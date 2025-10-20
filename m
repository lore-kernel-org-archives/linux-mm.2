Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0979BCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9FA8E0007; Mon, 20 Oct 2025 09:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49A698E0002; Mon, 20 Oct 2025 09:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A128E0007; Mon, 20 Oct 2025 09:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 228EB8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:48:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CBCBFC017F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:48:02 +0000 (UTC)
X-FDA: 84018621204.02.2500A80
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id AB7B0140011
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:48:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ciGCDUS8;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760968080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owfB6MZ/RaTOdbtTEnPA/HVBHwSA4OIJrzJG673UzUg=;
	b=qdY1h+NMk0PHi0IKALn7IbkGGa7pawmdJCiOqY7KULeg+OL+yFc+LIgwV0eaQjX0Bg3ez0
	yCc7GE5zlRU4YS2aN0FIV7rTL/Ct1xlPLvquGQcL4eac/+DDSALHvt7WWZM1Fa+ExxfNPa
	px8QEABmCVyMjR2vsSzVLcxHZOWnV5k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ciGCDUS8;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760968080; a=rsa-sha256;
	cv=none;
	b=ccXv2jMXbB+P9NrYwETswoYshdgMtQZDgf8kAlzLsa1aGT5Hed+Kx469ZYTrN98TTlP5q+
	6znBJlPBE4r7CZm5g2qghgKemON8iGq7NFAgZZIclBRZWVmLV2ZGYh1UadCLzMcvaovGMf
	IqYtb4X8tINrX+7gi61LTfr4k823YNE=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63c4b5a1b70so4541479a12.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760968079; x=1761572879; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owfB6MZ/RaTOdbtTEnPA/HVBHwSA4OIJrzJG673UzUg=;
        b=ciGCDUS8bdLArFxKm5IBUUP33pITb5coOnXpx6XOsG4IYhwya+SLOMGmiZ7Swsjucv
         5GG3/M3orIOc+N+NRHISIncB3h9bC9NueNgzIvlsPHGxWwV5CVY6m8Ro6NH7hdu8ipkR
         D1srQITYLczGCeCZKJV86lf0uMiQP5YOM0WuqFoIYbHBY0w1pYzqO+5WKHMW/ktDy/f9
         8njdlrq3J6SuTp1nGWmZzG0hLGWZtcXRUL1fDzD1Dxuyf3Yd6Wi6VeXmH56hsxsvxqcR
         VHPNVi1vj9GvWtyXbrpUyFi///hfxWYCQvX8rb9pQKPQIimbH+31VpgZxY2KJbuP/+n5
         dhZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760968079; x=1761572879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=owfB6MZ/RaTOdbtTEnPA/HVBHwSA4OIJrzJG673UzUg=;
        b=ebPoH0HLgLW44WnxzAzuXvA+9aC2VG7hRC2gm3ppt9Hlfgah1gjpE1RftEAGfaKQDu
         /E+OA3ZCSZTinFJYr6HDVyFdijkg40OJt1l9oPDiX58ld6sCAiErSr65rSLL4QAA3/QQ
         WQ9UejLYt8ImXe1MHSUfGRcNtjvFlTIyfC+8Anv+cPN3mXDpe2jBf1lXIF2VOz3N0kKH
         3O/88nFaZQI2/qGH7hbKCXK+cJXE544KWpwEUAu//N1k8wbwXYCq5UnZ1yedHC/e7US8
         81BhdfW7LUlaGCyFnnYOvAsmlRTX5vUX1byyqCmVxkps65AthmuVAJpKJPBenGSZunQn
         s77Q==
X-Forwarded-Encrypted: i=1; AJvYcCUEL//3zOUUqFalTHCIMylaCSTdRdDDJ1YKA8j/ZNxSihkzemUZaZwFsmJogHqFkK13cRq+slxsfA==@kvack.org
X-Gm-Message-State: AOJu0Yz+Kh9y7vXNEklJYu/74QdxrphONd1PVnWHAFrzbI5joAlwyFK0
	6T4q3zsiucpdZ4X1xSD0/HrglZkKuVnBbZY9ZGBV9inpN5GFltzuuaNdqj+1iSSo6EX/Qxro/Xn
	KhEaPhdS3v0QSjfJvFb9ZfW0B9PEdKMEC6fI2hVfl4Q==
X-Gm-Gg: ASbGnctoEAWLhRO3/odHFL/YLXna8hpOrrbKrdLuIuhD8uTjGyx0mMnimTkY0ts1EXo
	f52xINDIMqkSnp0A6iU44GtNkw2aAWovRy3SyhYfVHtSyo0xnFL6tOMiUniFahvtGdZ4Ktki4ix
	vHwsFpRjcerCqeJc3R5whQhoM+9nj9PzP8EhcW3otqDBsj2Tf+rjnk9rPSu1H59RPiMsNnV+OUs
	Ne+5wXPJHFGfR1QKYvZz3jQTR9bdYtFq2OjA8vJmixkQjRkVjFP56Ufw/eq2TNmIG9KWU/4E5GF
	sqo=
X-Google-Smtp-Source: AGHT+IFcr4yYt5BkZRvwg4aS3vOuI/dUA++JB1Pa5n/q7YHF3s544Z0m9fDyyoCLymYJhHWCIs054zb/31d4lLoohCo=
X-Received: by 2002:a05:6402:2113:b0:637:ee5f:d89e with SMTP id
 4fb4d7f45d1cf-63c1f6b4c29mr12824950a12.20.1760968078712; Mon, 20 Oct 2025
 06:47:58 -0700 (PDT)
MIME-Version: 1.0
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
 <aPXz-IPDRniMHN0u@kernel.org> <CA+CK2bDMc8RdcNq_qmmW02DNzLePxQNWBgdOuwrfJ=jmr0YK8w@mail.gmail.com>
In-Reply-To: <CA+CK2bDMc8RdcNq_qmmW02DNzLePxQNWBgdOuwrfJ=jmr0YK8w@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 20 Oct 2025 09:47:22 -0400
X-Gm-Features: AS18NWAHh0mRsVXmirlOiWUS1kBKZtHjFUd9z0xLGz6uGryTcRWZa3G7aWSpR-I
Message-ID: <CA+CK2bDaN5quQd+3UOXguxRfdq2OMLSVqnPU-cM-=YCCRw8=Tw@mail.gmail.com>
Subject: Re: [PATCH v6 00/10] liveupdate: Rework KHO for in-kernel users & Fix
 memory corruption
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: c7qibsuoe1q5u6etx5n6mih9nqbqkdeh
X-Rspamd-Queue-Id: AB7B0140011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760968080-758321
X-HE-Meta: U2FsdGVkX18qlekdmvbIFglFTwtSS7FGFDT3rG+DUQH02D3esHV+2DyyxWQtuHEOG/5tdH5fjmqZ295y2W+SCpmD95pVJvj3lnPMENkLkaVHKI4nStJyaPkKtrx3IPhla4a3BQAQFYKaWnV+rgJRl00DxZHsRX67HkqmzrHp1vXkav6Dj+x4lj5UwbEGlQktDaT3g8zs4A5frBKnK5piGrBRfoEQCYVX+xo4C1ws/ge6mexzXnAulPoTa0c8kI6qP5gOKesJkVbuA9vKyvRcr5WPa+5Vyg7EuQUXNfEn2Jgvt3z0zxo60FfMMd1m7X9nuUhXuPYkBVcbfWOEk0E8Z085Up5IkLG03ofXyVxCYY9cLkz3raTmTDW8axK5C5MS/ajnQD0S0FMuggMsY0uJUkM6jrV9uurNq8qjYxF2D9I4XfTjrSM1XChNTlF2eblX1OgDE7KQGaynUkrR1dsr9aKgR2qjmZGJNSP/NVpp2Qbul38kywgPDUGq706RK2EG25HZvYTw/7eaqloFybgZ40pnCurngD8Po7kljilVrI667MNKo5aMjrR/xmVSm4X6uz4jZL8Q03EahiLs6Xa1kouMS7Kn7ARTOkQwAmntvQsUbXH+WLazNb1oNmxlq7fNUr1bBef6jWPqO2pUzo+9p914Fm0oEmHPERWWUMI+Lvm5tK5wNn6CnYck/vo/zYBqMfE+IuGVLn+TnbrtP5KOFok1oaKCLg1niVeZ5Cu1Zrecwyw+KDNsTZJ/WPtUga8rZsvbHvdnzlv7MNb8NukIfReFveRe0EZh+fhHQuXb9j9SxHhxTzRa1w22H10q5U8JPrQ0giX+vxLqeDaqymgECgxJEXLO4ASIy9AbPvvSqKKOeO3grpJM6ilTWXdqFAU9w8fei8JKDUo2DOlctVI0Mz1H3DaSeVi4r94HyAjXKVqGQrw0bk0OgL1MFfjhfS0JGj1+/l5RyZ+p2YpskMF
 6PXWayc4
 tg1E+/UGUMJBPaGfvJqWUXc2ppZBVVRShDKlL9BuTRl3wK7jHQtOp5SJpp+B7m6dLW8O8E8kg4OKpx2T3EZinY5oQ1lZmNqSylP6huXZeFLzBMd1o0u4LDzprP2MTM804j3xCdYwmYAmXLbRMPmgEnBtWNJRhkRYowu99m1yHaYNWlkvjYxFF6AvU6vxIGp/J34r9/LI5ykdS1rOLGiLabiKsj0YDw3jE5gtJPy+N65CC3WWengR67ouxlXmPOwK5oKy6KIyw0b27PtgrEMq7RfIgcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 9:46=E2=80=AFAM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Mon, Oct 20, 2025 at 4:34=E2=80=AFAM Mike Rapoport <rppt@kernel.org> w=
rote:
> >
> > On Sat, Oct 18, 2025 at 01:17:46PM -0400, Pasha Tatashin wrote:
> > > This series addresses comments and combines into one the two
> > > series [1] and [2], and adds review-bys.
> > >
> > > This series refactors the KHO framework to better support in-kernel
> > > users like the upcoming LUO. The current design, which relies on a
> > > notifier chain and debugfs for control, is too restrictive for direct
> > > programmatic use.
> > >
> > > The core of this rework is the removal of the notifier chain in favor=
 of
> > > a direct registration API. This decouples clients from the shutdown-t=
ime
> > > finalization sequence, allowing them to manage their preserved state
> > > more flexibly and at any time.
> > >
> > > Also, this series fixes a memory corruption bug in KHO that occurs wh=
en
> > > KFENCE is enabled.
> > >
> > > The root cause is that KHO metadata, allocated via kzalloc(), can be
> > > randomly serviced by kfence_alloc(). When a kernel boots via KHO, the
> > > early memblock allocator is restricted to a "scratch area". This forc=
es
> > > the KFENCE pool to be allocated within this scratch area, creating a
> > > conflict. If KHO metadata is subsequently placed in this pool, it get=
s
> > > corrupted during the next kexec operation.
> > >
> > > [1] https://lore.kernel.org/all/20251007033100.836886-1-pasha.tatashi=
n@soleen.com
> > > [2] https://lore.kernel.org/all/20251015053121.3978358-1-pasha.tatash=
in@soleen.com
> > >
> > > Mike Rapoport (Microsoft) (1):
> > >   kho: drop notifiers
> > >
> > > Pasha Tatashin (9):
> > >   kho: allow to drive kho from within kernel
> > >   kho: make debugfs interface optional
> > >   kho: add interfaces to unpreserve folios and page ranes
> > >   kho: don't unpreserve memory during abort
> > >   liveupdate: kho: move to kernel/liveupdate
> > >   kho: move kho debugfs directory to liveupdate
> > >   liveupdate: kho: warn and fail on metadata or preserved memory in s=
cratch area
> > >   liveupdate: kho: Increase metadata bitmap size to PAGE_SIZE
> > >   liveupdate: kho: allocate metadata directly from the buddy allocato=
r
> >
> > The fixes should go before the preparation for LUO or even better as a
> > separate series.
> >
> > I've reread the LUO preparation patches and I don't think they are usef=
ul
> > on their own. They introduce a couple of unused interfaces and I think =
it's
> > better to have them along with the rest of LUO patches.
>

Forgot to add:
The LUO preparation patches have been soaking in linux-next for some
time now and are mostly reviewed.
...
> Pulling them out to apply fixes separately feels counterproductive,
> especially since we agreed to add the new kexec_handover_debug.c file.
> The most straightforward path is to build on what's already in -next.
> Let's stick with the current approach.
>
> Thanks,
> Pasha
>
> >
> > --
> > Sincerely yours,
> > Mike.

