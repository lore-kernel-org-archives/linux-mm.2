Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D38EC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 00:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DEAB6B0005; Mon, 13 Jul 2026 20:27:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6CD6B0088; Mon, 13 Jul 2026 20:27:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F41D6B008A; Mon, 13 Jul 2026 20:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E7676B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:27:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94B601401CD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:27:43 +0000 (UTC)
X-FDA: 84985494006.01.24EDD42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 00D92100003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:27:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+NIdeOm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783988862;
	b=UhRk5uXXGYZ0+gWBM+8VVeQiz4kFqP9j51veSqo+xEsNSYwjS1hUZLIJfEsMwVLCrMUCFR
	dZQAFU5fsMLi4UzixwsFvlfVo6/IIvbHAeFeo0hot8c8GY3Er5cy6fV4JeYvyO7shmZwlJ
	G9/ChTbxxFwhhPzLAKe6gbKQ/36KR/k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+NIdeOm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783988862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QoDq4TZKn0bzwtutz903WlltVUL0JHQTEIuXLfoz+KU=;
	b=57P/iUJ5LWw3a8IE/q4tpGatovAr9SD9wsd3ANH0Q2vc/Nnj79A6MB7d65Svu/xV7dup0x
	8f3x0hmYK7cfcAO2u8yDEaI7+WbE2nd4/tnWexFsfesWz5qHxftSZkWR0vyLP+oMwJpe0h
	hXwGJ2k1xoCiza9xy9BFq5i949VotZE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCD81429E4;
	Tue, 14 Jul 2026 00:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F76C1F000E9;
	Tue, 14 Jul 2026 00:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783988860;
	bh=QoDq4TZKn0bzwtutz903WlltVUL0JHQTEIuXLfoz+KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+NIdeOmm/2UIFfyqHLKJu9SjYM9TwimD//3hh2m62D0IkeJOgYIlqRTvAKGfIk0g
	 WC0ASzCbk2UXAll6ctUEWZSK0QbyFQA424v2DL4XCAJAZccaX/3X5R+VXep+dkTICP
	 PHGZoY5VcQPm10q1qvLre5Bt0xYjOLeSqgyfc5UwY13yYFWQfRnKQpCgeql/zhBjJI
	 2fK0hHLrG6/EIJBiUuqN/v7iyjC+QjVMpvE6AwiV1vwgnwd8XdNB/hxPbyxIRYHO2m
	 ZBMYIPWfgoorZ+O7v6lqUeH08kV/NnXbCS23hmSsSHKh8IU6qhB0R88Nlw2Z30kRHx
	 osT6eAj8Z1L3g==
From: SJ Park <sj@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: make mem_cgroup_oom_notify_cb() return void
Date: Mon, 13 Jul 2026 17:27:37 -0700
Message-ID: <20260714002737.85810-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 00D92100003
X-Rspam-User: 
X-Stat-Signature: kp1nxbr4birfmz4nng55c9of7t731cmz
X-Rspamd-Server: rspam03
X-HE-Tag: 1783988861-60676
X-HE-Meta: U2FsdGVkX19f2HUG084I5qhJ6QJty5aGDCjtO2KMtGLTeuzHxK22BsJZqN96QpUsmyocTqRfhc5akP15iAeYItn1/fY4Y6hDwuSPlviup2bP4AwTF43fHhk1PkrbkbT/KRt0ptmJjAIVc4KpGQEhr3E33N5sIBavgwm0JugfjQzXvQqAUoQiiB/XADhVigJlljxMIWkAKJVAkJeyJC2hY9ggjgALbRr/pPi+mharTCjLg2xqvzgS47qALlZjuHM666urWqKlvg/y5x9ObkCXGqcWoVAYVaQ/cR7nhW079D022sEBK5llwqzjHGNyzeaKVtba5STkX+vhdamyaMNZP9sQFupjCZuI9qYNNpHABdWzserjXyNl8ykcD3J4bev1bWO/tpr7IiVzmde7rr46mthl8SrJtekm+2aI7503M4mBYr/EPmpIeDGXbYdp4da0WMFJrzmka1OJ1KXNAiE8441a7fVFDnaNmX7PF6fvw2uNMsBWwThHTQu5c9HIGTzRWQ5NF2mLXIhQ9gFUkGppeDkluEVRlE/2dka1vn3Je4c6prw7HPlGeSxvDpqfNCSJIlEcDkVvap1sh5U3IYYmyO2LrUq+4ijHbeJ48mf/yb3IeesPplAW6O1VOSm67Fa7p8WtBJOGKt8GwioYiqH3MQo3KeMat/E1rHLqUgbh5B7Hn7qOZT37G9jY6quRR+kR58KiqJGH+hIwDBUuIP8ZkxiPs0WEZJJnOEHDDNbs940aQkfmr0K6w6sWivPKcwqdGP8VeRuU/eQlmpF7UkNKcJhGEsNFN7u3ScbmnntX1qdm/1KMGXNKx/OQ0chH/yDeIt/qHmC9aKU9DcUKH4llzkXrgw1PDkZQfyhKwIopl4XnYCjSaGOnO7NIt4CHwk2alTgvQxIPnldI+n96XZOUOu4+CVpjH5iLfPBXUK+XXay8Vdv4R/Wd0HjKPt44tzyHKNNpVBY0lz9p8t8bzdL
 cXeLw6Id
 AMkqSOAMIzeZRcu7AKjn+h1B2bigMhZbMbpMhYWPC77G0IZypGJbuQiheSFLtrTuzxbTdSTCnOATD2fOuwwbaOruISDyuIkCykb0E//tR78KVbWfsqhYGYK5FWjR6xlSROucoPynEldT1Z3t04ScWf4TTcoAW9yKC5Bwbv3PqsleRwRSV7WQ1LXV3PerSiFoGoTrUa3DWTmRRyh9cwThkR2/NzHyogRRGwOuWZwgW2nvzWi0oT62g6moRtFwtyI0simhPQvVoecKladax4kEPSK5VjuVbFtFKaOMCPTd1G0gcrYGmw4tM2nxJ7Vyrl1dv89LZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Jul 2026 17:37:37 +0800 Guopeng Zhang <guopeng.zhang@linux.dev> wrote:

> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 7d74b06f240f ("memcg: use for_each_mem_cgroup") replaced the
> mem_cgroup_walk_tree() call in mem_cgroup_oom_notify() with
> for_each_mem_cgroup_tree(), but left mem_cgroup_oom_notify_cb() with the
> int return type required by the old callback interface.
> 
> The function now has a single direct caller and no failure path. Make it
> return void.

Makes sense to me.

> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

