Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1BF5CCA471
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 06:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6E38E0008; Thu,  9 Oct 2025 02:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2FD88E0002; Thu,  9 Oct 2025 02:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF8F58E0008; Thu,  9 Oct 2025 02:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7E38E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:38:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 209D713C051
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:38:36 +0000 (UTC)
X-FDA: 83977622232.22.9F799C8
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3ED1140005
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:38:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=a9d11YKi;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759991914; a=rsa-sha256;
	cv=none;
	b=F13iQB84Wg6Bx2GGIk2IhkgTwKLUC/0mpImjCeFR5C6apU3cMZLceWWofPx/UijmyMVvZs
	RDahq8poeCa6ryHAAvZhigWhPSat2fIWY2xIwG9K6b2HaMbKwW32UH7sTRhWg52zVx2xJ3
	l3LmoR8KSNrrqCYDSsFfUWikagYVhT8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=a9d11YKi;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759991914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7uF0ypIDD4ce4JFBz4t/KnVpqhkIM1GtfoljNrd+fM=;
	b=luPS/5OTff9NtyFstEEn3wBOfBQmORRZMpnkn8qZHUCrA9sU8GDTf7/At7k/8ooycHP9N9
	998yzgmCwFJOo5ZFjt8yUwrXC2DOvAaHlC9BZ198bwR0U9IBC0V+OIeMKAZZS2y+fbaIt5
	uOMm2qaKi6F7Ci98mt/KWVTwer8cvto=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1759991909; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=A7uF0ypIDD4ce4JFBz4t/KnVpqhkIM1GtfoljNrd+fM=;
	b=a9d11YKiqRgbOM2CbBKQlQU38a2sjhXQpTvI3B0Cicu67A02ZqhhQlnc9Oy7IsZbkcuo5jmKmGeG/6O21izL+TK2E6zEfXq7E6uzA3xg7L9SMdCTPq0AVfjqxq+LVcYjQEUUPl/bBJDxqgcy6ndl7obWMl9+I1NhL+x6zDyVERg=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wpj7cTa_1759991908 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Oct 2025 14:38:28 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Yadong Qi <yadong.qi@linux.alibaba.com>
Cc: akpm@linux-foundation.org,  urezki@gmail.com,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmalloc: WARN_ON if mapping size is not
 PAGE_SIZE aligned
In-Reply-To: <20251009061410.820-1-yadong.qi@linux.alibaba.com> (Yadong Qi's
	message of "Thu, 9 Oct 2025 14:14:10 +0800")
References: <20251009061410.820-1-yadong.qi@linux.alibaba.com>
Date: Thu, 09 Oct 2025 14:38:27 +0800
Message-ID: <87zfa0tw9o.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: ze6e79kgf1pnk6aktixysrgp413hcyac
X-Rspamd-Queue-Id: 3ED1140005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759991912-831681
X-HE-Meta: U2FsdGVkX1/JsE01MXItzUOHief9sqHI/TeYsWi0Y2FDvqDa3K2dhqTPhGSpdavg/xmSYPfGRNmOgDvahGO24MqPhdVpcvrIUBQ/4R3cctLZculi6JBd/x6+W4Zdqo2gwSGWEolck9LXwgqZ7tgAixC2WF7FjXlG2VZwMx8GdbbmqQmyIG5oCDQN6oa2tFwWeJR0D6QoeZh583htebFKCrtk41WpLxJFa7c2u5driPzD8B+euB+YkIF8I7opVw+9sl5B1JKL60iTRbK67Jxv7h3oUNiEyCvUP20pnh4dVjQjscQxgWCyxDbLCp6hfyrpYxeHwsV9scLPSKWve1ytKexdD3vZzV2rcr2Xs5Ghwe+r79HHo+P3PwyNpkAUmnOyto7IU7VopVAghMRmaOmtZjFGlP3hn4xgvYObsAukuok2V6HN2G6veY4OaQy/2eC2YZjt1stqgCYh9v77dlFitY1DSlE6IurtnhJSY1wyw+E2MggJEzh+neKC3aNXpu4ZtQbmrceTF+xZEYHgs4EKBvrEhXW+0BHNgr+1m7NmjB7GF5ivl8+3SMmB/HWq6ud+5H6E104cLj0DWfsew0vuEJzR6PrN2SUcHTD6auQMpOw8NxpNIWLCj5lrbQfVVGZZq6cfarf4WN4hkbEQXtUnfbJxbuj81X3Ko43U4fHx5zVKLbQF0u0xGzBhdpEwLLySJz71FZsv1tTDjP3ShfnpXxVfu756Uox9h+KqaZxJ/qa3kcTJa5fI7cALumTQ7LYgVD9DqCZLZbm9DgaT5SQ+Bxb5cWV0D9eUkPLKcVLtpCtloYXUDeHW+jLMCi6vkbdstKmkFdp0YK4r33NpGHjMdg+kvxRqZIYyIGhD7wc2cUO3xLBVN0qxrw2Qq5NJxiCd14ObCj7jTrsgT0husOgYOE+ilgYcBvwwvrBLOrBMb35IzdB4ZlNyuli5watEy3PvGQodSsnHBnKB6ZXAloX
 eUIKJ3E6
 buLWfFIhMSeXb5xLuF81j+QaBMJKMuTY5UuqRz/+qblYRT+Oe9yRee4SMyWPqoPjS8VmZ2v9FLw0B1NXfwbAl9+iV3SBPmE69jRjwxVQD7H8gRw7uD85+enPkTAOd0K8yYilJOFOu1K/TafGYyGfKwyM6JyDyh5OqCq+yS1uvznxKY5vUPGoqjWom0RYy/5suwjNFmx3qf8oNMC+OhdFZirMdv+YzRHtTbpdNnlGAdC32B8RnT0YFs+XaAvwFUfLO0c+yBrXyVmGS51jxi6FCzpRS8T3lM1hx8I+rB2Z652T3Fz5LWwHC+UITczoaX1OWBLgEy5iDVTFkfFCOOJbQu7ms2gIX5MS+gldDMi+5Yu86TjSGMRVrch1NAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yadong Qi <yadong.qi@linux.alibaba.com> writes:

> In mm/vmalloc.c, the function vmap_pte_range() assumes that the
> mapping size is aligned to PAGE_SIZE. If this assumption is
> violated, the loop will become infinite because the termination
> condition (`addr != end`) will never be met. This can lead to
> overwriting other VA ranges and/or random pages physically follow
> the page table.
>
> It's the caller's responsibility to ensure that the mapping size
> is aligned to PAGE_SIZE. However, the memory corruption is hard
> to root cause. To identify the programming error in the caller
> easier, check whether the mapping size is PAGE_SIZE aligned with
> WARN_ON().
>
> Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
> Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> ---
> v1 -> v2:
>   * Use WARN_ON instead of BUG_ON
> ---
>  mm/vmalloc.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 5edd536ba9d2..2cad593e4677 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -100,6 +100,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	struct page *page;
>  	unsigned long size = PAGE_SIZE;
>  
> +	if (WARN_ON(!PAGE_ALIGNED(end - addr)))
> +		return -ENOMEM;
> +

EINVAL?

>  	pfn = phys_addr >> PAGE_SHIFT;
>  	pte = pte_alloc_kernel_track(pmd, addr, mask);
>  	if (!pte)

---
Best Regards,
Huang, Ying

