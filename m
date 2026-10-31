Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAFCF606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 04:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jWF3W+s/
Received: by kanga.kvack.org (Postfix)
	id F303F6B00EF; Sat, 31 Oct 2026 00:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDABC6B05B5; Sat, 31 Oct 2026 00:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC91F6B05B6; Sat, 31 Oct 2026 00:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5CBA6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:22:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2CF7CA043C
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:22:26 +0000 (UTC)
X-FDA: 85381624692.02.63F06DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 931BC80007
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:22:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jWF3W+s/";
	spf=pass (imf30.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793420544;
	b=6m2scoyb8i+bC4HLnAQJP6SY8Am+b0i4Q2hvpwx2dUzQxIcxxCpGfh0JWpPvKoxO9muwXq
	IH7UUak7dgkMcPdGUAbJn/kfo3ShPT8s3tv7Dgr4bkpPAO3Fnv7EfhRqKc9t+zJzA2a7LJ
	HdOpx1OUPhQkBB6R/0eHGtwAl4QaRBM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jWF3W+s/";
	spf=pass (imf30.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793420544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2R0GYd790JXnb4Y8ot5FR6nSs52IU/ungvwEsnVbrT8=;
	b=iG5R+0BYpuoC4i8oo+Ry/HyNWVJMpMvV2znbgd/um8XQXDBjce5t6wVJfU3nrKsYJC7d7Q
	SIBgSp4AfvfVhBbvmz3oPOUNWhlVBv7syP27UJi5pVIPPRMAghoA4ZcVNJ44tvEMHuC1mP
	E9EjF7Ygdwo74oI/YkS8H21Es3G5DPc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 259F8600AA;
	Sat, 31 Oct 2026 04:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9151F000C1;
	Sat, 31 Oct 2026 04:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793420543;
	bh=2R0GYd790JXnb4Y8ot5FR6nSs52IU/ungvwEsnVbrT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jWF3W+s/1UqGh8FCgl+GBRs8Op4RxqFJ9/kFjrGf9PWl7ayKREc36HjsyAtHZEz4x
	 0LxCRfFC8ByNO0yTT0jQgUSuGxBle5jQFmEVaNgleN+8YvQJLNes7EKCkLclRIEkOt
	 0wJLrEQlMiMM6jyXLaLH7JJ44A5kvcJTf3HdXtM0TUBROwL8w2wn8CiP+pW9kk3fW1
	 cnmjcFUwMZaTHcyLBZNef8J9HTpPAEKn1Xf/9ffMR6VSBg8e9N0KO+GpM693LJkNvt
	 yhHZj8ZHJOUdw4u1fzf0XMFjtIC7zXWzBmLDKOBDSWXVur00pMF2pYEBAhmf7cIhC5
	 4DoEM4I5L3LZA==
Date: Fri, 30 Oct 2026 21:22:23 -0700
From: Kees Cook <kees@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 4/6] slub_kunit: Add a test for the slab_buckets boot
 parameter
Message-ID: <202610302117.74D1EB1@keescook>
References: <cover.1793253633.git.chris@chrisdown.name>
 <47c0b11109203640122a9b5b030d3f41bfbac609.1793253633.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47c0b11109203640122a9b5b030d3f41bfbac609.1793253633.git.chris@chrisdown.name>
X-Rspam-User: 
X-Rspamd-Queue-Id: 931BC80007
X-Stat-Signature: jk1mkyu8wxmd7b588mz4xt4atoq4se6z
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793420544-103964
X-HE-Meta: U2FsdGVkX1/3+u+jfDlek6QyKb8uYoobB7RyXtcQKHJBC4CaRPZY8L1ThoVfys29QS0Mjby4mh6rnJ1zl/wnAdcAJBb1hj4z8bqFdXnpUSgVrSBHvXzDZlj4caks3oGk95YwtxWafu6MbcLjnixWVDaNinN/W42sF+2Gq7ug7XLLEW9rptXRH8nYd1rIPlxGhiUxEfccSF/ypbZiHLbcND3G9LGWkPL7rNsK1O6y3/lKAp40hesSxB+BYiEadXjH0XRoCbXJi9YyhJBIVNwvEHYSEfamTX7l6Ja0o75nilp1yRG4O2ozy2l/gQ9B1o0P7UwKlHvlL3vtuqQXUD3D8gg4dbzf0HYpZv1Z8IegLOiT9ZnZFXwm/Rn4dTxE0t1bdKCAAYRhgZ3XszzWUnqjvj5RwVILP/5Dll2H8aBzBOy5DE7lqswHMWLrdwiB+D7u+7RFRXppgGB6+30A/JK1CL8z1GbyfZ0jTeoNDFnP0gucwAbX3qlrc7HHVD3A1C5z9dQQTPwMVJPeOFnKDJ8vIUSQbd8R0t/8ckaPZrdorIRl1QbUE8AaWiYYnQE1IPazHiF9arBQOXqA15tCC1m3TBLeG78NtLwZ1JnL7dD7E2BMSZ27v1vfzgnFzvNgeMv94/qX0A1isRV0AZ2LkxvLDHljAQzhHAHhJhfNHgaEc2W/TUijkKn7HBFEAdZahe6rru5RutQb3oFSPwo9qXB0q3JN9Mb61NmTbhVSbtpOIoNzegOd8Ga8p9KvGsVTH7L79gKmwjdiEhcJmEkHpS7StKuT8U2iKG/kaVM9aknnolIkRH679X8IAixzA6S/Mph4Hoo8EFGdvBvBuY97+6hydLCn8ZRVLsx3fSdFI8sNVmebYUAw8OGeTfaR9GiE+cTR3ZFUNjpXyF0+MxGIEQkxlZMu1gRFIKDVCYmSH1nhZwOI53SiNQR7iqXT4UWr9s78+6XQzdsWhJcrGkQ1KyW
 hKb9Y65/
 av41bNApK1q3UAFc+ADGi1q3DdfQdCZ7V0BfybUjA6KAL1DFSdH6XKDEMUxE8HcsYswd0Ale7mLSPL2I5GyGzfdkIhuT9PBEqIfdXoebsOr3/jucUC2DHGJAWeq9XzRukNd6CDnHK6LXH93Yw0lHhTHq689J7I4umhPDvNJx2Cq+kG2IfYazN/kdsc3B7R3rRzwQliqriQ/WZ85XQ6VOc30hEfSDoGzIBKmaOgZFj/oBla8FlRTW5nANDr+9IdiXHoNLXqm8yFc+VSi8wUyj90XHt1PZZZTMwpLrufAY7Ct5Ky0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 02:08:44PM +0800, Chris Down wrote:
> Check that memdup_user() allocates from the memdup_user buckets by
> default, and from the regular kmalloc caches when they're turned off
> with slab_buckets=0.
> 
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  lib/tests/slub_kunit.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  mm/slab.h              |  4 ++++
>  mm/slab_common.c       |  4 +++-
>  3 files changed, 48 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
> index e3b63f0338d5..670645875b27 100644
> --- a/lib/tests/slub_kunit.c
> +++ b/lib/tests/slub_kunit.c
> @@ -9,6 +9,8 @@
>  #include <linux/delay.h>
>  #include <linux/perf_event.h>
>  #include <linux/kprobes.h>
> +#include <linux/mman.h>
> +#include <linux/string.h>
>  #include "../mm/slab.h"
>  
>  static struct kunit_resource resource;
> @@ -296,6 +298,41 @@ static void test_krealloc_redzone_zeroing(struct kunit *test)
>  	kmem_cache_destroy(s);
>  }
>  
> +#ifdef CONFIG_SLAB_BUCKETS

Please don't ifdef to drop a test. If you have to do any ifdef, use it
for test skipping instead.

> +static void test_slab_buckets(struct kunit *test)
> +{
> +	unsigned long user_addr;
> +	const char *name;
> +	void *p;
> +
> +	if (!slab_buckets_enabled)
> +		KUNIT_EXPECT_NULL(test, kmem_buckets_create("TestSlub_buckets",
> +							    0, 0, INT_MAX, NULL));
> +
> +	if (!IS_ENABLED(CONFIG_MMU))
> +		kunit_skip(test, "userspace allocation needs an MMU");
> +
> +	user_addr = kunit_vm_mmap(test, NULL, 0, PAGE_SIZE,
> +				  PROT_READ | PROT_WRITE,
> +				  MAP_ANONYMOUS | MAP_PRIVATE, 0);
> +	KUNIT_ASSERT_NE_MSG(test, user_addr, 0, "Could not create userspace mm");
> +	KUNIT_ASSERT_LT_MSG(test, user_addr, (unsigned long)TASK_SIZE,
> +			    "Failed to allocate user memory");
> +
> +	p = memdup_user((void __user *)user_addr, 64);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p);
> +
> +	name = virt_to_slab(p)->slab_cache->name;
> +	if (slab_buckets_enabled)
> +		KUNIT_EXPECT_TRUE_MSG(test, strstarts(name, "memdup_user-"),
> +				      "allocated from %s", name);
> +	else
> +		KUNIT_EXPECT_TRUE_MSG(test, strstarts(name, "kmalloc-"),
> +				      "allocated from %s", name);
> +	kfree(p);
> +}
> +#endif
> +
>  #if defined(CONFIG_PERF_EVENTS) || (defined(CONFIG_KPROBES) && defined(CONFIG_SMP))
>  #define NR_ITERATIONS 1000
>  #define NR_OBJECTS 1000
> @@ -489,6 +526,9 @@ static struct kunit_case test_cases[] = {
>  	KUNIT_CASE(test_kfree_rcu_wq_destroy),
>  	KUNIT_CASE(test_leak_destroy),
>  	KUNIT_CASE(test_krealloc_redzone_zeroing),
> +#ifdef CONFIG_SLAB_BUCKETS
> +	KUNIT_CASE(test_slab_buckets),
> +#endif
>  #ifdef CONFIG_PERF_EVENTS
>  	KUNIT_CASE_SLOW(test_kmalloc_nolock_and_friends_perf),
>  #endif
> @@ -505,5 +545,6 @@ static struct kunit_suite test_suite = {
>  };
>  kunit_test_suite(test_suite);
>  
> +MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
>  MODULE_DESCRIPTION("Kunit tests for slub allocator");
>  MODULE_LICENSE("GPL");
> diff --git a/mm/slab.h b/mm/slab.h
> index e94ac63d10dc..b5b344d6e402 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -390,6 +390,10 @@ extern struct list_head slab_caches;
>  /* The slab cache that manages slab cache information */
>  extern struct kmem_cache *kmem_cache;
>  
> +#if IS_ENABLED(CONFIG_KUNIT)
> +extern bool slab_buckets_enabled;
> +#endif

This feels messy. Any reason not to just export it entirely and avoid
all the ifdefness?

> +
>  /* A table of kmalloc cache names and sizes */
>  extern const struct kmalloc_info_struct {
>  	const char *name[NR_KMALLOC_TYPES];
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index b7a46c368ab1..9fe48da12010 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -29,6 +29,7 @@
>  #include <linux/memcontrol.h>
>  #include <linux/stackdepot.h>
>  #include <trace/events/rcu.h>
> +#include <kunit/visibility.h>
>  
>  #include "../kernel/rcu/rcu.h"
>  #include "internal.h"
> @@ -410,7 +411,8 @@ EXPORT_SYMBOL(__kmem_cache_create_args);
>  
>  static struct kmem_cache *kmem_buckets_cache __ro_after_init;
>  
> -static bool slab_buckets_enabled __ro_after_init = IS_ENABLED(CONFIG_SLAB_BUCKETS);
> +VISIBLE_IF_KUNIT bool slab_buckets_enabled __ro_after_init = IS_ENABLED(CONFIG_SLAB_BUCKETS);
> +EXPORT_SYMBOL_IF_KUNIT(slab_buckets_enabled);
>  
>  #ifdef CONFIG_SLAB_BUCKETS
>  static int __init setup_slab_buckets(char *str)
> -- 
> 2.54.0
> 

-- 
Kees Cook

