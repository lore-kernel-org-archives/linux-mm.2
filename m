Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86074606A324
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=i0plHjP8
Received: by kanga.kvack.org (Postfix)
	id 80E7C6B0377; Mon, 19 Oct 2026 16:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6356B0378; Mon, 19 Oct 2026 16:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC736B0379; Mon, 19 Oct 2026 16:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 485886B0377
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:37:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C9E441A0896
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:37:38 +0000 (UTC)
X-FDA: 85340536596.08.C096D9D
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id E2CFA20002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:37:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i0plHjP8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792442256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PO9p69nb6+vsNmUFhgfonclxpqAf2KqjRDuFhGInggw=;
	b=feqZ1Pq/M5BJWfhlh8nCUYU5CrhFj3IXDUajzsUOiAsE/jely35cQuiXNYFv7wgX66n3Zo
	qbB7g2F4hXBc0Ogl3vrWkp4QOLM48C7vK/qyNB+sRUpOurfhKeozZFOggn3MLAwdoJ3D85
	vvqwH4wiEXx512Ppv8W8c08C9bKDULc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i0plHjP8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792442256;
	b=bQqSJPYC8I0BvQXFgiVrh/2Fyk+JN6zhUht818p0QS/nXAaVGUWpAm2GbNk6ftvgr+ucuV
	lcK8pqd4qlyNxS7a84Qc4Vr3ih720ssJwElIfyQBzYhiYNCB3hVojFV4FUmXG1xshssIib
	2BIN8n1n+oDGhm7bD+IftHMIsfP5ctc=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8ac8a2ac52bso836357b3.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:37:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792442256; cv=none;
        d=google.com; s=arc-20260327;
        b=PYeSu7RVVFeeJwe30YW/+wqodESefrogBZtiQILa4IN51A0BP3kABDg2wcl15wA8DI
         kBiEX6rHet2FAAtL7B/A9yfgLRv6YlpTir0UWDW1+c2W4C3d16DxcbwyMINSxl7qcBuJ
         aS4YVPbZi5hw+FjsiOG+IMZC09bQDj6EECD+joAyNK4SDCKbSt2rvHa/dD9+0Qrmcit1
         KQUYWT6BJKLmarkSxRlyeELl3x6ESSwZr6UhRRwEeZyXT/iS455k+rNbUOJEzZeNcLwG
         rlrFd3+oudnIykYJyV4p27dVCQYJ4v5Iyi5RQ8V4zVsH3wuccwYa7FutQDD9HZQzoWPf
         8mUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PO9p69nb6+vsNmUFhgfonclxpqAf2KqjRDuFhGInggw=;
        fh=N/SeTE86vAtY3XDQ94PsxmbU8ynhTQ+QYNuClsFKNVY=;
        b=YUhanFBK+0twx2WQc6Mi1p8xFh1YKTpS0O4cF5orjZZmmtXbYWbyrpDQjP50SaDunk
         Qww4tLdFX6YpTGEoy7CmHzz+K6T1tviSy9+kymh4AmoeRsKZty2GhS3+EY1ISCJQMrz3
         05s1QrQp5dIcRKHaEZv6kIJewW10uxidjwHE21LdtG/jUIeEcVXCgz2IJp422U955eyh
         uGPi9/QhhpL5sbocubqyOwAKB5cR2OQaa/zwqwWKI9fFc93SosulbgYyIUuTP5OM0iKY
         tUEjxcxVDkLcxra2a4KNYEZLtEdXYlqfcm6VqFppOXDcq1tYgWJj4w7wi1YaDklcTL4M
         FfBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792442256; x=1793047056; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PO9p69nb6+vsNmUFhgfonclxpqAf2KqjRDuFhGInggw=;
        b=i0plHjP8mMIPU/jtP/DjRFhnNGoSt2rX6mWQIbWZtOTpiJEwiBqAGJYFbAe9N6V+OK
         B3ireJi4U7j2aFW4w8B3nY6eTNS2box6DlSud9/g/PctQyPThXIFBwbafr24ZWmG6bZF
         kHzLuBxKTHxH3s2BWyqrxvJ08VTEvbihkpUGGbmrALKlUx3sPxNJMS60caIblEwRYS4O
         gxpektBPX3yUUqSs/3kg6XRQ5LQ9TsT7Plj0QqhTc1sc0ZRM8gzFGHk1y8qq/niAOMqY
         xew7NtKlppC8RwysbKUwFdltHfQxo8/d1sDb6+LgM0y3lXL78f1LvZEmZtLkw7+Ygxhp
         QAlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792442256; x=1793047056;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PO9p69nb6+vsNmUFhgfonclxpqAf2KqjRDuFhGInggw=;
        b=V63Y9EdfOG3uVXu067IwP3JmWXCEi+kNgoqjUWZ2ItWOkddCi4gX7T8JsZDN8vIux0
         Bi06W9FYh6F96T4isRiv0Ebvj8g755hlfHaOF7cfbN6LdiIYGrKh4gvcV6Y0ZHsueVQf
         0zxIntbjoYAg/UQtcEn8WUNHuJEfTjH2tnvJjZEtjph5Q6JlPUFRrh//6NM9EEly4SmE
         FWVmvcoLTU7bLNs63jX7fLgEJ6uJ4e/dmioU4d987cBl8WATl8FfPRtlk3mYoh7pXyL3
         Ptc/YCH+LWBWTQbVMnOHnEitesiMCnwSWBV4rrxigq57XJTDwb6Aa+o2JlRrgvD3MPT7
         nDtw==
X-Forwarded-Encrypted: i=1; AKwUvBzrXM+6VLgjNNhtiuw4SZN/IQE2UBhXRJ4qNST+XtiL+e2oXTlimAz1j2YfTfT2XcizRZh8OeYtHQ==@kvack.org
X-Gm-Message-State: AFq9FYKNSAZUqoViPbNsSydFnugq+d1ml3AsnU4K1YZ/rm++OmouXpsP
	IOkth/5370ExEAxqvMc6hkzYgvuAFzoBvILGPmVCl/a6bhXASHzFgj6ZxBk5x9lMtep6NIuqWkL
	RXD5OtFbQicZNMDjj6WiJALwUiDTIxCI=
X-Gm-Gg: AYBFou196+eYdC8lzYR65vBW6cWP3i3C9gF5hBAMYACBhCJLj87pPxd33HBSHjccbqO
	XDXb2mQ8HzSvtpkzvE5T7kak27Wu21nU0ufiJXbUmBX8gnbozBrMJo5tXeHTjd2Uu2q3CgcB6ty
	kd+n6EKuW+eiKZvOvLhqDZJZQ9N5bdFakGQX5J74AOwN4XrxYAYCjdWoR0HyZV6zBHbcMTESApm
	RXddF2R4X6GxpUMCSyTnQ2ZFJ8wDuMMCKl47Vpq0tWtDr+6p4k9qBQNgpMJ+ESnjXegWSLq10jt
	u2OKgT5YJJpBfIUbRqBC/VVlAhVS+plTxNx4SrXJkdIZt7jQFWS3wF/YX0kkhtXJt448yPu0CPP
	rGL1f7Dbkw5MGF4qD1FTWd7lRMcHE5wxs+mRsDZeh5zm/DHErWsDlTCqOFv9Sj6S+ZGVTB3GSL6
	BkdlP6OKH1NIKmvpFjOeBDhqs=
X-Received: by 2002:a05:690c:fce:b0:8b0:e13c:2857 with SMTP id
 00721157ae682-8b1200efc87mr992317b3.13.1792442255969; Mon, 19 Oct 2026
 13:37:35 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261017050928.128582-1-sidchintamaneni@gmail.com> <CAGsJ_4whqGRQ4JY5rLLJZU=f8u5T75qHkJYQFDoqZSx5c6EBHQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4whqGRQ4JY5rLLJZU=f8u5T75qHkJYQFDoqZSx5c6EBHQ@mail.gmail.com>
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Date: Mon, 19 Oct 2026 13:37:23 -0700
X-Gm-Features: AclHuK9gI4T4O854Y6L1TXMVucW7npKKDzemjhJTunU2ylrUfYVjiEaTh7rHj_8
Message-ID: <CAE5sdEgR3C30xMayXJkWOECQTfADHgNE8Qf9=wjB5eGimjwLYg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref
 with memcg disabled on cmdline
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, stable@vger.kernel.org, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E2CFA20002
X-Stat-Signature: rr4wef5ad3rsbax1u6ut9zpxbrpdg9w6
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792442256-73046
X-HE-Meta: U2FsdGVkX1/tQSKRsMOK9ZeALetgklaXUSH6XApqifnhsfp95xY+ho9kPIFse7jJmPNShHR2pCzCdn+lusxxxbY9+oM+vdn2HaE+vlgvdt4iCxHbQRItFtNUDgv9N1Hi70Lx8+4MBbywWVEywdVBKE2RmlNPrweywgtuKmdBlC6LsgeIzD1pvCXN5SOFzIkVDalLjtn1rbiuvoCsaDkNbXVQ8ounMYURJc58M5ic7iZ+LXaLE8QpKyjAh6F9oEklcIvOWERzsYoZIMM0QAIxOw9VlksOs2s0Zzf8JtnkwFF4Uix2FW5bimN225czqvTtXPmx02K8OCsc4RgSxzbJWNSTHI8O+mZcUlqa3oaPWlR1qaA+zrajyu+uQbarNQzggx1anZttwPh1JzwgU0IZuGtTjHi0MnbwBcqyxs4aOJI82QzPs2Y4eNDbcRq/BRLEt4ty6yl7N4Z1H7dD0LSCF6pX8gXcdhuUR0FCKFI+9uB2lpZG1XOoCMhrch/sdB6OCtriYv2vSb+BiFcUcaq0SBvZN7Ker3xnSNaoFW+u5QHZpakzWMjlS4/UDG3ErauLhbbkYcbLnqrGot3lHhU7mVSHnGy/Xegd9ZB3LgjhYtzVK9VQVd2ggYymloEvR+7hKnCWoGFjMsRpzyrY+QwIifmGeTZoMvkWsdBWlKx+Bbluz58JCF1hzwc/ix2EiEGIOiyGuUfo6ty3N5jV63CnUltuQOuQ7+9qfR9JdXKrMo0LjcJGu8FU+41CeeNziwLl8MZGUJwcWQ6CSwpOGEJLSQZQV1ALdypaqSsgEIkiYKMjVVFL/tvs/h5B1M7LfXa57HtY6lEacdYcsKY/DcAxhKBs04TUEcTux/bPKIAicVmUS0sm83dIPggh1j0VxKsha5PRf6Aq+KSXrQVGLenno5A8fgV9ER5iwt2JPSEPKzxZZyZeyGI1S4yD5Ah/E+Fj2jJtEOYuoBh3EJ56arI
 PsrmXkTk
 6N9cPalbndUrAtWDXzgwYvqOu1o5wZx6jcENyd0Cg5/HxYzqvpNtdA56w4X+x3hWD+mO86A0XTTO/tiu/PUeVXRpBt7NQtNBHv7k6TT/E/VoFrxXgv1sixxRo4XNEXHhFis3w7XL+gl84QF/YR8m5p+UTlxK45RpUY7uEsE6h2L5nyRvtre8diq5zIfYdEcQiIg8w3gJlR3opxJwSqwZPEfyTOh0y2Qp22eHxX+31xgD4Ti56rLq0QE03hUs7kF82SLAktGcvIk0iNfvSAEbjIFVK45KA75CjW7JHP/hM1s5zDJc0daRf6srACwB6WqVKp4alGKY60R0SEXB7YSyxRfskMDgeoxwhcP1Q5McQE3kIrVLndZ1MW8M3zRJVLYj2AlDx4ZYyKCNsj/cponQ5c16xo0jYdWk8bJbToK/iqZpP2h/dXgyglty2GYKmU0W1vLdbdxGfVDelZuTH7f4MklQJFx2N4Nhd9vrI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 18 Oct 2026 at 14:05, Barry Song <baohua@kernel.org> wrote:
>
> On Sat, Oct 17, 2026 at 1:09=E2=80=AFPM Siddharth Chintamaneni
> <sidchintamaneni@gmail.com> wrote:
> >
> > When CONFIG_MEMCG=3Dy, lruvec_pgdat() returns lruvec->pgdat, which for =
the
> > per-node pgdat->__lruvec is left NULL by lruvec_init() and only filled =
in
> > lazily by mem_cgroup_lruvec(). Normally that happens early, e.g. on the
> > first folio_add_lru().
> >
> > With cgroup_disable=3Dmemory, lru_gen_shrink_node() passes &pgdat->__lr=
uvec
> > directly to shrink_one(). If direct reclaim runs before anything has
> > called mem_cgroup_lruvec() for the node, which can happen during early
> > boot under memory pressure (e.g. a kdump kernel), get_swappiness() ends
> > up dereferencing a NULL pgdat:
> >
> >   Unable to handle kernel NULL pointer dereference at virtual address 0=
000000000005040
> >   pc : get_swappiness+0x68/0xb0
> >   lr : try_to_shrink_lruvec+0x54/0x2c0
> >   Call trace:
> >    get_swappiness+0x68/0xb0 (P)
> >    try_to_shrink_lruvec+0x54/0x2c0
> >    shrink_one+0x8c/0x240
> >    shrink_node+0xc6c/0xe08
> >    do_try_to_free_pages+0xdc/0x570
> >    try_to_free_pages+0x124/0x278
> >    __alloc_frozen_pages_noprof+0x6e8/0xf78
> >    alloc_pages_mpol+0xc4/0x1c0
> >    alloc_frozen_pages_noprof+0x54/0xe8
> >    alloc_pages_noprof+0x1c/0x40
> >    atomic_pool_expand+0x98/0x300
> >    __dma_atomic_pool_init+0x58/0xd8
> >    dma_atomic_pool_init+0x154/0x170
> >    do_one_initcall+0x64/0x350
> >    kernel_init_freeable+0x214/0x430
> >    kernel_init+0x2c/0x208
> >    ret_from_fork+0x10/0x20
> >
> > The classic LRU path and MGLRU before per-node lru_gen_folio lists
> > obtained the lruvec through mem_cgroup_lruvec(), which sets
> > lruvec->pgdat.
> >
> > The above was hit on an arm64 kdump kernel (6.18-based) booted with
> > cgroup_disable=3Dmemory nr_cpus=3D4. It also reproduces on mainline on =
an
> > arm64 VM with CONFIG_ARM64_64K_PAGES=3Dy, CONFIG_MEMCG=3Dy,
> > CONFIG_LRU_GEN_ENABLED=3Dy and:
> >
> >   mem=3D160M nr_cpus=3D4 coherent_pool=3D512M cgroup_disable=3Dmemory
> >
> > These options only serve to force direct reclaim early in boot; with
> > 160M the boot eventually ends in OOM regardless. On mainline the first
> > LRU reclaim happens while unpacking the initramfs, and faults the same
> > way:
> >
> >   Unable to handle kernel NULL pointer dereference at virtual address 0=
000000000005040
> >   pc : get_swappiness+0xd4/0x150
> >   Call trace:
> >    get_swappiness+0xd4/0x150 (P)
> >    try_to_shrink_lruvec+0x44/0x2b8
> >    shrink_one+0x80/0x1a0
> >    shrink_node+0xd98/0xea8
> >    do_try_to_free_pages+0xf4/0x4b0
> >    try_to_free_pages+0x110/0x360
> >    __alloc_frozen_pages_noprof+0x8b0/0x1718
> >    ...
> >    __filemap_get_folio_mpol+0x2ac/0x548
> >    simple_write_begin+0x44/0xf8
> >    page_symlink+0x178/0x198
> >    ...
> >    do_populate_rootfs+0x13c/0x200
> >
>
> So this happens before any folios are added to the LRU and before
> the userspace init process starts?
>

Yes!

> > Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> > Cc: stable@vger.kernel.org # 6.3+
> > Assisted-by: LLM
> > Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
> > Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
> > ---
> >  mm/vmscan.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index f11491ee9ed5..0c57e4f1eb15 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -5253,7 +5253,7 @@ static void lru_gen_shrink_node(struct pglist_dat=
a *pgdat, struct scan_control *
> >                 sc->nr_reclaimed =3D 0;
> >
> >         if (mem_cgroup_disabled())
> > -               shrink_one(&pgdat->__lruvec, sc);
> > +               shrink_one(mem_cgroup_lruvec(NULL, pgdat), sc);
>
> What's a bit weird is that even if we fix this here, with an empty
> lruvec, we still won't be able to reclaim a single page. But it's
> hard to see where we could break out early, right?
>

I am not really sure about simple bailout logic. Please let me know if
anyone have any thoughts.

> >         else
> >                 shrink_many(pgdat, sc);
>
> Best Regards
> Barry

