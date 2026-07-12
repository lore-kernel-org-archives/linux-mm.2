Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E3EC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 07:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AA576B0005; Sun, 12 Jul 2026 03:41:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781976B0088; Sun, 12 Jul 2026 03:41:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670BD6B008A; Sun, 12 Jul 2026 03:41:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 433876B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 03:41:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3E4AA0856
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:41:02 +0000 (UTC)
X-FDA: 84979328364.22.6E44361
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010008.outbound.protection.outlook.com [52.101.46.8])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7E83740007
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:40:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="msn/BWK6";
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.8 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783842059;
	b=7jgZN3gfOuxIXOn21RBDq3QuZo5ZQWCBHY74rkc+A89T30MTuJ25+1isU3X6tZNQMSLGw8
	LMg8NBYPg3Je8lQ05VrDQodJ/QaW9vyArFh6m3omEgSsA7oNf9pM0Jl2PFVMbsXMOS3Bfj
	cbZThnsmgWaBiYKfmFP5+jowN9PpWpc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="msn/BWK6";
	spf=pass (imf01.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.8 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783842059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fyz4ctdhor70uMG2b2egvjPOetCEM34n6i2B+bcaLeg=;
	b=yPWxDI01p2ia5EHY2s7X1Vte5oxt2b7b2j9YahRtIdwwPL7x404mcvcJUJJoNUEaQVTan+
	mnBYrZCCxuOUSgVN9FUPauxxnN7AO2tBr1ltm27eY+94Vsp1DypPP2ND9oFAdKU3MH1zjf
	lJll6rKNBepS7LOvZn6Fe6STuVFf7Dg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JkuYrLFX+3nUZTIGiN1E6kxEc4TbXZbZ/iiIGe0PAHFDkjkclH6yj7w7Z3Q5lBADvjtn25jlZu7yDIqTqWLEP1W7ioNMwv7SB65JSlc7p3KmIQyOOmJIyVh4RxWTlP5AOWXQSc2OTMHgUtKQXsYY528yZLWq7sOIxnu3pBoZip0Ag4Ul4qsgV1QEZxQy+AQPTc6GIsLLsb65hqo0RiP6rQ4fO8fT4nPRYRWVXp6ZweBM3vjKK9zuU7oAZPCaZirxUPYZ0XfLRu3SMWxFg/VSO03DTwQsR9wKC4u/aQft9ysaeVRY44lBcmhiBmTpIroukK/+aeD9SCAYn2BSg69xRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fyz4ctdhor70uMG2b2egvjPOetCEM34n6i2B+bcaLeg=;
 b=mV7JnTL4jNxvhBBhsYNPA3yYNXNkWdlWvuzyQBWL44MFS55uqkysWWXqVeBmpihcTLrWeW7Ll+6to3RhK1Oouxdn1V85N8tPRmdai+IzGa4aAvdPwjbmpk/1lsFuBsp27C93EUaBR+GVb+EmfmA4Ctha1Cu9swzCSmbecu8QCBUS9eu94l1IufUY5glR0F2QYQV/raW/Lmzlt5hTfUgQeK0lZPx2bKnuIO2JJ+2FKQ9ruFRzLbi7jyYmRIoc8x7DJdTjPAnng/mB1M2mQ+LrLTm6sEmnAp+kJJJmT0F/WbwD/CpcCUdrbl0KgJ0JfqSEC3KsoeAlvMU0300eiLO4dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyz4ctdhor70uMG2b2egvjPOetCEM34n6i2B+bcaLeg=;
 b=msn/BWK6/zai91Hr4oS6r9wVKBOE3pe0VkDrn9XQaHcZVoCKXAyqUnoTTKNcZ9QqrD8JvVFnN7A5GRmmvUEshLx6GY/s7otw54uVldKyrxpL9id80Dv8srV8rBDMOYGVTWXjopIzBgkLLX+Bj8Ri4RHvpnjSp7itNdAIBMMfz28=
Received: from MN0PR04CA0011.namprd04.prod.outlook.com (2603:10b6:208:52d::7)
 by DS7PR12MB6119.namprd12.prod.outlook.com (2603:10b6:8:99::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.19; Sun, 12 Jul 2026 07:40:52 +0000
Received: from BL02EPF0001A108.namprd05.prod.outlook.com
 (2603:10b6:208:52d:cafe::14) by MN0PR04CA0011.outlook.office365.com
 (2603:10b6:208:52d::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.18 via Frontend Transport; Sun,
 12 Jul 2026 07:40:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A108.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.9 via Frontend Transport; Sun, 12 Jul 2026 07:40:51 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Sun, 12 Jul
 2026 02:40:44 -0500
From: Shivank Garg <shivankg@amd.com>
Subject: [PATCH 0/6] mm: batch rmap walks during large folio migration
Date: Sun, 12 Jul 2026 07:38:46 +0000
Message-ID: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAIZEU2oC/y3MwQ6CMBCE4Vche3aTLREFX8VwKGWEPYC4rcaE8
 O406PGbZP6VIkwR6VasZPho1Oec4U4FhdHPA1j7bCqlvMhVHE86mE9gm/zCnU9h5BohyLmHa6S
 ifFwMD/0e0Xv7s+H1zu30H7dtB9nNMNN5AAAA
X-Change-ID: 20260701-migrate-rmap-batch-8ecc04de1905
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel
	<riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
	<vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Jann Horn
	<jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>
CC: Karim Manaouil <kmanaouil.dev@gmail.com>, Frank van der Linden
	<fvdl@google.com>, Kinsey Ho <kinseyho@google.com>, Wei Xu
	<weixugc@google.com>, Bharata B Rao <bharata@amd.com>, David Rientjes
	<rientjes@google.com>, Dev Jain <dev.jain@arm.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783842044; l=3176;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=JaWvTqPDVb50vASsYrb/KTWrSaLeUDGTlaOCse6oj0w=;
 b=7f+y52xOewLwCYemlCFsPtwxeHTDGiYPaP8RC5UFxeq4+tqH/VwkIiViBzDXo28tokOOhWDZa
 h2YFWh4hUTpAVxXJMGt1s87tPKGji+2+jqt3tTxK/xXW7+RnGF2JsUb
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A108:EE_|DS7PR12MB6119:EE_
X-MS-Office365-Filtering-Correlation-Id: bb5e532f-b09e-4e91-9da0-08dedfe8e604
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700016|82310400026|23010399003|921020|13003099007|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	7qIBSmWlCxUE1jXUxbeEDqKqhZMRLkuJGJJTGZ5e9YhTOnxXCePJDNV2zUUarr+XsuqQGgfyzrG1vgKYelMh2r5H8zP8CWoPRbYHVHua5TWai8iOrwcY7+z1XJdLwFJQc4aCa+xDzrVbqYzNXQjPZTKEclynckf+hIw0RDiEgVQI8ZxzXp1YISih2i9XC4sBvjEAAnQpt/6MsZV6qc0uCr+KL8Zpa9HhLTrO2B8315k3a4JYwXimi8o/bzCsk6R5zqdB1WaILDDl/d1mHLMRlm36YUjkesjk7HR8j16jIZAfO4A2MRhCR9mN+KFoLeMlsM+7QDQ/NhfMB6OAbeXbiip2UK64CLU7bgMyl6WTFt0hqtXbO8V8gymXw3K4yOOl2GvcqScMKdIV26SdDdjs0CmAhKWk0iQSQKLSZVU4i3U+Tovm2kLe4TAuEpfMpMI1fVhauRWOSzwHIB6rEPS5JaYDqeW9qEGyG2sKpnp2bcQfdfNJIq+SNYijMLKo61Lo+YokNuuBrERVOOFRMmq+hjnKWn12+yaaZmlccw4Eajd/G6bNGFYH0Ux+NiRF5sC4mALg80CscDadDUk0V/HQAFoLpNacOnihZnxTk6SYS3zaKmGdrU5aU9unUvp+hpmAoBHFx0Qo8mEXrB8Y650m/ALaPuWDfc+XKrtXgcnnlmLYAupMgcUja4/JBXfm2H11r6da6Yg6RfXTyKoieZAR0+Uwg7SV/cXQbsaC6HnD3Q54kZNc1Z3/OXcdLzbBcngX
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700016)(82310400026)(23010399003)(921020)(13003099007)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	brOrSDkyVc0JLjoYHUiVPIZajSCwy62/9WgL8qXvVPJ27BHob9qQBEE5E3waog3N4M+1UlHwIXKIgGBd9DtNUm9MZ8B24VVmj77z6HYlL2VDB1+eoKRH/aFPhbqIxCeMTNlzldXRzQAZsu9vtrARr7Lw3d0o+l1HCSNObLIyEWvdkF5iq7hYhxoIYbP4U3Lexj1Mk3ZehXUYpjgv4QRz1emncIiMdxwyl4MPs5NMYNOenX9vU8PqBYFs9eEtnQtOvchDiMXbYILjywLaOwrbpB7Ny9hJBitN0ZkOsjQx8NqrI91MKDpHlXLOBSPk9jEMIsSqOS3AJPSW69QZUDT84SjthDmU4wB4qZbXIeYPYHrwiCfe1kS016q+PXhhRpDwWxxI11V3b4fsrpM/4Il8xUd4LZC1p+CVDg/IX3cFJnwRIue7qUUrlyky6rDytwJ+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 07:40:51.7237
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5e532f-b09e-4e91-9da0-08dedfe8e604
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A108.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6119
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7E83740007
X-Stat-Signature: kbc1egos5tijuzitip6du6yrrm17ri78
X-HE-Tag: 1783842059-261015
X-HE-Meta: U2FsdGVkX19cZFD/KaPvnEowE8ntbFrA8xmAHLK6IPFuScV6ngh+ElK2Rz/ZUYdKI0taITmEycE+axbci24BddgqhkzXvzPv8ab05uAST3lOw654GtgeugPbrVieXdFGFQf9ylavGehnhp25NWuvee4EleZRXF9jsiEAgy4ov8vkd0qZVeDZdB4/ina4eNl5FPe0a0r/6JQWM6nNckdgSGWAwi2XQ5mJVX+cbaQgFkVVmQDJQPYHuiTW3n4Vsx/K6x8Nkg8m+CcnaojvE7DduHGHvM3yZ5VSJplS17ee6P/e6RE77zBTDRV3g4zoDWMQxL8tdCMLwjtPJcnwbMjdiAB7egsfa05IzuSARturIqatNbpENs3rkRR3BwMsfNTYWlnMk75VZGICp5+2ROFbvXO2KtKjHDgteCmnQ5dppaLoN20PNo3HmJgtlJsMUKkQ8Mj2bxlrMf7xl959MrRsSTsPCOgY00IeYKrnHkPS3s90wYoE0+U0nkGRTBBnVtKNiPISiS85lY4v1KXsx2/7D9rhHrW3pYAMpLE4zBDY+3RsHUCPawLBysBOYNnaCR3q/gQZKLmmos8swQEOgso5fhTMkF3nqMYxNsUPwRNI+uEK6N+oikUrETLLn0mhbkaIyppETlvNToV4TdHfFfWExQF6h4NKq/xUaUm2RueZ7X6HcvUFzkQxPJKQ9oaGisDW6KJcGk/LDiKpSomnNCs4NcUDOaylBPghk9QG6PW4TdkOA41cQax7DUBF/8sNbAXStmknFceW6LqSDoj8lMuALxFRiWxcxnB/fLFmZ8CxLYE4ZMQ9anHOtSbf0iF7v4hMPa+jiom+Mn7lrQ4wY76PhPZKEnMJxFeZkyypYI9Dbujiab7WQarjOj81jodGrmslAPuArv6tTP/mGobP1y4P39MnZ+iwRlxOEX4WNnGvcSA2GxV2pBI901GIi6laqnHqqe0x5d37b3P3NxQ9L+C
 92joMlAI
 o0iI158e8h/MxDiqb31XyeMORbqbrszFoGnODJYtI74P1JRT9JMwNIZi2pefZNHdFWXegc4GdF5ZuTFYG4wZSBMAvkhDKYd0n8JA1TbrbedNFG9iWujsbfdBKMmf417Wt7OztyCzB9M8Jj0ict20OeYv5DNhW+IPeJEatdf3ZPXkIKO+54Vvj6PZtVwqI+D0D0rIU+jVBhcnDhpDhfIvM1E5khWsKAGCwbtXe7pMmaQRPGOReoWGXjoUodVNMEY3shbb/RVNXClaJBV86s3q02lnY+FnTfUgauLFTrWgVJZkLjLyLGnpio8kjCjK6r7xzmZqxGH4UrJhpvX3twk126o8TGaO9nIOtYXuFdFkNaXKcv5Brm46aMx5W2YmGHDqEYZv5GhwXrP8TFlpXrv4L+x2UUovJgQ09uAvaB5gIo/Y4dXugRW2AHFotCb5hs9zJ79wPdUWwCxpQaZvjhB0KXdjJV4pMWHHyDRBWOvOcceKfCToP4tnyujM18zLHU/lmC7F0+BQNjLPIKnld5lNNku44unxhJYfqisw9V8Qh6IYEmcvtgLcgVE2Br4cjRL7uqYw9gZBoE8sZgA4HHDcz1XYIFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Migrating a PTE-mapped large folio currently walks the folio's rmap
one page at a time. It does so twice per migration:
1. try_to_migrate_one(): Replace present PTEs with migration entries
2. remove_migration_pte(): Restore migration entries to working PTEs.

For a folio with N contiguous PTEs, each walk repeats page_vma_mapped_walk()
and the associated operation per subpage of the folio. (256 iterations
for 1M folio).

This series enables both walks to process a batch of consecutive PTEs
that map the same large folio and do some refactoring and clean up on
the way.

Performance:

AMD EPYC ZEN 3, 2-socket system (1 node per socket).
move_pages() migrating 1 GB from node 0 -> node 1, throughput
in GB/s:
		         batch-	        batch-restore +
folio     vanilla        restore        unmap          restore%  restore+unmap%
4K        2.98±0.09      2.95±0.07      3.06±0.05        -1.0%    +2.6%
64K       6.16±0.09      6.24±0.08      7.80±0.08        +1.3%   +26.6%
256K      6.85±0.06      6.85±0.09      9.54±0.19        +0.0%   +39.3%
1M        7.06±0.09      7.17±0.09      9.89±0.06        +1.5%   +40.1%
2M       10.97±0.17     10.67±0.13     10.69±0.15        -2.7%    -2.6%

In plain migration, the folio copy itself dominate the cost, so these rmap walk
savings are only partly visible end-to-end.
When the folio copy is batched-copy and offloaded to DMA engine [1], the copy is
no longer the bottlneck and rmap-walk batching translates into much larger gains:

This series + [1], DMA Offload on PTDMA (DCBM), 16 channels:

		     batch-copy
folio   vanilla      -offload(dcbm)  dcbm+restore   dcbm+restore+unmap
4K      3.36 ± 0.10   4.16 ± 0.18     4.10 ± 0.14    4.12 ± 0.13
64K     6.16 ± 0.47   9.63 ± 0.23    10.00 ± 0.33   14.63 ± 0.14
256K    6.70 ± 0.09  12.98 ± 0.18    13.52 ± 0.15   32.30 ± 0.65    (2.38x)
1M      6.99 ± 0.02  14.32 ± 0.67    14.84 ± 0.17   38.97 ± 1.03    (2.62x)
2M     10.74 ± 0.29  64.25 ± 1.48    65.36 ± 1.00   64.97 ± 1.75

[1] https://lore.kernel.org/linux-mm/20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com

Applies cleanly on mm-new 10-07-26 (61cccb8363f).

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
Dev Jain (1):
      mm/rmap: Add batched version of folio_try_share_anon_rmap_pte

Shivank Garg (5):
      mm: factor out generic PTE batch detection from swap_pte_batch()
      mm/migrate: split remove_migration_pte_hugetlb() out of remove_migration_pte()
      mm/migrate: batch the restore-side migration rmap walk
      mm/rmap: split try_to_migrate_hugetlb_one() out of try_to_migrate_one()
      mm/rmap: batch the unmap of large folios in try_to_migrate_one()

 include/linux/rmap.h |  52 +++++--
 mm/internal.h        |  36 +++--
 mm/migrate.c         | 190 ++++++++++++++++-------
 mm/rmap.c            | 427 +++++++++++++++++++++++++++++++++------------------
 4 files changed, 464 insertions(+), 241 deletions(-)
---
base-commit: 61cccb8363fcc282d4ae0555b8739dd227f5ad0b
change-id: 20260701-migrate-rmap-batch-8ecc04de1905

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


