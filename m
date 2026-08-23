Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 459AFC5DF81
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 16:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087AC6B008C; Sun, 23 Aug 2026 12:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060036B0092; Sun, 23 Aug 2026 12:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8FEC6B0095; Sun, 23 Aug 2026 12:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE74A6B008C
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:52:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2CE6DA0350
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 16:52:55 +0000 (UTC)
X-FDA: 85133128710.14.BA26C3C
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5F4B640005
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 16:52:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a4AxxIj7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of abarnas@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=abarnas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787503973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QjRcKycCgEIdRjuuH2tPItX4wlK7ZDllY3I75Ar7NjE=;
	b=Pzfujfp+zUVwQOqFHzhqoM6O39HaPo03nx+KnIip+FBOuSQQPecThWwlYNh5IYpjF+v2Y6
	5Oqfijn4+z9G4lpmxErmVxmPbAXgh/MDI02GDUwPdh4pjumgMY6uQQglXazg0uqP2xCEO/
	oRuZwuolGPe89VzIEVf7T/AOSEqiE7U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a4AxxIj7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of abarnas@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=abarnas@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787503973;
	b=LJKMv0cxnemjQNG3LvSM2e+Iv7lRZ0E8jJOB1mP/p2J93oPvqz8SRVW0R1XcaJ8Yu0cGnu
	EMre8rka9WxRFRsS6WSv2kcPxjlxmD0AQ/m8mcPAYJqRUFbboeyXWA486WXBC4gPRQGiGE
	nZmoIKRDqZw5A4iqj5iXmoCUrMS+vVc=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so24273295e9.0
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 09:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787503972; x=1788108772; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QjRcKycCgEIdRjuuH2tPItX4wlK7ZDllY3I75Ar7NjE=;
        b=a4AxxIj7N5nhZXbu7M++/UsOtd0L0E9ksDqnKvLJpvhxJtaoW6zqlt3LkJpFHoipIh
         n+vfo7vLMp1mR7f12WIBHJ4ULvdOqyHQKk91dSbccrhL1BN0wROS8R6+LMsnOfMm1gu5
         IndSRzgSb0fNrG4plZEGGUodlEV/8S18jPklvBRHhmUZWGQaRqdPF+EDDn9SqDcrJwFw
         B2KtJezr8OpUixSSZY5yDl+i1jWlnDWTgffRWT4U4QtqCWK5T2k7ba/fz8r3+WMebDqH
         ZqiouRBCKhZQToEKcerW/EEPeB+UyOsqdJxrokY3/Zmzkz6b7ntnIT4jDHsP9M7lVago
         E+OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787503972; x=1788108772;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QjRcKycCgEIdRjuuH2tPItX4wlK7ZDllY3I75Ar7NjE=;
        b=PBdcj0sr24OumH09c/1GeBLcE/YH4IENtz/xIXDB/hTV/GNP4LZaK+lXkr7Gtf9r41
         H5j2Ij9vbKcgs38GNkybnV0EjsLYt7xhKrdRcEVTg3vSbZZ79SnD2BSLyh08kYXvsTBk
         R1aTVTDZj6/FUFAoY4M1RIGyT2K2E/YlAdBSBJ3m4GWKPF11HljBG/z4AP5nJ+QYU9rN
         DfQz/P0mNpkCXHX/H332bOCfp8hdjSgQcQ1TrfpQ6YqPnUW4jIIsC5xP2LfD9Z0A7aPY
         UIYTuYJt11zXremMfJx+aPOqpRdJeg0Wm98V09pOm/OnQgfZsSAJJDMawC4QsZhmHPsc
         l+AQ==
X-Forwarded-Encrypted: i=1; AHgh+RpwviaaMr5xM/nojOaDLbbjOJHUIB57MmYgX2PU0SHVH9Zwfald4705KiNaMda/P3XnfgtjAi5OHQ==@kvack.org
X-Gm-Message-State: AFuF++kZp0etW8YUCS6KHujeD4o+uKy3Qd75t+KEfuNpJW4CeLIPX7Kf
	mrP5ccas7wNXO/sgDObEMAsEhAfYIJ4C8tGbSnV5lIjTFqRWEcxDyXcgLEbkek9auA==
X-Gm-Gg: AR+sD13xgEs3m+7ng5fFjvf6b2sJxCVQvrLrqbPRBlYMRxGp6sLktVK7F9WTV0Rn3Ce
	rxmpfsCD5k1aauLpoZ5SSPewb2m+9WJIgnN8ffIgKtmQ/aIXk0uPejKMnzzYKeoWjcvssz2cltv
	q0+/2Mf8vB6eD4ce/VKnl+O9ELZNlBLpldkzELTTh9Xj+RyzEGlGIqwjzdIo+VY3BTciu7nmglR
	jsKsSkV1gOIMnV61Q3RCvAnpuPcZ0pf/+Vl9wu4PKYVfDgsoguSdrrTGffhcrYSpSKK7Zcrh8W2
	cyZZ7aD+ca1fIk0DaWcwnK0rlBPu6YYr1baZ2AUVI05SbkQ2jP+ItR2d516eSVHtTszrK+w0oKJ
	nAEGLWpOVv4gi1iEi15H4cJ+L78/aQpp6Ye/tsl4xWvObil7KovVq2HuLZqiZBI+XeDzAPTApBd
	t/Hk72kVfwwpXOmXlY94qzrDEFrJGXp3RivSack6Z9yPAFA2TCA8nar+ZszdcSkVY54GFsCdRI1
	e1i7E3gQlWqWiQ637W8SOZZR+bO2nV5Qfp793l5mFZTDoAT
X-Received: by 2002:a05:600c:34c6:b0:499:5f7a:7ea2 with SMTP id 5b1f17b1804b1-499c19cbbd7mr122720055e9.12.1787503971299;
        Sun, 23 Aug 2026 09:52:51 -0700 (PDT)
Received: from google.com (78.207.190.35.bc.googleusercontent.com. [35.190.207.78])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499c33098besm53780005e9.0.2026.08.23.09.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 09:52:50 -0700 (PDT)
Date: Sun, 23 Aug 2026 16:52:47 +0000
From: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org
Subject: Re: [RFC PATCH 5/9] arm64: mm: Permit permissions changes on huge
 vmappings
Message-ID: <aoslX8cDCR647ebE@google.com>
References: <20260822135323.795946-11-ardb+git@google.com>
 <20260822135323.795946-16-ardb+git@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260822135323.795946-16-ardb+git@google.com>
X-Rspam-User: 
X-Stat-Signature: b616qzmgfiwxgq13ezdnnrrrbbuqcb4o
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5F4B640005
X-HE-Tag: 1787503973-639756
X-HE-Meta: U2FsdGVkX18dt5Xr9n2R4r/pLHjyZbSmJ/2OI6y1TsFMTUQPMQQkMRMVOWoKfN/7vgxN0pH1o41F67cNCkk/7gfqSX5KYaRgbnMWyOu2BvihKj3oy+Afu3z4UdJekjFKCgUbFTN/nM2RYBsMrivHoBr7IhemIjcXJ9Pkfy7xfjLBi5qc0Tk45EWp06sVXdCl3XQyRITpXQWh9THE4muUmnoNeZXRBK8zvUejhkHZgrsLuQBnnWdM3DY6PX3klPnEep3BjpMylbyo03mgNFwn700Q9z30Tf2kpFHg/UQaqWDB0BpRkh2zdOy+7oI7p2pr1ZhfmPBa/nVer3W9LUAlPrQLTc/eeM6YEd8CzxdUmFYRjOe8amIziPnLsv9C3DGOCMHmHopBsH0ZjRtPaNH7qoF4nkw5P5Kn/kB8Cd5z74xDg6iR3jMp7enDdDArnecFrHTBgHMESoAoqNK+fAfJwdmpAb8flJBiachrEyag+VfhER6U7J9/HvT/CGKJQf9rKD4rZ/ZTniXLYmiM4a4mUG9F30THt74OF+auneB5iT3R85QhivxWdrdOj2EgJktGiutQLoOD3N/SkezWZt0vhHovcmU0fK0UzVJuRzQRgv1Ir8SZt33AGFuVAnBWT4qzXvnBNwkf9ZJwreOlTZTV97q9aqSH3MPuQ64IlNt1eKZzfrVyX2E0qSidFiPSQb7rNHqjuxLBZH0rN+VT2TQFzYfk4JTLtWPqB5LfD5xMjVhv8iaHq+7b3UMz/WF3mlJVlkF3hG5gff3Nfc4tV60fzkzbon+/r/FvB3QZeXu/2xcaB+x4yqM4ACPgbvK7+SYgkNEBV3MCcWZqnC12Jvqjk8QBH4xxMc4cjbR0av6ramfHKLD/qEBb+QHYPzfJhfebX6QXMIVxtyhchrkZZD2k0a9KnRBOqMN3UvoYd6c/1zUy2xuJWGI/c0gYDWSpaSRgkeCzums+PUvDuYG+t5W
 fG2nQOId
 /ermGQ1jgL9HLxjLbXPpS569dDwZ7ifaTq3toWv5+ChLjUbWs8doggHeq5+VDsOCRxMQ1dKDqU3sLipk7EPsKw+rEM+DHwVpElrN9rQPswSYWFyv4mF/jEnGR8AqcO+LwFsY7aTieSJih3rT8xhLauEfMvBDmcmsQwR9kiCArzb3Ue87ECiecs5XzxlypmfqHcFDMr/LqmbToS4hXPiUcKxbzr+AWXGAeWYDIypGn8Evik0ZSOWnqubkvIRw+meEGZUSZU+pK3geyt44P6/tmMb7NXSiRFQsOccL63YulIqd17oX7zcP/9K9F8fcO2FsAy9HUNlBCapTTEo+eHy496Qdz8qqA4YnCOXTE0vzMqlOTTW4DL0x95wD08PhyOgy59xVrEgov0YMIat1WZhv/2awzZgfs2oVdFKDCqbRtys056PoT/iEpEukiyHUluWGkC+r8rZxkXneKvyyw2M1sGZS6RzgKcFGIm+vWlQU3jmB9IzTksF3SL9pH58NykvZA6X89XMtBawkxDrU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ard

On Sat, Aug 22, 2026 at 03:53:27PM +0200, Ard Biesheuvel wrote:
>From: Ard Biesheuvel <ardb@kernel.org>
>
>Allow permission changes on huge vmappings in cases where no splitting
>is needed (i.e., the region is aligned sufficiently), or when the system
>has support for splitting live mappings.
>
>Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>---
> arch/arm64/mm/pageattr.c | 13 ++++++++++---
> 1 file changed, 10 insertions(+), 3 deletions(-)
>
>diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>index bbe98ac9ad8c..20ff9cb273c1 100644
>--- a/arch/arm64/mm/pageattr.c
>+++ b/arch/arm64/mm/pageattr.c
>@@ -169,8 +169,6 @@ static int change_memory_common(unsigned long addr, int numpages,
> 	 * we are operating on does not result in such splitting.
> 	 *
> 	 * Let's restrict ourselves to mappings created by vmalloc (or vmap).
>-	 * Disallow VM_ALLOW_HUGE_VMAP mappings to guarantee that only page
>-	 * mappings are updated and splitting is never needed.
> 	 *
> 	 * So check whether the [addr, addr + size) interval is entirely
> 	 * covered by precisely one VM area that has the VM_ALLOC flag set.
>@@ -179,7 +177,16 @@ static int change_memory_common(unsigned long addr, int numpages,
> 	if (!area ||
> 	    ((unsigned long)kasan_reset_tag((void *)end) >
> 	     (unsigned long)kasan_reset_tag(area->addr) + area->size) ||
>-	    ((area->flags & (VM_ALLOC | VM_ALLOW_HUGE_VMAP)) != VM_ALLOC))
>+	    !(area->flags & VM_ALLOC))
>+               return -EINVAL;
>+
>+	/*
>+	 * Disallow VM_ALLOW_HUGE_VMAP mappings unless the region is PMD
>+	 * aligned, or splitting live huge mappings is supported.
>+	 */
>+	if ((area->flags & VM_ALLOW_HUGE_VMAP) &&
>+	   ((start % PMD_SIZE) || (size % PMD_SIZE)) &&

If I understand the intention here correctly, I don't think it is valid. Even   
if it is PMD-sized and PMD-aligned, it would still cause a split because  
the loop below is not using page order, but performs attribute changes 
page by page.                                                                     
                                                                             
Best regards,                                                               
Adrian

