Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA372CD6E6E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 01:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02846B0005; Thu,  4 Jun 2026 21:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3B06B0088; Thu,  4 Jun 2026 21:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9546B008A; Thu,  4 Jun 2026 21:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF8DF6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 21:52:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 391E8163CF8
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:52:27 +0000 (UTC)
X-FDA: 84844184334.03.5F6F4CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id A072D20009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:52:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMI9oC9W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780624345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYZKQzJ7zPWE8IzZN6QipGkw8psLqfyPxmzoQEcOgD0=;
	b=KRw19qhxqv6c04bZBefiIVW1wVpK2N0zlVsZDNzJSmjVYJVhJW62PwcHh+eooWVNH5F1dQ
	rZy8VrNneouEW9tB+8DHjPiO8nr8pRSrfGjvr7ukV1GkhnR5WWRqtNWxvLapV+DrFIy165
	0sB3aIMaFxjsgp5gmcGVSg2d/xCVyK4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMI9oC9W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780624345;
	b=OaN0Bt7zbEc1XRfVWnYtxM/WEDZtnMijHXZQSn6Nww27XGeXfOat9b4ERpWAx1fmfHZl5k
	3uMLdJo/1r6m1z8xpjRChdNGoA475v2L53aWso74EWyxPsUeP1tgoK0mCsf5PsVzFnswCr
	TWKqh96YTqj1cBueSmBv3U9DcxXdYTg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AC5744418;
	Fri,  5 Jun 2026 01:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB1D1F00893;
	Fri,  5 Jun 2026 01:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780624344;
	bh=zYZKQzJ7zPWE8IzZN6QipGkw8psLqfyPxmzoQEcOgD0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RMI9oC9WkY4Vd3JhcbLzodR4vkSfN1AOUPQ1Y1xPvQEhB9E0f7J2IhtI+dPwwxfUo
	 HPM1Mb4t0fCtCW6FzTJJ0Fn9JMD7zInl5p12tWQSu90hxDg2/6xBaULX42qVRpxruP
	 WyDyV8+2PT3n1U7TdbjJzHZ034mzIdT52x7lF6QG7N/JnnujDaETGwgfZTVNu87fEL
	 h9Wm0AYmBmBAws+3CIsW8yaPKsvrqpShR1J4e9GU6uKV9VlLCVwGqWI7VNFyqPW48L
	 3mMt4S+taTAlIfip+xmT1Me+n/Pw8WGthEsx+RnzWa5yB00vwoamZCsMM9QvhqeX9B
	 sJlHBeCQg34Zg==
Date: Thu, 4 Jun 2026 18:52:22 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Hao Li
 <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes
 <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Simon
 Horman <horms@kernel.org>, Jason Xing <kerneljasonxing@gmail.com>, Kuniyuki
 Iwashima <kuniyu@google.com>
Subject: Re: [PATCH 2/2] net: skb: isolate skb data area allocations into a
 separate bucket
Message-ID: <20260604185222.794ea329@kernel.org>
In-Reply-To: <20260602183122.747759-3-pfalcato@suse.de>
References: <20260602183122.747759-1-pfalcato@suse.de>
	<20260602183122.747759-3-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A072D20009
X-Stat-Signature: dqcdqqzh5da51bffnh48f9ojpcaakn59
X-HE-Tag: 1780624345-593612
X-HE-Meta: U2FsdGVkX1/H14qWIzEPAnNQnIANbyAezrWf0/zL2gp0msLCz80YQV6bvw9Y8L2EY7dVjXKYpI0HrELLqMdrekI7rb41Es4KcZipIk1bpxP2fE0+8rP30YpVtbIgoR2LKwYrwx5AncRPwnK6bWzh016+AMYndub9lrcAkWEpB/iaV4svLR7b0nvA9pBBQc/cPsHKIu0DtqXai57vGnt+5kpNWVO7JNd/fjA3owo1MdkX2+rI/wANKZheR5/H3o/yAkNWYel2BUH2+PWO0eGgUZ4DAa7pYyodVcwxAGn9nNT8J+1gBCbGAuhyjH3MN/zthuLlm9Bz3vzOoyJrjQqX2KGBUsnUXwqOd7U1u8935Fjd/fHrom7dYQ4AUM+fjXdciG5HUVntst3sv/AzpbDzj51tgFgKJ/8ShTlImTlWTeOYZVhvlMBlhRlHJkaiWrAxCfGG47DsFS8UjCHeZbk1cXK/eXarUCvUEOOHlvHKIZtTD+V62rt3ATRAlBQ814Wspo2MzpOconIp1ERfrGJB+j2JAPNrDNwBvebEEeB19T2uJNv162mLQLJS+Fs+UUVk1F3jHY/QFsPYbl/BTHjNZfn3Q8X0ZqZU6Umvs9uJpm8+KMMOAjkAquklkI4jpP1xFXkyLxgFcgCUj2aT5y4IZ0Vbhm/4qWW8cR1C5OmKtCyTqi9laqlbNUrxiPnOFRGjEbi9AjiQAwUmjG97Zvm5xq1+uMaetplqhZmO+7o/K7qQODNtxejlsKLQ3x0E6kktWqMn4yC9mzbBxns4l5qTz/vEhNfa4vcpdELn8LHs64DEHMXVURR7l2kPF02uwxTWz+eZDbj8ZxCFtO6a+PHooehsyfQcvC4jr4YdmaiwK/hY1HOH+MCndFwEiBlSYXv5FJUGGZShuJ3TO34538zm71x5DiUo1alWt8tgBl323cTvSg7JyYhiKm3iCr3FezZK36Xyks5xJ7yOrK3UkKw
 vGa+9t3F
 Unw15FoHChuVWRUe44tIaNBe2EZvr0L8iE9G91W2BH8NJ99Z7yk4Sm4ou62fTtTtMK33BUjT77x5vHVe9jx1ntPUlk0bdje6MRR1kxfEt8pqTAFZAh6PjImu1rRCDsps1Zy9K8aA0kPiO9QDGTv4vwij+zKy3BCALVTaqhg/7eNbMOiZP8qLNlQzWTMYsVzIcWdeJOR4OKLE+tCWY607iwX5Vh2KqxqF0N++TL5Nz4VsFRkEvXsrLBgAAyP7ezHzPFZK8RdjzGTtC7YpmS9lHx9fADg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  2 Jun 2026 19:31:22 +0100 Pedro Falcato wrote:
> SKB data area allocations (as done from alloc_skb()) use kmalloc().
> These allocations can be variably sized and their contents can be more
> or less controlled from userspace, which makes them useful for attackers
> that want to overwrite a use-after-free'd object from the same kmalloc slab
> (which often just requires the sizes to roughly match into the same kmalloc
> bucket). [0] is an easy example of an exploit that uses netlink skb
> allocation to target another similarly-sized accidentally freed object.
> 
> While other mitigations like CONFIG_RANDOM_KMALLOC_CACHES exist, these are
> probabilistic. Use the existing kmem buckets API to further isolate these
> allocations in a guaranteed fashion, when CONFIG_SLAB_BUCKETS=y.

No idea on the merits but from networking point of view:

Acked-by: Jakub Kicinski <kuba@kernel.org>

