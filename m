Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82E81D2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F776B000E; Thu,  4 Dec 2025 14:31:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDF996B00A4; Thu,  4 Dec 2025 14:31:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCEA06B00D7; Thu,  4 Dec 2025 14:31:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A94606B000E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:31:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7918916038B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:31:09 +0000 (UTC)
X-FDA: 84182781858.26.6A39293
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 47E9AC001B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:31:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=afsk2n5H;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876667; a=rsa-sha256;
	cv=none;
	b=Z0sAT5aWJ/3dlxn5swTA4SxkeQcyHD2uC0f9AgeTeMPl5wjb44axevGF59InFhnPeuF+Mw
	EkigJrOOJBOdGje4HnPUqY3DY6iTvP6TSSZlAe3kJzb5DlPvwMO95ND8GEDJSkpMsJCarJ
	+yT6AeyWRTX+lzaedlZkyRCOypKVKjk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=afsk2n5H;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LIMoyBwJn7av90qkAfxn/q6wIjiZW7ZSAh6MwAXyokE=;
	b=4rJsPWVLM0c+CEOVbekh2nCILgaxX16NizbZzky1MDkBJxlrIFIh4E/isqCGB4KdZI+wfk
	NAPLcMzDEFQTwRdGtri1qsUo30PFVzwpao0mMCVZfffW1MlmdYcu5RG0ipzM0BGgwjSor6
	OL6YzbTTAng0c18gKIwuPVIFCGXkHmw=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3418ac74bffso844947a91.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876666; x=1765481466; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LIMoyBwJn7av90qkAfxn/q6wIjiZW7ZSAh6MwAXyokE=;
        b=afsk2n5HMTeXPXy6fTWrR5+goPgjvZ9mBwJBqjclhxHdqNWPODN6YQrKax1CscB2Va
         Qoy6NJbC+4v8WzAVFTAKPoMRronZE36BZUALJ0qziXyrOPwad1z5Vok9/jFFlRxSQfb8
         v98X5x0NsFR46K13OgY4pX+ElPub2ugb4Gx5gfQQBhXWhK8oDyj6zcl6tL8/r7X/Uqy2
         RVJON/UUQJSKufHuHTq8flJvD3sqcuRHtUMAuK8O3YuhyBt0+YE6Q7gy1DsZ/wQpSpJM
         vs+zjWMWA8ZJvmBH9Iaf+9OC/Zvd/5TAgW61b6RNa66BBLv1zPIUbXWAjD2bFXyWMeDL
         2d1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876666; x=1765481466;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LIMoyBwJn7av90qkAfxn/q6wIjiZW7ZSAh6MwAXyokE=;
        b=M5PXT0a3e1TXVZjyouCmeQqrFwDq4heBdjs1NYK1QR3h/556zdCLWup33u75MFSKLS
         1El1PwkO1zOy3j9fXBQqxshcK5JWZ/fHnswQOU+/0/GIzYfWi9QLGJY+hHpJgDg2fx3n
         H2PgpWSv7fQlhM7G7axctliB+edFVzb7r44nlnR9unUJcCLp4OmTFxJpfyHTn4B5dYXL
         +TYPrXaD0dvDGMsno+T0hrXnA48VUxCvADKNlp0r5SIB5AngAp0c5KF8g2jlFJ6dUK97
         FNTUPUi1Gz9HQicZadKO3ROkseNM/Xnt2D9+/+XpNQyU8eU/0dTVHNx1oHAOOWWvqRVq
         GZHQ==
X-Gm-Message-State: AOJu0YzHjAMZHJ85Ns+fj3mjvV0bpkJOz4vEldZAllta3FRmpkF+nR16
	k8SAAEqO9xO8vLmIu1nNgNj9BGAE6NemjDwbyiGGtpQHlK8mMsMFIOV6
X-Gm-Gg: ASbGnctyRNK3YiAh1Y1YH6JtJzQuD2EBlgKJWKvh3WTxoFPuzvzslwRF1nEHulw8gsN
	CnuhL1Ms82e1tePieAcmk0Z99+iLZymyg2G4kHCOy9XaTG0Nsg8Hpw4Im9dT2RJQcfXGJWwPcmn
	LiQH4U6SgvsEWj1KkgM/qScgbRBFGJ8xcZmYPJJvQlg73V71ke4QvZPJrdTTuKKGRwjHRvBPyP4
	jFyhobaYeerusCbZaV4b3WMvChEWS7frW7xOGYdOQj333Li0DFEX1tCmSmkWGeGbHdzgzudfzLF
	dHGVY9+f0+eZ9ZOZwhw3nS1t7uzpXV3OyVh6NvJ9senzTqfUuTqMlZqSy3nJZqfg2D7KnnrjoYO
	H5pG16hnuIvFFgJGY2xo+GJfkPLIaQ5YYYd4xJD+08ZZKl+HAe7hXkqM7k8Z7OpXV7WYFHsUN2f
	eHJcoRdpGzHjnDQNJ7H1wsc6q1DqQZtiicwaEax2s3BwC5E5tlfXFqP1fgauU=
X-Google-Smtp-Source: AGHT+IHc7nv/4V6WzRg5ybDSnfl1DlbA+tXjIOJmCku4lUOrp+NzASqiXTTHgcTYv3FBrgDA7wq+wg==
X-Received: by 2002:a17:90b:4b82:b0:336:bfce:3b48 with SMTP id 98e67ed59e1d1-34947dabcbbmr3753351a91.9.1764876666104;
        Thu, 04 Dec 2025 11:31:06 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:31:05 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:27 +0800
Subject: [PATCH v4 19/19] mm, swap: remove no longer needed _swap_info_get
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-19-cb7e28a26a40@tencent.com>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
In-Reply-To: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=3397;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Hx+6RnEV6CvOtID5C4mncKak3zAk83r8RmTaFWHQlOY=;
 b=KjUWPjf/oIz3MVxWSNNjn0n/F6ra+PBZg3ElsA0eu14B/aoaT73yAjmo6sF/TjF54R4crzumu
 indUS8L6+RJDdd6gxn9Behlg073fv1wDi9pSKEpUf282zsXcF1vZqEZ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 47E9AC001B
X-Stat-Signature: f83h3rj8rd3ng863p1jkm3jbkondga8y
X-Rspam-User: 
X-HE-Tag: 1764876667-218181
X-HE-Meta: U2FsdGVkX1/JRi6IpSiF7LCvvc9soLRhjKyA2kS2CJWGCnCaoA1bZez6VoVt2eOCLtJj0MJWsjk7ljbc2imGNXmabFtb7eSB9muPJsm583QUMMvai/XVyZenYjS/s/BqoJYjFAau4V8vPvpj6ZTSriIFeQCZBXEK7zOIf/iZmgoxrMOWZQR1fprggLh/QovUO1QbRYnagrF57Rc0LWSEES6vuVPzuwJzTpWNLUE88M9N4qVXp8hf3cdo6fL61jRVjJTgyVYE3d7ztr4jVbcWJfGGP5M/8yKX1WD7Ck9jozb3VVn29D3//Xz/20XuJ/L58ZJQ9szUOqhWtCUIEZ/NYY3U4SinOysn9Bjjb7nSg0o0TpoGEDEaoBXDRtdPfaeFvTUYMzFcqTD3G8yP2xRI61sRgY/unxSL52ahwLAVEjJ8H4U60Jk4gFuSgsprDDJGthlYN16YB/gU1ivJxhlqw2oMRJSpeIdvofXA15IAkkuDhGhzpneRaInTiMkpvKIQuAu65PxOW/k2L95c/KCPkEeJ27lZ5sy2MUSqf7FJHertr3ybxaxAAWJ+vc/cAl4im11rXKAr+DU/32fxqIzRwGOLbfgeoo0Otkhqn7ABXqWE4mFndKteoxjGxR4x8FBK8tpeARgUTO4PPs1JgjgTCc5+RrPtF1JHCoYUJBWhCzAGRPH6QKQ+xxodhyRPBkYrMgL90d1i5QMNHbvCQjcKS81k+//7iKNrp6MkCiz/HcjEXdZ65rb+JwRvmjn29KB7rVdQNHj/SQTDhilpO9x5HDrhPlz865x2wYk9EgXQ9g4IRxVTBkYtvK6uM/PM0QmIguxsd05fsnfvYE2X0TJlLKPsv3eykseG3NmkriRjs9wttIYccvqfBTqERdei8ZxgEyq6SfiPQ5DRYwiAVL3GQqTOM1ROF2c1KxsLL48jUrkL9LK02tzM+hwgxHxtuWizDvh//782ZX2M4aBeSJG
 1wau6NHu
 O+tKjBb9Fh9pl6qFYYnFYl6bQDSfC18StFznd8K5HxpbY3aveN+Vy5L8i5irHHADSu/Qx5LzQrdEGo5PVT78kjcuwFbs/dSKQ8v+2TSggDpBpYXSmcbSidCnyOFLzMParVU6cMYCEZeSAq0f0rJ8gQ8iA/+blF/w0Iquz7fkk2jCncpfa6iQcx+5787wTIpzEC8pN5l20p5ie1azfibxMz7yW8945sdjiCyR+l/+p2QmdEERaWkubC6dS6tySgNie6CUTa/MFDYXDcrMrD07tOfLHq5nOAiOeuHCc9o0WDFp+ABqMOWFxZDu06zpLPqA/PQWTPz1AuJrSLFX71qPleCU47iwibcWOsVedLe49++8wTuBzt2RIlh3uoGtoS85aGuyE5XgPuaSzJbC4YePv+Dh6Fu0mN+4Mewz5D3SpVv9RXWH1NagY8jCgKwDHkmEug8nDuwIa/Nrko92rk7DjCGjXkPP7OlUMyfNR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

There are now only two users of _swap_info_get after consolidating
these callers, folio_free_swap and swp_swapcount.

folio_free_swap already holds the folio lock, and the folio
must be in the swap cache, _swap_info_get is redundant.

For swp_swapcount, it should use get_swap_device instead. get_swap_device
increases the device ref count, which is actually a bit safer. The
only current use is smap walking, and the performance change here
is tiny.

And after these changes, _swap_info_get is no longer used, so we can
safely remove it.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 47 ++++++-----------------------------------------
 1 file changed, 6 insertions(+), 41 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 50ed2d7f5b85..ce2a34858fa1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -83,9 +83,7 @@ bool swap_migration_ad_supported;
 #endif	/* CONFIG_MIGRATION */
 
 static const char Bad_file[] = "Bad swap file entry ";
-static const char Unused_file[] = "Unused swap file entry ";
 static const char Bad_offset[] = "Bad swap offset entry ";
-static const char Unused_offset[] = "Unused swap offset entry ";
 
 /*
  * all active swap_info_structs
@@ -1600,41 +1598,6 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
 	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
 }
 
-static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
-{
-	struct swap_info_struct *si;
-	unsigned long offset;
-
-	if (!entry.val)
-		goto out;
-	si = swap_entry_to_info(entry);
-	if (!si)
-		goto bad_nofile;
-	if (data_race(!(si->flags & SWP_USED)))
-		goto bad_device;
-	offset = swp_offset(entry);
-	if (offset >= si->max)
-		goto bad_offset;
-	if (data_race(!si->swap_map[swp_offset(entry)]) &&
-	    !swap_cache_has_folio(entry))
-		goto bad_free;
-	return si;
-
-bad_free:
-	pr_err("%s: %s%08lx\n", __func__, Unused_offset, entry.val);
-	goto out;
-bad_offset:
-	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
-	goto out;
-bad_device:
-	pr_err("%s: %s%08lx\n", __func__, Unused_file, entry.val);
-	goto out;
-bad_nofile:
-	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
-out:
-	return NULL;
-}
-
 static void swap_put_entry_locked(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
 				  unsigned long offset)
@@ -1793,7 +1756,7 @@ int swp_swapcount(swp_entry_t entry)
 	pgoff_t offset;
 	unsigned char *map;
 
-	si = _swap_info_get(entry);
+	si = get_swap_device(entry);
 	if (!si)
 		return 0;
 
@@ -1823,6 +1786,7 @@ int swp_swapcount(swp_entry_t entry)
 	} while (tmp_count & COUNT_CONTINUED);
 out:
 	swap_cluster_unlock(ci);
+	put_swap_device(si);
 	return count;
 }
 
@@ -1857,11 +1821,12 @@ static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
 static bool folio_swapped(struct folio *folio)
 {
 	swp_entry_t entry = folio->swap;
-	struct swap_info_struct *si = _swap_info_get(entry);
+	struct swap_info_struct *si;
 
-	if (!si)
-		return false;
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 
+	si = __swap_entry_to_info(entry);
 	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
 		return swap_entry_swapped(si, swp_offset(entry));
 

-- 
2.52.0


