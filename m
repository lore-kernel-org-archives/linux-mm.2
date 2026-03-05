Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67EA6F30946
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22436B0088; Thu,  5 Mar 2026 06:33:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0B26B0089; Thu,  5 Mar 2026 06:33:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB18D6B008A; Thu,  5 Mar 2026 06:33:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9CFC6B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:33:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44843593B6
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:33:28 +0000 (UTC)
X-FDA: 84511798896.23.7E14F41
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 079A51A0002
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:33:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Fwhk4V8K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=byBhOEv5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Fwhk4V8K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=byBhOEv5;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772710406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kc0RqdmKxn0gydjGXnITat2Rxw6V17rHtDnvEkqrOvY=;
	b=SNA666+oeYr+KpJq5pteO+OUoFhb2Ow/3SicSZbVOGdBNJ8EL2axGr25PqThMOYXDZNwz1
	0TY74xdWeOP8xDYR/7Sr9hPi35WxljOjkcGOjiaHdwGeOvAHD8L2d4SG4vohEuA41udI3P
	JuWwCRfwB5ptwJJBihAwzqy3wM+7myM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Fwhk4V8K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=byBhOEv5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Fwhk4V8K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=byBhOEv5;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772710406; a=rsa-sha256;
	cv=none;
	b=6KFCpgPX77tArcX3VFUJEkWeHwC4f7JsRXF/tlXsTAAlYwXCCcCya/5HShZGdvMWPprxk5
	OWk17IHdhunJ/Av2T0ZpK7vg8bY2qxGTzrHQdvfennYllTPVOT/ItDd7k9QyoMw9LgeA6R
	NziFLs9/DWuqYPkQYwVid6DKdL4smm0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 64EDF3F802;
	Thu,  5 Mar 2026 11:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772710404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kc0RqdmKxn0gydjGXnITat2Rxw6V17rHtDnvEkqrOvY=;
	b=Fwhk4V8KuYnji69vfsOj5m+Ch6qvSgSwuTPWCkQRh0Rb86t3fjWZeqwAOVy9bA/C2hxNfi
	Cquftrfl7aAW6PJUOSgRdb33z9lQEV7aHWB/zmA3nl2JW+6fgYrXbHjYTht1Qe6o5vYCbo
	3n/1TAuiGgYK5Jy0rHIY0mEg9/1Fpj8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772710404;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kc0RqdmKxn0gydjGXnITat2Rxw6V17rHtDnvEkqrOvY=;
	b=byBhOEv5doKCY5LcpskjsnGpputQ1yzvLeHyRnT84T2Az44B6smCwP6Ipoe46zM85jxbnP
	3ZDKbg7V2jHeTeDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772710404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kc0RqdmKxn0gydjGXnITat2Rxw6V17rHtDnvEkqrOvY=;
	b=Fwhk4V8KuYnji69vfsOj5m+Ch6qvSgSwuTPWCkQRh0Rb86t3fjWZeqwAOVy9bA/C2hxNfi
	Cquftrfl7aAW6PJUOSgRdb33z9lQEV7aHWB/zmA3nl2JW+6fgYrXbHjYTht1Qe6o5vYCbo
	3n/1TAuiGgYK5Jy0rHIY0mEg9/1Fpj8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772710404;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kc0RqdmKxn0gydjGXnITat2Rxw6V17rHtDnvEkqrOvY=;
	b=byBhOEv5doKCY5LcpskjsnGpputQ1yzvLeHyRnT84T2Az44B6smCwP6Ipoe46zM85jxbnP
	3ZDKbg7V2jHeTeDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9487F3EA68;
	Thu,  5 Mar 2026 11:33:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id b//+IANqqWmONQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 05 Mar 2026 11:33:23 +0000
Date: Thu, 5 Mar 2026 11:33:21 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org, 
	Mateusz Guzik <mjguzik@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Gabriel Krisman Bertazi <krisman@suse.de>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dennis Zhou <dennis@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Hao Li <hao.li@linux.dev>, 
	Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM/BPF TOPIC] Ways to mitigate limitations of percpu memory
 allocator
Message-ID: <ji4ddtoo7mebygmytprcp5kpnu5y2ddthk5zhacshods37xij2@fs2sizuagdvz>
References: <aaE8rkGzxlB6wCTt@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaE8rkGzxlB6wCTt@hyeyoo>
X-Rspamd-Action: no action
X-Stat-Signature: 8ebfarbx686turahos6cqnd6i6x7rqaz
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 079A51A0002
X-HE-Tag: 1772710405-667334
X-HE-Meta: U2FsdGVkX188lSz/ozZoUEP8p6qGpM2SptdIXNLC1k+/xzz+oYaRJ+2AjhFEYskgY8Fm1AwJgLwt1aYqS1We4HUA9z8pfSG8GhE5naMHwxwFrR7AKucyw2chnRbD3lpJPdz9H43DVVdDaoYaYEtPqelzY6cANXXsTa4sVR/Lr5k+GQY8fPMbFzj7s7SMxmlI4tit5v2Ztgeqx9kLrAYL3OF4rNWDMzx0U03rY1nAqGAwBftSWAu+ZcZtrz3Jd5OLVYsrqZqsr9iPWC1evDFrGKZndP6M3MwbUHlX6IIMy7fS8Gpr+Wj169RbmmTpydmXvnaDz6LFiUMCysUgbakw16U8VvMaspH4hnXaSSHxJlZiOpXdhm5Rruii6X9Ax5QzbwOfzwuuZ7A/fKk4CrrZ2LKErB+KwCE/Juvuh65rSvSPONpFw/qmkUb4kMZDesOjnLsNQcWr815IH7IE2dD+Ih2vbTygGUk7iYcSZ56nUibWvOwDPLMZMNgRYEURQG0IMCudt86xSDrzIo1EGsy7fwzMtPeya/2nfg5fm2KE3amDAd9imqQuL2RaX/N46it2Pglz2Kgeg6b3Mhhk0YNQPNBN2gq9+HrNdPfnXLEhFwz0AEhJAhERjCDWHeS4Nu6zKLvOlnjqjA0G0J/ol6cdOuGbeql7PI7124OxkqMlH64pN8GZJKmsqzZe171OQ6yziOKlJgke3ha+WFUusRL6ClPnipmm8cVEFYb1jKHMKR1jsHATreamcyeYM60oPIBWbfYfN/eCe8vsfH8Ntd1eaBOu89yrQII4rt1Ww3wy2ULGFhc+O9+VBkG4lXReWq/wQJic5R2jV+0Vx0Yym01oKRwqfODgXL0UcDGtwtz/R39AiixbHUSM0ib9CzNBi+tWjjv0tOyGnUn3oUg9BlP5Cg5oRSjeAY3EoNBav7JB3UwkhOiJk/4wPFushA90Rfi3irY7sQMsh/9nVTUptyn
 HrxkpaKJ
 FNQbqhW4VZucHZp3gscmsYtS32ldBmC/MNtkqDfbVvHjjYdDwEnpnRYY2RGV02o9gp1TCzFHGhSKfxa16ShkAYpf3fCwnQBNOW3O1JU83B+Z+42AOqR8dfZM/7oMEkuE/TY5JbjJtwSoJqNZdv5mS/ch8oBNLuv2ciy6A+OkV0kM/Nw1J45hZmxY13Q0jwYE6Vscc34tX6fnUzItNBnAegUDa8Se55iuplPILh1mYsF9rAf6ClzGUDFkFPyJkhHfLFG1DlnOarQEi8dgEsg+dJw6GUrCXL7DOu+HT3pfNw2TyZz8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 03:41:50PM +0900, Harry Yoo wrote:
> Hi folks, I'd like to discuss ways to mitigate limitations of
> percpu memory allocator. 
> 
> While the percpu memory allocator has served its role well,
> it has a few problems: 1) its global lock contention, and
> 2) lack of features to avoid high initialization cost of percpu memory.
> 
> Global lock contention
> =======================
> 
> Percpu allocator has a global lock when allocating or freeing memory.
> Of course, caching percpu memory is not always worth it, because
> it would meaningfully increase memory usage.
> 
> However, some users (e.g., fork+exec, tc filter) suffer from
> the lock contention when many CPUs allocate / free percpu memory
> concurrently.
> 
> That said, we need a way to cache percpu memory per cpu, in a selective
> way. As an opt-in approach, Mateusz Guzik proposed [1] keeping percpu
> memory in slab objects and letting slab cache them per cpu,
> with slab ctor+dtor pair: allocate percpu memory and
> associate it with slab object in constructor, and free it when
> deallocating slabs (with resurrecting slab destructor feature).
> 
> This only works when percpu memory is associated with slab objects.
> I would like to hear if anybody thinks it's still worth redesigning
> percpu memory allocator for better scalability.

I think this (make alloc_percpu actually scale) is the obvious suggestion.
Everything else is just papering over the cracks.

> Slab constructor + destructor Pair
> ----------------------------------
> 
> Percpu allocator doesn't distinguish types of objects
> unlike slab and it doesn't support constructors that could avoid
> re-initializing them on every allocation.
> One solution to this is using slab ctor+dtor pair; as long as a certain
> state is preserved on free (e.g. sum of percpu counter is zero),
> initialization needs to be done only once on construction.

As I said way back when, making an object permanently accessible 
a-la TYPESAFE_BY_RCU) is screwey and messes with the object lifetime
too much. Not to mention the locking problems that we discussed back-and-forth.

-- 
Pedro

