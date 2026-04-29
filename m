Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAE45FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6D126B0092; Wed, 29 Apr 2026 11:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1E306B00A1; Wed, 29 Apr 2026 11:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0CF16B00A2; Wed, 29 Apr 2026 11:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C1CC36B0092
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:36:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5BB82A02D8
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:36:42 +0000 (UTC)
X-FDA: 84711995844.29.753FEDC
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013007.outbound.protection.outlook.com [40.93.201.7])
	by imf07.hostedemail.com (Postfix) with ESMTP id 418EC40015
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:36:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ic9Lta+/";
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777476999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QV0l8LtvqT0oWNl22v31BqjysztALBSL8ooDwTqwEnM=;
	b=mbRvhvmDGgiKz9shjQc94u5sqlhQGjZ7vpjiYURGZemoZpSH8Yt3n1Tc7+SoL5qF5n8JSI
	cH8ASTMOyuEGn84IIicGM5njMkyHbszfZh2n6V3sF/Mv0FDHSwq5ZVngSXnTKlrEphKB2s
	zlqbHbhGtCCZ1AlXDWhLN5VIGkNSHxk=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ic9Lta+/";
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777476999; a=rsa-sha256;
	cv=pass;
	b=AsV2H12qH5PFILjCKeVYwbaI86GYpzTbAfZQmKpzP9SSLnIZp6VWQHY4y3HZAtHmb7pZB7
	fZGnEZX9A26PT9P5r3Pj5uWhMMmf/Q1UT+F/87d6pVdvafwG+3RmFys6DXGIm/ebXccjRB
	XmaEr5LGmp4wZU5JpTfK1+IUbeZDTfs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UAso1Pv7MfcdzJShV0bGy+7P3KYzhW1xYAZ82sSL3RnAEN+1tR6NO7qZRFMJWzK2f0BnTAMIKMkecDGuWOFDJ3IVD9D904UrGG9pUCfFT3z41hMTk7s7l1U3cQCt6FCj73rGpu9rDd7X3XXsVHbbbSSl+Si0rPx3Sa5zWP09cOq7lP5ny9FlhOc9ZURVtH4YfsFr/tNsLzMJvWTLnv8Y3/DR1nNoz1lyD6citIW2t3rjKetIC0lGPhyFdUv/XK1Z7ASpTHTiQ0nWKHu1WyWq9O7/nRVfxDpAblnxxakEfvZyp8mIy4lvb4njPGGQsLyLvtnZUctaMShHvpmJb/ViSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QV0l8LtvqT0oWNl22v31BqjysztALBSL8ooDwTqwEnM=;
 b=dasPPLg63MgDkB6pMrriyCJsxJknYRywZIiC7yYzFwV0ZAWp2RzQearyFvIFI6S9aui+yO7RykxO9E0Rb/Rcw8rD2RaQzMW4vdBM/JZRB7rN8v60zqci5iNOG/d5+VCZJb5pJSXJREMWFWbZnzqLlsUcceo2S/jr5BMcFWrcgsnuc6Eb4CmHLshW0O3QLZRNKa5bT6ySc2ncWYck7IFN2+JU4sOhYTIMVB2cr5iNAGdG/msysUcsVDpns+ltF+jFV3JvjcfvBRJ72FmH0ccnNhsxAA4rhnpn7x1P3YP4h3C8Q7H3A/IcABadiRix5/0VkChmKgCpILtlwkzUcKiUxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QV0l8LtvqT0oWNl22v31BqjysztALBSL8ooDwTqwEnM=;
 b=ic9Lta+/ixpqUJbkQMiEqur7gbrBIDWCF9GUibeYy2jQgwygoi9VPtsOLF4c5sHtYjr9WVncx12SWPdTx4+eb1jzqdsLD7vc15/vWif1n8eniePIAdatIkq9yIgjy6x+m6PlTHU0o/a8t8Yc6/AL60c7An0my6fXEas63Ltcrx/S3dTYyoMucuPwNydnVAPfslbBK7tWt7ae3D734XHPgtyR9Od2NMalHtFpg/Gy+F6kch4FVzZV96D1B8uh6L8gAIKh2NzpJSKBFiJB5T/VdKWWxFk4R9KwpAgzgW/DsAT5K9B0p6M/XTLfr65Ea+pn7/4pLI6Fb8wCukAfXuZdBQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8881.namprd12.prod.outlook.com (2603:10b6:a03:546::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Wed, 29 Apr
 2026 15:36:25 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:36:22 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v5 05/14] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Wed, 29 Apr 2026 11:35:28 -0400
Message-ID: <20260429153538.727855-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0046.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8881:EE_
X-MS-Office365-Filtering-Correlation-Id: 98f97a61-56af-493b-1d4a-08dea6051122
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oCCWBzJf4fypC6C1y6jd2DT2W/4b5SR0mEoKl60rZu5y1rNnSVXo4wwthIbWrFzpG3VDrA2xjKE9m+8xuo1UhB/2Ksi4MLIqn0ai2GusWywjki80/iBajnL7LhSZdDOfl2iVXJo8FCvLiG3x8voXiDHpVUdCj49XdDGlZ78fAYNhsjmo1DOHrqb4BcMF1BZS297pVx9dKHnaBndOdgEK10ad++LiRJDlfn4+wEL8efPozG0IK79qqhgiDe74XiOzwo20sm4PEu++IcDhndNHraPt0RaSjgkWXgPRcx88I9VTom2+0p+oQmVslBdF2B8ihkLBD/BsMmaygTj5NaYXQgt1w3qqlEtdGGNLhrNl4CXwg7aJFNjSOZClhah2PAPgQCrWflbA91XwoekiK85JpmDT7nOqcsSGWaBIpMGr9/fP/3nMwYNRvwX4BRFekj+XpnVZbFi4qfRPmTSFMDEpHI21RvK1RVb1WvgA47TALm1yCwXv1jw3L6XUMJqAILnxGI2HNtUIbIYppRMUHjdPUZ0bZmnmR6znMODAU0SI+aZRE+DgtIGOsDc68hCH02QkJ31LatIP/IuzzpIN751aZUL0CXn7So/rpUJ8UP9rlYXq5mTHnHEd2J2WhMfGj34hWVqFtWrRAro33Q35UDStvlHgSwXENPIJ6allNjN7yXREjwyUTzChVHHWnuvqesAQGYAKP8VvRynr7JJzsukVAB0kTO4yiIhWT6R8ipIgWic=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KroQuYr6XMj1lBYZUjuLskA/QsfWTv+DkYH/HoY9TFjUHbJo/X79ZTF3xciH?=
 =?us-ascii?Q?ofzXCwOR/gCimvKyiDLSww5kiZd47l0mUCf76sFIRpDJTmIP+kBYbms3QJ2b?=
 =?us-ascii?Q?glV8vsCFZzuf/B3cN6U4NEjo3wIyomrwODu/r5RWyPb7QOxd4YN974H8t8j7?=
 =?us-ascii?Q?0H9lDZE9hmoAcd9pd5AilIgUYFG96AHIK33UnD1eZyo/zDpK+nnOQpP7Ox6J?=
 =?us-ascii?Q?naYDUeWraHJ02O3PAFNnnW+O1lU216qt1+JiO7Z1Nc5Udvaw8k19oxV+WLp7?=
 =?us-ascii?Q?r5da7Wiz6EMOEjgXfRkQNpoappP/kD3AYD3pJY4yT5Ps6Gzc9JLt4e5Ks8SU?=
 =?us-ascii?Q?dvJbZlAGbQDzrhAJr6r9m/Okci6nPoKE2trYT5kgs5MdphIq6+FDCnh2kFLO?=
 =?us-ascii?Q?pRFwsGTCMhdon2CK1cCAiNn94mi7fVoRkI+VyOMHxQVu1OigNwzmbVzbhICN?=
 =?us-ascii?Q?IB/LirztWqXgo1qmSA0ESf5XRSJjtuWiCgfWPjw2S9/Ok/2aQhTtojpHmfcv?=
 =?us-ascii?Q?Mbu/8kRxu7V35JHNyB6gdeczAULSet/D2WsPhW94P8TVVqD51S/SLbyI9MTk?=
 =?us-ascii?Q?3ogGH3Q3ywihcyVUWYvI7arNwKyrFR6bfkSx04/aVx4WyoZfvmyPKWaJbJeU?=
 =?us-ascii?Q?RDD6jR49KsXz5fFGtPpz7qqW48oEvsxAH86QV0ywG/EJD9nHQ0B0uZsm3V/x?=
 =?us-ascii?Q?ObQGPFCKBVoTmSU3Lp7OI0AdPTnaeJNbY8M/H9OyNDRy44uJF8gsPgV6tmEj?=
 =?us-ascii?Q?QT4d9UUcd0yJPA8gXlUExwbIanp+/9cMqqaE4pyflLk/iTya0z5f7O0OTgUH?=
 =?us-ascii?Q?5DsDOst/MVbhf0mXg0XmISD3XvffuozMigw54TCnW+x/szzYollje8jwFw3Z?=
 =?us-ascii?Q?GZ/AJ06ee2uGjr0Y7XWyOydfv9TipUaHeBUAt8snHmOA4jeWWVsZ3kk13dn4?=
 =?us-ascii?Q?iiRbt7w/iJsTB9Qrjpuqww9yP5QL57IMtt+vtGVMWchJL4dULY9fbGQ+nWIe?=
 =?us-ascii?Q?YAYO/wCHFsCt+efHEGw/D6HwMkEokO2sphKkyuPPDx4Drib/hvVcpVsWIyyL?=
 =?us-ascii?Q?5kUKbACJjR6Jd6wgOJIQbTig5QYaps4TZvNxoHlfuy0HJuii5oECMrpMXKaj?=
 =?us-ascii?Q?x1i0EStWKKji5JglGWXmkTMPfp3+jljJ+x6WwRH01uhDxpWx2mw0Nxwwsb6Y?=
 =?us-ascii?Q?393NF4jxkqS2oXLHOlaDSRngCNCa+00Tfe4f1H+qjXK2EhikbpB6GxoZyVVW?=
 =?us-ascii?Q?6olDfH31kkEoVVChKDuAt1V97j7org+/ZLr9wNYgM1DPlIJqd6mOJPXNeDbt?=
 =?us-ascii?Q?suRtBsy+neZCLlEjuW/Y6dCsL+rFoLAKuo7Pldd89lZEoKAX1nYvQrCKLYr9?=
 =?us-ascii?Q?LdLRqHFHVK/FD0zk2USMyN9pmKL2QYFh3OE7NC3cK1Rw2oL7WByoTcptRXdw?=
 =?us-ascii?Q?cKrlPZ+5pSeFu/OvsSo6GoJEmg5UGtMMQtmKoSq/G9GZjToJHNdURehBw4VP?=
 =?us-ascii?Q?RNrhzZLaz9w6Ly5VLRGbjmASHEUlxGXPYOZqzTQFiD9jCLERDMKaUTkU3J6G?=
 =?us-ascii?Q?J19741kP0VaqHAFqJ6qltAzGN0V9Syl35cJrvnO5akJgcL17Jtb0z3dGsOmI?=
 =?us-ascii?Q?VnlNLsuakEr3vaeyJRMcFjSbgzoy+TM5EkOPZLtrGWBJRJ1MWXfFNYD3bUOY?=
 =?us-ascii?Q?Dr3Ljh88anYocnXZpvNSFk7s9vvPz9N5rdwVxQAjKq4nqIkq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98f97a61-56af-493b-1d4a-08dea6051122
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:36:22.7284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GmURKb2y7oUTW9YTvu1eTtKKhlOs8Ki2o+G0Vf9L/90iYmy2PZGFjMFruWLIQJpH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8881
X-Rspam-User: 
X-Rspamd-Queue-Id: 418EC40015
X-Rspamd-Server: rspam06
X-Stat-Signature: 3nqog5wykpugex64s53unofurqwcd1m8
X-HE-Tag: 1777476998-778335
X-HE-Meta: U2FsdGVkX19KO/qXSgVwmjJlJkWW55jNHdSqdzvAPMiXOTSpmwNmkjDPNyBYNhjy1yUPI26rsndfyK952fvd+9GVJZ/ALSDFQIKCAfNiV4a5etueJSIj4+F4cUQF5ltfrqLka7zoE0A26YpjcUJHCgdv/+I6s0WRE8jT3HuovxU5ZKku0LN4abxICutAkkF6t2AGlc6dm0nNra5hhKtDJU7Y0PCkuxDbonSESoD3ZHt2e8Fr4IwDPiYm8Lu6ZL77IWOM8myhR5Vct4Q+QWEGHRD42l8C8iguhkjWcLM+2outknYITP3I9wACGd55HkGfaBPhFNbKrrUlzEVDaD4SGUbefUWdq5r7UkigV/KPlzzPtf5E1p6kPR2yOVvoA2BPytNhu18/NZJ8tq8b2B8wugvb4HmToxgAYsFfqXjjK18YeNkEJRjJfX7sXmzpULzPCxfyF9lwInsouCoZYpO9yAAQ1jC1Cit/p3nrdJidWqsYNcSXBksvWMsZb7uSScVzJxpBOgGQ7Rjyp7RdXtZS+5dXPbFx+gQk6k85yX0A+YiKfGntIE98r6R/SbBBJ4bb0rbUIVfAYY/xPUZWwN0NjXaggNbvr9qshOxTrMVPVerS/e1ocMGxdYJT2FkjXpgumRpx9WAl0Nh97wcU5a+ktRnS7AyJbS9kTS5vrvrf0iWNIoPUc8kTeIeyq5gdpmS1o12Q9/a0H3ujiFj51TbFeNv8S+kVyFKoyy2fBJd7V9n5+FEH2vWC53pfCD12A+Zx54vyLA8v/h/ndOvABeBOTwcYwqpbvOcx02ONPfhxzX2GFg/js8V+8vwvqkhQmOahnJoEUIC0t7bfALiNCIoBDbdSUl+2cZV44a88QvTY07gWOwgfCokXY0FfXhE8XCbZRMEJvPVdJx/TDumv/y6ewu+40H2U1vCY+a7sEu5DlhlHoGYz3w9S5aSa3tL3xnSJfqDjOfAzQCTs6O2zXqF
 DVGf7wav
 bQg/w+QJG7cINlQ+dqy+7Pwl8TV4LVEwsFGmAB38BVdJWEu9kUFqRH4WsQ/cAwxSHo9o+SFAoXEcbLob25BgTn9lx9RB8U++KdDPXU2r9BoFill1NaaHWmU82XtrK46QMdWlbIGOB2lQPqL/Ntr/ObZOrVzxbTpw27610elA9zsqWWmd7TSXrQWCrqH3KUCr8CtUY9/D3ZVkf4vJXuHRZa4itbm0JoNd95NTRTxLUn1C9d2H2bg1Ja0Xkkw4U5xr5x/ljJZTYuY7jG/w9sMqJeRSuW2s3ciZ846t8Q/v+434gNsczk5Q8tZ5VptMk081EwMJnjxE8EOIPPvCaqc3L+T1Cg40Sv3qzZJkAP7+Ga+WgUNMSxoEApDr9Q6HSlVM3IgzXCAH9xgYPDjKih30dYahbKkndAALQEYRW8GkzhsraYapafjucbnETyUCUgNhBrswbZU2+Dp1LnqZgU29iyAgwE69EZlIwxZnl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
support even without READ_ONLY_THP_FOR_FS enabled. Remove the Kconfig first
so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits remove
mapping->nr_thps, which its safe guard mechanism relies on.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/Kconfig | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index e221fa1dc54d0..27dc5b0139ba6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -936,17 +936,6 @@ config THP_SWAP
 
 	  For selection by architectures with reasonable THP sizes.
 
-config READ_ONLY_THP_FOR_FS
-	bool "Read-only THP for filesystems (EXPERIMENTAL)"
-	depends on TRANSPARENT_HUGEPAGE
-
-	help
-	  Allow khugepaged to put read-only file-backed pages in THP.
-
-	  This is marked experimental because it is a new feature. Write
-	  support of file THPs will be developed in the next few release
-	  cycles.
-
 config NO_PAGE_MAPCOUNT
 	bool "No per-page mapcount (EXPERIMENTAL)"
 	help
-- 
2.53.0


