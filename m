Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31335F532C1
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756D46B00A6; Mon, 23 Mar 2026 20:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0F56B00A8; Mon, 23 Mar 2026 20:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7C46B00AF; Mon, 23 Mar 2026 20:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 445386B00A6
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:05:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9492140DB9
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:05:41 +0000 (UTC)
X-FDA: 84579012882.17.D5F5E2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 288A412000F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:05:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yw+GUCPo;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YXJBAa7WAwf1jzHyuKmp0V1uaiOVC3mWP3/JR6jQH+Q=;
	b=23ttbTGNvsXI4jMo/caU+eO2w+xmRP97SWQttxA+mlrXbBAF7aEZq81rl1L9909dObopmO
	beF0+77cx2GiwLvzBZSxZEId7qQ7GGaB1uChe8YRnUQzuK5M8QuS0COXrqu0TesBRvfYEY
	IwNd4/Y3AOwfcuaxCxEQfSDhFhJ6dJ0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yw+GUCPo;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310740; a=rsa-sha256;
	cv=none;
	b=06yAvlSJob8N1KF5hEbNEnDnXTs0NGdeN65vBMQiD9fLmsSFi23QST5tk4lMX7CTPD7T2w
	u8hqJk8/AAxYZ4x+X94dPfMRfoq0bGJO8fb5AEv6YoJ8LTmcrNxesHSwCA3t2NgfaIX6/i
	HG6OHYNoZrMPZilbY3WOwy1INPRCxxY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DE42A41B55;
	Tue, 24 Mar 2026 00:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D8FC4CEF7;
	Tue, 24 Mar 2026 00:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774310738;
	bh=JZtG8qX9+rZLGaV9iv2qDcDjwAssk//lP10kEXRkSyw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yw+GUCPoqs71HSdrdaOegL3LcPLTbvJA53NMcFKC6pxh/Z6csXuDhercKGoOGqYvF
	 P5nB/k6r9UnFbhOoxtf2jbMvuc/qw0i2l2Q8McIANU48c0ZPYsgIcZNUWmL7+13IyJ
	 XS2Zs8HwdrSEluumgR06fl6V3Hknh9oD96pwIHX8=
Date: Mon, 23 Mar 2026 17:05:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, David Hildenbrand <david@kernel.org>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
Message-Id: <20260323170537.0aee4e4906169db510e9893c@linux-foundation.org>
In-Reply-To: <4fb7fzdf4uirsxlxiwd4arbhlezgrawb72nm7sl2slntvxlng7@kimmnebrr4c4>
References: <cover.1773924928.git.ljs@kernel.org>
	<20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
	<87tsu9kgv3.fsf@linux.dev>
	<20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
	<20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
	<5cd57c69-7193-422f-b6b5-75bb5234e5f3@lucifer.local>
	<j6hsn4mxnzoukebcdggu6ojkyaj54joohocbbkrzksm47km7ni@zzp7aurwmto7>
	<20260323143604.603b20aec4e3ab77cabec107@linux-foundation.org>
	<4fb7fzdf4uirsxlxiwd4arbhlezgrawb72nm7sl2slntvxlng7@kimmnebrr4c4>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 288A412000F
X-Stat-Signature: hedq69w3op53dak8jrpgibkt1gxp5fwj
X-Rspamd-Server: rspam06
X-HE-Tag: 1774310739-585715
X-HE-Meta: U2FsdGVkX1/YkpopRuxQWEl5TYzjzJ638rCnST3LpwxAogNdCk9aWt+xczd7THpqrbshPToi5AdnvICp7qD0MJc0ziVoj1HGThWa6rcvR/0a0BZPfwcXl11e60w1cIjfEaLZLsHohvFbFsvz/lUZSJ2j5MI5WSf/RhNvROFAiNts8R3w0aY/IRcDe/Gz5Lc0EFg6eBAxBKWPH9MbDh6lA5Ra3YQDxFE5n//izPu0zD7bTb9aTs+QEZzbtHBay3Wm/GYgVv7z834kyWWrZh2vyv0sDzuRJ79jWyvVhgGCGguJwPlM2CQlc5Er6rEAfvcnuZeqYx+Mm/3k76eMbytodSikYsVmyvuVfHqLj1lS/H8EsJ7QbHlzeKL2WCh0NEzDXZJ08OgAYP4GLNGom8ORwt/c1idweiz/Sh7GbtwlVQRk/nOAJo6BUbitHzMFJXpsTda6YHD6YRPhN9WYlMsuRtgzTkHhkgpZTQaR4nbdGPRh580PBXRrsxBU+jV1c9cmCgq98DMZXDj3KIFzv39Gdv80QWpYEMIv9c302ai+Z2v0DFt9ejsgfslfCs/a7PE3g7yPmtfSt6hcgGnQwTvH4PsfPTboOQPmj+XvsRPCxciNnalOBXz8eInX7+j5itxMhFLt/v5mtmUHCFKLOmC35ygdzzOsqGEtDxc4BRES1zPW6baDj9yHS6MjLuyuzy7y9uwKbKTQjO03Fx3QKO/TAyPx+M0hVsCHeKFc/GLc9cuhL2WQjbJrtOqjCcN+/ksiHwYw6rAIH2gYxohmfU9HVNzKljwfdNfjQ7zrniRgL1rNUL278h8K3PIpqL5nC1ZZaoMDxoZ++nAvNui7k7bIpiON3JgJ5Kvdv8xQlINXczwPJNoXEti2I3E3KiIWme4fLkZiN1D+h9U4p+zlcpFwY5z0d+ynnDbBGJjPhMhW1DWv2ioKaSvSJwxn102EXxLt9gNqw/QLQADNT0P+Zw2
 H3qXyHbg
 AS3J/TFFFKr1n9rvhbfO1eHY91/a1EpbE4dpYjisB5o3NuiKd4dRK1ul43Tiht2eyfd5CtmlAPF3C2RaQcrPEQQkgt4YKRIeSgzbPbvMNDYgXS5WVDepiuo2WZ8TyKDaGPrX5TJvMq+y0QzSeXSqWEUXMgZ0L9DtjLpEGYthDuskZ+4NTG/cvzKqqUe6mnXBQSDHZKZSMDhHXKKbP/Efdstsm0sJh6gKYupODt7pg8765RlAoAzz6QCZKLoiqM90lkXJ9r14nN/m/+76cR+cli+GapzNS3Q5I+uU6E+KYDh6wywijfkzlV9E2ER00nZkY18IRofrJEw98bJ4Wf4GlDXFT/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 23:27:35 +0000 Pedro Falcato <pfalcato@suse.de> wrote:

> > also maple_tree), the amount of such unreviewed material which enters
> > mm-stable and mainline is very very low.
> 
> That is not what I said. I said "we don't require proper M: or R: reviews
> on patches before merging". Which as far as I know is still true when it
> comes to the process. If I have this wrong, then I'm not the only one.

People never define what they mean by "merged".  I define it as "added
to mm-stable".  Things that are in mm-unstable are unstable!  They're
subject to alteration or removal.

I pipeline things, a lot.  The main benefit if this is that material
gets sometimes *weeks* of additional testing which they would not have
otherwise received.  Also there are integration benefits - inter-tree
as well and intra-tree.

If something is getting close to mm-stable and doesn't appear
sufficiently reviewed then I'll send out bleats and if those don't work,
it gets deferred or dropped.

And, btw, it's really bad to remove material late in the cycle - that
means moving an untested code combination into mm-stable, which adds
risk.  For this reason I do ask that M:aintainers and R:eviewers be
attentive to material which is in mm-unstable and to tell me as early
as possible if I should defer or drop it.

It's a mistake that we've never defined the roles and responsibilities
of maintainers and reviewers.  If we were to define their
responsibilities, I'd place "take care of what's in mm.git" high on the
list.

> The fact that the end result is still high quality is a result of your work
> (diligently tracking down review states; yes, i've seen your quilt series file
> and its annotations) and every single one involved in the review process.
> This is not however codified into the process.

Yeah. mea cupla.

> (note: the fact that DAMON and maple tree both lack reviews from !authors
> just shows there is a very low bus factor at stake. we should fix this...)

Agree.  It would be a long haul for someone to effectively pick up
something like mapletree.

> > 
> > > Like, sure, sashiko can be useful, and is better than nothing. But unless
> > > sashiko is better than the maintainers, it should be kept as optional.
> > 
> > Rule #1 is, surely, "don't add bugs".  This thing finds bugs.  If its
> > hit rate is 50% then that's plenty high enough to justify people
> > spending time to go through and check its output.
> 
> I agree. But I don't think it's flawless enough to become mandatory.

Well, I looked at some numbers.  Data!

Searched for linux-mm emails which had from:akpm, message-body contains
"sashiko".

22 emails received replies from authors indicating that alterations
were needed.

2 emails received replies from authors indicating that no alterations
were needed

1 email received a reply from author in which I wasn't able to decide
either way.

A few more replies said "no alteration, but we need to change other
code".

10-15ish have yet to receive replies.


That's a really high hit rate!  How can we possibly not use this, if we
care about Rule #1?

> Sure. But I'm thinking about the human factor - I simply don't think either
> contributors or maintainers will be particularly less stressed with the
> introduction of obligatory AI reviews. Maintainers are still hardpressed
> to review (as is their function), and contributors need to go through the
> tool's output and figure out what's relevant (and _true_) or what's not.

Yeah, it's a matter of figuring this out as we go along.  It will be so
much better if/when people are able to use sashiko privately.  But
heck, people forget to run checkpatch ;)

> IF we were able to codify the MM process like in (https://docs.kernel.org/process/maintainer-netdev.html),
> with things like:
>  - NO patch is getting in without being 1) written by a maintainer or 2) getting Rb's and Acks from M's and R's

Sure.  Where "in" means mm-stable.

>   - Ideally both, but maple and DAMON need special casing for now, I guess.

We do get quite a lot of patches from sole maintainers.

>  - NO -next content is being accepted during the merge window. straight to /dev/null.

For sure.  Well.  I usually park these thing to take a look at after we're all
merged up, but it's usually all stale by then.

>  - review state for each patch is <here>

I generate that now, with the occasional "mm.git review status" emails.
I could run it daily and add it to mm.git or something, but this
doesn't seem to have generated much interest.

> I understand. Ideally, sashiko would be a tool that maintainers and
> reviewers (and submitters) could use to help find problems. I don't think
> having you check every AI review scales. But I also don't think we should be
> treating LLM output as if it were a normal review from an expert.

Sure,  But that hit rate is so high!

