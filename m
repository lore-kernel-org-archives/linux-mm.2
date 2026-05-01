Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A398CD13DE
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 01:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792946B0088; Thu, 30 Apr 2026 21:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743A16B008A; Thu, 30 Apr 2026 21:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632B66B008C; Thu, 30 Apr 2026 21:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9EB6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:56:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 028421C0476
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:56:11 +0000 (UTC)
X-FDA: 84717185784.02.90A549A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1779A160009
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:56:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SFjIjmRL;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777600570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTr5ixRj0OwS+uiR39MnJGmq9C7ROF550klPwrUqBFo=;
	b=ciWWuCTjC5URJclw4MhPd9lAc70OS8wcMXZtX0Tj0ExeQeQ0Ejhy2yq3zMNe101pTyLQjo
	PjxmSR5REYPbtZNjR50Y6UzS+UDQZQMqX53Zvok465k+qURnTheALAcrY3MVLvMjZX15lV
	FDg7RgnPLsvJ+VrAm/6xg+pu7LAMqJc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SFjIjmRL;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777600570; a=rsa-sha256;
	cv=none;
	b=nPkGj+msZGLc4+DmPiY1eI9hcyi58+MBvMp4ItSrW7gWBlq4WIxJ2fc2WU+e9Q+6S0IG9H
	dSOmPUOR0+uMd3GsJQCKdzOMAuBaGHsGhhmbIvQWsMzWJ5LUpLpb43YuHHtYhqsJPPoyRs
	mscB+58d2GpbQN1v4a/swGHZ4bqoOt0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C541404F9;
	Fri,  1 May 2026 01:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DEBC2BCB3;
	Fri,  1 May 2026 01:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777600568;
	bh=qzviNm8rnhp1c0NC3tvj7ydyyrxohLehCvxK6danluE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFjIjmRLHJwtVZaHIAzcwOOFWelAi76TY8UEznldmWeAh+LSB2QMEyWImvw1GhK49
	 jUnJjSMDGpR8zaZkSNB/YMvABpAj6pJRjUt4uR5T0QdyYaWsBHKSFXpwjDF+OWJdcq
	 NdEGrMZU9DS0eC7wsE8RwU2R9VLoqqM46MYuMLwrpkt69iKQR0CAXZHBZRirUVery0
	 P+bjyt07fat5KFz1lQlbYSMzvJg4o8tQgq8U4AQUgDBofrvv3qtykX9LwH1Dt03opA
	 ndFFQSZvm/9qJTnIdPXQ9+gSLKByzr5tMFxSE5+hjJ0IRLEWT7mixx2gB1ldj0grK6
	 MhnTEY9TNtcJw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 00/11] mm/damon: introduce DAMOS failed region quota charge ratio
Date: Thu, 30 Apr 2026 18:56:04 -0700
Message-ID: <20260501015604.83041-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428152424.125760-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1779A160009
X-Stat-Signature: 6c4nzm84ejaqu1u978wf9o7b8ydwodwa
X-HE-Tag: 1777600569-385066
X-HE-Meta: U2FsdGVkX192Am7gZj5i/z/mrzfoA7rv5DlCPCeGPE75DQs2E+TXTuANQijwFkH9rDzho0/3hl2p32OD04ErIvbc+51viz60eY9dC2tsTe6Lw1c5sUZiOKbt0Tv9d4OMb6XLgTN7DhXJZNct2YfYaS/gs4a0NlHPDPi3EZPI3/yV4Nl6WDQlEJUsy+N46Y4g5HiqLQZ2d9xt+2EixyvE5/i7Ju/g2ZfPbwNjD93brPyjaTEn/OJ5Q3mhPZetjOc8OM8ZgOe74dmJ7d5NyxTe3rujwRWtBaeQB8/hJBzZN9JD1GCAJfwNB4tFuR5sG8IGtq9UNCJcDkbBSw3gOLKOhemUiNCOs+vrRriAMRsmRrqdFbRLGm8q5dx5q/GAIkXBQ87I7Sp7Iw5fg2VykjuyswifPG3+tAvTMAw2KVYv8KVPMUwzB5958Y6L8qOdQMOI/ySq2GEv3L+39Y+c6Jc17kj319Fgq6vh3plN0GKPPdn1rpXDXGeCFblTMtOr3XU3Fyxt0FRopRyKqHzv9doLw47x0t/V6JsrQbRKd/5J2awtVs3DCab4CBqky99qpr5hAl+DhHbIpUr5tn/efFFHtmTVKldCiKdWl/wWyR++OQuNvZ2NYATMuQ4hG8L3q2LLgKAdDGWhV5orII8Li9kyqvCknUExRxtuxeuU1fXuncnZL4FKaUr40uge4x4SiAbqR2LtjRf1NxejzHttrQsBNQaY5k0zcCCGeYkN91CWdZzk2ETZRIt3F0oLJIfaxexJWUnaNSKzgcNA7Rku8ekNBDyvTA7qnFRoOtMIlTBJxvIf+7JzQL5mNULUu7Y0aePjmIcm+XTOTAEXsLxyOpMA/9AkDEnVZOHwgK58pTo49uFNXXlK6u6v/l6BKsgOMgI56JtmFltJqh2tatRX9ayKDZUc9aje8H5HPK8IWjJRas8h9DjhCG2RCksBsytKAt44Ze66/7Gn/EvNc0e7u1N
 Ki3LDFCP
 qRWsXAX9xSXfKIm0MEG9VvYJFgHngqGnzEsSmysQ//VxpcPWSgNLnddz7VQiA2EzSalglttYX1N6oZLdMwsJhbc/mVbM5kDOCK4Wczve6nCy1XuMZ8QlPj66SZO+L3gq622VecakV/jgYtwo0mbTn6SjEnV2uCXw1J8oAqdBa7SaCQ1kvrlfdt92f4iTeuXRkrkZHB285nIU5F70xw8cspDfQJD1olQ/9SfIgV65x9feui/gdXWX82O1n8I0V677BR4WC+EVXlS/A2t6ZE8ZiQZuK5zX42FR2ajBnFjKAqknT1KkwsTqPGE/U0o15uEFdimuqQ+WmSZPSmUY5jCULnMG6bmulsQDCS4Rg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Apr 2026 08:24:24 -0700 SeongJae Park <sj@kernel.org> wrote:

> Hello Andrew,
> 
> On Tue, 28 Apr 2026 07:48:37 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 27 Apr 2026 18:33:49 -0700 SeongJae Park <sj@kernel.org> wrote:
> > 
> > > TL; DR: Let users set different DAMOS quota charge ratios for DAMOS
> > > action failed regions, for deterministic and consistent DAMOS action
> > > progress.
> > 
> > Add, thanks.
> > 
> > As mentioned provately, Sashiko claims to have found things which it
> > didn't see in the RFC.
> > 
> > 	https://sashiko.dev/#/patchset/20260428013402.115171-1-sj@kernel.org
> 
> TL; DR: I find no blocker for this patch series from the Sashiko reviews.
> 
> Now sashiko replies its reviews for DAMON patches to authors and
> damon@lists.linux.dev.  So I replied [1,2,3] my review of the reviews to those
> on damon@lists.linux.dev mailing list.  As I mentioned on the TL;DR, I find no
> blocker for this series.
> 
> And I think you didn't see those because those are sent to only authors and
> damon@lists.linux.dev.
> 
> I nowadays reply-all to original recipients only if Sashiko found a blocker.  I
> will also add short notice for non-RFC patches if Sashiko found zero issue.

... Now I think the short notice is only redundant and silly, as the full
review is available on damon@ list and the one who primarily interested in
(Andrew) understands that.  I feel like the short-notice reply-all only
increase unnecessary traffic and my redundant typing.  I will not do the short
notice broadcasting, unless someone makes a diffeernt voice.


Thanks,
SJ

[...]

