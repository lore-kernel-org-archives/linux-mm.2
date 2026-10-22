Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D0D606A320
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=g665lMZI
Received: by kanga.kvack.org (Postfix)
	id EE61C6B081F; Wed, 21 Oct 2026 21:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBCA36B0820; Wed, 21 Oct 2026 21:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84756B0821; Wed, 21 Oct 2026 21:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A80456B081F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:57:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BCB71406B2
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:57:58 +0000 (UTC)
X-FDA: 85348601436.20.D34AE8D
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 63F5C40003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:57:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g665lMZI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792634276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fW9kk5xIMv5VRWKeoldYnyO29pC8D9VMf22Va3ehq2w=;
	b=g6d68gmF3NuwzBJj0tqHhsGp9t3LDlnROsnoNVJPMKvJ6BhMHSeqp+AJ3onzn9K6DapKyv
	a34SuDy5gfrochzTG/XVXDy7l5mnsqqgI5uf39+fInMcfR8xWYU+2y2Ppj11YLDLghsgGf
	WoOm7orDdkpvTQ7bvICEl2bY6R9EE4E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g665lMZI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792634276;
	b=E4XAdZmgK2RuGQGPowKw/Sm28j+sXnOEyUpV40Fpe/elZsK+EjEgLDlthZyU7C9LDef8Kq
	xHDTb93NOLV1OSItLcknpON8aLATf5cmeNusksYE4kPYLZuzHTRJMkbgkgLW3QOP0jzCoD
	lzlWPRHqzMbk8N/HcRYxnspwdVRGYnY=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3ad41b47541so1137505a91.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792634275; x=1793239075; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fW9kk5xIMv5VRWKeoldYnyO29pC8D9VMf22Va3ehq2w=;
        b=g665lMZISJu4DafRs08ww4aVILftdRHaKTn+QxeCUcxOnNKp0cgQXebRKVz1Z0XWA/
         q4UQZ8hOetQwGIYAVS4CM+FbhXuEpKJQvXRY5fSOzNNxy/V5n4rsKYK//bdeAX/emCP+
         bFojzjlbxW3bIr4ekG+UYedisn4FrnJe4jMm63Ov67vAmZg6liXUiu2uOlZIbWlyELMe
         qeJlR5QYEo4D00wrEr1e9bUfnHsJOxZ/+TkE/NrXMYepUGjwqSNdoUEKJ9jYHGcvyvpI
         pMJeemLF4gjyFq9nt2iBNESrPMO6gHIwnKO7zCselMi14inQf8Ho5sq32xt7U3DoEAyw
         75YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792634275; x=1793239075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fW9kk5xIMv5VRWKeoldYnyO29pC8D9VMf22Va3ehq2w=;
        b=viHt9HT4RpTYphbcStJKryCR/OqRH+HHxZENrjlzLSOvCxzusH4v0T/YdXPNXGbDS2
         FLfv37VOBYFKxG1PmSHO+NHLW2wv+qM0mb8418riB374vgjL1saUZAtaD9p8lew1Kcss
         /1aoH3QSibRvmq0dISRdqJgl4ZValgqqeUnBMs92yPbXdI7pDYa2O6CSf+jkazwDjS00
         vC7BcZZ5kP6wPdA62e1AGqVWzBsPQ2u2GkiBzHeSSluntU43C65qFZDveJf41B3wU14r
         NQT2wL7EJG9DGVGtwnTF4BTDzfaeeC+0ItFbqwdteInOKnZ1o5cHKtWWq7Tn7R/24lRo
         j5TA==
X-Forwarded-Encrypted: i=1; AKwUvBzaemfW7V2lMVeZkq2upEgqvH4W9EybCdmENdKxtsyUw69RgTLM86WkTt9DWGfPD6hqcxbmJGQk7g==@kvack.org
X-Gm-Message-State: AFq9FYICKmIX0J1PZ5N1dfrXc1k+hPi8zepPXYKHJM7Ze65uBEctkOE7
	wNxupbZyURU+WaVWRCXxGkQFOKTmqnX6POOFxlNoNJVpBGj91E+VOo3j
X-Gm-Gg: AYBFou3bgV7CBVYe5B5Hmhyio3sE4ReswUKbuQfAlrwftUH1hxgdKWnibm2IOrTfGIq
	Aum0r55duG+3a9bxBejxnIxOVe6vWebf2kcJ11J9I0PwLEIORzI5vQo/TgvEA1klqP4sYeaSvVx
	oZvui6SBORzBlFnoV5cuHCi5LVYWdXU7EtrDdngiA6FbeXk2WZiktPuYafOVh2/D91wMjNvTX+/
	CU0CWmz7fg9LOlwdG18FhorbRQwQf2L3UcIH7GMHgszw6iV3+gpBUtzG4gZupX4lI0JWabsV3cZ
	eudHCFoo1hTt1B9YKn7cJ4wtjEzdxK05CaePrg+BYM1zIqcP+Ka6/TcGD/KMnP2UHe1YLKJKXa+
	bC3WAfWuRUyhHJ6lHHxwfzQvq98xnPeiUKWVrn0P1/iTEBvmMvsedRqrysNLVpN42Tf0ZLON5k/
	RCaao4LxD9VwpTwBPFt/Rjy9/URhCLtazzLDKLSt4QcUYthSX+1aHCXhwCj8mJFHaeQGswGuCYG
	2SHlIAYey89RUBcPPhfygBYKT+MeZaUP1MVIoRgFwSsSKDSQ7w+xsNz1x56FIi8gsnLbyKxYQkW
	gdNvbm4nOnF4Yat0wouBG4/UGtOeFYGUZAbKSRRWNzJGXoUMfDKGUdKtPJODgkIIHLt7c3oGmCg
	dyxmMJ0OyHDbNbnth1QZpacji
X-Received: by 2002:a17:90b:4b0a:b0:3ac:8446:c1b5 with SMTP id 98e67ed59e1d1-3ad86f45340mr3130506a91.31.1792634275135;
        Wed, 21 Oct 2026 18:57:55 -0700 (PDT)
Received: from coder-ast-ast-dev-ml-0.tail2dda0.ts.net ([153.61.198.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada490d4bfsm1991495a91.10.2026.10.21.18.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 18:57:54 -0700 (PDT)
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
Subject: [PATCH bpf-next 6/9] uprobes: Don't sleep on mmap_lock with dup_mmap_sem held in dup_mmap()
Date: Thu, 22 Oct 2026 01:57:09 +0000
Message-ID: <20261022015712.1297331-7-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 63F5C40003
X-Stat-Signature: wesk89qqag7dsprgkuzh4wk51be49c5k
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792634276-534948
X-HE-Meta: U2FsdGVkX1+WRofVqmKZ4pPgW5HVlWtc7OJgSdCIF6BXN4aQaQr4rQp4zCT2BkPR2OFSsy+Sjh1257UYxmUCW0Wnh7OPurUwqDooiaN0LLMshE6Uo91gstEEpqqPF3nrbBLIZz9U+ZwrhE1x+ZgjNo5Bl0tZPrE5SHBxKl2VnXxs8EvyCpEEfU5iVo1sZSsjtpMJ76y5FgL3gIXA81kU96SKZ495gBle85SqL5qeP586xSnrDvFnWV8781VzKBuG6NFSQhbOfImyHhWcQ+bg0dol9xSliMw9ExbXr0oSY7IFIybRfqKmH+r8W1Ax1zDkkZh64/8vw8tgEI/Gk8TmAr1cgy7XzMbclDF2Bz6nGoEHMaEdoSSyIRc8UjuTK64PoApEIo7XASIOAEfmBKRVc/0IZT9cYwP0DeQW+EjiPl2DHAlRSx6gHRF5Lvuz6K/S9sy4AbVJAiBWScG+xo1r8P1XbDa3sHoaBVzyPxp34ToWspRonoRTgY9cGcW5CzrCtJV8mUPPu9u1k0fy40Oz7e+poox8pbz99fADECw3CFJBGoiTR4Sh+GVthba2iFgUyDPwljDTwEK3CE5tX/79mfHnu+uk/gbHnxDf1yBHP9IxXKgkWzkxy6F0LGnK7HUbKB4aWfn78rUtZIl/4zC9mI75Ojq8dTvBIrFPbyhOoUCbX5HJsS9s7r3Hd3Xet2vsxOsp9xHDIrrXKxmb/st6EXix/6f988G3OdQ12DLwRmwz1nquxpwl4L2cHq+L93Jsj43LedEEUoGUvjiLngohnSQp+k1oFpfsv/GfspmY2na5xV7m18LqXgAyWuDZKiD3884QWR4MEAh5eAmCIq30q1yz5npaIocqwMFhjbfseQoxwT01ZJtoNOcwV4zG4aph3I8l8SyXwILFYigjJVVdqs4AqFuDqG/ZKZH0JE8s3Ny7m6UYgN6RmOV7r2wzRMxbcaXGkI0kqZ6CDhC1ieE
 VwNv7nIF
 NOu/Upj6OqoLDfdbnK9mG1agIIWwEHVhXNAExorJxOfmXuHJ7ZZHzl/RcJtXmwR+wCMvDjwjXhmx4yRw3XvZcL3tLAPwFE0hNTdakyCAqFh9FJlU9GzCHIDRAaiMM5YG+Lk+vkJA5gKCs3+JWambb4AtM6Ph58itXMoT1uI6c0wLxAKxbpU0R16JID6kZ/tOCzmORCCTBH9GNG0sSHaT+At+TY707llrzOIyCJFspykILK0KVEOlWbvOvn8tV0lTu/nNQ6gxE+1T7s2yOSnZSnB2ZpySfo6VlOK3FJQ0MT7yol2bRQjmkzxZ8viZnenm/OBTBWZmxrSNC7/gqg8EC16hwKUx4MnifmY6uvlGdSjGvTDJ2JWd+Vf92JwPdpfettdFu3cqzMUXM+9RuZlXRGVw14OI/494FQUkvogqzavn87wzXm4IUSd6SHUgh+hHcwKcSwd3kvQCIqMsF4dP7791NeXUGDauVcGVq3ZkHb/VAifAazPe0GF7pEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alexei Starovoitov <ast@kernel.org>

dup_mm() takes dup_mmap_sem for reading and then dup_mmap() sleeps on
mmap_lock of the parent. When another thread keeps that mmap_lock busy
register_for_each_vma() waits for the reader, and every other fork() in
the system waits for the writer. The parent doesn't have to map the file:

  A thread 1:  mmap(MAP_POPULATE) -> mmap_read_lock(A)
  A thread 2:  fork() -> percpu_down_read(&dup_mmap_sem),
               mmap_write_lock_killable(A) sleeps
  tracer:      percpu_down_write(&dup_mmap_sem) sleeps
  others:      fork() -> percpu_down_read(&dup_mmap_sem) sleeps

dup_mmap() needs both locks. Don't sleep on one of them while holding
the other. Sleep on mmap_lock and trylock dup_mmap_sem. If that fails sleep
on dup_mmap_sem and trylock mmap_lock, and so on. Taking mmap_lock and then
sleeping on dup_mmap_sem is simpler, but then all threads of the parent
wait for mmap_lock as long as the writer holds dup_mmap_sem.

Both are taken in dup_mmap() now, so release dup_mmap_sem there too.
Commit 8ac662f5da19 ("fork: avoid inappropriate uprobe access to invalid
mm") moved that to dup_mm() to hide the child from uprobes until mmput()
when dup_mmap() fails. Since commit 43873af772f8 ("mm: change dup_mmap()
recovery") dup_mmap() removes all vmas of such child before it drops
mmap_lock.

dup_mmap_sem is released before dup_userfaultfd_complete(), so the monitor
that doesn't read UFFD_EVENT_FORK no longer blocks every fork(). During
that wait register_for_each_vma() can find the child, while no task points
to its mm. The next patch deals with that.

Thread 1 of process A loops over mmap(4G, MAP_POPULATE) and munmap().
Thread 2 calls fork() in a loop. Nobody maps the file. Process B calls
fork() in a loop. 32 cpu VM. Median (max) of 15-25 runs, msec:

                         the longest fork() in B    attach
                         before      after          before  after
 uprobe_multi, 1 uprobe  206 (219)   0.10 (0.30)       220   11.7
 uprobe_multi, 4 uprobes 208 (428)   0.08 (0.32)       219   13.5
 perf_event, 4 uprobes   419 (424)   0.10 (0.44)       632   11.4

During detach: 265-293 -> 0.19-0.37.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/uprobes.h |  5 +++++
 kernel/events/uprobes.c |  5 +++++
 kernel/fork.c           |  4 ----
 mm/mmap.c               | 19 +++++++++++++++++--
 4 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index d34dbc0fbbfe..6d74efa80d04 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -211,6 +211,7 @@ extern void uprobe_unregister_sync(void);
 extern int uprobe_mmap(struct vm_area_struct *vma);
 extern void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end);
 extern void uprobe_start_dup_mmap(void);
+extern bool uprobe_try_start_dup_mmap(void);
 extern void uprobe_end_dup_mmap(void);
 extern void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm);
 extern void uprobe_free_utask(struct task_struct *t);
@@ -277,6 +278,10 @@ uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end
 static inline void uprobe_start_dup_mmap(void)
 {
 }
+static inline bool uprobe_try_start_dup_mmap(void)
+{
+	return true;
+}
 static inline void uprobe_end_dup_mmap(void)
 {
 }
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index a9274016c55d..92ccb730278f 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1927,6 +1927,11 @@ void uprobe_start_dup_mmap(void)
 	percpu_down_read(&dup_mmap_sem);
 }
 
+bool uprobe_try_start_dup_mmap(void)
+{
+	return percpu_down_read_trylock(&dup_mmap_sem);
+}
+
 void uprobe_end_dup_mmap(void)
 {
 	percpu_up_read(&dup_mmap_sem);
diff --git a/kernel/fork.c b/kernel/fork.c
index 10f2d05d816a..8fd6be932afe 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1539,11 +1539,9 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
 	if (!mm_init(mm, tsk))
 		goto fail_nomem;
 
-	uprobe_start_dup_mmap();
 	err = dup_mmap(mm, oldmm);
 	if (err)
 		goto free_pt;
-	uprobe_end_dup_mmap();
 
 	mm->hiwater_rss = get_mm_rss(mm);
 	mm->hiwater_vm = mm->total_vm;
@@ -1558,8 +1556,6 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
 	mm->binfmt = NULL;
 	mm_init_owner(mm, NULL);
 	mmput(mm);
-	if (err)
-		uprobe_end_dup_mmap();
 
 fail_nomem:
 	return NULL;
diff --git a/mm/mmap.c b/mm/mmap.c
index 4bf26b0f1e6e..6ce654e33e3b 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1713,8 +1713,22 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	LIST_HEAD(uf);
 	VMA_ITERATOR(vmi, mm, 0);
 
-	if (mmap_write_lock_killable(oldmm))
-		return -EINTR;
+	/*
+	 * Take mmap_lock of oldmm and dup_mmap_sem of uprobes.
+	 * Don't sleep on one of them while holding the other.
+	 */
+	for (;;) {
+		if (mmap_write_lock_killable(oldmm))
+			return -EINTR;
+		if (uprobe_try_start_dup_mmap())
+			break;
+		mmap_write_unlock(oldmm);
+
+		uprobe_start_dup_mmap();
+		if (mmap_write_trylock(oldmm))
+			break;
+		uprobe_end_dup_mmap();
+	}
 	flush_cache_dup_mm(oldmm);
 	uprobe_dup_mmap(oldmm, mm);
 	/*
@@ -1883,6 +1897,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	mmap_write_unlock(mm);
 	flush_tlb_mm(oldmm);
 	mmap_write_unlock(oldmm);
+	uprobe_end_dup_mmap();
 	if (!retval)
 		dup_userfaultfd_complete(&uf);
 	else
-- 
2.55.0


