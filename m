Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B567D625E0
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 03:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3126B0099; Wed, 21 Jan 2026 22:51:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0603E6B00C9; Wed, 21 Jan 2026 22:51:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A436B00CA; Wed, 21 Jan 2026 22:51:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D6A146B00C8
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:51:08 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A620B1B0913
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:51:08 +0000 (UTC)
X-FDA: 84358224216.27.3BCA301
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2A3D9180005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:51:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YgqbA0JT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VU7P8Bdb;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769053865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1bIzV2Irx3QMPzUOzWAgGO/HxC9PDNnBNK4/C6+zW4E=;
	b=3yUka3Ddq1cCxAwJpQfqKBeL0ipS/IPZeGvHOfMWt0LsDIOGSQ26XMAINjHoxmGlvDwFji
	sSyyLb89u7Dp/OJTyKEh3HoXqhSzKCXV/8clcK5cOp8SUpxZeWyfvJQb7xibIr2Vqy9cpe
	3KqjKFo1U3PHOwvgHne4MQ1yVw1y/gc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YgqbA0JT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VU7P8Bdb;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769053865; a=rsa-sha256;
	cv=pass;
	b=s3I1AKQOR1ghnsjEy2UbV/hx5HOtKzfjQYUspdBQShliYZpK3sbzOSsATlNrBYwjEjb5Ps
	27yuD4UOaZY8NpLcwBGJ+nhPqVYtrLSMDd2kTV2uR6QCm624p7cn7SBdqn7dQzmbVLg/Fw
	ZLWVAxGxUiXPVu6d8K3w3FzusqUmE3U=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LMachw3028859;
	Thu, 22 Jan 2026 03:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1bIzV2Irx3QMPzUOzW
	AgGO/HxC9PDNnBNK4/C6+zW4E=; b=YgqbA0JTq7zkyCiOddkCZfkvViv2FKvgjS
	7w3HtRekE0CgMuPtILMa1++mXUhIy5QNvPVRwM6r2c7ivB9qADyEnxcKeC4k3h4i
	kKHwyYZYfectIb1sZWgmc4clH42kM7kMKOG0GGMn69QuA9EnAOjDvhwaz57sl+uV
	vqknbqk7FjPDThHucVSTfR+hJt4UyeXBuogL9O6lugUO8AuWSxy7Qpnqiyl1vYw5
	TE+YhTtR8r+WdSgXO/O8FafbgTPgoEayZ+tLzmPFYquYyfUAWjT2n9UWRGzN8AU5
	2inoaCmPubGdSSN7zQobzzteCGuaQiv7UfFoWor4IeVpNeiopqYQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10vy46g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 03:50:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60M3IcbC039561;
	Thu, 22 Jan 2026 03:50:56 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011033.outbound.protection.outlook.com [52.101.52.33])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vc7pnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 03:50:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uks6MVwuV5n9eWUbsRMW443lPm0BYjDwzsAQmEDZsPG0T0UHSNZLCsjF40IK3NrBmkf7kgyX/xVT4aGMQb8I94gXPJvfcnBdA7LyhKSO0Exs2KMvBkSK8UzBpp77hKUgKntFOcD2NH7KkU9GSfX75bZWuoGZCNuX0AzhnugFfKf4fozHzzNCPnHPXvnJ9PCuP5UR7eDtnOySE2sq92/eGl5eo5ibk6FLFz4JQrZM2a0BPkYdHm6PX7LYuDMgMGxKOJ2pj5PkSRCnje+1VxZB7T0lQHORP0HUJH0+dl+JG9NtNAZ5l6ZBFbvIMn1nAusptbi9sE6d7dH4scCljPBr1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1bIzV2Irx3QMPzUOzWAgGO/HxC9PDNnBNK4/C6+zW4E=;
 b=rF2cQ200hyyoMgD18HNNLAulonmNDxI25v/VJ0/JgkrKtyYX8b4+4t30CbS7gOsjoSAEWn9x8BBY/W6hAB46J1U+d9mqUQBvs/Q4EDqH8DnwHn3bBLmDe4fXlFsOY46XoHqDmcIG1Olx0HQL9NX9elJfS3Qumvz6lWnHn4ZnQ6htQEaB5UYM6piiC+r6SF0ttrjP+03sP49R60980ioYEGfpfqRdZisCD1s/8nPB0JjmSkRoKzrfnmg6pmde2S1FeJ0THXZknpP0IWlF2ObWf21O34WV6salONHtAkITcybiAqBV27rrly/Em/mb28c5wi6muPhXTVJJqHPf81YkBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1bIzV2Irx3QMPzUOzWAgGO/HxC9PDNnBNK4/C6+zW4E=;
 b=VU7P8BdbV2LOQweVpLKivEAQqdyP0/aKdYcCQ00hy0MDvZKYO5W6WfXTcWLCXVPnK7tYFCJvDUI7b9ukQl63ChdyzZOuGht7hvdIBolFxoDeG7tLMXmhbARdpq7UY9GbUvcbnBT7USRnWDUiEyoa88qfjIxvnEcGOGvAnp8PO40=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 LV3PR10MB8153.namprd10.prod.outlook.com (2603:10b6:408:287::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 03:50:51 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d%5]) with mapi id 15.20.9542.008; Thu, 22 Jan 2026
 03:50:51 +0000
Date: Thu, 22 Jan 2026 12:50:38 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 16/21] slab: remove unused PREEMPT_RT specific macros
Message-ID: <aXGejjS93L5fALig@hyeyoo>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-16-5595cb000772@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-16-5595cb000772@suse.cz>
X-ClientProxiedBy: SE2P216CA0038.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:116::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|LV3PR10MB8153:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c36bd4c-5142-4190-c7ad-08de59696f60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4CIXDDKJvq9Ad7XoYK/bZZ/8J8LzVtFxqq0I/fvswxHfnsLafL8uuVtOdtcb?=
 =?us-ascii?Q?oL5xGdzQyzCJX/U32B5maNbf/N6DslyRcRSlSE0OgJAxx0lU4WLmo+HKJo56?=
 =?us-ascii?Q?VWIK/gaAJKDcXYegazNugsyA0DuBQtR34Q4bov72R/WwW5YoeAW7iiJV0klx?=
 =?us-ascii?Q?59u3JVTDgISV9zIAJETWUJSnUBqy1oRuGn8MelNooWtcoBHduy/9rHGjjiiy?=
 =?us-ascii?Q?x+DcQ4NkAFcm8J/tvXUb4UVcksXqiSLGjgC7mvUhwsNocCoxMSawBP7EA7tn?=
 =?us-ascii?Q?RXMajVDdZ5wlSVl2KZjVH/ylMv9NyTEAZuJxBo1R9bfKDNcvRxrDd7qs9pT8?=
 =?us-ascii?Q?SNx7NR85lvqM/LsFUDUd6ifaQuwSgHaLWGklxUVVVvp5lOQ3BGqIeW1kNv2N?=
 =?us-ascii?Q?snPBiOxRH6sRhAJnsNR4YXv4y+NcCiNaPfrNzTkW81HUGx0lfQj1RPlM+amj?=
 =?us-ascii?Q?81pLOCr7ZBDBefDdjd8TCwBWZYo6zmiUvpIXDXRUcUId6KtJ0TtkemN4wUJ2?=
 =?us-ascii?Q?b/ZiNWZIjVz1om11z8vndzvKlfMwm2alTyLGoDOlU3PZ84GbC3/+8Q0a8EqY?=
 =?us-ascii?Q?lsuRXB5j1unDhWSTdXBS+KxBqkryTR7nifKRqGnE8n60a4JUBx7xgOmMzC/y?=
 =?us-ascii?Q?lVlu8+h7YUKd66NVhNc84U7MKvZ8Mnb1a/qtq/OiIuymNYwz4oE67eaBaBmG?=
 =?us-ascii?Q?TRyflkqmKpsV3CVlu9iVKGQ4pWl4FUOBGBtWM7IO3ELxw8j77AJL3CfQ0p9y?=
 =?us-ascii?Q?Fkrf4ewxGYFZGZJEf78Z0b522Fln05rsoUaOrL9lpnHJ14hAQPbddNWNBSis?=
 =?us-ascii?Q?30SZhiyeLqTX+ffZtRexG5znDh2b9jqavxAfAvg6oL5lfBr2jYX7vJjxL145?=
 =?us-ascii?Q?t8wwxYV1on01BXCojXQGPw1JhO9HEjrRSMqKUaj1CCGV5Ml8O5ZpeSoWhMZ3?=
 =?us-ascii?Q?71R0oChUfaZRur8dgwCaREFHwbBAGvdyFHwKF+yrAZqsXGbDnoicLwO/gXsO?=
 =?us-ascii?Q?pwCUWbADrbCDF86AuMkSQ5K8J68tfW7Xp1UKyeCtUFuTO7RN5gzhyrtU7lhn?=
 =?us-ascii?Q?o6vuD3A0PvvDEN/nxdeQ5pG8xC48o8vBfCc350jnJU1whUGsu7ixH/IkkEqW?=
 =?us-ascii?Q?XkX4Ms2M7035d6+M37w+hr0aJijmfMRAJTrkniVskusT+rKi3M9VN/W7ENWF?=
 =?us-ascii?Q?v8PVd/9fMY5n33GPjtQKwaBvv0TCUFpNYCBHz8+aVgLGswL73xNQ6mvJakgn?=
 =?us-ascii?Q?aUwniRRh0y+WUxGDbhvwmTlhTAYcJMIY7HkN1wriFg1zlSZoOraA98lP14ms?=
 =?us-ascii?Q?2WPpDOiErR1DHuSw6Ew0mtdMy71lTA6wp3ko3mnuJracPYY8jWIzJEX4poTD?=
 =?us-ascii?Q?l6OnRCWDz/TY64bEiztTa5Db3k2k+kDWUm34hNqZqF12gUDNTbSQCKqjz7/8?=
 =?us-ascii?Q?gZaK4Cd37vMEwQ7xyTVe63TDqXgxSqBy1JLvQLedfPbyvA9lZMG5wkog0ybC?=
 =?us-ascii?Q?jq15hvc2dn44O8UBfNK+bQTZyV+4IrV+XslcbUvQDCAfw29CnRTXp4HXdpx6?=
 =?us-ascii?Q?qmlNW4BmV0qiD6Vd0CQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LnBkLqQPDQpCYPivzOS5j2C7YlbgtEL73W9lTf6xh8dsGFiNFBUVK2beubr7?=
 =?us-ascii?Q?dD+nFBi+C0q/TpodimOLCVfa2Tl+yh9cJp5i2v15yLLy2I9URduJVjkHbzzQ?=
 =?us-ascii?Q?s7LJcc6NX8rwskUHso40s+FAkmYDBsMSng+udH0RaDSXxQId0GeunDhQHW0u?=
 =?us-ascii?Q?aKw079pqJvia6GaQ5Z5TWPGOFfkPplmwCAoHFBB2gulLxkiF7x41UNTFaNR9?=
 =?us-ascii?Q?eun8gfzVUyi7LK2ZuQomnUmwEmKoXc4mQxeC1KJnvJpW+8n17kMjJREpfxTu?=
 =?us-ascii?Q?NsDl7k4IqamyXlPOJ9kFqpi7Cv0kOVWTVUJ9mJFLwbPf0S3deTD9QuQv0WWS?=
 =?us-ascii?Q?zDDJ1dzZwXhiRAhS9L575COiUIy2eD6prfN+1I/iCJJs5614RBuuyxdaECsv?=
 =?us-ascii?Q?tA3N51jjWp9uUP4OiZ5Im7iyZbUu6E4nlh0oi4+VkZCjpGENnRiuKJH38nFR?=
 =?us-ascii?Q?ZvBunPAqC5LqoXRt8HnKPniti8Gx56EM8Sg2h2M4gxU39oRsXb0SdUdCmtsu?=
 =?us-ascii?Q?7ztIUwhYcy0Y0iOWN4kwk2XM9SHixec6k5Hr1Q9YXTTtU5kN/QRIVz5B55Tx?=
 =?us-ascii?Q?qukts86x4atJG/IELrqU1USstzO8HbxE45IZwCbJFHjgn40AkbrkXoeVKIp/?=
 =?us-ascii?Q?9VqkXITpCISLNycbquXpB+YTIuyL3XUE2YceT15wDGb2Dob4T5peJv32kDp0?=
 =?us-ascii?Q?at3ZvmwjE2VnEXdy9Z5G3iK0FRVwvEf5YVjvq8sArc1UF7DQ+f+SCIgoiOJw?=
 =?us-ascii?Q?tD3sa6nZGrDAQECorSK4siC9JgY9Aztd9RO4iVgPP9wk+DQEhnOiepPc619s?=
 =?us-ascii?Q?HEykc3TeT7Ykj/9gOS9SSPF9bvF723VH4I3dhj5e/Ct3RiRqPlsmRfLtKdyM?=
 =?us-ascii?Q?el4nP0dQ8/YXjAz3zJteeH5IT6W1mNZkB5gOGLUm0eeUNwGKJaxwZgjLuX7r?=
 =?us-ascii?Q?n89rDt/xxIYX62+ougi9QW0+KvT2vhagj0mD5kmdz6O80Dk3pc9YXOpPAbiy?=
 =?us-ascii?Q?ghTqQaH6IybrZZmw1Vmx1u9NP4FxoAOoMhFCfkqnNwd9T/+dUxLmP1gjnSAj?=
 =?us-ascii?Q?ARbqD3Gxh5D4GPGvfR3jTdvwstL+50AeM2HhOYatSj8tg7CMMg4YJFosM4Z4?=
 =?us-ascii?Q?3HpI5BJX+TTjVMJxblHFh2CPOQgXr/pmsSIfV1aDimg4XUjv/k1V+JWLC1au?=
 =?us-ascii?Q?0g7yIgmHr0PxXpCHb7NlGCnbj8JjHPOwIprcP6AMfB1Q3Mw57FRFlNsIm753?=
 =?us-ascii?Q?//r5aAH/0QubIF6PXp4RI8fC50g+3QAEnNvPVEsGBNrlS0brdRxqwByDDpco?=
 =?us-ascii?Q?6tyIzVSuNKHysSR9NhHk/erJsorT96UZcJv17dAzy40f9rYMjaSHiYN7oXMp?=
 =?us-ascii?Q?A8ubXwpxQI+cRSuXNTSIflGclbs1w7wI19pvJiYtcn0tXt89rb/EnNYf4X6a?=
 =?us-ascii?Q?5ywyo9Co8iBxSP1rRpyYWkhSVqjBRaPU4IMwaCcck9CA/jz+I3RWT4asqT74?=
 =?us-ascii?Q?mLYCyvSIyWo5deBIYJnvglzV0POviHudx+yoD1UxbZBUq3Yv1lHWwBX05Dw8?=
 =?us-ascii?Q?r4VduJ/9AlqjGMnsLMb8tta+mARCfJC33jZ1pWMfFLQOxgX6x0BBNE+jo7W2?=
 =?us-ascii?Q?7mi3JjtqzdcLcZjbbYZxndGjilBIYaWrvMmFmpvCzaG7UNXL8E1kvcEPXNLy?=
 =?us-ascii?Q?eJwVtG8N2S/eM2ozw+/nJ2Tr9wwYBil3zXNPjv4c8BGd6/+zvEIgcmCL3L7/?=
 =?us-ascii?Q?j1N4Q11PRQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4y4+Mj+UrAx+K5i8Ej4okXtpLTWGrAJUCRXOjLK3djZvY7wDeJ7D6Rkp8aqdP2CeeXbKFyZIADex41BKBxt1B60/wThRTxuszQ+JhpIIofpdtF/Z+DaAw2EjRC0ZhLAa2Y9byEUrnPqVHPcplNVMhxtRwOe0HZ3Zt/vtDyI6z6v9YxKLZRzb6jBfCVh2SU8JfZxvq2aIEL0ztDOn87rcwaSQq6kAHV4UMkHlcP7qyIVQrpWvHmUPwhmZXoao7N+hEigFjwkhxk50Hek0PcvrYviVFFcPbHF7n7EteWz6FJOMWriz/99Khh2QXEBSe1rLGVjmOdUFbpr9hZZK02KEOTb++LsAW6s0oMf6BXW0Xda7TsVdqD/fOjL1P/eTakZ9jf0iGay/hb1bIO9iS73EK3Y82AqXsvHwjAsVMbFn5YH7yk7aBgZE/ZWLj6FtTgqb97rovIx4noa2stOocrex3dnHTyWUZvX7mL4q6ROFWJBFonc3BlZUuhYxgPLdMUosf2EFHEWeVVWKT48J/f21d+wYbaOpaB9qSor7u28nu2R8vx2z+9+hVH06xXxBjfZZ5Go/fKf7MiXLni6vu0FlnlDq4infWMVF8zhUeN6W0x8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c36bd4c-5142-4190-c7ad-08de59696f60
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 03:50:51.6773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WIIjnKJiPUB/lwTmzuIgN2PstgCg9LNKsO7cwAeKQfnSFR185sRrCOLSsdy3cihiYqoWD3S0CFfkCysCo8DWUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8153
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_04,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxlogscore=860 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220026
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=69719ea0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=jXcXkP6qC-kw7IvTVz0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: C3-h2FYP3YCHfZ7hnx1OZHVlinXFRkNE
X-Proofpoint-ORIG-GUID: C3-h2FYP3YCHfZ7hnx1OZHVlinXFRkNE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDAyNiBTYWx0ZWRfX7er7nbKDzhPp
 YnlUG/JzNfDe8G+GHeaKGLe16F7q/lUmU8JXd+rMxFbZC1d3EnxQv2dv8PKtlN97uT4E3O/nt5J
 fQkac0octpADTsjW64fw21ljDNc0tEIoTnwueYaaSIhNNTpyi4O98LSmqStfO7Ks3knsMsH9PIj
 z3Xhpy3Ox84/MNIbZb2QKk8vLiCkba/qYLyOcmLKjQ8DzRPl1hSnjFl7blB4iis4BZ7MQF26raA
 mdwYmSR9IeQndnN8Ve9tEzIfP4AguVSK1PINCc4CAOjN32hCifv7iOKfm6duN+mLrUmc2Wahl+u
 n2OX3YKyRH6JkcFwDS/Sc7q7suMRAsBbEEGLBlr2pBFQmwOyy/aAULedsy9fOsNGMC7uI0/aEtU
 jQCxQeDOtKD2MaORqOVJEr3zrkuVK5Asffdw6jM3iv9pTfTQdZyxUqjIJKXWvWL0eOge1U+3zni
 ThAB6XcwXX/s1X9rH+g==
X-Rspamd-Server: rspam11
X-Stat-Signature: gjw1mjknnmja545mx6npdukfhqfcxcmu
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A3D9180005
X-HE-Tag: 1769053864-78294
X-HE-Meta: U2FsdGVkX1/Dn15CgKc1Ez4vj/BaY8aeyBDwFlAw2tN9YpFinj1AFGQ0lSrrYuATxY94bWr2kVp+Drrr02cAbGkZukkDVGgd0LjzVMyEWDAA2NcWppCpll1krreOaDQKCaSKyVTQWi8YO+Nyq10j1op8y23FmZsw7HfZNuGoEiH4YiGKtwxtzwUvEDTCJGmyEgqLyuyuOYX3GdG9Yw/SFB8JaSgFcoxo73tJiR/NcBBpsHH6c4i1u6sAxbq6e51NJa+JD8sxSe9pLM1A1rcr5g0GyTZZ7N/OY2mKABnFfMiJXCWLJZ3koNwpG96mzAMRQBJi4p44WjuuFonI2sD6uEVo7uF4n6n20/c+qZB685XNg2tLWXU0fWuflckxwoV8AFFdVsaAV7qL8iUloQzQo/D/j0hfMqLcXJEjKD+JDnpvDr4uE3ooqOv5pk3sbNgEyYl2xFmTRPP41fNSWBNxBn6ws5wvb5cz/e+bsq37Fa/sL5JSHZTLhfutfqDBxJN0CPY+ER6yzEnOUpsGRUcSX11XLvyCidopkUFIsJSTBVzG+fEBa8VJ1dx3YlF/50EfQUigGmv0QGjHkrNhkMcBN2+plJp4Wu7HZTHZ0QqOVBlKQEyOHt5uAv6CwjO5xKsbOSnsUqTfyQFIA914RPJcssXqLxOEAXnBdbagYJIOKni50/CQbRXu9Y4trNpR8YgZqia28Z+V9DPWGcMfqRoCpoi43Fohf/yX1Gtnqh7PqMdX12JczXhTad0HYE/bCyvDX0PD5GXlxfhGsN+5mC9NyhveoJcbVClDeZC1M12FDH7C9KKy7tJQT5GEy0pvpTMsiciZrf5hK26ucdPQsMWLDKFQ1VQlsnH9ahTRp1iKXxzH4KtxEK/XXNbT5aXUMecZRv5hk2qfDgxQcf5ez6UdWwIn48c/dBHMrFaMbPfrNZg0LRf/oavp3s0rYb6heckbKOkQ8x9Toa7I3moZSJC
 45n5A0Ma
 I+ewuyilrFnVWuxYd7SBoCp3Kxnbsnil5V6aU8PlZBbk78c2md5KiG6WM+mXy8W/C/QokstaJHfS+Jp9sDN98dfVDqN1qdp3u+FJQ42nOPiT02eAaXOmthEv6NwaBAEJ+tkMm6UBJtstM85/l+IE6kAFkNiHG3V09ONwqOsWyaK8m4Ro8TrG3LdpmQF/vl+yCRNYeSnpchg258VpBUU3cZ77l3/HU7cMdX5fMv8jHmaDQ9knk3WwaoaPLaY6wAstoe+9VC7BK2Y/V3Q4KTRuzOxB2Q9PaVhRGA9cDmXxudSAIb6YKAi4qsoQxzlPqaT8rhb8DGXMjti3qTBo5K10vqjQkExG382kr3SrUIIvgPNTwGSCbkvrSl0prLyYvIJ4NYoG0D1d7reU3LmGQAv2r+tiIPE0qzX7EOG1+WP9vfwiYeIzGb3YW4TpTBH0VoeheczDvG9sddGRxohF7p8XaAMXGopOMY55+9AWRfKsUGcvDHsmMhTGkwvLkjTz/P6lfmRSlOtWJFDmk+lmPhS09zNttwsQxlYSr6yrEiCVBsdGrq69GhGVKEZOJ8TWpyI9rQM2QRK9Lk8lhk69lUTe/UEz4sIjW+md6ZvhpoWhHoXPsS+7XibZrfptmnLoQ4RMfSlXKdx3Dnk8TYgtv6xzMAxAnj/4FZShT2h5NZN5BA6BL6AF3+pj6nG4xv1A31bsIHiHMcqu0g43hXvjPBzUiIPuT3T01/BfD3o8Q6gFVtCeLNn4hrsOftAfzeYFG47cYY6eu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:36PM +0100, Vlastimil Babka wrote:
> The macros slub_get_cpu_ptr()/slub_put_cpu_ptr() are now unused, remove
> them. USE_LOCKLESS_FAST_PATH() has lost its true meaning with the code
> being removed. The only remaining usage is in fact testing whether we
> can assert irqs disabled, because spin_lock_irqsave() only does that on
> !RT. Test for CONFIG_PREEMPT_RT instead.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

