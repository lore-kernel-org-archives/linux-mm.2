Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05678CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 08:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4243E8E00FF; Tue,  4 Nov 2025 03:52:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4AE8E00E7; Tue,  4 Nov 2025 03:52:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3C88E00FF; Tue,  4 Nov 2025 03:52:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 144A08E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 03:52:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B35C1B9807
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:52:07 +0000 (UTC)
X-FDA: 84072307494.19.478FD4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 30F6F80010
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:52:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762246326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DKF8DXpRe5ZXoRWHf+6DY2U+Qkeuzaa4vmfNWHu5yU4=;
	b=w8tzVvyVgOsQIGwRrfNsS93HLn4taPbiTeIU/GaLQ4HLRHJfseK14bk2Y/IAJO4x8wcdJb
	uSkSEacEq3A9Za9oD/c27BmRMJumCt9wbwE6kvS8HdbUli0MkR4nO4sz6obOg2Kv7ODiw2
	Hq9gbqJqs36DMzM500vUQDzdHBB/x08=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762246326; a=rsa-sha256;
	cv=none;
	b=4/TtOBCdFQh56pYX1xXif76qNxflt90BQHgO2PZmo9eee1R6WmRP9iI5NCAdF7l8udxKdU
	IhYKYMC6NnWKSV+BFQC2Y/HMMaJQnONxdVGYoOVhmd3rAciR57xLMy359uZDixmOf0jnx6
	v+LSQzyNpAAXIxfgVjKIPGlEEH3eqHY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 466AB601EF;
	Tue,  4 Nov 2025 08:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92586C4CEF7;
	Tue,  4 Nov 2025 08:52:03 +0000 (UTC)
Date: Tue, 4 Nov 2025 08:52:01 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Mark Brown <broonie@kernel.org>, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Aishwarya.TCV@arm.com
Subject: Re: [PATCH] mm/huge_memory: Initialise the tags of the huge zero
 folio
Message-ID: <aQm-sVxuZdw3bl0t@arm.com>
References: <20251031170133.280742-1-catalin.marinas@arm.com>
 <aQiu-hU3x5V5drHF@finisterre.sirena.org.uk>
 <aQi8dA_QpXM8XqrE@arm.com>
 <79a1f2dd-6752-426c-84c1-a38d300eb78c@kernel.org>
 <aQjRa-Bh8J8Smgur@arm.com>
 <20251103170547.4935d9caae8bf558faa1b04f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103170547.4935d9caae8bf558faa1b04f@linux-foundation.org>
X-Stat-Signature: 31z9u6ato6ehosz5gsirqkeyn4n3fqy9
X-Rspam-User: 
X-Rspamd-Queue-Id: 30F6F80010
X-Rspamd-Server: rspam01
X-HE-Tag: 1762246326-716
X-HE-Meta: U2FsdGVkX1+fJqoqrS6r8fSE6qd/Rsk5opN8dCHweFx3bQOhNCxNvS6VmrOBCwPt6MIROMomdSIRdLlRSKlt+Yej7xnPZoXyabzTXv3JicteuJ2mb7Pt7rRKI2ijuxKgxR0tlET41Kw8wNBMkJoOUWBj2iDfWIfIc2ph+WIGim6MlF0Oy4E6pnW9zFehYDEMcx+XZZ2HyKDvtMJYyv98r1c0SbydqGaChmotHuPMMEoNnmRjGFGUgSMiGooq9sX59n2QLZG5ItO1sg86R9ZaptbX2aYQwbcFoov0XKOn/Y8Uq2Roh/4edV2LmUf7CDGuboh5rlU0k6ZBSNpKXiAo6xnn78PEpvpPq36cbSNd0R48zwwPsXxEBYaKWm72c09e20w1Vllopd4WCPh0cO1FpOJHYF45FhUiZP5n/nY3hGoiNyuub5hSxDw8EUo0Y4IB/g7hLYybeIqBtP4tX7RjaRXTN6EejhYHh0FaV4TRNsIHKIJB9G/apm70SoQ4r3pccV0qJvY66+hjmKP0HqvGvQfFjit5B4AIicMlXsQepssJGWuPSDuElTLxVnwOZf1GlYjlePgxBeqT2c7apQudg8dAv6M//JB79UgemihBNqNrTOlaPUlhYZMpn8dyWNOxrvSObwS4M32OMdQPyJaucQ+irSTOLuHtA5eQ2fLpmh0XA8J13M10h1C1arjHWl79VP9aXj4TEfp44GfSm5ZqdrWNLN6bhjDVpLzUZFxe0IlrYNhRhwgDgm7SRHU1eJGurx5zSTjR1y4pYMjq813jJ+ZdRgwvi83kH2J+OD+ep9aOCqzi+TtozLHL2qb3eQXjOnlPiRK1WCM24QCkDzgs68LyL4eaHvKiSiKpYD/ek6cVpxeWDvvLjRayOhMyRqljX9q/naW4cRd3uN/Zuk554arECMq2lkmiq8S/3to/jLjpia5LXJJcBd780aIjzM+clgLutYlB83GboWCTiBM
 0q0jdHXR
 mtyNIzU1FlB4DXJu+9R/1S5txGzEwLsH9aWe8u4s/6dFVaKrlZbJad6+u1saeBoh3GXsdQxM7A6wY/h1ObVEYmWnhHk09w7C5sFcH0xCI1uwrDiMVYLtpQtHbZkXb4lLMrE3a960I1zxal6lhHCI140nSpS1AW1b5L59HgHXwrHqEImZ9RRSw/zNDVsbJZ0BALvak4OLNaGr9OcMMHiuWn3LtCk2a/04Z1Rzh2aLpwPnV3tgXZnlE33HVM6Ehao9OdsyPTArbUHfIjmlldGw7zi5umJGWgtE0bEIpoMD79eI5Kwku8bYTXVxg6AgXfkFu9+DyWo8Iu5b6yl/w+SDXaSF81p6rwK0GdWfPmWvtdW+7aNCEHMgq10ZPTJ+T6iXtk7oAJ4RJbVWfN9vkilnVdcWyUiA4tDNqaGKIv8fxaqcNZbyeC7G0QJM1c2oA8IrPqCyt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 05:05:47PM -0800, Andrew Morton wrote:
> On Mon, 3 Nov 2025 15:59:39 +0000 Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > > --- a/arch/arm64/mm/fault.c
> > > > +++ b/arch/arm64/mm/fault.c
> > > > @@ -969,6 +969,16 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
> > > >   void tag_clear_highpage(struct page *page)
> > > >   {
> > > > +	/*
> > > > +	 * Check if MTE is supported and fall back to clear_highpage().
> > > > +	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
> > > > +	 * post_alloc_hook() will invoke tag_clear_highpage().
> > > > +	 */
> > > > +	if (!system_supports_mte()) {
> > > > +		clear_highpage(page);
> > > > +		return;
> > > > +	}
> > > 
> > > LGTM!
> > 
> > I tested it with and without MTE and it works fine.
> > 
> > Andrew, would you like a separate patch or are you ok with folding this
> > into the previous patch?
> 
> I added it as a -fix patch thanks.
> 
> And I added a Signed-off-by-you-by-me ;)

Thanks Andrew.

-- 
Catalin

