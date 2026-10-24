Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13079606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hHc+CIUO
Received: by kanga.kvack.org (Postfix)
	id 7D1006B05B4; Sat, 24 Oct 2026 15:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9E76B05B8; Sat, 24 Oct 2026 15:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697456B05B9; Sat, 24 Oct 2026 15:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 29ED96B05B4
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:23:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 925F6A04B3
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:22:59 +0000 (UTC)
X-FDA: 85358492478.13.198E99F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 127271A0008
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:22:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hHc+CIUO;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792869778;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kd3MtfqA/aqWIyW7moro4bTPKCESSsJ0Xx5Da81C2bo=;
	b=AEyfobJh/eoU1jJQ8RQh7zTZv6bg8Ue2Tt4t5mYMMrJ9R6Bvr9N7xTaYOzEztgx9ImZqya
	jcDsIOyzv+4xyZwiUDOuK8EPXAHlcV82AUcofxc+W5QHjkQFnCy/FZjeljhY6qGcqEMSPF
	OT4/+D0Qlniz/m/dM18yQ+cKDwYDDeU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hHc+CIUO;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792869778;
	b=q7yuG8VGPlWJeUub5Vcymjv+TFS+9jZ1R9fhDz/U2AFoDl3mR1lijs+VhX6LDOfzL+dGXG
	BxxvGMQNfZkTDY09fqg4prZsHmm7+t44+CW5WdszBRWtwmblVeWz8qzvWAzIlUaM4J5Qv/
	GE0qvRFGoV05u0kjEpUJSWOY+oySxRM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B30F601EF;
	Sat, 24 Oct 2026 19:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FA61F01825;
	Sat, 24 Oct 2026 19:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792869777;
	bh=Kd3MtfqA/aqWIyW7moro4bTPKCESSsJ0Xx5Da81C2bo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hHc+CIUOCPFhYAgc0roe73UX5/0EsLPqzsyWdpGEyIw9nzDzl52SMx+hXnsCnSZCs
	 QsAAhekqZbivA8OBVmKP7kLoXpHjn30zVnx1NH6RYXiQx1YO2h9pK4Af5pNT56QP04
	 axNPAF66RFTgXWSIQWZDM5EfkDQhud7X92IYxpdsmJrk8A1uFDf/a7pwIXlOcAfQKS
	 gUjjcOgFG21G1qkF64bNKiHIi/nOalT4HwAST+HznVeFbSnNksiBl1RhDJnhPEcI56
	 7ijFCnohjLQR6WORxOVb30ZI1+Jk4MSN2Vy8rrnLb84swN6cGn7iwuzg4eGOKE+h6g
	 vMuYRG+jglTyw==
Message-ID: <sashiko-outbox-183853@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 8/8] mm, slab: deprecate CONFIG_SLUB_TINY and
 reduce its Kconfig effects
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Vmxhc3RpbWlsIEJhYmthIChTVVNFKQ==?= <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Geert
 Uytterhoeven" <geert@linux-m68k.org>, "Conor Dooley" <conor@kernel.org>, "Damien
 Le Moal" <dlemoal@kernel.org>, linux-mm@kvack.org
In-Reply-To: <20261024-slub_tiny_rework-v2-8-bf1419ab5ffd@kernel.org>
References: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
 <20261024-slub_tiny_rework-v2-8-bf1419ab5ffd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 19:22:56 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 127271A0008
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: tc9qm6e1yc98knrc9ai1azodd9csx3qr
X-HE-Tag: 1792869777-114268
X-HE-Meta: U2FsdGVkX19wDk5DSfDOXy5f7Xlcvaa1YJPp8104d9ctmVbfNWR9UHfQLGSby7xkdHNvnm6sTAdG5nIGciXaGWo7P5Q65MToC/84JfgSfFS2508xk59Ayi6Ukw4UhK7bMHROAocFsTC/dOPH7ByLjfWIcDmXNQlUos2SVsgeQnj7W5cOjYvHnaBPooFkuyJw78IDv7CpkoKETj0fY/fEz6UTYwph3yHgijbipc7+xkCbMp8HR6sZcexVghM/VQlDXXkJ2cSsmCPtFQoiGNSPxf/PkwV9WqHT8U35SSfGRdck5Nya/H625oqkcGgRDSG97taoUyeS+WRU2HZyIZVHHxoS/yQJ0xUM33Ooie7iyfaIVCGrhA7MDHGLYIRQPH7G30Oz2aHeh4uPr93kCEliU3PzJRRVooi3slqkljc8X8hIWHFMfTyTg+9e+xBWXqLVjFb/Z4aJuQf8I7T390ydsQKRzwVXXlIePMi5ZCRS9Vge9Y1V8uk3K0XTOuQjRXffTFraZxTXDX4PAsKFnGvI5OYIWRsNqfnARXThxmQpIajcS1eu1H2MseR7YqTzOkz+1Kxn6DxuIprva4NJ/BCNWRDHDBQeon5zgJ+2P3gGkILEImHn46GscGP1H5RNI66Q5xKUYBmc/bBUcmfzQMKnvKxl6EKayZ5hdKg6RxvMO1lhFvZtqBBKJD1g0Thh1BfuA5eDjbhTQ0oeQFYXpgI2Ul1M9XXYleLSE3WuD3wu87ijYA4H1w0xEso05CDn5uE2q367wS8512l6+tmuGWYNHe3UVZJwiY6XSdxmiN8THluAAMZUfxcqUiRvbeYxTgE6G4/Q0BZChyrshwSC54jCI6hOaDjqxw1Mi/hVQSR92rMRDC/cWylVLYKaxN+oJHBQcvO1N+tubtvU+bYpymA3aGm7USehQ2CdO9wG2IWb1JhxCrXlE+Ivnis+a70h9BI0QdDGLfc6DhZcQaqKKZD
 LhvSlise
 wwn39Nv2CqxaGpUf5mCqb6I+fFg6W5Fe1QSrbMB/UslVpYLu0aNC8kFP0hlhV1agCAStMJm3xd5Gx1Y/0Pz6y5Yq2QliDnDzE5fKSQSUOhixhMH2Mdnp2OJk/EK7IRWdYIS47bhD55Ef2vt9QNnbR9SArkcBzYofuTHAj7IrWDPpowq3hwkWOi/4tekmvY3FkC2vMlxNPrqwyptEM3T1hfCIcfQTe+OJRlZtDPzI7BzMwou3hcSDJNt6gC7DRkYC7iNzp8gHrvTE16RtA/bvL2ejWmt3PwmssolA5W21ktd8bC5kiIeaND4f/bVd2VVtL8S1AzKyWmIa2K7YxK4Si1qA7JCPto43IGpYlGQTuMFY2CoBYxDBbQqm6R+0pa7Ta5+MzW23uuUu939Jb0RHUZEQIqFqFyGV+kdngD3vDHB9csP8VMDIcnRfVyB8v3IxMZIPfAwnuUCVg8+n3nx2pejk4snj1yD+M4x1/jClELktrLJ7E+F7OCCk8Mdd410o/az9ETXjg2oAq/EdCzTDjQamXv+RPp5YEyTPKtFkFZpgKwYBmLrIuFWKDdmbfpcvY1SiFDOpJ86xbTCBUigdb+BfXHz6ex9f5bjo63Pn+YTcMpocQoK5rA8528MRJtaD3Md02wdo5YDLbFhqfIBXpKKFTApr2zbBgPF2D854zw9KvIzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: slub: immediate slab free with SLUB_TINY breaks SLUB_DEBUG and=
 KASAN
--

commit 1e2131ba6ae41313bf0a5ddd37175ec68730ea9a
Author: Vlastimil Babka (SUSE) <vbabka@kernel.org>

mm, slab: deprecate CONFIG_SLUB_TINY and reduce its Kconfig effects

This commit deprecates CONFIG_SLUB_TINY in its Kconfig description and
removes its dependencies and selections from related Kconfig options such
as KASAN, KVFREE_RCU_BATCHED, SLUB_DEBUG, SLUB_STATS, and slab hardening
configs.

> diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
> index a4bb610a7a6fa..f20b574f6653a 100644
> --- a/lib/Kconfig.kasan
> +++ b/lib/Kconfig.kasan
> @@ -49,7 +49,7 @@ menuconfig KASAN
>  		     (HAVE_ARCH_KASAN_SW_TAGS && CC_HAS_KASAN_SW_TAGS)) && \
>  		    CC_HAS_WORKING_NOSANITIZE_ADDRESS) || \
>  		   HAVE_ARCH_KASAN_HW_TAGS
> -	depends on SYSFS && !SLUB_TINY
> +	depends on SYSFS

[ ... ]

> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index 9eaa25d1cf234..4e36c7c63ef78 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -48,7 +48,7 @@ config DEBUG_PAGEALLOC_ENABLE_DEFAULT
>  config SLUB_DEBUG
>  	default y
>  	bool "Enable SLUB debugging support" if EXPERT
> -	depends on SYSFS && !SLUB_TINY
> +	depends on SYSFS

[Severity: High]
Can allowing CONFIG_SLUB_DEBUG and CONFIG_KASAN when CONFIG_SLUB_TINY=3Dy
cause use-after-free writes to freed page-allocator pages and NULL pointer
dereferences when slab_tiny_enabled is active?

When slab_tiny_enabled is true (the default under CONFIG_SLUB_TINY=3Dy),
do_kmem_cache_create() in mm/slub.c sets s->min_partial =3D 0 for all cache=
s:

	s->min_partial =3D min_t(unsigned long, MAX_PARTIAL, ilog2(s->size) / 2);
	s->min_partial =3D max_t(unsigned long, MIN_PARTIAL, s->min_partial);
	if (slab_tiny_enabled)
		s->min_partial =3D 0;

When freeing the last in-use object in a slab via free_to_partial_list() in
mm/slub.c, s->min_partial =3D=3D 0 causes the slab page to be immediately
removed from n->partial and freed back to the page allocator via
free_slab() -> __free_slab():

	if (slab->inuse =3D=3D 0 && n->nr_partial >=3D s->min_partial)
		slab_free =3D slab;

With CONFIG_SLUB_DEBUG enabled alongside CONFIG_SLUB_TINY, tests in
lib/tests/slub_kunit.c (such as test_clobber_redzone_free(),
test_next_pointer(), test_first_word(), and test_clobber_50th_byte())
allocate a single object from a cache, call kmem_cache_free(s, p), and then
write to p before calling validate_slab_cache(s):

	kasan_disable_current();
	kmem_cache_free(s, p);
	p[64] =3D 0xab;

	validate_slab_cache(s);
	KUNIT_EXPECT_EQ(test, 2, slab_errors);

Because kmem_cache_free(s, p) frees the only object in the slab, the backing
slab page has already been returned to the page allocator when p[64] =3D 0x=
ab
executes, turning those writes into use-after-free writes to a free buddy
page while validate_slab_cache(s) scans an empty partial list.

Similarly, under tag-based KASAN modes without quarantine
(CONFIG_KASAN_SW_TAGS or CONFIG_KASAN_HW_TAGS), freeing the sole object in a
slab immediately frees the slab page and clears its slab page type. If a
double-free occurs (such as in kmem_cache_double_free() in
mm/kasan/kasan_test_c.c):

	kmem_cache_free(cache, p);
	KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_free(cache, p));

kasan_slab_pre_free() -> check_slab_allocation() in mm/kasan/common.c calls
nearest_obj() with virt_to_slab(object) =3D=3D NULL when
CONFIG_SLAB_FREELIST_HARDENED and SLAB_CONSISTENCY_CHECKS are not active:

	if (unlikely(nearest_obj(cache, virt_to_slab(object), object) !=3D object)=
) {
		kasan_report_invalid_free(tagged_object, ip, KASAN_REPORT_INVALID_FREE);
		return true;
	}

Wouldn't this dereference NULL at slab->objects inside nearest_obj() (and
also cause kmem_cache_rcu_reuse() in mm/kasan/kasan_test_c.c to fail because
the slab is queued for rcu_free_slab() instead of remaining on n->partial)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024-slub_tiny_=
rework-v2-0-bf1419ab5ffd@kernel.org?part=3D8

