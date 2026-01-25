Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EC2AE63CB4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 17:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1F9D6B008C; Sun, 25 Jan 2026 12:58:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07D96B0092; Sun, 25 Jan 2026 12:58:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DF576B0093; Sun, 25 Jan 2026 12:58:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7CC806B008C
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:58:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2057E1B0320
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:22 +0000 (UTC)
X-FDA: 84371245644.11.7AB74BD
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 16F13180007
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T4Prfobs;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769363900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAw5ZLwfH3aOqNw+8qnqKgdPaynl21dDWoO/xPxb8Vc=;
	b=1n6yBmoQRHPy051bGIanjFtKRS2IoKL+UCN/+h+LmwDotHrzmZ0nQB6YarRu76OBP1D2mH
	z2+4aawjXuAeXUDfvCCflH4ZvYZjsmzOvZkzki+0xw9U8BjzYnjCGmMf6GtZsLKRsSbeh0
	CEbcAw4w6v5qCHJjLF+E53SCHKw0JJw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T4Prfobs;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769363900; a=rsa-sha256;
	cv=none;
	b=vf3n0/tZFISMzV8W4nVv8ND1sBDW5+nd81aes7pP/JdN2578LOF1xnso4/9aomFzRCI4bW
	HaLybOnvBVbqTHxiEezY+xL1t9TVO4dBXBafLeIOCs1Yr+sisv0TyViRmV9fy7PLEdPIAc
	f1FIjjBEbpBLuCbaUar5VD+F3s4pMsQ=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-81f4e136481so1888286b3a.3
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769363899; x=1769968699; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aAw5ZLwfH3aOqNw+8qnqKgdPaynl21dDWoO/xPxb8Vc=;
        b=T4PrfobsaDca2BCkv4OAl4E5+iqjzZAZuam+BgUKKTEde1JfQm/Hu1h0yoBnipkZOg
         dJBU7RiBbBZkD0Zy86XqHnbTJgddRMyiDfPQtukzDPkDz+k0qvj1e7zmapECIiibxctQ
         BIrbjHic2M48s/Y9qcYeuFVA52Jx/2QAETti+U1cTF49FbAaBjsw/Rten8WrLUE83mS9
         DLqGT6jy3fi4wZHgSseMR83GYOUsb+n58wO6ZdY/NNpm88LflJiEJOXrWas8cNwgI/qq
         Se5d5krSny7Mil93uk4vSxDSqR4TcoEI4XHIkhPXfNRHAPUMyiuGhETlDPCZINBaDPpE
         jVbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769363899; x=1769968699;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aAw5ZLwfH3aOqNw+8qnqKgdPaynl21dDWoO/xPxb8Vc=;
        b=Mk9IeVi8HDuZ3Tscisjix4kJncntNoSiTQGjXQ5c5wSE+9vtfWKjEjHX4L+5Yx7xK5
         h60bJ58GsL/Eo2JoaM+QpfPUK2e/oB3v+8zBE0qTZlIp8P340O7dNddMxPNwtsXlBNPo
         7UCKNOZ3cmzQqCd80lT6WGoyNzg71w85JFd8rNAi7x86K6mhHO2jbK3tGsdLqK0Vc6yp
         GmnesNvSAoqdGh2LCNBuhYzJsB5w2S1FC1NVh3cznncWoKHsmXuD7pyBdpS/pLBbfi1S
         5l5z/wHuawJ0x1U0CZYIorfBrmkzZbyot/iHRdiES4yc7adEjO11FvlgkpP04mfi9Gn2
         ljBA==
X-Gm-Message-State: AOJu0Yx2MkhePHyPscV6CSftuM6sNeaKRt1ICsIEZWteahMmH2qfLsib
	g74NOptUE1Vxr8zQ3s9j4f7mFZxIIvzGCFnBDeiarb+FlwEgTOMexixf
X-Gm-Gg: AZuq6aJ+k2ICmFbzJj7pD3hKUCiyB0mssCtUTffUbd9mzpheHjZZbGedgtt3hcDpWMm
	DaWKtXm0s/EPP2sbP8pmPxoLH7iyvfMUFszIseGaIzSETCjvAf0bSRBy+K9ooyL+avGmXstyIYj
	EUNWtKVx5QyQexfeCR2fBYGo0y7YoYDTQKjQfgOYBtarYBQnkyoNP4HKKs/T9pR5ltmjRri7DoB
	on1WDzTyJABeAncHWFKFoi5WqYqq4hMDb97sZg4pNYbNMpeNgecciva9diZVQefzjFe8+Vxmiz0
	vApS3MuhqH3p6EPdyras5RvyqX1mi+iqEa3OaSEev0vsYl9EQrsoZdF88Oy/f04lxUwmI8Sgrd7
	AXhWYZJZtIR3G8VZqG5oziKQm6Seosem9cBeL0ZKCGxpuMxtMnaG3xYiltY02VF43QjHYqqxEQ2
	hCHH2N5NYNYnHZ16eAxOiut5PrSmJ29GYiIiW5G2Kv2wGymP2w
X-Received: by 2002:a05:6a00:3c93:b0:821:807a:e427 with SMTP id d2e1a72fcca58-823411dad08mr1660383b3a.21.1769363899012;
        Sun, 25 Jan 2026 09:58:19 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e718sm7405963b3a.62.2026.01.25.09.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 09:58:18 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 26 Jan 2026 01:57:27 +0800
Subject: [PATCH 04/12] mm, swap: consolidate bad slots setup and make it
 more robust
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-swap-table-p3-v1-4-a74155fab9b0@tencent.com>
References: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
In-Reply-To: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769363877; l=4411;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=OidTajkMc0iGAT4CQSZ4FaMMIJHOoz6IAuhiV5n7RgI=;
 b=22h05Pvce5AkmGELBrC+VspfwsX4gVHJPoaq21bkR6YV6t5rRkvi2X8Y59JOGt3EG4xfxQBNi
 wV6+WfpY79sDSPNwBbtLq6PengLrG0audQ8Rc0lvcP8R/0MM3pRKruN
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam12
X-Stat-Signature: pxry5eqgi7xp781pzywp1jdhqyawjqy4
X-Rspamd-Queue-Id: 16F13180007
X-Rspam-User: 
X-HE-Tag: 1769363899-754455
X-HE-Meta: U2FsdGVkX184KtYXkoa2OEbelKTC8/qgDwhO97TgImjmIyucvlAsJGsi9bQf0Jvxsk3gu93Gwj5SiO53KEcl267EtGqbdY/CpbARc4fTNpKa0+dxNh4WygZ8Tj5NgWxEmN9i9m9jiX5IYV2+VupCi6NPAc7MHkRvYJQbj/nuTq+1yNGU4u+z+c7MZ7nf8TyCmMaihjgW2LIIqIoc6V8ud/ocwywGSOUhcQ3q+O+rYU0yUyYNsIVPB5qLjaSGuWRkJfKRfzS10xoYlDXGvR718nBkOZwivDuSYVcZp+Je7PJJ8azVTZu7+9XgRXnJE9UnxS7CJtmfNKRMZs6wpTK8oenXcdYGCl9B5xNC7XX+2Qir6LPBUAPDxNvr9qP7L8dGdfZu4qT7y3Md7mzvFUjKJf4A0vvFxLqxPMLohkhvJSyAKM9wZvmHafwFjQO69booVn98/y07ArN+BIoSTz6fUaW+p5oBZ7gUKomo6OIBW+8GzCMq9r7YgscV63j9QO0/wB8xwLZmmu/G+Pjp8hQFaJ3R6TXofnQ/oj0pQIBRhwU37JjG3hydu4XGdcJdg6hSHstOOIoXBnN6yuK9woLvZrld5Q8YBzjJufpdLMvj7aJVOxzyesnyVE+jcGR2gZ/x4BxdSJlGBzgu0r+1KVhCj7KXbEI3FeoE71lOcXdXGesq7fntxtj3yoZcFjmUUE9DWD8vyCESq4dR3tKbpXz5/iWl0E7CwfQSc75Jnt8dZW29a4XK9DUEarPgmeoOVWdes/GibH9zyd2KqS4JZXvSS1lilxSAbKpHbgWEyurnDIM9pnIzjZcill4nR8FoUZx0VBOg7XCzrwCc7mosP3rCliG+hZ5JmSw5c6jktj3FVZv9hVLf49r40BJt0hndAZBe9Y0+lSsfiVY7DQAWspcfaNSc+xKfwFTsBWl2EBxAC+oNK+kkoJT/xn8YJSr6TWB97SPfK/n3+FECfBH62sI
 Lo4PZUYD
 V8EaCUfBuetkyCSVBAzDzlHu46T6i1zo/+eXSjbIuqkz4ncbq2MqeUj/bONZ92nqOLRY/cz0bYBjxeKS/Ea5iCT+y3aWATKQSnT/PlPYuiCTlNA0YuYaob3Kw2LKBhcgIHxtd3B8aMhlM5hcUn8nhQKmLeYPpxgZS62VrKQMO7dLVCh+EwlJf2Ci8RgEpPdKdl8kuR9rp1cEQnJ23XDuKaj+JaCfIub4GY6+rOp9RoKF85HNjfZaEKpYA/8kKof9Pvyxv+wbDwZv0D99St5QwRiVUOfELjnJgE7Ol8jWAuvJfeWWehDfs8mv2Q/EjlCN3vGsQaUVgzOaaGjBW7gfJ6uuNun+QKDqPxvEfC9gB7xynGjjzttCdpLIbBJCykbfo4jBeIweQoMvB2nVzioJM/06ocwtEx0mKgF7vwaelYWezH/2bsOrkDIS/rQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

In preparation for using the swap table to track bad slots directly,
move the bad slot setup to one place, set up the swap_map mark, and
cluster counter update together.

While at it, provide more informative logs and a more robust fallback if
any bad slot info looks incorrect.

Fixes a potential issue that a malformed swap file may cause the cluster
to be unusable upon swapon, and provides a more verbose warning on a
malformed swap file

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 68 +++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 80bf0ea098f6..df8b13eecab1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -743,13 +743,37 @@ static void relocate_cluster(struct swap_info_struct *si,
  * slot. The cluster will not be added to the free cluster list, and its
  * usage counter will be increased by 1. Only used for initialization.
  */
-static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
-				       unsigned long offset)
+static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
+				       struct swap_cluster_info *cluster_info,
+				       unsigned int offset, bool mask)
 {
 	unsigned long idx = offset / SWAPFILE_CLUSTER;
 	struct swap_table *table;
 	struct swap_cluster_info *ci;
 
+	/* si->max may got shrunk by swap swap_activate() */
+	if (offset >= si->max && !mask) {
+		pr_debug("Ignoring bad slot %u (max: %u)\n", offset, si->max);
+		return 0;
+	}
+	/*
+	 * Account it, skip header slot: si->pages is initiated as
+	 * si->max - 1. Also skip the masking of last cluster,
+	 * si->pages doesn't include that part.
+	 */
+	if (offset && !mask)
+		si->pages -= 1;
+	if (!si->pages) {
+		pr_warn("Empty swap-file\n");
+		return -EINVAL;
+	}
+	/* Check for duplicated bad swap slots. */
+	if (si->swap_map[offset]) {
+		pr_warn("Duplicated bad slot offset %d\n", offset);
+		return -EINVAL;
+	}
+
+	si->swap_map[offset] = SWAP_MAP_BAD;
 	ci = cluster_info + idx;
 	if (!ci->table) {
 		table = swap_table_alloc(GFP_KERNEL);
@@ -3216,30 +3240,12 @@ static int setup_swap_map(struct swap_info_struct *si,
 			  union swap_header *swap_header,
 			  unsigned long maxpages)
 {
-	unsigned long i;
 	unsigned char *swap_map;
 
 	swap_map = vzalloc(maxpages);
 	si->swap_map = swap_map;
 	if (!swap_map)
 		return -ENOMEM;
-
-	swap_map[0] = SWAP_MAP_BAD; /* omit header page */
-	for (i = 0; i < swap_header->info.nr_badpages; i++) {
-		unsigned int page_nr = swap_header->info.badpages[i];
-		if (page_nr == 0 || page_nr > swap_header->info.last_page)
-			return -EINVAL;
-		if (page_nr < maxpages) {
-			swap_map[page_nr] = SWAP_MAP_BAD;
-			si->pages--;
-		}
-	}
-
-	if (!si->pages) {
-		pr_warn("Empty swap-file\n");
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
@@ -3270,26 +3276,28 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	}
 
 	/*
-	 * Mark unusable pages as unavailable. The clusters aren't
-	 * marked free yet, so no list operations are involved yet.
-	 *
-	 * See setup_swap_map(): header page, bad pages,
-	 * and the EOF part of the last cluster.
+	 * Mark unusable pages (header page, bad pages, and the EOF part of
+	 * the last cluster) as unavailable. The clusters aren't marked free
+	 * yet, so no list operations are involved yet.
 	 */
-	err = swap_cluster_setup_bad_slot(cluster_info, 0);
+	err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
 	if (err)
 		goto err;
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
 
-		if (page_nr >= maxpages)
-			continue;
-		err = swap_cluster_setup_bad_slot(cluster_info, page_nr);
+		if (!page_nr || page_nr > swap_header->info.last_page) {
+			pr_warn("Bad slot offset is out of border: %d (last_page: %d)\n",
+				page_nr, swap_header->info.last_page);
+			err = -EINVAL;
+			goto err;
+		}
+		err = swap_cluster_setup_bad_slot(si, cluster_info, page_nr, false);
 		if (err)
 			goto err;
 	}
 	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
-		err = swap_cluster_setup_bad_slot(cluster_info, i);
+		err = swap_cluster_setup_bad_slot(si, cluster_info, i, true);
 		if (err)
 			goto err;
 	}

-- 
2.52.0


