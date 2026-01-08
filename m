Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7055BD1D486
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 18:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CAFE6B0095; Thu,  8 Jan 2026 13:51:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978A36B0099; Thu,  8 Jan 2026 13:51:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823B66B009B; Thu,  8 Jan 2026 13:51:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4856B0095
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:51:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D115C162E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:51:31 +0000 (UTC)
X-FDA: 84309689982.26.E4465B0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id A940540002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:51:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SGpRHKn+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZCpB8lr6;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767898287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=85tu9lNp55wwM3ZQxHSipYQIGOxcOlhKGZC/930Jx0E=;
	b=TQ0UewrIR3yKIBU+z4DEoVrjl5TJiFHsIMds2BF1jiyzUJm7YSigagVa8xXJUj+bYNHmdi
	6s5W9zA2Ux7foWaR+nR9kJzfqD+VNNF6A18q/uMLKsXjgKUG8Mo/Ru5vC+3ybtH3xZONhs
	Poqg3mx1dTrkjDyadVoz86uC9N7Iljc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SGpRHKn+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZCpB8lr6;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767898287; a=rsa-sha256;
	cv=pass;
	b=BV/gLEQiwWq5EuQFwtZDsVW6ZypAFTF9ZALuft/Sq5N4Vmo/bIrky7USBnkulzgD+2HLxs
	TMwZYi0wHmG22bRyMe8y070zi/EKYllnmBRK0XrJXayOxomRZh0qrg081puIjOOndZsij3
	w3SLHIoxrcvFuMj30vlkONn/WQi/tZo=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608InmPP943630;
	Thu, 8 Jan 2026 18:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=85tu9lNp55wwM3ZQxH
	SipYQIGOxcOlhKGZC/930Jx0E=; b=SGpRHKn+hf+zmg0u/gIc+Q3iLxu5AZMiOz
	DBEJwdm1g1SUINDYNu67j00B17e8yP+bS5lKT4EEL18e2rjLncC5L0FXJOYPq7e9
	arUK32kkPTjbGRkrII8HPQm8JD/4yJDmSfxM5harpf058EkpbvLGXGrPdNl5lHka
	7rVLRIfeoFu9RRasZ2pkd4Cn+sDXWG060xdw2j+UwlleY/FSrBjy6IaE5hvJYtgb
	T4MqXif4fxgmx/V7IwFJcoQ7KWJfE4RZoGfQ4SV3mz2L08MOEUo0P+ewemYIoMiw
	sv3xa2eyZ5te5Seo7mruNg2eYIb8hkchhGeAHCb3NwyYOJzXxeHw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjj6vr02p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 18:51:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608HjIW4021775;
	Thu, 8 Jan 2026 18:51:21 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013004.outbound.protection.outlook.com [40.93.201.4])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besjb6bqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 18:51:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a6EVnwekwwWtxVpyiopPG/vG66jMfaDHFRpkjS/DcU+IIWJFtJsGzGaDHlcnHOB2APytCYRm03qlkYmdFL9p+NPvHmPljYFF9u0TgGBZS1rtqus4jQw5E3R/fEaiK9RsHqpXhfZotHHTdNKN/Vk0HFZUtUa0sDeQsuVTzRv8KICtk+dP/M11nQ3W1xwAMQt8oWImeU89J2J3kOYru7KfhTWykEDBtubp/UgT73sKz6Pz/cfFFZfY7z4LyqneJQvX8D23fxpMECH00p529YOW/V4fgcpD9BHrVlvHlV3tiiQ1aLXJ3SBEkxMxcJTL81fo22VwBpXOLLB1iK+yAHOGqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85tu9lNp55wwM3ZQxHSipYQIGOxcOlhKGZC/930Jx0E=;
 b=Q6DglkeZg3S9AN1oCbqbrO2iQ497cVjcha5eZOCAwE01VvrDvdX6bPRi9HKbVUTu3bfwXx9RFIQBufImDL7m/Cq7ukKJT9ddbDJkxt0AS9no4V6S2BkGcvU1RoGLhDzQTWBKClUrB0ac6r0kCoI0lCyPuMAuY4JkyOBYuURQpKUYKxQ7xc5oTP8PId8QwuO0E21qiGMNpIN26g2G5HBUiv9tZGuYSJJThNJ3WqhXtkIJwYp8rttBkY3xpwqbupJKHLaBZLQ9vbQWTe4CQw5+DF6Yr0tQyyK2NvFe54rzN3Od2tyN0oEXxOeWdENsA4yYW+hby95W2jVvgWA15/KlCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85tu9lNp55wwM3ZQxHSipYQIGOxcOlhKGZC/930Jx0E=;
 b=ZCpB8lr6AQw+LdJ0N2AM7OIRtJK646f0Qd1d+WXwKh+yGvtWFca5Aab5FehGir51Z0hgj7RtM847Xq7enbsI29n18dcqJw00ZCJfunoZJyK+pHHzjZuVjgk2npw9DTVxsHQPtZ4iapSGEH5Rhk27A3uM8oRkJ5HmBAr6QeqoLUs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4426.namprd10.prod.outlook.com (2603:10b6:806:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Thu, 8 Jan
 2026 18:51:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 18:51:17 +0000
Date: Thu, 8 Jan 2026 18:51:20 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/8] mm/rmap: allocate anon_vma_chain objects unlocked
 when possible
Message-ID: <f0fe73fd-cb23-4670-b5ba-c716edfd115f@lucifer.local>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <ff2651a4d5b73c7cc8160c55d46d6e5385996e62.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff2651a4d5b73c7cc8160c55d46d6e5385996e62.1767711638.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO4P265CA0246.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4426:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fe854b7-4dbe-4ac1-041d-08de4ee6e7c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vb6FJ3Lb/sFXNhI0G1GxRL+F4FGRA2dTs17lFokyT62ZWvbXpkaVMziEG/qe?=
 =?us-ascii?Q?HuDleenbfPq+iLEqJ1R6sTig9IhoGV7aI+KY0Az1RkiyuYQj44yQjayId6kN?=
 =?us-ascii?Q?MobtAteW2SRP64zMi46xY9OM6BdvRvQ7THCKUFBmnoh8ZJ/BBdVZ2g9kgX8c?=
 =?us-ascii?Q?0gSEZEpPUxHSUD9Xta6DZaZhRDYa0a4l3hwA/XtTqtKkk11M2RUbY8RMEbdH?=
 =?us-ascii?Q?cbf9b1c8P/gtNbXah1Z8NAEXfhD1WIlfhvidZjTh9M13yhTkqF5P4AO4N+im?=
 =?us-ascii?Q?Cq5x88bLf3qvk6Aq97/CMvQEiYck0l9E9HnkkwZsYSKlA55ng6VbdyqVxWNT?=
 =?us-ascii?Q?qoOkEvQf+p+vLSdgm2xVig1zMnGGtHHr5moCkcJSHPDJ5YLdXyS3s4D7GXpd?=
 =?us-ascii?Q?nTiIBROyeczmIbp5BxPc1MsVB2YwkuB57YCuL3gaYCRDZNGxUlY2lVDvCIjx?=
 =?us-ascii?Q?73WFKS1Bi199uOcYuF/m52hr6KXmaemhVx/WyUZES5yid73/28WUt2cN8og+?=
 =?us-ascii?Q?/Vv+Eruob5xD83DWogPEvr5aqQPFHJyAXfiR53LE8srLE7Fk4AdP1E1R4p+L?=
 =?us-ascii?Q?FWft6SzZT4LZlBDPHPq/RnQjPCdNRJF6j0y+1LUOi987pDGVC/f6LaqNNlnn?=
 =?us-ascii?Q?yc6iXSl4JfgAUI3yX8CKDjLzIHwXCjdJjRivlLHOnHN4BJA+OD4aGAZ1glkc?=
 =?us-ascii?Q?77ng7x4hbJHJdVaE8Ba/mZBxbkXBr97JkgNyeA3MX8llzhl9J1PVsA1v2FH2?=
 =?us-ascii?Q?FliZcfNJkNo0ObCLU0GO52eoyiJeNLNmbQEksiy0AKFCMTK7qgzlt1pb1rua?=
 =?us-ascii?Q?PkdkyU+xKa9kIs2Zo8NrSjA0g9zkckiAgYHjNDHUjR6tKkZ4LwR2kwvHaImw?=
 =?us-ascii?Q?Ng50DxYDzaWE6aX8IaUf6BonaafCU6r5Zee0MOlCuA5Fnt38CQXbTAgVpC7v?=
 =?us-ascii?Q?cQGyTX6X13S+i/zo82N7Z1eS16RfVzU3n5IO3YJBSixpyQhJ+wscbLZf5wyl?=
 =?us-ascii?Q?FNMLj5ASX8hqJcoAjOxnwCf5RLPryItU+9L6q7fzfAcb5L3l9bH9Nws5u2IU?=
 =?us-ascii?Q?Y+PAo9ki/+9TPEQf8q3tKamhW1oSx/P3C3I/NafO4IPxcwBljnKdMtIUk+v8?=
 =?us-ascii?Q?uQ2taX0Nu2gq5RNFtYLIeeWtE2N7YwVFt+/tYT6Hf0FOoCUoLVbrMBoHLCPl?=
 =?us-ascii?Q?K7u+74l8PMffDdtIJBwahefsjAwjW6K4chNaQZUvpnzSE9Axgyx8dPQfRvHx?=
 =?us-ascii?Q?07PkSFArGZZaTV/wQ5CQfnH4GJBXXwpWrQswmoHUNG/zU6gYCPew9JK5ovVZ?=
 =?us-ascii?Q?hRKb/jN76VZjd1cljZEhMoh9FILZCvlNYzdj6oqnQaScVxr6CfUsL5oYaWNh?=
 =?us-ascii?Q?vTdwkiWYvJUXQkijycnyDMz2D0JRpVQbUJkBfRB8Znecz2P698gBKjWqTDOy?=
 =?us-ascii?Q?IRe25PQHArcG2IWg8oAaDSwSfb5C3CwZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E8YSi62VehnrHbXDhyiaYFjgB73IRefdNZODSJq/PFsz5xZpNvZRU2bBFhw/?=
 =?us-ascii?Q?ZxcodIEM5TSULqGY+sq6w/ZW+4EqKAlgQ4zQz9SyiRbXf+BqkcAa3a0EzFNr?=
 =?us-ascii?Q?RKfea99A5gYHuYgKmIgTldfihAF7eM3Nb6gddkGPYZuuDmeiffMxc9ey2vtF?=
 =?us-ascii?Q?x3aUU3WNNBesH8K0W+TmRg2G3m5amWGoc6R00AdxdL67yQpoogJv9JPzidBD?=
 =?us-ascii?Q?qB2oChyNeahBn8HAzsposZJW7vzZ+9acsn1lMmYhtk4E3l+6mcUxcDM5mic6?=
 =?us-ascii?Q?KmQE4vonD+U6Pc3yGJ/pURbKDanRoewtbzPLmGWgtkvEWjPQ10YD86umyMw8?=
 =?us-ascii?Q?Sv3iHsBavrwCbV0I+ljylGoKv7rKZgcmayBHidXsgj6UoQEISZBIt0mrBOeN?=
 =?us-ascii?Q?VrCR1HS1mc7TUG9rf4OaY6iOx4GZFVocZ8VBY1gISONVIcyvnl3GFiQ36ZwM?=
 =?us-ascii?Q?x3nuEPfzwYU3JLrQzg1g5zWlOOZRLZYREB0SRYUoFgbiqgKokN0uIXA4x5S/?=
 =?us-ascii?Q?SVs7z7RbJVs+oYuiYFKtMkYlauyCLJmLN3op7Unv1T47tFYfAS0ecYarYxu8?=
 =?us-ascii?Q?EyAzijFroyxvjxODwdhzjJadKtSts1NqhNP4DaHVcoUx0scPbrriKR9hruOV?=
 =?us-ascii?Q?PUsq1VAIJkLlyE8JknsY0lFZc1ALsEJAAsgTYGnxrn5Atf4wGF7hL2dWGIMc?=
 =?us-ascii?Q?hkABAI1937wn7EBCcQl7HfRgJOPxvKkdvem7v63+mme5wLjQCkkX7CYOjt2u?=
 =?us-ascii?Q?tOaF230QW6QHpDAqBZDpnavXoNC774sV+xJhmZoQqPo5TzuGo4Affx+ije76?=
 =?us-ascii?Q?h5KlfzEPLc0oHp2u6ZN+6uTd9v/hBBPQEOkP7MLQyFm3PmYrY2gQ3J3H9mfc?=
 =?us-ascii?Q?Ifxe7Z+Jy/Liz9an40DooFxT9UMkip4gT3r5fkT031RLTo5K8nccKvigR3r0?=
 =?us-ascii?Q?1AMFvE0/Zdwf8bUsLBi8FeO8syBP0jq96BJrbBWJnyyPSPs+oxs1WbolgIfb?=
 =?us-ascii?Q?Vi5rXh72mw4vmwNsEBKiaM35lyWdSOmdwMjpwpQxDnuFKJp1+xuZXPoSuPkm?=
 =?us-ascii?Q?VXZqniZRLZnsh/iuKQ/IeUW1vmTETSftgUBHi1DnwPda8Lz3Evu32NMSSZPg?=
 =?us-ascii?Q?iN/SFrEQhlcUfs1tdpqRYR04hqUNdKKT/EztSguscXLgSjGYwXNQw63M2y5L?=
 =?us-ascii?Q?P0i9hVly2lb6HFpsWhjl5+T+FhHLImghYq9E1KUWnK3nNPHSXfFKguoq70gT?=
 =?us-ascii?Q?xmz9SymuopDKWfucmnjmmUJjCZKFJvUDY99ODUPMtAB5/43w3h6lUwsb4oyZ?=
 =?us-ascii?Q?MjQ4ObYZmmU0esgd0Bb1sXyV+MShYyNDeDHd73MCGbTK3vSYqP7Aqu/Bz+Ir?=
 =?us-ascii?Q?VFjViqYn3LdJx5576g63x5QI/EjG3hnUYLnFBjYCwyO7tL9QlK+83aAXAQWy?=
 =?us-ascii?Q?hqSRn5A5MagJBetNrutzDER2zF8RU5xXg2t52fegMx+hrLdSKolRyyZSWSFW?=
 =?us-ascii?Q?ocTmU2wZtvJTIcwb5iiQZ9xudJwhowGPpdTlELHOlbk7lF0X5CSJku4pODkX?=
 =?us-ascii?Q?uUmIhVZdrFo05S6uOiR/w1WVsjZNbRXS50WiF2dlokDTPEIZ2TrNoLxmfxsb?=
 =?us-ascii?Q?U62oRYxq9wVL1NKUzgM/gHmaCiH4tZbpLIufUou0Lw/lUms68q9/9tbskOTI?=
 =?us-ascii?Q?XFjsRx1z+cwv2K8AUtLu4rXSbPA/fVIJPwXCAIndlNnu16aQ+9M3RKq31Put?=
 =?us-ascii?Q?my9eGHQV57n77b93ZjlqmtDGVfcRugI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xB4ENAMWX5zCn9e/wXPx6VMSIG+Bt+ZjbxC/0lU03a29bO6UUaVBmgHIC2dHZhNVQceXtaCAgBLfySBTuX5iB8B90gaWpc1chCBiSIBFhxtEp6+ySYBqgS6tdL7D8gbTI8d59z2Pr+2aUpSotCTaGKOzxUz74WAGgfftlzyk1a+g1OkSq/5p8ttC8i7fc0hCdT+CxUrS04XjAq95s18cy/kXnSqb7VjHfq+Xlb5qOe1vTnMw80dHx2FqLqY8FUZfnkvsRVkJ2dmx7p3yP7Ce1oabVkc+6H+zvMhcF+oykH87/0sEgVKjtXhEEUlmTUx9cvo/YwAj6kfP8OR8JR2/1CCvVKusue2s9HsrNHiK1XlZhgxGy2ni5zrWEJlQuAax9cvKb8ObEgi09AjEb7fDLmnVjObpmDrbbhN04uo+tQAM0V/r8jkz1PBqPvjH+3a0EcGkv1MINVY9WSwLunPmDjhOsr7IaW8Yf+x6jJsO4fhfNExYuPYadPlzrnNlSGATOotawmRiWtV5G5g6VzqmNjG1iXiMTMtaU4vmDYTZ2bqi29YmuA0FUVYhhXKK+epWMxnTOCCBnd67zq6N9vNAoIImIQip/6ttJxTW+WLM8eY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fe854b7-4dbe-4ac1-041d-08de4ee6e7c9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 18:51:17.3986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a3B/B1l+P1H6IA/n3Zsjgy7ZFQKxQHCTh704oeEj8PMwobSv7wKRi8dOLxnMWWVmr7TJ2xJpX6BnSmxsnvGu+exKq3gkWj88qb8dd17KPZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4426
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080140
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDE0MCBTYWx0ZWRfXzqlE3oDQMD1m
 MzSTAb8qYdTAgvzEQ0e9l70MZs3fklfxDwLMFWV9ADfXJ6wkaNfWKl3TmPuE2LeJ3JTVqPzQ99R
 dx19nb4UO9TgEi3o6dMuMbOiDTYYlcH8dodYYGAvqCdP9hRANk5/bM3TAC7PqIrMTu/oiIyZfcz
 +LiMYHL1LTaPNPF9Z+inqVDObSXwM3LLjE3uJcQ91rSL0kL+3ikqDSPonJcgS2jQV8xLQ2mG0ix
 3R1fBKIFTPIEvPT9DjInf+HCK9fz67c0fvWmnQawSQWRyxsW5MgmxqXdppRTgpvnxd8Bkx5Lnku
 KFR1EywpXWoRx4AGqejaKD+IaFgyZfIA9YD/9zEVmNGytYwcxWswmWZUpju9TU6Gwao+bbBclPD
 lfqJndL5O8DzHUo5oq9GoOan/rrWHUZkECeWVajdficTZqb6PMngC8qJ4PtaVy0t8OwwK6NyzWM
 gAozoIS9XAco1zvQRFQ==
X-Authority-Analysis: v=2.4 cv=caPfb3DM c=1 sm=1 tr=0 ts=695ffcaa cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=BuijjQSSENxffrooEnEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: YwDEdTCGPcPB6YYX6VezvtZAqZS1WPmM
X-Proofpoint-ORIG-GUID: YwDEdTCGPcPB6YYX6VezvtZAqZS1WPmM
X-Rspamd-Queue-Id: A940540002
X-Stat-Signature: 4nchhr3z9qpqtj4yy4ztbkbxofjfy8zd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767898287-904721
X-HE-Meta: U2FsdGVkX18+cUYd+j18EIxF7bKxKGfZSs1mI6Qp2nVRtit85sixrPyeH4Wfg41PtXdfa57O7Mq1NvzKkHHYs4IlocjCClt7UU3HTQex0X6XrfFdh5KwQjCFD6RXTPgOptvhoxddgGi1JQ5QZ0q5t2SuyFMzd+ogdsby1O5Hm4NdCzZQVlwbtUSJ3U6QN7U14BLyB+gd9gQc4DPTFpLbbxSjrtYlZ33tIfXrBNZn2kGOObaadaYAdgb7KUtJZGjgPq2wKVlTlJOviGsTzKzTQAlBCS6ll+MYnLGfmtH2zjZmyKKUxHYJqnldd0ccPk0gg/7gD7iH7J1KDnlFouIp4YR/rEsP/dNUL8/BDx7RHyHYOvWsGV2pAREDaX9K06/2u2OKtT1/EiVfPDLzXihx5R0Yhgosl2ftVQl1n5X7eQQSlp4SaFLSXcJRleSI76H0sj+XNLVSZbwdDlmf4Jzq8ndUNNSyomWgqlN7jOc4KvH+y+czGF99+FV1VDebNdvC2pX3tJj3ECiQtw5Wbck+oYibYZWQnkQguF0hf24l7DTrkJLmAMTXBw7exKdI+XMLUJf1JanAPZrpyoH7vjsaY5QvuvuId5g8HehBjzsX+mJhR48S08kQYocbvpZetTOFqLfhvB5GNeSpkmktlph7OLlkzoCpPOxrFkDlCiP106w5pk6ROw3EXXUSXcdSHrvVlpKoqDv54GRjNO3gYFqAEkY7/Z1oAgLS8uVEwNt39e8MpOwNn1M8R5vPCVGxHCGCmMfHo4PV9iEZ2AjSrHJ8St5Qe72K8Mi2VlpYwZctI8FaupgsrLnst3CBvi0Fa/USqKjyzb0YqXB+r7GCUrQeOo5mKvFJdLUgIUIDmfsuxPM0CX6uc5qQfco//RZcEp8uW6YqoiBRnxhSzI1CX2tkFMp0KSK0GvNHUtiMfuMus/xKQRe/LKwTPCjlWE0F7pnA/5e41hI+16k6dcsjweg
 2gZsdvdC
 UsMvroeA7F+0ZVuSSyiIxN8zZ3R77HY+FnSCP/2ktJF3J0X4IhL3fzIUOzvkDe5uNF7Hb/9wZID0cylCvKfgugk/74+WzjEKvXvSNpWDOr02p4W3neiNMhyGhJVQKCIQO2b4AV522iLkJL2yvTa3I7mHTKsYHjhjipN4yXalzuhmnsZZ0l8B2zhxA0GLWBRcsqquw9c9iwNC7LePc0DeR5i14zq8qLdh525YgF3yGO+vYqvOUGPDIWNXqI6zegHelYdb723OO0HWtlkL3YlFvP01uVUlCX6zwTIap1p+i1qAISTTQs9L+VNyxm2hzXzJ7ZDoSaukSohmgMbYP0njwA/ZEYUH9UWt9Hi0oEmYTkLWIZK2jJPdmASzBcwSgsF3v0SBLjly73itx71iK5YixM8Vh2+HC9Wen8Aqipo0hIr5JJFknQSU0SjrmmhWYMhqHxWamP3P50jg7AQhEEjoOoiNPMP7zy3OVUcuWlJHGcqwtF/Ti6/6mfxtJ0rCVrZz+ij9gwPA2FcwXWChOiUznSKiWVpHz9sl8m5ZAECixAX2V4Wtf00YBN/fROimcEExckbPqAQGICIw67Yvxc5wbkwa19FLNnTKVD/34TaGy8aul3j+jstA6+ncbSQiKd3gtxhPWIbx+CxZLHXIWeW+Ru2/kKXHthIHCaphU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Please apply the below fix-patch which addresses the issue raised by Suren
regarding the veracity of a comment around locks held.

Thanks, Lorenzo

----8<----
From dace24fb96c7fbf812e6cca2fb4aa0b6489ce8e3 Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Thu, 8 Jan 2026 18:49:07 +0000
Subject: [PATCH] fix comment

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/rmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 8f4393546bce..576c7cde6464 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -297,8 +297,10 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 	* are not updating the anon_vma rbtree nor are we changing
 	* anon_vma statistics.
 	*
-	* We hold the exclusive mmap write lock so there's no possibliity of
-	* the unlinked AVC's being observed yet.
+	* Either src, dst have the same mm for which we hold an exclusive mmap
+	* write lock, or we are forking and we hold it on src->vm_mm and dst is
+	* not yet accessible to other threads so there's no possibliity of the
+	* unlinked AVC's being observed yet.
 	*/
 	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
 		avc = anon_vma_chain_alloc(GFP_KERNEL);
--
2.52.0

