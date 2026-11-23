Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43114606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kWphZf/y
Received: by kanga.kvack.org (Postfix)
	id 5E10F6B05B3; Mon, 23 Nov 2026 06:10:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 591226B05B4; Mon, 23 Nov 2026 06:10:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CEC66B05B5; Mon, 23 Nov 2026 06:10:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E1A86B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:10:14 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B701780820
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:10:13 +0000 (UTC)
X-FDA: 85466114706.17.1E2F1FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id EFE5840009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:10:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kWphZf/y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795432212;
	b=3lm0/msvzyDtwkDpwH4HMu78EoQ6fKzfqobAtyyjSh8ZFeOSfYEQtLe1wgH3fGu1BJ6y2G
	WRC8DKDB/Nh9FrMNoC+152wAExaUKhjYQAc9fGdmLSWSYxFSsPlmw1e/6hmR6z/CRpC3KO
	hNlFqcafGq3C5mXvzqNWU4q3gJyo4bo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795432212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jB4Jc0m241bDmamiVxwXgatL0MljUoYCzUMg2HcGIDw=;
	b=SRFL5LSno0hfNjrQ/UWPsfWf8CXsCFkdsdBOx0Dgf0/+R7N97q8lMp7RbB6Cs2duz8HrBn
	7D0nKLHF3WKME9K9vw2tqXk9Dh0rIxCDhHuaBjyFYB9BoHAAQSqYhBKGbGgUZyXfvZ5A0K
	IfYFzONpkBhUHlrW2GWodkmqROn3w4A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kWphZf/y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 388186207F;
	Mon, 23 Nov 2026 11:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6620F1F000C6;
	Mon, 23 Nov 2026 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795432210;
	bh=jB4Jc0m241bDmamiVxwXgatL0MljUoYCzUMg2HcGIDw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kWphZf/y/YIu6XBeBrWtheRyIohUen6aDmlkVygIEOIPi+zvDVA8TPW/TlPfDRERB
	 wWsTV6Yaf0bvFcBzGVZ4DwcFJwpH8z6xzA9u4SHOLfoANmFC2z60x7HvZYUW1dy3Mb
	 GFUSICJDM12Ry7j6Jm9tRjY6nj7QDTJwgHwicVHo2rDAQT/XDRxdCzuB/a3ogiZ7lX
	 NX77yuyXYTVL5Fctzkxnr2CbuX58PtQcAZAD66u5Vxcub+OLrgbJJsU5NJ9mJzJ/4Q
	 ncogL9Akmq6+ia+VBuaAdRU3yyarubZbzAguIgAvkR9T1xR8jD5S5T9KAGb1CefH69
	 FJrAY5Z1IU80g==
Message-ID: <0c29cf1e-0234-429b-adef-fc7b52290906@kernel.org>
Date: Mon, 23 Nov 2026 12:10:06 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/mm: Preserve the final page owner record at EOF
Content-Language: en-US
To: Zhu Jun <zhujun2@cmss.chinamobile.com>
Cc: hannes@cmpxchg.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, ziy@nvidia.com, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 iamjoonsoo.kim@lge.com, linux-mm@kvack.org
References: <20261120062140.98503-1-zhujun2@cmss.chinamobile.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261120062140.98503-1-zhujun2@cmss.chinamobile.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EFE5840009
X-Rspam-User:
X-Stat-Signature: 3d13onj8dkdp94qd77tkt1e4r6owp18t
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795432211-27924
X-HE-Meta: U2FsdGVkX19MAq67MK7DCmvAYr8Hp9Ql7s8/3IVq+qgVYlLyGCSm6w/mm9IbynDYc+fH6zUCvTNDjNFLFcw9cdpWwaGiDOr9SURL9EIIqHcFmncx+XuGHeCIHFIcmqWa/u7QaNcIIxLyofl/KGNVXKbEr5VDlJDF3bDF3zegwiSA+bS7zqfQBgHsjArLYcpu/+Pw0srYszLEMMoaD9uoiTz2+JX7k5I7oXdM17NMcVtrDr7Dgc1hdcpFUeACZpCBhFg1aWnDjgvQ2aC7MWKYM7C0nz6PeHJ8FPJtjHuadBpBjYmTCDwRhd9VUf9bDY6qR9LMHdhOduUx4wrYozsQDV2vDUDi9mnROVTuvRM0v8SS/vK9QIrouApE6/rFD6jMKBRy58vRVEm2Z9NgxH5hwEy1CgxKU2OHHtTWAGb1K4fGNAvx+5llPBlKKD7DCUXpXUBELjHsXflmb7JtlgV6dPclaQgjObv8dKs8Idz4SuhwVHEWAV2u9HI+jv4bO9yRKbSnz37A4f191kdai0+zrsFTF22Ejg4pBSygEwEOBBUz8lELmy6N4/59Y5GfXvOwN3+/Np24rhVVuZ3BwPQi2L4IxHP8hCp0tvEuP0a6tpZsuWkuaRPGh8DGYRJ3C3MW+yVnEkZVLx5+SlJnOcwe/EBTkpspJ4Lt3GJ3snZk/M3hJ5eOCuI3mDwgUuBoBdVldtxXMy6cIqGMGetPNUtulNezGIS99QezN398JbjDI6CBijDX9ZxSGWozLGzq+2Re/LzpcxL/8KRYM0XRf9d3UnKN+6zm6zuYYnVXkpUGnE3K8cS1SotUMbhZ3+NtX9mnzvxF+nYW2x0K2TIhFLXhK6jUfOPPtSdJmesqlG+pBePSCOqBYOU6J+tmlFMcUAhtLgpx0mei3jT7DCUTcon0htRjr2EzGTASqHzzNSS2M2gO4h70AaHmitO7CgKc5JpyuQJvFMOKbc5rBkZs8si
 L4RKTdB8
 5A3V15j82bZuPTpPerTwvUECuMkJoKQ2M6CzkjFcnPmtWcEWyXe4ksgfl9QYnjj+JRSPsUmpG32e0mjaR10P9K6QsNEiM+u5URTcdVjncjnIBtDmLjZmz7Mc45BjBQGMPvkb8iatgNX6U+umuALd8uvGgCx3F6ih9IvqJGGwRSSR3P5hKs+9psfbkOHBCTAlHxoDHNK3+ekTnDmYX57PhVoGJAjZ0a4pix83RGz/xpmsXYlBwmUk06An0Y6v+R/GETyMYJh/dgp2L9r4Y4ahqODCoDifRKsyBpG9quY7MxGeIJ9c2By6R+JPiy1hxR+y3OiekdFr0DXjiTsHSeinmolhOqNWBJ7SP4KDJJrJA3lblw2RUbe94cCnEhHqHTYrADaYaoSiEF5UkidwA4w9DsaZsrlQ/kjrfiViife0hiaKPVysLu/NuFMamnlGz3bGiOwUJHTZxaimaBpxekYGrJzgF0qXEn9SJUarI7RLvxquS2d9NizkvPIh7zsGFwViHnvNF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 07:21, Zhu Jun wrote:
> read_block() only returns a record when it encounters an empty line.
> If the input ends directly after a complete record, the function returns
> -1 and main() silently drops that record.
> 
> Return the accumulated record at EOF when it contains data. Keep the
> existing failure result when the buffer fills before reaching EOF.
> 
> Fixes: 48c96a368579 ("mm/page_owner: keep track of page owners")
> Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>

Applied to page_alloc/for-next, thanks!

> ---
>  tools/mm/page_owner_sort.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
> index 6c2ac5d9dc4b..48c403d3de4f 100644
> --- a/tools/mm/page_owner_sort.c
> +++ b/tools/mm/page_owner_sort.c
> @@ -134,6 +134,9 @@ int read_block(char *buf, char *ext_buf, int buf_size, FILE *fin)
>  		curr += strlen(curr);
>  	}
>  
> +	if (feof(fin) && curr != buf)
> +		return curr - buf;
> +
>  	return -1; /* EOF or no space left in buf. */
>  }
>  
> 
> 


