Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A3EDCD4F25
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 09:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858D86B0005; Sun, 17 May 2026 05:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809D86B0088; Sun, 17 May 2026 05:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F81E6B008C; Sun, 17 May 2026 05:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60AC46B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 05:01:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5B94C2238
	for <linux-mm@kvack.org>; Sun, 17 May 2026 09:01:37 +0000 (UTC)
X-FDA: 84776318634.24.F6A2377
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id AB11614000D
	for <linux-mm@kvack.org>; Sun, 17 May 2026 09:01:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="IWuZ9Xp/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x2ARWsxV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VtCVOWHt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="oJ//3b3p";
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779008496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5aby9ZwmKZPtiMHVFEb2wDmgq8fqEOg9pkZ9u1EhJM=;
	b=zGKM6yzFYERCTHZAwUgCuWwBHfImln+dxjDJoufkEonFClZrgB6X/97ZHPVjPiM+tZgF/r
	dTed1O91bbgTHrTXVyRw3KiNv6AryvWAblEMXNBfPC72OUrV+VKkkpeIZN9pUIPJNVyeHn
	GSjN1Xyq9/wBK/+r56qpTWk1rx/sDPI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779008496; a=rsa-sha256;
	cv=none;
	b=QXLb1wwqyyr7N6UGJoU+8IQ8au1HA0xcDLNL3RMEivCFMKB96uDOq88aqfSzixVePAgdrx
	x0E9yw37OwxqSuviY+9wCFsvrLcL6+qKU1fm95gORSc0u/XCrt9MEg5vHcXD+vKjPqojEy
	nGgbS9nRE9fS1UqhX42n2QXgvbNZIws=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="IWuZ9Xp/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x2ARWsxV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VtCVOWHt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="oJ//3b3p";
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 006496A815;
	Sun, 17 May 2026 09:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779008494; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W5aby9ZwmKZPtiMHVFEb2wDmgq8fqEOg9pkZ9u1EhJM=;
	b=IWuZ9Xp/f6xDBn7X9SLDB1EXwr3GdWXxS96ZTPbApZmQE0DYGFEwlMF5fLrHQXrmT6HoQ+
	QjxOLcjrqKc1Gr9Bzct6/MgZYRnMoplvf4Ilzq5+zFqwBqGorRubfA13kctg2AIM6MuNk2
	aCrZ+tZWV0OFRJcJkRREMU5xm+5sKds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779008494;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W5aby9ZwmKZPtiMHVFEb2wDmgq8fqEOg9pkZ9u1EhJM=;
	b=x2ARWsxVZy34NTtKOHl7riHkb3hLAoNosfxwL9/MP4BNVQVv7UGtr9vrQ7o17vk/2E8yTr
	0muntm+tAtIITPDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779008493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W5aby9ZwmKZPtiMHVFEb2wDmgq8fqEOg9pkZ9u1EhJM=;
	b=VtCVOWHtiJCV8cgxqDBVZk5zp5a/qbIuczEeFfaIMyMgD9dVGA5sg3BuoevATGv05ZFneD
	S64EK0MCGrgTJ8LEW2Xsk3edZSglP/vWwYHGELbzBHGbjzyMCFtQIdutYXsYXoMVcmBSNP
	RqaQMdEfl37MJHKevkq39BbQKVAC1Fc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779008493;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W5aby9ZwmKZPtiMHVFEb2wDmgq8fqEOg9pkZ9u1EhJM=;
	b=oJ//3b3pnchq4Yy/Pg0zF2OPn/W8actU/4Oi+SFQo+qFCiL0oKtjZQgt4tQHfoPB4CjgeD
	390jW4t3lktHx3DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3A6E9593A8;
	Sun, 17 May 2026 09:01:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gBn0CeyDCWo/FAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Sun, 17 May 2026 09:01:32 +0000
Date: Sun, 17 May 2026 10:01:30 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
Message-ID: <agmDiAY-mmlvjX0m@pedro-suse.lan>
References: <20260516182126.530498-1-pfalcato@suse.de>
 <agj4mXKRVW44ZJ18@casper.infradead.org>
 <agkRpj4oU8TPgmTS@pedro-suse.lan>
 <agkXHu_ON_KyWtvP@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agkXHu_ON_KyWtvP@casper.infradead.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AB11614000D
X-Stat-Signature: 8mnq7nafwu1brc8iruxkuuujysbqrae3
X-Rspam-User: 
X-HE-Tag: 1779008495-807813
X-HE-Meta: U2FsdGVkX18pFtJUKtNkTvBGXESrMl/Pv2zG0sTocXgrlDC74JX8WmbPpz3laos5OElxIigdpd+OKJjJm373narL/BKu9atJWyWx9E1noIs97LnAc3nDXhxP0Rt/0EQyAfcIo4hj65q9DzLXZlJwCpSrShNVJNtkPjX31GDLnyfvexT/8DvGnAp1lBjilK8y1ju7cKn/zvLA/0JXK6S+uq1eEwBwes/0wSl0xUp857ksqn+r+DuzOda/F/uLJkhTeaHK/SbXZFHS+WGxghQetDQh9vZRbKW4STS4LYwsvmrhziitR1laYEy6Cs2qTrFa2sMsN3UDAKoxCkQ0u9bSTC2jUD8IzcMpuiK0++F2kKszBtcudCS/OcwBmJ9xBjeVrkkPn7fOGNup1JPcabvKgCpJQ9aqQqMK41++FTkSDdfg1VhGYWTRIteqJeuuTHzl9h3fVDjypaz7eA1+pZe045wNsSnPCOccbvn4ncKdoeVBHlmDZ28vl0XbGf+YHgACgX5d9M00lHAxqF3PVkzOHHG/jldEVM8rXR73I5+Gkp4KqRurJ5tu0WEEmXoC1nNIEOESB5uGNJrBgLs0mirh7hOMKDJb9FhOAY9LYD7OxkgHQ+lna/JYOG39N4wzHTLTxiGpb5CYq1uA+d6SM7rlRtFCrTV81aABaxbdfL17Zw7Ty6MWT7ARe/odegVSo+NCFdUeS1j+DsoqNugvOImr11FTBrMeOpu+WejxpHiyxov97XSz5ort1TKrzuxuaAv1wXxGoKdju/nnvXRdN3fx14ClRnHmeciFiMTVSPOngRYjy/OSk/J3wF67FmzBWWELoUPCcZ7mvm+mIFOUhm4/s2DwtHOozTKhIAzIozPI3iwDZ4SYw9z1f+GWoW0WEjvTlUDsWiQGYkHeMdmWmXjM+95anMjKECLDr/saDpwo3Y/aGu4DMOnYMHNHrzekZzSbZdceBv83Utb6FY8e4mQ
 QNbJg7oI
 72jywUgUzEKVam9kLPr9gMDJa8U9xQBpOMjA6J0pRxX9XmYORdsKDoehMHaqzzg0kTBEnbkCDYR4uXKBbH2zLo8YB3EzJUSKJPTIkSyGuCYRik/uIMn5CJeqZqOwvY/y0ukyF6Cvc7hseD05cLssEcTGPIV43ptGtszb0j3Ys6FHKD+qHFk0sCAIswbXX05GikGwHT73t8L4iEviShuyBJ3dN5VpsDC3J7TpH2MfJXoAzVC436O5vvchRhEZTGMSMkRaoiigFV9Rq/IhKGPFN47cmCauUQ8dFMGZy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 02:17:18AM +0100, Matthew Wilcox wrote:
> On Sun, May 17, 2026 at 01:59:41AM +0100, Pedro Falcato wrote:
> > On Sun, May 17, 2026 at 12:07:05AM +0100, Matthew Wilcox wrote:
> > > On Sat, May 16, 2026 at 07:21:26PM +0100, Pedro Falcato wrote:
> > > > +static bool may_write_to_page(struct page *page, struct address_space **plast)
> > > > +{
> > > > +	struct folio *folio = page_folio(page);
> > > > +	struct address_space *mapping, *last = *plast;
> > > > +	struct inode *inode;
> > > > +	bool may = false;
> > > > +
> > > > +	if (!READ_ONCE(sysctl_splice_needs_write))
> > > > +		return true;
> > > > +	/*
> > > > +	 * Always fine to write to anon folios.
> > > > +	 */
> > > > +	if (folio_test_anon(folio))
> > > > +		return true;
> > > 
> > > What about KSM?  It's not something we've seen attacked yet, but it'd be
> > > pretty nasty to be able to change a KSM page in another process.
> > 
> > It's my understanding that only anon pages can be KSM'd, and KSM still keeps
> > the FOLIO_MAPPING_ANON bit set. So folio_test_anon() should still test true
> > for those.
> 
> I think you misunderstood what I meant.  If we have a buggy user which
> can write to read-only file pages, then it should also be prevented from
> writing to KSM pages.

Hmm, I see. Are you suggesting we unshare KSM pages here? Or just straight
up reject them?

Rejecting would be relatively sane if only we had access to the VMA here
(in normal GUP), testing on folio_test_ksm() is less robust :/

-- 
Pedro

