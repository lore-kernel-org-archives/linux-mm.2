Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1DC606A320
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 13:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=DM2fPH07;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=C2qqh51M;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=DM2fPH07;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=C2qqh51M
Received: by kanga.kvack.org (Postfix)
	id B72E86B0367; Fri, 23 Oct 2026 09:30:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B49FD6B0368; Fri, 23 Oct 2026 09:30:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5FB86B036A; Fri, 23 Oct 2026 09:30:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8231F6B0367
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:30:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F7D21C37AF
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:30:33 +0000 (UTC)
X-FDA: 85353975546.18.F287E8F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 067CD12000C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:30:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DM2fPH07;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C2qqh51M;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DM2fPH07;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C2qqh51M;
	spf=pass (imf29.hostedemail.com: domain of tiwai@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tiwai@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792762231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H5C2YgX9zoAUN8RdPNBEehJ+u01y85A4y2Tev8DT1hg=;
	b=O0vPpbr8rOq6V6K+Ux1Plu5FI1zs+i/0YgwdynicIDzhDxtz6TGHrVPZH12rufTp9f8Hzp
	MaoI7pDA2RghNZmYelHkCtxzqA165hkCKxbdU34RbT6bQWZTr4NwvVT2pY9A/2cMsgNyKu
	DZXpEwK+xdFTY/zw2kQPB+Jo64I9bCo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792762231;
	b=K5b9xuPLE6q3ougL+VroiKSohBCa9kLknvPpYJt/9u+egNKscU25TUVGferRjESEVazJDz
	Cr9qA0w5oxl23om8Uz/hmN24iFmIU5XplccWx0Q3Ec9GCZcSDtJ1ePaZ6e5uAsu/5jxD1Q
	HZnH6VaUSsEcTH+igU3waG4Oz/g3kcA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DM2fPH07;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C2qqh51M;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DM2fPH07;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=C2qqh51M;
	spf=pass (imf29.hostedemail.com: domain of tiwai@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tiwai@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 706C5220D3;
	Fri, 23 Oct 2026 13:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792762229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H5C2YgX9zoAUN8RdPNBEehJ+u01y85A4y2Tev8DT1hg=;
	b=DM2fPH07E17ZTllrMqBRrD7OXjttjIWUEXjPuHEzvJUpNbQXN5qmQX5BKeCz7uARth7cFG
	j2H5n9KXSd3FPBvFvWtuOM/bHW/K9BbLIrWGBAEec5ocN9CYFBpX6PD+8s70dyUcWwhRn7
	gjREfMDayFpjOGuAUiu20/NDOkbWSKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792762229;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H5C2YgX9zoAUN8RdPNBEehJ+u01y85A4y2Tev8DT1hg=;
	b=C2qqh51MJIORQZbHuWwC4QjEFo8QJkfsrAgse2aSBwc/Y3PojDaCf1KInPaBjuBeY9iV3R
	CaW8W3f6HwFeUfBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792762229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H5C2YgX9zoAUN8RdPNBEehJ+u01y85A4y2Tev8DT1hg=;
	b=DM2fPH07E17ZTllrMqBRrD7OXjttjIWUEXjPuHEzvJUpNbQXN5qmQX5BKeCz7uARth7cFG
	j2H5n9KXSd3FPBvFvWtuOM/bHW/K9BbLIrWGBAEec5ocN9CYFBpX6PD+8s70dyUcWwhRn7
	gjREfMDayFpjOGuAUiu20/NDOkbWSKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792762229;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H5C2YgX9zoAUN8RdPNBEehJ+u01y85A4y2Tev8DT1hg=;
	b=C2qqh51MJIORQZbHuWwC4QjEFo8QJkfsrAgse2aSBwc/Y3PojDaCf1KInPaBjuBeY9iV3R
	CaW8W3f6HwFeUfBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12033133F6;
	Fri, 23 Oct 2026 13:30:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 342PNXRh22rrSgAAD6G6ig
	(envelope-from <tiwai@suse.de>); Fri, 23 Oct 2026 13:30:29 +0000
Date: Fri, 23 Oct 2026 15:30:28 +0200
Message-ID: <87pkx0a6iz.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Carlier <devnexen@gmail.com>
Subject: Re: [PATCH] ALSA: us122l: mark hwdep mappings VM_MIXEDMAP
In-Reply-To: <20261023-fix-us122l-mixedmap-v1-1-e7bdd053850f@kernel.org>
References: <20261023-fix-us122l-mixedmap-v1-1-e7bdd053850f@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spam-Score: -10.80
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 067CD12000C
X-Stat-Signature: 9xnhhhkkoe13316t8pedothp3bffgrup
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792762230-740501
X-HE-Meta: U2FsdGVkX1/SxfLdiAn/Wu04kcq7qsFOcEcUuoS0GlU7y2fQwDVpDqe6tY+JNhjdGLxTCARbFdhRWrZP1bfg5Rs3/WfyQo+qMBd5T/1p6KX73EnYv9B6lFNBc+aIH4+s7+/hF26tEjc+Bso+VUATnkEEtDeHUEj/o5fivaTJfQTtBkmMiaJkXgxTqK5uDne0Llrp8xcvYImx0xAkFybY7iAWJXs16r+dEwz4jSSMaRJk9hq/vuCHziUKo2wME96qvwQd2uSEO9JYqYNOkhzuLxonIBDH/MyodrEKekvY+mNrbsQz63yxhrxrP63HhGClIJhAKu0v0vf40OVAQ9OYiq7SuerpVTpjHnM1D1tLdf84me9sa6EWaGBcgVLEnO8YjWDnjQS1pmvilPNrs6NJfq4IsRRcMfqOs5D/JPCTPU+d8GL2SoPS+oh0cHFIM015S1JpYVL4ig2ijnFPyCRjvY9syrzf8ZQuvuyuP0o0nkgOPU1TSa0tv5B/+wDr448VsWM8dbHZOs4J6lHLfaQXogiR8+XprQYtGO3uznTo4B7tiis63KWjBzITOnHPBIFOOk4v/7T2iRdfcFHccvXeWjBXn6KR2BFY4QEDtMPoWrPr2segMOU0wodSB1dbzU3WOtFIroY89SMIR+b+7f3FDzlwyrd1u6Yhi7TQZF2nmGybq1ySfdtAFO+PTf2meWxotHh+0TqmRdQ6KOgBvnUEHmuzNLTLarYWijaMg0J6RcZH8kWyIRyaCVJFaBCcagxlf2CtqFblojuj8Z/kile9S2hX8NL5V2R7tGhlP/LEUVBDjeowsFtVPWWYLXsLjaMM8v5iEfhbfxxPxEuyk8YMK/uN5vtED5QlXkyCXhj3yXDX8/gXwr+pigbDucxG7MWr2AOF5uLYkjBGQ2OIA4kS6XDK0qZT/A9EZra4ooxnsLkrCxAy25WktonPGs/Nbs66UCxycEt47EJ/y9ivZb+
 VagBDnci
 FVLAvGETCKA9navD733xrz2rI82AlVMLtfnnMzqClU9a7GT6PBhxWaNDfcubf3Xp/vF+y1DSnDONhV74/hO9Sfx7MTIbCWP1zn3okizFBrbnJ4Tds0CnpfGU3LXGL8LgvScZ7J7ZEj9cAuoc1K1hMK+fWHTs0Qu8K4tO9YzNJ+vxGwj6w5kyjkoXklELtav8AnfPcDCJAK0VpDkYNwpX2snFn4OYnlY2vSH5N++/rRCXkBHTsi8Qs+7yhPBe6E8Dn4E/NjlKRfdeo821FGYLpSIm71n5AFRUwfHgidmPEXmxEf+gUitYqKG2jrJ2sauYpr4euVezmrEfulB9vmkAj15wiqL8egNfYTyvatq8bjGmP1Mt8aPnED+B2uSxzxS4bVbFO2LU9gsTvFmWU4Jl1asS25zu40CQ7e0BwLM4py0ftqyX91YLqkrW32NMssfRThgxOlMllJdwY3ETZQaaWkbVEkniOI464M3+uOgf3V3KyflrgbyaInzLhpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 23 Oct 2026 12:21:31 +0200,
Lorenzo Stoakes (ARM) wrote:
> 
> mm has recently moved to a strict model which requires any driver which
> clears VMA_MAYWRITE_BIT to be mapping non-mm-managed memory
> (VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT), failing any such mmap() with an
> error and a kernel warning - see "mm/vma: only allow mmap to clear
> VMA_MAYWRITE_BIT if not mm-managed".
> 
> However, simultaneous to this, commit 71c610aeb177 ("ALSA: us122l: Prevent
> write upgrades for read mappings") updated us122l to clear
> VMA_MAYWRITE_BIT without marking the region with either VMA_PFNMAP_BIT or
> VMA_MIXEDMAP_BIT.
> 
> vm_insert_pages() and friends set this automatically, however this driver
> maps its pre-allocated pages from a fault handler, so never calls these.
> 
> Simply set the flag in usb_stream_hwdep_mmap() to resolve the issue. This
> correctly marks the mapping as one whose pages core mm does not manage,
> which has no meaningful impact for this driver beyond preventing the mmap()
> from failing.
> 
> Fixes: 71c610aeb177 ("ALSA: us122l: Prevent write upgrades for read mappings")
> Reported-by: David Carlier <devnexen@gmail.com>
> Closes: https://lore.kernel.org/20261018025905.201296-1-devnexen@gmail.com
> Cc: Kazuki Hanai <hnkz.64@gmail.com>
> Cc: Takashi Iwai <tiwai@suse.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> Andrew - I think easiest for you to take this.
> 
> It should go in before my series ideally to avoid bisection hazard, I think
> while it's a fix for the driver, that'll be the safest way.

Yes, feel free to take:

Acked-by: Takashi Iwai <tiwai@suse.de>


thanks,

Takashi

