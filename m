Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04907C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139306B00D1; Tue, 25 Aug 2026 08:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111B76B00D2; Tue, 25 Aug 2026 08:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E896B00D3; Tue, 25 Aug 2026 08:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D68046B00D1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:31:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FFE01203EB
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:31:17 +0000 (UTC)
X-FDA: 85139726994.06.C441E1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id AC50518000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:31:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ofT11nQA;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787661075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xsNEWNi39UPPJLm1+sc4ZRXUG0ihBnLDmHXk5dXeQgQ=;
	b=v9fsidYoCCW6SlMc1HQYgtSDOOUzwtvs6VancykgWtUCbBcIsNrgFB3A7eMPzJwpESeaGd
	itd+guihmp6j74RfkUhVQfAY2RicfYdqdzkjL+wgQSkNJCQU6yGYE3BQ1J+v01pW+S5vTF
	Gn/YQP3u6mWRj0U7hAdUao9lwWz4SCU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ofT11nQA;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787661075;
	b=LB9xkCIeQF0oSpO594+1LHYT5BRUBn/5yNW03rJFOBfD4dYqKgdF0PXx1zpUbQbCSKZWjI
	jmdF9UQqucxrjy83xEfOeD9AGNIU887xK8ILtx1v46Fdur855XIYEJFAnTwpznYYyKi4aT
	w72MppaeSuN1vb3ErRt8ktIHoYS2aoQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7C296011F;
	Tue, 25 Aug 2026 12:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3BB1F00A3F;
	Tue, 25 Aug 2026 12:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787661073;
	bh=xsNEWNi39UPPJLm1+sc4ZRXUG0ihBnLDmHXk5dXeQgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ofT11nQAHKRBlGPgKi3v4szvihkQNzTb1w8uYeVH8n7nu6YU9r+smfAe5YEONEysS
	 ZiSV5ecEsptyKeUZveViAqUPRtqVual9dbogk50MEhTf/eMYkIylU4WxuiJ15mvMdd
	 TSJrJzOOYGwLFj9ciXOwPxNYZn2NnzhJZzLA/bMe4lnr4drVZHCG5b8DsCyFqCBiNI
	 3/Gg25a3bjkMb67W77yD0yY46uVPmJF6m+FTHyzd2njJm0BzSMS7SRETbQqLf/0a5I
	 w1ls5vSOCoUi2f70nqILQokejRuc//N9ao8Z+x4gLU6B9kFh/guBDXAzkn7FHDzd+G
	 /o82JOJxr51+Q==
Date: Tue, 25 Aug 2026 14:31:02 +0200
From: Christian Brauner <brauner@kernel.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Xin Zhao <jackzxcui1989@163.com>, david@kernel.org, ljs@kernel.org, 
	rppt@kernel.org, pfalcato@suse.de, viro@zeniv.linux.org.uk, corbet@lwn.net, 
	skhan@linuxfoundation.org, akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	surenb@google.com, mhocko@suse.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, ebiederm@xmission.com, jack@suse.cz, 
	jlayton@kernel.org, chuck.lever@oracle.com, alex.aring@gmail.com, arnd@arndb.de, 
	keescook@chromium.org, mcgrof@kernel.org, j.granados@samsung.com, allen.lkml@gmail.com, 
	rdunlap@infradead.org, kuba@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v8] coredump: Add bit 9 of coredump_filter for pre-exit
 files before dumping
Message-ID: <20260825-singt-panne-gelage-fc5d58f101c5@brauner>
References: <20260808052732.2589657-1-jackzxcui1989@163.com>
 <20260811-zerfallen-boiler-bissfest-cdb998278337@brauner>
 <CAGudoHG8ff=8RA+8e6JUtESDxBHFjZ65UiCaM4X_6qSU6-Q9Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGudoHG8ff=8RA+8e6JUtESDxBHFjZ65UiCaM4X_6qSU6-Q9Nw@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC50518000A
X-Stat-Signature: 5uf8et5a51ykpeqy7jkj4ogh57odo8po
X-Rspam-User: 
X-HE-Tag: 1787661075-364411
X-HE-Meta: U2FsdGVkX1/2VDKA8TspVu29hpXm/1WFgi+o5EG5QEEih3s6eQXN5fA4O6CSHr80vLBphnqN+GnN53wC7QismYG9HdGkIPU20OyJ2bSiyNo67Lc7OgcFL89RzBE4tFLmPlsM9sWld4anOmPxyNouhCk1POB0ICVqpij1stclvf2f05iyFrEbkZ5APiWuSCpB1M+dg0T53uBL1zxYIC6CPITB2FHnO3MjRQN149jEIcvbO7ODZJ698WKmobvDPEaeieEcnq2Upl4TALCWjV1sYnAeytKvQWP14yjXzGb2Q9gb8A5Hj6WeJ/Q9emNt2l8xJVJFPReTUgkLc+C9JJHt4D50usEJP3g7fxwaRlQb6P+LGXUErynLq0b+ixeQ3lqkyHHS95LhuPlfQRKGp4KKDVE1/En4CpLnw+2nfKgN73C2rtyB8wKwBUQK2nkauoUbNwkSQQptjpX9FQpCLfJkFWBsLV3G3vGQJiVCsJQJ3GW5bmwCcDATCAnrBxISDUUDe99Ke/AraFwMCgbhRJ/G/f3sSv0svxxMTnarIyyee0b1n/PhULTYseu+s6dInxdW4ZZPqZj2x8WNhrGjFMFnMerSGIAmZB6xl7gUAOaeapV6mCiWoJ3oVjrW2IZ1wzgCXAZM6ed4UC8a/iiEzUpg4nDcjOL0i+eW5aMJINGN70sh2vLQBqs1fUqliavJL0n0don93w20CCNwDCntNV4UQg+d3nYGCevvGDFGXM0Q9tUutsb7DWV5XdVsBOKQBKK3voblx4clZi7VemN26ky/5wQkT85IfCnMmTmQhvwBoxyU1vZnUJo9+IFFVAOt7TTbiSr1ZU3U0UHCkKy4gGths314AN1jfiOtF0ceGc19KmFvwRbrmeK6L+aSeCycAHH5qFvnOOjKtJLizxhNw1pOpW5x9IwAbslCb6RXk/7/VlM+tvNvUZ3PG36UKXkrldmafKQCbDxWvs2Hoi0fDji
 ybM6mOnl
 Fo8xbdl9I2sV+zeVpM3v6MltzoPO2+1Ato6Tv6yG6yvS5N0I+Z6WImBxEyJoH6RNo+rHGyWj7WucsZVtgWtu0lHTccRfJ0uuOMS8UKeuTuxysM07Udjbn7Q3f/1O8D1pH/AlPP5or8ayOhj/HjR2i/H/iRgTz3cp94bjrURF2JJaEZ0f+xCyF3it2xJvgaX527cENqtIbHFxAfYhLPaJjSwv5zDdBgkSYfX++ZoMiOwIvVF8FysmkQEEtTXG9jkJ8esVS0JcoFTZ1MvPXthtTxLIhDhcC03VJO1/3AizguA9HRzV2KVxyNspfEX3cawvx2cG9NG0+vZvyD78X6Cr+LO90iYzmBdyzplK/9QZoVIfihsMb/WmZa9Hjp6psrutd4OCTPAU5GTYkZ4A8czgWXAAI9CpcMgdfJsY2pROxeli+JGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Still NAK to this whole appraoch.
> 
> Would you be ok with a variant which merely unlocks prior to dumping?
> File descriptors remain in place like they always did, but that bit
> about them is changed.

Fyi, I've sent an alternative proposal (you're on Cc).

