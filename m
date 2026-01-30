Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 377EEE6BF39
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A32F56B00C3; Fri, 30 Jan 2026 16:01:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3FD6B00C4; Fri, 30 Jan 2026 16:01:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1276B00C7; Fri, 30 Jan 2026 16:01:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 539646B00C3
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:01:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FA0AB8292
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:19 +0000 (UTC)
X-FDA: 84389850678.09.CC39B4B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7CB882000D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E6UcUdsa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NxB9L+GH;
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DmSjnSjNlvsv6bVDLcrfSIRttLW42EvL56RuUYI4N+w=;
	b=lWGJSq6WDrVjQb0BunGEy5DEXc3tUoLVRYg+WhD219eAxdgjTVlqifCH8tpMyt9x1SAjKf
	MoQnvnXo44Rg9Rkura+GQBDvUvj7ky2rypzdnez8eF87ZnAlG4klcalTsLDrk7Z4wiCX+d
	GPd9pAnP8Ntts/P6gXDaE3gwQUC154s=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E6UcUdsa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NxB9L+GH;
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806875; a=rsa-sha256;
	cv=pass;
	b=cr6t64HLu8nvdb39PggYDSDOTzd5aCK0kt6N9mBH8m03UJkHhzUmvyT7d7927uzjKxGi4e
	oBDZIqgPvVBnT6CZOiKmUgBT4A9aQHR0BaJcgtE7H5qYvn66jL8WhSssT0cfR8Ya36apc+
	Eo8yrPXp8Qga7ysw7N61Tc+jQ7g9SHw=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKEXud610890;
	Fri, 30 Jan 2026 21:01:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DmSjnSjNlvsv6bVDLcrfSIRttLW42EvL56RuUYI4N+w=; b=
	E6UcUdsaG9rRLJXoGt1iEEKC5n3AEDipQuNXKPgbkrJ2WoxRXKjDIM17WphvFAwt
	URw4aQfYhVlfHF2Y0jUfh9nrfuv5RQ6na5QID6w4eAAzt5FuiKAN1iDVleeyFVmt
	El5sNF1bfDtoOjZtY3F+xBQ8NHNia1Z/N09b+GB1aFOQQBarCe6j6z9MqKH8U60J
	MogjBtP9rP0ztz/r0I1WW7wL2CMddkeBPBcpRcLZfopUN1XOH9Mj/9Be64Wm9PO7
	aWSVIepvUlg0OegOO8tB2NN/NmjICWET72VNC5P4JYJoQZsiiAJ4WWkpm9ThEP06
	YKabVSu/QbKPvWTDXbFijA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10d88bpj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:01:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UKeggJ035129;
	Fri, 30 Jan 2026 21:01:03 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013041.outbound.protection.outlook.com [40.93.196.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe4gwr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:01:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rUWGIX8C9QAsSb5GTr9GxlaP8t3Sg/dn3lvxyX48Yie/FlyEdWBMu3li9WYf+lc+uEvzNDachKaUETVi6hNklFM2PJF1nEmnjVTV/I07i2QuVN/6axuUZgo/kIJF1xhATbXZ/ypZTqLdeZKPDyz79JXiQ84LSFpeW96A1S4wE8RbTAVvtsMRwUchEq2qkswtklcyG5QXH2JTSGVuHn81BSiJHPUqW7GZgYAqFMD2fCYrmNMf4sVP62iLqMpCZmufd8mSByrKBZJ+pyIN+5tSiHllVTYSRXqRAjoZOIW1EMTxDrnXulpF1fygCImJYAFp2PFbBqV9/05M7ed98FaIxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmSjnSjNlvsv6bVDLcrfSIRttLW42EvL56RuUYI4N+w=;
 b=ucH9SNVubKy21wOP6Hd6DHj2SDQ+Ks2T+/nrN2/sgU1VlNUyjdSHlSgK6MLDMYlvk1Ur+ECTIZF0wXloHKLIQoXtTqSZyX/tyFlQhZaynJngn/+kpt/3S+sCwQFJ3jupsbtB7jtLaPRDN49MnHhXGdXuUyitNqgcRSVNjk23eEfZVvlXIOmsg7iy20kpRNtF+PHYU6n68nShP/aJu5s7v5vcB+dAEvbDI9fi4fV9avOMiM33lDjAZSf1GLvkM9D3Lw6wSRJ1lzsPNAAobnHzkz+aKkmiUmIT9Ht5+9841qO5Ms6FD4KReY4iBvcbXEogMgnp3bnqbThlOb2GPuTeaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmSjnSjNlvsv6bVDLcrfSIRttLW42EvL56RuUYI4N+w=;
 b=NxB9L+GHLYLMFUbm1G73Ggc/Kl0qFG5ujn4lUBy6UhNn7KYRbjJBshHOigRyUk5SFzOYehMik9YKNSsiN2/HMTvaZ5n7C+yvmRKUQ1jII2/6LNyI36b63UO9BcHW5EUdVKcpoicw5v56hyZ6DC1ry1NQJZPseJEsGrOv/kKZR9s=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA4PR10MB8541.namprd10.prod.outlook.com (2603:10b6:208:56b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.12; Fri, 30 Jan
 2026 21:01:00 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:01:00 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 28/30] maple_tree: Pass maple copy node to mas_wmb_replace()
Date: Fri, 30 Jan 2026 15:59:33 -0500
Message-ID: <20260130205935.2559335-29-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0070.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::16) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA4PR10MB8541:EE_
X-MS-Office365-Filtering-Correlation-Id: d87799d0-963c-49de-2908-08de6042abb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QYMHZ4G56DWHqQs7qraB1JCLyzPnJYDQJX7WpbFLCZwp5upPVAxfpG1Skigj?=
 =?us-ascii?Q?MmjivTfx9ODrrYn8b7oPIZFCZObc2/f4vR0apyY8j1t/ki3xzr1IK4Q4TFDJ?=
 =?us-ascii?Q?zPQLwAn3or1/0V9IxOPQxH5igM/YJxpFSkqNpQS0+pc3hcF+TNmhfvw4hVF4?=
 =?us-ascii?Q?5VN29+REHBhwQ5Clmz7OF41FwYzu6G62jxkrfPWHmAWcDXmrsbhevm5Q70Pz?=
 =?us-ascii?Q?jjSyegXXv7vPfWn3N/a27X0zMcp57DLRzDjXKpGZZDd8heHL0vfvOd0f5KN1?=
 =?us-ascii?Q?kcVHsRuh1H7R5ZuN3egvkl7ujVV/t++Z6XyFJoN1unMxq3HKMue4nnIVl9dv?=
 =?us-ascii?Q?xGcBTeuHMp/xbiFIEqGFo9WOC1DbTEIx19uv15Ma3k1/pYvl2GrFrEQZB6ta?=
 =?us-ascii?Q?Gnt9Ggdis+w0zwYeHc6eqth5EXj8DJarmMUn2UBwDxtZFF5FHgPk4AL5GdGu?=
 =?us-ascii?Q?om7kAtSYTRY1k8zjWEOSLI04c8YuE9zAyyD82cxaT/FFq/dk7ZVmn03tQdjv?=
 =?us-ascii?Q?8/JBuSGjSXyS0N3uk5rTnquRq58loUHNBzIlngVt5zMC0QSfl0X6RzCZGwxz?=
 =?us-ascii?Q?xFIXIouAXbyGiL6DqZn2blTU98anmjJBgKGvcbVcpKl2+EpgQzVp6m7Tq0f2?=
 =?us-ascii?Q?W17ebOmFRI86KmE5GMQhKgO3cQjXqXvH2JyOHysUVAUHWjuJJZV6HqhXG9xb?=
 =?us-ascii?Q?tuMAwvk4TiwPj3i9p5dJBRzn0OMl2wMOmo1nf8V+KNSyfNCvSyilM6dab4rd?=
 =?us-ascii?Q?mHz7014vIoBWj1xYk/52M6j9OQ4xaxSpm+2Ilhib6hz3+6KzKs4Xzh0kYzIW?=
 =?us-ascii?Q?J2tx6dhVvmOWZo9iA1nKPZ6cQQ3OhAiafqVh95EX4sjme5NnBBAqfDqvieQ2?=
 =?us-ascii?Q?1r9uKEUKzlsMRb6l2QQpYv26KelhArqeASOZREyz07REaPE5s7EeFRiDMbqv?=
 =?us-ascii?Q?EGc5qEy7P6Xu3woncfQ8NbFywVh2waCOtVciGsU+g7tNxeszyMxwvut3ZA+p?=
 =?us-ascii?Q?OgLNecrLa5tHE+/sNRU1giUx4Eb8/zOZUltrOHeZoSBLZPQZRt3bmNa/Ygce?=
 =?us-ascii?Q?yjpVRMuWWyn9cXjm+GgGxgdpIQuenlQYnK0E8pVrk3VvYWefd+f2qzcARdAj?=
 =?us-ascii?Q?/b6UG/6r38B7Hc5KaCxUi0Cut1aIO9qeBSvrE4+GVQKi8qznqLcayGCzR2VN?=
 =?us-ascii?Q?Q3YFHHsVa9mYK40RHEJe0gKEQPPZsDJ0SiknKBcO1QCbWBew8mxffzXoskyA?=
 =?us-ascii?Q?4reizH+b7vAjbUtqLFUkcZRX/5FkLSz54YTxXIHDyVmzjXdoPQgtM/2nKsva?=
 =?us-ascii?Q?yxrKPDgsCqWvd1hN9dsmV045xlHCG3ddyeA9zaFrLu6YDwPJQGzD2OSzAPJ5?=
 =?us-ascii?Q?z/iWLL492Dcakj0ohyxDENGw/9doZ996ChgqMPg6WWoNI5jHeH854J50v7aE?=
 =?us-ascii?Q?Ordp/kB7V23+G6WA4eNtVYGFqlHBfT6PcRaR8m0V6tbtBbhHX2hWUvMON+No?=
 =?us-ascii?Q?T1n98snf7Rd/NNhqALai7UOmEHysgzyI26bUnLTDdTZA84Y1UC8erbio4DTD?=
 =?us-ascii?Q?AykTTIawFQxhmJewzZ0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZsM0ZKJD4QU7CdVGZf+hRRirLyjQkg3I9jKOM2TvTif+2fcqsrrj1SyKwV5R?=
 =?us-ascii?Q?tvy4Cal5NyD5f3OBnrzuvfOVyf+ZAVu4kjkPaVX02Yy5cyL1VIAlbLb5RnwW?=
 =?us-ascii?Q?pdJTqLXUi0q0zfAf/NGLSmhm7NPtzkad4ziTXYb/bgMvhfJNQ9kqJ5gdpOVH?=
 =?us-ascii?Q?lydNWkSJzsFfxFnEx1AafRicheixxyax07027UH2rHVIuxMhx4EHasC0hicr?=
 =?us-ascii?Q?lGI81D6Lj4jokdBviGcz9GiDSV2+hu8h5wgr3cPBpiam6+y3Q81Accs2wIpW?=
 =?us-ascii?Q?/hLv1A+Digv5if5YIUqNP5/CYGlcM2Bm608imLJJLRzf/9gNKCbT3Uf4nYFg?=
 =?us-ascii?Q?zfRhO2InhpW3jj1JXHmV70z5FlyEQcu2qE8Wsm311tjP3KfDX1QjW1xqWNyM?=
 =?us-ascii?Q?OI8DOYWxs1iAjB4PVV+xtMEQzLBhUBXD3BL6UgIJ41SW/0ElhDhzBkpTxHFc?=
 =?us-ascii?Q?cIklyRu5Gw8GnNWu3OBqk/AIeDGcu10Ew151mt5Gof3pc+Qc9YPuzzHI5thz?=
 =?us-ascii?Q?QuV2gM3sCur70ClWq6NxaFNs1TGMgbXHizEuS8e8GCHyYE8Ra9VG9vMLn8ZG?=
 =?us-ascii?Q?1aT7FRyZgVPyvC9e3Z/a8gzbvHRPPX5RTlwfmeWgRxZyXgpOSxuB6HsrlUgx?=
 =?us-ascii?Q?JsBYvvkEk+4rOnMgugNgW8lOpNL9cokdpyZbOE8KlmxRSMLpOIupwSkm/PhL?=
 =?us-ascii?Q?N4tPQHX5vrW9szNiIeBqThJHSs8Ced3OLOEXbWbMi6oZo9ku/AFudxWMDYlt?=
 =?us-ascii?Q?htJJyfu+I66BfgG318UdLA5eS4Kjp72JrT0h3LtSNbUPd1T3C5u2zHVOiyhI?=
 =?us-ascii?Q?VBTcWuVML6L1aZh+31FdtAx9A1IAB4P0YSzmMOGTf92aVaR4p4GewEvk5JGE?=
 =?us-ascii?Q?UwEuYEEGRK8byz/n3aFjrLJ2VWrl+DVTv8TfruvaQez9lH9Y97VEldPdow9w?=
 =?us-ascii?Q?EPiMyYDypLY6JafyE7LeCJxbUzT4LioCiWMCBoO4hUsMz912mk42ZirLtlEP?=
 =?us-ascii?Q?CXRcgGYHvICOB4VzWwNLmmUtRhsD4dkTrb58JEenNgF8uGe53wSwHIhgOmz9?=
 =?us-ascii?Q?aT/cIrCGPJVuAgjMZ+4EjPbOMD2m5QUMaWmSvrw96N+IbOFX+SUs8FIoTAIK?=
 =?us-ascii?Q?eC63PAp4qEcQj+06EQRDgesQFgGEhgxViJpfELdXSqF8YO4UfATGh9MjXML3?=
 =?us-ascii?Q?2Rf0zqivu/48dDzBcxDGimGEecNQlTYBM1xuJG8x/ystRn7B0vxQnew1ZeaB?=
 =?us-ascii?Q?hKcqsQj7Py21NRuEsoJJM/iNUTNpTopIRgheo5cAoXJ0HPTNZfJvS2L/og6W?=
 =?us-ascii?Q?sRgR5le/CFTimj9hxxypdWIxNqYiUWE4DLbBKLXvN2CNGKJClXkOLMdwDdfE?=
 =?us-ascii?Q?/EzYfSQjRNsH3KbLeIW5z7i6qdFh8hMSB4PWpn7oxn/TzxzqGe8LQ/44uh6h?=
 =?us-ascii?Q?4PZilzS8cJ+tts4pTeOaB6tMmtqn1gfLTVOlY4lC/ld4c2VuCcDwaaWuPZ/p?=
 =?us-ascii?Q?CifYsjFkjqhBjwgDLC8xQM+Cx3JR0JTa1+VqNSe4RXWtlYz9TSjsOruhimeA?=
 =?us-ascii?Q?tE3VxplJXtiCEroyTL+KxlXL1pwaBGqJvQh9UI45iyiwZz0voCVfvf4p9mHy?=
 =?us-ascii?Q?/uBEMFhPAYHAGiHA0/6A0ii/Pc8eh68BHu0zr2O1qqLtBWldfBJXe3IsI0Vd?=
 =?us-ascii?Q?wpjCxbn5/dx/xZ6OEisoWF5MXnatAdunCPvXtjohBo7IHspvMesjmMP3msfA?=
 =?us-ascii?Q?pksV3O7Txg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gn2Z5YVd/yXmmYUt2TqE4j9KeRhmKgtOjinlVtiUnQa/JVj2vo5vlgze3a17jMPE2MN8mfWo6Vz1oOtEYlC//JDzcEXMSrN0lyXEapYPD09+92b1X1a3SkT3kuoFS+E5Iwm+ca+H3KrWMnBsu8p9NZN8CzVPudOK0zmbYngbsESeu0h3dF3iYvwmp0TbA/Icb7BkpYx+LQGrAoM852cTdnWqDLYJDnh5lj9Bcg7/BT4eGLzGE8AoRTvZW2u5fKomg6bJkQWdCd2BK1lC5ELW/4gbPMvssZCcW9zLaFCvkpfP7CPkpPSioAVw0uhgis0/B/z8rVNfZFNGGQwm2veof7bVJIywMacyuXYXGZXsQCXKDvigMoPisnBGvFmtkrIOpcVynzb3X/kxJbMDLmxDLL3BZO4s7jOvwd3U4A9jEiT05nQRdIc5kc2XlxWG4hrnIq62UNZp+ZX0eEHXzIDOXVh92w5Hr8TAApTDT/Y0SbKXQ54VUdBckgboaYvjH4uEpRE66J1S7qy21+7f5xh+ycfOILhl/7U+2T2ze7RYdfH+0O0Hw8OVZb9jaumWVhC5Oiy464U8cfl6nhSE61lCqSMDQ67PDpXWX0fXuR4SXDY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d87799d0-963c-49de-2908-08de6042abb9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:59.9354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qDU3ZA2WCWek//4bxLdgK8klfF4AXWEXhTiiFR4Ihu6+Ym/xlvPm5RWOJ1UGvI98oQ1JfxiuGyvaiLxxqLPIPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8541
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300172
X-Proofpoint-GUID: 9dk52KpPiqZhbMOuawenVRSS2d9QSRjg
X-Proofpoint-ORIG-GUID: 9dk52KpPiqZhbMOuawenVRSS2d9QSRjg
X-Authority-Analysis: v=2.4 cv=YuoChoYX c=1 sm=1 tr=0 ts=697d1c11 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Syb4SKakgNXmRhdLsicA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfX3t73UImnZ9Gd
 WoB9QuMHKiJ0X7mGzADfroZhxfdkO9YV72+3NqaCd1vtHCkiBSOhpaNKWvzvBGEw00YfEGlB6uz
 hnYsfL7lyQZnzOeoybueyxtBfa6vISPINAP/dZmcnugxyXy4TSXK2caIAlfTCmJm1COp+2Vn+FG
 uVxIKdQecUsGGfEUWmhSxSm7FyTCuf1mjI9c/M9S5qSakS1WZ0k0eegq8CJPbTRzCA8cVOHDiM+
 FF4JoY/yGZsSW1DhoZgA2lxE5FG8PC2ykXN7vkv+RDqrhmpbdYk/2RCxezU3J/eDYziv3AAY3Wd
 SBcxST7V0mC0LQaDLcY3ayCXB2zAbSK9FNWsV1w05ZpjOy79wywZVfEdiH907vM3lQA9qMf5As1
 VH7g3yuTNCq/GCPjA4Ldxzr6YLgXz0C0Yhiyd4MBU4fOqGRgwHVy2+CemM+V2aErLpOepRieGit
 ElfT1DwXVE7pN//fmHw==
X-Stat-Signature: jdjmtmkem1yj33zdqd7o4ifejahxoqzf
X-Rspamd-Queue-Id: 7CB882000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769806875-780854
X-HE-Meta: U2FsdGVkX1/lY62V97Gc4ZZSFOqxf+HugqN4c4gWytG4OuJOtdaf3AoaXsXqlJOWERQaLX5W61NCxVvXtBg10uxtwFNm6v4nUj99AdxO0A33T7YhMYLXSPMY4ub2ttcxtgKxZE1jIjMbzpA/T9VdtCsGqRqWu+ljzGPZw2cMk7p2whHGrAigWKaae6M+OXbOo2HaRyQWM421efDK5NYGYJWPcIqQ2pocSMfJkxIDgbWZy+N/ObettrQEkyZ6g17HVDZuFjC9mBI2QN1lDAHyz5SBsFeO7kuU6cHQY406dOGJmMZ1EhUh0ejYi4ETz4Gl06DGXIvAotCrpinG7NDnVNSmq9UkQUIBlYW4VVNOrlsakMCm7lzBO1jEs7x8phIUjBwUbWjhzwFcn6ysOixmMICUJnyz0Sxnnct5nGSSKOPnrwBVAZ5CD2b9Mop4Qlm1xpvZLrCdhydJTubyOjd5ui/5VELH005E9YByqZISAQ6MFjDpGoyNKYi8jhkWBPvmEUg/aO5ZnL4pfRRCZYT8Vjc4xi8EcimZj8R3Khs/OIKDEZVC8s8lbt9MIMUvj8eNSFmj7qurdH0eliM1jkAsK5oOF+xbB3pSmjys3Quk6EuoHv6bz3z5w2sTCDDhWTTL3SUsmpfbM33Gr0QVKYNsakvN0yqDYlXUS5M06q4qNACg32tPWrrlC68KpKXbK4cu4i0+YMIr8gQ9qOY1ml36t9tBwMI+6awbSthD7EJ47eGDgjlN0OSp0djySN743bMK5AF5tdIwqcYna4Y/R4oSPoJrFn2RalN0JZsno1Q5TJnqH88O/zfRAqdQRTnEu2GbJQ52i3cqiRd1BTsFxdevmCiQGJ0meox/X8gaBk4JTog5MkH+JpaTIRjPF1GDriPrastixGxELggPY466K9voWK2c5bJlxwxa7qDNnOPunuwoRM18Qof4VgaKeOTpivTqnllvWHibJ4IqzoqdX/U
 P03hJJ6H
 Z5lz2kn/F9X9x6j1vLeH6IfW5g7d28FQcl11aIvjGLfi1JlSl8pu4XrH8Vw2N5Zk1OZJx8YtAKhvQXYDz2fcl2mU/IFNCGwi0+1Y2CE/qhZZJPglMJM0z1VgOuNslVj2FJX8ZXcPXGkn7zlPIGaykcqaoyazYqwYvAF5gZmEw5mwXLp8achbtZcGwgBn6f5tbebQsQhQV5JYRn/JVq1op/xW5uvL0AkDjg+Z4r0hIxhrTq5MyYy1nkVU1TEGU/UfG56iLAB4BYeGvWzduSEi9KYux3UOCaI1RjtsUktzroZxxuR5jhPr8hTJ+zEexHgQsbvBO0FgHetk15kX/cDZKxh/rwiFJKBYSh/hwQyXvcd2rE60SvBWpPq9kQHDAuull//Huwrg6m1OepeIic5brZNqeP+Ufmi79EVQDFvww+nV7TF3ug3ew6xZlsURcjRvOSpgyjzWohI/ymbjriflTwuL4n6UOevqGHJMG7W4R8L1WYs+J9/yi5W+q4TZsnCRPNKYiB5o/4MJu/TWWwDh6XJGPSCTndMyB+CZWLKEKLLYNmyLyiaMv8EToI5Ilc0OzqO9h66Ce7D/9qYu54esLuTpLofWcn959uIpNBKnasbeQVNm1ww3QFawr22MuK0NaqEGtAArhfRSfjbaCdw7kwfjjzpFQNY3f7/2qbLt/9JO+2nJ61K2lGD2PaTDhh8qSSHItuZuzIe+YFRR3gRc+hafPLm1LyCSzTWUJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mas_wmb_replace() is called in three places with the same setup, move
the setup into the function itself.  The function needs to be relocated
as it calls mtree_range_walk().

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 60 ++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 1cfbed6fac9f5..064357a44906e 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1900,26 +1900,6 @@ static inline void mas_topiary_replace(struct ma_state *mas,
 	mas_mat_destroy(mas, &subtrees);
 }
 
-/*
- * mas_wmb_replace() - Write memory barrier and replace
- * @mas: The maple state
- * @old_enode: The old maple encoded node that is being replaced.
- * @new_height: The new height of the tree as a result of the operation
- *
- * Updates gap as necessary.
- */
-static inline void mas_wmb_replace(struct ma_state *mas,
-		struct maple_enode *old_enode, unsigned char new_height)
-{
-	/* Insert the new data in the tree */
-	mas_topiary_replace(mas, old_enode, new_height);
-
-	if (mte_is_leaf(mas->node))
-		return;
-
-	mas_update_gap(mas);
-}
-
 /*
  * node_copy() - Copy from one node to another.
  *
@@ -2086,6 +2066,28 @@ static inline void *mtree_range_walk(struct ma_state *mas)
 	return NULL;
 }
 
+/*
+ * mas_wmb_replace() - Write memory barrier and replace
+ * @mas: The maple state
+ * @cp: The maple copy node
+ *
+ * Updates gap as necessary.
+ */
+static inline void mas_wmb_replace(struct ma_state *mas, struct maple_copy *cp)
+{
+	struct maple_enode *old_enode;
+
+	old_enode = mas->node;
+	mas->node = mt_slot_locked(mas->tree, cp->slot, 0);
+	/* Insert the new data in the tree */
+	mas_topiary_replace(mas, old_enode, cp->height);
+	if (!mte_is_leaf(mas->node))
+		mas_update_gap(mas);
+
+	mtree_range_walk(mas);
+}
+
+
 /*
  * cp_leaf_init() - Initialize a maple_copy node for the leaf level of a
  * spanning store
@@ -3044,7 +3046,6 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
  */
 static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
-	struct maple_enode *old_enode;
 	struct maple_copy cp;
 	struct ma_state *mas;
 	struct ma_state sib;
@@ -3112,10 +3113,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 		cp_data_write(&cp, mas);
 	} while (spanning_ascend(&cp, mas, wr_mas, &r_wr_mas, &sib));
 
-	old_enode = mas->node;
-	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
+	mas_wmb_replace(mas, &cp);
 }
 
 /*
@@ -3433,7 +3431,6 @@ static inline void split_data(struct maple_copy *cp,
  */
 static void mas_wr_split(struct ma_wr_state *wr_mas)
 {
-	struct maple_enode *old_enode;
 	struct ma_state parent;
 	struct ma_state *mas;
 	struct maple_copy cp;
@@ -3454,10 +3451,7 @@ static void mas_wr_split(struct ma_wr_state *wr_mas)
 		cp_data_write(&cp, mas);
 	} while (split_ascend(&cp, wr_mas, &sib, &parent));
 
-	old_enode = mas->node;
-	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
+	mas_wmb_replace(mas, &cp);
 }
 
 /*
@@ -3470,7 +3464,6 @@ static void mas_wr_split(struct ma_wr_state *wr_mas)
  */
 static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 {
-	struct maple_enode *old_enode;
 	struct ma_state parent;
 	struct ma_state *mas;
 	struct maple_copy cp;
@@ -3501,10 +3494,7 @@ static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 		cp_data_write(&cp, mas);
 	} while (rebalance_ascend(&cp, wr_mas, &sib, &parent));
 
-	old_enode = mas->node;
-	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
+	mas_wmb_replace(mas, &cp);
 }
 
 /*
-- 
2.47.3


