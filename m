Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56FFFF531C7
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4CCF6B00AE; Mon, 13 Apr 2026 15:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25076B00B1; Mon, 13 Apr 2026 15:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14876B00B2; Mon, 13 Apr 2026 15:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A11B46B00AE
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:20:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2489B8B0C7
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:20:59 +0000 (UTC)
X-FDA: 84654500238.29.F74303F
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012041.outbound.protection.outlook.com [52.101.48.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0F4DC40015
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:20:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Bng+NzvM;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Bng+NzvM;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776108056; a=rsa-sha256;
	cv=pass;
	b=uJ7EbHhOYGlOlM2y75G1B6fGE5W7UF8v2kn75ZotuKxWsz7LaSbc8gOVP8sX0tDpW3O2aO
	/C2tY6QYzQC4HIoZtfntHDg96Ojrrysy6tbvULHKB+zKVbd7vS0HOqTGgjhXlaL0KoiTLG
	hC3vGYUV5Srr893nqoXQgpNiKHbkLAc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776108056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NejS8Z1t6Y+7zgrdIe4+MUiS+w3T7QiEI133vyKg5EM=;
	b=Z7kxqCnXHIosWn+waTsWixqFYt37e6WDgL+U233rKk8sIlsPQpz4tLqnbZN2lSDO6jVGCS
	hl4esbXC2oTI2s/P1bFBKIPr4xazeL07dzQm3w9ECGMO3m7htBrloqt0V4V6PKD8qQ2Qh8
	rnbImTpDDFQhsIkGoEc6O3MV4wfu1fU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HtUrOGp9TkAR8jbf49uhTKY62Y7ywnhQUAA8p3ruUoZV0FNMH5Ob2cNDP5wBAL0u9ckktPJvgpwACmWMhJfjfYpba4dpSidLOYwoc+4MWbKnDO02f3uC8SBZ3qt8W90r8Vv3Eizl3eotvBDJI4anl++QTSyGBE5+MBFxVsYOC/wlzVBW2ZHGq6bXIXQXzss9+DCesMQbTqJDK2RJ9iCAK4WN0/BS3UMKJtMTZkZMsnuOs0VP94wG9LhDxULuu/YLUtX/D3H3EWg6aHyJLyaqlWQciscpzl+hFCwTZRp2rWvbTdA0js4a8UwcZ7/X97c5549L3BQRb/0CRbxrXrfB/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NejS8Z1t6Y+7zgrdIe4+MUiS+w3T7QiEI133vyKg5EM=;
 b=a0VPjtlj/u4yD+o8fEXrbJ3+8MNXHntWqLo1hdnN0ShFPZpACzEb+f/gAI7ahf83Gtj07QEezPiPWRYD7hJ3By+WKhweoUOWax5RANjo4abyUFzLABuGLNz9rL0NyRVf/hNsLGKKVbXMUNU0MogDc7BkUHs+letpGZ5AXYc3aJi0X0tpdsCqrLpNxCn9AKqNJ/QkXKAMQA+Y2dt8TFcXJ8swvoR8cO3M6V152hocpGLC88FkFtko6l+OZfHwJdxbvTWwv4kOllOgDs8ym2xZBp2XJKQrwMC3Qw2DZWnWukL0I/a9E1I8un2cOvuhiT9r+/GBD/i4Vib/QT8prA3Xtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NejS8Z1t6Y+7zgrdIe4+MUiS+w3T7QiEI133vyKg5EM=;
 b=Bng+NzvM+lXEmrxAl1fAjM3uX1YCqdGCki+r1l3maKO0qRj0i5LtknfNL2xHvqEA9lOfsv+Z/xrUzNo8K4p/dPp8dN7ZO3ASMZwsKFcnfMvP7p4tJQdmfkxt2av+b7DifC3aYL+CefqQeFTXlsVQEHV0GnxgDDL6W4kkLQMJ5mJJgh0nuCE//Dh7EUhqQSxYWUQu+xGZA6pfxDcDdZs2GSxwXP0/8tL36aSKas8K9INT7kDRPUNyvMeRMmP0AYj6zujYRmgGTzRhwV3JFPWia2S8Q1Sj3t+ahB4h4z4fOxTfaGum62DsuvOolXZJZbG90TQOMCkBRjR0QxDfUuOBzw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Mon, 13 Apr 2026 19:20:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
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
Subject: [PATCH 7.2 v2 02/12] mm/khugepaged: add folio dirty check after try_to_unmap_flush()
Date: Mon, 13 Apr 2026 15:20:20 -0400
Message-ID: <20260413192030.3275825-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0053.namprd20.prod.outlook.com
 (2603:10b6:208:235::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cc6e3b1-42bf-4c68-7c6e-08de9991c0fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	/JMYe/d9coFEAMupAhJIgy+huvYYKY5qE2JYpRcnU8Oku5beCqr261CAav6r51nvg3mNdOAPoODnI9wiJiNhPUUv/O+4XG49yBuQTTA071DNh15jwgyghgkOCDEN5tS161iFb+xLz3fFrlvFpDsGUVzK8Vi7stKs/aYycwAAEsPH9SCESjaW9pkBmSwxto65GRLqd24NcWsDxPg4O2Vb6hUhDht7npBYGBcUa8VkIFsFwl3hcmxuRyhL2KyFPYn8teshPibex+Ol13jh38oUMCOaAvoXQEFTaWyQ5vCeMjxVMkOONG4+m/nta7LSrT8p453MOYPuB0nX4ZyaeIgzViQ40KHsKGDSiZpTcCV4tq7/Wb173Mya9KGlvR52hsFRIPtB1cdtvXy55hBGQBw4kiDcp+ZbEidPP47IK2TthztT598SRrlWlefKZMA90Jx8/IuD1gv8Xt+AcMUMmpyRspDvBYgHbPQhEuy5BH5SJ61AV3u1AAP4SK6NGOogo7JIfm4tHApUASaXUBgNNOQjWRzH+uYPInlETzLu97y62N6By+IlfPDccoSwU+UoZ2cFFCOU2QX5KzPbEHhDeE8AcBGBhCttjzG2+/8tljyx25VkazcmWXsggsaXIYYvsF7yjgZjQTWxceYUScR4rV6J9p86gKvoPWDcCBIEb/COtcBF0XA75pIJfRZ9TgpjZa9nlEku2ytOmc1w8O1LfvIk/LZ3F4hhNRrJ5N8Z8szm2MQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E0eH109nffSXRUXcwhoshmpovR0dUEA5tTstMVfZFXNw4+4aLNIyn3L1jeaA?=
 =?us-ascii?Q?iF43UPsaz/LbzTOwL4RS7z6WpZgUowQpL6TfLa10dtGJadzpMEcf9iCqG7z6?=
 =?us-ascii?Q?2RcF2R43x1qIZDXtURItj50CKU5z3zK8GALLI8R1TPe/AFWGumvdcxgraX9t?=
 =?us-ascii?Q?DZ9LI+PP0ycrNB+nhr49NdihUmRuMLRe8mHzYTkYtrOmjRSqitKuEhn7P7s9?=
 =?us-ascii?Q?B9ThFYBmPfpcNyiXQFZTEppFOIJCWEjcCXPzYVLVlEj1dMMzhASDOodnvmIH?=
 =?us-ascii?Q?3T7MldL8Bc/2EP4MaIEg2yetQRxLVFG45ftHt50GqrH7cuHxET3llPcvvdov?=
 =?us-ascii?Q?MrDBNtJ8eR6zUT644Y3quBYxQS22XVnxx1JIVqI1CAhHLBlNOvzXWoAODmhX?=
 =?us-ascii?Q?uy0kG+9lv7WZYHQQgBHuQcgHOzzlhj0FS30NIHDn4Af9M6wpZqQGOGiqXLIG?=
 =?us-ascii?Q?ErFtyBAlggaBfH2RQkx6AwXezjWXwBrW4kdaYAwOHG1vv6GLWrEBf3cTtLLT?=
 =?us-ascii?Q?22pg3fxUdWnB+q0WMduSkpRCNu/ej2y0LIW9O4XG9gdENY96B3Az7r+Y+MnN?=
 =?us-ascii?Q?G0DW3ACWX3r7dRpEdeTAZgudxljZrH/eluNWZ41bOAmkScggUNzJ/x6O1Wnc?=
 =?us-ascii?Q?2br8XMwFr6lPStiO2j/MoS6otnRRSFLIPdTrGvUaKCo8jOqZlk2tjfQdGFss?=
 =?us-ascii?Q?iqrUJOWjb3hGuiyslqQ7HjbHzRu1F5RMwR4bDmKicZ7K7YY58kYBy3LR4GIY?=
 =?us-ascii?Q?ITmeqXif29qpHaUthjur8/47HSaHFuRRquFyHok7uaYuxtw7hLAB3Xw5lQlB?=
 =?us-ascii?Q?TbF2WwX7I7Di3TfaLSqvhs8kiTgFA8xZzoDaKCzjz3PnQzjpQPBemAeRN+15?=
 =?us-ascii?Q?0Z8yqn/L7tzD83tL27Os9UXqZptXth+mRp3aGCdC7Ilf/JJwju3sKIHMqe9u?=
 =?us-ascii?Q?fuXmdDFFWz1ubD2skWsjbcm6QExQdMyKpEJXi6NLWcLCO+H0QLMx90KPeAWR?=
 =?us-ascii?Q?dYalBlQgWOa62ff1mRYGGxfnnqVjLj0YqsSV7+M1K4b47YIKc4VOPqMDY88s?=
 =?us-ascii?Q?9M1wa+/61z0/OJ3xGPnnKNN+SdkL5UEqaYLIAbgiyqigrmBwx2mkGT6+moV0?=
 =?us-ascii?Q?2X6rQ0vIB/8uUwld+9hX0URTvad0pdrZWz94y6JNtzoIYgxouRBoa+hjbZB3?=
 =?us-ascii?Q?aXwSIhV74zfJlTdKpa1ikF5BetH5uf6+sGmUlVIp3GxTFttBao1tSTgIk0QJ?=
 =?us-ascii?Q?LgHJ5aTuoFTCY0l/kP8UVinPHliajv6PYrOoaXEe5pS9l0FU6WnA3u1WceX1?=
 =?us-ascii?Q?g5jcHsb/4JipkLWH03makkgIqs+xN2OruUddz0qIumnqcnMxBrmx5q4PBE7L?=
 =?us-ascii?Q?bmXpkYJGaqL3RZf75PWE5FR+gDMkwJlLlKGDJtQF8FQru7nsb/5AzMfCPcED?=
 =?us-ascii?Q?0U+iAp5Qa2boi7KGXSAqMwDZVTs1xRuR3pb3hV8Kr9BXfDuLVZ6PkXhuA4gz?=
 =?us-ascii?Q?dPrKT7aFXQdYcI/as3Sanpp9X3IDzfCJU6L/ByaGSzfVBTpEhV6SKKp73hLo?=
 =?us-ascii?Q?pNGWPk2Wlf0ElgSLRlE2EjlslgDcmsB0jM0R5eBHD+gMPplpkz13l6jTKpD9?=
 =?us-ascii?Q?KMp/L3EBqQagkW7cbqrKpkOEzJoVjNnEv987oalv6mz9zop4iLD4cMaFkIqg?=
 =?us-ascii?Q?QGKEQewK3o+lvXNI6n6lPCxEwbSC5T3vjMKjXcz7rmwIzayM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cc6e3b1-42bf-4c68-7c6e-08de9991c0fb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:42.1475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ugPUB+427UJ3LZSt8uERTHGOA3ZtyokutYUvNgNe/csoZzqY6Ujn6ozK7YKoeUtt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0F4DC40015
X-Stat-Signature: etj9s8daaujgbbuuu9xmirf65pf6nhat
X-Rspam-User: 
X-HE-Tag: 1776108055-976900
X-HE-Meta: U2FsdGVkX1+QVvYKsz2lg2k9tnOTP8vRj8vAF9nzRWcBuVsL/SumR9XZOQKKpS2m5M6BcnS3l1Utvy708joZHLvEwCQKDAac3xnQv1UhR7lghWW4KlVpEf+we87IVGQy+RVQbEoYdGyxtHaTiE81Qt8TzmgsnCfZ0EjoCsKzN3f4CSsMEHTpBTZ00EE8raUsaq7ABdPoSK13ALX4OEeSBZVZD8t/AJSwcANSGWM+pKD6+/lEPx183SbZq1XpRePpJ7yTcRFIwysi/wu2zCG62dEl8Z3cyDcGvVAyCCvzwD2zJ21CaQkuegy1xITfMK32odJ6vrR+TC5rcvv8vJV2I+Jzr8s6/0gLd0G2fd5KX/uc19AmqsUGcNCSFMKFHBBaIwuwTb1PWgxpzCKN8l7MJF3r5346I30ss5QRG41LdSMKIVDvwTlEc8g1E3mBw8ulPF4ovre0WMhZOAtdoEIrVKbDdN5vkpL6kp2j39PkJoOrEnUB/rkHQ1WpjzxBQYxH18E2iwpz/BQ8Y70fz/Y7cOaTWzpJ4eKJ0/2Y+QUckUTZbvE0Tp9KLTJZ6NTOguIkquMxDYWz1qECgw7OGg3ZaQK7sAf8lZfDon1oSq3u0exnMMH+TJ/Jy5qI4fW5O73StBsidnso5Z7bOLlEHL/t0KX4A2SVPYEsEJd6U8fDso1EC32qBjS/Orlg8RjrJ5DTIwm87Utx4h57Y8FxVfMhi8qp77ITNgOK81POfI/Xn7AHDTjfnDT1ti2YjMMZKT0mT0AG9b9VGqZz91h2aRf5lvDjlX6IBnVboxsrjESXncEK8G9JwQkcxYNBjKtgD41aaAZ3AH2cCGbegdumSM9aivDSZTjlMrFQMOAt9tj0B2lh4i1wTd5RxZW6qVNKvOUtlxceSp0PfNAeeRYti+a2OYZ/tX7d3GvhjnaWv2SjXkSyR5++zWh6h+1M4jdJheL0zI+NpkYKKihnq2Qlox6
 DZfjVx6X
 zp0WZ10Dw1D/AGD9QNTFRicAYvtIoJy+cnejtkZK+zKLRflFoOLgLjeG64ywVN7xn23vvDqmFbpkYa++lXAXT4yXf8NcJ9jJ+hHIA3HsNmRc5rdhzXEBSJXPtwZRLqqXHv9tY05wJvlgR7E0HhQBWWpGAaCMukjInVGxhTIC0F57ZFuqZIXSyEf0NeCcrmVp22Rj+8BxxoJFXNHt4KRIgKkcoW2TemNX5P8evY6FlJqFD6mfKZpW49csVu8pb3RjpxyV+xJN+7mELkV4qxfygfOhdQ1ILHSLUv0a1/0I4iZCgzjYqnRJxAa0PvrKkv5C6nO4vLCIbDzVsJUH8dU6evF7mFgLy8F0dXe5ywwYMu5sXpE8cyQbjtcfhn/OIcZdJKnamUenvryVHdHv9c2WaUQSNQVBt0m9j/Gz3KwHf0zLU18kYhfAxjoVfKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This check ensures the correctness of collapse read-only THPs for FSes
after READ_ONLY_THP_FOR_FS is enabled by default for all FSes supporting
PMD THP pagecache.

READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
and inode->i_writecount to prevent any write to read-only to-be-collapsed
folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
aforementioned mechanism will go away too. To ensure khugepaged functions
as expected after the changes, rollback if any folio is dirty after
try_to_unmap_flush() to , since a dirty folio means this read-only folio
got some writes via mmap can happen between try_to_unmap() and
try_to_unmap_flush() via cached TLB entries and khugepaged does not support
collapse writable pagecache folios.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/khugepaged.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d2f0acd2dac2..ec609e53082e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2121,6 +2121,24 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	 */
 	try_to_unmap_flush();
 
+	/*
+	 * At this point, all folios are locked, unmapped, and all cached
+	 * mappings in TLBs are flushed. No one else is able to write to these
+	 * folios, since
+	 * 1. writes via FS ops require folio locks (see write_begin_get_folio());
+	 * 2. writes via mmap require taking a fault and locking folio locks.
+	 *
+	 * khugepaged only works for read-only fd, make sure all folios are
+	 * clean, since writes via mmap can happen between try_to_unmap() and
+	 * try_to_unmap_flush() via cached TLB entries.
+	 */
+	list_for_each_entry(folio, &pagelist, lru) {
+		if (!is_shmem && (folio_test_dirty(folio))) {
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+			goto rollback;
+		}
+	}
+
 	if (result == SCAN_SUCCEED && nr_none &&
 	    !shmem_charge(mapping->host, nr_none))
 		result = SCAN_FAIL;
-- 
2.43.0


