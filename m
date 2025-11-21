Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 295CBCFA47A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F87B6B0032; Fri, 21 Nov 2025 02:29:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0FC6B0062; Fri, 21 Nov 2025 02:29:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60E006B007B; Fri, 21 Nov 2025 02:29:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF6F6B0032
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:29:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E78E01404D3
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:29:53 +0000 (UTC)
X-FDA: 84133789866.15.69A633E
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf05.hostedemail.com (Postfix) with ESMTP id F14A0100002
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:29:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763710192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lbC2pgUnDH30348AyB/uX5AoEjyPtRM6vDyhymAadVY=;
	b=Ahg8yagvo83wzGuuoIV8X0aXXyM6qWStdzGGk4am0Fn3pVHpzlK+K2j1yR4SZxMc+n4l+i
	NNrTBNBBZtbx4iD0v1OluzxFmBy2vG6x3se/bLwCxhqMjqBQ1rFRKqS6kLX131X93IGQ4n
	Ifk2hpJ3o1KMvnRrvPyfLqt8iTBn9qc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763710192; a=rsa-sha256;
	cv=none;
	b=2VCpsTamcLqWMUUuqO3FAQ0hE8zybgQRwQDNJRlpFdolnwN+KFYc9HVoBOE2LRRzcB2R12
	5a4zmoH1ZTiJpxWxhLDoqUpjIYZ8OpAIGJ+BMT3ihslz8L0dD6pwGTWn1u7c/Zoc80X6zT
	eE1n2a5buacW60MIcfQjiytXNP4FoFw=
Received: by verein.lst.de (Postfix, from userid 2407)
	id F189F67373; Fri, 21 Nov 2025 08:29:45 +0100 (CET)
Date: Fri, 21 Nov 2025 08:29:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"urezki@gmail.com" <urezki@gmail.com>
Subject: Re: [PATCH v3 0/4] make vmalloc gfp flags usage more apparent
Message-ID: <20251121072945.GA30438@lst.de>
References: <TY3PR01MB11346E8536B69E11A9A9DAB0886D6A@TY3PR01MB11346.jpnprd01.prod.outlook.com> <aRyn7Ibaqa5rlHHx@fedora> <aRzPqYfXc6mtR1U9@casper.infradead.org> <aR4SmclGax8584IJ@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR4SmclGax8584IJ@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: F14A0100002
X-Stat-Signature: jungxy8xk595cg7f5cxxep18n1tmijo4
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763710191-573685
X-HE-Meta: U2FsdGVkX18xzd+BkoF8uDNLPsXt+mUkCQsStXw8d3BlmrPBg3AAgIs9XMjzMpDw7aKc1U6ST6e4X6O3vr5meKgRrf0bICCEITmIgk6jskW6Q5YUKAlpTMTjervYrVD01btqwB6mOpSf951AfhVwkhgMSNHoCL424L/8tkhIwbzLZFZ/e1K7APC4pXCOF8O83N9musPw94sF6eYeRKrX+3haNbWvB09JOFwtq8f0VcFOw7FeSeRGXWoCeQlofgInCxcUjEJ/10/lz5iAtti/PhtZ/LSOLuGhgmVeNetJyyxsosUWi/odRQF6zrsGY0AwpaRQbjpv8iA5nNewy8LoRkLVexTuM+Fvn+9I7BCoST2D7V4ga6n7sVDuuWqMn6yPnYU4NNk8KDnde+mxkOANoAEAoYKfBxPaDgtcesJ2BmJHVPTJVGQQ2pj1SgKvuAPfKBNru/8xI2PVLL+8Ee9nXhjaWC+8Mwl9OHuAlDLYrl/1jb7TQcmAY3e94FyTrGUIkdEf1ykh2neZ6pmBgqUgjHLdaiEI21Y/+iAh7evGMf0yNPRE4ni+SBdOq/YbQ2OgOgVK84pm5QleIko68sYmalbS+kw6dMwD3dHbCCh5L5yYdSq4Wrj66inlsdq0Q/MLfxyzPnSkt/doNJqxERnufBIcC45KstqHj47ScwFK100Qc/5U42wP0XP9FqhOGTD+Fw/3r2kpzvKC1beEyHfkn3pWK1nCZxdnL8qKgYjvr/ugr5Czn2zoDY/sImyN+/RtynuLvMj4BZ9RU7u0aTFNnl/Rl9r+k4je6Za6WVRJwechCHnmgxenUJTVa3bu20UP/bu8iIs8Om41Lvl59NjuBJCrbwdAzbq9Jk2Om5dWYRgjyZM+AMAtN0QdKQXKkqu1VHh7aO2k4CgHahAcjpU0mrydzixYw9v43pTIpa0yrSlqDU3s6j383lOSbiS5tFFtpz4vdU3ysN4bWHLi2TW
 VHnVQKAJ
 akituzvSHeWfatiVrk+4ps1KoRbwwZ+OVfeOLrcoU+WmoS3S+CaDWL3FA5ZDgGkz/oN7kHf1JTFhxUGKzgq3JgudP+l8xU/LHglRuNYDjpM9Ie1Fq8DOioekAeJUNuPeddyc2bTnmmkat7ZSpn4p+zTQ3+zTwXMLA8aj3D8c2Oyj1B+FaWdBsA7AQ/YsCAM7R2LX8vGnhZFWc+x0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 10:55:21AM -0800, Vishal Moola (Oracle) wrote:
> > Unexpected gfp: 0x1000000 (__GFP_NOLOCKDEP). Fixing up to gfp: 0x2dc0 (GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN). Fix your code!
> > 
> > I suspect __GFP_NOLOCKDEP should also be permitted by vmalloc.
> 
> As far as I can tell, theres only 1 caller of this.
> Christoph started using vmalloc for this xfs call in commit
> e2874632a621 ("xfs: use vmalloc instead of vm_map_area for buffer backing memory").
> 
> Looks like xfs uses the flag to prevent false positives. Do
> we want to continue this? If so, I'll send a patch adding the flag to
> the whitelist.

I'm not a fan of __GFP_NOLOCKDEP, but it is a valid hint for the
allocator, so it should be supported.

