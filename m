Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E928C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 18:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1FE06B008A; Tue, 28 Jul 2026 14:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8F06B008C; Tue, 28 Jul 2026 14:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99EA96B0093; Tue, 28 Jul 2026 14:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76DD26B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:24:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1BAAAA0434
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:24:57 +0000 (UTC)
X-FDA: 85039011834.28.67D8ADC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id CBC941C0011
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:24:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="gAQV/3zD";
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785263095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jP8z/RaADyj4SpOiJr76y895B8w3LXU0vC4QQdU3dfg=;
	b=gFuVr9UTxaYyJu5136U1juDZr4fisArLv+rUaICbCPxpw5Euzo1fxlJlbHriPn3ZIYF8Xj
	1hw3btiTyZjsIQWylWjxpC2iZGLqVQUNtGoHEOGBX6MME4RItjkOxvkJURP+PLMUGiVMft
	Wf3yPVJ76H6eQvALzeg+NNb34K71nC8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="gAQV/3zD";
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785263095;
	b=YFxLuvldmVenfeRvOZmOf2WhdXVJDa+qjtaMQzKDY26AoDw6siqDQwhk2yRr6KybCw3wsR
	s+NkWAQHH1TYzuaFaFQmZk/a1eKBCGOh/8sODfBnrjQwva3azO0o3df58XFgLG7UhV+lAo
	bBhLklb/GsRNHxEte6uQ9thDeq8nMRk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jP8z/RaADyj4SpOiJr76y895B8w3LXU0vC4QQdU3dfg=; b=gAQV/3zDg05LuH2uSK40ydF48M
	PmFT2ztWssSY9W16jKElvZf5r2T432m+Qnq3DvMveYg4dmdBjwii/MrvFRNQsK6Vi68KO4GoIHyWv
	SK77RTvJBOxzzYyujqP1XnrJ2t9lFQoNr0HSYX90ca7hMJLjjcuFNFS6Qsu2FA0jlDpY3oNAMrtD5
	SH/WZbvWa53EqknNeEBvC8yS/KAidOEuXunmUjSC4EQdvaPqBqsFXobAMduJC7P25pg2GYNd8TrhE
	wGMfC7WvSUwJa4rxXHdaiAecf1TSeZRj5dFfP+ICKJ0fa/Xrfu+vvR5WQnqeOE/3s2L9RrsE53JQZ
	CQB488Gw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1womTu-0000000DxDa-0uJx;
	Tue, 28 Jul 2026 18:24:46 +0000
Date: Tue, 28 Jul 2026 19:24:46 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com, gourry@gourry.net,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com, dave@stgolabs.net, nifan.cxl@gmail.com,
	xuezhengchu@huawei.com, yiannis@zptcorp.com, david@kernel.org,
	byungchul@sk.com, kinseyho@google.com, joshua.hahnjy@gmail.com,
	yuanchu@google.com, balbirs@nvidia.com, alok.rathore@samsung.com,
	shivankg@amd.com, donettom@linux.ibm.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Message-ID: <amjz7kIDuZH6gBx9@casper.infradead.org>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728111401.b6d674baf8e56a27c55e0c52@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728111401.b6d674baf8e56a27c55e0c52@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: CBC941C0011
X-Rspamd-Server: rspam01
X-Stat-Signature: 4cyca3hfj9o1ixe4uot451y561yw7qad
X-HE-Tag: 1785263094-862188
X-HE-Meta: U2FsdGVkX1+lt5OhWhJpByUC0NaM3t7JJiPj1PmtqHNw/TkG/0iGZ/yegyli/kc42eEsMllAjQgSLEu1/91vn7O0PJQs3OIJU//XnUTUMrsg2nXBx6uj6bA8JeuSKwy92s/t9UUCoTnu1O2M8Sp4ks85Zjj9hd5o5AicL9IMgW/N+1j9aTKnTV7z4s/1FmF9/Nuxp7RHUIUYtuq409MI3Zi/k+05uKIqehJz1X5TJNFid6tQGSpo6uLnizulSUAyh19ZUhTtAfhT2kvtxRtWkXqkqs8B/1GxOvM5XEulKtTtakKciZ8awdaQQyP4bnnARfLfus7DIBjXQ7jseklID/9x12+RWdd/dezlrPO9Jq5InDvtfLfL5EnDXWCZyVhufOLLrOGKzDfV0q6rLjPrh53CFIx06hTPS7nSFc6L95KEUJ3mI4QT2j7R9WmRtEgr1+G9MHn9zbhrUH3uE0D1bfysp32YHMnaNvWwQV/0xxijN1CNLIwz79RWdKF+lxuTzOBJs4XpFjHUmMZQpHK4KG/jXbBgZ2KGNwBifPtV2AJUv5xhpJCz1f/1M6WoU3ItzvV3Lb0DUAeTdSYXYwfLROP7iZHMi8JRc/cKE0eX5gJ+Njm3sunzXnivjTHeug+IbAKtcSEeAwb5qJ4wXcBHvRtXyi3z/3OX7rMYmFkO9yeqTMQkG+uUioNPPwlR6jEFik5jz2DYYMk+P1LF0+t9ObiQacRHwUkdIsG/LLd0ZqUesoysdIyJRaYi+mTzlNx8nfdYLgtLg59UKsg7FWBIsF0tZMpW7HhdrZd+ZE3u3n3r2MJUn/xThcWb7kSuHHBcAoGcDIQKoehPiOzsA4YQFuqzUklSfgCZIHPRZDOzKqqyLMX9fLiyE59Lr2jkNYpuH3JfhenrocGIA6x1rLKYhke/6NKh7fSV8n/rpd3d+RzxKU3y5eTJBBj6I4ijfdrwIQbjJXm6vUbJROpx4PF
 g8q3Pi4+
 U1Ki1efYaVHAnW50b2W5HiIv7ztLpVkNJVslXHRu4A0cEAAxfsBsV7JUXIolu6OStsFALElejfyBM4E9z6R6oUq/nlteTW7MLL+/zMA733q+KLGNjKKODfSPPgmjqA7A04hsxWr6r78URgnz5hvHydJ9dsRY0i6FlamAIsP4b07RvyYYBjgD4GQbR+HAB4nhXnNGsiH+QGMK63yImEaweUICvNHGhvOiyXpG2lML4qMoCix9AIvV+pHMLErm6BWH2My2VKcQmeBVVMZDCP+pf5k9jbk2BAxKOSWl3jFg7dVIsQ1Rpf1pZ46iQSOC0ReJPaQygbnoRYO5Rn+uapEDf4ZOqJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 11:14:01AM -0700, Andrew Morton wrote:
> On Tue, 28 Jul 2026 11:13:48 +0530 Bharata B Rao <bharata@amd.com> wrote:
> 
> > This patchset introduces pghot, a subsystem for hot page tracking and
> > promotion.
> 
> Can DAMON be used to do this sort of thing adequately?
> 
> Thanks, I'll await review input on this.

I don't think we should do this.  I don't think it's a use-case that
customers actually want; I think it's something CPU vendors think their
customers want.  I've said this repeatedly over the months this patchset
has been in development.  I say no.

