Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2413D1F9AF
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:38:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F4816B008C; Thu,  4 Dec 2025 09:38:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CC776B009F; Thu,  4 Dec 2025 09:38:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2486B00A2; Thu,  4 Dec 2025 09:38:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0456B008C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:38:20 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A50AC12A3C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:38:19 +0000 (UTC)
X-FDA: 84182043918.08.9FA347A
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7DB014000B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:38:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JM4wZYbS;
	spf=pass (imf01.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764859098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oyv8T3zljC5amsZPaB9Pcte8dRSYUhsdKHtrFYp3ltI=;
	b=w/BUrCyAc3b+h4n6ZB0G9CagG9uDpX76Tl3X8X0VBH2evJ3NnufE4Ry2SghLjcoa0J2E4B
	4Yc02v/vZNwv5FV8c74rLvBME8c5qtBSSqxT8v+twcfMXSrvkXt/quwD7NjO5co4DnC3Dd
	QVIGHau0sSf1n4wo5+6NQBWeOAJlWe4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JM4wZYbS;
	spf=pass (imf01.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764859098; a=rsa-sha256;
	cv=none;
	b=Kzw1EN9tBktoaFnDiWNdrMfuG169T8xWtJ5m5Id261UpW8FJ02pnFgpemYbDVo28Y5eWNz
	AO/EgrBHZRF23kfbIhGBMS/MleFGIwfkI1uPhW3ScNmuNQtvIbuWiS2cQ6rcFxlrWj4C4h
	qeTgovHLCXtlfKqs4UnJcYcdvBOINLQ=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764859095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oyv8T3zljC5amsZPaB9Pcte8dRSYUhsdKHtrFYp3ltI=;
	b=JM4wZYbS6PN4WOkpcTsmyfuEYnqIDtFc8l3AXkH0Qf62PC/gWco3qiHf/uptpNFXlrMpew
	n/cyWOCkBUDhw8VloiuQNrXbBYec75TdhztnT+UEVVBy4lpnXKawdURO1rU1zqQ030nIG5
	RmyNLeEWz7rVwOteYtoF+dwr8ZpVlgw=
Date: Thu, 04 Dec 2025 14:38:12 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <ef40d7bb8d28a5cde0547945a0a44e05b56d0e76@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm/kasan: Fix incorrect unpoisoning in vrealloc for
 KASAN
To: "Maciej Wieczor-Retman" <m.wieczorretman@pm.me>
Cc: "Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>,
 linux-mm@kvack.org,
 syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, "Andrey Ryabinin"
 <ryabinin.a.a@gmail.com>, "Alexander Potapenko" <glider@google.com>,
 "Andrey Konovalov" <andreyknvl@gmail.com>, "Dmitry Vyukov"
 <dvyukov@google.com>, "Vincenzo Frascino" <vincenzo.frascino@arm.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Uladzislau Rezki"
 <urezki@gmail.com>, "Danilo Krummrich" <dakr@kernel.org>, "Kees Cook"
 <kees@kernel.org>, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org
In-Reply-To: <5o7owlr4ap5fridqlkerrnuvwwlgldr35gvkcf6df4fufatrr6@yn5rmfn54i62>
References: <5o7owlr4ap5fridqlkerrnuvwwlgldr35gvkcf6df4fufatrr6@yn5rmfn54i62>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: em91abxj6r163krehf14nm1nyfaexbt6
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DB014000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1764859097-539406
X-HE-Meta: U2FsdGVkX1+R97SirPoWJgL+tnNO0DbCB9RVkRRe7vZ50eNTXgN+Ck30BmZkCDGt1MA/6500SDkvePraY/hPbNhzMHQZDIzY4i17OWuOKBNXlP/v4qdOgGEFHCPu1HGJI+tZqIw1BXNuffFM4ucMK16VOPsUDzQCAQTfQq+zh2YZR62UylDECPLOu8XBQt+MjWPiR/3zluJVlo333fVITrePjhSeMlbjvEK5pp1VK8Q5EaNbsI3D+bsFaYcWfeckknaqZ0DvztAGWiWz/AtH6/ZRQPxWP9G1OX0xtXe0hlUUr9xegCoFwIL6VOs3Yb+QTgQwKFWyrXItxLxvm8eyD+NiCULu1AqUdQoAZgZ/HdsD5Ii9VyKw7FoWb8Wh8VZSBrVsRd7+/UoXKy/cGpQYcu9yOlmm53EeWmLkLNuO5H4ic+g03UPhl5ubfv6HGopNp9wqj2/V/Y0+C4YKlxh4jkrkR1PHxffsV883xkRkgi2GtKxfNpwXho9xkskWKXngosgOjgyK5aH0G18GUY4rzD/OQ5aNNoQwREmmKaCPzmVs5w+HD35qwxuX9ytsRoU96eyLf7GOtKB+IyWlL8poUG1XvJe3TLPRhEP/UB7K3qwbs2tISBDrTiIzFDsi7u+zJTVyxgwuYbn65ODTPPdm3quzwNCNjp/BLRTURJNnic9owN3y5uu18SP1sU7kzhb6qODH9VS5jkkGKOah6MPh7kHylj6h4PlBzhOxcXbahS55woarAurUpIP84cfzDfzbQHGIU3e4vbG30dXtNTnS8BzxxuEITUxAOOA1hkmrbz8Ui7N/FxWTn/j/y7ZatZ2f/DjE+8SeX+JHbxZX/fVygyHgEv1/qcB8o1GcdYAfOG58gEwZhcytoFtlnSmMPDAPLXjIxbZR/eU31iqAFd3HSYtNuPKdEq7xgB+hbhl8/pGrOUO/msL3dOv86ESsOymYmD5KX3jgXU1OPdT1tLr
 r1SKxoF2
 dvlesCOJIvtOcOEu1xmCCK7ky1Xm4ziLurULM4r4T7sx+u6YTktsxiwJIehuHbwYtp02/nx/bnCyqnGWcDp7wD8H/CkJO8brMTyEyEJgWo6qcWv2r/jXqSHcheZ9EGE+6pNHeV5Kal4wasR7/8eIlKkvJb+xefTfWW8wrX5bVebcKZl1kjJq5KcYeEaZw36pIK+XYXF6dhLVvqRyKgOK66IYLs05H85p+Xwb8yyOhpNL7J1FYIApmZiZ2Age0CRYLXF8DI9F9JTa8nt7/4SruMN+GP8HLWI6quqZZGxsCC2nFGGSu7THVKKH6bk1lL6SyRuW1LaMxMd7/M+m6iD9sapW9yYsMrEDXGtH1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

December 4, 2025 at 21:55, "Maciej Wieczor-Retman" <m.wieczorretman@pm.me=
 mailto:m.wieczorretman@pm.me?to=3D%22Maciej%20Wieczor-Retman%22%20%3Cm.w=
ieczorretman%40pm.me%3E > wrote:


>=20
>=20On 2025-12-03 at 02:05:11 +0000, Jiayuan Chen wrote:
>=20
>=20>=20
>=20> December 3, 2025 at 04:48, "Maciej Wieczor-Retman" <maciej.wieczor-=
retman@intel.com mailto:maciej.wieczor-retman@intel.com?to=3D%22Maciej%20=
Wieczor-Retman%22%20%3Cmaciej.wieczor-retman%40intel.com%3E > wrote:
> >=20
>=20> >=20
>=20> > Hi, I'm working on [1]. As Andrew pointed out to me the patches a=
re quite
> > >  similar. I was wondering if you mind if the reuse_tag was an actua=
l tag value?
> > >  Instead of just bool toggling the usage of kasan_random_tag()?
> > >=20=20
>=20> >  I tested the problem I'm seeing, with your patch and the tags en=
d up being reset.
> > >  That's because the vms[area] pointers that I want to unpoison don'=
t have a tag
> > >  set, but generating a different random tag for each vms[] pointer =
crashes the
> > >  kernel down the line. So __kasan_unpoison_vmalloc() needs to be ca=
lled on each
> > >  one but with the same tag.
> > >=20=20
>=20> >  Arguably I noticed my series also just resets the tags right now=
, but I'm
> > >  working to correct it at the moment. I can send a fixed version to=
morrow. Just
> > >  wanted to ask if having __kasan_unpoison_vmalloc() set an actual p=
redefined tag
> > >  is a problem from your point of view?
> > >=20=20
>=20> >  [1] https://lore.kernel.org/all/cover.1764685296.git.m.wieczorre=
tman@pm.me/
> > >=20
>=20> Hi Maciej,
> >=20
>=20> It seems we're focusing on different issues, but feel free to reuse=
 or modify the 'reuse_tag'.
> > It's intended to preserve the tag in one 'vma'.
> >=20
>=20> I'd also be happy to help reproduce and test your changes to ensure=
 the issue I encountered
> > isn't regressed once you send a patch based on mine.=20
>=20>=20
>=20> Thanks.
> >=20
>=20After reading Andrey's comments on your patches and mine I tried appl=
ying all
> the changes to test the flag approach. Now my patches don't modify any =
vrealloc
> related code. I came up with something like this below from your patch.=
 Just
> tested it and it works fine on my end, does it look okay to you?
>=20
>=20---
>  include/linux/kasan.h | 1 +
>  mm/kasan/hw_tags.c | 3 ++-
>  mm/kasan/shadow.c | 4 +++-
>  mm/vmalloc.c | 6 ++++--
>  4 files changed, 10 insertions(+), 4 deletions(-)
>=20
>=20diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 03e263fb9fa1..068f62d07122 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -28,6 +28,7 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
>  #define KASAN_VMALLOC_INIT ((__force kasan_vmalloc_flags_t)0x01u)
>  #define KASAN_VMALLOC_VM_ALLOC ((__force kasan_vmalloc_flags_t)0x02u)
>  #define KASAN_VMALLOC_PROT_NORMAL ((__force kasan_vmalloc_flags_t)0x04=
u)
> +#define KASAN_VMALLOC_KEEP_TAG ((__force kasan_vmalloc_flags_t)0x08u)
>=20=20
>=20 #define KASAN_VMALLOC_PAGE_RANGE 0x1 /* Apply exsiting page range */
>  #define KASAN_VMALLOC_TLB_FLUSH 0x2 /* TLB flush */
> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index 1c373cc4b3fa..e6d7ee544c28 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -361,7 +361,8 @@ void *__kasan_unpoison_vmalloc(const void *start, u=
nsigned long size,
>  return (void *)start;
>  }
>=20=20
>=20- tag =3D kasan_random_tag();
> + tag =3D (flags & KASAN_VMALLOC_KEEP_TAG) ? get_tag(start) :
> + kasan_random_tag();
>  start =3D set_tag(start, tag);
>=20=20
>=20 /* Unpoison and initialize memory up to size. */
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index 5d2a876035d6..6dd61093d1d5 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -648,7 +648,9 @@ void *__kasan_unpoison_vmalloc(const void *start, u=
nsigned long size,
>  !(flags & KASAN_VMALLOC_PROT_NORMAL))
>  return (void *)start;
>=20=20
>=20- start =3D set_tag(start, kasan_random_tag());
> + if (!(flags & KASAN_VMALLOC_KEEP_TAG))
> + start =3D set_tag(start, kasan_random_tag());
> +
>  kasan_unpoison(start, size, false);
>  return (void *)start;
>  }
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ead22a610b18..c939dc04baa5 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4180,8 +4180,10 @@ void *vrealloc_node_align_noprof(const void *p, =
size_t size, unsigned long align
>  * We already have the bytes available in the allocation; use them.
>  */
>  if (size <=3D alloced_size) {
> - kasan_unpoison_vmalloc(p + old_size, size - old_size,
> - KASAN_VMALLOC_PROT_NORMAL);
> + kasan_unpoison_vmalloc(p, size,
> + KASAN_VMALLOC_PROT_NORMAL |
> + KASAN_VMALLOC_VM_ALLOC |
> + KASAN_VMALLOC_KEEP_TAG);
>  /*
>  * No need to zero memory here, as unused memory will have
>  * already been zeroed at initial allocation time or during
>=20
>=20--=20
>=20Kind regards
> Maciej Wiecz=C3=B3r-Retman
>


I think I don't need KEEP_TAG flag anymore, following patch works well an=
d all kasan tests run successfully
with CONFIG_KASAN_SW_TAGS/CONFIG_KASAN_HW_TAGS/CONFIG_KASAN_GENERIC


diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index 1c373cc4b3fa..8b819a9b2a27 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -394,6 +394,11 @@ void __kasan_poison_vmalloc(const void *start, unsig=
ned long size)
 	 * The physical pages backing the vmalloc() allocation are poisoned
 	 * through the usual page_alloc paths.
 	 */
+	if (!is_vmalloc_or_module_addr(start))
+		return;
+
+	size =3D round_up(size, KASAN_GRANULE_SIZE);
+	kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
 }

 #endif
diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 2cafca31b092..a5f683c3abde 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -1840,6 +1840,84 @@ static void vmalloc_helpers_tags(struct kunit *tes=
t)
 	vfree(ptr);
 }

+
+static void vrealloc_helpers(struct kunit *test, bool tags)
+{
+	char *ptr;
+	size_t size =3D PAGE_SIZE / 2 - KASAN_GRANULE_SIZE - 5;
+
+	if (!kasan_vmalloc_enabled())
+		kunit_skip(test, "Test requires kasan.vmalloc=3Don");
+
+	ptr =3D (char *)vmalloc(size);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+
+	OPTIMIZER_HIDE_VAR(ptr);
+
+	size +=3D PAGE_SIZE / 2;
+	ptr =3D vrealloc(ptr, size, GFP_KERNEL);
+	/* Check that the returned pointer is tagged. */
+	if (tags) {
+		KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN);
+		KUNIT_EXPECT_LT(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
+	}
+	/* Make sure in-bounds accesses are valid. */
+	ptr[0] =3D 0;
+	ptr[size - 1] =3D 0;
+
+	/* Make sure exported vmalloc helpers handle tagged pointers. */
+	KUNIT_ASSERT_TRUE(test, is_vmalloc_addr(ptr));
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, vmalloc_to_page(ptr));
+
+	size -=3D PAGE_SIZE / 2;
+	ptr =3D vrealloc(ptr, size, GFP_KERNEL);
+
+	/* Check that the returned pointer is tagged. */
+	KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN);
+	KUNIT_EXPECT_LT(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
+
+	/* Make sure exported vmalloc helpers handle tagged pointers. */
+	KUNIT_ASSERT_TRUE(test, is_vmalloc_addr(ptr));
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, vmalloc_to_page(ptr));
+
+
+	/* This access must cause a KASAN report. */
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[size + 5]);
+
+
+#if !IS_MODULE(CONFIG_KASAN_KUNIT_TEST)
+	{
+		int rv;
+
+		/* Make sure vrealloc'ed memory permissions can be changed. */
+		rv =3D set_memory_ro((unsigned long)ptr, 1);
+		KUNIT_ASSERT_GE(test, rv, 0);
+		rv =3D set_memory_rw((unsigned long)ptr, 1);
+		KUNIT_ASSERT_GE(test, rv, 0);
+	}
+#endif
+
+	vfree(ptr);
+}
+
+static void vrealloc_helpers_tags(struct kunit *test)
+{
+	/* This test is intended for tag-based modes. */
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_GENERIC);
+
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
+	vrealloc_helpers(test, true);
+}
+
+static void vrealloc_helpers_generic(struct kunit *test)
+{
+	/* This test is intended for tag-based modes. */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
+
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
+	vrealloc_helpers(test, false);
+}
+
 static void vmalloc_oob(struct kunit *test)
 {
 	char *v_ptr, *p_ptr;
@@ -2241,6 +2319,8 @@ static struct kunit_case kasan_kunit_test_cases[] =
=3D {
 	KUNIT_CASE_SLOW(kasan_atomics),
 	KUNIT_CASE(vmalloc_helpers_tags),
 	KUNIT_CASE(vmalloc_oob),
+	KUNIT_CASE(vrealloc_helpers_tags),
+	KUNIT_CASE(vrealloc_helpers_generic),
 	KUNIT_CASE(vmap_tags),
 	KUNIT_CASE(vm_map_ram_tags),
 	KUNIT_CASE(match_all_not_assigned),
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 798b2ed21e46..9ba2e8a346d6 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4128,6 +4128,7 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
 void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned lo=
ng align,
 				 gfp_t flags, int nid)
 {
+	asan_vmalloc_flags_t flags;
 	struct vm_struct *vm =3D NULL;
 	size_t alloced_size =3D 0;
 	size_t old_size =3D 0;
@@ -4158,25 +4159,26 @@ void *vrealloc_node_align_noprof(const void *p, s=
ize_t size, unsigned long align
 			goto need_realloc;
 	}

+	flags =3D KASAN_VMALLOC_PROT_NORMAL | KASAN_VMALLOC_VM_ALLOC;
 	/*
 	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
 	 * would be a good heuristic for when to shrink the vm_area?
 	 */
-	if (size <=3D old_size) {
+	if (p && size <=3D old_size) {
 		/* Zero out "freed" memory, potentially for future realloc. */
 		if (want_init_on_free() || want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
 		vm->requested_size =3D size;
-		kasan_poison_vmalloc(p + size, old_size - size);
+		kasan_poison_vmalloc(p, alloced_size);
+		p =3D kasan_unpoison_vmalloc(p, size, flags);
 		return (void *)p;
 	}

 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <=3D alloced_size) {
-		kasan_unpoison_vmalloc(p + old_size, size - old_size,
-				       KASAN_VMALLOC_PROT_NORMAL);
+	if (p && size <=3D alloced_size) {
+		p =3D kasan_unpoison_vmalloc(p, size, flags);
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during

