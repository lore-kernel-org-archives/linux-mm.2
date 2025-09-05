Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8125BCA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 11:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1308E001A; Fri,  5 Sep 2025 07:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C618D8E0006; Fri,  5 Sep 2025 07:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50628E001A; Fri,  5 Sep 2025 07:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9CBFB8E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 07:20:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C4321A0123
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:20:05 +0000 (UTC)
X-FDA: 83854952370.29.2FE00B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3940E40100
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:19:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="A/QIh2dd";
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757071165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSe61z5BayeoSR86wiQVMBpcSVw9JUSiFDv132hHJEw=;
	b=vKYhzW3k+o4zLm+LksrOxdPojMcjZJzA5qu7cSA/e8e7Na9ssHHMFE3n8XqKobsK0OF67x
	vv9yGgXmUYQMb0KnwruKyPgVIY+KGCWlPa+ckqU3487W9K+aXEyS76s6HZh8FulkAC2mu6
	f+QsIGLxriY9HLPfZeULXg9hz1ZGmdM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757071165; a=rsa-sha256;
	cv=none;
	b=HcJtn8K4mhCawXlIOyfPnYDZEe/R1F2g59pjVJrjacWPCDI8RGbonYMmQHkyhYhV158KNT
	AySjNCtM2FY9+tPJGmh/80YPUANIU3s9ObSj97nOzQYQf/Ocjn0Mr94kT6bQA/srzXzqQ/
	XGEoyuooYVhx919woTJJOXfIGUX5DMo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="A/QIh2dd";
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 89B416027B;
	Fri,  5 Sep 2025 11:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C27C4CEF1;
	Fri,  5 Sep 2025 11:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757071164;
	bh=RHLqjtmoQ09sM+x+rrDllENxQeIkKdioDv+JW9P+Aos=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A/QIh2ddmPQW9GbhkGscvwZJAOdlvRvh05eTseLWqDi0NqX5VoUz3c+rFGi5te6gs
	 FeVf6cxesM0g4NssvOVujDWyj9mrdK8LpKlTGDp/6FZss2dq4STW6zOMrER9uue5m7
	 gYM0YJqrGGelTJTg/Wae0ezZ+Ln5Z9a7rQdsrtvsC5aJMkzJDUejnZeo9niA5S9ZsO
	 rAiiZhiID4hhFyLR0EPR+sXVy1LHpEREWSJ9XWSwcd0WYCKy66BICmsJmvPOks/99s
	 KUtvAv0iw5WXUoAptM66b1336WnWvdA8iRqYrawyqjKazn3DqpgdPmx5ld20pIZHkT
	 94jShf4NQqhcQ==
Date: Fri, 5 Sep 2025 14:19:11 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH 2/7] mm: introduce local state for lazy_mmu sections
Message-ID: <aLrHL-C_UXfUbCd9@kernel.org>
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
 <20250904125736.3918646-3-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904125736.3918646-3-kevin.brodsky@arm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3940E40100
X-Stat-Signature: 7sdw38wd66x3gzyot59spdhtnfbdojaa
X-Rspam-User: 
X-HE-Tag: 1757071165-595666
X-HE-Meta: U2FsdGVkX1+peyS9S/No+xil9Y4Vz9IxTSYrNF7dwSyaiujfrQw6s8gi8hQqNFrDpVPM611hxOfG1hHfztQNDSiIoztwff6Qz/PfGaYuQqqph8UhO2wny8JsbHDe6HtIBy3rtHIH4jQCiZNsGOf69Sj41PJfjLC/Hj1zmzwbcgAHevilt0/g7tSs7OswskkbrNmteU8YluzDVJDaaTtyu+GOK30THJcUnHU+ZTtFNthOmqpBCaWilkm0/HOfISu8CfhwYLBvi7b2xt0xn+QTAfjzdnFaBjMXfSjmREgzDKmR5x/tDCET5M5Wa9QMAIczBQzamEpo8AmBLXVCnzVLa4sZGwL4whTz7IoovjeXV5L09rjfY+ktpQk64ew0YMiJSXtBU74pc4W02aOSblAgSHhq7CBloyajp2TmrPln50l7O8f5usSkESKA3iASXWSBYB94p0i0azEha//AIAwubi/zWFfM5CPkNtjuDIFidms8Cl5XHhSi5sSNO0kmKgt9z6jZJSbwVKoEmSeWptmOZY0XbvZ97kpOmUMFUepbZlobIF8b3kSxEMBX3ZIPqf2GU2IyZvxx3EltE5UdiPofI8bA1Uc2MR6ACOr+dqSIsr0JfTDfHWiygdOTyFkH8BMNgB4SAY3yLrRntadpXJN+y6CQJ0a/DzLmdTSBLRZGpLwYGjEEpjjl97xeJE3SiWh5tba7bnz8aZ/Nbs+nibs8H18VFP/uIccYwfR/Vuf85PuX40asPK5LKaIMbFzk52PwnwpWDHlWW4kx4gVQCbWib+IVojlr8G6mLUjiuApcvvbekEqs3Z5trkbvSppsnmrxr29saKnwVzOodcii6u5xP5Vx6SSB3wB51zdovsVMQH77LW5DJeMImfucr0pGNC2S6fubKycQnMEt8AQgn+XS92ni6uy/s4sg7xQ3UabLM9DnjKEHDRSKZqMsk4cOfQdj+irwPgV79qoCiyLPOcq
 BxEhMS1x
 dZtuCfRj3ipxr71nbNDLgAGx79CsM8iTHEKiHjeTxZx91Lr5iBlaCHgCNiNvflxbyWggR2tcq0UtJkkxVgZYfPq3ap0Q8nhMqRCXZCEui+qgawYdTjDvRWfWVfWI9mCx5AbuZr+pI+yU0LBYu93P/Dz5Pw237+Nl1byoCnD0cN0sCcyLyXpJbKP6VEbdIH3Xkf+slxyugFU1U5i8b0a/y9YbpZnDLoWtQvV+AmghVgaS/DO+RZSs4zv4wEoDihFTu4bLZ+YeuVFeqT23qaxKXp49g2GZfUSm6zH/CEU0VvLXYyHKo+qOxgrAE2A05wJPd0qflfsoQp3yLBP4XVVVi/rbhz4C3bj4KqLz8Yf+Z2HNlEZekHxJa4RN79q4lAh0n+fUu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 01:57:31PM +0100, Kevin Brodsky wrote:
> arch_{enter,leave}_lazy_mmu_mode() currently have a stateless API
> (taking and returning no value). This is proving problematic in
> situations where leave() needs to restore some context back to its
> original state (before enter() was called). In particular, this
> makes it difficult to support the nesting of lazy_mmu sections -
> leave() does not know whether the matching enter() call occurred
> while lazy_mmu was already enabled, and whether to disable it or
> not.
> 
> This patch gives all architectures the chance to store local state
> while inside a lazy_mmu section by making enter() return some value,
> storing it in a local variable, and having leave() take that value.
> That value is typed lazy_mmu_state_t - each architecture defining
> __HAVE_ARCH_ENTER_LAZY_MMU_MODE is free to define it as it sees fit.
> For now we define it as int everywhere, which is sufficient to
> support nesting.
> 
> The diff is unfortunately rather large as all the API changes need
> to be done atomically. Main parts:
> 
> * Changing the prototypes of arch_{enter,leave}_lazy_mmu_mode()
>   in generic and arch code, and introducing lazy_mmu_state_t.
> 
> * Introducing LAZY_MMU_{DEFAULT,NESTED} for future support of
>   nesting. enter() always returns LAZY_MMU_DEFAULT for now.
>   (linux/mm_types.h is not the most natural location for defining
>   those constants, but there is no other obvious header that is
>   accessible where arch's implement the helpers.)
> 
> * Changing all lazy_mmu sections to introduce a lazy_mmu_state
>   local variable, having enter() set it and leave() take it. Most of
>   these changes were generated using the Coccinelle script below.
> 
> @@
> @@
> {
> + lazy_mmu_state_t lazy_mmu_state;
> ...
> - arch_enter_lazy_mmu_mode();
> + lazy_mmu_state = arch_enter_lazy_mmu_mode();
> ...
> - arch_leave_lazy_mmu_mode();
> + arch_leave_lazy_mmu_mode(lazy_mmu_state);
> ...
> }
> 
> Note: it is difficult to provide a default definition of
> lazy_mmu_state_t for architectures implementing lazy_mmu, because
> that definition would need to be available in
> arch/x86/include/asm/paravirt_types.h and adding a new generic
>  #include there is very tricky due to the existing header soup.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

