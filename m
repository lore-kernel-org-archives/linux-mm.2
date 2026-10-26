Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9247606D138
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=EzRWwf+X
Received: by kanga.kvack.org (Postfix)
	id 1D3DA6B05B7; Mon, 26 Oct 2026 17:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ABDD6B05B8; Mon, 26 Oct 2026 17:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C1826B05B9; Mon, 26 Oct 2026 17:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBFF16B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:52:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1FDC5A83EF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:55 +0000 (UTC)
X-FDA: 85366127910.09.D586BFC
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf20.hostedemail.com (Postfix) with ESMTP id 74FB01C0005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EzRWwf+X;
	spf=pass (imf20.hostedemail.com: domain of 3tMvfagoKCCkOYMTZLMYTSLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jthoughton.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3tMvfagoKCCkOYMTZLMYTSLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793051573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQEJn1r6phHG9JJTEKXNjl8UbrwqhLU2o1gcr6ks6C0=;
	b=5hOTehEoawL9i8DfGLMOu+PK+hlL+hJEExupyDQphiMS+LkkZbghWZ56+4DkOGQerhlQ/4
	KQBkIl4ZC+gbB6ls2RqE9ABdko7RCHSmcbDJbWtYIVpohrAPJagq8OrP65Ybff3m82Re0u
	LWFYmEFjZGI93Ck5IMbB42L+FvvD9X4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793051573;
	b=cda+hvKbLQos1GSoYt5SOuqFwJy98CM0hvXSFBmEABvmqk6zubhWkJdYpeltB9nVpPtn7K
	z+SxhMCus8PEnc6blQEV/TMSrLR3yoDyybaDEHxo/QpBvYJBI95Rjvdu0oOhzls0AvUTsK
	XpY2AQ8X/PB7oXdANOlgzSqppFuJWwI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EzRWwf+X;
	spf=pass (imf20.hostedemail.com: domain of 3tMvfagoKCCkOYMTZLMYTSLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jthoughton.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3tMvfagoKCCkOYMTZLMYTSLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd0cf3b1c70so2139044a12.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051572; x=1793656372; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OQEJn1r6phHG9JJTEKXNjl8UbrwqhLU2o1gcr6ks6C0=;
        b=EzRWwf+XPSZCrz6tcwnIMLRE0+7oQ7L4BpY2loh5Tuy64xLzx8T/IWp0fQdigcRznd
         G7pDDJZ2tHl0GVaL7U+oWkSXg+ZpVwouheYOZ0N6rZaAP9Oeavp3u17qEjoJVrhcML7v
         g0y2W872OyKY0jO3Zacr9Ftg9CM+wKoDu8+WxCT4EnHsBXVgRMoCdTYw4YmXurSvqCC8
         zfyV7QGHN2Ls52s/Yltx6C5HLqjdL3J9WDt2FFYFLpVe2klxVnIYtg5eaVSla+W1aYFF
         UrnOGY8Xqc9k3XvfK6Lf+SmFQNtHehS2W/BVzO9lHMjBBg90ERhMmnJlmCJiZRG1QLvd
         CrYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051572; x=1793656372;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OQEJn1r6phHG9JJTEKXNjl8UbrwqhLU2o1gcr6ks6C0=;
        b=r8NurBvPPPB4jGkwivcUC7+J/eaKIIAc69JC7lf8X48QBN7s93b6ocdEUHgcUXLwyz
         w8tZhpNoBQWvDqziThEHuOnbCVeEXopx7+Rzg2jbhhlAgADA6kZUgnUOWKDlZCZNFeyX
         oXKsfuCXsgtI1hyxqKaJeGiodmPiaQXL6z0lYzONqPglAtXZaPQexLHxTFGseorcpzun
         z+DLFUD2Sg+I/vGvHUTnD1TmNbv+arp/GIcZJBIiQD2i9Z/ToIF/85LqZvZBqMRM0Ne1
         zCIwup8Y7G2Jcp7KY4M7R4s4/3l6Cc/zFMRCZ0FZWfO4PkmepFj6JxjrxsRXQBLXaBJW
         GsoQ==
X-Forwarded-Encrypted: i=1; AKwUvBx8FR912b1Yq/StdAzffWmjnVIiU2Y71f3q4rlFbR6mH/TY6QBKZDsfDl/iZj9JX5q3NU+iBuBw7g==@kvack.org
X-Gm-Message-State: AFq9FYI7vnn+AyQNiA+zbI8RlrPl4B46RuE9hNnL5oo/9UZDZDPl59Gt
	Yn5hP+sXKIMPJh3mchM/Ye7WPrfXMFh20k0sJdZjAw0rYYYE5kNzUcCm9U+r+Z4ZrUw7S6R9VxK
	8r8HPj7v2BttW7pV3q1182Q==
X-Received: from pjbee5.prod.google.com ([2002:a17:90a:fc45:b0:3ad:f864:f94f])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4d8c:b0:3ac:a521:95e with SMTP id 98e67ed59e1d1-3adead4f7ebmr6876350a91.47.1793051572060;
 Mon, 26 Oct 2026 14:52:52 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:21 +0000
In-Reply-To: <20261026215226.3713941-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026215226.3713941-6-jthoughton@google.com>
Subject: [RFC PATCH 05/10] perf/core: Don't unwind the user stack without an mm
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 74FB01C0005
X-Stat-Signature: wbk1pauid8qmh7t19y81qqt4dddo5sbx
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793051573-893399
X-HE-Meta: U2FsdGVkX18cCye5MkL5eBwXPaZBYmgg9KOpS1G525KUr5sDQ4TW5c2EoVLrQD6MBEEDYeHE9aVdg5k3uavVGxl6uXFCqEg8ruwr4ejMvL3sImUtJUJbFOpmODjNVt+/qjSbyHwyEg0fqypvZoRh0hZuPy7e11eJ7nW3b9bX7YUO2EZDvfR2jGNfI/Hufdn8S4KMhfExIQh3oHsrl2rCoBF+MhzdanhplpRajZmLwOiqalCn6xZxTfrUHnlDhCUJeHhUq3g25QUuzI4Adsjs7sPxZaAVlm68ql58j1OS0/Tpu2TVpNE+b4rtZuuGO8BPEvP2PRQ73fF50GjBHpOM2gzkCemwL7h7g8vFLMUvzfKplWqsNecFxQ4OmYh7cSlObCNct3Lm/vpO95yA726trKe6ryWkPQtqh+GIlIhhmDzbIB4FJW9UjAMoR3tSwQoXzklVu/RtNaKtPtOCg3qWHzhPvnoEmAXiJSSLPScwcjKJSN80z402GVmjSY+FE0Fm984pAmM7+u/poctCDVEXx9qcAzdUcz6IW2wzagQ+7NFGAWfQNr+wPI5QkeEfgvgwVA/YQqNp/qIwjoDXCqPPM5UMrcwbrgX5RWTmBy2x+Xk1HKhsQMvY6g8Eu2yAdCJBxlZGeUpC+QhHPGNxNQygzO6OjbcEXq9TPtIAS9B7ul1LAv5bCrM9DQmKUks2vMOnjsPOCLUxciTdry8h9sTxMnB8jQdXiziJA2JSpS+umTVYJS1zjz74dzBKatoLuzFEbsa3Wsvhv9F0cXj2Tx2bVDLfUbBvXqPJPPvmCP+KxJlEACOEJH7Y8H+VgFKjOKqCN76sgH8GYu5ogGLYh5x0tihcKHz39Nweos0zY9SYJVvFi2Ji3frYkef1WIb0ElCf4LlguYXoilRnw3n7IklpqrFN/b3sv7GF54TqyhGJmSWs7wa3HAF5OUb4FmTH/SkBOWifi7Kw3n97CC3CY9W
 QFw5a/9F
 gQ9uyWO9d01su2EO2IXdyg+b8XPC9vk8KkJ8a4/g4eNlUNx37v+KYhu/CcEzO/SrK6fo3WHKBIaYkMh02v3b3+5970WkQNHJ7Ie1wbb8GcqLHzLSE/z+k+ctHduTfQn0rYqP+C5Zw6h+3ORsTeDyN/MR9Bwg2SQf7z4i1zHTmFJN0gi9szry+7BclJ6vUdMulaNxaRq+13/7szCeA+QP2tf7dpgFNC3PjOpG7HDYYsosHxz5HSlq4ai9ROvUBedg9BqVvU8d/nkOF5bX9nGc7QqHRcTY/0bgwLFDrR5JxMAtVdGtJW+m2UBfXV8pXvUA3wkCXEmXmwnzece0TrJysq3BeUkwwvzTN8++Ox45HUvLrVOxo5JQ+joHYNluIkVNDN2LQ/Oekvtq6I/qc1d8TE6cJNB0Yjk0oP3ZyiZJDn5w+52mQIFD69nGJg5FjHb1xhZn2PCa4aX156759yaW2mutVb3AOm4GBYKdFFy1fRBJWA38CGm2w8sPLjq/d1cLxlZk57LFnhMcVzing8Yc74e7YaSxb9C1L/EqFBn8QaAWIUA3lPbSdripxb/Bfr/lu9smphyoIz1VwC+vac4ol7vbVTO4KMsLCHNcbeso/GL5YfYUdHELcIzD43LaFVh/0GzIfn2p/z005t/EAYK7Ujae32Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

get_perf_callchain() only checks is_user_task(current) when the regs it
is given aren't user mode regs. However, BPF's bpf_get_task_stack() (and
bpf_get_task_stack_sleepable()) pass task_pt_regs(current) when called on
the current task, which are user mode regs for a user task, even if that
task has already gone through exit_mm(), e.g. when called from a program
attached to exit_files() or to the dying task's final sched_switch.

perf_callchain_user() then unwinds the user stack without an mm. That
access does not reliably fail: the user half of the address space
belongs to whatever mm happens to be lazily loaded, if any, so the
unwinder may read another task's memory. This affects e.g. arm64,
riscv, loongarch and csky, whose perf_callchain_user() doesn't check
current->mm itself. perf events themselves are not affected, as
perf_callchain() already clears the user callchain request when
current is not a user task with an mm.

Check is_user_task(current) regardless of the regs' mode.

Fixes: fa28dcb82a38 ("bpf: Introduce helper bpf_get_task_stack()")
Signed-off-by: James Houghton <jthoughton@google.com>
---
 kernel/events/callchain.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 9d24b6e0c91f..a451ca2a5573 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -245,11 +245,15 @@ get_perf_callchain(struct pt_regs *regs, bool kernel, bool user,
 	}
 
 	if (user && !crosstask) {
-		if (!user_mode(regs)) {
-			if (!is_user_task(current))
-				goto exit_put;
+		/*
+		 * Even if @regs are user mode regs, e.g. task_pt_regs(current)
+		 * passed in by bpf_get_task_stack(), current may already have
+		 * gone through exit_mm().
+		 */
+		if (!is_user_task(current))
+			goto exit_put;
+		if (!user_mode(regs))
 			regs = task_pt_regs(current);
-		}
 
 		if (defer_cookie) {
 			/*
-- 
2.56.0.307.g5fe7bd680c-goog


