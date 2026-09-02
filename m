Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6456BC624D7
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78F236B009D; Wed,  2 Sep 2026 10:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 712E56B009E; Wed,  2 Sep 2026 10:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 600906B00A2; Wed,  2 Sep 2026 10:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33EF76B009E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:22:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C8448A3CF4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:22:51 +0000 (UTC)
X-FDA: 85169038542.19.40B77BC
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id DD7FC180013
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:22:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I7AqozNI;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788358969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6kJ6c1h0K+r9+chFszj0JIJxELOe0sAVph3Dxv71sUo=;
	b=pOzcRQBaXoYTGfDIrostuIO2bsM6wSnpNcRS3wfWBKttZWZU0CQ9CGUBec+6Tn+mgetjN3
	QBFCyVjkZtuwFV0B61R7Z72U+FYariT27BlZ0rwHXXGHyyp6nI9Y1dxJdMoesUndcOuLdz
	RpUiGCRfyNrkf5ioULWd/JRAy4RwXvA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788358969;
	b=qlB5rlvsKeANinyqRnWFzV4awC10LtAv/AwYtu8/ZMxnUqqvb571xpWfSKtmoHotP6UJ3u
	delqEhCSvLRSNxdcN7XwiqBiL5X1KbWLWcnj8RyFkr2RHgjT090xtw/aNaL1wGRnNwthEi
	ZcjrQySqZFzTusfNpXjD/9h7LvjLrWw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I7AqozNI;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49b392ccaacso16354455e9.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 07:22:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788358968; cv=none;
        d=google.com; s=arc-20260327;
        b=S1SYAUsfmjtktHQqU0BX9q2KDrNgk0vhyobJ994TmwdbR6hs8WjqHo9qNvdnarOiFs
         /1/skTO0nMjassAqDy+kAMfEAJSW4gIrqZgpwLPty6UAvwn+xrA0pzMoU8Bv651YGUoo
         F6rsVY/4jZ/4QcutGXPBv0dupCgd8KIHhPolJoam3IIves7+lqh5atQLTY8xcl/n4IKx
         ikA1INuwDEC7SJNOwHpo8jDc+4m5ZeAQfcjEwnPL8K92heM4VR+J6E0cun5heHjnVf24
         bYvnyESF97FAfQrRufD6KN7o9NVGQt32yzebi50S7X+Jyn6lRu31X/Qf8iGtV6+iIwnU
         IfkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6kJ6c1h0K+r9+chFszj0JIJxELOe0sAVph3Dxv71sUo=;
        fh=2Qzq482pFrwePhcI01oa+qeXBks7kCgpGlBaNsWVV0Y=;
        b=YUBNRQ31QCHYtyyOOSjaov+UZtPAp5UNVM+hwHTb6Aljs+Y2Um948L3dpsHV4agF4o
         Ul9rDJ0WbjLbCzIwErQqtvH/z4pi8Iq1CI6IXF5p1kfGJ4YkSaW/QN6bcGTdZ8rGnR6+
         E1W6MGJNtpe02gY7g98pXEDFE8xH28QbcK3V0Oq0lJeWVTkaMz4cnTJpfbYaE2a7IICn
         Utij/pVZ1g7ovOuYu5+H2sCdLH5M5+0iUCxofabzUQrqSYsGBR7H4Tc1bT5pNhBJdgbr
         EO368CW3qxy/pVjBppsTAOIAVdhuLsIxgDl3MhcWE+bhoFJAKxGFeeJD+32u6gzOvYrp
         Ascw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788358968; x=1788963768; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6kJ6c1h0K+r9+chFszj0JIJxELOe0sAVph3Dxv71sUo=;
        b=I7AqozNI99cVIW1H8FOl9bW5xYYjuVMLOlylBX4PxArjW7DPofg29aNNkahmA2ledu
         32AiM30bo3NK6jA3pHqKzYd8obCG/TYjVX+9R6+mm7HS9I8XupBrmGYS7g3emyjYg8Tx
         uw5I4D2SbySn8gZbYQITCZx+nvnCwmW5UP+LS4h+o0CZveR0e6htpccKzq1yGPg7MZI3
         wv20gqR61yW3SYksLpDWPWLtuAzgUADX4IsGizIeZH7gw6cNJMZkbYTJiHuiQCHgEkXm
         +EW1ZbSv2H4R5N4QSbdeCgxWl9jfH0Mk7/65qafLnBjDuLZPRMrH+lZ0pj4Oz3oN2hn1
         wP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788358968; x=1788963768;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6kJ6c1h0K+r9+chFszj0JIJxELOe0sAVph3Dxv71sUo=;
        b=Vo+285LcwbD/NcN7zi2hcgndpAOO4ckiDih4TZ2slnNktcEX66vGXO6vNWHlhHh2EI
         l3HUo1m08VY3lPruMuuSgJUwVRS1Nb6yfjsjT/CTAY8wKTaZaI7aasOdNv38Rdn24hMf
         x2wLk960su5L0jZLJH9Wvqs4K2U1plPzxBKgcTLQ/xk7lONtE/6uPXpYLhdiy9gNB7BZ
         C7k0jGfW+mwXoVTNS0H7UB9xgNAa88taMyjODxtEtNxVAof3aq82xmA53zVHel9SSVNk
         lhLs6ns5sm/6zs4a/KpF8Nz+uSArbfIA/vqO5g/A7zpOg6NUX5pbV+STzlPyAIVyGRf8
         oIvw==
X-Gm-Message-State: AFuF++lC7qHhCoEDxeAx8CjNeSs7KvC/gwEwzaMzodILczwU3S8nVSzJ
	6o6AafJkQ5X3qkFLSPKIx+dQC+4sMSW+5pUxfQx4Sc38xnY9o1wkiX2g5IXelai/mgDCMOMSEHQ
	BafFp/TWEM9wqfK5FG68jismOteaCBaU=
X-Gm-Gg: AR+sD11+ymRO7nrAD+ihHhOrcal+LFrZ8oKHTzVCQeJPIuNM/SPXBy7o42lqDp6vgVo
	P1zq31s8gon9yEBXv1OB0QKfIXGDKfVyBDNImLfsfpMOiQ+DWXcj44LRYekIUSiArcQHReONP1k
	KsTmBL3NTiBQVm8K/4RGVaxekX2gVKOCfbGjHQyxRbcGhytBqfAIAONg4BRGSak7W2vAfYPlckK
	7ZwKcDVgSlPaHh74nfkpu9lYE6CYk2LYHgvozTNQJc9aDAZaMB6+JrAAVcPyY9f9RY72UOBYQYn
	dhSB49cWX+F2aCr6n1v5xBWFZ2HF5H/9EN9TdkdLPRJ1opOjII306GIex3L/cJbKP40A6ndpZoP
	8Qw==
X-Received: by 2002:a05:600c:1da1:b0:499:9eb8:a1d7 with SMTP id
 5b1f17b1804b1-49ce5842935mr111961815e9.9.1788358968186; Wed, 02 Sep 2026
 07:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 2 Sep 2026 10:22:36 -0400
X-Gm-Features: AcwNN1XHngzaHLhUNCqIXTdftrG_CiGVj__UOOGYwakB35FZUOuqBaGiqnEl-Sw
Message-ID: <CAKEwX=OW6M5n8u3L_oigD3Ffn_BcB2L7p=ROfmJCxMKQFH7tXg@mail.gmail.com>
Subject: Re: [RFC v3 00/15] xswap: extendable (virtual) swap device backed by zswap
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, chrisl@kernel.org, kasong@tencent.com, 
	baohua@kernel.org, youngjun.park@lge.com, hannes@cmpxchg.org, 
	yosry@kernel.org, shikemeng@huaweicloud.com, chengming.zhou@linux.dev, 
	baoquan.he@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DD7FC180013
X-Stat-Signature: 3mq4gm14a4dggtckb3mndz5k67iin1yx
X-Rspam-User: 
X-HE-Tag: 1788358969-589003
X-HE-Meta: U2FsdGVkX1+S3fXrUi1NXaF9ejj/fXeJom/hAtMmAIQL0ShN9yUIwB9bytJ/SDLu+5rcNlX7wLuyuFEQWUvTojqiOcBmBapNrvMF1MaI2sHQ6krxNwAhj2gXZl3E3DUVojFe7ZhCjoK5hPIE8J/DplpwtnnlO8Bi1AMCpZSQxaEoB4+r1FU1+lzgxAPmv5ezGOHmV/t8MwS0rt/PeuEQnu99dBMc+WTrxdtmdnwBd8CHyzF7eTHUY4W0/oc3nbWIb6glaV2t7LwUUQ4R+7HA2sHwjBkaR2Hm3aeFpkK0H3+5CWHHop1C6Ttg4i74nZfIDZTmJjBaq+pr96Asyw2AHO6X8wUFan2NB7nUMJf+L3Idz7XbCggUFL/6iBkT7/WkoFSADfNdg2hd4m5GoflK83uEIVu4nPKlA2SsmYCo/Ruw07yAx6XBqy4SQDA7UpAMSFvU4dxXM5bi4oSlWH2ohvhjnduZBhBlEAAGIqUvEmcgyVcxRIfYGAjq4jIRqJk/mvVd6ERIyddbYbmx+3x44mlLFh4a3VXYOEK29+CFDLTKpwa7ZRYG89TXDWNq2Bx+8K12m9oKSRt4GvLuIWHkAyaozVsuMETEaiqAcU5qYSX57MnXxbDzh1Pkn81hCjZhSEJc41eZi0nCQ3Ei80A7/dkuOOZx/vwFR82aYq37sE/JWp9PMC9gicEw1LgqHHifzn3horComTG4beg/bwnA0g83oHyk7Hqn6CSWzGxLYN4VpRPwk8wFWqzRXno5iplsB8P00tT4Z7u8etW59NRfmDZi/lAn4rRd+qnEHnnI01rkhOardU+Y7xgBVhuEtfGgSE/BjCxgSdTz+IGqIA4FgyKZK4vzvEzKslfO9Ok057j7gvWaDx3PbnENn/VoQsMMFeEj0rtQwTlmMBMq4rvlg8O8xl9t+2wfzLmErsodqDxgXn3hNUHdW6FOtjKemR3sp2PyjtAb5HFZ+h3wxNT
 ZNxO3feB
 fg3phNF2L+08hdE5avUOy2ID+5+wZXBXTU0XxgESI/23ZewxjlPgctvpf9ZBVtJ4QmnfY449sXNUDPZlm2E9hYGygRqYu4gn6eiRNCzVeyz/XoqulWI/3LoR+UTVeRbyPkKoH7DZEUx52vEBzgHMm8mMkQrM/Cd6Ytdpsg9FiJckcONw2tTWfQhz+GeRrF8g+0lV+imqcuCA9OGMv9wdLF2bF2M72FpuGldfBngc8iErPe4mS6MuY4vFC+r8aJnyJLbKLxMnC4pr74YHfvKAm8qWefiV406R34wDAARLhDgqjko9aaKBZ0g4WhqknAYBKR2Ho4AXrThHSGb2S8Yw4YETxImnU0MRXwwHfNc4lonaag6E+MKRu3RfsvyRefq9tjTMdKlHUKiFPqSpj8PnSNcGHXpO1Ofzq+yqR2yh6Ec/NZIrVkbIIqKdebiV6CENjVn4nyTYikbPOBDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 6:49=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> w=
rote:
>
> xswap is an extendable swap device with no backing storage.
> Swapped-out pages live only in zswap, so the device wastes no disk space
> and its size is independent of any physical device.
>
> xswap decouples PTE swap entries from physical backing storage.  The
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
>   /sys/kernel/mm/xswap/create           write a percent of RAM (0 for
>                                         the default) to create a device
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
> (co-hosted with Yosry) =E2=80=94 the swap ops and the xswap extension int=
erfaces in
> this series are moving toward exactly that. I don't have a strong prefere=
nce
> between xswap and vswap, so if reviewers object to the name, please comme=
nt.
>
> Note:
> =3D=3D=3D=3D=3D
> Most of the added lines come from the switch to a sysfs-based create/dest=
roy
> interface. v2 created an xswap device by handing swapon() a "header-only"
> swap file (mkswap followed by dd of just the first  4K), and teardown reu=
sed
> the normal swapoff path. v3 makes xswap truly file-less:
> /sys/kernel/mm/xswap/{create,destroy} replace that file dance.
>
> This patchset only build the base. On top of this, I believe Nhat's core =
code
> of xswap writeback, rmap etc can be implemented simpler. E.g, we only nee=
d add
> one field in struct swap_cluster_info to let xs_table point to physical s=
wap
> entry, or zswap entry etc. No need to introduce struct swap_cluster_info_=
dynamic.

It's functionally equivalent. I think it looks cleaner to separate
vswap-only bits into a vswap-only struct (technically saving 1 word
for the cluster that doesnt need it too).

How would writeback, rmap be simpler? The complexity comes from the
operations around it, not the actual vtable/xs_table operations
itself.

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
>
> Testing:
> =3D=3D=3D=3D=3D=3D=3D=3D
> 1. enable zswap
> # echo 1 > /sys/module/zswap/parameters/enabled
>
> 2. create xswap device
> ~# echo 0 > /sys/kernel/mm/xswap/create
> ~# swapon
> NAME   TYPE  SIZE USED PRIO
> xswap0 xswap 1.2G   0B   -1
> ~# echo 80 > /sys/kernel/mm/xswap/create
> ~# swapon
> NAME   TYPE  SIZE USED PRIO
> xswap0 xswap 1.2G   0B   -1
> xswap1 xswap 3.1G   0B   -1
>
> 3. tune the zswap size
> ~# cat /sys/kernel/debug/xswap/type0_cluster_limit
> 1179
> ~# cat /sys/kernel/debug/xswap/type1_cluster_limit
> 3145
> ~# echo 2048 > /sys/kernel/debug/xswap/type0_cluster_limit
> ~# echo 2048 > /sys/kernel/debug/xswap/type1_cluster_limit
> ~# swapon
> NAME   TYPE  SIZE   USED PRIO
> xswap0 xswap   2G 377.9M   -1
> xswap1 xswap   2G 376.2M   -1
>
> 4. add memory pressure
> stress-ng --vm 1 --vm-bytes 4G --vm-keep --timeout 120s &
>
> create/destroy and grow/shrink xswap device casually, all passed.

Sigh.

We have something that has performance benchmarks, including on a
real, production workload:

https://lore.kernel.org/all/20260825153238.2695446-1-nphamcs@gmail.com/

And somehow, we decide to implement a different data structures,
without concrete numbers to show that it is more efficient than xarray
(only intuitions)?

At the risk of sounding like a broken record - I have to ask: why
don't we land use case first, optimize later? Especially since, we
have data showing that performance is fairly close, AND users who do
not want to risk it still have the old code and can do A/B testing
before they decide to switch?

