Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42666C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40FC26B00F8; Mon, 17 Aug 2026 12:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1146B00FE; Mon, 17 Aug 2026 12:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D65E6B00FF; Mon, 17 Aug 2026 12:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0963D6B00F8
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:47:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 89DF11C19C2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:47:33 +0000 (UTC)
X-FDA: 85111342386.12.BB3E88F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E5C0B160008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:47:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZdwTlAlP;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786985251;
	b=YQX0hnbIxw6U+HSCMmwpJtCqtcfc85C2TFNS2qVmVdyGr1NBUjSsiAAqBVviItnqGWaJQ3
	CMt99bTfRpJG5CyK31xo0f6fWlJevVFMoX/DkiyT398l5prqs0p3vA9ktlwhepsXL9aOrb
	Xr8q8X5pDNFXPWjTHbakmKGNmH6eIwY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZdwTlAlP;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786985251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgz+IVMK9TQUnK1lY1PtvWGnfkBc7BrhZWmwgpK+RXc=;
	b=K9uoy99rHV7FBvragA3PpKW1jP6f0RSE5An5mIKYDntlQnHcEiSFgUVtS25ns3fGBt3mNt
	Po5HVwm2lV8yjJHN+CM7YtNS7drI6NN+BbD1noGv12j1mL0cabXf1nj4XE6lo7hsKceWuJ
	53YybDCFDNqZ+YIrk7gMsU0sDcEj63s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CFCA600AE;
	Mon, 17 Aug 2026 16:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4621F000E9;
	Mon, 17 Aug 2026 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786985251;
	bh=kgz+IVMK9TQUnK1lY1PtvWGnfkBc7BrhZWmwgpK+RXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZdwTlAlPQspxfYiSSXCPw/KUJfybyvow5Ao7DTHuhA4RVrXwz65khwE/C18iofQ/z
	 SgDtcuzmeuX6db8Zk6VWmYEzT8xAtFqt2R6dAFcY9am/hJfC1Mhf9TxDfj3ZL8VRHm
	 sj3sG+7z39Xmtadox0nUL2zGxgl6/L4u4l0F89imk/wf3W+QScEIW0Ss7eNbg8HIRE
	 foY7YSe8GXoT8xgy/vndNgRaKHel7S9iE1qnyQwC3V0CQRyIYaHkRlc2s+jZFdjZi4
	 jweq5TIvJDiUXw/wTp29X/ePvhnuumjbYz4HKdSJ1Ron8aHIXyl82pnRXX/rJ3ClYg
	 juZ3ImN8e2rxg==
Date: Mon, 17 Aug 2026 17:47:13 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
	Matthew Brost <matthew.brost@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: fixing sashiko failure to apply (was Re: [PATCH v5 00/16]
 mm/rmap: index MAP_PRIVATE file-backed folios by anonymous pgoff)
Message-ID: <aoM6-BhHcavcosov@lucifer>
References: <an7ewWbMwN20xklN@lucifer>
 <F700B4F3-2068-4DFD-975A-6324DAAB384F@linux.dev>
 <an9FhK3wSJHkEi3j@lucifer>
 <DKP5OL93OG64.3DAD063ZKEA9O@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DKP5OL93OG64.3DAD063ZKEA9O@nvidia.com>
X-Rspamd-Queue-Id: E5C0B160008
X-Rspam-User: 
X-Stat-Signature: nh8z7ojrdsfrw4x8r63x85t8rgctx7a6
X-Rspamd-Server: rspam06
X-HE-Tag: 1786985251-405642
X-HE-Meta: U2FsdGVkX18NxjqjFDMVXGXsC6Cc+ze6TJG645TLO8MQFrBH66M8xBfv8QJfijs/OGvEk4Cyae61+uNInHPyWDjUu2nA0Ilkm64pBlPFlKHi81DMm6VIZt0XZYIFLB9KeSQcpWyrykhMGVnsnmpgwbZqxpsWJ9G9doyM3/FZ7JwlT0maIwtj52SeHeg9aOUFYcBRGgwMM0ipERN8iu5WFXRTeo1RZq39QUkOG3E4cfyXEriHcDVtJPrKVFEvwKQU1k022SpSwy1GzQ89n8vSpdRTp/bZUz/jmHDQVjRfdcxhgjsNpRlxm0vgcAIkDhJCkhdt5kNE9FAt86zpvSHAhAXPaM++Su+KxhbaJNTAOl53DJs+/9Sa87PFQnb8NKySt4n83b1/1jJ6Kxx+QU9PxTYmp8Ny03v49+nsaA5m3kaBpDGRC3BpcXcanjro3pRo7HGiBw9R5GnfGQvJaFwneswQhglh5Kw3m/kO3phpLB5Ctxb/3/flyAE+k2EyjAQFLk3OMcmB3T9dextrQO5CBUmxH9Uv/X+g+oFtRNgpgII74DSHVZ4JUerUueCrr2FeyFlqbeBRbUI/3LAdbXQF+Vi+Uiq6Bg1d1NtS7f3tWrHxDy8uYzDme9nDismBuq5YEALR/bYZFF9x7jUlZ6ajW7zdJ0m4VDftO36HRRH/cXeZThvE2mgQ/yV8GrMmRWpt9j33ew04rPyA1Pkc+M284izq027F8GT9TifYsswKFnRzbOCfvuQiJvmvOKPHIdHKWGLMSnVUs/Kwmibz4UbGJBqoQeAsy978R0Iqbd36bNQLgmwgQHEaXvPlgI0Z+HaYOC84MbYwzcscQSu96ash0QT7SyFkFJVzcI3W8KxTaZpmCfMAmMNLoSa4qFUgnDLFZxr/J2GWdstf5oFjwPcB1rQFUHqxCmfytBumplBYnK0aytS0grVA13lg5rLK4fRlGihTpXEqZdkVP4zj5Gc
 QnWM3H/P
 7JmaqrrjEUNVwz4915QdRXhZOjkRQCleUBtg5dFoy4ITn+dU1WRQUWGhyf/ZAddc2Xy9jn2GEIbVF2Y1qvkClt8r/oqdP4HGnrJxEkrgmd2o6jEiIioAlhnThL9S3j5ica425Zm+pW+lekWLsKuVfEVI6FfqmxOEQGRiIdNGv/RJGoeLovKZ+xLuWbD0QZjPyNgNmszQ0z7M+P77Y0AdVfXgs3cCZxBaaNCZDwNMUX6Pmv8MfQPt8GhJ6taO7rOw25DvGbAxq9Bsu7fOSP9rxwYuzRDTkT173vWdRR6TjQaE3KzPEUEHSrCqqwdnec2cRroFE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 10:19:10PM -0400, Zi Yan wrote:
> <snip>
> >> >>
> >> >>>>
> >> >>>> Sashiko can be guided with a base-commit: tag but I'm not sure how to
> >> >>>> tell it what tree/branch to try, or even if that's necessary.  Perhaps
> >> >>>> someone can figure this out sometime.
> >> >>>
> >> >>> b4 gives a base commit, but I think because the trees are rebased it ends
> >> >>> up being the incorrect one.
> >> >>>
> >> >>> Not sure what the solution is!
> >> >>>
> >> >>
> >> >> We have seen this on the Xe list (our list is based on drm-tip),
> >> >> typically with cross-subsystem patches. Some cross-subsystem patches
> >> >> apply and run correctly, while others do not but public CI flows run
> >> >> based on drm-tip. I do not have a bisect or a clear understanding of
> >> >> what works and what doesn't, but I think it would be very useful if the
> >> >> community could better understand the root cause.
> >> >
> >> > As Mike said, mm-unstable/mm-new is heavily rebased and also carries the old
> >> > version of the series before the new one is applied, so it's super unclear what
> >> > the base commit should be there.
> >> >
> >> > But in general, I wonder if it's possible that we could tell sashiko
> >> > after-the-fact what base commit to look at once the series is in, or re-trigger
> >> > it somehow once it's in-tree?
> >> >
> >> > Roman - any suggestions on what we could do to help sashiko find things?
> >> >
> >> > (Once mm-next is in place everything with change again, but can address that
> >> > then :)
> >>
> >> I can implement any reasonable logic here, the problem is that my understanding is
> >> the current mm process is a bit vague here. Which likely will be also an issue for the mm ci.
> >> I’ll merge a support for b4-like dependencies specification soon.
> >
> > Yeah I suspect things might be tricky with mm given the rebases honestly.
> >
> >>
> >> Re re-starting with manual selection it’s on my todo list, but maybe a bit lfurther away, as it requires
> >> an authorization, etc.
> >
> > Yeah that's the fly in the ointment I guess for many things like giving instant
> > feedback on accuracy, well you want to make sure the person giving it is who you
> > think they are :)
> >
> > Probably an email -> author with magic link or something but thinking through
> > how to avoid abuse/spam/rate limiting everything etc. is surely all a pain :)
>
> If b4 is used, the cover letter comes with a fixed change-id. That can
> be a good id for new patch series replacement. For patches do not use
> b4, authors can add their own change-id. Without change-id, if the new
> version comes with a link to the prior version, that can be helpful too.
> If none is present, author email + patch title might be the last resort.
> But I think we need to encourage authors to provide some id for their
> patches to make replacement easier instead of spending too much effort
> on identifying different patch versions.

Agree, but with mm constantly rebasing these hashes become potentially less
useful :)

>
> --
> Best Regards,
> Yan, Zi
>

--
Cheers, Lorenzo

