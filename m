Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA0D0C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 13:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3BA86B0088; Tue, 15 Sep 2026 09:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEEF26B0092; Tue, 15 Sep 2026 09:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB466B0095; Tue, 15 Sep 2026 09:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B5BF6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:52:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B12831C24E3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:52:21 +0000 (UTC)
X-FDA: 85216136082.19.37575D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id AE5E740009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:52:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=it4mEL39;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789480339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5JZvciHOubNz1++8I3c/2N9YUlCfXc/5f861xiy4ft0=;
	b=ddAJU6dJr+Bai+N7TqWPkaF/QvzW7j9TVC1g61TzwE4OifJuoJqHyRRB1lwje2ge+gGKX8
	8DQj0AfYl6RdAokL1ldvUbgFIHJaQaQGEddBbn1Sgp0ABPm0o9r5msYxhdrCPERLjZ50jW
	7PT2c69y8p4NvLp6JfZmgMVSIGxGHPw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=it4mEL39;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789480339;
	b=qn9PjbAIp1NoUHS05sk4c8xLbSBL+tc7CSDnJXaH14IK4CJCGw/AE7SDfUwwB3kooNJSPZ
	hP+8VQ8MKxNqEdQyZv+tHBtAOUfB6V4UKVwx3mAyVltY7dyYw2pL9cxntTEIXcniI33l+K
	ZRm/8ib58WQJ0OMEo6aU+ZGkKTuDBnw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D48CD43D8C;
	Tue, 15 Sep 2026 13:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0831F00893;
	Tue, 15 Sep 2026 13:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789480338;
	bh=5JZvciHOubNz1++8I3c/2N9YUlCfXc/5f861xiy4ft0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=it4mEL392VOylMtWKucJN1H/SF3DAnw0vMuOMuzOxgyrfVosMCtYFPEOzDYEmBrW2
	 W+hJM+/RR/gY7ErtRBZSwl+WlJhSXohUCn6o1XeZ5ycAVGIW3kJ6OjOCPHwu/L+pGK
	 3ewVonc7r4UoKGfvtY6i8NU2P25btpAx/REc/e00UQY7GKiqtjsugzZ0EDzQXqhGbx
	 DTQLHHJXWC7QgdC95T0OSpDwm2v9UDD/SPGVZgjCkxcnGnPS+6Bj6wVpNIvstFD8Uf
	 JqsdvI//38sC3gA3EB0fPBHDwi5qqkPzu8hm4b42Ytx76sVcEa8g/ceU/zcGffVBHK
	 0czi5YHXvhY1A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 20534198003A;
	Tue, 15 Sep 2026 09:52:13 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 15 Sep 2026 09:52:15 -0400
X-ME-Sender: <xms:jE2pahuaU0yPr89PNnwihMvtUDzatVBlf1o7bmhFX_fvdotrRxPNaw>
    <xme:jE2pasyD6rPQU-T7SmzLq9z7dbjbsLYjkbKjXrtQhdyq-J4_MxeCC2WM7ITBa4AqI
    FODCsVl6oZ-jRmH8MiPOJhi-AazrWCFj-aOKBwuMtiU815RWzjoBZhDkA>
X-ME-Received: <xmr:jE2pajfDJtIrKyv_BSRFJVrRzGMsmE7J7J3okImqThKeGQ6jl3GvpHylMds>
X-ME-Proxy-Cause: dmFkZTGFaXHpQBoGzjJpzXuLzZEpEDoJVlEK8qfTCGlpZSscY902ocbS+NTIbNE8tMLKHV
    Kw+V8ruiMZ5vcsUwLmFvicjQ5fT2dEGX6BR2ofYNuwhWcszZXWDOzUPFZV9Kf2hTY0XyYu
    jgPRsVUGCvAoUBVHrbjcyoU/B85MGHEOvmNw+eGSCdPHSF+WLKvCB+LRHaJjwhCDtr3onu
    9t7U2m3RKVIfG63unn994NKXoenEEAMJlO4Bca8sh/2dGdJkRJfrRO11fJi78OFB2d6mXQ
    f6/BbV5VWGgDSXWO0Q4c80Vk7TllbENgzRJLLQpIDfQ0PD5mAXpy4gZfEHx7Mr9L/IT0K6
    qh4TshP2kn6kCNLC26NFy23vTdqmsw8g3megqLyVsGqfTaooE+RYvVeuOIYZy7Gn/syAK/
    mNQESXCErDbA14ZJWZl10saMPTrc6xf8XeOzvS/LSSWkGC977QeRJhhixrzJbfu+n81g9e
    1UH9yXgjzdTmINJ0W1c/2l/8tsZ5SsrH+DBIDUf7x1iNg5JRg4E76mGNLhLbU0PpzmXwuz
    fxsbi5T4JDhLZVv7EnZRfeABl7Tvmoe5VcDJ5trMTr/Py6Jb0oHqYqPMt54lsK/cZ45fqp
    eYKlOCmUSIfa9v0foUvG1fSeSBnE2eyER4tyPwmWpyxheKzoGzIAZR2ZhruA
X-ME-Proxy: <xmx:jE2palKexW_56iZGYRl_E5d3Cu6P3XzpWFLsyln1PPKWwAz8EhzrtQ>
    <xmx:jE2pavkxi9ChIIU-0-VW8D515yeU6YlXXf4pRnSrH_EjKz4cAJAgkQ>
    <xmx:jE2pagWthQlpbluzBQjzPidj4ZNuzeY1gW-HZYMmAX7jFVQ98KShdw>
    <xmx:jE2pahs_bggCtIocE9mX-k2TRJSv5vXt2OxUFTUW0cPEs59A6Q52Ew>
    <xmx:jE2pak0I-NiCjXIwieGMDtqxkNU6lajCAf3ySXrSuRVN2imtLk7w-USU>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Sep 2026 09:52:12 -0400 (EDT)
Date: Tue, 15 Sep 2026 14:52:11 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, usama.arif@linux.dev, ljs@kernel.org, surenb@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/huge_memory: fix pgtable withdrawal for huge zero
 PMDs
Message-ID: <aqlMvfIhr8nD9RHB@thinkstation>
References: <20260912234635.db50397364858aa15f58f4d7@linux-foundation.org>
 <20260913072312.52111-1-lance.yang@linux.dev>
 <aqfRCPheDYTgTdAk@thinkstation>
 <f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org>
 <20260914111940.f7e2c72eac4a2df97a646793@linux-foundation.org>
 <30bcc70c-be07-4237-9bb1-554aa5b5c5c2@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30bcc70c-be07-4237-9bb1-554aa5b5c5c2@linux.dev>
X-Rspam-User: 
X-Stat-Signature: neeqbfc6ca45ua4875uhz7dbfnezr9wx
X-Rspamd-Queue-Id: AE5E740009
X-Rspamd-Server: rspam07
X-HE-Tag: 1789480339-608337
X-HE-Meta: U2FsdGVkX1++KD5C7dCqsA/SZlxE6S20yfbjVcbnriAJpqgNJ7++ePaZuyNsxe4ZizX4uUMKd8VBRk9ZhQVBQgu3Wcq4Guuww2kw60LGC6HcL4DM+/7mkyQe0w2YENIFEBnzeB0nMxTaCNjFP2sqLzUQw7DGmkQoviDcL0AqQzlr5/eLZN0mORz3XtgI6hV8hhVEsW7rdVMK5LlKfDQ3XXXsgGY+cR8KVqK/yZLteUYWuIYmUPzNAYgOnMGue1DaDYXxV79dSVy3aXe0ZrbgOUZ5HLhtU/q5hJkEzKKRPgTXr9TfL9u/euWPf9MOQGLu2VhIjx+9KJy2/NTUnHVOW5/yQMKtvmKfYMtlW7zKueZmpJaQ92TwExgW/WqL/0nYdimE8SLMQuOg7WdEBuQtbFYriWz4uszyMktODFDCwqxzUy2fnkCISOgN/L7M1Gr/qXtCrU/d4EyChx7dvTIDhgIJacXWxoX83+SyWe96/qTQ5X0NqT3QTrPAzPvKlL294toNJNlxOy4vyIrHlmgHUINrhrSgXGpurod+5qsgLsWRm7TtRCwLccoIHi5xykUa2gUZNBewsyhJ94evRfLsCgr1gFJgnnTSLdJQVbPW4GvQqLO4bwiKH+7Qnl+b+xR/nJnIfNgoPJ5TdTY98uyW6Aq7Q++/OwucBSzNw42i6Y9WByeslrSAiQEzgHE2WvBLHr1xSMiiD05n4MSOSqkfgxMqliJGOftFjpNvPKpBQFhHMDwRABlFHPqSjUkP3Ekt/KTuVWcEgflNmUlIsesZo+hYRUOeumn373GY1iP1zWFONGJPKnGX8XIil8t+x4HG/36hbA9sSTDmMFwcFfVb9U0pa4ZsCfQoC+afV1v+XqBsHfspw6vitlVS+68My/BNpI8/ebThIlp4+i6wh0UYluFv1AoOoVoxkBPID4RfzKsqNZrT8D/YNchVZvGp3Wl8iFS+Q4hB3PFv+LR8+qn
 gS20sI6B
 Iu9Wb7ZWrFvfzhvPLdXu2APy3Fon07x7157GxtxbB/g6mlxEPMvQjyHuhKQ9VxC/PaD2FBfTXp5+bIxEZfm8e4aVfaSzISp0b2nyfb5/gZkc+OQmJ6FKbsyw+mLgbSmRrJzwC0Cu/OfvtiA3UMnSgvAY/9mXdfdfTZ3mIiFw58jFL1lxgUuUuPnduCJGdsghOI/UlOffhYT0+a2Lkb70ay0BiFq9kmDnpSnGrWvGvNlsfv08hDJmD8T9NpAHKE9sFGv8VqfUoUbQOnDC/a3kR80aGI1HZboiwqeibZQjndireW+xkyXCWDf9j61IG0Hztbl5SB58sQuzKJk32Rkm/jfbzM0ihHXFz/P06
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 09:43:15PM +0800, Lance Yang wrote:
> 
> 
> On 2026/9/15 02:19, Andrew Morton wrote:
> > On Mon, 14 Sep 2026 16:29:00 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> > 
> > > On 9/14/26 12:59, Kiryl Shutsemau wrote:
> > > > On Sun, Sep 13, 2026 at 03:23:12PM +0800, Lance Yang wrote:
> > > > > 
> > > > > On Sat, Sep 12, 2026 at 11:46:35PM -0700, Andrew Morton wrote:
> > > > > > 
> > > > > > 
> > > > > > That's the sort of thing we'd prefer to avoid.
> > > > > > 
> > > > > > 
> > > > > > How real is this?  Is there a reported-by:?  Do you have a reproducer?
> > > > > 
> > > > > Yes, I reproduced it on x86 with a small test module. It sets
> > > > > VM_MIXEDMAP | VM_HUGEPAGE and calls vmf_insert_pfn_pmd() with
> > > > > huge_zero_pfn, without touching the page tables directly. A full-PMD
> > > > > munmap() crashes before the split series[1] as well.
> > > > 
> > > > Ah. So there's no real bug upstream, right?
> > > 
> > > Matches my understanding.
> > 
> > Thanks.  I'll remove cc:stable, move this into mm-unstable as a
> > next-merge-window thing.
> 
> Sounds good to me, thanks, Andrew!
> 
> Kiryl, David, would you prefer the validation for raw-PFN mappings
> of the huge zero page as a separate follow-up, or should that
> validation replace this patch? wdyt

I think this patch can be useful for graceful recovery if we somehow ended up
with a zero page in a mapping where we shouldn't have one.

A separate patch with validation would be great.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

