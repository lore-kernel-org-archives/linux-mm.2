Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26291EE4992
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 18:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619776B0088; Tue, 30 Dec 2025 13:22:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59CD56B0089; Tue, 30 Dec 2025 13:22:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47F036B008A; Tue, 30 Dec 2025 13:22:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 378E06B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:22:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CEC011602A5
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 18:22:11 +0000 (UTC)
X-FDA: 84276956862.01.B02F3EE
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id C7988C0004
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 18:22:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Edy924B9;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767118930; a=rsa-sha256;
	cv=none;
	b=i1ouCCvdVjye0dB4b6+QONkVgXPp47xWYrYywL44g6KowPaH2PrvsjsleSNn9UGdSmA+Zp
	WwbgdyLj5YKLbvCl1qFVwLoH/m04PgsMh0oBp8txi9v+5nTeJZTKEp5LXbZbr0iJoDCn9E
	tZs59BmEyQeqin5epEF7Yl0BC9l68TI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Edy924B9;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767118930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SbX4+3prQedbYohaWCzcG8i2LaKGHYsnZgkzeM93RSw=;
	b=2mPwEo6fhZFTYI4KFxfW1/q/3IhT8FsdwPpvjUXYJlj7bJCGIwXUYqaUlx/KlOUJcKYAHp
	bLIV9DEJJSisdPleFZbAu6XjS53hsYK/vTglzTSZEV1TKww++JMa4HNcUONHSYY5LrJgJ/
	6YRCftiHZ8ge1oLbbfaMdpHYs5UN6/U=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b7a02592efaso1552720566b.1
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 10:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1767118928; x=1767723728; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SbX4+3prQedbYohaWCzcG8i2LaKGHYsnZgkzeM93RSw=;
        b=Edy924B9pn1hoJjzHeWO6Hc0XouqN2YT0idnk8wEJRZOdMY/l6cJaHHAm2iXJdi5ix
         6nBSYJuXBP4PlcjTAxWzSPaz3BNc+Ik+l2YISzWGHTSQotqKOuqny+E1qavytIQUckmT
         UdbUa68Ve3sGmSW9PwcnB7GO2go+oNwWr5cSOrCEIXSCmtbIAbikAakeR64p66SHlqaK
         ZQgea5OOrV2RrF75aPWHOtCp6NlcumvUaw+UvS81g+CaJTYFWklcqOug1Ji2wyth36vT
         1R9e0Vd+OZBQzAltf9Tkc8rewCw5N+Pt0ieL5dZtFfPA/pvGnzpVWpgeMH+WyXQf1zRd
         XD+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767118928; x=1767723728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SbX4+3prQedbYohaWCzcG8i2LaKGHYsnZgkzeM93RSw=;
        b=MH1C5P85jS6VmU1xSCoqBD/Q09y4pxzndjPL+SwIAa1+qhEYnpLZNWu1DHj2Rm6Gwb
         5+8dcrsdsOUADmcjHdEHeza00ILB8gePuNc1ifSHL3sjCaFUu9ygGfAigUv36Wuk5j/U
         nZWRu/nPxhTgfBvEsX4oGfiK53DYnc3eKqULRJt3cbJBFcyMF0rFU8lWjqYdiWEVp8Pl
         vKVSw+kFW4JZqlfrIxYLsEb9W8G58Qd96vGsRg4kLRVWdpeHyX0zvgUxKVXuiFPTcFLu
         sG2OjjFv3S5GH6z7Y+28Rbxp8p3KafYsdpu0plKmB/Trq2TMMYWmo0M+SSTnv+1UdVXK
         nfng==
X-Forwarded-Encrypted: i=1; AJvYcCVtYgI9ntrWXUBj/3oog+XdBcEbM7J+uCB7Lde+HuyeOOz+eWN2jsJMIjhymcV/oycMzUENUsq6kQ==@kvack.org
X-Gm-Message-State: AOJu0YzyjT6TMmCN7lyBdLIUE0pcul3egpGpnFCrZaZr18uXj49NTSrK
	W1Y53Bx3yt7lYq0H+RXxBbOVLhO1kH5kdTWJzmb4lHsYu972BKrI2k5ZaVpNT3TmeZSUrd4up6Y
	hnhNAmXcr80EMSBW2br949WehA6hFP1LhE2np5u+Ccw==
X-Gm-Gg: AY/fxX78JefmwlobwUz7z+qGmFJ3ZuDJKkSRp9JkTcVf1diNKy9tLGrqO7Pt4fTZKLx
	mh9pcR69fNXjHmPKhAJ1WEAbR5I+RI7qdpDHVJn8mt55hwYKWkdPi48+BWSp6mbeuT6PNYgFAsZ
	NhiXstlW8dq5VuPlla4f5XI2XmYEIiBMra/dwIgSl1rezAS5szSswbLoiB7gN6yDxEzOvRhR5mb
	Mjd9sM62hVB14i8qaJYTB76pt0RY48liBlHYWR2f2Olt1GLGkOJxtYYKf6r2uIxTrCu9oS2OnPD
	X5VZWz4F8D/sqJeyH6dTbqIG51HakHsmMMyd
X-Google-Smtp-Source: AGHT+IE+NvY3nTwJty4csE57PDC23CsYYgYnBf8uXu6yTmkVwhlkaOlD6ryEaJ7e/qlHwQjSX1HDyhcouW9OYEj26Qo=
X-Received: by 2002:a17:907:28d6:b0:b83:1344:4872 with SMTP id
 a640c23a62f3a-b8313444da9mr1518310166b.32.1767118927990; Tue, 30 Dec 2025
 10:22:07 -0800 (PST)
MIME-Version: 1.0
References: <861pkpkffh.fsf@kernel.org> <CA+CK2bA1kYCf0BwhX3Sg9Ur82nK-7HPzs0sg6xbVWFAJaZLhpw@mail.gmail.com>
 <86jyyecyzh.fsf@kernel.org> <CA+CK2bDxnTEe9Ohq5zLuyF-jqgD0DPhfdq6z=yztUsXU5p5fSQ@mail.gmail.com>
 <863452cwns.fsf@kernel.org> <CA+CK2bCjJWZG_rPoPsHWSxirmUCTOuFQzTCss2AKf9UqpThrdw@mail.gmail.com>
 <864ip99f1a.fsf@kernel.org> <CA+CK2bDDEZ5a+LJNDVMtKFtQ1D9rP6rJqU064eoru=a9eHpaAQ@mail.gmail.com>
 <aVP6wBYoHJQsplIl@kernel.org> <CA+CK2bDZPwYpUhksDLSbfVdVm5TYbh0XrOKRV=q4YjGpqH+Fwg@mail.gmail.com>
 <aVQJUPOn85WlJaM9@kernel.org>
In-Reply-To: <aVQJUPOn85WlJaM9@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 30 Dec 2025 13:21:31 -0500
X-Gm-Features: AQt7F2qfaFW5jYlhg6zDjPkXHhj6hFsRttMeIx54YfGgD6WpInICzEQbwDgmzGw
Message-ID: <CA+CK2bCm=AGDSLTbs6etbqveFUHU80okE-bCT2zg20nrHXgHRQ@mail.gmail.com>
Subject: Re: [PATCH] kho: add support for deferred struct page init
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, Evangelos Petrongonas <epetron@amazon.de>, 
	Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C7988C0004
X-Stat-Signature: 7jkeym1155qduwp5xqcjs9zmszjp8ub9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767118929-80646
X-HE-Meta: U2FsdGVkX1+gxeW9ZsnNOV+9BzF4tR3blq6EllVKC47HOMRsZzMQXHdwxkrCXH6JJHS5HNTia8vu/OmuJaaYr9jN/72WMxwTYkBTsAofmYeeMAn7ZPb+p9bRvSWHXgkWnlWjhx8jr+ReLRfwBd6sZywNZzj6TKgx92zXVhNum4a/cuGKu9sj92NqYF6h/fLufC05v96XJkyp4hI0A+0ololTDbA/jloxl9JNySJd8MifRHJncW8F7F9eAJoc3wVVqryWIpL+ZFA1U70+hlxF9B5/Fh1j/PjNI4ui9+T18oNcoKwKAoCyDw+wYHNZtWgIxDJz++2DR8cuE12mcaInLzaLMvzwgNGwPpeoJiyceYlQoAWBTq3ZUSTpIq35Pc3XrjxibuhplXCxL+xj7wnMoaR77pspAIQcaLUFoewqaCz43CWv/Q5xUvXsIWyATRVGBd45TH2zFXHkPPe0AdB9yjFFGMaMmlg0evpjF79drSFEHvy1yoCrNdW4fscEU9Ysgs+QcpqNOD0h4mvoXXNKpbX4MQRNOqB/cNSjKyhkeTsrfLE/Vf+cgHe73gkHZy/zzU43S0WUvWahUEXG1HMzj5hdSyWzSj1A2elZ7kM1bmQSpnzwwTIRE83m8RxvCJYGqMkqENjyyGzgELaY+JqyoantKflTG56EryYDOVbkGozzYNYj7GbWTISJVCmvrrIDfY2BcyDLvh+KMJC04e9e633JT1q0eYS6sDl+dkKoFOMkXFQvyw+5o+46D+Tcji9bF9ImMdQsP0+xpIHBF4JhSldZbcBZqs5sl16nNa7ujRQZdqEG5QhRLs6k9Z74FuvxbaREi0NmYCkwu91LifJyUn/Irix5zBoWGg4lzYXtqFWhfuzUhHSXV7s/tqBGhlOh+kl4pxm//8/KyJyk4q3nvH32+3ReF4PQy3jnpuAs3f1C+s4u7oWf/s9n52/nUy35od6MT/o4CbtF9iA9B+R
 mTb+PvUI
 LV6EyfxtM5az1z/qrb9DKVswbWQ46H13VlBgTaGuhev9WbJqAvHlRWx7pu/FxiQD4sligm+n4IzUKqcOOzXANCBFkaj6SJApXeZS9sN27PXywX8eKHAwcD8zYTSIcwUrJo4wiW3mXfufmArZgupY4X/qEHqsslOLJSST/kaQnfBtLISHV9zmKlNU94y8bc+8OCyOyt196ZRiw5KRBHVNHJDg9/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 12:18=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Tue, Dec 30, 2025 at 11:18:12AM -0500, Pasha Tatashin wrote:
> > On Tue, Dec 30, 2025 at 11:16=E2=80=AFAM Mike Rapoport <rppt@kernel.org=
> wrote:
> > >
> > > On Tue, Dec 30, 2025 at 11:05:05AM -0500, Pasha Tatashin wrote:
> > > > On Mon, Dec 29, 2025 at 4:03=E2=80=AFPM Pratyush Yadav <pratyush@ke=
rnel.org> wrote:
> > > > >
> > > > > The magic is purely sanity checking. It is not used to decide any=
thing
> > > > > other than to make sure this is actually a KHO page. I don't inte=
nd to
> > > > > change that. My point is, if we make sure the KHO pages are prope=
rly
> > > > > initialized during MM init, then restoring can actually be a very=
 cheap
> > > > > operation, where you only do the sanity checking. You can even pu=
t the
> > > > > magic check behind CONFIG_KEXEC_HANDOVER_DEBUG if you want, but I=
 think
> > > > > it is useful enough to keep in production systems too.
> > > >
> > > > It is part of a critical hotpath during blackout, should really be
> > > > behind CONFIG_KEXEC_HANDOVER_DEBUG
> > >
> > > Do you have the numbers? ;-)
> >
> > The fastest reboot we can achieve is ~0.4s on ARM
>
> I meant the difference between assigning info.magic and skipping it.

It is proportional to the amount of preserved memory. Extra assignment
for each page. In our fleet we have observed IOMMU page tables to be
20G in size. So, let's just assume it is 20G. That is: 20 * 1024^3 /
4096 =3D 5.24 million pages. If we access "struct page" only for the
magic purpose, we fetch full 64-byte cacheline, which is 5.24 million
* 64 bytes =3D 335 M, that is ~13ms with ~25G/s DRAM; and also each TLB
miss will add some latency, 5.2M * 10ns =3D ~50ms. In total we can get
15ms ~ 50ms regression compared to 400ms, that is 4-12%. It will be
less if we also access "struct page" for another reason at the same
time, but still it adds up.

>
> > (shutdown+purgatory+boot), let's not add anything to regress, as every
> > microsecond counts during blackout.
>
> Any added functionality adds cycles, this is inevitable. And neither KHO
> nor LUO are near the completion, so we'll have to add functionality to bo=
th
> of them. And the added functionality should be correct first and foremost=
.
> And magic sanity check seems pretty useful and presumably cheap enough to
> always keep it unless you see a real slowdown because of it.

Magic check is proportional to the amount of preserved memory. It is
not a required functionality, only a sanity checking. I really do not
see a reason to enable it in production. All other sanity struct page,
and pg_flags related sanity checking are usually enabled with
CONFIG_DEBUG_VM, so enabling it only with CONFIG_KEXEC_HANDOVER_DEBUG
is better.

Pasha

>
> > Pasha
>
> --
> Sincerely yours,
> Mike.

