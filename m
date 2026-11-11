Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC8B606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K28nOICW
Received: by kanga.kvack.org (Postfix)
	id 80E766B00EF; Wed, 11 Nov 2026 14:18:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF1B6B05B0; Wed, 11 Nov 2026 14:18:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D48D6B05B1; Wed, 11 Nov 2026 14:18:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 536116B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:18:03 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E05F58033B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:18:02 +0000 (UTC)
X-FDA: 85423798404.30.1B11149
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5569380005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:18:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K28nOICW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794424681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbGsBkq80dTXDcXRO3OyP/kA9RBJVrCTbNnkA3YaMcQ=;
	b=8BTRkeVge2BTu6oY1ntQJNNNZhJIVoYOCaUHs/tIVbuogI9CC/qTqM2iD1xTraKlCPSH4A
	Uq9x8rghSXwzcMFq5RnN1atEzllUfcfWsNGt3HD+0Twx/UNObnX3ilkH56fSt+BvWxEafp
	i3G/f/HF+Y2J4nZRsT+2e3uGHkTkz9g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K28nOICW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794424681;
	b=WpNZ9MKACG/ienunjK+qW4nqVC4YT5Z79evWPjE7zaTnVuDoZqAJ5f+z06pYHhTdGxKzjw
	AKgupHmxpHtkavqHfy3Mf85BDm3acnU3AFVkdBehXCGmSvrKZhUbrxv+CvmlFIfx9W+j3M
	ZirwAODASeCIk5TMbWFxOksXsnvdBoY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21927442A8;
	Wed, 11 Nov 2026 19:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A499B1F00A05;
	Wed, 11 Nov 2026 19:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794424680;
	bh=FbGsBkq80dTXDcXRO3OyP/kA9RBJVrCTbNnkA3YaMcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K28nOICWilHBG7YzxMSQh0SxT0VsVxB0J/CWM0TQkAcAFbkikEwMcpJo/uBe17gKu
	 5D1Pw0fSGhW3aheo4iegmfxooOxhZ8/cqVmJukXfcfvNup6Nr+AtHJ7pYlVAk/IW/e
	 LEzArB8JhmJ1Sx+mX2HuPXMQWwFS9D2x9Bgqkvlw5efkAJADe7ErITKvagfkEWD6tP
	 l3mTk3/CoXKys6wsx+ThT6vELjCi2wrhpERH8VvgwpfMUCaXzA3QBv6JseuEXyA87u
	 s/AJd6qLegmBFEuxOJFggMjvStqx8pQZ8PSbINn5mgRrd3/QueHlw0+QSr6T8N5l5Z
	 Txj+rYf4OWLAw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [RFC PATCH v0] Docs/mm/damon/design: document data attributes report infra design (beyond page table accessed-bit milestone 2)
Date: Wed, 11 Nov 2026 11:17:51 -0800
Message-ID: <20261111191752.145919-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261111185412.145514-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5569380005
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: nuk3usdzc89bad6newx835bru91euwso
X-HE-Tag: 1794424681-411105
X-HE-Meta: U2FsdGVkX19hUMFoljQhjaf842A5kFqWuzGheEc/HDTrQiHiML1Cc+YZQrznEutY53BzBiog6mqNGTMB5ZsVLz3cFxkPVCGsbvcao7jzYXCwSx7rAPZJtJpNPZGiq2mGA+AOIfnCfpqx7cbdLBa13DXXMjIUa053EqJgAaMJCBpeUnhI0lYQn5C6p8F4/ZsMOGAMMvpzDdmpQonCH1hy6EMjYpQJpx+F9v/R3nDUjes+YZSRMgrciNPp6fLQ9JAlE9vxh0iM/rGmEKQjgZY66dEo+yoZdhE1mPkFfZt0ccuq7leP9WdYnuCjLlziM3IQaoYEtIvugh5HAyXOmWZVyuZ0vjAlycqWsfzE+PtLlvoCTW01VuNa1cGxcn2VjTX0rQrqgZGYwcjOPd1KXVlB6FLWovyX07jZIQzjB0vTb5MMpLeaZ5H+A8G55WrUSVa576JrVyhIgsF7I4AiIVNj36uL8p68Auq4Kk5tE3OEkIiqiL3wr/Nmn3mb/SzmwOu9Z3/lBEijbeFpheUv9tZ9FneWL47mSnRne+8yHI3b6Guyb8nu0EUnzR92lfezCMzkzkPMO+FG0TnwJkRamte9UYB/NbLKcybFmudybtRBw+rIvouCq7oV/KKh26HWYZWxjLxIR8ofYI40E9XwCWOtmvhvAsVuA0N4d/Q+djQKsOUEunIZQ/FjjLSDQM+jiPznUK3HYBhF097qDVsmfXJ4urZv3CQ/LdFalacyjPgm6ZdVtr7kbMsc33Kc/EORBRAuPY5WkddtuVyyAGYSMCnjSC7jPW4IADdyFlJESzMofD0PsLElsF6Toll4CFJLXkMt1J+zoVfA8rJBg1fuWoYObA0x6T1Bt9m5ZReEGCPJiG3Gg9cW9g7W7QNdQJdHGicTOYt0KGlqfkQ7cHcrhOsJOy99z+pPASqUcf04iPd2vl9cIo+o8910l7R4fVIqh4Dwy3faHWvt2tbUASTNLPK
 O7VEl7hc
 JTAS9DzIeMgdHFBnP4lITShhWEWpg4HDKHnJTrFTwnh0h7HkhD/RlB2kw9bAzke6ZAt6i5h7XFzDh0MRVFlZ5UW8SHRSm3BHogG6c6S0ZWeYPzmek6J+0sByYBK4bAo4HPH/EcGfbOwzFu9vn10jp1duM5dC494K1o9uQxYa/09GL3ftmlnid9LBS5QIkGkSzUW+HN57W4NXN9nPPREbmb/HOJyd/hDyVj0hapNgPJ+mFaUrL+BsA9TgUbMlaHGqi8oUXzWe9NQVFCzBgt7C0P2ipJtQABjYT6T9f9NOH+YYmb+7X77rm2kfIdVWcexFQ4EvgVylh0Hzl55A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 10:54:11 -0800 SJ Park <sj@kernel.org> wrote:

> Hi Aveline,
> 
> On Wed, 11 Nov 2026 18:35:52 +1100 Aveline Noir <jm5905938@gmail.com> wrote:
> 
> > Hi SJ,
> > 
> > On Sat, 17 Oct 2026 12:57:45 -0700 SJ Park wrote:
> > 
> > > +The data attribute probe supports the reports.  The probes can be configured to
> > > +hit for a given memory region depending on the existence of specific types of
> > > +reports that associated with the memory region in given report buffers.
> > 
> > I'm wondering how this would interact with the region size.  If each
> > page of a region is reported with probability q, a region of s pages
> > would hit with probability 1 - (1 - q)^s, so a large region may hit
> > more often than a small region of the same access density.
> 
> Thank you for sharing this finding.  Seems this theory assumes the probe will
> hit for report of any byte of the region exists in the report buffers.  Under
> the assumption, that makes sense.
> 
> But I'd say the assumed implementation is not realistic.  That's because DAMON
> design does probing for only single sampling byte of the region, not the entire
> bytes of the region.  In a real implementation that is aligned with the design,
> the probe will hit if a report associated with the sampling byte exists.

I will rephrase the document in the next spin to make this be more clear.
E.g., The probes can be configured to hit for existence of specific types of
reports that associated with the probing memory in the report buffers.


Thanks,
SJ

[...]

