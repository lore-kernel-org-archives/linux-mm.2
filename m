Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 510DCEE6B7D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 07:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B1A6B0089; Sat,  7 Feb 2026 02:45:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8636B0092; Sat,  7 Feb 2026 02:45:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62EB46B0093; Sat,  7 Feb 2026 02:45:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 521196B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 02:45:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DFDE358B8E
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 07:45:32 +0000 (UTC)
X-FDA: 84416875704.28.3799483
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 60EE5120002
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 07:45:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="tB4L/x2h";
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770450331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8uUq51zBluM1y1cwUf3cc5HgiUK7Y4/DPAVG8WYvT4=;
	b=HXPsQ6Z8vH8ffdTseqI3L5mnxpcCFQBwy3wkY0vEn2VZR1R1FJs0FUa0I85T/tYm5HVJgg
	H7nPx3IFzi1xrf3F3ZGDRJXmmtFsnwDPN+//ewbmA5aiE7Zc2f8XXDGUGW1WItHzs4wOlJ
	KDRdS7onsP+nEXq3U9pWq6uINFP7d2Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="tB4L/x2h";
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770450331; a=rsa-sha256;
	cv=none;
	b=YTOb35UckidId1UaqnGhx3aPN32zgWCcUruQQjPU0CH/BIvW4cq1Q9f7JROX5HuJcVnV7a
	j6xGeOkUcdpbL/gQvu/lQqN49lgZrQZ8/Td/HRz+OJ7Ta0F+7huAY5xR6zdkpyPjuWspVI
	JF7jHudFZQNgnWp+P2AYYHq5clAo0uA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 822A86001D;
	Sat,  7 Feb 2026 07:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE597C116D0;
	Sat,  7 Feb 2026 07:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770450330;
	bh=jKCIXT2VZx0+bTvy0DK1Nljzhsli0YPyMEbT2BwmVeg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tB4L/x2hGunhDsxnyPs0mnV1dmr0x+yJ+sTQFKaDmxZobI0YcYfjt1ubwcyDVEDhl
	 e1m5qh03hWnaRb4s9ctBtgcOaKYnBYOxWyFdO3i6TBqmA8f0xk0A9di191AbkgUOgL
	 cTkYNFF183xN/cesl8i3i5qPgqbq6nLhKoKzNc/V8q12g9nfT09b6GDId6T4rAEDAp
	 4I/24AzvnXnhpFo0DT+UEJH51c1c28dFmW9FBlud875qTjANt2VNoULWNR+Gjjj4gE
	 1ChL25YuzQRnJ4t87hV1gmq6opSNxxB3LHcyi8LN2PuvDUThUqj35WoT+wG3pNmwUg
	 BX4lbhLuYNBwg==
Date: Sat, 7 Feb 2026 09:45:22 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v4 1/4] mm: Add address apis for ptdescs
Message-ID: <aYbtkpls3VEVUhh3@kernel.org>
References: <20260205013527.322157-1-vishal.moola@gmail.com>
 <20260205013527.322157-2-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205013527.322157-2-vishal.moola@gmail.com>
X-Stat-Signature: ot3mkisdyr3r9awdhu8ouzsoy5trqs4w
X-Rspamd-Queue-Id: 60EE5120002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770450331-636451
X-HE-Meta: U2FsdGVkX1+PRVoh+dDdhbuuYlNmuPFv6oqGaRICtgH+s2s1qkdhOkOXYMcrxqZt9xNU3RD4vzkWjGLKjVLiCEBCZ8GCFkcsH/uknppf+2R09ioyW7ExYSeevE/M5fEnQ47aPvTeGzPln8qp3Se6T741ADfXkK3ejtwnmbF4E2V+Fb8SJb7H+UIA+u4aTUEB8oQGCP8qAjEzdxchM8mPCzB/tVhHSnVz9t/O7Jvdr2DHA+IXUvjjHflUnbiBVANXmz6gziYIJCwYfQiBRgRJ/H/AJaAE/f7mAqDL6Mod8yRNtHOM7Va7rE60dLMEadTiuLaEs6jmq64NmVu1bhrukXdP99Nyit5jMrrypMfAGbJUcNvNsIYNR6Q3FxKIaSOUjXTQAMlaHa1P/LbtveE9LJsriqT11gozP8wbMwLWlj8ocVSwuXATntNJKBhgdB6NOktrpXtLVq2I9/WTgF09kj+rIrE+nBFU0UhrvQ3C0dx5Yf516rIuMXT6eZ6dox1LEqtAza3Ol0tyFzBXAWEKTJj6jCNwhEznHBJ7te2WQciFf1lorSMy3n6xtv5vmmlOQvexfEIwmcO/HuZONnUSGQVIjrlB3EUbVm84pZMGc74qx3IQgr+r3JvikYFQpoCe9duvFalMZfN6OeCOR/EIyXxcjJzKGcoBFW8A5RZidGaKfKed1PW3vkepADztkArAk2jvSK1/eHJMmfIPFsumg5UBPtCmNwBv69gxWD4DfIE2KVmsyIX+ocM6NSQaL9KTaz9tfJV6dM6HLujrLBK1mwOyQj15JxbBAOspa6GS362ReBqIh0M/zGAZXFtSx5VT3dSHN0s71o8BNJZkgbmAXO4ePqem8swufr1mMlz93oJkLOCtmFhmsbcalnEjH2smE0NbAuBcKultyfvGpXx4USSUejlxgzuISWZwcUBC/pFyYbenGNB8d6/2jFmpfVD8hWEUU98qDjz2NPvMYXi
 CCkkLgjS
 y5Enqrqpz8I1StJrtxUxGkbWkA+CigfJycrVyHphlihkkC3cCr8MviTUPJY0HeYmI4kTWW/qnqPHG+Dcbk2ItchyaTRqSFjdHC9ROStdzUYWITPnZ3B7h6Mz4GswZSVmNCMuD7T2OYfGbOBOe9Qg0tHZ7tw9ftYGdBb6ZNRW3+8hip2j4FXK53I+oCVQl5sJQ7VcivkXFmYbsQeehwaZKhwCTn1vPvIEDKoz/RHPhRp6jXWgOH/Y1ft6WVFf2qCDyKK5ymXh2Uvi065QC60KL+adk4LblM8iDdjOsJlqishYAdAuJcxyPcAi/AL1UnNIlL+jgTgFxMKhkyig9aamFCfsY+u+/y1DoeqaZyIjIb2HnlsoqPRsLFzGmJPBsfhKadDCoK03TfZvL81YX4ylW/hvUVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vishal,

On Wed, Feb 04, 2026 at 05:35:24PM -0800, Vishal Moola (Oracle) wrote:
> Architectures frequently only care about the address associated with a
> page table. The current ptdesc api forced callers to acquire a ptdesc to
> use them. Add more apis to abstract ptdescs away from architectures that
> don't need the descriptor.
> 
> This patch adds pgtable_alloc() and pgtable_free() to operate on the
> underlying addresses associated with page table descriptors, similar to
> get_free_pages() and free_pages(). The allocations will be zeroed since
> theres no reason to want a page table with stale data.
> 
> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  include/linux/mm.h |  4 ++++
>  mm/memory.c        | 34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f8a8fd47399c..3f3000567823 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3419,6 +3419,10 @@ static inline void __pagetable_free(struct ptdesc *pt)
>  	__free_pages(page, compound_order(page));
>  }
>  
> +unsigned long pgtable_alloc_addr_noprof(gfp_t gfp, unsigned int order);

Why not void *?
I don't think it should follow ancient get_zeroed_page() and force all
callers to do the casting when they are expecting a pointer anyway.

> +#define pgtable_alloc_addr(...)     alloc_hooks(pgtable_alloc_addr_noprof(__VA_ARGS__))
> +void pgtable_free_addr(const void *addr);

-- 
Sincerely yours,
Mike.

