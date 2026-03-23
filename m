Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEE71F483DD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDB076B0005; Mon, 23 Mar 2026 13:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3196B0088; Mon, 23 Mar 2026 13:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9756B008A; Mon, 23 Mar 2026 13:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA0A16B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:43:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D3F11EEFE
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:43:53 +0000 (UTC)
X-FDA: 84578050746.27.01F8323
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9F44AA0016
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:43:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=luRfH6h3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774287831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCq65lUhfb+QRcu3SYc5fMOA2qGVc3hggm3HEzC6G2c=;
	b=fF14zcvjwh1DbwEWUZwvZR9WjQMv3RMyem009Dtj0AfBK8UO0/HfeXMnkP136ozYP+r/lq
	+ITgYvM0pQPs+aCnOkowV+yK50j+wHBjNMuv3/knoAFK/0oM8mpVWHXS/cLCW4EJ1iLHRM
	8XSSeK2G3mmW2LTA0Tzk18s3QPGRkTM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774287831; a=rsa-sha256;
	cv=pass;
	b=ukZhXbLi3q/pacFM95HjH+he6Jc4PocD5amsfDFYjBqNeSm1PPEp9/xJ67ivID85qf5HZJ
	OkxHxuZjpODDYJgpRVAedPgzff+grIlR9TVDIH1ITojGzugB4SvzWQH1cZ/xKIpGNDRv7J
	9Kk4zJux5wIWABT6bJa/9IGqgLacL6o=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=luRfH6h3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-509069a7a7fso63401cf.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:43:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774287831; cv=none;
        d=google.com; s=arc-20240605;
        b=Dqm0SiE7c92X7S9Of291DxGi2kakWVtPAA4MgWTl4OwzWV74BIbpN5qKswZalIMhE4
         YPMHgzmfL98wa2gzBXpAoiFANvYgkBMBOz1W+kDWtorduyLyiPgIPL9zgqdX+pemtT2x
         w8cScFTjyNL+q4GM2YAQw2LpsGdxwk7xgjPGpB61o2n9N223YPaU13/lt+sPmJFvCohi
         cb1x+XcEfBwU8a7tdO6+ifmT118wyQ+qmIrh/eQMsIfoFlCQ0wp95anwqXe0MoBnPOh8
         CNpBy6iGvRev5wiUor3c6lsqdljWdYwjBhL3SdgZY5BpFNv+nC9M6kYRd/5gPzUqAt7/
         QpLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BCq65lUhfb+QRcu3SYc5fMOA2qGVc3hggm3HEzC6G2c=;
        fh=AivxgmAnP7mYAZqmLIQWGkMJJtM+2oF0DPwklmIUFEQ=;
        b=Dciq3RODMtFKaAlUByx1rVlMg73ebopqzECXpsLeNpwSAGspU36wWxvuU3woqxGlWF
         opmPElnajWF/aTehyWOuLucNKah6FHBHbg80As+sq5y4DtLU8acznBqvK4wGSCVOtUJu
         Vak2gBzVD3qYRy/9BaoLc1ycQjjLAESMhTOx0KlZl6ZJf3wRQj91oQNAH/i02Ts+Kca/
         U4sn83JGT40rpyRkQ1Pf7nqFLa30ALBtnVmwVXmW/IVQOLJmAfdaZWaa5xQLlQC71T2K
         dYNUlPnUb9FckmuaiH3hIX674iT+C5f2MAVBA+lMRTvfBXdm04tojBNAQbuXq9TvFtdL
         k3NQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774287831; x=1774892631; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BCq65lUhfb+QRcu3SYc5fMOA2qGVc3hggm3HEzC6G2c=;
        b=luRfH6h3fGsM13EHLO3zLrIr+gJ2x/VhCW/cZ/cmMSlHkX4EGUlTBFqph5f+fibPlE
         ZvVjmQR5CC2FLrQGXdyUxUed9YhT0cbnLSsLZbXFd/+AgbzNcYSb/6ybFDrILN6qfDRt
         5fieZ8QdsKK8SlbHDnArM2kzqzg0cxh1oqH9vICKsudN9kw1FNYIn8B5SaJzxBBz67Mt
         jb6rvZquPy0KcnJAT0NyCq7Qp5idf1C4YkfmZ3FhQVZkikh/+CAHfrm7yfSgmnat0KDX
         QxTlyO9dVC0GSVksNSDxtoA5meZ2a1+SNpCwkTUcU+p1MqmSZE0QDTth7Be/veu1CB3l
         JGPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774287831; x=1774892631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BCq65lUhfb+QRcu3SYc5fMOA2qGVc3hggm3HEzC6G2c=;
        b=Mxi6kpKWHw+Xh5gQ3LqmumLGce/TjHqquyU/Trsrdo/IHP1R0EqMa48zXzM6pKvwLG
         RvvEt/qUrzAant4qsYAMphNuiku1YlnntE21kf7pV3rGkHCuLykQTnPhqNgVo4Er5r7U
         ZVUn9fButlfYmHeBzx0SntSm8DOygm8TBFhX8Jv2pTAtXn40AFLbN+vQpFnRYU+Lexu2
         M9ed95VpPwE1BC+UJBFUjBuR8+2zkUyUX0K9YsHXpGI+J4cp5rauTBPw45pAisfcanTi
         tcNrNNFO6a+vXeLo6DfC+UJXj27lQJsAtIIFt+s3/wwZYeGoXb4uAmHizpWvz8ubDvrD
         NXeg==
X-Forwarded-Encrypted: i=1; AJvYcCWC4Lw4C83LLEG7kamN4C/dEL+++wGkOPrBXUfJLqLxSJuAsQGVgMZty6VH9nD3WGTTOx6HEZLYDw==@kvack.org
X-Gm-Message-State: AOJu0YwsCVgmuzknliHz9EEcgf2QcPpclzYLhoeJpiX6ga8ZqYmpPv7k
	GWzIm4RK6crf2QFB/pmjggnZd37rNDPWjFk51hVjCl+ioHMQnf6bo5Mf5h3BnlU6LdlXu/D4wQU
	+CJEcoIBgLQPBOjU9hfnXvN8z3TDg6tEJ3EuV5h/P
X-Gm-Gg: ATEYQzwNVdAbmLgWguB/ewmC4ZgCwFZirGvjNOHF51+iNbLQ/ca/j2dINe/I8TwMah3
	lVDfrh4VOAtODOcj+ECb3OSYDcM6pHBo1/x0+V3pgjXxtwRSj5bg3ohaZtnmwDBFKdxJvAv6htk
	T/6Hq0BbjK+89+/IDOIMQTbot+u98Pp/RNv4sgVaQdgr74aXVJCBPzKd23nKpruugKHOHG3ztN3
	xlztgSMXYO26nYs50paMjg23AJ3lG5pLLp8/hUF2XcfCUcLyS/IhhEvW3NDTu9XvaJKVyKW5hvy
	mgKYiuaDidWB3Scx
X-Received: by 2002:a05:622a:20a:b0:4ed:8103:8c37 with SMTP id
 d75a77b69052e-50b6fb96461mr691571cf.12.1774287829548; Mon, 23 Mar 2026
 10:43:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260322070843.941997-1-surenb@google.com> <65cb38ee-2815-4b11-929d-3fc1528cc620@lucifer.local>
 <CAJuCfpEm4u3viNt3hG__RbgCJBxFQpFvjx2cAE-fg3DGPfja0g@mail.gmail.com> <dd9f09dc-d1c6-4f5d-9e58-d5ca95ff434f@lucifer.local>
In-Reply-To: <dd9f09dc-d1c6-4f5d-9e58-d5ca95ff434f@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 23 Mar 2026 10:43:38 -0700
X-Gm-Features: AQROBzATssHfmB3mILFMH-ju4s8zMXclEpaPQfAhXS_N2eL0otFup8_0lBG6AY4
Message-ID: <CAJuCfpG5Jp84yYMRmr2y3RaqdgnHF-22tYFWvv44k3Wo-2xp6A@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/vmscan: prevent MGLRU reclaim from pinning address space
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, yuzhao@google.com, 
	shakeel.butt@linux.dev, willy@infradead.org, Liam.Howlett@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9F44AA0016
X-Stat-Signature: cruw8ggi61khnzogbjakk3ztr3ygi197
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774287831-160549
X-HE-Meta: U2FsdGVkX1+VO77Ei7OMpzr7xMaaYgYME9TBstOLF28puVGFvbd+3EV2OtyhxIxiImBYbd14Cp4BwUJEG4PZt56CGHN85D6HqARJJXqsO7i97G4Z0w4XS4y39Y3MZkTZdsfZFAkJ04o4af5SQPdeeDlnbc+7Sm5eE3+uAdbMBmmsr2xrI1lWifwbXBANiOL4DetpTMJoXVJ80XLSM60NcSIULTNepCWTgRQPUO+23iucbWPwyPuGJdV3Xk45kq7+8WOZX0+NrSTjMlXYuFDzIOeGxAyL2EmSjM4cjozHRRp8VcDdE2wLwTBwGwPFjUHnTH+qcxvolN62pe712p+Tesc21TUIkGLHX2JvbVlte6JNyPE4e3o+eUOsR1YC7/W0WaPSFS7XXG8HGj6hWUgQMc4l36gVAUMXXTlRWHTqdxDHf9xmvA05jvPYVAOj003dzyWI1aHvCYGfK2rDmmKFhaNp99Bogi6Wq8rPfqrr2/jsLTXsFSobSljg/RAvXaVAdiMoyp9JvZx663mQIHXaJoKlDC7wNF8fpaI73jvQGsYhSkhQSIMt14L74p6w+4VgW/ah2B0KSYHZmGB5wLlX9VawBemqP43967UDlC2+GQZfz2IOfvR+OXTHvMB2ZaqMN39I0LvWyWs+bALAxGreo4Pnuou/S6eiKrTexBjMTWOsOTX/IuElC09jvvDtR1hSgETG7mG7909IU1f1H/m9PB4RNqKGRiMV7QXxZOVBS09tycXWtZGfvSAI/JQjb0kfNHP7TAAe4TVryJbrcTYLVn9DrW/69ShZgYKcyVPNl4LHUOQ7kCDQDmPeDNV0zBnwb/3GtDB9Tc+bxY7s6Xmp1JZMJ+YLcDRTb4NkgdjGAaUAE/EXcGO9yPevIGlD/+BzVJXE+cPOKbC/MZfQJar7u2NYTICu4wJeKPdH1Ftmp7QvEA9EWOlCcj9UX1LXYOtg7o1QA03luODytfTeNVg
 aq3dKUVq
 RiRRYi3lLSXy1pYSkgokcNyhOvXnolr2dc74xohYtkWvPXmHodkF33gBfojgepx2rFZdGwkqpHRcwLppahrTp/YEOgQAK8KUi4rbIB59B5nViF4JLVvERrLsvh2DbfQSqyS/vuTPJGJDh+/A75f/BsO+tgCFw8VGTvPmiSgZTUuwqItZMrXfbsincjodtJLATd1xqWDGVF8YL8AYRGV5H2z54qJJxQYNTtJCXU51qoMg2mdIvdmsi2krB9rUxP0k1IAaTZcrDSg3KkNyY1XLlcSZjvFna5Rn0dnEXcPBURmPe8IM6eiNwCYy6Xw0Mb899tHea5eO9iaOf85GSrBctBqynRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 10:02=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> On Mon, Mar 23, 2026 at 09:26:02AM -0700, Suren Baghdasaryan wrote:
> > On Mon, Mar 23, 2026 at 6:43=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@k=
ernel.org> wrote:
> > >
> > > On Sun, Mar 22, 2026 at 12:08:43AM -0700, Suren Baghdasaryan wrote:
> > > > When shrinking lruvec, MGLRU pins address space before walking it.
> > > > This is excessive since all it needs for walking the page range is
> > > > a stable mm_struct to be able to take and release mmap_read_lock an=
d
> > > > a stable mm->mm_mt tree to walk. This address space pinning results
> > > > in delays when releasing the memory of a dying process. This also
> > > > prevents mm reapers (both in-kernel oom-reaper and userspace
> > > > process_mrelease()) from doing their job during MGLRU scan because
> > > > they check task_will_free_mem() which will yield negative result du=
e
> > > > to the elevated mm->mm_users.
> > > >
> > > > Replace unnecessary address space pinning with mm_struct pinning by
> > > > replacing mmget/mmput with mmgrab/mmdrop calls. mm_mt is contained
> > > > within mm_struct itself, therefore it won't be freed as long as
> > > > mm_struct is stable and it won't change during the walk because
> > > > mmap_read_lock is being held.
> > > >
> > > > Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > >
> > > Oh and sorry, missed this - do we need a 'Fixed' for something that's=
 just a
> > > perf improvement?
> > >
> > > This doesn't seem buggy?
> >
> > Well, if we are pinning something we should not is that a bug? I
> > didn't CC stable, so I don't expect it to be backported (though if
> > it's accepted, we will backport it in Android as it causes real
> > problems with reclaim), however if someone is looking for MGLRU fixes
> > I would like this patch to be discoverable. If you feel strongly about
> > it, I'll remove the tag.
>
> I don't feel that strongly about it :>)
>
> >
> > Thanks for the review!
>
> No problem! Working through your vma killable series atm also :)

Thanks!
I will need to respin v5 after Sashiko found a couple of legit issues
at [1] but I'll wait for you to post your feedback before sending it.

[1] https://sashiko.dev/#/patchset/20260322054309.898214-1-surenb@google.co=
m

>
> >
> > >
> > > Thanks, Lorenzo
>
> Cheers, Lorenzo

