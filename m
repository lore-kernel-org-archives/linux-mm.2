Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD7B8CD8CB9
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 17:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82F16B0005; Tue,  9 Jun 2026 13:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E33016B0088; Tue,  9 Jun 2026 13:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D48F26B008A; Tue,  9 Jun 2026 13:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C39126B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:27:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F8B3A060D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:27:37 +0000 (UTC)
X-FDA: 84861056154.16.2572327
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0C55812000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:27:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JRbBnebo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781026055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRCzUiE2hwh6Hqbc2UBSoVPwWk3hneuD42gLXpyxaT8=;
	b=4KVFIySSSJUqlRSaxlyvaI03bqRcZkiuna0X6uIU6Ci75TIq9p1xQeyOWvNzhEPMl5S30z
	BsNRbEhqwwcRZ2aD43t3NenfzruDUJjq9jLsHfXOv5oOjIjnkxeDROWETiNA4fpPDpVbm0
	YdxfqK94HJDqot3E3IENNztXQUR6Rrw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JRbBnebo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781026055;
	b=TCH/2ZHF1uJZW/3+ykH4FOvPolQPFPPV6wUBZVYJ14z0sKuLk/u78JDpdTUskjkm95FcTG
	6i6vKaCHOeq0OdL6o/khfPQ1C89/GIL1Q2r/zNfaO0U82HchDlBiC6zn9HBNS/12p5px1x
	/1dBhiaKsvj62bZZsQNSkDnD4LzLK/4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781026051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CRCzUiE2hwh6Hqbc2UBSoVPwWk3hneuD42gLXpyxaT8=;
	b=JRbBnebo77gJlbzFks5VoRzUf9dv8lQdMhZldAuKM9IeGTyIHsU+fGVCsMdWb0ezail2gx
	OlpKSgQSLB3yCuYdoHXI1CuMYIlCd0txR7DJHJ2+LcSPg09SIx4CruDT8mx8QYs0X/YBw6
	vZXg0NHk3qDJICYS6/5iKDCEdtPcak0=
From: Usama Arif <usama.arif@linux.dev>
To: Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	xu.xin16@zte.com.cn,
	npache@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	usamaarif642@gmail.com,
	yuzhao@google.com,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting from interacting with KSM
Date: Tue,  9 Jun 2026 10:27:15 -0700
Message-ID: <20260609172719.803537-1-usama.arif@linux.dev>
In-Reply-To: <18102ABA-0D8E-4DA0-AC30-544E34E445D5@nvidia.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0C55812000A
X-Rspam-User: 
X-Stat-Signature: pr8y8jh4fhoy747jzx8nmac49fi4inyq
X-Rspamd-Server: rspam09
X-HE-Tag: 1781026053-418448
X-HE-Meta: U2FsdGVkX1/4Ed/wUtisVgWJTG1GgIiG/6dwfJ5bJ5eA7sa02BjIU7ru0ppelFMer3SGxkQbBx0teCwq033040mx0IS/NogDt3xha5+WpxgncRM9oXUHmyarDmb8yCIpbZ7Ahu7EF1p3LVUANvOx1ZIO3g+mgkOWFChxrUIw26zxkMj+aPuaq63bxUcGHVLYK9YvbZLvtjvSNRB3O67M7NX0uWIfIemD1m61h5J9M/2i+hgX7+3lBCZr/kIoDhMKJfZFJzwIXctswKPxadqBx1v7nWBPJt5nutFL+Zx52U4J13y9z4uUcQ+7Xfgh2uknEgts9orkHfBtKYGywdYfOGYz8MPWTtuXgSJU4KnKFHUTzhIxunwWzg/bsNeAkd3cr9qARwrHijyp+zRzaEZtNcg9vrS+AiH4bFxWaQVix7rzjiz/LRZKyJn3LglQIgGBXtaD2fvgDCkuxfRMdoPiGSRHH+WdNnn35VTEck6gohYukMof93qP/rCllopR49UiQRmDeCwgQxC2SvXrlTxWQ1hakIU1Drum80O67LPRDDcVMGVymQ2SsKq3SVYuaCEcyOi0pmOMMWHuMNbiLzGbCFoR9aumbi02NH66P84Bvm353di6BpNUHJxzSoI63N1LWDxNcLwTA19tv8APJwVBV5wdSkYSkuHfw33lnNhqJCgE7zunNfdxVaPL52H00ZVmu9F4ydT8H2aHkAwBJ4vN/iyY5XVPmuNydsNfFXLP/5tkIYavWOmkrV4lmBtEP48qdltzWeqtGopnA6KqyQrgyRl/NPLVEBapAaQAr06QnoIJQiEC55meK3W5ZAHyJ4lMyclJ3OBVbeY/xTvba6tRZSkUIxdkXHTQU6yQBj3nGhj5YkpEczx3vL5NQBmVo4a9woLblqH3WmtBPPrryxn0u1R3ZlUV/238H0V1f17GjIJXQGHinPlcSHyXX2bc3AxJGVGMGjpx8Je2zZ56+Ap
 xPogxpM5
 26IZOq5lq/oVLMaMqbPWazAvG2dpSdghYWMH24DS0JRKFfUjVNP1sm1Lqo07YjXKfPEuE5Bw0f+xgNXcOPK7Sa8NKlXNRgmTwUIN78pb9C8iFLzpqJ/ku5ZjFDRAqHgS/9FonWHxOuUb5oFsVs3kRxeG3jwhxBm5zToVIbotHSbhzxI0hylXEIB0TnAPuPEk/jB2Rtg9KWOH7V1GfRs36Vi+0CL/O++vBot6zOlHXkbsinj0ZPwABIYIOMd+hslNXQp+HzZseE4gnsvL2qlYequoUOFTn3BAX/dZEM3lfxFA6Su8+w+WXvm3uXDoowo9lXk31wxcXOkR7uNZnpJlVfstRLTnWCSzOd/k15k6TsUKJ1pYe5wQmasROaLSQ7/lTj3kxBvAyFBDrd/CHAo6HmvmtZNNx+28QDtkw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 09 Jun 2026 10:07:20 -0400 Zi Yan <ziy@nvidia.com> wrote:

> On 9 Jun 2026, at 9:47, xu.xin16@zte.com.cn wrote:
> 
> >>>> Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
> >>>> when splitting isolated thp"), splitting an anonymous THP remaps all
> >>>> zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
> >>>> This flag is set unconditionally for every anonymous folio split,
> >>>> including splits triggered by KSM.
> >>>>
> >>>> When KSM is enabled with THP=always, this causes two regressions:
> >>>>
> >>>> 1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
> >>>>   split_huge_page(). The split remaps all 512 zero-filled subpages to
> >>>>   the shared zeropage at once, freeing the entire 2MB THP when KSM only
> >>>>   intended to process a single 4KB page. This bypasses KSM's
> >>>>   pages_to_scan rate limiting, causing ~1GB to be freed almost
> >>>>   instantly.
> >>>>
> >>>
> >>> Why do you see it as regressions?
> >>
> >> Since the zero-page remapping was introduced our test has shown the
> >> following behavior changes:
> >>
> >> With use_zero_pages=0, the merge rate drops from 60MB/s to ~6 MB/s
> >> even after raising pages_to_scan. The KSM merging is now much slower
> >> and CPU utilization has increased.
> >>
> >> With use_zero_pages=1, ~1 GB is freed almost instantly, and it no
> >> longer respects the pages_to_scan behavior.
> >>
> >> Even with just this patch (1 & 2) or the RFC linked in the cover
> >> letter, the issue no longer occurs.
> >
> > Understood. You're saying that the additional processing action in split_huge_page
> > (remap unused subpages to shared zeropage) increases the scanning cost of ksmd.
> >
> > However, I still wouldn't simply classify this as a performance regression,
> > because commit b1f202060afe increases memory savings through this action — so
> > it saves memory at the cost of additional CPU overhead.
> >
> > If you want to address the increased overhead on ksmd, I think we could add a
> > check for the shared zeropage in cmp_and_merge_page, and skip merging when a
> > shared zeropage is detected.
> >
> >>>
> >>> AFAIU, KSM and THP do often conflict with each other. THP tries hard to collapse
> >>> a huge page (which may contain many zero pages). If KSM is enabled and part of
> >>> that huge page is mergeable, it can easily be split by KSM, rendering THP's
> >>> efforts futile.
> >>>
> >>> Therefore, in our actual production environment, we typically avoid making the
> >>> same region both KSM mergeable and THP always.
> >>
> >> THP=always is a global setting used in many production environments,
> >> so these features now interact very poorly together.
> >>
> >
> > Actually, I have long thought about submitting a patch: add a new interface
> > 'skip_huge_page' under KSM's sysfs, allowing users to choose not to split huge pages.
> 
> Just think out loud. Or just skip huge pages all the time unless memory pressure
> is present. Basically treat KSM as a way of reducing memory pressure by merging
> pages.

I do agree with this. I questioned about if it even makes sense to split THP
with KSM in RFC (https://lore.kernel.org/all/20260510114001.600681-1-usama.arif@linux.dev/)


> 
> Best Regards,
> Yan, Zi
> 

