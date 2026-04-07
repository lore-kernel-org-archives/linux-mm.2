Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0C89EDB7CF
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 08:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 036716B0088; Tue,  7 Apr 2026 04:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2EA66B0089; Tue,  7 Apr 2026 04:21:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18B56B008A; Tue,  7 Apr 2026 04:21:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC0E76B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 04:21:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 778E4C259C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:21:19 +0000 (UTC)
X-FDA: 84631065078.03.114362F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 174644000B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:21:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xLGbQ6Uu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Unv5B9Js;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xLGbQ6Uu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Unv5B9Js;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775550077; a=rsa-sha256;
	cv=none;
	b=cxL4hdZ0LDNxC5OrZ7LBIT8qqtRUDdlQ8C9tOrPlEg9GEf2zJNEc8oWc0pKG0ikVMq9O6r
	h+czTOatwwDVBEgvoLctn66rqovGvLb/JtlxAomwsgfscDo39wEHyVgsGxVzq4EIn874vl
	PF17Ucfy8I0KXvT09GFsuuG2qC5DXtE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775550077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tM5pVGM5I6FLfPVcUIK1ZxbPT8N+tG2e+NWVRs+nFnc=;
	b=58AQ8AruYfk3ImrZzNX3bUsgdqFuZ1wasVClv4NIq7mYBQEeSqCKNLodJC2dTQ/WRJYWWT
	WzDdeyTrudQAPh0ktNAvXBylPQq5Q9EcLaVdwGfK5MLjjBmyfRP9thAwsWpPgLsdivuBye
	X4lx+dFeJafXORc1d3OdZNLZf6/7fUo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xLGbQ6Uu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Unv5B9Js;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xLGbQ6Uu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Unv5B9Js;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5F4D94E35B;
	Tue,  7 Apr 2026 08:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775550075; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tM5pVGM5I6FLfPVcUIK1ZxbPT8N+tG2e+NWVRs+nFnc=;
	b=xLGbQ6UuGu7/peclXL9ys+KIX9gu53Xoq7kwu0rQKPfDsJpOTJIu6xZ48As0AD33HjIoaP
	jM008CIAYvrj030C+wYMnJt/CrAuctXqAHtQDTJpzWVBbS7zoXq7ZVOQibBh/MpOS+vjox
	77ckKkyCnUj8NWkkCBe4A6s1qQzw/iY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775550075;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tM5pVGM5I6FLfPVcUIK1ZxbPT8N+tG2e+NWVRs+nFnc=;
	b=Unv5B9JslMwsdYcL2A3l8JTbNOtduxkwn5y1J+9TcuuU0v2F7iZ8kURB4IVP0ofUCSboFi
	Lq4TSAeoXOmnOADw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775550075; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tM5pVGM5I6FLfPVcUIK1ZxbPT8N+tG2e+NWVRs+nFnc=;
	b=xLGbQ6UuGu7/peclXL9ys+KIX9gu53Xoq7kwu0rQKPfDsJpOTJIu6xZ48As0AD33HjIoaP
	jM008CIAYvrj030C+wYMnJt/CrAuctXqAHtQDTJpzWVBbS7zoXq7ZVOQibBh/MpOS+vjox
	77ckKkyCnUj8NWkkCBe4A6s1qQzw/iY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775550075;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tM5pVGM5I6FLfPVcUIK1ZxbPT8N+tG2e+NWVRs+nFnc=;
	b=Unv5B9JslMwsdYcL2A3l8JTbNOtduxkwn5y1J+9TcuuU0v2F7iZ8kURB4IVP0ofUCSboFi
	Lq4TSAeoXOmnOADw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 853304A0B0;
	Tue,  7 Apr 2026 08:21:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gQH+HHq+1GnuEwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 07 Apr 2026 08:21:14 +0000
Date: Tue, 7 Apr 2026 09:21:12 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, 
	jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm/mprotect: special-case small folios when
 applying write permissions
Message-ID: <jumu4avqtfpf5334cddblhn7xawryviqmxqavxhctpgvtrv7nz@wczfgh3zdq6x>
References: <20260402141628.3367596-1-pfalcato@suse.de>
 <20260402141628.3367596-3-pfalcato@suse.de>
 <20260407005026.ytf7ed4bk2ljyflx@offworld>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407005026.ytf7ed4bk2ljyflx@offworld>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 174644000B
X-Stat-Signature: 9bzurd8g8eqfz9mm96ufp1a6nwdsa4rg
X-HE-Tag: 1775550076-7885
X-HE-Meta: U2FsdGVkX1+j351vVKmaRos2kI9yrI8FGKAXG1GHEMP5HnOYcre52Nfz67ZIziGG6JvV7gXXZhAan6oFWTsXndv2dkNnO9VWBamx1m5c50RE+zFbcPdSv21nEbrCtWtOPV3G2qfMy3ZmxubwmmqKTKJ4/isncrFYrdMThpJaYZ71yjou5Mfo505Z62DJROCVsmdZ3iVwkjx8f9utiSb0rGDBygDwHrYjLh/vT8ctDdtZI5x1SVWo4Z82x8TkpiJIXRuN6L/La/HyHlPcYBd/bjZ/lC3wIba0vcsafD68sonrRfTTprPBb7VhYJcuUdGe7Lgs1P54d1qb4RDad2UTgWIoBCIer+xNZbjiZRRmFKHXoPKuNze5I83TAqyGZ9KFJGz9ObxuUZOzxlpmm/IJhfSaVqUw2y6iWydGHqTABTTZU6jQfcrvPCo5q8LObuUjxtya9XBRpjhpxl0ANh3tKJ42TfivfZ64fcdv5GWv5vNgpii5ey0LroEvSaFJCLDPLFpYkwCZ0jl/DhkrMv3peV1btKG2QlpBq7BkDzH55AqUMIMNDM0gc4KiMk35iFMTftKC59IwdRXHCd5pMwYuVuliA5yaKD+b+zUS/bUsVUodOMNGYzJ9OOk/FG0ngtjeAgQ21DnMDf0a81Uhz63JVF9asdbmPyqP9PAQygbF1k0SmeGRQaTyzELdOFvelp+0RsOsUBMDO4qX1Q5eWe48QGQ8v0eULn6IkkqcVXx9Kw6l6dmsQkPHuQ02CZ3V64VHGGQVxVRKz4SaNZB4xr276K4okL/yFi/eDxVyLR9ef6j0vbJdVXWmc8QlpoqlAjKkUQQucRX+o5i/gLz7vo7BET2bi6C7qyf8Kn1Wur2HVilY+FvqYrKSFO9TJRYR/OvWhwV4d+XazzoFU2rqsEDo4wduQ3xJNpqIWbd0ae9ycUVsUiHT2MjWw+VlBKVYH4wClSEQDWaTNTjzx+iGPDZ
 QIRgq+DW
 o+AceP/D0aIEEMbDNyk1BeC24/cjxuPGgvOv+KIFrAmVxdwGv8MkI3RVI5FWHloJaUPoN8/40YEbVH1Pj2CB49MklaVLnmhAiLXo08osdpcVQs+F/+g8mNWBJEjhNHw/59gwOoDRRm5dtZf5tUFCab+fdja+COKXzDxE4tXny/38LkxFK8a+RLhf8PT2vnmZ7e3mybI4ASuBKpcpRSMUUXXY3xrNZ8ts4qUR8tVayEvjykH+QfTl7u+rKhUGhlQ4aVPMY+xZeaP+0gUIiYJ+ncrHOT3N51qH3bPLZE1jJEgTthG0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(note: had to manually adjust the To: and Cc:, it seems my neomutt doesn't
like something about your email)

On Mon, Apr 06, 2026 at 05:50:26PM -0700, Davidlohr Bueso wrote:
> On Thu, 02 Apr 2026, Pedro Falcato wrote:
> 
> > @@ -334,34 +371,20 @@ static long change_pte_range(struct mmu_gather *tlb,
> > 
> > 			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
> > 
> > -			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
> > -			ptent = pte_modify(oldpte, newprot);
> > -
> > -			if (uffd_wp)
> > -				ptent = pte_mkuffd_wp(ptent);
> > -			else if (uffd_wp_resolve)
> > -				ptent = pte_clear_uffd_wp(ptent);
> > -
> > 			/*
> > -			 * In some writable, shared mappings, we might want
> > -			 * to catch actual write access -- see
> > -			 * vma_wants_writenotify().
> > -			 *
> > -			 * In all writable, private mappings, we have to
> > -			 * properly handle COW.
> > -			 *
> > -			 * In both cases, we can sometimes still change PTEs
> > -			 * writable and avoid the write-fault handler, for
> > -			 * example, if a PTE is already dirty and no other
> > -			 * COW or special handling is required.
> > +			 * Optimize for the small-folio common case by
> > +			 * special-casing it here. Compiler constant propagation
> > +			 * plus copious amounts of __always_inline does wonders.
> > 			 */
> > -			if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
> > -			     !pte_write(ptent))
> > -				set_write_prot_commit_flush_ptes(vma, folio, page,
> > -				addr, pte, oldpte, ptent, nr_ptes, tlb);
> > -			else
> > -				prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
> > -					nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);
> > +			if (likely(nr_ptes == 1)) {
> 
> Are there any numbers for this optimization?

Yes, see the cover letter and the testing done by both myself, Luke and David.

> While I am all for optimizing the common
> case, it seems unfair to penalize the uncommon one here. Why is nr_ptes > 1 such an
> exotic use case (specially today)?

It's less common on most architectures due to having no real incentive for
enabling mTHP, thus having no anonymous pages with order > 0 (that aren't
PMD_ORDER and thus PMD mapped). This leaves you with pagecache folios (that may
trivially be larger), but that depends on RA and the filesystem itself (e.g
btrfs does not support large folios at all). But I would be extremely
surprised if there's a regression (not in the noise) on the order > 0 case,
as it effectively does more work per iteration (and per my measurements you
easily get order >= 3 on ext4 folios, up to maybe around order-7).

> ie: How does this change affect the program in
> b9bf6c2872c ("mm: refactor MM_CP_PROT_NUMA skipping case into new function"),

That's the series I'm "fixing" to restore performance on order-0.

-- 
Pedro

