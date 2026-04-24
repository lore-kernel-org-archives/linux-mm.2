Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C55EEFED3D9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BEE46B009F; Fri, 24 Apr 2026 11:05:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096CE6B00A0; Fri, 24 Apr 2026 11:05:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F151A6B00A3; Fri, 24 Apr 2026 11:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E0F5E6B009F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:05:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75EDBC101B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:05:11 +0000 (UTC)
X-FDA: 84693772422.15.5954019
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id CCF1A100017
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:05:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GBm3gHMf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777043109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NqApcQrwdhaOtWhqBdoM6sLqZ2bCPI9lnI5VOoCdDg=;
	b=Nl6gf56Tdb/pRApIl5JQPVvmQzetSh9ZZqOVDKVdMx7Ew2a4bQfgbCGkvU9woBEERUl54i
	z9GOSy8Tv5wdI3JEft2caE9sy3L9VxKrAJYSN6pVYF8DkE5sWz64lt53Itp5Xo/FEtnEpU
	NreYOCv/Q2m9ayPsDaFD0oH1Xgf/QKo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GBm3gHMf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777043109; a=rsa-sha256;
	cv=none;
	b=ftyqrP1UxJxs/nOC1bcyKobHsvrednZlp2aW/D9I28AcfmnyOJYMC7MG99dP44u5C2Q7nt
	e+Do5iks3rL0SJnObZ9pMcTR05OIsnz8mpOwLmIY+/eUdbpNElHNQznbeNTptt59ZY+xdU
	MgyeVuahJJ9qUExUPdF5YHTi6WjlNik=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+NqApcQrwdhaOtWhqBdoM6sLqZ2bCPI9lnI5VOoCdDg=; b=GBm3gHMfOVuha9S9cV0gdRX1yr
	YcsRzjFVJFChaczV7xWUg5ocsiMLja9wCwp5Ve36UGe/gNs1EIRcmW2rdxVQ6S/dBxD5qmnQPhvmf
	5U21nno16gogxpiGy+1qJeXBKtgHU8bR35ejMKPbsORtH5XVNUEN/5vQcZ6dyIKoqOMOrGOPELKDZ
	wl8otUg1MRTIkW6pKcv3flWlUHnMZyCopyIXfGgnK1XG5Fb1dOgYyiC+r4vMmPw1oW5xYL1ZG0myt
	VAkU6mqW+K3yF9kV+LpWrUvXsAeCSKveJOLDeejVyi85mDGUVGs3vF32tZmElrGMfcYYpl+qDoS4E
	RfyT2c+Q==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGI5O-0000000FNxB-407k;
	Fri, 24 Apr 2026 15:04:55 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8B7E8301261; Fri, 24 Apr 2026 17:04:54 +0200 (CEST)
Date: Fri, 24 Apr 2026 17:04:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, shy828301@gmail.com, riel@surriel.com,
	jannh@google.com, jgross@suse.com, seanjc@google.com,
	pbonzini@redhat.com, boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ioworker0@gmail.com
Subject: Re: [PATCH 7.2 v10 1/2] mm/mmu_gather: prepare to skip redundant
 sync IPIs
Message-ID: <20260424150454.GF3126523@noisy.programming.kicks-ass.net>
References: <20260424062528.71951-1-lance.yang@linux.dev>
 <20260424062528.71951-2-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424062528.71951-2-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CCF1A100017
X-Stat-Signature: qtpcwrdt5xb9ekkt5izwfntju6ae8um3
X-HE-Tag: 1777043108-673532
X-HE-Meta: U2FsdGVkX183pRBIcmZWAoldvD5HHk//AGrvJ9FGAw48p7ZQ3vZ5Tn1ahhUiAB74opp8f4/jx2dIoMAMhDmkocJEHLpk4aE/t6w4wmv0N8UijZ1gtlPAQELn/7nPzR/H2yUmf/S0cNi/WsqwhtYd/sJ+i8du6li1Gzh3fnG5sq6SZkF/WolaSIyn9/iGfQnFPXzSwlpV6uuUqkt07otH5Z06Q3x6DPdqT3asEDpQepaL7P/ACkXZsRwLXySTxTrw+vhmeFLZlaBQQrycKS+i+0VfMc4kGpkOlof4ENJDzMamLZ6SVD3pO/YrFeYBtl9+jJ9/ZgvzEYXFHx05uxIfiyPVNkQjO12HkhxgZtpjuK3htIWCgER1BMuPK+lQ/41khX3tvvvYni0HHJl52rv9jTkuctxw1EzxmLtzmTpb1TdOCVRT5IiF0CyWxlTdVXgr9JYRWj0kbdn6F8tQAIdB3K9dFXRmfPdlryzek+FQ0Jpve5cS2gLQvGQuZCZNAEtc0yLRGO/ZUd9M5gUxg4i6z3ANxVzqE8NSN+aUF63Gzq9b9mnCduqT+lJMxCRMPkgW9HS7jpHgjPtgZK56yaJT2peqwQfcZMzj/EBIs7bKOnoq5YUoeoyKWvi9sEQscIt25H3ajDpFnFXX9ZXuHGzpWebL8xKoTNl8CeXZbjLOwyHopFVcA3oGMkq167bUd6JRFlyPyydfVeCRstQzMstvnqx5NlEfddj1JwevOLOrf/eLMGPXAFyyP4hbsRenopmXBx3466OuW5n8nZ5VIhHZhE1KzjNF8WsQbTKzNyoXyCIYeDFpXUYXcOUtCqJeDrwTMZPg93Qhry8k2kFRw//KihBiiOjCGTkgYmGog08+1lgDPt8aQKY38Vc6sPhf4Izib7xvd7R9neZT0yqSWXUCXl8wnl23el3Q0ea2D8tSPa7YI7/vCufRZNxA5xaHtKl9JyD0GszCoC1rxVFNDxO
 jDp7bKly
 d93o0Df4qtzoQpklhtm7rVT91NAY6tI1v8x9vxr8Edj5/I5dl4ONyzkm2uIe5lveKGtTV4lDlhJsG+nFbGjZ3xJ8Z+DIDMXPrXFcdJTCorcTglJxWNhGejpUk7ti64cPJkjq0laH0mnSIuYJbupeentpeDgaVfj1F8abptTrMV9bq0LJ5tfAo5OtgxexfU0mYTAwD/qABJ//ge80BjS9WKPc2kdX6koKIU54qGHRUdHVQLhgKZwTfABs7VTNh6rcZIH0ezzduUlbmBmrEuvghY58LTptlXaQZVx3btwzvbc6zqZcS1k82tFfEJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 02:25:27PM +0800, Lance Yang wrote:
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index 3985d856de7f..37a6a711c37e 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -283,6 +283,14 @@ void tlb_remove_table_sync_one(void)
>  	 * It is however sufficient for software page-table walkers that rely on
>  	 * IRQ disabling.
>  	 */
> +
> +	/*
> +	 * Skip IPI if the preceding TLB flush already synchronized with
> +	 * all CPUs that could be doing software/lockless page table walks.
> +	 */
> +	if (tlb_table_flush_implies_ipi_broadcast())
> +		return;
> +
>  	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
>  }
>  
> @@ -312,6 +320,13 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
>   */
>  void tlb_remove_table_sync_rcu(void)
>  {
> +	/*
> +	 * Skip RCU wait if the preceding TLB flush already synchronized
> +	 * with all CPUs that could be doing software/lockless page table walks.
> +	 */
> +	if (tlb_table_flush_implies_ipi_broadcast())
> +		return;
> +
>  	synchronize_rcu();
>  }

So I don't like this at all.... The comment says there is a preceding
TLB flush, but there is nothing that guarantees there is. One would have
to go audit all users and ensure this is always true.

This thing is incredibly fragile.

Also, the comment in gup_fast() is nonsense, the local_irq_disable()
isn't about tlb_remove_table_sync_one(), it is primarily about TLBI
IPIs.




