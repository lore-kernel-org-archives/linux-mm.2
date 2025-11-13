Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A42C7CD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:10:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DF828E0007; Thu, 13 Nov 2025 12:10:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 090B58E0002; Thu, 13 Nov 2025 12:10:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72738E0007; Thu, 13 Nov 2025 12:10:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D12688E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:10:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AEE013BF83
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:10:38 +0000 (UTC)
X-FDA: 84106222956.21.EA862FD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0E96B1C0012
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:10:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TECEMT2W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XMKnT0Bn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TECEMT2W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XMKnT0Bn;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfosqSfA7Ck/rRxcQyj6uQq0w6Nfghu6FH6JEc/unqM=;
	b=mle6s9Y1RJ2dPCCIa5ajVQTRKhVS5DcEoFAmEQeZZox6SjUBGb5QJ/hYt8neeOmyi1OCQP
	LKUljFUJfyuUPBc0Q/tqlNut2xNijJLYYcRcHBoEsBwJGdyz+M903tUOOYHdG0kdjOJdFX
	gbJCF6mwrrmGNrVqAw8TRausq2EBH+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053836; a=rsa-sha256;
	cv=none;
	b=L/6mz8nz8ABOOAq+64OY3aybmNgh1Zf7SUo98M9Js3nhOEf2QJCi/OYKJRyUC7EWPutUmw
	HKRfyUxGLmISLwxT3feODHZAJfT3m0Ie3Kz+rEijBaTYCrBk0LM8/hPGKFr89/852cwukK
	Cbdgozn1LCXmqtI2AKQLdHeJl7kcS08=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TECEMT2W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XMKnT0Bn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TECEMT2W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XMKnT0Bn;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1742121285;
	Thu, 13 Nov 2025 17:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763053834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SfosqSfA7Ck/rRxcQyj6uQq0w6Nfghu6FH6JEc/unqM=;
	b=TECEMT2WYNmEP/lufHSFTJxh92S8n3RCR7o9QmWPOAVl+5vxhVghEL/bF52+/Lme3by9ZY
	oYoGGEccpj73K2gbawVjkn7OvEDVipG1jx/tTGsriezpIIDXEiJBWWH5NcCXeTY4RidvSS
	5UDJ2xtA1B+mzOZ/POFUBYokuQBgPHk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763053834;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SfosqSfA7Ck/rRxcQyj6uQq0w6Nfghu6FH6JEc/unqM=;
	b=XMKnT0BnLtd074BwoCNvUoEOytJdjJvpAQxJPnv4R25vhkdX+rqXbEtRhr00kmWm1QVPPa
	AD0j0qj4ouPIfSDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763053834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SfosqSfA7Ck/rRxcQyj6uQq0w6Nfghu6FH6JEc/unqM=;
	b=TECEMT2WYNmEP/lufHSFTJxh92S8n3RCR7o9QmWPOAVl+5vxhVghEL/bF52+/Lme3by9ZY
	oYoGGEccpj73K2gbawVjkn7OvEDVipG1jx/tTGsriezpIIDXEiJBWWH5NcCXeTY4RidvSS
	5UDJ2xtA1B+mzOZ/POFUBYokuQBgPHk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763053834;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SfosqSfA7Ck/rRxcQyj6uQq0w6Nfghu6FH6JEc/unqM=;
	b=XMKnT0BnLtd074BwoCNvUoEOytJdjJvpAQxJPnv4R25vhkdX+rqXbEtRhr00kmWm1QVPPa
	AD0j0qj4ouPIfSDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 06E533EA61;
	Thu, 13 Nov 2025 17:10:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jewkAQoRFmk3RAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 13 Nov 2025 17:10:34 +0000
Message-ID: <0ddd2ad7-04e5-49f1-9f46-653cee9ecba1@suse.cz>
Date: Thu, 13 Nov 2025 18:10:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1] mm/slub: fix memory leak in free_to_pcs_bulk()
Content-Language: en-US
To: Tytus Rogalewski <tytanick@gmail.com>, Harry Yoo <harry.yoo@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
References: <20251111125331.12246-1-harry.yoo@oracle.com>
 <20251112184645.GP196391@frogsfrogsfrogs> <aRUpqFS8pU0qGIsb@hyeyoo>
 <CANfXJzsha8NtY6SwVzq=w1fNYSF46x3yeGk-ZuGCUj7CGrn5nw@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CANfXJzsha8NtY6SwVzq=w1fNYSF46x3yeGk-ZuGCUj7CGrn5nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: m4jax589dd95s195jif934ah6hk8skif
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E96B1C0012
X-Rspamd-Server: rspam10
X-HE-Tag: 1763053835-578690
X-HE-Meta: U2FsdGVkX1+prhGRuZULZ7bm7Uxcn2Ba4R7MuNEMSE1n9wuOs79VGp4Pe5e8ju6G1FnToszjtf3isTqDukHESgc4pFCtWLAxVwNVAZj7o/V3dBGbn5wCm5olMm150LCG36cM1nsvsY8WMBPqI47myrmXc3Ddx3m5H9V0UsEFAOb/rl3shctMiL3Db7SkoEX8zObjJQ2IKAWo71+KcoJx2qdTnZ/fT1Ms8PLbZEthu4fJb+RUGcx+XM0tgpHr4M6fGW+GVeuoEUGyKnAVvbKK9Zzp0yQrj5vIUr5rsOZoMeDJuX9BT3RE9XRjxIUSRZ0vA4pzfWcFtHEdi+HfuzueFdD3rsTZkE029JKPALe4HXPGdIqlnGrnnCUQuP256OUWL1B8LEcqm9uOuoxEs+TUyfPY5u5VFzqBINIvsqcjGvUTttk5tTcGHrnT9VqIQx/BlDL/V4x1sTraObfDsyb6uRLpmOq6zMAwcNEl3SPyD7Xf6lrpAQOGFOE6DGJcVhrMkwbYEvkJ44eDtK//a9SPDiK8eghn3sn9IBtvhUy+/UaJlcDzjogfSaBx2Wkh9KTz6m7O4gcN3GWCwT4zm+/bFXNh3LOjJJQQdSbFNUT5CISz4PkcKCAajkjqRneYmOK7cscz1UnBUT57QqHWvqIWlFvADD2CGMxwTWGkCG2+/xmg0I2UUZc9T8+Z3Ei75CIjl+dRO9z6/rG0pqqImDYcU2gPG9YLS6lGLkRULKxoWTI/A8lXFy7nNR/NBJ9vzUovTqDZ4GBmN59ear2Dq46Gna2Alxmt9fkNMw1NJsejfqirpM3X6UTIc1GEWMKKJWxrdEfpq6e/xvsjIYya54RC5Vrv4wmWTjLPjxlzeZynEc3+jJQ4w2KAciVcp2/DZpyU5Ux6Oysjr05Atn/0WQhpTWxdEMZE1vCsc92scVq4tZgjmiQnTbKhhExIS8no0ffaUIrZT+tvZqLEVXaxNW+
 nqxMvDIg
 yMLClpOvHKWMY1r7nuDGE3EBW856F1G05NjtXgBiwvxl/h6kg4ZAJtPYDk4X1y6mXxYMC/q8mVWq78aq5U01eLa/HfMrePHufeZ5UBANhdluvN9BQhNT450I+e7+sf3TRnAXdguulOG6g6P56B70ke4kRBtLvGKLjFA5jxzjiWLYEFNwHkwL6gbrpIJJpofURDa7foW678JhMKlHxStjSqtqtdd1qS1QivcmNcSm/3ZWhEhhI/HwV2xdJHZ8oXpLdlAU1saITKNF5eelSjSAUEtASbWba8RSk0vRn2kH2YPX9NeiRRZz3vkMb+2rNw8/DhFLEyctip23IO44A4A9irf0xmqUYJ4dXg0xChYF8I0Gau80ZfWuL1dqFMi+P1kvb4/Cd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 18:02, Tytus Rogalewski wrote:
> Hi,
> OK it seems that this in deed fixed the issue, and i do not see leak now.
> Thanks for fixing it :)

Great, thanks a lot! Can I add then this?

Tested-by: Tytus Rogalewski <tytanick@gmail.com>


