Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9922BE6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B0CE6B009D; Fri, 30 Jan 2026 16:00:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52EB56B009F; Fri, 30 Jan 2026 16:00:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39BA96B009D; Fri, 30 Jan 2026 16:00:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15FD86B009D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:00:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC945D4D28
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:48 +0000 (UTC)
X-FDA: 84389849376.15.2EF4149
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3CE43140003
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qOUksuf9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="m/z9ctXY";
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgkE4OW0KG6KU/HEahv4pxM8DZ5R+yPd67+MplgFSU4=;
	b=TuCfQL1S8beAZO+G95Y2QbQb0O+o7Dd+qmj4V9y1s8tPPsZneQB+TL9z423patR1xQDX5P
	GWzj7VGqq616GC5/P+FEIGhfjeUympwzBAX/W59928UYGUCbAuUNFdlnRAI6rxRirySzLk
	MMKsNurL8n1kkTkteGgMb285M8SZ3/Y=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qOUksuf9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="m/z9ctXY";
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806845; a=rsa-sha256;
	cv=pass;
	b=bwyVSjMuOctPlJBPnzUqx/cD+NBMJIVIJ6NtIJvY7Knz52Nq+vgXLrdvu29rvKFdMe+A3g
	99obNy3GbxfVfDVE7gyqCPS2PUSbl8WNiYlpLyzjjaY/WUjlFbwhdI3Hnodm1ijEDPXpti
	j+v5WMnmqCaAqLR3qz+4GlrAMU5yZlQ=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDSfM3732752;
	Fri, 30 Jan 2026 21:00:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tgkE4OW0KG6KU/HEahv4pxM8DZ5R+yPd67+MplgFSU4=; b=
	qOUksuf9lmtXUSXrs6ZQYE2/esFSZjosC4B0hFpPodb4yk+fuHyzqi2Q+pXxbaLG
	/iDHaaeoX6ocwWLHNIMYTOg4ndoFt2POFYYNnPnz8USwF694EIXUgozCaLHkPE+o
	c10LTzDVAElqQLdonBzCnGcWIg2u1xGRZLSltCASBV/0pdPShAK/mjev86BJ2rWF
	f7lFoIIP3C1C+wQW+a+hD9NghSuwu2GIvW2EmRajvyiQIUQX1jHdWmKq7h8yZ0j4
	cEGI6eTgjiFYO8SAaDh0INM3tsGMnVW7a1eyC5dR1eMcLnl0lU/UCZK2CPHRCe0k
	b5NuPvfxGwL42hplyLp/+g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by5t6dj6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UIkbKG032726;
	Fri, 30 Jan 2026 21:00:34 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010008.outbound.protection.outlook.com [40.93.198.8])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe4g0t-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ldYg38l5Fv96vrYO3MgZVyY/AJPRmc34jF3h+6SZ5IIC56pQBRBLk7LZgrgOqFh0JkIVH88jrEDFOEwAUHqrNx2n0BJOUF/nScxiTbFY50cuEOxnc2vn2hFLJUJcYFISt7eIMcLX1yYvJQcY4nGASUtFXRCNzD3DwCU0jSqmgSVuijUOamz3I/OC43YJ7toW/1VxgLbBGv5GmV8A9qoxOf2wA7O3435gM4Ja9b7ryBTmYdAPzs9FDqYufOc77AerLJZRCjF5eHdqoU++fqa30Npk/lpGE1dt7JoitE7mekIMyTX+xbuodcZSBjpcuBB8U5wp9YL7Uc3S2wrSVOuRFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tgkE4OW0KG6KU/HEahv4pxM8DZ5R+yPd67+MplgFSU4=;
 b=iN+dvJkNST5gmSducpAk0vWYL9rElOOmNm/LzCN2PB4y7i7aAg6ieIDd5FkJ12he6vCCJdbtfpUrvKuyyQWOoErc6uRBgtIv3iJ2FoF/ODtdf9l/T4GIZ9OA9Q9arhyKWuSqQyw1J5ePQ3SsZJEKVJ5LfxYry25sWbnvL3ZwEgLMhdVtooWIYJHJbaFPMDVuamn9EUC5afJhi8wSMd2shCbOk21dg/CAtIrcoS0v6srkMH+nHHwYAp2JStGGRslAm7eGdCbWdEsorsEtEJnb/diFw7N69hJLX7szJGD66n3eRzjuyfR3u8A6uTP5DHbybQUnnMuHN0MZy+CKrLn1cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tgkE4OW0KG6KU/HEahv4pxM8DZ5R+yPd67+MplgFSU4=;
 b=m/z9ctXYK2VWu7NGeDcEPTD5wG8+1s4ycMwBgSpdVxq22Vy7DcSJpACwQaq+sYW9WtX9HKKeViNIV5c5z1wO5JjGJM8OqXqYKq91Qn1kVtokJ+xi8ub1Hflt+cmrY0fetNpydZqVbCe4FWAm0EPKVXssEreWMdYPMRJuUMx39+8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:29 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:29 +0000
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
Subject: [PATCH v3 13/30] maple_tree: Inline mas_spanning_rebalance_loop() into mas_wr_spanning_rebalance()
Date: Fri, 30 Jan 2026 15:59:18 -0500
Message-ID: <20260130205935.2559335-14-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0038.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::16) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: 761fa455-e1b7-46ae-3bce-08de604296d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sEDAB9ilB7rbXdUWUrnlldvrKn5CQDLmjk/rac3GRrfmKr8oS+m9kB7G7Bkc?=
 =?us-ascii?Q?yDrPucEB4qNQYpAW6MdeDfbZWQ0N7h+PzskCYzrb4eLnB7cg5vLtjs1BUu2b?=
 =?us-ascii?Q?bwKoawM5e47gdUH7iBUci3r1b0REmkA3dwAkAm9yd51maFdVCGdR+8yABtuL?=
 =?us-ascii?Q?DrQptCjMLF1W7CEtaya/Xw3FBW3kgx5T/g/qdpeziJUHtI5j+sSEXAMlWX4i?=
 =?us-ascii?Q?k9wyheR2mNBjekvMdj+v+BLyMgJigiBBhL0VGszLbiyxql5mubUObrUkB3t7?=
 =?us-ascii?Q?z3YJea/XB2qk7EbukD/PqbnlofNXjE/2wKbjSx4ScOHAVl0yabJY0jiQS3uq?=
 =?us-ascii?Q?ocHfOn2fXgRgG7gJx8Np2nij9xuOHqRH9uRRxDkJcCt9ZeVseGTzLBl+4xeh?=
 =?us-ascii?Q?9bS/a0is1VR+PLyGRIcwTvvB9E5qFR1HOv7+nWd19vfDbDPKughv60wlCuzu?=
 =?us-ascii?Q?wwV2bXuXb4lev0VPghRatQFD0pH0FtNzITSgkzveGaMlkl8e479/G3RZ8XKJ?=
 =?us-ascii?Q?lHSkf2Kt3RJZ43rQ5vHIffMiu1BF7laS2B9I4HFwoU9DghDLKo7d6Sc2bYRU?=
 =?us-ascii?Q?BrIyBwSnFTWDfHxmKw6rMsSZjbO7/TrJ46nnN0dT5MPLgJCkajmWvxAOkOne?=
 =?us-ascii?Q?Bv0LyXr/uyxheafNkIVRif2wVhyixI1obTirUvQH3s3QVs4Z16mgfm/hZ7hi?=
 =?us-ascii?Q?z0dJL1MvkcmWAbKYFRyren26mQ6IEM3UV/FTL2qBA9pOsuAFCMxCaXpo5bFG?=
 =?us-ascii?Q?YoL1LqRL3qd5U2NFZyZH4h21dRYZotnUbLDXPI5rYRSC2qSuTuPlM6KW//ip?=
 =?us-ascii?Q?MyVXBKOtKuNFL+jbLvN1QEqLFYx/CynJuWxbMwRTY/tN6GCzkaDrcJWzNjJj?=
 =?us-ascii?Q?THiWN+thN55uuaTfs5RjJl9wvgu519DlsmJvFdqGaraJ4gfFDAYO9y1v2hdo?=
 =?us-ascii?Q?g0JvOF/G1G6pAmmHjiE0HI4+rQt+ySTQ5hE/IcyrpHRB5kEcveZUX3oe14RK?=
 =?us-ascii?Q?9lDOUxGPjMppQ3tG4DTjrAuGDxMKDiaSkA9+82aDyfd4Fd0EnT/z7p9/O9Cw?=
 =?us-ascii?Q?iwJ17wRsUmI40PgxZyAXqNU46iDxkE3Bm8K2lkIb9XazJ9P1tdupAN21J+hv?=
 =?us-ascii?Q?WmIJmX+imzab9woh+PfF2cYPSNjM0ddGY+RJqzTnKrIFrBqN2W/EkIllJKM4?=
 =?us-ascii?Q?EPHzKHbOshaN6iLUvHsgF4hrHHZdoNDfUnsdw8W3TPrhddvZe96+d2e2Vbpr?=
 =?us-ascii?Q?6oHCo6PjRdvmTlYn5S7Fi+XjQgUdvmA7zHxxb03+glYfLViaXyjFvwxCffk1?=
 =?us-ascii?Q?+arIZw7XaQ42rpP6fo0ARk3MUY9cS9KohQJ8pUlSNQd2XNJrfagl8wjZZiCb?=
 =?us-ascii?Q?6IFnKpV29Kp+xI9s44tY+z0X9ml6qiAbitd786IreySwDU1VPfsBUiC4Xw/L?=
 =?us-ascii?Q?xlAT7xILfvVoiTkZ5fBcLzUlQlgH3AW443zsCNmFb8JBOY+efHFxnwYWs300?=
 =?us-ascii?Q?zvecE3eK4G3YYXSZ3Yz0sy3ol8BC9j8I2yIBoVKY+WFn7hivqnffMoItDaDz?=
 =?us-ascii?Q?PTJSYWH8jsJIUEcydoA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5dQ46g0PwRHa+q1Sg29zOSO+8ulbmMNlvawac5ewh9PWTLZ1ZvYTchbfRFE6?=
 =?us-ascii?Q?pgs8fjzJJQ7wb4kashqFy/P/XpMdYqh6NNlVMfYghaV4RgCKXhFZjB1L41QD?=
 =?us-ascii?Q?u6dpGgaIkhoA2+7H3W2Xvcx99QHkyOYHQS3gFjaXGogydKI+AdJlG8p0vLoV?=
 =?us-ascii?Q?lxQAJYZf9xSMZ0ImDTDcs6UaIyMVHA2oT4mF2u/7jUBxQFIOz6N4GP4YmLM7?=
 =?us-ascii?Q?ooray+KJSQqLN6+QxfzIR8wnp0XdRVns2D3pNyax6Vx/6dhhsX8Ftnr7HgLY?=
 =?us-ascii?Q?bMpBWueyNJQ/IxEd9Ij3AI+oApc3bWn9vXugZ/kjXVSbppIBHv6j4s4q1BVm?=
 =?us-ascii?Q?MVQ68pt4zm5xSJMZOOUB8R07Q79QPmr3ls4eI1kh+i6FOMoMYjGTtPK5zc66?=
 =?us-ascii?Q?+Pf0A72JFbSGEjtealqrKSP9qBKRzRBoAToYpLo2RCpa4Y2bys0atR8Qb4iE?=
 =?us-ascii?Q?IMR30kVpI2D+smanpV611zo3RzEdlXOMe9DJIv/DTzBLNQxOi1r8OrdB3WrR?=
 =?us-ascii?Q?axJuBYWdMgqf6la23hjqngE6ReYXUWlZQUebdZPvYw6YXrO4GdqmBpZsN7mb?=
 =?us-ascii?Q?w8vABtu/187K+2726aXGxfb5AEBf0okJIgVKZbJF/MFAS30DNk2rh3AVOHNK?=
 =?us-ascii?Q?4/9erlg4MgJ9Kg+q7oeqV5HzLFbUip5P4OJmCskDo1sP7QtY3rheMULWd+zN?=
 =?us-ascii?Q?Dtg4FGm45jpsW2yFEMI0M1iCiRbTA2xhRFB9Jd829aRiiMvPQ7m90mnA8pxh?=
 =?us-ascii?Q?6SgvfukAd7fmQgzNIviPTXZDCcrlJ+DQIRoCM6oUDVMbIRWq09++THWxdCRB?=
 =?us-ascii?Q?Jlz04QQWwB7MtnH9WDr1EV6vigIq2LaTXL7gtZTfdtSZaVvv9SzoyRBbwiPg?=
 =?us-ascii?Q?qa43i/yJp4uKMguzTepCarXMroT6m4nKiFQIdEgflur7MpY8oQpbAWVYCnI4?=
 =?us-ascii?Q?NL17DXJw/A+bZE+ALE3ypmuOoGv4ymPNzMz1n8pZEbtcBd33UJ1NcpCsoR55?=
 =?us-ascii?Q?N0wiMEMxcRC8tGppu4ys0lFavcy6tYbZxy78mUKT2PZdQgIxvkmUKkW6FLjj?=
 =?us-ascii?Q?Rm2Hkxuemsv1EbnYhvRATqrylqgkvKXD/UP2zWJ0GXilltIZwuouUgC0lJrI?=
 =?us-ascii?Q?4T0JIUXoZynxNo1YE36xkYfWxdtiV2goaRq4Nbpe2MBhBRJ1jgfLxL0Tfo90?=
 =?us-ascii?Q?3gGhm+DlDuUePkMwMXWbkSMVmtAyXb7d1LwJGqeAbB8YabbAQKT+2YlAhQ04?=
 =?us-ascii?Q?6lU/w3uV2m7qO/hYkl8N55yTAjoceXs5noBx9JmF/iP+/lfSbOCNqfpyGkam?=
 =?us-ascii?Q?10kMmhUjnolCIFfRizxLAKBH+JrnMlJ+5P9OV3eRW8BLalV1kcfBWvZDcRB1?=
 =?us-ascii?Q?F2gOPuw7UkDtqjj+t9IuQctf4SMZ/42QFTGRTRYAZwyQdkROnMDKUGqBOVI/?=
 =?us-ascii?Q?4zbkrO8McljjQt097DGgpupfbtI6XOJa6DjpqBJyGohHMCotwct0KhNpXTbY?=
 =?us-ascii?Q?OhlbLXpqB9Pbl9/aP3tKpBnFOGCAndTK609qMUiwc2nbqt1UeODUpe85r4zE?=
 =?us-ascii?Q?rA9cfoPJyY9Fs89eF6g6+S51kIuy2c6GdkaX1j3LTxbWne5gHLmLO1QQp2CG?=
 =?us-ascii?Q?uUZCnnowtMj5SWlvbHSZfSl/NAVMtvzeTApyfqla5XVILAW5pIu07uSm3me1?=
 =?us-ascii?Q?Zl0Z9JRgGpITRoYcgp/stiYALuzhgH4Zp2orddtnouL9FftquaFYsDRWOF6z?=
 =?us-ascii?Q?N2lSzOK2QA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cuuxvump5y7DOhP0gsPfJeoXz9a9tE1CAVZkS1hRcByPZ0jP7zoV7ypV8NYj6+F6o9ziZSrtKieM4D3yC1fJjPtz1ElecMMXHZxnv5hgfghomMyyHRzuojrIO//l1GLBkcJdsuihEkni8gkl8oEW8kJhWqkpd64QLWVaFMpHTOJlzZZUkeaT3nGjCOHffqxTrI3zoLJIxeQqAIh6jMj5PBvg5Em3FRDLMhwe4XOcqi4NLt6VudlaZlgSOy6rohqXb83puFk/Ctor1brx/sAMh2D1H7DHQcN66AiyOo2hixqpOYGZrXeTMQte2hUkr3BNI0EzHKIMiuX72npOhXJEJj8DU3H6aQYoyexLfAPhzBK55UbqHkrRhrS0NPbJDR2Db+078MrJ28QBrJXgvUPSh2eD/AiHXUGTAh0mpue6PB4nMo6Wc3Kg8pvipjewhKzqTJsdOd+7ViVa/u4hufn76D8hXkUHW8sPQBSHMKyemB18MOZolDzsqmsT6ZQga9ZWTlnKCVvVoj+kk5JjIPPJsgWE04W6m3/0+pYuxBJHssVqPmXj68A3OZDMeey/eg21gGJpIrx03guiHqvIzocWbEcMavPt0KOVggnmEKZsM60=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 761fa455-e1b7-46ae-3bce-08de604296d7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:24.9013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w0VkgcORmyALRFimJuKo/xBSpirjjlHxpozZ9KdDXRGwNmOKmopcd7hHNIjtCn9CKf4ZW/Yi9hURDdPXPf4/7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300172
X-Proofpoint-ORIG-GUID: hUWun7F-Tng_NVpukEmERx6OsRlvbVtA
X-Proofpoint-GUID: hUWun7F-Tng_NVpukEmERx6OsRlvbVtA
X-Authority-Analysis: v=2.4 cv=IIcPywvG c=1 sm=1 tr=0 ts=697d1bf3 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=SVrgk92_VGy3w6ovwu8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfX8MEiLZBxqmkr
 d14JxkKWRx+SsVjRjC0t9eRhq3hEmH5oj7+R1DYLZHTRPlpI5px3djdDZYL5oEzi1M+3TDYy8J0
 uEMG4hLs2GZ1DDjhQ/dn8hwFEVRC1Qxu7BGtkvP3zQJeIFD0+fgBs0A9jYyA6MMaim2EbER4CbC
 fNZXqF1qap3vhKT7H9xK3OmceQWtdcedMImjOTw0n+fSCD3mQmVYQO2SmtwfN0j2xGPxvnFHxUE
 421/uEPF4uNXDqoGYDrJsFW9xEAlXmKk3Tyvn4tTEO1o6gBo+Jg70ZOt12JKzdRMawWD+X9h11R
 fisScszUc2xAVdJQk1bfL++iLFgYqgBt7R+NttWHWA4wktRbb52wZAJ/7LPr3PDVbMR2XzsZtdV
 bug3MMzlMZIEDJ0dQKHSH/KXzt9Wv23NUq17KPnO9MiDBtKV11kdx8s8FD3M+GCMKyL2f9WiNmw
 vnFBOf2MNnko7oaNzbQ==
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3CE43140003
X-Stat-Signature: hzajgs5jthor4jgoaj3c69j3saayjj48
X-Rspam-User: 
X-HE-Tag: 1769806845-594813
X-HE-Meta: U2FsdGVkX18ofrjqfimhZaH928+aIcqa7G25ArPiahDUrLvdSGfC2K7VZPsFyvhawe6Sq914cO30e7Yt5RzTgwHV4dbWZ7lasatYZw2Q8six9vQyscnhAdo4z4gmIrXt3B0gE/nWD2pNrx0LoICmHZjVOLxwbEGSqQBCWKpo11xcjx8k1Iyg8EhWP/I1TfuxKA/ED1RkMjceXa3OYHpGikN4X6VqzBxUX7cqTWQagO0Ev591KkSUrfqjo9SkRjNDyTrAWPOB4RoXaGX+R3j7+Jg+ZHT2UeqOO4O+WK7mZkB0O0Gs9J5gAyRi4BFQG7PwNypmb0aCuRPHK6o3FO0HH+LzRtJMT4DIlDEDSEVq3dXEdBO807K12fYYrgc5MiU+f1E3kWW0fqR3JoSRcDKZIM/2ZxkE2YHAes/Enuq/MZb1TThRbZInDJN3JDzYuIrxZ6iiF498QvXJ4pMHquNoXEUcOxbicYTKKaLzUD2WSSCWDnyml4zcZf6ImcVexDDo/1fTeMvgpT5zu+qyj02YkHRfy0Nqu6Ur2RRpIUTfXd1piAzfAID6Zy9xsYhEiuuoNFgd4ZeutcmvKaQwd8KKcAX4vG5C8w7p29foT1ghxewrf1mGve/50Qc4brAZ7EZuKIy37SDQtjhIjs40IcptsxKqfjwklFoqFWflI5/JL3LyspIiuXvgMBDzw2pDfeZOOqBwbB2PP7svHIfAuh/nvmMaZKXehELBn3lU+eqt87U1vsLKJnUT4HJbRxC+XqsL1Zjh87v2rRk1q4Ah5yivxtPDz4nCCcT3to7Q3rYXxh4vQIulDVR6kjW9zUiu07OBXJUqKIsrjnZC6tv1Zz4xB6GyU9eaC1tWXrX1e9s9XBgJ6DSSb8gfmWgYhPV1RNRH6dt58uQNLv+t1fenuaUxsSvwkJ9pU++/8CBs4EQrfD6mAOJJzGa1fE53300+fYiuX8BMtSJdpI47N4glhlb
 63LwW0v7
 EVvYZBYpacKyN0qVztCdoMiUzhXXP5gMAkg9n/2KqBtPWv4BswhOQhxYsEdT2kxrPvK99mn7OnanK+wVzRNy6XzB/WiWim8/lYjcpEUi0e8hH5TXINoXUoQ+rnET7M9XwWDHo9Yi6wnPPyAo1kBRAMRVPqe/tCAk/iUsRqkxHG5LWgsM+1A9FHwNHbTG2edQnutCt60jbLIYPymYlAS8TzM06pEp8bDdc+nXomu+uDfNwOiAGoFbIO7kPbBXcZ1mnJ/rMMkR1jHIX3HPL6uTHbK/o4KMNZX8EHnma8tseXh+xqs3aJLVqVJ9bpfRE55065R0oYa+o/oJqGIxbKP6CIttvhfcFjbuQgyC1jrGp8gBL2udq7kyTSfSfa1GWRDhF8V8cDLXYiDCT8XOy90Uf3zBAd31bR+d+0uIEBhrrDBOeIj6ny7GEQUwODO8U0WsIhZ4rplpMa+OKpMdwbv6ru4E23D0TBlFNjdcafc8fKAXnPzKnBWPVmavAeyUR/x73K9QUknZfdN8Op9HfbJTcUSod0IM+LKG6p2u1FF4Voet5ISC45vQ5Byg75XCyxGnglBdPKegkuYOY9rvAWIPbw1EVOdrmdzegUL2BK04Tbg3W6qw8R2FYjaQGIqeUGOL/oGQmh/VNUKQ0WUvur8Aeyt7DNMkGAAv9w0So5y4hoUP+ZqD4dDTrjSFAIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just copy the code and replace count with height.  This is done to avoid
affecting other code paths into mas_spanning_rebalance_loop() for the
next change.

No functional change intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 108 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 107 insertions(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 554fdffd6c5b9..a9b7e398c7dbd 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2862,6 +2862,13 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
 {
+
+	unsigned char split, mid_split;
+	unsigned char slot = 0;
+	unsigned char new_height = 0; /* used if node is a new root */
+	struct maple_enode *left = NULL, *middle = NULL, *right = NULL;
+	struct maple_enode *old_enode;
+
 	struct maple_subtree_state mast;
 	struct maple_big_node b_node;
 	struct maple_copy cp;
@@ -2917,7 +2924,106 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		mast_spanning_rebalance(&mast);
 
 	height = mas_mt_height(mas) + 1;
-	mas_spanning_rebalance_loop(mas, &mast, height);
+
+	/*
+	 * Each level of the tree is examined and balanced, pushing data to the left or
+	 * right, or rebalancing against left or right nodes is employed to avoid
+	 * rippling up the tree to limit the amount of churn.  Once a new sub-section of
+	 * the tree is created, there may be a mix of new and old nodes.  The old nodes
+	 * will have the incorrect parent pointers and currently be in two trees: the
+	 * original tree and the partially new tree.  To remedy the parent pointers in
+	 * the old tree, the new data is swapped into the active tree and a walk down
+	 * the tree is performed and the parent pointers are updated.
+	 * See mas_topiary_replace() for more information.
+	 */
+	while (height--) {
+		mast.bn->b_end--;
+		mast.bn->type = mte_node_type(mast.orig_l->node);
+		split = mas_mab_to_node(mas, mast.bn, &left, &right, &middle,
+					&mid_split);
+		mast_set_split_parents(&mast, left, middle, right, split,
+				       mid_split);
+		mast_cp_to_nodes(&mast, left, middle, right, split, mid_split);
+		new_height++;
+
+		/*
+		 * Copy data from next level in the tree to mast.bn from next
+		 * iteration
+		 */
+		memset(mast.bn, 0, sizeof(struct maple_big_node));
+		mast.bn->type = mte_node_type(left);
+
+		/* Root already stored in l->node. */
+		if (mas_is_root_limits(mast.l))
+			goto new_root;
+
+		mast_ascend(&mast);
+		mast_combine_cp_left(&mast);
+		mast.l->offset = mast.bn->b_end;
+		mab_set_b_end(mast.bn, mast.l, left);
+		mab_set_b_end(mast.bn, mast.m, middle);
+		mab_set_b_end(mast.bn, mast.r, right);
+
+		/* Copy anything necessary out of the right node. */
+		mast_combine_cp_right(&mast);
+		mast.orig_l->last = mast.orig_l->max;
+
+		if (mast_sufficient(&mast)) {
+			if (mast_overflow(&mast))
+				continue;
+
+			if (mast.orig_l->node == mast.orig_r->node) {
+			       /*
+				* The data in b_node should be stored in one
+				* node and in the tree
+				*/
+				slot = mast.l->offset;
+				break;
+			}
+
+			continue;
+		}
+
+		/* May be a new root stored in mast.bn */
+		if (mas_is_root_limits(mast.orig_l))
+			break;
+
+		mast_spanning_rebalance(&mast);
+
+		/* rebalancing from other nodes may require another loop. */
+		if (!height)
+			height++;
+	}
+
+	mast.l->node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
+				mte_node_type(mast.orig_l->node));
+
+	mab_mas_cp(mast.bn, 0, mt_slots[mast.bn->type] - 1, mast.l, true);
+	new_height++;
+	mas_set_parent(mas, left, mast.l->node, slot);
+	if (middle)
+		mas_set_parent(mas, middle, mast.l->node, ++slot);
+
+	if (right)
+		mas_set_parent(mas, right, mast.l->node, ++slot);
+
+	if (mas_is_root_limits(mast.l)) {
+new_root:
+		mas_mn(mast.l)->parent = ma_parent_ptr(mas_tree_parent(mas));
+		while (!mte_is_root(mast.orig_l->node))
+			mast_ascend(&mast);
+	} else {
+		mas_mn(mast.l)->parent = mas_mn(mast.orig_l)->parent;
+	}
+
+	old_enode = mast.orig_l->node;
+	mas->depth = mast.l->depth;
+	mas->node = mast.l->node;
+	mas->min = mast.l->min;
+	mas->max = mast.l->max;
+	mas->offset = mast.l->offset;
+	mas_wmb_replace(mas, old_enode, new_height);
+	mtree_range_walk(mas);
 }
 /*
  * mas_rebalance() - Rebalance a given node.
-- 
2.47.3


