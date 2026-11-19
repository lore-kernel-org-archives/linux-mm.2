Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C1A606A333
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XL7pJJBk
Received: by kanga.kvack.org (Postfix)
	id 141316B05BF; Thu, 19 Nov 2026 03:05:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2F06B05C0; Thu, 19 Nov 2026 03:05:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23136B05C1; Thu, 19 Nov 2026 03:05:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC43D6B05BF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:05:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FADDC0973
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:05:22 +0000 (UTC)
X-FDA: 85451133684.23.4842509
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 70BB540006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:05:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XL7pJJBk;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795075520;
	b=NCsArWRoFDdwcLSwXg2jlt1O9siMNh5q1UYbwgtxhzqXJP8pghEwWAUG3LFquhOmslgvMj
	PTqT0MQg4CDnyvsOEistuF1L48n8qw3Ab1WkxQzOAeqCs4F4uPyoG5eH8x1o3XrLMRKYMn
	SYgdTF40MEvAlTOG5Uq8z05QEREjIss=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795075520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Rek7UTjER/suQr6FAWR61hR3HRsZdSl74XAnmKcX4S4=;
	b=FxbIJUIUiy33CPw0m17IrwL/v9vaPINlBV24arqAmOPu61jr0rC+yVQIqih7AfpxILtks6
	OYjtR+6KJNgLReBVkYJxSTWwwVcdqF2nxg3lth0JZrlVD3AY2DMHHckUI+m+7UhO2dFVRa
	+9Ivz8sEqOCMevyxsBeIWin1TskNG0Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XL7pJJBk;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F73D46AAB;
	Thu, 19 Nov 2026 08:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E692D1F000C5;
	Thu, 19 Nov 2026 08:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795075519;
	bh=Rek7UTjER/suQr6FAWR61hR3HRsZdSl74XAnmKcX4S4=;
	h=From:Date:Subject:To:Cc;
	b=XL7pJJBkRxw6vp1B7sLrs8+PPOzVSCLx5x5NMKdUFo/AcFOI7uXVV+TrWJlvyfojJ
	 eLX4Gk/7YDVl7fnoL1rBjvYgCR52PHFzOrCKTsdKKzBLFGYeqPuPEYSkmsaetdqtc0
	 RDWYobT9fry0eRYhf3cD2XWn/0oOkC6DvCV0whfZoFib4LSsuIZi8X4DSPhtNwu9en
	 W1GZO9LORnbX6guOLiiYIiRKJfmZ1vQpVQJ89Zp+1P5yk8DhMlpilkiGWT0n0TCKIT
	 Y/I/6yG/WDYxsBkzxwnz6iBfl691IUzuJxof4moKBGDxUR2ZYefNFpNTzPPuTVg+7P
	 Muv7pLqr2lkzw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 19 Nov 2026 09:04:58 +0100
Subject: [PATCH] fork: clear p->mm when copy_process() fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-mm_failed_fork-v1-1-b3019f43d197@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yXMTQ6CMBAG0KtMvjVNOogk9CrGkEKnMCo/adWYE
 O5ulOXbvA1ZkkqGow1J3pp1meGIC0I/+nkQowGOUNqyZubGTFMbvT4ktHFJd+OrmivuzvYULAr
 CmiTq5x9erofzq7tJ//wt2PcvbCpTG3IAAAA=
X-Change-ID: 20261119-mm_failed_fork-a46141b503d0
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 Alexei Starovoitov <ast@kernel.org>, Song Liu <songliubraving@fb.com>, 
 Yonghong Song <yhs@fb.com>, Ingo Molnar <mingo@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, Sashiko <sashiko-bot@kernel.org>, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3334; i=david@kernel.org;
 h=from:subject:message-id; bh=2L4FtiSPbYQrvmgemAopv11ASeAoc306idpK+0NzQBY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+rd1wUXrSo1PlktoPA5/KadyZrhO2PlioJGszl+/1Q
 3PXnNe91VHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEGPYwMmye56611oV53a4J
 DPP3SkfVHDp+KV7q5h7XE5EZpRUdnm2MDP0Lty0yP9Saeqf0TbUET2eQdaTHZaVN3i6XD2mqu6U
 m8AEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User:
X-Stat-Signature: raxgqhu5mncdjcq7uz6zbuyxmuetjk1b
X-Rspamd-Queue-Id: 70BB540006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795075520-589862
X-HE-Meta: U2FsdGVkX19U/CV7Gs1LKR5tSmQs1pcI99Hm2K+Bh1IUfHAEIvNLufrjzVY1KAZm50xSvWSLlYDGI23XAUf2+lFyoNzLjPrtXDk641d6FQtKPKIMuEB+6RHKG1jtKnP6eutzHPVCclGyu+73LwynScazesiypwZUnRnX1+NWHjTPvN5bQdQSdi62Ec1JiCJRb3yQWLN27HrBetUxfwMRkpAecoGdgDNcSAEqTI+4Yrp5zDozhJ9EAHU1mYDkTCiG1lhX3CA/Kye9J9OBCXYIQysa/HmhuYa/Kvth/jCPuV/sLn6OOGRdEoWz+55wh5nDhAAlc7IXQwbaz5axKkyP1WARTMDioBbhtJMIe3eYMDULUUnkmZcYcXFsw824Z01NQzARsgSXVGRvCB7/Dr0ImkpQEyGDgpeHC0QH/pa+TICW+kMyvMOSjFKPUKYu3c3EPXd8Cl82RHA8idAl2+5B56I72zI701oisxBIV04fUZDVNkq1CZo3d0ISSb1/8d+O0kvYkxp06GkoULMvRGsw7gdb8ovxYM5Jz+CM0g5Jnu8mOINhjV6FqR8Rd9Zx63BEnAkrP+djLrX5DMAPzYHLazaV0w7hrA+e85/wfkjfZpameRXdQvi+9vBag2ZfwokX2KaagmamngVpHZXEt4GmhTyYyfKmsFoetbWxaVYjRIPDvKdu0d334QCaO2CvMBPX6N532P2uKYVKmn/LStLwTn9LsB4luy/1FIqllq6F5qcyLpMwlcfDslMOZ5oxqAb5Xa7lrfWwUWvWP8pQm24MgLG7HFJp66xFkZjOEkBD/1W8/w7+3vnxk1f+fw7TYotk7NZp9OxHnX8ptfu8t1yLafhNZgMvOIBZ6PiEO/mnNgtwcgL8gwjkKB2rcsJ7aRtnKn/BjUIunDydHBK81XW1W6ZV0uzjfsIoc1F+7IaCk0pHy8ek25alXKhUOQoDKxr/AJP6ldT037Ez0ffwbWm
 FRxuhmHd
 zCnX0sLwhc5CMwiBqEUBTPGJRKGwLWv0MQvRfqvQGFBg4YXaXrjECcqsUXhj/g0Q7eaUZZ/jXpDuDhYA4nxLaEpKi5df+kZB/ljrYdgyPPbSm+9EDXx8C9rgPZtT4mKuPT3GthAHheW6WcCVg/QkJUs6+Fx0it0IecbiZrRDS7hzWstdvNjgMypg+5RNP2XyX2VwVY/ADEqNDJxV23GVjSM2XCedRQaK/8JR04OFI7lAsQmpKjYUUfTFFsvYz6t72Tof1aQV6cgl7tGaWExGJBvbz8KB+vkjJ158d1H+VGHSponr+qK/e3rR+6YKPkpt4kkNAKzTkbZIlkGBzHbSTg7nnSeZuCkhUMePOeEF+vhTPzMZsN/kTmfA39hG2cWXByy6IQfOXhFYh8M+4FjL4AFzrPxt3cmXUZeJDwsIDSpf4NF8+Ey2bGqhh58LJk3X0vmh+b0zyCkGdqWFvQTUgb9DXFUhWi2evPU6N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

When copy_process() fails after copy_mm(), the error path drops the mm
reference but leaves p->mm set. Perf and BPF can still reach the
task, and take a reference on the already freed mm through get_task_mm()
or bpf_find_vma(), resulting in a use-after-free:

    copy_process()               PERF_EVENT_IOC_SET_FILTER
    ==============               =========================
    perf_event_init_task(p)
    copy_mm(p)
    a later step fails
    mmput(p->mm)
      /* frees the mm */
                                 perf_event_addr_filters_apply()
                                   get_task_mm(p)
                                     /* use-after-free */

Similarly, a BPF program on the task_free LSM hook can call bpf_find_vma(p)
before the task is freed.

Fix it by clearing p->mm under task_lock() before dropping the reference,
just like exit_mm() does.

Further, if copy_process() fails before copy_mm(), p->mm is still the
parent's mm pointer copied by dup_task_struct(), without having taken a
reference. While nobody can access it concurrently, there is the
chance that it might get accessed later when a BPF program is attached
to free_task().

With CONFIG_MEMCG the task is freed after an RCU grace period, so the
parent might already be gone and p->mm in the child points at something
that was already freed. So let's just clear p->mm before freeing the
task. No lock is required as there cannot be concurrent access (and we
might not even have the lock initialized yet).

This has medium urgency.

Fixes: 375637bc5249 ("perf/core: Introduce address range filtering")
Fixes: 7c7e3d31e785 ("bpf: Introduce helper bpf_find_vma")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/sashiko-outbox-180866@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify description and comments ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
I can take this through my tree (rather soonish) unless someone else
wants to pick this up.
---
 kernel/fork.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a78..77d6c8fc38c66 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2628,8 +2628,14 @@ __latent_entropy struct task_struct *copy_process(
 bad_fork_cleanup_mm:
 	sched_cache_fork_cleanup(p);
 	if (p->mm) {
-		mm_clear_owner(p->mm, p);
-		mmput(p->mm);
+		struct mm_struct *mm = p->mm;
+
+		/* Perf events and BPF programs can still reach p. */
+		task_lock(p);
+		p->mm = NULL;
+		task_unlock(p);
+		mm_clear_owner(mm, p);
+		mmput(mm);
 	}
 bad_fork_cleanup_signal:
 	if (!(clone_flags & CLONE_THREAD))
@@ -2663,6 +2669,11 @@ __latent_entropy struct task_struct *copy_process(
 	exit_cred_namespaces(p);
 	exit_creds(p);
 bad_fork_free:
+	/*
+	 * If set, p->mm points at the parent's mm without a reference. Nobody
+	 * can access it concurrently anymore, but prevent later access.
+	 */
+	p->mm = NULL;
 	WRITE_ONCE(p->__state, TASK_DEAD);
 	exit_task_stack_account(p);
 	put_task_stack(p);

---
base-commit: 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd
change-id: 20261119-mm_failed_fork-a46141b503d0

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


