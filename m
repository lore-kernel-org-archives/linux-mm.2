Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0785EC111A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 18:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53BE6B0005; Mon, 23 Feb 2026 13:22:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01266B0089; Mon, 23 Feb 2026 13:22:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD55D6B008A; Mon, 23 Feb 2026 13:22:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A6D1E6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:22:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0642F1A02AC
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:22:40 +0000 (UTC)
X-FDA: 84476542080.08.21FBFB7
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id D5FA740016
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:22:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PhsUj6dq;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771870958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XkJwIwniiks0s1p1oXukSpLNtAOi5sfRiwj7r2igO2w=;
	b=iufR/TEnmGdsM1LjrKEfNxRxEi1FDHWlRKbnAvEjyYShDmRd03X8vhT8Eseb72i9scbL+L
	8ldZy7pNSvWx0lOZWz2Fx8+RQUkRigePSBxbSxQPRmBhsz7GcZixVRLNDQ8HW0SpvvvRP9
	xKcyMAZEsipQV6Hhsp6OIPatVontX+M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771870958; a=rsa-sha256;
	cv=pass;
	b=GxW1tz9o+pRaXvnst0+VXhWx7PK2X91KyhdVyojWnhs5+0EV5pRsBHkHvnAGoJQ8l8uJAh
	roELplV54bQVvYr6XtpVZr5HDUrIZB5aTtnVVpcUI4y1JnghPpdKAiYp+jqfm8SkHfeXKO
	dVtzleDEoQ6CH8BbiimJIcFJnDj7ywk=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PhsUj6dq;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-437711e9195so3070687f8f.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:22:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771870956; cv=none;
        d=google.com; s=arc-20240605;
        b=fYP+39uAa33Qv+Di9sjt1Px//oY0ZkZoqiOAlYhwcwl0IJI9L/lmNsS5u98VI+N1Cj
         0s+57XkIw0aNK9Z7IUSUJ4Dl888oYAjYn3PF94amZntcfAn4S8+yVOwAHSEYFiYgSoZk
         ZNtiS+I8M/0xjEuUQWIyVsvQcigMfYdx6cORLZqUCZO7XczJgsfLhfPSQuLwPTPVeg8s
         RSaJo8mxMWIQGNXH8IKx6LiIRbsDQa5WwyHlMudVLf1+yRkjts5s+4YnXP4QbaWSr+3Z
         slComVAavSFxFI9rUJXxYmw6dJKSjssiRx1+hl0oEi2DqRNEUvLqLfqak35HURXd4vaS
         3q1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XkJwIwniiks0s1p1oXukSpLNtAOi5sfRiwj7r2igO2w=;
        fh=87aQM+44ZhfE5dgkq44/p711XonfJhlI46zRPaIdU3s=;
        b=QV7Zb6LtXQLFR9bP0RL4oT9OLbDRmO/bDO1kjZJRGow1m9Agr79g3K0C3iP8w1gnfk
         RBiioRO4Gt4hH8mHLtY2Jo8ccb+vX/wjStZOSbv5WjMKvDqbSLCOtqM1DateBdFkyx7P
         E+m3+AsZxFMPl9jOQ+yPKDSULn8v8Q746qCebxB6xpnEK4Xd2x0JGEQkx2A9a7g27+XS
         EZA4ALGtBaWzAqJbxMqhKAqvbP5/djddfAIMGXkWEvKkBmFFRiID/LJMNWrukPsX5Qt4
         OG1cQ6S3S+MDJsdhX2uJr+eai9xrIOlJSIZRbTSdEzqHFR9/dmn4zcATn7/6T6Q3sPWx
         cq3g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771870956; x=1772475756; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XkJwIwniiks0s1p1oXukSpLNtAOi5sfRiwj7r2igO2w=;
        b=PhsUj6dqZskJZOqmDYqEQG1Z/npZw4wQl0a2wIV1wssdFYMJ7UIJH7Mlaqaez8HXBk
         xj0OW+GiZVtJK3EQ4TGRZEHy2FbVCPZT9v39tRbpuBAUShwkcmbqE2niEpoehiObKrjG
         HbHU/VUZeb/uoH/LJkTSSnxpoYfuRCXKRVvyPmrM3rasrQqIb38Mfb7ALl78sxVhzqlV
         JSB2OnNuNQuktju7Q04QNKYqezQM2isiPiIcAyyYuk6LUQcBJSGHCQKxesg9K4pTmeCb
         hRGgl+Hrlx0KnbZqKVMmIRH2isGxuDTj8J9NNuVGJ+t5tN5cLd6MEAXSMCDgReNTGqqq
         PLGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771870956; x=1772475756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XkJwIwniiks0s1p1oXukSpLNtAOi5sfRiwj7r2igO2w=;
        b=cH4TD+oRlBPgCdvVVZrtT39lobizRAb1CDlpNeoXSu4bktT9FgUqnGnTBuIXRKmivA
         vrM5x0o+4e9TTHe5hIzYNrbU7/QcEjXtjmCqqs03Bin+V17oZPcuRijqUY6CDg2BXWQD
         ntr/jJ2zo5E4zY3k2NMXoyvjPC/AV531eDvGYFSZrP+RFzhKQUH1PFTXCRsNoBwTTf3O
         DUePVU/SAHGHT7Dl2BHgpLvBv1wBJxvmRNyw5m4HneBMe5W+h6hPgBJwL6+SJjGP/lHb
         cqhEJqBd56xfFabIEHVS9rLsTc6vvsdeFLDsvGxXpk/9R097ZRqxNGdWAeGi3dzzgNya
         RBXA==
X-Gm-Message-State: AOJu0YwauQXTU/MYox2GXi3LiKXwfeCWPxx9wsx42G+NUAUhvj55bhqK
	h0SlNZcpV+DK4JdqBpCsNt/2GZ+6pHyvMfxFntJlcVwPO/2Mm7/o4Bpljhg2N86w5t202noaPBi
	QsIId1MfQN4FGHa6UI5PUdbwGrwRcn3M=
X-Gm-Gg: ATEYQzxn1ZpyP9NmEJrJypQuc+hmzlZRw6kswX8aenyktQw1KFPso9v7wp+G7sCAuvz
	ovw/wm6c5/oqlrQ1gQN3Nw8GdDJtDvqXtdgQ6YopTVhkJS1rVM1T6YaTTUJWriizf86UIwmt5xq
	2PNIs8NA0Dqhy8/AdOSUo3ff2x0JPjeOmCWnJn3djrT59CvRIHzbJcHSkvdPh1tO3e2a8jU8Crx
	jUr9zSKw6e38XFNW21sEkdAkw38hy0JRRR1B3YBuTkcdt7jUNOnFeECWXs9DXLgbzMaE05UZ3h4
	u4kayeXwdrJj9i6OmS2G1wK0nCO+iGyY4cOR0/0D+Hj6rPU36uT3Sg==
X-Received: by 2002:a05:6000:22ca:b0:436:7a5:aac with SMTP id
 ffacd0b85a97d-4396f116114mr17533401f8f.0.1771870955471; Mon, 23 Feb 2026
 10:22:35 -0800 (PST)
MIME-Version: 1.0
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
In-Reply-To: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 23 Feb 2026 10:22:24 -0800
X-Gm-Features: AaiRm50EclgTJkpuwFKUs5IJ9xfozQ-JHugIhkuhmnaNamawRiZioeIFLlrX9VM
Message-ID: <CAKEwX=OaDKQwanaYm=Mt+mWAKjaqXPdiScF6NB=TZYx1B-Xo8w@mail.gmail.com>
Subject: Re: [PATCH RFC 00/15] mm, swap: swap table phase IV with dynamic
 ghost swapfile
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 4so34mt6cowbzufmjq3bgpx94ud6ms8h
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D5FA740016
X-HE-Tag: 1771870957-533726
X-HE-Meta: U2FsdGVkX18ifXimCYklTAsN+UAJB3OvHrbH9ExGr98XN03uyd+Z+aYIQR11i99rb/9EJ/iZm/kRJv/q3R66AqJJQ+8U4Q0ksiT2XJDAhsmA2bOSldFAw8YC+Z+xUwerNesvsJCqpC0/RU1rg9KhpR4u5zzDkO2wfLN4TpFYYbYptoMdrxO1wOtGFfEEgyBp6IAdekuqKe6BxBuNw3e7m6tIOMsafxQGLsoKH11KsMvrSGjvhOgalxiuDtkFKTg0voFnpgknNnMeDoeNJOVMFKP/uSpCz19ay8M5DEzJYbkKAJi2MOvu4TW58LDv9c2xJD5TaJhW1fBeDnpipCN/4MInA5fXyHuV/snl0b+dVc3twET/hjsS5GXhbHPR8VszVHH8so3e/HB1NR6WrD90m9+c6DBeeh0c4SyxamON5TFykkqexwk2a0UlVvEFRGS26Z0wQ3iVOsHaAfcfgmemyJDNb3M57PcQkH+91u0sBEggYLCbhWxU2RxhWBRH/TkoVOV0oNeBhqjjUyovXdv9tTm7UhHVYAzPOaRUu/nmOJtgr+AjcjrIkkPMZyNWTh64JrMcXpAT6widIR7T+PwVFAEXuCbIrG21fVeX8AMvWlT5Ywyc4/mE1IqOjz8fFDIwvFtsz1k34jZOIS7OULPG/qnQihfH1Z+d/tlWpvyV94IPlGxVqDS9gQxHv/OxAlobYx6pkBz9YqkCC3UK0Mqm2u2WHYVd5LxepHLYSpg08iYJV5z4usWA8w55615wMacrsCps48Ua2nu5SCuhN10ThGlQWQeV/A1x/o6qEhMVQcS+X4urU9tp/y7f+LMWXlixAPgKwnyo+nLaNsFV0D4pNIbhN+k+/COhZyfZtfibkyVn9jLiF6KLLgDMuYpBUhrMiBdqmgZW8D05fIbd0pv4yLalyIehWDcM/aTeWQoiZM8IH0cFtO8nbYfh81IOV42pwRWM9neKbbhq+puL4r9
 cRv+1PJa
 7VoVARcTgoa9zb/I/FtWsEtsn2DdXW7sz/NXazU1erkopioVNSZpOj/4OAILuOmgiP+2O6vr4TkiMxIcTPwXS1lP3LiMm0T3TP1Pw3gP64thwU/fW2G/qYCwYOlffQudVBPvNZ6b505loitN03Om6Sh+OB+FJSXpV+/VYMirnh0t1IRhVfwpIbcYKp+/qvA0Ipbpw3+v4AOH/vhu5yBBvaq1G27TrswpO+R3+rb6hi0C7fPKB03FYrFKyJxda4EvFPfPtcYqLYDuF5hiF2qGPaaJYwnLb5B4mjdVs4ZM8XXcmheQQbSuPDROlyReUbTpAr7qpbIDpPEcZhXgDj3f3RKez1GjqNOzI9wQ8hjdAy2j+r6F40BqH0l+GadgNsPpSs1wHwe+0uF3hhOdVDOQ4qIhMH31BtKOcA1iv4th2IzohnEz+6cBCnitnnZ2x7Ip7Y2hUevSuOCBvqzvLUtn6ERpFhadFOPIs9YxVHGx7RULZ6COaafuvEltSW1m9NNV+9s4+YH9G+e9nhcw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 3:42=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> NOTE for an RFC quality series: Swap table P4 is patch 1 - 12, and the
> dynamic ghost file is patch 13 - 15. Putting them together as RFC for
> easier review and discussions. Swap table P4 is stable and good to merge
> if we are OK with a few memcg reparent behavior (there is also a
> solution if we don't), dynamic ghost swap is yet a minimal proof of
> concept. See patch 15 for more details. And see below for Swap table 4
> cover letter (nice performance gain and memory save).
>
> This is based on the latest mm-unstable, swap table P3 [1] and patches
> [2] and [3], [4]. Sending this out early, as it might be helpful for us
> to get a cleaner picture of the ongoing efforts, make the discussions eas=
ier.
>
> Summary: With this approach, we can have an infinitely or dynamically
> large ghost which could be identical to "virtual swap", and support
> every feature we need while being *runtime configurable* with *zero
> overhead* for plain swap and keep the infrastructure unified. Also
> highly compatible with YoungJun's swap tiering [5], and other ideas like
> swap table compaction, swapops, as it aligns with a few proposals [6]
> [7] [8] [9] [10].
>
> In the past two years, most efforts have focused on the swap
> infrastructure, and we have made tremendous gains in performance,
> keeping the memory usage reasonable or lower, and also greatly cleaned
> up and simplified the API and conventions.
>
> Now the infrastructures are almost ready, after P4, implementing an
> infinitely or dynamically large swapfile can be done in a very easy to
> maintain and flexible way, code change is minimal and progressive
> for review, and makes future optimization like swap table compaction
> doable too, since the infrastructure is all the same for all swaps.
>
> The dynamic swap file is now using Xarray for the cluster info, and
> inside the cluster, it's all the same swap allocator, swap table, and
> existing infrastructures. A virtual table is available for any extra
> data or usage. See below for the benefits and what we can achieve.
>
> Huge thanks to Chris Li for the layered swap table and ghost swapfile
> idea, without whom the work here can't be archived. Also, thanks to Nhat
> for pushing and suggesting using an Xarray for the swapfile [11] for
> dynamic size. I was originally planning to use a dynamic cluster
> array, which requires a bit more adaptation, cleanup, and convention
> changes. But during the discussion there, I got the inspiration that
> Xarray can be used as the intermediate step, making this approach
> doable with minimal changes. Just keep using it in the future, it
> might not hurt too, as Xarray is only limited to ghost / virtual
> files, so plain swaps won't have any extra overhead for lookup or high
> risk of swapout allocation failure.

Thanks for your effort. Dynamic swap space is a very important
consideration anyone deploying compressed swapping backend on large
memory systems in general. And yeah, I think using a radix tree/xarray
is easiest out-of-the-box solution for this - thanks for citing me :P

I still have some confusion and concerns though. Johannes already made
some good points - I'll just add some thoughts from my point of view,
having gone back and forth with virtual swap designs:

1. At which layer should the metadata (swap count, swap cgroup, etc.) live?

I remember that in your LSFMMBPF presentation (time flies), your
proposal was to store a redirection entry in the top layer, and keep
all the metadata at the bottom (i.e backend) layer? This has problems
- for once, you might not know suitable backend at swap allocation
time, but only at writeout time. For e.g, in certain zswap setups, we
reject the incompressible page and cycle it back to the active LRU, so
we have no space in zswap layer to store swap entry metadata (note
that at this point the swap entry cannot be freed, because we have
already unmapped the page from the PTEs (and would require a page
table walk to undo this a la swapoff). Similarly, when we
exclusive-load a page from zswap, we invalidate the zswap metadata
struct, so we will no longer have a space for the swap entry metadata.

The zero-filled (or same-filled) swap entry case is an even more
egregious example :) It really shouldn't be a state in any backend -
it should be a completely independent backend.

The only design that makes sense is to store metadata in the top layer
as well. It's what I'm doing for my virtual swap patch series, but if
we're pursuing this opt-in swapfile direction we are going to
duplicate metadata :)

>
> I'm fully open and totally fine for suggestions on naming or API
> strategy, and others are highly welcome to keep the work going using
> this flexible approach. Following this approach, we will have all the
> following things progressively (some are already or almost there):
>
> - 8 bytes per slot memory usage, when using only plain swap.
>   - And the memory usage can be reduced to 3 or only 1 byte.
> - 16 bytes per slot memory usage, when using ghost / virtual zswap.
>   - Zswap can just use ci_dyn->virtual_table to free up it's content
>     completely.
>   - And the memory usage can be reduced to 11 or 8 bytes using the same
>     code above.
>   - 24 bytes only if including reverse mapping is in use.
> - Minimal code review or maintenance burden. All layers are using the exa=
ct
>   same infrastructure for metadata / allocation / synchronization, making
>   all API and conventions consistent and easy to maintain.
> - Writeback, migration and compaction are easily supportable since both
>   reverse mapping and reallocation are prepared. We just need a
>   folio_realloc_swap to allocate new entries for the existing entry, and
>   fill the swap table with a reserve map entry.
> - Fast swapoff: Just read into ghost / virtual swap cache.
> - Zero static data (mostly due to swap table P4), even the clusters are
>   dynamic (If using Xarray, only for ghost / virtual swap file).
> - So we can have an infinitely sized swap space with no static data
>   overhead.
> - Everything is runtime configurable, and high-performance. An
>   uncompressible workload or an offline batch workload can directly use a
>   plain or remote swap for the lowest interference, memory usage, or for
>   best performance.
> - Highly compatible with YoungJun's swap tiering, even the ghost / virtua=
l
>   file can be just a tier. For example, if you have a huge NBD that doesn=
't
>   care about fragmentation and compression, or the workload is
>   uncompressible, setting the workload to use NBD's tier will give you on=
ly
>   8 bytes of overhead per slot and peak performance, bypassing everything=
.
>   Meanwhile, other workloads or cgroups can still use the ghost layer wit=
h
>   compression or defragmentation using 16 bytes (zswap only) or 24 bytes
>   (ghost swap with physical writeback) overhead.
> - No force or breaking change to any existing allocation, priority, swap
>   setup, or reclaim strategy. Ghost / virtual swap can be enabled or
>   disabled using swapon / swapoff.
>
> And if you consider these ops are too complex to set up and maintain, we
> can then only allow one ghost / virtual file, make it infinitely large,
> and be the default one and top tier, then it achieves the identical thing
> to virtual swap space, but with much fewer LOC changed and being runtime
> optional.

2. I think the "fewer LOC changed" claim here is misleading ;)

A lot of the behaviors that is required in a virtual swap setup is
missing from this patch series. You are essentially just implementing
a swapfile with a dynamic allocator. You still need a bunch more logic
to support a proper multi-tier virtual swap setup - just on top of my
mind:

a. Charging: virtual swap usage not be charged the same as the
physical swap usage, especially when you have a zswap + disk swap
setup, powered by virtual swap. For once, I don't believe in sizing
virtual swap, but also a latency-sensitive cgroup allowe to use only
zswap (backed by virtual swap) is using and competing for resources
very differently from a cgroup whose memory is incompressible and only
allowed to use disk swap.

b. Backend decision making and efficient backend transfer - as you
said, "folio_realloc_swap" is yet to be implemented :) And as I
mention earlier, we CANNOT determine swap backend before PTE unmap
time, because backend suitability is content-dependent. You will have
to add extra logic to handle this nuanced swap allocation behavior.

c. Virtual swap freeing - it requires more work, as you have to free
both the virtual swap entry itself, as well as digging into the
physical backend layer.

d. Swapoff - now you have to both page tables and virtual swap table.

By the time you implement all of this, I think it will be MORE
complex, especially since you want to maintain BOTH the new setup and
the old non-virtual swap setup. You'll have to litter the codes with a
bunch of ifs (or ifdefs) to check - hey do we have a virtual swapfile?
Hey is this a virtual swap slot? Etc. Etc. everywhere, from the PTE
infra (zapping, page fault, etc.), to cgroup infra, to physical swap
architecture.

Comparing this line of work by itself with the vswap series, which
already comes with all of these included, is a bit apples-to-oranges
(and especially with the fact that vswap simplifies logic and removes
LoCs in a lot of places too, such as in swapoff. The delta LoC is only
300-400 IIRC?).

>
> Currently, the dynamic ghost files are just reported as ordinary swap fil=
es
> in /proc/swaps and we can have multiple ones, so users will have a full
> view of what's going on. This is a very easy-to-change design decision.
> I'm open to ideas about how we should present this to users. e.g., Hiding
> it will make it more "virtual", but I don't think that's a good idea.
>
> The size of the swapfile (si->max) is now just a number, which could be
> changeable at runtime if we have a proper idea how to expose that and
> might need some audit of a few remaining users. But right now, we can
> already easily have a huge swap device with no overhead, for example:
>
> free -m
>                total        used        free      shared  buff/cache   av=
ailable
> Mem:            1465         250         927           1         356     =
   1215
> Swap:       15269887           0    15269887
>

3. I don't think we should expose virtual swap state to users (in this
case, in the swapfile summary view i.e in free). It is just confusing,
as it poorly reflects the physical state (be it compressed memory
footprint, or actual disk usage). We obviously should expose a bunch
of sysfs debug counters for troubleshootings, but for average users,
it should be all transparent.

> And for easier testing, I added a /dev/ghostswap in this RFC. `swapon
> /dev/ghostswap` enables that. Without swapon /dev/ghostswap, any existing
> users, including ZRAM, won't observe any change.
>
> =3D=3D=3D
>
> Original cover letter for swap table phase IV:
>
> This series unifies the allocation and charging process of anon and shmem=
,
> provides better synchronization, and consolidates cgroup tracking, hence
> dropping the cgroup array and improving the performance of mTHP by about
> ~15%.
>
> Still testing with build kernel under great pressure, enabling mTHP 256kB=
,
> on an EPYC 7K62 using 16G ZRAM, make -j48 with 1G memory limit, 12 test
> runs:
>
> Before: 2215.55s system, 2:53.03 elapsed
> After:  1852.14s system, 2:41.44 elapsed (16.4% faster system time)
>
> In some workloads, the speed gain is more than that since this reduces
> memory thrashing, so even IO-bound work could benefit a lot, and I no
> longer see any: "Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying
> PF", it was shown from time to time before this series.
>
> Now, the swap cache layer ensures a folio will be the exclusive owner of
> the swap slot, then charge it, which leads to much smaller thrashing when
> under pressure.
>
> And besides, the swap cgroup static array is gone, so for example, mounti=
ng
> a 1TB swap device saves about 512MB of memory:
>
> Before:
>         total     used     free     shared  buff/cache available
> Mem:    1465      854      331      1       347        610
> Swap:   1048575   0        1048575
>
> After:
>         total     used     free     shared  buff/cache available
> Mem:    1465      332      838      1       363        1133
> Swap:   1048575   0        1048575
>
> It saves us ~512M of memory, we now have close to 0 static overhead.
>
> Link: https://lore.kernel.org/linux-mm/20260218-swap-table-p3-v3-0-f4e34b=
e021a7@tencent.com/ [1]
> Link: https://lore.kernel.org/linux-mm/20260213-memcg-privid-v1-1-d8cb7af=
cf831@tencent.com/ [2]
> Link: https://lore.kernel.org/linux-mm/20260211-shmem-swap-gfp-v1-1-e9781=
099a861@tencent.com/ [3]
> Link: https://lore.kernel.org/linux-mm/20260216-hibernate-perf-v4-0-1ba9f=
0bf1ec9@tencent.com/ [4]
> Link: https://lore.kernel.org/linux-mm/20260217000950.4015880-1-youngjun.=
park@lge.com/ [5]
> Link: https://lore.kernel.org/all/CAMgjq7BvQ0ZXvyLGp2YP96+i+6COCBBJCYmjXH=
GBnfisCAb8VA@mail.gmail.com/ [6]
> Link: https://lwn.net/Articles/974587/ [7]
> Link: https://lwn.net/Articles/932077/ [8]
> Link: https://lwn.net/Articles/1016136/ [9]
> Link: https://lore.kernel.org/linux-mm/20260208215839.87595-1-nphamcs@gma=
il.com/ [10]
> Link: https://lore.kernel.org/linux-mm/CAKEwX=3DOUni7PuUqGQUhbMDtErurFN_i=
=3D1RgzyQsNXy4LABhXoA@mail.gmail.com/ [11]
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
> Chris Li (1):
>       mm: ghost swapfile support for zswap
>
> Kairui Song (14):
>       mm: move thp_limit_gfp_mask to header
>       mm, swap: simplify swap_cache_alloc_folio
>       mm, swap: move conflict checking logic of out swap cache adding
>       mm, swap: add support for large order folios in swap cache directly
>       mm, swap: unify large folio allocation
>       memcg, swap: reparent the swap entry on swapin if swapout cgroup is=
 dead
>       memcg, swap: defer the recording of memcg info and reparent flexibl=
y
>       mm, swap: store and check memcg info in the swap table
>       mm, swap: support flexible batch freeing of slots in different memc=
g
>       mm, swap: always retrieve memcg id from swap table
>       mm/swap, memcg: remove swap cgroup array
>       mm, swap: merge zeromap into swap table
>       mm, swap: add a special device for ghost swap setup
>       mm, swap: allocate cluster dynamically for ghost swapfile
>
>  MAINTAINERS                 |   1 -
>  drivers/char/mem.c          |  39 ++++
>  include/linux/huge_mm.h     |  24 +++
>  include/linux/memcontrol.h  |  12 +-
>  include/linux/swap.h        |  30 ++-
>  include/linux/swap_cgroup.h |  47 -----
>  mm/Makefile                 |   3 -
>  mm/internal.h               |  25 ++-
>  mm/memcontrol-v1.c          |  78 ++++----
>  mm/memcontrol.c             | 119 ++++++++++--
>  mm/memory.c                 |  89 ++-------
>  mm/page_io.c                |  46 +++--
>  mm/shmem.c                  | 122 +++---------
>  mm/swap.h                   | 122 +++++-------
>  mm/swap_cgroup.c            | 172 ----------------
>  mm/swap_state.c             | 464 ++++++++++++++++++++++++--------------=
------
>  mm/swap_table.h             | 105 ++++++++--
>  mm/swapfile.c               | 278 ++++++++++++++++++++------
>  mm/vmscan.c                 |   7 +-
>  mm/workingset.c             |  16 +-
>  mm/zswap.c                  |  29 +--
>  21 files changed, 977 insertions(+), 851 deletions(-)
> ---
> base-commit: 4750368e2cd365ac1e02c6919013c8871f35d8f9
> change-id: 20260111-swap-table-p4-98ee92baa7c4
>
> Best regards,
> --
> Kairui Song <kasong@tencent.com>
>
>

