Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5C92FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AB9A6B0005; Mon, 27 Apr 2026 04:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15BE36B0088; Mon, 27 Apr 2026 04:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B726B008A; Mon, 27 Apr 2026 04:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2AF36B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:40:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83E118C4A9
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:40:16 +0000 (UTC)
X-FDA: 84703688832.09.C9670A2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6112F180004
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:40:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nj+KaZoT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dZpnDmyN;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qQIp1vvF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MnJWARvn;
	spf=pass (imf24.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777279214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UReiR8tBfbqAEvNOviGNvtVyvBhm/HcNLTCRksGYy3I=;
	b=Z2SHE/Cq+8abDZjfx5I2pYHIe41C7Lkgj40qpeGn5k8JivMXDr8KyA1djcUlYEnMvlOf54
	zUpIlHW6c/5FDdG8pA0a3xWzix2HTP0OVpNbDYQcZ8HI66c9kUYc2FKjxhanfnfhMxdupS
	BIZ3gZvM4o3Ny0hqsPtpLAU6C5A3cXM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777279214; a=rsa-sha256;
	cv=none;
	b=0svAkhodgpFBUAs0hpUjJuJGbWuInfUm0EWfabovYx30X8ccDoASrkQ8JzH8wtS91IjpSn
	IHwvtADpryr0SYbwwMY9+QWUuEgd722ftahsm/sXGoPJsl92+qwiUOjpCQCo90lRk4qGgx
	IsGFBCUurPTBZgBnTonHPIzIPYq9bhY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nj+KaZoT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dZpnDmyN;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qQIp1vvF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MnJWARvn;
	spf=pass (imf24.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D7F695BE62;
	Mon, 27 Apr 2026 08:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777279213; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UReiR8tBfbqAEvNOviGNvtVyvBhm/HcNLTCRksGYy3I=;
	b=nj+KaZoTa9/GluQ+DtQMok6+GUWJi1tSIzfND7q2L8gk5IOcF7ADSICLODzq2/HDwKHuR1
	mwc1neZ6DMk57ngllZ7J3GsnGDuJaFGnXJZ0HQFjQArUVjpiAXBGWtiiQJzf0Aprw9pw5N
	2LD+fRuQSktgzxdecdWzeEGxtd9RFV4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777279213;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UReiR8tBfbqAEvNOviGNvtVyvBhm/HcNLTCRksGYy3I=;
	b=dZpnDmyNL8/pfI3pY1ODk1TSRuRBxiFsZiMCHy0UXtV95kCKLZQh6EeZ6uQZBb5ZUpQmYW
	qR31hY14RmsYwTAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777279212; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UReiR8tBfbqAEvNOviGNvtVyvBhm/HcNLTCRksGYy3I=;
	b=qQIp1vvF6IRXxs1zMpZogcXfT47UPQX2tZrk9tFoSjC8cRwLBVKntuH5EvgsK37aSYBEGv
	fFFW0tgJuYgGLmcuiyI9LdRRmpJ1LvQxtG9m0j4Jp0VEOgP4Wok1DScnpFZiS36ADkjn1P
	4ruWkvqy6PhyJcGkIo6TtKDeuL6m21w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777279212;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UReiR8tBfbqAEvNOviGNvtVyvBhm/HcNLTCRksGYy3I=;
	b=MnJWARvn4BQ8RqANKFlWJgXcRF03Fl+yplpj549cRVqodgRw5qXhJQGw5EPljgVL0wb/aR
	BlINi6ltNAnZqMAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6BB04593B0;
	Mon, 27 Apr 2026 08:40:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BQwYGOwg72n7JQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 27 Apr 2026 08:40:12 +0000
Date: Mon, 27 Apr 2026 10:40:02 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped_walk: add missing pgtable entry
 accessors
Message-ID: <ae8g4jipQxQZRe6E@localhost.localdomain>
References: <20260427052000.196402-1-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427052000.196402-1-agordeev@linux.ibm.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6112F180004
X-Rspam-User: 
X-Stat-Signature: 5sny9oj187g7qyqoksa11r5sqeuuayhm
X-HE-Tag: 1777279214-477257
X-HE-Meta: U2FsdGVkX19VZJjehlhd3vUKlJaeU6MnjtE/XpU5wfKjqBtWG1KGFD4QpGGlE0B9hKFMc6Neg17T+CWLsi3ViDU0jmOvr9Zc1vIQZrTNf4y8PvKwCtCxR4KzsGRwIvp+DW5t5t+1ng12sH3+mjRbfdEK3195sqyF9FophMXOTP3cb7+6wVblWW8UxPsuLtAUTTZ8qIL68SbZc8E3237ajWuFM/++RJMHVsfe75anSKKMSDsgY7ZHA3RHfFFJTwLFh/p9SbYoA4rSJY1EPRYHZdyWQbSxdoc44szyxp4YtwPUfEHGe8peKOp9vMELMLVPGYjoxYCJR2JZ0WKaEvi4WHw8/6u6AoW2VT0gNG2zYeHMXeniY8fJOuWOXyRfKN+fISgeY8zaDQDzg1lsPBdxhvHLmenTkQtrDraA4EiunHO7KAuSfqNCxiVfHIXQGZemuCm4fjPcd6UG2zYd8ivLM+I2Sc7vVPinmRnx0h7fbzPNaZz9Zgrpfapj046Br/+HeCV+OX7WjwqGB839n8OvlvlzhPsT+yVQiWDBDYM6sBpruiL4botbEKuM+2x+DQcXUCtaQJKVJs6OFEUiAh68wd2OqDtbjoRtBerXsjfqT2qfSaHj0u42uasmvZfr0JsWpsuQCOoSdmNgNdlj2iyFJRKaq7MN4AXRpupUkOSV8qGLC1AFuft7NNJZ9WBm2IJR8Ny+Kj57wkTCdnfJlktZB+kZ7qe/AxSAEFmeObR1M3CKsFBYM4KaAvnI643CIF6sOp6s3v6Bed8J2DJLg4svY1/GlNBlKRFJiAs+XmDzgMJ3vjGT50YT6+sbX53yHR8VbWqnG+aQG04mw77UpRL+PDcVCL24oQ3zMU/Ef0gVLyFFEpvzo9r/Ky3q8nTeT/MIctTNcnhD9Ia6UntGgwe7NAUvj+IyzBACJiEWgPZwOOjArJv+fivQHAiO8lHDWDzhMIh0apBFMWfdxOR0Fi/
 hv/NrXaB
 ocb+bR6k+QiPpdKH9wpXTpE2vY8DoVr9+CLZN6uISKD2aO710HBb3GLWiHJ4u+clnCm4Fy8lubh3PUdoWBds8EPTvbCKwT4Kr2/29cZXtW30stYtkmB78XJ/+T/d46m5WGkFmq0astwkeEO0otyoUGYRLv0p8Qs6EyVUU2P5JbRdiGAHJxRv1jFm9z5zl6GnD2P0m5xx4rOzy7EoRf7/IgHFq4zRIN/xC9lQtN/hLYccXhzCPGJxom+cBHucLBS0grEMCJmRZFKBxPb+6Yh0RtaVQZElnMNvpKnWmS1o1BpUsjC9y+1XLEgEZTr9/rBtTUK6JKtl/Q20KrlQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 07:20:00AM +0200, Alexander Gordeev wrote:
> Convert pgtable direct entry dereferences to the corresponding
> pXdp_get() accessors. Use ptep_get_lockless() variant for PTE
> reads when no lock is taken.
> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  mm/page_vma_mapped.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index b38a1d00c971..a4520bb10d2a 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
...
> @@ -317,7 +317,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  				goto restart;
>  			}
>  			pvmw->pte++;
> -		} while (pte_none(ptep_get(pvmw->pte)));
> +		} while (pte_none(ptep_get_lockless(pvmw->pte)));

map_pte() might take the lock if PVWN_SYNC mode, or am I missing something?

 

-- 
Oscar Salvador
SUSE Labs

