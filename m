Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DFECCD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 17:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977716B00DD; Wed, 20 May 2026 13:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 927996B00DE; Wed, 20 May 2026 13:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 816656B00E0; Wed, 20 May 2026 13:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7736B00DD
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:00:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2AC731403D7
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:00:41 +0000 (UTC)
X-FDA: 84788412282.09.2C8824D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id CD77A20020
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:00:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XFeteOEb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gm0sDgpC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XFeteOEb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gm0sDgpC;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779296439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hP3GgoM+7XosNtAoNN1KCHY5Cnngjk0GxA2K4eewNT4=;
	b=A6fGH3O0FkHj91BKgAQ5Y5JNj/9fs2KZP71PuaK502/2gos2t3Rlzd2V6R1rzUgY6B/j3u
	866s4FyPwutkn3UNv3hinwTGUka8Cq6J6RmZ0PkJ++j/nMTXaWP9QSqAGPiZqPFWcGO5IA
	huRNj9kciHEHf0JJB07bwCFGoRBK/jM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779296439; a=rsa-sha256;
	cv=none;
	b=piOLXx3iz/CsaTc1lJQ5UksWHt98qMf6dGiFdp2DYczSdissQMs3GZMFxMKJ18km1V+9PK
	FCssQ+lnmTsEy/y41hq5PQ46o7s0I2qPUW7R6X7DPMq1gXYt9sHzAQhfpPSsW/P2bFCAJo
	XwLQV/vmUlzuZ0r4c8K9BJSFzLnXuD8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XFeteOEb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gm0sDgpC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XFeteOEb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gm0sDgpC;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 664F66A8B9;
	Wed, 20 May 2026 17:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779296437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hP3GgoM+7XosNtAoNN1KCHY5Cnngjk0GxA2K4eewNT4=;
	b=XFeteOEbesfi1pQ2qFaVbK9P7Mmoc4JRQol3VJQ2aoNQl6iwdPMh5jjlGrbVjXVjDvegXM
	FKOS4k9Yh+HScq6FuMf260TWNOVI+P04Ds52pzerVzvgsIW/DLlsSq//gN3LaU702yelh/
	s1nBdh3s90I0fHUjTbZKN4bZTUFnbso=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779296437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hP3GgoM+7XosNtAoNN1KCHY5Cnngjk0GxA2K4eewNT4=;
	b=gm0sDgpCOqHXWjMnhqJPIqd2MA6Hmw32f8gJFcpFx3RAXVPmV6uoqL8of5z4hV2DY+JWVU
	2rntfXwXDRXP2HAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779296437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hP3GgoM+7XosNtAoNN1KCHY5Cnngjk0GxA2K4eewNT4=;
	b=XFeteOEbesfi1pQ2qFaVbK9P7Mmoc4JRQol3VJQ2aoNQl6iwdPMh5jjlGrbVjXVjDvegXM
	FKOS4k9Yh+HScq6FuMf260TWNOVI+P04Ds52pzerVzvgsIW/DLlsSq//gN3LaU702yelh/
	s1nBdh3s90I0fHUjTbZKN4bZTUFnbso=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779296437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hP3GgoM+7XosNtAoNN1KCHY5Cnngjk0GxA2K4eewNT4=;
	b=gm0sDgpCOqHXWjMnhqJPIqd2MA6Hmw32f8gJFcpFx3RAXVPmV6uoqL8of5z4hV2DY+JWVU
	2rntfXwXDRXP2HAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0BA7E593AA;
	Wed, 20 May 2026 17:00:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WQvLALXoDWpmDQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 20 May 2026 17:00:37 +0000
Date: Wed, 20 May 2026 19:00:31 +0200
From: Pedro Falcato <pfalcato@suse.de>
To: Daniel Palmer <daniel@thingy.jp>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/nommu: Implement just enough vmap that compressed
 erofs can be mounted
Message-ID: <ag3np3Qf-s216nIM@pedro-suse>
References: <20260520163442.1099667-1-daniel@thingy.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520163442.1099667-1-daniel@thingy.jp>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD77A20020
X-Stat-Signature: dzphedqw9b4hsibb4iz58zdt53zfobmi
X-Rspam-User: 
X-HE-Tag: 1779296438-720556
X-HE-Meta: U2FsdGVkX1+iX7vM9aXBmv07+qmO7R6sDaHzi/ZLubgI8au3XYC/caCCeFfcd3j8TePo4IGzHtmLeqpmeCEqfT7Ps3houHFsHS/5hUrdqIzCpgtI5IjVdXbO+oDrz7k6osBhI9BOJAaWhi1csWZe7PkTRwikEjyNuZ1GXHNeQYzzMdLibNPleDuZLYhlThiAWdUQG78OjiPer6kcmPwOvK98dDHk9OOkqnKVldwkxXy0OmAaef/WcwvR2EqB8/yu8BcRuHmyyjXljiK7hC+ehuLd+jjlK0prbt2g8DjyCpMtGgYhOAwRgkXkqISys4Bm9Mge8jyIksgio8k2aBBAYLP4V0Jrjod6jWhY+vnH3dnJ//nq39MJnoIqD8eCsmuQhaVzfD8DfOTs4RhBxp9u9LmjSO2rLsDdqTuQWcbA1iOKiGvN7kM4DJm+Fd4pefWCX+uc1M4oNEf3wTlaHNIIYDieV7uwC/6ldpTp4dBPUmro4vUA18ngWAaa+xAHInkGc8d5fOnTRftT/mUjJgdxuV+iigbXNZapUhcNLY0oCVhyiJqYJCONYByAknrzFhIUe7BUnACN7wexN1w/756+3oXTsq+PRgyQ0NwFY4bvs3V79TqXLklFjBMnub96W9dbH6JBZOfsmhspJHr8BSIkHtDmhoc6pKy9WyaMI7ldhJ2r1+FjXVqHX/vCWYODTFUVhkNRIErahk4ZL8D3fLmymVm1nF4Dzd5fsDKrswJh2OxmXt1Z4WxpAZ5lYdDJ6on2Q0DHBkfcBtGgkJhPV3M6l98aOZCsH/fa/02HFCJG3dWl8ZA49mRZPX8G7AjNUAZsLWfEU3tzJ6XLp+eV3NSiY/ovp06M+iV6LmsMlL9YzgMKj3fYgyRfXQ/9qDxofNKTiZIh4ZMQIxS992Mtp455rzI+Pu6Va+ZyVMkaTgsFYz3toE9w1WiEfJpH4TxepxW6sQHBBb07JC3RJFeIYpC
 2H6Dg2tg
 gOZgx/F9UWal1ILsiOg8zyPsHLl+3lLC4RaPomNuRdR0UNr8sddx6gO+9y8b4rXSr0vuGFTAcJTpcxtg5AzzcRsoVQm+rAFTvd+KMrlIEh0DxOV4lUahahXSPOTJYyYX2raITJvfyX/rgfTKJoFmXyaR+wQYcHNLOZJpbH7DZhV1WlE6rkvxiyhbxHKqXludJFJdw75RMwOGSdA6RcwHukAWgPXDXD4GEpLr6LsPBsGr84ckDbAFGXbgbmmvytEWO8ccdGt5JVHkKyLCAuwy1UHKLuzje3oytYQ84QrVBg0QT960=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Thu, May 21, 2026 at 01:34:38AM +0900, Daniel Palmer wrote:
> This implements a very poor imitation of vmap that works just
> enough that compressed erofs filesystems can be mounted on nommu
> machines. Right now compressed erofs filesystems trigger a BUG()
> on nommu due to this missing.
> 
> This is awful, doesn't work like real vmap etc,.. but if you
> really cared about stuff working you'd have an MMU I guess?
> 
> Signed-off-by: Daniel Palmer <daniel@thingy.jp>
> ---
> 
> Did I miss anything massive that is going to come back and bite me?
> Maybe it would have made more sense just to change the erofs
> code so on !CONFIG_MMU it doesn't use vmap?

Yes, I think that would be preferrable. I'm sure[1] it's possible to get
EROFS to not use vmap().

I know your patch took some effort but trying to implement this for nommu
is fundamentally not possible. Like your vmap() "bouncing" is completely
fake and users expecting that the pages are actually shared will have a nasty
surprise.


So, yeah, please see if you can find a way forward for erofs :)

[1] I hope.

-- 
Pedro

