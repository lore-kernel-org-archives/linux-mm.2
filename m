Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D3BED7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 837C56B00A3; Fri, 19 Dec 2025 14:45:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81BAB6B00A5; Fri, 19 Dec 2025 14:45:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718D36B00A6; Fri, 19 Dec 2025 14:45:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FBF76B00A3
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:45:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 335D2140334
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:12 +0000 (UTC)
X-FDA: 84237249264.24.6A37E82
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 29EFD40008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Qnu3W/f4";
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xBKZWOds8khsJf/1rWCdSiGA4KHr0oVaNprz6OLz6qw=;
	b=Sr7N+bJmbmNsjHCtmZSDn2Bxb6aqJRNb6aqiSAqDZdT9cpjhmGNfjfbPT3tb8AMBrRVEFP
	R8eKmO6HjSBeQ/Mgbvnf/TGYt+GC3q432fw91y177HmMZ0ISdJUUcp5NQ4lQhAI7NZ37Wx
	5W43aApJUIYCl678r2ThQeZbcnO2wCM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Qnu3W/f4";
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173510; a=rsa-sha256;
	cv=none;
	b=j3BuVxfgG/Bnn6mQGgqommWa9pke6sixq0VpOXQg3YEsXaJY1/GVPBKTNuZmomKS/F6yqs
	wPeEvR0ykmVHcgHS5ZugvHe3d/oMM7JwU+GIzAijAC0tTJvF1VBsaIQH0iPig0Lfve9AuT
	VL7NRCN0I4/81o/qCwob2udB6FH9AEM=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a137692691so24575775ad.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173509; x=1766778309; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xBKZWOds8khsJf/1rWCdSiGA4KHr0oVaNprz6OLz6qw=;
        b=Qnu3W/f4W2adpMeirLgSnhOZZiFEVnVA9wkk32o4Kc4QUJMeX8vnmS7PnH5hFlbZj+
         lQrHkdtFANMVp2ixdfJ3Wp/vzf3IsKNiFaCYWLi0mQM/PDhISIjFUHGNEcIfc5of81H4
         DdO2YSq5ujvgxkwmDix+b87B9PhPfPyhrOE9tnZ4ccJP7nSc6PeK1BTOl55yPBEUZa7n
         NBDXM0AMAcqNWBVxpL6kOLodL70Bp4wRVbNrfvXCPt+VYXOQE1soIxJDmb8aAM95XYfB
         HDljJS4pYx3Nfb/xkGfOaW/LNw0VN5CgqLaY7ORcv9BQtIaxXDV6fBvUI6/TIrbntdjL
         rNtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173509; x=1766778309;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xBKZWOds8khsJf/1rWCdSiGA4KHr0oVaNprz6OLz6qw=;
        b=duV8meqEBBLe9faRr9ir6MXuq72LoVgn9EDAuW5nTySY++N79TpVGHJEwR7H1blW7C
         YqaB1O8sxDP1geN0yemvpRjem3tQSgyoFpXPL1+whiYgdoC5enjXiMh9v0IcVCJUG80s
         qSM71JNwy9bUu1iWikvDrtnhbJzKotYvWfIj16ybtH6VWnhTw/GBvwR/DJsG6iLk0eqH
         Isvk3MfTDUhXkvi/iSYAaMAIvtkDNBb/YAwE3nlHsrouHnHYcK/We+pihvW/n90YW8Gp
         VPpZadA3/TITe8VYw+IWq7NZnrsZXJztKTRBi626AlAY+2XXto/4GHmJiydzOKbSKBUt
         kKag==
X-Gm-Message-State: AOJu0YzeYt3ChitgFIIvbIULqg+Q3Tb70nuAeq8LFi4HkJP3A3cT5ytA
	ILjHkuvonh5R0vtjoarhhOUekZ2NDxGtfY8Ny6jlkzcdQ8ZeS8cyS12P
X-Gm-Gg: AY/fxX5lr9Gvr3+UNsO2gIYktB5XcOWW44+/ZqbF5N1YEWyG4G3Wr8AHwVMbTHmoESx
	BhJcZi0dFGFUMYknNS4AhcAE0a7bcOIUr4pRgSYFYoUUifJdkBMXCf2icoW0B2HLM/pcaX4qSNB
	aOGmyRDlqO4fh3qxmA52qvN3BOfP/IPMoeDGL/eOvxVqPDtGOVHjTtEPZR9od1lM6ZxJ4Ivsl1+
	6XxSLgFfJqLFxQtntHHnoYcewitXSe9lLJh3/WCH3uNV8zVwHGzideIic0LK9QXCMeeA1t0yUE9
	8MRSaKEs6niR7UGHd7SwwkBxi8qn3SyxgNAmabGc2tBO6VrOHN20RhC6YnkCsddchuYEOv2F3W4
	cCGorwIRdfvRLTZYxDix4L+4zYDjZol6XoKj/57DNMe7SCaBbap8079nOtOzVGyJQehY9VVvBGr
	V6/KkQOCPdU8Tc9uAYCBWmY09fXMta0mY5kCI5PLQ4fLZIHBsiwJwv
X-Google-Smtp-Source: AGHT+IHue++AcgUKNm6UdMDh1zNcM0NXOdchpWQN9jVvmWptaNwbmQipzIOUzW0NdJKVXkmlvjqurA==
X-Received: by 2002:a17:903:3508:b0:2a0:ea4c:51ed with SMTP id d9443c01a7336-2a2f2737055mr36006985ad.28.1766173509044;
        Fri, 19 Dec 2025 11:45:09 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:45:08 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:40 +0800
Subject: [PATCH v5 11/19] mm, swap: split locked entry duplicating into a
 standalone helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-11-8862a265a033@tencent.com>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
In-Reply-To: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=3237;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=MDvljxn/+eOgDP2I6U2bGDv2Q1tUhJNmxWn5F/I5OZM=;
 b=N1iJmzhWEqsEhTA8SJSJWKN/UgFnp4NM2qNl8VIkZC1as0rpeYYh9nM1MrAu58kx8XtQRHPA4
 2pljakNoMLvCwIWc78Kq0oebSA97vZgBAlqipn9ojXj9h245ptzY30r
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 29EFD40008
X-Stat-Signature: amjob98t6ab9qzw334qjcgqak9ji13ww
X-Rspam-User: 
X-HE-Tag: 1766173509-119598
X-HE-Meta: U2FsdGVkX1+K1nebhAAQnZv1Kaw4wNhVfSxYPtABDbPtTtdP1uS7KIzCy2/OrDqE8NkkkI49MYLL1F3+PxIs3e6Z99e8oHTCUi7r1KjBkbAfbnZqby3OXo/oVXsYpqnW7n24oz8dGHQvFLeSU3tqNdjxiperYbEFINHLcN+1EsXpx4KqrdjqOUliYpJ+BZffH/+++TRQ3T1DdA2ALN1bfN8ags/XuejdwiOZPmR5zr+sjdx8DgiUCaTetzXpLf+HEqsNOoyecnXOV1IecckvqU2QpTHWywDM3PqnROu6A1msOf85xtu0nlt9HfpiEHvlwMUXUUBrDztZ5vyP7HIE6O5S0E5SBbcPrIH7vcldTo3HcEZs3GsDTv1sHPMeH1z+xQ0irESfTQ5OdqiwboAezV/RbmILABL11x3eZgK3pQMHnRRnLLc3Yc76MPr+CEY9HUVH3anPvRI5INuWCXoZ9Qi1ZmIKROnoWje2p0ujLWtPZ1j6iwbpVt0WJcuJNr56UJmwDtLIiCN0IyYutm5devE2NpuZ7DQNGuLtkk2gnoccgM4xpXj9zsoGrrFt2ecrRKbUspntd67RgkkabPxZmXMIOoWEjUmtTvxBKBY75tBe98iNcJBEsWBrIqh+NLvRDPLtX5ZnW6CHlB//ZAigIdGpJnQtiC2kuxkE4dvZNdgP8WYElWJkAb3WdHZNK7Pax9wAajv8lc6GnPd24RkrUrKouyMzcF3mKrGE8nTNqRDhioLjlsy+z4+6diM6PiUKn1f/zLXrw+5rMoQrkoHEksPrGOYfalE+bgdwnAy1eWZVsi6MQNISspzonbgDEYrjQk1tV28HdUGzSwvq0Z3qz1cIg6a1TN81DdX5i5YQ54a5rkEp3XPVT8Wsen8vhInbLSS53GE60+T8YALAHwCs9SdsdGIh+F/WUkqK0TDczFSCLA0O2g2pWJW6WLqkvvFsxJbdI4LXPXopD0EmjWA
 0d1jicjg
 0UvHypGjkpgcoglU1DqI0y7AzEc4XDvD6G9TFnBtpRgSzhYa+kYeggkGbeyrdJS3ijsF7pQDGszn60HGExCIM+PT5hvhRtKVYHh6jWLq/inB/ZZyhWhHgPS5WqJaah/15CUZQta5oclnkV2pcjxHfCwW06DFFVBMSQAYFuFSbBHCG8ofII/ebJqnpQkAhdgn7t/s1UCRnpPISYJXS41eOE5kS5a8+lYLqP6tG+kfceYfUAs7sdqNUWks2UjYTs4c63ieGfYp36kCyS0J8VQCRCOkdk5BR8bi9tuVKwq/3OZ+NPor87HiteGfCG7gedAAxZf0wLuEL0NFimIT3LGaP+UjS/7dcEtMvxH/PxOOfich94JJEqUAilKma8ZLIbE122wa/jegyH26D0VG7egsF2fKpsu5WifLf55dg+pzIyZ9wgeUzFj2X46KDWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No feature change, split the common logic into a stand alone helper to
be reused later.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 62 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index f3516e3c9e40..c878c4115d00 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3667,26 +3667,14 @@ void si_swapinfo(struct sysinfo *val)
  * - swap-cache reference is requested but the entry is not used. -> ENOENT
  * - swap-mapped reference requested but needs continued swap count. -> ENOMEM
  */
-static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
+static int swap_dup_entries(struct swap_info_struct *si,
+			    struct swap_cluster_info *ci,
+			    unsigned long offset,
+			    unsigned char usage, int nr)
 {
-	struct swap_info_struct *si;
-	struct swap_cluster_info *ci;
-	unsigned long offset;
-	unsigned char count;
-	unsigned char has_cache;
-	int err, i;
-
-	si = swap_entry_to_info(entry);
-	if (WARN_ON_ONCE(!si)) {
-		pr_err("%s%08lx\n", Bad_file, entry.val);
-		return -EINVAL;
-	}
-
-	offset = swp_offset(entry);
-	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
-	ci = swap_cluster_lock(si, offset);
+	int i;
+	unsigned char count, has_cache;
 
-	err = 0;
 	for (i = 0; i < nr; i++) {
 		count = si->swap_map[offset + i];
 
@@ -3694,25 +3682,20 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 		 * For swapin out, allocator never allocates bad slots. for
 		 * swapin, readahead is guarded by swap_entry_swapped.
 		 */
-		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD)) {
-			err = -ENOENT;
-			goto unlock_out;
-		}
+		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD))
+			return -ENOENT;
 
 		has_cache = count & SWAP_HAS_CACHE;
 		count &= ~SWAP_HAS_CACHE;
 
 		if (!count && !has_cache) {
-			err = -ENOENT;
+			return -ENOENT;
 		} else if (usage == SWAP_HAS_CACHE) {
 			if (has_cache)
-				err = -EEXIST;
+				return -EEXIST;
 		} else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX) {
-			err = -EINVAL;
+			return -EINVAL;
 		}
-
-		if (err)
-			goto unlock_out;
 	}
 
 	for (i = 0; i < nr; i++) {
@@ -3731,14 +3714,31 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 			 * Don't need to rollback changes, because if
 			 * usage == 1, there must be nr == 1.
 			 */
-			err = -ENOMEM;
-			goto unlock_out;
+			return -ENOMEM;
 		}
 
 		WRITE_ONCE(si->swap_map[offset + i], count | has_cache);
 	}
 
-unlock_out:
+	return 0;
+}
+
+static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
+{
+	int err;
+	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+	unsigned long offset = swp_offset(entry);
+
+	si = swap_entry_to_info(entry);
+	if (WARN_ON_ONCE(!si)) {
+		pr_err("%s%08lx\n", Bad_file, entry.val);
+		return -EINVAL;
+	}
+
+	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
+	ci = swap_cluster_lock(si, offset);
+	err = swap_dup_entries(si, ci, offset, usage, nr);
 	swap_cluster_unlock(ci);
 	return err;
 }

-- 
2.52.0


