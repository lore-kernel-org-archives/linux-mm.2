Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38539C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 17:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37D536B0095; Fri,  4 Sep 2026 13:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355456B0096; Fri,  4 Sep 2026 13:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245ED6B0098; Fri,  4 Sep 2026 13:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAFF76B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:33:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71200140162
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:33:37 +0000 (UTC)
X-FDA: 85176776874.30.7F52D11
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5A3E2C000B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:33:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b1eqeNyM;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788543215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=soTQky9Z3nYNLqFSceLyBlbSmjBlYyMm4HBR+pwE4Gg=;
	b=WVgTujhB0xkM1gN1POkCWLFylOeAvr8Xstf24PnEwUAEL+XD7MinJ6Hx2AUndQt3sLfp+K
	w6slmyufxDi90xmhIxo1wF992AGjM28mGneiC5xZFVIXOylLfzxPOGXOTgGM6y5PsaUMkl
	kBBhxrE9bBkEPvfHhLNwGKAuCFM8ZB8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b1eqeNyM;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788543215;
	b=3BVAWTqtzM/OFf+b+bPc/5rx5Qx7PxDlawzjYZENTJd9LyC6qUvrKgVIEzHDpMNzvc6KZF
	FbLyL1Z5pl3CSSwXCw83hVhmy56lcpo19RGVEaOWtBR6rQWLlz50y0sX4/80AkNEnO5/h5
	1M72QWaOOQr0NLuCPO7w8bFG+7u5cf4=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48441a2ba14so1101370f8f.1
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 10:33:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788543214; cv=none;
        d=google.com; s=arc-20260327;
        b=SKFIqtfVI3WrfgWvYL5EITtkf9Fw4Tb6LKXX6fq74Ri5ckHvkCmF5vx4db5iLfm7WF
         f9tDNRbZDvIXUVSPB7gF1ypC/6z80L7eiJWupJpdjYeSIf9c6tW4ZgkYQrLcTrzYMkY/
         5bTi1+1x44pke6YCAL3absYvQ3Xk/40LK/WqtQSvgGSnJ0HAhig5uqwcip9OBjZu4t0V
         Ru6b10kim/Xrap5M7Nnj0b2JqfygZ9vydbJyxQYBWDnNPKDKS8vVnUSBUIiFnJhjdCMc
         XxnS/IyEJMwjw3Dbf722QiIhTGWly3hPek6xRtvpwFLtZUyE67Rh+KrA52Slq3FogjMm
         jxSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=soTQky9Z3nYNLqFSceLyBlbSmjBlYyMm4HBR+pwE4Gg=;
        fh=ADQYGoFp7OVoUemyxaMhUTdLFFV8+JAYf7HQVZkXFDQ=;
        b=d8IrcGrzatA5e+e9nLzdwXJT+Vq4fyaPA7dMqyrMvqKQIOotQ04N2nqfK6hNBP95KR
         485q/WcjAW95yd/kar6XGNgmWNJWKdanxg2A0cosCLhs1LhCjTEHnd52E+ttBqpIeS20
         B439ZmycBcgLRMQOVHdjJnGkgHuY5Lsrd3EY7SnPZKx68OzBxV18KxtZzKQdayb6kViu
         l3YiWVaI3J+HtrA4xNmz3jAY6JiLksEx6pNRSeIyBwo0nqitqutzCqaJaopwvJR5l5I5
         D7FsHWB92zLYycsFAQlqcVFZ79idWgPM8mDkQZ/E9B/lkbOh4VEvdH67rICoEcX6Bnsa
         Rwng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788543214; x=1789148014; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=soTQky9Z3nYNLqFSceLyBlbSmjBlYyMm4HBR+pwE4Gg=;
        b=b1eqeNyMLDUxIGrT7TsurUZY0Da/IPPKgB73QoyDTYLg5+QMLGSmdHoLVRhw+HhvkI
         WL/7l41KBNBKNq66Br3swH5TjNhUTNDAlWyH86fAf37oFF75sePFN8MP5Fr+fNXUy1Qt
         Povhr9KsENkOl8BrPyNy8Vib6yO9wkafjpYO0DYNC8yVLEj0o8SpYnDXtYLbI2u6Wy+P
         owtKZjgxPQ5PlIo5VHRHobPO+p38FH3mkh5GNgESzyHZ+OYSnzSQg6Y0vjX5HQbYRMXf
         pfpzi47E3ctC08gGGYONFvC13XMZqmW2ha/aFZUvTG1BXJ5YdkxXE2KQH8k3ZeKeSaa1
         7Xvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788543214; x=1789148014;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=soTQky9Z3nYNLqFSceLyBlbSmjBlYyMm4HBR+pwE4Gg=;
        b=hT29waOl30Al5HSvKBy/LUPlHnUNsfVRfRN0QS6M4gChj6uD4ZN58dfWPPgfVnbqcc
         tI34qHbTuVNnQomNlUDG7HgipRllRdKUs0au1TSAPJHK93ELbf2L5nlWGdXOOJJdgZrX
         fy1DDs8AU22/oCNdjsNd3XpQTR2j4olmw3XgpDDdfOdN+kFOaDmdxfnqzAECFgw+WV0S
         vm9NKymzGYGDreVzKwIQ9Af8rdy6sU98YxlKK3p0bOulVj2Q0QfxO/IhvSUoovRBbF8I
         8b5iABO4C3rweNDMQAxp2PDjvcOzNiddH9TbsE22QIgKEejjHf8qHx/WtNpq6UTKSvCX
         5hOg==
X-Gm-Message-State: AFuF++kL1kcMHsQ884ALtmr3LXoAQI3hZ391RLxhxwQh1n+F13lg+weq
	MSWKXEkkKgIi2i9sJIlW/ywOh1zpRUmiVvsm/ICtEGRfUxBIkQyXAuf52Ddv7cSkcBrRfwaSrS/
	A2e0PmHps/qvFTj+22/z/1mXyzH6HB+M=
X-Gm-Gg: AYBFou31TQjnRwCzn5ZJhPrg7HYp0RpRU5frNprfAwEJVLBcdV43F+fxthlxU9w/KJB
	wVD/m1D96S9Ns/mLx2dvrH8J2+YgTgcWGgYnto1jUkasLiKaGokdcWdRWHTOgoEhDvTf3jDWFsw
	kMmOtBQ1yIsmdB2nTz33dnfoVt/+FX0hp+kxF9KoN9iVbfjaFXXg/PDdhdkl17wCwrXqnw4n7Ce
	+QMkl4cqQBIL3XFPXrm1zF7JZ9QmAJNirvoFBH+ndngOr8IhpLqn7zKyU6Ee1SdAlQY9hmqmqPt
	tp0wzyibns73N/5bMe1s2HnJBmSc6WB0ADjeLdCM+pNm0+8DKr26gyWmDeMPblH1OzkmiDTyK2p
	4wN3Hz+WSN+Tr6WgAeWBnxWcg/ok=
X-Received: by 2002:a05:6000:228a:b0:485:8fe2:ed81 with SMTP id
 ffacd0b85a97d-4858fe2ee3amr163801f8f.26.1788543213669; Fri, 04 Sep 2026
 10:33:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
 <CAJnrk1ZLzNQxrSLQx7TsLK89QC_=9cDfoDcyKNBNde0CiDGoNg@mail.gmail.com> <4e498938-f21b-4d75-b789-8a615aba877a@huaweicloud.com>
In-Reply-To: <4e498938-f21b-4d75-b789-8a615aba877a@huaweicloud.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 4 Sep 2026 10:33:21 -0700
X-Gm-Features: AcwNN1WC5_C19pRuHFRSSvaEOgUDXw8Fkj4YdviBWSd6-uI0JItHi4sYChYNXkU
Message-ID: <CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in truncate_inode_partial_folio()
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com, 
	willy@infradead.org, jack@suse.cz, ziy@nvidia.com, bfoster@redhat.com, 
	djwong@kernel.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, 
	yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5A3E2C000B
X-Stat-Signature: u83d439ygskwnoosnuyeq8wmdza9cgss
X-Rspam-User: 
X-HE-Tag: 1788543215-564198
X-HE-Meta: U2FsdGVkX19pPl99c7f1i5uhpKJAauX4qbcPcrY8GUXbkn4meGHZQFitqfrQJsG4kaaBFu/yLUpYWciRsLyyt4mcm6Q3jKAflmcgwcGFsczIprRsATpy/CQt54dYkGQ/bqHfM/AFTJiqwXfdbi4j+kO9lsqug6092oZseCkSVii1zGMLdAzfUzVrzzk65Tsf5P/GJZJrChecFS2hrwBS1n0a2BfSkXaq7l3Xp7Z3peGhcaNJi2AT+zdMB3LzD7TzQKy7PhRXxLnyqVHs8RN86RwTLgNXdQ5PRmUOudcfU+amneGGvHs6VPp3hYfw1dOiHbXQO/hzsHoBg98KwhTQKds4f/0IdE6yZNYyNPfP0aMSd3V2a3+VE2yY7dKulsOHTpejyqOoCYnsvKjZuq9Kf/OCaJ5JdPRX3MjwsE1usfz+YRdfowP5EjMKvQzUcl3uQ72EU7r6DVWfdKwy9sV9BENvbwm0WwI1cyem+03U3VhyOUSZuEwKnJdDD1W3kAH9pXrSih9jJVSCSmd73+j1Sd20B9OO9zH2/S35hpBNtfbWAT9i59R+1DmQjjo89JKLiS6QF/VL8nIWTKnU1OqoU4GALwo5J37wySKdIZo0PDPSf5360bvCRU0MUT5XTW4JtnscD6r+5A/W9zBCfZqsslFNEIKVYClUq/UmP/2VYQG5vuD+k3+cMOtnXcR9BY+t1dHSHcqsfBV1Siaftc/snCZhRGhpOk/3RUZKwEoFS+0ux9lSvo+SMFb2CC7U2NxBXQ7n1MckCgNGkAAu1t9TShD3P2TYKKuEtbDkmjUToFWPGEsboxVhWeNBiOGdbLg80ntGyx/YCmDY+YIldU2vQy8i9BMKeApnXvyNj8eu2OFYvPvn2589n/ESD7EvoiuSodhi2ZnB5gGDOldzlZOdIgY4W3BfuSM/Sk2w8Fb8JMVdTyQ459b/p4pdg30HJ7Fn8ve6jsx+KBI5LURTBFd
 6oKe8lZ4
 TbjDiQJSYHqe7vV51lSE8Vw5loBcvW0H5afoYu6N9K9cg+J35z+pOEimmUz3mF7rx+Iz2yDdTYxGh+Iugnv8SSA7bYwOIPwld/tTaG1n7aUHzqs8s8PlNM2FkUYtuRP1ftClKpxMLS11cYHLbIx9LEFeB8i2UCAouGKk6EnuR8YqXDkudJBtkdirFDEdsmFxktF+WPfygJkEslOtanvuYz2WnkxJzFts6Oa5YWitkDmS2Mj+4tgtM/ysWAshuk5ULVapYcje7WsCWNlSteZGddhVi3eRuAo7T9CyEujCa7NCHzLN7lIAhINx9ASS+EOLquMlMS/K7bYzHl8QfWKEFWeyfimYrWCw3QuSGvrQ0V9lWLlhjfRM/sxBdF/p7Tx9nYnx34WzIg2CQeshe5VAj+YTIhLdrHaHkW2ttuvwUCI214Cq/dZIx1ZcUYto+6lNF6a/6HitZXrl6l8gTS2pGShdE711ZEpX9yaI5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 11:27=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> On 9/4/2026 3:01 AM, Joanne Koong wrote:
> >>         /*
> >> @@ -259,6 +265,10 @@ bool truncate_inode_partial_folio(struct folio *f=
olio, loff_t start, loff_t end)
> >>                  * for shmem truncate
> >>                  */
> >>                 struct folio *folio2;
> >> +               bool tail_isolated =3D true;
> >> +
> >> +               if (end)
> >> +                       *end =3D (pos + offset + length) >> PAGE_SHIFT=
;
> >
> > If I'm understanding it correctly, based on how
> > truncate_inode_pages_range() uses the end value (eg the "while (index
> > < end)" loop condition and the find_get_entries(..., end - 1, ...)),
> > end needs to point to the start of the folio if the tail folio from
> > the split is a large folio, in order to exclude that folio from then
> > being truncated. But with the (pos + offset + length) >> PAGE_SHIFT
> > calculation here, does that result in some cases in it pointing to the
> > middle of a large folio? Maybe some logic is needed to make sure that
> > it points to the start?
> >
>
> Hi Joanne,
>
> Thanks for your careful review! I don't think that case can actually
> occur. Let me walk through the scenarios where the
> (pos + offset + length) >> PAGE_SHIFT calculation is kept as the final
> end value:

Hi Yi,

Thanks for your reply and for walking through the logic and explaining it.

>
> 1) offset + length =3D=3D size:
>    The truncate range aligns exactly with the folio boundary, so
>    (pos + offset + length) >> PAGE_SHIFT points to the start of the next
>    folio, not the middle of one.
>
> 2) !folio_try_get(folio2):
>    The folio at that position has already been freed or is being freed,
>    so there is no folio in the page cache at that location. The
>    subsequent find_get_entries() won't find anything there.
>
> 3) !folio_test_large(folio2):
>    folio2 is no longer large, likely split to order-0 by a concurrent
>    operation. For an order-0 folio, the page index and folio index are
>    the same, so the calculation is correct.
>
> 4) folio2 becomes stale:
>    The same to case 2), folio2 is removed from the address space, so
>    there is no large folio straddling the boundary that needs
>    protection. The caller won't get folio from here through
>    find_get_entries(). Using the page index is safe here.
>
> If a large folio straddles the boundary at (offset + length), we will
> successfully get a reference via folio_try_get(folio2) and
> folio_test_large(folio2) will be true. In that case, if the split fails
> (cannot lock or split operation fails), we set tail_isolated to false
> and set *end =3D folio2->index to point to the start of that large folio
> since tail_isolated.

The case I have in mind is the case where the 2nd split succeeds
(returns 0) and tail_isolated will not be set to false, and *end still
gets returned back to the caller as the original "(pos + offset +
length) >> PAGE_SHIFT" calculation. I don't think it's guaranteed that
the split will create a folio that starts at that page.

The example I'm thinking about is a 64k folio being truncated at
offset 0 to 36k on a 16k blocksize filesystem with 4k pages:
*end =3D (pos + offset + length) >> PAGE_SHIFT =3D 36k >> PAGE_SHIFT =3D pa=
ge index 9
start: [0 - 15]
after 1st split: [0 - 3] [4 - 7] [8 - 15]
split_at2 =3D 36k / PAGE_SIZE =3D 9
2nd split will try splitting [8 - 15] at split_at2
after 2nd split: [8 - 11] [12 - 15]

in the truncate_inode_pages_range() logic, start =3D 0, end =3D 9, so
find_get_entries(..., end - 1 (=3D 8) ...) returns the [8 - 11] folio
and truncate_inode_folio() will drop all 4 of those pages (including
36k to 48k which might have dirty data).

Do you think this makes sense or am I missing something?

>
> The page index from this setting is only kept when no large folio exists
> at the boundary, which makes it safe to use. What is particularly
> noteworthy is that for cases 2 and 4 above, aside from setting it to
> (pos + offset + length) >> PAGE_SHIFT, there does not seem to be any
> better alternative.

I think if we just rounded down *end by the min order (eg *end =3D
round_down((pos + offset + length) >> PAGE_SHIFT, 1UL << min_order);),
that would ensure end is always on a folio boundary and can't be
inside a folio.

Thanks,
Joanne

