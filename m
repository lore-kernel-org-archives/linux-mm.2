Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB69C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5397F6B009B; Thu, 10 Sep 2026 10:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9526B009D; Thu, 10 Sep 2026 10:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D7D96B009E; Thu, 10 Sep 2026 10:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FDE36B009B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:42:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AD8D4A0589
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:42:03 +0000 (UTC)
X-FDA: 85198117326.09.2B05DB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 097FF140007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:42:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nckwhsbx;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789051322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AC2aVlJGfM8BolgFPYicq3jFdCi6ZcStjOJlfIZLYLI=;
	b=SSI7WQzBhhN/BhOxrxysrJUcPDT/ZPW4ZX/i69HBCgpmxdVGfWbk/3iqvJ027+LDIc//jy
	Vudvdt1JNxcF07dHS2w1XJoy/fFVoujO4R2IauA0WrYqtRhLjhW1pXvaOkSOxWYCpcdfbK
	5DBtjU13ySIUiveBKjtB+xSUsRVzHrw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789051322;
	b=V55fvoOmZI3rzyCkNTBPI+wSV2v/OucoqkL2TpOpUz7pcqOxhi3z68WLQ4F6muKMKmaRfI
	0c1vmgH1WzBMDjlgkb9eHei1/exqcXwbS2FYsFDNZq5/3fykIurXUhII+/v5gkO2+Cnd10
	t7rpJuVHOFFJrrr0KA7vFd+zcX89F6c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nckwhsbx;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E0CCC43D0C;
	Thu, 10 Sep 2026 14:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7721F00899;
	Thu, 10 Sep 2026 14:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789051320;
	bh=AC2aVlJGfM8BolgFPYicq3jFdCi6ZcStjOJlfIZLYLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nckwhsbxifazypO4vMSW527cot3mVYyWVuVZnS2y9QbRQSzX58sMrbJUtkltcSehy
	 54OcQSYm0JA9oGJgLHLeKRygrkgimIc6WV6T66RYGyAEAcMTlHocy2tTmElNoS7jFl
	 bGSKek6YA30XoMC+vBx+2s6glRBX7BaqZ9OWguQqtOQ3HyLp6OjlWZSNeqpPpflYJz
	 1TmPI8aA3QdMbUjfoLoQyh6bHd1VDJsWvjQFvhE3JdimnnvZALWl4zyKJZgpt339C5
	 fSNBG9AQujVw7zaJk1hSUo0AUypE2bFCTyY7NIZ1qg/elrO5df8RFpMzNlQ3JdUWmu
	 z9ghuwZPMAuIA==
Date: Thu, 10 Sep 2026 15:41:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/12] fs/proc/page: clarify comment in get_max_dump_pfn()
Message-ID: <aqLBc20gZyDfkhdH@gremlin>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-11-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-11-008fc8d579fe@kernel.org>
X-Stat-Signature: 4mh44br4y413gmhf8h4uwoy7c3dizpe6
X-Rspam-User: 
X-Rspamd-Queue-Id: 097FF140007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789051321-492328
X-HE-Meta: U2FsdGVkX1/d6f+/AbsxavZ7uFu6t4QmI9yEiAD7lQEmL1HS120SEhKL9Ksdt9UHLQOK1hoPJMayQ+pFZVHZleR21T2LrpLd/QX3+Q8NKNughmwb4yIcGfpgQLJGEHoMyTjJ0BHRfW5n5vy1NreQfXRjogjDsjxRqygMGWsB5zicJtQ6M5RyFyOn/nsP5tdqM4ydZMMTxXg6mApOlR+hR1dj8sK87MefJefe7sTkeF3VqO+NW97tW+ODJUX6U92iQN4zPbWr02zL30LlaL23vZfvrt8kHPRtFNZXRCUmg0yS6azWUo7KxVQbeZJllevYlRKhNEUWzTzfx7J0LAzhmUVTk540umK6HnwbXs5EvlRIBcgR6Pnsm9fV45BnctD2kQeHxJBCIRDXaMddB3/ph9I4o4VdTqqMJ6oH/dYy2iBlrLx3kpB2uazjlDwNNp54xC5EeQXZ/nbeXXbrLiO0KeabfNdPvZTFavlge7+hvO+fA7+CxA+BGk51lG40uptdUdj5mRwxXGHR9Y8dLkEqoMBP78I9tMxa846VVnbvFshzPP4B9RtLGjf7KCba+m7VP5O/STfKsPmXTOIvj+XEwpd9GsC/y394SpbSAcsjs5FSK742acU5NraTjdwTfLbMuCIszNJyjKcacaRhPz6xwQ6HTmo1WnesgKBFsBgbf5fto0IR6rbU+7kxPY9ixOM/EP/ZYtByzwwYB2EGlnDmmARUK2U/z5UMkk0ygPRge8arucYQTbR7ur+T9aZ2O4ICxE6yFr0p/cvihGxFYj/QV4X5xrotGP1/2VBTbJwsjaxi+rBo1GmdN2doWD1UhmkNVGyWfrqSG+JXAuMGqoUwkJC2Q8liwlDjmgMRxNqDGH30FqkKKvBgie0epNF53kH5OdSYgjAEo0X6IKQKmjCE3b1kXjeDIep8c1SimZhPk8Q4qrAuyz1N5GGF8P1L5u2MFSEN8p4+ZhWVNvQsWgI
 Z5JRjU+B
 maLXE15wfH6yA2YqcCqsr0AwNBOZMjLgnEDL0lPO52V5CGMVbG+sKIG5Emg2aMuRKDaPHs43z0iX97gezblRlfLerT/yp3LP6NNLfrQ73Ig4VH3yG/Smby0/2klpGzyj/WKyhXXEK+P01Yn1bPThXSRMGYZGWSlEqa3pSabgObJax2+DPRWhPrW1cpKQXmYly8okvg0NFWTL4DdL3nELTWv5Iq5hpqLR2fovZ3qyGzhP8Nk9CGQx3GIkYX2Vq6TYZ+6RD/g6lK34W6uaClPnt6Mwb34cZuWxuvRRQOrQWzMmtbwwKXNCXx8nWJ71uGEoDaNjh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:33:04PM +0200, David Hildenbrand (Arm) wrote:
> pfn_to_online_page() will only succeed on some PFNs within the same
> section, not necessarily all. Let's make that clearer.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Nit on comment below, but LGTM so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  fs/proc/page.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 260772b20bd99..6856ff3e3cf28 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -31,10 +31,9 @@ static inline unsigned long get_max_dump_pfn(void)
>  {
>  #ifdef CONFIG_SPARSEMEM
>  	/*
> -	 * The memmap of early sections is completely populated and marked
> -	 * online even if max_pfn does not fall on a section boundary -
> -	 * pfn_to_online_page() will succeed on all pages. Allow inspecting
> -	 * these memmaps.
> +	 * If max_pfn does not fall on a section boundary, pfn_to_online_page()
> +	 * can succeed on PFNs beyond max_pfn within the same section. Allow
> +	 * inspecting these memmaps.

'Allow inspection of' these memmaps is clearer I think. But this odd turn of
phrase existed before this change also :)

>  	 */
>  	return round_up(max_pfn, PAGES_PER_SECTION);
>  #else
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

