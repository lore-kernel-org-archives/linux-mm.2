Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F4CAC531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 16:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DFDE6B007B; Thu, 23 Jul 2026 12:58:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7476B0088; Thu, 23 Jul 2026 12:58:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F49F6B008A; Thu, 23 Jul 2026 12:58:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 065056B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 12:58:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 840D11C09E2
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:58:52 +0000 (UTC)
X-FDA: 85020650904.19.FE1CDC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id F3DFD160003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:58:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784825931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0rosnFueFk5L+rbQoTyhq77sYbaq4m804yU4PWOXAks=;
	b=p9Ug0iEl4wkETlbY7CtXrO9LWCH9f7+cVmzZ/0LYqY94r0iXXzmEqLKmzuzvxYq4cBV53l
	yU6FomWv0bpWopf+Yev0JSulKg88UOEWQSn4SmAPTGkbZsHO+0MilbHhNOAsoWZp9wjB1t
	oZC3pyzR0SCwxgR8eTDVJwV+UkiPpSg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784825931;
	b=zFmReL+GCTqw2lEVHovRRmpyrIyYvV0tEP8pp12DOwnbD2m9moo0Vr99bkBdOPuuTwgdzk
	abf+PRDg2DDtFZn+vRecN3ErWy5MXQWoSb6FfpKYVponLrFhOkf6IXlMUECNkKfJya/2iC
	2G5a8S907HAhtM3t5RxQ6Lwl+wwD2mo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 08CA141495;
	Thu, 23 Jul 2026 16:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD0A1F000E9;
	Thu, 23 Jul 2026 16:58:46 +0000 (UTC)
Date: Thu, 23 Jul 2026 17:58:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nirmoy Das <nirmoyd@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RFC PATCH] mm: use precise current RSS for high-water accounting
Message-ID: <amJHS7EV4UJMqFVT@lucifer>
References: <20260723134158.1473841-1-nirmoyd@nvidia.com>
 <bd3facf5-cc4e-4fa3-95cf-0f4aa926ae23@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd3facf5-cc4e-4fa3-95cf-0f4aa926ae23@efficios.com>
X-Rspamd-Queue-Id: F3DFD160003
X-Rspam-User: 
X-Stat-Signature: 9cqu68bt9y3nm3p3fjd6uw63oi8chr57
X-Rspamd-Server: rspam04
X-HE-Tag: 1784825930-567207
X-HE-Meta: U2FsdGVkX19azfkBUoGuVIfETWdW4D95/l2TMf1+ZcxF4hzWRAmV1KlaxezujTrX/8VB9DipYoIaPouGeqLr+DNE5keEuLQuK9ubST4oZ+CRAaPLN7Rf2r6qtwF59cq3ZpcPBbVm73UwJf73PNN7uRiornsPDAbLqJpml7HP2/IXr8/S+ZmV3B+NZtKYZIZAjyRkFzTjHnZlpCWS8fjRnyamsjoEuapbPVbQkFN6jnQcGRgCqI7Jw3Ic+CY/HcSCtls8nDqPV5pNaH8ElxC8djPokBC2VeqezP9cAEmYyrtrQBb+YTr0Vg8qakAOSY3S368Y8KwFISzNdNIMxK0AiPOmwu0im53BPFffmFotpm+hQzOtUQlV1ve567uOiiMkZgy1b2BFVwyK6aBT4rHmr6ENEBBTiY6YneIq1qm10tCICw1KBr6+OqMM0bP8eaR5KRAsOjv2/DvH6Mz5OWhAQu3zDBIddcyHbnLK13yKLv94nqUY/pMOSGjAcQ+dEtibp+jZfORKQzD2NDip7LERYIFlAwlh+oHLt/C4NKWp9XIY3iU/w4Ej1J74ApDPU8ECHIMwI5O4ABRsnJ2t93J8gZmbfS64lXOmhcQQ2Hr+ByMAofWFEOZOI53Z6PeUnLukLx16W7YOqOsDFt9s5vPt/qELsY990b2kTcOs7JKKoo/YVkj4wXIr0cx1mtb0YwrVNrHZBcuEi4SSh8l+QePYmTX7Bng0sjcK94vSrC1JTUu++UTfhPFYSi7Aa0Q0C2gUuGA0TYA9fPTQJa/xOmur6O0AeP4mFZZofLBarUt9EQtc7LWK0Hi1CuHZw6OBOiBx6tGInZkKyhKYoDemnb66H5vCTUzM8QH2zBboQ5RRfNSV9BgPVktIuGuS6gHMKpOZ+OE4dIqOmv+oRlv+ENuFG8XmU3rFHwjvjtsAOUGnd1zMQJjIsJg66mTiCu5Ndjtay+Mrquamzr8kl6Dd4MZ
 sS2x7US/
 Duo0Ae9CmDlEbYGQbttno4qhmvDYC3/0t3kJnFk8jB7tM/FJ/cckHWRUOn5uWmRpXsMsoxH4FjoLTjjmf+93p3jUzTokLxw7wSyfsL0d8m2PQq9CDMpnAQJCtIcZclCFf4NjMJwTFBm2CLElGVuIvBPIS/VC4pvWnaE2Jv0daN2/kJOVAFXKtp+BSw227W827wDYliZzenyrrFLu/PS8q74pBV+giuu2MNmo+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 09:47:13AM -0400, Mathieu Desnoyers wrote:
> Did you compare this with my hierarchical percpu counters series ?
>
> https://lore.kernel.org/lkml/20260707131544.75906-1-mathieu.desnoyers@efficios.com/
>
> I've sent it to Andrew two weeks ago but have not heard back from him

It'll need sign off from relevant maintainers, I suspect this is simply a
product of your series being complicated and the incredibly overwhelming
amount of review load at the moment :)

Do ping on the thread though if it's not been responded to within a week or
two, we're usually (much) better than that in mm!

(I'm not sure I personally have the bandwidth to review, but thought I'd
chime in to maybe help you bump it a bit :)

Cheers, Lorenzo

