Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CBA0C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 12:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D158F6B00A8; Wed,  1 Jul 2026 08:05:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CECCF6B00A9; Wed,  1 Jul 2026 08:05:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDC4D6B00AB; Wed,  1 Jul 2026 08:05:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 908C86B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:05:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A0A61C6FFF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:05:21 +0000 (UTC)
X-FDA: 84940077642.24.531145A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id D081C140013
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:05:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iQKRemWA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HMFxpWNz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mHOcNFi5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Inykshk1;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782907519;
	b=Rs3Qj2KE+CPTk3ktdkZeYc/+O3NDhFL9Zl0cbAcQYG3lLEIe614MxLW2ez2wu5dQS7J//k
	X4MqAD2nf0ZyyQlTKLID8m5QKbWRkK4WxAk4lpSq2CNd/HqgkNZHhYsB8LxY2J98MOxs6f
	2FvPW3GEumRvDoG2zxUUvuIeIkobvqI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782907519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mWAjt+Z5M5aCYbFA65hD8FRE5iZm55B9+U5Z+re2dO4=;
	b=BDDPg0AB9QeU+BxGHbgrthoE3HkprfoJjmnEovmY88nEpHAF27dAk1HIUDqHdX9bW/k7Q7
	S/X8fmyYAUuJKIdKO/pj11HvT8hChokkIpOezRhCbLWwSgWJ4uo9hx7ksgFnjhgwdPkzEX
	h4knU69AgDPm6EnSmqJZnfng3CYOqGY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iQKRemWA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HMFxpWNz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mHOcNFi5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Inykshk1;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C2A4673A87;
	Wed,  1 Jul 2026 12:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782907516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mWAjt+Z5M5aCYbFA65hD8FRE5iZm55B9+U5Z+re2dO4=;
	b=iQKRemWAEfDbRzZ6IFy4PuEOM8F4Nehx6zhjBR+dDQQjSLGxIVbJVmzjw0io7AOLhAd6hb
	fcHGOVIGnjAPpTE6Q6QxYtl+XdcgT6FXMWc6eFd1bgkEuCqXGpxnid7v7l0JRQKyU+C7BE
	cGkTIMzHjIwa+NzSClO9/YueVI7LNM0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782907516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mWAjt+Z5M5aCYbFA65hD8FRE5iZm55B9+U5Z+re2dO4=;
	b=HMFxpWNz4c7KsgoT4zlQVBmBSkK+t3w+LKn254Ggpsx++aipkABmI3UMcjAOOIq7RDAfkD
	+L8gpkR6XKmcj4Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782907515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mWAjt+Z5M5aCYbFA65hD8FRE5iZm55B9+U5Z+re2dO4=;
	b=mHOcNFi5SNfdu5VZO/H2YRlkXvfKiieKe0mlcSkoC0ifMqZPKK1p1ew/2qeErR6svGk2fH
	arF5CLI+997wXccLPMKfRmPdRw3A4ulKdzOgYal7FFNpMDs941kI5ZGoGpT5WPjP9GELom
	TTeiVA0JX23RKkN6RDDpmd2+5/6ZW4k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782907515;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mWAjt+Z5M5aCYbFA65hD8FRE5iZm55B9+U5Z+re2dO4=;
	b=Inykshk1SZu0toM7yV2EH1MDG4BnoNjfZskmMT6F1GdN2Uv7cEWsRknlhHbBiKp9gx5Naz
	9ZK7rJk4TqNu4XBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C775E779AA;
	Wed,  1 Jul 2026 12:05:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7SVzLXoCRWoPMwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 01 Jul 2026 12:05:14 +0000
Date: Wed, 1 Jul 2026 13:05:13 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Zi Yan <ziy@nvidia.com>
Cc: Gregg Leventhal <gleventhal@janestreet.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Song Liu <song@kernel.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Eric Hagberg <ehagberg@janestreet.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: Subject: [BUG/RFC] write-open file THP cache purge can discard
 dirty page cache
Message-ID: <akUCbsNo2krhSV03@pedro-suse>
References: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
 <akQIIav_zaK6RmIC@pedro-suse.lan>
 <akQO8JtTxmp89GS8@pedro-suse.lan>
 <akQekZUyoKadiGCH@pedro-suse.lan>
 <DJMR0W6NUSAI.3UF6I74VFDFSH@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJMR0W6NUSAI.3UF6I74VFDFSH@nvidia.com>
X-Rspamd-Action: no action
X-Stat-Signature: ezqz7xhnj3xjqkif7zixyng8xun1axf3
X-Rspamd-Queue-Id: D081C140013
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782907518-353750
X-HE-Meta: U2FsdGVkX1/W/47ZodisWTgtj4jcBD2O6qu1A9ftUE1ffO6WJD/DNkDh4QJ+RGdV8ylYPi3kVT5iI0lyEgINRMfuSRoMKNjDEebKmrCB3G0BeKyLF76zz1bvG6+VoHXpiKxCQi8CdqadIdpvHw8Y7W+8gemvgj9DjLc3PCqzcIzUnfjj82SOt8NKw2IST22CwPr8ZmzN9GFzgEYLsNgUrTiDtOijUeKDMYuNYlEIhBxTWAqAYhUqO36mQCl15yz4vI2gZds9ZqTJIL+vRvNKB/PfNQMtlRXUvBQEKJSkHyNDBRQWmRkvz2rzNBO0dTJJZc70+DerbAZHue0ATCWTD26vMtbsGb6vA9NgUDtjuRJP+ROjbhs9F9NTWb48jfkHSaPlGs2qv0o5vPM3SQCXWujavdNdc8QTEhG3lFnRmHkuYF3HygrHEEDlgRgmkH8R33ZLTLPAUhsz3O2yGUf4Ce3xnudLgqrcHqFeG90c78av7c2sLGZflOiAKNc6uyyU6RUoHIjOsntDt/M/dnNugPIp4gkn+NYTL70QSHOuNZt8cBGd5Scdx0BG294pOWfP504a0AVI+L1yCFN180OXzgKNFdnck0UemvR3gra2zIVPYcvSRSWY0BEhWGzZDvZP5jcQL7umkW7tk6lBDcuHFceSYg4DvuEy0jsxGHyIpabmrQPnANCIFtPyZwO671zEHH9pb1vwYOj8Tj5ItpIeFiu74dJYVXMBS2A5LFR3051d0xRsusTaoJ1inoVI3G3nWgsWppkGlImhB7KKSOPbnkGkeCPWbPMedKBZhB/HSXycyHoGC7YZtMtzKl+TeNcPRL6d/0+gEeJSL/d9fuIh/GBhip/EeE5pIoFI9W21d+dCurByq+isV57TXwb9UR8MSRDOmK1rlqg6AmEu4J286VTpMgfLdjJW1SWbnBWDzDCWxvdvFq+qHku4G3d93EAmKhi6KXSEgOhewEi8+W2
 G7/ngyj8
 RZzx5GuiMUUUZBMlXE+5Kc2mfsVzlKCoKONiXy9K8vWHuGT3otbg6Wpd3RoCKU1Wo9vw7vxsVtNB+KhbycDjTdKlKMVUC24FSe/cNsFVaDBRzaWGtNdrvYUAkWxKG1564GdsS55klBi6C1rFGmd8Ot8dl0We6+WwO7PFUFMIbk4CXOO1nsN4XbwxECb/jyEkmOMv60gIaHt63wsPy44IefOkh8CuvXAY+ALQP+AIaerz6gWhriBTj4kIZXpv3DNA1zWPVQWTkzx9jMRNRBRyf/ngUWEu95qMay/0NWOCrzKBBXHvG7XqntEai9XR8cBKh3WeFDP7+x3ijvcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 06:48:39PM -0400, Zi Yan wrote:
> On Tue Jun 30, 2026 at 3:55 PM EDT, Pedro Falcato wrote:
> > On Tue, Jun 30, 2026 at 07:49:12PM +0100, Pedro Falcato wrote:
> > snip
> >> 
> >> Other idea: perhaps doing filemap_write_and_wait() after the nr_thps
> >> increment in collapse_file() will Just Work and result in a _much_
> >> simpler fix. And it avoids any weird forward-progress issues as no one can
> >> write to folios at that point.
> >> 
> >
> > Gregg, if you could test this patch, it would be much appreciated. This patch
> > (hopefully) makes it so no dirty folio will ever coexist with a ro-THP, thus
> > hopefully sidestepping the entire issue in a simple way. Only compile-tested
> > and not reviewed.
> 
> I tested the patch on v6.12 kernel with the reproducer from Gregg and
> confirmed that the issue is fixed.
> 
> Feel free to add
> Tested-by: Zi Yan <ziy@nvidia.com>

Awesome, thanks!

-- 
Pedro

