Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD53CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DFBB8E001B; Wed, 24 Sep 2025 11:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7F98E0012; Wed, 24 Sep 2025 11:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8A78E001B; Wed, 24 Sep 2025 11:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB97C8E0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F994BBE43
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:26 +0000 (UTC)
X-FDA: 83924454852.21.7F342C8
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9600B4001F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Tw1i5J/K";
	spf=pass (imf07.hostedemail.com: domain of 3hgfUaAgKCDMYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3hgfUaAgKCDMYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EzrycjTVpnWNKj7lM2bs2OjeckNX2GUUhGCkamMVlMg=;
	b=a/4Bk+vk7NO/iksBbEz4qmodr24gUQKUJMIVRifLsBIvazHv2KfQAgkHmgpx8iLVcNkvwm
	Jt87hPPABIso+9BC1KnQYnzG8R34zjRAEAP5R7xEpDG+H+d6t2FxqAh2DKxDjpaB+ODXCL
	YSXur9exy/QZuKOZnrxGY4X0VcrmUqs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726024; a=rsa-sha256;
	cv=none;
	b=EyygqDT1UiuqQzHajbOhL0qcRqWFDgkbSE1gUB31dUuLBog5xbpSE22yCx2KuKP5DoWEQr
	kLc49Syj05I2nuJ4yUZ5neIb71evXcpG++k0PDB+DjN8XK5JCHBiC5mV5QiEl08WfTdYGB
	lp96MR67oJXXHLNEdxS/ievHQSJ4OnU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Tw1i5J/K";
	spf=pass (imf07.hostedemail.com: domain of 3hgfUaAgKCDMYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3hgfUaAgKCDMYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3f924ae2a89so3319221f8f.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726023; x=1759330823; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EzrycjTVpnWNKj7lM2bs2OjeckNX2GUUhGCkamMVlMg=;
        b=Tw1i5J/Kao9vWp1+UDtikjA4522+Lc23BLWp5bbhaY4fQFPCVNgkFuuRaFVAiNWEfz
         3TbyB6NW7IEnmctIQgpLLls+X90Yl/dR/zn1LKyHuFNfnE7ZBSKJ/23xdsQxRGIn8MkD
         sDr0jWnuLng6SnUK68Kv+Dauxoe2Oj8OoqflWE6aPqh0OnwySi8ps5XGiupoAPJd3Yqr
         xEMStLfEuLtsLZWkj76INhVnB4PaGMboWxKT6bOfsp90Jemj9pTDC0Yz3E9d29hOwHHY
         O8zr/nkzugycVzcVy5Ox3Pz2ZtGenHTfSA/qqRVLZ2KaGthnCIQHWS6cf8/J5RMlqFwH
         wWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726023; x=1759330823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EzrycjTVpnWNKj7lM2bs2OjeckNX2GUUhGCkamMVlMg=;
        b=U+qnFJKIUMHb9ffsgIDqjT5QQ1MpHWaZZdN7j5CqyArgNFNoxHF5nDkxwScCX349uG
         kpN0wrMz7rUj95NsBk22IFKASOVzjy6FzlRi2VTBw82+gu6LquwvNwYQarGnNhSbnFil
         vhDYw48R9i9QWJYVSsShQljs4Pgy/3ye98DuqoiVPtaQh9m35sbTl+kdH8Vf+MZYTQWD
         2Vy9tgPwu5pTPz3aeXpASuO5wdRv4KH5BuqUkfSoPoqx26+Dq2hQUqyy0e2QacvCFJQO
         6kJU+WbU7xivY7Oj/RAYatBG26AW0iRyDtZvG+1CGmctK8hFq1V/wHvLtQbvXOkR+tA5
         n6ig==
X-Forwarded-Encrypted: i=1; AJvYcCViF7GvxmvKdalVtPHkmeUyGxdKroNrjI7AM27Rjnzf/mUF4PggBIO1JwkoiXjVq8Izte/cnvZlwA==@kvack.org
X-Gm-Message-State: AOJu0YzoF7xrR2KfjnKj8PRm9bR7mG90aQGTKMAX8XE2LqL00TFY+Wob
	iUJYUHostsRhAGnhp7or0rUKgzZkpTRTEP9qeUiV4t1jOBXZQDZzvGTR8REcqDooft4tbZ1NuhV
	Yrtobr5CKZkDkjA==
X-Google-Smtp-Source: AGHT+IG4WxCVm2OtQGcna9zHZFJt3Y1WAwbtDQRLq8Re2vHQBN3oIS6DUJScN8kIjtixgF9x+8sRx5iaUapcaw==
X-Received: from wrxo18.prod.google.com ([2002:a05:6000:112:b0:3ea:af7:bb94])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:381:b0:3e0:34f4:3225 with SMTP id ffacd0b85a97d-40e4ce4baeamr250578f8f.45.1758726022897;
 Wed, 24 Sep 2025 08:00:22 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:50 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-15-2d861768041f@google.com>
Subject: [PATCH 15/21] mm/page_alloc: rename ALLOC_NON_BLOCK back to _HARDER
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9600B4001F
X-Stat-Signature: 4it6uafrer46exngpo43crotb39wqe7z
X-Rspam-User: 
X-HE-Tag: 1758726024-9807
X-HE-Meta: U2FsdGVkX1/34XaQ0/KCN4Km5G7A70nR9uB9gtxCy39B2JFcBK2WeYHxO+qPkacCGkEKioVRvz4jy1m3cX7jFs+yQD858dR75dmxLG1fPxxFPTYR3VmnsWFwUmwCmbgOGZJXm0DnVjgtnXULOboRipwzKizyoZmaZ1j9EurQHOC7fWmu91hHhYkTYde/Kg1uWE6GcerZkkLpSlkL4nZ9xQW4NddSn/jM2X2H5cFnAuBloczoNpwRu0pQACD7U054Tx5o8HY3mJK80sNE2t6BZUcAmkSLnYMbWryQpDLNm64lAXYhZJvaBGXAV5lOLJitWwQETJypJFtBbtT1G66agwy1+Z/n6E6ibHZ6FbH8mtmMEznmLjCSqwI8onPGR5rvpQuSZ5+APkXuUBWC60+yJd6+z9KQbDs1+37kq6OHV5KBu3aS7bv6NWgqYnAyEzN0VOKCb2x4HGbJrZ8ta6gHyiGnxTOaJV+/y38zKdLKpiXOyrS5NwEmief10tIdYOCRB1bEN3v2hI5V7A0QFydq1eB5JYGGXqwCecSboVrowF32Tj7ouuV77gWOC4J7/zqKlRkYtYN1yFUzdAPylkB8EaBgbgBs78FwnmTCF3HpGdOHnXoKgW7RDEkS7EnOrPF1bnqGJm4+inOf+OlkL4LJiV60O7C4Zml7c0GGcufDDXAA/WvWn4h3ueE/551CZ6UOn/YoqdK7eJd7nHx2L1808YEuakmr+OC1wnzieP8HCoK2z2FZNtfdLnW9UeRdyDKAfPiyyQyRkG0PTG5D/qHsNXQBK1Olo4Q+VQtc9h7VtmdCwCQp3F9IxmOGx6uEhr2VoOA0yPa9dP/KFSkgEw09NlxBRbvg+eFbvraaSDnNcXjUWAyp2hMjuB8Af7O4kUDeRA0pfvMi2DdcxEb/X2aNcjALIgQhBwxcJWcO1eEUnetKBOGfsFnLfyxySNFKvtBEu/sjFL1I5f5iBZ4Epnu
 2Dt1jXB+
 3AhcPwOQBjVLgcErxSzOgzhwfC1zPNbQmIetzBSjgsM/vrV5RUgN84KS0fN5IDN753gR/b2TQgg8vqtzt6mNSUsQkYU6YFTnmbFTNlNexmpSvKeqM9ci4aG9mZHMKmBSHAsFx8Cof3nuit4Fc7ho/TqgkKT5T2R+10ikJ6wrmEK+6NAk4W0hyQItzc/A44GU+9YoAeSblMpgjM7q1a1+bTa56wjMHMeZBKpMU8zqm5keYD9Jghmx9GGJl/djDSmiq6lVIABu2aV5JSUg27LUqcUU+sbWH/p6BGECE/rmXuB23giRP+zq5Mw40U6AtMTzpyfVjaMRyfhsJMpTYzUhcMmY0FM2SxAKMPgy3HKygrGFCcwx6jxkWdSdAOwnzo7C5aGU0E1l+0E6gWWyLx8wfLu6Y/OMkDzsh/0O0j57AG5tZR3k8Uj1LKyWDH3lqGPnBMOARM8UbEoLWn35Ao8kC295f7wfRfG1T6fHJLFX737jJ912q2aTRMgFw2+YyvMWRdFHlo64rsr4UgImWIVFv2+KmhpiBKEbw7KDJm0ikEG8Y30npQy9xv8wBkFsW/txm4t1mCk/pCiJwPehhGErBtXxzEZizQSlvkOXWs3UyuNkH33Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
non-blocking allocations accesses reserves") renamed ALLOC_HARDER to
ALLOC_NON_BLOCK because the former is "a vague description".

However, vagueness is accurate here, this is a vague flag. It is not set
for __GFP_NOMEMALLOC. It doesn't really mean "allocate without blocking"
but rather "allow dipping into atomic reserves, _because_ of the need
not to block".

A later commit will need an alloc flag that really means "don't block
here", so go back to the flag's old name and update the commentary
to try and give it a slightly clearer meaning.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h   | 9 +++++----
 mm/page_alloc.c | 8 ++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 6006cfb2b9c7e771a0c647c471901dc7fcdad242..513aba6c00bed813c9e38464aec5a15e65edaa58 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1297,9 +1297,10 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_OOM		ALLOC_NO_WATERMARKS
 #endif
 
-#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
-				       * to 25% of the min watermark or
-				       * 62.5% if __GFP_HIGH is set.
+#define ALLOC_HARDER		 0x10 /* Because the caller cannot block,
+				       * allow access * to 25% of the min
+				       * watermark or 62.5% if __GFP_HIGH is
+				       * set.
 				       */
 #define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
 				       * of the min watermark.
@@ -1316,7 +1317,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 /* Flags that allow allocations below the min watermark. */
-#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+#define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
 enum ttu_flags;
 struct tlbflush_unmap_batch;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0b205aefd27e188c492c32754db08a4488317bd8..cd47cfaae820ce696d2e6e0c47436e00d3feef60 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3295,7 +3295,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * reserves as failing now is worse than failing a
 			 * high-order atomic allocation in the future.
 			 */
-			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
+			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_HARDER)))
 				page = __rmqueue_smallest(zone, order, ft_high);
 
 			if (!page) {
@@ -3662,7 +3662,7 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			 * or (GFP_KERNEL & ~__GFP_DIRECT_RECLAIM) do not get
 			 * access to the min reserve.
 			 */
-			if (alloc_flags & ALLOC_NON_BLOCK)
+			if (alloc_flags & ALLOC_HARDER)
 				min -= min / 4;
 		}
 
@@ -4546,7 +4546,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
-	 * set both ALLOC_NON_BLOCK and ALLOC_MIN_RESERVE(__GFP_HIGH).
+	 * set both ALLOC_HARDER and ALLOC_MIN_RESERVE(__GFP_HIGH).
 	 */
 	alloc_flags |= (__force int)
 		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
@@ -4557,7 +4557,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 		 * if it can't schedule.
 		 */
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
-			alloc_flags |= ALLOC_NON_BLOCK;
+			alloc_flags |= ALLOC_HARDER;
 
 			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
 				alloc_flags |= ALLOC_HIGHATOMIC;

-- 
2.50.1


