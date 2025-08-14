Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ABC1CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 23:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B59D9001F0; Thu, 14 Aug 2025 19:24:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D229001D5; Thu, 14 Aug 2025 19:24:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CBA89001F0; Thu, 14 Aug 2025 19:24:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FEE79001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 19:24:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9DE411A080C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:24:08 +0000 (UTC)
X-FDA: 83776943376.26.7ED30F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E494DC000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:24:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0jiS0MN4;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755213847; a=rsa-sha256;
	cv=none;
	b=PY86glpG6dI5IX4jTnuNxhy09eriBN+PsOys2fgh19yKlPXPUTrdkohIARvtKvvtHTeZ11
	s9B4X8QCOQBEUm2wIW0UBVqZx1x+AC2jV1jBloG7t/mH8l0TOuenYzMxgSAq8y+ULSZkcD
	gc7Gmp0Eo4Tu9t0wO/X6FQ16Znzi8f4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0jiS0MN4;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755213847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41vZQE4qVj2qb70cjSoEC4RwtvqSxYt+zihXufpvrB4=;
	b=vxBln32m62hpzUMDdt7WS8xZzK8aOUVZUelYIsGwCz+rCQ3VQ30hsvG8yL33SrhMpOI+AN
	D2ZK5WOTS10orq+NZnsS1gvX+QdMJaEVCCe1WrLJ1PTje0kkF3sFnAbmNGUBJRl80R7LkR
	jI5YunUkiWh5zlqnq7mueJgl7iyvfZ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F1C8C60053;
	Thu, 14 Aug 2025 23:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1B7C4CEED;
	Thu, 14 Aug 2025 23:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755213845;
	bh=Lt6jBIulxaTo9RIUgXftMb1SwjwcRMNvaTJxyrnlj78=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0jiS0MN4/TWhe764dHWzjTgvAGMJecSSdfZWFOkJUS7BuIjhyZKOl+A5PrqjFOduD
	 IsxvOxBO+k+v+PziyRQf+Q7TQM0DhZnFEQ2PaknBTmYhxEHSQRHua4azWjzIgmIkiW
	 ecFxYV+H+SUkeqY9R/HRVhofTlwwyNEN4NBGc7RU=
Date: Thu, 14 Aug 2025 16:24:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org, x86@kernel.org, linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
 nicholas@linux.ibm.com, christophe.leroy@csgroup.eu, Rohan McLure
 <rmclure@linux.ibm.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v16 06/13] mm/page_table_check: Reinstate address
 parameter in [__]page_table_check_pud_clear()
Message-Id: <20250814162404.e3a0f12e2aa1a87de51322e7@linux-foundation.org>
In-Reply-To: <5aa057d0-dc76-4723-80d1-82065320a428@ghiti.fr>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
	<20250813062614.51759-7-ajd@linux.ibm.com>
	<5aa057d0-dc76-4723-80d1-82065320a428@ghiti.fr>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E494DC000D
X-Stat-Signature: 3mfw1bg1bjogz989pk8itaafafo7ohe1
X-Rspam-User: 
X-HE-Tag: 1755213846-267469
X-HE-Meta: U2FsdGVkX1+XfE5x/Ze3sTGoO7vdtrFyyWLPzA486l8m1Xzg0dwjPSGNohvJh/g9PuKc+/haUswNsGQFaKVZqT2eNU/m60reOP4HMo5ARr6e45Udx/3xOxxoAVVZmvvyCnOiOTLhmdEDcl4UnnV+R0Vru0USsT+UGm3sjzOesLVNNNU+XMhropsj3nV2P4At1XGQSLzOTC7c8/KXpSFZWRI9DHSvIMz3jHe0qLMeSMvKzbRZ/g9mu9fTt1G4hjyYGuTTzaumcu9ER8dzyOeEVqZbSWbl6qlq5bMmIxsUFvpElhtV55fMEfdB6MC4YGd2wA66VAo4E4v6fvfeUyJXjfD4UjUNSxsTvejWPRXK9QPA9DL1VwBAByxA0b7cyUk9uCQpDwQkaFR7lgtY/rtkUPxR2OCcoUiC4JWqSeXwm6GCeT4Zp50pW8gQvDKiodeXoidkki97Q6SNjB8VI2J4X75rstIBS4IgieLst2l1MPxHb3F0ScntG+ZEZCznbdk1t8D0k2xYSIGl4DPSHcpGF4cagx7eCZYT3bq4CFfLYvuwv0V0iu8nNffiPl77PMx4KU1aidq9Gk/7/8g/BW+oDhYgr1VKf7phxMrWoc04aYFGJC2ShYBHE69iCX1UnucywhAJOHoQYkbnRgh6nQElsCbRZMz3PZuPZufuK9V2+0yp1IZvZM/fcYWxTIdxMdRfpvdE/VSvqf8Vf/IGmAD3ol2laRL3U7BXUrALckBqk/5r1DcDKlFy+siD3mNMWlXhEW9QTa30lsiU28/6q+0s561mpA5tedgMfBGh/BJiMlHIl260mPfQ6bHZeVUlURjXzkPMXm3OxgtdusPPgKxc2ElUahzpxkgEh37W5wgA83hA6sibY/XIhdzlcPL4lCFJfda78PQZNyYxOhVy75x5m8S6VR8PcJ0BBtSaKTslTDLnXh/FlvzcA1yV1DBln6ihhfQ13IBdFcmikM6Q4OR
 pSmSi1ZL
 aj5bBkDZpSWRX43Dg5jSZXWDAD+1YE1a8UIP6C94Hc0Pd93sS6fVpyMjUTc9o3uUoulmbbh0q4Ii4Ne9UKEcod+t1KTzlbqkDsDfY33CIjm0gPx0i/C8lbdZ5MGAtUZmhMxMt2/NqU2G0TJUOHyTyEc4+VJ/jGVXcJwGe70SCLfNKAEVXT8WFDEDnAeNrqD6VMUnPvhLpKsAMTsbrvDkCpSWe0/g+5N+WUevI6KmOcoIPpDPHS80zUX9Y4uQoS0KYXmdCjkUb6AuEklNGd1Djv0E5pPnKY5+cbfuAOphpzINmns6f6Jdb3uZ4spRMgL62A6NxRoloagmTz8rBOqliJHEoSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 14:11:45 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:

> >   	for (i = 0; i < nr; i++)
> > -		__page_table_check_pud_clear(mm, *(pudp + i));
> > +		__page_table_check_pud_clear(mm, addr + PUD_SIZE * i, *(pudp + i));
> >   	if (pud_user_accessible_page(pud))
> >   		page_table_check_set(pud_pfn(pud), stride * nr, pud_write(pud));
> >   }
> 
> 
> So this made me realize we (riscv) did not implement 
> pudp_huge_get_and_clear(), which was a mistake since we support THP PUD. 
> I have implemented this function in this patch 
> https://lore.kernel.org/all/20250814-dev-alex-thp_pud_xchg-v1-1-b4704dfae206@rivosinc.com/T/#u
> 
> That's a fix so I'll merge it in 6.17 (at least I'll try) so your 
> patchset will break the build on riscv, I'll keep you posted when it 
> gets merged!

Thanks, I'll temporarily grab a copy of your "riscv: use an atomic xchg
in pudp_huge_get_and_clear()" to keep mm.git compilable and testable.  

