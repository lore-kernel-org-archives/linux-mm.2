Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44EC3D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 20:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AEDB6B0030; Thu, 27 Nov 2025 15:29:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386796B0031; Thu, 27 Nov 2025 15:29:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29CA16B0032; Thu, 27 Nov 2025 15:29:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 199746B0030
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 15:29:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5F31B780B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 20:29:30 +0000 (UTC)
X-FDA: 84157527300.05.C7F4D99
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id BD19718000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 20:29:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aAYEukPu;
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764275368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BMTw1kDL8EKjTOAtowuEddJlwPoqJdeq89qWoiUPpVg=;
	b=nFhmQe/TeQRe7A7ZnYC459llr6BIjhVVU31tY9Bv8pcmV3epz9Ig4S636FDF66CYorY+5y
	i1TDmw0QmA2m+DCUnTq+t3vmYwFn/mfcqhAkqvD1KVC1pEynv2R66sSPOhbYDqS8KERQqS
	wSBTYrmJlhLL18udKcF2mN9kYQPFkgc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aAYEukPu;
	spf=pass (imf16.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764275368; a=rsa-sha256;
	cv=none;
	b=G/SpF68MPGRziZMCj+n5ei1C1sWLrRIt9fAzmaq+Xbl6Tiv5ULSD+p1HSPkmHsgB95v3H0
	Y7y1n9VW1lm44NunyJ4SMROKuNK8/5SRdWoObgpdHGagytu+iQ5KnnHRG4eG8F9BUqs9ST
	0dQ4urjtcZoTKsb2xvsZO1yZcK7SEN0=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-880570bdef8so12066846d6.3
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764275368; x=1764880168; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BMTw1kDL8EKjTOAtowuEddJlwPoqJdeq89qWoiUPpVg=;
        b=aAYEukPuXu7zpCU/6VsJxj8k22i3sJyHFzRpmD6alE0QtCzXe10P/0Ocq6zd5wZUXg
         5hFvJqynFHk6DdSepLPpGcSjtYoFlL29uccTQQunGOOCzwv75vYZXIubdooLLP68Znlc
         hS+RvmJhy1NxwPPqN3EVMbcq4IBNqaZ/LvI7W3vfZX18k9+JdUDBqanyJW/MBTsXszdL
         Ng4KBIrOSzv0Qm7irPe30gXLgEXpPLZYSEo5tyTGMABndIfOCMjOHyX4TVxfkqUlgEdG
         WAqo4nCoPrz6CF4QgyqBhvv9bSf3X6c1gNmishghK2tD0T51k53gkT5Q9oeOalr1oKn1
         3m/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764275368; x=1764880168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BMTw1kDL8EKjTOAtowuEddJlwPoqJdeq89qWoiUPpVg=;
        b=mqfAH+4WiOcDIS9E0YHoynNfE5m5L6plYjXMiDcgkj1YCTOWB2g8i4hOp1aoyH8GcX
         SdT9fLExMTUwpBU7zXIDJPP13c4N5HoSMjV4aYyvEHbvf3kVNnHC4x3d+oc9repj60EU
         UAM35Jap5kHg3j7iEMMRO9XwK+vbpv3a7s1yK6sdyEI/wB9P9Pwi48ceN8lfpzttHYtM
         DYcJMXBtJiRHrXtvggbF2hriNd4jfwWCod/saKGJzx+3nnrSDj/z237XafwS/8lm3e5z
         xXLcS3FNjFqcNsOM4I7ipJtXShQ+A+QObWlV31AVXZV2uN8nqYpTrc/k+qv7DtqHDemY
         pFXg==
X-Forwarded-Encrypted: i=1; AJvYcCXMvUFU3xFOXmS7GZKV3tL5tVPuEnHKBSSCuFSDuCMKh6GfJvt3f1svxeXW4DGb5A2oPfYtIAO22A==@kvack.org
X-Gm-Message-State: AOJu0YzlR4twjD2X+HpHQdzyii6zjHbqCnC2zhRBwGXhDrUeFuPO5fyJ
	R3ZBjWowtrYkLSdQRP7x18dF6KTxZtMvH7LB4HPW5H7ScdGxJr9xtTe7fFmCTJYx9SmjKduLqEV
	q3afuhzfzdh5NCkct+uJDhoU+VCgo2H0=
X-Gm-Gg: ASbGncuzH+7l6CcYg3QfInYcg5jVy6qe4jDOVBknnv+IQ+mp9nMnOrDgsCurowiKeCS
	Hvmyi2EhfbZ7trQg4Guy7umZYBQcC7nlLukcozCDot+AaXzIWGT5co+tQ6/IQg/SUiUNtQBtJ7J
	EFqeXI2GSzG+EU6h1S4MtSt6JzQmzrkxBjJiKHtVLoHAEPtTyIbLqqxgVQ9JqBhTFbO3qKoXn9S
	QOYd1Q64+rBeqSvLOUF4qltTa6WXekWQs0a7JBsMIDSjyq3IJZIgxjEOLaBrcUJ6EMSXg==
X-Google-Smtp-Source: AGHT+IG5GcGrOmVVsePre6BxCVhrhKY7NJnCRBVNCLt/HcgbymNTTZVjYmvrDTtjRkuAQ9GKsIJdwvx3BNDYrNQPC88=
X-Received: by 2002:a05:6214:234f:b0:880:486d:18dc with SMTP id
 6a1803df08f44-8863afb4d8fmr176925236d6.58.1764275367501; Thu, 27 Nov 2025
 12:29:27 -0800 (PST)
MIME-Version: 1.0
References: <20251127011438.6918-1-21cnbao@gmail.com> <aSfO7fA-04SBtTug@casper.infradead.org>
 <CAGsJ_4zyZeLtxVe56OSYQx0OcjETw2ru1FjZjBOnTszMe_MW2g@mail.gmail.com> <aSip2mWX13sqPW_l@casper.infradead.org>
In-Reply-To: <aSip2mWX13sqPW_l@casper.infradead.org>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 28 Nov 2025 04:29:16 +0800
X-Gm-Features: AWmQ_bn_b-JGqeMVPQ751bNAv2Qsiauy9g_kN3cQ2gR4dkmeqYmOBAyRrjCf_ew
Message-ID: <CAGsJ_4zWGYiu1wv=D7bV5zd0h8TEHTCARhyu_9_gL36PiNvbHQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: continue using per-VMA lock when retrying
 page faults after I/O
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 314yeekfdxzznb5iiz3tf3yzygz7tm7u
X-Rspam-User: 
X-Rspamd-Queue-Id: BD19718000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1764275368-450363
X-HE-Meta: U2FsdGVkX18/q0TvltXlXuT1b1RsU5t17D/07ibZ4I6bbytKe49Pt0hX29jzz7zYUgO+c3fnnGoaSIho05HaG0hzkRyLv0+suhnf5zaz0BmRgHUzwJH+TTaRuFd1gQE8QshKJcUU+FfooY7qGPrBaAbXON8+1MwvDxFTuR01NsbFjVAORZZJHZyLdIWHbWo2dPN186LPj+MGm5mdrpeImVUfFaEyk19FmoVb0a8o0rSzCFM2gfz7MzF/LQJ+X6Uw4Q0yePdXZe0tJhnU8f6JjMBbhHITj6+rosQAwvWG4QHysEW0VK6Z9y2JQ6xJuY4CfdKDNwrgS4kT1+5KN7xP3sPI9RGaWBUV7pmveR9lobPji6tWOEIenIdO7QS/eirHy9eSeI/s7f0+5lXTlqT/HkTgF8k8AuRjIhS0IMv0OzV8hqwpUpEeawZbbx0nlHwRgY9WWDQv3jT9x7hssog8OJ09qYVpaqNC72fQuHGmU7NLax7zOy2Ms6nPjPFzzP0sn0ECXbXwJnKOU3IZfO/y2zSkCAK8cTql/oWqgT+11qKnKG5CWVe/Z3j8g0tm3tsqTeDFW0gOFDpe0jQd98K1QsYHP/mg7bkPtjI+77Mo7KWdOWUjQvJgbunnxFesCqlNHQw48dr+1P0obwqDneOPsGduJUFynuIPl5Z+GfnF8Q4ky+e2X4RRXWcBufn1h4S7mCcfdxda1Z8sOjtW1xs274nsxyjb2N/WMu31meeSwTFlXXiEWeGNrN0Xc7RGtyKtzUbpxsaIHQ1UDoM4HHTqmzaSImsIGUyYB1531/U8afxKFWGWta34WhBV39DdI36lc1fU5qYXVrStFNYIG3HxOHoA6YCG+z2NEFutMobZxZ5LOzL0C8y0079es6to+RNE5/75jNwYajio5Nu97YqPtzxrtjWwuyTZm47XeH8KgNTWFwFH5gPEHle7X3lQHyieBgy/+2Oj8bLhhtrmK5B
 LTF/pAWl
 HMfllWLEmDeiOdbiRwYvyxw+GhbnL2O3OurMpk+wcxmkXjpfGhsFJvrcR/7m8oZFTlfx5NXruCzFH6mbRcAGPqx56AFw7auDGKA26kJavHDDOeeMAz8SA7rfZzzE2nO1ADNrt/kJ4MxqMopUKBeKfhNS12TGenUnr23jz8oAY701PdaTaTU83lBDryOLwoB+e4qknCdC7qMp574hIfJrPfQNGZKvO9kWcajYMJ/eMhGAdZbuAnjQRYgd4zOZ09LWYQC1CnR6N2fy/dNaFGqG1l51tb29V96m6EGgWBmKT3Vqd1X75Iyx4xX5owx0Ohfz/qZ5GNsLdWI3bHBPJesyQ6Sa2cmvZIW6toezMBjIAstZ6JcAYi6bdnUQnm8x9wmhSfUdraLE6ck82y2EEsczllAmgoTYYXCM93DYI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 3:43=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> [dropping individuals, leaving only mailing lists.  please don't send
> this kind of thing to so many people in future]
>
> On Thu, Nov 27, 2025 at 12:22:16PM +0800, Barry Song wrote:
> > On Thu, Nov 27, 2025 at 12:09=E2=80=AFPM Matthew Wilcox <willy@infradea=
d.org> wrote:
> > >
> > > On Thu, Nov 27, 2025 at 09:14:36AM +0800, Barry Song wrote:
> > > > There is no need to always fall back to mmap_lock if the per-VMA
> > > > lock was released only to wait for pagecache or swapcache to
> > > > become ready.
> > >
> > > Something I've been wondering about is removing all the "drop the MM
> > > locks while we wait for I/O" gunk.  It's a nice amount of code remove=
d:
> >
> > I think the point is that page fault handlers should avoid holding the =
VMA
> > lock or mmap_lock for too long while waiting for I/O. Otherwise, those
> > writers and readers will be stuck for a while.
>
> There's a usecase some of us have been discussing off-list for a few
> weeks that our current strategy pessimises.  It's a process with
> thousands (maybe tens of thousands) of threads.  It has much more mapped
> files than it has memory that cgroups will allow it to use.  So on a
> page fault, we drop the vma lock, allocate a page of ram, kick off the
> read, sleep waiting for the folio to come uptodate, once it is return,
> expecting the page to still be there when we reenter filemap_fault.
> But it's under so much memory pressure that it's already been reclaimed
> by the time we get back to it.  So all the threads just batter the
> storage re-reading data.

Is this entirely the fault of re-entering the page fault? Under extreme
memory pressure, even if we map the pages, they can still be reclaimed
quickly?

>
> If we don't drop the vma lock, we can insert the pages in the page table
> and return, maybe getting some work done before this thread is
> descheduled.

If we need to protect the page from being reclaimed too early, the fix
should reside within LRU management, not in page fault handling.

Also, I gave an example where we may not drop the VMA lock if the folio is
already up to date. That likely corresponds to waiting for the PTE mapping =
to
complete.

>
> This use case also manages to get utterly hung-up trying to do reclaim
> today with the mmap_lock held.  SO it manifests somewhat similarly to
> your problem (everybody ends up blocked on mmap_lock) but it has a
> rather different root cause.
>
> > I agree there=E2=80=99s room for improvement, but merely removing the "=
drop the MM
> > locks while waiting for I/O" code is unlikely to improve performance.
>
> I'm not sure it'd hurt performance.  The "drop mmap locks for I/O" code
> was written before the VMA locking code was written.  I don't know that
> it's actually helping these days.

I am concerned that other write paths may still need to modify the VMA, for
example during splitting. Tail latency has long been a significant issue fo=
r
Android users, and we have observed it even with folio_lock, which has much
finer granularity than the VMA lock.

>
> > The change would be much more complex, so I=E2=80=99d prefer to land th=
e current
> > patchset first. At least this way, we avoid falling back to mmap_lock a=
nd
> > causing contention or priority inversion, with minimal changes.
>
> Uh, this is an RFC patchset.  I'm giving you my comment, which is that I
> don't think this is the right direction to go in.  Any talk of "landing"
> these patches is extremely premature.

While I agree that there are other approaches worth exploring, I
remain entirely unconvinced that this patchset is the wrong
direction. With the current retry logic, it substantially reduces
mmap_lock acquisitions and represents a clear low-hanging fruit.

Also, I am not referring to landing the RFC itself, but to a subsequent for=
mal
patchset that retries using the per-VMA lock.

Thanks
Barry

