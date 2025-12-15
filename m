Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03154D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5480D6B0027; Mon, 15 Dec 2025 06:57:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F8676B0028; Mon, 15 Dec 2025 06:57:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413F76B0029; Mon, 15 Dec 2025 06:57:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2CBC76B0027
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:57:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9BBC3B61DA
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:57:35 +0000 (UTC)
X-FDA: 84221555670.02.EBFCC16
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id 95F1DC0007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:57:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GsUDtQxg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765799853; a=rsa-sha256;
	cv=none;
	b=fhrKLpLl2Fxd0pa2JbgOj11CiK9PoPldv2q/HJQKqtqLWtdxx+t0YhQjeDKfVozcOV0h+q
	SEIxYknaBE8B1XvUSGsHlRy6b6PpDuEdduXNptQY6yBB+Kc2s1VlBwB0gIP2EXxd8bGo1j
	rGyPH165rvyRXbIJCgiAop4UcJt86hM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GsUDtQxg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765799853;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Flwk3C9sGIKtHVgz7EWy4WDHMBBZcG8HtkdXRgtuUk8=;
	b=nXtXkYhmUfb6M3tLpt71TXSdrJd69PtS9pjrrp55vJh2XUgh4o/f3smCCVbWWdp1FssIrb
	SAfVWaDmPGTeVXsjMpIboThMbidC6Zhr1AHYxTgqUTYAafUm2rrVHwsOKxgC9RTKS5ND7n
	tzonqrQp2l+kHfYdXxO3PtXKMsIg5ro=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b73a9592fb8so725995766b.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765799852; x=1766404652; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Flwk3C9sGIKtHVgz7EWy4WDHMBBZcG8HtkdXRgtuUk8=;
        b=GsUDtQxg0XdzhJpAfCIYIyGlKbR8ap1GAgC25PYvSpJJH0Ms+8ePaAoDW5AIdGC0dv
         yoUfjG8i0Icedfc6hHB/KAyX8G75XDedQv0QXFYBt8Zjpq+Zn3o5//AVwzt2KRpOVoD5
         ZeBqJ5KuuA30zfLkuu68WUKAt5EGLELmkTtJ9tAtQmjBL9IeKAoxUJIrQXoxjLanOSuz
         Wu2KsB9iYtTyVlHApE5yKpV1it/6aXaht9N0B2eveHedCjFyIJpQfE+cki5HLW3nKde+
         K0KAlUB31GQmU1GNaViTJ+iYe+knaCaeerv7DZsPI8ET+/v3lU6go3E6fS3o3JK8qShd
         C6wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765799852; x=1766404652;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Flwk3C9sGIKtHVgz7EWy4WDHMBBZcG8HtkdXRgtuUk8=;
        b=MxcZ1QZlTDoCn50C/2VnGffXclMJB2a+Wvb6OlJie4nPEqdzQVxv/oateXQXAId6/v
         M3r09sqzvRd3KayVeAhWoRuvuRb3A/w9oNdHvt2WcnrPuxhRdgd2ls3ShVfJIogCh7H3
         qKE+W3tvfBeQ/WEmRS7qJ7/Ph9R4bvaR9wd0wSGp1c/qb07LnL9kg0LTJL15/UkTzfGG
         Eka5WIwweRF5n3DzC0Y8Joz4Wzemf2X9xQpqGaQldxuaqy/OzT2NhmSlwQPyDK78VrJl
         9O3wKJbrbsDSRjcDIyYzLWwsShkvfjOoojKKJjSgZu7b6zeLhjbJXWBBy51RkuytRNHS
         kQNg==
X-Forwarded-Encrypted: i=1; AJvYcCWP5bW+zwLNwl7wibbrKLINdwb0ysQPOcxxHZaD47kebrzJ/HEUCZyneQ/dmOzXUW6fMLWIv2ZXYg==@kvack.org
X-Gm-Message-State: AOJu0Yw+cDX2hEvsskhqKZf/VnRWQEGpE7f2SdArslB+86miCpFOAZNW
	Oc+3KgPUNMvMuytwL33URAMEWhrIM4dIEL/C9HUpI8BqKqXtIeWu4Da3
X-Gm-Gg: AY/fxX5lbpxQgG5uyzYdoeSEQioEikiyWO3iFIUKAzjEKhZhOeTvD/ACeNT47Lya2jx
	Ji/GrwG9g24CUcjVLfB5LFmVK1lqP6DkHwge37ElZ/YEnn0Zmak44FSRdfGdGzzE91Nz8HtenSc
	FpQfv96wOw0XTclmZ8eIIWJYRKcxq9gxJTjxhj8sjCuDwN2cQr2ObomEIdkZn1xvhwZxAXSg4zR
	yB29lC25vkW60djQosD9a2El5oPAl/i67f+AKbkkL9tM2GbXTxtfW/o0ugipThIyJdy5fSTRag1
	ukxvlkGljNntFpY2GyLgw+lkR8I7y+vy1bBeRSsDN2lg0pD7wkLxkPkfnoB2fWJ//292zipK4Wq
	6prTrc6gM1PAsrOEe4p/zbF7z9ccqYWExKnUmjiKxoG7TAI2N6VdKbrXYXbbj6dqh8xljJyjVZS
	TrvLfx/PuA4Q==
X-Google-Smtp-Source: AGHT+IF5BV3kIQgvVFr4NpWOf5xsHeoLYqoBpphtyDqGXNbnVZE8JBJ1zIZVTDsh3qNzzztN06HFtA==
X-Received: by 2002:a17:907:7210:b0:b7a:71b7:2409 with SMTP id a640c23a62f3a-b7d217ed026mr1368445266b.15.1765799851129;
        Mon, 15 Dec 2025 03:57:31 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa5191fasm1351584166b.33.2025.12.15.03.57.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Dec 2025 03:57:30 -0800 (PST)
Date: Mon, 15 Dec 2025 11:57:30 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2] mm/huge_memory: use end_folio to terminate anonymous
 folio remapping
Message-ID: <20251215115730.v462lhxeqrofjtfj@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251215004836.694-1-richard.weiyang@gmail.com>
 <CAGsJ_4w3535fwxa_WkkQLcfNjzRkJYbBJ0WfpYJ+v2hwovdvWA@mail.gmail.com>
 <20251215084353.nmznnnmcpcqo4ldy@master>
 <CAGsJ_4yPnv_G0vciNLabA_kn=0k=RP6kBpuD04btj3HM_zarTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yPnv_G0vciNLabA_kn=0k=RP6kBpuD04btj3HM_zarTA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 95F1DC0007
X-Rspamd-Server: rspam03
X-Stat-Signature: y1hzrrncfy6dpyetf3pon6wc4y6scx58
X-Rspam-User: 
X-HE-Tag: 1765799853-536235
X-HE-Meta: U2FsdGVkX1/cUpjKe9+efQkB7b4uO5Rfsg0sx58KxXdEY5WNytx4niEkZWNw6YS+etmL+nFHy+jaTW7iUUJN40lhX0KIXXLKirdSru89KZpfW4AmBNDx4gMaPenvg5qnMMAvfwpvG9lE1Bfut0QLOF6ya9cOqjugkbQ4r19T02xaascr2GVnGh4P+n3dwDVlOf61TRp+skDRxg1DkNlDztC1tGg3IY7C9JJOdDBSr+oUqtWD0zuh63DQNR47Sb4nd5sCop2ZVI2mRh3SlbTRnKHSjknZuNsNnus71jwuFHsa/EVcpzf4N0UgdlvLBxGGm2jGsb69tAWPv2po31W1LecNUF9GIZY1axp1gUcKhkQdatZUjZI4QwgA6kMxygEPGvMXTWPjED11aLF5HKV01iGkdooUyf+AgtC/30l3e4AEmk3QURBmf27QsYbFjxnQ7DQOxI0fOFPKKj4eoRDEM/GYJzvq3S0xOy485veLZbcCSOU3ed1FdEbkpsy484W47mFvf0iyp4091CVpxKHJXe9vRJA1XlemHB9BtvAECCEEAQqGFoE5fJUKVHYgwY94EjLMF7voMjq5TxxF08qzYpGnlWuSsWDC00dQi0iGUpaT9HkRI6vZm/s5KprrHtg/v7EGdcGcTIDjnpwdBwUNHiJa6kJjZFHJlTkeHWliv72UkiqvUr4imjYd8h0MJFjuZM7L/AT/jblIqeCTjyILeJVizrT2WMbaJnICxab+bg6Pzt3m8sPivPztH9GhLN+ZwW1eCKbYMb9WNe5DhzhPgQnOUVo87AxJ01y87CPgC4e9X80gVZp3K7VtjiNd8CudBlod1r+AQ9Q3JWk+ScBTBDqkpLXXDh2hVKjJZOgP41bIdzZM/VD0qmOj9q0Z6knd5riXGc8DKIw3OMXuG6kYHO9UDFE1Kv9xNlH1EXo7JvGSODbnP61Z+eev4KmhUfLOC7uf7Mjr/pJQyLp+OVr
 PP4KisFl
 tllVwuShwx7RIyVooeZXrBFBFnSaRP1zpTiqd/sOUzrW/wNXubzLMOyJRVEoHpvo0CnOlLqkDtTUa1id5poZhzok3n1afPMXLdSuic26m+9mKfD3vHPmodsUNWdw4YIqEHXLTthrWAo9jS8kwMiaJf13Ayr+kvnaUnefbINQINT8BRd5KVArwyGKEK4WSKhttrzujM/si3EafvOHwtqQbcZNAXz0B+JGLNiq9HonwpoRpw3NAqEkTrAfpLyhmgWXyWKv7BaZHrHiH+0X4EviZDnm5mLr28U9kYIn9iU+/KyS6gfTMlZU0KuXUL6TSi5G7YN0ygEwATdp0cbnlNopjQ6ywGtaeduOyq044XtH9ndJRLsh3MpoFfUsNe5SahgrfhZ3pBweshVw6kuRaNKKNniiP7xDS+mqHGFt/XQ9PgPZvyLjM6Hw78D39k029IpnsXOZBd3QRHyWuQLTwM+QLO3JXRYlh06oFtf7ryqrqyaQXOC6PJyA7epQxZ/PSR9t7USpsEz79u/DemJFXEs+h6ynr68gd7rFtwZVFcgJkPYxZenHQBAlJE0ejrBkNQCsqTEQvahKgSx4GpchpT9U7bOwGwrc/fb7xA5EtkqVDiTZqDVrJ5Bt9sNoYqaffTD5p0ZnZeaTXDnC4YImkKfLq+NhXUEn5cSn5O6DN/p2RuUOspJtXL0IAc9Ys5LjsKqJJC7ZpzxHXInwdW+Dyt4w5QfvmI3ZSaCTkZYAolhsgG2f8Hif1kurvcWKbe7qQYmw2gYRB/mOTqeN0pfWQTXelo1UZlqsq7q4Vw4H7TK+EE/t2ycgqoMLHMxTQRTnxR2qm3X9H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 05:15:17PM +0800, Barry Song wrote:
>On Mon, Dec 15, 2025 at 4:43 PM Wei Yang <richard.weiyang@gmail.com> wrote:
>>
>> On Mon, Dec 15, 2025 at 10:31:15AM +0800, Barry Song wrote:
>> >On Mon, Dec 15, 2025 at 8:49 AM Wei Yang <richard.weiyang@gmail.com> wrote:
>> >>
>> >> After splitting a large folio, it is necessary to remap the resulting
>> >> anonymous folios.
>> >>
>> >> The current implementation determines the end of the remapping process
>> >> by counting the number of pages that have been processed.
>> >>
>> >> Since the final folio in the sequence, end_folio, is already known and
>> >> tracked, this commit refactors the remapping loop to leverage end_folio
>> >> as the termination marker.
>> >>
>> >> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> >> Cc: Zi Yan <ziy@nvidia.com>
>> >>
>> >> ---
>> >> v2: move folio assignment in loop
>> >> ---
>> >>  mm/huge_memory.c | 13 ++++---------
>> >>  1 file changed, 4 insertions(+), 9 deletions(-)
>> >>
>> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> >> index 40cf59301c21..fe812d9c7807 100644
>> >> --- a/mm/huge_memory.c
>> >> +++ b/mm/huge_memory.c
>> >> @@ -3423,20 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>> >>         return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>> >>  }
>> >>
>> >> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
>> >> +static void remap_page(struct folio *folio, struct folio *end_folio, int flags)
>> >>  {
>> >
>> >Do we actually see an improvement in readability or performance?
>> >The existing code feels a bit more readable to me; nr is clearly
>> >the number of pages :-)
>> >
>>
>> Hi, Barry,
>>
>> Thanks for your review.
>>
>> Currently end_folio has been used in __folio_split() and
>> __folio_freeze_and_split_unmapped() as a termination marker. So continue to
>> use end_folio here as a termination marker looks consistent and improves
>> readability to me.
>
>In both cases the variables are temporary, and they look fine within their
>own self-documented contexts.
>
>Now that we’re crossing two functions in the context of remap_page(), this
>doesn’t seem to be the case, though.
>

Thanks for your feedback.

>>
>> But yeah, this is my personal preference. If it is not the case, I am fine to
>> keep as it is now. :-)
>
>I personally find the existing code clearer, but I’m also okay if
>others like your new approach more.
>

Thanks

>Thanks
>Barry

-- 
Wei Yang
Help you, Help me

