Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48716CD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 10:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A66C6B0005; Mon, 15 Jun 2026 06:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E9D6B008A; Mon, 15 Jun 2026 06:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793CF6B008C; Mon, 15 Jun 2026 06:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7FF6B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:07:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1473B1C1F91
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 10:07:39 +0000 (UTC)
X-FDA: 84881720238.08.58EE8D0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id C51BC1C0003
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 10:07:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lIWfMw4+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t7GE2tcE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lIWfMw4+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t7GE2tcE;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781518057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bcwcuid5G9Jv1yAJ2BEQE/cLseUTL/2R5NAEuMMhL8s=;
	b=eCh4OngUVRhl2IjnKXkTl9pBrYW4JR97DGVlIgbYeljA9KgT+U4T0mi0LgmAsPMrS4jZLk
	BhaHHBcOpYy/e4f5MJ3eb7qRGMoliyiNhiEH2BVpi9kpGL0hmPGtN6S9RIVQU7QvX4D02W
	Wdv2wZQIGNEWRgG5AU3/yCUoLNzo0tI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lIWfMw4+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t7GE2tcE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lIWfMw4+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t7GE2tcE;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781518057;
	b=T/rh1DWEbmRjs7O4YiPKyn2E5cFoKmw0wHF1l2zf0nh4WiTCMbmxSNxMtkl4levsfzxxUB
	pn/Dy08kn8FbesXV05tY8zxI5gBf6Ns/xEitfB5ZCB0BU0YBNPVzHq3QiN9FMYDuRCl1Ud
	nZT1T5TlBwDa9p8fc9qYn+aJmSq/Fmg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 05D8F75938;
	Mon, 15 Jun 2026 10:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781518055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bcwcuid5G9Jv1yAJ2BEQE/cLseUTL/2R5NAEuMMhL8s=;
	b=lIWfMw4+rNTJWFvjKaMg19WvN7uXYaEL/vc9yYUWlX3NTQiwVXNqsO4Yag5WnpDkDGWN1u
	FCNRj/ypXIisZylFFLwG4qDxMD9EZSd9+vBmHD5XQhE3yx6oTR2bhoM+1WC8bLrpiLLELc
	nqLtRgTBmJmPn73fZ8TQ7ii60F9oxTM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781518055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bcwcuid5G9Jv1yAJ2BEQE/cLseUTL/2R5NAEuMMhL8s=;
	b=t7GE2tcEHcCkbYQInDvZT+SaB70th4oyF0Wlm6kqpMdYvUz/tgyXUOBnNKnZR3Pxrjy2HY
	DOwTWKUzN0fOs+CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781518055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bcwcuid5G9Jv1yAJ2BEQE/cLseUTL/2R5NAEuMMhL8s=;
	b=lIWfMw4+rNTJWFvjKaMg19WvN7uXYaEL/vc9yYUWlX3NTQiwVXNqsO4Yag5WnpDkDGWN1u
	FCNRj/ypXIisZylFFLwG4qDxMD9EZSd9+vBmHD5XQhE3yx6oTR2bhoM+1WC8bLrpiLLELc
	nqLtRgTBmJmPn73fZ8TQ7ii60F9oxTM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781518055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bcwcuid5G9Jv1yAJ2BEQE/cLseUTL/2R5NAEuMMhL8s=;
	b=t7GE2tcEHcCkbYQInDvZT+SaB70th4oyF0Wlm6kqpMdYvUz/tgyXUOBnNKnZR3Pxrjy2HY
	DOwTWKUzN0fOs+CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BB0E0779A7;
	Mon, 15 Jun 2026 10:07:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hHJGKuXOL2qLZgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 15 Jun 2026 10:07:33 +0000
Date: Mon, 15 Jun 2026 11:07:31 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, linux-hardening@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Simon Horman <horms@kernel.org>, Jason Xing <kerneljasonxing@gmail.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH net-next v2 0/2] net: isolate SKB data area allocations
Message-ID: <ai_ObgbjlahfXs37@pedro-suse>
References: <20260611124642.345400-1-pfalcato@suse.de>
 <20260613113303.7562bc59@kernel.org>
 <ad862f5c-34e4-48d6-8d8b-f02bdc02d7d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad862f5c-34e4-48d6-8d8b-f02bdc02d7d6@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C51BC1C0003
X-Stat-Signature: cdrdijrr6ohjx5fs5xc45uiaiqn7oxku
X-Rspam-User: 
X-HE-Tag: 1781518056-294921
X-HE-Meta: U2FsdGVkX180ND2xhzw/bQLiSDu+NOhZW3vD+IClyg87x9ufdJ+R3m3Hnj+DxPPGT2IAqIR+p1D3QTqSkUqkUUkKBepDUokfHRdq08KMQ0MVk6YEkNjSTAK4Ca98rALOKJf8REvHF1KoIN5JmgHTdYg2a/J4JVbqhjk9x96ZqTY3z4vZvnv2vZnRLb6QX2MAG3QQWUQfLtN1pspwqZRHjyZiEN0PC2/Ys7oJUbi4WtMi946YVunrHAZVzICuWPsua5Azknp09KhoPr6Mqzd0m/LN+Tc1MBBFFzJ22gEAFTb3F9xZ1hi8QaBgdy9xHUfPwagy3wWlYWq5sGrefnyCkidktVig3plT0NN02zXdJuwEAm7jFrsuH9yeeQd7qmYQr1QoIlwFqF5Cps+FTYBLXPsH6R4yUeLCDylyw4QhsjE/8/acxghDZDHLCQZ3jFXeBiUjIZix7uYYaW+gxH+lZ3dm0WZeUpyxZhD9sq5mnu7voeT7epzUWbyGfpYtgTjxveJLJgZ0i8i/Q4rTPefmJauQuq+rCZDdbWE+WIiGuzCTAchJq1JXIwDDgQJmA8uctbNHujtR9fqf+Z3zoSjN9PiGpSJw3gH7U3rmwri6zQm5vV94pXsQlm5g065/CoVLRUmYeGSWFNqDf6G6ZAaSl5X0qwxtTrRjT56+jnsq42hCFd7VphnRalb9+r6dI1JYQpN67kKVnZDRnL7AadlOnZUQdk0B6UbVX+KN/nrMfn6zTQ74933D15aoi29XHWy9+q2HPIqB76OG6QjwVkByuP9pZVYirO746wKfc28IEyLzrlpdpuoeMbr6lMbplFcICPApyTgK88uvKkqMHR+m4ttPn+xlqFcNQ5BxKI9j4RcLYJU1UGJOfMc6ATZawNsjAUBlN21FD4zIElNFqD5BENfJi5v1iWz2DpSoufK0Ofhb+52Vj+oT6zxygv2Eu1t4/FRM//6oUBKdnCK9ikY
 ETCSL4Nl
 Fl2gGXjjDo+MsBM+LB/uByA0x8XQz7h1jZnSnPZG5eWhU5F3IXzbdtE1Zvhm/f0XsfESPy6tl86pjVEpSYAD+ADRPdBeXFcshXWKRkQIc1ptpfnXdbuKfIwFudJAN2rIRfYHoaYa1Vj3IZLyMR9x/eNtL4vd/cbVVZ2C5UU5GGwiZ5bagayzpokWvYiv/rtAzPS2A5Fz8TyxoS2ASqwPlRowBP95aPvkgWycsTdCqnqyjnUncxM+iBrgju1BiTHknfvxSE6fbAYf3GL0X1yjTlQpCEIaDrocVvjetltkG5diNT/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 09:28:39AM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/13/26 20:33, Jakub Kicinski wrote:
> > On Thu, 11 Jun 2026 13:46:40 +0100 Pedro Falcato wrote:
> >> Subject: [PATCH net-next v2 0/2] net: isolate SKB data area allocations
> > 
> > This doesn't apply to net-next, does patch 2 not apply to mm?

Ugh, annoying - really should have rebased on net-next precisely
(vs just linux-next).

> > If neither tree can take both - maybe MM can take the first patch by
> 
> OK I'll take the first patch through the slab tree in the planned second
> next week's PR.

Thanks!

> 
> > itself and we will queue patch 2 after the changes propagate during 
> > the merge window?
> 

It's all the same to me, I'll have to resubmit the patches when the merge
window closes. So whatever is easier on the maintainers side sounds good to
me :)

-- 
Pedro

