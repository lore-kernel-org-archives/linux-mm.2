Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 224C8C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 07:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11BB66B008A; Sun, 12 Jul 2026 03:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2E96B008C; Sun, 12 Jul 2026 03:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F236A6B0092; Sun, 12 Jul 2026 03:41:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD5936B008A
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 03:41:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44388A05F8
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:41:18 +0000 (UTC)
X-FDA: 84979329036.08.39716A0
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011051.outbound.protection.outlook.com [52.101.57.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 258D4160002
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:41:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="F/Y4FxX9";
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.51 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783842075;
	b=Eb8sDGN3DJTdHX/oFGUH2x7NJUJ3ge4ZUAXYCNO7Ur6eDwMACjdR7Oh+wkF324DeUhbD4+
	+Uz1tcY54kkh9FtHTkCiARgOPvCN/WGxfQE42TWcbPui3YyGI2W30rwp9I+gXW9vYb3IeV
	Cu3UOjB2d9qadd6GaKhI971KZ+QXnGc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="F/Y4FxX9";
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.51 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783842075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/1/PC2ZMw0rvgpLweirOTI/UNiY02ZFPp/DXWvgP/E=;
	b=w3b7UBNZ33LM76OzJEhVDsWmw2EMbBuoYWU/ZFqHPwhL6AM84oilHZC2b2syIAJpdVpGam
	T/zEKkcuoERspvecu2dby0QtsbmIaZxSlT3gEvFJgYLtWpt/lUKbPbcVPyHx4ACWq6CUAB
	ZBzZR3IjQ/zW+phXgTS7atDv+GEL1h4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gGrOK4wiIrTn7UmpNWKuEPWWYf77Sog4elqeQRSlW3A6V8fA+7EaCKS1mUvVAgtkWQ0wl9Zcw5e+JE11iu8ZgejQQMxgfGSSO8jnhPz0ymjOloOJrhSiBtIPz828IKrPCAIQEsDRIesScd2q0vZuKcLw58W3vKLvDH8ksgnPERtAnGMeUke1HckKeRhkfj+aLtUwSIIG1TjKWOuvbgaWc4bC9DWa0byNw8IveJzDAcvaq4hZon0SFNpH/JzDljULpb8KowHm1cU8f1/OfpwUivLhTHnNdnGVcr08pDotMkWprOs6FiAOS5zSbrv2DrH0sDgebobLLDVMnx4U9+BrjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E/1/PC2ZMw0rvgpLweirOTI/UNiY02ZFPp/DXWvgP/E=;
 b=HUVcrAN/1YfsTnrzVx/0l8rEeovwE5GACj1NAxhiQwTaTk1WAXBPRsrrs5JNjzptI4anATivWcoMdZ8WKG0PtQWqicAaXGR9fDxAVrRdxbk4IKrL6HLXf3v/C8IhSVYeVHptbDr/WOTh1MhSQIq+GPGwRq4L98ShU9Dkm44ng1ZQpuUEJrNA1o2FBqElj8oDnnm43gXPXR3RizIKtRORRiej7dqSMyGWdA0b1Ktx99VrD6mcSuX0qd+1UCLd91v2ZCo8YjGrfZeiPGQY1R3628BtPC9O9lninqT9ntbfYhuzdVVErIOnGcSroEvD9tdDochcfytqe0Ia1Iz/efjZTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/1/PC2ZMw0rvgpLweirOTI/UNiY02ZFPp/DXWvgP/E=;
 b=F/Y4FxX9iYtnCgT/+oHbWCwE8rEsuF/xfxDFVKlNsc6wO4YNYFf/niqEyKJfYLUuw0eCRCifqN7WPfmvfISKRMNDDJbmJs2kMN+MwKeDW2+3qNdmZ+M3kpCLQwJwsqTkUPJfOl6wdq2084+8PgPXHHap69tL0NtlvRsUT80ughA=
Received: from MN2PR05CA0065.namprd05.prod.outlook.com (2603:10b6:208:236::34)
 by DS5PPFBABE93B01.namprd12.prod.outlook.com (2603:10b6:f:fc00::65f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 07:41:07 +0000
Received: from BL02EPF0001A105.namprd05.prod.outlook.com
 (2603:10b6:208:236:cafe::83) by MN2PR05CA0065.outlook.office365.com
 (2603:10b6:208:236::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.9 via Frontend Transport; Sun, 12
 Jul 2026 07:41:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A105.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.202.18 via Frontend Transport; Sun, 12 Jul 2026 07:41:06 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Sun, 12 Jul
 2026 02:40:58 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Sun, 12 Jul 2026 07:38:48 +0000
Subject: [PATCH 2/6] mm: factor out generic PTE batch detection from
 swap_pte_batch()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260712-migrate-rmap-batch-v1-2-872a734431d1@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783842044; l=2080;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=IqFSvR/5vhwyfDVx/GvRf77BmahPitfvnb9fPwcJzUc=;
 b=Qu4R9pDnYXaCjWUgvj41jvI9UViuC+XkDfrHZ5vSEoD6lrAWzBOfNKJ0UvfIywHOmnlICdYBs
 JRi/btYvrFkCS5PjszyVQex+7dMEPcm2Qvw1iBixGVGTn60F+oO4ev3
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A105:EE_|DS5PPFBABE93B01:EE_
X-MS-Office365-Filtering-Correlation-Id: dfd786f8-d981-4deb-5856-08dedfe8eefa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|82310400026|23010399003|1800799024|921020|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	jR/R+ZSdrw3XocVuFcba7InYmw1KbR2OCSMGgxBNwld2RwU93f4hM0O0IAjPIckpQls87g8/nGllsYuRjoSWmc7JVFN0cwUvusotactwd61Up6arjmx2YnQW/1m8WZfmJGXSpaPuEwldcB7+QQBqnS5JqssNy8hjeqizbUL5FclAVFYy5qvut3nM2tq/rWSWf3YN4E2LyjPWGJw9vxKCyt4s5vB5kROnayF/Q99PbmPbdX3afnhmDiT0RWyPPnXxTihCair0z9y/5ayhUK8hljiAJPEAChPidqTPNHiNPrpOvcFpXUim5Fwbu+3YFmPb6qZfgYm8zrE/tmfy1TnBPSmqg7uwBAXBJIgZvRTJF2f2/aIZ5YGzVLqyceP5WmlccaJ9uWWCgC3MIUuUeKp03PqcS2nBqHcu1Q+AktF0yEv3A0mMPEKuGXbBcTfoGS9c/vEByAdi8uH2IiVhYpeAwwRhyR+C7ND9i4DxjTp5VlFNk5IBB8euBfuWubwVVUX718YjqgNwwWRa/iw5MYkXkifx1Za/ARbOJUDgxS+Mqmo6d7Fe2qN9WqRWuQvCqDURtE1IMO9bNeJy6I6kWN7iyNzR1N4PbuoDR3VEkoChV1Y0eGjIl5GyOjNgcisT1tMsCUI+bxqTtvajIZYqiobCjzKsZSgxxpTZo0BCg3baxMwKoZmkSQNWj2qVeYA96/Nn8d51YaLb5wrN7HYVNbqNoxSSAFqSJVFJAoSEtvXspv8=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(82310400026)(23010399003)(1800799024)(921020)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6hne0cYhMbnR2XpMTn9xzmjGk8mp4EheUCU65QrQp21yJG2HtRkNx2LSN/4jL/k0rFNDcV5NdXINJGl5od6rConaBqIvJNbE2x88IR2AfIwoCIBCVmJL/BUAAcmvueLpRjxTH/TKt0Q1CQKfcMq3xBMElOqm6NCdgYJ7SGL2v8obJHjkCMp+Sfri3sPDa6ZLtEfU56TEPMIDxeH1vRMUmF5IhPfNOWLAOaBBaqH20ZRyOsG/ReufPN8Tw8hI4fyw5OO+9/Vy1oHnlNKV4fDpOsKTG+CBkpdODf2R6BzCOimV6ItxYKm/cG39Y9bbzfYEowOUWs+rlY/zgXeMNyAnpMe/nFOxBhPP+yacuWZ/3V3D9BRB4irUVbmisYLDO0pyPrqqXAlYdbQYmP9PsGuGGfc9/forIaLcRAaeU8xuqJQyCNMY7PlHC1jfEL635zTE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 07:41:06.7547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfd786f8-d981-4deb-5856-08dedfe8eefa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A105.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFBABE93B01
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 258D4160002
X-Stat-Signature: 8mby4d6yr8z1f6kni9m5ztzmtf8bsdtt
X-HE-Tag: 1783842075-394108
X-HE-Meta: U2FsdGVkX1+aFIFIgtVYX1dAAWzpT9/cr9ls9NHRcOB4UG7f2tBOWSNWzAzL2jX/DeiRbr6+yOKLP6RZFmREiZa2PVhTsVoj4iPXXmopw0fcWxm/jLo3tRNQIE++8mRg/LA80Wd1UFCex5ofhcS3axmFsZpqw2hnrDFXw8tnQtkcs5Gy9bG4wwl62cChArkrxfXfEKGzhxyidEIhh9WmuMK+9/AQTmT/tZyqWOL5P7q043hCBf+vitWath7A2OjHmLR8NAlij3zYaTXurd4HuJhxnndCQZ6i02YbpsuJACRTRPlYP5GCLq+f8A2u5SxhDjDm/Ww+F5d9BCEWJeWBAqdaowZf87hlqr1taYAkXJ18ucSCNnWjq45DTHTSMDA8CNZEkaQWuRQUpH5ertl9QDVAkzhJ0DpKuJgkxFwbwm4yUwHrPPT7G/1zMTbwGx8OCXhp34TIhvvx+y8cWGMsRtiqycTIA79omBiBWotjzHt2jRMyMMaXgApzQsjGcrzDP9PZwzfSh6Wb9GHxgdeQRWrxIhBWiRCX6D27wP9VTqg7OHDuoVcLnucPDhT2TMbYjA6KXqY3wceI39WZCWp+B9Ky20Ho+rAqh22ycvHvEDEInWIu8aXMMSqHTTY4qZcVipvrNzpGCGc8VIxBPhfcX122ehMvSACj6ds4DqgCs7+SsCoPidhmPRPHXlbml5XaPUldfwMiIA5ypmw8uNfdvOewbwFvQlNYgTivUk6UMpfqR0V4bvF03PDawug+1KQ2wT87yCkljpETfxRmTzHMjGkek0EMk+YjU6WNSJf+9cYPtSS6Oq03UH+bGJRfxsG6TyPhjajZrBuVzL2ogQQuXoZHtSwELWkt5pxFKGalQ/jKb6DVI3E/EdDl+VzLK18t0ryPhbZpiCPfuyKNKKWyC5AQ6euON+kMcZdwIWyHUibz+RlK1GLk8RsY9qQuRIuQ0E713XApUWUqNHR/2eH
 k4NQZthz
 A0wkgzsIJ4AxrUKFN1Ko0WW7wvjrl4oBOi1krIjnSxCcRkKZkkKFqxHqzlO2KNAQEJFeRfHYtXsX4k9+bToyfB5TaIpaalxGCTvcgw4NewUSqxG8wLB456ADrpsjWFZvyEBsquGe2g11+c9jMAcOPgxBi1jV7UcYIWEjckUat27WVzJs62oqracGLEjarmrZjicxBxNumrMrPbIzuDsH2CcqD+dO3fvqHFQVvMydEpN10FGTHsPaRqI2APuYz5bIkgroDO6CeIkIC/4hWm1uUEzcnva7l1LhS6ot5fQLd/IiMgD9gng8ms4qFO4Vav0G09A4DuEJhAYdatntZSr8MA2I3a6W77kk302G9SGkczRlV6fKhE3Pb7Re5U1iHA211q0/mcpifChhHsur1ISMcw9kPMkoG+YgM0gjo5CgTEtoAJk3V8t51AjA1dwp3SuNYFVvIwnXQVAUACxDiZH0NETliZc6rH7vtWRIu8DFR3Oc3/D1MvvMXM8/vm62iBTL50oO/k5Jy661POF0SzcQc/+wPaNsIGg70yrhqOusOrQWEmPJ2oInIZHPrcURNCa8Wo5I08HvI94iCTbs1A+X6z5J6hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Factor out the generic PTE batch detection logic from swap_pte_batch()
into softleaf_pte_batch() helper, so that it can be reused by upcoming
patch that adds restore-side batching of migration entries.

swap_pte_batch() now keeps only its swap-specific concerns and
delegates the batch detection to softleaf_pte_batch().

No functional changes intended.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/internal.h | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 874be94cf257..a90721f8c687 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -505,6 +505,26 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
 	return pte_move_swp_offset(pte, 1);
 }
 
+static inline int softleaf_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
+{
+	pte_t expected_pte = pte_next_swp_offset(pte);
+	const pte_t *end_ptep = start_ptep + max_nr;
+	pte_t *ptep = start_ptep + 1;
+
+	VM_WARN_ON(max_nr < 1);
+
+	while (ptep < end_ptep) {
+		pte = ptep_get(ptep);
+
+		if (!pte_same(pte, expected_pte))
+			break;
+		expected_pte = pte_next_swp_offset(expected_pte);
+		ptep++;
+	}
+
+	return ptep - start_ptep;
+}
+
 /**
  * swap_pte_batch - detect a PTE batch for a set of contiguous swap entries
  * @start_ptep: Page table pointer for the first entry.
@@ -522,23 +542,9 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
  */
 static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 {
-	pte_t expected_pte = pte_next_swp_offset(pte);
-	const pte_t *end_ptep = start_ptep + max_nr;
-	pte_t *ptep = start_ptep + 1;
-
-	VM_WARN_ON(max_nr < 1);
 	VM_WARN_ON(!softleaf_is_swap(softleaf_from_pte(pte)));
 
-	while (ptep < end_ptep) {
-		pte = ptep_get(ptep);
-
-		if (!pte_same(pte, expected_pte))
-			break;
-		expected_pte = pte_next_swp_offset(expected_pte);
-		ptep++;
-	}
-
-	return ptep - start_ptep;
+	return softleaf_pte_batch(start_ptep, max_nr, pte);
 }
 #endif /* CONFIG_MMU */
 

-- 
2.43.0


