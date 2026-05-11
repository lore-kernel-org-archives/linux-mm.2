Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 297CFCD484A
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:29:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3D76B00B6; Mon, 11 May 2026 09:29:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784BD6B00BF; Mon, 11 May 2026 09:29:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C7D6B00C0; Mon, 11 May 2026 09:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56F066B00B6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:29:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D626540112
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:29:42 +0000 (UTC)
X-FDA: 84755221404.16.CCCA86C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2C410C0016
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:29:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nqPvDGnX;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778506181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LALHkPZdnBF0gx5tkVuLmyM8RO16i0VVrr3aEUEm0xo=;
	b=JR+EzdY3KIojh5DKFUYE0+8sGyRH2RaBbbB6Ma6h7Q3XHMXQdxf+Cqy2yLMFUFdYV5EU+w
	ZAsrm1i//1Hpk2ALtA5CUBnbQpqXgYXYRym8qw/if26NiNfLgM0kL5L4kDErVuegHp5EUH
	keUJtUDXQdTYNoxjTldxn0osPnMSz1o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778506181; a=rsa-sha256;
	cv=none;
	b=RQX3vEPEATufSzx5QhhxIskgGLwzzMZ9gXS4QaBbpnC8ag+fTNlJCxsosdxY5HLbub9f/v
	J0D3gSjk/5nsMvGk6s4WjVTAo8FVLkfahx8aSnIZ/PTPqXvAFoTWgQMUTqVTSHEI5VvpzR
	Gj9d5nJg2VYuqOrbDKyrWU/7h0B4Xk8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nqPvDGnX;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 75B2960120;
	Mon, 11 May 2026 13:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592AAC2BCB0;
	Mon, 11 May 2026 13:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778506180;
	bh=FupFSPq4hGi83SE/clUkWU1oZUQvnMgM/MElybqlmyI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=nqPvDGnXlUdLiMLai71SaXE8Wb7zh8+fkvy5/GGVf97cN8zvgo4nq9gORD7Iy3nX4
	 zY8rG3BJ7Ycxx1dqup0bOnhzdUnSePAPkfRsswp1MJ/s4UUpR9K6thVEawFoN16rt5
	 9uGLCLaHpyUcc/XBxZW6NEEFSRAv9Zsdm15vJXVm0hgPBDjFQRth7iMpPAHfAR/Trf
	 v/Toxl2DhMyTdGGAjT+eYiq79u+xt7Lg610iTVOJ3pZ00GFQi/ssxOL2glm0tFdMqG
	 prbAPsZ6eydl0GDOX0MHEEdqvzjjlBfmIRYuJK/OnoUQrCk4p/jQYVGEMJ+82s6I3O
	 DWSrGP/1SYXnA==
Message-ID: <960ba89c3c6a04a7b9137322493d65e4ab4cd7d2.camel@kernel.org>
Subject: Re: [PATCH v7 2/3] mm: track DONTCACHE dirty pages per bdi_writeback
From: Jeff Layton <jlayton@kernel.org>
To: Christian Brauner <brauner@kernel.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)"	 <willy@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett"	 <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport	 <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko	 <mhocko@suse.com>,
 Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>,  Ritesh
 Harjani <ritesh.list@gmail.com>, Chuck Lever <chuck.lever@oracle.com>,
 linux-fsdevel@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-mm@kvack.org
Date: Mon, 11 May 2026 09:29:35 -0400
In-Reply-To: <20260511-begonnen-zuwege-b4272b78eb00@brauner>
References: <20260511-dontcache-v7-0-2848ddce8090@kernel.org>
	 <20260511-dontcache-v7-2-2848ddce8090@kernel.org>
	 <20260511-begonnen-zuwege-b4272b78eb00@brauner>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (3.60.1-1.fc44) 
MIME-Version: 1.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2C410C0016
X-Stat-Signature: gnrh6ws45hou8chsb4etmr57bxwcyc3x
X-Rspam-User: 
X-HE-Tag: 1778506180-895750
X-HE-Meta: U2FsdGVkX1+0U1hLb/+a8k9jc72hjTWSFIuhP9aPkdMvKm818YifPk5qmJbREYN9fGUgwr8pZwOtssEg7UhYo8+XlHiqzbSKu+sZuO8nxDyY1PQy6FdTTClaDHaqD/FqRoe99jWZ/5WvIn3NSxAJ3a4p1OQY2b+ZvgBXjdumI+nR5D+xPuSoq9wtOL0dp4Mycx7b8x7AYqJNoQ5ptVx4rXuAHquxZ5ojbQV2pd5xxDdP1zsmJpx8zdd5zLA51Il2E2uIfRe+/rFgs/N2tbR5koO2aSW3jtkoFqmfO//GfNa6VtRSBU7RqWD0kDH/kuQ5fOpqbZDh7rJmdm8bOkKm0Bj32yWnPb9GX6GvMrFZYwbR5NGZq7AtpEZcQ0vP7jUfE3GZqyAFYhRvv40L3tqQ0kwSWVYA5LSUZ9+B8QvhWxI611DnhWznU2JclBibKXDKCOpSTNxpr7ARi5xzfn5DtR+/mM/ur3noXTXASEwDRVAaHDMZK4c2Lo0B+yNLB3o36QuzrhVvhrjkExJFt2zX5k0+5pt5YAvL3AbbsJrawjph/pZkLPuDdH9BsqgkxZwLtt/BA6WS9lRvxxpK1xSllOeqP7PendewFAh5FXaZWOeVZqQRo35aPoPh5DbrdsWl6mQTMzmKgM+rC16on5M+cqH3qPW+0umtAcx5NuOOPCs15uO/L9skrbvY3SMxx5Kme8trnWtasJZiRFwxSeIeI3dM70JfjWiv+/PX9izBMEogPhMHbAkQRS2RZ1QlutWcIofZT4SN0uRnYlUsdsxMadHkGxFfV3/BdlI/HPLkQjulshQjKwP9mzGyFqEykgtwFjOBOl5UijO06rbq7EzO/VEOuxzU2N2qnF7Z5DFqrErkOfGr3J5HnJzMpdxm51zVPdHJtCUfo6N9nbwLzDyp1elh/ev5JG/E8TX7g5c+pf5pknhtLR5dFfNJwD69554z4pZx9uvkfqeBLp+qnwS
 OaYwDkxf
 ES0VIOEKmWzVSJW0M9fteKtf5gxuIZTunf+ED8SihZwLCm+SXqI6nEn5019nOk5JKrSvOUJ52WOSfH8U/xHTf7Y4sGV961vuv89RGbPli6R/y+SAbFcMMegiP3ABj82YW1UBl4LC70W8leO/9k+9OdQsZOTLLPEuUPOQhRe5lHEhijeVa0v0R9zzR0+IeVoWQv623qo9Mid3KrwMoAoIWwy5fxvJtdsMLU7U1mlWRfh11z3/Rl01/hbmj2VMEPhHY137rH1EPOvbPDJBuQWtvOApwSdD3MReFQnOUtcaK2AxjlmbuvPKIKJvqjuUfKQTEnJUUuMmXjKJgkiro218WnIHMRiCHb/07Cj/3N8OJHx7RONo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-05-11 at 15:10 +0200, Christian Brauner wrote:
> On Mon, May 11, 2026 at 07:58:28AM -0400, Jeff Layton wrote:
> > Add a per-wb WB_DONTCACHE_DIRTY counter that tracks the number of dirty
> > pages with the dropbehind flag set (i.e., pages dirtied via RWF_DONTCAC=
HE
> > writes).
> >=20
> > Increment the counter alongside WB_RECLAIMABLE in folio_account_dirtied=
()
> > when the folio has the dropbehind flag set, and decrement it in
> > folio_clear_dirty_for_io() and folio_account_cleaned(). Also decrement =
it
> > when a non-DONTCACHE lookup atomically clears the dropbehind flag on a
> > dirty folio in __filemap_get_folio_mpol(), using folio_test_clear_dropb=
ehind()
> > to prevent concurrent lookups from double-decrementing the counter, and
> > guarding the decrement with mapping_can_writeback() to match the increm=
ent
> > path.
> >=20
> > Transfer the counter alongside WB_RECLAIMABLE in inode_do_switch_wbs() =
so
> > that the stat is properly migrated when an inode switches cgroup writeb=
ack
> > domains.
> >=20
> > The counter will be used by the writeback flusher to determine how many
> > pages to write back when expediting writeback for IOCB_DONTCACHE writes=
,
> > without flushing the entire BDI's dirty pages.
> >=20
> > Suggested-by: Jan Kara <jack@suse.cz>
> > Assisted-by: Claude:claude-opus-4-6
>=20
> Picking up on something we discussed at LSFMM in one of the sessions as
> an aside rant: I find these AI Assisted-by tags so useless tbh and just
> pure noise in the git log _especially_ for a core developer like Jeff
> that I really don't see the point of them and I'm always tempted to just
> remove the tags when I apply. I have dropped them before because I found
> them so pointless.
>=20
> Crediting Jan here is the right thing to do and it provides actual value
> and also just makes sure that a real person who spent time helping out
> gets visibility in the git history. Why we should extend the same
> courtesy to automated tooling is really beyond me. Somehow we've become
> all convinced that these tools require a special status but have spent
> months arguing about the usefulness of other tags.

To be clear, Christoph and Ritesh also contributed a lot of review and
suggestions.

I was mainly trying to follow this new verbiage in
Documentation/process/submitting-patches.rst:

------------------8<-------------------
Using Assisted-by:
------------------
If you used any sort of advanced coding tool in the creation of your patch,
you need to acknowledge that use by adding an Assisted-by tag.  Failure to
do so may impede the acceptance of your work.  Please see
Documentation/process/coding-assistants.rst for details regarding the
acknowledgment of coding assistants.
------------------8<-------------------

If we're demanding this from anyone, then we should demand it from
everyone. I don't think we want one set of rules for core contributors
and another set for other folks.

As to whether we should add them at all -- I don't know. I think it
really comes down to what we intend to do with this info. I'll play
devil's advocate for the moment:

The cost of adding these tags is low. It's just a few extra bits in the
repo. Maybe this could eventually have historical value?
--=20
Jeff Layton <jlayton@kernel.org>

