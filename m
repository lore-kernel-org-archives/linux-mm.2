Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A7CEE9D3E3
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 14:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBB716B00AA; Wed,  4 Feb 2026 09:24:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B677A6B00AC; Wed,  4 Feb 2026 09:24:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65BE6B00AD; Wed,  4 Feb 2026 09:24:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 939BA6B00AA
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:24:17 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 29404139441
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 14:24:17 +0000 (UTC)
X-FDA: 84406994154.26.B1D82EA
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7065240006
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 14:24:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="cD0uY/Q6";
	spf=pass (imf27.hostedemail.com: domain of aswinkumar3301@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=aswinkumar3301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770215055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3qQoNxe742wAMET6iW/9VVCIbsGWMOhQXF34GxJvupk=;
	b=s95I3k51uac02822ZhKubWia1/Cw/5OMYSqu+0hOdr+40zLZ9PSWCvGHc54YEhUy54/L39
	u352dVZBozsV7LCP1ft4oUPfK+0RWkEtIlKaCaabwDD/87d5OaInn3M/D/bxPVoxWiRTpQ
	H2VdJWKeJbHclIH2Cbtxgtd4rg7OIyc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="cD0uY/Q6";
	spf=pass (imf27.hostedemail.com: domain of aswinkumar3301@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=aswinkumar3301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770215055; a=rsa-sha256;
	cv=none;
	b=eYNipS+EK4qVnuGIYdheDx000BSvHKXORxOQYGoAQFJJqDwEm5WI/tF3CcVSKxTKSQjIjJ
	reTBEJnqf7s1AGGDxB2+uwvX/X+Q0J+FhXBKbwsPDLKwlrIL/9jQs2VuJqkOjpSsjqteUv
	p//eHB0ZhTz6HISTSP3klGCHi/4XnzA=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a871c767f5so5461325ad.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 06:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770215054; x=1770819854; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3qQoNxe742wAMET6iW/9VVCIbsGWMOhQXF34GxJvupk=;
        b=cD0uY/Q6IDCzCI0bFnvv5IVE5G7/tR4ddDDQoXibRvb+24989lyOhYhOhnFXhOFoeG
         D8bwxnrm7iEEfqvW9wQyxhH8gHJTb/pP2D1EwDjPdWHjUwdjUOqsSOlMSOov26Nn+XiP
         dASTJpu9WbFfDtwCnnAQY6pRobrm0rdyUuFX4UjcqgHq7KGc5hCkd9ogaZA75F1QksjU
         7EnDb9WJPpq8m4ZUXGlgxoDpOm/Go97C2iEooTmdar+06NySN1riqU4MjnM+EueTyoT1
         T2eSDnUppIebeiogmR/1J4WYxala2OYEYMqehRkvno8JYG77IMhdDOumA+uJE/VU9RF1
         0y0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770215054; x=1770819854;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3qQoNxe742wAMET6iW/9VVCIbsGWMOhQXF34GxJvupk=;
        b=tt/RtpXD2tO80Vezl/fhwBwe/6QwewfV1cPBPOiKYFG8sab1Qlr16VwACOVBBXhezS
         fdxCeUdDq0TpzwlHKcMSstn/xBcBXUcRVZsNPR//u/aHmSDWlj7LRE8jTYlUpQ1el4Gn
         QVGJA9bljFKPGxrrYktrfcyyaETfsB2vr0QVp98Mo58zx7QG7yODrK/h9QT83CIe7XK4
         OHqdXT+y4c0hwjURKddg5EV53gNrP+2T0HVEC9JFGKVdfSMrpXXn3hJ0C2ISZaqx1jot
         rTxZ4/BEeX6rKu+T1DNMtS0wFnJakGOQ0lH3wzRtOYTivgKvyJTEAMe1nJSnGu27DzJC
         91nQ==
X-Gm-Message-State: AOJu0YzGlPLg+5Qa6QoDeQ5e9I1KqcU4+/9Ff5+peuiM3xpYqT5AfWcc
	BF40NBAM8zY4e3oFCSJmMEisj8vCno/P8c/ft/Cdq7l1E84NdyyOXGHIkKh5IQ==
X-Gm-Gg: AZuq6aLi1k6EXeklLzITiYxDAdMTL8FNpITih455uP8NDeZ2XDNnKlYpiQihIBb9AXE
	fqmktaNAN/j8zBsEPrWLYx/7C2KsDrQ1x7m8A+scN86IGo0AaW+KCMWFO0GvVyut1pPL2e8od+H
	vKqfUIpwIaL1glEeVoEeG+SJJfYXHJDSgbX+HjQtGkql/CQOHPLdpvbpEk+UBUui8k54kA0YNuc
	5RDrXTX3K9YpvWfxYMt0l4blAdh7vDlJ5muc/LRp5abY/dt95D8j6VCLV+69DfNJaNDGp4P1DJq
	UWufuYb2HLwDG1yA1I8Rb7GrrcYSz83EN3mXs7a+FMhFTZDtJIazRWAhlilkA8ywAhaRguCaVmf
	dTi7tLXVJ2MaZsVxeU5ElqSCJYwvgkg9SymfeYSWIUJnEwCx8NSRoZoeZf8wZ+ZrfAIiMUMXO2z
	nVVtSkmVajrzxeY1Q=
X-Received: by 2002:a17:903:2343:b0:2a8:7814:47d1 with SMTP id d9443c01a7336-2a933bc69f7mr21896745ad.3.1770215053851;
        Wed, 04 Feb 2026 06:24:13 -0800 (PST)
Received: from aswin.. ([157.51.37.214])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a93397ef6fsm27170315ad.95.2026.02.04.06.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 06:24:13 -0800 (PST)
From: Aswin Kumar <aswinkumar3301@gmail.com>
To: linux-mm@kvack.org
Cc: andrew.morton@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	Aswin Kumar <aswinkumar3301@gmail.com>
Subject: [PATCH] mm/userfaultfd: fix likely/unlikely annotation in move_pages()
Date: Wed,  4 Feb 2026 14:23:50 +0000
Message-ID: <20260204142350.1642-1-aswinkumar3301@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7065240006
X-Stat-Signature: ji3jnd549mc5ndjsrkyajtoikdaize95
X-Rspam-User: 
X-HE-Tag: 1770215055-478738
X-HE-Meta: U2FsdGVkX186JqnQJvVOF0l/mY1z4FKGUTFyJz3ozd6rh34OE03dAoQUtvnxYo8qXQSUmEPBtykcsyKbD7L8/+/mdMl8IN3PXWvgHfORsuumCAhhgE6SxPa0wMotBpSvcbofGG2atqrsSLB4HNLzpTc0e9HYq9a3svyLVgB6Ex/9v/uPUdIKyaadrNbDeIf6nvZ2XvpteaLEnd/HhIH3eKXdlnJSDGJyI43CxJpuNC/UknBRqhPUndWCCKPc1KF8pXOS1mDexlJoAcwp7rLy4KK4YmY3Mesal9Sps20Clc9o8ePN9k19bfxU7bxyGmRBniKDOvFN+jizK3kDMKPqqiLcVxx5DhWv8zBhbCw9qwrrJKPoDl7clpVRAAlV6HpDYoA5nWSK1T/cQkTjMaKwWPCGmsKXbO210DPc9w3gmrI+0jHcyon0KSIxkHkJ3ijacRqSAwa0UJrfkqh4Uhpcsdkze6xp0xUJN7/gTjt3SnBpQWmLzSQK5waYA1EDwnLwfCk1jUy7L3hB+VZIGO37tNvVN0cw6xfZkDA9FtyPfSsOLQoYZbtCvZPYoOJUjLbhOiaKYBPsGinYZPFdvb9LYxC/KJ51WxDgzVhquqpBi7Yj22cIF/j41UDpMVoo+sBHSMj4Z+WFcmw7s3IhVAJfXRab6nUNboNxZnhE47j7e3FJ2X34ZoWttfDDsVf9Zya2s/n0wXByKVl11xfDy5PEexYITd0zKQkXYAaNaYfxw37vmFfrSMoKDEctgA6OXdmUCMdopfqkbRnnPbbY0eYkJgLzjV2DQSvau64Qfd+2fshPE98gw8Uv8hRdYiux/TnwqT7g9iKn2jW2S+cI5Kx4+TKu/UaTq14qTK7luPQV8L8QMhpLdYUGmzMTSAZVoQTkgVNp5KRFajahLZaKNMxCbq7eChSGyYmq/KJ4ANhP3nHPUpWG0zjSxp72oqc3faaCU984Y+ipA4/Uz5MkWAp
 lo0NGgoU
 VAirReV7jIn0nshcrMCPsiU9ZCLT0fd5RsY5r+OMDFH4GtptNuIe4t8hAI/B5lhPrBalHnAqyV6Dm/Vl6/ahl55IoegMfL1bgMZA8Rz0KmJEn2YVwyFEmINgEToUeG/EYr5AsmMz/oNFBsZ9CJVHoU0NamJ6R9c2bvPEtwMOfjQh+IsB+/bX5lQEjosYBiHk+4dlKOGZwBNc77nCwvGOcEBN1k2+wor2+O47nCRVrLf/Jk9aVHTrALJ3b5cDx+QnvOr5VNXa8Bkj/94BBQKEV51tPZdUt2ipkiY51k/A6wESSzhHz2XERI0GcgWT5yruAqI+ksQ/Jnwa0fVigeAf+G/L28XNaBHFfJtb3csAsW/y7dE/CVr9mSpgHrXVgfcaxtftUjsh/hYyXn86xKUFLGdonnHF2ySpxjjQNhfVWu/foeqQrugIpNzj6/743ZI+Yc+jiSCQhHj6XbJIz71MGNFph8ydXRtDApCzpQA8I6AqD+l5uMNgaaCN3F0okLP2OofYskvpSeex9VDpVgL6c42ewRsR3+KWbxvBRLuNBDxupxPo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All other userfaultfd paths use unlikely() for the mmap_changing check,
since normally mmap is not changing. The move_pages() path incorrectly
uses likely(), which is the opposite of the intended branch prediction
hint.

This is a performance-only fix - the logic is correct but the branch
prediction annotation is wrong, potentially causing a minor performance
penalty on the fast path.

Fixes: e0a58ef0faa7 ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Aswin Kumar <aswinkumar3301@gmail.com>
---
 mm/userfaultfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index e6dfd5f28..d27080348 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1793,7 +1793,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 	/* Re-check after taking map_changing_lock */
 	err = -EAGAIN;
 	down_read(&ctx->map_changing_lock);
-	if (likely(atomic_read(&ctx->mmap_changing)))
+	if (unlikely(atomic_read(&ctx->mmap_changing)))
 		goto out_unlock;
 	/*
 	 * Make sure the vma is not shared, that the src and dst remap
-- 
2.43.0


