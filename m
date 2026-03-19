Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD7A71091930
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 23:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8BC6B04A9; Thu, 19 Mar 2026 19:26:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E907C6B04AB; Thu, 19 Mar 2026 19:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA69B6B04AD; Thu, 19 Mar 2026 19:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C82BB6B04A9
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:26:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C99CBB035
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:26:25 +0000 (UTC)
X-FDA: 84564398730.07.BC9C84A
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id 716A7100004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:26:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l71ERaBq;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773962783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7beb8gjsdwOqcZgIyiO7JeS7nO6wuiWGWdh35QWvwZE=;
	b=CWAtBPVWkVKMml6qlJ2LHqUGbolvARDXV6l95HR5JJIagJ6uUYhTuPfW7KDN+nTlPMqpj2
	p6YMNi1oKNwkzDbXgtNf2Tyzxs13insAVr3g+qUcyl8RxHmN7i1vpLDxHJcIrXdKE/JcTt
	ijy7SWj90tOQ5M8EKtk3YRKhJZZbnGw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l71ERaBq;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773962783; a=rsa-sha256;
	cv=pass;
	b=UUe0Gh7IVxLcrjvq+t74w6stTqmLv9+yVn+SE2/Cu96AAfRWDYxh1gUUolRkbDIGp7M2XO
	1lL1HI48AGIOLQmAPlYzCAfYgdoTPFPeXTgl2mCBzsmQGysVxJZbO5lUBSq4wCJKmP4yN6
	aTcWczp1SEmlfU5WBde7uIq+P5FEj48=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-485410a0a8aso317045e9.2
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:26:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773962782; cv=none;
        d=google.com; s=arc-20240605;
        b=gXtcsTnwzYantl4fDslBsyY4FTvDLedHYg+2KufyAuu9Py2xZvVzsKbGRY1cdSVnKR
         UyVHhgb8UZbIGxydANDEZmDuzeX6e9q3CDRLHmBNQXr2WmviH9TE8tWOdWPInSThfOl+
         s0dqLieeG9LHES6pj0hImLLhPWxuHKIQ2ScxuLLzpFk7BRnIJhjC3e7IST7CiyuhWjRN
         SV5c0QOaLZLkIINj8X5M5CSzphLrXuvLKeTnP+aobjBLHcRuvCtTsaRcc5P3M1u37Rr7
         droQzAxXFN2Iv9v6py/9c+FFUUJGa97xmSCHnQrf/hqHtAydYHpcGjv0BIAToZUXzIoH
         6XSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7beb8gjsdwOqcZgIyiO7JeS7nO6wuiWGWdh35QWvwZE=;
        fh=D2rpsAXXtfCZ3o4srzyHGGcWPSz3B2EaPyJ9A7uHqKs=;
        b=CxjxPieWo/ZCk0uaC814EzC7/9f0wmdvrN8FSYAhxiDmsfJu9Bnuj0mgaXkDi4JNQ6
         GpZJcGP4e81RhxbvfH+KQ45wYCB+3Ri5fAY2fS+9epGdNY0Z0hBJEWQ+XQHY/lTdeRoH
         Uae7GC+4X47qHns/KIC67Vj4LJGmxK/vf5BnogojM1gT35FaZI8hxzNmK/oRRLg/EcxC
         +bj5EJ9VK91jAO+YSYUxZ3KSfymWzeJ7aJmq6iD1A65bmQgYrPUhOEMdJg0qiwWo/kSx
         xEKvaUYD+Zb/zfTVuq+p/M0Z7UIyPDQNKCK7G7cf8gfSDE4CVOUaP4Kxir9LJqyvPJuR
         fM8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773962782; x=1774567582; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7beb8gjsdwOqcZgIyiO7JeS7nO6wuiWGWdh35QWvwZE=;
        b=l71ERaBqjGJBEu5YNZNvC3RaXcC2lGjrKkIR/qAHtKO2QfFJzD7vtOI63uJGA+zRLl
         LO/jt1lbicZbfdV9iMEXO0qf9sThTw05GwIxhEODR/P3+b/9Y54rfFwA/gqMYEYbpQL5
         XD3TEj6xJ5Ab01kL/5dvGoYQtPKKZJhNEunkjazHHQyAskAcFDQeyySz9zec+uBObl6v
         8gxseqKwiGBpzyr9EDwJqXDvBf6sXGBcGNKCsG0u8byQGTr2B0O3t70nN1j8cyTNTsU0
         mlWJU8GBZOu1U96HWFLjhPWWXXvY2pga60HM08Nmh/tem+hDMYrRX3XlXqSR9MF+7f93
         qdXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773962782; x=1774567582;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7beb8gjsdwOqcZgIyiO7JeS7nO6wuiWGWdh35QWvwZE=;
        b=aUdU6FlE1/Azb54yCYvbLSWKxP1brf9PnEfk4t0VQ+2C02KzNV7S/6VVDbv1BE6viA
         nPM4W7WGwqLDGTqgEaDBmKtOwTne/TwuznDlVQZERHUHrr5GtbfYiothjQTqVpcsCr12
         aXTUL8KnfWTzmsuFLcXQmi9ZCzzInaY+XQu8HqmgamiuSn6TWdhsT7M4P1Rvq32v5Cbb
         dX4Xfes+u/8eoCt75OUmtO0H/05MmAL1VUl8jyk9yuE2BfE45k3ft6fb5fDCvKy0Xpo/
         ffGHGnwXV5Rah6a9IGV8wUXTqN+ET6cJoEQpmTKNtZJjf2B/WC0ESnhcu7zRHfq69jBi
         Qs9w==
X-Forwarded-Encrypted: i=1; AJvYcCWaGwlx6B3iJRxgs07kFdCS/WSfEKasUA+UDZjiXt1cUaNaCZd55ePt9C+G5F1XqXFt6PjDsB8fCA==@kvack.org
X-Gm-Message-State: AOJu0YzyUrhVUQEoV1ubjE+bDB/scpqKO4w+PKht59sD+xjxoaXsUtkW
	qHFehLgiPwuvTT8ZO3RDPspy0RU1/e+W3jxya4AdHumuuKxg1d8rmDAcwVq0SMLXRniYRkTv8Yj
	8FoMNb74W3YvtgR8yRTRepj09MMm/fhQ=
X-Gm-Gg: ATEYQzxJRpjBUjzYUEhDxblBSDO2YfMBKNRgRLav+z6tBXwO9/pd0KNuWpc6j5820AW
	PXtSGTOEojDYUH1C5cKHdnecZ/QeqEuc/d7vW06Hz9CPsJy3H9OHBVUHYcTRa3+V6pqGTggwDQd
	rhB+65q1IARHO8xpqSFOw6HMAgj2ZnLB1w/sluomlCMNkUCRVKk/wqu+kUbcDc8XaslgiD5dybF
	d1ZyVH3UzBjZlE1kCan3x+sE22YTGSbPO+lW7OWaJhOyAIIpUGHQVIu/uOsApz1x406pe0Y9fyV
	0S1+youqhbK7GME4d+OIIidLvCCHj0y0sgHFXno=
X-Received: by 2002:a05:6000:1a88:b0:432:5c34:fb32 with SMTP id
 ffacd0b85a97d-43b64257edamr2078092f8f.23.1773962781517; Thu, 19 Mar 2026
 16:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260318222953.441758-1-nphamcs@gmail.com> <69bc6c4f.050a0220.3bf4de.0001.GAE@google.com>
In-Reply-To: <69bc6c4f.050a0220.3bf4de.0001.GAE@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 19 Mar 2026 16:26:10 -0700
X-Gm-Features: AaiRm53Xe0ySNcLwX_1MJR-ZkSlSVSu1aeYx4yiRcGwlx-CLDipgZeR1y7Vur74
Message-ID: <CAKEwX=PF470op0e+eXcFS3SHKaLRd5v6ZuE+_aUk_4xfdGosog@mail.gmail.com>
Subject: Re: [syzbot ci] Re: Virtual Swap Space
To: syzbot ci <syzbot+ci0215525ee2c0ed89@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, axelrasmussen@google.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, bhe@redhat.com, 
	byungchul@sk.com, cgroups@vger.kernel.org, chengming.zhou@linux.dev, 
	chrisl@kernel.org, corbet@lwn.net, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, kasong@tencent.com, kernel-team@meta.com, 
	lance.yang@linux.dev, lenb@kernel.org, liam.howlett@oracle.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, riel@surriel.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 716A7100004
X-Rspamd-Server: rspam08
X-Stat-Signature: u7hyshj7xe3mn1nyw9dhqs93hobztpo1
X-HE-Tag: 1773962783-775438
X-HE-Meta: U2FsdGVkX187XNe7DgBjmkqo6VI6WlVoMR5gLMbm5HPNmpRzyrmZUnvhLgv6wc0jZoZiGdolPINo8U5unfGwAGK4MgTLjsUvUaeQnWYfN2Ha/lj4v6v3mnLzxhznyrzIupXZ1TA+ARQ3+684nhYyJxcVhm9sA1ls3sL21XuogtNuDGgzMAZbYhJmqkjbBeTcuqinvU1mbvN2vOVrcFJ5uyEVht9UA/frjH9VMoWxRU5mMsN1REuCfGhTMYpXYZXinyYmw8ca0Ige8vTUGvMboBKX4OGYDMihKS+vZwxcn8DoiYx2A3HMeQaXMrQos8/7TL4Zk/UAbdAcSXDjMv8Qp1NFAIW13mBRTPxbH+edeGZy+TgaFrVCmLpsOfmFnCKl/ZcK+X1BW8aw0cD4r6ihiJXrXQqkS5ZFx1XulLQIoD7PLERgVyR8WUdCI+2spiHiw8tkkrT8cAt8yOU/CJddWXr77ISXHqxJW+zhOVnqaQbpw28m82CZYIfu4e5SsEzUOSeJ0W00RyWvzHmMsVsPuXe9WEv/KvJd/E8dntbqEvVoul0afXXxAI4xfvkttNSmWAXdF2W/OldmGZMTboJ6M1d/niuEDdMZrXSrXuJREQoi91/DeUQF6sxpE6IXsnCaqyBeYuO83pGq1NO4DCRggLvbZToqPI809YAlhIgXHkZHWy+FATfpT1rVPtaim6RkZNnlJstxmbAcmIxp+wYpoByTzOfrqt8UjvQLOI/ArO4Jm5ytInRUxFplsSsfnz2hkj1/AjlF5uKVbQFuap9XZE5F+hwJ9uRryp6EvW7m3CxRuu2yhV0rj4iwALhtbXB75DFWJfBrweiDuR7n5h4g4O2mfQCYfI7zw4nXNsDnvmwE/WGa7grxGu7adGga0TnFVo8o1uwofztGRycl8WSkU/+hngDaeI+i8HcFW9+oVMvgfNqRFwP+V+ufwTzIxYMr4OSsjEhEyf13zwmdYiP
 IvgW7sE/
 ARWVWcENvwrnfVruEK2xu6BuhTCZk8l+Yi4MiFsY1ZABWTZvwOfz8xbW99iPuUswZGmu/MB2WlhpB5vXwVbTj1Kbn2hU0JPy73Tk4AZGRpOGE4XDzUd1sfTmqJn1I78PDvDsQX1GrwXPWsyo9hGmJiYrT4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 2:36=E2=80=AFPM syzbot ci
<syzbot+ci0215525ee2c0ed89@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] Virtual Swap Space
> https://lore.kernel.org/all/20260318222953.441758-1-nphamcs@gmail.com
> * [PATCH v4 01/21] mm/swap: decouple swap cache from physical swap infras=
tructure
> * [PATCH v4 02/21] swap: rearrange the swap header file
> * [PATCH v4 03/21] mm: swap: add an abstract API for locking out swapoff
> * [PATCH v4 04/21] zswap: add new helpers for zswap entry operations
> * [PATCH v4 05/21] mm/swap: add a new function to check if a swap entry i=
s in swap cached.
> * [PATCH v4 06/21] mm: swap: add a separate type for physical swap slots
> * [PATCH v4 07/21] mm: create scaffolds for the new virtual swap implemen=
tation
> * [PATCH v4 08/21] zswap: prepare zswap for swap virtualization
> * [PATCH v4 09/21] mm: swap: allocate a virtual swap slot for each swappe=
d out page
> * [PATCH v4 10/21] swap: move swap cache to virtual swap descriptor
> * [PATCH v4 11/21] zswap: move zswap entry management to the virtual swap=
 descriptor
> * [PATCH v4 12/21] swap: implement the swap_cgroup API using virtual swap
> * [PATCH v4 13/21] swap: manage swap entry lifecycle at the virtual swap =
layer
> * [PATCH v4 14/21] mm: swap: decouple virtual swap slot from backing stor=
e
> * [PATCH v4 15/21] zswap: do not start zswap shrinker if there is no phys=
ical swap slots
> * [PATCH v4 16/21] swap: do not unnecesarily pin readahead swap entries
> * [PATCH v4 17/21] swapfile: remove zeromap bitmap
> * [PATCH v4 18/21] memcg: swap: only charge physical swap slots
> * [PATCH v4 19/21] swap: simplify swapoff using virtual swap
> * [PATCH v4 20/21] swapfile: replace the swap map with bitmaps
> * [PATCH v4 21/21] vswap: batch contiguous vswap free calls
>
> and found the following issue:
> possible deadlock in vswap_iter
>
> Full report is available here:
> https://ci.syzbot.org/series/f8238a2a-370e-404d-b3f7-5945b574bd63
>
> ***
>
> possible deadlock in vswap_iter
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/cf1517a6-d391-46d8-bfbe-98e6be6b9=
3ce/config
> syz repro: https://ci.syzbot.org/findings/b4e84ae7-17d4-4bf8-9c3f-4c13b10=
a1e52/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> syzkaller #0 Not tainted
> --------------------------------------------
> syz.1.18/6001 is trying to acquire lock:
> ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock include/linu=
x/spinlock.h:351 [inline]
> ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: vswap_iter+0xfa/0x1b0 =
mm/vswap.c:274
>
> but task is already holding lock:
> ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock_irq include/=
linux/spinlock.h:376 [inline]
> ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: swap_cache_lock_irq+0x=
e2/0x190 mm/vswap.c:1529
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&cluster->lock);
>   lock(&cluster->lock);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 3 locks held by syz.1.18/6001:
>  #0: ffff8881bb523440 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock in=
clude/linux/mmap_lock.h:391 [inline]
>  #0: ffff8881bb523440 (&mm->mmap_lock){++++}-{4:4}, at: madvise_lock+0x15=
2/0x2e0 mm/madvise.c:1789
>  #1: ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock_irq inc=
lude/linux/spinlock.h:376 [inline]
>  #1: ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: swap_cache_lock_i=
rq+0xe2/0x190 mm/vswap.c:1529
>  #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:331 [inline]
>  #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:867 [inline]
>  #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: vswap_cgroup_recor=
d+0x41/0x440 mm/vswap.c:1909
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 6001 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
>  check_deadlock kernel/locking/lockdep.c:3093 [inline]
>  validate_chain kernel/locking/lockdep.c:3895 [inline]
>  __lock_acquire+0x253f/0x2cf0 kernel/locking/lockdep.c:5237
>  lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
>  __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
>  _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>  spin_lock include/linux/spinlock.h:351 [inline]
>  vswap_iter+0xfa/0x1b0 mm/vswap.c:274
>  vswap_cgroup_record+0xeb/0x440 mm/vswap.c:1910
>  swap_cgroup_record+0xc5/0x130 mm/vswap.c:1933
>  memcg1_swapout+0x358/0x9e0 mm/memcontrol-v1.c:623

Good (syz)bot! We're already holding the cluster lock here - shouldn't
need to reacquire the lock.

Should be an easy-ish fix.

