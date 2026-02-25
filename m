Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AC79FD45FA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACAE16B0088; Wed, 25 Feb 2026 18:04:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78356B0089; Wed, 25 Feb 2026 18:04:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984AC6B008A; Wed, 25 Feb 2026 18:04:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80B876B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:04:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14E5913A8C4
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:04:11 +0000 (UTC)
X-FDA: 84484509102.02.D439426
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id 532871C000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:04:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mQ928ON2;
	spf=pass (imf18.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772060649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+DIYJmA1zfgahLdi3SX9E/gtSF322FOGG+oNFk3Qenw=;
	b=qohIqBp0vRLhNa4FI2eFqxFDyvP9SJmzAbKodA30xFr+Ai4yNS7SQGAX6cdMN3Biky3bes
	gNq+BW7RPapjk0NcFf9vMyWP+gq1q95EMeRT4oABd/ws6kEhuyNymWkZDIT6PHb0Z1ZzPa
	mFF+iFUaqDxgHkU/0oE1tgcYxiIB5Ow=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mQ928ON2;
	spf=pass (imf18.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772060649; a=rsa-sha256;
	cv=none;
	b=gVZAzbaAn3mc+mpKSe22MhKmJNPvxZgFh21WRJsLEnTUL8YnlFHOkNDYwJIQ9ciIAoy+m2
	sGyUfaFeORbaAfIfdsQeI3lYJK0awrJab4vJf8JLxJJAiPk93BYN7po9B6kBIn8GKn89ra
	Q4NN2/0AhLFhR7wYFSKWD0+Y89yUato=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-899a2f4cdddso3292406d6.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772060648; x=1772665448; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+DIYJmA1zfgahLdi3SX9E/gtSF322FOGG+oNFk3Qenw=;
        b=mQ928ON2iYIxo1oxnk7bjT+D24ndny1PvYDhTt6CmKCTFrTxpYNdNpZMz4UP1CqQRo
         +sJikLlLOn6uJcV5ZGBKiI21MkN5rEtzh3/i5EKI/JAyAr3Fu+SJj8fB7xwd5X0QuOBc
         rl8bWpQRMeQVSl14Hu/AOhp2U6KEwuLaAYg6Gqir4axAZumxBtoAjep/lxBR2U3F7n7H
         PhzYmSWxAM5Ue0SQQN5896R3LifJpD8EFbNSeSEUeS8CeaIcWyIyvZmPCFfRjRkTQgpC
         pfD1KBWO1S76jqTKLmXnmlE7vChIPYqaFpEOSFVwv15wT/4tP35ws6Tqn23geToERm5w
         fs3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772060648; x=1772665448;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DIYJmA1zfgahLdi3SX9E/gtSF322FOGG+oNFk3Qenw=;
        b=LYIK5czhO+G8w9tybPa1/5dJPg6jezMikksdPjQfYArSDGAgfqhAD6MIKGXGz4ZcDS
         Gns2VkRx3JamIjkRHl5qD7QM3ngE0RMRSbmBujD5j6UkXpJSNeIxF+f5l0UlZ96gLsfD
         e8ocPC28HYbWNqnKUaiJrd2Or+UH46JQ11PT8NMuxaYandsGEOmg7sCyjzXgxaW4fveg
         FZ3dEATkX/kYgI3v2Za/Gq+lZGfDGT7T/h1llbU+bkB8ruAWVzTOWimLnbr3ZfT2Or1i
         neQExD7LbZ5foxnlLksSLBY/KjJoixp+BfV9vOhN0D4uwhCAbHdyyeam3QqjM3S/WVza
         j5MQ==
X-Forwarded-Encrypted: i=1; AJvYcCXblltrKZjQgWhQaelFNIDEVvZDD6LQBgKMOeGen6+e6H1QwvD0E57q1+2gtOpbGyszl1zipK0uYQ==@kvack.org
X-Gm-Message-State: AOJu0YxipMUdvIr7kdEHmopo1/ns4BndIi4ZnbxcUBT0SBmtUcnAeS+I
	7lKpntE/L5yeRnK0L6t1mqY9cHCYM3pZeuZIwx7xUQuLT14JIhNjQz/FU/jZOAna
X-Gm-Gg: ATEYQzxwijDpsst7EUXOXCI08KBAI9LIqvsWkRzyUOK47/l8sU0kHGhYh0On1XJ0Nvd
	+0kstlBQSZu5OScJ5NO8NAjaq/aufR78RyF5nyoKzbCphecJXEwB6PCfPLL6bEdwCVSti3umGWQ
	OKeWPro5m4VA7y3hcT1kzFTAkPoMoLbP1BYmeuoPMdl8ozvM5iAzwKnGZ56iB3QWyZ8+p2UqvmC
	yth8VcdZsD9x2jWCDaN74x9jUtm3hoANDYK8bgKvk6uiycblPkKx+0YivKVhci9X3nw8O2mMhOr
	JDXugPPQzWDHOoiUvEY6xZ+FuJjGz8zUq68i5YFvS1T21v07Y2Ay42sk24+SGpBv6Cpr38Tu71d
	8kOejLOhWVr8C4SLKQGjZ86ZrfzooUMv5URPEZRqkRhLY9GxqDn8t0rTH0wxSRn/qIZI/cf8Zxx
	ECdEOB+iY443d3ca4ybyMFiREfLEe79mDy5l3L
X-Received: by 2002:a17:902:d2d2:b0:2a0:c1ca:20f7 with SMTP id d9443c01a7336-2ade99bd62bmr19648135ad.15.1772054816193;
        Wed, 25 Feb 2026 13:26:56 -0800 (PST)
Received: from Barrys-MBP.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6c87a9sm1455865ad.71.2026.02.25.13.26.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 25 Feb 2026 13:26:55 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Barry Song <baohua@kernel.org>,
	wangzicheng <wangzicheng@honor.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Lei Liu <liulei.rjpt@vivo.com>,
	Matthew Wilcox <willy@infradead.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Kairui Song <kasong@tencent.com>,
	Tangquan Zheng <zhengtangquan@oppo.com>
Subject: [PATCH RFC] mm/mglru: lazily activate folios while folios are really mapped
Date: Thu, 26 Feb 2026 05:26:42 +0800
Message-Id: <20260225212642.15219-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 532871C000A
X-Stat-Signature: hstypyae513ktrko7e564pobctradjc4
X-Rspam-User: 
X-HE-Tag: 1772060649-856830
X-HE-Meta: U2FsdGVkX18Ptv7JazOflqHdCNrITMozGv/g8vh5ldkR6NGeb1uslB36aoDqSNKyWiZCs2DFdTwpmI921Ebsoms9ZUUZjHFDkiaamj9ALugPyv9XWpUEsQLMMSx1Wt4yRXPO53HFWl4GGSOH5HmjZUQnsVrmJdD9b2el/ycFgnjZIwQ72uvo8iqBWXtTt+bksDn5xoGHaCWe7G/i1M4z+MRHUiFfjwCVJbgiZChx7r0ysjM94H4v7ueUimaQuhBTh3ThGOIH9oSTfbZmIigV21vShgIBeDl4xqHGdeU53cC/F+UpAmdvNhRhDtnc7oH3A5tzgGn22JCCaaa9EEEouvYBELvdMtdvnj7ljgpoJrksAal/xyupLmS7LW5jIO0OGmZteoHXQL7Y37qUrrHVCfyh67nrMyucq1JNViV5EIYrlz9ezB9Y6oZIwQg2b1/6DPAh/IIPB/4O2dzcb5172rhzB/kqiGaD07jA29Enbeu69qM/FI+9D6sg1IqzHHGjXsBVjXG8/Nb0EBvQ19hTEzlzgclJJ+QAnKPyLxP6VHE1x/Y+qtMSlCFjvjMB2GoUgr9nGZkK+TPTIxti9BlqgwCZzjojlmiZcIZ7J9Y1KBM/xQIlDxRu/h0XUN5npmw2DggEJJpYEuPvEPZEBIj/XW4K60ycgYUkWbZebhFi0Ux/GqYwaKFfxAR3hlRC8mFuIzn3ApwxedNh3i3iBrl94zNAh7YeRAIZWIkCNW4aBt1EpN/3mRc+Y4KRLrtnusuo8DthGmmkqvygzUFmLEKmj4MmP3l5Ofad32ROKwuVLQ+qbmJHd54bCXQMqcJYVfTt+EIF7zvwbgvjD0naD+C5UipdNQAruk/GEiDJ80nqmoT37r8z/2jby/ObkDKLImjI96nr2M6WopoJN3peWEaA99nK/24wDDy40ag9R3/VqZvo3lm3//S47mxy/Fu7+jpf0b+Wmb5grCYsQzUDUAd
 Qn2SAj4v
 l4Ol+sjv6BlcZjOX+acbtYukr+FGWfcXJQ2fWqUnZlWNkqzz5Ez8DpINE0BKtWj55heKD5NevH2BjAX0KXQx2dMcr53QOhEq/IkeU4uiSMN9ab4WA/HeB4cXu1d7V9npKzhn2preHNdGMkUnXxor5Z0Bo5wc1GALDmQY8AqjL5GRzkIPEP8eCx4XmFQurTAIs00/2QbBW9YtFTK82vFVTkkPEGFOVSFfLK+UuRZ6LuSDpCmFFwjidBVWPfGhtxhbO+4bK+GRsT18FW2LB+uqxQ8Z2UIvabX+1G7x6ddlaA+2ukDwdUuqymejFwpdrrc8Om8ZHRJHnHv/z/b2mDlAN43cTfCBNMRmomwFY2YzlzPfzEjuatSAR2bzrM/SgZuK2IwYbtUhFC2l+zsmZzUBj/2HLms5YJED7Vsq8b8qWG+XAUxf1S9I36GBiUiWr7eIrHvcZ4ghC6or4YPQDUGRltTm1AaeLHSHPeku6+fT1VJNOxlSmWlOmFOOBhBGDh2O5uig4GIYdgPx9YM1qFLro7ER57sjjSHgoYFHQPjuot+dU+MWEmMGJRRAY7PwidL1yFqc+G2Ui1A4vEh8UEbEA65Asmv4SdYt/Z9x0HL1cpIxqVpUxBQ59BoacUX776W1gEHhnEvIrmPCab7cgbVH+jBHj6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Barry Song <baohua@kernel.org>

MGLRU activates folios when a new folio is added and
lru_gen_in_fault() returns true. The problem is that when a
page fault occurs at address N, readahead may bring in many
folios around N, and those folios are also activated even
though many of them may never be accessed.

A previous attempt by Lei Liu proposed introducing a separate
LRU for readahead[1], but that approach is likely over-designed.

This patch instead activates folios lazily, only when they are
actually mapped, so that unused folios do not occupy higher-
priority positions in the LRU and become harder to reclaim.

A similar optimization could also be applied to swapin readahead,
but this RFC limits the change to file-backed folios for now.

Based on Tangquan's observations, this can significantly reduce
file refaults on Android devices when using MGLRU.

BTW, it seems somewhat odd that all LRU APIs are defined in
swap.c and swap.h.

[1] https://lore.kernel.org/linux-mm/20250916072226.220426-1-liulei.rjpt@vivo.com/

Cc: wangzicheng <wangzicheng@honor.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lei Liu <liulei.rjpt@vivo.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Signed-off-by: Barry Song <baohua@kernel.org>
---
 include/linux/swap.h |  1 +
 mm/filemap.c         |  2 ++
 mm/swap.c            | 17 ++++++++++++++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 62fc7499b408..ce88ec560527 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -335,6 +335,7 @@ void folio_add_lru(struct folio *);
 void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
 void mark_page_accessed(struct page *);
 void folio_mark_accessed(struct folio *);
+void folio_activate_on_mapped(struct folio *folio);
 
 static inline bool folio_may_be_lru_cached(struct folio *folio)
 {
diff --git a/mm/filemap.c b/mm/filemap.c
index 6cd7974d4ada..0b8f383facdb 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3567,6 +3567,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		}
 	}
 
+	folio_activate_on_mapped(folio);
 	if (!lock_folio_maybe_drop_mmap(vmf, folio, &fpin))
 		goto out_retry;
 
@@ -3926,6 +3927,7 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 					nr_pages, &rss, &mmap_miss, file_end);
 
 		folio_unlock(folio);
+		folio_activate_on_mapped(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
 	add_mm_counter(vma->vm_mm, folio_type, rss);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
diff --git a/mm/swap.c b/mm/swap.c
index bb19ccbece46..1a991586c5af 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -488,6 +488,20 @@ void folio_mark_accessed(struct folio *folio)
 }
 EXPORT_SYMBOL(folio_mark_accessed);
 
+void folio_activate_on_mapped(struct folio *folio)
+{
+	if (lru_gen_enabled() && lru_gen_in_fault() &&
+			!(current->flags & PF_MEMALLOC) &&
+			!folio_test_active(folio) &&
+			!folio_test_unevictable(folio)) {
+		if (folio_test_lru(folio))
+			folio_activate(folio);
+		else /* still in lru cache */
+			__lru_cache_activate_folio(folio);
+	}
+}
+EXPORT_SYMBOL(folio_activate_on_mapped);
+
 /**
  * folio_add_lru - Add a folio to an LRU list.
  * @folio: The folio to be added to the LRU.
@@ -506,7 +520,8 @@ void folio_add_lru(struct folio *folio)
 	/* see the comment in lru_gen_folio_seq() */
 	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
 	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
-		folio_set_active(folio);
+		if (!folio_is_file_lru(folio))
+			folio_set_active(folio);
 
 	folio_batch_add_and_move(folio, lru_add);
 }
-- 
2.39.3 (Apple Git-146)


