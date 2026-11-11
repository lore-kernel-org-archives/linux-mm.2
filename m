Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807C3606A325
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=rMW2z906
Received: by kanga.kvack.org (Postfix)
	id A3D3E6B05B0; Tue, 10 Nov 2026 20:23:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ECF86B05B1; Tue, 10 Nov 2026 20:23:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DC256B05B2; Tue, 10 Nov 2026 20:23:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 645F36B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:23:51 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D7B51801D1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:23:50 +0000 (UTC)
X-FDA: 85421091420.03.4145C34
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2EEC31C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:23:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rMW2z906;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf18.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794360229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1lig7Anod9lgx4qxcaJK02qF6KZYVAP1p0ZWZvSXvA=;
	b=QYeYUyVkQDI31p7jONQgJbx/walYVWcKR7J1RwyLo0JaPHIVSDYEcXeLFXfrUy0CNCcuOk
	MHvAXzfbn2ujmCVjEpzhgbYTKoVAz+FU5ITjJoExR1eTJmKHH23A34FwgLfFWyKT6S6Eyd
	DSzKVzi3CB+JvoY0KxEnM/QciWkmSRg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rMW2z906;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf18.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794360229;
	b=7fXNfyFhizzdO62zBuwugXyFWNxSV+j5YrB0Z43ZL+eisYz1I+Kvdf3wTYzaq+nkzTkiZC
	PnP+hUbOdVmA74eVBGQnChuR5mXcTmZzj9vKPBhiD8+JGqBTfjZHl1Li71X54RyooXmleN
	RjBoFVx6sf5cje8Ud5HtmyyCZdr+ui4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=B1lig7Anod9lgx4qxcaJK02qF6KZYVAP1p0ZWZvSXvA=; b=rMW2z906/5ueth+PvqcM41FDxI
	rcVYiCU+KRHZllIijHjk+mirLP+V7kTCFKS/FUah33Uc/R6PNXhuYIvw5XkV0DpC6PcNVZR2CAWrU
	vqoBPa+61LPRg9bFMccEXxSWzVN0pagYSkEuRjHlFYQqy8g3exYlA6nsJDBG/MgAAjPobRgbg0doz
	zIPn1i9rYpn3eB77VgeMnxa14jiW2cAHPE02E61UfhYl1EZQ09pYKyqdzTAcSyiEy9KMAiSxgwLbF
	b26h0A9nCFL/j5Q9ubC/XyHiUe6KSCjxFl5CABbKmR0V+TtUsuI+iI9to8roP0+7SKJ7c5BWfsxPQ
	08siLNqg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xQx3z-00000005N3K-2qQI;
	Wed, 11 Nov 2026 01:23:47 +0000
Date: Tue, 10 Nov 2026 20:23:45 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: only assert mmap locks if CONFIG_DEBUG_VM or
 lockdep is set
Message-ID: <g2qikknwv37iierelgrbodhvvchef3z6nunhcti4dqvxwbob7y@easqjwlcj2ly>
References: <20261110-tame-vma-asserts-v1-0-be293ff499a7@kernel.org>
 <20261110-tame-vma-asserts-v1-1-be293ff499a7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-tame-vma-asserts-v1-1-be293ff499a7@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2EEC31C0005
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: jhdrrhi6rraycsckfxirf16zyozxryar
X-HE-Tag: 1794360229-657898
X-HE-Meta: U2FsdGVkX18RK0yGcdY5XgdhFJTx+yTufZdSp4Achi0d430ZxypWeiRTthQuLkgVOEp3IlSv5tIz+/SiKcyYyMgxq8Fd40/6OL+AMALe/jGtQ5K8ctGfhjVorZ1RfkUPh7wFftJO4qoyXgf/7NFLjKmzBRz87DdLxGbMD/bQqtx2gLL2U7xcbHQo/gahrNnCJZlE+JUUgMrT/o0MP2cm+StqLu+/+YCki9ny9BehlnTev0B+ijAQIf5QknEr+O5uwoNB8wMGrybRvZ9NfaMy8mlemJlfr70yJAL/WCxFkk2KMd8A5obh8qhw1kE8hT4JGP1BHxLzLPmquR7Azd7PTUJ+gTT3KfM+7ZuoAZpmHVHgNGDiLHYdaCWDNN0ab1QvDTvboOhKfWkSi+lklDn2CWo+VKBAyi/VkO/4CJ8vob6WQDm42k/M2AZgHpZyqeOeaxp3+rzBPg9Nj6icAyyJ0v1JVFiKmnBxNWF7JkZaFd/8AQNr+XoKd4NV+wHkYrlrxqDbuVcXc6UgfoA0Brjrbphh85/LjgI8WA9ZnGzUvIbKJWG5cI0gTWG9H2WAWidYvVDGXakNwD6zrYN+9U+hbDEJMtLKV8LNZiJqqOBEvm5TUFHCNr+IkhiQaa9KOhEcAIrM93Hcb6WhyR+9K3Fa/uUdfPAvxfmLJ5Cn0EKONFBH4ngmJic7E/v6Q9AdcTAsOqy/sqwWplARXrXBEnai3nQ3/GbnM76RgEQIAdkGVikstm6Y35ulNpx2/UE6XmQN71O0cJ2H2PYJLnysvsTE8vko8Vol7ZopPvUUUwwgrUezDStIUu3hLyw+qVrfw5nomUf/MyKtKe7t13ysLp4cnqBiGc41p4G1l+IPRandWD0+qDMalndxPOvuXRdFaYVfE5ZynqtiJGxxeSqmSeCvaDpnQzqpOm+mxdZnK8hXQm6eMtsYAdF8bbohcu2CJ8Lj728fjCecbwQCHZ8dw7a
 WbRVggVP
 Sl02rd0MXNP5qNb2gpdumqiTrc7QzWhlPMZHKYfQ0N6uCN70OQgrFoCtUi2CcCQmkOT4NS/RvDk1x9kKqzfAXYahUYMPRxDkJeqX7sk2L1LO8//FcowW2IuWyozSLTRLpRSx3RbTkpfYHfoav1H1EN+ZSTHLb13o/H+7peAEJTsUBCcnFo0fkkuuHSK/jz4QFAhDPsIC3qGXolrRnhKrcTSresV6HAsRFAyiI8BIzGRSROM15ETFMmzba6dRDSnv29m4kAD96pSF1GlMHtdnb/0Yw1cJ34YMYStSjaOvW+5xOXmu4yRPnoFvaxfHNMB2j5EnCiYW0/DXM3uTi20HJQfzqHq3gTr1S4Qyn/vPfNPCWfhVQ8jS8I0jLCW/ox0tKZMBo1ar5hz5nBwiLjvoRuleezk8mFWSJHBOU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/10 04:57PM, Lorenzo Stoakes (ARM) wrote:
> For a long while we have asserted the mmap lock being held regardless of
> whether or not the kernel is a debug build or not.
> 
> In general, given that these have been added as programmatic asserts that
> nobody did something stupid, production kernels are simply wasting their
> time checking for this.
> 
> It also means there is a two tier system - where some programmatic
> asserts (e.g. VM_WARN_ON_ONCE()-checked conditions) are only checked for if
> CONFIG_DEBUG_VM is enabled, whereas others are checked unconditionally.
> 
> If we genuinely want to unconditionally check for the mmap lock being held
> at runtime, then that should be made clear in the code doing it.
> 
> Regardless, if CONFIG_LOCKDEP is enabled, ensure that the lockdep
> assertions are performed.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>

> ---
>  include/linux/mmap_lock.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 9c3a9c6525c1..9367430ee53c 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -75,12 +75,14 @@ static inline void __mmap_lock_trace_released(struct mm_struct *mm, bool write)
>  
>  static inline void mmap_assert_locked(const struct mm_struct *mm)
>  {
> -	rwsem_assert_held(&mm->mmap_lock);
> +	if (IS_ENABLED(CONFIG_DEBUG_VM) || IS_ENABLED(CONFIG_LOCKDEP))
> +		rwsem_assert_held(&mm->mmap_lock);
>  }
>  
>  static inline void mmap_assert_write_locked(const struct mm_struct *mm)
>  {
> -	rwsem_assert_held_write(&mm->mmap_lock);
> +	if (IS_ENABLED(CONFIG_DEBUG_VM) || IS_ENABLED(CONFIG_LOCKDEP))
> +		rwsem_assert_held_write(&mm->mmap_lock);
>  }
>  
>  #ifdef CONFIG_LOCKDEP
> 
> -- 
> 2.56.0
> 


