Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E63606A329
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=dwzAAsI5
Received: by kanga.kvack.org (Postfix)
	id 445306B05BC; Mon, 26 Oct 2026 17:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A81D6B05BD; Mon, 26 Oct 2026 17:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297BD6B05BE; Mon, 26 Oct 2026 17:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 021566B05BC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:52:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E84BA0862
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:59 +0000 (UTC)
X-FDA: 85366128078.10.5E0DFED
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf15.hostedemail.com (Postfix) with ESMTP id B60E4A0002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dwzAAsI5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3uMvfagoKCC0ScQXdPQcXWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jthoughton.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3uMvfagoKCC0ScQXdPQcXWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793051577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQqGCLRyEFq1Qmw7LfzuGpexsFHiUvTKIyODgPSn6eE=;
	b=a3/rvmoS3WQkMrANN0PhMSpH2BTKmIgGNaPssiE8z2RLH2aAseKexWINWWk2awL4UMG3Bi
	N0nZmeJ95SpeY/fhUxwN9YIXk+NscQrIIBeGK3VeTvUUklzlE9n9e8WlxTaY3XhWDiTXNF
	xMZyhJjASfbYWpMatt4Os4NEgPqyMkQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dwzAAsI5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3uMvfagoKCC0ScQXdPQcXWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jthoughton.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3uMvfagoKCC0ScQXdPQcXWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793051577;
	b=pkRlHmbwyH4kj5K1dIPn9Hha++7j9jq+HoPW6eJ+TMcG2QUkwAYYX3vIRN4/lW8BQin2+5
	/PjpKNq5R13M/QfP0OR+Ib6qOmDbfg5ot1xFuthAD4u0yEsW1Ns4/cEgoUyC214BKhI72I
	2dPYShkAVBuaYpuvv1hwgpXWFwWW7is=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ad98380ccfso5288553a91.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051576; x=1793656376; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HQqGCLRyEFq1Qmw7LfzuGpexsFHiUvTKIyODgPSn6eE=;
        b=dwzAAsI55dzb3ktUeAgZfalSpgqVjMLGf2L+UJYAClUCww6InRtXLrOUNaMlHfX2q9
         XFCyl/d2ZuxMOsKHMozE06YJk4ZCjhJc9qRdghpurZexB3Gz73Y21q+Zk7fh3MfE479k
         orkF1F4bW+WMDBbqQWPrr/OIjYT8Tb8RBqf4lwHeRWtMhVCTSXLT0mcFe51B7g8yv45M
         IToipmuz85TLyXk6aOlOAlXYXs8r5AQ1EzqZj5IYP3oi8Lj17BYYmOe2Py6uBVTCxFrC
         +hw8NQYl7q2jTFbcw3WM5J0dnE3SXAkpJSy5J23/RkoFZKVSw6nIqC6rF5hv3n6Y6ZVe
         SNQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051576; x=1793656376;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HQqGCLRyEFq1Qmw7LfzuGpexsFHiUvTKIyODgPSn6eE=;
        b=LxHxlbrjLiXHVq9vraBXIHRFdrlMeXxh0p38PR3lI59yoFAjnMJ6oDaK9H6iRjOXSz
         z7mxFSZAPrUprJZ2IsRN0Z59IqkWoEnBi4qtOhalG5MD4SA/j7LgY8Owkz5LzP2P7Ul8
         utvxQ3Yt4Fd3dCmgcsDIcPPi53uxOf4QxGLnghmJW89tS1iepetKCFFHpod37c2UXkBN
         5K+NMpUMwrhH/ALtQov9WV45rhhIzh9dOmnBsDMktb/aQzKn++2IRwzb1qoMqMQRTAW0
         hND9hkXxYX6X8zzEpDAuWCr8U3bh9EsnwfTwkh9WJDQ6BNs4pvUw3OKbhK7nd6n6RizJ
         C0eQ==
X-Forwarded-Encrypted: i=1; AKwUvBzaXnCBAb4zP6r1ZU7M5oKBDOuMrsvVmXMGn3XpenOmneNbEcgPdiKd6+wo437Bwl+JItOev2NbjA==@kvack.org
X-Gm-Message-State: AFq9FYKNx0jUFhPKeX0vSYORQ+k8eoxs9vG5yH/aOlfYrotgfimFZ86V
	ztAnR0oVIqlwg2nCeJZHQiMYI7V5mNs/JQt3HXu6qgMxMSmYxT9qnKr5RGjuifSEKFuQlMUb4bL
	6oOpUrlT6lKAl7E7In56Q1Q==
X-Received: from pjbst6.prod.google.com ([2002:a17:90b:1fc6:b0:3ac:989f:b65f])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1a92:b0:3a8:211b:6c8c with SMTP id 98e67ed59e1d1-3adeaae6e15mr7057279a91.22.1793051576336;
 Mon, 26 Oct 2026 14:52:56 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:26 +0000
In-Reply-To: <20261026215226.3713941-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026215226.3713941-11-jthoughton@google.com>
Subject: [RFC PATCH 10/10] uaccess: Move the NULL mm warning out of line
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
X-Rspamd-Queue-Id: B60E4A0002
X-Rspam-User: 
X-Stat-Signature: ga66snrcaee5dciwq774pdb3b3f5hfe9
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793051577-792700
X-HE-Meta: U2FsdGVkX19mLuC6LVIcrsGNMPk6fyIRIk8yPLzFNwFb2P1CGo6ry+/CZM+RFMaS79gXGif0CK126kGioDDSx3OZ9zQH8w1qGeCOLDt4mnavxhLC6SSXRbw2VoPrBAmWPWpOokBgajUeYZo0FrjXovT3KrDmn7DVl5mQoQJQNgHZq3n3m2Lf6jiLqeTURcR5EXKRKvDgVMjHeJLhuuY8pzEldWgfA01xc9lYhoSHpXRSyFrW5uJHc6uBIckqu6J4LIM6IDkOvN/EhQB2xePB14ZqVB9jsEJF8Pu0zSMrMtPOeE7tcpeWqJlQCNd8J3Dcw5vZY6rES/1BOC0UEsZD05WUNEBtvtlN/AXCsX2bec18xMGFZrcEA3wdNpy7HhAaQQ8tUtELp8NXRjKADvbTmCSMDuJTeJPCYPbm8wtUEgAyifmQOCdlx3jblaUK3fejT7vBznUGhRtMBhWBOhU7v6qBxnjAvYUWST4tzCfG3ekaqQAhhPGWkUFFo8ZPxpcgZ68wWzwJOdX+Rt3rvFbuxAIOMJGZtoGZzuh9JqEXtZbywY6JU9tpOk3t6e62spyGnkGFE93OoldeIWbhngt8hH4XwSGhWjQpc6a3kXt+DJLU67tj+Cu3GNUddQWJhbpJk6EuwHy+Z5hR4gJFWBno3yVfcJUfP5tVimHfBGaRO5oA59tzMQPz0HntNricsLWnO+aGMHdJKAvPKgMya071qo4s3rMSdimrJq3EJBjq3iykfr9yBm0chJ6DO4Piz5YAWj/CNHEjfZVJAh+OEbn3vkuiEx5WnRwzoIkT3+bxzAqDEUqk3fw6QLVFFYzsYVrkg1y3ox6n3QWG6ayWrFrwthG9gihl3ZP1XFxBCoOKLDktyBq6yKF31Mo7WTrUc7oLr6F7zqPAeCuRVYj+8gY5g+ASHsJpWyGUn/wiAX0bnqHmUDcdUmmbsdBCxVzURLvyFh1WSbFj8ArpVnXq3dc
 HXRSKlQY
 2I4RV4S/JV/z4p8gJY2Wt3NsC2l1QPY1R29WgBYMKQmfLC4EnCVCYZLDsZsXcQTioXy1sr+AiaT2XzZ21HMPfTzpxSgnzHYxlynHp4EFti9SbBIDryKMC0WiIBeD/HcUap/c+JfVpbet41/U2EzrkYzgnKMCfmAbw+616+sNAWr2782uq1zMuweFESJJiYVYpshZNS6UYad48C/D4eX3eQAeW2N8mvEjsgqE94GVksf2jUY+ER1nuPurcsmfxDTkcX80BSwsocYgP/oKeDZQKftqxKmOffTamxG9yiV34xblTWwRFzsc6hxzy+/+2QhlT/XLVH+SF/JFq9Of084/Wid8T9DOzDX7YzjW/Gn2W2tzWPytHG189w5GUJDXMn48D906qn8Ndc2u5QHs2ubYTlQL6TDFvZjXGFtSD78yiy6oBt9JKu2h1vG1YV/Nf1TqtY3kU0IYVCuzK6r19I2ZIPf8zHVAP48GgTk/jD6b5MBul8uUAYf+D0Y5fOmG4OOMBaPV4Po83yJUmu+qpuNDMSSOl6qIqVUw0MU7nWsib4C/y5NVlZEDatX8Wn6Ce7ZA8cv/Vjxq05ysRBX/4xnPV6IFSMoVG6XKEmbcRU8A7iZAJ8wbYeq6dkuCtrDiD6DC6i6cYx1Q3X5Ea+0a9+s6tAVE0ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

uaccess_without_mm() is inlined into every user copy, including every
copy_{to,from}_user() call site on architectures that define
INLINE_COPY_USER, such as arm64. Each inlined WARN_ON_ONCE() adds its
own __bug_table entry.

Keep the NULL current->mm check inline, but move the warning into a
single out-of-line, __cold function, uaccess_warn_without_mm().

The trade-off is that only the first offending access in the system
warns, rather than the first one from each call site. The stack trace
still identifies the caller, and the access is refused either way.

Compared to the base of this series, with defconfig + KVM:

                     inline WARN_ON_ONCE()    out-of-line warning
  x86_64 total       +5,884 B (+0.014%)       +9,714 B (+0.023%)
  arm64  total      +40,948 B (+0.10%)       +24,609 B (+0.06%)

On arm64, this removes the ~16 KB of __bug_table growth, while text
size is unchanged, as a call is the same size as the inline brk. On
x86_64, the call is larger than the inline ud2 and causes more .cold
splitting, so this is a slight regression.

Signed-off-by: James Houghton <jthoughton@google.com>
---
NOTE: This patch is included for reference only, to show the cost of the
      inline warning.
---
 include/linux/uaccess.h | 8 +++++++-
 lib/usercopy.c          | 6 ++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 7d26d2de9599..6a5b6c2b3388 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -66,9 +66,15 @@
  * that keeps user addresses belonging to a specific mm must check
  * current->mm against that mm itself (see e.g. KVM's kvm->mm checks).
  */
+void __cold uaccess_warn_without_mm(void);
+
 static __always_inline bool uaccess_without_mm(void)
 {
-	return WARN_ON_ONCE(!current->mm);
+	if (likely(current->mm))
+		return false;
+	/* Warn out of line to keep inlined user copies small. */
+	uaccess_warn_without_mm();
+	return true;
 }
 
 /*
diff --git a/lib/usercopy.c b/lib/usercopy.c
index 9146c729c47a..3d547ecb74df 100644
--- a/lib/usercopy.c
+++ b/lib/usercopy.c
@@ -26,6 +26,12 @@ unsigned long _copy_to_user(void __user *to, const void *from, unsigned long n)
 EXPORT_SYMBOL(_copy_to_user);
 #endif
 
+void __cold uaccess_warn_without_mm(void)
+{
+	WARN_ON_ONCE(1);
+}
+EXPORT_SYMBOL(uaccess_warn_without_mm);
+
 /**
  * check_zeroed_user: check if a userspace buffer only contains zero bytes
  * @from: Source address, in userspace.
-- 
2.56.0.307.g5fe7bd680c-goog


