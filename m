Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24DF9CF2563
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 00:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713396B009E; Tue, 18 Nov 2025 19:06:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB2F6B00A1; Tue, 18 Nov 2025 19:06:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6010C6B00A3; Tue, 18 Nov 2025 19:06:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EBB46B009E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:06:36 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D26CBC022E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 00:06:35 +0000 (UTC)
X-FDA: 84125415150.06.15002CF
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012018.outbound.protection.outlook.com [40.93.195.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id E830318000E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 00:06:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U2Urw14K;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of nicolinc@nvidia.com designates 40.93.195.18 as permitted sender) smtp.mailfrom=nicolinc@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763510793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/5PWLvdd1WeJ4W7zy8OAcBghdLi8K9u6ZsUNgm6aoQ=;
	b=uL6VzWSmUv9FeHKXm8XuYTNaBdXVYkzLLFcqMNdMfFngSOueuc59ILHcY/bKwg/8Sp9+6i
	w1cP9YkNpvJXETU+U/HjakVyEzDmn/8nuLUcRC40VU9AATthOzZxIGWneNVIcaOZh8eY/D
	WYsfRnfI/q7q1J92dstzthnzl+gycgk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763510793; a=rsa-sha256;
	cv=pass;
	b=kGSrxxDqIglbWgse75lJ5UMm6dlrZUJ4uW3rlM6kVkCNL2biEH37s7Ch/hSaKo0Y5GdqjA
	FoEUOVdUf5IX8lziu4w6SsWcSgYcUfv/1osXRXs4UzZuHFqiEQFh2vzYKyscKVsyK+DSjS
	uIF7UPIQoWVEYmXIYXaWYdDnZvWQ6s0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U2Urw14K;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of nicolinc@nvidia.com designates 40.93.195.18 as permitted sender) smtp.mailfrom=nicolinc@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fzUTSyQuiLfORfKX4LI3X8yvZcGDJfGPUSktAKBfjYYRq1g56DORDZcH0LneYpWpweR54S961+xc7+v+8jUCsD4obvc7/G2dEfEGREME3kMT7l+0CW3GBKzdk/u93wme7jZjETC7OiiCi2+HWkenEuOxlgHH5JacMj7h0yZW3nXrpuWNSjBLBoCThR1Ty+EFbsJ4U2bvPbBYP4T3bvL/FlOnl6R3DbdGKcmuG2whuWC9F182Tn2eUJPR6WUvwjEFLL4Pmde+821kwK6qZgbgr8TNlV2ZdOpgzg+nHPqzS/62hv0hY5FIBKJJFgF4BgmEr8yXaDyiPlMJJNN/zZ7afQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/5PWLvdd1WeJ4W7zy8OAcBghdLi8K9u6ZsUNgm6aoQ=;
 b=Pnm4XZ1vAJuVnhTW0JuRoALR+6gZ2i2xghn7DZjIfTYBZmfUdcTCMn9x2Myzarg/TsabwK0L00aCw+vGQ6qwsP5G325dQaTD7vpN1TtVAiAWhDUJrRO2nfpsqYUATCyTSt+2EpTmQ/EHlC4hX7hTpsM42GgxDiwxEI0YSwIyjGr8rNRvrCp7JuzuZ153zYWeTaKsUt5PIxDZAaSPsU37FvTTPsYhyOiiIEumLvoiVYwyJj1hTZ/vC0lLv5DmlqUp3/gGqK/3GlFuZnyRiQgocWO/W8uXa0ZborQIn9flOtFP/xrnQnjaezSoViMvGdDRBKMZoPQaEsPtNj6qpLSENA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/5PWLvdd1WeJ4W7zy8OAcBghdLi8K9u6ZsUNgm6aoQ=;
 b=U2Urw14Ko2+/JJeYYi2XiQOHuCm9bRJWUnU3odkLPjnFdrmy51bEUc5iUzP42CAqZqDryRSseNuWikpMtlGMhS5FuJeMvd6sWz7xsjzh84qup23Vf8lgPDWyd+zu3U6hWbH1LtokVBe9mpr5anMeCQO33f/atHJMrefPsFDJoeJPQogwBmsDeyMgWnML/wtaDwz206VM3IGZmH/laT2kExJ0/ZFQaO0W6z/n3/s9XGWtzYSiXzXHnaPg0B+BDoFPeXBvw/pOPRgwImo6AlL3GHwbDUfDK+a5bUeGUVEvZxJcJ2jDQH239dzkXBviM3xEPP1yfLCKi1OGBD3D9x5ejg==
Received: from MN2PR05CA0023.namprd05.prod.outlook.com (2603:10b6:208:c0::36)
 by LV3PR12MB9266.namprd12.prod.outlook.com (2603:10b6:408:21b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 00:06:28 +0000
Received: from BL6PEPF0001AB4C.namprd04.prod.outlook.com
 (2603:10b6:208:c0:cafe::e8) by MN2PR05CA0023.outlook.office365.com
 (2603:10b6:208:c0::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Wed,
 19 Nov 2025 00:06:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF0001AB4C.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Wed, 19 Nov 2025 00:06:28 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 16:06:14 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 18 Nov 2025 16:06:14 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 18 Nov 2025 16:06:12 -0800
Date: Tue, 18 Nov 2025 16:06:11 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
	<logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>, Robin Murphy
	<robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
	"Jonathan Corbet" <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Kees Cook
	<kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, "Ankit
 Agrawal" <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "Shameer
 Kolothum" <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, "Alex
 Williamson" <alex@shazbot.org>, Krishnakant Jaju <kjaju@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, <linux-pci@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>,
	<iommu@lists.linux.dev>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
	<linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linaro-mm-sig@lists.linaro.org>, <kvm@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>, Alex Mastro <amastro@fb.com>
Subject: Re: [PATCH v8 06/11] dma-buf: provide phys_vec to scatter-gather
 mapping routine
Message-ID: <aR0J8zHtfe/j4ajU@Asurada-Nvidia>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4C:EE_|LV3PR12MB9266:EE_
X-MS-Office365-Filtering-Correlation-Id: ebe9b90d-7b73-4436-d0c9-08de26ff7cc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UPeB8HywBeXH9UFWWV9lGgJ2/MmtmJ4OOyC+g0tDe5AHpwAMQ8xrS6GCm95t?=
 =?us-ascii?Q?lypTQjm9hVAlB61Ih4p3RTpPf13nZlWDKGOZj19RdiO18GyUP1p7pfyw1P48?=
 =?us-ascii?Q?DXUHpHO9McNgpIZhwS1APsZaNVzGsVSp14ZRnxyhOIDxuWxYGQGPfz+atpK/?=
 =?us-ascii?Q?4ug6gssdfpdangpl1z7ssWwhAsPLc0Z8nkqvNyhWd+ldBXksv3/ZR8B35Qwu?=
 =?us-ascii?Q?i3lSev3/2gBEuYkLxuZmB/sVeEpJ/q64JHCJUJoDVL2HESYtNpyOefxwJiym?=
 =?us-ascii?Q?DrKTV2harBdf5XwDZLyPRZ5kBqKy+ZNTUVHLrqa2DqhS7Unh6/c+6ago9AoA?=
 =?us-ascii?Q?+QEIAQqtAq6gzg92gGK1CJe7AUS39HRMI+J64p8kSaPwdmdbLvbppgRJ1e+C?=
 =?us-ascii?Q?hB8ooQDk1gO4i0SZbgzyuXFcwaKWf9eH5I4cFbHKgr/33JC9Yn9x9K3zyD2v?=
 =?us-ascii?Q?1jTHhTUVa9WTVDPv60wC8oY1gqnKpb1a93TlygocYhNWyhq7B9gWPhLL2lo/?=
 =?us-ascii?Q?tmoCpLG3iRDCRtrD67CIQiHAj4zzrlRZoF0oqQR7GlyqKK+Dc5mlVe4sRike?=
 =?us-ascii?Q?HEX1IuS5zvM9n45fWFfwLAwOQjTZ4RwjJVb1HbQDrYVtNmC7v8Yz6u6gcfDH?=
 =?us-ascii?Q?x4pLbWuS0Em961+4bv8aCOi7Qf/2J1/eZgMF5VC/Kh1V3g+GvzSI5j1lGV/U?=
 =?us-ascii?Q?0ccMSGm39fyt5SkU3exrIVpuRTHXXo859Z8OBNeRGnoWv1JabHFpOebfbwgo?=
 =?us-ascii?Q?PwWBoRSLQFHPmNDejZ2M/+lPWp8ttIEEP9+lg+7l6oRU7c5arWg6+r7gOmjR?=
 =?us-ascii?Q?FdFqHArzm4QoVDXm4Kch3bpkGswMlpPl/fBJgjDY27IfCXYY+Q55e0nLcB21?=
 =?us-ascii?Q?K9Aw6kXoyDqllhEMVyrrk0KEeyHIP/v8Od+9kqLrZbDGna+DXSrEjZ/AczXL?=
 =?us-ascii?Q?kKrAaDaRioqnBWRj37hqeErWmbLyOUEDuf4RXqWRCyvJsvm0bLGfJ7abRPhG?=
 =?us-ascii?Q?CPRmmOwAjBnad1pg3iv2T61/pnNOZ1c7IhbhMJHvbzdcCqemkdQ08zTK9dup?=
 =?us-ascii?Q?I1qY3aJ3833cvAXLC69+sInbaPEI2AI1ZjJJRq9YpVcvg7OUTVypKr4k9PF3?=
 =?us-ascii?Q?1i7AWhnkvtLwjiQGUW13YrS4wAydlvjfFvtmhppWhjesEDX6ZFO6Ch20tg3B?=
 =?us-ascii?Q?kkoaxLa01pU231Oinyaxb29CtdYeM8btVDFQUJIxIuE+Gb/XtAM8G7HLfvoI?=
 =?us-ascii?Q?YP4Wr2fAvvgsmL7/uRRWmLgpuU2D5V59T6nbRSXleWHUjX7yaI8sbQYqPZxw?=
 =?us-ascii?Q?vx0xqCn8tolsxteGT2vI1X9uuNAooDuB11+0VKpf9H1r33DR6pRjjfsIxaDJ?=
 =?us-ascii?Q?A2q9p4r++4Pw8+u5VFml2hI+ruoYzfopgj0+M9lsFra16JF7Sst8Bb1u2E2A?=
 =?us-ascii?Q?uPF5hj+K0By4f1OVN+erk0Zy3aiucAvTVCJqHm/e5uT2wtpAbd4K6vSE+hG0?=
 =?us-ascii?Q?Fy9nREql+PdPKhNhqn70EwFh1cbyLrx0nstSyZWL+N1cv08E7ejQndAseUQz?=
 =?us-ascii?Q?JQXESL5OXwu5dsUf+ZU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 00:06:28.3462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebe9b90d-7b73-4436-d0c9-08de26ff7cc5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9266
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: E830318000E
X-Stat-Signature: 3syf8dc9szu3a8cgwdyjrjkgtca337px
X-HE-Tag: 1763510792-62930
X-HE-Meta: U2FsdGVkX1+wgUBPhaNT9AmRHofcAc3UD98c8Evmt2gMIEvz0lFaSNNNMpy/XXmKbeg4EsjzOgy5Be2aQnEBW2X3PLAeUmjTVkCXJqOUwgPWsCDntv7yjbn9LTeMuFRJCmJmfA6KFXASKarUb48i6uwu36VT7oN6E57ArRAZuTfH7tQZbOM/W5heCgmlFiSpKSLvOAKe1B0FaxQ/tPQuWBzgKmd3cGfFCF+bagVn6ybdcGw12ios4NJ3m1EiiamHx2Mie0Wrb5yeOpo7+lFwNWrN/gdEbyd5Cp4btUSdI0Lhxp6QH1p1hvTECWg6FRho52RFjNqLccSt5wsRjx6vS5CFtbw6VXfHh9BGCwfWaeoSYmaWhh0MFg41tCzGa06blmKlR6Vqk9WXpoYh4qZD5HVp5RPzjgHGdDynU4KbgvV22i2PN3Kc8G9X7Uz/sEKr8bDFhVjT/NkNH1yUpxDi1FvIuOzjT1FSq7MqlQ/X3qVjrKdW0/3hnxBkqvQ3UQziRzNgxobhOtPHQJ57BVO/Lh4OGJe2ZUxobavw1n2WgIlHeM55Ih5UmGrPJRurEX37rzx3Ib1Ge9JdTncY5S4/XwbblcgG+1LIsrkUe+e0Wkv6PPSyV2vuNYWB3M+9I/PxL9apAnH3cgoIHR9bJfuWlTeHHN0yY3s7Je79y+WAwpqMquPrRz1vRF4UMfR0ah8SRmtuSTWsoFEEY2/Y2eBu1+oStVGslru01Z8iVwgcM2cIXt7kk47uEyDZ1Qv4sdI03p2XYwpT8vObX0iw56avCe4jeoRoS95NcFGKwEUVo+Oz3ICc2R8R/P1P0gAGRv6LVC0KrlC6p22VwiSI2jLzWDS7rXCxCIHw9kO7TZ5JGLsVrNNDITqojKJMMbMhOyISqSAHhCnk2QFtN9Bz9o4zY52pZ1KldOhB1fHbrFfyPbVpa2nNEfzcg+0UuVRodSpK68A7DU+knPEx6JxWFWP
 BZGiPwFU
 hwFqiCDO6Vg+5wS9AxlGdwfxCjXT+hs3qaCQaU/kALB2xKjee6khFnP2FnY0AH4sJmK/bZxWSnGeA0oqu6mwCAMkGUob2YZV4B3+X597gp+cxi0zet97cfBgixDv2aI+HhJl4oIdnDM7/UFrcoB7wnTF/olxDAemAYxuENusKkHxTGV2Gl11t8BgIBt66910BunkG9mpHrIBGfQcNJCjrifaylg9LhAm6X3yipwOcuVf6GHgXlFJcgvFQHbMNWCsqukhAD4QZnGfkFdm3HbC7LyyI1Ho8XBzrQyStFaBXQOBDJ6EbRYaOXxvgJ/ekmiJi2+dsm7p8pQAQEwdv/mcB0qeLMasGTriSV8kAHnTX2xoWnRovvD8gvXOgilm9X8Mjt3DyMxTr6wb9mtH/yMAnaoqkLZfETEZ6E4pipMOncx05oda+MiC8azRKEdXrWkDY4lfYCcDNi0/Su8Hl71Y19GlQ1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 11:57:48AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Add dma_buf_map() and dma_buf_unmap() helpers to convert an array of
> MMIO physical address ranges into scatter-gather tables with proper
> DMA mapping.
> 
> These common functions are a starting point and support any PCI
> drivers creating mappings from their BAR's MMIO addresses. VFIO is one
> case, as shortly will be RDMA. We can review existing DRM drivers to
> refactor them separately. We hope this will evolve into routines to
> help common DRM that include mixed CPU and MMIO mappings.
> 
> Compared to the dma_map_resource() abuse this implementation handles
> the complicated PCI P2P scenarios properly, especially when an IOMMU
> is enabled:
> 
>  - Direct bus address mapping without IOVA allocation for
>    PCI_P2PDMA_MAP_BUS_ADDR, using pci_p2pdma_bus_addr_map(). This
>    happens if the IOMMU is enabled but the PCIe switch ACS flags allow
>    transactions to avoid the host bridge.
> 
>    Further, this handles the slightly obscure, case of MMIO with a
>    phys_addr_t that is different from the physical BAR programming
>    (bus offset). The phys_addr_t is converted to a dma_addr_t and
>    accommodates this effect. This enables certain real systems to
>    work, especially on ARM platforms.
> 
>  - Mapping through host bridge with IOVA allocation and DMA_ATTR_MMIO
>    attribute for MMIO memory regions (PCI_P2PDMA_MAP_THRU_HOST_BRIDGE).
>    This happens when the IOMMU is enabled and the ACS flags are forcing
>    all traffic to the IOMMU - ie for virtualization systems.
> 
>  - Cases where P2P is not supported through the host bridge/CPU. The
>    P2P subsystem is the proper place to detect this and block it.
> 
> Helper functions fill_sg_entry() and calc_sg_nents() handle the
> scatter-gather table construction, splitting large regions into
> UINT_MAX-sized chunks to fit within sg->length field limits.
> 
> Since the physical address based DMA API forbids use of the CPU list
> of the scatterlist this will produce a mangled scatterlist that has
> a fully zero-length and NULL'd CPU list. The list is 0 length,
> all the struct page pointers are NULL and zero sized. This is stronger
> and more robust than the existing mangle_sg_table() technique. It is
> a future project to migrate DMABUF as a subsystem away from using
> scatterlist for this data structure.
> 
> Tested-by: Alex Mastro <amastro@fb.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

With a nit:

> +err_unmap_dma:
> +	if (!i || !dma->state) {
> +		; /* Do nothing */
> +	} else if (dma_use_iova(dma->state)) {
> +		dma_iova_destroy(attach->dev, dma->state, mapped_len, dir,
> +				 DMA_ATTR_MMIO);
> +	} else {
> +		for_each_sgtable_dma_sg(&dma->sgt, sgl, i)
> +			dma_unmap_phys(attach->dev, sg_dma_address(sgl),
> +				       sg_dma_len(sgl), dir, DMA_ATTR_MMIO);

Would it be safer to skip dma_unmap_phys() the range [i, nents)?

