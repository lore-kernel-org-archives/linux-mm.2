Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16C49C55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 15:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01AB36B0088; Thu, 30 Jul 2026 11:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D866B008A; Thu, 30 Jul 2026 11:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFCBF6B008C; Thu, 30 Jul 2026 11:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3B626B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:28:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DDAA11A0192
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:28:41 +0000 (UTC)
X-FDA: 85045825242.08.1AD676B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 20A2014000C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:28:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vy31z78X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785425320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7aGN8weU+L7DqgVQRgWHsE0n2+CyhRki/zqPigzBOM0=;
	b=Kcn8I3MTmgJmctJIZLuXqWuMU2QjQ7NzEyTXEpLie3tFSLzRw/i4L/axgE/lnWyK+lzi7Q
	IM5C9TPblWCygDvAjs7FG/LKvM0D4xzUjNrTheiJV1g0y39OfAY/AsZeBLh3gjL1U+9g1x
	Rc/TwFbObC8O71GcohBW+wlmYFgr50s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vy31z78X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785425320;
	b=IA6OqnhBQ9JqMLVXWaRQsd6KFeoScFbrzvZqTDYH6vI7TQK+9vr1zDHA2BerS7xexvQ+ku
	m+Z78q8e3NoZ1kDJLXZhNd7eXCJB4cjrsJuHXPqrC6eGDCyd0L+wIOEO6NUN/OAYr67fsk
	Yw7ccPK4LH4UoWh5EwUzgv5Td1dfmoM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A72460204;
	Thu, 30 Jul 2026 15:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F78E1F000E9;
	Thu, 30 Jul 2026 15:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785425319;
	bh=7aGN8weU+L7DqgVQRgWHsE0n2+CyhRki/zqPigzBOM0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Vy31z78XoTEU+GQPKvefB1jK45bLSI4i9veb1bxkb8p5FDQ0FA66fGUfxdhXJfPcP
	 QtF3yyxjOVLk+IuSUe+8Iq0eG64ukv8xNHFbR5VXMX1yqpzmq3/yGgO7VIWA0wWgNO
	 SEHdkzCwruqPIUjuK2GgcejNyk8AgfKHO3Jur7vdQkgx2KC+OTwHDY1IUyk+McSdsg
	 MXuJ3sQ4+SV59X5e5bTdKQiVm9xwDw+1NGqT64Jfzh9J6plHtOxuChwnBr/g+rQvOZ
	 5xyKNubRoXOkkyX9qIzct3zJj8MIq2o2Orv9RBBAr9SVTkPkopjM/v5uqvpC8fsoNa
	 6jy97VPG+zwxw==
Message-ID: <3105745c-f547-481c-a329-9b78ff4de0f8@kernel.org>
Date: Thu, 30 Jul 2026 17:28:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: only update lowmem_reserve_ratio on sysctl
 write
Content-Language: en-US
To: Jianlin Shi <shijianlin11@foxmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 20A2014000C
X-Rspam-User: 
X-Stat-Signature: 9zsxrw3ndssjhyj9hc3u1ndwgawd1fbi
X-HE-Tag: 1785425319-216694
X-HE-Meta: U2FsdGVkX19HINcCNVaOsCdHe9a3QyTaxiVYkSJQQLqROOq0uJKUpAQu8wqwFNHARb6/o0QNQEJqqGNl1+OISR2pGx0Y30WJWADMeJ3JrABRSdbXYlHPgs5le68op7UWWhd179AiyQDDcYwQjeADpSyqJiadh2hIlImgIDnLd/WpQaLf9gRtK82+Q7vJ7cOPJ3yVYx1DP0xq9dQTnVZsTti9Gz3bGmbRTvfgxCP3WK/zKet0B3s51TKPPqMwx21c9LLIiMVsvmowy7cezaqVzVetexD9BGw0cUEdfiX1/90chf9Txn03ePIfdhjimsXksd8PAuZP5rML8Lg//XqgIp8hvk+G9OIa5FxVfR+D71IZyggAOz2CkXrm/xAIRwR8BHP1uBcmwdGSg8x4DVPU+kfnOhGDQBxcqAQ1TrSIrrLlNp3P3LcR26iuVp3qjwnKLxaZUH4BhdShPaThIZ4ay9AFYciEVz08H/7kkbSJ/ncaQnozE3WiazJPcNzTMxyIO+ukOgew3x85+weMUAsPTxWt/7FGFwnfFW69E1gLudYg6wCZo7ya/3KocKi6ebfN/VMqObYln1Fggn+W1asaoKVoKTMl2cytSdab0Eq6X2ryNF7PPvvrXkRN8DfEteK1i7wSqT0eADvy7/bEgGs+vBc5vpfSSPpvL+f62DePorWmMLkoTC+APF1gt7cXXgglWvfNa1x6VbV/GJiQegySHbtADmiVusMrkLgC4KDfRFENBTNNv2mxMpfTLka4BZjByG/9IRfzQ2tZzP3O8tEe7/SMTLFKATXoHRh7xLmf1n2b5arv7MmJV6gcKuupElz+9zKCVmoZXzB/qrtCTGk4z0kDfwoYCOx25Ab0rOeqyV5xxufFsI3nB5hD0bgxfFaoazwSjWuAT/RPGgJTxFUq9XEG9ofvBfSYURkTPMO97Sa3SbIcZTn6X2Evg41jnVQ8aTZ0izf6xfWlVz27WMf
 r9xcbOf4
 Vv+ygfH474dLzwtFcUdRxXC+k7FFO3GsPIqcVV/c2BNq+rRAgyH8fisnPa8sVkfcsO71/5EokBJxTzM3i5qosehLl4D6ioBi23I+J1iY9qPlsLk4lsD1pe0Gs8pN23UFl46qV5hMy7dgeWO0gpcbifOm1vBLAf9MlkwXkft1kSv5Xv5g5qWN/22j4jQP/xrd0TOdm57KWo9pAfVVfRCgdcKCHcQ5fY6gE5IzNnR/vI7hD/bWNx9f6P/r3ArwBmkSolCCibNd6AcuBOvM9ZKt2S+I/VhzeU2M0Nzkgb2wfhVRUJMPIfkrNX/NAB1Ws3I9ZuIwZL4/qt+j9D2uYPKqpmk7u8k93ntE5OJ156gHXIOY2l+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 12:32, Jianlin Shi wrote:
> lowmem_reserve_ratio_sysctl_handler() ignores the return value of
> proc_dointvec_minmax() and always sanitizes sysctl_lowmem_reserve_ratio
> and calls setup_per_zone_lowmem_reserve(), even for read operations.
> 
> Reading /proc/sys/vm/lowmem_reserve_ratio should not recompute per-zone
> lowmem_reserve[] and totalreserve_pages.  Only do so when the sysctl is
> written, matching min_free_kbytes and watermark_scale_factor handlers.
> 
> Also propagate errors from proc_dointvec_minmax() instead of ignoring
> them.
> 
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
> 
> Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
> ---
>  mm/page_alloc.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0387d2afd..ce33579ca 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6683,16 +6683,21 @@ static int sysctl_min_slab_ratio_sysctl_handler(const struct ctl_table *table, i
>  static int lowmem_reserve_ratio_sysctl_handler(const struct ctl_table *table,
>  		int write, void *buffer, size_t *length, loff_t *ppos)
>  {
> -	int i;
> +	int i, rc;
>  
> -	proc_dointvec_minmax(table, write, buffer, length, ppos);
> +	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
> +	if (rc)
> +		return rc;
>  
> -	for (i = 0; i < MAX_NR_ZONES; i++) {
> -		if (sysctl_lowmem_reserve_ratio[i] < 1)
> -			sysctl_lowmem_reserve_ratio[i] = 0;
> +	if (write) {
> +		for (i = 0; i < MAX_NR_ZONES; i++) {
> +			if (sysctl_lowmem_reserve_ratio[i] < 1)
> +				sysctl_lowmem_reserve_ratio[i] = 0;
> +		}

Could we also get rid of this adjustment with proc_dointvec_minmax's
handling of tbl->extra1 set to SYSCTL_ZERO?

> +
> +		setup_per_zone_lowmem_reserve();
>  	}
>  
> -	setup_per_zone_lowmem_reserve();
>  	return 0;
>  }
>  


