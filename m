Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D715E9A04A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 03:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8956B0088; Tue, 17 Feb 2026 22:45:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658566B008A; Tue, 17 Feb 2026 22:45:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543F96B008C; Tue, 17 Feb 2026 22:45:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 41EC86B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 22:45:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10C06589BA
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:45:25 +0000 (UTC)
X-FDA: 84456187410.01.387C48A
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	by imf24.hostedemail.com (Postfix) with ESMTP id 40981180007
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:45:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=hOWx1uii;
	spf=pass (imf24.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.196 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771386323; a=rsa-sha256;
	cv=none;
	b=xUNIqD7NXd3ZPBOErfMzvb43xEvCu3FGs9W2fvjW6IG2e0qWXytARFqPLYiCO7ijOFekwl
	v/TBVRpr5vSLxXYFG0UOpyOG5SGAE5Uhz+C+8b2rG4i3p4wIensWBSZ9hxaFB6YfRqKESW
	fIntALUYaIUUkDwSyJ+aPwCxIPl/ItA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=hOWx1uii;
	spf=pass (imf24.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.196 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771386323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LrPqeRMVexCnZ04Cs9L6s3qrPGGSz8yolplFHjrk3wU=;
	b=ZMBfq7+YFKIrnY7bprHtCOT03Afx3JA7GdarfNhvZ5eP/i8Me9G9VD6BTEL3lI8DYq3S15
	a8PtHULy2XVHcQscg/0sQ7HTYsChCZvpQ1U9V7aBc4A8CUSX/rVJvgpYLVMoUe4f1FqukU
	mEqqyPQS6Uvuue5aFvPQjA6LESqP7mY=
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2aad1bb5058so49746395ad.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1771386322; x=1771991122; darn=kvack.org;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LrPqeRMVexCnZ04Cs9L6s3qrPGGSz8yolplFHjrk3wU=;
        b=hOWx1uiicAPuc4WpxajNjo2R+qSHlCKAIrC3nhxYkwbEU4IGq5v3ROydk3nc9lqyiE
         cKvsBYD+RxlE4XHVygxOXDkMPJNi08UshdTe/KszYZa1e9sAfJ1sw1pzqHulwt6g/bns
         nalxxa4A2lZWkzAqnhIAt9J4ZLFknkBPBTGzo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771386322; x=1771991122;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LrPqeRMVexCnZ04Cs9L6s3qrPGGSz8yolplFHjrk3wU=;
        b=GqPD2G1e7MEXxgebXrDz3P03Reo4bHRHFnTy4fSKsGpeoO7nWpwWnrHWeORXyiBwJy
         D4zxH32Sbw4PpJ0LnooKQWPFeyxNqnJbUFanmevHkIR2d8ZcUPB4wyYBe5k2UgdXv2XR
         HqtbVTC3iAk7zvipxhUqESNqgyvgQ98VNHJ7kDdN33RK4qOdrJgCDG3Wx4K+0aDVBhJa
         GoflRJdh2gE3ioZcj79efvVpMhbSjO0QNEwVEBNVr6eQrM5ciClfcm++VMDnJ/kE8RB6
         /yHvWxC1b9+CErI3CoVvzuKs4/wsXodPE+heF/+EeoBtza56HRCCv5QnpyrXRTlppf50
         YBYg==
X-Forwarded-Encrypted: i=1; AJvYcCUIl2U1298Cz5yC2iHZl3OeEP/ctEqglpp2MVdK/e7Euwsb6kpbvSLrbzDu5o3vRbJZdEmdFZ/gJg==@kvack.org
X-Gm-Message-State: AOJu0YwmK7Ux/yf27341HmpbpVyOvCDxzSAEfhdSx3FOAZkWExe/eM1B
	t9ad6mG4tpOtH7VHsbJTktkdYe/as5vXW28PSZAgJ6ubePtyP/6CuCCue4D5Nby9ztw=
X-Gm-Gg: AZuq6aKk1jvGy7it2iONIhn/9YXWMzc4cKgpat+Ai8+ktXG31TDsNTlsJd/zLNt3rZn
	+fbJVMg7ipWSJ+ouF0PhPeGAwgxuCJHZ/BmnigN5dKucgr3wFVlFliAi/C1RB0cl959DULflSNQ
	ocOure+edm0L+4IoXPxHv6wU6bg72uc+QKmQlsCbRkuuzNw8OF1I695eRfvNesyp956Onnsyj8A
	F1ki58BEs5zzgG0Vjt2iXRGdJ4l8emHnZxHUn2fEWNUZFHQDlIWMLZDTPk8vBGZt69lORvM0C6j
	lanC0/feeypyRsR8INDZpRezZebr15Fx8BwWE/yZHQ8FKJx3MhTRU3f43vidZGN3QEC0pjYU7y5
	MdRBVehgc1wJvYFUZi2KyMuMDPDF6K5Ayy66alg6SDaotL8E5eMxht16Qao7ki3hJnop8S1sHPT
	5T9VDaBpGlRVZRopWpKxcD
X-Received: by 2002:a17:903:1c9:b0:2aa:d6d5:773c with SMTP id d9443c01a7336-2ad50ec36f5mr6655225ad.25.1771386322192;
        Tue, 17 Feb 2026 19:45:22 -0800 (PST)
Received: from localhost ([175.139.248.66])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3567e3f54fasm19644387a91.0.2026.02.17.19.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 19:45:21 -0800 (PST)
Date: Wed, 18 Feb 2026 11:45:21 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/2] mm/huge_memory: Mark moved huge zero page PMD as special
Message-ID: <aZU10aBZxCHfmjeB@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.2.15 (2b349c5e) (2025-10-02)
X-Rspamd-Queue-Id: 40981180007
X-Stat-Signature: a1e3mkhskjiker5m19tmx4bepb3q99em
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771386323-800527
X-HE-Meta: U2FsdGVkX1+QfDvi9Fqnz+FxznMOv/qAkMw6qRi+ll7EbtkeZPVOhnLAkWo76LYADjP3A1k+XDoe1PSNnJbEmX218YcqE0BbSv8R53qthh3Oru2iy2nz7DlGHSSG3ZGWMGCuiSdFgMxzjo7T/3qEi/zH1a+wRSU1wKy3bwBwLlcfUhadhndHoJlbKA2Telo3B5IZdd67P3Koo225wTNcJYnQDWul8klPBCR4f3HD4hr+oljrRQT4kQPG1ZjmGpusoalWvZsRa5nPueWqX+RmRFFSXqOLIo2RJ3t0S5yikhdH1Woc+xJRRMQvnVeTbLYb21Ynflat5z2+yBD5ZIOVE46MoZhviW7ElhU7li5IOSJ+j/xQHkUEFyiUaDWz6lPZpGW3ixBCVMvDvEcAH41xipSlTx1tow9sPIAsVCD6Hf3B2w6A69gb6DjA7KLrBeU2qb3Ud1SjWuiO2F+NkoO9zNKVmQo7MUqMNws64l5jtQftUkXEyw3whGuItl98IMVv5Hl5YndL6SexrUtaBjxEqDp5pxndyjZZr6D0uEEamx82Avz71kaE+Zw89w3ev8x1hfWHRVqI9ayjiCg4PhpMlBYjBNPtkmJdeR7ddxiiePJd4vzbn+iMDVmdymDoS5fOvkTqLcGDJPCfp/Ays4k2hfyRjwPNfwK4NfrYH4UUhXHv+p2NpeabvhcrAxtaeOgkNYG5cfJR+l8PbPSoKFZx/vZRA/maVzLeCm0PcMMuL6Np848IlT43HJHgrduaawxoetWSArjSHmAN9Xvo/QYdqWSkq6TTR6d3iZxdkv8NkiUogdJuWiVWwUgevhuHctivH6nWQTC3MBXK4hNWgZogEpHCZHNYZprR4qCA3ULP6yXFiJ9lmW/+R3hXg0WhJpG6E7tUMrxeJqa2cAn+SU4IQKzX9vprhqHFD3aEsvwryPc523cW4kxaOyuYtElXI0G0qYYeMMQ80/VtOzQhUSE
 jkZL0Ra+
 Rycu6ZPSfyLQvBdcV0fD0Py4Qh6bWCy7XMgLEbx+1fqoWc5x7OfM5emVO+XzJC9CwIZXXrvs/IpLkwKbZATxrGBpaErZ2xBR4kiNUC8zzL/fc0v+YEAQnrjyX5YbHGND8D80OLq+cBfVitdJR/cKx8dUaHd3gnkFSW3QfPOybpbJbqgazrDxORXM5Ly9Yi01lxhoM21pMrEs39M1J3JkljYWyn8Yi9+0YUiYOPakOGZYXEPU3xsh3OIYIepgcMmGME1cN89tEqx5V33qpWvGOqIC6E80TapgnyQ/XZSULfz+4MMYsieG2Yq6UfhMAPCE0lJ8/2XaObthikJsjmTJWdAjxwXVnUYRPdyfHLbuFRW+KOsI2++JyZgjOXD4G2BuRIvDisP1kZn6IHeO4QC8iU5YjPPqvkZrED/+deg6nvnKftsO0curAD7PtApxHG/cwSZeGbnTFAm+mShYAgEf/jYFH6ivoejzWcEYWGs59UihJyRZNWOANFPUs2KbakSekrakuQINGERi2gqx+hB5IF5A6nV9bz/wMxtFOWRXaX2PC46n1bs6ftDw0rZWltmnu29N7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000085, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Without pmd_mkspecial(), vm_normal_page_pmd() on architectures with
CONFIG_ARCH_HAS_PTE_SPECIAL does not recognise the moved huge zero page
as special, incorrectly treating it as a normal page and corrupting its
refcount.

Fixes: d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 mm/huge_memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fed57951a7cd..5f908cdb11f1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2795,6 +2795,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 	} else {
 		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
 		_dst_pmd = folio_mk_pmd(page_folio(src_page), dst_vma->vm_page_prot);
+		_dst_pmd = pmd_mkspecial(_dst_pmd);
 	}
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
 
-- 
2.51.2


