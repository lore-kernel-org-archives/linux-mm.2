Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E62D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 15:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FDA36B0005; Tue,  9 Dec 2025 10:10:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AE666B0007; Tue,  9 Dec 2025 10:10:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBFF6B0008; Tue,  9 Dec 2025 10:10:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 209D76B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 10:10:58 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9E66A13396D
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 15:10:57 +0000 (UTC)
X-FDA: 84200270154.23.045CF7E
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id C1269140019
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 15:10:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MKeRU64A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765293055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=49DxwA4IERFFfQvlNFCEhllKAUT3KrhJruYrNRHk3/w=;
	b=KoJ6sA1bzPUxSUer3Cb5xXhdwkjoAfBRDXkGJEZOdlssSOQFQVTM4hfznGKs52NK0cCFV4
	ZhWyxNV8X6nkDHAyqBkAjxD5Lrt35wtNYTxH0UucGxS4IYLA+VvRM6qML6dB0oYzqufWDY
	JFaf58GeB5LLw8bEvF4xEBXFPOXVULo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MKeRU64A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765293055; a=rsa-sha256;
	cv=none;
	b=A9VtrNykYlLjosUFgx+ULLUF0cp+jqyHqwDkyGuc/3DdRRpjx7FGCc+k8j3NdL6kAQOR+7
	LyYBD6PDSxbvTWDfKAWG7eOKNQ64oYRHXcjfT6j0Q13LSZrG0v3Kuf/l+DKZW+u9LmIhHI
	Lm2mlZa/6311bMnKK6/YacQ2SvfhgqA=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-29ba9249e9dso80371085ad.3
        for <linux-mm@kvack.org>; Tue, 09 Dec 2025 07:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765293054; x=1765897854; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=49DxwA4IERFFfQvlNFCEhllKAUT3KrhJruYrNRHk3/w=;
        b=MKeRU64AnVO6yaHNYLQiaZRMb5tZ+uZjhcM2QmL7VfRLJv9Rtz5wNNQUpiCQ67xSq9
         mn/JpAOeN3EHsFK5g9hiAcCYUBCLiZjjE0UYxlyDxGbxQa9GaKS6cpYzB6goRMZs5a6t
         0kjhzzOjWIawPn6oFw8ZwV2nfYlarc8izb+HvfVYob+io/fvFfFhUZrllWFXakRItFIL
         aFrtGGrXWbdLX3qGuB2zhLbrh7UNiF6DuoAHDeLsOVODGZ4zR3LzIzbDb52McvwbDSv2
         Vg/X4+ZKajMW7Gp2dGsY/DGqcHUt1UgjRzl8djRD/+m3wArm3kiyVWJJ8tEqNruuSpgv
         x4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765293054; x=1765897854;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=49DxwA4IERFFfQvlNFCEhllKAUT3KrhJruYrNRHk3/w=;
        b=jt7tSu2h27odAV7P86qzXC41Cu/F9Pnai0m4GV+HMSK/62Fiqea8wquL/Fbih2iS/1
         uU3+C4xz5ZsVRwaafQHEzgShbygBdzIt4fEoWnPkR6Wjj/aUpgXbj6KpSnz2rAQT8i9i
         +HjN7Yv6I2uxT3bBWW5Mrbk6IIFONo7X8+fywGfelYY9GXgbwzaboNa9OLXgUIQ2J0Oh
         iSgqMJEu4/5/9Oi80MjEVnmwzX0Navz0WN/nqg4stLjkUN9BLHL81WUm43dPfhpzNbP0
         xd8HD0zVbtdMZIex9TNrrpzSjxbkBI9ZZ6mwpdBI99gCFkK8wW8KvntrZbbw43I2Jdx/
         kadA==
X-Gm-Message-State: AOJu0Yypuvg6oiyrabFn+q0CHYkBMOXIZzpuI+bOy/ahVU7Zz5rvTBxO
	oXO6R2k2nCeErsHskaqaDobCQNJj41sdVmgyRmqxLlCI3Fr9zzK5Tr9U
X-Gm-Gg: AY/fxX6rRcm4gtQ13jEq1vPSppW9OHbl9GQwfhGDQ9UZhaG5Ryle0Mg4yuPbY6rmuaw
	gwTkaO9WipmphTLbDrgYpDkhjXMd97IpG83e3EE7MasF3rrPR+puy7jJ40Hpy0DSBlLt9HMNfOk
	fPHWAcyDdxqVR6jF5dD13Cie/VSVnK/2LjHfaHeQ19YFstQ0FnIsfvLiKILubGwbHaPQXwWpOrY
	Gl+YiEKlcyQdSJj5p9oGLLwfjee5SfxpJG/hOweF9ess28tndTntmWdMfmRUgFKEx5tQEH5c1Pj
	gjSHQmNeC5+O+tydmkm8ixwOgOU8ifPuOlWnhwspvxGR9rw2aIZrFxlYoFM/LDnrgREEke7LCH6
	OPwry9INoO8VOCh28QSohnkS0+UGyD3fWRyoLRV/izWayBV87f9iLhS+9lkWuUdl8/j0fZzRoHQ
	wsVxNzpmZ8GTMhwksPaD8aKm1yDA==
X-Google-Smtp-Source: AGHT+IECVUNK7oNWE2SGrCYOjERm1R1tBpS+ZJuNzaphn+nqQg3fHnMx9oFUnZ+wKNMrX7vd32KDhQ==
X-Received: by 2002:a17:902:f603:b0:296:3f23:b909 with SMTP id d9443c01a7336-29df5dc1415mr117408965ad.39.1765293054198;
        Tue, 09 Dec 2025 07:10:54 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:8d27:8b88:232c:c7ba])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29daeae6e88sm160223685ad.92.2025.12.09.07.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 07:10:53 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: damon@lists.linux.dev
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	sj@kernel.org,
	akinobu.mita@gmail.com
Subject: [PATCH] mm/damon/vaddr: fix missing pte_unmap_unlock in damos_va_migrate_pmd_entry()
Date: Wed, 10 Dec 2025 00:10:34 +0900
Message-ID: <20251209151034.77221-1-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 17xf8crt1k97sxjh5t9bfeq3g5ofm9bg
X-Rspamd-Queue-Id: C1269140019
X-Rspamd-Server: rspam06
X-HE-Tag: 1765293055-429197
X-HE-Meta: U2FsdGVkX1/ufSBYSrOp2ImfLl+NyjGgJS0AsviQYw8S7WrXXt5dIpEj0hyUpttAQ/+/EoHp8q/7mENU/rIdm52WOfhWQS2krMWSv88asM6yJiQOzsqD5lEDmsYpaTREKPyezHroaPRJVMsFO11qqiYAhpftnkbAWfMFkbPqRdWtChmD4YPdcxG7ViNcaSFswY+TRZr+SoGO9I1nYb4VdkpjtJqtJb0aMwd6Y54JIZRb6FkjsWMw5OE9flwZZVE+M85oqd7roCpMdkUAEaGnQkaB4ttWENIVsUwqOJGfYVExbhNWBFxzQkTpqsC+821I8KQMDdODVkkpIgLAXK6LekAQKv/Ds1XKyyVMXtm53gSYxlq9prTawNtJVpdC9Xbts/GEifio+wHUjt3jsAb7ScAjZ0JTpxXRy+JLhJts8hLe5A3cwyWRAIICai9sCPYdSS9gAQ0SA0yqTBy26ikzMqgkOsFVJ4tjae5+IlcCQjW3OtxqUnGKsglEr2wtZ5KQM88Qto0lavpBIKGRGeRzeD7f4xrtk7oRjesJy6p0vd7nbKqJ9Kvlq4hAkzJgJM9R9YtevFG663ZttIT8l9Y34pVEGy9tMriaykkRTZUKy2eGNZdUi6fUzGUJVvROi3t3XRPbRSgE/EzFXznG3zszxWtMiSyi+1hlMJNNc1ManZm3cY9QhWAPOQn8R74cqmzbWH/Go7F2bYC+mJIohZHYdjrPIBjcAwALzn9X7gTUEQiAt8lNTtc0jfG2BhlOIMnWNPOLp6i/E/BUS4QkNCCrWiDLwYkdhK8RpCAgsUVjQFP/oW0gjMIsR/fDi26MnSEfLWQxTGBeeTAlAsVkCLcuPdJERex8Ayp+v9J0aKJtvWeNfMk+S6LE507i+HSIhZnezEx/3QcqdJnexcHwjopdNgTA6SCS/sEWyz6eEApuD+SKUf7GIDu//CYRFsXL1V6nkw4ySw4ovS5dCXnnRUv
 hc3B8c//
 DwNb2pBJAlGL9imzEKUumc3hUbeGtoha5rxxZ4nYYSmAvcGpIMPWL1pDOU74ctMXPPokhhqaMkTybJgn25KxQg2sHLZgG93ipimnXJ/ZIBJ8uty89eYVL0B0MbRTvBTehlB4I3A8W6RTrclhbjl/EWwG8iHaR+QX65wBq9LNI3LneuUZDe5rUFacn+FH2nwQG2NPX12/l6QexQ2nSUW1goDwTWfN5hToo4L2xeFUXXIPjAoQ06fKpcndD4eaGKGIqxZWVvV+ELa/b3uYI2ftVnYL/UCUS5Tu7vA+ynA8D4gtXw5Z19MyOZWj/ZvYn9UP7ttU5r9CuFsfEx4krWrdYiFoLpJKRmTPzpXREf8TBKdPAs9M8heTJQM0u8/mlI4DONNujlJ9zB+ZW+jU3lHgzOzsQzA7NlVpP+3mGTbIw1E33ghruwA+9pZUH7PuyV8Vc5TsPZdWpcTNvZhB3ddrTKoTPF7slVH6ozxgp62zo4z9VsZ7EbzhjYgEyBlaoxBZIs/UnR6RhKUabWoctenPnQn7ldakDbW1uF8wWJCMZCEdJVwvaHaLdLplblsjiHb1/LhPD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000198, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the PTE page table lock is acquired by pte_offset_map_lock(), the lock
must be released via pte_unmap_unlock().

However, in damos_va_migrate_pmd_entry(), if damos_va_filter_out() returns
true, it immediately returns without releasing the lock.

This fixes the issue by not stopping page table traversal when
damos_va_filter_out() returns true and ensuring that the lock is released.

Fixes: 09efc56a3b1c ("mm/damon/vaddr: consistently use only pmd_entry for damos_migrate")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 mm/damon/vaddr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 2750c88e7225..23ed738a0bd6 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -743,7 +743,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		if (!folio)
 			continue;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
-			return 0;
+			continue;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
 		nr = folio_nr_pages(folio);
-- 
2.43.0


