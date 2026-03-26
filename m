Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66BE6109E535
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 02:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49CB6B0005; Wed, 25 Mar 2026 22:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D37E6B0088; Wed, 25 Mar 2026 22:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89B286B0089; Wed, 25 Mar 2026 22:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 740DD6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 22:05:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 19E571A0B63
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:05:52 +0000 (UTC)
X-FDA: 84586573344.30.31389B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8208A14000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:05:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=waC01LrU;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=waC01LrU;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774490750; a=rsa-sha256;
	cv=none;
	b=zbtJzHqbrJdJqEuxqErOyHbOpQc6EIekE6PIsbgiAvreGfeKT41e9wAVKqkaAP2IXoq2je
	XI1lhlVqNF30TC3kHZCTIu07I0st1OHieTR372xfJMYZU7ZHmTg1+9SP8u8J38ec2GvNnx
	uY1MMLQlCNqQeOOJoX1FeoHcjOynURs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774490750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZfkWCNYXidkhf2GV1pwb/tIy7jX9dmkvCKwEgK8jlW4=;
	b=cswEMC4AcAwTykixBB7mkuHP5Xbbl73Aa/DyXMbJaHCls0WbYqRahmBlkhSzxIUl9FMvyd
	Z413I0eHl2/hLtFLBD7zes7foXABdYXehIIgTZoTwygYwlikfTCVKD01uQPNVTDhPXNIna
	KDj/XlZNOEM51SO+nz7e11cFD5/yOmI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C58A260103;
	Thu, 26 Mar 2026 02:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C22C4CEF7;
	Thu, 26 Mar 2026 02:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774490749;
	bh=mtEUOAMPeIXBSy2/Sy+n9/8l/Xxu4HKjYU1IeLBTV3g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=waC01LrUKtqwDboD0zEDswPZcsahgJD1uLbD/7QjzJzzupbiu24URsshBggUB+xzA
	 Xrq67mNtGKsN/bJW1vRyA05MrAoNr2Xty77pcDVoobqjk5SDSLH1JCH9qudptSfdM/
	 fl+dNzCqfgdEIDKfvIf4iWkOKR7YfkAYa0jTA1/w=
Date: Wed, 25 Mar 2026 19:05:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: lsf-pc@lists.linux-foundation.org, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi
 Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <ljs@kernel.org>, Chen
 Ridong <chenridong@huaweicloud.com>, Emil Tsalapatis
 <emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Kairui Song <ryncsn@gmail.com>, Matthew Wilcox
 <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, Gregory Price
 <gourry@gourry.net>, Barry Song <21cnbao@gmail.com>, David Stevens
 <stevensd@google.com>, Vernon Yang <vernon2gm@gmail.com>, David Rientjes
 <rientjes@google.com>, Kalesh Singh <kaleshsingh@google.com>, wangzicheng
 <wangzicheng@honor.com>, "T . J . Mercier" <tjmercier@google.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Suren Baghdasaryan
 <surenb@google.com>, Meta kernel team <kernel-team@meta.com>,
 bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory
 Reclaim (reclaim_ext)
Message-Id: <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
In-Reply-To: <20260325210637.3704220-1-shakeel.butt@linux.dev>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8208A14000E
X-Stat-Signature: dfyqezmhpr8du5iegruxgsjcb77k47m7
X-Rspam-User: 
X-HE-Tag: 1774490750-930474
X-HE-Meta: U2FsdGVkX1+trWtaPtii1on2c5pZCbsjShZ2tNni70TtaKM07ysvutADhNq59k/NZX+ZKMGMuG8KWX77ed49Kn7iha+R1Ka/stQGCoC997m4tpZX5ExUfSdAe8BnqrC4z1wh1APrpFIykPQKrNUfcMfORGxrcfUSeyLR21Ad4BXvAonMzfzAS07RjkD5PEvh6gk+ErEN4sypycnBIfy5R55nisoK/VHnG4VcF9WpVAPgjir6CCUHscn6WvqJK4F5PEXCJ52HdGhDifgeVYn1DXzND7zZzM+2rapVeR2ZgDaGhGlIMPxEXAk50sgBDP0aOjGlzTblffuTZhBJ712hrZKM2GbZQUO6cWJfl1n0ya6T/R0kkdVUgO+cixBlKyrktrGQBxp/A+hZet127qo2LVq26xEdmzeKY6ygwJCn6kyCt49vbnLPFpAAREDGXqC+Boy+dibiC++fJulqU9xgRKyuzFFjjhWvKVcWXic41Qz9zwtARPxT00ja9LGoyAOjZ38+1NsF0xYcaPIeBVbSRRX0wUvURXR2D2HG0kQAVy2nHhv2Eg6UEnzVTLBlpiAYVesMcfLfE7/pK1/XCIzzLru3BHEPB2kQJYn+J4DKzeFJN+JQu5Mke06BxKw+xTSKhgA1FqzohkvLlN7p6sK6TvscAm23GY3HPvMR345EvefyKGBX7wu8NNY8Wv1GYYpHRvWge0xtg6Xlf80ivF0qkp3yta0TNDqDs3zaI23iZu5WJSbyOyaFRr3dCc8mkvtbPtMQhjSc40RbeYYVslvBok/nKbWCyCyoUEEav7/GF70jpbNeKOVCsiMrSzTp9LokefRg1leZD7ulJO2yOhspIYzVeogl+fPxf6sFFQVGPwQxuGkRAoC+/70ka+ysF0poGdOai12Bp1P4QQvuncuQ+kETg6WJmWR3a1XiFuDusTJvEmdhdwkeijWNkMC+k64aRRHAF6A2MNfQPXOY3oa
 NtdzPWZb
 MGcGlK8hwfNBWvYoogD9Ymq2KGImA2UM9eaLlDpnX/3G5TVoTPnmXlVg/eB8nnR3xMZxFulkjm97sYVw8h/e0kjv8NxrbcAxPoFLQpldQ1l99S+/EOm156In8zYxS2p/U8lQB4RwgCQ1/nx1lyKTU9QrNgbAXP5hoEu1JE+nf2V4r7MQhcXgEUA/V7G6Zs32mAnt5eVC39p+B+OeDqO7TStTFi2l0nwX3MIK5IuFSX+6/vAbxXj6PCfaW7YVWZCpXv1iWc5kF8YsWv0K5lO64n74AkeqhDeEgP0sjRTHiO+72oOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 14:06:37 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> We should unify both algorithms into a single code path. 

I'm here to ask the questions which others fear will sound dumb.

Is it indeed the plan to maintain both implementations?  I thought the
long-term ambition was to knock MGLRU into shape and to drop the legacy LRU?

And that Linus has expressed such a desire, but my googling fails me.



