Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E97CBCCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 01:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E7968E00D3; Mon,  3 Nov 2025 20:05:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BF038E0058; Mon,  3 Nov 2025 20:05:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FB828E00D3; Mon,  3 Nov 2025 20:05:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 227B48E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:05:51 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A10A6C0345
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 01:05:50 +0000 (UTC)
X-FDA: 84071132460.13.319E54B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 14266C000F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 01:05:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ji11rneq;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762218349; a=rsa-sha256;
	cv=none;
	b=RB1t4gEYez4IOzD6Bm+m3TMF9meIgbWzzmgGFzmXNGvpHTvhJ+RJn+LFYOQLRtEHCVVGQO
	hXFMhGWsQBgZCUyaWvDD+xRhnwuhy0vIYw9Xnzz7V61VXH7NL0nIXyOB7Yq9azG6VvRCkz
	wOs5e7b8dbf8RH7SFrMvBhDi1aP5WVs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ji11rneq;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762218349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NO8UUl0cc2qXIJH7SLeI5Q+K1DE7y81dX+uJlx5f+fA=;
	b=WeLKww10VKs+iIHTt6AH8GAeVUegU+luunexSFqLSdmH5un37LvveaDajN0OPOv5A71jdD
	EtKoJOm1ifgFrWx7s5urPcp0wm1dvdHV55Ixy+gGdHObBwlDJB/hObJENgsW5BWwaZPaMN
	u3ZEeONJTkOlfQYdpRnEZTcs94AeUY4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 35633601DF;
	Tue,  4 Nov 2025 01:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AB0C4CEE7;
	Tue,  4 Nov 2025 01:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762218347;
	bh=5TWeHa9L+UKC4ivQThYbj/5dl2jCMFfjpOayfYk03Eg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ji11rneq0JEXsVQI7V39y4Y+9FA53jlHpB/K7jPiOJWiHK0e/XbRu/mia1j7obbkH
	 lnN2GObf3hn/rv7b86Dz/H96saru74TYLPT9c1D0HEL+X4SBc1XMoej/Palr1yJrfv
	 D8UGNsmEDluRipk/cTfeuHwEbfZg2EXt4jg+AR7s=
Date: Mon, 3 Nov 2025 17:05:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, Mark Brown
 <broonie@kernel.org>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 Aishwarya.TCV@arm.com
Subject: Re: [PATCH] mm/huge_memory: Initialise the tags of the huge zero
 folio
Message-Id: <20251103170547.4935d9caae8bf558faa1b04f@linux-foundation.org>
In-Reply-To: <aQjRa-Bh8J8Smgur@arm.com>
References: <20251031170133.280742-1-catalin.marinas@arm.com>
	<aQiu-hU3x5V5drHF@finisterre.sirena.org.uk>
	<aQi8dA_QpXM8XqrE@arm.com>
	<79a1f2dd-6752-426c-84c1-a38d300eb78c@kernel.org>
	<aQjRa-Bh8J8Smgur@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 14266C000F
X-Stat-Signature: as5omf68q7nc5rwn8zwjyb4bgyfzpqyz
X-HE-Tag: 1762218348-726027
X-HE-Meta: U2FsdGVkX18OCufUBFhaIs64HkujwJRa1vAfzXJNqZVlmgHxYdXjsm87/KYI9hu8GaKSn1b2cxcojVfN1w7bbevKDsSxESjFp8Sz/ta7Qt8czhcJR887S31Vqj31oEvtfv8Rzx0K3bbzwBpb3qx9KgspnRvGUDOefMylowR6L3RWQi/CnbSSQ2kjN6snlcQPqdBCIQ4HUXXp/IFtn9ztzgBdor2jsO5C8rHBKZntCwJtYIkNmqsenXLHNjRA0IzuNwZOxXJigrBD67+/g3AnDdvOuiu48XPxLwDcGqVKAvQvuncbPvk99MY+u3VBELiJw4q77xo6yLo7HsbMbk4JYGn26eaBUda17F6lG0fGEBJ3n7yySuy0s0jLzxXaIaFF+GeXQr/hlbdI72WNHEShiWbU0wbxjeCiHG3+pei8JVIclya9uj49jnjgFwDfoUjwGibh0qayBwUn+ZPtLZGHL485hfqKL7YPc8+EBlf5Kk/izAElngT0PvptEzZ/uowAN2mpiJ0z3cvy3aqie9VXRUUm0KoQsBUNPIasiEqX3tZtoqyVYl5pD22a4z2VKBCphMBZ/muFP4K7f+6j1e15+zlu72rC7uxznPSf2o3se+CeDx9SM5+RaJ4OGyRgFKNrv+VfxJ0HxEKs18OsnS1itplNp7Ea4/WzRWU4L6QQ5VaJ7FlqMSoDY4v78I9330GdpuSRwkXlbfP3LkaxEYi/3Hg1/Jl02rPCoUH/W51hZyZLVXyQGTEyR48pScyuOnZby74TXpZEpEqU0Vnu2/eAWVWcIgXpbfnTgRA3TVTqgNV97jziLycodWApUCPiexP7PSpPVF1bbnuZ0e9QdgAgSPX2RIU7KEucDbE2zo5jii787o2J9nfyo/Ka0xlJj/cMVP81WTDAkKwt4ithYfstRyNFleLZUe9uzxXyDBR4iugns+FEkv8m50wVDOlhYqAurGpXBafN/LnuHJklS+A
 8eR3Ofmg
 t/S6y3B4kQv3Nc85S4SGWVnRvYMVIYAhNnhsANghx24pyr+MezpTa0f9SXFEtMm0MvjyuF8+W2qJuVnJlPIPaXAXbr/pG1cKupndG7xzkCT7UFHA4Pm6NmyTaaLPnGfSU9NHfX9SK24imy2pr8SQfu4j8dhQuLGW4SAQAjMPe0GITmf0ZMnJiwzJFCaevpX08TKDko/JHzLf7H9Kvz4hifJr5At6rfMaOfYGlK+zzbZ7Pif3bR0xJedUkBPD/f+VLSAlXsYtG3MO4GIW6PywLcBKMfSi0COLN+hNwYwPA5KlJ9CA/FpP6hVV8b2aed5Yr5+DgYMU9Ixxdkzbw3yr42jG60BhKPc2Q4UxS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 3 Nov 2025 15:59:39 +0000 Catalin Marinas <catalin.marinas@arm.com> wrote:

> > > --- a/arch/arm64/mm/fault.c
> > > +++ b/arch/arm64/mm/fault.c
> > > @@ -969,6 +969,16 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
> > >   void tag_clear_highpage(struct page *page)
> > >   {
> > > +	/*
> > > +	 * Check if MTE is supported and fall back to clear_highpage().
> > > +	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
> > > +	 * post_alloc_hook() will invoke tag_clear_highpage().
> > > +	 */
> > > +	if (!system_supports_mte()) {
> > > +		clear_highpage(page);
> > > +		return;
> > > +	}
> > 
> > LGTM!
> 
> I tested it with and without MTE and it works fine.
> 
> Andrew, would you like a separate patch or are you ok with folding this
> into the previous patch?

I added it as a -fix patch thanks.

And I added a Signed-off-by-you-by-me ;)

