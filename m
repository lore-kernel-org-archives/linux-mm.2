Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A03D7F483C8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04E536B008C; Mon, 23 Mar 2026 12:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 024BC6B0093; Mon, 23 Mar 2026 12:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7D286B0095; Mon, 23 Mar 2026 12:41:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA25C6B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:41:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F455BCF4D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:41:33 +0000 (UTC)
X-FDA: 84577893666.15.7A410F7
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 596171A0015
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:41:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hFY4VVJL;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774284091; a=rsa-sha256;
	cv=pass;
	b=loN2zGbBcIfDY/M+HhlUHzgW/TtzI3E8M0obB0fWEdte+KQv44Q+XQyiIozO9/sQtTaLnd
	8Us9wLS9fp/BdiNiHT0s1OsziUWdfsMVbCOraSFimrKEoFB4ap99VlW5WJQrB7xLLMKHBE
	1tNEjlORybO7GIooVKwoXPdZJHVF0Hg=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hFY4VVJL;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774284091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vmCa6NJatdq+42qe8sVhhvk4aoBatMqzy8mT5DZOBUc=;
	b=7C+qJiiOr/iWiZckC7tFFNtQ0sY2ahKe93SSiTXE9sckvfjfsS9MS4tT1D/aZqH+EYQx/O
	bU3D4i0qSVZynm22jSdzYdA12RDKttoXZcorNYERgX6szAf3DQK3xNFKuuT3gNx4WEfmGV
	N+XCj+Aa5Hg7i+aRBgCPXJKGldsrEQw=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b9825ba7e8dso53188166b.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:41:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774284090; cv=none;
        d=google.com; s=arc-20240605;
        b=fkUtDUgSvv9fJOii7iJ95ardCj1FCkc3Gk4ZwONpXY3PyJehPggUGYSgipTBp61SFU
         xx0VTHw6NNXterZobMYc93HkrvZiakipEdr7PSBlzFrNIJsNBCCY0mX1ROqz/MtBDEPg
         FJRTbmc8Z7qy7wm99cMN6xmPApgnNDNFe6wK8LcU5tZv7bQzuOC6Bo/X8MTcQCXTbZNj
         IRsf1q0r9viR4SJCs8Eb0UUo7vgEZTwDIirgOaZZO/0x8WDDvn1U9aeO+tnaNdUbaDPf
         4kh83NRK92GpOjooN38NlGR3tDfpNdMSLOuW7moMvXGU0NbG6ONrxjeiTEdtAU7DTJ6G
         JcBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vmCa6NJatdq+42qe8sVhhvk4aoBatMqzy8mT5DZOBUc=;
        fh=DOatpQH3afbVcu/eqvGbvWM9QEWpkpWxj0JkpFJ+VwI=;
        b=it0YMM3c0EyOFD46NTSRq4pl4ScZLLzAu+QG2/GOjKtJ7tSABLABl4WPQq9COY4KDE
         5toZ19vGhA4bMglW1r4qV2iRGSXFz9j3Ro11suyXd3abW6/T4zCO4KehP5bjUch8Y02v
         7IImJR1V0NNX5BkHi1rCoAuSlVIKExLwXdKIs8TYKYPhsNWNV+piUFPR0k+QrG/l8jKt
         X9l/J+x7yvvB+OEmbeSmnHmwrZ6puYkALErW3YfwQGnE2HL58UDNsrP0gseSiuYUcVTz
         bcvJi0GyCZwDlE/uuq/w/k1KhCYRJ9IbyHZb0u7sE6b+cD9co2tgSYChrwKAsujwhBYk
         Xn5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774284090; x=1774888890; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vmCa6NJatdq+42qe8sVhhvk4aoBatMqzy8mT5DZOBUc=;
        b=hFY4VVJLcxSbLb7r97CR8zEoO9P7SWgmKe5SvxtjoBhEjir5OT4xjoAliroDMJdfSD
         Oh+Ep0/yCHJ7CfOsayJx1KKfVIlOqxvJo4uIXV4ZxTsO5g/63ocpIQzY+sG8gK16cf20
         KiM3BuNf1955Yh2GnimTPFiv7URnOZzzr9y/b3QW8XU3oiCVS4kPo1+o2+vCCzOXIT5p
         X85CjLm04CeuQbvdSV796nZ0HjzZfXyDahrYWKYlbmWvRkqrM4La99Bv/ItWk4/vxKTD
         bZ3m13yZlr71S24S/qQkfEtDYs8q2Jl+XaWwIw7PTU7U57KIMVTaNm9saJrcoXsV1r96
         7Rxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774284090; x=1774888890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vmCa6NJatdq+42qe8sVhhvk4aoBatMqzy8mT5DZOBUc=;
        b=Az+lqYKD1uCdKCvnvMVWB4vYEeFAhqe3h9RHDdR6KR502u4av7gFEUM1yFGIPz52cA
         tzcmaUoFLb3kMi0SAmjRgp0ShU4RiAcVSi2hlnRMXYH8RvJX7ASjNLWLKw8Tx+nTxkc7
         e5A7PsYHq7Aawa8Aa3M/MN2leqj1oV6oXL8wSUUOwHnvkImpvv9r4BszsPQpKTBCOd88
         4zt4yJBW6CUAZYoPkFs//hlpDwO5vGxUMFcQeqrUhZnfN+tPmoZfOvHIxsHnB4fAWdVK
         cOz5QAMhbHRuwys+bHaVIo0E0dLDceCAyr4S6owKvmanCFvdCZp3e4Y12zdieDYLy31X
         ANtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXej12ZLOpfM9XZ0NWqp6Q/cmTjrWH8C9/ZkdchCNkC2G35HjbnXTVBYHVZqHsgZ/aPFCLA86VyrQ==@kvack.org
X-Gm-Message-State: AOJu0YyWD+jtxQh1RT/gL+2S8urYEpAD5XpTq4oxoaTqfyKusW0kH4Zy
	wwuu95IdPdJx/yZ//wAL8pRhzVDTmBdD39QYXEAIsVN5rWYQfAIRIPAPptCGH6bppVjOubJV56/
	IYKxPJpnd3qe13GDAjLFKG5/OgQC1Ye4=
X-Gm-Gg: ATEYQzyJAT1M7U62joOCzWvMS230wT8XxjcNVYzNdCUIDOh67TfPwc0HUaNHOJrMK6G
	+l8BHYCBk39IcC58sXj8e8+pEV+XibkE3kgrk0L5dmy/fqWcH3hpvpjz1ZdSDZ+2HiX5yOODtxc
	LE+ZtosAiJBJI484/QRvidAOwmjD9Yzy2MPYdqpe0D9Ei0App1GM/TL5T6q48fNFz1gjYc3Ne6o
	/w0f845lUnbdkmfWjU7M/g2044e9DyU50Kvdf0UH1DyhAdS9jXkliBMJtNEaUmpKjlgKsDI7/5g
	hgBXvdBurUoGYdXf9FeCWx4LxvmEOC6US2aBpUzC
X-Received: by 2002:a17:906:c398:b0:b97:1009:7536 with SMTP id
 a640c23a62f3a-b982f286a8fmr671723566b.15.1774284089391; Mon, 23 Mar 2026
 09:41:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <CAMgjq7AiUr_Ntj51qoqvV+=XbEATjr7S4MH+rgD32T5pHfF7mg@mail.gmail.com>
 <CAKEwX=PBjMVfMvKkNfqbgiw7o10NFyZBSB62ODzsqogv-WDYKQ@mail.gmail.com>
In-Reply-To: <CAKEwX=PBjMVfMvKkNfqbgiw7o10NFyZBSB62ODzsqogv-WDYKQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 24 Mar 2026 00:40:52 +0800
X-Gm-Features: AQROBzD1kpskNn11W5HqnEfFhEQur5XfLuCkDmtbLopJRo-HyQHAInVqxx1Q2Xw
Message-ID: <CAMgjq7AzySv801qDxfc8mEkEsFDv4P=_qw0rNOTe0n+qy7Fz6A@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Nhat Pham <nphamcs@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	lenb@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev, 
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 596171A0015
X-Stat-Signature: ftyjagsmeersx7zm8jfwmnt6zrygxbrc
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774284091-230881
X-HE-Meta: U2FsdGVkX1+qATwZptpNPX++5wD9LOdCplr0AgJmmISIbc37qDsRjYwhvrpZWNRck2LV3xH4iacDr24zWQBqqexOOHv7L5qCMQc4rVb88GVowSNbMRhpAn0J59GeKcYbatI4f1RXLyttS6rUcLif2MQqZX1AJr8KgQtNaKIvqv2W71fl8dyGfCs/Ry/TqiUmCrj2guwrSrA+qmn+s1WQaBlJLtiXOCTbEyuJhIEKpwPga2H1yJV+wXsQDy8IbkwBzBlNjdOBTzeSne7CNuvoOlH0IbbbYhPqnzaO37ise3ncbLRV/UbLLPQ4TaHzm65oNktos2/gjLH8PUZFxrJklsCS5jI2Hkl8JrogyI7Oi3zs625R0EeI0YRmqvdycZcPxD+qBdcVxq92sEuBOMvatMC0au82JwInGluvpBSzBNoywVQ1guJtkF9JGHmBEen51o4tbohuBnfxKb80Pg7qWCnjMKlbvNJVZdLTYNFjJTV0qb3ernn1eBkDStk/iFE0B85V+E4jXExnFbjMeRfNGX1XKZTVdHsPR1eXbp+JqgQfizqSvbVSDb0Kbh+q9BDV/MZumCVQ+9+eyXJ3kCnLpRn1BZj2fFt6KfxOKJY/QCdrlVEJ/+mEwXq53oXwt7nLN9nXzXnE6cKmICziemYHdznjqQ+D6xJdOr55hG7MVOmFWC6eOyJXjJillSIPrTb9ksXGmaE+7HcXglzwE8WTJMW+6QhBfq7xFU2zXy8KTimOcOPsXWUtnWvBSEB06gXV0yrIYMf2iZ3xMPqJKqfxBLx7lB2C18GaqXbbrdgxyaGYJhf1GVlrtInbLoaI7XCWGv8ZixsmyyHcWepwfrOBQNfA0H+1NXpdStX29fEv41pB3Z3/2yLq4iAhnIEIFvpOWABCCojh5oc5EastWUhAXX/dV0bY6738mi4qfwIngPjG7MERdRb6WzUHkZDEFv6NgSz2Pa+uLvRfdcvogaL
 IN9ftSbT
 ezrquxD6sQEwLbzMSZIWGVDeF19HDPapgxN97TKkCnA17hgcP0TX7YtNe2LyJUKc9k7dvRHo3hVYhAQecCd4Wn4GW3CojSTwQK/CZ9Et2lBHbggI1FHoiKzGS9FNgN/sHNdXo1gn3LqJmyaX0b4KUOe2zQoriOdfHkdd+D90opbadFAqqyijxpPzKkeKkKJ76j3AEi9GzgjIVeMJp+uBQUNYOHxB6l3ECBEdG87CfAi8scTl0yC6kWjFMTuQ6Ims51RYOl5/l+5f7zCi9rfA9IGZvTRhwEjFKS9UCz1OCfu0OA5NGcRHJA6Y3fxcbnxzKrcY6m5Sw5blHLP0HFDldLlXyqN5s+NrAYOY2i2y5E7RLTCZrBm+3sa3pxDGQfnUaRvzRFL6i+ooDc0tx5wrZhe5nygejeWUDW2fxW80OrUjz80VDvqSKA2B+TjxJwuzMJVi7Gg5uutBRlklUBDJ05U01XDiNLKrjc91lwI//i4zYCM7HtIHuyFf35qW/1ZRBKY9mBpil9ZNVaIq3qFTqCz178pO3dmOF0nrIvm1Dj62fmTRiMx3Miiw/NHMlRG2xJA13wJFDayt8WjN8+Oe6gGimYzTSEQBUO0nFTEbLH8C5Jznza8G4/zoiWewjrt39qc6ZMtXCS9VpeV1nsKegvAEvfCrcJ3R841Slp4ZxuqOYGpbTIDMCyTZmQV/gLHn1rzoP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 11:33=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Mon, Mar 23, 2026 at 6:09=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Sat, Mar 21, 2026 at 3:29=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > > This patch series is based on 6.19. There are a couple more
> > > swap-related changes in mainline that I would need to coordinate
> > > with, but I still want to send this out as an update for the
> > > regressions reported by Kairui Song in [15]. It's probably easier
> > > to just build this thing rather than dig through that series of
> > > emails to get the fix patch :)
> > >
> > > Changelog:
> > > * v4 -> v5:
> > >     * Fix a deadlock in memcg1_swapout (reported by syzbot [16]).
> > >     * Replace VM_WARN_ON(!spin_is_locked()) with lockdep_assert_held(=
),
> > >       and use guard(rcu) in vswap_cpu_dead
> > >       (reported by Peter Zijlstra [17]).
> > > * v3 -> v4:
> > >     * Fix poor swap free batching behavior to alleviate a regression
> > >       (reported by Kairui Song).
> >
>
> Hi Kairui! Thanks a lot for the testing big boss :) I will focus on
> the regression in this patch series - we can talk more about
> directions in another thread :)

Hi Nhat,

> Interesting. Normally "lots of zero-filled page" is a very beneficial
> case for vswap. You don't need a swapfile, or any zram/zswap metadata
> overhead - it's a native swap backend. If production workload has this
> many zero-filled pages, I think the numbers of vswap would be much
> less alarming - perhaps even matching memory overhead because you
> don't need to maintain a zram entry metadata (it's at least 2 words
> per zram entry right?), while there's no reverse map overhead induced
> (so it's 24 bytes on both side), and no need to do zram-side locking
> :)
>
> So I was surprised to see that it's not working out very well here. I
> checked the implementation of memhog - let me know if this is wrong
> place to look:
>
> https://man7.org/linux/man-pages/man8/memhog.8.html
> https://github.com/numactl/numactl/blob/master/memhog.c#L52
>
> I think this is what happened here: memhog was populating the memory
> 0xff, which triggers the full overhead of a swapfile-backed swap entry
> because even though it's "same-filled" it's not zero-filled! I was
> following Usama's observation - "less than 1% of the same-filled pages
> were non-zero" - and so I only handled the zero-filled case here:
>
> https://lore.kernel.org/all/20240530102126.357438-1-usamaarif642@gmail.co=
m/
>
> This sounds a bit artificial IMHO - as Usama pointed out above, I
> think most samefilled pages are zero pages, in real production
> workloads. However, if you think there are real use cases with a lot

I vaguely remember some workloads like Java or some JS engine
initialize their heap with fixed value, same fill might not be that
common but not a rare thing, it strongly depends on the workload.

> of non-zero samefilled pages, please let me know I can fix this real
> quick. We can support this in vswap with zero extra metadata overhead
> - change the VSWAP_ZERO swap entry type to VSWAP_SAME_FILLED, then use
> the backend field to store that value. I can send you a patch if
> you're interested.

Actually I don't think that's the main problem. For example, I just
wrote a few lines C bench program to zerofill ~50G of memory
and swapout sequentially:

Before:
Swapout: 4415467us
Swapin: 49573297us

After:
Swapout: 4955874us
Swapin: 56223658us

And vmstat:
cat /proc/vmstat | grep zero
thp_zero_page_alloc 0
thp_zero_page_alloc_failed 0
swpin_zero 12239329
swpout_zero 21516634

There are all zero filled pages, but still slower. And what's more, a
more critical issue, I just found the cgroup and global swap usage
accounting are both somehow broken for zero page swap,
maybe because you skipped some allocation? Users can
no longer see how many pages are swapped out. I don't think you can
break that, that's one major reason why we use a zero entry instead of
mapping to a zero readonly page. If that is acceptable, we can have
a very nice optimization right away with current swap.

That's still just an example. bypassing the accounting and still
slower is not a good sign. We should focus on the generic
performance and design.

Yet this is just another new found issue, there are many other parts
like the folio swap allocation may still occur even if a lower device
can no longer accept more whole folios, which I'm currently
unsure how it will affect swap.

> 1. Regarding pmem backend - I'm not sure if I can get my hands on one
> of these, but if you think SSD has the same characteristics maybe I
> can give that a try? The problem with SSD is for some reason variance
> tends to be pretty high, between iterations yes, but especially across
> reboots. Or maybe zram?

Yeah, ZRAM has a very similar number for some cases, but storage is
getting faster and faster and swap occurs through high speed networks
too. We definitely shouldn't ignore that.

> 2. What about the other numbers below? Are they also on pmem? FTR I
> was running most of my benchmarks on zswap, except for one kernel
> build benchmark on SSD.
>
> 3. Any other backends and setup you're interested in?
>
> BTW, sounds like you have a great benchmark suite - is it open source
> somewhere? If not, can you share it with us :) Vswap aside, I think
> this would be a good suite to run all swap related changes for every
> swap contributor.

I can try to post that somewhere, really nothing fancy just some
wrapper to make use of systemd for reboot and auto test. But all test
steps I mentioned before are already posted and publically available.

