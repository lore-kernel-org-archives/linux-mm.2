Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E803AFF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 22:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3635F6B008A; Sat, 25 Apr 2026 18:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3141D6B008C; Sat, 25 Apr 2026 18:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22A806B0092; Sat, 25 Apr 2026 18:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 121006B008A
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 18:01:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8CB451C0592
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 22:01:39 +0000 (UTC)
X-FDA: 84698450718.11.D51A244
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 987822000B
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 22:01:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="d59uV/ih";
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777154497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35JI4T42UkEo4Y0KyaDcg3Nod1MWEvkh5LAwsg4s+/s=;
	b=DLkGlKVi3BkxeW+ssvrskfNEDJhqHqxgA25hK0i1tKgAygGQoiybqjayxIsCE7dq8hKhlp
	XNCeg4QIuP9e6x/0c9biH9Ex9blG5SFbxE1fFxomFygjYimucp4nJgkgZb2ZvHc82Wdr9e
	PO/lRHB+sjbtVJ5mmjoHCBmesr8hL9s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="d59uV/ih";
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777154497; a=rsa-sha256;
	cv=none;
	b=g7WixqkECZHqPXkdfaT7GH6qnk/lKbpF3e3xfrBu8FmH1KtqMEFY21H2x8riTctGpasyCp
	pTktd8Fy9sWmdFicC40GaR+qq2GnEyQc8KIW1bk/6qbDzC7olPZvF77kKGwUnPs05GK4nD
	52zp5gtbj6iVz6e/AVETdzhRjeIKrIU=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso92546745e9.1
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 15:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777154496; x=1777759296; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=35JI4T42UkEo4Y0KyaDcg3Nod1MWEvkh5LAwsg4s+/s=;
        b=d59uV/ihglKUq4yuDu8KXWcgV1F+phdOnE8dC5DpiSHyvRFVolt1cEtJEkTEzCLz+K
         gJLXlQFVUS9k7Ju9mNF0wNZIULgSiVF3bfr95QBAbd5TkENUu8eghMX8Gr8b71cxHbBm
         gZH2xZikYaYgL4yybghNyUilmbvhDIoPbkxHwjBIil9p6KBVk2857HiUib62oZxMj3MY
         To9GHK3yh2a+z5+LCLymYah/C9kTN3NVSw56/1gLUfShR5w5Zc3B3w0D9jfzJCGAUEV/
         whXGIW+VmZRVaobfz3dH09I71GhJYjRd4CGUiHAzVIGmfzmNcZyFemaNqBtIS7q0Tt3Z
         NsRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777154496; x=1777759296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=35JI4T42UkEo4Y0KyaDcg3Nod1MWEvkh5LAwsg4s+/s=;
        b=dJbwjtYIUZMi3kG8tMV5nbHhk8A2cAkZYqJEUclsikni6YtUICUJJhowh2sonPR3Ik
         DSRpxZBM5PCo6I4TmoU5L8M1Ys+FmiIux06ZEx1hgfFm4v6pDxBHBwylu8S0Re+MqX3L
         +ZqNL74s+h15GIb07ORl4b54VwgD/c5OACwWJznLk1vHRz6IUAOZtC01kT3hn8za3vlj
         s5mXD+0dlvwprsuDh0hcyptG/M87dz0h0qlgwV/zZSfQkpecYhB/EYaxYFN0Kx2DfI/c
         BJ8pXETie3t4i4HxEie5gtswmDdeuI11BB7WF1NAwn2kuDG2Nz1j066PJwyZwv8QjCOy
         FsLQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Zp0sNKWBXBm5oIEAo6Xv4RprcDDVfg8yMelgQJHNkeTy6nj6Gt7PQo/mQDvTLeF36+H3DGx43nA==@kvack.org
X-Gm-Message-State: AOJu0YzLnywYUl8FdDsaYBM8nVRk25Pn7MOasInVGxpladYU5F3MezkI
	KwMfISq1fyyzo9WkqgaUwRLDbtJaGE1OzMQ+awfN1n8LJgqdSE3PZ7K5
X-Gm-Gg: AeBDiesqiBhNQgfeq+XtKw/15J357noLAdBvXrJA3AQ2Xbz6hxNd5XCFApDC6Sth6cl
	ILLvYQMt7dhoYXOrX0xVwLhNiraKxlfAOouwIkaTkFkU7bSsrhtR+UJ2HztUlyKiGREGssbb+gw
	W/0C4UoGEYo9pLNKv6ay1I4jFxq+TSyb/RFbIEzIs2R5dffynG0gN4AGJNjk+NdyZjg5r6xeSu1
	iWa/APZYdX+MGuZjWJF+3ssnowoiqmYGAuVHEK8hKnZgbFC7sW/P+TfWjtzGQ6tDFVNbPuE72F7
	kSEVKujW6x9Cm7FPcEQV+7523bDeyc/CrQAjHN7EfD37OrTtL483dCrtq0o27BJyWh7ch3Uf8xZ
	9MvPd3uD1f8KjNOpymClKRH6AQq4i5yjyR38ck9qWpr6VqCLptKWlkUFcFGFQ3SdDLJwIIjwf8I
	7Bh8f43wf3tEkKKgMqPbRXv755RXLSASWRJ+a3XPdjziOKx7NVJ9gpNVBdR3aTGJLJhHAAlPXjA
	18=
X-Received: by 2002:a05:600c:c10e:b0:488:8185:e672 with SMTP id 5b1f17b1804b1-488fb792e84mr425930625e9.30.1777154495710;
        Sat, 25 Apr 2026 15:01:35 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a4b329542sm704004115e9.3.2026.04.25.15.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2026 15:01:35 -0700 (PDT)
Date: Sat, 25 Apr 2026 23:01:34 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Min-Hsun Chang <chmh0624@gmail.com>, arnd@arndb.de, msalter@redhat.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: replace ________addr with
 __UNIQUE_ID(addr)
Message-ID: <20260425230134.5449498a@pumpkin>
In-Reply-To: <20260425135737.e79c4b546d22b5ebfd96c0b5@linux-foundation.org>
References: <20260307092119.20733-1-chmh0624@gmail.com>
	<20260322144032.7353997c@pumpkin>
	<20260425135737.e79c4b546d22b5ebfd96c0b5@linux-foundation.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 987822000B
X-Rspam-User: 
X-Stat-Signature: 8pr7rnpyo4xuk8zeog5opmsc94fbysus
X-HE-Tag: 1777154497-561381
X-HE-Meta: U2FsdGVkX1881cUAf4OmyRHzuQOivpx+DQ5Q3mSAgFCRYzEdiJ5x0pmKLyEiJqzIUyJlklV7EpGKOossqSWUUHe6N+Eoh/9D7V1O3LUEW2VhH30BHc/J/J4LxpsN+3n+dJechAnqAsc4XwH3tvYUQdOW1/Ozhbc7MtWVKt/4B4jObmbZxS6v8vzdZLVTeGZDSFvrEoZejKOSeMAFtNLVTRu21A48As4Aql/uutsrXLfoRvTY+ABS0dxc5FPkQoPdABrBAo8fulj8wJ5RY1XoPn3RFBBF7QFqhix2jRGuXuT/TIn5fXlFNEMpdVO0iDj1nop4ZjEXhpKe9k0uWKOU8lV/WhArLYW5feunzA/QQfGkZXXTTcq+JMITE8xd2bdCyIGmNNf96RaUHUCz8DScBTjhgMoH8LOOrISKfsf7zH+QmPMehD5+D3VzqqE9HKR2ROlUv5l4zISsxo9XSlmWVJHMkmbbOEkSXJ1yAZsHtCdRDR1Wu+yUZhSr89p6Z9fzm/Iwe0uAdz+B4BKPGV1bMcglDvo6AEt5HsagZy8gPV1qiJ7zut1JFevXxs28bNuMw42Bf1XTeYTTAsSqwMu8o8zGvbK21oAUTjz2hMM1O6iUSxrkTVCpvLeAbjKaoeVCxWy+DOsp8hFW8hsvTwC7CgGFxBkBtYaZaTelgPsNJVDxyYORKSnpsZrdpFDI/lNStB1tG6DUBoDJoKhpGlax3bUVkW9RgtmfrJXEUb6HnLPENQC85pRSBsaMKcdeSQt+75v0POuy1Lc1j/QVcJ4ndRGGxDPv2J6N3toIjp5kOiUIF8Q//715/8uLUzVRIkomC7RJbmaVFXjJKh9ckrq56fljTRRpX6Oc+ek8yTV92K6ifCcZl0Vuesv1Q4tw93cedFe+9ZvN+Dzs4MoV0uQWFYLxQFmbXCb71Ge2Ez1tQ2KiCGXpiAKG1Vi70dpc3ewCCwmFvXovz/aTzyoxnbh
 w2dcj//x
 6PiEzfuLr1gc6QQ2r7FeoZSP87Mraccw5zQE4CiSi0rWwo78Pl9tqNORGuz9AER8ZI5DxSvmwggYIUgQX2kiqCcE1QhHL4Y+8RVX33+157lYRXV6RVooA0Er32yUcZT43vVGTxylOMsbG8lrP8niLS4PnkAo8T88G9Prm9d27plZofr1asLWPtmtvhjLMllUgq0kQED860fa5pc+WNYbfOoxAvz55R/7IJ2rzrEhZpa/hw9b+UrBx0lRWKW+0QAbYQbyOWYfFYt2BTOA1EjItJjf2s6OnJFU35NSvbeKLD5ACzPf92NCbmVhESaUU+1+1amh+pdI6vYe+yEBBy+QBLpAG/XLstd0sRu/5P6sWYqeOGX4DbyH9YJfjrONg+owRqOqXEZGCNSmQHgYaz1w7RGPYdxIe7HDVkKoddpAUzq7MmnUE3tVJLjoFm25SBNYV1JxQ237SqaYMe+DyDRNnA0LYhsSU7zM+Kr85v1PJRRZlRKYrImRqnYhHbJGzG6fbwMdD0nYPZsu9vPIrnSI/2t8Cd5xEAyxNN8RjSb2TaCkd5VnBIBRWlCWoEKYYkzsmddZF4mEIbYc7e9571J7TTsnzkVjZQ27991ut
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Apr 2026 13:57:37 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 22 Mar 2026 14:40:32 +0000 David Laight <david.laight.linux@gmail.com> wrote:
> 
> > > -#define __set_fixmap_offset(idx, phys, flags)				\
> > > -({									\
> > > -	unsigned long ________addr;					\
> > > -	__set_fixmap(idx, phys, flags);					\
> > > -	________addr = fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1));	\
> > > -	________addr;							\
> > > +#define ___set_fixmap_offset(idx, phys, flags, uniq)            \
> > > +({                                                              \
> > > +	unsigned long uniq;                                         \
> > > +	__set_fixmap(idx, phys, flags);                             \
> > > +	uniq = fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1));       \
> > > +	uniq;                                                       \  
> > 
> > You don't need a variable to hold the result at all.
> > 
> > The real problem with this define is that both idx and phys are
> > expanded twice.  
> 
> The real problem with this define is that it's a define.  Why oh why do
> we keep doing this to ourselves?

Sometimes #defines generate better code because they are expanded earlier,
and sometimes you want type-agnostic 'functions'.
But neither is true here.

But I think I'd go for 'always_inline'.
Sometimes the compilers make silly decisions.

	David

> 
> 
> What's wrong with the below?
> 
> /* Return a pointer with offset calculated */
> static inline unsigned long
> __set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
> {
> 	__set_fixmap(idx, phys, flags);
> 	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
> }
> 
> static inline unsigned long
> set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys)
> {
> 	return __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL);
> }
> 
> /*
>  * Some hardware wants to get fixmapped without caching.
>  */
> static inline void
> set_fixmap_nocache(enum fixed_addresses idx, phys_addr_t phys)
> {
> 	__set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE);
> }
> 
> static inline void
> set_fixmap_offset_nocache(enum fixed_addresses idx, phys_addr_t phys)
> {
> 	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE);
> }
> 
> 
> I'll toss the below into mm.git, shall send it to Arnd if nothing blows
> up.
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: include/asm-generic/fixmap.h: reimplement nasty macros in C
> Date: Sat Apr 25 01:42:28 PM PDT 2026
> 
> Min-Hsun Chang reports[1] "the macro __set_fixmap_offset() uses a
> hardcoded identifier ________addr, which can lead to variable name
> shadowing if a caller happens to use the same name in its scope."
> 
> As is usual with macro messes, the answer is to reimplement everything in
> C.
> 
> Reported-by: Min-Hsun Chang <chmh0624@gmail.com>
> Closes: https://lore.kernel.org/20260307092119.20733-1-chmh0624@gmail.com [1]
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Mark Salter <msalter@redhat.com>
> Cc: David Laight <david.laight.linux@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/asm-generic/fixmap.h |   34 ++++++++++++++++++++-------------
>  1 file changed, 21 insertions(+), 13 deletions(-)
> 
> --- a/include/asm-generic/fixmap.h~a
> +++ a/include/asm-generic/fixmap.h
> @@ -71,25 +71,33 @@ static inline unsigned long virt_to_fix(
>  #endif
>  
>  /* Return a pointer with offset calculated */
> -#define __set_fixmap_offset(idx, phys, flags)				\
> -({									\
> -	unsigned long ________addr;					\
> -	__set_fixmap(idx, phys, flags);					\
> -	________addr = fix_to_virt(idx) + ((phys) & (PAGE_SIZE - 1));	\
> -	________addr;							\
> -})
> +static inline unsigned long
> +__set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
> +{
> +	__set_fixmap(idx, phys, flags);
> +	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
> +}
>  
> -#define set_fixmap_offset(idx, phys) \
> -	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL)
> +static inline unsigned long
> +set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys)
> +{
> +	return __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL);
> +}
>  
>  /*
>   * Some hardware wants to get fixmapped without caching.
>   */
> -#define set_fixmap_nocache(idx, phys) \
> -	__set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE)
> +static inline void
> +set_fixmap_nocache(enum fixed_addresses idx, phys_addr_t phys)
> +{
> +	__set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE);
> +}
>  
> -#define set_fixmap_offset_nocache(idx, phys) \
> -	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE)
> +static inline void
> +set_fixmap_offset_nocache(enum fixed_addresses idx, phys_addr_t phys)
> +{
> +	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE);
> +}
>  
>  /*
>   * Some fixmaps are for IO
> _
> 


