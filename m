Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73F33CCD195
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 19:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 427D38E0003; Sat, 18 Oct 2025 15:12:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FF728E0002; Sat, 18 Oct 2025 15:12:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314E18E0003; Sat, 18 Oct 2025 15:12:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1FAA28E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 15:12:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B883911A42C
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 19:12:30 +0000 (UTC)
X-FDA: 84012181260.27.96D3C66
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 086C7C0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 19:12:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RSpJ9ERj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of mehdi.benhadjkhelifa@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mehdi.benhadjkhelifa@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760814749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uenq9zUN4jnOACfiis104z+6oR/uGp0g0fP3KoqPQzk=;
	b=PNG4N/hgNWZZzj246Eb/C3oK+INY77kRIpy+5hrI6LXVsPTkzhxh+yItTzlkRtJWPj8Fnq
	rn0iXGBw7nvpmTLkzpQ5IwBV/R1ABFq+duNdReUoQxKLOFJKsRN99MMGbhH9cbew1lYBb5
	vEP976Fluk/Lm9ZphXbSaLVpy+yRthg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760814749; a=rsa-sha256;
	cv=none;
	b=TjJjJKo05bwuiYyjdoLcTRdheXtmgfUwcGgHsDNL1yb/v7ig5VVc+lkSW515tsIlWlJKga
	CARCfrR+hx8/1CE7s2q64T+YmoFEZfmw16o7S9wUV1ZXvKUqnO9nFEWPw7GldnK2gv5L51
	OeN8+paQArCqEZimG1joU+E8dj2t2/E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RSpJ9ERj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of mehdi.benhadjkhelifa@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mehdi.benhadjkhelifa@gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4710dc94cf0so703265e9.1
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 12:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760814747; x=1761419547; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uenq9zUN4jnOACfiis104z+6oR/uGp0g0fP3KoqPQzk=;
        b=RSpJ9ERje1lc/uIEhnPzqEtVOAV5nZu9jI2BZIRIGxUo20AAwKEmDBksSPjjq+YEbh
         GpCI0wOOxMHUarOZZ+sM4lHfnhkqeqe4WkIM0hw7FF7mt43X1qYmX6msi5/VXxYg0d1v
         d+P9QRHOQosfv4gh4a4S7yW9Q2PQKB8UBXdKkCZ90KpbuFyWISJ8oL3KX72cwGA8IEPv
         6f9aA/1fWMtUllLApLzfveoSj1W0roIKtcFaTLXpDuXjxRpRMcqUMuNcRiiDUhZhTsor
         htpy3prSSgevZ9AHF+oIPDhyvUFPDtkb5gBGxzYyZ2iWCOVRiCu8H58D4n+0Z8h8Lhad
         Ditw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760814747; x=1761419547;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uenq9zUN4jnOACfiis104z+6oR/uGp0g0fP3KoqPQzk=;
        b=J7OGWIBBrah7H6HVyZCn+fGgPEzZYCclwAhuAroIjjW7EVhCHrlLZ/k9qfwVZIUIaC
         vBte4mWYtSaIJUnNnvEXb1Q5ZM8O8c2bOYCDjX8IaeH+oFV4cS9vVH/N5KHDF1hKHeIb
         4XgbHFFmE7e8po0YsGerznYIAm+VR9lGNT6MP3lBJQAano21YxTR75pkQC+VbSKkd/M6
         dBdHNCR0Y72JOs+DSH3+ojDmb/bDvsF14DDwUbvFwWCeGNMD2GUrcaw7XNhRSztRpT/u
         ITWuxo8qpzVo/qb5+appkGHTH+RQ8W7l7+SwAPF4G5W80DmTxf079HumHKBVr2m+F2i4
         LdyQ==
X-Gm-Message-State: AOJu0YzMMdvusePr3u737573JtF+i3trGSd9eVb98Ml+1NyUWzhyTBSK
	vbvzbkQrKAr/TOf2znfl+OXgucMG3GpYijR0gnQ4QN58OeKifdU5AQzt
X-Gm-Gg: ASbGnctoBr4+wocSTwbWI7LzGVSRJNdQ+HOZY14WvqKEo3N6vcRUJdRMCWzUoTi/xRk
	LzSnBpQRLoX4CDiCVUdMavui77SeVKpQyQDrIlmBAjeZg71wI2Klbd15oiH4Pg2CDUdw4tnyEDH
	ns7tJpargalPPmTXTlr3wkNy4PIYwlkS0HbZimhsrMjsT3fl4TKE0PSFmBf4YzhVbGyqQtfEXHl
	77c8yGZPkoKpc8xrYUTsK1KDHohPsGQ1OZu7AYo5l0I73paGTcmMX54JSLm96bLFf71GQjUqlBC
	5Ij0KJByFM1x6bwwunf/UndJYSuVKC7wu0Vt2XjpEOSR6FpNYnGFMaoKh31RZeTOP/KxiEez8L8
	1z84zkL0xDX7dollvzCS2jXg7TgMhwZ2zhtZlrtVnnI4P9NtYaizq4JKv9518OD6uk6FRpKmxoV
	1Yo/M0
X-Google-Smtp-Source: AGHT+IFeotg3SOqozCDeGAvqxPUt+glB8XDCNwLIM43/UO8gAjt8ouXK8ko6Vt+aDxAZJHhJtcwrow==
X-Received: by 2002:a05:600c:3515:b0:471:152a:e57d with SMTP id 5b1f17b1804b1-47117914193mr32306685e9.3.1760814747218;
        Sat, 18 Oct 2025 12:12:27 -0700 (PDT)
Received: from bhk ([165.50.121.102])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5b3acfsm6406354f8f.14.2025.10.18.12.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 12:12:26 -0700 (PDT)
From: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
To: akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	linux-kernel-mentees@lists.linuxfoundation.org,
	khalid@kernel.org,
	Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Subject: [PATCH] mm/vmalloc: Use kmalloc_array() instead of kmalloc()
Date: Sat, 18 Oct 2025 21:11:48 +0100
Message-ID: <20251018201207.27441-1-mehdi.benhadjkhelifa@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 086C7C0002
X-Rspamd-Server: rspam02
X-Stat-Signature: mm7szb1dt3mbb9ohbuzgfr48y1s78xg9
X-HE-Tag: 1760814748-438363
X-HE-Meta: U2FsdGVkX18zFgWKqrUI0a20wY6eKRxYfBdh7LYVExAOXlYvPpoeiImuCdlybAXk/JwW3uvd8ZA4ELk4GHDbvxnCKGCsPTScYP9+RNG49GjZ2h39TfPE/5JqRlo5rMr3wDz1GpXCjwC5/aiW+HpPJ90u7wA57xcyfDwr39YtZb0u5vS9xm2XPDl5o3M+v534ijpjSbvIfYXOEu5SCpW8GU5A+Ukl5TRKw97j+oWXAXf0qStxMPUSGPr1VpoMhQm902w62icYKnY1VEg44pqtasxww6oLZwjhG/MidMwa/qg+4Zls9SHu5qbODc6BjdIokz+y51w5N3tp0nDZIsaUKvaEL7fux/gWxUDBT/PCpP3/y0HEsB8sFt+wkofhhYe44pConYU+ME7xhu+rFpIh91/ImEFK0EOW0D2e2w81cYetr45nxo8jULBCw1dYpmzbBBywV1PFlGrGCqiwKa7hbZzSaHbW28T1SZNX6EXRyfccwhw6Edc4X4ILMoyTLmoF7Khr7N3GgnCjaodP0l2QFTHs9EhNeKgiEJ8rrTgaUJnE3Ve85AaDBkSjaMH1YYHJKHhtIVCgeN9hJRxe+VeoDjbTJUQSYWayOiJEeLuSNDaSHZthJ3NqgHXdep1yypsPzw2q9f9XMeslYjFRfFR2VwCtxqfDcx3YKS/bT3mgz0qfBl8fd4cXMD4tPsDz9uekn4yWmcNgOlFT4sWomShI29U4ZuqpBNIFbOBxQBK2/q8XuODS9E9KMgQyX3yhO7lXcgXM8I48u0bejw0tFb3NSFSOOvPWgAs6fQSqXdPz/REgHPXh/tWfsuo74wIe8sB05FQ0PewkkVtQmdGNRiuJCeU0BAlHQVzXguhkqBwO+R+vn+glJzOHuWeVwAEJvHineC0OpvF0t5/Y2SqQvkIq50FTiiqLWHVa1sl4+FqcT1oIxpUFZaSgmh4T8ZZj1pRz3AweL74F0G8Bc3WTY9Y
 rV1PXvh9
 yp5ms5FerXGULIVd2wMZIyiibAjABdI9MdONGpQ5xedyMSegrrY6Fb87KvlFFPFDinB+kgKdwIhAhF+j5xi5XHDahwtiC4SurSbccRnudcHw9lHpS9Qsg8dYXHDG38BYGlebn8X15KW/fYM1uzt3ElbaJojOwFqfYwsg+Q/US82l2TG3OWCRM+gfJ4h/5m0qN80sbFoeFxnO5xPx8BXcdvzC5K+QSOva+veetCvnzSIrCzqoghRVECbQRz93OxR2aU+oPtQHk54TpTCRhbcD1MzUAiXPgIy/uxIUkX2Gm99bUmZcSnKCeIRCnxWR+WKq3IMW7dV/frpQXteWDPKMzZetDi9xgCnOlDS6PVlJ/0n26vbFU3mVVVlWsIt1/Ko6JZGa968O8jvtDaY2cU87BoTO5Zz0Eg3UjtUo48QA1tLSio3j9VQn/ZM+yQrPOHMjbS5J8TDw20bx3l8g8XiQO5laFADaZ1eMQ8/D9TXEWK3bcLWAX6PZ4EiXd6JOH5p/JTC6UBrryW0Q+rnzx6ND+vTqxdCg1kWjgKnORLb8MTq4CPDf2w0LLMdTHF5aWqr2ysXAw4STGippsUbDG1wpZcuKw3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The number of NUMA nodes (nr_node_ids) is bounded, so overflow is not a
practical concern here. However, using kmalloc_array() better reflects the
intent to allocate an array of unsigned ints, and improves consistency with
other NUMA-related allocations.

No functional change intended.

Signed-off-by: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 798b2ed21e46..697bc171b013 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5055,7 +5055,7 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
 	unsigned int *counters;
 
 	if (IS_ENABLED(CONFIG_NUMA))
-		counters = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
+		counters = kmalloc_array(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
 
 	for_each_vmap_node(vn) {
 		spin_lock(&vn->busy.lock);
-- 
2.51.1.dirty


