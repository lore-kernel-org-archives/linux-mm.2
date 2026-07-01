Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15B07C43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 17:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FC796B00AD; Wed,  1 Jul 2026 13:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4036B00AE; Wed,  1 Jul 2026 13:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C50B6B00AF; Wed,  1 Jul 2026 13:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 598076B00AD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:19:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C92E214044D
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:19:20 +0000 (UTC)
X-FDA: 84940868880.17.6B331F8
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0313920002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:19:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZzwHSzAj;
	spf=pass (imf31.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782926359;
	b=TEzZ1ePys9ujWC/pZLcnr9DFEk9SmouCyz0OM6+i/bKbiUAVTzREkbjf97dAUWqcNlExq9
	vWnHxtDkZTMLns4PEwVi2sjbSHaHSiZCn5dupSp+CmHjSwvKGmFSQIZtcqdQRpBlkep0fK
	ViOjuV4B93ocrfI2kFRxWhgmyajCpvI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782926359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obKytdSgK8DmwXqyL+Uzle0RrtZhdlqOEa7faS72rK8=;
	b=M/AiusT83J+wjwTwP7gHitqkf85ly4mb/aCLBAFW4oxP6JKJZij7pbPVLzoXWNpHvxQ+/1
	3ap+ObFOAVVTi+lsjU8UZ7mlyhtYi72/NIy5Jp5t0bfP1Iz7YsHBWNxShZF3DmOsgksU37
	atw9+s14HiG9Cr0ajvQxvVpWA1ocyWg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZzwHSzAj;
	spf=pass (imf31.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84780c95e2eso540754b3a.3
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 10:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782926358; x=1783531158; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=obKytdSgK8DmwXqyL+Uzle0RrtZhdlqOEa7faS72rK8=;
        b=ZzwHSzAjeg2FNS4RtT3zOd4mq3Ts7Zo1k4ReiLqNBnDbYQpKOJ7ix+R/WH0qVjtXcC
         91Iv0cMEfYGTQKAz9MOzbcByloMtx64mVz5IgZE9O1qWDn/hpbLE2DQzuK9kBFnq7Qdz
         dlLUpYfHp3W/0n6bQ1kiDAE72fMnpl1wPrsZ5GPte843wYpi2e8WYuJdSv+H32dOqgBc
         URTCRwCOzJRjztgULl3+xBtA8aiGZ/+a+sEW6gsZwu8EGSEn44i/dxsig5gAtm+e+zV0
         oCW28Vnl/FD1miPHThHQ/Re9sJ/5Tp23yyoG+26PdjvqysexK50fBW2HOYk9fyhJknFI
         /Xtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782926358; x=1783531158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=obKytdSgK8DmwXqyL+Uzle0RrtZhdlqOEa7faS72rK8=;
        b=JGsMG/C97sE+/gC14odPPW2DlLa6QM63MusKms3oEzwkG+CnbxrKWFkMYAvSPhJA7k
         ecqKuRCybPOp5m0Sqp9E0ZnyBcgAtq2IHqovxSlhibEqcZomoKgtp62Do6ydKpwwJLGa
         US8MP1eW6/mIDKDDJ7C0c3M2qmRcUPxlukdjXTZDbKwV09E7C69uCi4jAJ0SCdHL0h+y
         pWynudfRZJj93C2d6Sd2rarNKhMw9Ef8V+wh3hmVW+xCwxPze75kOTgwumIqdbrt5WIq
         NLc0yABBQFI3l/QFgRap6IrQKqCCKJwB1Pr8iluucc4sS+wclHi4C6CHCJ41Bqszx3Xo
         XIUA==
X-Gm-Message-State: AOJu0Yx36VTyH4y9R+mFM3Cd/M8v1GOENjWt/ZJ+iwN4Gtaa7uMcQ/Xe
	jbRBNhvtEoYFCuKqLfnHP3wMKjvfiMhYhpnmUizwdSEMlOQXr8V6bSEM
X-Gm-Gg: AfdE7ck1lG4kt1duuxawy7ztaXvj+X9BBbWUBE2vEkO4N3mFn1actzt+FObH9x4GiPH
	IPeipcAnxGEEfEDoITEGHgVpoozBvZGojeYX/gOwbH16wxadh9bVGm6VSt9OBIFwbn8y+vmo/kg
	41bc1hNRUTHlEDOoxpqt3MdmwYDtEOubjYBrHRBF+JZlNvsbzKvOEGA0ZO65/AccunW2MLZD03J
	6FuCGm5hAF+ogrYwNMiWpEMtqvPL2/P3wYRizzdUV/JLT20QDfGiKZlq70xFC+j/ziPbJfS80Ph
	iRub4nRm7hjbjhD+TfVTWfGCkCcqgQZufwB33miRBEg0tLmrwElmYnlEl34akpvhXhtSS41OQ8n
	9Ocrl3YH+XifWMpMN/49BFk/4PKq7cNDjX3un6eGFnhh2j2jLFLxWfYEMKomFJYQ75JG27xoNSp
	K4tmYl+zQ=
X-Received: by 2002:a05:6a00:b4e:b0:847:7f0e:1ac6 with SMTP id d2e1a72fcca58-847c5070041mr1582243b3a.19.1782926357933;
        Wed, 01 Jul 2026 10:19:17 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb94ab79sm105719b3a.31.2026.07.01.10.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 10:19:17 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andreas Larsson <andreas@gaisler.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Rich Felker <dalias@libc.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 3/4] powerpc/numa: set node_possible_map from node_online_map
Date: Thu,  2 Jul 2026 02:18:50 +0900
Message-ID: <20260701171851.2447626-4-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260701171851.2447626-1-ekffu200098@gmail.com>
References: <20260701171851.2447626-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0313920002
X-Stat-Signature: u6fah7371yg6drat9m8kny31xroy46wr
X-HE-Tag: 1782926358-799545
X-HE-Meta: U2FsdGVkX196v6Ba7/YoP0UqDymrtjPuV+Zjwq2SqeqcDt4446+N0qXgDVqtXHoPTGZwSe0pQvLnpT+O/P9beBpCEKc/a7jiuTQqzMf/QHorkJFIgK1b32OAE6bUyL5pNjrZq6vjiDxhKMHxiYKfUBN1UcpqluzKzroOUde6L5H0N/3Wa1DUfGWaMENnnb0LXJw7G0tt69wOgoiVazq87U+Tf4PkcH6qkC/zs9O1a2Tg0rSye3qdUyeuCP3PSTQeHolpbn2AiSURB3BgUQfHOU17VwQ21LrhdkPKzG7/beC4DOOGkxMB2Kp9W+mFWlk1QIBU6JHl87wV1y8PZ4YxZ+XHdf3TbqPjOpN2rviSlK0ObxZImMBFA8MJnut/seMD8RRbQt+N5W7qLGZC4LE4Jm5G4fySP+IjvUBBSQ1TmNvlOrkEZjU2OuKeEKSuScbtGYxcdNiBQ5LZNLXPoyF7abKHcDwg34NQXL1RDDj4tHyV1vnYb2m95oeHSM+lOiTJE4Kwr+RvVjE83/UVsjHuEwS7u5NoJC7Bsl7IMhw9uyQH/dtHcekGzVIUALhNcZa+lPCcY0wG3CuIxN2az5dYym/yQPFR7eNPMH3x3qbTVEuW8+E/XPy8kR6lw+su1EUImQna97o6h2kolRyLuCqLMakafsvZUg0M9sECNMZV0Iefk+I7UeGyAtndO1iLlnWqTW8BN5xRpxlAmjMIrQELJSVKgBiAcvDMkKEo014SF28j1NQVo4FbepyW5Clh9CLz0MBIVzAc6PbP4V55FMsAVBSwPKAJCkbCXH2crJYp014MdViMcgGqlOR2uqxe1InoeQMz/YbH6N5YX8uiOx9JEQwIS0sAtKLXRf8vNFaHeA2LNKAbZX/9yhBn8oU7jAE5X+7a2X2/BZePMWFOVrybx+I86p1pnZQzvlleelgiongSmYjG5rzOIqO4h6YTLChI/UjS+G83GgO4OsrB9V/
 TBRxlj1s
 FHclQex9fQ9sKKCz9anheikm7eSjZG3Plt5WB9n1Ucg6BIWG5B3Rr606Kl+9OL2QFNGvYrCFAvvmIZ2NwZrZNVpm+L9EZKDTTeDxWpDzKx0IWNU6Ez/BWITEDudjTPR8upHk24ROmfHfV0Sx3qbR+23loY1WyerR5DU6wmEhOY6K9iZy9pwyuKsY0wogldaMdR0m+qnbP8CyPN9Q+7epyrfREO/ue1Kp6KQJ3Re9ZgPWAQS2UBSc/q6V0FS2ndXoK0xskdvq44D96+um4aS+5CWToOLmdcnIhWv/TjYS49Q5JMdvKmcjh1VgibLm3bk0oKHnIqcSQw+oU4Uyu4yyOqmSPzIhJ5NDq1opDwYZdazZaM/if8lSSqbaYcEnOemY0CwLMXmgpq41PHmU6pmn2xhByYgxZXXArF0EpgybTYdrwaTwqYUwS2HDjK9Kkh3OrZpH7dveOFdjCMmZdE4YAGCFb4vSYf4L74pxLB6qgZnuXNL/SI3I2V7gbcpg648dYltylksHg1Gl9eB3/G0UEffGQLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_topology_setup() intersects node_possible_map with node_online_map.
Nothing sets node_possible_map before this, so it is NODE_MASK_ALL and
the result is just node_online_map.

In preparation for changing node_possible_map's initial value,
mem_topology_setup() no longer depends on it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 arch/powerpc/mm/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index f4cf3ae036de..2fdecae90a01 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1179,7 +1179,7 @@ void __init mem_topology_setup(void)
 	 * that we expect to make use of for this platform's affinity
 	 * calculations.
 	 */
-	nodes_and(node_possible_map, node_possible_map, node_online_map);
+	node_possible_map = node_online_map;
 
 	find_possible_nodes();
 
-- 
2.43.0


