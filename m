Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AE54C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 08:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461106B0095; Fri, 21 Aug 2026 04:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 437DC6B009B; Fri, 21 Aug 2026 04:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F1F6B009D; Fri, 21 Aug 2026 04:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11D726B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:59:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D51D14036E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:59:01 +0000 (UTC)
X-FDA: 85124676882.09.BF7140A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id EE0C3140005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:58:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVgG0YWk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787302740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/svEZ96u/XgpDcn+/+8Lk9kAWvGHG4PXL4nB1no2kT0=;
	b=lb8iYKLhZsv8LGixqlTzkKR3OyN2i1YgqID9qlu1e2GDyhu9Lsc9EtKVGYnztttAvKwo9N
	U5KKyOnnqQhZlss162jKvfKFuYNQW4ILzCBSenBN4WXKEv7s4EoBvKHi3ADgnxSm6DjnXi
	LYY0CS5c9oL5EhaL2OlmCqOd+pbFcwY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVgG0YWk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787302740;
	b=RffT4ay1MvfwMmCe0JPXFsWPGLOvUG6LJIJV6jEgS2CjMktUNsG2qKwSRVoWijDiaLLdMe
	yjIDwdUzdPtNLjtBrUy2HySBxCut66MSzzCiyelnY9vKqERLPWeVxQAWD2mBKcxJit4wRj
	rWkIoogja+I2HHHHO98H6S7kYE7JQFE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C5C760DBF;
	Fri, 21 Aug 2026 08:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A3B1F00A3A;
	Fri, 21 Aug 2026 08:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787302739;
	bh=/svEZ96u/XgpDcn+/+8Lk9kAWvGHG4PXL4nB1no2kT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NVgG0YWkXKLHdVuOJkonzqIhIVR2HYmY/jEGmlu1+tTGtqx5zpcNbIMqgc9EpYLAp
	 lISq+kipsOgr1sgA2POu6j+GyAbz1wYUe1h4Wiir1F3gNYEw0Z2T+oBZCEzJfWWhTp
	 Q4skTFdto/yRNMaVUvCbswuz3oltufek1wfE+q788FZbXIdERyBh1ex3jK5+3FHtyj
	 zJ+5UjLmIdadRJ691Nxo9bmI9DfmwCnfnhaFwTqIujf9zTlS7YoPp6SqSDJQn1LmM6
	 a8p5S8RXsQd9ilwC5O4LH/JYTz4vfNte76y8Yx2poGDWIZ/1Cr68s9Cu3Mo4yYUaxZ
	 hopwQha8dTCYw==
Date: Fri, 21 Aug 2026 09:58:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
Message-ID: <aogQ6iDA7RkuTtDG@gremlin>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <aogMyu5R_DZRqp2J@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aogMyu5R_DZRqp2J@tiehlicka>
X-Rspam-User: 
X-Stat-Signature: yncrkt5a1j9g78zscrtcyg74mgkru1ph
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EE0C3140005
X-HE-Tag: 1787302739-623619
X-HE-Meta: U2FsdGVkX19HuRmRNX2KwC7+MKmIasV087eN3wd9+5CnVko6wUIP+n5AgGndhiqvWFQ7Pj9qTG/9o6hDSNKiIQHfgNxDjzadSdHHRkBXwry0fLAI8ubmV96Z+ibHJG038kdGo8zuJ85zZyXV4qLF73WUJjCcEinQlTt6AaKXm0y2R2XxfVSYyPrAi8vSPopIcdwghE4yyiNNHaGzaYqANNV2DaZA5/cjmLheJPgCHpqc78OTpdEATnxtH8KMwqnOPMF+jp2onDUnAR8jCd5gRCNFyFtynNTQsRDCnGnar2WCrPDBjPEIWEKQ96SSjOWgh7kIccbP2jtkLjHdGBoWIasQNxWzhmt4SAT4jgsPYe0UaM+AnR5M4NE2jCFE5Qh2VzruCYq3BzxCZ8xyovgAtZ8VlVEJ1BNTCcdcboNWZTFbTwGubd1eRfUuBVexL87HNFGT5CFcrNttqDOgZ1i+No8wH1xbL0Gdm4M3ygWhyug+gt7tBgU9LR7HnlNrRnuAvR62ICV76ZxQfxn1kdhDwFfFhovg60d7QjCqmHJ1RhjgFIz+Sw6PM9zwGK1OYU5M2F8r3XH9+c44ZQ2Wfcf0j89FJN6+oyJOtGLo5qJ7qnWy4y4Vnnklzw6jrB/l4/vcAZ5/32c9HLkqeIbb5KJxXhVlS0RSLN1pNg1mgGzxZ5GlsZrFSHmEJ2jknh38w5QSffuX3jwHmfYcGsaE2phX04OLs2cqj6SxgXETZDgnuBR1tvYAv4s+9ytu59UXupJYvyoBOca72g8FvgWs8bYTDOEQrnQIM5WYqH7N8JyI55Jf1WnLBDncpka4uc3B/Tv261QM080LNvc5HzLHxbtYUtv0gtEd7BMfcqLyFo/ftya1KofDGQC8Xdw/qBTkwKpKRI9Gp6HjoT2+L7OIYhj6JXddxD0pBjpbHhIFrSZnsMhm8bpPjj+miMYiSJbL65nj4yRRnlctPC0dycWRvw9
 K8+siq/w
 Ds40Uu0QmKaWMl7OWDIw+9elGG6rAUHa3jFoY4skqggOC/waBCl5mTBoLoTHyaj7pqhvXtTA6LnBQ2EavGiIqfTJe/EEUjCJGsKt+1IA0iH39cI/CIWfjAWmXqf5zLi635Pg9hVYgcsVk4XEl1gDhdvvEpxkTxYpierfEd8As9XSxKkx44zvtay2NdVRzOkJ6TzGnsBXgzjdPKOPdXn91gpn8SsPuGgJ7PgIVqQkoZGceRnnxl3UEdNmlj+Ox4H9ofM1W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Roman for suggestion.

On Fri, Aug 21, 2026 at 10:31:06AM +0200, Michal Hocko wrote:
> You are explaining what but missing the most important part _Why_ do we
> need to have this addressed? Is this just addressing Sashiko review
> refernced below? Is there any real usecase where the current behavior
> matters?

This is exactly the issue with these 'unrelated to your patch but' suggestions
from sashiko.

You end up in loops:

        AI generated patch --------------->  AI generated review
                  ^                                  |
                  |                                  |
                  |                                  v
                 AI generated 'unrelated to your patch but'

And _at every stage_ reviewers have to do _additional work_ (with ~50% signal/noise).

This isn't sustainable.

We already had _too much work_ prior to the slopgeddon. Now we have a multiple
of that.

Roman - I really think we a way of switching off the 'unrelated to your patch
but' stuff per-subsystem would be useful.

Maybe we could figure out a way of funnelling this stuff somewhere separately
longer term.

(I have I think 2 slopped fixes to rewrite after the previous what like 7 or 8
this cycle? So forgive the grumpiness :)

--
Cheers, Lorenzo

