Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6E3EC2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 18:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F976B0098; Sun,  4 Jan 2026 13:14:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDD5B6B0099; Sun,  4 Jan 2026 13:14:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13296B009B; Sun,  4 Jan 2026 13:14:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B30876B0098
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 13:14:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 672D61A12C6
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 18:14:47 +0000 (UTC)
X-FDA: 84295082214.17.AFFE7F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C93454000A
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 18:14:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="UC/MCP98";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767550485; a=rsa-sha256;
	cv=none;
	b=Yaw8kdZ1AkrLuZo/fVs2Xvsmp55AFDtr8iNEnUdFexgF485/Erl9q5ZEVOMsL4mhhKYNJY
	ICG2E/jGdv2dB4HbUIc17l226M1dxgJ22nge8/gOkZtwLSEHzAiG0ykXtVUq+b5FWlGw4Y
	JmiukD9oytf7q/2azaiW0v5xwm4COwk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="UC/MCP98";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767550485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ao7Ys3XAfy01aKjs5W1Sw2ZSuEhzNVkMNr8j8FICp8=;
	b=kYTbTjyPBqhHl70Dm0Xr2jsht3uQMKwMgDmQfWMolPFzwqzeDZyvlVi+x3BP2AKBORFbVG
	hm81DtnhtdM22BqFP15LCI+GfOoYBjZgLu/nXAo+m3OyAaaO+9OycQdhjGcBFEzDu2iwlv
	1yyriKIMkZvZXnInGCIrhAELZBbJ0dU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B39E60010;
	Sun,  4 Jan 2026 18:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A417C4CEF7;
	Sun,  4 Jan 2026 18:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767550484;
	bh=uexxpGTRJdOdjecdMSGkGbE8JdVZGYKsGcsnXnMXSSc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UC/MCP98UsfJ9tekhTU2w51FdkgZBaC73S0T3w5Vfe1JW1JVNXSvBo/gspEotD9AR
	 M6x6lTFqA4Kd+yzrAyUUdG/n9F95nupj3jIyL/98gH56ZKtylj5uDTFlMVPIR4cxRX
	 4RvivEddpK2EWpYW0qP6IXEOUvWZZLMA0iVma4UQ=
Date: Sun, 4 Jan 2026 10:14:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: wujing <realwujing@qq.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Qiliang
 Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH 1/1] mm/page_alloc: auto-tune min_free_kbytes on atomic
 allocation failure
Message-Id: <20260104101443.f10264bc9730de884b52c5a2@linux-foundation.org>
In-Reply-To: <tencent_9DB6637676D639B4B7AEA09CC6A6F9E49D0A@qq.com>
References: <tencent_C5AD9528AAB1853E24A7DC98A19D700E3808@qq.com>
	<tencent_9DB6637676D639B4B7AEA09CC6A6F9E49D0A@qq.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C93454000A
X-Stat-Signature: 8byxe6qudx45aokbdj8bummaxuhg6481
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767550485-504552
X-HE-Meta: U2FsdGVkX1/LpcuQdAB4ZLwjizQU3TeSlKsznqU6vj29fcHlj6aiYoSjIBA6Sqi/mkgklvI7EjVhzo1kF4xDZVnPHgCOds1koX5RXKmCX9i8IjKUYEnFFMMuGKtX/gCUVRR2nG2kg1q3bUOXOlHWTqt5YxMdUo0QJjltVwwrwHG6KG1HnQ8DA2VfI3kce8qEgR+WNKm7NWyokMHRWaC3FFjm743cE8m67uoG9G3S0p0nbJrf4bOaRrjKuxCBgS3kqpwA/QvIM93KxCL21nSgU0busN7OWWGqwZWsfUf850SdtRMjdZEuIpHX+8X7AvpY7F0gMwfVbg412TsrtJv7PN/3crWErez/VMO4WEWJbIJ/GmD0nQ0FDRUlf6f4v4L+9aCI/bI94nlVqh49KTTThunePoPwGy7Z4be0AhcjEJEBTqXFzTssSiSry++zkTug7ZAw3SzKdFILGxg7A3qZSvc465Tet8iC3Y3qkqe+KtbbQX/cnS3UHSfXx4hqAc/FyHezXpaat5Dsc5Rd3lebDsb29pBzoSAstqUDMgt5HFaYM1sDvs0hntEjaYEdYxgeSTR6/Kirm2FeriNlsxWxctsm7ufsvqrdirmFx6Ejg0EhnUL/4d/13G5uBtZG5Ox1nIPa9EY5yvkdolHmA2RHAIJ5J3bmUjDXtbUKsyIoeyDrSaMg1JpCkCy7AtMzGLEwVhDd2GmyA6kPup4XpzoOiCDifgnKrSsgxL2VBvNelmdKFmvwyT7W6odWbTFIWnNApTGAaD8I71oCHOFpjoiyz1Y6X81E5evOTCKQjRq0pcRsH5VRa8uog/K/0h5J9Mi4Pb/HePE5nmvz6Klu6mzIIxUi70wlP51TtKos/61tCtAvcfkDkG54NxDuiD3N9E5iHJB8dG/n7LXT0ml2p5rpCOgq1/Ykn7F0bFnLBv5WjV5r6B33ksY+sG8eHjzmSyOpK9mN6Ydx/XWkke0lGSV
 BF2BMQUB
 KqT8Oy2tiVhBtyM8jDYELHhDBy2AolxyamQtKSSKesH2OXYwdO3PHQpMySamLKJxMB6z+JS1VSSd47zAFTUC38pYAXGCqGsKXnTC1Nec3gR6fjkxo0hqUiyFAoicyTheBtTj3my1YGPo5FODBvWI0fLY8GVtPGGDT06YvttnOZfQBvUX4M0eYSqTMUFNeSgaKvvElwdMQzgWOEEpFNp9t4uKbkZm13JffqdxxsnSCz1CnKjQt9InlCnvyaBeQFJhHHf5yqTtDt8HpHtTE8LlXxHzUbl5RS/FDd77WB+Hygdoq845z6KXT+tpYdPahGUoaQ3IuUmMLHIEPDXHcXd+3FUiHAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  4 Jan 2026 20:26:52 +0800 wujing <realwujing@qq.com> wrote:

> Introduce a mechanism to dynamically increase vm.min_free_kbytes when
> critical atomic allocations (GFP_ATOMIC, order-0) fail. This prevents
> recurring network packet drops or other atomic failures by proactively
> reserving more memory.

Seems like a good idea, however it's very likely that the networking
people have looked into this rather a lot.  Can I suggest that you
engage with them?  netdev@vger.kernel.org.

> The adjustment doubles min_free_kbytes upon upon failure (exponential backoff),
> capped at 1% of total RAM.

But no attempt to reduce it again after the load spike has gone away.

> Observed failure logs:
> [38535641.026406] node 0: slabs: 941, objs: 54656, free: 0
> [38535641.037711] node 1: slabs: 349, objs: 22096, free: 272
> [38535641.049025] node 1: slabs: 349, objs: 22096, free: 272
>
> ...
>
> +static void boost_min_free_kbytes_workfn(struct work_struct *work);
> +static DECLARE_WORK(boost_min_free_kbytes_work, boost_min_free_kbytes_workfn);
> +
>  void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
>  {
>  	struct va_format vaf;
> @@ -4947,6 +4951,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  		goto retry;
>  	}
>  fail:
> +	/* Auto-tuning: trigger boost if atomic allocation fails */
> +	if ((gfp_mask & GFP_ATOMIC) && order == 0)
> +		schedule_work(&boost_min_free_kbytes_work);
> +

Probably this should be selectable and tunable via a kernel boot
parameter or a procfs tunable.  But I suggest you not do that work
until having discussed the approach with the networking developers.

>  	warn_alloc(gfp_mask, ac->nodemask,
>  			"page allocation failure: order:%u", order);
>  got_pg:


