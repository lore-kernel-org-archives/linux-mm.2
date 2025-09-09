Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83802CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 06:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE958E0011; Tue,  9 Sep 2025 02:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6568E0007; Tue,  9 Sep 2025 02:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEBB58E0011; Tue,  9 Sep 2025 02:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BEDCF8E0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:23:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 697E81A03BB
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:23:40 +0000 (UTC)
X-FDA: 83868720600.02.AD2B1C4
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id B7F0BC000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:23:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uzEcs6A2;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757399018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z1Wkb174DBn870xlUkeOU+s2jwTcULtI9clHVJAqBRQ=;
	b=tKZm1oixFDjN+LSQbJ0ko/ms3WbYLN5cCPrZthBc2izfaRU5xwxxBb3nRVAJHCMYtOg4Of
	Z8SABtG14CmE3Uvq6+ni1YWl9MMRLjfIJRArWCaUaYB2cq67d5Wm5MyiPjwkoFGYniZqfj
	B56nxijTqV6h9sAS7UmANwpzMic2e/Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uzEcs6A2;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757399018; a=rsa-sha256;
	cv=none;
	b=1TUN+cGlLsSQT0Cnf16pWRrEbsO47eIKL2lL5l3U+0gZ/Et4y+nZalylO9jDbg4Q5IACu4
	hthPVGDp72woDZaGxwatjNrXyGFY5bJxI6Pw0oxRM7D/iqIH0Mo75zhWSVGEMQJzdfPu64
	FT5q80Idgi9/cN0MqvULa3wOpNzBsgs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757399013; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Z1Wkb174DBn870xlUkeOU+s2jwTcULtI9clHVJAqBRQ=;
	b=uzEcs6A2JfZTNO5jMr+ncEOJPG1Fiyjv1Mzq0/YKWQ5jQi0jwJyR2jVRwESC133tVa9t03FJDmS3unMbw4yx4IkGr9PuRXcB3s/n9IEMBv3KQ7P3500JQTK5uKao3dxg0eN3SORLE7QXvmiGxdnmq6bLACq5Jzb44afQFvWLsFk=
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WncsZDS_1757399011 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 09 Sep 2025 14:23:32 +0800
Message-ID: <09420e06-5acb-470a-9eb1-5f35d8b2a6bd@linux.alibaba.com>
Date: Tue, 9 Sep 2025 14:23:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: skip mlocked THPs that are underused early in
 deferred_split_scan()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com
Cc: Liam.Howlett@oracle.com, baohua@kernel.org, dev.jain@arm.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 usamaarif642@gmail.com, ziy@nvidia.com
References: <20250908090741.61519-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250908090741.61519-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B7F0BC000C
X-Stat-Signature: 9jjh3xentjuxei9naexjqyxfa3zu15zw
X-HE-Tag: 1757399016-939370
X-HE-Meta: U2FsdGVkX186uuGZ1OhMKSlaa0xflOJvKVkhUMyM5FKhBy74EFGOnY5Ot1nWrStOuhBLYUv6gOETYepsQvICAZHRvHJErFRfGHcvdri22wecZxnPF5HxRNMcd6gQ2GdeLkVINJ2N7kThVwBVlZcoGlvDAodXszQdaXkG7kUp1ruOMPE8eh+u20diTbwMM2P7+Y2maXOotZkOve6q9luGNkAUfltmBMO4fBcmH1JKOkXPOUQbZJ3KrQhOGncwXcZjkIhr9wQUUFZ3qUQmSx+qJQLid810b6zeJxt6NUmH06IZiAHsH5h/sFNKriLoutdziivcmvpsd4TDAM43Ehy57uT3ETE1C0Pgv02tSjAYZW+DI145/Mi+lJX1VGtvw3/XLcZSQx/edw4+nVKazVrwKBwY6FFtmfJcGM3Hxm0DY/Qb3H7aXOTy5UfhTlTk53RdWPp4TlUMXQEbskuJ/CssrajjkF/7PLdS2UqbS2Zep5jd/ipK30EGX4VZX1l4da+ReKbmAMXzecBVr1dDCRbxM6MUanYnR/xK12cShwIKGcOjITzh4Vpj0Umz3dOfR6FNqFpjt5Phku6xIT6AXKahFaGW/x40+9f6xW8OMAub/ulV7DG84PVr6c/LffW+OQntVE/9bUWfmPf7EBtxoWeD3NRN9M0cSOTQFIvx6yzPGh82hltgfjFtgFW/YWyDuIgawpsujUm2ILqMm5Qe3xDOTu+ttsNkE10Kr84zxwOHcETg0OELEQ9+tsM5ZpiZ9jJJBiicVdu44bYu0capDbwayIniowqKHnqj3VACht3CWEMsyP/ebqA1w4GI9h1g17fkR6+p617fIodYXOsS7LF3Nbrmza8eNW+62fEmZ635JCHgHyX5XRe8jlFmQLdbyw7pzl6pwtjK86Cu1Gy5mLaT2t8/uW7QUJH/jj2AI5tSdculX9XIA/p+iRll2hi/TvhRYHN73bgK8Y1Utm0teYf
 7cv2FVaX
 8asf0TTz6umZLN00nO8qwPqyFot0odOHNzWczo1E5Ko/P6px+TaW8PrwukYe/Mp5PysjYy/1QR0wQyQpjC9/Jd1NAFZWuP93T1Kye9mW7VYPsQjHzz8zP3N1R9QVt9RrXE86pKqHbNOGH+0GFQzlCdQy7bt9nvZBhxUc0EsYN1iAZDh6m38SrR4qa9gJ16uhO3HKLBtI1vwI9Y+WnWWOVZ2aNq484+71E8hs+zgA19NIa+NRu9v4L9HxCq07euR72auxWNTg9WP0Zf42j5SRZ9fYLWOXBq7EF2AYHd4G7hG1uaCdJiQY0bL2A5EaAYv3dcCsgj5o/OeoPMRrQ1ZKP+KI/871bNghwZOkNXZAGlkFPu8cBsLoYrgbh9YZz2shxXg+s22aVp76loX4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/8 17:07, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When we stumble over a fully-mapped mlocked THP in the deferred shrinker,
> it does not make sense to try to detect whether it is underused, because
> try_to_map_unused_to_zeropage(), called while splitting the folio, will not
> actually replace any zeroed pages by the shared zeropage.
> 
> Splitting the folio in that case does not make any sense, so let's not even
> scan to check if the folio is underused.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

> v1 -> v2:
>   - Update subject and changelog (per David, thanks!)
>   - https://lore.kernel.org/linux-mm/20250908040713.42960-1-lance.yang@linux.dev
> 
>   mm/huge_memory.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 77f0c3417973..6d99893c18e8 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4183,6 +4183,13 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>   		bool underused = false;
>   
>   		if (!folio_test_partially_mapped(folio)) {
> +			/*
> +			 * See try_to_map_unused_to_zeropage(): we cannot
> +			 * optimize zero-filled pages after splitting an
> +			 * mlocked folio.
> +			 */
> +			if (folio_test_mlocked(folio))
> +				goto next;
>   			underused = thp_underused(folio);
>   			if (!underused)
>   				goto next;


