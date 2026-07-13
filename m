Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64076C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 13:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42CE86B0005; Mon, 13 Jul 2026 09:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD956B0088; Mon, 13 Jul 2026 09:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F6876B008A; Mon, 13 Jul 2026 09:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 090B36B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:12:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D0B94015B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:12:55 +0000 (UTC)
X-FDA: 84983793510.16.5542270
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id AA7E820003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:12:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fM+mafjp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783948374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BgJBPkZ5skj/gjGlTheMmG+N99+EZQjf1oVIDsBj5d8=;
	b=GihJGXzldsWz+kXML2DZUMt7AWzbqJGaELD6bs0G9V16YCBAhrL+qi2jNzGE9T4VlfT5Fn
	Oeo0SqLP+WAxDWfkx2LtJ0dfsQlTwfOe0kqz4B6BDurxbMcbW++OXKuQoKiEe/Z7i981ss
	ZR2tUNmNrqUajo3ucvDlB1I6PJb/bv0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fM+mafjp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783948374;
	b=AbjS5g6LqU+XuLKIRHnjiC9SE4ExFvJ48Kxrm0HDMLdzeMHHWF5b9lX5zjjyvg/DQcR+kn
	Fcjw9TscEwKiXC9FcQQXkEAxrmGG8P+DGEsTkYCHSMWFEGTpdqKCH/9GYbHdHRzfp6bc45
	Gja3s7mSp5+Xe6A3yFuW/pepnBWVXmY=
Message-ID: <4752c658-7b61-4636-ab5b-bd172e11a42c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783948371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BgJBPkZ5skj/gjGlTheMmG+N99+EZQjf1oVIDsBj5d8=;
	b=fM+mafjpFjm2q6euqpTOUH9LBCGN2HTwkh1zBOC+/9y7KBmXmgV17ArNOvAO6G6YmjYHgO
	Jwwvr/aJHS5zV0U9Zutr3M7/9j4zoA0CcmISGvtC4uhCqDYWybCjWX+bfKh5IYeNdSuJ6I
	dls6V2uYq0RaU21yrr4lRHFpoe4Oa7Y=
Date: Mon, 13 Jul 2026 21:12:38 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in memcg
 slab shrink
To: Usama Arif <usama.arif@linux.dev>, brauner@kernel.org, jack@suse.cz,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org
Cc: hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com,
 linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com,
 kernel-team@meta.com
References: <20260609123047.1948242-1-usama.arif@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260609123047.1948242-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AA7E820003
X-Stat-Signature: oenj7ddh76g96xhq8diyacgzabdagr4p
X-HE-Tag: 1783948373-672959
X-HE-Meta: U2FsdGVkX1/jhFZz6RR5ZSHfvU8qwA5d1/PkMieco6VCyV29VkHeXa7Aw9ddlOdCAaqhGapaHaH5X5n/IAXiEplTS/GSxJoxWA61MAJpaVcy2hiFOTI7QYDIOnCasZjQ8W9Zou6a3dB1bpGJXB8TTAp1+wNxRJN2qk5fsm/1HyyvZW3He9jSsVQ44Y7atL/Mvs+6HVjZ3m7jz2U6e/T23xUrzxR19WZZeLVKEHVal5i9PAuMSBFXPP+UunrTQCZmLlwq4oreD0hhSKrvk6vnwsjhN+/DfBvUfr/pbHube1zWqo5yCYyX31XS80l6fxH3xx2D6MXpN7CChe/3W2suex0cy1Nb5kMnwsYIKi1KSiXRYbwEzVW15hS86gKWatHs2ahT5Ts/MXerxw53BgJpVGluMbxII39qs7NsN9i6Gp/6bxTVdvnUvDu34vl5tq457EUdU6pt1+lMwspViMjgXZBQisWBjzu//mTzbLy6N70P89Etp+qMuDrdbdv6Ar4UpOn9o13FOYusgSPknJMZgZV8+PoYjMNJPacBQ+jEWXw9Wr0tufTEvdV4idS2YWh4QCy21717gMt4W2v5zaouWvR0bP0GkJS9LMIeH/WL2g1eZ2vIVz+T4/ziRZMCFD9Yq2n3cfR6+0VE/relsjy0UoJxqXgjyx8ecBk/bk36Hrj+qvWW1JOtNnavaxBdE4l1iB+zSb+ebfZrUSdXuWN5yT7oURUG1ibBMG9HEUfB6MMbZEfgvDTEli01lJYgOQfzoNsv+REMqVOcX5a/uJayt7wGyJR3T5FM3X1nEfOAA+dvAfg3TCzLwJ0n8hr2pgjtxUlYBLQQLtIgiCLd6TvpnAnhDeMaNuFIbcyOi4BhK/X6iKZE/rTbow3vs+JoL/qpb9UvV56eg/jwmEQllt8xDqDSe20mPmK3UZVZMnsLausmLYWVVP3DTpzwxrQbUjjIWrpa8LTSPRGSRCec5R8
 at8faK3m
 9o/jVoszVIU5SGfO8zZGV5epfXP4TQoL3mNRfq83HP1/OswciltnxIttBlBAP0pyA3LMizX2w/SUAlEUKy3DeObFe0twNmpzayEUICkjNpGIOSoBztG9gPZ47Xr4lixK6rINRzjetWDvpUNOCu+KsCQi6iMH9HmQnGvlHuEhgdIDUlJP2JplxSQpba1aFKhG/bXIG9eBGpZdPM7hkwSA+Md11PQxN8L7XHY192Jmdsxcp/rs257JakWCoDJxg6huYPOLI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Usama,

On 6/9/26 8:30 PM, Usama Arif wrote:
> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
> btrfs extent maps and xfs inode reclaim operate on filesystem-global
> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
> None of them filter by sc->memcg.

This makes sense for now, but how should we handle this if these
shrinkers are made memcg-aware in the future?

I've recently been working on making the shmem huge shrinker
memcg-aware, but noticed my changes broke after rebasing onto the latest
tree, which led me to this patch.

As for the shmem huge shrinker, I can work around this limitation by
making it a separate shrinker. But this feels more like an overall
design decision, effectively meaning that all nr_cached_objects are
precluded from being memcg-aware.

Thanks,
Qi


