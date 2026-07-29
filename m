Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 862DBC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B6AC6B0128; Wed, 29 Jul 2026 10:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D886B012B; Wed, 29 Jul 2026 10:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3D76B012C; Wed, 29 Jul 2026 10:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12A886B0128
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:49:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D37AB140634
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:52:15 +0000 (UTC)
X-FDA: 85041197430.21.ADDEF65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0A4428000D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:52:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SMBofCzT;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785315134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYCRDETS5dI5i7sQBYk0JlztdxKG736m3ZWnBU7yY08=;
	b=GGyzXeUF2hap4c9UKoXeERVWjD7JYMAk2oYX09W28WC0t952IBQZVW/lGBvtmfcxqOssjl
	QEMzewM///LgM8e26UlfgfV2d0uavrp1kafp+APA6Cjmk1EVW5c8SS55aJEfnPJFWQqxb1
	9cGxnuA02SITx05eyURyHooEPRda0UE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SMBofCzT;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785315134;
	b=b8zw9I1TOREbmjBRw8t1iMzctLAz94gCmVbKDG6KvHLPc9HJ2MFUMH+rlAXZNN5i3KV85Y
	hOo2j1mQ7NmRRJPLSLVs5UBul4IFzURwOZY1qPc9nNr6owr3DTqMTyklIbwdqOk5CrpeSA
	Kpisd8lu0HGXrxxuN1yl1H2GB/jOxeY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30BC340694;
	Wed, 29 Jul 2026 08:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DF91F000E9;
	Wed, 29 Jul 2026 08:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785315133;
	bh=lYCRDETS5dI5i7sQBYk0JlztdxKG736m3ZWnBU7yY08=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SMBofCzTBEg/3tHBjKYQzFrRPZgXFQ4Vi6xJLpf5IJf0vlWxsnprH1FKf5OYoVFlK
	 1hRCzkpNh+Lvt/LkZyjPPYNWFQ5DigcPjoW17VyqS8ZKP0io1czw9RgqXURhYlVFKV
	 7KL5++EJruR6tHPa5B5dBnAJrFQQCuV4iK5aKdHCWxaf4uEDNvNPa/tSfAL1ZUkrH+
	 MrfWXvF8q9vIhBGmndVyDm3DjcFSLGghszFtk5yPfI93FOJaV4Xs0tcs/QCY0E7d4O
	 q03KOOwiPe7D59XDUHXJL8uI5n5VlE9yENkX7IP3nYTAcL9VJZkXQOyRseK6clRd0m
	 RhKI2n0Eo//iw==
Message-ID: <de52f27f-7248-4f29-b37c-922fcd6e31fa@kernel.org>
Date: Wed, 29 Jul 2026 10:52:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/hugetlb_cma: support percentage-based hugetlb_cma
 reservation
To: Sourav Panda <souravpanda@google.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org
Cc: surenb@google.com, fvdl@google.com, gthelen@google.com,
 rientjes@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260628190155.3655895-1-souravpanda@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260628190155.3655895-1-souravpanda@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0A4428000D
X-Rspam-User: 
X-Stat-Signature: mfkfs6aebxeneirfjb51e311wc7pa34s
X-Rspamd-Server: rspam04
X-HE-Tag: 1785315133-27184
X-HE-Meta: U2FsdGVkX186SHRmBlOo66zsRUp0AorotLmjbJ6pj13q5A0gYCawNHJ8WaXc+tsRiW4YlSbOCDZ1zisOeb8PxRLiXjD49U3KNthhor3so18ksHmPgc39dg2I/TFx1bGW/sipnB3AP4XLtrR7hTFKKIJkfi015ct/U+z3J99JBHuV5ztHdg1u8+UvinHOeuN+zCmDGyRQJvq9ZBnPGh5qxYAXHH/Up/1ktAhtozXmBgyfmHjWMmiMEZbB9wcyTWJuo2ZmmmQUfbTmABkggk8F1bh8MGZ2TfPBvqnLenIm6H3UAJYZMlV3pyqgsNmxKM06O23MGw6VYtLITYynbL+8pCzSZoQ0jMBYeA4YOvWHP894y/JN6GECCohp6yTN7aR7ZLTFyjX/H8LUCLv32GFA9fuI+opMSeD9+YegpOVBYdi81Pr/rDZwwSNe98VmtL7vUvtj0+lQyrqkRyl/ZaI23Ro6w4gwEXCLJnE4kZSaIMjW0gmoJpxRGthDPLHyimw+amYOZTzn5YUesffr9olbvZOtKEDlOTchseh21BVbKOAFeT7GxMeRCvEnMa3qcCRx0uq7UvXKTbuMIr1sjmb6DDmAkLB0j12M0YORftTUH4+X67JaLdUlAzyXGCEbyKxrY+LG+Yv85LvLs2MrkJRM0cQlZO1TXDmSQL1iKOlLHTnWZDKXprhTer9yxm87FA10SVvoQ+jJggZacatdL/pb8jYwe+UYqbfSw2x4wkh9g5t6F0XiNPE5/0FGEU9MQRHXSxvta0+2m/MUqkuuWKSCypmxmGjjeE1eIAGBQUefwzeTrgD8o5tHsVpns1eDd9ru5GApIxUi+cyNoRtyH2/xODP55Lj4pdChoW3LX5aIZFD5ihHMY47LyX/b45YVl0rglTmFlvrJsJN5gPpAhD/mTIHRMV5pzX+68EbfAQRsjTgYra7EU085drGyarB8nkdxEVKfVG0h+XSjU7qG8LG
 jB+8U80t
 xUEJoyTZ6rYYIEZ7ULQcLT0g9FBSyXJDEa1ChEdvmqNQFzNKNUudAqOlA7jjO4dlzkEYZbmFdlLiGDMl8b0bf7QJ1842g3R2hKBPQHteAygXJRTgEGaC3v8A4kbwzBwJ/epWi9vvXzQPMlJP7CzsAgSamiyF5ZTluhpygojzZVj7h8hLXWXI0r8ATUs3Mygkny91WkVmfgrlt5rxiVkJWQt+1MsOjuGCOIxhfpJteArQ1Udvh0fse0A2R2In2xNPfCf+BtAvbWEO+Tq2SW6FWyWSo5ofG3B+zWJYCngaTHGbkH7J8IgdyF1i5E4LYn4YsQpebnL3YsR8inTcP+FeqcNT2sNfs5HB3RObYgvfgae7+p8/MSWJy854oiOejPZ+BiGmC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/28/26 21:01, Sourav Panda wrote:
> Currently, hugetlb_cma reservation only supports absolute sizes (e.g.,
> hugetlb_cma=2G or hugetlb_cma=0:1G,1:1G). This can be restrictive in
> heterogeneous environments or when deploying common kernel command lines
> across machines with different memory capacities.
> 
> Add support for percentage-based hugetlb_cma reservation (e.g.,
> hugetlb_cma=20% or hugetlb_cma=0:20%,1:10%).
> 
> The percentage is calculated against the total memory (for global
> settings) or against the node-specific memory (for node-specific
> settings) using memblock APIs during early boot.
> 
> Signed-off-by: Sourav Panda <souravpanda@google.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202606262023.IKUrn01I-lkp@intel.com/
> ---
> Link: https://lore.kernel.org/linux-mm/20260625215900.2151690-1-souravpanda@google.com/ [v1]
> 
> v2:
> - Use mul_u64_u32_div() instead of mult_frac() to avoid 64-bit division on 32-bit architectures (Reported by kernel test robot).
> - Fix physical memory size truncation on 32-bit PAE by using phys_addr_t in memblock_node_memory_size() (Sashiko).
> - Fix boot parameter override logic to respect standard last-one-wins precedence by clearing opposite values during parsing and clearing node-specific values when global values are parsed.
>  .../admin-guide/kernel-parameters.txt         |  7 +-
>  mm/hugetlb_cma.c                              | 96 ++++++++++++++++++-
>  2 files changed, 97 insertions(+), 6 deletions(-)

What's the status of this? Reading the comments I assume a v3?

-- 
Cheers,

David

