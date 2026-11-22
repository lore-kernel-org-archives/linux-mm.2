Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DD57606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XBLde5Es
Received: by kanga.kvack.org (Postfix)
	id 4C9C36B05B4; Sun, 22 Nov 2026 08:27:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1326B05B5; Sun, 22 Nov 2026 08:27:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390CA6B05B6; Sun, 22 Nov 2026 08:27:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DEF76B05B4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:27:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9037E1A064E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:27:09 +0000 (UTC)
X-FDA: 85462830978.16.261B63F
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id ACB5240004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:27:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XBLde5Es;
	spf=pass (imf12.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795354027;
	b=cn2P4OX1F4ZKqbedmVYrfzhcOGdBV+Gdcyd3ILppb+D3tMzxTkmiBIc8EB75v/uy5mHWxX
	gAiBG7opoFOkNp4TawD1hOz0UpWgTCpGgFptUF9OXcxZydMo3rwzzg5ox+yT8lO/mTgDtM
	iGAtBY6dXWGxNP8vn+uh1HTYwzVzT64=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795354027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Vjxsk05GCtbwT9AzJDYSYJvCFKsZl/7LIPSbKWoOhY=;
	b=SGuwE+xby5mcW9rnzSdrBFQ+hiRhsInsKp8rdIw4fyKx52KkGQthP9+2IrvKMv9+xy42iD
	RxX+4WiGgBp3IbpTRffQsmPGcKnIh4o5S3fDPsBsanZFQHbCsoMIHk9FzvOwDYT5ZxCYrV
	h5sp7A6+eGLohHR2CvYCNZ6CChhbVEI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XBLde5Es;
	spf=pass (imf12.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so22627795e9.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 05:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795354026; x=1795958826; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Vjxsk05GCtbwT9AzJDYSYJvCFKsZl/7LIPSbKWoOhY=;
        b=XBLde5EsbOcB8lTgHBAKcChFSa+yboN0ryrUk9s52kDZRSJAJXCl+Z6s53wlmTy+lr
         D7n94atTSZ9S+adQKJyspZatsU/bib4bTD4sBuLC+F1fKfJMkUiAWOFamD4TsxqF0DcO
         k74J/t/X89/BN1/g0YZCQeeypjacjw9YoeytyjCD8qzAlGP+u90P6VmRhcIWqaJEuiav
         wUKrTD7O43BnCFDlphEP8mHZwEC31eP8cZynZH9cU071X97uiGUcnq4+KJp4yHmDGRV5
         Ua2ZufBwqCRI7vCeO+JsHyhxge3oAdsdcufBUqLALJpx5YbnVe4slHmwJJ7sCWwJYC0H
         oN5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795354026; x=1795958826;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4Vjxsk05GCtbwT9AzJDYSYJvCFKsZl/7LIPSbKWoOhY=;
        b=mPfFQLx/7ccD3um9zp5PGqbMKI7y6cHg/xqAy3R2nTc8wACVWv3jwsZ9Segpv6CGx5
         quXGoJKgcfK5/wLldMlTu4eJ5Hwb4s2Jax2HrDAUXYIwcgVZ2et3YzWgm2mbbLLvBFXB
         Ry/9BitgXtS+/DFcY6PnScu8Tuzp4r325uNmdivC4u/DfgEWpS/iDC4xSJcg+BA+GtZA
         gySzZn+msnDQc5DVofLb+Fcqwuuim4GN+1KO7ge/H/rMW8Sm4Db1I7K9wlNKElPq5o3s
         fGBEdH1leRVSp6Lf1HbS+pRJK4J9/reTM9yn6g/z3kxlMH92do6wqAu97bvRmFpJdZfV
         v+5A==
X-Gm-Message-State: APuU4Z9klUV2JUQTyXYJFEvaTd3OjO8stYrvwtEHsYXLOgYbmKL4SQ3n
	aTMU7dH4MvqoNA7HDY4hBjOlQHjJVYnpZDYDqkpMQiDiLhteVFeuiWOv
X-Gm-Gg: AZFdTZfswI8ekOcWrEC65PCh94fe6K9oOW99VnU/YudMKyZWTALe5phObZdtfYxH24h
	06bI2ZaTjWTXjNEQ7dWovnkxGfW3eqrGKejY9URjBvI8LPrUOhChlAq/SDOnaLe5PfKSlXXVc7n
	KBky1LvueAbL9f1DUTDoJlG8Z7rsv80z+0Xn0gpeI60NNhXNm524QtyiR6KABTOohctbc47ksgU
	K0VP/FjZJrtTURcEuwPhRvxpfgH0+0k1aiiLgdXv+qTCDBz3U+A3ROnJ5N26Z8bndlCYQQum0zr
	G4oPTRRaBdftxXbWro7LSlmLfULpqUMY3lU0mhM8VUBDb8vy/cJZjMF6mUnPZ7agocopofKDmfQ
	Qo4yERA9PYZJXdmMBKgOb3eeosqwDTcOUXGc85rhJBj8aDZP8AbiFNHT+pa0icHfHdEDBvoseU2
	OSVJR2vCIaVpkn5VCGkF02SOEnBNcB29qtZ/EkdCYInHbLJIs4SZ/Y6FbkoScakqRZyufP83B4I
	MmdCjQktKBltRtFNwjba1hjDlF+542wlVeYWz5e5ctTn7xEWOHWTAYI+Kw5+iBaaHzVCuvncWc8
	cx88WMTjPDt4SCrmC7W7k+8HGA==
X-Received: by 2002:a05:600c:6749:b0:4bb:5f95:c014 with SMTP id 5b1f17b1804b1-4bb8880f283mr194508305e9.19.1795354026164;
        Sun, 22 Nov 2026 05:27:06 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906635c7sm113782625e9.2.2026.11.22.05.27.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 05:27:05 -0800 (PST)
Message-ID: <08fabb3b-d717-4b52-8c9d-d4c996e97bc5@gmail.com>
Date: Sun, 22 Nov 2026 14:27:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: hugetlb: allocate larger early CMA pages first
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, akpm@linux-foundation.org, fvdl@google.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20261122065527.33123-1-qi.zheng@linux.dev>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261122065527.33123-1-qi.zheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: ACB5240004
X-Stat-Signature: zpnmeraumbqa8ekrfa4r3n6kuhq8pcjd
X-Rspam-User:
X-HE-Tag: 1795354027-335868
X-HE-Meta: U2FsdGVkX19ZRzAmzCYkJNWeEze4d7/axujQzj2oZJVcFob0HBZPLlNOThxBjUgDv9VS8i44i8TmUuL++O5KkmzwfQ9xBwJneuyL0A8T6uJlHbkk7+mEqQh8sX6m82eQQ5dASTqjfCHYflCPU5vtyCseEjTS//PqOoOv7/Oo6o+VBJmj7oBI9uBFuwiY6UWnuC98+L61LtU3Agm8e8AfEj3+JkB1CqEV6BGmPTpksRk+R9eOdP0g/rLIIG7Dv+Y7cljmh6zAfWEOejmU4kdPJIBXNCRwBVNzhuD3vuJetlIkRrT5MLNBTSvnzaMy/1p/pvawi/0U8ce/noiIYyXLLt53n6Ssuq95v8X2NSdPZuEnUfNt65b9a9RyxpIHZo+XrrI+0njIEOM2nqiUxxwxe7C7bfE6XOnrGtmTUjvCLzx0kJlHuh29eSkokwCcJiRqWpOXe4p0ZTL/bAiEom858jBGRhxWzKXmKgn0hSeySP+XlfS4QMg+CYzBBXyrVqsxdRUtB2HiAh+OD+PMQkjXHJy8MYULl5ReNUVTiwCQoOhZ7J4KK78cI5pF5AHREWlX4oDSrlaFEMUk7+9HrkvI1xOxQc22RikKcMfuFYNgI2XCvj+m3FBWCtIbbnV3kxuTk+z8KkwZQ+IKABiXWv+0lkMzUaE3nPlEAjZUdo4dCoktkMXOspC+KVRbSvwxrf3I4dbIXousaS9rQu5L4f8/6aV1xEvjkuD2i7SlFOM3rUP4YURajqBnLm478cSSR4PUNsPekAyf7w+sBLiWc1uEOVv04HFLtZ/jjtux5i5+XgY5n4nqLetakTtGM0ja9rMZA26KsWPvJkLYn6M2A/aoHYbE24wEatXZW2pn3deXV/oxicoBXpa4JKIsdCrng+nXrSV/u2KtyfREjUe4BMQsKW/ruAAozf47dj3PLKGCbOjf/0mjwKk76ygFi1x+NC9XpFAiFvLOMasoFTzvRNk
 2OGeYMEh
 kLSBBNpi6I7ON1jSK4MNMZ69Mu0kDtkfoRnfTyZ96JabD7qTv/KzYjfQ90SdmCLP+wajRIi6z37A7F/oXWA4WfHpjncmj4urcIjpJFmpY4k3yKuDBcF2J8w40bzNovULwouOSg5yb0gu0h4SH4zVGLp8hAIGdPEPFBlf/KINavZ7ZJAnf7XT4T+mL9w6LKaw9YA8PtWmUgAy1w7P7vaSHxKFAEsTiSJI+7itCO0WTl+DNuxFtoPvvZJ2Q13pPG2zRL/WaoTixQTAQ1/1yVKyIiYmhmBo0igoaAkQdybtOhejzVOCRyDlzKo9IpJvLDPii5YUTzXHfVnewDFkugsWxTHpGTVSwWKAOF4vlURUFEWqKzqvNsfK6aEi8Hj8Fm/QwBEuOd8jhjwgd4xFZhDlmzl3zlC2kpfBVQ5GwRud0EGiOY1LKEyKaynPDSRvHo7uf+x9mno79+BPs2LR0rEHx4BnjdXx0A2b+5mGws+GMu+tAIrGNixAXpJb37Wq+RgBVjxr4EC7Qec1eVw0ACVAVwbQd08DycMx2vlQ7miyEQF6NTDRgIcD1dbazLBAAsZ5WObaWEB2as33fjjtSErDtTwoIMaq8HQB2RwGVJbuZDkpk582Hc0uuQW+zn4GtKXqXFlBhgiuGXHo0737CkVHzLut+SD54ASluRaGYO70Y13XVtTY5zvnoINwnCD1Kiq38zW7eU6HkEWVWeNPFQasC+eaZQ1ryncCFchBL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/22/26 7:55 AM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> With hugetlb_cma_only=1, early HugeTLB CMA allocations follow hstate
> registration order, which can depend on the order of hugepagesz= and
> default_hugepagesz= parameters. cma_reserve_early() advances early_pfn by
> the requested size without aligning the start of each allocation.
> 
> On arm64 with 4 KiB base pages, 32 MiB and 1 GiB pages share a CMA pool
> aligned to 1 GiB. In a 2 GiB CMA range starting at 4 GiB, allocating a
> 32 MiB page followed by a 1 GiB page places the latter at 4 GiB + 32 MiB,
> violating its required 1 GiB physical alignment.
> 
> Simply rounding early_pfn up before the 1 GiB allocation would leave a
> 992 MiB gap and advance the cursor to 6 GiB. cma_activate_area() marks the
> entire prefix below early_pfn as allocated and only frees pageblocks after
> it. The gap would remain reserved with its bitmap bits set, and releasing
> the two HugeTLB folios would not reclaim it, permanently losing 992 MiB
> of usable CMA capacity. An alignment-only fix would therefore also need
> to track and reclaim such gaps.
> 
> The same alignment issue can affect non-LPAR PowerPC64 hash MMU systems
> supporting 16 MiB and 16 GiB pages, with 64 KiB base pages and
> CONFIG_ARCH_FORCE_MAX_ORDER=7. The 16 MiB size then has order 8 and is
> also gigantic, sharing the 16 GiB-aligned CMA pool.
> 
> Allocate early CMA hstates in descending order. Each range starts aligned
> to the largest supported size, so this preserves alignment for subsequent
> smaller allocations without creating gaps.
> 
> Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
> Cc: stable@vger.kernel.org
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

