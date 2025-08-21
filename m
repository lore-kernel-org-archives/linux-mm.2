Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01D0CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 05:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398A66B00DC; Thu, 21 Aug 2025 01:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370706B00E0; Thu, 21 Aug 2025 01:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AD996B00E1; Thu, 21 Aug 2025 01:41:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CB686B00DC
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:41:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 959991D9F3D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:41:53 +0000 (UTC)
X-FDA: 83799668106.28.2BDC4F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CF63110000B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:41:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZG63smvN;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755754911; a=rsa-sha256;
	cv=none;
	b=FOnM6RxSegwbUcfpXwUDta680qyBOqZwQC8SUwRg+IS1xBJ4iIYOvI7C2dNxUwKgsk5Enc
	XUi5/Wef5m/U36Dw52z6Eo4hd2K9bFHzTDuJ6Nd6AtRbeBbnmwYqn/yJWBfe1OxzYutzFf
	Mty0qlf8W+fiTvTflcH20wq+Yivl+dg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZG63smvN;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755754911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NxGLUU6rth3OqATT65y9rtxixyIJ9ouDt7NT6vNgjYk=;
	b=4iVcmqS8wTBiE8HELQPLLJXV+OSysONDrf3C6D+EDnbTNvhUdNOfkxjotLibpYzy9Q2018
	H7RLOwBTSiO26ra2xPpaYXece/7C3WdidZ75XP7bTzz3s/NOo3HxLsh/eDCWQqJjSbauGp
	YTSbAtcH9jazkScjAQlLHDqsrGRYyQs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AD1243E02;
	Thu, 21 Aug 2025 05:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44144C4CEED;
	Thu, 21 Aug 2025 05:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755754910;
	bh=JMtuIIvFo7J8JQhB3++74nBLvQexz96KHhNj/me0ewA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZG63smvNblF919/9nV8D4Hi36RuJURGwi6Upoz20ZjFw5cvdW/YdH/FiYZ+m3faF/
	 3s8oi/b6esDoLbM0iB2VseDM9dkx8e2abm/Xqsd8ViptL1yw6bkyMZ/EhRAFoOJNur
	 GO9ZEYXrxeCk+/e2HRl9G8i5dTWNaCTSdUvZvADIrB0hhBIh3YkbY5nQjFiGdzegDy
	 lIxBLnZyYeKMxCyCnZPRjuRsyiqJ9uo6czKSGihvd4k8/QPeO48wGPZjGjUoU+o7GN
	 HxcdOXeyj548+5xlUyh4kHwqaKHtRk+QJlxbChbludtkb9iCLLf+PZQdTeDjNXuL4m
	 Ui6wIYhSvDHsA==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Wed, 20 Aug 2025 22:41:48 -0700
Message-Id: <20250821054148.53746-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CABFDxME5ZEAn+6=0GRWybTi-xBzbhhz7U38pMni3SdKjA+Aj-A@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF63110000B
X-Stat-Signature: gjgdan56kyjbxuct6i9iz1kid6e9gwmw
X-Rspam-User: 
X-HE-Tag: 1755754911-425062
X-HE-Meta: U2FsdGVkX1+FlHLPpA8sMeuVIzBib89Fbm2CvUystxKnJ3JGnThEXukGWBFGx/+HF7XIo5y9OC2BMkEk8naczAgZpmY+TeB9YkwThDLC7BggmGBfvcGe/oWlGMiNUkxqMD3ARc4PHmthGobZvCq3DECw34PK9HycpET5YXBImNbmzEL1cx6aOpCnVcXka5KZhYBE0b37M/xB8XK4khzURQ62wn0Uhgqpo1kkTG67xNEivuKlWcoU2gAVRVIHG4SBIygOq2L//e3ETF/YxsgkuHbq09jKQTMqpxV33hXhLMKk8fbeTff6PXl91a94BlcQiOE3Lzi5ROCnhk0XXLbHBOmsvBbALbrcOzaiNaGD5dGwPnm2WUAgZrgd122CtmcWqgqjw83DsgkQZ8L6v3f5IJ3zBuUXHpFQj9tu4da6iXsDLHmcW9HEQp577EO+0+v5TrOWmyVwnrJkKfrG2aqLvbkIaWeZoDpbOa0oGQ/pE3xzSPBPJBJe8RbN8Y3IFvMHGSSiX9DwCLh3vVWUTKWVs0qRSCHVSyDGU6+ApwsDygz4kuaKpCVVro2VourpTWcqOmmmtUMEVaHMIE/thy5kLON9luPSJPVl3HJmNF+tGCyt962a38t6pWCBlh5GBNaMzu3FqJF9HNXOXPbRkWzxuQMz/bx1XUlwqvxguG4z8OHu5AxJgS/f0gUBixyv1k5ysPnJyNUVl09Zu+JOZdxpR5IuABhnTPZLGEHPm21QDEG87gwiw65WZBSvIj0I02J89g/8xGwN8j2AM8HXHDEJllAJAkkmPEtr29x1odFauX9bWxgUwZOA1xWcPiO2D8nnLcIs+S9XIjGl1qLaBJxalv7/mN887UZHuE6SY3JcTgJSKwHaBXCk3C8ftsCFokA0yuw3FS3bSaZF1NWj9pqpHJNHr0rD01t78xDU00+GxX5HNdw5jNkzWxwxizdCO+pn9kzNSSuszfGv0IJNZkP
 wsW9gdrw
 6IbcTyyNfbfLpHKBKP8j9WLCXHZT3nSD3/1PiDymvATpREVpGY1uDz3a4irWqhFSHS+UTVABu2KUSaOMrbRlMCXeGLrB4GC82nd+C/9gpmiCxgIhtVoIuN4P9FefUBZQcKus1vCgk5Qt4YoOkDTHpdbHd2QQedmS0qASj3Nq7Kf6BdfGHQVV++BLG3GRqWiGTQaNyrgdhsImR7OQQUNlrjxemGyW7OKnkeTuczlzzGrux9jhdZh5+dgFPEo+/nUHxmsYvt5bZCCVPj2+1sO+V3P3I+CcnVhTLXkIAERW2/GDXfzQRZUyaGKe4UoBIcJsXFgAf9QLY0RgsUt0PRjZ05DOSmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 13:29:04 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> On Thu, Aug 21, 2025 at 11:54 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Thu, 21 Aug 2025 10:08:03 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> >
> > > On Thu, Aug 21, 2025 at 3:27 AM SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > On Wed, 20 Aug 2025 22:18:53 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> > > >
> > > > > Hello, SeongJae
> > > > >
> > > > > On Wed, Aug 20, 2025 at 2:27 AM SeongJae Park <sj@kernel.org> wrote:
> > > > > >
> > > > > > On Wed, 20 Aug 2025 00:01:23 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> > [...]
> > > I think that I checked about user impact already but it should be
> > > insufficient. As you said, I should discuss it first. Anyway, the
> > > whole thing is my mistake. I'm really so sorry.
> >
> > Everyone makes mistakes.  You don't need to apologize.
> >
> > >
> > > So, Would it be better to send an RFC patch even now, instead of
> > > asking on this email thread? (I'll make next v3 patch with RFC tag,
> > > it's not question of v3 direction and just about remained question on
> > > this email thread)
> >
> > If you unsure something and there is no reason to send a patch without a
> > discussion for the point, please discuss first.  To be honest I don't
> > understand the above question at all.
> 
> Ah, I just mean that I need to make a new RFC patch instead of
> replying to this email thread.

Why?

> I'll just keep asking about previous
> comments on this email thread.

You said you will send a new patch instead of replying here, and then now you
are saying you will keep aking to this thread.

I'm confused.

[...]

Ok, I think this discussion is going unnecessarily deep and only wasting our
time at clarifying intention of past sentence.  Meanwhile apparently you
understood my major points.  To repeat, please clarify what is the problem and
user impacts, when and how it happens, and why the solution solves it.

Let's restart.  Could you please rewrite the commit log for this patch and send
the draft as a reply to this?

We can further discuss on the new draft if it has more things to improve.  And
once the discussion is finalized, you can post v4 of this patch with the
updated commit message.


Thanks,
SJ

