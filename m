Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E28FC79F8C
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 19:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27BBE6B0088; Sun,  6 Sep 2026 15:39:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D516B008A; Sun,  6 Sep 2026 15:39:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11CC36B008C; Sun,  6 Sep 2026 15:39:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D028E6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 15:39:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F3B1805BD
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 19:39:13 +0000 (UTC)
X-FDA: 85184350986.16.E9FD82E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B36C120007
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 19:39:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQNoTprd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788723551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V0dlg/OCZ/KvufmAUs7+NibuZAe4qcL98ZBaXdAOiso=;
	b=y2EREaHTZJU1bXHNDwqLI+PaqnJ/VBZWJ+2NMP3EF7HskFk8TdO9t9OWVVFuFiJXOru0RM
	ho4/bWCRZ7Z0qnLQcCNtQIA/YbVo2DRf7hJ4VIEcaRZh4rOMu+o1VVc20/qVk4+NrWczBL
	EEN0cxMLKygtiYV3VHWnOor+YED3Ht4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQNoTprd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788723551;
	b=w5j/O5vGDFe2kkguHQl4sEReIPYM7z7+V0S2/HqlQ39kSasCb/bto2pjwDKirOtuWJ+kxN
	BejIEztswSPmoZ+gE81yZ0iU1Bmdx5dKozB7Z7gbi9DH4imOrriG78jh6yf7K1QO2h8FBx
	qoilwxt+Wx8x2USMhwuDF4O9rQWkDog=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25E51601F9;
	Sun,  6 Sep 2026 19:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625C61F00A3A;
	Sun,  6 Sep 2026 19:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788723550;
	bh=V0dlg/OCZ/KvufmAUs7+NibuZAe4qcL98ZBaXdAOiso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iQNoTprdzIABHeaY8m1+qIYrChSBW4YR5g56ND0IDGxjVrUjtu75iXcCInOb1364I
	 +wTB43doqgMJLnfBYJoSskumSgUkqMuUSGSIyoiPPsV5IWdYEYUL+GqtDQkjrs8b/w
	 R6nDfbG6LsyEfVITroBVaYZCYKvjcF1I8vSvuQf2oWbg1ZiodwnpaEcX1THbxmnSe+
	 IHQQ7ZglbTz7DzRXjtIv6JDrqgE4UHHd8b9zAX216R+bHlW31/yMX2GKkwGDEUCJoJ
	 YO213e8leFhpd/Q0nqRYPJDTLfgotLWQBIY2H1TusP0BQqbzqo8eIUTF+jNybiPMEk
	 M4oRLiEK08ijQ==
Date: Sun, 6 Sep 2026 22:39:02 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	sudeep.holla@kernel.org, jenswi@kernel.org, robh@kernel.org,
	mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org,
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 03/10] set_memory.h: Introduce
 can_set_direct_map_range()
Message-ID: <ap3BVr5hHwA499gu@kernel.org>
References: <20260902104712.2399797-1-vdonnefort@google.com>
 <20260902104712.2399797-4-vdonnefort@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902104712.2399797-4-vdonnefort@google.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: dorggcp7mqnetp6h5wfitqrekoip45d4
X-Rspamd-Queue-Id: B36C120007
X-HE-Tag: 1788723551-871627
X-HE-Meta: U2FsdGVkX1+6QV80mNptCFanYE8v+Wilcm0qas/5vecxOYJt6P+RjeskQbAKVxgSodkQC7AKGcFNGGuqQWboMeRbkp7keTP+WdMKKUeLBvPjdSmEIgSQYyTOIQVYmcvwxiNs2nbygxn0j6kxmcwf+DdWJdQyIB8fj7U5GHlbNPESuDajPxk8vai33RbYogDKd4kB6YkLnVuyyYUUyR7VnSS7eJ9SswvlFCOp9JuYBLxCKADj11lVKxb4hAdNkv3I5Sh/vsckdmt5WaQaAGGDiHL9KXt2efLGm9jyGOojDZUo34M5BSP5Iac0/231m9T487zBg2lWhlB7J7wKYF2Wv2Ji2URCEvSJzytkVamYNFle00YTQVkrwxRTelATQipUu96+58BrKEPVV9doBLyJrGF9UK+0y0+06pQ4c0IyUynfB65gO1G5ImRvHpIWFofwkdH3G1mNE093IC6deE6y8SNtcZEi3pazSG9cPlqpcT8iXLEXvz1OPYQVNvI+u+eCB0NUK0AcE0FaaPmAN76MZoQHG2fO/d1eC/jeF1vJtMDnK2bHiRH40tF6KZ68UZ349A3WsdFfiOP8Zqyg08VrYxsxhYSLTLuIFmfwCGEJvOhG1Mhjf7dRbFGIWQ4He6CW2dpW1vOprOchiysntiUqqhcTMkKut0Gt+FAs2VTv9MTNiJnpY1czjh/8DzaTjUgNKla55wTWJaoypSEOil8nPTM4U32EZ0eXX2Ko0gRnrZGnlepSnBfiX1YfgOqjRswfCjrGqlTSYGdptYexgGWTzMAjdpRLyn+JWFtUKyMJ/iALR6E5atcvQu+SI1xCKSkttv58KlFqtnB9qMR6NwOmqWI2wvpDBK1B8b/EKXma/SiOcggSnDk5g5YekIOwuLy9kKTOh42lm6izWt6oj8ZkBkYNpbaFv8Z/2NGM4ih+iz8x+cJMAlBOo0wZJ+deEMyje/N5DnOyvDqfDH8Q7u/
 nhmp4dNa
 Xm8r7WscXkjMsmMdw1xP6nO8sw23n+izIYkNZzAsiALKIedR5iVbSJOfo9dODfW2395+9HaoPkouXIQbEZV9RmVfE5leh5UETM+KIWKGTo5fdXLkSXT/IJ3U5ocsXEBLADRmOfvnNzhXu9M5EGH0Xy+1UWY+vVrK4q4r6/CuwWAO1Uamcfp+M0ERmTiXbldF7FJS7rNcH3ZFJEfEu68gxsVE8akT0DyPA32xpFkgvGCcgTRmHNj4zpck3B86e/QfwioPRKCuYg+YIRm0Awe09SkaNXer0ZmDuOoVVBX07ApPD4gx+cwNPSz/+HG5BOi1dy1bIw7G57TPTFESD7gVfWLTSZ9Zb87TrwbYi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 11:47:05AM +0100, Vincent Donnefort wrote:
> While can_set_direct_map() tells whether the direct map can be modified
> globally, can_set_direct_map_range() checks if a specific range can be
> modified. e.g. if mapped at PTE-level.

set_direct_map are going to have number of pages parameter soon:

https://lore.kernel.org/all/20260903-execmem-set-vm-perms-v0-2-v3-1-949b64a9f755@kernel.org

so this check can be a part of arm64::set_direct_map

I wouldn't expose can_set_direct_map_range() as a public API and rely on
the callers to "Do The Right Thing".
  
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 3030d9245f5a..88175c3fa751 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -44,6 +44,12 @@ static inline bool kernel_page_present(struct page *page)
>  {
>  	return true;
>  }
> +
> +static inline bool can_set_direct_map_range(struct page *page,
> +					    unsigned long nr_pages)
> +{
> +	return false;
> +}
>  #else /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>  /*
>   * Some architectures, e.g. ARM64 can disable direct map modifications at
> @@ -56,6 +62,14 @@ static inline bool can_set_direct_map(void)
>  }
>  #define can_set_direct_map can_set_direct_map
>  #endif
> +
> +#ifndef can_set_direct_map_range
> +static inline bool can_set_direct_map_range(struct page *page, unsigned long nr_pages)
> +{
> +	return can_set_direct_map();
> +}
> +#define can_set_direct_map_range can_set_direct_map_range
> +#endif
>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>  
>  #ifdef CONFIG_X86_64
> -- 
> 2.55.0.970.g62bdec98f9-goog
> 

-- 
Sincerely yours,
Mike.

