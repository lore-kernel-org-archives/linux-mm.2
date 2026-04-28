Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C30E4FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 19:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97A76B0005; Tue, 28 Apr 2026 15:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D48056B008A; Tue, 28 Apr 2026 15:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37D66B008C; Tue, 28 Apr 2026 15:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE8646B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:51:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 578AF12024F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:51:19 +0000 (UTC)
X-FDA: 84709008678.22.5D4335B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 99D5F160002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:51:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nm3/Up7F";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777405877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N5ioFK0mHY9Ys4LHm2ud15cUW/kDvfazRIYlH++roFY=;
	b=rn0MR8nWr8dimIWQB4YV++yZwUQBXeZ8VAWTN4SSvLNtAZg7+LdHlbs+hPX6t1e2ce10kg
	fu4LweJ5R6OXCk3Wt1Wm0Nq9dD895Z1kxDkb7TZopVYdluJz4LB+AUXsCVJ8Mo5WnJEYgo
	kHWTvovtuZA9E3x2p+8RZqqHGKsC/Xw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777405877; a=rsa-sha256;
	cv=none;
	b=XSN/qqquWhGGryTdBP4K1CrR52B0WEkbRXmEXuYwzYLv6V7eueOkbOBiuc8amjvlAzdeWe
	PEbRTT1I7g4ce5+4awnVnTnYeatvO/59akz1NUXZMZvjIy9Wk9iO+N2ZAzQnMKtQXStlN2
	lvw6MIGl7P1BE1MPRmc6euXxnXMh3I4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nm3/Up7F";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EC5E161145;
	Tue, 28 Apr 2026 19:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA90C2BCAF;
	Tue, 28 Apr 2026 19:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777405876;
	bh=Nhfmyw9bPmtRKlxPV1In2mC53XW8ms1qpcByR8ySSaY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nm3/Up7Fte+HsSj4Zi+YOwznbJD7iPvMtnYo665KKkx6dWJcE7Gzd0pPiMSQo+jK4
	 jne31Wtcxx5AG8x5gUZVH9V8RjxMZw7APbTvdkucjJW3hbn/Kxv2fYWn4d4iNwidcq
	 oxgP3xyTt8eJTpuPlhI6M7N8t55F9QFPaHEBiZMxlU5purCnr6aeQmlod1arAb7qyT
	 TejgemR812N9nuTYeJuBNAVDkdX15SepZsM2cm3UB+os/1GK6MzazI8reQvK4XdYJx
	 2vglztBGG3fVOstGGeKmJzZujOc0herLstlCzqy++2TxoMjnhbtu7LcpirMLnVykhl
	 0WusTNZOxXBdA==
Message-ID: <3d1a6b5c-f3bf-462f-879a-cdb5b60868ac@kernel.org>
Date: Tue, 28 Apr 2026 21:51:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/15] mm: Make empty_zero_page __ro_after_init
To: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-19-ardb+git@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260427153416.2103979-19-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 99D5F160002
X-Stat-Signature: dmuqhpcgip7aogkj6b6ub5ggu6nne8sh
X-Rspam-User: 
X-HE-Tag: 1777405877-507372
X-HE-Meta: U2FsdGVkX18wEGrWewboU2pPs8bjHV1czxOAtddbZbe/Yxygp+3Rw7v55hXw4vIbPt3KTBrei0KGxYKf7FGY3iShebjiRMCXlfrL9Ir+Y21YBBtPXeNAO20BQwVfROEhfV9hgUK0O1H0AebpsVJ2jXhW7NzFfLWTCJ/ZJ0GboDrno/s6Wp3xebvalhm9i+6bmGeZnlL0e0IOIA6dDEKI3qP2V9VyesX/ZrIrmFteUM6gud+iUu6yf0EtiCftLL1O4oQE5XpQtDe4RjMyEWxV43RcBP5myvDRhuKGoxlefcgFLD6Ml5M4dgvbT2Q90iVPmkMU9ibIWqZQL0PzQHl2OY+rp4ycOj38BITYR26DaJXb3uIxx78OdaE4e7SPhgfQJdyVSy75W2SDxVKN7wtsReP7XK5lgSE5JhwMkhuxEutAUhvq/JWsQW/oo5BelUdjdr1Nhjv4BP/dysPOdOr05feXj3W3pFHZd4O+C6qi/dVcQGkY+vfnkDWmphRfIUEsxMbPrL4W5BVAVLQABEAm8MnoEkGI1fgCY1zBOHvmlzRRoilIG5tqpFPvUsKw1HTlJjg5F9f84i4ZWk0VfJ6kUkFdXu18gM0T+H6/XwhatWg0MXHAqbedD7r7OFINoCdJGGkR8TEERAPtwH7dv08XDZV4/USoI1BBvTrKCDwuN6W4JD1xXjAALvZruVES+HZazs1yH/YGMA1R84GOVWoUF+uaK0E+AP7VblQhKSMpZgTXT1+Y6CpRKFzGvwKk1dHCGUJeU7v1O+ub3c17h058I81TtEDEUbIusHWcKfo19zBJ+6ZfDcaZxDHo/G+vT8v1AUQMMUeJEZRFq+Kt8h2JrfT2Bh5QCHVEvOgbOKXN3H/m3S46V6/RgrKol0KP0a829frFpJWf9Sig5Dn6ji5gC4KRd630ThcZqQnD+NvCt1xeJzr8rzQKhejwI5CjmFizrFQpASuoAq0DbZNGUCD
 ovZUCU99
 3H+rm4nFo508onCptE6xIkEDPgzXPHiUfa7iB1l3NZYK+0OMHEbzrr9vo8tkx////js5f/GlpmbqHkwn7jz4tB67I72uIBS7DdIfpwlJRdPvvZZhj91HYidOJtcqx90kA0bMEDW2YrliZZIx9b6Q5Vxk0hcv0/VMDJNJpFG4IkaiqliYAIOgscGRCNKuITEdFKJKleHI0Y1soRegY3NSZpO9FG7uY3cdwkvxmlcjRrTnoZwpxxYttU6HNlMK0O0oaeoP/6j9j8DxnvMqaZegCDYT30s1BNNaMUNZXf4iMvFrT7Q/qQJxDdGCg/E1GvgxD4mVUSyIEVpRxClY0QmvSUda/ozyfJlrZ91jOSV7rB/rF/MFwoE2/4f8UvylzT1V+8xK7wH5sVwnXbIaBKYbsVwyZRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 17:34, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The empty zero page is used to back any kernel or user space mapping
> that is supposed to remain cleared, and so the page itself is never
> supposed to be modified.
> 
> So make it __ro_after_init rather than __page_aligned_bss: on most
> architectures, this ensures that both the kernel's mapping of it and any
> aliases that are accessible via the kernel direct (linear) map are
> mapped read-only, and cannot be used (inadvertently or maliciously) to
> corrupt the contents of the zero page.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  mm/mm_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index f9f8e1af921c..6ca01ed2a5a4 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -57,7 +57,7 @@ unsigned long zero_page_pfn __ro_after_init;
>  EXPORT_SYMBOL(zero_page_pfn);
>  
>  #ifndef __HAVE_COLOR_ZERO_PAGE
> -uint8_t empty_zero_page[PAGE_SIZE] __page_aligned_bss;
> +uint8_t empty_zero_page[PAGE_SIZE] __ro_after_init __aligned(PAGE_SIZE);
>  EXPORT_SYMBOL(empty_zero_page);
>  
>  struct page *__zero_page __ro_after_init;

I am no expert on BSS etc, but from what I understand, we'll still get zeroed
page-aligned memory. I don't know if there is any other impact on not having it
in bss.page_aligned. I assume no

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

