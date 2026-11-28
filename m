Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46398606A33A
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 06:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CYB7cesV
Received: by kanga.kvack.org (Postfix)
	id AF35D6B05BB; Sat, 28 Nov 2026 01:52:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7CF56B05BC; Sat, 28 Nov 2026 01:52:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9930C6B05BD; Sat, 28 Nov 2026 01:52:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 648CE6B05BB
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:52:18 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9150A0613
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:17 +0000 (UTC)
X-FDA: 85483608714.19.A096220
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2289214000B
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CYB7cesV;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795848736;
	b=HN6rJUnshK47D/ELbfQOGXwwd+0+gA5HD2L4nbYUpBVSJIdyDWEXWcDW21L4qnpL/hw85m
	03BL7uTKN1BB3PpXHjvr4TclCBN0HSWRSNsTIXgLiVGpOTbzfYwO5p9UNBU1x5r8Sanb6R
	R6HTxvBuAt5JHj5TpTFlnNZ4KapXE/M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795848736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=a+0qJ0ki6I38K0Pp1ZZMYoWTUSwwIpZRuywtK0CzQQM=;
	b=V54rSs8KKBjyw0q2QnsasjXmRCG4vQcQTmF3HdTtVESMo9tJyVCnyz+xQIK+ckxZNDdstO
	quWecljeMD6VvtYnr4Rn9RMbYRniZScVJxUnx/pMWBEpqtMUQUcHzXYTA4TSussEVVKwFz
	Z/TEQRzFgracQbEuP8AW8E17p4VY2YA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CYB7cesV;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BFB644305;
	Sat, 28 Nov 2026 06:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD561F000C1;
	Sat, 28 Nov 2026 06:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795848735;
	bh=a+0qJ0ki6I38K0Pp1ZZMYoWTUSwwIpZRuywtK0CzQQM=;
	h=Date:To:Cc:From:In-Reply-To:References:Subject;
	b=CYB7cesVfofR5YSlJLhbtgBluyZvWvRkNbxZD5qIq3Cah4cg8LWBk/iXQvbAzAsUt
	 TkddmWmVMh+dFBQ5IAEnm7axNS/p8YcmyzHFxSxt2RTk99CRmxKmoSxvTEh+MS+zBs
	 Impta2Lf+cfkvm6YWUNq6npKEIbMsWgL7Di2Wb0g=
Date: Fri, 27 Nov 2026 22:52:14 -0800
To: Kurt Lin <lylin1023@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Amir Goldstein <amir73il@gmail.com>, David Hildenbrand <david@kernel.org>,
 Eugenio =?utf-8?q?P=C3=A9rez?= <eperezma@redhat.com>,
 German Maglione <gmaglione@redhat.com>,
 "Liam R. Howlett" <liam@infradead.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Miklos Szeredi <miklos@szeredi.hu>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, Shuah Khan <shuah@kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
 Vlastimil Babka <vbabka@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <1c93b263b19d4465899bb81efd62bcb3.8@linux-foundation.org>
In-Reply-To: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
References: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
Subject: [PATCH 8/9] selftests/mm/memory-failure: write the whole page-cache test file for OMFS
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2289214000B
X-Stat-Signature: niz65apzf3fw7iz8ifb4c1ah3o79t3hd
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PP_MIME_FAKE_ASCII_TEXT,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795848735-870247
X-HE-Meta: U2FsdGVkX1+x3GhaBrhNZt+bWwUk0cMrPP5+8Zy2dKdtnyGuvhWQP8qc8Zvmw0ZaKlK9vnzmqCOlE3GdcUMESwZTGFKPW07G31snr+lWrWLy4R8Q4VymDnVmHUcMChn69BFiVA+QKjaThfs5tBxtgPqpK4OMLKhDD7FbQbd5ihEDkKAksIgouAZhX3ld+snNo136wZtFCMDs+Ir1A+6NACquGYkUDxLJShsJbeEn6QgkF5UOf0AYPl7pGUf/TFTQ9SEsSlFHS7+/nFXveLHAPDGWFEsfqxjk+9nYG/Kx+HO3WPM8oGCgf1HGpkTrwps3IVKWURKYNZDhao4fRJSK3OTNW0hL3qwlYVvqJ7taZKxEQDnSp/6PIWHoZFB5mFfW5rowloY6Gu7MjgCD8gsBYc2cYYInZw9jECDXZjIkZx2ySIczbpL5wbVDchoTBwmdjLXGMgo1zJXS4GQVmVAOdf+B956vzL4es9zM4w2GyUQQzg9wwmsFGCVjdt7ggDNF7VsulTcfDzYL18EJbw6rkfturhoCQ7ipqbXQeaP0aQglLZCgCXbEN5gYVe+6ad1jHb2n8ZBJ3NbTif/FJsT3XKsnnJKLD+s+b/of5KzZBIIO9yZkkVIT6TSJN47wY/z+Uq8xsU2Ek0dpPDbTuD9XLgNfA6S9BDbduQ+wjmXmm9FO8psbtTsMnbTaJjF4aM882x0tUxtJDjPrCVAlUM8x5voJ4Hshg3OOAMNm2qwCupPI8aGp2aqCD9g5l/Rychjmw8m6LvHhtHZXWaHuKxsJvfxCDM0lrHuoqLt5CZ+MYdHXpFxp5Ko45mp8GzkRAzAWEiUBEh0KLrOTIE3OlYZ8g4wGg7GpBIB2ThwoumwIMOK1ZfCJ60uY/CfipgCvWEGVqIeJ8JLsxoTPdxzdQwi4x1XKeMx2XwbdgkcpS26Qpe30TjmR3y/OGfquZPATM3IGJi5MUIeCMEnbUj77GPk
 I5oyermI
 cEawwu0sWjmFTKMDN2fhXw1thrKL5CSpDoLBgrXfis1KHwThMOQ/PKyJyI06qI8vOGWiCEm7Rm4+J8TO2Yt44QmP9N272eVmMfg+fOfEtoduVz7caOk/sK+9Z2/+L+z+GAAlgDidmZ6iGQzV4XZ7C8bpS2ZYy24jd7Sw/jyKzoQ1whzG8cMpW+o+k954XEY+x4O0k8k6AN8kJuqmCwVx6uelcCP9/mbbBUHBFKJ3S0lCP+WYcSq07vBigSgItLwxzUBK/297YHOAk+E1TANGlchIFaxfJElL0rpH7DwSBCVP3ja+D5Cc8UOoOShVZjU1QPrXEuUE4EGMBdySDjyUooRdxJ2P7Mco+pnv0pG+v0FF+JECukyKRbMVrptSBPiKFw/1wVuE9FWp6gx93WmE3vSs2z4EjVbJGvMAXDC0lJ1mhnaVgrpvYuACOsYSOdp19DQMS+P9xshBtZFgQrle+nwaF5xCQ/WKctGHskzTU07iBxURQx/MBVxY4T2+yzWcXObm4kzogDYP4QoajeT119/yQ3wbCvE2884pEDfxsDi5bnAb63OgZKbrJ5JyJPvxwr9auKqL8TewqcPm8pCiAA0Uaf+tIf2cwmzvkYKz2mNhz8VTXa8UI+Y2A2TZ0IlG+26W2y6hFMY/IIm5kbANG3FwIRQx+LPiam0s/O+gzKs2TmKtDYADwBQhtEqF5WO4e3iQ35s7jF7mwIQuMQxfaE3dr9zQ7BVSmXFdqipmhfdFuF99LsJJJ/HMxyLdBbOmRvWl7RuKFUKekjozMpv94s0fauPmfUQwvAcr6gu3A9QKRW21QpjOn0/WDJHwMTnPbzA2rM185hMGsmXuuu66KKpa5ElRVw6NeBDUPOHv5f4WYeF6tSVxnuqhA0Q5/2U889i7Wq8AEom7PLc15heggeB1szQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests/mm/memory-failure: write the whole page-cache test file for OMFS
Date: Mon, 23 Nov 2026 10:46:15 -0800

"selftests/mm/memory-failure: extend page-cache test files with pwrite()"
grows the page-cache test file by writing one byte at the end.  That works
on HPFS, but leaves a hole on OMFS, whose extent allocation does not
support holes.  After a mapped write and fsync(), the file still has the
expected contents in cache.  On remount, 2048 of its 4096 bytes have
changed, so the hard-clean-page test fails when poisoning drops the cached
page and rereads the file.

Write a full page of zeroes from offset zero. This still grows the file
on HPFS and allocates all its blocks on OMFS before the test maps it.
Check the write and clean up on failure as before. In a diagnostic OMFS
guest, the test passed 9 of 10 cases with fix-5 and 10 of 10 with the
full-page write.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: German Maglione <gmaglione@redhat.com>
Cc: Kurt Lin <lylin1023@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Vlastimil Babka <vbabka@kernel.org>

 tools/testing/selftests/mm/memory-failure.c |   25 +++++++++++++-----
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-6
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -17,6 +17,7 @@
 #include <sys/vfs.h>
 #include <linux/magic.h>
 #include <errno.h>
+#include <stdlib.h>
 
 #include "vm_util.h"
 
@@ -264,18 +265,30 @@ TEST_F(memory_failure, anon)
 static int prepare_file(const char *fname, unsigned long size)
 {
 	int fd;
+	char *zeros;
+	ssize_t written;
 
 	fd = open(fname, O_RDWR | O_CREAT | O_TRUNC, 0664);
 	if (fd < 0)
 		return fd;
 
-	/* HPFS cannot grow files with ftruncate(). */
-	if (pwrite(fd, "\0", 1, size - 1) != 1) {
-		close(fd);
-		unlink(fname);
-		return -1;
-	}
+	/*
+	 * HPFS cannot grow files with ftruncate(), and OMFS does not support
+	 * holes. Write the whole page so OMFS allocates its blocks before
+	 * mmap(). A write of only the last byte loses data after eviction.
+	 */
+	zeros = calloc(size, 1);
+	if (!zeros)
+		goto failed;
+	written = pwrite(fd, zeros, size, 0);
+	free(zeros);
+	if (written != (ssize_t)size)
+		goto failed;
 	return fd;
+failed:
+	close(fd);
+	unlink(fname);
+	return -1;
 }
 
 static int prepare_shmem(const char *fname, unsigned long size)
_

