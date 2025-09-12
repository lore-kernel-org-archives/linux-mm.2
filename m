Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD05ACAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 18:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64F88E000D; Fri, 12 Sep 2025 14:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEE4C8E0007; Fri, 12 Sep 2025 14:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A196C8E000D; Fri, 12 Sep 2025 14:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 893F38E0007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:22:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D7271A08B0
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 18:22:23 +0000 (UTC)
X-FDA: 83881418166.17.F744A50
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id A3CB81C000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 18:22:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N+y8qdZd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=D2wUMS+3;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757701339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WV6GlHKGfHoAbGC/T+pPhkCJ/x7GXo3NJgfYStX/6fM=;
	b=WH7QDEoPb0L5VpmY+IUy9pVVL1ZmYvxQQ8XgqNNuARjlRzrRLD+4Mdm0TzLGjkXs1jPN94
	onw7EdmmgPIlyEhp/+unQpcBvzfTG+sqfeLA0ouJQP33z/ihaxJXusNR0myeT52SLaIJfx
	mHDIDgI1M11hD3BQ9GYn+1UoicA9sco=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N+y8qdZd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=D2wUMS+3;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757701339; a=rsa-sha256;
	cv=pass;
	b=3aGuDgB4MUyx1WJ7pOLnnqZpPNTwR2yrynLOxOPPK53EoR/vxjbQJd6cbo4y+TqHCcSoPr
	zIja8d4b2cPozG6m+fmT8IXVa0Jnh+An0Q/6gWLTYJohVqYE3LhHAnm2pmFHgMCJF00Ttp
	o40pBfs/GCGc4r5ygDs55zDkf3rlHQA=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58CIHnPj010829;
	Fri, 12 Sep 2025 18:21:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WV6GlHKGfHoAbGC/T+
	pPhkCJ/x7GXo3NJgfYStX/6fM=; b=N+y8qdZddZUzRO7DAJBqfR1YbcHgk6gXyJ
	tf1kX/+qaSYnlgo4CfwKQ/LRLI3BKAsT9paJgselrRcQtpA86+cIYSqIUhk5V8GP
	yN0O/bTwLP3vx7SV+N1UtQ0dWo6TMCkot/vZJa41rjxcEkpJVWU0B6EPk8JC42Ut
	gJFHr4q73QVshRkt4x9LfcInSnX/vFlzNkjL52y3v2pKyYSc7zAk8AMqJ8iQPviY
	Ns+HedSSo4Xhdl2HRlVG9cYfgYOmljhGAUpE6gkIxDTYHbu4MwxixFVPo/3nprR9
	76kGjdpKH6VLIXs6qmJ+WYGIMyp3Ie1IvApE3YvXYTvJxGWW35LQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49226t0s6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 18:21:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58CHXNrR032819;
	Fri, 12 Sep 2025 18:21:55 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012058.outbound.protection.outlook.com [40.93.195.58])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdf6vmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 18:21:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bT5UvO0+XhiBZLMT+8JnZsCWFv5N6BWZCU/NqH6q4BkvUWr24ai8CCj2Kk0dUtMdEIl5udMoeuKb5RdENAMG8g2JK+gvOi9Y+KJbV3McQ2sbKwH+IWx99c7KjN62xrnKc3/5vIyYXm2qkrNjWDFYkAQDZOztfLZhzzWm9p/VxF1ZXPl6Qca0FWRgzPP8VCX/f69b1d9JvreBNy96sIIRyFMAx7tqVwPEoIn94O8rGYIOfEjfSP64+/qN9p5tEzN0+UA7TsFt+iyX8U0/07oqDZ/INzWx65PlVvLUZsO91lxyeOIFOOKScalbJlNYV4bp9Io4dXmk8bH+DjT87xw7WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WV6GlHKGfHoAbGC/T+pPhkCJ/x7GXo3NJgfYStX/6fM=;
 b=xgQONNTl8bNbksNum8g0PjAVYHoEloTbcfWdx5TsyfU8CfZsZw3j/6ACcvMij7e2YXWLC9UT7we1mFn1LDQZMYP7VdZtmk9K3/xisXqW2ckGIw3zb4sH1EK+MhfuZP1KQzY2WUjHmiL7Htl8oTaYMmmCxfrTk4ZPyovPm4eraVW77vuLVEq/SCCfE+0Cv7vKnjRrhuuD0ajSaD/fT6gLJv/02dl2IHojU2O6f0urGX+75Z1hxF6bI9zHzWAt2x55AHOKwGM/JMiAcIEZEyLcdYdThZDmiGua6Tdm2G9qeW5gzHvd5iA1CaMGm88CBU/MbnQzL4XGt9icNR45n/B8Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WV6GlHKGfHoAbGC/T+pPhkCJ/x7GXo3NJgfYStX/6fM=;
 b=D2wUMS+3iv82ozU6Us0LmhH7e4d/NM1Fhvr0z8sxPBWyb6bfxyZ/1SbEx47T/UubaRAI1+bBEJtf3TxokriAMrxKWexRQavBetG24GF9TEJgvORk373FW0KyWtt05yhohpPYsTnimgXkO5/x9uXa6q/75vDxaecu9oOUADAeILg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7763.namprd10.prod.outlook.com (2603:10b6:610:1bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Fri, 12 Sep
 2025 18:21:52 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 18:21:52 +0000
Date: Fri, 12 Sep 2025 19:21:49 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
        dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
        jglisse@google.com, surenb@google.com, zokeefe@google.com,
        hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
        rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
        lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
        jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <dcfc7e27-d3c8-4fd0-8b7b-ce8f5051d597@lucifer.local>
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com>
 <ab8c2e03-53fb-402c-a674-c2c6ab11f54e@redhat.com>
 <rapl4xr55zv2nq3jh5ulk4wvfyxa2kmbnnb4uram6q43y4cbwn@dv5m52ocyqne>
 <80c50bf4-27b1-483c-9977-2519369c2630@redhat.com>
 <7ri4u7uxsv6elyohqiq2w5oxv4yhk2tyniwglfxtiueiyofb3n@l4exlmlf5ty4>
 <59641180-a0d9-400c-aaeb-0c9e93954bf5@redhat.com>
 <c5bcecb8-13e7-4db5-849e-2120c69b2af5@lucifer.local>
 <ed784d6c-6c2a-4e0b-ad2f-e953bf310ce8@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed784d6c-6c2a-4e0b-ad2f-e953bf310ce8@redhat.com>
X-ClientProxiedBy: LO4P265CA0317.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7763:EE_
X-MS-Office365-Filtering-Correlation-Id: c75dea94-3552-4942-6c9b-08ddf2293ede
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oNGVYYam8DMk3pVX7zk1VcCp9z7fz4LyiUlZnoaXoJOLi0sZDbgOoyfx4OHm?=
 =?us-ascii?Q?fcQykCNBHZOrNnu1AlsI8CQOvTgWmIgPld5zECcMZ1gRcx0pdkxA2IXOkpNF?=
 =?us-ascii?Q?RZmZ4hzjVLSDeV2jKTUnD2D2oV6F15wCiiZd3AJBmND/9l1QVgAVY8mlg+M1?=
 =?us-ascii?Q?TudhYoeZcAL0cDm193TD6fznhwf7dDdgS5dCxOC6T0sutI6Qm5O0jYrN27OH?=
 =?us-ascii?Q?AiCJSLdxhFZFARugAUoV6jd1qslZ8FpX1bQv/dz2A6xqbxpGUtRQV35nBRpG?=
 =?us-ascii?Q?ccCE8DMZpwC+CeYpeJs9cWTdma9pzYyln2jdfUc7f22swfIxYjXduZKtXmYo?=
 =?us-ascii?Q?c1YbO7FalcclEBcNQsVqn3e1xfQAPLYcm7wTSv01tK9wQ5ZjfBGlSEJ9N52N?=
 =?us-ascii?Q?548rtE3ZzByPgHKniVa/FjAawdUw7evO06ZRHSQHsFmXR5+T4bmxhMaT6IXd?=
 =?us-ascii?Q?HoAoxHoQZiDrWYtMaiNJeCoguWe7FSlAJcLtuym5D7sCcelAM8kaCNGBSGDp?=
 =?us-ascii?Q?AALOHIJeX3ALozDVDm3FQ69CTBiXjb0p0B2xLyq7oYlw6tU+8bTRcH4EDRuc?=
 =?us-ascii?Q?wGQSRuMxQQAxprq/tzNBb28OrsPzMnTTqrtQ8gzD5kZlW6VpKU9IcrDi+pHx?=
 =?us-ascii?Q?nJi0mTxZV57kxPuxuXGrWXMiC6DzISLBDPQZRBx7JNfcTRzZC/kxtPWQe01B?=
 =?us-ascii?Q?9RWvgnrumgGglNtVe8POwlgjW6n/qbj1jPt6nU3p9LgWh6QuwRiR6c8k4c82?=
 =?us-ascii?Q?7MFUWFJltpFq25+tkD4FFCKNXX7s9OSiKZUtn9rr/VO9xFVzgAviKc0IN68Q?=
 =?us-ascii?Q?zgU1mDu1I4S7uhD28dgXW7Qk7Rbe5/1+BUjr5T8okd9+gSOn7hwECwJ3DuGz?=
 =?us-ascii?Q?lgyvJH/qHQ5z9zUwZ/WRtKKS1H780LagnMrcdeuJeOBuJsfMrc3iiMXDMF1o?=
 =?us-ascii?Q?4BhnG1GLSEgYzK2VtolFjhEPhUdiZlAO9hwIvDg055QuaITsuoCx7T4z7+st?=
 =?us-ascii?Q?FWnD6ZoFsXZBCvltBpNN8Dfl0Rb25XByEqXtojUwIScnV1ehNM2ZMCUUIUsK?=
 =?us-ascii?Q?f+chLlsPoh91TMrX1KpZ8zLN1YGZ7JKAF5i1SG6XL+L72zI/EMFMRSIY/Y8P?=
 =?us-ascii?Q?0kBuHgasNncPUNIKDfqvGNkFFOl/K4sSuoR3sSRu+Y3wfdwpA3jJA4RctXN+?=
 =?us-ascii?Q?ZutnAU9aJyith0m3YcLhfnPN3KXkk0METqTuajpEm5CcYA+qNKv6RVKpnP4Z?=
 =?us-ascii?Q?xBII5aiVBKccP8UQY7aqLvtRXLD5BzeAw7M2AQ0Ue0yJFRieJUhUMz13icYq?=
 =?us-ascii?Q?9h6A3F0eD5Ad/hIHJxQrcBI1JvQruRWOFh8DhqNeqMZ/K5av4+T0YyqnocR9?=
 =?us-ascii?Q?OIHINOb9ofcoCuDPjsKavhczjKYzdy09029qHC/Mk1t2xcYugJufKmHfncFr?=
 =?us-ascii?Q?6pNNUaB7BGc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OhQ1dc6gY3pCeA2LVCWGs0qEDe1NeKUKoykyRVCUx1BUAvMzkmXOuT9Te2F8?=
 =?us-ascii?Q?oEuJAyhgZeq64MEpnqIyElRvaFDFSuXuJDFnboK6SDAOU6PntIrszTbQFIak?=
 =?us-ascii?Q?yORRaq/tBKCY2/DQwTUr9R1qXQhEJAoaPytAajAd/+saO70MkQ972m8MThTU?=
 =?us-ascii?Q?bkWDG3ueHAYn3m9l8Bl+qB40oanVoQEKkIOUSGSsvEBGm/jI218mn4yG+B0n?=
 =?us-ascii?Q?A9jsgB+dD968uPMo6H8aQyoMzLb7fppQvnBMLfJLtaw3VKWc0vUA93NKGf5k?=
 =?us-ascii?Q?5Mim2co4lPypVGzgY095hbNi5w/VAcguy2naepWGDSu08q3HxMox033RfmDG?=
 =?us-ascii?Q?7HLpEj1QxkZkC0BHlIAEfHoOqrOsL03rhVXRC1P4amAf+i8+3cHD7rutOxFH?=
 =?us-ascii?Q?p4dOB9iUy/Q3Am5Vk2yrnAHCoo2Jgi2QlzVTz0SDkhAcKNLUDz1Pmr5W6w9m?=
 =?us-ascii?Q?CA76Ce0TlFZaH5aH+G58hyK5yKuJNEACab5iAbm7KeMb8i4Z8XR/5BSHfAxp?=
 =?us-ascii?Q?34nluvgDR6NonLPazJ5eK+GAH3gAODMgEYXsuBAMaM5qQdybiMA/RpvrTNtQ?=
 =?us-ascii?Q?cyQNdbMV0G/lweF0FSBhV92URYj8MlpjavujduEFenkJPoA3cb2o68afMLjY?=
 =?us-ascii?Q?sv4gkJMUEmbJeth2/xNGPqf64q+UIHuJ1wrNv7UszALUbXM68Orh5S2QqedO?=
 =?us-ascii?Q?xjCBieVfqGAAi7XRYrnV8I5gfytxl//8K47ZbDAZEwjs6+fgdBC0kPAXrQ+z?=
 =?us-ascii?Q?9sc5SJeq5/xi2Wc8dlKUqxtzeS+1tvVAiV5Ue/JKzwYq6GbefdgLW3p5ufZh?=
 =?us-ascii?Q?NMOudqKuNQRLw8rasRYMUY4Fdj4bISUzdN2NcbTG22e1YoBg0Gi8+HUolVjt?=
 =?us-ascii?Q?rfWsBZJY87W5gwE/JaeXD6nmRxZ2ACtVvRWnbcm1Fj/11gDspxmFENAR8HKb?=
 =?us-ascii?Q?7buSSMb1Ta+P/v+DY4yz6eLPxu4k/Q/Vmu17T4XdhwFlNwg++weVhGcDaPRW?=
 =?us-ascii?Q?DcEZ+Twouhj2SePActVS1UMgO1R9e0ml86np1KR9Csc33aS4YejL/G4WksN2?=
 =?us-ascii?Q?3K1oOeQn6OSSfwE4v/4C7nWIArmeaQ6NTWRsfOtNLSyQxN/qqGAgketltGMw?=
 =?us-ascii?Q?MWcqs8TI1fOfTNAqH+USEyaekLlRbVkuDBVpK18eVJ27T1zC/Ug9BWgKMUsb?=
 =?us-ascii?Q?suCdqUMThYkpK+vp2vOFrbBL8uC7if8s6GYex61yRtfEOFkMOEMSCjOXqDiZ?=
 =?us-ascii?Q?OLYZ7RGIrZZzRb7TX4nDy+t4twEuk26a9sdoo3Xcg4DszVM0KTqKrw7r7idw?=
 =?us-ascii?Q?H8G4C/mFlenVjrvG2dmm71ejbxJiuNDeDb4N+dEvSNgbCjy/wgYFULDYxinE?=
 =?us-ascii?Q?p2hnHcE2ulrr1QxDHGYkVsFq7+BvV7Boi/LS+ggkKFEgXr5D4dGdwFwcUv2L?=
 =?us-ascii?Q?VC9ltntqHejwRun4OdxFL0hhWc3zvmcep+pzA2gI/u7YrABc2DjqNr3DG/Ab?=
 =?us-ascii?Q?SOHBHVQEuTl+OgFOoF+JyE60Ro05zoo7utfJMMZcC5CiyAlsxcVSJRLoUjT/?=
 =?us-ascii?Q?9n9LjrvlUuZRBYuikeZG7bjsxVrdmhEnJBYn6kzaZZM8OGv4atF5XltRr6iz?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VMg4NThhsS9DsJJ1atUejBTC41lNmUJTbB5K3YHJ+ANYtGbm/uqc93laiklumxN+bSiufyBM2YEmWNhK7hI+hvxG+2XNAhbk+YbFcojYV3iyaW14T3FCu1MbAXgW3OaXh4nY4RWbiDPSWK+vlKf/FLVWYt6eZ/yVc4wXvrjpyFAKlf+IGw4no9hlqrFy5nusO1f1WIDYYcHYdWtZ0gaWgAZeHCXvtWinkCDVVdaVSxVMfqd/0dicO7G7w2WKQSH9JAla1HSEcb2/vRt12Tei2/JwhNjHiffPMLty1SkqRlI4moSZKHuJvbvpM5bU37X0kzEKKnctiWAYqLVyEqOP8hoWPHEUf7O1XeQatcqtV258cldJ39fwEEcOEnEF1wQopNh1yt2uWBEbp7v5UDJn7qsTk9ywbs5ZGicJC+5wDNbDtsqplUqnwByshdh1A2EqAF0P6ein/kCkUkXs/x0MMfSgftVZhC+BQZwEhPT2AtaSeRX5kDyHAt8VZmMg7Iw9ityT8J4Xfo1M2kx2bWSF8D6SFO9/JIm4Vtaa2rcoKUKRBw/To4m8amW6otod4fdsUj42sRElOrggvUKWCsMwDzMxNaFy5dbBlbtHXiQt+/A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c75dea94-3552-4942-6c9b-08ddf2293ede
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 18:21:51.9769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pt6HUApwc1pcQ94zxiSO8M4/rf+tKDxY0M6fRUPbT1p6o1BwSDvdUj/vXmLM36u2CXShYqEpyXKzW201CjcHtuKW/v6p88e3OFtoq+DkAcY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7763
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_06,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120166
X-Authority-Analysis: v=2.4 cv=QeRmvtbv c=1 sm=1 tr=0 ts=68c464c4 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=il2DyN9IsavGJFLcubcA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: LuiY6P4kCcwS0UuVERM-HY-Ho3Vu_tpk
X-Proofpoint-GUID: LuiY6P4kCcwS0UuVERM-HY-Ho3Vu_tpk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OCBTYWx0ZWRfX4e7dlYJOpXyB
 acfDY+X97YYps+6jrf93QbgOuTjMOgVCxs5NG5H7VrtLItIO129y0LDuw29yl8IzOrGosjw6Eer
 1wuvYYZqs+ZNi54sMgeT4SX9UX8aKC4gD1fF8YA+ay7PcFDaUVwOarTExQRkJr8S5kv5Twg792H
 FG7jriIWKISf43z6GS1gbGtX5MECFIcK7ViKng923ywYVhVkJK2Uz66fcittubXA3mamFaS6iVU
 xxrVRaZIwWcjuMbJogIsyF/lb80zVx4THTDWCmMzW9c1NVgveZZs9/owlkWJYlBBSoAyc7HqFsD
 DygvNIdOjYZIyZFfB4V3o/InvOaKnVkP/GvwM4tD2Afhtrn32J4rgssKjF70e46qbppXDZeK8Xh
 03yLr1m+
X-Stat-Signature: b7yoims1zrkdwg7b4iig4a3wp1chotrd
X-Rspam-User: 
X-Rspamd-Queue-Id: A3CB81C000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1757701339-556979
X-HE-Meta: U2FsdGVkX19x8PnSCEkoLDK7evRm+HDiATQEYLx1YKYBk7M1Hmj3dlRkinocpUApKFqguNtX7Mt3dqK/EWWjBCvvoF4HZD6wkpzRabYufIBqfWEWaDPE/SjntlubRt2dCiDFfN+7WBhVl5lp4ZksXuaqqMR/7Cz/Qn5lJIJHfPHLbIAsN0SyLLL/81FvDWYiPziTRzQfGCaJdnrisy63fnoH4yOLpP+MXkNPUxv8AKYD4XP+70yi9OJBDYXDVYkmXdIuCqG3pvfOTfxCz/3GRPYumNtDf9Inu2ruOWpw1JV3E7JqRfJwq0rNMm+rMVlJ7pW7FYkZ65twj0V8GGrgv2nCV2hdU9mgsteQrXDDt+nY5V6Z/B+1ce8+6DLQ7XXxr90nEyFHUvcEVxJ03jdEXCSkorMfnU9zYHJ48k13RmISeG2BiAEu+OZy+yzru6sFlgusF3Cb5QzucOGuz4QgkmzTbAfGZ7sDZxJR451iol4qXnsLgCcRZ+13mk6ymS+oNEHiDXknRHw8FebWr3qUeE8tOT0TI7GvKwWwR1tmP05iNSF5//ZS2wXfZUejQJKi+SNyj3e/0rd5+EpBNNNjMtlWkr/lUZs/zEZy5ia4saqQ5iZctBXryhMaMrWYY8lrhoFL48T0q3twjMkuefsRV0gxGc1/w/PHKNwl0i15RMpK1+cNcJLDiMb1UbGGVp/d3cNoLVPOFHWzdOWVD88izDK8XUBpXmR67jkd3rP94fjVrYhz2pvg7ZrCGML5n7PnT7n32sMUnWCgEVA95i0DSWJE+VVHa6WZf3dzg1rSVk5UkutkyUurrso1ikWPvK8H9+y0j+sVmwGOitQZp+kQLYxqqVOBz/gPRyaEZPoij7rqWnpqRlJAOtY0XYNdWZntHEYMhbX9c5U1vLnf7iQTyT4E/NIqoVJb7VgIovb4McD5ZB16HRGb/fOgPiilJ4wALbvVhsBGQ4AYHFF9kV8
 9w4wU4E5
 OsFRyvuqjTimcVOfQ3KulRAvL+8LJzNusvrxVfd5tFoHpK/iOUgdRxbG42y1/8Z4A43B4BRN6aBZqtd+k50er66tQb56JywMLRNv7Uq41BZ7SfHVRL6LCTo2jdKh+SfcAsDm3Hm6ecvS2bkHO2DV11fmmCCZxyTUlbetRiGFUXk/3zYTAJIkA2NKpYml8yAom6RL6YeJ5wVZQxaamP8ytpqbfYcxAweFgTE3kGhXMYOmS8A1hUVlJkSPrmv7L1pk9oiFN859e6+ccSCSPpJigsGQtKM8wg7EejUKsuMlGQHzme8LJdjODOJuNFI3SPx/r5c8PPcllEBy1M2uGESLenojz6IxaAmoW2dHh+j1ZyY8/tgb4FtVjZIKUj5LbJbZcu/hmHXouFu5jjbE5ucj54zhtjMhxTpwRrLqVjBoBofxagUC0tbcC5AuZDcUCsk36T11qGy36IbqBgxdjoj2x9FvNRSQsh9F7phy111Rpd4AzgmXm7ahb1UcpXKONC5a65AYdihVQce8RJoZHlV2ZQYkeRyx7Lv9B1dTgKVVl7hDyKqf/HR+WjEHqVu+BsuiLM9VbWMlMwszeK/dnEszBxPt0AD4ZzrHK0TtwHqaJgsbBIFtumMp6+jiq+5qn0LZOo1k3XIJwR3T0js/yhvTQ4UJLtSrh1LWB8gs9IcPw/9dQgEJPS/5Er8TGZO6pCXM2vccVwPncALubLM5XXwCS/7vvoMkG6/KM5RD5X7Y/bG3Oy4epWcZ0CUnZ3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 07:53:22PM +0200, David Hildenbrand wrote:
> On 12.09.25 17:51, Lorenzo Stoakes wrote:
> > With all this stuff said, do we have an actual plan for what we intend to do
> > _now_?
>
> Oh no, no I have to use my brain and it's Friday evening.

I apologise :)

>
> >
> > As Nico has implemented a basic solution here that we all seem to agree is not
> > what we want.
> >
> > Without needing special new hardware or major reworks, what would this parameter
> > look like?
> >
> > What would the heuristics be? What about the eagerness scales?
> >
> > I'm but a simple kernel developer,
>
> :)
>
> and interested in simple pragmatic stuff :)
> > do you have a plan right now David?
>
> Ehm, if you ask me that way ...
>
> >
> > Maybe we can start with something simple like a rough percentage per eagerness
> > entry that then gets scaled based on utilisation?
>
> ... I think we should probably:
>
> 1) Start with something very simple for mTHP that doesn't lock us into any particular direction.

Yes.

>
> 2) Add an "eagerness" parameter with fixed scale and use that for mTHP as well

Yes I think we're all pretty onboard with that it seems!

>
> 3) Improve that "eagerness" algorithm using a dynamic scale or #whatever

Right, I feel like we could start with some very simple linear thing here and
later maybe refine it?

>
> 4) Solve world peace and world hunger

Yes! That would be pretty great ;)

>
> 5) Connect it all to memory pressure / reclaim / shrinker / heuristics / hw hotness / #whatever

I think these are TODOs :)

>
>
> I maintain my initial position that just using
>
> max_ptes_none == 511 -> collapse mTHP always
> max_ptes_none != 511 -> collapse mTHP only if we all PTEs are non-none/zero
>
> As a starting point is probably simple and best, and likely leaves room for any
> changes later.

Yes.

>
>
> Of course, we could do what Nico is proposing here, as 1) and change it all later.

Right.

But that does mean for mTHP we're limited to 256 (or 255 was it?) but I guess
given the 'creep' issue that's sensible.

>
> It's just when it comes to documenting all that stuff in patch #15 that I feel like
> "alright, we shouldn't be doing it longterm like that, so let's not make anybody
> depend on any weird behavior here by over-domenting it".
>
> I mean
>
> "
> +To prevent "creeping" behavior where collapses continuously promote to larger
> +orders, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on 4K page size), it is
> +capped to HPAGE_PMD_NR/2 - 1 for mTHP collapses. This is due to the fact
> +that introducing more than half of the pages to be non-zero it will always
> +satisfy the eligibility check on the next scan and the region will be collapse.
> "
>
> Is just way, way to detailed.
>
> I would just say "The kernel might decide to use a more conservative approach
> when collapsing smaller THPs" etc.
>
>
> Thoughts?

Well I've sort of reviewed oppositely there :) well at least that it needs to be
a hell of a lot clearer (I find that comment really compressed and I just don't
really understand it).

I guess I didn't think about people reading that and relying on it, so maybe we
could alternatively make that succinct.

But I think it'd be better to say something like "mTHP collapse cannot currently
correctly function with half or more of the PTE entries empty, so we cap at just
below this level" in this case.

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

