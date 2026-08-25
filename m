Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 129D9C61DBC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 16:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085056B008C; Tue, 25 Aug 2026 12:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02EC26B0092; Tue, 25 Aug 2026 12:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE0E6B0095; Tue, 25 Aug 2026 12:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB8AE6B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:44:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 552711A0100
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:44:24 +0000 (UTC)
X-FDA: 85140364848.21.FDC44EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C7FAF4000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:44:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lc5N3dWn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787676262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HhDnYJp6idU/zB/vpIZI1eo8XyX+VQJ6y+dK4kTg7es=;
	b=E15kwHg0teJcxPB8Qh4yRKC1bThRJLfzlP9GtEb0wVThmdq9T9loi9awCBX6hD5rcbb38e
	pSSC5IpdxZvo1SDgdasgvXYzaV/7wDM4c2B1Bv7iIVEnrR6l7euc6I+K1MNZmeWP45HYWI
	QJcYj+InTycuQxKQtgjZd34s4WssSg8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lc5N3dWn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787676262;
	b=oDYAt2KezqDglOqJPApqRPHo4Gndp0gXmQXSQhY9+FyzsK18jHTRQdpNO9j9SqgJx/SbN2
	No0yfgvYppYOFrXhbhsCFGDhGofdSKe45rhUlw35UMSOr2Grt9RPQiZAQ4qAP5U33p3xxy
	0qlZnzvoBN9doPsOHFs2EpccyxkSVIk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4234D60133;
	Tue, 25 Aug 2026 16:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216351F000E9;
	Tue, 25 Aug 2026 16:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787676261;
	bh=HhDnYJp6idU/zB/vpIZI1eo8XyX+VQJ6y+dK4kTg7es=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lc5N3dWni19ze5u+0uMkDDn2EcJBmW8KejCOvedJ1G3bvff6VjTKA++o4r2/zX4ah
	 pdXF7g5OKNCO26VzY76H8NWtdQ+AhxPhl2LKUn7KlfKzUOKR8d9/y0AhriYtro1GJA
	 1FhdvugucOPlDv6fTQ81FCQEQ3Q4ip4voc3N/T5lqkX8NhMXpmx2wtHePEjKcuhtRS
	 IW5CRx8ruYhDfNNkjRwTgkZVpIp3X0B22RVLoKfGV7lhe+RMqRl1zSTniq2G1cZ5Dp
	 j10p3MT+bnpNHHTLgz+knj6X6hsg14ZRrFXprL7IFZdoUAyfYpcjlOmugdUrxGN9nk
	 NncWc4mFC4qHw==
Date: Tue, 25 Aug 2026 17:44:14 +0100
From: Will Deacon <will@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
	ljs@kernel.org, usama.arif@linux.dev, catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rppt@kernel.org,
	ryan.roberts@arm.com, ziy@nvidia.com, baohua@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v6 2/3] arm64/mm: add set_direct_map_ro_noflush()
Message-ID: <ao3GXvT2ltf89_rG@willie-the-truck>
References: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
 <20260730090647.2401252-3-xueyuan.chen21@gmail.com>
 <c81ff923-800c-4ef4-b6e4-ec9f5eb1671f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c81ff923-800c-4ef4-b6e4-ec9f5eb1671f@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C7FAF4000A
X-Stat-Signature: fakwfkfwkgyow85s7e5gpamskfwrhzcd
X-Rspam-User: 
X-HE-Tag: 1787676262-279307
X-HE-Meta: U2FsdGVkX19YttYiolIG/+RHug94LnMRRuibNOlGBCFscfUSAH6bXlu9E3aVFZhY0a1SH9XhwH1xgkPY4J6li3e6es+rli9APYxbAeyjtH5mhx6tFz7h1l2X0vZ2jP9NPvxUdP4mhBGLLxe4p8NrdS5eQwCTDkNHgS6A2yCCkj4wGHenFg/pKkxfegFdnhH04KP16wUYZLvTcEP0M+5viizTRSquTwubfHqjWFz0iDDoODnsCf7lkyw5IQfU3L/8+Ro7j6wccEHbcBXYEtGeLYGCMrFtdoBbaN4as+e8GwTJr8LeFgfgAEvnAw4xdB04v0/qk1F+ck8iv9jJJTVknjHEvsdhKTL5cbTZVGNirxvQlr6HX++EsbSCXW4Fgw9b0QqRhAl2yo8bC42OzB8AVEVPZTq3hXrzSAP1zmAEYrUdY8mXHZpWkBjN002tQ+dTGYp2IDlNj0boPPO9YIwM0w5AdCmleE52cyBGg+6Me3XX4lLmi1+X0oeb8z2fxNc+ukjzgQbGxoi7gGZEyJXMM0uRzN3LMOYxb1yTV4Z/07w+pHsafs/nf03+96DTHg2OBQWzrYrMyeB6OUIUpM3DE20CWzLGvhdc+gdcohslsO3rzcGn1FjCwvhhDA/f/hcpW0c/1ro65LQOmrbe0/VQx+tj+39k36JNs1DGXNqCGJsmKxx2RKKx0RVkZce/ApObxn4qAXMua/0RmuSjX7+yGilM55K5WkeXa8PyZU8ZilozTMoraE2AmqV8R1Ux0SwxVoMUJ2puGk4ZcK2wRRAVUrAGWA59dd1WjSKw+wyMFso/xh8blpiy28qR6MNSKm1HIeMMcZgGI+hf5lMAF0hEzNQ+4CYXnJlyOOIIUttBj0Cqc6PMzl2daNup6SHuM9Y3SdT3dEF1GLoxGVvC0VymI6D3zLll/jx5/4MjIXxp0ThQDc0NKvEkCXGEQ7JZ9dGRua2Wak1nWAil+XiXW+m
 CWKmQtt4
 YpkQugM4hH4rHBDlRHR1j3QJjt8d19vKfkdHi0QnJQeDhCitowkrnIXiJPxfLv9mleorVM+lZk79fIGNnGTxVORUVcMslFWcnKrST4U7b2vs6HL/AGzRG9ngt+BTRj0eKWklt0Q2d3f13Je7Rn94lufNJqiGn0p6+af6Zrb24/bUazvk1rkfe9Zm4bKfTg09D8H4p6HeBldS94I9oy+mFJAKvmbd/MBUoLwyont7lNnxzq24nVOvf91Ucd+vCrKQpsW+3AmTwdbrZxTCOf1MN1AA6cCEtnVfhPfm4nwWNXNoYCiFOQPzEYzCAEk8kxvfvRh7NQJnyHL/khZWDSIDR81YfZvEst+qrlZeuCSSikbVW8J42YEML53slFbSjYVHwI0jujyFRhtUkpJFXGx4IhizFhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 05:52:20PM +0200, David Hildenbrand (Arm) wrote:
> On 7/30/26 11:06, Xueyuan Chen wrote:
> > Implement set_direct_map_ro_noflush() for arm64 with update_range_prot() on
> > the linear map, setting PTE_RDONLY and clearing PTE_WRITE. Keep the
> > existing can_set_direct_map() guard and leave TLB invalidation to the
> > caller.
> > 
> > Co-developed-by: Lance Yang <lance.yang@linux.dev>
> > Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > ---
> >  arch/arm64/include/asm/set_memory.h |  2 ++
> >  arch/arm64/mm/pageattr.c            | 10 ++++++++++
> >  2 files changed, 12 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
> > index 90f61b17275e..7083260303c3 100644
> > --- a/arch/arm64/include/asm/set_memory.h
> > +++ b/arch/arm64/include/asm/set_memory.h
> > @@ -14,6 +14,8 @@ int set_memory_valid(unsigned long addr, int numpages, int enable);
> >  int set_direct_map_invalid_noflush(struct page *page);
> >  int set_direct_map_default_noflush(struct page *page);
> >  int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
> > +int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages);
> > +#define set_direct_map_ro_noflush set_direct_map_ro_noflush
> >  bool kernel_page_present(struct page *page);
> >  
> >  int set_memory_encrypted(unsigned long addr, int numpages);
> > diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> > index ce035e1b4eaf..c51236b61651 100644
> > --- a/arch/arm64/mm/pageattr.c
> > +++ b/arch/arm64/mm/pageattr.c
> > @@ -365,6 +365,16 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
> >  	return set_memory_valid(addr, nr, valid);
> >  }
> >  
> > +int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages)
> > +{
> > +	if (!can_set_direct_map())
> > +		return 0;
> > +
> > +	return update_range_prot((unsigned long)addr, PAGE_SIZE * nr_pages,
> > +				 __pgprot(PTE_RDONLY),
> > +				 __pgprot(PTE_WRITE));
> > +}
> > +
> >  #ifdef CONFIG_DEBUG_PAGEALLOC
> >  /*
> >   * This is - apart from the return value - doing the same
> 
> We'll need an ACK from arm64 maintaines. To me this looks good.

I generally dislike deferring critical things like TLB invalidation to
the caller, so it would be good to see an example of a caller that really
needs that. The caller in patch 1 unconditionally  calls
flush_tlb_kernel_range() immediately after calling
set_direct_map_ro_noflush().

In fact, that means we have a pointless invalidation if
!can_set_direct_map(). See exhibit A :)

Will

