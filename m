Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC7AFE6ADF9
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 20:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393546B0005; Mon, 22 Dec 2025 15:59:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D396B0089; Mon, 22 Dec 2025 15:59:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294A66B008A; Mon, 22 Dec 2025 15:59:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 180936B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:59:36 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C12E61325E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:59:35 +0000 (UTC)
X-FDA: 84248323110.20.027C398
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf29.hostedemail.com (Postfix) with ESMTP id 144A5120011
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:59:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nZJflpUs;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766437174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mZ/UtThSWtPu4Oy8X58uMB22wy61L0gvY9PyQceVLTU=;
	b=VRqPA8IWWeuQkO5e/m/bQTeZEo8JNTjA1Xc0aiesXYCg1p7Fot46dDXFGix0wCzZ6X6dnS
	lGVx35H4Mryx6dmQHUR5zSptz1+AEnmVSfOq980Atwg6oNcIjwU3IPhMftkp/aErIGvr4L
	fupKkzO/ADjRE1I5qn7hfCOd5FNvtQk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766437174; a=rsa-sha256;
	cv=none;
	b=8gkI8LsFOSFJSUlOsln1zPtNJQ5YDO1v1JFWg4SwrXEVq+4M8TXMaHZFp0T2+n7Z87kj5q
	OBBc7uP771weMkludMIuVO0s/KVhwN1ZIvZjcP3XDDbhxR1ns68rB0pUEhQBeJSDDT/J4s
	D/hzWk16NZpCD9+xu1WB4WLlG+JHv4U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nZJflpUs;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766437166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mZ/UtThSWtPu4Oy8X58uMB22wy61L0gvY9PyQceVLTU=;
	b=nZJflpUsEdvMGyI7nb87aSCrQNiiKJayQuZfosbzlkuNU26egktK+1mOkpm5W8jBaedN5p
	SgVxLaZHZTNPGYMxoXL5rfR/0lFkBVZYkoct5EWYXyt0vb6a4NwF8xZnD7ZSgyt7SvkBOq
	KFA2NzPlh3c/fN8xZlPev1flXkvW/pk=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrii Nakryiko <andrii@kernel.org>
Cc: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH bpf v3] lib/buildid: use __kernel_read() for sleepable context
Date: Mon, 22 Dec 2025 12:58:59 -0800
Message-ID: <20251222205859.3968077-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zdjx8a8o5cz4iejqbj4ke7jf16bjyqkc
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 144A5120011
X-Rspam-User: 
X-HE-Tag: 1766437173-358794
X-HE-Meta: U2FsdGVkX19F0WNI21hEwLzncx8GM0FWr9jJvIGFgMgbCVpQtGrCg1oPUtqadA0W1IgEgZazIG5qmqvyAhG3oWGkUEn1oSWL6rUCccwo7yS8vQ1sDEMSMcAlQjcwmR1jq2mZXeJIrfy0Hqh7OiArljwAx49ikSDiWfch1ZJhdXaPsefkKO9WDfrQ7iTDVYWra2wVm5V1dxLWlKAYhsd7/aOzyL0VAuG4awk/NyfS64wPCNheN/T8yY9Oy3m5ym6vCNJwHa1Ylu/F6p7huMrvsckl25rjzVb/ZLw9lsq9ZDfLSqNOxZwM8PMMqp8trTF122oZUk+MFRCARJQo6SU0Kqb4H+0flIyndVWk/iXJWTxDowmh8bGVWdwcBZ5TiKJXM7Q6Gz/F5H+GzUMy77ArSSXoLFPFxKuXqYiU+risLCS1sPP1DUXvxGf7K76YmxUlrRg4sOSA8tR0e0VxdnwPJn1SEv0sq4GX5eUV55idkCO8TnsHx30T0cxJByb58temtpBZDJXHPJxD5E84i0q6gLxAjoncSXg5SXy+Ffuf0/3Fvq9H6lEE0XUkNX93pRN9pIdSw0JPvg0HWgZ2l9MHNyQClGbSPsdHrvyappLtkD4ciegImxER6nHw1JDzfBPR7v5dSom94aYfdJxoqauL9QVMf2Lks++O3hcgCpjI8Di3VNqHXxW5GA6jt/WzFBq5O0trxwoHaR/WStnxG6t89RQj09ADWMPjLtCfPSKH1m1F+WUWa+KzFL8ILM2jhL8iLlu+QFs57gIAs6/UKSdQhwa2Vze44Nje6tL/+Xq7IziHKtCJlksX5ldZyBlDtsAHMhbfcXJUbaMewAyf7zy1NSo/C2koxo87rg/xjBOogSaG3Hha2R84ELIeFZGAYEeHvTNVA+C953h1r25SOkHOxbO/YPCOTOe7gX0WNiAx6sZVVh0Uz4oqIh2hWAJZOwh+MCa5n7+vL7UY43itGkZ
 4MCGD+bH
 m67Mz+N7HjgItnXL82p6U51e7mSGNUOflq1OMrk1EidywMT6EHeeSPF4EIRfirn4d06iG8TFHDQbB6MPeauOADZr4NuvUUzKc5jSBXN0kyC9gUOhdAT4y5R48htF68XOVZZG1HKIGk8iVyBothBpJLXEdqerysBwT+g1/DkNJ/tr/N0ti/Dkm718WSc/oGBhoXT5OOTwvz18NdEmYx9XxlVR/tBDFlNHEDAChNlymvsWCDr+962Q9THLa/Kbi0Ikb/e+uMYFNAhX95DgTFdk8MNuSJuore7nr7xHFOn8/ksx6rdIFe/PeBbvvBSB6Iv1DEJffYk+q4EeDc/6U0hSbxwueqhpGRdnubz0/QNgu2THLHGCcSK/Zh2kkh7m28D4JqwUxmnU89ZGqrAjB3x3wAt8Swmcgl5/pUnHX1e3iWZXwyjPVtnuJmKvxzz8sXuFEihnU7wRa07hOo7xSvn0VPaQkng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the sleepable context, convert freader to use __kernel_read()
instead of direct page cache access via read_cache_folio(). This
simplifies the faultable code path by using the standard kernel file
reading interface which handles all the complexity of reading file data.

At the moment we are not changing the code for non-sleepable context
which uses filemap_get_folio() and only succeeds if the target folios
are already in memory and up-to-date. The reason is to keep the patch
simple and easier to backport to stable kernels.

Syzbot repro does not crash the kernel anymore and the selftests run
successfully.

In the follow up we will make __kernel_read() with IOCB_NOWAIT work for
non-sleepable contexts. In addition, I would like to replace the
secretmem check with a more generic approach and will add fstest for the
buildid code.

Reported-by: syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=09b7d050e4806540153d
Fixes: ad41251c290d ("lib/buildid: implement sleepable build_id_parse() API")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
Changes since v2:
- Single call to __kernel_read instead of looping (Matthew Wilcox).

Changes since v1:
- Fix handling of buf in freader_fetch_sync as pointed out by Andrii.

 lib/buildid.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/lib/buildid.c b/lib/buildid.c
index aaf61dfc0919..818331051afe 100644
--- a/lib/buildid.c
+++ b/lib/buildid.c
@@ -5,6 +5,7 @@
 #include <linux/elf.h>
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
+#include <linux/fs.h>
 #include <linux/secretmem.h>
 
 #define BUILD_ID 3
@@ -46,20 +47,9 @@ static int freader_get_folio(struct freader *r, loff_t file_off)
 
 	freader_put_folio(r);
 
-	/* reject secretmem folios created with memfd_secret() */
-	if (secretmem_mapping(r->file->f_mapping))
-		return -EFAULT;
-
+	/* only use page cache lookup - fail if not already cached */
 	r->folio = filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT);
 
-	/* if sleeping is allowed, wait for the page, if necessary */
-	if (r->may_fault && (IS_ERR(r->folio) || !folio_test_uptodate(r->folio))) {
-		filemap_invalidate_lock_shared(r->file->f_mapping);
-		r->folio = read_cache_folio(r->file->f_mapping, file_off >> PAGE_SHIFT,
-					    NULL, r->file);
-		filemap_invalidate_unlock_shared(r->file->f_mapping);
-	}
-
 	if (IS_ERR(r->folio) || !folio_test_uptodate(r->folio)) {
 		if (!IS_ERR(r->folio))
 			folio_put(r->folio);
@@ -97,6 +87,24 @@ const void *freader_fetch(struct freader *r, loff_t file_off, size_t sz)
 		return r->data + file_off;
 	}
 
+	/* reject secretmem folios created with memfd_secret() */
+	if (secretmem_mapping(r->file->f_mapping)) {
+		r->err = -EFAULT;
+		return NULL;
+	}
+
+	/* use __kernel_read() for sleepable context */
+	if (r->may_fault) {
+		ssize_t ret;
+
+		ret = __kernel_read(r->file, r->buf, sz, &file_off);
+		if (ret != sz) {
+			r->err = (ret < 0) ? ret : -EIO;
+			return NULL;
+		}
+		return r->buf;
+	}
+
 	/* fetch or reuse folio for given file offset */
 	r->err = freader_get_folio(r, file_off);
 	if (r->err)
-- 
2.47.3


