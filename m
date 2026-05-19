Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABE48CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 21:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75E66B0005; Tue, 19 May 2026 17:08:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D268D6B0088; Tue, 19 May 2026 17:08:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C506B008A; Tue, 19 May 2026 17:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2CC06B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:08:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 109791A0ABB
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:08:38 +0000 (UTC)
X-FDA: 84785408358.16.8B887BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 28F6320003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:08:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jURyxAjI;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779224917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JS1yyKmqnk5Unq24VeZ3/2R9CA2t4l0FygZRt/eQOoE=;
	b=UwFwZ4mLbj9BxqIDFkDfB0FrPC4qNqfHLRt4ASHtX2ZwfShsUhgAsFpXMg6sucBoGHbbCc
	AHfkjC7ns8nm9rjS9TDHRavrYwUvum62wBKIA/vi18cVcxEGZSx/hv58+/u/i8LOc0gdTq
	PcARJdsNr6VBnZvuC+UshLrJS3lTUg0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jURyxAjI;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779224917; a=rsa-sha256;
	cv=none;
	b=oZehX/VwrcYkUU43aMdPUT51rGyExhaKcWdrIYiOA/knhdEjKL2wY1WWcJr+prbICSx+0R
	8LA4yBCL7LNeREi84MxtEHS0OsFFkg+eE8GFgqM1z2XW8UsY3mhLs9+8gd1Ka54Za9sMhk
	u6AVENelfuFt/ctL9JKCv+1FrsCWotk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 470C944470;
	Tue, 19 May 2026 21:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31C31F000E9;
	Tue, 19 May 2026 21:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779224916;
	bh=JS1yyKmqnk5Unq24VeZ3/2R9CA2t4l0FygZRt/eQOoE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jURyxAjICAw+O6bXQeTFnit8oi3xSXozTg6BCrySYVh2AqIh8wiej8qRBEzJHnOky
	 nPwsy7Li5/Pk3jr3FgbINEvo06oasgpgVbznHfwcoIedWyZhAdkHs3bSbDcPP0Aa8F
	 FGCVPMyqBeUksPS1S3m91+b2d8QFIN6q4xZwilNY=
Date: Tue, 19 May 2026 14:08:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Georgi Djakov <djakov@kernel.org>
Cc: Georgi Djakov <georgi.djakov@oss.qualcomm.com>, david@kernel.org,
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, Mike Rapoport
 <rppt@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2] drivers/base/memory: set mem->altmap after
 successful device registration
Message-Id: <20260519140835.0eb262de8c8e37b9fd307c74@linux-foundation.org>
In-Reply-To: <90c0af4b-f608-42e5-9f61-222d943bcebc@kernel.org>
References: <20260514092657.3057141-1-georgi.djakov@oss.qualcomm.com>
	<20260519132522.421c018b39328ebc4767dd8e@linux-foundation.org>
	<90c0af4b-f608-42e5-9f61-222d943bcebc@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1s4x5akds4kjifbfw3cbnxb67s8zg3zd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 28F6320003
X-Rspam-User: 
X-HE-Tag: 1779224917-537015
X-HE-Meta: U2FsdGVkX1/RQ5Z8OaTOQnLB66SybmoDjHDCyLfwlZNhFsPqjUWjGuE5sNpmOko+qbLBMOg8QSBMO1sGFG6vYaB9Xmu9jVNOX/te/DkgclOsPPo76LjdC5l8rfwQxqBwwmKkGiZ+Gh3h5/cB2nn9LhR5EmSQoYIAZqzzmYzSAjABFEE40P/TR32KiVVQRg3i3MzzGq7ITLjhKLiZQ1m4viXMsLcsrRXFS2RHe1XrFD6q6qxDrVYeGZa1k1AEYZRFwv6mSzI22wTu/7KqZAmEkO96x2vhTi3yFRBWTwN5NlLuc2BcjX5TlAZVj7l2Tm9tDWbXJyV2VIbe+/Ut1mbCXrh/fi+6kJIjov4B+QnLHT3yzWZ/GbL/T8O1yn4yYgZdWPS6QmqdGPeSR56K9bEE4DzMKF0MM6HkoI2jneJEdKjsOvbGYhJuFUX5FfDcyHHLQ8txucWu/Ez72BOZikJRS+f4N5CYWE9ms30HkaUhCBuuJbRcXu2JjVF3akX7mz8CDZi6Ko3ZADJZ2db5tCBsUadyJfPBqLD08VSjlFchqmIufbiAw4Xkj6mBSBQtZDnyM8j9/u++HUVtnF3wyXTm7+XVfUMxc3SEEeMS56BolVURBivVFo+BFWNojVupWs2h3vW3eJun/pvp+ua5aVkvzUy1iqtaPxHn13xRSM6azbDswtn9J5iEIldVHBA1Sb7uSrWhuPioDJFSA+FB6cRnGp622cihBzXnpMJShS3NdOCvRT9Wh+8q2VXO4/yNheWWCkxtpl7wS2bPJJMppiULhgBkGHfIgpgXPGVVFSLWKMHNspKEKAAkYlP52qk9wPGt11O3PrkjjrVGwlCnD/BOiJWw3DcpnjsqpzgzypANcuDlEcjz2KmuT7DW5svWMPb3dZMFRQEpbBQetSGCt9z/arKyUtWhStAKBcAA1DZS+54Fyi5qz6wiyyaUuCD2fPsHfBmga4eL03RFz83GiWU
 rU2wqjua
 IFtPllH7RH0mzgE5Q7H79Hhutk/qCiKKrRoadU+NWnrV1gdASpS0+Ww3m0ppKhrWOdhNLkU0op6n4wFZBvRATNsbqALDf5uyOIhBxmuQ2Y3uBUwZAIhs10tmYHlJ+f3U5x0TNdWiJxCaNuNDf+lszQIt12VooTncYgXqSl2lBh3qYLXV2z5/6rWC+VhEETZwnYrbg2tPnHmvQj25CbVGhGmO+PLfctufNgeQU789FwIDbAjZe6iokn1tKb4MmKmjvHIQ06j07a0T2m6kKi5owsMux1SzIqWyVJLtG8c5BH9MW0ES+Ud7SwPGJVo6NQFEzloLeGa51GOY96o9zWexaYLxpoUvGizcbVeRxspP0wWojmFZKydWqTC/8nxxhO/4IjPTn9VyfLCf+UKC7gzlVTCYWeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 23:57:52 +0300 Georgi Djakov <djakov@kernel.org> wrote:

> On 5/19/26 11:25 PM, Andrew Morton wrote:
> > On Thu, 14 May 2026 02:26:57 -0700 Georgi Djakov <georgi.djakov@oss.qualcomm.com> wrote:
> > 
> >> If __add_memory_block() fails at xa_store() (under memory pressure
> >> for example), device_unregister() is called, which eventually
> >> triggers memory_block_release() with mem->altmap still set, causing
> >> a WARN_ON(mem->altmap).
> > 
> > That isn't good.
> > 
> >> This was triggered by modifying virtio-mem
> >> driver.
> >>
> >> Fix this by delaying the assignment of mem->altmap until after
> >> __add_memory_block() has succeeded.
> >>
> >> Fixes: 1a8c64e11043 ("mm/memory_hotplug: embed vmem_altmap details in memory block")
> > 
> > Patch is nice and simple so I'll add a cc:stable to this, even though
> > the issue seems rather minor.
> > 
> > btw, AI review had no issue with your change but might have found a bug
> > in create_altmaps_and_memory_blocks():
> > 
> > 	https://sashiko.dev/#/patchset/20260514092657.3057141-1-georgi.djakov@oss.qualcomm.com
> 
> Yes, i have hit exactly this bug actually (shortly after this WARN_ON, we crash)
> and was going to send a fix, but noticed that someone already did:
> https://lore.kernel.org/lkml/20260428081855.1249045-3-songmuchun@bytedance.com/
> 
> I can respond with my RB on that one if you haven't applied it yet.

I have indeed applied it, but a R-b isn't a problem and would be
welcomed.  One of the many reasons why I retain patches in quilt form
for a few weeks before gitifying them.

