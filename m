Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57527606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 15:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=XKFkU1s1
Received: by kanga.kvack.org (Postfix)
	id 6646B6B05B2; Thu, 12 Nov 2026 10:07:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63B336B05B8; Thu, 12 Nov 2026 10:07:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578316B05BD; Thu, 12 Nov 2026 10:07:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2266B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:07:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A531A1A066A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:07:56 +0000 (UTC)
X-FDA: 85426796952.17.EDA09D5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 50CC1180007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:07:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XKFkU1s1;
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794496075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6opaRvcpYR6ER81jsMzDjvR9PJZQhTjt+6UYrb+STEQ=;
	b=u3eZ6Y+fDSJ/dku8vZ6VSMXepYxx53eDF8p6iOapYBB+s1RXd3ECBmiI19/DUfY+npibV0
	WuxJSWflP1vJWp/5l06lrA4bJjCpJBqFk514OmN5ZVi3TL8YGfTAEqSIt4QB9gPW3tpXor
	/BT+ZkFFySKQvqCXOAnwk1YbuKmPPR0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794496075;
	b=nsaMMqGHHigvw3NnHCjnfgKjMlLCj0hQB2vhrQO1IdDM1u8aocOyo/9ld2fues/GRs6NGZ
	gEKzEq/zT5pKZk/ePQtzmJ5T6o2VP7v3/z/kYm8vFhbn6C6yjVaqg/JS8puAIWXMq+xNAo
	gy6kAW/IETvkTBdq0EszMtNQNbWjXQM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XKFkU1s1;
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6opaRvcpYR6ER81jsMzDjvR9PJZQhTjt+6UYrb+STEQ=; b=XKFkU1s1WLuQPbtURXoArtJ7j7
	o9pwHo3e6AdR8Zgtb6oRujApHL3gysKUnm6lDE0R7s1iTknyaH74HuyPtjCmuEoIGR3T+kN23iBZ/
	KlC8uFl6aqsVrqrxFqFnM5qZQtQR+WRpfY7ztO0HcKJKXGWlRTCs/Y8GwaDEVsUt8sXtElrY1Gp5f
	uACRXsOItxvIZI7gScaYKe66Qxz8TJE5h1mZ6Thk3x0sk28ZJmbOjryXKSMUK7zjjSn7aaN3r8lOG
	q6ISBbgwj1rpG85dXSwLafePK2XjQK1CNNQ7Y+S3vUAsU2M3nNQuw5l9OUmUQ8djIDj4r0kubq30z
	9X5y0OfA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRWP0-00000008PHw-0kFR;
	Thu, 12 Nov 2026 15:07:50 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 42E64302FBC; Thu, 12 Nov 2026 16:07:49 +0100 (CET)
Date: Thu, 12 Nov 2026 16:07:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: Re: [PATCH] lib/smp_processor_id: Don't warn if there is only one CPU
Message-ID: <20261112150749.GA1813469@noisy.programming.kicks-ass.net>
References: <20261111092421.3771992-1-chenhuacai@loongson.cn>
 <20261111170600.GS1779021@noisy.programming.kicks-ass.net>
 <CAAhV-H6SYOjOw+owmStK7sr-HOiADC1zZ4Cii5hv1q+qYAUETg@mail.gmail.com>
 <20261112081348.GB2668804@noisy.programming.kicks-ass.net>
 <20261112094059.18f66c2a@fedora>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112094059.18f66c2a@fedora>
X-Stat-Signature: nzuyk43hidu7y6hxw9p9zsu46fx8yi8o
X-Rspamd-Queue-Id: 50CC1180007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794496074-933821
X-HE-Meta: U2FsdGVkX19Q2vW0PMUIsU7v9+rQpEoPVT+je0RMaMamYPfQZ4H0HYKAfN5HDjDn7f1TgknvYG+xopF9UjVRH4OmP6VWzq2/Imd/V1SVi0Y/xKBHMYRCSB77+DE2OJhd5OSJB4e7IDyt5SuewjRLAxy4BLyB4EjOEIqAFjGDI8b8qyV0PU7hRz+HXiSkGPOIjPvuLiGcMiWSulJ9rrTtZd1myYHB7Y8sD2sOuTdkeZXTwAWQIl2+nMh6XwVMkuypFVChuyutrwHL1VZtqvlvo+0RB3PBEhxmfdnJpUfLhT3qA9lNihtp1RtoTOV4RVfr9/OKBbZPH2KU87NSI4T/ZLeY7cpWX9rrp4Kk9ctcQvTxKdyvKfsTxYXto6TskqtGSLQy/g5pILz5yfF0GZxLc+IOdf/dqRbFoaKQ9qSRzcZaa1at+34NWcorP1/Zh57Sl+XoB8aHvQecUM+Ts82a8oLGsX2XFryFzE1HtCSD9KCUYt91vomY7r8dFEDJk2k5VzhVr3hh/a6BdE2gjKEbUJcBn2i8uOQaGzeczw26lJJA6h6KmLkgIrwlbEPo1DoOAk0RDsUUVBPZSzyWhueTwbicgp+s1X5V6ZQRBf3FdBJ5fgf7uCwRGNz5segSK44mcCdEeQxUAi69G2kw7UsaY/oMg3AVyKcP6xJKZi3B7jE3BMkVmfo0WaPbOqVqgu8x/uN99exYpnc5zarokkrwwRXNTGOEptk3p9bHNm8UbxzcQsn3sr75TmjELnqqVhUHpSy7AaXRbLzaoKxXm842J6I3MJET2KDYCtivDg3ddKIEi9vo/W0CAYVLz2fdW6CX4ndb+iCLyfg4TAxIs36KqMM0J0BxXxgIslYSG4NrqeX8DQLJg9y6pmjdBeinLwj/X6inLMv7/E1dPgaNZj0OF+Mzc0/JfhEjr9VIbbB33j14zWPwPme4vn72mGxAFXoCR8LE+nbbqsa/F3JyTlK
 rAMLejHU
 Ke9ADsj936E6RZsjMDdUviY7MZcMYzafshDYtVMtiFr//r7WdlB79Dli7siPTFwqFrLxPbPUnWS3zk+y4MANjsQDRbgdtBtYPeYCxCbmvLsjrmIhDRfge9C/Hw9C9Jos/SB3nVo1PCtOMWFly2fEAqE9L1aJBNorGgcI2OLOJkBM+L1Q7PH3pi5SoLRQz0yn3wyFpf0TDBdEV1akJn3k99LzZa/R2G/yT7uNJ/Vm+uxBxEdCO51Ynm0M5KGvxUu1/X2qrGEcjG2l8RUt0tqh5x3IE/4zI2Gf8zqM3BUbpsiPxDI9X0T7V/t50+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 09:40:59AM -0500, Steven Rostedt wrote:
> On Thu, 12 Nov 2026 09:13:48 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > num_possible_cpus() is what I was thinking of. Notably, there is no
> > requirement that the CPU bitmap is dense. You can have nr_cpu_ids at 256
> > and use 255 for your boot CPU. It would be completely daft to do so, but
> > it is still valid.
> 
> Hmm, I was under the impression that there would always be a CPU 0.
> 
> Is it possible to boot with a non zero CPU setup?

Yes. Voyager did that -- although that code is now long gone.

In general we must not assume boot cpu is 0 -- although I don't know of
any architecture that currently doesn't have that. Might be fun to have
it as a debug option to catch out assumptions.

