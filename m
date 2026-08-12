Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71167C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6996C6B00E7; Wed, 12 Aug 2026 07:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6706B6B00E8; Wed, 12 Aug 2026 07:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AD456B00E9; Wed, 12 Aug 2026 07:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 37A706B00E7
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:05:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B656F120178
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:05:48 +0000 (UTC)
X-FDA: 85092337176.20.726901B
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1746E180005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:05:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=IIoOqjaQ;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786532747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w2apc6v0QyxEHj1VT4UFCYU/Xgf8d/neWcW5aoUtuf4=;
	b=kdlG+kpBu908QwmlCeK0TC3Ab3FTQKtSUWzn2Ll9JlUL5VQo3sJgmTsE7iVqttr6CjsnT6
	Vry3VjF4lX8NsMJeXpLNjniTJtxOzv2yaBUaiO4NAtSG5FNMbTIEUSEojTole+FMIRk6R9
	lLN5VW6XuR/j4FGHaqA/58mWIoOkytk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=IIoOqjaQ;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786532747;
	b=yUfM03vSShO7sbo4Yp4px7NXtNq0MUTsJvOJqVRRABzjEbrRE39LJMRlUTh6v00soULwbe
	uQE6WwYStvYkfE7d567NvfP9SbsPAVeB6OOReIlWbJ8yOGUXMbPqZK9Wnuphg2pLlPmedD
	tYv5LlOO5liGbQps/PluDu920tHsRIE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w2apc6v0QyxEHj1VT4UFCYU/Xgf8d/neWcW5aoUtuf4=; b=IIoOqjaQhu4BnbYR28jckH5yD+
	x9mZCttH/rA68W8Uts3XCDflZ77niHUFCUUrvf7UYJReCuzy7YBkabFWhZOyGozqqCYyDL+IqHFTf
	CM0bGfB6fDTNLpxH9+2GY5uzBFGqtyXc8EHksB+OlytQGwtWrJUK+8AeIgGGfRbvRt3EDDrmYUW5B
	xCq7PHBYE+ewsxn+1x6wW4wa1euIcOosU5DKdfDNH+OEGecvicOm0aFYDHp23dvlU81DLUeKb2TIj
	jHmWLZNaKzhQCoYXwwHM2qHAs5uYmtMlK4y0vOcpE4zrx182R4mb9cZkA5vxseFln4I42LWxjGKkV
	fVWD79eA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wu6le-004IUn-3C;
	Wed, 12 Aug 2026 11:05:07 +0000
Date: Wed, 12 Aug 2026 04:05:00 -0700
From: Breno Leitao <leitao@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 0/3] mm, swap: don't spin or flood the console on a bad
 swap entry
Message-ID: <anxS8cZIEi6pAWAc@gmail.com>
References: <20260810-swap-v1-0-375ef0767206@debian.org>
 <20260810102034.547699380bbe7aeb232344a9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810102034.547699380bbe7aeb232344a9@linux-foundation.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1746E180005
X-Stat-Signature: pd1fcohnof6nb6hf74hh1btetxdjrmgi
X-Rspam-User: 
X-HE-Tag: 1786532746-778044
X-HE-Meta: U2FsdGVkX1+0ktBHf+2AEfxHApHV6wd4MdudORtE92lD6H8qceVPp9FYTUnysEk4Hvp6oiSYPDPCWGix9UeXN83T1eB5m1SwldrtUsZGsdAv1fHAM++FYKTYdeGtSzz41+V/VgCAmTXFD+U2jPWovhg3hTxdfugFpQmvFC4+K+3NodNIKxIM8ER6ZKOqLTs028lyaHo8MAam2F5d2SUc5jbePr6JirklvJrrUkBhkbJHAdVgStffcvBngnOoY6AylExCDyt+LbgvAd7urkTROSgIZRcN/hQ1S4HLQi+N4zBubOiB6en8dcDfACXSQpT5dnHuU4EHB/r4FhnoOw0PNhx7YXsuHgAztntalnPT3kHwS10KYm2PKkk2n7uYzlfzPJ6Qh3H/8e4dlPueq5yCcVxlp4DOFzFllhM5+ONW4iHKtbMElg37GlE4RrncMdVtPbM5tgxzwU6jdRv3hHun0YdM5Hu9E8kaJFgZIc5YxGxzIKQQ6nqoMX7U1DuUThBdQwXrxAjmhgy9+N+QseNTdPEGWCv4veOj4Bfg1IL3ADcqlbUbMYytIoK9h3xrLu3ZRgXMIHtBKTLILYmdpLcg3TmGNx0RzRy6Z77d3C4Xnz1H4c8zKIOXp3iVO76yUCU0792IxdYalahYigRQSBuQBgsq9h/9Pu3L9aZpVG3llHDk6+fBNThSijnGVeuXQf1HnrzNbY/7piWPjvoCfG3PrXAHsILIQqYHYQCY5UCANcP9J9gNib0bstjN8qfggjAol8KlmkyKkC6PPwdxJKVu/uzIMw89E9RniPAuzAla8Uxmv/VPuVNM0y0fkVkX0ewLsMt5TihnYmqHWOsgGk6/C63R/BNjR3c6ltpuxeLhe2g16VFaDqJatI/AzEkO7ZwjeERiTdfaDtm5nlKw3Nl/lJq9BcZi2NsKQO/tc0X+OZqywTzq/y3UuJ/96PeFk6sqgv8Hn+Zwjsclii6P92F
 h6ACQntA
 HdeklrFRUjk/9p5X6HMwhlvm42rD3DBoxKh+Zh5UU9H27y57e2WzN9HcEd2xOBQFdEQVsGNTltFHEsP3LnQ/D9UulBUCRpQ20HHBWnJON+FyNZq4XyXLQlnXHGVOMD5JECboMTdu5R6zaluZDNTKBBCEzVxZbboGb77PiriEGKSCmc604SkGsBj6WtC4etjH2ldvbgYa0Pig1JDf9wvK+jAi3oRWnEa6GbJBu59BfujPMH91bb4B+siXbtcqw7hwuR1G5ycVnXYpiajVXbif3Kh7mxRyFiype/cmcUgYy8Tt2xPnThUwC/33DGumpN3Hg7Q0TwN4QFQ6laBFZ5Caa4NDi5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 10:20:34AM -0700, Andrew Morton wrote:
> On Mon, 10 Aug 2026 09:26:48 -0700 Breno Leitao <leitao@debian.org> wrote:
> > Trying to fix it in a naive way:
> 
> Thanks.  Sashiko said a bunch of things, all pre-existing.
> 	https://sashiko.dev/#/patchset/20260810-swap-v1-0-375ef0767206@debian.org
> 
> You might wat to address the first one as it's on-topic for this
> patchset.  Ther are some swap things.  The remainder are for the poor
> uffd maintainers to scratch at, if inclined.

Ack.

Rate limiting swap_dup_entry_direct() is right on its own: it prints the
same Bad_file message as get_swap_device() does, we have another case we
want to rate limit as well. 

I will update and respin.
--breno

