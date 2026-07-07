Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC087C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 23:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6EEB6B00A0; Tue,  7 Jul 2026 19:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A461C6B00A1; Tue,  7 Jul 2026 19:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95C496B00A2; Tue,  7 Jul 2026 19:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6656B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:27:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8FD81205B4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:27:44 +0000 (UTC)
X-FDA: 84963570048.18.6DBC5B4
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010038.outbound.protection.outlook.com [52.101.56.38])
	by imf24.hostedemail.com (Postfix) with ESMTP id 077F1180005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:27:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OidEmnBs;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.38 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783466862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hFMdpD3jQWiW1+/pqU0mO4NzUetP31JfCCXjbtZ4h3w=;
	b=de2R12QMeeHtguUgNreMDmZYdMhDuga/yeNdKtwdkXLyKHQpWB6JkZSQC0Wz+jyob4rfju
	mUKq2RZa4OkK0H0QsgcXNRVbhfMN2J6dXi+S6jF3bNFNmPbGm2QTqINC990Kt1pt1tcCTP
	7xpGO8qsm5Zm03pe7jbZxC+mTBf6ZJ8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OidEmnBs;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.38 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783466862;
	b=cRZ1wzz3kujcco6MKGBl/96CNQ4njP2/fOKToDt1DzkIV0kPC1oaUAmXvj++PmzF0OuQdT
	FCuvST0p7g67kOdIaOb/jcd34GAZJxuAx4vmdP+1XEd2roplZtuE3tKszqF0vcfKcnU0wl
	MJzWHIEA33OKgx2hZhMkQlcDyuag51w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VvVgRqxxVkx2kuFtovA20etJFMUiU4v7ME5e0BIfgFkEyyRMbposqfItRxPijehfKFRqPH2tkQI0jNNH5T9jhyewOhpog29rjwQUg7lUjUSEhZnU4Zq+6gf3qV0kgH8tIYbd1FtAwxwrdEiYqiptsSJVG0bRM9wLIYo9L6W94mU5xfdSTjI8oy8zFjeaJt0/lACE5rn+vauFqMuk532Et3iXOB1bgjgEUOiT9LCheRBrsCHF5QRZRgTSLRL7/Rhh6zuV+/4w+JdzahemzH/P2zeVB3mMINgnLLeckedMePuibFKSMNGi8Y2pxEsQCx4ckokhXCqAo08DT0KHS282Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hFMdpD3jQWiW1+/pqU0mO4NzUetP31JfCCXjbtZ4h3w=;
 b=XeoOXlNRqqbEF3JjTA2j2ogRpEZZFoDDeK5guFhg43bCuYcd0RSvpFSlBem+Fj1WL4qdgSZ+nK6qXr84UWrNzuThLNEsOYLiZXgiXWdFLEDgxe29Gnleh4BWTRapS2KKLG9c0fGdJwLZFsYeJXYpwfzOtB4NIjcTRANxABY30/ul00R0l8SiExUdhZ1d/W05NfZ2xOdLQRcyxZvSMnrRXOrcULYOzpX2fiToGKpKueQdP4jF3V3uOnkkm1CORvZxTM7zTEFsaVB/8I9HIo0nb+ZTsROaUb9Lqr0iR0Skh1feLx3gGtjmHlAwdbrhNgnKCeXZBD7VE82dBM8LSvcQQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFMdpD3jQWiW1+/pqU0mO4NzUetP31JfCCXjbtZ4h3w=;
 b=OidEmnBshq4CYdmhMA2Um3lGWV+t0zGm5Z6XZinjrNqk3pte85wgFc+9EODeqMNnV08GRwMXJZl/5bjEdTcybbFk3ckxPuIUsTLYc2ldrp+nqD6o1Y9oMg6LcWRlvazeuJHt0k7foYIxHK8qNP5V/ciBW7VN6Nh5c34yZvAQgJywqNCeNIIXldwie1Ra/1IVIu3DQorZxCLMAlqvOAWto+kRaKhXQO69n6Og7K4l/1Ll6H4gruLijAxSErE8d6sKhzO4GanKYj/yIv4u0VNRpJeGWGLwjFrpiYmaWpft2cVh5URvBD10BbIs+TD+EJiC6rcEJbJ6ZndEFVmSj5sI5w==
Received: from BL0PR12MB4995.namprd12.prod.outlook.com (2603:10b6:208:1c7::23)
 by SJ2PR12MB8740.namprd12.prod.outlook.com (2603:10b6:a03:53f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 23:27:37 +0000
Received: from BL0PR12MB4995.namprd12.prod.outlook.com
 ([fe80::dde:9068:4b1a:53e2]) by BL0PR12MB4995.namprd12.prod.outlook.com
 ([fe80::dde:9068:4b1a:53e2%4]) with mapi id 15.21.0181.012; Tue, 7 Jul 2026
 23:27:37 +0000
Date: Wed, 8 Jul 2026 09:27:32 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	david@kernel.org, dev.jain@arm.com, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, matthew.brost@intel.com, 
	npache@redhat.com, rakie.kim@sk.com, ryan.roberts@arm.com, vbabka@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	sashiko-bot <sashiko-bot@kernel.org>
Subject: Re: [PATCH 2/3] mm/madvise: skip device-private PMDs in cold and
 pageout walks
Message-ID: <ak2LRXe1r2Qk4E9O@parvat>
References: <20260707135255.292870-1-usama.arif@linux.dev>
 <20260707135255.292870-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707135255.292870-3-usama.arif@linux.dev>
X-ClientProxiedBy: MEWPR01CA0107.ausprd01.prod.outlook.com
 (2603:10c6:220:1e0::15) To BL0PR12MB4995.namprd12.prod.outlook.com
 (2603:10b6:208:1c7::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB4995:EE_|SJ2PR12MB8740:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a681c54-01f2-4a11-0c26-08dedc7f547a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|7416014|4143699003|11063799006|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kL/tyDMTvPpjf2EHHKnjZBnIKT5yAYIxGh1v2vt9fXn/z5vaRmCXq25g49+92csP50NYaYjItSRUoeQxvk8Uv9gnoIgf3NuOxgDRxUp8FUq/v8Dzmi39r7duynR0kA5WagyRE2PgfyWwf1nPPmUVJplpMKoE5dhiGk9e2ix2dJoxrT/WigrWe+Lv2XgY/CIQntstL58MLks+MCPZocXo4DI4rbWIv3DgoK1TaEFISImsI17XFqbLRHb1MdvqWWLrz5lsYNyzb7Pjp4FtWCluFcXe9ema5XXCjawA/WrxCUMLXrtVFteFot/H6Mblc4GFrdq/t62rAsaYGVmbRKso3Sg2t09IoSb/fnvy+nQxiNfzRsp3cHyv8P3YVoaU6LSpxiaJlmoGh0O+YiGQEquSj/IYvSmJbgELbM3PRd9Gdw/Tsdi3rzUYj3x15/vkywnwdIhyC8UNMPt1K62fS7gO3z5kdvD7/dsQ9PcTnhVctj/htzXTa6//0EK1dAmHkTWJJihVyTgObuByqz0bRK+IqK0RvFKkG0lmGh3uea8jFKSFe57eeXHMleEtGa1iGTCWgQ8vEIcoIpi6+Yeiu4AqnISR1Wo3FuJdd9cmphsHBC3j+dVNV4VWWqA7+H5UFJi9AvK7Ua37r8ezPL4lfWAgubj4aP15bVb90jFUdv8dUgg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(7416014)(4143699003)(11063799006)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ROP2UiVY3xmut9R/33kPekVbx4s3fz9/rCoyQT+ITgV6Etk+iuRuIFax+rYM?=
 =?us-ascii?Q?WYxPCJWi0VN36MHmF+/tcIGYzE7rM0ERjA7AUjF7GYGLEkF1EMaUgz7lMAcB?=
 =?us-ascii?Q?GpDUzBozgRY5cpoazoLIZ9coXmpq68tMnSxgg05n8i7tMLW+4ncOEz5g8np6?=
 =?us-ascii?Q?BuMkB50/tN61JjWHOPZsEnJr/zGMTxb92gW2tJ+ie96kZy0sy+R6t3nML8IF?=
 =?us-ascii?Q?RfgokRTXNNKqRd4hUnZFcPTEMhQ70mtHOq8aFSq3zdkf4mO9bj+zK2AQeNAU?=
 =?us-ascii?Q?WAy3q1XWXOCRkj+6GdIOUyMr3klXOJwfXKq/1JUgNLRp8oLphvmYqJ6XnloA?=
 =?us-ascii?Q?gc/jr+7rnN3+NTb8YbwdXcidvJjn5CEjJiofe9zhlxbiUmz9Kq/Lvuida3Bm?=
 =?us-ascii?Q?g0KncxiCsvzOCpq/+qIVPDbvF8oYzthYdXKqe+Agie+oT2MOMr9lDOAGgeih?=
 =?us-ascii?Q?MK8vaSAT/7JsWAoLwah9YafDSF8HYjHsVVBxE6pPLYdbYtq5xBMaRcK/0iw5?=
 =?us-ascii?Q?mcVBYLexPDbtIxTEQoySYZx9LiibGK86IdJWlbLna+wJVfKPnpJgDkUCDNQ1?=
 =?us-ascii?Q?iL4/AxvBkViQIL8YIlHIy3SW5QqK8219L63unChiw477b4/Ath8MnmDcBzna?=
 =?us-ascii?Q?jhCpLWbtAIN9/xI8rulbU4alTAh3B3HE5GIo36nr7kUrr0Rfjr1Kl4jfTE1j?=
 =?us-ascii?Q?nqS+YsDu3uhydggBELcm4ijJnnaxANuPrXhW93lOeGdm1AyU9bulMeYrotB6?=
 =?us-ascii?Q?8HqOURE6KMswerInMeywZlejxCwkCOqdZwTMWg29o9ZfOZpz2XBoojsK5pcw?=
 =?us-ascii?Q?0l7TFIFru9ebdhVZuauhKrZfV+fUFvdvZKYLnhtk+RqS9lDcnmEz3SvVHKa/?=
 =?us-ascii?Q?YROwgizgXlg6gGGKHHkbsV/NzHFj2iOzMFqWBL1W6SNiUDZE2ToesXG0uz6S?=
 =?us-ascii?Q?9KTPCR4o4N/hMVMPC8cLfu+iTvvzo1sBAeizXOHmUqlJYifuL/pe5NRz1peo?=
 =?us-ascii?Q?9mcb4qE0cLTVb3YizSJ+ZOlpEhFf8Fh0xaNMsk25vy7c6bSnJGM0ajxPZkZD?=
 =?us-ascii?Q?LN4AWMfK+Rtwx9/onFr1xOOSzOrqYn8dzDrE4mM3UC+DTdpMlsA9vpOxDUSX?=
 =?us-ascii?Q?BuzrsAwR0ai/5CA4wBYei0RtfOXU0YzE4/DAl0gQwvFhnzIJICdxLbg00zI5?=
 =?us-ascii?Q?DVHDRGUWPHqxZQphGhJ37DLuipn59rWNEPuhzsAm30IhfhGTti1ADMYAJuZT?=
 =?us-ascii?Q?p5z6erXnEz5fPJaVWKH6BvSFzZmww6pST+rSVLrIy0B1DRyle/TGDth9Etjx?=
 =?us-ascii?Q?jE4N66RZoPDoeHa+b10hTzSZLkr9hZI1XBU5IGtp5+/HoPXBFQnw/x6ONxCz?=
 =?us-ascii?Q?9LY3WVKPieFtEusW5bNDGGFLLvvjuXujC1I6185INWuSOIZLjXW49OdSQQDh?=
 =?us-ascii?Q?A7nj1w+hwrqRnmu3WxMwgABq1lPlrhq2YM+eVuCpZUhWnAXGtMaFqAnH/+QJ?=
 =?us-ascii?Q?m1Hw7FNmww5NCra4F+dhqPkyw5UBEmScCAQzrG/M9ZFPDTeZn9XXB+SuX5Di?=
 =?us-ascii?Q?mDr9itzel0OFSwB46kiz2DKLJqFrV96oZF8iOLiVjUfzWdzBEli/rawOUJU0?=
 =?us-ascii?Q?eml1Hp+huIqxKO6M10jc2zEJ8KIB8o1rBOx51dSDNHqquf4yedolGj78UCjL?=
 =?us-ascii?Q?mt3dZf9po45U/HA+JIO3GbflNFdgwM2rd0TGb+ZPU89fmBpv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a681c54-01f2-4a11-0c26-08dedc7f547a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 23:27:37.3727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ozbI0+93SUyupwt+yWgsAvjeJFFE2Xp+2fl6R4lCPN4RMlET2aSjYz/k7PAGbZm502+GekDs7oY2s4gscNNAow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8740
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 077F1180005
X-Stat-Signature: mdyueoaso6j78jeihktsprq6jyutwn7s
X-HE-Tag: 1783466861-360143
X-HE-Meta: U2FsdGVkX195p/o8lvRZMTzZS1QayU5BlzIQgiuvoU98D9jEvEh3AbHkRxuUjaa5WPRdCTTGgZurzLuoz4sN2DfTty7+iE2aVT3j4hpY0LCJ1LR5VsbP8bYOqtrEg7W7PHeQO1MmO5YZGsNZckAfAUTpiDcWvyhLTPYsk+u6cxPHW8I3azKetkJopnJdz38pnN5ZkY+oKOkiOj+vB0BNFnd/GxXxqApCdDrBmde8CadXWLkyk0+zyEWnqp8JpFNO9Ep0zb03GJ7V4DMYBuf+n9+tiMNep/AmAi0K+spjDhMmRE3PVYKyl93ZcLdVe5DC1KfIdIRQFJfUbEbvb+TTnuzjANLwK4KbrPfGOHAHtl4ts8weXx6dksezbHcHy00maXlo7YiZZZYFFyHevBt3Upe7LtfXzlfzVuI3O3+Jc8PrGGVErx0tpNl661HDHDjZZzN+L5Xw37gqRG61wbaiODCaeYqPCU15KXfhjxapgcnBEJgHdV4IV/LraDjIo6OeeMCQUZMUHKvgKibgVgUIsIAFa87ADsk5jLseOHz0aFc2mRQzV5JlkMEZpukTgtEANQ31mxfMzST+icc0SkUg+py7szYe0goF5usEodAC8BbMyBnsT3JMWMKC/CyDCW/xoD/2De6UPMjmYLGI81ctFUrqjW3ondql8tqe3h9yzKGyiBOQHWuKX3SYLjuk8yM56ImGJC9GwALeLaM2Irj0Y25DMvu8Tx6ALi4a77yR8/A3eTfGeRTLBHGwl9KzBHviq57+d6r1AfzZCwud1HtZ1gO/sgkHhJHimiOXCzyugKRVv5UO4pgHM2e9uRttyi7wfMIeKBQGy6TNUY1Gd/PyvKfVK6kqPJ3qToBWfCrKJzQ68wS1nkmO0w5VCRwtByGXtcADcm0ucnGuBo0UnKK8iZvNUQM25dusptfspridcS04CDm2BGw16NrmU6pdxNDqYWg3SQJ8iHgMURavMCU
 XY/oxA+0
 xMJYu0dnIxdIPdJvvlao/CMvm0FqJqwFkFDN0ufWb/GanMLxrWazHVruhMvqwkqyJ3pn98U0URv3l/KdO1VfK5K1jWc59mEpYtNg5S6AW2w7DuuwDxQROxouVb3gnwenRVIr3ZTqQs225P/EKeyqt6/bTMM+8Vj9bLZ4+rrt60hYzZo20uh8w1ZjQlv4IZpzcrXJlt/dxnslX5eGvIeoddDqkN+SCaMAleUfvjT+aOxZ83IjV4W6GB0/lhbEYajILVipYcXtJmVSwdN2eqS/+C7AOxR7tP52p5irWJZr7dN4kq+E3W6zChAWuXRB8NBAhnoxzjChewPnPI28AUYoiB7YA7h7phC0RGTsTR1PzUymVO4epPnxZq5cLmcPCJYWWDI52KS5gj9I8SfV8ASCTv/YzClGj/g4/PM9hskmJn9UJGymBcOChE42kMuBXknnU2R3Hl1mJEV/hY6ISnDJ8v0xQi5RNWQ+bN+a6hKTsGImpI7XIVdZYf5nCwxDKlco90/66xGaod/4uO6D3PxgPa8Yy3QLKqHJ2Ke3dcVX39ywr+zOEOzP+Se9Hp+VZMQYNYwrxTgotAki08f8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 06:45:08AM -0700, Usama Arif wrote:
> madvise_cold_or_pageout_pte_range() takes pmd_trans_huge_lock(), whose
> pmd_is_huge() check returns true for a device-private PMD. The subsequent
> !pmd_present() branch has a VM_BUG_ON() asserting migration is the only
> allowed non-present case; a device-private PMD trips it.
> 
> Potential trigger: an HMM-based GPU driver races with
> madvise(MADV_COLD)/MADV_PAGEOUT: pmd_trans_huge(*pmd) reads true, then
> migrate_vma_pages() flips the PMD to a device-private entry before the
> PMD lock is acquired.
> 
> Skip device-private PMDs after taking the lock, before the !pmd_present()
> check.
> 
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/madvise.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 9292f60b19aa..870be398c6f3 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -384,6 +384,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>  			return 0;
>  
>  		orig_pmd = *pmd;
> +		if (pmd_is_device_private_entry(orig_pmd))
> +			goto huge_unlock;
> +
>  		if (is_huge_zero_pmd(orig_pmd))
>  			goto huge_unlock;
>  
>

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

