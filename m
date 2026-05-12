Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F058CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2726B0092; Tue, 12 May 2026 03:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8934A6B0093; Tue, 12 May 2026 03:39:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781DA6B0096; Tue, 12 May 2026 03:39:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 680696B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:39:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C0C0C1ABD
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:39:06 +0000 (UTC)
X-FDA: 84757966692.26.E84980D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6EB7C180005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:39:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CJC94ErJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9CHJqyUE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CJC94ErJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9CHJqyUE;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778571543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YazKQQ4f7Xtj2bwB4n8Hki+UhzT6K854g9SreOa59BY=;
	b=Lf7QEzFzG7/lHz1aHCA9ARW6pWZRAtwMfWwqyXvA15IgVV6NPfEvVaZ8D8D76fYJjoGJcE
	LdslScXdbvcHYUrB/SphfHgQVphq+1jp/XJ2DIxttg6krNizsqUwH1KABDhUK5YrvkgusR
	RlXL5X4fDmWrmZoDVo0ke0+REeDv4Ow=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778571543; a=rsa-sha256;
	cv=none;
	b=bTQEhrfyone/XJnvaZztf4hBjlnZrynvEEW/Dp18OBCTQFwgzNfV9C/s1SfdMmHsRC0ovI
	a0KUPyGnSY1alv/jQ43eCurJ0VsAJ1gNqcUda7Afp1MAtgJAv9zxdv171+FBVeF8CdpnCQ
	T63SRTaFUP7eJl/3C+EMm/5BUXfWFhY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CJC94ErJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9CHJqyUE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CJC94ErJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9CHJqyUE;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ACA7775CFE;
	Tue, 12 May 2026 07:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778571541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YazKQQ4f7Xtj2bwB4n8Hki+UhzT6K854g9SreOa59BY=;
	b=CJC94ErJRYdTvyGm5j04VDtMDONCAoR7qI24x8ISmaPjyEj4T9ZuNFe9iyYdrXwuu613nn
	SuEIbfJpJql9t/ox88nKZ5lG0D054ESqPFZQr40EMOU7cIkTgnwwEjE0jDRvJVVjKt+z20
	gDC5ineRr57kJ5e7fYNUKPJyf/v4Jio=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778571541;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YazKQQ4f7Xtj2bwB4n8Hki+UhzT6K854g9SreOa59BY=;
	b=9CHJqyUEer6dkjksYo9fhBIUf959UuzIQqkso3tZSxL9EzxJjqSfYaumtLZihgV3Ov65GD
	pG/jF8BAk/Hf1mDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778571541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YazKQQ4f7Xtj2bwB4n8Hki+UhzT6K854g9SreOa59BY=;
	b=CJC94ErJRYdTvyGm5j04VDtMDONCAoR7qI24x8ISmaPjyEj4T9ZuNFe9iyYdrXwuu613nn
	SuEIbfJpJql9t/ox88nKZ5lG0D054ESqPFZQr40EMOU7cIkTgnwwEjE0jDRvJVVjKt+z20
	gDC5ineRr57kJ5e7fYNUKPJyf/v4Jio=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778571541;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YazKQQ4f7Xtj2bwB4n8Hki+UhzT6K854g9SreOa59BY=;
	b=9CHJqyUEer6dkjksYo9fhBIUf959UuzIQqkso3tZSxL9EzxJjqSfYaumtLZihgV3Ov65GD
	pG/jF8BAk/Hf1mDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A1C61593A9;
	Tue, 12 May 2026 07:39:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id A7F2JxXZAmr/SQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 12 May 2026 07:39:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4A3C4A093D; Tue, 12 May 2026 09:38:53 +0200 (CEST)
Date: Tue, 12 May 2026 09:38:53 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jan Kara <jack@suse.cz>, Vishal Moola <vishal.moola@gmail.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/filemap: fix page_cache_prev_miss() when no hole is
 found
Message-ID: <oshbymv7qwgi6ffxbglw7r7pzrlqmhs3tuwe65gj3752u3nepx@65svx4bkaya2>
References: <20260510-prev_miss_fix-v1-1-755bb123145a@columbia.edu>
 <agHPIcZHHyzBjcGN@fedora>
 <s6hnqm4bbi5j2ergudihydboj3uw7gsu7te4dfmjgv2qeosfbd@yvhp5oy3r3b6>
 <5280b6f9-e6d7-4854-bbdc-ed5349a478ed@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5280b6f9-e6d7-4854-bbdc-ed5349a478ed@columbia.edu>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6EB7C180005
X-Stat-Signature: u5igs9nw3q94abj658o3dn9ceib7uh79
X-Rspam-User: 
X-HE-Tag: 1778571543-617859
X-HE-Meta: U2FsdGVkX18t1G+j8RTXh4UGsHDOUPToszvNVJRs3lrpuJ9NqeyM8TEa6QUnw9FfCnX/APAfgyWjoi29ivsEcgFvFVfA24Rvf99v14E5TLehi3K9OlCpAb3OWdxz/Kps0Ov28unFwQbWwCz+9JYtKh5fU3QEyAxNeFabTncSYrqkunVsFhfAaWFs5Zll1nO2jz0yLhyC7lxa/r5UpTPWZUXPQqAxbdfk6qsR891bVq6q4THRMU13U61Pg9ctxOhIDy7D8GMMfdtYbRFVVE3oMQP10yZK05o+J5U35/xlSUAzcIwHd/Fr/7F5NdTTwQLCz8W5N6KoTgY1DIw6MDwA18cRNDX7MTkH/6RWthW8N0XL4Yp3BVnfcwD6hf62qzZkIUSRpx/z40gGr+RiLfBZtDzYzfPjJAe724FQVd2grLSPFViiiyWx7FbVjSR07dCZdtCp8My2rHfqO7EDN/nMNWwrUc0HDhnGGNpXESYXc6O4rUyqA9Q6HLxGQvgXV7v25s+EsaKuBFGZ1dv5HNi+S5K49BK8Z1M9ugwEfLzJsv/RenDsdUbLpTkBbTZDRCGZelkUX3bO8QsKADdi9wk/OW0mogMumsaLu2SXPeQkb/fb4xCB0u9rN7trqsPKiPUq2iB1ELNKRf/AAKJyba49MdJxEcb1RNjUCFRQ/RIG0WlMa/SMpnyU8hOpX/QXNizeAOhlqfnJF3mM4YRPItwer17BgkEyJk+3AlE7dCrqVfz2Z+AD4hBvofFY6NiYqxfTHqFQbbid2tMN4EY7tYMlQ4EbiBBrZYTU8GQUr8nghr4Appt4jCkbe3Q8Vsp8lpKMXKX393AbFfEHrqLkmbdJIxwJAqtaDdJ5NBAK2vi9rJ4Dzwmf7D+E7LCujEbdhtCVGd+p5IqcLSEbHILL0Pr4iy+PtlkCOKwSiiChD/dgKQDoVCOqKheX0xTt2IGCXF//a26NIImXMwyqaVKeRhK
 6esJVskq
 nusaU7U1pdqru8lMIg4v1CqYjWiiBADgdTMVKiPujOZikfS8bjYFuwBw0cHlLowpbHw+7OGwVFJp27U5cj5Ab/NXK4ufBk6Ajp3bq8C9jEFbC5PKglkleyfvWXnoEofdwOtu3KomRWO6EVQGLXj9xGiz+VG95PxHCDmn56IubVAT0mVGwik3X0dzv/VxOILGDMG3of8HVcq6RADbnt+K/f47+bZlt6x8Cp+8AUNxXGXmrSiLbdr6tT2xJeAJuc4Yb9FY+yV9D9eUUhQGznHCwqLbsb4a1CIIpVnrO9zO8ZhDwyv5wzsrAf/tNp3H1KOznqRU9q6FqvxZR7hKOoRXN+8GZpu4UP2mb9ag7CXuToy61RSrGeKufJCxmhh6BH8D9+NWnIZU+jnTCE4L+Cph7yM/JhJ95mSPXrP8vEeJtp+5aBGGuzPzMufZVPVWg0fjuPOAKcrYpOaapY0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 11-05-26 14:15:41, Tal Zussman wrote:
> On 5/11/26 12:26 PM, Jan Kara wrote:
> > On Mon 11-05-26 13:44:17, Vishal Moola wrote:
> >> On Sun, May 10, 2026 at 05:54:17PM -0400, Tal Zussman wrote:
> >> > page_cache_prev_miss() is documented to return a value outside the
> >> > searched range when no gap is found. However, the no-gap-found path
> >> > returns xas.xa_index, which after a successful loop is the first index
> >> > in the range. As such, that index is misreported as a gap.
> >> > 
> >> > The sole caller, page_cache_sync_ra(), uses the return value to estimate
> >> > the cached run preceding a sequential read. In some cases, the buggy
> >> > return value can undercount the contiguous range by one, shrinking the
> >> > readahead window or pushing borderline requests into the
> >> > small-random-read branch.
> >> > 
> >> > Mirror the fix in commit bbcaee20e03e ("readahead: fix return value of
> >> > page_cache_next_miss() when no hole is found"): preserve max_scan in a
> >> > separate variable across the loop and return `index - max_scan` from the
> >> > no-gap-found path.
> >> 
> >> IMO, this way of fixing it hurts the readability. I'd prefer something
> >> similar to the fix in the original commit. Or...
> >> 
> >> > -	while (max_scan--) {
> >> > +	while (nr--) {
> >> >  		void *entry = xas_prev(&xas);
> >> >  		if (!entry || xa_is_value(entry))
> >> > -			break;
> >> > +			return xas.xa_index;
> >> >  		if (xas.xa_index == ULONG_MAX)
> >> > -			break;
> >> > +			return ULONG_MAX;
> >> >  	}
> >> 
> >> If I understand this correctly, couldn't we just do something like:
> >> if (!max_scan)
> >> 	return xas.xa_index - 1;
> > 
> > I think the easiest to understand would be to do the above two explicit
> > returns instead of 'break' and change below to:
> > 
> > 	/* Return start of the range - 1 when no hole is found */
> > 	return xas.xa_index - 1;
> 
> I can do that, but I think it should be consistent with
> page_cache_next_miss(), which does index + max_scan. If the xas.xa_index
> approach is preferred, I'll change it in both functions, and also get rid of
> nr.
> 
> The nice part of 'index - max_scan' is that the kdoc describes the range in
> terms of that already.

Frankly, whatever you pick :) I'm fine also with the patch as you've
originally written it. I was mostly suggesting this as a variant that also
looks sensible to me and maybe it would look better for Vishal.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

