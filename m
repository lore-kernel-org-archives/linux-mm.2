Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A03C1CD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 11:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96AD26B008A; Fri, 19 Jun 2026 07:04:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940266B0092; Fri, 19 Jun 2026 07:04:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F2C6B0093; Fri, 19 Jun 2026 07:04:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4166B008A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 07:04:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E4FD8165A6C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:04:56 +0000 (UTC)
X-FDA: 84896379792.12.ABE09E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 51E9CC0002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:04:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGvyJq1l;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781867095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oahfa4mOTeBScg/vkMnuvaXcHN8g7hfrDjLC4oiuCJ8=;
	b=H0Duvvy2obH+Kr1OLC/JCEC9QP+NC3u/pje9TuWZ8aqDzlYTZxVOsjMxC8otiQGNjDtery
	cLaGkFyQtwgyj2y8fqKz5BVEwJrsoxHp87gsP2rIOqG758Bo1HOacORJDhj7MEXfOU6m+4
	WEkaJW8vSZnQyxdT59Zt9aDakRUVbU8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781867095;
	b=ZSrYvTuSo68ZBlGW9MNpO+BCM07xYY1rc/QpDNB0d97dnjQiTDCQn6cx6V2veHUqXV2vZe
	+P5uCjVqtuiMz9wS1b7pHNEsr/Cx2ZAHPWrREFDA1vENDEbgY+DWc+ZEs+YxxQ06uBzqXQ
	txQ082bzSPvkdG/CqzoZK/1NHrzpDzg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGvyJq1l;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6C4F601E1;
	Fri, 19 Jun 2026 11:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865A41F000E9;
	Fri, 19 Jun 2026 11:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781867094;
	bh=Oahfa4mOTeBScg/vkMnuvaXcHN8g7hfrDjLC4oiuCJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NGvyJq1lThI1Hi53i6iHDf/UepbC9nbNUHUO01BCqbxMv3aLFKYqmAgJU5PzpbDnh
	 PqVVBFc1iprgtuXq/mZF4JwIz0z1sx5X1VWM+Gtq944f+us7zJo6WVNXeJrVz3EQVp
	 q/RMfbgBPTOVM5JxMWUni/N8jkaynXAIHs/1q5vwX24fHS7JLcCSAnFBut31Y5LPsk
	 /Lefw6QMa3/OHsspld4dy4AuwwEDnL2LiwZ3+KZJbDfd6N08M76yHuMxYQJSXxxFYG
	 Htvdpx3cbXgYlVC4UVyvI5OmYpQiOoAgBMyXeIQOavS+HVIdqb3Au74vNbBCZIMYdq
	 XxMrlW/YWFTnw==
Date: Fri, 19 Jun 2026 12:04:47 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org, 
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, 
	jannh@google.com, balbirs@nvidia.com, ziy@nvidia.com, sj@kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [Patch v2] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <ajUiEs3ZzbgJc0v2@lucifer>
References: <20260616063436.20455-1-richard.weiyang@gmail.com>
 <ajUXNjRMraKb6k2n@lucifer>
 <5e7f7fe5-221a-4fca-aa76-297ae19eb80d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e7f7fe5-221a-4fca-aa76-297ae19eb80d@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 51E9CC0002
X-Rspam-User: 
X-Stat-Signature: xdg9iczawz65r93o3mruopwmb13o617y
X-HE-Tag: 1781867095-808086
X-HE-Meta: U2FsdGVkX1/Ri1ofhvuXrBW2qnAL1qNiKWY+5BMJyTNiZVDn+r8ODx4GUTffOJ2RgojFiUYVeAuHyYIamWI1Fjgy93CqGcEDOOweYnn1e2r5Jf92AQ1k1dsLWdO6kCAyhXs1YoORuV8XtN9WjHHQM1icf/rDa4IJMQiAKVF6HGyaVWAftjfZCSB5+4GsN1l8MzNOsbwDUgJEQL4lezVdsYOyjrmjd3YuwP42vErUNUfP283mzyOKBhIxS/Lz/S71h3M24bjqcn/STvXmzF5oPH0ERvYnhCq8inoxF1D4z7CtgFUyt2S1h3wz6idQSwCEf12Wqq8O9pe3pNnvQBpNWh3TWLK49Pmdd4NyTXaWQmHn/fgq6hS+o1KjeUUhO7d3BY+fqFLyVDvHgksIkK8GYoJ+v4Ydyt9icov7o1tukrI/9VYchYIDWybB/bth5GG59U6ox4WO+UoyA8Nxw3xKE3bW2Ldfj476XyeveDSkCyoS6ORPb0x7Zw6uPFrGU+sLhov9T/iF2AiXTiaj0l27Kuhxpv6psXjJYppTBt6FMzthv3fFqj5AG8qR+y4RBMzErEYxSXulz9YKCaH1hdF4vBeKLqoJWZgl7HHVnivBDtgWhfjEvZT2v/CGlUdW9dvHaqiT+ihco1TC+hu4pSCewkCx5tfoJUY1HkI9AuzrE//Ad+2QGkgW2iV9jg08LQTXweEp/ISyG+tBuF+EZCYnsV5VHeP1E9MKFvGaPQpqu58jXVf6T4WLR8lM99w0TxBQoIf6VoMmieaG/ir3lpYpSuuSwlprPX0iJ5XcxLQ0JyC+8M+xnCUTg6g4tPoKgw5FQTZO/OpUxWnri5tDileJMfIvDEtMfOJ4agtJbMcuRt0WKvFEgtZ+O5FoXjmM02KimHMdxKk9aW+HfW5SGlWe05nfqXbawIRZuE2QpTcGyKQ5kcpKzk1tprLsN2T1o5sRsftO26ouFe6yCeqrwm8
 XQh9CxdJ
 P+pG2h+00EgSOy/8wfD547Q6odutVCkxlMb70G1VYC2VgHdJtBOmNZyNstczb7HVvgln7RpSzihC2f5ZeS1Ry6HvuJS+ATTQfcK462PAgQO7C343SqYxq2lPlpbs0wNNaqCzh/8fY6boqRfyHMJNm8KLtcfx1yQqCQEAmV1TwK9NaBmQuyQU/fPAhckz7n9BliwAWYi1rzgjDOdc/KogcNOCUkIZI05fLOSe0HTp3iKtcHzlzyCWZNUk3YA+xmLbm5c9/YYROTsnPWSCmZTCLymZdS2AuxUaAKU+55J007f5eO4HvD8gMKbBNl0qdOakb8VI1KVZV4KVsll0ONEZzep9pKw/e2UI/G9Pj3uoOXbt/LSUtH50RsZXpHTSX4pu2EGmKdhp7LuRTRGGm2HA490OjRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 12:48:26PM +0200, David Hildenbrand (Arm) wrote:
> On 6/19/26 12:44, Lorenzo Stoakes wrote:
> > -cc wrong email
> >
> > On Tue, Jun 16, 2026 at 06:34:36AM +0000, Wei Yang wrote:
> >> For pmd_trans_huge() and pmd_is_migration_entry(), we does following
> >> before return the pmd entry:
> >>
> >>   * re-validate pmd entry after PTL
> >>   * check PVMW_MIGRATION
> >>   * check_pmd()
> >>   * handle on pte level if split under us
> >>
> >> But for device-private pmd, we just return after pmd_lock().
> >>
> >> This may return improper entry, e.g. if we are looking for a migration
> >> entry, device-private entry could still be returned, which leads to data
> >> corruption.
> >
> > I don't thik this is quite clear?
> >
> > How about:
> >
> > 	If a softleaf entry is present, the existing code simply acquires the
> > 	PMD lock and returns success even if PVMW_MIGRATION is set (indicating a
> > 	migration entry is sought), meaning that the caller can incorrectly
> > 	interpret the entry as something it is not, causing data corruption.
> >
> >>
> >> This patch fixes commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
> >> support device-private entries") by following the same pattern as
> >> pmd_trans_huge() and pmd_is_migration_entry() for device private entry.
> >>
> >> While at it, it cleanups the pmd entry handling in page_vma_mapped_walk().
> >>
> >>   * Instead of handling trans huge/migration entry/device private entry
> >>     in a mixed manner, we put each case into its own if condition and
> >>     handle with the same pattern.
> >>   * Also we grab PTL and make sure pmd is not changed under us after
> >>     above check instead of do the check with PTL hold.
> >>   * restart the process if pmd is changed under us
> >
> > You're doing quite a bit for a fix and you're putting it all in one place.
> >
> > How about do the fix as 1 patch, and then cleanups as other ones? It helps with
> > review too :)
> >
> > It's a general rule of thumb that if you do more than one of moving, refactoring
> > or changing code, to do them as separate patches so a reviewer/somebody
> > bisecting can clearly separate each.
> >
> > Also PLEASE do not add new functionality (this lock recheck) in a fixes
> > patch. We'll end up backporting new logic that way.
> >
> > Make the fixes bit _minimal_.
>
> To be fair, I asked for this
>
> https://lore.kernel.org/all/2d48ef0d-1110-4a9d-adcb-f701a1ce2cfa@kernel.org/
>
> But given that Wei mostly used my quick draft without properly checking the
> implications, yeah, let's fix it first separately.

Ack yeah sorry I mean I agree that it needs cleanup just has to be done in the
right way which clearly I think we agree on :)

>
> I can then follow up with a proper cleanup.

Thanks!

>
> >
> > I think in general Andrew prefers separate fixes patches so I'd just make the
> > _minimal_ change that fixes this for the backport, and the cleanup stuff as a
> > separate series.
> >
>
> The issue is that the existing handling is just crap, and to fix it, we're
> adding more crap. But yeah, let's add more crap first before we clean it up
> properly.

I couldn't agree more and to be clear - I hate how this is right now.

But I think for the fix we have to wade in the crap first then clean it up
afterwards... :)

>
>
> --
> Cheers,
>
> David

Cheers, Lorenzo

