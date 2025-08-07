Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD3DC87FD2
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 18:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73CB56B00BC; Thu,  7 Aug 2025 14:10:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C4F16B00CF; Thu,  7 Aug 2025 14:10:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58CA86B00D0; Thu,  7 Aug 2025 14:10:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 44A256B00BC
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:10:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C37BC116E46
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:10:11 +0000 (UTC)
X-FDA: 83750750622.10.98C9FDA
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id D9D54180012
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:10:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I2ZUT9LQ;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754590210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=undqdjb7Cj5qXyTPAeQEDrcBeJD8DH+zyfxYBBjDJpk=;
	b=zH05g1eqNhUG0TTQx8MUsr5hQLB+wYaXixp+RarRvhzTIN0C6FTCk2mXY1R6L0KEXsSrWK
	2CEAVxO+/mvTgcVDYqlNClkB0OmaWLiAThdaBazgqFLyCrTqyeCzPQdUPDQ+sAVivnUBo8
	cTy2C4sfzS6YHqCqNLU5VFfvXcP7s04=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754590210; a=rsa-sha256;
	cv=none;
	b=4CjyVqHiGoqObfSKWbAxn20Tym4PyvMMv7DkkI6a+kv4VhKgN8XW4uvcIEMo1kf4U5qTHM
	xijCqelYhwp7ZsTlXL8iA33z9XpFLpRFuSL9lKincZViIXnP/ZqsE4gN+1/GIWHxDH4E+w
	0RuaxKZ9SSp+VrABCjqW+kiuCbGDF+I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I2ZUT9LQ;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-55b847a061dso2680698e87.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 11:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754590208; x=1755195008; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=undqdjb7Cj5qXyTPAeQEDrcBeJD8DH+zyfxYBBjDJpk=;
        b=I2ZUT9LQM6QjNg8+1xFkKxtuiP3v1u0L7GhxUvUGAbDm/EfICWgWEbFUl83zYsNlBZ
         sV0zxf3ZFGIRpCmk+ZWQrk0Hx6HJw3BGhYhI1DQPg9Mfi/aV4A6u5rYdQathDgllVN9Z
         Lq3nleh35YkL9PRSeGLBWDyE5xrXJdNzaRW+sJIeoev6Q5+N+nZCCVILEWX/4YLPmDJG
         kQ+ecwnz/MsTPSC9dnyWm78E+Krd/3MIuxJV5AosiXDnK63kE4gIj9iK1p1ImMTCrPVW
         1pDJRdModjb83NOhamJJElXrATatycgcV9PmpJQcwd5nRjGkekDqt5phFUW0pUgqMtOM
         J7ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754590208; x=1755195008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=undqdjb7Cj5qXyTPAeQEDrcBeJD8DH+zyfxYBBjDJpk=;
        b=em4IJBQHCJ+EI/MuaGjgogqqjOBbpk1TavbLn413slRbq3Qk2x+uCqkcTOMK3jTag8
         wpi6Oph4CTP2t6e/q0Be0KzQMXurre/qlXoknZ1kAec5Mn1ftj3M37zWclS6PSMcyYWM
         NkHhU1hmnABrd8Of7CEZxXqDodgs5DAY8EUGEWsvzFXmM+cftd8wtnhLzEFizXIAzJ6/
         Fa5IhCXsZhKARf9Qh9tqij0IqaB9149S8P6UO8AeABeYuhU9b6wZSv+IN8s02514vsrg
         iszkhzSYHWbuDXBBZOX7I8m8gfwf+utKbXSjQKXXWMHoN95litFScgBhwwY8zXBU/Lqv
         AAvg==
X-Gm-Message-State: AOJu0YyOaHLanP/0ScZeNFee5gc9oJm/txLueM6VsRZZ/Lztvw040WJI
	7BjzBVoZ+hhqxwCGDOs8l8hpp4kCC6skz5EUM9giaeNc2GrXaaXo+H08I99StwJGS2P/bMjO06d
	D1jO0mxE8j1vBPtpa0HNAchs53suQO7Y=
X-Gm-Gg: ASbGncsx5e9Ox7ZnbqE0cmdVgZGwhwlWc4gEBjzK6pUlEWBVQHr2zcu90rKlxvT2rWl
	+JTLI5B1OZQFc/Dy45uZkncL2QyQh9r/jgD1jgHhzt6S/kfVsVoOEX2e+Nglc7Kvz44kO123R90
	A0Hm2i4WBrnYVY5uddaONp+/5LorSsEVb7n+zXazZCm45wo/VM2NuGFFVFdfRqfA8M0DHxjKho+
	z0RH+A=
X-Google-Smtp-Source: AGHT+IFj26gAarF9lEJMiYhzLFQXeXYoZ/3YXgwEb2CQdUVeYAJ3voVdP6ox7aC7qY1raCNksDYU8dJse4iGH7bKs0o=
X-Received: by 2002:a05:6512:239c:b0:556:fb24:6f85 with SMTP id
 2adb3069b0e04-55cb61e220cmr1442281e87.22.1754590207592; Thu, 07 Aug 2025
 11:10:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250807152720.62032-1-ryncsn@gmail.com> <20250807152720.62032-4-ryncsn@gmail.com>
 <CAG48ez114_bmuca2UL-g0ZY76-VqhL-4rQtJM_k0N2NJXE4vdg@mail.gmail.com>
 <CAMgjq7BhfGC7jVHQ62wAJBfTKCDG2+VdgpjiZ7hjxXeC5fHg-w@mail.gmail.com> <CAG48ez0O-Ro9-x1LZ8QdijMk57j1D2jWf3MR7F6AiDP7Wq1p_w@mail.gmail.com>
In-Reply-To: <CAG48ez0O-Ro9-x1LZ8QdijMk57j1D2jWf3MR7F6AiDP7Wq1p_w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 8 Aug 2025 02:09:31 +0800
X-Gm-Features: Ac12FXzZmSlM9Lu3wRnHAzlk8tqAltT0Tp_y8BAOl3P0HBRgteVJt8NuwhYJOpU
Message-ID: <CAMgjq7Aosd20rpFa8thPaGQ9dL-qLeq6Ki7S0H0VirQy5rh=Kw@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] mm/mincore: avoid touching the PTL
To: Jann Horn <jannh@google.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, David Hildenbrand <david@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D9D54180012
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ioxwhxdmiuwrauo6ygb7p39myb7faewx
X-HE-Tag: 1754590209-252705
X-HE-Meta: U2FsdGVkX1/udHBPCaXiyY+dBaAADgeP/s21M5QpHpE1J9IBCZsgjXwdqrJLTp/9L/5UQzthgXyQMFo6xgnVrbLvCPEQcsZ/S4QhrIkTo0aJwPZhZHbg6QQ6kPaBw0psdkPi+dX6/nyMJr4sIt/IGVuflXsX4BNbKcvP/cNRxVdzUHVoHiau77uQEytoR4k3oI0f5K555pNyOL9MeQphyi8w8y3rI6Muc39XqtPPiIRznryZFu/9pBn+gWpwc/Uo5O89TGGf50ObHoOlBsR6GT/RvoVS7UviRKcCN5xfe23WFbPFZ1Xrl36rc64i7vDRF5IlhF3Drw42nmRs8rOd9Ik1YmViEYj1g05plAGDDa7qq4xGotnNo7SWvJzynwxgp86InDpg4ZY0FVestIiAdOGjCfxpqpWCFMgeLuPI0OWimuBqwjUFNFItD04z6CbtBjEGCnZOFhLV9jqwGbR9ATvGaHKkm/QmCFBzohaPTb/YU0mHS/zlLAo8mdYHp66qMrJJlBEZSBMI0mIxSWWm4QN4nKjkXRhOfiFkkiAklGXYP8xtr8UWw6P2x5xWlP18LIc7G7mZl0Yd/njQDZaDKjLCuwgQ2ZXvIhcIZ8ja38GedbaXp9ofEGKscXlnOvAWu9G/dJ4/7QHmBVpqzvRcAkcmYOI5j0+nDv4fPt0YQJgJUsuFDcYdLTDLDrzIaTR7bl0JhTVfy1+szL1sP7sKyXrLL9MlE8UjUdC8KqVJ/X6HVDqyIdbO0uB6OAw0eSUThIcoj6SJEjT0BbwAr8A1AEg+9hpiEIMjqiHDrrDoZDwRv/dHDtQObwBZi/euEmVTx77kMXgfcEhLgkQBRq/bOWIqwCHRIqDo1tCrPWXA5uhrD5x+oZIfs5/5aqianLRIPvxvKQR1IbnTeCAAWIG6sO9tGspCe3ncOZVmh9rLp9eKd8Vvzws92JKKo2Kdn3Yoh9y/TxB/wUp0/4sesv/
 WIbA0hWu
 62iRea9ULSj7m2q4AnzL5J2kWxjkEkJ4KWkXzRr+FhJjVBAxAPKttev5RLPICMiU89tSOc01wBaWETeRMwt6/aRF94yAIR65TcS9kCbjKLQsEsQj4bjcAJRhCDx/TYPfkrgaQHV/5b1t8Sdh6Y/wIdFQ+JjhEtiiUP69WqqH064TPy62cVWSohCzWgZ+gtNsS8w0isxaXny2GWHm9Cmfqg06kj6FvbH4e9KzRISImjmXpmMGUYRXtMZVQsH4G6+HRGMi5tNjxT7PI100URgdi+2IQK/AfcmkBskiBTBgbE1WNY8vj8OOuULBxYJopBQ32JdpQaqNPx7tQ10uC9bIa9i5DtynefAuoSTMz/K/ZJtccuxbuLL3O05vfG9wOM5QBSzLGtXbhraPajRFfDigAEEPNpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 1:45=E2=80=AFAM Jann Horn <jannh@google.com> wrote:
> On Thu, Aug 7, 2025 at 7:28=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
> > On Fri, Aug 8, 2025 at 12:06=E2=80=AFAM Jann Horn <jannh@google.com> wr=
ote:
> > >
> > > On Thu, Aug 7, 2025 at 5:27=E2=80=AFPM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > > > mincore only interested in the existence of a page, which is a
> > > > changing state by nature, locking and making it stable is not neede=
d.
> > > > And now neither mincore_page or mincore_swap requires PTL, this PTL
> > > > locking can be dropped.
> > >
> > > This means you can race such that you end up looking at an unrelated
> > > page of another process, right?
> >
> > I was thinking If the PTE is gone, it will make mincore go check the
> > page cache, but even if we hold the PTL here, the next mincore call
> > (if called soon enough) could check the page cache using the same
> > address. And it never checks any actual page if the PTE is not none.
> >
> > Perhaps you mean that it's now doing the page / swap cache lookup
> > without holding PTL so if the PTE changed, then the lookup could be
> > using an invalidated index, and may find an unrelated page.
>
> Yes, that's what I meant.
>
> > A changing PTE also means the mincore return value is changing, and if
> > called earlier or later by a little bit, the result of that address
> > could be opposite, and mincore only checks if the page existed,
> > it's hard to say the returned value is a false positive / negative?
> >
> > Or could this introduce a new security issue?
>
> I don't have specific security concerns here; but this is a change
> that trades accuracy and simplicity for performance.
>
> > > And your patch intentionally allows that to happen in order to make m=
incore() faster?
> >
> > When doing a clean up (patch 1) I noticed and didn't understand why we
> > need a PTL here. It will no longer block others and go faster as we
> > remove one lock, I can drop this one if we are not comfortable with
> > it.
>
> If you had a specific performance concern here, I think we could
> consider changing this, but in my view it would sort of be breaking
> the locking rules (by using a swap index that is not guaranteed to be
> kept alive) and would need an explanatory comment explaining the
> tradeoff.

Thanks for the explanation.

From the swap side, get_swap_device also ensures the offset is still
in the valid lookup range so the worst thing is a very rare inaccurate
value.
PTE change will mean the page is being swapped in/out or zapped, so if
the mincore is called by like a jitter earlier / later, the result
changes. So I thought it hard to define the accuracy in such a case
considering the timing.

>
> Since you only wrote the patch because you thought the lock was
> unnecessary, I'd prefer it if you drop this patch.

Understandable, I can update and keep patch 1 and 2, which improves
the performance and clean it up without causing any potential accuracy
issues.

