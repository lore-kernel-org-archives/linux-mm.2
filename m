Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184E1CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 18:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6488E0008; Mon, 20 Oct 2025 14:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356FA8E0002; Mon, 20 Oct 2025 14:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21EAD8E0008; Mon, 20 Oct 2025 14:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC7A8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:57:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CA9FC0298
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:57:13 +0000 (UTC)
X-FDA: 84019400346.26.38832FD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1BB0D180012
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:57:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=clj4Hd7J;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Q7zitOxy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760986630; a=rsa-sha256;
	cv=pass;
	b=pA5ru2jDjjgFAA+7FM3hisH4H4uQbgGxrM31d6XHmHN15by/9rtscTDPlVKyllfKkmN3qV
	psYyz8hP6x741hrVR5KI2qx67jIPcc/HQhCs6oBq/79ReuNCIaiPpB6IB0eoBkXcxTkjc1
	ZxYn1nSyCNg7gC7jQcvawN9ShzBDSYc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=clj4Hd7J;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Q7zitOxy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760986630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JHtEMSzELPf7a+xbxxGLRshSG1rh7k4lPHLI4Inp+Kg=;
	b=diScvXTJAtfKWu5ngkkzRo3K051m2EFH/OrPnxJn9W6D9O5rRWjhW/PGDa3d7/zR2iRZ0p
	pBHjx2MbcebDjVSiUe0XHcZP9UIr44tNwahndVlNNWuO8lJKvXnVb+LK5hn9Ikv+9MeC3S
	1QIc8gwXuY8XPGtCM1pQOsp13vBZL28=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59KFjxr9032522;
	Mon, 20 Oct 2025 18:57:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=JHtEMSzELPf7a+xbxx
	GLRshSG1rh7k4lPHLI4Inp+Kg=; b=clj4Hd7Jx8OCpp+/a8rVVUhEqI+0I3r35M
	PvQ2q/BxPoELYTPEPF3t2cjB2UVwbWhTVDYupA/uRWjgPqJXBTZuniTTVGJIVVgb
	fFbCbFinr6A2WhJPSVLZyosV7rpaJquVmACcNXbNXbmKkH8D9/CBepyBrULzLyXw
	n1EtjTRCrq3oyFo/Yq92M0C/DObtWXm5wzBVO9ojfVIrzL3/bsY7Gy/TDQ3RlwH7
	Ci+X+8z+RqIKaqi+bac1TSr8UvJVB6uFWsGCOKoruIZreJG1It1FH1my6DPCPiPM
	XG+UuvDB5UkzXls8Uo1ANDOQPzu4lnGPMDMHWinS2VVRUFnkW5tQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2watw9t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 18:56:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KIKLkd025420;
	Mon, 20 Oct 2025 18:56:54 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012012.outbound.protection.outlook.com [40.93.195.12])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bb1fkq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 18:56:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZtHZwUP1Fssso3Dj98w89BiPRj+72F5z1Rbkfggc81QN2VrDOD425AhgOUQ+UVt4xB9bKAUlo9LwKNUGH830rgNyPAvJK1Gp4z7B9cSGap/U5PeSiCYdH7jPqz2hLcbGMOR7v2T3kZeCi2//lwYwS2BVDUVA6oOqpQeJ0lEEdEzQo7Pt+y8Lkt+/EtTZavFgWdf6xDFuyFiDxqH4m+gB2HHNcQ0D8OOM8E5SbKO33KrGfIaz6Ie7OpnHIvp5gATQC91v1lRWKZ0optQQs8dbCDga8DycuuOI0IvQDHhUrBc6ATl94KlQlkoTDV+fCcPdahaBvfLR29Xf/dC2YqpKlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JHtEMSzELPf7a+xbxxGLRshSG1rh7k4lPHLI4Inp+Kg=;
 b=HqEoMhVPv7Pifs7tmL5Lk5EEOSbJz/oFxRFQC+P6dGTH/lUCBjqkpbFNY2K53o4icrRWW5VJSgImRcpO4INjqcXiUqaDpJCZjjmqXjmI/42K0RrpnBBafAQZ4OIN6UIgU1qgB/nEFuXtuQKppstMx4gyxgQADQgK/rDo6asWWRsy/i+T//x/Ip2vTpttBZFlaqZMtY6YPJVrw1R8N3XyqH/vBaF0gWCTGfI0kSi5F4ZvCaKtb7pWdrrSN0IUWNe1hYGfetCqp0P9PlHxiQORGZqLeKecJhTlfULXt3/iVT3uyMvITGVOU/o4yjVn52IrwQWORL/fYnFDPu9oxIaAIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHtEMSzELPf7a+xbxxGLRshSG1rh7k4lPHLI4Inp+Kg=;
 b=Q7zitOxyDAPN0H1M0EF1tBJkv3yP77r7YteibUan9WbqlBtjmscAjNzTbrJ5c1GVdbgAMXwufd7nyW2we9TpZn5xonIpi60BIZLMdVFCTLTj4TDFHVO7GW/iF2qHbO6ALfAG2HtCe7/LrdziqwChWnlNnKNDuSYHWoLrxZTimUI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5793.namprd10.prod.outlook.com (2603:10b6:510:fa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Mon, 20 Oct
 2025 18:56:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 18:56:51 +0000
Date: Mon, 20 Oct 2025 19:56:49 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
Message-ID: <759578b3-d582-48cc-90af-491210ecd90f@lucifer.local>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-4-wangkefeng.wang@huawei.com>
 <335895bc-c2ef-4ee1-a423-06c673a67147@lucifer.local>
 <1a97f0e2-fc97-4257-8540-cff06a789e32@huawei.com>
 <5ff1ee06-375b-4d5b-b513-7b8cab4e8139@redhat.com>
 <f1d3d11b-6ac8-4747-b2e7-952d4fc3e09b@lucifer.local>
 <719c8df8-b4c9-4a6a-bedf-d62becdb09d2@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <719c8df8-b4c9-4a6a-bedf-d62becdb09d2@redhat.com>
X-ClientProxiedBy: LO4P123CA0601.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5793:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dabd535-a105-4215-5963-08de100a6e03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s7dRlvmVzsFFbARP+e1yU97u2yBPazLwqU+KR7buhn6Rcry6VCC5eZ5vG41g?=
 =?us-ascii?Q?zPK/mAZrKGAJwYOqsmkCRucZ/Qgs0Ucfh8IuOGFAXv1AVn1DvrCx1Rlo+jeG?=
 =?us-ascii?Q?XnBILMefLQpsOw32aD4R+2V+/usIyCsxQIWp1sYK2mLC5Z2Oe/7J8yduuXDU?=
 =?us-ascii?Q?SmxXzo3bHL+ORTABBFK/6DiZoPAMVCxW5vBEK/oc/vu4DfkNUlZ3BjfuQfM0?=
 =?us-ascii?Q?tgiu4aYYakSHCwzTraIrQDY5BViHKH4YHOy47s1h5yKrwjrT40seALnxKGgn?=
 =?us-ascii?Q?lRstjtK9B2Rqc0W75y/+5BdJf9Bb+5dOfuqKfymHcZSjzJeVY7/LUQ5iJZiG?=
 =?us-ascii?Q?rOOBAk/JpM5iyl9ewIMJHIVxyIq8N11Wo+cSO+Dm2A0ErYvbhJbQxJefJOxz?=
 =?us-ascii?Q?gTkijlHG8eEViQRBPxkibQRi4TzcHsZ7e91iffV2ouxflhLuhzgnKs+WVi+A?=
 =?us-ascii?Q?aUz8k/pm863ZsF7WgcQK/mLXjfvBY8/v/a/V5aQn1TKs0S7hurZQb5reABji?=
 =?us-ascii?Q?u+LOcUR2uxtDPmi7RtUzAuG95wQkRTdyoGsZ/EUI7/d0MqtKjJt7GhC2x4H9?=
 =?us-ascii?Q?QDi+OmV0j4jRPqwtBg+Bz8UIQuCyadutZRRUxuYeoFzx7qssUrwlMRyxYbdC?=
 =?us-ascii?Q?1hfRoIz4ucsmNw004bl/xlFTVSKSzS83zB95IYETYvWpzZVXIpkPxKacbX1f?=
 =?us-ascii?Q?da5uwYg5jWcQMGNovhc3lnaVJLzVYGhO/QzjP3HWSScR2fF43Tr7Wp6Gs49+?=
 =?us-ascii?Q?qXEhPtI05cdpekrg+91pkAi1Ep+olLFBr2NL72reRxVwyozuPfbQ0+Z7Sn9n?=
 =?us-ascii?Q?KyHeZxK+6lUqRqme0Mg0Ggj8zksdddVP64+fnyfETKUYGTdLfqwBLVgEeI/7?=
 =?us-ascii?Q?5CBfxP28+cI+Efd6p4X/MmHO9xhRxn8i0/ZN7eo20IaifqX0lWtmYABMgPZA?=
 =?us-ascii?Q?0B1A3jR4dLbNRHg3NhXJAkYA+da8zbPVcDOVzoJvdDGx9zaUICjqFl52RaCw?=
 =?us-ascii?Q?6Bd73bGUK8nZQ3mYLS5JcEQgKJI4UsalM2qxJTR8+/vQ8NX4hX/0F/5tfmDW?=
 =?us-ascii?Q?2g1bZq+1DWon2NYsoUafaAVErCwnp6osAbqhg2v8NnWrC67piqEl9JESztF8?=
 =?us-ascii?Q?/2ASr9q0OlmNgd1eh+LSKzxfR9axLnboeOGLMbEeLFe+ePasJlTH4wxJpC/Q?=
 =?us-ascii?Q?xRXD/R2jdpvCYJf/M6wWTmFqQR2vYqKet343YiriGlplnKnjb6QJoOlkKqIN?=
 =?us-ascii?Q?q/wWmm05DNmKCozDL5fO26XyBVH6JKOMz3ccpPboqq4eSgXt8LZqI+9xxxFo?=
 =?us-ascii?Q?4AdFx8/CG9jnhJcnsC3oDU6yStNnxKZ5/05HgvmE/F7m1Ms9sIOafA83Tz2F?=
 =?us-ascii?Q?We1Y617fgZDDGGjX89lBtqKPiYWLT015EjUJ1skpr0Dfs5MCnjNivPpjneUU?=
 =?us-ascii?Q?VmrYInTCUjpxQ+VMT6ry4GW7cMA6v0SU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MssU3ydAIpvebE6gx/nQa6gyGe9HHl9GUpVb1Lwgl+Z+r+c2xdw3dlc6os+O?=
 =?us-ascii?Q?Z4rEnG9jy06+BAcqAou1vOhiBzBYSF2hIHrPTXKJytoPB7neuub63S+fPOMp?=
 =?us-ascii?Q?K7VqsQi3UiG3g6ws0o58bZiVGjUaA9/06uznZRVXT3y1RB080r+Xocxt2/Ad?=
 =?us-ascii?Q?OVZcWt8IztOQa7RYHfpKolBvplWYwUuLnecscF16jZ4z5kDf4BAiRx1OPcuF?=
 =?us-ascii?Q?NwGwLqPHXocdyeqM7s24cwxHD5rWAOJPj7Su5Ijqx3rBfVcsN6FWfa2LV+zV?=
 =?us-ascii?Q?eHG7aAcqgKUbR0U80F5JUi1vifFWKBt61kcUu/tQEUcC76tJKYi4S1DK644G?=
 =?us-ascii?Q?7MzdoUxbpz0bboHOqGFaG/bCANPK14LjymeLdKH599vUxVkcZp/BRymkf6Oh?=
 =?us-ascii?Q?ULwfZypyebwttjxMAVOi4UCqb4ovtVJUt9uJfWKl6eVLnEBI5rDmy7FvQAOi?=
 =?us-ascii?Q?qqB5L5U1XmzV8Wjm4lolgWc57RXRGa4skjf8j3O9YUxBQjLpnULfWe8/x2vE?=
 =?us-ascii?Q?LRj2IveF5+/1wzMSBlmPxCm6OHWyQaq3l4M9qYudpM4JCgPA1tx6g/oD6eCQ?=
 =?us-ascii?Q?7lu/kHi0e9yS5BVSiHsx0v6Rat40WVPXkYs/8bH2+Tt2YPZatz+lfIdV51so?=
 =?us-ascii?Q?8V9v+KCt6KkonmCdPNKCdc8Btz4EwM64GZUZTizh0jQWoekPJLDFGLtol26h?=
 =?us-ascii?Q?O8XekmD8iDWozqGLJyz/aRPltvgxCuMQzORcWGO7PiFI1qiOBMBaM8ZuCJV5?=
 =?us-ascii?Q?zwNJTAyzONTEIeR7cPyQs9A2LVxffuDUhB74n73TBwFD/ILAy7SbO9j9JD4o?=
 =?us-ascii?Q?auSKG423UkAQ+0oLmvr/fSCLHjs3HbNdcFhk42u58QYV7xBhIAtWQDhMaO5o?=
 =?us-ascii?Q?0riD6qfD1saFZoHSBR8nEWsn0/FWk7PRAQqA5sRXGtKxF29AuNMOeD3scmpY?=
 =?us-ascii?Q?Gzyugg5PhkmiENn+2IJcSwTG7iJrYu5+yIBvqyoisGwg/bag51xEAjVHj9iU?=
 =?us-ascii?Q?SlHTUG8OEiXk3et7vdU84Oz3ysnS1CFT598d9xPFEODlwpDaM6pkIgjRVTrw?=
 =?us-ascii?Q?CVArtjr3ZZLEQ6fk+14gxHxXsL8boCbJ10vsubFPl/HO1ie7hvEzLJbX4qmA?=
 =?us-ascii?Q?pwlr0DpyCsZpIzb69xhKJMnQ58NjnTupoC2nP9vQOLdXlXylDd33HBc8k4PM?=
 =?us-ascii?Q?HS/89dfmaWEXfJLY5iLNcjQ0Yignjb4jiWLsNde/V2pe37AHwuZnBTU9WTOS?=
 =?us-ascii?Q?GVez5VSwTwXHX7koGdot6mhJ2Fskn53fx4B339JAdsyEReD+3cGlInNhdqAn?=
 =?us-ascii?Q?xhn+KZXr8GSAVwfLuO88g5g73XFuUub7XcjKp840TnAMSoH74T9X6V1E8lIj?=
 =?us-ascii?Q?Jw+fM9vy/o+bCtHTIH2W7MXC04YRhJKz51LLlG4lJkosSmP+/S92Hh66790a?=
 =?us-ascii?Q?VFnh0l73EMJH4lF+0svW0JfjfY+/5mtn1xLui6YPbH7sDOxBrLdbOzEvHSZa?=
 =?us-ascii?Q?Tg6Q3hdb3zKf5JVrcB8uNzpzZWs+puOUlGeESRrd0zs4YNihTxsI0L/h6yLl?=
 =?us-ascii?Q?Wx+z0P5GzaDHWz7kHnh/o5l3r6DW4kW64g2qgvJXLWFCRYgxJtjsKkBD/dRZ?=
 =?us-ascii?Q?zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+rpzelWDoz0eyT1ZL2G6IyrJhV+8/ma4WSTY/6+NYk7+8T9/+E/vaolUozzCwgexL6EVEhNQfyN4kSRevg9/46fqWkaBoS4YTA0xScVAP6MdbxdOFjp243ljia8QOrtpMg4R+ZRx+8huwVNxyki9YpeGDmtVQ1/YG9/u7bHsstRtiUt5hoKzGS9kXsfPTp95W+GwTj24mbg1IBm6itij2ibon8EkP+y3TV3PTbgqpIS1Yd+iB8ovPpycOJZMOsbJ5bw3986WoqJv6nqnZbxzYX8LpigPSPiyZZY2MDDZfyuHQzuahh8c5C9fQg5Txa+Q8c9RNp+DbvZQ9RSeWVdx9lHUg43K1gZdFnyx07wmA4DcK/cJqFMjjM6Ec4j+rK9ia/bshz5TqSa5vFoXrmQQyd3VfPT8nghe3nBWaH1d/3qEcqQWn3tRrPI3Ohrq6q6ZLHPIGEjHzdLJlNmYTrTGn8E+H4a5UmE6pk3eRZkOEWCwuL+OrC0WpeB6/HaB3DWCTpl1sQze73aDxh29eQ2P8jOQsHSYgjm3roim1GBZlOkGtqebO5SpW329w6g5v7rQYrGpfGd94dYIye8ohJ9u8SCOHWYDxVI3CMQzXOt+gnw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dabd535-a105-4215-5963-08de100a6e03
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 18:56:51.6351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f4vaLHCbLiqeCqlJceJ7iSxQzPZGRKrt0Hq5pYZRG4fuSBipv+BbZ3cz14blXIYTxFrz+g8Lut4+8j7xmBLfwUd60ZlXMi+06MX1hBlEVSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5793
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510200157
X-Proofpoint-ORIG-GUID: BmHgjbGDCLvtaJz-xpY0foHvvaGj6zKK
X-Authority-Analysis: v=2.4 cv=Pf3yRyhd c=1 sm=1 tr=0 ts=68f685f7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EzuPlZTADeRTEnk7ufsA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX8+4frGytUKR3
 4GCgkbUiq1EvtcQrc6z2jVwaRuGVNBjCSC5oMvqw9l6rdIypJiAvemtlMtBqCEg02aJGxyHf/ZG
 w7iuLksLHGPRplGUjElDTm8n0v/s9vPft6Swgv5XN9wlnvrqg1zqueHFUw2r6CXILoOIt7Ag2qg
 u9kKt6y1MvLg09NIFQ0XtyU1r7Mo67+1DHUghHwq6Rwf0b+q/WUHRkZmrB5ydsE65+jG/3JMqeY
 P8F3IUrM9mck6+uAaUcQg71twWYqyo2vhMbBcAqE+8dd+os04uFYdVCLEiADSBECXPaS4q1i7lE
 fqaOSmrYEsDBNEEs672E1+adtKXmpf3bXaIP7x7KRFrn1C8KncmQxMWyh+BG7CLzamz1zjIFfxl
 9K4Bi3qXzUxAM4Po3yXYfG/ug10F+g==
X-Proofpoint-GUID: BmHgjbGDCLvtaJz-xpY0foHvvaGj6zKK
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1BB0D180012
X-Stat-Signature: dmnh51o3pzg9uyo7y4ps4bizjpd6rn6w
X-HE-Tag: 1760986629-228344
X-HE-Meta: U2FsdGVkX18eYLXMHiUNeAphzMegQjKF2pdyiMRXr9y5Kp8ZHxFPnasLAbeYSkhYe0qGDQyv1CQfeYSJOVLaRrHvFlH3mrmno2InIFQZXbsZokTmn6IeZvnPuZzq0zgB0IknUeP3zR51fXhN1+gMFvO23hXo0cFP8N9nhjg28Dh+ov9ENo6o7+Qg6x8tR+uWCQADKGi2B5C0BH7MAbLhsCOr/R5ibOSol4ZHr1NhSCYUJpW+B9hgfQpM6V+Jn0ayCS61wZXQrIqlX3u2CHQihyZ37GiYB65bM5HajFOkIJmKDALmEOgOwKZsh1BGy3kuDoOug9kRRJK8qShhICwTdUbTZCMs/wrJvhFijbZ6hrqfjhD1g8tmt3/crZzf+DW5qi5crEBOknEoKrBeRDlYQ09cXmW0tofMpl+k1ENyHPpdeA+gbRqTM6hd3AP9TqmECPfNNzIHsQHsUY+0MSARUd5Zvc1zJSr6l7E74r9YumClkLUrAl1ETyuVqiPV6xlqfYKMld7vMs46r0AaJ8envQYawucIoCmXzReuG/iF68C68ha9LlhJoCq3Ix5+sMQbDFpr2NYEIHzDJkQC3qkoBzDmlxJCVi9uPNIETAOScerfNfYf45qnEft8JkVxgTXDfSf4GbS3jIogl/AaAzq0Te6XeKE59EWOhVAhTKrY0BI4BdxBfDrIQ0h3w3hmcjba5Ojw4MyI+tjpE2sLZsLiRkzLQnnCteldSgVgTcLAwfs6vYrmnjWZxkJZkLatR8siDs4Dqub0ZB4iw+5jiPdEFSUHynLyR4IHML/m6JBDmxq31ysh2xdP/xIL8/xU6I7ZsSQ2cSUYxfs0OtSyRKlz9jJEJhjQE+r66mYejS4xIVzHkHcZNj3aq0oiL+b2EGRPZhYsiv2y2yEgb2FqOyqw1bZUDdWF1KVv8b27VXZoSFiRjBnqV/ZoAPEjno4TC7CZQgBHr8/7d1GsQ/ZN6w0
 RmiVWEWi
 epT1kK7NBw/nVkA6QTw9uzT1vAogL+8qbsYECsVkqzzZLA+RHE48i1MnTCQlW4ZP7vp4QRI8v7cozKrlAtz78D6nnaduoOXI2+bq3eE9uWgLFlt51aPLwrGBUEZmkcVyAQVW4HCSrSI8VY7RM8AKBj/2Y/ahL4UJYCun7vT10QAZLplVSb9cpt6OGn8qMbgsn76HKcv51pmSwTIQj0z7URxKW5MBiDxO7Namx+ldokibTbrf3aRxgIcwfW2YKM3qH1h75RHZioSnSfip0niyEEm3RAxfR3vkxt4EjMd/LwkT6/xK9/Fqg+i8aJCm43anZGxSC3hdxNePaJLxQgR3QbWdTq9rmI7ga2w6pV7EDi3v8a0Byq5d6ziO+ln40m/eHDcXSXH2KUhJ4Sw2cIE3dsquJKU5SAY4SxUhCezbmR9lhW5UfprG7JciGr3CN/xHzzO9aFAq0d/7VCve3VCi83BPF4227cvihe55Updb2KrZNWN/ZE9Fl+6wN1SfTnK3s16jp/LIJZWa5X/D3Fc+JyeBvH2bb9Gj28psGK7sY/EXD0lSg1B4HRX6Saf1lLdbvonht3C7zpVQ3kdWGXsUp/U//K7HfhgnGWhybt4Zd/XJgVrRNEkZTyWMHnGvtpj9peclM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 08:12:08PM +0200, David Hildenbrand wrote:
> On 20.10.25 19:49, Lorenzo Stoakes wrote:
> > On Mon, Oct 20, 2025 at 07:34:51PM +0200, David Hildenbrand wrote:
> > > On 20.10.25 17:14, Kefeng Wang wrote:
> > > >
> > > >
> > > > On 2025/10/20 21:10, Lorenzo Stoakes wrote:
> > > > > On Mon, Oct 20, 2025 at 02:18:44PM +0800, Kefeng Wang wrote:
> > > > > > The prot_numa_skip() naming is not good since it updates the folio
> > > > > > access time except checking whether to skip prot NUMA, so rename it
> > > > > > to folio_needs_prot_numa(), and cleanup it a bit, remove ret by
> > > > >
> > > > > Hmm not sure 'folio_needs_prot_numa()' is any better in terms of indicating
> > > > > that you're updating the access time to be honest.
> > > > >
> > > > > Also it seems to suggest that you're determining whether a mapping of the
> > > > > folio should be made a NUMA hint by the folio alone rather than the reality
> > > > > that the mapping is being considered for NUMA hinting and you're checking
> > > > > to see if you actually have to do it.
> > >
> > > ... because the folio doesn't need prot_none protection for NUMA hitning? :)
> >
> > folio_xxx() impliles to me that the folio independently has proeprty 'xxx'.
> >
>
> I would agree if it would be a folio_has_* or folio_test_*.

folio_is_zone_device()
folio_is_zone_movable()
folio_needs_release()
folio_needs_cow_for_dma()
folio_memcg_kmem()
folio_memcg_charged()
folio_pgoff()
folio_pos()
folio_contains()
folio_mapcount()

etc. etc. etc.

All properties of the folio in particular, not folio_has_*() or folio_test_*().

I mean the pattern is established in the kernel. Including folio_needs_*()!

I honestly wonder if the original formulation was correct - check for exemptions.

So something like folio_exempt_from_prot_numa()?

Or this way around folio_suitable_prot_numa()?

I think this is an English thing. 'folio needs prot numa' reads as 'this folio
_needs_ prot numa' right?

Oh - folio_can_map_prot_numa()? Something like this?

>
> To me the folio is really just the main entity we are querying information
> about. Not the VMA, not the target node, but the folio.

OK, I guess folio_needs_cow_for_dma() does the same thing with MMF_HAS_PINNED.

>
> > So it's like saying 'here's a folio, does it NEED prot numa?' right?
>
> I'd say: "here is a folio, does it need numa protection in this vma". So I
> still don't understand your point, unfortunately.

Again I think it's an English thing. As I said above.

>
> And keep disliking prot_numa_hint_needed() ;)

Well you are very particular about naming :)

I similarly dislike folio_needs_prot_numa()...

>
> But again, I won't fight for it if you have strong opinions on it.

It's not the biggest issue in the world. Equally if you insist I won't lose
sleep over this...

>
> It would be better if we could have discussed that as part of v2 to avoid
> having Kefeng go back and forth. Maybe v3+v4 were sent out a bit too quickly

At v2 I had just got back from holiday (+ being sick) and had a >1,000 mail
backlog, sorry.

>
> --
> Cheers
>
> David / dhildenb
>
>

Cheers, Lorenzo

