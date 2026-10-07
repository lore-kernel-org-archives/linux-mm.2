Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECB4ACA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 15:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6BE6B0092; Wed,  7 Oct 2026 11:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C572A6B0093; Wed,  7 Oct 2026 11:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6E196B0095; Wed,  7 Oct 2026 11:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96C006B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:35:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20D1980272
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:35:28 +0000 (UTC)
X-FDA: 85296229536.16.B632AC9
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by imf05.hostedemail.com (Postfix) with ESMTP id 357AF100002
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:35:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791387326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=U8Ef4mH5S239BV1dlwJI1m1vw9ZOMBhFL5zRu/Aseek=;
	b=wR7vNETZ1rtPknQxTIUi3Zfz8jXQpllrQZHXvK2YzL+oulPatG9re/BbPHtCD2wKo6+9KP
	p5P3ElPPoWDW+mS/Vcudlu9yEn2p4xJgcyZE3aPfQHB67cmIzqyOQT/riWTOBevj9+Ewsa
	4XYw6EMLT9CytfejwSAZpDsbr4JdGqY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791387326;
	b=rC6tkVHWJmMa5FMbRpYinVWPv1dmZDV2wKRsCuTXDKsmEnO1I9vh7n+5bNcbbwr46HVa1K
	YdSdqRR0KZvw1zKjTieY0dVCk2oSo206emuN2kRm76d0/9Fpdcw4CyuxevPbaovInosD4H
	36QJn7frxinOmqn9VGgbfR5QXIo9FXw=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 66A1E3ED21;
	Wed,  7 Oct 2026 15:35:13 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH 0/2] mm/zswap: batch the writeback IO
Date: Wed,  7 Oct 2026 17:34:42 +0200
Message-ID: <20261007153507.50715-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTFIJ7nMxdQyOk2ongyJZFHaCsXczRmiXS2sZuP0SNTYc+PeIMd2hgsEcB/x1Ck2wNeZG1b4EYnKmfnFDTjp1WaMBVh48h2/qAxXDP+0wj8ky/7h5/JZB/rbv9e7eFW2pbOG34NQa0d8n8kkqPtCtE5kx1mvUQIkClxDvYTqfW+U4T6ueZneoEKpqnOhSkiEpD5iNSQzHVP7Vyn65ADAc3S8gVXhdLU55tCIcQ+ngA5Min64unHflQnDSheRBdVPDbGnkf7/A0BRTop9NX/jZR00PcVtLq/hS1XUwnZs9raRyS+jQxLXmQucxvAw5x9cJSe1blAq4ZkcecDnlc1om3MNgis8dViAIABKzZsTi4HmQqLLQSmMHzl8f3r+FMpKlWfRkCMXghj+eDbcoh1WHC7Q+WKzK3/KvylAFJAb9ZZ80EQekDixNx6FQWcUScyll3I0WQG5Ko+SUJcvyw9/WJag5wYE1VUPveoK66w/hSe6cCntwLaMceY4s1zig4Iau/YZROLEcLvWuB7FcCdVZ25W53s/RwWSpv8NTsJjM/5YvKl0CL4MAbBJpPe7GEC4R4iN71YTBFCiybNux827+pCvH5izXKMywyp9jSjOVNLC/nvGek+CHBG81gaVdSFcQ2rBq7pKtOKkAoPaXiXOCPhFf7jZVp395eBmiIaije2XWQ
X-GND-State: clean
X-GND-Score: -100
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 357AF100002
X-Stat-Signature: opnryniew8r14748sbjzdrgcwuncgqxp
X-HE-Tag: 1791387325-205241
X-HE-Meta: U2FsdGVkX19FAcKudK6EfKEwF8NtNpk2riPz8scZqYpmD00yJGlvikUpwR/kTuOHlp5L0h75VI6naLLBEKs6E3EYol3CH3H849ZMRfQp9FFjMmzBMOjMR2lZcH5koUNcgwaOEzZ1KR2fWd0lIatHcrxTi8MsyaLWNl2io+BP2IJxpj2aAuCAlgZeTLWgkpVNO5+MoN9XIf86AeFUJkg/bGJB+9l3zTIsYg67P1JPvYS3wNZvQIEKbppkW7OZawwvK7TQyBU448yqhFVnYgMcTxgt65/Uka9t2HeKaQ5bTd5hglaIrfYwV5aAB+uENqn0QMlv68OB/DeY9SCxsUK4jSmYdB2ImsmYtCPIGnxdncpcHDJcSQyUA3o/R0XBJl59vpNgg4o8GEpQdopmc0m1Vt5UopbBmVzw5T3HQHj7t4SYb3Cv+J3HNXIoe1fE2rrQuEOrYT3SFreXIVy+pqqX9BfzWvHS8VD/NWUS89jPO13AQyw8QY3tw2Yg7zJElLgBlODTGfGr0iE35tfMuomskerlxldJmK/gKUcrHeKZNHc4EKHwkQn7e+0JPlyRYazEC1VS48pk+MhO+YiEssHmoyBV7yrXlV3Qfy0WWcs3N1Mmo1UMcv4/LWpCHF0zZo2+4dZQSoycCgrkuMmBgEN2DQPB8sN3ou06T/PaQ1elNqXiFeQ2AMWs0Ny1wZgbsBKApkmvyz8tDL4OqASRji/uoNYRabO0Y9cQk69CY4A/JzCmwkJLuY1P8zs93A9RmgIRMC+mw9oMrWbY1sOqzBjsvGiXKdZzGYL/fekRwDFunXXQ0jeo53S0KPWntVWft2VbjHDXVe0r8CuzOZiDkT1OMFGraS6HLhZndJiLtkeW+v91Mzx2lNfA0ElTo+Km94QhfhFTdJ8fnskAiZBiHKUa/JAcseSJnFnmLE525g5QvAzvEGaNm6ThQsXQf56vcJ+/SaR1R3SItlpVuq5Dvs9
 t432VtOZ
 M6K0p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 8f29aa226f82 ("mm/swap: introduce struct swap_io_ctx"),
reclaim merges the swap writes of folios with consecutive slots into a
single bio, but zswap writeback still issues one IO per entry. Patch 1
makes each zswap LRU walk batch its writeback IO. Patch 2 plugs the
walk, so that the block layer can merge what the batch cannot.

Kernel build (defconfig, -j4) in a 600M memory.max cgroup with the zswap
shrinker enabled, swapping to an NVMe partition with iocost enabled,
next to a sibling fio random writer with 10 times its io.weight. Mean
+- stddev:

                                  before          after
  patch 1  build time (s)        2269 +- 50      2203 +- 62
           pages per request     1.08 +- 0.00    1.30 +- 0.02
  patch 2  build time (s)        2188 +- 45      2104 +- 75
           pages per request     1.30 +- 0.01    1.35 +- 0.02

Alexandre Ghiti (2):
  mm/zswap: batch the writeback IO of consecutive entries
  mm/zswap: plug the writeback IO of an LRU walk

 mm/zswap.c | 54 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 11 deletions(-)


base-commit: 3fa97dbf7e37bff1e4dbe8bfd026c1b4a13e186e
-- 
2.53.0-Meta


