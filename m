Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C7AAE9DE68
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C19886B0005; Thu,  9 Apr 2026 04:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1496B0088; Thu,  9 Apr 2026 04:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E176B008A; Thu,  9 Apr 2026 04:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A54526B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:27:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49AE0160421
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:27:48 +0000 (UTC)
X-FDA: 84638339016.25.47F99C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A233640013
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:27:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DDjVTAIi;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775723266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XOLbiyFZ6yUTc+lvkxPmguuF+R5YrtfocWqBWRVawTo=;
	b=bgC/AjEsD/oXGTRStufINqADR/jFxMJlGi1BLilN+XoDdux3BkpZT+BPmWK29I1nK9zqOY
	sk75GIjcot/kcsYJAK4X5yl71DfyKUMUnEyckukU0MzEAbQFyM4XIc51S2yiab5XxLpgMX
	dQDifzux+KOtAp2AR/yz2nzNNiLtW68=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DDjVTAIi;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775723266; a=rsa-sha256;
	cv=none;
	b=TVaastBdnIsQhWzGGoHhmpc4fuDjsjw2nd0Cm1+x3QNON5EbQxkWY4Lj66mjHg7yySk/Gs
	25kFOtNs5tpZyv5L7cz79OrtsJL1UjNc7iIHubEZ9N3cb7ynFa8BDUGCVjY0HEG/IoFO+G
	zVNBbBw+WHtzbdAcEBCh1d7RmaU//qs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A0F9140DB9;
	Thu,  9 Apr 2026 08:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F0AC4CEF7;
	Thu,  9 Apr 2026 08:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775723265;
	bh=XOLbiyFZ6yUTc+lvkxPmguuF+R5YrtfocWqBWRVawTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DDjVTAIip4E5V92VROBLPSNEdCRwyYe7VvOXqlsaszBjwomvTUkfdwYa1WVb8oO7a
	 Tzb1od3eGe+AysPGY6/Dv0kx+EQT8nHOWUr2CdAumZOap50cHVsAvhV6g2vE/X2iEC
	 3AqSDNRKX4otwBgcIh6cVZtLMtB8Qehn+pXh2bXQNVZ+VshbERf9HhuNuQqodsSrFZ
	 AcZWCVEJ8yuJZ0dKUcLrI3MBowViBvmIuFi8U6YN9ghjHFE65x0bSMobAJuQtvA/fk
	 Pjb7TBluBzfgyNVOcASwY3MBDd+EVSLLRp2PvyM+K1D7GvSDdyN3zsVIsd7nh+K8Ok
	 3hgNqLlysNMtA==
Date: Thu, 9 Apr 2026 09:27:40 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches
 interface
Message-ID: <addiCaDKTWYge-3R@lucifer>
References: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
 <addP4MKmA8zfSN1o@tiehlicka>
 <addRr9Vn_LNiXp11@lucifer>
 <f8eec130-efe5-4e08-b5b4-a9701ccc7056@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8eec130-efe5-4e08-b5b4-a9701ccc7056@huawei.com>
X-Rspamd-Queue-Id: A233640013
X-Stat-Signature: rgdxy4gaddgy9uq7hjbnza4843c9k6sh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775723266-953364
X-HE-Meta: U2FsdGVkX1+V8vE/N8FSN6PoUcXcpjpt9kj/r5SOvuKFU6pmfE/dedckyS5rycQD9cg35G8uWxfjgCkjwGgTxLdrBQPkWJOpe426L+VQ8YDste5dzvg7qytgc+yrNnA7U5buKBI0aOUf9r3nKaxyylLKY/Bk77gF9f/rLLSNkhN8M3L4dnCy4M4wekmsPxHa2OZI9FnV0WUHmXllAb4c/oCidlLJYaBVPQw7depNnO934gsziZ4JimrVkoVg48Z5o+PYCqrwHT5XxwyfhYCHj8cdUy9SGEl2PZSDy08RI79yP0zYUeGnlaXeU3JPev7w0wCGNLyoHMEZBotx65buQRhBQMybKefG7zba/T7i+UUlKNNqphwCp2vyPSoN/084o4KdiV5YUea05rTjLIW79YMkvW9wRfyNKPI8oz+S2Ejszr+706H0o/MMFNwwSkdRr91DyzF0Fm20fvtQQgs2w8aS/t5iKt3+DBPu2G1Ahst3/r2ZD6CAV/m1JsEhGHe0FGDyUm3TEsoHzvu85kxz3SPPmz98UjzZwL/0AC//KAhX6gWEqGaT9cPPmuEMCSx0z1SBEL+nLKqG/n/p1yjYB/wfBQpO/L9n+yYGWUS5AWTPzOf1xP1FEtuc8aDTkY0FayHdRuoxXk42gRBz/OkCQV5EGjGn1aA7QsxfXPfJJWlV6B9mH+Uc8CmnssotfsqusRASseO+EiqVSgrG6ymttPCwKAT5wAiKrpiqadga6xYyrqT5pRlz+08twaQgSn2ld5YPwpkMR6y5GKeyYqZ0GfMK46gee+S7TuvOSWLkGlJMg0cMQPzkUORGChq1amkOZemiXtjhUBF8AkFiwEPv5nMprBZpf4zanVNjWNraNvLdTr1pJS0/VF4wRnNkrx6V6uAhqC0q7w5S2NfkCq+M8m7OTJrdEitp9qZPrEpq02fNwDaM7yJ+jZszx7cAFNV7abMFiHB+xlYJlt+c6PA
 z6KoQNbI
 S07BCD2mC5TkNUAwq9bwIRaoTWzgIXU1tpNfdbkNAybmhzPm91fOL5b1CFVplfrpNegjsG0X2SP5ii7APm6ru2VAPj8GIfRsh92wIxKwnbbHNXdaw+UvylwgMBLq4fQdK9tqjcSAfv1nS47fPNuqY2T0pHU6X9jUwHBcDzCiv0grt/gdWV9BmxALyjTytzpVK0lSU3qu/KCkMm34I/JP7jv8JP8yK1oMImVm/1ov6uU9h3sXqcLE+EY3vkgFmJhyYgTnlUX7Np5bUBa/BOiWhZwQ9+OyTJZBm89+YgHHgAoimlYROnrq9QhQtpsXBYROP42t6alGHGMpBzpQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 04:21:43PM +0800, Kefeng Wang wrote:
> Our use case is as follows, for hot-pluggable nodes, for anon pages,
> migrating them to other nodes, but for pagecaches, just evicting them
> since pages could be refaulted. For mem-tiering, a large amount of cold
> memory is stored in the low tier, we think that evicting pagecache is
> better than migrating them back to high tier, also this avoid the risk
> of accessing potentially faulty memory.

Hmm, this feels like it should be a heuristic in mm rather than something people
are manually triggering by writing to a file?

I'm not sure I'm OK with us allowing people to manipulate core mm page cache
state for non-debug/synthetic perf analysis reasons.

Cheers, Lorenzo

