Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D03CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 05:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3285E6B00E1; Thu, 21 Aug 2025 01:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FFBE6B00EA; Thu, 21 Aug 2025 01:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23D586B00EB; Thu, 21 Aug 2025 01:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 187706B00E1
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:43:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 672E71DBD69
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:43:54 +0000 (UTC)
X-FDA: 83799673188.28.51C7D40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CF13B80004
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:43:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MKOLoolX;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755755032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pTvsanUWoBaejWouvp7fsU2byoIYqvCJ9DKWrUenbC8=;
	b=SCmn8CI52DKPkAlmP5V3uGwf4QC/jIjpaVX6Xzy9+36t8zgcEdoaLkh6rAOewBojIMfwhL
	0bl8j8PZ3dWElNPSfTPrjDqqQ+G58Odv5lACd3QqOEefDJxKTPxz2i7UCcWQcDNEPYK6IW
	t2ZWPzSbUt20wOFjuQrJX7fJ8YO4jMY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MKOLoolX;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755755032; a=rsa-sha256;
	cv=none;
	b=8b1/B8tmkZBN4oaYKkv/ydY41Oko+XiwPICsRVDq9DKE4Khrae6VUfbWGkkNb+FomycEdz
	qyqcFvBKiP2ARqMh+Jh+AVRzwrlX72+0ra9iLE+xwEi8vVX6d9UEtKLWiVBRKIaf3Y2c3j
	mrxkoGv+xGwYHvyEhImlNMxJwl6FH9w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B3A961138;
	Thu, 21 Aug 2025 05:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95591C4CEED;
	Thu, 21 Aug 2025 05:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755755031;
	bh=wslDGFckcPcpSuCYM0gIHtwPLeSyL94Zl1WSFhikYZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKOLoolXYQgU4+4/ayOBQeg1NhhN6jqhwTGUyHdOP5KYTBJEoUR2DHP8JdwoR6Iax
	 NdPTTkxgSgUpVVrgtDLfUTcC3V/v/hk40V9cUE9A4hUT8u+rNxC0X+DZQwb4EWji9J
	 4eAeiL+vrgMnaY49yxWDn2dYRAZXz3q44PAEPbuYcOapOsFpyBfp9NsRAIVtyLiJ8z
	 217tSLRuV0G3S01ystBbpw+fJXf4BLTX/wNEJJtyeOYZB6hqcHMlPmllkW49HuHWf4
	 IlZYyjypoz91OyMSs+vXrQ5iIXrn815UBENGVewk9kxwMlBzIQPDJSyaTNzemYBuAT
	 QxzXYs/D8bLXA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Wed, 20 Aug 2025 22:43:49 -0700
Message-Id: <20250821054350.53849-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821054148.53746-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CF13B80004
X-Stat-Signature: knmfm7u9fh8cjncubjjwqw83q94cx1ni
X-Rspam-User: 
X-HE-Tag: 1755755032-689171
X-HE-Meta: U2FsdGVkX19jkiJeVAG8sRD1fsFVn/vYUPOvMbj/AliNj80qrfIguhSSn6oPNjpPUBEWci7ksxcOnlwLKtjn6cjLhkR69LU9sXtwnu/ASpU573YHyQcHw2zo3ET8E5ULdmJK/0AFzBs8OdT48XMjjgXvFJ2Z1BxeZooP4U7o6iqGZo6o9SSfFpT/+1iWMeeUdqlYzXztYhiX3MT8Y3GXwK5lHK1cwFUlMaDJPEDs5+cv5A7XPwgwHwX2c0/NTrqNQSI7IkHAh4FYFBY+IkcnT7olWOZaj5M/8Nm/GDOIx+bZqWqIrOMeTVQBkBuAVyKKP1QAKXWnUevUgUfDX2+4i686+FmEEwjA6gOpKHa/X8DY0Z7tJS/t/NqYDHrVdaHo0HL8SwKJ7lbXOOwWqjy9QL6v2I/NHqzIUVqKXGTacb3eZ3yLQoi/zQwbiIXi58gh4FEQVjuL6x+Rbzf1xC/VvmZzfT9XconLye2wDSUJutv1yW03Ins3FoWYRBJ1OLRUAC/gqdKzjdIv1nsJ0kCoLgdO8P/In0JSYw0qPQP7/+iodsyWNe7O2VJuBmPmfzlG8RJVAB9tIc5A3y1ST+2aG/0LqPG9+jWIykr5a7wEKlpIcOpTgdb8Y+xv3wSzXODSUiwG5GOtq+Z0aELDWQjXTDfmsDf5OWtQNT6V5be+hnBXkC8TLjipTlyFv4ilOOGknt2j+rMwkLSnv2nBcPCAGW0fp1SFeRlL54RQV3tc/nosAx+H1GgVrdEaJSrcdaxG/4Md8Q0A/BiuNF47egVbaal8BLDEfEpimwUQ3IQKmtBuQ/y8ZDT0isBxlE/VPNetg9jwdYk6rW42GIRiTfh4oysZ52Zx7mMOAsjVMj6YLKLsGk/kReprpSrIGZp67TJa/MiZve4Y9ewaZZpj0Icta5VwEHn0GXmf/r0SAwlLkRE3o4ugGRX5brkJOItVejdlKqyaxTCXtbHWxZZ5X/Y
 2WC4Envk
 wiPqhic5Sh7UQmXABxhThVp0V8dYYKn0p2x1sN92W1ef/LeOyFLk3ZctBu3Kqc2efxGMTCK/vft481yF61wzSooAFxFU/Gz8TczqyCAVSbKpWCtnrKQoYjEiFiwggTcfq2Q+oQob2MBcb1D+MAnFubekNoRMOidt7INpa1sSH8NBEGC7pU9X8sOP6R12IT85rI9wZownSqLC59CZyWOOTORjuq0dLHFtMIAZx0LCzc6pSb12+7OUlyqmoi68aPYR96IFrhue1PVBuetskbqckzNFXlIDIY98cpnCrQPdl06lWHThDQ6s+atL/zZ33dv4BRopHwbXHm3PS8hU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 Aug 2025 22:41:48 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 21 Aug 2025 13:29:04 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> 
> > On Thu, Aug 21, 2025 at 11:54 AM SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Thu, 21 Aug 2025 10:08:03 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> > >
> > > > On Thu, Aug 21, 2025 at 3:27 AM SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > > > On Wed, 20 Aug 2025 22:18:53 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> > > > >
> > > > > > Hello, SeongJae
> > > > > >
> > > > > > On Wed, Aug 20, 2025 at 2:27 AM SeongJae Park <sj@kernel.org> wrote:
> > > > > > >
> > > > > > > On Wed, 20 Aug 2025 00:01:23 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> > > [...]
> > > > I think that I checked about user impact already but it should be
> > > > insufficient. As you said, I should discuss it first. Anyway, the
> > > > whole thing is my mistake. I'm really so sorry.
> > >
> > > Everyone makes mistakes.  You don't need to apologize.
> > >
> > > >
> > > > So, Would it be better to send an RFC patch even now, instead of
> > > > asking on this email thread? (I'll make next v3 patch with RFC tag,
> > > > it's not question of v3 direction and just about remained question on
> > > > this email thread)
> > >
> > > If you unsure something and there is no reason to send a patch without a
> > > discussion for the point, please discuss first.  To be honest I don't
> > > understand the above question at all.
> > 
> > Ah, I just mean that I need to make a new RFC patch instead of
> > replying to this email thread.
> 
> Why?
> 
> > I'll just keep asking about previous
> > comments on this email thread.
> 
> You said you will send a new patch instead of replying here, and then now you
> are saying you will keep aking to this thread.
> 
> I'm confused.
> 
> [...]
> 
> Ok, I think this discussion is going unnecessarily deep and only wasting our
> time at clarifying intention of past sentence.  Meanwhile apparently you
> understood my major points.  To repeat, please clarify what is the problem and
> user impacts, when and how it happens, and why the solution solves it.
> 
> Let's restart.  Could you please rewrite the commit log for this patch and send
> the draft as a reply to this?
> 
> We can further discuss on the new draft if it has more things to improve.  And
> once the discussion is finalized, you can post v4 of this patch with the
> updated commit message.

s/v4/v3/

Sorry for the typo.


Thanks,
SJ

[...]

