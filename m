Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F40A108B8E9
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76E86B0089; Fri, 20 Mar 2026 06:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E326B008A; Fri, 20 Mar 2026 06:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3CB36B008C; Fri, 20 Mar 2026 06:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B2BF06B0089
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:37:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5225C86125
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:37:30 +0000 (UTC)
X-FDA: 84566089860.12.B28E39E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 30D3D20010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:37:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ettoXUll;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YD6AsqWd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ettoXUll;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YD6AsqWd;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774003048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zsoGz04enqZTkNgfCr46wNoG4jtDeE7xMBPnJaLoNFQ=;
	b=mcfV9yFfVINeXTsvltkH76DufPaSlicQXRA1Z3C8/K9tFzBKkeGaDIXB0raDRQeSVaJEBR
	JaSTFZASpN9YE3eDBTihc87X4s7e2AeYyXMAXHTZkjlLmErZ4txRK+f5adlA4jA+cMMZ68
	bM4lqbAW8iA+n4OwXYGSDK28+ZkSR9c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ettoXUll;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YD6AsqWd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ettoXUll;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YD6AsqWd;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774003048; a=rsa-sha256;
	cv=none;
	b=NQkg0b1hV0J4gz8U/Zv9rNxBegrNlJiNhCQGSs0yqo6F4J5np2RzRy+NUPajfyUXe19ZjR
	esdrnCqXIGWD0ORS3/QRnCXhmGx+tG52Ut9UsFl3iGINcwT3I1oTMcO8i1cS0j46Ln3Ej7
	rVxMzQdQG7IdETQyK31b8fL3ZZNNWNM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A4A564D248;
	Fri, 20 Mar 2026 10:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774003046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zsoGz04enqZTkNgfCr46wNoG4jtDeE7xMBPnJaLoNFQ=;
	b=ettoXUllM6FzsRKqYfBwe3oHupPrR7k6FXBAPz6u6gUBPfFdLR6AhIscWNt3gkc0Si8EIJ
	EZimk9FyDkgAkltDSyvICd7iHO6u+ueR1Ogvdw4gZMqpD7W1KNUEwmQrqBPqoAjOskuwM2
	sxUj5tQIIl9Jk4PibSsWn63tT54sK7Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774003046;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zsoGz04enqZTkNgfCr46wNoG4jtDeE7xMBPnJaLoNFQ=;
	b=YD6AsqWdhKKf3IVBDCqGTCkBrQMCr73qt8K1gC1CNDjjf31lWWBtvViBhTss+1au1ugm29
	idqGVIm1mgXd7wDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774003046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zsoGz04enqZTkNgfCr46wNoG4jtDeE7xMBPnJaLoNFQ=;
	b=ettoXUllM6FzsRKqYfBwe3oHupPrR7k6FXBAPz6u6gUBPfFdLR6AhIscWNt3gkc0Si8EIJ
	EZimk9FyDkgAkltDSyvICd7iHO6u+ueR1Ogvdw4gZMqpD7W1KNUEwmQrqBPqoAjOskuwM2
	sxUj5tQIIl9Jk4PibSsWn63tT54sK7Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774003046;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zsoGz04enqZTkNgfCr46wNoG4jtDeE7xMBPnJaLoNFQ=;
	b=YD6AsqWdhKKf3IVBDCqGTCkBrQMCr73qt8K1gC1CNDjjf31lWWBtvViBhTss+1au1ugm29
	idqGVIm1mgXd7wDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D448C4273B;
	Fri, 20 Mar 2026 10:37:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id a51BMGUjvWkVSAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 20 Mar 2026 10:37:25 +0000
Date: Fri, 20 Mar 2026 10:37:24 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Dev Jain <dev.jain@arm.com>, 
	Luke Yang <luyang@redhat.com>, jhladky@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm/mprotect: special-case small folios when applying
 write permissions
Message-ID: <qsrrjeosttys2yo2x47kuvazz7tjc6euqbikdofqhjajcwhqyo@qx4yorotuhif>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-5-pfalcato@suse.de>
 <7cd1e50a-f5a1-42b6-9d04-4e329d338f41@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cd1e50a-f5a1-42b6-9d04-4e329d338f41@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 30D3D20010
X-Stat-Signature: zmj94q3r4j1djs956nigqkb38x81s3wi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774003047-333306
X-HE-Meta: U2FsdGVkX1+1Sc1dIItXr+pBYMms2CE5ly6ZOYSWYWbVIG86rEjM+5Wg4oc8s1aAs0cyp2TJrsVXE9q5GnlKZWS48tGWkhUuZpyrnBGEMj49BhM7naBYtigzrHkx/OjQZA865Szt1KqlBP7FF4W20YgUhz7Zztjhmwp74SzH1TGJ2oaWKOaAc97nJtYcXZpBAmb2YhZ0bHjXiYLrTJt6JoG0zSOrEM+nF15228FPF9DfVy11V8RRv7u50H8rVRuDb5MrpE+0WETGNo2QYHvUbeuK6EWC8ZSsp3iN+QWVGHxa09/eMyFCk8/5fy8po0wLR+1j0hQ2WtonqQgibQPFCrWM2jRhoJTz2p+sClW32MhGJfeQgZKVpoJ4YsruFSr5wp1aybbNussBVmDg69gDyjWZXojgAJKtxEnzZRttCbgrJXuCTds6tFvbgwx0kNJi5u4q+5sKHVnR+KzTU6xdN+ISHPSia0Wxyf7jA/lE8cNmklVSORjbAkmX1ZcSAebPQETLXPZ+TABKqavo6Tx+qwLMrGIkDciaX3gla/HTbCaCujRpiht+uRa4NJPMjdLD549v1N2xBoVSmV1eiaPfoL1rP1q3sP31vJClJAv8XuQliLJdbTPSb4g0spsudFk4SZiORWDo2QOtYmOSPFPLSQYD4WvwcItBJTdNXsllSx2eXWJdQNDLwTG/r1qehX46SKiNA70z9z2sDHo0k0khUXvBF30p5Lhh2QbKKtL0xl2q281bb/5y0H3V/trxllhzGH1WE0T2geI1epQ7rtIjwujYWOI3vn/HjI6mUSWoj6bWbs8uKCV7ZEzSQMSXGkGt46zoDFsGaq+6WrYTLKa0FntqF9VI2z5kJjjbTs9i8Q1KAyx60ulZ8EaBvH+A9Pp/elR8lcgIUVNnseaR9e98dsM3eKWlQs6WVC8o+e4cuO8Vn4H8LE+SYnAngPAAYKYvLDPxRx8gUBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 10:43:35PM +0100, David Hildenbrand (Arm) wrote:
> On 3/19/26 19:31, Pedro Falcato wrote:
> > The common order-0 case is important enough to want its own branch, and
> > avoids the hairy, large loop logic that the CPU does not seem to handle
> > particularly well.
> > 
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > ---
> >  mm/mprotect.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index aa845f5bf14d..23a741f9a4c8 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -170,6 +170,13 @@ static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
> >  	int sub_batch_idx = 0;
> >  	int len;
> >  
> > +	/* Optimize for the common order-0 case. */
> > +	if (likely(nr_ptes == 1)) {
> > +		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, 1,
> > +				       0, PageAnonExclusive(first_page), tlb);
> > +		return;
> > +	}
> > +
> >  	while (nr_ptes) {
> >  		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
> >  		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
> 
> That should likely be squashed into patch #1, because only then the
> inline makes more sense.

Will do, thanks.

-- 
Pedro

