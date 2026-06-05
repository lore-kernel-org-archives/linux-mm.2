Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC32CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 11:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8D5B6B0005; Fri,  5 Jun 2026 07:59:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3E346B0088; Fri,  5 Jun 2026 07:59:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92D316B008A; Fri,  5 Jun 2026 07:59:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81B426B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:59:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0ED43164305
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:59:27 +0000 (UTC)
X-FDA: 84845713974.18.CB219F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 574C120006
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:59:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zl2REIDg;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780660765;
	b=lT+TNbSHE8YLT+QkHFg+c+tpOjPDYAnPKKQ6i6jMWvl3k8HEEQlROPgQnxRYD671Ctm7cC
	dS107KybcUOZ36NY9t0WYia8xR0tLJ+Dv1oJ2zsTX3JfP7+l2Sq9uj5dLTuWyXYSjVxmCq
	nK3xuCAmxC3uouwqOAVVo5rJMC/M4Ww=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zl2REIDg;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780660765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wiOY95bbms3ph6ntuxqrCRd7im8fwXbJxnhcBs8rZm0=;
	b=Y8pd/M7Hy+2cJYgpA7Ac5Tw9Z+hV64w5omYdr4KMezW3/1PRAQqW+N41Q2b0iY8rk6A0zy
	6occ23gn6ZCBO8XLXxqNhIhhB8GuqRnhHFJB/X0cZwNp5MUrT5RupViJ+79+ydF6Ygy+AW
	cRIV0Z7xIhJbUGUa12MEjkuo0s+QWUU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7F16601DD;
	Fri,  5 Jun 2026 11:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221391F00893;
	Fri,  5 Jun 2026 11:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780660764;
	bh=wiOY95bbms3ph6ntuxqrCRd7im8fwXbJxnhcBs8rZm0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Zl2REIDgG5ZqGgghwyl7YWWUvU1WXXbSFjB0mqOW1AxnfPowAFppenxyPu5QZ8WQC
	 YLvFTcIaZ69LfBP38RP3NJsmOFKSwlJRwfO0axy8wEOcHPdtC1r1y/bZxAzR5wOD9n
	 FHwz+UDCB22ler3P5uVPVZ4UYD6QJ2XKQh6RazBWNDqsaKryrgSPXnB8qD5AYUksJQ
	 PCkklFXpZIQd6RpTwocpvtgO7gpYJQPf26guJ/eqc6/kj0zyHONXlKOsG6GwOEwqKk
	 A8IcgxbQKDfxJ8lL3KuYJAgI3mnbNT84sX6g6AW4CGpdvZD6lSvgiG6rHX7aVED1bd
	 9b9YM7gR1ifVQ==
Message-ID: <63ecf4a2-13a2-42d2-8990-e53e50ae9a65@kernel.org>
Date: Fri, 5 Jun 2026 13:59:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/slab: add a node-track-caller variant for kmem
 buckets allocation
Content-Language: en-US
To: Pedro Falcato <pfalcato@suse.de>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Simon Horman <horms@kernel.org>,
 Jason Xing <kerneljasonxing@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>
References: <20260602183122.747759-1-pfalcato@suse.de>
 <20260602183122.747759-2-pfalcato@suse.de>
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
In-Reply-To: <20260602183122.747759-2-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 574C120006
X-Stat-Signature: 7q65uxji6cwcro6bw4ineufbiw3jnkta
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780660765-327738
X-HE-Meta: U2FsdGVkX18gDywlpj7tsXlKd68qk+Frypp2QbiIYOnFRxGKo5LCSBPS2c5BpYInUTyqKuelHzztQ4OXPMcXLuGk5ouAG30Wn1XxEdkA5v83xLZNq96Sr1iRUZT2e3ytnNApJftgTWyBnhGF3SCRaJ+wyIXUOsBBxUUmegf0/HKVOIucO6b/sgts7epdewsCHfr/rOShoaG++V4H5snZk/s+IBuL+beQjlxVJIj03NzeX8LYkIFxhBnXgJzd4t0+ThyIDtxkfDwY2TVh7zlsslNpG+PAgTJap+b2a/lFDWlDKqQQSwxGAGlhbjCG6GvVJ2NeMp3PfmjQ0cCRl2ldPXCscv0TsPRm+t6AzElh/haEt1aY3vbLJ0CCy/K4GR9yWSFvl7CZKmGJkBfchB3yFp8ZbT9DaJaXphYt2gXzVOyU+M4gXzN5nS9sYhQNOJkpRBIeZq+WkhI6/9XpR4D4D0/BkWCD8HNT2O0oGCIOPVQ2ae6p0iyyvWALYwBPAnnlJh3R9ZDBBo3PXDGLTKlospAR2m2/vmzKfqCqvCy/iD2j0HO/+dOlm+nkPtbriM4HGbkZjP5h0V46MNmLk+ApGjJzQsUynOlPetzsig+3vCE5zrwUWb6AOlBUXWjFel6hwvtcl8s8TQd/3B2mdyEE6dR8gv/5LqZCn9C4kOOLs3xP7Dsz/FBJWXo41m/Pq6J2Nmsl69Hx/5O7ajx+Ix5OvhrE1kdW2qvZE6/z9KDargsN0BRwo5QEyKu4hmzllX2gl5RPi8Ucbv3Fp/as4e3RXPsE5GNFft7u+DM3vXuOxzUXVpaEmn8pHz+TgFpH/TEE9Wkm+e5Q2VINEqyGwYj+vzwptptf0h1p5mvtbDXELzfhdMOvhnAd7JzkQOVTqX19Mwpy5SS5V56rreLF+FSmZE1ffC05Ygbm8aFNX7nCqKM6B0rXr8O7zEkmjSGMwzzvsRGw2glz0PHfB9ljcdX
 tPaAgsvq
 Jicww77N48xyrxbMmUCtx2gKykq+vprPrd8OwmCmnM4ILPO2Zan/y3SxDPVGAhRvOjCLLGr8at++vHf5Zjn9TxbYURjTy2LJLOShntZdNayVW0cblotGLZL8Z4sIdKcziETh+SQXYd/rvYAYBdEL1gxmXjBsT9JCOQHaf7K6aDfv+Rz/NvDlXlaqMOuyKwmJnFZ4jrpZU78YY/+PTgUU4IlU1vV7myJ7QagE3mieLDRMgA8Uk6VpJkug/yTtEU1vb5IqV6CL8rns93uAxJ19Ae2X08g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 20:31, Pedro Falcato wrote:
> This is required by users that want to use kmem buckets, but still
> desire specifying the NUMA node.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

As the main change is in net code, probably should go in the net tree?

> ---
>  include/linux/slab.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 7b46fa499b08..685a87d8f0c5 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -1153,8 +1153,11 @@ void *kmalloc_nolock(size_t size, gfp_t gfp_flags, int node);
>  #define kmem_buckets_alloc(_b, _size, _flags)	\
>  	alloc_hooks(__kmalloc_node_noprof(PASS_KMALLOC_PARAMS(_size, _b, __kmalloc_token(_size)), _flags, NUMA_NO_NODE))
>  
> -#define kmem_buckets_alloc_track_caller(_b, _size, _flags)	\
> -	alloc_hooks(__kmalloc_node_track_caller_noprof(PASS_KMALLOC_PARAMS(_size, _b, __kmalloc_token(_size)), _flags, NUMA_NO_NODE, _RET_IP_))
> +#define kmem_buckets_alloc_node_track_caller(_b, _size, _flags, _node)	\
> +	alloc_hooks(__kmalloc_node_track_caller_noprof(PASS_KMALLOC_PARAMS(_size, _b, __kmalloc_token(_size)), _flags, _node, _RET_IP_))
> +
> +#define kmem_buckets_alloc_track_caller(_b, _size, _flags) \
> +	kmem_buckets_alloc_node_track_caller(_b, _size, _flags, NUMA_NO_NODE)
>  
>  static __always_inline __alloc_size(1) void *_kmalloc_node_noprof(size_t size, gfp_t flags, int node, kmalloc_token_t token)
>  {


