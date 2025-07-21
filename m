Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE6AC83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 23:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF798E0002; Mon, 21 Jul 2025 19:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6FA18E0001; Mon, 21 Jul 2025 19:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37338E0002; Mon, 21 Jul 2025 19:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B44708E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:48:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 350925725E
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:48:32 +0000 (UTC)
X-FDA: 83689913664.10.1E92762
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7651E20009
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:48:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="fDQ/b7nx";
	spf=pass (imf03.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.92.88 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753141709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tg0d7c+6Dtm+mWI+V3VUu6m9ZHrPj/CHcZsL87dioBQ=;
	b=UMectVerg1d6tFaVI1ovLKqMpvZDT59z4DpOyrqz5hl4MuNjEBcVBPOI3IXneL4Ey1f26A
	DF8xavFGxF75eKjekaInspYbYcS3a6dPyPLyIm6Le4CJMIqv2Qbwp7jFowHPXkjoc2M7TE
	2tDfHAs/t5oxTUWmJjgvm8qW+W4UfVo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753141709; a=rsa-sha256;
	cv=pass;
	b=LXEZVxXaElxxfVgwEmSCh5rM447efNN4IfUPt4AVwE5kVu30rhpvNYQE0b7mitS/JK6ZbD
	njRBirsVn+Mk3jKM8Awi1+Zi7BSdY8mAZNls1XeZrRLRk28uJ8xjDlrp1PNZt/CdQnqQoH
	RKB4+pgYB7gO99eKsSoWIzFQyPKEmZ8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="fDQ/b7nx";
	spf=pass (imf03.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.92.88 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xLeHftaN+nS8ayKs1wkIxJft3/onb3O2hBHzAI9xtrnXzsRIjE267LnNH9CD5ScCvHZwYr2kjhajwyXpZgemj96KkLyFhof7tk1qDs2imzHgi3VlDY/29rwT8rJ3S61B8kSug+x04djlNz0ImdsGm7ZlHoIChCNDccsjvtpija7/1cGBgGOBCl/KCRFe2H0BMf9JcOiVNcCpQc7GAsQhj679GFN9E3sq6GTlI+cfaCpiYfvwZnFNU+F0pKB4pAeClfJzxBnU4Zy3Bne0uqeUjS49UCxT4EnwI0/JkUcNSuwUsOmvpKfaKWFMFrzJaSgzjhQpvttr/3euz/7p8UtERA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tg0d7c+6Dtm+mWI+V3VUu6m9ZHrPj/CHcZsL87dioBQ=;
 b=j3YB/VJFZp1PlXO60J1a8OreWWiePwiLAJ/UgaRNkUuVQqO5LWGpbyjpYGt7U2+r4Wq3FtfjdrjgnpTGAs4SBKqdwA/7sCwTUV7SEtVXXorSjFchi9lpwpfCt2Sdy4nmtA/ja1eiiLnXGK9yeDJ4rJw6Fq8xe3F1QLNNghAkKnxJbmvAB0cbhKL53vJlvrPwwVKssZBhulZ3iJmKsnE1wwKxgtYYjSMh6igtqTOs0DjX5uGsoOmH5Cl71yOBiRmqFdr3uvB0WgVnuSnbs1yikfSGw5/4NQvh4N63rauNGCTpOgSpTqPokkBNj6DcZlCeT9lpI/sl8NzmLDIS0+EY1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tg0d7c+6Dtm+mWI+V3VUu6m9ZHrPj/CHcZsL87dioBQ=;
 b=fDQ/b7nxXAJac9MY81EEZLJwnSCQTlOp6A1iHZO7CliF8DP70K5RszsMeF7jDetlwa5gd2qELmFL5xtjLq/XveMWi4l3qJjfhDpvEZMVxKIQWFvgHOHZYMut9jI1yPAisZYvrFhk8oJrM4c4zdLw+d0wlltBjHrVVjbCGCMG3K0P4ylauyq94e9zDFSaXR+B4lMqthNaufpBOj+aFYXbBMdToo71MLGV9iY2V+TuMtCDG37ULA+lL9+nrjbKxd7elfybGcZLxJxj90gQ3q4TeeR+GTzVb+GnN4yCxsrOVCxrgfNxygJzDOGTqdfJV3t7zMmtyfy8VbRl7wcYe7QMpg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS0PR12MB8504.namprd12.prod.outlook.com (2603:10b6:8:155::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 23:48:25 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 23:48:25 +0000
Message-ID: <0340e202-8ec8-4226-b136-e924eca00309@nvidia.com>
Date: Tue, 22 Jul 2025 09:48:18 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v1 resend 00/12] THP support for zone device page migration
To: Matthew Brost <matthew.brost@intel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@redhat.com>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, Jane Chu <jane.chu@oracle.com>,
 Alistair Popple <apopple@nvidia.com>, Donet Tom <donettom@linux.ibm.com>
References: <20250703233511.2028395-1-balbirs@nvidia.com>
 <aHmJ+L3fCc0tju7A@lstrano-desk.jf.intel.com>
 <09c5ce76-f7c1-41c7-97e1-74448e6143f7@nvidia.com>
 <aHnUMTly7pOywJKg@lstrano-desk.jf.intel.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <aHnUMTly7pOywJKg@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR20CA0021.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::34) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS0PR12MB8504:EE_
X-MS-Office365-Filtering-Correlation-Id: 89ea7db9-eee8-41b4-e8b7-08ddc8b1155b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cHJmaVJBZzdKNlczL0FVMC9jY0hYSmtwY1BwMDI3a0l4L3hhWE80M1lwb3lX?=
 =?utf-8?B?c3NQZVNNdis5UFFZT3l1NmlZUm9qaVQzcjZQV0NMVW4wVWZKY1hucFR3RGFY?=
 =?utf-8?B?dERFREdHL1NNSHZOZlV0TUpYTWIxUTRuajFTNFdlNWhkMi9tQzcvZk9kSWkx?=
 =?utf-8?B?RStNcTBxUk42eDEvb0E1cVZRUTJWQ0FIK1dGRWh6cEZ2UzJCeS9tdVphdWFr?=
 =?utf-8?B?WjRBRXN6Ykt5ZDd1RDIzaGRhMGNNQ3YvQTdsdCt2NU55aTVoMTlaeTZxemFZ?=
 =?utf-8?B?UlhyZVZRQ1diamZQZGdIcG9pbnNxQm5UbTBPbFVxOEd1ZFZvelRDT2RSekJt?=
 =?utf-8?B?aWdWdGR1dXRuN1ovR2g2Vk8rbW5zalRiWTJaM1VsTWtCNnFuY3F6elZBQnpv?=
 =?utf-8?B?NTUyZGM5RTZOaFpTUm5ualJHdnVqWHhQaTVicnlNd2J5Q2FNb3I5Z3Q4Q3k0?=
 =?utf-8?B?di9jc2Y3YjFwY1A3S1hpT1lWL0o5R0VmZk1ic1JpcHkxYUM5S0NnbFU5MFpi?=
 =?utf-8?B?ZTNoM1grK3BGRGdUbTRpV1JTSWZwSVdJcmxBbGtHTjRubnArSHhZUENPNE5a?=
 =?utf-8?B?Q3N1QzJOZXNPaXFtVHhOR3dZQ2Z2WWVpUDJ5TmkrYndiMHpoMlc3TXFxZS90?=
 =?utf-8?B?VmVTZERGK2lqcUNlajlLbjVDNXNOUzMxUFNpRzVBV1E2MzRrRUpNWFBIaWxJ?=
 =?utf-8?B?cmRnQmprQUxWS0hwTWt4MkdZcytpeTRWWTNwMUVPanlTbXZJM3FWZlRhcTJZ?=
 =?utf-8?B?cGIxOG5NTXEvd05hR1VZdWJHQXJNYXVLZ1hVWnBmdmJST20veUtUUmhsaVF6?=
 =?utf-8?B?UWZJWFlJQzlyRVliZytTUmhHVUJFSDFDZzZ5bWovTUtEZkRvTlh5V1pJSEhM?=
 =?utf-8?B?cWR3YVVhaEswbHBJeFFIRWx6ZEMxVUNkYXhBcjQ5aHNYQ1RraVJ2WUNNY3lJ?=
 =?utf-8?B?WE9NQk8xS0dqMEZ2T1VzU2hRaVI1NDNyZXVmMVMwYzJ3RkFjd2dOTURHREY2?=
 =?utf-8?B?aDNBWXhBOHdPZGE1RFVRM0hoQ2FFamN2ODJpcS83aDBEaWZIckpuRUlqeU5Y?=
 =?utf-8?B?eG0xRk5oMW14eGlnTU04bzhNM2xmeFVLUUdtM2cvR1RBNENVOGpwZVhOV1V3?=
 =?utf-8?B?WlNZRDlvN0ZrKzNnb2hzYUMrMTBxcWNaeDYwRjZscDd1Z3dYNXlQc3E2WU0y?=
 =?utf-8?B?YTBuWXBtQ1Z5Rm1MYmhQdVBhOURxc3JlUm5qSmJYTzNtYWc5RVJlRUdPN0sx?=
 =?utf-8?B?cjRZZ3oraHBXQkdObEo2QnBwTGppUGpEQ0dvcE5qVFhoUkszdmVaeGZlZTJT?=
 =?utf-8?B?QlNOamtueW9KN216NE1vaVA5QTF2VVJoZVRIekc4dFpkY2dYb0ZqSWhlL0p2?=
 =?utf-8?B?T1lBcGxhdDVFNUh5Z2VDV3ZQTXAzaUxyUmZsZ0VUY29CRC9hTHYyUGJweFlP?=
 =?utf-8?B?NjY3Unc1NGswbzI0ZnVhRXNMdDVkTG14MENXODlrbVdhMXl0K3BkN01FVjg0?=
 =?utf-8?B?R3M0U2hTdzNMY2RUYlEzV1B4bk9zR3ZEVG16V2sxSTV4akt2UXhBeUU2eEdt?=
 =?utf-8?B?eitOWEEvMzBxOVhmQVRXRDRpY2hHUU1ydCsvblczM2pHSFVvQU1kWWNpODV6?=
 =?utf-8?B?N1lGZVlqYzV2RkVRM29RZ0FCUVRUZkdsZEc2MGE2ZzZiUjFsS3c4dkR3REoz?=
 =?utf-8?B?dlYreng3ZXEyV3VKZnFqSkpPZHk1cmR1Um1XL2Q0VTBWNEhCR24wbW9teXZV?=
 =?utf-8?B?T3RCWWc3N2Z2TTY3OFovdU55SzFtZzVvUzVUNnMvTlJXRzVsVy8zT1FTY0Fr?=
 =?utf-8?B?MVJlUW8zanlTZk84REx2QU9LV2JEOHRHUHZhQUxhbXZxZDVnQmVvOEJxc1Nt?=
 =?utf-8?B?N0ZVbndXYS92SjdmUDZBajNycCtKYXFLcmRBTUxqNUtJd1h5cGh6VkRTZStN?=
 =?utf-8?Q?AprDns0XTeM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWsxeFh6QVBZbTE1bmk1Ri9CVWVXV0x2d3lzMkRTL1JhaG9HMUZBaFJubWdi?=
 =?utf-8?B?UjJ3UzN3Wloxc3JOaHcrL3FLR2U3WUxKOGFMekFjV1ZENHhJWFRGMm5URmRT?=
 =?utf-8?B?aFBNdzRWcUtwbFlESVlsU3lxbkdBUFR6bmFLc3h6cVU4OU8wSmZQeU1lNVJS?=
 =?utf-8?B?Sk9WdHlQRVJDRXdieDVtSHZvckpCWWdQOHpDMEUwVmt6RHhlOHFsR0V1aUE1?=
 =?utf-8?B?QXlkYVRaV1praDFnOEpXRjRtU1ZkMTNBYkJKZUx6RE9ITWVGQXRzUmcvNjN0?=
 =?utf-8?B?VTdibHNvb01NZENzUnlhRnBmZFlERlJxbDh5WTBEci9USXdkbU9RR05nWTFq?=
 =?utf-8?B?TW4xL3Vja0F5dm8wTEFYd253T09IK2R2cC9sNG9FelBKZEpGQ3hFZkdGVG1l?=
 =?utf-8?B?Q0xCeTlnSER2bVVuTTJ1RXBlYmtHb1MyeTdUa052OFF4NUs4VUI5eEYvNmJ2?=
 =?utf-8?B?ci9xaG5rN2FsZkpCWGwwR1lJY21hUXIrcnJ4NEJJZFB6U2lpeVNoTFJ5clhi?=
 =?utf-8?B?K2IydENjZGJWaDVYVTJaTXpEVVhwSm9wVXJoQWVPQ2N5S24xU2hLM29PVnVT?=
 =?utf-8?B?eGtjdnAyQWhqODZlWWYyT0lZZ0pSOWFDYU5NU2NaczZYMmgycXJ6VU9FOFFm?=
 =?utf-8?B?N244MUduUmQ4bGJWUWpTYlQ0T1l1c1lhZDFHczhQV1FwNmZWZi8xUGxwWldN?=
 =?utf-8?B?QkVXYm1Sd1pGL3ZBR2VVL1d4blg5aGNrRUlXSFd0bFRZKzY3MWM2bVlxK0Jr?=
 =?utf-8?B?b1c4UnlGaENONnhuTi9HUGpSZUt5SGp6K1NFYndqcDZ4OHNhemJ2Wk4wVWpo?=
 =?utf-8?B?Y2tadXFZSnZlb2EyWUVKWEpkcjFWZCtMSHdualVFUWtnaGlFdmIwY1RtK1dT?=
 =?utf-8?B?WDBkZUE2bVFORW9SS1FUS2FxcnM2VlRncTVaQzNxM2w0K2g3VmpoNloxd0tk?=
 =?utf-8?B?UUZaL0hVY1RKRmlNNTR5TFJIbWh2UEVTcjFlcHR5TXFndjJ4TUxKZzVmMUFN?=
 =?utf-8?B?RkhXQk1tV2ljZWFQWEtENlFPY0V2OFI2dWpxdjNUOXBXT0lQVHpPQ1EwWU1q?=
 =?utf-8?B?ZzRkSFozL3VuTVlFYVE2RFRobGxycUpaL1NWZXhmT3l6bVdEakFuaG1CVGZk?=
 =?utf-8?B?YTZDTXZrUTdFcG1tajQybFI4azF3aG50SFJ2dHdHNVE2bmYvWnZTQmlYdisz?=
 =?utf-8?B?WUVMa3dOdDdETlpxTk1QMllRTUlqR3l2RHRhZC9ub1AvdWlMNzlCcVhTbThv?=
 =?utf-8?B?R1ByL0VlVnZuZGUwLzd6SjE1RGhLdFMvS1laWGo3TlJkMzBHdUY0ME9kQUt4?=
 =?utf-8?B?M2hvZ0xPSlFzU2dMR0x0c1ZWdWJTbWlSNlFJTEVWSXgvZzgvRUNJOGVJOFNs?=
 =?utf-8?B?ZDNXelBZUlQyMzVJRk9xS0J6WlZabHJ1elFYNFhacVVvZ1l0bVVYODZvZ2tL?=
 =?utf-8?B?RDNkL0QyeFpRdEtFY2JMR2dLUFByQyt0RTY3cHpmRWNMZ0duQkdrclhNTmwr?=
 =?utf-8?B?QWJKTVRKOXZxTGZGTGU2dmYyMFU1LzBnR0J6cTlZVmVwQkxxb2h1MVJJZ3Yz?=
 =?utf-8?B?Q1ZiOVFiTktHYWpMdzJGVUk4VWJzT3g0R0g5SGpzN0lZeTRiVXhRZncrVnFW?=
 =?utf-8?B?bDhYMW5TSy9XVVdxUG5KbHpOZzNhTGVDMGg4SThiZGVIQ1prVnR5dG1sUUlz?=
 =?utf-8?B?T3dyVTRHbWV2VjREYjZYeHY4QmdyYTFvcStCV29NUUV4TFJVM2hpRnBNTTh3?=
 =?utf-8?B?ZWdONEkwMkd1OHo2Wjd5SW45Y28zWTF3T3o4S0FDNE54MTBrRDV3clRON0pj?=
 =?utf-8?B?WUJ3MGMxcThkcERTZkh2Z0J0YU5Nc3FtUjNuZEZPUDZYZjlyTnBSRUxwN256?=
 =?utf-8?B?bk9rRnhsT1NCRXhFRmJDS3RkdGp6bStaMURROS9kemM2eTltcmNyMFVHbmdo?=
 =?utf-8?B?RkRpRWRzb3VLek5JTE9EQlRNWGd6THRwbEpFUGdKTnZucWtodzNRck5IVWpJ?=
 =?utf-8?B?OTJTZEZWSUhockNwYmtxMVBIN3JqR20yVjdmUFVoMUpnZkd4VVJYVVRySU42?=
 =?utf-8?B?VzZWb3hTWEZ6ZkFCdmVCRnVkeHhBdFNkdXFkRHFueitzalBWS2xSQmlOSFA1?=
 =?utf-8?B?OThSZmRjR1U5NEJzTTg0YXI5Q3IvZU8rSGZFV1pOdTEvQjE2bXFBa0liQ0NI?=
 =?utf-8?Q?pRtK7DJWcQqQfYypQehDbQ8yzsYbJn1xVEz00Mm7KEDz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ea7db9-eee8-41b4-e8b7-08ddc8b1155b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 23:48:25.0924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j6TgRmR52VJ7KJCntkmFOuF8/QBiLAFpdLIGNepY0GKZjN7ddpguiBYRyTSGaXOoGG3HoWsDiVJMCSmiw70tYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8504
X-Rspamd-Queue-Id: 7651E20009
X-Stat-Signature: 8gezyhgotct67cbqgq5kzroaqjbz7oy4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753141709-217631
X-HE-Meta: U2FsdGVkX1+npVZtCPSFfN1TeuJLjtA9rWlvaH7yy5tzTrJY8ZZD0kuMGb6S+hnOaWm/djaaCtSjdtw324BShl2KRuol+P1+D4TbBGPchGpUH8AKpBVIA3vW2LHJtK6A67uhBuI6ewv58/IIMFUjutS53VWAkGu+gr9HbA/CzNnw0VQuZPu49ZCipGZPdSl8BoGV90lWxSzB29K2fV3Y9AgnW8dz6NPSR2+VnicpsZaGbghPQ6xRdoQU10qYl3Y7BI6o+lecbkzsfDUq8UqQgdWUpim65lyam36WK1rX53ufxFDyM3gyWZMmIm9MBYFtqMbgMZeFvXH98o5qlPUq0LmBklfqn42TFL/aTVLKu37zghaLmgOVkSZuPpehedD44tUZR55mMkaItQb6hysn18nHrhKwS9RYqbVtlKTZ+gL33YrwRW4BARupWW802lZ7lJPBlDSJsKuMzntGb9fGqOI0w2D6EMcbrfCB7rAonkPAellpChchw7WEb2UoNQ5euaFZ5x6QqkaS6t4lrSi8rYiKvkSes1kw+A4kojOYcJ6gHwVDoOfEvkdKN0XEnkBK+TL0esjiUFdKZf5wahTg6+wHUp2i63G0ZBFIt9vRwUphS6vWsLqE2SxOAli6oqxh/xeNxgPuPl9zIUGp8hRheHVRcKtGIB1/c1h/pl+S+ESIQiNns7/BSoQI3dGVY+y0o3QpoG0MPPilTKPAd/NdkRDMajaG3clWAirGKi0h1MdnQS14sh4vD0AwfyffK4hs5pyuNC/4CbkRfW11LBplu9KUxNAOK8kCYgieG+M18SceSLXroC8O7wRWmH1Mh4X7F1lHKH+/nofWE+w2Y6Ea2IDrOgte8uAH1Kvh7vYm2HMPh52I3uE3L1AibSV8yLVSxyAejzsMmvNVX1DZUnO7WBlT3ZM3BbC1h3NGTddGVztKLJJSTYoAjmZaXXAmEG88
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/18/25 14:57, Matthew Brost wrote:
> On Fri, Jul 18, 2025 at 01:57:13PM +1000, Balbir Singh wrote:
>> On 7/18/25 09:40, Matthew Brost wrote:
>>> On Fri, Jul 04, 2025 at 09:34:59AM +1000, Balbir Singh wrote:
>> ...
>>>>
>>>> The nouveau dmem code has been enhanced to use the new THP migration
>>>> capability.
>>>>
>>>> Feedback from the RFC [2]:
>>>>
>>>
>>> Thanks for the patches, results look very promising. I wanted to give
>>> some quick feedback:
>>>
>>
>> Are you seeing improvements with the patchset?
>>
> 
> We're nowhere near stable yet, but basic testing shows that CPU time
> from the start of migrate_vma_* to the end drops from ~300µs to ~6µs on
> a 2MB GPU fault. A lot of this improvement is dma-mapping at 2M
> grainularity for the CPU<->GPU copy rather than mapping 512 4k pages
> too.
> 
>>> - You appear to have missed updating hmm_range_fault, specifically
>>> hmm_vma_handle_pmd, to check for device-private entries and populate the
>>> HMM PFNs accordingly. My colleague François has a fix for this if you're
>>> interested.
>>>
>>
>> Sure, please feel free to post them. 
>>
>>> - I believe copy_huge_pmd also needs to be updated to avoid installing a
>>> migration entry if the swap entry is device-private. I don't have an
>>> exact fix yet due to my limited experience with core MM. The test case
>>> that triggers this is fairly simple: fault in a 2MB device page on the
>>> GPU, then fork a process that reads the page — the kernel crashes in
>>> this scenario.
>>>
>>
>> I'd be happy to look at any traces you have or post any fixes you have
>>
> 
> I've got it so the kernel doesn't explode but still get warnings like:
> 
> [ 3564.850036] mm/pgtable-generic.c:54: bad pmd ffff8881290408e0(efffff80042bfe00)
> [ 3565.298186] BUG: Bad rss-counter state mm:ffff88810a100c40 type:MM_ANONPAGES val:114688
> [ 3565.306108] BUG: non-zero pgtables_bytes on freeing mm: 917504
> 
> I'm basically just skip is_swap_pmd clause if the entry is device
> private, and let the rest of the function execute. This avoids
> installing a migration entry—which isn't required and cause the
> crash—and allows the rmap code to run, which flips the pages to not
> anonymous exclusive (effectively making them copy-on-write (?), though
> that doesn't fully apply to device pages). It's not 100% correct yet,
> but it's a step in the right direction.
> 


Thanks, could you post the stack trace as well. This is usually a symptom of 
not freeing up the page table cleanly.

Do you have my latest patches that have

	if (is_swap_pmd(pmdval)) {
		swp_entry_t entry = pmd_to_swp_entry(pmdval);

		if (is_device_private_entry(entry))
			goto nomap;
	}

in __pte_offset_map()?

Balbir Singh

