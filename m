Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58DBDC44501
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 07:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F0516B0098; Sun, 12 Jul 2026 03:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A10C6B009D; Sun, 12 Jul 2026 03:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1690D6B009B; Sun, 12 Jul 2026 03:41:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1CB46B0096
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 03:41:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A73F40880
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:41:45 +0000 (UTC)
X-FDA: 84979330170.13.DD377B4
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013019.outbound.protection.outlook.com [40.93.196.19])
	by imf07.hostedemail.com (Postfix) with ESMTP id 254A040007
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:41:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=krcXOpEK;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.19 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783842102;
	b=ClqzEcIoNQCjdN4H04SPt8tlnwLzH6okAdKpomSKCCQiQR//rb4tSe32DMnksOTfWKCPPZ
	u6r1GZVQHYN3ByZ3lrCn5t+k/azIeLxenGxJItGD8/0o67306cMwRO6ATD/eTFZnYwSGj7
	MAnROlLee3LmyQpI53+5EruZ9rb+WRg=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=krcXOpEK;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.19 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783842102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T4/By1nSX/TaUxcLN/jiwd7uO1bHTgeQaXSwpyDwmao=;
	b=UsaEe8y3t0YhSyIu8MeQbKiP96uzLyB5e06Cngdub1x5wH0HHimJzttf4dixPpc0dR58U2
	bCRrmb4rI9tTYGUXhBU8e1xKqEbL93FMStjIB8y1VM10LpN9zInIXjp6t8SIIQmnaK+xUA
	YTRfSwNlS4+FrVpGuvN9PqfBO4K2fqM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XaBSU8sFoFr5qQl+YLaI9r34/ifr+I04384vCh7NdSgXTdTTNny2Tfxs4xOCdNAitNSp3v2yeZ/VzvTHJUt3vg2cZ6p8/Js0XOC2we57zojv+T0Pz8FvZr4ezhZhFz6UqtdqiN/CXm32k039UCSVm1a1BkTOksnnUMi0q8cVP52tqUVHni4qI7KSxWG32u12W04tCXE7evQVXMokGEul2meWTQH/7IoNFumaV6JESnDr7ffDaJbBAvgudKahHqzSEQF0YaBCHlr3ELLM4jFVlX77Y7Zum57lf45lkwjeSnDm/d14bOvI07q+RwIVtzYujcda4flxtxjmaZAABV804A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T4/By1nSX/TaUxcLN/jiwd7uO1bHTgeQaXSwpyDwmao=;
 b=UUbr60gh9uEzrE94ux2AflIR0XT07m9CrvmPIfrp7768IDCC+PYOT1LFLu9Vg0OkmVeNfoaujKL1WEIhwls6qbjTg0iNIaNmWKILI6OVYMtMGWVf4xQ0k2WDyaLX8dHtUXYfvVEMLUOYsZSf0LzNQNDSrX5VRzmpIVWW4OBIhbYp9eLhg1tInLbO0ezQBe6NGmdvU3g8605Ocb4tveglUCeICx63pUQeh5boNGS6kJNd0esfsXwwSeey10hh0K+4+yLffwLWFuIHdBEjTEo94wEIKsHtxuz4aSn3Q0yASqG43zVhG/81bnDeCppOWcmMOeC791+VVjS5P7fVygf/yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4/By1nSX/TaUxcLN/jiwd7uO1bHTgeQaXSwpyDwmao=;
 b=krcXOpEKDH3Du2lcJUH/7h6ew5o3D5PjeXB9YTa20mE5ezIxJ9vLBJ7KFP7vAL9i65acAqOKXCcvdk1Hhb90vUDsdtBcohijEcR5lIvshG3NiWzxK0Kpd6+3IkOHZDMyLrlSPKCzZaE0uSZVQHvq0yqKdnLmP3zXadhANO0OvWw=
Received: from MN2PR18CA0003.namprd18.prod.outlook.com (2603:10b6:208:23c::8)
 by DS7PR12MB6118.namprd12.prod.outlook.com (2603:10b6:8:9a::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.22; Sun, 12 Jul 2026 07:41:36 +0000
Received: from BL02EPF0001A107.namprd05.prod.outlook.com
 (2603:10b6:208:23c:cafe::63) by MN2PR18CA0003.outlook.office365.com
 (2603:10b6:208:23c::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.18 via Frontend Transport; Sun,
 12 Jul 2026 07:41:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A107.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.202.18 via Frontend Transport; Sun, 12 Jul 2026 07:41:35 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Sun, 12 Jul
 2026 02:41:28 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Sun, 12 Jul 2026 07:38:52 +0000
Subject: [PATCH 6/6] mm/rmap: batch the unmap of large folios in
 try_to_migrate_one()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260712-migrate-rmap-batch-v1-6-872a734431d1@amd.com>
References: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
In-Reply-To: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783842044; l=7150;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=DaXaWAks3ni26r5eG7Mgqp8Z7R1+V8py4omKSnb7ukA=;
 b=ptWuqXtlG/w5MOWYfGviPHSj9VRSJnXloZaQ7AmlnebTb5eZBIPSDJfKm0nD+4FpnRYKKBJS5
 gp4GDZBBzEbC2iSijZXydaAPTFBKnO4dcduYaUazT44ap6j7+S7wPEW
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A107:EE_|DS7PR12MB6118:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e0ec902-ce60-446f-1ac0-08dedfe90056
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700016|376014|23010399003|56012099006|11063799006|5023799004|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	BPn8+5xcZ4GnQXoipR4qZCWdppc+TUkZcu0G8/rdnq/bqt1c1bR/UoJStqh22Lk6uj8uA1D+nbKH1Uec7XpqcCXRUR62YnQ3f/GANhUfWh999fgBijHtr8a6JrcWfwDa/g4wR8+E8jkbLc94pwKCJUPq5c5vVSeiEM1hZgprnNtOw1D9wAujfe6M9CEsZAQhiXD0RJ24iLNM01jHurk2HdexAaQacdpf5WnghpSBWiEYxD3JVOK8cqmtHOafaP5aiNGVPK8UkH8sOh98tBPcJqKJo/OHR7h0EAxlJ1GoCbDzvBYn3i6t0JvWm5CAQ4g6zoMrUl8fYHUTHWTJ+r01mRutG9vnLlPM7iN4DjToz+AbPKDLbQGQLAdKdPuOahxQ60Q8nB+jgQHWycy4ABjZposYb/aoZSw9N1eoi741C6ewRaG44CZTyDYJ2EsRNlqNqJ9HkWu66VkGpo3uQHNlGSVq1pDFga/RAEK2WDVJFwlj7ef8KHmwjNOykCeUfHbUwk9G9+OlbaKSxUpAIs2Jc7nKGqmoJ500nF1EsKKyaP7Hm7o4ARBgpY3DFapA+lXUPWqTLAy/l7isgJXeng07IhO8Y5N67VgOwdatn/X1x8DKe/RU5+Ycp5Jv0pxv7x9OVjet5TJeJgcI9q45DrYUP3EcKrXl2q7c7sb2UlLjkMTLxVJ8PVriDGcYXypsvazXeCW9Yo5xL5c8sISn2Zn4+SrJfcdWAa3BBauAeu2Ge+k+AhqIido8/KcmQGp5Baga
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700016)(376014)(23010399003)(56012099006)(11063799006)(5023799004)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3gYw0DT34VqPFUwl9bANQQRC+tfJNWTOm/ZqT3EwqQbGVT5lvsGNs2wrG/FrLHtus2+hfCowlkin04gl8hTt735ahncwGh6TsDdhkL46P0uRY3o2mYaUIBdnzBOAdCnhHOdpCN/xfS9w0GT90mVHZyzRqasM6mbijmpqNk0fKhPz9MNVknKMa+BcJVq+naQYWbNLozxQacsVLS2sFjeNc0r2m5MJUnbL5XzYpLhRwaU2PNcjrYSQ+xkSgMyR04o2dV84+GvSRNM+baZ2vykJsbcGwbrk+3RKwvJ/EZQrg+BBz9cbJLM1EoyCpCSqS5D3/MtwsP4VoHcdwSnlEebQpUVxIXMvQ5tztPuvjEHqNS++Is6SZrEJbTVin1UZjKf5yF9ZP1IFXlYiAEsa5dQ0rTTLadRA9lEB2dU8X99URP1C908vPiQKE3iXHu0xhBTb
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 07:41:35.8768
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e0ec902-ce60-446f-1ac0-08dedfe90056
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A107.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6118
X-Rspamd-Queue-Id: 254A040007
X-Rspam-User: 
X-Stat-Signature: fm86w4iu81u9szagnekdozey49uwpoau
X-Rspamd-Server: rspam03
X-HE-Tag: 1783842102-864998
X-HE-Meta: U2FsdGVkX19vBAAqru1WArvBOj4lPAZgrAQysnmW7XdV9oHI98qcOX8b69UDm/jvX+poANpxrKgJYqzmcvIcugHbLehP9aYvsh3GeGfdUuj2OiLQIGsUyxDXDiRkMotdDYWGxey2ji5qu9UXRZ9k3gX9TwD4KQAtszOHfYizBIa4pgD+Vk2mTiE5yZi8jSiuXlbcjISDIE2OunY5FzD5STvuatLSjpguajBf7mKIRVY7q6mjNYsZGSgAcxi56Bsd1oI1Wi5yizOG+kc7IOLhORU2e5/3oA3b5o++PrphEJbSxD/CbJPPOuBYV1z6Pe0pQnvuANSx1Q77HXh4SRp8Uw7fn5q6PBIytkR8qp42E0PLO+32WEcsQPiFZKknK0VKC5zlkgTUc0BzuGHxamq+sFBEGYju58Gp9GCg6zbOFagI5yH3TPelq4I91/8rKnYDGOVL1Fkcj3HiLavo7wLJdyw6YvxW36VzLPd/oaSlz3cC2+TOf0tXScYwpq+3JfSnVoJot4t7n28hp9UlgCkOusxeWHOx5uINIULpp7WP614yx4lkwmrXSXbu9IDkCu973i8f1YK8tgvIevgSjnJb/2q74mFV1xxP/1OAMCTS5zOuyzR2ESnbvArJBQO/HAywofmrHO5RNkiAeVHH7VkuI+IoakjMGkG9SCFzS1mZ4Y7Gj/Ifk+RLgpMT66C+WmjHltmBKnWplBONqJitRQ9e+5fxlEmcnGRoNP3QYeIMaA6MrhgRxCkYiuBTaO5r4APGVObwMN7qv/Z/2PoTo3yU8faEy7Wd2ZtjXjVWCZ7QAqul9JlyELwNsiubbm+PCki4R77dLowhURlMp5+0fB9bOodGYl5gM7AUaRfzviXDZ3cBbKoWcEUwrWpFzmCIv4n+SRd3G2ezce8sgmY+B2m+PMgYPuxI+LOtfF5fPeLbrUzoKhgKN9mvuwdSfXCElEizs/eWVXwjoaJfjLDpKVl
 UmFJeUhM
 jNEIaVfr5Ww+1GL4689ebGxu4Obu1mwrTdAYSg/mYq7+TvrHakPApyp7obigFj55DQDAKvslnOCvP/6S3E6F3ivGDp/dRoirFIwpZWP0M6NsfUAdGb7vo7RzqaulRhik8dE5V+D2l/BBkff31goKqVRtDLLPAGt/p+rm4LghEJU2ZH2LDTonxsjCMjaYhcdAqh5738yeGyssDQGtBn/S76aBh/0HiRHOcNaFTE/azf3SAdPw5UgLHUZS3PSspCsSPHVLsgMQBKMxQEh/O0AgLzlcRoxDpOsy7horVvmA+KQhFw+Ni6zP38XEeEUEzMhpm/ZgZW70Iz/oM+2FmVo1b4uzBooyQarnfQzUkpSOCS7xmjxu6LeaI4fq3gttc5bqdG8H3zzHkVnPZFh/nSSmjusaqGKBwa4m4fMTPnXw9c7Gvd+kG90gz/Ou3fukVXfKKtzZ4khsjEcTfOyqlyIX/SgsubD3wbhFtyL7dw3CEH96hHam+Q0OKEFW+8JqI20MYAWtk+kLEvtqDbVeftorkihPRBwkxz1R4ZTml586bfs9bH8RhFbJ0LIaieuUnY2k57HcRWADakB/4z35r7WiRPm6LJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_to_migrate_one() converts present PTEs to migration entries one at a
time. For a PTE-mapped large folio, this repeat calls to ptep clear+flush,
the migration entry build and set, folio_remove_rmap_pte() and folio_put(),
each re-entering page_vma_mapped_walk() once per base page (256 times for
1M folio).

Mirror try_to_unmap_one() to introduce folio_migrate_pte_batch() to detect
eligible batch for PTEs mapping conseuctive subpages of a large folios,
and convert the whole batch in one shot using the batched helpers.

A side-effect of this change is trace_set_migration_pte() will record
one event per batched run instead of earlier behavior of one per base page.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/rmap.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 85 insertions(+), 25 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index ef68adba89c4..cfac85f6f68a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2586,6 +2586,48 @@ static bool try_to_migrate_hugetlb_one(struct folio *folio,
 	return ret;
 }
 
+static inline unsigned int folio_migrate_pte_batch(struct folio *folio,
+		struct page_vma_mapped_walk *pvmw, pte_t pte,
+		struct page *subpage, bool anon_exclusive)
+{
+	unsigned long end_addr, addr = pvmw->address;
+	struct vm_area_struct *vma = pvmw->vma;
+	unsigned int max_nr, nr, i;
+
+#ifdef __HAVE_ARCH_UNMAP_ONE
+	/* Cannot batch unmap if arch_unmap_one() is defined. */
+	return 1;
+#endif
+
+	if (!folio_test_large(folio))
+		return 1;
+	if (folio_is_zone_device(folio) || folio_test_has_hwpoisoned(folio))
+		return 1;
+	if (pte_unused(pte))
+		return 1;
+
+	/* We may only batch within a single VMA and a single page table. */
+	end_addr = pmd_addr_end(addr, vma->vm_end);
+	max_nr = (end_addr - addr) >> PAGE_SHIFT;
+	/*
+	 * If unmap fails, we need to restore the ptes. To avoid accidentally
+	 * upgrading write permissions for ptes that were not originally writable,
+	 * and to avoid losing the soft-dirty bit, use the appropriate FPB flags.
+	 */
+	nr = folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_nr,
+				   FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
+
+	/* Limit possible batch count to a uniform PageAnonExclusive value */
+	if (folio_test_anon(folio)) {
+		for (i = 1; i < nr; i++)
+			if (PageAnonExclusive(subpage + i) != anon_exclusive)
+				break;
+		nr = i;
+	}
+
+	return nr;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument.
  *
@@ -2602,7 +2644,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	struct page *subpage;
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
-	unsigned long pfn;
+	unsigned long pfn, end_addr, nr_pages;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -2655,11 +2697,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
 					!folio_test_pmd_mappable(folio), folio);
 
-			if (set_pmd_migration_entry(&pvmw, subpage)) {
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
-			}
+			if (set_pmd_migration_entry(&pvmw, subpage))
+				goto walk_abort;
 			continue;
 #endif
 		}
@@ -2685,9 +2724,16 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
 
+		nr_pages = 1;
 		if (likely(pte_present(pteval))) {
-			flush_cache_page(vma, address, pfn);
-			/* Nuke the page table entry. */
+			nr_pages = folio_migrate_pte_batch(folio, &pvmw, pteval,
+							   subpage, anon_exclusive);
+
+			end_addr = address + nr_pages * PAGE_SIZE;
+			flush_cache_range(vma, address, end_addr);
+
+			/* Nuke the page table entries. */
+			pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
 			if (should_defer_flush(mm, flags)) {
 				/*
 				 * We clear the PTE but do not flush so potentially
@@ -2697,11 +2743,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 				 * transition on a cached TLB entry is written through
 				 * and traps if the PTE is unmapped.
 				 */
-				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
-
-				set_tlb_ubc_flush_pending(mm, pteval, address, address + PAGE_SIZE);
+				set_tlb_ubc_flush_pending(mm, pteval, address, end_addr);
 			} else {
-				pteval = ptep_clear_flush(vma, address, pvmw.pte);
+				flush_tlb_range(vma, address, end_addr);
 			}
 			if (pte_dirty(pteval))
 				folio_mark_dirty(folio);
@@ -2741,6 +2785,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			dec_mm_counter(mm, mm_counter(folio));
 		} else {
 			pte_t swp_pte;
+			unsigned int i;
 
 			/*
 			 * arch_unmap_one() is expected to be a NOP on
@@ -2748,19 +2793,15 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 * so we'll not check/care.
 			 */
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
+				goto walk_abort;
 			}
 
-			/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
+			/* See folio_try_share_anon_rmap_ptes(): clear PTE first. */
 			if (anon_exclusive &&
-			    folio_try_share_anon_rmap_pte(folio, subpage)) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+			    folio_try_share_anon_rmap_ptes(folio, subpage, nr_pages)) {
+				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
+				goto walk_abort;
 			}
 
 			/*
@@ -2770,19 +2811,38 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			swp_pte = make_migration_swp_pte(subpage, pteval,
 							 writable, anon_exclusive);
-			set_pte_at(mm, address, pvmw.pte, swp_pte);
 			trace_set_migration_pte(address, pte_val(swp_pte),
 						folio_order(folio));
+
+			/* Set nr_pages migration entries, advancing the PFN. */
+			for (i = 0; i < nr_pages; i++) {
+				set_pte_at(mm, address + (unsigned long)i * PAGE_SIZE,
+					   pvmw.pte + i, swp_pte);
+				swp_pte = pte_next_swp_offset(swp_pte);
+			}
 			/*
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
 			 */
 		}
 
-		folio_remove_rmap_pte(folio, subpage, vma);
+		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
-		folio_put(folio);
+		folio_put_refs(folio, nr_pages);
+
+		/*
+		 * If we batched the entire folio, there is nothing left to
+		 * walk; stop right here.
+		 */
+		if (nr_pages == folio_nr_pages(folio))
+			goto walk_done;
+		continue;
+walk_abort:
+		ret = false;
+walk_done:
+		page_vma_mapped_walk_done(&pvmw);
+		break;
 	}
 
 	mmu_notifier_invalidate_range_end(&range);

-- 
2.43.0


