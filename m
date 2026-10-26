Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA75A606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=GVHH6YBV
Received: by kanga.kvack.org (Postfix)
	id 99BB26B05BA; Mon, 26 Oct 2026 17:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94CD26B05BB; Mon, 26 Oct 2026 17:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDBD6B05BC; Mon, 26 Oct 2026 17:52:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 482CC6B05BA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:52:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C41FC40862
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:57 +0000 (UTC)
X-FDA: 85366127994.23.9B47D1A
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf15.hostedemail.com (Postfix) with ESMTP id 177F6A0003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GVHH6YBV;
	spf=pass (imf15.hostedemail.com: domain of 3tsvfagoKCCsQaOVbNOaVUNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jthoughton.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3tsvfagoKCCsQaOVbNOaVUNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793051576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bFIgocNkSNISRV4CHBI3t0UD1tr56XsmI6e/PuL6mFQ=;
	b=yvl8fcPwaD3yxHCdummsuq6mcgdYVtSIN7uJ6uqUgvZVYkU0WhOw7bYjijfD4B/8YVpzWL
	jb8A/h0nHH9eA5ysHMYFkOyz3mR91m5LPoonDL0RUhiAbVDfZMkN/BqBRPqfhRRAnIIzbE
	Z3Zd4JWTTKbOhlBdwk0HiRNJeFuRjes=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793051576;
	b=eT5cj8ZyGRpgs06nq9NdgDOg7cyWrTWvA8lLQ/NOP3XcyfHr7+SbJ3+u5jwUnMbadJniKR
	GhVmHKKzkyovVMzommu9TvZcJJoDJobvpk4HWtic7lVPrAtJ0WewnNWmh1W1XZVt3YoRvu
	rcIGTAqC1MGAxdrPeAJ/5rUnxD0CplU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GVHH6YBV;
	spf=pass (imf15.hostedemail.com: domain of 3tsvfagoKCCsQaOVbNOaVUNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jthoughton.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3tsvfagoKCCsQaOVbNOaVUNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2df8484f12cso33290685ad.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051575; x=1793656375; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bFIgocNkSNISRV4CHBI3t0UD1tr56XsmI6e/PuL6mFQ=;
        b=GVHH6YBVF441BSCzN1i/9GrDqYU2iJUG1uOWFzjUvZLGK6K7107KUZAEfsLN1hW7Hy
         2lvvHewqVjYvr0lqTzJI2vifu6RyiTy7E4LI1OO4++NEaGSRccJyQrVHAjGeut3cRc4e
         Lg56OfSHur/kaLK0tpAiHJm+lrSryHtAgxJZwKwy/jDrA6j92oUTFj/8gjNlOEr8IDsz
         R4vkSPLE7bpagqw/2Xc2kUbR1hhuGwT7n7fb7frJm0kTp0wGTN99PwAAiwUBi22r44Kb
         lQ0dvVACaRm3WO8eqPQwE+IAJ8z3vgqByUsLKIlyM4/utwWlVN26WdSQq4hAarJgbF39
         hKpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051575; x=1793656375;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bFIgocNkSNISRV4CHBI3t0UD1tr56XsmI6e/PuL6mFQ=;
        b=xT4oeHhX9PdFzrR4DXo3YjpnjFKLurgYzZMTQpBJgHX31lrEYEn57YvI2AySBxGHMh
         yOuBuWWEiSpsSP5SKSf7MSqz4vVS0VpNa5LJpH5/q3IXqp8DiO93vEIB0Em+uM2N7AoH
         G7h0LSmB22+HTZPST+H9TTipDMM0Exy1iRXBJmeqhW0bEqytV4LwU2CToLsjHpDe+nCD
         Zt8ZTWJN0KG20rfRzK/rc/zXFTQ1Ir682anbsZhFqNUd6wNox0SDV2ebNBFc5uXy1tMs
         ou1/0DhgoRkfeblsu+HCtUR9dTb+0ERuBVpIGu+b0RQBctHJSjX9d/Nfpa/TMkUsOPes
         8cqg==
X-Forwarded-Encrypted: i=1; AKwUvBws5bfXCnKK9CqpnzIJNfI2M+nAduYdJwoqrmMtceh7f11hwFOdAUpV6h79i0OLP9g4rszbMzXBQQ==@kvack.org
X-Gm-Message-State: AFq9FYLC5lhL8QFht+aHDQ2SwPxgXTWG8Hy+GDG4gbzAoOhhjTMyTXTW
	X2636KtffppixcO33Zef+Xr5Ztbn5kO97nrFIvkaLzcToaALYuc+6Zb3LX4ErsendQJtxfedGxH
	fKqVymVGc7ZRxU5fWE4p3Bg==
X-Received: from plblg15.prod.google.com ([2002:a17:902:fb8f:b0:2e5:712c:5c7])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ebc8:b0:2e2:e0f8:e57c with SMTP id d9443c01a7336-2ea9c95ba58mr63848015ad.70.1793051574627;
 Mon, 26 Oct 2026 14:52:54 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:24 +0000
In-Reply-To: <20261026215226.3713941-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026215226.3713941-9-jthoughton@google.com>
Subject: [RFC PATCH 08/10] uaccess: Refuse and warn on __copy_from_user_inatomic()
 without an mm
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 177F6A0003
X-Stat-Signature: oh567udsmp8bxxpm39faysygsqywys16
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793051575-610962
X-HE-Meta: U2FsdGVkX19xZq95xrl5c9BaZ0VM+IZYcbM7D59+SVt1HxGhXYFPfoF04Cgag+AQwqh13RHPFoke1+wSViG31zn3ic3f+DkzNMmSGWirY2obnZUzuvYnIQaGRPt+17q9YW4qfA7YPgfsceoy5h06ZI/7Wgagzco/0W0VI32wk2f+xSlXl/yQhbZgM1L+9a0EsxUPni3BVBbbGwIKj9FYYSy5rp6Lo1dozmdyZlDaCNgHa3uxkEldPVSrsiK004J4wIplu9hb1X+IjjfY5CMs2Cc7yG01X4yq809RRadl/p+8DQqYQoUzljsBq6cuaF3XEvIiUrmmkbHUjfcugpg/7iEsPnX9BUxFPW1yEVo8vMA7PxV6emeMEqfi9WvgfFjBBUW0y9qUnftbG8ZR4pxSrs1Ug0/rRVd2Ef+uQsGqgTSvu55lsl9bQ8aH4v/dZL7Qo1o+6+D1PdWIRqfpnuwi4J20+q0AxHCve1H4DtwO9iMbJjlZDfzHJoIcvA8jAHxIOuHQ3iYoUM3k0y4AGiqDKZch9ykZHoMYwL5kudaWLRe2Jb4rdttkcUjNnervgqgquJQRjSzCRWJt8Ml4CojriPhdm6IZnrgnId6CX8VfmUVKweD7kNvqcGfZDObC9s7MoU6dB5Czyv+5r26MhHcE0PAoFUmBBVT7TFURQEXZ5BqPzHW7ATAvvbrmiDaJEOn8EQLgXKIQiZw/gopGeqSzyPsVIScwlqxvgWKVXDEX8/x3HjdHjEK1GUuAdq4I8JjI9UMVYV9Lxv9NIT7LpEjzYSo/58WlzRU56RETol8KqCoLZnuc90/IFIbs2VatQDkGsa2sOQprO5tA3BqSaLiAAaaCp36LRSw3grMyxZswxI3r0Ie4ubPbAnm0tc/uQrPq/lM40G8X+hkVI8oqXmvZgKGT/RiSC2iWBBx8TKWOu1aNla/QGuXRMV+p7q/D+Vw6YC3Iq5jIFrYWfwPyyco
 l688QgEa
 d/Ikqk38Yl+exatPIch2dwsp9rENIsHhik8qK+KDuH0bZX4QTPYlSGqNx5asMslkxhR+EbJNuChowND/kXaDfQ3Ono3WFdfvk/pD1iOrlOqk7lPlYISpBWcnbfjAtk1YJXI+B5r5tqcmVdhQdDXmvdvk5lTFbzZJCONhf2o8uuHtkVwsmgo0xyaLrOzmvRHa+mhvAm3byW43XKRlwciGS1QOwt68PriIi6ruWTEHKKRwkRA+BsLi0pVT0eBYviFiCierxNEZ//QYBVEII+F3OS+Oygfwl/FkJ8vkvkhKXal7dRZk0Mfmmdr3j64ryRnDnIqOqXUKFb8QH3uOUwDTg0Io6Oi6M5ZZEQnq88fpIInlznKIpzERKZhpqemqFA90IIDNgre2gU+6f07Ulgp0J8vUSVVdN55w5feIU3mfCDvihsridT1eJqJjbaOOujtQozPCd0x9gpXLaP6HspBGzRZzCwlOVr+FxSV8X4VXC0JkUe8wspGZZO6k3sY0f+5VQD1NXauzORWMRnMWnelCiJArtDgPVS6JdVEH4upB5CN0e1AeLF4hYEykYW+kQG8L+9MXnX8YcN5HAFsaBL1q0kQsbdgN51Ippfm/LwSHIVggJ53jTw4T7kJXP3hKtGn/5m2tZOda5I37NRY+tn/qXFcAdbnYMZFm2mxqqDofv9j12Y31DHT1tiXtuVFXMTOcGz1qE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__copy_from_user_inatomic() never called should_fail_usercopy(), so the
NULL current->mm check added to uaccess_should_fail() does not cover it.
It is used e.g. by KVM's kvm_read_guest_atomic(), by several
architectures' perf callchain and stack trace code, and by the generic
copy_from_user_inatomic_nontemporal().

Split the NULL mm check out of uaccess_should_fail() into
uaccess_without_mm(), and use it in __copy_from_user_inatomic() to warn
and refuse the copy.

Don't use uaccess_should_fail() there, as that would also start injecting
failures into __copy_from_user_inatomic(), which some callers don't
expect to fail in practice, e.g. __wp_page_copy_user() warns if the copy
fails twice.

copy_from_user_nofault() already fails quietly when current->mm is NULL,
and the generic user stack unwinding entry points (perf_callchain(),
get_perf_callchain() and stack_trace_save_user()) only unwind the user
stack of a user task with an mm, so neither is affected.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/uaccess.h | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 8ab24e706a22..eae204f7261b 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -51,20 +51,33 @@
 #endif
 
 /*
- * Return true if a user copy must not be attempted, either because a failure
- * is being injected, or because the current task has no mm.
+ * Return true, and warn, if the current task has no mm, in which case user
+ * memory must not be accessed.
  *
  * Accessing user memory without an mm (e.g. from a kernel thread that is not
  * using kthread_use_mm(), or from a task that has already gone through
  * exit_mm()) is always a bug: the user portion of the address space belongs to
  * whatever mm happens to be lazily loaded, if any, so the access could
  * silently hit another task's memory.
+ *
+ * Note that this only catches a missing mm. It cannot catch a valid mm that
+ * isn't the one the caller expects, e.g. when a file's release or ioctl
+ * handlers run in a different process than the one that created it. Code
+ * that keeps user addresses belonging to a specific mm must check
+ * current->mm against that mm itself (see e.g. KVM's kvm->mm checks).
+ */
+static __always_inline bool uaccess_without_mm(void)
+{
+	return WARN_ON_ONCE(!current->mm);
+}
+
+/*
+ * Return true if a user copy must not be attempted, either because the
+ * current task has no mm, or because a failure is being injected.
  */
 static __always_inline bool uaccess_should_fail(void)
 {
-	if (WARN_ON_ONCE(!current->mm))
-		return true;
-	return should_fail_usercopy();
+	return uaccess_without_mm() || should_fail_usercopy();
 }
 
 /*
@@ -117,6 +130,8 @@ __copy_from_user_inatomic(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long res;
 
+	if (uaccess_without_mm())
+		return n;
 	instrument_copy_from_user_before(to, from, n);
 	check_object_size(to, n, false);
 	res = raw_copy_from_user(to, from, n);
-- 
2.56.0.307.g5fe7bd680c-goog


