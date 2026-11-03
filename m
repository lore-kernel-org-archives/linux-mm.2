Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37177606D809
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=TkbN7JC4
Received: by kanga.kvack.org (Postfix)
	id 627A46B05C5; Tue,  3 Nov 2026 03:00:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 600736B05C6; Tue,  3 Nov 2026 03:00:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5158C6B05C7; Tue,  3 Nov 2026 03:00:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2ADED6B05C5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:00:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A55D1202A5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:48 +0000 (UTC)
X-FDA: 85393061376.02.C84D469
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0E0C31A0010
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=TkbN7JC4;
	spf=pass (imf19.hostedemail.com: domain of matthew.ruffell@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=matthew.ruffell@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692846;
	b=XSPYnNUkKVioWnMaUoWp1vQl+nJG41+PqV3tRpDond2F6Ijc7pMfkIlgHldKroy+Dsf1s3
	6iwDihi8V6mTuM9hvhI+ffmJ0jYUDolkoBF4B3CSbpqYhMG6l/fVctOeIdhKxrVtKv40U1
	ezh22Mut47AHtiIHHJCYJ3/5uwH60cI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=TkbN7JC4;
	spf=pass (imf19.hostedemail.com: domain of matthew.ruffell@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=matthew.ruffell@canonical.com;
	dmarc=pass (policy=reject) header.from=canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=axvLEFAtLHuXEMPFGyntKrpt+rf9qpIaNSM/g7iVnHA=;
	b=JVB4YTdv6EGz2r4fS16wYEAK+62RmVKfUV565PKA40zRpCP0ADPHzsftyXZ9d8xoupgMVd
	3/A0BFQB1sZWoX2v1YITs3tfrZs8uldmKKgufuJEbPv4egztvOoZ9MOuG13ZDM4fusQoMt
	XUQPyU2CKvCDQY12jsjFj/xldq1Yx+w=
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A99743F6A0
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1793692844;
	bh=axvLEFAtLHuXEMPFGyntKrpt+rf9qpIaNSM/g7iVnHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=TkbN7JC4NwqwaC8NlTPVX/z0ilUl0WHS85fzKdAsXkY2S3lCCkCafb5uW3wMznFqa
	 hXOoWSGdS4uYj+BQrSVsUoq3i3TCwB4sIYpQhEzvJq2Q/rGCo3jWE1rWY8mAISJv7n
	 fQ0z3ycWoMEhu8Ae4o3M54WwrNFGkm+j+MQ4dSrwkvJUB+nCY/V/aqyRXSRq2YvH6F
	 ebSDs/NRiNOhRY0FdCzlFQF7uHHwB0P5YS0SXMgqODf2Fa+9xsPXUmxQA4ZweNmo2t
	 x56+D/u/jDkNrUL0GdmNazJkgC+kG2f4ihQq01MDpzvxCvvKIvw4rXMwQEZYpoKC9o
	 Er5zf8sX3yQ53VTLE8j7+xyHR0lqAMZzfF1TT8ijpSBasT+UaBgwafhE235h4GjS03
	 wu7LQBv2vtjzsznTJC+w8rFQ3D9EupmUopDCUqCbz07pdvrH5UJAoGyRgmjpoWzY0z
	 xQmgwTJmDPCMOjoTmvE3TWjWU5/VbMIKoiGqR2bxbU/pDgHIHeXLCPQj1KES8LXhd6
	 BzhdNA/n1AdHw64yga6Ul6PrAdOIGITUZWU6ImoV7WGk0Q7MQcaV6zmCrMiurTcyVB
	 fRnEDhn+jPMXKQITdX9nfGSBnXlawAoOLf01P38gwr38Op/7es+qRYwWKXWOGMsluu
	 gRQjUo+kqELeGE80P3LmFDrc=
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-35c5aef2a74so16515361eec.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 00:00:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793692843; x=1794297643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=axvLEFAtLHuXEMPFGyntKrpt+rf9qpIaNSM/g7iVnHA=;
        b=mqqDxwcLfAThsR4rxYOe1EJGIiCUfSTDGt++NDApjzz5Uo0QqNHg7WqoIPBoTekBpv
         M5M23L3e/9PaAr9m8LvLqLZ8j4HiTp1QLNtCReU1Kq+AnhOAc91C/50IJzz7DcnvqocW
         0N91S4VHmDV5RC0N+ZCkyyJfFDC6VXV/KuC9N1c/0jcrpyYFySxvXuIhtvztTBTkyDBD
         wS9XjL0Vp6tRDzc42n7dnBawTy7e7PpYTwGQF3Uo5i0+ziusfNcWuut3Re7+IQuILO7l
         qtBrdFod0y2Hb2xOuNS1EXj9wFDAqZXh89svs9ZyNPBQt/uHFhiHsjx/fkr3xiFbZMJf
         FvRA==
X-Forwarded-Encrypted: i=1; AKwUvBzpdL4pJplfGq7EdWC2OiFJxzZ37Am/JMtj4bWKB4GR2GUckEYpaHyJU9GS0/Fq8d1EP4cX7Cclwg==@kvack.org
X-Gm-Message-State: APuU4Z+Q8OBWdH1EaIeImeiQIu9I3HR5Uxx41H4oU4OvYKSlH0tIQ/iH
	By02FDtEzXKzCQSGimg4czfB3uvlX58t52Kuj9fXXjkPxGOGYtVXY5DOuj8p/urTvCoqXozsUwk
	dl7IotLYDqltDdnJw3i6iC2cksLm7QpVeAoP3eyLMouAETRCpA+BgtBJLcWE0XY8oOlIJ
X-Gm-Gg: AYBFou0zPVhAcRKlD2jZ/sWNnIg7SuBAR2HwlYpAmnxGrONxFQuufbj88pM/kqPr5DA
	OE4bQhAnNbAx4tnR3vfxgP8CF0PpH3aJ/Y5qk8Fpa9zOQfLLy0/x9mqgZsJAz38/2U3vhkxv4z1
	HBlMh3a8uMHQ9uaCrG83S88pTYisNOH2CuUnDPgvto2KubkE8s3t2mIfceGaMN8DSwUimSsw8uX
	Gy6oMAVzp/gNnA/GAy2afN8Q/x7XcbExb5T+ylPbf2/0EXcJIHNtTYQ35YvQ1vsSg5TuoiLpfWc
	Z4fzCzsb3ViFnan4vXgR5v9oCJldFGb1KzB+zqAkftYhFFotV9WDgv6ISyS90Kq+mWAgKpCSqg8
	JUrg5UD4wgHaV6VWK72ASg5KSwgJninLf2ZrVCB/HAr6JklQRqJc+xR035RdAHTDdBorGa2zPMR
	9r7P+baF5N1JcIleoxnA==
X-Received: by 2002:a05:693c:65d6:b0:368:72f0:353a with SMTP id 5a478bee46e88-36a42431e17mr15518470eec.38.1793692842720;
        Tue, 03 Nov 2026 00:00:42 -0800 (PST)
X-Received: by 2002:a05:693c:65d6:b0:368:72f0:353a with SMTP id 5a478bee46e88-36a42431e17mr15518408eec.38.1793692842058;
        Tue, 03 Nov 2026 00:00:42 -0800 (PST)
Received: from Garunix (122-58-163-222-fibre.sparkbb.co.nz. [122.58.163.222])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm37885274eec.4.2026.11.03.00.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:00:41 -0800 (PST)
From: Matthew Ruffell <matthew.ruffell@canonical.com>
To: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH 3/6] mm/folio, mm/mlock: Don't batch folios in per-CPU LRU caches on isolated CPUs
Date: Tue,  3 Nov 2026 20:59:37 +1300
Message-ID: <20261103075940.110308-4-matthew.ruffell@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103075940.110308-1-matthew.ruffell@canonical.com>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5xchssw756sisao73b73qmjs9pb8yuia
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0E0C31A0010
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793692845-619853
X-HE-Meta: U2FsdGVkX1+rakn1WrfhA/RaLyaf7dt1WgCsHdpp4Ik4JZVB0C/CyyTxbfEYWvobGxHLk/rYI8RwVGBJya3AwpSKrN15pgjRTkETwzI/CEPAVzb0JwKUzrhBCoXYwktfh3GpgaKjoJruQfaWbnJy2LTt1rmoh+h8d5RVHPvhid10vO11ID2qaNCG0i1Y2zyqam5n3tGHfZHpJWRIZPYIY3WpbVrbN2jaOGMIwAX7wYIjWXJ4p33Zqdhs7YT9DmAiur8WHgo64qi1HRlNrMiqshCjGe8kPJE2LsFnauJOSSvc6LcqZ1/ij+LIFDyh+K34ao5L1hPEbCxJDz6wxWZU6zrCFZ1+xaxg2T7bC448gtE1h2gszuEqTQGN3bdzll4OwjPgpqFWeNisQkQkW6nf5r7s5AMD5RbKyLyk2m0IZ5QgaOqL6cLKY1bKVsgSM5D7XKbGlzYcE3russ6fBPR8AniIB7HQsK9UU13VekJAcALNirbS7T5nyz1KUPV8If2/XqM4PhIV+ffPs97+KzKE3wP+VSfuZPCZoLSo5hHTqGzZy11q9rZsv4ouZXXOIxBb0rcmuHkHes6Y7qQH9gLd5Gmzrpcxlg4X7X96biVGXSQBIpYc3wMOPH1WQ5lU8I26O3upOnJmpzIfof4pMSxSgn0Ud5LaEj5rhAEJbuS4Ol9+v1JmUQslI7vBjzngSU78NCkJqSSbvjFi2IbZLAl1KkMgdSsIJJsyfHntUMUfygzmsmzRQVhtbBK0TuHC2GlgpvrCee+t7i1YPFWLfcOtBDNGI+XSuAB3cj01AvCvjLbQnXIaKeMLskg7UZZkKhPBhAQiC/S3XPSdwCgAp9yiMmc/iUcImRXWXAF3GjP8UJZl6QkDSJIyN2ct6B/Z+vU/hktkgSVy3SJZ/itYwjWH7S486b3IwqSKpbuGjdkyrM0x4wIyUmIJ+bLW/6GwWIk+1ZZcTGZ4GjuW1xnbkMn
 sqdJiW4t
 abM75Qtjq/nlcm7NBUnL0c0oUYUXgEMJZC8SaM63Oa6YbLdIPq42ThyxgQLGj60EDz4PlSrvK8A6Uc3nIeTwTh/XhLCQACRV6pPXMZipXyxNKf75hd++edjUYRsPCUD4cZiCPH6nIPJ7EFWNlFotoSJlx6ktCcVunFh3/iHMstlqjNqwNQ2EDy/mkgQPTLvye5QjUGhU5UyX50kuclzdV8AnXsOjWm2x7gVAA5lIislubCWZ8T+8bNV88R7eWXY1x8ff11vWPQUlikEDx2JXTlZ6ZTZNNNG6Cii+ZJpmCYGeaNs9X4PzfhVv14sEa6eGBkGYwyYOVdfmYc2qmbGIKRm873w3nBuJl2rzGMC4VV3kIAp2gVAWpO8i+NlOqhovDF47FuEQv/bPO8L4k/fw6+Nw1gOr/6xzQBFEwKV5O/3v3DDl1k/bGXB257g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caron Wills <caron.wills@pulsar.com>

Folios are collected in per-CPU folio batches (cpu_fbatches and
mlock_fbatch) before being added to or moved on the LRU lists. Another
CPU can only empty such a batch by queueing lru_add_drain_per_cpu() on
the owning CPU and waiting for it in __lru_add_drain_all(), which is
what every lru_add_drain_all() caller (compaction, khugepaged, memory
hotplug, memfd, drop_caches, ...) and every lru_cache_disable() caller
(page migration through cpuset.mems, mbind() and move_pages(),
alloc_contig_range(), memory offlining) does.

On an isolated CPU that per-CPU kworker may not run for a very long
time, or ever: low latency deployments pin a SCHED_FIFO busy-polling
thread to each isolated CPU, and since RT bandwidth throttling is gone
nothing forces such a thread to yield to a SCHED_NORMAL kworker. Any
folio left in that CPU's batch then blocks the waiting caller.

LP: #2165410 hits exactly this. Writing cpuset.mems for a cgroup on a
192-CPU AWS instance with nohz_full CPUs 18-95,108-178 running FIFO
spinners makes cpuset_migrate_mm_workfn() -> do_migrate_pages() ->
lru_cache_disable() -> __lru_add_drain_all() -> flush_work() wait for
the kworkers on those CPUs, and PID 1 (systemd), which flushes the
migration workqueue from task_work before returning to userspace, stays
in D state for 2 to 10 minutes. logind cannot create sessions meanwhile
and SSH logins fail. The reproducer, a FIFO/80 thread per isolated CPU
that touches and MADV_DONTNEEDs a 24 MB buffer in a loop, keeps 1 to 14
folios in the lru_add batch of every isolated CPU at all times.

Stop batching on isolated CPUs: when the current CPU is isolated, move
the folio to the LRU immediately through an on-stack batch, without
touching the per-CPU batch at all. The latter matters: __lru_add_drain_all()
samples the per-CPU counters without the owning CPU's local_lock, so a
folio that sits in the batch even for the few instructions between
folio_batch_add() and an immediate drain is enough to get work queued on
that CPU. A first version of this patch reused the lru_cache_disabled()
add-then-drain path and was caught doing exactly that in testing.
cpu_needs_drain() now stays false for isolated CPUs and
__lru_add_drain_all() never queues work on them. The per-CPU buffer_head
LRU has been skipping isolated CPUs the same way since commit 8a237adf213d 
("fs/buffer.c: disable per-CPU buffer_head cache for isolated CPUs"),
and mm/memcontrol.c schedule_drain_work() does not queue memcg stock drains
on them either.

The cost is one lruvec lock acquisition per folio instead of one per
batch of 15 on isolated CPUs, which are not expected to do bulk memory
work. Nothing changes on housekeeping CPUs or on systems without CPU
isolation, where cpu_is_isolated() is a static-key guarded test.

Link: https://bugs.launchpad.net/bugs/2165410
Signed-off-by: Caron Wills <caron.wills@pulsar.com>
Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
---
 mm/folio.c    | 21 ++++++++++++++++++++-
 mm/internal.h | 28 ++++++++++++++++++++++++++++
 mm/mlock.c    | 28 ++++++++++++++++++++++------
 3 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 35e242b48870..7f85747910d7 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -208,6 +208,16 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 	folios_put(fbatch);
 }
 
+/* Move a single folio to the LRU without touching the per-CPU batches. */
+static void folio_move_lru_now(struct folio *folio, move_fn_t move_fn)
+{
+	struct folio_batch fbatch;
+
+	folio_batch_init(&fbatch);
+	folio_batch_add(&fbatch, folio);
+	folio_batch_move_lru(&fbatch, move_fn);
+}
+
 static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		struct folio *folio, move_fn_t move_fn, bool disable_irq)
 {
@@ -220,7 +230,9 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 	else
 		local_lock(&cpu_fbatches.lock);
 
-	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
+	if (lru_batching_bypassed())
+		folio_move_lru_now(folio, move_fn);
+	else if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
 			!folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
@@ -856,6 +868,13 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 	WRITE_ONCE(lru_drain_gen, lru_drain_gen + 1);
 	smp_mb();
 
+	/*
+	 * Isolated CPUs don't batch folios (see lru_batching_bypassed()), so
+	 * their counters stay at zero and no work gets queued to them.  This
+	 * matters because the per-CPU kworker of an isolated CPU may not get
+	 * to run for a very long time, if ever, and flush_work() below would
+	 * wait for it.
+	 */
 	cpumask_clear(&has_work);
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);
diff --git a/mm/internal.h b/mm/internal.h
index 566cbd2dce48..5888f7b5ea5c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -17,6 +17,7 @@
 #include <linux/pagewalk.h>
 #include <linux/rmap.h>
 #include <linux/swap.h>
+#include <linux/sched/isolation.h>
 #include <linux/leafops.h>
 #include <linux/tracepoint-defs.h>
 
@@ -1006,6 +1007,33 @@ bool need_mlock_drain(int cpu);
 void mlock_drain_local(void);
 void mlock_drain_remote(int cpu);
 
+/*
+ * Folios are normally parked in per-CPU batches (cpu_fbatches and
+ * mlock_fbatch) before they are moved to the LRU lists. A remote CPU can
+ * only empty such a batch by queueing lru_add_drain_per_cpu() on the owning
+ * CPU and waiting for it, see __lru_add_drain_all(). On an isolated CPU that
+ * kworker may not get to run for a long time, e.g. because a SCHED_FIFO task
+ * busy-loops there, and every lru_add_drain_all() or lru_cache_disable()
+ * caller in the system then blocks behind it.
+ *
+ * Isolated CPUs therefore bypass the per-CPU batches entirely and move
+ * folios to the LRU lists right away, through an on-stack batch. The folio
+ * must not even transiently sit in the per-CPU batch: __lru_add_drain_all()
+ * samples the batch counters without the owning CPU's lock, so the few
+ * instructions between folio_batch_add() and an immediate drain are enough
+ * to get work queued on the isolated CPU. The per-CPU buffer_head LRU
+ * (bh_lru_install()) and the memcg stock drain (schedule_drain_work())
+ * already stay away from isolated CPUs the same way.
+ *
+ * Callers hold the batch's local_lock, so smp_processor_id() is stable. The
+ * housekeeping cpumask consulted by cpu_is_isolated() is RCU protected.
+ */
+static inline bool lru_batching_bypassed(void)
+{
+	guard(rcu)();
+	return cpu_is_isolated(smp_processor_id());
+}
+
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
 static inline unsigned long __vma_address(const struct vm_area_struct *vma,
diff --git a/mm/mlock.c b/mm/mlock.c
index 67ae9b18b923..3bb8195e5c5f 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -209,6 +209,16 @@ static void mlock_folio_batch(struct folio_batch *fbatch)
 	folios_put(fbatch);
 }
 
+/* Handle a single folio right away, without touching the per-CPU batch. */
+static void mlock_folio_now(struct folio *folio)
+{
+	struct folio_batch fbatch;
+
+	folio_batch_init(&fbatch);
+	folio_batch_add(&fbatch, folio);
+	mlock_folio_batch(&fbatch);
+}
+
 void mlock_drain_local(void)
 {
 	struct folio_batch *fbatch;
@@ -254,8 +264,10 @@ void mlock_folio(struct folio *folio)
 	}
 
 	folio_get(folio);
-	if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
-	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
+	if (lru_batching_bypassed())
+		mlock_folio_now(mlock_lru(folio));
+	else if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
+		 !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
@@ -277,8 +289,10 @@ void mlock_new_folio(struct folio *folio)
 	__count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
 
 	folio_get(folio);
-	if (!folio_batch_add(fbatch, mlock_new(folio)) ||
-	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
+	if (lru_batching_bypassed())
+		mlock_folio_now(mlock_new(folio));
+	else if (!folio_batch_add(fbatch, mlock_new(folio)) ||
+		 !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
@@ -298,8 +312,10 @@ void munlock_folio(struct folio *folio)
 	 * which will check whether the folio is multiply mlocked.
 	 */
 	folio_get(folio);
-	if (!folio_batch_add(fbatch, folio) ||
-	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
+	if (lru_batching_bypassed())
+		mlock_folio_now(folio);
+	else if (!folio_batch_add(fbatch, folio) ||
+		 !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
-- 
2.55.0


