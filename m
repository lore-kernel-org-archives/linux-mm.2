Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 441F9CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22B436B0088; Fri, 19 Jun 2026 15:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA766B008A; Fri, 19 Jun 2026 15:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3216B008C; Fri, 19 Jun 2026 15:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD4566B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:26:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4001C120552
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:26:12 +0000 (UTC)
X-FDA: 84897642984.16.B702763
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2E79320002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:26:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oMEO8hZa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bTCPSDDb;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=06fyhC6H;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JeIK+lkQ;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdvOATWDJgsgvJ4pTMkmozjLJqD5xTNUgtRdb7I0nlA=;
	b=vOCjBOHKHnw3tU2a0Ty00i+vN90W9YFFURJPw7QhwHhoOwMz/SGNW5jKmiEzd0OaOn3ozc
	6eqCpqsIJBGSXaECOynWa07smpVwJkajASakI5l8vWG7TcbMqCWyjd8KH4K6KqE4gaCktt
	yZ318yT40mPPs/ezaTx4b0T/NW/iy9U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oMEO8hZa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bTCPSDDb;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=06fyhC6H;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JeIK+lkQ;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781897170;
	b=BmQO1Iiejsn6Qd8UeB5sCw1uW922E7wzVAqsx00VI3wOe3YhyPKgCZPxsZl3DhsTEB8PLB
	Pbf35ygDKjOPZrBwbZurthd5L/3pBbWl6wLP3OhsZlb2CNVtXBbu8Oy44o1cN1AVff/P+T
	UcVVGMdnds7+uNtaAuCYcpIxsVxIhBA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9CBEA6D951;
	Fri, 19 Jun 2026 19:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781897168; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bdvOATWDJgsgvJ4pTMkmozjLJqD5xTNUgtRdb7I0nlA=;
	b=oMEO8hZaAB3s+yMA3xxmwcE96tG6O97KNtS/9p8M7zkAfahUukMyrolns/UC/uiOhX6cKy
	zw96pI8H8R3UxobMu2v3dJqosw9bpYnwYlh807U7WhhY82ndp4nkCkDuBgSpNBFPNWu7Sj
	Y0lnl/MaFUMsLafPOYqINGtwOdHCPRY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781897168;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bdvOATWDJgsgvJ4pTMkmozjLJqD5xTNUgtRdb7I0nlA=;
	b=bTCPSDDbbYCypVwaT1zoifJOs+W7Kk0oOX5w+E4OeC+1WG4FylOZc60OZdHKRO64BokwM5
	Fqhcd2e/ZflMUoBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781897167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bdvOATWDJgsgvJ4pTMkmozjLJqD5xTNUgtRdb7I0nlA=;
	b=06fyhC6Hc4LG7XFbzycWP5Nshs3yEiLXtlTcbzFg89KEbdJyCRrf6nxIYS61Ekp1MTo8xe
	IcN+Jqrc+pCFfYTX0w1jh2x9eiPfl+3Bi547DhRBYUtTA4Y5X+glZtD4lSuZt56FmWmeMZ
	21SMexJn5qSq3vbpnnoakXkvJVVKY7s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781897167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bdvOATWDJgsgvJ4pTMkmozjLJqD5xTNUgtRdb7I0nlA=;
	b=JeIK+lkQc7kqWzspBwkOBkhSZJmVrKSExZWW84cZYO5e6kEdZTkGQ0slsfkZXV8hABe+VP
	aCUHzA35//8rdQCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CD73B779A8;
	Fri, 19 Jun 2026 19:26:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gPtPLs6XNWo4OwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 19 Jun 2026 19:26:06 +0000
Date: Fri, 19 Jun 2026 20:26:05 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Frederick Mayle <fmayle@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead
 to VMA boundaries"
Message-ID: <ajWXEn7gECvgG7F5@pedro-suse.lan>
References: <20260619112852.104213-1-ljs@kernel.org>
 <20260619093711.d0d37c9920b3a16394c356a6@linux-foundation.org>
 <ajVz1nhMn2JwucMY@casper.infradead.org>
 <ajV0TbwEyaKMzoa6@lucifer>
 <ajV49Fyogfa6aIjy@pedro-suse>
 <CAJuCfpGdxsPDbxOwQFdY+Xt7mZGFvoKWmed6FteTongvFgjgww@mail.gmail.com>
 <ajWAYBXHJniJAO4u@casper.infradead.org>
 <CAJuCfpHF1qtpHZQzLmLi7xz06OWgBfduHqBHF_-0Vkx7OtBmcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHF1qtpHZQzLmLi7xz06OWgBfduHqBHF_-0Vkx7OtBmcw@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E79320002
X-Rspam-User: 
X-Stat-Signature: nceq5uh51j6mp9u3853atq9n4dozmtqf
X-HE-Tag: 1781897170-994611
X-HE-Meta: U2FsdGVkX1/fV/qOki9U3Hukl4aLA8zk/9HQ+jZOg+nm1MVnPLk/TOFLAaLwuZNWmBWC8Rnmv47SFLH5SlCWxNBvJVL77spQxafkyE2/qcOLl0igGEkPGBL8E5nSljBU4iIuMUZHXB2DJ06b0LZU6ZVTRarBu4CacQbDGe5XSXHEgk9RKXz2yXl2/NbUJG1BOijDMl6yo6fKUPTmHWiHsA4dZtAsDGBiYJCg/EdSFWODUxKwwoOOKdDDQw4fDRYTkNkqsmAj6gFNrgeiKWReT8UKD/dOg1wIsim0/Tx62ZZiq29p8+yfzp1qUl5Lvi3NUjCN3HbJKs2w06m8CXI3LufaJBcQwRe6jO7UAH6H+6Q4WqeKs8NJY0tZgt5jiHAMTMJJ8hW8o4FEa8tT/MzVY8+iT2VwUjBPT5e8ZQguWD4rt+9KFC83fdov04VuusaL8fi4oyrxUL20IJkalCsEK2wCQJfcLUN2daGfUjOucl22+3TgRRxIx3KqtaHOByn5tzMd1bi8Q+z09zoQl3qWEBqJjV5WByB4z8xGoyakbD11UM7D//+F2JyrZo7R5Jv5DuF2Bpx//HJWJxGXHcsIEFJ0bPEZDXBF5muXYgm9B5z64i6WL7g0KP0UVv39L+qdKvBSxMuUKffs3/CTkuBTcQ4sYe5QWHGIrkpaIxix9ikyAbeMIFgasgtcpg7o8DGW6rhCWhztbeeCiAa1fbxIsnSIil14BBxlXA0X0WWfyH/ov7SCsjPlpxCExFOePkPMTbSnJQ4NOuObzgTke8JCWs3yA7J09BqUlAKUL7gtwwNDJy+ekaVY91r65AnWwvQSc9XklQZgw+qMJCCllTBhdqFikeSHFdQQTre4Uly/1BmwpLXI7hTXCUvr2U4/AomVnJWDe/BSz6VOKzXOxzPAdYFk+vvts3lWIjcsOx6pIcM/s7XT3qXGdnrBRCNiBJDZC7+gNXcEH/HA/edka/P
 CbswXpPD
 Hl6gtAM4T+duWSNxzTM/+A6YFy/o4/hGlQuxhrTwdXHIyzUWalj6cGvMzhMWL851agPf1xqOo2N0VKSVhNYNA5f5B54Mw3LBNnpN2wCBSJ7DdZCt6YVswte9HzGjh6UKsYOuimazNbhMIHXVdfIv+g55OPa2xIkJ3OuC24kVwXtj+yin2nJM/b+qFNsR7AkdED87YnW7k56ETEMlvhwlDX6IRYHKkUbBCwQsJm9pL/N01ZsWYh1SrPC1ACwDp+Bsf1PzwswZysWPpGkEGgIT423HWk85wF/12PTQ2MNsUIw7R2fi7gr2oPO/h0XLbVUVGzrGAQfgJLT7nngPtZKI7/xOyt/LdVdkZdMsc2FcaGzZk+Ka0DtmjZc0ILgETOt51RM4F0X1Rb6DwtiQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 10:52:07AM -0700, Suren Baghdasaryan wrote:
> On Fri, Jun 19, 2026 at 10:46 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Fri, Jun 19, 2026 at 10:43:06AM -0700, Suren Baghdasaryan wrote:
> > > > Yeah, the mmap usage on SVT-AV1 is a little suspicious, but I guess the
> > > > pattern may come up time and time again for people doing chunked mmap
> > > > reads. I think we need to take a closer look at this change.
> > >
> > > Frame-by-frame mmapping for a streaming workoad is quite questionable
> > > IMHO and I don't think we should be optimizing or encouraging such
> > > usage, but I understand the reasoning for the revert.
> >
> > If userspace is properly tuned, it doesn't need automatic readahead
> > at all; it can disable it and issue manual readaheads.  The point of
> > automatic readahead is to cope with userspace which is doing stupid
> > things like calling read() for a single byte at a time.
> >
> > Could it have better defaults?  Maybe!  It's worth a try.  But those
> > attempts need to have a very low bar for reversion when it turns out
> > they affect other workloads.
> 
> That what I meant in the last part of my reply :)
> 
> But in general, I think that benchmark measuring "how many frames per
> second a CPU can encode" should be revised so it doesn't depend on
> file prefetching mechanisms. Otherwise it's measuring something else.

To be clear, that's not (necessarily) a benchmark, the code we were
looking at is their encoder app.

(it's also generally not possible to prefetch the whole thing into RAM
because, well, raw video files are quite large)

-- 
Pedro

