Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF8C7C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 17:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49316B0088; Fri,  4 Sep 2026 13:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF94E6B008A; Fri,  4 Sep 2026 13:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E7486B008C; Fri,  4 Sep 2026 13:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E79B6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:14:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B147C0153
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:14:17 +0000 (UTC)
X-FDA: 85176728154.03.554EFFD
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 812298000B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:14:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aSSF6x1x;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788542055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjaqkPTnppiQ9iMiGEGM/pFHCNqFkiCYfaf94LCABdI=;
	b=bEbmtlDjoY5vdxnXW+ph91YaNSy3EilljmoCjvZuyXzt0j0o7A0wB2A8hEW3p4pBaRKAW0
	0BOM5grDoK9H2cIPxtcKvVKjcbs0ztQY+47jQ/lSUbv+No5U2Gf3i/4hXPE54ElRMTTbMg
	9HYhw4MST5rG6H5PQXgxS2fULQcxnwE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788542055;
	b=NoLNutRmZjWufBLQ0q9pWJyYyMe6BIlV5BjuAniGvE0j8UQO+OEQ3o1TVC440ETJvVwbk7
	gN8aHok9SL4Hc3SR3CpRAUUFDwlPjyg/zoZ/tSmdymOpuDTPVXRPF+wXu5CgfGm4tz/XiV
	GYOxsW+9EpMZTMLlzL1Y86sbN5GnVfM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aSSF6x1x;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-48a0ca07c38so1178604b6e.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 10:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788542054; x=1789146854; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gjaqkPTnppiQ9iMiGEGM/pFHCNqFkiCYfaf94LCABdI=;
        b=aSSF6x1xOAUIAe9XshckFzSolb8liBSwuZwWaUQ66v8RSqUTByJEJNvwe6pNodO9f7
         HnD/uUCfthO4xP188FZf6jEiD14k71dpyNzO/dODipgRghWEaDMrG+x1JmanIDaMmoR3
         DJNaSOk+yO4vdj6g00M9DCVr7kFsqIRuGrohsBhPa4nQ+PbfKXqDtrlZYH/21fzhHIJu
         ZwDLtRLZE/M9vVhys/Vlh+PyFN0A5nPBM1SR2B+G448f7ypOrxasFZz+UksAaXxBwq5W
         BP1Z1O2s309i/m+8wb4DbjYouy/eQkwDW9GA4SNPVRDaM8ZRlPxsKbmNn0oAG6R75EkM
         j2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788542054; x=1789146854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gjaqkPTnppiQ9iMiGEGM/pFHCNqFkiCYfaf94LCABdI=;
        b=mBE3fDSDTyxC3nSEYlfr8CPp6q5jH6pqkywoNTmhF8jtAqYAwjQHBd8KXUwrB+vKt+
         zVEyNVEKsI45vzbRanimnfQLYTb3X6XwaPv1XuGJvGMlyUlnyHcZCo/ptELCH+PkuZfH
         YVODoJe95bOeAfChv7DjUDDNVHsDiN2pxdoECg1lYB77sKFCHzpw4SzOsP+n5qV7JCyD
         rAz8DC9bbYD+WoaPjxB20d8b+P6zsBjYQlr47bsUZybfNuoFzJVqvUbJYC9h9LHa7mWT
         48VJ5YO53yahlINoGFaCKdP3L9lF7QdmOat5dLaGtuKE7QIjaqsavtLrDmtrAPsjAZnB
         0BtQ==
X-Forwarded-Encrypted: i=1; AKwUvBxRz0Pasmx741Uy5VCaIrhNW9VQxccgyVmOU6XNKE9ohibn4zsfnOAf30IdDo7A4OFTIkOZmco7HQ==@kvack.org
X-Gm-Message-State: AFuF++lyKmqCA3YQXQm38kQ3fYFFL8llhsJf8ElogAh+7mOczc8rRQGT
	M9tv5o4i4C/h755oJyRlJNusiXrhmIr8JFKJjy2JzpFLwHxCKIVMxYdO
X-Gm-Gg: AYBFou3bRne0tFrfdMDSKyKDsg0voz7gbOmmJ/HV36CB2xTSxGCWcyax3MkneOigbkJ
	S8oHJZ67vrQ9l3vExVp3Y25esxGXWary/7LmtAGOdJfeNy26nTkaCduNMIX7r4RR54PwYVu/jAi
	OjX51dxOziVtW2fe7zU9xEaGL3PHWjy1QD1c1H8x4lsI9S5U3VlQAf8g3aHF3i1QDx6bAgFsxwS
	kHCYqgSOv4sVO+7o65A7LR7Zcb7s9Gu9vuJiG1X/rhm96ceYX5MlDgayTjhOa5M1j+2ctFh7LyN
	eEr5CS8SNAv17Mgo5YI2xqypdwuTErI/AK3IssDkYmTSLOMiwyiZJReyLHNsXggI72TJCwEkKJm
	e6UBPTLZ9M4/fePtX5RW5a+GcQ//T502DAyKpenRPwE6H4IgzkMyeXYMIcB8knikdz/ALx10emW
	YhRpwBkF4WoyFqw4qkyt+GLzZCuVtGFn0HoTZLcWK2lYLkOVRuSFoSFGNrlvvVs7S9lDxQwpsd0
	t3MQWjH1y41d3/t1A==
X-Received: by 2002:a05:6808:13c1:b0:496:11f1:f2ad with SMTP id 5614622812f47-4b95f94794cmr7013081b6e.6.1788542054195;
        Fri, 04 Sep 2026 10:14:14 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:a::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b971675a96sm2865607b6e.11.2026.09.04.10.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 10:14:13 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Cc: Alex Shi <alexs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Hongxiang Lou <louhongxiang@huawei.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	jthoughton@google.com,
	fvdl@google.com,
	rientjes@google.com,
	vannapurve@google.com,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wupeng Ma <mawupeng1@huawei.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ackerley Tng <ackerleytng@google.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: hugetlb: Return -ENOSPC on memcg charge failure
Date: Fri,  4 Sep 2026 10:14:11 -0700
Message-ID: <20260904171412.191180-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902-hugetlb-alloc-folio-memcg-charge-error-handling-v1-1-e3e8942c141b@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 812298000B
X-Stat-Signature: 858ky7uqoxzyfwccswcpo6nr3mhmnu4k
X-HE-Tag: 1788542055-363610
X-HE-Meta: U2FsdGVkX1+UPHOystXxYUaJLmY2W7ceb6tp8CZ6rlEMeAe3Gxp3H/rwe9fZwKvUxtTC5TfIY0CHbRuxd/hTKtaS7mtdeq+TX+h9Cu/jVHFxSAZjVO3Ku+qw42FYmNzleaCmj0mUVlRGz4rKYV8a9iwmo6BAX94lU1FK4wk7Uq3fS5HnQJucFfvfzw8sl2VuirM/jmrNsTDanVFKBQtE8hzfFMHu0wu/UJ8il394XYWLNLBcBaPZd4rz+TgMz3G1HMhwSimbQjVhTmtNBHfsGfbm70AF2OFUbS5jp36CXNNXOWYs3KC1qSeVLuqx+vckjlpM+Bn3vRbgevau6y0l9DvkokDjELb4NjXff1oveEREWd3PVR35b6wnonePFcstLAa7KXX0zkSlFkwo8YAtGBSd5t9wL9mzRX9/RxaBJQ11f+Onfxu/7nKr9oWvcI1pD1IVbXmTPYtbN5++WHs1kPL7zgx8IISx13s4Ew7Da8n7NVr34ryBSHqFAYJ3MvXwdusTT/aIq/tHCiacM5oEuJKioF1YHfFJ3U7iCtRCTMXoWqBSefMkX4UIsNqHt77u7n+F8FJs2qrohpozIUV32l7KkkiJWEyinrPFjFeYM7/hLq38mgEiN/yewhzokGbHajZXDKSbdYtOsmmsjKiijrPCn7SH9d7+9RK7TmsO42pYfVX3bjvJDAxIOlIDl91Hi8v6NfSG+X6tGwBSJtd4r5QY3L/ex6V6eQjv3zF8zVSKFzCRPQJJSVktcz9THQ47+k4ZX15XfqJqFlR7rfXWGW/AW+RzpZvIOnjhiESFk/zDhh6y1Bu4mLN0t6OKIP6Kz6xBI+hi3pf1L77q8VKPO6FsPcglgkkFlURiK/fB8PcFOHWA0e1wIfMEEX7piVUw97XG27K/vqUfTWseByMF9cTukZDjOvropy1rOMN8qbTEQUdXzYFw1dHt0cok2B9SGk4TCxNjcGOWEq7e7GI
 4/T0SseR
 urRbMpekfh49/uYXuVh80Xk9tVBm7aFGMHatVb6PvLt+2v1vILPhtNawBiRh8zXtKFQPoZCNKrmuSHY0f05TKea0OUQGzqePL6Ey7h+ftxqQNxzG2VTc8dyxQTU4rg8G5HZjYCAeK/agaTgGy7HjKeXXfAwY+LgBrCrmaWKJUgA3Vq5D7ha8FjXRRsKboxbeGKX9JRVy3a0tF6UTkVLoqwZYRyMd6JsCeD4CLlo9UDBDYzA0eK17chHsKqe8yd/7acf0sLImmp0/6we/K3VfJLM/oq+KlW02N3B8/tpEFmUcPvf+yJDCkUSsQ8Sp39uT48WUkAlYf2uH7v/Phty6+zCQxtfCl81tcVvoD0DehUOklzr2PLn6pKrkLzMuMw+Vv2452CWWqNDGaXsqAlfeZmtXG3/QwYjcpxKohtJ5EbidUTeMt2NWzmjac8go/bjYsiLPq8Vl7hq3jI1OzwtazItd9fgqXtIXum89T07YD7fAMgFO/6o1BetaFwU/ohoRmbiSKwnLNaoAUeq/CWyRRWgYxaXFCPGE5jETqiP/wImuAG3raOE5uO8+kbzA1cq6iDJU8oLU34Je21CMBR9nuAl+lc4ARN1EOvC9guOOz2P/TsXCFpC6ktxqnewjyZP0zPbv1qnJf+/nngGEORMb+7o4B3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 02 Sep 2026 01:22:56 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:

> From: Ackerley Tng <ackerleytng@google.com>
> 
> When mem_cgroup_charge_hugetlb() fails with -ENOMEM, alloc_hugetlb_folio()
> currently propagates this error. This results in the page fault handler
> returning VM_FAULT_OOM.
> 
> Because HugeTLB allocations are high-order and use __GFP_RETRY_MAYFAIL,
> they bypass the OOM killer. Returning VM_FAULT_OOM to the #PF handler
> without triggering the OOM killer (or having it make progress) leads to
> an infinite loop of retrying the fault.
> 
> Avoid this loop by returning -ENOSPC when charging fails, which maps to
> VM_FAULT_SIGBUS, terminating the process cleanly.
> 
> Make mem_cgroup_charge_hugetlb() fault handling use a common error handling
> path, the same handling used for hugetlb_cgroup_uncharge_cgroup{,_rsvd}(),
> which also don't trigger the OOM killer and hence opt to terminate the
> process with a SIGBUS.

Hi Ackerley,

I hope you are doing well! IIRC, this is the same fix as the one in
[1] (in spirit) right? 

I prefer this change since it is more obvious that we return
-ENOSPC right there and then. Since this is a fix please feel free to
add:

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  mm/hugetlb.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 7857728457952..01b57f6d3b804 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2823,7 +2823,6 @@ void wait_for_freed_hugetlb_folios(void)
>   *
>   * Return: A pointer to the allocated folio, or an ERR_PTR on failure.
>   *         -ENOSPC if cgroup charging fails or no folio is available.
> - *         -ENOMEM if mem cgroup charging fails.
>   */
>  struct folio *hugetlb_alloc_folio(struct hstate *h,
>  		struct mempolicy_interpreted *mpoli, u8 alloc_flags)
> @@ -2896,7 +2895,18 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
>  		 * were committed to the folio and freeing the folio
>  		 * would have cleared those up.
>  		 */
> -		return ERR_PTR(ret);
> +		/*
> +		 * Return -ENOSPC when this function fails to allocate
> +		 * or charge a huge page. If a standard (PAGE_SIZE)
> +		 * page allocation fails, the OOM killer is given a
> +		 * chance to run, which may resolve the failure on
> +		 * retry. However, for HugeTLB allocations, the OOM
> +		 * killer is not triggered.  Returning -ENOMEM (or
> +		 * anything resulting in VM_FAULT_OOM) would leak to
> +		 * the #PF handler, causing it to loop indefinitely
> +		 * retrying the fault.
> +		 */

NIT: I do feel like this comment block is a bit verbose, though. We just
want to explain why we return -ENOSPC rather than -ENOMEM, maybe we can
just explain that OOM killer not triggered --> retrying is futile?

The change itself looks good though : -) and I don't want to block the
fix. We can change the comment later.

> +		return ERR_PTR(-ENOSPC);
>  	}
>  
>  	return folio;
> 
> -- 
> 2.55.0.970.g62bdec98f9-goog

[1] https://lore.kernel.org/linux-mm/20260720-hugetlb-alloc-failure-fixes-v3-2-7d2a169aa9ee@google.com/

