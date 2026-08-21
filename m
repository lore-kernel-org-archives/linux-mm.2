Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71748C5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 21:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D50E6B009D; Fri, 21 Aug 2026 17:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284956B009F; Fri, 21 Aug 2026 17:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19DF56B00A0; Fri, 21 Aug 2026 17:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1CDC6B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:49:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA30640224
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 21:49:33 +0000 (UTC)
X-FDA: 85126618626.17.8629BCE
Received: from mta1.migadu.com (out-159.mta1.migadu.com [95.215.58.159])
	by imf25.hostedemail.com (Postfix) with ESMTP id CF758A0004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 21:49:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nYreJTyj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787348972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5gB0/eoQgChB7MUzoYvGQXG/r+CKbSdsXnZ3NssqdGU=;
	b=4cViLNGDa6EfNaVsx3ecNhMiXfRJm2lq72thkg9OOq6Y5SPQP84XtQQ9akUZYAC7Miem5U
	Z5qLSqS41/5bmGNmdBLUo/mwiZlnFRZSgiE4nHvojgYtjAIn9gw1TtXAIQUgQWaKQIdYMZ
	eI4cJBKr8AyO3WJayoy7YZZNrTE43vM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nYreJTyj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787348972;
	b=RHxT5PSrXoLUhISAgphxJmPHTcc4p4HeglCYyyUAgYntWRG53+18wWDy6NqO8T1VmAthKj
	06ec776nw+dKeuS9uWKr5DKga9ed8EaoJit3tfYsLDrzuTa0odDyxFR9mEWwjomnlYuNxz
	xktfqU6LqNRyLECtDqRkO8vbwpPx7AQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jXeoTgDV4DScDHzGSbrBzBDKi7kiB/EPOD+3RgYwVSI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787348970; v=1; x=1787953770;
 b=nYreJTyjav138mLIkov8roEq04Le/afrws56QwDh1mursu/ohqaetlELXU9b96VlIfhU5n9o
 tWL5Y4zn9iot2i+BwMOltSvl/gd1oJCECfjWotUVDi0uhpXwgru7kwymemzQH71WXnRS8D4k0CG
 VjUAFol0oTeki5zLSbZ7sJYg=
X-Envelope-To: linux-mm@kvack.org
Received: from castle.c.googlers.com (35.203.187.139)
	by mta12.migadu.com with ESMTPS id 64ae4fc1d4dbb56e;
	Fri, 21 Aug 2026 21:49:30 +0000
X-Mizu-Trace-ID: 64ae4fc1d4dbb56e
X-Migadu-Flow: FLOW_OUT
From: Roman Gushchin <roman.gushchin@linux.dev>
To: John Hubbard <jhubbard@nvidia.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,  Michal Hocko
 <mhocko@suse.com>,  Ridong Chen <ridong.chen@linux.dev>,  Andrew Morton
 <akpm@linux-foundation.org>,  Johannes Weiner <hannes@cmpxchg.org>,  David
 Hildenbrand <david@kernel.org>,  Qi Zheng <qi.zheng@linux.dev>,  Shakeel
 Butt <shakeel.butt@linux.dev>,  Kairui Song <kasong@tencent.com>,  Barry
 Song <baohua@kernel.org>,  Axel Rasmussen <axelrasmussen@google.com>,
  Yuanchu Xie <yuanchu@google.com>,  Wei Xu <weixugc@google.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Ridong Chen
 <chenridong@xiaomi.com>
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
In-Reply-To: <67fc54f3-8889-4e18-b72c-e14266bd4703@nvidia.com> (John Hubbard's
	message of "Fri, 21 Aug 2026 14:44:14 -0700")
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
	<aogMyu5R_DZRqp2J@tiehlicka> <aogQ6iDA7RkuTtDG@gremlin>
	<7ia4tsonw41j.fsf@castle.c.googlers.com>
	<67fc54f3-8889-4e18-b72c-e14266bd4703@nvidia.com>
User-Agent: mu4e 1.12.15; emacs 30.2
Date: Fri, 21 Aug 2026 21:49:26 +0000
Message-ID: <7ia4ecfrywih.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: bopjwjfq6sqiowe7t6uu85yg7wmww5xp
X-Rspamd-Queue-Id: CF758A0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787348971-285745
X-HE-Meta: U2FsdGVkX19hMMsnoErUIrHc/FlXaZaiC4dF4Ggep9d57Mv7f+5MltyNTh+DIgNlXieuFvQdoTD1Bodusos201kJLwneDdeylzGTbzckO/aJ4FWYRYMafk8pNG5WD3sdsOi+aFqtiWr7NsfrItfuPttX2T7cGWG5yr2EfQMCXCsps0pKxTMPx2B2Tw64Nz1oeqwLEKN8oQb7gSKyGXkEqQsY9xSI8qMnT+mBreqPRz9uRb/EdWP2UKUx8Hc/enDOFWakaM0eOTdokhBJlRttVK6wiSr1NILlZJtD7tGr00FD0mrEdCrgIchAb2laLrKJeIb372wMZbQdpnXxqi1BjFJ2KMU47L6H9tdsm+znddE5N0/ySNlGtgPqqzUfk3uZ/hOa1nTwWZu3b6/i7/dkXJqWP6I29+M9AlNmvTKD6aK9EBy/JKF+GsFLN43ukMw2KbsNs0z15nCQpOEiqswLXdpQjGIIs0zJlQddeauQup1k3v45FfvJa0fJm9pvB6HRlSt+Rskl1fdpgKXk/kGB5G8ersw9lhbS+zy7OpahGsi59TCzvxtq2wyloi0lskG/wbBHnUMl6EKAsPjeaHqG9of3SbA0RA0KPBUz/mya7TAgREpxEq0hwNK1eF4cCNewj5mRaTfuD7RFdVcYDGGZjUE5P12Kht6X4PPAsoprAnvPEtTAtSjZgTl0FMmndxVPkw41eKsHstWObeKmB4MuNfEkTe6cgcc0cmy8x/+4nHL5mtpCdgL/ZXYsgDrc5OIt4lN8SKE3huvS45uaoQX2uagAN1apHq1cqorQAdsJpQmM+DMmCgRR60SIDddBJGb/8U3/giErWtqJdTvWgPvNvfIc1cjAYX3PgCokWRSS24zVwQ3LukXWMfbJM6FYIvtV7JbnqIikf+Xa0W5m+KCsOWCRpn5Jl3061hzVPetHksoa+GSIk0LjXmie+Sfe9HAVbQZ08oxUyycAi8amAiZ
 lKSitW/P
 GQlM1mJEkT6xqmCPUoFWbByMcdcpi0oqz2Z/SvumNURbegyjRwlJuaRrEAJGdQDpV9RHixtTrqhOzNILQSiIfCAp+9rxJ4jczLHNRko+qN1ldM874KpkKTU/OFLa8H3HeA9mfY5ZT9QXwf4nMPn6VBlawr7aGDIVphIPc/fzlVNeyahE5qaQ8FYuJVbqsUP5Ehz/Jm8mMwBxkZGPbTgbp287IeEWE6HOzs7OtKyTa280rWLw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

John Hubbard <jhubbard@nvidia.com> writes:

> On 8/21/26 2:35 PM, Roman Gushchin wrote:
>> "Lorenzo Stoakes (ARM)" <ljs@kernel.org> writes:
>>> On Fri, Aug 21, 2026 at 10:31:06AM +0200, Michal Hocko wrote:
> ...>> We already had _too much work_ prior to the slopgeddon. Now we have a multiple
>>> of that.
>>>
>>> Roman - I really think we a way of switching off the 'unrelated to your patch
>>> but' stuff per-subsystem would be useful.
>> 
>> I thought about it, but switching it off completely looks dubious to
>> me. So maybe moderating it a bit can help? Like not reporting completely
>> unrelated issues or at least do not report them more than once?
>
> Or, reporting them *once*, and not as a reply to the patch! 
>
> After all, it's "unrelated to your patch". So then, don't pollute that
> patch's review thread, right?
>
> That would alleviate the most infuriating part of this cycle, imho.

Yes, this sounds good to me, it requires quite some work on the sashiko
side, so I can't promise it tomorrow, but hopefully in few weeks.

Thanks

