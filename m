Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38038C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 05:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 170EE6B00AB; Wed,  1 Jul 2026 01:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120216B00AC; Wed,  1 Jul 2026 01:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B176B00AD; Wed,  1 Jul 2026 01:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6B766B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:18:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5623F1C17E7
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:18:06 +0000 (UTC)
X-FDA: 84939051372.09.5D92DEE
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010012.outbound.protection.outlook.com [52.101.46.12])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1707AA0004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:18:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LGchM97D;
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.12 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782883083;
	b=mr0JYMmCM9YrYKZL2ntdDG7wOwb2r9emcVsN5IqSfCjeLGeRBxJm4ea4QqQC1tHewsyzcH
	d0AuoxGCDni0PxFBF/W/6wv6NtynQhMx12x163T2eCT0cldU9Y3aZPyc37WXCPWWL+o7o8
	F2tczLe6naDlMGS5aXxkCmA+UYjMLPQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782883083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2GzenrHN8qppCvNJluBKTQtMQIZMQd4mbVWJ7g2W6rM=;
	b=UYMGoX898S1aGs/0FT71zbybsM+xXdJkHMaQrBw5EhoDMjepETNNcPA0um125ha+3YoPb9
	Mk2LJ72onHd3cOQro4vcYqg0RK9ZYHd9rKmpQVsY8ZGwIfHNQVv21ZxwMD+NiUQ5NvGa9p
	IsXHJbtjUy11B/K93SKjGWNI9hW2Kqk=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LGchM97D;
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.12 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sRoRMHLoisMm6wm3kpcven5BWjunR3sBzC3JeamgxgUZLtVqQSj4oy7qsx7PaVo/qvMxoXQqxQN0h5pr9IxCv8KDuaEYGzQDWnL0LCSUqLoHB8NGIazGy3YQ/hgl5J4JzGI4SJzlAeDz+pOso5KHgDOTZlpuJAb88nAHF+mDgnhAfowF4QW2ZjXTczo9MqOJUrnfnyTgbDrU01pJ2XExy9aq7fAnW68putCTCvRR4fq9wWrBygDoJaH2FkwWUMoo80qpQ6cI+WgcET5N+Xx2djmRrpa2GTMmNVSmOrjRy4sYUT7NPxJMGZdRnttvhS1E23lMbpo02laBeRctyLY2AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2GzenrHN8qppCvNJluBKTQtMQIZMQd4mbVWJ7g2W6rM=;
 b=LCFr94MZpTU8SWYgW6ufiMgG3ALw4LFld4ziQMeHq58/i72kRC09sDJB+tw3p3dtRRxOjL+00wkt5CKBJX13ZzcKEcTfqbchFAf5VvyigBuird0uqItCfMip8zesYmrXQmCJ+2NcGfYwJRYimDCWk8sk9jlBdf3eHxTeIx+aTAC9cYVxhN5MmXjIV7sNCajog7isjJnfOa+al0VcujVSgxbMGMIBke+0OCGMoYS2NtC1ip2aAxACadrKTBirRuJ3Wpu5y+1vgSRPJDO/L7aRlHrMSJaot4fNehLmnykXbbmsHK2EMUSf9oSmMu8OysEo5Axn2QuCfyd5xl2omA02iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nvidia.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GzenrHN8qppCvNJluBKTQtMQIZMQd4mbVWJ7g2W6rM=;
 b=LGchM97DOPRHtgzJQsb2hoIVA7LQta9T/c3fhrcFXJ93j664JHBba1wUP8ROrwP1Zlc47EFhNq1cK02PA7+VTRe5A72Sa27DMCzKEkYpOHP6E8/LsZXWbpMNCJz5mZRU5HsKF7FAgvUezfqHLiIINrSBQL+4bnce2XsF3iw/+i0=
Received: from BLAPR03CA0165.namprd03.prod.outlook.com (2603:10b6:208:32f::9)
 by LV2PR12MB5917.namprd12.prod.outlook.com (2603:10b6:408:175::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.18; Wed, 1 Jul
 2026 05:17:55 +0000
Received: from BL6PEPF0001AB74.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::6d) by BLAPR03CA0165.outlook.office365.com
 (2603:10b6:208:32f::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Wed, 1
 Jul 2026 05:17:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB74.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Wed, 1 Jul 2026 05:17:55 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 1 Jul
 2026 00:17:50 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 1 Jul 2026 05:17:21 +0000
Subject: [PATCH v2 2/3] mm/migrate: fix stale list name in
 migrate_folios_move() comment
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260701-migrate-cleanups-prep-v2-2-d9e8f17130b1@amd.com>
References: <20260701-migrate-cleanups-prep-v2-0-d9e8f17130b1@amd.com>
In-Reply-To: <20260701-migrate-cleanups-prep-v2-0-d9e8f17130b1@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782883059; l=811;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=zZ0SnL3z77P/SucIFw5r8pgGLDbwv08bU5jF+8zSC3I=;
 b=I8dRQzEsnnzCg7xLg4o0TI7kJUj6gUP8jQ/gh840eD+xHAl9cO0BiEhW75cAkYp5ErvdK07A1
 QdDLQ2yMf1uCdLx0vEgz0WSqWsBHy6KaDDJlfxQdkIIwA8IZkFYs2Yw
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB74:EE_|LV2PR12MB5917:EE_
X-MS-Office365-Filtering-Correlation-Id: c6d7c528-1b87-411a-60fd-08ded7301b6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|82310400026|7416014|23010399003|22082099003|18002099003|921020|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	41jzPmPVKYYVrfTkgxkHEQR0nk26F4FJIMhx0KFxRZETOKnOB1vX8ES7OTLn2yMIek2qvOyvOWXsDe4VfIW0etKtfvHhSN2Ge/GF1df9lUC9fo0INhj3CEILhWJh5SgdR0VW9wfj8UkPiFsNiYnE3iIXnu7K7nT8xyo44DjMD6i4G+OILo5rZRmZ7fT+gA+LGcJ7yt1jmDV7BQIQPocHGBt4f7Ur+ORfmnHimyHuJXVxyFa1dJTV9MrU2d4VYiMIi7LmsnRiCuhwSBTc5valGYt9Y/NwRa5gaWptiW7e6ri8TXVObI+zPi6+2jd7RDbxmqpqLfD5gy4brx03uKD/NL2TmhgLujjp/DAgGD53J9u83zTYS02nactghddkpcELIfdiJBVpUrS37KaQbhgXD0w0txjyY16PKBTFAU0qIO4dwFf7F7a2LtiLNXj+L1wqwF5Rne4eS7qabH0klcrXLg0diZQ4UxzQofDYFNP3Pfsan10WCc3ijuq/HcxWZ4xpQic+PtBNPHGzf07r/rJHNYGCa/z+mpxzMMNS67LwrxKLYpSe3CtBTIVRJdKMXtgfj4YuXZBibebdVy/Qi4YgwBTGuoa4pZuQLkZD35svSsknC3xZkxRwwa/eLUfSGRsRyH8Xw+H3xgZuI1ITDrErjxuCGd+VSEB8wQ70ObqTLNz7eFq5/gFdvch+Ajx2xj40s68Kd0/P6jFDAJBI2DnrOS7V1oLxQN1fqNsgdmjQ3sYzidiOPltWvdloOGGCJzSf
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(82310400026)(7416014)(23010399003)(22082099003)(18002099003)(921020)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	veNYFyppTOBLP1g7oPp74YXcnWlYOG7U6OxjTtuoDKUXZ7KAHMoiCr01As6zlo8oIYI8tX+lR3akw4gRLqxkOIIu8ziX/w8rBvRh8EQ7ml/VewkLyldmArxbTtDfmxH6p3Rn7+88x2IBnmDiU0kceGsVNgpoYOPLwSBYxwigXzgAxqxkDo9hxtEfXZ/PF1G/Nmk5Ky7ykjvAg/PesIDN8lh5TNnslfzQml/pb+17Nepr00O2qq53u48sQaLX4loplq141iM9XU+f3egsj7psv58nIcY0oGF9gz4sqNMqm/eZqgD7/+/Ewlc74g8A+xiIrFlpX3TOuGL3cw56ToMhy1qE1LzxGfEihgLDDkblRzHbXHtGmXqpJRxvG4y78vEzO37Q1aF9dbEiEMXY7JeKrzMH+GejuDsuhfNszT+mcnKtJSFaP5QmpkCuNrGDmkwN
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 05:17:55.1093
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d7c528-1b87-411a-60fd-08ded7301b6a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB74.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5917
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1707AA0004
X-Stat-Signature: esyzytumqdfzd6adehmzwjdwdazosqxq
X-HE-Tag: 1782883082-435994
X-HE-Meta: U2FsdGVkX1/9QXHApYog9vQg+1C2YOAFvWd8VhNRuyu1T9DQ9FRpQMcZSYr9fixfZM2Dre/YQ5jqTB/b8NaukonZZ5r+BK31RnSXK+ljRGToMhFeCsCwN2nhpjWbtNIMiFxkawZ7FkxF7GfU3I/+O4wy+ht9V+ET6LUudQNtrB1CxBqbqgQxebT1YhYS/bFMp1BYodJyu7gQAMd3dfbN+ProW7Tb01zjO/iCxJ1Gw7u2zsRNRB7IvTLkCtqkvZYLTpXr8NjFw2ZMOPrnmQ3NAKJwRaXFwJUkggqp//ENN2wYDuzkMNfCAraAx7cod3LOkUVO5xfhZ5JGpgiK21b8p4O4c5ALJHhKnLPU+OnI8rXrmlLbma9NFCUJ58688TPJKt/X60o/L3W/Ub87vpKeM0PJ9zZga901/EJISqswee0uBdX8ak2gUaLxOqgmUV4aCKiyg3wCz9ir9vQIQ77JoRlXqURkzonS3qd07b4X4XfSXzbXB+b72+W3ZnLoy3mP2RO0Xtr1iX9JfEfPgRmWGh1vV4Z2mMC3nBZ1gjS9Z+SQguDDy1SsFDczouT3HmRaEA223RjV2GlEC7/3vYLBtYbMG4oDlXBAm29clJIxFZqLRoE5ixuvgPS42Fp6yb1k/0ZCprMB680ZDKP1LyrdRhPytNK/Vi8r/o5Nq6zhNw7oGSSlOyeAIglUd6IkvbVVZpjwvuvc7E3uqYbsFp7RF0r/KN5MrM3JpnzA+7Nb4lbK0gpxlzSgt4YNT3TMNSklU1jUEze7quOQn1cjGd0OFGvl1oLxpRvBa2H27Uxq/BJ3zJ5fg4fzdKZtuWH55+04oS42m7TFIkyYFjhC6RN3LBZbRQdqkFUBAGhpyHZLJL7hTHFHYYn0uEKVy1cdntIYmd7Ggm0pCP0CfnKtVlQoNHtQep+wj6Gfhspjzmwmgkg0iJrvjZFZMr7fTKTIZNeZEIoG6U2jJV8std03lBe
 1bD22hxq
 aAVAKGVdqnoWrIbRuJpaMCLaQ0KH0Kh1aw6iYar/gFAzBC8t71Bv4NBCbHy0F0XjdeF/q+gYgD0tHi5anJ2pehLJVPZm8TGTohVaiSZAFqnrTm1qd9Bm1CskX35OO5a+RUBpNsn82WlKr/RaRFLsF/3TS0AQwCF/35hfxKiob/ZSZQpq9KU4OonLB97avrk08sPl18D82INdG3CXa/qsIcLR6og2eyD7L66Q5PN3uIWXnu/UQ3rb8/XHOfti7vmVguprdoDZEOw+JpJTWTRqI2itmCzBuzGEGSVFaJUcw+ggxf0qrHfs9emRQP3S2VGJk41WU4rLX437+6eqpc/qJmxysplYnr4DxepOkW2p7Gu/+IYK+kE/VT/Fq3HEmz1m1u/5vDzX59IgjS5h2t/RFUkmv08p5Tfss1b/R2zxEEKuxSNvenqKgr5ZCGOoOh9pynxe1rHvPunjRURRM73KqB1dILt4ksp4PPeJ58nc+1Jjd36dMvc+P2KXXWiHuCxZaZX1ez6rMl53FJmMgnw7z77dwVVvzpDRNAp/IjlhU5NMOutUToNichutVEtwYOV0lB0o9jtwMManf9veVqODUlxgroPTLweW2wWd7UiOyEBUcBcWtrk2xmXIrtWpx3W7uUajF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The return-value description in migrate_folios_move() still refers to
unmap_folios, but that list no longer exists. Update this name to
src_folios.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 858350ca58b4..5bc81d61116f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1739,7 +1739,7 @@ static void migrate_folios_move(struct list_head *src_folios,
 		/*
 		 * The rules are:
 		 *	0: folio will be freed
-		 *	-EAGAIN: stay on the unmap_folios list
+		 *	-EAGAIN: stay on the src_folios list
 		 *	Other errno: put on ret_folios list
 		 */
 		switch (rc) {

-- 
2.43.0


