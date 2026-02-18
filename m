Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7720EE9A049
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 03:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9B1C6B0089; Tue, 17 Feb 2026 22:45:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5C436B008A; Tue, 17 Feb 2026 22:45:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55696B008C; Tue, 17 Feb 2026 22:45:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B72986B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 22:45:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E3978B8C3
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:45:04 +0000 (UTC)
X-FDA: 84456186528.03.5EFBD77
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7970C1C0010
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:45:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=VRwjgZbI;
	spf=pass (imf18.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.171 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771386302; a=rsa-sha256;
	cv=none;
	b=CpRk4MplsJVfE/ZCMPSxJ2/faIqgoZPFXYNGxubbltHlw87u/ip/JcmkhdI3kbouyg1yH1
	Aue/O+vQ8JY6Z7O2ibhdDhYNGeljuCg8U1Q6/xEYjobRTeEAN/p75jHEGIxeWLdFQwynpv
	tVHljh9dYGjzngYHj8rUvX9AbIo0yvU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=VRwjgZbI;
	spf=pass (imf18.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.171 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771386302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NJWFOiWF36F/VYxYvq9ObLBGauZxL9efpCybptIgmjg=;
	b=YQ6yYJeJuz74ZVuiOhKwP8CDQknFImSekaiAHLki/HuFFgOZ3FESGtaGckz6R/X21eVwji
	XSgaYg5L/qSYAx4ENeqvUgLA5EfwUtE71hkZwKlKUGm9S20FSzUWn/sGQYUcRbJM/+NuM4
	lU+WZOVX9l99DCKijntuGZGbh2JmbL0=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2aae146b604so35413125ad.3
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1771386301; x=1771991101; darn=kvack.org;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NJWFOiWF36F/VYxYvq9ObLBGauZxL9efpCybptIgmjg=;
        b=VRwjgZbI+kpJ14UF4IJXN45HgQCbZVWsJojKpevZfYGJj8yXeCvD91rM638EZRl0Zl
         dloxCa2M2dGAa+UOaUCkhMg4nwMWpxzK9YT/YkmDF3EjUBhsfyItkiOGHVu7nADVsdQ+
         RxBIvG/UroKX3jH28NsT0hLY8DnwCK8M/2q/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771386301; x=1771991101;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NJWFOiWF36F/VYxYvq9ObLBGauZxL9efpCybptIgmjg=;
        b=BLNnTQnf8Jz0xlbnpW/q3eVo08XQroTdJhp0vC80PDauJKkpHQPQstMn5Ft1rjTs0I
         xluCctM/cNheebLSOU32H9BUrdKtRApK32rokqPqNuStVKS8GPMWW//y4LoECD3ubE2+
         eP8uMcAr/PRaIi9W/n+uEJj4t5m5yHZR3pLu2xo/cojlHsAJWpeRLpo0CtqLiAtNmI1X
         m5JXiliCSLMQMeqIe4ePe9LaoJ7jW01jPOrCCrhbvfziTQZshVK1nOJ/6hOs6f6KIKCy
         lhhvldEI4PPu0+uDnxDGQ9Qh7qEBcuOu9ht86KJjnLal4NRRE08NQz5uPVvobqWZhQGh
         2PcA==
X-Forwarded-Encrypted: i=1; AJvYcCWVHr3mEuh2RjxnJs5FLWuzFb4s/pDCk41ldCifL8V4odMNQaiCfdsVzw8umxhK1bxQDkImd9PPDA==@kvack.org
X-Gm-Message-State: AOJu0YyVtJKKjHgwblgn081qjdGOcUkNghZx5dOkx0A4kzlj5HELMKUm
	8CEI8/AbAmZ6J5vwhgVeYGuxhJQ94Dc/ItJ23jmIrBiidTnWNJwpY3NioUL0RFNdD+E=
X-Gm-Gg: AZuq6aJh1omy2C7Ispxlu4sr/NeBrM6xY/MxDfqwJF3vgv5QYJMqpL2EGc06AFUGNln
	QY9jMVVADA78265fOg2a8irqG581Ladi/cwSp8kK2B/mIl7ql4+Zj7Xa2rLGdiNrtZCSKYCCRd5
	ghdbUk9YZq9IdjxLcNsBbX4IfUaUXOZ8iO1AhujlTf0WRnLViHg1T68RTgsCCa4lptEIog/wZ2z
	Hh84bMC9E6yS16QfsIxab0f6twjaCbgSSzwLyNQHJ24W7Cb83igjqLDbi6sO0CYyPE4pRuQuu8r
	pUp88IsAgtnJqK/8S/5EwsyQwr7qP7AXoG1l5GWLXlOkuK9pz0rqhZ0qW2YuEcSBHm4RHf7FTN+
	oJORu8OZtj33J1Ly+/2ybQ1Emabe2RzPUcGtACO5OhE1wWwDBxelNcePcutfD5jOvSSAtiu7cFF
	X+llvpBDs46oWvDzhLgyRV
X-Received: by 2002:a17:902:f60b:b0:2a0:bb05:df4f with SMTP id d9443c01a7336-2ab4d053111mr152329315ad.44.1771386301369;
        Tue, 17 Feb 2026 19:45:01 -0800 (PST)
Received: from localhost ([175.139.248.66])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a9d58e7sm118526155ad.45.2026.02.17.19.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 19:45:00 -0800 (PST)
Date: Wed, 18 Feb 2026 11:45:01 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] mm/huge_memory: Fix use of NULL folio in
 move_pages_huge_pmd()
Message-ID: <aZU1vSmn5aF8xvJj@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.2.15 (2b349c5e) (2025-10-02)
X-Rspamd-Queue-Id: 7970C1C0010
X-Stat-Signature: 1xjdk7t9xykrkcyodh8mo5i6ax6d5dhc
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771386302-575577
X-HE-Meta: U2FsdGVkX1/M0SDU95xpnPLDtMkaXj5Rbnr2Ge/p3yZ8+uILe++UCKsUugepgV73CJYLHg98BBujfPSHC11a7Ul1EFtkeTUHPGQ90/eMpScIp6ZwcO6fWln1a7irjN+T7bIqlaWTl0UQPundDlaigSaFehoG2CTzj2CbSImp1VtmzOtkD4OP5pdw3RLYCNCkVLXxkgIqbh6qwhi1XplNlF5jqOFXahHVOxI4OuA4rJWkzMaeAz7fCpTwNtuyY8Cxbu9yZsjvSFHjNgsL46X/v8GJ4dOnsYQj0gCwk/T6XeZZKIbJSqyWxiro/HAmlFlxNwsLndgnq7KVnTUSnjPVijpnFKDt+w4ROinjS+vc6YWns0gBMrI9iXIjxOMGptj1dTWR7U61tUvN09CVGioadXXDM/LILqS+ryy6uCue1KJvlbb1xgbdYlexfe7IyP4lLAGzj9/181sJYDd1WXeD2Vf4/5p5ehdviNfN71og8A4DDpMSIGwVB93nhqIXfyBDZN527RNormsAVpt96xNLfVG8k1Rl5fIUF5RNbsEqV4EQCczS9Zio/wHIRer04BAg6CX6cAl8WDDvu9UACI5qVr5/VYStZbAdSeDfXsZ3J+bShRkCmnTWJ/9Buya3RktijgcRke8p88UPAmoC8GbdU50V3jjxSMykURd46clpu8roCoLNXtFDobSF6F6quVXfbFyNAPprtIeOxIcV4A6srw5hcJQpY3GIbiq/VCi232Jp5HLJgtFoCm/6IW0UxV7skPwVReB1q9T3o2WNMfnBL2bNIM7m9ALoLQMq14fNa6pcW355XN8fq6Lk/Rtjtb8jdr3AemBR0bxJ8jgL3afjNslxxZrN/tV9w6XHsxCHQFITQ7MDgMTJYZBGmUzmTMRqu3XznEw94xjbx5rHh1oO3vTOqiD9s1XfoTcIiLtNNj9wW6T4YFeUuDP91gRndisgkAHe/dqAdEQrXhlP6cS
 M4MeXWrP
 edXbuNLyXlLM3WL3ezOUJ3GJbRDKXMHEEZYWaqYfRI2FwT1Op8VQsrm//Hqq6hsOgpzeOKsfmwwOJd39KsfzxhqXhLW4d3TwhnA7JNKha1ismCppYoQVpOjh8paivj2YR99Dsy/WxtQyoEh4g0qMEq45efJmZ90LTywKuEqjuZhFIdKERSUV6ZptjwYjaCUsh6IzHLWqqiJg5Ms8XBv70qcn3XifZdp76TweqTsc+5E5BjbTgZhto95QZl26mfXVVFgIfNbzNem75tuVKWRELvUhxgPLX+2BZCn2FeCJVIcC4lWoJNYnLHKOFzdmZqIcYV+EhqXvjLT4cmGRzAewvY0SYs+nnZXI7JsH4VlK1okObUs8AnjIR+nUGYYiHSka934tV6Qau+GtY0x3lGyimBhZCMqlS1tvc0K1V+JkL0mUV03TDAQk2zwtLDAms5FxWvyHU0p0RYWXobERXYsZq4FGpilpXgPi1gYOrIeEpZlL04MoMOX0LDjJfkBh3ko10BhLhg63FL+m1Oj1jrAUe8NQMtxRpKO2NFNFP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_pages_huge_pmd() handles UFFDIO_MOVE for both normal THPs and huge
zero pages. For the huge zero page path, src_folio is explicitly set to
NULL (used as a sentinel to skip folio operations like lock and rmap).

In the huge zero page branch, src_folio is NULL, so folio_mk_pmd(NULL,
pgprot) passes NULL through folio_pfn() and page_to_pfn(). With
SPARSEMEM_VMEMMAP this silently produces a bogus PFN, installing a PMD
pointing to non-existent physical memory. On other memory models it
is a NULL dereference.

Use page_folio(src_page) to obtain the valid huge zero folio from the
page, which was obtained from pmd_page() and remains valid throughout.

Fixes: e3981db444a0 ("mm: add folio_mk_pmd()")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 44ff8a648afd..fed57951a7cd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2794,7 +2794,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
 	} else {
 		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
-		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
+		_dst_pmd = folio_mk_pmd(page_folio(src_page), dst_vma->vm_page_prot);
 	}
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
 
-- 
2.51.2


