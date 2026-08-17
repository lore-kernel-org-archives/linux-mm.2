Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C73ABC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 23:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74F356B011A; Mon, 17 Aug 2026 19:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7008A6B011E; Mon, 17 Aug 2026 19:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CBE06B011F; Mon, 17 Aug 2026 19:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31E476B011A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:35:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 372EE1A098E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:35:05 +0000 (UTC)
X-FDA: 85112369370.15.50DABC4
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012009.outbound.protection.outlook.com [52.101.48.9])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5D2C3100009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:35:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bPQ1Codh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.9 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787009702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZEs8zeiLAUCxdjzlh+YZVtVQCe/BmDpBvPhAo/av1o=;
	b=x3FHwVxuN1wQPn8SzHwMDas+evau7PdtmvTbFKDw589GYhxSZVUq/U3W39pSX5uXo2oTbE
	tIcpR+MJ5dTWWYd+LgwAjIVjdD2TSAeJoMVlqmpnxQJhcBdCRcHdrbnbGlJgqm1ysDNEnj
	lTu6GBjZdbOG60Y4oPQFtNoSZgRFHDU=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bPQ1Codh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.9 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787009702;
	b=FpgunDD16OSztYkaGGtF+LVUwY3lE7v7Llw5fEbllvvYdXEMLv1BA8CojDFUdU7LIMiiHr
	cIr5Dfuofb4MIWzZ2WHo//esZkd02FTwc60vMYMmUBwGOqkKwD8n+SROzzuINQbP4eQTl/
	yG5jbF9EcTA8KV9bCI/OnqHB5elZM2Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lpwwkE59ioncvhRKzVPgDNBRsIZjQ/IJXIaGbPD/xJY0V5OqiDirHoohs9GtJa2uACKWQomO+hAmzRYaxufUg22WjyOigOMuftpbW0/qOqA0BvpTOeiyVTT+J3E1w1ELwxLlg4ikCsgImaP99mPRcfCU1gXu4SNNCMGqodDLD4ZE9jFCyGEx5egulYfME6RhBsPhy9MWpyJviwVyjbsP5dcrRME6Dbhqwb4eZLcdx3Ezoh4Vr4fqLzhfnApEFMkH8MT2JSKmJtRugd4Hno6gn1tueNI3X89uVkMwf5rQW12w7IdOnE5lE00J0XT/kiOR4xB3BKyMZkbvoQonFmfczw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JZEs8zeiLAUCxdjzlh+YZVtVQCe/BmDpBvPhAo/av1o=;
 b=xGMBlfDSJZa8ElFRdtYP3HGPXLK6Y0tZVqrnMvuhzNYpNkK4CyRxL4M8hp9sIwywZWaYbNv+hkcP/eMIlxGoPMVjg3B4Wrd5M1OP2I4AalMjD/aO3/6lvL51lPiKqpS3qgbPHPoz2bqYaJp4KUEM0YLZ0EXPNfgr/cqtyOe5sRx82ch9aTD5VSej2b8ATxMK0p16gJWGO78af+YLJlouNeic3LDQ4OeHcVuTVne1eO8J0WuXIXhtOkadc+WJDX4tzU4mbgkFu/nqX9VrxL4UWjWAOlBvehNDB6oTNHw35MceBs4eMbAUpPotxkaQtxRQ9/iFXsVBtq0a6MfMW4xZ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZEs8zeiLAUCxdjzlh+YZVtVQCe/BmDpBvPhAo/av1o=;
 b=bPQ1CodhNkIhdYdYQ0eVucw/Fq370ieR3LKon4mLNuJU5uzQdl7swPE5LBjicaCwBdcJYKA3Mk0Hz4tvGFHq/Qh/aEdR4hFTYWEfu/nhmWAoi5TCQCCZTvYYC7zxl+p/jzZbiuT7bUcAHgTme8Roilrl5CFlIHyn7ngfVqpGdWGRaTQPu1AH1qRXTuV0TKX19IB8nW2NPWW/NH/oDWPdt+qa1fv1345Ow4BxUzQTZF93O3O+BqnGzf0DPVb/ICj7hqc0+dXcjhSmaluSl4NqOpVrWzW+WykcDAe9F9GxjuXVAcDdBb5wgL6sbqE2vCm247/Wz1Rt8obqsufHh85OhA==
Received: from CH1PR12MB9670.namprd12.prod.outlook.com (2603:10b6:610:2af::6)
 by BL3PR12MB9051.namprd12.prod.outlook.com (2603:10b6:208:3ba::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 23:34:54 +0000
Received: from CH1PR12MB9670.namprd12.prod.outlook.com
 ([fe80::416:ea1f:d17b:2811]) by CH1PR12MB9670.namprd12.prod.outlook.com
 ([fe80::416:ea1f:d17b:2811%6]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 23:34:54 +0000
Date: Tue, 18 Aug 2026 09:34:49 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, 
	vbabka@kernel.org, jannh@google.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/mempolicy: skip zone device folios when
 queueing folios
Message-ID: <aoONaAtLLnYAZnmG@parvat>
References: <20260817220810.1175596-1-gourry@gourry.net>
 <20260817220810.1175596-4-gourry@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817220810.1175596-4-gourry@gourry.net>
X-ClientProxiedBy: ME0P282CA0084.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:213::16) To CH1PR12MB9670.namprd12.prod.outlook.com
 (2603:10b6:610:2af::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9670:EE_|BL3PR12MB9051:EE_
X-MS-Office365-Filtering-Correlation-Id: a6854a17-6bc9-4325-35a0-08defcb82428
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|18002099003|22082099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	JKgC6MXUHRb8jTAhkYrtyWW+9D0cu3AtDn3xPY6UqgHmOnglRousZAahBXpfSkAUflMT1OT1xYVjVJiwga4mshNese72rM3rGHtxUKpxEHrMfhyAe/Q4P1iE+y4po6qFCcYuc/kPegRggk3aC2GoGkFnJERqOHAHjLkZHtyNhC4WGbB5dkhAH9wbjXgJfNwNI2cWnVB0u2A3eQvgsq8yMf2aMeuVO82mwFbpEP+O4CAxBFNQruWBs7CZMbwLit+HrwBr3MY9zmghQiYSdAv9eB/leQ9+lTDzqfSPEIlAEC4R/RogmHWMMw+VFdvcnR5Y+06CG6KCNbAjTFkvRV2wTtg6/KMZGTRP1YdvfUJynRlyVVEkZnMoYYUwwYGwhUMds07q0HZv0j2EWGtkYh+loGAaKid6fr+/R4RVpI908ViQmPa00JY11hSDGTtbvG0YBlpeitidt6wXwhIUmIyWQfH/mmDqVqXn7+FslaWnBlauHQRavLqP/EBLL2XiC/u0sdsNIPr4DUnkYGObUI8OKlXECIZEvp/QUjWBF9JhpXsIQmrQDOfCxuLy8nxfEB/VnuteZoZNbRNU1vKFomRkT3YvEkBuuAtXJ5YGYEOMOWydsJP4DInUrqMh2s8gqni0Hnrz23xZHsI0Nqk7OgG9Zy+vZo5B0VJFWK7NAfOMXSY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9670.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rUNrCD+HCSRFabg6mbTCg2C9AXpr9lCwr3OPyDjY1VbRdhpoUk/qUplpktWA?=
 =?us-ascii?Q?Zp8kPRtMlg8ONQT+DqHBRH6hmy8v+6jWCI0Re/Bgtbhn6naIiVEb0EgBqJzk?=
 =?us-ascii?Q?eUZ77x7F1lpRw2fi+Kj6EoEJpf9tu1LUeHhcYmreqp5EcXjj8GFpfCgdI3tr?=
 =?us-ascii?Q?hrI8pObyehA7wOYHw6gBst2oomFkhJwHu/JEJwzT2wPPf371kEBzKbz50Hab?=
 =?us-ascii?Q?SFTFMPvSTHZIRPzeS3vqncTD7VOsGiTp+7mhpmdNOeMIlsQGGhPB0H1tZTjm?=
 =?us-ascii?Q?SkMSs5e1EIdlqqeOQhRVLaq9mEc9iaxs0gITciqHoOItNjyRhbIfgQ2NrGnl?=
 =?us-ascii?Q?WVNBTDUEnPaKOZqxRVO7UjuYlVwpdsW/da7w8eKIyNpYApBe6HoAtgR6tBmJ?=
 =?us-ascii?Q?KYK8MGNv25eKjdh7X72Ztuu/m3jfGx2PaVHCfb9DrruRyiiUkIkOrysMvzIW?=
 =?us-ascii?Q?fzJL579zS9d1jT9QNeFFpDYg3nAz80IxQXL3zVgAHN1vYGHn+U44hUCMH0qK?=
 =?us-ascii?Q?AyEq4Hn2DQrIva6aUpMdEj9kwyQJ1kfAHeU0AdTOs/wFH+iw64Io8rx7HrGV?=
 =?us-ascii?Q?kfPm3V7YP0gbvHGe6mTMrea1BVEmeQmNdTVikV2/0+ec9sg7/vE6NHC9FF3W?=
 =?us-ascii?Q?9EGXv03bMVAnZvEbraLG/IBu8Ev2wab4j4RFvblvjwSXo3Hfua9OvYxmHYMX?=
 =?us-ascii?Q?tlxJkklAmTCyC4CpmKi9MUdMQGqVzIzPVSMjUVO1/OC8b6LRllUekogp+p98?=
 =?us-ascii?Q?ekuBTV+8IQBAymNCgAHuUyCbsQZ7l6j8SxxAMb/q1g40jPlCuMdP0OolNm+1?=
 =?us-ascii?Q?pkZmY6BxduTuSQWrqufop1euw/bK8TTBQcapSQjfQJ8b5G4zA5kpNCXrAj52?=
 =?us-ascii?Q?E6QEkovSVIWDXlDmKJBjAD9GQGE/0gSoR4gz1DiO+LqkFLjvYvO5PAUZjeSD?=
 =?us-ascii?Q?+dhEfAuof5qpf2qTV4kZNzjwXOEGmf3Ley/tlKx7RTU70kHhomhqbaQoFaBb?=
 =?us-ascii?Q?dHNhQHsLOPRJWZVQ9KT6lIXat3RBBntDCL+xCnEdMmzxsifbccagwQddVRAO?=
 =?us-ascii?Q?3jE+Ekfv1c0jXrSGQglnet+oSUVclk6CVYWgtuT0F6aaiHW6QNETb66RcC8f?=
 =?us-ascii?Q?MPjhQrfh/E2VChyBqjo1a/4njuD7Z13uEHR9/kuyQZhwOnHh0cUiQZ8Mg3mv?=
 =?us-ascii?Q?zauuoKGPacHyORt1MxymX1wU7bCOoikg/dDQoYcDjFc+OEOVHWgNFZAgkO1p?=
 =?us-ascii?Q?1FAiXU/OvZGXwqXykiq0rr5sNGGN9ZNZZCHymOT1iGk/bYreEGqXB2YaeiKD?=
 =?us-ascii?Q?v1SvCQoWV8oUsgupzmUo75grlLi/ZzJAabnRUp4wwCzBQqn1aDxkaqDQeHkK?=
 =?us-ascii?Q?l0OSEyA9TC5owfrgN/aZXK1R1dk11LiL/YIsY8l4av0sDMRcgpZ+Fr/tucTu?=
 =?us-ascii?Q?UF7O7f1s1zjINN6ROOM60gBs4GFKKHi7XhGAvSGq+Y1oKuG8CKOG2ZGOpWYb?=
 =?us-ascii?Q?F6oNsgkGEUcOrje5ZuFMT23yupCKFRiG4RPUlwn039jfMp28paN6dDm7ORwH?=
 =?us-ascii?Q?7IfEzpm/ZCstdVt7JTxmpB2wVUuXL/WSqVKjV8PQOc8MHLcvUMu5El5iTQP3?=
 =?us-ascii?Q?lvDQm5HhdIjb/cDud1LjDbVJonlry5Hq/4qy0uvfy6C/oEPmvkx2/O0RVv+k?=
 =?us-ascii?Q?/p1HKVHhiR6W1iQlD7QUS9h/ewhoV8a4WMzcHNgernWSO/aU4orJ8Fjk9Mt7?=
 =?us-ascii?Q?BKadH35Q/Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6854a17-6bc9-4325-35a0-08defcb82428
X-MS-Exchange-CrossTenant-AuthSource: CH1PR12MB9670.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 23:34:54.8182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K94oTOzzXzF5Dd0GQQD7YxaLVJVxmkukWiZvExN1tKC91X6Xb/+DlPg2KOEAE2h7y0vRdXd+bZlg2QX1vzkzHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB9051
X-Stat-Signature: ss4uwta14o78owzqy8qnoeuttpzp9r5i
X-Rspamd-Queue-Id: 5D2C3100009
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787009702-314687
X-HE-Meta: U2FsdGVkX1+gkRrwenAEoY+tWkmWFh6jzD8foinWtAcnieB0mVvVXG7B6tSUUTgs3vsbBJc2pmiHhvRl7Ry8znz/X7CZOnpQh/o8l5avYlS1DTFCFuGE+k/BhYL518QTzrZ3P47nagOn0Kj+G9zjuGedI2JYA3liYZx+GT+e6i/0gdF3aybJ0ywTXrqqZbuULnsf0jHMb13o+2a9w5txditQUPsRd9yTI7Rb6QAd9iQ6COtECeeWPWhGJDM+llsrU6iimYlIZDer/i/Sd7m7BtIZLs8Fv7Lk5lpdSRkuiDHjfPEH+D0CO5geiGkoKmBG+NF1fDqdZ/UgcWOtJF1gVksoOVUnprtTHMzsLm0IXYdyT4LMSgg7SLqMZYCwWfxrClQWYFrERbkl1tCSTBHnQgGTSVAkMC965yMtyeI/z80In3YkX5RqzgkCYplCeRg7yC99+kFMPDbVXxmIHfgwROzYdnAmx1v/ppHJMQ4PGTnHazivzz1tlI3f+Fj4ITPY6echdrLmnBl//dsJgisYQdtuFMQYziLXeHh+wLrUEKlrL6EFKhdUG1tRp3pwkwDrRaz6FBPQf0rrkDb8ImhG3jH7cobfTSpcs1Te8n9wNZt7S1sgQb+yuG1GI+HDuzaNrSCA8btKKmGFkSMHOVaEUiXCw8B7yrcy/FsBRWQVI8J/HybiT5FJPVAMH8dtvNB8ZgbL6sp/Gmq+fsjfQ2aJYhV3U+zFSiwVV8dbGITP3csZzsMjDebNrE0a+bCeiuIR39fSlku7Mp4DFxJlRZgCabmekA5pY2RFKWqiQQ/fjlkcMxAtd3fMbU+uouwaTH5KzXGEDC+4Ge5pEWuZ/cFBjzjoWLxAM/knShc7arVdYJZVZYTygZOgR0v+qSQNYRKGUDUXm1da9XpaDyauEk3nubZmFYOd7uXmj8Q3Cu9zQZXuTEbf9LBmq2oodtj3w9G3r5lP3gPu7uvL/y12F83
 SkoTc74C
 bH4BaeTBH55HKJsp5f99JJywdfOUxacTWjkpwgkUii4ARrjX8Q7NTzKdxwXTLS3Gg9xfo92bJ0HYsW+af8bwWbgfRN5AJOUNn0QFbEu3HtxM1fhdAUPgqS93GulLKrsnJsGERSsFOUyPHXsAT+MXBY2PEcIZ/GPIW6sSyPfqeaF4QjHH+6GD9owBiab1ELBrCkaqmdEiuYofAcJsuh+q5qAw5HBJyssGWrMemkr05CoR1Ur7sHNWW0O9qmlid3tIIAgu+rWFduax8QqWGkZoWIEIvlDwqD/iJs6exInVH/zm16M9QP9GrgSBnEjhJY4dBtS1LkvFpOjswE6tX4KbDauV5B5++kmdJFcx2KAr8jZY+hl6AzD1so6eZAr9PtzJvIpfzcSOMkmCeKBhT/13K2reMWxrgwvRSrP9Y91BttpZF/MfLr5rhEKtnIvrsEYp+BD8AN+mXelhKfMbdc4y+2VJ7qHIrBnWLiQLLYJohk9ML2uBZv0DR6Zt/jvbYnViLnF+6D7IIlq+ltAvUzv+axYgrm2zhK3iXp++JvrLGtqdc3PC1cZGiVM+PIU97/4agLN/EgMWum74mcRw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 06:08:10PM -0400, Gregory Price wrote:
> queue_folios_pte_range() already pairs vm_normal_folio() with an
> explicit folio_is_zone_device() check before adding folios to the
> migration pagelist.
> 
> vm_normal_folio() alone does not reject zone device memory (a present
> device-coherent page in a normal VMA is returned as "normal").
> 
> Mirror the explicit check in queue_folios_pmd() as well.
> 
> queue_folios_pmd() uses pmd_folio() directly and can encounter a present
> zone device PMD - e.g. a device-coherent THP.
> 
> This is not filtered by existing checks:
>   !pmd_present()   - only rejects non-present device-private and
>                      migration entries
> 
>   vma_migratable() - excludes DAX and VM_PFNMAP.
> 
> The early return also means such a folio is no longer counted in
> qp->nr_failed under MPOL_MF_STRICT.  This is the same pattern used
> by queue_folios_pte_range() (skipping zone device without failing).
> 
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/mempolicy.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 3498a5651d50f..3418b5664dcf8 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -662,6 +662,8 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
>  		return;
>  	}
>  	folio = pmd_folio(pmdval);
> +	if (folio_is_zone_device(folio))
> +		return;
>  	if (is_huge_zero_folio(folio)) {
>  		walk->action = ACTION_CONTINUE;
>  		return;
> -- 
> 2.53.0-Meta
>


A similar patch was sent out earlier, but that was only for zone device
private THP, we don't support migration of device coherent THP today (we
should add support). The patch itself makes sense

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

