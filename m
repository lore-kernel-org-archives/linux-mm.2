Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A037AD25B44
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 11:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13A366B008A; Wed, 28 Jan 2026 06:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2326B008C; Wed, 28 Jan 2026 06:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028556B0092; Wed, 28 Jan 2026 06:52:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAF8F6B008A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:52:52 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2889D40A8
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:52:52 +0000 (UTC)
X-FDA: 84381210984.25.2F9309B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1337A140002
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:52:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C0608Ttu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769601171; a=rsa-sha256;
	cv=none;
	b=p5LlOyDOhdv5J/YVpuCrKItzVnKEibCtIQRQiCYIINqyRpq4y52etnVCnWscsV+tcE5P5r
	3NJrVHBaZCALNeLixHw1PKsALYM/4xo2mfH/v1hI4mXT+hKi7zgPaOScWyS3FlALZ21o33
	qpmLqbKEP8P2ioGHNrOq0C1dyWI/SJU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C0608Ttu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769601171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6mLAVKxlV1psp5WhMmMccch4bs8PevBjlssdyt3ww5I=;
	b=Ev6JIIJ0Sr//a6/Gulc+x6OdSHYuYdILCPFBb0YH2+ITd3+0RoVF3JhQgpeMR2G5jWi6lR
	19LI/9uZN3jXTx2Cg+V7+k2K0R0Kq+hTohxLZSOZHETpqfZdcXEdlswhYoLKmAAj1S0guC
	FXkg2XFria8+7Pf0FRUD7HleIUIvOjU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 75F9760007;
	Wed, 28 Jan 2026 11:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AABFC4CEF1;
	Wed, 28 Jan 2026 11:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769601170;
	bh=qGeiQcnPUREdu3NwgL8PhW+DAcExAANqppOHWMibh1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C0608TtuLAJdwx1KLa0K5cLbb458/bDhbLIzblRKsOyGSV4RJe9vIYW8YMegQfzEA
	 nT70UewOXAYVf1GRY4pc880T3YL3C5cgtXPvflM9zJ2WCQHZlPMV1kTvv4zQ5hOMpF
	 A255Jp1o582c7Lu51oJQp41SxmVvf3su7//YyqKRBMCfMt6wcFdIIWCKjWW7/3aAZd
	 kppBXaQ/GOhtDVgC8ohsYpVBs2nXbCkeYvDjdnGVpc+VoA0uTu0NPzygloo426uskf
	 moHAht3pfr+2hb9QhAMxP9D8qDMZS7Q9dpei5Oza56T1wlr0az+Gilnc5DrN5547HS
	 5KcgciN4WPEeQ==
Date: Wed, 28 Jan 2026 13:52:43 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/3] Convert x86/mm/pat to ptdescs
Message-ID: <aXn4i6Zo8OKyVoCL@kernel.org>
References: <20260127005140.197847-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127005140.197847-1-vishal.moola@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1337A140002
X-Stat-Signature: ccrwyrkjwcjoo575k7494u3fk31s4k19
X-HE-Tag: 1769601170-705189
X-HE-Meta: U2FsdGVkX1/VzH5JcNLqGu8K/CVLpG4Fd/TFVP17HuJGF531xhYF48Yag1iIOcvcqO8UEEFtw2P//KUUHe8b4jY7cW4J67zHv1Demisw3Z6l6kzY7w3yFaIEvfre2gNTDu/hhaQHsSwQ8okiFkPXUFfvlFuY7Nxf0haUIdYaT3jLWFLNAemMSgSBU5vcfXJQvhjOA7SwQYcLlU3CFpStcqihZsPRATyo9U0Dl7GVRjBXEp6JUjrwj/WHhwutQEaqDbOuQ9qiNf+Vh5VZjWAZDof1ej4Kk1lFXhjT52ua9o6y2IoZtBZTrjh1GchYS3ZEPsCuF4Wpq8JDjifkAjRPtfGnVwXZO0C5AFU2fOorT8PRHHle9zzuZEh60bPvlga6UEgq+uEvIK3/FSRZoFRNTJhX0Tv2+DO5z6CPmdZr4CBvGJh/jtdvLD53Tr/50DhxPN+8hnmcThyaoEOd9qaXMaQO37lTvYPuQVTlO909XZU9YIvsSCsFgrgXV0Fac2FxVvEq3QTDPnIW6ZRb/j11RyZ5WoN1b1Dn6Va4yBCYtxVGU0wO2MCNfEOdLk4KkepJ6kZ/EAAz2fBA4Ffsx787JBBgyNJF8QfbZhCW/Os3SeE+ko/wRaixmYIPbJYrtAOD7sJ1dFjgI2bQsTOkVDxLR0CUIE1vpAGGD44QWutD012jtLDkMFpLBn19vhcl4O2eXQKAHky7CpdF2OM7zjko0G0Y4kqBvUFDewytPkW4JTKP1JnJ/LKQhQZvH7zo6qmfIEmxK03Zc2QDUKNWhhTAoJcotmd1gtx3VUWXjSGr8Hf8xcGry2V0+DebTL+0PFz1miuJvvZCB48dNA/vtL1FywNNCyxzaHwTHxR9Lzy+UEfvgtsbfzZAsA8NXxh7K0q3J33KpyC8QmDJenIFgGg5cGVbJQ5xwJuzfGdCL6JrT+bOA25uj7RxA/TkK+N8tCOI0r619XkudNnKmWfFMor
 aJVeeUW5
 zDBFAX+AkU5dezD6gJyZT+8jU+ELxfY7qK+dDu0BPSLZUVpUcsmthUpi7B2Z5kVu56av+nOMON6g3z+cYSQwiikDlFRtwKQVED25AARjToHOaVxf1QgyRI8Hftv/D1RU4hKQ4VCvRPNnNXULVnei8CyJHU4vEM39NPrVTF+41jiGfNQ20oCHSU1SQ2kJCCEoR07jWR2WRC9oRPdgeQPWF2NwVdJzOjqIp65wkwPTyVyuBdafevwGB1wr4EsjT2Oya5k5A/PtoLzGbOJHaRPgM77tR2Er5In6MVVSXm7fr/rV4jkzsYEd6iTYnYG6+Y3tvquor
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vishal,

On Mon, Jan 26, 2026 at 04:51:37PM -0800, Vishal Moola (Oracle) wrote:
> x86/mm/pat should be using ptdescs. One line has already been
> converted to pagetable_free(), while the allocation sites use
> get_free_pages(). This causes issues separately allocating ptdescs
> from struct page.
> 
> These patches convert the allocation/free sites to use ptdescs. In
> the short term, this helps enable Matthew's work to allocate frozen
> pagetables. And in the long term, this will help us cleanly split
> ptdesc allocations from struct page.
> 
> ------
> 
> Based on current mm-new.
> 
> Vishal Moola (Oracle) (3):
>   x86/mm/pat: Convert pte code to use ptdescs
>   x86/mm/pat: Convert pmd code to use ptdescs

There are still get_zeroed_page() calls in populate_pgd(). I think they
also should be converted to pagetable_alloc().

Other than that LGTM.

>   x86/mm/pat: Convert split_large_page() to use ptdescs
> 
>  arch/x86/mm/pat/set_memory.c | 37 +++++++++++++++++++-----------------
>  1 file changed, 20 insertions(+), 17 deletions(-)
> 
> -- 
> 2.52.0
> 

-- 
Sincerely yours,
Mike.

