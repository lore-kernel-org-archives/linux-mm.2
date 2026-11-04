Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 018A8606D807
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 08:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bXTYrDSE
Received: by kanga.kvack.org (Postfix)
	id 09BC26B00EF; Wed,  4 Nov 2026 03:17:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034E96B05B1; Wed,  4 Nov 2026 03:17:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4166B05B2; Wed,  4 Nov 2026 03:17:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C47EF6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:17:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5266016067E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:17:27 +0000 (UTC)
X-FDA: 85396732134.10.9655AB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9025120005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:17:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bXTYrDSE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793780245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sSlKHe6xc24svxDkA3PbRnbZQ2Hd6+8PIRLhRVLtkNA=;
	b=AhPgT0WX13PHjLKHszsPJY7betlyFjMpRoaG3AOHDdZN2Ce3CC2M7eVg7t5Fsa3tE7lElO
	dDnj5sDRjknA/mCR8PqpT75Upa6YA3CHZxZIQYyJvDy8A6tvUAhE/a8FQw8X6HvVfV67UZ
	poxO0xg8lXseXr7OOluOBIbLkx/IKLA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bXTYrDSE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793780245;
	b=nJhatA/2CzekIv6IsqAcVYp+cgUfoq8kBCTKuSZFRxUhuR8Gko+ZqH7KqDy8EIcrql//BC
	nftDikjrR7PWbmobDK85NEKJtHkRjdv9fktNpgBjyirIcSo1kOPN7NufhkPtHHg3bIEbko
	Ii6VWPHZ7EdmMfmbwYQ67IS/kzSfk84=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CA0560611;
	Wed,  4 Nov 2026 08:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2DB1F000C1;
	Wed,  4 Nov 2026 08:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793780244;
	bh=sSlKHe6xc24svxDkA3PbRnbZQ2Hd6+8PIRLhRVLtkNA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bXTYrDSE8v1k4UTrZsaWqhHJsS3KHpcVQ9MpNm3mcEPTD8vb2ex7rANe82ae4M8i/
	 U+Ge7YFlUWCEP+xm3yD8oGT2QLL60w+3jeGfHcyFOzeMowbYgPtorwLeFSLQWRoFeh
	 vKaFxSbDESgRLNr8rWHYeENa5CsIt+x0S+Hw+SDaqHy4nHKjSi9n+hqfwW6di2LYzU
	 xbQjrqsjQGFpGz4zHt46mCInYTWrKSrUysrH238MZo9pFr/I/LN3RKu+vLVtg/E+W3
	 mC/OYkkJrUji6ca7e4xgedrR5Lj2PqIbcDkFwq3tn2lxiWWhI7rbo/Goy/r3fDxpLJ
	 5OQ3BzFslQzPQ==
Message-ID: <634f37c7-6096-49db-8cfc-7c5421631322@kernel.org>
Date: Wed, 4 Nov 2026 09:17:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/slab: restore the rcutree. prefix of the
 kvfree_rcu parameters
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: urezki@gmail.com, paulmck@kernel.org, qiang.zhang@linux.dev,
 akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 rcu@vger.kernel.org, linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com
References: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
 <auIRU802S4Z4yAmo@thinkstation> <auiedkWD41Ok95TT@thinkstation>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <auiedkWD41Ok95TT@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9025120005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: nxj1dba9t7h88dkghrazb5cujqk7xtkb
X-HE-Tag: 1793780245-991975
X-HE-Meta: U2FsdGVkX19h1sXdYSrF54/dRcM62Pa/fauGAFHfMO50KbWZuzgXCoE/MaXvd3+HndZrj7aX0hfF3JIFUXD9eHF/MPbLTyG0ooSUvm3xWiC+arg50aUAiDKPkja/xLDSFfcPa6pN1NNZ6XRwAr/ekElJpHjZ1LOWdooQMWwyh7m5fvpTG4Q6J6Zhl5W6BSTfo74frV7wAWRm9j3cou1bM4N2QpKycsiwgWwar6isysEZUPfCSJRSsuw+abENVJpeGNW9dHHpe/pxOs60/90q3q93Bx5xQGbtA3g9iTrCGDm8c1sLSM48G7QR68E+rAXzYRz1vKLFeCqu79G+zdXp8SWy4wJc0f+U+NB5/nypQi+KUSkhfuK3F7IqdIZGeUeWruhjTJPqMu1a91OIaSbyM3lEeKiI+4wshwhoeA2lC82EYTRW2bHphXzsP3h4j9xrIHqb74Kv3ptqEOhzWRg6JfgAmlCa7WkOALV0y1KDug8fRzdKHRu8L1khTJzGl1adOzJ5Du5e10Q4PpjyalUx0ksQuPHbIkNhhL7VxRczA1z4NY397iTTXQOxnYGzAJjRh5vuFdYuxumTY9dzcSd6taNW4qt32Kr1Er6J1NZPsPkvlK7nCpX4shKAWMHThGRlNZhZXe7spZpBxONOJvnutMUWzA39DpcRu3D0Ymi99l1yn9OU1M6vLREMLZn+Kk5ZWrYORfP1J6TtJxNuk4Lc6Jv7cbQEXI7YKLREVvEfsS4rfcmxSqzyVLxag1mqMfCOZGMwTW6bGgEZCauu43WrVk3DdccowaIUCxNvf6TGAZ7bQ47JfgkvB9i7CVAFp9pXmL8liQPOKENS1zZSZu6+5kg4zRe2ZaFuM5eFpTIFkXEqdhyA1Rfk/MF64gy0XKFtNYN9YPCESSjlArhWvCTnk+xkKPWZV59ZIuJMauJ5F6qpk5iOOoLcnPzgw038zPrAkJnYSFwcCPGcD869YJk
 4nrydzma
 ojSMddJM/lnZiZyuT72/fKawbu/4iOmIcCiGts+dhHtjgCEBBKJEjzOMAbnhiKL0RZUEjunCc/q9sJnd7RGZnU1AkJEhtsnBUKryHJtDJbp6/f/QcLKxXwDv5FtGHoGZfdKupHHWC96jo++0ASrFecfgHj7SLzKF22S6sfTAgqO7+l0+poyv4uhFvPCEQJKjG+GNEyz5snpIDhyUCewQV7GgIZu/Y8ZFXrXtFMs04SECSVoFAy+sTMGM2ohGOGt2wFg9fGmZLDyRmu8wylUl392tusC4swFJTaHkNcVf5lnIjDC8+14/KB6ktj3aHqMDzbbqnx2oseBo7lLYVJ6lMZzKC1896o2+Ak0dcm3T+wvYvEjfiyDKHLRpDhv091SJ/u4IGG+tekAt9+BLZ5BBGbEBdJLPpS3tEwsmL3TuzqsXlJWr/XxEGdNh3/fJNFvE+t+vBeRb3LEYcCzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 15:33, Harry Yoo wrote:
> I adjusted my feedback. End result:
> 
> mm/slab: restore the rcutree. prefix of the kvfree_rcu parameters
> 
> The move of kvfree_rcu() to mm/slab_common.c dropped the "rcutree."
> MODULE_PARAM_PREFIX, so rcu_min_cached_objs and
> rcu_delay_page_cache_fill_msec became slab_common.* and the documented
> rcutree.* names are silently ignored.  Restore the prefix; the
> slab_common.* names, never documented, stop working.
> 
> Fixes: bbe658d65802 ("mm/slab: Move kvfree_rcu() into SLAB")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
> Link: https://patch.msgid.link/20261028134647.3176080-1-zhanxusheng1024@gmail.com
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/slab_common.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 01c64ef661e7..41dea01a8c1f 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1367,6 +1367,10 @@ void __init kvfree_rcu_init(void)
>  
>  #else /* CONFIG_KVFREE_RCU_BATCHED */
>  
> +/* Keep the prefix inherited from RCU */
> +#undef MODULE_PARAM_PREFIX
> +#define MODULE_PARAM_PREFIX "rcutree."
> +
>  /*
>   * This rcu parameter is runtime-read-only. It reflects
>   * a minimum allowed number of objects which can be cached


