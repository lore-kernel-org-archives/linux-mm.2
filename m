Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7D7FC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 09:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41716B0099; Tue, 28 Jul 2026 05:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19546B009B; Tue, 28 Jul 2026 05:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08E96B009D; Tue, 28 Jul 2026 05:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3506B0099
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:07:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1B11120304
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:07:31 +0000 (UTC)
X-FDA: 85037607102.07.DE37360
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011031.outbound.protection.outlook.com [40.107.208.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id AA8381C0007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:07:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AO2UHVK5;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.31 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785229648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1z+7iqbSi/LNrJLugGK9GH95ANvxbIR1EzGFEQmbI0=;
	b=LvBXf1LDEkmE1KQYyglfDlJ6VdRPt6lfM5WRzzss8DMdMp6eFL1TyeG2xLR7AconaW68EX
	sFNlFdasbEbA6psCdHBwDvi7mRKUvxaQiZbzYsRji5Yff0KLxEi1aLSYOid4iBLsfKmIJA
	7A0UjYjM6/UwhvPq9OutHcY4Va5wUbc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AO2UHVK5;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.31 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785229648;
	b=fNkIcjPI2n4H3Y3HOcmWN07q62vxKJfRP/m/yFMj/8QnC2yg6hJ20i9Vx1gZOKe7RGBbq6
	JODD/qRxje+ZzcgZYh3zDEgMUxOPQZdKG0LAG051VcWXCeA1UrUL/HUrqRZ1PH/268W/Rt
	bXMS6korvP4yO0M1NmPqf/HpFjg9SJk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cNe9JQaBUOoAJO0x2ZRG0KzFWyMvbHNAPo9F5rC+6JNO0L7QoNC/IseHYat42/ef+pEWQ3ovKBZni6FH9fSnD7eYp/9YPLqEZ/4PTOkfBrdJtamELoZzwmj7qrhYa/lqsJLqYD0wmT1+kaYZSvQ5NkpR2BnKQ/DzrquQUUQAYRXTetz/JkdjR5SoYvXnmdnUHSadly6VayeJWBISilkOgTZiJ5Vb5gdNcuA0Q8QFylswEzkUPOTXORJOZgOrYSKK/z7O3crQetAcfCp/QYTSplNzyYtGHY4Pd/fvQlxn0VkKFMHzjzRnFjHxFoMIQZPNzp2MbjdHsdcyyQNND111gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r1z+7iqbSi/LNrJLugGK9GH95ANvxbIR1EzGFEQmbI0=;
 b=gsJRAwsqrA+N53H8/lGwhiMtuux4rDPik6+rgaZChx192TFoMkYJ3ITr+eNEJS21Dwmnw0Zx+1f9F+jFG91ngC1UwZPXDH3nbHIeXXhEElDBVBdcB78z3o2i+RcFfJT4/OLXM6gtATym2hNjNf2oyxm267Jv7FRpLnVdzeACJWL/RWrMl6iNRMbha42IUc3LsVtvmLviUK2ESX81EF6mFbH99W6JNAnXSjQemH18Kh56D7Fv30JhOSfc74Ggspxe46QTRho4+tVNIHzGKbgJUSM7ffJt4kJz61gHvVdWs8c7OW2xM3e29EkcMWhVu2m/t464nV6mcdqLrWVpS/yMtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.alibaba.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1z+7iqbSi/LNrJLugGK9GH95ANvxbIR1EzGFEQmbI0=;
 b=AO2UHVK527kcfMEacd27M/UbVLpuT4ho2P+GTn6ckNE7AmFfULTZ3KI/uuENH51MJGmKv5Bs7mAnkEJivqP2NBUO0/mV71GnrPEkPTu2vILS/SbM8lf5PvMP2ZeuWTGtkBlVoYS+3YH4BPVPu+46oVLCSMPPeSgVA8Y1PRBfJck=
Received: from MW3PR06CA0017.namprd06.prod.outlook.com (2603:10b6:303:2a::22)
 by CYXPR12MB9338.namprd12.prod.outlook.com (2603:10b6:930:e5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Tue, 28 Jul
 2026 09:07:20 +0000
Received: from MWH0EPF000C6194.namprd02.prod.outlook.com
 (2603:10b6:303:2a:cafe::58) by MW3PR06CA0017.outlook.office365.com
 (2603:10b6:303:2a::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Tue,
 28 Jul 2026 09:07:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6194.mail.protection.outlook.com (10.167.249.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 09:07:20 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 04:07:10 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Tue, 28 Jul 2026 09:05:35 +0000
Subject: [PATCH RFC v2 2/4] KVM: guest_memfd: implement folio migration for
 non-confidential VMs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260728-shivank-gmem-migrate-v2-2-269ac1f84e2b@amd.com>
References: <20260728-shivank-gmem-migrate-v2-0-269ac1f84e2b@amd.com>
In-Reply-To: <20260728-shivank-gmem-migrate-v2-0-269ac1f84e2b@amd.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, David Hildenbrand
	<david@kernel.org>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Chao Peng
	<chao.p.peng@linux.intel.com>, Nikunj A Dadhania <nikunj@amd.com>, "Michael
 Roth" <michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>, "Ackerley
 Tng" <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Vishal Annapurve
	<vannapurve@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, Patrick
 Roy <patrick.roy@linux.dev>, Pratik Sampat <prsampat@amd.com>, Ashish Kalra
	<Ashish.Kalra@amd.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Ira Weiny <iweiny@kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785229610; l=2548;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=vJ7tdOeFBMkBCcRyaoW84wXqwR6XkDOVFqGKnmaRxU4=;
 b=GD84uVt4JNjfESyg6uqVH0eOqeAAWTGiidycJgjtx+nhxDdDtU8HcSET59TZgDKVrWFsDW/lI
 3mtzlKNvmZvBw5vrOprt3CR9w9TntmxxAYzumGebsOZedhn2ELAWF0V
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6194:EE_|CYXPR12MB9338:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a011d01-fcb9-40fa-df05-08deec87a173
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|7416014|1800799024|23010399003|921020|6133799003|56012099006|5023799004|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	u012Jj6zLHuo4AzQ8jISG6MqQokcbWrPfD5ifJI0S0j2P6aR3cJ+9ejfGoiO8oscqwCJYxM75RuewPB3cnUg5JnuJp60VBoRvq3nZaY/dK0xCEFaAMvFxB5T344AviVIber5uuomUy3tLnM9nkLEi1I/gwv2JlACE+S7Zr/9PQO2qy3MzFUOxPwsBI1Il/50noKIU6Q/Ty04F6m/7ktqoZjjljFZPcPF4FzyxWQU75Ys5+F1jaIsbj6ebu75XX9S/e3dc3IDl4UVb6eHd/cOIXovkhz4d6Jkt17XiEsssw5zGJI3AqcA67CXRB356k+6wmJoaWqpqiimH8b8Idyzym6o6NRs1joY0iYB1kYQBcHA/9kygcfEbBS4qOmcLQ/XdcWzVTY574tepvvEC86INCNcEBgUaEXaJZR7LfKrsQYKWVF9+W5BD6Did8YrkxStLqcCEck2thYZtVM4Y+XBBsmsMnlnFqeq9LaxfUOeO/B1z/c904Kw6+yd4y/hOEg67wIe/QtY78l7tfr4u2zGwF4PcAetI3EMZbWjkO+4tKSaYtbdsGkDa8vWQZXnC3N87w79pJPNJv9e+PPXQj5A3pzEuAXrVeipfOxBhzq8JaE3uAwm7fbcmMrqpLWamN6cM8MtPkZHMjCLKzR+20dtesAIZqmUXnv1q0R5IzCyn4T3v6iARmTsVhocq6TSX8QCoLB9C/7hBNxaL4XLYb8n/2zmaOSV3DUQL1ITpGuueEoPqq98ZtGmVUpFnn1L8bNd
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(7416014)(1800799024)(23010399003)(921020)(6133799003)(56012099006)(5023799004)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yetDJmn/60IVKOc1/zuo1GAHimKdQX0G55KYHlN5p4NeeAWAbT3cooQ66AwhDNDcSMXV+vwfZdonsXo0CqJ0z3ynInTN5Z9yKErSAoNUVBMFjE3xf8O+KwNn+tNA+hGQBY4gQHK6B9zG6eCWpQpH3rz4UcgBMdN6GQrN30rczwiSutFUMoMjsDnFHZlOQpYTPcEmEETEhnigj1PyT/kn4UIJ5/0pbXOqmXsnVdP48/vN/IrzjVcrjF/vUD9hLTnWtvmiX7/FmLv9mnGRBxV0YrE/GOZLNroozGWZtDQM1sixGXKsURkTNhsL8d9ydyWIWJRA4yUfci9HG2OXkneM/oD+F417d/Mgly8DlbSae9beoqK7CyRvkzlv6D0eIpGilB1xVI2tWUyYaCDvO2Vav6juJWwP4f/ki78/3VDxDNpKkrOhE9yP2fj+QXAfkWIR
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 09:07:20.5329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a011d01-fcb9-40fa-df05-08deec87a173
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6194.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9338
X-Rspam-User: 
X-Rspamd-Queue-Id: AA8381C0007
X-Rspamd-Server: rspam01
X-Stat-Signature: 89gmex37xsmf35emprtb34iubnsb7o3j
X-HE-Tag: 1785229648-42114
X-HE-Meta: U2FsdGVkX19087qT2gMMqQULaVmBG1RR/XiHiR1H+sHekENCRHCPrvYPaxNmtPwtsQvvIv3ZM+efloXOF+xc1BXSMAJnIdCO49jIcN79FoNA/WARCeYpLSZ/LYTlBl/ypIrTcfw187Ageoj17dUyLVcksXt5DfNTBxkfRkmXrMyFqafC3wMcQhjRaCuRvofGiRulG3vTA8Ih+TLutgUEVZeiAZsgA0xvI9Iuxu2LpwAgbZCvvbtOD5Alu4k63N1FXgDMivVTZbsPxoGM0iltjvC/pwS8Ts9I8FvSKvYnkLvOzblaguSvelytc22nuHWMwC2JW3MDqKfB8XJjmoyDSaZijwsZuQRkEX1gnfS/wWL8GM6duCcrfZDSqLyoxdR0Q/pNZj3UXTRNxbtZzozqMLQWhy1OTrXly1HeC6xnwPUeXAWvUjcXEqYwWXOjbaGgJP/zwEez6My4e+l2gQERehJ2lkjvQAAt3kndPCohaujp3eSz4fRsh6xG/d9PaGYkSlcXL9QM77DRE6G2CNSLKJEmYYkimd02j50Ha+G7NbcAw4BRd0BKMcI45VsaM5Zz9R8v/vcxkBXep+xqG/SLTVBbkJB8pvNq2xVuGLy4qqOdNQGlEh9M3/R6xPLydUDPMKOe/K+tV8BQRykAa0xo2pzya5GTEfGXgaa5R0RyZU0V3RZm+fvalSnhYYo0R63EjrAHVRS5wpg88HAAxjnxH5YVoGjJ5k9bHrgB88vsJbLRe3Xac9mn3Ezf63nJVbR6UQB/pajztkd6p4OwGgNg0hOu9DBMJRsFfDxG6guRMl91qqfn+z1MMD4/yAR6QllkgzTnpbgunbIeIO9+5sMtS32+dXpV7ZOXsGGFpD5tgkHzihSoLwN4S/Ashw4hNqoVTXOL1uZnNL/wbSlo3lCqZBSeG7fVnzkelLfLcIdKWtJ7qrijELtwrgcNTDuhL5+jVrv3x6D8PQQBVvBrDUA
 lH5DDbVS
 HKcbd3TQn1jWlclyCzgG7rW8uRrRr3/ReAE0URLLF0zodH8wbexh+/ufBLvVhu5FrVgqfIsv2JplAJvrrU4C+sdTAeeKHAdJfHmJUuQ9Xjsh6o9o5/Psjp6ZkGxHJy7lm8KlfOIUmFMNlP/Qh4F5rbshJMlohj16FCSSVav/G4LmpKk9cJkNHa1l7KZhDwRmRPGtNrwBwjfThUfJ0t95l/+7BRgFMXYuWZqKmDuJT4Zi0HyfDpxzvAag5VU0T/RymRQPNHfsvU/IqJ038fLjq6Kek1Qpv9nYp2C95GN6BeCZMDE9wyvxW/93wD7sqqfmNae7cBXDp/KQGXOXVu1hBvQ/CKDJpcs3jNNF+IdPVX6hNutXkL3J5YXj04LtdVAAX7S/kvATs+tO66dRU6GJzkcFxZhvNusGpjRFcs96EZso09m7I3C3EHR1ReUckdu++OAVA8UY+X634elOg8Z2xioBQB5ChIUB1QZgx7kP4w87H/yvmCnZZGKfGKrlSxnd+BbkreK7k1RR/lsgqmGV2jLD0j6J7mOCNVDbq9o1QlU9IayigQxlsCxfS1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement kvm_gmem_migrate_folio() using filemap_migrate_folio() for
non-confidential VMs but don't enable it yet. guest_memfd mappings
are still marked unmovable, so MM never calls it.

Migration invokes ->migrate_folio() callback with  folios already
locked and acquires the invalidate lock afterwards. While
kvm_gmem_punch_hole() acquires the invalidate lock and takes folio
lock afterwards during truncation. This could invert the lock order
and cause an ABBA-deadlock situation. Use
filemap_invalidate_trylock_shared() to avoid this.

A subsequent patch adds an opt-in flag to change the mapping to
movable and enable migration. Non-confidential VMs can use
host-side copy via folio_mc_copy(), whereas confidential VMs will
require firmware-assisted copying before they can opt in.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 virt/kvm/guest_memfd.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d3b1186b03b3..ec881cabe8e3 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -488,13 +488,45 @@ static struct file_operations kvm_gmem_fops = {
 	.fallocate	= kvm_gmem_fallocate,
 };
 
+#ifdef CONFIG_MIGRATION
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
 				  struct folio *dst, struct folio *src,
 				  enum migrate_mode mode)
 {
-	WARN_ON_ONCE(1);
-	return -EINVAL;
+	struct inode *inode = mapping->host;
+	pgoff_t start, end;
+	int ret;
+
+	/*
+	 * Migration invokes ->migrate_folio() while holding the folio lock.
+	 * Use a non-blocking trylock to avoid inverting the lock order with
+	 * truncation, which takes the invalidate lock before locking the
+	 * folios.
+	 */
+	if (!filemap_invalidate_trylock_shared(mapping))
+		return -EAGAIN;
+
+	start = src->index;
+	end = start + folio_nr_pages(src);
+
+	kvm_gmem_invalidate_start(inode, start, end);
+
+	/*
+	 * For non-confidential guests the folio is host-readable, so
+	 * filemap_migrate_folio() can copy the contents itself via
+	 * folio_mc_copy().
+	 * For confidential guests, this would need firmware assistance.
+	 */
+	ret = filemap_migrate_folio(mapping, dst, src, mode);
+
+	kvm_gmem_invalidate_end(inode, start, end);
+
+	filemap_invalidate_unlock_shared(mapping);
+	return ret;
 }
+#else
+#define kvm_gmem_migrate_folio NULL
+#endif
 
 static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *folio)
 {

-- 
2.43.0


