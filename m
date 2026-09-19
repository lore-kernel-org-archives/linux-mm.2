Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EBA9C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 10:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C6986B008C; Sat, 19 Sep 2026 06:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49EF26B0092; Sat, 19 Sep 2026 06:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38CC06B0093; Sat, 19 Sep 2026 06:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 05AD86B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:28:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7325B1201F9
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:28:31 +0000 (UTC)
X-FDA: 85230137622.16.853A035
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf09.hostedemail.com (Postfix) with ESMTP id A33EB140004
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:28:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KurgH0kO;
	spf=pass (imf09.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789813708;
	b=X0qFSsMLet+hXuDDAc0XjvGGueR1qLtqpaNAHc8k9Zxxj9777BRR9ltrhhKLirZmRYDdyv
	mOGn0T083vWcGjU74lgOlBbDzShWCuYo0IS/ltJuxiI1Og8gjMMIhxBCOJ/Yoxy1uuD0XA
	Y9Wsew1EbfjpJf9rPMGzbi3q+TvAQVw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KurgH0kO;
	spf=pass (imf09.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789813708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+T4o7Z4sldFW89gg456PmAN7vw155d0OxgwruAX/bjg=;
	b=rf7QIBs5DvJ2KeIaasdvBi7P/rINYPAfg7OnjqfE4e2lp0n0UQBHuw1ZWAzkOlpg9kS0xh
	HfVkHqaRPOEMpZqUo6t7iPW9noG3pZva9peHUgdjIouolMjOMRYYqfo1jsXQ8RQlSPWIzp
	QeyOWOUAiDdHWVYpQxu+4ZEWthmLc6s=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccc09d65so1493940a91.3
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789813707; x=1790418507; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+T4o7Z4sldFW89gg456PmAN7vw155d0OxgwruAX/bjg=;
        b=KurgH0kOXYLyhwO2U1jWBa52ePMZTFBU2ObeJj8C/vhlKPxpsyFIFS7t2tbC1sqXMu
         Z+mbDGvjZA855RL5BEYQLUHsbLjx40cpUS4xegaAfkFTjQjOSjOYOeiteUIS7zROkq/T
         OuhR87h1qJl/CVEBBsCL6Q0dof4uH4/84GdVwsTAchCZJsgzdSzSEYq97cGfkF/KXMCh
         4NXSKu+cBKkJN7uiiIceDNFM9VfVK6+6D0JYDKnT3KmhxcApyKj/FN+Bkeu6W2xqDQFd
         0yzp7085OTcKbz9gKDyKUG61wsKeiMQwQQCTDOPJbDF6a4LGMUpAkPEC+m+7ga4OZP27
         qBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789813707; x=1790418507;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+T4o7Z4sldFW89gg456PmAN7vw155d0OxgwruAX/bjg=;
        b=DznNTfKa//B5wOiAgW47Nk66rNnRJLCoWDsHy6PpkPfOWytFwafwF+VYeRVr82Cu4S
         hh6YKm3FM3ldPy+9wLSts6oHa9sNj4G9Id13mrj3KgFsoSxZ1GVxlwRVu4md7CqQPGh3
         5spc5EsZWjkV6O7vLNRbduWWv7TfnzYu6Wtz1AH1tj2hGfoqhaZL4ic98Kz5zCNnuJ66
         YXvJxsx5WfqL7d1sQoMRbTtOhDU0v0aZYrOH0jWX7p0fct4EYCl/aHFhGvkgvd59Vfdc
         JZrTLJLwBPvZvp/eayzpT1m1BvAhV8jsNCaF5149AnlhE7oF4timTuYqL2hOK9Fk7Ay0
         YyKQ==
X-Forwarded-Encrypted: i=1; AKwUvBzOPwrWWUIzxqTIZtS01zemkYBYwIbl/i10sN3OZ65A7c1tuCE1Cg3dHtlbYjm6iaUufZYDU5RxyA==@kvack.org
X-Gm-Message-State: AFuF++kR9HnO822BpOh4HiJQ/SpadMa0rIgkTM+p12zWjHGfCNHUr92N
	pNG0kWZGmy3zbbXLFO8T6cLFUY+SrhkXwPFbbEqU/nmEZaEZV+IygvHZ
X-Gm-Gg: AYBFou1X04HtKC9bn5xk9ye8Z6JIx5nLTKcFY4SQjn44AsMoBjCcCUT5lGQe8m/r1Lo
	WG3dkjzpKtjaKXbhH7C0iswUum1MEfRVVIbgAPrukGL4z2uGMOO/UGVYb5TCrcU0wV1SDA4niZ4
	anpqWxK8FxK2NH8JaeYHq7aNmlSBz1tzUZ94xpbJKnAavZtvdx7waCZSrEyCZY/wnQbxJYK2DdX
	Da+W+9Yv2yKEG/gqfBiRovSr9Cx+DjzZCHRIXKH0vQAZEvR0f0Owt2V5x1++Soz2wqvNhEPgTgt
	/6VkBg3dxKpyuDnRrCjEKT63OpdELJZhmO2fOENx7EXTHBWQDmgDVBGTjnxrJOtuEVOpNLHYhRl
	cnCWdNUxg8vbZsVs4veb/JjIar3VCBodwIrq64VWLgT1Wddacdgom0jQHMP9ZRmEShBK3jkRXbq
	9xogPO2pIO5bFXTJEU2tK/pGp3DOID2zdRY+fg16kKZ4pOmHHeY4BluTsyeog0L79Vy02nPqhvK
	RS/BtYXh+o=
X-Received: by 2002:a17:90b:184d:b0:39e:6a7f:1dcc with SMTP id 98e67ed59e1d1-39e6a7f222amr3389602a91.40.1789813707258;
        Sat, 19 Sep 2026 03:28:27 -0700 (PDT)
Received: from localhost ([118.34.230.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c615f05sm4060068a91.15.2026.09.19.03.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 03:28:26 -0700 (PDT)
Date: Sat, 19 Sep 2026 15:58:25 +0530
From: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org,
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, hannes@cmpxchg.or,
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com,
	riel@surriel.com, harry@kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v5 8/9] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
Message-ID: <aq5jyXzuDAANeCJs@acer-nitro-anv15-41>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-8-3bc7a57bd503@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260915-hwpoison-kho-v5-8-3bc7a57bd503@debian.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A33EB140004
X-Stat-Signature: o6bjksuqejfu4pg76bb3brsqrt5i9u6h
X-HE-Tag: 1789813708-566803
X-HE-Meta: U2FsdGVkX19MvOwhLSLLso91OtMCTpHHCDkap50muNBmcUVUt5j15bAgEve0kDsHTZlW5IlBt+Z4EVCyZGmqEHfHufJeCeF+MjT6l0mxb9eMiELz48IZxGHSxLTNfy2MJ2R9jUxVI/zBCPiee1zkLlWnqpqBVfBbZ5E2rYq2PL5nH1i4X9kQWBMWnvRzwvluQtD/NXFszTsmWvtuEWgVu7OhELnsMXG3yRAhGXX6ysDRTUa6srPKH3GSSkTIpmITk6ydvykhF6GME6DvwgFOJZwUp5Q3LtyarCyfKOTw4LXus5q6SvQTFUcap8Q5lSITqYiP0hboVHD7xSzrdMyABLrpk+3lWJ8YKL3QETEoPkssK4SWtqgtWESsI1orATyaV2XMjywFJCD2T7XGfOxATKw+tOpOo+GFxK2ZSLrZTlCpT9rhkG3PJ7UllG8ZQQtRIx8CHAtyK0YPDiaZ5rNhDaRzmkm94H9/2aM/sp/xCzUnPmc882uOe6KOS4LS0wsMJLqnrS3hGfTBCsLX6rVEwblZax+NmqmKNZSkdluWkr6UcPb4WxW+XAmZ8BJZoOEtsbwHtGynVdzRuIvy5x24bqkRuIM++rEwHMM5H9tlDsRetXObgSoSiz887JxoUotmGi29sU+7S7786GaYqxnNzQFCrVnMsORRe+I56UeB4lXfY63bExou+dJTMHxed/aFiO24fryyIXJjA8rqnbYTbgz4IlX61rdZfvpFG4zxpQtrKvue4MTZeK/0DIYD2FW1W5Jlg2+9wQw5YoBkZ+iQoQgoAkyjWbjtnQE9h0Bu1uzdaHvcOp8Iep0LZ6WvcbBvL0GuRJLSnYQe9WOf840sFpEfLJL7tIpARHFx8azU/YoGY5BYU5QEpdS4PXJThwiGCunXcxTz8uJWEh7mc2SQRCGmRMtGsHSKJLgcFMfNd6BG75D3+UItJ1hsA2dGeFOxvxaS1inrJ7QhomDqzVM
 nrtc66YU
 n5/UwQsSQGWzdlpzkph9D+l8My2Oj28jFU5NG77POls4w529rQVIjlnNNETsX00p1bhI1QyGAk40bBDHlAjyJKLYGZ1b0IB1OYclrXsF3GYKq+C/dvwolW0Ls+NIVmELtFwrbTf+FQmHxLrGXpj6cuJjMFUia7o3fAvx7JueQZRLpxIP5YcBHhxhEci1Q/fZRpP95YxGKt+iBbew83qtqJ59dz74xJtvFga3faSg70iJ6xGbEqS025HvRe6koTq+3mqRP+8Djpx9rf43/PvnJ2bkJhFgr/2mZqit0i8g3Ocii9r3vg8bkKqLUivM0Y5s+1xLYloEZeGfN5ThC6TSValHra3nNAStiJa5/CesRQBvhYTlgco51skR6btslLCJ2s2fUc+ldkqx0SvJPsx6eIQq6VCZTDPrfm2dvvRp1eTUXZRjS6e9R9zzhum83IzYfoFLoxniuS7CENARgyr6mciMfYCTke2QlCmVBx32hUE0oDJK3hZyqkzC+P/1Vxf6jVk1JNh8P3c2tSU3Y1rBGSg3lHHgHKE1OlzZnlU+Khwdukz/TduvL2BGHcH2kX6g2Zlbl1dcqcDcAiVhyz7Wisy76+zx8yVR0oEXrm7kCupDhxx1dgDbp7aEQPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 05:53:42AM -0700, Breno Leitao wrote:
> A frame the previous kernel recorded as poisoned has to be flagged before
> it reaches the allocator, which is long before memory_failure() can run.
> Add a helper that leaves it in the state a frame poisoned by this kernel
> would be in, so everything that already understands PG_hwpoison covers it,
> the kexec segment placement check included.
> 
> num_poisoned_pages_inc() does not work at boot: its per memory block half
> looks the block up by pfn, and memory_dev_init() has not run, so it
> divides by zero. Take only the global counter there. A hotplugged block is
> already there, so that path takes both counters as usual.
> 
> The caller comes later in this series.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  include/linux/mm.h  |  7 +++++++
>  mm/memory-failure.c | 26 ++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b68824fcfbef19..8039830998dd4b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5225,6 +5225,8 @@ extern const struct attribute_group memory_failure_attr_group;
>  extern void memory_failure_queue(unsigned long pfn, int flags);
>  void num_poisoned_pages_inc(unsigned long pfn);
>  void num_poisoned_pages_sub(unsigned long pfn, long i);
> +void __meminit hwpoison_boot_page(struct page *page,
> +				  enum meminit_context context);
>  phys_addr_t range_first_hwpoison(phys_addr_t start, unsigned long size);
>  phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size);
>  #else
> @@ -5232,6 +5234,11 @@ static inline void memory_failure_queue(unsigned long pfn, int flags)
>  {
>  }
>  
> +static inline void hwpoison_boot_page(struct page *page,
> +				      enum meminit_context context)
> +{
> +}
> +
>  static inline void num_poisoned_pages_inc(unsigned long pfn)
>  {
>  }
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index d9b8be696aac38..60e9682434700b 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -137,6 +137,32 @@ phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size)
>  	return range_hwpoison(start, size, false);
>  }
>  
> +static void update_per_node_mf_stats(unsigned long pfn, enum mf_result result);
> +
> +void __meminit hwpoison_boot_page(struct page *page,
> +				  enum meminit_context context)
> +{
> +	unsigned long pfn = page_to_pfn(page);
> +
> +	if (PageHWPoison(page))
> +		return;
> +
> +	SetPageHWPoison(page);
> +	set_page_count(page, 1);
> +	/* The page has been completely isolated == MF_RECOVERED */
> +	update_per_node_mf_stats(pfn, MF_RECOVERED);


snip

> +
> +	/*
> +	 * The per memory block half of num_poisoned_pages_inc() has no block to
> +	 * find at boot, and divides by zero looking for one. A hotplugged block
> +	 * is already there.
> +	 */
> +	if (context == MEMINIT_HOTPLUG)
> +		num_poisoned_pages_inc(pfn);
> +	else
> +		atomic_long_inc(&num_poisoned_pages);
> +}

Hi Breno,

num_poisoned_pages_inc() currently assumes that the supplied PFN can
be used for per-memory-block accounting and therefore calls
memblk_nr_poison_inc() unconditionally. The early-boot path needs
global-only accounting because the memory-block infrastructure is not
initialized yet.

Could num_poisoned_pages_inc() treat -1UL as global-only accounting,
matching num_poisoned_pages_sub()?

Example as below:

void num_poisoned_pages_inc(unsigned long pfn)
{
	atomic_long_inc(&num_poisoned_pages);

	if (pfn != -1UL)
		memblk_nr_poison_inc(pfn);
}


The caller could then use:

num_poisoned_pages_inc(context == MEMINIT_HOTPLUG ? pfn : -1UL);

This would keep updates to `num_poisoned_pages` encapsulated rather than
manipulating the counter directly here, while also making the increment
and decrement interfaces consistent.

Thanks,
Shaikh Kamaluddin.
> +
>  /**
>   * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.
>   * @_name: name of the file in the per NUMA sysfs directory.
> 
> -- 
> 2.53.0-Meta
> 

