Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EFA5F99C70
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 01:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581456B0167; Fri, 17 Apr 2026 21:35:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50B4D6B0168; Fri, 17 Apr 2026 21:35:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3B26B0169; Fri, 17 Apr 2026 21:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 274A06B0167
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:35:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A760F1A0326
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:35:08 +0000 (UTC)
X-FDA: 84669958296.18.5BBE01F
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id F1200140008
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:35:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776476105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fNqDeF+uYzWhsmjY6GczDy6N8Lr4vc10S4j9OADHR0U=;
	b=uHI7YNQhzhhIvswT4rm90vEZBPE67FqzpG5esDN+5+00JhgLIcA9hN+c5loNifZLIK9mcM
	zsICmDHV4TzsOSaPhLW7ttBdERYzCxH8mUyt/+MgUXMiwa5ML2xzjg/2UrhiVrnsEK7QdN
	Wvk3nFrPlYBbkyCE0BZUgvlNeFjm58U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776476105; a=rsa-sha256;
	cv=none;
	b=0sEO6tbohNpebOH8RxLB1IHXTU44QiG4/SbDnTTu1csWS6r6o/mggtgyMERJ/62A+E6C3y
	Ny7kxfFokEjPU8YJsEDqNRoGQm1ueg2YHigX/5vk8NbtFN9xz4CVWaCysSY7fcv7VH7etw
	s1i0wZLzcLQG08egNp77gZ4FperxEkk=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fyDnv3D3Sz5BNS0;
	Sat, 18 Apr 2026 09:34:59 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 63I1YtTI060502;
	Sat, 18 Apr 2026 09:34:55 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 18 Apr 2026 09:34:56 +0800 (CST)
X-Zmail-TransId: 2afa69e2dfc0111-b8716
X-Mailer: Zmail v1.0
Message-ID: <20260418093456750c2QBPL6Dyx_Oe_QUCJlf8@zte.com.cn>
In-Reply-To: <f8171c41-3e42-4268-9717-9b07cc931f4d@kernel.org>
References: 20260415165255601BBSSoil3iPkco33RXFtU2@zte.com.cn,f8171c41-3e42-4268-9717-9b07cc931f4d@kernel.org
Date: Sat, 18 Apr 2026 09:34:56 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>
Cc: <harry@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <xu.xin16@zte.com.cn>,
        <yang.tao172@zte.com.cn>, <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2N10gbW0vc2x1YjogZGVmZXIgZnJlZWxpc3QgY29uc3RydWN0aW9uIHVudGlsIGFmdGVyIGJ1bGsgYWxsb2NhdGlvbiBmcm9tIGEgbmV3IHNsYWI=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 63I1YtTI060502
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Sat, 18 Apr 2026 09:34:59 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69E2DFC3.000/4fyDnv3D3Sz5BNS0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F1200140008
X-Stat-Signature: uidusa5bp7t1rdp11fon4754htunaxut
X-Rspam-User: 
X-HE-Tag: 1776476104-882555
X-HE-Meta: U2FsdGVkX1+yYJ8/924jiZaE7ahF0HFjBeMsap1AchOUwupL7aPuJN1jDoB9fVxda8Zeor1It3CLRSCgbGOwiYRzbNVvOfgMgXg/uQzAVZo1DYg8IFt+TZpXW4aSWq19A6YrcE6iAfYibAnvBDP0GkqkOR8Y96ZHJeYxqThDYV6QEIps1+C9SbRXZHqhw0x4VcG3yM+g6lS8CvV46hxawZYPecLJJNg5H/G9tivf0v0rp4HR/aykxdSzkZBUh45LFpDLpk8i5SS3NGO6P0l24ZHf8QIxnZzgzvuEejjmoluFSeIETz7MkEi8GJv0BwVvP40DPmfWAAr4CnkLpQTULkAzJU5YyA+0enFh1i26tDi3VljWSbcjzwRk69YCWEMu4xev5KiLO+wbksmN9B5xIbVhLG5WrEvmBAyT/rwNdXBXz8SXAW6mGOdiVhdi+Tk0qolwVFkhDbSj5Nw+dslqA69PQOcbJOQ6dfUMS8eD57F6O53nc58uzEnnbANFLMSNXbZ//OCYjfnyO2F3+/ri07tIser8/4Js7qotEHrTOQk0QvNXJffjFBkJx+c3NZL+Wb2b2/E0E7YjBYe+OwJT2BSdk1i7Nrm3CzOzMSnV/Clylua2hGKKNWLdbMr7/fe2FXJ2rRq9JLjg4dnngR6kNhrO2TklyNYviqwVinWc/Mj++ve1DV1F57HV5y/Nyvc/f+ynCbfo4TXOM9dfb2IQrfJjhniFRhr1A4XPuhYC6spD+FdkZGGTfl1Yy7D/te7s45Esp3IxdmvKuPKYoou9EJFKoKzHqU9JD4+LSZrfRNNjAA/Gzkgx+uf/e45NPtGMAhGS7Ygcj6/gBMcttiZZckvqGf76AGfUuygIM70MPvCTva/ak8Gsawd5JgX8IRIMcZyBhtJnm4MLDmvoHed6MN6FIzhRezOA3AK2vVycKzs9XTAvVPA3VpLtV16srWlREhPkG8Mh0Ts4/4GrY7L
 pQFTS/Dn
 ibE1ImC+WVzeRekM+HofaJmWvaAGjwqLKluu87kX97WPCpfUjeGS53t3axvBnirQ2CYTmW3cw08GFAC3VjsR/VKcDvIhnxQCfy70r1cs8HZjjKvFPRWfWBVmrl3Jk4QRlCQ8Jz8JG7vZFZdKtZ8TPV+3Mej7kdG4ybv5/0VlYh1l5h8J5QXTC1BPeJzSqvq8K51LVQ1ecJIbVZG+v53OZgxB/K5Lw6s1+Abf99t0S5xSlm9vKRoffxn1rWBVW9gqA1570P/Z5WGYetwUtwAk1ReTtOsHWVZSz70zus85/Z5dOb7I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vlastimil wrote:
> On 4/15/26 10:52, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > Allocations from a fresh slab can consume all of its objects, and the
> > freelist built during slab allocation is discarded immediately as a result.
> > 
> > Instead of special-casing the whole-slab bulk refill case, defer freelist
> > construction until after objects are emitted from a fresh slab.
> > new_slab() now only allocates the slab and initializes its metadata.
> > refill_objects() then obtains a fresh slab and lets alloc_from_new_slab()
> > emit objects directly, building a freelist only for the objects left
> > unallocated; the same change is applied to alloc_single_from_new_slab().
> > 
> > To keep CONFIG_SLAB_FREELIST_RANDOM=y/n on the same path, introduce a
> > small iterator abstraction for walking free objects in allocation order.
> > The iterator is used both for filling the sheaf and for building the
> > freelist of the remaining objects.
> > 
> > Also mark setup_object() inline. After this optimization, the compiler no
> > longer consistently inlines this helper in the hot path, which can hurt
> > performance. Explicitly marking it inline restores the expected code
> > generation.
> > 
> > This reduces per-object overhead when allocating from a fresh slab.
> > The most direct benefit is in the paths that allocate objects first and
> > only build a freelist for the remainder afterward: bulk allocation from
> > a new slab in refill_objects(), single-object allocation from a new slab
> > in ___slab_alloc(), and the corresponding early-boot paths that now use
> > the same deferred-freelist scheme. Since refill_objects() is also used to
> > refill sheaves, the optimization is not limited to the small set of
> > kmem_cache_alloc_bulk()/kmem_cache_free_bulk() users; regular allocation
> > workloads may benefit as well when they refill from a fresh slab.
> > 
> > In slub_bulk_bench, the time per object drops by about 32% to 70% with
> > CONFIG_SLAB_FREELIST_RANDOM=n, and by about 58% to 70% with
> > CONFIG_SLAB_FREELIST_RANDOM=y. This benchmark is intended to isolate the
> > cost removed by this change: each iteration allocates exactly
> > slab->objects from a fresh slab. That makes it a near best-case scenario
> > for deferred freelist construction, because the old path still built a
> > full freelist even when no objects remained, while the new path avoids
> > that work. Realistic workloads may see smaller end-to-end gains depending
> > on how often allocations reach this fresh-slab refill path.
> > 
> > Benchmark results (slub_bulk_bench):
> > Machine: qemu-system-x86 -m 1024M -smp 8 -enable-kvm -cpu host
> > Kernel: Linux 7.0.0-rc7-next-20260407
> > Config: x86_64_defconfig
> > Cpu: 0
> > Rounds: 20
> > Total: 256MB
> > 
> > - CONFIG_SLAB_FREELIST_RANDOM=n -
> > 
> > obj_size=16, batch=256:
> > before: 4.85 +- 0.08 ns/object
> > after: 3.30 +- 0.20 ns/object
> > delta: -31.9%
> > 
> > obj_size=32, batch=128:
> > before: 6.89 +- 0.07 ns/object
> > after: 3.74 +- 0.06 ns/object
> > delta: -45.7%
> > 
> > obj_size=64, batch=64:
> > before: 10.70 +- 0.17 ns/object
> > after: 4.60 +- 0.12 ns/object
> > delta: -57.0%
> > 
> > obj_size=128, batch=32:
> > before: 18.69 +- 0.26 ns/object
> > after: 6.54 +- 1.30 ns/object
> > delta: -65.0%
> > 
> > obj_size=256, batch=32:
> > before: 22.36 +- 0.24 ns/object
> > after: 6.61 +- 0.09 ns/object
> > delta: -70.5%
> > 
> > obj_size=512, batch=32:
> > before: 20.59 +- 0.36 ns/object
> > after: 6.90 +- 0.15 ns/object
> > delta: -66.5%
> > 
> > - CONFIG_SLAB_FREELIST_RANDOM=y -
> > 
> > obj_size=16, batch=256:
> > before: 8.77 +- 0.11 ns/object
> > after: 3.63 +- 0.09 ns/object
> > delta: -58.6%
> > 
> > obj_size=32, batch=128:
> > before: 11.59 +- 0.31 ns/object
> > after: 4.24 +- 0.12 ns/object
> > delta: -63.4%
> > 
> > obj_size=64, batch=64:
> > before: 15.58 +- 0.51 ns/object
> > after: 5.32 +- 0.11 ns/object
> > delta: -65.9%
> > 
> > obj_size=128, batch=32:
> > before: 22.13 +- 0.63 ns/object
> > after: 7.39 +- 0.20 ns/object
> > delta: -66.6%
> > 
> > obj_size=256, batch=32:
> > before: 27.12 +- 0.74 ns/object
> > after: 7.92 +- 0.08 ns/object
> > delta: -70.8%
> > 
> > obj_size=512, batch=32:
> > before: 26.92 +- 0.32 ns/object
> > after: 8.28 +- 0.26 ns/object
> > delta: -69.2%
> > 
> > Link: https://github.com/HSM6236/slub_bulk_test.git
> > Suggested-by: Harry Yoo (Oracle) <harry@kernel.org>
> > Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> > Reviewed-by: Hao Li <hao.li@linux.dev>
> > Tested-by: Hao Li <hao.li@linux.dev>
> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Thanks, LGTM. Will pick up to slab/for-next after 7.1-rc1 is released.

Hi Vlastimil,

Thanks for your ACK. Have a great day!

--
With Best Regards,
Shengming

