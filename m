Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D150EEFCE24
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07D2B6B0005; Wed,  4 Mar 2026 12:43:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02AC96B0089; Wed,  4 Mar 2026 12:43:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E44F66B008C; Wed,  4 Mar 2026 12:43:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2CD96B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:43:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 82B4213A960
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:43:07 +0000 (UTC)
X-FDA: 84509101614.16.45C4285
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 45ABC80009
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:43:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=NiN1cv9K;
	spf=pass (imf02.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.172 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772646185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfDnuq/vwsoxwKmrzVMGKuFRHrkxLssFX7lmFUDoq00=;
	b=ibjWrPsY//TnD2+TGtoAyKOpY4TdJul6b+GH1ivPtAk+s9ka2u3nwRZTLGGtVydsj8IObX
	DS79Ol0Vv3FfxSGg6vI+J33Fl7zJaZfA0nLFC9mAoPHvE0xKcmzKEW8XiZIg+sIKrb4rN2
	tnE3iwL2oVKVpgk75ScDX4AMmv2nqVM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772646185; a=rsa-sha256;
	cv=none;
	b=Phz963sJbvNXG/Bj+O+OmrPyFr5tbRrlF8sT96x1O2/pl+fgNQP9e1l8foysp9GR8/FwTm
	oz+nT7Kjn/AVCA8izeQnHo3IokP2HoZr08lDteDJxCK0v6NsoWfU4UqbsSD904S/HvIWrT
	3bNdirYjyhnyrKWnwB3RpN/uVqGYRYU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=NiN1cv9K;
	spf=pass (imf02.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.172 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-38a2cc31e20so18438021fa.1
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 09:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1772646178; x=1773250978; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GfDnuq/vwsoxwKmrzVMGKuFRHrkxLssFX7lmFUDoq00=;
        b=NiN1cv9KCVqnqFT7z186Fk1RZDCShi7b5/Ck8X8DEVPXKrA/yVIaQSW9YZW1iC+7wu
         7Dj9HromTbsYWyv2u5vBDWVJpbDZT7hawLvSmR+TUcbaJEkNAawgWIzpsl4Qy7IvoCPQ
         3kC5kKXe+Oft5AgSd6sm0Nt988bw08sTyPDME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772646178; x=1773250978;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GfDnuq/vwsoxwKmrzVMGKuFRHrkxLssFX7lmFUDoq00=;
        b=Xr/bQfzRe/mfqmArKK3KumussXJjYj58PPTS3Ep6jtYfSWdTGwJ++4bG6IS02IakDv
         xgXxATjzAuLWrN2XIemxOrOi9eMm+Wx/rG40XBPV4ECyAXqam5+ad+1OKRErzpO7fyUI
         pGZouo0tquIzhQls8+2myjLTMuegxnfjMb9uqVCIFjY3/aZzBAeIHo7zDSrhOKBR65hX
         JNpo3cOII/XLpR/y6V6ohZGkIbYK9GEeYcq2IKU2aLRZW8OS4xnoiV6JJsDaOXLTTdvJ
         J54YU4P6u98x7dsRPguRhu27VQURwgYCFKkS0iwsuVRWFjjj/lZb/oraPLEaxhmtMfjw
         aukA==
X-Forwarded-Encrypted: i=1; AJvYcCVL69/1tkN0yFmYTRhCjxlUMhaA54KINuHHqDH0ym+jcdvL3IOBgPZpY3bX95TZyqG6VLpNoRYYAA==@kvack.org
X-Gm-Message-State: AOJu0Yx773udHqlZxzXQaeUeyHm0VrvWpgLhETslo3Wwh7kyP55ke1/Y
	XVCoKr+kGUArh+laNTHc+l3CACh6qetDcumm1eRHjddh+jWYwlLp3sTaWacqIQb5feP7i8J0IMr
	drHqqlovKhA==
X-Gm-Gg: ATEYQzxz2kj0ugF64SZpnpJnwdzmNhOyJYGDKbMIWDCD07C+9jew/VM+rYGTjeaUP1T
	MgyHMVtVmFlCt4KMf7U+b3FP+4wWLfP7/Nph0zhVAdKPePzBbjA9DDqRnOD0LRyuS+73H8Z+b7B
	2hUkRRbJkJ2C8W8838IFbJlyPQeFgrLMawkyCOAK17lPjJkcl6pbrzlUBtWLrae/OJcW0lztkSu
	abQNozUNU9eBorkT2/XWu4ScJp081kGKiPTo8f5MN3u3UZxd4JInyPxC248frLfQIe7AFg02hHz
	+yG4q4nIz5/X+2NJRIaTEECDzhMkStOb4AT2kgNJruH2qnW1drc/zc5StMlX6CbaGV4O80GgqnO
	j45TjcQRxqO+GfDPtxSLqrrjeHOC3NtWv7omsZ0on31ICINqIF9D2Z5wl++hb9ymvIjDQz2Pl6l
	now5vVG4BL1aJThW2e6MnjJjfIYSmPc9EWtKhcUlvgPzh67WLnFWu5Y/cm/+vZ509YtBXU0I4dF
	s8=
X-Received: by 2002:a05:651c:110c:b0:386:7cfd:55de with SMTP id 38308e7fff4ca-38a2c57d069mr23353791fa.13.1772646177749;
        Wed, 04 Mar 2026 09:42:57 -0800 (PST)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a12357da2dsm1086616e87.45.2026.03.04.09.42.57
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2026 09:42:57 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-38a26b4d830so32716691fa.2
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 09:42:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVX4448SzbTVV+S4CKszB6smKr1DP8430JNVqDoCY3o2vqPRmgZre1g+7moSycKoYNUdMxJfFuHuw==@kvack.org
X-Received: by 2002:a17:907:96a6:b0:b8e:4790:d7cf with SMTP id
 a640c23a62f3a-b93f15ac294mr177199966b.53.1772645708275; Wed, 04 Mar 2026
 09:35:08 -0800 (PST)
MIME-Version: 1.0
References: <cover.1772120327.git.gladyshev.ilya1@h-partners.com>
 <20260228141941.f6fec687aae9d80a161387f4@linux-foundation.org>
 <CAHk-=wgfs7KqS8pD8F9F9yC8jwSgQtmifytbmmXVfz9xXrQzuw@mail.gmail.com>
 <CAHk-=wgOxtAFf5XeYTcoUHSpWfMrgZaXKc_hrmqt6yKBdr=3Zw@mail.gmail.com>
 <m73zmq6jbdzqmxdjgnmfmd5h4w5a2khur7we3e64r357o32hfj@mvwcqgnuhzqh> <CAHk-=whWnAqw+2YZ=LHs5C6ecGSLqgi+DxtJJ_p06rZsnosVKA@mail.gmail.com>
In-Reply-To: <CAHk-=whWnAqw+2YZ=LHs5C6ecGSLqgi+DxtJJ_p06rZsnosVKA@mail.gmail.com>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Wed, 4 Mar 2026 09:34:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=whc7ne30jPpe=FFECg4OBUAqEqzQUXJ+vdb8NyYDW1anA@mail.gmail.com>
X-Gm-Features: AaiRm53ea_CBAqi2fN_2e9fC9KOu5oZt4YbR1GmGnimt45dHYgrrY0bIJE8Pc3U
Message-ID: <CAHk-=whc7ne30jPpe=FFECg4OBUAqEqzQUXJ+vdb8NyYDW1anA@mail.gmail.com>
Subject: Re: [PATCH 0/1] mm: improve folio refcount scalability
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gladyshev Ilya <gladyshev.ilya1@h-partners.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Gorbunov Ivan <gorbunov.ivan@h-partners.com>, Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kiryl Shutsemau <kirill@shutemov.name>, 
	Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 177bc4shzjb5fdaxwbhfniggqe588w6e
X-Rspam-User: 
X-Rspamd-Queue-Id: 45ABC80009
X-Rspamd-Server: rspam12
X-HE-Tag: 1772646181-3371
X-HE-Meta: U2FsdGVkX19gcZkpSmNZ3K/DHiEFKCgvcv5RcDan9uN4Ez1g10N3etBSTdF0xs8k+aKINVYfmLkmiCPjM0jLSaMokstnb8FEs+8EYyQ/2fShTILOFajLtNBSvaniRgZkq+WqeslV62kY+Jisg9k/+iwXyX3GlVCiyj816m7srHYYet4Qx78moXkBqfPD5felGpeyf6BvubdLJLuETajXutXjaIIcEo2fZD7tiEg5EwdNrSeW2gYVCoiVt1NwmXlReTuyigw5+t10YpKYkRxyFrxgT2Oei42ESo4L2intmjoETZv+xYai7N9aVSnIJmMkZGYvyy2fXD51eEuu+7bDkYgIcOgB1wjIyEwBTLL81lK8w+BKOtHwq7Asgzpl6zJUPc6BehnauWSzVkq9eLv0xqXjfl0GdgSPWHvjy5DMWIleURLjrBeewy5ydUVZ9pQeJ96Yzj4YBW2fNR+ujwEzIjetOm7UiQ8hjiqPVljcmxHxOi4gT0bw34fOoy5ZPfSJ3Yrjhh86tOBDYF00gD/Dy7s6G6rRPWxqcjk7+SE2HsAzfJfTE4MZziIW7hGfMuFB4yQpfMHAtFKd0Cqy9oZJpplFPfnFHxgwnUHHJnv3aDe22F30m7lQdPi7Ix6c5790CafLCIXJLBvNpxrzEeGF6t8D+2aaGaBXZRCVhFhdZdL9j22h3J4/QYcSQQP0ZMDnTbDQszQDX20GJhLoX/sTkG8387bSo5fyh/ISoIQESlFyDCulMN6A2fVQMu73LdE6FuAHnRNjQtOSyOmWY8T1nJr3iTSblI6qE/Pv4cVNPKngU7yLoHPS8YP6bUwjfzx2aUHb/R/58x5Om8onmoKz+rxe/pKlTVG6I1ot5DFObGXfmpDv7ajqFRnTinhMJKdIymhTD9IBwe7ZNyoRABGEnciQOhVrtie/CTcIS0UQqyXTceGOsMdG87zzwxUqATJkCnpVlGXZXcvelod4MeC
 XAZ8OF4B
 kCrblB3pivlMM99VhMMUMRuuu4/zGPEQW7JLP+qpfRi8nXnhgyj90eRm8X6RTjCbwSw+/aTeiPj8IuExxURViLMwqxDTDBL5Y/Xj6ktfnGqc+UeiLyPdCBXMOlTw+2uuvBqfVyJPxtfAfc2pNwPMDvGHi5lMSBFeiP2MPv1/AbKMz+UtmLsebnsbZ1YHgklIelaN/nFTt9zYo+fRBHfm9fuzaYgdPJ5FWs+NeFDb5sf47NweCnQgZwDQ1Q2l/Y/3Um6KvOrp8ptk9VIxE/rDAyigh337OWKQGQ0FRrps2stQnZbmhRowoeR7aqqsL8SbjyR5cF606Bm/tRKslSFT0ByYv+Wlk2c3npsFSRI1Yn1GB1p8RuZ8mXEj3rhP0H80fHiTyI5vHWgaGm3ahSYujx5Xhkk0eXntoETOWqxptz81E9IYkb53SP7jfJbiXAyDzeZCx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 1 Mar 2026 at 13:16, Linus Torvalds
<torvalds@linuxfoundation.org> wrote:
>
> Ho humm. Maybe that "locked" flag is the best we can do.

Coming back to this after having spent a few days mulling it all.

End result: I do think that the locked bit is the right solution, and
you can add my "Acked-by" to the series.

I do have a couple of requests (the ack is not conditional on these,
but having looked at the patch it's what my reactions were):

 (a) please rename "page_ref_add_unless_zero()" and friends, since
that's not what they do any more. Now it is
"page_ref_add_unless_locked()"

 (b) verify and add a comment somewhere that the PAGEREF_LOCKED_BIT on
a free'd folio is never removed until the page ref is set to 1 by the
next allocation by set_pages_refcounted()

I'm asking for that (b) because if it is ever set back to zero, this
all fails, because the fixup for the atomic_add_return() might do a
atomic_dec() - if it never saw the PAGEREF_LOCKED_BIT - and free a
page twice after all.

(And if I missed some reason why (b) isn't true, please holler).

Anyway, I like it. My initial reaction was that it was complicated,
but in the end I think that was just because it was done a bit
differently from what I was used to in how we did the DEAD flag for
dentries, but I think this is actually the better model (*).

                   Linus

(*) For dentries we use that lockref thing which has its own
complications with the spinlock acting as the lock bit for the
refcount, and it uses the cmpxchg loop to synchronize things because
it wants that lock to be absolute. But I think the page count approach
is actually better in being more flexible.

