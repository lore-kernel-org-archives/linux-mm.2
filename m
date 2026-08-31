Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57BCFC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4E16B0096; Mon, 31 Aug 2026 04:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC6C6B0098; Mon, 31 Aug 2026 04:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5EB6B0099; Mon, 31 Aug 2026 04:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F41BE6B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:39:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 64C2E1A0373
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:39:54 +0000 (UTC)
X-FDA: 85160916708.14.8A63E2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A518620005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:39:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlVQxh1p;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788165592;
	b=ZkBpNAaBVCxGm+idzEl4ekyakedk+zNjTaIN0rsx19i195nUbkms4/Nu4TCbDF9YSf3S5u
	fKohUfhBPFUKQyhCytdQTIYEvnuqw3U73odHgIWcmqY97z3PDxGIu0UKIR4+4q9vhOcNIP
	49HRqR0tsI6+hLkpAkUWTQwf7nIt/Nk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788165592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07DNzbG7Ea9A57I2ROWNCLeREPGQQY/UiEj2oMbahtM=;
	b=vUti0dMdjhGrvLkJaTEp7ozY4Iir76oT1TWb4SJ9jgbeh+u4eLyiqwu2GzV/3v9OrTKstz
	nh5TeiYTIsM00wAY4ELpX4iKb9xyd5BjuFzo+V/2qWp4CPP5WCzSIti/y9BIbjAZlcXAsy
	CDxTkSnT3n6acGjJtTnulbpW2X++uac=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlVQxh1p;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A8F160120;
	Mon, 31 Aug 2026 08:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5491D1F000E9;
	Mon, 31 Aug 2026 08:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788165591;
	bh=07DNzbG7Ea9A57I2ROWNCLeREPGQQY/UiEj2oMbahtM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZlVQxh1pZrIF6IuHK9/Bj9Do89thFo+qT9twAC9fuI7+6I2wqDE704FVePsFSBjNY
	 jUE7kviO2nwi2wjPX26x5gFT5kZi1W8J4DF7VSOpe2y058l0QxnqAGHId73E6G9RYT
	 3m76imtPCrTX5e42fIJwR7AEetVz5WUXkvl9NAQT+bY0iTpC3VMh8+Mi15tB8IPy2s
	 mdkQYBwBPZi/91DaUq3zLSK1c7hgrGfkQblMr/xeN0cufEtvEwvUJaUCLNL4LpOIUu
	 5de49mrXyubaR14qUSd8vPitPPWs3+aqYzQ18SR7Wb9TopFDuQmf9md10Bfjb2NOxg
	 72bpVJcYXwWaA==
Message-ID: <140594c6-0a39-4799-96f3-bbda79b6d832@kernel.org>
Date: Mon, 31 Aug 2026 10:39:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm: adjust out-dated document of __GFP_NOFAIL
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260829025847.26779-1-richard.weiyang@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260829025847.26779-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A518620005
X-Stat-Signature: yen8d16s48kfta6biuegstgu8jjc4wpa
X-HE-Tag: 1788165592-846858
X-HE-Meta: U2FsdGVkX19tvFWNSJeFRPFdobgkm9h0bZL0uTpn8403mR2ytFl/syWhcpU8Xpsz409kso01I2NRGAEXaIopj4/mtdEe3HPIVC2vPRhKZrJldQ/yg2h9nscXxrtHrUqfUbS2kzmeVNK4xfIij+BOaQMpapopv9yJLk5PU5RtgogCiljwzadrNs71LrfP96VK5va7actffFVs08i1Ugc2R5CCDcH+otE/sGb1KzUcpFYxHSxpaPEXXGa4iUZWpy42ecxjzCrNvzuf6/KxLRsn1AkvklcfCA/m+kVNZv2gmBrQWRXASLbeLg2QMc7Za75Ix5zz8Ufm2uNOPeSdxn9N9DqeCtva7xUxFoRtZAhiinqewwF3gc3BFhZAHA5NWaUQD6AQSLX2U1WD3Vpg+Nrx0zMmTaqJe4miSDKukfgvKAE765lhG/Bh6JP+qjHRGmwYOpn9o9kcFcK0JAbToqcezytgQqHqTr6KXiA5C71z+YH7H0rGu8Zd1PuAjAch/DbSBNQitdlEVs2Ypw3iZLpvVr1HK6iVGoDJgud8ZEsZp23BxXllaYeUv3TjXrB2A+Dmeln7XNM+46JR6JcgHTVWMmyBRsDHsFODXCjvZmQUIHRhCyIN3KSPdvx/g+K3aLzhlg37FYh4RCu6PTmsf7pOzraTbfZl1p+dS9HuTb/ELBgjsL/lI+OngDs9qMXI9P1A8UKOeLZNrKq5njgsy0ZJ7MC4GG3gbtqdXCYiY+V+lvRccTof4MIqWfm66mMLKhMpDcKJdPQm5cuN5L2ENKo1QCzYLFIitxTIRTpymEVpRnKiL9kWV/CHOFXSBCb1hBawPAWy3DafIjdSaTOarUKR0/FaIxav209ZQgqS4+Fb65NZ/YJG6L1AYPg5DiRyjqe8L1S2cEiy8MX9Hq2vLng07N1VdzH4KbTUnIdfOuVGiU+lqPLR9HblccN2uxyCzPmE1glzH+mYNpo4aLx6nnN
 IfCbVVof
 ekkYaQAekg1befHYqqJXXSB1lFW/ISem2gJNbnPdA8OlAG68aCNTppGviVjdvl2DzI5q1laPKPRSEIksFle41YfSLyb/f+VhVno84kq/mj4hY6LZYZOcpQZ1IVFu/kxHSTzgQD0u7C2srqkylPGhfMKTsi7ouMPXAbrjcWv4AENqoRuJBGIVHx9QehAi66JIxz4Q93w3iK/1QgNxd4E4XckWFeY1vvuji4VfPNZ7o8FXI1JnqvgAwn+ImbEPKibm+x+1wZlG8Ozx/yCtmsO9CHA4h93JSJHpWRFBXivM+FkotPTYDDr1L9wXoGjSqBnOH9VUegSQwfXkq21PcB8o5uhTT3CqPWZVkcn58MsoPd5eIWXTn9Y/QUdNqNdTSVqHpK1Tr7PO5wFvDhN4CYZ8UCG33A1bB+T19K/r4GSdvLlMRXvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/29/26 04:58, Wei Yang wrote:
> Commit ee040cbd6e48 ("mm/page_alloc: don't warn about large allocations
> with __GFP_NOFAIL") remove a warning on allocating large folio with
> __GFP_NOFAIL, which was placed there by commit 903edea6c53f ("mm: warn
> about illegal __GFP_NOFAIL usage in a more appropriate location and
> manner").
> 
> While in that commit, it also documented this behavior which is
> out-dated now.
> 
> Adjust the document to align to current code, and adjust the comment
> while at it.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> 
> ---
> v2:
>   * s/is adjusted/was placed there/ in change log
>   * instead of removing the document, say "is discouraged"
> 
> v1: https://lore.kernel.org/all/20260827030548.16631-1-richard.weiyang@gmail.com/T/#u
> ---
>  include/linux/gfp_types.h | 2 +-
>  mm/page_alloc.c           | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index 190191411009..bfd4c43ed777 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -244,7 +244,7 @@ enum {
>   * definitely preferable to use the flag rather than opencode endless
>   * loop around allocator.
>   * Allocating pages from the buddy with __GFP_NOFAIL and order > 1 is
> - * not supported. Please consider using kvmalloc() instead.
> + * discouraged. Please consider using kvmalloc() instead if possible.
>   */
>  #define __GFP_IO	((__force gfp_t)___GFP_IO)
>  #define __GFP_FS	((__force gfp_t)___GFP_FS)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ab385bc252cc..146f7e0a9462 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4804,7 +4804,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  
>  	if (unlikely(nofail)) {
>  		/*
> -		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
> +		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
>  		 * otherwise, we may result in lockup.
>  		 */
>  		WARN_ON_ONCE(!can_direct_reclaim);


