Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F98CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0956B00AC; Wed, 24 Jun 2026 10:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1426B00AD; Wed, 24 Jun 2026 10:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2911E6B00AE; Wed, 24 Jun 2026 10:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E87B66B00AC
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:30:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70B6A1C5C17
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:30:23 +0000 (UTC)
X-FDA: 84915041526.17.38F10FD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6001440012
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:30:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=efQK7yFs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rP4xkJoS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="t/LGhA4g";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2JHYmjbG;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782311421;
	b=njYcPpkSj/vCwfUX0My9MjLSOEuN++k3nMGHQh9hxUtr9L5cDh+H5MqBy25Xa1O+DIz7Vm
	z5/pmXLiNapTlQa8UfKzK74aNfWL6RtBNj7UO+M/bFc9bPuiQ5zT7vwtnxxHives041a2e
	FBfiATIzhbkRNEaRBlPHtFhgrCtPLwg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782311421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bDUcBVoM9gSGROPcuY7Mn0vWKWX29qFwrzj5APjK3C4=;
	b=Ta9nKN0M86RbbUEgf0jPdcz3KcJ2k9uSq/3QmIJ8fO9e7EwtNpbOVaozfiPhOkTmgnaW86
	oRGRzs3gHNHVSJudOOMieQgawT28DpCC0dfCbBpgaiYft5rHG6hgOWKl2iQhsn9g7MTNE8
	P3GxuI1yA4uOatgzlETEWmKj7kp+ocA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=efQK7yFs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rP4xkJoS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="t/LGhA4g";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2JHYmjbG;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DEC246CFC4;
	Wed, 24 Jun 2026 14:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782311420; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bDUcBVoM9gSGROPcuY7Mn0vWKWX29qFwrzj5APjK3C4=;
	b=efQK7yFsHlv0OJKUB5g6Eo+12pf2yoHmSmIWcdCocEyKa8kHdrCfoRbZ/p3lkvKBSogepl
	cwpQHEidrTSCNPN/SCvdLuLMehwYyDnhDBI7ZR61SCscN7FeMI3hGMihOmVv+LWvRBniLo
	mXvRkJHu2+vv8Gw42IaTkmHDzacjCrU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782311420;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bDUcBVoM9gSGROPcuY7Mn0vWKWX29qFwrzj5APjK3C4=;
	b=rP4xkJoSxY9r9aIeGXiMSquCRH7xsGdnpKsMUrH3I90GuxwCsF8VB4KwOG2/Mk6AjjwxPB
	qNFxy1tGs3EYpYBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782311419; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bDUcBVoM9gSGROPcuY7Mn0vWKWX29qFwrzj5APjK3C4=;
	b=t/LGhA4g85m5EzELTXWNcw+vRn0krzoE+Sh7Hx+W7i4/N9tJzalGPn1qxCsZGVEVqFlOAZ
	R5RKBiYAYP2hGYlp4QEYx1yi8XDS6gZQLE5sE77U6uPRaMzmE6rv6ydkCMV6HK8Gq72fAr
	hof8usLxlL6hghkRI4xoVfQYjdPuFxw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782311419;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bDUcBVoM9gSGROPcuY7Mn0vWKWX29qFwrzj5APjK3C4=;
	b=2JHYmjbGybxWeS9J4ua47txjjZzHXCHOYKV4qmnjgGBhqobHKPpCRVN6QU4bKoPjTP4ARR
	lVZzDXptms4noLBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12326779A8;
	Wed, 24 Jun 2026 14:30:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rUgUAfrpO2o5RQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 24 Jun 2026 14:30:18 +0000
Date: Wed, 24 Jun 2026 15:30:16 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang@linux.dev>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, 
	bpf@vger.kernel.org
Subject: Re: [PATCH for-next v3 4/9] mm/slab: use call_rcu() in unknown
 context if irqs are enabled
Message-ID: <ajvpq2Ay-nRH7s-X@pedro-suse>
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-4-70a54f3775bb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615-kfree_rcu_nolock-v3-4-70a54f3775bb@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: 9qm7h6gqmswh6au3fkqwmptpqmndwig6
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6001440012
X-HE-Tag: 1782311421-142870
X-HE-Meta: U2FsdGVkX1/RhbsoLBS3XalKcYdTFGf6YDLh32cGVIov9z5cQRbKE799bBUA+ucBJNGuGkEsMvLKQPg5xDkAEO88B2BL3xAvNoEAWn32bfgI/SJvJAuEjB4Bvd6hks7OQ2EcmFCjuttr6IgBLBeKcq2YSoMpv3GLgdwXGxQ2KvVnYz1HhLqFK8ltqwbwIVl2sZzWD5gdFL/Q0zbZpGb7tuizgKeDbCLJfrl+UEd0PYyHkJJ6zJoPkGOFhorexFgcIucSXdGTL3a4hqib1OjnK1DB1a3fhMAclzDsVgFufmJAwZyk1dJDZ7wTphU1Gxx50N8DVlhPC7whB+FUT1gT5+omQ1SVh6YxSW7eVMyXZ3o9BzYTEX8M27Mx5DCgs3qeRbsA96dUG03kxL5nMNUSYba0O+gcPOX13Ko7pMPwbFnq6VhRiFMu9IAS7no1RFuTQwrPNhxRz5u1dDvL5FvlibZ8okeLAL3ER1AvXwnc7PqG1/G+kU3ftZ/twlXNnC/VJjPPNWX6P4yxjgMJUsJe7N7oyaamCGE24vYKB3o5Eov/8bI/NeXogs2sc5Z0xha7VBw4eU3xMRd8IRcubN8KXbJJWU8eyY4hvdPVFBY4TlgDwSKzQ9DZk03z8/kelVnEXfJK4d/ZZA3ywbmc9+M3FwAyhY4vM98N96JFCRN0c3ERJYc535qvovrCQ4zUEdF7G771nlpzDpmZWjEpehuAnX4siZt8y2gV0OCsguZ34sU/qKZ+2c3kyphNhaOejFBjwUEkTe93KfA/EX6Ye9yEFQun/mtbMlZjKDoNUYV3+PVYVq4tUi/wAfaNLl3w+E6P8FtfhR5luyf5FHYLBr3JG9rlwJ06ePg5WJWWwtS9L4bQEaQ5Y+FFcGrRPe+dryhF08z0WNzWgHtYI43A+7sxPm6u4rChwKwLEq59FSwjYOCdmgigAEMJdRLtUbKDpMeSca7FZTGYXm5HIHgWkL0
 TZqrtAXS
 UOrp4nOxWxG59VTs79MHyUVc2NRCSja+r4RHYU1FDeLmZFhhltg4pQTHp6k5oCec2ylGMCc4LJWLED4QlPIpfqKOVcpPeqa2M3jKZyd1E5vgfockkMvdDD6ZXiddZQYhOJb2pSwmuzt+9g0RABAk2wGpt7hwVIm6/O4+Tcfz0oicYna8f86rJSM+lc5LsOqZ2VispzUNbN3XrSD8LI3NOxMfpNU96Gdhx3N0uTu4GEmBkF+WIVGG47Uz8dqjQWGz65B2Uo6dkDwmakUfx+1oF/AWNtOH5WqK7ua/0q7SVwtSQRt2G8klUDeEjLNl9i9sWGPjFYZFe7p3hl+R6nLFFYm2N7lBuleouj1ds3z9skeN/SwwRtBzTvKw7CewMyGE7iaS0U9dND+LRb7XrNY8PfN3EyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 08:05:58PM +0900, Harry Yoo (Oracle) wrote:
> call_rcu() disables IRQs with local_irq_save() to protect its per-cpu
> data structures. Therefore, if IRQs are not disabled, they cannot be
> corrupted by reentrance into call_rcu(). So fall back to the deferred
> path only when !allow_spin && irqs_disabled().
> 
> The RCU subsystem does not guarantee this contractually, and this
> optimization relies on RCU's implementation details. Ideally, it should
> be removed once call_rcu_nolock() is supported by the RCU subsystem.
> 
> Link: https://lore.kernel.org/linux-mm/CAADnVQKRVD5ZSnEKbZZU7w86gHbGHUug2pvzpgZTngNS+fg4rw@mail.gmail.com
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
>  mm/slub.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index b0d38d515386..6a3552b70683 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6158,8 +6158,8 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
>  	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
>  		rcu_sheaf = NULL;
>  	} else {
> -		if (unlikely(!allow_spin)) {
> -			/* call_rcu() cannot be called in an unknown context */
> +		/* call_rcu() disables IRQs to protect percpu data structures */
> +		if (unlikely(!allow_spin && irqs_disabled())) {

Perhaps this could be more neatly exposed by RCU? something like
maybe_in_call_rcu(). Also, it's a bit odd that you're introducing code and
then subsequently patching over it with an improvement. Maybe this could be
squashed into patch 3?

>  			rcu_sheaf->size--;
>  			local_unlock(&s->cpu_sheaves->lock);
>  			goto fail;
> 
> -- 
> 2.53.0
> 

-- 
Pedro

