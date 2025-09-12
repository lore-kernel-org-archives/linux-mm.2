Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E8DBCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 07:57:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC208E000C; Fri, 12 Sep 2025 03:57:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56AB8E0001; Fri, 12 Sep 2025 03:57:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B454C8E000C; Fri, 12 Sep 2025 03:57:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A21738E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:57:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2DA341406DC
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:57:36 +0000 (UTC)
X-FDA: 83879843712.24.AD3BEE7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id C17101C0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:57:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YZsnxfOD;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757663853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+PqVYBDLbo+GI2XNIjczAPm5r0PaP1XGtlnWHDNHZk=;
	b=txqyb0BfQMC/HUGbDq2zIW/qieiJB3sBxne41KRpuT7ubeLIHlBre+3b3qSc/dOPEGnLkn
	Hkg+LSg0R3GaKTQHKcKLvkR7J7JtFiDDECIZUfBxR/hZXSyaLZ+xJFUFdw5N5jxxbfhkGl
	5y1hMamw2m2YU5ngQusGCGvx7SUgnPs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757663853; a=rsa-sha256;
	cv=none;
	b=SWkvzC5KX8Ts+HDNYflTt9WNz5yB1Iz3WKcF54HTpH7QbQML+QuHU+P8MtnWw8WcSyTfpK
	oC83t/0F51cVVKELVt+tzhq7O3edftQg6++yv50gDvJlFvX8ZgZEUkblFe/6m9mfYmfSQa
	ACUES4yKMiypB3SpO/tCgeyYK4xGLZ4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YZsnxfOD;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757663853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=r+PqVYBDLbo+GI2XNIjczAPm5r0PaP1XGtlnWHDNHZk=;
	b=YZsnxfODrcqQHFT3QrKNrDeJcfGHC85vx3t1KKXbuJTSugN3KrKdgD4fHMiPDYpRJZJIRI
	Uzz87777EmeASGTap9L9mo42CrC7lKoozp4S5OgQusQRUdFY9BAz2k0mvSE8ejdGovbvuy
	moP614TGWpOjlaE/6qJTOEj7oPX+3/E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-mUc5isblNLC_l-IQrcpSTw-1; Fri, 12 Sep 2025 03:57:31 -0400
X-MC-Unique: mUc5isblNLC_l-IQrcpSTw-1
X-Mimecast-MFC-AGG-ID: mUc5isblNLC_l-IQrcpSTw_1757663851
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e7634eb959so747685f8f.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:57:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757663850; x=1758268650;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r+PqVYBDLbo+GI2XNIjczAPm5r0PaP1XGtlnWHDNHZk=;
        b=SG9fb9QmOuiePgqlg5EWb3A2RPVdLV7Q5tqJvqBF2cqiKQ8Am2ndfpJBpp5VWv2bg+
         qtniyVqtcxOu4RLOhMU+JCau5XxOApHi3PLdvOfaYk+ZrH4xZvFbORpiczgbB8P9Z8yp
         Ggjexmjqe9377WsgdEjkQTX0TUzZyAu2592Ie4eMx1Z3mUf0Qei6F43eXKAvQc5v/FBL
         Dj+YOhMBUCTeWXYvq3p63UaiPOKUcZaVYe6PUh/FWC8jFxf9w+VIV75UjA/iIM9ObxNk
         UWY5mo3eCW9koIyD1E+n3hXp03BG01TB4gq1fKCAn3t+VHbgE3F91NQkh933nDCoIzCz
         Sfcw==
X-Forwarded-Encrypted: i=1; AJvYcCUzFrR0YrjWPU+LLB3Xo7ucV9rM45sP/MzaQUWPbvXzjJgawRBXnIF98lCWlDOMJV3NBbo5NkQDIg==@kvack.org
X-Gm-Message-State: AOJu0YxrXNUnVAO2xPTqnSXMxTHM+4PoylsdW5WUlfQRH4pmVIaKv0MP
	pce5Os3FV8Aj9buB7bKWPGI5FrBIFhJVW4qCy3t2WUHQoHJMi1Mg68kBl/9aL2wq418EbQCiQ0v
	AahYl6/oW7b9k/ibTqVKVZMrE9I9GWk0Lb5eD48W+jJxWBPl/duBx
X-Gm-Gg: ASbGnctT8ixiGEI6pwXbfuG0wUI0+Qw/8tMqsgw8Y8e7sIYnhjFpbiABgrs1j/18QDA
	1kfYWabQEtYs3kgPt6gW3BPewemfaz8CUSl+1fHc+R27FFzwNR5WiV/HkTBaZdSiV6m0BaHSywI
	kAGXL26COiFkAk4fGzyQBHEuo+PxrKR7tOdZuUTC3YsHO6xLtxac+D/0sa7cEqhJSlqKR1JyDy4
	jEEcJkU18p/KnRo2P9J1MUyy97eRfO1dRS7NQkf6gIy5F2qY+SmbCV85Vf5ikS5EfarnqAL1N/2
	U5JIJ8E/Ln3o1c98R3N+FxKEEPxRAwIHqjC1PIOJjInx+HELAA6yPUGE/UzJ/45xHJKU+W+RLvY
	QlH2Cg1gT4GlK1EIHVI6zJmtmCYpGgdl+2GU0FCoqqfozVJhR310f7YiZZ7Gdn28kWZQ=
X-Received: by 2002:a05:6000:1acb:b0:3e5:d2f1:403d with SMTP id ffacd0b85a97d-3e7659e981fmr1992700f8f.36.1757663850562;
        Fri, 12 Sep 2025 00:57:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5jTihNZ8u71EpurEXi9WIL859gU0373T54vnlvHENg3fNIgXreHhMHhAU/LbYZT2vWSOlPw==
X-Received: by 2002:a05:6000:1acb:b0:3e5:d2f1:403d with SMTP id ffacd0b85a97d-3e7659e981fmr1992669f8f.36.1757663850093;
        Fri, 12 Sep 2025 00:57:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607e1400sm5516947f8f.55.2025.09.12.00.57.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 00:57:29 -0700 (PDT)
Message-ID: <e326949b-5d8f-4a35-8116-015e784df421@redhat.com>
Date: Fri, 12 Sep 2025 09:57:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: boot failure because of inaccurate page_pool_page_is_pp() on
 32-bit kernels
To: Helge Deller <deller@kernel.org>, =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?=
 =?UTF-8?Q?sen?= <toke@redhat.com>,
 Linux Kernel Development <linux-kernel@vger.kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 linux-parisc <linux-parisc@vger.kernel.org>
Cc: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
 Helge Deller <deller@gmx.de>, Byungchul Park <byungchul@sk.com>
References: <5a004aef-9df1-4126-b167-1aae27d4240d@gmx.de>
 <1756327287@msgid.manchmal.in-ulm.de> <aMNJMFa5fDalFmtn@p100>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aMNJMFa5fDalFmtn@p100>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4HFgtLcroxaFGa59xlxvJ27tBCM0mKlx34Wll6ZxTHk_1757663851
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C17101C0006
X-Stat-Signature: koouoyudhss9677yt69kjsc7fi5otufh
X-Rspam-User: 
X-HE-Tag: 1757663853-914584
X-HE-Meta: U2FsdGVkX1850mvc+220SqrxnsmRlGzbliZeeS7V/LtjZczx4E13/99u0xkw01Lk/leU1xYu/Ifyn7t+LHD5KLF5l6EFw2jkIZ9OlaTa3hRaT/0Ksh1+seMJA78MBdZFWfRC7HwUeB8zWk7fBrYyE86UDy4Vc/7Ojcvl4NV4jxc1YjTMMJ3v2M0XkwgRObpAyzf7umZyAoz3i31onj9fMTIKseM3pG6c0PZRmVt8HErP5c9Py+9FV0T5c8uPdzHJQsYJd/m3r1ilWQMb+J9wP2lTS8TBDdiWUTcvIEuapkMfUONhfWSj5gH6XNNgHGiRASahe67S8xvMg+3mn/MzhfateIpMJXJxhWnd85whroh2kLJCFVxd9gGMMQGWnSsa8IYZyvnwEKuHu1rEwFMN9s2WnV6lJVQ3PG1VezkpdApFtKrPy5MP45aAqT95Vl418js3SJOhLMG7D6AXdZ4DqC9HxDSJOC3X2fTDjnik7yDGa5xL68F/aejWYbQU0OMmuiSiq3v0o14pShwk2DsWWbOMfpEqI073IClbi07s/+Ab0k3d8Ac5FFKzvpvR+UX+0pMtKE38N7gUnhttj4jz2OP0QUYD7/E++Ajup80fSNeGOkS/AqRJc/9/IGm4xrGJ0LZIgMbJG2YRZP6K9Gkx3Qsp53fgR0fHyABpEOidbbDkj5DC2lnPwg/FP4JmutXnIWS5JpIKOdRwtRbKodFkfzJGnnMN0EnISXZSv/+6DADb+S5QQy9KM/3lia1uDKvMCmloTJQEx4Yb1ESdLWkWQxMfhapi3QYgMgTvWbB8bG1Z74RJDG2fTadp4VMNlKUucCQHyQRd8NnxGsFh8Atuo6Girzk9H25nlgvaa7T9VRm70Gz1PiO7v6DGBd14ReC1BX9CwuA2o0/QQU14RAGDIk2IgkJb/+jCKfvMC9A6aKbWDUx1hqitXjXA0n2PWhLAzsyJjLS6afLVcMddNlj
 7UxbGZZO
 8QaXc241xooy+veAugOcjWJysf5Vv/OpYWdnZjOhMuwAxc8jKij78K52sWznJfDIgvcOxTOeZ6xG6GgzSwhINBnhgPV3GJuKJCAKueYkYv1oRw8xjhCX94poi21irpTQ0HbtceoOxK6aanPFNj/eZAJ+AD+EFFT/v6NBrVr4vB81iNDEmfG9TOYzHjDAiNL6L8KRtJj7ke0XK1UGOHY0t6Gz21x5ajHgaFmGawLB/8EN7UexpCu/2/2YnaBdd4feLo2FgsE/N0TPrm7gh0+LdWja5O2RTREK54ALy/OKgOGcWz0orUAEV9WhNdigJLtqSk1vy99vItf8IE54dHaFMQdF4q27dMiPYq+2rdRn1y/qLEHJ3Xi/BxJKYlRwcKojUYzkxBRJsA+Bylj2DAGSZSwhh0QySa+nZx6HI9Wnk4/RlNGEB0PrcVdOUgl55WeMq70BdqnpROAt7X/aXBpKrIAu8SBXtvq/PVdMhlSGcz5w/UK1bfgvcBHZtRWdgF+9w/0CI1WW+uUj6b9ey+tjbuMGLfv9gBSdvfAV/OuDTx04zPkpJWBfh9+m89YMpQ8gk0u5D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 00:12, Helge Deller wrote:
> As reported earlier in this mail thread, all 32-bit Linux kernels since v6.16
> fail to boot on the parisc architecture like this:
> 
>   BUG: Bad page state in process swapper  pfn:000f7
>   page: refcount:0 mapcount:0 mapping:00000000 index:0x0 pfn:0xf7
>   flags: 0x0(zone=0)
>   raw: 00000000 118022c0 118022c0 00000000 00000000 00000000 ffffffff 00000000
>   raw: 00000000
>   page dumped because: page_pool leak
>   Modules linked in:
>   CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.15.0-rc1-32bit+ #2730 NONE
>   Hardware name: 9000/778/B160L
>   Backtrace:
>    [<106ece88>] bad_page+0x14c/0x17c
>    [<10406c50>] free_page_is_bad.part.0+0xd4/0xec
>    [<106ed180>] free_page_is_bad+0x80/0x88
>    [<106ef05c>] __free_pages_ok+0x374/0x508
>    [<1011d34c>] __free_pages_core+0x1f0/0x218
>    [<1011a2f0>] memblock_free_pages+0x68/0x94
>    [<10120324>] memblock_free_all+0x26c/0x310
>    [<1011a4d8>] mm_core_init+0x18c/0x208
>    [<10100e88>] start_kernel+0x4ec/0x7a0
>    [<101054d0>] start_parisc+0xb4/0xc4
> 
> git bisecting leads to this patch which triggers the crash:
> 
>   commit ee62ce7a1d909ccba0399680a03c2dee83bcae95
>   Author: Toke Høiland-Jørgensen <toke@redhat.com>
>   Date:   Wed Apr 9 12:41:37 2025 +0200
>      page_pool: Track DMA-mapped pages and unmap them when destroying the pool
> 
> It turns out that the patch itself isn't wrong.
> 
> But it's the culprit which leads to the kernel bug since it modifies
> PP_MAGIC_MASK for 32-bit kernels from:
> 
> -#define PP_MAGIC_MASK ~0x3UL
> +#define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
> 
> Function page_pool_page_is_pp() needs to unambiguously identify page pool
> pages (using PP_MAGIC_MASK), but since the patch now reduced the valid bits to
> check in PP_MAGIC_MASK from 0xFFFFFFFC to 0xc000007c, the remaining bits are
> not sufficient to unambiguously identify such pages any longer.
> 
> Because of that, page_pool_page_is_pp() sometimes wrongly reports pages as
> page pool pages and as such triggers the kernel BUG as it believes it found a
> page pool leak.
> 
> IMHO this is a generic 32-bit kernel issue, not just affecting parisc.
> 
> Do you see any options other than:
> a) revert the patch (ee62ce7a1d90), or:
> b) return false in page_pool_page_is_pp() when !defined(CONFIG_64BIT),
>     which means to effectively disable the page pool page test on 32bit
>     machines

We should have a change coming soon that would use a page type and fix 
it as well I think.

https://lkml.kernel.org/r/20250728052742.81294-1-byungchul@sk.com

Until then, the easiest fix would be indeed to go with b).

But maybe the page type thing could be backported?

-- 
Cheers

David / dhildenb


