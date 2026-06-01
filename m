Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 680A3CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D03066B0307; Mon,  1 Jun 2026 05:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D416B0309; Mon,  1 Jun 2026 05:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B7D6B030A; Mon,  1 Jun 2026 05:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0D186B0307
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:57:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4BFE71C1B36
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:57:45 +0000 (UTC)
X-FDA: 84830892090.08.A6267CA
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7BFF2A0006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:57:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YTb5fAnX;
	spf=pass (imf25.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780307863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VeYhkIkkPdmPxP0oRNh636yFz6Mw8IPmOd/UUON7A0w=;
	b=Nyf2PzTDLqeemin957CdtkyHlIwIkuHdo1r4pDPmDkJ9HzCCZpzLd4MxPzVCrBnBKwFDfy
	YoI1stE+bVvmhVluRnQVjsn1Xg7RexZx/NxE1sL02tHvgzNAiMs1cjcR4SjzqlnsiBD7B2
	cNxNqzeEN4tzjmwS0m591p5zQFxZxfo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YTb5fAnX;
	spf=pass (imf25.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780307863; a=rsa-sha256;
	cv=none;
	b=jDjWeBwUUFKJzhxG0MwkTGwDxoXqzcKjGGT3xLXOshFVNC+a+KycEcnxnbYHwr4TRBPjHh
	1oVy3lNdXEohKFevbtnTJBPkUssaXpeBInhW79PusdCraeJErsNKz91WxE7ZvNejutfoJP
	20i0vEZth5Yt+oiCOoweOFOpdgDLfVI=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490a78fbd7bso1521705e9.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 02:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780307862; x=1780912662; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VeYhkIkkPdmPxP0oRNh636yFz6Mw8IPmOd/UUON7A0w=;
        b=YTb5fAnXhQ52IAINeVS7NYC4zCB0Afnz9gkTN+RRm4O0E4luG6WuBFX+kb9wbfo1Hj
         LJpZUNe5F1l7JhtjKJy5oXX1EJZ+eeYkLXEYvKirUxGQpvXbntqzGF9pafm7HoNlJtT2
         t9AW1RrEBnkNiUo35wLtxHgwtKkkeCv/UNySWhSPF+fZ4r4+Yme17gapwih8UzI5clO6
         O4AkvQax0c9Nlj2ahgxgONRd8IuDe8PznyQ9DNfCeE9/VCGyDvbQypfwHBWRadrtjYGP
         Vbj/tg0i6oqB1s/H857vJT0tFFd+uHrd9LEfXD/KxJtYTR1t2IXk4F08D/2Y3Rf2Otvh
         IDHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780307862; x=1780912662;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VeYhkIkkPdmPxP0oRNh636yFz6Mw8IPmOd/UUON7A0w=;
        b=YqBp6FGSgnKUJv5OEgkd5gHcdf6LgNOWCPtpL20FLgNAlM7lK0nQ2NiduUKv8TVPTY
         f1ZVkungVt0H+21jjFVKv/hTKKwM5CWfYQKLkpaqOjjDkls9uxKV5b7KhNmbfZJHGJ8v
         l/ys2M5cNEFbwZUBcCudmYrF4stVsF3WUrrF1BULv927VnyUZ24jn/Ym34traNVi2xVD
         EnablAsclUL4BzxMXhiBoaAccPGAI1AfMaqWBf0/+KWDmb+/Z7IDSfeigmcNJ5wWdMOk
         1UvRxZOKwSaICUHd6VL9pb2aUq8V9OOR/bAcTmv4b03OdPLd9/ES8SA7L4JapCf3z26K
         P3GA==
X-Forwarded-Encrypted: i=1; AFNElJ8OHlCxKFr8GTMZrhkQE2NNky+kJluqFuExzZcZl3jRY3MZ/FmCj6mxtwbTK/8MisK0SwaLLXjLlg==@kvack.org
X-Gm-Message-State: AOJu0YxvgQ4aLx2OVOCxPvXWhHOvmOdsGQcnFedkYfOdz2LaaAjpf+C+
	+wZpHACAy7YRqudofMlTKdiB1Ry/6nHCqPQDkKXfJC3aG3l78Q7frJaa
X-Gm-Gg: Acq92OH93A6fJ/nQt1hT1o+QcwXSirXfXxfLNGIIVWP4ztCyveXfekEq+dAWBhTQ5m4
	2LXQG8Ks5VD4LN52SC9fzW14n9rKVNsTRj5BYk96m7PRX17l0+D/VkHU9/XWZ3BFy0PwN89h1/4
	NzxdGZSfsYW/9W5dpdzFxCTTm9pbzRzjte4t3Ry2lD1qVBhehS763mlAa6Mfr/fpJXLi5R+GjvA
	8ImyFLmdfhGqmXsDhCYL+7vGYnRgVUN1Aud0g/zdfLMROcRk1NfoC2fFNh3h0psu8GTGCnqZEGo
	6C3yZ/I/cDq+kScV2xOYmEonx+vvIHOd7EJFhUtkMyFJc5spavvcq125Mhhi82/z7VOha1Na9P0
	K95D4AeiYPi0IX5vnHBk0q6oGEgv2ZARL256+2douuwXTK5LoDn6rmFpSyB2Q9jfSfxBa4Wq7Lc
	zuc7jBtbPpGJf/sGH0KT2VLmU2XCzg2PU26mAF+djyuTOOKM/LP+dk/lFWofNMBaTLa5AqhiDkC
	sw1176IO+UkDDw2wgAIpCjoEIWqfFa5uTySCZT43Ip5umIodUtphOdwJ/+mqb/phRsSej+vTw==
X-Received: by 2002:a7b:cbc4:0:b0:490:a2f4:c499 with SMTP id 5b1f17b1804b1-490a2f4c5f7mr49990015e9.6.1780307861689;
        Mon, 01 Jun 2026 02:57:41 -0700 (PDT)
Received: from fedora ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34a03f8sm25589419f8f.7.2026.06.01.02.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 02:57:41 -0700 (PDT)
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Subject: [PATCH] mm/compaction: guard move_freelist_head() against invalid freepage
Date: Mon,  1 Jun 2026 17:39:42 +0400
Message-ID: <20260601133941.111989-2-giorgitchankvetadze1997@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sj11o3c7t97ig9pmpqc6sj47xutnm8wi
X-Rspamd-Queue-Id: 7BFF2A0006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780307863-184592
X-HE-Meta: U2FsdGVkX18vwt+9rGRk5zOiiPhM8kgiDjptKyDX523L31pzFt+pvKZPKSlPsXj9OV8NMTmovB0uuB4CVZ1M7MB0Nn/mHAXYV2bZ9tSprgcMdcJg3VSvmInHX+tueU9bVAiRb+0qSp0jEfhJRsrv5m/norjHVsSJDbOGKYBzsPSwb5qLAVFEKtb2VpdDAJn3zcXhYZGCE9OnKXEJTC2oV8rGzFQy4o1COVl7WxbfqM+10iYB0ObumQ/3drn5skPuvtYhQfhc0iXfRJvB5A8gKKP4UoEp1+poRvIXerIGAHXuXrkLZQbJp7ub05xjmztLAT22wq3S1G0YueS/mnjP8AcpDCxibtAgxE9+t7qP9s5acUs8oco5NYDY5Uyp0U465sgx+YmLZo55R0IftqdJGYGWPqoS7AeVJOtkYMgUWe+busr6f9mW4tFqQffLPV/6i4X9Vbqa5Sct0XzObpRS4/eUDMwRtfbPM+/XnN4A7jiENtDOdCANm97fRhtaQt7GOs7FeYNrKQZZ6StdWo6pVxYZeBE3T3FsfxnGqz8cCYbdNb5xkjnRL7q+OVITxcJV0gU5fbUHOzYfwYV4WCBsAizdVfzkBV7yRPyEtOnPYcReRnLA9DHvWDOCPA5z1P7uinpesiZaJdWowmjwIYVQ3e56Ptv9HkGLH1WXBXHgoZ13O8Hjp5tzE9BD87kqE/E8Kd1TVaSLArCiUmP+zharfYopqrBeSfuHD2x42LWedOuJ+K8j0blZ/Ze6/7bWwVTK8/VoCApj+FKgHwuoy0lgI0dvldwhTZqJMdQ6cJEQFnH6S7tAx+iBYWXUjMRfrjq6crKD/4SH2san2+7iozQ2G23UmMb4RQYJ5k1O0ksv3IN9nHm9DsVhiJf0d4daC2dnRfvbGFZViUJGPfLfV5u3ZUwqywvkRtoFNknVU6M6PiUF0QufjWPfzNpeo3YDT2aScZtgO8Ij1q4G7+Ly+/W
 ueqQeYWB
 shEZx/5HRnDB9qFjOwfzU9D3kRwDUbvxpc/5AexlqEJ52AmXCKEaGeDe5pPzjcUsrhn/w0zopQqZAxvih9tEIGKFBo9ZjBkCMdvc6a0LjH5S72gV4D9Hv8B0lbC+SlSzSntlIhIHMkTWim+mvu8/zY2WPLnFHdPfsEhadGRIaHkZej7pKTYSzcx0hM+CjKjZXgGrKXnHErIlyuAOgSvkof/BTjtbzmFOB5Cs4yU7VRNglKO8VG85kG4TCWGlpGM5jC1bzUNEmoqZ7jCBHuO4ZcXuXezLU3HfX8LFuKTE4r7AisbGodOHjt7svTR/a/elO4SX+sZsB8vGMogvgpspBFlSpY4hinia/nTd3cN5v+KZzpYMymM3/F0NMsy/23YLFpiPra61R0ZUMYJIJ8unNGxdoqDFmLURNrkNmGFZzSsPv1U0CZ0YtNTVOXz8+FACKiLTD3TTTwNQZfJwLmF1mlr2Rb1hNFFM/kl/Z/M2gPeCJFm2nLZxCe2R4bMRyfJdJlUT75dG1iD72+L8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In fast_isolate_freepages(), freepage is declared uninitialized and
is only assigned a valid page pointer if list_for_each_entry_reverse
exits via break. If the loop runs to completion (all pages in the
freelist have pfn < min_pfn), freepage holds the list head sentinel
and high_pfn remains zero, so the high_pfn fallback does not update
it either.

The subsequent unconditional call to move_freelist_head(freelist,
freepage) then passes the sentinel as a page pointer, which is
invalid.

Guard move_freelist_head() inside the existing 'if (page)' block
where freepage is guaranteed to refer to a real page.

This issue was identified via Coccinelle (use_after_iter.cocci).

Fixes: 5a811889de10 ("mm, compaction: use free lists to quickly locate a migration target")
Cc: stable@vger.kernel.org
Signed-off-by: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
---
 mm/compaction.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 8f664fb09f24..320c082420fd 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1611,11 +1611,10 @@ static void fast_isolate_freepages(struct compact_control *cc)
 			freepage = page;
 		}
 
-		/* Reorder to so a future search skips recent pages */
-		move_freelist_head(freelist, freepage);
-
-		/* Isolate the page if available */
 		if (page) {
+			/* Reorder so a future search skips recent pages */
+			move_freelist_head(freelist, freepage);
+			/* Isolate the page if available */
 			if (__isolate_free_page(page, order)) {
 				set_page_private(page, order);
 				nr_isolated = 1 << order;
-- 
2.52.0


