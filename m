Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0694F10A3D89
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3476B00A3; Thu, 26 Mar 2026 08:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653F86B00A4; Thu, 26 Mar 2026 08:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569C56B00A5; Thu, 26 Mar 2026 08:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4461D6B00A3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:31:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E49A6160B31
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:31:36 +0000 (UTC)
X-FDA: 84588150192.05.1FBF782
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1EFEF10000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:31:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YO+CcAyy;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774528295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gEWU8VToNZlTstbGvcSVvvTALUEK39vCEMZWae7q3Ng=;
	b=umestaC2aak7SjzGyKoDL6emJzUrPFGj/rUrXn2v+slT2pBScsMHGwBzyocZuM4QG5pVSj
	qJOkaj3MzuZWQeXrkLbtO92tfs8qcdTHdK6e970Lfq2UN5UW1ZM4Nd/ELvJt1rTZl/ad+G
	O0Lswfw1oIO8vqriEnagHyDj4GZ62I8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YO+CcAyy;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774528295; a=rsa-sha256;
	cv=none;
	b=jhLrWTYbDVfFHpP4YoRZaEw6GhhS+YDPP3Q10cAK11clrgpXFQs+X5eTvwVc58gugxpMI8
	UyIWQlSe3U4j6aByyEj2LuK3cLelyV51ru6BMo5MOUL6VhhVC5hqFU+g0G+38muxE2ChjN
	UrZNWALJ4bhmwxtMkcNDbS6W9MV2y38=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C1C642D99;
	Thu, 26 Mar 2026 12:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A38C116C6;
	Thu, 26 Mar 2026 12:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774528294;
	bh=mYVRjum22wCN7KHGtoG+3bBzHU9b1WB0/yHYlJYiUEA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YO+CcAyyd+UxqKox1MoYb7gIA63PVa6WuBrt1uGObsCwB9tACMuiCvYfP/vltuVVa
	 jcRyyEOUWCnrYb8lEB61MAp4aRGLsEhm6o0nXJla2YhUQRP4VYkOlKDT/6A8nAdhvJ
	 2UhYM039ed67DUo+KSak6g+0IP4ICnn6PsXO68kBZO6v89sVc7Ip3YojYC531gyH1U
	 MGaazJyZWIRsllwO5f3xVDWsHO9UjmGpCqH8bTYbWTHU+dKgdyjtpqieO8JL3DzHkn
	 kZALWT1p4urNNNloM/U15eRnhwhluAF6W3Yg1o+jn7L2JRFoF3EjLuXIL4VE9AwMIp
	 wwVWUHhLAN3pQ==
Date: Thu, 26 Mar 2026 12:31:25 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, lsf-pc@lists.linux-foundation.org, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Alexei Starovoitov <ast@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, Gregory Price <gourry@gourry.net>, 
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Suren Baghdasaryan <surenb@google.com>, Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <f617acf0-6bb6-4ea0-85c2-d6f377a2a574@lucifer.local>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <CAMgjq7A01C+wyHxytZfVFVvaJ+gUNqkKvYN61_Peo911YaBHOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7A01C+wyHxytZfVFVvaJ+gUNqkKvYN61_Peo911YaBHOw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EFEF10000F
X-Stat-Signature: kicyqjcnsax5h7yp566b4pkbf6xbj1di
X-Rspamd-Server: rspam06
X-HE-Tag: 1774528294-288996
X-HE-Meta: U2FsdGVkX1+WJnnH5Ok4fv8n3dP3+h6EhlSlFXSvMiKOVJhY8AqET2pB5zjtZy8ZcSYOQj5tVc0+PbeQeQD9p2Te3OlRHcVt438ZkdtTKsaso1SquMiqqiaZ4QldyqVIcG6b747LZNTROnQ0JkFcE1wXWToqST89Ff7zU/wIvUMcD3xVaW0lReTo/yHf50933LySLq6JHwTaoIMWzzMsAMXzzPViIR2PAxW7Im/TVN0Irv3+IFqEh/QNvOHYGElICb6wcPGq7YmCNIe6X9dyznxjcCLMeffYUPAVN7vF5PI+7ZgeIjCRCfEYZseP7Pkn27tnfyWWuNq/1ttZgntTSiqXtXH3gFlR58PFApsX6kuJyMPXNDTgMw4j5AfIRMq5i/ABdsPZSiawguRZk5ex4Wo1PkNM1Cc0Pnrl0VNFEKa6vLLi5uIQPEn6ehoqWfcFJOovA46gcSWIWaBV2zpgG4MryFVE8w7PamwxbOvkGSHK84Z0HwrYbaP6u4RUuVwM/9xYwC0NdDjP8RGb5sv83lfEyhOYHQv8Skfg2uibl1tTCi9ZohxMuOLNBZnNCE7kjgRnGJYblKypHd0YqnzFCOkEmmBtgreN2gGcVuMXjCDZ2HH1IFp1onZ2OANbpyB8fpwvDC5EoKlhPM2fb0VMJ9emV2l4LdWqcbh2WcwsWuLBdDBbNa6vQwCZ/yxvyiAIiSlGuHymBK6ulss25w2g2U6GG9HjLRZck3shCj3Ep76qer7Q/qsSiolTkfJp82dL3wpa7UWNiH/ozbo5OcCjLtdRxKOqycEvo/KhNCrHUrPNyfkfArWbMQXHgMnqq5c4MQ1ZM8uapRnRPtjQauJQAyF6oB0yWgOGY3kgg9C5qCIFFN/fOhYJFhtEHcJPW0u/TeP7l+gkXiGJcj/Mk8y0x8txwDDKzg4RuPccnEZJVw5Ajzi4EJFCEFQmHyFJGM+S3vkU+JGi1ZME7uRMjJ2
 CxT5nNfI
 eJqP4B+L9teSayFALPrT9gNVfdjWerxirLvlmrdFBI1KrCt+p86u80AYOxMLhTRXJh71fW7LGJ7LAe35vpCp9jlUAfKd2I85fb4URPFo7GxNb1PlOCXW3Jn5AlNXk0pmeEql8t3Cjuu7RhqkwJoH15raRAMTvDFjvSQEd++e5bjbFqt+pMWkFShZXGCfVnO4hYd5lpUQi9iqPvDy75woRck+k00lGMSggka7DWjvcBd4qDvDnU2AOQgzdfrBhOO9BfanQpmnafzOOX2N7rcUpzb2OTn1kphJkZCR4aMAeGuML8TqpAtpZ66sDMJO+af9m32iulh2Z0yUU9j8nxQvTN+5FKkZOvfDgiuf+5wfF3HdZQnDRtwaPLc9hLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Gregory

On Thu, Mar 26, 2026 at 08:06:13PM +0800, Kairui Song wrote:
> On Thu, Mar 26, 2026 at 10:05 AM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On Wed, 25 Mar 2026 14:06:37 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > > We should unify both algorithms into a single code path.
> >
> > I'm here to ask the questions which others fear will sound dumb.
> >
> > Is it indeed the plan to maintain both implementations?  I thought the
> > long-term ambition was to knock MGLRU into shape and to drop the legacy LRU?
>
> I personally also agree on that, so far I'm not aware of any major
> issues with MGLRU except some corner cases that are not hard to fix.
> Once these are done, I don't see the need for more complexity.

Well... :)

What about the issues Gregory raised here?

https://lore.kernel.org/linux-mm/aaXM7xNSJaJBsety@gourry-fedora-PF4VCD3F/

>
>
> > And that Linus has expressed such a desire, but my googling fails me.

Yup I know, and it'd be ideal to have a single approach, but we definitely need
a little more assurance this time that it's the right choice :)

In any case I do agree with Shakeel that de-duplicating the code and 'stealing'
good ideas from it for both flavours of reclaim at least to start with is a good
way forwards.

Once we've done that, we can work towards eliminating the 'classic' reclaim if
the data supports it.

Thanks, Lorenzo

