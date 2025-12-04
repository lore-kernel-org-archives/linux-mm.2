Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C6E2D2168B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BDFD6B00BB; Thu,  4 Dec 2025 10:06:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66ECC6B00BC; Thu,  4 Dec 2025 10:06:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536876B00BD; Thu,  4 Dec 2025 10:06:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FBF06B00BB
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:06:46 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12039B70ED
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:06:46 +0000 (UTC)
X-FDA: 84182115612.01.AC2AB58
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1059A40018
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:06:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WGvBee0r;
	spf=pass (imf01.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764860804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5I1HHFjP+dmS+OWCaDviDx1a/C2VrJBVgYWkPX6+djw=;
	b=Fhcqg58gzWPFvLzU7rh9yr+uy9tNdrQJh709+LpWJQBCUsRemLSJsVVBGizmHLv1InvS7M
	o/BvaQc1sGvnJYVKmbqEanfwLid5HSURnkKGFOkFqt25J81KODI3l5MDlQi816QjaaJ/y8
	Mve9AaHLSwWMFYs0+/0XD/4IE8Smri0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764860804; a=rsa-sha256;
	cv=none;
	b=68PO6XlvDOjEmzNViaqoy3xn2ysR4wU4JFu0AoCDCmRdzF65N0Y7c83rbtjLntA+Nk+K1Z
	N/fl8GRprbtcjjUxHsnU8fWoRC3fSl6uodBPs1dLbpnckaVEvJQQkx+TF/ptOCn5apJFti
	yKUkYA+4PZ7h/b4lKrt1vazwI2k++Pw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WGvBee0r;
	spf=pass (imf01.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47775fb6c56so9615835e9.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764860803; x=1765465603; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5I1HHFjP+dmS+OWCaDviDx1a/C2VrJBVgYWkPX6+djw=;
        b=WGvBee0r8Zh8jddlEFHmdMI+/2XVjVGgBIHibe64uwoFtkdyg3RYAF4S/83WDUGHXP
         rYctR34qdcYcuKskzOnPZje1zdKNy+ZV13dwXU7ik5IRVTaE7EMNuBgrKSy9sd2DaxSf
         LVSM+P4/gEY/CaHHTynN7gAnrvuO8xxqMKDRoWXa1i9gp0gcA/X8XLx/fqbIaB+fj0Kq
         mLYQ7mMtnm67NWIQNuZ7Gl6vZUwp99qOVwAA4axcoTp1CwyGyywLqHFhVbRMDoLjysxU
         vlsDzKEI+6fxCu38qjZTYfpDe1Dcsm0ovYxR+RQT38j2YmceOZU+CPEaMh9jvbkHrHSQ
         EAvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764860803; x=1765465603;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5I1HHFjP+dmS+OWCaDviDx1a/C2VrJBVgYWkPX6+djw=;
        b=gidgz4b3655MB9MLkMXW5ltxuGCSAY5RY5dw49XfjIq5dHZX0CGshQOdFxDdQvNOr9
         t7k/WNMPFCHudsKeIprerZdC8q05uTj6wJcREFgsVvYCMoiK9CJ8th1wPSRApxJBh4tA
         whX2x5/aPJ7YXqMoEX3P06cmqgjOJgUgV1vCw6rHF4MM1IlZoFKmj1K1nIgkPB7s9UMX
         NNG2yTbeq1R4DhNFuSJpW+PO4SxDFy4SvDHQF0ATDC09qqyg1fkWN28yILrBRZuU/HW8
         elFkp1gPxnkaYJ/X3kHOarw4oC3ucOcoCodw4+Y1qatzoLxDFGp+jXA7HBgASNlsY9rd
         8ofQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUiz+nn2Dx6FeY64qYEZdBuH2kGNfBqptWVXCXQrUGkVpwCSGM+avzSOx9u1pMwSS6fGMoMyJjiQ==@kvack.org
X-Gm-Message-State: AOJu0YzJ1HXfB6p+0oBJ5DohGc+zbEfIZ4JwpeHe1YJuu29fy6RiEiUm
	Nvx5jCb5fNjpUysGGB3FJTh2rSjBExwjWwYNEPEaeV5DPnqQtfWeN4qz4Vzbzuu0CJhC/fCQF8z
	OFJLDLU3XDJWlSCdFu8HxP9piSD/0wmE=
X-Gm-Gg: ASbGnctQYA7h/POKZqRztBOO4pNNjAkT6nzaHOsp9pwro0fqKr5Y1qFJZ08a19SKGc7
	E8ShD6OI/vMJx5r4qW7vkNA6qKtaQadWhGA/Qmv1N68iafpk4qOsy7m4wtAWiyFPqlcJ23N18fx
	UKc0nFBK0R4sIV9Jcr0EW0xDK064TfTPziihQ2lcuFiauhBPPdfPg+lK9Kaisbqjik3cuiAccnE
	wuGXVzjTi8Cox+onE+L96Vr1/NPzKLCnhq5rWemRrKY/lpzvfy2mH5nPniIc79mnbMzXxn+H+X3
	ZVLug6Vz1BLOBqq1dbzrhowa/CDR
X-Google-Smtp-Source: AGHT+IHB3xS1opCSVE28Vu6Rp6w4LgnWtYOXJ31CIXncRJJoX9JZEBqfpHUfImIeEKnlEG/lQB3cdv7LMvANeYh+KZ4=
X-Received: by 2002:a05:6000:4014:b0:42b:39d0:6377 with SMTP id
 ffacd0b85a97d-42f797fdf66mr2936033f8f.17.1764860802318; Thu, 04 Dec 2025
 07:06:42 -0800 (PST)
MIME-Version: 1.0
References: <5o7owlr4ap5fridqlkerrnuvwwlgldr35gvkcf6df4fufatrr6@yn5rmfn54i62> <ef40d7bb8d28a5cde0547945a0a44e05b56d0e76@linux.dev>
In-Reply-To: <ef40d7bb8d28a5cde0547945a0a44e05b56d0e76@linux.dev>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 4 Dec 2025 16:06:31 +0100
X-Gm-Features: AWmQ_bnaUQ25kTdEWv00pQqNAPpKBXdTjclujxDMcVwZh7_yFWZPsNiD0hppyoY
Message-ID: <CA+fCnZfn+bu15DPwawApE3DXrEz_wkYzHdjbjbTD0n5KLEQfsQ@mail.gmail.com>
Subject: Re: [PATCH v1] mm/kasan: Fix incorrect unpoisoning in vrealloc for KASAN
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-mm@kvack.org, 
	syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Danilo Krummrich <dakr@kernel.org>, Kees Cook <kees@kernel.org>, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1059A40018
X-Stat-Signature: 4wr4ez9bsgyhy9icbi8b65bwh9mi9rcr
X-HE-Tag: 1764860803-258608
X-HE-Meta: U2FsdGVkX1/7Jju3NO6NNXPmHAIZXI6mPhmoZh9GyTujHSDPXSYdtgryfetNi255pfEewRyxIg5Kes2n25Mz0Wn7KyYp/ZMtzfal8H77hp3GbWaWdjKW3NVm8moiY1DlelbV78kKAWtgztEcATUaoHIISVfdN2OhNSa8Mmzjg14As5K3JSJhpDX8hs6dRnL5o3VEaSy6ot9XtEIxA3S4HG6PPzqXSPZDz94AyL/qLBjfH17x5J+Et+CEcEMAzwQFbDSkF/fL/7o2uvxqUZP7eQg22b8v/afQYyTDV3CL9XBvCPx8POZpZK0B72BhIAoj8cfE/AibafhuxH8/YuuF+7x4s4B9Mvxb5g4XIO2ddTtc20mTuKsTwt+2JLmC2mrxZjR3iOdBgkh+tLm5VVUORTlPafQ8TckWpBCP8bMpQGO1CXM6jcGYh7PjZvtTD65JGTCU1G7YDrdLFeMSmV2uAptfa1qKbx96FAhQ2Ab3eVE2JdjvYlMRkMpLMOOPHWBislFxuiFR5jBHV9mtiUvrqlS8KWo+dCIWk9w3T7Q+//0CNjmkXvQVCeIqORq0h+3ujc5FnFryirfnEC8+/cgEVCr5SqyKe2+59/OL1Qw+sB9AL+RgZJlnCOLi6+3wqoMKRCZTxnuK/kI26xiNZq1rC0W/Mx91xqJGL7f1QgnWROqio0qpWJzBYH1WDimtrRQCydJLgq7MUHgHrphEgNqgjL07fVuRSfsyyG1ck9ZukWSwFHC1XOmUevBUPlhob5aAJn5+58RwWlsjb831NokNk5sy1funHY9WEkUMgCwKMq45iC8oS30nnqO7Pje052wVULsWrnT4khpbQe940cww45ggJP4XIxVUTAM8g3KpvacgJOZbrr/LvBqZSNept9H1h+x+1vSpGkPCGHMJBT6rdv3XnBHnn/Hb62OOirxdDdfdYwCQRZddA/nySgMj+wWw+NlwHYul53Y0LHyze+j
 f5mv2am/
 GNadzsDq42jFGfxvA0fffjoH44XOYkqCWGZIMCFbRTbmusDKlazPhNVuv4Mw72kOqEyfXzgjn5NDo3Ns2qDxi6U0jq/NTN+LAT78ASGsqMm5td1n5ONp8aaQ5tZF+3PJlPMARUF+LURBezXklWHOm61+cGJGM8nBOPeB+zI7ngEPqH51M/ARjNCSabiS40VMvZ5Wov1tnHiHxRtSd3K/6it+i0bbBLaaqsdWEoyBzHK+wJ2RtJ4k1F2PHU6zBixvEQsRoydTlG9NReN2MaDkifkaRrXGRWhC+9+BXOgI+DwpLAs7MggZ5UrkVKowsKlrORDlohiu7VBhNCV96hnF376MNmzgyhdW0hiD/MwdAv8T3SZ0GyWs+salWnZBdI+vHYxtxBqfG1YpsW+E/l7ACreJnCEnhCmHaQoATvx4qYV2SkFCkugKdo90PAaHhld+iG/zFc7ZFay2LUB72yeiS83ijBdogaiYI9RbTDPl4Qs29k7fOyrKrvtCeRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 3:38=E2=80=AFPM Jiayuan Chen <jiayuan.chen@linux.dev=
> wrote:
>
> I think I don't need KEEP_TAG flag anymore, following patch works well an=
d all kasan tests run successfully
> with CONFIG_KASAN_SW_TAGS/CONFIG_KASAN_HW_TAGS/CONFIG_KASAN_GENERIC

Thanks for working on improving the vrealloc annotations!

But I think we need to first fix the vrealloc issue you discovered in
a separate patch (so that it can be backported), and then we can apply
your other vrealloc changes on top later.

So please implement a version of your fix with KEEP_TAG -- this would
also allow Maciej to build on top.

>
>
> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index 1c373cc4b3fa..8b819a9b2a27 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -394,6 +394,11 @@ void __kasan_poison_vmalloc(const void *start, unsig=
ned long size)
>          * The physical pages backing the vmalloc() allocation are poison=
ed
>          * through the usual page_alloc paths.
>          */
> +       if (!is_vmalloc_or_module_addr(start))
> +               return;
> +
> +       size =3D round_up(size, KASAN_GRANULE_SIZE);
> +       kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);

This does not look good - we will end up poisoning the same memory
twice, once here and once it's freed to page_alloc.

Is this change required?

>  }
>
>  #endif
> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index 2cafca31b092..a5f683c3abde 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c
> @@ -1840,6 +1840,84 @@ static void vmalloc_helpers_tags(struct kunit *tes=
t)
>         vfree(ptr);
>  }
>
> +
> +static void vrealloc_helpers(struct kunit *test, bool tags)
> +{
> +       char *ptr;
> +       size_t size =3D PAGE_SIZE / 2 - KASAN_GRANULE_SIZE - 5;
> +
> +       if (!kasan_vmalloc_enabled())
> +               kunit_skip(test, "Test requires kasan.vmalloc=3Don");
> +
> +       ptr =3D (char *)vmalloc(size);
> +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> +
> +       OPTIMIZER_HIDE_VAR(ptr);
> +
> +       size +=3D PAGE_SIZE / 2;
> +       ptr =3D vrealloc(ptr, size, GFP_KERNEL);
> +       /* Check that the returned pointer is tagged. */
> +       if (tags) {
> +               KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN=
);
> +               KUNIT_EXPECT_LT(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KER=
NEL);
> +       }
> +       /* Make sure in-bounds accesses are valid. */
> +       ptr[0] =3D 0;
> +       ptr[size - 1] =3D 0;
> +
> +       /* Make sure exported vmalloc helpers handle tagged pointers. */
> +       KUNIT_ASSERT_TRUE(test, is_vmalloc_addr(ptr));
> +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, vmalloc_to_page(ptr));
> +
> +       size -=3D PAGE_SIZE / 2;
> +       ptr =3D vrealloc(ptr, size, GFP_KERNEL);
> +
> +       /* Check that the returned pointer is tagged. */
> +       KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN);
> +       KUNIT_EXPECT_LT(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
> +
> +       /* Make sure exported vmalloc helpers handle tagged pointers. */
> +       KUNIT_ASSERT_TRUE(test, is_vmalloc_addr(ptr));
> +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, vmalloc_to_page(ptr));
> +
> +
> +       /* This access must cause a KASAN report. */
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[size + =
5]);
> +
> +
> +#if !IS_MODULE(CONFIG_KASAN_KUNIT_TEST)
> +       {
> +               int rv;
> +
> +               /* Make sure vrealloc'ed memory permissions can be change=
d. */
> +               rv =3D set_memory_ro((unsigned long)ptr, 1);
> +               KUNIT_ASSERT_GE(test, rv, 0);
> +               rv =3D set_memory_rw((unsigned long)ptr, 1);
> +               KUNIT_ASSERT_GE(test, rv, 0);
> +       }
> +#endif
> +
> +       vfree(ptr);
> +}
> +
> +static void vrealloc_helpers_tags(struct kunit *test)
> +{
> +       /* This test is intended for tag-based modes. */
> +       KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_GENERIC);
> +
> +       KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
> +       vrealloc_helpers(test, true);
> +}
> +
> +static void vrealloc_helpers_generic(struct kunit *test)
> +{
> +       /* This test is intended for tag-based modes. */
> +       KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
> +
> +       KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
> +       vrealloc_helpers(test, false);
> +}
> +
>  static void vmalloc_oob(struct kunit *test)
>  {
>         char *v_ptr, *p_ptr;
> @@ -2241,6 +2319,8 @@ static struct kunit_case kasan_kunit_test_cases[] =
=3D {
>         KUNIT_CASE_SLOW(kasan_atomics),
>         KUNIT_CASE(vmalloc_helpers_tags),
>         KUNIT_CASE(vmalloc_oob),
> +       KUNIT_CASE(vrealloc_helpers_tags),
> +       KUNIT_CASE(vrealloc_helpers_generic),
>         KUNIT_CASE(vmap_tags),
>         KUNIT_CASE(vm_map_ram_tags),
>         KUNIT_CASE(match_all_not_assigned),
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 798b2ed21e46..9ba2e8a346d6 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4128,6 +4128,7 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
>  void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned lo=
ng align,
>                                  gfp_t flags, int nid)
>  {
> +       asan_vmalloc_flags_t flags;
>         struct vm_struct *vm =3D NULL;
>         size_t alloced_size =3D 0;
>         size_t old_size =3D 0;
> @@ -4158,25 +4159,26 @@ void *vrealloc_node_align_noprof(const void *p, s=
ize_t size, unsigned long align
>                         goto need_realloc;
>         }
>
> +       flags =3D KASAN_VMALLOC_PROT_NORMAL | KASAN_VMALLOC_VM_ALLOC;
>         /*
>          * TODO: Shrink the vm_area, i.e. unmap and free unused pages. Wh=
at
>          * would be a good heuristic for when to shrink the vm_area?
>          */
> -       if (size <=3D old_size) {
> +       if (p && size <=3D old_size) {
>                 /* Zero out "freed" memory, potentially for future reallo=
c. */
>                 if (want_init_on_free() || want_init_on_alloc(flags))
>                         memset((void *)p + size, 0, old_size - size);
>                 vm->requested_size =3D size;
> -               kasan_poison_vmalloc(p + size, old_size - size);
> +               kasan_poison_vmalloc(p, alloced_size);
> +               p =3D kasan_unpoison_vmalloc(p, size, flags);
>                 return (void *)p;
>         }
>
>         /*
>          * We already have the bytes available in the allocation; use the=
m.
>          */
> -       if (size <=3D alloced_size) {
> -               kasan_unpoison_vmalloc(p + old_size, size - old_size,
> -                                      KASAN_VMALLOC_PROT_NORMAL);
> +       if (p && size <=3D alloced_size) {
> +               p =3D kasan_unpoison_vmalloc(p, size, flags);
>                 /*
>                  * No need to zero memory here, as unused memory will hav=
e
>                  * already been zeroed at initial allocation time or duri=
ng

