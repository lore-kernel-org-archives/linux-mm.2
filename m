Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 244A3606A336
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ExQo3HzN
Received: by kanga.kvack.org (Postfix)
	id 4447D6B05B1; Thu,  5 Nov 2026 08:03:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41A6F6B05B6; Thu,  5 Nov 2026 08:03:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331EB6B05B7; Thu,  5 Nov 2026 08:03:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1856B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:03:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31E4C1A0A4C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:03:30 +0000 (UTC)
X-FDA: 85401081780.19.C47914F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7B433A0011
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:03:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ExQo3HzN;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793883808;
	b=VT/pSRd6XE/nfLUUWS0XWK2Tu9a8b1BdcjaaEXs5qSwzAyDkH8OCpONCJSnmzPFyF1h9Rd
	GZnRUPYyOOwci+QHL0+eniHVkYjAPPDM9O1bGqu2t1q+PF5HoA8B0SuuiV30Mpst1bmYUw
	aiNLjEIEpIfsAvxqB/2oVq/9DUAg+ww=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ExQo3HzN;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793883808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNXx8S4y6VN9U7HOm9Ke4cFt+Qb/QdLtRtSH9O/lE0U=;
	b=Xq2AkJT/KSnvaLygDxZsC2tcpkZrNiY5zdA0YOw20eIEKPRkD+1x2P6xo2hIQxvm140R5Q
	RZh8AcmF8YUDsnrEcBTfpu+9i41jAc6yxBnY40EeM28Wdgp5pGMhWzYQQ/TdI1m2e45pTC
	8K0LLrfzDgTlUGwXfWGkVkj0KrQS7TI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A90734228B;
	Thu,  5 Nov 2026 13:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABB61F00919;
	Thu,  5 Nov 2026 13:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883807;
	bh=kNXx8S4y6VN9U7HOm9Ke4cFt+Qb/QdLtRtSH9O/lE0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ExQo3HzNLjxDCE92I8tmckWktjbnm4JOIWhThBMgpqdJ1IPaROCC6x0wiCQ5AD1U+
	 dsGCfi5GW98YeS2Wb2zNIBC2BUhIotnN6ckC68vZpyAPCkMz6/DaLOkmG5cZmto8JZ
	 yPt1EzTEnytIhkDaAU2sSsMJEx2VqVVMCu88vX8/zhqBx/2tbiVAV9YCv1fFrJQYXa
	 Dia9T4lLSV9M15ZwV79R6vMcMfQzW6YRd/veUPh13xyuQ0mazmuWclPU5CZgdkE02W
	 QsVM7HYv2Lt3/XR7PyAGrUMmCGFZQclICdvmzG6t/q5573AD5KTJVt41aLz5/fxxpd
	 G0GswnDFfaGhw==
Date: Thu, 5 Nov 2026 13:03:25 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Conor Dooley <conor@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 02/10] kasan, kunit: pin test slabs by an extra
 allocation
Message-ID: <aux-POg69ZJ_4keC@thinkstation>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
 <20261105-slub_tiny_rework-v3-2-0484ce59eabb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-slub_tiny_rework-v3-2-0484ce59eabb@kernel.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7B433A0011
X-Stat-Signature: 8xwcr9w7npi4sfyncs963fwbmk9j3316
X-Rspam-User: 
X-HE-Tag: 1793883808-356244
X-HE-Meta: U2FsdGVkX19gxv1vcg2VrPiSlhaBSU8L+G4WljsEJ1JA9kEN8SfmDGOcpyfGs2e3Ei8Sl7D34u1dR0YptKXQUoIzv+c7yO67gMuD4CWMNtSUVILqj8S1DKtIkYplKI7A1Tefl6vQ24dVehVsAaKkdQl/Xugix0Ebwp+jnXEAz7oNxM1GWfa9KLa4zL5oP34FsXUU7893qrY+4F2g7zL4itoe2dEclqR8B6wlc3AEfVA6OgaPPG7Lvlellw2iARQ71gghAm1VPBmlSTEw0dTcaUDy8nfXbYsdygdII0swU9Os2GeUU5kH9cT0oKWTFxZeaOqKkxbIA0sl7f9bHpy7MJ3H+PBn3IQWYPbTEvi7DhWOBz8hzHTLwdxAmgTQRShOjVHUf5cm7KgmFbJQfxrmviEG3H1j53RDGmJx3THe1QvJOLS2kSAdbtAUKjrZm+ETK7sF63L/1Bjm0lgdm+OccI48vVBhM4yNjgqfRjkAqdTMrEzJGHnacj/X52RFcwLhcYrPOFYWJDFUgCggYFA9Kvv6RhlxOgCV3T6+v7S2kYWBO/BiW3yqcxEq67sbiTAooBK3J6mwqyRL68aDFn1hxrj3VQz7wGjYzSBMTOlM9P+U7tP7Rc7p/ctJPboScEYDlYOcvLObDe4VqKfOWn3XKHEud6/bqQHxXj5Qq1MMJv5ZOscm55jGgvQeyYO5xCK9S+CWGsr4GQorwtxM5IwZrPmGFfKwcoYxlzcZ8lhLceMxCGg7wiWvB5ycaQ2gPgaoxRxbv2VOV+8b9tO/VpIutLqKBNkxCUAs88/k7co6aP2cLQzWDU5asUHBSKJp4w8zI00sUg8Z5fQs/nHf/L2tKR42HZ6pQS7fhyYf92vGv8/WOvj7slvYhcU6AP3coDPGRx6MxETg1l86OOvcibJa48DNBjdI+u8lfnNQgozaJYKBDPPCunzenl1qHf8tUhhPCI03fQ1KJOx5HHm8vsa
 ORXA86aN
 dVuxU/AnNIVIAAf8hMRLZo617WUz3HcGphUYKPmiJnPJw4I7RLr6jcgCgxD2qB2W4jEey8ywWcK7hQe4XZb224qwiQbWlWGkZbIEsErrfFnykWqmPoUnk2PXsUZyM+A87ioSq+QUY+9LiHTaC0gaQD41ZcKmEkUb0pf4SLVsVZ8cff9ASYRvCnxZnUErT/ic7CQt++9EuNkXe9NaxEiGoD32hvEWpQjXmk6EsuBCvju7V2cphc6YaXzSJjpXKSh4v4ciaXex0zYMX3X2fP4oxxW4NEFdG8USFNvitxWickTOEz1T7MtKmTrzkCQxH8lk+yU1LQsyUpRZ5i439laedWUYyZIbSGAju6vamHqwIxZTandjHv58emr6vOcykpufRBItG5E4eoMfws/Mi6rQiaiT4R04GdKoOiwgV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 09:43:51AM +0100, Vlastimil Babka (SUSE) wrote:
> The tests kmem_cache_double_free() and kmem_cache_rcu_reuse() create a
> scenario where a slab becomes empty, but rely on the implementation not
> immediately freeing it.
> 
> This subtly relies on non-zero s->min_partial. It currently compile-time
> defaults to a non-zero value, but in theory a sysfs write racing with
> the kunit test could change it. More importantly, the upcoming
> CONFIG_SLUB_TINY changes will make it possible to run the kunit tests
> with s->min_partial being a compile-time zero, which means the tests can
> cause a NULL pointer dereference, or fail, respectively, as flagged by
> sashiko [1].
> 
> To prevent this in a robust way, add an extra object allocation to the
> tests, that will prevent the slab being freed. Use migrate_disable() to
> prevent migration to a different NUMA node, which would place the
> allocation to a different slab. kmem_cache_rcu_reuse() already uses
> that.
> 
> [1] https://sashiko.dev/#/patchset/20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org?part=8
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/kasan/kasan_test_c.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index b9e167ed5be3..580a9bf007ec 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c
> @@ -1152,7 +1160,7 @@ static void kmem_cache_rcu_uaf(struct kunit *test)
>   */
>  static void kmem_cache_rcu_reuse(struct kunit *test)
>  {
> -	char *p, *p2;
> +	char *p, *p2, *pin;
>  	struct kmem_cache *cache;
>  
>  	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_SLUB_RCU_DEBUG);
> @@ -1162,6 +1170,12 @@ static void kmem_cache_rcu_reuse(struct kunit *test)
>  	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
>  
>  	migrate_disable();
> +	pin = kmem_cache_alloc(cache, GFP_KERNEL);
> +	if (!pin) {
> +		kunit_err(test, "Allocation failed: %s\n", __func__);
> +		goto destroy;

destroy path doesn't re-enable migration?
otherwise LGTM.

> +	}
> +
>  	p = kmem_cache_alloc(cache, GFP_KERNEL);
>  	if (!p) {
>  		kunit_err(test, "Allocation failed: %s\n", __func__);
> @@ -1178,8 +1192,12 @@ static void kmem_cache_rcu_reuse(struct kunit *test)
>  
>  	kmem_cache_free(cache, p2);
>  
> +
>  out:
>  	migrate_enable();
> +	kmem_cache_free(cache, pin);
> +
> +destroy:
>  	kmem_cache_destroy(cache);
>  }

-- 
Cheers,
Harry / Hyeonggon

