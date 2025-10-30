Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C1FACCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 08:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5CE98E0134; Thu, 30 Oct 2025 04:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34048E0112; Thu, 30 Oct 2025 04:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4C78E0134; Thu, 30 Oct 2025 04:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 937578E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:26:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49DB712B68F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:26:16 +0000 (UTC)
X-FDA: 84054098352.17.86A7A37
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id C80E98000D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:26:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pbahck3w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UrNIq4h3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761812773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KVAKlW35FXGaAHnr4A8PRRsS4WZ1OJHtWNANhGR6clE=;
	b=pjV/U9p9KsO/M4ES1fgJ/OTU5evE/0WvPBCbGuNMPZlr9dzeipEIWMVata8eDBg0YA7ukE
	I/BxecUUKvuqqkW1lRxSoExFaJz1mN89CJTWzlWKyCpHWoE8q2t5t28SLAoz6aIQmM1yEL
	Kth3Zx5Rg15jdvuOLgs9HAZUaPkpuko=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pbahck3w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UrNIq4h3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761812773; a=rsa-sha256;
	cv=pass;
	b=N/PO+0VNGpNZ91E8oqiBhRqagV/IjVyjk8mhIUP7OpDQO33+/zlqyH4FYBDY1KEtC843TI
	t1o7HSCRWOAviLaWFaHtk/2Xi2Oyvt6cK38SiJIr/9aH0TZja7NVVosNDW8My933x1F/1M
	pu1dFAqwhuC8NVV4EgwQTzL35xlUId0=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59U7EhBr001835;
	Thu, 30 Oct 2025 08:26:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KVAKlW35FXGaAHnr4A8PRRsS4WZ1OJHtWNANhGR6clE=; b=
	pbahck3wManq/YJI05aiZnh68qqJ2vnZBV8xQl6jmRLIpFRCyMqKNk6jV7hEjhtK
	RiOGCXg0WfL5IXfh3/HqIAJ0cJU4n4eDo/jDpHlsE2wZ6JGvnKedREfK8v4kYWhK
	7kopwHd4bmdQ+FufZQ8BwhI6zGKMDS7L+W545G35/qROlmztyV8NXaH/FnHf4fQs
	5J7ceIz6tSKBgmlWCs5LloRCjRt+A4RSRAkBnDACVvGrkpXIdaYjHz0Em5Zw6GYL
	aMj4hpAKV+6yeJ81U+JaxUtgYsZepTJ6YuCCQ5dGAcBSaf0dqYd5dcUXsI0XxaTg
	Yf59wfVXl/DJC+5nlCTFdQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a43f2840w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 08:26:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59U6iCpZ012210;
	Thu, 30 Oct 2025 08:26:03 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012045.outbound.protection.outlook.com [40.93.195.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33vyap92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 08:26:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QgAv9KUouvSDqOG85CujAW4dxIfLwy9h/fR0c7Tk3R/F0jvfbGdC78fYIIREZehORkf13/Xp2D11PofPnJOaOEq3by/hCbXkfX50h8xwJI4uoIJm9UTSTDuV2ouBWgC8ve/EOSZRuPqG+Cp4orTpleLoxaZZny8cGh7UkGdQggl5mLHsKgBBaj+J+Sxwg3taeAPz0v8ZJwlOtLC211OqAxlNGVBIU+gITaVhbpIFp6RISKfA6auTkmc8sYwcjpZCrwG5NJV844oIWpSlVI5vctaRK9jQEjnQOIez+eZSzGXg9j20bCsqVKtE2XcmnC49Y0gE3rmBhp1SXZOyPX+92A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVAKlW35FXGaAHnr4A8PRRsS4WZ1OJHtWNANhGR6clE=;
 b=JFkI/FPgfUCEFx/gbwxB+WZQv+IGErULDr7VVsUNRd/Q5n+RSLmI/EDvJBUO2sNmnw6NM256E/sE77Fgl53BxLiYWnMl/UlATvjtMrjtVeAwb0FI5CVEsz5jYfNqZ+Y49JtT0o1itn4qremW2edqH8+Yy0VkiCOnjUkqD0hOBTnpjSrfhc+L5FUjiDsdlB56moBLmJ9wq5fI9LuiydIzgq7BuoV8zoV8Ek1wr4GhMRNWX9ZR5NWGOisx9S6FCieDswvMzoailm1EwegVC3DOYrh2kEIjcuuCnSUH2nF/8AME/oSVqZHMB+2RQhfl6CWbWGcTcoFVSlEEr1JD0nUQ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVAKlW35FXGaAHnr4A8PRRsS4WZ1OJHtWNANhGR6clE=;
 b=UrNIq4h3Ghp7VxBv18dwdhVafZZfx3+o6CpNwl2svANaTgr/ESBV7s2WdW3+DnXPsT66ZLYhUhH07298z4Zw5uGt1A4pk0xTzezlHESetO58SJzUMzS9y1MxkaSADmM1KFyeKV3ClG+K2RsETBMFishBswz3mRgfaheYCeQo8Es=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB5747.namprd10.prod.outlook.com (2603:10b6:510:127::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Thu, 30 Oct
 2025 08:26:01 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Thu, 30 Oct 2025
 08:26:01 +0000
Date: Thu, 30 Oct 2025 08:25:59 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH 3/3] selftests/mm/guard-regions: add smaps visibility test
Message-ID: <034da71d-7c13-4638-bc61-35888e35510d@lucifer.local>
References: <cover.1761756437.git.lorenzo.stoakes@oracle.com>
 <9e5ef2bedbff6498d7e5122421f0ea5ff02236b7.1761756437.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpGFAv9DizXOzCn1Qi5=NDyHh6XyxpmsQr0K45LS6x4igg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGFAv9DizXOzCn1Qi5=NDyHh6XyxpmsQr0K45LS6x4igg@mail.gmail.com>
X-ClientProxiedBy: LNXP265CA0074.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB5747:EE_
X-MS-Office365-Filtering-Correlation-Id: 908a2c5d-9a30-478c-ef39-08de178df589
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RjNmMFVJa0xZcjdEdjhMUUdNbEljSGF6alhNV0U0eTUxSUYwaS9GRGZIaWJG?=
 =?utf-8?B?eTNwR3dYTVJtS2pCckxOa253eVdLNWhhMGYyRU5BaG5jUEFzMzRPRGFHRkVa?=
 =?utf-8?B?cEpqb2V4aDNxalhBMS9nZkw4WWtzbmM3b1NEa2tHb3BxaVV6bG95Z2RRbGNa?=
 =?utf-8?B?UDRjTktMMGZaaFhTeFpER1lxRlpad3graGFFcmpnRlVjUEsvYWY5a3JqaUo2?=
 =?utf-8?B?aWZycWFqcllKL3hHSjF6Yk5KSXJKcE9ES1VYeGdQbC9pU2pqMVBrQTZXRGln?=
 =?utf-8?B?V0lyWjhUYjZTTGZZbGV0SlZDR0dWM1NPQmI3RERvZGdwQVR5TnJKQS9OMm9K?=
 =?utf-8?B?bTU5TFZ3WHBRMkNzcmc0Y1N0dTJDazJSZnRWTXorL0g2MTRFYVRDM2xZeFNE?=
 =?utf-8?B?S0M2TmFDS1dKQkIwaGxHeHdXR1k2QUQyNWRvWDgzUDVPbW02SnZsbS9hOTJh?=
 =?utf-8?B?clRJZjJHQnhiazNFK1IzOFVNYXJBUzFOZlgxNWpjOWdZcXE3Y0pwdFU0OC8y?=
 =?utf-8?B?Nk1sY09yNm5hUUI4YXJ5L2xCaDFXZFJCRTlSWnR3eEExMmZPSlNjT0ZpckhG?=
 =?utf-8?B?MFVlSm9scE5wVXlKS2NMR0VMZUFuWUVuTGptblJMa3NGNnpDam12cGtTSHlF?=
 =?utf-8?B?ZU5LVTJ0T2lnUk9PcXJLdU4raTlQaklyZW1rLzFKOTBlRTNPYnpFRUZpRnBQ?=
 =?utf-8?B?M0w2ZU5GdkgvMi8vV2U1VUJqTC9HcitkM0RpaFUxZHV0TU1iQmR1cFdhOHVC?=
 =?utf-8?B?VkRRb1BVWTUzUTNjOXp5SkFvT0xjYnJxN0l4eXY5OHVFNWJtand1T1FQT2VF?=
 =?utf-8?B?Wndlcm1MblQvN2gyRW8yQzJjUk9OZGtTN0l6RkxzVU81UFU3RjlvQ042dFUz?=
 =?utf-8?B?b0R5bXovRWRhOGJZMmJaNGJreEZLaFBSaE93T05XVGVnd09OelQ1YVVUVnpT?=
 =?utf-8?B?MEdjUlNadkNOMUF5NHc4NFVhdkdrZ1Fsek1VUWNQK2doblNJNUpQQWw2TFBC?=
 =?utf-8?B?czR1dmtsM1I2REtnMGRHUHE3OFRQZElrdzRqaTUxK1YzV0dJc3d3MmEyVEVE?=
 =?utf-8?B?VEIzSmwvRGp1R1VhRDJqdWVRYnZReHhOVE56RGRucmtMdDRQd2NodGZiY2Jo?=
 =?utf-8?B?VHJxTUtUc3pDTmpDcU9XNFZEYitNOEtJalVNU1VSZEdHZUs0TFMzb1ljb0Z0?=
 =?utf-8?B?L3NjTHFVdXpmZ25MdHBrOXVBc0NLM214Skk1azlxbjB2SlZvMGxWd0l1MXVn?=
 =?utf-8?B?Z0tHWHJQK2dOeWRUWDZhUHpWZE14cnloY0VtR0NXVnZsQ0dubmNxNEUzN25i?=
 =?utf-8?B?UTV6b2Zubmc0cktXV25waUpJV1FMdXBKUHkrTnlSaE9uQXNnZk14a1hQYXpR?=
 =?utf-8?B?bGw5N1BVWU9qbUxqRVlyRVk1ZmptcWh3YzlJQllITW1jSHhmUDdSendqVm42?=
 =?utf-8?B?QjZIQUl0dVIvSUlNWWpDQzBRNzFFVmJ2Sk9GNGJwMFlSanMxV0swSnJpenBh?=
 =?utf-8?B?enRpc1J2ZXVkcUtMdDRtQlF6K1NJNkdlVUJ2R0dFVHZIdmJPbG4zSVhpd0l3?=
 =?utf-8?B?dzZhTUdhWEQwZjgvemJmZUVkM0R6YTUvTkgwem54cXE2NmJHSVJRaDZnem5z?=
 =?utf-8?B?WWh1aXpOcDc5VmhzNHNBQ2c5eEx2TlVObXU4WlBlQ1pQbXpnVzN3V1puSkNX?=
 =?utf-8?B?andWRzFLUitjM09KdzRGcStvUWJHNnk4V3gwa0hHTkZrS3lTd2lHcnVaSkpB?=
 =?utf-8?B?LytqUnpOeFNvMUptWFIzUWE2U1BYUTcyM1d5YmoyZXo5aVBTV090S1prREVO?=
 =?utf-8?B?ZWUydk1icGJneEw5bnA5eWw0eFlkSGFUMVpMNzJXVEU0aHhGdWJVYWZlVFd0?=
 =?utf-8?B?V0F6TGF2VmNiZSsyNHNTMHFsTHVaaEdxOUhaYU1GY2U2NEhPVTlTeG1jM014?=
 =?utf-8?Q?Vc/GhK8okShqhCe9NePeMaxOrGpQXq9Y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTdHckN2d3JsSjUyT1VNU1ZHR0cvYmVGMktOOHo5dk5VT3FiQkxvSWQxeXZx?=
 =?utf-8?B?cithazZQd1l2STJHR2lQMUVhSHUxbktNaWx1dG9OTkVwOThCSFZrQXBKRGY3?=
 =?utf-8?B?RlJSOG9kd0loVFFFT0Jua2Z2ZkF6cUhnazg4NER1bjFPNUg0RW5DNU1Ta2NU?=
 =?utf-8?B?NHprVkx6TmhWcnp3ZGVwSFZmdXJtY0xRVkk4dzJ0enVRM1JTR2JUNzVrS2NO?=
 =?utf-8?B?OXZZdFhiN0w4RURWQm82amxEdGpxNDh5RExYSEIyN1dyb3FwSUJvWWJTMy9D?=
 =?utf-8?B?ZE8vR3ZadlJZd253TmxROFdMMHhUSzJEWm1Bay9FMEZnV2lnSStyTFFCYkRp?=
 =?utf-8?B?bU9RbXc3NHhsVnlMWCs5UzFIMWczTWJlaWIvSkxOYUZVbmkwZVExWkdscjNQ?=
 =?utf-8?B?V2dqelJTSGNFWk5jOEdIR3NhclpDYU1mMnRoL09HMG5QeHdSWDVNUGhMb3dx?=
 =?utf-8?B?ZkhIU1J2Qk1scm9QWXRxaU8yM3lRUGlGTmV3V0tORDh3MTBoc2pJZm1wNVBO?=
 =?utf-8?B?cFMya2FDcHBzQzJGanJVaHVRZEJzOGRHc0RROVBlSy90ZGRMWUhtbHZpYkRW?=
 =?utf-8?B?NkpUTFc1Z000aTB2QStPWHRiV3doRG5KeVhmWUZwN3dMTFN5TU1qcGxiazF2?=
 =?utf-8?B?eGhLcHNLZUpmNTdtOW9qYW1sVEFhY1NtelluQ1UrRTgyS0dXR2VKSTJuSnFV?=
 =?utf-8?B?VU9CYUg3b0ZsZU5iY29YQStOUTdZL3gwWEJQWmNmblRQVmFGdXJCdC9ZWkxn?=
 =?utf-8?B?M25ublV1Wm1sUDBnN1haUWphTUpPd09oVkJUM0pqeGFxYTMrZEprd2o2UXlk?=
 =?utf-8?B?UDFTUXNzcFp0ZU9qSkExY3UxQi9oYWdnQkJXRzFlSmtxbXIreWs0bWs0Wkc2?=
 =?utf-8?B?U2ZoYk04S1JZNlhJczh2Ykk0bmp1WUR4M3ZSL1Z0aEpkdXlLaHlVZmt1UEF5?=
 =?utf-8?B?OGFPb0wzdzlTSEtzTXdYS2kyTy9LbnV4UXJqRHUxekRDMldqQWc2Sk9aVTV6?=
 =?utf-8?B?RHpabW03cU5MU2tiWWJEdU8wdFNDUUg4MjZjOUFUVW1sbUFKVmRkNE1wNkg4?=
 =?utf-8?B?TGcyQ2NoaWs3ME1qU2lzUEdTeWlGOVhabFhCa1Nxb2trUnV2MjFIVU9RQnJF?=
 =?utf-8?B?UFI3dGRxU0ZWZWp6VktmV28vMDlrK3JXZ1lXR3gvZEVGY1BiQzU5NlJKWDNY?=
 =?utf-8?B?N2xPZ052ejI1VGRmd3VnK2VDNU1xOGlOZWN6d2c3S1daMXVqVmF1TmhGYWVa?=
 =?utf-8?B?VVVqQmNQaHpMWEZxSjVBY3h3THczNkc1NS9DczJHRU1HbWcxdEpKYWhSS1hU?=
 =?utf-8?B?eExJWkI5ZFZqZUhKUTZtbmtlWi9BN2ZGcmMzVTNjeEl2RTBOOE1qWmZjdThF?=
 =?utf-8?B?L051b2V2QXVTTU84YnZ6UmF1WEMxZnNNU3lHdk1sNzhCdGRFdDFDbnJQdXBm?=
 =?utf-8?B?ZFFEbUF1ZW9HYUwwcENHWjh6NS9SdVNodUNhV081Y2k4TWQ2Sk52eVFKeU1l?=
 =?utf-8?B?Z1k0WjIwcFVESXkxT0Uzai9zV1VrT01IK2VDd3NvSDVIQXh2YVRWb3c0aU5I?=
 =?utf-8?B?SGdCNzBxcWIrQmlWSGc2dnFia0svMHBjRGtrRnFqYjI0U3RjaW43eWxMb2RX?=
 =?utf-8?B?bXZCRzYzUHdoODJxQUxROWFxTmJLYldnUDZpWmNwblBsQjNrWVN6Q1o0dGRX?=
 =?utf-8?B?bkRmOCs3dXBsenFEcWxsT25kWDVOSkkrekd6aG1FN0JBeUtyeTIvUEVTR0tw?=
 =?utf-8?B?TUJMcFY3cWNqblk1RHhwWW42ckFpSklYY3BEcFNTbHpyUDd5dURDZjljV2dm?=
 =?utf-8?B?VWxIbUM0QXl0bnpvM1VBeVRod2tDb0I4a1ZtY21WNDgyOHFsMGlXSTdic0RT?=
 =?utf-8?B?S1JBM2twbzl0a3E2dWlhaEpmRVYwM0V2czlNRkwreE5XL3Y3L0JPaVBsNVlq?=
 =?utf-8?B?WUlmcjhUVXJ5SWJRRWgwMndkMnlVY2IrdTRLUThkbm8zSHdjelV6U2UrQk1w?=
 =?utf-8?B?ekd3K2Jta1J0NlRLTVppT3lGMGsyKzh5Q1lSV1d1TmpsMVdxaG5MYmRXb04z?=
 =?utf-8?B?eW0xYTFYRGZJM1NZU254ZkJJYnI5ejBzZXl5MVFjSzFlWEZPbjl1K3NtS3BC?=
 =?utf-8?B?cXhVOWdGYmpsVk1HZGw3Q2ZObFBoblovRDhmb0E1TFVKK2FrSUJVQnY0UXhN?=
 =?utf-8?B?V3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LWnqavO9/IsxNSsoe/wdD8tpZ2nXG3XuavTrkf2Z3EWbkOu0Osyd4sGF2CzRcnC/VbX10u4Gev+AiCSwge/YZIQ7DkgKftWfH/t6r4YfIbqjtE+cTvwhGitQRORbUJeCWMHAuWbRc1LYNYKR8EPkfEgiJoZA8U2Y38dFAYGa/SNK14N9r0XbVLeBqh9XdH+Noi516uYjtyRj6kyXeD8bY20nruRQzrcZZSI4C6RD/RpRhRvUMhzXAeoPPJukF1Rx5sbxUdWBX7wF4hGjNRyUzGvl0Vb5wlx7nVQF3h5pSbuWrIl+YHlWC8R+ubAmzJp8Mn+gmYnh0ngRl6g2NC497efiQTxx50U+aThrmmU7GSGYYqyjSXU6BGvwGNyy5uOliDsw+G16O0kmeRVxu3632w4SgULkTJaO6Na7/vMtcrmtm7UGN98zH9LwvFMjn3O9eTSDPeEtzvBdocLPSC9uSMdyqzc01VPaKeoXmoy3E42MduVbeSt4UaPGMUYB/tjNqjkw1N4xpRxo6zxZoLoaWXH67eEhPDy1+1gBytANXwEa3dPLHzNBPjNYUEAlrlAtSsP9D9Gf0EyEFVvWVgu89PUPst9xhjvevZkTAu//IeY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 908a2c5d-9a30-478c-ef39-08de178df589
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 08:26:01.1123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZgyrPbM3gICBHb1P5RndCUehxXIlI9oyU/DZWSun3faXMUna4QcA78S9WN4fIHsMrqCqqCbiZ6MbnbfNmZi5s2TSDjTKqk44gKXa4bk5gvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300067
X-Authority-Analysis: v=2.4 cv=PoGergM3 c=1 sm=1 tr=0 ts=6903211c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=tPu2dLCoSz1dwxMZUn8A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: lXgwf4UEfiAhAM4HU30-SNHirq-A2d-5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDA1OCBTYWx0ZWRfX+C/yZGilvjwN
 F3MsBy10rL/PwWYgJ2UGjzTpqoRiUYYz0bj2A19rlJneAVVLFdArut6jnQV+MBmUBEmZmyXS/1+
 A1EJB9HPs+WU3ieQTxBKFkBY4eQNGBwPlDZfgNTgJay8PGxjNmpSMvMKSgr9Y2H3OvZsZy2LRgG
 Tkg3RVa4Wp6oW4J1Z4sscniiNnDpygG6RSVF3FD2Gv496X6k+SaRuZDhd+fTVJ0845zntjcRubx
 ADcK00G2D+EsdCbXADpmkm0aTkAfg9zlDfo+21vbLbVqi6+EU51PpMP+6ZAhwFYObB9VC0fuW6a
 rGYzVrTdpPyxZsQKpmH0bASm8xCpM+x0l893xVU3kyVH3KrMtux3ZHNl8B+hFlr+AmPImaiVQxN
 GzfBVT7zSa3x03WZB6bVuQluVvWjlQ==
X-Proofpoint-GUID: lXgwf4UEfiAhAM4HU30-SNHirq-A2d-5
X-Rspam-User: 
X-Rspamd-Queue-Id: C80E98000D
X-Rspamd-Server: rspam03
X-Stat-Signature: wbekzybghrt7q1mqod93k55ntyoaqwz9
X-HE-Tag: 1761812772-499692
X-HE-Meta: U2FsdGVkX1+ef7zKtjtN5XH3z00gcSrlUslOkdEx9UW6mJgNhDEg+viTOoX6XzVvwcCLg0DoIG2aUqPx0czy395VNb7anETnS50JHXwh8zZOr7cBsFvhDE7TJbWQeVBWzXCW8u/qEyu/oyHvNzQSICS+GYholWPTU8OMlG6lNobJngJ/oHma+qsup+Qhe7WIlXAXbzJvs9RcxwErtDaXlbAtVmXa/Fu5JfZLPSX5gVCBIJklTLaxOji0AWRft9XjgGTRadqyeE+toxixLN2UtxblCZcpOm7fNeg7Vj7m4eo3gwPyf0hB3V5IeL9mDF6va9fMKe+FHeJR8sQe261GEr+jYXNqG0A2pU32k3jHTlMDfOU17ewREtl2hptXnOJbiUj8gT/408gDGa3wSp6iIdZUHHmew6JMIvKCjJeoTlvW8Vaszwkno4G7cmnlN6Q1cX20yx6AzU8oqQP2BooQo6DJzNTztk0WuILcBjzhRSFTMrfEnQasQrFMBg9/6HnWtCrjTotM8/WYmJBb456OmZqz/xPMHOOduaTOrR15uk2YX2IYDEsXvNanHcWojbCT/3kn0MYUrgObFH1La0cbiCIrD7GxCXc67CiaCMawz+DTGosoR/LIrpJhwSQkEz67j2aVI10tF2fm/nJDVMob4iPAynknjXtd3DlBADW+vXpUNwLnSuvG60thQaYmoKCH/gwEdCrEFUJLaRW8gE9zTuvfnvwOX53FKB2fFbo49oGpt6ba9X2GpD59uy0jrTU+/Ju6ZFb6aqvVbIhaJiTw6USW7fIpm7gr6EHQhLhvpKK87oZsp3p0xjy6SKUkZE2IT9G5/llus9Z+jgAPuhYc+HGKZuQUZuE825DU/SSxKS4NLmLXrpoOKeStuX9INbJ44y9wyAgW+M+DeY2jPKYAxBJ4a+8V4hlW1glOBbTangxJphHY07CErE+D7GlgL6T4JclG7PpYac9CDC+1eds
 usiZgIpi
 lPMNhrizbGmqs4kZzjHdovre7axyzgLSkXvX/VjOn+AShf8+1CvqqZfNSxPY37aEMq5AbfeiQZcCqS19rP1Chz+f/UG7CQXnRZRpIA/GUPT04fdXP2MOUJTrtehHvZ2hHXsJGFkXLAiDkV2iZU5rOsYBY6dX5pbfM7rUgq6KVHQqGeDcJSNsQoVOkuhCBUNrR+Qh2CSj7qKt2fL8UUFIQxdAdnSCR05JKWYGKuIZivP+ZH97VxpnTU3o2k2qorcBJv30VRB0mWoEIx9uVXXb1AC7ujrqOrVSvP16zoNCRZW4zE76s+/tJxEEGm8nIwanDZUD+pqcXZk9Uk58a5snqEshXKTtGA0drf0cTLY3nULZVut91x6gHlBffaIP/zn5RUadMCesVaH39gGFNJbgZIJRcMb/D/QEawIzS1h1IMHrI6XYLrJWIfilyWwjHK/ZPxkXeEBZRZA3CGyAXjzPOVbbXjcZAsRvL0D3AezPmJye/MyXm/SFI/6kpaIzr0jxFlMvoIs8Sos+FKRb/gDiZQhw5IdTUTZmkN5d+8LaHR//YjCjRAW2+KA2HorEb5zaUl1Pju9njYW7GOScVDo5KmKH6TB0qTDF/39dcKLNPxAbittcBv3dA6+cU+bnm+pe1LMIphepU3zeaweF31dXnSANr5JL23p2lc0BdEmAdYHA40Dx7vURf0f6mtX1Z/dL0RcUC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 09:40:19PM -0700, Suren Baghdasaryan wrote:
> On Wed, Oct 29, 2025 at 9:51 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > Assert that we observe guard regions appearing in /proc/$pid/smaps as
> > expected, and when split/merge is performed too (with expected sticky
> > behaviour).
> >
> > Also add handling for file systems which don't sanely handle mmap() VMA
> > merging so we don't incorrectly encounter a test failure in this situation.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

