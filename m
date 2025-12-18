Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC1A9D68BF6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 08:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC226B0089; Thu, 18 Dec 2025 03:57:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28A146B008A; Thu, 18 Dec 2025 03:57:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162366B008C; Thu, 18 Dec 2025 03:57:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 00A046B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:57:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B86B15D512
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:57:06 +0000 (UTC)
X-FDA: 84231987252.15.9E242CD
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id AEF34180017
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:57:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=K8b9gDyQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of elver@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766048224; a=rsa-sha256;
	cv=none;
	b=lYvR15MgHHawAvTVl7jIG+XvrjX4NNXeRCQSGhWC4KCymwckspacsS9nZL9cY3Am19vUQv
	RqCqgqeIZu4YJPQkY9yP9+P3OZi66jG1TDfpO3Pk5J0l1I8vCPCelZha6sNLziKm+lbS2B
	mnxXa24bJKD7+WHHnWGVRvGOT6ujMYM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=K8b9gDyQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of elver@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766048224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQSScrHGocujKud+xiMEi7IrZhWMIzDGmWhBlDWcW1w=;
	b=BDSF1HoWbV9Mon+841s0SQztpjRPQqoccM11Y2kYI3QU8ILzBgr2XFh3/G2pp+Q3icwy7V
	Hw5Q9kvGkg7H2qA+QLiCYyvH4apI8VNGSw0FEUZC2mopl8Hwy4TZ53yplfe7YFfuC6pAhI
	4WqjKXVsZ1DKOFaQWfi351Qat3zLAQg=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-477b198f4bcso2601945e9.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 00:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766048223; x=1766653023; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GQSScrHGocujKud+xiMEi7IrZhWMIzDGmWhBlDWcW1w=;
        b=K8b9gDyQzqkvd99cpDrBeeC59ynzcHiX6FqioaeSGku8EhL2DFa4XRmwT0YP12GlsA
         jPHLjdzCLlHFuqFVy0cjFPfhHFni6kr1BIu5UDE5Y48Kb2LpDum3T6dm0JQdAtOtYoOA
         P/rRf+RoJ/YcNykTOKqMwAg17WtJqqtL0zpcd/hzZZ5EGwZPApI/8gLbSPpjD2QNOp+t
         l7FkdGBJGiiqXwsdJwB/sjWZVOMWLovgbBzhf2siHKU8DqJCuBy+I6ICDq3utJCKSyL8
         I0iYP0F3oE4fItXIu8uzjs74REglp9eYZRPcefHQMb5ZDVdxysPAKwsxSXck8THP9NRz
         DikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766048223; x=1766653023;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GQSScrHGocujKud+xiMEi7IrZhWMIzDGmWhBlDWcW1w=;
        b=TIPPizhdqRk3MCdK2v3MwpySq2WdRKTf+el/F630JbGbUTIYPvSVDHD0EmBGY9eQh5
         fKY5W3xi0VccZxUYHFOOXFVeTrxKNUfG1+ZaMb9jBK/y57gK3+CNC2O5ynRC0Cf4Edb7
         bYAFHXpskcE604mLp8cyi8Ch7XI5Rfa8eJPFIQe5WsJbzwerjzepF7OqPP7deo/O/dED
         lqY/UpAUdhcSRPnSUk163vm6Mqoc4h2l95dvgPVCuA6s2+k2vebSd5PWTPb0hZL5yysc
         vFswdHURFsdok0U8uiAfiUVXsaPuh3mwmbkPfNyxwGeJwS/7MewAx2DK/NTj9056UkYk
         Qa4g==
X-Forwarded-Encrypted: i=1; AJvYcCWWzaZ2mNb9U+I2vIPAMuvuzj7muE28wjhR9e645URVHVIv3is6U7ij1JeLDtrSDrvBU0f3aokECg==@kvack.org
X-Gm-Message-State: AOJu0YxJCg6UysTpgwO7rp0wFTEUwJBarMvs04D5saEzRjCZxL15lGfj
	f7+Jc53PBGk/IHZrj3eg4s34Urcg2JSPfoCRLqTOLIJOSnELATalj0cs9/RejwBBpQ==
X-Gm-Gg: AY/fxX7o3PiHM39WxGS5CZSKVX+N7ZSq+h4JOdkxar9NrPak6VSmJ8D0hivWjd8PUvd
	NTEblUW1h+ob9RTY6Gb7Sa38MNSLpAlfMRdEEMn8ZfgsuznzqUpwBiWRND1WhghSAe1eEd/palX
	XNs/NpcTLXalBEprr5VVYRtKlxlIoSEJVkNQ2t75ijDJE4yXScP53jRLMgKtdSTySnG1JRWg/wS
	XOyy8kKtFgIP/sIux6v5SfDTd7BWte5fTI7gxPEJQBq6S3q7vhO0fWgwbcNmh56ITcLRDtBTmIw
	1WdOvs8QlIS9Pf7pyU79Ave9uA9pkRMMlPKPuHdLhBOiB5txHDp0aJtz1FtraPEprJqkJ4neRVX
	gnG2oaAmOFt+yQmk3ChiEznPeiFTURbOkzo1yQs/t2WPdvdGtjDHbhfewSIq7iBIkxRP7IYbBcW
	1WLTeiVeFm4jK+0BElfnRtybjA71fHqb1kG2vaCbAgBCMYqLIf
X-Google-Smtp-Source: AGHT+IGpBD4WMpC0/xgz/Q/hvvTr7xggeD09+wqcInauchGlEAY2Uj8VJqyBRZ11TmR8Uk2ZjfXOPQ==
X-Received: by 2002:a05:600c:45ca:b0:477:9f34:17b8 with SMTP id 5b1f17b1804b1-47a8f8a80bemr200448785e9.1.1766048222784;
        Thu, 18 Dec 2025 00:57:02 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:fea4:c93d:2b17:7eac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3af6dbdsm9753695e9.19.2025.12.18.00.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:57:01 -0800 (PST)
Date: Thu, 18 Dec 2025 09:56:55 +0100
From: Marco Elver <elver@google.com>
To: yuan linyu <yuanlinyu@honor.com>
Cc: Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] kfence: allow change number of object by early
 parameter
Message-ID: <aUPB18Xeh1BhF9GS@elver.google.com>
References: <20251218063916.1433615-1-yuanlinyu@honor.com>
 <20251218063916.1433615-3-yuanlinyu@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218063916.1433615-3-yuanlinyu@honor.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AEF34180017
X-Stat-Signature: 8iwytwcyn33daxujoh5pc3ed1dhgikmi
X-HE-Tag: 1766048224-957094
X-HE-Meta: U2FsdGVkX1/psfW3ng/g9AowXjaBd/+5s/8WcoKnWumAQUEeOktviZ3gXdSIBGlntzgWtswt8zqpsbRfpb1+rZ/7AlT8h/sF3RpUodPFvZ66zxxrXoE82GnmVi8B9Q85u7vEyI+osg8aZmsF+NAyZIpmHhSLc//U+Pr7cWKBwapVeUYZWoY4v6C3KVgx+1Zf7FoI1aKALQormVKGH2VFiqfnUvcndFATKd8EuJSbV887ssyzRJx8f79fEpL8UUjoxFD94lxg3iiozSrPlMrWO7MGQwWL1mklLeCqfX9LEvPKb3FkiSIn7McaJ7b4I7obVe74IdTwud1+irr0I2QYCsVtFfTlgYtgbvJGf/mGNknJVgsA1NprXpCWiGWS5uNRLXL99kYt6KIAFthH9t14Ue+EvLMNTCRqJUrvORrvk28LVeM1i1ZUfbmoQP/EzPRUx+Hri+lauF1PYOvCIAsIUvKBXk0XCTMQTX3dhRiSmSBHV7z2U2AJiHxr5H5GILenriUYNgC5mPLF1ceTjKIxkpy9IldN1Mtx13xkVsFGlI7Nn6u5UY9q9M2QBMh3im8EKBi5f+N5R4gmG+0HsOaKhOcKvnscR11KrA12UrJP8NAiOYJrd2MaH79ed2wGB/4pvXpEdoufc3TTqMNqr7tI3SnRUYwBqZ9cn7K2SEx+y1+US0Lgim5UJxCWnMH4BVMOI6sc8jlLBHP5sjJfJ+NaeUR60v1eAbcdYi1stSkEdVjY8/stjd1FloteoSoibVRAdoXg9ZGQYikb5pd0FrN+8H9MMpVuhsM0J4zLQx1kmZGna5OYC+Gp//EJhZURvK1qv+Srht2LmNNfReMpx+I/wtnf43dJnBQLA3RwDTPlAX7s1+p62DmTuuFbpBNtMJRri2wMQoH84H1q6KheF1cx0iKHIPCVX91oRtCvQQHbFyad97EsqAr4yDU4aTKjVsLD6fW1PTc/aQZxfsVfaR8
 OeLCQofQ
 35BjiWh7QSsMFd4fRhJH6jLtM21YQWyYSIPI6gBWP0wKTimppCEGxZLT03NN8Iyr1sBA8Uc4Hfe87oWr4wmxEC6cnxrfJ+J/Jcaha4kuWhGkpOif27pEY2OPsYhCsu1gBgNsw5CcQP/LABNw0oOP81HFq3LL5EZ8NTO3CvZGJFHy1WdJdi7Jpnp0dnVrM42nZRkQnUj0b4y3n335fjfOJHhHDD0qPcK3yVwTE4DpVeznKbjTJiIiLeNSh4jj7gz1/t+RSaEJpz5MCwqj9yIPG4a9tTQo8mq2u58+wGLFDSG6uNNaRXo68fEln2FtFni/E5VnWn5G8rtNfU6wCxK+DUiMiydVZ2P6yVpvHD8V1I2BXeWRF1uJLtMWPbI9nGJJSwgYTHh6dG9cStj2qgYd5qVhr9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 02:39PM +0800, yuan linyu wrote:
> when want to change the kfence pool size, currently it is not easy and
> need to compile kernel.
> 
> Add an early boot parameter kfence.num_objects to allow change kfence
> objects number and allow increate total pool to provide high failure
> rate.
> 
> Signed-off-by: yuan linyu <yuanlinyu@honor.com>
> ---
>  include/linux/kfence.h  |   5 +-
>  mm/kfence/core.c        | 122 +++++++++++++++++++++++++++++-----------
>  mm/kfence/kfence.h      |   4 +-
>  mm/kfence/kfence_test.c |   2 +-
>  4 files changed, 96 insertions(+), 37 deletions(-)
> 
> diff --git a/include/linux/kfence.h b/include/linux/kfence.h
> index 0ad1ddbb8b99..920bcd5649fa 100644
> --- a/include/linux/kfence.h
> +++ b/include/linux/kfence.h
> @@ -24,7 +24,10 @@ extern unsigned long kfence_sample_interval;
>   * address to metadata indices; effectively, the very first page serves as an
>   * extended guard page, but otherwise has no special purpose.
>   */
> -#define KFENCE_POOL_SIZE ((CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 * PAGE_SIZE)
> +extern unsigned int __kfence_pool_size;
> +#define KFENCE_POOL_SIZE (__kfence_pool_size)
> +extern unsigned int __kfence_num_objects;
> +#define KFENCE_NUM_OBJECTS (__kfence_num_objects)
>  extern char *__kfence_pool;
>  

You have ignored the comment below in this file:

	/**
	 * is_kfence_address() - check if an address belongs to KFENCE pool
	 * @addr: address to check
	 *
	[...]
	 * Note: This function may be used in fast-paths, and is performance critical.
	 * Future changes should take this into account; for instance, we want to avoid
   >>	 * introducing another load and therefore need to keep KFENCE_POOL_SIZE a
   >>	 * constant (until immediate patching support is added to the kernel).
	 */
	static __always_inline bool is_kfence_address(const void *addr)
	{
		/*
		 * The __kfence_pool != NULL check is required to deal with the case
		 * where __kfence_pool == NULL && addr < KFENCE_POOL_SIZE. Keep it in
		 * the slow-path after the range-check!
		 */
		return unlikely((unsigned long)((char *)addr - __kfence_pool) < KFENCE_POOL_SIZE && __kfence_pool);
	}

While I think the change itself would be useful to have eventually, a
better design might be needed. It's unclear to me what the perf impact
is these days (a lot has changed since that comment was written). Could
you run some benchmarks to analyze if the fast path is affected by the
additional load (please do this for whichever arch you care about, but
also arm64 and x86)?

If performance is affected, all this could be guarded behind another
Kconfig option, but it's not great either.

>  DECLARE_STATIC_KEY_FALSE(kfence_allocation_key);
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 577a1699c553..5d5cea59c7b6 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -132,6 +132,31 @@ struct kfence_metadata *kfence_metadata __read_mostly;
>   */
>  static struct kfence_metadata *kfence_metadata_init __read_mostly;
>  
> +/* allow change number of objects from cmdline */
> +#define KFENCE_MIN_NUM_OBJECTS 1
> +#define KFENCE_MAX_NUM_OBJECTS 65535
> +unsigned int __kfence_num_objects __read_mostly = CONFIG_KFENCE_NUM_OBJECTS;
> +EXPORT_SYMBOL(__kfence_num_objects); /* Export for test modules. */
> +static unsigned int __kfence_pool_pages __read_mostly = (CONFIG_KFENCE_NUM_OBJECTS + 1) * 2;
> +unsigned int __kfence_pool_size __read_mostly = (CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 * PAGE_SIZE;
> +EXPORT_SYMBOL(__kfence_pool_size); /* Export for lkdtm module. */
> +
> +static int __init early_parse_kfence_num_objects(char *buf)
> +{
> +	unsigned int num;
> +	int ret = kstrtouint(buf, 10, &num);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	__kfence_num_objects = clamp(num, KFENCE_MIN_NUM_OBJECTS, KFENCE_MAX_NUM_OBJECTS);
> +	__kfence_pool_pages = (__kfence_num_objects + 1) * 2;
> +	__kfence_pool_size = __kfence_pool_pages * PAGE_SIZE;
> +
> +	return 0;
> +}
> +early_param("kfence.num_objects", early_parse_kfence_num_objects);
> +
>  /* Freelist with available objects. */
>  static struct list_head kfence_freelist = LIST_HEAD_INIT(kfence_freelist);
>  static DEFINE_RAW_SPINLOCK(kfence_freelist_lock); /* Lock protecting freelist. */
> @@ -155,12 +180,13 @@ atomic_t kfence_allocation_gate = ATOMIC_INIT(1);
>   *
>   *	P(alloc_traces) = (1 - e^(-HNUM * (alloc_traces / SIZE)) ^ HNUM
>   */
> +static unsigned int kfence_alloc_covered_order __read_mostly;
> +static unsigned int kfence_alloc_covered_mask __read_mostly;
> +static atomic_t *alloc_covered __read_mostly;
>  #define ALLOC_COVERED_HNUM	2
> -#define ALLOC_COVERED_ORDER	(const_ilog2(CONFIG_KFENCE_NUM_OBJECTS) + 2)
> -#define ALLOC_COVERED_SIZE	(1 << ALLOC_COVERED_ORDER)
> -#define ALLOC_COVERED_HNEXT(h)	hash_32(h, ALLOC_COVERED_ORDER)
> -#define ALLOC_COVERED_MASK	(ALLOC_COVERED_SIZE - 1)
> -static atomic_t alloc_covered[ALLOC_COVERED_SIZE];
> +#define ALLOC_COVERED_HNEXT(h)	hash_32(h, kfence_alloc_covered_order)
> +#define ALLOC_COVERED_MASK		(kfence_alloc_covered_mask)
> +#define KFENCE_COVERED_SIZE		(sizeof(atomic_t) * (1 << kfence_alloc_covered_order))
>  
>  /* Stack depth used to determine uniqueness of an allocation. */
>  #define UNIQUE_ALLOC_STACK_DEPTH ((size_t)8)
> @@ -200,7 +226,7 @@ static_assert(ARRAY_SIZE(counter_names) == KFENCE_COUNTER_COUNT);
>  
>  static inline bool should_skip_covered(void)
>  {
> -	unsigned long thresh = (CONFIG_KFENCE_NUM_OBJECTS * kfence_skip_covered_thresh) / 100;
> +	unsigned long thresh = (__kfence_num_objects * kfence_skip_covered_thresh) / 100;
>  
>  	return atomic_long_read(&counters[KFENCE_COUNTER_ALLOCATED]) > thresh;
>  }
> @@ -262,7 +288,7 @@ static inline unsigned long metadata_to_pageaddr(const struct kfence_metadata *m
>  
>  	/* Only call with a pointer into kfence_metadata. */
>  	if (KFENCE_WARN_ON(meta < kfence_metadata ||
> -			   meta >= kfence_metadata + CONFIG_KFENCE_NUM_OBJECTS))
> +			   meta >= kfence_metadata + __kfence_num_objects))
>  		return 0;
>  
>  	/*
> @@ -612,7 +638,7 @@ static unsigned long kfence_init_pool(void)
>  	 * fast-path in SLUB, and therefore need to ensure kfree() correctly
>  	 * enters __slab_free() slow-path.
>  	 */
> -	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
> +	for (i = 0; i < __kfence_pool_pages; i++) {
>  		struct page *page;
>  
>  		if (!i || (i % 2))
> @@ -640,7 +666,7 @@ static unsigned long kfence_init_pool(void)
>  		addr += PAGE_SIZE;
>  	}
>  
> -	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
> +	for (i = 0; i < __kfence_num_objects; i++) {
>  		struct kfence_metadata *meta = &kfence_metadata_init[i];
>  
>  		/* Initialize metadata. */
> @@ -666,7 +692,7 @@ static unsigned long kfence_init_pool(void)
>  	return 0;
>  
>  reset_slab:
> -	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
> +	for (i = 0; i < __kfence_pool_pages; i++) {
>  		struct page *page;
>  
>  		if (!i || (i % 2))
> @@ -710,7 +736,7 @@ static bool __init kfence_init_pool_early(void)
>  	 * fails for the first page, and therefore expect addr==__kfence_pool in
>  	 * most failure cases.
>  	 */
> -	memblock_free_late(__pa(addr), KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool));
> +	memblock_free_late(__pa(addr), __kfence_pool_size - (addr - (unsigned long)__kfence_pool));
>  	__kfence_pool = NULL;
>  
>  	memblock_free_late(__pa(kfence_metadata_init), KFENCE_METADATA_SIZE);
> @@ -740,7 +766,7 @@ DEFINE_SHOW_ATTRIBUTE(stats);
>   */
>  static void *start_object(struct seq_file *seq, loff_t *pos)
>  {
> -	if (*pos < CONFIG_KFENCE_NUM_OBJECTS)
> +	if (*pos < __kfence_num_objects)
>  		return (void *)((long)*pos + 1);
>  	return NULL;
>  }
> @@ -752,7 +778,7 @@ static void stop_object(struct seq_file *seq, void *v)
>  static void *next_object(struct seq_file *seq, void *v, loff_t *pos)
>  {
>  	++*pos;
> -	if (*pos < CONFIG_KFENCE_NUM_OBJECTS)
> +	if (*pos < __kfence_num_objects)
>  		return (void *)((long)*pos + 1);
>  	return NULL;
>  }
> @@ -799,7 +825,7 @@ static void kfence_check_all_canary(void)
>  {
>  	int i;
>  
> -	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
> +	for (i = 0; i < __kfence_num_objects; i++) {
>  		struct kfence_metadata *meta = &kfence_metadata[i];
>  
>  		if (kfence_obj_allocated(meta))
> @@ -894,7 +920,7 @@ void __init kfence_alloc_pool_and_metadata(void)
>  	 * re-allocate the memory pool.
>  	 */
>  	if (!__kfence_pool)
> -		__kfence_pool = memblock_alloc(KFENCE_POOL_SIZE, PAGE_SIZE);
> +		__kfence_pool = memblock_alloc(__kfence_pool_size, PAGE_SIZE);
>  
>  	if (!__kfence_pool) {
>  		pr_err("failed to allocate pool\n");
> @@ -903,11 +929,23 @@ void __init kfence_alloc_pool_and_metadata(void)
>  
>  	/* The memory allocated by memblock has been zeroed out. */
>  	kfence_metadata_init = memblock_alloc(KFENCE_METADATA_SIZE, PAGE_SIZE);
> -	if (!kfence_metadata_init) {
> -		pr_err("failed to allocate metadata\n");
> -		memblock_free(__kfence_pool, KFENCE_POOL_SIZE);
> -		__kfence_pool = NULL;
> -	}
> +	if (!kfence_metadata_init)
> +		goto fail_pool;
> +
> +	kfence_alloc_covered_order = ilog2(__kfence_num_objects) + 2;
> +	kfence_alloc_covered_mask = (1 << kfence_alloc_covered_order) - 1;
> +	alloc_covered = memblock_alloc(KFENCE_COVERED_SIZE, PAGE_SIZE);
> +	if (alloc_covered)
> +		return;
> +
> +	pr_err("failed to allocate covered\n");
> +	memblock_free(kfence_metadata_init, KFENCE_METADATA_SIZE);
> +	kfence_metadata_init = NULL;
> +
> +fail_pool:
> +	pr_err("failed to allocate metadata\n");
> +	memblock_free(__kfence_pool, __kfence_pool_size);
> +	__kfence_pool = NULL;
>  }
>  
>  static void kfence_init_enable(void)
> @@ -930,9 +968,9 @@ static void kfence_init_enable(void)
>  	WRITE_ONCE(kfence_enabled, true);
>  	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
>  
> -	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
> -		CONFIG_KFENCE_NUM_OBJECTS, (void *)__kfence_pool,
> -		(void *)(__kfence_pool + KFENCE_POOL_SIZE));
> +	pr_info("initialized - using %u bytes for %d objects at 0x%p-0x%p\n", __kfence_pool_size,
> +		__kfence_num_objects, (void *)__kfence_pool,
> +		(void *)(__kfence_pool + __kfence_pool_size));
>  }
>  
>  void __init kfence_init(void)
> @@ -953,41 +991,53 @@ void __init kfence_init(void)
>  
>  static int kfence_init_late(void)
>  {
> -	const unsigned long nr_pages_pool = KFENCE_POOL_SIZE / PAGE_SIZE;
> -	const unsigned long nr_pages_meta = KFENCE_METADATA_SIZE / PAGE_SIZE;
> +	unsigned long nr_pages_meta = KFENCE_METADATA_SIZE / PAGE_SIZE;
>  	unsigned long addr = (unsigned long)__kfence_pool;
> -	unsigned long free_size = KFENCE_POOL_SIZE;
> +	unsigned long free_size = __kfence_pool_size;
> +	unsigned long nr_pages_covered, covered_size;
>  	int err = -ENOMEM;
>  
> +	kfence_alloc_covered_order = ilog2(__kfence_num_objects) + 2;
> +	kfence_alloc_covered_mask = (1 << kfence_alloc_covered_order) - 1;
> +	covered_size =  PAGE_ALIGN(KFENCE_COVERED_SIZE);
> +	nr_pages_covered = (covered_size / PAGE_SIZE);
>  #ifdef CONFIG_CONTIG_ALLOC
>  	struct page *pages;
>  
> -	pages = alloc_contig_pages(nr_pages_pool, GFP_KERNEL, first_online_node,
> +	pages = alloc_contig_pages(__kfence_pool_pages, GFP_KERNEL, first_online_node,
>  				   NULL);
>  	if (!pages)
>  		return -ENOMEM;
>  
>  	__kfence_pool = page_to_virt(pages);
> +	pages = alloc_contig_pages(nr_pages_covered, GFP_KERNEL, first_online_node,
> +				   NULL);
> +	if (!pages)
> +		goto free_pool;
> +	alloc_covered = page_to_virt(pages);
>  	pages = alloc_contig_pages(nr_pages_meta, GFP_KERNEL, first_online_node,
>  				   NULL);
>  	if (pages)
>  		kfence_metadata_init = page_to_virt(pages);
>  #else
> -	if (nr_pages_pool > MAX_ORDER_NR_PAGES ||
> +	if (__kfence_pool_pages > MAX_ORDER_NR_PAGES ||
>  	    nr_pages_meta > MAX_ORDER_NR_PAGES) {
>  		pr_warn("KFENCE_NUM_OBJECTS too large for buddy allocator\n");
>  		return -EINVAL;
>  	}
>  
> -	__kfence_pool = alloc_pages_exact(KFENCE_POOL_SIZE, GFP_KERNEL);
> +	__kfence_pool = alloc_pages_exact(__kfence_pool_size, GFP_KERNEL);
>  	if (!__kfence_pool)
>  		return -ENOMEM;
>  
> +	alloc_covered = alloc_pages_exact(covered_size, GFP_KERNEL);
> +	if (!alloc_covered)
> +		goto free_pool;
>  	kfence_metadata_init = alloc_pages_exact(KFENCE_METADATA_SIZE, GFP_KERNEL);
>  #endif
>  
>  	if (!kfence_metadata_init)
> -		goto free_pool;
> +		goto free_cover;
>  
>  	memzero_explicit(kfence_metadata_init, KFENCE_METADATA_SIZE);
>  	addr = kfence_init_pool();
> @@ -998,22 +1048,28 @@ static int kfence_init_late(void)
>  	}
>  
>  	pr_err("%s failed\n", __func__);
> -	free_size = KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool);
> +	free_size = __kfence_pool_size - (addr - (unsigned long)__kfence_pool);
>  	err = -EBUSY;
>  
>  #ifdef CONFIG_CONTIG_ALLOC
>  	free_contig_range(page_to_pfn(virt_to_page((void *)kfence_metadata_init)),
>  			  nr_pages_meta);
> +free_cover:
> +	free_contig_range(page_to_pfn(virt_to_page((void *)alloc_covered)),
> +			  nr_pages_covered);
>  free_pool:
>  	free_contig_range(page_to_pfn(virt_to_page((void *)addr)),
>  			  free_size / PAGE_SIZE);
>  #else
>  	free_pages_exact((void *)kfence_metadata_init, KFENCE_METADATA_SIZE);
> +free_cover:
> +	free_pages_exact((void *)alloc_covered, covered_size);
>  free_pool:
>  	free_pages_exact((void *)addr, free_size);
>  #endif
>  
>  	kfence_metadata_init = NULL;
> +	alloc_covered = NULL;
>  	__kfence_pool = NULL;
>  	return err;
>  }
> @@ -1039,7 +1095,7 @@ void kfence_shutdown_cache(struct kmem_cache *s)
>  	if (!smp_load_acquire(&kfence_metadata))
>  		return;
>  
> -	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
> +	for (i = 0; i < __kfence_num_objects; i++) {
>  		bool in_use;
>  
>  		meta = &kfence_metadata[i];
> @@ -1077,7 +1133,7 @@ void kfence_shutdown_cache(struct kmem_cache *s)
>  		}
>  	}
>  
> -	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
> +	for (i = 0; i < __kfence_num_objects; i++) {
>  		meta = &kfence_metadata[i];
>  
>  		/* See above. */
> diff --git a/mm/kfence/kfence.h b/mm/kfence/kfence.h
> index dfba5ea06b01..dc3abb27c632 100644
> --- a/mm/kfence/kfence.h
> +++ b/mm/kfence/kfence.h
> @@ -104,7 +104,7 @@ struct kfence_metadata {
>  };
>  
>  #define KFENCE_METADATA_SIZE PAGE_ALIGN(sizeof(struct kfence_metadata) * \
> -					CONFIG_KFENCE_NUM_OBJECTS)
> +					__kfence_num_objects)
>  
>  extern struct kfence_metadata *kfence_metadata;
>  
> @@ -123,7 +123,7 @@ static inline struct kfence_metadata *addr_to_metadata(unsigned long addr)
>  	 * error.
>  	 */
>  	index = (addr - (unsigned long)__kfence_pool) / (PAGE_SIZE * 2) - 1;
> -	if (index < 0 || index >= CONFIG_KFENCE_NUM_OBJECTS)
> +	if (index < 0 || index >= __kfence_num_objects)
>  		return NULL;
>  
>  	return &kfence_metadata[index];
> diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
> index 00034e37bc9f..00a51aa4bad9 100644
> --- a/mm/kfence/kfence_test.c
> +++ b/mm/kfence/kfence_test.c
> @@ -641,7 +641,7 @@ static void test_gfpzero(struct kunit *test)
>  			break;
>  		test_free(buf2);
>  
> -		if (kthread_should_stop() || (i == CONFIG_KFENCE_NUM_OBJECTS)) {
> +		if (kthread_should_stop() || (i == __kfence_num_objects)) {
>  			kunit_warn(test, "giving up ... cannot get same object back\n");
>  			return;
>  		}
> -- 
> 2.25.1

