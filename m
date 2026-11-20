Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A33E606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s7NkMzEH
Received: by kanga.kvack.org (Postfix)
	id 3C1BC6B05B6; Fri, 20 Nov 2026 04:58:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373B56B05B7; Fri, 20 Nov 2026 04:58:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289BB6B05B8; Fri, 20 Nov 2026 04:58:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E57C46B05B6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:58:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E392C0E27
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:58:40 +0000 (UTC)
X-FDA: 85455048000.21.AB6B1E8
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8A74D1C0007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:58:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=s7NkMzEH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of xavier.qyxia@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=xavier.qyxia@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795168718;
	b=u4l0mMP0GYzn6lu2+H1Sk+DppN+I579etf9Fpy4fBs/Z50vZcqpUyDLSw+OIxvR0QJnCjV
	NMMnDiVcKMtIivs1G61dvWhxdod3+hZPNfWqnGV/lnvS92AUmwe7EJ1hu8RkG99Tsny75s
	qbAEarcfo/avVpKCNTej2fyUcXkyZcI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795168718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=47qKgjPLk/HlG7xONmnC2hXhMR5aH9m0CTLLnBtxpJY=;
	b=wo7Dt7Lp7I3ZyW5yN4f+S4alXtRbh4Mqgv0ao+h5ZxlTQE/J1EIIfqubM6Hg6I2yhpmR3p
	qcJWttEeMlUbZB7oEDz2+H0WVtgq/1Pcm3r959l996GlWVNDEpUOr5fDxiD+f0c57dsdyU
	1yy6oFz1Uc07HImJOw4VfbgpjXg1diA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=s7NkMzEH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of xavier.qyxia@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=xavier.qyxia@gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cdd9d0c9bbdso426476a12.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795168717; x=1795773517; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=47qKgjPLk/HlG7xONmnC2hXhMR5aH9m0CTLLnBtxpJY=;
        b=s7NkMzEHBqihZeOfvUv55+qeIvuE9ovEbb12IJFevHl6LSiZWWHvEESI48+U8zeN2b
         w4sw5UjjKLg7u1Zu+As7hlqOiK6WlGp3efcYFCkWbZ3BeSJd51SkjSGXX1UOGrkCk2p2
         wqDXd3jwwKO4SyE1UYA1e+F+sbYYr1hS0cyWulRe4E1X9ODAHseMUBjbrIJ4NTOYWtvw
         xVU2F/qoRafUwmYu8pTs0njDjjzuZT6a6kTso4Ahp7l/jF3UvNrdhC4oLHlo0MlMuNnZ
         f1fubBiSPDcZfK3gMPwFZtyQkVo026nAHw6vIP/b7FDNI3Y/SEzrAQYBr00iD945/nqM
         w+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795168717; x=1795773517;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=47qKgjPLk/HlG7xONmnC2hXhMR5aH9m0CTLLnBtxpJY=;
        b=oHPrtcv33Rid1DQ5KztvnPoLAirHodVNHEldWRO4de1oIL4h9ITD4x7q20SmkpjNvn
         PviaPGpU/duNeaxrAZBNZd5jxyNz3JvC4X4UlmwsyRI4OJ+GrM+RAVxZABnOeMQNDdaK
         tg5SvrWKHABjM984pxEPOxxLgc/A4F3cb89i7l6nkqd7kLXp4jvpMjYIcwBMsEVSeW+F
         de6eb/4M0qjMf6TxOd7H4owjWO7jGB8lWx0lfFjQVBtYy2feeoSV9hc7gpRsAJbJ6ICZ
         xjUrlXdR7Dpr5hmz2L7tTfKGzU0CFcmkR/GT6x/zPMJHpquwqmhIc6yU1uB6+Zymnx2v
         zfmw==
X-Forwarded-Encrypted: i=1; AL+hErFlDY+50G44OTgRjGRmIn7sEfmYOAI/eafdmZEEqL7rTgel8P98S2+2AVumqTWgf6k6ZuEXwwY1xw==@kvack.org
X-Gm-Message-State: APuU4Z9mk8wYG8qP7kKszE5WgmANsGqZdf2dLXbb5hQ+BCAEmq3s2fd+
	jEEB7hsoDyMOxGjlrnOIl1kmb6wRCLRkRcNFJJfgfK/hwYUvdwRQYh2y
X-Gm-Gg: AZFdTZcpsz5ntTkxYFxHk/X6ksnMhpD/c9CiNhO/qX9JSMHySNjOgKnC3qqSA8+VZMX
	UeWvwAIffRBOoQG7+HgIpwJgsFyof/Sh59yI6N+MBIM6LAVFONs3AMGslqVWuEsnbfstKLuOvmE
	cVvFEBvWYwVQbuax+upvsNB5/kWuIBmhgvekVwdtRbTdqvqEDCWOf3YuFwK3t+i90je6R00CwrM
	u7HQDj22yHJWHPo82B7nJb4/gv3MfA8WJ49XobptsdTp6KLQHWF6lc3m81x4I2Fjpub5E24s2YQ
	B/x8sSkIYtTNUCxVjCPbY9VGyKfyMv9OQ13MArrqyPo7kD4bSWu5JKOrKaWBQIVDy5gkoQkxHHe
	tS/MS8IWVIAjlKaAopYD4hvgSthm65Ikr7XVALbGVeju6xoa3nOEd2023UQJV1BCeYJ7ayPZgMn
	B8RHi48V1rZR+aE8PS9XvGOQIGt/X0xVQsabIh+8hHQpAis8pK2CVYDKmkLWy9OYxWavKeiveZ2
	+BKaE0rXOAMlAdCJVSNra6+c5cAK3BL35arKVB3I5YNzt0Vj8dbo5DvUPjc+gTPtDqWnql3Et3B
	CnOVyORhA3u2thm7gSUqjvgEYOHsjndPpLP/k7ku7EuFOfMDk38zdltltkvq1A28RQwiWFQSg5E
	8XIiw21w3EA==
X-Received: by 2002:a17:90b:2c84:b0:3b4:1220:36fe with SMTP id 98e67ed59e1d1-3b41c7d0ddfmr2141240a91.9.1795168716946;
        Fri, 20 Nov 2026 01:58:36 -0800 (PST)
Received: from szth-acg-baixin10897724.szth.baidu.com ([120.72.52.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm3684982a91.17.2026.11.20.01.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 01:58:36 -0800 (PST)
From: Xavier Xia <xavier.qyxia@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev
Cc: mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	willy@infradead.org,
	jack@suse.cz,
	david@kernel.org,
	brauner@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xavier Xia <xavier.qyxia@gmail.com>
Subject: [PATCH] mm: batch per-task lruvec stat updates on the writeback path
Date: Fri, 20 Nov 2026 17:55:58 +0800
Message-ID: <20261120095559.429515-1-xavier.qyxia@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 8A74D1C0007
X-Stat-Signature: 89o9denst4dc43kppx5jexq15wz6t3qu
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795168718-555982
X-HE-Meta: U2FsdGVkX1/pRf/MQrAH+2WYNrqqagCdM5bJt1qB6xSTT3b+c4habM3DfwnkoeR+aRx5FbGGcWX9AFPTlzjgRIVzazc0gknaSUIKMG64lZdd4Q8S44d6l8gYqRrfXB1DG8L4l7m3/t8MbgSYaSLUuksOK0cURfd25A61/+TWv6TeOEWcUdQFUlHwsi5MtT5DNrvWvNmLdtEVPcPvwGacXyFTJezzV/4grdYMEpRHtBCxRM8ulvkzTnF2gbkDu81ejjbRJdKAjZxqh2gGBEUjd2T8FExtxtbC/UVu8o48r09nRhvOp7Lvuba8gPJZYrgDN84Yxqxrmkz+mIbODoNevw7yZeSWcVZYNlDNfz/ygHqcolEUMc9p75Je7OAhdAvFNzEuXk8vIo0OFFvWUfQvp+sMKqgKyla3RdueFkN5wThiWtywLWkuznWHeEhNCvBHSzm7H5VKH0Kngm+VdbTPH86tm8WoU/0vme6JgOshfYHxGwviStWaamUS05sfRNIx8SKuhm5NOBp0gktUYdEyctSLTJInGnsTpNpIH7mjr/zhXJAE9n5PXIRBJpW+h74ZW7Z3tZbVnBSoWQQzC/oy+ZL37YkN7FeuAzz/hdnUD7swCOpaIkcDC5PH5DmgEdqqvTumubISCfOWxqeQNx34d22ybYinYtoxhy7BKUiRbAK0Z+3R6CsdC9OquRsUvT2LlhGwDW0gZ4vYs3J4515BZKkQVR13UbNWxAiBBFm7owQm3zy6+5pQgEy/GSEYh/qn4iI8dnlooAPjvQuUUa6xWTQY+sazL2H9KoTnS5lOOgvKSGdgFliHQOpxKNuOx0mb6w1jMlSmWV6nphA2AdGktorJZv82HpvSpdj7+K9BkOgJW6o64nvYEkTJcU9UmaXYYrv/uObLeVHrLqQ8JmFpQHTO/lpA27XCoZhRdRJh5aRrZa39NFQb06cwtyQyfIPRHAJcQ6I1QgliGsrUR0e
 bVYrNmtB
 rokdsGICk2Yqq2KrjVHvjvf0RT0CXc2s0Kneq7AHXIO3xp5G1eAc2Wbdag602zDVMRhC4+GhrRjqydwjTjr2EdeMl/dZIUMKLbFYVYYOGDSYdgV7bWXn/Iy9XSKglnjC3OC/400UNsm8WihQB2xpQlWgpFkXfCw3JxrsCjPnWA2TI5hdlDoxTM3vDEBr/dCputyldwcPLflZm4oV+5WbnjNvKpXPYAnS4RsPUiUEqYHLJabOejJd+uEVehAbKh+2GoUk7TvLI4m/RGLjVOo+TYJUB7GPMw3zqBBdumtAfaZOhqXLnXlRNiBNpnDRrB5NG6+Nua+S7u/52xUKATVzLucxKFtEOBHh3zmI1u7fbrpCI2EvXyROqRgBxEDDeslA5iWEWvMbRldFQ6rQPFOrnJwHAujYAuuvvwnlmjq1ABRuYtDoxTyHmqlQvFshhcDwqBTeSwypyGD1UIpQNDs8CA3H7m+8eERby/rJdW8ahOUrs41MaRHBJ2K3phPRjUQMVwBJBhKJ/PSoz7KQVq+6HP6PsiuMV1uIpngOgMOEQGIp31rcWVmgHd4+UvKSEU0LQA5VPwSGFDn3V8ZbVDwcRB/NtSVFDSY1dsaJDVGwWznGUX4F8LO102QSJdo0Bq6OHICTBlbVhQtqKW5JwwH+ngvxEi8vTWTYz9A+t6zZY1HB1+ktDw0blbGcieIO8C4DaFANCq/CiUowV1ehrxqAie9mBrxCfhOvXsAA64QJlmBVrssFKA+9MVXy+F0SI5IxEJdg1iqPz61m00lo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The writeback path updates two lruvec stats per folio through the memcg
rstat machinery: NR_FILE_DIRTY when a folio is dirtied and again when
writeback clears it, and NR_WRITEBACK when writeback starts on it.
Consecutive folios almost always share a lruvec, so the same counters
are updated over and over.  On a 4k buffered write + fsync workload
__mod_memcg_lruvec_state() is about 8% of the profile.

Hold those deltas in the task instead and apply them through
mod_lruvec_state() once a counter would grow past 64 pages.  Three
task_struct fields hold the pending delta: a lruvec pointer and two
signed counters, 16 bytes that fit in existing padding, and nothing
without CONFIG_MEMCG.  Besides the size limit, the batch is flushed
when a folio from another lruvec arrives, before
balance_dirty_pages() reads the dirty stats, at
file_write_and_wait_range() entry before it writes back and waits,
when a writeback round ends, and on task exit.  The per-folio RCU
section, folio_memcg() and mem_cgroup_lruvec() lookup stay; only the
update through the lruvec is batched.

A task therefore applies its own pending delta before its dirty
throttling decision and before its own writeback-and-wait, so neither
runs with the task's own pages missing from the counters.  Deltas
pending in other tasks are not visible until those tasks flush, so a
counter can lag by up to 64 pages per task and item.  That is a fixed
amount, so it matters in proportion to the dirty threshold: 64 tasks
that each dirty a few pages and then idle hide 7.4MB, which is 7.2% of
the threshold of a 512M memcg at dirty_ratio=20 and 29% of it at 256M
and dirty_ratio=10.  I was not able to measure whether this delays
another writer's throttling; see below the ---.

fio 3.36 on ext4 in a 16 vCPU arm64 guest, raw block backend, pinned to
one NUMA node, in a cgroup v2, 6 runs per side over alternating boots:

  seqwrite 4k +fsync:   547 -> 591 MiB/s (+7.9%), system 63.9 -> 59.7%
  randwrite 4k +fsync:  550 -> 575 MiB/s (+4.6%)

1M blocks, fsync-per-write and sqlite synchronous=FULL do not change,
and neither does anything with cgroup_disable=memory (p=0.31, n=12 per
side).  For one 256MB write+fsync in a non-root memcg,
lruvec_stat_mod_folio() drops from 393464 to 196858 calls.

Those are call counts, not CPU time.  A 384MiB buffered write with no
fsync and periodic writeback off, where only the dirty side batches,
drops lruvec_stat_mod_folio() from 196747 to 98443 and
__mod_memcg_lruvec_state() from 297789 to 201019, and that is worth
1.27% fewer instructions and no measurable change in cycles.

In testing, memory.stat file_dirty followed a write in progress,
matched the bytes written once it completed, and returned to zero after
sync; a fork()+exit() writer and 200 short-lived writers accounted for
the same number of pages as without the patch.  No reports with
DEBUG_VM, PROVE_LOCKING and DEBUG_ATOMIC_SLEEP, including on
PREEMPT_RT.

Assisted-by: LLM
Signed-off-by: Xavier Xia <xavier.qyxia@gmail.com>
---
Against 7.4-rc3.  mod_lruvec_state() and lruvec_stat_mod_folio() are
unchanged on mm-unstable and this patch does not touch mm/memcontrol.c,
but I have not test-applied or built it on that tree.

Interaction with c78842919368 ("memcg: don't go through the lruvec for
folio and kmem lruvec stat updates") in mm-unstable: that commit stops
routing per-folio stat updates through the lruvec because lruvec->pgdat
and mem_cgroup_per_node->memcg share cachelines with fields the lru_lock
holder writes.  This patch caches a lruvec and reads both fields in its
flush path, so the two go in opposite directions at the API level.
Caching memcg+nid here instead would need an exported helper, since
mod_memcg_node_state() is static to mm/memcontrol.c; the css reference
this patch takes would cover the lifetime either way.  I have not
measured that variant or the two changes stacked.  I can respin it that
way if you prefer.

The 7.4MB of hidden dirty state in the changelog is from 64 writers
that each dirty a few pages and sleep (4 measurements, sd 92KB, zero
without the patch).  I could not turn that into a throttling
measurement: with periodic writeback off balance_dirty_pages() never
reached its pause path on either kernel, and with dirty_ratio=10 in a
256M memcg it does throttle but throughput varied 5x between boots of
the same kernel on this setup.  It needs a bandwidth-limited backing
device, which I don't have.  If 29% of a small cgroup's threshold is
too much, STAT_BATCH_MAX is the knob - lowering it cuts the staleness
and the number of avoided updates together.

Only the writeback-start side of NR_WRITEBACK is batched.  Completion
keeps the existing direct update, since it may run in interrupt
context, where current is not the task that owns the batch.  That
counter can therefore also read low by up to 64 pages per task, in the
same direction as the NR_FILE_DIRTY lag.

Benchmarks, in addition to what the changelog describes:

  seqwrite:   fio --name=t --size=256M --ioengine=psync --rw=write \
                 --bs=4k --end_fsync=1
  randwrite:  same with --rw=randwrite

Call counts come from the ftrace function tracer filtered to the one
symbol (11MiB per-cpu buffer, overrun and dropped both zero), cross-
checked with perf stat on a kprobe.  They count the named symbol only,
so inlined callers are missing and the numbers should not be composed
with each other.  The dirty-only comparison is a 384MiB buffered write
with no fsync and periodic writeback off, PMU cycles and instructions,
3 groups of 5 runs per side.

Also built and booted with CONFIG_PREEMPT_RT=y, PROVE_LOCKING, DEBUG_VM
and DEBUG_ATOMIC_SLEEP.  CONFIG_DEBUG_VM=n and CONFIG_MEMCG=n build
clean.

 fs/fs-writeback.c     |   3 +
 include/linux/mm.h    |   6 ++
 include/linux/sched.h |  11 ++++
 kernel/exit.c         |   2 +
 kernel/fork.c         |   5 ++
 mm/filemap.c          |   2 +
 mm/page-writeback.c   | 128 +++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 154 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 15260cf2a29b..46327617a7ad 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2491,6 +2491,9 @@ static long wb_do_writeback(struct bdi_writeback *wb)
 	wrote += wb_check_background_flush(wb);
 	clear_bit(WB_writeback_running, &wb->state);
 
+	/* Don't pin another cgroup's memcg via a pending batch while idle. */
+	dirty_stat_flush_current();
+
 	return wrote;
 }
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6af3b7008f1a..3267d74c0994 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2134,6 +2134,12 @@ int folio_mc_copy(struct folio *dst, struct folio *src);
 
 unsigned long nr_free_buffer_pages(void);
 
+#ifdef CONFIG_MEMCG
+void dirty_stat_flush_current(void);
+#else
+static inline void dirty_stat_flush_current(void) { }
+#endif
+
 /* Returns the number of bytes in this potentially compound page. */
 static inline unsigned long page_size(const struct page *page)
 {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e4f6323d7855..13b557bc037e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -67,6 +67,7 @@ struct cfs_rq;
 struct fs_struct;
 struct io_context;
 struct io_uring_task;
+struct lruvec;
 struct mempolicy;
 struct nameidata;
 struct nsproxy;
@@ -1476,6 +1477,16 @@ struct task_struct {
 	int				nr_dirtied_pause;
 	/* Start of a write-and-pause period: */
 	unsigned long			dirty_paused_when;
+#ifdef CONFIG_MEMCG
+	/*
+	 * Pending NR_FILE_DIRTY/NR_WRITEBACK lruvec deltas; the lruvec is
+	 * kept alive by a css reference on its memcg (not for the root).
+	 * See stat_batch_mod() in mm/page-writeback.c.
+	 */
+	struct lruvec			*stat_batch_lruvec;
+	int				stat_batch_dirty;
+	int				stat_batch_writeback;
+#endif
 
 #ifdef CONFIG_LATENCYTOP
 	int				latency_record_count;
diff --git a/kernel/exit.c b/kernel/exit.c
index d5e7bc2af804..0f60e1c04ede 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -979,6 +979,8 @@ void __noreturn do_exit(long code)
 	exit_nsproxy_namespaces(tsk);
 	exit_task_work(tsk);
 	exit_thread(tsk);
+	/* After exit_task_work(): a deferred fput() can still dirty pages. */
+	dirty_stat_flush_current();
 
 	sched_autogroup_exit_task(tsk);
 	cgroup_task_exit(tsk);
diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a7..6ae5076d74e5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2412,6 +2412,11 @@ __latent_entropy struct task_struct *copy_process(
 	p->nr_dirtied = 0;
 	p->nr_dirtied_pause = 128 >> (PAGE_SHIFT - 10);
 	p->dirty_paused_when = 0;
+#ifdef CONFIG_MEMCG
+	p->stat_batch_lruvec = NULL;
+	p->stat_batch_dirty = 0;
+	p->stat_batch_writeback = 0;
+#endif
 
 	p->pdeath_signal = 0;
 	p->task_works = NULL;
diff --git a/mm/filemap.c b/mm/filemap.c
index b04be64a5069..d837371ae988 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -781,6 +781,8 @@ int file_write_and_wait_range(struct file *file, loff_t lstart, loff_t lend)
 	if (lend < lstart)
 		return 0;
 
+	dirty_stat_flush_current();
+
 	if (mapping_needs_writeback(mapping)) {
 		err = filemap_fdatawrite_range(mapping, lstart, lend);
 		/* See comment of filemap_write_and_wait() */
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0694ec4098f6..516a8bb028f8 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1812,6 +1812,9 @@ static int balance_dirty_pages(struct bdi_writeback *wb,
 	unsigned long start_time = jiffies;
 	int ret = 0;
 
+	/* The loop below reads the dirty stats. */
+	dirty_stat_flush_current();
+
 	for (;;) {
 		unsigned long now = jiffies;
 
@@ -2597,6 +2600,125 @@ bool noop_dirty_folio(struct address_space *mapping, struct folio *folio)
 }
 EXPORT_SYMBOL(noop_dirty_folio);
 
+#ifdef CONFIG_MEMCG
+
+#define STAT_BATCH_MAX		64
+
+/*
+ * Per-task batching of the NR_FILE_DIRTY and NR_WRITEBACK lruvec stats.
+ * Consecutive folios on the writeback path almost always share a lruvec,
+ * so hold the pending delta in the task and apply it through
+ * mod_lruvec_state() once it would grow past STAT_BATCH_MAX.
+ *
+ * A task applies its own pending delta before balance_dirty_pages()
+ * reads the dirty stats, and at file_write_and_wait_range() entry
+ * before writeback and wait; deltas pending in other tasks stay
+ * invisible until those tasks flush.
+ *
+ * The cached lruvec is kept valid outside the RCU section by a css
+ * reference on its memcg; the root memcg needs none.  Writeback workers
+ * clean folios for other cgroups, so they flush when a writeback round
+ * ends rather than pin a memcg while idle.
+ *
+ * Only the owning task touches the batch, hence no locking.  Interrupt
+ * context, deltas above the limit and a memcg being released all bypass
+ * it.
+ */
+static void stat_batch_flush_task(struct task_struct *t)
+{
+	struct lruvec *lruvec = t->stat_batch_lruvec;
+	int dirty = t->stat_batch_dirty;
+	int writeback = t->stat_batch_writeback;
+
+	/*
+	 * Key the flush off the cached lruvec, not off the counters: a
+	 * batch whose deltas have cancelled out to zero still owns the
+	 * css reference that was taken when it was started.
+	 */
+	if (!lruvec) {
+		VM_WARN_ON_ONCE(dirty || writeback);
+		return;
+	}
+	t->stat_batch_dirty = 0;
+	t->stat_batch_writeback = 0;
+	t->stat_batch_lruvec = NULL;
+	if (dirty)
+		mod_lruvec_state(lruvec, NR_FILE_DIRTY, dirty);
+	if (writeback)
+		mod_lruvec_state(lruvec, NR_WRITEBACK, writeback);
+	if (!mem_cgroup_is_root(lruvec_memcg(lruvec)))
+		css_put(&lruvec_memcg(lruvec)->css);
+}
+
+void dirty_stat_flush_current(void)
+{
+	stat_batch_flush_task(current);
+}
+
+static void stat_batch_mod(struct folio *folio, enum node_stat_item item,
+			   long nr)
+{
+	struct task_struct *t = current;
+	struct mem_cgroup *memcg;
+	struct lruvec *lruvec;
+	bool pinned;
+	int *slot;
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	/* An untracked folio has no lruvec, only a node. */
+	if (!memcg) {
+		rcu_read_unlock();
+		mod_node_page_state(folio_pgdat(folio), item, nr);
+		return;
+	}
+
+	lruvec = mem_cgroup_lruvec(memcg, folio_pgdat(folio));
+
+	/* current is not the owner in interrupt context. */
+	if (unlikely(!in_task() || nr > STAT_BATCH_MAX ||
+		     nr < -STAT_BATCH_MAX)) {
+		mod_lruvec_state(lruvec, item, nr);
+		rcu_read_unlock();
+		return;
+	}
+
+	slot = item == NR_FILE_DIRTY ?
+		&t->stat_batch_dirty : &t->stat_batch_writeback;
+
+	if (likely(t->stat_batch_lruvec == lruvec &&
+		   *slot + nr <= STAT_BATCH_MAX &&
+		   *slot + nr >= -STAT_BATCH_MAX)) {
+		*slot += nr;
+		rcu_read_unlock();
+		return;
+	}
+
+	/* Reference the new memcg before dropping the RCU section. */
+	pinned = !mem_cgroup_is_root(memcg);
+	if (pinned && !css_tryget(&memcg->css)) {
+		mod_lruvec_state(lruvec, item, nr);
+		rcu_read_unlock();
+		return;
+	}
+
+	stat_batch_flush_task(t);
+	t->stat_batch_lruvec = lruvec;
+	t->stat_batch_dirty = item == NR_FILE_DIRTY ? nr : 0;
+	t->stat_batch_writeback = item == NR_WRITEBACK ? nr : 0;
+	rcu_read_unlock();
+}
+
+#else /* !CONFIG_MEMCG */
+
+static void stat_batch_mod(struct folio *folio, enum node_stat_item item,
+			   long nr)
+{
+	mod_node_page_state(folio_pgdat(folio), item, nr);
+}
+
+#endif /* CONFIG_MEMCG */
+
 /*
  * Helper function for set_page_dirty family.
  *
@@ -2616,7 +2738,7 @@ static void folio_account_dirtied(struct folio *folio,
 		inode_attach_wb(inode, folio);
 		wb = inode_to_wb(inode);
 
-		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
+		stat_batch_mod(folio, NR_FILE_DIRTY, nr);
 		if (folio_test_dropbehind(folio))
 			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr);
 		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
@@ -2915,7 +3037,7 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		wb = unlocked_inode_to_wb_begin(inode, &cookie);
 		if (folio_test_clear_dirty(folio)) {
 			long nr = folio_nr_pages(folio);
-			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
+			stat_batch_mod(folio, NR_FILE_DIRTY, -nr);
 			if (folio_test_dropbehind(folio))
 				wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
 			zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
@@ -3033,7 +3155,7 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
 		folio_test_set_writeback(folio);
 	}
 
-	lruvec_stat_mod_folio(folio, NR_WRITEBACK, nr);
+	stat_batch_mod(folio, NR_WRITEBACK, nr);
 	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
 
 	access_ret = arch_make_folio_accessible(folio);
-- 
2.43.0


