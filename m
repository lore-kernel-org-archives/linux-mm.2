Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E6560A3808
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Q7RXZKGp
Received: by kanga.kvack.org (Postfix)
	id 72B336B05B4; Mon, 26 Oct 2026 17:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9986B05B5; Mon, 26 Oct 2026 17:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 507E46B05B6; Mon, 26 Oct 2026 17:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9D96B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:52:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 93D0316063D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:52 +0000 (UTC)
X-FDA: 85366127784.22.449360A
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf09.hostedemail.com (Postfix) with ESMTP id DB843140005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q7RXZKGp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3scvfagoKCCYLVJQWIJVQPIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jthoughton.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3scvfagoKCCYLVJQWIJVQPIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793051570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/8L34Uc9Xo1d4oJ1WUUvtNMd/yh9NNapi89sPDAfm6Y=;
	b=1H8dcujOnMwnW0WPLYw2zqSHjz9jKWYl/n5HtimY/RWoBAOsIq7GBIr9Wfljd9+c0w6qCA
	/n38JzCqLTiyCiiOzg9eLGjia6QpS2yLQA64bc5KNk8AHD0wubzvwLpEMqlY0pdhVv+9eX
	uPeiGD5phTFJeFhIJG1PfotLNrow5Is=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q7RXZKGp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3scvfagoKCCYLVJQWIJVQPIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jthoughton.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3scvfagoKCCYLVJQWIJVQPIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793051570;
	b=yAyU3xHUzMow4AHsJXWBxlXFOPUXCi0Y2SYMSoy5+ui7UfMNj120hgmFVirQF8vLW/AJXU
	sMYs3zl4KpRCa5GqMYRhcHpZ6lkjNM1/WavELjjR5V8fVp1U5JAHlsool6ZASiHaCEXuqY
	fb9l+3wODMenox9yOeR5eCOOiJDz5X4=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ad840053c7so3402232a91.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051570; x=1793656370; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/8L34Uc9Xo1d4oJ1WUUvtNMd/yh9NNapi89sPDAfm6Y=;
        b=Q7RXZKGp6GBdNRxz/8XKgJ+xQn7bxDSFTJT72zAF2gkiweExfZvhWlWoCj8QJOFTSK
         MiJh+un158M/o5kQ46V/wNCoKNs8NX5zKZp1EGtjcvokiOJLh9hQiSVBAf5sKFvKNUXo
         rL6N5TPm1iY+QD1T62Vy7dm81xefcke3RVQsVIKytI967qrMs6ZdbKWmKx0TVD24eCEH
         gLbL6LFmed1XgR1ngj9dyB+GDrBFsyyu+fmvQcOc9FYQFJMOd3Z8GCfOldPR1LHdfAnU
         A7r/gmPWaEjg5+lXcb/m9tc5LQ7FaS+p7nbDnw9nyctz4ltHzFv44SZt9dbuisKrRAKz
         c5GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051570; x=1793656370;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/8L34Uc9Xo1d4oJ1WUUvtNMd/yh9NNapi89sPDAfm6Y=;
        b=YVFuZxOP2mIYC+OMGRvrUKzIjWcErgGtwt7+gSNaxRlsi0S6NsW7Bp5gxTXIyWroDg
         xYP3QJZfHlnCBNO8aDS3nhfN7RiEF9N2NR8hKITqkW7KEvCZxZpVTmsG6aTCLQD8ClZj
         fmcqR1ofuKdiRrAo0tuoJ3rCxRurCmZ5ROomUP7u1aWiL38bMyqktDd9b4JR4sRRHZyT
         JFBGcTTjF7jWOB99KWM0TQMhXhCfHbmNZgpvX5vrpmk93XhhQKKPcKy0eNxpRoBMLw34
         w18kxSqpn5q20UYrL0Uj6hNz7LTplUTM7Ale1L7WlPAVMaBcyPJKVR1LCfMB5bnHxQBT
         gFFw==
X-Forwarded-Encrypted: i=1; AKwUvBz1l7Rke3JI8DqOMxUURi/GnR7ozGwsBK86Cd334dBe08OwTqGWurAOBfJSY0SYxe7ZEI3kOT9/GA==@kvack.org
X-Gm-Message-State: AFq9FYKnya5b+6+g7QMEipyz6p9Okz6hU4JuHqvGvMXZLPiaxpNSCJsH
	mPPro824HWG1pDbNoPWbkO9wvWMjwBM1Gj5qJJfveVx968ykpACvUq6R4Xaj0Toh9wYuK2yIj0Y
	X7zjfLolVJKD+pABHUoWUBA==
X-Received: from pjbme4.prod.google.com ([2002:a17:90b:17c4:b0:3ae:349e:2bcd])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:35cc:b0:3ad:1b31:92d8 with SMTP id 98e67ed59e1d1-3adeb16ecffmr5865801a91.60.1793051569572;
 Mon, 26 Oct 2026 14:52:49 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:18 +0000
In-Reply-To: <20261026215226.3713941-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026215226.3713941-3-jthoughton@google.com>
Subject: [RFC PATCH 02/10] btrfs: Don't copy encoded read data to user memory
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
X-Rspamd-Queue-Id: DB843140005
X-Stat-Signature: 8qkhcawofs5sn3eb8dcwge5jp1jf96ti
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793051570-988224
X-HE-Meta: U2FsdGVkX18OFGIfTnY87sZbMuXS5LzA/xdui2EaOyowf4/LEYBFXfD75/+Nsc0GMXh4LDbSWk8zUle5NoGeAZvyEvMA30zt0eh+Xv0AOMznj4q9Lab5EseRp7+Gm0yCI26WMqiyccr4h6E1Gwl1ryCN0jvZPJeajjEDPAlK7v79tyxMyUunP5svy6j9LiM4YTqw7RBiUYQHq4enty9WPWvC4hKtxQrKZWe3cJWz4jiwm1K3CdlefSxZstw54VWVp0aiaw7uFSkD/946VmImY1RbeelLzn8qeLOV8p5/rkVt341Vxjs7yCF2xyPIhUWHfzmA9p+poEjmpJGXbIyrjbtXuog7CDuuO1M7ZDCqrYL+kW7BU8shXq1ffXM5hCsupb/FyWCwVulhD1iLh4SOD/LP9S7h0xof/1BTsr5QJ3voeatf6zfgUBDcm6wWdda3EG6n2Lun7RTn3YEZjGaNQgIVUgav7nKa2f8ZygArazFxNJV6RBQNaj2CHj9/1uaYoQBVRcsQDO/KGH6kymUaf3yMRUri5rfbZ+AwVyvxfpH59uZFaG44mD4+qUoGLLK9Qcp4MegeootVPkWmykReEbRevWAN0SgwJqd+v8xWxei/F8IMfDWG49UjYsgna9ZSgGwdzXQrbaQUbWMJu44ABVqohA682urUslxkCivf0kKDYGiEj8lkQOlvR63fFJIFnZJc23BnfmMx81H9tkxHmodqvPqqmxp3WMLQjxwR+OIYXUyFZEG2nMbi+YyyltDA1pUnVeh1p+aUuzOl7PxPrjKd68vbFuJvRBVU86Q6jZldaeG7XmNlBNMf+rGmG/RaNoSrH6jd+r7fFS/GL5LxWqVVjbp8fS6SdeQ5x4r4Ecf7e+9tQD06c/vY85htJ9qYE9FzwOWW+YqN9H+wD3gQQIqB209XCIttoYKmuNl9yKpnXogpoMFMYKb+rVWXsXM+q1YY9OM94jVCJm2VhKS
 Ih23CHN2
 cVgnwjI5SL6qdg6nUxyiQL43MS0G1UeAtvGT4HARU5NQrgJ6sMhJ4wxielmFU3dTdKnL86uc+Ha3duUWw1CiVZhDVReOzkD1Q5zpxBYMR9phXm2Umygvmvduktmad69K+e6LyPBun0Vqbo2LG55QwIkU1apVXsoVzrV7tX4q55oEz2Csqvp0VlJDBWX7IFWTTnqO4ArIG+bNZYOqhzDwFKdCv0mP/D+UCeEAnQNL5FRGQf2f1+p+FK5FJwF9CQvR6L6Egx9mSC3HqqvtNdib0Rkm74j6dXn1pi1iQPYjkHmt2bwr7aPKifrUH+M9/SVq3CEZbHWiE1KdFPBmKhfMQQ9URdEJaIO2m1dKpFeBECrpHp7XzcDCv/NvydC6rirnfRV22om5I8BbxKObEvoEJBUEYT62Jo4UBkrd603pUpJfyXpUGTVC79l+L45XbWMG3HuTuuE2Vrcrnj3v2bCKVRCCqIxELT41kJxNoJK1Rp97s8ClnkVWtJYchjvq4PbCEml9f8U7Wnv2DNodZPo088U+/bhNUwgBAVjEdQPBUrfw0olLQ8PxF1He7Xz3T7qKwIA3p418JmfZxoM66iYtHwwQGPqULZkzNJeQT5L4OkGm2NRrmbHopVUB7yiaO3bAa1DYGnOekzyj9tLehB4K8V8ZcSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

btrfs_uring_read_finished() copies the data of an io_uring encoded read
to the submitter's buffers with copy_page_to_iter(). It runs as io_uring
task work, but io_uring may also run it with tw.cancel set from other
contexts when the submitting task can't run it: from a kworker when the
submitting task has exited (io_tctx_fallback_work()), or from
io_cancel_local_task_work() when a DEFER_TASKRUN ring is torn down.

In a kworker, current->mm is NULL, and the copy does not reliably fail:
the user half of the address space belongs to whatever mm happens to be
lazily loaded, if any, so the data may be written into an unrelated
process.

Don't copy the data when the task work is canceled, and complete the
command with -ECANCELED.

Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
Signed-off-by: James Houghton <jthoughton@google.com>
---
 fs/btrfs/ioctl.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f3e2afe221be..d9044fbd9547 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4609,6 +4609,16 @@ static void btrfs_uring_read_finished(struct io_tw_req tw_req, io_tw_token_t tw)
 		goto out;
 	}
 
+	/*
+	 * If the request is being canceled, e.g. because the submitting task
+	 * has exited, this may run from a kworker or in a different task, so
+	 * don't copy the data to the submitter's buffers.
+	 */
+	if (unlikely(tw.cancel)) {
+		ret = -ECANCELED;
+		goto out;
+	}
+
 	if (priv->compressed) {
 		index = 0;
 		page_offset = 0;
-- 
2.56.0.307.g5fe7bd680c-goog


