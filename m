Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 234BCCD4851
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 00:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07D406B0005; Sat, 16 May 2026 20:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02D906B0088; Sat, 16 May 2026 20:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5F146B008C; Sat, 16 May 2026 20:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D292D6B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 20:59:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 729BF1C0366
	for <linux-mm@kvack.org>; Sun, 17 May 2026 00:59:47 +0000 (UTC)
X-FDA: 84775104414.22.5BC91BD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 34B97140007
	for <linux-mm@kvack.org>; Sun, 17 May 2026 00:59:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="H/qUIemu";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H5ffgJTN;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="H/qUIemu";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H5ffgJTN;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778979585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h86kkWgyYcudDsr22xFMuZPneeAXkcdGpM6QgUrvRVY=;
	b=Ug1wk872VGf6eUxCzyk/3rGGm8kRYZqYLxK85Flfh5afwoN6ViSBk11IiQRRTmkePZV+gu
	dlrBPapETjvPuSxW70f16sjloUP2UfnVJ6dItZoPxNLujDW3V7WU/H1PqvncvqdCvMUSvh
	gQamcEpW0NQjIDQ4NTuv+atdDe4Aqts=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778979585; a=rsa-sha256;
	cv=none;
	b=8KA/GuLHd78ZHybAlZCXTSgedGH5wOcahJPwDcw+HSOF1NlaYDiIzbU4nmK0KZyYL6Gr8o
	MvqPdpW+/tFHcsWWp7GSPj8MtcO696RV4GPXHcu3gz68A+SwXMfcsvrCuvT+M8yofORWxU
	YYmhF+ktSnfEmc9DOxreXBi1Z9CiwI0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="H/qUIemu";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H5ffgJTN;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="H/qUIemu";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H5ffgJTN;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9F2A15C99A;
	Sun, 17 May 2026 00:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778979583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h86kkWgyYcudDsr22xFMuZPneeAXkcdGpM6QgUrvRVY=;
	b=H/qUIemucRVXOQUZonXUxnpIUeDwB0G7IpMCUx0pwEMlHAfRRnJTX8KNYz23+ZWEYeadzv
	DHE9xElP2w1BhnSP1gWqZ/xO+lKekdpbHVmm3MC3w3Y9iKX5Cv3QFnQxsaQmRIkCyqgUU/
	1FOb14pNe7+5S06oU1HGJ+GGKjLVqsA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778979583;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h86kkWgyYcudDsr22xFMuZPneeAXkcdGpM6QgUrvRVY=;
	b=H5ffgJTNzXdrdrNLOIGsRQCTSW0oQ/oqcqe7e1V3PRp/vcgG46qrn2pQMoM7kBrsyRbouZ
	z2YNKmoIH1FPwwCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778979583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h86kkWgyYcudDsr22xFMuZPneeAXkcdGpM6QgUrvRVY=;
	b=H/qUIemucRVXOQUZonXUxnpIUeDwB0G7IpMCUx0pwEMlHAfRRnJTX8KNYz23+ZWEYeadzv
	DHE9xElP2w1BhnSP1gWqZ/xO+lKekdpbHVmm3MC3w3Y9iKX5Cv3QFnQxsaQmRIkCyqgUU/
	1FOb14pNe7+5S06oU1HGJ+GGKjLVqsA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778979583;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h86kkWgyYcudDsr22xFMuZPneeAXkcdGpM6QgUrvRVY=;
	b=H5ffgJTNzXdrdrNLOIGsRQCTSW0oQ/oqcqe7e1V3PRp/vcgG46qrn2pQMoM7kBrsyRbouZ
	z2YNKmoIH1FPwwCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E3DC8593A8;
	Sun, 17 May 2026 00:59:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oO0JNP4SCWqAVwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Sun, 17 May 2026 00:59:42 +0000
Date: Sun, 17 May 2026 01:59:41 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
Message-ID: <agkRpj4oU8TPgmTS@pedro-suse.lan>
References: <20260516182126.530498-1-pfalcato@suse.de>
 <agj4mXKRVW44ZJ18@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agj4mXKRVW44ZJ18@casper.infradead.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 34B97140007
X-Stat-Signature: hdfywp6egorcxpbatcm4pk64kanmehcj
X-Rspam-User: 
X-HE-Tag: 1778979584-308854
X-HE-Meta: U2FsdGVkX1+MJ00oYKK5MyERV4zSQTceYgOwDTrho8glz/EMdCRoF3MKLnlTToNwt9AmUeSyHFQzS1fKL0DA+vIGQMstalS9UyP7z+zWD3GlVexALaPZmoC3AKckndGvzJPoZVNOdijvvDtBYzcDJtWfNezK17fECwGTrXjyoyN+yQz6hY+/XG0/K/mbkOvMVuZvJ+hp8eHHzaRWiz/aO/SGFWwDuNfKKo3I5MMn4YIyEfswyGbxf+2N4Q9ZUxeEoRqJ88ihzaF6WAOwxRMfZjiJIIzTfcqOI0wuH3o+5+tHpXjnL8GvplBoNwMms9NxFBgnr+HDILVoz1/oQ388KRlmCU67Rxo3xwY+2zlvXEnNiNIZY/XMmig8UV9ZFCgejsL/AxNPVvPievRN8xpTvU84Qm+9PQ6heR3eU9KFIEvH+LGsmC5l89N6+kV5yiqesARchsB2u39tpzubSMv8BnQr5Dyg4Ttv+xg447kQjkltrlEqSxQA2TGXmiYz+mEMreeCrK3n0yURBi/sa5vdv3ZatipXWWmmBrBBGONoPQKlBpN+UMMt3UnBtvTwD2OpnIis9nlrPdJd4nYgXdONbD5Oox0Hp3kXvXKtUFrVxtJLi8uTeIJtYIOOPsKCqURSjPrj0sc+klYOh7NGp3E31Mh7TqOKIltvKBiAg+6SBxH1pPjsIrxWSoX+3C7g/JaMJslhYWLzNPutqHD7LTiBOEGws04Rkqa+bmsLrRi0MtuJ/Q+BdVRu3byUMSz1p2rrfIKcQ19putCUjjVFklXPxto8RuawgRBqTbxS9ObZeKNRwBG6u/LhYE9Bw5JwdpZALFC+8bivGTCkxn8XD/vSNbnu2dg801nPX5HR7+psjUd6rtZAaflnhSAv/KPKFI/VlbymFREBqYvG/WL7mp1eVv5I/Y3F4/w4nOjNhKyvYUgRgUhwH+eCOJ5SG56ar1CrxXq6XYvenxAGP9Ssfjd
 2xehpg7h
 XF5UD2uYSU9UuA8PIefuCpChYl1bSywe/RBLvMbZu70vM3Bo7gVjFEJIhPLahV0NQ2KuhrOS2g5NeTNm480DWPr338o40sW+ZCFRwjsnfQeWgNnwkreL0wtgBkDMSNpWfywXDetJWiQdCAMaHo6Lne0n9BT4vuF3eIhzLHs/pI3Y+AUGYjPiRAWYbVda4HmbtL63P4jl9T7tsM4RP+SP/ThOyhZ75Xcw7F9cGgHE+V6Czd1jn23k1c8VA/VJ4WFzL2V15SPTnwpsymbQ971u2XJY89ocLr+w3ruge
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 12:07:05AM +0100, Matthew Wilcox wrote:
> On Sat, May 16, 2026 at 07:21:26PM +0100, Pedro Falcato wrote:
> > +static bool may_write_to_page(struct page *page, struct address_space **plast)
> > +{
> > +	struct folio *folio = page_folio(page);
> > +	struct address_space *mapping, *last = *plast;
> > +	struct inode *inode;
> > +	bool may = false;
> > +
> > +	if (!READ_ONCE(sysctl_splice_needs_write))
> > +		return true;
> > +	/*
> > +	 * Always fine to write to anon folios.
> > +	 */
> > +	if (folio_test_anon(folio))
> > +		return true;
> 
> What about KSM?  It's not something we've seen attacked yet, but it'd be
> pretty nasty to be able to change a KSM page in another process.

It's my understanding that only anon pages can be KSM'd, and KSM still keeps
the FOLIO_MAPPING_ANON bit set. So folio_test_anon() should still test true
for those.

> 
> I just got off a flight, so hopefully I'm semicoherent.
> 
> > +	mapping = READ_ONCE(folio->mapping);
> > +	WARN_ON((unsigned long) mapping & FOLIO_MAPPING_FLAGS);
> > +
> > +	/* If it is the same (locklessly), then LGTM, proceed. */
> > +	if (mapping == last)
> > +		return true;
> > +	/*
> > +	 * Else we have to recheck with the folio lock held, for mapping
> > +	 * stability. TODO: killable?
> 
> I wouldn't've thought that'd be necessary.  The folio can't be being
> read because it's mapped, and we won't map a folio until it's uptodate.

Makes sense, I'll avoid the trouble then.

> 
> > +	 */
> > +	folio_lock(folio);
> > +	mapping = folio_mapping(folio);
> 
> I think you're safe to just look at folio->mapping here.  You have a
> refcount on the folio so it can't be freed, and I'm not sure there's a
> way to transition from page cache folio to anon folio without taking a
> trip through the page allocator.

Yep, makes sense. I don't think there is either. The worst that can happen is
that the folio could be truncated out while we have a reference but not the lock.
I think I just used the helper for the sake of using the helper, so I'll replace
it with ->mapping.

> 
> > +	/* May have been truncated, etc */
> > +	if (!mapping)
> > +		goto out_lock;
> 
> typically we call this "out_unlock".

ACK

> 
> > +	inode = mapping->host;
> > +	may = inode_owner_or_capable(&nop_mnt_idmap, inode) ||
> > +	      inode_permission(&nop_mnt_idmap, inode, MAY_WRITE) == 0;
> > +	if (likely(may))
> > +		*plast = mapping;
> > +out_lock:
> > +	folio_unlock(folio);
> > +	return may;
> > +}
> 
> I don't have a problem with the idea, other than it's really sad we have
> to do this.

Indeed :/

-- 
Pedro

