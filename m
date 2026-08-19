Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F100C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863A86B00AD; Wed, 19 Aug 2026 19:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83BAA6B00AE; Wed, 19 Aug 2026 19:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777A56B00AF; Wed, 19 Aug 2026 19:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36C9B6B00AD
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:10:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5D128040E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:53 +0000 (UTC)
X-FDA: 85119565986.19.AC80C68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id ECAAB160002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YIcFcM+B;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181051;
	b=ybUuHWO06sgGlvJ9QfKSpfYDazR6EKToszItcNkU/+QtPVNfGGZypIBMwaMdH4M2gIVIF4
	7X3TPwUxvmmUAHDXlu4VLiXKgExSUXu+z+GPR6eSVKtsCcL+MccqiAcC2ByzdmfF/QKncn
	7VWQrboeAMRXBv4nFc+4Ti1XAFFVE0s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YIcFcM+B;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exIMLt1L2itKU52nrrnmTx3w7rdobSFaYhq0fQ82NCg=;
	b=OynGKuOllqt0RV4CP9HsPCW6TDWYgxkvFUk17srQGW/Ai7UtFHWtfqoZ2qhJ7y4yD55bEg
	eZxKU285gmEeR2HUhHD2Da6uwUSbOP8HHNmhkdqQ9548kxZsvGqanGo2pTxdBYMXmxmF27
	c6/6ytyTGroJMJNBUSuGZxUO1G499Dk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E3FF6187F;
	Wed, 19 Aug 2026 23:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B76A1F000E9;
	Wed, 19 Aug 2026 23:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181051;
	bh=exIMLt1L2itKU52nrrnmTx3w7rdobSFaYhq0fQ82NCg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YIcFcM+B2Z6+seWCqxRl445ZotpwYdYtA/YcfjlFQ645iCYbLw54IVgabn9un7Rgp
	 n8KL75z6q9F6AnRaRWruscBccHOPmPpXuLb805Y+sV3SxTIEmIAIRXfEW7EH7CwW6O
	 d74XPZTGNvKoxXa3OMCHZz7xwa0n9dKECDkRxqZzdujb5rR39JTnHfX/77f23Ga2f1
	 2FhkFcV797eR2AR100h5M8cfm4xRWxs5hGNMqGSQQgcfm5Tmi21sfF4DY/Gk2LaUUg
	 gCrG+pf/UUwHGa1q7WeiJKSmMYSIEDB3i2OFsm8aeVL6hHlKp/3Bb0DPhA/tgPUOpB
	 SAuy26keKCGfA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:27 +0200
Subject: [PATCH v2 10/22] coredump: make the dump helper return bool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-10-ba32dd718c51@kernel.org>
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
In-Reply-To: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=6635; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YahMhih8rmcfyUDHWo+xUJvRT2IOeEUVN31aqub6Kwo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me/z2hA585q9LZ+ahZqn/q6DUXclz8XOfnEi/GBi1
 VfeBYccO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYSvYLhf7aLjP38ruQGoUMX
 E19ckXvr+qf/tOCvn05vOjpnLCqfX8vwT79S6qNCkPyhnBdJC+Y933HyZ0Dbf2eek8skA32WaW/
 /wAoA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ECAAB160002
X-Stat-Signature: abyibntxyi6dzs8fwkwanzwegqot133j
X-HE-Tag: 1787181051-168059
X-HE-Meta: U2FsdGVkX190DfObFdX/f2M6dLbD+GLupAVgQZk/+sZy6AElnqYHDMGa0VBdTabGW+HuBhP48CDHsasBf8TrKjji36m42Tf59vCAYJerbiSz3UKZLwdIDWZ1m0lkpKJVwV/DIRHIf1S6QbW5HuFwF/WntbU0wu9M3FVXhI17M0D+WN3UOS8bs7QGNctk2uWrfD8btwlwP998viqpOlorV2H6kkyibCLjNrJi2EpK6UXzMMdpmJyoMDMgSdQ9JX4Ue7WcZ39l79LuY+QDfWb493ZdXAVK3No7M+WqPMwDfS/hUXT6g+KIIZHFb1ZgD2Bu/4BbWcEpLB3Aed1hQCiIhZWS6XXl0rzmMGa/8kM11a1xkvTXvIMwyE49OfofLX/qXxlizQpqMKfmZwQOOl6CXhV3NrrtwfILTgzdJiUvszwJZZU1x9J4jhsYhgRJTy81+4rPmYi/q/zVpFVipr0hCU1QgrfDhpC/DpQVYVXKChRIL4UcwN3KgVxvOJhWQxtlw4Fh7ryMoq0G0x35HINDqp6bCBsA9L5l+JNaLljSvxKGFk1xuCDwcHKqH3HZDp/rjaHgiv6jcHKLC3p97X4d6RvrfxYPapCiT82u+r8AtHqxLJFOTix9aE7uqI/L51H4E2CJa7IXPSv0xnKX8jh+dTy1PIp6GaAyuEwt792k1iekVCc9nfU4RNNDSSgtAsP+GA6ozXR7CiNzAP7a6eKiyNyehiBD98DQtpGNKVIv0Xy/s7ZwV1VSjd/2wEld27Dyo/wPv6ufJkfpPNcR3HcIU5s8SL+0iLuHHlYla5Mc7tqWBoGzIvUnCjyZoBeWzbs4UPUbw7KX5Iv/RkCkyD2QuR5bwh3FrAv5iTHFgPqv1K1aR9N6/fanqHplJOJlbogM67t0WB+U9TuG59y5+FJcO3vtw0Rl5ebsxHKgbVb/H6jafnUa8C+i2KMO9DeN1vTVpm26LV9kZy2V+jlp9o1
 U9VqPPax
 HQ7MyT3eBbyAezmmNgCTjc2AXiA7TgMYr6XB3ULXhV56RdrEu5ackeGVxBE3tX7PfBQIsWF5Iq1c3+xWf+0zzMwIzaNEqNKkC8q65I/VwseT2bcDRdXrAlUgw+h18rDd6c0HdkrNbv85REb+5Z4QAcAodRx+W6zlCNuOGcPfXcImnkbX4zTrTrQWVhGONV1FpUBJ17ruEZ/FPwmCogdy1TdiOX5rUARa24uRHKNltPbhO66hBqBdoeJwSWn0K971DzMGmd++uDjIPpEGjnpHaDjRZCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The various dump helpers return one and zero. Every caller just does a
boolean test. Convert them to return an actual bool.

While at it, drop the externs.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c            | 63 ++++++++++++++++++++++++------------------------
 include/linux/coredump.h | 14 +++++------
 2 files changed, 39 insertions(+), 38 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index cd36a72be445..d837819031ff 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1215,41 +1215,41 @@ void vfs_coredump(const kernel_siginfo_t *siginfo)
  * do on a core-file: use only these functions to write out all the
  * necessary info.
  */
-static int __dump_emit(struct coredump_params *cprm, const void *addr, int nr)
+static bool __dump_emit(struct coredump_params *cprm, const void *addr, int nr)
 {
 	struct file *file = cprm->file;
 	loff_t pos = file->f_pos;
 	ssize_t n;
 
 	if (cprm->written + nr > cprm->limit)
-		return 0;
+		return false;
 	if (dump_interrupted())
-		return 0;
+		return false;
 	n = __kernel_write(file, addr, nr, &pos);
 	if (n != nr)
-		return 0;
+		return false;
 	file->f_pos = pos;
 	cprm->written += n;
 	cprm->pos += n;
 
-	return 1;
+	return true;
 }
 
-static int __dump_skip(struct coredump_params *cprm, size_t nr)
+static bool __dump_skip(struct coredump_params *cprm, size_t nr)
 {
 	static char zeroes[PAGE_SIZE];
 	struct file *file = cprm->file;
 
 	if (file->f_mode & FMODE_LSEEK) {
 		if (dump_interrupted() || vfs_llseek(file, nr, SEEK_CUR) < 0)
-			return 0;
+			return false;
 		cprm->pos += nr;
-		return 1;
+		return true;
 	}
 
 	while (nr > PAGE_SIZE) {
 		if (!__dump_emit(cprm, zeroes, PAGE_SIZE))
-			return 0;
+			return false;
 		nr -= PAGE_SIZE;
 	}
 
@@ -1257,20 +1257,20 @@ static int __dump_skip(struct coredump_params *cprm, size_t nr)
 }
 
 /* Flush the accumulated hole before writing data. */
-static int dump_flush_skip(struct coredump_params *cprm)
+static bool dump_flush_skip(struct coredump_params *cprm)
 {
 	if (cprm->to_skip) {
 		if (!__dump_skip(cprm, cprm->to_skip))
-			return 0;
+			return false;
 		cprm->to_skip = 0;
 	}
-	return 1;
+	return true;
 }
 
-int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
+bool dump_emit(struct coredump_params *cprm, const void *addr, int nr)
 {
 	if (!dump_flush_skip(cprm))
-		return 0;
+		return false;
 	return __dump_emit(cprm, addr, nr);
 }
 EXPORT_SYMBOL(dump_emit);
@@ -1290,7 +1290,7 @@ void dump_skip(struct coredump_params *cprm, size_t nr)
 EXPORT_SYMBOL(dump_skip);
 
 #ifdef CONFIG_ELF_CORE
-static int dump_emit_page(struct coredump_params *cprm, struct page *page)
+static bool dump_emit_page(struct coredump_params *cprm, struct page *page)
 {
 	struct bio_vec bvec;
 	struct iov_iter iter;
@@ -1299,25 +1299,25 @@ static int dump_emit_page(struct coredump_params *cprm, struct page *page)
 	ssize_t n;
 
 	if (!page)
-		return 0;
+		return false;
 
 	if (!dump_flush_skip(cprm))
-		return 0;
+		return false;
 	if (cprm->written + PAGE_SIZE > cprm->limit)
-		return 0;
+		return false;
 	if (dump_interrupted())
-		return 0;
+		return false;
 	pos = file->f_pos;
 	bvec_set_page(&bvec, page, PAGE_SIZE, 0);
 	iov_iter_bvec(&iter, ITER_SOURCE, &bvec, 1, PAGE_SIZE);
 	n = __kernel_write_iter(cprm->file, &iter, &pos);
 	if (n != PAGE_SIZE)
-		return 0;
+		return false;
 	file->f_pos = pos;
 	cprm->written += PAGE_SIZE;
 	cprm->pos += PAGE_SIZE;
 
-	return 1;
+	return true;
 }
 
 /*
@@ -1349,18 +1349,19 @@ static inline struct page *dump_page_copy(struct page *src, struct page *dst)
 }
 #endif
 
-int dump_user_range(struct coredump_params *cprm, unsigned long start,
-		    unsigned long len)
+bool dump_user_range(struct coredump_params *cprm, unsigned long start,
+		     unsigned long len)
 {
 	unsigned long addr;
 	struct page *dump_page;
-	int locked, ret;
+	int locked;
+	bool ret;
 
 	dump_page = dump_page_alloc();
 	if (!dump_page)
-		return 0;
+		return false;
 
-	ret = 0;
+	ret = false;
 	locked = 0;
 	for (addr = start; addr < start + len; addr += PAGE_SIZE) {
 		struct page *page;
@@ -1384,7 +1385,7 @@ int dump_user_range(struct coredump_params *cprm, unsigned long start,
 				mmap_read_unlock(current->mm);
 				locked = 0;
 			}
-			int stop = !dump_emit_page(cprm, dump_page_copy(page, dump_page));
+			bool stop = !dump_emit_page(cprm, dump_page_copy(page, dump_page));
 			put_page(page);
 			if (stop)
 				goto out;
@@ -1403,7 +1404,7 @@ int dump_user_range(struct coredump_params *cprm, unsigned long start,
 		}
 		cond_resched();
 	}
-	ret = 1;
+	ret = true;
 out:
 	if (locked)
 		mmap_read_unlock(current->mm);
@@ -1413,14 +1414,14 @@ int dump_user_range(struct coredump_params *cprm, unsigned long start,
 }
 #endif
 
-int dump_align(struct coredump_params *cprm, int align)
+bool dump_align(struct coredump_params *cprm, int align)
 {
 	unsigned mod = (cprm->pos + cprm->to_skip) & (align - 1);
 	if (align & (align - 1))
-		return 0;
+		return false;
 	if (mod)
 		cprm->to_skip += align - mod;
-	return 1;
+	return true;
 }
 EXPORT_SYMBOL(dump_align);
 
diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index dc7a05b1bb0a..943bddfb22bf 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -43,13 +43,13 @@ extern unsigned int core_file_note_size_limit;
  * These are the only things you should do on a core-file: use only these
  * functions to write out all the necessary info.
  */
-extern void dump_skip_to(struct coredump_params *cprm, unsigned long to);
-extern void dump_skip(struct coredump_params *cprm, size_t nr);
-extern int dump_emit(struct coredump_params *cprm, const void *addr, int nr);
-extern int dump_align(struct coredump_params *cprm, int align);
-int dump_user_range(struct coredump_params *cprm, unsigned long start,
-		    unsigned long len);
-extern void vfs_coredump(const kernel_siginfo_t *siginfo);
+void dump_skip_to(struct coredump_params *cprm, unsigned long to);
+void dump_skip(struct coredump_params *cprm, size_t nr);
+bool dump_emit(struct coredump_params *cprm, const void *addr, int nr);
+bool dump_align(struct coredump_params *cprm, int align);
+bool dump_user_range(struct coredump_params *cprm, unsigned long start,
+		     unsigned long len);
+void vfs_coredump(const kernel_siginfo_t *siginfo);
 
 /*
  * Logging for the coredump code, ratelimited.

-- 
2.53.0


