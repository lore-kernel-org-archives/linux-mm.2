Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF45AC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9056B00A4; Tue, 11 Aug 2026 12:49:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80966B00A6; Tue, 11 Aug 2026 12:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4B956B00A7; Tue, 11 Aug 2026 12:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8783B6B00A4
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D6D7A0468
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:49:08 +0000 (UTC)
X-FDA: 85089573576.08.DE2A8F0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id BA992A0013
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:49:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BLF53B8G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YFpGXfkV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="S55VMP/6";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="g/x7OqB8";
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786466946;
	b=TtuAGYTaYKN1i6ByNk3/JeFb8PvB/uhsT6Vdc6MbPQyGax9oxs5ficRt931FUfxM88+8Da
	J7WEvkh8QjFO8+zGQv7ZZv5/AhcJyIe7VjQk4AlbOvNLQrCO/i43mW46w1rsCZnA7BeQeS
	d2f4krXJCofuJcyvEPhyZhuoo5EPMQE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BLF53B8G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YFpGXfkV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="S55VMP/6";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="g/x7OqB8";
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786466946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eVdcMKFMo3zBANZOAfr9VKuTXRXf87k32CNOefn7rf4=;
	b=aKALN+ahkJfsd6bKQ8Oh7UtBF4v6DBTPcVNDhd7TW2iogzCgN8Rhpzz98F0xQ+tOerl55o
	S2dDUHSmbbgp9sQe5Z7X4ylbQjX7bjkPm1s9zSXqpprRZFutD8GwiBfFP5YXmfXZdkFPmH
	/qmMlYfTeWO1sz8cMq3JrNafHTv0pYc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 070BB81D9E;
	Tue, 11 Aug 2026 16:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786466940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eVdcMKFMo3zBANZOAfr9VKuTXRXf87k32CNOefn7rf4=;
	b=BLF53B8Gi/y6LskRKte3f8ehCtY7Yn/tBN0L5w9gN+3HLVZcyimTjCdi5RtDabewloGL9d
	Qy0AQp1NkTwQZvfSe1y2rlG7bs6PpaKIRuGe6CfNdiyvZ4be2OsTldSXsWKXiujRC7CcLv
	VvJDdtdNpcGibfNbWLHqkcjGFuK885s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786466940;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eVdcMKFMo3zBANZOAfr9VKuTXRXf87k32CNOefn7rf4=;
	b=YFpGXfkVeBf0uR7F6IXAEoY+PW4FfZS9TyIPvCpsVHXiMZENCBXcuQX22a1ltwoCukhNLc
	W4CrdhBlD8LSAIAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786466936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eVdcMKFMo3zBANZOAfr9VKuTXRXf87k32CNOefn7rf4=;
	b=S55VMP/6MnLmmQsBto8EFwKEzCXOH9Qw1fdXqK9OoOnMdm+M4bP+DLDjf1QAhsNkXT09ZA
	yZ0GyvOObRdx8pEFe6AbStECsNI55RTSkfOCY6u7tv4oMcW1LCTh4INvrDxP9gpI1GqqPb
	cMAJkmaFZNhgXnjtCx7PxEp/0hZTUc0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786466936;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eVdcMKFMo3zBANZOAfr9VKuTXRXf87k32CNOefn7rf4=;
	b=g/x7OqB8xWZY1K3Bb73cyJfjnP82FSu2D0Q8H58g/uIq82Vqvj8kmqMr/235twPAt2qves
	AhmOP1RVlII3rGCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D852779B2;
	Tue, 11 Aug 2026 16:48:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bql5E3ZSe2pxLQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 11 Aug 2026 16:48:54 +0000
Date: Tue, 11 Aug 2026 17:48:52 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Breno Leitao <leitao@debian.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/3] mm, swap: ratelimit bad swap entry reports in
 get_swap_device()
Message-ID: <antOPhsllDia-UVh@pedro-suse>
References: <20260810-swap-v1-0-375ef0767206@debian.org>
 <20260810-swap-v1-1-375ef0767206@debian.org>
 <a2e220de-19d4-4177-9703-0e8e5c57f269@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2e220de-19d4-4177-9703-0e8e5c57f269@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: BA992A0013
X-Rspam-User: 
X-Stat-Signature: 68ifdtx64cs8yb4ez7gyxo789w733sej
X-Rspamd-Server: rspam06
X-HE-Tag: 1786466945-676300
X-HE-Meta: U2FsdGVkX1/jB8fKNNjOM5WbZRSbBSAd2PT23+VHYva2ILA2XfIq9HFnc4QuiKgg+tt29hUxjihVsoFSfOhz0vVSebARv3RbGBlxh2dJkwyRinTgETn5nu0M+YF6tPWGuhbyDZoSw2FFvm665FW4q2qpQHbNMorW7uCk/3pxJ+8EraGEElNJFmQ5IFndUCQdSP3rXB5+Rh29b0WoNI4G6idAgI0g1AW+5zGPJ1iDZ7+4BhtVfLrbBG+nCiVJU5Q6mwsRnA23YwPKGYt4h3UPguehZrSx2qgOZHjHDp9Ylt+QvdGjHPtO/OtF6CZKI+G4gUJvXp98JAT2cfvXVHz9lYPMAy7JZGa+cyCgmjGT3l/htEJlr68XQ0C1ELkv972jUAi+By4zGypAgn++visH5zDJ0I5/4NjHDoMld/CBDfY/JGUYVmddziX3bEjaDdYFxeZR8H0D0/vrOeBwN/3YBqABwp29jvPVFUEwTd+jURtsHYJE15+1bVjPKtIzKiWFOR+N9OCHmuHRfW4wx421ABlqOi7YjE44pfNnEei+EbAN17WoH/QUHeiasYSHW1WrPjzLm2bbBzn+i7Px5HEM0fZC9fzoO8YKrQLFmUEqQyPDBSiBNyBgs8JqiLfMzavOymipmrdPAc8ReHTi8LkzTgxjN8C/71fdgJO7xak3wpLXat886qnNkgZuTFzgXM0J+GnqHaMxmmifCHVyiCYEruPQtlzxRCM1jTrKG8gaNQC0PCxhJ+AzO1qkfHoKv1sWuHzL4yiT2brqqFPzngZMlwCLLOZLFQcEeZfinufHJcWCv+2MMz8AiQ7ekVOwsaewSjLCxllxI6MkhSRn43Jgz7zf2jJLURRAZySs9artZjq0QzyQvsUhJSw3YqWSdo0UL5NNjQvJmNzDYvQvnBboHIqB6EGLfPiN4zMhF65smp13QHiEV92d+dlJy/3i9WBP8bpFvoWQZVWWL+kPhC0
 C8DP1yLM
 g7NnVhdAPSRU+N5Jm8E69XcCd3IZlBBmj29GohEnztMn3CgRsP9apOKwGtB9XYJYLOI/ZVobBDeCwG2HtrJaGlilFG9ZLtp/GOuLfH/folhY8Zg9Xfu70kcxSMfLRA4R3OZK5UDgg+0Rxx66+Z564wUeCDn8FSIOJbP6LSsgvo5qmqkUe3DlaiKejdA2VOan3V7C//zuXhYQb8V3XDt1Ju9waWGluaiLgKx6FsYZrhQeNvQ1+B2O87oqT/mpqXX73wHa2ZCHnAl3VA/689QmbcVOERBaDwIEI2R9ek5J6XFWUHJD/C1sg/P/5DFv/OfBkJBQzophGohtayFa65tbmHsOdN5st5Ovf/3XhjQBrq+uJk3rgjCi+Lil8m/90tJgQnMkQOYEk9ZgFBUh2c0xS1g3suA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 05:33:54PM +0200, David Hildenbrand (Arm) wrote:
> On 8/10/26 18:26, Breno Leitao wrote:
> > A corrupt page table hands the same bogus entry to get_swap_device() on
> > every access to the mapping, and every rejection is logged. One machine
> > logged 6185620 copies of the same line in a few hours.
> > 
> > Rate limit both prints.
> > 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  mm/swapfile.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 4d4e3e3059f6b..9ab11dc24e4f1 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1899,11 +1899,11 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
> >  
> >  	return si;
> >  bad_nofile:
> > -	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
> > +	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
> >  out:
> >  	return NULL;
> >  put_out:
> > -	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
> > +	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
> >  	percpu_ref_put(&si->users);
> >  	return NULL;
> >  }
> > 
> 
> In print_bad_page_map() we use something more advanced
> (is_bad_page_map_ratelimited): essentially a burst of 60 followed by 1minute of
> silence.

Is it more advanced? It just looks like a handcoded version of __ratelimit.

... I hate it now. I'll send a patch I guess.
 
> Couldn't some of the stuff you drop here (different entries) be similarly valuable?

I think we generally do a terribly lousy job reporting these kinds of
failures. Would be awesome to log this elsewhere, or possibly send
something like a SIGBUS to the faulting process, for instance.

(and this kind of stuff should very much be handleable by userspace,
otherwise programs can drop data without even finding out about it)


-- 
Pedro

