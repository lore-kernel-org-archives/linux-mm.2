Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6941A606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nCMJj64e
Received: by kanga.kvack.org (Postfix)
	id 6A7D86B0282; Wed, 21 Oct 2026 21:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65F576B0284; Wed, 21 Oct 2026 21:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544C66B0282; Wed, 21 Oct 2026 21:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0048F6B0282
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:58:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F23B1A06FE
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:58:11 +0000 (UTC)
X-FDA: 85348601982.29.376E34D
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id B95E9C0009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:58:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nCMJj64e;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792634289;
	b=pAungGFR8J3zdFVLhitqLFn/vRkVA3b9WNDIc/8G8BdL+xeB4k2O84Nio/NKQEMAmm5zY7
	CfEZ7/wgMJwM4GwBr3eME5FM+z0fjW2FdtkGgVWMuGViNvuHHYdn9dM7Ave7RvSf54JU6n
	VdPSkZzN8/irNCKCCQBSo0SETTtA0AU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nCMJj64e;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792634289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mq98Rc54j/apXLpD8jeCAQO2NMmsGpxAwTZHZJ6mXaI=;
	b=cMll5+5RJ5Pntr/Zq/4QJt6kk00i0MzjQeQ0wa7q3Rkv71LgcdVHtVhiB43i8spAEmxCe9
	2sxvuhCN2UyMye35veVTK4jD0wIC3dSKZTGBKOB432NFHa3SlUs2M0lirwNOjaciXOBYlU
	GwVHeMzvR50RWIgVvgTpN67rpATmdNs=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cc52c1b8286so203574a12.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792634289; x=1793239089; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mq98Rc54j/apXLpD8jeCAQO2NMmsGpxAwTZHZJ6mXaI=;
        b=nCMJj64ebSFCTRQPYvpcogSRNcxfm5BDnIO9d9yINWy+j8rFxJvrn51VtZGuol5G1O
         bNt8kLrw3uNvoIpdvGV0ZXhYFC5OFMwvzp4zWZkX8JAyD9l+IrA37P7wwyEUldrg5z3u
         9+jAj2jLAhsBHdq9G1valtYXr7TVr5XFM19Ax8Oksk6NUXEAPvKdbjjaoVgZN3DFXjvp
         TzEShYWwKCBxWXjCNGDHl4Axm6J2Pwk26NwN/Eie0lg9gxK68SXUR5laywTIWU3aArJx
         GP8ZINDR31h9KZlSLW7fBDfzpZRk8kIxNCI2VyEEHd9D4Vx7+U51rk0Om7qcbV6TRTCW
         hTrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792634289; x=1793239089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mq98Rc54j/apXLpD8jeCAQO2NMmsGpxAwTZHZJ6mXaI=;
        b=S7erHAaeMV2PEjrwpP1TuEdm/ivktRTFrXDEbWSMFDxcwmSpzAHutp4NEQcRkCol/2
         KPZJ/sTuPTyAtW7hjs3sYqhnl2D/gJBa0ywggN4xn86xNp9oKWabySruFEficJt4xooO
         B87xijbv0WRYcYfs6KiSxPmlwMSOTfXaAPRfNNej/SezTsK1qjYreYByc0KSClULdMkz
         nj605WqW3RQriYWK/x8jsr9bekmhod23xhohXsDscU4fmTiVUW9T6NNoh7YnXuBY6WBQ
         m/AWrVPN2JS/scR/m+lKFCi0RM9cwFgD+vkb3L6ZU42id/+cGgByxYstP1UWBgfLi4Mv
         qqKw==
X-Forwarded-Encrypted: i=1; AKwUvBwlmFwLxgfqF8anFsp66+/kT1FfuSZ1fWK1IXUKdkrm/IUb7mWPg5PXAU7sSa7FJ9D1AVVnNemM6g==@kvack.org
X-Gm-Message-State: AFq9FYJPz0XbrpjZZ1POR3TFbX88nfcNIjcu8VXO3RUrQXppGhaYOQDn
	FkF6Gge7VmY8CuecuRMSTmsIFZCKbYV4ooatSbLMj8kMDxy4qLXcx9QP
X-Gm-Gg: AYBFou2YQTrahFkVltwQg3sBAqVpGXm50AgMKXitV/D1FJDHXa3yHAKH+v1MgYHhF4Q
	M+wtjUJhkuQLNbTLcW8Cc2xZw4evmHDEWFAB04NMPmzqJzVlQHD1h1i4NXbCzOCI1JosaYnluGI
	GS9RRTt2PGmIsS/N/hxJ/ZZX6hFj+2Nr4rSOJ78zKvHxECqdKp2CL83ozS/dkqNLuJ4UXM1uMDT
	7mdywxjQT7vwKxBHWsVWSl2qYvNqI7Hl1mqun4oKTwXiS59ZYvyTP6vYmtZUnj0K9o6R4GGxF+j
	mW5cVb5ukta4La/NYH92ysNGDZ36NqjCR2ZLVJndJuW9TAlgN73XxlAri1Fg63cvs4Q0YKzQ4l3
	pD9ZzC+KDNdLMpqGlEU7rFCWnrOd0b8xAdteUnZO8F3sdoP7E43Z3A1IS2Dp0CbNiVZ2XiK/0sG
	zkYWDvWqe4tMEsFcpo7LdwXi2Cc39h1GYEdRW6x72ldU55/nICiEVuTgieQiCmtCW3v6wHHBHjX
	tPJPsdKbRAa8sWBl5nPcoNJ/UDOg7hhLsNMkvarNtKPsNILsH9z3AwC4MYBRsxRa/uSH5WIvfew
	XyctFpasOWyeMPgygoUP9itnjEVE72tfbCLozKgoxPIWfskgaNVVkjEahlF7Ozgex6E9XWcwzOv
	ZNhappc6h9jGb9YdDJmloVFM+
X-Received: by 2002:a17:90b:2791:b0:3a0:c31d:80c with SMTP id 98e67ed59e1d1-3ada6c545c8mr517003a91.9.1792634288589;
        Wed, 21 Oct 2026 18:58:08 -0700 (PDT)
Received: from coder-ast-ast-dev-ml-0.tail2dda0.ts.net ([153.61.198.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada4887669sm1796939a91.2.2026.10.21.18.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 18:58:07 -0700 (PDT)
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
Subject: [PATCH bpf-next 8/9] uprobes: Don't leak the breakpoints if the unregistering task is killed
Date: Thu, 22 Oct 2026 01:57:11 +0000
Message-ID: <20261022015712.1297331-9-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B95E9C0009
X-Stat-Signature: b4op73gy1b3xuxriaj7djxiab56jq8yj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792634289-469736
X-HE-Meta: U2FsdGVkX18sVWCWu6Hn5tUcqbig4LwlZ0dQBZea/T3UhBRvfWIRdOS2UFiEVEHy0ebyX4wpIvFuw5G6r+XVgpvGza0n4nDKuZQ81rQONbBwMA7MZvIwIYpVxGeOmqGQBEYXmM/qOiMT+cnTb5fOjEiHNK23tfCCrPX3qz2xJeQiwTS4yYmEr2tcH095wDOyq1UdX8HHpcECf9o/H+KWozL3TwQRrhJ9rMrIkyRP5E7zmxov0vanRZKaYD6XDT6xNQJDzX5F/chvRaTHgWKKntBrS70VYbVYL4Sra42Xj2OJ7JTsYrS/mbu3EifOeRt0/6AQcGzFJ6MtsjY9g010/0cXVtd8GOh0B4vx/7NyXo7UPVKDubNG2x5Cakx+q8VNGqqTg1Bjx8Q3Q/XmPh+QnjNKh7Tadi6ZDwxBVVTVnTFrHwnaHoq3k1osOmPjm0sub3AyygCMzizxRptkExVSpe+HgRzd8pVTUBD0I+ssYm1l1mxsq2+O+iIhC5AqiCTibGj2W6pJQ+VMNptDEo0OsiXz+sufSJ3dVzFmWd/+2f3DYH6YQ86+ygDI7skPgHNKvI9GGR0ewxqFa8erFWT+k2TK2YEmRxloNooymBXOrWsMtOG6XOaWJy7Oli1wVXQGFbZcbVMcsw1FrXBiFLSwiHCM0/WpyYnrPmTSv0a0RZkTPr/xnCS36XcEYHZ3eA93QDiWVArYqE1MOQZdELkM3vUCMPBTkXptWzb4Y74UB6YWMNfIgC9WWrmvo7c5VNALVEsKzvgpfV7Xt7QqGwLDVUAiXE/Gh5NIF6AhhPfbgKGHDuRg8Bsp5ef9DN/VgYRcl1zxwjCzjrf6uKKpD8j+thKz+W0ckHoKs1OjhffC4sCEYz1IUmcrpoTfcRnisaqodVsl7kKq3Oxkpmd8+WqGAWXbe5RBzjSPDqu52FCc6fQhL42iavB5FlJGGIVLgT7scTFE6fuVsjJwuK4UDF4
 CXp2KeFm
 Shsf58LiPxc17ieF25T1ND1adMGykZ9IGiTqBnE6NT+KBkGuGzfzah6yP0PpkiwXPjQWZB3MsNusaF2hGDvrVvL3iLBlSbw9ODUpFkDX2FF2t0Io/D8OhecPaFXyB70pfZbNXtr2529/7iPDT4n6ZTMGucS0fk79CqDRlogLsOwbh7eM6HTRp/6uwJP+fNGlq9RXChs7qpw0CMZMl+tn6zBz7wtdiYfAlOjo5S75qrmAy+omxVkoDNheeMXcBnGe0wFiq16qE7GnkZPqTsPt2RsOVcZM/IQ8rtXCRjH0hMJeuY2oVodlWnRgm16PTp/dimdgT/v4CERrjyP0tk/Uw3iZYx2zlffmVFo6Kz7kW3le+6rKs/cSAXwuGTdDa3WcduVb9GEu+AuEd+kvRHa0/ZR1j7NE1ZaDM5ZZ6I+6LZE/TSwvlXQFtcgrpvjyLW8HNDZi41Q1PplF1y7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alexei Starovoitov <ast@kernel.org>

__get_user_pages() returns -EINTR when current has a fatal signal pending,
and uprobe_write() begins with get_user_pages_remote(). When the task is
killed in uprobe_unregister_nosync() remove_breakpoint() fails in every mm
that register_for_each_vma() hasn't visited yet:

  uprobe: <comm>:<pid> failed to unregister, leaking uprobe

uprobe stays in uprobes_tree. The breakpoints stay in these processes and
in their children, and every hit traps into the kernel for nothing.

The same happens when the task is killed in uprobe_register(). It cannot
remove the breakpoints that it installed. Since "uprobes: Don't sleep on
mmap_lock under dup_mmap_sem" busy mms come last, so the task that is
killed while it waits for one of them leaves the breakpoint in all other
mms.

Trying again after the failure isn't enough. The signal can interrupt
the removal after ref_ctr was decremented, and the second removal
decrements it again.

kworker has no signals. Remove the breakpoints from a work item and wait
for it. A kernel thread does the walk directly, and so does everybody when
nobody maps the file.

The price:
- A round trip through the workqueue for every removal, 9 usec.
- The removal runs with the priority and cpu mask of unbound kworker.
- The caller sleeps in flush_work() for the whole walk. When the walk is
  longer than hung_task_timeout_secs the caller is reported as hung.

The tracer is killed while uprobe_multi attach waits for mmap_lock of
a busy process. 100 idle processes map the file. The number of them that
keep the breakpoint, 10 rounds:

  without this series   0 or 1
  without this patch    100
  with this patch       0

uprobe_multi attach and detach in a loop, nobody is killed, 32 cpu VM,
median of 21-27 runs, msec:

                                  detach          attach
                               before  after   before  after
  4096 uprobes, 1 process        33.5   69.4     7.35   7.44
  1024 uprobes, 100 processes    95.0    102     38.1   43.4
  256 uprobes, 1000 processes     182    192      107    117

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/events/uprobes.c | 74 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 71 insertions(+), 3 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 92ccb730278f..361b52c9c3bc 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1426,6 +1426,68 @@ register_for_each_vma(struct uprobe *uprobe, struct uprobe_consumer *new)
 	return walk.err;
 }
 
+struct unregister_work {
+	struct work_struct work;
+	struct uprobe *uprobe;
+	int err;
+};
+
+static void unregister_work_fn(struct work_struct *work)
+{
+	struct unregister_work *uw = container_of(work, struct unregister_work, work);
+
+	uw->err = register_for_each_vma(uw->uprobe, NULL);
+}
+
+/*
+ * Remove the breakpoints. If current is killed, get_user_pages_remote() fails
+ * with -EINTR from then on: the breakpoints which are left stay for good, and
+ * the removal which was interrupted can be left half-way, with the reference
+ * counter decremented but the breakpoint still there. So let a kworker do the
+ * job, it has no signals. It takes the locks we would take ourselves.
+ * (A fork() of an mm with busy mmap_lock can still do one removal in a task
+ * which is being killed, see register_one_mm().)
+ *
+ * A kernel thread can do it itself. So can anybody if nobody maps the file:
+ * then there is no breakpoint, and uprobe_mmap() installs none which we would
+ * have to remove.
+ */
+static int unregister_all_vmas(struct uprobe *uprobe)
+{
+	struct address_space *mapping = uprobe->inode->i_mapping;
+	struct unregister_work uw = { .uprobe = uprobe };
+	bool mapped;
+	int err;
+
+	/*
+	 * vma_prepare() takes a vma out of the tree and vma_complete() puts it
+	 * back, under i_mmap_lock_write(). Don't mistake that for an empty tree.
+	 */
+	i_mmap_lock_read(mapping);
+	mapped = mapping_mapped(mapping);
+	i_mmap_unlock_read(mapping);
+
+	if (!mapped || (current->flags & PF_KTHREAD)) {
+		err = register_for_each_vma(uprobe, NULL);
+		/*
+		 * An error with a fatal signal pending: the file was mapped
+		 * meanwhile, and get_user_pages_remote() returned -EINTR before
+		 * it could see that there is nothing to remove. Nothing was
+		 * written, so it is safe to let the kworker repeat the walk.
+		 * (Kernel threads which unregister uprobes don't allow SIGKILL.)
+		 */
+		if (likely(!err) || !fatal_signal_pending(current))
+			return err;
+	}
+
+	INIT_WORK_ONSTACK(&uw.work, unregister_work_fn);
+	queue_work(system_dfl_long_wq, &uw.work);
+	flush_work(&uw.work);
+	destroy_work_on_stack(&uw.work);
+
+	return uw.err;
+}
+
 /**
  * uprobe_unregister_nosync - unregister an already registered probe.
  * @uprobe: uprobe to remove
@@ -1437,10 +1499,13 @@ void uprobe_unregister_nosync(struct uprobe *uprobe, struct uprobe_consumer *uc)
 
 	down_write(&uprobe->register_rwsem);
 	consumer_del(uprobe, uc);
-	err = register_for_each_vma(uprobe, NULL);
+	err = unregister_all_vmas(uprobe);
 	up_write(&uprobe->register_rwsem);
 
-	/* TODO : cant unregister? schedule a worker thread */
+	/*
+	 * Can still fail, e.g. with -ENOMEM. Then the uprobe and the breakpoints
+	 * which are left are leaked.
+	 */
 	if (unlikely(err)) {
 		uprobe_warn(current, "unregister, leaking uprobe");
 		return;
@@ -1553,7 +1618,10 @@ int uprobe_apply(struct uprobe *uprobe, struct uprobe_consumer *uc, bool add)
 	rcu_read_lock_trace();
 	list_for_each_entry_rcu(con, &uprobe->consumers, cons_node, rcu_read_lock_trace_held()) {
 		if (con == uc) {
-			ret = register_for_each_vma(uprobe, add ? uc : NULL);
+			if (add)
+				ret = register_for_each_vma(uprobe, uc);
+			else
+				ret = unregister_all_vmas(uprobe);
 			break;
 		}
 	}
-- 
2.55.0


