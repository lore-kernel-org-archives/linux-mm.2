Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A3FDCA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 16:59:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E7A8E000B; Thu,  4 Sep 2025 12:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5264C8E0001; Thu,  4 Sep 2025 12:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4635B8E000B; Thu,  4 Sep 2025 12:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33DCB8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:59:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD9D21402E2
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:59:42 +0000 (UTC)
X-FDA: 83852179404.30.8BF631F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 11629160015
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:59:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf08.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757005181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dXdL69La8rlk4Cc+iX/4Org3UmBemAueG/dGwfzzzJs=;
	b=VqqyTQRAisLND6kpKUDa9iNREZdVBZEogyOBay76824qgLwJ43+5CBKF2PEDamQBSs4Iap
	OtwBtrdcqhfDLlAaDB1oL1wqyKJfqoFnhJUxrGHFB4dJlp+7xQuMdmgMDBRUXYfiuO+3t+
	Z9GIm+MPGrbmXaPL1A33DgpFjzbliGU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf08.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757005181; a=rsa-sha256;
	cv=none;
	b=XcpQX4sATkahlmXJKShBi+n9fbc4AFxKaTMZt2KI9Gqv03Y+sFjb3rkGcruw4CR8KNm/Zb
	G4ErQU5Bv0x7A3zAmM9evi5WU2jFT0YfQJt7v7SIKF4MkBm88DaZh4XF1BQodFgAJ3DYSb
	cZU/ARM8Ye1tfOa3hVYnANtKsK7rZJc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0843A407F4;
	Thu,  4 Sep 2025 16:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC426C4CEF0;
	Thu,  4 Sep 2025 16:59:37 +0000 (UTC)
Date: Thu, 4 Sep 2025 17:59:35 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Ard Biesheuvel <ardb@kernel.org>, Dev Jain <dev.jain@arm.com>,
	scott@os.amperecomputing.com, cl@gentwo.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v7 5/6] arm64: mm: split linear mapping if BBML2
 unsupported on secondary CPUs
Message-ID: <aLnFd1Hl_FSHZR3z@arm.com>
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-6-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829115250.2395585-6-ryan.roberts@arm.com>
X-Stat-Signature: 9wgn89tiimaj88y51mjkeg9eewzp8isj
X-Rspam-User: 
X-Rspamd-Queue-Id: 11629160015
X-Rspamd-Server: rspam01
X-HE-Tag: 1757005180-55181
X-HE-Meta: U2FsdGVkX1/D+8gRyG0QHzOFBPYqbChTPxLPONRQriijRh1uHWSacBSj0mdEhipW2clLcaakHydwlUnzvmPAIU2zf7f8wbgyW4pl/QP/JeDgJA2DCNaCX122Hxdu5RUVzI8hbVrRCmW263+Fz4pPw1FOh1I4CosWEU5O1iYDJoKhIrj4or7lddoGg7uJFHXk3LB5Gff3KAPwluT0PDEhNBQ1OD8/AjS0QlrawUPw5erAqbq7TEwf8t0ph/OJm5Akcn8xe8/suQBU91rjgQs7pn9qllwo6z84a49pTtw1YHyUVMpkQLwvFOZs72kIlGbC9J+gPnE/HUtj//8N5h4gboPhiQFXGfIWx1cZYDIR5GuJqsIfXq2m+yktN7yGLLMVrgE7bVnIVmbHuU4BasutXTa7TqZ9rlyAnNbh2U0F/8yZSPoURtqOu9YrIxzY61jvb7J0zveWjibIE2IbUXwPrxDJmVNxztcjqcK6SYXHiYJBoL9YQdhfuAplRRXeQSZSnDo9bhvjLmk7pt/hhMGx3TTAuT9OUMTspYfp07ABoyz6E2is8Bb+hyjnLbWX/vYlSh8+0VJ4VnLaMN4FGjVDvs0aS6AQZFPKOV8xS7tKKkUyRfTBsYnCmeqmyWCjgjCgtQ01QHqJmSv1r70WnbOWDSfDf6LY4eSTXOgACG7nQ8U9ee9xwA4HRObSiiXb9sQ/Gbgd1VJjld6TPcjzMqHKi7Abinb7lneQ2ap1u+adI6COELs2w3G1hfxCz4njmC1PNY3wBhzIvANwliVFRAW8lZpMApGXXKDiLCjZVsX4GymWBlwkwgwDL9Hc2aLLZ+kMNtYvMwS1eK0FcWZvHZyIU6B4mjPTNwjMYM3irXxNDLuV5wIMdd8JHVLQaI5ejt83b4odTAqZMNQKzZjlqOKkukayvj3haLqbGbMLLTYSqBkjEkMl0l4cG/Yf3BbE8lafd49xaYodqTYgNH0Idmh
 ClWb2Kyg
 7TDdX1QkWfD+3r0e0TCecmS+4krPVpipiu3TXCX4C+dPcwkeMCHW11R8IH7JxYNGCDtVfzgrzY6yiHtw+tjqew3UfN/5JBP632iUzEWiDTX9Zq9aNVswtP7s1x9F9t44jrUv/QExw5Mtrg/hp82RThtweAklY7RTmRjI73Ix/y8nYj1H8naCDK0u78HUiWhLg5cKUDQ7b18tZcvsZLHD9SRzJojQiYO3vfafVLf5mZ2y0MV5GoWZrvU45SZGmgStftrxWRVDSqXHHblN8Yf/nWfMkvebPJyU7gpMEH74pe2CaNuW1UOuU0gC9QS6eOTC6NpSUTQPS17oXO7z/3Vb1eXZHKPflBgZObOrlRxZU+avbB0CtIPi4yFsqrfTUXUdw+YjcEaoJmaVbZAF5LU+ry94mAVKv2I0N+kK9O5IZzlUA2Gp1qu3PsEtS9jMoRi9NrhJicVuYsHjDtRakEpnwsvdGRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 12:52:46PM +0100, Ryan Roberts wrote:
> The kernel linear mapping is painted in very early stage of system boot.
> The cpufeature has not been finalized yet at this point. So the linear
> mapping is determined by the capability of boot CPU only. If the boot
> CPU supports BBML2, large block mappings will be used for linear
> mapping.
> 
> But the secondary CPUs may not support BBML2, so repaint the linear
> mapping if large block mapping is used and the secondary CPUs don't
> support BBML2 once cpufeature is finalized on all CPUs.
> 
> If the boot CPU doesn't support BBML2 or the secondary CPUs have the
> same BBML2 capability with the boot CPU, repainting the linear mapping
> is not needed.
> 
> Repainting is implemented by the boot CPU, which we know supports BBML2,
> so it is safe for the live mapping size to change for this CPU. The
> linear map region is walked using the pagewalk API and any discovered
> large leaf mappings are split to pte mappings using the existing helper
> functions. Since the repainting is performed inside of a stop_machine(),
> we must use GFP_ATOMIC to allocate the extra intermediate pgtables. But
> since we are still early in boot, it is expected that there is plenty of
> memory available so we will never need to sleep for reclaim, and so
> GFP_ATOMIC is acceptable here.
> 
> The secondary CPUs are all put into a waiting area with the idmap in
> TTBR0 and reserved map in TTBR1 while this is performed since they
> cannot be allowed to observe any size changes on the live mappings. Some
> of this infrastructure is reused from the kpti case. Specifically we
> share the same flag (was __idmap_kpti_flag, now idmap_kpti_bbml2_flag)
> since it means we don't have to reserve any extra pgtable memory to
> idmap the extra flag.
> 
> Co-developed-by: Yang Shi <yang@os.amperecomputing.com>
> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

I think this works, so:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

However, I wonder how likely we are to find this combination in the
field to be worth carrying this code upstream. With kpti, we were aware
of platforms requiring it but is this also the case for BBM? If not, I'd
keep the patch out until we get a concrete example.

-- 
Catalin

