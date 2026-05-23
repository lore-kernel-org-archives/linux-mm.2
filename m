Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA707CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 15:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D650D6B0092; Sat, 23 May 2026 11:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE6C6B0095; Sat, 23 May 2026 11:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDCE26B0096; Sat, 23 May 2026 11:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A54B36B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 11:59:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06FB0120B8B
	for <linux-mm@kvack.org>; Sat, 23 May 2026 15:59:05 +0000 (UTC)
X-FDA: 84799143450.29.782952D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id DD9754000E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 15:59:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VqSMot8F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="8/5BOhYp";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VqSMot8F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="8/5BOhYp";
	spf=pass (imf01.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779551943;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PigY/OTtyoBC4PQKUyB3Djq6TUmlWcS3lHedpovsxTw=;
	b=iGpHOnRKeOUGyjq9Spbpz1VHnyEkKkQRp1yzSmqafJ6jWWCP2NNEb4FN4gMLUsAa/8cMvy
	UQONPagaTcdG4J+ScLDax7FV7mvwT1Vzwv/WpEU0AI8CM5zZHrswtMJD1TGk9pFL4Re0oH
	4H3LbtuUG7yDwDf47OPkwYn3SQr8zZg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VqSMot8F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="8/5BOhYp";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VqSMot8F;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="8/5BOhYp";
	spf=pass (imf01.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779551943; a=rsa-sha256;
	cv=none;
	b=PbrG68IWVjFwILLBFIzPFjTSeOqNjWT90ZNMgTvemdiMd5chypBpwbrtBOIt4b/kvCH9CG
	LSpRsVS+ejVQ8+DHpAM0FmdfLnUPPGGNlAT8CAerl0DdyJU79/pqiDaXjSy3vrljBfQxfY
	Pyj+AHug6wEBWgfhJn4AZfiSjE0AR2Y=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 270C263D11;
	Sat, 23 May 2026 15:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779551941;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PigY/OTtyoBC4PQKUyB3Djq6TUmlWcS3lHedpovsxTw=;
	b=VqSMot8FWslhseKH1A+sIF3BbIxYNYt94oQ7WVTyRiUtQ15WedK6fV7bu/pEw1zaK2CKH1
	rfwx+NuvlHwIYdXIhq3d+eWjSqWBanX0vnC7Yr6PDJ8Z+5S94b4Dck3Je61cK/xqWkpPoW
	V//SGAH2mXtwsHK7lpXCDmpShHRDEcU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779551941;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PigY/OTtyoBC4PQKUyB3Djq6TUmlWcS3lHedpovsxTw=;
	b=8/5BOhYpfPHPajToZ0KL2xeaFcYVOXWI9Ma2QR57SfqR71qS926ZF8GIevcAFyTRczH08+
	sZ0ceYtd0ChorCAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779551941;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PigY/OTtyoBC4PQKUyB3Djq6TUmlWcS3lHedpovsxTw=;
	b=VqSMot8FWslhseKH1A+sIF3BbIxYNYt94oQ7WVTyRiUtQ15WedK6fV7bu/pEw1zaK2CKH1
	rfwx+NuvlHwIYdXIhq3d+eWjSqWBanX0vnC7Yr6PDJ8Z+5S94b4Dck3Je61cK/xqWkpPoW
	V//SGAH2mXtwsHK7lpXCDmpShHRDEcU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779551941;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PigY/OTtyoBC4PQKUyB3Djq6TUmlWcS3lHedpovsxTw=;
	b=8/5BOhYpfPHPajToZ0KL2xeaFcYVOXWI9Ma2QR57SfqR71qS926ZF8GIevcAFyTRczH08+
	sZ0ceYtd0ChorCAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F3642593A8;
	Sat, 23 May 2026 15:59:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DyMxOsTOEWowBgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Sat, 23 May 2026 15:59:00 +0000
Date: Sat, 23 May 2026 17:58:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Boris Burkov <boris@bur.io>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, linux-mm@kvack.org, david@kernel.org,
	willy@infradead.org, surenb@google.com, hannes@cmpxchg.org,
	ljs@kernel.org, ziy@nvidia.com, usama.arif@linux.dev,
	fvdl@google.com, Chris Mason <clm@meta.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 34/40] btrfs: allocate eb-attached btree pages as
 movable
Message-ID: <20260523155859.GF183694@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260520150018.2491267-1-riel@surriel.com>
 <20260520150018.2491267-35-riel@surriel.com>
 <20260520174749.GA1458531@zen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520174749.GA1458531@zen.localdomain>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DD9754000E
X-Stat-Signature: tmj7d6kf6oyd5sgxpotekbqp5qugam98
X-HE-Tag: 1779551942-49185
X-HE-Meta: U2FsdGVkX1+kwhJ1bsIvWnMEeHchPPHt3mUbpmEDCekGybj/VDYqnZ2U2ICkKyvR5dazBCidoXcxYk1Ut4KckSU+ft6R8RWawLPxMv9TdjUAchv3DQcQV1COG/hTugtoW9R6Ke+DIHyTFHDT6DktKgV3Yjz0KiVi6Y0F2DKH0LDN0+0er82BCzMwTHo6+F2VkTQDRB08b1CJUAuMyzxE22W84lYMXMlMvvkUApAmFlxhMRH0Kxd2JR3A4owrzOpcx/Pt1iwDCySlK7r8TOAJ9eoqUYLHraHtZNDDUtAN+6WQrxNSZByY2K55yDwRw/Oj6Isg1MvLp/jXYueWoO2FgxO+4uupkqZT+v2ZVWla7vXAvvJhZODWI0orYPK8b8PacEua7k7pu7reYKO9qW2OfYxlDGghuPWk5EyTHRRQRvKL/9ORAi6P9qHScEg97ZHvQ0rMy1oop/TMF/Rn2SWKCIsfQXOpyp9TGVZfs5eWFR/R0TEdio1OwBb5BdDOTjmSJOEOkQQtinSFl7oEJ5ezKZawOBjJqUHtPUwBimubclAPJplyhuKESUBTSE2veriaO9bqTacrgkAdzvs3PvA2EacDsIYCEaBXx58/+yHlDFG4BwYU63bf3B9krND3t+3xu0UOzTfrs8seBNPr/68FK+KcQ+sHDcLWtbyEaa0/ZkSacDwX+xa6JSKWkDRlnSvJ2J/i2iwmX+i/hHJO4AvaKzqEMCFfTTPNAzOQXjsBSEHkEvm9sLWnSGE3AlEIdyl34srLrSBR4OMsJMS0aNvAmD5l99r63cW94o3VPTnHTUw/aqdZWsQUxNSA1XvCuQ0GgT4VG99P4YvrbJ53YKip2YninfPZ6lQgfYnmW+Q/PAFYkNsJ2rTFFr7d7JWGrsU/TzjACVTfcTM735zbHJVU44Q3tOHK/Az19n6UeQYeIeishGiaAejfT74Q13eWpe0meXOpYG++akx0nfCj3Pu
 QTQ6dBAu
 ogwg80+lmy7F3N4ovMFP87vsp2E4SY+XvKutl79K0oXmx0UeRMZ0hcl0xulkDJW8g1ktYYY7+xsFnk+6dmnN08abg2Mr6qk4FWaDDBL/cvm2QbQ+3cqnfnWVcaSQH9uHUEwOTOtWJ5LhHkf+CJ4Z4dU3h3JuRL7e9pBk/saR9fjH/pSetwqAKR9iGMSGrW3ar8kV7WPQ8+Cj6ryQ/GmUZ+NWqZSs1pUr/rV5cdHiLd/4ByTbm6Vi36le4jfGhlAUB5lIYLQ8ChIk0o0YuxdbnvFecsEfdBD78KuCk7Wy90nB4IUec6yPho4hGwZgJ9tcvXHG3oPfHFRA+soIpVi742ueKptT7zHuva2XU4EZE2SUwEwsuvBb98UTX5DE2HPKzgzMV9ghEHaKERLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 10:47:49AM -0700, Boris Burkov wrote:
> > @@ -689,14 +704,23 @@ int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
> >   * Populate needed folios for the extent buffer.
> >   *
> >   * For now, the folios populated are always in order 0 (aka, single page).
> > + *
> > + * @movable: pass true only when the resulting pages will be attached to
> > + *           btree_inode->i_mapping (the alloc_extent_buffer real path).
> > + *           Cloned/dummy extent buffers (EXTENT_BUFFER_UNMAPPED) leave
> > + *           folio->mapping NULL, never enter the LRU, and never get the
> > + *           btree_migrate_folio aops, so __GFP_MOVABLE would violate the
> > + *           page-allocator's migrability contract for them.
> >   */
> 
> My gut says it is nicer to just transparently pass along a gfp flag
> rather than a carefully documented movable boolean and let the callers
> do the right thing. Just a nit, I don't care strongly about it.

Agreed, the GFP flags would be better and also a bit more self
documenting where the functions are called. The patch is not standalone
so I don't mind having the booleans, we can clean it up later to let the
40-patch series proceed.

