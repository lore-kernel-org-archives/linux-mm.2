Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DA11CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26CF86B0088; Wed,  3 Jun 2026 04:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21DF56B008A; Wed,  3 Jun 2026 04:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134656B008C; Wed,  3 Jun 2026 04:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 066166B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:39:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9F79B8CF95
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:39:10 +0000 (UTC)
X-FDA: 84837951660.05.8620CAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 00491180006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:39:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i98P46mH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780475949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKr4pUf7s0iQKui1I94X0WI85TpgG6R24P5fLVzYq+I=;
	b=qVYbWzS3lE6ANcLYPOHB5uOpVhDvU52kLpHKUaETcWUnoB8Nsk5Uiwd/xwNZ1iePy2PrqU
	OthCGTkEZQVOIOXTeK7Wf36h7AMCsLWvbiljum0xGw2nXE8oLWERQY6iTMKddcxKDRsrfW
	9+j8p+YqiMbe+IWMZ6XXR2SSLlW3uXo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i98P46mH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780475949;
	b=XfXQXSHQju/nOrtjjPi1plm680qKduHOLNTOR379eL1ceSvUWcZWomp6yaCziQ2yrRRBDT
	/ha90kLNd1NzDMYggWU3/KvS8dALpo72BV8js06CVqQ6Ar4gxPpYaMG6sR5Jaf03sM2EV9
	bWIBCuqxUS+0ga1+so3kMaUexKpgj+s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5CEC43E5E;
	Wed,  3 Jun 2026 08:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492E11F00893;
	Wed,  3 Jun 2026 08:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780475947;
	bh=pKr4pUf7s0iQKui1I94X0WI85TpgG6R24P5fLVzYq+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i98P46mHgVeg+UxDqZZWoEzhKi1tPOQXy7qPWwBJVFxBJ0k26UtD5ig0yvDTl/Xj7
	 u9605qUhGM5vFr8e4OM9GCpYkswEqCDCmDVu0Ork21OvSdUiw5b/8tiaqOliWbKMy8
	 GFD0BjTBBU52GOTAz4REmcKEU+MRRaNv9Ig5aHSButGWQTNfeHBYti5d3MLNKhHS2w
	 L+jlZWBwEEdRIw9R+wG5AexLma0a+fd/YFv+K7RqYUP73b5vsNUBYdqYLPM5f4J0ze
	 4TUG6S9bhRKLOVEBO1rp2FcqGA0gQs5KGd6oDXagyO+NLO/JcAPtqgOP4/UdxPjZ0N
	 5/21fSatppZuQ==
Date: Wed, 3 Jun 2026 11:39:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	liam@infradead.org, mhocko@suse.com, vbabka@suse.cz,
	willy@infradead.org
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Message-ID: <ah_oJEODZJp12oDl@kernel.org>
References: <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org>
 <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org>
 <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
 <b5b1a7bf-de6a-488a-a011-673c37bd24d1@kernel.org>
 <07334dc3-79ba-407e-96be-21ceb2eec00a@kernel.org>
 <ah8Tflgn50DTMvwl@kernel.org>
 <ah_ML-Wm3B92ZniC@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah_ML-Wm3B92ZniC@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 00491180006
X-Stat-Signature: tmizchoktiiqdcu3hud16j64zqsgzg7w
X-HE-Tag: 1780475948-316111
X-HE-Meta: U2FsdGVkX1+HwrxBhJwh+T8kSrE0QW0wn7ziB/76LJ/WGLQxVBUNuDv9lTKTK9o7S1Qky5euaQVr5ILE7UbdKcVeJzIbnxwPpb6t0s1d6FA6J2Z/BF44ZZtSsJAu/vbLLIh0PopuuOxhl2o2chCMpNqqS7w3qnIVC3/NRYZa5Z6z7hXujrq4BfqtsWXcKwWyEIYg2vDVDE/r6TvJUDvqoin5j/2d/dZnQr3N2KbNdIWfxaNMThcDMuGUm7V5orM1jBJ8+aqeN5eytuCJnbsg9+U25roVCV3wyx+UHD8GVJq9ddU211FzpUNGUXxqVVAgWyXq7HmA2/LDFSaJXzEbDocTN94cjuKZ+HfUaF7sbbrIy8sGqOIcYWViK3zbKzVJJnEIqFFR0qgD+b8nO/I06OeuBUcvH3bPnPuqOlm7NQZKE1QMZs0/nR/Yo8hxbvWp0iNqpdAGSwAtYKl6NmxM9pc+ALcbl1iuyh5MUJ/PE5IgadD8IbOA7+yNSdfMgRCWs7ALqe685VRANULItTc4imSJE+14yIiBJeN4bGL5gtFPk3SzTfXAyMGLEiFxW+fAq54a2rBdxUSmvmMVit3EeeC/9DSK/9Kyyj3CUq2Z6mo9HGWPYgGBaJPyDyZhwOKusZE3QmrzWEORE4vqkkymZzx5mJ7Hi4G/qMJh2e8BJThMVru53Z0wVt9JZ7+KE9wBY5jPrwc+jprXpHbllaZi9OAim72ysDdrrnlvIlvftbisCyKuw00CzG0c6Nb8mEyj0iwZSaYaomWpXJ7hv7E+jPnPRvKlh9NbpQtj0O5iRnF64b7xOkX5GHncDOvRJMG2Uy2w8/FIUDXwEJHhY+Lza9Z7WHlPiYZIt54cTAD4Pqd8nC6vdfOoyVaWtwX07Yu2uteyZI6DcMeZjTZnSUdscXl/QN6JjIPNLmVxMFL/C6SGdzmVEudzQc2NbbuSx7tXMzFGCxEghRwzisMGz/7
 FbI16/AH
 1klh2hdfDgCrDJjwyQUcksR48jbt2euxoEODDBmCZ8eA6SHWeY8t7W0zlUv+5VWGIP//c/McZzVUhSOxme0bkTaiLLJ0cTvnoj+HAFS0c9RYtz3woikMTNOQztcz/86M2AzJojByxco7Lf+FQOQZisQKjNAjJ8BxBzNXjObQLQm3x4BsE0ZhDcNGXTCHjY7WvjeUwKpb1yvoKVRGDPJIiJ7+oElmam/1mxirAqGgSGNzr9ZFmisNkaQepc0p55wbu0oVZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 07:48:46AM +0100, Lorenzo Stoakes wrote:
> On Tue, Jun 02, 2026 at 08:31:42PM +0300, Mike Rapoport wrote:
> > * Supposing we keep the model of early merging for testing [Lorenzo, don't
> > yell at me ;-)] I think it's reasonable enough to drop everything that's
> > not going upstream at, say, rc6 and ask contributors to rinse and repeat
> > after rc1.
> 
> I won't yell :) but I really don't want us to do this, and to improve our
> testing locally. Because:

There's no contradiction between improving our local testing and allowing
to merge early to expose to the wider testing.

The merge early is a part of what makes mm community welcoming as opposed
to tip's policy "only 100% perfect material goes in".
 
> - We've become a bit notorious for breaking linux-next

I don't think only mm breaks linux-next :)
 
> - It makes it more difficult for us to yank things

git rebase -i
 
> - It blurs the line between the stable branch (which in the new model we will be
>   updating constantly rather than right at the end) and some 'unknown state' of
>   'whatever we just sent to linux-next'.

The aggregate "next" going to linux-next can include both, stable and
stabilizing parts.
Or they can go as separate branches.
 
> Cheers, Lorenzo

-- 
Sincerely yours,
Mike.

