Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1EABCD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAE9E6B00A2; Fri, 15 May 2026 08:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6EB26B00A3; Fri, 15 May 2026 08:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C840E6B00A4; Fri, 15 May 2026 08:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B77DE6B00A2
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:53:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 62F541A091A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:53:22 +0000 (UTC)
X-FDA: 84769645044.07.FA1DD63
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5ECD740003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:53:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NEeaZNOf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778849600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ke0Li5xx3d2PGZfPx3tj+IVT63oudggFt2tC7FV9z5U=;
	b=qMx9dbUn55yVo59H7LEnsw1EP0S57g2Ovvc95hYHdgympHU/KOe+M3uXaJXBO+CAeRnPZi
	eC60067IHTJenqzwQpZYK/ruPjClUP8zM8L9Sh/zHTkX/v8gPsf1dqzyhD6l43+pHddkTP
	5f2Js4R4KLcHA8IESCLmUUeZ90o8kME=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778849600; a=rsa-sha256;
	cv=pass;
	b=db+JNygdyFNrRynTEGicLTBp2LeQkEsgCO5weVu49+07IZYuG3l+wQcS60MYMKyIxQodOF
	txV/iqj3FpmxTuab5neJ0e6VvSi4lSFJGPBpdTckLQEqBrGG2N/vP8HyO9ZsMYyFJMs+Sw
	CidBfLYRv6qiwfH/XkFxSCNnMpGtx4w=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NEeaZNOf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bd22b2abaa4so764757966b.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 05:53:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778849599; cv=none;
        d=google.com; s=arc-20240605;
        b=eDE2NdebmSYoo2RbPSs/xPteTdP18McgJ89lW7V0x+6ggo00ScInmb7yOJO6Gb2nUA
         5/W5OZGrDezpOHXgGbRU1SNv78H3WRjVHsl7rL0cvLflbhMBIjR49bWbeHYv+Jtmxe7Q
         Haddex/2dSu+XiL/AFnTcF8xAQGdoXkkmVznaotnEJP16Xu0omXBmKFSVlY+qGqiTQYs
         LMsLxmTH89T8fLR2p3Qel0xwdF55sNgKlqZZjdPJQolZwZjoBvdRUODzCtPJ1qDH4IZ4
         m56SeLLSUGaG9+EWyc7+T86de279czsDK8ByMjH9DWzfmRhQDhevRJDL2curXc/rg6f9
         Dh1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ke0Li5xx3d2PGZfPx3tj+IVT63oudggFt2tC7FV9z5U=;
        fh=wzNKpsqbeQ5RcAsJTmqnt9NzFcAS6rswX1Tk+BZsKDg=;
        b=OOJsoL7TTgebtq8XNG6I+RK+ANCkJKPzB60qgxy2txHGW99ZuuIkoa9YVCdt0Qcc2Z
         mRx+nCWC1/Tmf55kjyjUxc2FDZaVWAovTxQ8ccjlI51lOIq6xCEu36eGftZBMbBQpWbS
         u9cX+HzjVbCXuPE8GXd58cUyEIat77RI0vB4KLKDjhIX9/7eiL8hxn98I1Gvu7deJ/Uu
         yXVO23ZLx8fr0S6bTvqGVaJZ29KEtyuHmBlL5aXZp+xnAEt29JkQB9jekY84MZbiIXqL
         oVxUYyiwFQIkPaHXZQzzyin+oRx+6qMt0S1cVLMIaQ6f1ck3invEBPc5K1YxvtSAOglH
         FWqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778849599; x=1779454399; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ke0Li5xx3d2PGZfPx3tj+IVT63oudggFt2tC7FV9z5U=;
        b=NEeaZNOfzbRTIcKXFR/0uk9/O3MDfT7qgGFKxagt3XnC85e1VBAbtlpjf4KYthSN6E
         tk3mfobbPU9ZIGcyVp+pbicH0TGjxhYS/qS7SqIPwLG5wDYRSELMSfxatYdR6B4cGyTL
         mUNg4FOn6fp7h+wFm5qXSGUR/L0dZBPRwx5OrqfguwOc8yW5Yd8b1B9NeC73aFsZpcjo
         7q2OG0hBXNqZ2ZJRWqZWk1fbkIp7kdTFAsIJfbrVf+dFoxmVDb9BN/8hjhtbt8XFKQqp
         xBiBWi7foDYHYn8ApbflGu2J982pKsZgOV0B6THZ/tEnBtXZ8inikgu2gZ4NQnDIDfUm
         Id/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778849599; x=1779454399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ke0Li5xx3d2PGZfPx3tj+IVT63oudggFt2tC7FV9z5U=;
        b=BBnkyyeTAigkLP/zKDmZC1MZvmVZdCuC43f6tlGO9dobYnR6vvb03KhQbx9VZyjAP3
         ziy/P8PMIMq5amHd/TrBnQLHmBiuMgvxdVzswO2xaV6feExaDW5tK5nosbWFZlUnOyB2
         /gH8aHecEphWoAo1LoDqBHqOnbQvPpBFFM/CvH+opHXAoq+5N029md4zPEseHTo1v99Y
         9VcgmoY3ukMAKnykr1IugRKtfcm0ss1qU6ZgFeWhyNuM3hZnWnziqZBIrevyK0sSBHee
         jOoyHZVPvMABsZN+h1QRe2EMQc7YfGqyweOzRCqpegrsYEfyJ0xJlTJ0cIk5C9qyJ0Fs
         Yamw==
X-Gm-Message-State: AOJu0YzjPHuiAggh9GRtqZ/AFKeVKQXIC3xis7MdgvtoFhBP7IEYBLTY
	puZrQyqoEcL7xBFbUcjjhrsDREOa/bWNjQvL1mQxLo7/D8L4rgFma+SF6+zV2Ne9YVAJupKgyf1
	8yITgBexu9LhrmM13JEzMwypVnyRqCQU=
X-Gm-Gg: Acq92OHR5W7SmneTQnLZPeNYtDm99b1BElODwihUGajGIZ8XQpsr/WRd/K2/gGmN/Qq
	V93kuCY0uIT35GnquhFzgeoortZlZLlZpuLh0x8fzn+i6Sdb6kMYGPcN0z6BNDmWQTBf1IcMFP1
	nSSXuv1MENItwg+3vRjnqFjwY7rPVipqSajqSoOAf3eaK83FtNUat/mVyQATxTi2RfnBeKg39so
	+8O6jrchtF1Z5PbdijQdUsMe9Ld87NCV864NES335sk3OtiNIX8QIdEUV8PacWZxXkGDCmAIBCj
	GNWeKMEjWuI440ZiySuQXqpgF5Q9VHFzh7lC8T06
X-Received: by 2002:a17:906:f5a1:b0:bd5:7c3:ac9f with SMTP id
 a640c23a62f3a-bd517aa8204mr200673666b.47.1778849598429; Fri, 15 May 2026
 05:53:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com>
In-Reply-To: <20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 15 May 2026 20:52:41 +0800
X-Gm-Features: AVHnY4KKMC6UsoCY2OZW80O3AVaXMrw5VqL9AagwO8cKOz1-c41n3YswGGjQ8iM
Message-ID: <CAMgjq7BpZWs22W4F5G5vT2xskQENsoW3vgsKUvcy6KrNPb9B+A@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] mm, swap: swap table phase IV: unify allocation
 and reduce static metadata
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Usama Arif <usama.arif@linux.dev>, fujunjie <fujunjie1@qq.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 5ECD740003
X-Rspamd-Server: rspam04
X-Stat-Signature: y4hf5cf3bkq4shkhzqhaoz3znk4kbnga
X-HE-Tag: 1778849600-341015
X-HE-Meta: U2FsdGVkX1+METkF9U7W4CNF4/v4w/Lbh9owQI6jHtMB9xHj7T1OKIjZ0uNT+Tb7xXhJwUgMG5i8bDVeNm5EDaITzQfe9zWpG7FUUgobsV2rC81xYR7Cx2/Yx/Re+NtzpKhvFISJDBP7zqMMEQVTlMnxKQ7Wc0/rftA/m/4hJB+D73nY4GG5Y0buYI0uLexfEtBkzmLIl1zLc+g6K33LixN6rNfDccKSDa1N4NL5gYiKqLow0tr9YnC2gWg1X4iIJuOG/lDk4WN0UkOhpK/5j29xLSGSOYgf/UCOQd0wEW9IcS4rj4MJJr9PZHsVbDjLfqbVv3dK2pswO59arh7coTmBxOaG71q7QFvOFQRUbixfzH/DBU36XFvCY1QknyugxLcTXYQ8Owyd9FpJs9fWGZOzhKT3TE7ZIQij3azTKr7jKs/pLKDowDgwkM33KuAA5Vx4AyM5nospNPbSedyhJ794wuNtVkaW9F9zzuIepm/7xxxIuOQHV3nvTGFW+YS6MJWfQAv9Pgi28rNJSo/APY1rwvmk2Wj3dYXBY+HOyaGj9kmuU65M/TrEEQsiJcUyR/4yZcZNRZ5ReA/GqGi8KBTrVo/H3eHkb9PPhDNOnS0atwjreMseCwYMEjXuXb8jds+8+hzzyl5d3zAF29JrsoyAnQtdByb7jcz1A4YX92jLHYMWl2g1AVnAYLpw3+Z2fAd7BkMws5X4cfl9eFl/7+TGnzSW5MxdibijrNG37is5/b9ELK37+HBFCKCJmUnGY/rHbWizluf6FTloXUX2wKZHXl6LE3d75MhuzFXEx23pWbqRbwDx4qEc8DjaJIX55mq8FGGpcs13GopmtTqg7dRnSnAduoBgkOGbj2xdQYuW5LC1Hjh5P4NvCw7HL34U+4Zpg83WEv5my//aNxJ0980ScZ4/fv8yeRtkg4+FYL5pbCmACmWVljU8cLR0jvmRcFDK2mHrjGUz0YiCozx
 9zIas7Ta
 omRZGgLS/91NH7QC0c78n6PV1xoNJrC76NiwJyaCOOSdkgzpYMwuQWej9YeoNbhP2FPvuwQxHVHDwfKe11zXSSvFCefXAs1TzhNKPy/+fYp1VjKN3pN/m70wKGt7wsRPB637iZZIUvYqgSSqwpfP0H790hCRWZYzvSOw8rVQiXm4eoASkuZ781ttNon4EXuZURKAIp/QzLJiXTn81wf4x1dbCS8jxWphJGG6uzZOdbpP1WW2Va1qdiUFcH8wFdhRugI08v4JY/Xjf1i7v2bFVKzzujbkObI1sbfPCQ1wMuKePCDNP5LTuWVioJJGegxEEjr/h9jZh7/0O+o64SJyEkMURlIaKPBUXvEbE9VIZnD4jIu5z7xH/Acn+UFqF1WC+NJggI0tFL0S3zZWNvBtUq2c2OkVGeA8cWmVce2ANJEFDDePrRX1r4/T3hZX/xZ/frkYF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 6:15=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> This series unifies the allocation and charging of anon and shmem swap
> in folios, provides better synchronization, consolidates the metadata
> management, hence dropping the static array and map, and improves the
> performance. The static metadata overhead is now close to zero, and
> workload performance is slightly improved.
>
> For example, mounting a 1TB swap device saves about 512MB of memory:
>
> Before:
> free -m
>           total   used      free   shared   buff/cache   available
> Mem:       1464    805       346        1          382         658
> Swap:   1048575      0   1048575
>
> After:
> free -m
>           total   used      free   shared   buff/cache   available
> Mem:       1464    277       899         1         356        1187
> Swap:   1048575      0   1048575
>
> Memory usage is ~512M lower, and we now have a close to 0 static
> overhead. It was about 2 bytes per slot before, now roughly 0.09375
> bytes per slot (48 bytes ci info per cluster, which is 512 slots).
>
> Performance test is also looking good, testing Redis in a 2G VM using
> 6G ZRAM as swap:
>
> valkey-server --maxmemory 2560M
> redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get
>
> Before: 3385017.283654 RPS
> After:  3433309.307292 RPS (1.42% better)
>
> Testing with build kernel under global pressure on a 48c96t system,
> limiting the total memory to 8G, using 12G ZRAM, 24 test runs,
> enabling THP:
>
> make -j96, using defconfig
>
> Before: user time 2904.59s system time 4773.99s
> After:  user time 2909.38s system time 4641.55s (2.77% better)
>
> Testing with usemem on a 32c machine using 48G brd ramdisk and 16G
> RAM, 12 test run:
>
> usemem --init-time -O -y -x -n 48 1G
>
> Before: Throughput (Sum): 6482.58 MB/s Free Latency: 371371.67us
> After:  Throughput (Sum): 6539.28 MB/s Free Latency: 363059.88us
>
> Seems similar, or slightly better.
>
> This series also reduces memory thrashing, I no longer see any:
> "Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF", it was
> shown several times during stress testing before this series when under
> great pressure:
>
> Before: grep -Ri VM_FAULT_OOM <test logs> | wc -l =3D> 18
> After:  grep -Ri VM_FAULT_OOM <test logs> | wc -l =3D> 0
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
> Changes in v4:
> - Rebased on latest mm-unstable and re-test, benchmark results are
>   basically the same so mostly kept unchanged. Changes in v4 are code
>   style and very minor behavior change.
> - Improve a few commit messages, rename a few variables as suggested by
>   [ Chris Li ].
> - Rename thp_limit_gfp_mask to thp_shmem_limit_gfp_mask as suggested by
>   [ Zi Yan ].
> - Cleanup a few allocation and code style issue [ YoungJun Park ]
> - Remove the forced fallback in swap_cache_alloc_folio, the caller will
>   pass in the exact orders to be used. [ Baolin Wang ]

I thing I forgot to mention is that this will also provide better
infra from swap side for Usama's PMD swapin, now
swap_cache_alloc_folio(orders=3D<PMD ORDER>) will provide a stable PMD
sized folio that is ready to be used as swap cache folio for doing IO.

> - Rename swapin_entry to swapin_sync, it's only used by synchronization
>   devices at this moment and describes what it does better
>   [ David Hildenbrand ]

And the rename here is inspired from Fujunjie's ZSWAP series. This
series should also enable the implementation of more generic THP
(including zswap THP) support.

