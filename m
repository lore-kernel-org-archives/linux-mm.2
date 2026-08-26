Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 152CBC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1296B008A; Wed, 26 Aug 2026 12:41:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7DDD6B008C; Wed, 26 Aug 2026 12:41:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C436E6B0095; Wed, 26 Aug 2026 12:41:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98C016B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:41:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A95AB1601AB
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:41:50 +0000 (UTC)
X-FDA: 85143987180.23.94CE6A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D25A98000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:41:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gfyXWyJA;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787762509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPjkwU0mp8K1sg0RQauhq6nWb8WLYzhdL28QYw4YzWs=;
	b=fGAn+K2N/UcennczjwY21ycUxCuVi9B/LrEx/9cq+FTc+yrOWzQZ+sPXC6uIldV0S1+cmI
	4a30TKUmdWZLCNSHiVm/+Ij/IdzsLjBjNE7PwUW37Pr8ezxdHqnAsNEtLbf+diyKHb0qTJ
	U98l+qTqwsGZR0ZaADcjgGIbK4Eowf0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gfyXWyJA;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787762509;
	b=mCv0/QtShJO2OgfzFEAdywkFTE5Tm8PSR+ftlVSHKHkKISNE0U0O4lFS4XFllHRXf/DrYz
	JsLwJ62+ikHr38hGETnvAarLgwcGPo3vPQ42nwsDO35cu9ZXpj9gVYnsl8eVI2otBxsMnv
	dmQjRiaKWLGyRv4XFPyj8ikVbplJBYk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 033EB433A9;
	Wed, 26 Aug 2026 16:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4111F00A3F;
	Wed, 26 Aug 2026 16:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787762507;
	bh=TPjkwU0mp8K1sg0RQauhq6nWb8WLYzhdL28QYw4YzWs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gfyXWyJAAoC+SWNzywo5H8E7eZPuZn7ZYQEBQBR/7ZSlXqLv4LEaAS8oL/I41lFhP
	 6emZEdySsJrp1L/L41obUbRI0Q2aTQwJCRANgKNLHyci7acwaJH8t7wTbUzoj89JlC
	 h/2gz5h1V4rXhMKUqYup5qMKtIGC815OLKk00bok=
Date: Wed, 26 Aug 2026 09:41:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Hui Zhu" <hui.zhu@linux.dev>
Cc: "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl
 <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
 linux-mm@kvack.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] maple_tree: Annotate lockless pivot reads for KCSAN
Message-Id: <20260826094147.42e1e71e91a5a537ced30a21@linux-foundation.org>
In-Reply-To: <20260826074430.1139325-1-hui.zhu@linux.dev>
References: <20260826074430.1139325-1-hui.zhu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 95p8519dutr61yhaowmnzx99wghcrtw4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D25A98000C
X-Rspam-User: 
X-HE-Tag: 1787762508-902424
X-HE-Meta: U2FsdGVkX1955yIvbw9vSCJtevzYiP2u1ndbn9MrE+fG8he14BszoudOFgg56DX1fFnNqWNZKMUXW/4mFMlSMNaNLpIE3zsYPs8NoQiUkqnIQyL3WSlKPLPhsBGiF5C4SdprkrdG44mXzMOgNe+uk/efqbgFX/cNFpeX1PTqrWADL1HgCsMaH7cVkRRq8xX7Q+mdUYDLDoi0niUEt6Mra2RYpPG6G+fJLpaTbeZUnJIFD1Hg7t7UkDU6r602eMlTeEvXzmBmcRJN+mbsQJYqcBI178X55pqqSbEzeVoziCfR4ofXqXbb2LrGOYW3HUvBuBGdzeMuSgg/ezr3vGW0s/4mun/82tvvFr3YAWhBUlklFNLevjnY3qPTfPj6pWRbw7wJays1mrBjwBMg3+jYjC4gVU9wA9uLUCb4jFL2h/AhcZ5u0K3W9beo5Mh8rFF8iq8kZZCMtOz1uSJYaNpmMQEh7EQ8o0LMyV1IxrfuKiBE5B5IFVSVbMA08A3f+woLTGqUYdeostPki8l4UO+x7s23Al8MnB5r3AtSX5giVv41Dr+ZovvND/5ADF6KAWAH2zc+7PCs5e4vR0NnoQ2ndNBxWlZvv6sU14L0LrCwcyDRJtoz5ivwu91hhgwkcc1NoTHZNDyBAESGW5747gh9FBMgnHvWzL7DZha6wRVt4ZiAGxXU7jFdt0rOD/l/DyPqSuuUk55Ldo9QQv89xYyd5uzu84aO+2OtuL14+WEEdfEdB2Fhjb3jBxdpdOZ/rcvobXA6GX2SrMxi7xbnPdz+Yy2ArNfTzhu33QRIuhzPBKocSvh+4TP2H122r/KguIBPgC5G934rNY5h4ADcQ6qyNiJp+9J5Lh5VsSRItI6oNC2++2XqrYAdK2ja3OAKQ9jGAf1WqM243XOBpr/ScH0Dysvp7uCniBtmUKQJB+/nb4BLM5TLYVfi4EREHhUhVaf9PW4WJSnjqJkbvCzSraK
 /QU4qRWL
 FrZa3OCBt03tAUQctizLEO21I2NoC+B1N537sywGYF0nB2rrfz/9P433abuarr47jK0unGHlauQJ4xllZ52i3gTt+rkBZm9ONHpEU3BcScmEbF2zmDH74BhgASvDCBj8DTalqsl6pDaVLZ0SQbAzVcR2GBrNA6SMMBXjV038ZXjcydusxIW8FVSITWLyEUcnzokCw2jsqhH7zJkeaIUZ60kyb+0K1Brqi2WwQOjuhe+lxnB5R1XThaD1GdgVGrwZHqBW5RaHrgJwH9cNayipBG/8kHLmsQWZBbJ6rq1KuMYNQt94GLPt6B4hrF1goyX4oQfzszBMR38fvV7zSfhhudLsSRwO1z25HmTMe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Aug 2026 15:44:30 +0800 "Hui Zhu" <hui.zhu@linux.dev> wrote:

> In RCU mode, replaced maple nodes are marked dead and freed via RCU
> after the new node has been published.  Arming the RCU free writes
> node->rcu.next and node->rcu.func, which share storage with
> pivot[0] and pivot[1] (see struct maple_node), while lockless
> readers may still walk the dead node.  These stores therefore race
> with the pivot loads performed by the walkers.
> 
> This is harmless: the writer marks the node dead with an smp_wmb()
> before arming the rcu_head, and the walkers re-check ma_dead_node()
> after reading the node and restart the walk when the node is dead,
> so any pivot read that raced with the rcu_head stores is discarded.
> KCSAN cannot see this protocol and reports the plain accesses, so
> annotate the lockless pivot reads with data_race() through a new
> ma_pivot_rcu() helper.
> 
> Found by fuzzing on a 6.6 kernel; the race still exists on
> mainline.  No functional change intended.


Thanks.  AI review suggests that the patch is correct, but incomplete?

	https://sashiko.dev/#/patchset/20260826074430.1139325-1-hui.zhu@linux.dev

