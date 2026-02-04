Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 049A9E9D401
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 15:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245136B009F; Wed,  4 Feb 2026 10:29:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F3706B00A0; Wed,  4 Feb 2026 10:29:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5426B00A3; Wed,  4 Feb 2026 10:29:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEDC26B009F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 10:29:05 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A06351B1601
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:29:05 +0000 (UTC)
X-FDA: 84407157450.08.07608A6
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id D423D180011
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:29:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JuxSqIOc;
	spf=pass (imf24.hostedemail.com: domain of 3vmWDaQkKCOkLWTNPcjSWRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3vmWDaQkKCOkLWTNPcjSWRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770218944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=comgElPe5TTFNgd95XxdbOyr6d3AFR078228Bo4y0I4=;
	b=YyUeELGM9L0L4xNmsf19JHYJMh7+AljCpeWaqBbBm/npnGd3y+eFxScQD79pVysCHgEAbr
	9svMoYwMTAkQQaGYIuTVroL00lijVOiq5Fe/IiCL4qGBrIuQ3/kkSjy+9HhyZoGp9Cet4P
	QJK3QXXd9VU8bAHTdFz7ludF4Yz+g0Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JuxSqIOc;
	spf=pass (imf24.hostedemail.com: domain of 3vmWDaQkKCOkLWTNPcjSWRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3vmWDaQkKCOkLWTNPcjSWRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770218944; a=rsa-sha256;
	cv=none;
	b=RJPjC7zivet2fFNs5GLkRc4EC9yCb5K67GzOxTNMxeELs8liaCNlIfucTN3pCtonUOz0kn
	8gAlYkMxrc5fdtB0QzC7KGosT86+Oh9RVMZSvIvS7qVCSINIRML4zECu2HwoWYbIzst/lx
	GWCrIMI7A+UxDE1q5qeKe6nNZemP7dk=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b88649b11d2so922506966b.3
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 07:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770218942; x=1770823742; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=comgElPe5TTFNgd95XxdbOyr6d3AFR078228Bo4y0I4=;
        b=JuxSqIOcIwYOcOr9Hug5m7Q7dLchcKEb9aFqqV37yNeNy9Kq8uNBCk3H3yLO2A1vgJ
         KN6bCp0m61jOyXBfqmoz7H/PdbsoIwL+mnweyCUioyRMeoO31adAlep1OpYTeUPzBUdV
         8V6WVzaXuIBw6mrdnjOed3QYTpUeUGTCf7nBPrckTJQJ+5ECH8BGCkDlYrdnzcGEZUjo
         FNOpVvog1UumZ4XRoWN+jAt5DHMD2xHPrRsAQmZUH1reoBh8e1wcq0pYkMYL88Ra6apN
         SxohQ6tTxI78xNnj0NzmEIs0phXxkcIIzQ26S2QBeXEPnWirJ/oz5Q5T9vI15J2IlJge
         wl/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770218942; x=1770823742;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=comgElPe5TTFNgd95XxdbOyr6d3AFR078228Bo4y0I4=;
        b=TzSUT33PuUiXb2k7vdydG9bU1y63dD8rYMK6MmBQxiW+stdPgLkD8LsoTSUD3RKHjn
         51G0W0KwN8/HOxasgi023GeaasmXneJDW9ril3aJijM+vTz7W4+tbZefMmsBdQhn9StS
         GlUP40bFY7xLyrD+ZaX1lx6feAisu8WqlJEfpaDDqDKKwnNt63AqS1jAjGZpA2xmui69
         SJZEQ/mx0qe4lazUavFPbcK1yla9VKK9UJrL3KFxRkp2+8Lh+gBJyABGoyZ90ZqDwUEd
         5/wrSZ62Ix9WnXcpyeF8AqgBOnmIJYgqqWvyLb/85yDBbYwbQckifNcD60FPP90uDOOu
         ltig==
X-Forwarded-Encrypted: i=1; AJvYcCXyZr6JQgYDFVp5owOgniEQ8zKEKDHk5BJXnKtlAEMS6UaMGToz/zn5E2muZRIlRy+CPqbO2Hr3zg==@kvack.org
X-Gm-Message-State: AOJu0YxZ/bLUpB3813JdKaNvn5rGEaQqsN2pdMqQOkXUG71fD4KkMnIQ
	L2Ld+CUNc1o4JN16+R7FSwMM1XeUCeIRl+zQGFWl/DPVJYx88hCuuSNeHWfvI/5L5m9cOijBleh
	Q79HkVDTRiHbDPL906A==
X-Received: from ejew27.prod.google.com ([2002:a17:906:185b:b0:b7a:5a7c:9bd0])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:72c7:b0:b88:7093:3ca3 with SMTP id a640c23a62f3a-b8e9f04ca7dmr253684366b.23.1770218942193;
 Wed, 04 Feb 2026 07:29:02 -0800 (PST)
Date: Wed, 4 Feb 2026 15:29:01 +0000
In-Reply-To: <6fgs2mcvwlitkjza5d7cpu3mk34sqqn53vqazkicyge4gtqt7f@5dvqmpubypip>
Mime-Version: 1.0
References: <20260118-mas-next-doc-v1-1-827d9f4924ce@google.com>
 <tal36hph2g5azjk33h564bllr2n6bz2xhdw4vcvizkhptedfuq@56chjersnkfe>
 <aXCiv9vOrMTbiJtb@google.com> <6fgs2mcvwlitkjza5d7cpu3mk34sqqn53vqazkicyge4gtqt7f@5dvqmpubypip>
Message-ID: <aYNlvQmpL5FVpGNz@google.com>
Subject: Re: [PATCH] maple_tree: update mas_next[_range] docs
From: Alice Ryhl <aliceryhl@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: D423D180011
X-Rspamd-Server: rspam07
X-Stat-Signature: f877bsamfseg8jxa4r57p9343zonqgiw
X-HE-Tag: 1770218943-176298
X-HE-Meta: U2FsdGVkX18Z5sGT+WcwD7NRzeNyVitl/XnmQBj9WgQ2Z26gpvGLwjsRoQyfjmlKgTDzdZh/P9dirx75afBFn4+1BjirtI5J+UcX5E+H6nEySnaBkuMYRV41Vio4yLEsH2xbuk4syHapFTWCxnrx3KXsXV3mtxjrLccgGskICjjcYd/3n/YEUXmS0wt0k0zJLy2JmHNFCWNQTcGq8LlvgfmrUgZ3AVwJ0gp7rKUYHtWKz0lBi35r6t5tGkAQluBCouxMngbNu68PZQkRrub7g7JSqicXcbkI75V3TvOKSm6Dij4BwhhC5kikzHUAi6qOgWpuqOdQ0EaIB4VGX4DyfS7VCjfhDzQRmFYOl6F6Z4dTPV+PO+sWM1jFUrUoyGW82024BWL2DOZKGXEsJtDbbC/knC7Bs6TImf4lbV/QDihB1ztMFzjcyfujVaahQiZAWs9cegxDa6RbOUPx5NPPnROUJBcoX3qps4ZomTmUQnccVWKYmjCDRQR23RWLv02ZZIpdlVOmNmx+IEkNZfcRdxVfD+7Yuy1Nb5JFctt/xIJnx4uNLPJb7EwtPHazVqG3u1mqhG2m45OjrWTO2QKtSe6X/wfZnorUHvUxiOT8EbhZMS/YjM4JjdEMqOCAmsrV8RMYdsEVlGk9gAz9qwFvJR6sXtguRzNIa6zp8xIuZETn2nSuxNhp24ztqgXFd0zWW3U4VB9KUdBzeliHR4G/4xdic7MWzU4kIVvN0ZSDGZs33I7J5p19W5PnFSW31dqQf9NPdAqbM2FdCEwkCbHTWywMg7syKWOo7AITGIKiBoDJEj9+UrxPFuK31jcdda6GSZbkInmpv2srFFDbQ6gDcTUxieGVthwc07LKDrp//yHsfX6VSI/o3wf2fdk2UJOiNmjLV37xRoSjnkanIO86ghBazxJ+fEYBJPSdlag6JRWgl4V9Ydjcjd2yG/y+XUxyEFqzwg7763RGBXHIChC
 bxNzybpb
 aPgIQcr1YmYc+8ro2uRDIl89nq6ytFPRoGhEL8P9lvFAGiggNCW2F9+ALh3Hm2cSa3KLCAH/cFOij0eV/KqLYfa4LZDE9cT6PEK4xKTRe5++XA3BB8t496pK/7PXTiQrZtrIjvyZG286hO9YMhOV1bJAMI8rxvysDMsrWuUnokas9xgH1ldXtS9JNlP3SA5K6ZNZ4XVFsr224L2WrpzCoqBcekFb1CaPAgjyey0rfn42/Lb1ciWhuonP8TjM6fhg3zg5F+F3U5obvbW342MapUMVff/UmRrKPl9POPDI2j6xRXzP8HrtmktDflp2XL3nPD0cqbt/QYy5H9kUKGjufmLNKo7lXS5iew6NoDLn/8micv8diTv6aQQFAEs3biIOcFY7S+ziG4aDm+gc7nKJbIBKh8FRXqY9GIzeYGq83MWfZa4D/34yjWuLvaKm3anxL8262Cy/zc6Z5HQHfvJ8z4a0GoovdJkXUcythmq+u6e2jy3ZWo6xJyEqYlf1kVTBKpOt+YMljpeL6+7cDkVdKmd9Kv56Quoz4yWTpDAU4YSQ6pR6R3ZQtR8PMULJYrAfYJyYOhNpw7Jhg724lqrT5c2Hv1pbxFGlaRRUfxLa2mJZgRRxZC2/aXz1Fhiga1J1TeFBMQPfXcSnhcTE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 03:20:17PM -0500, Liam R. Howlett wrote:
> * Alice Ryhl <aliceryhl@google.com> [260121 04:56]:
> > On Tue, Jan 20, 2026 at 12:54:47PM -0500, Liam R. Howlett wrote:
> > > * Alice Ryhl <aliceryhl@google.com> [260118 06:00]:
> > > > If you read the docs, it sounds like the difference between these
> > > > functions is whether mas->index and mas->last are updated. However, if
> > > > you read the implementation, you will instead find that the difference
> > > > is whether NULL entries are skipped.
> > > 
> > > This is not the intent.
> > > 
> > > mas_ should return special values including the XA_ZERO_ENTRY.
> > > 
> > > mas_next() should get the next non-NULL value.
> > > 
> > > mas_next_range() should advance the maple state to the next range,
> > > regardless of what is in the range (NULL, special, or a regular entry).
> > > 
> > > Both should update the mas->index and mas->last values, if it moves
> > > (ie, no error state is encountered).
> > 
> > I guess I'm a bit confused about the difference between XA_ZERO_ENTRY
> > and returning NULL. Isn't the case where we return NULL when a slot has
> > been reserved but not inserted yet?
> 
> mas_ will return the special entries.
> 
> mtree_ will return NULL on special entries.  I think this is just
> mtree_load().
> 
> If you want to use your own locking and use mas_, then you can filter
> out the special entries yourself.
> 
> If you want to use the normal api, then the special entries are filtered
> for you.
> 
> This way you can mix/match the apis but the noral api still remains
> simple to use - even if there are advanced users that mixed in.
> 
> The idea is that if you're using the advanced interface and storing
> special entries, then you probably want to do something different on
> those entries - at least sometimes.
> 
> > 
> > Like the docs, you use "get" vs "advance" wording here, but I don't
> > think there's any difference behavior-wise? Is one intended?
> 
> On return type, no, there isn't a difference.  The difference is where
> the mas points in the end (mas->offset, mas->index, mas->last).
> 
> If a NULL is encountered bu mas_next(), then we proceed to the next slot
> (which must have a value, if there is a next slot).  So, mas_next() will
> always return the next entry until there is not a next entry - then it
> returns NULL.  Note that mas_next() takes an 'end' value where we'll
> stop advancing slots regardless if there are values.
> 
> If a NULL is encountered by mas_next_range(), then we return the NULL.
> So, in this way, we can move to the next range even if it's NULL.
> 
> I hope this makes the difference more clear?

Yes.

But I guess the docs should still need to be updated? Right now, both of
them say "Can return the zero entry.", but one of them can't because it
skips them.

Alice

