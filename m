Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B93BD606AB1F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ZgU9/52i
Received: by kanga.kvack.org (Postfix)
	id AFCD26B05B2; Mon, 26 Oct 2026 17:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A872D6B05B6; Mon, 26 Oct 2026 17:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B07C6B05B4; Mon, 26 Oct 2026 17:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52E886B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:52:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFD0516089B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:51 +0000 (UTC)
X-FDA: 85366127742.28.ABBE19E
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2EA0440003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ZgU9/52i";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3sMvfagoKCCUKUIPVHIUPOHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jthoughton.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3sMvfagoKCCUKUIPVHIUPOHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793051570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RD5MWqHEB8iYDLFdQXvkJ0xSc6fsoJ0ZXufXHQQ7zgM=;
	b=nPp9KCw5uKP8XkeLJiQQjx2gcdQpZGQ5cd3NZ0OCoTq/SVdT5tc59ELxqednfojyuT22bh
	F22rVF9zDoy625dXAvVnKe4Z3ixHA5gSf9ha3WkuPZH0n7bKzxDCeuprRYZzVI9uT8VBTq
	MnXjf8qVR+H0Aw4tZy0ypNWASGj4VjI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ZgU9/52i";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3sMvfagoKCCUKUIPVHIUPOHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jthoughton.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3sMvfagoKCCUKUIPVHIUPOHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793051570;
	b=UkXVB4XzxUziLsGFgYjdTYpXd5DXYz0wVVd7rsJs/PzaNuc/W1L/C60GAQetPZxsxmAhBR
	hSzB1ou5BDSuIK9tqEiKwMb1uFNNtwsfXuSgB0m+6O27TyFClmQc2Z9iu4pvFh9EA+P5bS
	1Pt9+NPrVFYO+j6bjvpxxuWqXtbr29c=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd8b7226694so1541144a12.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051569; x=1793656369; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RD5MWqHEB8iYDLFdQXvkJ0xSc6fsoJ0ZXufXHQQ7zgM=;
        b=ZgU9/52iPQaPMhw5HD/5jpSck2xlKwZYXdvSkgV2JpVD59yWrrpfm671v/2Jq5gs1q
         iuqEq2AXwXngj00P215oz/By4hXNMXO5S7mnFanwte4cFOLgQk69jJSB9RQUmN68TKZ/
         cxWelZe9m4KeGTO+AW4yul/y2HS+3tZYZTYLFCjj70OsRY5qQ59I19LTCnrYGip3HlwR
         IphBfkKjBIIWPtsi1WBavhKZRZZ7ntIfj452eUi0tE3+3LDGtKJV6bidKqck3TB2zG0H
         91B5dT8bTaVloQQG39xrbOjT//T6p9kU82+RDjt5H4qA0qBINDVGaoFNTOZkByzwbEWF
         6ESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051569; x=1793656369;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RD5MWqHEB8iYDLFdQXvkJ0xSc6fsoJ0ZXufXHQQ7zgM=;
        b=hRgr/m3OZ3+G5MBqFLA83qgHojYquZlxaUG0sdM9k+iSb6nFEdVae7/h2PF5UcD4Xc
         5IyfQyd777DBl9jT5sVD+QDjxiguHGrI/fEbQmDy6QsE8fgYekplT1/gZUEaWuHETxRj
         IODhynmbDHwZZ9E2+xTSpVqgsNZE/L2ijMVV2WGLA7H0C9CLhdnTf4ZpZdHuXGjW6fS5
         w5a1mlaeI+B8Y62IdwsAaNHFDox79aFylOaqf7RtsGks94G0BcqP2pbrOyyS9U7gcMkV
         5hjbNkAjYK70tRJOJ1xwlTFcv+CJYUodEN3ioidAGmZ/yvOHyh3LVRd3nhYvn+F/bY+M
         Zivw==
X-Forwarded-Encrypted: i=1; AKwUvBxL0/qc8aBD5teb8Z/wu1tZCv0WHKo7lKy7OtEZVJdQfujfVkSEMYWB3yy7FR2guu4phwaYPtyVkg==@kvack.org
X-Gm-Message-State: AFq9FYJ465p1Be8ZhoIvJVHcX9CaLpf2/LpWvZk97VXlwPaVNsaiS/eG
	RaoNWvIGbQnFkyLFDdAC1mNyPw7UiRzAq/FhYQIAyUbAh/Nj+M8i1bHvF40ckFSmGTCW+UgwbH6
	l0bMQEbz++Tmu3tPFrhipiQ==
X-Received: from pjps6.prod.google.com ([2002:a17:90a:a106:b0:3ad:c8d8:70c3])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2688:b0:3a8:cb54:e135 with SMTP id 98e67ed59e1d1-3adea899125mr6172313a91.19.1793051568668;
 Mon, 26 Oct 2026 14:52:48 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:17 +0000
In-Reply-To: <20261026215226.3713941-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026215226.3713941-2-jthoughton@google.com>
Subject: [RFC PATCH 01/10] scsi: bsg: Don't copy sense data to user memory
 when canceled
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2EA0440003
X-Stat-Signature: 34ki74f4i7pr87soyb4u8od3t4edziry
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793051570-797967
X-HE-Meta: U2FsdGVkX1/4b/mV38FZPcPwjsMmwXJKu3uXnDA2sbEG9zhCLZ0or2uoFbiT4z6xnGC3Y+gmjJOCD8nT/JJTofWkpyY2+mlMnV68I1+Sr8Y5Mgauf1U9/qiING8r1G3aKDyTSqQsKuFRZmDgcJxacusfYs2TeURKzqQnz5506swqtHNK1eYudr+lz6Q2AgV8JUWvQy+/CM1rfIaUGXFJBUoK5k78F6byDLag0SExX9Bz+HP3GIp1PxZTSDCjdvtYCcXobSq6pZAhvhp3VH5Ye5g5VcKrgLfruiT+Ei+oooxZ3HSWEBs7C/S5TIWiUj2KHANReRhVNzTZfPCXNKgCz9KJchj3cTDDs3NryyghRZPeOQvUV00GBpbm368x3O+vc+d7TYAEW1vl3DfzbjGkste3hxUoeeVnTaXSUTvaOqhrE6yJ+iu+FST4D/mAfhemkRN0LYVf2qcGItYuveD2xFGyan1PPvN57HWv664Hdcx6VuhL56Jxbvr/rUJXo+2WiquFVZBC65mjXq3F0E2WfAfyGbtcRdwUndtGM8cnddCCGiFAiGf95neca6B1kRHXlf2PgtKNwUzfFfOdzuZA1wbsD2aHMU3lK6Islvjp1p5AWM3pAI915HejQfQK2WzzeqvgNzoMlOlz+/IKYvis2N/7Pb8F+3lWt80KzNzOLV0sg75qsBHHVCrDXuW15m3hp/cE7WXgIWMwxv0FTsoOIDr96H++xMl+I9tBPM/4+UtaJqPxw7STqhP7bN7jq+DELOvYOzfEIPGGqv+C/AT1Qf9/1Mw5dVw7fzX/aagAtkHWouScix/lkp2GJBQtAblgkM+desSIV+yeWK/AVr6zjOmGwUvUZiq/zkZsJWZv6rBAg8oYCgMop43niE9J+Ep/HVQT2NE+JoJ7cBvzjN00E6JPt8drJdOSHWaQTEY15NzYbauKORC1ZEKSyHyWSABMNW6tzAImNFMQ2sW4LHI
 hZoel0Nr
 iN1QyoFStIZRN3rqAShJhUR4hZspIu4jDp0mBGcvRCIyE9H4RJZ3LQzUorqiJZ9Ykt3ZHx6HyfgFS69mWaaUy0Ce88rjxKnx6x4+iQ2rA6hsyDtVKY85Gfi0hP8Dnz56pURgBjz7HOXur50rhsEv9g5uB6PVDqo1ECOsFMNDTDdZmqxrV6sYqKXvJR5ElKUPr3B9+DDgYg29wWXkvxNrd7ypZ+Vppf6ZJkvC2bB/GE2PbGHvBZ0B26Bbvz2Q7uNZOa83r6RLxkQWJxd8ZtvhmhmJBkQfROgUq5bO1t2MNdM8ukv9461cwhB7i2n3lVe30W2owFlLUfFaK0QNpZoEFvzzHyxdXdBPdjQ0qfrvLwaWhhMs50hFG35WDbgUwA8e19UJhLkhSR1QN/KXbCioCPixiLhiXlN2OKF1wlLR5O9Tsk4rCEIP6VXmI4k0uQY9jj18pJyaKAmvf9wa/staHC4BHZ8UcH6Gl5q+rxfYm8tSMEksl0pL3sC58PDgkIiclCpYfX+E/qhTYLJYKOR67ykSCET+gH3ZBetiBv9rD+k7GgIfpCgv+S+nWTbsVyJNqLaJixrXcxLcDNZHjS9CAzAa4hEJUbiT2EMGoxaCuJOhVUiAf0L5g303HuK+VeNPv2301fRdkYiNUjnlLNxJQtvpqyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

scsi_bsg_uring_task_cb() copies the sense data to the submitter's
response_addr with copy_to_user(). It runs as io_uring task work, but
io_uring may also run it with tw.cancel set from other contexts when the
submitting task can't run it: from a kworker when the submitting task
has exited (io_tctx_fallback_work()), or from io_cancel_local_task_work()
when a DEFER_TASKRUN ring is torn down.

In a kworker, current->mm is NULL, and the copy does not reliably fail:
the user half of the address space belongs to whatever mm happens to be
lazily loaded, if any, so up to max_response_len bytes of sense data may
be written into an unrelated process.

Don't copy the sense data when the task work is canceled, and complete
the command with -ECANCELED.

Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")
Signed-off-by: James Houghton <jthoughton@google.com>
---
 drivers/scsi/scsi_bsg.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index 5eec248a77a6..3755e33fcdd2 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -43,9 +43,17 @@ static void scsi_bsg_uring_task_cb(struct io_tw_req tw_req, io_tw_token_t tw)
 	if (pdu->bio)
 		blk_rq_unmap_user(pdu->bio);
 
+	/*
+	 * If the request is being canceled, e.g. because the submitting task
+	 * has exited, this may run from a kworker or in a different task, so
+	 * don't copy the sense data to the submitter's address.
+	 */
+	if (unlikely(tw.cancel))
+		ret = -ECANCELED;
+
 	if (scsi_status_is_check_condition(scmd->result)) {
 		driver_status = DRIVER_SENSE;
-		if (pdu->response_addr)
+		if (pdu->response_addr && !tw.cancel)
 			sense_len_wr = min_t(unsigned int, pdu->max_response_len,
 					     scmd->sense_len);
 	}
-- 
2.56.0.307.g5fe7bd680c-goog


