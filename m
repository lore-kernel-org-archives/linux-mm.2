Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C436EE6B44
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09696B0096; Fri,  6 Feb 2026 12:40:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1656B0098; Fri,  6 Feb 2026 12:40:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90A616B0099; Fri,  6 Feb 2026 12:40:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F29F6B0096
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:40:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 275D3160165
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:40:27 +0000 (UTC)
X-FDA: 84414746094.16.C478399
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3B7841C000E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:40:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MRmXGUCA;
	spf=pass (imf21.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770399625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4pcYUP41h1qvxc4IslgWl6htM1/R87B2mcOvIwOAbeo=;
	b=SYy8Pc9dMTUcrMNxXE5ZZ7MNg5PYes4jUJ5rSSTQQdSa6783E6T+/Za+4bA0SDXBibXXEn
	XVh64XRDTsPBndSUnZS1ciamgPpyfWhNRbE7yg/jN3oKuw6k5z79w9wSrMPCK3NchSgQAK
	LGyOVWxHaKevb5KzNAA9RM6R4YiFpzI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MRmXGUCA;
	spf=pass (imf21.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770399625; a=rsa-sha256;
	cv=none;
	b=jVEkS4hD5y4xiArOYxwzDHLpsPTDXjlJKDop4xNyMXufRGD/mxLFizdly4MjDOCUtpy7tV
	8/wciUSgPHEas0lUr395WH2lzUXqC2dRcD+pofb2+I/xi/4Qn8tG+lGmFvjAQMR4ZBZbct
	2qRzIyjGt/XQNMD/Fnk4/2Kudbz5XQc=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-59dd490be5fso2951745e87.2
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 09:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770399623; x=1771004423; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4pcYUP41h1qvxc4IslgWl6htM1/R87B2mcOvIwOAbeo=;
        b=MRmXGUCAdbPqTxY4H+WMq2CIvJMedM4X1fQ0+LaFk5xg+p+sjWT0Q7ET3kzAbzBUWR
         N+EgHYyCkQ8TvJOH7c+cC2daw7pXXFOdWJda/XxG07Q/2v5kkZzrnszVUG/ubglMc6yI
         lKTDBSOOxP0Mg0WqJPhWDwmJeITFx7Z0Sx4TkhJ3oUm5ZdlKpoPG/XXbF6IkLsnUXQN8
         H9JlvY6BgKL2FHzdCSELSzmzm2kkTqDr8MCKv10+2PHWmy1CuvFgBSZmE6BSsrx316RQ
         TfttK8HnHf9LEyGrPvE3ZquwvisQ2Po4bYDXHnXgPq6prWIuS+hGRcl89BB3qgN6sE0D
         ACOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770399623; x=1771004423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4pcYUP41h1qvxc4IslgWl6htM1/R87B2mcOvIwOAbeo=;
        b=QeANpGhk4F5hvTqhAM/puv5W87tz0NgdkVdhsPzZrVYNNSNqmy+hhRWUbgq8rbRKAG
         d8VytZ9z0pL6sBXmQ3r7awrFAQQfHYhzVvZNeuNwvuPnLHlvqFHl4A+VaZubL1awvkz0
         91si1kJ/Cv8Jog5vUUKJtl/uf6BtizxMGTgXXgT0Qwfzd1SsZN5s2gpJDvkD7+5B0hTW
         Ws03o+Wqk+76F+GhFbIFaQgd65zEQHJhhH8vaQNSCB04eEY+QKE3N0tQMHJRVA78CwoL
         vxazKXmw95mVlg7Ec5cdpHcBXJ6vVRiB0tMXBTa0ZZD8Pht85pnKLkjhXxzt18efB6LE
         tIRQ==
X-Gm-Message-State: AOJu0YxwsqqPSb1DjfnPPCosk7TbeCQT8O1shJCGO/Q4wuymQ+Nt6yij
	yMCbB9Y4SYdK1bII75CIkOk2lUuMUIfn59nenD0giGvtcGyqhHWyZotOhaL3x4a8lZuJgA==
X-Gm-Gg: AZuq6aKMsxQpCraVdOAPsbwvVyKBm7POQ4wBM+V3SdlasBQpxC9YzlT1YhJb7ukGGWB
	qcbkufD40XBDeCEMwq7cgEDD3/h/nZMGfsraNm6GaXl85OBIDCo8iZ/TgFzubupAM+15RCNIKYf
	Hjx8ukbfz8nxgYBDEiJlhG+wTOEcXVcktqkodY/l1IMJ1ULU8Wy4pFwyDxzo3s71IY29rMAPk2V
	P1X9eoKxfvwnN6ExyEEBTIrru8Z8hVxJy3a3p5TNvsgz6rasKS6DY1OeQDW52bA4gFMFxoQWr7u
	kN/LXJqbg8vtRLTfHECG7xVVaakyBhQ2sb8co/7yW7mhM+L3wRLj1PWWaT4C3NKdbrxIqqV5Fo+
	Ykbgn/viVEYBZV5/MVS09YCfZjbJIfCrG9oiorQdcDRbLwyLYaH+5nUfJcLsPjLpEQ1d0cCHDD9
	vk3g5PfudGPoRaAuBqZgClyA==
X-Received: by 2002:a05:6512:b92:b0:59e:387f:bf97 with SMTP id 2adb3069b0e04-59e45050a14mr1113338e87.21.1770399622667;
        Fri, 06 Feb 2026 09:40:22 -0800 (PST)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e44d00890sm772907e87.38.2026.02.06.09.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 09:40:22 -0800 (PST)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	vbabka@suse.cz,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	ryncsn@gmail.com,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/page_alloc: clear page->private in split_page() for tail pages
Date: Fri,  6 Feb 2026 22:40:17 +0500
Message-ID: <20260206174017.128673-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CABXGCs03XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ3PwP0mGXA@mail.gmail.com>
References: <CABXGCs03XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ3PwP0mGXA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3B7841C000E
X-Stat-Signature: hra7hzcy7mdgf81mh9agomnxzch4fm7h
X-Rspam-User: 
X-HE-Tag: 1770399624-160773
X-HE-Meta: U2FsdGVkX18aSLteSGwcT8N3t+5a4mUWbKiIesbYHTNv/vGjwSKrB7BNLvwePmMTIRKk/Nh0YNMTTCIBOIEZW3ubjuq9nVPK1JAlrtDGrMhJRE+oSGm8bcpXaZPHAxv+H57pIaFgHcEVTnH8J1LiPQ91qeAEqcmXk4stkN+trSVF6BNLxI9PR2iNYLj3Hc1dEjm5DWqy6u4AYZT6juZtF5jdz0CQvB7gKckP7Ob4vTuR8XnGr0uDJGAceRiIv/WXcFK2Dtfkb2SGkASO1s6RoRRrYXH6Ntq+fThsz+00oRJmJdjffiFcfJj8xitUuR/NIZEVo9R6L3tRAnLBsoRCyhSPI/yFzDgMoPWOvhsxjDH5KtyDLpS+EBET8shc6Z5n2orRUtqDj32UHw75U8+yd5V2Ivi+YLdhMW8F+butF2p5HZ1G+YpQa90xzVP7BVTtAO/EBL8y8H9HNFJBkWMycazpYQI2xBdJb2YiV9VXeZiJOnRJoTZpv5svP3oi1a5IUeml7yMM443PFcEHEoLICvynDSR2+BJPP6KiuAGNNoFKbhhMvnMkXoNvj6s2qwK3HPo8crbb73BYRcVXxEWiUt2VaRq6+iV5f+i8MAdddHkubHMhTiBO5Is3Dz2KHq/7rkBmCBlr5I7a/mkXo7ZArMk9bGEAHvEBDpdQQgm1Pkgn0zTf1Hu6V4ZCAbvuqUXPeD0TcBM+bzP92nEcAcU60lVKq+Zq0n2V7UNIQy2L+Vsmsewj0cEClhyaCHDtBYiO3XYQRrATvnLFPHdyLqKFtuhaXF4GbgcjtiTpBgd0YYPtMVDCaWiWDyutW/jXyLSZx8VZ1ep21R1hIk6Vfs9KG9lari8DoYseN+aK+jdIPtiZjemLOKtn4hIOkd2DC405Ef7qp9lE2dhi3ObSvtY65ouKGIjsaLVmK5EvmmgMxLtwJzgPjDgrwlnp52i7Ffzrpwkqccf1YVqZhk/mc5H
 yCcgzgFY
 +svHbCvRYKWmFFEdO+tvYFMA4QtNyDN9Li412+PfyQ0XHaUiv/aWye6MijDeA9FfaK1k1tBV2gu+zXcM+NFVe8SbXDbCChtQpKG0zlvm9y/ErMT64OdWSmARiUMkYiO/uiAvD/pufYsm31zMgYc0juWUIldri1lEIiV02ibXAQr1y2mrQ0MjqArTUWn7ka7qtKyvcbyWbchtxrmkQt5Ehu3WVqy639lu54iOfpHfjkWGSznDJgjwmFjPGKnTts4yXe4bh3mEhTSBMK370Lsc/D71qnTdXrNxWC43VUVO5UqKx+fEhSZievmd6c1kbEoBn2Xx9oPmUoLK6GkGHSsUThwPcRG10YuctmJoYW1jnYniwKMhTx/t7FHnELkbY42+UVdbznQ4JHub5Xr/d3UhGod4SioiB2zq0S+u33wsbQnqRVtCtSxy0YZs4f1lwneSUkWEkwMafrVsyBmpvscCXu+4rRopYcztNGjwSkwtFXp0SjdOK4DwjUW9WqwkmJfLLJTWBW3noUZIanlfyRJ8iUCDcNgeXZ2PvYwtbLXS7pp/19jLZqV42BjAeY3hK9AFlwsjJUtm5Ugmuhcu3zhfwkh03KjP3qmC8K+/ReT5ZjQFc/A40keCP0vqa/MLoF7R64wD87sfHZ7qXzM9B1A31efZjPh3f2l7TkKAZMZeb32OgFR1nOC+kHg87+3iJ8GGKmveJY4Ghyj67TqPnemBQaCugZWBS8yin+X6O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When vmalloc allocates high-order pages and splits them via split_page(),
tail pages may retain stale page->private values from previous use by the
buddy allocator.

This causes a use-after-free in the swap subsystem. The swap code uses
vmalloc_to_page() to get struct page pointers for swap_map, then uses
page->private to track swap count continuations. In add_swap_count_
continuation(), the condition "if (!page_private(head))" assumes fresh
pages have page->private == 0, but tail pages from split_page() may have
non-zero stale values.

When page->private accidentally contains a value like SWP_CONTINUED (32),
swap_count_continued() incorrectly assumes the continuation list is valid
and iterates over uninitialized page->lru, which may contain LIST_POISON
values from a previous list_del(), causing a crash:

  KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead000000000107]
  RIP: 0010:__do_sys_swapoff+0x1151/0x1860

Fix this by clearing page->private for tail pages in split_page(). Note
that we don't touch page->lru to avoid breaking split_free_page() which
may have the head page on a list.

Fixes: 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages should be split rather than compound")
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
---
 mm/page_alloc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cbf758e27aa2..3604a00e2118 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3122,8 +3122,14 @@ void split_page(struct page *page, unsigned int order)
 	VM_BUG_ON_PAGE(PageCompound(page), page);
 	VM_BUG_ON_PAGE(!page_count(page), page);
 
-	for (i = 1; i < (1 << order); i++)
+	for (i = 1; i < (1 << order); i++) {
 		set_page_refcounted(page + i);
+		/*
+		 * Tail pages may have stale page->private from buddy
+		 * allocator or previous use. Clear it.
+		 */
+		set_page_private(page + i, 0);
+	}
 	split_page_owner(page, order, 0);
 	pgalloc_tag_split(page_folio(page), order, 0);
 	split_page_memcg(page, order);
-- 
2.53.0


