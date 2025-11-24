Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE9ACFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 14:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5C16B0027; Mon, 24 Nov 2025 09:11:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065E66B0028; Mon, 24 Nov 2025 09:11:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E976D6B0029; Mon, 24 Nov 2025 09:11:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D53426B0027
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:11:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9505858D36
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:11:58 +0000 (UTC)
X-FDA: 84145689516.16.E31FBA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A3F2C180012
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:11:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TjUGt8Li;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763993516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KMDKfFvqxZF3OgYS2Y3qGBHTWecl6sSIcgPW0EPBoLA=;
	b=QF6pXeMcvlvWLXQqSZMrZJQ8dNdSM8Uiy8W0Wbj80wElLPJLq6W10kQS+3kEC5BgapJQGI
	oZH6Vl+hDybzimBatimFtADl8K6CvdN9urUSxMEI0WsKzFa1ZlUYyOQ6eRb4zg08Y+3Jyr
	l0zVCPnFMpeJFM4++JdapRfWaEbHTSU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763993516; a=rsa-sha256;
	cv=none;
	b=px/Ac0UcfYz5rsEkag9+VhtGbGVyFcNeCfxAxh8QU6ws1lANZ/fyfaTiSSnCFtZt7R/jcK
	8f8/L2YUCM+DmH+uxMyy9Nkx3fr7hF4MAiaJOnXe1mU9cKHnT0XhlCKC0X2thtHZZSJqDb
	wglOmirWc1GFlgYDgZMUHMzbo5SGBH8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TjUGt8Li;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 123B2601A7;
	Mon, 24 Nov 2025 14:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE78BC116C6;
	Mon, 24 Nov 2025 14:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763993515;
	bh=pKRds4IT+BzPKh2fxA3wO0tgnvzHdhCWGBCp+0CwG9A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TjUGt8Li6YfogSyMUKImhk9t7zCEyR/5lyaBjeNw6RcKDKrbRq6HnmNGUOxqptBCd
	 dLRr5vxSkWtTK/HdcfyyhBGI6jbvcRygLDwJPNmugo/e/qBVwdADZJpApwewQnH0Lz
	 Zvd3xoS+6vTxsekxWrHLixtrCO8PmynL3TGa54AYYvreiAeQp5nXHtEPY83/MIXq9v
	 IDvhAooUaPXLRXgkrwnbgHUW6P169b7ay8AKZtPjbmGcLHflIqg6kF1HvRTZ7a8+u+
	 51pYm9HXbc2JA+xZLuh0Y9NS3lb+de9hbRLWFhjCNgsTJpUFrYKe7BdliclaVXA64P
	 5nWYBjsK1rt0g==
Message-ID: <9800804f-6e8a-4d08-8eb1-f114df6d6b7a@kernel.org>
Date: Mon, 24 Nov 2025 15:11:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/12] mm: bail out of lazy_mmu_mode_* in interrupt
 context
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-8-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251124132228.622678-8-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4mw1r3fzf43wrafe7cjcfek5idru1179
X-Rspam-User: 
X-Rspamd-Queue-Id: A3F2C180012
X-Rspamd-Server: rspam10
X-HE-Tag: 1763993516-122136
X-HE-Meta: U2FsdGVkX19ev+s7aj6/BTVGPyuElye0FrKeDmbew6n6pnfi0c85YcsbL7c0p5LpP6p3xBN2A41TT97z8mOVCx6c6RGQv/L9ShzwS/akyWf8QSQho4N+mgck3aAUQ0JydfQqy4UpnoQgibBbQFVl6JyDYALufSfDS7Pp08lz5RBnO1hRQ5pllKNYYGBzw8NtIqrqEMCJ0dyChSqM+MtGZc/Yi7vtfftZZcWHVpfXopiVeXBYLIR6eFRssdZ3e474mp9WKROFnwucdgRDmO9y/nVQXLkzXoPSf0vJyJZ/KMef/cuO0MSWeshez/epPUWSQZ9nfx72MlyUi35F1Q0WFO6IGfpA3bS2do5LWZr4T0I2iWLVADKBzgexDCykEbO3KMrIvkb6lgBCnBq2yUAwFeAJccodWf5EcArYOqlqz1UPtI7+ISHltKRfhbWwyOxGDpb8Zxs+YQB7Y1Ug82XJpNvQWC8G34Z8V8VESs3JlyjlJ1UnAiOa9KW/1Cr0YEpr2VEbSuvoWrCi3ZV2Gz+6fq9BHlUbdWcZE+eT7cHolGRXF3xXIKbhqr2DDzav4hnO0Bq90FIRuH1yeJiP4GjINCxnDo6xSUY4BLftEbT1IcGqmVgHGHeaarWxuK/uioLqCnxdEcew6m3q029VebdLun2GkP3WqjjbnqX+8qmMDxT19j/WI7Vb3Gbeu+Bs1ikBgwRqvvOsB2/tU4acHv+O+u3yq5mJkVhJHpJvvFfMFuX1XGVW22nc+5GsLu03Wwtoo7qRGJJjr46TLP5XD0dwj1jM6Ufk5Kb4pCJKjUC+1sT7lXEgf2i7IlHHg9g5X69EiGPK5MJVPFUzz4kzpENNQB9GM3IiA+mMLc7LoXUn4ctYqVR7AxKEr2ajLoIvu3JHWFLzaPOXcFhfvYH/BYN/7IhTScAx6YmVYu+YYpcdzF8hccawvZU0iXQMCTd2ia/6x0qBAxGwwQHM4gCbzXI
 M77WoF3d
 AuBmtP8B+neC4e/vjnUcho+WZyPwexhQDhHEDfuIfqyADnoBdW1UVvauujHpiH6r3xTNy7UL1I11Esf97VCEEU4ubETbbGwVafdwXFCmVkT1E989yEsMHM1oLK3rMBwoWEHkesCRoNKGTDR6IKJolYgXhZRL6m1Qs+QCPC5E2oMm7y6vV2WEsRnBmxRHM3jmBJRFjdseT4X6fdTAhHcVvo/wogZHDZInI3GOuKZGeSACjpbEtxmXksg6+N6/IgyJGXqr6RJfS4WGRYqr8p7jtmtxNfUyD+wktmKzyC3miGfySkdNKgmtDnA8ci9SIRSmhXlUHIK8eGzFZ8TGAkO6b07c77492Dh0A/aWNOYzsXHe8TbrvIB3cj5VVsiW3WxMbM1nvBjfwNviWHkb/VsoFvFLLwyuPkxPDrbdgqsnHWSPqYU8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/24/25 14:22, Kevin Brodsky wrote:
> The lazy MMU mode cannot be used in interrupt context. This is
> documented in <linux/pgtable.h>, but isn't consistently handled
> across architectures.
> 
> arm64 ensures that calls to lazy_mmu_mode_* have no effect in
> interrupt context, because such calls do occur in certain
> configurations - see commit b81c688426a9 ("arm64/mm: Disable barrier
> batching in interrupt contexts"). Other architectures do not check
> this situation, most likely because it hasn't occurred so far.
> 
> Let's handle this in the new generic lazy_mmu layer, in the same
> fashion as arm64: bail out of lazy_mmu_mode_* if in_interrupt().
> Also remove the arm64 handling that is now redundant.
> 
> Both arm64 and x86/Xen also ensure that any lazy MMU optimisation is
> disabled while in interrupt (see queue_pte_barriers() and
> xen_get_lazy_mode() respectively). This will be handled in the
> generic layer in a subsequent patch.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

(resending as I pushed the wrong button there ...)

Moving this patch earlier LGTM, hoping we don't get any unexpected
surprises ...

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

