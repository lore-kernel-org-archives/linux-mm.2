Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 476A2CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 08:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 872A66B0005; Thu,  4 Jun 2026 04:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823746B0088; Thu,  4 Jun 2026 04:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7389E6B008A; Thu,  4 Jun 2026 04:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 650E46B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:19:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 101141C1BCD
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:19:52 +0000 (UTC)
X-FDA: 84841531824.27.E5530EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6E7F1C0004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:19:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JLGNfpBV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780561190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYrxUKw/nh6sRJP9IfEqp4mWcwg9s0A3xJ2XpyHROBU=;
	b=IJCDUddF6QQ0qP68709CvfIVJ9oUz/1PNymEfF8gfrzs2/UyuPkMxpWJzkbeFG9WqNawGL
	ocuynDv9Dyx08dAeFPrLwWUFMgJl8NuVNYw67YHJOrJUg+IHWLwvcJwVBxMtQ/05DsLEqZ
	KCi286q5jFcRhfAfwkT7WnI49H6sWkI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JLGNfpBV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780561190;
	b=pu0KBG6/Dh+h7mvBSPEuOlmZA+exxbmx2AlFDfj+iV3d0fgOLBaIexu86U345NXziHgvxP
	fJoHF9XEzR+7tFHKRVxpPcXS9tPBQy8B0vRZ+IdDI5vqi5CQlE3LJx2eSPHNcGsba2Bd75
	Zy58ZjyTSbpPPoUVShsXXYGjboBidYg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 769E143B1C;
	Thu,  4 Jun 2026 08:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A541F00898;
	Thu,  4 Jun 2026 08:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780561189;
	bh=VYrxUKw/nh6sRJP9IfEqp4mWcwg9s0A3xJ2XpyHROBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JLGNfpBVWfxx36KiLlC/Qk6guC48/mOVATLoN0gRvinE3JqF/dmnpgSEVDgo5m5wl
	 4mg3VeKl2WZ3ZL7uUamdewZdngdomlZ6X6PiRl+0W1WjYT49F0fqHq9oQDahh/FgiU
	 NPrDSHB4ukNxZGeMeT7Pu8Gb/voiWcC87EjQCKfWD1a7f2wBIZZ3sE9LN7hv/N3cNn
	 g9L/AYaG1fISV6GRH4UfdAso0HrIeA5xmwpXp1ZLRW89DBM7uBFJBNiV+43JCUcrMg
	 8ijKgiGABkij3S42taF8WOO1JWTJXJ4SD7SGASh4uVhwShnaMgqGd3HRx4vhGrrGWa
	 xYhR0FerEMfaQ==
Date: Thu, 4 Jun 2026 10:19:43 +0200
From: Christian Brauner <brauner@kernel.org>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jens Axboe <axboe@kernel.dk>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Chuck Lever <chuck.lever@oracle.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v7 3/3] mm: kick writeback flusher for IOCB_DONTCACHE
 with targeted dirty tracking
Message-ID: <20260604-feind-eisblock-fischen-80a2d23c2300@brauner>
References: <20260511-dontcache-v7-0-2848ddce8090@kernel.org>
 <20260511-dontcache-v7-3-2848ddce8090@kernel.org>
 <20260511-zusieht-amputation-efe8b5058cb7@brauner>
 <7c0880ee25b13f64f71319203fcd7105f54e5ad0.camel@kernel.org>
 <20260511-caravan-behaupten-0402c454c22d@brauner>
 <aiAvWRr_3Y07Ba0V@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aiAvWRr_3Y07Ba0V@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: mxabyfxkuunjahqqedk4tphbkiwskoaw
X-Rspamd-Queue-Id: 6E7F1C0004
X-HE-Tag: 1780561190-835669
X-HE-Meta: U2FsdGVkX1/ISrcwJMc+iHXzOyjQ4kR/IoE9PO6rFjMDL/1d8iq9Ln/e+ZpN98/B+Clz74W3rF1njSFxodsDJtQiqcZw4MmZS9blN9BiB7lXYv2HO8o6H5n45EiFF13J/DfyebEgNfQkC9izpx4l03qtcto+EPQ69LdG2TAmFL641AfsV0ZB4lGebfQ+OQWfkAW0NrB4bcon/dma+n3wKUrcurU0ZI5PTqKoXfsHMUYqRIAjzhbP6HIPYJNAT2oakihOTFvxLodaqzS9gMn7ex3WhP1KCNxGRUmKUjAeXoVBKSj3a963fPuDgA3HzDwHiLzFZkBpXLd757ocKUFVe+ToFfBDSsEiFuiS84iKo9EV0V9I55rk1iEaRmxQT4aWDSNOIR2w3A6LrMFAGe6Ts1ryt35CkViBc0mroMCQvpShjffXQaJBU9MpBD0KbDbq0CwDc9PcIwVeBTQOFSo/ikzx7BOWvfj1zJ406v10gpN7+PfxoGIIqwxlXVsAFMEt/i7hLHbsYx9ct7jMKlSp1apzu7qGJHYtGD0F5E0GK93SCgVVO2GHuhr/Cej9LY64qnqPn9kiKaCrK/iRDFvNdR1UehaHwslPPh9YuW4x8t6bAjCfEG5KbOQXjFYtTZLw2yBQvgsFYqc8pSN1Z2Eioa7d4diPfOtG3F4VfdBDT7K3RhpAhEC7xh22UtLqCZ7YNY9va+BFB8usOrBh+7Q5y5A8UOoWDzdfps33gJZDAm9fbi46bKGjNZ1HDQ1MZCKXkA9eiZhT2IDrPothJIGFZ/d0kCP6fyheJaT0Y2ti7r5Zav7ArE6cfnPrYXbsy+d3XcR/DRwsS7eRxYciRuU2Wdez3YqDvQoNiLO2SXreymm/pxsh1SijJgvvKjhFokQLGxV2RdUb64Ugsi32BAHlTky1B53IXaJPMQrHhkFKuKWomcgVMFzoDqzgfbnyiUUdG5LFCCaZR/NIw3MnqYf
 Qk47pEwI
 4q3tMMsqpBK9tUpRg5SxkjWkDUsci/28xLxdavWEvfrdYRmuvD4ILipTF7baGeYaE1qWNzi2tIGNnUIWBW2lD/1nrLiFgCVAQewlzJbvHtPp3pm+4ZUByjALhgJ/dylYtXbF/XM90ZinyTH+IlbO7VCJWFkyk56+H8UhSn6a1apyJ0/ZgL9ilVN9zmcCk69egiUncUE4dKSpoh8gmGGTVEGyg/bcjI3Ol7Vg1Loz/uiyEmP57nCDhowascR7VFy3rVX1yxpI9eHMFT/WvpMExWkUY4DbuE6E6P92s8vIolNcROxzMTpMZ5SpgJmW5BqLuBE4qq3j8F7x+OSfSkzswnEr37rtO3zeVGsonpOpqccYgEF1IXkLfCEYGSMTYjoqCcsANYYJ4c8KsEDeWRJvdGvfc2tTZ0aH6SqmhV1vwNUdJUQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 09:42:49AM -0400, Mike Snitzer wrote:
> On Mon, May 11, 2026 at 04:06:42PM +0200, Christian Brauner wrote:
> > On Mon, May 11, 2026 at 09:53:21AM -0400, Jeff Layton wrote:
> > > 
> > > That does look much cleaner. Do you want to just make that change or
> > > would you rather I resend?
> > 
> > I'll just fold it. I already have 1157 mails. I don't need more. :D
> > 
> 
> Hey Christian,
> 
> Did you happen to pick this series up from Jeff?  Not seeing it in any
> of your vfs-7.2 topic branches.
> 
> I could easily just not be looking in the correct place.

No, you were right to remind me! vfs-7.2.writeback!

