Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9375FFD45FF
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 01:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00026B0088; Wed, 25 Feb 2026 20:33:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE3B6B0099; Wed, 25 Feb 2026 20:33:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14516B009B; Wed, 25 Feb 2026 20:33:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE15D6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:33:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 67FE51C5D3
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:33:02 +0000 (UTC)
X-FDA: 84484884204.08.B22CC26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CA395180006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:33:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jYkt5C4P;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772069580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6EGQLiMGLNgLTwJzR9ZXHxtyEjIbgzNuXEIsz3biw0=;
	b=qoHRtuvIgiTktPs3/taaZAGdCiBkV7ZOP9WPu8AbtAlv52HMMD1c9ObpMu2QRmvTHSLKf+
	TCZRIx+qV1HkUHa1KHKQHDUsXGni2TBr/phZL2dp+im6pxKGDkM5lTEfYMf+kznRu4IltE
	7gUz/Qg37cuNjvQKk4otiZSYT152USM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772069580; a=rsa-sha256;
	cv=none;
	b=qrYfiNRPwBjEhT+HjCEVPkR73MRTpxlIziVxWqSpIJ2kvbAPmOLGq9/zmpxD4PZlXJosg9
	0zw+EH0WmtzG/kEfF2Vs8B+h1GPGh3hlm4yDnRuQUpDcguSIT6R9pZUiuT8RIlauyQvua7
	VaTn+qTUL6amkR/LvAYL9l+SiujlIyU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jYkt5C4P;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 47BF360053;
	Thu, 26 Feb 2026 01:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB1EC116D0;
	Thu, 26 Feb 2026 01:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772069580;
	bh=jz5yjUjM/f+IZwWRIgyYptE1sl+VBHPa3luymxuES4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYkt5C4Pb2PTBmn20lPNS6ETyWWb4ivEIHjhGZl4xP1EcLCSnVaSadSTPdl4n8Zg0
	 RSsHdOYrMQRtOnMrsw/EDzN2XimpO5klwpSVhT/30jZs1eH9wjd673GwAhTOPUz0LD
	 pQwiRxXp2CntgV3ii5HkCXyx9X/r9NGG2qB3iEvzvsCxohgIN13gk7ytRXtyb43x6f
	 lJpMDxjVyTTI5fGKRL+OSZk9F2t6rQccbWLmOPPor3YHP4gRkeeaBpKJKW/cpPGupW
	 a3JhsUJPbRh3ewmE8lzGwv6EBA+mx9kq129CMQs98jvs99dtmmTFWhwAaIEpjrSSpU
	 AqJ60K8UAX7BA==
From: SeongJae Park <sj@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ron Economos <re@w6rz.net>
Subject: Re: [PATCH v2] mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
Date: Wed, 25 Feb 2026 17:32:57 -0800
Message-ID: <20260226013258.8490-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <7AAE3B00-627F-4F40-A383-7F5FDCBAC8F5@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wgeh7sj3x1mg45du8tt5emdf36hxygwi
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CA395180006
X-HE-Tag: 1772069580-691020
X-HE-Meta: U2FsdGVkX18V2tG/PYqiZvNPtF+bwnZaM6SjafuxeFwcXwwTOF4aqJyDGZfDWpa9f4yEJTZV6NbpjtMBk3W9NK6BW3jJTqpIVeYXCeVqsvEbOvoe3RJNm2TyzOuNluO3T023TzgtX4TiQ9aM3cvIHIGMyaCrERAVw1lrhXfiag09lK8T+0S5k9zLV2wCmNF2eI9a7xLvnXqf4HtmRWDLHZhU+HiXjsnE18VKFZqpfJKFJ3T0zmQOKJTnMArLO5nSsjaU6zxANRfQVqIxoP0UZmGy98/3pb9ArNy8bTLGVZlp6C3PD9sOzKrsu6+26szUL+KrMaGPUNQbiPPAyuDLWz/NkjoGZ3TMFpW//4mRHxRCoMIVWRsyAdK6BELlYQg26ZDxnmXR4YF277ZI7rvk5S3pNspBmPvAPrG8aIdVa9De6Ia9d5ULpgLbmyReyyqbY6eKl+BpDQXcwDxaUIHGlcVmFfajkOT6Y9HakznNzUDAepr9lsJvDF07Tnd7GxgnGwhuER5nEmrpSkCP1+Bww772LlW67mOSmlbt96vJKCMm3iZWuYAfk3gsT3+j/rvOCGcKTSC7JRpHBION88Jb37e9KoXfRfbVWXGgAPpyyOJA4lXVq9RpC0wrsJWoDbtYjmpYEOAIDt+HlxJPLVVsBXQFdm9F1h5YZ5LfJhWaLjZQLueLVTpRchvqGi1+d+Atl8kYzL46g4HdwT3iFBOM9s9DCnnz0ZZENLGlEW4Li8DaW+1F1vl/7SXvuleLMfIdFAivLykDsptFhUECev1ZN3jBYn7zWVcXAbhjbTxJW4n2UeqfYQn11nRXdFZkkTXk79wxrOq+k8BbMWnWXF42BnwaiFniw3TZOgHNQhQ2VVTptnIOEMsHlVkX0X8foTdGJg+WPX6nsD4z4FtUeUQaIfYGzxhXe9DGPz1QLcN4OQXe7UzRnvKlFp+buJCfFOTdC4i0eR9aTt6P4dKxuIH
 j9yan+Vj
 pNaP5khVQcaHg1vjMpYZWaFUEO3aldDxvm1ZWBgrh62B7TM0eAl1fEougaVbYb0/ds8jFmmdCDY9b1RCJiRVk8fXy0BogaYUa1WCojWrRnorNiNH+8v37B8T+afB7nA9VJdgxEM2ygrPSE7Ba00ck+d4OK1VMvQw30a1/apXHoBwoAhROUkF6pph+wIBOpeUZDAJkvk3YW4DtVhctDbuhzZqVhIYwrzBq9XlotJ+SE/82Rir82ORhs4SnOC4JAEYdZV8FG4gWWvg8w6PU12FfA0Brhg0dzb9fMQpu3KCpX6iNTM4FD08JHHVBq9nVQBYaSIf1BUqal6OwHmulehyDmhzzOIY9Y7dZjXZzd1Pr/ACcR0AFhqp4fv/Fb1P3ya+xnG4rKC4jEMhSS0+Y+FMpOUc+cPQKd4uKqPdASTIVsyQ0OF/u7ViqQuDl6C5O2KQCVH3q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Feb 2026 22:04:15 -0500 Zi Yan <ziy@nvidia.com> wrote:

> On 24 Feb 2026, at 21:54, SeongJae Park wrote:
> 
> > On Tue, 24 Feb 2026 21:28:52 -0500 Zi Yan <ziy@nvidia.com> wrote:
> >
> >> When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
> >> with side effect inside it is incorrect. Collect all put_page_testzero()
> >> results and check the sum using WARN instead after the loop.
> >>
> >> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> >> Reported-by: Ron Economos <re@w6rz.net>
> >> Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
> >> Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >> ---
> >>> From V1:
> >> - Collect all put_page_testzero() results and do a single WARN after the
> >>   loop.
> >>
> >>  mm/cma.c | 5 ++++-
> >>  1 file changed, 4 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/mm/cma.c b/mm/cma.c
> >> index 94b5da468a7d..ea540d3f473c 100644
> >> --- a/mm/cma.c
> >> +++ b/mm/cma.c
> >> @@ -1013,6 +1013,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
> >>  		 unsigned long count)
> >>  {
> >>  	struct cma_memrange *cmr;
> >> +	unsigned long ret = 0;
> >>  	unsigned long i, pfn;
> >>
> >>  	cmr = find_cma_memrange(cma, pages, count);
> >> @@ -1021,7 +1022,9 @@ bool cma_release(struct cma *cma, const struct page *pages,
> >>
> >>  	pfn = page_to_pfn(pages);
> >>  	for (i = 0; i < count; i++, pfn++)
> >> -		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
> >> +		ret += put_page_testzero(pfn_to_page(pfn));
> >
> > So, 'ret' will be incremented when put_page_testzero() returns 'true', right?
> > Shouldn't 'ret' be inceremented only when put_page_testzero() returns 'false'?
> 
> Good catch. Let me fix it. Thanks.
> 
> >
> >> +
> >> +	WARN(ret, "%lu pages are still in use!\n", ret);
> >
> > This will trigger the warning even if CONFIG_DEBUG_VM is unset.  I'm fine with
> > the changed behavior, but I'm curious if that is the real intention of this
> > revision.
> 
> It was in free_contig_range()[1], which was called by cma_release() before.

Makes sense, thank you for clarifying, Zi :)

> 
> [1] https://elixir.bootlin.com/linux/v6.19/source/mm/page_alloc.c#L7238


Thanks,
SJ

[...]

