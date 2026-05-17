Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7E57CD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 14:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1971A6B00AE; Sun, 17 May 2026 10:00:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16EA46B00AF; Sun, 17 May 2026 10:00:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05DB86B00B0; Sun, 17 May 2026 10:00:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8BEC6B00AE
	for <linux-mm@kvack.org>; Sun, 17 May 2026 10:00:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF33AC1FD0
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:00:15 +0000 (UTC)
X-FDA: 84777071190.04.70B8656
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010003.outbound.protection.outlook.com [52.101.201.3])
	by imf29.hostedemail.com (Postfix) with ESMTP id EBEDC120013
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:00:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=W1ESWBGl;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779026413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ArEH/lkRcWJQU8MZ9DZ5yK+j6jI8INdHbkXeha4qVcM=;
	b=eZBKFk8512ZQUYXbp0ubl8PrW1PEk6YmDvu29+d/wUfTURHta8fiS38FQeFwuE2k+9TJzT
	TJ4zJejN7W1UxvzJc+h+MeExSxO++3Y9MT3Na8NGkfHLiRxSyolud2yG1l3s96JI8T/jzk
	RUINnRWu/04KagRRaCBg5PYlekn4TfM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=W1ESWBGl;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779026413; a=rsa-sha256;
	cv=fail;
	b=cSnUo2x2jvGEJdXQn+CwDtknk2e6azcqX6nuLvVuc2De5SXANebZ9XuwV2Yx1Xv1whE9Bn
	oVcJWIaPE+Z7P268VJHzcgN651xRGbfc3Rw5ZYdYx68WRS3UHfUrJ5FTcmj3gson/MU6K8
	Yj2jl0bZs3Senr8pkzb9WxD6zxirQGQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CUcwDeB8dLUh/zaLvr4q9CaZK3OoBPTdy6CtkgbjOFPliuT/FJA13hFjUWesF+Uo2W70Fz3jmnRcVq3mlG7n5QPsuCOjo56aVEpmxMf3m9af6oRFenKmkmLgdq0aFcWN385o3sKrDECpL+m4uw9wmDeCVRp0Tc7+c4aWerClQBnyt/rdajnxLi1Qqkdy1H4/efVKILAe5Kznyet0yEAkumCEoLEA/IM591KfGqHDBz91soTY6cLabXTE/DnuttAtbUsmdJNuzuFdNxySnbqxvAjkcAi33a5nyDXYd3L/GOnCDOdmsF9iO43yHykJwmgS5RBjEIHrG9cTXKs2aCg8Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ArEH/lkRcWJQU8MZ9DZ5yK+j6jI8INdHbkXeha4qVcM=;
 b=L0zHB8sh4h8AmzAYcQx62Uc+xBK9DuZi9dcNaKz3cHhPurm2uV+n6CPBuFglYx473zHfkQUHplKQ/ZJVOeTjAG7iotFEsRFY2YZd8RkvkO5iB3pwlmeptt1oOanXt9fBqbqyfHzqebdfdFM1JmP1Rnr8H2Qspjq8/04ColbKCXraYYOnM8PQ9ZFV2wbuM6NN9IeHkkWJ0MgQq/so2DFnNlQqid7P3x9VvV7PnfkCGTLCHhStf3rVYvJOXj38SEnPHYQi4VP8WK/kXHet7qVjtP011flUba5/5pULxFa1dCNOXxVQLMMS452Wvtk2sz4Z2Off4zx5xih6Q1RrwPcZEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ArEH/lkRcWJQU8MZ9DZ5yK+j6jI8INdHbkXeha4qVcM=;
 b=W1ESWBGlqGKa6xjMyKOEqugzeXeohn5c+ACrnuem3mZhxroVpsDIqz8QKGBLL34/it/zAWcF9RMb7WSsCHZwb+JAjchXjy8KsGjpG2WGqzd57hBwGjQrmghHp7EHeEzZoQEafenhgxIuoeLyqEILZqp4YCSxwegiAWpeFCS4Z2vRRwh4cwS/tM1+IRy6mfuDeAFBO1nun9DmBj/G780srbkAW9SgZ1LxwwaXsCvu6MGZ6kNk6A5M7kkaiv+LNs855pI4dPgKVfIJpYt6L2gJO1GtEfvzOlr3y7ZF32DH4eN3AF1o7Vj14PaPE/4Zz4347vDu0u5ueAA4G3hTCq45og==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:00 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:00 +0000
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
	linux-kselftest@vger.kernel.org,
	Liam Howlett <liam@infradead.org>
Subject: [PATCH v6 02/14] mm/khugepaged: add folio dirty check after try_to_unmap()
Date: Sun, 17 May 2026 09:54:04 -0400
Message-ID: <20260517135416.1434539-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0388.namprd03.prod.outlook.com
 (2603:10b6:610:119::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 84603023-906e-4642-99ac-08deb41be338
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	xhsPC7E6uBJ7wJf9+B2h2+435LXUE4aatrbngzAYADgvuyvbPvk0o4UGr163rkDL1L3wGuYvnIs37TTaOul67PP212+o2E0cywczBbiu0oqY+/p+Qxz41sqBpLUTuVbIzIEtT5VGbNE/jEePApDFRcgddH0BktNWoXJgKFxyVApBXUTTSHTe696MCwyXF/TuvTdTEC8xJU0+qmaX7kH869veB6p2BDIzGGwwpcsoc2w/eSsWpb0Q0aQrljeFI+Sgp8+dJW0pSNAKOcPN+2FTh5R3Nz48zv3ubdnIwK9RyNEKUlxuEO3OJmEIq/BPis611Lwmk1WePxZYrjUUuy59E0lRrAz3xleKg/pyfvMRDjHW3F+nDeUgiDoESCFKKEM9DMazfWdd2qkW7wRrKlQcEO+iJdJsvXkM1Ge3Cv1m2LMr39YYR7PtsEp/S6D2jX+fS7Z6Z93GMBHTBtFLOAIyYBkFzBpVXYXN2PvI/cg+EZwstMctdKm3CxfU/oJoLAIPSxMmgLv8BA845n3wpmt2Yu/YiLWQT+fVt8mF8uAagylX08TMFtLBy4HS1ckcKO/Kmfkci4dzaxP9bVSSbXyxrW+1nvMnloFrd39qfT/Cunut4cFtDk0QQTiCZtfreEt7CqGRl/XoaZ6O/UxE+flJEpU0kMKK0vqOD3qrotYpVlgRyk6GaMern/+GPZXswbqo
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SD9zZxkVexDNQd4ot0Nw/PBwtcUj0g6EyJ7EaI+y/++MAjr+ksseiOMQczFk?=
 =?us-ascii?Q?8OVUYrdkUgml88orw7FCYYlpMXJEO9KEXekqupAk3lSrF2UT3UMVxCv3KHUh?=
 =?us-ascii?Q?yJn9SG/QLTloYJ0CZmBVP+45vx46ghuc1GQkjTYz+KYpVcBacd7revaHVNXV?=
 =?us-ascii?Q?7epdqBQrBQGDtdIQtFzdeghIiQkyjvJklO89PtRqt4LRe2t/CNQs0eEr11ln?=
 =?us-ascii?Q?hizg3o60k6Agt551CabPcdrwgoqDAg8Duu9wTf3UH73rj3ecWOBLq3nAUS/H?=
 =?us-ascii?Q?CiA1auOs3wW7rs+z/SMD4J3/z7F24M26Omct6ShONf8dShWEx4feEC4L/fMr?=
 =?us-ascii?Q?FHCwCmnD+256P+rVrH3htr4hwCOQmWUE8H/XB/oPfDoI25macroPFPi/lH0Q?=
 =?us-ascii?Q?6YQAbRo3zGWNQMx+sY6Kv5GxZX7M04D7RLGdxLduk2eV1p5niKNqrece2PfE?=
 =?us-ascii?Q?BexWeBO9AwLw6BbkBFik9c6H0CKudpruiunM1PTRIInnfJh4QBT68byQ0Nnp?=
 =?us-ascii?Q?BhoN5sI1PC0RWgGUntiU80q/kS7MUkoz1D6Fa0ZitGwh9hA1aO991NcKKY0r?=
 =?us-ascii?Q?KnCGd1If/53YGg4OSW+gKrXv20GZLt42hZtEcB1sFd92Kh1xfP+PKZN7X2y5?=
 =?us-ascii?Q?LdZKuuJb+y3mzGx1Knao7p1lAYjbQ5aryhjaJh9lNhRby8YL4jgE3y7JJ/PL?=
 =?us-ascii?Q?O3t5ZW9d8ktGApue33NoBOtHgUdhg72hB8nRyUNYAdSkAAnhkvJqUgyaw2vB?=
 =?us-ascii?Q?HEDsZw2bFti6cDZ2XWzZo7Bi8UieRIVP6b0l76n0b7rlq/EYvhf1A8U4a8ac?=
 =?us-ascii?Q?p6knkyAFuzIImRuib0Sv3Vzxe4uyOv2DWZpOVdPrBniRfNq+CdrS/hKFEgkW?=
 =?us-ascii?Q?D0oacTw8cgrerhkgBAdgibW9xa+JFEDHl2oWvRrYbHQ0nQfLK29ckLqX5YUo?=
 =?us-ascii?Q?YtGvGgni3UgY/Q5IUK7XuQ68M3xkj6AJ/sba6SAcq2oOjBeKy2LQU4DOvY+f?=
 =?us-ascii?Q?HfoIC0YSTsfvvEh3seEPJRWQYqTcUL9jepOxObKe+NlZRqHzqnwZkshpEtgy?=
 =?us-ascii?Q?H33CZJF+ydLgqyjxb1kn/4PUtE8jhB8BODazCDk9KyKGc2AGItTGWXqGvMWB?=
 =?us-ascii?Q?YMGA27vUfEsVmp6ny7AobyVO7bbFC8cL6BSLHJ5Y7GnNSyZmfbTOevm34y+c?=
 =?us-ascii?Q?8ncTjhH5KA9sdfCCh5KJYoVsVTjYVSiD20q+MaanxQOshM5wSTV49onkoJ30?=
 =?us-ascii?Q?D9k/Md5uE0iaoaBOqPNUr5vbFpWTJsfCaJz/jG8fMzAUTU1SBiml6RbIsbXc?=
 =?us-ascii?Q?hzkYzXAOno0f0XPwABwp+a2m6ks5/AkvpXqJgOUqJ+uOb3/kFMkQvf0SwCUg?=
 =?us-ascii?Q?IRs5u6Ydx88pUPdP2gE3wTAEXVV3tERWvkUZhL8hNqR4hjQ1D0bkae8zIV3x?=
 =?us-ascii?Q?9V8SQ5pyzqDkHgyWa0mlyPb134LJSO7Q63KURDfiirDuzchei8KktCWsZHaA?=
 =?us-ascii?Q?AGNlEVXZovx925VBIbJQ3KViAJZ/1LLP7xsjALmF9QNfrYeWNdy37ToKHP+0?=
 =?us-ascii?Q?7eVNsihuf8vQ7WVrJZNLDJQ7xliPqQAKVMK3g67KZ1xTkjmkUmfI82ReJ+gq?=
 =?us-ascii?Q?JSjvkWWtiQpGm5XaspBerM5MFTSoBQr25ttqvmemcDpR2UA4EGUMIdMImUq8?=
 =?us-ascii?Q?bXMNzbYHbCLB6Bl2YNnOBIlr/hkAwAU86CnvnbSxhGpNscWD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84603023-906e-4642-99ac-08deb41be338
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:00.3413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VdPaNDjW8c0rQsE+YufFRVw5kO69w/yJexjmhBPw4b3NkwQ4HoYe06QnPevVa2CK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322
X-Rspam-User: 
X-Rspamd-Queue-Id: EBEDC120013
X-Rspamd-Server: rspam06
X-Stat-Signature: xdexdg3c376z6j8x3rxprxfrged1967d
X-HE-Tag: 1779026412-447974
X-HE-Meta: U2FsdGVkX1+fJUhSbkma5bfRTChUegr+Us1P1laCxT340BpewwCVOwHJa4bYja7xGPRvdSPDSUICzAZtr/vJRj11h3yAB3sEZrklAPd0/vyIPFyBHv7+nr4SF9xB5ixdhg0DLW7qJPS4nsjmGlXkPYcgA8TZsJA9CilOnPKwv7Nd133Udvg741nhqT/HokEIa9s6r2xXIBEREiQNnzEyfX4BnXptAtgrwyiEipIj6PobXYJh/ZGSF09jC6akqXT1dGuVXN0dllMKctyUCKhPoXORYCUuyL2rJcJE3086vFX74LnKvvoyx64oOr2yAd+9LDFgFQLglUkyoMoeEw4mug39A7CriXP41L0mck/ShJNGR5CqJb1pTU77dQ48hnvQN1SHVsAnmSB2qYavaL3lmR7tUEfuDqWK5Opw3CyzxqTCcu6EqcEBhGN09lNqCCxn4K/3eR+q82m3Lbv85YUbQmdNip7YgLPUP0TPlhm9eI/RqfNAG1MeTckngSSvnxuLK2xF6K0yN/6NInCqU0iSw8HwwEi7LDkLJ9HBBfMlFHtejtuBRg0Die9dXP7CUPHyqswEAv3k8d25o8A8JfFeF8xwQM70sKyWRRqwopXtdSs4D0QfZaYm7dAx6Bagc0t7zK/8UxI1EHxBSFLHd07SexEDXdfq4kaUN14VZmI0OZgCgb8Ne6C8gGS2WFxikiZ5x/6cbLiyPGmbe1375wDiYY/d29PWfflp6we9maPNFVRHs2RCd4M9mM9DvR7wwyzxLQNvOfZLuA6PbHBvQOKdFV3voAcJRjl3ZDqddTxXnQ1VX9EoRuQVP5fE4BbKhAoh3MXlPZrADlwwgbCb6+5WDXIZxACYwaIA7GmGC9Arg5wpOP0/vp0zc8TDaIfnoCV9zOo52AkUmL59uui0w224/lhymNECwsBNVFgilWyUL7R2aC9o7iHGEOPTnrc/kcID9NG3ntprquYOwnqBKmm
 whbxhG1h
 zl7B2VaLgDjtxMn2XyNKxJkqJ20zum4oPWU2BmWWO4CAHBt7zme00VEHDU4Wca4ksV6lAkXYtaVgToXtWGMPvDi6bTRyoukUeRiOXCyseKm2PzFC6ewghWG/wkP/9t0ru5f+gZrpM31uFHAzjqaFeOX509De0uHfUmE2UC5ztOlB0ucMJ8mihxsCwORi0i3Xlkm2/iOiyYLPSgAx9kiUd0UgATyOBws67i6iYm+8UlC79vtgSGBDyT2MWP0rxBqEqLGJBSfYyZSCu9mH9NszqrQnvD42Nbev6GP4ly+W7Hl1ICPlRCtO9GvjhgJUcVIBdgR7bQFp+yLWTtX4pTBSHLNYamzH7wJlFvd7c4p7TrCIZCDZrzqXQwIlqyQTEDr9DE7Gs2GoqvVXoghXVbAeKEWTDXYNmOExszvqBAZvTuxgk5afgijVbHmJXkBoZWf1/bbNwFD/XD1MVFCqiyCW2etzBtZYskKImIOGSwPj4Pno9u6OTIbYWiaUtPyfQDBfkSdij+Ow6mmxY+/ZclcmNJr0YbeXIms9ULv6GSET81HIl8B3Dt0RWcKCQOpKv/LGzkuL1dYdspooc43ntwbTxAfbuva1ExW8f+YRjw+WzhjNnpHTVMMZuvZz8/XSxuVe13n1j+MJGFkensbl7EKqbpYnuOtSxBQlqLep5aIeqJZnqozUdckwL1jBbNsPfenrHgtZ54FsxxXyIbyXIpOXCN4ntryRVQqqYcsv2Qs/yd19RInOmCZ/w5V5Qr9gbYniixBCNE0lTLVB1npR7idGG8p/BVNfTYKzJyW+E39av3MM/U3OS/OnUUf1lJ39ZRikCX9f+wZbNZ9UpXLXprBsLKr6dhc/tj3VEXtcZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This check ensures the correctness of read-only PMD folio collapse after
it is enabled for all FSes supporting PMD pagecache folios and replaces
READ_ONLY_THP_FOR_FS.

READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
and inode->i_writecount to prevent any write to read-only to-be-collapsed
folios.  In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
aforementioned mechanism will go away too.  To ensure khugepaged functions
as expected after the changes, skip if any folio is dirty after
try_to_unmap(), since a dirty folio at that point means this read-only
folio can get writes between try_to_unmap() and try_to_unmap_flush() via
cached TLB entries and khugepaged does not support writable pagecache
folio collapse yet.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 mm/khugepaged.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index afd61168d915c..2ebbfbd260ec4 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2335,8 +2335,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 				}
 			} else if (folio_test_dirty(folio)) {
 				/*
-				 * khugepaged only works on read-only fd,
-				 * so this page is dirty because it hasn't
+				 * This page is dirty because it hasn't
 				 * been flushed since first write. There
 				 * won't be new dirty pages.
 				 *
@@ -2394,8 +2393,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		if (!is_shmem && (folio_test_dirty(folio) ||
 				  folio_test_writeback(folio))) {
 			/*
-			 * khugepaged only works on read-only fd, so this
-			 * folio is dirty because it hasn't been flushed
+			 * khugepaged only works on clean file-backed folios,
+			 * so this folio is dirty because it hasn't been flushed
 			 * since first write.
 			 */
 			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
@@ -2439,6 +2438,27 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			goto out_unlock;
 		}
 
+		/*
+		 * At this point, the folio is locked and unmapped. If the PTE
+		 * was dirty, try_to_unmap() has transferred the dirty bit to
+		 * the folio and we must not collapse it into a clean
+		 * file-backed folio.
+		 *
+		 * If the folio is clean here, no one can write it until we
+		 * drop the folio lock. A write through a stale TLB entry came
+		 * from a clean PTE and must fault because the PTE has been
+		 * cleared; the fault path has to take the folio lock before
+		 * installing a writable mapping. Buffered write paths also
+		 * have to take the folio lock before modifying file contents
+		 * without a mapping, typically via write_begin_get_folio().
+		 */
+		if (!is_shmem && folio_test_dirty(folio)) {
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+			xas_unlock_irq(&xas);
+			folio_putback_lru(folio);
+			goto out_unlock;
+		}
+
 		/*
 		 * Accumulate the folios that are being collapsed.
 		 */
-- 
2.53.0


