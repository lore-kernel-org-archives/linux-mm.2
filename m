Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF28C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 04:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57446B008A; Thu, 17 Sep 2026 00:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C07A46B008C; Thu, 17 Sep 2026 00:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24126B0095; Thu, 17 Sep 2026 00:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 893406B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:18:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E4CA71C1AB1
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:18:55 +0000 (UTC)
X-FDA: 85221948630.21.3914103
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id F1982180003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:18:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=obxnpRuD;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789618734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1raU+CaqI1GLp8zDPqWDq7KLcJI6Jq0QHu92NyCig0=;
	b=TrncFuFZO/MywXKrYX9gvCOtXdzSdEkSlzbEB9jv4m0i9als4sMFfTwcxN0UOCMwtWlgSV
	5Pgz87HWwOVLlcd2wfxbs1F2vwbZUVuAu1LzbsaBkNklBdWtNadQrgktyoOu3JWCEarKGL
	ZM7nv7HjGJ/rX/COTXlglZdBA1mKy+8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789618734;
	b=ZHn0Z9YTFfNjE6GY8unyl/RBU9T4ElWsKeYFB/eptgu3zdlktI70Yg9eztmKlC8fp311g2
	TnvSdSMi/dO+OxttmJ24MH0J1vaSZFk2mXMQKVokJRZJqxrWtKWXISiQZJJwnB0IZgwCB3
	UeqqGC3iHuy6ikFiPsMh3K1Jlsz2jDc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=obxnpRuD;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 685F61476;
	Wed, 16 Sep 2026 21:18:49 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B8FD3F882;
	Wed, 16 Sep 2026 21:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789618733; bh=qX2pKJSt+jbXVDMn1VIn5tjWN9rlhtAz20MEdFpS9BE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=obxnpRuDgn1BP2nOU1Vovtq9joyGzBs6NtdCxr476bPAgUJ6iu0l89qcfyFvS4bd9
	 8TKZ3sYcFvvmnBZpnmEwKRMjkMvnjgEyRSJAQ5ab7vP0JwXmReJbkqQFnPSGSqgj6Q
	 eZbJAQH7mV04PfWF029nyZb7q7W2JBXHLc9gNeNY=
Date: Thu, 17 Sep 2026 09:48:49 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 04/14] arm64/mm: Route all pgtable atomics to central
 helpers
Message-ID: <vuetqfctrtbm5e7ay7owffyqkoopeqaxlle37uu5byhf5oeu7k@aplgoj4fijip>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
 <20260907035030.2839978-5-anshuman.khandual@arm.com>
 <ef85271a-a1a3-4b9b-8c99-c1f871a13c6b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef85271a-a1a3-4b9b-8c99-c1f871a13c6b@kernel.org>
X-Stat-Signature: xpwc4swbnd4eh1nzfktrumfij15if3zz
X-Rspam-User: 
X-Rspamd-Queue-Id: F1982180003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789618733-754763
X-HE-Meta: U2FsdGVkX1+GRqy9oarAkVEkbUJJC3Teld7VMKlRfQGpmUSblg9WxsxlbrRwDmsavlEZ6hSecsBxlEzNFAp9cKiWsda3Q/MWGrcJsVPTEL1Iq1ZIwVuKgAZrNSIhwaVCwN+uhrHHCB1TO/uGD2t9ttksPN7yUmG9Fsi2/ryHhpvVGOvUOsO5KHFsuZi+jIq3dTpNQBipmBK+SO6d0i60dZGFbVcFOL6UDS5+96llLAcQAVtZsS9TyZplTUxksojHOzPhXWri9+b2BKKezt5kDah1UBtS0MhJei18GFYlQEiTD+6eLqFJKe/IaeCJ84notHgz228yVr/xQhCup9V/EG0DpSg3UfxPyY7ZC5WbtLJMZcs3uroti+UYwXhFptZOcgHmB+L47lT7VHZCSL01lIbbcheIb0M2luGEWcp4IjyM3s5l2l/T5bz0QbQt/UZMMJUuqTaGPCE2mLa6Rmdie17BCfJYfZKyitp7Gktvtp1AnssU3Oj4dZ3r3kUfwAyARAd7juNhXuYc48N8UTNmpI9DUS+WobVR9+FDJ9lXtX1XxpNF4d8Bq7wGFB+bkHB8+awm20gNYrLNyQ1WzWll61G8im/Os9G3BH0sW+Bdi//Q3/4dp/DcUTPnnzngbU00hT0J6ZUtdnVGRca4GnDFzi0jeoF06A+jox67/rpg21KW3mJh7WyJUBo8WRcIozcy1AMCCoiAa9nZK67UOFUTVU6TIVs8Sv8p4qpbFrDh03faTz9tAKzgjKeyn//pmajyCR5IAd1jZ4c0TZyXLslPshtP/PIhigcLW8pFR2fM60pYkFOD+wlYuMPa5F3vLg16JnZBENMYgVRVSKaBjDpzrVOzEH7LQE0c7odsy3bC9HeddvnrKQVuY5KVerZj1daB5oIrai45rVasVsCfy9HECKvVfB49BtOX7ysLvNQ6MSKM5psLop/brPMirb/xtm5rRwPkJVVwq2Y77bni+w7
 s1Yzm9WV
 M5wl/1o2gXndSiDyYEgXPZNrdFM3fCFCFptX8qoDwj2hPiZ7pKmyOMN1xlNb8dNuDNwMWGPmBf1Q7bgFRTZ9tmwvYlHutdhKXe9pCn3ZXpF6ZymxUbZYN2hy0m7Ab1eJ+oH3b9KY1YPYtTP9kkgLIEPNS0za9FFT2cqdMNXjuJQdQcJZfJyv/sbIJoXxDhmd8BPBvZcXNSl5rkEPkFmdSDhKaCUDqZRmxlQPiF16i1E7bnnx5sX0okgkISn0rE9+ql2aQyFnUIHMla/tAGQfe8io8S/YsrXjqJv0+gL/VYCfGj558qt7TBzVt7xFuPrig+1EQ9UhaBLIExQEnaLSoM9EQ0x2Q9++a1glPmmOjIzhPhHf/P23+cEEQ+VzX3bVxcMkw6OymKLcuwWB4zXY+b0KIiJ40QFQ3XfOS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 03:39:05PM +0200, David Hildenbrand (Arm) wrote:
> On 9/7/26 05:50, Anshuman Khandual wrote:
> > Route all cmpxchg() operations performed on various page table entries to a
> > new ptval_cmpxchg_relaxed() helper. Similarly route all xchg() operations
> > performed on page table entries to a new ptval_xchg_relaxed() helper.
> > 
> > Currently these helpers just forward to the same APIs that were previously
> > called direct, but in future we will change the routing for D128 which is
> > too long to use the standard APIs.
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> 
> [...]
> 
> >  	case PAGE_SIZE:
> > @@ -1400,7 +1411,7 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
> >  	do {
> >  		old_pte = pte;
> >  		pte = pte_wrprotect(pte);
> > -		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
> > +		pte_val(pte) = ptval_cmpxchg_relaxed(&pte_val(*ptep),
> >  					       pte_val(old_pte), pte_val(pte));
> 
> Indentation goes out of sync here.
> 
> >  	} while (pte_val(pte) != pte_val(old_pte));
> >  }
> > @@ -1438,7 +1449,7 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
> >  		if (flags & CYDP_CLEAR_DIRTY)
> >  			pte = pte_mkclean(pte);
> >  
> > -		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
> > +		pte_val(pte) = ptval_cmpxchg_relaxed(&pte_val(*ptep),
> >  					       pte_val(old_pte), pte_val(pte));
> 
> Same here

OK - will fix the alignment on both the above instances.

> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> -- 
> Cheers,
> 
> David

