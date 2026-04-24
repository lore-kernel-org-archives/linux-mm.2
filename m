Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C92CFED3FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F1266B0005; Fri, 24 Apr 2026 14:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17B9A6B008A; Fri, 24 Apr 2026 14:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C696B008C; Fri, 24 Apr 2026 14:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF12D6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:58:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86CF51402DF
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:58:47 +0000 (UTC)
X-FDA: 84694361094.18.68C7BBF
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 817741C0011
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:58:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E667fXTV;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777057125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k6t4eZkeokPoyA8oRZ55oWxWJC7v0XmU5akNG3U8o98=;
	b=RTWqPEizc3s5W4M1lVLL9RzYBx4LXITqHpD4yk7cTWcMIIQtaT4p4r6XT/Fn8CaU0hseT4
	xVM1XRtgJlC6N6VXywPOQScc4IF/xLdUjBIe3DdJLK+EYz47Dg9vZhwQoHSS4iAM55r8U0
	nMRZjrTJ9jpLG8ekwJpzh6c7fcc4Cc0=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E667fXTV;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777057125; a=rsa-sha256;
	cv=pass;
	b=XRH1Y5nWyd9mySexZDU1CF9KX/K6dTQkNN3WeB66Ih5j296Opoy3HKgywxE7QNkmgOFiDf
	S+IDl4N9QNTB4AXY/vZ7fyHVQjyWcVNZa3PZz4KBdBtlyi8Yq8yZYBKFbQFCDtddMKfkwa
	UaShJOyS6w0r/+7rVP79xwHnceVZQAw=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ba3115fe0d5so1495815966b.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:58:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777057124; cv=none;
        d=google.com; s=arc-20240605;
        b=MzwrtJH9XUZSvGKvEYNCcUrg5GEZX4ZdR+22RJ311S926RP0WufIeOMrql+o/7Ps3/
         xh/ckomIrB0N+2VIs9mNqNFkmcQAbmWXMaithVW6QDvHhXTSHMHdJ4u0Tfy13mAT2dBA
         Dr7gq8X76UPQrl5AiKYVq4heUIn/6tXlU07l2qkCH8l07AF/oGqc5ThMAigkRT9F9D2A
         91G/yHWih28MB+7bGEj0ncy5mHQvj2FPNaehKKBNaZMrRxwTstM0jJK8/RI94qyqu1/y
         GsCUHP3JbaNYD9x2UugD0gCjcdAKM9YbyZHegr1wwMKpY0N12yLG5ReDu2wkoumqQg9V
         QRAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k6t4eZkeokPoyA8oRZ55oWxWJC7v0XmU5akNG3U8o98=;
        fh=h5XsPSll8U4zaOpMO49pRHeAt5oj1ddHekMcZKHoNcc=;
        b=TAOa5f9trzGd+O5zfkG9gx66GxPtPmhAw35/+mHSPkhKyavPOy4THzlf86osYPShUO
         dCkvTS5YV5cLwffRLpAxEwvh86zV/7kQ46s0my8iqg6rbp35LSNcA+CmETlW0yFp3an+
         OOUJKDfhXQkGK06XeUIid5WlTXd2OZCjdeDcabyQ9kTbPoOj7+a+nRCiI/BLwzYn1ZHg
         JpOdyYMLvi0xsdz5JzBe5Gkm0dCxPVxJfdHnqLJvuCW7s2AyHJabGS5IJAedMqUGkZs2
         IAeiTdn4gPQI0EvhUJ5uzMX8dmXDJlZhpnoQLbLSssRRmbazDYSzR/xozTFOpN056HSE
         tFTg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777057124; x=1777661924; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k6t4eZkeokPoyA8oRZ55oWxWJC7v0XmU5akNG3U8o98=;
        b=E667fXTVdprrP+RoiiIeHQRBL9Ssnvdsf13oTNhTbGCASlubyI4IyFEm2hQkVgggUB
         Z5Gv6uZ36k5ZtoYMXQ0EXY6xIr7hcyRa3pPa7QNJ3gqQedW1w8TuB6Z0l4Y9YujhCB4c
         EWjhiibZcR/UKdjwYv92aq1uf4GsMxfwpwDI/NrPNWar2HZpVsNQcrRnxvKLDFHflclM
         9yY635wERQIv/iHW6yZauqjq9QHTkWWgYIhmAipt2Y2fO/cZVA7SXcKQailVMyZJik7l
         Mt2kNfGly9aq77DUEQS+7rpznLe9H29OPMn0UKj72aQ1hVl41nBONDgw5Ea+LwfBkzRm
         aVcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777057124; x=1777661924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k6t4eZkeokPoyA8oRZ55oWxWJC7v0XmU5akNG3U8o98=;
        b=ro8TX3uzrZ+b2uQHMyis7GpWntniVkcHg/Gi1WO4rMf+hd8kfTjpNF+WGxwZKoVrPM
         k+8F7DnI7Oy6cJ1gP/7HRw+y60YHlZdA2ayxPEszgbJhv1vSKTwFQRk+1Atx0e3bWD52
         Es+byCUSrlFEewDx788/vsIx4Niz+hopnTKyIpK4boz/qSnxaklAvYjulnL4Nn75fcrW
         x/Ct/GkDqkl08aUavXY/baDhDCG9Lmzoia2CW30DwbYgFJXOVtwzAQHoPl2cX8Zvl2PS
         v/xdLpMJ7G4nd5DrPW+nH1nVPbd7cawbMjNMLyeP3ke2gyEL/pXv84P7cbLGKIJixmNL
         qZhQ==
X-Forwarded-Encrypted: i=1; AFNElJ/VWb2WYhtuVKVPgmjre605g+I7SX0TJks1qTo7G/8xatAIZHyP3Ky3/rhn17M+CfUJilv0LrsvXA==@kvack.org
X-Gm-Message-State: AOJu0Yw7e7shNG6cIjsO2zctGxSBDok6MUn0Jmm/JPCuWdMyiqNsOoYp
	o+I6wmmX0Yx1gAVgnHuQlOjwH5fsl4kgAx4dUWeWqA089RA+DaGRzW/cpqFN8Ejv2IOG+K3JjJQ
	14OgNffp7J+BSfM2XcghtmdvXPY/iC/w=
X-Gm-Gg: AeBDieufz/0Ej5hW8pYrHCsYgmGYen13fH0d8tgH3fiJ5oPdqgDPEf+5J2ES14q8MTb
	ziZ8NDbyCfEheDkMCvwpDfYjcrIxL5DZLqJtECzx4CVYU3piWV6yAoX8XRwyaX5QPUlleufu/9W
	yPrH3eMkS4NLOwghng2MFGxu0SLjnZ3pQkWyXMQldNtIsaE7wmZOP/GfV8DA3gtSuTWOT6bFylP
	mUCNEiUmTGlm95u+bFV06FOgeHEkhX53DbRLaAAv8jEOS4bPQvSeZg++SCv9JYmju7ZzkHKFnLv
	WsJj8/7d9CGkImHWZ7tOI0Vei4j3xUGoiZvkDucH18QVOnfbrsM=
X-Received: by 2002:a17:907:7209:b0:baa:67b9:57a0 with SMTP id
 a640c23a62f3a-baa67b95a5fmr713004866b.3.1777057123475; Fri, 24 Apr 2026
 11:58:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
 <aektdlD4npMVThu3@google.com> <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
 <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com>
 <CAMgjq7AGzBubCkmv7LubBjPLN1DzL472d4zUm+sGxo8ZptMgRw@mail.gmail.com> <CAO9r8zO+tm2J0FRC64VKCYOSuKPXX8cQG7C07SwMWKoLiwoV+w@mail.gmail.com>
In-Reply-To: <CAO9r8zO+tm2J0FRC64VKCYOSuKPXX8cQG7C07SwMWKoLiwoV+w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 25 Apr 2026 02:58:06 +0800
X-Gm-Features: AQROBzAaIu04DPxOg3P-cwpIEdvMhxhii3pwiMT8HK0UdOYxD8nmrK7NsGSDAaE
Message-ID: <CAMgjq7D1WXUHqAV1yuXvrUmEsE_m_+yx0mBq6teJhipx6mySbA@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	akpm@linux-foundation.org, Alistair Popple <apopple@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <bhe@redhat.com>, 
	Byungchul Park <byungchul@sk.com>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Lance Yang <lance.yang@linux.dev>, lenb@kernel.org, 
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matthew Brost <matthew.brost@intel.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Mariano Pache <npache@redhat.com>, Pavel Machek <pavel@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Pedro Falcato <pfalcato@suse.de>, 
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Suren Baghdasaryan <surenb@google.com>, tglx@kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Yuanchu Xie <yuanchu@google.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Zi Yan <ziy@nvidia.com>, 
	Meta kernel team <kernel-team@meta.com>, Rik van Riel <riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 817741C0011
X-Stat-Signature: mhn88umdkhnjgki6xukbpdbseohwuhtd
X-HE-Tag: 1777057125-620599
X-HE-Meta: U2FsdGVkX19ycZhFyc9ZNqY5itl90qpGW6Mz2hjtMVtuTPytCIOyOrqdsIXhRSSDBONHF2qrS0DqM2MDDp0NKsqF1v+OrDkRaSQtqKDESiGKVHuHh30DSY6F7OA9u8yG9pYyvs56trXOQFpsOnn3BaC1E+DzHtaRxhrdTq0PW2LCkCfbnUhdmn17iOUomUgnzY2a6FqCPyk3TomdIP5o1GP/FCVnpwajNV7T9TNdKpwTxgsDDKz5PDmUSozovvi9ntNzHjv9x2B8+TvPkOKEHKTIis5Wa+UpSLmYqM7OTLfinm5Ou6NczqBJeXizhV1aKDO2FaNeDMIO6jUcGQlhl3kgIBG7+Acsg2ZC/ulTAancQVqi39PZUai8BaAH8RqGIZtt1YvtraTl2ifYWEXW3sS4nrS0H2jvb75izq+hoyQqLvjmYc/IZ+2x4RBoh5Ug8ZUv6zkxQsk97Y8kzQuMox9J+jWJtWnJNcsW47nPUBj0JGmw+VED4yAM4YXCriQk2MvxStiBPKCQjyzQrUX9NtdJ+tNe4W4xA9k2nsVFKTxbRq6IJZkjTi22YCqyC/kYjbXFy11ceMslbk+mHjeIFpqr269KN0NTf/WsCWxILy8BPGrMy5HSuY+8yW62FrfjARBVKDmDILmPPMC/52SEQIhKC3YAuoUuq73w+7ebsk5xgFeoJZ96sIsSW9BKnEqDcVkl3Kn88SVdG9lbLIh/fXMI6OPkfUUk6ZGFPhWuJxPYf7fIi4Q6QMVkjGdMNTbB8lq7oe3vA5Lp6k9JvRvHJMvoNojKhbbooOElEbE3RzR9qDNC58fFDCsrf9meRSPFkr6RuAfWudjTNyuYiep5FsgBpSUoqvZGcMcHygDDp/I2258hCu15IHI9wUdFhTeMRFX5K4Zu1czGg89w0DR2vgZwmSR3VcM5Y544AN5XvdDSoM0b+2N2sKCzuj3w9XqR3RS4hhPh3oDBIDH5OkB
 ReR4Mz1+
 osKX/ejV8TDAQZ4fvdKr0b6C4uhh2RILcZh7Y+m49I7xRdfMtaD7HZuBXpfSyXS3NV2k4SzpQLihoxo/tVY3QXyy7XYzkMNWZZlorOoJ062fqW+wybG+v9pt44NwGb3RgnFOkT0cvRUj5pFBacOvDD7bkixICspPoILqBVRYXXeovAj94sanrPveq/ssXfXzDxaOgudbMEwBQ4NHDwhJ6byNoA52KGk91QHudph7gwLlh4r2KcNXxvIgHBKc96erkLFAUfTupgblz15ETaMGMzVPm9v1TSNk9v60RhOftRqp70Xje8WyhI00rLslfstwPA1CtmOeO8iQywLvd+QBMkRkjyycQ/v8tUmudagX245HVZj+A1ruDqkg9VDNylrSgpCD3tm4wcvKE1xWbg6KAeEoojmA0c1HKIq6Lz3HzdDoY4lG83ZM3j+Yv0NOmD4ikBiFfC1ux2fEzQm6bIbMjyWLxPUlInvojED4sJAPyyE1DgE3HrU3AenLMmrkMqKUxzRumVp3N0P5aSiuTj9Uo/h4uGED2MNdGpxSQTxZK6+kPStVcumckzDDClw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 25, 2026 at 2:08=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Apr 23, 2026 at 9:16=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > Yosry Ahmed <yosry@kernel.org> =E4=BA=8E 2026=E5=B9=B44=E6=9C=8824=E6=
=97=A5=E5=91=A8=E4=BA=94 04:48=E5=86=99=E9=81=93=EF=BC=9A
> > > > Using a swapfile does have its benefits, though. For example, the
> > > > virtual layer could act as an ordinary tier following YoungJun's
> > > > design:
> > > > https://lore.kernel.org/linux-mm/20260421055323.940344-1-youngjun.p=
ark@lge.com/
> > >
> > > Hmm I didn't look too closely at this but I don't understand how
> > > making it a swapfile helps with tiering? If anything, I think it make=
s
> > > tiering more difficult. For tiering to work, we need an
> > > abstraction/redirection layer, such that we don't need to update the
> > > page tables (or shmem pagecache) if we demote/promote pages. That is
> > > exactly the use case for a virtual swap layer. The page tables point
> > > at a virtual swap ID and the backend could change transparently (e.g.
> > > for zswap writeback, or tiering).
> > >
> > > If we make the virtual layer a swapfile, how do we demote/promote
> > > without updating page tables?
> > >
> > > IOW, I think the whole reason we want a virtual layer is to separate
> > > the backends, which would facilitate tiering. If the virtual layer is
> > > itself a swapfile, wouldn't it become one of the tiers?
> >
> > That's exactly what I hoped, virtual layer being part of the tier.
> > Tier could be set up per task / cgroup. So is the virtual tier.
>
> Just to clarify. I don't think virtual swap should be one of the
> tiers. I think it should be the mechanism through which we implement
> tiering (see above). I am not sure if that's what you meant.

YoungJun's swap tier have been working pretty well without the virtual part=
:
https://lore.kernel.org/linux-mm/20260421055323.940344-1-youngjun.park@lge.=
com/

> >
> > A standalone implementation of the virtual layer is more heavy than
> > being a swapfile. Actually I think at this point, it is the word
> > "swapfile" is misleading now. We may rename it to "swap mapping" or
> > something. A swap mapping could be physical or virtual. Virtual
> > mapping can realloc from physical ones (redirect), and swapoff of
> > physical ones just read its data into virtual mapping's swap cache.
>
> I don't understand this part, please clarify. In my mind, all
> references to swap entries from outside backend code should refer to a
> virtual swap ID, which could be pointing to physical swap or zswap or
> something else.

For example just reserve a type (e.g. type 0) as the virtual type?
(type is really a bad naming though).

The that swap file (or swap mapping) will be

I was trying that based on this:
https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-15-104795d19815@=
tencent.com/

It seems to work and the only thing we need is actually just something
like this one in VSS:
https://lore.kernel.org/linux-mm/20260320192735.748051-15-nphamcs@gmail.com=
/

This part:
+ /* fall back to physical swap device */
+ if (!vswap_alloc_swap_slot(folio)) {

We do a folio_realloc_swap if folio->swap have type 0.

Which means, if there is no virtual device / mapping / file / space
(I'm not sure how to name it at this point :) ), the ordinary swap
routine is just still there untouched.

If there is one, and it's being used, then, it is still the ordinary
swap routine, just do an extra allocation (and the extra allocation
strictly follows YoungJun's tier rule), which is same with VSS, but
everything is reused. From a user or high level interface perspective,
this can be designed with no difference as VSS. Just with a few
bonuses: being per memcg / task / runtime optional, zero overhead if
not enabled, and reusing all the infra.

BTW this deferred allocation (in VSS or dynamic swap mapping, similar
thing) is actually a bit concerning to me as well. It changes the
common swapout routine and maybe worth reconsideration (e.g.
activate_locked_split and mTHP stats is now ignored?), being optional
for now also seems safer.

> I *think* what you're saying is that we should make that optional, but
> I don't see how this would work. If a page table is pointing at a swap
> slot in a swapfile, we cannot do tiering or zswap writeback or
> anything dynamic without updating page tables. So even if the system
> starts off with one swapfile, we cannot assume we won't add more and
> set up tiering (or enable zswap) after that, right?
>
> I guess we'll keep the swap table in the swapfile and then we'll have
> it point to a different backend, but I really don't like this design.
> It's unnecessarily complicated in my opinion. Page tables will either
> refer to a virtual swap ID or a physical swap slot.

Or in another word, they are all just swap entries, and the swap layer
handles things internally.

> I think we can simply have swap tables representing the virtual swap
> space and pointing at the backend directly, whether or not we have
> zswap or tiering set up or not. Is the overhead really that bad?

Right... I mean with two layers you will likely have >16 bytes
overhead, and double lookup. And I have been thinking about cutting
down the memory usage to 3 bytes. And you can't make the lower /
physical layer just a bitmap if you want a reverse mapping, and so far
many things do require that. If we make the reverse mapping optional
it might be more complicated than the thing we discussed.

I don't think the thing I described above is that complicated reading
all the code and solutions so far. Maybe some better abstraction can
help?

I've seen some vendors doing swap using UFFD just to cut down the
overhead or having a highly customized backend solution for swap, so I
was hoping the kernel part could be as minimal as possible.

