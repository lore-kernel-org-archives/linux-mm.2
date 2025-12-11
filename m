Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9966D43343
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 20:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371BC6B0005; Thu, 11 Dec 2025 15:47:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349006B0006; Thu, 11 Dec 2025 15:47:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286E76B0007; Thu, 11 Dec 2025 15:47:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1743E6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:47:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B5FCE1A031F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:47:13 +0000 (UTC)
X-FDA: 84208375146.09.1057659
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 13D3080002
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:47:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V7FoWhxi;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765486032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=auKbupQnUpV5VkJCX4Gz5Tmzm+KzZYQOOJAi2kceG0w=;
	b=irWZu7gvjrJY5cqLf7c8Ta6pwK0D3gVfFUKmQdQMScZIE1V/oJT0Kx56wWPCr0wKtLE/rr
	CHEHf8yqjRSNBUH+ECBjYKnF3RXeWaJZb1ftSaak1cKskki9PY6XWOeBFZhuKaG7D1o2Os
	EyJYzWcllTefZYfAT40cergvOhjogFU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V7FoWhxi;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765486032; a=rsa-sha256;
	cv=none;
	b=8MEwZ4bNKYrjwTzvV2ydrSkKQJVzz8hJtBwosUGb+TS+qbSaC/UKaxAN+eAFWinEbiw0SG
	YWa4ns88J8h10RYkKg/TQc9DeoJ88veC87+Apnn4fzEiJ4LOrqzmyM+wEt06vQlONC6bgH
	DF4radXIa0VLI4obJKvXb/E+txGA6C0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 46D2F60097;
	Thu, 11 Dec 2025 20:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD48C4CEF7;
	Thu, 11 Dec 2025 20:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765486031;
	bh=wTwDPoEwycYUHR2/lb93wR9R6ICIFyLXY2w59v6xDTc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=V7FoWhxi+UrKAjN/T/nhxCQ6n1Mzr9ekIZUjEpI1Y8V/uF+NSUggc0GrS65ueDi57
	 yWoZTAS89pwHbakWkBd99tzMVQ07RkCNZ/8eUBeOvvrX6vqGGpz98K0AWHamKocau2
	 1eF5kaQs3XN89KxcoslB3FkxRqTVp5C4hs1RoDBA=
Date: Thu, 11 Dec 2025 12:47:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
 lkp@intel.com, linux-kernel@vger.kernel.org, Uladzislau Rezki
 <urezki@gmail.com>, linux-mm@kvack.org
Subject: Re: [linus:master] [mm/vmalloc]  a061578043:
 BUG:spinlock_trylock_failure_on_UP_on_CPU
Message-Id: <20251211124710.f1a04ebb7d8b57abb2de6baa@linux-foundation.org>
In-Reply-To: <aToCq6XBybxAFopN@fedora>
References: <202512101320.e2f2dd6f-lkp@intel.com>
	<aToCq6XBybxAFopN@fedora>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 13D3080002
X-Stat-Signature: q6t96sf954wja8b414wh71oaki5xfn55
X-HE-Tag: 1765486031-917566
X-HE-Meta: U2FsdGVkX1/dJIDaQ2dixyRUHuKXPKLK4hlD3pCJE8wgnmQ/gntErnDK/BiONUtK/zccJeD2K2BqsY6w+ZZgqkDUnygbVQ4favAf4kE0Nzv4NeUgAuxKZrx03UMTrRVUvuM2hOZLrpq2VZPVy8eT5Xu0s/XZoK7B/yS9f9xQSosnJ2pqp3/Bc/OPbc5rbjoFBYPnY9dNWqP0fLhrHR2s9AhdZPzGQ1owWU389iAk4s/SHEKv5gANrLTChwEE209LdcLKpiNhqfbOtkZ6pYCOm81urKAFkseLsBBV/qauOOm2mnpn7JRpey23oD83MsTsRNg+1fS+nC2zlZWo8DuIYNIFNfp6AR4MwW/kztXzqEX3RzUv9fuNYiWKvVXg9VrwUKI8J5LFFIH+VU1j896OG9pAw24MQ8xt2g6rBAI7oGUpu/nuAJ8fX/T2oBxC2v088IwvdFqQH4WXnmVhbb6z3nQHEW2cH5icNUJ99MqsuiQEbX2pOZiQeJCg+TTF0LViU1nULdTQ6usnyYcrC5xrmBEjgjvLGWESocA2irOgOTHFSFA7ImGaBEfv2t+8tHCqRS1PoSE4vjgYS6nJB814TGo8PZ1RdFUNd96n0wotzOz9J7zyFh+L5MEuFvuD8RedYYeokySwfTOZHP4W97CKqqlOTX/wmPpYZY6vzGJwqugulJWqhUPzTbFihYNZIuv3MUg5YShWX4W7nRjomHhZNcuCe8vOzS8fZx9HYeHp2GEinJwEskQWrv2SGOvjR/1nspORQXxoblGrflMjhg9TRvzdz4PPdEzGh4yjK4KorigsyskkrikOc0dgAR5CyM/WX2mA0XKli+qnytKvHF673LhcFBBDGzi2PkLLUNDZMJNED2JnH/SAyH1oSY+q/tV55fEBsSKfcETRHMomtQISDvQd/ChGaPaEEJhXd35qN430sm1R7bhNVR9UAMXpB7OUU6q+suIS22VQbSN5j8Y
 F2aISurC
 HpeW6OOaH5WFoTesVepGezJjNBuI617+SaIT3VuzV0ioMBjaXfFMOMuixT8C4z4fJJ3o9w/rYnLWbCyqdd6SMCsAmwYfuycd/Hnk8CnWRaQx6SiHoOKy7mHnQuZVuhauJJaRlISqQTo5oZ/GFymZcbS34oUP0bSlpb8KmcMFMsipZdPTcDqlP0P/LQJENuycG1JwVENKSJrA7et1X7fLUB1PonNUOSsogsYmPK/oyjfRdRZFIBYsyQ7qzrp6DX0OtKBm45dqHk3mB1SdSWOQ/mBbN1y5D+X/qQ0hk3OwL8fimbfEdoHB2QV/wHk/GfiA6cpMVWlzGV52FTyx6bGY7a/Kr2dsYcoiyZmBpwO+pWEyUZ0/yEnRVinqsE8UO0/jGUVMw5z4lq/ZuRUk2qCmdKkr/MS3VV3CO+Nyvbyf1NbRZVaBmBOgs7DsJHovmFObQiXSp673trPGTKpwTC90Hz8SZaUJc4UUJHN9Cg3ZFlXb2JBRtXLOvYsNGUX846azCgMDF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Dec 2025 15:30:51 -0800 "Vishal Moola (Oracle)" <vishal.moola@gmail.com> wrote:

> > The kernel config and materials to reproduce are available at:
> > https://download.01.org/0day-ci/archive/20251210/202512101320.e2f2dd6f-lkp@intel.com
> > 
> 
> Hmmm. This looks like a race condition tied to reclaim. I'm assuming
> we fail to allocate a page and kick off kswapd. Then when we fall back
> to the bulk allocator which tries to remove a pcp page at the same time as
> kswapd tries to reclaim it. Maybe?
> 
> Does something like this fix it?

Concerned.  If pcp page removal is racing with kswapd reclaim then
that's a problem.  Altering a caller so it doesn't tickle this bug
doesn't fix the bug?

> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ecbac900c35f..0d1480723ddc 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3634,7 +3634,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	struct page *page;
>  	int i;
>  	unsigned int large_order = ilog2(nr_remaining);
> -	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
> +	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_RECLAIM;
>  
>  	large_order = min(max_attempt_order, large_order);

