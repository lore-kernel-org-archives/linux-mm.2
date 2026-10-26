Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A15606AB0F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=PgHQ5lXC
Received: by kanga.kvack.org (Postfix)
	id 444946B05B6; Mon, 26 Oct 2026 17:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F5E76B05B7; Mon, 26 Oct 2026 17:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 296576B05B8; Mon, 26 Oct 2026 17:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDFAA6B05B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:52:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4DD378083F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:54 +0000 (UTC)
X-FDA: 85366127868.19.6C68FE7
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf26.hostedemail.com (Postfix) with ESMTP id 99673140006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PgHQ5lXC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3s8vfagoKCCgNXLSYKLXSRKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jthoughton.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3s8vfagoKCCgNXLSYKLXSRKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793051572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zQfCS+xbNCI3ecGYMw9q9f4jA1EzYR8/pz81vPbgxA=;
	b=R/wh268JehtvRi0XILjxD1afz6Z+LxdEeX4LE6YXQSNuy/uCg4wpTdqcpj/YRrSHO46lTm
	FyjgP7+zg1uBtttKN3DKNX9Euaq18eWQU3poa27UQeztRdLxOWJaSZ2kEdUDkeqSkNNBy/
	BwF5zgH2qWeEAfDCdGVVRVUzWbVkQ/s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PgHQ5lXC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3s8vfagoKCCgNXLSYKLXSRKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jthoughton.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3s8vfagoKCCgNXLSYKLXSRKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793051572;
	b=fx+s+VvhZ+vokYLq3pD/walgnW36Gav2m+cc+fz9iDJXoKTKqMLGmT6FQ1hVvoSqn4zQ1m
	M0ENfNUxw5f2IGoJK4a8aY2TG0MSoJRZlBKe5JiKoFt5lgPkEzlkjy3XZQfhFKkK45/4FV
	hrpflXKinr9sbmqwOMrPeCED3OUgnKY=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a01e2962a1so3748350b3a.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051571; x=1793656371; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0zQfCS+xbNCI3ecGYMw9q9f4jA1EzYR8/pz81vPbgxA=;
        b=PgHQ5lXCFy0CkIOQ5WjEFZQJz/ZUOxVXE+bGUWkkHoXPdjaZPrEGOUC45TDN2SqVEa
         RKiOJ3BBDjkanOuWgk5wbugVsPXHOfLTRa2R9sfmm+u6I+eOSQp6/DjShOmmrIKEBt84
         7Mx3SZzPE5Ywvc6mkzGMgGMqbD1jwv3F5CZxX+/l64G+0XHGkrqykuNYhrtUw4WaIu62
         pP7ZylA7FTGvwstmCEogGix2ooqFBJTSmjjT8BRWg837Gig37JkTpQJjKFTfgjMtzOyL
         oWRDwkUHnCqMW5sA7mqDISoTNtPCszkOf7nuevkfJF5aeCNBRgwXx9LhJIIv4eFgnjFc
         zlXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051571; x=1793656371;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0zQfCS+xbNCI3ecGYMw9q9f4jA1EzYR8/pz81vPbgxA=;
        b=M8K1T2fq5qNYo2wjH5Y44yXltJp5EsbiTOFi1RpS9Q0H/kIruDKYVECkDXKbgJeTM+
         0Cu/nZZp4U0VlUbi/3TGL71hNmixzUSBX/pk31yBRZ1okUYNQRJu+v4INYQYpBardoNS
         5vexTAyRbbYNFgio6gDUfsIc0kwFOEZhmWpKaV/1tcksODySkXk1PnegALfBTf6aBlce
         aVFbxcyoslpghaHczzqwsFhrLPXa3hZzWhRtykAtIzzxC/YQD80Z7Lsgy0OAJ8b2AMmq
         deestLqirps2CjFiNl/8Qr81ANycQbPz41fhM6FCCclQJ+mDK4JeeL6ar+9gXIAHydly
         qEZA==
X-Forwarded-Encrypted: i=1; AKwUvBznsjbAjbKBQaEXtB7XUDKcsYEDO7PEzTORF++TeKqaHgug3t4WoFoSoFNwO2uhCziEr1G3d7fiSg==@kvack.org
X-Gm-Message-State: AFq9FYJKC2qzkSc7BlSka5NW1zAvorivRp7asD10viCF5S+TXl4l8oKX
	hDTsWWLF/2NUjCJ5/nRAZ6hukahmL+yOp6r9szM2CzZcbh98N0qgdAXjzXC+NnQE1/GYaRqERMp
	OJbEHW4rKNMQguOYJozsLbA==
X-Received: from pfbho14.prod.google.com ([2002:a05:6a00:880e:b0:8a0:6a08:e927])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:bd81:b0:87c:e44e:5694 with SMTP id d2e1a72fcca58-8a366b88ce9mr5902881b3a.21.1793051571129;
 Mon, 26 Oct 2026 14:52:51 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:20 +0000
In-Reply-To: <20261026215226.3713941-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026215226.3713941-5-jthoughton@google.com>
Subject: [RFC PATCH 04/10] stacktrace: Don't unwind the user stack without an mm
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
X-Rspamd-Queue-Id: 99673140006
X-Stat-Signature: 9iq5ogk7pzn3mgop3prtgrt8us1ygzfk
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793051572-845266
X-HE-Meta: U2FsdGVkX19YEo/1l2vq91ewWOANBDh06boPRqCKGPcyNrnyTO89KPZ2cS7Kd+Vbi2MPWEJWctBoGeUcTzHHDwOxrrLUZ0X4ZCEnoUFHGspSyO1oXRbYTXXjUl0I6XuSsARY01KeUAK3b3ydEFG+8sq/fKbtBLAWcuVZG53wDmwGRnI3Pq3M5qHqY8TUcTY0DSYf2qcbDnWb0IqC8IkD27rdYGdk7sj5n0cvkZccjBtTC5OLdwrdp/xWYT/pOhx+EKDTJ9xcrxmmeDFjNZYkFDe5H3SoiIB28BMfRtOsqS9ObInw/MQaKRfyVV2quuCxSh6Z5mV7c79H6xNUMVfPyM3mXWHzisnwwxH7QDhtjue3SDHt3abSJPE9QIXpECn4ABeSucu0RfkyaVCBu3DSHfwoz1Jj1UG1wXJX1viusRTZb8NtUYjFF22gT2+KkTOKgSLyfiedwQaQjw4qvYim4jVUk/ge7n3Yt70bSf5BAhq38V9GrPXelUb4NTsPCCPoG1EwchTBsGxlW6yIHMgww9kdm4null0gk8n5b+Lv2gQbH+vxxtpx4SNV+yj4FaKAY7OOeeUOoX/ip8CLggZ/sm4XLvnMDa1An8zALjXVf1S0G30vsa8naGhZEnyPIvuHmqH37tXWAhaA1RpYYUrgt2tXt+mYjUz9lvIhBgVNpcJXCDxet6CYCSJ3eUTpdNZTNa/IGceu9Goh4/VAYNig4DEbUGSQtoBxPozXHx05OGubykvxi/7bjSLzu/TkhnTdwBYk3eJxa+UY7QuErLSBw32C8baPOYw1dyUbseRd9ZScLgroQZ0uCzg5Tg8SGdbby1UabnoWB2DgyBwNKKf7V8lk2StZn0eOB47vxWMe6kkIAuIRaswbSaGWSKi0YXRLpLPH5yXrFWvKge/aecqHXWfiitNtsPC7VTiuXz6MesND00oR8FLyQZy3QWkFQ9BYQq4/6lZ0pJJyrEB673o
 8U5KYSHg
 mPVHOr2XvF/eA0R8yiX3xj/2yHipUQNAE8KhR4QjPiDVo+jiq6SNFMV8zKorXVxoJFTAGl0xOXFz/3OGL+RoIhFFimGVgUdSyBC+bZnzoT4HzlBBY/3cJpx8MtYI+CrDpSAup4guKU0KTZKGxsKVK5+tsAFUYSRcx5o3VUILnx2+3YDeqG7qWRG8sbFmi0e7U+RYwFPeBE2Iq4E9W8MBe6SLZImFii3HWZWKCTX3csBLGwQ0RIHeAxwmSNyjcIYAC8fgRAfnbIBJSM9BTzub4WaDutjgk5F+1XnKpzhL83ra47ASSeoB++za5mDGvqTFcZa7Z5C1II+mgiLsKAv8IjSLXHJ/g+XH1aJ+4/KzZNbYzx4/j6nYlg2nS6IXEVE/EyLglfesNP2JMYbW+uIoDHzYjyWt4WlIHFJ4qz2GXYhY09I884BF6ALBNbEvKzVOlKCUiwImpg6wd0cj7G6moIWQNK4CsMlZTJ2+tCQTHAwAmckWqmCGI7ZBpEGbKC+vRDbgp4J7Es/v+1l5Xj0O+hH5q9bKbg0S302X1WgHTPnhhLGdxgHw3eVgcWBlcx3ZH39l24DeVu9rJcvlVWIcfDyMdJ30uc73e4cLidX6fpH/bWEXufxoaeKrOCyLSpHH4nB7MsWprF5TEPzrZfl/DMz21sA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

stack_trace_save_user() only refuses to unwind the user stack of tasks
with PF_KTHREAD set. That doesn't cover all tasks without an mm:

 - A user task that has already gone through exit_mm(), e.g. when an
   event fires from exit_files(), exit_task_work() or the final context
   switch in do_exit().
 - PID 1 before it execs init, and usermode helper children before they
   exec, which are created with user_mode_thread() and don't have
   PF_KTHREAD set. E.g. booting with trace_options=userstacktrace and
   an event enabled with trace_event= unwinds PID 1's "user stack"
   during initcalls.

With the ftrace userstacktrace option enabled, the architecture
unwinders then read the user stack without an mm. That access does not
reliably fail: the user half of the address space belongs to whatever
mm happens to be lazily loaded, if any, so the unwinder may read
another task's memory.

Use is_user_task() instead, which also checks current->mm, as perf
already does for the same reason since commit 76ed27608f7d ("perf:
sched: Fix perf crash with new is_user_task() helper"). This also stops
unwinding the user stack of PF_USER_WORKER threads, which never run in
user space, matching perf.

Fixes: 214d8ca6ee85 ("stacktrace: Provide common infrastructure")
Signed-off-by: James Houghton <jthoughton@google.com>
---
 kernel/stacktrace.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index afb3c116da91..f96a5ec12f6c 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -228,8 +228,12 @@ unsigned int stack_trace_save_user(unsigned long *store, unsigned int size)
 		.size	= size,
 	};
 
-	/* Trace user stack if not a kernel thread */
-	if (current->flags & PF_KTHREAD)
+	/*
+	 * Trace user stack only if this is a user task that still has an mm,
+	 * i.e. not a kernel thread or user worker, and not a task that has
+	 * already gone through exit_mm().
+	 */
+	if (!is_user_task(current))
 		return 0;
 
 	arch_stack_walk_user(consume_entry, &c, task_pt_regs(current));
-- 
2.56.0.307.g5fe7bd680c-goog


