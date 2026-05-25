Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24371CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 07:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33E6E6B0005; Mon, 25 May 2026 03:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EF136B0093; Mon, 25 May 2026 03:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204C46B0095; Mon, 25 May 2026 03:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 113AF6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:22:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60CAA8F4FC
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:22:22 +0000 (UTC)
X-FDA: 84805098924.18.EC86AD9
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3257D140009
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:22:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FEE6BK9a;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779693740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bW8KaJpi8udYmyiUW7NK6ANQnUM7EADuYOYwL7NnDmk=;
	b=akniptp1SIXqPzD7wPIWme7Hnt6TPUOkMvoJy2/e5cXu+9VQBYxEAOfo5vG+XVdH5koTIk
	6xJdgQiVYxuJv0eb3XGf8EuTNSWMV+1yBgzFq73DpoXmhcavuFRJvWNxJ0CugUbYoOh/er
	7rI9/Yc8sG8lt3om2zT0nNCgLAc6GPM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FEE6BK9a;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779693740; a=rsa-sha256;
	cv=none;
	b=qPUCQKSaIGficQv8oNOtXD4Uhy51lLwTcBEFbBMBlInJltR3RimdY/IOe/9azcwt7wgHmc
	okoaPp2BDLPzROW60egF6t4pKjdxxEDn6fAqjXB61qgWKChDwcgHmWiuqvs/Ka6lPGFmeB
	j4+n2pqHq5x5utvI4gm6y6X+QXPNPPA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779693737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bW8KaJpi8udYmyiUW7NK6ANQnUM7EADuYOYwL7NnDmk=;
	b=FEE6BK9amCw43FKvVXDblujY4YIpWo+NfMEwirwwINe0sGuo1G9VKJQLQufS41ZwPqi1NA
	iz9AXc/5BOnIDzLVEz/nwbBSWsJ7qykslYvELVZCpVnNEoDWBwZcFutFJ7ExBPS17s+J5e
	/HOYZczl/jgKfiIFIo2tlyd6A6aVQsk=
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH] alloc_tag: fix use-after-free in /proc/allocinfo after module unload
Date: Mon, 25 May 2026 15:21:17 +0800
Message-Id: <20260525072117.112779-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3257D140009
X-Stat-Signature: 3gn1f4ip7w7abnmsx6btw4w15hu85aeb
X-HE-Tag: 1779693739-372520
X-HE-Meta: U2FsdGVkX1+waukhylDbKdyqeDogZbmSZGVMdqRhmJ6uV2sRpv7Non4/9it8/bKRJR9Ce206Zgn9Y3pYGcUkZmgTfrPl0cdH7bGQfjzXvKtg7S68UjrC7UeTiCHDrIKkX8P8jqhxQXuMdZ5HNTPo501dhWZsUleGJ+CroM51fJQ8kEIJGgMFpO3fl7us6EOx191+EHYZ2qDEbNjWW+wIWzQLn5XHl+TXbwMlEe0G+t5MtBX/og1QOWlLR3hjpG6K/tjmdfOix6WedXHtF4SK0UDP1ozOhsGEzEJN5dL8lhoKx/D68+9bLzqKeMOo4RavV2dx9tYgYwPSeMt1nwM+Tk0Y7OuYvrcgnEWJFluerPcw8ylWTMS/MvnVjSdCeO/uStdKOEjFHOknTETOkNW6R+n7gHaZYpFAc8hKXZhlxQ3qAFMmPTCbk3Xrk/VBnYw4MK4y+1/NTSNqfv9QFOqqMzailIAM9uYTBnmM2zxBFtpal+GytkLPw/A9+zuuBjHru/jQXCxtJH17xfWUXYKCBWbytMXAvlS5eLSkCVTz9DHBIe4lhpOiO8bhaOpEG1XFEu67D3jVWX87+HjLPrejlznLRGvT/DnAFQ6EMJ6BIqd6ncvKXJdkTFJTiZs7V91n27rwkrMQ8z3ZxjMBMZ5zudoKPqZ7I2bLZo8/cYczdOWUV37iHubpS1jaCPNjpWbx4IDi4KRrtr5+zbHDWC1KPzt3KDqdJChnNk814jpMbdlQ82UhexdwBpqy43DxwU13sUCz8wMUiVZZegdU/120uCyKQF+Kh74NEgQIeCkU2rjAe4nrui5CbcUmM8Z8stw7NHBNbv/FW9iHBgSYI3qsy6baQOLwbSIwaKX3NAMol5MvLLmwVdVNVGGizDZWKOLsfLw0qQbICZtJmAcqtRYpz2MzOvm57GgkEec8DCuDKLvpQpzhLUK2yFs/KDiIGFoJE1OnytuY+AlSnFKh7Aj
 tf0Ufs6O
 Vpn4vuc2K/gu4FOwIK11v+6oDqIm6viDjWn7ITmEDSrUr2OPAp2CRZmavr1zCVCGhwSwj8L6jRq4yfT7JkXc8hAPrIigotPlyNdL4aXNlqoLU1RaFu5RQT11ZcCHmPHnOubRvsBnINzH5xYBvO/euFEl9j0en5BJ5bqqanEO7clPxoOumdq8bFhgdJHyVzSTJIw6yGmpQ093HFM/KTkieupDAw2dY5rSWfsgaCXot/585dzWojHetGQYi2Q==
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

Fix by always reinitializing the iterator in allocinfo_start().

Fixes: 9f44df50fee4 ("alloc_tag: keep codetag iterator active between read()")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 lib/alloc_tag.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index ed1bdcf1f8ab..2b2d1580c714 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -51,16 +51,19 @@ struct allocinfo_private {
 static void *allocinfo_start(struct seq_file *m, loff_t *pos)
 {
 	struct allocinfo_private *priv;
+	struct codetag *ct;
 	loff_t node = *pos;
 
 	priv = (struct allocinfo_private *)m->private;
 	codetag_lock_module_list(alloc_tag_cttype, true);
-	if (node == 0) {
+	if (node == 0)
 		priv->print_header = true;
-		priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
-		codetag_next_ct(&priv->iter);
-	}
-	return priv->iter.ct ? priv : NULL;
+
+	priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
+	while ((ct = codetag_next_ct(&priv->iter)) != NULL && node)
+		node--;
+
+	return ct ? priv : NULL;
 }
 
 static void *allocinfo_next(struct seq_file *m, void *arg, loff_t *pos)
-- 
2.25.1


