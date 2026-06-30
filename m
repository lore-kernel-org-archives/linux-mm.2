Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B4A4C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BA196B00AF; Tue, 30 Jun 2026 03:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7913A6B00B0; Tue, 30 Jun 2026 03:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680D66B00B2; Tue, 30 Jun 2026 03:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3574A6B00AF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:29:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5D8EC1CED
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:29:27 +0000 (UTC)
X-FDA: 84935753574.25.82CEEF8
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010069.outbound.protection.outlook.com [52.101.46.69])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6891018000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:29:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=IZkIKJcn;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.69 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782804564;
	b=LX6l+62AUOrc1is/iulvELP1MsgqswsAPZHo/McbKJYrbUCjv2+8Lhz4vwpULl3oEQJgJz
	d7az3nXcYU1caXa/Nm5shwUr+UTmIPK0+3WC9oQiPkZPoVcqb2EIBNIuYMx7HAbSXyhTRz
	mfLFMur9iUfLjdvEJMWXNRhNkiihkSI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qOzxY0YymOrNOLIyUo3fX7VnGjAr9WEUGQwF1rsBSaA=;
	b=TvvuBSc6ds7Q6t07RWVSoekMI5E3mw6HGhoR5/9MidtNoBpMQMAuzHJ4XmX/pIDmNsaM5R
	0MYbluCXc27h6RaWtmxzhf0FRje2JMXQfy1VUz+tcPDs3AWIKFPKqCPWREFpWW1qs86ro5
	PWCKQi5AeDJb1z0lQsOB1YqxzicW13g=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=IZkIKJcn;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.69 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P5+LHHuRJF6k6uiJU6aP8kLmd1hPVE/YencHQfgPAnh0w5B4NaFSrT3/vHs/6dmatjmdIXhXh9wYmYW7i4KShmRpYiQaUbJSSbj4WSjh1eLVYUubzcjR/+9TsXEYShZvg9S20B97qV2dBn1bYnzuXjUYuQEyCssRLA3l607zfvf1ASXI1dnS9i5q2xNxEBv0PXD9YoIfbMN7bvhFeAUwvs22acAFxF+KlApIgRoYdEsB6F5KW7qQb5AH6yuJ/NQoreoof0/Kif6Z0FbDLD88AU8HtgJhFKasGq4ZGGR7ORwr+LoIYzS3dvT0NW6BBPsz4vKD5M5dfR+wEVRdSuVFXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qOzxY0YymOrNOLIyUo3fX7VnGjAr9WEUGQwF1rsBSaA=;
 b=W10Ke4/3t98RNqBxBwQmxoaMG6aJf8psI+Sl0tXOhWxFQuVMuBssFXoWMbgCQNMxiWT5EbMN/DsFOoTyNV+PHX1+diLJ9gEZaicBsIpars32bNpp6s6gx6MCKtfgU+vdr0IlaY9dNbhowcdG9zdiWE6H73eHJXsh9i6HOv/W0YskMB2XHXQFdFiGpa/a3k0XgNG7JvKbYajgS+/1p84m0LOPN8N9xuiImzxRBoJdndfALjxElAsE5YNDeBYg6IKEFjQAt6A0ULt9fHr5gfjMtvE5sR+OL+c1Ae3SIhlrshrIYsHsFhepB5V1s7hF/qElilsHFCtF7eBKpCsO4ewu8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qOzxY0YymOrNOLIyUo3fX7VnGjAr9WEUGQwF1rsBSaA=;
 b=IZkIKJcn3ECLzH29fF/4mMnZ+haNdLYr2VazCEKiaSYY51sZ1gGi1ba8IVrBUFbwmnve4DB284fEJbT1J9bH84TwpnztK1TcjMri6+OglREwG9BWx5YEJimFaYZnxefR9VkRlldJ6Z7iJ3yR4iZk3UM+DOqjlxbVJIdz8z54Ynw=
Received: from MN2PR15CA0045.namprd15.prod.outlook.com (2603:10b6:208:237::14)
 by DS0PR12MB7804.namprd12.prod.outlook.com (2603:10b6:8:142::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 30 Jun
 2026 07:29:18 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:208:237:cafe::a6) by MN2PR15CA0045.outlook.office365.com
 (2603:10b6:208:237::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19 via Frontend Transport; Tue,
 30 Jun 2026 07:29:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 30 Jun 2026 07:29:18 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 02:29:07 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Tue, 30 Jun 2026 07:28:38 +0000
Subject: [PATCH RFC v6 2/5] mm/migrate: add batch-copy path in
 migrate_pages_batch
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260630-shivank-batch-migrate-offload-v6-2-da95d7e8b8a2@amd.com>
References: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
In-Reply-To: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>
CC: Karim Manaouil <kmanaouil.dev@gmail.com>, Frank van der Linden
	<fvdl@google.com>, Teja Vojjala <tejavojjala@google.com>, Pravin Tamkhane
	<pravintamkhane@google.com>, Kinsey Ho <kinseyho@google.com>, Wei Xu
	<weixugc@google.com>, Matthew Wilcox <willy@infradead.org>, Davidlohr Bueso
	<dave@stgolabs.net>, Vinod Koul <vkoul@kernel.org>, Bharata B Rao
	<bharata@amd.com>, SeongJae Park <sj@kernel.org>, David Rientjes
	<rientjes@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, "Yiannis
 Nikolakopoulos" <yiannis@zptcorp.com>, Dave Hansen <dave.hansen@intel.com>,
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>, Shakeel Butt
	<shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Fan Ni
	<nifan.cxl@gmail.com>, Jonathan Cameron <jic23@kernel.org>, Aneesh Kumar K.V
	<aneesh.kumar@kernel.org>, Nathan Lynch <nathan.lynch@amd.com>, Frank Li
	<Frank.li@nxp.com>, Dan Williams <djbw@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782804526; l=7792;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=8C7g10RFPyzYzAfUxPcrNVYkvx5/MEoSLQXRbVB3Soc=;
 b=78QuvfZbFaApjYWZ4bqW9eN9T1Std1pZ5X+dmvGgzHNEJaHkbBvcjAdxO/2Er35RKPso2FJm7
 49kUdpc/R2QCaSQTplNyJKh8AYB6DF3BLeq7aLzZE4LXPNJ8Pn8ebIf
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|DS0PR12MB7804:EE_
X-MS-Office365-Filtering-Correlation-Id: 47594dd5-fbe7-4453-71cc-08ded6794ba8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|23010399003|376014|7416014|921020|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	Zl1sPqWxQt9lXm1Ne9CsNVYaFCfWyhblw9hk/j9mk0UvIm4DIrAJH8NznJEJESnPeUNTIn4da5MD+Uz21lTIZB9HVrmJ9K2vN7UIHeXKiqCR3woGdLPWdGv55wQvDgvwF0o+aq782lUseeCSifoPQE6EhAoqe0tpcO1Y5qWqgvqHyFSmg439Wk883XoIfXgu3jLCSFFbF9iUNAyQw0IkD1UJ/WHSnCwJxroVO7yyeCcttOSw2kxEz1DY22XRYHNdOb/dk5mzCYhD2pZgS3VqD8ri0Bu1HOERxhL4ML0Pn/AOgMLEZTBj4MuZhIRVoKBVaiaCB192GZHV6i1pnqVO5NZ4usty/hksfcn8fF5XePJL5VNeJUJQY0ZAQNSM329ly48AzYP7ZygJddtxMpKAys9Rl6UjFs3RqbmQkzMD4Wpg+wvKXXDr8wI/Mvj7545qoZ+bP/twVtgaAQ98ELqDRcMl8Td37qfMQ6siefQZM2LBPMTY8IpJVkSvfyyoarddBjANdE4ex7bnscsEJhjrzxnvz/tLRPPf43cz6H4RtCOzbCk/KMZspWr6LtToGBchWwr1OIcxvNhmk2LVIV43Db1cHxxrHXUgKT5EM6vyjhIcFSY6LqRFobWUk77eGp7q/8vh3FfpFm/MI9HNlR9kCTpUMrBGo0bIey9ZCo82puF+Ez9H9Bru0zwVboyCbwCinNUg8cKI3WWffETigYsAoC1EVmkUsBWemcmTcU9zB1Rs09Fjy1zMOd8vDCShp2TL
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(23010399003)(376014)(7416014)(921020)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jp2ALsP5URr/SdTH4FUsV3mZte5nbOCBXiwVxlpzNrGITNyPJbhqr6SDV7BbGSLk9bn2YhnN0SF7pjgcPrkA1onhwEzzO5bux3hvF7reIwyDfiYQZu+TKUUPIlY6ZDG1v1G8I2B2KQa+Rif78RgLahWCJxz/yl4/4v/Mn6OpXykseABeFXXgimuQJiJm7CuIKXbBfXmwL62mrZpAYdGnyGnCdCdb3rtimDp2GciPCZWbHW/NvPWJNkSMZQtf9QyeXDzVpNoi3hlkxj5Xb+IJhVQWjp6u3V1Wd/krZZdnZHJPRhpqnip/GKFYVaoKdNLFvgmlWepS+axkhHd0bl91/ovAHe73io/OeODoha1pdVVTjX8Xy8RbElQuTci4fl2rq7ZeBjfaJPmRz+ead7RVok6QUiutc3FQRhUAcjYbPAsddC4oiygCkvIREhliaZpU
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 07:29:18.1487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47594dd5-fbe7-4453-71cc-08ded6794ba8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7804
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6891018000A
X-Stat-Signature: jwau3smuncd7krsm5zt5iedobeiso5yy
X-HE-Tag: 1782804564-952360
X-HE-Meta: U2FsdGVkX193GP+TEIqAHsRMP/FMC+Em7dOsUjxBh8le6KX31a/7FIacSOXiZWmfvNykDIIyU7uPGZy7H0i5vwpAcxW1ykGkKStrnhoj2+L4ToGSFgnP+0L4G8Yq+sLZy/uD/Hrf2WcujFApI1XHVytdRo6RKKKWPcZOszjk96lJSMKuD4BSqGpFvc5c6DTw8C9VdUvWX/yb8ThI6anmoNaw36Ubz1vV+O3mdYpU3VhUaAHMI2eXanU4ernj2dtCsZdv1RtpYIY4Fqbl+wpOUn2kThqgyBKs+D966bKt3YHEvgK5omK3sRXP4rbIXozDdMTk/jag1LQ1iRk8wp9KZ+e+rqagFfbILvPeLzUC+w8ULUPsXu41V3NH2LnQotDMUUDWwlJ7tOs5WPoq+6bHB4TMLBd+zlXR4n91dI83UVet3ez9xP2alLNDZhbKqeEBMcknBlhbPTFKwASMWA/9Inx9KF2prvVeEt6FvGOQFNQVACEk5Nu2pHj4nlmlLzyS2M3Xppbjk39JI9FO5WcjQYEeg4QcQF0RKO3Cn5UASdw29oOZyyk65n2I2x846I0HVsE8DpA3fNn+/7O8kY50sY0Xquhu1P4fy2SaS/l5WkxRQXkiSWU/nM4gOo3ntEURO3f6imCUZ75bEfNULxse6Bk3F8Tprh5gc1IR0vKbtNiym7S7mHb1zGO9GP2sJOOvnM9IEKp5qS+scWJa975bK7RPksxB/tqkmAHX8BzJPPtElTuC07Q+BuOc4EDKui2r0TYMWML6kZnBbjRFINTd/Owywj3rkOsVA6WQJmnqZMuFmmBupwYVom0ZqIxxwEqwS5zeELUVFX1j90mRw2AT7JjggaCJe8+8vRqT25mAWExoGFwh5bAWPg2QnnVZijtG8FT+EsOyP5wIdv1Eqj5p1zhupdAUK9VoyajexIAG1gMPzD/GK7TIPIrNvDnGpzo59eMgf2V/sO5vteuADqV
 oQ5Hcf0j
 z3HB9m+o9Is65psERXxFA2g9JqyC4pu5+O7MTryHmDjyoEST8COm75/7FtPX3Z88hy0/JoJmoC3ygZ+evQhfrm/kRPIUheuz0HLN+NbsRD8A+t2DXoMHeEtqjeNp4CpamIqjecfppIWMMKm+wsvVWmbdGRKQboumw9nLUKOCgUyBoSASQTFrA6yNmKjRzIrEXqJw3UHtU/vUIP6xAIKcjl1JECg4qjDnR7iXWnBQ/I1VAjMRLllOYkmvH1n8PlIaJE5L6SbKZjWksb0d5J4cVulQ5pq1jQA3Mg/Hjxjr6wCV9hwgRBx4KdkGBRQ61dPS+twqxPUwzQ/LSLisI9bdl0+RUl4LsMud1+MPuXYDy9PXvlWJgvojeoGr96wXZQ12IvE5dq4Jl1wmaAP9VUZB3MZgwre7lva4MAgQGUR1I8zg/trN4Ly/WuvIvEBuRkxK15DaivQKXEhQcGiY+DgUW6CAgom7kZRKjJ0dnL+Eu8+QhwSACH70kR3YVC2dUBOjdgMa9Ux0fIo+i2ySu5x4I4BBH5+CqdxYkDFmBdLQXnk7+fwH06DvFKw4ynA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add migrate_folios_mc_copy() which walks src/dst folio lists in
lockstep, copies folio content via folio_mc_copy() and marks the dst
with FOLIO_CONTENT_COPIED so the move phase in __migrate_folio() can
skip the per-folio copy. The folios_cnt parameter is unused here,
present for the offload_copy callback signature compatibility used by
later patches in the series.

Split unmapped folios into batch-eligible (unmap_batch/dst_batch) and
standard (unmap_single/dst_single) lists. A folio is batch-eligible
when the migration reason is allowed by the driver, refcount equals
expected and it's not a movable_ops page.

After TLB flush, batch copy the eligible folios via
migrate_folios_mc_copy(), then run the move phase. The
FOLIO_CONTENT_COPIED marker is consumed on first read in the
__migrate_folio, so a -EAGAIN retry falls back to fresh per-folio copy.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/migrate.h |   3 ++
 mm/migrate.c            | 107 ++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 97 insertions(+), 13 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 876035df2fdc..e62c974b81d5 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -71,6 +71,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
 int folio_migrate_mapping(struct address_space *mapping,
 		struct folio *newfolio, struct folio *folio, int extra_count);
 int set_movable_ops(const struct movable_operations *ops, enum pagetype type);
+int migrate_folios_mc_copy(struct list_head *dst_list,
+		struct list_head *src_list,
+		unsigned int __always_unused folios_cnt);
 
 /*
  * To record some information during migration, we use the migrate_info
diff --git a/mm/migrate.c b/mm/migrate.c
index b3f632575c82..41b732e78a67 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -51,6 +51,12 @@
 #include "internal.h"
 #include "swap.h"
 
+/* For now, never offload. Wired up in later patch. */
+static bool migrate_should_offload(int reason)
+{
+	return false;
+}
+
 static const struct movable_operations *offline_movable_ops;
 static const struct movable_operations *zsmalloc_movable_ops;
 
@@ -1707,6 +1713,60 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
 	return nr_failed;
 }
 
+static bool folio_can_batch_copy(struct folio *folio)
+{
+	/* movable_ops pages have a separate migration path */
+	if (unlikely(page_has_movable_ops(&folio->page)))
+		return false;
+
+	/*
+	 * Only batch when refcount matches the expected refcount.
+	 * Otherwise a GUP holder could modify src between the
+	 * batch copy and the move-phase refcount check, leaving the
+	 * dst folio with a stale copy.
+	 */
+	return folio_ref_count(folio) == folio_expected_ref_count(folio) + 1;
+}
+
+/**
+ * migrate_folios_mc_copy - Copy the contents of a list of folios.
+ * @dst_list: destination folio list.
+ * @src_list: source folio list.
+ * @folios_cnt: unused here, present for callback signature compatibility.
+ *
+ * Walk src and dst folio lists in lockstep, copy each folio via
+ * folio_mc_copy(), and mark the dst with FOLIO_CONTENT_COPIED so the
+ * move phase in __migrate_folio() skips the per-folio copy. The caller
+ * must ensure both lists have the same number of entries.
+ *
+ * On error, dst folios already copied keep their FOLIO_CONTENT_COPIED
+ * marker, while the remaining folios fallback to per-folio CPU copy in
+ * the move phase.
+ *
+ * This function may sleep.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int migrate_folios_mc_copy(struct list_head *dst_list,
+		struct list_head *src_list,
+		unsigned int __always_unused folios_cnt)
+{
+	struct folio *src, *dst;
+	int ret;
+
+	dst = list_first_entry(dst_list, struct folio, lru);
+	list_for_each_entry(src, src_list, lru) {
+		ret = folio_mc_copy(dst, src);
+		if (ret)
+			return ret;
+		dst->migrate_info |= FOLIO_CONTENT_COPIED;
+		dst = list_next_entry(dst, lru);
+		cond_resched();
+	}
+
+	return 0;
+}
+
 static void migrate_folios_move(struct list_head *src_folios,
 		struct list_head *dst_folios,
 		free_folio_t put_new_folio, unsigned long private,
@@ -1806,9 +1866,13 @@ static int migrate_pages_batch(struct list_head *from,
 	bool is_large = false;
 	struct folio *folio, *folio2, *dst = NULL;
 	int rc, rc_saved = 0, nr_pages;
-	LIST_HEAD(unmap_folios);
-	LIST_HEAD(dst_folios);
+	unsigned int nr_batch = 0;
+	LIST_HEAD(unmap_batch);
+	LIST_HEAD(dst_batch);
+	LIST_HEAD(unmap_single);
+	LIST_HEAD(dst_single);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
+	bool offload = migrate_should_offload(reason);
 
 	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
 			!list_empty(from) && !list_is_singular(from));
@@ -1902,8 +1966,8 @@ static int migrate_pages_batch(struct list_head *from,
 					private, folio, &dst, mode, ret_folios);
 			/*
 			 * The rules are:
-			 *	0: folio will be put on unmap_folios list,
-			 *	   dst folio put on dst_folios list
+			 *	0: folio put on unmap_batch or unmap_single,
+			 *	   dst folio put on dst_batch or dst_single
 			 *	-EAGAIN: stay on the from list
 			 *	-ENOMEM: stay on the from list
 			 *	Other errno: put on ret_folios list
@@ -1944,7 +2008,7 @@ static int migrate_pages_batch(struct list_head *from,
 				/* nr_failed isn't updated for not used */
 				stats->nr_thp_failed += thp_retry;
 				rc_saved = rc;
-				if (list_empty(&unmap_folios))
+				if (list_empty(&unmap_batch) && list_empty(&unmap_single))
 					goto out;
 				else
 					goto move;
@@ -1954,8 +2018,14 @@ static int migrate_pages_batch(struct list_head *from,
 				nr_retry_pages += nr_pages;
 				break;
 			case 0:
-				list_move_tail(&folio->lru, &unmap_folios);
-				list_add_tail(&dst->lru, &dst_folios);
+				if (offload && folio_can_batch_copy(folio)) {
+					list_move_tail(&folio->lru, &unmap_batch);
+					list_add_tail(&dst->lru, &dst_batch);
+					nr_batch++;
+				} else {
+					list_move_tail(&folio->lru, &unmap_single);
+					list_add_tail(&dst->lru, &dst_single);
+				}
 				break;
 			default:
 				/*
@@ -1978,17 +2048,26 @@ static int migrate_pages_batch(struct list_head *from,
 	/* Flush TLBs for all unmapped folios */
 	try_to_unmap_flush();
 
+	/* Batch-copy eligible folios before the move phase */
+	if (!list_empty(&unmap_batch))
+		migrate_folios_mc_copy(&dst_batch, &unmap_batch, nr_batch);
+
 	retry = 1;
 	for (pass = 0; pass < nr_pass && retry; pass++) {
 		retry = 0;
 		thp_retry = 0;
 		nr_retry_pages = 0;
 
-		/* Move the unmapped folios */
-		migrate_folios_move(&unmap_folios, &dst_folios,
-				put_new_folio, private, mode, reason,
-				ret_folios, stats, &retry, &thp_retry,
-				&nr_failed, &nr_retry_pages);
+		if (!list_empty(&unmap_batch))
+			migrate_folios_move(&unmap_batch, &dst_batch, put_new_folio,
+					private, mode, reason, ret_folios, stats,
+					&retry, &thp_retry, &nr_failed,
+					&nr_retry_pages);
+		if (!list_empty(&unmap_single))
+			migrate_folios_move(&unmap_single, &dst_single, put_new_folio,
+					private, mode, reason, ret_folios, stats,
+					&retry, &thp_retry, &nr_failed,
+					&nr_retry_pages);
 	}
 	nr_failed += retry;
 	stats->nr_thp_failed += thp_retry;
@@ -1997,7 +2076,9 @@ static int migrate_pages_batch(struct list_head *from,
 	rc = rc_saved ? : nr_failed;
 out:
 	/* Cleanup remaining folios */
-	migrate_folios_undo(&unmap_folios, &dst_folios,
+	migrate_folios_undo(&unmap_batch, &dst_batch,
+			put_new_folio, private, ret_folios);
+	migrate_folios_undo(&unmap_single, &dst_single,
 			put_new_folio, private, ret_folios);
 
 	return rc;

-- 
2.43.0


