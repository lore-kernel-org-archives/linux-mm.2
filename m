Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2296DC61DC6
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 08:15:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB27F6B0005; Sat, 21 Feb 2026 03:15:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60346B0089; Sat, 21 Feb 2026 03:15:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62616B008A; Sat, 21 Feb 2026 03:15:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC1BF6B0005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 03:15:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AB5B1C47A
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 08:15:56 +0000 (UTC)
X-FDA: 84467755512.06.2C8BF34
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3FC0B4000D
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 08:15:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="lJ0OYi/B";
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771661754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqJhtOyCKaatcPuVbcWAYul34KhkdgQblBgCMkQEGTI=;
	b=jyeI+Q/eMDgD/f2VUKxhpIKnxIGXs6W2zhFvArm97zh8ErQGC4PGOUIaukt+vza2Gqgtcv
	BtHkPiHTvFZIDrBnv2CIR0uANro4Z86ZcGeyT8VIvUZKAJacSRZwUVi0Tbz+4h17aSaogE
	EhVG+hAS2ONOXKUAaRBpZ/99oyxS6cE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771661754; a=rsa-sha256;
	cv=pass;
	b=XQBX2O7M9lGRxu4EoHCBrvOyzrgY9cqP+zyExoJ/wLe6p1pBYH3IogwbISiBbl5z5gZrnH
	lHna3RySkI7G5LryYMjFJNP8slZRhXou58cs/qFt4+9UM/74Ycb+79IGcp7TkKVwam571C
	+rc+w6uIcI2ODToyEbnnM/IxmXXOQiM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="lJ0OYi/B";
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8972a14e27bso36721656d6.2
        for <linux-mm@kvack.org>; Sat, 21 Feb 2026 00:15:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771661753; cv=none;
        d=google.com; s=arc-20240605;
        b=TMi1AFVQO74G0+28DDM32Wdo3D3NRd6EJ4vjI62xB+KIqbNHVEe/mpNGmb9E2kNunN
         iUnZ+c+7lJVb4CCyAMslXciBW8U9vOsbRvm3k3pbDN2sRRRT812ufaflIBGNXW+WAWhL
         CtDdCtF6inad3IemZRsDm4b7UQ/vlxwxfOLKkLtX9UR3lIYYA6l+lms/XIaTcQB9YRyG
         i1jffEw1XLqt/GjtbDXffgM/NZ1bgX68yBmxQAYbZQEwf4azpx5WbkFoUrwOy210MqNg
         ZfjVLMa4LChPlJNNGxoz1DdPZgmV28gtUhlifAabwSckX2Gof0uNGDzYo0ZTIhZ+lZEz
         x3WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pqJhtOyCKaatcPuVbcWAYul34KhkdgQblBgCMkQEGTI=;
        fh=jIchxDKlRgnfV0eL5R53VjxB0IUCJp2NSH1bWCUm7G0=;
        b=MxlPgmJuuk4f1vumjnlbo+fZpnFVnKPzzmUzNgQsuUnPCfGnr+ZxXFVJDPC+t2X9jo
         63kNn+CQEeHfRVA4ITavr8RvHzJJITZkoPC6Z7Ww3b3j4Ja8TYMuwknOrGcwZn0cmh4n
         hNJkfRwW0aS+v2EpIT1Zmd2f+YR0TiVfTGyn/H1gmzklCPPF+Sm3NWKAAZHxlORGZcGU
         MHnVqkxQ0rCx1JjcDDQDfrmKWB2LdlOkdDdEFnSGPHS0NNyBlesectZvrI7t5faw2sa2
         hherc1icRq6U9PTFgxQ4ziDCcM5hsGExAFk35Ae16VeaLaz6DEA8QyQz5lkb6w9Noo2W
         LIvg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771661753; x=1772266553; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqJhtOyCKaatcPuVbcWAYul34KhkdgQblBgCMkQEGTI=;
        b=lJ0OYi/BPilJMWuhMZr+HgU2/g+EcS9C8nxNDlkfGaxhxrFLgbZIlOY+rcWGd4Yh3t
         q0kbbVV+uJvMBUWTQ8xklUyjDjldUGX4VBJ6wJpb6bIyBq1zI0uHX/GIUKVEzG4X2+1A
         fTycUKXldKsL7cAL4wXJznjfqtIxPqU9Ja6jDed31qzME1JUh5VaYg1dSlwgWzzUEcBT
         FA+3rRD1ReWTt4Pe/QpoyfuFMeScY1gzrUCurF9UmA41vm0+Cc3GSQg1gXeg4kZeNmKz
         FofqHnRrlkRemuEA73W5eEesLzGreadNGo5dVDDEvvY7sXQSkBag1TFpoybuVLodBaU7
         dtPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771661753; x=1772266553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pqJhtOyCKaatcPuVbcWAYul34KhkdgQblBgCMkQEGTI=;
        b=p7YLNHAjbg7RIcn0msZRWIKmV57JnGNehxnhwxxqDjdAfrYSLM7TxsYBYbNndv7XCu
         MR8Dez0Df5LVonjWRoFFSc5x05DhK9PbgaIgrvLII6AZpcFOV55ww3c9Qq+O96I5Ec9F
         Gi1Q3jVwGPEttkbakhpab+7qoKIoESNh+S2uBxgQiN26RDwgACPWxlWnky8g19hPSupY
         30GHLuGqM9pt8NzaS55qKcGCLzYMPFHFcGdhaOIjY8ItaCbgHr4isyv1poF2870DsMvy
         vJlQ6H8pmUqL/Z65+c4+BfzUgAPQm4Is7h8fecf9e0n9JAavmG2CnjgDDKQ3j+pFNp1j
         UfLg==
X-Gm-Message-State: AOJu0YxBVNSMlm44AHJEQWxkTeFaHEmQl+lAUqTWmW+p1VMWGLKjYC9L
	vyKaaA1Gp/Sp8WLoFpHgvd4uGw5o/QMMuhDepAAqjKdJdFLM61bB1CtutFGiiOua8qidz8/dUn8
	wmc/jeub+oF+M8Br3JcDbsLdJubZx9dA=
X-Gm-Gg: AZuq6aLT2BU7H9je6R5HHVEwSp/u3PZr8r8OhY+trLIaLM0B4c7Bp85/1WrUX7eFc1V
	mP0m7hkaK67imQ6ItmX5E5t9rpirl4B7dqxxhpZngC4YKBH978i68efNPGpkL4wh9KApKLHsKHM
	Ac7X2WEN4KeLwSu6dxN86Kn4VgWb/s1EesUqde544LpT/Uv7rUF5JJ39tM7hi/vlqseGo0U9dUu
	zCfo253U+3/aAFQYNDOB7didTHnJVeSiiW4mNi60BS/A31juKifQYbsx5Qh1e9Ktf/ofjlYSwnK
	hQfw1g==
X-Received: by 2002:ad4:5b83:0:b0:894:773a:4581 with SMTP id
 6a1803df08f44-89979ef88f8mr35023106d6.49.1771661752857; Sat, 21 Feb 2026
 00:15:52 -0800 (PST)
MIME-Version: 1.0
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
In-Reply-To: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 21 Feb 2026 16:15:41 +0800
X-Gm-Features: AaiRm51aBJQnXsyOpa3tomJfwexW2cBBfl33LWP9FjuNSVqwIZLll-dWCZQAZ08
Message-ID: <CAGsJ_4xF5sK8H1RsqRNoi7DfGBtThASsozY30gq_kdRLaYgaTw@mail.gmail.com>
Subject: Re: [PATCH RFC 00/15] mm, swap: swap table phase IV with dynamic
 ghost swapfile
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3FC0B4000D
X-Stat-Signature: mcy9s8skd4nibabssi1e76shjdcj7gad
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771661754-212568
X-HE-Meta: U2FsdGVkX1/Nsc3LyLoaopeMsPIsNpiY/f3OjqQ72v0Fi7rWpcoI+2eLKh5jw4oApBSwtuxE6nNf5FxrXU0mzoyqP58FdRvpKt7bDe9Ub3zgLAXt1jheyy36RPsJ+JeYTbVFpg5+cogMgErpLxTq3CSjXKmelI+9raOxWpbNkzU3sHo/MdXM6N+QBksiQmJZZVafIdcIdCinUJ237HCUVkkUllq2SGZAMyPCoGByeEBVx7IZeKXjkE8hFR1n5mqbvrXUMMrRVupffNGdz1HdKKrGmh/yewOqn41CKJj6o2mE6LeaRKDOxKKMVgA6Z5Ur+uqDKAl97AsFSvjE3YHVokmTb7BzDcvjHpyVxi01xZwZn87vN12sFJXXxM9x9Lv9oegk1dy5e8P89hxx5D79kZ+2wtSa/kc/uhi4XY4FZZv0LdlKsc7cWe9RfckpkB3KYlij2Zvi/mezfmDgZwJG6647oA5hG4Ev+8V33v8b/rNZ9eZRoxefhpAcYKOvlP4+IM+vfZd690MDVIjSyCZWI6nBPPQ7ILiNiDfYi7B5iCLAz7vGMza3RjWfGilDX3PjnU8W8WPe5LI/8K4CdKzQorTgJ4pdD4NQ7SPQi+F4NIAg5TT+QF4oqVCfH69NRjOPBO/qB1Oa/72iSeHETlGRkMKZ+YhQOp7DNOHrQO+jvl5aLRemaA3mmU8H2gZYUzBdZb03Yvd4AqfqS+sXEU6jJNC2EyZKCJ2AVMoXe5RnYc+GcVfNUXdkXs7FGiLQZQEmMmF8ArXF53XqDRe+4MIDhHrF1F/zDyfSFJC7cAsrshzMce9UsDTouSoLQiQK3XC0xdjgUXkr93GCNniHmlWRwp9NyjPKdx8154toiinuyvdp8kP0wxooBuNx3KbaxzqrGd3t5biql5w9RaSD3aFUgMG5D7etlBjhfcFtzCVq0fJLo1ppJWClKn4iEn6wUZhUo+4CJfIu/hCm65Ml5XL
 R9w8YmHI
 OZroYlXAI4nZ03S1u6O8S766eSsmN5xiViYWYEPGPJg2E0KG7yS2BKo2h3oTkZea1FHDboM4gmbHtWz6/jLTaoskaQRyL+PrgK0wGOtEokcPxnieBlfPc0f6VZAUcuCBFsCgqi+ZkMJxmNXbXZdf1IZ864wKzdDeajEKz3jbYt0fWIiNwRJ3wS9HfJD/o3BLwE5nGtAUiD0pG2kuCRYvUn5AUJuLPMk39df/gW/LF+TFnVNvCTOato/0Iz6OiOwdkwQZPWins+dXWJ1LWGfQyAPTa+0fBSUsU4MzY5qccwP2GTrTdsN/VkuAE9zHO3x/fDMf4QyqeHWavjAI8kjKGTsr2+9H9LkZmD205lmUuSXi3P4mzuJ/H4wUlciUhCCriR4QOffM/6QvAmDARt4p59s5OJmmeiZbbAgEtulgSeU56vkWyiS8DiIS/TMCtXmGetmuXQZEC6mKcgrtpSsj/TY0JAEOmt/ZkSh94zC9zMBonNQpZxEf/U3BJWl8w435UnVN6rfTn1HHRWqY7toKOreXT9bLWIc9LnKjKkmNJ5awaI8V8xUuHE1LHKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 7:42=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> NOTE for an RFC quality series: Swap table P4 is patch 1 - 12, and the
> dynamic ghost file is patch 13 - 15. Putting them together as RFC for
> easier review and discussions. Swap table P4 is stable and good to merge
> if we are OK with a few memcg reparent behavior (there is also a
> solution if we don't), dynamic ghost swap is yet a minimal proof of
> concept. See patch 15 for more details. And see below for Swap table 4
> cover letter (nice performance gain and memory save).

To be honest, I really dislike the name "ghost." I would
prefer something that reflects its actual functionality.
"Ghost" does not describe what it does and feels rather
arbitrary.

I suggest retiring the name "ghost" and replacing it with
something more appropriate. "vswap" could be a good option,
but Nhat is already using that name.

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
>
> Currently, the dynamic ghost files are just reported as ordinary swap fil=
es
> in /proc/swaps and we can have multiple ones, so users will have a full
> view of what's going on. This is a very easy-to-change design decision.
> I'm open to ideas about how we should present this to users. e.g., Hiding
> it will make it more "virtual", but I don't think that's a good idea.

Even if it remains visible in /proc/swaps, I would rather
not represent it as a real file in any filesystem. Putting
a "ghost" swapfile on something like ext4 seems unnatural.

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
> And for easier testing, I added a /dev/ghostswap in this RFC. `swapon
> /dev/ghostswap` enables that. Without swapon /dev/ghostswap, any existing
> users, including ZRAM, won't observe any change.

/dev/ghostswap is assumed to be a virtual block device or
something similar? If it is a block device, how is its size
related to si->size?

Looking at [PATCH RFC 14/15] mm, swap: add a special device
for ghost swap setup, it appears to be a character device.
This feels very odd to me. I=E2=80=99m not in favor of coupling the
ghost swapfile with a memdev character device.
A cdev should be a true character device.

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

Thanks
Barry

