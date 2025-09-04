Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44910CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 15:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B0168E000A; Thu,  4 Sep 2025 11:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887238E0002; Thu,  4 Sep 2025 11:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F208E000A; Thu,  4 Sep 2025 11:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8358E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:34:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0101A119183
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:34:26 +0000 (UTC)
X-FDA: 83851964574.21.06ADB60
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7C7F0140018
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:34:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GH4+KzTP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iwe55haw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757000063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HT+LEk3heZ4IxKUxfvB7dX4lWLLSI28Df9TtAqa5VoE=;
	b=f7nbtdb3+iJ2jjC0QFfUyWd1UXt4yEXrccjmZsbTFlAF5YbQT/I/ApyswrtuaKGT2izYe9
	s6gpUNSVXSyHtaFRsyJxNesw0H7a9d3s2js/yzu7/4k3blI4vuGQbZOMLZRHlSfrFykqsq
	RpconAm4zIOtCc7MEd0qARFARpXJNIg=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GH4+KzTP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iwe55haw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757000063; a=rsa-sha256;
	cv=pass;
	b=R0FFxRXSPq+kDJe524mKNL7AWxZq9P7VIKK0MKXBP4QzLG3Y3VYkwxFXUwC8e1AmZ6Fa8u
	Lx4KSMA7RcoWBWXgQQycM3yg5a48rm6taP609geqwXkSISE3VgTQNmc1nCJ4+E1cCUUUCF
	FpCJf17EUdT71mHf3K+OO+A6vFM25SY=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FJdkh018913;
	Thu, 4 Sep 2025 15:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HT+LEk3heZ4IxKUxfv
	B7dX4lWLLSI28Df9TtAqa5VoE=; b=GH4+KzTPHkkePHqGhKoeUirpd6hcSiK4hP
	cAPn8fwReqCmfZ5we5Ziodc1HTj5wZ0fUWFXOU2Yk4RvOhwZIE8mLrYMk0WjwnT1
	7e/PLS/1OsKFoozZxY44jqFxJ8p551ytD5wKM5ApS4NdWBw5Cnfo+cNChA18GYXD
	IU46/rcMVXNn4D/l8+OMn3RJb5rEvXr7/WBzVGp9ZWhvwGHbO40eUJONmDXwQB6g
	Z+GbSnUu9+I6QoouIeR20yESz/Gbc57jjrV9+pVFHt5gMTwS3GdjHzocXr6MFEGd
	+vjBYgxWZFReIdDo3cgTGRZozeT0wjqFTLK1ErnKOmIP50FNhApg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr14y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:34:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584EGmkw036112;
	Thu, 4 Sep 2025 15:33:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrbprru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:33:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xAL88CfXQe/DfMtTEXHLPaZWCAASd0vm6q4nVflb0Qf4R0Hcs4xoHTXPVgOhO8AERTXUjoV+DbafqwU+HrKkc//GzI8J7Os9rttzb2Uceno1aUPlcKyUMmo9Fat46GOBp/+PmxKeax2+bHh5u5gCdxNgOoyz2wCNsT6rqGIMj0VlozOPd04Jtp1VhdAyg29+HAFzSu8Zv4VIgnG3aUxbTedHgglhdCVB1mdkOVNA+V4+GOvKM+nvSXQ3b0ATw8hRGDUhHCI2/lcZAAO04VVI0/1VB7QMjzBUVqT6WOHpc8jl8f2/4Ojko0fDat8/OERu3ME2ZCwajvP+GJ0mghQ/jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HT+LEk3heZ4IxKUxfvB7dX4lWLLSI28Df9TtAqa5VoE=;
 b=WrZKh04VhsOT9Q73nzF34gRDPNX+irPsL/HvnuiHtKjYgxJ3djOdaRq+LA56gqFPoAoC+dH6DnlQVcXb5WG2AyYrfNzG9g4eBbcCKF8B+rBFzr7a3zbhHt2ut/x/PEQiZEdvudnubVx9Hg2QeYLTlR24gRr3iXV84CKt99aeoQPPNcEYmHkLR9iS72/2ElAfRVnIA4uLAWJmGcLQPZJJYq/G0Pa1ewjhJ9TOh4iwx9J+Nqe6JrNcrzxI0F8LjLegECUKXSpwL8DhWUg1zLJRLEeGdQiNBTAjUSusvp+RTKviAhkd+TUczhqTFXHDQ0zvDdAf2HUOKLCEnCaWgiHq5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HT+LEk3heZ4IxKUxfvB7dX4lWLLSI28Df9TtAqa5VoE=;
 b=iwe55hawcpGxrdmfNycVe11FkfgVEG/J6I2nEdYBFfE6EYiIM5jg8iAU4DxdoVx1YOKhAqUo/LuPPGw24cAro1DREXXRzl8Sp5rEm5Yjm45wp7RJ59KGb37yUlhj/GiYfw7YLEMnYYjdbK2RElahvLfL5zVFZNlNgJbClGSZj4Q=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN6PR10MB8167.namprd10.prod.outlook.com (2603:10b6:208:4f1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 15:33:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 15:33:55 +0000
Date: Thu, 4 Sep 2025 16:33:53 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 4/6] mm/memory: Add tree limit to free_pgtables()
Message-ID: <a558f789-8c21-4e10-acc6-fdcea110563d@lucifer.local>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <20250815191031.3769540-5-Liam.Howlett@oracle.com>
 <39c46a52-f63a-4f3d-a276-6f59c55680ba@lucifer.local>
 <hs5nuhqzqyt5mp3fzznuaiyyck6b6ovuxoxayvm5ofhoa5324m@gtmezuqareiq>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hs5nuhqzqyt5mp3fzznuaiyyck6b6ovuxoxayvm5ofhoa5324m@gtmezuqareiq>
X-ClientProxiedBy: LO2P265CA0066.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::30) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN6PR10MB8167:EE_
X-MS-Office365-Filtering-Correlation-Id: d66af2aa-04b8-43ce-6291-08ddebc87596
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+fpKD9/Nhub0zqEcCIo7+/RCN0LO4nYeBNuDC+D1YDjPTexACiUbW04d78R3?=
 =?us-ascii?Q?og2jHUSnLFJ+mCs8i8BZmTOerIGDveeDLWK5ZBmQuQDioIpD5qbWUx8b74D4?=
 =?us-ascii?Q?Hinvzcmuw72kUNh8jALs+y1bzGNVWtJ7ryXdlYYHOC6ZoWoQ8YW3rz1oOBCA?=
 =?us-ascii?Q?/jwchrDLAKzHd/ew3q1cuh+3NgWiUnviwkpADEUYrNrcmJhnnyxbVZnBjpg1?=
 =?us-ascii?Q?gtehVmq0q5bgEP4LYz/1z2EC6xQHg6EqjlbR84A7gGiAepwKGYXB5HULEw/H?=
 =?us-ascii?Q?Yi55lZsFpFygdmVBKa4VEgC/Xk12qzMyr4G0qCbBf3zzCum5r9YaHivAQpYd?=
 =?us-ascii?Q?s8gENLBpvIzfTXA5FBVHBQ3by7g+iPLcJYO/6SzqqV68iPQHCRCXTK86V65G?=
 =?us-ascii?Q?2uGUGeU/nL4aSNxz6goDa5GWjJyrYsZoGzzDtnZvOEdDXa8ezzuM73PyxOxG?=
 =?us-ascii?Q?1WF1EsZmvyJmsciNWrtLbXI7TjolUqw1PPJ3l/Hy5aPS7/zwZejozu9RE+bO?=
 =?us-ascii?Q?4zR+/hvrXcTvt84nmvkmZp+3FqE57kbHIbEo05kMJBTFrNkR2A2cuX3PIeGa?=
 =?us-ascii?Q?fKQzULY6ns7S0EKJ3njypI3jinYdUbGUFobDtHvbxQmYs6x/oqEj+kGkF+h9?=
 =?us-ascii?Q?89rd8/5+JAZG8BEBrDVGUp2vvZhjGBz9rdgnc1Li0ft5Mev36+CwqbOCgQ1K?=
 =?us-ascii?Q?rUsdrOby+K5egSKKf7WRQvM8pfUoeBKoaMH548PugCbuChlFst1gJ7/DHJbp?=
 =?us-ascii?Q?oYpMT2XmC8IFX2igD/g1azCu/DRK/Cm74UB2zEpQ361Quh9oczbWGdmUjlzO?=
 =?us-ascii?Q?TOEYtr6CnSdeB5jSbWAg/k1OAAlbyBJXJq0uCr7fz3K/bXoMwmU+O3P3xm6s?=
 =?us-ascii?Q?G49adHV/G/ODJiFsuFY8tBpxbmeVE9TSIS6QbI6kAnrhgFMzfB1eN7ikDX/U?=
 =?us-ascii?Q?IfG4aoBdb5OCaZzWWJRA09r5tFYE/Hk0N1sPRL+FNMYXBqrrUhNGXUf5Vfym?=
 =?us-ascii?Q?lnWzqNjEZXlGvL/h6FvnUOTIGYwucCPgzjbvHfKfrVYnWo7ScK0uqn6wxnP7?=
 =?us-ascii?Q?9ccnSQerPEFOvnQJ0t8Zqwa2ICCSWnYIzQrs7oEtKkPRMcTA+DAcFTFno5ah?=
 =?us-ascii?Q?y5/g+oEPkKV/6GslzYE61R2zQN86yNWgWS2W4e/Z2h6j6pJP4ec4+yB9REsg?=
 =?us-ascii?Q?6WN7MD+FTi+At7H+tkYKA91pOhApUgjp+HLF8zJ88eR5G5fr+6q2cvoIr9S8?=
 =?us-ascii?Q?M60/eSrtWmjUZARpWi0dOgTNVuOK+wTVjfZ1ruYYWfServ39vILecdOivD2t?=
 =?us-ascii?Q?t92uRwweQeA64ytJ6TcHUNM9okkACg5VTkpZFlF/1eZecgeJVLjpm4tlbpNe?=
 =?us-ascii?Q?u5/EYQYo9XA24SG9TyaoODxQbi/tv/BteRa+D4IN4W/3M2CEfcaKYfN4rXz3?=
 =?us-ascii?Q?lC4B7z4Bl5R0HPJrg763EGifK9OG4Y9htBamSZ+IOPFsf3b+2IQRJQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L4e217HpcWmSvRKXxzywbo4qhZrKjKGKl3VALxhikCa91CFkmLoczUw7FB40?=
 =?us-ascii?Q?nfg/2+YOUSBOuBX7U3j3lsH7QFGYjqgN8abPM4TpuZhiQGSzzqZZHrkkOBuI?=
 =?us-ascii?Q?8qA0fuGzvYVlJiOLghvEZVfV9KCk9EcW0vKZu+cqqLTRiXvIynWj2ul++BPY?=
 =?us-ascii?Q?FWzkm+oRMsdqxOdUNglTerrviA7cxCDIln+cScKF0p1EFB9aJGm4VGsys6if?=
 =?us-ascii?Q?vJQABL8+MvENE2vENr9/dcJ5lZbdy6F/JgWekJ0pHWVa814bc2YGCesY5MJ/?=
 =?us-ascii?Q?aU3tK++gJy8u5FTWPZYxjCnB2NBz9vjRlykMAsqQJmVdPr1EFGPQj1hV/EUj?=
 =?us-ascii?Q?mAdQhLaQGJyxL748+6xdTlpBM9ihGRLnPzxgOBRcxBdd8oAlWtFOjIjZ3RI2?=
 =?us-ascii?Q?wp2Fqnz9jwYgdMj897d9ET2xIAOyYVeF85ddTZcWH4FMyX7ANMWvX7mDD/dh?=
 =?us-ascii?Q?n7HSEhFzN2cY42R+sPOed4++NgOZS/y6uRr/9TnibG/oc3e8WpyD3SLCTgu2?=
 =?us-ascii?Q?VsWNZpUUDWwVz5l1KREa1uIswspAOSf28tPc4kxyo74wsSLcM0bZGZ9nMvTt?=
 =?us-ascii?Q?7oRC0qbs+PlMvWdS9lP6+szMilNYJxq3sqr7bdeaqKtg/k4343hSgdtM6mB5?=
 =?us-ascii?Q?XVpXcIMXwgy+9unFp6+96EtPrfoU1hg275A0/7tOkaNX/u0AWXhLCuZdgbn9?=
 =?us-ascii?Q?opfHR1YzxRR5E3QpgRkN73L4g2QkOKxmQXwfF1+16KcPfwFwLoTrwRhJQ0Ob?=
 =?us-ascii?Q?PJLuAQKW8/98knV/laCZQvPjxVeAqPzrRFvlPub+Sexy6u8zPcog+eUciIzQ?=
 =?us-ascii?Q?LLjmipjOMVr5Y/Uv1SltttstiH5rmL2JS5BwfkTlhhmG7mKVKPTS/dsoLKfT?=
 =?us-ascii?Q?3DFGLk8EwC9IarOcHaYVJ2z1pWCZgRRrEIEaRIYlJAoW0GOolpsYihkgBBgo?=
 =?us-ascii?Q?e2vyhuN6aH9ADiJZXku1qQTN4WQnT5zlUX8H93M/l6+nwelJtc8NWnef1V9K?=
 =?us-ascii?Q?Zv3ZBUmYb4Pxf3nzIdUMtVb00C2R3VA7udYKHKFJm+MnJ7SPIcFSAwEYGsOD?=
 =?us-ascii?Q?/p+NXPcPFmCgBszwafeQNfAQTnCJbosPw2qSDdBMFuAkTcZE1JdYANKKv+yV?=
 =?us-ascii?Q?zd3TAUdJfSQtt27deX6tuHoksn3op1Uz38htuqa50nZB4Dn5whQ5Rqj7Sfbd?=
 =?us-ascii?Q?dgqYrt7lg7aqSPF8PJeWcfDFz19uIX7Gh7hqDVpWmY9PTrIBl6bPEaEdggjD?=
 =?us-ascii?Q?gog1J9YiEtaLzbIanvVthWj7A3RfqpfNCxFh5IYHpLN1rfjfLjyIdw9XN3mC?=
 =?us-ascii?Q?vcxiMf5Is5k+BZpV4Po2ncNWx1Vso585ZPuiMdfIstaYgvT5HmbAxby7Kjfu?=
 =?us-ascii?Q?k7XmUKzGkywlGgoXueQfDuXm9i+DMR7CDWLUP8m9ncra7apcHHhkKeb7ZVRE?=
 =?us-ascii?Q?V3DGJw7XSSQKWpVXeRITFEwd9BUL/nEoGgIv3P39f/SHGpjKVU0eaz5+ammD?=
 =?us-ascii?Q?12ohz99kgeOx1syj+OVbtkup+e/8apZtNip5geY2nvS3VbTIGJrWO9dxT3VQ?=
 =?us-ascii?Q?70m6kyfHSLW41DcrgH//5OMdDGgjJ66+fq/uA99nlBsVfLhiNgZWGaF8mDJp?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5EdTudx5XONB6gTIldBqHFjs8eNozf4Uf26w2o2kMCb4v8WB707n7wwBON2SoIhIhM7PKv16HHmaRPiMCIJm1hH5yrGWQ0gsS8B6cMn5bEeR9bQA/l33xpJvUBhtz0JA6yjJsw4BIpUJRg82HYPb7lz0FFLHhvwNyhwCeXYl0VzdBzKZVvFUhPw5GMBuF7ZM3avki5+kQxedWtDQD548+4gIKgIjuMQKdAkIfVeNWnm04rPykk/3bjsPzanNG4MMgEj/Gxn3cQLPShmOgkkMfeTu2xnuUk3JfZxb0yqJpWeC0eQcw6AsTLf0jyVpt/SAAmGT0pResTmoJo0G9NdhsT2At3SBMn4hgdeHkT9B24vVKanlDIzwEg2Pk1mEj+TEXPVktDnDyWmy01/gGL2X1GXGRJhy6AfwtCqPO7Nn/aM7pmucnyv4URvsuTLqME4qfPYwWwWhngnyN4avG8soeB9aFHS8CxWXPrBjMwIHAt3qX66nAJ2rp+svs9QwH9PEBYbV/O/xJvQfCDS6UQCIOrH8vt+6VjvE3+2fTIUHMzbT0lGdxXZubjb25DQ30d9+JNhApd+7/HjKIFBlk28Pe0qFZ9kSDxohNMb8Hchysb8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d66af2aa-04b8-43ce-6291-08ddebc87596
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 15:33:55.5862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bm4poEzuF/bHyAO+NcWOEXS2bXg23QY1ixq0cE9ZupJNKv437CbyJtyu75UtNGR0pxjJqu8nHxO3/GmxGpnuKOS0O93lcsx5aXRJkyuOPKo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8167
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509040153
X-Proofpoint-GUID: yswo2T1UI8IKhEptynwczbf5zZPhBYeR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfX6PGjyL6A0qVb
 ffN6REmF2Hgm3vY76vVZr82J0w8soZOwcbcqssUB1zjs34JOypiVgybqpaQ0XRIFqhoi3wTISft
 TBAxU1ElXO7Iyf5WaaYz/vrbkTIJV1FyT3tiPAol2cQp0WffC3IjjrPOwBUgRIJ1wS39BsNsWYR
 q25qVxIms8aeW+UBrKfZ4J1eP+c1jSU+DachOAuGmqLi8Ti9ohAHlPYv9KTtN56xCBVjgKvuuzN
 KCqSeqaHfyJBmpjngPXuvPaUsx2b4HNaWoFUx6ZnLPi/ubZbRipy1iz9M++eRS28L8KLJuCa+Bn
 8KhPV+RbHpgYOVq3WE8Ry8/CZYAxm+Vyl6CJhrCVtS70AYDPyz6kOYlgViDekdB9+t+Mx85Nr/3
 CHdkqIBt
X-Proofpoint-ORIG-GUID: yswo2T1UI8IKhEptynwczbf5zZPhBYeR
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b169 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=mUkYA2rUojRMVsTVeJQA:9
 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7C7F0140018
X-Stat-Signature: 8ts47yoo76a4ogpqjqq13mf3x7tu7oau
X-Rspam-User: 
X-HE-Tag: 1757000063-963087
X-HE-Meta: U2FsdGVkX19Iwm9FVJBw5pEPgPRBcaQTHU1c3kiPb3eihAuZ04w9+/S8FeKkR0oXFviI/mPYcTR5av5JnjmlM4kI6wAVgv2Yc2WihG7YNaBF5PzoqNi8jAIDK9ggVgj34l76zuNrsjgVCIkEYEY4ug1gBCj7ZjVxDiv2zHU1MUnnNZ2T1/kXkGEECY45EO4AEXHKSN6QYUbDKEnm79g+BGgGr2S7c1UZZpaQuI5Jx3lqvkaWtib1zqX33kvYT5dyFi+Wtan5XYnkvoAQ38q92ltbimTWZXHaGMCX7UrCNNbXjdt00g8EAmnRvX54T/qA6cpOoDiIeIo35kzNgatoTyuYV8hMVmCvBOW7l/PpckKBJEla1U2jespcsIo+g05dkKJiOPcCAYhv9HpgyiAl331OxCxuQrGK6O/AirqjB6R7cSffqetzZQuGnCHXlLKr6uHqbFAZCaqWF209mU4OEx/GMgDTZlTz50vwh3s4ivbR83OXKkszx/5XfX1abxeWXgznzYWXf8J1tSCSfj779IFDXST4OKRE31BMuZbcoAsaeDpjb1amFgNSpZjbEtbBAqyQHH37tJ2KbONnhExJc3wc93nYw6K8GcBhUsKVLhdsDdMRthDkw2vT84dpIrIQAgFzjBCmIvuXe2XGdTe2hVPhTNNMb7eCPbGxQmylpFFJpjAoopO+SshOgGJmDJPaLOD8u/2sYMuqqDgAQXDqhW0MgKkYJFUGHOy7MRsXs8gEbRlO/8IQSG6pWAoIFIBkeC7/Hhhhhn6nqaayAC8AXB7i3D/x/3LnUElsSNIDYeBIb6L9j6q6Dz9hVW0hjuZCaorHIbHUvUOFWY5pI4lMplFLP9f82lhv+7vuXYfO98Fe7YB2TXMIzxJz3lXCj3c7J3FZW10XNrE0AC7bx29PA4ZIh49GSwE5qC//aJmsA7yQLut3HE51CMKtOyvCdqOk0gZHvTaJl5udMTbOg/z
 RWY6pn5x
 bd92tacSga1EPxjrf1T0EJOgTwf7Fn1+5WGtX91V4zW+PJSg3sOpsOWwK6SI9UXwRIIS92jFC+0EtpU3OTNZgazEJtbsjqty0mARcO02OGJdNfxG/WSH63M+vY5bd3hiuqGIlAz4GrLtnpsIEhNXVRtIiuoQExNNzSXIrvPEL6FbnK0PJQ46n/7rPvoBEgk6kPjYNRVVvH0rze8/TDJwUVFkLW4SQBsaIfw6zbIXeHfD9AAFSPkaf2EE9DENS3zx0mL1n6zYrbnkiVgI30uWBqUNllpKemmNFVWcWMzDTt0cgc++BCZvJ77Pz2ZH2mZcVOR4d/mMSKayNJBvG46rfib7DKNiyrlTyqVc6svIOV8gWFsjRaNndK0OeROYEQHRT6utKjLBLq/vQdgL07RUv5NWPY08QeMR25jGEQjS+Hg0so1dNoSCTDiBTSRvQ/MIxrWDc+yXamG9mzAAQC2PvIKAWVUR6ZtHfRlYdCc27zddULqGr31t3T7rRcFtgXybuS/jExDrEFkjYlryehRbqpnHCPXQrb3AW56OEnZ4wCf1jiGjoacmTHQk+EmcTBCWW9EgXgGqiBXJ7WcMCi9+eH1+mvZQ8NfXLC9BcV9UoClZj4NCIMqGbP7nRFZUFK+uiE14BLwWaidRSA7MVHpdMOTiHgIx44z2TOXDxYRGd7ZCuwUEdH4jyRpHT55ybDJGLhWreqxEuEN0t3CWagwh06KR5NOJfxMjfXyzpYwv1LUvr6alCScNMGlV3mHOfi4q5tA4QJF229bM6umIl19moE1CApn5mbMfsgtnibfuRa7Bacftue7lgZ8yHgj9YIDZoy29s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 04:19:04PM -0400, Liam R. Howlett wrote:
> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250819 15:14]:
> > On Fri, Aug 15, 2025 at 03:10:29PM -0400, Liam R. Howlett wrote:
> > > The ceiling and tree search limit need to be different arguments for the
> > > future change in the failed fork attempt.
> > >
> > > No functional changes intended.
> > >
> > > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> >
> > (Obv. in addition to comment about broken VMA tests :P)
> >
> > I guess intent is that if we discover any page tables beyond tree_max then
> > we ought to just wipe them all out so, in effect, we don't consider
> > mappings at or past tree_max to be valid?
>
> Actually... there are some archs that map outside the vma and they are
> valid.. I think mips? and I think lower, but yeah.. it's needed.  This
> is why prev->vm_end and next->vm_start are used as page table limits,
> afaik.  This is a serious annoyance because it frequently adds walks
> that are infrequently necessary to the vma tree.

ugh god. I was vaguely aware of this but that's gross. Very gross.

I need to document all the VMA weirdnesses smoewhere.

What do they do this for? Guard pages or something?

>
> >
> > I feel like we need a comment to this effect as this is confusing as it is.
> >
> > Could we add a kerneldoc comment for free_pgtables() spelling this out?
>
> I'll add a note here, but confusion will probably increase.  I'll add a
> note about the tree max as well.

Thanks!

>
> >
> > > ---
> > >  mm/internal.h | 4 +++-
> > >  mm/memory.c   | 7 ++++---
> > >  mm/mmap.c     | 2 +-
> > >  mm/vma.c      | 3 ++-
> > >  4 files changed, 10 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/mm/internal.h b/mm/internal.h
> > > index 45b725c3dc030..f9a278ac76d83 100644
> > > --- a/mm/internal.h
> > > +++ b/mm/internal.h
> > > @@ -444,7 +444,9 @@ void folio_activate(struct folio *folio);
> > >
> > >  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> > >  		   struct vm_area_struct *start_vma, unsigned long floor,
> > > -		   unsigned long ceiling, bool mm_wr_locked);
> > > +		   unsigned long ceiling, unsigned long tree_max,
> > > +		   bool mm_wr_locked);
> > > +
> > >  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
> > >
> > >  struct zap_details;
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 0ba4f6b718471..3346514562bba 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -371,7 +371,8 @@ void free_pgd_range(struct mmu_gather *tlb,
> > >
> > >  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> > >  		   struct vm_area_struct *vma, unsigned long floor,
> > > -		   unsigned long ceiling, bool mm_wr_locked)
> > > +		   unsigned long ceiling, unsigned long tree_max,
> > > +		   bool mm_wr_locked)
> > >  {
> > >  	struct unlink_vma_file_batch vb;
> > >
> > > @@ -385,7 +386,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> > >  		 * Note: USER_PGTABLES_CEILING may be passed as ceiling and may
> > >  		 * be 0.  This will underflow and is okay.
> > >  		 */
> > > -		next = mas_find(mas, ceiling - 1);
> > > +		next = mas_find(mas, tree_max - 1);
> >
> > Do we need to put some sort of sanity checks in to make sure tree_max <= ceiling
> > (though this 0 case is a pain... so I guess tree_max - 1 <= ceiling - 1?)
>
> Sure!

Thanks!

