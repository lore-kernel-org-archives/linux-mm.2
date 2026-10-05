Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6620BCA5FFC
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 16:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497FC6B0088; Mon,  5 Oct 2026 12:26:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470466B008C; Mon,  5 Oct 2026 12:26:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35EB76B0092; Mon,  5 Oct 2026 12:26:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 121436B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:26:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 93D7140326
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 16:26:05 +0000 (UTC)
X-FDA: 85289099490.20.2364E10
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4E2E1C0002
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 16:26:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="k5ruQcs/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/uqe5lrM";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Bna+jeUN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ljolE5FX;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791217563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QCxilX6Jn3NHwpmrQszL9nBtZP+KGRKGSWPtHz/iVU=;
	b=iORB56di2wmFGoghn1ftGQTnnwvfprrLm1O2lTP0mdPegXPb9WVR40E3uhCpCBuj3KRCaM
	koop84qO4lSveySzQ2gyEqQmiPQJN75XZ+GMHU/oRuyLdmWpb1XoNIjfWgT/WISjfRhleQ
	9zVxLBy7dI9CGHtwR4FtFkvM9snDAJY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791217563;
	b=BX3DYIal96zLAAkUOJbpAJK1UDiFXYogqGj4v4zCdCeHcanYcPeUpcPp1YmXVANB0sv+tR
	HihRs9UPeOmQIGipRu/TBp97VWMrYcCNE210ZTb7W8QVoqSdHUrnzvV8YBZrW0ZmooUnOe
	7+fY9MF3qkEspbMTf4rFyGfyz8K9X7Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="k5ruQcs/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/uqe5lrM";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Bna+jeUN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ljolE5FX;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 534A521CC9;
	Mon,  5 Oct 2026 16:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791217557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3QCxilX6Jn3NHwpmrQszL9nBtZP+KGRKGSWPtHz/iVU=;
	b=k5ruQcs/on2VIzOXmxqSS4IfZ8wf8r/4SV8G3Fdr+JJby1qa2X7bl98nKgAAgmZd7yJal0
	otTQlTiFFDc4hYaJCiCJkvNAQdvOiPbNod2YvcEkkXtdLYNSTuoBho0LcCoqlRHhD/EPzb
	uzIYbioILKr1owBgdsDbD40Qq/c2pnw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791217557;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3QCxilX6Jn3NHwpmrQszL9nBtZP+KGRKGSWPtHz/iVU=;
	b=/uqe5lrMr+KbBX+d1oDtcrnwCe1K7WykRsGn5rf3yW6RV1/KVRPYtWEVdt9FhzndnPexep
	HxTgMuod5n952/Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791217553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3QCxilX6Jn3NHwpmrQszL9nBtZP+KGRKGSWPtHz/iVU=;
	b=Bna+jeUN7vDJuAQDE0OYULGaLBRqrJz0GjUweYJBDTlet0ToeEucKYTWFl+8qfEt9gnXE4
	xqCTx1ilWdrVH7SHLfJ9pKPNEVugJPw7/Y6UD8bGfiXkY3vwAiseYC6RimegfTLJsR1LXU
	txWfS2NAwOIRp/jrk+uoZ/aErveQLzs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791217553;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3QCxilX6Jn3NHwpmrQszL9nBtZP+KGRKGSWPtHz/iVU=;
	b=ljolE5FXb6fhoA41wVfhQWOHSZPyVH3M4vv8Vv0KneEzDxhIsyyBZWCJeZXMqNPzvMFl0d
	D7QPKOBnXMfcu4Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E0F3013688;
	Mon,  5 Oct 2026 16:25:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TpvxLpDPw2qXMwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 05 Oct 2026 16:25:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1CB3CA13FC; Mon, 05 Oct 2026 18:25:52 +0200 (CEST)
Date: Mon, 5 Oct 2026 18:25:52 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Julian Sun <sunjunchao@bytedance.com>, 
	linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	willy@infradead.org, tj@kernel.org, akpm@linux-foundation.org, 
	Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <bsb5vk2s3vyqglw6bv6pgpoqqvkho2p5kfnskfwfban5azi2vt@sceqd6t36yai>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
 <aroIAqoCNDBPlB2A@infradead.org>
 <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
 <5my3hyw54ej2tw24dqnacsy7xppywdjovvnwvrevmczsllzq7c@berxapmobgfa>
 <asNfNHd-kcsI4B1S@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asNfNHd-kcsI4B1S@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4E2E1C0002
X-Stat-Signature: atcxtmogam939mhce1g6nghsthg744h8
X-HE-Tag: 1791217563-208681
X-HE-Meta: U2FsdGVkX1+APkL0U5jIcz0VAhpALJ47sjmY6n0dn6R5vShf92fjc8P4XkSAscHe41hHaTu+tDf5zv8dn1iHXp3xQxVvi0TCSB93MxqmSr5jUUMNgOIWKxi7N5fIUkAZJA31NbTcLIsws7zkpMRvHwWQz7XTFA3RVedYIep15QFd3VMfem2kW0Gwvrj+yXdaOYaXEgaD+hBG9++NQ5rOEEGmKU3zRVfHN8t/siV9NICx4oWeikeQsqIAGJVRfae0VCHtiTx+K102Qug8Lvi+SOFY12xwgLujpZGJsBOWLIpAMPh5IspG6tVZLfaLNrDf77UkbGAcEMQoNN4MVOm1VsITFiVp8+2nVEK/pYq5g4DN2Bf0GBVVTWcnGf3KvLpSYXMLsF9v/d2R6xkIObqKeqTRvBEbciJexgZ1tP63vKbkHWezSo5l92L9h1VaYoNrJIU8dq14KOl4kvg9s8+zB4Uw1uGFqO07pZEMw5aUT9OCO06vnECxC1x0in/zmvRgxICswZfV2j2XSZeN7I93sx8nNblUiTgp47ekrr2z3t4BWH2Bc154n8WcVNhet+/Xea9vqsH+Zz8NuvBr9BrDt3+OwmW4haOgtVgPsIq2pGvhh3Sw0RupJaLyaxjYRQ2DG7Jx2jcWJj1HHC+BiLYSq0RAw3DTlP/JJ8W1ULlEHw/DHfV6Q9PXMJvVQhE2vt8RlYigDvlcJnV0FC+yYw1aVK9rLfYYYDRA0S9Lv6oGfFW7Je7BjhGj0Qoum0qKJBMnp+wH7G0fP1JVu6xg+Azu04uGzNJVnx2jD46fmYU2KiIn7Mu70d9P3+tlVBv2HgoO4/wSETMoI96xCO1S89Q9dsX6S9+niFVq3hy1FX60rxHNjtrsFhn4NeMHBTKZBlvoChTechkjk0ofI3Ljot63mM6CjwU/2IO60XfdzYX0H9CiygnkgP0/TlR5fe8oqF2aT1agE+/+F6pYaCpSVcH
 DWLIYev/
 FyX0sxRSSePPA00EN9jcDGgcr/KYW68HzenUutaCH8m+PhO595NqQhZG1wtgPhQ2/I0vdMekw2AEr2c01nClLJHIx87YB5bx8fpNnxAxwL9VVZI0Dr7h4CgfUnO1Iq76wUgpctaXA1lFUwW4oOd+/1AdCrrQr4kJdGocrlTxHuaGgypjay0dyES2C0GBWMgODMahbdXzVp/Srdykt/pSKxOYFb0UczWMGX/AzfUo5+9DjqH1uxVnZCSV/WotQoO8gNPu+y0tN6oSlHAcylkXS8WoZ2CNXF8FbpXsuQEinIWxS8wpeaGBq2qWDMWsYZmoSawrqu/w3qFoCM09xGX2WP34KxnDznjfaHBRxEkec4ixYehLZSZGnHSPCf8b4rZPSulycoc7z+XfRlRY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 05-10-26 01:26:28, Christoph Hellwig wrote:
> On Fri, Oct 02, 2026 at 01:10:42PM +0200, Jan Kara wrote:
> > FWIW I share Julian's concern here. It would be fine to use AS_KERNEL_FILE
> > for ext4 metadata but I think just unconditionally setting AS_KERNEL_FILE
> > for bdev mappings will cause issues because some users may be using bdevs
> > directly for their workloads and they could still expect proper memcg
> > accounting to work in that case.
> 
> Agreed that it should not set unconditionally.
> 
> > We could set AS_KERNEL_FILE when opening bdev for a filesystem (and remove
> > it when releasing bdev) but that would have to make sure there are no
> > folios in the bdev mapping when changing the flag as otherwise the
> > accounting would go wrong. Looks it might be doable but getting all the
> > cornercases right will be hairy and overall not very appealing to me...
> 
> I'd rather not support special case writeback code just for this legacy
> fs abuses bdev buffer cache case.  And we basically need to tear
> down pagecache at unmount anyway, as i_blkbits can change, so while
> we do need to be careful, I don't think it really is a major issue.

OK, after some more thought yes, I think we can make that work.

> We might be able to restrict to setting it when
> CONFIG_BLK_DEV_WRITE_MOUNTED is disabled to avoid the problem of non-fs
> shared mmap writers, as anyone using a modern kernel and cgroups really
> should have that disabled.

I don't think that's really needed. If such writes are happening, they are
*very* limited and done by a system administrator only (as they are very
dangerous) so the fact the writes will get charged to the root cgroup is
not an issue.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

