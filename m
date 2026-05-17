Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71BE8CD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 13:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9E026B00A2; Sun, 17 May 2026 09:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4EBF6B00A4; Sun, 17 May 2026 09:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3D7B6B00A5; Sun, 17 May 2026 09:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0AAD6B00A2
	for <linux-mm@kvack.org>; Sun, 17 May 2026 09:55:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7CF7A1404A5
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:55:56 +0000 (UTC)
X-FDA: 84777060312.12.3FC857F
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011014.outbound.protection.outlook.com [52.101.62.14])
	by imf17.hostedemail.com (Postfix) with ESMTP id ABB204000A
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:55:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dKCAVhiS;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779026153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSCnRMd4FcVrYz2vCXmH2+9aD3NPH3q9GjbPARil0mo=;
	b=btb190+s2Dixz4/+Irq6+/z7QSmwB6VEVCrLM7LDeQ+ob2u9kKTj5tm0kxNigcMgF7YitV
	nXEHtiMLkp3vvjqZX+iEP06cIhDJuBEB79M37NY1Ipg2a9LJYyFa3KRBw0FC2B5B+Jk7qT
	1gbZDIjGJTuWcQOBD8m0qNAIvMPwAdg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779026153; a=rsa-sha256;
	cv=fail;
	b=F4pgTpdTe5AyZsZN3dIJKo8bRfr/kmxk1Ss6AZ6QSrV6BL1UUk7WgqGr/40f+/Y8CuH8pG
	xkHgYMBhU9k3AikFeWYgM6r5yFLUkoe7JuDDjdmhPhJt/A/rT2Wx1pUqQIjdNmdm3RFl8A
	5PulnbBLDTwmVzHpYQCDselq92fqKIo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dKCAVhiS;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZY6a6iZpbPl2uFyNpgydO68oMXMBBuxdaEsm5tp9/N2VtTwZxXnIKS5Gxh71YQVGZ1EjE8IhPHxwrfOVFHnGUHr/w+s7uw7RY7XSI62apSvyk5Ku/rNJyMlgZPvMB4n5xZYn8P2YiV/1FRFWIqR3MQTpjlBbQ9DDU4C00QvmjZcKXitsWL5Wzrlx8pzLLupG13f64PO6cw7r9k+OTSYdVjfa3H1o0FTrISQl7Oz+inLBqZfDGqDsjWWM4ev6KEn4KU3/RgjxAAYUBW7eXwWZOKzOtj0OcTvMPL77jchLDQOOW4vYB1hvxgpdijOUI4Sf2J4tenOHQJbb8aerLq4Z3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vSCnRMd4FcVrYz2vCXmH2+9aD3NPH3q9GjbPARil0mo=;
 b=hQ5hG6sp5d1DttCdQFO3Ez/YcMagVZnsoHNWbDY8KzL0/U2akPnkI78LwVr99VJDTa3EHOAQsmLYbQBdZ775OUxCVjt9DAcgTy/UpTcd3ugl08FJsGex9s7zfujgX0o9RkKVXYwlQx+Zyr9lajPrPuWpWJ3gombIurLKOYe176j+ozTcl4s7IBsPa3HAZpUBJTnve0uCukhal/C5mKhPsDr0BYD8IGuXIugJTZWQPOlaCMU09W9djzqfLjERR9q6CZ/J8t85NTaumsa+z0/6POFGNAm+d4owUEEFy6FmSVzJCx9mXeVrlervF5Wh2Hfv5cQfpmrkaYx9VJKYmH6tHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSCnRMd4FcVrYz2vCXmH2+9aD3NPH3q9GjbPARil0mo=;
 b=dKCAVhiSwmPjNz7RI/0A16DM2BcZBSEI+JDSrUPqcBeEelOuf1VXKYytlqNG0xqbgQay/hwFQZ9PTXcTQWwExqn4dootKFHA7Qer/rCtX2G/Qs6aSDvXwl3BcBHwCr0pHkkSBcsLPiSIMlf/hg+92vy7/ZXnvqI7Y5HWAwVVOWTBGsFgBPE33V2E6IjoSBQNgsGK+sR10IVd+dWVMY5VkEJFC7X6citYK+hTtGbGSYQ4oDLh2qIP1jRFbbV/ApJdNgknbrJ6+kIRgx7hlTmg/fLfo4mb1UBViJtJZktkhMqQvzNq6ysNImcfpHJSrxL7yZ6t5GOsewF/Y9l754al2Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:10 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:10 +0000
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
Subject: [PATCH v6 10/14] fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
Date: Sun, 17 May 2026 09:54:12 -0400
Message-ID: <20260517135416.1434539-11-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0024.namprd05.prod.outlook.com (2603:10b6:610::37)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: f5ec5afd-dd51-45b3-1669-08deb41be965
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	TMMeH9uZVITkR68xf5Vr16kdmvFdnDK8SIVNZHNE413JDbCAHLwIo0IKwDEYeA3e/jbI2hh+4VuGm2wzfA3Tgxz56Y3FQDKK8c8Cz6Vp4lkfNVOX6XigPCtE3x0Tef6Gu6Y3asYT08KUd3aqFswRNFMiQxYzrlMxAPA2oVrx4Q1JmY8WEeuhVkWetwg5Q+cgS7HTl2HbPP3CS0Iuf5KB4HwFIHufDNGg91VdwFOcW++coEKk9fMGLHCUTo/FCWhbBGeLlkfQ2PPP8HYIzZz78/AjesOVBwdAv99ZTY5+FeuHz4fVi6fkqyJBT/4hoy/SKGqsry7ohlhm46OZBpyQbMvId5U4kC9NTk6p374cPAsevWwy57kIuZkNlwIg9dfw3gZaTeAt8a4/Tnbq3cKfe8vMxXQLPTz1O67NjMcIbiFKtr2+bOO80GubuepF/Nd416sSRAnZyT8i57Dmq4VH4AdfVlJRvmX0jMKtAVuQX51ebRvsT2Hq7cEuA3wyH2HE5fLBrHJMZIrRRglDk5pt7Tu6IgnMDQST0VoJ+68creSEUy9+GfoTqJWPOH9NEuCpUww7sw7YufYfHV1H6PUDve5LxiuNGgJpDKSzkcHzmc9Yckees3r1+piaMEq/J4Tz2fxU2lrbm1dOhw5A15X9uBVhKAq8mIVfYAM7Z9j65GyWeBzVVpbfbit4Z/mSWmXN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4eY96duLljuyFthO147K2GJalhKit/HumsaA3YH07zaanoZA7ERGbx0jgCag?=
 =?us-ascii?Q?R9/tmVWTpZ6sT3MKK69+7fEAhMSZqXQ9ZdWdueObA2oQLU4gX0SxRLC9qyQo?=
 =?us-ascii?Q?nKSU4YtN/Qs6Y2WoveEcGfR3zdQFQHua9nQVKeKED6+46V0RamRSmD/LHEq3?=
 =?us-ascii?Q?Gn/fZDfqZeDmUjwxnIB2+HxUeqD7SvFxa/3V0CNKJUabgawuesyJ8AxkyLjx?=
 =?us-ascii?Q?+Vb/GbC6hbJD8cEMbKhK5WqMBKSJrgmDn1xWe+mWzvN9qvus3rISQBiNJcNh?=
 =?us-ascii?Q?GSnagGAf+D6ok+gEfeQ4b76osjoS9sOlMlJTDC6PGvIfqrBdcBeztizz+tv8?=
 =?us-ascii?Q?zk2vcPZYzzlkJh4QMlZrS39uQlyPTTXJPlftRHE7KD+ZkGGX6LLxjkWebNRC?=
 =?us-ascii?Q?45H4/cjk8yLpOIVfAEHcDP7Z7Z1RqyRXw38O1Y8cZuPTZwicIsstioqgXYKj?=
 =?us-ascii?Q?uPVIKxD0Aq9I8+twg3qHH3Z+PaYR3g8iSE9wKW0bU1N5Jp8nvNFpmovKd/3W?=
 =?us-ascii?Q?0OGZyZ22RPgfbxUpQIXMWFnF3g7xXgppSkZ+8F/C6k8gNI5/xEJyQPSI5s53?=
 =?us-ascii?Q?R1Xfps1j9kzUDjVSOZtPan+guYhhFY0j5ou9KHHVJEDClRB4iYqEg5Y6Tc/h?=
 =?us-ascii?Q?vo8nFtAG3DXu3/1IpNXJ+f2vcLKxYoRo9IuGQuDZ4e18p3Y4QtPG3bRyf88Q?=
 =?us-ascii?Q?1+sMJImOifUMM+WFlv/Nk0e9Gl7rGdNwt28wHr3pomrhMG4TCVsll9FVATgi?=
 =?us-ascii?Q?o2UFu99Mm+D2PWfd24vOb/QV/Uxc1hjUZc8fuNT2GvtHT355trrK+hHw/L5J?=
 =?us-ascii?Q?zDsILXVrOmsAro35DTbpgmTAU+0nC1Yud0hR0QubGpQb6T42GqhOVZbm0NQ2?=
 =?us-ascii?Q?U/7gLYMOhMCxPw6qh9KTTElveU3CpJwPqHy1ENn0bxirzA+3xQr/+OeUDrvf?=
 =?us-ascii?Q?3a3UXG2msRxFLSYQ1un359wuPTX9/LNMyUHO1V49KuD+d9iJGmW71TInh7Xq?=
 =?us-ascii?Q?eGwqpFLLLYQ1Fc/Jurbdeik4wVM4KzRS2GW5gNOoXgEqv0OqCT1Gdm4K2Cdf?=
 =?us-ascii?Q?jYHtnde9x/BeJi5qMeKQw3yrWvf3nmHdfhmdSQssXIY3056wrertZIKeuPZY?=
 =?us-ascii?Q?rDgc3E7ci59S1Xz6G7DF5cSgqrypY6fYb6giFar9yv5CDU+52ZdJ2Ojw1/4V?=
 =?us-ascii?Q?KstB6Iwsq1V1j6SsCHAFiHGGcGP02cd44TuqS78anwUc0EH68ONaRw7rZ0w9?=
 =?us-ascii?Q?Moz+9OibA/jmYLIH8GRPYj/WYkEdBEdv01VfSROGi9SukfMEY7azIOodQtFT?=
 =?us-ascii?Q?xGp7pY1dYj3pEA0RwathQZVVDfYANNxzMrp/fT2dg8omsm4llvesujr5vq7R?=
 =?us-ascii?Q?T+Jsbz84/V86k8YpzEFXG+mRBpLedH/wObP9dkPSsDieES4ZpBALzVMmfo0Z?=
 =?us-ascii?Q?iRYThOIl10EHwDiC9Edy7RFBQKm193I5ciEcesjtXQcZVv+Lq1RSovXfbrOC?=
 =?us-ascii?Q?umBXCVDdds6jSafy7eoZyYuTBh3UrzqFUEoIBFYaWC2FBkR5C/lQ02MxI/H0?=
 =?us-ascii?Q?PTyLo5qVmbqyKhZ48qbsjoC3komDftSzyX0ka0szlJ2/4xJSpLhn487hTCzZ?=
 =?us-ascii?Q?azzl7gzu2S+B3HSeVJNRpKtB9Zhw9IyM4bQpDBALZHMaoR88iPyPmTfq4y06?=
 =?us-ascii?Q?qtXBZskIEr0KNfLqQ/iIsCieKG8jBS89vOcUc49/1TvufMVR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5ec5afd-dd51-45b3-1669-08deb41be965
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:10.6966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NDL+IV+3cD1OMCPkaEi42L1Pp6jO7fFYt8z1Q1xy29PPYpWipyKDqmOTnbJdgTlS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ABB204000A
X-Stat-Signature: amfsskzqmh4yjzj8bu3w38u4moynir47
X-Rspam-User: 
X-HE-Tag: 1779026153-980497
X-HE-Meta: U2FsdGVkX1+0QUHFcDokt4pwBJ9psYeZwXpiNeooRqB7W98SW6TuX/7qhlKUUfOcpoyLKNYWLKEk8ucIGTwgKHiilkT5+t31qcezD21F0Vf/z17+slraGqnjyOYUtQqgz6JXWfjPA9kLtd7CrD1thX+EAqe4pK+KX45kWJdyIyB+SvgVeoaNiue67QE4RdQMTIvlLtOEpQKkwEUYkChG9BB84z68NbLI7NlEuVlvbJB5rv2kzQ7kIQyhgIy2rdHeeF/E6k++tnEZN9F/IOm+NQXeiJafQecmjtAXl7xFLWFJNj6b0SD1VbDHTC7+rk54sV3nsopbq5SeI68JrhuTmr1FE3EN5AIREIV+9x+tzfpIpLkkzF8IrJpHOwroY/psLqZu8XCdOo+oEe8YVXf+5P4N3b/ctDAfATpEb+sXTtH8Zl9EF2GJITmk/sfq93/nFKsya+RtDxu9cDj37iD6pTC8qXzh1QnNzxIljTtFlze8vTtO51k52o73EZWcC8ZnjI2LIdg8vUrYzZsmO2NVLj65HVeZtB5eaNtn+RPsm219yqGzPNNwwNIjSrEjc9rkOPKb6Sv/Zn37SBJjxEi5Ekq7VvgudJVOb7sRa+06788rtBAGgRE5+saxYYHlPfRSnL0gAl+iixO4/QWKFJoZFw4kj6ySb17UShX+tEKhQ1jbYkkfVf3nptMSQE5SD+wBMlG9MWAL2bPPUSB+LBWh1uuC9HvWQ8q3R8IWabEWcY4+k4ZFbZyiiqZ8mVJPv6wJTPK+xwQxD2GJ2zWo5NyooszAHwMzzv8YPCgTPGsUcV/jwWJlkPQzmakBnk3X27gRII/RO7sZdyXBysNlUo0TfPWO+RvRFLGk+8wdH+26UDjLa8hfM1MbPrnnM4jcNGMyKVyyrIysRXPjcSxxHnYGq+eco6S4XUJsGb64VNNHdKh+TbJl4qXZYfr9gNTAt17ZUkdnYwHYGsehQOWeuoN
 Zw95OcVz
 c9ELxi+VzcCpdotmoNsw6Jp+VYUYgduZ7DYkg98f8CwQsy7l6M5r4wPzzV6ER8DWNOu8jdl2VtqiKHaFwdP1/6g3qSf77GlLZcSvZxmDuyIaXgLPsT3DFeMt9sDL5Vvvo4b6TGdyeSBxSH10BwxhHFxfI/NrZCnQck90iH+VQL9gaUhykmvRtNIJ/gA6dp8ucoa9m8d03Nc/nPpYpXeJ3mxEmEfLIMKVLTF5QOO6cqLe9WfCwRisWvSRgotCO9DT1WnxkFapoVVIPB8gX90NI/1qZZYu/B2LUQ6L5nxTl5SGNglalNcmwCGunNmOwjfLd7J6scy/4QUlreE+zOJt9IOYAsy0uqaSzdlD83RLb5R/b25koRd/XtzcE/e7gqqnmxC8Uxy8BUtyKVf96dwptY/IAslsy2p98oiM4v5qJMWbMWbmRWpGxevoOLpyvY51Yt3LgPZvqmR9hva5jXseVFevU/h2CmWziW8WBBg5S+ROBdfQ2Qlfrs9O6vp2N347lDPKDKqEyrA9okuDCZGimd8y1euE4b1O5sWNwpOK7zX8slt1wmdoZES0ssYk1DxasYiLoL2cEsQkhTCoZToVMBt8D7qxGk08WDf5YysAl7GJDYQJaa1hVds02jIxnQND39anB0jJF1L7rpjT2H65ikE11qQB36X62KHf6FYAQx89aq3zsKrflq0H5WeRNdworULRFtrxiLW7IOs000z9KK77efkKLHmLNtjit80o6WO/1PIqx/CyiDq8+enjkI3et+o63GT9tlBc8SY4owjY4IFvw+aJ6s3Lm2pzIdoRGDPazDsqNFG45BmMTKZmR0eg3XX0J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

READ_ONLY_THP_FOR_FS is no longer present, remove related comment.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Sterba <dsterba@suse.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
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
 fs/btrfs/defrag.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 7e2db5d3a4d4c..a8d49d9ca981c 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -860,9 +860,6 @@ static struct folio *defrag_prepare_one_folio(struct btrfs_inode *inode, pgoff_t
 		return folio;
 
 	/*
-	 * Since we can defragment files opened read-only, we can encounter
-	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
-	 *
 	 * The IO for such large folios is not fully tested, thus return
 	 * an error to reject such folios unless it's an experimental build.
 	 *
-- 
2.53.0


