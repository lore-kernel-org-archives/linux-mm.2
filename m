Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8FECEC01CC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A67F6B0095; Mon, 23 Mar 2026 07:11:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E766B009B; Mon, 23 Mar 2026 07:11:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 393FF6B009D; Mon, 23 Mar 2026 07:11:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28FD06B0095
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:11:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC6B31B902E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:11:06 +0000 (UTC)
X-FDA: 84577060932.25.1584FCD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 34A8318000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:11:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JtKO4QAN;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774264265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkIE6JOL7WrV9enUQEbXKzWC6F34ACZhKuqLyFySxHo=;
	b=WiI04pAMLC+559tnRDXiXMNKTGeKY1KJApE+R8FGph+aScVCfBWo70d+CG8y19KJTEBjTA
	lg262wo5pGTub4CWRXkCC2bKGDxxHHmKJcxYA7oO1RW8qXIK/eRf5+bTtI8AzZT6zSn55U
	oJqeiBd3j7lMx5CzAxQ+liiySAC/EA8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774264265; a=rsa-sha256;
	cv=none;
	b=MNOEKpVNwJL9Sxiqu0xHqyHLy5NDNaGaB6YfTrcsahQ7omFkeu405b9DGccOwqXVAXf1Rc
	2rMuBWoy4OOnhj0SunhEbhFD0gIsAKx39CRsuFe4LuUuyvnOQtGXze7GDb4OJuRNhjw3mh
	BBntcJVHq1fa0j2LScurcYhqtif2i+c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JtKO4QAN;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8230E60123;
	Mon, 23 Mar 2026 11:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF316C4CEF7;
	Mon, 23 Mar 2026 11:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774264264;
	bh=vTUszPxJ7UBycC8qO+JCehCQKDd15YQItm9d2WcAJPw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JtKO4QANPZgLp/9I0GWBByVvq719GSIruX6T38eKeXJbZuk6oOGlRJ1N7/P4rO4Aj
	 L8II8pmPgJYZ3/tJfC7RQG3g+SF6Wyxv0FY2PnunAYjKT9Id84VSQP51StTzOAMGLO
	 nyaLpuARpVVwmphwmR6LWHr1FBOqgi3JEG83tXBjlwl15JrR0smgomY7DYIzzjHTv/
	 in6+KmWKw03h/FTwymyLjyw/Qw+lVs34o/qHpsIfVN7YQ1giMr/lS3VTJRo4Telj3+
	 /Eey6aTdgACkv1z1fUa++f4u+FHbKIwnnwIvWB1yqPaabd874pJUgp9sJe/g6TXml+
	 cqo/XBij2wgsw==
Message-ID: <bc8a7721-2bb9-4044-b5ec-422633690971@kernel.org>
Date: Mon, 23 Mar 2026 12:10:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] x86/tlb: skip redundant sync IPIs for native TLB
 flush
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: peterz@infradead.org, dave.hansen@intel.com, dave.hansen@linux.intel.com,
 ypodemsk@redhat.com, hughd@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260309020711.20831-1-lance.yang@linux.dev>
 <20260309020711.20831-3-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260309020711.20831-3-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f4fdiomtruacrpnqojqhrnnyy9r5kqin
X-Rspam-User: 
X-Rspamd-Queue-Id: 34A8318000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1774264265-678666
X-HE-Meta: U2FsdGVkX19DrsHe/xdulFEjUTx563HdwxP7A8ZD6E/59/mssq/rwAz8U0VKRPGmw4CVC4/uF5FMykxXnVl8ng/AwbHJ9egOfakIvuuV1uPXy5ZQ85wE57mUxeMQuP05Oo//jw9Po/uiWfhsWVADIJ/0H1QUmMYEQ8XepGs3aSUfGNP4ti9E3N+Y+glgs1N0Cne5gPOfZu/niOIRVUZGd89D7b0ByEkaXKVV0WOK50bRJJLX5wG2MEELpK51Bxic/UcZzjbGTcEn88QJXp2mFzeLtZr7M3tMHlIeMu40oY/OTYyR7EfiQp2UbIa75EZ772OHYLRdIYZP+aobPzosrv9VxvXXKuisKoXVmy/saHAI1FIJqPwcqb1zVbK/gvGt1UrAQXgQXi3i2DP63LeKom29Byn10dekqbTH1IAi6NIPZcU4w0wmwHzyEgyabQDaTIlvfqs96rQxz4tk1/SxsNU2jylLkhoX2odhu/8ZK5n1kABPsyX/40uAbTuLTP1oHvo9TBpPTODEpagpWiN08kVEsXFI8vBgma+Mr9r48tbijktgiLwntU5WLg7x2dzhSSaKitsi8yt7p342lNqS+unBdqsxr73V/lahZrPp+z1ZS282eG5JEi+pmasm03jInH8Q5YR4T+paiG7imNIkJGxGYFPeVlNabUz239X+tkW3XrWFZLI4sc0uBIlyn++3bIhnOOM25CAtae313fDfn36uNpiLdxnst4/mRfTS5VFpfU+y0qn+r6G9IOLA9aR135RHZOA4Ry5FgCfeWhWba8RZmR7n3dXJYKVPgojEHEYxRAErOrA3MSstsjoP8J+MZc0HkATFFoFbA/N97r5n8EBKy2LBL/CR+jg2na5VRWh6+7Tpe0/eEsuQqZ1a7zBVNiuZMpBvB1dRPeXvf36OMpiiFmzju6HHEvBP9VM1iOACWxsEkbCrhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 03:07, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> Enable the optimization introduced in the previous patch for x86.

Best to make the patch description standalone, not referring to
"previous patch".

> 
> native_pv_tlb_init() checks whether native_flush_tlb_multi() is in use.
> On CONFIG_PARAVIRT systems, it checks pv_ops; on non-PARAVIRT, native
> flush is always in use.
> 
> It decides once at boot whether to enable the optimization: if using
> native TLB flush and INVLPGB is not supported, we know IPIs were sent
> and can skip the redundant sync. The decision is fixed via a static
> key as Peter suggested[1].
> 
> PV backends (KVM, Xen, Hyper-V) typically have their own implementations
> and don't call native_flush_tlb_multi() directly, so they cannot be trusted
> to provide the IPI guarantees we need.
> 
> Two-step plan as David suggested[2]:
> 
> Step 1 (this patch): Skip redundant sync when we're 100% certain the TLB
> flush sent IPIs. INVLPGB is excluded because when supported, we cannot
> guarantee IPIs were sent, keeping it clean and simple.
> 
> Step 2 (future work): Send targeted IPIs only to CPUs actually doing
> software/lockless page table walks, benefiting all architectures.
> 
> Regarding Step 2, it obviously only applies to setups where Step 1 does
> not apply: like x86 with INVLPGB or arm64.
> 
> [1] https://lore.kernel.org/linux-mm/20260302145652.GH1395266@noisy.programming.kicks-ass.net/
> [2] https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/
> 
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

[...]

>  static inline void tlb_flush(struct mmu_gather *tlb)
>  {
>  	unsigned long start = 0UL, end = TLB_FLUSH_ALL;
> @@ -20,7 +30,12 @@ static inline void tlb_flush(struct mmu_gather *tlb)
>  		end = tlb->end;
>  	}
>  
> -	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
> +	/*
> +	 * Pass both freed_tables and unshared_tables so that lazy-TLB CPUs
> +	 * also receive IPIs during unsharing page tables.

"unsharing of page tables" ?

I would maybe have it written ass

"Treat unshared_tables just like freed_tables, such that lazy-TLB CPUs
 also receive IPIs during unsharing of page tables, allowing us to
 safely implement tlb_table_flush_implies_ipi_broadcast()."

> +	 */
> +	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
> +			   tlb->freed_tables || tlb->unshared_tables);
>  }

In general, LGTM.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

