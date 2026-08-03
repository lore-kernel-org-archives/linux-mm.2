Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C74ECC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9041A6B007B; Mon,  3 Aug 2026 11:37:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B49D6B0093; Mon,  3 Aug 2026 11:37:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB516B009D; Mon,  3 Aug 2026 11:37:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5996B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:37:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E63DE140767
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:37:23 +0000 (UTC)
X-FDA: 85060362366.19.5F853B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3A3BA18000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:37:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L1vtDyRu;
	spf=pass (imf24.hostedemail.com: domain of "SRS0=EL+k=F4=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=EL+k=F4=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785771442;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EEeHvCK/4qr0udFm9xmmfnLHXKUOj1vvk2w3lbpsW+w=;
	b=JYGUoutlIGRkiiKPLzqUpYBASVSU4g62h3J24jY1CVUzI/c+IxEliuHp9wx/qyfEqB636O
	Skl1Rb5rn2uzPrc54hzmUYj3Fh6uTVjJ71i3Dah0FYeSRed7/BGq6PgfUzg5Yc41Wn9iZT
	9OGx5iVPcUmMs8/f4QGShTBFeXmCwLw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L1vtDyRu;
	spf=pass (imf24.hostedemail.com: domain of "SRS0=EL+k=F4=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=EL+k=F4=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785771442;
	b=uczHSXdrY9m/hutUOBI8nYX+Mn+Mh/QE/GBLbdotmQSmxYXJ6tPO1AJRflYjL4dOuby45L
	ZzSXh5FDqTlNEfcTSg7ipcvuCx+ewgt3EFiqLX69bxOWjyxDJFdrQfHtyIpFie8XrWZQ5C
	vTxjekGUL50YuMS9oOVf4fz7uiTiz+4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4937742D69;
	Mon,  3 Aug 2026 15:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B44C1F000E9;
	Mon,  3 Aug 2026 15:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785771441;
	bh=EEeHvCK/4qr0udFm9xmmfnLHXKUOj1vvk2w3lbpsW+w=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=L1vtDyRurwnCEOZ2LLZLwBHDU7joi5ok/iepNHu2YWDHslKpqlFboRSdyO5xCRhKw
	 T/7amMFjOZPiWnsk8fH0/s51+udxYa0Uew7jo7e3DXUt7oGTUN81ZsOOoZazyaMH/C
	 L4LcHET9THFSgfv8I0Gi5bKwPrPAB3zInEXpk2/rdcq5fImT4FA3Xfk/SOaT3Z17Xw
	 jfw9EHd/faF3s/xRBKDks8m4ZrFxfZcB+wX8u8Ns4kgg4cTQFy1yzbyJI+NERCQKMe
	 JUYb2xIF2H4K2IguY8Ok3P4evxCYlFQ6tJSWH2hNXrfTTiL3lKalkmOPQtXS/xoGkt
	 Yjyt2gidm6DcA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id E6F4BCE19B2; Mon,  3 Aug 2026 08:37:20 -0700 (PDT)
Date: Mon, 3 Aug 2026 08:37:20 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Uladzislau Rezki <urezki@gmail.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: stop exporting kvfree_rcu_barrier[_on_cache]()
Message-ID: <f309e572-8fd9-479f-8ba4-4c9ecaa73bbb@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260730-unexport-barriers-v1-1-852f6641abe9@kernel.org>
 <d2cd0e92-930f-44e4-96e5-67b751419a1c@paulmck-laptop>
 <c4057657-7246-48ce-80d0-123e351a921b@kernel.org>
 <anCCVU7Y6lMaPmAT@dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anCCVU7Y6lMaPmAT@dev>
X-Rspamd-Queue-Id: 3A3BA18000C
X-Rspam-User: 
X-Stat-Signature: he546wnuabrhba19gmx5ofi3fdgfino4
X-Rspamd-Server: rspam04
X-HE-Tag: 1785771442-587421
X-HE-Meta: U2FsdGVkX1/eGKXzkxzEtIQwYGNqmze1NJ2geRAblBIZrNp0rFHkhw/++6tKuKfzgxbbhlSJewogmH3pvGOYJFDtjrhd9VYfk9QVIdVEWm0iSuv7Dz1i4o+dClI+tSoy6mt4yzNXvfJSPSCI0BRDsRF0V30hp+6pXNJ43xsUAZv4u1K1CtgzXjQUHib9qcoY0+pX5IFld3ApOeyha1gwNlbFz87QNATV2F13ZFEHj2G70n3KlFFGpm/FJBqLK2/fWqNAiS4RLFD6ZFnkm1CCk4RYqThU9dW9IDl33ZIYY35zHZmpGmDAyLXbUYejLlI3PQ1QbFMK43aPyBXs/Qw4sg843p21KeQutKkaimHNnXl00anrrqqNlh/gFMzxiXCcgFB/5RPjo2K8tV1SDhv9ETW+DMNebN/qaRzIKE5Y6IgC1UMbEgzKqpq8e/WKY4uOsNwfOCEcr60jA2nCkwvfu/5Xm6Wj776C+osvV62c3OFcc56l+GTzaOca3M2zH15EXenyhZdoClsgxk1HI1ALl8+vgVM+iME6hnGjSfJGTON9lPWq4FzZdZgOiOZfhRKkBkg4WlsKqjP+ctAagYC8MMRLK6B9hunCoDe8lCumJW6juzIwHtaA/dDIMFDwKmlUQNdbldudxbrXWurKavKEnsZyJfzMx53RUsg4AAD9WH/EIw4ysim4M409CLLERheE+SjbqYQOgPkiZ5NzAsuhXgfuycLH3C9hrhLZn82aFNEH3cTEvSx3r8ZXV664STiS0W+6f/KhtcIn3DC4IEc4zJdmK8gdXz9fyKLN3ciz+QCf1qsqaJH1u+EAZ0T8q1kw2x95zFxYJEx66/JsYE3f2zsz/StEaoDXr+Lnnzr8DRb8Pp3r/L22SSRlkO7DX91+dD/1EwtbjuHFrSQ6iFE42C3svlgaU99mL0YVuigCeG1tF8NjrWxoR0JZGSYzebYWcBACXQb4AHCKvdtuP7n
 HsKq8vND
 veziwIDyXPM8tiqEuyGUuvoin+b+QG6roYvSrvNLtcDdhTtrb834NeoUjUj72TRlSSsdGej/OXsXMCsPTULcpyD8nQcrmE/88NcCYgJdhEdXz4+se43HJcAN2k97HzIJV6kLHSk+Vrgc1h+BIfnB3ijZOHnfVizAKeI7eBtZx56AO1jZY48HcUEvXF3qPKBw9udQgJaVewnQHsSN8Gdb9m+zfjE19442nQkWIkccVC0qp1Pg9PJ73bTjocp+CijVfdDyk0//UmHvpTt+8z73xjomIb+dRRvFSRpfKGr8v93UjzWGmtbtHH1Sc+TbueAtutHEZb1icewHbRt23EsgTeizsLFIvpHx0KDlWnwPO8jAW4ekKJ5xRf2KShndEQzN1Ew1BlYw97og0IcQhIO0G9BgYkhhwJgDvKS59Akugti5Br5G9t7YeguT3+xluaRsobOLpFxKbGwsviYqM77bwY48LvjqPI2Z85F1Hc4D/Myt8g9H4mvzkw2lC39pELmt/CAvK5Qym9ZDkPXCs6VKRMR5b8tk8lvBvKnPXHsQbHQpEZHITFvdQMcGXQaeZZs4/B98ajtAUZo6PsVFulgVuus6uIAi9BYsQK5UcF+0lycSpNKcxZ/QWweImgmuyN2uzv+bZb+uxEUcLqZqeir+tC7IrVpO4LyRqZQ3xEw1cVXx0Wtk53HS+RYmZ1hiRYZzeCHXeEWfi2V8F6gI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 12:26:55PM +0000, Harry Yoo wrote:
> On Mon, Aug 03, 2026 at 09:59:44AM +0200, Vlastimil Babka (SUSE) wrote:
> > On 7/30/26 22:59, Paul E. McKenney wrote:
> > > On Thu, Jul 30, 2026 at 04:32:46PM +0200, Vlastimil Babka (SUSE) wrote:
> > > Which reminds me...  Are you guys interested in taking the kfree_rcu()
> > > test code from kernel/rcu/rcuscale.c?  See for example the kfree_rcu_test
> > > module parameter.
> > 
> > Hmm, we have a slub kunit test, but I think no such torture/scaling test
> > infra. Maybe once we have that? What do you think, Harry?
> 
> That'd be definitely useful. We have been reviving performance tests
> every time we wondered if it'd affect performance in a surprising way.
> But we've never put that in the mainline ;)
> 
> Probably test_kmalloc_nolock_and_friends*() don't even belong
> slub_kunit.
> 
> Perhaps worth starting small with lib/test_slab.c, and slowly
> move/add torture/scaling tests to there?

That would work for me.

							Thanx, Paul

