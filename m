Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC7BCF31BF
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74D536B00B7; Wed, 19 Nov 2025 07:42:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FEE16B00B8; Wed, 19 Nov 2025 07:42:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ECEF6B00B9; Wed, 19 Nov 2025 07:42:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 490356B00B7
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:42:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD66F1404C4
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:42:33 +0000 (UTC)
X-FDA: 84127320186.21.E9E811D
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id D31B316000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:42:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dg1rWUfH;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763556151;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGVPQs0raG+cv5Og0jXtjlAYiYTgCHb1gAaNgqguMEk=;
	b=PHw2aXR6UQo/VRiXfOO7BLi+kWG7qwJRc1y1WEniJ44dPmQvzXIgoA9lgHcIMDSPQtoLrr
	zKcVi+kWKZ2YWoRJabwD806FotJ5R+JGvxM0Qgo1pstsAp+Nni4oDCxO9kr57aXeSr7BeX
	wMyAVnMs8xpPUXGZa3C2bct1pSMiQAo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dg1rWUfH;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763556151; a=rsa-sha256;
	cv=none;
	b=icPuWvob+cv8CjgODZ3JQ1Jm/64P6XBwLvUwS5HNPKYjYKXG7iHnT05EB2H13/OoZJRhSu
	7xE4m/bPG+/0+xmaQPAaUnltPp2MAXQDssHRp5NthkIjkPJ20185BDufEi5pm3UPd4tnvn
	BCtxNXY0moSNEo4a9HGIHBYYsXlV1Ns=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b7355f6ef12so1175971966b.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763556150; x=1764160950; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AGVPQs0raG+cv5Og0jXtjlAYiYTgCHb1gAaNgqguMEk=;
        b=Dg1rWUfHlbeuXy0TJuoubxSZPGDTS8fop1L7kR0+sUy0VihWc1WX+V/PPi03lEV42l
         rUoUdLZXjsqb2z7vDincwpI4x2rRAPI43oq15ip+SQmaEbhRxihLXzcQHzJJdCfu1YrF
         0EdRepSwGIcZjhZB/Vbx9R38DiFdVYExc12+ZuTEA3HGzDN6CjUVmtXVq0kjLEF+9RW9
         qL83w0cML+5t1+pB9lcgKxJCv2FHK45jnMBgrYE2MHrYKpotUyXAcuN8wE0qy/QQG+VM
         XQHBk6p4cZfW5+2LCXQl3Kkj/h3i8V+F9I3n+trkkH2hGN50bUO3j3BW4uJIYwbWWxKt
         Dr5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763556150; x=1764160950;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AGVPQs0raG+cv5Og0jXtjlAYiYTgCHb1gAaNgqguMEk=;
        b=T6RIfE9XOt9edP24M+gs2XGr5uS8A55nh9BCxyZ2qnrFn2K7X3NwU9fFaslVyAjVs3
         uL8fEDHb1eRYEiQZc12y0z14JE1j05D34WuP0gNJQkEQJ6FH3eOHJr+kk1TRG5bwm28w
         c/XBN5eH630LYrPS5x5NYD1UK/9jEfEyeQTrV2Z6rYYyo3LlUWGZmhft4oNsbFdVjnY6
         TqqCqXN/Fh28VxxfAan+wd8mEzY2bm9aqDiQhp6PK0b5vrw/XHu8viU2FiSAgtDBTLvX
         Qbyx3N+7Dh7B8liu28LV5ANWXw46mOKwfQTg/ZGkul/xbN2Z4sxg82TX+6v830ztaUZH
         Eqdg==
X-Forwarded-Encrypted: i=1; AJvYcCUB5B/6nYk4c1Scr4/zCV/SzOp9mUsFKsJ60DnAjT4/57W9l/DI1IzBbAGY7M+AJwe4+Skk/afI+w==@kvack.org
X-Gm-Message-State: AOJu0YxgbOZUn7DO7Vpf0kC2WO9p7UwP1tIgGSFZOOzIGutAcct4rvFM
	Zy0+mW6Xwnk1WhO3wkQnsnmh1eJXgfkFY8bgPuFQvmj43BtT0C8ZX4jZ
X-Gm-Gg: ASbGncshPUQcf7BY4595NJkJcDhP83Mp/Up84pwWB5y90o6ATzk9kbpwRge6FebeIcs
	bGMUl4BWkk/auzneFQPP5GC6cvhhuV9x+8RUNOw6uY+9MYRYoNWRwrXGma4mWOw0mbRZePD6aaT
	WabRMvx4RVRaMVndggmGCgcOzk+qKjXTLe0soxSgsrBxXV+E9BGcDFNSEP/S1lDKAzGRUgC3d2K
	lCDyoKhnD8KJQsPpPA2b//raagW0AXe2MlxiuBEJdkXedYoLu72VPSRWqq9RtjEBOS4iMi07z/6
	U+6tPTdBuBLO5FUzvklZEZ8OrG7J9xaIXNeQlboBe0c0IUpu0Ez0Qq6Om8Ga0GKweQViYlfEAXT
	LMkIMczh5maSh2iTjqMdg0qwWDzoYTApJathRGqKqsWnEQv+7hqTaZf7/oyZ+zj+kcNOzPkFJ1l
	inoldWJ511FqEcRNCLpToZjDBW
X-Google-Smtp-Source: AGHT+IEN++hzFc6qM5M79F8zkm6+1UULklUVoadEco8d4VARLzqMb8To7qTtpf6EO2mbe1PlKSkrNg==
X-Received: by 2002:a17:907:7252:b0:b70:af3d:e97b with SMTP id a640c23a62f3a-b73678ade45mr2126745266b.17.1763556149881;
        Wed, 19 Nov 2025 04:42:29 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734ff75e4fsm1611291566b.12.2025.11.19.04.42.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Nov 2025 04:42:29 -0800 (PST)
Date: Wed, 19 Nov 2025 12:42:29 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when
 splitting shmem folio in swap cache
Message-ID: <20251119124229.e4cpozqapmfeqykr@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D31B316000B
X-Stat-Signature: 9gurftgib5tuuixq4phusgtxdf3jubkq
X-Rspam-User: 
X-HE-Tag: 1763556151-309882
X-HE-Meta: U2FsdGVkX1/zLQtALFxtJLTdgPwWNLXDaLQSSnnA2VVvLfZcyk2BB+PGmekXyBXi/kzpbVHtqlqTf9/R9ak+/wi1qFrAHAHuXVW/JoNFgZAxgwf2m/sNlStNEBQrnHx/pZ5HZRoAnRDNUCkRgmev6/usnjgG7VYKHVV80gwhOBFtOywTvJ59KnQmgXfihNcIJ6GfN5wTa8GNSJvm1i9UAPuJeuJye9ENXqQe6YolI69T+vC/4+BIpzkTEcy/4YToVDA53Gq+m2kIdETJkYIKMw185M4glxp7JKQCLlI83VUMJs0Rm6cXvs0iOTnYhzqwzqR5+2+o440M2KxuW5M30v238OzhqcVo84sunZLogHhYZqnRdVcvuboKQIU0IrNcfmt8NeQqZ+3W2Z6ibGBc7+i49W42+QxipVy17JJ+jsbqL9T4TL/MaMIpK3kst1qCu/BiQD03FNHku0HTltlQ8NhwyM0P9cgSqFQQeCMqs25AnUieQk260RpYZOm3oryGSo6qkBOwopedHoc/QPhR97/cGSCgmd7Nxfh9Tn4V5ZL6JRxe64w6UvmCoeagovBLa71oxjmVuolL7LhnhxW0nob8IuqL9m7BZ3UTg2aCedkQOxrpGGo3Eo0Ax3vb7MRFijOJmLDWkd6DDTBy4qtwmspAxTeB1DJ3F1JDd9MuFwcSP5JGrc9qS6cg8Ka3xSY4Ct/asVWHkTdQUrI8BMXzr3UeMqGALvKhUnzgDuZ/U/22B1zqUUqGvBdQxwlgqHUj55JXpfCVsiwuY5T4sXsG88Vt5TSRFpOv1MK3UXYJBaaT1AGYlM1vA9fRArWA3V+ttajvdPeC/onelwTANLX4kwukeICEZVH+psErqRz77N1IrS8zThpBV+9CMGn3K1jXi/1XTN4P0NLQ/WEK2wHwBSJrdG9jJ24g0uOXHj32RO/SrjHkrMQalsUmHRS9gGANmJ8S1Wi0E6WFYWQ+hKd
 LCT9FHEK
 tKmhWN81PHa4/BHwBFW+1jWLyW1YfvCopto8PcgfQmFAS2OxgooIvE7JyHAQp7Fflyhd/ZTLCm2bya5JBhaLf6ncS32j5BWEfrFxqDNuo6dtmardTwnW5Uuu+3JLL4W+j0ZX9zKaylh6nSg0K9TUCzoGldsecVfmmQk6lDw3QFbFzh7P/EzriDLqgp9fc1RZWX1kBU4fnuNJaSJuPpHrVtUWzHe0mYX4x07Oxc9O7Cn2H0Vs3TeKq3on6vkNjSdn7KL814eoRnpW28TNhErkAh3p2kPt4Tzj2qY+3hsNTyrslyX0TMh+yjEd9YK8Dx6nvl5ivoX5OtOW97DUCfsiGXE8ekt1TxGXhsp5VNKNpSLyyqZ7MvF5yAt0brTHWQF5tTKfqfpJWqGZa9TWqH+lewe0kn+ZjdPL5djYkU7/sJBcPlwCkUM/KsyX65jxRQZ7nahb1RjIEMbnnrORGn9W7xwwRQSg+9d4bBqDAgogoNhDppDkHNNtv2Ca2otuK5k8z7Len15LcExceZ2KPYzm7ScVQtR89IHUApUSikj6ToI4QnwRXqHz+Mnzr8O5GhHSXvNnLnxQaCcHsCazBaMDJsz2k7SwsE/HjsE91VM2vJU1ssYzNgU6rTkLzeIzWxGoVcffIsq5w1BroTdPg1JQOtITRYAuoG6I+57/01+yMiO+5jxmC7yHaQkKGfDpa61vX3W/UC+sHttF6DhEnceJCLAY7+GMLUHxbGl1pJPualvriJICeFPtHNXlN0aTElbhR93Y73+cePlYY3fDEU67T0BlbATzyjqzJiLMvjoATJU/IK+rnaxa6/qB1pvWGWRqZayZAv9FaBgJ4ihlG36z9pXZic2WmTn77czzswcz6gd5cdPLc6v83boOsRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 09:57:58AM +0100, David Hildenbrand (Red Hat) wrote:
>On 19.11.25 02:26, Wei Yang wrote:
>> Commit c010d47f107f ("mm: thp: split huge page to any lower order
>> pages") introduced an early check on the folio's order via
>> mapping->flags before proceeding with the split work.
>> 
>> This check introduced a bug: for shmem folios in the swap cache, the
>> mapping pointer can be NULL. Accessing mapping->flags in this state
>> leads directly to a NULL pointer dereference.
>
>Under which circumstances would that be the case? Only for large shmem folios
>in the swapcache or also for truncated folios? So I'd assume this
>would also affect truncated folios and we should spell that out here?
>
>> 
>> This commit fixes the issue by moving the check for mapping != NULL
>> before any attempt to access mapping->flags.
>> 
>> This fix necessarily changes the return value from -EBUSY to -EINVAL
>> when mapping is NULL. After reviewing current callers, they do not
>> differentiate between these two error codes, making this change safe.
>
>The doc of __split_huge_page_to_list_to_order() would now be outdated and has
>to be updated.
>
>Also, take a look at s390_wiggle_split_folio(): returning -EINVAL instead of
>-EBUSY will make a difference on concurrent truncation. -EINVAL will be
>propagated and make the operation fail, while -EBUSY will be translated to
>-EAGAIN and the caller will simply lookup the folio again and retry.
>
>So I think we should try to keep truncation return -EBUSY. For the shmem
>case, I think it's ok to return -EINVAL. I guess we can identify such folios
>by checking for folio_test_swapcache().
>

I come up a draft:

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7c69572b6c3f..3e140fa1ca13 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3696,6 +3696,18 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
                                "Cannot split to order-1 folio");
                if (new_order == 1)
                        return -EINVAL;
+       } else if (!folio->mapping) {
+               /*
+                * If there is no mapping that the folio was truncated and we
+                * cannot split.
+                *
+                * TODO: large shmem folio in the swap cache also don't
+                * currently have a mapping but folio_test_swapcache() is true
+                * for them.
+                */
+               if (folio_test_swapcache(folio))
+                       return -EINVAL;
+               return -EBUSY;
        } else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
                if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
                    !mapping_large_folio_support(folio->mapping)) {
@@ -3931,8 +3943,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
        if (new_order >= old_order)
                return -EINVAL;
 
-       if (!folio_split_supported(folio, new_order, split_type, /* warn = */ true))
-               return -EINVAL;
+       ret = folio_split_supported((folio, new_order, split_type, /* warn = */ true));
+       if (ret)
+               return ret;
 
        is_hzp = is_huge_zero_folio(folio);
        if (is_hzp) {

Not sure I get your point correctly.

-- 
Wei Yang
Help you, Help me

