Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C75CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 11:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27B98E0078; Fri, 24 Oct 2025 07:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD83E8E0042; Fri, 24 Oct 2025 07:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEEC98E0078; Fri, 24 Oct 2025 07:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A75A88E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:19:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48508893C8
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:19:58 +0000 (UTC)
X-FDA: 84032763276.12.B72EDAC
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf23.hostedemail.com (Postfix) with ESMTP id 705A9140007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:19:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=tOVtoHmj;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761304796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HVxnkzUz6NVdQcmcA5Gy6ABoyfmOd7q1+o6lDDzoT0=;
	b=LDruzr9nPZGrPGgk2nHrt8SEdH2XUefiktYIJC96i7zzUWRCJSXMKmPNUzv1h+1+LSNKhq
	TnbTkLVlvtMjNO+rOsFv+BveS2DYxJK/EF7NJW++DCTcCpbXU9KtHsSogqzLtrIjpCVO92
	Hy/75vQQ57Z814S1SiGpoA7na3PLLHc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761304796; a=rsa-sha256;
	cv=none;
	b=caqYdse4kWxSFVUp6tptQB9c9skHjEScj4KjABcEGzf41dRUJPZVolHoHd3tDboWxhvMx7
	Yecr6+soHyzCQKg8e0h5haxq3/1M0Z0IvQx6Jn6Wk/jF/O7fKBHZi76Z9ggyzqcB3lVGST
	XTDeN3CF3zJjYJNri+bCIOXeJrQB944=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=tOVtoHmj;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id AACC39AEA4;
	Fri, 24 Oct 2025 11:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1761304794;
	bh=4HVxnkzUz6NVdQcmcA5Gy6ABoyfmOd7q1+o6lDDzoT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=tOVtoHmjYUqKiQGeMmtZVdQo88liG/Y/9xwsGmFX5CXc/WTRyceTjnt0Q7ayTuVG7
	 M6nISb7ajgHNtLOaEjzN8Tdvc4vZltWvJ7/xI1+RHRBi/iH3MhY5uondOSXGSDPf4g
	 /Y8FJBtsIq5AqCO/OFnUv6M7OjGjNb79Dpq2GbEk=
Date: Fri, 24 Oct 2025 11:19:50 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: shmem/tmpfs hugepage defaults config choice
Message-ID: <aPtg1vUnpkaK1Ce5@shell.ilvokhin.com>
References: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
 <aPstDXRerYqi1O2X@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPstDXRerYqi1O2X@tiehlicka>
X-Rspamd-Server: rspam05
X-Stat-Signature: 8aqzstc8faqx8y8bt1pik58shkmqif73
X-Rspam-User: 
X-Rspamd-Queue-Id: 705A9140007
X-HE-Tag: 1761304796-390842
X-HE-Meta: U2FsdGVkX1/77MNOYqawRXTHBnT4Tw2vqFBhDzdsAqguaa2St02FEzAA59AEa2dJAeGaJYx2Prv5+2aWxndA9xei9H4giI0Ko2iHIpU2oCkXSptjhPgdsbYvN0BUd2xbQG7cKB2fmGuk9qgn8yEbgE879+0wsJst73yIAzK1+FB86WwmopY31vwy9aCoDx0huN83zLwITcPcdP5mR6MS1gZY6fBi2IoCixIcONcmsrymmT2zWc9lcVk0+eXum8+xEfI/74zbEkUlYuWCt/eWy4LPmTw6Fs7ZYt8ooRs7tr+uhd+OWt2mFzwGlc0ggLnD4S3TBgb9AAIkbNmx9giyTrzviI0Ih3+r0ohR9Snu4F0NIkaLzpv0Dif/g4k77TuPtZSNiCJSo0YpiOuP/uToWqYqEealsO/TVc3EHSDpexCc36A5PSHXPNCpvJ5BaUdUd37jycVP84MqYlYHWFlVlFrM5dC+Yv9DS9ag6qAcLikiFPAuz/3RQJBJ9pBRiR05PR3KyR82he9GmuosKxtDcu9KO5Xf4/vIEtInDII7Vtd06d3x82T/9oxBKI9QAXjnugkjTy9Hm5uai/HIf0VrZIaxgl4/T/Al1jVkU7o2oiDoVRYtaLSWF6hwXLC/Q5hJNBw4bfaNx8TMRFEGXM23HzCCdoDD6FcGa1dd1+X6ht+em7IJqGGfjwhYlhikSRuBzr14tNXysktJ7aywO7vbcGBvMuIobdMNBSvTO0V5oCYLtL5iW3jnrejSUmXWQcdvjoL+A+1mveku3IccsTY4wRPqfAUoFQLinXWWZFmX/rk2coPfx9omG2cEvc9FWgrsUrYZAepIMDo/f/KxM8gWWcKZsR7Na2JNGO99ZnqOIIYMo7CIOu1DT2fBFlqf00Mhr69/nrubNjcrPdZ+oUsTQBbVO+e2jdDBGWHlXHMtEyqQ7JLwVOoNyGiRjG/k7Ywe7XkPfpo48NQNVNmxHZu
 3Pu8nknk
 ttx5ook556NfTq28ylG6PfbJ75/qnrC33Gdo5DCnBhg6oYYTcQOh7V46aTrUMqdoyuDNuLWVGcfKhaKHTNTknBg1SFUh9bz7VnBiDsZ0Gd+yg6R15I7V+4p9Zj4aYzmUjTHzXB0EF7pItwhR2GI0HlL/u6HsFwu7v/LX29gOkHgtRxEE8MV4BHCi5L1ftfeo9Hvh6e+lD+Ii9HgtQqER/qMkDUR/okty9kb9bopJCGgJkBxw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 09:38:53AM +0200, Michal Hocko wrote:
> On Thu 23-10-25 18:12:02, Dmitry Ilvokhin wrote:
> > Allow to override defaults for shemem and tmpfs at config time. This is
> > consistent with how transparent hugepages can be configured.
> > 
> > Same results can be achieved with the existing
> > 'transparent_hugepage_shmem' and 'transparent_hugepage_tmpfs' settings
> > in the kernel command line, but it is more convenient to define basic
> > settings at config time instead of changing kernel command line later.
> 
> Being consistent is usually nice but you are not telling us _who_ is
> going to benefit from this. Increasing the config space is not really
> free. So please focus on Why do we need it rather than it is consistent
> argument.

Thanks for the feedback, Michal, totally make sense to me, I should have
expand on this point in the initial commit message.

Primary motivation for adding config option is to enable policy
enforcement at build time. In large-scale production environments
(Meta's for example), the kernel configuration is often maintained
centrally close to the kernel code itself and owned by the kernel
engineers, while boot parameters are managed independently (e.g. by
provisioning systems). In such setups, the kernel build defines the
supported and expected behavior in a single place, but there is no
reliable or uniform control over the kernel command line options.

A build-time default allows kernel integrators to enforce a predictable
hugepage policy for shmem/tmpfs on a base layer, ensuring reproducible
behavior and avoiding configuration drift caused by possible boot-time
differences.

In short, primary benefit is mostly operational: it provides a way to
codify preferred policy in the kernel configuration, which is versioned,
reviewed, and tested as part of the kernel build process, rather than
depending on potentially variable boot parameters.

I hope possible operational benefits outweigh downsides from increasing
the config space. Please, let me know if this argument sounds
reasonable to you, I'll rephrase commit message for v2 to include this
reasoning.

> 
> -- 
> Michal Hocko
> SUSE Labs

