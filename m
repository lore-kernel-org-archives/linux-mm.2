Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC56606A332
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ne/rp042
Received: by kanga.kvack.org (Postfix)
	id 35A6E6B05B9; Mon, 26 Oct 2026 17:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4516B05BA; Mon, 26 Oct 2026 17:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137926B05BB; Mon, 26 Oct 2026 17:52:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D77D36B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:52:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3AE1A843C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:56 +0000 (UTC)
X-FDA: 85366127952.11.91F3ABF
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4488180004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ne/rp042";
	spf=pass (imf02.hostedemail.com: domain of 3tcvfagoKCCoPZNUaMNZUTMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jthoughton.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3tcvfagoKCCoPZNUaMNZUTMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793051575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPD1DyegWTB9pcC/MXMtMDXG2VZzMQeq5nacp4T1bXw=;
	b=Lb10nN2W+GNM299N70WJb3XV0UT38W5QZx8PRGG3ZFTW/bQAce3bxFSusGMqsn55/T7h8b
	MfEP9NhoqnfoIZj2kMiP3aMMT00tYxTzR2Dox/suHzNtNtFItykkAOKdUD6vpzARgwaSjx
	Tdl03XY8kF2X/Fz34wOFXwZ4CE/0H0I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ne/rp042";
	spf=pass (imf02.hostedemail.com: domain of 3tcvfagoKCCoPZNUaMNZUTMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jthoughton.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3tcvfagoKCCoPZNUaMNZUTMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793051575;
	b=0KH8YRKuhKcbzmZ/BHYt2wUKOIt452FtTbr1w5qa+oEaqNnByNWZghRxIb/4tJakjZ/Ig6
	x7SoYmPHwPT/lmo21IJBL6aeISLKkUxhoVYd3TAKb/I25huXQVM0nUV4bBBNxDLfh3h9Vr
	wSFavI4pEaOClzRzMR8/GH3Bv8NLjWk=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3aaf955db5fso5549287a91.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051574; x=1793656374; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UPD1DyegWTB9pcC/MXMtMDXG2VZzMQeq5nacp4T1bXw=;
        b=ne/rp042/l5TVp6Fuc+LsWZU4yutTqen/3hkPs8iNz0BXYZyMVHxOzYhDSnEtp23xr
         VPzn0+r9cJgxvBORJXPONoN07P3Og83WpSTju9KpnLPts8LX4pOaCCotMCJ43psgZmo/
         wy3Z6136dqCdSprAx3tDeU6cggw1lUE2NYDuN1dTWnt1RARQjar2f7tcBbgbFaw/VMVP
         h0u417qXowKJI5SbTnwU+EsJ745apWD29g5HqdDHQvATLypM/hdjFCpRq6eyzEO2iT39
         ypHPPjDs26BuCgW1hpVP4T3HhEbF2r+61eAuvmXHO0IR+wZJ2abxT1Z4F9j3yCpsZEXQ
         JjeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051574; x=1793656374;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UPD1DyegWTB9pcC/MXMtMDXG2VZzMQeq5nacp4T1bXw=;
        b=zr00Dg+nzhTJ3ksZNlslmFjk5k8UVnUCkAVDKPDl+xbmHGK6OousTSqx2UtMKca1SH
         aFWqkz7HKfRWYTvwPko0Lkvw6TLwJhZi/3wf5uhnZi3WZ3lUpZW9sTJJO5TtpqPeyI2P
         waegCUHAWGesoM/42hN7uaKbNeb/iJQ+tL/KOny66b9KIMX7625ERn1a4S4BPVBu03Jw
         ozbgunp10HtJJXg2+0HhyaPCmmvDjDhn5vEfK3SiO/H/JnBcW+AdwO2Bg1+tjVwgHNyD
         xdcFEI4RzWIqtPpij49GXBT+NWRoivh7kaV0SGjzCBkxSCMgrAW6cEiSzVmnfu/64V/i
         mAGw==
X-Forwarded-Encrypted: i=1; AKwUvBwJT36P70tYF7hy+yeYXBITDPEEZYFvhf57oZtpXxYaaNGUM4giPx6s/XpHiT8OzRO8ZrqpTPjwvQ==@kvack.org
X-Gm-Message-State: AFq9FYL0dvchh86Enx1KrtwClA5/SEk2R2Izy7c3dTH+vCSxorrva9VU
	MPYf4tcpnn7CwJTWxeBrViRWUMVPWr6PuKol4uMdL1+HKKne9J1XNRu8HxpSQSvE7xe0zG5Whgj
	93VsC8KpDNDCfPe3V4WwJ+g==
X-Received: from pjyp7.prod.google.com ([2002:a17:90a:e707:b0:3ab:c373:bf62])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3e4d:b0:3ac:403d:6232 with SMTP id 98e67ed59e1d1-3adeb120167mr6870324a91.55.1793051573802;
 Mon, 26 Oct 2026 14:52:53 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:23 +0000
In-Reply-To: <20261026215226.3713941-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026215226.3713941-8-jthoughton@google.com>
Subject: [RFC PATCH 07/10] uaccess: Fail user nofault helpers quietly when
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4488180004
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: i7thgoen4b3r1phuxtt8u98s6pt8i3rn
X-HE-Tag: 1793051575-468285
X-HE-Meta: U2FsdGVkX19t+rc78JjiQWctrHGTnBEMZh0jgda+pGNpHwl/zfPfJvOpOPnrptd4F4rAztm+rmKbIyXFpZCLgHl1F6c4byZCRREFPJInJWG72gphpZNqnTP4U0qVojicQsCLKlanQ+v+eUjgu2qzLVk4ouOvnd/KAEITV8gD1KAlqLKgehiFRLlKd5tiVgsEACQ6rIP63VbIInBZK7F6O9ABpTMewFM64rHLY9sAeyNLvfNcGnZs3fKz5lcOtnemunC1cirBORBmFSqZNBN938BV2QfjaISCzDTrfHGnufLTuO8M6NHOCUJHyWV/cXfIljfHy/5Qu5ewT7VENAGoWd7sLpcACNlzgi/rrfeScAqHB+tNmNf11UjTt7MArRzFOkdw2qYJrr/7Pczj/FuWxsguCJx2ZuxF3sMr1CdAgFeGgD1DOtybAfoX5GajZqsHbAGGd4NHDr3ISiY+9wC8tMJYto9T/uoDHW4EmrG0U1QQVVImuI8T+p/1G58ag/h7slv1kjklHJhW7qOqzTqdupnRE8DDYVS+26qv2vJO8Fr+ohsBSc3t3NQ7KZHHPR/T3UaJsraZ3IigNx58SW5YGeUnr38Pur0QRR58afW4+wC9xt3iup6OhRGAyPVU/BGBlEmmQs0An4cX9Mm0NJNRnjrISaFtmdXniV36M5w42yAxW5HtKPEB9y4IArvJ1PIrOGIiC+ZU3H16pBfLUgcBI0w7hvoUNqvi6Q61cfplguhsX/m4X/rJL2/A2C65njLurL+d2FJ0pw3DhQ0/X7YTUN2UFhlpVyqhsQaJU5zp3ZAGEeOlkyAv6Ce9da5k9Opqwf3YHG4va9lGGlENZVAHjjr4dw3IP88jRZCQLEe8f3YuEB3bdWgs2usSS8F5rB+m4I/dhzs1tI2WpRNaRe2saxabPRthynP4T9W7ZINrBvdoFjAKeKtyXRMNZ8BhzaWrZY0D1xYWJkRr6nJ6bod
 DlsmwdGX
 c14P3j2dAlfXe7eJzALuUNXmc1X3HdlTkWg2B8GrmcuCO3M6VclX26i2xQ6srspUA6GceVjbeF7F+B4g91rGsnRfGsgww9XGef6rTh6K3+IX6B7vhOpkxltdXE8Q/cfKjNeg9pvw2sTqJ2Ugf0iKDL5d+7a8XSUsCJuwdPtYw5dE8OEfYoI+P63N1Q9UaiyubxlCfvQ13SFv+3zYdhDPv1DD5yncla/VXPsrqWUz96vgDeTKazQ/VZGtigi/zYeBgrjNwdWpHt26c3riTIsma0HbEmoy/kOtRdPV95EXBB/N3CR70/0hLYR6+U2Hx+cktf63B3KB9da74wl8jiJbz6HsU67rL+/a1WSKKx7B3Hh+GAA+whvNQ6BuKDTJ47sP9ao1twgBMxRtPuRRxnMKouGDMzcW6UoGaCzcxVhKhimAmRBSsbOJY48PMYvD3hv4lGyaoZgFb2X+IU4Uo/ajQEhhktDmwNJDHYcqy5pLQjBmKVfTAerPGiS+Tey9AyJF4O1+XPIRKzM8pj274SdsA9tYlIleLsy6EmBuyBScPDd0Wi50YBcSStk0Ko7J5KiOvTymIDaBVBbmbT3hCOt4vawJk7fdt9+1aqPZyzGAFKlrQ6q/qkow8pGp4zeSNlY0ifG67czc05LVebTh9aaVUAK0qGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The user nofault helpers (copy_{from,to}_user_nofault(),
strncpy_from_user_nofault() and strnlen_user_nofault()) are meant to be
callable from any context, e.g. from BPF programs, kprobes or perf, which
may run on behalf of a kernel thread or of a task that has already gone
through exit_mm(). In such a context, there is no user memory to access,
and the right answer is simply to fail.

Since the previous commit, the uaccess helpers they use warn when
current->mm is NULL, e.g. bpf_probe_read_user_str() from a BPF program
attached to a function called by a kernel thread would now trip the
WARN_ON_ONCE() in strncpy_from_user().

Check for a NULL current->mm up front in these helpers, and fail without
warning and without attempting the access.

On x86, copy_from_user_nofault() was already refusing such accesses, as
nmi_uaccess_okay() returns false when current->mm is not the loaded mm.

For the same reason, make copy_to_user_iter_nofault() use
should_fail_usercopy() directly, leaving the NULL mm check to
copy_to_user_nofault().

Signed-off-by: James Houghton <jthoughton@google.com>
---
 lib/iov_iter.c |  2 +-
 mm/maccess.c   | 17 +++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 3d6ecb50d778..21e2ccf1e8f2 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -33,7 +33,7 @@ size_t copy_to_user_iter_nofault(void __user *iter_to, size_t progress,
 {
 	ssize_t res;
 
-	if (uaccess_should_fail())
+	if (should_fail_usercopy())
 		return len;
 
 	from += progress;
diff --git a/mm/maccess.c b/mm/maccess.c
index 486559d68858..678bb6165b39 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -121,6 +121,14 @@ long copy_from_user_nofault(void *dst, const void __user *src, size_t size)
 {
 	long ret = -EFAULT;
 
+	/*
+	 * The user nofault helpers may be called from any context, including
+	 * from tasks that have no user memory to access (e.g. kernel threads).
+	 * Fail quietly instead of tripping the warning in the uaccess helpers.
+	 */
+	if (!current->mm)
+		return ret;
+
 	if (!__access_ok(src, size))
 		return ret;
 
@@ -150,6 +158,9 @@ long copy_to_user_nofault(void __user *dst, const void *src, size_t size)
 {
 	long ret = -EFAULT;
 
+	if (!current->mm)
+		return ret;
+
 	if (access_ok(dst, size)) {
 		pagefault_disable();
 		ret = __copy_to_user_inatomic(dst, src, size);
@@ -188,6 +199,9 @@ long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
 	if (unlikely(count <= 0))
 		return 0;
 
+	if (!current->mm)
+		return -EFAULT;
+
 	pagefault_disable();
 	ret = strncpy_from_user(dst, unsafe_addr, count);
 	pagefault_enable();
@@ -222,6 +236,9 @@ long strnlen_user_nofault(const void __user *unsafe_addr, long count)
 {
 	int ret;
 
+	if (!current->mm)
+		return 0;
+
 	pagefault_disable();
 	ret = strnlen_user(unsafe_addr, count);
 	pagefault_enable();
-- 
2.56.0.307.g5fe7bd680c-goog


