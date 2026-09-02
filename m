Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666A8C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C6226B00A1; Wed,  2 Sep 2026 12:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650476B00A4; Wed,  2 Sep 2026 12:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542AD6B00A5; Wed,  2 Sep 2026 12:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3E66B00A1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:49:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 996AA1601EB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:49:52 +0000 (UTC)
X-FDA: 85169409024.26.F1D5CA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E349F160014
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:49:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cGw/2Eja";
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788367791;
	b=mY0zQn0s0bdN7nf0xCXpSnkpHh+CDmThE/nlU+Tgojbowa8Qs274VrOqsBpCRopsh3QCV+
	wMUcbhrkkOttl3t9NNZ6lPwxJ23RAJyoF/hXhZW5ZB0ZUJtt+AA1WsCgcCbGFTfXP+TelT
	dWm+ceVeaTZmT5JWZCIJbk/+cVj4FkI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cGw/2Eja";
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788367791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dn0iOvv1GVRWETQs2SDcxWNO+0sddiy1Vm8m6bHlbc=;
	b=lBiYfaH3TAn1jJ/bKZD4ZKIWkiBDtZzPkr+SKt8CWdisNFPkcn4PMIyq65gxlCCo1OCR4k
	8CjMyVa73+PDsu8aS1UIs67GpuJ83s67YE1zy8FhimUFaYMgm+KbmrY0/Rtbv0xOKcDJwW
	4QlHuEUsbIaECkE4BOLfRVpNkq/7hZo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 046CB42E17;
	Wed,  2 Sep 2026 16:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA241F000E9;
	Wed,  2 Sep 2026 16:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788367789;
	bh=8dn0iOvv1GVRWETQs2SDcxWNO+0sddiy1Vm8m6bHlbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cGw/2Eja2ZXVKjPcg3P+V6xH2JPYwXkfhwNVQCowY7r3PY8C1yjuggvjE0EZY3RMB
	 ByIHlI4AiLVUoc2AWMOxd7zbfjhNMBJD0auPk2Qal4dcDC9t8l8AQupaOyIo8LogOF
	 C8WlorVwY5bD9H7SvW6vMk5DwFTJOk2Dhx9zcBvSIrN3K3PdYqcISmdxdnakOkLVDn
	 C4N6cKaPjoHOljzl8DOTpItlzu0SJOnu4d8SbSILrPUtDSyPMo5K6TFkSEYMpHvQrJ
	 u/zo7rE2z7lfskjO4kDH+/4wkZhXr1J30e7DyqZ6uLaPNfVPYTNXDWIrqhuIYEVV9P
	 JQzuw8EGDvyQQ==
Date: Wed, 2 Sep 2026 16:49:48 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Charan Teja Kalla <quic_charante@quicinc.com>, 
	Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, 
	david@redhat.com, vbabka@suse.cz, hannes@cmpxchg.org, quic_pkondeti@quicinc.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/3] mm: page_alloc: drain pcp lists before oom kill
Message-ID: <aphSYFTd12oia8K2@google.com>
References: <cover.1699104759.git.quic_charante@quicinc.com>
 <a8e16f7eb295e1843f8edaa1ae1c68325c54c896.1699104759.git.quic_charante@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e16f7eb295e1843f8edaa1ae1c68325c54c896.1699104759.git.quic_charante@quicinc.com>
X-Rspam-User: 
X-Stat-Signature: mbcmwocx638zjmf3qwitor8jexio59je
X-Rspamd-Queue-Id: E349F160014
X-Rspamd-Server: rspam06
X-HE-Tag: 1788367790-188397
X-HE-Meta: U2FsdGVkX1+mm9rGO02fvP1m0yxshoED4peMmg32/mUaXp5REykHlgRgj0VHDF+vPQCjeibdkbracKDi2ONodrW6Cvx06XIK3eAQdMDhZvR9D59GlvwslOJ3d0IP4uldrerRrtjeQGVCEjQGBjmfDwzrZyNHEAZC/jOXlPDMmK/RcQn4I61T6x6MVYccx+lZcGj5akgk/Mn8gs0x+N66en8fV7nvzRy5W85fBRe+NSSYFoWiEUIJrhPE+LVCX4P0J0RDVbaxE3LVg1NLQXcsR+i+PewPJYdFRXJPeYBWN2wXA602do+0lAUw+ZHevZ7fMvxGMZlfuG5SZ4olZxK3BHhiV3/Y9P+7STEGI5sFIOamezuI5h2b8NDCYu1qxbZfPMTh+/XcOJsKYz+GFikaL4vdSekadIgBSVoe7Xa0dGqtdcdUZhnaXPnT7H1w1RSvzso5nm2S/uaS9OmmPHXGSuo0q88Ier1ohgi/xdKSx0IF8ogtZBCgK9cgnUsViSQEO/aC0NpVlrSWe2WwIn6+rOczLZyW46zd+T/lbfVQ5bqEzklRuZi4ptgPPQWVP/oCE2U/3MZGEbmyew+PQNY6Xu4+L/74KITSGT5kS7D3St3IH/YP0FkksixdaUKsnclciw32msXQPrxD5pqvJqNZL6tWgUJtMlRLlWTL+KyoShgk20Pn4VN/jnXo9eO8+78fW2XKvp8CpO98Erz7SWQzTxRssnOJHRxU90Z4gikLZ1VRE3NfEMgpTEAc8Cokz+d5PoVUrLPr8nAWsCZCnS7aYvFCc8pBuNwAS3STVMuKuqIXLGz7IL9e7YjKaY+Mhuv8Sqe2ZIzNNqN5rZqgQlm+DWxHGWuipggkwLKcNJjU6uuYb4jLckMsUJEOQDyjUvbLAWerWOaheEplNOuKEAscfgzej6urMuNuDituufLi6zQRsfbS5z0NcjpzTrHY7QcKIKB6lbfuF0amUH+jt7w
 LU3gGBru
 2oMZBpJemTkQqQ3Qoim+0xDeIjYvqagEMYw/000gLGI1vmf4/XHiLE1f4V0V0DeuXRVdUK4kOqV4c9p2vhL07//EXcNAJQWJZavB4PR6AgU3J34JXuunAKweSq5erpvsDG/BlUiLWLRW0H5AP1rgu1hTNqlOGW0rl9KV+gKReY3MnwjFRufIEZk95249Goi59/QztXnvlRCf1XqvtYrHZM+eRRyBfh93NU/TExXFrXJuZvZbQy+JonLhK4cGeUJEjZ+absNPxoJAyDNJVUiTs2SETdYTBLDacxogYmZIli0RVaQmEw3pQjkTPwRNkY6+2nCL9UHOsb93AuvoMxD6EDs9d6N+bXGrRnPC1ewgw0sMqARBGoUY4+4pl250fXsM2BE1VW+EDqJiiL0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 05, 2023 at 06:20:50PM +0530, Charan Teja Kalla wrote:
> pcp lists are drained from __alloc_pages_direct_reclaim(), only if some
> progress is made in the attempt.
> 
> struct page *__alloc_pages_direct_reclaim() {
>     .....
>    *did_some_progress = __perform_reclaim(gfp_mask, order, ac);
>    if (unlikely(!(*did_some_progress)))
>       goto out;
> retry:
>     page = get_page_from_freelist();
>     if (!page && !drained) {
>         drain_all_pages(NULL);
>         drained = true;
>         goto retry;
>     }
> out:
> }
> 
> After the above, allocation attempt can fallback to
> should_reclaim_retry() to decide reclaim retries. If it too return
> false, allocation request will simply fallback to oom kill path without
> even attempting the draining of the pcp pages that might help the
> allocation attempt to succeed.
> 
> VM system running with ~50MB of memory shown the below stats during OOM
> kill:
> Normal free:760kB boost:0kB min:768kB low:960kB high:1152kB
> reserved_highatomic:0KB managed:49152kB free_pcp:460kB
> 
> Though in such system state OOM kill is imminent, but the current kill
> could have been delayed if the pcp is drained as pcp + free is even
> above the high watermark.
> 
> Fix this missing drain of pcp list in should_reclaim_retry() along with
> unreserving the high atomic page blocks, like it is done in
> __alloc_pages_direct_reclaim().
> 
> Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>

[Sorry for thread necromancy]

Hi Charan,

Are you planning to respin this patch?

I know that Michal was questioning the need for it. While doing some
stress testing I came across a couple of OOM kills that had significant
amount of memory in pcplists. Something that would have been prevented
by this patch.

It's not something I can reproduce reliably and it is an artificial
workload, so not very concerning, but the patch seems like generally a
good idea and hopefully pretty harmless. It's also consistent with the
code in __alloc_pages_direct_reclaim().

For the record, we have been carrying it internally for a while and
there haven't been any issues AFAICT.

Michal, WDYT?

> ---
>  mm/page_alloc.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b91c99e..8eee292 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3857,8 +3857,10 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
>  		cond_resched();
>  out:
>  	/* Before OOM, exhaust highatomic_reserve */
> -	if (!ret)
> -		return unreserve_highatomic_pageblock(ac, true);
> +	if (!ret) {
> +		ret =  unreserve_highatomic_pageblock(ac, true);
> +		drain_all_pages(NULL);
> +	}
>  
>  	return ret;
>  }
> -- 
> 2.7.4
> 
> 

