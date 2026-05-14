Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C91BCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 10:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACBCE6B0088; Thu, 14 May 2026 06:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8C296B0092; Thu, 14 May 2026 06:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CA376B0093; Thu, 14 May 2026 06:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2436B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:28:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F84E1C0E50
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:28:33 +0000 (UTC)
X-FDA: 84765651306.19.4B92F11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 77D8B80002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:28:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hZIucBvP;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778754511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HlXOfhXSxTJ8so/ak5Tmb8Rz6S7rwJUhS2sgnnCZKMs=;
	b=DfXMSB2IL+Iu13UoYhHKkG1jftVfhhbP27cHBrcUYotHrJX3aqlRG274eUIHAkemAuKgWe
	YcUO0/0J2vK6cfQDfe6OMpLeB3LDqDCQdfKhFZgpUMUaqdNniP1qwopuu4ah4u6nqEBwjW
	3FtC3zmYEbJIeYgytkfeM39mU6vxIpQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hZIucBvP;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778754511; a=rsa-sha256;
	cv=none;
	b=QhczKYyNVZlePPA/pnI4re1y7f9nDU9UanwEjN4vPXa3ShkRjbTwKotgOe9sUoi8ZJR9W6
	XK6wc8BKFWac1ixOk6gwKjth6wWM89SH3lW9XFCzYVC41OISDvsGhlx6HG09gF2pvpelya
	2+NgqKW7FbGF6BpnxL2hyXTWg7TqpyU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 94BB144326;
	Thu, 14 May 2026 10:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25386C2BCB3;
	Thu, 14 May 2026 10:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778754510;
	bh=J2E1ngOfP+z/JoQMu6HZS2xqwSwuHFP51iCK7RA8Bck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hZIucBvPihuaorZZomcxWbYinrUzDR8G+xzUt/s26qidns7znx6wk7z2f6tdJgf8M
	 kzZhwU479eTizwiL4UJJwdTLFXWDICtQIZMgB+dJYHCKyNBqON1KnRSXscQ4x7rgcj
	 Fg8dNvCOwfmxO2XR0WmPJkFR2A9NjRUjkHv0f5d97ApQggoZLXtiZ2AyOXuL1/bnre
	 tvMLrHn9RUeZuCJ3czonObSsdyX4TYaeR5jKPmph04Qo0GWYKu8QjZnkRoNg/ub88d
	 TUCAeMzRqcbPXm5geIvCChiEj2gBlsCPoOEuMfCiWeXAKbNfUFNcPGQAx54r0d+7DF
	 I1d4ZErcxQX1Q==
Date: Thu, 14 May 2026 13:28:23 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Takahiro Itazuri <itazur@amazon.com>
Subject: Re: [PATCH] mm/mmu_notifier: Fix a begin vs. start typo in the
 invalidate range comment
Message-ID: <agWjx2pgoyoCAviB@kernel.org>
References: <20260513163546.1176742-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513163546.1176742-1-seanjc@google.com>
X-Stat-Signature: rd6czi9unq3jfqu8we51rhw19ag9sjym
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 77D8B80002
X-Rspam-User: 
X-HE-Tag: 1778754511-673021
X-HE-Meta: U2FsdGVkX18A1ZAqSXobrcen5kUnbGEoXUV6+km8piY6ls56hxD/mkqChzoV5CE8MOeEyC4tlAdUgl+IYDym4judzjJRjQgufZXdbzVwI7MGEosUVusxpKEMpNhmWJ7LIreGweDdgTYrKELJOOfFT4ObCGH3cKsN8TTnj89ZBNHZ+8GX/Hpw+T6oYMV16GApfldWln2sQZ8YZB8B7tGdVMz+QHyxnXL8DHGv9G2+Jd6ixH7/dEcEfQsiow7vMReLroMfyYGYUasNBriN756UNdNeQ/mj7Kl0IE1w7QNneUorTYW38Rx9Pm0qLthVVlyNAOLUR55v4I5bzxcO+wRUj0AZaYDPoSSwQScxnKPWZuHdipYs3Pu94ffQCGrEel8QPa4sFvHYfesUxmDJqmcCI0Oq5cGOIwHE1dw5/89YJYdfbR+88LHtY5oEM9Q5i+7I5t2p+5Muc6PJtRF1zaZOegzoEe2kDQgY0iJ2Vj7LsXlngTXbdWEkNogFdA8D29Rba7s6QD4z51q17wTfNhXHNawDfMK/L89va9lgiqaZEA/19XOVeWxwsJ3xGrLmyD34AiPOgsA98eJGC/8mlGFSI/l9x1iU4gutgWXF8RlrJ16wAUyej9Bux/NGaqMGJemyvPrmwSbw5t9CQ6MAQ/csfzcCxO3iy8qn39+sk5x9Rpy7t5ZQ9OLCykJJozRuYQ3y5lPsw4GJmILc/v8fisMCqEPfYGXf/hsmmVpn/nWKBBYYduDqg2Wd+4VKhKYaL3V9xjZ3NMfSbOj6lwtO8evSeAi/tbxa9bxCmNXvf8vjlXo6abvMsozLIpb/vuF3+hPZTrLYa7W8nF/aeTNaWh+EYLff+ew7vv//okRuHC+nWbMNu5i6yYrg3H9ksXc3lO/ZDU9vW+pmlY5uHis3KyeKQ9gGTXF2f2FpJAm6ImAk973MAnQO5prCLSjg2/Z8yYH8zPcGx2fP9s6DynByv99
 EaBPYWvD
 pj6jBeKm2tq2oC9tefcgb66EMgIdnrxx++h62Q0BBG1KMiYTIbNRkRlHcuX8hW7Wt38/iHhYvp9bCQR+P06ToKU3oWOSMNuR2QZi8MvPVypfVVxSIdXSjYBrFFc5isEHo7g47Zae782FKRKFkPVe9/nZI6nkcKhpipXkKm1xHoeJUNvm5ZFoKo74eCDDh4Z/MeFKFuBFDqtwDUy8Qecm0JbwlC/bii3vaGbNFiLVgTV7WgImfaLXhSYLsnRXxvkfCCqPV/Bi9brduLD+upYvw3HMRr7zH4b70MTyeaY4FshgQ9uCjcqqNwgkTn6OK3axv+fO/NJyG4qyxA25HB+/xnncl5MeAmFI29hlIpN0riOU9IT1gc+UHmAD8TA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:35:46AM -0700, Sean Christopherson wrote:
> From: Takahiro Itazuri <itazur@amazon.com>
> 
> Fix a goof in the block comment for invalidate_range_{start,end}() where
> start() is incorrectly referred to as begin().
> 
> No functional change intended.
> 
> Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
> [sean: split to separate patch, write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mmu_notifier.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index 69c304b467df..a11a44eef521 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -134,8 +134,8 @@ struct mmu_notifier_ops {
>  	 * Invalidation of multiple concurrent ranges may be
>  	 * optionally permitted by the driver. Either way the
>  	 * establishment of sptes is forbidden in the range passed to
> -	 * invalidate_range_begin/end for the whole duration of the
> -	 * invalidate_range_begin/end critical section.
> +	 * invalidate_range_start/end for the whole duration of the
> +	 * invalidate_range_start/end critical section.
>  	 *
>  	 * invalidate_range_start() is called when all pages in the
>  	 * range are still mapped and have at least a refcount of one.
> 
> base-commit: 5d6919055dec134de3c40167a490f33c74c12581
> -- 
> 2.54.0.563.g4f69b47b94-goog
> 

-- 
Sincerely yours,
Mike.

