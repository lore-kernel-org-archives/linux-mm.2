Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D436D65C7B
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 16:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5556D6B0005; Wed, 17 Dec 2025 11:38:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FF1D6B0089; Wed, 17 Dec 2025 11:38:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402446B008A; Wed, 17 Dec 2025 11:38:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2676B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:38:22 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCF091A0B8A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:38:21 +0000 (UTC)
X-FDA: 84229520802.04.C7034C2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id D0EAB1C0014
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:38:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765989500; a=rsa-sha256;
	cv=none;
	b=bMqbWq5sK7feytaOvZVPn+LbSao5bu93fig8TckS9d7ZqyOOcF/gSbBSXIo9YOGv1s25Qf
	PcTBh0tJy8J49x9LfBSihoWRO34PlE+m7HjSUhSWIQDImEEB7/Bg+auajkNQZy9o5XGJ79
	Qw1TnSf/rhj6QyV781btm3GS7fQgSPY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765989500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N6Z/uKu8uJebQEVGTnY1Mg7FtwLddEoZVb/3GgOmPIs=;
	b=66putOv2xzhVav+ZKvNelvKWsrF4tOHU1cmoyo3Ybl6HGfExGBeypLU3EPFsyP63RbuFCY
	0JQd3cTSCBKp4AkJxo2EhOv3Ygkpne0fs9+DssOz9/1f+y5XdjSKR8ufdjLrfF/er9rsH3
	YYlqd+sdE1xK5ky4ezRLuztQjaDVGYw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99F1EFEC;
	Wed, 17 Dec 2025 08:38:11 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 806BA3F5CA;
	Wed, 17 Dec 2025 08:38:17 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Ryan Roberts <ryan.roberts@arm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Kevin Brodsky <kevin.brodsky@arm.com>
Subject: [PATCH] powerpc/mm: export symbols for lazy_mmu_mode KUnit tests
Date: Wed, 17 Dec 2025 16:38:11 +0000
Message-ID: <20251217163812.2633648-1-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org>
References: <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D0EAB1C0014
X-Stat-Signature: rzwac9n7cg54en8cijqnqw4uw9wr3m6p
X-Rspam-User: 
X-HE-Tag: 1765989499-807931
X-HE-Meta: U2FsdGVkX18TQtG4O9+lZ9wctMhVzlqRGBRjUEjiJNq26/3d277FYPbbucG/48t3F86hx7PcsWFfZ5OicTwKMQMPnC+5Ta4fw/0OoIyXHaiJHv9qBufi+YzcF+RQ1J90PkA3ijSbCXdWstSdsOyGwZGWHMD54ZLVINLCEvlf3Hk6pEM20+7u7D8fXYPRaplnM+Yvnb2Hmc0g6Yi3nNJwTh2JVfgj6Xdiw5GSr4MGMtCj/2vamvDcCLoBG7kZOLCHUww/uu+n8W4To6ZiTtLp3FJ0SQLYF/nY0GlUdszjsEwdYu2s7C77lAhdw2r2c8Z/sz4rHJi8uhaxniNmWPMDkGz7v6+pfExIhsnPivUP+fyCjam/mc+nP4c6UU9Q6qzY0bDuPoblcuYR0ZULHptHdyN5uV5hpiKS6dQo8mRfkBd/rRKOSGeWXY6878szbImCB7LUPhYIU2ntqGHWF44PSPb88eQpJxpUCYDvDnaoeVEteFW2fNOx9Q9QqmqEPfGfmwTTdV8T7oJbqOSMEPxMdAC0b8yxWzSOkVhW1K4wljp2coh4RF85xnNIz7WxhWXQeFvuWyFWK2RphFeZrMVTty+VhxwpvPt7eNjUq4as2MMAyc0Vlys2KMZtYvf7HFUXvp/zeVZSqGtfK6jIuFvgldP5c4Wi32YstFYihtaCTBn2oGiTs+o4A/t65aaw4VSQfJ9IxPmuTsxbCNFiRqQk7IiZ4M9fKWRK2CYZgUjfFno+BqEVKJmcMrgQM5InoLEedPDD4YE6ZuiKrtqpPctm3VV2LqXeCLN4nDx7MA99yyYxETJvsFz/YSwz18HIYGifoTTEZEXlpbjaaL7x854rnl+jTpR8MZR3llGzeDwBTCbI6AvspfyS1aJ5FHiib3srvALCjzqUdrQvlVDZVvZtDuHz+WxzWr64zwr4boTLMnIozkAfWcROoJ5WPc6QKz6hdySdQPpMhOn7S6X4S3k
 nb/L+LIm
 5m7JWllmZA+PU7d0mzkdgUYkHWYLQKFyzJjNrqmfwYbpS9WAqbxfTqglPwyEg4+6aBMe53H0kE3dFSi9howNGW80sXcrTp81YlM9funLTtOB3Hg/DBmeZSrbK/JSnP41SR5i/blsusXqEF6xbqatirgnWh+FUfwD/Y7ux6duqZEmvTiEduDijPQdKoxwBJlTR6NeftwiCfL0JTq8v3ApS653JTmn16y5QzLW6DydjLlNr/3ExF861s4+c/YSy+38teknB4vGla9+jOQQMmuBb2GlZzcpqIJbJqSim
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Upcoming KUnit tests will call lazy_mmu_mode_{enable,disable}.
These tests may be built as a module, and because of inlining this
means that symbols referenced by arch_{enter,leave}_lazy_mmu_mode
need to be exported.

Suggested-by: Ryan Roberts <ryan.roberts@arm.com>
Suggested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---

Andrew, please add this patch just before the last patch in the series
("mm: Add basic tests for lazy_mmu"). Thanks!
---
 arch/powerpc/mm/book3s64/hash_tlb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/mm/book3s64/hash_tlb.c b/arch/powerpc/mm/book3s64/hash_tlb.c
index fbdeb8981ae7..9e622519a423 100644
--- a/arch/powerpc/mm/book3s64/hash_tlb.c
+++ b/arch/powerpc/mm/book3s64/hash_tlb.c
@@ -30,6 +30,7 @@
 #include <trace/events/thp.h>
 
 DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
+EXPORT_SYMBOL_IF_KUNIT(ppc64_tlb_batch); /* For lazy_mmu_mode KUnit tests */
 
 /*
  * A linux PTE was changed and the corresponding hash table entry
@@ -154,6 +155,7 @@ void __flush_tlb_pending(struct ppc64_tlb_batch *batch)
 		flush_hash_range(i, local);
 	batch->index = 0;
 }
+EXPORT_SYMBOL_IF_KUNIT(__flush_tlb_pending); /* For lazy_mmu_mode KUnit tests */
 
 void hash__tlb_flush(struct mmu_gather *tlb)
 {

base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.51.2


