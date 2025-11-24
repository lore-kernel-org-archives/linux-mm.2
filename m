Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C77B9CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A51E6B00AD; Mon, 24 Nov 2025 14:17:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255CF6B00AF; Mon, 24 Nov 2025 14:17:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1449C6B00B0; Mon, 24 Nov 2025 14:17:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02D5D6B00AD
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:17:16 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C66E74F736
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:17:15 +0000 (UTC)
X-FDA: 84146458830.16.B533753
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id C24C74000B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:17:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kcpp4UYA;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ipXeMGLwUS00AgxE4fTHfgEHnRGf4+zO4yZv4QMX+tY=;
	b=x8fTpcFUJo+mut0T9JyZRUQxQaVxzr9YH8LeD5TlwhkTuz1yHi0u1DNPToHumA/ZLKyuWD
	b33LbV7TKs4zLSGyklL/9SooQkAcNpcNE/5G8ULmg1Is11x1+LbCPQPl+NW3QXxDfoVoqV
	9FI0ri5AtMuh1szWFgZXgE/ZS54p9ow=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kcpp4UYA;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011833; a=rsa-sha256;
	cv=none;
	b=x6pkrsXd0IXh+7FmIe9t5eoMiOOwt4vAjtLGjpqtKJqmiWjSlUVP4dQcmnnVYN0J6y/NYg
	IQTKKuPb3r6pFjyryPkyc4X3SwMJOtnZemKy5D7ajjClI320MO6+lhXvP5aWCVgMs/U3eV
	2zHwwcZoMDwJdkQS382DMkfRAKdrn9c=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7aace33b75bso4336250b3a.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011832; x=1764616632; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ipXeMGLwUS00AgxE4fTHfgEHnRGf4+zO4yZv4QMX+tY=;
        b=kcpp4UYANTlM4++DsOXVEHu+GT3fkvAzvohlmFolhvgTQ/ttYLRMGiZfb4xyDp4V6Q
         SFqeMS0SEmW41WP2D8SImV7tODzKjrI1hFWWQCxybawtdzMCGfgL1bXlU14p8U4QPdjm
         VpX9+Cgke/+rQ5WgLQYM1mdHbpP7atRkBG/XvuSlpgoI2gKZdAsVOZNb9s17R67keVD6
         LhqteBcJxk0xwZ+tlM8qW2zTJAwj+LkzWXHNXUSZFHx9qlaBBntXeO8UXdUh+qeuMZ7B
         2ch0BIy8a8ASiTj3tjl5i1SkPeuYCDWePYbMhScKiIZQXioJuYx6Ov8tMP7KjficfPGD
         DwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011832; x=1764616632;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ipXeMGLwUS00AgxE4fTHfgEHnRGf4+zO4yZv4QMX+tY=;
        b=YAPY/3IR4kJFG/snjFnb8XOKrNAqDKbNMtgW3yaIEhD05KsAzS/jP1uhXyzc28uPNe
         P0AL+3yPWWMo4AgUHqs3S65C6Jwar+E8EIuzHrTlOx1zUBST8UPDDbD5suI4Qvfrydgd
         5i1rKD0H595EDYDyl+/kUtvGdGWI8qi9qTBZfrjj5nsOGbUrl8L5sGS6iXYjXzEh6xan
         dfWlW92+eh02dJnotSwI7CSUT/iTmw+GDVcMki0y3BgNj3vJS+iixzUFFtXXdml26Fhv
         aTzyCbmA1vP/H3d9SrcwATkElyR84/sqFI7mZasgPnonUwhqS/1ij231GUmszsfxJd71
         nTXA==
X-Gm-Message-State: AOJu0YyEUCfu/+Te5k8swulBd+WWU9XKT/hJP7khLeN9IOthAbmk9UL1
	8gG73VG6lk2G4v3ZwRW5+W5lY+yoT6aGpaHNDa2vvogwnRJg1T7PK6yQ0BJmsOlVgOI=
X-Gm-Gg: ASbGncvzdTDMQsJdc1h+GxUvq9hJVlxbWTwBFI9KFSBt2gX36DBWx4gGXAt8UbVaj+L
	f7u+ZW7mee+PMyQRgekTSNNFlPZbrjQDOw/EUCvPKobau7S+1XfOT5OjtoootU4l4qjW2H5ET85
	5kc/fqGw9PiObGcjBrCsSz1Ilu+FlWpoI1oP7k9G7ADrEHZ9oHkk5xTkdpQNmNd6/49dOSB8npD
	azNz9ZqMCC47sPI0g/dmS+hSVCvSXhgzpmCUI8QaZczyqiEGxPRxePURL32Ld0zBF85BWl1fvr2
	9Ha7QcZiB4EO11HvGyDygAa0HUbL9MhARbrSGVeue6tq8CwJqiuk5HHCb55xed9UcH1qcYYFcz1
	6fXD0OQ84BTg+Z8YICDjYsSkmqtk1iNcIk8TWDxsVmqf7VuypRhXRdAVO90rG4UY01NYntL+Lyd
	tZAegSi2UE846ycJHlVAqjhjRHZ2cIO465TgD9FOUdiiBdIXKi
X-Google-Smtp-Source: AGHT+IF9pmdrLRfwkVSrwzmwVH/8sR8ttEwuXPdu0FQKbT2rnRW0P3S5L6s9lD9AjOwFibcZl8+83Q==
X-Received: by 2002:a05:6a20:9189:b0:334:a180:b7ac with SMTP id adf61e73a8af0-36150f05e9bmr13653593637.39.1764011832539;
        Mon, 24 Nov 2025 11:17:12 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:17:11 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:14:02 +0800
Subject: [PATCH v3 19/19] mm, swap: remove no longer needed _swap_info_get
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-19-33f54f707a5c@tencent.com>
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
In-Reply-To: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=3397;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=C+wGETtNWjFBAIszWBWUQ0AB6Ts3cedoLdPlGNc1qko=;
 b=xAXi8hRLR0CKEwSihjhMaupTrBszmAPy2MMlSOA+zsn3GBmo/KsQJzG0X12L1V0ywNHH1JQIZ
 wj0EI+ZhtflA+uAjgX35RDPXjkdyoeyNrh1egeU6J4HBvuZNzMCHHRh
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C24C74000B
X-Stat-Signature: gb43nsrhrx3t5aqp71q7c35hm9krjcgo
X-Rspam-User: 
X-HE-Tag: 1764011833-365948
X-HE-Meta: U2FsdGVkX1/WcR3NhYrsee22HcCHwo3qsTdD7Olwydz+TRqC1hn0pRxQMciAa7a4aOwSWZdLyez9S8UVKAOYEuJ/wN6g0QQUwljzQcAy4R8rZkFXQ95OG0njpm+f4Et033cm4jq29kVHIabis5ELr1JhHtQqvFu5cEApUHaT20Hu9UDrwVmCCQIWWQwHMTkVnRQrcmRzR5Gtevk1cvWGc/NFjAyU1DUZn4ceJIia8+xkkQC4o5LF1zs383YVjyNg2MW5qG2l9Akueu1x409FAs2k3cUGd1Mnd/fP30yWZt5ns0IelGp/aod6nE5KcgwiMDaQASn6YQ8WALPff0KEhJWo8jAAA457EeKy7tI95dXg1uEntEP1cgD4EhdlI7KtB99TGNqBNP2cAKqOgG+fAHMH/cBujg236N6fzsAuX0ghLs+Nzm8wIATSxJ5lFhEP9oWdo22E4IUAfot/3ID19YnO6G/CSdg5453+GykAqt/rvijMUa10S35Xl1UdhQ+f0u5FLhcV1quyazxbPssX6ebLCiJs2QxxHhFNYpg9JHfHqZrBX+PZW9e0k5Mtsczyu5ERBYOn9uTsL8Vkn5i/qR7jp7wOpPojFfymRt5TUF/RhJAirviBj/pOQGK0QnN5Mh/QJZ07HMC3LkSfQdPKVnZuY2xPT6R8VsNngk6xol+xjmoiSUcOZMsyO7hvJ99hVI4H1kPy7oBq2KGzlgvel41w8xMb/prsSSHO7DC5HZMrMTqBJPoqYTqM9gUnTSmTnPHimPvU0VP/GXYVADhCCf6QxqB5f1B0VG6WD5WgvF46723J+cRYLL19SIHiaNQZW/kFIpMC9YLe9QBXlZk39mGV0ayzpyhQjswPFYvdaF2ZQNk+x5aAXGmovS8cRExt07vsHUSHe9nBXBzSQ5fGuR5SouRdKk+3UNjoMuJM6Q2QaNx6+VF8T2jin5y7cVGangQkXZvM+XjLihR4/NS
 5GOowQjt
 6vYpoJ9pmCX5wfjnzAmmxdWGSSp+TnfDbt5km/dSvD+c4ymqtu3Zq8a5qTv26K8F6t9yVG6/12ZOwbjoaykQGL6TC5CQ/I0JWvXCvueCHEJTbjqrhxh10+MZGRpFyBYZmdRTF22jBmNju2BJosdmfheU8hio0eB4SPAVhDpw77wQBSzZO5K0A7rQZa1kPcM8p43wuY/ayM/0yC6sK5HLpNI/cBU64Hae+RF3lVxX60Gjotd6AFopvv8RePErApRTSvgzWIzJSywC5/PEPamDLFBujMaCeIfNOvGEk2RTp/PYV49xraT/8pXfDJgjWxxGQ7/Zcjqd455DrQZnwY3vkFNgBSovgCHfV1hS2UjbypPQTpJ1amfnJQJLdXfjm4H8g1KyF2+fRHYcJzKvOtoXr1CMqVlboJdljjNfkAs+NC/6UXnwdv9CiqmOHL1+1dFwRvIGg3/hTjHu44Jp3XNfj7OYroY+B5vVxAotB
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
index eea904dc08d9..feb57e040ef1 100644
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
@@ -1588,41 +1586,6 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
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
@@ -1781,7 +1744,7 @@ int swp_swapcount(swp_entry_t entry)
 	pgoff_t offset;
 	unsigned char *map;
 
-	si = _swap_info_get(entry);
+	si = get_swap_device(entry);
 	if (!si)
 		return 0;
 
@@ -1811,6 +1774,7 @@ int swp_swapcount(swp_entry_t entry)
 	} while (tmp_count & COUNT_CONTINUED);
 out:
 	swap_cluster_unlock(ci);
+	put_swap_device(si);
 	return count;
 }
 
@@ -1845,11 +1809,12 @@ static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
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


