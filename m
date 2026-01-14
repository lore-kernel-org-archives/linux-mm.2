Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07007D29FF7
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 424A56B00B0; Wed, 14 Jan 2026 07:17:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3236B00B2; Wed, 14 Jan 2026 07:17:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5566B00B4; Wed, 14 Jan 2026 07:17:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17BD96B00B0
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:17:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9BF831A0489
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:17:24 +0000 (UTC)
X-FDA: 84330469608.12.8590AD0
Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9F94B20002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:17:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="KlGVeJ/m";
	spf=pass (imf13.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768393043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38Vfj0jf5OEFbTnSianKjy7lCeGnbxOyBRt1UQTdjUY=;
	b=gXwZXw7wo6EOZsi26AeeuO8fqrh+KHbROkAKTzcpDyd27dKxbF93E6+KqLOM5dGLktU2OL
	K6OT1w+GBTMOw6d7xbwLYh/PlBcya+IUnhVD9yGq9IPT1DoEqDkzwVtgBx1fXfZA1l36ik
	reGc1hJGpQtLiOmHe+biAxnMDH+qBhA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768393043; a=rsa-sha256;
	cv=none;
	b=N5iOWf76mTvFd3BYAhYXm7v7XSoVdDLW1gduyDHv9N1bvaCdrHuXL3sscOn3h+OK/4rtQZ
	yOOeV1/Ox4z5VgsnwNSJm6UXWRoA205lT89d4UarW5Y5T2c8zVPl9ANgrSGkpcamcmqCwj
	EDvH0URNCqDmoDd0EvuybICq/iZh9jA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="KlGVeJ/m";
	spf=pass (imf13.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768393040; x=1768652240;
	bh=38Vfj0jf5OEFbTnSianKjy7lCeGnbxOyBRt1UQTdjUY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=KlGVeJ/mpzbSvLJukRjrqyUIhoOMgUz1f5jmbnEcVI+ECOgljv1sbTT0TAs8DxhiA
	 F0VRTDX1oLIPWgwzmiktz66MmqSxjXW1mn1zExnvPKvnldrzJn+thG60F4pAbh1Lng
	 GM5tAOwYAN5jde/hZpLU+SIT5+ejVg3ZZq29yWK4TAD7td10yAg0xofF1nNOQIDlZt
	 2yDhqa7+FwbEH6mDgH9aKjCK7xg7Dvv6BtL27F2Pa2EO4ZJFUGxDyiT9J5NVDlKIC2
	 r2vdzfG9KSqDtPxyqPRVlM2Hpc1SZY4yBCZAIFUGbsH77zEvkkydQyL2HC7YMjKczq
	 R6d4dxXQWSvVQ==
Date: Wed, 14 Jan 2026 12:17:13 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrew Morton <akpm@linux-foundation.org>, =?utf-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, joonki.min@samsung-slsi.corp-partner.google.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/kasan: Fix KASAN poisoning in vrealloc()
Message-ID: <aWd2wquw1aEB2rON@wieczorr-mobl1.localdomain>
In-Reply-To: <20260113191516.31015-1-ryabinin.a.a@gmail.com>
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com> <20260113191516.31015-1-ryabinin.a.a@gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: bf1405530f43e5d2b345f5d47b7d43e403f0b146
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F94B20002
X-Rspam-User: 
X-Stat-Signature: ksruar3u1tkr6xp36qnybs9drjwudrt1
X-HE-Tag: 1768393042-916993
X-HE-Meta: U2FsdGVkX1+4P10Bhqu+bZgGmdLaSJB4OkBRtfgN6u+qVEH6Fx3VZcyZXJSYT1X1ieqI18W4h9lF+55lXKQvwv/daUyiT8TzVRRWrLFaTc4ZoAVxMmtEk2W2z9zs+EikKraIS/LY7eAGoQG8BGQidswLMr2pVz4QuI0gfu1JO4qNJ3eXsBYkfCQOrh4qIJLKGbyHRh20gLWP0zmVt+aSVcwvBT+vg/qn3pc6KTuF6deb9Px7WEEx5mRNEeTrYbak4VgdfeWPhfvqJ2NOmYDGm/7nK55y/3BQJ8cyDo8z/9VIJr2QKOxi19Wn0rsU4aAe/wklDETYNKsVCABxp1BUxvxmrR2I7Gh++jAyeSsP6Xp+Jd8eiMMajBK3Lni5pvdtPlM9xKDzzVBcmEMrkAUqHoSS9qMx2nEq7QnVqDpGy2OY7OOiO76oigdkfzZ+5PVwKO1wiz0pH7WMX4iarXkmmGmeAeHBmv3hTEiB7ZGDOclzzqAGOXqpVudh9WBf1ww4f2F2y6XTlAKoeW2xxOPEfe73AhoeO/fcKziAI+nsx7caBS3o2/vf9FSJSM7Tcgtm0CBG4Plg7IgOm1NjtAW+pOXAOSVDC0sUR+rKGJKchOPomefl7fzOeV8qbMZMCeCFwymMWqy1nq9xM2Lif57K8qf8CXFbtwQKc5BBJ+yTdIg4AvB5EeoZDktHC4JXXmUsg3Se4/d8wIji7IqIxgV+eZKdRJVh5NtqL+atFaOoqr5/3T5Agp0FgJ/QlEhm8lymSQVUEcgs1w8GkxkeGm/qLoYrwvg3wSFTZSYL3V/ap55pwXStR0A1ZlhexxDdLcLxXCwFHYMFgAWNq1J1xm7egv6QzyW9oV4+fCBsnwKmkveIQLcySFwM5KxkgTKg+ua7S5z59ovN4Kv3KEUPogkLiH+Ua2XM6i1ccvKkaR1EVJeldfJsS3aXYCkh3frnTIiyXqiTxp3T3zsDUzomV/n
 XIv93sYe
 UnOL3g99j+LJOi+FXooK6RoVZ7YaYWAKAn5VR1pbZr1ZxPfvhSz55cjzD7PR8N34s/lP95Px+ovC/+n2qhif6QaKK/5e8gs2O4nmrA0lNzxnbTsDE1aWJYRi9bE8+BGuMJZrKuDeq+hx4OjboGktt8eooOnTFJbYY62tdH3gefphfZAp7Cvn6aHNO4Qr5mVQw+Fnc+4fv9ZXjfDJInXgnsMPUEVN4a8G7LXSF7lC+UdLjGstKUX5c5XB+cUfP0HDlRsIFpt2leKpd8zS2aHyHZ9ZGmaR9JX5tBFgNpyIi8YfCFD8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tested in generic and sw_tags modes. Compiles and runs okay with and withou=
t my
KASAN sw tags patches on x86. Kunit tests also seem fine.

Tested-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

On 2026-01-13 at 20:15:15 +0100, Andrey Ryabinin wrote:
>A KASAN warning can be triggered when vrealloc() changes the requested
>size to a value that is not aligned to KASAN_GRANULE_SIZE.
>
>    ------------[ cut here ]------------
>    WARNING: CPU: 2 PID: 1 at mm/kasan/shadow.c:174 kasan_unpoison+0x40/0x=
48
>    ...
>    pc : kasan_unpoison+0x40/0x48
>    lr : __kasan_unpoison_vmalloc+0x40/0x68
>    Call trace:
>     kasan_unpoison+0x40/0x48 (P)
>     vrealloc_node_align_noprof+0x200/0x320
>     bpf_patch_insn_data+0x90/0x2f0
>     convert_ctx_accesses+0x8c0/0x1158
>     bpf_check+0x1488/0x1900
>     bpf_prog_load+0xd20/0x1258
>     __sys_bpf+0x96c/0xdf0
>     __arm64_sys_bpf+0x50/0xa0
>     invoke_syscall+0x90/0x160
>
>Introduce a dedicated kasan_vrealloc() helper that centralizes
>KASAN handling for vmalloc reallocations. The helper accounts for KASAN
>granule alignment when growing or shrinking an allocation and ensures
>that partial granules are handled correctly.
>
>Use this helper from vrealloc_node_align_noprof() to fix poisoning
>logic.
>
>Reported-by: Maciej =C5=BBenczykowski <maze@google.com>
>Reported-by: <joonki.min@samsung-slsi.corp-partner.google.com>
>Closes: https://lkml.kernel.org/r/CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm0=
8oLO3odYFrA@mail.gmail.com
>Fixes: d699440f58ce ("mm: fix vrealloc()'s KASAN poisoning logic")
>Cc: stable@vger.kernel.org
>Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
>---
> include/linux/kasan.h |  6 ++++++
> mm/kasan/shadow.c     | 24 ++++++++++++++++++++++++
> mm/vmalloc.c          |  7 ++-----
> 3 files changed, 32 insertions(+), 5 deletions(-)
>
>diff --git a/include/linux/kasan.h b/include/linux/kasan.h
>index 9c6ac4b62eb9..ff27712dd3c8 100644
>--- a/include/linux/kasan.h
>+++ b/include/linux/kasan.h
>@@ -641,6 +641,9 @@ kasan_unpoison_vmap_areas(struct vm_struct **vms, int =
nr_vms,
> =09=09__kasan_unpoison_vmap_areas(vms, nr_vms, flags);
> }
>=20
>+void kasan_vrealloc(const void *start, unsigned long old_size,
>+=09=09unsigned long new_size);
>+
> #else /* CONFIG_KASAN_VMALLOC */
>=20
> static inline void kasan_populate_early_vm_area_shadow(void *start,
>@@ -670,6 +673,9 @@ kasan_unpoison_vmap_areas(struct vm_struct **vms, int =
nr_vms,
> =09=09=09  kasan_vmalloc_flags_t flags)
> { }
>=20
>+static inline void kasan_vrealloc(const void *start, unsigned long old_si=
ze,
>+=09=09=09=09unsigned long new_size) { }
>+
> #endif /* CONFIG_KASAN_VMALLOC */
>=20
> #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
>diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
>index 32fbdf759ea2..e9b6b2d8e651 100644
>--- a/mm/kasan/shadow.c
>+++ b/mm/kasan/shadow.c
>@@ -651,6 +651,30 @@ void __kasan_poison_vmalloc(const void *start, unsign=
ed long size)
> =09kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
> }
>=20
>+void kasan_vrealloc(const void *addr, unsigned long old_size,
>+=09=09unsigned long new_size)
>+{
>+=09if (!kasan_enabled())
>+=09=09return;
>+
>+=09if (new_size < old_size) {
>+=09=09kasan_poison_last_granule(addr, new_size);
>+
>+=09=09new_size =3D round_up(new_size, KASAN_GRANULE_SIZE);
>+=09=09old_size =3D round_up(old_size, KASAN_GRANULE_SIZE);
>+=09=09if (new_size < old_size)
>+=09=09=09__kasan_poison_vmalloc(addr + new_size,
>+=09=09=09=09=09old_size - new_size);
>+=09} else if (new_size > old_size) {
>+=09=09old_size =3D round_down(old_size, KASAN_GRANULE_SIZE);
>+=09=09__kasan_unpoison_vmalloc(addr + old_size,
>+=09=09=09=09=09new_size - old_size,
>+=09=09=09=09=09KASAN_VMALLOC_PROT_NORMAL |
>+=09=09=09=09=09KASAN_VMALLOC_VM_ALLOC |
>+=09=09=09=09=09KASAN_VMALLOC_KEEP_TAG);
>+=09}
>+}
>+
> #else /* CONFIG_KASAN_VMALLOC */
>=20
> int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
>diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>index 41dd01e8430c..2536d34df058 100644
>--- a/mm/vmalloc.c
>+++ b/mm/vmalloc.c
>@@ -4322,7 +4322,7 @@ void *vrealloc_node_align_noprof(const void *p, size=
_t size, unsigned long align
> =09=09if (want_init_on_free() || want_init_on_alloc(flags))
> =09=09=09memset((void *)p + size, 0, old_size - size);
> =09=09vm->requested_size =3D size;
>-=09=09kasan_poison_vmalloc(p + size, old_size - size);
>+=09=09kasan_vrealloc(p, old_size, size);
> =09=09return (void *)p;
> =09}
>=20
>@@ -4330,16 +4330,13 @@ void *vrealloc_node_align_noprof(const void *p, si=
ze_t size, unsigned long align
> =09 * We already have the bytes available in the allocation; use them.
> =09 */
> =09if (size <=3D alloced_size) {
>-=09=09kasan_unpoison_vmalloc(p + old_size, size - old_size,
>-=09=09=09=09       KASAN_VMALLOC_PROT_NORMAL |
>-=09=09=09=09       KASAN_VMALLOC_VM_ALLOC |
>-=09=09=09=09       KASAN_VMALLOC_KEEP_TAG);
> =09=09/*
> =09=09 * No need to zero memory here, as unused memory will have
> =09=09 * already been zeroed at initial allocation time or during
> =09=09 * realloc shrink time.
> =09=09 */
> =09=09vm->requested_size =3D size;
>+=09=09kasan_vrealloc(p, old_size, size);
> =09=09return (void *)p;
> =09}
>=20
>--=20
>2.52.0
>

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


