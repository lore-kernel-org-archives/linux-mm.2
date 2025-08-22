Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 044FACA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50184440152; Fri, 22 Aug 2025 13:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48ADC8E009D; Fri, 22 Aug 2025 13:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35283440152; Fri, 22 Aug 2025 13:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D34E8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:03:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CAF36116637
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:03:46 +0000 (UTC)
X-FDA: 83805015252.23.A9BDFB7
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
	by imf20.hostedemail.com (Postfix) with ESMTP id 13F771C0005
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:03:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="qWEj/aem";
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755882224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TqGqGYvEq5rba3u38n7FGYvTio1jIpsHHhDiM4uw9Eg=;
	b=NbkJD+sNO91l819NIdo9QBqYY8bwUB40p+HwpUvD6hzr4UWZhvWgafXdPmvCFfF+oh/psS
	0IJ5FTn2Ry4TkWEvz+1nAoW9X+HlRASt+TDv3wv06TIoKmB7a1qB6GS7I9vSqqsNvqu9yb
	w+UdAwqbJNvYKr1clC/F75LP4tHYrsM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="qWEj/aem";
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755882224; a=rsa-sha256;
	cv=pass;
	b=q97+ZpjV4R3hO3Q0a22APtxq8TQlblShZnE/+gvPK6htqE2olwMhYAdYfTiNE3tC4FNo1u
	601/7Y+sFo+Sz4sTwUfK3lzKT/PDdyMvuJP9R6AigejoFW6ZH3hq4CYLT8gm0iMfmNNOpR
	5aO50a6vXgJi9AyY6AjEcJIa37auNnU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uZv5fp82wCPU9esPJaAXsV99QHGo/mk1QfbMnSZM3wzNv/f5JeSiZhP1NsCheT8OLw9pJuAisZwAzNHtyXaTSK4otjLBlbg7r+8LvLeMwIMvQW0e+2xkDCPcel+4QhHbJ0oQpyEWO12i+gAaQiGVM02SsZjOfGH92palmQ8FRsHjXMYiqkMddO8474YgYds+R65+Hf6iCKOYkdQucGN5JzjXLGm+eyW3ZcEF5owLCLLl0pJnF448NdcNxAWuFTHKclT97xvH4GR8IintHRlMR9fQRnXukT9sKm/8DzbdCVOslNenfPJMdmgA8JEgYyHPKScQiqQki9ecagpLWykw1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TqGqGYvEq5rba3u38n7FGYvTio1jIpsHHhDiM4uw9Eg=;
 b=c2QwuuoojJ9x9Jra1cMo1IEOFKJeMTgpGDllE2uVkYGW75vdUGTXcGmQCLbqX5CIb1jmWIvvSWBoD9LPL2e7Im3Ly7v42+ExCToMDB1JPR1VXf4yjsqzYYEuJuot7TPkV3PtwkihS0/Erp6V2nCjGdScxn7vWlW4mv0XpBj01xI5UcqQVN7wMSiQK48M0dtbtSJ9JTF9Howw0JS4YoUY4Xp0mHIFZdhWFBMYNyU4QHAcE/5KNgUhKBMvQ93UBbut9wo8vysn2ZqGayI9q6RQZLDisbXu7EohcCvGgYjDI0i1g50sAQcYp6Ctt9A+pcqzAPMwKukwwFCvxJJiZexBnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TqGqGYvEq5rba3u38n7FGYvTio1jIpsHHhDiM4uw9Eg=;
 b=qWEj/aemIsFVk+q3FmYDQBjbVt/pMPT/bIFAGUuHIVnddrVrYFQuaTKeNEAVOACByrk2+MV3pfHaNZxUKqYmw4EtQbAscSz2vluOMkiIsEJvprSLQj6Pxr6cCUBsVg30KPDsltfAevLuGrSD8Vgi+Ufx1MQOIXzWWId2FLS+fc8ubmc09vrx43vmzao6bT0y31MXEnZ9IQg/BNXfK6NFHkO+cptkU1L9uiBtqOKmbce21p/TA03DAyTCA2AhRoe4Aw5SDw7+5uHkHmGhmueCoAA40WYoRoFrWFpirGZFcMNIwOoPQ53DUNqMkVFOT2QqEjuVDewU22pq8t5xcwofwQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS2PR12MB9591.namprd12.prod.outlook.com (2603:10b6:8:27c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.15; Fri, 22 Aug 2025 17:03:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.013; Fri, 22 Aug 2025
 17:03:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/khugepaged: use list_xxx() helper to improve
 readability
Date: Fri, 22 Aug 2025 13:03:37 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <33109C8D-C594-4462-8E39-48F310923331@nvidia.com>
In-Reply-To: <20250822025732.9025-1-richard.weiyang@gmail.com>
References: <20250822025732.9025-1-richard.weiyang@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0010.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS2PR12MB9591:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a7410b4-d01d-4878-c387-08dde19dd7bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U2+05Yi7iNHd13GWa1ZxyBmrpRs5AD9YMw6abdSLAbsZw09wF2GKGQZeFSVJ?=
 =?us-ascii?Q?0+tbOXIQ8miIr/yU6L1NUETmwRENkqtOz1/QpkTUF0FTJEApym/TAd3W31a9?=
 =?us-ascii?Q?1IiwnmSpC4PPJGvfGji4/ov+EmjzaStXUnaM83youeis6dxX/Sfu6i8AxKrX?=
 =?us-ascii?Q?q/3isbSY+k5B7PjwUYKDZc24IDpgXu4PD09FZnfClMV+aAvfVPGox7KKvPrF?=
 =?us-ascii?Q?jGW9849e+wRAEoXE0ChRnPlzqFy5hT2DxeWMQSZdddLs+ATHgn8inCecdOza?=
 =?us-ascii?Q?Af+8uWPQS8QzPJHfkGiXEN3B14kx748tXd+VzN1DaWG3RCDABYKpMJENZnVx?=
 =?us-ascii?Q?ns6H+osCdFVFbGX4jZWU2xWdhGk2oSSbHzvOu6ytIFBHESotYMCV7mZVEWb+?=
 =?us-ascii?Q?vCHOPi7IkNqG97YBZ3aDMV+2VInKRHmo9IPSdHNEwLv/Ap3s/0/en7ueGrgE?=
 =?us-ascii?Q?Ct7vFGT8pWnus+BVIv4AwKCF9RRX+8lHirZKhlcT0JiYe6b9vmluh0Q/SpmA?=
 =?us-ascii?Q?cn0N/xHzqJZRjlWrwX9EUrgi0/AEtyCavcigSjAZRNiyIWjzBFtO1xDDUAMx?=
 =?us-ascii?Q?2mqiuZDi/SW8w/Oyt8hNhxUkEuzLmKmNWgmfQZHbE7+Cw83Hkcshnl0HOJZA?=
 =?us-ascii?Q?ffEjF2Fn3Twn6gsdScObPjFNtOsrdlSCm3T5EQF6n8w6HvbjfMsuezKqBmCb?=
 =?us-ascii?Q?7ENkHdvStXp+4zlzDCNw1rP+n9Akfz2G48OzMJD5nxZ6JMkbI6DKrE1ShfwW?=
 =?us-ascii?Q?Dhg1VEEmvJjGEhtvpX1AAkf98j5JhJ93czLi7GXmn4EEDeHvyBq4kx5dxJNm?=
 =?us-ascii?Q?3BJfTDAerDfhV9c/4ma8d8nVU+X9vQQcqMsrXwKG4+vt1rtEg9KIwOOyO/El?=
 =?us-ascii?Q?DdSDNElF2UOQRjZUe4uvEKc3w5/V3wkCQufYpSFQe63ugDXH3JbGCj2qZkeQ?=
 =?us-ascii?Q?Yd14Zs/vR8wMxLx9CnxMGIi+AUOoVTqUD4yV11aKLidp75axCJUqrzHgKwSI?=
 =?us-ascii?Q?xkAqGPRDq9gz1rhRdK8fVMoBxISGQhcgTA33do6yWdNJKUOkLf9DMr1bmFFv?=
 =?us-ascii?Q?tdynM9O5/b3Zsom4WTOySjI3QaYpbZqvJYJCl3Aaw+akVpfK5pS0scOJ35ww?=
 =?us-ascii?Q?7YveyTeL/+PbMT4U892n8Mqe6f2DCFqC1C0roRxhQtCsWduuLV59EW4NO7KU?=
 =?us-ascii?Q?P1TRT0jb6nMHBRGXzEGM9adKeJhj4qOP6AIUqLHFoZSatueH47AhL9fVPUnX?=
 =?us-ascii?Q?uvUNnoDVcpnsHwpKYSoN4uvbcFiDKVJWBmnVNUHH9/rhm/5L9SC6Dx8V1GOx?=
 =?us-ascii?Q?gwk7O0ACcc+v/0CJkX4wPCuCesJbscS3Cp7Fk0h61Ch0hNztexZm5GzE6crS?=
 =?us-ascii?Q?cYm4Id5kK5YhelHER0MKP8WrVB6zY59QTcQOfWSb9N27j+XXwg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Iko9xLvRM2ffwNrtJ5zIfpXr5LxFZZ50xp1lNgEq65jzRFL1EZeXMYtX0D7H?=
 =?us-ascii?Q?oO8DWT4FQq+b6V0S6DxL7Eduq5LyEcZ9hoBp6wdWS+ttPIu2kv5+bnXZLrKx?=
 =?us-ascii?Q?Kr3kTHaDPQxYSGmeKsrJYoUKhV19UDRfZCWW2QAXISXmVF5WytCawVMN/u2M?=
 =?us-ascii?Q?v5WUq4pUx+uvYt1En4Ecy8hrpBxAumG1q5pUhzEy9nlKXj4buGAuXGECJfcC?=
 =?us-ascii?Q?ntDUQJnOHz/0pEB2Tj/74wivHpEYUFF6+aXmyhO7BrZxDwxxvFhYuJGFqohe?=
 =?us-ascii?Q?S9WTAIDt0PYMxXZxho/ocuiKPcXbUZklZZ23/Jt8TnxZ9DJvK9oqSjY3F0Ye?=
 =?us-ascii?Q?bXRdr/rR+E9b0MQnVlt74HO5ZVqfdTskZkKdRaYGDtqQw7XtcsmVDhDNYY0P?=
 =?us-ascii?Q?CmwlPtF2cg7k+nE4RWOMNACipnlY+7n9s0J4buXA06akY+olYzz80V6prfb6?=
 =?us-ascii?Q?3G1a8h0/sinjmLx7a+0fyM7eneBVoIHvodjCrlppLsNZV51fygmP7pLHf7KZ?=
 =?us-ascii?Q?7ch/iCMYKHSAKLaGuXKUSkCve+1Bl6rhNckKCKGWDwXQp1G060TR3RNZORJ9?=
 =?us-ascii?Q?6a584Ru5b1Zy9rM+Lo9Kczzy3dhWYvOQNmB6nETow+jV4nxONf0sNYREKJGp?=
 =?us-ascii?Q?iM48KN3anGIIP7xd2ngTrAaCKPFEvf78QrH26+noYn8YRC39scu1B5Qsjw0k?=
 =?us-ascii?Q?uMgfYAcRJUv4AEBETVZPCENnn98cYiHOdGEKxDn51rOUlbbn/yGUFC60cUU0?=
 =?us-ascii?Q?xs1rRIP4euHcentbVd0ixhIe6WK8y7o9fIh0Vg8e4KwoKZcQ+RsbEXXJk9qU?=
 =?us-ascii?Q?LAWeJg93bULtr4NbH/FHZ/vjuPWv7zV5ilk91huPf/KKRVa3WNF5ioWn0i4d?=
 =?us-ascii?Q?yN9PqEwcEAswck7skW7QBLaIN7bWEpqsFQvQpsJWudjIruswaADeWkgyaif/?=
 =?us-ascii?Q?jrRsRCcy2c7rTLhmjDpTmou8rrGyzklb1j5MuWDb7BR0+VQ6dKxqmQ+KMQZe?=
 =?us-ascii?Q?tgCQHsZcXnwJigS2GnXdds5X9gSoCvgrHDVq/2GBn0sj0TbyQAFTB9OGPM06?=
 =?us-ascii?Q?wPUG8isVXHVXkyXZpJ0PT1uaF+IJJ1mJDnPLpOZGWpdkdUQQ+OTpLsMIQdYQ?=
 =?us-ascii?Q?ONkjczBUI6cj21q+P/XxFRctDSMlQYDEhi1TFTCs7bngYO+++4oxUJ4IEZAV?=
 =?us-ascii?Q?piTRLaoFd5aGgbF7uv/37jbgltDjna0W6K3StznOzxQZQmagRhcyyWuXzNly?=
 =?us-ascii?Q?umAaVaqKosMo6MbdCrkvRMzAPKKrKAp4sSAqYtxFmylvMts34/IwuyTWYrpz?=
 =?us-ascii?Q?Hq8kHikh3so5NeAw5jPuYbpi7gBlMSoh/luhzH/UzDB91LPvYJr+QgFMc2EC?=
 =?us-ascii?Q?WSFwiOz1rKVPUrVr10wkby4vnGGQtJjzKHopIEgRFTy4egAXM27SNCyd/f6U?=
 =?us-ascii?Q?vr4lvNFV7TDONdAWoa3eeek62FzMb9X3LxbAupPEDdTZV0JPtZOoQebkwSNn?=
 =?us-ascii?Q?vMb4TJrlI8CiBED0ZELlmjTnviPw1qEr8GCKMRVHB2NuB5/+/kSLy5HtRWNL?=
 =?us-ascii?Q?N1rZBygVZX+9l8/J8pRJlciIVstxtkx1BG88qjH8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a7410b4-d01d-4878-c387-08dde19dd7bd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 17:03:40.3536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: egoFYvj7Wbj60mSA+vWKyscbEV4QO8lY+08fQ5uIQS7dIh6HDdwr+UiMyUA+3aLG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9591
X-Stat-Signature: ob5z71ftmwxe4grdqugn36anrpqrs53j
X-Rspam-User: 
X-Rspamd-Queue-Id: 13F771C0005
X-Rspamd-Server: rspam01
X-HE-Tag: 1755882223-889424
X-HE-Meta: U2FsdGVkX1+lE7ecv4zGqflEmwb/27Lr+g/0Y+i5O7d/RFLf/qvM7U3Pjw6mcCPpfozORgcJAZ2Lwrq17hnPDKDi5c5JJh49i7JSusUi+QB3lUWUSAq4O8uZA86uuaZ0BUg1siPqDgfSax8m1BvIgtQxU/9X3ExoCviqQzhiSAr7W0A0ZHTh4pHYDVKSjRB2gkjlOw3vFPzJOyWOyAMWpBdLGuHdiyuFYHnDURkTUcXe+mdqDzJKUhkx/Kk4XDu8Wsw65XQDIyKV6i35JAig1hNvx5LEBPKtqZKjf613pjfbQxrX/8jaqQwmSu//x2jbCDY2bvRL+AV8Am7HY+nbRjsx+O0eeud3v7R2XHFV1BjYuAedcW4vF1M+Xj7/+u1fRY4W0TeuJrQ9AjWYWFSex/qBAIxtGs7AoxH6foheOSKPcRtSm3nsyjcEEPNNXPCXz3Nqu0fZpiVyVvJtEtKsORTotriFMLGr/Y4ZAfnr8AsmvKg90XBKY0V2DJNXS/Ht3h6dVgcCnYp71FvZ1TVIly1n8NlhWxCOJZ5uJNyAf8mmJmOA4x+CD3PZkxgT3gsgLtDkxeLhNkHSrL68pV21U8kwKzpiwOe6tLLLNvFly4Qp3bYdFBUpbfnP9aaK+JD0VwhLZTOj0/O8B+wfgVcoMbVklE4VYRdvAGftf29o7jl/14bwT0wKCFBZGU3yCJ7bjHhITNxMOue6yXdsxZ1iYdaHo4nP7fIMPZ5tlYuqoNdT7KtBFITWA3wApkiR1ggwZdqJ2m6cppkNS87TWLGKSv/AseIfVfLovoT+i6GVnhlrxCRfixczobL7N28eEcfWk42cz0KYT7d0Cj8vB6ET2Yd0IRqy+GGzW+oDN7EKTcbbrVXYGsGGtykxbmBGJwjmabHz4mL6+b/aJmB1Jywe5wzNg5p8K1jOc54zN3hPHxosCKuRI96TWSAcdiMV4cTqVM83CPecAfqyYelu3t+
 RM5qFxGW
 yF5MmM+/vhqpS0fTnYMwQ9jfsFeChD1uX7I0+MCuH02qYCOc0K8s348w1PPJeXUsK8/w6C0OlCBJV09ww9iz58ZmAfASvJiYESROUJjSUHlGz0rB2SYqKSsf3PvY3skl2Oxh5PqO4YeeP/3stTkZr+3hHu1sE905dYNt+pmDCkuxUCoiueSsawLE2EgzKH7hu6GLQooRqOdU17QtPuP9CpQgcOgD+/RTqeUVpSr9cg7MSEQjUVLTacGc3v3Ayp2VBoOjDUIAcFZrRErc+3BoMJCTaR5PsFtHLfJSnidnUdTEVwQof2nK3XtUtVM8fEdJvzsqlgMi9ihbpvUh8nJgGHYIEqudT4oaUGGFghNa9LEmeISVrjOurbuKZmp1CvVxGzrWReMrEBTUOnqI3h4IoE3wFtBfsGHudwDhpmw7tKx4rpCh7TX1eUE5hWuooyBsFVa1um2QbyNVZj0IEY7GTPDFBHqvNn4/75Yxv8aOiVXDHhTD47nT45DVOmZjcdHaldZ0VlGQcqptjB9WB2MmzN3Qghd05aWfcoHdSoFizjb0S7bffP9O4kHS4tZVyalvR3MgjhaMpBXXp8Vo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Aug 2025, at 22:57, Wei Yang wrote:

> In general, khugepaged_scan_mm_slot() iterates khugepaged_scan.mm_head list
> to get a mm_struct for collapse memory.
>
> Use list_xxx() helper would be more obvious to the list iteration
> operation.
>
> No functional change.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>  mm/khugepaged.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

