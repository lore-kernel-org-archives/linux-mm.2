Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 869CECD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 22:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CAD76B00AF; Wed,  3 Jun 2026 18:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97BC16B00B0; Wed,  3 Jun 2026 18:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8430C6B00B1; Wed,  3 Jun 2026 18:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7272B6B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:14:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4EBEA04C3
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:14:54 +0000 (UTC)
X-FDA: 84840007308.23.EF64349
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id DBF99C000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:14:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nnVK57o1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780524892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FmzDsup0sFlBNWhGg0+0FS+tEwpLPYz+Yh+3amtQtVM=;
	b=TmefxpGVJo77Vqg4dBYhs6aWlpYc6gncSy3/3Dy1qw9rm7K7y7j86VetZwSVquHB9h6iQq
	rWbauHVM0Y6H1oH1+vOsDAm3eUKWNnU7qmXX7BJDtKZAwRSoQ7O6Zc8hdxe4F7edjH4wN9
	YRupJncXW6mT02uqD+nD1Mn5FrH0FG8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nnVK57o1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780524892;
	b=e4+Yok8VWzupT4mV7CO13OcdZnOSx6al8nDYoQZOrU+4oWzf3cfTjM/3wPEi0Sd6jgTtDk
	v8/IOnZgOZtiMQBlsrt9HHoXo23UOKTZGmQGy7Zo9xaHzh2QYb8+lpSZbRnTxbQ4adaDPq
	bRaZHxxqBmtd/5WVuBaIPpFBjSkhvxg=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-91562bf6c12so10282985a.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 15:14:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780524892; cv=none;
        d=google.com; s=arc-20240605;
        b=cQOxONdIPTqq1bfNZE2Ea6kdhv8Pn6j5zZccwX3pyc1qkg6X4IsgokkLYARpTPKDN2
         zsdpMkuVjp1ZuxbxuoCtD7jQet2GP9QaPaCTLfwr59FS/9lakromM+1ajPzeUcz+CM9d
         /U5kUwRyvrxv4WYUuhseZ0tsj7GlKKeBnlXOdCgzqLx8a3eb9Zf38T/VBYtuRAkWJKZH
         91wArTqaOquNzeZn423rzmr4wxlNZgMsB+Whf5zrV3kdkFhW8e0anIvRavQZ9y/RTCOY
         iGjmqaX5WE90ZuIY/xWqLvbd11gatQvzc2v/3g727flj2HwnXUCu9sgtLQXufEAk0mA6
         d3Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FmzDsup0sFlBNWhGg0+0FS+tEwpLPYz+Yh+3amtQtVM=;
        fh=DotKrzN339hx4DRVY+I55+Kv4CIqrGd43PP1Hk89HF8=;
        b=cuIzQTZnsYTLNozLzoFIOcXZsQTWvlJgQUZcGbi0gYpE0LAyugDwCF3Je6U6q4lHBF
         9W0HDQlB5j7TIUQbbV2hwVj9hptebSsgWPbdvlR82VVbgCdl1cDGKOZG2mySSblX47cQ
         bNW9pIpKbuMgKJOd45sUUjtwKwLesef4zmHo3irotNow0cRO6yHaNQ1SPQKNyWmjiKSO
         GHGg/ti57wHE9EXCU7CUjNdKoTTiCy2+jylaUtAYvnWnTcUh/o8xrZ8yen/wPgnPtTCA
         XF8SaMfZ0K6CM+rC5esVxLT7QEC5VlAnqzufMFmoUcdVNRocTO3g37SiQkUolhNZd9lR
         enAA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780524892; x=1781129692; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FmzDsup0sFlBNWhGg0+0FS+tEwpLPYz+Yh+3amtQtVM=;
        b=nnVK57o1kbammAKyNiOgkERErJZO0W7YslPT2nMJ93XJJD+bK11MwibZTIccGIrefk
         7SmsM/fItHPMHiQDs6J7glu5qZJobkBC6C/sgfV7ueLqGV8LmenMQJL20Z+3/JB18bow
         vHB6yZYUWbOuh/jI1wu7Sqt3++FEBxAJpSPsHnVYmr4sJ43vCbV7D+tb6bEMSXjrQP9b
         HQMuEG7MAT3Zxkskk8NQagiASasLQvcBI+i8UovINhvfHrMHpVxnu99YvdCA8dtxBhpU
         EclJZIZfgdHnqKJi6YZvW7oqUCzymo8nUivU1HZ/JX6UDYu8TVoDoDEOxMekXmA35qqc
         ovfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780524892; x=1781129692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FmzDsup0sFlBNWhGg0+0FS+tEwpLPYz+Yh+3amtQtVM=;
        b=fDBQgow/JIzKhG9LVOKlHAEqDNCHBIwVLXjtM6bXJ881+pPkwCDR+I9tvaV/MyqDXf
         6fDpeZZsCvdV2D2S32GZDyvCOy10LUrtj4cdrAYuCe2GtTS938h6yKNjQKoMtrfSeaeV
         DtMqHRk8+aMPpnV8Nbqseg95dklbldKDi0a3OQUz0U9ECZVg/KmrlIT0i2e8kdnMAoHh
         pF7ho6OfHrBwYu8yMvuxOWpJuZxxhcSquuy7bCsr6js4ZXfzckVVsLwgyMxtlU+YFrVo
         ET77Gsug4Hz25zThZrHTy0u1Bzp3QpxZdvO5/pdkvrS5Ts3pgO2h4HXWrluIuVuIa2m0
         rM6g==
X-Forwarded-Encrypted: i=1; AFNElJ9EuyQGTCUOrWT+tVLAgQzoaEtCm0FhxaqQJL3KrX7lCvhns3Be820qsNMdhRt/Qgfx0+ikFPpRcw==@kvack.org
X-Gm-Message-State: AOJu0YwE/RXGGiLfLzUGzch9spoRKy3pgGjjK0KW2AyxjB3kMic+mifX
	UdJcjd9zYkSMoWj2hob8buuANferIlfgbH97ZyFsnKb2mI/kH7xITUhDNGkS6Hv9OHyyyPQvm9s
	WDr6st95ZrdsUt1rvoTxKBz47HwKFF8s=
X-Gm-Gg: Acq92OHIb+Nm3OFBWnz1YIlluVnFskped5HnfQtvcO18fE/+lTJfNXeg7yxfCm8JEBP
	W39QEtvfThOQ9894WwJTjrnDtHG6S4k1QCXtZF6sCsWY+tbcgyhFcnvJY4m6eLKWgheJyOVZswK
	2yJi+3TBsRsxpREC608V5Rn9t9X00xscHMgUrwDpV6dLysogtCjGKdUhB4ucl0V3B3hOQZVe3gV
	QSshtEUlrxDR3DYF+x+xO6+jkXyK+D9rZLAKrY238odqf+P7/2Ort8e1uRZKllaYQYpUSsT10eG
	z87V0Xn7yscHq2s1LGDJmdgVebo1/x2coeXzmXsiEA1iLb6F
X-Received: by 2002:a05:620a:40c4:b0:915:9c4b:fdb4 with SMTP id
 af79cd13be357-9159c4c0fccmr119218285a.22.1780524891016; Wed, 03 Jun 2026
 15:14:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260527110147.17815-1-tao.wangtao@honor.com> <70377626-500d-46f2-a3f5-a0d2914ce365@kernel.org>
In-Reply-To: <70377626-500d-46f2-a3f5-a0d2914ce365@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 4 Jun 2026 06:14:39 +0800
X-Gm-Features: AVHnY4LRywF8yijh3uWS4ASgIO-DqQ0mxyZBegdnnjWwYExKtCPyz-v6JopNV6g
Message-ID: <CAGsJ_4zg8+pVDwtsJtxxiC1ahJ9MR56Ue8VXCt_VrQgcXES2uQ@mail.gmail.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma creation
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: tao <tao.wangtao@honor.com>, catalin.marinas@arm.com, will@kernel.org, 
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
	x86@kernel.org, akpm@linux-foundation.org, willy@infradead.org, sj@kernel.org, 
	kees@kernel.org, luizcap@redhat.com, zhangjiao2@cmss.chinamobile.com, 
	kas@kernel.org, ljs@kernel.org, hpa@zytor.com, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	jack@suse.cz, riel@surriel.com, harry@kernel.org, jannh@google.com, 
	jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, lance.yang@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, nao.horiguchi@gmail.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	pfalcato@suse.de, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, damon@lists.linux.dev, shakeel.butt@linux.dev, 
	ryncsn@gmail.com, jparsana@google.com, dvander@google.com, zhangji1@honor.com, 
	wangzicheng@honor.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DBF99C000A
X-Stat-Signature: 7fwrw8uqmupxxmjf7tqs3xsepq1jjgkr
X-Rspam-User: 
X-HE-Tag: 1780524892-111130
X-HE-Meta: U2FsdGVkX18s8UfN6tEYIRaBOSEcc9zlnji3KUSLgUl5W5s4v/Q/OGk9DqpQO9JkWkKNbhEpWq5hzKHmD5OcYLRAtJjImWV3r0wK5WKsBIHnOSHymZOEBCoeaim2s5kv8OGeRVXmcRE1zvaI/XZg9Xwhep63AHXXxAPG9+zCAFYmAHWmbOxM8kZajrGNvCSgmARLe+E2wPUawhOxLsAcCn8tQsD0R36HbemzTfTMc3SoBeeUb6iD/PaFQNcQRgLJZwd455Pykho7Wsmq5aGo378K8xik9WNho+4YgiwmOfVe2B0Koqe62Rbueqryobz4qaWY5CaIoKhAJ+jhp8zxOaQQbDq2Uqre+uCancNgdNdYITyLzTfjDNk1OHWWqZ80bGoTmR+VoWwOWl264LOsvMgX7f6fInutYkubupPcItBZ+R8BxyWVc4LLk6mL/18Dv2oKhzSixUiVL8BVwezcSel1/V7sl8BI8/IUL6e7GwrqrSPd3QIp5VAQERHkzBcvC6YRNfMF/SqdjfARj/KUrvPrBQidOIMfptBGcewjvbXbwYgl7CwPrnnnA9ds/O/BBgbHh8pbNkIixC+VbAM5mDDA0BuMDe7TjnzTongmfJiIdNyMnqqZSSLcNV3KS1KX2FDaYnfqqnIXIvvbRoMRM47CU7vCfDJ0UcKUxY7QYKiSJsl3A3MXDuCyzQhG/vsniu15QJ4uqvsABPLkjQzi9SuANmXIyHr0+Q29ElQ8nz98u85q6zquhOxI0K6kJwk0cIDaLbwLCF2FVyaqsACYHTr7rbHP38/QehNAirr0tvwvooVsSI3XRBksuqUeXYikxZmN55zjaiipTvLJZS8EVPlr0nr2KoBHwGnQqFjhryNHJqwFMOrDb6grFeJJ69nLCX1hUnB4vZquHrfkeD5hfl2psQ74T5n/tt5nNaPHZg21Jw9eFAQ+PAU8+W6vyblNkdTAeTJXCFw/1Q4FXLf
 dn9McBVa
 IjV0lJowUu2IDzBVQsS5jEQhlYZFEMC0y/5XL1QzrIz0oG7jO10dKKFdXhyoiym/NYKuOPICJanTI0DLOFVH9/FxOlHqAPBCAySxJpwLuyKtTlJ3/PQ7c9D1EDQ88c+LF3WVTdnvEhIBWlhAR2hmQ9uONfMJLTlY4XMbQRyk+/885Mmn0f73RTNo4WFH5l+OC0C5mifYotIC2kCy8z/9rbPILLtJrQb5EtsKmF2gyrrOf0C1NoIJ3DMLnjZT+huXQjDzqvRJaPm4tFYY88zYaK8jGcFpvx7MnoB/vvHlHJs4/RhhcPF06BRlEl+apOYvaQwm2nPasc5Mqk8PvFx/2zRoTBefsEvRBbQDGwO3ckXLQYFpVbS8Ze4I/zMYt2ae9+SN3smeT1EPEl7XC49o6X4lB66FtyKQWW6ciUBaWkwzqIVsmSxWnMSQwKnA8Ziu8Zipu7rUOIpHNG5gBSp7osPpwX2Aarb8vEw9mhXIVbYuRo2X31GQ+fXZ7dDha1AS2GjOTHCSqkOEApZUlLVnr68PtZlQCJg35Psoa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 4, 2026 at 4:25=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
[...]
> >
> >  arch/arm64/Kconfig         |   1 +
> >  arch/x86/Kconfig           |   1 +
> >  fs/proc/page.c             |   6 +-
> >  include/linux/mm.h         |  38 ++
> >  include/linux/mm_types.h   |   9 +-
> >  include/linux/page-flags.h |  34 +-
> >  include/linux/pagemap.h    |   2 +-
> >  include/linux/rmap.h       | 165 ++++++++-
> >  mm/Kconfig                 |  22 ++
> >  mm/damon/ops-common.c      |   4 +-
> >  mm/debug.c                 |   2 +-
> >  mm/debug_vm_pgtable.c      |   2 +-
> >  mm/gup.c                   |   6 +-
> >  mm/huge_memory.c           |  16 +-
> >  mm/internal.h              | 171 +++++++++
> >  mm/khugepaged.c            |  13 +-
> >  mm/ksm.c                   |  43 ++-
> >  mm/memory-failure.c        |  11 +-
> >  mm/memory.c                |  19 +-
> >  mm/migrate.c               | 126 ++++---
> >  mm/mmap.c                  |  15 +-
> >  mm/mremap.c                |   4 +-
> >  mm/page_idle.c             |   2 +-
> >  mm/rmap.c                  | 690 ++++++++++++++++++++++++++++++++++---
> >  mm/vma.c                   |  76 ++--
> >  mm/vma.h                   |   4 +-
> >  mm/vma_exec.c              |   2 +-
> >  mm/vma_init.c              |   1 +
> >  28 files changed, 1279 insertions(+), 206 deletions(-)
>
> Hi!
>
> When I saw the diffsat I was concerned. Going through the patches made me=
 ...
> more concerned :)
>
> This is a lot of complexity. On top of something that is already so compl=
icated
> that I fail to grasp most details without regularly taking a look at the =
nice
> figures Lorenzo created recently.
>
> For example, I read above "since child VMAs do not need to allocate anon_=
vma"
> and wondered how that could be part of something that is just done lazily=
. Then
> I had to learn in the patches that there is some additional "Child VMAs
> are created as ANON_VMA_TREE_PARENT and do not allocate anon_vma" -- excu=
se me,
> what? :)

Yes, that part is quite complicated here. There are two cases here:
1. A forks B, and B inherits a VMA from A. In this case,
B's VMA gets ANON_VMA_TREE_PARENT.

2. A forks B, and B later creates a new VMA via mmap().
If a page fault occurs in this new VMA, it gets
ANON_VMA_TREE_VMA.

In both cases, we need to upgrade B to a regular anon_vma
when B becomes a parent and performs a fork().

This may be a bit off-topic, but I'm also considering
whether there is a chance to work with Suren to support
case 2 via a GKI hook in the Android kernel before
Lorenzo's work is ready.

Even then, the optimization would apply only to the case
where B never forks, allowing us to skip the anon_vma
"upgrade" entirely. That assumption holds for most
applications, although there are a few cases where it does
not.

I'm actually hoping Android could eventually disable
forking for UI applications altogether. From what I've
heard, some applications use fork() primarily to evade
LMKD (the Android low-memory killer daemon). For
example, a child process may monitor the main process,
and if the main process is killed, detect that event and
request a relaunch. This is one way some applications
attempt to keep themselves alive indefinitely.

But even if we limit the optimization to the subset of
case 2 where B never forks, we still need to handle
mremap(), VMA merges, VMA splits, and similar cases.
That starts to become quite a headache.

So please just ignore my rambling if it turns out to be
nonsense :-)

>
> Reading about VMA refcounts made me shiver. Reading "Holding only
> folio_lock(folio) cannot guarantee that the split
> operation completes atomically." confused me. Learning that we have to in=
vent
> interesting ways to make page migration mutually exclusive to free_pgtabl=
es()
> concerned me. Figuring out that there are arch-specific config options an=
d
> runtime toggles is a clear warning sign.
>
> Seeing test_folio_unmapped() was funny, though (why?! :)).
>
> I think this patch set has a noble goal of reducing anon_vma overhead whe=
n anon
> pages are not shared during fork. However, using anon_vma for them actual=
ly
> makes the overall implementation (e.g., rmap walks, locking) more consist=
ent and
> simpler.
>
> Even if we could be convinced that most of this here is correct, how shou=
ld we
> reasonably maintain this increasing level of complexity here?
>
> I won't echo what has already been said in this thread (and I didn't mana=
ge to
> read all, unfortunately), but for such big and invasive work it's often b=
est to
> get in touch with the community earlier. Otherwise, you might end up wast=
ing
> your time.
>
> Ok, arguably, someone who writes that code learns a lot on the way. And i=
f this
> code really was written by one developer only, I tip my hat! I'd be curio=
us if
> that code already ran somewhere on some Android kernel out there?

I heard from Zicheng that they have been running this for
months and it seems reasonably stable. Please correct me if
I'm wrong, Zicheng :-). This really should have been
discussed with the community earlier.

>
> But adding more complexity on top of something that's already extremely
> complicated to save some memory looks like the wrong direction, really.
>
> I was excited when Lorenzo started working on a completely new approach t=
hat
> would focus on improving the common cases while trying to reduce the over=
all
> complexity. Because I think most of us really dislike anon_vma. It's stil=
l work
> in progress, and I am sure there are some rough edges.
>
> But fundamentally, I think we want to find a new design that is just natu=
rally
> simpler.
>

+1

> Lorenzo has been hard at work exploring various design options (and I'm a=
fraid
> he might be one of the 3 people on this planet that understand anon_vma i=
n full
> detail), so I suggest we wait for a redesign proposal from him and see if=
 that
> is doable?
>

Thanks
Barry

