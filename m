Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30296FD5F87
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 06:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B0EB6B0088; Wed,  8 Apr 2026 02:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362676B0089; Wed,  8 Apr 2026 02:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2508A6B008A; Wed,  8 Apr 2026 02:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0FD866B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:49:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 919751A09C7
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:49:08 +0000 (UTC)
X-FDA: 84634461576.10.BDC2935
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D7A5E2000C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:49:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O4NFTZAU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775630947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SenYDPdkiQKzoSg2iBQvwYuThBrOYOejVdxnNLXibeY=;
	b=kndZ893zi5KdlcbW1hT9rhtKzDA315HOJPrzVfSsahPTitP2tLka5rgGOWRERz0MJZZiLh
	dg1IVAGTf1AaD654s57yC0rFRUb8fj9/9HRLgB8K9LQPez2ZxR3aHa9bwKPWKl0KF8Td4r
	e9tFqeoBes2zcGY7Sr/otCfVrBleBTQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775630947; a=rsa-sha256;
	cv=none;
	b=8ppyr0ySENKJtZsCLWYn7ZNlDFrJj/Ks/5lItHiQefGkSE1so676laOys8p+yAvCw45qGB
	E/x+O5Rk0aAY6AW89ymLGAkSyf0DOAfFVDCoc3Rko08tjO7G9nq5m6ntO0ssUoQfZ78b6N
	xwllbp52u+yxY9a0gtKEK2sXt9CS+sQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O4NFTZAU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2BC5435DF;
	Wed,  8 Apr 2026 06:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DA8C19425;
	Wed,  8 Apr 2026 06:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775630945;
	bh=Jf27xk2PEb+D+m73rLzzPti70YoNYsdCvSbCyz5KRkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O4NFTZAUGXJlYJi1cB1XvfzxzdGTopyBo3L3YcY86XA142N96ZrAP2E8Z7cICnhLE
	 6AeES82rZ1GsQxLKVt6MkUHPfg+P7aIRFJgyQpgbmVrbSsa7jW85ipzT5C6LDcS0XP
	 gRoSDzQgopOYGZbbOnFfFufWbjcN0mV7jrsb6rLPGUY7f4w4xUxlKOoWXKNQODNu2E
	 mZd3Qix7Buh60T4+rmK4cx3a5t4M4Pm5adIEofTwJpiX1TKY3djbBbAAYSinFuRLaI
	 RP+58r0yTBQ6QMvYP/COqOMpaf/w8MiS5qx3fyLn/tFDdAP7Z2ZdXxVtxUdC6c2c//
	 HJbDftmUH6B0w==
Date: Wed, 8 Apr 2026 07:48:57 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, lsf-pc@lists.linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Alexei Starovoitov <ast@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Kairui Song <ryncsn@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, Barry Song <21cnbao@gmail.com>, 
	David Stevens <stevensd@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	David Rientjes <rientjes@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	wangzicheng <wangzicheng@honor.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Suren Baghdasaryan <surenb@google.com>, 
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <adX5txC9tGPR-iyX@lucifer>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <42e26dbb-0180-4408-b8a8-be0cafb75ad9@lucifer.local>
 <acVPrEyfcE4Naz5b@gourry-fedora-PF4VCD3F>
 <248a126c-43e7-4320-b4bb-282e0b6da9c4@lucifer.local>
 <acbgIKuwDsPvPjdF@cmpxchg.org>
 <adTonuzmUc2AzUhp@lucifer>
 <adU3P9fk8h-AmEp4@gourry-fedora-PF4VCD3F>
 <adU8VnzlLw9JUHB3@lucifer>
 <adVPAS4PP7wK0Pxq@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adVPAS4PP7wK0Pxq@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: D7A5E2000C
X-Stat-Signature: owsbxsyn1ncqqctfyrq5upf38u94bwd5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775630946-185888
X-HE-Meta: U2FsdGVkX1+Th0hFU3v+v5iEylxyZwJaT6zjq7+6EZFp7aHAl25gPtqgmGTp0MrHVUSvz16EMTebUKBucuiOQQfjSLVEjBwuWiFj3vhIawbYXSo1PRGLeIkoUvqRkFSNhJFOjUl9ozGavQ+r+LQE9g3AsmRZp458LiWh9XvSRWF1gIpySNs7PSlhhD4+CAAXx8nDJedB8gJjOOfTdPSpw4N179ZzgjBqeGuOy/Eashaoi5AnUA5+AzSzASQfXdhRugfV29gdoizu1ucxOC2wh/Ry305nMkqoc1QLgGK/Am46q/R3Mwq6ZSu8kpPheQ295ZplhXdF8DTEOyUHAS54tF37Q2Li2n6zgdtNW7C8n6zbMMyJsmHkSlbuvyX7u0Ew2GQn1xEjDg5g4ZxRKAtk4bH1dppAm0CfjDhuiv3b6zLU/1xnntauSks8WKHKwG7fLUiS1XWy218f0YVj21IHKSw+GaXQWZs/pjyWgdxHtw5C9k5ChkWdT/STStDpuAxJrISMu3YGjZn8K3UCy24KFM3i31K9qwIRjcr9N7n5mYFrIHq4Lfc6iE9tiIJkVojEaOo61K5wzA+8kogtjx4oPnVmLOEL1PLHYAdkg2W7Fjl1ogVwhwTghXjms7ZB/+c1Ex8UEnSnPvDGH96lD0H7PQ8Bzo2x1h7a0HgpU2S32uf2cMbgZS8aLMBjjed6ZSI8TFDcW13wbwEEgzcW5gzzXw0LvbM2m7dJ/smfiSG+yBfDHLYxaS7lr5wIL59szrl6m5JX/ARTnc8kLPsfVV8UJeRUizSsCRkX5lrEUqR1Agag00y5v677euKT3O0BOu+gdL1ytqzcEp0h/fERMcYxXQyknnSTYLmpk0TMAF/xDisYJSkPhmu/rRvMDXVcSHQcYNRq1VSIjpUbTsWT/4zaW9e2AhYGD5JHrnQM++UDdZJDX81pRdZRhttEtw8j37OF2okDcnnwgDzIKVT1X9G
 3pRPK5O/
 zohnW9Fr6wwapcKXs694Gx2YShDgf3SMCYJW3M468n1f9sb3jNLXV2HlF1Em2AZ1SUf6mjpLpUYIegVtFHGUcLDhyaKrPptruRsy04UrnDK/Uc8kkV82pDxiC1OXkJkSpnKEWFOIkleTiiYFsLmoKFr3q3jBhKjeE4tU3EnsL2cp1Y9HyRJ/CB7QpoQPi/y2q0ye/Oh+hBcomsMIejtNo+qB9deMbsWyKthP9gd75aLALvA51K/UzNfdGaxOgJCudUGBN2+bY6yKC26AjEWDvL85grDDUKqU5pqTJJZA3Je7RQ7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 02:37:53PM -0400, Gregory Price wrote:
> On Tue, Apr 07, 2026 at 06:30:55PM +0100, Lorenzo Stoakes wrote:
> >
> > > somewhat trivial work these days via <pick your favorite LLM> with
> > > reasonably well designed interfaces.
> >
> > Though to be honest, I did ask Claude to do this with some code before and was
> > really impressed with how quickly it came up with something.
> >
> > Buuut I've generally found the code LLMs produce... terrible? Really terrible?
> > So I think you'd want there to be some level of human improvement there.
> >
> > And in any case, maybe doing things this way will struggle to really represent
> > real world cases (lock contention etc.) but OTOH, being able to simulate a high
> > memory pressure environment with certain parameters even without [the rest of
> > the kernel] interacting might still be super super useful for diagnosing issues.x
> >
>
> There is a concern people start looking at these tests as signal for
> performance regressions - which is neither meaningful nor useful
> (unless you fundamentally break list iteration or something).
>
> But for trivial cases, you'd at least like to know under strongly
> controlled aging and reclaim scenarios that anon/file memory is
> reclaimed in a balanced manner - just as an example.
>
> If something breaks THAT assumption, you know there's a logic issue.

Yeah and you could assert a lot of things like this, for me the real value would
be in extreme circumstances which might otherwise be hard to simulate.

But it'd be testing very specific things rather than 'how does an actual kernel
behave in this situation?'

>
> Likewise with comparisons between LRU and MGLRU.  It might be easier to
> identify the behavioral divergences that way.
>
> But i fear the whole page-table walk thing makes all of this a
> non-starter.  That's turns into stubbing out like rmap and such.

It could grow exponentially yes :) it was hard enough isolating the VMA logic...

>
> ~Gregory

Cheers, Lorenzo

