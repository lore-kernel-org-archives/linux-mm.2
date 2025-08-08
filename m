Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25120C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 13:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3BC6B0096; Fri,  8 Aug 2025 09:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59B9C6B00A1; Fri,  8 Aug 2025 09:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463256B00A2; Fri,  8 Aug 2025 09:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 34DD76B0096
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:19:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D9A5211531B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:19:27 +0000 (UTC)
X-FDA: 83753646774.23.6762DCE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4575420005
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:19:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GmD9mH+w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mCVpAT+k;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754659164; a=rsa-sha256;
	cv=pass;
	b=cgmFGmb2jVcRWVVZt0qTimQXrWeomA0BZTTHzN7F0kgk4hJw4kH9YwOhGzyYr3idjlLTed
	onfToMcbSk0+PsNFerPslDfzLMqYERjIFkP7YJPyTCrk/fktSYc2SPpiCfENjMVbpoJRub
	BVGt1DbMooY4NxAjAeGZl0FVFPxmuNc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GmD9mH+w;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mCVpAT+k;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754659164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v30OQ4Nayo0FFJzy65tBU2dz5nUGvRa8Azik72B71sA=;
	b=42XOhWO0JbuA0nAZkskAep3JtylWViCm53jOvBtg+JDrhohpsYS9zU5Ng5zvRmYId5WI0E
	1BPVW30YixmGvL0s8N58ujRbAQxJVVEgeOlvbLAfSc55Qp6k4vXD2gyAFgxFtVT4HAC2v5
	QfTT+hntspFPIzBmG8zYhpz0LMQZ49g=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 578D3T4C002552;
	Fri, 8 Aug 2025 13:19:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=v30OQ4Nayo0FFJzy65
	tBU2dz5nUGvRa8Azik72B71sA=; b=GmD9mH+w7AUPlptTLLiHPritRF8V1TY2cS
	KyLajpm8n+M3wPoJTV7S5L6wH+bHsvuH/7kJiy7S+eHx8kqwhui3uAtky7lAe/HN
	ExRfqHbwO6xknrkDbzyofO5a1adsLR6fIKmT8a1jBAMFXVN5ZNMM+AmnXKi05bBR
	YZyNY0yCcLW8zJipHVbinD51Y/O6oL8Yp77vOHCb0tDNZi2qI6cQSMEhiKmaDn/d
	mhAbmrvBXrlWM0bFlqkeBNWpThiL94gZx0dI7Q0ejCEbjaZ+cQu0Hebf+1j2/Q+O
	cOKFyoKsc15zPp6mgDTDVax8ZX86RB0IBw6qf34h9Gk5kBeKLigQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvgx6hg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 13:19:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 578BjBJq018304;
	Fri, 8 Aug 2025 13:19:15 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2060.outbound.protection.outlook.com [40.107.236.60])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwtsj3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 13:19:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XrttHT4uR0urK7iFjbJ1md5DpGVUP15S8MX1ZJ0NX/5tdnt/PpTO00V6yAx1AVQx2yUHm2ELYJT4uGFQeE3JB3IXbByh34WjDKn/dmIe/RRtTi+oW5MLxTyiJV2bkbGnlYplpSqlu56ByopuajIJgdhYxQq78x732ue2MUwJSwKn3plilT8Rxv7uADpDZOxPr7PLI79OvQCw3FxcldO00KbhIYZ7SyOfvJ2HJub4RADVK+pzdt4bcl5heQmaNVZMyLSDdoNv9D7zWKQr10s0oBRaHS8Ov7j7cSuzg6P+9JQXg044kH85yeNXBCFpMa8GnRlgliQ5uiLnlSopWifD0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v30OQ4Nayo0FFJzy65tBU2dz5nUGvRa8Azik72B71sA=;
 b=qm6vf0Nl7OAMnImRUotMi1AEPEWhsuq9bC6UJergtBDt6f1kdVJoX3mFHMKJpTSnYlZ7LslM2hQnBQk73L/Y23AngCRKKUR1I+BOQMUNuGOalavxgk0s9Jtb2GJqNk7s5UPqyh6bgp3/TRq8jf0Beey5YWXYTsvkIXDRQm0+coJsUuGmQqoyLgJU/Hy1621t3kyOnM8GOU7Ddb8P6q8g6ulWmoRbCOD7b2u1qU/1krcg5Xr1JhehgJ9pzSE9B/Kmb87uSGB4oXbqAsEQEm4n+VGFSw117GQUBrTp9OK4ysI+DYmJzHZdFdc2fpKBWcwfgikyE48IkK3y+RUqf6J94g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v30OQ4Nayo0FFJzy65tBU2dz5nUGvRa8Azik72B71sA=;
 b=mCVpAT+kIntUuF4ocIefntA7LtbCDrp8Qf4fFeDfCgg3sSY9Y/F/H0uXLIQRb/Min60sGV4EMLM2pyhnYKOw2k8yQs7Qa0wr6ylA6zZd5rVwA9BHGGyEs7yh6ESjBDBCbyYHnAsUIAiFW+veW37oKFiQRSxHGkV3AGpFgm3QlZw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5820.namprd10.prod.outlook.com (2603:10b6:510:146::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 13:19:12 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Fri, 8 Aug 2025
 13:19:12 +0000
Date: Fri, 8 Aug 2025 14:19:09 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.17 0/3] mm/mremap: allow multi-VMA move for huge folio,
 find ineligible earlier
Message-ID: <976cacfe-06e9-43b6-a4ed-24be76642f4b@lucifer.local>
References: <cover.1754218667.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1754218667.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: MM0P280CA0036.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::34) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5820:EE_
X-MS-Office365-Filtering-Correlation-Id: cb7f1b21-16b9-41fb-5275-08ddd67e2aba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wmkLSrAzno4G3DW9HHNhi15UjX4lCYWq5HEllpF8lLEBWX3R4GACVMItpZAy?=
 =?us-ascii?Q?EcRLNU2Y75TaQpikLlmbSddd6RwzYCHkYuFefJ136HFdk+3NXTalxvQoZzHT?=
 =?us-ascii?Q?hQr9vxQ3s2F/uvACfROk3BTa7guvaYArVVwAqAPa0MkRL3kcjVTrIZGm7e28?=
 =?us-ascii?Q?LqyK5HaC/T3g5lLIh3Q9cyiLH5JUdHgojK+4MHH4szcgklB6FUDM5ILnrUw3?=
 =?us-ascii?Q?BpmFLON8u5inWQNs1TlL2XmNFLCUgC/0JT5uEg7dYD7yKW+QQx/wx1of5ZXv?=
 =?us-ascii?Q?myLYAnhXj2dXmIzFoz/QRZCsf77x9GBwrb30qbYQ0RgDyc5XJkR9eNbuWKTe?=
 =?us-ascii?Q?yiqflU+knSR4WoR5dpy7/WxQd0uXki/tUDDHSmzj8K06mb1uqraJJwduw91s?=
 =?us-ascii?Q?oWaDCoPYuHTsw+QgYcvpmFVNrOG3KnoNw4rhZXNjlxFyoAtLEheDocr7gho5?=
 =?us-ascii?Q?HEyIzhKpm9LfFtj0y09VDMvoiNFZfxfmFRI94m5oAeb51kiVJ5/YLscl0IH+?=
 =?us-ascii?Q?DbdWzoaGfyJRXFVxZjVhW6AE0kGvDowiODU45jJ4OjcZsrZaaaN0L21CIheu?=
 =?us-ascii?Q?bA5pxFvqv+LrW9Wks1YK8Eingzs0SNdJ4DNV8lVi9kQMGIWnyIjpNbTX4wZU?=
 =?us-ascii?Q?ad9nq7K77STQzHCyDoXQDx/BJ0Y3GjIXq2CN3kkIX851omvlDyT4GZ9Sd7kY?=
 =?us-ascii?Q?ZFI1hqKq9bvoRz8nGDYx/ySlOVfk7Pngo43lGt+OvqUrEh2+JsdnqNLwACkd?=
 =?us-ascii?Q?X90EEjFg3MrQMQ39HtLYA1jwGllBiLZuEcwW5TEdf5ZpBMUDUhGHcwPp0kGK?=
 =?us-ascii?Q?Uk/7GZAuToPhSWMMIbwwHaGYdd/3YgfGvFBWSQLHHw35ndEchaQSxGeze2ea?=
 =?us-ascii?Q?FsB0gbgKPZPBZJqN/bED5JiVAH0R895YOp0kdRx+RcSZFbfxLVy9fTuhUIsS?=
 =?us-ascii?Q?lVnOQiKuG8fAr7ZenUvLDpd6rjeJQ+fK76gkDF2YjkGQ7CooYpvi+48FktIb?=
 =?us-ascii?Q?yrYEq1hQU89SotisXO8Wg/jLV2av/CjoPpO4G2XgATlrh9ZpMzOEgNGXF+Sf?=
 =?us-ascii?Q?6D18Dy7g0HgyXdhiQLKTDvi/gYp/VSjrwl6cF2JbTkjdWYcP1ifg3r2kF5Rg?=
 =?us-ascii?Q?zbu7iq5imEzpqbSv4lPZ9i9gXr6/D6lXl9Vp32/a+WRKfCTUzlJ4woYUX1Cw?=
 =?us-ascii?Q?T8dU4KJq0uic8cG1d6i5oNfoqRkbdTFcaMPvTUgeWb/EGXE7io1uK8tK8+Co?=
 =?us-ascii?Q?vzIn7P510Lt93qEVllTSXJCKpAVyh6Eb2dNj74D/TvleX3FQVesM6FiaJ6xZ?=
 =?us-ascii?Q?vxDb+wfNWRT1cqYcs6bCwdjkorUe/FkrgF8d1x/hDbG0GzBHgWXakEnFTtSt?=
 =?us-ascii?Q?dc3ySuBCYGVPeFSivX8ubsEOrm14Y0Mhp+RomnS/Z3v32G48KjEjgz+Y+rWV?=
 =?us-ascii?Q?Sj9WOjcbzKE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WeQME8UrUVAG0rzKQy8m259LT82d3n1urZ5zbCfTpZDxEz03NRXtAGb0jKRf?=
 =?us-ascii?Q?qjQvQx/PQPqxH95X89wHg9g9QBPiT12Aa9yBoktJy8UQhler1aUktAcPAKH1?=
 =?us-ascii?Q?fEldQEShUAbkm9mXNMuTLkXJ6X06g6H9xneupQ+hRV9Q/FGmOu0kWfJiU8h+?=
 =?us-ascii?Q?e7X6CHf4e8nP+520V96o1x5blrU8WFFhPvl4j36jhP+dNQg+cahEk50ro1iJ?=
 =?us-ascii?Q?LVpO2SqVZSet7/NS/UWQDuPy5aQzhltt/nOpuyTdgyW49MVqdUvTVJBp1/3b?=
 =?us-ascii?Q?qBvjgWUsiIHdTgiPU2IjqIzKenQ1J5ih2DZ314Tg8k2I29nZrbIEQBmrc6Zp?=
 =?us-ascii?Q?o48NZeiJEQxjizfQXp+7fvwuji9fjyIBCX1yuOWz9hpEzfAB+352tgvOFXKK?=
 =?us-ascii?Q?ICDMF/fIo7e+6ctmNZ6k2YydXxwDpsH71qGSBLkhqkgEawB7O+NMXmOshI0s?=
 =?us-ascii?Q?KGlXHSdqZVNsPm52CngZC8AHT09ZMwul9QjnZN4jMBKstwltt3hxbI0bCPIY?=
 =?us-ascii?Q?tWxkjECuAMAzssVYaEZUww19AaRvVSX6YUhMtsK8+ZhAuFxHYViMNJox25xM?=
 =?us-ascii?Q?/tKa66d+H3uZ9m6T0uyYCtcDjFVZ3rL/O1LdHglJofArgjma10aXDqervXaf?=
 =?us-ascii?Q?kjL63Tn5IluNm/5vDADursSjb26gj9nsSqtcfWzxIUAuHvyDhNajCtjt+BZu?=
 =?us-ascii?Q?MQ1IE4q/CvDmS5/QavLsKiNTWs4VY1esMW7jaNBv7PD1JZ/mN5dW408LEc+f?=
 =?us-ascii?Q?lA+V7oxxAMTcUpRzh2gWqZeuCqAUjF6p38XFI34z50xAFRdiRdbU5NvNmfq+?=
 =?us-ascii?Q?NzuULrQ4YF5j9eiuHwCtV1zTMvfV82Be86L/EGU9Twys1mJAwc+2eGEanPJb?=
 =?us-ascii?Q?1a2v8td8Mmkz+QDjpMDWkmJJMw6LrZEszWC2N6fqrtHwCKdu5solCNIbSOYd?=
 =?us-ascii?Q?L3t/yeSKiNyiOJi2YFKMZ51L3Wtp5EEWkJ3eJxjIQ7Y0ES2ZOxOVoniF6t6R?=
 =?us-ascii?Q?y1gFCZp5F1q4tb23nWsVWhM1mZDyaixXIFTEmr7P0DkjQuFyvCULtryolL6A?=
 =?us-ascii?Q?1E3M4kJKEk/swOqeXycejHe7QqbIHp/zUAmCoITg76gmO1c6OMG2ScP+dWt5?=
 =?us-ascii?Q?iLi9RQBoGo8iC9WbiwnsTN2AzdvkuSLuVZ5JNP66fBXo43X6tzHdJdA+0Cxo?=
 =?us-ascii?Q?sXE42HAZefhSWwAgmDZ6Me9ImgoVOtGT/nR5FJqQGNaObN+fXAVmmER+syKL?=
 =?us-ascii?Q?8f9vb+f/BCJ+XH5kojwGaxe/s90OQBUUoW2FkRZbG65nezsr6ddT3nPeqXyp?=
 =?us-ascii?Q?xybcA6JXr4ntYVPAjCrPUJ+ae+zsCSGeVwlKwMqjaFgyypTb9enmIcUh72CI?=
 =?us-ascii?Q?/bEM6PvFO8xQQl0tm4naSvvplMSQcrBpQqjNrR091lhYF/q66zXpGiNpY1fc?=
 =?us-ascii?Q?AANR87WNNc8orOic3j90oBVFzSM5ZUTM53qkKcDtbitBCJuqCS4MywmBBCo+?=
 =?us-ascii?Q?gGYols+/ClgHXkJEonqe8ZEIgHZBVGLRxM/UvykKgK/mwUFJWF4R0BPjpIlR?=
 =?us-ascii?Q?wozl3itic4c9RwYWL869ikg8jnt7D3Ng9/FzeBocq451P0bToZI8oNOIm7/+?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ofk6vAClRtTVpHOZzxGa/eU35RZwcz3E1vuSg6Q0FZW4CvYXoMGt8GfCFVHRQqleiPRu9nkAUuwDgy2vp3wAUiV4zoz9Y59tP8zPJDVQ7G5NkdWQX9QfJTGcUV7Yhga/F8kV8GCyLSW0dXA4ZxEEwudSx2i75LsmJyjGu2YVdTW0LpmM0r3V73gR+1BOZ2y64VNTubE3TRcBwKWiCZRqIdPa5oKfDEs4ThfG6dJ5I8pG/9DMUNOa+CX6/G1PChVc+N+Zp4crIl1aBszfgB1ATuYjPdDUGeMNQBOGe51RdTFMYYzyFp+CtORYIepQqVc+vA35qeY2o3QjyraYpI+PMPvfGvj95lKsziTSlW9yU3kzVuPt6c/eDXzxomb5bFk56JFsECEy2HWqnGvQgM+bTvNoS5uKVeJ4utsNygeGPHQ3PTtjVpuQt0YsipU6DoO+eE0O/JivxyxxJt9iQisJaAM605il2/OobY37+ENF4yWeEt18j49ZPc00ZC1Op5kBhkQFlKXs04jRZIte8wYCyY5X4QElhrS7tz1mHbijxTNq/QJNyd8WRlAQZ862JPEQYnij4DoydXa9MEsFwa1oD8S8jTdbLKeajqaP5AtJD8Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb7f1b21-16b9-41fb-5275-08ddd67e2aba
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 13:19:12.8274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hYHV4bRwMCc8inDiJrDSkX/q48Nthak/n28Dsg1UbhMrB3W4ZLHQhTJMhRqFEOo+y+yBaQa0R4V2fdp1No1Sg5Lc8nEkU/jOWT4uz7UON5g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5820
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508080108
X-Authority-Analysis: v=2.4 cv=WMp/XmsR c=1 sm=1 tr=0 ts=6895f954 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=twOP_kTiFU3hOX87r5EA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12070
X-Proofpoint-GUID: -O7TnzKZhj2Y0E0V08MFlf52E1rObEdK
X-Proofpoint-ORIG-GUID: -O7TnzKZhj2Y0E0V08MFlf52E1rObEdK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDEwOCBTYWx0ZWRfX9v41C/ye20kn
 zW0mAH7ezK7/1EdkC5is136RizxqvPBPZDf6TTECGIDym+dug0MIUDBHA1YbQ6VRgFWlXYHp8Pf
 JUnT63H/kfDeWLcdyzvHuBWgg8Yw7pj5cHN7TOcgoViXZ2it4e8vn7Zel0DiHtlIlEeQjWjYda6
 b+ff6iF0k5DOF0LEGo2q7yMhNy61NQ5sB88nwWyJrW0ysqpAZPbLhiKtbKhYBnJWEhtS0ZfBPFL
 rZXNd8WaFINbf/Mb3zwrnHX5efofAgGxQ6dbnOuLK+CgmS8tn7/PnNYfpFDVJUvqcI12vBCrRFk
 amW/KAmWuxB74OtpS8AFRXPqCifrYgDIGsU2Ood/DKY9znEffn281CS1LXRyWs1m7S9001/g0VM
 a5xP5paelDhDTwiygQSMacXdj7kOLLLP3735MnbbytQL9b9Q96fwx1Qo+QsYCL+ChEVoGNSY
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4575420005
X-Stat-Signature: qz6g9odur8syat75oe3zqb7fzypi8tqw
X-HE-Tag: 1754659164-976466
X-HE-Meta: U2FsdGVkX180JZEsmrslYzjYFZ5CpMcgRA95nvDcNh8AVSqW+nsJhisfM/r0eOpu+UEacLG/sWZ656EwJpqSmBWR+Pbn/bxQR3AV9LFgV614y9lhZAICooW7LC/qMTbu46X5NiOG+SY3xk4Ty6ZH9dxyuuiZQSm80eM7d9FxPVE6HUBulzJ5DE6bsIeoTjvF5NoQ9Z8gMcOH10Vvbaz6TWMmbcugKE8h02wBz1DWqRUrtZumVpZNp7cwwlaL+BuDycwy5Wzii3Ef/sNvYGMvzmMqFjcIzhtVVBdnQtJtJlROtnbnaLW3HpdLIySO0aVKDebTbYhwRe45AFX9Wl2JyL1LiX7/xWhxlUnMM5zm8y5GYjDNdDJAN/JPkVO7K5SxcXjtqQ6VM8DkJrhUJvZo7lnEMyOPQA4oVYYjbKi4THkBMtVX9k9jek0akzC/eQwRJAtu5gBOiXPZWH6Nme6pV+wuxpll+RRMfMF8zk3lk7//veq6UzFwHnTouilyxuLyHnPXWr+sqWR52jpTGTvMglclr2UOwtWhGRFA1IO/Vk+TR6TcD8/8mZi+U5KIUvAO45aWs8RsWAwn+KRSEq+aq3JPAWArTo+VxUfDefvNF49VAsNh/Ch57VwvUzce6rRMw9BOAPHybzrp6d4aSpOArAMaWMherb2zEDzuwLwzy8CxPNs9SWWRAg3IT27krIh3L0PPLaQxHQMrqSS5NNhQKeHgXdHGmBgjcciYVcyhbpzVI8CABMsc8ZmsfD9OHBtEGNBPMmiqnDBb3Zvtrsvct4Jc+PhJx6uIkAmn+lVHAffuELnnb+Tw+O5HtEhTBkA95/6fC6P5q6aA8YgKFygcuUTsa26IptQZzVO5MM5mQ7Y9NGYJ3EHzdP8R9Wf5FeZtS7rfyhpxbx7Eu1LU7mumdJrBf24U+IzJupcUTjah/aqwDgEXd1XSY8SVOFVBTvZAGwRcK+oTEM7A9WgsDNA
 OczZtrQP
 2+8cXWXQ8nAd63cqwZC5792qg5orE85JesPtaoeirw8z/HTNKynx6tPSEl11BxxcgQOEF0QvK8Li5ZuAyz1IgUsL2PXUKK+OhgSgmyIxKCXXVzdkoSow9nhvW0LFPWVju/jUc1GonB2GcmBNQpnFYMOhHzRgvkGYjepWxi/k1hQOd6hguwdDXFVa7C+jXsNoQHQtQCPqlwbezd2iRpmTZBxJzLqeLKCXntoN15GsahrzmbDyqvOFx/L8JFnGIejLJ3RC7gGOhKydGhJWOwibNxHCOL/PZ5BMhAL+NehY1Vycu4FzAQEWMn8nr8HypBOCxfhhxtDie6qzAHj7FtYDGUDzbVXYkmrdOQZj9ly2LiiZnVWaopm0zuxRyzInaC1gDOk3VPyePhAw0yiI9GT8ULTIREN2NEY0Jz7jEGIyF4ERFZOrcfdb61To9Eo3I3RplI7VWje6Enr7fcyiX/EpM0hz4pW7oNgEK0R3u8Y5kY+Z3NDxAguBW3ciE5BRHHx6Fr8tZ2ROxIHqmXA6dh1Wt0+H4HmdELe4NO7eDMsaLGTsDvpbNl1ZD6uWsg310GZeDG5MynBGddHKshjYa78qoOQmkWwBJiFMHYnA5lixRtHanc3fj2UC6r0xHESHVeR7s+YGOq6CCkSPuXYxWlz2nu9ruYsshBWJiBhflcT6kQA4pI+d6I2xgzHtyvjcMYkswyQQGRUr9iS8df6+5TjoDJ6QfjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 03, 2025 at 12:11:20PM +0100, Lorenzo Stoakes wrote:
> The multi-VMA move functionality introduced in commit d23cb648e365
> ("mm/mremap: permit mremap() move of multiple VMA") doesn't allow moves of
> file-backed mappings which specify a custom f_op->get_unmapped_area handler
> excepting hugetlb and shmem.
>
> We expand this to include thp_get_unmapped_area to support file-backed
> mappings for filesystems which use large folios.
>
> Additionally, when the first VMA in a range is not compatible with a
> multi-VMA move, instead of moving the first VMA and returning an error,
> this series results in us not moving anything and returning an error
> immediately.
>
> Examining this second change in detail:
>
> The semantics of multi-VMA moves in mremap() very clearly indicate that a
> failure can result in a partial move of VMAs.
>
> This is in line with other aggregate operations within the kernel, which
> share these semantics.
>
> There are two classes of failures we're concerned with - eligiblity for
> mutli-VMA move, and transient failures that would occur even if the user
> individually moved each VMA.
>
> The latter are either a product of the user using mremap() incorrectly or a
> failure due to out-of-memory conditions (which, given the allocations
> involved are small, would likely be fatal in any case), or hitting the
> mapping limit.

Correction here, it's very confusing to refer to user error as a
'transient' failure (it's not), so replace this sentence with:

The latter is due to out-of-memory conditions (which, given the allocations
involved are small, would likely be fatal in any case), or hitting the
mapping limit.

>
> Regardless of the cause, transient issues would be fatal anyway, so it
> isn't really material which VMAs succeeded at being moved or not.
>
> However with when it comes to multi-VMA move eligiblity, we face another
> issue - we must allow a single VMA to succeed regardless of this eligiblity
> (as, of course, it is not a multi-VMA move) - but we must then fail
> multi-VMA operations.
>
> The two means by which VMAs may fail the eligbility test are - the VMAs
> being UFFD-armed, or the VMA being file-backed and providing its own
> f_op->get_unmapped_area() helper (because this may result in MREMAP_FIXED
> being disregarded), excepting those known to correctly handle MREMAP_FIXED.
>
> It is therefore conceivable that a user could erroneously try to use this
> functionality in these instances, and would prefer to not perform any move
> at all should that occur.
>
> This series therefore avoids any move of subsequent VMAs should the first
> be multi-VMA move ineligble and the input span exceeds that of the first
> VMA.
>
> We also add detailed test logic to assert that multi VMA move with
> ineligible VMAs functions as expected.
>
>
> Andrew - I think this should go in as a hot-fix for 6.17, as it would be
> better to change the semantics here before the functionality appears in a
> released kernel.
>
> Lorenzo Stoakes (3):
>   mm/mremap: allow multi-VMA move when filesystem uses
>     thp_get_unmapped_area
>   mm/mremap: catch invalid multi VMA moves earlier
>   selftests/mm: add test for invalid multi VMA operations
>
>  mm/mremap.c                              |  40 ++--
>  tools/testing/selftests/mm/mremap_test.c | 264 ++++++++++++++++++++++-
>  2 files changed, 284 insertions(+), 20 deletions(-)
>
> --
> 2.50.1

Cheers, Lorenzo

