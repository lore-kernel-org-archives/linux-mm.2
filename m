Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2294606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 19:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=V02YYaL7
Received: by kanga.kvack.org (Postfix)
	id 0B1B26B05B2; Wed, 28 Oct 2026 15:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063656B05B3; Wed, 28 Oct 2026 15:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBA816B05B4; Wed, 28 Oct 2026 15:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1CFF6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:25:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB401140274
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:24:59 +0000 (UTC)
X-FDA: 85373012718.16.E598F71
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf28.hostedemail.com (Postfix) with ESMTP id 41C94C0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:24:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=V02YYaL7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3CEziagYKCIcv5yt95rzzrwp.nzxwty58-xxv6lnv.z2r@flex--kuniyu.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3CEziagYKCIcv5yt95rzzrwp.nzxwty58-xxv6lnv.z2r@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793215498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8MwmfyPBU1rbQlzIAgGtEolB4rOOeIE0Utyj1UFyXuA=;
	b=iiMQYct9JaoxbmQIDMj23w62Ajw34eSyyIR5doo0hJO48pB+yJ0zBLC+Pe6NgICka3oQLf
	DQ67Dnwvoc+YU0B+LzRNs04JaYOmLmq9ZpFs6n6xoxTwejRxVm6ib10RyxuHm0L92/p2RE
	rIfbTH/eWZiFiaIQEW2pgTwUCFjz/s4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=V02YYaL7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3CEziagYKCIcv5yt95rzzrwp.nzxwty58-xxv6lnv.z2r@flex--kuniyu.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3CEziagYKCIcv5yt95rzzrwp.nzxwty58-xxv6lnv.z2r@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793215498;
	b=H4GHOYhJwh3d2W8tJW5y634cI3SZyH+rb5WOQ+JOHihCXW298brZ2PyB6K6l775izUhaBH
	2/Co6QLkBtTpRbUSacvrvWN2p/jhpDLitLitiUBCbcQotDQGYkj7E8R9oEmgg/iS+PDxzv
	QSTqWCtfeEjRXLMT+18gXW7EyjxzEDg=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ab2cb8d5dbso1184933a91.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793215497; x=1793820297; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8MwmfyPBU1rbQlzIAgGtEolB4rOOeIE0Utyj1UFyXuA=;
        b=V02YYaL7Zn+onxlL0F/iPBDSVB77R4/eeu8sWy2kMCeiAHfJxUCvSnw59kQdgGaS2G
         N3BSYAd1Uz4CFMsB/mdX/mJJSywWP+rICvp0nherhJLUmE5wv61mrDJufh2AJh2Vo0Av
         axj8eLQha9EWi1M2OljkTSqNwVak0wQYq3W5SkchsYz0BFtd7vf1uZJ2+EZ7fDocb6G5
         8HY1vJLADJw9XOTw2yUu63C5Fn0JrF/e4PPbpbeE5kFUWwR3WyylBVfqHeF3x5fIVCOm
         RReSGNV9PlGS8RtR3lI6yaBv/neHL5uIbEekoxbITAh73ZvW/7ZhJlj9jaYmL58Bd9w9
         EtVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793215497; x=1793820297;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8MwmfyPBU1rbQlzIAgGtEolB4rOOeIE0Utyj1UFyXuA=;
        b=xwRH8C2e3JCW7D6dkQPTIukERj+mfVFmf3iARMw/PCXd8gsWy62SOovcsMNhjdpai+
         L7djNt/tYgUzYu/u/ljgq8j1WxkcBTIfqsjoy7NZdraiHE7kYNDlDw0i7gENXBfxpaXc
         gfOayv8hJuSIdH4zNGaIrbqpUCGQa9dfcUe0WDyfOAjrItYFldhWeu9UPXGJhuG38Ld+
         9Pg9wQOBFvvevW8+D8/EqzpFxZfjlLJZTnLPh5/r7SzSEWsqzT49KuRoUakYK+nOFJls
         TcsZ/CDtJwf73Oy/Ydjy7wlKvju9xml+9nbyLwEhklA2JaW9poc0siUVPvvdEfE73ScF
         JxiQ==
X-Forwarded-Encrypted: i=1; AKwUvBwLbhWEQdU7EUmYHJwZEjgMX3fH9FTJWCldGT9JVGJFN/6XrMILWckoQdDFZU6XIj8EKQQgF9F5NQ==@kvack.org
X-Gm-Message-State: AFq9FYKhAU0sJIEGEy4f0ZaSbxn45Flx+ato0xyBLQkXIcn7T++qn31V
	Fup+F9TJ6WRYulAHCynbGTWA5rZ3jO4txnSLY3pOAOJ1pEfcaNeZcQum/Hu6wKvqMd5pUq3H4er
	rBaeArQ==
X-Received: from pgjf15.prod.google.com ([2002:a63:dc4f:0:b0:cda:d337:9b7a])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:58cf:b0:3a7:cffb:8b96
 with SMTP id 98e67ed59e1d1-3ae58171017mr2499575a91.18.1793215496879; Wed, 28
 Oct 2026 12:24:56 -0700 (PDT)
Date: Wed, 28 Oct 2026 19:24:56 +0000
In-Reply-To: <CAPAsAGzK9tySui7+LBTrtONJBdXu1FUXo15S+_EZCtm-Qsccnw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027222557.1072105-1-kuniyu@google.com> <20261027222557.1072105-3-kuniyu@google.com>
 <CAPAsAGzK9tySui7+LBTrtONJBdXu1FUXo15S+_EZCtm-Qsccnw@mail.gmail.com>
Message-ID: <auJLSzXifYWVRISI@google.com>
Subject: Re: [PATCH v2 2/2] mm/kasan/kunit: Add double-free tests involving kfree_rcu_sheaf().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 41C94C0002
X-Stat-Signature: zsoyh4pa1a6w8xm4thi4qw8bmb6s5e8i
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793215498-474594
X-HE-Meta: U2FsdGVkX1+hOcA+5u8MIdOTqjaFPn6kl+B15/PeSLClNQMdwAA1bPxtgY0TBmXolgwu/cxCYznD2RRWtvFtis3Rz94lYJCi9CJf7BcNza0u/ct8Qz5vQ8ji/H/YFATHwnXM5sR7GAujxGQortXRGm8ccFWoe8+YlgmhXuCGyblkdRM+9MYFEOMRbjyUKz+dMYDODUophUqcqdJK70cXC8SuLpVuKvxuY9905mraQiOZMO6W12pd2fIQ+j781n6nXSQl0FoIKBEZ+rTFECsUXkisfJkT9DTXRT9vvXjvU17nB0z1PfIlxi99inm/ViHcq72QlfCBXAERGfDQwgasnBycnNnXUwiLYpXr9eHJ0YaAnri5U+9i9mPFb2xdpyCbqnZUbwPrTOhKLjckeqOlgbCVchFuymPXIPhstOrNMv0zLOsjYXz11gk+yohyLMyQWDXru8ElsAc0xaqorMvE14hwsDfFzjQap7dVYhT3rTMg+Zl8VkVg3CA1CwKTXZj9raY7jqOk6CeMokz/thU45736PoPcdvefU8FSIKSQUdzXhAgQaX8sbUO605mCeVhH7xazbxa0Pjj7EG16N/LAI7p4j9/OdKDUFPW1+T9rVVaGzzeRmrDQ72u526nRaMglSMe2kE0bpNNtXq/+4Md2S1H1ixO1Wab68IsiNQ1EydC7whnny1RzDER+JLIzh+PAqMSzkAcyx2CZmaof4FvO4tedKjtqA5/S939iGVrYJHpJEeIfCigNKm2v5x/oMqqEGcsr9rW7Aryt7h9u6LfS95fPfsVUx1MsSoSP/ycczm4xuAZPeEuaSGQPAEb7W+YUQy4jv3KddI7+/Wxq5uNYZ5UXBA+xSX+uWMEO/rRDXMYAVR3w9kp8w4fRx2eikgDJIeIO0oq34kV98ysoEVJ5TijZod8kifXeZJAIcIFRkd349NiephU+J6XF+i8uOfvGFNDIwPQ/md/prXqcO/v
 IStjPnRb
 Ed7eRKECOGj5fANZqiKKAgmhRQThQ+Szis+mOgCG/sq2BFzP8NX9UZDssjBU80wc/XCwCqu69C2nALXMd8VDa//fmrgCWBv+4gzotsgYanjMtkeftQls9it8oijXbmA8s/x/R/4OA0NxH0X/G69+sRcmLIfRyyucbroHS0C85oSdq7UlvZ8kBD4s5S9qtkh6Tv5Mu0uukEJrW/m8UsJRUkVV5z70kl+hHemXssMd1HvrEQpmxfxfX6HU2h9/CSbrFqMV9CY68SwQF8BaJzonCuhpv5eJlMYrXcb3F68K+WjhFCUeX88h1gwAJ9YYqmhIwI7BiKzVY41jcs6UoJnzT3sGYHhVVFhqVbn/S6Z6NumEwNuKxshILwl4FtO2BirwvjjFGU1paHBMhWLTUwxTBVu8wUzq6htDiVwaIn5O+o4jh6AQnjR5ALVmdi2Bku3XyvGd2chPkN2mz/fJsrHH+c1iARgI/e6tm361CUsVw2w+JZwV+Qjd57hwO8IjoTpty9pVt9jHo6tI70KTNfEN70mfrJmXwC6u7X1ylYnKQkI4YLQUxEBD8qFQxgcMGgaXB0fUFE2lZazKNe+zZrbCIvqlYiwn4RFxHrIjRuav0M0Dqh95hu2rBgCIEAXkrdWm2kaWKdVN2Nx5QvXZ6ACeWiwQoEVnHhK2rRNaJi2S/gkW5mnTzTbTQR57zZoB/GtTX7q92gtRJKZtYKmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 12:10:23 -0700, Andrey Ryabinin wrote:
> Kuniyuki Iwashima <kuniyu@google.com> writes:
> >
> > +#ifndef MODULE
> > +static void __kmem_cache_double_free_rcu(struct kunit *test, int mode)
> > +{
> > +	struct kasan_rcu_info *p, *victim = NULL, **objs;
> > +	struct kmem_cache *cache;
> > +	int i, n = 0;
> > +
> > +	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
> > +
> > +	cache = kmem_cache_create("test_cache", sizeof(*p), 0, SLAB_NO_MERGE,
> > +				  NULL);
> > +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
> > +
> > +	if (!cache->sheaf_capacity) {
> > +		kmem_cache_destroy(cache);
> > +		kunit_skip(test, "Test requires sheaves");
> > +	}
> > +
> > +	objs = kunit_kcalloc(test, cache->sheaf_capacity * 2, sizeof(*objs),
> > +			     GFP_KERNEL);
> > +	if (!objs) {
> > +		kunit_err(test, "Allocation failed: %s\n", __func__);
> > +		goto out;
> > +	}
> > +
> > +	p = kmem_cache_alloc(cache, GFP_KERNEL);
> > +	if (!p) {
> > +		kunit_err(test, "Allocation failed: %s\n", __func__);
> > +		goto out;
> > +	}
> > +
> > +	switch (mode) {
> > +	case 1:
> > +		kmem_cache_free(cache, p);
> > +		/* p is already in quarantine. */
> > +		KUNIT_EXPECT_KASAN_FAIL(test, kfree_rcu(p, rcu));
> > +		break;
> > +	case 2:
> > +		/* The actual free order is inverse. */
> > +		kfree_rcu(p, rcu);
> > +		KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_free(cache, p));
> > +		break;
> > +	case 3:
> > +		migrate_disable();
> 
> Shouldn't this be before allocation? If task migrates to another NUMA,
> the test would fail
> because kfree_rcu_sheaf() declines objects from foreign NUMA:

Ah indeed, I'll squash this.

---8<---
@@ -1096,8 +1097,11 @@ static void __kmem_cache_double_free_rcu(struct kunit *test, int mode)
 		goto out;
 	}
 
+	migrate_disable();
+
 	p = kmem_cache_alloc(cache, GFP_KERNEL);
 	if (!p) {
+		migrate_enable();
 		kunit_err(test, "Allocation failed: %s\n", __func__);
 		goto out;
 	}
@@ -1107,14 +1111,15 @@ static void __kmem_cache_double_free_rcu(struct kunit *test, int mode)
 		kmem_cache_free(cache, p);
 		/* p is already in quarantine. */
 		KUNIT_EXPECT_KASAN_FAIL(test, kfree_rcu(p, rcu));
+		migrate_enable();
 		break;
 	case 2:
 		/* The actual free order is inverse. */
 		kfree_rcu(p, rcu);
 		KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_free(cache, p));
+		migrate_enable();
 		break;
 	case 3:
-		migrate_disable();
 		kfree_rcu(p, rcu);
 
 		for (i = 0; i < cache->sheaf_capacity - 1; i++) {
---8<---

> 
> mm/slab_common.c:kfree_rcu_sheaf() {
>     ...
>         if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
>                 return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);
> 
>         return false;
> }
> 
> 
> Also the tests fail with CONFIG_PREEMPT_RT=y (causing use after free
> reports and all sorts of warnings)
> for similar reason, in PREEMPT_RT=y case kfree_rcu_sheaf() skipped:

Exactly, I'll add this to v3.

---8<---
diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 83c418c0ef87..3c9ffee8001b 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -1079,6 +1079,7 @@ static void __kmem_cache_double_free_rcu(struct kunit *test, int mode)
 	int i, n = 0;
 
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_PREEMPT_RT);
 
 	cache = kmem_cache_create("test_cache", sizeof(*p), 0, SLAB_NO_MERGE,
 				  NULL);
---8<---

Thank you !

