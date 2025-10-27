Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDAD2CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 11:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D29E8003A; Mon, 27 Oct 2025 07:43:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA0B8000A; Mon, 27 Oct 2025 07:43:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8278003A; Mon, 27 Oct 2025 07:43:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5CB8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:43:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4F0612A780
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:43:10 +0000 (UTC)
X-FDA: 84043708140.03.C0F1D39
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by imf14.hostedemail.com (Postfix) with ESMTP id D25F910000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:43:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=uKEGJJ+S;
	spf=pass (imf14.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761565389; a=rsa-sha256;
	cv=none;
	b=LtV56WShJ1V4LCzaPDqgBEf36yAyK6Mng7wc5tZhf16JYt2KV2/5FpZiHxnfrU4lKLontw
	t9liz8RNzhu6XhUrQFi/jnmuoufEpleycLn3Ism+AUguik/6BYH4NGelaGrB6p4JwgKmxb
	u6Q2LmL0EXpLU7S08IkdMdcsdrl+EEc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=uKEGJJ+S;
	spf=pass (imf14.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761565389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RecRvmbX2CX3+LmpDDLiI1hfGK+eJ1u7wjgl7nEoBL8=;
	b=FFmXJwTRe2OR68o2B7yb80nMkZep9TaVeEcNhyCoJIuXcZYkL/rT1ygzUDIlvkkikUhIXQ
	0XzZaFNH2ByMeMyxsn+GaEKOkY8brpzfdNw9VAuh0NAdpKAoSlycsMn2gBuNmtZD6OREmP
	VhA8NLldO0bhFLY4dWWGg4wyhRwZr00=
Received: from 8bytes.org (p549214ac.dip0.t-ipconnect.de [84.146.20.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id D04BC598D5;
	Mon, 27 Oct 2025 12:43:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1761565388;
	bh=QHB7ogBviW1sk+l+lwC23glCf9NdDmpFfN6Z4qzApQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uKEGJJ+S41J6K4x7ujgqrKO56V8Tg6vOhZ+scdGG+hkOKQ8V7EnAvOKfHeOWJIRtJ
	 HppkmxRZIR7H3bo/lA9JjEfz8Fe3VVWlcO3ocesdAItzupOIPSX8Cbitj4lnkhtK/N
	 VlicelCFx4F3oilFlsHZUSaGBdTa2cY6nk1KdHuWqH27xxYNIB3b/zn51NYXmzvwJn
	 xzhiX7VfL7vcfacK1KVuXVSd1WlURNVWbKz8RWWmB9RFkyPX8hsHtid0jNZvbuNcEC
	 oWt9yJrIZToTAuYdNHssW9VHpG12yr00lHPVzBgaPrApQ/0aOlc6Sru2368nDTuF+S
	 vKjzvcHY/dhJw==
Date: Mon, 27 Oct 2025 12:43:06 +0100
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	rppt@kernel.org
Subject: Re: [RFC PATCH 2/4] drivers/iommu: Add calls for iommu debug
Message-ID: <hu7ozrdn6la24apa4pco5nkhow2dmthahjomjj6hy4nrefx6j4@lcdfbykoafw4>
References: <20251003173229.1533640-1-smostafa@google.com>
 <20251003173229.1533640-3-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003173229.1533640-3-smostafa@google.com>
X-Rspam-User: 
X-Stat-Signature: gn4pfyaenddt4kfc96e1sacbjwt3w7t7
X-Rspamd-Queue-Id: D25F910000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1761565388-680604
X-HE-Meta: U2FsdGVkX19bxj5TnVbAG6zZS/AuPDOJMOrNMhNjEQuNU+3MsCnjUaadVRMIr6FAuRXlbB3MEbEdenE4Ec7jxd2VAOJxl4wGgiAJ9ddOb4U79IhkBreifKoClfRShcqbM8j6jC/c89Qx/cph3VdsTo5koWWQZrIDq6MVexP1UrhvdeyhRpkNLIcuaaTTG/Swu06HJCkgzszYQJP5aFgrpAZs2DAanWd0+bO7SpdUNolclHmsdWDg4x+S6aAnmX3ZC11v4ZLEV1ZOsnSQBUYGUX722NfGhNOTzR1le8wiXrPT3lhx6iSTDmoeFO00AVgmU+201V9nOIM4Ch6JyWgw+PJGBwKcNX8KkoW1F0IWp1Iw/+3C3/Ole0LElF4vZDC5KjvXeNJbxlYyxQxBAczJkUwd6Adqk9ppq/caFjWF2ncmuC77sjn+l6h8pXXx3dEyAuemcxrn6VOIZoeJHXreAWC96Uv0dGSWno8uj7lYzm+1kcs4SiojRN5y3nmpRs0JhUTlGg9VpqWLTUD35X+hhE1ptB17ekFjCmfWyFd+TsPkoYpKJRq5r4kX643Vh1pQ9axvRCiVeyl3m2vv9hUKKSvvnMVfzHsL9u6I1Wfw+v1lzedIiQjojRILJJ7mzonNH/hrB3IM+8ET0iPhDf6b4IVYhOPliAn5nWmn5R+QhV89Mf0Nw9Yr9SsK0b0T3SQmssLscF0fMGyZ/riSCsYCQi3670DCDDgbnvUsd6DhBhzwO8ppcOW89fDY8+VTT6hVUmWC7u5sS+CQj7Z/kyEl9nhs0jGyfRZZgjs0NsE5Lalshc/3bxTa0yy3sit/iW8826FdBiiFJEjBFdKuPv7R0ybC3tuOxofxxvPnW70lbTCTxpulph+r8XRTWpV+XwHj74HA/VwerCjxwEEk1iyju4BtCJZuLnewcp274qKbK24A6zrtK80Y1E1WuhAIKqlQCs/mX4oId689q608HW/
 Vf4sRaTL
 mwV4J4XYXlfrAUVvHaSrN+ZmScorEpcAuYvyg/dfmiWWzGAngoJHkuDAZW52kOYRaEe8ydOvLYQ9+351EB4e7diRFjLkPf+XTUr/F1MCxn3OKIQlmJ2Fow7vO6qnAo6NkvP35OW0Q7Ot0hUUWfiIydf997Um6h7bUKIexDEIGsOxbukieNrxNus8/9NKCx6/4MzVhTFwNJqDZ/mNdE6916E2025DydtFklvSp458Jhvn8bZNJq+tq+icjh5A8vpkELZY1m3Ne04Vj1bcih2zt4x7y1UQqKNALTqU5dFdhRJrhuGFCFYdYZgExzK7faOEKO71OV9BQZNM1pfO3fO89zJ0f7hXpq5EYJlFOSciChiG6tgo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 05:32:27PM +0000, Mostafa Saleh wrote:
> Add calls for the new iommu debug config IOMMU_DEBUG_PAGEALLOC:
> - iommu_debug_init: Enable the debug mode if configured by the user.
> - iommu_debug_map: Track iommu pages mapped, using physical address.
> - iommu_debug_unmap: Track iommu pages unmapped, using IO virtual
>   address.
> - iommu_debug_remap: Track iommu pages, already mapped using IOVA.
> 
> We have to do the unmap/remap as once pages are unmapped we lose the
> information of the physical address.
> This is racy, but the API is racy by construction as it uses refcounts
> and doesn't attempt to lock/synchronize with the IOMMU API as that will
> be costly, meaning that possibility of false negative exists.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/iommu/iommu-debug.c | 23 +++++++++++++++++++++++
>  drivers/iommu/iommu.c       | 21 +++++++++++++++++++--
>  include/linux/iommu-debug.h |  6 ++++++
>  3 files changed, 48 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/iommu-debug.c b/drivers/iommu/iommu-debug.c
> index 297a35137b38..607f1fcf2235 100644
> --- a/drivers/iommu/iommu-debug.c
> +++ b/drivers/iommu/iommu-debug.c
> @@ -5,11 +5,13 @@
>   * IOMMU API santaizers and debug
>   */
>  #include <linux/atomic.h>
> +#include <linux/iommu.h>
>  #include <linux/iommu-debug.h>
>  #include <linux/kernel.h>
>  #include <linux/page_ext.h>
>  
>  static bool needed;
> +static DEFINE_STATIC_KEY_FALSE(iommu_debug_initialized);
>  
>  struct iommu_debug_metadate {
>  	atomic_t ref;
> @@ -25,6 +27,27 @@ struct page_ext_operations page_iommu_debug_ops = {
>  	.need = need_iommu_debug,
>  };
>  
> +void iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
> +{
> +}
> +
> +void iommu_debug_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
> +{
> +}
> +
> +void iommu_debug_remap(struct iommu_domain *domain, unsigned long iova, size_t size)
> +{
> +}
> +
> +void iommu_debug_init(void)
> +{
> +	if (!needed)
> +		return;
> +
> +	pr_info("iommu: Debugging page allocations, expect overhead or disable iommu.debug_pagealloc");
> +	static_branch_enable(&iommu_debug_initialized);
> +}
> +
>  static int __init iommu_debug_pagealloc(char *str)
>  {
>  	return kstrtobool(str, &needed);
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 060ebe330ee1..56c89636a33c 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -18,6 +18,7 @@
>  #include <linux/errno.h>
>  #include <linux/host1x_context_bus.h>
>  #include <linux/iommu.h>
> +#include <linux/iommu-debug.h>
>  #include <linux/iommufd.h>
>  #include <linux/idr.h>
>  #include <linux/err.h>
> @@ -231,6 +232,9 @@ static int __init iommu_subsys_init(void)
>  	if (!nb)
>  		return -ENOMEM;
>  
> +#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> +	iommu_debug_init();
> +#endif
>  	for (int i = 0; i < ARRAY_SIZE(iommu_buses); i++) {
>  		nb[i].notifier_call = iommu_bus_notifier;
>  		bus_register_notifier(iommu_buses[i], &nb[i]);
> @@ -2518,10 +2522,14 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
>  	}
>  
>  	/* unroll mapping in case something went wrong */
> -	if (ret)
> +	if (ret) {
>  		iommu_unmap(domain, orig_iova, orig_size - size);
> -	else
> +	} else {
>  		trace_map(orig_iova, orig_paddr, orig_size);
> +#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> +		iommu_debug_map(domain, orig_paddr, orig_size);
> +#endif

These #ifdefs need to be in a header file, not the actual source code.


