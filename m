Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 880EACD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 17:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE636B008A; Fri, 19 Jun 2026 13:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68F436B008C; Fri, 19 Jun 2026 13:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558D76B0092; Fri, 19 Jun 2026 13:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30D8C6B008A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:07:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A00251C4FBC
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:07:38 +0000 (UTC)
X-FDA: 84897293796.24.A437206
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id ED4B11C0003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:07:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=brkFo1gg;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781888857;
	b=FRh07K6wHjnhC7U6KYIGkWKhnUDCZzUf2xqLf3P0ZSD44Zl5k5NU79Xh0rvsTcH+hH6PUj
	Pd0ItF4pguFeuQdAQl83voRsMqn6IcPdI3pAsfb9xVE1Bpiw4dTP/lx0EIATokfMw5pdiy
	G/e/OmP1suXKhNCRH3wLrUnbqL9Y1kg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=brkFo1gg;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781888856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aeuB26U0brIWccqtcDGehQkxyCwlFMLLMddYu0942Iw=;
	b=w90+t8AdWWvMqCPGyetacEb/h1J2WuVJc5lDfg3Z3ywgsWRkU6HnJi4AucTEdOZ5xQKSnZ
	H8NZ7l5O4mVJCdCDyh2ISkZaftE+ve/6ZMf3TD+Jd6IC7DgdLH6GGbZQTeJgvB6VNI+90O
	WlRuRD3ihot2ZO2+9VAm7WNHb5JDfGo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 56D2C601E1;
	Fri, 19 Jun 2026 17:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E131F000E9;
	Fri, 19 Jun 2026 17:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781888856;
	bh=aeuB26U0brIWccqtcDGehQkxyCwlFMLLMddYu0942Iw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=brkFo1ggwWjEhDRsLhYJemXNMQkQUusqJmybB7qBNJ4XDdafvDSJQKrUxjm7GFIvF
	 tbjbdOhaMOjEc7KzbMFOKfJkEwRbp9IgRt+j0TLFlcACCSahsJsC1TKGj/LLQTHWma
	 ERYxbv7aIel7FiBSISmkvZhd/h2/Bvvf/pvy7Yww5kPmq5CyTThIcM+KOkyqFwz5mZ
	 ZjQdyvNSThJcniisREZm6Iu7/AbIXR5cGATSV4hJ+KQ8ZVmowIAUNKZBcYfXQEMEKm
	 /H2RKK1IiyM12fU7/tQDhVcOasb2rVyqmltwOvmyHiueChRLjggZrNkmLCkRQiMFVZ
	 GPlll8wVbh2bA==
Date: Fri, 19 Jun 2026 18:07:30 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Frederick Mayle <fmayle@google.com>, Kalesh Singh <kaleshsingh@google.com>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead
 to VMA boundaries"
Message-ID: <ajV0TbwEyaKMzoa6@lucifer>
References: <20260619112852.104213-1-ljs@kernel.org>
 <20260619093711.d0d37c9920b3a16394c356a6@linux-foundation.org>
 <ajVz1nhMn2JwucMY@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajVz1nhMn2JwucMY@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED4B11C0003
X-Stat-Signature: cyi5rbs8f9shp3p7h67wjtj7rrwq9y1p
X-HE-Tag: 1781888856-868330
X-HE-Meta: U2FsdGVkX1+8g0LuACNPi4s/oqm7WQNx2OaH0kjmwG387baRPrOIB56yET2eVYHjR79XlcX/RxbQViiuMk+1pGCxwfurCaB7GNmwBpBPeqY0scAN9j+WGEUsm0g17QA40RUU7aRh72pD82U169Rn3XX/rz+ONvV4ynL6Lex1KsPzQkdvyPYy2ZaBYLzp42ebFQDEtU4Sx+IwTvkFeGcxzmiCqsQ5l9hgNiif/AhdV7JJwoB9uwYnPL3ws2efRXk3YkEhcvAzv/DiV4S/wG5IewlnT6sUArk/2iJxXJU8LM0BBUo5Kkrb3/6ViRvPwf5DSEVo98VM9wiROSQxvGRU19vqSjTFXXpfqBo9wDgPisDAdUizRFjQ/rI5FnCSZl6MVBMXNhhfrTD8ywWcLM3YDEEGyVP/iFa4Euy4rVp0BnKNBKgd6r4wD6NyY9m6XxhBtwbJkC2H+nZabxnF7Xxoct2rcZOnyvaZifon59mNlu3w3XyqmKTfmZDZ++wM6hU2vvH7mWJrH0JRB3r7CDRURLlj3C107q+VtOdogsiPteNfhQx45HDchMaD8JT2yor+NM/lePvicpUtGgxhFhEbkiIj4cIX0D+GiDqIHpGwz5CWtp+f7RmnitgQ9PqlE1Cy6vV2dMJxr1CRnkLbKZ11OJn9YLTd1+T6S9aTYvcAmr7T30PJzugBxgLNto1V3Ww75SxRU2gXGJTZ4eCjSmFSR4ZRY14H5IhIBWnvHCjwyHp5ZQcaMAw4b7kov/9Kpe4bzfv5mOkwn93Zxh80gS5tX8qSTxfjM5OUPI2DLkyd7dIelhiaNikmRBURxqaLiglTgznewPTCXcLqg65v/DNsW5v1+WEygvMkJxvI8ZiWxQ//0V3t9p0WjX7RNkyxRpsbVyDCWIXngAIGo612kHFiWH4OAs+gtZZIbLog70QqqQmPatAH+R6xlMHse56x0aIW3i/xbn3THryrdU4b0cO
 8RJl7nI5
 iYa/Mmh1ltNWq1TL0Ss0HekA0Us+FCKCqqAIfx5+AN48MZIb9DSUxYXr+x+9SGj3v/Q9/B9cGFjQ3esO+D9603p5JAgKT1dugjSNsBh6JJxPLGXW7jhJPla4wFDx8hUntcPAn/lUsASt1DR6f+DLQlTJ3xNAylmn4rQ9iMhmGrlh08yZwBHzpecTmNhnMc7ii2Uz9agYtVqPaeRp/dV8vNm9lWxkLUFQUqw4zuNoaDIuU6suVHfbGs9kjVb7XWXHjFoo85kot83uveWbeCKIMLUq785HQLrumcTEPuIPNe1qNclnyQTOsDExta/Ha+3BzjbZJFyU2E6WCEiHxWcAzGKsWFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Suren, Pedro, David - I messed up the cc on this patch.

On Fri, Jun 19, 2026 at 05:52:38PM +0100, Matthew Wilcox wrote:
> On Fri, Jun 19, 2026 at 09:37:11AM -0700, Andrew Morton wrote:
> > On Fri, 19 Jun 2026 12:28:51 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > > This reverts commit 7b32f64bc512b40b268776c5ac4d354b325b3197.
> > >
> > > This patch caused a significant performance regression, so revert it, and
> > > we can determine whether the approach is sensible or not moving forwards,
> > > and if so how to avoid this.
> > >
> > > There was a merge conflict with commit de97ae6222c1 ("mm/readahead: no
> > > PG_readahead on EOF"), care was taken to ensure that the revert retained the
> > > behaviour of this patch and cleanly reverts commit 7b32f64bc512 ("mm: limit
> > > filemap_fault readahead to VMA boundaries") only.
> >
> > I'm a little conflicted here.
> >
> > 7b32f64bc512 avoided readahead of "file pages outside the mapped
> > region", which is clearly desirable (arguably a bug fix?) and we care

I wouldn't say it's a bug fix? The kernel has always done this with no reported
bugs.

> > about performance of executable mappings.  Whereas it isn't clear that
> > we care about whatever the heck that test case was doing.
> >
> > IOW, the revert might make the kernel worse, overall.
> >
> > If someone plans to get down and analyse that test case then come up
> > with a new version of 7b32f64bc512 then OK.  Is there such a person?
> >
> > I'll park the revert in mm-unstable for now, but would prefer not to
> > rush it in until we better understand what's going on with that test
> > case and what can be done to address it.

As Willy points out [0], we've identified that it's a real usecase that we're
regressing.

There's likely others too in the real world.

This approach has also not been without debate in the past (see [1]), I think
this patch slipped under the radar on that front a bit.

So yeah, this does not to be reverted, and as a hotfix sooner rather than later.

>
> Suren did that work.
> https://lore.kernel.org/linux-mm/CAJuCfpH_Fp=J-m-kVZ3VVmqH0cAfNX6CQKWt3XmAJq1Rp9sFwQ@mail.gmail.com/

Thanks for highlighting that Willy (copied -> [0]).

Overall, if a patch causes a major regression in a core mm subsystem, people can
wait a cycle to re-evaluate.

Thanks, Lorenzo

[0]:https://lore.kernel.org/linux-mm/CAJuCfpH_Fp=J-m-kVZ3VVmqH0cAfNX6CQKWt3XmAJq1Rp9sFwQ@mail.gmail.com/
[1]:https://lore.kernel.org/linux-mm/CAC_TJvfG8GcwG_2w1o6GOTZS8tfEx2h9A91qsenYfYsX8Te=Bg@mail.gmail.com/

