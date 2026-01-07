Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 429D1CF6C1B
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 09:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A57FD6B00A0; Wed,  7 Jan 2026 04:23:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B746B00A5; Wed,  7 Jan 2026 04:23:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 910E26B00A7; Wed,  7 Jan 2026 04:23:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE5A6B00A0
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:23:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2793714021B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:23:43 +0000 (UTC)
X-FDA: 84304630326.03.9B07B52
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011048.outbound.protection.outlook.com [52.101.52.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6391B40007
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:23:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Wnrfl7zU;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.52.48 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767777820; a=rsa-sha256;
	cv=pass;
	b=3tGK1HBka/GQytMMeGtdSXx0qSHyiB+bc3rt51PvGQLOLhhusqjwa1gIIOi6qMepM76GgO
	awRq2Ejsj+rQvZJ5PiCP8dEE3k6JsKZ6hua0GQP15Go8X26IJDzUgdodvNIFxbbn8Qrd19
	lqr2IFz8Vtz0xcqKHj9DbkEdzvfJH6w=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Wnrfl7zU;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.52.48 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767777820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXlf4tCqAJa8yGxE4UzLHrPybH0ghXSvneYVCU8VoD4=;
	b=VacvMfvlvipqrT3IgjxbgJ0YDhWA3/z8c38X/1c1JKRt4WqXLYkgAAiw1jCl3YfpavgQJj
	8ArooUm4rkCPgptl0AxqS+sofTL0ytKa5gp2kfvdnzCj+jcTmYGpbSAVNa2QMjytBL8+ZV
	Hr86eGrF+dI4x8IxYSj90/gHJb8z03g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cWAXa6f/KAQ1b4Tonky5JRaRkXjcol3BPtCA4QvJJ1VSLOAE+5uY7iM+9p/CG3vaIZFGwcP0wjlmTHPkMgrDuI2v8UPPQhCeVXE5VRJdp/xqsJY3YuszVYSS9pDMYLLmPtR3bCHTC2iQBsSuBaDk49+PcceQ//C9y7p5IJSeUZCbAYViErLetC4ccMuQnI68WiSyi7AosKqoU9hMOR7kq2X9fIucC1ZAVWj3Pt8GUn/sqQdU9o/5gd5ST8MGJHoeQxF1RIIO3L5tNByM9wAAwumF9Wh6jrzmJZhSivXLWL+LeajOEOt0JvjQCT6p3mwHS0zh1QRdrKtZR+phn/OP8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXlf4tCqAJa8yGxE4UzLHrPybH0ghXSvneYVCU8VoD4=;
 b=hgPv0IIQfNMnR1iiioxYQ+2UNzWZZtkVjUm9Boc1qXB26oYVsDguMOaVQQO0MuiFonWeUDiXeXMJmOEW++ZagsDcfPLfaVtx1yKcEposfSf+b9jzJ9CByU2s57K3hpCumhHaonwaBI6yr7ByACrxiQn3JqqI1HGeAujenloMz6dA7AQqo9CxOONqHBa2YT2b81lLxntwRJUA/Na6M8UjztJHw6WauhyGJR+k+SF3iJYB3EJqPh98DoavbFJiQlGQwxugwT3PZG9T8ZKg8odT0Kpgo924nuVspEitGb7OuanZCUoack0f/Ejkm0Gu89RKYIYh4cXf2AEUKRWSIB8Zqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXlf4tCqAJa8yGxE4UzLHrPybH0ghXSvneYVCU8VoD4=;
 b=Wnrfl7zU5E9x1uE2ZL1XQRD1UaWJfstpw2QNKDRwPIWF+NaDH/r62BkWC2g9DpU496pimu2TwHSQsb66NOVIGVFm6NAUPS94LpdNSnYGowHuqx27bpEUv4I08DgN52mJ6aMA4mz8M1FSM0B+72G7nuAin/AG4JJ+C2SlunKpFyvr0Va2oCnk/FZvB9bpkWefMsSf95BhdHKDBE9XgeGW1wYusBR+x1xNHst+RCnu39DdGzzsmrNlQ3y9QgRArQS3MpJsLCAxmEA7nrBVAp9iYsVrZF11ZK8oNcUS0WGk1YWWmshDTZEF1m6oZVZZRHvbfvVNFC6uiyoyXxgSKDZraw==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 MN2PR12MB4335.namprd12.prod.outlook.com (2603:10b6:208:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 09:19:06 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 09:19:06 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com
Subject: [PATCH v2 09/11] mm/util: Add flag to track device private pages in page snapshots
Date: Wed,  7 Jan 2026 20:18:21 +1100
Message-Id: <20260107091823.68974-10-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260107091823.68974-1-jniethe@nvidia.com>
References: <20260107091823.68974-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0077.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::22) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|MN2PR12MB4335:EE_
X-MS-Office365-Filtering-Correlation-Id: f236f506-a5df-403a-ebd1-08de4dcdcecf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZTQJESdiy4jj44xcSojXZJoi5arAP0HbfwsLS83wdabYJfZyU5wUWvssgviW?=
 =?us-ascii?Q?qh9RAqfIBF8qO2l7wqzWVqw3x4YyyAfX51hGzPM+F1i8eoJWt4gmmkLPO9o3?=
 =?us-ascii?Q?Au4+NlKSCw8BcPgDV2JL/usSgPuxsZzcXROCaXNni9kKHIbRMQH2NYyTLuQh?=
 =?us-ascii?Q?PPvoJghW4zqCHQTu7ZTUUMrzJhTaTIg+79B46ln7ThM3Y4mqvzPnCpvp0F50?=
 =?us-ascii?Q?I2wWZk+YLUup1q6wdouco43k1tSsZ8yyXDT0dyy7sROEeiRaKaEzc2M39oNy?=
 =?us-ascii?Q?ZXRYPtQN2f6rCg+EoGpw8fVQa6s4V6RyuZ/hc414Bl/3ku+NyQP0OvpLPYYk?=
 =?us-ascii?Q?nbYfA8WKn92LOvZERHeJIHfUZGuPBlZD4uLNL0rORCZCVu0PN6PTjNRwa6c+?=
 =?us-ascii?Q?K56DrFdf4FosxpdvGgbx1U8Vb+3jc7aixMIMU++kJXE5kqxHAdSDsepPTI6e?=
 =?us-ascii?Q?rb6PZVi/u2HgKBfsrnYwKMzVAYCRa4O8H+KRQAzcdLpKoM32FXp2e+PF6v7O?=
 =?us-ascii?Q?Wthay8hPLiJquetU+FGcYklLNiRMIRo1aI+AaidxBBSMlUHWmSN3q2g0veAL?=
 =?us-ascii?Q?LPPUOPEIceh0BCHBDFFqEHOIUe4tKwHQ1d0KjoVx1xK57wGWuDBsl3yTvhOK?=
 =?us-ascii?Q?Z1RRxOdNbA6BrLNlWD1l+MVrS3Ctc1wd5m3mrpjTRovQPH3yONhVE+gtmAGJ?=
 =?us-ascii?Q?4CTzQp6pomKEBj+QywlMW6EMeyFYMzaKJktefZKAAkxYD9o7XAMju8V9p4V6?=
 =?us-ascii?Q?KS92Xo9f0FpHjs7zo+r7i5YG55tP94Gn7eusgxunSKS2Slwejc0HawWQHUC5?=
 =?us-ascii?Q?K8bW5JQdBdkvuSomRNztRMEAoX+G9jz9N49suahl3BnaJTTB/dk+ODG4m3Ls?=
 =?us-ascii?Q?pzT6726pvUzD3GiQFwMkinKr1sxGdJbjaxWej0YSMZMw1Ucrrpg2+azzwbVB?=
 =?us-ascii?Q?pG1Jl+hWYgqOsZfOCBGLhqJc/zT9N7ChB1JzNkeZnmH+8GLdnF99D9/QHOkk?=
 =?us-ascii?Q?DFdWUW+OEMRe8JquP9X1F+iTqaqjmz4UvT5VlSPE4OMGfaHeWlX5M8Wr0gIm?=
 =?us-ascii?Q?8X04TUZcRMSUMHYl6YxBS6RpydtX73NvuKpOb223dvNtJG5r5gouwkL35GaJ?=
 =?us-ascii?Q?MRRlqfmCtfaziUCYsCtMX3iSkoaqGmnn5bk9/dkJjtuoSvJHfTW0YSRwFoLv?=
 =?us-ascii?Q?1rS70XqXz+jYglZbbSN8H3YlejXvBVljn6PjUAb9b5uRL/wtW26kH7J/7fWw?=
 =?us-ascii?Q?V+6sAzEZ4eSCrZfrt1wUTtctMDVXXqxDp4hnRvCV8jAhXjox25OMIE+y1H0x?=
 =?us-ascii?Q?6UTXGgATRZxBtCGtLZ8INAwTUDXyArApbM0NMC2kh7wPNYLuhP0c9RF+k9ck?=
 =?us-ascii?Q?pi0Dah9gkFt9jNl1vpOsiOGKbUFnshG5U3wXaiVBsMKFamtK+drvXqXQYuqH?=
 =?us-ascii?Q?xKfp9/mVkylcI7/JXQaIqSlNaxyZm17L?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4j7eQiyRbbmd+GlL1fDHDbBR7aZ69S+eocg0CKmaJryGxd7+XxjotOlgsLsy?=
 =?us-ascii?Q?ja3b9IgY4IGUXzaL3omH+dBvWTCCnfhuSz+jrmNCk3U0wQTuys4HETCLmg8r?=
 =?us-ascii?Q?IBmyGHPfAcBG1w06UW6FZF6dlqrlUk1TqUP382xEH6+++qOvz+V2ycqHD2f0?=
 =?us-ascii?Q?8Xfelunv8oWf7FcQiwoMBHVSxx3ybOWTCYxr65EI3vhCQyNoAM55QWDf5JoQ?=
 =?us-ascii?Q?5za0V3RVCaPUy/FXCC/0r6kanCxgslJdwZ+/1DvmVnSYB+7eLxwrx/MwXr8i?=
 =?us-ascii?Q?2OHSHvcwoDqtXjRRNSnpDMJrs9nra6v8sQKdcpxFSRx0AiH+JyUxLKs+wQ44?=
 =?us-ascii?Q?BSs1sZ1zf9uG7DDKwLC6Gp37peLwhopS4EriCCdjp6Rt++iPMaEc57lJoggG?=
 =?us-ascii?Q?857ZUkWbBKF9a/qT6XByAwOQL7xZ5urvg0+KUfn45/4uXmQk8WqTqgwuFpT0?=
 =?us-ascii?Q?fv09u2/lG5Ki2Pa+MkEXbObJgpDbwKic5fg0OMi+NcAoN0k706TPY3oscQGm?=
 =?us-ascii?Q?NY+bOFFKjNX5lZ8LbgZ21Lw9raHWOqrGo1ZzV5odsK1LEzA30URgm5c4yEFY?=
 =?us-ascii?Q?eXGEBBpjroqmF3C6pFV/ESec5m7PtheGvpjK0Msevikov4Nog1YhDKq4a6wc?=
 =?us-ascii?Q?maaCqsYbjQUxlCgmjiOSn1mSF3Sr7cSmbA/JSbHZFhgKGKFcQbME1BJMc6Ye?=
 =?us-ascii?Q?nYCaY1lZesxofOS9ghzmloOuK331FWRHY41IcLVEoorDYHOHkMasdzVhgeso?=
 =?us-ascii?Q?rr4dFhlerZlraUJPulZJJzid5erhQcfNnqA04JJ22b0J1x5acBtSplRFEFb7?=
 =?us-ascii?Q?t9QHoSJ8abgp6swCeKRhOQiOdOuprfx0KEwDFZunpM1HCN8fCEug08QtcQWc?=
 =?us-ascii?Q?VunX28KSzbeHL3xiL0CUrHHfttvKXjWy8GeM/Kd5nUb0DRiRnKViimH9CRq2?=
 =?us-ascii?Q?aEg3bCQ5l00x5VT1fnrWTc8z4Q+R6PsxpqgXVPR/XtK7AFOWUnZgOZK0Koch?=
 =?us-ascii?Q?CuulB0qebdRZkAobLL29lx4BQmancZqsk34HjMnfEc3U9087vbbFSCUm02Y2?=
 =?us-ascii?Q?Rfrm5HS4gLsAsD8HNiaNX6BRhSrcKasLYwofkG0EJcEmUTt9F/P8AIuKeazR?=
 =?us-ascii?Q?M25uYP1FGz1bhp8kr24CUXfQ59tu6V7ZARwswVJOwShjlNwX+tlwYso86RSo?=
 =?us-ascii?Q?EnL4XjzS4o0pq1yz87nNGMAoeNHBCATGCfRnGVwIl7NVaSCNnhUR4pPC5xic?=
 =?us-ascii?Q?d9fjComIH17yD1VER5gB5kt93eAG3QSIpIIr2po9ZdaMIhYfl7NDfkSm/DV2?=
 =?us-ascii?Q?D5v+ejka3dxdzg/OLjP+4XQGCm4e1c+nx+At4CHdi4DbR9erkdxiT6L3P2kc?=
 =?us-ascii?Q?h/1miETlcd8uKLjafiX8PPExJaFfhqeoW6rIus10i4HcBxC0puFovHXDNTTK?=
 =?us-ascii?Q?f/6k3ghgsNULuBMBVQPE9PLUaXnO5Xb4COZVkOTvtUybMynnzXuid4sqU5kG?=
 =?us-ascii?Q?zTMatRx421lizLGOXbYaiDCGmG753xqG1Et+wLbaGvT62B4eIez0l2YLCftY?=
 =?us-ascii?Q?JLsxatHPNzCDw9/N/VeCSMJZg0SOH3hfSCkg/35amj8SkQ5dgUjKkDuNtkmu?=
 =?us-ascii?Q?wAnJTuhlt2SRhO5I+anx9dyM+0/3Nsw0v3F4tIIb96ADhBuxBTrqr9L0xsPg?=
 =?us-ascii?Q?apAqjYNFHCYdadtGA2psWD9ZKTbEzlyWFTmV0uzJFWRCHq3oFkU2x/DqyTO6?=
 =?us-ascii?Q?RBXZ1vjlEQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f236f506-a5df-403a-ebd1-08de4dcdcecf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 09:19:06.7535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTBAHCxJ8boXTe5WGwETefU0xPa1QESdzbHNj9evtMTUXAyvYPU13QxOpmdX2Fcbde2GvhLGB5W1O8Cn8jyOSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4335
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6391B40007
X-Stat-Signature: pfabz3643pgmj7b5abwnj66get34myd1
X-HE-Tag: 1767777820-963785
X-HE-Meta: U2FsdGVkX19SbSqjPXHJjCFnRdcm+c8gKxtYfLEVSlQpzSlYg6AmufsskzRhelnu0LF1ieavWV0w/Zz0CywM1dPu1INrdSej12uOL2Cr6bbXCAsjXnR790S4sxnsEj7RhJLtf8Dc76aTvpvud0ujN1mvCWqv8dNEceKHRSb02mYMf1T1NtDf/DnlydHFOGWBc4Q+Q5ede7J7ZhGQaWNustaMVcY3k40Bm/BgBiXtKXcpsGCN//9vywpH4Qrcms4I3pFaOQQLCqNgfp8Da1seOprYwOaW+LGTQlSswzJ67IeZWM9EnV+UqUg3+qmlyiSe+TaIehpjQANOP6IWwdeDV4BLOUwbn1iSwmIEbsYnHPi3s9fDyjlk99HMjHAuseikK6BCgjDj9GgSjz+yLeVw2uel1qfWw/Ah5OSXIX6luoar+MwUu9YlDwa0mB+PAM9tRFnan+NMnsrTFNQTJsP/bg9/GVaSU/E/Op6UPzjpVn9BUUK0cQ0YArJ/ggCAbTbsUNyqtFH9VC9PGBdCmZ9UuKDs9UsSArLfEwBL7a1QDkxdpc/hdJmu4bdg/uDT8YyWytACuxy8UvZZGlcWA9Cgo/0YM0vP4RAET5cNR4i2H1qFmovm/j4DZL/ZWbIzetvS3H+be/HZDHHoZzb6mSwCCsHnNg7KT6528lHfZzTNZbS2m8fdgEgvp9ie6YAYB43H1TXwQkfCqD3aQI0e/ypNY5rQQ+h2nnJFKJANlIfLrrkLdq7pC1CfyettPE3gf9R/2CRLhcY5GwJ3sMfigoMsxFj9M1KdmFmlLijPnEZr1CICQTKA+CwPFcBCGWi4jrspqoEXk4k5hS6cYblccEOf5Uk1W8zCf4o7T1vdMg3paXL91w+tFGIdyC6gujrLKgK2+Y8G9onr5uuFmr7OqCbwCDdlYzyITZOyv2m6QdCPOb2FkWJy3mNYVy4GpyXpQS9+fLBfJDJwkbZifs+G+2h
 ZaiH8MvX
 LszNtLQ4uFdu7GiGdCTkHL6rTO/XvZYTTUHJiM4GdVIIlmX/SpTMapbrWE6cGXBGvWGoZyfVk97mAQY0zqNuqD6q42Z43UMhYjKyMUtsTVX4MkwLvc5XQO5cwSOL2PFy9KAuk7+6lfZX7c0obORhJCXgZICG9ihbCjTSQhkwF5JX3I6sVGo+oow9zPOr46xdVQMnwlv1YAu+z/8VI0RO3hSU2V+FhLYFivNrNzDr9LdNhJtq9v0gH/eiV6epqO4YXOKs9PXZdThPzb6W8cPIIJXofy7360KcVlUiKyfjpqP7NRPO/jKFkK5mZSHIzjjFYtiiNNZV5Q69WIXDe3bFBaxKzc3CJbtLq/7Oskare8k9l9gj7EMi022cRYctcMb3ZKM5OraTAs3xEMJ7QJDhrw+Jim5M3gnVVN6x9HiNwm+igx+7nTIDyh3ncOFzYpxK9h7cXhBuP6yxDy/lQ/8/ZdhYgW35+LHWKcH74v7bAZsPHmvUivLOsQSfxuC300W9DqCUxEh7/nFTZ71MAFCdEN6ULbGNxJ34UlJiCwN0rhfVJSs0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
normal pfns and must be handled separately.

Add a new flag PAGE_SNAPSHOT_DEVICE_PRIVATE to track when the pfn of a
page snapshot is a device private page.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
v1:
  - No change
v2:
  - No change
---
 fs/proc/page.c     | 6 ++++--
 include/linux/mm.h | 7 ++++---
 mm/util.c          | 3 +++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index f9b2c2c906cd..adca0e681442 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -191,10 +191,12 @@ u64 stable_page_flags(const struct page *page)
 	         folio_test_large_rmappable(folio)) {
 		/* Note: we indicate any THPs here, not just PMD-sized ones */
 		u |= 1 << KPF_THP;
-	} else if (is_huge_zero_pfn(ps.pfn)) {
+	} else if (!(ps.flags & PAGE_SNAPSHOT_DEVICE_PRIVATE) &&
+		   is_huge_zero_pfn(ps.pfn)) {
 		u |= 1 << KPF_ZERO_PAGE;
 		u |= 1 << KPF_THP;
-	} else if (is_zero_pfn(ps.pfn)) {
+	} else if (!(ps.flags & PAGE_SNAPSHOT_DEVICE_PRIVATE)
+		   && is_zero_pfn(ps.pfn)) {
 		u |= 1 << KPF_ZERO_PAGE;
 	}
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15076261d0c2..e65329e1969f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4623,9 +4623,10 @@ static inline bool page_pool_page_is_pp(const struct page *page)
 }
 #endif
 
-#define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
-#define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
-#define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
+#define PAGE_SNAPSHOT_FAITHFUL		(1 << 0)
+#define PAGE_SNAPSHOT_PG_BUDDY		(1 << 1)
+#define PAGE_SNAPSHOT_PG_IDLE		(1 << 2)
+#define PAGE_SNAPSHOT_DEVICE_PRIVATE	(1 << 3)
 
 struct page_snapshot {
 	struct folio folio_snapshot;
diff --git a/mm/util.c b/mm/util.c
index 97cae40c0209..65e3f1a97d76 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1218,6 +1218,9 @@ static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
 
 	if (folio_test_idle(folio))
 		ps->flags |= PAGE_SNAPSHOT_PG_IDLE;
+
+	if (is_device_private_page(page))
+		ps->flags |= PAGE_SNAPSHOT_DEVICE_PRIVATE;
 }
 
 /**
-- 
2.34.1


