Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA19DC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 17:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D18F8E0017; Tue,  5 Aug 2025 13:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A94A8E0001; Tue,  5 Aug 2025 13:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1983F8E0017; Tue,  5 Aug 2025 13:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 066DF8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:51:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8A4D114A93
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:51:52 +0000 (UTC)
X-FDA: 83743446864.30.4A0DA09
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
	by imf08.hostedemail.com (Postfix) with ESMTP id F3B83160003
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:51:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mJJ9hyE3;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.220.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754416310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SwPGcwNVesZMSvamT/IU7Ij0FHCtG4/sng5G+yTlZmo=;
	b=B2wEXYNViGraikZozKAvTUEvf1l5nePgpPt4fQxjoP/uxSvYvW7ZBn/qUVHckSFEbOeBsf
	E5jZ9lFDtMZLXtxtibQMXc+IOYFct8dzdwgIHwCGy+k04yQNTmhvwEmcaCzS60ymbk2qZq
	A9ZMzDpS8JRPP1knr4pDLlKOPHEnQx0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754416310; a=rsa-sha256;
	cv=pass;
	b=wjo2QGv39/SHX7h7KXj3YdSpkr0ew702FzE5XT6vWAQHH7Hv87XFJk8Xji2Sw8e50Ma6cl
	HMxRS6TTI/5R2bc0umOcZMLOUCFqPJ4H0Q+cl+38ECi8YMmG+eVWYcvPQNiEsFjQPvOMsH
	eXj1HfgFyPHdurzmfooSvpVIAaWFvF0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mJJ9hyE3;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.220.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HC/Pznybg4/Crm110A4MEy0CJBJgIHx+42KXVS/BCG2J7gtEJZI3rmTYh8C6j6TtKZ4sXaOFZCiVfeZFNZn0YBVJwtvEvZJx5Jc7dUM1SXom/tFCpHHGnRc8H/eMvj/rCbUXB5HYQ8UP963YqVJHX1xLslFjYouMSZ7eCbyemMrEMW7cMBFqZM0fngzpt5mDzu93VcWuC8OaxdC0kB+r1/frfMYm+nj1jMW4e47LYO/V/jhLgxhWVRgv67lGH/JjvtXfKzrBY+qN3tNuFDHvSXp2b7iDbPoTF20RRaqce0I4l+hvojQ0mBe873frWOp/YKCWb4H5L12NuGdyQj54jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SwPGcwNVesZMSvamT/IU7Ij0FHCtG4/sng5G+yTlZmo=;
 b=Z4NRg24tqrehGPbCE3cH11nG1TdN6ABkfHRb6H8yjwdndcPykPdebppBHrNKKsj2NLY5pFeljAynKpd0JNjjKEcCxWlnLBlJWeBeexFTiyfIrCruhzxMkF8xdzwQ06HmT6N2DCMvZitIoWzHqN5i+7oWPFV1PORLN7f7dNMEuS7valIr1Lp8iuD5+7ICJa5vIQazUrkMPACxjEDRyWUAjS6ZV0hIEKJ95zmrZk2BBFSWlGHCFfvsJJReEB04fg2ipmJJAaYFD40qFkZf0/jWkBzvXRuqUDj8c7FyCF/I0zTIGkvQehwPb4bHqo33xvbKNDG6nqbR/J2z43aN9W26Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwPGcwNVesZMSvamT/IU7Ij0FHCtG4/sng5G+yTlZmo=;
 b=mJJ9hyE3sarIExaSva5aH3f2kMonxUWCiHrSL2KRd8sy1bgofrt1lgyo4Y3+j7uZR1+EUoP0MS+lBgbtU4iWV8Cno6j+IJrzD/6xSlZkI/W8Kx6meZSgWpmMFo3uAZT4NpPfQQIDaqZsVWlfVuP9AaDooh9+ELvg+BDR10sHa9gxPWGQNb+3rf+f1Z4U1uidxZH3bjskerX2AHUVz0/yE7yciYh5pw2bJb4eiXXm2zdNJs5vXjHFxskM+hVYQ97kf1GakVKC8AAQvys6optT3Mp67lgNiJ+QdGKkag8EkSc136iwyU1LaiBfWKmlxbIvZ3aRd40XH310p2y4t5K0Ew==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB8796.namprd12.prod.outlook.com (2603:10b6:510:272::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 5 Aug
 2025 17:51:46 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 17:51:46 +0000
From: Zi Yan <ziy@nvidia.com>
To: wang lian <lianux.mm@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Jann Horn <jannh@google.com>,
	Kairui Song <ryncsn@gmail.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH] selftests/mm: fix FORCE_READ to read input value correctly.
Date: Tue,  5 Aug 2025 13:51:40 -0400
Message-ID: <20250805175140.241656-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.47.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:208:530::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB8796:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e181f8d-b4ce-4bc0-61ec-08ddd448be8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jb5v+f/LEJqLLZfGv4kL9i6bgeeLoPax/LlNWuhK6Qup579rGfzhlqwwRYW9?=
 =?us-ascii?Q?+1BhOp1r9Q6y7Yily7L77d6kjnp/7O8URBVdf8VcOnXDnNLAVxgWM2zp157v?=
 =?us-ascii?Q?CLTen4uOpy0IWC6i11JC7+XxAwUI8bIdzhQ/8RzSxvnokMP4POk654E1h1Rl?=
 =?us-ascii?Q?7qvLOpJSmMyZzxFyY+2VOU/bxw6Tc807rk9u3rJMFogc0t0PaZuQYfeWPW6Q?=
 =?us-ascii?Q?x65uX53LwruXMXs9wazx2Gva2YKPpyQfPhBupWtO4+3cjJP73A8JhW8jDj80?=
 =?us-ascii?Q?boc8oypmnc31b6t8lpxPfP16Ai1cMUy/RDEBSQUb4WDf1ol1R8flCTaOULDF?=
 =?us-ascii?Q?pt/mN3x/O3jM7BA3fLatapYKOhVtlhp8G/3rebncnOrmOADjVNlpHPDwgKTF?=
 =?us-ascii?Q?1kFfqH6SIVgIlLVrwzkT9wWBVvJbBoswq7LENAw/jXl5lfWEYXllsaNrrm3I?=
 =?us-ascii?Q?zzDjDwmMSyXf7AuLh9dhEFbuLRmdWfk81ZmX8eou6intHRoEKepa2vB6te8x?=
 =?us-ascii?Q?9QogE/pxVUKXSQtErJ4IzNEd5Lz7vrf5yhZTtY2GKZ5uh3/Pto0zIkqLmnlQ?=
 =?us-ascii?Q?EYzL1hs7sbZgP0pb3THJcW0whDf2zZcy+cMbgEKMZRpAbO4vuutwOh7HZlFQ?=
 =?us-ascii?Q?TYOE9lWjIhNuXXBEDky9t44dfk4XuL/i169dkJfNIM8GIPE/vUbC8GMJrpMx?=
 =?us-ascii?Q?XoRHOsZV17AFBt4DTJv1TKlIwpE1QEUESb1hAQzPE9Xf9gykkTEB8LtgxL7X?=
 =?us-ascii?Q?d8qlZsPFTYGtNV0M3XkOTncf0cqaQKw0bRlbm0AClQOIvsFmzZH/3b+qhUK4?=
 =?us-ascii?Q?1szasEKGXFZ6nmtGWlRR7MiOoP7naNG/yUudKtohEE/eQDM61f7J5dP84/uk?=
 =?us-ascii?Q?uI07dmktAYI28O8Ipxm/MtaKQfJuZvaBzHzxCiGEWbbDjQGb2o7xCiosPedo?=
 =?us-ascii?Q?fNIv26fcgOfL9cf2rVcyXbMg0FDnFknyGyxVrtNo91y9cM4w1c+AJUz/v+a5?=
 =?us-ascii?Q?AuCDSgqyTJ+TXQEkndViLyMG+7UgdHC/FH23c0Re9epGBH5RYkZvQTrpXc1s?=
 =?us-ascii?Q?qnhuIYW2oi6dE4scHrM9YW/2+EqN1dM6MkTKv0s9tukmaGaZxG9TKK49JJxZ?=
 =?us-ascii?Q?UiK0qYI1kjK3omSswV7CNVTxjFDNjcZeFFHNeH7GC7bN2g+rS5akFzMckjF8?=
 =?us-ascii?Q?SLNxWM61Kj8Fm5fhPtNlPkgL+D6OAUYlAzlN5MQJ+E8mTa8M77Y8Ol7yPpHj?=
 =?us-ascii?Q?ngYfXsMBt1qSC7uzOUxWl9VmVWWDO1IzmYAJymqkLqBd6ZYDVS+rE+Qf0ZqU?=
 =?us-ascii?Q?vLn7bHYgBgQa602aROz0VJS+B6cz1AmmqBuRllYoCMLP5tHao5SutJlJ0mSH?=
 =?us-ascii?Q?8HWRH+Rdj32AqS5umMiodfOzpipPfj2Jvc/8M2KWFhdQ042e2w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FMPtRZB+2t2IAHLnV9C0A+n2x/6eFMcU4873VNvP+w81z2QxKckX5vnfETl7?=
 =?us-ascii?Q?j33c3/f09TyTaV4yHFyi2VSbIUI9BVTCmEyfyMd6RNH5wHF+rrv4sGSFr477?=
 =?us-ascii?Q?7vhLxGRhsbABEeBS5O09EELZvKs0nRoyxs/qWalOMTcLYM8UetqZeDK612FI?=
 =?us-ascii?Q?Cs/DaOyMaHossaKob8fEG8ZoEb6S+dD0e9sSNwQQsqI2HT+GGmtIet2nrQV3?=
 =?us-ascii?Q?ax6/ehOXyv5MqWoyxXYN8l78VirvllLXnYb3ZTmq5lz/+1DW9bo2prku/qP4?=
 =?us-ascii?Q?7ffIb0JT5y0GS5ZK2cuvQCai9RaTdG3afA05fMXclJyEazOmdnrX7kHqHvrm?=
 =?us-ascii?Q?Sv2b+uPZTr2fy2vlWBJZ00lVlm2h5SZ9QA1b16sdm8jbJkzKonBo/g7sAMF1?=
 =?us-ascii?Q?wZAvpCQrWuUbAPHTojr8G5J0oseE0wRqPjJPqAHOdYqT7bGRtPgVKfhDKbI8?=
 =?us-ascii?Q?1LW2cNeJsVDtlujlP7CbQuN75Y8WPbAUsX6BVRDsQozTrZfLIEXU6MWhs/1H?=
 =?us-ascii?Q?MkITzxg2W9NMO4zEBAZglgovdTGn2A/igJS0heY4SQ+HfxwNGjTIUBhtUPBc?=
 =?us-ascii?Q?wc0Oi4zu/9hxlhCgdKyBcyzUg8TdtfLEyCMObVUs1vCrH0b0FFRMQfDLRyEN?=
 =?us-ascii?Q?Wvm65g01Cu3FX6QYH1WFmezNnqVtCUW6CXvpvfn6QXKuIErByrHu2xeQYtMy?=
 =?us-ascii?Q?xCfCTyqaA2TkjHu+qCwh/ki4M2YITSkesNNnZbLsYPyDN3wORZ3vje3/HQxK?=
 =?us-ascii?Q?MYu2AV1wUKcOPVMnz+3IG8jU5HysVU8noVyDs2A4Nt8+cEYfAbNkBZwigmyX?=
 =?us-ascii?Q?R36afU0xFBLXSU5U5ILG9BqB+Qz3fvRXkHQOjV4mxQLauT143iP269qEHcWX?=
 =?us-ascii?Q?Elu8cnkKnfdwlU5We99czgrPqjgOG3vYG9Vm78XaqbQPQd0/uJWKp9TZn9xy?=
 =?us-ascii?Q?Iw2N3P5hyiTAfauBPez0Lph5iZPRk4rrvjStHk1RvuoXDtk01i8uPMW30XXF?=
 =?us-ascii?Q?lXdV9VU1ELQnHvd2mz0lqYLSXliN61dgYfl+1ncN1r8wzKH6Ih6c5ImV2sua?=
 =?us-ascii?Q?QPoIsqgdUdiTbASm/eQJ6vWlttFK5TxAImVI6dotLjo+dH0R2YeM38dFGxF8?=
 =?us-ascii?Q?1RqrUWWWzwBaIr1gHJpIa0RiXYlUyPqM3VokIBWtC3w2n73Wn9JytGW+Ru50?=
 =?us-ascii?Q?ETjQPhFJZ+Sjp8ffN+S1je4Urf2C9C+6Vv0khNpKok4leQfUyYNqM8E9GKl+?=
 =?us-ascii?Q?0vi65zEraWD2ObNEfIsyr9eViGYBOCagUt37oMHEUq1s6KWejBryfmhlDh/7?=
 =?us-ascii?Q?h7f2uChIwkMNsA0835vbgd5MVzEdaO3nzbq5qiOSEHtH2P83tbW1SY9syoMX?=
 =?us-ascii?Q?eeZhoiUPpH3j8+vigrGlSiOo4sp85y5eXVdN2MfWCxGbUEpA5TlsxswwiLrc?=
 =?us-ascii?Q?rRHnZulAhWjv29H2TDkrUdLYVUXy0s7mFaGEX3klHR4l6rI/P99rJfc2WWvq?=
 =?us-ascii?Q?5fSewtr6eJsFIMUfn1qMQ+usiqWlKePaME20ZEkb69P7KV9wMkbwq3n7JKdO?=
 =?us-ascii?Q?I6gdr2VP2cAiyuj6A2y9x4QVFStLIPD9XMmyrzYv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e181f8d-b4ce-4bc0-61ec-08ddd448be8f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 17:51:45.7369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hCk9N2ZccxhiXQsgFvOVupK9917YM64c1JtbbtXnrrb33rmvvf/fnFHylb1EO9Kk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8796
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F3B83160003
X-Stat-Signature: kqqxiktt43hq4mqe9uhx6opajzeuzrzy
X-Rspam-User: 
X-HE-Tag: 1754416309-352855
X-HE-Meta: U2FsdGVkX186kL2ZfDSbAIfaOpU8LB8CjoYRCzlcXMdv6B1bZ3futUQp/4xwmUF9EWkkTfH7KoTiE1YedsXFZyQpfFjjSbJrQ7q26OHlXIgsrg5Jwe39KNnLNQD36e3aeHCFvMbg3AcT4i+Y3AqLjTpgx4jpA1oHtQcZOounxfh4BzYy2za58/tpVgj/+jhqgrQIhwUyI+IcboqYHR6esCXTdbNU6TIgvK/E+qAvWH9BeC+xcfsFlE6kNOeWR0NgGdUdJxGqqOM0wR/+MqqkdhY1MP8u9rY1k+2OsmHI8d53roqR4ahWzskVBGoRotKZGghlpf+6PmiQrilIzLtmSCUJJfnj4Tm2j4pPByz2RPOu4RNuMP53VfGz7RP/nOBlAMXlT5sUWUfByNcdr6nIzYjCVeET+1FeraQPJbmf/G1h71g0oVCTPTqOhcHmFWX/QORwzWIrsEkr/TRf3tvrEBqxEumt0eIWwQLhSozC+gUvOHSEfj2Pr3PjrApJ/vTegwLzSEdVcCSsiMik4HQM2nRE6HftYSXNwnVGzRJ2GWe+r1kGhbeJsEQ/TO3QzT4WmJ/jNWWt+s/VtPJ3he6tU6hMtwBT/ttTo9p1+OchOLKM1R41qZDJRDg2SXob1AOJb+uk8N8A5Yc7cHNowr2G/IM04KXcBzbtXmnHMQzFxRiCUDkqsZ2uPgXNkJVwvzfbSlgCwiSqYB/qdPuv4h89erEQh/277l5M7uDVw05nJwal745xl82RbJpVSoSbNghe04C4XeGk/56G2eK6CLdqIuQHUAyBgq+u8uBlQUY/7Yck4vSXA1DrknT5cbSIVfoNCvTfjlcNunuOlLjRXM4ghp8p3Ckz40Fsf9jlwsLrdpXOvVxw1JwvBaaLcnFbiIrL9ZfVurLwiIHv2DWDLGcYyxqGBMRu/Rx6P7QS1M0eo6C3UphwuJMZ9IjSvqMmu1yeIY76/hFrO/VfERRmfjE
 i/lGIxCn
 +3fc6gzZgEulbrPKDFI+ykGF952vMLdgML2NYq4VcogmYGi2r2NBwAR1hjKD1+gbNi/k2DJUGUjjrU12ZEu9iClB3OLs1nmJet1/SktpcBYDXdVu9V86niqYVg28x9ediJlkbvIUuvX30SEtc2Ggua/pn46CX0jVT7ML1ETE+OVMhk+7xAsc/ILnK1i30fhHMq2mKvLGP7vPVeiqKfIIxwZDM/0//WU1h+RZPQZeKcLLJwnZyiZIHKs3B3SoSjLBHTxhp+Di+LgQBuUUK5PtQuUO3s3xM2yzgSzCbmJKqODkE0nw/uGr+b00TWHUPanA2DcR/D0icy3ut4QPr1LA+ZDNfTRJaixW6x4beZgRdjt5k0HV+tVuwHDCcD9imBq86CM20rMF1kUQrgV9gCmLUcZNtqCzQrgme9PQ/oRItfcj6mYmibUk1arizSa24Rz6oSlh4ugw/cViSEXMDR6RohrqnICfXg/QKzBEcdcg23epSs4NWT6HrrDtz+Uk1u5x9TyUwW2O9VD84GmOuCxKNDqIuETY2Q+/KwAfaQ/ZRei3XAyfesLoTUclXsQjFLOY8r6zyBASWLPJRAukWvOjCuFCsAJ61UsUVJ8Qw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FORCE_READ() converts input value x to its pointer type then reads from
address x. This is wrong. If x is a non-pointer, it would be caught it
easily. But all FORCE_READ() callers are trying to read from a pointer and
FORCE_READ() basically reads a pointer to a pointer instead of the original
typed pointer. Almost no access violation was found, except the one from
split_huge_page_test.

Fix it by implementing a simplified READ_ONCE() instead.

Fixes: 3f6bfd4789a0 ("selftests/mm: reuse FORCE_READ to replace "asm volatile("" : "+r" (XXX));"")
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
FORCE_READ() comes from commit 876320d71f51 ("selftests/mm: add self tests for
guard page feature"). I will a separate patch to stable tree.


 tools/testing/selftests/mm/cow.c                  | 4 ++--
 tools/testing/selftests/mm/guard-regions.c        | 2 +-
 tools/testing/selftests/mm/hugetlb-madvise.c      | 4 +++-
 tools/testing/selftests/mm/migration.c            | 2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c        | 2 +-
 tools/testing/selftests/mm/split_huge_page_test.c | 7 +++++--
 tools/testing/selftests/mm/vm_util.h              | 2 +-
 7 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index d30625c18259..c744c603d688 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1554,8 +1554,8 @@ static void run_with_zeropage(non_anon_test_fn fn, const char *desc)
 	}
 
 	/* Read from the page to populate the shared zeropage. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, pagesize);
 munmap:
diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index b0d42eb04e3a..8dd81c0a4a5a 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -145,7 +145,7 @@ static bool try_access_buf(char *ptr, bool write)
 		if (write)
 			*ptr = 'x';
 		else
-			FORCE_READ(ptr);
+			FORCE_READ(*ptr);
 	}
 
 	signal_jump_set = false;
diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 1afe14b9dc0c..c5940c0595be 100644
--- a/tools/testing/selftests/mm/hugetlb-madvise.c
+++ b/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -50,8 +50,10 @@ void read_fault_pages(void *addr, unsigned long nr_pages)
 	unsigned long i;
 
 	for (i = 0; i < nr_pages; i++) {
+		unsigned long *addr2 =
+			((unsigned long *)(addr + (i * huge_page_size)));
 		/* Prevent the compiler from optimizing out the entire loop: */
-		FORCE_READ(((unsigned long *)(addr + (i * huge_page_size))));
+		FORCE_READ(*addr2);
 	}
 }
 
diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index c5a73617796a..ea945eebec2f 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -110,7 +110,7 @@ void *access_mem(void *ptr)
 		 * the memory access actually happens and prevents the compiler
 		 * from optimizing away this entire loop.
 		 */
-		FORCE_READ((uint64_t *)ptr);
+		FORCE_READ(*(uint64_t *)ptr);
 	}
 
 	return NULL;
diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 0d4209eef0c3..e6face7c0166 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1525,7 +1525,7 @@ void zeropfn_tests(void)
 
 	ret = madvise(mem, hpage_size, MADV_HUGEPAGE);
 	if (!ret) {
-		FORCE_READ(mem);
+		FORCE_READ(*mem);
 
 		ret = pagemap_ioctl(mem, hpage_size, &vec, 1, 0,
 				    0, PAGE_IS_PFNZERO, 0, 0, PAGE_IS_PFNZERO);
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 718daceb5282..3c761228e451 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -440,8 +440,11 @@ int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size, int *fd,
 	}
 	madvise(*addr, fd_size, MADV_HUGEPAGE);
 
-	for (size_t i = 0; i < fd_size; i++)
-		FORCE_READ((*addr + i));
+	for (size_t i = 0; i < fd_size; i++) {
+		char *addr2 = *addr + i;
+
+		FORCE_READ(*addr2);
+	}
 
 	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) {
 		ksft_print_msg("No large pagecache folio generated, please provide a filesystem supporting large folio\n");
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index c20298ae98ea..b55d1809debc 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -23,7 +23,7 @@
  * anything with it in order to trigger a read page fault. We therefore must use
  * volatile to stop the compiler from optimising this away.
  */
-#define FORCE_READ(x) (*(volatile typeof(x) *)x)
+#define FORCE_READ(x) (*(const volatile typeof(x) *)&(x))
 
 extern unsigned int __page_size;
 extern unsigned int __page_shift;
-- 
2.47.2


