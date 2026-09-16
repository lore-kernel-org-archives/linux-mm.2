Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7141C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45176B009E; Wed, 16 Sep 2026 07:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4EE6B009F; Wed, 16 Sep 2026 07:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4C76B00A0; Wed, 16 Sep 2026 07:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C8CD6B009E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:39:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25703160678
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:39:34 +0000 (UTC)
X-FDA: 85219430268.29.8E31630
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 41C9A20008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:39:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJyruiO5;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789558772;
	b=Wo2BjNga55MIP6O+T9JTD4X0MNZKQnxqdLXPTzP2nNzFoJnWYtH1bWCrRf423xCB0/uLlF
	YxCSpAgF3Fwc5IXXm08pPC8XhBPADk/EyvGQKCnDNmr0UqY/Irs5xEzkXsAVHi16S6Y7P3
	glsyMZ7YYuhMTpAJrj6LLF64+/b2Qw8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJyruiO5;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789558772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PwPvpxGrzEMSl2UNY8taOVvejOczhuAnj7LbVVW1ppU=;
	b=vQFf3EZVzUoGGm7qZoEZszGH4LKaivIdd/Bmuz0owD5qsSWw0gSycM87bKPxFdAmkNNqjK
	TX7PeRjXhyymfMY2ekNcThSsA/5cs5jSkhElPPtIpLBdZDTt+yypEgoBa+tfzLK1WCvbrd
	7L8H7LeKeNpLnW4HC9i/2CdpEP7e6tE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 636D64331F;
	Wed, 16 Sep 2026 11:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A404A1F000FF;
	Wed, 16 Sep 2026 11:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789558771;
	bh=PwPvpxGrzEMSl2UNY8taOVvejOczhuAnj7LbVVW1ppU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KJyruiO5wrKXPzdDFVqClE0Ty9ULE/hZ5397ZAAciwaIzSVYco6qRvg6/MDxgtKC0
	 5Orh+cdNNSyRg9VM6hQ/zX41j+heGbSMRTvdr4Bf6A683yZM+Uct4pWu7p8C/TZAod
	 oecbogdsDV6kKQO+FXHf05kUU+o/mbKfsVJUibf5nEU/8bF6feZlVbDOPQhBrdkCNq
	 4CJaECSLIEwat0TrrDvjO5jSd0KNNyHgMQm3amCX92l6XCO0ns5Hn/UVCMAoEtXizc
	 1+68a2ZkufZRdTVOGMQFm/423/2+A9Yl8H7Yx+w2fcLCxww5d6OnBDIserveBUvhlz
	 4/duiZamVsrQA==
Message-ID: <6cfc9b2b-f27d-4f06-ac76-bba64b5c1668@kernel.org>
Date: Wed, 16 Sep 2026 13:39:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: do not boost watermarks in kdump
 capture kernels
Content-Language: en-US
To: Yuanhe Shu <xiangzao@linux.alibaba.com>, akpm@linux-foundation.org,
 mgorman@techsingularity.net, linux-mm@kvack.org
Cc: surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, henry.willard@oracle.com, david@kernel.org
References: <20260916112545.3707893-1-xiangzao@linux.alibaba.com>
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
In-Reply-To: <20260916112545.3707893-1-xiangzao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 41C9A20008
X-Rspam-User: 
X-Stat-Signature: doqndwqgyrbbo76951j58jpsksefkfxg
X-HE-Tag: 1789558772-111900
X-HE-Meta: U2FsdGVkX19iCyBzD7dNUefCMvO+k379uwG5eImdd/+d6KqdItsRnlNz57XreC9ddj0FEHY4wbRB+GFGpR9LqoOK177iCkz03H8rr2shXX2UDwehgrVwfyRedNRPRhqEievXO2zTNOHR+3BASpdONWSXVXMyyVR4DGnF9t/OtMEHJtbKjCLoFGaAny4O3LeA9d5c7Efqr+u/qiG4HsQ/1CuoFfJHWJQzr6gmyfzkJ1RvmULIj2rG7G/2K2s+w1eM0UfFaP9hPzgf8qG5fnCo9sxMRnSiGH0UyKI7BWsmgkBW5KWGPrVYozJ6j0jgZx1swhCfFA7gftCpqUIUgXMQjm9zXhBuUay00/WFhyAZzPfxFhOz4Ap3UH+6AFaloWPn5ZPqXjPyA2ChnwFmSnkEKD0p7LU2jZmsUVf5x0YRzr/GCbo9JIjtFEarTpD71Q02Xof42m6ZfKGUdV8XEEXYVVZ853q3OXcxDwzi88taktXpBXhntkgziphREZKLHuhTSKjlSBuNRthIUYJuN+3BzrBDNegEJK2koJfsd2Psjwt02tEfMkP3It2qCX4Jij1/96ahwyk7H395iu9O/nHv6CoITlW186QtO+R66mEH9kSBd4Qt0FlLxo4cHT4FZppWyPWMqkyRJSdKmK8u+8No+UjNgafGC/A7if/Ns8jkzvNtAiVjXdXckHTm40Jk2ZBuHu9PfnhXFSEoajvOAAbiuUf3U7cwWiL5lt5Cuuw43aFTX+FGGUTWfCxyrVl2Luy1b7F0EiLWxUUB+ViTMcBbDO4Swcf5RYe8N4i8PnHpXyLNAVXS5PBAH0DHRQ+26Mg5WS9wxpC0gHmyDW/Bpu7S0BxbZB+X1TzVU/DEzAem3rD8r+gqB0JhRmIHE2NQM3X0aYyReZEqWTcJa60mhEWRvF8qObEDmZmNtPIxkH7RjmhyRrbFVxt+5jkqFZNUpYXrt0H7cuSZFk+uOLudfAx
 5MDXzvhL
 c5KDO8tbPeC+a0TMLoHkNIHDjTceaAJqMCS8kCLtmgWeYvsa53IPd32h5xIzyi9jhdBebS0/ZTn4CFxsvhBX9YilYsIWzHACWt+v+FDLvHSXrlJpzEbrBHMZStkItSeHReV563GDwaEdHQFba0XXE/lwGTD7ObJt8lqMufRe370MmExhR8759nGP0TKfPBm2vaAa4EzPckugirQk8wl1H2ZElKDUitozPxNEYbspjuxGAEEKBKkHXZrcuvtQbfQNRRlN4wfZZG1DJ5M5tKkcYZfVHDzUz1lVuIeUGqFZMmRHYqUuMINPJgjfc03Qf2NqNoAMaZRc8j/i/0pFQprRJWFuJcO83vqcEFxCfTrb4eoNNI/iVgCRlZLqz6RSAv7V2QsF9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 13:25, Yuanhe Shu wrote:
> A watermark boost is not confined to one watermark: wmark_pages() adds
> it to min, low and high alike, so every watermark check sees it,
> including should_reclaim_retry() and the last ditch ALLOC_WMARK_HIGH
> attempt in __alloc_pages_may_oom().  Once the boost exceeds the memory
> still free the allocator gives up and invokes the OOM killer, and a
> capture kernel that is still booting has nothing to kill: the boot
> panics and the vmcore is lost.
> 
> Seen on an arm64 machine with 64K pages, CONFIG_PAGE_BLOCK_MAX_ORDER=10
> (pageblock = 64M) and crashkernel=512M, running a distribution kernel
> based on 7.0.14.  A high order UNMOVABLE allocation fell back to a
> MOVABLE pageblock while the capture kernel was still in do_initcalls():
> 
>   Node 0 DMA free:68096kB boost:65536kB min:68160kB
>   low:68800kB high:69440kB managed:479168kB
>   Out of memory and no killable processes...
>   Kernel panic - not syncing: System is deadlocked on memory
> 
> The zone was not short of memory.  Subtracting the boost gives
> min:2624kB low:3264kB high:3904kB, so the 68096kB still free sat 17
> times above the high watermark and the allocator would not even have
> entered its slow path.  The boost supplied 65536kB of the 68160kB min
> and by itself put the zone 64kB under water.  It is that large because
> boost_watermark() clamps it with max(pageblock_nr_pages, max_boost);
> watermark_boost_factor alone would have allowed 5824kB.
> 
> Commit 14f69140ff9c ("mm: limit boost_watermark on small zones") already
> tried to protect capture kernels, but it infers them from the zone size
> and skips the boost only below four pageblocks.  arm64 64K pageblocks
> were 512M then, so the guard reached zones up to 2G;
> CONFIG_PAGE_BLOCK_MAX_ORDER can cap them at 64M, which shrinks the guard
> to zones under 256M and lets this 468M zone through.
> 
> kdump is a property of the kernel, not of the zone, so test for it
> directly.  A capture kernel exits within seconds and never uses the
> fragmentation avoidance the boost buys.  Normal kernels are unaffected:
> the size based check still covers their genuinely tiny zones.
> 
> Passing sysctl.vm.watermark_boost_factor=0 to the capture kernel does
> not cover this window: sysctl.* parameters are written through procfs
> by do_sysctl_args(), which runs after do_initcalls() where the panic
> above happened, and watermark_boost_factor has no early_param of its
> own.
> 
> Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
> Cc: stable@vger.kernel.org # v5.0
> Cc: Henry Willard <henry.willard@oracle.com>
> Cc: David Hildenbrand <david@kernel.org>
> Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> Changes in v2:
> - Drop the stale kdump capture kernel mention from the small-zone
>   comment in boost_watermark(): capture kernels now return earlier.
>   (Vlastimil Babka)
> 
> v1: https://lore.kernel.org/r/20260914131142.2984623-1-xiangzao@linux.alibaba.com
> 
> Build tested with CONFIG_CRASH_DUMP=y and =n.
> 
> Tested on the affected machine with the original crashkernel=512M and
> capture kernel command line.  Without this patch both capture boots
> panicked at 7.9s inside do_initcalls() with a 64M boost in place.  With
> it, and with boost_watermark() instrumented, every call was suppressed -
> including those inside do_initcalls(), where the panics happened - free
> memory came down to within 64kB of the min watermark, where a single
> boost would have put it 65472kB under, and the dump completed.
> ---
>  mm/page_alloc.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..f52ed7d2cd34 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -37,6 +37,7 @@
>  #include <linux/vmstat.h>
>  #include <linux/fault-inject.h>
>  #include <linux/compaction.h>
> +#include <linux/crash_dump.h>
>  #include <trace/events/kmem.h>
>  #include <trace/events/oom.h>
>  #include <linux/prefetch.h>
> @@ -2178,10 +2179,17 @@ static inline bool boost_watermark(struct zone *zone)
>  
>  	if (!watermark_boost_factor)
>  		return false;
> +
> +	/*
> +	 * A kdump capture kernel exits before a boost can pay off, while
> +	 * the raised watermark can exceed the memory left for the dump.
> +	 */
> +	if (is_kdump_kernel())
> +		return false;
> +
>  	/*
>  	 * Don't bother in zones that are unlikely to produce results.
> -	 * On small machines, including kdump capture kernels running
> -	 * in a small area, boosting the watermark can cause an out of
> +	 * On small machines, boosting the watermark can cause an out of
>  	 * memory situation immediately.
>  	 */
>  	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))


