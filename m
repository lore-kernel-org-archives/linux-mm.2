Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCAF2EDA687
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 15:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DE156B00C5; Tue,  3 Mar 2026 10:24:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ABDF6B00C6; Tue,  3 Mar 2026 10:24:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1843C6B00C7; Tue,  3 Mar 2026 10:24:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06E476B00C5
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:24:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7BC11C12C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:24:57 +0000 (UTC)
X-FDA: 84505124634.12.8002A56
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 31FAF1C0006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:24:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="gbRC+/Kd";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dpT1nbcd;
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772551494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QcD2KSdufUYjdCvHkkfn5vhg4ZnrpFAYZiI8Xw34yDM=;
	b=CrNJl9GnThDwP3IH/qSaPnVCJqQSiZtohsw8Fgd/PJ8r/wuN6xl4m16khSed34lHM1fYAX
	TxtO5QPAWUiVchDrOiz8dvI+y7Uorl3hikGcxmerC0QAmrYdNWoBhzTrpCOd3GmXGpKRfo
	vA84BFjXyHPpyUaK5rGqJLQlqpLZ+mY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="gbRC+/Kd";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dpT1nbcd;
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772551494; a=rsa-sha256;
	cv=pass;
	b=oTNqmhIsvkEmJaR0PJkkZgFF7dfJks0WYCN+wXfYS6c84IeICI/MUrJfEtGQ3nN6CAzPD1
	n1/xouqjMZ6vdYdm3ZjyC26SZaB2JqQVpYeXoi8zh0aRyweDmp7nZ60LvYVNjV7ZBCQYN1
	pQkJhJ3qzlvMQtHZbFvggWe/0+vg0WM=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 623F8JqO193685;
	Tue, 3 Mar 2026 15:24:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=QcD2KSdufUYjdCvHkk
	fn5vhg4ZnrpFAYZiI8Xw34yDM=; b=gbRC+/KdvwDPSRUHvf3W+dIR3UoqvzT/Zj
	uTBSpvTHAFX7RYD6bgfIOIttwr5RptVqaAMCDYbsgIQM75dP1W2A0aCZfBHLnQYN
	7iErjTeAPely/BnXe76ac9C+m4kqeLfG/QXn+kMuB+ZMt5C+zMyKE3kcNLXQVwQI
	lUQwjUeh4J/54e+c0bP6dWQsPWjL8fXiOi+rO6wxUgkZGHdcWDwHglntFEECNE/J
	Cp4xrZPMFHhh9iTlN12fk6ttlTVkCVe0F5QX4N5k3bjZa/c7xGwFu1089GuKlA5H
	/5Sv72MPsH3WMG4QQVKQWgD1l10Wd+OQqI5BNROEGyL/u/idi6Rg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cp20sr139-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 15:24:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 623FEELD027495;
	Tue, 3 Mar 2026 15:24:40 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010026.outbound.protection.outlook.com [52.101.46.26])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpta71v4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 15:24:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aiyitZOEzPZTzPliIaNgTLOHyBjCwgoByO1Kfv9BxL0GhFpUYhTybyKU/zTJWHChlxdF4pgkCXRHoJbqE9hfL1ZbCIfMZNzvcNYQ9exbvWoVEp/yCyPYdBHQXhxnPXhIN17D3nLMQ9wmxz1s1+UePiSwC85XscZpjSqpLo/4Fj+8AVKt0Yq/YrVcq326SAXqovVUgOmU8pwWiPx8mqtbZ9PCkweQtoeSXkI5hrtf5KwPD9O0wuwQw0JoxuM/IU4BrLCv+fWi0JphU1FVUIf9L9nqshE8p9xTuu98aodw834LLLla8cVyrGtSwE2ExQG4CVGRxccBsYP8RxYrhn7AwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcD2KSdufUYjdCvHkkfn5vhg4ZnrpFAYZiI8Xw34yDM=;
 b=YctRoEGVfaYZug7EkKuUcKpooJ6Nt/BF28QyRrz1uFg+drcBRD3ToEkKah4XUPeUknqxo4Yojtwinz/ehlWbMBL2/cNmdAXcbrRk31LUBH8u3SXgJD4dpdhmXu+7aMuI6Gw9gp+HjbeqEJ8SbptgZTENmY2K9Yn0xIVY/pQkD7OJC5X3HK+e9/q6eDcNiRUjft4oKTKz3ZSwIVMDCpcI6MAK2kXw86pPxTwdsolCX+Ll3rUn3036RLWadMu6HQHEUF1CH4zCQKv883ilOWkJlVq6vdWJtn+fL4+X3QY7FzaMSHVpbF13oQ6IgLQxfjOxvnF5gb8WfTS1kzRddZrwzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcD2KSdufUYjdCvHkkfn5vhg4ZnrpFAYZiI8Xw34yDM=;
 b=dpT1nbcdvHiona7xZyD3BcvypZLwXd8Tp/JtWgd8VpE1NjU69gKsKxoDXZgjBctFb8WKo6mq8yVAhhYnElfWuXeD7n/jJt97k1d9B3uX7m2qTa222Ol7G2VFhinMt0+lbP/xdRkc7HGIzq5SjSuw01hMB6LuvjEQ6eM1+IUxUio=
Received: from MW5PR10MB5764.namprd10.prod.outlook.com (2603:10b6:303:190::15)
 by PH3PPFEE76E158B.namprd10.prod.outlook.com (2603:10b6:518:1::7d7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 3 Mar
 2026 15:24:36 +0000
Received: from MW5PR10MB5764.namprd10.prod.outlook.com
 ([fe80::412:f26c:21fc:faae]) by MW5PR10MB5764.namprd10.prod.outlook.com
 ([fe80::412:f26c:21fc:faae%5]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 15:24:35 +0000
Date: Tue, 3 Mar 2026 10:24:33 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: stable@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        Li Ying <liying3@sungrowpower.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 6.6.y] mm/mempolicy: fix wrong mmap_read_unlock() in
 migrate_to_node()
Message-ID: <bprwn76uevcbjoeqotnbehtwxhvju3feevy3tmzlp5v7mxnjh5@llxnhqlhjk7i>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, linux-mm <linux-mm@kvack.org>, 
	Li Ying <liying3@sungrowpower.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Christoph Lameter <cl@linux.com>
References: <20260303101245.22290-1-david@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303101245.22290-1-david@kernel.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0453.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::14) To MW5PR10MB5764.namprd10.prod.outlook.com
 (2603:10b6:303:190::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR10MB5764:EE_|PH3PPFEE76E158B:EE_
X-MS-Office365-Filtering-Correlation-Id: 40043e5f-6212-4de3-2317-08de7938fa41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	GOk6e375ITaNw5QLudXFqx4k+uNEsivXGbfUlkDZinvxvvKF79BVDDXGMazYh7bg6th10IR8gt26CdKhTfdSHEl/Bh1X632D4cE0PvmXCW9MUEGGXr3XXDHqSxzuaTQjFHDmOTmN2Mjwj+2KCkosUcPg7cfrpZxta/IKb8AKg8/cqo8Qtf5SFci9LMrU0plCShoavk+Z2YJhCB1NfkJLqa/sM0/ObFGf1KSd59B6qc+p8UiXiApYAqZ+NDdZEZIhQzMHP4Rniff3mUHa6/LY4wjwTnEDrh/SVXKTKWCDrjrOubPqgjpCBZwFr4C4tRm6pjwUbh/9OvzKjfRysqz0Z7zAgeDMpB6sx/D32z72Kg2zyslABkKSxGvI+5UVuTYPOqBOVA6Vi5sGSBjEGlyd5ujgCkj5/1t49n8Z8odgmCdIFY1fEYftyL92hLVQOU4lhZHE41I9bEUHMkVy5qnEp7kE5C9abAxmg4TuDqOncogehqodDA080fVHiwCLcEd2ZYBRi2RbLYat/ijHP66rjVoWogG983SkC0iCiUGvvCFOv/MMZn7Zrfd7DiF3YCOhKFd1YnTq5PYWWXTd3HDJRUrY+sEOZIxXvgpg2z/D3+Sz0OQmj7FyQkag5kczPSnI3INBDcrpBQwRwsAcLF+zA2hggWczS09RPBUUa0KbjmSmakXsGsA5D6969mWN0W/mj7yu7Ki3TaIGvg2iZ2BHvUj09che2p7GkiGnwY+o+UubX60PkMbqJvS030HJJvHy
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR10MB5764.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VZPK+//pDs4gWlnVRBWr1k9ScWSD9XxGqzWxfK2TiiwGu6i5WVIhzBH6D6kz?=
 =?us-ascii?Q?NCal96V9fC7HXhMuPds6pGGTBjEHvsI4cybmyJ65SMLnmzS2+5jhE6EGULdM?=
 =?us-ascii?Q?BJfLNJ5vw95O26MTGpdddvsc831y5YEruD96p0zVlEv02LWSHR7sy1LMBL+Z?=
 =?us-ascii?Q?NpKF+hdctUkiBOm8DKjNo3S3G5QDLzrcl7tsRUIPASo2kL1ARhQMNkBjrLxy?=
 =?us-ascii?Q?5jqrEzH02kt8+TkWlFWNZyuxbrLlAtR13bVo/oX65L2S65FHql82KjwLjMWr?=
 =?us-ascii?Q?EJKtal9OKHlPPYKhZDe+keCMaBH876GZWILAKcf8SJopuB2we+6mZZw8BqV6?=
 =?us-ascii?Q?4DTUQnTh4gezhR58MbVLHQrN0BVamIKDn/oCG0lTRfp+FyURMP+rk7LzxnDP?=
 =?us-ascii?Q?aL3WQai/RyQnh7Evsx/t6UL6cw+R1vnKVpJVZU5mMxSdZGrR43zjNyc9gkgY?=
 =?us-ascii?Q?mik7/jM9KnMhWNhh3poF9EYzRyz8exhgLBzjWgd21czXkg/jhJN6eCHUtbHJ?=
 =?us-ascii?Q?kl1gmpNdZ9fxk4wX6Gl6P29VbHKC9o8LqhHdTUAnlwanFwCcIIcLdhGe91Qt?=
 =?us-ascii?Q?Ro3/qNGCbUdxcEFHdRx6FYZpqQhIvufbj+bxvaY7usbTK2QHe+qu6kTm0R2N?=
 =?us-ascii?Q?0m/oWVgwPnF3KTrl2gn5KN6aEAFyL1ak+GO4zbI84v4WO0MZGNTU280Wy8pS?=
 =?us-ascii?Q?Jgjzoei6b8cPIWEgKVyqVb1ZQPiA64cT55y+NgGX4n0yg4CqVQ/133M/7V85?=
 =?us-ascii?Q?Lr1Zo6Zro9AYoC4ZjcRWDMXzudnAdwdTSmpaOztSbZlz8YXySijtW7BUmI1Q?=
 =?us-ascii?Q?lQtc1YE8UoKz6wmbUw9j/oFrxWmZntRzffLKBwBcEp2+GBD4XwpBji8Hlp19?=
 =?us-ascii?Q?2s7ZmdYFSGrE2hUORBV9a921J83HIzW41iISn7Rb9rsThP2A0YI7886YZRX/?=
 =?us-ascii?Q?qt3mtXl0CnopMJwtkauCxFPbR3AsYSpyA89uzHDop7EFqi4BK4OXTQUYN12Z?=
 =?us-ascii?Q?Y//NozpLWU6ephbSRUVWAIk+r2r0k6e5sp7IZ4MHAVJG4ypWfMYf2xpYT/9q?=
 =?us-ascii?Q?jWMqfsDn8GTS9S1hzkQFc3qQZOA4j0AhhfkHZXuq8+64CqNL/dlcpm4jjMz9?=
 =?us-ascii?Q?pL4AeJNUGveKB5z/OqIGvos0PlBPKyptqrJ+qtzwEg28zTnZ9sw0BteFSui+?=
 =?us-ascii?Q?+H0ajhgCsq4+RQjnou/xGAmUIt3yj3pYGaydhUc1BDJd3JEqDsF5EICDGwuL?=
 =?us-ascii?Q?Pk7XaaxpJ5E7g7DKu/5Y29xwBud+e4ltbrg4o9UCNuyXcjHAQveDMeTCUovt?=
 =?us-ascii?Q?tjK9vdHdKwBejxZ/ocp6liRm783CC+xAGALS8FBzpgKsQw7qEHfNsuhQF3hl?=
 =?us-ascii?Q?kg2hDbfhTocHEW07gJ94DnCBaxW4Ze8PAhT+w/UnAFaLzofhzZoBpwsTYQBW?=
 =?us-ascii?Q?e6XZQ6wUTMrupIjby/9st4ylLNgIg8HngiZwYC7yDXH5+CUFbTAugXoPs4Ne?=
 =?us-ascii?Q?ZTJRi9mgqKgNmFMftlwPKLcy2d1QN2wxhby3FSBH3NoXKeyYQ6UsgQW4xK7q?=
 =?us-ascii?Q?jX7dEWPwrduzinFymqX57HkcqHA0weQ0AL3S5IsKkFQdlKHG0Ezjr3y6u51c?=
 =?us-ascii?Q?jOB//3SfHLfrHFg2eJedEBPaDOq6ZLh9bsIQMCERtwXMDWb4NOWzpixM6pFf?=
 =?us-ascii?Q?k4mtcjAoCm6xgQ4dE/shkSCF53apuhYo3Nyl3Xq3TIRQbIJi6oTvti1sgIGa?=
 =?us-ascii?Q?+nanEpgr3w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	y8O5CoKm7ucJI2DYdj9QCqNZaj7FtyZ4ud+/BgNUFI3SheaqezjBc9y/2GRTCm3dotZSTJ3H29QVljbG2icpBV2HX3JReGQ+LfqG4zTxFrKB9S58ZzZyBkjmk2szhHORCoJ+mL0YkS2jecTp4DsNFcBvmYJ7nuCqaUf/9ldjvek7fnm0fyFhN0qy7PQosIEfDxEtl7dNaVvQ4MC/f29zA3jZWgySbaPuzVJb9NlUzzPQcDU28cwg3mJIPXX5qB6N5A5znH5VWaPTrhNpyHBKYV67OdRPe1EK4hqrLPEEJSTTuVtwD1yoVFd+uIdiOoP/yZDQxdApek6+u3LluANk/TyyvUXcPzGRWupbSMPgnNto+Z4otCAcXAD0mzHzHchcSjXXEdLdP0HRP9a6hvD7A0ehMVt/vyJN1PAfzDtrhN83/gxIBceMjS/44cH9zRQAdvG+lv2Ur630zfxlSh9YxBcfDJDItooK0x0tSDBcpaaV/mIsQJHb2XBWQynai2FzU6DZoRMg3hLvW0Sy39JIopHyEObiSXFAJeXxHYnoJw9FVjpdY/ay10nC8KTEk3Kpq6nqZnWByncVUz4SgMjnrAq2yFtEQcXvY5U2aCHctV4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40043e5f-6212-4de3-2317-08de7938fa41
X-MS-Exchange-CrossTenant-AuthSource: MW5PR10MB5764.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 15:24:35.8343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tbf1domsostO9Gh7Bzpd2OdIBXSM20/uYadCbJ7Iew2rnXLuFGoXZ+Qp8cNpN0iQB8n1z2ip/uVCfzJ6PL+Aqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFEE76E158B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030123
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDEyMiBTYWx0ZWRfX0fAkYZ+qXK1X
 R8RWlwuEDdG0BykWCoiJH1jgeLuBG9r4dn6AVo9bv9kv3rD/vTiQbsJFcI1g79+YZ33wxWcq3UE
 zVFrFBn/Hl1cwnuQqhAk/ai7jHgnCqy5Hor0pDkPixIclfSxq8AxuUnTBQO6gnJvnqYfRPtlB/U
 ZjG1NKiBg4dAxeRYtQcCZtNnkkpvMRDoDV/ES8n5iGkURyNmXbqANssX603jZSyU6EHnqt2CiFG
 BlPRu+QUSV9dp5MLD3rvF+Pv1SECn41Q4kNh/vumB20wxE2VpuHyqJ87tQNTzQuaaPoNRMQW52b
 +SCRvaN/3XyOxqJ0qroMaygrwJASPB6leMq4nhTrD1RTOxtDxoRB4DeUmCIGRXRHHqN3GWlTvpY
 g0xpmFl8GKEY0cwQq5yAomsAw9X6E9HbeQhmFBgDuIYhsGtKgmATAegoOpZ0XEpj8AGLytx3hfM
 Agk3+u0PGKkyEJjzw5A==
X-Proofpoint-ORIG-GUID: LuCc6uTpfFMq8CJ_3Ye8y04EU9oJOEre
X-Proofpoint-GUID: LuCc6uTpfFMq8CJ_3Ye8y04EU9oJOEre
X-Authority-Analysis: v=2.4 cv=EfrFgfmC c=1 sm=1 tr=0 ts=69a6fd38 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=JfrnYn6hAAAA:8 a=QW2pVdLgAAAA:8 a=ag1SF4gXAAAA:8 a=Z4Rwk6OoAAAA:8
 a=NufY4J3AAAAA:8 a=yPCof4ZbAAAA:8 a=1EikDpEGqEO1-poqPaYA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=vf3o9Gby-Vc0ny4K2HEE:22 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=TPcZfFuj8SYsoCJAFAiX:22
X-Rspamd-Queue-Id: 31FAF1C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: o43o8mbbj558ajpjofxr5wwbcjttuwsf
X-Rspam-User: 
X-HE-Tag: 1772551494-250578
X-HE-Meta: U2FsdGVkX180ZuNLagsyq1JMwnfETJCrAK+pBxYLCzyEcnHTgV18BSOx6GbCmJCWbqpTL9qsOhAlZJTUcHCA6u/YpIV2boMh7t54I4oP9N5PmwUfmc0UCTrxUUC5PV8Po4YCkAGkMvHrs+9+GwUL564q0d++pYcxpAtpJt/6QXdy5nmAT0LT3bWRUtQEnMKN+9oQfayCAlyPHApZyxDEYeap9UZ+X8LxsyktpqQ6cEjTau/Y0d3o9C79CQUqHaVcM4TTD8TC9KaeBYmK+N3/IGExGOSZr+u+sOn0/ieRP5vRbzyr1/ZNBpMTaYHJohJaXlY4N7t+d4WWr07od1Tlt23jAjYXWoMxTd6NN6ToEuuRq70Arr1Q2t/2s3Q3EbJ6pmlrPiNX1jJ5isg+YYGeYjNW9EExrfCbre6JCYwd5KoygJRn5cYV5DO44e/YkiaLNo87bceNF985QnPxu4Eut38ICAPK9uQG+XsSTUH2xJ0UabZystZJK87mQKandwHfGTeZ4cVSw9393YStU+/kq8hq9t/t5HK33+7YRC/anjxOsn0EEj8CICOb8H6fhUv1cA/Qvz1wJEFVgOTM9w1ah4+pW7yb7LtQ22b1QyoeuvtYEJAboR3oCkXBVK9j1Cp3ruHVrr3cJzVQz18hrHcZ/RCvsV+v8GhgWTX9iWbh4/Ib+Hgop1H9HKwhb0UfCCrZ+BOimkMnrtON9E+IVFBnx/0S/1RdVn+WPFikOosRiEO4OoIgcKy06Y4y6DedqbqhDBKK+RL3deybz9ZIdMTWmY2lnaLpQOudHb7T7sV9ztkGYBhatUS2Q+1wyKLSkA7BwUlNy8H7hFwtiODSkmwZWQ6t8ttJrKrgksn5IE3r3UcbnKqIPB/po52YwQZHGrvJKAf6PRaOHQMeqDtf2HVXMeuPX0YmPqw93WZyC+FbVLCJKpuTwmAriB8RaQGqfmTKtBuz3x/DZT/asHl0XJQ
 0X9lVVIw
 BAAJpTNJuF8onRS/Nge+5zJNCdJGdGQ9923UaHEFjDuWX6Ax/LI172r8W7n0aM+zGaSAB41Obx/WRWKQ9QWAqSyg7auG+IVF8ctHHIfDmQYozMDH6OlHmtZvaSYNPXFCy2RYRUfVougIfcJ85Aq3BbtR3uDLICqeDMZvBtFZJjNgSzYwjX/QagQ+9nhTVzHWjnSeu2cM9ndz9nwKUAXowAwxsWyBrfDQ5+9alFvYv+r30HrEuc0gRRItij+/YHmSeEaPdsC7uHtiaN05QkboMH9LTjxFEI5vB+hXCsPwDxu91mS38mPJZi81KLt+YPMzk8NKOMdKR34ZVncViJXe2DUNIECLmPgFzBhNT/tFF+6p8rvI4iLeZ91rOTpqBhS+h0SaJvaHD9uVtTgNhMqMULoYFX/VG/YquS5s2y220REEWJNsT/cQREG+D6HpKmFJpLKDS+1x1Cmy2WmwaZ96lF6oTMV74NpLszkDmAZd1OtUWahKJvUnwKDiVRza/b3du3A/skFuUxZFiyc7t8UD8MiVc/COUb+6JrfrYF9wcKpf0uPz4WMnLh15K2IdGIB6ESKhqdPQYc0ZA1Q4uEn2wx3NdWEKIC5rKnzXvENQUYQMOLxFmzLkIwmGmDHUdlBwr+rb5FPpKseKEat1qmVohzHi1T8pppLGYupBZeS0pWT8Nl8Y6azRccUW18z9KiJn7ElTtV5IzqA4DHN1BiNl51GEUaOtIcn3CbwLkD5jWJAjHjkNUPByUVVZYatUEX7vy5sQ23/IUow+2bIQZD9Zz1sTBAy5O1ju7upqFPMpKfy5rZ7eflsAZKVsgQlhZ28yRFsgYR/FksiwVAnBDY/c++YFDbWdB7lyBO3BMaZKckDQWmG4/QvQApyaBtVhPcBD9M9rtLIO7iizLVaAj14KkkQ2pCvr5wLuiQOWtPbWTl5h2V0jtuEqUo6xqaitcWo5T/MckHCI+EhuoAHuTwlg2Mfjg3sSG
 D7U3kzUw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* David Hildenbrand (Arm) <david@kernel.org> [260303 05:12]:
> The backport of commit 091c1dd2d4df ("mm/mempolicy: fix migrate_to_node()
> assuming there is at least one VMA in a MM") contains an error:
> migrate_to_node() does not lock the mmap_lock itself, that is handled by
> the caller instead.
> 
> So let's drop the wrong mmap_read_unlock(). Fortunately, this path is
> very hard to hit in practice.
> 
> Fixes: a13b2b9b0b0b ("mm/mempolicy: fix migrate_to_node() assuming there is at least one VMA in a MM")
> Reported-by: Li Ying <liying3@sungrowpower.com>
> Closes: https://lore.kernel.org/r/aaZgUNxAyKC2IwuG@casper.infradead.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Ouch, yeah.  The locking is different.

Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>

> ---
>  mm/mempolicy.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 94c74c594d10..d8007e1c2690 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1071,10 +1071,8 @@ static long migrate_to_node(struct mm_struct *mm, int source, int dest,
>  
>  	VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));
>  	vma = find_vma(mm, 0);
> -	if (unlikely(!vma)) {
> -		mmap_read_unlock(mm);
> +	if (unlikely(!vma))
>  		return 0;
> -	}
>  
>  	/*
>  	 * This does not migrate the range, but isolates all pages that
> -- 
> 2.43.0
> 

