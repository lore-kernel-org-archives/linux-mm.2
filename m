Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01B73CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 15:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1DE36B0093; Mon,  5 Oct 2026 11:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4F86B0095; Mon,  5 Oct 2026 11:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0B2D6B0096; Mon,  5 Oct 2026 11:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B48D46B0093
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:31:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47B1F1C2766
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 15:31:40 +0000 (UTC)
X-FDA: 85288962360.06.380461E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4AD50120006
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 15:31:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=exVUm0cZ;
	spf=pass (imf29.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791214298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KptHfrcQ4aindQkNpO+syEz+BjMEx0loaikAdffFS7M=;
	b=P1nj1X6Ne9hg1Bj0CTFUQjxwijVEKha0fOc4WcLjc4Doov2uNhDCN4uZ/zMo7kl9WRooOL
	laBmwyKIk9qwEGlBQ6GThy7SDwTOmbawKLCzZTJe3SQ5WpeCRpM2W5qWe5aw4rdSQJm1PP
	zf5m6pom/9P6u6PSsWbQrmrYaZmW22k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791214298;
	b=amPQgKGsYlTo+7wBe/NmikSCJktG4Y6Wg9aeNoDGNddzWU49ght9dcyblW3/NqRxmS1tEb
	PV1kBatxkN/hFq+xu0Ohfc8M6zTL98/601dPn0WXVvq9eGnf7imuPNstSZg5FNGIrTKmcE
	jRXBcUbQi51QIdXSfDqr1OtwldKrDyE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=exVUm0cZ;
	spf=pass (imf29.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EDDB1152B;
	Mon,  5 Oct 2026 08:31:33 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B85EB3F66F;
	Mon,  5 Oct 2026 08:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791214297; bh=UfbkEj7jWC5+3mriZ290i7LpZ34xnOeNx98uhNGcwvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=exVUm0cZnHQnY5eDcThWwtVtsV8bnj/H4FIk9vMSC0M9uS6j/8ciV6Puh+y0NX116
	 oI/KBHXz6lA63AsMY4N4h+jtZA/cp2j9D7tDztXG8s4lHbkVXoN5n7cQWvthLajd+L
	 3/qGM3C3zhcyE1sjAcn3EEG/VTNV+Zr8YqR+3xUg=
Date: Mon, 5 Oct 2026 16:31:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH V3 1/4] arm64/mm: Use pmdp_get() for PMD accesses
Message-ID: <asPCv5Icdm7Z9mWF@arm.com>
References: <20260924062214.1635078-1-anshuman.khandual@arm.com>
 <20260924062214.1635078-2-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924062214.1635078-2-anshuman.khandual@arm.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4AD50120006
X-Rspam-User: 
X-Stat-Signature: 1nmpwwryrbnk8ujb6hdstxxbaqiz7o4d
X-HE-Tag: 1791214298-249534
X-HE-Meta: U2FsdGVkX1+3r8aIxfFHyr/nnsbiyqGAHHx1+J6/UjGb7rH19O3EEbexafMtdpg6LkCb4w7dH6mq/y3t1uZd1M1HghveFR+JnEmST/tUtFyNINeMVRlaVVbIQIvPD3H300t0E8mgJFQkXrqtJ/Z7A0CyRLE6/vZJDAtVOtZp8cNZNMlQd4fCYZUdywRsewuGNrRA+3FjPzCuspmiOcKCHoDtwNIOUE9M4CIVcgItBNHZ9Y+GVl4JqeQqZ/hSpmOg4iIA8x59h2iAM79GypMnnQy/QGXaWIBoPw09MZ+ZoEZgaCfETy/F2+Z7MqXoXqhMoKR5KMEvr6d63/UXx4cDzyoUJaggTl4Fw5CFlEJuEfy2J0gP5vRH9G/M6tQroeeScIeAAAQQj2Z7wzZoSvKGfQtweK64dP2afUx1er8m3hY/QEiWcg4Ndtndgfx2wNgFtV/2fTdOES+5G0Q5da3S78WPMYzn26ZkAWSyEy6s4zwFoeZFTU1MLq0QKGwFZfnjD59nNaPN9hgvmw9kjLkIUT4gVOFmOCK/2T4GK++svV7W+mwnR42eqjj00IaqeCm4SKzc0d49qhXqVNyQuQBIvm5Qb5QkVO41YY4YNhDja0Joa9D0ub65tnRhDGvokHlrbCEFbTNLD5gOSBDcbpB8uiXgOGNZEaH1kRFfiAAKVPH/D6gYS9omY6cbZhkgE6amQefxh0omqCgn7Wn3ayvirNlNN5VdPbGffRjIBA+X8jWfMq+vJRvZY9iutUPMo/lwPq7XiO1k3XtjGLr/4n0f6na/BR1WKNT/gLfs1ySiFXsm1RSpN9DHkAFkFRmJzonXobMjn5qMIHmKBuduvrZxlmJKW0KZZ1HB60b6C7GgKl14+24bwVxthsWiBTgFqiV1qHUfr976tKFv31zvJfCFIWC3FpmTz26VcIv6ocqGlAyaUpfdEt2iYdKT0dDXysMXx7dOQDp/h0eOv9tC6zb
 EseCPimV
 dnAok+FlEE016sVfh47qrs+QTfmJAo9Q2CwdgreLme8j5sSwK9Yy9RVsIbQgJcLo78O2fDCVi3uaMwQT6ZDMZkQLh3u5pJnx8/cI+9I3kYTGrkBMpXrP3gAk8hHOCCzqKNeba1Clb4LLWHk6pgnjZR14ev/b5BD55B/+GUhTnvZOc6NMEJfyL3ztnO9gSsw2i8sitJuq2kUlHh+D6uRMWKQB2+VQ0P9twX3s8mQeR3WS2Bg5z+5rX1IQ5Ut+eq1a+DiaVMBHQ41WcmwZEN9Q64uwyMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 11:52:11AM +0530, Anshuman Khandual wrote:
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 763c5a411d64..9ad2d03e86ad 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -84,6 +84,12 @@ static inline void arch_leave_lazy_mmu_mode(void)
>  	arch_flush_lazy_mmu_mode();
>  }
>  
> +#define pmdp_get pmdp_get
> +static inline pmd_t pmdp_get(pmd_t *pmdp)
> +{
> +	return READ_ONCE(*pmdp);
> +}

This is the same as the generic version. Does it need redefining?

> +
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
>  
> @@ -811,7 +817,8 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
>  }
>  
>  /* Find an entry in the third-level page table. */
> -#define pte_offset_phys(dir,addr)	(pmd_page_paddr(READ_ONCE(*(dir))) + pte_index(addr) * sizeof(pte_t))
> +#define pte_offset_phys(dir, addr)	(pmd_page_paddr(pmdp_get(dir)) + \
> +					 pte_index(addr) * sizeof(pte_t))

Why not make this change in the generic version?

-- 
Catalin

