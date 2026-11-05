Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4957F606A33C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=so6TMbeQ
Received: by kanga.kvack.org (Postfix)
	id 4DD1B6B05BA; Thu,  5 Nov 2026 16:47:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48DD46B05BB; Thu,  5 Nov 2026 16:47:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7326B05BD; Thu,  5 Nov 2026 16:47:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EF7C6B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:47:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8498980C0E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:47:21 +0000 (UTC)
X-FDA: 85402401882.17.612B7B3
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id A28EC1C000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:47:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=so6TMbeQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793915239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJ/A2e5X07rBRQBUzH+eXJYmu5j343R3rSFT2KqYV2g=;
	b=qdBIf2eQGMUaTjoU69ixUFkWSnCpVxZo3Vpz8v/7q7rpkbxyux9uwlROJKYeLzLZYdkq7l
	28lvjfSrdRsTe68VNFofba3Hl9AU1RIMA2KotWy6WQbRfaB+Cqv2/Yd+PWAh18OKRFElXl
	3msaduY7rXeol5vE3UThBzxkToqU/zo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=so6TMbeQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793915239;
	b=wSS1ZC4EGzBO64zqIeH9bpTaV5OIqnyDsiS24K4yh8FyhO8OeCs3tfbY36wi1k3pP6tXEx
	DuAkM3v4GpzL7QGNxR0Uic+hYL+sRAoJoBTCPX4FWq9wLv5isPSACL/WID8Vz9V9kFs98j
	YONBwCvwy8YRvLiULjZToUKuGxzWu9Y=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a20bde60a0so19845e9.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 13:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793915238; x=1794520038; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FJ/A2e5X07rBRQBUzH+eXJYmu5j343R3rSFT2KqYV2g=;
        b=so6TMbeQJ+g7tZebvDhiTt8NSB13uOW36Eoi5RFRvi9QdAucStcaowDw+JFh6kFanU
         tGtYWSX2FuMc70aZ3Yr7a8XqchJABMhbp3YG/ehoTBjyJOtsrRic0CW+M4oKtz17U16D
         ndmFoZ6mN9gQAo3KDFw162sO9VfRWdHgJ7kYeflL0DcBEpiRbN0DnrVYHy/n0QYmOedz
         hEOTJRvC9XAej4KPFkaGPHEyTuYXOdMTlEbzhVUtQaK2/6hTzWVtnoBege9AAtMaWKuQ
         1P1wiA1bce2y7E62dxfuS0kzJ0ZqZavNsmSGQSE7fiRylgMJPSr9vj5EkSqIcKDETT94
         quLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793915238; x=1794520038;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FJ/A2e5X07rBRQBUzH+eXJYmu5j343R3rSFT2KqYV2g=;
        b=miDmwvc/B/DAutm7QGhQzdgKgbteQ7Syp5ufPHprCzWzeFXdgesS5vsf8FaV/834CR
         BhikkYD7LHBAYJUp+hAYAOJ32Jo1/iPgZakFfeBBHwXopfJ1M6Zen3DQpFwnzZWKXq75
         OncVxZilXUz0IRfioQIy6enQQUHj8h1uxkPQMvA/+/7TOd9YxXr7CuESoF35+sUy1DQo
         nV3ftMkSYNNU2ogiYywu971KiMpOQK+lvfZmTMPLXjh40rnJdX+O0QsBGjN8frLEzFeh
         Co6A0gi4zL6olatGB0eviPrsSDQ7uQoxarUCZ1G4IRsMqDXgoSOR0gQGs7MsQ+aMOMEg
         SbOA==
X-Gm-Message-State: APuU4Z8e1tNJ6hfY8pgovOJvmwyEDiU7IO0GjacZpiKSQ08AC58cl0E8
	Dniqz87wq7wYHndKFuEYKj9pSXMVpKD2FoqME4RZJ84gryvJ4g75Vcjd
X-Gm-Gg: AYBFou3ruPUg7bP5cBLLgG6udDyX5WxIcWqmC2ctt1XNAl1nOdUxVk8Y8fos6Ed+XAB
	8BUL7qm1IaZypmsvY7K3d64oRc3wn0RivP7DcAeDB3e0L8OS35FvwyahKmispCLwR1t5aDOOX6Q
	yq+uWJxeMatCyWreHokdtFyZYiUGt4kNG3ohdePQ+lc9bBK3RusS6UhRKcBophwVy/T3x89iwQn
	PwIAA1y2A61xurayC7mRQi9f6iZ0+K/RB/VNrRA3C+vsTAYJ6DbIXq17SB0Cy2m9qnUeLkIe6o0
	+sGBlkS3vvVfMzDzfVMevrLto9j7waZk301fKIEW71uG6+c2Yto5GkGiSzhE3/Bp/XmkJZH7Fye
	yUBeWPplciFbZlGJQG4tVjYbSCoNV1oGjxELuzPxtikG8JA7k4YU93olxUuZ129KVCi1AqfrUeo
	kyPMzoaKopGI7exM0FjviHLSi+PfWCWKCkjGbm4CRsa15KzXKYTIAMF5F9adMFpSu5OWTtqTuEl
	+unqR/dOm8lN5kyfU2cDyg/gwdmCHVzwha1/cau2iZ2x4uRraEtbLx3LCPGWIMWZO6CyCHMXEQo
	Yu4tsG3n7Xy9+gdAgKs+70Y/
X-Received: by 2002:a05:600c:64c5:b0:4b0:a7aa:843 with SMTP id 5b1f17b1804b1-4b6df4f1dfdmr6194255e9.25.1793915237988;
        Thu, 05 Nov 2026 13:47:17 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b6c776c90asm8123125e9.4.2026.11.05.13.47.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 13:47:17 -0800 (PST)
Message-ID: <0076d3d4-465a-4dcd-b789-aa11c112b74f@gmail.com>
Date: Thu, 5 Nov 2026 22:47:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] Revert "mm/khugepaged: remove definition of struct
 khugepaged_mm_slot"
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-1-4384bbfe4606@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261105-khugepaged-latency-fix-v2-1-4384bbfe4606@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A28EC1C000A
X-Stat-Signature: fuamy4dzfbhiimz9q6syhgtj4ixdzoah
X-Rspam-User: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793915239-600931
X-HE-Meta: U2FsdGVkX18nFL7HIZU7K/NJ75JiWqD3zm09whdorTVjuuiI0U1fuS9yD1G+OLy4hklg3Yi0SPHQRNMjM+qkvWMA76Bch1OnUUuWAmC3DTSYzCGAtlQnut14OHz0vhMVn1uqohXgp4GC3dtBTjZr5qb3aTk+YtvrjYy0Xm3oOohH9/gpwiyKLu+saeGCvvXNiYH5TWPh6rFncIyexE7Ajios7TSNfuIXC1jFjHSA/PZeE4tFfl+k5Dtnbp3aDBG1cmQUKC8JELmb6ySTA+DRPrspuLBmzOpcclAsTA5bnLLjmdLwJLIYjyEvBpSRDokB1oVe6HBoLJGxoQhxSaBYrmJUd116Z0o3WZzww+dwxQH/+Gy3JOTeblLEwB601u432hU8kCxhsv8IeEP7GX2r3Zml8EltrWVjcV1bZYqYNT+HtdXs5l5Nv1sESqfC9k0YbcTvChuOxxyks9l3Kzcez3MC/f3FJvcYnOaWKmk0BZpFBTkjX5hjqpYI7qmKh664AV6eFuiVHy2z1PGBSNTUp81dLF3CohBXGoU9arVTkPUqWUPoz1s0gMwDJV+38B+XYUBQl4LtayjmcfaGXjzHr28eMuz7ScMi/RESa47PcYFaHxVctLL95YY1UzshlZzSIZgMQunRqG2SqblhlrBJqLYDTFZmgHQlYbQgHt+RUmYTYid5AABrSlw0vLo2OpiS59IoOm4OplRhcfpMbDBygkpdTr1nqeo3PU/s+/RPQmXBBQr57k1QdGAUd7VZ9/YPD2bOzA60gKM1MBnXyiamGGhe+QCb2YqhPv+03Ukx6Enkph11xp2/Fq7/jjBzuuAdOLAWNuTaD8d4qkv5wJj7lFcHRELjI9sOmF3h0UuO7G3xr8OIfJOehJ9Sj3vl11zUofcQURsGF97Rkofc5JEPnxb1tuyKycg04NXmBVK8A+iyPnFWe6XLXF+VYSlG/Es+AqrQz/5NG6CkP16AXaZ
 G0Ixo4nZ
 ehQYWmN19OFaj7L6Ap8WeMWDszdVoZjMKpXqQp8Wk7vqCKL8UfvmfqTYr+QlJM4w2zkJRbYSHlTPGE0d4QK9+bvpw2/eInzL9nHnid0BfF5mxpxLnYjX0HyPIkWXmU38ALy4AO57mo/Jl2L0UbKi73H1lkweJkAJioxtMAp5vE84TvnsF5vyJcw2nNlrs1FuDmVrxN/Lg9GVxKcH1i8hCZMlrkgc78A39ozbT1ty+ge/AxTqc+XPlf/LC/A9+fHnSO4p1bknpJUXbrwQoweK1H62JFfxHPlQFRtxkxBMZcQoWGWBzRfmZ0zPvVtxD0ph13WrAQWY4gLZD9Rhg3YqkoDnKvOzp6SiBdye49Zx3Cxu4aXYzC1x0UCvCrg37X7HGvnxzcY47DW6gnt2CdkrFC/3qD7zDdC9LMUSO8yO6kOG3JA0HVdMWH+MkFQ5TmJZ/ywTq6mUbQsW2Y2Ks1hckX+qKUai4OwIVOOonyUeyueaPlFp3xDpWvq7JA8qJwurPU0angGh8c+UeDgjsVfZcMmMRVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 9:57 PM, Lorenzo Stoakes (ARM) wrote:
> This partially reverts commit b4c9ffb54b32 ("mm/khugepaged: remove
> definition of struct khugepaged_mm_slot"), as a subsequent commit needs to
> resurrect this type to store additional data alongside the mm_slot.
> 
> The stated intent of the commit was to address a NULL check in
> __khugepaged_exit():
> 
> 	mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
> 
> slot can be NULL and mm_slot_entry() is an alias for container_of(), so
> this is container_of() a NULL value.
> 
> This was benign as there was only 1 field in khugepaged_mm_slot (offsetting
> NULL at 0 results in NULL), however it was right to fix this, so retain the
> fix.
> 
> It also unwrapped KMEM_CACHE() in khugepaged_init(). This was a mistake,
> and was itself reverted in commit c14bdcc9f274 ("mm/khugepaged: use
> KMEM_CACHE()"). Therefore, retain the KMEM_CACHE() form in this revert.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>


LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

