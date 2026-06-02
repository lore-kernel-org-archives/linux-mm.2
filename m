Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 801CDCD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72CF46B03AA; Tue,  2 Jun 2026 09:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703D46B03B3; Tue,  2 Jun 2026 09:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641106B03B4; Tue,  2 Jun 2026 09:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5469D6B03AA
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:35:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2A18A08F3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:35:49 +0000 (UTC)
X-FDA: 84835070418.29.7F8660C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 67FD3120016
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:35:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nFQVeFrO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780407348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIFsvZ8o1klM9coqPWB+8+5GuojIlmrjo3nZO0SjZgY=;
	b=QZv95/g3GtqE6b8UumougJhozfuwoFmYKgNR3uH5PSvalPPdeHpIIu8XY5G4UXU0q+JRB/
	8vk9KAbCITOWx3Hg9pmXqTzZXXcx4eOQNTy4pQKE/EdBQMxjsx2zGilALDIxUG7WG+B+iH
	GgQVeKXkTASPtWlD4LK165cMqjqkk2Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nFQVeFrO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780407348;
	b=zIcE/tuN87HiFb6inwrCjY4qfgzL9k6qQQZ+FSHetMCYmwDbJLkoW8YdlhiRBUjUiGVVGT
	AMRil2jjzgSuSsqMO24ed25dtQnXr9fh9lIv9ViV7c0sTyzKgmCN7TRfDRnU2RDGGfo1n7
	ZJawEh5IpQhSDpMXINOcHXfOeJwKqHc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D702A60123;
	Tue,  2 Jun 2026 13:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25F01F00893;
	Tue,  2 Jun 2026 13:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780407347;
	bh=cIFsvZ8o1klM9coqPWB+8+5GuojIlmrjo3nZO0SjZgY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=nFQVeFrO5qWsMa3rkGphURuuAJAkKJpVFsxhAS00xM2iY6Xa4CocSyrWIeK+pUzW7
	 9Df0aHNWngtOsJfkaqKnenGpysTrZa+Hp8sGt4qKTmPrKxkTwxdKM94fkhfZWEc0TZ
	 Ks4iNkbGI5vIlAHXND8JluSSRXTaZvzl9muh85TqxIz+GhpKgLyBSBGCUSO6v+xgad
	 lqqIrX6sS9hf5yOus/I4fOyWvH0kYnjk/5xxqsaEkwAR2KP7Y29uc+porWx7LMeReS
	 N7l8mfCMZBxJf+HfOPjNFrawGaeCVtlru1mFpNxoa3116/fEVbQG+6p2/XIrpEQHnU
	 nDuwvVpdeF/dg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] mm/hugetlb: make bootmem allocation work with KHO
In-Reply-To: <ahyAhyVGzXdrigIw@kernel.org> (Mike Rapoport's message of "Sun,
	31 May 2026 21:40:07 +0300")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-13-pratyush@kernel.org>
	<agmS5yZRflzN1M8U@kernel.org> <2vxzo6i37bs6.fsf@kernel.org>
	<ahyAhyVGzXdrigIw@kernel.org>
Date: Tue, 02 Jun 2026 15:35:44 +0200
Message-ID: <2vxzpl29dpzj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 67FD3120016
X-Stat-Signature: sdkhqubmrnkckk7tzt4cn3h37cr9kz9s
X-HE-Tag: 1780407348-759541
X-HE-Meta: U2FsdGVkX1/75d3v5+NNijuSMXwgzU90FvK7wtr0QDoeAO6kgNM7IXxHn2VIAsgVv4hTt8nSX0m+bdAdsy1/vr8EPe9h8mtfiRFTvlswSgFart5VuzmAKC8j26hlvs0kI+uxBtaNffqnRA6QfjI5+fDm0hsijTAMvuBy66AFcnTbsdM1d4gQ8hpvVrA3GV7QeMfUmDprP5vZGYVRpaoZQS4Vo1ARB3VDhJbuo3ctNUPoa+l7og0EE8/OW8kCZtYYpraa7mrQJnu9ibLlWKb2XEzbmixRpcf0ZInDXAaAdB9Zly17tSBv1Dq2SB8ilnvN5TmcUciuXuOGrKGU9smRarv6wLIW1XbJ1Kdene2IDbVf2aXK4FaOosSS/kCtp/Q9Jk97/1kroboh6dM8SzgDVL1ndg59GiOZ26hGm78J+2M5Ymmp7e7dONtHvcdoJmRfcymE9Toyk9eH7qVc5GN/EY4UMD54h0cvogi+NuuG/J0n9X6YwPoGyuL0Is/V7xOPunvn1Q3c1I5Eipp2Sv8LSB4Ph5ZP2wbxVoM6XtU/9piz+rnroeYPpCtRpfK74Jjnu3iWECPkSrz4hw4LbRC6uL1mGbHE/amc+aO94MeBj6scFoO7kCC9NhEvKwecj/rPKPpC+K19dG5mvXo8+U+bBEciKZTTqSYrbGRvCjmbIl83a0MHIU7/PiEXrRvWn/L1IktcNFEg4Nh9IPIAKVagSdAyX9Dh+FPwhA7YT5KfyyLMAyZxn3S1GsNkFXZT80im31SWKkOAgkkymxQPPM8aTWluu6deDOfFsTDbYlHchkAEb8WTC6htMNcggyE9a61tZy149r8ivyabxq0c4/+fG5Jvj9vp0NI/T99D4isaWqu2scmGjtiN9XPqTutRQEhhkQLKtjSB2I9METn1b7RdXE4a4TFpEpf6xF7qtxqwsxkjrCleoMxG75Oogc+wchqGLVzsO08tewCpx6tMokh
 XMslt31g
 6rNkDG/J7PLwC4CS9Xicd5v7bsCDblyYMc6UY3ok6Yuc7k1BGtKBkL2h/CqxiammsNRa4U80IakH8xA2Thsm0EHrvZ7TlDt/n9/BuXIaFWdfW/OFWLOYB+lP2CktKjTfpV3/k6loRnzO+W9A4/5Np1dhV529b+OHlAwPh9Dm1VMcBCuFrSW26mISkS1olXMPbiiX9ZZ4DE3ND7aOs52ZHBWodNuwxmZyW6kZf/3Lr43dWpLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31 2026, Mike Rapoport wrote:

> On Mon, May 25, 2026 at 05:24:09PM +0200, Pratyush Yadav wrote:
>> On Sun, May 17 2026, Mike Rapoport wrote:
>> > On Wed, Apr 29, 2026 at 03:39:14PM +0200, Pratyush Yadav wrote:
>> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> So, in summary, I would like to pursue option 1 and try to make it more
>> appetizing. But I would like to at least know if you hate the "extended
>> scratch" (ignore the name) as a concept or only the code it results in.
>
> Let's retry this one :)
>
> I looked more closely, and it seems that mixing SCRATCH and SCRATCH_EXT
> should be a lesser headache than going with option 4.

I also had some time to ruminate on this. I still think option 1 has the
most promise, but my opinion on option 4 has improved a bit. While I
still am not sure adding a 3rd phase to struct page/MM init (early ->
deferred -> KHO reserved blocks) is a good idea, I think it might not be
as bad as I first thought. Dunno...

Anyway, for now I think I will try to make option 1 more appetizing.

Here's an idea I want to try out: I get rid of SCRATCH_EXT and mark the
free blocks as SCRATCH. For HugeTLB, I can teach the special
memblock_alloc_hugetlb_something() function to exclude scratch areas
when looking for free memory ranges. So core memblock does not get a new
memory type, and the complexity of hugepage allocation does not leak
into memblock.

How does that sound?

>
> Tracking the changes in gigantic pages in hugetlb also does not seem
> something we'd like to pursue especially considering that memory from freed
> or demoted gigantic pages could be reserved.
>
> If we add a dedicated memblock_something to allocate gigantic pages, we
> can reduce branching in alloc_bootmem() to
>
> 	if (cma)
> 		do_cma()
> 	else
> 		do_memblock()
>
> For hugetlb_cma we might want to teach CMA to create pre-allocated areas
> and then it could reuse the same memblock API. This seems useful even
> regardless of KHO.

Sorry, I don't get what you mean by this. What pre-allocated areas? When
creating CMA areas it calls cma_alloc_mem() which calls into memblock.
What would we change about this?

-- 
Regards,
Pratyush Yadav

