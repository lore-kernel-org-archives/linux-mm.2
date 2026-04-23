Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D69B0F9936E
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 11:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03F1E6B0005; Thu, 23 Apr 2026 07:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32006B008A; Thu, 23 Apr 2026 07:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47C96B008C; Thu, 23 Apr 2026 07:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D11ED6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:12:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D17D1605AC
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:12:53 +0000 (UTC)
X-FDA: 84689558226.23.ACA5C9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A597A14000B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:12:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vULEhAPo;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776942771; a=rsa-sha256;
	cv=none;
	b=Q7PyzadwoPTi8aOEm/e0gKgxiB50KecF79CE23+Xv7mesr5TWTxMy9w4bwGHb+SNEtQMz4
	TyOYXlJBowUDUXQoKIJ7h4wXdGGBlbxYx1vnPSQGBsYiHCGlUrqvmHE5t9nqGc8/sgSNbY
	UGYmdgIxGPUWbAxhuGB2IRGhXGQawu0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vULEhAPo;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776942771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZpgQ6720MFa5Y5hFI8nEZItxyxiMa046Rsu6g7exts=;
	b=pbVrZpRB2y3239SolsYO41TQM/c0iZ5EGuogAMkrwYXX2wp9PPSChftLD0ycE1u0nFYeqL
	z3d9t2Vn0jFtOSJIbFVp/fblzyeNhycrTCkkbUOMRJqxfrBrMVYwuhVXvv+xXqqjhIQh4w
	zWiGaj/MzEo9nPcP5Kg8TqbV0FmS/Z4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B25844302;
	Thu, 23 Apr 2026 11:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4A6C2BCB2;
	Thu, 23 Apr 2026 11:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776942770;
	bh=aG4UEfRKsS91O3VxSN0LQyWp1NS50airK/bhwBveSOc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vULEhAPopc8qt2HKcJ+ZpRi46sD2pitq3K9i3RNrzavSVfWwwfEn18780bqNu9Xok
	 bI22VPL19Ky42B1brpsaJkaLMfz8fIBtfPEjeyLgb6z61B8EF5oI/IKR7Wg47POe+e
	 akDmnid3ESV01CXGb4b7NGUwntsyB4dR4oSJL9No=
Date: Thu, 23 Apr 2026 04:12:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hrushikesh Salunke <hsalunke@amd.com>
Cc: <david@kernel.org>, <ljs@kernel.org>, <Liam.Howlett@oracle.com>,
 <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
 <ziy@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <rkodsara@amd.com>, <bharata@amd.com>, <ankur.a.arora@oracle.com>,
 <shivankg@amd.com>
Subject: Re: [PATCH v3] mm/page_alloc: replace kernel_init_pages() with
 batch page clearing
Message-Id: <20260423041249.156eb95889696ccfaf23dca1@linux-foundation.org>
In-Reply-To: <20260422102729.166599-1-hsalunke@amd.com>
References: <20260422102729.166599-1-hsalunke@amd.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A597A14000B
X-Rspamd-Server: rspam12
X-Stat-Signature: 68pkbd9sob3co5mg7x6kn1hnzo5mykkj
X-Rspam-User: 
X-HE-Tag: 1776942771-551300
X-HE-Meta: U2FsdGVkX1+WXgBcEQQ71KampFowFu5kXom+/18Eaffsr6zq8MoyXUL2vYJIH2jsHG5GuR16hEwg78zA5IAk9/PfERhXiz/wTPMEy77EFqRnz3965RAFdYjz7QfkDk/X/y4bLCia6i7OR60XxBitj+fQ04WiNLuJc1Z0UNff+oxwWtveGgCPYn1zdV4MtuTU9hFsXPi/A+q8zdgGdZ+v1hdG/aLNH6Gn5RKt43NTyB/uOrUg+oN1omT2DCkcM2cd2pC1CWVMoeBbRwC3IlgNLvUEiSfDQjbLa88JkunkH1LgR6aYP4zO0LeYiSH4Pw0mySbDg/9sxy39JV2bKESrlvKlTgLBtsmG/DVOBNAsJoA+VWrNibV15ZUbmxzysHV/Z4BQo3vGIy3BO+fSS752qeB3ovZyOxieAUeYTra8IiHzmo2TWHN3CJKZTdFm9KW8Ei1ex/Z4Fu18e4YmM2qm0U40kzDm6jKtDvoRn6Qla8Ibq+GebnU2rYrQV6TJoa/31waV3wk+dvQxtYJovEiwdj+JUd641MiYVZ37X20CTQ8Yh7mwAqa+XVnzmls8+NB661ViYuDeY8tHOONvCr2AjeYEsKU2pXsMSrT8u6YMMx2Plp8nip981xmNXcKWDsUETfWRcGtNXcWNvbTSrM36wWHSe0IMyFb7uofV/ZxAyXTRMmduYMkUoVcJVd4V/J3C4bNrdt/sDmW9USfReVa05UGIJMVgWF1XIEzn1pDsFyvw9yab8urqvsG4nktnrE3XHm2gpyMR4jrLPD8WCbkmYqDGaFblhjEtSql/LXrV5TGoeKS6S6eUjNAEgugDTPTGUhTSc1JJDF0tjsBYsW8lthTr1oa8TmwNz1Ttfdd6HEyTW7JXjhVoOn9JykIc1D4SHAs9sVwFQ2LY78/e3/GGSkxMljX2NOmTGpU81/ZBN+FZolh7/x2IGF9LDIJCesNNvBCINtYkpCX4CPFCqEs
 fbBP6a4w
 +kaIekZMm9AMjWPC06f1JnfSHaEcVWVw7YV5HBXpi393wDhQWj4TSYmaFpAnXk3KVpOT4maFSjyX3ZGejn46J5wo3VNOKN6dfQTuVe+CJHuiH7A7ktriVZJVkx3gcpeKEY2Glnw+FAUDFPNAxdcrfhHquABb5b21c9jjFzxis0UE1CvYjy722qxHapc67pl3i1XSkZ0y3oxeG//FjFtwtrZw4sh2X1cqRQZYn93lfEadvRh2pbfkNa2U5nPHEbDV1uvEwd7ScBJZyqWO4ygvTa8GpKd6d7SFwj3HSp6nNxa7MgsGTaJRzXsT/BF7WBbxj5okB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Apr 2026 10:26:58 +0000 Hrushikesh Salunke <hsalunke@amd.com> wrote:

> When init_on_alloc is enabled, kernel_init_pages() clears every page
> one at a time via clear_highpage_kasan_tagged(), which incurs per-page
> kmap_local_page()/kunmap_local() overhead and prevents the architecture
> clearing primitive from operating on contiguous ranges.
> 
> Introduce clear_highpages_kasan_tagged() in highmem.h, a batch
> clearing helper that calls clear_pages() for the full contiguous range
> on !HIGHMEM systems, bypassing the per-page kmap overhead and allowing
> a single invocation of the arch clearing primitive across the entire
> allocation. The HIGHMEM path falls back to per-page clearing since
> those pages require kmap.
> 
> Replace kernel_init_pages() with direct calls to the new helper, as it
> becomes a trivial wrapper.
> 
> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:
> 
>   Before: 0.445s
>   After:  0.166s  (-62.7%, 2.68x faster)

Nice.

> Kernel time (sys) reduction per workload with init_on_alloc=1:
> 
>   Workload            Before       After       Change
>   Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>   Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>   Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>   Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%
> 
> ...
>
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -345,6 +345,21 @@ static inline void clear_highpage_kasan_tagged(struct page *page)
>  	kunmap_local(kaddr);
>  }
>  
> +static inline void clear_highpages_kasan_tagged(struct page *page, int numpages)
> +{
> +	/* s390's use of memset() could override KASAN redzones. */
> +	kasan_disable_current();
> +	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
> +		clear_pages(kasan_reset_tag(page_address(page)), numpages);
> +	} else {
> +		int i;
> +
> +		for (i = 0; i < numpages; i++)
> +			clear_highpage_kasan_tagged(page + i);
> +	}
> +	kasan_enable_current();
> +}

Why was it globally published and inlined?  Is there any expectation
that this will be used outside of page_alloc.c?

Both of the callsites are themselves inlined.  The patch adds 330 bytes
to my arm allmodcnfig page_alloc.o - did we gain anything from that?



