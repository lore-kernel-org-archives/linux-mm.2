Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88CAEC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86D266B00B4; Wed,  2 Sep 2026 06:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845106B00B5; Wed,  2 Sep 2026 06:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C8C6B00B6; Wed,  2 Sep 2026 06:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53D446B00B4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:47:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E3FC31A0195
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:47:38 +0000 (UTC)
X-FDA: 85168496196.18.4538F17
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1F8FA180002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:47:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ECMn3hjr;
	spf=none (imf06.hostedemail.com: domain of BATV+92e025b455efe38d25f3+8410+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+92e025b455efe38d25f3+8410+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788346057;
	b=bbcHi1I4Q5ZhQwURyKQK95fr3+ej/F2XwhtrDbP1qYgJWgy4+34IaQVrkexGLyPErFG7VY
	Z+CXW6CsGZGBxqO8+K/pmZ7X4uUdyX/QwLyO0E3o0mKK0sMJhNynz+jonHvqaEsYXkD1s5
	e2kUzQa3QIxZyMbqtQg0B1Nl1jA1Oh4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ECMn3hjr;
	spf=none (imf06.hostedemail.com: domain of BATV+92e025b455efe38d25f3+8410+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+92e025b455efe38d25f3+8410+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qt/W3DSxMQKIwG+yUDdW7Q2R2X7cicnF1/L0NrB0XIs=;
	b=4H1akX2BuUcisdaaUSIrOJtH6LJbcd8IuwRzUUSFPi9D4Eab9hG4zFvHZ8r3Ppjw1nmnFy
	e3xAIRzjP8wMURc4Q+stub959yt96lIfxZnKZZqoqKWCKmUuKiVRiqvFgZ+7HjiG/OCXUD
	Yq9Rk99PzS6FJKp6kjuWTPpz0HMItjM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Qt/W3DSxMQKIwG+yUDdW7Q2R2X7cicnF1/L0NrB0XIs=; b=ECMn3hjrfpjO+4jRc0BJUqRldG
	C8pEzEh7EAe2mFlZ6f4a2lleEZ7PEM+QsgJr346Sy8Fy/yhlby7UPNX3JhH1RG+Y5AglE0pJP1FQy
	wEj9lzPR40rM2WqAV0+LcLKb0PSBk/tMtNVuqB72N0v3kDMjMuem2dvLAxeuBxP+RsmhRb2ArqGUw
	5UgHEtIj9vrq/1vzPHMU3avyhWXV/1RKw9VnXlqJPiLcjnE2RnjlGo/miLnynKIaZ8l8J0zIKOg7r
	BY0TlTJCCVDapg6RVFC8yj5UgAK9J4pV2nD4kZYPaoKZv5FgVy8YG3V9NISPx/tukGxMyTiUVd8AV
	zHiq5Pow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1iV8-0000000EOUL-1SWG;
	Wed, 02 Sep 2026 10:47:30 +0000
Date: Wed, 2 Sep 2026 03:47:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: vbabka@kernel.org, hannes@cmpxchg.org, willy@infradead.org,
	abuehaze@amazon.com, akpm@linux-foundation.org, alisaidi@amazon.com,
	blakgeof@amazon.com, rvvandan@amazon.com, brauner@kernel.org,
	dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	hch@infradead.org, jackmanb@google.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, mhocko@suse.com,
	ritesh.list@gmail.com, stable@vger.kernel.org, surenb@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH v3] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <apf-wsCj_5QvAPcV@infradead.org>
References: <7ddb704c-76a9-4071-8969-06fa1403eb07@kernel.org>
 <20260827092100.3988386-1-dipiets@amazon.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827092100.3988386-1-dipiets@amazon.it>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1F8FA180002
X-Stat-Signature: ugguijbjndzt63megk8synfig77q5iqm
X-Rspam-User: 
X-HE-Tag: 1788346055-207890
X-HE-Meta: U2FsdGVkX18G2cZak7UNPzbDdvLy7lN2XB4pNoZIy0pV2MB5bwJOpazRgx8hPH+p/LhVGsuf2vpQZDEV1+NbLSLdurN+vG7Vzyf2DLAtmGReS/9c3Owz2fNEeW3Zl8lbDpXZ8dQFnNA8IV/oOvEMW6JwQFq5a+5tSHLpR3pQkoeAc6wujpSK3TGPu2V1XWr0eA5ky7UKj/qEr612u5AmMOKUYQi+93qfQziwCcCfGsgwRXSz6clFu4myVo1Ka3CucxIfpY8OvRh6LZpJgf+2KbSSbgX6sAjYVzvSVrIpL9TaDAs+Tf2FYP5nADfvLld8Y83zXt/aW6oifnV4DhawRyPewrm6l85JHZCT91bwm8nJ2LO5BY6CINVQfDpwyLpi4XySEUKt7dxQl2O7b3qYviFwNGDfm6KJ8pbpt/OldyhoGBp/GDBtsNIAQRz2wEmh67nKyXhmpMT4PURE/2zK0nR8kgwHpAvTaUgyKMc2IjJrkQtkLwxEmBVPcRHZbxYXlwpnwHEFTLz3I8bb8Gk6JH/v62VEnyqWf86O9S4Il4rLl1VcXwvv/eNd6moL/qwZWA4LNY0+4H9jsGmnpQB2M2JzDAtZpfKXsn/O06p/9uhq6U/rs37C8uxdCKFyNh4LtypsFZ9nsIVu1C2SGELtL8hc1CpZyQsx7V2ub6po1fk1L6oW8Tg3fOHs29zQonPNtKOTFMcxJAjithIj0ooS+cVktPyoiGs+jjj2IUeILLyG13v8FPqYUkO8QWMIZl0r5ihzepA03zteugiUqJx4YvH7V+lHpFNMv2e7s/jdf5jhWt+nB04DgdtlGywQQOnR7QH/XoVFgW5faAAdupH/mQhr6Ea7y3o+k0Pf4elfgJyE9yz82bz7suHykEzZzWxZoGgvfPg8MXk4o/vep8fLwdfbiMRlmC3dXE3AFfb6+CEQx3Z8VbmUAbxmn91sTksin1DXM833QyXmy1/la9p
 F4BFuiZr
 +2Z0wq+KVMmWLXt7utRZb62ck8UJS5g4ShGyPL0MGVm3cWjGnjU6W2zCC0Tp1cB2Z2BBCr8bNWEnNFMDeWXGPo+oJiwad1yUfIxRCvfNMIqM7OBUPEfb1Og1JkNcV4kTCzY3Mel2z3ZrVrkarTAD9KHQCGuBOJAEgcoSPzraxDHhoYRe5u1BNqSdS3YJnspSNyC48d+cwPzeRz5W9PID3OaCR+pVphND0GA2sBoIil8JD3Hm4qV4bDOug9VV9sxqcpMhNek2vO5VBgHe6raoj9GwzC3/ASpXE7d5+9U/AOtL+mz9v5vlaTAQg+wk0yaUa8tRFS13BoMu7x8/IqJq/whHRztyBIzDGunxf6SYXUPW5jopDkA7+jQy0QqTg7GtUAdvDfe1fJJGQmRx790IfYlYBIs759RghO2MUw2AOfpd97eQhhHAne/zp0kYoBB7E/233GIR30I9QL2mgAITs1QV5D4MTb/P49J0gXgUIQaObXWN57p+8oVkAbpD3/lCZdd0ahQWbZoUxjhpMj8Hzn/5lR5qvqW2sjSX5g/0B1J2x2/TdTnBeXfpHtDJwr7H0zRfOMatmNjfPbZBUL50nr2/HLDP3VYUrqxX96dnOuxQMvCzhx7sUDr1BBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 09:21:00AM +0000, Salvatore Dipietro wrote:
> 
> On Wed, Jul 22, 2026 at 02:35:00PM +0200, Vlastimil Babka (SUSE) wrote:
> > AFAICS both your v3 and the implemented Johannes' suggestion effectively
> > make all the compact_first logic dead code - at least for the intended THP
> > use case based on costly_order. It will only continue to do something for
> > the non-movable order>0  case. So that's a significant change which will not
> > show up in your results, but might affect other workloads (I'd expect mainly
> > by having fewer THPs).
> 
> Right - the change above modifies THP allocation requests as well. So instead
> of applying it to every costly __GFP_NORETRY allocation, I restrict it to
> callers that do not ask for __GFP_THISNODE. That leaves the local-node THP
> attempt untouched: the same bit pair is already tested further down the function 
> to bail out of the compact_first block (page_alloc.c:4899), and alloc_pages_mpol()
> sets both flags on the local-node-first attempt (mempolicy.c:2476-2478).
> 
> I tested this with my PostgreSQL workload on kernel v7.2-rc7 and results look good:
> 
> Baseline:       70,735 tps
> This version:  144,670 tps  (145,280 / 144,037 / 144,694)  +104.5%

This looks really nice.  Can you turn this into a formal patch?


