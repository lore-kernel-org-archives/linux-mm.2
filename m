Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92240606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KuvBsqGQ
Received: by kanga.kvack.org (Postfix)
	id E9B156B0821; Wed, 21 Oct 2026 21:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47E06B0822; Wed, 21 Oct 2026 21:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5D676B0823; Wed, 21 Oct 2026 21:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90E3A6B0821
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:58:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5AE6120736
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:58:04 +0000 (UTC)
X-FDA: 85348601688.25.A81A029
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7606F20006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:58:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KuvBsqGQ;
	spf=pass (imf31.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792634283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=erBvMxyeCCyC8K/1NyLhHI0mkOqFJyJCPxOLNLg56iI=;
	b=V/fnltvLSQtW5kY+o8bmyFrdVWyrj4Kgrs59dHgz9NqI0BKtsEYUqBj8gFsPO76JYtni6l
	seLIk6kiKSfyf5I6o3IeQLEjq2QPDxt3/x4pz5Th3xOcWF/9VjatC5RPKafHBeCh3Dx8tr
	rDvpvhnul/DFVJpzJdGPHRyKfCEp4MM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792634283;
	b=XZZEpmcpPU/8AGR4sk3ADIvpYkF4Kd44ZtaM2oJYOuUS/MCgyfma3b4LazKjepa1toGuJG
	lr0KOo8JTxJputWKZEKlsTgZFYjXEv/SL02vGQV3Rs5tdK3OdqzzpcrWUm3Tq5RL/hMwHN
	7EJM3Ekp75vJm6agF8Nrae8GhGGBEw4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KuvBsqGQ;
	spf=pass (imf31.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc4b1f7e8f4so523117a12.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792634282; x=1793239082; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=erBvMxyeCCyC8K/1NyLhHI0mkOqFJyJCPxOLNLg56iI=;
        b=KuvBsqGQQFdT0xGHNhsz4lz9FHkFs5QTlJQgRhERdSI4buOesANKQ4UGPAnGPyUPI3
         3vtF1wr59zEBVQSCVCa7xinKuCFLaUZOtXqR2mjPeLZUGyXepnfpHhm60jxpJjf8MRCN
         NUN+95QT8yuApHhC8vctECURioyCYohUGuVAwhfwPE4G/6ztuOmNGqis8mqqbv0LTZmv
         58IbVQW0B0Pn3pqYIqOu/9InVvpJfU/Eh1K6fI80agATbeAPS6sgYPrz0MHT4+YZ+qIx
         cZ44e24155desiaEiqDD9jXmkZL84Np6sSqwxURdjVTa6la808Bjygd0p18I0PhUzcW+
         F7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792634282; x=1793239082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=erBvMxyeCCyC8K/1NyLhHI0mkOqFJyJCPxOLNLg56iI=;
        b=d679W69iL6/l1AlVQW2IJ2JwlxYzIZcv9Wl7hnaCov0VLsyQOpn7MfcFoHSFlvtbo8
         ref64CRbJgZnFWgpoHuT7aWnUYHV+7kg4/xC8HuLbZNeoiGdzSvbyEoH41z3qaC/o72+
         Vialjmj6Jz8no3LqNz7BFSU4z49WYipZ8MbQm+t7ksNUTe5D/T4EJykHvV82uBEwm/0A
         hWs1jLWlulz6kq7Fg6QRy/0Qtn+fijpWADFuBitmjwS/en5fcGxHEb/3IYbBDEjPywjI
         +BQyeyRM5KjsDtWptyfePieLidS/04/r7SK0MnPazvUiS8kei/Deuv+0fW4PyJyc8Nwy
         +x4Q==
X-Forwarded-Encrypted: i=1; AKwUvByASx6fcc/j9QJciymH/jdf3J8VIBh/sIJswKrkB8JYSVYY0yXdSM5/aOk8yr/8y/feLrbpOryzjg==@kvack.org
X-Gm-Message-State: AFq9FYK04OXvZuVGaWbvMRCb9NyPnijAy9zVFMKJ9Ph3S6j2KAK7HwYg
	X9IkGPbpKn8ldxNGQ442MZl3AM2bEb39iZdibvPzyRKAHdV7pD89ELns
X-Gm-Gg: AYBFou0eZRdvwBap9PCjTl+gJnb3XmZ2CXa6wJJUbE7m3LZfXkVypS2fSvqnyl5sOde
	JFexGslmWSW/PD7sXmeCd5hwoc/jVvSxvfwNhiFSKj5kk9cGHIbraKOt9+qQxcEwMfkKkfc55p/
	oSk4P0IxxNCRANR0l3Z15Lb4UXoMWceKsDZcuEyscaaMHK77TgQYGT4sMkKlKAtvkHNtz8Z3Z34
	XpegkG3/WlNt6uT1OK6bJypbuf3OQeXd2UfBGSrO8NRTKzCkgVYC0Cl1N1cfXL0KEiwXCUUNQhA
	EhgPdXMj4TReYygWirFpqsyprfxVANwPhGZ3+jPSvR+TNYgXDsTO6Tj2imqjTrpRnzh8ugxrwRH
	gq5uUUjwTQN8LT4d9doIdZFG/ugHrMJqvdAi87S99bzEf7QqmtaT+jj2tHerBc9mx9Z4HOVtDne
	FU1K407+mHJDPMEQ95PaJbn6v1TMYVYPkoM0RXERKtzy6H3ZO/mGseTBnNckDFyySCD4gjVl6R5
	56DgsM/pZNhCbb23et1Q08E0YZ7AoTSfuB25RCrq/YncXPbQwp+loZKtLAUF7q9xzrl+IysYYSx
	w7Nr+nu5O2S6JvimUwFuHxefVjVjwiLS4+TPR07uw4GEbjH/Y/8ydf7B8fDSRYte72Ny4hUfB/1
	0Cw4oWnWJ15sXctjUKOlFFLa5
X-Received: by 2002:a17:90a:e7c8:b0:3ab:d45c:59e2 with SMTP id 98e67ed59e1d1-3ad86f1b28fmr2821607a91.55.1792634281882;
        Wed, 21 Oct 2026 18:58:01 -0700 (PDT)
Received: from coder-ast-ast-dev-ml-0.tail2dda0.ts.net ([153.61.198.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada490e5edsm1751706a91.8.2026.10.21.18.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 18:58:01 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	oleg@redhat.com,
	peterz@infradead.org,
	mhiramat@kernel.org,
	jolsa@kernel.org,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	surenb@google.com,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	hughd@google.com,
	kees@kernel.org,
	mingo@redhat.com,
	tglx@kernel.org,
	x86@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 7/9] fork: Let the new task point to its mm before uprobes can find it
Date: Thu, 22 Oct 2026 01:57:10 +0000
Message-ID: <20261022015712.1297331-8-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7606F20006
X-Stat-Signature: w44xxmkqkzk54fuhfjm7ci4fygpsxe3h
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792634283-580855
X-HE-Meta: U2FsdGVkX19m780OR70N1xOYDVIaGgdFpLtxNytiYlPJVrFGlJ7caCnIKPaUFcI0GEzlj9+qBRv4aT1DphEgt1+K90t0H0OwPUsXyCSuc23FbTVixpa9F0wSuQTD7GDeaGh7EPMmR+CN1+Leio5BOElkbnCOy0zorEX/0addz8O+xKfBl9HeoLFRQyeArIwp7dqZJ+bFgDF+suCj4qkG4oKw6Z7idzLZkXYprEOutg6u7Fnm4lA5Py4Ye0SIazqu8VOdkvpa33fexYKRX1FyETFn+xmkoh5SUImwDW1PvTXdw/2LdaBONnT0cq67hMS9zpkjf4lyuMPM6EQEg6ITmEe3M1JEM3OEpuuOtlrOjnzADhkyaKR7X2Bzv+macpUiRhKK4g+IA3sl/ocB5RunQWf4eTVse+tU4voZLPAlqIMbrGQZq8xK7K0iXRnzglDC2KNP+LeRbM/itK6Du3p/JHPuFRj/C4R/2Od+fgKsj1gdB1kqZE5KM5CY3e1368JaRhZFS5Ti+yNwehFdclb9QGUfqBuNwTCqHvzO6w+H8qclwOhAo9ZlO8ZPhud8XS2jQ/76Hz/QzBsIB0viYtFcR9R+feKioOV/sW595jUhgmbIaD7K4NIPZq+YsTgmxq3paTf5vtHT0afiaTV3OPu+5MNP+OPZrCbWytw6MpxJrj5xw9fgNn35qCVSD7kvo0SHZGhiARuORCotnBGvT1cGzP/sGgmAYa88MXOdUwzyqHbn6GTmyGjM6PFrpBn6z6YZOohbgRLLDtdkug8B6MYqvvYethqjKfDVxfmh0yOndGiKiOuw2z4QWy87jJUhrKzi1MBqbP3svbDaP9ogZyc7H1AgkTrn4YAvNB823+/R/rfUeezQw8WHG0UftM9QF1GU4meubc5XqFxsKJARfnQVOiQWvWMrfIChMiWJ7jeNeh3W4ijZVMvo1d93zBEiYsQjvuigWViIjTj4Jr8VNAT
 M8Z5Ex0D
 DzrXH/RM4fbvn69TXQFpwmaiaXwZia6st1XZVM4DN1Du6uPV2gyR0v/V+e2Vc7wrZv85lM9Fe8Qb3AsA8yTthKxLwKtpesi2J7czYVQM8MvKIuKkrKkSR3iVSr1KCbl5yGDsliJnMOAVMwDR2vT88fSv0DKCdFDDhYRGyxT9zdIePoa6kTLhZBBBemyJfrzQqv0DW1fEObcmItVVxU/tPOOgn4H/U2OoAUQBS9uJxT3CVWuk2J6Spxe3quLVo4ZbjDKvn7XhKARpQsM2n1mYs/zvTivhZYnI00rbjRKrMbZxfS31ATdGEAuD/iD9Ci4XVRk58zytvkkuiN6szYUwE2AwGiodJ+P3zI7uf4qxqjepuUEe1WfWf8TQp5LUIl4l2Bfx15MMMMaC3BijjjZBouLcyRcnhJF4+ngJ6I/k4TxFadCxcLKTAy69/7h/rU8vpGFTkonhLlu8PPwtNoluWap1gUyEF7K1+523Hja5pf/FJLLSvtYfQvSnfvUynmxLt3JPR7PBJhQtHUu4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alexei Starovoitov <ast@kernel.org>

uprobe_perf_filter() compares event->hw.target->mm with mm. The target of
an inherited event is the new task. copy_mm() sets tsk->mm after dup_mm()
returned, but register_for_each_vma() can find the new mm as soon as
dup_mmap() releases dup_mmap_sem. No task points to this mm yet, so
the filter says that nobody wants it.

The walk that removes the breakpoint, because another consumer of the same
uprobe goes away, sees !filter_chain() and removes it from the child.
Nobody installs it again, and the inherited event doesn't see this child.

It's an old bug with a short window. The previous patch releases
dup_mmap_sem before dup_userfaultfd_complete(), so with UFFD_EVENT_FORK
the window is as long as the monitor likes.

Set tsk->mm at the end of dup_mmap() before it releases dup_mmap_sem.
Not earlier. The new task can be reached via its perf events and from bpf
progs. They shouldn't find mm that is half copied. Clear tsk->mm when
dup_mm() fails after dup_mmap(). Do both under task_lock() like exec_mmap()
and exit_mm().

The tasks with such event fork, while another consumer of the same uprobe
comes and goes. 5 cpu VM, 90 sec and 7000 children per run. The number of
children that the inherited event didn't see:

  without this series          11 to 24, 8 runs
  patches 1, 2, 5, 6 only      23, 12, 21
  this series                  0, 0, 0

With UFFD_EVENT_FORK monitor that reads the event after 5 sec the child
lost the breakpoint in 5 of 5 runs without this patch, and in 0 of 5 with.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/fork.c |  9 ++++++++-
 mm/internal.h |  3 ++-
 mm/mmap.c     | 14 +++++++++++++-
 mm/nommu.c    |  3 ++-
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8fd6be932afe..5a2f571b64b7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1539,7 +1539,7 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
 	if (!mm_init(mm, tsk))
 		goto fail_nomem;
 
-	err = dup_mmap(mm, oldmm);
+	err = dup_mmap(tsk, mm, oldmm);
 	if (err)
 		goto free_pt;
 
@@ -1552,6 +1552,13 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
 	return mm;
 
 free_pt:
+	/*
+	 * dup_mmap() has set it if it succeeded. get_task_mm() must not find
+	 * it after the mmput() below.
+	 */
+	task_lock(tsk);
+	tsk->mm = NULL;
+	task_unlock(tsk);
 	/* don't put binfmt in mmput, we haven't got module yet */
 	mm->binfmt = NULL;
 	mm_init_owner(mm, NULL);
diff --git a/mm/internal.h b/mm/internal.h
index 9e3be236f18c..70e40306d881 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1520,7 +1520,8 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 			  pgd_t *pgd, void *private);
 
 void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
-int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
+int dup_mmap(struct task_struct *tsk, struct mm_struct *mm,
+	     struct mm_struct *oldmm);
 
 int remap_pfn_range_prepare(struct vm_area_desc *desc);
 int remap_pfn_range_complete(struct vm_area_struct *vma,
diff --git a/mm/mmap.c b/mm/mmap.c
index 6ce654e33e3b..3167272a77ad 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -46,6 +46,7 @@
 #include <linux/pkeys.h>
 #include <linux/oom.h>
 #include <linux/sched/mm.h>
+#include <linux/sched/task.h>
 #include <linux/ksm.h>
 #include <linux/memfd.h>
 
@@ -1705,7 +1706,8 @@ bool mmap_read_lock_maybe_expand(struct mm_struct *mm,
 	return true;
 }
 
-__latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
+__latent_entropy int dup_mmap(struct task_struct *tsk, struct mm_struct *mm,
+			      struct mm_struct *oldmm)
 {
 	struct vm_area_struct *mpnt, *tmp;
 	int retval;
@@ -1897,6 +1899,16 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	mmap_write_unlock(mm);
 	flush_tlb_mm(oldmm);
 	mmap_write_unlock(oldmm);
+	if (!retval) {
+		/*
+		 * As soon as dup_mmap_sem is released uprobes can find mm via
+		 * the rmap tree and ask the consumers if they want it. The
+		 * filter of an inherited perf event looks for mm in tsk->mm.
+		 */
+		task_lock(tsk);
+		tsk->mm = mm;
+		task_unlock(tsk);
+	}
 	uprobe_end_dup_mmap();
 	if (!retval)
 		dup_userfaultfd_complete(&uf);
diff --git a/mm/nommu.c b/mm/nommu.c
index 68b05565e15a..7529e03d3f2c 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1885,7 +1885,8 @@ static int __meminit init_admin_reserve(void)
 }
 subsys_initcall(init_admin_reserve);
 
-int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
+int dup_mmap(struct task_struct *tsk, struct mm_struct *mm,
+	     struct mm_struct *oldmm)
 {
 	mmap_write_lock(oldmm);
 	dup_mm_exe_file(mm, oldmm);
-- 
2.55.0


