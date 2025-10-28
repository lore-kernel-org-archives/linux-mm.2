Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94642CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 11:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB0D58013B; Tue, 28 Oct 2025 07:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D885F80131; Tue, 28 Oct 2025 07:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5338013B; Tue, 28 Oct 2025 07:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA07380131
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 07:49:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E13914041D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 11:49:02 +0000 (UTC)
X-FDA: 84047351724.14.379835D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id F062EC0008
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 11:48:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oHisylFD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sd5JUpjC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oHisylFD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sd5JUpjC;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761652140; a=rsa-sha256;
	cv=none;
	b=RX0e76HwTFvntRwWRtZGDbfQwMxA5HtqzlRk5LtN0v5P/Ti7/AzB3VAoe+H6QzaA3cd34a
	ewApV6Eg806kDAxxDWSoa718xIVPOqW1WEV1WVC9kUqZPk3e3U30axDS+gZqPZ6ij1WSnL
	ZMgnYdUWwf/C+2F9ogXUWb3q3Mya1tg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oHisylFD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sd5JUpjC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oHisylFD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sd5JUpjC;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761652140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EEDsYxFkkJHUjGWGL4EddzX8EcwO4m2OW9aFt7wKD4w=;
	b=ttzhCw60j0HyY1YG9AWzG/ObjnvBPnr03qMlUBZDZkhyFgdDsaQeigan3bCurvm7RnjNOI
	QUI7q+gMxTXlZYdkrUL61E0DtVw9mi2zpswpKzLbyhS9t+HASa/fyFFOGQhCXve1DOs/Yd
	mGMDCyAViskf+M/aduqpQKNHMzm5YvQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 291FC21A49;
	Tue, 28 Oct 2025 11:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761652138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EEDsYxFkkJHUjGWGL4EddzX8EcwO4m2OW9aFt7wKD4w=;
	b=oHisylFDAuZV7QpEp9sT3pOu7poBnog3qCyORDuUTdG+ynWHjNS7PQ0KlqQlu4iHxsRiX4
	D4lqUwf0IeeFjI54ZAQV9KAsXpD3fiDajoSApMpqDKQe9F8+6/reXn4Or9d4qkMyjBv3kC
	sFOFa+WANwi38fkkkCP3r1igwdg+qUI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761652138;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EEDsYxFkkJHUjGWGL4EddzX8EcwO4m2OW9aFt7wKD4w=;
	b=sd5JUpjCNPXFTvsLJDmZNd9p5AGpi7UtozPA5+iU1ir/e/GNibMP4ynI7wbKF7Wl39SJP2
	VA+fmGcg/MJ8dvBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761652138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EEDsYxFkkJHUjGWGL4EddzX8EcwO4m2OW9aFt7wKD4w=;
	b=oHisylFDAuZV7QpEp9sT3pOu7poBnog3qCyORDuUTdG+ynWHjNS7PQ0KlqQlu4iHxsRiX4
	D4lqUwf0IeeFjI54ZAQV9KAsXpD3fiDajoSApMpqDKQe9F8+6/reXn4Or9d4qkMyjBv3kC
	sFOFa+WANwi38fkkkCP3r1igwdg+qUI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761652138;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EEDsYxFkkJHUjGWGL4EddzX8EcwO4m2OW9aFt7wKD4w=;
	b=sd5JUpjCNPXFTvsLJDmZNd9p5AGpi7UtozPA5+iU1ir/e/GNibMP4ynI7wbKF7Wl39SJP2
	VA+fmGcg/MJ8dvBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6B57313A7D;
	Tue, 28 Oct 2025 11:48:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wJN7FqmtAGlAegAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 28 Oct 2025 11:48:57 +0000
Date: Tue, 28 Oct 2025 11:48:51 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Dev Jain <dev.jain@arm.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Barry Song <baohua@kernel.org>, 
	"open list:MEMORY MAPPING" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/mremap: Honour writable bit in mremap pte batching
Message-ID: <jmxnalmkkc5ztfhokqtzqihsdji2gprnv5z4tzruxi6iqgfkni@aerronulpyem>
References: <20251028063952.90313-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028063952.90313-1-dev.jain@arm.com>
X-Rspam-User: 
X-Stat-Signature: wbfaxm8ojafxua8b6xn9w6b5maifcj9d
X-Rspamd-Queue-Id: F062EC0008
X-Rspamd-Server: rspam09
X-HE-Tag: 1761652139-789436
X-HE-Meta: U2FsdGVkX19AsCi6elY5xJJw4BkdvfYHKvQmUTUbKc8BKrZwHzu/68ZkdUWlgHxRuYiT3BTWWt3K2LCJideUiEA9uz+lj1Lzrkum59nb9ZYtLnVuQJtz3l6zsuZsJ4PYmM1xd5fy36Puc0Ob6roSWvDKuNZZfSGL0HE0PDAys3h2lcYpcI4qHrDWeAVmnKdtUp61mwOmjByDbno7sWlLmXcltd21jC8qtEogRU0/0mRT2zJ5na8X4awK8/mLiYXrFVcEfRqPNcHKO4uMaqxIZs6EAoWNs/g2PQKp/2HIwZ35CRIYaR2pFmBuBnP6KTevxuSbh5NI5sJtfafsBZ6Aqg5q8TRr5ChS8cvjFXqE2wRGxK5odFpTnLqJGbOCTmGRvRCOSgbAkDEAleK09qyZtz1E42BILGMp5B9pOXJRmN4GwnIofXAh7aueVDsTdEzi8a9A6dPBvj27RA0lsiPOZL/ugIeMXIbfF+PIIbP+UGwi9pQZj8QGjpmBd5s12rwicxNDpOWXT04Bpy0yPjuS9wjnP7c3uamSpbn/VO+xxMl4AFgjjMDhLsw3KXKZbGXxkxxLgXHXXIrBO+7mh2MiItA98oVlSA9Wu1yWAbkgjSJL2yck5cG3k0irC6W0ldn5C/Vt6v5afthaqs2Q6ZH/5vRYM5r9rWS5nq6A4ck63EQjnuD2+xflvGfOisL5l1TadMBnyblFhESJxSsdFqpL7bIkzH2dvToHuggVIGvWGgPkIoJaqQoq3YW1RG/uDvPwcvqug+lS/MyMlBirccIP/G69IHqh/osjZRM3PsYBqxHFgLbXcoTGDk5SrhA4qIC/Wd6RqEqnubIyCFWbXfLfOaTeuC0qB7ZnFtFTXjv5033rlE+rh6YmZ/+3cjnKl8b2dK1qojBbNca56OJd10MzDlrkppYCowZo7kCdeWeOzJDsmc3xeuYKJZxuVJ20524UgD/+jP8h5zAbOuYDt8p
 YZ+tM5Dy
 3iZ+dblocAygcQy/IHT1rSUHdcaGuFbruTdkIPupswLEkGI0rZEB2MGtLtFN1gOCymfDTSDDLXrVwV8cGnTbhPskRKtFAFVIyz1YWHK2aWGF5X0fqFr9Ls1Wh5Oau0ssQGG8QaFaac1gIzraMbGC5rHyVP94dP9M6m9EMewCj14ILk/pU0bj/xuh9cy+RAOD5PqBP71PWUJ5Gmdz/5Wc/qsvqb9H+B6/DYco9dodXuSXQKuvC4H+5k6nn6ckP6fCk+ox6yDlx7dYNcljKs5eeAeaHUSdZdXtAsEC83JMSCpaseE5htC3+i+no2AE5D2s8UoJJexReB0vzIDrHOK01LIe60uKHVQ2zL/hwn49SCcGqVrrmpJeRb8Sbl1jFouZWBb6fIs9boMjDRbSKtweie8zfkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 12:09:52PM +0530, Dev Jain wrote:
> Currently mremap folio pte batch ignores the writable bit during figuring
> out a set of similar ptes mapping the same folio. Suppose that the first
> pte of the batch is writable while the others are not - set_ptes will
> end up setting the writable bit on the other ptes, which is a violation
> of mremap semantics. Therefore, use FPB_RESPECT_WRITE to check the writable
> bit while determining the pte batch.
>

Hmm, it seems to be like we're doing the wrong thing by default here?
I must admit I haven't followed the contpte work as much as I would've
liked, but it doesn't make much sense to me why FPB_RESPECT_WRITE would
be an option you have to explicitly pass, and where folio_pte_batch (the
"simple" interface) doesn't Just Do The Right Thing for naive callers.

Auditing all callers:
 - khugepaged clears a variable number of ptes
 - memory.c clears a variable number of ptes
 - mempolicy.c grabs folios for migrations
 - mlock.c steps over nr_ptes - 1 ptes, speeding up traversal
 - mremap is borked since we're remapping nr_ptes ptes
 - rmap.c TTU unmaps nr_ptes ptes for a given folio

 so while the vast majority of callers don't seem to care, it would make
 sense that folio_pte_batch() works conservatively by default, and
 folio_pte_batch_flags() would allow for further batching (or maybe
 we would add a separate folio_pte_batch_clear() or
 folio_pte_batch_greedy() or whatnot).

> Cc: stable@vger.kernel.org #6.17
> Fixes: f822a9a81a31 ("mm: optimize mremap() by PTE batching")
> Reported-by: David Hildenbrand <david@redhat.com>
> Debugged-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

But the solution itself looks okay to me. so, fwiw:

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

