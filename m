Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C4110AB80A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 19:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91D0F6B0088; Thu, 26 Mar 2026 15:09:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4666B0089; Thu, 26 Mar 2026 15:09:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831DB6B008A; Thu, 26 Mar 2026 15:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 721E46B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:09:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22277BC54F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:09:20 +0000 (UTC)
X-FDA: 84589152480.16.49A05E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 642CC4000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:09:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PhQ0WnCS;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774552158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TmxQFcoImenInxT8DdNugaeXqE3D3ZLGAf0vVKM86+Y=;
	b=laNekBdqqyrj5rQq4rpT74rxT/4ADtIwjsbKoLygXb21GCtCSYEvkqIIznADTzeE96l1vT
	tquVp5E31EZ+e2hOCCxhKxKP3iKVSw2TG49sZEfnDed0lFVXnKMpARFnTKF8ZCa3Jtiruk
	PedJL7no3b/ANNP8cSkty+5/lhpf2o4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PhQ0WnCS;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774552158; a=rsa-sha256;
	cv=none;
	b=Iy8GnRnohH8yJWT5yZkdEIId05RUiSrnRfYBHb4vZkyywF1P+jHRdYowfS2xrU7X0bc4YT
	7/D8elki/3kpfP+9pHSW6Kj+rcIWhTaEuPTZrWVYCZAEh6fagL6NLQKP2ZhzT9SezCy9Sr
	meOF65JvoAHaKbHncbY3ovyP0si+Pmw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B461E60128;
	Thu, 26 Mar 2026 19:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144AFC116C6;
	Thu, 26 Mar 2026 19:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774552157;
	bh=23H9+hDeZzqOwppiqsrduagCe7Tuo7bMUK2xidg/Nsc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PhQ0WnCSvDjfyoIc2VXk4oGg3zhvcI3pL7Q9w4KBEfPfjhH79DS/Ktil/S94RK7Wz
	 WNyJHOFCmXO0QYyeA/TCuzJOR9oq1D1BzvL31bmlcp5OIYvEjNFn/SSO4u6dNbwfOD
	 SZXNT97fwNLqRHSkX0bAXs1BqudFYDp11DZpBTdmQtgSdXBKqTseUPYdM9aFSOUM6n
	 3E8xfsnoLazoZo53Xxh3+iwzgCZcMMj6J4+XnZTXrdx/w1yFEg24e8PBboEqyV/xBY
	 GgoeefnvRsuJmBz6uibF+Uh6gua2+XjSz/zY38/oA5QgPn1/KBnnU7GO5BvU6SqgaL
	 GkzzefWXJT09Q==
Message-ID: <0d4e27a2-e9ae-41ca-b327-82296cbb0cfb@kernel.org>
Date: Thu, 26 Mar 2026 20:09:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: update MGLRU entry to reflect current status
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>
References: <20260326185629.355476-1-ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260326185629.355476-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: x76gfiyw7e9zr7pfq91jjxtaa6gwjfb4
X-Rspamd-Queue-Id: 642CC4000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1774552158-540295
X-HE-Meta: U2FsdGVkX1+Fi0ozGOV65GLeI5k3autG3MilH2+FiPVwTgDuC1wuI72IiZ1I7fC5Vc5kp1PLscv6YhyGSNlJjF7NV70aoEvFtI4K2KL1QsmmcwRrKRcK6hEfrLKjcgocurMfToIjPvymEEDnDQ80wP7i/RH8LOJbQBgfv2wizgHoscoKfjEk3D053sDXG35toqCGM44M8Nyj1x2RScLb3uoq/OvSGm9VXkpAMti1NVw3iVPF2JZG5InJHPT5dwvnWnuw9bZk+pQNVTEOCQm56BR06wgt7Xm0fHOfqT1W0m7X4WH4afm0iSYpN1nhOHDjtTLu/4lXuUe9b1LYwq8poRrTLrczApusYmRc/LtMzUWedK4lxDIGfc+VNSOfO+m1rm18gm2CJm/Hca+A4MQ8aGLBLQOKDcMwGgeFfOStNDGBjFhAxsk4khDNhUPMo2eu98Fo1prIjOZc2HQJJ/Lgz0lXKCbHabUNqdwpSAFooHUKyod5wxw3axP26bnElQq8h1c3K/HfiPHgGJpiUcsXEwEBygFbSNrwTerX3ZcgsCmUoBngQ6QQ/FkXNAVhbeWZzIHI70XsbBTjEQx1J/Zxn+6WcDpshUcvaqfsVBFjOYEZacLUnhWKHV7+QE8l+RS4nXZ/KUtVesLHvrHBz6Y7XXkSVEbXSWnhXZBjGcxwNvbBqGWpgOIUrCLkdBR+dO4IJLz0XBj+YH62P7jPAw/PO4ECa/3C7xLObeQq/7up3t9UTDOzYO7wo/KeLcPDj6sDl71OMFYkEZfxVzCYxxVRUw2gXJZpIEWcUcqXfvrtl+ZodYF28VPT3MErfu2h8zTOq6XHV1XjrNnyZMN6KkalAEEEULsz+TkmjgLFMkcQkVpae09zaMErsptSLOgorYvdehvKMVWUTxv+X8o15wj4D/1hNzhUiICIowMtQUg5/ezIG8DkEZdA7HuwAo1GikenPkr1JeNt3jCL7sbAMip
 ZPZ9774D
 uY0kEBBpnR8nEXG+Vi8dcpx7oB5EoAgbcWxqjbmfFaafgmpq4Nj6AzJyzD7K2SAszFySRH+nGH+LEDtR0TGR0o1DyzFNsPAaPKDeksCVgVe0F/0ORkAbBPLT66R+nlYfPxqYi/HtmjjSTJyj5vwAsS0Mc/CKBKXAKpsrdg4xMjlbIDw1h3xNmd7Uawj7+3PzVUs0SrMzE7BkxUrzNZFI8yZjbXJjv+aMwG1x5PK6w9korc1rEg1tzBSa+AlGI3z0XbNOhvXGyIALPEJCC50EZ13ppMIgkXh188rxtbCtDn0w2lYMG4Iq6/TKr3wyNZmc/td+0nHs7aEFxJhwqPweJ4fsSyXe0rUWaaryfi87fiUBg7k2Szxecr0ZapNvcAuXEfvVhz0k7lDJKWanD7Km4DoXr7Gk6bDL/5TUmH1pMlbGmtplNBnvo9jBi+STKE1vfKnbr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc Suren as IIRC he mentioned some intent to look into this as well, in the
mmap_lock call.

On 3/26/26 19:56, Lorenzo Stoakes (Oracle) wrote:
> We are moving to a far more proactive model of maintainership within mm and
> thus put a great deal of emphasis on sub-maintainers being active within
> the community both in terms of code contributions and review.
> 
> The MGLRU has not had much activity since being added to the kernel and the
> current maintainers who kindly stepped up have unfortunately not been able
> to contribute a great deal to it for over a year, nor engage all that
> heavily in review.
> 
> As a result, and within no negative connotations implied whatsoever, it
> seems appropriate to downgrade the current maintainers to reviewers.

Seems fair to me.

> At this time nobody is quite exercising the maintainer role in this area of
> the kernel, but there is encouraging activity from a number of people who
> are trusted elsewhere in the kernel, and who have contributed relevant work
> or review.
> 
> Therefore add further reviewers, and at this stage - to reflect the reality
> on the ground - we will not have any sub-maintainers listed at all.
> 
> Each of the files listed are shared with other sections in MAINTAINERS, so
> this doesn't reduce sub-maintainer coverage.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

(I assume the newly added people will ack their additions)

> ---
> (Apologies sent first version of this without MLs attached :)
> 
>  MAINTAINERS | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 76431aa5efbe..16874c32e288 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16757,8 +16757,12 @@ F:	mm/migrate_device.c
> 
>  MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
>  M:	Andrew Morton <akpm@linux-foundation.org>
> -M:	Axel Rasmussen <axelrasmussen@google.com>
> -M:	Yuanchu Xie <yuanchu@google.com>
> +R:	Kairui Song <kasong@tencent.com>
> +R:	Qi Zheng <qi.zheng@linux.dev>
> +R:	Shakeel Butt <shakeel.butt@linux.dev>
> +R:	Barry Song <baohua@kernel.org>
> +R:	Axel Rasmussen <axelrasmussen@google.com>
> +R:	Yuanchu Xie <yuanchu@google.com>
>  R:	Wei Xu <weixugc@google.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> --
> 2.53.0
> 


