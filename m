Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75FD5CD6E68
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 07:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962376B0005; Thu,  4 Jun 2026 03:00:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912046B0088; Thu,  4 Jun 2026 03:00:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827906B008A; Thu,  4 Jun 2026 03:00:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D94E6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:00:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13CEA1C0E32
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:00:56 +0000 (UTC)
X-FDA: 84841332912.16.2A8923B
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id D6A1B20005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:00:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IM+De4kI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780556454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TjIpgjmM+vdGa28OxsmD6HXDMP3817Snwv7Mrurc7oY=;
	b=E/oLY6Nf2AsKjkhU5AO1RW8qH8P2oOTch8qZlXhbAGFCYj4dt09PAFcH1eOqtqT9zVbNLK
	42nx/2yYOqlFqN6sCy39aslNfgWJ+5ufvgIA7WTzX0+S1zC16ChdSB9M5Bg9UpbBRM+SLq
	kMtKiQXqBhy3na9qXiJbWqnleZ7zJfo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IM+De4kI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780556454;
	b=CacDT9bFRfoUTcTduRPtjPKXugBvHlLNK0XRHWc+SpmdY3Phat2peGXr5uSHPNx+wIqOPD
	5dghk5yigp94GFfsgouo86TBgt0sRr9+WeSAGD95UeOv6vbCKmTpjuCbhVWi15XsOzsUkI
	gBjZBEfm5upowc0xAwkWq4hBRMomQVM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780556450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TjIpgjmM+vdGa28OxsmD6HXDMP3817Snwv7Mrurc7oY=;
	b=IM+De4kIrbge4FkTNpW9wNUN9uboIOfk5lnAduVgVqEzkJb5URL/aHNJO1dcHsW2bFuXsh
	B/Y8KmR4N68WZrdGsmwX86ciK5S1MdeVEeri342oYeHMqdoZtiyLRlFpsjZT1i1FdYZcBt
	bKmAK1JCUvt5ni0CmNGBePRKfviF0Mc=
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v2] alloc_tag: fix use-after-free in /proc/allocinfo after module unload
Date: Thu,  4 Jun 2026 14:59:38 +0800
Message-Id: <20260604065938.105991-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D6A1B20005
X-Rspam-User: 
X-Stat-Signature: g9hxyw8311ypep73jmbzszygnwoh73so
X-Rspamd-Server: rspam09
X-HE-Tag: 1780556452-589272
X-HE-Meta: U2FsdGVkX1/nd8SVyNHgQW/T8LENEdZRl22+leu3RJY7b8mtACR0FhDkaCfoz4USP7rEa3+PdY3+3UlGKyx7FuCdEECE6G7REGiY5x8ygvi7xq6Qm7SlMX4NW6TlI91k3wed2Mom4NIE8bzLUdTdbNFcpzepOCNiraey3a6XN7tstWmTycMqWPefsRxImQZvnaSRKvfA4B7PC/2xNgJeif80JxEcOThPVbFwnqZbryJ00hkU62nzddL0DlQp5mns1ARxExYCA+GS3XOhm0gVjSvGax0FPHE5GWIYHnZrTN/ZMBDBtcus9rvWAWjCQZoUhhkPCs8pSOz+juIO9ydRHGPVdtViqaK6FH+PctTAnki7jpsoioSWHUgwTBt6kpocPvn6DLCWcluHQnFTNrvcM0JzSS6sKZasp3pJw+wtkU0yapoH777MvcqdDuHshHy73GC41jiqAh/mT8VftobcsByB8CjNaM7Slj4E80RFquaAnKQKCsk3ys80j7uQJByEhrG5b4phmCRqU7ZqGROT3dUReGrDkCnx6ZqGkc4cqivbKI7O965U0e/HHb2pl3wBO0j7Ql8+mDTzIrtVFUD0ri0MHI4W4cjv0QSVuoLBeAikDnpL0/NxH3A/TE66C00Bi3NnaVvQa/7DMp1C3MpituzeGksRkPr745IugFfi1/WVzNJbQYJgUIJhNahM7FSU7B4dusBrvdGp9r5039MeOarEG1rHM7Gs+d60CxQ8b9Nk+4Ue99FfGjCefhqzzjFJZFUKc3c2Ql1mcB3h0Wd+WkinOcCnGQAniM29tJ03wnsZuYKr4Q8+l7x2ICDljApgyRNH4yRGhhmx5NMNQeqy6sX/DrOMo6gmDeuS75zXmD0k4qnv6nvWdQjBIuIzyvChK+iohe5y/YJSPmKz+AaXZlqiP+fsj3dKA3BbrgIoKRJtr+/Q5lT/gat3gaFpfRFkVgmGguUL6c371V2aXBC
 N7Rf85YH
 wKBzb8cNxVZlLgM1vkkhBjzqMBLclK8SV6UTNyz/6MWMqXn6lB5aI0/szSN2fAY8CJ4dvswq/cp+w4VQkmzHVi3RBtV8pqowJM9UzwjvUI+kT3ku2we3B261BBMu4DFcPbi0Sm2HZO4W2ldxFZViUXl5UrugOMLS0/8v7sHFur0jp6p0KAcMrPYOR/Fp8Kp/tBNgHQRkEn3PgXd54Ldk4zl1za6zA88xqtw/2nZHrIohfgL6P9d7llwY0/RfXAosac+buPrd9Jg6JkgoKyHC1zG6BjdwE9XBXvT4g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

allocinfo_start() only reinitializes the codetag iterator at position 0.
For subsequent reads (position > 0), it reuses cached iterator state from
the previous batch.  allocinfo_stop() drops mod_lock between read batches,
which allows module unload to complete and free the module memory that the
cached iterator still references:

  CPU0 (read)                        CPU1 (rmmod)
  ----                               ----
  allocinfo_start(pos=0)
    down_read(mod_lock)
    allocinfo_show()
    ...
  allocinfo_stop()
    up_read(mod_lock)
                                     codetag_unload_module()
                                       kfree(cmod)
                                       release_module_tags()
                                     ...
                                     free_mod_mem()
  allocinfo_start(pos=N)
    down_read(mod_lock)
    // reuses cached iter, skips re-init
  allocinfo_show()
    ct->filename   <-- UAF

After free_mod_mem() frees the module's .rodata, allocinfo_show()
dereferences ct->filename, ct->function which point there.

Save the iterator state in allocinfo_next() and resume from it in
allocinfo_start() with codetag_next_ct(), which detects module removal
via idr_find() returning NULL and skips to the next module.

Fixes: 9f44df50fee4 ("alloc_tag: keep codetag iterator active between read()")
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
v2:
- save the iterator state in allocinfo_next() and resume from it in
  allocinfo_start() with codetag_next_ct(), which detects module removal
  via idr_find() returning NULL and skips to the next module (Suggested
  by Suren).
  v1 link: https://lore.kernel.org/all/20260525072117.112779-1-hao.ge@linux.dev/
---
 lib/alloc_tag.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index f2f574bcf383..551cc14bb1fd 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -45,6 +45,7 @@ int alloc_tag_ref_offs;
 
 struct allocinfo_private {
 	struct codetag_iterator iter;
+	struct codetag_iterator reported_iter;
 	bool print_header;
 };
 
@@ -58,16 +59,20 @@ static void *allocinfo_start(struct seq_file *m, loff_t *pos)
 	if (node == 0) {
 		priv->print_header = true;
 		priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
-		codetag_next_ct(&priv->iter);
+	} else {
+		priv->iter = priv->reported_iter;
 	}
+	codetag_next_ct(&priv->iter);
 	return priv->iter.ct ? priv : NULL;
 }
 
 static void *allocinfo_next(struct seq_file *m, void *arg, loff_t *pos)
 {
 	struct allocinfo_private *priv = (struct allocinfo_private *)arg;
-	struct codetag *ct = codetag_next_ct(&priv->iter);
+	struct codetag *ct;
 
+	priv->reported_iter = priv->iter;
+	ct = codetag_next_ct(&priv->iter);
 	(*pos)++;
 	if (!ct)
 		return NULL;
-- 
2.25.1


