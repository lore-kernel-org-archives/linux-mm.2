Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CE95606AB05
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=HpjoMFrQ
Received: by kanga.kvack.org (Postfix)
	id E7EA96B05B8; Mon, 26 Oct 2026 17:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E816B05B9; Mon, 26 Oct 2026 17:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59A36B05BA; Mon, 26 Oct 2026 17:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2296B05B8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:52:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF3D7140832
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:55 +0000 (UTC)
X-FDA: 85366127910.22.55DA1BE
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4983F40003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HpjoMFrQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3tMvfagoKCCkOYMTZLMYTSLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jthoughton.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3tMvfagoKCCkOYMTZLMYTSLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793051574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYBRYm53aIgyLidEi/RI31/ngJcANLPfjWm3HzPNi4M=;
	b=z1WT12V+lSce181Ma3saHh090/inPwh9NcHENHojBtK8g6+PNQnlrgrZvvS3fr3/5pYBZ2
	5zVf6XdYeWvASjdEI/PuyV9g60ArDOnFHIvopBi1MHG+/BBm1rxonePUA1Vu/0pqJgt25x
	icVCUyrgvca0UWFUF90Nj555Gb4zgTc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HpjoMFrQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3tMvfagoKCCkOYMTZLMYTSLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jthoughton.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3tMvfagoKCCkOYMTZLMYTSLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793051574;
	b=1xsCStdzPCfrwBEOX2uWjEC69KD8AEpAuVpjMAipT7+mOh1TAXi+zsHB6xhI9q/sexet1n
	A9WQ8QQth2c6fwA75DHISUvHXVPVaEHGukEH3eAhUZTWzhc8yPGkFQoKdsDDboBF5CZgjc
	LperWbgOjhzvNQVqsSRn8rFlEDbx3Uc=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ad704d4760so3182804a91.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051573; x=1793656373; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cYBRYm53aIgyLidEi/RI31/ngJcANLPfjWm3HzPNi4M=;
        b=HpjoMFrQo1TZr6aRzKahixs+XuWgbKNK03qzVhFfN8kuB5fpsqoR65Ah5+0R3dDhxB
         bo/54cU/Psu9c7OOKJZeSEvVsmfsON4P/plHloC8nVCO+7uYFiHlWJp0//DjyrqWkeOO
         0KZIYvxWIWaVWw7BTQvwDe+ahk8jwlkW5EfLkbGuMOhM7OSN0/Iuz9JDGcNy0cGXVsKz
         4yEZxGPjrXsRdfrPlgtvZ+l/53PgpHfifBsthUqdqhFBVeD3cDOE6NqiO9AJ2FFMtwEG
         rJfwqnx5kzqVJ/NWNuIgF7JsbCU37K6lFIkYilPObmc0RZi8D2TYOk5GL9SmO5abx/B1
         QZ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051573; x=1793656373;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cYBRYm53aIgyLidEi/RI31/ngJcANLPfjWm3HzPNi4M=;
        b=i0lIsNw0xe06UQL3Nym9uTxkZlUA0DD9IQBsJQdIor+F2LcDwL/qQ6+FwjBGmUHIcJ
         Ryudsg0BsLQ4ZF8+giOObv2UIQ6Aub9sufhlcBatC7vt1u5sQoL9CWLDxXPgZ8cDoMmC
         SP+KPSc7kMGjUJMukK9oXFonZxoC5uFt+Ppxccswt1q6T1J/qhz/b1Wzjzih8o0qEeA4
         BUt5sRE13+ThEw8eKBVM9yuI2VhZzX+TEWHoT2Y4tEZ4MpXk0+GK1TmaDCvBDDJcGMr6
         iy/Bqt96FZHBK60ZvXJwMLhSutWe7Ruusv93SSOsXPfOZ94IvFkt8veIBgiMVxLoaItQ
         y4vg==
X-Forwarded-Encrypted: i=1; AKwUvBzBrYdpFEkrB1Q4UwoH3DVHX1McJ3DcjMJ/NXXJnfBxcO3cgnzEsU6apENr0rn/PI934wXL8ChAmQ==@kvack.org
X-Gm-Message-State: AFq9FYLlnzsnR5Oodgf5wpAzuTQHY4kkfLGbjz5oGIUH9GImOvxSv5a7
	fddMB6l/VbuGaQCV649a+gc1w1wWDNJIiBq2vghMoeFcMISIkJKHX7nnDFX/zKwIa4tf4HsereZ
	0bouG2lssvPcCXKIbRbNaMQ==
X-Received: from pjst21.prod.google.com ([2002:a17:90b:195:b0:3ab:3d7f:6c0c])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3ec7:b0:3ad:3715:d21 with SMTP id 98e67ed59e1d1-3adeafb0481mr6464242a91.49.1793051572848;
 Mon, 26 Oct 2026 14:52:52 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:22 +0000
In-Reply-To: <20261026215226.3713941-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026215226.3713941-7-jthoughton@google.com>
Subject: [RFC PATCH 06/10] uaccess: Refuse and warn on user copies when
 current->mm is NULL
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
X-Rspamd-Queue-Id: 4983F40003
X-Stat-Signature: xuin9jwb7cj6mgfgr7b8s9xycu7q1859
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793051574-33356
X-HE-Meta: U2FsdGVkX18yeLlMUPikJ+cA/PcuFkgANJEErNDjOQRJRW7QXZk3Dz52P+AM304iBLwoAgJpFK53Yj9BsS7ces1RE2ex44/rFmiBe1qKiy44EA0AIEAk9FaBeOtu0GryNcFeOg1aa0N3C8LKlY1H2vsvGdmna8MbWk2OnIBxvLAs9eku9xIIPmCro49LLnb5WkMDG88a7EBYl3dpQujAzEAxrAs3848IqrE8bjXHylOPNWSWckx2+7aXYANDRO6/RwSTy2bLh49yBadxG893SC1egwb0u9iQ0fAw7CcZMdkxbpSE+KraYjisdizme/KUEITBCpqR56WPNCJFc5IdQtJTLAkGlVTHtRpaDj8XRaDo08yEiBo7/SRDjYA7I6M67dEeqt99DgdwpUPh+9ZA9BDhZUjld3hDbDF3JWgj+VofKvMpvcwe7SmE/lBka5T2NKac6CraEOLMLHxEwaMt2RQyysHBT6MpX46ZLogR4ZAGzp2DJJlMIhS0uaaVlcGRUj17Tz9T41w2gl+8y4dvgWxi7h0gdOSYUIKrm6kqgqV7DBEhz1OxmVDSzemZ21bT0P2voPj+KfmqzrwvUL5//61XeJ6GCcZCNSG628wJIfYX3j55pEptiv2QcSuAxzKPAN/LVhFZHuiAw2d6HIl7M2PGEBSeZTffcvCjIYIyhymt/wwL/0cyo4fiC8+xglx91E/1Qh2Lo5KLx+mbkyGRmXsZU/whuZxY/zXCAvQdTfwrvntRyBgBL7n/ZNon3KPXdCRaUlGH89L1vhPc3YAd6/yg2Tv/0QsurOmRvGu4IyPo58W16PNAoeNwAkP8MJ7PU1iforrUoDie6Zxe4GqfJcgfRb3x4xTOlgwnUH0nSi1RFezYWZg6Qcr9FFim9TYBq5qCJ0dDAQikQeLtqgJ7vzUC3WNiiwvD5AJFKDDepOnkff5vbwgYiKV+HJ19lS8XBy074Rp33mKuKwnPM4q
 4EKcxdn/
 OmQFbAYzx6DwDg526wv0cy6HhqByYG3MLUVhVD0n4yoFrpimW6sOqMRK6T06lKiDx2TB7ORvyxsORf/4j62UsQwTzVpWFP2D7L2vuMckogYQNSbDItqvfLIYQZLSj9/3ixWfqBKaM9saz1znxhVVFdrAcDMM3Eek/bFKK+ZRxrC1BgEUzZilN2Rnz4BVXrd5VGDeFLtWgLrb88fxENFKSYdqV/47faPDzhhwVIYsxH+0HXfdaddsEQW85r+jxKWF1HbR1JqBrvfX5kTLQZR+FtGUR0nTtu1vNggRoUg0U+MWXqLRB5w5xv0x23Bp2893zYV20YhFSZv+MIKjQJHUMDsvQltAt6a0L2h/CVO2/oVEWY4ccxtujH52mCyXLwyBEH+UY7Hn3GN2irmEmc0Qet1mVTMsVbaqYqiH6B9mKxHTAiGn6TGZqTmzS+Un0HHU6x19AiSyy3e2iQf1UKnp4h49BcSf+lkw5drev0dl4FzAGUsAaNHNU9yb96gQhHeUHWMpvOT5lTsED/t7DM3fzN+VqrArGSmC1ZhJCF5ypashv5/kjd6wHwRpPS3kvqdzWxjLqnIh30Yr/fqrdeFgCKUdzbTtLaSs7+1LZ8bCI1kRzxC6M0RldYpkShMyLKAd9U9cr4yz3CoI3aoIQAxg5Zel7qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Accessing user memory from a task that has no mm is always a bug. This
can happen from a kernel thread that is not using kthread_use_mm(), or
from a task that has already gone through exit_mm() (e.g. when the last
reference to a file is dropped from task_work at exit). KVM has had
bugs of exactly this kind, and other drivers may have them too.

Such an access does not reliably fail. The user portion of the address
space belongs to whatever mm happens to be lazily loaded, if any. If
the access faults, the fault handler refuses to handle it and the copy
fails, but if the page is already mapped, the copy silently reads or
writes another task's memory.

Add uaccess_should_fail(), which combines the existing
should_fail_usercopy() fault injection check with a
WARN_ON_ONCE(!current->mm), and use it in place of every
should_fail_usercopy() call. The user copy is then refused as if it had
failed, so no access to user memory takes place.

This covers copy_{to,from}_user() on all architectures, including the
masked user access paths that never call access_ok(), and the
__copy_{to,from}_user() variants used by KVM's guest memory accessors.
It also covers __copy_to_user_inatomic() (and so copy_to_user_nofault()),
the user-backed iov_iter copy routines and strncpy_from_user().

Paths that never called should_fail_usercopy() are not covered, e.g.
__copy_from_user_inatomic(), copy_from_user_nofault(), strnlen_user(),
get_user()/put_user(), clear_user() and unsafe_*() accesses within
user_access_begin() sections.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/uaccess.h | 27 ++++++++++++++++++++++-----
 lib/iov_iter.c          |  6 +++---
 lib/strncpy_from_user.c |  2 +-
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index eddbbb65ccc4..8ab24e706a22 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -50,6 +50,23 @@
  #define mask_user_address(src) (src)
 #endif
 
+/*
+ * Return true if a user copy must not be attempted, either because a failure
+ * is being injected, or because the current task has no mm.
+ *
+ * Accessing user memory without an mm (e.g. from a kernel thread that is not
+ * using kthread_use_mm(), or from a task that has already gone through
+ * exit_mm()) is always a bug: the user portion of the address space belongs to
+ * whatever mm happens to be lazily loaded, if any, so the access could
+ * silently hit another task's memory.
+ */
+static __always_inline bool uaccess_should_fail(void)
+{
+	if (WARN_ON_ONCE(!current->mm))
+		return true;
+	return should_fail_usercopy();
+}
+
 /*
  * Architectures should provide two primitives (raw_copy_{to,from}_user())
  * and get rid of their private instances of copy_{to,from}_user() and
@@ -114,7 +131,7 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
 
 	might_fault();
 	instrument_copy_from_user_before(to, from, n);
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return n;
 	check_object_size(to, n, false);
 	res = raw_copy_from_user(to, from, n);
@@ -138,7 +155,7 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
 static __always_inline __must_check unsigned long
 __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)
 {
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return n;
 	instrument_copy_to_user(to, from, n);
 	check_object_size(from, n, true);
@@ -149,7 +166,7 @@ static __always_inline __must_check unsigned long
 __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	might_fault();
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return n;
 	instrument_copy_to_user(to, from, n);
 	check_object_size(from, n, true);
@@ -167,7 +184,7 @@ _inline_copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long res = n;
 	might_fault();
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		goto fail;
 	if (can_do_masked_user_access())
 		from = mask_user_address(from);
@@ -195,7 +212,7 @@ static inline __must_check unsigned long
 _inline_copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	might_fault();
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return n;
 	if (access_ok(to, n)) {
 		instrument_copy_to_user(to, from, n);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 2072c04e99d0..3d6ecb50d778 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -17,7 +17,7 @@ static __always_inline
 size_t copy_to_user_iter(void __user *iter_to, size_t progress,
 			 size_t len, void *from, void *priv2)
 {
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return len;
 	if (access_ok(iter_to, len)) {
 		from += progress;
@@ -33,7 +33,7 @@ size_t copy_to_user_iter_nofault(void __user *iter_to, size_t progress,
 {
 	ssize_t res;
 
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return len;
 
 	from += progress;
@@ -47,7 +47,7 @@ size_t copy_from_user_iter(void __user *iter_from, size_t progress,
 {
 	size_t res = len;
 
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return len;
 	if (can_do_masked_user_access()) {
 		iter_from = mask_user_address(iter_from);
diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
index 5bb752ff7c61..565b3125e752 100644
--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -115,7 +115,7 @@ long strncpy_from_user(char *dst, const char __user *src, long count)
 	unsigned long max_addr, src_addr;
 
 	might_fault();
-	if (should_fail_usercopy())
+	if (uaccess_should_fail())
 		return -EFAULT;
 	if (unlikely(count <= 0))
 		return 0;
-- 
2.56.0.307.g5fe7bd680c-goog


