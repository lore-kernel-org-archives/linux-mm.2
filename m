Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E668FC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 08:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF2436B00BC; Fri, 31 Jul 2026 04:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA35B6B00BD; Fri, 31 Jul 2026 04:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96A226B00BE; Fri, 31 Jul 2026 04:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63CC06B00BC
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:06:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D05C914037B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:06:06 +0000 (UTC)
X-FDA: 85048338732.01.938B92D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 075A4100002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:06:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gzjfaPKJ;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785485165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jhnv6E91VovHWUzkYJZPMYasnUiAVIO7XKKczSggJkY=;
	b=kJj40UwZ36P9zP9wxuOhmKPJVesscoDrBS68NHwgfTjSM5agPQyH+6fnKbnooUajgBWkJA
	rIhFTzSQz0N3hNaUZxSujpnR+HolIe2Kf7cSVoJnVgqiPNA17wpLxHmq1CfsK1d98vSI15
	k9EVrRCfv8Od/JHemyQ1cZYunmb7TOM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785485165;
	b=nXKs6KQWBSzXgUFClop28+VdY6ZNr0uMR2zy3MV3kMDSTyNIdnPz09ub+LyQIULd0jVvAr
	Cigo7KtGIidq2njsuFbr+p6zpPGTRsGqgfvxlJp/RdlB8M+f7hURf0iCtYofK7uE++Elez
	CZPnOxffKZWUHV6pfuVF8eyu3tDQCRc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gzjfaPKJ;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E1F4A43452;
	Fri, 31 Jul 2026 08:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122F81F000E9;
	Fri, 31 Jul 2026 08:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785485163;
	bh=Jhnv6E91VovHWUzkYJZPMYasnUiAVIO7XKKczSggJkY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gzjfaPKJZTOzmGlAuQkWDSuLVMJCDu1KA2DDlT8HkDTFQ7Q/8VI7/aeLYVTtaG1bu
	 1hfUUCg6MCgVmd/OdijbCyAz2WKlhbdbot3Tf/TaC255ZDRCCRfreDdBktOwaj8z3y
	 AyQ2MwmWJXNDLUcbb+jaI4PMu434OAPB7jCJ28yEQN3uTB575kIqlwnu/RVCQy/tL8
	 OduhOGjX1KdtBLjhHS2FaaPPi7M/lUEt130z6xwJ1O434cQQlMgWLBMzo3mCB0WAG1
	 bB7306jA5H3nclKAPWwscwbNrr/PJV2uC3ZJ5Dqb9mKSPJh5aKc0xelUwmpC1/5EK0
	 t+Y635gfR5xpQ==
Message-ID: <e0b27a56-2cba-4115-ad73-28e9387c040b@kernel.org>
Date: Fri, 31 Jul 2026 10:06:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: only update lowmem_reserve_ratio on
 sysctl write
To: Jianlin Shi <shijianlin11@foxmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
 <tencent_DB426A4AAD75DA751446F443770939B43205@qq.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <tencent_DB426A4AAD75DA751446F443770939B43205@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 075A4100002
X-Stat-Signature: shg4ngytxo6urt5y5xbto7qq9zmbcx1q
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785485164-935565
X-HE-Meta: U2FsdGVkX1+9wewpNkoe8/wxpvRuXgoPbG2HqIY6kXFhDDQkmsVxxMj8IrWvkoRkIpMe4za1C12DwJa2R6FfX+uCIbTKTRCb3e2aqvd0/oFBK+GaT4RtdYvXjoRZ1O9eG9m9HPBaOQB4e0XitU8M4UFB5Pv+qiq8i/GXUNQ2KFCBOzSQ1nr7VobXRCArh/M9rjH5laeqjxM/YgolIWLYlNnRQrUWgRbmptuqLYso0eBqtdxjmsY3mZwbfeFmGKsMudhbEYaG6yap5flAlYq01Cz+CHKEWwuAHUa/hyPt8O2YDVyiTT72sh8X0i5bZO2WkpqYFiOd6f793XM9jbUbcirjJdg3cqI3/H57iPC2xIn7lbS0E0oGX68sEcbvP/G1+fFrTWA84O2ZdmsjZwNW6C57DJioOWpOrKc5pc3J11v5FLFGKDOP4d6kK+lnYvugjb+1xjcov8xRueGYnzNElO8AyEHBdEsjrBg5VXEaxVlQDZX5rNuCGcVEjPIqdx297ufziCYPpIEEN6lCNG9GUVYrXSRNZYbcY2aIWgbXy7Lat9gYflvnNbtR2aQfQwYgxPpid+HH9UAEqLzECba3NKIRPWtTbgwGinGmIpeLGdORzSyJoqejdl/lUY8MbSqPC4DOpYBbQMc2tKK/CLOeKvnXNRzOU2j/UlRn0XRplzVIGhagdguxm3ejteHt+R7bTjPGTrLeTU+XcZEwakMEK3rDQCSiSrxzcG/slhdiBUjAfhmR74Egaix7QqQT4tZbsh9HRnq/bR3Wbqm7kIMLgKr80LB0FLFOomLnLmRi6MV05OzfXayirwC5+A591M+Os0GFkOLW6IJWldFq1dDZLKfrMZxBvANaDpkZ+iaCT1eP83d5CwXa2aR+BSRD5jgfMck/b/B3fkl8CO4J/rNpW0JupdnFxVXsZ2TIb0cX1R3NLXCANHJQfiKLpXKmybfJq+AtbMn19y1d+QMoAnM
 uu6yWxt/
 Op11kCpq+u1Zvuxe/o7Ct7xrTm7B7QTjZZywnp1nlZvmkjNUNCGuoTWDQr7EyUnNMZA+OKOxW2WKBl5re58RK9rmEdncBTy4eQNt/42HpzlssOxNZIes8zv/KYLcxZWgEFc+xX+4ZPxD7QWaHKagUJ3m4Z5iNNV6ORl/jZCabv3uL5XNK2kPrbdyYHaeulfaBC6PoXQ2WBi29GuxUezpxLj3V1ZZy14k1jPNM30B/TiNx3nYdxDwHKdMjrEX83ZaCzrFCjvXJTdVBjhL3Qw6lgA+6yeCvwwoAYWWe50lfULITSZnLwPrYE8SNrbHviWhdbBR2zVLqnYssrgIvmM5MRo7hfla/jKH3nF/tlLo6V7BNhs51nq5PvPVId1KnTPDliCzN9Y5OO9kJfl6NNJZCAx0ScWa0ZbsAnYD6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hm I also noticed you didn't cc everyone from PAGE ALLOCATOR section in
MAINTAINERS. Please use scripts/get_maintainers.pl next time.

On 7/31/26 05:42, Jianlin Shi wrote:
> lowmem_reserve_ratio_sysctl_handler() ignores the return value of
> proc_dointvec_minmax() and always calls setup_per_zone_lowmem_reserve(),
> even for read operations.
> 
> Reading /proc/sys/vm/lowmem_reserve_ratio should not recompute per-zone
> lowmem_reserve[] and totalreserve_pages.  Only do so when the sysctl is
> written, matching min_free_kbytes and watermark_scale_factor handlers.
> 
> Also propagate errors from proc_dointvec_minmax() instead of ignoring
> them.
> 
> Drop the manual "< 1 -> 0" sanitization loop in the handler and set
> .extra1 = SYSCTL_ZERO on the ctl_table entry so proc_dointvec_minmax()
> enforces the minimum on write (suggested by Vlastimil Babka).

It would be fair to explain the -EINVAL change in the compatibility note
too. FWIW I consider it low-risk.

> Compatibility note:
> Previously a read also sanitized sysctl_lowmem_reserve_ratio[] and
> called setup_per_zone_lowmem_reserve(), which rewrites each zone's
> lowmem_reserve[] and recalculates pgdat->totalreserve_pages /
> totalreserve_pages (visible via /proc/zoneinfo "protection" and used
> by page allocation fallback and dirty-limit accounting).  After this
> change only a write does that.  Documentation describes the meaning of
> the ratio and the derived protection pages, but does not document any
> read side-effect.
> 
> Worst case for odd userspace that treated a read as a refresh of those
> derived values: lowmem_reserve[] and totalreserve_pages remain at their
> last written/setup values until the next write of this sysctl, or until
> another existing updater runs (e.g. adjust_managed_page_count() on
> managed-page changes, or init/watermark setup paths).  Until then,
> allocation fallback into lower zones and per-node dirtyable memory
> (node_dirtyable_memory() subtracts pgdat->totalreserve_pages) may not
> reflect a refresh that such userspace expected from the read alone.
> Normal readers that only consume the ratio array are unaffected.

Well there should be no change to the totalreserve if nobody wrote new
ratios. Other paths that may change the result do call the update as you
describe. So this should have no observable effects anyway.

However, except watermark boosting hidden here in
calculate_totalreserve_pages():

    /* we treat the high watermark as reserved pages. */
    max += high_wmark_pages(zone);

The effect of boosting on this calculation was probably overlooked. I wonder
if we should also (as a separate patch) update it to use a value that
doesn't include boosting to make it stable and deterministic.

> Changes in v2:
> - Add .extra1 = SYSCTL_ZERO to the ctl_table entry
> - Remove the manual sanitization loop (negative writes now return
>   -EINVAL instead of being silently coerced to 0)

Changes normally go under to the diffstat area* and are not part of commit
log. Hence the suggestion for the note for -EINVAL to be elsewhere.

> 
> Link: https://lore.kernel.org/linux-mm/tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com/
> 
> Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
> ---

*here

Otherwise LGTM.
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


>  mm/page_alloc.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0387d2afd..a7381327d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6683,16 +6683,15 @@ static int sysctl_min_slab_ratio_sysctl_handler(const struct ctl_table *table, i
>  static int lowmem_reserve_ratio_sysctl_handler(const struct ctl_table *table,
>  		int write, void *buffer, size_t *length, loff_t *ppos)
>  {
> -	int i;
> +	int rc;
>  
> -	proc_dointvec_minmax(table, write, buffer, length, ppos);
> +	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
> +	if (rc)
> +		return rc;
>  
> -	for (i = 0; i < MAX_NR_ZONES; i++) {
> -		if (sysctl_lowmem_reserve_ratio[i] < 1)
> -			sysctl_lowmem_reserve_ratio[i] = 0;
> -	}
> +	if (write)
> +		setup_per_zone_lowmem_reserve();
>  
> -	setup_per_zone_lowmem_reserve();
>  	return 0;
>  }
>  
> @@ -6791,6 +6790,7 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
>  		.maxlen		= sizeof(sysctl_lowmem_reserve_ratio),
>  		.mode		= 0644,
>  		.proc_handler	= lowmem_reserve_ratio_sysctl_handler,
> +		.extra1		= SYSCTL_ZERO,
>  	},
>  #ifdef CONFIG_NUMA
>  	{


