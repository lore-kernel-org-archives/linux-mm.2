Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFB40EA7944
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 21:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05E026B0088; Wed,  4 Feb 2026 16:01:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00B726B008A; Wed,  4 Feb 2026 16:01:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22D86B0092; Wed,  4 Feb 2026 16:01:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC76C6B0088
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:01:52 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 851F4140311
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:01:52 +0000 (UTC)
X-FDA: 84407996064.27.014A757
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A6E861A0008
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:01:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Vzrnjuj/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770238910; a=rsa-sha256;
	cv=none;
	b=tLLk86Bds68LztPFI67lb/xELn2z3dXBatnjccbT1Vwv2m4aT5vip7sG7YUDLTymS76aUI
	jd229FOhjcY0OId2Cwl7QpVrHF5sFEWcu6KfUEUlR1zpsiIGfUXgvEQMOFp3HIjTPDqEOs
	s7yYvtUPfT7c6MN5lAO7xamBUXSdqRU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Vzrnjuj/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770238910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fdmHgE3ZGbAhvRpnrLMyPKzhMTTJNL/+uUOOGFpPmd8=;
	b=00wyMeFfU6jSCQ51Hm3NiABM6susQvba5TaEYFP3y3LB5Cv3DzUDsGRLzX6bJycen129Ds
	QXLO2XR6vjIA5pK1vtrl3C+tgfYoONL43BIFfNAKGvgp/Je0YJnXSVc4r4Q6EiCwQN1LH0
	cY+MC1tAKtmA3tz5dPw6W4Vh+ueh4so=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76C7A44032;
	Wed,  4 Feb 2026 21:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2C9C4CEF7;
	Wed,  4 Feb 2026 21:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770238909;
	bh=jp2KfloYw+uC2B4Pxh+HiUCTQy7uOAAaMHvJN6AaS6c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Vzrnjuj/OhJlTXjtTS+zXd6lBLI3Hiy4cjnZ1JFzAV4OwNr4aBpV5r5gxMCWDXb7W
	 yJZoVMfN6LFBlWkgImX9+f1eXNpte8okcFJ3D3N+5VjQMXdPFA0SUdhXMvaO1/KNYY
	 q621/QIUEvMNKxbMZKdfnR0fpMtFX/bK+sKRFWX0ZOjj/dNfeKn5QT4rb5rc5gjDmE
	 x6xjMVdUETf+K3mbOGTED080SE3lbocDvqPiMVIc5c/ljKPAIso7z0+XVkLqaTYhNU
	 m7wCg7fEA1IdNGDk/yZ7X0lvogdWdcOrE563hP1IUoRgTQC8hjQJySuQznONrj74q9
	 s7shtKCW4HvEQ==
Message-ID: <9206a7c4-bf88-4138-b8af-961625a82439@kernel.org>
Date: Wed, 4 Feb 2026 22:01:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: folio_zero_user: open code range computation in
 folio_zero_user()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
 lizhe.67@bytedance.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
 kernel test robot <lkp@intel.com>
References: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
 <20260128185943.2397128-1-ankur.a.arora@oracle.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260128185943.2397128-1-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A6E861A0008
X-Stat-Signature: ess5qapmo5rw35ejshaaybo5n7gmg33z
X-HE-Tag: 1770238910-475740
X-HE-Meta: U2FsdGVkX1+aUrJv/jm63Xziaefs8X/svKgT0cVCT7GrtbtXdbe8BGtJajGVUN2NkWHSGC3mMajZu6jlNdJcgXhM5EBw2SZCBXWNWeKTRcz/fbKcexHhd9L1r3LuuD6yW0ILCSrgQogUj5ItjE1HvQ9kaJ5zSJuw/2LSu7N8ko/MqBC7X5o1e7Jl/pSXrr5X9tkNo5g/cpjVx/81qgTTqe4OitI5COg/1/KJgNykp2X+Re30SeGIKxptyOWzIeN3lkjlPZLixKwBk4eMoRSpT7twRuSnLZ3Z/3oEpEYPy3/8tJjg7DFB93v1j2p8HGxi3jq9qQeOy/3ZrwIkgtgcH1TJNhpd5SqofC3MjpootMElmxl6MeB6TgQo68KA1JLfZgG+TbYlFpVcwAhTN3PBB7Fcf4uST7zJqLAUtlB51I5nqOTUNtQNvH64kNfSH2xwmonVa2pbeol/mx4N4e8UVEs1L5B0S0VYCi/U5DN/yMgVVg0HtN6c0eOe+gGvn7mA7ldGqn6g3QKBrIJZpx5u3HxplbNn/cLTPLCNNL5b3bzO2m6WSvHWHWt2hYnoWQKb9E0WS+VLTaiTUSkVuqG2a3/aF4czdbnSxcP7AbLhO63GBvQFU8KO8+PgN3oPkfBvq5U09OkGbAcDGxxyVGV0UX565E3FSWpCigw8xBh7RhKoP847ytBZxoryTqDWskK+rzvqTs/LCGeF33tTrGDvIwsvbvlJKMNzb+1ktPaH43SZTPB97GPkuQ7DGt6DcfkoWA2z+dHE00lNht0PidylXrPekAG1pI6Gs+HGSkXChraZZ9NWO0ow7EAVz3ONxwyoinU4aUDFb0FYa0EYWB9Q1EJp6ZfNYGuWvofJ1vZWdtDPws3G5UTwfiil70Si+gYdzGCa0HHF6YyI5WFhU51gqgIwRskQIrEs0f24k2Ozh9McTUVTAJ7aqoGar9TemBExTTaNzO/fFycQ5uhj2L9
 NuZlvJLR
 EGL9esC+NJSTRpoCm1egM3kQK62tnv5TYcDg7FjItzfvFXSiiIEOJYiXe4zEuzKZ7Kgv+k9JyPnUJe533B+RZnwJTtZ7kvYYO6QDQts/gQhMTItKCHy4RY9n/h3j+NWKcm3P5vSSUFwjen3yh2YIcUaYoZPQb5TcPlXSmAmQLBuJS+Nlh7+qqs9SHT3DG3coXJz63j28z525zAix7ucYnhl7fRTf3Is0dnJlJZgCgNNFtT8CPWkhiQGGNJYE/Q9cYIP2JmHQr+e+cGiy9fEKE/CbMRkoKRF/xR2FKFlH9dgPN34NH8Dn8u1RpfQFvncmSg4/y1Nr6jvrOAqodD7vjLplOvTOYctTDr5FUrNvFRiiRsUdNjOyJqdt1mq72t7Gd3DpB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/28/26 19:59, Ankur Arora wrote:
> riscv64-gcc-linux-gnu (v8.5) reports a compile time assert in:
> 
>     r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
>   		       clamp_t(s64, fault_idx + radius, pg.start, pg.end));
> 
> where it decides that pg.start > pg.end in:
>    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
> 
> where pg comes from:
>    const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
> 
> That does not seem like it could be true. Even for pg.start == pg.end,
> we would need folio_test_large() to evaluate to false at compile time:
> 
>    static inline unsigned long folio_nr_pages(const struct folio *folio)
>    {
> 	if (!folio_test_large(folio))
> 		return 1;
> 	return folio_large_nr_pages(folio);
>    }
> 
> Workaround by open coding the range computation. Also, simplify the type
> declarations for the relevant variables.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
> Fixes: 93552c9a3350 ("mm: folio_zero_user: cache neighbouring pages")
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
> 
> Hi Andrew
> 
> As David pointed out, the previous open coded version makes a few
> unnecessary changes. Could you queue this one instead?
> 

I'm late, maybe this is already upstream.

> Thanks
> Ankur
> 
> 
>   mm/memory.c | 17 ++++++++---------
>   1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index ce933ee4a3dd..f5bfc082ab61 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7284,7 +7284,7 @@ void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>   	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
>   	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
>   	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
> -	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
> +	const long radius = FOLIO_ZERO_LOCALITY_RADIUS;
>   	struct range r[3];
>   	int i;
>   
> @@ -7292,24 +7292,23 @@ void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>   	 * Faulting page and its immediate neighbourhood. Will be cleared at the
>   	 * end to keep its cachelines hot.
>   	 */
> -	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
> -			    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
> +	r[2] = DEFINE_RANGE(fault_idx - radius < (long)pg.start ? pg.start : fault_idx - radius,
> +			    fault_idx + radius > (long)pg.end   ? pg.end   : fault_idx + radius);
> +

LGTM, although it could likely be made a bit more readable by using some temporary variables.


const long fault_idx_low = fault_idx - radius;
const long fault_idx_high = fault_idx + radius;

r[2] = DEFINE_RANGE(fault_idx_low < (long)pg.start ? pg.start : fault_idx_low,
		    fault_idx_high > (long)pg.end ? pg.end : fault_idx_high);

Well, still a bit unreadable, so ... :)


>   
>   	/* Region to the left of the fault */
> -	r[1] = DEFINE_RANGE(pg.start,
> -			    clamp_t(s64, r[2].start - 1, pg.start - 1, r[2].start));
> +	r[1] = DEFINE_RANGE(pg.start, r[2].start - 1);
>   
>   	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
> -	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end + 1, r[2].end, pg.end + 1),
> -			    pg.end);
> +	r[0] = DEFINE_RANGE(r[2].end + 1, pg.end);

TBH, without the clamp that looks much more readable here.

>   
>   	for (i = 0; i < ARRAY_SIZE(r); i++) {
>   		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
> -		const unsigned int nr_pages = range_len(&r[i]);
> +		const long nr_pages = (long)range_len(&r[i]);
>   		struct page *page = folio_page(folio, r[i].start);
>   
>   		if (nr_pages > 0)
> -			clear_contig_highpages(page, addr, nr_pages);
> +			clear_contig_highpages(page, addr, (unsigned int)nr_pages);

Is that cast really required?

-- 
Cheers,

David

