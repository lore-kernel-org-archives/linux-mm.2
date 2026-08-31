Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8D83C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 19:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B52176B0088; Mon, 31 Aug 2026 15:56:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B032C6B008A; Mon, 31 Aug 2026 15:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A185A6B008C; Mon, 31 Aug 2026 15:56:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 830FA6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:56:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EA32120226
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:56:01 +0000 (UTC)
X-FDA: 85162620522.01.C87DA35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6744380006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:55:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oHq6PIHi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788206159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9/xutxa0yVC5oXqjxcXznHsaJxpAP0rLurk1SO8VpY=;
	b=4DtZiNQsmL18XijqOww5cGGvO/W/kAsjQpBEf9HTwfJnVW/SRY5v9Ckgok8qtMUiy1L7/j
	EjBG3QurXO41ptmtHTMCPMELiqm6H0l0BkQM63QqaUgOIpEHdZqltL2gpeW2ebZmHyiJS7
	g37U21QTcAYDfkNoFZRo1Uy2lYGbk3E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788206159;
	b=3JJzoEIcRnL1kCuMZKxaYzYUYD75gFuNujrtTV167UmjML4xH257kPghEMdyzB4Y1e3LLo
	fcznsJXr5/nfw1e6o3Y++yYCsrV24YiRSwbUnE70XfXxyhDCofZ3jbI8O/kghzPU4jtXVH
	kAOWqbAAfJspfVdL2oUwypqi1Z6vSWU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oHq6PIHi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C800640189;
	Mon, 31 Aug 2026 19:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE961F000E9;
	Mon, 31 Aug 2026 19:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788206157;
	bh=Y9/xutxa0yVC5oXqjxcXznHsaJxpAP0rLurk1SO8VpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oHq6PIHiDubRuBSKmIQs2QbnhopS/6egB71tJJg68HkwzmP3mpjSk5O5/HwT+kms+
	 widEfcMi5WrCNRwcpaZR0lLNh96xakeA89h5FwnIsfFKwafGAywUtrpzI5BUWpOrqu
	 y/OJs+xhGzcByUHjTC6pMwzpdWSQeSZcBZ9C5CBOh0CukLzbdOzJWTWnBIMimIS2sn
	 IkKjDbtSzceuVaf3Y0lqHH2obcto1Y0cF+3Rz5RyDE06QQuPpItiPa+Crnz0y0YPi/
	 JiS6VIxNfKXKMQcdKulKBmWa7UZTYqh/WnlXznd4OFpBoz7JNbojB7Kx6DcJRwuZxG
	 wyerF3pj1kEOQ==
Date: Mon, 31 Aug 2026 20:55:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Andi Kleen <ak@kernel.org>, 
	akpm@linux-foundation.org, liam@infradead.org, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RCU safety for vma maple tree walks
Message-ID: <apXaTN6o5YaEO8FR@lucifer>
References: <20260831143511.1133029-1-ak@kernel.org>
 <apWUsc-a6k1YkuMv@pedro-suse>
 <apXXgimKxgJl57qo@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apXXgimKxgJl57qo@firstfloor.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6744380006
X-Stat-Signature: epdh77ywsi4em7cd5yyqeg1rt7bwx858
X-Rspam-User: 
X-HE-Tag: 1788206159-263101
X-HE-Meta: U2FsdGVkX18h6zCwB7VthFCntVY4ByAD+cFWo2Av+C6jOA1YcUMfPZxZSGo3+BB7P5ifJ+svPbWzJE6cBpgjvzjgcgTX1ROvj4+XbA8d4ttWhOrbFYuAYDsPRzaNTHuG1DZIrMn0h59TlGofP7HwkfieHY5j40vVfTyj7N/kTPb+ACh1BzAC9xJzhdvCsXNtQNqqt4+MnMAAE/2RxzA47Qiibm34hyFiUE59EZXki+35bJ18Z3SfGnz6saZ216nTo9hXcU7T6/lPE9D7aADKQ2Vq7ra3CfUqYV4JLI9nxCUZiz2MuJx6CQoddWTUZbXih3b8xuk7DHx3bYLvtxXYevk7Km0QtLOogzpck7vRoR7rMO6JT2+lvOkKUXxio7vrb791YapXxYUnavMr6yn98WfpsxH7TXn7FnQp7Y52stylV2adaDf6WjzK0DTQ+B7AFNc0XAR2gh87IkeqocUBr3zvvtBkaeTnAJE3IgWrli6i2PxPd3XtQeGQ4Z8STdoaJzO/PAKEcYBvOHxoQpJ+v6N0EYUdnEkB8TgYi6GZS0EQHnWvPV6OLJ0RExZ69ndt6Vlq56ObApt1hbi1sXNyWlOMdsycgKdYGbWIqvgB6tHXXNrJDD3TRmsaffi3YnJkCtKYmLXhQP0lWD8bzHRhHMglogx7vMVooD2kEj3Z0WflNf7eik4cl2dtrkS4M7wUsuUjHMyAE2g2pvt/Vwe/Myq0R9Xr6ZX1aGjwCYxO7F7Siq+tbgIvRiZD+JWIUztlswj6/gZUdPpkauAaYZ0j688aB0YRGr+tJ1okRp6n6Vh4jYTVV2PBy5CluWPCCUbamJ0l6NUoMR/ICcu4IK0P1xoJ3tVIIrZxirLrcHmTAVVlptIGR7P4kgFbkiVSJKTWsXSQwTt4+xCxn+pZf04Jy8bSVg35C6jYjuO6dz3Zek2MuySgSdvy9r/UmbnaGtlsDoQbCjsYdaxESu8zBYh
 EJSz0sSI
 zOvR4ak+lMrCfgo/4z2TYYplGHlxKjAZHQ6BEXIKiY33gsGEAFE/D8DBBv5lTFaPrBiv8gG3sRfZ8hnjcUCOgiR7dHUET7497wFHZAKd7+7FnMQXaeVY5m10c2PNg6hjMe1g8LJsP69OJWwIjtjpRvYH4YFCwEhRfjNppmH7lDnVy5v7vi5ss4LHKVrJi/lGluI7x8y4nRdVx5V4qqEwN7g8HbSrR+QhJV4nI37d/tqRh/66TzHwY+VYp89jpA87hT/2P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 12:35:30PM -0700, Andi Kleen wrote:
> > But none of this code uses RCU? I'm confused.
>
> There are two classes of callers: ones that change the maple tree while
> walking and those that don't. The ones that change it use
> kfree_rcu (if that's what you meant with "use RCU") because they can free
> nodes.
>
> The patch changes both classes, but strictly only the ones actually
> changing need the change. For the others the existing locking is
> indeed sufficient.

Andi I think you're really wildly off the mark here and it's not really a great
use of our time to help you debug your own private patch.

But in case you are on to a real bug here and I'm wildly wrong, it
shouldn't be difficult for you to point out precisely where the node is being
freed as a result of the split that causes a stale node to be referenced?

I mean what actually modifies the maple tree nodes here?

__split_vma()
  -> vma_complete()
    -> vma_iter_store_new()
      -> vma_iter_store_overwrite()

Right?

But I see:

	if (vmi->mas.status != ma_start &&
	    ((vmi->mas.index > vma->vm_start) || (vmi->mas.last < vma->vm_start)))
		vma_iter_invalidate(vmi);

Which calls mas_pause() which sets mas->node = NULL.

So I mean, presumably you are saying this doesn't work correctly or this
criteria is wrong, I can't really see how else there could be a problem here,
could you explain exactly what's up here?

Also why is the solution to insert a whole bunch of RCU read locks everywhere so
we can keep on accessing a node that we've already decided to free?

I mean surely the solution really ought to be simply invalidating the iterator
right?

Also again, could you share the patch you've applied to the kernel you're
actually seeing this bug in, given you haven't reproduced it even once with an
upstream kernel?

Thanks.

--
Cheers, Lorenzo

