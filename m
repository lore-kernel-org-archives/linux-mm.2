Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0B5B108B8E4
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CB036B008C; Fri, 20 Mar 2026 06:04:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A32B6B0095; Fri, 20 Mar 2026 06:04:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7A76B0098; Fri, 20 Mar 2026 06:04:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 33C606B008C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:04:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0604A1A0143
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:04:35 +0000 (UTC)
X-FDA: 84566006910.15.E25EEF7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id D3868C0012
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:04:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JrAm9Aet;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NauPAB9I;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JrAm9Aet;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NauPAB9I;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774001073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hx8aYZBhNpgr88F+KNS83FRYqr+PRYSxaGdz/pedq3k=;
	b=MR62XtSzxu/Nzs+A1OHV/I9akvjMv/3WjkaSgi4CE7DaXN0K4EbEwug/E55z2kTVI4Yb7B
	FMjTfhUnCRI29OebXJSpGGkYDz/6DKiSH/+zANeVOfOWtyIc9khAtcL7sHD3v0HexaKXDB
	LGnfQWKVkcQY+Ijj2PmFqT9Cxfy67x8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JrAm9Aet;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NauPAB9I;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JrAm9Aet;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NauPAB9I;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774001073; a=rsa-sha256;
	cv=none;
	b=r9hBcxoEDutw/VNczRComtbcCDNQv8228yEmS0Jl2QZGTsYohwgR6pWVOuYmmPkIpLj6nH
	HR4pja8vK8DAdlrOZ8YRgIWUQTfPqe1JUYvkW+oH99IXy2lTIX2t0P+XSmd/GNhpmzciow
	RrOw6/8AhHo13SLQySj7B5DJ29QKqpw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 51EB34D21F;
	Fri, 20 Mar 2026 10:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774001071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hx8aYZBhNpgr88F+KNS83FRYqr+PRYSxaGdz/pedq3k=;
	b=JrAm9Aetvt0nadsia8DsPrrXsTRd/Pr29ZkRQay5DY0IotfnHlbuflrwgO1yi8/B/4vqj0
	qvdFKEIuyDY9RL+BhP3BByJOg5byN2ms7iyp6f/s06FgTb/EkSMjRpXbFEMsH/JUIEbz4A
	TRmNeiro0DG49Nz+Iv/2JwZ+3Catfkk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774001071;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hx8aYZBhNpgr88F+KNS83FRYqr+PRYSxaGdz/pedq3k=;
	b=NauPAB9IT3omQ2VWRrNFx/IYGpbUoW+oENcOAgEsSV/rLI1x3UcOAVzhzLcHwJpov24AKs
	48kOXn+5Uv7eh7Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774001071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hx8aYZBhNpgr88F+KNS83FRYqr+PRYSxaGdz/pedq3k=;
	b=JrAm9Aetvt0nadsia8DsPrrXsTRd/Pr29ZkRQay5DY0IotfnHlbuflrwgO1yi8/B/4vqj0
	qvdFKEIuyDY9RL+BhP3BByJOg5byN2ms7iyp6f/s06FgTb/EkSMjRpXbFEMsH/JUIEbz4A
	TRmNeiro0DG49Nz+Iv/2JwZ+3Catfkk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774001071;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hx8aYZBhNpgr88F+KNS83FRYqr+PRYSxaGdz/pedq3k=;
	b=NauPAB9IT3omQ2VWRrNFx/IYGpbUoW+oENcOAgEsSV/rLI1x3UcOAVzhzLcHwJpov24AKs
	48kOXn+5Uv7eh7Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 89B004273B;
	Fri, 20 Mar 2026 10:04:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jiQ0Hq4bvWn+JQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 20 Mar 2026 10:04:30 +0000
Date: Fri, 20 Mar 2026 10:04:28 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Dev Jain <dev.jain@arm.com>, 
	Luke Yang <luyang@redhat.com>, jhladky@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/mprotect: move softleaf code out of the main
 function
Message-ID: <ypaiecdbqmma4imr3euccouexs4uecaacjr4aucv4vynz3xbrm@4xa343ivvazy>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-3-pfalcato@suse.de>
 <f0ccf41d-16ca-404a-bb84-fe038bcfe0b4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0ccf41d-16ca-404a-bb84-fe038bcfe0b4@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: D3868C0012
X-Rspamd-Server: rspam08
X-Stat-Signature: 6d3qk5zac1b9ntz8e7qwryzde3q7ptxh
X-HE-Tag: 1774001072-710240
X-HE-Meta: U2FsdGVkX18J8W6Dw1SYB1xVVIR2SDvvExnh/k878l5X0qru4kra8W0NvF3ZN4tGC1Epb5lJBpJYxssWSqYdiJ3XLBVT5+tgMe/x+Wq+Zbh5XTx/Z6D+gYXr87Bn6H/fzRZbX4DmdCM69MrBl60noNOA+jBlyhRsDzPrj50uvk5Zq8BKzM++cx6DNqOIh1uSba5y+qBe0+xa3yzEw7Mvr3uLHV2IpDWJ107W1NqHD11rj+ivPMYDrz+nN8aTTVNvsKDDFyXqrGUPuWWKS4xiy1RzeUDiq9cJtFZGTSPOFXRGbG3kkfOPAm3HBEwTXXwVBSsnL7C2Fi5TXzK1zjjBv9BElKcFezAFziMevi7yD7XOWk+oyrJaBQaDh6c2tDIzMXXqvo6XzzrKmFVQD+DBI7sh6TlOuTD41DUEzApOaBzpUjU1grnrQpFkgK8wf2aJLcDdHWw7GDzw/PQrRAvKXD7Psjt2zxiTA+wKFNtBqQX/wspyBgaMJdAKm3fMohOywZh+aGaoTJ+7Rzw27CwtY605tbgE86jCzf4Vymg411vzqN3RV7dKSD7bHYQj3WGIJn3Ol/g435p+BrlFIt2KcgfnICsJ35TnCH842b5l7Mx2AoupsJSAh/PX4T7/vYPDTQ48NVY3U+NOAd4C74obDKQPMDoiU4XvfwtD+RRQUWv8vbnA9kVZaJJ/H98sqtBVLSy8ubtY/gKShnvIdg4wVbrhhzRAxjlhZOfPa48fCRahA4ExAU8KnB0z0HhXjLgip2Vx6jC+k/xGw+Y5ZsFi9aAFV6LUsUzYofSGvuNOjOLpSMqxKbCtWKnalh5kGA2wNaboWPAZImBK5blK1ZBSeawkjWv8j9j5pHbDU8YdhMB2TS3cx570xUMZ7atAul4LFkUQJWilCjkUsaBioZj62Vr/Y33SHwUwq9Kb5ug+3reKy7WP9ac9LdNbVfxY+6Wayhj3r8KUB7kN3uTv6Sa
 xN4d2QzA
 rVHt1hb7DjVrvHlq1uK3I8frl/fWXoKkwJV+vYIqcmzPt0L1qPLRhOzfjDuZdQ3UcLJlhMKQBfEg6PjczSzaCWlVks37Xnswp25y/U4oYalQVb0XjCIbCYZKPz8Ti4XHG4HBn3vyUQlMnyBenJhxVbOcXCnTC7rc9dVvDGx0d8S8iAiHl2ZRK1pz4l5UyhQ57RB4m8Sz/TWFLkWp/Uc2vdlbGyqcUh9aivIN74kbdSqaYJRi5YzLchFx9Fi5Buzf2XGFcbBdCnPxuqFlnsOzpP6wpCK4Q7vgZSAdeLqZy22c+Sce1nccp2HcPYIPaUHY32U4lTS5LPe1h1OU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 10:33:47PM +0100, David Hildenbrand (Arm) wrote:
> On 3/19/26 19:31, Pedro Falcato wrote:
> > Move softleaf change_pte_range code into a separate function. This makes
> > the change_pte_range() function (or where it inlines) a good bit
> > smaller. Plus it lessens cognitive load when reading through the
> > function.
> > 
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > ---
> >  mm/mprotect.c | 128 +++++++++++++++++++++++++++-----------------------
> >  1 file changed, 68 insertions(+), 60 deletions(-)
> > 
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index 1bd0d4aa07c2..8d4fa38a8a26 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -211,6 +211,73 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
> >  	commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
> >  }
> >  
> > +static noinline long change_pte_softleaf(struct vm_area_struct *vma,
> 
> Why the noinline? This sounds like something that works good on some
> CPUs and bad on others, no?
>

If you don't like the noinline I can always remove it, but see my other email
for the justification for most code movement here. In this case, I don't see
how softleaf is the common case (at all) and it's a sizeable amount of code.

Note that the results don't show improvement here (in fact, the opposite),
but we are also spinning on the mprotect() system call, so it's hard for
the icache, branch predictors not to be primed.

> I like the cleanup, but the noinline really is odd.
> 
> > +	unsigned long addr, pte_t *pte, pte_t oldpte, unsigned long cp_flags)
> 
> I'd call that "change_softleaf_pte"
> 
> > +{
> > +	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
> > +	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
> 
> both can be const.

ACK, will do!

-- 
Pedro

