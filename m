Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9281BCDE00B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 21:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FC026B00C3; Thu, 25 Jun 2026 17:55:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4DD6B00C4; Thu, 25 Jun 2026 17:55:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1133D6B00C5; Thu, 25 Jun 2026 17:55:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA46C6B00C3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 17:55:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50BE11401A3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:55:40 +0000 (UTC)
X-FDA: 84919792440.17.29B5F16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0DC0BA0006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:55:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ekAcyCZX;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782424538;
	b=yLwC4R1jvdAjp6gajK9ghonp/108IhC6dD6bwWurVy6rGx2S0rq6YojkZd0ED4zJmX4qkT
	YFDn5C+NDzvJ79iCU5SEqspwOrYm/fIVm3abRwnksWBgbksPLhXUxGR3w3tot4A8jtN3Xl
	z10p8FJL+LZEYIRe7zmFSzoxLp7LJpg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782424538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rt4f112zSrueMWRT0WzroueLIIukufkKMPXRV2puyzc=;
	b=5ELioIfXfVMXCQ4a0I6CWUBUExcXfsTHgod34xmF+HlP1QTjFxLOOqW2y+We25sup6OY39
	DXselT4KepAmti2EBDJaDrpTvbPivcnf9Opd8HCexsQbkS8eC9UuEuRXN5M45BMt1nTsAw
	jhZ7yfX9hUMoXTVIThq1VbSu/E1bf8I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ekAcyCZX;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21E8242B5F;
	Thu, 25 Jun 2026 21:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8F61F000E9;
	Thu, 25 Jun 2026 21:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782424537;
	bh=Rt4f112zSrueMWRT0WzroueLIIukufkKMPXRV2puyzc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ekAcyCZXr3dZ7UwCVUku4sKOE049YiBK7w6TEcedNJyVde5+DyZaslqxTG+wqI6QG
	 ms/kGfn2/eAMFmCgOJtHVOXG97wSzBNN78JxEdx2lUgv699RrKmq8w19sqzzhGBx4j
	 MV/13Ye2SEy2fl7zdkj0ImvMi8D3TIWeiEymqnJ0=
Date: Thu, 25 Jun 2026 14:55:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mm/page_owner: extract skip_buddy_pages() helper to
 unify buddy page skipping
Message-Id: <20260625145536.53d92da2fc695d1e5df70d02@linux-foundation.org>
In-Reply-To: <43a99a8b-3c27-40a1-bcc1-77112eee6c15@linux.dev>
References: <20260623065234.31866-1-ye.liu@linux.dev>
	<20260623065234.31866-2-ye.liu@linux.dev>
	<20260624172025.3087e8d574285bfa8d6772e3@linux-foundation.org>
	<b2e7646d-346b-4eb8-aecc-d70fad3a28f7@kernel.org>
	<43a99a8b-3c27-40a1-bcc1-77112eee6c15@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8tcijww636yieh938y5r4ojozsagyb7y
X-Rspamd-Queue-Id: 0DC0BA0006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782424537-628743
X-HE-Meta: U2FsdGVkX19EZidz6RTH08mfjud66yN1inMNAdU/GiwnpCyD3lWJb+3+9DhjwS0D372wa74Ch9MBLnktD+gSd9zFmjnludOc6EsvMGnReF3osJQlvJD02P4cQryA3zvrjW2K4Na756Im/R7MvAHU+H9jOtCsTS2OUZXE5eRupDVX0TKLkCfuWU9SYtnhUGuzOaQhVUHasKORvrWlCm/cTTdGNm1qVEfkiauN9wmQXznjMWhCutXv4LvYDhknKOOWVO0GgXmDXPBYKwkAK1S3EQpb3GptM8MGEuxIVxamThBhSbjxibzuES8CEMPaoAw3iB30WPl4mi8mdl1qVkw2YIR6KGxHE0dVND4mpXrDCh2CVaZOPozEV6g9zVxYEBSKquPWkgdgC8dydVNOp3XdHy+8QVEh4QkGi/vcxJn948yeJsLCQlFmsKJe5+XKHj8+FhZvDgybwK1EIyaAui4aJSIrg+GzFQ4AkTb7uul5fibDhYlsfd+ifcYGk8ok4koDaAg/FHJnEOHuehwAjZ4LcjJOjaWsE5bOtSvwbS6kCwBYY3Z95zmHQgilfdW+3Hwc6ciHFd6/HJ0NIr+/HuU/eWEF0y+s7WRDZRKR+NUOf6KHbfAN/tnjAQXzpOXfrNXMtCOVUCHCJtW5XYHP6wE2pYPWjHQs+SJ/m5eHBF8egsIKOSWic/MzFcao++UMbOTVieI28+rI1mJKkszE8q8mcrwVbiTdctf+N8UThxEzZWsPP5MVXXkRsNjvxIU4/72JaE4hS/bdxfAl9mfOgZrmoCOG6HKFHRQ2dqk3bbrWWqtxrzDtA+VTzwxaVBW/80yEwZO5G3HZHgK9wJ9VxZ7szF3yyUQ6kw7h3xGfiMgI4sfMQ48Ruj8qs0YRwnSacSISwcBIW84oamu2NNRvn/Hin+uycsQKCwBqiKbV6h8fXiJRB08VFPOc5s7y1rsxjjfFYMx67z3T3z6aVXRnqjp
 rsTfsexf
 kbDNB9YDUQBqdG/jngQUAZOjlG4+EVCaQX4TG8ENPDbWaJFNeD2xnrg3ESNgPPf2Fr5Os1/lPmG+Sf/wFwhTfz9QEemKmZWAX2Buek2SmTqsJsuNb5/eWM2gq819GVJEmFpwTA9tEkP/E498EiWphj9yIUg11hPzmBcM+hvMJa+Xr7JLr0qx86sPA9dhrB4CZPvp7vT460ga50cQ9QAaOnOYwWc4mRx8/HEtMlW7Lm0Cw+IBKEvRTTaFdSgnJSF9EO7+yyPtulzCyFTpZn/Ub2Kotnd3Sup8bCQztjPiVWyJonfyUpjqXWmlZihKnXwYEoOL1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 15:31:08 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> 
> 
> 在 2026/6/25 15:13, Vlastimil Babka (SUSE) 写道:
> > On 6/25/26 02:20, Andrew Morton wrote:
> >> On Tue, 23 Jun 2026 14:52:26 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> >>
> >>> Three places in page_owner.c duplicate the same pattern: check if a
> >>> page is PageBuddy, read its order via buddy_order_unsafe(), advance
> >>> the pfn past the buddy block if the order is valid, and continue.
> >>>
> >>> Consolidate them into a single inline helper skip_buddy_pages().
> >>> The function returns true (skip) for any buddy page and advances
> >>> @pfn past the block when the order is valid; returns false if the
> >>> page is not a buddy page and should be processed normally.
> >>>
> >>> The old init_pages_in_zone() variant used "order > 0" as an extra
> >>> guard before advancing pfn, but the continue was unconditional and
> >>> (1UL << 0) - 1 == 0, so the behaviour is identical.  The comment
> >>> about zone->lock is preserved in the helper's kernel-doc.
> >>
> >> All looks nice, thanks.
> > 
> > I got a bunch of "added to mm-hotfixes-unstable branch" mails, but this
> > seems like cleanups and nothing urgent? Was that intended?

Yeah, sorry, I soon after moved these into mm-new.

> >> A [0/N] cover letter is nice to have.
> > 
> > Seems like it exists, but wasn't delivered. Lore shows its message id, but
> > as missing.
> 
> 
> Apologies, I accidentally sent the cover letter only to my own address.
> I'll ensure it goes to the mailing list in future submissions.         
> Thanks for pointing it out.                                            
> 
> Subject: [PATCH 0/6] mm/page_owner: misc cleanups                      

Please send a full v2 to tidy all this up.


