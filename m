Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 382FDC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590BE6B00A2; Mon,  7 Sep 2026 10:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A1E6B00A3; Mon,  7 Sep 2026 10:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D026B00A7; Mon,  7 Sep 2026 10:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23E8B6B00A2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:08:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B36221C0220
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:08:29 +0000 (UTC)
X-FDA: 85187146338.14.0548602
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 03EB1A0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:08:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ltQ9qrzi;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788790108;
	b=duHjLPYHHy2N4uaSmiFaKYdpUZm5+qGo1+6wmfk7wPlWs7b9diYZSS1uDJIRUFgmOVtqoL
	P21Mi32ANgLb1xKdZtOplJ/iZJRXt4klrv2rENcbnSm8CiNdxSRkvB4KixpjvgTNPzWI6/
	IG84vdsQ/CnsjdLiOwB6iN+HP7wTiX4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ltQ9qrzi;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788790108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dpm0sddIqNsVpgVb1UHMD/zioVt1o3wV+nhZjnsl+8o=;
	b=RuXb12zGWs5hidLKVVsAyHT/xAdb2FExEqtdVT8sF5O0TyZrq6lUcSEFkix2oeyIKbXey1
	e66i6Pa+0Gd8xBIFsk/bYp8jLtBW53rbdsRXTNgJLi+LDr8nw0eKztXjKMAlr/SURgHitm
	4CTOjB8KU6CV960znib0fSOujmEY2Sk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CBC6601F9;
	Mon,  7 Sep 2026 14:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BC91F00A3A;
	Mon,  7 Sep 2026 14:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788790107;
	bh=dpm0sddIqNsVpgVb1UHMD/zioVt1o3wV+nhZjnsl+8o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ltQ9qrzi+gdGxZBQF1twxJRWxkHKgXTdf3M6ufNooOD/+ALPLZHa848kCGghrQFao
	 hXTUbCbSRPYvj6l6BcbPvDNpJq4GhRzoqceT+YcqVPdRBOs4OaQF9CsH1IjhaEIQ8t
	 F8gXClL+xjdox8iFnVtyARQSQLCwQpL4qA3eG0GMxBiK/7VK7SfVI8eyNk5cVke3jf
	 oZGPg/8jXJbmlGMXLMUYUVVbtjNYt/mUHcIH3sSV/nvyv00t2Dn3rXp/fyDbML28If
	 r+LBED2UhSbA2ke2hfxiwCGviCdbmEz2jX+I4BpWgXGU2FQ4iUHo+UO9L+jjOOGMwX
	 Vez/pKueGp8Vg==
Message-ID: <0f48f042-8f04-4a04-ac2f-49e87bde5676@kernel.org>
Date: Mon, 7 Sep 2026 16:08:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: remove unused mark_page_reserved()
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260901-mm-remove-unused-helpers-v2-0-f6474e169c23@columbia.edu>
 <20260901-mm-remove-unused-helpers-v2-1-f6474e169c23@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260901-mm-remove-unused-helpers-v2-1-f6474e169c23@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: s8pspxdx6yztfdchgp75j6kj9jcdntmi
X-Rspamd-Queue-Id: 03EB1A0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788790107-176599
X-HE-Meta: U2FsdGVkX19rSdqrM3X21OVPdj106P0GMAlD1aSEiVoZQiaTVSb+XBSRDV2ByklkDT690d30962sFh9EApA4p8lz3Ph7gPWNs8c9K/QXNcOfu3bAc7lJ3jYvI+kFPkgMezy3gEPdArzarj0L6Tg2v//5mFD3plpI5LIEMWUCWPBbK7hHBcOh7C6Zb/dWqQP/uwzd+oFmv5jD2L589324yOgCeRp9BcxI0E9zRDZaShcprVkrwvXN/4dBCHHrEB8NYEdbm7fxpFYW41BZh5ZDScqIlI1xfHcjd4CscUpJBBRrV9YMMiDRxm/3axfmVsBJ4Zps1Ik95jfZ/aAQTHoNR8egQ9TkcOiCwRcxtvg1w82ulu9Vm6IL8opJKlQpVzNnKwVwQGaMru9x4yvHI6JJWEtAlCTrBa/qkRu2OAc4FW3P2eqgd4mCY1JLYxm+eOczZoqUFqUpfoQ7WIQj1BRDsfDhy11pk9KxzPOZTUf5hg1TNRgmauIkzOYkH3Wc/I5Ai5uBgcAAfutE5dZB02uaCWmMw0DSiROIOiGJj6KF/JXTHLnUlR3YSW1sKL93xZcZEIOzGLl0AvP3/zCoVnRtTlGQX4nTf1ibDoc7DfnAdMKBNubj5fWw7JTJAf1qlpXqp/Bfr0FB56rjykZ2YNrW4dtNjQB5Ss2LXYJ/BLVNpeKrDFMX7hFM7ik8WH0BkIQYSZ2TutftQ2B6ry0z+gjHcO+701nqCVOB2Czoez8sYLEwWEGJmzAQXXkiX6C+s/9Vw3fBDlvCqRI0hIvCGcINlOpnD4fsaX2ZDrF1UE0sVc9jvjzb2zv9/JpEFIqdVczJvaNvFVZKjaC51OHArDOvaz9jXEWONgGrgZCE0NMoDYBaYlQQJynO96XhsW+ncIb5fiAJ16SZpZvCuHdTaG7PR5ggXQmWhsWBYy/ezp8Szbp3TNc5iggr33oElhK1U/uPHL1L6B0/7s0X2zO3igC
 QntJEAWM
 HGqnuM4yGBb7SGMy1Id09kKyMUPL6VYe/a6WdHXJTcHiLr0+sgC3YuZgeaHSJr2CL+FoXpZdp0f70scr7j7u2jF8mOTBJdQG4cgAJjGim4BpSf5eI/4TfM7r1P6g1zuu/7+Ac7y4ZeJYVqndlOKDXrKs1zyIMZfBf12TG/NLohfKMw2/fMpWyPJBeWI5IneuXV1SofwfNEcRFoyS2xgFkjzok+pymgaDxlKL3/DFePL8mi6HzwdbzfamHSASmqza8CNOASIqVGkI2mtm2l6AqTo7ps80ujUXHlt6hi0qWD2bboNiUX8dc5V8OQVhZtUZKUvovnaF+h1xD7mQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/26 21:38, Tal Zussman wrote:
> mark_page_reserved() lost its last caller in commit 6215d9f4470f ("arch,
> mm: consolidate empty_zero_page"). Remove it.
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  include/linux/mm.h | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1b28e6fc8d5d..e3736c42c4db 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4080,12 +4080,6 @@ static inline void free_reserved_page(struct page *page)
>  	free_reserved_pages(page, 0);
>  }
>  
> -static inline void mark_page_reserved(struct page *page)
> -{
> -	SetPageReserved(page);
> -	adjust_managed_page_count(page, -1);
> -}
> -

Good! The less PageReserved magic, the better.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

