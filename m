Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DBD3606A338
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=pQUd1uHe
Received: by kanga.kvack.org (Postfix)
	id 7C7226B05BB; Mon, 26 Oct 2026 17:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751FE6B05BC; Mon, 26 Oct 2026 17:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CB656B05BD; Mon, 26 Oct 2026 17:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 20C806B05BB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:52:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81FFBC07D8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:58 +0000 (UTC)
X-FDA: 85366128036.26.A0A4D9D
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf30.hostedemail.com (Postfix) with ESMTP id CABB780003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pQUd1uHe;
	spf=pass (imf30.hostedemail.com: domain of 3t8vfagoKCCwRbPWcOPbWVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jthoughton.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3t8vfagoKCCwRbPWcOPbWVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793051576;
	b=L3KfdLSTw1lEO367Wb266YSujsz5Kx8vzyGwGz+MHGBfZ1dTy2ICFVtNxw0xEu4WI5pywT
	c7A5LvM1OaWEREWaLj45SzwVUhYGlgEHLOUI3Jpj0dqDmSPDSdoD6zidPefLjLwtU7Q9Uu
	MAH+zbdVlnvCgEzd690vlf93vpsPCOs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pQUd1uHe;
	spf=pass (imf30.hostedemail.com: domain of 3t8vfagoKCCwRbPWcOPbWVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jthoughton.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3t8vfagoKCCwRbPWcOPbWVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793051576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxmWryDZw0sLLhu4Yu8pG4ro8w6TSaSVJ3F6CzsZUrg=;
	b=DKLxdf4w7iuvm82rg1W2IRnXR79eBe1EsaK3S+sQkJh7mhcO0A2KqmVbWhaLDE7kLwPmwb
	5zmY0McNxSy8RuaJ8vAqBZwiZy0rgFQmtn94Oxjvz4ct9g8nPg6FIcVdlBEZCtnKJhhAJh
	bYBoINNWFrtYjRc/K8uImNR39uE/x00=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc7e0321ec1so4539298a12.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051576; x=1793656376; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CxmWryDZw0sLLhu4Yu8pG4ro8w6TSaSVJ3F6CzsZUrg=;
        b=pQUd1uHeMx9B+/5AA38eWld8ryWPyf0IAxCGuCxWcUoQC9OZPkvxL0nHRGLNKsMFii
         9Jqmsj61dZM9eL073gpk6PiMHy+rRwKVdVf+b9yFIguvCcKG5j9DNogUoqBdf2UxvDY/
         MAXGbCvQ/4/BA5Y7vC84EwsYSNuXL4ctj5qaldCvbnJw3m+m4G1RCdizX9I4265lI/u7
         ppDI5VQo7f2/BUVr0fxY6HD/6hQumJN4mBK+PYn/OKkJFpaEwcRFJPMH3Hsqd9TR+Lau
         QCZ5CxWHpwEaz2ay8SH4CK4RYUmHRQdyS7ErJ8fCcKwwZdLWjXEpg4OJYQZ1nmwKQByt
         magw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051576; x=1793656376;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CxmWryDZw0sLLhu4Yu8pG4ro8w6TSaSVJ3F6CzsZUrg=;
        b=SdcDPDZrmO+QRMTY8VGXLvo9rjyXsUbwryss35trKNfqAnMEIVmtbTutBnBZ2sOUsh
         306Gl/zz5E7C4zWUw/V6thuyraWKhA2uuIrByhqaRKbG7+TcLuAaLV2K/EPPlRDzqGlu
         ozH68SgcMElGsmm/U6TxpGdZbPxc7D1U6mRjL1CQY4Kb5OE8+HfeYtAIM8j4N2Ndq1AM
         QX9L1elRCm6GxQ4nhknpIWQRT4Nx1NYwjZ34YX0SWLq5gyuZnmOmkoY5ijARitPM2dLJ
         OPbwuBlnELKDtAxUab0d1aZZyXF5mcb0NKOaWakNPnd+RoAL7BHPlKloV4KmufAe55CI
         qnEw==
X-Forwarded-Encrypted: i=1; AKwUvBzlCc0ABagvOTE6zEkp39H87zFC1zowjv8C/VDw2OMSjPRkv+w29oZCAgMJP0pPwYq0TgGhrihY4Q==@kvack.org
X-Gm-Message-State: AFq9FYKLBvzaHS3GWotuJbjTJ4E+Ijhk5Za60mWWuoBhk9s5IFtJ0FtJ
	SAzLkBXIcO4jHtzJSdgXYHmiscN80uSb/T8/rsBmVYFaRwRSCfjapkY/4Igmezc5WAgUVvWPjpM
	TXY/rP/DP9lyG1o9KUOnLZg==
X-Received: from pjuy5.prod.google.com ([2002:a17:90a:d705:b0:3a8:211b:6c8b])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3b8f:b0:3ac:450a:f9d4 with SMTP id 98e67ed59e1d1-3adeb16364bmr7181921a91.64.1793051575471;
 Mon, 26 Oct 2026 14:52:55 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:25 +0000
In-Reply-To: <20261026215226.3713941-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026215226.3713941-10-jthoughton@google.com>
Subject: [RFC PATCH 09/10] uaccess: Refuse and warn on more user accesses
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
X-Rspam-User: 
X-Rspamd-Queue-Id: CABB780003
X-Stat-Signature: i84ur7jq77ixjtifbm3zush9k3h8qewo
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793051576-210144
X-HE-Meta: U2FsdGVkX19bYgUVFxJnkhRKcxuzPD0bhpXd1haB7EsM6MWp9fLjgiMYDKmBAyrCdl9oqKxoo2YQfG8+jA4yepNwIuHdw09i+hb1Hx5rrux5NMW+TPjJSGgE1pn5Ig+wf53MUXTPc10n2Q4y26T5xXjBfOwUm/kOhkRtPTk1YYCwuP1h7R0YbMekNfDj+NStKFhWoDZZxNhVW50NrZ/UvEqk7CZx3DODDurwE/fuNugw2koN3DIsLAd9iWqnsZ8+JPFo5OgeuxkIeTIF8FWPdGO2cb+26j6pH3op9/Ru1KfkcYF5wvSaiDlajuSZ14i1bJmP8CI0f3IA1FDKb2OKturvTS59n8XpRNC92Y9IuuFDPej3HjIVphLpgpkt+EHkT/GMO6edG+3zgev5/cocgBvwepuvOkd8KUi4750wgBC4i/LO+wsvE/K8RsyJy/H5JHGmunNEJJxYSYTD7yGeWggtNpn3u0NRruzbZHvqQ9rmbmj7CbFMPAouE1DYVmxinTRhpP+baFN4ekSB5jSft1akxAOz/2Yrm2nEXybYtm9NvONAL8Ga9Hdlh6gap5LzRQg903NtY1wW5rM+surm1q4sd1M+dkRIAOQmN6v6ILwg9yD/TfUUseQdU+nAHpAymsva7n29XKV4zUoBI008Op4xi6mpKhebAWsjE2hUBqwtMYBHD0NCN2xw3VO/h4cOBrwhnZ1iRqKpKkisBH4GIYjATvd59OmkxxX/nFzsfrFZ1vas8dJPmYvkx4KZ0bmvX9H6Imi1T/Xvn6+uwJAXU6Bvc+le9lhR2Eh7LdJK6fBGWKyK1eVxtNNAnOtZ9U93mTjUPB08kZzFJ4n/br6ewAeZz2pkjjVbFpvss8aX54ERZaRXDV1O51uyuGgMhCUU/JlDD9FggtEquk/+xD7oseZYKOD3bQEx4dhdRwLFwWkX+YTgqH37q3sZz2LZ3yMrvrT3SLCsxeirINC7g9t
 +dXYTdfZ
 xaRm80d5VKnMFS8lADfBTNcQF1wNauZjitHYKmKm0/UesNNPN0PZyPclAutvyUNXG78xr5m3BYcRD/nvupIWNJqxMQogjmgrXzNsV4BvgNonTfXx/BnearqK/2ZRP6hClUbdMNTuXS34lZAGDal5MAlgIIPVgOfNoM/JldfZ3Bd6mbsfBZbc80F0ThRcxZhbARS1Sg87rBW+VuunqqaFGkkcyIIDnSqA9mbD9Z3fAxgVrMrEjNnmB8+vlRdBH4tZYwvGcBPZbn+vrXrULzf6B4CkedS9bDUX1Hj558bqgwKQLD86lNv4Cxe3lugc/5VrPG66UOZ2IEJl+G1xs9IK+nFD3TUN1lESUcKVKo+dN6luczyB0rOUH6OYhaSWhOGtWlQkfnGNl62aRnBMXcJFKnI3amexVWPg1BgFHJ60wvOxkeck80V+19vzFK4EZuM0s/3zaXXNzJqx9FLm6d37Wq4ZEy6BmwU/XKpn9WdFrOvFTcMt+dLZgrCoybDv3NC3o128R/TGL4t5AkVcsRI5j5bCHGhpVUI++IEh72+WUsC1LJwtRNQa0kZFXbYZ0RSMLoqmo7U/k3XWXtmqimtKdzlNzlTC+4k79jzCZhR1M1fpyLNIG4Uc1/TNE1KXDHkA2IhNH0uR6UUWhyOk1OvEKX79VnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Several generic user access paths don't go through the copy helpers
that check for a NULL current->mm. Add the uaccess_without_mm() check to
them as well, so that they warn and fail without attempting the access:

 - __scoped_user_access_begin(), covering scoped_user_*_access() and
   get_user_inline()/put_user_inline() on all architectures, including
   when masked user access is used.
 - strnlen_user().
 - check_zeroed_user().
 - The iov_iter user copy routines that call into architecture-specific
   helpers: copy_to_user_iter_mc() (copy_mc_to_user()),
   copy_from_user_iter_nocache() (copy_from_user_inatomic_nontemporal()),
   copy_from_user_iter_flushcache() (copy_from_user_flushcache()) and
   zero_to_user_iter() (clear_user()).

Only check for a NULL mm here rather than using uaccess_should_fail(),
so as not to start injecting failures in these paths.

Paths implemented entirely by architectures, e.g. get_user(),
put_user(), clear_user(), and direct users of user_access_begin() or
masked_user_access_begin(), are still not covered.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/uaccess.h | 2 ++
 lib/iov_iter.c          | 8 ++++++++
 lib/strnlen_user.c      | 3 +++
 lib/usercopy.c          | 3 +++
 4 files changed, 16 insertions(+)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index eae204f7261b..7d26d2de9599 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -781,6 +781,8 @@ static __always_inline void __scoped_user_rw_access_end(const void *p)
 ({									\
 	typeof(uptr) __retptr;						\
 									\
+	if (uaccess_without_mm())					\
+		goto elbl;						\
 	if (can_do_masked_user_access()) {				\
 		__retptr = masked_user_##mode##_access_begin(uptr);	\
 	} else {							\
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 21e2ccf1e8f2..a0769874241c 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -204,6 +204,8 @@ static __always_inline
 size_t copy_to_user_iter_mc(void __user *iter_to, size_t progress,
 			    size_t len, void *from, void *priv2)
 {
+	if (uaccess_without_mm())
+		return len;
 	if (access_ok(iter_to, len)) {
 		from += progress;
 		instrument_copy_to_user(iter_to, from, len);
@@ -277,6 +279,8 @@ static __always_inline
 size_t copy_from_user_iter_nocache(void __user *iter_from, size_t progress,
 				   size_t len, void *to, void *priv2)
 {
+	if (uaccess_without_mm())
+		return len;
 	return copy_from_user_inatomic_nontemporal(to + progress, iter_from, len);
 }
 
@@ -296,6 +300,8 @@ static __always_inline
 size_t copy_from_user_iter_flushcache(void __user *iter_from, size_t progress,
 				      size_t len, void *to, void *priv2)
 {
+	if (uaccess_without_mm())
+		return len;
 	return copy_from_user_flushcache(to + progress, iter_from, len);
 }
 
@@ -451,6 +457,8 @@ static __always_inline
 size_t zero_to_user_iter(void __user *iter_to, size_t progress,
 			 size_t len, void *priv, void *priv2)
 {
+	if (uaccess_without_mm())
+		return len;
 	return clear_user(iter_to, len);
 }
 
diff --git a/lib/strnlen_user.c b/lib/strnlen_user.c
index 4a6574b67f82..45709798eb8f 100644
--- a/lib/strnlen_user.c
+++ b/lib/strnlen_user.c
@@ -96,6 +96,9 @@ long strnlen_user(const char __user *str, long count)
 	if (unlikely(count <= 0))
 		return 0;
 
+	if (uaccess_without_mm())
+		return 0;
+
 	if (can_do_masked_user_access()) {
 		long retval;
 
diff --git a/lib/usercopy.c b/lib/usercopy.c
index e2f0bf104a59..9146c729c47a 100644
--- a/lib/usercopy.c
+++ b/lib/usercopy.c
@@ -48,6 +48,9 @@ int check_zeroed_user(const void __user *from, size_t size)
 	if (unlikely(size == 0))
 		return 1;
 
+	if (uaccess_without_mm())
+		return -EFAULT;
+
 	from -= align;
 	size += align;
 
-- 
2.56.0.307.g5fe7bd680c-goog


