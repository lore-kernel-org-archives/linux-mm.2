Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB6A4109C057
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26C876B008A; Wed, 25 Mar 2026 14:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21D866B008C; Wed, 25 Mar 2026 14:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133376B0092; Wed, 25 Mar 2026 14:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 033036B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:58:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E7B6140A30
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:58:40 +0000 (UTC)
X-FDA: 84585496800.08.67CF3A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 01FE480010
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:58:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EPjEZEVV;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774465119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VlLhePYL80sOu02aUw6u8m/4ZKI00p8+/Y45HKjk0/A=;
	b=W8HYXGc/QrfDyrlrffEoNkGQ6vlS8FTcoY1/j/C4EDCiufVb2eJcIDpFFaCUNsKN18xKuw
	wVPdtzsgJojNJ7ZedsdX5BUz48lkO5OmXqcfVLY8uaVlbGWjImSGAMZsz++0Ux3KBcWF4x
	w3Ef4tFWBnF6PK1HUaOiF+pfKy+ryWU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EPjEZEVV;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774465119; a=rsa-sha256;
	cv=none;
	b=VB23g9A2zm9fRjYeSLecjFFKfsKOFK1SIsxFDpICtzuOjk0c83dzkFRwGp/SH/UAz4rpGR
	5SACOekBCKxs8b9gV2uM7Hipa+Toxg18JAxrpvvasGNU0yoYUTTRH1gZz99mPbXb7S0A55
	ugvfOtF6wkcWpC13ZaoOapI3vS2EzrA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 11488400A9;
	Wed, 25 Mar 2026 18:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC86C4CEF7;
	Wed, 25 Mar 2026 18:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774465117;
	bh=4wiJb71r8PouC2/f0A5EgwpoJUcINFnRCFiI7rXCalY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EPjEZEVVQk+BooWQbKW7Ksnp8brOVn6HUSS502JAp69PF4/u1BGp6R/hmHGl5WR3+
	 XSriiIBGBiecnBYISBNXfK6H4K9NqNvKILt9H6eKYbTO052CnkqGYKtEDjvwouf1V0
	 QheFOcAqWp04zUAZo3UAbMgndolyQPgP6MAL0qtkexjGQfy/P+KTq2UacijgwM3E4+
	 6UeVAOPpMsRHcpzmjaAoKrLeInomrdF+om93X7p/hRJWHbg66WIBrSGKGxbzpEHouv
	 q1mWa13Vhm1Slz3w/NPfmhX+69jYqpErrohKCY1A7492nGSM70gMMjNKb9cPj7bnoV
	 ooomwlbcpt6/Q==
Date: Wed, 25 Mar 2026 18:58:30 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <21cnbao@gmail.com>, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the
 references for large folios
Message-ID: <92e77b03-b7d4-45f0-8077-b3f745727785@lucifer.local>
References: <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
 <86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
 <e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local>
 <e3e374cc-ddf2-4112-b063-6cb1839ea566@kernel.org>
 <e227a7f7-0186-4d10-b7b4-c84ca8424bdd@lucifer.local>
 <20260325083016.a32095bea3f04488a7c9005a@linux-foundation.org>
 <af9d8a6a-074c-412c-ac5e-3f0dadde3e7d@lucifer.local>
 <20260325092300.9008e605ed5550ce4935638f@linux-foundation.org>
 <7820cffe-60bf-4ff6-af10-89c774f0fe0c@lucifer.local>
 <20260325114305.eb90add580948aa56a88373b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325114305.eb90add580948aa56a88373b@linux-foundation.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 01FE480010
X-Stat-Signature: c1kb7z69o749nkk5rkb61stogbtngdbs
X-Rspam-User: 
X-HE-Tag: 1774465118-712901
X-HE-Meta: U2FsdGVkX18mrUK8FNrutem6MCfj8SpWYBgtPOBGvLt7Dc09yk2+6x45CmUVPaR+934B58ez/syINZI0eabVuIjjaWLlxxH+4kLXICRZF0xlhOqPtRa6T0HwxytvQZVKkrRIRg/B6rV04fFBHVZC9bvnjAVF0SIIzrx6QT5CJOnMkVlAkF8OhlHRmWDvQuWQBmwf0tcNXxBnDC4C9mHd1tbRi53fVu+M8Pr9Lw+dPL2COE1RArRlVOmxaqZiduomDJNpfri+e/L0PDBercZI709iEcoMSyx1UFhHxYlRpjQXq/QUApKFevlnCqZ5SfH5nuLP1FuoRr1yHe0sf1w15SXYmvaJF/SXBoqfmxR+mVfXNCjy9QGVrG9yUG/bdakfKS3tMxZb5zJOMveSO3UGmTp43xRIoRw7SMQApFaC54QzVGic7+QEOPq58+UHl9AgvfzNxQP9cwnhhoBf4FMsbcZBqm1MkPLHT/P1q7xu8yUDSCfsmkIGWXJhzOg926jMz7rBus/2vT/BZKyaD8EOckHje3bsus+ElU4hWIMmiDuIpA1wslwTi/s7Zqobrt9RKuvQjq4zH1fLMEP1jtG+zZ6HY6bKJWoWmLNNNz8/q/vnY5hCPRdpoMiJhwAYc1hQZz4AXC9FMx1XvotWwpa4zfk58DL/2IAREjHEjOTzY97v//y/jKTQm1xZC8LW1SYaL/JTPpseGpKp+2NCXesf1TtX+Cc9oNxnSc/VCAO0ZUG9kDyOnn/veRk+gCBclxd7dnW+VWkA+/TkwsaXK+n8gASuhzVIhU8q3KaO82yhnJVts0kkniuQvfacsAnn9MSrI8S1K4VtpaRCR5aEbO56RcV3IAd3XnKoJ/NBIalBzVj++h+BWaCBfmqmKEKVxd1Fn4xrEiYWokTQKZAebCk4K5xFm2imHO6aAkbJDTKPwH0EOPSmEG+SqCddwuS7j49g9cKvM5O+aor/9wQR1NP
 cmO+yU6N
 zEWmD6HTXszZNVvqCc3JDclfx7XrAhsKVc5JRVCRMXf4tZNOWrSibEeKbybA4AiInYcpzOlisLKjSRTQwWKzl9wfltCivGvhKqlzcz+mIXn93zKBJ3eDcxfkRpv/Pr8kzkHc+CeaalAp1Teq+2sRqvsnx6RSUWK99MM5fR85c0iskHQitBFR2bZO6h48FjeFEb3KuCP53pI+wc/m25aL6c40h0vIuv5aEpQ/abcCYR2zdDWPjYZY2GlrGJ5eazrces3qsTJVaNkvL5YyXkd4bdWc+caqa7hgdX6DidOq0AlMNuJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 11:43:05AM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 16:28:18 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > On Wed, Mar 25, 2026 at 09:23:00AM -0700, Andrew Morton wrote:
> > > On Wed, 25 Mar 2026 15:32:50 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> > >
> > > > Really I guess I'd like to know the timing of when mm-stable is taken so I can
> > > > know the deadline for stuff like this.
> > >
> > > Yeah, as mentioned elsewhere I'll add some words into the series file to
> > > try to describe this.
> > >
> > > But the start of the migration is quite variable (-rc4 through -rc6) so
> > > I'll aim to keep people updated in the weekly "mm.git review status"
> > > emails.
> > >
> >
> > Thanks. Wasn't aware that was a thing actually, but I see
> > https://lore.kernel.org/linux-mm/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org/
> > now.
>
> Well now I'm all sad.
>
> Yeah, I started doing this Feb 2, shall attempt to sustain this weekly
> after we've hit -rc4 ish.  I expect I'll be adding more waffle to these as
> things occur to me.  A general overview of where the tree is at.
>
> I can Bcc: people if asked ;)   lmk.
>

Yes please!

Thanks, Lorenzo

