Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8DD2D38FEA
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FF1F6B0089; Wed, 14 Jan 2026 11:32:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3096B008A; Wed, 14 Jan 2026 11:32:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F3D6B008C; Wed, 14 Jan 2026 11:32:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0D4F6B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:32:28 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8887B1BDC2
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:32:28 +0000 (UTC)
X-FDA: 84331112376.15.381CB9C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 356B240018
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:32:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AJDHiTyj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EOoKxV1F;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768408345; a=rsa-sha256;
	cv=pass;
	b=dCStG2nhK8qqkiJTKTVAWWMpsK8GJq7atzDg7CGm0jfmNSS92P0lY+Ma3mKfzFvTPiFKm/
	9ARoFTNOfUdByljaXrVGOMeTRAWGBQ17sE1WV1/L8Tnt+TV2L6kHXf2DYAOYlGNmgaspNO
	MPlFbA0MpDO14Qjn5mKg4/aVUZOQFbU=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AJDHiTyj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EOoKxV1F;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768408345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oGNdr16ZidTsbGkxNEF2dBcw7+Edl6kD8+69U4sZPoY=;
	b=CnedFUZMUZ0vQNUObGGR/qece13vegEfrwX6d5Tb94bvKU2nUCzAvfAZk/f+IIAXpXIRcN
	50eM0F7c74ztI48VurONbJPIeWF0VhZ5bsRuJeufIodsC05KjGb1vwHyl5zL/PjttJ7wiy
	L1gbT+w4cJ4pmUQP6WOp9XjylkzNa1E=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60E6f3oH2686260;
	Wed, 14 Jan 2026 16:32:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=oGNdr16ZidTsbGkxNE
	F2dBcw7+Edl6kD8+69U4sZPoY=; b=AJDHiTyjrt5jw74vabsdo993JQc5/J520G
	gzNYZIBKAjzf1GbgNP6KtVpnE4v1c9+YdrT0/tGR3NydrWtBICpwor7kmCq2zK+D
	d0fDQRdWVIT7oaDXbFxk10V6iG610XZHulxuk7jouMmBdVmg5ZJgkEH/VqosM3ul
	B6aRFxq/hkD7H8kZ0V7JRzS9paMDjpOPDkTol/FuaBzCw5CifZeaH8yMe/gHrXrZ
	yHsTdV0ny9Tbtp73LEn4ID3Nhp7dS1/lJE+YVAIzGwWPSsrlaF9zQGZPicpa81R4
	ya2FwAeWXwViQIkRbmDUGqxaVOsbFRNL1dtsSgzpb4pcByodoPFQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntb5j2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 16:32:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60EEqtXW004216;
	Wed, 14 Jan 2026 16:32:01 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013058.outbound.protection.outlook.com [40.93.196.58])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7m1mpr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 16:32:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LwO9w8w8CJh8McEYw18A4tAhvAJCKgb+6iGzSRiHjKVfhGsTfM1RidQu/rK9DIcrx9rZpWefvkuqYhHysFk5rVJbWGGKGq01evYBEtv5wyOdBXg1Lh05CvI/bi1P2y7gYb3E0JA8yrZzqM5IjyOptHYom6wixopGlP2dBbZiryGAW3KZwGZaxlSIxwcxoXR3e3xPiHtqU/beIUorTWZ39B+QhAeK3DW0rwrm+fM8AbzCEWc8jfsRzFokXKRQ9TdFGP3yiyVPNABhgmf1KmqdjhNY8MQLrIReYGROOMj8LlwcUuULDVJeDTXl6P7DtmKdmvACYT/eLP90EesZGDj6XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oGNdr16ZidTsbGkxNEF2dBcw7+Edl6kD8+69U4sZPoY=;
 b=SO2PTYcUNcYQCm3q1I354S+bQXMiwpxwMwC4uGoNscn9q0ZJvqyvcx3tykcsJ7ExiXr+O/XwdbcX5BepqEinscSB9dFAHQ0pzAkVT32xpHzraUI0yELGbfHepoykqR90LJ1x1eQa/htXrfqJ/2D+oQ9EN5Z3FcXJQv5TgCtqI9HJqA527xG4t2gLZ14hjWnc/Ox6ZMh7sUX0FOOlD1QJpSMewH+v+/NYV3lVUl/3iFg6RGBXRJDCUHWHPbUQUakNFEl98HJOGRjz7n3TM0Y2fzEYusfuM9R4AUrDNF25agMoEKccjclKgBtb4slIIyxxQVtDclKCCnuIeOWQymINHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGNdr16ZidTsbGkxNEF2dBcw7+Edl6kD8+69U4sZPoY=;
 b=EOoKxV1FjDjQ6lzTcumEKw7nhvLcknco+10eoNnN/T1bceVlthmDFJ0kTfo+rgkWJP8YzqXVMR0xon6/EfrbqQfzKM/LvDvtVYtIvRdj/7wN5B/b1tnFXIwxmpdBYyHf7He+LZ69fK+wPVDqlxv8I/CUqEuiF/mCycNjGayln4A=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB5868.namprd10.prod.outlook.com (2603:10b6:806:231::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 16:31:57 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Wed, 14 Jan 2026
 16:31:56 +0000
Date: Wed, 14 Jan 2026 11:31:50 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 8/9] mm/vma: Use unmap_desc in vms_clear_ptes() and
 exit_mmap()
Message-ID: <fyh3q23ntftdrc23xgcroe4q2ddssh5x2yj6g2zga2uup7yyn5@7yknsh3aujmp>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-9-Liam.Howlett@oracle.com>
 <35d63781-ea17-4472-87ec-541b6c8e0ecf@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35d63781-ea17-4472-87ec-541b6c8e0ecf@lucifer.local>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4P288CA0085.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::16) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB5868:EE_
X-MS-Office365-Filtering-Correlation-Id: 40604ded-6db6-4d3d-d0fd-08de538a6f01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZggMD89XiQtZdjemQfCbLgjw/Y8+o3DuNkTzGLCpAC88lFK+O2SLlmytDMyO?=
 =?us-ascii?Q?kHeQxZ33zXmV7p/kikWzyiEILCishihmFUCf2Xxdzsh2RXV0voX++E16GIji?=
 =?us-ascii?Q?k2FnQG/t012rPEzv85Gukr9iIc+NnRzWEfem+7Rr2ZKc0z2bB2p5bJSp277Z?=
 =?us-ascii?Q?8YrCnessk2Pu1i9kr3Wpkwmxl3gLqCga/ZiTHrtYFm27ITuqpvmQPi7Uluuu?=
 =?us-ascii?Q?YMiWcaws4fVyvl6MOS5634Gp1wxTVomMS4orxCwwmFZ1eevujmsqFDlteS2Q?=
 =?us-ascii?Q?8p7yWr0otqKQ+detoQPHGTlSZBQZuqE0OUc1bOL9us+dyW0e+x8JGdlGdF1E?=
 =?us-ascii?Q?NRDVBAZao3pQA7K72lTDAZVM+KVCELdopG/EIPdUra5CPwwSVjxQsYH12+Wy?=
 =?us-ascii?Q?dr5cUs4+a5P+9aQRrZOIGmjFQsFY5piuGpobwnd3/3S8ZbIbPZO9cP611bOi?=
 =?us-ascii?Q?zfpt5CeyxhaNYp4YGiWXD0IX4a8rsmBhURruT0OMR5CCSNmqU5Xe0MSYRZrD?=
 =?us-ascii?Q?8o5ZEgK9eCr6WEtrBfBloE2YHMPJgleArnJMdLRR3dJ+4q/6NZbGgFhCdhhW?=
 =?us-ascii?Q?n7sgLj995dihTdWmhOco5BcKrZvUTOWAyEI3U5mpjtT5hlOX97OhJaIhNBhr?=
 =?us-ascii?Q?LDCavFDmKkekCELZdC4H72fgcijAwUhJQmixPcaSeZgtyY9i7GBdQyE1WCwq?=
 =?us-ascii?Q?DGMqZfnGoFPQiMtx+W7cM7zspLXsp+ubf96vdHwfSCvpshY6Yffohw3ofGfW?=
 =?us-ascii?Q?rmUZajk60SGWbYfMO6VSN3IVXJsjrDjFW+jqC3psxKN5+mc7alzk5FV6yiu/?=
 =?us-ascii?Q?wFcNFhCLDxMHf6LFWG2f1Avnl6+WtFzkJpfnpm4eJFK13oq/ozpQu9P0GZL0?=
 =?us-ascii?Q?WrHla2fu1TBVBMJ5Y0oNzPU0MV7PprS8qvrG/x1D6+jESAeaLbr5Zt6glokI?=
 =?us-ascii?Q?ZpTi6zO9SddM4YSUnmVdbnA+le+Aw2ISJjvYl4Vy4ARFDcuf7lPyAustmPNL?=
 =?us-ascii?Q?v+6uU0VtOPTzHkS7SqIr5p1qcgMR5TPNGlSP95b8G3LSgA1rcgGPrZ3RZMxM?=
 =?us-ascii?Q?194V/ClFuJDl9WEZeIUc8oGIrJBNVg93DC5ZyMzgfzcG5O88Zzev/ZrgGB2+?=
 =?us-ascii?Q?XzArdvfXX6QkHBm6ww13PaYZhQqmODhB5jJYcAuPpKvZDvJv++qvIzcs/xsS?=
 =?us-ascii?Q?BPm8ponNg3V76a403Vd7ZguR51StSg44wVx4CnbhC+OsQM5/V77E8xyUqbZu?=
 =?us-ascii?Q?MhZxfPCfbu7fJ1RSsjRVaEWaZ9q/pLT4AvjLLs58JSBuLJ33odgAHmIl73Pl?=
 =?us-ascii?Q?LKSktNbChEoo5UUxA5OXrHf8rBITiwoXC+aKOHm5+naMkCJqJIRq4kOypJhr?=
 =?us-ascii?Q?OWqAc0eL99DftblOpiE58NUuJVMlCrXTZ8GjqLt7C9x1polyuh+d3HHVW2xj?=
 =?us-ascii?Q?aNWvSCA/LL9o6PfrKqNbYJWeWumPJRWDoqCWgU9zr6xoCTMGEomNdIF+wfLv?=
 =?us-ascii?Q?f74rS0FUCwqKy7wVt89W/VbAy6Q2XJr3QYXuPMva6G9+E/21rLWcOnEevXzU?=
 =?us-ascii?Q?xDLsWCf8qsfPvO4/kDs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OyHfI2B64caQbVezZDgLjtP1Q5kTATmd2vHLrYXdW8v/4jfGYWQ15HUFAyh7?=
 =?us-ascii?Q?5rMp1D2/4Hu+xCn98ELUimw1usO4S6rB9T7eLxxg4ocJqJ3akKAeaEPWgaFi?=
 =?us-ascii?Q?ssxDMQ5D39KambLY/vZmEAM6l3/X5gR4AQ8yOv0fe8IbtQ2oWf4rsxieq1On?=
 =?us-ascii?Q?rZcGnJ2L6NUBoUTLUOw96NdHkNt+0czBL0lSKUbeAL+uH/3sJvwMXtyuIFxX?=
 =?us-ascii?Q?Y0CSmVkdhO0hP2OYxt/Uwl2x7hGxa13VQz3ywM4EtnL1VerJxSAvvB69bTvd?=
 =?us-ascii?Q?jaIZCaof4kQgD/D+K97tFsNLGNFMngqehWYlf/FmyQ1ddXYMyzOKxVN+LCsq?=
 =?us-ascii?Q?Sy4TcJ7vY219G3NnAvRhEIqBvBPTenCEwd0RDczUbfn4n9EwwFm56px3fwSX?=
 =?us-ascii?Q?81sT8tPJTN5Ts7mE49aD6TMosbtfuJWsYBXz8SuCJqNq1LwLdnCu1DzotPtk?=
 =?us-ascii?Q?Ck81HWMhjFM2ADCKv07X47zE246/2F8RPx2yHWDnoUnqXWDZR3WibKJPNM2F?=
 =?us-ascii?Q?NgFJMSF+NOKDoRRlT+iv+SqFP0jp/ZF/GACqEtfPOECtA1/4YYZQifDfMfrP?=
 =?us-ascii?Q?ARO0Xs0YrAuw3HB8E9CVnqkAtv2lIJ81DejQeaaBwSNEfts5KLYAiuLm5pHa?=
 =?us-ascii?Q?UIF3ZYIUZyr7zjjW65FqXlKJSEKKFUT/7YZvU+4QJ6TI2cT4RbMjjn6KrSVK?=
 =?us-ascii?Q?pb669ioO2eGe9MAn08aW7mSa+74ShxtOopyhhDs6I2oKQSIHacVl+E1Bwbec?=
 =?us-ascii?Q?3pdgqaIprDi/uEjYuzQtg6b062ZMnMJ7yZi2384JC6qlDgoMIsXVBQNN89tB?=
 =?us-ascii?Q?mMo9DCzjl3TUf9Qss1MDSu0Aln1rwSkZYynnhB/A9gI+1we5Fy5i/eBEAZXm?=
 =?us-ascii?Q?170v+nbnWfn8lC/yHhUPhlO1qepIAayh2qHkfuTlM/UAC8xUFO52LTqWFCTL?=
 =?us-ascii?Q?zwj0WOEWVJngEdTfyNBXTlQi7TrlDK3rf9JdiTBqu+z1+zjp9uQCeBRifDrW?=
 =?us-ascii?Q?bJFWDx2iuHgF0R6B01pHpMug8KFyFY5rHLXkUmtTK4FjgBYrVIOwJkC4pu6O?=
 =?us-ascii?Q?BlNm+A3+Gs4frSDogSYATk99ujBGh9gl2jiAkDg/ysJz+4EmSlb3dRtJSTPt?=
 =?us-ascii?Q?E0dsoObEdwWxBCIwPz3ExUDxo4D0Dd0q/KwQGDIOd5eO81+0oqtw6hzJhzpv?=
 =?us-ascii?Q?uhUdDmQuP85Af3WnVRFW9g0DaPcvwI0rTKddt+ipKq+KoRm+k0J44ymRCLw5?=
 =?us-ascii?Q?52BXpzr4/SkLOf6rF0gP6oLmQO0UmUgurWOTwxOIZc1kU1TFBeuQVvIGfWry?=
 =?us-ascii?Q?mOZL1hSvTZT1Jh239YtSnn8hud21XmZ2gUxbKuhzORrLiQMhj2PqTisPUfzS?=
 =?us-ascii?Q?8CA6ieS93TfWZEIBY33cN5JPfNsIDbRNSSa7PEb77zZSjvRfKsQmDgkJe0Kk?=
 =?us-ascii?Q?VZlCxHgwxByeXPzHU2f61ikZr/U6o4gQj6/CJVyYBNCdQLxN9zuuf3XI/lfv?=
 =?us-ascii?Q?CXUNZmzoNrISDhvALRu6Yma6+gIB/sOhYr7wcAoyc8//eqYvSIcxtjA8pGth?=
 =?us-ascii?Q?RDdO+6DQV9qh/PU2g2+Cj0RsycKpHuOdW10vFs8A5+WA/roNBqNbgy9EQMid?=
 =?us-ascii?Q?mkdzzcI0qs67TeTDp4BDSWn6BKyecHNhMbikSX83O84qI2UtCNR7KzZg7NJk?=
 =?us-ascii?Q?cvK0ctX4TRIxUlq0AteAKpwJYeHt9jdKG2a/6oBvONu6uSQ4AAWEzk9/5AjM?=
 =?us-ascii?Q?1H4g4p8s0Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	up/kVnThvD/gE46O5p/6wlHmJos9/+a37dkOouaQ95wjFn57yduhO4HtxUmuI45dVrbAtBoMNUszu+OUuvMUjhXQH95qOoG4KbTT9t/P67pCl/zACdMIvrDtDGbchUcUk9OqsmxFK/1gHheeVaoFMpIBQumGMuQVfmS1nCbu/hkkB7XCDY12r3eaQuFtpIQuqkFv0BQB2gRF+MH0Deya7THY/ja7EOa2HlpTG68Ptvk/MpWw4eZOPxA5Rmf8ipq9a0VOr3rqCc5cbTfmofcwbFcjxE4m3GFWa2g0WLy231jGuuQy+WCR7Z0iz1eCD09P2yM/FtfgCdOoCz78blpdcsVC1rHO+KxC8mkgXkOnewM9OosDc3EihlsXLKaFIhV7VI4aA44rV5rpUtL3r6QduIgKGxbXOKqM9IHFlXo/DoZgc2BQ/JWD5qShBYDQOr7lk0M2XHYe/oICD/BPIHjj2OvgODXxMeUBGSQEzv1lWSyMUiVR3bnzP6gKwoHRF8BD4OuotI7HBFY+nI0/vgOmHSmD29fG6iisXu4AeX8FEaGJymKun+lt+/n8xgEdwSQGTtS7o4oias396JXQBRcjqyx+BV4gaOBPVtldrhV4CCQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40604ded-6db6-4d3d-d0fd-08de538a6f01
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 16:31:56.8643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ukVjMyY6mfzFf+LZGW9F1yDqXCA0ZWQzYvacv4tD8p0hIWPIxfj2QLvRyXnmdD9yjzuctX8wa1q4xVmhcE7yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5868
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_05,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601140138
X-Proofpoint-GUID: MiKEA_lmavoG2FUPFXRhWdWBC4GFF1ei
X-Proofpoint-ORIG-GUID: MiKEA_lmavoG2FUPFXRhWdWBC4GFF1ei
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEzOCBTYWx0ZWRfX6Q9DAzmqourW
 10mdDY4TLsGan4x1ulIe5bBtg1SFjuDSO8QFeJUdx0pUhCDsuAH/T9O3bb/nMihut/MkBCR7P03
 LdsXmXAihwRzgdCHqpCUf3PDmQkfhZrRUEGLR3NI5JQm8XHHAaZlLPJy/qhnKeAWNmCWqsacjwS
 qwOYt3QlLRWv2dIBbEL1qS7pM7Rjq3scS4se8HuSwRwHO6JXNo8k4IxDcAqo0nFiNJ4RnJ0she5
 KZ+dnFj3q1V3oG2GGOOrr3W1vKF5GgbeX4vrA+jwQsfDqNxka2A0RFfhCXDYmg8ennB9VEcbggd
 tuOWHvtPW/Fjbs8Z55zVsG83zbt5OUgKUBg1vGYF/OcjpOswwlI74YzOYxwmyh7S+n0in7u38+5
 xMpa6EGu1J5vIP1etIWMnN90lziEsP3J7F2MOqGT0jvLevYrAXxTuzGRRJlzQykMeuOGS4IQ1IB
 WIiS6nX9wQMIsYL40IF9T0apZsjSzG9MmIK3ogNY=
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=6967c502 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=RuiTzO4UnC4KiZjqEvkA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12110
X-Rspam-User: 
X-Stat-Signature: ij9k36xk6qn1mremd84hpjzyyyfxeaka
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 356B240018
X-HE-Tag: 1768408345-858924
X-HE-Meta: U2FsdGVkX1+ygUOgXEt58Md5VEMN7yMzvDeMakalFf3O54xPrwGakeKt9tkmhx2VX9dOSNKzH2XXsezyCvCmCRvQTRikox5mtvkhkcKeBkpdm6OSy7tp3hy9OtSoLIZiZDykty7xQj/9FdQFlz7kOCBD3ubccBJkpz3ambIZ0kdQQd4+yCwa8ds/TQWjB2x8M+3oJd+7B1WbxsTYY3zXLIypQ3wuIj48jlWmnElDQCjMwWLvwoXM19StuESoDwv1lbMW7pQKj3P+fCPdP2MfUHDApqwxbw3h6DO7mb2j8aL5Hbn1XWAX/6gdyIg/fNQv73ihd6cM3FltZDtYriqmZ4mCCo49LNE18T1vTZ3oxo/zlapXiXus/sHLq2d+XDoW1fWArZ9B3sHxnBwirEVOd5b6/3BMmPtCf/+K+7k3tXStXTJZuUgpnFzTtRdMF7Oj+05+YCIVlKizNxkNx40F7376qMvrLZ19WIz+MZKX7yWOsV7u9V9pS68uBoW0Y63V0V7QuefOgcfJchuPaXDvThXngz2aejNypb2Z2yQC1rVrm0WM5NEAnBW9mm9BBFhUGWKZv0W15w8PXs7ou6xnREdGxnGR63hpmBglca6zsOfp5ltdGgOxxmsPv4/qX5g6KMP/3Md3K/JFAlF0P9TekIM1ZDPVOOmP2Fz8+3J8vLcqnsMJHMB9tAZo1TqFrKattWtx18cyp+pI1BG5N32OadVeWfeevHXGmVzHseXFPjEORf/wIOkAWe/qTQrZEYGrvwcp3l/l2/2z1UndVqjUpL/4A72vkuAu4LJNshg4B8oUnxDZuBTN49Y1jz72mm1hmKDSlqPHGw87PozN1nhibt17PMWiQIPHVgu1UE+e/abYP+RUkSHXoT4rNkiy9nzzac9t55k2PhWAyyyn/fR20qqn4ISFd2MZhYPSqcvKlAJGdsIKQp3kPnTKfA7C6SnNR3/4U+jRTjvZZoZssiv
 DDV8QLAd
 SGC4HYiNZiS0ZVoJqTAydKye05wtzO24eig6R3y6q/FY8PkFCABS6DNgQZo0JqybVIaMGfH3WrwoTkbW3zfGOCAEuQjAhoJ+u4eiI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250911 05:53]:
> On Tue, Sep 09, 2025 at 03:09:44PM -0400, Liam R. Howlett wrote:
> > vms_clear_ptes() is slightly different than other callers to
> > unmap_region() and so had the unmapping open-coded.  Using the new
> > structure it is now possible to special-case the struct setup instead of
> > having the open-coded function.
> >
> > exit_mmap() also calls unmap_vmas() with many arguemnts.  Using the
> > unmap_all_init() function to set the unmap descriptor for all vmas makes
> > this a bit easier to read.
> >
> > Update to the vma test code is necessary to ensure testing continues to
> > function.
> >
> > No functional changes intended.
> >
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > ---
> >  include/linux/mm.h               |  3 ---
> >  mm/internal.h                    |  3 +++
> >  mm/memory.c                      | 24 ++++++++------------
> >  mm/mmap.c                        |  5 +++-
> >  mm/vma.c                         | 39 ++++++++++++++++++--------------
> >  mm/vma.h                         | 14 ++++++++++++
> >  tools/testing/vma/vma_internal.h | 14 ++++--------
> >  7 files changed, 56 insertions(+), 46 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 892fe5dbf9de0..23eb59d543390 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -2450,9 +2450,6 @@ static inline void zap_vma_pages(struct vm_area_struct *vma)
> >  	zap_page_range_single(vma, vma->vm_start,
> >  			      vma->vm_end - vma->vm_start, NULL);
> >  }
> > -void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
> > -		struct vm_area_struct *start_vma, unsigned long start,
> > -		unsigned long end, unsigned long tree_end, bool mm_wr_locked);
> >
> >  struct mmu_notifier_range;
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index d295252407fee..1239944f2830a 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -197,6 +197,9 @@ static inline void vma_close(struct vm_area_struct *vma)
> >  	}
> >  }
> >
> > +/* unmap_vmas is in mm/memory.c */
> > +void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
> > +
> >  #ifdef CONFIG_MMU
> >
> >  /* Flags for folio_pte_batch(). */
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 829cd94950182..8d4d976311037 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2084,12 +2084,7 @@ static void unmap_single_vma(struct mmu_gather *tlb,
> >  /**
> >   * unmap_vmas - unmap a range of memory covered by a list of vma's
> >   * @tlb: address of the caller's struct mmu_gather
> > - * @mas: the maple state
> > - * @vma: the starting vma
> > - * @start_addr: virtual address at which to start unmapping
> > - * @end_addr: virtual address at which to end unmapping
> > - * @tree_end: The maximum index to check
> > - * @mm_wr_locked: lock flag
> > + * @unmap: The unmap_desc
> >   *
> >   * Unmap all pages in the vma list.
> >   *
> > @@ -2102,11 +2097,9 @@ static void unmap_single_vma(struct mmu_gather *tlb,
> >   * ensure that any thus-far unmapped pages are flushed before unmap_vmas()
> >   * drops the lock and schedules.
> >   */
> > -void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
> > -		struct vm_area_struct *vma, unsigned long start_addr,
> > -		unsigned long end_addr, unsigned long tree_end,
> > -		bool mm_wr_locked)
> > +void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
> >  {
> > +	struct vm_area_struct *vma;
> >  	struct mmu_notifier_range range;
> >  	struct zap_details details = {
> >  		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
> > @@ -2114,17 +2107,18 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
> >  		.even_cows = true,
> >  	};
> >
> > +	vma = unmap->first;
> >  	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma->vm_mm,
> > -				start_addr, end_addr);
> > +				unmap->vma_min, unmap->vma_max);
> >  	mmu_notifier_invalidate_range_start(&range);
> >  	do {
> > -		unsigned long start = start_addr;
> > -		unsigned long end = end_addr;
> > +		unsigned long start = unmap->vma_min;
> > +		unsigned long end = unmap->vma_max;
> >  		hugetlb_zap_begin(vma, &start, &end);
> >  		unmap_single_vma(tlb, vma, start, end, &details,
> > -				 mm_wr_locked);
> > +				 unmap->mm_wr_locked);
> >  		hugetlb_zap_end(vma, &details);
> > -		vma = mas_find(mas, tree_end - 1);
> > +		vma = mas_find(unmap->mas, unmap->tree_max - 1);
> 
> An aside, but do kinda see David's point about min, max & start, end & floor
> ceililng, perhaps the prefix_ is enough to differentiate these and we could be
> as consistent as we can be?

Okay, I'll try to use start/end with prefix.  This means we'll have
pagetables ceiling/floor being set to start/end now, but anything we do
here is confusing anyways.  We're going from a state where page tables
used one min/max while vma used another.  I went with min/max because it
was the shortest and would make it more compact.  I used start/end where
they existed previously.

> 
> >  	} while (vma);
> >  	mmu_notifier_invalidate_range_end(&range);
> >  }
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 5c9bd3f20e53f..6011f62b0a294 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1280,10 +1280,12 @@ void exit_mmap(struct mm_struct *mm)
> >  	struct vm_area_struct *vma;
> >  	unsigned long nr_accounted = 0;
> >  	VMA_ITERATOR(vmi, mm, 0);
> > +	struct unmap_desc unmap;
> 
> Perhaps :
> 
> 	struct unmap_desc unnmap = {
> 		.mm_wr_locked = false,
> 	};
> 
> To be clear? I mean it does mean we're initialising some fields twice
> though... but at least avoids uninitialised state if we add new fields.
> 
> However I see you're already seeing mm_wr_locked to false in
> unmap_all_init() anyway?
> 
> Ideally we'd have something like UNMAP_STATE_VMA() here, but ofc you don't
> have the VMA yet.
> 
> So probably something like what you've done here is the way to go, but I'd
> rather we initialise this var in case of adding fields later.
> 
> Then again... you would have to make sure the _init() function set all
> fields anyway so maybe not necessary. Hmm.


The setting of mm_wr_locked = false was not necessary below, so I think
this will be addressed when I drop that.

> 
> >
> >  	/* mm's last user has gone, and its about to be pulled down */
> >  	mmu_notifier_release(mm);
> >
> > +	unmap.mm_wr_locked = false;
> >  	mmap_read_lock(mm);
> >  	arch_exit_mmap(mm);
> >
> > @@ -1295,11 +1297,12 @@ void exit_mmap(struct mm_struct *mm)
> >  		goto destroy;
> >  	}
> >
> > +	unmap_all_init(&unmap, &vmi, vma);
> >  	flush_cache_mm(mm);
> >  	tlb_gather_mmu_fullmm(&tlb, mm);
> >  	/* update_hiwater_rss(mm) here? but nobody should be looking */
> >  	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
> > -	unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX, false);
> > +	unmap_vmas(&tlb, &unmap);
> >  	mmap_read_unlock(mm);
> >
> >  	/*
> > diff --git a/mm/vma.c b/mm/vma.c
> > index c92384975cbb2..ad64cd9795ef3 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -481,8 +481,7 @@ void unmap_region(struct unmap_desc *desc)
> >
> >  	tlb_gather_mmu(&tlb, mm);
> >  	update_hiwater_rss(mm);
> > -	unmap_vmas(&tlb, mas, desc->first, desc->vma_min, desc->vma_max,
> > -		   desc->vma_max, desc->mm_wr_locked);
> > +	unmap_vmas(&tlb, desc);
> 
> Nit, perhaps didn't notice on previous commit actually, but you're being
> inconsistent between naming this 'desc' and 'unmap'. Let's choose one and
> stick with it.

Yeah.  Not sure what's better, I guess unmap - but it's overused.

> 
> >  	mas_set(mas, desc->tree_reset);
> >  	free_pgtables(&tlb, mas, desc->first, desc->first_pgaddr,
> >  		      desc->last_pgaddr, desc->tree_max,
> > @@ -1213,26 +1212,32 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
> >  		    struct ma_state *mas_detach, bool mm_wr_locked)
> >  {
> > -	struct mmu_gather tlb;
> > +	struct unmap_desc unmap = {
> > +		.mas = mas_detach,
> > +		.first = vms->vma,
> > +		/* start and end may be different if there is no prev or next vma. */
> > +		.first_pgaddr = vms->unmap_start,
> > +		.last_pgaddr = vms->unmap_end,
> > +		.vma_min = vms->start,
> > +		.vma_max = vms->end,
> > +		/*
> > +		 * The tree limits and reset differ from the normal case since it's a
> > +		 * side-tree
> > +		 */
> > +		.tree_reset = 1,
> > +		.tree_max = vms->vma_count,
> > +		/*
> > +		 * We can free page tables without write-locking mmap_lock because VMAs
> > +		 * were isolated before we downgraded mmap_lock.
> > +		 */
> > +		.mm_wr_locked = mm_wr_locked,
> 
> These comments are great thanks! :)
> 
> > +	};
> >
> >  	if (!vms->clear_ptes) /* Nothing to do */
> >  		return;
> >
> > -	/*
> > -	 * We can free page tables without write-locking mmap_lock because VMAs
> > -	 * were isolated before we downgraded mmap_lock.
> > -	 */
> >  	mas_set(mas_detach, 1);
> > -	tlb_gather_mmu(&tlb, vms->vma->vm_mm);
> > -	update_hiwater_rss(vms->vma->vm_mm);
> > -	unmap_vmas(&tlb, mas_detach, vms->vma, vms->start, vms->end,
> > -		   vms->vma_count, mm_wr_locked);
> > -
> > -	mas_set(mas_detach, 1);
> > -	/* start and end may be different if there is no prev or next vma. */
> > -	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
> > -		      vms->unmap_end, vms->unmap_end, mm_wr_locked);
> > -	tlb_finish_mmu(&tlb);
> > +	unmap_region(&unmap);
> 
> HMmm why are we removing all these? I'm guessing this is a separate
> refactoring, could we perhaps break this out, as it doesn't seem to quite
> belong in this patch?
> 
> I mean this is really nice :) just I think belongs in another patch, unless
> you feel it's really tied to this one/necessary here?
> 
> Sorry to be a pain... :)

This is the special case that is now handled by setting up the struct
instead of open coding it.

Okay, I'll expand it to more patches.

> 
> >  	vms->clear_ptes = false;
> >  }
> >
> > diff --git a/mm/vma.h b/mm/vma.h
> > index 4edd5d26ffcfc..8b55a0c73d097 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -164,6 +164,20 @@ struct unmap_desc {
> >  	bool mm_wr_locked;            /* If the mmap write lock is held */
> >  };
> >
> > +static inline void unmap_all_init(struct unmap_desc *desc,
> > +		struct vma_iterator *vmi, struct vm_area_struct *vma)
> > +{
> > +	desc->mas = &vmi->mas;
> > +	desc->first = vma;
> > +	desc->first_pgaddr = FIRST_USER_ADDRESS;
> > +	desc->last_pgaddr = USER_PGTABLES_CEILING;
> > +	desc->vma_min = 0;
> > +	desc->vma_max = ULONG_MAX;
> > +	desc->tree_max = ULONG_MAX;
> > +	desc->tree_reset = vma->vm_end;
> > +	desc->mm_wr_locked = false;
> > +}
> > +
> >  #define UNMAP_REGION(name, _vmi, _vma, _vma_min, _vma_max, _prev, _next)      \
> >  	struct unmap_desc name = {                                          \
> >  		.mas = &(_vmi)->mas,                                          \
> > diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> > index 823d379e1fac2..d73ad4747d40a 100644
> > --- a/tools/testing/vma/vma_internal.h
> > +++ b/tools/testing/vma/vma_internal.h
> > @@ -884,18 +884,12 @@ static inline void update_hiwater_vm(struct mm_struct *)
> >  {
> >  }
> >
> > -static inline void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
> > -		      struct vm_area_struct *vma, unsigned long start_addr,
> > -		      unsigned long end_addr, unsigned long tree_end,
> > -		      bool mm_wr_locked)
> > +struct unmap_desc;
> > +
> > +static inline void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
> >  {
> >  	(void)tlb;
> > -	(void)mas;
> > -	(void)vma;
> > -	(void)start_addr;
> > -	(void)end_addr;
> > -	(void)tree_end;
> > -	(void)mm_wr_locked;
> > +	(void)unmap;
> >  }
> 
> Hmm why is this still here, I thought I'd removed all these (void)'s... I think
> actually that's what's in Vlasta's tree, so this will conflict unfortunately.
> 
> Anwyay, please just remove all these (void)'s, they're unnecessary.
> 
> (Also I'm sorry for making updating this file a thing, but I'm not sure there's
> a better way)
> 

Okay, I'll drop the voids.  I thought I got a complain if I didn't have
them (unused variables?).

Thanks,
Liam

