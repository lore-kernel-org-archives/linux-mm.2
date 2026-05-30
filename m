Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CAB0CD6E49
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 16:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 348346B008A; Sat, 30 May 2026 12:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F8E16B0092; Sat, 30 May 2026 12:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20EE26B0093; Sat, 30 May 2026 12:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 125056B008A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 12:19:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F1704038C
	for <linux-mm@kvack.org>; Sat, 30 May 2026 16:19:50 +0000 (UTC)
X-FDA: 84824597340.06.6440812
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id BC3ABA0009
	for <linux-mm@kvack.org>; Sat, 30 May 2026 16:19:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WZl0+4I9;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780157988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WxYmQxwwBxgWs6asR9XSCI+irQfqn2faBEqKE1hn53E=;
	b=q/ITkzL3qZIkqEPT9flce7HPg+nc0dnK1EF8vJ9vgCQalcy+9dJ2V0l9z04yw0BKY2nuSY
	+2MtxLeZcjshN8+Uk20GtZnDJ++iEISarNI+3gSYG12y+aS0OYKfTmii0J4sLTUG8CmQ9e
	CrBRyomwgNGb++/geYP5e7nhua75YFg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780157988; a=rsa-sha256;
	cv=none;
	b=iEAE33cLwIzGnvaWuPx4C3ANjl54uSQ74qtas1NY9+cFldVmquvc24TelJi1VNTzbK0AmC
	aiZFBwmcQdUyk1VuGmL4gUTtCZv5FjeZ8Mt185XzjsBoePL2VKdn0lu7fbRftkZ0FUdxgq
	9RvSRuHPBbEEbo86doc+8vRx25/PKBQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WZl0+4I9;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18ACC600BB;
	Sat, 30 May 2026 16:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD33E1F00893;
	Sat, 30 May 2026 16:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780157987;
	bh=WxYmQxwwBxgWs6asR9XSCI+irQfqn2faBEqKE1hn53E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WZl0+4I9eq0OPPyxyDBdqCGRR+y0CoJpx7P9J1ZNHafWZGZX1fuK9HT7HOCSp1FVU
	 9ddWJ9lDITFjq9eKGfZ8XgcPI1Gceue8QxkZpOu0JwKjN75XEWJg4tA2a8UNAkWZvu
	 d2ASsHkW3EY1IZ3rOpPzq31XPfEMQM756K5+/fSW612wkX78yv2eAZ66ejeZV4LlfY
	 gAu+RNJYW42KKsssq+PHsl1z2ZSd/eOK+QZCgtAc5FgOD8sjUj3miMaJcP2gtaD17q
	 8U+HAlTtH77+9KCSbzDnS36KQEJCJesVoZVR5wfQkL3btqSLgCjvtjIMAmDS1I+rUb
	 wf48OWQ3Lcqyg==
Date: Sat, 30 May 2026 19:19:36 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
	Ard Biesheuvel <ardb@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Liz Prucka <lizprucka@google.com>,
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jann Horn <jannh@google.com>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-sh@vger.kernel.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH v7 12/15] sh: Drop cache flush of the zero page at boot
Message-ID: <ahsOGMc7ys3H_oAt@kernel.org>
References: <20260529150150.1670604-17-ardb+git@google.com>
 <20260529150150.1670604-29-ardb+git@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529150150.1670604-29-ardb+git@google.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: hbocaoxt9xc8fgdxbt5agejm9cuyagdm
X-Rspamd-Queue-Id: BC3ABA0009
X-Rspam-User: 
X-HE-Tag: 1780157988-532449
X-HE-Meta: U2FsdGVkX1/lf3BjvEobfBlf3hr0fpqEqarrdLPtJVbpPmkL9hnOQiRn2Kl4KifCccBAry1AYv4geiDgewVEVcSSCde1r7f46xFLhW9HIcZqd/pEHPvg3gsLmqbeED0PJVu/802owIIWlbnHguy7kLHZV1CVcDs6lIqMK8brBVqSC6MS5uigsdHsTeNwTyhXtfru0V9/edmiDonfXZS5jabdOmztf+PLn9ChJKVjg86fq/9zSJZxgxcIFauGWQTAsZomN505G4yxpNRSzTY9pU8M2OYqbYz1bD8XoTl1hyTTndBdI3zeXvOfE5VxUZ76GZDVj1oWOJcikwuLSgz77FO7SBveHz8Gp2+s4c+UDNZZqlRQfg4r6zvLrq0xYN3oA3/IH9pfKDTXkE6gAtqLkyKXkc9HeiYZ7jrQRjQIacSSJ49p6VjqHwTTLnQYOioLlRAOk1vBw5I7GVD8L7HDlfo6ePNGZT7V04VJvjF8N9FXgMupm0l1spowqHVdVEC2GMEZkG+LV6HvGhEAU6oHlFmWtJftQDuIbpCrCOQgtImsXZJ8Vu7bLE02F0wTfBtaY/9vAUINYlqnwW7Y+B5SaBuhpJPKGW4M6koy+WJY6OVQj3JD9k7hfiJfgSWGffLjkXdzasgCZozp5bYBk6vkiEcCBXJe1sYO6nS2khDxDZnvJx71csNE2tKwduW9f+jwYmqDfRaYo8AnvWNrE1w1Ppq4fRZZTc4ABoGtVtRRcYBZgAfhX9lZFiFUxD5wonrr3SpXDQUgyaD0Uy2lv8jVtA6eXchSp4fI8hrEbL9pS12gbJRhf6HGHjjhNK2+UT0xj92QeWuyNdpKm2tDA6k9Gf06t6Fki6PP5ZNWz4jle0iP7rV7NEJGGnsPfUs/+DYI9ltcbXDsV77aIMwVLxoYX2dRggzvU1nLJSazvUdUQ+7jOwxngKA1tCHKqfhXerbR4CHttk7wD3kv/CcHK1m
 zLR3KpV1
 nhqdsh/rbE6oJx/qs6XFA93dYhUlogVjC68+/5qor5RUPr96kKmSqw+SG0AZgbqVfbyTkQG+5YZnEsJaJFFgGbl8mRpAPenFr/R/yfXmUpaAkpR+rqsv0TelcyLaHtW9tEHoia2r2c/p9hoCXk5qk9VLEkswgS4oeu19aew9R1v5/nq5ZKivh7wJjrKmcaT05n/Z9WkLOyyoSGHKx2OtxWAM7jDb9rP4ahrfUgu+srS2EYSXsAjSqZGNN4xszI3RIy63IB+PGcyrr3fGIjT/6w+dqhjNHyp7brF93l6hOQuV/F0Sn1hzaU6gVsfvyIFwIzNM08PEn2iwcTlQiohgXm6cwGHd2gvr3SzjJzlfCM9Ef8F49ZM3blZiZ4IHaiM65L94BiMMM0kjoJ38B3Kcjh+5j69rNBufftNH1z2ZX+oTX/OA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 05:02:03PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> SuperH performs cache maintenance on the zero page during boot,
> presumably because before commit
> 
>   6215d9f4470f ("arch, mm: consolidate empty_zero_page")
> 
> the zero page did double duty as a boot params region, and was cleared
> separately, as it was not part of BSS. The memset() in question was
> dropped by that commit, but the __flush_wback_region() call remained.
> 
> As empty_zero_page[] has been moved to BSS, it can be treated as any
> other BSS memory, and so the cache flush can be dropped.
> 
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Rich Felker <dalias@libc.org>
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/sh/mm/init.c | 3 ---
>  1 file changed, 3 deletions(-)

-- 
Sincerely yours,
Mike.

