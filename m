Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBDB8F532F5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A71C6B0005; Tue, 24 Mar 2026 04:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358486B0088; Tue, 24 Mar 2026 04:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26E416B0089; Tue, 24 Mar 2026 04:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 129CB6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:39:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A83514184A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:39:36 +0000 (UTC)
X-FDA: 84580307952.23.BE58C59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9A960C0004
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:39:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M/UzrF3R";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774341574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQJSjRpH2rfpL38PsSak6lUUtCSpY4GQ3kR34gXO9M0=;
	b=30f/GST3JZiwIFC+vuSI3RH9HJVNT8j1TENAKxbMYPD1sJnfrKzd9U+LxTFqEjS+y6SuG1
	Tu8mYxYtyCo3kxsv3QgxZg+M0x24ZzVRqiFLWbbKl1c5txGpSy9lJjWZ5+pSzy0GRdVZVG
	BXo/cnhH3xu91EB1Fi5uBfgM5oUBSEw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774341574; a=rsa-sha256;
	cv=none;
	b=tGWHDJVcNHJ/7AsApXVNq5UoLXQodwm7+dteWpga9KQ5H37lybaMLDmjWnR4CuEvlgdED7
	DeFHduL1JBCIv8Yj1H02veVB2fjcUR0RlcAdbM44MDC2eh9ANlrbQrFf9J5GfVZCTdCQFs
	kLl4eR4RT4DqCepc8ZdlyvFIAsGmTk8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M/UzrF3R";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44E67437C8;
	Tue, 24 Mar 2026 08:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E084CC19424;
	Tue, 24 Mar 2026 08:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774341573;
	bh=OtOjF7Mt+dJ+1ARMRcLf5kZ/NDUv+K1d9LWNs6dcnt0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M/UzrF3R7Q1imKzJ2jhgsgeRthZOiNg69HFBVV1fWSI5imjY60puN1El70ZIZGBf2
	 D1YZk+0rneTPNYtbv97N78D/aWJtS3Nkj0jYj0XJxctzsupvzCdTBqQNVt0X6KEyzy
	 hM9COTrvPfHngvFkWcRYMHiAEty1iOudMQ2+m0w1iBl/ydbHmuDHz7Ot6HvmKFqYC4
	 AaMLYY7Xz/zb5TqS9wb23nYFAPRV0MuRMu7IlNGWpUfX/DdWHOHTwfoLy0QJh1rHvO
	 rp3NsYWz/v3KvPDiIEy/GyyqlF9XXPaMUSa3KNXT2TwlpkLhyuq77OE56Py1WymRY9
	 TZGCop/8hv1pQ==
Date: Tue, 24 Mar 2026 10:39:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org, Alex Williamson <alex@shazbot.org>,
	Max Boone <mboone@akamai.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memory: fix PMD/PUD checks in follow_pfnmap_start()
Message-ID: <acJNvA97csyxd0Ml@kernel.org>
References: <20260323-follow_pfnmap_fix-v1-1-5b0ec10872b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323-follow_pfnmap_fix-v1-1-5b0ec10872b3@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: 4pijyx871mwfeta1dpdf8b4wxd5suq44
X-Rspamd-Queue-Id: 9A960C0004
X-Rspam-User: 
X-HE-Tag: 1774341574-273861
X-HE-Meta: U2FsdGVkX197KNmI4OfDZAHMvWatU3mNqkbtyvjKZCm8C1rqIF7UZj1RDIxtFCPRGHV1byeKCwuRSR5Pnngcd6nYt51qhL3d07/ulARIbyzVaD0L8dHdGpgGEZShn50WXkNL5g3GapWgGrMdgiVQA2im+rRbCVCAega32dibAhnL5QMmCfiVk5gWys98wCorZiHWzmvKzllNn78N9bEIlN25MHZSfEt5Fr1fi93kFdwSTpCnHJnu1s6+6gbqzsPTex3CimTDsMln0aEpsLlztB+WcdcDtkPawQNh9rSNAIKXItou8hivhgDillTRemW7LFqqowKI0ZpGmGUiFqYqDftOkwzK8eXRHQB9UQYN2qUfYHYY1sQgaTR2k7Oa+oLsqVf8QIf1XAOCm8i7Wy8q/n9lA7wzFeeMV6UjOFSySYrgg5x76j/3EtvceiriVTirJYuLpL4X97vdt8jl03ofhSNGR6+Pv+0fUBtXN5IXznSLvvpqfJh2WqSQQ1Ai/C5/nYDQFs++YOGQNj2eLnUKvvuuHHY/rvwK4fOtcyhelgDmQ/i0w2xCs13owYqCgpwJOFmwyHfHFx0P5ub5zPPsAk+fWCw1OhMJMZOWG1IucSeGOcmzVU52ygMOC31cUi6SoH2XXtELwvCt0wIxtzgCaEdayGofOREw2C3vWJmtQEMuAZzjdOCegZUKCGfyeBWrRZlg6+nKmHU19+yLJAq4j9T/vhewZzjda3cq12/ouPtVnZuE0KkqVFfWmg6oyIUINJdoxh38TrEbiPZ+nOgT/38GnIJ88ua9Gjj33Y2zwQaNxCy2em0pCkRZtov8q8w/B4y0NHdyT8p5bsUVY8GR5XreOWA7bd/247N7zFTxQiwcu94/gDtqpsptYYGwskK/AZBtIxj57SC/UAhPqw2p7OTEBzQc73kIq72SGFrTB7gJYyQ9ORixItevTv1f8XDbLf426nBkg/vFlJIQLNv
 eQhdZFpM
 PgaA8qJh7KOcXhZs0dpjn8bww8jX0kD8Vibrvtc1Omiof4XSNw/GZNmo2QppJ6rUle1kJq9FBvc9SplbNvH0w7a3Aq5wXpXkQTY9eyce8+OjudATYSN850uu8FK4/Zdq58mE/0NAK60wBk1Y0PEOK7Je8j4DGH1WT0bbLZnMcCENQzSE24G080/DR3UJQXpNQPNHgiZ+ujiDUChnZ1Mn0vGoUVvPH8U/ctMBUiHk2tUgGhJ/hWN5rkFBqM92ZGnBbvHNunG3Z2EGlit3/a9vuW6g5vSm1pyMjcUt6v1l5Tbd5O01Dn6mO9gk1V5AeBXyq3CHxM+blOIGKmD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 09:20:18PM +0100, David Hildenbrand (Arm) wrote:
> follow_pfnmap_start() suffers from two problems:
> 
> (1) We are not re-fetching the pmd/pud after taking the PTL
> 
> Therefore, we are not properly stabilizing what the lock lock actually

                                                    ^ lock lock

> protects. If there is concurrent zapping, we would indicate to the
> caller that we found an entry, however, that entry might already have
> been invalidated, or contain a different PFN after taking the lock.
> 
> Properly use pmdp_get() / pudp_get() after taking the lock.
> 
> (2) pmd_leaf() / pud_leaf() are not well defined on non-present entries
> 
> pmd_leaf()/pud_leaf() could wrongly trigger on non-present entries.
> 
> There is no real guarantee that pmd_leaf()/pud_leaf() returns something
> reasonable on non-present entries. Most architectures indeed either
> perform a present check or make it work by smart use of flags.
> 
> However, for example loongarch checks the _PAGE_HUGE flag in pmd_leaf(),
> and always sets the _PAGE_HUGE flag in __swp_entry_to_pmd(). Whereby
> pmd_trans_huge() explicitly checks pmd_present(), pmd_leaf() does not
> do that.
> 
> Let's check pmd_present()/pud_present() before assuming "the is a
> present PMD leaf" when spotting pmd_leaf()/pud_leaf(), like other page
> table handling code that traverses user page tables does.
> 
> Given that non-present PMD entries are likely rare in VM_IO|VM_PFNMAP,
> (1) is likely more relevant than (2). It is questionable how often (1)
> would actually trigger, but let's CC stable to be sure.
> 
> This was found by code inspection.
> 
> Fixes: 6da8e9634bb7 ("mm: new follow_pfnmap API")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Gave it a quick test in a VM with MM selftests etc, but I am not sure if
> I actually trigger the follow_pfnmap machinery.

Most probably not :)
KVM selftests might, didn't really dig into that. But I doubt any selftest
would trigger potential races there.

> ---
>  mm/memory.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
 
-- 
Sincerely yours,
Mike.

