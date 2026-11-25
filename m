Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B8A9606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NpWuesNd
Received: by kanga.kvack.org (Postfix)
	id 54DCC6B09BD; Wed, 25 Nov 2026 06:26:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE806B09BF; Wed, 25 Nov 2026 06:26:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414756B09C0; Wed, 25 Nov 2026 06:26:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 166056B09BD
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:26:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9FFE240EA4
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:26:01 +0000 (UTC)
X-FDA: 85473412122.28.532B008
Received: from mta0.migadu.com (out-106.mta0.migadu.com [91.218.175.106])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8319D180007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:25:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NpWuesNd;
	spf=pass (imf24.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795605960;
	b=cnAzxferEWscsLx3fUd31GdVZxGLSufT/OylwpePT29L/luZDWydAevAMv+lcOghgfkZzS
	gliyufQO48/3D9+IvuioWrT84D5VAlQOSsxGB0mFlVYiCRaMV+D9HjhNbQuL6eczb6SUm0
	tK1ABtHXVPmVrSRnF3e+sAGfI0pE7yc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795605960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YaMpE8mwgKIgU6RCzVSB7gVQuVXkm54ZA+zzWDgxsQY=;
	b=CQscFHhHPNlPvypIsHbBtJe5o7QegwqCNJaXxzrG8MD6i014ypX/7UqJxj6/AJmkGujoKh
	AoH8BDuWwF06iqHfnnbw0CSRXtI2VFw5hi01CGBzlXAzi9TkfuzjW51J2KMcZHRmwxEhwN
	BHaKUn6HpnTUiJdxUTV0+L4qIqmfw/Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NpWuesNd;
	spf=pass (imf24.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tsWkXInLa1MfUdAiJPkw5Dvzk94Lc8spqVEpz2z7/KQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795605957; v=1; x=1796210757;
 b=NpWuesNdStD+2gc6JjO6Qp8XKsRCnSlzWpRraXZi7gj+eX2M1EssoNz55h7b63+iejSmDrne
 Dfzuuq9Ll4R3jDk4ZjiXtAiNepr6Pj7h+LytBLozalGUqmizvcAUP9g2VCTpx8oYvNfx0024lYC
 AgZe6y9gwILb2PakybXTI3rw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 604b38b9ccd6a9d9;
	Wed, 25 Nov 2026 11:25:57 +0000
X-Mizu-Trace-ID: 604b38b9ccd6a9d9
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH] mm/mglru: skip redundant bitmap store in lru_gen_use_mm()
Date: Wed, 25 Nov 2026 19:25:35 +0800
Message-Id: <20261125112535.4022171-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8319D180007
X-Stat-Signature: 1xjiczgns9rurs554tbtsuoi18j9a99a
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795605959-698689
X-HE-Meta: U2FsdGVkX18SunVR0sP7Npr/k07ulaUqvS/7LBHms6uALWj/A0B2ZUhioCjXCQoRAvoXywN6L2vUrTqF+ayJI/C2b3gdeVdKKFm6c7/Ne2i0MBHlmc2ph3NPN/CKtbpuQNPoVgz8C9cqpTohteI09T9DeThISPUDDR8f/zoXGCoTzsXrTN+ZJgLwKB3h+XFG0YHDDR6/P7IPj8VfTLC9b5YHsQOf5Yh7dJl6e75f3L5V3pGYGYo2YlI2m4yTlbPjjcbA4klnBC18XSi7bMYelTWj0sq8wUjdhi+NSp07c/U57OOqdTrJmudWzGtFanhW2NKT3ofHJhPzOqKzeVcq5jEAtk4Fx5zww9OGYSoe0iK5ni0sDBAOs8dLCNlufkjGDsORq3C3Y28FXsJWPbbMSxH+wvhOm9Xt49qCxCOGvs0rK6xSTrl8kcvJU3D5YgK1b9c0W5TdrW1+AaXs40qCIQrCbMy1tzCOXohJoSB5/efmYapYbku4UU4YpBRN3D++7scPEa9Kevau1tc0DErQAUqBBJPoyAFtZAEGqyM8tIb/kGL9ZzR/T1/aW7X1QHAeDPM8uQpwk0eHkgpl1Z0+mdNjo480cMBfolEuPvZYDLUeMRd39OlFky5w3dNDsjG6sGeNDBK5e8FC0sPPVLYDhg+L76TI5h4fd17LSRmskraxBhKuEDJwYcP33TT6shD5Qq9Iemwf+yeKuJhYKOKEqjIKiWB62tMpAx/G355zwfbByfPlHkW3cB2xCoMcPOIojI9t0wa0s23fMaPl3o4mMM41vSvUfy/38fj+Kvw4oHhVHj88juW6MOU87v0W/Se7J/ut3+V2hsQqNs0Gm9DxtvcELGhO9gpQlU7H8BVYvDMyqhYxU33A2zPE/BjWJy4WdVmXeyX223tHftndHB9Z/OlQyVl56JzZgfH/eQI3DuHhIY3RPgp6aOGB0U3CpBQzoLb5YXs/f2HufaPWkoX
 CMCD3Hxu
 4cxptnlhIWGHnzBPm+pC1A5JjVV+TfGDGLv06scDQP7Mshv7QjQuLo9VwFRlZMERXGsMIOY7fpG1TjI7GsUQzlvH6d/pcKnNGPfj8D2ZYJJFrur8gE15OMvjnwXWSSOU/kW3uhdguxQzs/T86BzZusL7RKFg07Dvhj87xp65Pl4FF2R1MUb+WZDfnNC1AJkAy2OjQSTcfbYknLBUvfu6piAxwkzHT5XpgMr64OK6+NLV2xhQSgG7615/fgsK6eLxb62IG1TQVzhLggciJP68sXsRV/JxyUkl7imngr0SmtE9/tr/MU9D+9e8MTUQz8u7Twnv3XRWD1KQWstLW0x4vhb2aGiZ99jcojMWEcNN+CzgetXICjlKCEpKsBG0ATtK5SBYDb5ygWbFL8nAXtpmHpZ7wljBq5TfPPkmy9xJxQbl7NkDiiQBT4mo1lbjb6uomwwXr31WPrQLdUxttenzA0dHRUjJtXq/UJK25nZQQMBC281ll1tWkOuE/zCQf8p+5A5bmtdLc6ayIZp6uNwyy836jaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

lru_gen_use_mm() is called from context_switch() on every switch to a
user task and unconditionally sets mm->lru_gen.bitmap to -1. The bitmap
is only cleared by the page table walkers in get_next_mm() during aging,
so between aging passes it is already all ones and the store is
redundant.

The store is not free when the mm_struct is shared: every CPU running a
thread of the same process must take the cacheline in exclusive state,
so the line bounces between CPUs on every context switch. On x86,
switch_mm_irqs_off() returns early when switching between threads of
the same mm, which can make this the only shared write on that path.

Read the bitmap first and only write it when it is not already set.
The semantics are unchanged: the plain WRITE_ONCE() had no ordering
guarantees, and a walker clearing a bit concurrently can be missed in
either version.

Tested on an i7-13700HX (8P+8E cores, 24 threads), with turbo disabled
and the performance governor. On each CPU two tasks sched_yield() to
each other, either as threads of one process (shared mm) or as one
process per CPU (private mm, control). Context switches per second per
CPU, median of 5 runs, averaged over 2 boots of each kernel:

  CPUs   shared mm              private mm
         base     patched       base     patched
     1   1114766  1106870 -0.7% 1104512  1109284 +0.4%
     2   1086513  1110204 +2.2% 1110334  1112209 +0.2%
     4   1085872  1112258 +2.4% 1113146  1112467 -0.1%
     8   1085945  1111371 +2.3% 1111662  1111876 +0.0%
    16    660870   666748 +0.9%  665470   667058 +0.2%
    24    579382   596472 +2.9%  596177   598500 +0.4%

The 16 CPU case uses both SMT siblings of each P-core, which share the
L1/L2, so less of the traffic crosses cores. With the patch, the shared
mm case is within noise of the private mm case.

will-it-scale context_switch1 and sched_yield do not show a difference
(within 1% for both threads and processes): sched_yield runs one task
per CPU and never switches, and context_switch1 leaves the pipe peer
unpinned, so most switches stay on one CPU and the line does not move.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
Changes since RFC [1]:
- Split out of the RFC series and sent on its own; it is independent of
  the other two patches. Patch 2 of the RFC is in mm-new as part of
  MGLRU-FG, patch 3 will be reworked separately.
- Rebased onto mm-new, no code change. The numbers above were measured
  on next-20261023; lru_gen_use_mm() and its callers have not changed
  since.

The test program is a small C file; I can post it if that helps.

[1] https://lore.kernel.org/20261105132220.2233677-2-ridong.chen@linux.dev
 include/linux/mm_types.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 4c576e24ce42..7812b36fefff 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1541,7 +1541,8 @@ static inline void lru_gen_use_mm(struct mm_struct *mm)
 	 * used since the last time it cleared the bitmap. So it might be worth
 	 * walking the page tables of this mm_struct to clear the accessed bit.
 	 */
-	WRITE_ONCE(mm->lru_gen.bitmap, -1);
+	if (READ_ONCE(mm->lru_gen.bitmap) != -1UL)
+		WRITE_ONCE(mm->lru_gen.bitmap, -1UL);
 }
 
 #else /* !CONFIG_LRU_GEN_WALKS_MMU */

base-commit: a036649714c3446abfdc36d0ae483046432b16c5
-- 
2.34.1


