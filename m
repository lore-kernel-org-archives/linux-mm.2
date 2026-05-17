Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B00ECCD4F21
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 13:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258146B00AC; Sun, 17 May 2026 09:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22FFE6B00AD; Sun, 17 May 2026 09:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1241F6B00AE; Sun, 17 May 2026 09:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F395E6B00AC
	for <linux-mm@kvack.org>; Sun, 17 May 2026 09:59:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF823C2244
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:59:01 +0000 (UTC)
X-FDA: 84777068082.07.C5F83F7
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010007.outbound.protection.outlook.com [52.101.61.7])
	by imf13.hostedemail.com (Postfix) with ESMTP id EE00C20009
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:58:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=keMbdTLv;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779026339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Agorkw4TqSVe9ErEFhQLBC6nbb8pSlOdwD2rkhwPKl0=;
	b=k+u6drtnejeGNsKg6Ujkojs2DcLqwTLxZzpOLNgMmX44/JzE1WKanm5uzR6H5geVVBjt75
	HwSMmMt1e3qcl27o6NaFT/6dwpY5qMPPHQMQHedu3NkzDVG6LIoDqaYkOlAQ3VxVZjdZ5o
	aDXasQaE8jC77ybHKCX9AkHlL3rhd74=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=keMbdTLv;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779026339; a=rsa-sha256;
	cv=fail;
	b=jwmz3jDWpRJWvaoNBQaOzTf7PGkCF1UNbL2aP5eS5nhDxjB+QS5N4g5fj+CBBlTtV/T8df
	O+zV0TMbml4bwsNzFNx63+bjLq/fWQK/4owKFK2GCE9fL3dBjfjaDpbHnBuNCUbbglC9Ez
	CBKZuAYEC1cw8RwjDsj71ff1osYcqmw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P87y+pPS/Z4sbPgzW7ihUOS5XrXdqWw56BffgmljPI/by21ML8Tao4yBdp1zXtoDWLEtewvgG5GUjIlETz/Bxsb1JBz1AYgRed2XJeYrGAOesObI8+kYDPlXy2lY+ZxSnGHog9eux4f7T22SCE/3/AmEoZnZpGG/UqKrI4mvT8JwgI/xFLIf7jcqHRBK7pwPp1HqGn1B6aGcYAzKHCmFn7Vr/WiyczKx6bysZOilNZD/jCp14fjWdSz9nf1dk9SOdLwW2U5sT1tiFAOotMF5T4MIAit0Y6Nt6Zn/SDXwvAHdApqJ0E9IAszNzeDQFXXddE3PKQ1Chqpf1dXKD9jVZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Agorkw4TqSVe9ErEFhQLBC6nbb8pSlOdwD2rkhwPKl0=;
 b=QsbmIAGGN0jTIY90tPgRZb2eqTnrzdqO0ul91zGI9CBhF/jvTh0UbwktbBwFrj1GS1lUN1QzRYuRqsrOU1hgzUBUNq4Oaflhab3O/xcFGv+Xb/E5XMIxK2+7tAGPycK6TPp8jj03k9XHdJdxltKOsa7PvS40m7p7ihV3R5wszlvob4VSk/FLnDsEF8eO1qloFVcvp4BIltqj8648QU4e1CBG6TGdjHbA08vIk7cnxxe1fVqfBAFlm1lClnaqgClUT1Mw+Q2ylgeO9gwHhbYz0DM2ZJ4AEggTnKEHDB1WmHAjoBoyaZWwPI63UIQPzIkRcpElj6eCEcv8ceRJWVSpZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Agorkw4TqSVe9ErEFhQLBC6nbb8pSlOdwD2rkhwPKl0=;
 b=keMbdTLvo3ZF9C+IN1119tQsCz0KB3qpYG/hNl3QCw6uz7scC6xjSSA6ZEQDekXSC9hV5oms3eQqKlOi6vQ7ZHTYry7pzi7QFzItIJb5390HILlLSjeQFfyGqhhztz+9fiUo3P0ET3ZEnjI2HKeSMAc9rFuI+SJ5ehE5xQi2rpD+zkehY+AA/ogbJ++B0BbvWja0QN1SGlse1cls+q1IhKnXsoF3yE1dVRHMcJKED0sgV79oyakP0hRvVfph6glROQ/xa4UcdxQ0ClQdf7jIrmn7mLgGNzh/uF2HWs9Ignj/oTrVi8/j7f4oG0aBrMtn+h2qrev3sjci1wrB5LQk7Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:15 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:15 +0000
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
Subject: [PATCH v6 14/14] selftests/mm: add writable-file collapse tests for khugepaged
Date: Sun, 17 May 2026 09:54:16 -0400
Message-ID: <20260517135416.1434539-15-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0310.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: a941d7f9-fb5f-4d2e-0f95-08deb41bec50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	hkCUb9UPiUyA24KwniEcstG1OUYvoPuWKEZ+32VePNyWQM6r1q41IN7yKDHH8Vd7Pc62m0Q8oLh4YZJNaVhs0jXw7WcP+6dj7hWERuyFIB4X5tHWuNXS2W+TsPipobpW/+rZ6C7qPUKevHM/aM4SPfGx6hSOcMYC/ucL4mREAGl0fDi0V/HlhfwYx/u6lbVCBRNchkks8CzbSVawNnVQ2h7dXYU8aiyFXfGqAuFx0afJX7u9pgQP3ScT8jnzKyjD8iLs1OG+/O+362ITstqlTqewEGvFrOK9q6VZRcAK2pFETFAboYqmPFL+wLeOflE/ILQ1DWyCOOiMwtxWxcnoRutvgNtbz59x6Ik4g1Y0qbRZ7xqQuLPoSQe7n2zS9SOn2gpcCWryoxv170PPA+j7ggmUDkRDkIqfJ3M3w2Pk8rkfyDl+nB56VtJ25qGPJA0grNUSJft+hr8FrPijVzYNnXNxc0btmyfFQWhSXj/iVOffqDcuHfD0JxLqWodPFCYkC2J3l/eEY2mheJwzbVyC48nV5P95ofN53mOj2zru7vgAYSZVeenYbSJN8etGWFgUH6RnkBP5TaI8zJzYV2msz4byNu5OYvQvIbRNpZJlzHtci+61Kq9J5x7qJp2qFa66jGaQLexXtxSXmYDCYPdeeCD8kyL6We3Sk130MlTlgIQSDZoGizihzwVepyc8jBJw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?II4GJvoMF5RuW+nSHmxRQyuXhfGLgrL+caTuC+osChM9ksAh/3PROHbaM7E7?=
 =?us-ascii?Q?XAajSllrfdMTLMHPB5sXf/NJ9NWLkkLJyMtqfZrwcotR2QoHiUGwQXokNH3S?=
 =?us-ascii?Q?np616CpVQZrfyQ2+9QczxjEKHVBq/No70t+QC6kzE/UcAyIbXYc6O9vaVGXD?=
 =?us-ascii?Q?q18+MMwecgtaPB+4bxA3CxVW4jM8a1/eRoLG3DhWPJB8OE7sG7209U4TpSWL?=
 =?us-ascii?Q?nDUbFjShSXwwdW3JP2tYmC/xck18MAad++zlzDpXi7Vkf9kJ0z3ppaE6NyNn?=
 =?us-ascii?Q?lbEgIAirQzsGCwXU419eOLqW+cKmeuLGAyVQU76HlHBYfJlfPNwSqAbgNBQA?=
 =?us-ascii?Q?y9xgIDhfqLzE2KhfZeeiAjhgiqkIRMQGw/G4OZp7Zy1VmQYXphG4s/XKVrZo?=
 =?us-ascii?Q?pCIdjDwd6PiFigvUTYvz0XlRhLom7ph+psds1Uv2nMQb6HT3U3UwHoDAMWpF?=
 =?us-ascii?Q?NE18y1sI8bJB6IiyrBwAS46qgnUGtz2hkEVkjKRcqKO/kye5JmWvJgFHZccU?=
 =?us-ascii?Q?kkocWTH/TxEa8NBH/3uKHKdtI6g6eQO8Tjm9jceh7/ZwW57xtDL83EtYw7Hh?=
 =?us-ascii?Q?+ta9MBgoA87qWvyKFFJrEKbcUKmeuINWcPJT4hH4aop8W/se/MIJh10zJvdM?=
 =?us-ascii?Q?Izw8uFME1TB2jksORIVp8bx5cO+WYZcXIVL8yqoLbZiHrJUjStqe3zrOR9TK?=
 =?us-ascii?Q?ib04pFl/TNJ/kxXa2QggnaLMFpo+gYWM7bOZvT4VJ6PFeSzAfctwyc6abhQS?=
 =?us-ascii?Q?+8SHyW09Qun8mOWvm4Bx2Qt1st2Ekg9SGDr/D7LWFVyA8q/JWh9Z/y5RE3k+?=
 =?us-ascii?Q?diBfVqr2STO/PG8ql2uJQ0ygLoKunezqaHFTuEPsn2zfveBaPzB0ZCsNQ0TQ?=
 =?us-ascii?Q?rD6Plas7AvFjqkcn4YaHRkdpTWcrhHsUyzI0SD+OVYCxMLD3VZtAwJbLpkVY?=
 =?us-ascii?Q?O3Ivh/UfYYXx+keNcdnlU3zhtWFtijCXREoqYeaGmbPhOv0G/JgexictiAzU?=
 =?us-ascii?Q?3VzpPfhH/WZBRc9PWBePrHQjNTh5ndgUGYGXYdwIIg5/jX2UQrfJhqntQi0H?=
 =?us-ascii?Q?2XcVFDnl8G/0d1SDeUVgfcINPLHFkHa+C3wInZ1iRRNehPKzVpYJeCMeRIDk?=
 =?us-ascii?Q?ArokBCAFPDemM1dGBwgrbmL7zBJ3/zx2QGfcE4gEzT4CN6UV9+jXfUFYcQw8?=
 =?us-ascii?Q?pmIGJruS4isShHnw6eJ2heRsX1Wv7dNKWod8821xpVzwG7zJjSBnVJ9FnJeP?=
 =?us-ascii?Q?cN+rmjLzIgNa3/pRbXtIfXG9i5SNGAJPmvi00399P4qWWdK1IRRQHS0MJHFf?=
 =?us-ascii?Q?vleF1NrWBx3YBZz4ifgbAbuY5wAysfn4v/i7jTuVGKJppjE1WEckOOmOeMhr?=
 =?us-ascii?Q?3yJW79lOyrexTqNxs1+RIYdZwEq86T6HxdmARv0bOFGRkdCKSP0I2iXuV/KT?=
 =?us-ascii?Q?nJNY0B+4kr0p88q4LVt9nNVU7OuUh7ygl28SNfQZNRa+fmPq0n3kFUW+OTLS?=
 =?us-ascii?Q?4xhoodKIoM9pFlQM1FQG3X2+qwF3nRoCRk/8kuO0PQVqJhDtLfXFY7ayZkBQ?=
 =?us-ascii?Q?EsZ47J35u7241e2VR7vB+Zgo4lFTPTNxZ4JUVGx5V7iBI/Qw+pjxade7F7rT?=
 =?us-ascii?Q?A2qMM4d8qoxpIQk5qck+O7BTBdUSUH0Ghc6xv4yP3e1IGTf3zbSSGvmLL1U1?=
 =?us-ascii?Q?5kxJmVVJYp5/LeY5DRY6IM7XQeA1Lsa6iay9IXmlfQWF+BDz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a941d7f9-fb5f-4d2e-0f95-08deb41bec50
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:15.5828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XA505ki1VzjAox65WFNvFPyqNdJe31Txv82MaOaEhlxyNCOBnBmkAtIopje4jAIi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322
X-Stat-Signature: uru8w6eagpjoktngy7thn7atebuk3bbw
X-Rspamd-Queue-Id: EE00C20009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779026338-583828
X-HE-Meta: U2FsdGVkX18zJQ5A5RbW0UUrJIlWukXp9TovV9I02SffK1Eg6NMne8XBPItZqvD/ajOGjMuxIl3lxTGGegDBCZoQk21qr/HIu9h7OIJWvtZYeFrq4WoSuM2ccPtkRXiL4Mo2mOydqhI/7y8a6cOW3MNr3vD1i6fN5PwyCdH0Ct44T4g7LkTvPAhr2996EJhsbHFXrpgfYhlCvHvAQJ+LIRcE7RIJ+iC7TFF0EjSEK0UkliwBCec1y7v+uhGe9SzPGKEFxtEHs9pboGmS/WyZtGEeYkwHmX1ZhoRkdrA3nALBo0QY5aUF8Qyn+HLDLwu8VphXAGUzM7mlQV0CXTPOIgXMLLemiyUb73HWvPjoFNF5QnbAIMYAiavIa6JZW1dHIPWt/Y7vWo8Ojse47S+SHJPJacbFf5uHw+1k6Tsy12v4QjmMe4kgu/VQGIxXDRgr5za29r1HWLqglKSiDMdwL2OzXSB05d50vDxGSk0fjMQ+7njAca6c4Lz7Pgyepd2xTYj4ICKKHuXd7IbYuRDtBhPNViKN8dRfQwvW31yPeJoC2OhCbMubNIxnbydIrWAaYVH8+lkHbGbSkUn4HeuBpNFMv2WwPY+ZDQY8Y6cNJkqTvPyj+1SqU8ZLMFpdAcEPv1wTB8tKYaUwoJsPQAjBzu6/mtWh/35SeE5OnBj61yim6uj0tnpVw76kfUgPJOj19dnVzHv+UylL7joS/EaGybHcoADdD2DHx0zcL5rf2+b6WeCzbolpE1BPltspzmmN67dBhqAyiNuPZvrlCD/rJDPsA4YkIIuuc2ViqUfojyM5uS5PjNe7D6KOa6QPl+BmnHOhAvKSdiMGmu06oibJbAgUHxBLhtuXXZ++iUPq5yvindXbAPNbecRjTl12BsBl/0BE5RXKQmBBb8gEw8HAoRSj20OYuHYGw8p2l6k9h2B38suu/P3GnKgtJgT+nOjgz1EynPo4n9kviHKMAcZ
 O+vMFw38
 OBOGYTlgCDe3GaZxEvmndoaB4au9IKapDP4O4kdh00kOh6qSHxjQAV2MgzdvvayIXVhyTstf9uR3j6C/sMjARlyGlWbs6Lf+Hs9Oftw+LfIp8arC/DJ6SSJYRhuIorFSqwNLvdDcSgpIwVGCu+24SYq33n4O7YNv43X0kSx3Urkk41UoN036ixoQawJA2533+amdrlX4bkq5vn0GnRBqyJZ8Xi1hPpYBk2TL1zKxQkNT62+F6ppchcYS1XLsBQIVBA/nnWqKliHEJ8oLFHpoI21fx9lGsUrw/uNQNW1AQCZOrWskuoWAEno7pIesgztAr5NGb7+++kGkXznKP/foQQ49s05gSPpZASZOQwpHSTQBAkfyWzviPuhsUMJolcRaAyWX6ekZCUCjqTjIrNzFNDdOjhHDHfYG748DsPTPYXo5FvUXrNya9NUWaL7lyU8VP2mvRurtnTUFJVKySyXkaZluXQB4BmC5RmOrIw55E72Jytms9fpYL2iOYIYUd8XY1XxS4FoOqH2Dwpq8EAFZdHlTWALcN/4x+7f3d4al8QYB48m6OongFuPhp5grt4i7brixs+fWbF/ykLo+GE8Xuio/nwAro5kOKVkdesKqhid/GEit3lFlQ7zsud6cX7PN7cC3wCnJlftqkfJsG9vCpRvkUL6CZqswPu5cYfFX+4BdoGLtahXJjeenFitHM8OT7LzW5ewxkUWHymCRksXGJ7+bLlkd5wAP7Iqc8jjkBGzIgIw43gM/jS37YCGaVsyGWk6nngi1UO0eXWmg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_file() now supports collapsing clean pagecache folios from
writable files, so add corresponding tests.

Note that madvise(MADV_COLLAPSE) works for dirty pagecache folios from
writable files, because collapse_single_pmd() triggers a synchronous
writeback when first attempt of collapse_file() fails.  That writeback
makes dirty folios clean and the retry of collapse_file() succeeds.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 111 ++++++++++++++++++------
 1 file changed, 85 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 7ee6dfe93b3d9..9ce0a11b461df 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -41,6 +41,12 @@ enum vma_type {
 	VMA_SHMEM,
 };
 
+enum file_setup_ops {
+	FILE_SETUP_READ_ONLY_FS,
+	FILE_SETUP_READ_WRITE_FS_READ_DATA,
+	FILE_SETUP_READ_WRITE_FS_WRITE_DATA,
+};
+
 struct mem_ops {
 	void *(*setup_area)(int nr_hpages);
 	void (*cleanup_area)(void *p, unsigned long size);
@@ -50,7 +56,8 @@ struct mem_ops {
 };
 
 static struct mem_ops *read_only_file_ops;
-static struct mem_ops *read_write_file_ops;
+static struct mem_ops *read_write_file_read_ops;
+static struct mem_ops *read_write_file_write_ops;
 static struct mem_ops *anon_ops;
 static struct mem_ops *shmem_ops;
 
@@ -113,7 +120,8 @@ static void restore_settings(int sig)
 static void save_settings(void)
 {
 	printf("Save THP and khugepaged settings...");
-	if ((read_only_file_ops || read_write_file_ops) &&
+	if ((read_only_file_ops || read_write_file_read_ops ||
+	     read_write_file_write_ops) &&
 	    finfo.type == VMA_FILE)
 		thp_set_read_ahead_path(finfo.dev_queue_read_ahead_path);
 	thp_save_settings();
@@ -366,10 +374,10 @@ static bool anon_check_huge(void *addr, int nr_hpages)
 	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
 }
 
-static void *file_setup_area_common(int nr_hpages, bool read_only)
+static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
 {
-	const int open_opt = read_only ? O_RDONLY : O_RDWR;
-	const int mmap_prot = read_only ? PROT_READ : (PROT_READ | PROT_WRITE);
+	const int open_opt = setup == FILE_SETUP_READ_ONLY_FS ? O_RDONLY : O_RDWR;
+	const int mmap_prot = setup == FILE_SETUP_READ_ONLY_FS ? PROT_READ : (PROT_READ | PROT_WRITE);
 	int fd;
 	void *p;
 	unsigned long size;
@@ -405,7 +413,10 @@ static void *file_setup_area_common(int nr_hpages, bool read_only)
 	success("OK");
 
 	printf("Opening %s %s for collapse...", finfo.path,
-	       read_only ? "read-only" : "read-write");
+	       setup == FILE_SETUP_READ_ONLY_FS ? "read-only" :
+	       setup == FILE_SETUP_READ_WRITE_FS_READ_DATA ?
+						  "read-write (read)" :
+						  "read-write (write)");
 	finfo.fd = open(finfo.path, open_opt, 777);
 	if (finfo.fd < 0) {
 		perror("open()");
@@ -425,12 +436,17 @@ static void *file_setup_area_common(int nr_hpages, bool read_only)
 
 static void *file_setup_read_only_area(int nr_hpages)
 {
-	return file_setup_area_common(nr_hpages, /* read_only= */ true);
+	return file_setup_area_common(nr_hpages, FILE_SETUP_READ_ONLY_FS);
+}
+
+static void *file_setup_read_write_fs_read_area(int nr_hpages)
+{
+	return file_setup_area_common(nr_hpages, FILE_SETUP_READ_WRITE_FS_READ_DATA);
 }
 
-static void *file_setup_read_write_area(int nr_hpages)
+static void *file_setup_read_write_fs_write_area(int nr_hpages)
 {
-	return file_setup_area_common(nr_hpages, /* read_only= */ false);
+	return file_setup_area_common(nr_hpages, FILE_SETUP_READ_WRITE_FS_WRITE_DATA);
 }
 
 static void file_cleanup_area(void *p, unsigned long size)
@@ -448,6 +464,16 @@ static void file_fault_read(void *p, unsigned long start, unsigned long end)
 	}
 }
 
+static void file_fault_read_and_flush(void *p, unsigned long start, unsigned long end)
+{
+	file_fault_read(p, start, end);
+	/*
+	 * make folio clean, since dirty folios from read&write file are
+	 * rejected and not flushed
+	 */
+	msync((char *)p + start, end - start, MS_SYNC);
+}
+
 static void file_fault_write(void *p, unsigned long start, unsigned long end)
 {
 	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_WRITE)) {
@@ -519,8 +545,16 @@ static struct mem_ops __read_only_file_ops = {
 	.name = "file",
 };
 
-static struct mem_ops __read_write_file_ops = {
-	.setup_area = &file_setup_read_write_area,
+static struct mem_ops __read_write_file_read_ops = {
+	.setup_area = &file_setup_read_write_fs_read_area,
+	.cleanup_area = &file_cleanup_area,
+	.fault = &file_fault_read_and_flush,
+	.check_huge = &file_check_huge,
+	.name = "file",
+};
+
+static struct mem_ops __read_write_file_write_ops = {
+	.setup_area = &file_setup_read_write_fs_write_area,
 	.cleanup_area = &file_cleanup_area,
 	.fault = &file_fault_write,
 	.check_huge = &file_check_huge,
@@ -537,7 +571,9 @@ static struct mem_ops __shmem_ops = {
 
 static bool is_tmpfs(struct mem_ops *ops)
 {
-	return (ops == &__read_only_file_ops || ops == &__read_write_file_ops) &&
+	return (ops == &__read_only_file_ops ||
+		ops == &__read_write_file_read_ops ||
+		ops == &__read_write_file_write_ops) &&
 	       finfo.type == VMA_SHMEM;
 }
 
@@ -554,9 +590,11 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 
 	printf("%s...", msg);
 
-	/* read&write file collapse always fail */
-	if (!is_tmpfs(ops) && ops == &__read_write_file_ops)
-		expect = false;
+	/*
+	 * read&write file collapse succeeds for MADV_COLLAPSE because dirty
+	 * folios are written back after collapse fails for dirty folios and
+	 * another collapse is attempted.
+	 */
 
 	/*
 	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
@@ -624,8 +662,11 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
 static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
 				struct mem_ops *ops, bool expect)
 {
-	/* read&write file collapse always fail */
-	if (!is_tmpfs(ops) && ops == &__read_write_file_ops)
+	/*
+	 * read&write file collapse fails since khugepaged does not flush
+	 * the target dirty folios
+	 */
+	if (!is_tmpfs(ops) && ops == &__read_write_file_write_ops)
 		expect = false;
 
 	if (wait_for_scan(msg, p, nr_hpages, ops)) {
@@ -748,6 +789,9 @@ static void collapse_max_ptes_none(struct collapse_context *c, struct mem_ops *o
 	validate_memory(p, 0, (hpage_pmd_nr - max_ptes_none - fault_nr_pages) * page_size);
 
 	if (c->enforce_pte_scan_limits) {
+		ops->cleanup_area(p, hpage_pmd_size);
+		p = ops->setup_area(1);
+
 		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_none) * page_size);
 		c->collapse("Collapse with max_ptes_none PTEs empty", p, 1, ops,
 			    true);
@@ -1195,21 +1239,24 @@ static void parse_test_type(int argc, char **argv)
 
 	if (!strcmp(buf, "all")) {
 		read_only_file_ops =  &__read_only_file_ops;
-		read_write_file_ops =  &__read_write_file_ops;
+		read_write_file_read_ops =  &__read_write_file_read_ops;
+		read_write_file_write_ops =  &__read_write_file_write_ops;
 		anon_ops = &__anon_ops;
 		shmem_ops = &__shmem_ops;
 	} else if (!strcmp(buf, "anon")) {
 		anon_ops = &__anon_ops;
 	} else if (!strcmp(buf, "file")) {
 		read_only_file_ops =  &__read_only_file_ops;
-		read_write_file_ops =  &__read_write_file_ops;
+		read_write_file_read_ops =  &__read_write_file_read_ops;
+		read_write_file_write_ops =  &__read_write_file_write_ops;
 	} else if (!strcmp(buf, "shmem")) {
 		shmem_ops = &__shmem_ops;
 	} else {
 		usage();
 	}
 
-	if (!read_only_file_ops && !read_write_file_ops)
+	if (!read_only_file_ops && !read_write_file_read_ops &&
+	    !read_write_file_write_ops)
 		return;
 
 	if (argc != 2)
@@ -1282,11 +1329,13 @@ int main(int argc, char **argv)
 
 	TEST(collapse_full, khugepaged_context, anon_ops);
 	TEST(collapse_full, khugepaged_context, read_only_file_ops);
-	TEST(collapse_full, khugepaged_context, read_write_file_ops);
+	TEST(collapse_full, khugepaged_context, read_write_file_read_ops);
+	TEST(collapse_full, khugepaged_context, read_write_file_write_ops);
 	TEST(collapse_full, khugepaged_context, shmem_ops);
 	TEST(collapse_full, madvise_context, anon_ops);
 	TEST(collapse_full, madvise_context, read_only_file_ops);
-	TEST(collapse_full, madvise_context, read_write_file_ops);
+	TEST(collapse_full, madvise_context, read_write_file_read_ops);
+	TEST(collapse_full, madvise_context, read_write_file_write_ops);
 	TEST(collapse_full, madvise_context, shmem_ops);
 
 	TEST(collapse_empty, khugepaged_context, anon_ops);
@@ -1294,30 +1343,38 @@ int main(int argc, char **argv)
 
 	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
-	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_ops);
+	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_read_ops);
+	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_write_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, shmem_ops);
 	TEST(collapse_single_pte_entry, madvise_context, anon_ops);
 	TEST(collapse_single_pte_entry, madvise_context, read_only_file_ops);
-	TEST(collapse_single_pte_entry, madvise_context, read_write_file_ops);
+	TEST(collapse_single_pte_entry, madvise_context, read_write_file_read_ops);
+	TEST(collapse_single_pte_entry, madvise_context, read_write_file_write_ops);
 	TEST(collapse_single_pte_entry, madvise_context, shmem_ops);
 
 	TEST(collapse_max_ptes_none, khugepaged_context, anon_ops);
 	TEST(collapse_max_ptes_none, khugepaged_context, read_only_file_ops);
-	TEST(collapse_max_ptes_none, khugepaged_context, read_write_file_ops);
+	TEST(collapse_max_ptes_none, khugepaged_context, read_write_file_read_ops);
+	TEST(collapse_max_ptes_none, khugepaged_context, read_write_file_write_ops);
 	TEST(collapse_max_ptes_none, madvise_context, anon_ops);
 	TEST(collapse_max_ptes_none, madvise_context, read_only_file_ops);
-	TEST(collapse_max_ptes_none, madvise_context, read_write_file_ops);
+	TEST(collapse_max_ptes_none, madvise_context, read_write_file_read_ops);
+	TEST(collapse_max_ptes_none, madvise_context, read_write_file_write_ops);
 
 	TEST(collapse_single_pte_entry_compound, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry_compound, khugepaged_context, read_only_file_ops);
+	TEST(collapse_single_pte_entry_compound, khugepaged_context, read_write_file_read_ops);
 	TEST(collapse_single_pte_entry_compound, madvise_context, anon_ops);
 	TEST(collapse_single_pte_entry_compound, madvise_context, read_only_file_ops);
+	TEST(collapse_single_pte_entry_compound, madvise_context, read_write_file_read_ops);
 
 	TEST(collapse_full_of_compound, khugepaged_context, anon_ops);
 	TEST(collapse_full_of_compound, khugepaged_context, read_only_file_ops);
+	TEST(collapse_full_of_compound, khugepaged_context, read_write_file_read_ops);
 	TEST(collapse_full_of_compound, khugepaged_context, shmem_ops);
 	TEST(collapse_full_of_compound, madvise_context, anon_ops);
 	TEST(collapse_full_of_compound, madvise_context, read_only_file_ops);
+	TEST(collapse_full_of_compound, madvise_context, read_write_file_read_ops);
 	TEST(collapse_full_of_compound, madvise_context, shmem_ops);
 
 	TEST(collapse_compound_extreme, khugepaged_context, anon_ops);
@@ -1340,9 +1397,11 @@ int main(int argc, char **argv)
 
 	TEST(madvise_collapse_existing_thps, madvise_context, anon_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, read_only_file_ops);
+	TEST(madvise_collapse_existing_thps, madvise_context, read_write_file_read_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, shmem_ops);
 
 	TEST(madvise_retracted_page_tables, madvise_context, read_only_file_ops);
+	TEST(madvise_retracted_page_tables, madvise_context, read_write_file_read_ops);
 	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
 
 	restore_settings(0);
-- 
2.53.0


