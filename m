Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA182CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 18:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C00A6B049D; Mon,  1 Jun 2026 14:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46FFA6B049F; Mon,  1 Jun 2026 14:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 338846B04A0; Mon,  1 Jun 2026 14:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1897A6B049D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:06:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA2D84025D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 18:06:53 +0000 (UTC)
X-FDA: 84832124706.07.7527037
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id B9A91C000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 18:06:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gaHApvla;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780337211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+NcOvINeD/X7jg493pqLpYD2a6ETdaWQNv9IdTEDm4=;
	b=gX/8lQ3ry07cU1y+UjAhofgQdH/unUhhkR8URr0V0joNQr+DY4ipFY+lLM4MSrBHhsn+xD
	DPcopy4mxyMEfeHXZj1hwCpltAdolMIu+4Appm0T3EEYmK9UweB2NoSSQnXxKq7RqyzG0a
	OkdwNxvYzdxjUWBwoHWHFDFEohvvy5U=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gaHApvla;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780337211;
	b=Zw96GZ7XaQsplbSb5r6FzfGOAuxOOLrZ/0Ik6sHm3NjOiBJ5zidHyQ8WU6sBflhdzZg5q4
	Bd16JzeCO+ZY9NOhenbiEiQ4hhK5Ax4kwyq8zznActhC0RBkzKIpQvKKzpJsOgR8tYGqbN
	RamELgK65FP8TtIHxUGi0SIY50hwAc4=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-45eee266c6cso3115870f8f.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 11:06:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780337210; cv=none;
        d=google.com; s=arc-20240605;
        b=QfFARIXybYfJB7frQY2SOTTfs8/6+4Qko+dLyUmk7WI8kimVsreZfEoUghQPM58H4u
         56UzwOoTCkfLcJ/CuUUuy/kmTR/hyRiRBzZgBmx9SMXDpf4LE0ntUDijMq4AqQHSOsKl
         Riwx7fPKeJHiKQ4AVyKuInKcubh1iqYwnE9BM55U1LIYm+bW4uUcUrvyak2A05Ys06Mr
         C7Nou77EOZg/lnlxgSBy13WgpE5gkhIuWt929VMk4AGX2d5i+L2udgHLVCSVx02+ZayA
         l4QYEPzd8hgyuBM6WRvmVXRdvrF9h3Jkn5fCtaF0bFr309XC2gM+9PB1S61sPmQM3V0K
         LhUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k+NcOvINeD/X7jg493pqLpYD2a6ETdaWQNv9IdTEDm4=;
        fh=YRdvu72CKc/dzEGL3WFueKRvbteTkWBZbkpTuyWOtxk=;
        b=lzJByS4D0qvx0XxVKeGN1eFt8MNBadFByUhCwkWf2u+DAqSR6Bip3Cc0eAysowjB+6
         10hCJrMOdb6bedKNdSFDuu+4VZDxlmedaOJMfIIM2lZEYzNwKBHf7rjWUvkM1/ryEtVf
         2LqjYcPvVPf41vs6qKfidSyoEooN8nBVWZmrtL6nyBfPDwgavqTbXZh96FCkJ2uXXD1f
         h6ydNRk/WIA3AljilJg0hccxxnT//wZVBB2TvZx9QjrNN5Zys5vG50YlSHTQuwyR/M8t
         eNGzk06nol/gXLt/qcPvL8xfY38corpbU40MMT11YDRH1hntmtrR9yV4dYq6t415BhbY
         bFIg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780337210; x=1780942010; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k+NcOvINeD/X7jg493pqLpYD2a6ETdaWQNv9IdTEDm4=;
        b=gaHApvlaIjAsi36/tR9rhtPUsaETubZeIJqx5pFBKDSSsfNjpqLtBsHFuWxWilAoNz
         +fDMw1COv++X/FCxC/ptGYEk1ohX18U/smiTMMiJpX3k7tcp6FK4JYz6gWuxzhMOklyY
         wRd4nlm4Ka4Q1F/RLQ5f7WaY3XAHugVNAjidlWZn8BUbtaveVariNwbWMxQ4lQCJnntj
         3O9NMsxLzmicFHRKawV039C3VNxGydE6HuENZQVDEQocOzJa2Kz71+E2MHWrS07NesAn
         C+O0CPIc1J4U9q96K0k4FC9ACbOoLEpJI9xHLEHZReIfhbBHSPp79Bdco0rUwFHfyY1b
         Bxww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780337210; x=1780942010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k+NcOvINeD/X7jg493pqLpYD2a6ETdaWQNv9IdTEDm4=;
        b=WjcyduErvaUjYUkTBDd4TdnleIH7Zi2EADdzu5fqIkJiQDeK7aeWrCdWhkxsys/anh
         TE4AJWd+cv7TEcIeDfUJ4GwZDyZ+vZwF6JUP/GwKc1F6kDbR/XmDor+fdtBiPc80zqE8
         OIL1UkNEgA5KPBjx6kxpawL9IJMRiJWK/6XyF0xPF5ABA3SBYFSwD8r9gK2voTB5a2CZ
         YKiu9OVwJZoFJFLLCjkli4WkhoBrbmvqJNr4P0EGcALNWZHSG7yywHXCj3mJsS9aE84B
         GmW3gmc45WMJmhe4xgNWhnUysQZt9OQqz329e58Nn+ERP1qOerWxZbMKg+PIysR+emmL
         ipDQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Cun2GCE559k4TzJ5G1sc+tugtYecP5AePAhDIgFqJKswA4S2jAxg9irMeKsEwygYdt+HLL2FRQA==@kvack.org
X-Gm-Message-State: AOJu0YwlQj8IExf7BpKcP/I+KEcDtJCZAhPbmcAxp8xYwBS6ppCK6sux
	xtmaehoT/XiSnwp57/1li7VJ3h7S2OJjWxO2B2ianEpmRPZSKvmb4AvqCa2uz5JSM+OhHaP175q
	b5hnR56evC3XU4AYHVo7FQAiYg3nHLTg=
X-Gm-Gg: Acq92OH7DQUFkFgTREEqdi9okyyXmo7BjwFeojqn+y7G9ydluhywRvbdiAJOlO6GYBz
	FCj3BDiDa53bY6MEZGU14goslbo0KajzmdS3d/pUGA647L1s2AHHSYnxPFpWrKoOAkgDXOrMHam
	KXujqwOz5rJltOuJQ5bQFmeoPmoa2wNo9HUsuI7ns3yJoV1M7pMOsKMebxsiFxiQquFM5eukT24
	CTueUVAPU1MJrVQNuejbwgpTAOVbg1Sazl0+xHnW7yQW4eQttUHjRBUNWHFY1Fikys7i4fV6hnf
	78LS7zku9npJu667cBh7a0GFTtIB6Nc7OlOQ52XQT3xxh0Vrsg==
X-Received: by 2002:a5d:58f6:0:b0:45e:e50e:3bc with SMTP id
 ffacd0b85a97d-45ef6b71573mr17744808f8f.29.1780337209883; Mon, 01 Jun 2026
 11:06:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260528212955.1912856-1-nphamcs@gmail.com> <ahz_iYG4lqWL4g-J@KASONG-MC4>
 <CAKEwX=PzMwXXgq=ULAkFD9UqMz+ewLqhKt+xdGxkV7OmA2QG6w@mail.gmail.com> <CAMgjq7BhOn48xEyC=2j837R7qddfjeBVHMiRqdx8no4ZEBpBLg@mail.gmail.com>
In-Reply-To: <CAMgjq7BhOn48xEyC=2j837R7qddfjeBVHMiRqdx8no4ZEBpBLg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 1 Jun 2026 11:06:36 -0700
X-Gm-Features: AVHnY4KpgrZEoyhjTsiexcEZOQjS_1bg9H_7TW6-dFwfjU3rgggaOz11SKO19Jw
Message-ID: <CAKEwX=PmwzaJhfjBrho3+kQ8HXFUC0WiegQrsguBc-_pmn5bSA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
To: Kairui Song <ryncsn@gmail.com>
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
	riel@surriel.com, haowenchao22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B9A91C000A
X-Stat-Signature: 8uixbyoiaio7skw9ekdxeac781u8pfsc
X-HE-Tag: 1780337211-745349
X-HE-Meta: U2FsdGVkX19+RJjWeIdu4vX+sIdkzG8Fv5tWMn+R99D8u0lHz3va0TeHM3QfIyY8ScUzWne+vXbic7tI1m3m4tGN0yRGwhFMuizsgJ4jt+qgP/oElbfbOurtatJvNQgmdAxo2RaCbGCwW9B63GCiZ/y9pQPN9icSq52RfNm8I7lpdwFxf3mWjhFJ8yhoWPilPpZhZ1QrqL3r0Gb/JeUnp/4Rm1W/+SrI+MfZzT++FyApOCxI2C0TFXd6OJeCYl+mHaNQTtPPODH6uv82Zg+eQWnOkUMNdJ7Z/ewdnbcDJoGhUr1sNJml10IbFDzaerwwA2HTYmi+Ae9F3UeK+T88Shtd9c4wT1yjmj6d9rC3Q3VUz4AbkqV5ikrkFWrw0bMlFztKhG/R+z1QdB1QnY8JxBbgkBqJvaSQI8ZG8T/eB67exGV/6j7+x1tSYAjCcDYkxFPuUQxppJYc8nXXImy2LD89Aq9JdF1ylrHvKx9tPHoeB6nxJh1T0Psh5V+D2c9dGrYCFkrvwJ5NAIbvtcAD7XY6oo/mYJJpkEgfF+kZg0n4IaftFtHVLKfa2SyOtxbPo6d8kpTpTRD3sZ8y/GMReqqY3fSJp6qJfEvx6vxdFrTaPx10jvMWgcliY+oQgEJ379t/NqnPo6i6/8OapDyOwmcCKzZBP9fUuqNOZuwiilaDvvYqeCgbS7Ispt7diIqpkHMfW1TdWYCMClb49viMtRji7DZtF+yKyJjMbcV8GyzDjg0FNQcPfcYkP/O/L+7wsq52l9AvyilkMmMYY55A4jClIgtIK8Ye4Lz7AZn/W9NNIguoAa6txbtUXcrrHc/AosoMEA5jHyW3xy67mb2F8jafSQ1WryAHIDmyyV6nl2I9jmKAZCSxx2BzzAJ15zP8ws67VTvj/5o7bNaDRKQEZMmvydLI8HeGNQwTrMM1GIweefPwkEEKdlwP/ub+jv2nBR2sADiciEUnMwi0Gcq
 U8JC17R8
 Z/KL0dtF+ZEmAwx6if9Wow7MEQkuGGIE08/CLaEHimiqOx7n4oHhzWBl4HZucVSH7E80T/M45tP2NkvGZTWKUrGnFrMGDW1AkSxnVnnKI+sKlzLGz3PtkmSNjwE9sYgdZtk1TCqq02Ak/EwDM7J6hx7iTSeFe+UwUL7J3x52RyMpVTfHzI9grf0CSfcwoNVyWJPsRq9CULMT7yfqfOIj6wTZee15yEkmsgJwxDN7x8dH0k5OxzCSDzuQ6lwRIp4sACAm9ntVKaU0s1RiRhbKF00YmPAekBx1SrqF3FJNHtPJH8Z7//5Pg7CU8rtjRd7+W4KnEz6JFcxMxDZRdfr2meb3jjeyWtNEeFlpyMLCfD7XdnGVlZfGxQFzeHq+7+XsssQQsc6taq5TAxsRKUG66fqT/bLjMjetrewuec2sE6CiVDtXDhfR/K1aAHJcL8KtfYCyL6yLJbSEo7cBEIHVlQcjkdIxOAz+HNmP2r8tq0ivJPo1nnr0TF+7fda7nCb/8L17Vc2wsQC7Oc3mboY3ya2g7+6GD3KxuD6xk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 10:45=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Mon, Jun 1, 2026 at 11:57=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Mon, Jun 1, 2026 at 12:34=E2=80=AFAM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > For the format part, PHYS don't need that much bits I think,
> > > so by slightly adjust the format vswap device could be share
> > > mostly the same format with ordinary device.
> > >
> > > For example typical modern system don't have a address space larger
> > > than 52 bit. (Even with full 64 bits used for addressing, shift it
> > > by 12 we get 52). Plus 5 for type, you get 57, so you can have a
> > > marker that should work as long as it shorter than 1000000 for PHYS,
> > > and shared for all table format since it's not in conflict with
> > > anything. You have also use a few extra bits so a single swap space
> > > can be 8 times larger than RAM space, and since we can help
> > > multiple swap type I think that should be far than enough?
> > >
> > > Then you have Shadow back at 001, and zero bit in shadow. The only
> > > special one is Zswap, which will be 100 now, and that's exactly the
> > > reserved pointer format in current swap table format, on seeing
> > > si->flags & VSWAP && is_pointer(swp_tb) you know that's zswap :)
> >
> > Are you suggesting we merge the virtual table with main swap table?
> >
> > Man, I'd love to do this. There is a problem though - we have a case
> > where we occupy both backing physical swap AND swap cache. Do you
> > think we can fit both the physical swap slot handle and the swap cache
> > PFN into the same slot in virtual table? Maybe with some expanding...?
>
> I don't really get why we would need to do that? If you put the PFN
> info in the virtual / upper layer, then the count info, locking, and
> all swap IO synchronization (via folio lock), dup (current protected
> by ci lock / folio lock), and allocation (folio_alloc_swap), are all
> handled in this layer.
>
> The physical / lower layer will just hold a reverse entry on
> folio_realloc_swap, or no entry at all (no physical layer used, zswap,
> or after swap allocation but before IO) right?
>
> Looking up the actual folio from the physical layer will be a bit
> slower since it needs to resolve the reverse entry, but the only place
> we need to do that is things like migrate, compaction (none of them
> exist yet) which seems totally fine?

All of this is correct, but consider swaping in a vswap entry backed
by pswap. There are cases where you still want to maintain the pswap
slots around backing vswap entry, while having the swap cache folio as
well.

For e.g, at swap in time, we add the folio into the swap cache. First
of all, we need to hold on to the physical swap slot for IO step. But
even after IO succeeds, there are cases where you would still like to
keep physical swap slots around (for e.g, to avoid swapping out again
if the folio is only speculatively fetched).

So you have to make sure we have space for both the physical swap
slot, and the swap cache folio's PFN at the same time for each vswap
entry. So we still need the vtable extension (well maybe the other
approach I mentioned could work, but I'm not 100% sure).

>
> > > This could be imporved by per-si percpu cluster. Both YoungJun's
> > > tiering and Baoquan's previous swap ops mentioned this is needed,
> > > and now vswap also need that. If the vswap is also a si, then it will
> > > make use of this too.
> >
> > Yeah I made the same recommendation when I review swap tier last week:
> >
> > https://lore.kernel.org/all/CAKEwX=3DN2XcMHN1jatppOk6wnmz-Shab5XMtTtzgY=
OzRvU_6YFw@mail.gmail.com/
> >
> > I like it, but yeah it will be complicated. That said, I think not
> > fixing the fast path for tiering/vswap will seriously restrict their
> > usefulness. We don't want to go back to the old swap allocator days :)
>
> Thanks. Not too complicated, actually our internal kernel
> implementation still using si->percpu cluster, and use a counter for
> the rotation and each order have a counter :P, it's a bit ugly but
> works fine. It still serves pretty well just like the global percpu
> cluster, YoungJun's previous per ci percpu cluster also still provides
> the fast path, many ways to do that.

Sounds like something that should be upstreamed? ;)

I was concerned that you might deem the overhead too high (so I came
up with the per-tier percpu caching), but honestly I like it a lot.

>
> >
> > >
> > > YoungJun posted this a few month before:
> > > https://lore.kernel.org/linux-mm/20260131125454.3187546-5-youngjun.pa=
rk@lge.com/
> > >
> > > The concern is that some locking contention could be heavier, or mayb=
e
> > > that's just a hypothetical problem though.
> >
> > I don't think it's hypothetical. At least with vswap, it's very easy
> > to get into a state where the shared per-cpu cache gets invalidated
> > constantly if phys swap and vswap allocation alternates (which is
> > actually very possible under heavy memory pressure), hammering the
> > slow paths...
>
> I mean if the per-cpu cache is moved to si level, then whoever enters
> the allocation path of a si will almost always get a stable percpu
> cache to use, even if the last used si changes.
>
> We might better have a more explicit per si fast path for that. The
> plist rotation should better be done in a different (will be even
> better if lockless) way.

Exactly! That's what I'm thinking too. Basically I'm special-casing
for vswap here, but if you're happy with generalizing this for every
si I'm happy with it.

>
> >
> > >
> > > >
> > > > - Runtime enable/disable of the vswap device. To be honest, I don't
> > > >   know if there is a value in this. My preference is vswap can be
> > > >   optimized to the point that any overhead is negligible. Failing t=
hat,
> > > >   maybe we can come up with some simple heuristics that automatical=
ly
> > > >   decides for users?
> > > >
> > > >   In this RFC, CONFIG_VSWAP=3Dy means the vswap device is always cr=
eated at
> > > >   boot, and CONFIG_VSWAP=3Dn means the vswap device is never create=
d. This
> > > >   *might* be enough just on its own.
> > > >
> > > >   Is a runtime knob (sysfs or sysctl) worth the complexity beyond
> > > >   these heuristics? I'm not sure yet. Maintaining both cases
> > >
> > > I checked the code and I think it's not hard to do, patch 1 already
> > > handling the meta data dynamically, everything will still just work
> > > even if you remove vswap at runtime. The rest of patches need adaptio=
n
> > > but might not end up being complex, it other comments here
> > > are considered.
> >
> > Yeah, it's not terribily hard to do. I'm more wondering if it's worth
> > the effort, both for the implementer and the user :)
> >
> > As I said here, if we want vswap, just enable it at boot time and get
> > a vast (but dynamic) device. We can make it optional per-cgroup
> > through Youngjun's interface, and that would be good enough?
> >
> > >
> > > For patch 2, a few routines like vswap_can_swapin_thp seems not
> > > needed or should be moved to __swap_cache_alloc? VSWAP_FOLIO is
> > > same as swap cache folio check, which is already covered. Same for
> > > zero checking, and VSWAP_NONE which is same as swap count check
> > > I think. That way we not only save a lot of code, we also no
> > > longer need to treat vswap specially.
> >
> > Unfortunately, I think a lot of this complexity is still needed. Vswap
> > adds a new layer, which means new complications :)
> >
> > For instance, I think you still need vswap_can_swapin_thp. It
> > basically enforces that the backend must be something
> > swap_read_folio() can handle. That means:
> >
> > 1. No zswap.
> >
> > 2. No mixed backend.
>
> If mixed backend means phys vs zero vs zswap, then we already have
> part of that covered with the current swap cache except for the phys
> part (zswap part seems very doable with fujunjie's work).
> swap_cache_alloc_folio will ensure there is no mixed zerobit, it can
> be easily extended to ensure there is no mixed zswap as well
> (according to what I've learned from fujunjie's code). Similar logic
> for phys detection I think.

Yeah it's basically generalizing that check, and handle the case where
we can have indirection.

I mean I can open-code it, but it has to be there :) And I figure it
might be useful to check this opportunistically (at swap_pte_batch,
even if it's not guaranteed to be correct down the line) before we
even attempt to allocate a large folio etc. to avoid large folio
allocation.

>
> > > For memcg table allocation, on demand seems a good idea, and actually
> > > we are not far from there, I tried to generalize the
> > > alloc-then-retry-sleep-alloc in swap_alloc_table but still not generi=
c
> > > enough I guess.. Good new is the allocation of the table is already
> > > kind of ondemand, just need to split the detection of these two kind
> > > of table.
> >
> > I have a prototype of this, but I have not tested, so I do not want to
> > send it out. :)
> >
> > TLDR is - I still want to record the memcg for vswap (just not charge
> > it towards the counter). So we still need memcg_table at both level,
> > generally - just not allocating until needed (basically if a physical
> > swap slot in the cluster is directly mapped into PTE). You can kinda
> > tell, since you pass the folio into the allocation path - with some
> > care you can distinguish between:
> >
> > 1. Virtual swap, or directly maped physical swap -> need memcg_table
> >
> > 2. Physical swap, backing vswap -> does not memcg_table.
> >
> > Another alternative is you can defer this allocation until the point
> > where you have to do the charging action. But then you have to be
> > careful with failure handling, and need to backoff ya di da di da.
> > Funsies.
> >
> > I think I did a mixed of these 2 strategies. Anyway, I'll include the
> > patch in v2 (if folks like this approach).
> >
> > >
> > > Mean while I also remember we once discussed about splitting the
> > > accounting for vswap / physical swap? If we went that approach we
> > > don't need to treat memcg_table specially.
> >
> > For the charging behavior, I already have a patch for it actually in
> > this series (just not the dynamic allocation of the memcg_table field
> > yet).
> >
> > Basically:
> >
> > 1. For vswap entry, not backed by phys swap: record swap memcg, hold
> > reference to pin the memcg, but not charging towards swap.current.
>
> Maybe you don't need to record memcg here since folio->memcg already
> have that info?
>
> I previously had a patch:
> https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-7-104795d19815=
@tencent.com/
>
> The defers the recording of memcg, the behavior is almost identical to
> before, but charging & recording should be cleaner and you don't need
> to record memcg at allocation time hence maybe reduce the possibility
> of pinning a memcg. I didn't include that in P4 just to reduce LOC,
> maybe can be resent or included.

That works-ish when the folio is sitll in swap cache, but say if it's
vswap backed by zswap (and the swap cache folio has been reclaimed),
you need a place to store the memcg, no?

Just seems cleaner to centralize this info at vswap layer when it is
presented, for now anyway, rather than juggling this on a per-backend
basis.

>
> > 2. For phys swap backing vswap: charging towards swap.current, but
> > does not record the memcg in its memcg_table, nor does it hold
> > reference to memcg (its vswap entry holds the reference already)
> >
> > 2. For phys swap directly mapped to PTE: charges, records, and holds re=
ference.
> >
> > The motivation here is I do not want vswap entry to shares the same
> > limit as phys swap counter. If we think of it as "infinite" or
> > "dynamic", it should not be capped at all, but even if it is charged,
> > it should be something separate.
>
> Good to know, it's not too messy to make everything dynamic, but if
> our ultimate goal is to account for them separately, maybe we can save
> some effort here.

It's not terrible, TBH.

