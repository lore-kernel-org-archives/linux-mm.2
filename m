Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9FF606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AErUo+gX
Received: by kanga.kvack.org (Postfix)
	id 903316B05BA; Thu,  5 Nov 2026 08:26:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DAED6B05BB; Thu,  5 Nov 2026 08:26:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0666B05BE; Thu,  5 Nov 2026 08:26:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 624AD6B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:26:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB5BAC0991
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:26:41 +0000 (UTC)
X-FDA: 85401140202.21.2A1BFF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5F962C0005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:26:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AErUo+gX;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793885200;
	b=JJoJdaItbOpAdAWwqocAVkHhqWjCSXT3nLi5W+iY5JtW45jcPenwHh6b6lj9pemKmO3y0i
	eJ2Z3arwfLQEjoqN8ClecjfsvjCxNILMCxLVZzwLmp0C36rC0eKtE9HhrKM5d5lB/b8HzV
	6QejW3IJna2oYU97YFU9pkalowcEgPo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AErUo+gX;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793885200;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaZuapltOls0ICv2ewjQnLeAoypGsXpSxX88e5fOByA=;
	b=Pr6cWotPh4IVG8z/BD3fB9eWj1B5VKDG0FUDR3DlJCq3wRFVEZMDVJXap9qVI6GUkA+ck1
	NUt8MLTymdVV7WwxHXp3Pjpnch2IafWOGTsjBV+dpW8SATZeZWdTSNbTudIQnoOXE84GUO
	VFp97VR12IFZKi77VF54A3duN4LnoLQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CFE5C60267;
	Thu,  5 Nov 2026 13:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3197B1F000C1;
	Thu,  5 Nov 2026 13:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793885199;
	bh=CaZuapltOls0ICv2ewjQnLeAoypGsXpSxX88e5fOByA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AErUo+gXFv3No0OFHUJl/qbfS+KaX667h1kJttMGqwMBsRPL+53J5wRBHty0+Jo29
	 hqc3kwDDR+E45oSwdrW4mqIU52abYVU1sI2Qqge55+UyxPGyC/emBU3SKxBOl4hZD7
	 lt9AcO0bZ7TqD7hxmtu9Aaf+TARDv1BdRJKYXf5orm+Zg0Rn69l0Z3pkLLS/BJky95
	 a1xdZ+ABMGvPCbpP81/46ixuj7Irk97c9Kf/RJQ3jV7ACP0S6L0HejsC68Z8xBEMSP
	 2P9PUw2h1HoGHRD2OE1K9H7irNvoiPc8yab3kPe1X8W7FuOCTJADF7WRLUu3Tl0jEB
	 l8O8bR5oSH42w==
Message-ID: <sashiko-outbox-199142@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 02/10] kasan, kunit: pin test slabs by an extra
 allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Vmxhc3RpbWlsIEJhYmthIChTVVNFKQ==?= <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Geert
 Uytterhoeven" <geert@linux-m68k.org>, "Conor Dooley" <conor@kernel.org>, "Damien
 Le Moal" <dlemoal@kernel.org>, linux-mm@kvack.org, "Alexander Potapenko" <glider@google.com>, "Andrey
 Konovalov" <andreyknvl@gmail.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
In-Reply-To: <20261105-slub_tiny_rework-v3-2-0484ce59eabb@kernel.org>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
 <20261105-slub_tiny_rework-v3-2-0484ce59eabb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 13:26:36 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5F962C0005
X-Stat-Signature: uyzjq7h4unfc4cmbpskstfabusix9ks5
X-Rspam-User: 
X-HE-Tag: 1793885200-990470
X-HE-Meta: U2FsdGVkX18m8eolrjG781ZUGRveLI7U2ENP4ceLUH1Q0u9BgFA29Els+6lGG9KTHEwuQzjZrQNnqQilYc9y1fetmC8RBNc+8iA5ouzn/lIBrKIWfM/KJoBsSDLUuHX0R6uznMeBEtesc+V8fQSCOAeN7gT4mpJ0tv41eD5l2HSdqwl8lpS32bfB7BxvQJkyn+rI0pNSJTaQSNXDR1wJunuhqugrznhkzZA0PjNiAzXjdWdjQSAB4kDeyh7D0VSHl548g8yIkLO0i142PkWeTg3GZAtk2Fi8T2I/rYduGUCjV+LLPEnU54390FrHNAqZgNlumxT+Fa4YuUQVzyMd06KafFwGPtWIIaRzEa+dFxyLCllZqa7yrJfCyzGObL4cckROG3eiaghlBXI5FM8aowENDYhtY9/uTM1K9y7htjyPT20OV4CXxcXXMZ6w98S69q6VdrCym/AUG8WtLxFKyQ0JcmObumyc8AdHqZdWzUaavIGlYPoNVmBTEm8cU7jZ3KBlLbkLcu1quiE0tbXW8Kal0u9glqSlhGROv7C48ldjf53P6PGrt6VQR2elQ06lSBGhi3tsDNxrxamb9ydutXt+pJk6h6C9mv3Cma0Spd3W0JZYkKSdJjcFb7WsygqcMy00HFKH4JBoGC355OHZWzRgsN882kIilpLrMNOOFsp9iMM+P4auL9fpRczt5dSF95Q8i4w2ZFuuuGgayYQrL9ZzI58Tzg4iD9pApGmoZ/F2k+m4fbI6159gxRD2vwz4XAT6aIGo56AHbQHpBNj3wGdx06NJdKVoGd0+IAbr1cUKDFGuvm169r5Kq0Fo6TMFEIhuLBwFjxOL1jQk4/2oVRAY+cq20TRUL4xb1bLqT+oIAJa8Po3AwbGpviyNFMUhmtGvQMSJSxKwfXFJzNObACNian0SgTtzAchTywkmefDS+8xfGSG1bKryzxLR9A0cMY8UOPM+5NZv5sPnL7U
 jPZ8R9Wi
 +O7zRVN149/uzN6UnDyNuq0MA+WWLGQWql9Y2mSyhmUFXblFYSiX/OQNKAp3HttvY7Z69etGnOYeB0w9cF7JYp7VxF7CgwDcodwoVSA/RmrzPUe0OBtQLpmuPte3rl5BN4pfagMXBhnzfUuQwg5D4nQzZn0g0OcV/OBr5bSId4R2mpwcCrDihJ4432Op42CF6CrCRiEikK7Y2rDM/xkQNFjjVMJ9fi38Hl45PCQqBCKM1oDJwc1CH0mfAAxY8Ugmx9cXRY+5TPfUykcR5JbKWqPvniR/LBchECFV6sJD7lzDMZmBYvUCW20+6FEQMgVNScsBlSGuVm4pGSbj0j368pMmHvqAVMYx6WA2a2pYkJ4LPGXCA33DK/v8yUM5dHnV/8P/678s/O8+W/EIsUKpynhDY/SVGyt2zEngfY/LvMwGukgpwS6tWPHpE+rFdM3wkH+Vy9FMSjyJ0C+5lRoWyLDXHR/Z0JyzpAyq+XCpS5AJc6GW/rA46qAy4wg7OBjnnkv2gtbwy/wXfK713+mqosPSbWGK3j4Jo0UU2aMdxPqGXTo4npug05A40qospAIRb0e/Srs0W2KqL6kSfHM3tyXsvCeKDuWaFtBCkAWLiMazNAlDodc8rpcyDxOPH39YySK/RtKMEPD+TIc4O5biEvOM7M8d+igi5XM+pCv2Ns1/1j0LC0VrVjENTYz6m2lkggE3sLalKui5+8gs=
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
- [Medium] kasan: kunit: unbalanced migrate_disable() in kmem_cache_rcu_reu=
se()
--

commit 9889dce92c4935230b2785629413456302c4d31c
Author: Vlastimil Babka (SUSE) <vbabka@kernel.org>

kasan, kunit: pin test slabs by an extra allocation

This commit adds an extra object allocation to kmem_cache_double_free() and
kmem_cache_rcu_reuse() in mm/kasan/kasan_test_c.c to keep the test slab from
being freed when s->min_partial is zero.

> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index b9e167ed5be32..580a9bf007ec4 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c

[ ... ]

> @@ -1152,7 +1160,7 @@ static void kmem_cache_rcu_uaf(struct kunit *test)
>   */
>  static void kmem_cache_rcu_reuse(struct kunit *test)
>  {
> -	char *p, *p2;
> +	char *p, *p2, *pin;
>  	struct kmem_cache *cache;
> =20
>  	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_SLUB_RCU_DEBUG);
> @@ -1162,6 +1170,12 @@ static void kmem_cache_rcu_reuse(struct kunit *tes=
t)
>  	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
> =20
>  	migrate_disable();
> +	pin =3D kmem_cache_alloc(cache, GFP_KERNEL);
> +	if (!pin) {
> +		kunit_err(test, "Allocation failed: %s\n", __func__);
> +		goto destroy;
> +	}
> +
>  	p =3D kmem_cache_alloc(cache, GFP_KERNEL);
>  	if (!p) {
>  		kunit_err(test, "Allocation failed: %s\n", __func__);
> @@ -1178,8 +1192,12 @@ static void kmem_cache_rcu_reuse(struct kunit *tes=
t)
> =20
>  	kmem_cache_free(cache, p2);
> =20
> +
>  out:
>  	migrate_enable();
> +	kmem_cache_free(cache, pin);
> +
> +destroy:
>  	kmem_cache_destroy(cache);
>  }

[Severity: Medium]
If kmem_cache_alloc() for pin fails in kmem_cache_rcu_reuse(), jumping to t=
he
destroy label skips migrate_enable(), leaving migration disabled when
kmem_cache_destroy() is called and after the function returns. Should
migrate_enable() be called under the destroy label, or before jumping to
destroy?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-slub_tiny_=
rework-v3-0-0484ce59eabb@kernel.org?part=3D2

