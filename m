Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E35C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7596B00A6; Wed,  1 Jul 2026 04:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FB16B00A8; Wed,  1 Jul 2026 04:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096EC6B00A9; Wed,  1 Jul 2026 04:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D792A6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:04:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 532DC402A3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:04:48 +0000 (UTC)
X-FDA: 84939471456.29.76F5336
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B351614000E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:04:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mV/b9bmH";
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782893086;
	b=WwIm/i0t7wK7BHxzRHUNQ8AO0JRASV3KXvTaNig/JbfwRSMwcK+qvrsNXjGuReJJnIRm65
	wT7zCAuzUniWpLXY0VI4ybprj/NlK+DxDQnLXSdYN5eRGht1zyHwHGFfJpmUMrAUoR2SiQ
	zn7n/41KXtX9PUR1XZH/yIWoFl1dOeg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782893086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BD1uqYg6aOus6UzpBzoWFf6c6yOuNtqvA/qB9gi/YIE=;
	b=w+CQu0UmsKrtUMPJRHlrqwfQbJ0G4h33N4U9O+1Vlok2ntGFTixcIesvKSThf8vcNNNZZ0
	R/ex+wqYwuKkqyXlQf2SyFVkhDr4tTfw7l+NFfseUd3ArLutDO/XDUmbCPYElYgy9RfV7M
	MsWi6lhFEOQTTyO0gnB9wHBa3Xy+AAg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mV/b9bmH";
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D9BDB438E5;
	Wed,  1 Jul 2026 08:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9B51F00A3A;
	Wed,  1 Jul 2026 08:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782893085;
	bh=BD1uqYg6aOus6UzpBzoWFf6c6yOuNtqvA/qB9gi/YIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mV/b9bmHgphleSddekMxNHCHtOGt1uNOteQLYlTEG61lSZh0aMJyTO8J0STaLybev
	 cLasn5JLPuMYFzlvUsl4aZg2+kkPH/IlEPlDi+tvpEwdmJWuv0zf+5y8ZvL1RpKNGc
	 X3KK3zxD6cjUmKNVm/3Xhrxufst7WpENUEb5WCVMjTEDxtY/yQsgZJkPfBSxzrF/Yq
	 18Tum2cpJeNXOLghMBcW89LyiGrRQvYyfZmgiBgLRG1fAEz3ivFA4OMQdf2Rpb0+pE
	 cjgIA0Vz93ACLoooaNeX14q+l1cZ8jxAlb6eNmlOUwNxJie4u35tmpPE/58scpVRMX
	 5j9hs9kZQH8hw==
Date: Wed, 1 Jul 2026 09:04:33 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usama.arif@linux.dev>, david@kernel.org, chrisl@kernel.org, 
	kasong@tencent.com, ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com, 
	Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, 
	baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com
Subject: Re: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
Message-ID: <akTJsCTKZ5hMBf5V@lucifer>
References: <20260630164143.1595669-1-usama.arif@linux.dev>
 <20260630125024.6c079ea708630d99708e26f6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630125024.6c079ea708630d99708e26f6@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: mkd719buqeaf54hg7ceajpb9f5k9j3oc
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B351614000E
X-HE-Tag: 1782893086-303363
X-HE-Meta: U2FsdGVkX19jVFmZMHQZjnwvwQ8i7ApuSb2nKjLOVifyRyVg4nyTU/TUofquP6PZvJmVkFXCRdASoTDHNOXcSbfKiZskWBGx825CBsF/ESGS7kbCK704ex6d5VofuoQy812ErDsEfV8jL07mywJsQ5uhbp+3ONSVBLYrQklIwQQAs9Nm+aP2l6qgCzGD9GxW2OneCZcnOgFyNwVwIcMVdBajmOizzSskOEUAYnLjKc8JXG/fS7JJ9L9xSRYNe/T9JmKJ6T6tpR8/rK8lphN421hx8jaiByBkWGbSfnI27izTgKgZgnsKa84emRMrO+0RmbE3hTEAXb0eStFKZp4T92BTtP6DrJCRm3CkA2LeXAuQV3UwcSNoeKwUyxRMmwR9kkZt7rzOPrC12iyg3trsm2wQk9eKlBniWRTd5FArAvpTaSkhZxMszXan5KqxA6+DTu85ub+ihW0ocSrSpXLIWGeNAs9V/WzPgU9uKmK+WSrdp2tcCtB1qWR1KbpCGHNdqpjN2hI1fjcCQCqVmGttqW6SdhuMsPa/7HoHaEZRmgGxoa9iYW47MzAvqFzttX+nS60Nk5gpjKnwLrd6B5WueQI0vUHHAl+IPoIlhIpUZfgz3neDFzr3veDcfVjQaov95TdhiqORDrLkeBMzFfmBXbU8n6yrv75+csx0c8gkfk/rHet2D8wLFDi6Jaj25xLS54p3MK0n9F+vdtkmZb5XmmeW4SnETZe75qWKxtMYRhU+UVxYXq39xFk6VK/fAPZcGgfUf29EPXlRgs0iqbbshq7/55SMEkp4cz4w0bPm7UWP9U7aM+EjBuFcjqk7wdm/181LQ6i3YCowsk6SH8UPC/Fq9Scobi8mtbVI3kzlhGectF3wlThDf2eO9TMYgDv5fFRlyo6lUbUZ/p8Ly3U7aMmHRt6HmckeK5RhtLaR/nmi05ZZD1aPespCOBenNRB9ACGHNqZIKJZjro413Df
 vJiFrxF0
 URvIIwWmgaKmyuU5BPXioxJhyAxXaz7GeoEOYueKwNqJqd6t7Ltmil+7l2igfwckjA4QaW/fGh0Gn1lLpkrLtR2tQqqxkb2615IkKuIPe/cshAQnFwlii4c4rXX+c9VD7Fif3+pgTUGaaUPxnd8PM63ukXWNfRkSusDWniJ7bsrmpQ0B6PUAZraZCcTbl3jNjgdHUylO7rPXyMV07sS0UMVHroiz/2o+BjEXb7V3QJC4JXZ8slAvi0maTDKVJM1iNPorp+B3cB++ZvbwxUiSXZRI2ochIq+XV/hwnImrYYa2yx9cd5dAo1OuVhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 12:50:24PM -0700, Andrew Morton wrote:
> On Tue, 30 Jun 2026 09:34:37 -0700 Usama Arif <usama.arif@linux.dev> wrote:
>
> > This is the preparatory part of the PMD page table swapin work.
>
> Thanks.
>
> This comes reasonably reviewed, so I'll queue it in mm-new.
>
> Why?
>
> - Human review coverage and AI review make me believe this isn't the
>   final version at all, but I do believe this is something we want in
>   7.2, and getting it under test early will help to push it along.
>
> - Getting it in there early means that others will base their work on
>   material which will probably be upstreamed this cycle, so this gives
>   them a more accurate base against which to work.
>
> Sashiko did find a lot to talk about, some of it pre-existing so can
> people who work on this code please take a look at
>
> 	https://sashiko.dev/#/patchset/20260630164143.1595669-1-usama.arif@linux.dev
>
>

Hm, my understanding was that mm-new is where we take everything submitted for
early testing?

Did something change?

Generally anything submitted early in the cycle is expected to land in the cycle
unless there's significant adverse review or other reasons it can't be taken.

Thanks, Lorenzo

