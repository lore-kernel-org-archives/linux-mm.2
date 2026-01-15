Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32A05D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B9C26B00F0; Thu, 15 Jan 2026 15:53:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5918C6B00F1; Thu, 15 Jan 2026 15:53:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4901A6B00F2; Thu, 15 Jan 2026 15:53:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 389646B00F0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:53:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7EDBB9B4E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:53:28 +0000 (UTC)
X-FDA: 84335398896.22.D22A66A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2AE51140008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:53:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FKLxLDO6;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768510407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MkBkOX721SiO04YEUcmPqMOqxIKW+i/065hafNf3K/k=;
	b=OYjJ2x/2N4DduTsa/jJlu+ekxAltkf0u7lYRV8vowMOHZWaWZDQvGDPfVC+7MC8QDH/cMG
	chmHlz3J0r5Kkgo75ErMtjxKCkldaDRIFeLqf467pJZv7mcYHIbvFlxKsi4bCbrIK+fvqn
	KlmSpaimJ6k03pGp3Yfc+soGevKUnOY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FKLxLDO6;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768510407; a=rsa-sha256;
	cv=none;
	b=gDdL38vICrzywKHauN9Dyj0XOhUOAQwhx2npE/Fx1vXrU5NoXfdSd2IIZYVFudMR/e86zE
	FFb/J4XUtlrISQmS4W4MUdfZuBap2XJ0WjLRkGQo18y9XF8EosE4u852hPzyr0XvkLpI89
	AolX6xT1EZnHywfVvNcBSQgWk9DMJbc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7068D60130;
	Thu, 15 Jan 2026 20:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78038C116D0;
	Thu, 15 Jan 2026 20:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768510406;
	bh=+kSn6OZb689goDZqhJCcy2AxMqtGudBDlkvG4nHQZN8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FKLxLDO6WXGtdWy1XYnd/pnyJXXBMLdvo3ZvG1BHZf8HQJO80m9gwZxcxFcynmIu2
	 JVqSh29Yf4miHM1RVCKZINiVX4Dy9/POf8a5LSlyVZlW/HUMOcpHX6n3oooRr7XpUW
	 NCVaEuUx2RPTF9CggzR1Xnyinjj1b8guq+FoIHBk=
Date: Thu, 15 Jan 2026 12:53:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, Will Deacon <will@kernel.org>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Peter Zijlstra
 <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry.yoo@oracle.com>, Laurence Oberman <loberman@redhat.com>, Prakash
 Sangappa <prakash.sangappa@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Subject: Re: [PATCH RESEND v3 0/4] mm/hugetlb: fixes for PMD table sharing
 (incl. using mmu_gather)
Message-Id: <20260115125324.6373966518a479c585c4f404@linux-foundation.org>
In-Reply-To: <84a00b16-0fd3-4a32-bb7a-f117dcdcf1e2@kernel.org>
References: <20251223214037.580860-1-david@kernel.org>
	<fa37f15c-e5a8-4502-ba82-c077ee7b8e5f@lucifer.local>
	<20260115100501.2b956d74aabfe142d37aa608@linux-foundation.org>
	<84a00b16-0fd3-4a32-bb7a-f117dcdcf1e2@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 4gxsgty4ahxfy5kahj99a4ytu8xja6a9
X-Rspamd-Queue-Id: 2AE51140008
X-Rspamd-Server: rspam04
X-HE-Tag: 1768510407-506462
X-HE-Meta: U2FsdGVkX1805cJXkWq9lQTJ632JlMB0w4RkqChm1kKvdvBE61tHxOnyK/DMD8CO13I6QFR0ZzkgPbt978s4PD70lev8+6YDaORStlQmrBPmBMf3qMcYbXaevP9dawIhmcQ5y7+pQAviOrJZC5E92D9EmSEvfoKFuifkWCaDCeUc0LEIMexEbr1GbtPCpfjC5qf5rWScJfjGGjlUjMBBlGjleCjI7HbsHpbNetomdGitThV2SLzRYaOzxqpv6FOC9lRxTwIJ13OymG7ZFR4rbiWRr4ERlXT7/4wCawPr/ulYdnXGabm0b+AzHL2KW4n5vRKWSHGOrhWQaz+XA/MGkEpMPzyPLepcwpfrp0ZjAYDPcK3pjzQQd0Xfig5RDK/GUuwJCFGDv1aH43UmaDaWyXoErEIon8B1OxSqLgbMUzJiYyZvVJfuuyq+95uSTozGewKX3etnsvE0BM7WVdj0FUrD/prI+uFMD9aWHztOZGESROxUe8wJ6RBKzE43gb/vLseqR3iolrMD01VxEaL0BuQ4cLLvzPk1VRmOxVrcZN8beyDWI6HaiFBaDLRNbGXlJb/lf7vnT0ViAoaHbSTONMNOVNGMFEsBpL1seopTEw84ojUnFYGl1qhn+2dTIzbdGxG7UXFr55lFJdSqHEaMkMti4RQU0Af2bMfEvVgvmNMrnTpMxMa2yn55iUl1j5avWKL+ig3bmo52KghH1fOdP7p8DUGtff1OGB59ZhsLpWFYlo9Whs04bPABZIoNM3jwOmCDao862MriPJ9p+MIjyadC25saKfTioNJNga0BKjGc+V3zFRBuK7KtGjRDt66XCteQUcnBtBC8Ow29eb63HJM4R9ubH2dG94pV7UxV8orWbg1B54KxZOQhU25KnEzObnOQat23X44ghqxUNr50DyKlCA56zXQVJoXaboOFoUoJIASRN701LQMdgh9/2WJBcaWDNyjvDonTVvuH63p
 IEFN8Q+F
 W+H0W82nuPwcTnwOXNPGLjsOrvkegsad0jBYN04X9ehkYNH2LtuMaHqpLeR0feVNBVkVj5KsFIncXb7vsTah9sJbJoBzgCLz6+3gudAk1WRpwHQStotCqlOtEIXmvgfW791lDtHfmmEBmiit5L2I8x5RR2aPLII+/tz3yJM6VC9pppLAVNKwkhHxiLav0RP3+k6IbYRb9hwNiL9MF4NBnWFpBYFTYdwymlGjfuSiawqnBdZtUGZjL/3La4Wotfm9Y+PUNdMyOMsEVofOElqtpPSaSUJ1fiRAlsav95pbv4+Kp3e4YVJl4bOvF8iAvqZdEmq9yeQv78CLaIBlGvJlk/hb+8bXLjpjoAL1SwMSEpht8mWSompE+7EBCMn/RhKvLDvaOUNUzNrQbfIs0ljGtRek2BQZRh8UO9g7R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 20:40:13 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> On 1/15/26 19:05, Andrew Morton wrote:
> > On Thu, 15 Jan 2026 17:22:30 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> > 
> >> Any update on this series? It's a hotfix series and I don't see it queued
> >> up anywhere in either mm-hotfixes-unstable or mm-hotfixes-stable, this
> >> issue is causing ongoing problems for a lot of people, is there any reason
> >> it's being delayed?
> >>
> >> It's received extensive approval and testing, so should be GTG right?
> > 
> > This has been in mm-unstable for a long time.  As the series had a
> > mixture of cc:stable and not-cc:stable patches, I figured we'd merge
> > them all into next merge window and let the -stable maintainers figure
> > it all out.
> > 
> > As this is more urgent than I believed, we need to figure out what to
> > do.
> > 
> > a) Pluck out the two cc:stable patches, merge just those into 6.19-rc.
> > 
> > b) Merge all of them into 6.19-rc, let -stable maintainers figure it out
> 
> Right. We can just CC: stable on comment fixes #2 and #3 to make 
> back-porting easier.

Yep.  Seems lame to be backporting comment fixes because real fixes
were textually dependent.  Also seems lame to retain known-wrong
comments in stable kernels!

> > 
> > 
> > Also, David, where do we stand with
> > 
> > : I'd love to get some generic hugetlb testing on arm64 and powerpc,
> > : that do hugetlb TLB flushing stuff a bit more special.
> > :
> > : I'll try doing some arm64 testing early in the new year myself.
> > 
> > ?
> 
> Not done yet, unfortunately. (I don't (yet) have easy access to decent 
> arm64 hardware ;) )
> 
> I still hope that Jann could quickly have a look, but it's been a while 
> already since I posted v1.

OK.  It may well have had the hoped-for testing in linux-next, only we
didn't hear about it.


