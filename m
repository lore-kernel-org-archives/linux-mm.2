Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1ABDC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 16:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18DBD6B009D; Fri, 16 Jan 2026 11:16:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112226B009F; Fri, 16 Jan 2026 11:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6A86B00A0; Fri, 16 Jan 2026 11:16:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D86266B009D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:16:15 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C6771A01C0
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:16:15 +0000 (UTC)
X-FDA: 84338329110.06.C5C2BA0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 124FD20004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:16:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BJhTh2ps;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tqqrsh6U;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768580172; a=rsa-sha256;
	cv=pass;
	b=HdOkQ8ps6lYLIkYYqmAg2DGOK8ugBQAMe+3skw1T0MIQozw3T1uSRKXeSbHXkXyHBmWAIK
	36MP9KdI6kiN1tXJ5arCc8Alnnuq57wgXI1gjqtYVT0o4TXYG5PDS/ZqEUuwGcTqMyDfIc
	iqRcg6lvWHbe45KJl6UhvMpDv31l6X4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BJhTh2ps;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tqqrsh6U;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768580172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vQaIoSz2a+9Uw+gaedL3JSNq7vr28HzxIb0TahKZupY=;
	b=H3TvpCDKS2UiutG0AjRgEen/rOzPA7kcu0bodhp9MxV87hGcgtKR2+0n4bpH6VSBj1IPWZ
	M0PHhfopYHcNjdwjNxJ1ztolUhhnCok/OU3EBJ81RXh4RrpubdLsAnZAgkSPdgrfTNF8AT
	s3o5xtucyhbKIatfUHqCz27kJQPS4m4=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GDvwND1737983;
	Fri, 16 Jan 2026 16:15:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vQaIoSz2a+9Uw+gaed
	L3JSNq7vr28HzxIb0TahKZupY=; b=BJhTh2psLuDEZXx9dmhBs8HgvyI3K0LR48
	IKnA24GoVgGmrHcJ24RCpwbeTzrjldsLw3DcyZPGJGdwDWqCU7wvnM2rUvKJD44u
	X0D/xx/m+k9oEktYrpjCvkTWfE+cAGxI49WoycU6XDc/SGkGd9NPok4/zlj3r9qS
	4S/p7hkLupLrp8xrI+K7FQ9o8inLW1oUMVuTpDYu1QqjyWpTGfohjL5835LVD5Ly
	APD+Jtg/2wMNDz6Env95n2DcEf9T7NIHAw1QoR716GPkDet+f9yMcU0ePBiNOkp1
	Cnudp1yYISVAWaYY0xRtsJA0PuTdDk0jGHcC5ROGUc9zl/Na0Qpg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntba642-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 16:15:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GFaePO023019;
	Fri, 16 Jan 2026 16:15:54 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012061.outbound.protection.outlook.com [40.107.209.61])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7puvug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 16:15:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lqs+3vpS2ayiPYw7/QSBpbC8S5JHrzDENCgBNsrVZlBY+CbObQ+hITArfPOoLdtpqzamsT9Tb1wvkJ0kUpEP6vhWiYdRC5Rg2X82igaFAVQ3MhNLfGRu1Zy1wWX+nn+10FV+DidTPXTEULW0iAo/Mba/McNQK9fRAHIx6Zgri9MlzwEZoET0ruP9p1N3S1MChbUiMO7A938Nqq0X/2AW6jPDl457HeCB7H7nlS1f9E4Eq7bq2qdiP7oed2Eo27YmKgdlZbi9KkKz9EEVYgJNd0e3RyoWuR9GwPH+wc7MONxSkSztoNM1+xk8A3ms8lH48OM+Fwm4x9cv3NPwzVD2qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vQaIoSz2a+9Uw+gaedL3JSNq7vr28HzxIb0TahKZupY=;
 b=owZ/6ufdaH7tGNWgzXtD4WYT6CSCktIL77TttFQzUpPk0LKDix8hFschvv4+DIz/0rfZoO5LNzT8NEo4thssvLUXtw5XLBPjleTogHkJAIPhFLZIHmCOX2khlFy3eoDHBx+Pe4K1rHkG3m2Sf5AgbOjrcriHiDJw/Fo0kAnZD7wNrNZnksZxzL9LjR1Ad99jvsSP/QGH+EBWPKfOPwNRul7ItOznrTAAPwLbwFDqlKaZg8TrDPL1Y7lbtahui1csbI83G7T+UGzrg4wOzaRMmPlRMc+tRk1XNLrKvVsOlWGGxaSh0/aEB1V9Rnt6IAhwmc52tcKwcpKEcvPnJ3995A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQaIoSz2a+9Uw+gaedL3JSNq7vr28HzxIb0TahKZupY=;
 b=tqqrsh6Uy+RdPA6LlCBJl0xMceJ52y1oGLmmGweDS1LsqVRBhsh+G1BpXE9jLf15Dq14jJxFRAjgE2QpNiLkQPiBf5FvSbgSCo8M01qkUYMYOwR0YK6J2zT6drtlry4qSVPzTXcdSdUyOyOImaO1UCtHqrg5RXP1YKwuQKj6Djo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA3PR10MB8115.namprd10.prod.outlook.com (2603:10b6:208:506::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Fri, 16 Jan
 2026 16:15:47 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Fri, 16 Jan 2026
 16:15:47 +0000
Date: Fri, 16 Jan 2026 11:15:43 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: kernel test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and
 vms_clear_ptes()
Message-ID: <vcxnsoihqohhmgurdkbx2hvybuhaql7yruv45k63jwevlpkdod@4eugq6xubcug>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, kernel test robot <lkp@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
References: <20260115182720.1691130-9-Liam.Howlett@oracle.com>
 <202601160925.VR8a2hUw-lkp@intel.com>
 <0a97add1-2ee1-4a0b-98ba-c1f576c58477@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a97add1-2ee1-4a0b-98ba-c1f576c58477@lucifer.local>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT3PR01CA0078.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::9) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA3PR10MB8115:EE_
X-MS-Office365-Filtering-Correlation-Id: 593de5dc-c898-4f34-d18d-08de551a822e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ue/wFW0TQFZoqRaouHkxuDU4WIodZArYXn9Fw4S01BDJJdbHqPjp4ukhrqcF?=
 =?us-ascii?Q?uQFWCtzapAZPUci43mvthE0TMwMHkSMMU5tTWJJPx94eNNEEBOLuetUrQJmc?=
 =?us-ascii?Q?6Xk1ILkDjnJEqst3YVAUhX9R2W3Teg+N2VNOWaFI/HOM74+kI1EnfrZJxxYQ?=
 =?us-ascii?Q?ecTK+rpLJZo0w5sSYsacqUeVh2hGKCSe13pe1In6ZUYCQBHCFGmWLcynsaUU?=
 =?us-ascii?Q?4fToyqEqzWyE79I5Ap34PzklpvbSSLDSaLnLlxJpvD5v2/BvP/I8dWbspjPN?=
 =?us-ascii?Q?HqD/clKnEoDqJK2lPDKr7aK8hdMc2AiOT2LEsdc5jfq+nlCo0AZjGVddeGLP?=
 =?us-ascii?Q?kNz3m+kpyb0wCIzm4fj1gKI4f/5G0UhK7iaPgRxqqOQRJt7DMduKvDdNwKaL?=
 =?us-ascii?Q?D+QoFnsCd0HC5BM9zHgtmtfOQRlxSN+pMaXrV0K/GUPzH+GHHWVAh+NGG3ls?=
 =?us-ascii?Q?V/EHQ2TH21vH+AtE1rdXXuPZYbcyq2Yd2ZSt9t/wjy2lGfSSCRwwn4ChPDe2?=
 =?us-ascii?Q?4aoFXUl1RlEhA9ASVdaUoYczy2/e2WkvRUqos+6ZpAEt+oFxecEO0VTYVwBA?=
 =?us-ascii?Q?88nUDv+2GEC7fNrbqRW7/cm8pClcbAbEgrcosgcL1nJ+cATDWnqqf1nokZVH?=
 =?us-ascii?Q?CY6OW8P+6PcZWWJcDC1Gq7pncelItfFe9BHkbqE5F9RhxoXU7PSifqMtxzKs?=
 =?us-ascii?Q?OA/JSdP8ScTamzEG6y100XJcFO2kDrcpvtgKW4HdBZ2CF6M6X0moduL/p9Zk?=
 =?us-ascii?Q?Azl8RPjqvOp2AKvw2MgrZFiwfS9Q71ur42kboHiUkz1PPl7PhlGsFxF8r2Zo?=
 =?us-ascii?Q?edMNo2ViNuRC4A7OTGdPLj/pLq9KJdAPpA3yfOpAIwJ5TO+vXQxlX5zBHOql?=
 =?us-ascii?Q?XNnRycZdJyKePUOy4YlXQ/6t0Gp4yAx7hc6ThglgCrEal2/zaJ8ulJ1ckNW1?=
 =?us-ascii?Q?d5Y5ghlT0ALsLd3/FHVv19uu78b1j1pze1XFIMq2AuISEg69qn4gmTTqMeWc?=
 =?us-ascii?Q?Qk+ejUr9sum5sXiyB/27g+AoTeJ+6/ug4dPzlsm7tNQh5FjVq6ewvkKX63wC?=
 =?us-ascii?Q?gEYEyRHIGWgIEgxH79UPYXMXiqT6/JJHmSwLlOWpx377GjwBJ2KyMvpCIe1O?=
 =?us-ascii?Q?ReaM6FxxIlUWUQK4kGPumqhuzdN0iyEW/l5zg2Iyl83tDiWosHL2jWwz9kES?=
 =?us-ascii?Q?wtY2bBqZo4/enAk1Z7Bwuhj/WsoP8/z++N5ftqyAxrKm4z1HnyGN11HXwLLs?=
 =?us-ascii?Q?F4ycyJhuUJIYyD3txTWg+oKSaUNqsSblXlrz4Fh2pUPqoP4txkY0T+OgVtZT?=
 =?us-ascii?Q?CJf4LlA5gJARJhLdvcVqw64rDxZMiOtLhPMEZOqU2U68R+tOoK/YLrRjlH30?=
 =?us-ascii?Q?omhNmJBU+JZdXZYgUJ4csRlzh9cgQFkqyZZBOXaYTHYxb1XbvXTo0OyulEPF?=
 =?us-ascii?Q?99rN640lyV7J6fwFfcyqez1+++/MHX5h4+F1LFWIP/KA3tRRQBunE4P8KxYD?=
 =?us-ascii?Q?eXrDnlQO0+FEgOaLoUyD0zQnNIigIZoGjg5pWknEQ67wZ9Ndr1nwNJJLM0Ke?=
 =?us-ascii?Q?vTVCeB0Q/zfFKLEhUKrVo45oOjBBuK4Z8TKH2q1j?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zSEFtgCRspiIREVZ4LPnH0f1pInplrt3SLNJjmsciKdR75jJC4K1Fn5mkVAk?=
 =?us-ascii?Q?5NDF2P4uqO89+1V6ChUu+Khpz0MrLr3ztqT5WlLr3rtKq5lLM5J9g0/Qb94H?=
 =?us-ascii?Q?5J97ywkF5+xeISk2ewArzWiMagaRB4gtTS1d1nH3Sk7T5q4vv3OU/W5/MLcz?=
 =?us-ascii?Q?/R8LS6Gcel4dBzIKNTQFFSR+CwHvgFS+UHu4b7LMuUEI7/LX+I8dhqqJsHQB?=
 =?us-ascii?Q?ydhp1oSZ3JhFJOeqnXHqB0orQQLr/NtAKR+W64d8Sy6LdmioSt6mzDMvK9tG?=
 =?us-ascii?Q?+Jg2Gq9zGYLFiT/HlMW8ZXYLW1HfaAAgkm47pQEvExa7Xm8POUTp7OILQw7+?=
 =?us-ascii?Q?lC8cxG6s1j6wb+2U7DCJI/jX6wwlrUxDau8kbxmYJPRt3eLw99vTpB9itNpl?=
 =?us-ascii?Q?Pr0IZskBEJKJHUqHksKaQ8+QbH7GJCfRQbP8BGXkY2+yzrOBJqU6QiW1HkRV?=
 =?us-ascii?Q?IZo+AkjDu4aXVI92dNu6U2lu4BUvftaP0Dx52LGObFk5W1iGgVtLQiPswpm7?=
 =?us-ascii?Q?xrg5bJTdvXJ0MV6F0Q3y7QfjM0yCvIXty55ovi3v/u+fPSofvWlihj7cJQLP?=
 =?us-ascii?Q?H4IZK+1IYf0E7iHZbNMrxkCe0kW3EyqIRQbeL25AbPU5aIZzPgr/xdLLXrhY?=
 =?us-ascii?Q?CTXvnnHSReMpjJkzPeAU+35axWZYgrNgHp+W5FXjpyjO5AAV/FTAM2Z9eGco?=
 =?us-ascii?Q?IvmEARodyFpeYTQKXK2tMQYAfjFQUkpr+PmIEl8k6doFcBYnVI2yDgf65BSI?=
 =?us-ascii?Q?jtnnnobuwJVdkISuA8XyVhF8KkTyyhc0g5EPd0TWmT5w62fZqwilaoNdhgkx?=
 =?us-ascii?Q?ASeE6JBpGzF623sh4NnGcp9WwnNvxUZLfUwX2Ec7txW0vokdqUc1QC1cpLFb?=
 =?us-ascii?Q?tYNEapdwmxpgEsni7+QmwEP4hx9CkDV6flvSFQluh6c8Szw3M23a5WSBEVnb?=
 =?us-ascii?Q?XX5C43MusRr1wC33Uy9BnQYUiIwxSDgf81XhYXpSY0p1lmUE65c5UWMUnFAL?=
 =?us-ascii?Q?UQySAhKjfK8eNOhPOJnv/+zRJU1y9I+ZYfS+xl9zfvMty30osNvJPV+pvuBX?=
 =?us-ascii?Q?AwoBcLviy/IVhbMr3uZRuuOpBcGQ9wOgR69SuQIP8yUqdjwoF7/FAgmshm1V?=
 =?us-ascii?Q?PDjB1UUXU9OGaizW8L3CUSLs4NagZp8Qrd7fQjVl1xCq9S4ymEzIqrud5Pmh?=
 =?us-ascii?Q?W88FTmTtpwJO0N0cOECsuNvanvTY74AAJWkE8N630hb7GyP2tsDhbM57fMZG?=
 =?us-ascii?Q?hdohYYo/fSws15dAlbBCqhwIWHaYyoD1B47Drh1WyuJmiwuK7bjmxnm/Z8JC?=
 =?us-ascii?Q?xPG2LzKXHDEjkH2HHKjlUDsuIpmYpyCuz8WWhqjC2yNDA2oTrtgakMkOReqc?=
 =?us-ascii?Q?SurBgRrYMSc9nm5OHC5TeCYTstn3trkP99MbtT2FjbXYx2VhQHSJodS+OOyQ?=
 =?us-ascii?Q?Sc8YJrhNZCeD8JqIDWlAfu/EmcTg0Ea68L8KN1Bx3fx05p7QTj5XnAeNeKC2?=
 =?us-ascii?Q?P82+kejdTRF+6jGJgHF63Yu9xNhzwF0uSlW7HUEHdXryiYZLcHMOgYBLTIo1?=
 =?us-ascii?Q?bHALtnIcmiX/ToHOQFaRKUq3AGSsGj2JtD9/ULi8IRP/T2Sc2HewJlq9toB4?=
 =?us-ascii?Q?M0bk2HB9fM9bkLgv/AcUewJNDrBRroJgxBvvnwG6WK1UMmrddkeYYXAV4rS8?=
 =?us-ascii?Q?xyEjGXKoxlMzAIRXb+GV0vwHrdFqNv6Jey+Q7YngA/gbS7w3jhWK+UhmoDmr?=
 =?us-ascii?Q?nC7znPZBxQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C30dHjZBO8/nTBBys8UFKAzbzZzM+syYxT7BzfNpmRthdiSjvMQSegngZor8yu4yWFjrtSWtTgUbNtZetXl0aaULZ1z1PQDrT7RbqImv0Xcep1GdxG5ZHHTpq/uOw/e0IyxRowhqIsS2go//3TPtVsmKKEA3rGuaJk8iKiRt7vTr9aJnL8Dev3V68fRD69AeleEH6EBe2raLWUJCHfkSp41Zb2eQ6p1yxnJKSHOrz69qRME+kY6qAS8qXJoPA9H97sfs42hIILab9OQQuSpfBP100YFjhQGG5VpU6Pf0qW5QxS8Tx1iXYPFXLQCCj1MAOwl9FJfMyHO3ozrYLTRisPkWipWzuIdjaXRz8hHZMf8bF22ri14HhLPyqrolmltnO13x46NgvYSxvEovoH03SLs1ulwuBBekbDDxLu169uHC8yPRYl5XwTOE9kK3T8sWDdN3wm4ifP9pDFrc9SXjE4AwyWSY8Kcrgm/NPiYDdn1976uLFizRENYQUwP+vD3+LYbOF1H4Ww4LhZQ1yD4rkgUFZoqEXurz1we8jiJvhlVDPAHJDBANM0MT+3iC2ZsrBPp6DwZK+HdI368mv1Log1JhOxRVYJc2qnqtc55oJr8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 593de5dc-c898-4f34-d18d-08de551a822e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 16:15:47.6294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2h7MHlpBAlzcY19ZJnUUS+u3XcMXyNm7Yl/MfVuU24ssHk0eCac64U8JX+XLu3hg3OiAoLWu1vTMmMJP6j0KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_06,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160117
X-Proofpoint-GUID: awaLmSMjZiZK0NCBMQpvxGQjO1Ez8S2l
X-Proofpoint-ORIG-GUID: awaLmSMjZiZK0NCBMQpvxGQjO1Ez8S2l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDExNyBTYWx0ZWRfX4moOWdL0BRKK
 zMgsGt820XFVMzaF4pQ7PWM8CdxVsCl9Cs3by8cotx6jJegch7tXuXUmXS3YSTFOcgVduowA2E1
 jcfg9hZndMjVSqK5u+YrnRPuc9b2ZmZx6Bxw+eFXvMrUEN9BrOnSdmpq31VO1mAgjPnRoKALfkl
 gY5wGaVKtsEqcQ+YENwB08fZP4lZFb/jBdyoT/3EhwLrf7OO37E2OxPeAQk/DFK1kjzW2myutyK
 X3sI3rsRinzBXoJpiJxRQMmJwUImxyzmDOrMrX12KLoKMlrFovtYlvd3UtFzdnrQFhCAFafe9Po
 6GD2Wl2NkQPLElOFbRbzaee11QKB1sS6Pa3BMY5e+zs9TmK2PVv0imn8hqST1hHsZadKHg+ajIi
 q6ayYthnpuR9cPan+MdKQUAl8Inqu2lfHyRtksO2dyWZ8hSMWtxcBrV1vatUo4f9A/LcYBveVCq
 szhh0AkPIkz/Wr8jnKjUxFKsLu1XUQpWWJdtRyl8=
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=696a643a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=anyJmfQTAAAA:8 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=q1NLlJSvhMQ793OZvkgA:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf awl=host:12109
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 124FD20004
X-Stat-Signature: 1cxra6si8h5wfbfehhaq9mpqxwthw5wf
X-Rspam-User: 
X-HE-Tag: 1768580171-153363
X-HE-Meta: U2FsdGVkX1/UwT/ViKwaPlFVbhYQ7WvDWul0p8z/d2XWTqOkavXOie8tDnR3bWN6RWvyr6hqLOsHnNKADp5RYIEQTj7uzWV11FewJlx7IlAGLRviw7drBgMCA3ndAdD3cAmHSNHt+WuxOYuVYHYBDFQdfKlb8MU7QhS/ZEjTluIyWAL/e0ExghSa6/rUEsNzatmpiPNCnd8UcGKVMac4deYNsrsolwrrz893neQikT3NFO8PiDB5wIsuaAEZ8TjmJV/OJbn0TJNxUasKwutSdir9chjWH7YmeUZom3AQnMQ3BIT/UE4p3G+z7oc/8Kn2iwviUAwGC2FwMBkoERMlbfbEG4WfkB9uhJGRYOiWvpA1FzHCTmbnu/YMy7V7DfzIyrYYX7L3qjjstvQR+4wL5ftQQycDLRIO0BpDy/4k+gS4agbayHI0l4c2ACguR1iGR4qq7KPOEk3Cl8lDjd/8vNM5/bW3k83unwDBrjsab1jQOCZeEPivay+aLMYVrZ6EpIy7pKdZ0oERo5bJrF883bI4nVc3gwqA5cD0FvfATZ5uKuL/cYT0XSYEeRtJVfPwY5CLkdyAFL/1+5Af1g1vkkfTcyknp2nVuHOq5IV57TbWyNkGPYv3UVc2SK4CemXZxgZLAi/nr5yxx1f/sIHyRjVROrS1QJ4Yuss858M2vCii7Y4YSrjVQ06Q8ebIOqdzj7JNONrmR1lJEinoS9wsnOm6azzL3FsgjAV/su/SNcUG+8EGcKoAmDDWQ1uNz+TJBkuZWDCSoinWDmgzJx4+Mb/quaGOU3PIhVybKeocjSWwRmB0H8Bpn/pzhMIt0u8pZWhjm9jdmgLt8e/Sp9yRKpHIr3Wpi5CqQTnUuGe9ZEO5puWjK+RrQfOqCB/mXglLtBEVyvm16bnUS9rquZ447qbqyxEEfuz1Z2StCKF5Yr146OTm6HVKD8ex9tYTqeWDe6etRdYZUSmO3BInNTq
 0Kco87Rg
 Yl7U6TSDb+YcJl8KWgfI2fhQvk5plgDtnroQOPdeGJAe/o+klZdvgdANc6P2zWpdk5Y0omKsjx8vsYbnd40mRQSnrWvOjvo8oCVM1mOV2zLsF8oc+s5IMzXezfM8di8RB1CWD2A5bQB39JDpfG8191TioCdZ/PQjrEsAgpItrKnj/XTsISjGe5++M/IHBUyk6d2uyWlWlTNZfZEj0NL0IS/NZBzCXcEDoT+GB/Meqp71SCTxzDp56JM2Ir/UHC3A9Ik1ghgKXoZlByROWv1mKh6Dl5KJtvuPMcn/ZvPdFw1BtVCS3LK8h9XRqFk+VYT6pieINblBi8+vJ4CFoXqW7HE1nos8k49Zi3lfM/R1hwPo6o5uL6ckmWkqMkrLrx+5bSFlbEoSY100a85mIUgIz3c+dSLsfZjebuKY/0OM3dVrPQx9I5UIWLaGj9Mqmv05vDdQ93Nz4SB+vSefhm+H0ckOCk5N1NAAaiFyZuMysyerfVtwSpmbPI+Y1qYmzHGBzBnMY13C7s6ohj0inY2PVRXsEzhtDQiLTOvAUKbMD74Ht6HMHEaG5r1zebxJ2OgcUmLTgF29Z+9XeosDSSE9+uLsfMSU8GnJF+1AdngW7iYwvDAFGZq7AO9tj+PKue5AKOJ1pL/HWo7HqoRa13CpWih/UJPA+OZy0AH1BiAltijWv1qFiAwSKvWY5rBieC/UcsWMMbr5FuDBZJQ9DUL1LAzFSp4TLcWa3l19QT8rCWZlqyRk7Lr7kYK99f8t/AXG/eCSXgKNiljyzPpPI4nB2ucUsbauKoWTF3CUvynom8ceNyeVv0ThdAQf/bh0KIM5GzxNaqF5mkoIAnizpGX40yOEnXzalIdTC987/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260116 03:27]:
> On Fri, Jan 16, 2026 at 10:04:27AM +0800, kernel test robot wrote:
> > Hi Liam,
> >
> > kernel test robot noticed the following build errors:
> >
> > [auto build test ERROR on akpm-mm/mm-everything]
> > [also build test ERROR on linus/master v6.19-rc5 next-20260115]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/Liam-R-Howlett/mm-mmap-Move-exit_mmap-trace-point/20260116-023126
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> > patch link:    https://lore.kernel.org/r/20260115182720.1691130-9-Liam.Howlett%40oracle.com
> > patch subject: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and vms_clear_ptes()
> > config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20260116/202601160925.VR8a2hUw-lkp@intel.com/config)
> > compiler: m68k-linux-gcc (GCC) 15.2.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601160925.VR8a2hUw-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601160925.VR8a2hUw-lkp@intel.com/
> >
> > All errors (new ones prefixed by >>):
> >
> >    In file included from mm/internal.h:23,
> >                     from mm/filemap.c:54:
> >    mm/vma.h: In function 'unmap_all_init':
> > >> mm/vma.h:175:27: error: 'FIRST_USER_ADDRESS' undeclared (first use in this function)
> >      175 |         unmap->pg_start = FIRST_USER_ADDRESS;
> >          |                           ^~~~~~~~~~~~~~~~~~
> >    mm/vma.h:175:27: note: each undeclared identifier is reported only once for each function it appears in
> > >> mm/vma.h:176:25: error: 'USER_PGTABLES_CEILING' undeclared (first use in this function)
> >      176 |         unmap->pg_end = USER_PGTABLES_CEILING;
> >          |                         ^~~~~~~~~~~~~~~~~~~~~
> >
> 
> Suspect you need to add:
> 
> #include <linux/pgtable.h>
> 
> to mm/vma_internal.h.
> 
> Some arches don't define it and that header has:
> 
> #ifndef USER_PGTABLES_CEILING
> #define USER_PGTABLES_CEILING	0UL
> #endif
> 
> ...
> 
> #ifndef FIRST_USER_ADDRESS
> #define FIRST_USER_ADDRESS	0UL
> #endif

Thanks.

This was hit on v1 and I forgot to fix it.


> 
> 
> >
> > vim +/FIRST_USER_ADDRESS +175 mm/vma.h
> >
> >    169
> >    170	static inline void unmap_all_init(struct unmap_desc *unmap,
> >    171			struct vma_iterator *vmi, struct vm_area_struct *vma)
> >    172	{
> >    173		unmap->mas = &vmi->mas;
> >    174		unmap->first = vma;
> >  > 175		unmap->pg_start = FIRST_USER_ADDRESS;
> >  > 176		unmap->pg_end = USER_PGTABLES_CEILING;
> >    177		unmap->vma_start = 0;
> >    178		unmap->vma_end = ULONG_MAX;
> >    179		unmap->tree_end = ULONG_MAX;
> >    180		unmap->tree_reset = vma->vm_end;
> >    181		unmap->mm_wr_locked = false;
> >    182	}
> >    183
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
> 
> Cheers, Lorenzo

