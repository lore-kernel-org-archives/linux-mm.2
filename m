Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07BCBC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7487D6B00B0; Wed, 15 Jul 2026 09:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71FFC6B00B3; Wed, 15 Jul 2026 09:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636056B00B8; Wed, 15 Jul 2026 09:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9976B00B3
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:29:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F235014011E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:03:17 +0000 (UTC)
X-FDA: 84990724434.21.907BE09
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id C97C81A0003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:03:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zp9S4ker;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DU86yZ9i;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zp9S4ker;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DU86yZ9i;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784113396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/w0/JofSGuJID6gCR3ETcE1l/O+Ym8fL3mervCh8EY=;
	b=PUVXnbVd3Zx8F0+5l+fqi4KcFXzrCBYG45hczGP/mqijJTu74zoZf3JlAxtETuCc09t19y
	hjPZZZ1KZ4cqZZe8uhDZGO0sXGXHiFV9PIBgcmOTsNeGC8vNkKRpjskD3PoJUW6kmSL75O
	d+ViyUb/GlVFQtHIOd6J4GSL2L318f4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784113396;
	b=S5Zis3R0houwkb9T8cQdeEefiqPcZqi2tMxQ7D7eqzhP80sl8n3oNPdJgzKCdpx2HLRM0q
	RNzXj3GPog9X8lRGOdvtFGVBVCiANahdn8+zm8CeD+6gmVBqNQe7nfcxdTUYZEb1+z25iT
	MpwVWloibE2jdo/0KAv4y6TEKH7kjZs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zp9S4ker;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DU86yZ9i;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zp9S4ker;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DU86yZ9i;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6DC773E2C;
	Wed, 15 Jul 2026 11:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784113394; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y/w0/JofSGuJID6gCR3ETcE1l/O+Ym8fL3mervCh8EY=;
	b=zp9S4keryKvPSeo6DUINoZiYwFq/YXNK91O7BUc94CKyUaHs54bPkEIeNGlEdMWt51WpGt
	upkGJ3Vii8D8g1m2E5jrijlbLqewYO2M29/vnyDySzbN30ieZv8VWTrrwWtgomvrV2Ru+b
	Zp+iuUH9YSnECBdlyCt21KkXPkV1K+I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784113394;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y/w0/JofSGuJID6gCR3ETcE1l/O+Ym8fL3mervCh8EY=;
	b=DU86yZ9iikGFjQnG2BvTDTZqu9ae/Nrwml7rvrJ5f1gjjqLgaMZOljkqFv8Yg6EtZZ3S0I
	04jRuyg7ww8dBECQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784113394; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y/w0/JofSGuJID6gCR3ETcE1l/O+Ym8fL3mervCh8EY=;
	b=zp9S4keryKvPSeo6DUINoZiYwFq/YXNK91O7BUc94CKyUaHs54bPkEIeNGlEdMWt51WpGt
	upkGJ3Vii8D8g1m2E5jrijlbLqewYO2M29/vnyDySzbN30ieZv8VWTrrwWtgomvrV2Ru+b
	Zp+iuUH9YSnECBdlyCt21KkXPkV1K+I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784113394;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y/w0/JofSGuJID6gCR3ETcE1l/O+Ym8fL3mervCh8EY=;
	b=DU86yZ9iikGFjQnG2BvTDTZqu9ae/Nrwml7rvrJ5f1gjjqLgaMZOljkqFv8Yg6EtZZ3S0I
	04jRuyg7ww8dBECQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D47F779AD;
	Wed, 15 Jul 2026 11:03:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Qy1EO/BoV2oOfQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 15 Jul 2026 11:03:12 +0000
Date: Wed, 15 Jul 2026 12:03:11 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Gregg Leventhal <gleventhal@janestreet.com>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Song Liu <song@kernel.org>, 
	Eric Hagberg <ehagberg@janestreet.com>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH stable] mm/khugepaged: write all dirty file folios when
 collapsing
Message-ID: <aldo3HN27b5PoQyz@pedro-suse.lan>
References: <20260702165409.164568-1-pfalcato@suse.de>
 <akhYu66GmjyM8l6a@casper.infradead.org>
 <CAFN_u7HkJry=iFLbZ2vjzv5C=HnrptHfFJBLOqRq2m4LyhqV_w@mail.gmail.com>
 <ak5g9h3FuVn3bZ1G@pedro-suse>
 <CAFN_u7ExSnVo=QQBuZvRJkLR3rHo8qN96rDKYu+KNiSjk0FCHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFN_u7ExSnVo=QQBuZvRJkLR3rHo8qN96rDKYu+KNiSjk0FCHQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C97C81A0003
X-Stat-Signature: 956txgatk198s6ud1aufsrn33oeqtck3
X-HE-Tag: 1784113395-53965
X-HE-Meta: U2FsdGVkX1+y4hTG7A4CAWWUyn4WFLEY6x4KvCw+tPuFxcgw0ulu7zpES79/mF4CbJ/iHeqaidOWcnMzYOCgXH/1ypkxZNgXMyZnnmT8mmZOxhzHcMZDOWVcmyZptegaoTlj4P0zol+xrg++8m2Hf9kTU70BpfZGawNbdZx/AjqtYKuZBFgWOaj4O8QI10S+/EZQ/N0MAVgRXMjz+enH+FXY/o/+mEvP2V565euN4nZqTZxJyvFzPoiLeJByfBBaXdNKWzIqaUiBX+nGPNJ4HGK21NK4JoiHDtAbgXbziTsFOJmWmmS5Jf/yBFlRhOcX1hJtCY9150xbo1VHkY5pUeEIC18ymMlLBTaiCMSy0FlmfhXAbtVvfkn6OhZUPanotsnsdg0YEBGDCQ6jonqdTJErCd47NLVPGiE0CN9/OsxwbP80bOcd0bkuyF5eSi/Z5gUuMVFacKWkzMG9BSa2L6Idq3/YNJKME1x16Dofu17R4xbySztBLioX5ePjaT6m/PpL4UkkuKEkQuKw4+4h4YXzuidxfkt89u2jV1luDPhhePXfSehrwL1fyw4Oq2+M/bjmRPs3txew4jzc/OjYwF3RzEZI49D8e7PPXxjq0jrC7K1/zTj46gLUth5jOJddkox/mxiozLV7Tp9weaSw1rPIVHuF+UdnbEOQxvqgJUhBWYauhZI2Iv1m0SvAd9pPRRN0Pyd91/dN/KmKRGTDWYHx77JxSd2jmOIWqF+KNqoQX7/6w6HTpglDPIM0p5f71QKkW5nzBQ7FHRgM5uk5HeZmRU4aNoKXJHAjhkHeV7aCUwfkUXW69fXjxl8t2w6i1UPAGSxTOdNxgs/DYjkQyqEHGdKqNJto5ZsXcAFc3CKwHnGlv0WhtTweHmV5hcqcpUvXV2X4OHgFHT5gx1DPuiNS4SE+A3g6GnKpMIpXNIP8mnJzTIFcovEWBwleHQI8Uq5e2xW6AWSqi6z54kX
 RKSIJAdf
 3VCgnuSHZ7dy50s7YCjx1RL1VgZxqrgKkG31lcMJsw44OwPdPawivj/MVsTqgplj1KVplmqY7b8bef2KCtViEHbqlZNLi3W8dGE7d2I53nKM14dEKKEcapaA7hIWdHtfaB3ZgZWgA9qpcPY0uYcYAVeK8l1GXprZSx5o+BMmJHsrwmc6pC/8n9hYbs+15Q/Ffl5WtfMRuf4rIPF05ztC+jGtC6ZR6/o4Ih5hUo+cH7NB53AKfbYhX0LPwRMmOKabSamgtdZOCagj9tCenY0ZmkXlz/zXorSWp+zyOrUpAALXFafbk2194RjJ8o/1B2SRUequu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 08:52:47AM -0400, Gregg Leventhal wrote:
> Ack thanks for the update and all of your help with this!

You're welcome!

> Obrigado pra vc (Meu esposa e Brasileira e achei que vc estava
> Portugues da sua nome/sobrenome)!

Hah :D

> 
> On Wed, Jul 8, 2026 at 10:40 AM Pedro Falcato <pfalcato@suse.de> wrote:
> >
> > On Wed, Jul 08, 2026 at 10:05:43AM -0400, Gregg Leventhal wrote:
> > > Hi there, just checking on the next steps here.
> > >
> > > @Pedro Falcato Are you currently working on this patch (mentioned
> > > above, re: holding invalidate lock), or are we perhaps stalled on
> > > something?
> >
> > I was waiting for some actual tags from people, but given the comments and
> > no tags, I'll respin a v2 before sending to Greg KH.
> >
> > --
> > Pedro

-- 
Pedro

