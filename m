Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77AD1606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RcLnxpyV
Received: by kanga.kvack.org (Postfix)
	id 4FF016B05BF; Wed, 11 Nov 2026 17:06:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AFB76B05C0; Wed, 11 Nov 2026 17:06:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3774B6B05C1; Wed, 11 Nov 2026 17:06:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D1C86B05BF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:06:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3FDF80434
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:05:59 +0000 (UTC)
X-FDA: 85424221638.10.0EF5DA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D7BA52000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:05:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RcLnxpyV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794434758;
	b=Mzytp6YEmOhElUyLaPnNH21HFX5Prr1CMt20clH4MKVPPJF19Rh5WBZmmTurbNI10uSi/B
	8w+gMKFkjVnWP1pxME9ii1pPMqnZ2xUf0JBWYojx02JMioK7H+U7iYOZ/k288fMVhaG0fO
	FWFxNwxB/yOPZ4Rf6jrPqwXHxGWBOTc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794434758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3z7N08vif0wJRzAYglj+deRTAnEekHHdYmVnN3upqU=;
	b=xf76ETLPsxFtcvPaf6XYOx1Fx3zqMq9ozdNB922/32C/y1uiC0Bw9NdYcZOdzc6Ol4r1sV
	O040b0Y8UfpLNxxUV/1OOzYRIOxDShjW7Ien621jUROozR838Ddu50VXlODUFTR2H1T+zN
	+zZALygNf0SDPKsYCWaJZsIfPZpwk5Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RcLnxpyV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 50C94609F4;
	Wed, 11 Nov 2026 22:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907651F00A05;
	Wed, 11 Nov 2026 22:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794434757;
	bh=G3z7N08vif0wJRzAYglj+deRTAnEekHHdYmVnN3upqU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RcLnxpyV70qsh/dFqhzFKXXRCnk0lw3j5tRW3S6jFBCsMz5CimfxFkneTy393fygZ
	 9SZiQrEtUg3kb9UtPQbGD4rRD+YHD+5lJX8ecb+d1lmv7MVXFwsioKxzo6kDXczO+7
	 PWD4XK9pOCcYN6bo3uBym/P60/MJ/4hCVwdKy5+fRdnuD1MRWPaC87Y+KwF7SGsyNJ
	 XqhEId3JvQUSkk2wtZwkb5h/1Bm6YeuDCmPbi79zzjSIQm/0oYUGjvHZU76Uh/lrB3
	 n364Rlotx2DTPRpZ5e+XCbJZ8ja72YQzY4rzcI6eGqmpOelgt1hP9UKdz+XEsZFJ+j
	 otHKNQaM5yfxg==
Message-ID: <b1c1c835-180a-49e2-86c0-bc3f65981728@kernel.org>
Date: Wed, 11 Nov 2026 23:05:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] mm: hugetlb: fix CMA-related issues
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, azpijr@gmail.com, lance.yang@linux.dev
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1794046188.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cover.1794046188.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D7BA52000C
X-Rspamd-Server: rspam12
X-Stat-Signature: yiy9hii1pambpijfdfc34zknbin9bzdu
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794434757-685380
X-HE-Meta: U2FsdGVkX1+7KHOC6eqbkUj0lQop+S2Zmm8O0WBfw8WyhwQj+vjW1b34nI3EuVkDPq9jhMjGjllHLuf1LjFA9/as+ohZ5bN0dRbNMPdwORbUFj3FywGPb8oSHXA3pH2qvPO0XwCkLt7CApej/T0tESctO1a+tmFvmAxpTNyG1D/6zUMdXns1nrAgkTAY/Dg6QbF5csduGR2/BjGvaBx81HsWhPc7kDQ58nDVq8pmKw+4rVgfndkmX+C/yw/PKChxODyKWHwJzLqwKXpq6Y8yIo9k7UvvjTiR56jnCVZ7gllrEqYu6gyC2fxkdrWlMv26+Gvfg9DBF3MIT5L0OJubjH7NUZVAXsdxnwNSBbfcpYOudiNLZeADkfUVH4rcXf4EEzAuH4GKXfdUjN+RHth/vExxWofcoULJ5zn8e2lE+a43qAPvvTVBMUcwSjUK4WD+tFeO/M5GWu3a2pkQ2PS/jdL++9YeGlOQ/m1FKPQl/7BfJ8tmVo+bsAwHGa5wMo1xRgPTcimec1CeutQflX3XhLlRHYOsm5V5Ev4foP/7cUy53JysZOAb88yCldRR+Jbsk81WCzHqxGDWefO8/56C4pIoTa6/M37xa8Q9j1KjTt+H0LSVaZMRdUt3LYyHOrRyaFR0gjiqhTXFBSIIKLQBKubXfJiT2Cu5C09EwlbCXqvzgNnjTDx/NtRAQJ7c0TR+RzIQl1yw/MFbphc0gx7wtUarJ9JST+TjFwd3Kp04N/xpVj2SvslkQvQS9cfd6pn28B4QLmU7hrGRrfiQhk7dKTNujQU3Ozbe7iU2mi0bTvoWalpyEzYM8oknlADn4yOKjhMhggGHhCdsn76GcwKDUarhvqFcosy/6e9Lcx6RW77aNAYazIVc9RX+4/PWNe+SPH1ihlPqwuW/NEek8SgtJ0EnXB6kAm3HOAcJPgmiTIgQGlTCqOXTmi/iEuXr21GPOrzcozKN7XQ35gbB9g3
 yTEEiIWt
 ifgjR+eDMXbSQHw9NCadj2QTXPS6Fbjcvtj9F/84jnW/Fu8SDwHNPboX371+gzmVgFWIH7qibRCNyGqraTzGALMJpRYnTXIHObeefvjNoIdRX7V0t0Dq545GgE3rBFSVCZWViP1ZD4mXyhWL7VFuTwMa2t+mLRidldrEVFi7pNYJJEbHIWv2BD5XRS4djFB2TnlCNmSxHo0Pjyq9f/MzmIz3gUvc3C3/B+0sycNo5F24oJNcHcffdU9yv6o9gx1m6FzL7FO52s7AUHjulOsEzQX7vQVrZ5izXT3zcMvaLSKvKRd4UMvkBrgR99Fg/XjeQSHLr6b0FfZ2y5cA7GUZAvzAks+im2CbYQrp2qacmh5zkVvaoCev3IrctX6Q/zvdsB2nuwdEZVdNIOEKCelksKtgJzd7s9oYjNH8yf9p0D1DrHftJPupKrndI+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 11:30, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Hi all,
> 
> This series fixes three CMA-related issues in HugeTLB reservation,
> long-term pinning and allocation:
> 

Can I hand you over another CMA-related hugetlb problem?

On arm64, we can end up allocating 1GiB and 32MiB hugetlb folios from the cma
region.

Doing that dynamically is not a problem. Doing it during boot doesn't quite work.

cma_reserve_early() does not handle any kind of alignment.

So if you allocate a 32M folio followed by a 1G folio, the 1G folio will
suddenly start at offset 32M, not being naturally aligned in physical address space.

Likely cma_reserve_early() must be taught to align (and maybe consume an order
instead of a size), similar to how the dynamic cma allocations work.

-- 
Cheers,

David

