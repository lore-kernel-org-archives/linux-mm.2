Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95712CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 19:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 672B46B0088; Mon, 28 Sep 2026 15:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A6A6B008A; Mon, 28 Sep 2026 15:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587D96B0093; Mon, 28 Sep 2026 15:19:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2436B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:19:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C091280316
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:19:40 +0000 (UTC)
X-FDA: 85264135320.17.AE2C1B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3D3781C0008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:19:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WAYnUTXM;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790623179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3OTxVK/IdLEHqgZUY95Y42pkKEW+PjtSBC6ONnLsZ9Y=;
	b=VUyiXgHkXEWdItoe5cAq/mjRKf1PnurQRmrcyW2Nr5471KFdjwYNjPsFIupNi0IhhZmtT5
	b011bYIw816fDNy3f+invGl4Y9g0SHi8RprbfM0xzFLAiC8AbbO/n2R2969EsE1Lx9x/np
	P24Od8qFb22Qca/so2CCfQfbA8+op8U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790623179;
	b=8f7d1ENTh4+oCPmGpbZke1OQs0gIycRmmpHSG/amMxx5TwFKNTIl0FaWMZBtTUDgW1VTKE
	KeETfbKnog7CtdWvPG27C+zzI003ixP3k7S2tBUWUM1Mo1L3QMac62KW7dwY358a+8G22d
	It3RPdXK606cEtogDwHQPUWe48FbVLA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WAYnUTXM;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B9547600D1;
	Mon, 28 Sep 2026 19:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BAA1F000FF;
	Mon, 28 Sep 2026 19:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790623178;
	bh=3OTxVK/IdLEHqgZUY95Y42pkKEW+PjtSBC6ONnLsZ9Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WAYnUTXMTXFJKySbFuqmzPeYKgqYlqqRd7oCs3fqws60PvxNF/9klFq7Oc0tur97v
	 v2klAFQ0UtKjB23cHitm4X8qmLcY0tql6Sfay8DLht6bG41WBKFxrtPijuj5XzIKyW
	 /RENMf0MhvCZ9/bNd/7Hx1ljqhzWXqJnaUN1Whoi1WK1/tJWt9JF4rWiswaTBi48Dg
	 EbzImNa1nN+ucQhgWHRlTi0W0x8A6k1dQsXIM67gUPzMXzz75Yg0TfwpDSAqw87viy
	 WUf82vC80QtmXOSQSNGU+hi75dVP8dHJ6WHuEq5Ix6PFeyY0nQ9kBSmTehgred27gu
	 znOwWLZdQ1T7Q==
Date: Mon, 28 Sep 2026 09:19:37 -1000
Message-ID: <ee85445f60194cfbc78897cb6fe744c7@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Jens Axboe <axboe@kernel.dk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Xin Yin <yinxin.x@bytedance.com>,
 linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 ian@honeycomb.io,
 stable@vger.kernel.org
Subject: Re: [PATCH] writeback: let foreign flushes reach dying cgwbs
In-Reply-To: <20260926-wb-dying-cgwb-flush-v1-1-a8d898085a3a@honeycomb.io>
References: <20260926-wb-dying-cgwb-flush-v1-1-a8d898085a3a@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3D3781C0008
X-Stat-Signature: g56wmghoc3o563jnw7og6o739dke8pf7
X-HE-Tag: 1790623179-439125
X-HE-Meta: U2FsdGVkX1+aQh/V3oW1Iq7SGPvlS2lsU4IlxdkwG+OF5CbeCnHxJ5m+W4Mxyv/T65FpirUpysX5WyhqJuZQnn9zMjVzAU96Gz7/xQ4eKbTXqwU+YLU7R0oqIr7+OXKipJDhCNs6jms0PkOgxPp1vPoXwciNfHdDr6oY9trIQON1G/EuM3lXcNzIJozcBBW9Jxj3S/oAqlZfE1Zuk8uGHuR3nEvcQ/WTRLoE86HpmPMU52Ro3F7UVkeueA3CBvYMXk94k34TPmQB0YUdVGal0ZtQbw3tgkBGo1Rj3J4mbg1ZbP7jT4S4aKnxrcYjdJSKdefT6ptgsYPRQ8m4meKx6qtawSCADvVzk6gs6TihpLGzt7zqtuIIxESXZs8M2WRYkBRKNFULRLVyjYPf03bUs51qFmUMM8UgkfS9Zu/8rAbhSKGpQn2UMBO8JciwPX06t8xywjf4csSXKj5UPQWG9HcZ0HRU+7Ck4N3TIftAqilr0JjxsclKe3BgtCAjtlhP0kz2bUu6XmSJAjKizCmXZIOF3sOPF/2LOqE9YKHjXk5Lcvi3Cmd4C/On1BDI5gytptTwIPpfcnKR2mm3aWxF7bgMlEoZKzysAdFGB6zWN1n5YXhAAVDmfmxCy9vxf24aTXjNXAwT0JND/CKQBMcC3I5NsS2G5ApbczqUvL4cKNJRaWNNQNIFzxFLCb5HAlkKXRpOXMaekwTHyz3VUTAixRTFWfN4yNwhheiQEP6VTTjpH9OOhGajXHw7+zIWAkc/lFd6k6iEMARR5olV1DV57dl1SZXEK4eIXbUdL5Laf8D8TOP7ZYQNk/lxrFHL45iabHT5xKuyJZk7CakmCyhKWz37TrdzTwc3UwvLZn2ck+2pOV+LQPLcGowrjFi1c6JegFRMHNE1aAp4OomayeP7cdKhgAPsNXW88xaJDwaR03oNRPwrJWZQrY8PNq7a3SZ5AglMVwfTMcYnywxGG6q
 Al3+Gbgh
 x2k1LwzjLd+IfU8CeY5JvShpWtGyd/w5l7QK73PI/yZfQRJbOq7k/eq6F0loYwdEbM252cwtEhmi4/61xKBKmeXEE54W3SOWnfSbrWHuSMA7tfiEKGzEOcjJ1Htu++sKOYT9N8rrVeSNn7IwcuD0Ge6DVVxFAnOI1Qm/8L9IxH2otKlAGyRUUseLkzvzkJjkFyP7l6wEmqFlnIzojTgDCEFcLB0VHgiut17gf3n8v5NDfoQGe/rB+IMZm1oqpGC9CLa7SZ6gCjY8Xpyp0/yM/H5V0nQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Liz.

On Sun, Sep 27, 2026 at 05:04:39AM +0000, Liz Fong-Jones wrote:
> Fall back to searching bdi->wb_list, where killed wbs stay until they
> are released. With commit 168a8c13159c ("writeback: size foreign
> flushes by target wb dirty pages"), the flush is then sized from the
> wb's own dirty pages and writes out what the replacement dirtied.

Instead of walking bdi->wb_list, can't we update the lifetime rule so that
a wb stays on bdi->cgwb_tree until it's actually released? That is, remove
it from the tree in cgwb_release_workfn() instead of cgwb_kill() and have
the creation paths skip dying wbs. cgroup_writeback_by_id() would then
find the dying wb through the regular lookup.

Note that the blkcg association check in wb_get_lookup() would have to
move to the creation side. If io is enabled on the removed cgroup,
cgroup_get_e_css() returns an ancestor's io css and a dying wb would never
match.

> Fixes: d62241c7a406 ("writeback, memcg: Implement cgroup_writeback_by_id()")
> Cc: stable@vger.kernel.org

I don't think this qualifies as a fix. Can you drop the Fixes: and stable
tags?

Thanks.

-- 
tejun

