Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 573DAC5518F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 10:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2D76B0088; Fri, 20 Feb 2026 05:25:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4CD26B0089; Fri, 20 Feb 2026 05:25:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A862D6B008A; Fri, 20 Feb 2026 05:25:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96E5E6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:25:46 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34473BD886
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:25:46 +0000 (UTC)
X-FDA: 84464453892.21.F9AEA6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85567140012
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:25:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RN7maaPJ;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771583144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KSFq/eMlnsGxU/O/AIGO+U7y44qkWS2NgoGDTmE/KsM=;
	b=s/7ZV0TOyz6ihJuijIqkXrP3SQYjAfBBrfhwkeG0hAzStlujwunL7DvJv0VSZMNdK7Q1n0
	uf0EsdF9QhWE6VdaX7orp0XtueaAe7xGTSyY1xN9bGu7V1TxzauR+ezBy/dq8pENbFLULK
	ptsGKuU0/XMxEx8mb1fzejuNmgdJSOM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RN7maaPJ;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771583144; a=rsa-sha256;
	cv=none;
	b=d56lCKLmWN5DdKJ2AcAp5IG9jFy4KDgR1Dy6v+tfVsRGk4jNzWCWlgvRIfn+freA6vY5WW
	09U9M1y0/QYv2c1QoqiKCg0l5HpvEsabIlTciIpqwj6BRf3GbPS4aVKmy6MhXtebqjfxDp
	Mvc+h0SiqkjH4XFmTCkzJoqdE3cC6Cs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1677A40D79;
	Fri, 20 Feb 2026 10:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09801C116C6;
	Fri, 20 Feb 2026 10:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771583143;
	bh=fHah0S5EiDYqAgVFYIH+gMaVRw0f/1dDoBvuNE5U2VI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RN7maaPJvT08Xjj1xqxQX7/6YIpJ67iktTwqQUoO/AuJZ/51ixeV3h0DvF2QGF9n9
	 qVNhmzOUKgR7bymsT+7lLXaoV3MQNZJ/2jtu0D3kRHqbUN5jmN6oUv7GjFxlOwTFkH
	 1TwIl/N3tp4jqHzj7JmBJj8OGhRLNA1JGHokVT1OWfvA9YpIeb1VZDrsWdMZCdv0bN
	 i/QjySoM1tg7kYeIQFK3UytAVsfnjzQfbstOvjsTcSiVVuLJhn1pgejcL3kknCkf2e
	 ogEYWRK5OdB5mD3k1e75M47/hvMVIcRhGTZ+Cc7tZwpQT3qF1I3I0geNTsv5a8NWbc
	 WrVuYRNuVbz5Q==
Date: Fri, 20 Feb 2026 12:25:36 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	akpm@linux-foundation.org, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 0/4] Convert x86/mm/pat to generic page table apis
Message-ID: <aZg2oE6FshskL_Kb@kernel.org>
References: <20260219020354.321088-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219020354.321088-1-vishal.moola@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 85567140012
X-Stat-Signature: x4djud7u8a31sseqgjhpkg18psq1o384
X-HE-Tag: 1771583144-839223
X-HE-Meta: U2FsdGVkX18h4ZYI34Rx7U8rnh+uWrIDvMh1tp01Mcny64RIbWxr6YcjlzzQkdSghe3vvUx9wl5XBg8p1aBFXGF3pWbP+pHM+bDHn/TTSAUo1J7NBvhLaY3YVUIzVX69V8mGHSRocGiQOfVxQxqi80rxK56ImzLN1axTTSLtoArDTAp5GtijsWsj2Ar7fLotjeC+UHTkidO/E+8brWW4bQtjD7MM8afq7lY3sVTnVhZV/pg4Q5ZSVluJmYR53rt7wr7L7vWKeRIssMZyeqyU039abWhT1+Zz+HxMakprXihWzJld19SvB0i8c6wiXKuueYeAdvdptyU5Jr3wQABo0HQC6Kn+rQkwqXDhzQ6eiItFGnPH/VCJgMYbGbu3eJ6GUwA276sn9vtRNrEEqibq05ygXHZGjHxP1KcdWE25AyDBHgpiMLVdx4yPhIo43x0ozfKr25FsNHZwqTMthqnyoRak5MrUnEaL+aCN2YxxZwYyLwspIqik7p3vOi4YFHU84PaTZY7umJ6Iun0GfB9at/pkaD7zwjsq1NBaqciDcsp95RskLnz7sgDF98/bMRg6Mb7Htd8rdpJMik0rIue9hnSUWZb6QRDvTGo0IE3SwuVJyN6u1U6xEw+CvuN6fNM/WCmIkRpyMyQkVYutRN5JJ3shCNjUnhlJwwMH1wg2BLaoagPBjK2x+B3ZGG/sf2JyN6KeykuAVeaYcweVG3kX8z1mYw1NqURsECxe5ePFa0LYI1bd5/BD8m7MDdh1xmnufJqDVUX0eBR7/As3DYnX+azzjKKoIf3MYNBwX+3yxJeHoBdd5/WtJvfVUg9mNH5f+e0V7TXKs4ut7RFbVXDTDMTJyc5yPq7fVQnA69MmEVWNiK6eDI7ki/65GrTxH1rNQpjFiRR0/cwf4r3FJifwZUoVx3NCOlDsy5Vx536a3d67+M3s4nVyPQsFrCJanGZnfCuGHloCFAgTiKea29Z
 cQeN//s6
 84j1w0K5ePSoZF5PSh/kTddRtCO8CUF1kO6VHz9asM0weOC+bwuJESxXXa7c5MeoVm82gp0wz8l89KHbqzL86rEw6agZl390nQ5KDBfb5L+EHLGIBM6lfHeVfeC37ki+5lbApjFQvGI4P102suO2bJMllN5kzOmdGNRbZbQ/ESG7aH0H4h7euDKz9+PCPvsVCNMJXzQNSbRfDVnsvw0uW+vUV3XbnnwQv/7URc6rxLqWT/y9++yDG4b4sGlovKGfo1S0yCZcIj5VAzjQrnaQYvsDdhOnCPAoR3l+uuAlBqKHi8/+kBwBczSctV6jy+w3fW93TVYCyEwwSm9dru+qOs9kY4UAtmIAWOf+5+wjPKqpaonO0xUiJXASlXOUNc5grAoOs2NUUSzBp0G/wgYcKKCMWWKdMYKmD3SsyNCViPUQ4Cx2BWnYySO4kIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 06:03:50PM -0800, Vishal Moola (Oracle) wrote:
> set_memory.c has a call to pagetable_free(), while the allocation sites
> use get_free_pages(). This causes issues separately allocating ptdescs
> from struct page.
> 
> It turns out that we can just use the appropriate generic pagetable
> apis for allocation/freeing. This helps simplify and standardize the
> code.
> 
> In the short term, this helps enable Matthew's work to allocate frozen
> pagetables[1]. And in the long term, this will help us cleanly split
> ptdesc allocations from struct page[2].
> 
> [1] https://lore.kernel.org/linux-mm/20251113140448.1814860-1-willy@infradead.org/
> [2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/
> 
> ------
> 
> Based on current mm-new.
> 
> v6:
>   - Drop the renaming of *page* functions
>   - Use existing page table api instead of creating new apis
>   - Split the pmd and populate_pgd() changes into separate patches
>   - Reword the cover letter to describe the new approach
> 
> v5 link: 
> https://lore.kernel.org/all/20260211195233.368497-1-vishal.moola@gmail.com/
> 
> Vishal Moola (Oracle) (4):
>   x86/mm/pat: Convert pte code to use page table apis
>   x86/mm/pat: Convert pmd code to use page table apis
>   x86/mm/pat: Convert populate_pgd() to use page table apis
>   x86/mm/pat: Convert split_large_page() to use ptdescs
> 
>  arch/x86/mm/pat/set_memory.c | 36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> 
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

