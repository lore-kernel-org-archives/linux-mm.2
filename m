Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC06FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABF6B6B0088; Tue, 14 Jul 2026 05:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A978F6B009F; Tue, 14 Jul 2026 05:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AD796B00A0; Tue, 14 Jul 2026 05:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 743536B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:35:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFC21C02EB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:35:54 +0000 (UTC)
X-FDA: 84986875428.21.759B6B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5D906A000E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:35:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJVkrEWm;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784021753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfnergjAnRDuo3uYbSqLR2MsPNG6su0Cxt59mBpdmTM=;
	b=VJjHdotMuX3lwkKYYreZVlPurJpW9YRRtYlIsZNtz+Z/bJrCth5g/nBCmIjmAHdCYVxLE2
	gsmiP81IyOHLM+/w5rT/Yprz6Rvyclh0XUaD33FrEciSF2yDReDPs8PB2ZcKs35saRl4LL
	v4y/La3d8N6MiaW0dI7XVkHLwq4lMOg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJVkrEWm;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784021753;
	b=F3dyhpnqk6RYQIGdp/tfmWDgUDBepkAry/SCziNW/7E7zPu85GEkbBLedDdbJSHobJQP/9
	Kj7MrFC2xTPjY7pUZga9/+3TjbUPRlnMKlygsblVQXRFVVC6s7EeKY5Q1i+aMS1sAcKLXO
	b+zReUKNziQSa2ZrTntlL2mSCDcUyFg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6786C43683;
	Tue, 14 Jul 2026 09:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FBD1F000E9;
	Tue, 14 Jul 2026 09:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784021752;
	bh=UfnergjAnRDuo3uYbSqLR2MsPNG6su0Cxt59mBpdmTM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KJVkrEWmExl50s4hRp2xoNRfweUHQXFOAgBlRs6oo775P3o0VLXSLkfrzgNrtQQmo
	 oI3BEQeV9kivBQi9nW4Y2K6tQRvUwagl1yGAubQxpjvS1VWBuywzW3/mGBbITh2/+R
	 z37Om5e7uLXAWsZ61BxwGzFrBz08y5OQfMLqPoSF379dizDuxzPkeFUqag6EW33doD
	 ulkgdbeimMWqLsvdOZh3dVq1ZM/Z/oVkn2dLMihkG7XOl5MIWO/w2rIQhsp+Op2/Ah
	 /pfF/8OBz66RSD8tq76RiRnixipBpoZj27RWNE3CUM+Su2MPLSqS49rouf5tN5tbZt
	 UNkvSg87FW63g==
Date: Tue, 14 Jul 2026 10:35:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, 
	chengming.zhou@linux.dev, qi.zheng@linux.dev, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	wang.yaxin@zte.com.cn
Subject: Re: [PATCH v3 2/2] mm/mm_slot.h: add comments for
 mm_slot_lookup/insert
Message-ID: <alYC2N1HmOE3Wc5z@lucifer>
References: <202607140924549782dUh3YBPmy8g1NDMK2zIW@zte.com.cn>
 <20260714092815120Wv-CFDlLKtsTmda--97Qw@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714092815120Wv-CFDlLKtsTmda--97Qw@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5D906A000E
X-Stat-Signature: 3e95ik43fe9b5k54cmn9iz9eok5e3spp
X-HE-Tag: 1784021753-677455
X-HE-Meta: U2FsdGVkX18l9hW4EiyrIgLsgqb/o4QxB8dmw8UsSx62EfLCZ3hYCTfk2Vawo2a9r0yvPkg0poZysAHUViPCNLK+wOy8uAGWip+WYGJDZg6ZcuD1FvCDLs5W0SAWTVSibez5P7l2IgCICuHOZ5LaJDlRktfA3QijDbO6N2A8MD2Ax8Qv75ESVXlwAudGYWTSLyc5+r/+Dxw3mEe4WfQXUuPvSqxBWdlcrS+jhMC8xPciNA5eG4GKmv/JK9jPf405LNqJbd8Kmrc/bDt0FY0jRZ9bTr3FHgTWJzKa6puDHQ1+4oev9bxe8690qAqOZCgpAparZwzCOv2X6R7djwnkGVrgrnN72/t8n0XwRQYzJVfsTyscBo/9xM9HzZGxV0bxwPwTdA0jPsoucUN8JeEvwg5aOagwaArnLrWJbaxfTvgOVPEjbI3vSgS4F4OJtGn/6aTBOu33eOklErrqcDzTVY5p+q9/R5jfXZEKHFHfFIvlyWCTLGucyusym4mwFcw6o50Iyh1P/xwC1f0e2NzmadDZsGpqNfcwsDw8kkHp353/A+OOGeRaCWrJBi34iXb9+076g+mue4nXvcRdfU1TYhq+wuu/FXgH4JD0QSCrL9pJllnYXvpfD4BxSjabLCIoYhrFVGFjlZr1A1SlTBpRJxzJg+y4QGCKRz1Ov5arSXQ2wPJdcLMDazShAkkRHI4QEYciRWTHkYNhI2qEdGcfnGRxY1VNnPjfdEqvPgyv1Mi1OJyguhjlJ+A5yWz9F2WNIsXcwIhic/p1RswF6GlU3HzsiVmhYy5vCi+KjgVdxDjOiEwkCG9MAyzXSJcbseBOED7MRaqKHLekKgLwVBrrxjDPGsvt+hia3oSDMaT3G29VDKIuvngrC8ty51lUE5XiR/4KCPXPOBizWHvHXIL1rQyCJgC7KFWOOh9p3DmaDsZdzOGJm0PM24arvFnr4jN2bLXnuaFw1W24+SShXWr
 h9Rqq6fD
 k/+MmmabW3ezWem3gsTZcroiPFYnJK/ILRV0xjtP3COBaElsuzALPhAq8nDR4p0j6CBsetlNQz185gakUwQS9mqhmGpV0riv281eEs2qcSUqtFWg8w/UMkT3TamWcvMp5bQavZcm2xhr3FMw/gU+7vReQJQ6d5H7v34XeImsTZFAdq73HljJ8oWqxhWFz2vlvv1uUNY2piV/3YjUmvr9YfpdigT5fl7rNPPoxmP1yaozaEY06eZQ+KXJs9aa/zcF+FOYbxwd//kYU7C/gkkHEq0E78+iEIFf58lMvYfBZw7c6YBsakRxprZw818zGAv2NJ7oUQhjPKIZXP41YNwzv7+wlfgG6w5dh0DPJqLjB9KRy6koXnWTS9WFpoX/9i+FAvMqW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 09:28:15AM +0800, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
>
> mm_slot_lookup() and mm_slot_insert() are the only helpers in
> this header that are implemented as macros rather than static inline
> functions. This may look inconsistent without explanation.
>
> Explain they must be macros because hash_for_each_possible()
> needs the table as an array (for sizeof), not a pointer.
>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/mm_slot.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/mm/mm_slot.h b/mm/mm_slot.h
> index 5de3e91d86b4..9b09b68e5742 100644
> --- a/mm/mm_slot.h
> +++ b/mm/mm_slot.h
> @@ -33,6 +33,12 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
>  	kmem_cache_free(cache, objp);
>  }
>
> +/*
> + * Note: mm_slot_lookup and mm_slot_insert cannot be converted to static inline
> + * functions because the hash helpers (hash_for_each_possible and hash_add) rely
> + * on the actual array argument 'hashtable' for sizeof() instead of pointers.
> + */
> +
>  #define mm_slot_lookup(_hashtable, _mm) 				       \
>  ({									       \
>  	struct mm_slot *tmp_slot, *mm_slot = NULL;			       \
> --
> 2.25.1

