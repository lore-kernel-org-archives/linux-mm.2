Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 795AAC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 12:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320656B00A2; Thu,  3 Sep 2026 08:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D18C6B00A3; Thu,  3 Sep 2026 08:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6F86B00A4; Thu,  3 Sep 2026 08:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7C696B00A2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:39:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 80D7F1604D0
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:39:31 +0000 (UTC)
X-FDA: 85172406942.30.1473219
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7F20C20008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:39:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Inoo8fUP;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788439169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ryI59nFheCyodltaNYiaFw2/xCwHS5lRcpCtYO6UO8=;
	b=5detIrUUHFEB6+Qj7yUu1ueQAZzLf5ED8lsQoQ0efkyJAUVDy4uXQ+WpNWaHsu7TDjJyLE
	gZAMqoeeYqfppSN1ENM7e9qpMLgK+WifVv8z6maQf3kCgd9AWfxeIpV9E2mnEOP5CD6b0V
	W3emOolQWmiF5VrMPNrQU5xvR4JVOUw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788439169;
	b=M7C9cwJAaPLDLzacxoju8xoOhdbocvcS1tLZNgQ5OVuygtlr2cJz9pooyUtZUf3LIOQ8Rm
	CBlH45SuEWEZ7uRyQisr4ItHxQ5+RfVBMMqIAVH+PPknX90cBXDPabYCTQU/oicrQ0p3Ng
	AGZ320lvlpVBkFQi4fZWgIHAmvjBidw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Inoo8fUP;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A5D8D410A3;
	Thu,  3 Sep 2026 12:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05C51F00A3A;
	Thu,  3 Sep 2026 12:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788439168;
	bh=9ryI59nFheCyodltaNYiaFw2/xCwHS5lRcpCtYO6UO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Inoo8fUPGSNJErxjcu2YCMxci49DLzOd5zaOA4Vbj0yx43UjFdql/ieUY8GuVL5VR
	 UYBNyKpbpS+1IQjpAPSKab2ElCpMF+xXLZuvq1USTjFRLmfzYn9dVFTMmKOicqCmvv
	 wLofrQxS3HJh27LqOGEqJCd3TqPGazfJfh/6xsTy1xzUw3VM8wGxjhp1y8hEsNicTk
	 7uZCZa0CnfhWVb+Q/a9v1X21NoaQjTBEGCg5yOFr3ddY2AK5OUHc0ypyt6rvPDouao
	 scyo46aH+/bgUPEqhMj1m9k7vlezKCy1TO+isK9/RFIn8qrVgxkmFX3J040v8mkxDX
	 8J53zeGgvxvkg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8B196198003A;
	Thu,  3 Sep 2026 08:39:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 03 Sep 2026 08:39:26 -0400
X-ME-Sender: <xms:fGqZauPqkognvLO22ue7MYKMtaaL06W0DJXtdhbCF1OGIlfm9ocDxg>
    <xme:fGqZakjEa9-8LgEmHQN0uURotx45Ldev0j-KRJ4fOWn9ZABkC6P9qNlMYvuTgnYhy
    Y6ZrbycAL7K8359QtaemOuZu-Mh3FSX8y2Vgm8FAR9HTBoY4NHLnh0o>
X-ME-Received: <xmr:fGqZak5NRnAjj-ZvDc06pxtf0rfSJb_xQO1UPA5thiNXRRe-n99fIP67zZY>
X-ME-Proxy-Cause: dmFkZTF3zqPAAnIhb1YeMy24bRFWG3v32j09ZcqUOBuX3KYWzX7uJHPyWLP1Hj9+S4IwNa
    PEy+WtiDNm+MM9ovDxTHTFHgV04t/PKrt0NTN2ImGOgKC4nHBzHRP+V+NxyT+08Bw87TIP
    xDC4nnEMRVpoPDvzrvVp9/5IZQW8mgfOG0RwDIlK2TCv0z/bMQfFNMgnsMbeO0IPRHxTqE
    iW97TQlsSv9lKHgjhUMt4Sbntwm6GwEkMRqP0CPAl7hHyI006Lnh3QbvG4Wjp+y1LpKi8x
    rTWSl+P8HlEZ3jJJh9dvoiRgnQ3kpBf8Z3mAxfDoB8l/wr5EUjDhaN7di1qQ8wqK5RwRcg
    Tq1uklzx6pXzETlUF0tyDjbgcjmvjl7QmUvkQjOMPzvrColSeg5ZmXqq510TJyG/7ZyPyh
    RJCoz2aQNYCKgDtjTYbz3puc4VdUHq2W4TZ2YC+GaDCN6d0b07AwRoj0Ue/2fHA8M4hSP4
    8KqmvyJ2odJp7N61NrgMzMvbPE76WPVOGQLYG8ARqhApN6595Owmkzn7hEhaVQct5WLi7c
    Db27T3XWTxzdKzVCOI8Ay045x4cc2Nkri+oSRFoRA++Onlp0P7ayTUlt0ga6SCgFWxxQP8
    6e94A5yG7KJDM3FibVG+VZjuBXbOL/O3Kx9KU+PuL/NNWqDLGGyO2vkG+OVg
X-ME-Proxy: <xmx:fGqZardd_pIo-mypn-5cHUYN5lCsKTQy5MDZCbcxrXqDiG3q9LzCvQ>
    <xmx:fGqZatDYhUl6DJFgIzmturDS6uUSJbhUSSP2ywuuSxMkYiNO3pMyQg>
    <xmx:fGqZaqBuDq6kROnAhM9fG3_dWo6DCopeBGn-5mo2ukRZWLKVNu8NuA>
    <xmx:fGqZavb1BEVb8GbuaBEXLt1WMLttuqklOmmIo-Hq3n4oDlLXCCEehQ>
    <xmx:fGqZanwJRry7LHd7EMAiJvVYi6vDq9ESarqQgB8I0vLYmqNXbkZFQB8b>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 08:39:23 -0400 (EDT)
Date: Thu, 3 Sep 2026 13:39:22 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/gup_test: safely calculate GUP batch size
Message-ID: <aplp-uM2oQtjuWnZ@thinkstation>
References: <20260903115033.162218-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903115033.162218-1-sarthak.sharma@arm.com>
X-Stat-Signature: egoti8mbtker3ie9nqqxpxgowt97habx
X-Rspamd-Queue-Id: 7F20C20008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788439169-318656
X-HE-Meta: U2FsdGVkX1+spiyQ88mjuWbpD5B2IP5UPMn2QxWat8zVy43JEpPqteK10Qk7k7rB1dug3WAaiikDEkqgNPd4cgs0OxzewugEaIm7oTgapJJuwhrCT0gwLlz2Jk/UGsZuiuvjDTJJYHa3ngv2oQu47yqBAlUvy/HW9iOIezzQeMFzEHxTLGrHprVzpTJSBdJ3y8dUTEpDzWWdxjjD7RRbGLub20/YA9LUhczh7sQWQ+CmkFOfOfwQmlhFrZzg6O49t1w3HkKt73EJfZc1EnjsK14L7S+MweKThPpR05L+sr2nrJG2rhSf8JzhvMGAmGJDmm4r7t8DT51tDuQBvEmcqDuI9YiJ+KYuEVwBWHF6474tCqOSYAykqT+AQJfvFndhilvolTIRUTDqXqOzJQNpGJuem9/CJjAJ/jw9xSP6sACSqYbFJ6l3Q9veGZkd9eJNdqVLJjRPqd0iJUdRoJlWUl9Ith6NR1ZwSERrYaapNkh1TtrT2em86ZT4VBStCdvtC2eGL7RBt2sl8KOFOPx6VeLpJpOWUpb6dBI5q6qIaigMLE9UnhxBshTcpJoH59HiaKS4opmw8ysHZiKfhUjRZAArexCaWB/gzpE2rAHG1+IapACjKdHZrHG6L5tcVGA/rFGigkspYDeo27tiLKKlC438fnULbKqiwu433YcLUd4cXBl058Nh65vG6PXWJlAjlCOwCC5uIMRzuQB6pyvL/INhEs2mmh0eLMlB6Vndi+bLtYSWgqXSS78ag4t023hzaCfZC8nu0ys9uUxZcmCnjzh32yGPEg6r+D2aXiaNmg/uTjhanjx7k/oE6q+1ixFKbirq7gD3FWuvGwYG8VicM74abXm81KZbFGMg98owFHnE9ZWO5CMhL+QYED7sx2w3m+YlvVmdDzsIyRuEsG4e0Cp67bCVDBjgqcvLnvvTKX1mEm+DfTgQTjy8Ds8w01SgaoTgiupFTArBIkCiiqV
 RLMBKyvs
 AgRNVScZ54sl7lCFOK9T2lAr486kCFokjx9R34IeNKTGHV8qvfy8mOYXmVN/37GuMlT/DMQexNRBwnHMBWGb/wScKKDkc+5fjkhIT+hRraXYIiwXEauTTLT6zlb0U9apB4drNQGDARlteiVw6NMvM8VFOk5CrTM4GaIehVLN0Rzm0U0STRZp6GOMEARLnn4XLNqSGz2waCNWc0cJml3QuXnLROEQVMh0/LnVZUIlNcVqDKBqC2WqRA3Q7kzMWQz6gVlfuGgDHPoVXLrqPzIcnM+o1aPHbd+6V3oyQBeN5D4j5IK6waxIHGkc7nagavTfqJfvaL6QXvf6pIAVmzK1bQ/ugaopWt/A/R0IEPwZuW7vN1ENzOlKZAXVNv2dl2X58ojUZajmEiJNtwC1Iwy06BvesBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 05:20:33PM +0530, Sarthak Sharma wrote:
> __gup_test_ioctl() calculates the end of a GUP batch using:
> 
> next = addr + nr * PAGE_SIZE;
> 
> If nr is too large, it can cause next to overflow and wrap around.
> If it wraps, the next > end check is bypassed and a large value
> of nr is passed to the GUP call, even though the pages array was
> allocated according to gup->size. This can lead to out of bounds writes.
> 
> Also, when fewer than PAGE_SIZE bytes remain, the calculated batch
> contains zero pages. The code still calls GUP functions with pages + i,
> which can point past the allocated array.
> 
> Calculate nr by taking the minimum of the number of pages per call and
> the pages remaining in the address range. Stop processing when no
> pages remain and calculate the end of the batch using this bounded
> value of nr.
> 
> Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

On nit below.

> ---
> Sashiko reported the issue fixed by this patch while reviewing the patch
> "mm/gup_test: report actual pinned bytes". That patch has been applied to
> mm-new. Since the two fixes are independent, this revision contains
> only the GUP batch size fix.
> 
> Changes in v4:
> - Simplify batch clamping logic as suggested by Kiryl
> - Don't call GUP functions for an empty batch
> - Drop the pinned byte reporting patch since it has been applied to mm-new
> 
> v3: https://lore.kernel.org/all/20260901083452.115365-1-sarthak.sharma@arm.com/
> 
>  mm/gup_test.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/gup_test.c b/mm/gup_test.c
> index 185ba3bb8ed1..1b64e932c4c5 100644
> --- a/mm/gup_test.c
> +++ b/mm/gup_test.c
> @@ -139,11 +139,12 @@ static int __gup_test_ioctl(unsigned int cmd,
>  		if (nr != gup->nr_pages_per_call)
>  			break;
>  
> +		nr = min_t(unsigned long, gup->nr_pages_per_call,
> +			   (end - addr) / PAGE_SIZE);

I personally would rather have it in two statements, as I suggested
initially:

		nr = gup->nr_pages_per_call;
		nr = min_t(unsigned long, nr, (end - addr) / PAGE_SIZE);

It seems to be more readable to me.


> +		if (!nr)
> +			break;
> +
>  		next = addr + nr * PAGE_SIZE;
> -		if (next > end) {
> -			next = end;
> -			nr = (next - addr) / PAGE_SIZE;
> -		}
>  
>  		switch (cmd) {
>  		case GUP_FAST_BENCHMARK:
> 
> base-commit: 178b3d97bf1f15f598ea7cc615a40c115e528e1c
> -- 
> 2.53.0
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

