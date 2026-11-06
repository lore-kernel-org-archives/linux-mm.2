Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E4D606A33C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 20:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=DA+zqU77
Received: by kanga.kvack.org (Postfix)
	id D41176B05B2; Fri,  6 Nov 2026 15:57:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1FED6B05B4; Fri,  6 Nov 2026 15:57:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2DDA6B05B3; Fri,  6 Nov 2026 15:57:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8922D6B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:57:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 18F21801DC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:57:48 +0000 (UTC)
X-FDA: 85405905816.05.28719B0
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf09.hostedemail.com (Postfix) with ESMTP id 58809140005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:57:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=DA+zqU77;
	spf=pass (imf09.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793998666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nBmoOdVLhjxzW9Kafv3OvCDFQruGaI/hx6SsyCcZev8=;
	b=repcpkVvOJEquhjCVyXQ4QN0c7qlCbTJL9Tg4axjylbfmJdZohS27jG2CaoEKnEYDwA0Uu
	h+R4WKfMmT/x0c4GF5BD3mbPQZVwOxjPL6DJew3qq1eyLq2BrTm5CoVjS6RJUU+uvKyYNN
	SubVf162gZuFrVp0zrZEAhaN+rXZyUc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=DA+zqU77;
	spf=pass (imf09.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793998666;
	b=AzEe+NfZRpX5wKyVsZzf6nnd50f4MQqrRsqxuvZdmUMBP+YDe/is55gZkPsmxjrFcnigi8
	glkv6rRz/aRTvUGZ/BwycjEyF7eJHTFL5kCgCvn+lDaOMVUF3OMfid7v3i4X60OIuBL4lV
	9EzMbbhi2d8HavHy1N4ykjbSKNQ/DH0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=nBmoOdVLhjxzW9Kafv3OvCDFQruGaI/hx6SsyCcZev8=; b=DA+zqU77k8p0jFgv6g7
	01srGmpcj97AEgA8B4oU+0ViZRy9ctkLJmncbwxOCw94wTnUg6jW8LlwuNkNd0/8b3aPHRK1vyFUV
	iP1rL+761svdtn94+zqSiYJnMeg4vI0/D6WPPQaI5KzCvHTHUqeD2ymcG2V4lh7TBf/WNf9Q8rwcI
	k8ptJOqGLGoMktwudi32EskkA8AN3s/XDBTLNTF0lycQZEycGWI/Kflb6OiSZYooMBAerOyNQsR85
	AWycnYNJgtBBr/ki6vL0ThdqkWFtYIe0tVbbQj6brzv9F78QtL3dV140H4Enxi032mIcszl5pR6Be
	1gSnaTB7BXfINQA==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xPQwI-001xD7-2m;
	Fri, 06 Nov 2026 21:57:38 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Fri, 06 Nov 2026 21:57:37 +0100
Subject: [PATCH v2 1/2] binfmt_elf: return the real error when program
 headers cannot be loaded
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-b4-prep-vstor-149847-binfmt_elf-enomem-load-elf-phdrs-v2-1-1c8b7b1dae5c@virtuozzo.com>
References: <20261106-b4-prep-vstor-149847-binfmt_elf-enomem-load-elf-phdrs-v2-0-1c8b7b1dae5c@virtuozzo.com>
In-Reply-To: <20261106-b4-prep-vstor-149847-binfmt_elf-enomem-load-elf-phdrs-v2-0-1c8b7b1dae5c@virtuozzo.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, Paul Burton <paulburton@kernel.org>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4140;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=8ytuiULsyJ8GCK6BkCTcVg0Z22pwFQJoQSqUN4jBPwo=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq7j9FY6+VFr8UYcnA53WtID4/c39wnuObpLQLG
 xhEUW5OItOJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCau4/RQAKCRBRlgpH+WFc
 KhN1D/9zSWJWURpegXxA67uIcvpjYExl0kS8iPabm4rqY97wMLh1JA8y7V6A2jX3rqIIUxwTA/r
 Pq/LdLGg772JYqnvmyqfmbbgKBpiTh6ZbT3P9kPD5dOFP4hxVANmGBZi3eRsdU80UuVIHb+6y3Q
 qFYCAXliEb0PppssyXMyUpZIX8Gqw8SvzhQK72AA2NgEmNgkoqBKxxIOtZRaT8ikkWPB2FaX1mD
 h8Ygg27nLDTQpCEZpqMVctCcvM4B6pX7MBMmjavPy8CkqC3RkZzqFvvpuT0AAINcT/FM6w/Szfj
 7wGZ+dz2mnLr7NrEocHTgrm4oHXI/vlq+5wZCk0ZrzxixkcSq0nUpph5itTOIDvQVNDXyUMDS90
 9VLc5aCza7Hjggtl9xidiU6AFN1tgHFjiJlDsM+4gfDSDv1F3ckutuqCPDxomSErS/2/uuKy7qB
 W7ZHpclZO1a2v8VDQgqpDFqXsJuAYbXF7c+r5x2bvpR39onCQEde6pfA3h7FzTdgnfRtHXBK94B
 rLsEutGcInb0qSzSpoSZyi859fGPSLngq6nF9l5j6PL3bWMfm4SspA/snxe5k+HSuDTtjEbYRou
 05e0fpYwm78AlMyDZxy/aQZr6GKU8ZFILSUJJFq+/+63HdMKcWU/KifjyQOTXCvUbH2+8cylbrL
 V43JacsTV1QE3XQ==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Stat-Signature: e45jqc4go9ok5o34cttkmj95oqjs1guo
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 58809140005
X-HE-Tag: 1793998666-757431
X-HE-Meta: U2FsdGVkX1+gXG6aL/nxtDNaEXaGvfS965z/uumqHrWF9nLm2k6cz92Bh1jrWbbKUAWs0if4SY1lZldB0sCmawxbpRgEVaGbs+7jesZeYaBypQuUIAYJXkkdix/DesDpbnD6eet3524DwHK3euCzIyXtG+Tjl3TshKdoUbLUki53FzdYcjprKhtv7b54bprXKclAQ0UYU5+w6W85s/BZCoEbRkI04z4FHAXQKtpnFM6KSWPRDhtuR4V1FaavXa6VrIHe1UQiakff0gknp0uS5vgkXCHSTJCd4yJWDAzhNOgxyXx0RY62+iKj6opZZvsVmV/cm/tKwfcrwUl6XJi+i5XkW0RrTL1x828WFNzU7XoOEac/jLeEABZ8MfgldJB8/jIe3FYOeh6hZ0ve/vjxFAXiwJxPElBsIXyhVvQQpU+NKyELsS8zwU/j37eo8dWB0Zykl1YxyAXPD/XvOFpYiJPqXQtFNmvcfdCB0cTJE/084Qph3ehMGwXbymTb6G3hYL6oAZWrkAbEO/xTojxmHDShMtY3/s/2BPc5ifWoD+ivXKQPxAEPRax9XhNhcWZoACpMuEQE4TMVVZipkJZ37PFhM7w9I6uMB6kfrAxUk56GZRSsw1UzgNR2vgGvrtaiWIUUaW+LMcAXPPz00/2ONHmr5cEkc/ipEXFPRWLMCzMB4h/NYVSKRJLd8tMnefthcAgLsQBkObzuAxJSrkappZO+niYG5wfCt0KZcC9xO9VoaWWrkvPT5AwGasdh0xOAJAFC3bts1pgMQ8+i+k1fDatnNlGhjA+AF5x6rgl6JadwILsh1yBb6qlSnG2shZ83jZkURWmwXvQwLpbYfQG23OfQawaqvy4bcxiuwmEUGpU1HOte0HfwYoxyae8fhBGq4mGIJnbl/kI1+w6M17kjzrzYwjLc0BcOv5fXs6GxnJQTMu2xRZTaffwSWGX/SKuzSuCzdjz8CIPdlCNnE0K
 QjmssUet
 EDybLVyUVng8Ots7tUGtjwA/z1klvXJ0R7NTlzcMs2uXkPWAoXFEebXqi3Cbxpc1p0PpCbXJ9j9wVt5ZLakdpS4ZxwJs2yMPdYLtJxW1uVxaE3d99/YqLq27rOHJjN+pXwO4KPfFj1pP/KozBkQ1D5utE3N1Mk28sKGz7PA1H6saGt1wA7QAisBQG3oFgeRun7O5culSzgOkv34M6269yuHS77yvVR3S0eoLZv9N+OHcTtB4xEh+1WXExXP/bbNc38HBLSpOkrHdeiSaot4DgHSr4W6FmrlcLgLnY3SdLG0SQPJkDnnXiSwD7OQgRl34R3XNGVjvH+UsA1Qr1MbGg/VHDrT1KG6FC2WSCWEMwUhXwa69hMf+yWt9azvE8fGXxS5utwnKc8ealGe8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

load_elf_phdrs() returns NULL on any failure, and load_elf_binary()
turns that into -ENOEXEC for the executable and -ELIBBAD for its
interpreter. So a failed allocation or read of the program headers
makes glibc's execvp() run the ELF file with /bin/sh, and for the
interpreter reports a healthy ld.so as a corrupted shared library.

Return an ERR_PTR instead:

  +------------+------------------------------------------------------+
  | error      | when                                                 |
  +------------+------------------------------------------------------+
  | -ENOEXEC   | bad e_phentsize, e_phnum or e_phoff, or a short read |
  | -ENOMEM    | the allocation fails                                 |
  | read error | kernel_read() fails                                  |
  +------------+------------------------------------------------------+

Malformed files and short reads keep getting -ENOEXEC and -ELIBBAD.
The table is read with kernel_read() directly, as elf_read() turns a
short read into -EIO. An e_phoff past LLONG_MAX - size is rejected up
front, so that rw_verify_area() does not turn it into -EINVAL.

Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 fs/binfmt_elf.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index bf7f8f47548d3..ee44a354c7243 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -512,39 +512,41 @@ static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
  *
  * Loads ELF program headers from the binary file elf_file, which has the ELF
  * header pointed to by elf_ex, into a newly allocated array. The caller is
- * responsible for freeing the allocated data. Returns NULL upon failure.
+ * responsible for freeing the allocated data. Returns an ERR_PTR upon failure:
+ * -ENOEXEC for a malformed header or a short read, the allocation or read
+ * error otherwise.
  */
 static struct elf_phdr *load_elf_phdrs(const struct elfhdr *elf_ex,
 				       struct file *elf_file)
 {
-	struct elf_phdr *elf_phdata = NULL;
-	int retval = -1;
+	struct elf_phdr *elf_phdata;
 	unsigned int size;
+	loff_t pos;
+	ssize_t rv;
 
 	/*
 	 * If the size of this structure has changed, then punt, since
 	 * we will be doing the wrong thing.
 	 */
 	if (elf_ex->e_phentsize != sizeof(struct elf_phdr))
-		goto out;
+		return ERR_PTR(-ENOEXEC);
 
 	/* Sanity check the number of program headers... */
-	/* ...and their total size. */
+	/* ...their total size and their offset. */
 	size = sizeof(struct elf_phdr) * elf_ex->e_phnum;
-	if (size == 0 || size > 65536)
-		goto out;
+	if (size == 0 || size > 65536 || elf_ex->e_phoff > LLONG_MAX - size)
+		return ERR_PTR(-ENOEXEC);
 
 	elf_phdata = kmalloc(size, GFP_KERNEL);
 	if (!elf_phdata)
-		goto out;
+		return ERR_PTR(-ENOMEM);
 
 	/* Read in the program headers */
-	retval = elf_read(elf_file, elf_phdata, size, elf_ex->e_phoff);
-
-out:
-	if (retval) {
+	pos = elf_ex->e_phoff;
+	rv = kernel_read(elf_file, elf_phdata, size, &pos);
+	if (rv != size) {
 		kfree(elf_phdata);
-		elf_phdata = NULL;
+		return ERR_PTR(rv < 0 ? rv : -ENOEXEC);
 	}
 	return elf_phdata;
 }
@@ -864,8 +866,10 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		goto out;
 
 	elf_phdata = load_elf_phdrs(elf_ex, bprm->file);
-	if (!elf_phdata)
+	if (IS_ERR(elf_phdata)) {
+		retval = PTR_ERR(elf_phdata);
 		goto out;
+	}
 
 	elf_ppnt = elf_phdata;
 	for (i = 0; i < elf_ex->e_phnum; i++, elf_ppnt++) {
@@ -968,8 +972,12 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		/* Load the interpreter program headers */
 		interp_elf_phdata = load_elf_phdrs(interp_elf_ex,
 						   interpreter);
-		if (!interp_elf_phdata)
+		if (IS_ERR(interp_elf_phdata)) {
+			if (PTR_ERR(interp_elf_phdata) != -ENOEXEC)
+				retval = PTR_ERR(interp_elf_phdata);
+			interp_elf_phdata = NULL;
 			goto out_free_dentry;
+		}
 
 		/* Pass PT_LOPROC..PT_HIPROC headers to arch code */
 		elf_property_phdata = NULL;

-- 
2.43.0


