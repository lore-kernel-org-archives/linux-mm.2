Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07102CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 18:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F87A8E0012; Fri, 17 Oct 2025 14:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D0CD8E0006; Fri, 17 Oct 2025 14:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D308E0012; Fri, 17 Oct 2025 14:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E08108E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:06:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5938B118DE6
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 18:06:24 +0000 (UTC)
X-FDA: 84008385888.15.03944C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C740A10000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 18:06:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760724382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uZ7wmyeoCr/n+eEz+2rVPc9HZYTWQxyrTPZm5rRd0V8=;
	b=AYetPoX4C87ww3ARu/2s6jUaV0VRJ+V/7JOgSWcdUFsXrTjbRipHr4brhb9kbOMYmNqrEj
	J3MlUnu2bsu3o6oJaCR1H+YgcliSW1nQ8v1lxIt/5VKbBeTa8RX/THCYmttjMNjTUW5H+v
	IN3MRr2Z/t4okxjBXWr3lf6JD1sEZfc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760724382; a=rsa-sha256;
	cv=none;
	b=qPQ8+I/MvfAU6rBrPqCGtyZZr05EUTBLW+c+w1pI/QJIFNXHPi78NJ/7YDsD85WeUrP9um
	nhqJgnsHmK/6erCJ8p6ZzddK8aRWj8cUabYsSsAU/DeHsCsLPjNnXvgUlMj/6kFuTdoFKq
	wB6PwAbQdpB1/0Fp6TDaW5A9TJz000A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BCB2F6482E;
	Fri, 17 Oct 2025 18:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76468C4CEE7;
	Fri, 17 Oct 2025 18:06:19 +0000 (UTC)
Date: Fri, 17 Oct 2025 19:06:16 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Gavin Shan <gshan@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] arm64, mm: avoid always making PTE dirty in pte_mkwrite()
Message-ID: <aPKFmHg-FrkGJxWd@arm.com>
References: <20251015023712.46598-1-ying.huang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015023712.46598-1-ying.huang@linux.alibaba.com>
X-Rspamd-Queue-Id: C740A10000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: xohfuciumwbbbhg7iqzg6y99xzxzpfk1
X-HE-Tag: 1760724382-769738
X-HE-Meta: U2FsdGVkX19Z/5h0+/brZKsE6mGTYZNn+nbncuFQCJZwbr4rZ7VT2YFlRdpSFl24y0uihiBKD2NENWPv4nnzltqRZPeDgh8lMzXd7VuFmdoYvivac8ieYSoHw0s+VvtrvMCgDFtUFudNyXB7u1qVBpwNP89+mEvDuarWBGbOq6xeoiMMRM4R8luOuAWM4fd9ALuRWyPh1vKagfbempybAAgoHsbP7xwvdCLuKRnJ/oLb+xq8dGeJXNsiggtg8MARNXFb9R6osIimNhMPvpltK9VOoIR1betnyTwBZtk8iqNAaWAdtRylvpP/4MmfcasLsSt4tg84T3VN2y1IAAhPzLhjKs9tIbjn/1UuZxr/ktmN0dBLLCbo93WR2BnAnMD2LORCEr6UzCkmGI8qLZ4HrDWeLZTfAu9IroY75I2Ck0LlpmLhT6GVzlQnd/YUIS0SxJBM61uMUmdLhxJNYpbOCGgdh73qB4n7P4ORKCXo9VBE45XK3Nk03RC+HLYi+H5RSEeIrNugpHd/XohBeWjIsCbyBaXG+xSGxmjMAj3GNZcG4/Uq2S+c72fqe+OmT87PEqKb+s4KSQPbMnChVpWTre+wdhW+aarHgcBkGnBWKFn4gXuTU3yWdOoxKhNTXE2GefxDSP07AwgxRIAMkX63ibPyKRbIzU/ajH+Ux0apcDPNnAqlT2A2O6fsmG38m+J90q+BQms4eh0hNPCVLO//hqLJ6jl7nP9++Mu0mVn80Eak6nkdPj5BjgOwLrxd/oIfHbkiDIYbAJEp9ZlDtMYiQgzud+ZV4k2LgCT4U68MJ3ie97oBEaubNkOFJGFuaLeXbPGGY4vn9jHoUUm/+CIbUICnyspBaLtkI4ucHYxajnpCJStOJ8Q2K8C5jlIFGi44FYhP+Lrxzlpn32sShnvFE3Y08lj7s4reREIHXqC/ZrFcqJSH+5uBGD/VUyzKkLgJ5mhRoNcktgu73CwJkVF
 sj7IdZre
 UTbScx0C/L3Vc7KfPWYus5O7GVL8UX3lQlZtqWNi/kO5JIdCs9dA583FwNAHV64IlAWeXRh7+mGZ0DHIj26VWCozO8z+D0ADZ7vEXuBW8jfT1BCVXuZyH93mmUocYObOee4nYJE03zfRHqXvQD/aW2oq6j0v9mNxHDsk/zU+6E5ArXxSkoe3lanNNnU3WidvEVr8r8KUXzo/G81HUMK/ybicAxXCmeR0PMwKLc6K8ZjxjfSmcfU+QxNFOBP5YHEARYruN3ScsV45E/I1U+4KyKLuzWcUNRtfBHEHZZvTWncstM+ScYiBxi8yleso9R0fWHJWgKC1KlYNC/zdIDNIr6NRvN0APzaC8A3lcOihCGGUy7yYxGzr4+BQGjSUtgJOiMLHdzzdxJ8hJC3GcumZd73eQ+y3X+K2iqcytw3woO9q+3eWx2jqoNsHhjYaMs3Zbb0YTNqEDKPm3lAjH7FLIrWzCJk/h3sDIVptJ2JQ2q9+CngV5UZhPEtcDtFmNMMVHLE6TnjGFHl8EdaZEJT+jLnC7NZAL8+I61H4sgfIIM1aVi3REnIH/IsL9YnCivp5UTMGO3rLnL/xOcugbSzgW0kaBFMAPdHzU9NlIaXcNGw1BC0ZIV/Y073O11Rn+0cJVTQzl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 10:37:12AM +0800, Huang Ying wrote:
> Current pte_mkwrite_novma() makes PTE dirty unconditionally.  This may
> mark some pages that are never written dirty wrongly.  For example,
> do_swap_page() may map the exclusive pages with writable and clean PTEs
> if the VMA is writable and the page fault is for read access.
> However, current pte_mkwrite_novma() implementation always dirties the
> PTE.  This may cause unnecessary disk writing if the pages are
> never written before being reclaimed.
> 
> So, change pte_mkwrite_novma() to clear the PTE_RDONLY bit only if the
> PTE_DIRTY bit is set to make it possible to make the PTE writable and
> clean.
> 
> The current behavior was introduced in commit 73e86cb03cf2 ("arm64:
> Move PTE_RDONLY bit handling out of set_pte_at()").  Before that,
> pte_mkwrite() only sets the PTE_WRITE bit, while set_pte_at() only
> clears the PTE_RDONLY bit if both the PTE_WRITE and the PTE_DIRTY bits
> are set.
> 
> To test the performance impact of the patch, on an arm64 server
> machine, run 16 redis-server processes on socket 1 and 16
> memtier_benchmark processes on socket 0 with mostly get
> transactions (that is, redis-server will mostly read memory only).
> The memory footprint of redis-server is larger than the available
> memory, so swap out/in will be triggered.  Test results show that the
> patch can avoid most swapping out because the pages are mostly clean.
> And the benchmark throughput improves ~23.9% in the test.
> 
> Fixes: 73e86cb03cf2 ("arm64: Move PTE_RDONLY bit handling out of set_pte_at()")
> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Gavin Shan <gshan@redhat.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Yicong Yang <yangyicong@hisilicon.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm64/include/asm/pgtable.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index aa89c2e67ebc..0944e296dd4a 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -293,7 +293,8 @@ static inline pmd_t set_pmd_bit(pmd_t pmd, pgprot_t prot)
>  static inline pte_t pte_mkwrite_novma(pte_t pte)
>  {
>  	pte = set_pte_bit(pte, __pgprot(PTE_WRITE));
> -	pte = clear_pte_bit(pte, __pgprot(PTE_RDONLY));
> +	if (pte_sw_dirty(pte))
> +		pte = clear_pte_bit(pte, __pgprot(PTE_RDONLY));
>  	return pte;
>  }

This seems to be the right thing. I recall years ago I grep'ed
(obviously not hard enough) and most pte_mkwrite() places had a
pte_mkdirty(). But I missed do_swap_page() and possibly others.

For this patch:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

I wonder whether we should also add (as a separate patch):

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 830107b6dd08..df1c552ef11c 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -101,6 +101,7 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
 	WARN_ON(pte_dirty(pte_mkclean(pte_mkdirty(pte))));
 	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
 	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
+	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
 	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
 }

For completeness, also (and maybe other combinations):

	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));

I cc'ed linux-mm in case we missed anything. If nothing raised, I'll
queue it next week.

Thanks.

-- 
Catalin

