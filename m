Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1214CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 08:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCC486B017F; Tue, 26 Aug 2025 04:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7CFB6B0180; Tue, 26 Aug 2025 04:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1DDA6B0181; Tue, 26 Aug 2025 04:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA2116B017F
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:37:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35DBA1DDEDB
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:37:43 +0000 (UTC)
X-FDA: 83818255206.23.7DBFF3A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id ED0E240003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:37:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eUJMoKYm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZfsNqF8x;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756197460; a=rsa-sha256;
	cv=pass;
	b=1c+OYoGVuWDB8lJ8S5/4fuj0K3HgGpIOjtHhgFrd6EYJAT4jqMDrlSJJLqALH/R3/MB+qh
	IBBgj61EuMY5AP282O/bPAptPcqcx0nN+TwLRuUPQENRnS+3tKS/9jm6pdyyIkvvLV55J1
	f9QaKTxJh1w89nc4GT+YI1Cp/nLbwOQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eUJMoKYm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZfsNqF8x;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756197460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXwBLSlT5J1YGgXxB0AfWQXKu/0DMl5/Z4IQz91Gu20=;
	b=hWHHiadlv3a8OVK99TxGMbONFajr5QW+oudFWeZoT9hAufUFxit6XipLxXuTnftN5JhtD0
	zWqU6bJ99ABEfvJZrgAAiAjQ7eyS99GmDdItBFFzrIm2NtfYbTxu8S7HzfmduNqO6Ott2F
	O7kDULjdCE42l+P+55lbenLY8n0IgjM=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q6CEvU004483;
	Tue, 26 Aug 2025 08:37:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LXwBLSlT5J1YGgXxB0
	AfWQXKu/0DMl5/Z4IQz91Gu20=; b=eUJMoKYmGh9GCgGjb9jUTnfCT0fJR0pJkF
	1YGMt4rkW9TL2kcvdwIKJLaIA/sqR9wlBSsGr1q4QYWe4pMhrBamalzMms8XSwJc
	0X5CvSsRogIuZCTAQoBvZtMY0B5HseLnP7QOvIOgj9R8ZNsob8V7FI5tfq73JAR+
	OZIggQ0WgkZgdC2pUvjWwZoxZzKBdn+mUnD5ZS4ZGcpf8LeP4iWF1J/UK58ylyS/
	qjFXcarLHoOqZSJ2XQYxlDTmifhacrVZC1UMcHxFJQriRw0nvYNqac+AyiRaRbPU
	60zgwP8gRxwz4E6rTPdDjFmK/+G1GyD7Q7X3XpLEKtppDhu+HcrQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twaq5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 08:37:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q8Bhix012325;
	Tue, 26 Aug 2025 08:37:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q4398805-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 08:37:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rNyLLtZl/XQcPEADZGjWQKMUJKA59x9+Q4K4mR7xXI3jrXK9Qa8iAQP3t2p3hyQqd5IHeNqbRhtfC7VjhzpTsTFqIUcaxyGVHj6GRMMbxhgCo2NqBtNEqREsund1HU+diRAFfyVgJymbCWkaZ044395OBqBMKIsc3ve/IhI18k9zQH1nstebcfJYaxWfUCuya1FE6vIKgDWWGp5lDR9zei1YpPJ4AgIYau+FsAtfC79SNwsXgwJlNLD93s0aDJYcofUFYcBa15dFJYehdzwJfzXRxAPRJqf3bBrSvE3CLitJIEAxvschuGY89tDCkzb3xzWOqeVSf5GNvo2EtI39Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXwBLSlT5J1YGgXxB0AfWQXKu/0DMl5/Z4IQz91Gu20=;
 b=WEzgOQQMQfZ0bl+cMGwx2tCDNoIz4lNXfLNOhhh2dplvRDZ62MC4au1UTr8EB3Vqu53ZSCQ+x4gl6PKta/q9OFyZw0IAyrdgAxtPZQ8D1wWIanq43i4r2jfiwCbTRqbv8Qqn/3J0f2QycQ3Zf/xi77/chZuk009OJhx2kf8/24bO/s6QfcdSDIdL+cV0bRJT/TbPL6dOCXUPXiMpR8P2jCinmIQJJiqr1nH3/giiDu2Yns48zs2yIajgxcFy+xSFxLvDlGsa2SsvLLTIcr0TesATINoax/WBZdX//CEQ8MDh+/Ry/PWezLFlh9ylpwu/pFZqmI6jfLIeHSpULyVloQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXwBLSlT5J1YGgXxB0AfWQXKu/0DMl5/Z4IQz91Gu20=;
 b=ZfsNqF8x5qi3YXrzt7GWs4augnXto7Oix/ju7R1gzAyF0nhFVqt2+TcOEuYICw7YZqtUsUI6xDzXQ7xAHMAu5OlbBRj/LxaOkP7If3cS2lAHtkaonfkDsbAoZVvDMIpifpTkSm1MfzJATm26oBKrn/1uap+pGZQXcqyYLVq4RU8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5625.namprd10.prod.outlook.com (2603:10b6:510:f8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 08:37:26 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 08:37:26 +0000
Date: Tue, 26 Aug 2025 09:37:23 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Harry Yoo <harry.yoo@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Kees Cook <kees@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 1/2] docs/mm: explain when and why rmap locks need to
 be taken during mremap()
Message-ID: <f64483ac-31d1-4f80-8fb0-fcf15867c6c5@lucifer.local>
References: <20250826065848.346066-1-harry.yoo@oracle.com>
 <87v7mabl9g.fsf@trenco.lwn.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v7mabl9g.fsf@trenco.lwn.net>
X-ClientProxiedBy: MM0P280CA0072.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::30) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5625:EE_
X-MS-Office365-Filtering-Correlation-Id: a1fb80a8-467a-4734-3a80-08dde47bc907
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hZU8vMf2MbA3tPlsZ+o66WjsxPdfSdayl4zp+0IpT7DRIqvlcLqav8O73JB6?=
 =?us-ascii?Q?6mT+rXKdK4qLFhqymevAr897MiSQ1bji6NoQPpgbmpCoyuE8V55NMC0u+7Rd?=
 =?us-ascii?Q?niXBJ3XkkLF+/1i3gvOQ0nLfJ4b31jgzLUl2KPGkYe4bGkwT78gM5QiI6+rl?=
 =?us-ascii?Q?w7T9uU1ibBAS46JIQyzr6UQlD1AzXNRYOKHw6Ur0Vy0V7686IuUHCczL3B5w?=
 =?us-ascii?Q?Rsf174T89colIZGesmtpfZJP00QLKZLP0/eulAHpFeeX5zDopHbzvq7C2mmw?=
 =?us-ascii?Q?7H31z+ZdkRnGWyg7gRetMQNmkSPP0t7XSHyl6ayiRnaMZyt09Zg6JGYG7oF2?=
 =?us-ascii?Q?pDr0l5Mj7RfrDjC5gkQs7tSIjnn9XBrN7aDudaq2f7UdQyELt3PXEo0I4Tak?=
 =?us-ascii?Q?GDhSZ9ihlUOdiCgjbRCznORlfmJygeW7AIjMphdbEBBxd3jrQhlXScXGzcxq?=
 =?us-ascii?Q?icMI4OK+1f+qZ1SoHgID1boVJoZ325cJfyvSnlk/AP4eaRNSfjwvsNdKTvE8?=
 =?us-ascii?Q?xDUNnqRDU7mxFVlBW+f02mpWcElTxxk3EA+AMclxdcQ45xUMg7V0vOJXqlVz?=
 =?us-ascii?Q?sZ++P7qV2mLSaimGP4ZK+ieA0BEu3+kVD2QS1DUldeqVRueKHw9ciOvGcHx9?=
 =?us-ascii?Q?pNLIc9vhrLP2h7YTPLN8rkzIEuvSQHmgXoNdN6yyoZKEVQ2pxUVDRSMfPrux?=
 =?us-ascii?Q?86vp5BZ0ZZeF+WwKNP0QVbwMKcLAxp3TM8tO6jn28AGdENfRlVU8iyOYEOxK?=
 =?us-ascii?Q?l+hIyTJj8FGsvxVNRmc1nkXXrS3uyF+u5ClrI9MyOQxCK9998+S+3fUnLf9p?=
 =?us-ascii?Q?Oh/mbGVLfPkENdjLAsdxy7bAEP9UNSkYKdwKj9o6ArwbKnU9bGQL+8x8F0zQ?=
 =?us-ascii?Q?CFcCI1CTqDJ2nEnoHsV2ZYDR6yeWRVcWxVp9YCf4d1VzIyLm/nzcc81NSrIc?=
 =?us-ascii?Q?zjzyvIOtpq5T3g2mQIrIeMDUWCZ5qnQtS20GGr5XnYNGrPm/6cpq4/zqLhGO?=
 =?us-ascii?Q?VsDgIEcjDdAkWX1Sg5ehtTJAC6u7TGdM5MJYXIobQQX7daReLqxxqvRTVt8s?=
 =?us-ascii?Q?uuFgKMRtUDWQexI+YpIzo02I583GVlqFrJBkj2zcI8at0bCH9nGkFsTMpAcB?=
 =?us-ascii?Q?QX+cFXbP4sUAKuToHWQ00TOP3G0n9xwl9nUg3q64GILnfSZ0wkMQ/53U3eyz?=
 =?us-ascii?Q?hfpRR7xzCMvEaoCcHVOPeasjVFTYLbVkS73GtQq05WH/yyDi3VQwRFKLlO+M?=
 =?us-ascii?Q?nVkgZFxK6UjwJVVvBu7HYSab/61Ia8HmqfrwZJ1C3sUiITxSE4Xo2JhJq2b4?=
 =?us-ascii?Q?9oiTcd1/ZP7LPg+e1jrjPlQ1eJD/Dq/qQekD3z1gytq5Vg+hBCvNF6v4hVUI?=
 =?us-ascii?Q?ImyuIQZQA4uD02fnxEm4QYQbtjRgaUtVtGlfhw1jq9PkS9Qd0l2ROUSedZAm?=
 =?us-ascii?Q?ulQgTJVbzPE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CU0b/dl6mGh3fRYf6B5wZOFxRRkWDDkgFwoK+VHyEn1ca4b8k5SET6sUeVzw?=
 =?us-ascii?Q?4kg9Ecp86rCTJbuDOnGnwC1Uq0IsaFroDHKckmNFvMoPkQwY+JnNxJYJo1X9?=
 =?us-ascii?Q?EjULsuvVay7IZgpGMg/ZF8MGEoMKTp7ONinBqrGFWgMoJMjy+4e6rSrm0yNG?=
 =?us-ascii?Q?nt8+zKLIwS1KtDBEUZF5n4AX+WFWTvw+8x7sGXjolQ6ZXQ78ydSQ1OztQOgi?=
 =?us-ascii?Q?ZsYW1s+zYRYQsiuJtnn/hXh7U48p4I9JtKgNVKmvKhbk8/2tCrvKAadxXJjd?=
 =?us-ascii?Q?/ogZUpCe1pJNUEvx8hyeaRAgBTPvVYg230To6GI3AQcaU2ubBZr5AwS7M+9o?=
 =?us-ascii?Q?r6WK+Z+Pv4xdsrl8IrgGklFLi2uiZvlu+WBRxAZt5XQvu9Eeh6PDAnVrVFOj?=
 =?us-ascii?Q?egJgDBFtcGSyiydeJQCFjp92haPIK9FMukpk94p2aKq/doUpGkjQ7U/M6RJT?=
 =?us-ascii?Q?SLhCM8tQAGRSXzbBMRRTx4yj/mcbGh51Nr4pTyc6UV1RAcYhU2eHpTZdNKpz?=
 =?us-ascii?Q?8E2FWz3YSXfXKsTMKLiBSSWs24b/7rtHUHL5tT+t7k1aFaWbeTmto+lUaXdq?=
 =?us-ascii?Q?xvfdj7QSOI+jozJva8B3HWaDKYe1BEkzUwP291OAyDZAEAd9LS0xsi0rarPG?=
 =?us-ascii?Q?qT297MPlUprAXF9AueSj6pS4PpXeDNzE063EWgW4cWixqWGzA69k0VrdO4Ym?=
 =?us-ascii?Q?77C2DzOEU6njqf3IQuyNHTfDfqcnNlxu1NJP0L6t1tJ18/yYI+F6DIkOvwt9?=
 =?us-ascii?Q?AMe8CfWJ07SMj7KWbNMEcc8+yPNEP72pd1Z4Vt3jwCNbGlli3+x0eMvilk8b?=
 =?us-ascii?Q?8QPhCMyHMYHa7O36NyRjVV3GzlAuWmEKdD0HDWYuM37dh64Q3jdAfFdIhMR2?=
 =?us-ascii?Q?1geqbPCzOODASdex/CldGpGcrvsfFrBkwb6F8sfkVMVR/IAmDGT3lHID3dEd?=
 =?us-ascii?Q?YeDPR3x6JE+vQQVu001xivl2BG5EI4aDA/E8HMFHk/HyiPHKw986bAs/dioe?=
 =?us-ascii?Q?rB+9XEMuIV/Qjw0chpy0wv/rHLJ1VBj4NgnF9qgETlJKOupIUgXFohZBpAtj?=
 =?us-ascii?Q?tWgdv0aEfCsA7H5ZX4mExEh2eh5oKXjVTBH6LEGgOY/41i3CGr3J6XNF0LEv?=
 =?us-ascii?Q?UzodwALCZYH0fM7gM00qEytxHPZt6wcF/yg6mbHQlV+ac1geMALasrwmUNtZ?=
 =?us-ascii?Q?q8JuyvUtlw9XLqvmMies6WLblitkKVGx9aY//4rhXhR9L+BdthdrVUiFEn0s?=
 =?us-ascii?Q?z+7iJ2/WenKb2fvWebsXdezwOY+LR3deJImrdwwG5hPTskhFOAyA+TTxWNQ/?=
 =?us-ascii?Q?h+cX6LaZzo9XQy1B2jAh+pGwY0j9TAb9QSCZlT7HnOFztEE7hvEeeinRA7Uh?=
 =?us-ascii?Q?FPrqKEPMxf8JdDGXtLyrU036OL2bpZs+lheEbN0kGSPkYkJFHCavV8Jfeegg?=
 =?us-ascii?Q?TtG7MeyIVcwhTwR0VND8/kmBZoircQ7RtQPCX4VGab8NRq6M8/EjyNfDRyYe?=
 =?us-ascii?Q?kaPAmB2WqgMYsMEDmlQmHyOKBXsCzWb4N03rcsmpUrnAXnF1JeRaKM3sdZeV?=
 =?us-ascii?Q?hyUjxJdhdoxF/lwEqhvuqFzGnlEZP4Uh0h0Rchr4VXEofxfUAfyLgTMNhIr2?=
 =?us-ascii?Q?YQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wsTNg9p5wKZrsOJYMjmy+/TBLh0Yg0rEUbWku2/NwD6DZpCABn1Iz+JPtuBqUcWr+Yfee4OCJIBSwQieW5joPYSNI1yyWrta008gaJOb9TcOPx0F0JZfXr2dljz2YTLeTeMjCsCV+f6ktKBSw3rQGOeqavsG4YI3UsR0m+qIlHLRkCh95s+wDTgqqlRGQGqspVyNOUsCILeYOzzygdw23CHMrThi1cKEiDaryVNtgzGCALZAJPuVQZjm6tbgh+ZZPvjdV57cODP5MYewh+BFV3u6Xc97cnG5B2nC9UVud+/nsHxuvwmOWojbPHNQiJAhqIV3uu0UOUSpWsuFsv3L8da94BkfgUb1PIRhnOLk/r3j+EgM4GCUn8+nyhC2hhEoikkhxrMqriTQ64kw2Y5Azzd0+y9VRK7ro5F/IdUEDva0+eKpXMfAgubu93cNDfhmDwZNOL7IL7iWwHUjK6cqE9Jys+SeqhbfhfVoLa5ZiVNqhMHoalexZmLrNArm6wIS5b7CzCTq2jERD1Ua0Jo9atsAKH+C+mTXhcI+i8qtJ+AIcZBOWzffMPV7r+uzGuMvUSZxZltA0MCrSleSTJc+dlhPuULi1u0ETXCR01wUGuQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1fb80a8-467a-4734-3a80-08dde47bc907
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 08:37:26.1948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0e3wB4Vr5y40jExFSW97gsf1zgVIMHaQH5uKv/VTyVmbFVKShEBPr6u3SvwbyV4Mi91jHedQd/rrh6GUWIwKkXTT9+QiLjg2xKidSQ+UoQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5625
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508260075
X-Proofpoint-ORIG-GUID: W3r6WDNQP0NrJKFzOPhrYSHD7aS4JzoC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfX2gu3+QvTZM8s
 zQxsqOcf2tpV6Fxf8rxAnkBQk6QMrYx6whZwkccJ6jrDJ6MKut7HS5fljWcuHm7wHFmFbPzDyAG
 O3hZnwUXGpRIVxafULQLDo3DCz2YrxApUa8tIBaUwH3b7cG14dQhvwAC4MwGZiVzpm6+0OYP2rT
 2skbitUkMG+ofOo9L/mqonx0qu7uh9SQf81Ai7CNtqCrm+vEbz+3sG82mReieI+ySqMaWfjpPg8
 AVgGMDkExnN13Q1z/fUgk9igDuWC2dac9jdEwOVp0LicoBuaXnweHsZe7oE/OTWuBX3/JI7pFPF
 ygTBqNS39i+trIXpiWbRAwYrc/1x/XDita9LNTL3wEQomPx2wr9RL5AGbEnEV/XS/a/WiJ2F2Yn
 aGC8CW5BJX3V/TDhl6YiAhillsEuIw==
X-Proofpoint-GUID: W3r6WDNQP0NrJKFzOPhrYSHD7aS4JzoC
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68ad724c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=Z9iQ6pua90DveRCvPD8A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12070
X-Rspamd-Queue-Id: ED0E240003
X-Stat-Signature: 6uecxftc1rouggz356mk5h3xma9stqjg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756197459-903714
X-HE-Meta: U2FsdGVkX1/zht+pJsRrQPPPro8KnHtYr6sRXi1Cwbhb+CRTedwEm/tcTjq9N8l2xavsAPlRpAWWTi5elW6p7LZYIKFVuUt5SPHTIsrzUtxlNEMBbHvu6BvnV72XgabTbLk4kGd/lfKES+qLDuLS/wGv06cSsQrB5RZLQbSF5sjJDutM6G3LSqpK0R4WuNv8Led10xqTr994LWg2JGrreJKoEaFJD2e9dPUUPzVhg8TvSphQV1mM2EjVAgiPsKXZvshA4+nSiHwTdl+f0PvIAJR+zVih7V3lSxh1hlSm2rGSoV+htKY/Czmt6T2xwW/s60wH5gYoc5eer/UbdulnPbX/Xys/FSCSaqIy5Vz5tLoZqODOsCU7I+dukhAH/adwNXGS+RzdTZnrIPlzg00tNvnvRAIBpC8m3JLjHYYRjK/GiFq+WxM0prlHK6uq7GrdUTyMbqVNHucKuXbZSIMWroYr08RtI5Tyd3yUVrhyPJqkOmKiE6E51WUpyvqoDXXFNytWYtmt7NQC3gU9DFf7FiixPMFt2FpHVfT5PSmYTtZYpCNHQjQsuFBpPc3v+uitS8Zgcw4mZEN6hfzrFsYRr3W9zpkrR2qUxIVGQla6hRfbJazxlsljpB0oCOJ+R5flhwgi0z1/DvrLJOgZOPltD5m91+qpZmqNT+/YN2oBocgcgrJlIzYh5dCfo2llMSpf9AuTNrOHChqm/r60kp9QRp+jESp1cAH+FEhgS/2hmkMgIP+pROwLlWmC1/nc/5faWMoYKXe9qwTf5v8xbW6vTgqFdhfB7p/8vBKghwyyi9kCjTFQhmDSXk7VrKUWt+ZmkNK6pAd3TAuTHbPU3OH8axFGMUE8TiAxpRAE9sI7PIUwiLCaExUjmegw5Pl+M85tmmKk78K3Vd7r0HoXsBmnp0GHVGAK0ckNpAEuF7LPg3lK9Mq6S30xYgbmGEdVuCvyv7n92UHfnocKvlmh5++
 ySTDF6+Z
 sAQ2h62GKUf2JyAAOLWg465v+xLLWs689fI3dtxEHDLrw6Dk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry - one brief very nitty note - could you do a cover letter even for 2 patch
series?

This is a subjective thing and literally just my taste but I prefer it :P
obviously this is optional as a result, but I feel it's neater.

Thanks :)


On Tue, Aug 26, 2025 at 01:22:03AM -0600, Jonathan Corbet wrote:
> Harry Yoo <harry.yoo@oracle.com> writes:
>
> > While move_ptes() has a comment explaining why rmap locks are needed,
> > Documentation/mm/process_addrs.rst does not. Without being aware of that
> > comment, I spent hours figuring out how things could go wrong and why,
> > in some cases, rmap locks can be safely skipped.
> >
> > Add a more comprehensive explanation to the documentation to save time
> > for others.
> >
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > ---
> >  Documentation/mm/process_addrs.rst | 32 ++++++++++++++++++++++++++++++
> >  1 file changed, 32 insertions(+)
> >
> > diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
> > index be49e2a269e4..ee7c0dba339e 100644
> > --- a/Documentation/mm/process_addrs.rst
> > +++ b/Documentation/mm/process_addrs.rst
> > @@ -744,6 +744,38 @@ You can observe this in the :c:func:`!mremap` implementation in the functions
> >  :c:func:`!take_rmap_locks` and :c:func:`!drop_rmap_locks` which perform the rmap
> >  side of lock acquisition, invoked ultimately by :c:func:`!move_page_tables`.
> >
> > +.. note:: If :c:func:`!mremap()` -> :c:func:`!move_ptes()` does not take rmap
> > +          locks, :c:func:`!rmap_walk()` may miss a pte for the folio.
> > +
> > +          The problematic sequence is as follows:
>
> Please don't use :c:func: - just write function() and all the right
> things will happen.  (For extra credit, fix the existing usages :)

Yeah sorry Jon on latter bit, I did mean to get to that but workload
been... well you can see on lore :P

I have a real backlog even more than usual right now too due to daring to take a
day off on a national holiday here in the UK :))

Harry - more than happy for you to do the above as part of this series or
separately, will sling you some tags accordingly.

If you're not already doing it (expect you are) you can generate docs via:

make SPHINXDIRS=mm htmldocs

Then get access to generated HTML in a browser locally in Documentation/output/


>
> Thanks,
>
> jon

Cheers, Lorenzo

