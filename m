Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52F27D2F32D
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65D5A6B0005; Tue, 13 Jan 2026 14:44:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B536B0089; Tue, 13 Jan 2026 14:44:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48E146B008A; Tue, 13 Jan 2026 14:44:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36A236B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:44:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C652E160204
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:44:46 +0000 (UTC)
X-FDA: 84327968172.09.131A47F
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011043.outbound.protection.outlook.com [52.101.52.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id E61D31C0010
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:44:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g0lTJAiR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768333484; a=rsa-sha256;
	cv=pass;
	b=ZQaJVNW3P4UYAmkuhfvqVKs2WusJOuhTe7o3oxI7rFc9PrSsC1sdBHWFkWM3h+R3rEKJ1S
	Cdu1oFqbRerYkJIJ+QihLERHFa3LbEN+7adALIAxhwjTGbNa8ZrAGZiOzjNT8HCxH+lA7T
	lxpTlCl7S/pPPiTf6toqbGWot/y3yJA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g0lTJAiR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768333484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GFvg7LjarXdZ0LiJ+70YHbzEj/FHottqgaYOlroMEbM=;
	b=OblN2YIrFTnz+Jq0vfrTCV7tRDX5XaXPgnq+N03pdQhw7lz8xm1GwQnnA3l5Z7qys+6dCo
	lW95X5I9TbS0qHVmMxDxkhnPEmnMyA8nDQSXW6VqqOYEckxJoPk09Hn+foyBbDAg4Mqid5
	bcxBQLWkWsRQT0Plau/0uZHY2GsKIco=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=URZjy0NetJqsHFf9pg54juFP7g9lnf+kyUH6INsMagzfrVn9CKIVVYJC7oAlFcPECdDt3VIczZpZEN4kPIuWrdZwruLVcMSLk8Q6502Jz3+LinZamJ0/46886gBSYfdSfxdomwGs8whAj1YIwBprYlZ7uEWEwDoUDOFoUoFEKDwKCRw+lKT3Akj+Qm2eMqQAtNksAvUEH0SpfM6oHQhaXb3oWGww0kd4iM0me1f3mNu0gvhSh3LabNxEO/o7nD/kB4J1FuCn8h3ts9r6/SNCuahO1gwoyv7Gxks0AJuB1CeTXKAgRLCuLiUyvl5ppjNgi6ITFPW6yAcq/STfWgavbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFvg7LjarXdZ0LiJ+70YHbzEj/FHottqgaYOlroMEbM=;
 b=IKjV5NrkbYCxhL62hWiqOQFsE/QkDV/oTE1iQNmWkHWm8cfpzkqAi86LWXSWDncOp81Z/LzZxVOJ+EM63Whduf0JJf3/DP9vRoY3kaVptCdG1GLgns4lKNpvcEQohf1JLkJNfn2AjSskj0afWIYu8/HmXOwh4ZhNpRF5UTu9cn+prOS2Mi3Pq1AQBilOYlJIo6kiFDe3jFh8sbP5nJBYd4vujrJffCbRVXaBNDbujgzg1/xYDULy3SjXyN8L/xQrO8YxmoF7Kd0oLwULllDZdnMDadv46Msv9HeNLmyU3gMOyuFqC87Y92R5wzJzFB5nzLylcxeqvxkTMo0QO7ZoxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFvg7LjarXdZ0LiJ+70YHbzEj/FHottqgaYOlroMEbM=;
 b=g0lTJAiRh2OcKExABCaFb64GTGsR3vtNvDFy7NrJbdeXh49iaMBGtkGbXGkrLoXQPT8Mafl6qaIzmGMf9O8RtECdHb/tbFPHHCxSRDitN1ntrAa712IA/k9f7N/JDFn493ndqR2EyuICMH+YojYX1vIy2U0TxTGEcmkl04EadTQFuYOgbyFf0UgBPHg1rhTMQCSH7z3ZDHvy9Z7DYZB7OqtGZLuKe4Wm61i5TDc9HNB4PNZ+MLA17XI679c7tDZU/bT1+BdSArvec59spQWdlU243hKLTB+X0qnL38NbO0mni6qorQ4kpA0Aa5pDpx27AmL09q9Q8C4+ebOpVN+FWQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB8013.namprd12.prod.outlook.com (2603:10b6:510:27c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Tue, 13 Jan
 2026 19:44:39 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 19:44:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jordan Niethe <jniethe@nvidia.com>
Cc: linux-mm@kvack.org, balbirs@nvidia.com, matthew.brost@intel.com,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, david@redhat.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 Felix.Kuehling@amd.com
Subject: Re: [PATCH v2 05/11] mm/page_vma_mapped: Add flags to
 page_vma_mapped_walk::pfn to track device private pages
Date: Tue, 13 Jan 2026 14:44:32 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <FAA66997-D211-4145-A49A-8A21E0FA0376@nvidia.com>
In-Reply-To: <20260107091823.68974-6-jniethe@nvidia.com>
References: <20260107091823.68974-1-jniethe@nvidia.com>
 <20260107091823.68974-6-jniethe@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0152.namprd05.prod.outlook.com
 (2603:10b6:a03:339::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB8013:EE_
X-MS-Office365-Filtering-Correlation-Id: 194ccdf3-0656-4d77-d434-08de52dc3099
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V0tfoR1kazrtp2FnbeL2FvcRkspWc1i2xlqrj8r/79NnMqs8vK8VbsHRZYry?=
 =?us-ascii?Q?zMkky+QrM13VH4wzryxkF8js58ktDCCnT7Tmt2dI/IkookDqq7b17VgnV/+R?=
 =?us-ascii?Q?f5qK+kVTmh6Mvcq5uFALT7QiXvxyx1HEVlv6+jG+lfMtDd47HQx6p88e1o//?=
 =?us-ascii?Q?yaGU2wkJYAZT3Bec46fJcwAA1W+nD8zNGvbaVFvGVgZhlwnZ3oOOVzL5uOo3?=
 =?us-ascii?Q?poPAhW5jzF1QPAXTTXjt04O2Qr+HVsOuj3rdF71DADtAZJg+2C8SFcLAz6uC?=
 =?us-ascii?Q?8vELJ7oMCJdKNZ673i+vgxLfOB6vI8nalJFsqHj4sY52TRdG2zT079wf1uB+?=
 =?us-ascii?Q?Dso7cbAMHUqU9xX0C/joNEc0ZLxTlQHnPin/Lum8D83DiYwh4DySzwTp8ASa?=
 =?us-ascii?Q?YuMoP4ELkDuWUEFiCeoSAbWtWIWKZPgism/sYQ8HHgut5qLGnRmPgfvps7UJ?=
 =?us-ascii?Q?m00xdruarL6RdW3uuQfbYYz+inONXYQmkFEwpcE2KtKR+yeNwQ5UvcuRw8Zu?=
 =?us-ascii?Q?IV2AbcpkvwUH9bwcw0KlyAWDJHGguKBRgoK919jiwxPNV/of1niQuytp0JTE?=
 =?us-ascii?Q?Vu4xYTGg9RZ60tqmxEdWrAbYdx/9Scj6/jKBYFuHQYocq2EIP9vsH97BP19N?=
 =?us-ascii?Q?oljb+Bnvye5pQR7XxFZ+dQicNu1/z9JLGtgHnRBHDElkPG+5Qs54whuk8R8E?=
 =?us-ascii?Q?xMMXLWFqJwspFtmjzEn5zD/kJd+udalRpLTgVq8rSP9Jtphpb0YZ9u5VqbBN?=
 =?us-ascii?Q?oJHeDvY+4Cv77SuOpQshairDyIEenskNckNyPrjWgzWYqthCyqFLiOvRKmLR?=
 =?us-ascii?Q?dEN2aXYB8lLrGBph8zKsiSC6sOSOdaMHcGcwY7GKYS1nN/zEq9Zwbum/RXig?=
 =?us-ascii?Q?EX9JVkaN+cPVJ8q6P3v9NivLJr64ow/I+gzNO301RRIxay1JO3huMCzutDKd?=
 =?us-ascii?Q?7ad52zGvvlL+BPEQopaOe5iycHjVD+cXke6mLvT4XJGSMwwryPAm9AZSmZdk?=
 =?us-ascii?Q?53xUmLUsc+F5NFrUoPFz+DvOK6Cg0qZZn7kbNfO53x3yY3lVFklO37oyeliS?=
 =?us-ascii?Q?euPxlthHPgFu6k9men3eDniijyN+CcgD/j56ezOPDhoqYhBN6C60x1NGIKS7?=
 =?us-ascii?Q?BfFZq/or0GHXiKsekwizh3ieSPtOZ+GRm4KqpOxmyn3TN/laGXJestJVv6Ca?=
 =?us-ascii?Q?Gokt1UGaKZLuHkT7OtJq0YHbCeZCkHL4DhDByD9gPhbH/FMu+RlqoEK5Efeo?=
 =?us-ascii?Q?NJQO+anOorVqTs1L+u1t0xKvsiGLWdl61fSEeBTEQkxQR+0fxM+TNp//PAXl?=
 =?us-ascii?Q?B2wABNnmsaUy7VO2416sJbwzJVoLx8Jn24bW29vWHf7eu30W1xapCfUedSbH?=
 =?us-ascii?Q?6qsDUvA0Z5h0qYuE8LVXbvaXykwITJs4KhDGTR8wykZHuLIyPkCuvONRD/5M?=
 =?us-ascii?Q?nim8jmkknCW0gEZB+Oaor5QePpTyyTO1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DIjYwcdHSlG0YC/K8rOoEf235+ma00fjwIx5cSp+oQ4BzRy8xK6KeqgQYj8L?=
 =?us-ascii?Q?GvIydBSK42TGgH6W50wrqYEQIeooOE/wySAnCCshSZ+xjPYGWOffgTVDyj1d?=
 =?us-ascii?Q?Qu2pTHOq1kd0se17BRhuTgLv5x7O4LgAHNDKA7y2R18Cua54gfmUUvTBnuGV?=
 =?us-ascii?Q?3bh0/0BbyihzJPRk6Tad3npgXPxIVYDlBif7rppZzM+w5JcvNgm/JudWcc5k?=
 =?us-ascii?Q?4YWp9Z/PpcHgZ+ECT7cA3NFUCf5O1f/JtYtYLSzmUQZtcVujfKjmWPc4GCnM?=
 =?us-ascii?Q?og7woVWIcs3nPL8b04EmOv08CR5nTOo0pxdSNVmu/lnWeICRHM3y2NnTzS4A?=
 =?us-ascii?Q?ymCZMxjXssbIRA7NYL58wC+vFKm8DqPZrODV5j+ETRLhKM+v/P/5cHnxnjHe?=
 =?us-ascii?Q?j1+Ll4qhnu34Z5U7v8yHF9SaZPMmDEq2H+0vPCzuwTwJnPwfl4WEY62xzqJb?=
 =?us-ascii?Q?MUZakPY9qfNvWDZ8flKLfZaGkkWe3eiy3S0d9SopdHj+E5vh5PGW2TO4qKdV?=
 =?us-ascii?Q?N0tHIfzZI1seOZEMHDZswpMQOhJeL2bWhUB0PQpzgc17cQMrpVWqukFZRfOc?=
 =?us-ascii?Q?g0z39KxGI+rzpXY0zxBQNkAG6+L5s9YuncnoldXefEj0JprsXX9jBGd6oVjn?=
 =?us-ascii?Q?/j/kwi2huqHyTrBK49+XjxAR9gT4dA5R+PGt8fFsj7ndyX3t/LYmOKcGye4P?=
 =?us-ascii?Q?OvkLVNjulYsGEdmlSHulRNS9sxIh7bEbkBmGOCnTNrhLB+OGBHi+4Rp8IyLJ?=
 =?us-ascii?Q?kP+5Nr9Mn7hXCxAhxlnDldc1ROP98SBg3WyKmjedykmWBgHbdpd6yIdFT6+B?=
 =?us-ascii?Q?lI7N4Vv7JwzlguX/vYll9IpXWrDLTxA0uil9w/G1mrah1EaPKuMXyuxTEK3+?=
 =?us-ascii?Q?+4RxcR9JTlJexHifn6r/izucUQr9lBs7g0iKIbt3e1EOf2uk5cQQxq09vYDN?=
 =?us-ascii?Q?dNC/TBwf+clg2tmKiHA21bfTNr7blXrHguHwqsnsiS6hJHLRsJc0mVnLs2vA?=
 =?us-ascii?Q?F7FuKEJKGdGO8jf5UdVeUPa1G+NzocwfpNUI8E9lA31vo8kXb2GUSadeldn0?=
 =?us-ascii?Q?ETwTZsRu9ZJg92SFwaQAAN1eRhVO7Ko6oWskVHVPjhXrbXDbr05zM8iVy+lF?=
 =?us-ascii?Q?8eeJup2CGfW/UeJfMX40QUNSX0xSzAM0ZKtgG6iV7jr377OMdNuU6ZvSTPOl?=
 =?us-ascii?Q?JsYpQlHrcBBwELlFhBQFWAXIi14FnPa0BhNiUevm1tjuTLxFWnE8qlXTePjC?=
 =?us-ascii?Q?XTQN1HmIYqwbgZHf9RZE3KkDgtAPxc3C8djxKHRVYXuCoOsTgHc5yui6ct91?=
 =?us-ascii?Q?MTOLIeVNYHTJJzO9C0ZaaVCiFe23x8bn8MZR476G2diXgE8tYeum7i0n9EY6?=
 =?us-ascii?Q?cAdyLpOx6RFdBrn+x1m1fygi2t8p4Z8zJo7sJB2Int4C22LzGgPeEzJEaOnQ?=
 =?us-ascii?Q?Qp5d2xH2X6jU5nuC02bFov3xO5mjTO2vMAcGq3jdUbEcN2oDmAU7tYpntjuK?=
 =?us-ascii?Q?0eF9Ln6lgG4k4GsfPw9u8JKq3bNG5sEyJlTPJJw5Fh+MeDCiiRnItS3FthkZ?=
 =?us-ascii?Q?ZsSuS+ewHV9+ozE6dV6+ePjoChMl6HqUrh/R/ap/el7pDF+Rk/JVOIHR0JxD?=
 =?us-ascii?Q?mhmYTda+MlHKSau6v+xaiWqfIf31gzZoDTxTcVRSK3HIG3d80Z8NCM6Hufth?=
 =?us-ascii?Q?P+QLV+OG+rcDxB2fsXy6YAzPfdUCN35YNyIQZJAONxx59vYlPFhAlEHKN1gS?=
 =?us-ascii?Q?oGxOx9/Ldw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 194ccdf3-0656-4d77-d434-08de52dc3099
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 19:44:39.6230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JzBEDJ2gf5uy6DAJbmr4y1wpeGprytSn7IqodfZkaA9PFRJvDDGHvBt8ane+T6e8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8013
X-Rspam-User: 
X-Stat-Signature: asr4r1xdbafqf46icrwao4pyj4mkm3x5
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E61D31C0010
X-HE-Tag: 1768333483-615388
X-HE-Meta: U2FsdGVkX18CLtYpQn+Sy1r2qDgEseO8U/MdONXrCMG0NKRcp7L+s+PdJ/5EnsfBMMiqqjo4blHsuIfxVvlcOf0OV2oY6GfOLu4DnFpo9PHEyYoWNX7RS0h71ZptFzLe+jYT5uWgJWOad9+Zv8k5E9dK3Kty+Cq0bcwY7wGE+k9By+FldIDs0LPQuomWKS011puLY+j/PqOtZxP5WbtVns9b+QZzCl27DWtBHtkUUYmoFuuMYLsASHhVm13mem0PHJj1yL9EJXcmsbh305qGlHXW6mmE68KzInsxs+vrZ808gwFXFD8OHfXZmNoYuIgDhcsQuHk/RiMdjF1hjj3XEDhnTpuKWV/bSyt56GC3jQS+JDB9aAFSw6MwyyPX6BfqD+BoEPeiXtpx8n7pNDCe3H0ndfdylIJ6ChpNBHNkQ3X8S0+UQTKkE2nfdhwXIosO25sYOSRI+Kf5D2JdhoO9m1macxCvslXFiyE/K617TW2GREmvnv2DcJda4bSnFiVpsIVaQSMSaK1wnaOebrEOuQQHjR6yxwdcO/gE4cmh+M8GYY+PPlujwfNMHoGWgEAGyKIDH8my/sQAqwbDQe4Xp/f6Yuv0K32D+eqL2cNPHTHmnJX6WCVE98y9nWPwbMulJ08d2rpAqQ3KLAuePxd/VKUka/tmsKyKsDn8cIVz3WjrwMSDA9n11tecpTgqXlmAoUaT27VOG2gbu2gK7VRpyYg6RcipN+S2U0DkPS3yxagWPhuyyEzZdLvFgdWMWK4PZBgEpVrWA7MpPoq751LwDFGEcUewxx2ipxG60Qux0vCaGVU2F+kym3mECzE3Iq3lYS9oeVMnbY0nb+5Ag5RT3CY7niL3d6JT1G50BgLia9qAxuLjrHMCn4b3fRVpbDot8JEN9nv7lq3vYFbVqXACAOZojYpsWj0RAas4Qez9XXRx+DLiDTnEe6/EV/iwtiQ9fFKirB9ycmXHH/8BoGT
 xh7pbgeS
 jlvTIE4IWA3p2Xn+BuRwHdoRvGT7Wc3M3z+pb3Q9gjpl8QMRaI1RAb9gbXnoDE8dloYngsU/QWohTkoHLUKkSuaRHfjiVnrBrPt2c8UDWLbNzGGOhGyTn0ikc79Dw0FcBhzkhrLhUy2Cv/512njdBU05NrTKqM4XzXhylU3uwoRXyAM17PF01qXauzflSVu5Ug8EkE3qyPP1HsZUw4AMvVTyzGryucBhnAdGd+Q9rDjqmJ7A1lkOFCahW8HZwbm1EspIb6XdRU0AY6so3liKKlhsH3IG/yLbZRjjyTmO0E2szkQexPPCJS/7zd0P9ihbRfpdJ11OhM9JKZH8x6cbnB0th93AsI7QaggUhd8iQMXRwI2kyj70QDwAOzblStoKZcida79heRoxUZQlSO9qwf1mM8dYF4klcykfCF0R+U2xNof8SHuLQTnb6inRLdJRn+0BBBvBQuALUMP6lFf2unO8a8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Jan 2026, at 4:18, Jordan Niethe wrote:

> A future change will remove device private pages from the physical
> address space. This will mean that device private pages no longer have
> normal PFN and must be handled separately.
>
> Prepare for this by modifying page_vma_mapped_walk::pfn to contain flag=
s
> as well as a PFN. Introduce a PVMW_PFN_DEVICE_PRIVATE flag to indicate
> that a page_vma_mapped_walk::pfn contains a PFN for a device private
> page.
>
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
> v1:
>   - Update for HMM huge page support
> v2:
>   - Move adding device_private param to check_pmd() until final patch
> ---
>  include/linux/rmap.h | 30 +++++++++++++++++++++++++++++-
>  mm/page_vma_mapped.c | 13 +++++++------
>  mm/rmap.c            |  4 ++--
>  mm/vmscan.c          |  2 +-
>  4 files changed, 39 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index daa92a58585d..57c63b6a8f65 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -939,9 +939,37 @@ struct page_vma_mapped_walk {
>  	unsigned int flags;
>  };
>
> +/* pfn is a device private offset */
> +#define PVMW_PFN_DEVICE_PRIVATE	(1UL << 0)
> +#define PVMW_PFN_SHIFT		1
> +
> +static inline unsigned long page_vma_walk_pfn(unsigned long pfn)
> +{
> +	return (pfn << PVMW_PFN_SHIFT);
> +}
> +
> +static inline unsigned long folio_page_vma_walk_pfn(const struct folio=
 *folio)
> +{
> +	if (folio_is_device_private(folio))
> +		return page_vma_walk_pfn(folio_pfn(folio)) |
> +		       PVMW_PFN_DEVICE_PRIVATE;
> +
> +	return page_vma_walk_pfn(folio_pfn(folio));
> +}
> +
> +static inline struct page *page_vma_walk_pfn_to_page(unsigned long pvm=
w_pfn)
> +{
> +	return pfn_to_page(pvmw_pfn >> PVMW_PFN_SHIFT);
> +}
> +
> +static inline struct folio *page_vma_walk_pfn_to_folio(unsigned long p=
vmw_pfn)
> +{
> +	return page_folio(page_vma_walk_pfn_to_page(pvmw_pfn));
> +}
> +
>  #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
>  	struct page_vma_mapped_walk name =3D {				\
> -		.pfn =3D folio_pfn(_folio),				\
> +		.pfn =3D folio_page_vma_walk_pfn(_folio),			\
>  		.nr_pages =3D folio_nr_pages(_folio),			\
>  		.pgoff =3D folio_pgoff(_folio),				\
>  		.vma =3D _vma,						\
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index b38a1d00c971..96c525785d78 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -129,9 +129,9 @@ static bool check_pte(struct page_vma_mapped_walk *=
pvmw, unsigned long pte_nr)
>  		pfn =3D softleaf_to_pfn(entry);
>  	}
>
> -	if ((pfn + pte_nr - 1) < pvmw->pfn)
> +	if ((pfn + pte_nr - 1) < (pvmw->pfn >> PVMW_PFN_SHIFT))

Can you add a helper function for (pvmw->pfn >> PVMW_PFN_SHIFT)? It is im=
possible
to tell why pfn does not need >> PVMW_PFN_SHIFT.

>  		return false;
> -	if (pfn > (pvmw->pfn + pvmw->nr_pages - 1))
> +	if (pfn > ((pvmw->pfn >> PVMW_PFN_SHIFT) + pvmw->nr_pages - 1))

Ditto.

>  		return false;
>  	return true;
>  }
> @@ -139,9 +139,9 @@ static bool check_pte(struct page_vma_mapped_walk *=
pvmw, unsigned long pte_nr)
>  /* Returns true if the two ranges overlap.  Careful to not overflow. *=
/
>  static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *=
pvmw)
>  {
> -	if ((pfn + HPAGE_PMD_NR - 1) < pvmw->pfn)
> +	if ((pfn + HPAGE_PMD_NR - 1) < (pvmw->pfn >> PVMW_PFN_SHIFT))

Ditto.
>  		return false;
> -	if (pfn > pvmw->pfn + pvmw->nr_pages - 1)
> +	if (pfn > (pvmw->pfn >> PVMW_PFN_SHIFT) + pvmw->nr_pages - 1)

Ditto.
>  		return false;
>  	return true;
>  }
> @@ -254,7 +254,8 @@ bool page_vma_mapped_walk(struct page_vma_mapped_wa=
lk *pvmw)
>  				entry =3D softleaf_from_pmd(pmde);
>
>  				if (!softleaf_is_migration(entry) ||
> -				    !check_pmd(softleaf_to_pfn(entry), pvmw))
> +				    !check_pmd(softleaf_to_pfn(entry),
> +					       pvmw))
>  					return not_found(pvmw);
>  				return true;
>  			}
> @@ -350,7 +351,7 @@ unsigned long page_mapped_in_vma(const struct page =
*page,
>  {
>  	const struct folio *folio =3D page_folio(page);
>  	struct page_vma_mapped_walk pvmw =3D {
> -		.pfn =3D page_to_pfn(page),
> +		.pfn =3D folio_page_vma_walk_pfn(folio),
>  		.nr_pages =3D 1,
>  		.vma =3D vma,
>  		.flags =3D PVMW_SYNC,
> diff --git a/mm/rmap.c b/mm/rmap.c
> index f955f02d570e..79a2478b4aa9 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1112,7 +1112,7 @@ static bool mapping_wrprotect_range_one(struct fo=
lio *folio,
>  {
>  	struct wrprotect_file_state *state =3D (struct wrprotect_file_state *=
)arg;
>  	struct page_vma_mapped_walk pvmw =3D {
> -		.pfn		=3D state->pfn,
> +		.pfn		=3D page_vma_walk_pfn(state->pfn),
>  		.nr_pages	=3D state->nr_pages,
>  		.pgoff		=3D state->pgoff,
>  		.vma		=3D vma,
> @@ -1190,7 +1190,7 @@ int pfn_mkclean_range(unsigned long pfn, unsigned=
 long nr_pages, pgoff_t pgoff,
>  		      struct vm_area_struct *vma)
>  {
>  	struct page_vma_mapped_walk pvmw =3D {
> -		.pfn		=3D pfn,
> +		.pfn		=3D page_vma_walk_pfn(pfn),
>  		.nr_pages	=3D nr_pages,
>  		.pgoff		=3D pgoff,
>  		.vma		=3D vma,
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 670fe9fae5ba..be5682d345b5 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4203,7 +4203,7 @@ bool lru_gen_look_around(struct page_vma_mapped_w=
alk *pvmw)
>  	pte_t *pte =3D pvmw->pte;
>  	unsigned long addr =3D pvmw->address;
>  	struct vm_area_struct *vma =3D pvmw->vma;
> -	struct folio *folio =3D pfn_folio(pvmw->pfn);
> +	struct folio *folio =3D page_vma_walk_pfn_to_folio(pvmw->pfn);
>  	struct mem_cgroup *memcg =3D folio_memcg(folio);
>  	struct pglist_data *pgdat =3D folio_pgdat(folio);
>  	struct lruvec *lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
> -- =

> 2.34.1


Best Regards,
Yan, Zi

