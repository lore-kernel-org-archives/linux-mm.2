Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BD31C88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B44C6B008A; Fri, 11 Sep 2026 10:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33DA66B0093; Fri, 11 Sep 2026 10:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D036B0095; Fri, 11 Sep 2026 10:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2BA56B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:14:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8DEE4160137
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:14:01 +0000 (UTC)
X-FDA: 85201675482.22.FC7D71A
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf25.hostedemail.com (Postfix) with ESMTP id B7F25A0011
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:13:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789136039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5pF7UOjJ0Hc92aoK/fGuwkSEqe18l+crBILfTSieFQI=;
	b=W4K+gGxEHchP3TT6hX+lerYlHEv67/XreGzTWpKPnfp2cUfN2D4U2NfWFHUYCJRjvsjopq
	YhNBTInl2sI3j9OoVyJGu+mIoHtUOVEs0qxdYKHmo9cXDfkIwGj6IaQsSG/jahAp+9bhXe
	UhSQh9fjWvsaZjVcv82yhYU9NiyXtP8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789136039;
	b=hpQHvXmO1Fvl9xOm2x2iwzYXTycDOtXTjRm5NGmpVVjysXdQY4W4+CEEOkYoJxkbhgofmU
	EWPNAkgJOR0UTXThlF5qzbYyw/F8OXv1c06rmleyju2CM7UMKGStn0DNLUk7Mu4FdZcGw4
	vf+gwZeFVo1kiTzM3hL41Z+r/q88uSc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	none
Received: from omf10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0465120233;
	Fri, 11 Sep 2026 14:13:57 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id 8732930;
	Fri, 11 Sep 2026 14:13:53 +0000 (UTC)
Date: Fri, 11 Sep 2026 10:15:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Kairui Song
 <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)),
 Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH 3/3] mm/mglru: add tracepoint for inc_max_seq()
Message-ID: <20260911101514.1fe0d543@gandalf.local.home>
In-Reply-To: <20260911072848.2346073-4-ridong.chen@linux.dev>
References: <20260911072848.2346073-1-ridong.chen@linux.dev>
	<20260911072848.2346073-4-ridong.chen@linux.dev>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/kRIOymlh/yRyLjmb/AHjuhpRO+qc1TOM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=5pF7UOjJ0Hc92aoK/fGuwkSEqe18l+crBILfTSieFQI=; b=gMEucxCmj+6pFz+an9E4ANtASc6LfKKjFrswxZXbzlFzbRl3RMdZLezICim3m1D1g+EltbA0AAxcxjZFkzndutpjigSaREYcKBm39wpsCuSHyuYubGObgHzIORQtGzsUOg33YwZFKldCDQEv6aFsY6RAuM/Ir1V8sGRif+8R4bk=
X-HE-Meta: U2FsdGVkX18Qy0hiLDQcFnE98ah35wCu1vIZzyuKl27gM6+rsq3zuBhpsZz4DS2UvGVcZDbYIned2LtehysThjsjLGLHrdUWkQO224ES2ZkL301BaOUl6XrGBSbFka66RgDtbg6JYpyv9aO8iiY3TRMnOWzfyTrcUqfSAY3/ToMushNHQRVdRsO1VY0kvWMhsLznxmy3891Dh/u+rzgtmDUGFHgWmliyPOkVS5FgDqE72MLKWKK8Cnh3hg1lRCnBkS/HUCLJycBe3E4PEJywVWOxSdwPI6+AI8tfPz/4xya2HNCyXd89jbSacEhJYkeY
X-HE-Tag-Orig: 1789136033-909403
X-Rspamd-Server: rspam05
X-Stat-Signature: 8iboo6zs3eenkswywjdt6nxxw6e9k4fy
X-Rspam-User: 
X-Rspamd-Queue-Id: B7F25A0011
X-HE-Tag: 1789136039-540548
X-HE-Meta: U2FsdGVkX1/R5p8iigY9MJSE+7LfnoPBkglrP3XsiaO4N+Rk/DjJY4KDEB5mDggmHCvXuCP3ymyggN7XpSyz1cI7bdaOzEgf8WzssTd+Mb4hFTZzimferSznTrRo2PhE2S+ijgJV0H741kDBU9JUEC01yNdOZUR7uZXEBa6a/sD5IeIUzTXGGQr9NTT8j9ny89HDC274g63e5QlQQbpjcdKERuZYYbB6YS9GkRUglXkjb79Fs5Ze3m4bGRlvWlOsyTaTuuzd2uXjIoQLpJtR9wIpMZvY68vr/Wfa4i8msJpsB/Cl040CJHt/rFLm4ci0kLIDpBuVK0mKV8o1VmXg32GQNdW+koJhVpe7NT5WtoHFuXpBYEO043XNDggGZHII664Je573lyJUV5/dHZcCqVHlQfRm5LJyyDhig3d0BKtvde1+Q4nr88FqEwXvY3OYhb3F31p5OA++M7Fh3SXWJP0u/TqUzY9a3k5wusBH3TghfjnkpfsOJA8ys17Ghwr1i8HBBEC0FJwXo6nntWdh6uIhrWFeHHysXgEdpUUyvTKg5hrb4IOOL08WBolU0uIykP7jBPuRSReK4hHZ7zNswQdJVhy8H7l6b2qMY6e5HRKYmHijg08Rkf03W0s2x8gm+ktnRir30pmvQ+5AIU/Yw495gUrHBeBoYLcGEP3Wc38TlaNLAAc/Q8EdEbCW26vbwMobdi0uJyG4XEMbzViCItjW7S3j39Ibd1/1xcrE7bbMlzQo8vUVmuQ8EGu0S9w7XdVrHoqx9ofYUjySmA9EZCwjdSpW6nq2JRxFmNizREDUlPQQvCtG8rSTuA9b+cV+EchKOm8MhUh7I2Yn9YTeJk6xFWdYPK+eZgt1xTl7tbfaH6Ns1OAtCAoz2KQ5ahvczO7X7CJf5K/WsNWISGs2CprONv6o4lP6UXPjEWHy7Z/7aPpsmvg34IKDri7UlGjmyM4F6c1AYkItMF05k7h
 hyTfZXnx
 6zhFtOFTHExVnokIaFeHOdIT4tysE0B6WdF1+OFlSRXxxoYSSq5lhiMxqzQrW8syVgqKLyUri50H44gSbNogmfRaoz0MuKu5ngFd7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 15:28:48 +0800
Ridong Chen <ridong.chen@linux.dev> wrote:

> +static void trace_inc_max_seq(struct lruvec *lruvec)
> +{
> +	int type, gen;
> +	unsigned long nr[ANON_AND_FILE][MAX_NR_GENS];
> +	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> +
> +	if (!trace_mm_mglru_inc_max_seq_enabled())
> +		return;
> +
> +	for (type = 0; type < ANON_AND_FILE; type++)
> +		for (gen = 0; gen < MAX_NR_GENS; gen++)
> +			nr[type][gen] = lru_gen_seq_nr_pages(lrugen, gen, type);
> +
> +	trace_mm_mglru_inc_max_seq(mem_cgroup_id(lruvec_memcg(lruvec)),
> +				   lrugen->max_seq,
> +				   lrugen->min_seq[LRU_GEN_ANON],
> +				   lrugen->min_seq[LRU_GEN_FILE],
> +				   nr[LRU_GEN_ANON], nr[LRU_GEN_FILE]);
> +}

I would always look at trying to move as much logic into the
TP_fast_assign() and not have it be where the tracepoint is called.

-- Steve

