Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E42DB606B7CF
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 19:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PipEhC+e
Received: by kanga.kvack.org (Postfix)
	id D1BB66B00EF; Wed, 28 Oct 2026 15:10:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCC486B05B1; Wed, 28 Oct 2026 15:10:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D0B6B05B2; Wed, 28 Oct 2026 15:10:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87A116B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:10:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AFCA0140267
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:10:27 +0000 (UTC)
X-FDA: 85372976094.12.811AFF9
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id A5CB716000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:10:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PipEhC+e;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793214625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTRbuuK9g1LUPZHzumdbyEu1P7vkaopyl0+z0dso4UY=;
	b=DEbx6kvO3jMZAHwyZ0jIgQuVdQ7vJ0/5/BLUr2phKwpr85J4o0i3J7PxJempWQeX/2Mjth
	PYUTV/0AV1bcII583I5wfIXFCEy4zB9PT8fsce7uf/hEqVxrutLWw3ZnIqWBEilaVTDs2h
	i7IUyhbZlUXs/zNEL8MrqVZx0SkquP8=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PipEhC+e;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793214625;
	b=IP+ctPnc9iXfhN0LgOHGKYHRy21tzczTTw5qSyjybekBTWTrcVk9DcDkrO3cWVmA0H3bak
	chfVs/v+h/Hyr+Izm4W4DRoHIhudhDoB8gUmEL6jzmV6IaXCzmyQLaxAjCrcfgB7U5wTxi
	KlyRpXznw/k0ONy7Q4L4MDOPZ6KuT5c=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8b0a45e0fc2so1697557b3.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:10:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793214625; cv=none;
        d=google.com; s=arc-20260327;
        b=BfKU31HmjuB+ch24+aQlyHrfU+4er9HA/vlRo9eSfvCTU5+L2pw8FJvT9MbJAqEOVq
         oePIWMBFlNDgxMCp+qlgKvIVzFourBolqd8Oqllg3I0krTiP+b3XzOrqIkptSu7Kef0c
         1wBCsh1JWaDRxSC5vn6V2kT9MdRGi5P67SaC+mi6/AjViTnvhIE1HLfyjRH+8Xropk22
         8k8QW9sw70XdrbdkI41vkD9Tg8XjO7inrggSX73v+r6ZPTgIwSebnHvEThecW3VAsQky
         dbIBqIm0RZ3WMUE3Lvu5EIP/kblSWisYVYQ/7F+2zbaJomvuQnPa7vbzgXnvT2E9JosD
         XbWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=LTRbuuK9g1LUPZHzumdbyEu1P7vkaopyl0+z0dso4UY=;
        fh=uIxmSnTytzPbJGP6Pb/8jEf7Ob/djM+HlZWV0WZgnwI=;
        b=p/1kIUfA5Z1CvknSrLVZrMkLGMfRE1tyFiOVWKUwadL7Yg3ykdD4vV+E4wyfuYGVOA
         YMrgTFTl46swzptAzyKCRqSd9r/XsirrwfgLY8fw01njZeB1Fg8DEgotstTriWV6UEto
         zv/XsWt0tll6K1OdZr4s/lZ8fwCJ1zz+LAJcOI8JhxHLQInbRn+a66R6HCNHyIooav6+
         Xz6MX3qdkYkl4zPxHLHLn5BGUnIaKIzgqs8uWbevtPZ7X+qP4ZRPi86EcnKnuWc5MQB9
         Dewg1Upu673bRAFAd1bcbRfr4bObC3M9Ap6eqLFn/fP64b10es6PEd8W7xRbfqkZ+hFW
         jYiQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793214625; x=1793819425; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LTRbuuK9g1LUPZHzumdbyEu1P7vkaopyl0+z0dso4UY=;
        b=PipEhC+euDwZAk4bZK6HFx/c/bDmmDrAjw+h3gOI38MQKoaX3SG70JAf6DBY0DHCzG
         FvroXEIf+zgEPBdmaWDPsX6Eag4T+7Mq3mnOygqDgANQXxrgk6DXTiarBe1o3IQe6WGC
         Eyta1E/PM7PbQlfcVqj21mLO7RNI7cmaF5G2I/W15LS7GSj+fWc+X0e467y7Pqllax4a
         Z36Wj1zwz0fmU1a7JJUNW8qbo/H4APewFMvYbdwa/xPUnbXb1XHbhFaBuA5eRK2l3xXc
         m2RRPYEVixbxe2U9/Uo7PXwTWzwR2urVkbyBLJLZv1FyxXcbaA1bAPk66uOzYd8ivLmA
         WuQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793214625; x=1793819425;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LTRbuuK9g1LUPZHzumdbyEu1P7vkaopyl0+z0dso4UY=;
        b=e3WU/XUo5IkYdLex3G6QrIqq+YCrBZauDx7m33zEukr5ntpVTOwpMxEYLwZiyR/7NC
         856ugLVuP14rEg2/nmSCehpmfShwcE9v1jBYU18s1SwzdGf+em7944pRnDfphOIyeeu+
         nLQFOmIQpqoL+a8xgWUU0k6I49TagnI76nFx8aZ0/MHAuJcCu5zsEbcJDORpplQNPu13
         cbtPc9SKVWqVKPJtrL5F8EcUBawaeqbQ3omOVfm6cxBvWuTrPzi2rQt9L+sthm62qnTS
         LadoXJnCgsXptw1c+LC3iBZAfyvXDL0RaQPaJPTCyx/++OMFVToPpV9IngklHw8riCZS
         izWg==
X-Forwarded-Encrypted: i=1; AKwUvBytRlCRQ/5Z7NCgcoW0VIi9ZP3nuIt37ovEZJlnMBi7+b8exMMo0EDLD+Pirsw3pnUj1NGGPDk8Xw==@kvack.org
X-Gm-Message-State: AFq9FYKlBdF2w+yWRCrghq9HSoYfHgUFNH9/kte4QtHPeooLqqs/5Bja
	OWyXVyvpVyga6Tw+kvOwACRO/rj0yC3BMNbJWG9uofO04LmFlx4hHeXOR0zFGKX/mZPxYW03fXr
	i2sOCkeM85mLwoQPdn8WvFQeY92vGHH0=
X-Gm-Gg: AYBFou10Tm3C+JcsvSTm5XUEovwBC8KNYIgWiJN2eT39VH9xpM6BH2MXgxXUtPvCm1Q
	iaFA6I0t8+KimTM8gOd/6xW0zLmwlrmwIP7qpXJRhSPoF2LTA+UV0g31tm01/xMgs4vElEKOOa7
	vNJxQTBaSwa1e0ZHQ11IyOHA+dkwAnO8wMCtyIS+lCSYWWX8EDyLqAdRdfUVmwRkkqcWtvv0Zls
	611BTreNXXn5gXzZCpwxdteNDZVHyoNLNTxIaZz/htCANLLm5WjtvqInvQ0TbVB3s41G2ijMzu4
	z+z3rPNghjvTTHRjGsbtjrmbT2kJVhouHpvMHH+1q0aNmmO//MIUkenoRZNcsylJV39vEGeHVLX
	VqIjJr9zeaH8xsASZkhEtC58gY06GilfDVC0=
X-Received: by 2002:a05:690e:408b:b0:677:b7a7:ba35 with SMTP id
 956f58d0204a3-67a7b9ba99bmr5590714d50.1.1793214624747; Wed, 28 Oct 2026
 12:10:24 -0700 (PDT)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 28 Oct 2026 12:10:23 -0700
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 28 Oct 2026 12:10:23 -0700
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20261027222557.1072105-3-kuniyu@google.com>
References: <20261027222557.1072105-1-kuniyu@google.com> <20261027222557.1072105-3-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 28 Oct 2026 12:10:23 -0700
X-Gm-Features: AclHuK-4hCqcwKRWdOyvz6JQHnyn5CYILZG5p3PZBGRVeev0VZcttnATHXNTRZ8
Message-ID: <CAPAsAGzK9tySui7+LBTrtONJBdXu1FUXo15S+_EZCtm-Qsccnw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/kasan/kunit: Add double-free tests involving kfree_rcu_sheaf().
To: Kuniyuki Iwashima <kuniyu@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A5CB716000A
X-Stat-Signature: xfj96j9yoozk93ak96by6noehsafxr17
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793214625-434253
X-HE-Meta: U2FsdGVkX1+IRWmNET+XzviFUrQ/hdUUeaEw3jGVobSPrIrNc6Kl+CbBOjRJ7mbHRY3yLFIe1wbN7NAp8/9fflbdky8VyVhDrMsNkz1OqZrABsdOtorPq1kwx5rG5N8M4Lw766H7iXDsOUJdOQUmX/ChgnqtrLmHgKBun8L4M7bIaCTYd02FDA2ul86WVArIw0c/N/Uz9Pqo3hjBebZaxZtNPv7JdvZMNpWnQliN3pGIUQPyKNjBVP1gYMRDHzvaj3aVkJA4ZEoyA1V24yY/Wk3nxe+IcfcZSIOxM6bLNCl3ltDLM9Q/IRG1uW/5VYCNdRvnk6lrYDEa1ygDVVJsCXBSHsx57gAKI1ZQgQpaVzcB4QW/6osGd1LSsZR49C0af7CmjiQC1QldjaMCUjUjg4CGqwjEP48mxhRBRo6Rsv60VvKFJMg7ajoy9UZj2yS0Xs9aqkrvu2wCkf7XvoKEqsQK/iOv5HKMMq+T9X+0diAYUV/6UNRxtJEsrmJt+13sSCvCoJ4SFrButjFuQhpdTY/ySpW2x/DKsrfSBaleYxeAmdfFiN8qtcgtNka192Jfo0R1Ekjsf2BYSZfGeQU46+tN4iw7XZlG7SrIGBCC3vOsXNEPgtgUllYZm6+CqvMT07BnHImxuQ+8CuAMSK9G6jfs0X37/Oj/3nol0+GD3mwEgTPtT/srunhSyijEXy37Yb5WI+uMQUXEoOc6ipbLLo8kYtNzwCc1h7gFrLFeN2dvDh4n14sYt80YvgOCPuH3nKZASVZ8qc4+xAi+OLqg8ZjmSKCDwH66w/xVtigVaoUkxModUhFLbZVdJoLT7q4aTvsUaoH8OaP+Zxrbu2d+orxG54ovIN+fU7KXHjHGqab9BJhvfqEIOttGqxPU6R6eP5ol04R/deUtDwTVkan/XIKg6kR3eFU6yS/1pxAP2iZjIfwPo2FIpsw7/s+bPoklvwtbZ2ikPD6+a7KzK9o
 duI4Sjqd
 PK+KU+ik/jS30D27gQx11enL3BDZLiHv0FsUBytPZzCCYyHSrqDvi+lZfDsZsD2P+bVorerWXZuliA0vaQ3oAWk3HnABD87Mi1pT9KSrcFD/GAdEEpd4zDAwIRTAgPteWFnoS6G85gyyljszTWHhKX/k9zkfLUg1QKvp4ovtcIH8PeVJPOPVi/+vhE0QIdapFl7yMFe+XpPKkNAKx4AkE4vgC5DYVCgFYIZ5G7uBXlmlouA8vnUnanEJfdl/K/luaylkT/aiRlwUuIwxo1npY4GaDxFp/XyX5o9ziLQt9yQtapZVb3b3VK1OO8g6E8NffSJVMcv/2q7uraB/U4fRPYDzquTfQI79tFjE5GpC6oxTolm/KpdwRqHsPvbVaxBeMY5TSYWNLzfOFsLBmiR01xOZvbdb49RSVsHFA38JPRc32ouahch2MjAUA8dhdsJs8JwhsIPdA1FcpO6btIrn613u+VSg3rek7EMFz82ZjZ/ePGT7WP08GdPkOO9cQzcm5ICEpwOgy7dxsTMCyaC2m4sgPJhOSirkjhIgkkYFNY821Y3/7KcrObILSyh1mO65bLVzA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Kuniyuki Iwashima <kuniyu@google.com> writes:
>
> +#ifndef MODULE
> +static void __kmem_cache_double_free_rcu(struct kunit *test, int mode)
> +{
> +	struct kasan_rcu_info *p, *victim = NULL, **objs;
> +	struct kmem_cache *cache;
> +	int i, n = 0;
> +
> +	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
> +
> +	cache = kmem_cache_create("test_cache", sizeof(*p), 0, SLAB_NO_MERGE,
> +				  NULL);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
> +
> +	if (!cache->sheaf_capacity) {
> +		kmem_cache_destroy(cache);
> +		kunit_skip(test, "Test requires sheaves");
> +	}
> +
> +	objs = kunit_kcalloc(test, cache->sheaf_capacity * 2, sizeof(*objs),
> +			     GFP_KERNEL);
> +	if (!objs) {
> +		kunit_err(test, "Allocation failed: %s\n", __func__);
> +		goto out;
> +	}
> +
> +	p = kmem_cache_alloc(cache, GFP_KERNEL);
> +	if (!p) {
> +		kunit_err(test, "Allocation failed: %s\n", __func__);
> +		goto out;
> +	}
> +
> +	switch (mode) {
> +	case 1:
> +		kmem_cache_free(cache, p);
> +		/* p is already in quarantine. */
> +		KUNIT_EXPECT_KASAN_FAIL(test, kfree_rcu(p, rcu));
> +		break;
> +	case 2:
> +		/* The actual free order is inverse. */
> +		kfree_rcu(p, rcu);
> +		KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_free(cache, p));
> +		break;
> +	case 3:
> +		migrate_disable();

Shouldn't this be before allocation? If task migrates to another NUMA,
the test would fail
because kfree_rcu_sheaf() declines objects from foreign NUMA:

mm/slab_common.c:kfree_rcu_sheaf() {
    ...
        if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
                return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);

        return false;
}


Also the tests fail with CONFIG_PREEMPT_RT=y (causing use after free
reports and all sorts of warnings)
for similar reason, in PREEMPT_RT=y case kfree_rcu_sheaf() skipped:

void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr)
{
...
	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))


[    1.552763]     ok 37 kmem_cache_double_free
[    1.553617]     # kmem_cache_double_free_rcu_1: EXPECTATION FAILED
at mm/kasan/kasan_test_c.c:1109
                   KASAN failure expected in "kfree_rcu(p, rcu)", but
none occurred
[    1.606445] ==================================================================
[    1.606446] BUG: KASAN: slab-use-after-free in
__kmem_cache_double_free_rcu+0x111a/0x1280
[    1.606452] Read of size 4 at addr ffff88800da67b10 by task
kunit_try_catch/203
....

