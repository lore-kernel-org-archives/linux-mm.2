Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79ACFC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A38D6B00D1; Wed,  2 Sep 2026 10:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57A146B00D3; Wed,  2 Sep 2026 10:33:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48FE36B00D4; Wed,  2 Sep 2026 10:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17B596B00D1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:33:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0CD91A0223
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:33:45 +0000 (UTC)
X-FDA: 85169066010.24.3A156C0
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id AA6A140003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:33:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UQ3a1Z51;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788359623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqyxGctT5FdtxpqEQF1rjk19nIvIrXbfFFAKolYzW0I=;
	b=G3eCQ9wmivuN8bbPOE+Y1NUEeIqUWBya9WuTf1FF/9sBf0mWvvf4wv63nylq07JQ7wuC5P
	TcyNm0AE5ILXeMsvEWTM4x9h8uohcCp7EMCmCxfsIIOhp8uboB70VpY2C3USBCk/qotTTk
	ieP++YPfcMFIyM7s9uGsskcQCg44oKQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UQ3a1Z51;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788359623;
	b=rDAYYOvVukrUBw6uyE0ouydGoeHeh2nhLf7vXuhzjorfDcy8fEiijNO3N1kqX2G290wVsX
	Ir/xCOCcdN7tcxO2vcEACz5unKof+iVq/mEOlusbnuaTF4CbhqEX//dRdL6RLpVrek6BSN
	tC53G/9rf7K2pGIYaCWCfg9kRZC3f3M=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-482f2ee53e7so729275f8f.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 07:33:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788359622; cv=none;
        d=google.com; s=arc-20260327;
        b=sdApYhlEsmTnr/jRLvE6gqS+FywGcTlcj3yFlno3nEFec60OXPLJMKkX43gP8drj9g
         snGidUZwtmgg44m4TfR8P8MDv5AELGQA44ORdQ7QhyaXHhYEJTEqxhDDKQIN+FNADx9+
         TaJdOtwPzEPYaB5jD5zavAnAecoIrgmW2p6ViCrCl+bWSWAynMtmuXWcSIgyWefkRIWR
         KWuCzHu3OfHqvfWfb2b+b1tFn7PGQbgOVtCD4M8rUjy6CKzDk950O69TxJW+OtIFD89B
         4CX9uJ76vukdhD5vij5k5a0wrbBDQeBf0kOSreO7PEzbQJVfcVULRmrFztiZ86gCc8kH
         bnJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gqyxGctT5FdtxpqEQF1rjk19nIvIrXbfFFAKolYzW0I=;
        fh=KewnQt8I1RGzkGmgAsxpY598ouhBlUDawARPe163as8=;
        b=KM1FxaOF387uIGJKbDqF1XTAUkalQDIlXkvbXCVPGUW43xTLWY0gZ4WHaa8XxxoGxu
         N3wbwWb1TyzXPA+p0iX5HyvkK4mgZ7wnS1zGZzBA/MGF3YK2C0DImgkakc/ey+X/285U
         TZvzpHOoPG/Pq7G49NvUSOHkRhVwi+u4z9pdFvyPmtLJ5C1kcauUFnZ41xX8OBU7TMCk
         kgET+uOy88vgAjwpzBpviI8b5Y9J6XraySWcpssvSng8ZQfYBLEKBzuDmj+8g1MhYEpJ
         wqtdZdyOQYQ2l3VxIq+rsYJJPbvBxv3T0OPZFPfTtqj/TMuTm74BRN/aEAeYvpZ/ikSd
         0s6Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788359622; x=1788964422; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gqyxGctT5FdtxpqEQF1rjk19nIvIrXbfFFAKolYzW0I=;
        b=UQ3a1Z51CqcWkxz1KKIB1t//purWG9oqzRvIDRFXyKfHLt9CBrsB/d7dfoZeW7Pdk7
         iiu9TELfbzWyma2Rt+Qto7nIoGezzCyOkSK9Kp6SXjnJUaoq0fenFITPKsJckxk37CYM
         ZcOwjFtZSMOuEptYyfembbEZM45SG4Tt1tFYoQgVNKoEJyF9OBLePl+CzxzVmL/g2gn0
         9IU5bsiq/iVj0Y3MR6ncXqkbwnpaN261pThVtV+easgvYq4tEhezei37bo7GWoHXmrMt
         QrUl3BZ4m855y4+uZjMrR/9KcDR99caKZ/+n8vI6l+2WgyZSjjPQCSLEi574WiT03U+w
         1GwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788359622; x=1788964422;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gqyxGctT5FdtxpqEQF1rjk19nIvIrXbfFFAKolYzW0I=;
        b=lRB6LovHq07nKzJaToAnd5ui5r+k3usXrvNRSmb7//+tfqLD9LaWzOVPzLlgJUuzBP
         XRqzLVITyZEro/nur/+EUd85y4HFq22+pEuBHCDIxChmDmHeLIju2rWYsmUFeA7xo7ov
         MTGG3MHUfonIEwcd5lqppPugpG+2IP2bMEZyYUomluZ6mlSsi1WyOCW4xN/xIebT+fBF
         A/sMkHq6cm9O3PH8DzooaBAn0WbDqfR8IPOsnSen2P6LSiE7dtz/nR+ImM5U2VwKoKuY
         49NhRcqKKXvqAliCLiXCp3kS3S3QOZ8+QDxwJGGMwCVIVnou+q2XvioCsCbLiBfav9qS
         sNXA==
X-Gm-Message-State: AFuF++kdWkXqkQk6kzeoYjWTixbDkvVKIvHm0nHp/MYd8E3Tt998AdMD
	KAynQMI+7w/1IWAkCZS+bnQH3fToiOJVC3lUKb4+oBRfaCidmGkiRh43c1/d1J2senZuV4JMKHQ
	u2zMC4enVpd+in3DrtfFX6eMr9rR1LVw=
X-Gm-Gg: AR+sD112nSnxWrlr0WZS4Y0ak8AVHx07TBs4c/P3bwqy3ZxWNn31fHYQxAKHhku391p
	xC4E8WOdjBpmnx6vdlFz0pudDQZolkC4gO1sBNfZ6RIZSyTrst2VG1+Wly6l/22H/I3UoDt34yO
	yiI1cJEYfo6XNLaLKuqLLzNCDVnkReAzD1FtIBmuR7Q2Tz9j0VAo6b4Xvu7748+eGX9SWgVixLl
	qwQSqs/eDixaMpVrXS5B/8fqMXY9VdGg22jrrBlDYzJCJj0FkBvxNnXVIadLbPHe9St8Av3aIWD
	3+jqN68w1D+R2zaM4tqHkKs7RM7H1uUmDOiAlkk9eDBOvgW0zQbeG+mLxZas2LNvuDWwERZCZB9
	4Mg==
X-Received: by 2002:a05:600c:621b:b0:499:dbae:86be with SMTP id
 5b1f17b1804b1-49ce58352ccmr109404795e9.14.1788359621781; Wed, 02 Sep 2026
 07:33:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 2 Sep 2026 10:33:30 -0400
X-Gm-Features: AcwNN1UFWiuIst1_M2Ly-qV46cbouLxe69zvYrfE_S4pNwJojMnhxWhVG9iKlpo
Message-ID: <CAKEwX=NNzX=sXdqPATrWw7cw7sdG-vOO5LqjH=JnV1YiZLO5MA@mail.gmail.com>
Subject: Re: [PATCH 00/16] xswap: extendable swap device backed by zswap
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: f3d59agfo6ngs5otgjpdnx9bkzmf3fej
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AA6A140003
X-Rspam-User: 
X-HE-Tag: 1788359623-885446
X-HE-Meta: U2FsdGVkX19q6aeewhzIlQwwkoQBz2UdHuRKYJx7sviqZ6fUXqZ/N9QipmfxzQj6oSvC97Mg0ME/KGpocrjGFAriXi5Ggqon5/61hhaFUKFshpaljztEiYawauVycCMdnzq6KT8/7uXHhlY6gZ3jAWFNjtYzPl9fFXJZscMroOPjZAEGNgODf6jFKfQ9CIPnlAiy7+1NAHEtMA/csw9TsD/5fpDHVdb6DjQGL4C0hoYDYLiblLZWJLuj79FzscDw9ihqOCOHkEan+IdBhWABacSGPs5Xzia6yQPEglwMMjlzlQYrE/zNxmkkOs8McBU7eQ9Q0w1yaWVJ+I0NB9yD6OVoWyjrY0orBRV/aVUctGP+PdDccsfWO1wN2Arz78S0Wd3gBTWR052OAbHwoJwTgnIaFC+K16AG5/1QBWTk91tt3xViQMJt9Gm16n1FRgaqYQr0wr66cO6NFipNGNBwieHGZjjINoxk2GMVB3K52/7/BZ/AWFEY6ajJqlTt+weNxjMeK0zduS4DuFtJ4F7Wupirm79QMV8aAWx7UIf2fh0WHTHffGgjy29jOK5k2KvVvPfCjaoWw+NiwrdMtKWfG95CSgKlP536c+2B2PlJM1u86xU30AmCrDEy2JrA8HMmNBrZDhHinYJdEY9C8CzljCOBlZRapmEsMLJQZFU/ntrmrLOHjuuii/B3ijfrOSbHK3e62j5JZBUiK1f3f8lWmzcBanTsjiXAa1mQPBtzzO490UDX60LQdNFb0+ZZuY3m38aMt5+dmqmuELzAsk8qhKu54tmWfueUPxh9Artf79m6qXo9RASXpChyD2lw+LIEO/Mk6ypOeZx5ZHmBi5+fg7YaVCZCFILgM13fEzRExK6zZtDg3Fop8izCtWenzUJbEsK15QIElTvMqypPdh3bc099R2G1Gefj0E9h6UM04mkuB97ZYGzYxxb7+9oIdg8VFHq4e7mvjynmo01NCXu
 /USN8SSe
 VIrGBgJh3QOES9t7coIEA1x4fZd3nPhllNSHkejktU1Fob8NVywrodBq8pjUcO+rnrbftjgIhSYnKn5I7LOJJg3eO91Dk74sDHK8UBG8XqWTzBPgBM3DFBykdqtfMYQc7x1irI1jTkDLAOaF9Y5Etw/WqLLMWk3aJUI7EtjKmf28R1X8LPqyrC5uIgog29WX5MXt3MpapeQ5xe3evds9aFsHfuobhb4xUbL7IuwTJ/pxbrDplxvMAOzlFeTD1ai1mQN+aFHfJl5U/Tyx2EnQN5H+SVFnfmzvMRbD8cMy2JTR6uj9J5j1WJJYsjNzA4i3eQvMbGwrbdczOMu+eNDPpGU6o88MBMbpB2ZYoT9wfT/QWKDpeOl6urMPJLfzfuENLMb/elXCJJuAL0Gq0ltZ468IMonT5fLkYZRmS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 5:45=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> w=
rote:

Ah I think I used the wrong msg-id in my other response:

https://lore.kernel.org/all/CAKEwX=3DOW6M5n8u3L_oigD3Ffn_BcB2L7p=3DROfmJCxM=
KQFH7tXg@mail.gmail.com/

My bad. I'll recap my comments here for your convenience.

>
> xswap is an extendable swap device with no backing storage. Swapped-out
> pages live only in zswap, so the device wastes no disk space and its
> size is independent of any physical device.
>
> xswap decouples PTE swap entries from physical backing storage. The
> cluster_info array is backed by a sparse vmalloc (VM_SPARSE) area that is
> grown and shrunk on demand:
>
> - Grow: when cluster allocation runs out of free clusters and the device
>   is below its ceiling, more physical pages are mapped into the VM_SPARSE
>   area and their clusters are added to the free list.
>
> - Shrink: when contiguous free clusters accumulate at the tail of the
>   mapped range (tracked in O(1) via nr_free_tail), they are unmapped and
>   the backing pages freed.  Shrink is deferred to a workqueue to avoid
>   lock recursion.
>
> A per-device ceiling (nr_clusters) bounds growth and is adjustable at
> runtime via debugfs.
>
> Interface:
>
>   /sys/kernel/mm/xswap/create           write "<percent> [<prio>]" to
>                                         create a device; percent is a
>                                         percent of RAM (0 for the default=
),
>                                         prio is an optional swap priority
>                                         (default DEF_SWAP_PRIO)
>   /sys/kernel/mm/xswap/destroy          write a swap type to tear down
>                                         a device
>   /sys/kernel/debug/xswap/type<N>_cluster_limit
>                                         read/write the per-device
>                                         cluster ceiling
>
> Since xswap has no backing, swapped-out pages are stored compressed in
> zswap: physical writeout is skipped, and zswap writeback is disabled when
> every swapfile in the system is an xswap device.  xswap requires zswap, s=
o
> device creation is refused when zswap is unavailable.
>
> Naming:
> =3D=3D=3D=3D=3D=3D
> I'm going with "xswap" (the "x" for extendable/extension) rather than "vs=
wap".
> Chris suggested this name, and this aligns with the "VFS-like swap layers=
"
> direction Chris Li described in the first swap abstraction LPC talk
> (co-hosted with Yosry) the swap ops and the xswap extension interfaces in
> this series are moving toward exactly that. I don't have a strong prefere=
nce
> between xswap and vswap, so if reviewers object to the name, please comme=
nt.
>
> Note:
> =3D=3D=3D=3D=3D
> This patchset only build the base. On top of this, the subsequent core co=
de
> implementation of xswap writeback, rmap etc can be done more easily. E.g,=
 we
> only need add one field in struct swap_cluster_info to let xs_table point=
 to
> physical swap entry, or zswap entry etc. On top of this patchset, no need=
 to
> stir core data structure too much or introduce extra data structure.

It's functionally equivalent. I think it looks cleaner to separate
vswap-only bits into a vswap-only struct (technically saving 1 word
for the cluster that doesnt need it too).

That aside, how would writeback, rmap be simpler? The complexity comes
from the operations around it, not the actual vtable/xs_table
operations itself.


>
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -57,6 +57,9 @@ struct swap_cluster_info {
>         u8 order;
>         atomic_long_t __rcu *table;     /* Swap table entries, see mm/swa=
p_table.h */
>         unsigned int *extend_table;     /* For large swap count, protecte=
d by ci->lock */
> +#ifdef CONFIG_XSWAP
> +       unsigned long *xs_table;
> +#endif
>
> Testing (taken on qemu kvm guest with 8G memory):
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1. enable zswap and create/destroy xswap device
> ~# echo 0 > /sys/kernel/mm/xswap/create
> -bash: echo: write error: Operation not supported
> ~# echo 1 > /sys/module/zswap/parameters/enabled
> ~# echo 0 > /sys/kernel/mm/xswap/create
> ~# swapon
> NAME   TYPE  SIZE USED PRIO
> xswap0 xswap 2.3G   0B   -1
> ~# echo 0 > /sys/kernel/mm/xswap/destroy
> ~# swapon
>
> 2. create xswap device and tune the zswap size
>
> ~# echo "50 10" > /sys/kernel/mm/xswap/create
> ~# echo 0 > /sys/kernel/mm/xswap/create
> ~# swapon
> NAME   TYPE  SIZE USED PRIO
> xswap0 xswap 3.9G   0B   10
> xswap1 xswap 2.3G   0B   -1
>
> ~# cat /sys/kernel/debug/xswap/type0_cluster_limit
> 1990
> ~# cat /sys/kernel/debug/xswap/type1_cluster_limit
> 1194
> ~# echo 2048 > /sys/kernel/debug/xswap/type0_cluster_limit
> ~# echo 2048 > /sys/kernel/debug/xswap/type1_cluster_limit
> ~# swapon
> NAME   TYPE  SIZE USED PRIO
> xswap0 xswap   4G   0B   10
> xswap1 xswap   4G   0B   -1
>
> 3. under heavy memory pressure tune swap size or destroy xswap device
>
> ~# stress-ng --vm 1 --vm-bytes 8G --vm-keep --timeout 120s &
>
> ~# echo 1024 > /sys/kernel/debug/xswap/type0_cluster_limit
> ~# swapon
> NAME   TYPE  SIZE USED PRIO
> xswap0 xswap   2G 2.6G   10
> xswap1 xswap   4G 182M   -1
> ~# echo 1024 > /sys/kernel/debug/xswap/type1_cluster_limit
> ~# swapon
> NAME   TYPE  SIZE   USED PRIO
> xswap0 xswap   2G   1.4G   10
> xswap1 xswap   2G 315.4M   -1
>
> ~# echo 0 > /sys/kernel/mm/xswap/destroy
> ~# swapon
> NAME   TYPE  SIZE USED PRIO
> xswap1 xswap   2G 1.1G   -1
>
> I tried create/destroy and grow/shrink xswap device under heavy
> memory pressure, all passed.

We have something that has performance benchmarks, including on a
real, production workload:

https://lore.kernel.org/all/20260825153238.2695446-1-nphamcs@gmail.com/

And somehow, we decide to implement a different data structures,
without concrete numbers to show that it is more efficient than xarray
(only intuitions)?

At the risk of sounding like a broken record - I have to ask: why
don't we land use case first, optimize later? Especially since, we
have data showing that performance is fairly close (better in some
aspects in fact), AND users who do not want to risk it still have the
old code and can do A/B testing before they decide to switch?

A lot of the complexity in this patch series comes from the fact that
you don't get a lot of what xarray gives you out of the box. Which is
fine for an optimization, but I don't see any A/B data to compare?
Doesn't that sound like pre-mature optimization?

