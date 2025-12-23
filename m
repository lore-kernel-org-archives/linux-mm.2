Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F5A0E6F09F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 16:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1EA46B008C; Tue, 23 Dec 2025 11:18:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ED626B0092; Tue, 23 Dec 2025 11:18:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6BD6B0093; Tue, 23 Dec 2025 11:18:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 67EC36B008C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:18:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7AE0B8C4B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:18:28 +0000 (UTC)
X-FDA: 84251243496.20.083234D
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id C3A68C0004
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:18:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DOLU34Vg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 30cBKaQgKCM43uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=30cBKaQgKCM43uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766506706; a=rsa-sha256;
	cv=none;
	b=sVVSCi4PyDdG4NWNRc7wb3ShF5lSL1kP3iSsEN9AV1lEl0sKnHF42a04VtHVHVwqMfKdAV
	svwUukm5FBnZS82GP6MN8IjU3gBObitzEiOnXtOtN5jCJ21KUwNDcrKgaN3a9WFJBJ87iO
	2C16ey4ANsvF4YeBGdBYI5qL2dYKBMk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DOLU34Vg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 30cBKaQgKCM43uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=30cBKaQgKCM43uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766506706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8qAbifDARtNQH6///Cfz2Z6dr98BHzjmVALCF1UKvo=;
	b=R3vF2WmQB3XD8dRSLLmgz8HgRq0JA5xg0qTMQoG+rZnVjsTwkB9sCv5Btvvi6zrewn3TNG
	S723CMrc1WyEkQ36/xUWsK4Y+lUbJPfFJaG24wLB8BKjaslI3vnzONSRrBnfDDcAxeoB1r
	nwxQRnwv2Pa7tVrGSjsrW7qRzyZBIfI=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43065ad16a8so2430577f8f.1
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766506705; x=1767111505; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R8qAbifDARtNQH6///Cfz2Z6dr98BHzjmVALCF1UKvo=;
        b=DOLU34VgbRwUeXX84QSEc3EfHGEafmlWJZhmCpRnfZcxy4zFw9OBLO0Yc0SKh2Lm5J
         jrXOvVnndRTfRCNT28zuhvl3DUlWp4p4uLXyu51R6+YT8hWFTtrW+YHCq2BUXkQOw+R6
         OQ4fEdU4bbZYLUMwCFfDEFeFmSFePzzvHjXdh9HZkTEDj+mf7ah6K1t2J7EyRKrHp/Sz
         kJBe/5Ka5FUGYOtluN6fsTnQPO1i9Ftn5Ab/iinSazRjQKuRyUkTnktyEaWcfh5qHcV8
         c6XKN0pzTNk5Y+oG471X/jolojC1AkitOru9x4Z7X3g5yBCDxxnfmfav6QF/+CEC9K4d
         jZrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766506705; x=1767111505;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R8qAbifDARtNQH6///Cfz2Z6dr98BHzjmVALCF1UKvo=;
        b=joTxchPrQaT2RKJqvQ9VgCdOjH00AvBO6FYrzX2yN5URVIpGXvnv9AP8TvGCBWtEkK
         xSH/trqaYu1KAAb34cqPTskKHuFn8a/PhvAUiWa+S6+EBzXs65qZQEPy59pSjqW7gCi0
         5/s4z7eDVU/u7VSk1bUWQq2NWIYUCDIkei1JkXAfluYla5cdhCpwmefFjoBOZCKDfFMp
         4nLGmXg/MUQPpakM4nOFI+ltbvmaWrlF1NUqYzCg3avvcAab7zvGCQJUK7GuPCWex09S
         EzoxdC1ZnKgntyjVZcYWsjMAQJG74aEWySKiW4WZzKpsBquE/i8mfK3Yj38pjUPZDHEc
         9b4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWjlvwnMDi5BPj6ofKBE7QgjnLB20qb9MRBPfWIls6RYM5k4dmD55+hDf+VcwuNhC2n4SyImZ896g==@kvack.org
X-Gm-Message-State: AOJu0Yw33LLh08u79NvjbZWQawsKFtvicI694bZH+mFmxu1BQLEgdtf7
	mpcrOzH4P6pLrKa562BrBHBDddXvcNwTjbqe3zRb7iGcNJfcC4YI3IwWEiGB0OJ7DUwq+QZqylL
	zEe7DFITBZGx9cQ==
X-Google-Smtp-Source: AGHT+IE8oDnfqXf51PXB9j7+xWXr487pSfiP2TuENwnOyxXdASQaxwRWlpWlqrTmlw8rYWPUrC2vEA5s/m4GpQ==
X-Received: from wrbfu10.prod.google.com ([2002:a05:6000:25ea:b0:42f:b7f1:749e])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f54:0:b0:431:907:f307 with SMTP id ffacd0b85a97d-4324e506ab1mr15076109f8f.48.1766506705229;
 Tue, 23 Dec 2025 08:18:25 -0800 (PST)
Date: Tue, 23 Dec 2025 16:18:11 +0000
In-Reply-To: <20251223-b4-kunit-user-alloc-v1-0-fb910ae0e50c@google.com>
Mime-Version: 1.0
References: <20251223-b4-kunit-user-alloc-v1-0-fb910ae0e50c@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20251223-b4-kunit-user-alloc-v1-2-fb910ae0e50c@google.com>
Subject: [PATCH 2/3] kthread: Add kthread_take_mm()
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, 
	Rae Moar <raemoar63@gmail.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: C3A68C0004
X-Rspamd-Server: rspam03
X-Stat-Signature: 9k1bhz6zsa4zx5baza6531pamd1bqqh3
X-Rspam-User: 
X-HE-Tag: 1766506706-142336
X-HE-Meta: U2FsdGVkX18wgnXV8TpW8jaQXvB6ubtD6ceHD+Q9rcIHQOR5mG+BT/Hb+htS0V5x3t4kBjOx8jn3SsSG4QVgvOSk4pvaLD/3l/G4PBF5nAwXJzXKzjcoQndmGmEOBZo2a8FiolXNHxY5jA91I5D3EpQrsQKKE5PzYOX1ke8GgAarIK56X2ejEngQHkwmRSc8jwYbr4ZcsBo6TpgIuBF2qujs6iEbf001bzaMS2pS+n5DGMp4T1Ik/t9yFUV73sXHtYCX2eH7spreaK1BT8ywjTJnVMGcNyMljZkeasug3qpvOSOXpiI+q/hHuBEgMnRpi0HdJ4s/i77ty6YqKejE+GovGcwxFsGuZYie1ElCwX6qJhN3FKM/ICVY4Z2JtjbWpsj/4fH5b15nKZA6uNHT1UKrt0IptHhjLLXqrZzOEHw9veltXodg4p0myKByTZeKShpxwkOxv+4JCYTOTAlGFny1vlSQP3msUWJEOhjYvs2Q8h+CGbULWKa4hgfFymfopFt4AvxcEP9DY2bFQDV1am8LPTn1n1XR9HIX2IVpq52/xnCMBPp3J8Xe2sIqyxbuvdqH+4lv7KnhvOzD5q9U/IiDfaucYEiEzZZ9PSqlUTzQ59ZbLoBgLpdoT3/W6LcsPoTMwFcN695pLTZye97mvHmYdSEiWMHu8tj3M/kbHdyEeDFpLPWqNc6vEo4KxiBaw+JAhM2Rt9fNZUGidMX1jlEEF0lMA3mVGA2IN9bovLo4/YhvNKGCOfJaipF/b/LdyoZy8XNlkM1H5DmxHswmYYLFfdlai4rUvK+wW5RVW7fJMQgfHo2vu3LHKfwcfuuzp0+RJ1ztrvETfzB1Cwy4lyTzVuYue2USV39+ne3FjMKKrWdReWg5uhisYsLrZ7W22S2xAAwO5YxgGUmLz6wNOCuZvfAihHG5zKDtwV4HHkNC6513Ucm3ryS/D8Rw7wuN+qkNqtLgXjQ3lQlWju8
 IJpP7eMV
 INTl5LyP7pf1+wVruwZBPVDczmMmKwQFFz+3wRUo9ioWGJDUx/7iKKZ3SqVNuy69hSaXl/rsFmuZVO610qdtej9QW7Jw5mPnPBgc/o7b+ODvZ3u81/QaMjqJCXWbQ6B5CRq1ov303iQ3ABmU3KrCZgnS5r5mSVPu64eMnK+fvxztDpD69y2K58A7Km6huXyu9M4HjaonCACz/mEgGRga2mlQb+CsxbF1V3PLm8T+vpB6sK8rtLLhsKWMDCb5LsjhUSTIsAkPXaVw7V1644U0YkeoBozfAeAEcy1eAF1TMO4NkKCmlqvWSPo1XH1D9aFdzWJitKwfSQvAtZBCamz6vAPEgukzs8omQUKw7+1vM8E4FykFXnaNYjUage41PcltTXwAUGdESWbFBx4AQ8CL0WGL6EggT0zrW7VKj67NuisVNiIG0z3+I6Q/cAWOonupJ26d6CqeaPOEa6zaEYB5lahDQ9+05QSNZQnaem7jueMhthqH94uYRMPCoJd+mZXazqLo8L9Sry0G1GMPHRkPybixNMUrwz+YPTYVpM0rImsZUp31eNr4cnqgc4ZUesxToim1mngJhAZv26JdJ9LYwlHc5Es+M1uX7qgGmquriCzlMzIHl0qkpnjm05+yo0XtaXryOKTvtZvTF9pI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lib/kunit/user_alloc.c currently uses kthread_use_mm() without a
corresponding kthread_unuse_mm(). This is a bug, but fixing it in KUnit
makes writing tests that use mms more difficult, because of KUnit's
resource/try-catch model.

Therefore, introduce a new operation that does what kunit_attach_mm()
wants, namely an unbalanced call with cleanup deferred to
kthread_exit().

This is actually just the same as kthread_use_mm() but without taking a
reference on the mm_struct.

While adding this, clarify the reference returned by mm_alloc(), since
that is what kthread_take_mm() is gonna be paired with, in practice.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/kthread.h |  1 +
 kernel/fork.c           |  3 ++-
 kernel/kthread.c        | 36 +++++++++++++++++++++++++++---------
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 8d27403888ce9..2e6244d8ff1a3 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -259,6 +259,7 @@ bool kthread_cancel_delayed_work_sync(struct kthread_delayed_work *work);
 
 void kthread_destroy_worker(struct kthread_worker *worker);
 
+void kthread_take_mm(struct mm_struct *mm);
 void kthread_use_mm(struct mm_struct *mm);
 void kthread_unuse_mm(struct mm_struct *mm);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index b1f3915d5f8ec..761e6232ea75a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1147,7 +1147,8 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 }
 
 /*
- * Allocate and initialize an mm_struct.
+ * Allocate and initialize an mm_struct. The caller gets a single reference to
+ * the mm's address space, which should be released with a call to mmput().
  */
 struct mm_struct *mm_alloc(void)
 {
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 99a3808d086f0..c660c04a1b627 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -1589,10 +1589,16 @@ void kthread_destroy_worker(struct kthread_worker *worker)
 EXPORT_SYMBOL(kthread_destroy_worker);
 
 /**
- * kthread_use_mm - make the calling kthread operate on an address space
+ * kthread_take_mm - make the calling kthread own an address space.
+ *
+ * Unlike kthread_use_mm(), this doesn't have a cleanup, instead that happens
+ * automatically on kthread exit. Correspondingly, it does not take any
+ * references, by calling this function you donate your reference to the address
+ * space (from mmget()/mm_users).
+ *
  * @mm: address space to operate on
  */
-void kthread_use_mm(struct mm_struct *mm)
+void kthread_take_mm(struct mm_struct *mm)
 {
 	struct mm_struct *active_mm;
 	struct task_struct *tsk = current;
@@ -1600,13 +1606,6 @@ void kthread_use_mm(struct mm_struct *mm)
 	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
 	WARN_ON_ONCE(tsk->mm);
 
-	/*
-	 * It is possible for mm to be the same as tsk->active_mm, but
-	 * we must still mmgrab(mm) and mmdrop_lazy_tlb(active_mm),
-	 * because these references are not equivalent.
-	 */
-	mmgrab(mm);
-
 	task_lock(tsk);
 	/* Hold off tlb flush IPIs while switching mm's */
 	local_irq_disable();
@@ -1632,6 +1631,25 @@ void kthread_use_mm(struct mm_struct *mm)
 	 */
 	mmdrop_lazy_tlb(active_mm);
 }
+EXPORT_SYMBOL_GPL(kthread_take_mm);
+
+/**
+ * kthread_use_mm - make the calling kthread operate on an address space.
+ *
+ * This must be paired with a call to kthread_unuse_mm().
+ *
+ * @mm: address space to operate on
+ */
+void kthread_use_mm(struct mm_struct *mm)
+{
+	/*
+	 * It is possible for mm to be the same as tsk->active_mm, but we must
+	 * still mmgrab(mm) and mmdrop_lazy_tlb(active_mm) (in
+	 * kthread_take_mm()), because these references are not equivalent.
+	 */
+	mmgrab(mm);
+	kthread_take_mm(mm);
+}
 EXPORT_SYMBOL_GPL(kthread_use_mm);
 
 /**

-- 
2.51.2


