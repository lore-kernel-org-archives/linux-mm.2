Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3576CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18606B008A; Wed, 13 May 2026 04:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC9CD6B008C; Wed, 13 May 2026 04:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDEE96B0092; Wed, 13 May 2026 04:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BD3566B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:30:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88EC71C0697
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:30:05 +0000 (UTC)
X-FDA: 84761723970.06.DCA09E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C2B8120005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:30:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HO+oY0Nd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778661003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vf96suFQXEXD9a3opxXVvFkf/BARBXVgqxdseIJzW9k=;
	b=vicLEJFzYTgH4r9ZhLtH+wqYGR8OJvsoZDEJFzd/u8jUEn/lik8QDWPzi2FGKcIU9UUZNw
	Zbbf/p7sj80eqWSq7r0Zi8USU9/W9QRFU2yiOolbPiDUNfn4voetRKY/tE5JGELWU5OBS0
	k25+j9OdR1Qk7CCPE7ZFHpoxGkQxwPI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778661003; a=rsa-sha256;
	cv=none;
	b=uoXyQsdca/3gPdiEmUCpduiT8f7AKHVQfwNvgxTDuG0/ItPFYbE19d38xKYWffWuL4+9vZ
	bms2rNlvjfm6tCXe8hFt8UsAeK3b35K4mFP9xOck6n2A756iGWKdWxisYoHfISdRWIdYaL
	HOJMAyeIKLHZ8OdCycjfgGGimMhphHY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HO+oY0Nd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E7B843E06;
	Wed, 13 May 2026 08:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0E4C2BCC6;
	Wed, 13 May 2026 08:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778661002;
	bh=ZLaj6u3xCKR0/GZAQ0y6ABck1ESL0dcx2vChaLzZJY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HO+oY0NdOFVz+h7eHE/9LEv12adXbeAnP2ZzwsbhPOMLpmsuysp76rXaSbwEoZL4L
	 MkLN96NUUYoMbW03eInLeBbIKNo8oo9DpBzMo2tlwCEetIMxUxdBk5Qdyp/L4jlfEj
	 H8jWkt6I02G3VbRXauvYbcIrItP+m3HHf72TCU/IG7SrM5Jl4ZtI49zg/GaFvd2wvP
	 fvEmMwncOKALBUmcqhKw6iJFOj0ywjuDbKyylhVuILHn+GXQF56XuiBl+0tIKn7Uqe
	 AfCFABtT36jxPCYHKIvqJQxNUCCM4fphduLkt5+EYb64hjkhu/XR2k6yBvigrqqwx6
	 JOKHlZVyyb4eg==
Date: Wed, 13 May 2026 11:29:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/8] mm/bootmem_info: stop using PG_private
Message-ID: <agQ2fwPeMuEbnYeh@kernel.org>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-3-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-3-3fb0be6fc688@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C2B8120005
X-Stat-Signature: kbbp9bfqzph1fhh63g7w1g3n3bhwwft8
X-Rspam-User: 
X-HE-Tag: 1778661003-725070
X-HE-Meta: U2FsdGVkX18zh+Tjv/wyRG21goN5Km72BYFi1e0YePZyDAt+J7/fW36VNdxsli2F9ql00hTcaoI0hqIhC3JKxjKP9kRL/N4s7d0klEsO9lg+oBcUPlg9obp0DKDCXh+uVM4c7oFsQDkevJXQntjL6biqp4fmFGGw/tmDLiYl9d5dpufCXUZI2fQT8NMdWk6vtNEpMK0Qgre0/fE+b+SF1HWvASc1iBL+b0/+FvpodjzasBU5tDu+AoTzCH272bd/DkKVUN2SehCuqEF2XlzdKv/OMs2Z/FiCbQE8K9Uu8qPMcK1E0UFeZBBvDTdIaqIPtp08RYfV2brT08oBvVyv+8cSEVuERElGFSb+XF0rKFlm7Gr84FL27JGGliNEUDOko+kGvT2PtGUb7ZL+m08vCmygNhBUrWfkcOhehq9GKQO8/CIWW+vOUr2ejqU2oISKXIZq2R9XZ1wNbwTy+wga+7Gtk7LhcGLB1eNQDc2AUosLWTpJkx3YBtVuzROLCXnF+PqtRqD+xwIYDFOxmCLBbH6othnUOShQEUieSTr7HQEdIKt5nIRh53DLmkx03l7h1Cl5kIiuwlvQZeCp8SpUdjkjw1etjIu9nyTgqOPI1IihaKM/ng0wJvef+4SWwhnxzLCgwB71Y84Nvb5l3sxBGco0z26biiiXckP+4Xy9YIN7NUg5suY/dc1IVWjPEi577xDgRHoMDRrRizj6x6c4z1Y48Eo+ZQjUostOEM1/r3++Mf90bHxwgIqJApx2+i9FITOPW1rAmTboLuuGHpVAZOhz9kP+XzS/RqP4ssZjUt5GZwD0i/v9loAJXDvlnDdG2yHS7oipy30PHXdslbSqo6vFoD1BceaIlB9JLrw1m3+vcQlalOvX6neI2BIlXq0uGe3fjrIMEnmGORw3vxFBnFFQeW7XbtKF4o276e1EeJ4cHFPo7Iwv+bFje8uIYleKGVV8L8TDUvMXX5SXeke
 0CLC9lEh
 4+a25uCpmrCzXr+hugC4avRegIf7SET9yefFn6jtoCCVrcDdgzOZRCUHlKOBB62rprA4eJObxwtwupOIQtEsRwUMbt0O81YypMG+6NlxnmOxIJShG3dbN+lR3ItaK/SP+/JaHtgwbI9h/STiZ0+dzF1uxsmUGSYjPmga5+T8eHDDKbi4D0u22UjfMEWIsifQKAK4Icvud3w+lb+nEbsni+CJRYNmme1+tpLpQj5WnABBO7kM8Ck4zeLUjINApNpeIY0AYn+3aCvxmjcqzSQ3vIPUxn9jxyn2iUUXJNGIc4llNwuNwiaYrEJdowgYCO8ZWKaHbpY/dBzAtIGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:31PM +0200, David Hildenbrand (Arm) wrote:
> Nobody checks PG_private for these pages, and we can happily use
> set_page_private() without setting PG_private. So let's just stop
> setting/clearing PG_private.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/bootmem_info.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
> index a0a1ecdec8d0..6e2aaab3dca9 100644
> --- a/mm/bootmem_info.c
> +++ b/mm/bootmem_info.c
> @@ -19,7 +19,6 @@ void get_page_bootmem(unsigned long info, struct page *page,
>  {
>  	BUG_ON(type > 0xf);
>  	BUG_ON(info > (ULONG_MAX >> 4));
> -	SetPagePrivate(page);
>  	set_page_private(page, info << 4 | type);
>  	page_ref_inc(page);
>  }
> @@ -32,7 +31,6 @@ void put_page_bootmem(struct page *page)
>  	       type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE);
>  
>  	if (page_ref_dec_return(page) == 1) {
> -		ClearPagePrivate(page);
>  		set_page_private(page, 0);
>  		kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
>  		free_reserved_page(page);
> 
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

