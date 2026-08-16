Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D1AC5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 09:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29BE96B07F8; Sun, 16 Aug 2026 05:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24CAE6B07F9; Sun, 16 Aug 2026 05:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163336B07FA; Sun, 16 Aug 2026 05:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A892A6B07F8
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 05:00:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20C67804C7
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:00:44 +0000 (UTC)
X-FDA: 85106537208.08.E2748D3
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5EA50C0004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:00:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eCEj80WT;
	spf=pass (imf22.hostedemail.com: domain of kiarash.azarnia@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=kiarash.azarnia@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786870842;
	b=EhES8DgSZ+4U3palCTjXHQO1KquIkhaAOCl8CFI26ssxauTQPlX5wiPmHF0G1dZmsSbwMT
	W+ZUG4hPQagCVTi0VVMiN+7wtPZXbUrOA2CoFjaAE3GO12ZMpVqB62GeN/A9OLsyOT+e5v
	d2BAOYrVveUlenVA94OESQvTJKIzrKo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eCEj80WT;
	spf=pass (imf22.hostedemail.com: domain of kiarash.azarnia@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=kiarash.azarnia@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786870842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TB5hLITgaLSvnkEZ2ABO7VyYwwjhkPuh1sGrI3sQjr4=;
	b=qukL3HsvWSC+HAKRX0Pu9dFxfgTZjkCtkig58VcD2+x+riOT2KY6AmNSyHXqTuv3HOe4ty
	0hKge+HmVY0xZ9eFUlrb7KMi2DbpyxJuSl7CHxO6jTdPaNfrBWndZJ9dg8cMOd0FKwvBwo
	o6YB1iL++b9+vwp8UsTwjxGzvRag6eI=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47f7872abb6so1322131f8f.3
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 02:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786870841; x=1787475641; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TB5hLITgaLSvnkEZ2ABO7VyYwwjhkPuh1sGrI3sQjr4=;
        b=eCEj80WT8wymomIn1QkbF4JKNan9onI3qnR2mZ5qSRjUlxhl1T5a27ijj7mpIpOY2L
         iYt4Lolu0nvWFdWEk7s1V5VBhQYBpf4J1hjZovd8k/CluxmV4hpYr8+SLHnKxmVxeeWg
         504DrFfef0ui3yzbwKIIZhsX32xoIULMnOPsGQ5/EyLY8PvckAxAVllhCWe4+no4bK3X
         4qxi86XhKnyO1KJP035lxeWnRDCOV7tjI7gJ7coeqXbEbUx0U/03GbYRJBw1zS4rjdFo
         ay01uE55jNDyYbQ3l32ew4pvQqS/cHqm45R3GyUj/h+3kFCyoeyMkxMp2CCzo9pLgI8Y
         3NOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786870841; x=1787475641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TB5hLITgaLSvnkEZ2ABO7VyYwwjhkPuh1sGrI3sQjr4=;
        b=OIRf1+Jo/vgW16S8mc1ymhCo0uq9+j8iiJQUOYez+zLfApTZy0iBa07QNdOwMrLbk7
         0jU7Etxzvsi4/vIkQQ4BIdbO327cZzgxGPJoCQIgDQP448kllIqCMipN0HZ1AVbZ5I3h
         nvDVnmMXaQmigdXdIWwjT2BsShg6A83g2cYhZZkhX9lbzrmnNed/2VYL1BJMj7PRkEoK
         JapxP3Y9SH8KQBj6+qvSilVT7OFxcXRawVV+2sgdqhW4pX/ZBNG2qvkGDtwKF4axnDuI
         G2AGAhj2MABWonpF4u70LE+C/E2b/HRjoIY0nAxBV0vJArmsEMqyx1PthiUPshJMMQ8x
         d30g==
X-Forwarded-Encrypted: i=1; AHgh+Ro/8YmI7/wSvQ94ruPODCGUxaBrdiqlnUGe0ww2NUREeQjn4jRAwu/tnN0a6thsKERa6BxAlEl9gg==@kvack.org
X-Gm-Message-State: AOJu0YyYdiJkyT/+OOIGMvLe6o4UOZhMapwgvCJuw6PIC/CdL946BDuB
	O1F/7QwU+xaStIIIfcmFzHi+P7fxhxChWLRHb8Cs8rSWruFn/R90fsMG
X-Gm-Gg: AR+sD11c4UmE8XewJtl4vjuNcxCWlILaToW2nSZPZYCPrGTuIj1a2+Sp6+kkH6BIdd8
	iz6v1qFyQDHosU71uT7Pztz6lii8aoIJMqdSUFai37FDDmrElPPR0Q9TZtgHlTEjdGAKBNVZauH
	c5AYZMxU+NwDEgaWUU2NUi5itQLDZnGdK7DhRaheZhRmYKEUTaq6bfotBre8cBVSDV1y1lKNU7a
	WVahqg/XC6NiIaspnBb2ZVU90HkB6j6yZIFAodFRLajh0xyg+2Vk5XFKkUfGK6ALdXM8i1hfrxX
	Rd50zpKDSMyO4sDfotIASc544WygIHtJ9Pqkxn4gwot9PVRIWnQ9MXvzpesGnTfEAy7Bq86oXaL
	awiMcm+IY6yvi+YsRcP+Okzkc1RZ7VAow+/bqWZDDjbOqJcwxlxpacK6EqSZpnaB7T3Okl3CWpc
	E9D136BZD82RhD1bsINvFSlESEAWGsSnlNuuHYZwDPUG3Aw80que9zkTkD
X-Received: by 2002:adf:f392:0:b0:46e:1815:6a83 with SMTP id ffacd0b85a97d-4816078c790mr19677263f8f.29.1786870840761;
        Sun, 16 Aug 2026 02:00:40 -0700 (PDT)
Received: from zen ([37.203.152.61])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815f2b13c3sm18665907f8f.19.2026.08.16.02.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 02:00:39 -0700 (PDT)
From: Kiarash Azarnia <kiarash.azarnia@gmail.com>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org
Cc: graf@amazon.com,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] kho: fix signed shift UB in kho_preserved_memory_reserve()
Date: Sun, 16 Aug 2026 12:30:37 +0330
Message-ID: <20260816090038.3117276-1-kiarash.azarnia@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5EA50C0004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: p7xgg5s4r9aght5jg1b4px8fynt9m5rz
X-HE-Tag: 1786870842-45656
X-HE-Meta: U2FsdGVkX19pLmwrO6BS5AdEKAL+Mf1IXlF9Sj9NZcihbihWMOjHyDbk8RbA+lAMfloMOdEGHY1KdfTBN8Gevm/Vak7su4Mf+Z6S/EOpibh4Ov3VGIBWvRMdW8sarcJ2Mc5t5/c2yOk64VfB/RazQljuAUfRNJP7LelFuOUYMTRMGjTEAE8Qs5NmGVETvwjeAN4PilY9drVGVd5QrDamzNYAQpVOtOT5fAmu3YwUb2aWbTC7rI04la5NDHdkJkqI9q4SwMhidKiTR3vf9FziYj3ENYyrQAqnm4v0ZFst6RK9QNH1nkh9qbiNww9W4UCK5wthWc/YUL6CVlf1zzKZp2LNJi3KpgovVZxRMpLz1kTh6uH891/rzZkIfiBOeN1pDxwKUWEdbUTtQ5oYWbLAjEcXHJ4nb7La8VrKCJ+xyGMB+PIoH1OIBMgFUYUJjuv+AaJy0PPadBCbPhoY5NwVcu4JDRIZQgizAuNkqQR8hHVRdkxIL65zApM2tM/CigTLqNF7vXT8ivN+iJEPM1gku2VIVCWBagwHQxghVdffkJPKwjsjzytdZwx8PfoNSxLK9Rfw10k5aSEDFTLIrhdf5u0imGnxaFyhkHvKwASgVXSxngG1V7/4EvULIYLYgH4Zaj+HpULBLa2dG2Xrmc2vh7n7NGA9k6Wv6VeOLMP6ktBrM0br9LWpRmIOdX632rEMXsBVUHeoeZRHrRpXl9wWXjNdiaxzLz6oohB84pw8C7Nd2oEQxWfcOCz6ft0eq9JfeMKBFIzV27qmo3+XJ+S+D/BhTYrJHqJvSuc/8vfgdejUyGpvWU6YhzsY6y0M/DFX5JumYUuf2jh9eTChyLrGBGZ6BDazmlPCt2+SMqXe4JNa9NQXfhVbibrLTdxDdaFnB/Sp4ZdHrzpm1wofQ0XVbBf2FTctTaSezc+uwUimjdA9hjflveONQRznYDGoCSUoU6ejj6ybfQIgl/KTO/7
 wA/RK76u
 WfFK1oIIXJDUcoUZJOoHaD2p56XaJHeCueM/INh+b10Us7PWfLRR0slKnm4S4qG59/oz44a8xa3XMLQUgSRxp+mChcVRpqxt8TtHVPkQtqK+wWF61pyJVLZKY3E9qnjscoa8ymGgg8XIGqSLBx2qXMNNxALTTlmIqfXWGGYqd1+4qk5/+obVWWg9SbZT0krzsHQTVOU8h7xaZ04MEJ2Kr79nt2/9HGoSPzOQod1XX7y0CUK/WN3aef4TvH3PueS2fDXrCw3ozEa6R9dQ2ueYMRERs/yhLi+nj+zL0JjHlsWA9ffB4DXE+1gxEs2CImR2CVVVGSmnuUTQbpZHcwWm4cZ7LFmOsxMoDmOT8tprO/VZoKHK8WWJ70Wz5E7J5TM/2GrU7ahuZwxdf/5ZbhY5tfkxqhoRxCYwDSb5zhAsdoLJISBJkVDwb3lsB/kl0XrR+haULWjHiDA3AQ7zW24OhzLNCP80V2mZl74gvHB29KijowRvp7anft3PUJXctb8Ctq1n4VgMk7MpDAMY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kho_preserved_memory_reserve() computes the size of a preserved
reservation as:

	sz = 1 << (order + PAGE_SHIFT);

`1` is a signed int, so the shift is signed-int arithmetic. For order
19 (a 2 GiB region) it produces 1 << 31, which is unrepresentable in
int and is undefined behavior; in practice it yields 0x80000000,
sign-extended on the assignment to the u64 sz. For order >= 20 the
shift count exceeds the width of int, which is also undefined. The
return value of memblock_reserve() is ignored and memblock_cap_size()
clamps the bogus size, so the kernel silently reserves the wrong
amount of memory for the preserved region.

kho_alloc_preserve() caps order at MAX_PAGE_ORDER and cannot reach
order 19, but a boot-time reserve_mem= region of at least 2 GiB drives
kho_preserve_pages() to compute order 19, and kho_preserve_pages() is
EXPORT_SYMBOL_GPL(), so the path is reachable.

Cast the shift operand to u64 so the arithmetic is done in 64 bits:

	sz = (u64)1 << (order + PAGE_SHIFT);

Fixes: 3f2ad90060f6 ("kho: adopt radix tree for preserved memory tracking")
Cc: stable@vger.kernel.org
Signed-off-by: Kiarash Azarnia <kiarash.azarnia@gmail.com>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 175c08a6e41e..c79f48bd64ac 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -501,7 +501,7 @@ static int __init kho_preserved_memory_reserve(phys_addr_t phys,
 	struct page *page;
 	u64 sz;
 
-	sz = 1 << (order + PAGE_SHIFT);
+	sz = (u64)1 << (order + PAGE_SHIFT);
 	page = kho_get_preserved_page(phys, order);
 
 	/* Reserve the memory preserved in KHO in memblock */
-- 
2.53.0


