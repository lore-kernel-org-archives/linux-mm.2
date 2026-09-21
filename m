Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D113FC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86FF6B00CD; Mon, 21 Sep 2026 03:49:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5EB26B00DB; Mon, 21 Sep 2026 03:49:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26FE6B00DF; Mon, 21 Sep 2026 03:49:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C7D76B00CD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:49:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28CD2A0572
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:49:40 +0000 (UTC)
X-FDA: 85236994920.25.55D3697
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0975C40008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:49:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=L4k1kRQH;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789976978;
	b=jMZWmYdi7m+ZP8FpWFbh5BGJuoxGlnxgCgw9hRMKgG0nL4JdOqvaWDyEMAKqdZwOHVCFbu
	VyjIuwjp8CMuFrwvo/4Uwr/TNqsSTa1vLceEYOZmslpoqPeJJDYxVRi6HC2A1LBw0l6Y4m
	JOMUKu1wB79+0vrfgbSNT8C1TlN02CQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=L4k1kRQH;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789976978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1vigVIqG6XCaXAXwVAejbP6zF3lkMv0QAYSAYCRl1I=;
	b=AeYRJU6HXymDDNlIwq6gp0N68q8pHCufb2VUQEG4AIDPBSXQe5R+aHiwh0iHjXDj8UKg/9
	4OrOn3K9XDTdEQfqyZClr1hnwTO1f/bUVCzn3QcB708RTCkZjV0lYGv3ZoZOwIkjNYT+zg
	yGV8cpqFqeQvIWVZPgcc0OBcRXxJWHI=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e8185e037so14534645e9.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789976977; x=1790581777; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N1vigVIqG6XCaXAXwVAejbP6zF3lkMv0QAYSAYCRl1I=;
        b=L4k1kRQHqdoW75OeTGP0JSHrrTAhrklORQ6Obirzq3B1XTn7BoQR2YT5vGgfzH0axe
         c7WXMRL6eg6YpVxqhxztnUZslU+JgVHlGabi/SXHZwGroaYsGhOP2J4f7L3pJApkDWV4
         JumTa7UB9hHv5gUwyy1jy4YuRud229h5NZHe1AC/o/YWt0Pb9vrSIke1jY91DB/IsBu2
         soogj7XtSSRjEqcaP+axi8JLdQG3DlJPcCAvIs3YQhcwpEk8rWM97WWfu86wZ6FuXKsO
         A8kwAFo2+IBCPE2X9c9x1L6EXdtAPP7fvhsPOqHR11/RMdjXfp1/UyB1rtclmY/aWw3F
         YsmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789976977; x=1790581777;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N1vigVIqG6XCaXAXwVAejbP6zF3lkMv0QAYSAYCRl1I=;
        b=XPDcOUrwYVtu/MiqB1qjHHfy9ruree5ifm15vi8eS8qimykhH6l6AA5MzrGSf7NVqR
         Fu2L3kRAFlKe2cuOVaeJ9MTdQ6uEjAgh2hQyRu4VGxos02u6DBs5vU6V4nKycOAI+E7Y
         k8izlsrCPEWtKWypb+d5I+pK2q9FNUYqbl9yDMnIa9P0yHtCLT8oXMmHHxqDrXmW2jrR
         6qoSjoxHIm2wIok+VQFBCtzFUNRS6FbqHV2UWTy/S08+g6uTInPGAwOeTMSWaUarslL9
         qTSwU9ZIFISPVmqoq8eN1ripKuc2laJwcFgszOGxTkBypcmcptCYU8uWVoJzD9gLK6NH
         /5BQ==
X-Forwarded-Encrypted: i=1; AKwUvBy0/V1/lW/P85mEhV+pc/9whjZMbCeQ9D43aVyRXQoTiwYVkzykECnyApj/pDfGZSRqoLOtfBL15g==@kvack.org
X-Gm-Message-State: AFuF++nyxTFVgmfKRebWvVyxMcf4Ht/9RPrNaCTuzyd0MU/U3eIG1QnV
	VjSAeNUXOZrrW48okWBCT9S3BSHtsV44zCtiXaz43zFiZRMHI5Ku6tpmpyQun3nwdNM=
X-Gm-Gg: AYBFou3o5jilgdsZBbXfizA9eoj5+ltTDEVbvL8KzyOxqGFBi2BanpIEHA0xzKG4b0o
	qvFD+AHqjNkJhbWVzzfpjf29C939XGuxOKNHu+8POKJzb9rtKJnKLqh/qzIR319NUmxcfDDxKx/
	95XQXkd+Ar1Lhd3P7Ih7CQuiBqQN69Jc8/+8AQJ5o6lKeo0UrG0JNk8oU3fYQxvEMaPaok5It2M
	YYHSRehKpXOvSFsCvxN3FbX5uD2xtwqN4iUj7o4B3iG8NmcOtGjBqd//N+NlpzKwDetuxPocPYh
	VySFlLWTKFgC7R+fgTdbh819PVSMgVi/yYJ/QvBn7dSv1/qRXX3jmiHEqV2NAeuAJKsmeFhEuSD
	YfSuUaqKymhQnKGcTWVT2eY/yu1R+UKHL+RR9FO8UiKBR8n4C9Fyr/aTtjzvEShsEEfoZIbWLL5
	iVVHVUpH8AOX7TXzAXsV/jG1Es9ZTNUyH1dcBB+erD/fskTaFCM7NmSwAeaqbOBgfcHG3qDU7+c
	zfMOBpePg==
X-Received: by 2002:a05:600c:3e07:b0:49c:fc6c:be09 with SMTP id 5b1f17b1804b1-49fc58594d0mr133016185e9.32.1789976976661;
        Mon, 21 Sep 2026 00:49:36 -0700 (PDT)
Received: from localhost (109-81-82-61.rct.o2.cz. [109.81.82.61])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4872459d409sm19992757f8f.33.2026.09.21.00.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 00:49:36 -0700 (PDT)
Date: Mon, 21 Sep 2026 09:49:19 +0200
From: Michal Hocko <mhocko@suse.com>
To: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	syzbot+c61d6962d0b7e698439e@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] mm/page_alloc: enforce upper bound on
 min_free_kbytes sysctl write
Message-ID: <arDhf-LH0ZAxsd5V@tiehlicka>
References: <3c1598eaff225a155cdec5e92d5c97fbfc6c00fd.1789724312.git.med08elkadiri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c1598eaff225a155cdec5e92d5c97fbfc6c00fd.1789724312.git.med08elkadiri@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0975C40008
X-Rspam-User: 
X-Stat-Signature: et7g58gx8qzi6gxmptchz6iaqbxifc67
X-HE-Tag: 1789976977-106971
X-HE-Meta: U2FsdGVkX1+ENCnB/WgW4vIQBbuNDN4acJrAKlb7kqCzE8W4AAGymyHOEuZ0ghCWRbddrZGTr3RLRhhVz879T8wGtlslLrK5dHMSGchJgjKvVznY9rmLpYF1RH1rJMZhDfgQTNlhLqu9yNg030q+N7eTwnSAN5DXuDxuGT2l/xTEaMgL+jUkAAfYZdW2+qa9h2106q9/IokY+d07gGEmYPzTmqIz8PX2V+iZDQtXG0h4vEJaeJ4fPgpEkHFHPMY+Byvts8X22/Cf/608zsblSjLaKQJtrNp2kLCHDLh7aTcTfl6+Jewj4vZ221SVL05hPe/fzfcCi8SGPAP5VV8nOFTeZU45snowF3XYQ+2ncItMt8iK6vb2cErX3sICmTwm3OT303F7lTNuuNFewGo+5GuxtgTxDJ2XtZbU5FHhkWPGKmm9JkZ8VhyEIeS9ZA4M/FrPbF3ggv02WIV42PmeNsFo4oQprsGaZherS2Q9DZFjY7LsXs2Tg7aICawhE6i4raDTXQ/uhFDqbNPz/hVEhmgxc9ux8WlDFBelFVecoak2n+zmWQjOEe2zG1tmW8M8W4TghhINnQjZ5r4HHitZ73hGTi8FmZZPCLEccByq3R71Uu3Vf5tlkh24XJ2TyifhLAmqNBiN3x95iTHDBZ4lAooMKmk/A311GVO6CQUVZfc57jCsb2aRoXI/H42AS+nTPTfJSrYChaa6mOpb6Yfz/1pDUmWLCjDiB7dshgDbuNq/54Cl1MuIPUzj2XjWDmFQs/3Pn1lQxwzLWOPmg+MfswE9BzUU+kjm22ozoMYyWNTHfo+X/+8ALFtzx0T0ABod+IN4wY6w7QC66oYpdqpEaGGKLvozIoczc9by513Xy058F0Zxsnzx9+1UbK8udx4L2L5hcjpzoW7rGnNtSLKlFIsO5j0nH9wKUfO1WZDlrwdcIzczSu9pIEqfzCf+3N/qbiwTImbKRf2E0rg/iG4
 NzffcmxR
 oY2/ryPkvTPCS5faZowyl9Fd6RJefVj1Z5lg09G+8QpDqM/1BVymr6v9tNYkUa5uKJAV7ijWqdKMq/PvXEFC2cWQMph+dbZeSNRSsCQbR//5erj+U1ab4qKrXOSh+41BFGoxN/HM/hpwq1kyG6R70WDQqAi3gL/oomYuOOVRbdK3ny3xP4nP/24QEi0BdyiDjkj9j78SfrICIyn6n5qSs3p7Co42Ob4ZWj+dpB8nJ1++cSZwzeklvCT1toWmvByfICQzwS0Zt67dCZS7Lpb1Mav8nvEeqLYUBOOiBfctTNIF7g9jYxxr64TKwuhJ6ArdCflKeJiNIucyE/gxGPJr3k1M5/Ahm3A/nZLhr4BbAMNbMgvCguwPSzfxIa3izOkhVdg4KQBgElv7+XwwORjS/ytP41ywGSe2ShRfmnfOr/mvjzx3aTu8c+1h02YuFUQGnYTXCMfagTvAYjTAe9zkNeQQ2dYdfwOrCNaX7zV7PApoQYh/NzC79TipDyY6hps6uJKw9syAK44bmYHwa4zeop4Vu7FcWPUGtyaACj+bexK//CZgzQy8I0oLx/shRtTpGFPuYc++SvEiLcebu6QO97eGPOBuF83dAfjCtPHpOBN+iztBxRePoIfhMayBM7gHQu7R4MVXiqMp2Q0OMELosrAwOM/fp05HMq2rIRHcLQbv/M+TzjAXcrCYAxOJG8wORfan3tL4mwt+g8GASjGMqFaayXa40vEAf4juaR3vc31viJxo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 18-09-26 11:45:51, Mohammed EL Kadiri wrote:
> syzbot reports a kernel panic ("System is deadlocked on memory")
> after writing a large value (e.g. 3145728, 3GB) to
> /proc/sys/vm/min_free_kbytes.
> 
> calculate_min_free_kbytes() already caps the auto-tuned default at
> 256MB, with a comment noting larger values don't make sense even on
> big machines. But that cap only applies to the computed default --
> min_free_kbytes_sysctl_handler() lets a user write any value, since
> it only sets extra1 = SYSCTL_ZERO, with no extra2.
> 
> An unbounded min_free_kbytes drives watermarks past what the system
> can provide, so every allocation triggers reclaim/OOM with no way to
> make progress, and out_of_memory() eventually panics.

This is an admin only interface and we assume whoever has access can
realize consequences of the set value. Auto-tuning really cannot make
any judgment call so it needs a cap. The same doens't hold for the
admin.

> Fix this by applying the same 256MB cap to the sysctl write path.
> 
> Tested on top of upstream master (5dd1818b15d9):
>   - Before: syzbot's reproducer reliably panics the kernel.
>   - After: writing 3145728 fails with -EINVAL, normal values
>     (e.g. 200000) still work, and the reproducer no longer panics
>     the kernel across repeated runs.
> 
> Note: this covers the reported case (a value far above any real
> machine's RAM). It doesn't prevent a smaller value that's still a
> large fraction of a very small system's memory from causing the
> same problem via lowmem_pages in __setup_per_zone_wmarks(). Open to
> a follow-up there if maintainers think it's worth it.
> 
> Reported-by: syzbot+c61d6962d0b7e698439e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c61d6962d0b7e698439e
> Signed-off-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>

There is nothing really to fix.
Nacked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/page_alloc.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..8cb62879bf41 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6933,6 +6933,9 @@ static int percpu_pagelist_high_fraction_sysctl_handler(const struct ctl_table *
>  	return ret;
>  }
>  
> +/* Cap sysctl writes to the same bound calculate_min_free_kbytes() uses. */
> +static const int max_user_min_free_kbytes = 262144;
> +
>  static const struct ctl_table page_alloc_sysctl_table[] = {
>  	{
>  		.procname	= "min_free_kbytes",
> @@ -6941,6 +6944,7 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= min_free_kbytes_sysctl_handler,
>  		.extra1		= SYSCTL_ZERO,
> +		.extra2		= (void *)&max_user_min_free_kbytes,
>  	},
>  	{
>  		.procname	= "watermark_boost_factor",
> -- 
> 2.53.0

-- 
Michal Hocko
SUSE Labs

