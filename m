Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 547C6CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 06:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FF2B6B0005; Fri, 29 May 2026 02:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B0146B0088; Fri, 29 May 2026 02:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59EE86B008A; Fri, 29 May 2026 02:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45F266B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 02:16:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8A3B9B67A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:16:23 +0000 (UTC)
X-FDA: 84819447846.14.EAF3E9E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id C007B180006
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:16:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Qfb4o4xO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=55Xr3bsa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Qfb4o4xO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=55Xr3bsa;
	spf=pass (imf24.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780035381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2AoKt5jawG2SYWcB6lrzc86SNhTgrdb3Hl77qm/udGg=;
	b=TKJp8ZeWDaqdaaj7xF8sk3wUzZroW+BBgz5FLvyUSHLAqI11TcsfcPXZEQo3gQ8miGjjXj
	ooNwH4+tbnn9vdR29C7VfdboqAALdIWxW5cPGFqzGPvaxSM/2sr6QZ4O3Om2Or7WwYpzp3
	7SZxhNMjtQw7tW86Jlk2Z5k8zwydJTo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780035381; a=rsa-sha256;
	cv=none;
	b=Ts5XXITSaN1ckUfm1/i+oGgW+50nIDIzzO8Tzhhd9rJvEbzbmWG/FhxIVoSOZW7TheZG0q
	z1b8Z+6PCxKO7wry1TWIQKLIqN9Nfc4s4PhUvvi0hyAllcOLHic4o8/YC7G5VOjEUzFNJ8
	fRSf2QfBqfSgtFPLs1RzSHfymd6UNs4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Qfb4o4xO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=55Xr3bsa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Qfb4o4xO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=55Xr3bsa;
	spf=pass (imf24.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 37B4267235;
	Fri, 29 May 2026 06:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780035380; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2AoKt5jawG2SYWcB6lrzc86SNhTgrdb3Hl77qm/udGg=;
	b=Qfb4o4xO+07ViaKys2o47r7MyhBBn7VCldgc9aQMA42RDxzWNTpNhgKGMNEgnYu8lXaIdo
	YGegcOh6sqXcjlRR/2FPXVCtdmJyS50aFeGNBATUIr78i4YycGZMuUnTX8Cf4IkTAA7/e7
	fcgvXf4f6pnlidprw+PAtvlYWhOAO2g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780035380;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2AoKt5jawG2SYWcB6lrzc86SNhTgrdb3Hl77qm/udGg=;
	b=55Xr3bsauaj3J+QpR1BRYMOqu6SWpjBvG17MEHVnmQEd6/NwhnVm19X4Em4G9FdR9o2rGj
	PNd6mlV+kKrMNqBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780035380; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2AoKt5jawG2SYWcB6lrzc86SNhTgrdb3Hl77qm/udGg=;
	b=Qfb4o4xO+07ViaKys2o47r7MyhBBn7VCldgc9aQMA42RDxzWNTpNhgKGMNEgnYu8lXaIdo
	YGegcOh6sqXcjlRR/2FPXVCtdmJyS50aFeGNBATUIr78i4YycGZMuUnTX8Cf4IkTAA7/e7
	fcgvXf4f6pnlidprw+PAtvlYWhOAO2g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780035380;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2AoKt5jawG2SYWcB6lrzc86SNhTgrdb3Hl77qm/udGg=;
	b=55Xr3bsauaj3J+QpR1BRYMOqu6SWpjBvG17MEHVnmQEd6/NwhnVm19X4Em4G9FdR9o2rGj
	PNd6mlV+kKrMNqBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F097D5B1C4;
	Fri, 29 May 2026 06:16:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gzPiODMvGWpfEwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 29 May 2026 06:16:19 +0000
Message-ID: <36673080-f216-4c85-a9f6-ad9395dbd56e@suse.de>
Date: Fri, 29 May 2026 08:16:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] block: Add bvec_folio()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-mm@kvack.org,
 Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@infradead.org>
References: <20260528175905.1102280-1-willy@infradead.org>
 <20260528175905.1102280-2-willy@infradead.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260528175905.1102280-2-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C007B180006
X-Stat-Signature: ytgjrep78miumd5r36mk36i34ifuez8t
X-Rspamd-Server: rspam06
X-HE-Tag: 1780035381-195458
X-HE-Meta: U2FsdGVkX1/63QmCF7CovBb93Fx9Zr4fxigbjkyNUkhXHVeOzVxgkLlCmZmu5qUPva42ZljbLOzbm6cbIOxa4aS48IOYfqeFP3QMycAdOROGogyTrT/tgLw3HDNwUtbFz6X69tYtxpPerqi48sV7ArSV6YC6DBwWiTwCSYvIN+RYE9mUwueWwe8xJOQ4lAfUpvbeEIjb+5Rd5npx4Wap5tvKvYcPlp1wYCP+2OtUc4b2l0d4a/4jdMy30/kPcqow1/KdKi3GeObH0dXvHOyzI23p86HvZZ4R+DGscqIIPyVVSAruf4fkQ1Tlx5kLm4RuLVnxw3H65+3Ul7qFgHMvbU1WqgiiAv4n5AuisMtki8HssP4Xi1cdCpKKST4yrAmgMaWFoXn5VagjEiGZJFAlaz9Mh5+7L2lY8ysggQe0G15AlIEkPy997GSBCJiHxoezr4PJs0M273Cv+0Y2oUPTzc7lUGHmCcRrUMLOySFRY1kwrft8ix04jlzeTUL+SRMgcIH3W1/AunWTjtIu+LeLVWTele7kcsnBTkdd6khzM5P+Jhm+imueCI/PWQwwtCHmS6fLBh/mpGBOjjPy3wOZ5y9bhoXSO8/oS+JifmfQ3lTpQB2wKUcStUxy9qPMyw+GpYBm3K+ifZeRUQo2th36CrH1MQLm/H5g+2I76gkT5I1Q+aAvBhxO9EVizWM1KWSOY61sDo/n4q/yDY3m9IrFQhpRUmPck31WBvAHSdaK/5uw9lL3exiphgTeBGRR5engx/lRw4YM+NQRFZflTb0/q5VPHnTNyxgPaik4AvHusCMcZwcWiGLpSDO/VXUA9jTBa4UcE/+CHeiE/eFPCPpIl9P+f+QnxF5pN++2UM8F4SJWYN2sQkUFDZyiGXoSxsHJuw/gHxQ1N/aqZ6sQ5CmYNUn1HtS+evHefCqTdonVkHVL+z4JiPH0AdHJoCzWr92FWQnPkQgRkjReKExMpFj
 UAygx6Mh
 c9kqbSn1+UvLd3EL+6CzrKHa/T8Uhto+OqVUHx6IS9A5T7BnhvGAejMvgmFaWTK4NcAwelsRJ2T4WiCyEOQ12+8n0B3MLTxTOc8W7i/STChooFvSb7b8wq0/M80xMOqbEEacwlXKcR+D93GbqB+xr0zg/57v2DiO9ORnzlxKRxg/igQx4QOI8JrW8nxMZdO/9dxGr6HQtQfhJzf3T1QqGWJWDRGKwtZpEjF2kjbTG3CExDUJS6Q8uWb/wx8FUBFMD8SOC6PW4uGLnaa6Pfklkl+3wBpSz8QFdip5+ifzV7UnsbTuPAf6fuZV9MaWscInHbDd4hIrnjTD4yVGs5fcdOEikDuZ88/TjvmXTtthPAJ5SA9nNiGvzsYovU1VAU0P829jzQTkAnIUSfZbJD5v95Oz06fqBjGks9jLzAFmLNz1HA/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 19:59, Matthew Wilcox (Oracle) wrote:
> This is a simple helper which replaces page_folio(bvec->bv_page).
> Minor improvement in readability, but the real motivation is to reduce
> the number of references to bvec->bv_page so that it can be changed
> with less work.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Leon Romanovsky <leon@kernel.org>
> ---
>   block/bio.c          |  6 +++---
>   include/linux/bio.h  |  2 +-
>   include/linux/bvec.h | 15 +++++++++++++++
>   io_uring/rsrc.c      |  2 +-
>   mm/page_io.c         |  4 ++--
>   5 files changed, 22 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

