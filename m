Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2020CA1015
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 11:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32F338E0018; Fri,  5 Sep 2025 07:14:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DE3D8E0006; Fri,  5 Sep 2025 07:14:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6808E0018; Fri,  5 Sep 2025 07:14:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 025FF8E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 07:14:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A58BB1A00E9
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:14:22 +0000 (UTC)
X-FDA: 83854937964.22.EED55E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id ABCCE1C0080
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:14:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ihMD5Uip;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757070845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/wt05ObpdxwaNVDkgazUTN9jzFwrbxwSbbI3oRgsSg=;
	b=C+FEu/NAlqKwBtsTiXr1hDbqnMRerDvTIfzIaFEQl8TTmNkEXY3wgyKAC0ypuKtAYYNTmS
	dJCdRnDUziIJR2aeoUPWfUX9bLtfO/IvspgDB9dejtmjTmmBPBSIQihTmmM5HMzk1DoXXJ
	YEsxDUs3QibHxasnx7dhaGSjPkJ+Zmo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757070845; a=rsa-sha256;
	cv=none;
	b=vqY3afThXpUYiG+sImYuspjZ3Y8SlqeRMlEQZxsD1uq7wcALNsErGzzEhJwsf/dDDjXpMT
	Vfq6evit5DjscKP7IXbxoyYRjykvy13f82F+ZqOrdGpAzbioVmFZQahLs0rqwlJpuBPZZr
	wCx39d+g24gbux4cJhmeTa35R6igExo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ihMD5Uip;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D8DF860280;
	Fri,  5 Sep 2025 11:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F34C4CEF1;
	Fri,  5 Sep 2025 11:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757070844;
	bh=kDpzhB/6Cz5cknkR7vg25nX23vQb619EzR6gJMWg0zE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ihMD5UipqP42+z3YN+MrXn99n6Ycd3YsueOx6CaMNo+hdxO5RgsqI0SQxPdExPL3V
	 BxsONFBqcXHbav7x1SkdqIDD48PmtLWsgPm58G0QlMiay/oaIVskT0KF8NuPaK9VFd
	 /7wzkSZr/Kf5WRucMN8/UCNMZojnjOtaAmAF95Bjf8RmpqIT1ej5HygOv9JaajJW8G
	 3sqfezMFb01ibM/+0hkAjFN8sRUuYHQxj5dBVnj+if/YJu29wWq859HwQBz6EYrcmA
	 3EU4AmTwTsfLSifdqQkLCIzFzeBG/3X8Ze/ePLiEQWW6Tfu9V10hDtY4xQjiB241cI
	 b5217/1pBB0Eg==
Date: Fri, 5 Sep 2025 14:13:50 +0300
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
Subject: Re: [PATCH 7/7] mm: update lazy_mmu documentation
Message-ID: <aLrF7qi85tmHfWRf@kernel.org>
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
 <20250904125736.3918646-8-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904125736.3918646-8-kevin.brodsky@arm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ABCCE1C0080
X-Stat-Signature: sy9heqgtt6rt3g9sswodm4oue8yc483r
X-Rspam-User: 
X-HE-Tag: 1757070845-403840
X-HE-Meta: U2FsdGVkX1/35yOx7IqkWnESRIMLhDYJj2C5oREhHaqa4MIOs+UBJZrqlaiYpHXxlJ0901FgDfXufsPwAzznlSe1JK1GTvPE256+MrhdJVqGdI+ZP6fji56PDK0IJPprRrRiH4rKc76qiSsvN7yqjTtANj41cxF+yqjnTROxC15IsVKfzYUIm4IfaFFI1mrIecG5bD0mQpSTU0wvQ3jRC/6xw0oseZcBEqrUnyECvN+aA1fo5HEEDgfzZGMw3eaixNofUCPMUxuonwQSp3kOEZ+UzV3GnH9KvoynNaiInKD0HLI3bXcypP09vj9XqoABksEuk1kOUxJQr3MFJMpSvykDQtNyDdFdNmyL06TvB4R289OM6dobHNegw9MYJ4ESeJu3m2XtLn/k1gHIWBJvM8onnhoNtIptk1Ym52QwLtNNtkK3mTSG1jg/DlHGLD0wPdTDkDHbT2CtzxWwuYExuY96gKN4EV+3WrN8NQA25DUY7FiPIqhOSgIn0mgEyoB/ftXNiFVUE6n04wC3ngS/j9lmnbqDmO3wRQr3Ljn3E7iO4b0MmM7TSB0d4FrKxkZhvW44RNQvKT4V0iYvk4M2nVhaLQXGiiBB6iyYp5vUwBIulunI/oLQHwFs69iTr7v7lYq8k9OwBX5KevLmAxqC6/CI63ZEYPu46ZyOWRPmJU4ZehVZckwJDYZdWJNu2CkigBTQaZ2NSGJqvsEu70C1uf/d4YElE+TXyy9M6JvsC7U647Zf7r4p+X403zJK+Tu7kMwkM+EejQRlBIRv/U2BMnJEN/Y6DV9HQQwE8YkPKQNZA0FtD/ynQ4K5E5X04CkDfz8+cQWeCCSM0mfuZLA+t+V7TNc5Sy13ASyxnJX4kXsNoLEi2WsQP/r1wg/9C52FmGO3yK+5CIp1CEKijfe0vR4/9GsgAZ6JWk1ctL6Z3Ik6piYC7j8H5+4SqvpYbkRs9PLKt11m7nLc62L7bzO
 2/qN+H2r
 n6OUWyCiJFPsFgKzDs8APL0Sv6KRWfjkISA7sAvn9326UBfqH/hVhoUJkk91eo4dyut6Eofq/iWIcBh0lMV8ystc2kBJ8R+22vx98w9wGv2jJDf9ecuBhTeN+hiSwWHs7HWeCox+xFfIcSZfrhaaBoaurrJ03e1zmZJna3zDy5qApTxKuJw0x8HChjUkS9m2lNMoPL5af9IKXyvYmgmeLsUqzY6M4oEY0Fq+fUYfcGkoxbGm699sjJCWD5J6DDtH0ZcSlEAP+U0pnBR2gVdsNrYDBXJJv738OLUQMNde1ixnddHJuJAxNjzQw5tkKl87LiY+oGaE5uFBtDcc6tesbl9qshKCOb1le4EAhbh8gzNQ02lNnlLKTwClxa3o+H+HW2fba6Y4sgcfVKgHTAcOIjK0FnYtJtPB+2JAa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 01:57:36PM +0100, Kevin Brodsky wrote:
> We now support nested lazy_mmu sections on all architectures
> implementing the API. Update the API comment accordingly.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/pgtable.h | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 6932c8e344ab..be0f059beb4d 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -228,8 +228,18 @@ static inline int pmd_dirty(pmd_t pmd)
>   * of the lazy mode. So the implementation must assume preemption may be enabled
>   * and cpu migration is possible; it must take steps to be robust against this.
>   * (In practice, for user PTE updates, the appropriate page table lock(s) are
> - * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
> - * and the mode cannot be used in interrupt context.
> + * held, but for kernel PTE updates, no lock is held). The mode cannot be used
> + * in interrupt context.
> + *
> + * Calls may be nested: an arch_{enter,leave}_lazy_mmu_mode() pair may be called
> + * while the lazy MMU mode has already been enabled. An implementation should
> + * handle this using the state returned by enter() and taken by the matching
> + * leave() call; the LAZY_MMU_{DEFAULT,NESTED} flags can be used to indicate
> + * whether this enter/leave pair is nested inside another or not. (It is up to
> + * the implementation to track whether the lazy MMU mode is enabled at any point
> + * in time.) The expectation is that leave() will flush any batched state
> + * unconditionally, but only leave the lazy MMU mode if the passed state is not
> + * LAZY_MMU_NESTED.
>   */
>  #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
>  typedef int lazy_mmu_state_t;
> -- 
> 2.47.0
> 

-- 
Sincerely yours,
Mike.

