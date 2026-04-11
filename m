Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC0C6F3ED50
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 17:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 096676B0089; Sat, 11 Apr 2026 13:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047BE6B008A; Sat, 11 Apr 2026 13:09:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F8A6B0092; Sat, 11 Apr 2026 13:09:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC24B6B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 13:09:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78E338C6E3
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 17:09:26 +0000 (UTC)
X-FDA: 84646911132.26.CA277AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 03F6040005
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 17:09:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="beC/cCPW";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="beC/cCPW";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775927365; a=rsa-sha256;
	cv=none;
	b=HuWPcLZi72xnyIKC2GitP7C7+Rc46eXxJ5mtThsO3A1KW+54yuA8vSq1uCxvap0xVLZo0C
	pmX7Sb6BbS9OxHre5i9NQ957nVJcdUodXk7vsY7F4sTAx8ngZmiVZubaDoZoDGxnWYjeco
	/2UHnU5Gnxi6h44XOevj+UX2PRm1Uus=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775927365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8KFZ0gll5MjF7tBlOZs63BHUgMHhCrv9XFHw3cSOTtI=;
	b=fPVkg8CYfzndl4hJfANbFk8GfnE/qaqiP31yHhf1YKSfRcKVJUAFiSBjQ+cFL0m1Z/49l/
	i38YIrp4McGIVG4NF1Pi6WHp66He4ySwUJEhIrXYv0/ezWx7Skmd49R7pH2R9ryyCzrcy/
	s8MCOCQykoccFiM9GjBMMrxZfLrFedU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B6D16111A
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 17:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB279C4CEF7;
	Sat, 11 Apr 2026 17:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775927364;
	bh=mLWm1A+kvhVK3/mJ79ySU/3Nw9GXZUDws6e5yDbdgRc=;
	h=From:To:Cc:Subject:Date:From;
	b=beC/cCPWhkNYz93kjx9/TRl/QFtINiIfjh3GBnQY9pWolAOurYaFLGoNIAfCIyEz0
	 zaQwaZTTi6BuQLLy4nZ76zf3JQ8P/xoupNdVmthgsSpZrq7COYAuI4R1ISnEWnRI8Q
	 VaAOhNJ7+mlFnLNErf2/uteH96WwJCwf6wYXJh8oitec3Vbh3NLtVKN0YdPYwNvn2i
	 z/a+5E9St3KJPI21WRbid8ZwYQbWHHBL76AskZ8UCgl0h1Oj4l3ZUwMp/4P7YNue1U
	 qo8pfARl7n+pa+01g4i5bLS7PYPUh/SevjWUo9Hw0fN43kSc0fiijvtVUWdYnNJPgu
	 V2/J+k7t6GEkw==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-03-30
Date: Sat, 11 Apr 2026 10:09:20 -0700
Message-ID: <20260411170920.77900-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 03F6040005
X-Stat-Signature: j4he6bmj7yyrmg5c5itfm4bi35rs4ids
X-Rspam-User: 
X-HE-Tag: 1775927364-198850
X-HE-Meta: U2FsdGVkX193IlM3d/cswjR7GwVfAvSbXaOCZ5KXUAfp72Z9WwbcWe9BvbUOOWDKwnW8p8XE714szQ74TK4tG6GxWQ96/oH2WSUuKYKNYx6zZJvpfa4g1bd9Eea9OvWRJLBAkXMk7///v3ZZejTubtfyhdiopTvsJakWMNdR07TSObbGcVueswHiuGrI5cS8CzIm/m54wCrgIdh7+bLJ0fgZZzcb3r1Db4fvh0FMKyaqFFvcf0yhGsGEBxilKtTD7itA4FH8XUIL0siTGr8re3sZfKNyRHBA0yDXzEe6O46+TBrCawZ3YdFRYqqMcaigvspr1Yf4bc8DQY2iHevgX3xBxLl+snQSXFVfgsWlDqKyjKR5xSSpV1VInTxb2+tJeDyOFyE5rzuBBk4YwptKPMjaGQ90O+P8/Ce+KSNM6m43YM2WEYQXaZD0Fexhxg/rSnS5BAJOBA08xrjZWyW7M7Ax94+b1yAw66dYl8HIsBW3JTfkL/KzBNbv330c751Xya/yziC2dHctmzYLoh883L4afdKxIVkRuJaFvtmrUsC2/7YtCSs7evn6e3Kug4nDlvYTMZu75nSK/szN3ZtEH7e40t9QqZ6VBdWYrO10OjdJHJUFXcE5NIG7JoFoEV519656rqE75K9pVF6A6c8xq2mIJf1MHzMsvewX2xoQ+guCjiqywoFESo9ls3FAQM2BqxxiS/Jo7r9rJTjUQ/bIizA62B0qaxCeR8CI94cIG6q3sfhUgM/JXDbhk7gPeZJCNdtHORm7K7Ig8SjtcY6Q0dImprp2u9fDf+c4alTNw//ehXjmi3th7frA3+D2fcwWJxC7N5HznARKMFlQws5wZawkMGSf5U2jrOR37GrT0Ei6qEJoIlfO4bgWcC+vkF/pTvXVdCFBQBe4f2g4O+F9TIlQTWZ5vgEL5VKUvV6T5O3qdajuj6ZENbCap1sbozJW4T+O5HiZN0dkqa8zt9b
 pR1HCWjZ
 A1KE3p1T3wTdHsVEnVLJzOpVOC4WSCi9JBQSUVQSIKMOqLqJcPWhGn8qgYSBZu0ix8j5/ENE60gxM73s8Tc1QJ/Y/BJYnT9y+NgJ10qJN96DSSrI+xZZmPjvUAsSEj1L3AWedLXPBjdnbeKCKAvI/HRuXcYm+jjxHQZReUy0zssx/JXQCi8RLleTmVSt0TvL+OlRYhyIaSsbt9d5m9VDSfbq3L7XKj6g95VEVodukhvNQAvxt6rLhSUIR7vaAMVRdS7AxXDMKvjlZJ1LU03k52r1BfYn03eEz8w2aFpPzO4BdGSs5X+78hWQW3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-04-13.

As usual, we have two time slots for meetings in the week.

Next time slots including six virtual-only ones are as below.

2026-04-13 (Mon) 18:00 PT (not yet reserved)
2026-04-15 (Wed) 09:30 PT (not yet reserved)
2026-04-27 (Mon) 18:00 PT (not yet reserved)
2026-04-29 (Wed) 09:30 PT (not yet reserved)
2026-05-11 (Mon) 18:00 PT (not yet reserved)
2026-05-13 (Wed) 09:30 PT (not yet reserved)

Please reach out to me (sj@kernel.org or whatever) to reserve the
not-yet-reserved time slots for your topics.  The reservation is made in a
First-Come First-Served way, and I will send a Google Meet link to
reservation-confirmed attendees.

Please note that other time slots are also available on demands.

Shared Calendar
---------------

You can get the schedule via this shared Google Calendar:
https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t

You can also get the past and upcoming schedules via
https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing


Thanks,
SJ

