Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C974BCD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159336B0005; Wed, 13 May 2026 06:27:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131896B008A; Wed, 13 May 2026 06:27:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0463E6B008C; Wed, 13 May 2026 06:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7CC66B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:27:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 904651C0755
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:27:21 +0000 (UTC)
X-FDA: 84762019482.29.05AA21D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B2866C0006
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:27:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SNJY8EZ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778668039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lu2Dme3h8zfRIad+oAMv+dzVxXuavqf8aGob1xn33bI=;
	b=c13wPGtMR41eHJ0VTUDKHwZJT0Z/orcL2/augPIJKz6PhcO3d73YvtVs4DW0VUN+XEh+3E
	bh38yxyceIlekM6CLbHv0cQSrQbpTLlouWfS9jROdGvNSNkU0Q5X1OsdGMEzG1My4vtafL
	evxVNkGS5PwKyg5R/jv+ZLx6ExMw2Io=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778668039; a=rsa-sha256;
	cv=none;
	b=xe+NOcbl8awKdvoAcupyk9osBm2Ue888b09qTK8sChcMH4bWTnrA0/Z7iDjN548KnH8FWU
	M2UY0T9xA7IgbmmnLNAU/fatdxY/yGtfF6ipjq/3JxnjMpsQobJ3GKjwG1ReVoJD3RK62I
	3x6cnGyFHVfFXVWwsiyat7nYUDGPmhk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SNJY8EZ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD21F42DB6;
	Wed, 13 May 2026 10:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A17C2BCC7;
	Wed, 13 May 2026 10:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778668038;
	bh=9wsKnlDCa0zq3SwUnyJEwva2pHbz7RV1mkTvnS2jSjo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SNJY8EZ9GstqJlYvHdyo7od82nIYw5ft/y/X9Hh6pwvJnAxJWfeTR9TV3XkZiv6/O
	 F3/3GyJyG9f1A9BpVEsnmiwCm7HmtCtxUgysSBwGsVGRJbNzo/S7g5dKkQxtQfo931
	 MO5tSuTn3fqUUP4SPoPFXCETjwluj+4KF1arT7MfVzKADZBQ3PUQyB5DoIt8lg5oL9
	 z3UF2OxBIGS7w19+GXPwfkl62qUyjw/M2XFLhwnVn6iE0HguBokzhBxgMaQlURH+oG
	 w55UauEQCzGLPtKeNo+DK29sSVwc8o/eKUanY2aQyWYWoPCh4sf5r+kdMWZ/w3GgGC
	 VvHgBi/w8C/gA==
Message-ID: <691bf8b6-32e6-4c3d-af98-a7730631e810@kernel.org>
Date: Wed, 13 May 2026 12:27:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] tools/mm/page-types: Fix kpageflags option argument
 in getopt_long
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260513022120.58033-1-ye.liu@linux.dev>
 <20260513022120.58033-4-ye.liu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260513022120.58033-4-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B2866C0006
X-Rspamd-Server: rspam04
X-Stat-Signature: bcab7n6hs9ug5c7znrf7erb6n7zij1cj
X-HE-Tag: 1778668039-875167
X-HE-Meta: U2FsdGVkX18Ty5a3KoX9w8YireIuNqoTk3s4UWWfC8bdKWIeTUVpXGb6WW3z9iBVUQ/Qug1f2l8syk7dLts9d/MDs0QuA1UttpFvzsr3N3DKP94TIKCcsndwP1d/UVuJjKzaK3Dyprc1TPT48wXkcNCmDwhdQ/Sbc8kIWe8VCJDZVfpovrsXPUrbBQXUkiRPygV6E55W4gr/Z17htyLM8Kuiiij2HZZj71ji4wIt5b8jdiYkfjYftnizZLKauuPZQLqb6XFUgVOSqxGB63Zvq9UUhXS7+pCF/EKicZrfu4e6YCPyux58dq8pY+kJlCQQrJgDxXI9ovUtGrH1H/IV7tYOgzmw7MGGUe3m0MXHKoG9l8htWxJpZK+wS1UWTzZZs0zRD9iRpWv6izA5RnZH6eT4qwzTk0X0pmSVtaqMWxkxlvKwJKPpR/eV3FncnjsXXr4PnVmelvsXauaRqSz7LKZAkI1iW1GUhJg9UsbsbiIjwODU0D7tsB3xYxfHp38ZLW2UMxj3FIeeAaKX/PgvbEWjLm2ZQv0jBJc+pyTnLXe3TcFB5EM0NNwc9sFsP+aclmnu/VcQiLgPPHBvhHZh/xhUXhd7xqa9oOvuMOqEbd72Ft6epRxGViw3mxQ9em2pEBbLcE4cE/SiWe10N2Su8GjutAooNI/hTscvOriQDUvg4ZN4kKWHZvwqCrlFefgaiwg8pGzKNXU3qPLfV643T6cmc42WWNp0hNJWwaT306sdsnetvnQLAgMChKqHa8ued+TpwIcLuKNyUQ2KkX+rXkWiI/InxE+uUU9MhRuQk05EqmePtUppzjsNH9gQX7NE6UAOGIb1w6i58UDJYOcDPRNwUDXbIZS7zcxar2DYl7L2IHn0wwnrM16awH4bEjC0S9k4gPvJFvkQWWjEunNZENNG6bhbN6Y1iBQtiAizuuaM1BuIqtAffgYDKevyBCaNdcrfJqgjo9yuWT1L/Sz
 AZXNXnJJ
 R+vmdF6/HYnqvJIa+lwbfXopXKJFyVobGvmtOt65x3fN5ByqmyLmpRQQo7ohTag/gprz7aE1xpsMIOTHX3erxbhgMiMszICFmKck3e7vyjQn3jOkBAb2RAslYezG/889P+C0aoZ9NyNc9ROxRFuhxnGqZFCcZVehoN59dc6jFlczxAkldm3kTCGNSNTlEoU3GB9/TF+Lu6dizsXE8fBNsmq1xgEFDzyDt5ciNbhX9FQeoOKSVrP9Fv2w1U8szqEDmClidcQhI2DuSyI9CQLPm+abTTT4dscD87fRNR/TUHC7Yx/5o3CEcKWk55wgy3J0S2yR/xT+8C7vt3JY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 04:21, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> The --kpageflags option requires an argument to specify the kpageflags
> file path, but has_arg was set to 0 (no_argument) in the long options
> table. Change it to 1 (required_argument) so getopt_long correctly
> parses the argument.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  tools/mm/page-types.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
> index 66f429f2b698..7fc5a8be5997 100644
> --- a/tools/mm/page-types.c
> +++ b/tools/mm/page-types.c
> @@ -1261,7 +1261,7 @@ static const struct option opts[] = {
>  	{ "no-summary", 0, NULL, 'N' },
>  	{ "hwpoison"  , 0, NULL, 'X' },
>  	{ "unpoison"  , 0, NULL, 'x' },
> -	{ "kpageflags", 0, NULL, 'F' },
> +	{ "kpageflags", 1, NULL, 'F' },
>  	{ "help"      , 0, NULL, 'h' },
>  	{ NULL        , 0, NULL, 0 }
>  };


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

