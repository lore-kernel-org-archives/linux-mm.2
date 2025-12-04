Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11271D2168E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9D66B00B6; Thu,  4 Dec 2025 10:35:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1756B00B7; Thu,  4 Dec 2025 10:35:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EEA96B00CF; Thu,  4 Dec 2025 10:35:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1D76B00B6
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:35:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F10DF13A024
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:35:35 +0000 (UTC)
X-FDA: 84182188230.18.122D2C8
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id F1CB240003
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:35:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bG4Wr0P6;
	spf=pass (imf04.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764862534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSWBjoUbSEGuP/Fanmcv3C5LwDckSbaugls2GY15bOc=;
	b=a56Vo9E39BuV1c5uZkdiHtYSJ8GUkyF/r7FABFQUkA/VMNAvHguGQuG8QIs/xZJyso0ADF
	ZMLfPP9+fZACTH1/+Iu57LfHgxCkHjzGF8s7UZHEwWbE/0fNJvXL48mb/RwJ4kLe5m2QOM
	yVcKnAOPR6BgVqeOBeWQZpMXbOCjKLk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764862534; a=rsa-sha256;
	cv=none;
	b=P2ycDjDQO56j14U5pmm8b8osGygiCUUNp8bn8RV0dxIHOFbwW85D8wg8zRWL150N4tTt8m
	3YsUjDmGpSt+L93e2YtWa/gWLXOF6lXJggtV2CF4nJTnvIFNaL2kxHnqR0yOUjPU39M42H
	TT7xdNFzo6z/xXGIMc4Z8A047S6BFUI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bG4Wr0P6;
	spf=pass (imf04.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764862530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cSWBjoUbSEGuP/Fanmcv3C5LwDckSbaugls2GY15bOc=;
	b=bG4Wr0P67KtfulsfKzMry8tAb3VX9KIxE4P5MGAIP5w/WvaSB3Fj6/iEdv7wZ9Z2+RVUhz
	wm6ZEgXrB8evf8flgtEYNc1/6lV7Qa7gKbwHpF09C6OjKmaE/FvTiOMkRWqdZF2SdPsk4j
	tH/L73A0Hsl3lE5/iUcH5pjsy7ELGcc=
Date: Thu, 04 Dec 2025 15:35:23 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <5dce1baa4672646c54beaa94355e32fab856fa2b@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm/kasan: Fix incorrect unpoisoning in vrealloc for
 KASAN
To: "Andrey Konovalov" <andreyknvl@gmail.com>
Cc: "Maciej Wieczor-Retman" <m.wieczorretman@pm.me>, "Maciej Wieczor-Retman"
 <maciej.wieczor-retman@intel.com>, linux-mm@kvack.org,
 syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, "Andrey Ryabinin"
 <ryabinin.a.a@gmail.com>, "Alexander Potapenko" <glider@google.com>,
 "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo Frascino"
 <vincenzo.frascino@arm.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Uladzislau Rezki" <urezki@gmail.com>, "Danilo Krummrich"
 <dakr@kernel.org>, "Kees Cook" <kees@kernel.org>,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org
In-Reply-To: <CA+fCnZfn+bu15DPwawApE3DXrEz_wkYzHdjbjbTD0n5KLEQfsQ@mail.gmail.com>
References: <5o7owlr4ap5fridqlkerrnuvwwlgldr35gvkcf6df4fufatrr6@yn5rmfn54i62>
 <ef40d7bb8d28a5cde0547945a0a44e05b56d0e76@linux.dev>
 <CA+fCnZfn+bu15DPwawApE3DXrEz_wkYzHdjbjbTD0n5KLEQfsQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F1CB240003
X-Stat-Signature: mkrrw8crct8h9wcy1gxpqx57jf9txur3
X-Rspam-User: 
X-HE-Tag: 1764862533-750374
X-HE-Meta: U2FsdGVkX1+DVfTsbBqQSwsXsYB4Vr5lePuRUldCQMjciNsd7doBFfEP6AYDjEw5OkWxiuEyyNd319NXsmFKZOxJJbtZmMqgvHzPihES4drDnQUmIkGvvcO43ICew0GG8sbndo0MLzkNfjKqVQ/p6ItkJtQJWJ/x1QfJHS1Ofc3vp/MJ5LuxIiWX4vXoSkSI8KcfSqC+dbq5UhiugLcAaFS4LO4OxRPxAwqw79MZ0OQ9laBz9tevge0plU3KAUBgoMlnRcdZCMHhtlF4nGv9OLqtRFE1a5DQTrEPXuhtp36SQx4/diGpzjQUcSF5LG1RGRqxtCeETdga13kroKGzPTf+EgzBNvvk0HhpKEzrx8tcgOIg26FmjnZhIczPmLW+AWwGs8Jb/eTu6j9+zslMa5SoIAA8d3hMWhOA63WqAsi9z7Z2mxk+k9IKzxu0BUh74Iwl8mAVHs7Okc5io60chUQ3XXdGvZ3/8q2kvKPObolfp0lHihEgAE+Vv5PRyqnA5KdzzeJDv4WrR4NqK8HPKsJDc3goo0WX5BWB3F8Fd20be8b5LGuLjEB3OkKAOJE9AU1KTehoMbvZfba7AJbLMSCQnAeo8ea0MjRy2a5BKC3tTuTdzOyYBcdeGeMCfnuVxsNcMltH9Y7G3cQBdrPefWBOCp2serRerwRuV98kqUGG8ie73WiZAuzxSmXwXzdzSTyEM6z4IxY2MG+0nyjvL43fl23zFYZaf7phWphFkXv5HeTb4gcQ7U9fyXisq88V5e2gJMakvQDKu4uH2yFZ3Eghfe311xH6d+hFx9IUehwgwPuz9nAimWpy7+eImeuvmxLiWfPlQZG4Mzh91UDKh47YXUD7OYBBi7oZqK8hv6t0XFPlGb7IIq5Dg92HjxnMsC1u7tXN05e7Q5Qz28yt+rTDs5Rws1hGh2dsxt0FPuQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

December 4, 2025 at 23:06, "Andrey Konovalov" <andreyknvl@gmail.com mailt=
o:andreyknvl@gmail.com?to=3D%22Andrey%20Konovalov%22%20%3Candreyknvl%40gm=
ail.com%3E > wrote:


>=20
>=20On Thu, Dec 4, 2025 at 3:38 PM Jiayuan Chen <jiayuan.chen@linux.dev> =
wrote:
>=20
>=20>=20
>=20> I think I don't need KEEP_TAG flag anymore, following patch works w=
ell and all kasan tests run successfully
> >  with CONFIG_KASAN_SW_TAGS/CONFIG_KASAN_HW_TAGS/CONFIG_KASAN_GENERIC
> >=20
>=20Thanks for working on improving the vrealloc annotations!
>=20
>=20But I think we need to first fix the vrealloc issue you discovered in
> a separate patch (so that it can be backported), and then we can apply
> your other vrealloc changes on top later.
>=20
>=20So please implement a version of your fix with KEEP_TAG -- this would
> also allow Maciej to build on top.

Thanks, i will just use KEEP_TAG and make the patch as simple as possible=
.

CC Maciej

Thanks.

> >=20
>=20> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> >  index 1c373cc4b3fa..8b819a9b2a27 100644
> >  --- a/mm/kasan/hw_tags.c
> >  +++ b/mm/kasan/hw_tags.c
> >  @@ -394,6 +394,11 @@ void __kasan_poison_vmalloc(const void *start, =
unsigned long size)
> >  * The physical pages backing the vmalloc() allocation are poisoned
> >  * through the usual page_alloc paths.
> >  */
> >  + if (!is_vmalloc_or_module_addr(start))
> >  + return;
> >  +
> >  + size =3D round_up(size, KASAN_GRANULE_SIZE);
> >  + kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
> >=20
>=20This does not look good - we will end up poisoning the same memory
> twice, once here and once it's freed to page_alloc.
>=20
>=20Is this change required?
>=20
>=20>=20
>=20> }
> >=20
>=20>  #endif
> >  diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> >  index 2cafca31b092..a5f683c3abde 100644
> >  --- a/mm/kasan/kasan_test_c.c
> >  +++ b/mm/kasan/kasan_test_c.c
> >  @@ -1840,6 +1840,84 @@ static void vmalloc_helpers_tags(struct kunit=
 *test)
> >  vfree(ptr);
> >  }
> >=20
>=20>  +
> >  +static void vrealloc_helpers(struct kunit *test, bool tags)
> >  +{
> >  + char *ptr;
> >  + size_t size =3D PAGE_SIZE / 2 - KASAN_GRANULE_SIZE - 5;
> >  +
> >  + if (!kasan_vmalloc_enabled())
> >  + kunit_skip(test, "Test requires kasan.vmalloc=3Don");
> >  +
> >  + ptr =3D (char *)vmalloc(size);
> >  + KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> >  +
> >  + OPTIMIZER_HIDE_VAR(ptr);
> >  +
> >  + size +=3D PAGE_SIZE / 2;
> >  + ptr =3D vrealloc(ptr, size, GFP_KERNEL);
> >  + /* Check that the returned pointer is tagged. */
> >  + if (tags) {
> >  + KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN);
> >  + KUNIT_EXPECT_LT(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
> >  + }
> >  + /* Make sure in-bounds accesses are valid. */
> >  + ptr[0] =3D 0;
> >  + ptr[size - 1] =3D 0;
> >  +
> >  + /* Make sure exported vmalloc helpers handle tagged pointers. */
> >  + KUNIT_ASSERT_TRUE(test, is_vmalloc_addr(ptr));
> >  + KUNIT_ASSERT_NOT_ERR_OR_NULL(test, vmalloc_to_page(ptr));
> >  +
> >  + size -=3D PAGE_SIZE / 2;
> >  + ptr =3D vrealloc(ptr, size, GFP_KERNEL);
> >  +
> >  + /* Check that the returned pointer is tagged. */
> >  + KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN);
> >  + KUNIT_EXPECT_LT(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
> >  +
> >  + /* Make sure exported vmalloc helpers handle tagged pointers. */
> >  + KUNIT_ASSERT_TRUE(test, is_vmalloc_addr(ptr));
> >  + KUNIT_ASSERT_NOT_ERR_OR_NULL(test, vmalloc_to_page(ptr));
> >  +
> >  +
> >  + /* This access must cause a KASAN report. */
> >  + KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[size + 5=
]);
> >  +
> >  +
> >  +#if !IS_MODULE(CONFIG_KASAN_KUNIT_TEST)
> >  + {
> >  + int rv;
> >  +
> >  + /* Make sure vrealloc'ed memory permissions can be changed. */
> >  + rv =3D set_memory_ro((unsigned long)ptr, 1);
> >  + KUNIT_ASSERT_GE(test, rv, 0);
> >  + rv =3D set_memory_rw((unsigned long)ptr, 1);
> >  + KUNIT_ASSERT_GE(test, rv, 0);
> >  + }
> >  +#endif
> >  +
> >  + vfree(ptr);
> >  +}
> >  +
> >  +static void vrealloc_helpers_tags(struct kunit *test)
> >  +{
> >  + /* This test is intended for tag-based modes. */
> >  + KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_GENERIC);
> >  +
> >  + KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
> >  + vrealloc_helpers(test, true);
> >  +}
> >  +
> >  +static void vrealloc_helpers_generic(struct kunit *test)
> >  +{
> >  + /* This test is intended for tag-based modes. */
> >  + KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
> >  +
> >  + KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
> >  + vrealloc_helpers(test, false);
> >  +}
> >  +
> >  static void vmalloc_oob(struct kunit *test)
> >  {
> >  char *v_ptr, *p_ptr;
> >  @@ -2241,6 +2319,8 @@ static struct kunit_case kasan_kunit_test_case=
s[] =3D {
> >  KUNIT_CASE_SLOW(kasan_atomics),
> >  KUNIT_CASE(vmalloc_helpers_tags),
> >  KUNIT_CASE(vmalloc_oob),
> >  + KUNIT_CASE(vrealloc_helpers_tags),
> >  + KUNIT_CASE(vrealloc_helpers_generic),
> >  KUNIT_CASE(vmap_tags),
> >  KUNIT_CASE(vm_map_ram_tags),
> >  KUNIT_CASE(match_all_not_assigned),
> >  diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >  index 798b2ed21e46..9ba2e8a346d6 100644
> >  --- a/mm/vmalloc.c
> >  +++ b/mm/vmalloc.c
> >  @@ -4128,6 +4128,7 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
> >  void *vrealloc_node_align_noprof(const void *p, size_t size, unsigne=
d long align,
> >  gfp_t flags, int nid)
> >  {
> >  + asan_vmalloc_flags_t flags;
> >  struct vm_struct *vm =3D NULL;
> >  size_t alloced_size =3D 0;
> >  size_t old_size =3D 0;
> >  @@ -4158,25 +4159,26 @@ void *vrealloc_node_align_noprof(const void =
*p, size_t size, unsigned long align
> >  goto need_realloc;
> >  }
> >=20
>=20>  + flags =3D KASAN_VMALLOC_PROT_NORMAL | KASAN_VMALLOC_VM_ALLOC;
> >  /*
> >  * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
> >  * would be a good heuristic for when to shrink the vm_area?
> >  */
> >  - if (size <=3D old_size) {
> >  + if (p && size <=3D old_size) {
> >  /* Zero out "freed" memory, potentially for future realloc. */
> >  if (want_init_on_free() || want_init_on_alloc(flags))
> >  memset((void *)p + size, 0, old_size - size);
> >  vm->requested_size =3D size;
> >  - kasan_poison_vmalloc(p + size, old_size - size);
> >  + kasan_poison_vmalloc(p, alloced_size);
> >  + p =3D kasan_unpoison_vmalloc(p, size, flags);
> >  return (void *)p;
> >  }
> >=20
>=20>  /*
> >  * We already have the bytes available in the allocation; use them.
> >  */
> >  - if (size <=3D alloced_size) {
> >  - kasan_unpoison_vmalloc(p + old_size, size - old_size,
> >  - KASAN_VMALLOC_PROT_NORMAL);
> >  + if (p && size <=3D alloced_size) {
> >  + p =3D kasan_unpoison_vmalloc(p, size, flags);
> >  /*
> >  * No need to zero memory here, as unused memory will have
> >  * already been zeroed at initial allocation time or during
> >
>

