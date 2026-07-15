Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEA58C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C23C46B00A2; Wed, 15 Jul 2026 10:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFA676B00A4; Wed, 15 Jul 2026 10:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AECA26B00A5; Wed, 15 Jul 2026 10:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C88D6B00A2
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:34:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6BD2C16012A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:54:53 +0000 (UTC)
X-FDA: 84990703266.30.1AD00EB
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4404040002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:54:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jagq1YVU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784112891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70Z5NezoUH2RJlJVI3JA/0j2Eg0rD+q2bAJ3zEsLrN4=;
	b=NvNvwCYc2yTYXLXBM7rDCY/kasLefPk+LHTBmlYL2kOplb5UJDGXTlSrv3kPocPzeIzFrX
	HeoWdojb5PrG+AexOhqwh4Rcsxqqe3+RO7GweiULt1E9N70B291xLREk6r5RtLOCOqjvSi
	5inRinOVqMM09nS9AQOb5CUPPpdBYBM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jagq1YVU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784112891;
	b=tGtobZGnmvCrB5XtnoGaoKrYr2BXYHdLAOCM+u/ijLnTE5xZ55KW0+pAqnEpjngszH/si0
	ABYWfTaz2OFiFO3BIaMqRmjDh4+EiSDo/3x9Jywl20PD+fP0B5hMkSjKHz97ILZuyHQuew
	w/6z1WhtDUZa9V9TfvwqlTg7WHuZ8Fk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784112889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=70Z5NezoUH2RJlJVI3JA/0j2Eg0rD+q2bAJ3zEsLrN4=;
	b=jagq1YVUsHNqTIL8gPgg0nmxCuxZois9P4j0k7ZR4PfYTYED1sfSvHB3lgfr7ExZl/gLno
	ZwjS4uegfSMlEUxhd1JHymHJkVuz5B8uB1I8HhOP+8Is8F3ZCeXJ+p8LntlYJbmcwg9YI5
	7zwIgenApe1eeKa49so47zudgDoBRdk=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	ljs@kernel.org,
	david@kernel.org,
	xu.xin16@zte.com.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	usamaarif642@gmail.com,
	yuzhao@google.com,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
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
Date: Wed, 15 Jul 2026 03:54:33 -0700
Message-ID: <20260715105440.2946210-1-usama.arif@linux.dev>
In-Reply-To: <CAA1CXcA84BtQZxOpE0sWgb2ed6y3m0NLKkWD+5MfWS9eF5dqTQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5ffee76mqzozx7ux4jbf1oh1to5httc1
X-Rspamd-Queue-Id: 4404040002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784112891-450851
X-HE-Meta: U2FsdGVkX1/OZMbhWmAjb51XzyjM8YqMYG2r2JoNqGU/Aedd12oVSvn6BK1XFycvDiBNt3s6PCW//fn2ApHLNpyLnX/ztG1o1Rv76//m4GlDxVH25T+S5jvucD6pgIHJTopkgSh67pY7FT0FJd80SPIoepI+tPbkVwJiGJ5xiIe4lIAUWP0AO2YDDM8XjZTgd9vxn0ggagxqv+8zsivGRwgastNyiBg5DUH6lha6MM1VNcRoMyO9pYNOVk281agUnkgBTf+yQ8Tx++zcYjCR2CaVhoNpfqg/dEklwHLpSsmJwx7Hm2kwS80QB+eVvMoj2u0sZTEnEweQ61g8QvvPn0eg7T9TOp692RFnDHlDyvNQA+W0/kaN/cuzwYat0BY1wP4sB7NWopwgnunjfuKwRbVTNPAibu1VriKhSBtOanb6To89YdykZeHfl8uK89vkfzzab/VtGhb40qgZdZnnd6AyoylqM7oBxrl7NywXt/m8qkBpAzcwBVlkT8UxwBXIJoBaKiMa6ovH4KLrq3QuHfkTvitHA/WEoFdbL9yHxkCEh9YCHGTixv/lyT6ekTPgSBUrShY+scvCQYlO53J5VlYrRbZ1hocKIOwSssU8uRy3+I1xbwtQgWvLn9F5d9g9fakKCcpPMZAB/mLVeLqHRcscqO3BN5NVcYGPtzsV3oxdmYtYHpqK6p69Aa5Jq2am5I0K/UVry4KqqJFbsmp5wnaGw4Be1Q4DEvFuqfYRmu/FP0YcJTkAumBdGDBjTYvUsDr7FSsJVT74zTgv+9/kHbrkDufImmABvgrprQho0A3YeXcEXn01iEusDlUuSUPQfvSpRaFHugXflRv4UirDSns5XP9BOX2IIlhiTRprhNErp1E7fJdoCRsrhqgXtdEyzN1m+cMNB+59jJsyfc5LY63kYePME9clKORxf1xK2VdN6zFNB5m9D2b3Nk/bjaErTu5t1m9gaJ3HudSC5n7
 UElA9+4Y
 qEwIQgnLMVGHE5cDjRotBRHqFSBbz9lhwesNaThjfaR2bicp7mDi5aviA/wE9SaoXnOudQcdWHffReuCMbEq8UJ8GalsZWFDi53nDUxs/ImPP7kCl4eq1beuVdn9uPrFlUJJ3u0Ou3L+DRlEl/bs/bAAt8/yYJugCacpJOLXUjiXJBrPpJqQwTimSe6wc5PcQ8ONccxXhzoJZoqaPibRYZXUNnt3ohI43sp8R1PayjdVgpxhujjfufT949o7y+TRhnHsJ+XDEg/vRUACkoUEu1wp3yxdhlsNLXKpc6o6sHwErreGXSy6TBAGqQY/64knPYBFG61ZIbaJF88F/Q6gvY1wRLYSHKI9z55iTW0uFTqYK82+l7AFRzUVm6xT8XkuNStsA1bqbzqdhbVNSBZNNV45fWdP4DjEW6J4vxgpud/jeZI2BAWo8zgVOc8IBI2jKV7c0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 22:05:31 -0600 Nico Pache <npache@redhat.com> wrote:

> On Tue, Jun 9, 2026 at 11:27 AM Usama Arif <usama.arif@linux.dev> wrote:
> >
> > On Tue, 09 Jun 2026 10:07:20 -0400 Zi Yan <ziy@nvidia.com> wrote:
> >
> > > On 9 Jun 2026, at 9:47, xu.xin16@zte.com.cn wrote:
> > >
> > > >>>> Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
> > > >>>> when splitting isolated thp"), splitting an anonymous THP remaps all
> > > >>>> zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
> > > >>>> This flag is set unconditionally for every anonymous folio split,
> > > >>>> including splits triggered by KSM.
> > > >>>>
> > > >>>> When KSM is enabled with THP=always, this causes two regressions:
> > > >>>>
> > > >>>> 1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
> > > >>>>   split_huge_page(). The split remaps all 512 zero-filled subpages to
> > > >>>>   the shared zeropage at once, freeing the entire 2MB THP when KSM only
> > > >>>>   intended to process a single 4KB page. This bypasses KSM's
> > > >>>>   pages_to_scan rate limiting, causing ~1GB to be freed almost
> > > >>>>   instantly.
> > > >>>>
> > > >>>
> > > >>> Why do you see it as regressions?
> > > >>
> > > >> Since the zero-page remapping was introduced our test has shown the
> > > >> following behavior changes:
> > > >>
> > > >> With use_zero_pages=0, the merge rate drops from 60MB/s to ~6 MB/s
> > > >> even after raising pages_to_scan. The KSM merging is now much slower
> > > >> and CPU utilization has increased.
> > > >>
> > > >> With use_zero_pages=1, ~1 GB is freed almost instantly, and it no
> > > >> longer respects the pages_to_scan behavior.
> > > >>
> > > >> Even with just this patch (1 & 2) or the RFC linked in the cover
> > > >> letter, the issue no longer occurs.
> > > >
> > > > Understood. You're saying that the additional processing action in split_huge_page
> > > > (remap unused subpages to shared zeropage) increases the scanning cost of ksmd.
> > > >
> > > > However, I still wouldn't simply classify this as a performance regression,
> > > > because commit b1f202060afe increases memory savings through this action — so
> > > > it saves memory at the cost of additional CPU overhead.
> > > >
> > > > If you want to address the increased overhead on ksmd, I think we could add a
> > > > check for the shared zeropage in cmp_and_merge_page, and skip merging when a
> > > > shared zeropage is detected.
> > > >
> > > >>>
> > > >>> AFAIU, KSM and THP do often conflict with each other. THP tries hard to collapse
> > > >>> a huge page (which may contain many zero pages). If KSM is enabled and part of
> > > >>> that huge page is mergeable, it can easily be split by KSM, rendering THP's
> > > >>> efforts futile.
> > > >>>
> > > >>> Therefore, in our actual production environment, we typically avoid making the
> > > >>> same region both KSM mergeable and THP always.
> > > >>
> > > >> THP=always is a global setting used in many production environments,
> > > >> so these features now interact very poorly together.
> > > >>
> > > >
> > > > Actually, I have long thought about submitting a patch: add a new interface
> > > > 'skip_huge_page' under KSM's sysfs, allowing users to choose not to split huge pages.
> 
> This would be a good intermediate solution while allowing backward
> compatibility.
> 
> > >
> > > Just think out loud. Or just skip huge pages all the time unless memory pressure
> > > is present. Basically treat KSM as a way of reducing memory pressure by merging
> > > pages.
> 
> Hmm interesting. We should decide on future changes before committing
> to one direction; however, i think the immediate solution would be
> what I currently have prepped for v2.
> 
> My v2 follows my RFC alternative approach: skip zeropage remapping if
> the split comes from KSM. It also contains the patch (3) from this
> version, which skips zeropage remapping if the shrinker is disabled.
> 
> >
> > I do agree with this. I questioned about if it even makes sense to split THP
> > with KSM in RFC (https://lore.kernel.org/all/20260510114001.600681-1-usama.arif@linux.dev/)
> 
> This is indeed a good question but I don't know the right solution.
> 
> Perhaps we can discuss it here.
> 
> So far here are the potential solutions:
> a) skip zeropage remapping if the split comes from KSM
> b) skip zeropage remapping completely if the shrinker is disabled
> c) Disable KSM THP splitting completely
> d) add a skip_huge_page sysfs toggle
> e) only scan THPs when memory pressure is present
> 
> (a)+(b) would be my V2 which I can send out whenever.
> 
> (c) is the nuclear option, but perhaps KSM for THP is rather
> inefficient and pointless

I really like and want (c), but I know David has already pointed out
that there might be someone already deploying and expecting this.

> 
> (d) could be used with (a) and (b) and allows more flexibility than (c)
> 
> (e) is a more dynamic approach, and could be combined with (b) and (d)
> 

(e) sounds like a good idea, but then KSM effectively becomes a THP shrinker?

> Let me know what you think :)
> -- Nico
> 
> >
> >
> > >
> > > Best Regards,
> > > Yan, Zi
> > >
> >
> 
> 

