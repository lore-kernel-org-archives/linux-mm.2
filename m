Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68260CD8CA8
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 03:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B654D6B008C; Tue,  9 Jun 2026 23:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16DB6B0092; Tue,  9 Jun 2026 23:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A052B6B0093; Tue,  9 Jun 2026 23:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8B06B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 23:20:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39B471A0831
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 03:20:48 +0000 (UTC)
X-FDA: 84862550976.04.8AE9565
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf15.hostedemail.com (Postfix) with ESMTP id 62061A0006
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 03:20:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TnKTBVRJ;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781061646;
	b=s9+HElqE8Fv8BDXs7obrYal4DRqtMpeFKeLROUX8IrejdoT3+hQzd9aTy5DXnHnlJqVHYf
	2Os8ElHuCZ4HC4HfERDmOHfDvPUx8KuAc2MhDlCvF5OyuJ1Nsw8mprucgqGYCj7EmbyWz6
	ts2Gk6MwolWV16YmZZyehFGsfK5etoA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TnKTBVRJ;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781061646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ih1BA6VBQclIQnLMrdEp760CNzU2hkoYJjVIAwEnP8c=;
	b=6i/2kSQ9aFzQuQjDCnpXWc3pf2+CAaEnYepshY4z+REriGAKgKw0KlN7o9+nhb04kSwjTH
	pe9DZHS4DQNdLw508h9mhhgwSz1vBPAJKWFaAUWA1OB/tRVFdf9GAoormY9vi212AA9ije
	sJHdGCKx0XdNjCC5TZdu1E8sDyICj94=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781061643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ih1BA6VBQclIQnLMrdEp760CNzU2hkoYJjVIAwEnP8c=;
	b=TnKTBVRJuvU106/Zwt6YCEBWfPJp5K1VWTaSFRqCyVV/HvjLO52x40h9PunBn/qPPEPU+n
	W5HpnKUtdMxNX2c0p1aagTgWS2XJRJssUy/LyBQ3F98/lV2TyDnX/q+L0kngAjjHEFSfW4
	zLQyiio8VwGcbOAHXVj2V26/cY6XyGg=
From: Lance Yang <lance.yang@linux.dev>
To: dave.hansen@intel.com
Cc: xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	hpa@zytor.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	jannh@google.com
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero folio read-only
Date: Wed, 10 Jun 2026 11:20:22 +0800
Message-Id: <20260610032022.23361-1-lance.yang@linux.dev>
In-Reply-To: <930d9121-9176-4a7b-a2d7-8224f94000d3@intel.com>
References: <930d9121-9176-4a7b-a2d7-8224f94000d3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 62061A0006
X-Stat-Signature: 44sqzywjhsfnx5uy51qqjkapdbp1he6o
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781061646-258466
X-HE-Meta: U2FsdGVkX1842trKPAHJ20Ctj+j+cyuddg5lmfA3SuK8EDRoUKhw7YBd/sNMtYp4diL7+DaRJVOC16imwW3SvAhdUDcSFmMHingcSWTeI0Z6fnRsRxV0wqey8yJSLSe2kHVNjp5oLAuhyFTNem5acdO7HQ3hlyY6OaaTbLU5PilaCblxgIsMh4LAqK8HSfT5pQA1sKam9kM8vQ7nJ2XVKHTiYpJnarTYct67LeysgWyDw9RAjj1k1yLsN+bHBncngalLYR2B+IVsUX9DtX3lSdrX25igUjEPOnbEgjfhlOFNi8t/CC4TJO48r/RUMGTixlG8W/p8JaiqKFl0aKAx85W3dieQsk4TEH5rquVmLWZdhDeUxZQIq2Giwf+n+0wzRlgmWtLSWVmGdjNIql2JaCcvEyfTYb79Uv+adgCp36kyUfR5ySgCDOVC0jKkcX1fZGdRdk+RR6S2eWhFVHyHKIwK2a9qXHXpsdWZWk4rZNPE6sIphbqkhpxyZ0hoPOXHIdvhDSXrT7x6c3tr1MPc8JFEp26+PW4Hiac/a2KZ3iYaFKSRRUElh/0L1AOyP2aKBPVmCmGh8BI1hsbpsTqtGFbaaolXnfb9T9wxC7EcSZMsno1zusiHm+18JK1DkoRJf0HZ5rriLMzlJH5O8aJ6/bQK7+1bQyhRx7OZ8d8Hjr4JbIsKaTT/KnoGsCTYNHtlnl2RYEnzrvmgc0IpdWXM4waFT2RcytieLzMBL/WGqoIQ4flIidsRjne88m38ywxQeOEIa0VJBFylLnMY/tKgSwxVs4QusqulqrD4JZO4xmoUesrQRu6fTsoo4xLdJlwxedfwHTZH1ykqPH5T5LDrStnOS/Zbm5La1WC7RcmAOHeeyVKkWgXo74OxHys01ePhD3D23Fj2iJscixdOrpYCmqmWEyfAYv22wAvJpME4HH+cBUdA5GNEq4IatfGzpyiCUqQgLwBlCyhwmUw9kcq
 MJcM5+sm
 hOa6RpIOp1BYyaU0HKQ8VwOJ07TrBoL3eFKPmpTLX1i0uupDutUHRB/x7jsB5mRrOLaQhMPwNh17/r/2Mk4aSx/BMoq+eaSce/ABO5yrVRfLYb/JYuM2oHldKR0M2q0uBohgMlYdkRqVoi1hTF7RmTCbvEIj3oNYQE2ar8l5HlcqSsyujB7pHXesPlrwSr4p3FKUaKYbQYVgpSE+0+DqdABrcGRX6hZ65fxvPkWrIrAYoWxkUtZE0YxkNOguoWGWld/In5PoA21hTULHqvERnIb0vMdzUQBLeST5cPQO60CeHO6JJIfEOh/OlsKtIAZJA7vZjcxgE95mZyXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dave,

Thanks for taking the time to review.

On Tue, Jun 09, 2026 at 12:33:36PM -0700, Dave Hansen wrote:
>On 6/9/26 07:37, Xueyuan Chen wrote:
>> +bool __weak arch_make_pages_readonly(struct page *page, int nr_pages)
>> +{
>> +	return false;
>> +}
>
>This is a rather wonky function. It's going to cause all kinds of fun if
>it is used like this:
>
>	arch_make_pages_readonly(syscall_table, 1);

Ouch, yeah, it is ...

>It's also kinda weird to have it return a bool, and not check that bool
>at the single call site. Some things come to mind:
>
>1. This function needs commenting. It needs to say what it does, when
>   architectures should override it and what their implementations
>   should look like. It needs to be clear that this can't be used for
>   anything really important. What should architectures do with alias
>   mappings? Are they allowed to touch non-direct map aliases? Are they
>   required to?

Agreed. Needs a real comment ...

Just meant as a best-effort direct/linear-map permission chang, nothing
stronger than that. I should spell out what happens, or does not happen,
to non-direct-map aliases, if anything, and make clear callers cannot
treat this as a hard guarantee :D

>2. The return type needs to be reconsidered. Is 'bool' even acceptable?
>   Should it just be 'void' if callers can't do anything when it fails?

Maybe ignoring it is OK now, but someone may need the return value later?

>3. What should the naming be? "readonly" vs "ro". Should it have a
>   "maybe" since it's kinda optional?

Fair point. "make" may be overstating it a bit ...

With a return value, arch_try_make_pages_readonly() sounds about right
to me. If we end up with void and pure best-effort semantics, maybe
arch_maybe_make_pages_readonly() fits better :)

>4. Should this new API be folio or page-based in the first place?

For page vs folio, I was mostly following David's RFC v1 suggestion.

Current caller is a folio, sure, but the page-range helper leaves room
for non-folio users later. Happy to add a simple folio wrapper if that
reads better ;)

>5. Is mm/huge_memory.c the right place to define a generic mm function,
>   even a stub?

Ah, you're right! My bad, wrong place for a generic stub. Will move it
out for RFC v3.

Thanks, Lance

