Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FAAC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A09F6B0088; Wed,  5 Aug 2026 10:42:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978306B008A; Wed,  5 Aug 2026 10:42:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867866B0092; Wed,  5 Aug 2026 10:42:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56EE76B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:42:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3E9FA1F69
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:42:30 +0000 (UTC)
X-FDA: 85067481660.01.1FCA321
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2AEE31C000A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:42:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YdPO0JiK;
	spf=pass (imf20.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785940949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOyJt1GjebvcdavnL8pSeT2aveC2x2fYTTclxb3ByIE=;
	b=42YXTdKTTbjlsmBzvK3PR/d2A4BZ++tOxQW6lhE145YpD+nYcJOkJn3IxpaTZmaO8uBfyI
	8QdenFstLlkmnOzcj5hASOZekmTpbHfZpQNeqiFjz0Y07LSmgeABIGRPwO3aDL2m5YBCcp
	ayzQGzSv5jgg80Ajeat3dMqj/PofqYQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785940949;
	b=kWns+568UotCALObbA/QEc0+jxsQ9f0Pg+g7uVgfu3DIUcqUY5tyrK2Oxu8U133tpzOvZR
	rJJy6G2VdcE8CwQI7mAiV8CbBqbcvVbyr2WfE38WI4QrR1LSBVJE2nUnEAF/ssifzD28K9
	mq3UwlGhRNlcrcpsQtFBH3ZKlXMZlsk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YdPO0JiK;
	spf=pass (imf20.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f7027ca11so729089f8f.3
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 07:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785940948; x=1786545748; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fOyJt1GjebvcdavnL8pSeT2aveC2x2fYTTclxb3ByIE=;
        b=YdPO0JiKuY7cIeuOLCIOF2I6Ou3N8LZRDsPdS0HuoKSF+ssmUSq0/XJE/39/UihecF
         nFUY/lsqCuy1I98WnOlUsKPH3eGYTrqk5Ya102esQKdSwQO3tSJgueJaYCXwUuxnLa/C
         /lEnq89sfVJK/iN1s1AfNIAf9Cw5G+owJQeN23wJc5KVNIsatM50wba5s6xL+9G/jHYr
         CMBePzppnN/tRLlBZiH3rRP6ddVLyYl5A83SYqMbLurtpVb/GfnmJSd6IbGXdU/7Bzth
         Tpx8PJ1G3M/k8ok+aUm7mHpsu5r8AhWpcnrjJyIBgPRj3c1kWfyd3YdaZfgpx2Fdrz8p
         3AMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785940948; x=1786545748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fOyJt1GjebvcdavnL8pSeT2aveC2x2fYTTclxb3ByIE=;
        b=As6iiHD4b1i/VZgpDtinXf3zT6tpYBQKJOOUcz2pzLJVDPuBVNBEUInQaLTHLhyfjK
         01+1WQRgsVZAXLhfxV1F584WbfmNBfDpWKCNGWmRdm2iXVrLLYkWu+SkvKhzNhXoOsTZ
         Upy2L/LkV4+iX84Ub5s37GCDIoI/EttTiIarsunjDXvdSZcU/VVrKrZalns2PVATILAC
         ZIyzKGgMjd5kVdwtS+S9nigVSNwzo+FtWsBIupS3xxGNZu9kdYFMT3aLyoZRoz9eO27s
         QjvibHiV3PGABkFUqDCrmcJuiXNrNbJ4HkAKVYk2ypyMKHPtL7pwdCAKkn3TgqPRLrwF
         8z4A==
X-Forwarded-Encrypted: i=1; AHgh+RrpdWWaQVmCwHkrdXqUQRJHCySMW55Osz+jryQrTPnLIRk7SjePQHex4xZi+TWrbE3FpOm7tsNdkQ==@kvack.org
X-Gm-Message-State: AOJu0Yxit3mrkIM0GfJ0AyPEnZU2tq6KkJuft8B8SMiSOM9h4XK/FwMG
	m9+WU8J/WsMr7Frf03jSGUyAM+cF7WBDjMpC/ZcFrjI2FooqzXh/rCKJ
X-Gm-Gg: AR+sD12LfodBONsFqKg0lyhHc8PW2CILkqJ2IAiW0Nzuw/ZjRFM5mc9JZ59RT0Ohu5b
	ntuV/3MoJ+IZVBd810VdUDYSjWpHiLaHmd7D20g/2XKfuvaaOmJwCt0QdjpNRaGPiHc+xwXk3rJ
	gIgVqFCIR8vQGzbaR4hH2hpt1QQ4ZDQTKfGJELxzb6N/k/EiqsCvryRqxH2j1BBUNGJZCSTuVUo
	aLdeKnmbU3Wj/YC0/YRNMtvnraeWrqxKxYbAzmqe8Vk2tAW71yO4HAwkY1lKgo/oU9eD0h0QwJz
	XuflVrPN7A9xiw++EOEyjIB2gh+JHEZyOyVVEs/o3/LaGXQULOZnNtgPG1DjdICsJK1ZStZwtJp
	uzbxuhJ8Mg0bArneePfmkYRVHRFgYn9GLQFPyHdcR6o77xfbiRrvml9EiA2g0nvfvX7qXfDOwrr
	zmzNL3ei01QJF6rVfB9QwAFTxHLqo5KOJx23R56cQ5urSnN9BjCmq/N+sHaf13LuUzqD0mbtNqU
	uCdEou3um+D+iSa3nudaOA=
X-Received: by 2002:a05:6000:40da:b0:47f:93b6:8d06 with SMTP id ffacd0b85a97d-47fec482347mr12815889f8f.0.1785940947427;
        Wed, 05 Aug 2026 07:42:27 -0700 (PDT)
Received: from LAPTOP-AVI.taile24b5.ts.net ([2a00:a040:1b7:4f41:6df7:ffe8:d01:255d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232333sm10094289f8f.18.2026.08.05.07.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 07:42:27 -0700 (PDT)
From: Avi Weiss <thnkslprpt@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Soheil Hassas Yeganeh <soheil@google.com>,
	Arjun Roy <arjunroy@google.com>,
	Eric Dumazet <edumazet@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH v2 1/3] mm/memory.c: rename walk_to_pmd() to populate_to_pmd()
Date: Wed,  5 Aug 2026 17:42:17 +0300
Message-ID: <1d3d22df3b43080855d4728095f9ebaddfd7bf88.1785847364.git.thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785847364.git.thnkslprpt@gmail.com>
References: <cover.1785847364.git.thnkslprpt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2AEE31C000A
X-Rspam-User: 
X-Stat-Signature: rwt1qe3nykghjtx878qq7myrz9jifjq7
X-HE-Tag: 1785940949-997948
X-HE-Meta: U2FsdGVkX1+rhmnkzOlgZMaiVy14lSMy6+wyUFn3QdNvkZ/Lnv2ELNA7t+HpIfIknsJyXyF04BYYx4H0vz2FUv66zKH6QsinVC+KoEqZx8ptR6yUe+7wTH7OmZfn5Al9pLOEXuWzu5iT9eR8AMbNXRvNPMQUmdrBJvh2hag7O23OI9jXEWUEEqFdvPO4VuTJBunNc7n3mw3U+USJvEbpBxtf0NUsfRXvG3xEc6KWuSj60vHDr0TK8x3JewS6l4/QeeW8iHsan25TdDkr2dUzMfITnRkBelp8kUjGm/uabCqArcTcVQLIYaLukwIp8fNgUDBRyQQZ6OdNQkeXKjA6nU/+M9SaCb0Iyf3dIlCthskfppDoY+uUri+X8dtM5oVGondZ5Az2K3fKoSeOrQfk9uoMBKUY+JiVeZ/947XRzuGhQA7dF2H52vsMy6BZtVZKlKuBJIWddVxIFAs4ys1SdovlqrJcAL5i2K6wOU+m8moVWTBzhGRRqbJa/Hgy336ooEJM1XCAKARXh54r9/sVjCIXmEZJOyKkgQTZm5G2CWqcnSlhbpigLqwq4CuAnP9EscLeUBUKpfVvt2S8+qj2AFnN6/lQ9ARxWVxsupuDmHwYwkfcq2TMH8L1VdxM6Tq0mN1tyCtRx3J81tySyN/TbR63Op+Q42xJpDYzFqI8AZ5AYE2u9b6jToAnnf4YY3GvEbFBU6iMBuFIDfCzHzIzEXEvv4stPX/bhxDExWFEP7rrCYiOpVTB4r7sry3VDmv7tJ6aJdTCYnPboPY5X1Oi/QKWDO4hlaqbdj9I3NBgTSQ4IhuIsJAGVnS9P38KZxGwY0dW/u+rqKwsHCo5YViHJNfzJfUK3kFhgn3urydzRNCdJYcDUeK9W41s4JpTYmhiUmeKQWoddkPmiwOhVwnOXlcG8nQLZphV9DE99VMQQXgvze/HEggCyM1oJI5cEZwtCYaQqkEEZPFk2riJ7O2
 AeQF3PZS
 DbDCjWv6fWV+2pUMVt+F/nYwXsSnRQVfLi3DGHJYz15QvSqNxcR/ACpNl6Cxxi2F3DofCswmXAKtSQvckBe4DyAXMmP2Uc3j2uSUoNYLRGwMQRXTA6n0eX+De1vw4Nt9LAZn3Jb6YsJ92fsG/wL4a22ncEkcXZPmjqUYMWSg+sr5gd3kwFza4sxs7jhPhdxDuAcvIGpZUYE44cRQqWF71QsF4dluH8iASqzc6oqbk+i5ebf93mhni3uUzwIYx54RCuk+SO+HKbGw5YtrFUkmU+yhss9ymZdrlV1mTesa4JOX3UX466hmsb2TMiLB40RoyVa++PUQO4goMN+8weOVd4AF4XNu1cteNla/fs71RB0hpazobJ4ygzwn1LGlEL8CJMEk8K7Rvf4r3Iks6FEV1W+miygBb28frZAnrPfth/dH3W4oEztJ7DjCksvgYSNdheqTDc6gR+8j0rVw7tQ/G35+bSrF/WmbbBEwMRqkjgfLMXPfPc/s4zDcM5cH5Pi9knfZttcHZZtxSNpZKpeKuUDz6PiZlP1A9FZAF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This helper allocates any missing page-table levels (it doesn't just
'walk'. Rename for clarity.

Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
---
 mm/memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..8658feba8be9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2268,7 +2268,7 @@ void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 }
 EXPORT_SYMBOL_GPL(zap_special_vma_range);
 
-static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
+static pmd_t *populate_to_pmd(struct mm_struct *mm, unsigned long addr)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -2293,7 +2293,7 @@ static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
 pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
 		      spinlock_t **ptl)
 {
-	pmd_t *pmd = walk_to_pmd(mm, addr);
+	pmd_t *pmd = populate_to_pmd(mm, addr);
 
 	if (!pmd)
 		return NULL;
@@ -2437,7 +2437,7 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 	int ret;
 more:
 	ret = -EFAULT;
-	pmd = walk_to_pmd(mm, addr);
+	pmd = populate_to_pmd(mm, addr);
 	if (!pmd)
 		goto out;
 
-- 
2.43.0


