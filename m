Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 528DECA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 10:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997866B0011; Thu, 11 Sep 2025 06:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948BC6B0012; Thu, 11 Sep 2025 06:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E8B38E0001; Thu, 11 Sep 2025 06:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 632A56B0011
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:11:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14DE8B70B3
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 10:11:57 +0000 (UTC)
X-FDA: 83876553474.12.E4C0EBB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6D86F1C0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 10:11:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gb+xdx6M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jYuRcNh1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757585513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQacXmmMNnWlnwzgkWISIGVy3eECRzJBHjJGGhTOtwo=;
	b=vQawP46mk8dIkDsVgw3Y4iM94KvopFkL4SYglpAAPLi8BgD+vwigbRSGJA7aDscNo1Aw2p
	iL9M9K2JsPQ5yOoH1qbKdsLpHjlozROgDyPUwOD5Bxvkd/i8Tsc7rjQAfaoiznmFaL5Cmr
	aIhaaDLxZ2pBG1shh5WKI6rCSXj16QU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757585513; a=rsa-sha256;
	cv=pass;
	b=C5EzYFV7eFQz+lmpwmK7hwC/kGdrVeq6WtGF63XcN9YLpNqRuD917s6qpz9N5R+dcrq3yb
	p8WS0ZZ6kECULObxSMFiy3Ss+9hYQZK6zWXBpMrOWAFuZXEt/BOqJnPQa3DwtGIexZ8RH6
	pctIV/F1mbAJmyxFnl5V9SWPmpMgwMI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gb+xdx6M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jYuRcNh1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B8fvg7018014;
	Thu, 11 Sep 2025 10:06:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NQacXmmMNnWlnwzgkW
	ISIGVy3eECRzJBHjJGGhTOtwo=; b=gb+xdx6MnEUWxL77iPSPN7/zu2WONjvUMn
	KaagNcqZjQvABQ1k54RieBffSTkDjEgr1wKunBlVCwLi07iFfCX/qkdKtylWg9fP
	zD5nQrcjAqTQRy4hiICkUqeX5wd+9YW681R/oYibliK/SotatewlwN/7L4fxySL0
	lSS8IGh169IZX8sN9EDH4foQegOn28TnWyGKsK3yXRTj4ZvvfRWRPvEFktzaRGOh
	KXCx2DJOp4c+nyYIrrsSx3EgkEVW05Mz3mIpxLbMJIh7UglC3v8OD3wOhUwyu1+7
	ApMyTUmSmrLdKo+jl5lZNGWZpN/hOXxbz3hDu0/22cjP9DXmt9Yw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 492296603k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 10:06:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58B9hI6Y038916;
	Thu, 11 Sep 2025 10:06:35 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012001.outbound.protection.outlook.com [40.93.195.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdc8fsh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 10:06:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X1VW5VFvHud510ePBuQ8ezPC05hXqcyjNGFT8mGIXm6izCbmTHwHLq4fPuOBLwQyI1b3i7cspelD/vueP2gzGboKNCqyV+q6APqBJ6cqCy/ua3k+nLSXE1vgi5gxrxDgzGxW11Cj0Za8r+z7AZvdyv0kfoo0KqvhfMKlF5H1Auuzyv3FQNN8vHytZleaggqk4uudVnsiAUd3epC+ulIl4FrvY1XS3Nk72YxwyBCyn3kk7Ni54fh06VcY+UP28EJ5qwgN9WqUyyUazIwWt/k7OgK9h3q14FmnS+C9luxOE/2rcfyBkIRdu+DkBTfHzgjKxbdORFNkykgYzl/HsAiIqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NQacXmmMNnWlnwzgkWISIGVy3eECRzJBHjJGGhTOtwo=;
 b=jCiQF9zTrnqa2z0XjDwPhuzTAGbMy6sHOdBfSuSUhK8EvKOYORgSaA/tIVcAsSpuGbNextD0CR07aqHmjdvV56JN+hDcv21UXhPj/X70wF7BeZVr9VQXF3twi/wMiclpfhaNEUCLg2LJ1Dp3aETrE8oRD6dbHXU6lcftllYWzY+UhX9L6zAEp3iOOD5TVt/qIiVvo7plN9y0Tr+BkV8vj6R1zhUwTUQF3kfFqVo2CRslYl+UvmWQeZfR+ucyIdLN7f+dZBB3xH6uZwQVKartZTrPHvT08ZD3Xdrd/n0bgBTpZBdTjH5Vz/Qq2fRYrQ+8hdcq46OjN15KskAnx3Md+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NQacXmmMNnWlnwzgkWISIGVy3eECRzJBHjJGGhTOtwo=;
 b=jYuRcNh1qQqn6WZDfSYgfUlW8AIbqguWgLujLRNGSYq1WoT+gBSY5vV+4Az/guU0JxisfUWpZIqcrtEj5O9mqshNEypdLkJMFWhbXTgWSAhkuvHTc+vsXrqfGDoh3/2PvxZLZwW+szRJmfL2bmZSErAli4jAFmrZiKAuQrHkHyM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5731.namprd10.prod.outlook.com (2603:10b6:510:149::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 10:06:32 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 10:06:32 +0000
Date: Thu, 11 Sep 2025 11:06:29 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 9/9] mm: Use unmap_desc struct for freeing page tables.
Message-ID: <2157a865-5481-43fd-8139-4b9662239eb4@lucifer.local>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-10-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909190945.1030905-10-Liam.Howlett@oracle.com>
X-ClientProxiedBy: MM0P280CA0111.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::24) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5731:EE_
X-MS-Office365-Filtering-Correlation-Id: 2097991f-a2ca-427a-bf5b-08ddf11ae20c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?igfj+XONtwnNTUOwBuyKFRqrp9ys5FWHD+ylrD62TcQWR9AuYYxx+Bq0CFEM?=
 =?us-ascii?Q?5IxykWacgaxPRROMZja8n7fkd2lMHeHQ0J8KHmDTtbq0Gs0auTQEGwd0rpjl?=
 =?us-ascii?Q?MFXCUI6Cm+s+rzy+lg6h1qhR89JsL2pLslEg8Hc5zR+N0ma75xhKjmcbIW03?=
 =?us-ascii?Q?d50Y80maZM76gkdeplLfFXRTC5OEtDJLlTGN37KSF5pVHs68cjXs1CGUCGkS?=
 =?us-ascii?Q?37EViQlCf1XaCMAIf6QDfSgTQoK1JlpkC/PmbhWQ1XjFmbgGzT1tYRxD5xCW?=
 =?us-ascii?Q?jlKNuNr8dsQ22wcz1YbdfrqoFHjsZdjFfvDo5iQekyHmnjoauLK34gZ09MDp?=
 =?us-ascii?Q?arOdwAnv7omjYQ6K99REEK/b/sBouKs6HMso4PJyO4ssKGGhzZr3cqtILcxO?=
 =?us-ascii?Q?v5q/GeXDEhcFaIrZx7xjqOEo4CuMWS6hMnjh0A4S6QIESMHSNCYyo053qsb1?=
 =?us-ascii?Q?4Ruf+vj1O5RM2lodX9LhgZm/jKx4PyOqRtJ8wleT9kD8f0GrZl5yUGLjWQ87?=
 =?us-ascii?Q?X7EPcr7iBsfnwLVWdSBXbfTHRunPFKrI1zMfby+FBLt4KjgVx1PuAjk8wFt+?=
 =?us-ascii?Q?4jHrrI8cFzgP1SZGEy78a41kjs2HEj2ovgyUDhSNi7jpIb4xRBd2AnrcLj3Z?=
 =?us-ascii?Q?u8UM5mKm7U6TM0MZgrmLc53oHepOfnf8fTS6hOMW7SiJshSHge292T5m4qDJ?=
 =?us-ascii?Q?nTFnDbJZiwADDU92Dd6/n/E36QQvtGzzbM78iENH3oeQU/aDShzqigdmc9Uj?=
 =?us-ascii?Q?bsOBJQym5Px3sgIgue+2v/K8RMySbs8d+7t6ctD6/VaqvC76uYfaezhj1zv2?=
 =?us-ascii?Q?OWGqwiyI6kfHLqOECMu37PR6fai1wG4RSzXLCuc5WXOnKFJHzNeXEnIS6FiG?=
 =?us-ascii?Q?Hn6qhKZSoknXpa+Dn+NaexR5/Mv3IuWXwJ7QAfhMvAC6w7S0hIf5nDibVipf?=
 =?us-ascii?Q?7yCtjjK9tkJIqGAlG710D8Fz/8mDZixZKptVddRE5fneP4dQU30OjSruPk75?=
 =?us-ascii?Q?Rvl2TCIJ48Z3iiygs+8C6184IV74HTEGvzugiXwscnyUJLcBH9UGqd5CDIqH?=
 =?us-ascii?Q?6wHW7wwwLgKJ4KI91lnwdjI4hP3GgLlKb6x7z2o6PRP9iSScqpih9yGDJjTz?=
 =?us-ascii?Q?2OzTdqZUx4Qq7EqETZ8/xFgkbU6mR2hHVQZvcIKWuZVmG5+gcIWtPsWlo0Si?=
 =?us-ascii?Q?H8mItzwGcCXIrkGHSQ9/7Qgaa2FldZjxJ9F+DspiJHfIJVwT4noZzBfePGAC?=
 =?us-ascii?Q?Un7rnhf6bTRWeX5BLV0CTkzQvfySKkQgkOSKDS+5VPB7L0YltZnOO7pXKo9+?=
 =?us-ascii?Q?YSukFUaL3ZDBZvgRRissv0T/oP/CI2HODmHjd4QdZ8i1wSrUO4BNGBXAix+l?=
 =?us-ascii?Q?jGsFlZeHBrrpZTZNuGP1QFKgAdRy39rXiXwCpxz2tbG4ITMCgXO6wOLXEU9k?=
 =?us-ascii?Q?6ng08PmS+x0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tuVUFsa4kQ24w4Yym9BMrkAxVfZJ9bnM7THu8unxEymMKKTEX5GwL80paWXK?=
 =?us-ascii?Q?gyCLUUP0W7TsNs9rZNYsdudpCt2jj1Xc/on1tE4+YM1PFzIn1B3UKWtmUTc7?=
 =?us-ascii?Q?RVEx543Naot1e/ZcQU8NEgyfrikowCpHBLIt/508b903X3OF4p9PM6b0smt8?=
 =?us-ascii?Q?gPFEYXPswqjpVrUiTOFiJywc9AjwyeU64f/44SnmY/aFbSGnMF6mVeO9Uh8Z?=
 =?us-ascii?Q?zXYtfkGeleD3njCxdcXO/UuLxcXOgGyf5R/F96GGdK70A3rQh8SIxOvNULd8?=
 =?us-ascii?Q?oQPchoFWWAl3zRZTOFipCE4X1RzpDOiQiwvs2WYzlIly54ewPES47X5RW80f?=
 =?us-ascii?Q?ak1UxlEJAEgtjjq06p/fXGy7qKd5sgP0nPKWhb3zgIkVPT5u1m/nCUwjyRA3?=
 =?us-ascii?Q?3VJZNUwvP+uZHIdpq2VS9bMe47+QANa8IOyUFlUQmQTfzkxy7iviunF/0Uwj?=
 =?us-ascii?Q?X6fBx5LmhyuyCDpeEkOE1QBG/EunmsJGugQMy236S8iWO3UhucacKujb8TTi?=
 =?us-ascii?Q?1nqcmTs0MiHDtSdZT0DxugyWNGVqufDNb9YmRkc4N1YfG4Ca4XnXXaFKv2N7?=
 =?us-ascii?Q?IMOPtkQcTh9Z+BA/QVx4OC1CKNm7u11ncsrpeqIY12Ix58GvwNSJ8q4KxgJv?=
 =?us-ascii?Q?B+aGvX4q3KHYfss54BP6l7hxQW1Aj2lvzCy3IJCR+I5QpEzOS+SUD3DmopqG?=
 =?us-ascii?Q?OZVwuu5YlKbyyMwYKZyoN6ST+sul67AM2w5EvyrT2ueOlTefOtlNpqVLzMOa?=
 =?us-ascii?Q?hGeI+1GrwQF2DQAGC0ow9hem1BOW3Nj/9ryh1dZb6p+TNj2aNZ0uHn0PwEhL?=
 =?us-ascii?Q?b/th/fTEpV1sw/N+qcTzTGh6KTvoVNp3rCs+mSQ5B9EzOajCOz2sP9bFalsQ?=
 =?us-ascii?Q?aw3roH5yqihBiQRUE7AG0WATLJscokcyi5fmvXYBc/lXjYRoQc5OD7lT/E1Z?=
 =?us-ascii?Q?T2QlWUXsZsP/cZZtUBbhkM01SLnqOKbY6s95sCvF5ebvNWoCuwmbpDFpZZkL?=
 =?us-ascii?Q?dYRuEUGJWiVygZ8w3vUWqim/w1QYSugyTARW/ObZjkUXAyaqu2gmtKXuLlYx?=
 =?us-ascii?Q?hm+WGsuKPpeOm5qXZopMUisG0R3VG6VuRxgcERX9/u56/jyzHpquUBqZibWp?=
 =?us-ascii?Q?Gyx5ac1EnV+2ThVGoS+d/J0LhpUEgHtsfISg3YmhqbrdmDEfROFxVte4ASc5?=
 =?us-ascii?Q?sPMS/BfUIyad6PWKdxzaAoPfA8sMIeiQHusAIlpDQLpTD/Fc/AR+LhaA4K4s?=
 =?us-ascii?Q?YTkZt9fAgghzJVJoIMefEX+8JrJP0yXo63dmZa5frb9MYZucFgfaMWfTruGu?=
 =?us-ascii?Q?L88XZ6t7kvtUlw2aFD/89N1wYuvp4hIKa2A6ctVhHDh1uewn+/9rRDbwLXSg?=
 =?us-ascii?Q?jTlJm2wo4UGUiUbpapRD4YrtDdgrUV1N4Dnk1dmO4k2C2XuQt0WXzXNNzybI?=
 =?us-ascii?Q?eknAdp4X0dWPcTtOMpqS4qp5CQwbmpFwiwCMfiOLeAKPM/UejtvKP1I6vUgo?=
 =?us-ascii?Q?kSI6eLK7citCSQKMa/yzW26YMjLtPwLZ3CqTZZVCtbMIVfn0tVRD8hIdPJlr?=
 =?us-ascii?Q?PSOsBadZ2+sgqRwNyFeeDvPuce/RAu8QFYVDTxTwfJWPhuO+/LhbMm5qUWTV?=
 =?us-ascii?Q?7w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wQL0XTpLilkUcR/curYSA2YifBp/sUezWcQTjU9/VvxDAmepOoaSLuJjlFza4uHl9WeohSjKuRqCk4488Z8nLuS4XREzeak1C1aYSSPfQWi78ah3G6gn/26jECQgnBSAeXtKSPcLcgckUAKzikNfrsFhmQTtEezonNsdqsagxx1nvOY2MiEwT1sYiDxaIKl3OnPu0z1fYz/WDHRTXZSFGT1IoczHm7sSPABwsccFCp7HjfDugvHvwkR2VMOVh6pqTpXoi5zX96u0S+JL4PBmwwseNK4NEh+dpnfU7iRqWO6McdiUZVAWCWsbqeOUZxWrB+h229ngTAfs37dsjcNiuFQfdy8cxAb1WNhWG+mf6510gTHHCXhVRxEgws3yr2AyKlksqbBg8XPaygvyI+J2LjUugAScwQMjjpTXSCsxK5e25kCzwSEu/Ct/ZWF4K8jtm+nZ3Oxh43j14Gn/itESyfD/irO4eUgDrALc7P+DTTSionGVGXB4SJuMn6MMurkRYNoo2yfCMCNaY5WJU//YUSR8hhojK1Fr5FJ/UE+TU/xMMgTFhdR9RA4Tj6qumRBp/MntJJATTNjZBMxCPoxbE9x5BeRJYup3Tu3yYowVD/w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2097991f-a2ca-427a-bf5b-08ddf11ae20c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 10:06:32.2087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dNyuiUuoeC0hf5f4WtLXlbIVc18w2H0mcktjasiRRiDYMBur1xTfWh9Zp+uvzVR74JkS4wA2txdn7zLskbSATgzfbYCAfC9PuCYdCnC5xho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5731
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110091
X-Proofpoint-GUID: NHOqdookAY3MaKFlvUaNOOK5jFqCezUS
X-Authority-Analysis: v=2.4 cv=CPEqXQrD c=1 sm=1 tr=0 ts=68c29f2c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=0Bby8DNpo2XjeMghK5QA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12083
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OSBTYWx0ZWRfX9wEy4Jj4G0D9
 WjkAxoy5ym240N2dZt3v9aRCFydoT7UN4AZOXHeL55ElfBau+v2xSi+D7uNed3EMxEoeUWNkmye
 kviHP7PvhWFTyxsau6BH/o7LUEsqL0EXWN/0g12LZ9tRunD8zBLAAoZCJqEX8XJ4cACcZnC6nRM
 xMcZF3flFf5m0dyIXOkLFqwkDpzDyO0lOOiyx0bQidCIQ2Sh61S6t3nHdX6KeSd7ZAQAmKoSyH7
 cfjFsUZ9yuswzT3Mjw21OSIJ8Xz9jll/yJ9ftqP4GxwPtRAR4FCtIHrWR+oLkwlC97vmF70CAz3
 SNfiuxMLUXESdCOWm9JuIjh9rdEmofOiJXj/BgANbNVp6WCgAie9+wCIqR9ejPmwYnwocMuNbrC
 JF0qNZ1p7QWNPUCJs8eccQsupB9c9w==
X-Proofpoint-ORIG-GUID: NHOqdookAY3MaKFlvUaNOOK5jFqCezUS
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6D86F1C0006
X-Stat-Signature: ixkx3j6c3mjcjt61yrifnp6egtt5s681
X-Rspam-User: 
X-HE-Tag: 1757585513-649286
X-HE-Meta: U2FsdGVkX19B44biS/PMSE/FlXgvkTcJoS7MkmJM0fwT2gNp09vV70qk7wUqTJ1e4JclKhXUOCzOSdZ1ZCvdl77lIu8J6amqdAQJbHjQLE2cVtWW1yb6S2zs6+fLQ85Y0YXhghV/ULSv88WMiXKrj6XA9Z6lCxNGdOigFGFZHWKT3ZDtEb/ANUB4fJ1jKz6D88cGaDv9qncIaVyooE1Mr++KY9YqCpanRk1/H050lSw5L3qJpqS7s+MeG9BxyCg/h3jml2NA1wZNoo6XLDKQEQkk1ILEUit3mcsDpSEnRt5YMT+ioSXYptF3felge7AkVJ1fY01BVGpuOsMBfAeFI7qNnPhgT16TihfoXvoea4rHVlAUn+F/PHsOkwDSIu7f/Mmcf8bIOwwOUMDAG43d6NKT5oAxGjYUX0oW50+ttKeVKmKeNE3fcROQ0bCeGrHFZwiKR22P0rmSC0GZoIDzxbPqigGp6uVcljxVq7xADg9gl9tH/k0nusJjPxF7S5NP1g6nk/E4btA1UdTqBR21xv1/O7rUmuGW5MBwwQ4I3vIzdLf/FBA/4wTAbm6DQ05VPisSDxQqppek++GUs42BYvCg5G7tYBq5ngMCi4QRzPz+jlVvai/yJF4E7vlxyhtC6Ef7Igog5GRP8C/TiJPmFnEvE22swK0XYBIGe0U5dx7jjpR3cqGAfb1RlxAP892Jk3+AqzSCKnejjWyvwodD9jWGl0mxIuBddPXpA9dejGgdonfySaiASNs3FcEk4fQTBfWKNkKGuyEnvgZwu0y4BHouvmj2g+RI2wWwXb8xtXfLb3ecTegaOlmnV+3t1m9OFHeLSX+vLQ3vfvGkLlP34iVetgVuBVxMjaF+u2KSyKJPrKaNCDrklW3A/3v39M5DYJy09z/lykWnh0ytYsegrvlAHexNx/7UMvvvf2TinL0+tnL4WIhvNwrGz33Yn+LIiYg/JirDzC02tF2oOcS
 6ATC5NNP
 55KFh3e8eT9TRcXG1jqhT37AeJQKW8AixPun7Cl5sehLR3rSE+Oh0f3bkJMMbfcAQr+kNteKxTh2X3pM9Zxvdz5jhT03AQly8VbN4AnkPMDj/tjTnfKXbpmVMz8+eU/j+cPB+uG5vP3j0+bypB2g6slRE0T/Bq72ySKjdMn8dvF/j6v/NsUD5XkT1nQ1zTL9GjBRhJVC6mtwIA8B2SQesPprC9iKaKtT71wY3VLX15Mh3aX04iWgLZ/kYA8XGIygEjyh7Uy04A4GUZ9BosBtzdjkQIf/MtORnuNhvKifERqkY0QCro5VrRhEjuMSURICJYoJFIw7+RkK5ZbMqIRnY2shDHW+04ZM6AYVV+r9D6DBQbUxozIiqZAg1wMHgtHRvLW7biszKIeIhYQL4kVuvt10GTwNX0Li+qq1ivOufVSNSZGhES1h9TTVlanfWExC5/r71Y6QMJxjuLG9Hk3TK0QW/IMo0lUb7fYkkLzulHBTAHxljL27jdaWNd9oIYaonaqBKecjkCBKDrXkRA3xI/rzKyj7vRSwCIZ4ys6cCJXE9W5UDswiaZQ2CdWAl2qQac8ZDYQFuhK+Q/vtmYflbvSY8OFCC+c5cetiQmN/WwSS1PnLeM7JXbTq5jYJ/4yDn8FpJaQcM1JCCoWpeKGhdHEDG+9QnEQPeOJOEP1+Mln67IzmNQwelVkDrveu+/bsf7n/oTZFUNqrkTJVR2pgZvlEbB8BNTKB5wDj7iMk9mWHXRf26h/YyVEEH/AbEQ65wZzrDG7tRbHoDcq5HUZB9vQt/Pf7C9KWcyUK7vyNBYEURAyRcgPHZSOBgD/jhdOHdmzVb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 03:09:45PM -0400, Liam R. Howlett wrote:
> Pass through the unmap_desc to free_pgtables() because it almost has
> everything necessary and is already on the stack.
>
> Updates testing code as necessary.
>
> No functional changes intended.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

To be clear, I _love_ the use of this helper struct. All commentary is more
so details. what you're doing here is great... :)

Other than nits below this looks fine so on basis of addressing them:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/internal.h                    |  5 +----
>  mm/memory.c                      | 21 ++++++++++-----------
>  mm/mmap.c                        |  6 +++---
>  mm/vma.c                         |  7 ++-----
>  tools/testing/vma/vma_internal.h | 11 ++---------
>  5 files changed, 18 insertions(+), 32 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 1239944f2830a..f22329967e908 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -445,10 +445,7 @@ bool __folio_end_writeback(struct folio *folio);
>  void deactivate_file_folio(struct folio *folio);
>  void folio_activate(struct folio *folio);
>
> -void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> -		   struct vm_area_struct *start_vma, unsigned long floor,
> -		   unsigned long ceiling, unsigned long tree_max,
> -		   bool mm_wr_locked);
> +void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc);
>
>  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 8d4d976311037..98c5ffd28a109 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -387,15 +387,14 @@ void free_pgd_range(struct mmu_gather *tlb,
>   * The tree_max differs from the ceiling when a dup_mmap() failed and the tree
>   * has unrelated data to the mm_struct being torn down.
>   */
> -void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> -		   struct vm_area_struct *vma, unsigned long floor,
> -		   unsigned long ceiling, unsigned long tree_max,
> -		   bool mm_wr_locked)
> +void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc)

God this is nice.

>  {
>  	struct unlink_vma_file_batch vb;
> +	struct ma_state *mas = desc->mas;
> +	struct vm_area_struct *vma = desc->first;
>
>  	/* underflow can happen and is fine */
> -	WARN_ON_ONCE(tree_max - 1 > ceiling - 1);
> +	WARN_ON_ONCE(desc->tree_max - 1 > desc->last_pgaddr - 1);
>
>  	tlb_free_vmas(tlb);
>
> @@ -407,13 +406,13 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		 * Note: USER_PGTABLES_CEILING may be passed as ceiling and may
>  		 * be 0.  This will underflow and is okay.
>  		 */
> -		next = mas_find(mas, tree_max - 1);
> +		next = mas_find(mas, desc->tree_max - 1);
>
>  		/*
>  		 * Hide vma from rmap and truncate_pagecache before freeing
>  		 * pgtables
>  		 */
> -		if (mm_wr_locked)
> +		if (desc->mm_wr_locked)
>  			vma_start_write(vma);
>  		unlink_anon_vmas(vma);
>
> @@ -425,16 +424,16 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		 */
>  		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
>  			vma = next;
> -			next = mas_find(mas, tree_max - 1);
> -			if (mm_wr_locked)
> +			next = mas_find(mas, desc->tree_max - 1);
> +			if (desc->mm_wr_locked)
>  				vma_start_write(vma);
>  			unlink_anon_vmas(vma);
>  			unlink_file_vma_batch_add(&vb, vma);
>  		}
>  		unlink_file_vma_batch_final(&vb);
>
> -		free_pgd_range(tlb, addr, vma->vm_end,
> -			floor, next ? next->vm_start : ceiling);
> +		free_pgd_range(tlb, addr, vma->vm_end, desc->first_pgaddr,
> +			       next ? next->vm_start : desc->last_pgaddr);

Hm, actually, isn't ceiling exclusive? So 'last_pgaddr' seems a bit
misleading?

>  		vma = next;
>  	} while (vma);
>  }
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 6011f62b0a294..9908481452780 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1311,10 +1311,10 @@ void exit_mmap(struct mm_struct *mm)
>  	 */
>  	mm_flags_set(MMF_OOM_SKIP, mm);
>  	mmap_write_lock(mm);
> +	unmap.mm_wr_locked = true;
>  	mt_clear_in_rcu(&mm->mm_mt);
> -	vma_iter_set(&vmi, vma->vm_end);
> -	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
> -		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
> +	vma_iter_set(&vmi, unmap.tree_reset);
> +	free_pgtables(&tlb, &unmap);

Lovely!

>  	tlb_finish_mmu(&tlb);
>
>  	/*
> diff --git a/mm/vma.c b/mm/vma.c
> index ad64cd9795ef3..ba155a539d160 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -476,16 +476,13 @@ void remove_vma(struct vm_area_struct *vma)
>  void unmap_region(struct unmap_desc *desc)
>  {
>  	struct mm_struct *mm = desc->first->vm_mm;
> -	struct ma_state *mas = desc->mas;
>  	struct mmu_gather tlb;
>
>  	tlb_gather_mmu(&tlb, mm);
>  	update_hiwater_rss(mm);
>  	unmap_vmas(&tlb, desc);
> -	mas_set(mas, desc->tree_reset);
> -	free_pgtables(&tlb, mas, desc->first, desc->first_pgaddr,
> -		      desc->last_pgaddr, desc->tree_max,
> -		      desc->mm_wr_locked);
> +	mas_set(desc->mas, desc->tree_reset);
> +	free_pgtables(&tlb, desc);
>  	tlb_finish_mmu(&tlb);
>  }
>
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> index d73ad4747d40a..435c5a24480bc 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -892,17 +892,10 @@ static inline void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
>  	(void)unmap;
>  }
>
> -static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> -		   struct vm_area_struct *vma, unsigned long floor,
> -		   unsigned long ceiling, unsigned long tree_max,
> -		   bool mm_wr_locked)
> +static inline void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc)
>  {
>  	(void)tlb;
> -	(void)mas;
> -	(void)vma;
> -	(void)floor;
> -	(void)ceiling;
> -	(void)mm_wr_locked;
> +	(void)desc;
>  }

Again, let's drop the (void)'s here. Will let Vlasta fix up the conflict I
guess ;)

>
>  static inline void mapping_unmap_writable(struct address_space *)
> --
> 2.47.2
>

