Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 161E4C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0F1E6B00CE; Mon,  6 Jul 2026 07:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E98876B00D2; Mon,  6 Jul 2026 07:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64856B00D4; Mon,  6 Jul 2026 07:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB7526B00CE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:52:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C18BC1D63
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:52:44 +0000 (UTC)
X-FDA: 84958189848.15.3328D5C
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf29.hostedemail.com (Postfix) with ESMTP id DA49512000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:52:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=YgiY7HQh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783338762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eb4EE4GhIYXgk8IjcNOVvoBYVaWKohpIJ2vUwL57vFo=;
	b=qw02lh+ZEFXUqpYeD6IbEdmB7A7eoUzwDH6YyeRMV2b/2wUkmYoH4yPieH4rSMZKjeGoNP
	ba8vTwkjLK/KtR6SB4EICq5nybCdQ0GwMSai7iLLTiu6EpI5OpBVKkIC6rqyg+dRuKXALm
	rxvR+1cZqbfj7jYqudJL3T9wmGJLc4k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=YgiY7HQh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783338762;
	b=pou+/2NU/e/ehKQLHXlWxCmXU12U4E8IVeb6WB56toXrL2x/7dTUhnV7+zoW6Jn4VFx1Ip
	anbrzGUgSvj/3qtMevLcGOnMBKFTwd7eeaCjRNLABeXbv9OF3Iu20sl0iUXn2dpFopV0KH
	HgTpAYCsJEb/HwVWPzpH0IDWY5nj8qg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783338756; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Eb4EE4GhIYXgk8IjcNOVvoBYVaWKohpIJ2vUwL57vFo=;
 b=YgiY7HQhlS2dA1kXAEeGIlvzVmf8gYfodAtIORcvHREvjp9tLVT3e9Npt+BzgiCufjFgWU
 8tHCH907rtgXLJu7W+k10ZBelYU+Eq/Qsfq0QsESsRuUXoZ6kCY/BW7bx6WyzQYrpCjzdl
 3C1IraBfcvsPSSURnpfAcBhJ4zfZu0UQ9SSz9xOTdo/gLGuVMwhpzeUJWQKLPI/8UkkfEo
 xFnLhCk0rtCrWxZNqAuu5AySZqKQ5u5ZUfwP20qhU1OEDW8G7/YU8oY2bq/EJFNJ26BwY/
 KKEkMBX9wKyxv5uN/9qFiT2LGPyYCPzg5Q7HnPn3QP3ZZzV5WYn3X30zqFHFbw==
From: "Li Zhe" <lizhe.67@bytedance.com>
To: <david@kernel.org>
Message-Id: <20260706115213.50375-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
References: <8a6f0bc0-5b6d-406d-9d2c-d3861b5c31b5@kernel.org>
X-Lms-Return-Path: <lba+26a4b9702+e4120c+kvack.org+lizhe.67@bytedance.com>
Mime-Version: 1.0
Date: Mon,  6 Jul 2026 19:52:13 +0800
X-Mailer: git-send-email 2.45.2
In-Reply-To: <8a6f0bc0-5b6d-406d-9d2c-d3861b5c31b5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH v5 3/8] mm: add a set_page_section_from_pfn() helper
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DA49512000A
X-Stat-Signature: cbwkb4jaogei9g66bd34gei9osgupnqi
X-Rspam-User: 
X-HE-Tag: 1783338761-909759
X-HE-Meta: U2FsdGVkX19eGwPFSSsdghTG0BBhiWC3ycZew7kytC3hcAreFRBLU41ZjSRrnxhAk3AX+wuzcyrnDAkDkAGc5bW6jZIe1lfSAx+0neq/0Yc7Z+oyIsRYRqTiJD2i3v8ne4NenY0USCwGSSr/JzUbPJ51mDUzwOSuWtRdycguO7VlrdalcP7LMjMMn2drde8ujwr5f5lPwLLVpYO2n/Zv9/mOtqyYBlGanj2acjPUQOvcgUTe1pVZow8Cs+OcAEI90nDULOVJPmy6Qp+3pgCA/6eP/Qjwrz6PrV0VaIpGaFuIDeiOh1zCogZlZ1PHUW1DegWHZjX1leiHE3HauukwHhyKvK8srslwEldEA65jgAWj7x0/hlF1kAIH8fzlXff02Lp74MxS9mw41en1N8jsuAVnjSZ0eCY9UKLn6UK0Qmtgdhjn6s+r9pdSSds+XuGb31YyF0Q9obZKGCqGXmrbIkPWrpLhvX5ixjp2HEL55p9j857mg/CViouy/DuO0wDD/ts0pKtKjp0RHdJBRzN76ommDs3LNg43Z/mYvTvnAADGWapt9hvQzfN75Zkz8QFG7IHVprCW0VvJalyvn97G2vfU1YgjLHeNUXuN6m85ObRiJbtjTg1hwmiTzpzcPlApkLj3pjqZ82dM+AIoBIxLblnmhqgo3jw/pbv2nUTOVrUwX+1OjJzChSH88ZgdKHhNf0I2HES3Rk5abZ45600vLa3o18FOycVLqmeDF/Wsh23VLyQOU4Ki5TFs8AfaYE3n5bB2qoXKZRecGYtaJnDK0QPhbYF6eog7/vpifPSgisDeeTFacjMwfWk0a+zjewiV8YMLsQ8n5s02Yatw/YPAMYR0fDF9Si1o2xXNQClKUC4cHwKqx0Gr9dzgVzrVvozwhVpU+jc1JVkdi+wg2vCcyezZVO2gCGU3egY3yWr287rEkX1jNSfyWyyDlyT4SiXZ4Wn+E45msqwK9TGRA4O
 liRk43BG
 h+5YjUAfmksiiZpqUIQZykCmLgNqaEz6mPhH5v47qa/XNaPv6qkPK9qa/E91x++RqlGwlPhuHVyp+QKOKargbL4Q+ebkGVm0d4Rb0i9+QJes03jzYFs8EM1CzNV/b+NGJXxYa5dko+s+xzNU2qUERpa5+dct0H9D4w6feid6rEGOchwKDypTzHWzhCGlmdX3To3zlwXHwhzkOVWx+k2v2fY4MA+CmGKsifBIfgxxO39pOSKerVZMOrjy5Lw6NtAnKJAhLzti7FlHnjCJpgKDX9/7fDYR1j/0Ly+A+KxeXNK1X2zXc97SAfmYe/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 11:15:36AM +0200, david@kernel.org wrote:

> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 485df9c2dbdd..f78afa63dd3d 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -2541,11 +2541,26 @@ static inline void set_page_section(struct page *page, unsigned long section)
> >  	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
> >  }
> >  
> > +static inline void set_page_section_from_pfn(struct page *page,
> > +					     unsigned long pfn)
> 
> Two tab indent.

Thanks, I will fix the indentation in v6.

> > +{
> > +	set_page_section(page, pfn_to_section_nr(pfn));
> > +}
> > +
> >  static inline unsigned long memdesc_section(memdesc_flags_t mdf)
> >  {
> >  	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
> >  }
> >  #else /* !SECTION_IN_PAGE_FLAGS */
> > +static inline void set_page_section(struct page *page, unsigned long section)
> > +{
> > +}
> 
> Why do we need this?

The empty set_page_section() helper is not needed. I will drop it in
v6.

> > +
> > +static inline void set_page_section_from_pfn(struct page *page,
> > +					     unsigned long pfn)
> > +{
> > +}
> 
> Dito.

The no-op set_page_section_from_pfn() helper is still needed for
!SECTION_IN_PAGE_FLAGS so callers can use a single helper without
open-coding #ifdef SECTION_IN_PAGE_FLAGS at each callsite.

Thanks,
Zhe

