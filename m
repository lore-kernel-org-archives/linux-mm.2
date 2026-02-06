Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71243EE6B48
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 18:25:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3D8B6B0089; Fri,  6 Feb 2026 13:25:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14FA6B0092; Fri,  6 Feb 2026 13:25:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C207C6B0093; Fri,  6 Feb 2026 13:25:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFBA46B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:25:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C195D5939
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:25:25 +0000 (UTC)
X-FDA: 84414859410.16.1BDF1CB
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5C5E7160004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:25:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="PS/gTBrT";
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770402323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BdnMiZ5cC/+cpP7NJPnxAZV1j/p6+4QF4w+4P2BOE04=;
	b=KfCHOxMmqg1k7aktNM86GHAjZ9ntC4U/yEUdhyi0AQ4qKhB5tihlCXDTI5+mQV3AruZkuq
	aTgrbnWiaQ+uH3m7GAC1+cIP3VKnNYxaWV7AEbe4sYTW8yRWuHjKHM/01+10k151sdJiZZ
	wb/fsPxJg2/ParVV7bsE0v+KKVrcGdI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="PS/gTBrT";
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770402323; a=rsa-sha256;
	cv=pass;
	b=RE5/cLmA9UmAgtGiar6Kf5Ak5XZCyMjH6ChNY9ZmTGnnVxpzN7E47DzXbmKAtuj2AubCPt
	aocshHl2HmIY/TUELFXG5kYpeO88nnuZr+KgVWD0M9/JXjlQbM3+vDBkMiRHlSPfiPZXh+
	3g1KbHefVstdjOR0WAwWcgNyUopld10=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b88593aa4dcso337287466b.3
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 10:25:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770402322; cv=none;
        d=google.com; s=arc-20240605;
        b=IuUc+Fv4YfAOD7nB7PdqR94LggT+8JhXEpJfC3aIjtGdpCxrHP0qIBe1TsWo4qkqGV
         RrVuRDRMZN0lIYErzWrQsjdUSSQE9U1NaP8x1t0Nk2mPThFoAfUSXegMZ6ndL3pGy1qQ
         xYubrDZ432vrbllDzJjy7EYuT4sxiqgxW+iHD6q4alfi7bjl8S15h71v+1cgGLOswAJV
         1DAoj3nGezgx3xdoIcf0GYxJGjqX9+AqzS8eZZkFQvJhZbtaPKFlIgoqypqrIcKm4fSu
         BUBxPmj+ozIb873cKySKTUz/jHI3RjPxfhDjIWFNrOp0W2hzy3r0fElzYROcD7m7tRzp
         z7og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BdnMiZ5cC/+cpP7NJPnxAZV1j/p6+4QF4w+4P2BOE04=;
        fh=xxS/sQ97ZUkgZpV6FNbODEukbXRhh/r/SzDNegKi8Uk=;
        b=lJFAISw0KH31pk3fK+nDWszC3WncZ0bqdRiSiu7QTxyIqBNesZLBEVJtIlcQ79kC4h
         uOBpTb8KzPgD4gcrU7OI6O6HPoWr3L/FBvsn3OFvWHXwNBWMqESCdnlKr+mTrX6ZzJpJ
         hRegjAdjyY+M3g4s+/adQb7HCjQpkrAmkzWlUTYkjgS5dOBHrwEqcEXLHFy/kn2Gbk7s
         V8D+HsmSDZafqJdtNwVrDtSvOfYj1kZEOCYvVlOD65/+MceRRG5nBq1yeyzUXpE0Cx53
         clrlmrpNGbE+Hilh6tr+cbQiH7sBCMy1jaH/jIH75gmLwuS7FRStRQsk9vrtbgSiWpB9
         UzjQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770402322; x=1771007122; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BdnMiZ5cC/+cpP7NJPnxAZV1j/p6+4QF4w+4P2BOE04=;
        b=PS/gTBrTBZqHWfIAS+54QyJ/5skngA7gAdRBbjlIGV9dqT/EyMOKukYKlp6pgPMp1p
         BMbdhicnvdrch7jYtiGIcPF7wDW/qNo5StvWT6bx/tarAqQs2pmYwhz+uVzrgPyabbl3
         1q/AyzJazNTNOZgsgeNmtCUqJ+IvM0F/IFEJmJa3eyL9l3TSGsS8f8UDyCrksJB0Uk5k
         20dvl/NfIIY6C69+X4h7zVDwTHkAs36D7Zge3p7HMaQhSGI0LRpmZEtx1DXAyUGAGgfP
         HBa60cRP1L2DDs/7lQoXUoGxEw1ZmlArNc26R40/acqWOJWhOThKPEwtLGBVRAASI9Q5
         iexQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770402322; x=1771007122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BdnMiZ5cC/+cpP7NJPnxAZV1j/p6+4QF4w+4P2BOE04=;
        b=fjz883yOHrQV6KQad21LkimCpkmyJofyeBt4RMXZXy+2I4NtxclWneZWDW864QqWDo
         bgpKgPWiMUY8JOYz6VvT40cdqvWhBY+KrdkekIoveux+rQzytpnmQwjJYXcIUQRZvkiX
         s/OUMexzmiL+66aJXI7TTtoU1QlFD8vemhmtaBTJjmJy63ykuzUAps4s2r6rsBYL2bSV
         lxy/6go2LOdH7pQuBTG7Au4uRkvc6mTnOGV+P5NEdAxJnoQZFI8iFIBhlcTOsDi4GuYm
         y0rFiRdb0EnBthAr0OLZ8U0/LbBh46oim3BYLaQ9S6X2Q2RMtLimHd4i7AQpGB6GB9+L
         /61A==
X-Forwarded-Encrypted: i=1; AJvYcCX+tTCieef7EmsU80b8vbLZdffMVxNFl8rsYxtrFSWGXF0b0LSQuI02MX8NVOippldjtIp8hyc2Jg==@kvack.org
X-Gm-Message-State: AOJu0YyL8GknIRqmbmy+Pf2VOWfKQ5mvgyp7ObMvnr30486AP6Ep4Yw4
	OeX7r2IlUajFGNkkcZzT4HsE8ufkG5nwTrJ/W6BVaLSOtMxXBPxkFdxp+CLNZw31jiLPtXdIMCi
	bXWlVLByLJgXSiw+ep3w4mF8paz10pjs=
X-Gm-Gg: AZuq6aJNVHoPfqM1YIkcIKp++z+xHibFfXgKc0QaC45KNGzFCJ0j/mUuYcx2Kn7+DAq
	eVV4qCqta5Z+UjLR2HqBfuE+mRNuQmHU7wSJN7EnOyUHM25OnGZllzcwz3vwq1c0zIRmD9wR+1y
	HEY43I0H1gsJHKKiQMxwkJEVV5IKghlfRKuN9v4AFPbdMrpASW8yLIGAuAQYxBwXHofUZCMgIjy
	N7vghWzRQZ8EnEerjn0G4SmWUya6pz79OCJmPRJ4liHCf/Z0KbszD9KThkL9uJy5RdxaGHPdE1L
	cBfBmaMHWPsiH9mx0GqRlK2KXbZU
X-Received: by 2002:a17:906:4785:b0:b8e:9d66:f5fb with SMTP id
 a640c23a62f3a-b8eded5bf07mr212607366b.0.1770402321350; Fri, 06 Feb 2026
 10:25:21 -0800 (PST)
MIME-Version: 1.0
References: <CABXGCs03XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ3PwP0mGXA@mail.gmail.com>
 <20260206174017.128673-1-mikhail.v.gavrilov@gmail.com> <3BB6BA1D-3756-4FC6-B00D-79DF49D75C51@nvidia.com>
In-Reply-To: <3BB6BA1D-3756-4FC6-B00D-79DF49D75C51@nvidia.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 7 Feb 2026 02:24:45 +0800
X-Gm-Features: AZwV_Qj9ArkpXSETCK1paJ36vy4F_CRQBBxAfzS6Lq5DExmenMFaALVelzse_U8
Message-ID: <CAMgjq7CMBXrPKHC0Ni-76C=Cep1emQ71mMjhoAZ1BrkahWzLwA@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: clear page->private in split_page() for
 tail pages
To: Zi Yan <ziy@nvidia.com>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, vbabka@suse.cz, chrisl@kernel.org, 
	hughd@google.com, stable@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, surenb@google.com, Matthew Wilcox <willy@infradead.org>, 
	mhocko@suse.com, hannes@cmpxchg.org, jackmanb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 1w61iu64fib77q9zecxqdxprjm9mahmg
X-Rspamd-Queue-Id: 5C5E7160004
X-Rspam-User: 
X-HE-Tag: 1770402323-231544
X-HE-Meta: U2FsdGVkX1/nvq+nSRoqGX4l27OGzHWbH0bQI5hGB8xx51MHOdkoDdjfWxcmLFrFEjJZincpTNWhzJS9EvwWlFXN7d5wJiuyLQUJrQU7YrE7nWVXkEl0jfeCxsP1ieMk1TWEcsOu/1GqmBiuappyraX7i/Y3R+sHQ7jEaUTT/z0x7QYdI+pxrURvYRJcPROfHjwjw2xMFVWqgo7ArFKHvvImo/WceWxO9OMOnk5tEPfdGQAdPMKwuHmAC8ymJLiMXqgnHsSd9HX2/W1l2sF/Ud1BSbqtBle6Tqn5KoM7h90W7LFX0SiyiG4Hm3V3fv2E2gYywzFKq9ssfxnKMqNrwJ8dJ4fsccQLInMWvG59LuNtM/cFO9RLDj5wt7c4ZQEcSw3oOR1W5CB53VtWn46eV4NUxirZ1EUA57pktg/qFHVyCAsxf/LU6j7BK+fRrIeT19xkDxJwu0QMwvfd2p4pSskoLUIeOUn36UpyqKNDAeJsdp+5PFq0CTgQxQu+MhLsXWgZpiaATjlNMKhfdJUC1+9DTk716EcoPsOujpNNwO76McAjhnyu0R0fRDQ5OiZR9aHppVTJt+dj51+KeccGYajKnQplNeTJQhO6bqzSN6oKAbzOMO0TQkZzQf7tBPSGF4G+khjW1t2Cj8WGV4Tt1t0ovaohGp3uSLXRiLZWZUgdBsPc7XS/7qZ78Vf8Vas10s9Y6jbUaPu5lhMUns93AzzK5KAhxc6LJfPWpSlpQLEC5U0avT8GeOJRZLC/a2QrNRuZIQkckSpamFqhC8hgrgDCyzarNCjfK8YK9X8Um9vbVqukFtWzCajTqbCfTPRYEp/ZEIvC1u1aou46C57LC/ocrx7rrx/MaDOqUcKm+9TiSeY0M2WOsOnjIJY8WektFDKptYXKP1XwWS/yEtdhsx86GhKl8nn+8s9hbX3a6bjZEL7An5V12G84XCGOViDgdkxyPQwKOwdOxgJawXA
 Ya6WUL/a
 Two04PzzNhyVXCBmyW+XN/BaMos8fX3ES2J4R41E5P+knyPOYLPL3nz+BV+g3xesF61vRTHs1o0WHDmd+IYC4BYG4DD5ds6wSDkauQ+gf0IQkEVnUVcle3FdQq3q3ax4XQXupVaEj/0WGJgKqY6ECQlCbprcn3xwYgxiA0Fjt54OJ7KUj4eUuZ9f8Rb81EPkA6fYPfuB8jbbJHk/vwnTc0GK3GeigN7uGe4sY+Q9q0U0eUTqhZs6PYyhLcT9YR3HwpTYf8tQ7MNeAUAT+wGyfAYGB4nz4WevdYpmUz+SHP5OZPb/XvNBLdbpWupRBNWSn4po7iYYJJbFaJJgnPxrBSihZOWqzFxRhx+Btetd9qvcrPKDTqnD55+i4x+9bS8L3X2ICLRU+aNCeVCAp2e3NzznboG3JXsiyxPfzcg3S74LJONvie0bYe1QrqFCj7+Z13zdNiFY+R+UgEGR5+v1vATjoaVxkJhItnWmRK5TGr8Low1WENhy/yeu0UkXXfatCe3xUFYQQIDRZ3aLr7YTgqdTEBUpAOZpNVCe64eQlgsZpvneF+mnFjDVv6YEw+Hx3MOggDV1GdcZ1wkMIkZB0ymA3IczouOXx2fsW+3oFRpMkZ2VsxmefwAeLHImNLc9zglP/t0p69ihxXxtMaFcUbeRpjFAtyGtOIAmWTPVjyozoS8Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 7, 2026 at 2:08=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> +willy, david, and others included in Andrew=E2=80=99s mm-commit email.
>
> On 6 Feb 2026, at 12:40, Mikhail Gavrilov wrote:
>
> > When vmalloc allocates high-order pages and splits them via split_page(=
),
> > tail pages may retain stale page->private values from previous use by t=
he
> > buddy allocator.
>
> Do you have a reproducer for this issue? Last time I checked page->privat=
e

This patch is from previous discussion:
https://lore.kernel.org/linux-mm/CABXGCsO3XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ=
3PwP0mGXA@mail.gmail.com/

> usage, I find users clears ->private before free a page. I wonder which o=
ne
> I was missing. The comment above page_private() does say ->private can
> be used on tail pages. If pages are freed with non-zero private in
> tail pages, we need to either correct the violating user or clear
> all pages ->private in post_alloc_hook() in addition to the head one.
> Clearing ->private in split_page() looks like a hack instead of a fix.

It looks odd to me too. That bug starts with vmalloc dropping
__GFP_COMP in commit 3b8000ae185c, because with __GFP_COMP, the
allocator does clean the ->private of tail pages on allocation with
prep_compound_page. Without __GFP_COMP, these ->private fields are
left as it is.

