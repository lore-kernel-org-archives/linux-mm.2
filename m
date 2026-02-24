Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99CDBE9B249
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 10:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D344C6B0088; Tue, 24 Feb 2026 05:41:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1F16B0089; Tue, 24 Feb 2026 05:41:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3696B008A; Tue, 24 Feb 2026 05:41:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA6856B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:41:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 578441A0465
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:41:41 +0000 (UTC)
X-FDA: 84479009202.09.CA46823
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id BBC8F180002
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:41:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YxkdXSBf;
	spf=none (imf24.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771929699; a=rsa-sha256;
	cv=none;
	b=cteazMEKMqouBf+vbRkzPqpqF87/cTLCqumalQ5QKW7KW6tEh0E8pXDbNB+6hgetYt0yo8
	OjXFa3ZOcYqmrSO8EfI1aoJ0Su2gss3WviMPbNztUQKAKmta+3vphv1XpzrYgesCTudOET
	xru+gZqP1WjMCf5edLgy1H7McysTLcI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YxkdXSBf;
	spf=none (imf24.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771929699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bHwIF4V+Sfi2Dx/bo9vGSSFFbaqINJ//nOO1nfy3NhA=;
	b=IGFFrNupqbfB+UBzgNhCWQ1Duk6tMfJR7gF869z59tSDPXekf4ZrfSdAwHAIYZurLIDQ2o
	gmPi1i/qoX3qlYeA5jAfY8hUOWgz/3VCr2JLRLeHS3QYpWZUJg+jEzvqNYSrk1UIwoILAl
	BTAx/mQv7U1rYDJ99iU6RCHJRbg+gbE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bHwIF4V+Sfi2Dx/bo9vGSSFFbaqINJ//nOO1nfy3NhA=; b=YxkdXSBfv2J0CfNjCaNSNGxjsW
	HimhZAuJW4NO5YY8NK+llCUJeoqBRJ6Vn99JrFQjLTPSc32v5+H796fnEtoAEERJu7CHuuyt5Cq8q
	mgkfSXvXgGGNAMbbP68DvycGfejyRyfC64MxJw9nNRjI0SvikEy3mWLxWQSe7Gu6xvJjU6HWvmk74
	ChIW3W7MiMNHXPnbNOiICk5WzeaKFt1R0vsVGtgLzbNfJya6kUHttZIABiuipFnYmSVOIcKpFmkzN
	iY/HvUJjMn6/HhwyMGbK/YmZ1wOzC70WbrcIRbXBS9kJQEVEjXPYuE6ykoiI3MMcHusmIGp+/IeDl
	CVZfzgXw==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuprD-0000000Gh6J-17U0;
	Tue, 24 Feb 2026 10:41:35 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0DEC930075A; Tue, 24 Feb 2026 11:41:34 +0100 (CET)
Date: Tue, 24 Feb 2026 11:41:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org
Subject: Re: [RFC V1 04/16] perf/events: Replace READ_ONCE() with standard
 pgtable accessors
Message-ID: <20260224104134.GW1395266@noisy.programming.kicks-ass.net>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-5-anshuman.khandual@arm.com>
 <aZ14lUwuA86aiOH-@J2N7QTR9R3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ14lUwuA86aiOH-@J2N7QTR9R3>
X-Rspamd-Queue-Id: BBC8F180002
X-Stat-Signature: naq77wiq5r3ybq9j1krzn1k1wotwftkh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771929698-603565
X-HE-Meta: U2FsdGVkX1/en3vBRg6aGF4BhuUYYNh7TNhYSCG9quzSty/PYTgx2w9pSyP6EaOU7DL7gAVNHISq6NYqARKCXU2So53Yq24VE5pK1rpue5k0LMkY2WjaZiQ5zVbWQ5Vdv55ie6WAdy+PO43eJgEh6bS/2IpGQM10tfkEwbMVFUt+UFd8+6XVxM1zrALZvzfevIw0BniueURpmg4N/d5r1s93Nx0r3iAzzmB1sv6h7Bs19r20waPtNVG8qiQWBFje9H8F/Uu/JuOXw6CARxYZqR833/nW07rbofq9mCnUk+MWRCR0egAlTatH5ZdSvY7RFdkjn+OHO95qL+XqVnVUwCAXnyUXnXizVm4d8k8uNOKBOeACDOzdzeKhRQqdWrj6qLP59VvQ4ACWMmlMi/cagqdagXg0CPtumCqqMN1Z4UVaOLB6y+p0YepxdYD727KkcyoJu4E2SU08K0FWpzQAAn8XjcwAVmNNevZ1pXtZ3pvykDKH1StHqVsFmHeFmF7mbouGx5Yv2HzUVoAAovWjHaAL3ZxODt6EuBcktK/10g3mFr+k5WUbgjxnFvjIsfzPn3fgy88c/hct6veexUFHztYx5M2SSDYkIA37SVoObMS+pCOERPyOdQvXVhpLnwrGIPlSraNrg5Lomp31IARYgFEiN+TH3NaDiiSti/96av5PZ6jQEhY8P3ANNaBlZay+k6j/WzgVBY6tgA45BeD56xWnD9bMDtz8INPILjokwhZY1W2ESfxXmFc2JvsNNnwWGKxH6uCxojRKGF7dTS+ywdJdZWJro5Agq0epA1KiDuVGGFGHQdElUhkNw3EZ5lA1l63HxSIzylj66K0tN91yPcckkujDaedWGHDXc9fYhJZwotDg3z4wX83zvw/twQ/bKhSqlNtM+RLiwg7HjFqhTKckMMig31EoTVNBwm8fCeD13IeLUsHITZCHislxf529odH1NkrV76xJOKRH0RV
 dXpqedyj
 K788+BQE7FAIoUcaoJ3O98QmqQHKBHwJHxF5+/1ymlJWEw7mwMA26SfhdepMUVykz5T2Ljkz1nEfYdzCwcIaBbse7hfAu92PWODZSESZ3s0DzH171occJ+Y2haZmThN4u9HUYcEyhoVafS1Mzcqf91j9ZqoRl3HZVJj+7yK8VYRo/SaOOT0kTN/xLIMDKSn/I9SATX5bEco2DfwtyOuHRwnF2sYvmSGl8eEAKM75MG2BwiU+8reN8OlgrS7Oa87dJDwKAxT/UAzWW6nLWUo1Gyx4cMw3u7DBb9sK0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 10:08:21AM +0000, Mark Rutland wrote:
> On Tue, Feb 24, 2026 at 10:41:41AM +0530, Anshuman Khandual wrote:
> > Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
> > anyways default into READ_ONCE() in cases where platform do not override.
> 
> For each of the patches where you make this sort of change, please
> explain in the commit message *why* it is necessary to do this.
> 
> IIUC the entire point of this is that in subsequent patches, arm64 will
> need to use something other than READ_ONCE() for all pXX levels in order
> to support D128 translation tables.
> 
> Spelling that out in the commit message makes it much easier for
> reviewers to see what's going on, and to focus any discussion/questions,
> e.g. *why* won't READ_ONCE() work?

That, and only being sent *one* patch, I have no clue what the rest of
them are doing. Didn't even get 0/n.

I hate people sending me just one patch; just send the whole series
already.

