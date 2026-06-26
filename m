Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E4BCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8886B009F; Fri, 26 Jun 2026 05:29:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0F26B00D2; Fri, 26 Jun 2026 05:29:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5E06B00D4; Fri, 26 Jun 2026 05:29:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 819EC6B009F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:29:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC1361C6235
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:29:56 +0000 (UTC)
X-FDA: 84921541992.06.8DC2191
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1C7431A0009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:29:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W5WgwKaP;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782466195;
	b=LSfJSeu68r9mQnacAysLzLsg/70QIVEz3YbxALkzwskBBtg8rjF080NxpoD2UUBUOiKE5S
	wJaN5U3lw/q8MJ+lZL36EQI0W4d1kb3+mHfb09266PlYrJJeWlhJklkBS/Mhm4FyKelf1e
	kd+/Di7qmXSAvLE7GMXJ/Y/dTczM2Dk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782466195;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hM0SZhtB+D4y9Lg/i/wVWzrebqIOJYN4ewUhvqayhFA=;
	b=wcs4NfFzeZ12ldbyMUM5ioADHAxRfZ7En38eh8+sfe2QKFQzOS3UY/B+B6aR+yBhBRObC5
	qmHQ8y5YUPWqVabmAJPGXoyijGtJbzu9KmKud3aCOrCcmEflDG/MjRZE3F0JGgaIcvs5Mh
	h9vNpOmQl7/zgD3A+oBvf6/QoHeQZac=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W5WgwKaP;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9158fbaa4bbso96510685a.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782466194; x=1783070994; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hM0SZhtB+D4y9Lg/i/wVWzrebqIOJYN4ewUhvqayhFA=;
        b=W5WgwKaPKSB+gh+7EN9XkfpIfm2mtgl8zI6O8fEHfwhLhf0Xwa8nRAIb3DDWrTbTrZ
         IHDiyWhIxwpcfaNY3GwoMwaFUTS+CzOdvMi++/Tcu4ZiD20a4rCnZ4+Wbozhg8oHw6wt
         czn05SFhFbK9AAsFdO/y/DkiG3MGVgieXCUU33dd3rbmaiFebJ1MrXiftul9YP5Wr4qL
         tWCEceJC73Lqy4ELHE2xnRlhUwFXk5Uz1kbrhbRbWTdyUO9UK6VIeTyErflbJVj4B4xz
         yeCDmKIpIxgoMIwGH86jief7e+gHB15zOSCFwFrNYfJdtZWCtxzXPuOkqWxZtbPtYLfw
         7HaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782466194; x=1783070994;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hM0SZhtB+D4y9Lg/i/wVWzrebqIOJYN4ewUhvqayhFA=;
        b=k63wm8PgygdLUnP54c4n5XXf8sDEYTf1FkR5Vew/4uR2D0LXmISCVaQFfSy9J2fCei
         cx4Wjn/QjVKdHdrLhP8CJrLG5TX1vwwltAObMipdsBCqsdCLoHlnCpDrBxykYKGmoYzv
         iKIrZv4Jh70ONQPOB2yQBHZZaHUM54ezSi2RVMU6/ueFUrimw+EiWbLBExWnXrkxLPdY
         szG3sRHbftp8uGHu2M1H+Qko9wElZkilZNCFI0d4E4i2OUL1mS8wKve+Sxrq6AaFAC6O
         jYYfUyQs2Q4HytXsq1bwQWFgKL73dixPQvmq1XxoAVSlYgZ9MFHgPr5Gg0hNciPRrsW0
         PCrQ==
X-Forwarded-Encrypted: i=1; AFNElJ+40ALM9DSkLbIKrXqen87WX8ttrxJ8nGDkrv2uq2d5uQ9DdN7KObVfbLdwsGcSOgC31i5V3mG/2A==@kvack.org
X-Gm-Message-State: AOJu0YwQah7rdIIVKidMf4Gx1IoHASDTmx0m9hIUL5fPe4uWN+OqL5Ga
	nakkKyRYxtrte9u7Yujs/YVqVtIYrpAjp4bG/QDVQzhy9fuA4sTWJ3EgwYNrsA==
X-Gm-Gg: AfdE7clRJtaONrUumiX4OZiqmsVzUcgFFKJi1SsEHLkuNBEPRZI4m4AUu2FkttY6xV6
	KqFsKMtVd4pdC+pU2LsHdVqCP6EkH6siuu7xrUqtvx1g3Ubi7pl8lXIMzcpMhe+zRSkWT8GPWxO
	WLAYRA0LJ05lfVlKz5VL8xUzmTVLLAP6h4rrDCdM+mycBHfjR8i27sIiq19TjGBRBNv197AQK7p
	+guWr9kHE9I94kY9bHfpLQ275FA2fHebpuGNwGW/8YiupUTS08ahSWUO/rabF8CXT/kO8hpCWkw
	Etme0dJ/xXy4dnrH/Mrdm+hJkAmDmfAYcadpqtz0yXKCkxc+dbVXd0EeOduiVChQhJosGOZsqYk
	YYSiaV5FMkjO7eUTEZP7soydYmsrq6Z4xauzdWi6pLj6ve3wNdJTZ0bBqqWzVxXbI51saVHDSEb
	zTtSbkL+nxrK0=
X-Received: by 2002:a05:620a:460c:b0:915:a762:2735 with SMTP id af79cd13be357-9293d4b30b3mr925124485a.37.1782466194150;
        Fri, 26 Jun 2026 02:29:54 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df8303ebe1sm206881796d6.49.2026.06.26.02.29.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Jun 2026 02:29:53 -0700 (PDT)
Date: Fri, 26 Jun 2026 09:29:52 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Taku Izumi <izumi.taku@jp.fujitsu.com>,
	Yuan Liu <yuan1.liu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/mm_init: drop overlap_memmap_init()
Message-ID: <20260626092952.qoihjgphv43ezw6v@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260625073941.145014-1-rppt@kernel.org>
 <20260625073941.145014-3-rppt@kernel.org>
 <20260625095846.4e2tl3fbduc24erg@master>
 <aj4s8DvCQ0jE2H_y@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aj4s8DvCQ0jE2H_y@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Stat-Signature: igqb1xfk1kjd4jc8xh6d5spmydksekrp
X-Rspamd-Queue-Id: 1C7431A0009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782466194-626860
X-HE-Meta: U2FsdGVkX18wRizAL6mOTUCc2T94mNVT/4Es3oWuKHGZdZJH9T01BLa/ff56iz/GvGITampcMCOn4naVIpVrOGy3XgdQC8g5Gr0EvFSuXeyVqMOY6xRNmH+hUwlMENwvxGrWzTvkNyHEyagPn3Qgv3YH7t7k0AatjP8GGbj2ohgH4+j6BgdAtyFU9THmIcqzqPet64ToFnzaPXDmZuzAd/IjQ+GOgMzcog/+gnkfUKbMk1a37oXgfr47Z2uoDWqsa4eKFroSI1UgvQns1i9uHIpafbRNYoMHEcgV/dE85nQf5KVKqVPpLPP6tCjBquW8Tfw5DVpb2EUTC7x7kw4J6dpHheN9O5pfKukGppopTS8NITifezJP/UZ6elTFXjJC2aLPiJgeRHrHJ8TpCc6dpnEvBbHaLXtWDVFLKWAX7wDVKjV6PzNtIV4tEgEbIealBxv6Xfd3Q5/XOjRQa4pQ5DslGKfWHBnDkbnIiNHvRuz7mmvj23ZBI2kQSCs0ycnACHXH78iP7nbC1mbkPVyPy6LauIRHSj9rUI9Y4u3DBtrDI0Btlbvc4lxhgNeER7n5DStCg+s9vMYGYfvy1M1UzDwspgNZnr0riZ2+8WFY67X72vgfvNdKnMDjStfeThnBI4wkfmdARSxggQojyqfZExBvD9+T6X2rpSMz0fsgZA7diSG9jrWNOv6tEXhQjthseWcrpYqppyJVPSANV+ujz1T20vD6lk3OKw+am6x34TN/8O5/wI6oXxAQn2nNP27uqZZXRT7HjVlCQhWgjLzuIg0uU3EVD6VPhJhrVNQzGRJbh0DhecqsoHkaW5GOfQAGiQJ9Iy37UpD12ELYJgGid5eGWBQ+T7GgoOmA1WgK3nG6ewPpqpqzBs+Yeyo403dN9oPlWu6yD7sW4rBi4LlBOdNyl8lo1M5BkdPiYOo9bRLudAM33p/DYkfd5Ilh6WYNoPGExn+xwr8b81nALSJ
 wjbpvps5
 uzLzXf6o1Swk2kU7lUE1ctreh3k9YT2fEjA5bUu7SwUnJcwkOZQE8yZrU/32oX078r/SVT+r9rPbwdQi2PjnhJQkAYyec4NpRi1/KprayOoc5W7izfT9edQFC+UGTkOvPU2D1evvfzII4GD4I2pnWOt64UOyD4YlcFgxcOuRmv0i2EpkQhrZFNGSAIN8rGisTM4ae1XooVVoYuYvQQt+ql7iUOlNuF3lAHcQlsbvddZaLNJXpD/tPrOf7t2NK+2ypHmjDDgomHeITLd8dvV9e5Po5kv/JoFA0legW7Gq2Df2vmqbP83hkInJ+B+X0ofO4EEqoQu1QnbKEtesWdcW3dI3yqcLyFUMtYV0UohBJ3QMscTir0KKj96drm9EAYKPUjWPTfabU9/eVZyI7IYaaZ8HbF+l/kVzFz4cipgfj5Ul21XScz4Z4259RmIy0D9C41jw54YL19FWa9gE8vdgUCepRf1Sc6Bt4OhdLkodcdinfZEe84L7KXrU674MAS7mR6zXmGos9z9mztsTUL7xJfFWlITDnV6mcn8ntU20Z1iW/W+7wcnFzWu/jax+t8OGs+pG0MCaRQI8GMp0Xf9absJUx1gpZhAcCPiYfafm7R3n0isVWr/+wS40OXi6RilxMmy/1IrpjVsjGuVBlaJ/7BAwFrqf3VJA69G67xQOj4WNlRW10nL6wPds6y0JPnKPT1ETHTz1P+kJiFTXsY7AWE31hZQeJ3GhYpN12BzebHTYjCv1dGqsAYCnlnQo2XSUzUt9+/SvM90qFsNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 10:40:32AM +0300, Mike Rapoport wrote:
>Hi Wei,
>
>On Thu, Jun 25, 2026 at 09:58:47AM +0000, Wei Yang wrote:
>> On Thu, Jun 25, 2026 at 10:39:40AM +0300, Mike Rapoport wrote:
>> >From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>> >
>> >When ZONE_NORMAL and ZONE_MOVABLE could overlap because kernelcore=mirror
>> >didn't reduce the span of ZONE_NORMAL, initialization of the memory map had
>> >to skip overlapping pages during initialization of ZONE_MOVABLE to avoid
>> >double initialization of the same struct pages.
>> >
>> >Since kernelcore=mirror works now the same way as other variants of
>> >kernelcore=/movablecore=, and adjusts the span of ZONE_NORMAL, there can't
>> >be an overlap between ZONE_NORMAL and ZONE_MOVABLE.
>> >
>> >Remove overlap_memmap_init().
>> >
>> 
>> Do you think this is valuable to mention the double init for the overlapped
>> range?
>
>Not sure I follow.
>We had this weird overlap_memmap_init() exactly to avoid double init.
> 

Yes, this is really weird.

As I described the detail in [1], before this change kernel would have
overlapped zone range like:

  Normal  [100000, 1c0000]
  Movable [140000, 1c0000]

Which means [140000, 1c0000] belongs to both Normal and Movable.
And memmap_init_range() would be called on this range twice for Normal and
Movable respectively. And we want overlap_memmap_init() could skip init this
to Normal. Because actually, the memory in this range belongs to Movable Zone.

But overlap_memmap_init() only would skip for Zone Movable. This means when
init to Zone Normal, it doesn't skip as we want. And when init to Zone
Movable, we don't expect it to skip.

[1]: https://lore.kernel.org/linux-mm/20260623092351.13031-3-richard.weiyang@gmail.com/

-- 
Wei Yang
Help you, Help me

