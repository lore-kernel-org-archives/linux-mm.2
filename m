Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A8CCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 16:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2DD56B0088; Mon, 28 Sep 2026 12:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF0F6B008A; Mon, 28 Sep 2026 12:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5196B008C; Mon, 28 Sep 2026 12:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4DD6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:00:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 829C912027E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 16:00:42 +0000 (UTC)
X-FDA: 85263633924.14.1876D3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C3231100015
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 16:00:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xxh5DmGQ;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790611240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6eGbi4h94EROe2FvU3gHfkuY65w4Ck4RppvNoXrrGo=;
	b=OIWBNdigX463ISv9J2ui51/A1p04slh/UKkMRPPWNqXRcMSr2wy5ljEH1p7tY3LWdL2N4Y
	dpHOoifS7uBVIIKQa46/OqhkoQgrlcoNnbgDyeA2dcvTmxCFoODtEMi+/9S0+tTpk9m/mc
	1Zdj2EhYd+O5z7roW02opEVe87ToGDo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xxh5DmGQ;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790611240;
	b=71R+5ugKoWmxC50j0AIitnCKu2vff7xrLOnQO/GOnJ8J+JetlyAWx+IZe2WG6ENfoDlHtN
	PUHI81RKCqlmFithGI8Pii9BrHprhWEpPSvIhxlDGE/wV0H9KeoijkCH+J4wy9hqAv9Zd6
	dUfpnZ4kapKdV5OiztZMKJF2FsmCEBI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D30FE41764;
	Mon, 28 Sep 2026 16:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD4E1F000FF;
	Mon, 28 Sep 2026 16:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790611239;
	bh=W6eGbi4h94EROe2FvU3gHfkuY65w4Ck4RppvNoXrrGo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xxh5DmGQ/V3AQE5TqtcfppYnymChdn1KQezAimXBQ9NzTpf38wanjTsUBcC2xsLrB
	 q3KAfjYz1hS7deetbUlAEh9Zf1COn4l5weayXaOtUZRUEQArEm+EQUJKRZeX2jjygk
	 +jK5SW8f2MLqPoH/psACmui9jhQ0GzcFtyBOrDF7XMtkjpjdnwVsjnhE5GgSu/fkSW
	 b+xDgGf2/+3ctlnoS2A+TI/NVHC5aM3suqBzpv8WwpKN1mul8+9f2YMQVAEi9oFAYl
	 g3sjtfF5W6v2T6AXD1LK0P2IZTJ63llfRU7UpNIl2Qz3D3CTWYbR1IKx7FXS3berQ3
	 GmdI+zzMw9oeQ==
Date: Mon, 28 Sep 2026 17:00:37 +0100
From: Harry Yoo <harry@kernel.org>
To: Seongjun Hong <hsj0512@snu.ac.kr>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tools/mm/slabinfo: report percpu sheaves and barn
 statistics
Message-ID: <arqNTeIsjXCcYyxp@thinkstation>
References: <20260927-tools-mm-update-slabinfo-v1-0-a4ea0d4dc136@snu.ac.kr>
 <20260927-tools-mm-update-slabinfo-v1-2-a4ea0d4dc136@snu.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260927-tools-mm-update-slabinfo-v1-2-a4ea0d4dc136@snu.ac.kr>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C3231100015
X-Stat-Signature: uh864psp1uwo9wwtrc66sknx8f5o3x34
X-Rspam-User: 
X-HE-Tag: 1790611240-640267
X-HE-Meta: U2FsdGVkX1/bpXwJ0UqCDRVXkXONynPXVVXjijZUAcDPhpGYWwuNky5BTFhvt4BgZRChwvUHd7FTiU24kT6bIT2++M7wb/PXdrGaWdeffDkRK0yj+YoRpC4jmPbF7ajoZfNBVs+Gy9c7wa7yNM0dGLBppDhu2bsBH6S6lj7AqT/wLXKxDqgpljrnZKv2d/wS/BLGhCAJeiczYfCDtk7NRthIHUqYaLeRgq0/ZFE2Etmoq5ohrFcAwbtAteDX0wcpg/zJgGJFBkJEHeS9vrklqY6d159VpgRKaYERuD3TZoU5CBCt0Bz8BNGy0xgpHeMFqhp6a0yOvBY0Gms9ByOnRXocQ2a++j7fn90WHX6uiHDVhBBrlcbEBEx8ot7DXjVuL55ZdzJw8A+xmFi/ZRdTuA/FY9CyLm3YVqzaXeS16oqCSjfZx7Cyb+XR1U0qEjGk05Ght1/DCkRiUkB4niHwIc2uI3iTSYTHaUGEUTPkRKixC2FEiuTY9FGGOJN1QXY/+KYlmedkNtFx3MMBWRSc9xRM5sszqKrpMsAN1ql0E4cOWxGKsdLmptbJmWrHXAjc8Zz8+vwV1fIl2D6YnXTKzfzVYAP0B3j43jyN8Pe7dej2fIF4HymD2adIFWWnIilGPEc62IKegg2o3RmO7kIm0pPfGZLh2xGMcsytcw1HbD3vKszleymz99S4g8IU8QJ1Z40bsv/5t7ebzHLJYLOQQ/Eq2xFCHzqUm8IqlbKi3PW4oj7XgMAt0D9x/irlgaCDIscW98h+6dVGyRuOZN2KEbRuShlcFHlDjJmvPTn3mBTkeucm9frei1Ysx5ShWwIFnar4iD+MUVNFzdNVpT8H1EHiqVrv85W2Q8mA/eORrb1XRYlvMqcqg6uuvvvQ4zhgiZd89dMAAeb5X/rieFD7XMJ+51hp1+c4MVGpszTG5yljFdZU6Zb41a+yZ6fzLe8E+3TWcnghId4S3/uZdsZ
 2+ICNjb9
 v5i9dOSHBzcawfHbwqlfF4u7Av4QDzm0TNtuc7UlJbnm7Rw/1oHlG/UbKS2UAxYiUysWRbhOw75JXXW025g0Y1b9CHj/NW+dbbGFmG30LIivLxvxdUWZrAqJnwigrE+Cxq+YYDq2EDDAuykJT6TaFoVDkIRSfuqXnT0hcUXtTSntD5d9iYcMfFinzmuqhmKLHvuQOYeb90EB69kw+7rrZ5y1mN1CmO06I+tVlJGoC664qZiCCASyu1a+/cp2moUOXNU0O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 27, 2026 at 05:57:28AM +0000, Seongjun Hong wrote:
> Since commit 2d517aa09bbc ("slab: add opt-in caching layer of percpu
> sheaves") sysfs provides the statistics of sheaf and barn, but slabinfo
> did not utilize this information. Display perf, API, and sheaf allocation
> counters on slabinfo report(-r).
> 
> Example slabinfo report output:
> 
> 	$ slabinfo -r kmalloc-1k
> 
> 	Sheaf capacity             12 objects
> 
> 	Sheaf Perf Counter    Success     Fail
> 	--------------------------------------------------
> 	Barn get                    4       43
> 	Barn put                    4        0
> 	RCU sheaf free             34        0
> 
> 	Sheaf API Counter        Fast     Slow
> 	--------------------------------------------------
> 	Prefill                     0        0
> 	Return                      0        0

You mean "Prefilled Sheaf API Counter"?

> 	Sheaf Objects/Allocations

This doesn't make sense to me.

Perhaps should be separated into
"Sheaf Allocation/Free" and
"Sheaf Refill/Flush" ?


> 	--------------------------------------------------
> 	Objects flushed to slabs             0
> 	Objects refilled into sheaves      516
> 	Sheaves allocated                    7
> 	Sheaves freed                        0
> 	Oversize sheaves for prefill         0
> 
> Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>
> ---
>  tools/mm/slabinfo.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
> 
> diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
> index 84359d628f2e..dbc72582ffab 100644
> --- a/tools/mm/slabinfo.c
> +++ b/tools/mm/slabinfo.c
> @@ -574,6 +582,39 @@ static void slab_stats(struct slabinfo *s)
>  	}
>  }
>  
> +static void sheaf_stats(struct slabinfo *s)

Perhaps let's fold this into slab_stats()?
I'm not sure why this should be in a separate function.
These files are part of SLUB_STATS files, that are related to sheaves.

-- 
Cheers,
Harry / Hyeonggon

> +{
> +	if (!s->sheaf_capacity)
> +		return;
> +
> +	printf("\nSheaf capacity       %8u objects\n", s->sheaf_capacity);
> +
> +	printf("\nSheaf Perf Counter    Success     Fail\n");
> +	printf("--------------------------------------------------\n");
> +	printf("Barn get             %8lu %8lu\n",
> +		s->barn_get, s->barn_get_fail);
> +	printf("Barn put             %8lu %8lu\n",
> +		s->barn_put, s->barn_put_fail);
> +	printf("RCU sheaf free       %8lu %8lu\n",
> +		s->free_rcu_sheaf, s->free_rcu_sheaf_fail);
> +
> +	printf("\nSheaf API Counter        Fast     Slow\n");
> +	printf("--------------------------------------------------\n");
> +	printf("Prefill              %8lu %8lu\n",
> +		s->sheaf_prefill_fast, s->sheaf_prefill_slow);
> +	printf("Return               %8lu %8lu\n",
> +		s->sheaf_return_fast, s->sheaf_return_slow);
> +
> +	printf("\nSheaf Objects/Allocations\n");
> +	printf("--------------------------------------------------\n");
> +	printf("Objects flushed to slabs      %8lu\n", s->sheaf_flush);
> +	printf("Objects refilled into sheaves %8lu\n", s->sheaf_refill);
> +	printf("Sheaves allocated             %8lu\n", s->sheaf_alloc);
> +	printf("Sheaves freed                 %8lu\n", s->sheaf_free);
> +	printf("Oversize sheaves for prefill  %8lu\n",
> +		s->sheaf_prefill_oversize);
> +}
> +
>  static void report(struct slabinfo *s)
>  {
>  	if (strcmp(s->name, "*") == 0)
> @@ -613,6 +654,7 @@ static void report(struct slabinfo *s)
>  	show_tracking(s);
>  	slab_numa(s, 1);
>  	slab_stats(s);
> +	sheaf_stats(s);
>  }

