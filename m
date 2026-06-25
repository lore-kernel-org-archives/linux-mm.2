Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A86FCDE009
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 20:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ECE46B00A4; Thu, 25 Jun 2026 16:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39E2E6B00A5; Thu, 25 Jun 2026 16:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B38A6B00A6; Thu, 25 Jun 2026 16:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F13E76B00A4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:14:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B248140267
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:14:14 +0000 (UTC)
X-FDA: 84919536828.10.949E1AD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id AA85DC0004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:14:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wW34XuLi;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782418452;
	b=WJZI6HcF545p4yG0mj83l0H+UFT4XXEGGft/jMVv3/q/aCZ8eyxuNMGPfAWupBv3S06d4+
	zcQZPvmm+bPHw2LNIVyU5Ow/7V8wq1SCyn3wzXP+c7ZrDHbO/RZhtBsKmVrxGIshHcR9h/
	bFITGyc02GoqxjquqRWp/wjC8EGsCoU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782418452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xtPHeOMkoK9J0uCanVAhrPgdRQ2Kgkwnjz1DQnXps8=;
	b=4epZS1t2RZ6yCs8iTWRrHibAZsR+5/hjFGvikq2YZ6LIfuPDY81xP1p0me3eOoY68NJyWP
	mbzYxB0R3qedSagvXnue1MLyGnwyGG1cnnw53TOQoFqnUxv1cinzut3KdBkuCxHbSHHkvw
	3ZpUkRJKnq1yberUqdaiu1+gR/Qu3LY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wW34XuLi;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=7xtPHeOMkoK9J0uCanVAhrPgdRQ2Kgkwnjz1DQnXps8=; b=wW34XuLi7X5i6VE7Zhi2l8eU70
	g+1dl6MomDUPyY4dKtYDOpLn0nM4HrUz3HwRZUlv/2J1G4huyk1OeG3pvaOjHnGTVPJXLYFK6cJ6j
	0FQx1vuW1QJDdi6SbUCM5dS3v8qykhhK0HVwjRF6TZ0Jv8u/XctBcCi8fwvk700lRWDf7e/R2Y8kH
	dKw8Vae3l2QziMJZMov1FYwPJ34YzOtoLRNnX5knb1b5grikdzSSO5uovfRUlQ7b5AZkdFs/zUIEW
	01EBh0WqayZZuGXOUjbswbdqwD1VWeD7UjOifYKamyY2dgrZ0VKidooBtye4MI7R/C0u2S/t+8SZF
	hfSssnFg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcq61-0000000AWZ1-1bVn;
	Thu, 25 Jun 2026 19:50:45 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 09/11] filemap: Handle folio locking in __filemap_get_folio()
Date: Thu, 25 Jun 2026 20:50:35 +0100
Message-ID: <20260625195040.2508362-10-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625195040.2508362-1-willy@infradead.org>
References: <20260625195040.2508362-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kfjikid7tjxgqd9cdoyfrhx6oz6te9ue
X-Rspamd-Queue-Id: AA85DC0004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782418452-699145
X-HE-Meta: U2FsdGVkX1996Ty/9RUitgfoSRorK442vk+kEtvJanRalzCw4F2mDcr7VvkTUS9FtqrwJWsQkycz60biADxOAHUk8vnUdrovUI3SogxA+qxyHX4lKQSnsgwfdF1wE4S1Te2jx2w28SybvUx+h0lIefgTKqXnm5WYYNEv9Qkv4i9kt5TgtwmUnyZz7aCZNUaScKaghofXUbelWODtAqymWIrXv5MOTCKoGJWd588DBQJZNCTCTIFl6ELRNJQY4nW/uMEyTGg7U+LyGCPkwLwBWW4MyVz5M9U3Aspfi7ff9O5lkZFolX6a8Vr7uMxg7l3lOh8Oz/WWj29s8lQZuR74t+0+NlUCpIm8P2zThnYwpu8AmpOeOKDUcqfRLWIWs8zx0oKBZy5WZTNx6ULc2hIcke8iApwfVeLgHHwwEt/VR1wv2DZZAmYu/STuS4Sdvedswqhsg9mUHrLSE1NVrolNgp/TcWIvp2m4nTUfjx47GmYuDT5Z2ArIKTTlhvMjnDjzKqmXS+qoFZd5E2HtEFL6t2tFLL8BAbVQLaWxBU/3pK+5GdfLjmPB3Nd7mUr4s9IUBFPmWCc1/P5ZCTB/UHsS2eOyXVRP790IVy+E8yK4B/x0+whUahyhdqpKrWh/tEbSWxr3iufsNwHScHb2DxPs1z7J+MtoXIL1muWDJKpDFnjqKKxDfkFi72EZpQes94q/eGYaYq2xfTKnJKG2bsaqzdbuD8io2fXohSjEFLpX3lDpwP+GE6OEUA/I6zFHsPc3KIdFMXr74OskYQRYKJuRUoFrRRi8su9QS8LcFFBXafTtvmuhZSi66/dGuYgoRp4BhvsdNIw4zUL5MfRe70OPcM49xg2VFQHMy0i/vTaYpUi669RQgzZmTrjRMXsox79J7aRTETBbScyxQmPEzQxe7meuOyUnJJl9/rizZF9/B2mQYHDxu2OrX0b3nymqSWSNHVELwDkPiD6iyMXh4+g
 sDHUDXGd
 cnb0QFbVlDETUL9sGOnZneInXUyVVlB3cvDCXmeW/ffCV5duH1DCb8U08qvJWIhtiKMJsiUObp+4mBuftYgAiSpXvkDzi9LuDG1z8tdnX+sVCTl1pcxlGh9nZgTVRMyjFFKwZTKWFkAy3WtpV99p8R8Wx9wk/kM+tl+baPraWtj0yPh3FGgR8ORLP4Ds9Q8q78PQ4YhHxVdugh2BTV9YFtgqhsyvE53xfRm/sJnf8VoK7vSaiMNqRt8oHBx2oWhfOf65Xq6+N5Ccvn7NnaKHlVT5lRerkBJufdrUPcAQt5EnvLXLxPlxc2bPiy5yzKhFHzSh/SI4jDqydUiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we no longer care about getting a reference on the file, we
can ask __filemap_get_folio() to lock the folio for us, and only call
folio_lock_or_retry() in the case where the folio is alread yfound in
the page cache.  That lets us get rid of FGP_FOR_MMAP.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h |  8 ++------
 mm/filemap.c            | 31 +++++++++++++------------------
 2 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2c3718d592d6..53b14f8b6b3d 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -693,9 +693,6 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
  * * %FGP_CREAT - If no folio is present then a new folio is allocated,
  *   added to the page cache and the VM's LRU list.  The folio is
  *   returned locked.
- * * %FGP_FOR_MMAP - The caller wants to do its own locking dance if the
- *   folio is already in cache.  If the folio was allocated, unlock it
- *   before returning so the caller can do the same dance.
  * * %FGP_WRITE - The folio will be written to by the caller.
  * * %FGP_NOFS - __GFP_FS will get cleared in gfp.
  * * %FGP_NOWAIT - Don't block on the folio lock.
@@ -712,9 +709,8 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_WRITE		((__force fgf_t)0x00000008)
 #define FGP_NOFS		((__force fgf_t)0x00000010)
 #define FGP_NOWAIT		((__force fgf_t)0x00000020)
-#define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
-#define FGP_STABLE		((__force fgf_t)0x00000080)
-#define FGP_DONTCACHE		((__force fgf_t)0x00000100)
+#define FGP_STABLE		((__force fgf_t)0x00000040)
+#define FGP_DONTCACHE		((__force fgf_t)0x00000080)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
diff --git a/mm/filemap.c b/mm/filemap.c
index 54997e667246..d1f7efcdeb95 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1988,7 +1988,7 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			gfp &= ~GFP_KERNEL;
 			gfp |= GFP_NOWAIT;
 		}
-		if (WARN_ON_ONCE(!(fgp_flags & (FGP_LOCK | FGP_FOR_MMAP))))
+		if (WARN_ON_ONCE(!(fgp_flags & FGP_LOCK)))
 			fgp_flags |= FGP_LOCK;
 
 		if (order > mapping_max_folio_order(mapping))
@@ -2035,12 +2035,6 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 				err = -EAGAIN;
 			return ERR_PTR(err);
 		}
-		/*
-		 * filemap_add_folio locks the page, and for mmap
-		 * we expect an unlocked page.
-		 */
-		if (folio && (fgp_flags & FGP_FOR_MMAP))
-			folio_unlock(folio);
 	}
 
 	if (!folio)
@@ -3507,6 +3501,17 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 			filemap_invalidate_lock_shared(mapping);
 			mapping_locked = true;
 		}
+
+		ret |= folio_lock_or_retry(folio, vmf);
+		if (ret & VM_FAULT_RETRY)
+			goto out_retry;
+
+		/* Did it get truncated? */
+		if (unlikely(folio->mapping != mapping)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			goto retry_find;
+		}
 	} else {
 		fgf_t fgf;
 
@@ -3528,7 +3533,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 			filemap_invalidate_lock_shared(mapping);
 			mapping_locked = true;
 		}
-		fgf = FGP_CREAT | FGP_FOR_MMAP;
+		fgf = FGP_CREAT | FGP_LOCK;
 		if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
 			fgf |= FGP_NOWAIT;
 		folio = __filemap_get_folio(mapping, index, fgf, vmf->gfp_mask);
@@ -3540,16 +3545,6 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		}
 	}
 
-	ret |= folio_lock_or_retry(folio, vmf);
-	if (ret & VM_FAULT_RETRY)
-		goto out_retry;
-
-	/* Did it get truncated? */
-	if (unlikely(folio->mapping != mapping)) {
-		folio_unlock(folio);
-		folio_put(folio);
-		goto retry_find;
-	}
 	VM_BUG_ON_FOLIO(!folio_contains(folio, index), folio);
 
 	/*
-- 
2.47.3


