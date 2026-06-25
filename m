Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86CFACDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F086B00CE; Thu, 25 Jun 2026 03:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7768D6B00D0; Thu, 25 Jun 2026 03:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4256B00D1; Thu, 25 Jun 2026 03:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 472F06B00CE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:13:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF1C21675F2
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:13:57 +0000 (UTC)
X-FDA: 84917570514.10.2BDE180
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0C7C640007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:13:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZaexvV1B;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782371636;
	b=JDxbxh5mgTziX0/FIpGQw7yHcBYpKmBHw5gG43CZi1hhD4DovEokNAEB/v1/AzmRj7FpnJ
	g1V/xSh4Z4fzwQowwKcYGa13mh3YCAmaFsuvMPzQNaJxa/0Dze8gkKYmk8vCGyqKdfg+3U
	aKuWVxADQgnfhmL0hchZfhL7nnWJfzA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782371636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8nAgz0wuf1CLhm2IQQ+XAvfgYvp4loSLn0gnmrujgc=;
	b=qeSO1h3Cgy+5fuuFOh4YVQVV8mAjrfdwpQKlPP35Jj0Z1QkUOiXSmgai4khS+newL5Pe4T
	SYXIS+qY3R6VTUrz7g7XKalqSJRHJsV70ZPXoCi+ECsEc7wU3Pd93O6mdgScnKr43vmvrH
	A5PX/7b24uewsIY3xsX3qIIOt1gQY2E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZaexvV1B;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7005560217;
	Thu, 25 Jun 2026 07:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE171F000E9;
	Thu, 25 Jun 2026 07:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782371635;
	bh=r8nAgz0wuf1CLhm2IQQ+XAvfgYvp4loSLn0gnmrujgc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZaexvV1B0sH6EMs9pIBoH49BpJ6hcFPNI3FsMOp1XYKUpn9yRYU0a9ZyrIqZ9gdPt
	 2H1HpCEsM//OZ5b6WJRMlU4/eVVSfzkz888tmcdvP7QRxBeG8vJGRxKWaggTdVHQHp
	 ccw+d/D+MIG9SydP9cGp0zGvDC9BUsg++wcXn6QnY89igy5+6b8VkMu+YoRbAXK/hD
	 YSkGIilxuFx76UFdl8zy/Ju3Y2tRdZoqRA4mA80zKfVgyOaONbebjDWGWAY+iNvJW9
	 vmEQSeNxmUYNJvxDJC7E9bxG1GffZ0/nXCs6rVEjGkvb1E2OzHZqgRmc/SM5OdZC1n
	 4RwO5QUSOdGHA==
Message-ID: <b2e7646d-346b-4eb8-aecc-d70fad3a28f7@kernel.org>
Date: Thu, 25 Jun 2026 09:13:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] mm/page_owner: extract skip_buddy_pages() helper to
 unify buddy page skipping
To: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <ye.liu@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260623065234.31866-1-ye.liu@linux.dev>
 <20260623065234.31866-2-ye.liu@linux.dev>
 <20260624172025.3087e8d574285bfa8d6772e3@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260624172025.3087e8d574285bfa8d6772e3@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C7C640007
X-Stat-Signature: t91g861yghjcoz6dbwfd8pwhnq5csy9s
X-HE-Tag: 1782371635-825645
X-HE-Meta: U2FsdGVkX1/Tbo2sS2knSnXDpDfef6tcqX+eVkTwL3WyFsZQJ5Se880BW9VYuicYBc3zg6N3Ix5H5cHnu7Ic16MkeUu5N21H1Sx7n975xiyAWxYOWAhpcvTHsrYyXzOa0eQNx6xzfrUMEamh7pJbCQBHpXMDlofHRyBhU7sHCG/fxhKPg9sC3O9qEKpz9U7Sg8DHVQSCBSclo26QavO9//nG1zFIuSPay1TTgbuyHNsJsK75jff7T7xN4OeFp0xmcgY9pUMWDsaF8OtnOHN6u8L22n0PpWakzW3G327t5ywS8DOnFgNZ863JmefAvjX/fAQWd1d7F+dmJLG+Lmm8Md6geLSDrbsh+4y71cdQHYwiExmbsIKhBe0W9fMTKe5qnWr/skOgn0bb0JJLMWL7rntN5SHXg04q35Mepy45zbie/Z4TRyrhBzwBnhqXmKTqLm1oiJk5ubRnv4PFK8hsEFz/rI7TGMDYznI+9bjihpjYva/SOKZjZQi6FVM25SW/QKVnf1ZNEzf7zgcoV6GC9P0Hq27WyVLyVLDXNqkTw2VexTI+Sxc2KUdqHccx4rhTlbwxYEjkRE+1W1TbNEs8/CFYa4Iyfu23gp4rOm/BSxLsqoGJUFgU1ywvXnL6octtM503iGQDcavYyXYGCz+9UP8UTmrty+1A0orK4vZV9kEawdGUg+rUcnUt6CEujQYMXsxVGnNdIMNZz8hT1dyiQQfcxflJutUIMb9bCezckQdDHO4HwCtXFJn8UZaPGs3r7WOrwej0jargt4VHywHuLs953QO/9QkrUB2LYHHPB8ajGEpN2J/SmsE6DM64YNUwUiiQbsVqpkB6xcFNTNDBZBLjMD7iERzyH6EDz8vvPtbazMKqByquDpbVHqUJCCksfEGtF715Z3gcM11pH+6itqgCSbDtVrbCPXdSwCUOxlPSqAgfMDb1/xzMobyw02TehMIo7ysommxiErOka3L
 H51/wmS2
 y1LkjeaWl9ko6H24Y1WilQL42NX/m+XPNUS15WncRvCE3pxkFesJuscaLKTZ7TxBS8MLen6WuyuoUCezq9OzFJC/ciJLTsd+ipClpB4Yo33TMLXvXqbXYHe9KaREZ2nOGYuYCqgnlzFVjIw6GnecKSXDRTMWdj2eTyTlVGSe7SussmjpnXN7yK4GYjiW6ZDKtXDr+0NhPkJ30uYTdKuRPi6MIW7cw8n3FE18U2+JK3oSL+2YD4xvzImRmIFKm5GPXLCfnuhSQheHFv6r5SWZqmOv9gsYZXFbdKOF2co3PmvFNK59O35XZEUtDaqcG+HekZnyp5sX677InILWD0464QMLry9NFUGL/H7U7eIUNDciGY20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 02:20, Andrew Morton wrote:
> On Tue, 23 Jun 2026 14:52:26 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> 
>> Three places in page_owner.c duplicate the same pattern: check if a
>> page is PageBuddy, read its order via buddy_order_unsafe(), advance
>> the pfn past the buddy block if the order is valid, and continue.
>> 
>> Consolidate them into a single inline helper skip_buddy_pages().
>> The function returns true (skip) for any buddy page and advances
>> @pfn past the block when the order is valid; returns false if the
>> page is not a buddy page and should be processed normally.
>> 
>> The old init_pages_in_zone() variant used "order > 0" as an extra
>> guard before advancing pfn, but the continue was unconditional and
>> (1UL << 0) - 1 == 0, so the behaviour is identical.  The comment
>> about zone->lock is preserved in the helper's kernel-doc.
> 
> All looks nice, thanks.

I got a bunch of "added to mm-hotfixes-unstable branch" mails, but this
seems like cleanups and nothing urgent? Was that intended?

> A [0/N] cover letter is nice to have.

Seems like it exists, but wasn't delivered. Lore shows its message id, but
as missing.

> AI review identified a few possible pre-existing issues, if you're
> interested:
> 	https://sashiko.dev/#/patchset/20260623065234.31866-2-ye.liu@linux.dev
> 


