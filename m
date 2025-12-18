Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0627D711C1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 20:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0EA6B0088; Thu, 18 Dec 2025 15:56:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59E4E6B0089; Thu, 18 Dec 2025 15:56:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B31F6B008A; Thu, 18 Dec 2025 15:56:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 374426B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:56:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DB06160337
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:56:10 +0000 (UTC)
X-FDA: 84233799300.16.04A7599
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf22.hostedemail.com (Postfix) with ESMTP id 29F26C000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:56:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J66Awytj;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766091368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=C7WJGFzPgQgbOew4Nik7yqwK94tl6F+VcxmeN5CTI3c=;
	b=hPLg6kEA7/xggZZKGX3tjraft6aharSk0c8kzNMHb+fmt1KBCaBmA7ry8Lq/20JU0LHk1O
	mdg1Iq6TceFmiliAxXEqbgS800VCcv04hWY6TpoPDNgro08zSasH+LoX8GGI7qvZ7IbZO/
	oL6BSW6kdiCUsC5RPQe6QzQ6wG/7YzM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J66Awytj;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766091368; a=rsa-sha256;
	cv=none;
	b=LbRIbBP7HYiDG1eHO2VD8C4/K5L48BJiM2YP4SDmJoUM2a+LIq+nqC8FKsXvIVvwgQW9pZ
	1YIeeKC05ET9HDhvmtOVDziwFIDxzeOOu7acrmm6VdjHlBEvTmyJHDW/xJC+tchtC1iAAM
	8NbomC+/Cm3gTJXN1vviMSiYSXuU90M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766091365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=C7WJGFzPgQgbOew4Nik7yqwK94tl6F+VcxmeN5CTI3c=;
	b=J66Awytj8ygIwxw+zjd2Kmu4idD3ts6dRYW5m49ISTg/x8/eNiIojqqsx++kq2/NFN31aV
	gNPB7Yore+WyDHhO4VdU/Qf39r3vGjshg2M6t4VmpUw/OorBr9Ts+xAl73gRYKZ9pJMOmY
	+v2WbzeYvGdxJV/tSfYchwRoKuZniuw=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrii Nakryiko <andrii@kernel.org>
Cc: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Meta kernel team <kernel-team@meta.com>,
	bpf@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH bpf v2] lib/buildid: use __kernel_read() for sleepable context
Date: Thu, 18 Dec 2025 12:55:05 -0800
Message-ID: <20251218205505.2415840-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 29F26C000B
X-Stat-Signature: s86b9oeaat9qjioagi5fqhipu7yetcwm
X-Rspam-User: 
X-HE-Tag: 1766091367-852979
X-HE-Meta: U2FsdGVkX19/2mAVTW++ER7VyyeLIaBUXHS1b6eK/xaZPUfy0HDDYZ6lWshCY8gzQlBxtucdGIYy4s4n8RFtL2TuHFMTCYOEcd9yeaW6vBEJ2esn7CBhX7ergNVnZjUEUsNOAI5BNJy8kGypF839h+zoQ7UwF74BMP1NhWLajXu4mQm9q3bFrv9rRcMNt/Cy2nj0//AZtMDQotAhqQISYhoIBtYagF7evYHlEeq5ZHiS+/vAB40mydPVEUBGuFuDTo6/A273m3RDz17PFMuPx5dYVDqH0VV1sWngNWjMRtGpVjn1YAyVVjhd+ZeDvxPooIgjekTjKrtdKlYHeN8d6m9WOiMd8ZMjRskGgaBHiV+uhlhWUFzkA0RDE+uqThFz5lyxz38CBw8KhE3LR5SXTcEcDiBpZcux2TRJCtZQQTYZAhc5PiL58Y34pux4Np5L2163QJHsJwt7P9tkBOvAZhlN+lQNnlPcySIuudlm2JnjObUhkH6ANFPwBr/J/jZ1GR/cfeevlEmupVciZibevoV1VWahZza+Im7m71l4IQVXTUdX1eK7Q5/N6DuYCJTWXVQm/MWGR3hOjf6rJhdZe0eBBk6ONY980y0R6wF5pW1gLj5+3TBRyBuT49VbHucVfE/ilMJL/U4fcU74OQi6N8BLx6Srd1TlKkfIH0oMZDRzhhI5Si2O5J7CrTUZz+tjmYE0gUZwHR6ksCTWHjVwIa0f+zXIzIr79FCHcXfcMquYba41KzqOJOtm5DpYce3DKEhHRenR3M4zmywP6GvcyRMeVYlW7ugRCelDj2hX1DFU08D4HN6RqCfy15bOKQWR6zDNngBir7w2Mgiv/NR/9bXqzi0yak366ZCd+D7qdpf7sO7NkqYjOO5oi6UKZ5LadPoIgKjeHiEQCC3dawwu3BXvHK+lJcOZ+FKL56tqgUNYi+6fjbMff+YnPg/bhw0vFw+mqEEFCZjFn1hwI7S
 oOvTpO2t
 zxkVofgOd7zK3XcsgbGO9VFXhzz9CGRmY19i1U0VhZlBjbnrsBRTyrBJ7So0Fu3aMd8lj0luH9980K/vdX2xjCCNkrCO9n3w/4S36SGHo6inSE1na8O8YkbJy86GMwT07SZ/+sEl6w7qKqeFF8ov5+vZbTBu/2TaemCklEu7MSLwpcdK7Mc2wa9w1xKPxb1m+/O/OBBmwRYDZE7icozmJTd4DQ09FrGsnpT6CMN+uuGFjljQ8gDq7n5KKQFRtmfMc4WJYzkEETWLFaoF/z9zo1mn74/My2PM/BIOPq3BPgI75JBBC375LHLcE/VQ56bFzYMWXiKrYJyuSlbN/DVBqMXRvl5a0M5poEAvRakBjwKpSZM3n3W7qnTG2BxA64J68e/SgK7BENklhELiEWsZc+HcoVeDoBZzeabQC1VUmbDDZFvAEpXGk2nuM+e4uaPwjv8hS+RgOXRva3XEcl+fGaxhfTQ==
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

Changes since v1:
- Fix handling of buf in freader_fetch_sync as pointed out by Andrii.

 lib/buildid.c | 47 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/lib/buildid.c b/lib/buildid.c
index aaf61dfc0919..93b3a06e7f7a 100644
--- a/lib/buildid.c
+++ b/lib/buildid.c
@@ -5,6 +5,7 @@
 #include <linux/elf.h>
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
+#include <linux/fs.h>
 #include <linux/secretmem.h>
 
 #define BUILD_ID 3
@@ -37,6 +38,29 @@ static void freader_put_folio(struct freader *r)
 	r->folio = NULL;
 }
 
+/*
+ * Data is read directly into r->buf. Returns pointer to the buffer
+ * on success, NULL on failure with r->err set.
+ */
+static const void *freader_fetch_sync(struct freader *r, loff_t file_off, size_t sz)
+{
+	ssize_t ret;
+	loff_t pos = file_off;
+	char *buf = r->buf;
+
+	do {
+		ret = __kernel_read(r->file, buf, sz, &pos);
+		if (ret <= 0) {
+			r->err = ret ?: -EIO;
+			return NULL;
+		}
+		buf += ret;
+		sz -= ret;
+	} while (sz > 0);
+
+	return r->buf;
+}
+
 static int freader_get_folio(struct freader *r, loff_t file_off)
 {
 	/* check if we can just reuse current folio */
@@ -46,20 +70,9 @@ static int freader_get_folio(struct freader *r, loff_t file_off)
 
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
@@ -97,6 +110,16 @@ const void *freader_fetch(struct freader *r, loff_t file_off, size_t sz)
 		return r->data + file_off;
 	}
 
+	/* reject secretmem folios created with memfd_secret() */
+	if (secretmem_mapping(r->file->f_mapping)) {
+		r->err = -EFAULT;
+		return NULL;
+	}
+
+	/* use __kernel_read() for sleepable context */
+	if (r->may_fault)
+		return freader_fetch_sync(r, file_off, sz);
+
 	/* fetch or reuse folio for given file offset */
 	r->err = freader_get_folio(r, file_off);
 	if (r->err)
-- 
2.47.3


