Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59B33C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 04:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31F9F6B0397; Thu, 13 Aug 2026 00:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F74D6B0399; Thu, 13 Aug 2026 00:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20CE36B039A; Thu, 13 Aug 2026 00:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E97C66B0397
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:24:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6ED771204CF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:24:25 +0000 (UTC)
X-FDA: 85094954490.05.4FBB968
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010022.outbound.protection.outlook.com [52.101.56.22])
	by imf04.hostedemail.com (Postfix) with ESMTP id 411FE40003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:24:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=zAeAi6of;
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.22 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786595062;
	b=UCbO7DhnmPOFsxL2kjG3J063hRszgEOjoaXe2lJ+mGHuCL/8NuuyReLBmbI2D8gSrjflZD
	mexmLaGevQNcOnmXv2ZzMrnqPfv2pkViQAxyy8VTIWlspRowLd2zPA39W0QZlHviL6dMNG
	ZwzWNeXGCEkp1ohBNuYE7pGkdPcW/Jg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=zAeAi6of;
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.22 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786595062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZx0Ge6ZDreH1DBnQvrfoLUwMhi3ucN8qoNiw2CdSxg=;
	b=A/yLdS3F1d9gO5ZZsbePkZrExmTt0faK/CcSkObScFp+NG0a6/pUN1siPyWBpp9W91VmAU
	PXYEiLoAJ1iDIVs0Ze+QJli6jrHl9QrsGqSMNuhLUa9lyi/NCAsTkE7JOd6JgYV5YVDO2x
	azyTh7aacwWn5fl3mUrnri9/SWk2jnw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EXVMW5qEnmUHDWdNP71mDyTFXdduGf1y2WaU3i49/eTtN1MCWyUZaVQRl77Qq0c8yreW/z1HwEo/PxswfXLGaHOyOzuqWsdAJOk/XWH7IiRq2H+Pn+HrQMU5jUKTRhkiE9bUVLVeSEUET/JcfKhJpeZGm3op4IbFqFsLy4jfWLAovIWW1yzyEVaHsZC507M2BA9viDNZRAMfUPD86cmcDjq8sXfxUVxg0Wd5OigscmHGaifTqMQBhzyX9XkJ0da2xUae1JP2xmU9eMIIFg9C3IgaG/EdD77lmNVkzw4ioNzRBIElGq3Caae4BvZl4FX8pmivDh6du5YvCMdaT59U5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GZx0Ge6ZDreH1DBnQvrfoLUwMhi3ucN8qoNiw2CdSxg=;
 b=PiNGL6U45+kGxSI1PPM1uwCAwsdqgrt/ys9QtjlOs3zyqtaacaP9r357U2ZhjrPr/YyHswYcV0ROH/bZMQf3buwmRmwhZrmybiD1OLEhLkb32BIv81irVh3/VNiX0PTKxJQGhG0maiKaF3K1CoK2xuiukt2UpDoI2arX3DU558t/nHI8sGEbaCz3U+qgnAHEkka3EqQ4hoD6AWECAENxDT+sMKVfZ9XjVm+By1knYq1aNAHHEDbbKFVrUMFZs8NOZek3UVYlV1qsqGUKjSDj9tzkM1p7pqAAYeUKhwIGeaS4pMvwZcL6S/+4itgBorRkIPQj19nPKisAYfQE/RcNKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=surriel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZx0Ge6ZDreH1DBnQvrfoLUwMhi3ucN8qoNiw2CdSxg=;
 b=zAeAi6ofm9bq8LabrTWNBcHZFx6fDby7dMbhNbiOVXUEQlh7rDeKjtZ2zQ9wG5yFbRgqLu/TSTFNIANwEC53wXw70dl6pmj0LZ25AiwGZQ5R+d8IlkPTxX3N1JmEMJ5eLoE8fLHUougUNDzMsr0d8Q+Mjg1mWKe6gh9EkiJpqgA=
Received: from BN1PR12CA0021.namprd12.prod.outlook.com (2603:10b6:408:e1::26)
 by BL4PR12MB9536.namprd12.prod.outlook.com (2603:10b6:208:590::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Thu, 13 Aug
 2026 04:24:16 +0000
Received: from BN3PEPF0000B36D.namprd21.prod.outlook.com
 (2603:10b6:408:e1:cafe::81) by BN1PR12CA0021.outlook.office365.com
 (2603:10b6:408:e1::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.14 via Frontend Transport; Thu,
 13 Aug 2026 04:24:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B36D.mail.protection.outlook.com (10.167.243.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.0 via Frontend Transport; Thu, 13 Aug 2026 04:24:16 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 12 Aug
 2026 23:24:09 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 13 Aug 2026 04:23:13 +0000
Subject: [PATCH v2 2/7] mm/migrate: factor out migration PTE construction
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260813-migrate-rmap-batch-v2-2-3c5424c555c7@amd.com>
References: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
In-Reply-To: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786595034; l=2695;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=gneolqKRhOLi/xmG4jUme2u1klegVcoHCUCJUJlgL98=;
 b=R/y+I6Jl1+vGPpMitwmnPsCU2+R1U3wNMIW68+2Q7iSi7GEBcH9vabuuNNMpVDVORIykNqwkI
 JnwADKqjCn5DC6d3Ad3Q2Q9x3RxlPLGg8af+7Y7g6H059bW4ZAYsyMv
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36D:EE_|BL4PR12MB9536:EE_
X-MS-Office365-Filtering-Correlation-Id: 360e2414-83b1-4f69-970b-08def8f2bcd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700016|23010399003|82310400026|22082099003|18002099003|56012099006|11063799006|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	9I/kDeKKpO+oKUL6vDJ/plY2EEvQ1wjL8ZyUvRLWXCTEyPs7NYplcAc6YenelmOAR4TXt8gADRF2LeoABSYv5b50iuoehUQtH38uXjGCmQsngaGFxUjohBDfLXWpAYEXrlovJc/UjcAz8WC/XSEqxdr57hQdYiB/I+TiTEb6rwKpR7WJIFSvBdEdk5J7pKWQI1vcssKM5+Wis7xvlF7AyLw1DAcZoZybyBBFZnJXSSXqRIHJ9zo2dAxoM/b8lCOYbElwCNicujnRE/0sGh2xdvj3uaGv5f+H0kUZxrFlKmyTYFtzy5uSVoUJ2Jd33IH6R6dMn52NnXkNuWgHMnuho8rLCMoWkkTG0nRn2NZbgqfdLoLihF9HF0hMNeZ82JTs2K0kJRYRyoMtaScRxC/BZwNzJqe8/YZ22AXaL/3pvih8+OS4V4a1Lqy9KC9k2Ti6in8H6rogGn7/9bLuwzN0geJPQExaHnLNuBWj0eTMFyZV2tspAt5AS78KtYefgLGHAsEaLJBspmLZi6yjrShFHMUqOh9jcQcjuAwmLrR0nZ3Ywa2BhnHm6UmSMt4BjKg8yFeS2M84FZqayzGzCGGcD17rphZHePHwIpAKucEYoT/3hBdBeTGeV2l+YaHmdYy/QJwL6aTTkBqHDG9omBg0usHi07C1WK36BVH6Ag6jktwvBCvnmt5qZ56wslqoPT+8J8pIYlDH9z6R0hBVnKnmjtW9aBUOt7rvdWNlCabOOwogCiVC7tVTrMOAjRF3oKfy
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700016)(23010399003)(82310400026)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	imv8K8hM9M7qcVsMX+yH5EmqjMPDbAgJCcbgzwGwq5/BNJO9xcXtzHcHrgoeNvTsHhb6WTvarzlri3fpuSpa0eADNLhifkq/nVRGXtPvTTwR08V4qyc1QQAg9tP8aHeA0I3Bp3YAuZa+fK2a5Fj/U69tCjYlZXg3+Ytd8dmgqW1e255/WTtf+ZE5EVOi91SnU8MBxoS5tZ7kpG+Cw9vbGv7/P1o10EsfB3VYGMY1U3dA+mSugtUo+BPpH+OR26KcuyHzbl+Q4CIfzv9YTJ4cM80wnyWclHbGof6ALTtXOVW/tr7r/34h5eiVdsV+XgA2Mmq5xUN0u5/4cahc/5Qdz2GW1levG/sjhNSXCvRDl/WePlEmjt4SEOqu9sR6DtCU/0OAr1odo4y7FSZ8qTMomnU9zfKWkPlzZHDuG4ZoantUyXhpHXGBtEeFAifB7mfO
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 04:24:16.6531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 360e2414-83b1-4f69-970b-08def8f2bcd3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9536
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 411FE40003
X-Stat-Signature: kwoehmfouyxa4b9e5u569qe7gyzuyyi1
X-HE-Tag: 1786595062-349223
X-HE-Meta: U2FsdGVkX18tVsTttq0OpsB56PwwiQZ5JrhHoaI7+iGZR+/AF+xHQwSOMrguQZe+F4C91d3YRaXB9riUIKATVG5YgOAR9V3YTebv6ozqpT5HW4jxmpo4IkRxW224Qyd5j9LtFG9Ak+eYUiOjLaTy5l7/pYG/+wuxfq6bnZohiqd4HtZg4p94Ryhcw7mIj2XlhBONHGLFcshVeKaBZ/GZG8i/18VK6cDg2laRe8gKd8TrWvZgQo9UrgehXc1kslEZOt4cTTCQhz08SJ6iTafxdAAibiCjp0WaQ4o4cPzmdAv0rTruUVMED6vlwrCa+gKggYBC3DxBxmLBc6EtYXmHrR5Wvh2Kw7cDQLKk+SoJ2+kQhblssqGZ3HyuBwArE6ViHy/bhpGevAswvaxcAfVCK7dNcj1S1nsHT40M4PUq3kFZ83YRtVzvQmiGDasfLwjCdaAcnY/cWj/bL4j/GSyBeRPRswqf52UAJSYjZfoJNU00fmlOn0d8Cdr2lhhZxixmnszw9HWEhIZOlLegoz0i/5N1Jl6Mdvw1ddUHNz618VS1bEBtY/DQfFqHiy8a/dSZveo2rFla53uWRpCC+pTTmy2zFn9ahBJlugkPfDeFavKTDN6jHQU9ValRd5V7qQeH3p86skckyvVwEKkrmQif+BdZvd43HQRIg84w+c42ekY285bHhCMuEcW/9FKgpsokDwZ4zI8yHHTo0fJ3jxS2AkLDvcPjmYIELYES1/eTGIY20PnX7Ack7WesHQ2f3WyIIha/hgO/5TOQ3knX6zpOjel1LVlLe3crMCuSqtu4KaYmg2KhKrwY/S0CiIU27MxrxwNXZXOo5dQqSh03oJxQ79EGRSDFcs2GoG3ed8bq+aSXiREBcXs6/93p9nFLi6VH3QD31t+TQJcHPAAEMMadPH3tuKzwGiNAulVwwNJPnXIoBleQTCZ8A4sJ2Mgs2EH/nC6L5YmjDue/+hKmrce
 AKYa539/
 euoHu+n/7bldcCaYIytHjMSGTw84uDgZwVq8Nm9witetmqCZup4x+om/iwruDsZ6jhT/bwG6mpf+gJd1LdAv+CvBOJHWJWufH5+NoW3ckuTq4dSUbyuYlFbkXE8qjxQnJvYiwlsjMG0lWucRmFcX2hXhLHhvKO+BVXLXEQVCThe445Xwpk++ZmHh+1EtOLtPc0EsnbdI227L5pjZuNxYjyna+R+tL3zYd3Ad/CE4OrSvb8ABesEI7h5LLFCDwGS6ylWDZqKd4kgDpIfaWwrHfATDnFvoWlvdVptaoxoBVkYwsuWpb0SrojlUb+6/xTPMbyGiB+FQdVClIjUxxMf1OVBkCbUlPzsDs1bFRD3Jp3Y3GaOb59lbPalzMgchP8hPntUX7zaGRM053PPlQDwamGjMmcnn2kGZZ0BNIDuVE9pB44bVIreZF6zT++H/WzG0VcU+yhhULcnuihyzu5PZ2UkC2FIaPvlBvjGpkvqEQx0A6GK0Pkd0e4Wi52pHwi/D3lok0TJaNHDmpaRLuclbEuV2gw6bg4KM8rH1f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

remove_migration_pte() constructs a working-PTE from a migration entry
inline. Factor it into migration_entry_to_pte() so the logic can be
shared when the hugetlb restore path is separated.

No functional change intended.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 53 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..a3362cc9ef66 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -345,6 +345,36 @@ struct rmap_walk_arg {
 	bool map_unused_to_zeropage;
 };
 
+static pte_t migration_entry_to_pte(struct folio *folio, struct page *new,
+		softleaf_t entry, pte_t old_pte, struct vm_area_struct *vma,
+		rmap_t *rmap_flags)
+{
+	pte_t pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
+
+	if (!softleaf_is_migration_young(entry))
+		pte = pte_mkold(pte);
+	if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))
+		pte = pte_mkdirty(pte);
+	if (pte_swp_soft_dirty(old_pte))
+		pte = pte_mksoft_dirty(pte);
+	else
+		pte = pte_clear_soft_dirty(pte);
+
+	if (softleaf_is_migration_write(entry))
+		pte = pte_mkwrite(pte, vma);
+	else if (pte_swp_uffd(old_pte))
+		pte = pte_mkuffd(pte);
+
+	/* See do_swap_page(): restore PAGE_NONE for RWP */
+	if (pte_swp_uffd(old_pte) && userfaultfd_rwp(vma))
+		pte = pte_modify(pte, PAGE_NONE);
+
+	if (folio_test_anon(folio) && !softleaf_is_migration_read(entry))
+		*rmap_flags |= RMAP_EXCLUSIVE;
+
+	return pte;
+}
+
 /*
  * Restore a potential migration pte to a working pte entry
  */
@@ -387,27 +417,8 @@ static bool remove_migration_pte(struct folio *folio,
 
 		folio_get(folio);
 		new = folio_page(folio, idx);
-		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
-		if (!softleaf_is_migration_young(entry))
-			pte = pte_mkold(pte);
-		if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))
-			pte = pte_mkdirty(pte);
-		if (pte_swp_soft_dirty(old_pte))
-			pte = pte_mksoft_dirty(pte);
-		else
-			pte = pte_clear_soft_dirty(pte);
-
-		if (softleaf_is_migration_write(entry))
-			pte = pte_mkwrite(pte, vma);
-		else if (pte_swp_uffd(old_pte))
-			pte = pte_mkuffd(pte);
-
-		/* See do_swap_page(): restore PAGE_NONE for RWP */
-		if (pte_swp_uffd(old_pte) && userfaultfd_rwp(vma))
-			pte = pte_modify(pte, PAGE_NONE);
-
-		if (folio_test_anon(folio) && !softleaf_is_migration_read(entry))
-			rmap_flags |= RMAP_EXCLUSIVE;
+		pte = migration_entry_to_pte(folio, new, entry, old_pte, vma,
+					     &rmap_flags);
 
 		if (unlikely(is_device_private_page(new))) {
 			if (pte_write(pte))

-- 
2.43.0


