Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E042606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=lco/hl8N;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=alZaJIH1;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GrSTaFhB;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ctYW/Eio
Received: by kanga.kvack.org (Postfix)
	id 7821E6B06E7; Tue, 24 Nov 2026 08:37:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A326B06E9; Tue, 24 Nov 2026 08:37:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649136B06EA; Tue, 24 Nov 2026 08:37:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39AC76B06E7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:37:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3B29140BC3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:37:52 +0000 (UTC)
X-FDA: 85470115584.01.B4B17CF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id A3A8D1C0004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:37:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="lco/hl8N";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=alZaJIH1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GrSTaFhB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ctYW/Eio";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795527470;
	b=weu9UMb/fXx6WkhMwGNJIT57glkKrEh9rw7rXCCs59K5a+CqnWd4L6OrUrCfSLS9CGwmdw
	psS5pKIAc9c04+j4H+x0KRJsXmHlDQrY0/i0Fud1m2qcjixg4YSo0g5KOhDF9VZ6z5QFxL
	RPNDSwvwTfwQm0Ivzcne7zTIHwnNtd8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795527470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qoBXvSkKFB/hg52/Z3aOD/B3EVltr1cS716I45qk3To=;
	b=uH+rFaJB+iXtYYp9wMez8+YnZE084OQxpb0Y+3o4LFK8Sn4rKQILJgE6EYl+6bzeu0MGID
	vVBQ1RCWEewEB9q/wf0y0utTFpAWeS/cofw68B4zhNelsaWHfZfjoB4nyVqLsnFHR5SwG5
	lGiEvne5+nB74DXUp/J47/nS3aWL/RM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="lco/hl8N";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=alZaJIH1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GrSTaFhB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ctYW/Eio";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 406AD22045;
	Tue, 24 Nov 2026 13:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795527469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qoBXvSkKFB/hg52/Z3aOD/B3EVltr1cS716I45qk3To=;
	b=lco/hl8NuT52rOMTnhNPzkjxpgpMKgl5c3r+lYMfoziPUpXwuaQx+YQB23RIMuyWSJoVfU
	TUOGfqMXf4Y4pJvrqFDCf/IsBODVwW5Uu53J8OeC9k4Z+RFDuT7q/cVpWQPmHdwv9erbgi
	zajCwIL9kCHg3J+pIg8O76WcPmWTXjs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795527469;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qoBXvSkKFB/hg52/Z3aOD/B3EVltr1cS716I45qk3To=;
	b=alZaJIH1IM9U6rlVlGHsk+Nm/4PIyn5M2HQasw4PKpXD7H47cw09mbtw4MdzByNUE8L6qc
	scbWYIb+TmQeX8Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795527468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qoBXvSkKFB/hg52/Z3aOD/B3EVltr1cS716I45qk3To=;
	b=GrSTaFhBy00Ek0GciUVJgmyZIVu/eK/cYxonxQUwIRdDtq6VMbDnZh37Ab97BSn1RmQI2+
	FZnIXV5iW8EatUHjUF+mDKTWJgrZ/lHOdKnZoHJhSgHxDtXUcfRl9beaLWkphKKt2baAjS
	e6tcTJQNO2u7VK1SyExVAA2Bl/Hnwco=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795527468;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qoBXvSkKFB/hg52/Z3aOD/B3EVltr1cS716I45qk3To=;
	b=ctYW/Eioa17vHbXnyPyrRNPD6yw6zFKUA5N6TmPXc7/uSEQumQBUZg5I8OHCCD+uGU7Odw
	RqDRkTlHGnYqB0Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D1B6B13505;
	Tue, 24 Nov 2026 13:37:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8+SPJimTBWuuewAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 24 Nov 2026 13:37:45 +0000
Date: Tue, 24 Nov 2026 13:37:43 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: John Hubbard <jhubbard@nvidia.com>, 
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
Message-ID: <awWNyDZT2SVu2Zp9@pedro-suse.tail5790ac.ts.net>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <4f096d70-6f94-4148-8f47-242b8551e5f9@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f096d70-6f94-4148-8f47-242b8551e5f9@nvidia.com>
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Spam-Level: 
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: A3A8D1C0004
X-Stat-Signature: pqyy938oi96i348b7crd8mb13zqsf8cw
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795527470-73734
X-HE-Meta: U2FsdGVkX1+mXMetZjnzgArOGvnDghjg9oo0NlKem6ZBz8qUmvffdYqCojtOVv4EW8tWbK/scKL4Bs5dTldYaouLa7SVLm/bsvP6ceP18PjnQE741xqtLLfPmPacwl8LgkgzTSXZnsT9rPz4q+BGsFy0n8GY3Ve0r7TOFXEmrhVIJLCn3wyTcYbYWHDQvRtcUT/7f1UfkaQfR+wESN/zn47RmJ9FG7ymTGoJR6fFesASF/W3TJqpt21VAO2x6g2MOujyp/Fc+xM4mD8FZN1loAehyQcN/lFIJVD3omyHq5kGv6ZF2ox9VoK12ucVYXZWMXE+Ha5tX9qSj92GeedhcV80BKMAnT6vqkVwj93oD0BSzf5WgHACntQP268cVjR35uKh7AM7ODmB5tJj+v61SVmGdt6G6xTB7Zizfbvxj76oxW85ip6Q0l/y960HjnnkP4prfeYy/+lcCEeqsBObTaejKmIKJUuJwDGJ1Z22p77jgEUTbc4Fs9g9a8s4uoRQosrSNXJ8eR5mrDEWD9CAp+l88Mzg3Ei40m6nrHHLHzaZuSoY5fjcx5mFTj0iapy7Tesrgzn0QEWP4UdIv0qhvoIWjqhLooTSW9IWMnEP63yo8dv7ma/tNBXUhxQXSxhACoKnf4h9gjlbkuw2SXcAJbdogHs94vGRVHFLRz0zBF/JwLvUNMmFTrZmhrskd5NmW85D+QqIsU3LWOaBG+3eBlubSzSI7qal9t9EF+thq1vjWnUm0v8rl7WCa7NtePdHqF+6yCYPTgALeegixhn8qw6nZ3FeONmKMYMFqDfCGKYQzA6x/KK9f1Jt4wKMiMY4RDHoXEfHhcdYrHYDlY9pndJObYerBBPSjrYuaU30NtUv0WTdUWVX01x8qMZz1rR0xV64nzk6f54em8iHmT36qeijNqwqRqlu8uxLKFLpyZ9w2FnKFI9cIEuat54B3GhFIa9Il3mKIpnEaXGHXRB
 keusXLZv
 Vnf6G9QDzPnrYb57KEVshyCTDF+yHlwKn1pZ7yZznbmq25h7grOpS0fJo+P4L1BDMeolG6xUC6eWp5DCyDE1ReVAwKA2SfOZ9Q5d1mZpxmwe6g49zs+wS6OZ7b1ga1Eu+Z6Zm+qm7BoTGQzGhf5wL1FjE5JRj+4dI7bRLO2AzSJVS0XLRjr+75FAV5q461KatOmbtNu6PgqeizthC13So/HTPKpF0+ttW3fkzfLQhgSNOJKZx9rahkxa9lME2Vc0n5fA6NpfD3NJBqVqNgYWSNQ5wlN7E8nNv2HZ9dFKCZ3aukZNJ2fKASuFaX659+QWsvijqjEFLvzgJsHizfLbHkpvEQXtUA1iQ3GdVi2WRqbeWPYSMSPSeOhiEDY/gEGx+cPS/DqZ+r0J1RH/XFKKZpk5RlPIJAcl7sZ9CouW8y2qkUlknPUZDkrzpwD+wujWKtAaXA8bJqz7xfxsMyQMEE+lf6tJXmL5Yxb9gZI1Z87hofSkxDIGPtp6xY4+VYP5k4D6LCWdg2XAHloO14S1sq8ZJZ2GfPdv4EOfFybu6chb65EmwW3ZROSjcvRKMTYlMINO8ZNLMcqkVlZHkoYNBmwc3EyTgZrl+dZDO+Bp9m5dHvbTdeQCE8CNIUwMVUsZ9qMcHcmKLeD581zc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi John, Christoph, Jan,

Thank you for your replies. Since you largely share the same point, I'll
combine this into a single reply.

On Thu, Nov 19, 2026 at 04:55:30PM -0800, John Hubbard wrote:
> On 11/19/26 12:10 PM, Pedro Falcato wrote:
> > Sooo.... It turns out GUP dirty and ->release_folio() interact really
> > weirdly. This was initially reported by some AI agent, and David let me
> > know.
> > 
> > The basic issue is:
> 
> The basic issue is covered in a series of LWN articles that span 5 or
> 6 years:
> 
>     https://lwn.net/Kernel/Index/#Memory_management-get_user_pages
> 
> Probably good to read and absorb that. There's a lot.
>

Thanks. I was aware of some of this, but it's good to take a fresh look again :)
 
> The problem remains not fully solved. pin_user_pages() is a building
> block, but we need to fully coordinate with filesystems in order to
> finish. It's good that you are looking at this.
> 
> >  - ->dirty_folio() relies on buffers/IFS/etc being attached to the
> >    folios. It _cannot_ attach them itself, as dirty_folio() cannot
> >    block.
> >  - certain MM paths (reclaim, khugepaged, folio split, etc) are very
> >    trigger-happy when it comes to asking filesystems to release them. In
> >    most cases, barring any dirty folios, buffers, it will just drop
> >    them.
> >  - there is no problem in usual IO submission, but issues start to pop
> >    up with GUP, where the code flow (roughly) becomes:
> >         [get_user_pages(), etc]
> >            ->page_mkwrite() called here, or before
> >              ->private correctly populated with whatever the filesystem
> >                expects.
> >              folio is marked as dirty, initially.
> >        *write finishes*
> >        folio_lock();
> >        folio_mark_dirty();
> >          ->dirty_folio()
> >               dirty_folio expects ->private to be populated by
> >               ->page_mkwrite(), ->write_begin().
> >        folio_unlock();
> > 
> > What happens if any filemap_release_folio() runs (and succeeds) between
> > the initial dirtying (plus eventually writeback) and the write to the
> > folio completes? Welp, it's unpredictable. ext4 for example will
> > WARN_ONCE, and likely drop data (see ext4_dirty_folio()).
> > 
> > So, what can we do about it? It's complicated, hence why this is an RFC.
> > For the possible solutions:
> >  - ->dirty_folio() attaching this FS information itself is not really
> >    possible in many cases. ->dirty_folio() can't block, nor is it even
> >    guaranteed to hold the folio lock while being called.
> >  - Can pincount help? Kind of. Things like folio_maybe_dma_pinned() are
> >    rough, and don't deal with the usage of get_user_pages(FOLL_WRITE).
> >    pincount itself isn't available in the common order-0 case, and not
> >    available on order-1 as well on 32-bit, but who cares about that^W^W^W^W^W
> >  - Could get_user_pages() ban FOLL_WRITE? Mayhaps. I would not be
> >    opposed to that, but that's probably a larger change than ideal for stable,
> >    and I'm not familiar enough with GUP requirements to decide to go that way.
> >    This would require migrating all FOLL_WRITE users to
> >    pin_user_pages().
> >  - Can the whole system be reworked? Probably, but not for stable.
> > 
> > This patch series is really rough but kind-of works. Instead of using
> > folio_maybe_dma_pinned(), which only interacts with pin_user_pages(), I
> 
> pin_user_pages() was specifically introduced for this exact class of
> problem. get_user_pages() is now meant for other, much more limited cases.
> I've attempted to document that, here:
> 
>     https://docs.kernel.org/core-api/pin_user_pages.html

Ok, so I guess you want me to drop the hacks to make GUP FOLL_WRITE not
screw itself over? To be clear, the rest is still broken, even with pin_user_pages().
It just means we get nicer looking fixes, and I can drop patch 3.

It's unclear (to me) whether we care about any straggling get_user_pages
FOLL_WRITE users. A quick look around doesn't find me many; most seem to have
been converted to pin_user_pages() (though, admittedly, I don't know how many
of these are converted in stable; do we care?). Perhaps piling on a patch
to simply disallow get_user_pages(FOLL_WRITE) is ok? Giving Lorenzo's idea
a go again :)

FWIW I asked my least-favourite chatbot about get_user_pages(FOLL_WRITE) users,
and it found me a couple of cases. But little enough that it sounded fixable.
But, again, I don't know if this reflects stable, or whether we really care
that much.

> > ---
> > base-commit: 9663aa0da7070d958e333477ce0720512e9fa016
> > change-id: 20261116-gup-dirty-what-b73da748f5d1
> 
> A git alias to wrap "git format-patch" with a sed(1) invocation is a great way
> to avoid accidentally "leaking" gerrit change-id's into a posting, fwiw.

I appreciate the advice, but this is gunk that b4 adds to every patchset ;) 

-- 
Pedro

