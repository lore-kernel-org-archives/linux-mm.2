Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A259606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 01:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=MaWJkPnQ
Received: by kanga.kvack.org (Postfix)
	id DF2D46B0591; Tue, 20 Oct 2026 21:00:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA40D6B0592; Tue, 20 Oct 2026 21:00:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93456B0593; Tue, 20 Oct 2026 21:00:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99C6C6B0591
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 21:00:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07AAD12041B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:00:56 +0000 (UTC)
X-FDA: 85344828912.21.BD2CCB1
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 50C4218000E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:00:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MaWJkPnQ;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792544454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=brjSVHHjkTm3a15jKpejTsFNYVkjpbbbJOFcNDM0Mpk=;
	b=AOl7w3EuO0Fi8ALbd/I4tryG/SBc51SIdwRXwN4EMK2/gl0sMOV5fiIBzT7QW3JQtUS/HN
	Ein80RlQZzaOUNOrzeX3r1l7OvcrY64HX5kuRLkH8rHuF9ILomwFeqivwnk97OUYCyeqlV
	mqplKymdI+pGhbPnEde4gWId7VcE33k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MaWJkPnQ;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792544454;
	b=DiFCnGOJIicRQZunZjDQxransq1UVhBgrqVenuip4Dc83qoZTHuF+/QkXaQky03sXoLHJH
	EWCGlO5Z4CsZRUvhXeQK3Ute5ASFI5jQQJkPm5dhKgDnEOJCDJ3UahmOJtNBPV/Yzzgywr
	BM1x63tFeUbp3b6/U46Vo/yWGDaOeIA=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8b09e07e149so2112167b3.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792544453; x=1793149253; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=brjSVHHjkTm3a15jKpejTsFNYVkjpbbbJOFcNDM0Mpk=;
        b=MaWJkPnQRsBjjt+dcNOnB3BlsNSSxdrOqwKCH0XRZ/LBmybXt+AL/Egxvf4igVSMDc
         XGUhCto54WI1wl7AziajZZc1IUVBicppf7tXTimmOu0eocXR0EINrjJab+UyfH6NV2Hw
         B0kTdl0s0l9h084c0L+lbKd/5AI5a6F7AcX40fxg7JSkVB4/BAFDkXj7ko3wZTB3slsC
         vbNqB2FdxQhF2CsbuCmWcdNV6YqPWGPyLTKrkPX93uvHGs2e5M1dJ7179qIg0RpkL9xx
         bTzRK4zKhK57w398LU7kq2g45bnCo1omgJMcTKpQEES5YtCL3qHlGuTnY0vc8pU+OmLD
         orPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792544453; x=1793149253;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=brjSVHHjkTm3a15jKpejTsFNYVkjpbbbJOFcNDM0Mpk=;
        b=1tXdxArzbMX1ZuTzrB9YjmEDlrG4Cht9W6aCo3TMQDP8xc85W7K8WcztB2cKezXedc
         JpUbiV5y2XApsuOyVLcT9txMHX6QUrMpBNCC+w1d7z+MrCawVadVgAbcnHbl80znzQTS
         nruAtzTCqfmcWQDTb+b/UXZMkqeyHJNO1zUgj+ymQ2CVtd8/r0IleT5eLNUWFLGhdKV1
         9Vd90sxx4D7783FLIBkoyl+6qqi0WRxGYMrDHmyUxS/OIP6RdA4wa6TpeqZffwYT0lzf
         3/In4ka/eGEzSBuDDE5owyDk86I67tJs3KTNc2MJV9oBqdm7uSrXUsQOP9I7YHqTbnBw
         21Fg==
X-Forwarded-Encrypted: i=1; AKwUvByDArhh5EjozfaDyybQbu1pakBZmTxoCy8gYOQaTQ9Y9qLo+nsFf1eSEC0qNDpVr8uUecgMqcvc5Q==@kvack.org
X-Gm-Message-State: AFq9FYI91IGJHAvFCOQ66FkXmNwOuFf/s52sqm8PCzWZp25u69/fNNqx
	mV1iWR3xSRGjm3o+M/2RjqMF57Ez5gUxsrG3c9stdsouvFgWykLrr9Q7
X-Gm-Gg: AYBFou1A9v2wLZ3bRW6LtxEfpkgJ7xDEqp04oQcReQJQuMfD+IArm8VtvO71qlSv42V
	IYQ8MnSOyQBXVuBsSUoBE+LIGxBIYvl66IfqozgW8/B+zZkfY7SFld0PT6e5MTGv/tBkb/OH07p
	raDJTZvx5HD8SCHzArL4osGR2vLt68wGITrXztdKXI0RdXHZgs9AuKpVw26YJNh/UnK+YmZ6Udf
	KQTFdV81cYCFxGt0d+X0ac0nYZCQ3sfp8wMFA5ZQpPH4Zq8Z0GT6lM5xnPASYkqCIRRd7diT5zn
	wfQcMERMTTtsaMsWjjpF/N3tJ10xEj21zscjlYCs5L92BnoRFqNq8G8C8Q0+qBiTOrdGJQdFws9
	B+S2gDaWrBpRHB0UDdXMxmNu6uzzW7uvl7DamntYyuRjwVOjY2u9WqLBaZ4uy/q0RcRdPCeN993
	kp2SEE1g9+4UbVXXOM6xJg7jznt0iZ2Xgu5SD3vBDqykkLMvD7qMnIjIyxH7SDNwSKsenfDOYDe
	xIi8hJZKtySB4/Qz7MbQG7v8UX5EBVgd8T2pp6p2/DDg5dnlgP3yq4QouXi735fNOsXvLtHWo4j
	21r0rUAO1Q==
X-Received: by 2002:a05:690c:e1c3:20b0:8b0:702f:3554 with SMTP id 00721157ae682-8b133d0edeamr2195557b3.8.1792544453129;
        Tue, 20 Oct 2026 18:00:53 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1300ae0c2sm5192247b3.18.2026.10.20.18.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 18:00:52 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2] mm/memcontrol: publish null pointer before dropping css reference
Date: Tue, 20 Oct 2026 18:00:50 -0700
Message-ID: <20261021010051.1529261-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 50C4218000E
X-Stat-Signature: x1xx43fdqtqgdjdjkzxsuz5duexu8b4i
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792544454-580811
X-HE-Meta: U2FsdGVkX18aQWmlUjQeVX44zaqY3p1p6lc9nmotWcLgGRAE6J0r/1kMEctizk4fl0ZbXN61jUODJ5Q85VsOHgsWQrCwaECrAtAdoFEY3/tnq9PF2kUkxS9weNqKkMYMCyblvUKgvarV0jF5O+RvlYeqKVas5dg6ptujqJm5/vG6ub7qOU/OhAvrYbO9r3/8wzl6E1ctIVb6vQHN6vBTk8xF7QGIw3PVNk/WJE61HJ3gjiga4Dkx4XWjd4abw0hqD2C4/itaZofc/kmQenBT9wGnUiWtLwa7oo5DDGuI6C5U88OnpOeoP4msG/9k2YiQsZPlsa29u6m6wYLBRqFGHqWXU5hbkblTD7e6QrdLf6pqA7cli7JUdw46fbkT7rjZf8XMCALQSABtH4BheuOEuObol7WUfeDcYWZDWCJwfi1RawlMv4eM32w1BU2GqiYWu6D2oQTi5P7iOQYyT7uiAmbnQ1w8E4b+PrDXIrDTTjnw0Rwz+SgX7hcEuR3aLn0kp3SgykrpTbBWNURLIIr5b7evvEcq+16cw/Qo59ApOZwi3P0w94VLr125Fz3p6joz9D/wzp6RiSKAuo5l9W26a77SFw3XLudQgIkT1wa2Z1pX5QAAV+QsoeDJsFTCiMakS7X5mHJanhxOqgnObTbIxp5uG8oZa+sAvAGrM00dLY7h7N5JUloZXt2upMNrF0Lu+nM0dRWr9z/g57wFUjpb2J5ouCFJJIUGxbFCLhJeff5pSeMeb4yc7T0fjh91vcjbkZULNKnz7BAfpqTakpjMf2kATNKPeM2ws2du/niArk3D5PLyrsVFedcdbacBAK51/DAQLz1/GnQHRhUaCFV3P5fFICf96ZWdrDMFtZpRspk/Wtkmi5zjIfuJR2K3AAZLerKCuydvE/s6P2WAXLQgeqC/KpylpaN1C5aw7Tn0gfjUoEzTLsOzi6GWxJNDx79EC7wXjdYXvmFbf46JDvJ
 dlDjinWH
 Nb5saCgyRIgJ0iL+SSN1AQ+uODgDS6DtG7H90iv9HWNZOdnmN5yHvpghTVq68rHDAGCBmDbNjbm2nUww4kTOmuNmsjMRPSVZgizQUjty/jjUdRlWVALB2YIh3p4trUAf//tsAV7N6Z+NPSphhyxR6EuM6OkWQA6QOr/dYIlghAJwrzK+NvZcrUSx9Tg1Jath8E0SJYYHnC3AF7OUCrQpotiHiRgNNx+6aqSORzkOW7o7v0gvPWvZNsVFSMey2gb86Qxfr2z91heEIHEie1s+Z7bE8a0yRjZANHbiDiqtq7X2k3zxDsIX6AWkiSAGtX87PqgCLXjXbT8IZiithLpBK0U6gK/xXiJ3nOteu8XeUQmSEzKczPrfsYeZQ7dXVio0b0c6Qn1U6ySPTZGRcV/0uXwEaOlOTIFu4cOjU5XA9rUiO9q7/WhALgZkyOnxN72AEIh52y67H/UdFEUIgPU883oDbw5iOhRUe7T6B81PJrQtd+9wxDjGS5zudL/Sm9d7Si/PAE6p/11gd3Wqh0RCDEi295Ji1GSlmUpSiHWJzUkB7+NY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

struct memcg_stock_pcp hold references to cgroups that it tracks to make
sure that the memcg never gets freed with unaccounted charges still
living in the stock. When the cached stock goes to 0 for a memcg, its
reference is dropped and the cached memcg pointer is set to NULL.

If that was the last reference, the css_put would free the associated
cgroup before publishing the NULL pointer, which can be racy on 
PREEMPT_RT. To summarize Shakeel Butt's analysis in [2],

CPU 1					CPU 2
local_trylock() takes a per-CPU
spinlock, which is an rcu read
lock along with migrate_disable

drain_stock
css_put drops the last reference
release work is queued

kworker runs css_release_work_fn()
call_rcu() starts grace period G
which waits for the refill task.

<preempt>
					drain_all_stock
					is_memcg_drain_needed()
					enters rcu_read_lock(), but
					 grace period G does not wait
					since it started after G did

					<prempt>

stock->cached[i] is cleared and
unlocks. Grace period G ends,
old is freed

					mem_cgroup_is_descendant() reads
					old->css.cgroup which has just
					been freed.

To close this gap on PREEMPT_RT, switch the order of the referene drop
and the publishing so that we publish the NULL pointer before dropping
the reference. Note that this can only happen from drain_stock who can
hold the last reference, but not on consume_stock since another
reference will always be held. But fix this in both sites to maintain
consistency. 

This is based on a report from Sashiko, who found this pre-existing
issue in my page_counter_stock series [1].

[1] https://sashiko.dev/#/patchset/20260928192349.3432886-1-joshua.hahnjy%40gmail.com
[2] https://lore.kernel.org/all/atfMngq7nyZpt4u-@linux.dev/

Fixes: e1a366be5cb4 ("mm: memcontrol: switch to rcu protection in drain_all_stock()")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
v1 --> v2
- Rewrote cover letter for clarity on what the actual condition to hit
  the race condition, which Shakeel Butt provided. 

 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e7d7db5718f9a..a05d9a8baa1b6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2172,8 +2172,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			stock_pages -= nr_pages;
 			WRITE_ONCE(stock->nr_pages[i], stock_pages);
 			if (!stock_pages) {
-				css_put(&memcg->css);
 				WRITE_ONCE(stock->cached[i], NULL);
+				css_put(&memcg->css);
 			}
 			ret = true;
 		}
@@ -2209,8 +2209,8 @@ static void drain_stock(struct memcg_stock_pcp *stock, int i)
 		WRITE_ONCE(stock->nr_pages[i], 0);
 	}
 
-	css_put(&old->css);
 	WRITE_ONCE(stock->cached[i], NULL);
+	css_put(&old->css);
 }
 
 static void drain_stock_fully(struct memcg_stock_pcp *stock)
-- 
2.53.0-Meta


