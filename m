Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03F39E9A778
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67EC06B0088; Tue, 24 Mar 2026 07:57:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655E16B0098; Tue, 24 Mar 2026 07:57:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592E66B009B; Tue, 24 Mar 2026 07:57:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 486836B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:57:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C00F6E0F44
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:57:38 +0000 (UTC)
X-FDA: 84580806996.15.C093629
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3A7FCA0006
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:57:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mSipaLGO;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mSipaLGO;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774353457; a=rsa-sha256;
	cv=none;
	b=G89vO2FzWp3eYQRRe6xNJl+0z5NPfAaDaFBI80AFwLfKO0Yd9H4gBykG9u97qMhuhQsNVs
	CbhTlcTgsDWZb7Vpa9YvcjL/mGH5rD4n30qLhykPABu+nqRAPntdptyC4ccmxqMN/1tN9A
	NX+//G02eE4VW0PltEZFbfiVzKwSmqk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774353457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SQ1UTZgmk3FuP20xcmvS43aaJ5O7ne9rvHK9Q4vgVMY=;
	b=5YCuSYxy8rbh/lLPzr8hxgwoANY0mZmNPFrhoaqRaDeJBoSNeABWe3kEJpkbljlI5+jT84
	rlv2S4d1sLIL/gzX2KPaABpUhiPq2855xWr4y/UNEho4IU9yFNqW//qs1v5Slm+fDp2rbq
	kMrS7awS6HU0WAm32AQvGlWG+KHyKlA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D0C36013E;
	Tue, 24 Mar 2026 11:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6C2C19424;
	Tue, 24 Mar 2026 11:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774353456;
	bh=Yy6gXmBkDIayNYElsmxqEPYfSjNDuBzm4LVjiMDEWXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mSipaLGOC8QG08/lBl1D7TYVOsjAMRyeheY/JeHpMP2a0vuoc+frReTirRTH5CJHk
	 KhVOa7i1SLeSnyNhmFQqDJqBzJyvIwnAGkSLjtpfeE7PFBlgaxK4gxh+DDariYAcB7
	 rxXRfW8AAxcQ25IrvXoAicSqWr/1K6YG/26UAHIdRObpwZHmPJ/mGChF0oeBCgL2yH
	 VJbIaZp5J2L4cq4ISQwit6ioB43paKD/xnTAgH2/gTm45JBZZqyWcTQPTp+cJFRzRp
	 6u4XoFpfGDs7yFm0fIwB+T9ITMxItBULGRYmq7hpXHhfd83KusuBrm72RIo23e4Y9S
	 TITv9mIuse3gw==
Date: Tue, 24 Mar 2026 11:57:33 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 0/3] correct the parameter type of some mm functions
Message-ID: <d17ed660-3180-450c-9d2d-25d96bb3549a@lucifer.local>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1774342371.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3A7FCA0006
X-Stat-Signature: x1argmqfr99chmcjp1yxq8n317qucrkj
X-Rspam-User: 
X-HE-Tag: 1774353457-572970
X-HE-Meta: U2FsdGVkX1+Ag6C6MovGioPcdColPmJNIHPncl4oufh4ORGDBb36sGwe4RXYlLMEs4BgxfSTnhYSU4TAE0ZSgGKs+4Rn7ZLh3NJlnDAkEcRhcK+MrbcNSTpApElH27LvGBzAAvw03/eLtqdPO9/wM8nMHAT3og4BNoZ+K+kCEhm4JrO+wjVz+aYX8i8SctzVFEpM60ZVTWqXY6wUJuUOOEyOV3u4jxnFlqStA45A0nI1eUmxKK5/a1ClnGd3gbeefI+/7KizAmNrrQKHGr13gQ3JaQJSlH8obQ0ZsANTp9oocddajJpoaoRF5ROtCby7W8q1GKvdeDzcG57OMA611/4FfIjlbjMrTa/vARg0TzEpmCZjAo354zgIGEMAJpv6OlB3m3c8rmZijpNtJagW5oyNB1Y3TIZ9Daj9tD3rzwRk71Kc2r+yuq66zTCse6DJ78mCqvUumUq6ECVPI5pfHHn0xoTd1LMyPrbuI7Nni7gzFgpI95TTMPruYBqm2E6q0cXugzWS5axIwZHq8MdiImTK/KCOFuSG2ysjeOYvbkhJVwP1yDT632Pmk+e3gSsnKLUeCaDWgv9pkZFaK/cYBoc2A8Siio9C3r457MJLonDsTQ3Z/17X9CeIkgARVZKV8o1xJFTEU/SAVDERwTibtaJtbaQ5C9/HE9zo19ahmfs2DGVIwCNOppiy/w2uFH8dd7OuIMbaedRPMsIh6CT8UN8wQXWaTEsCt1M5RsDyyOL//nfbTqPKzuyxeIGqk143Por2khGeKDshwGgb7LfPnfe62Nhtv2YbLUDuf4ST4MIPEzc1dMPpi7RbewSI/TwF93dB3Tao4rnrWQd5Qug3oNBUs/rX1PX3nTnnOwIL5AO3rnKY+JAR6ykAJ28ZS8Tk9pjwVz+cfWPEoZ2KzLFj0AwF1M6ijgX4wGi4poJ4rAHZWuInyjoHiQZv7EucYyzTr9jppRpCJVcQ3uyt44K
 iUT9qVZ0
 z7o7Kf9rD5brUETkyDeD0iL5PI44FTiNPzJhUPftz5DeQFttdjp6gxfJEcqTpqJyfnepXEB7fXOCRSeyxBk/0cs1XXVvPOHj2B/2LClpvsQh/uZH3eeVmCIEgq9iZwY5a/xwD2cPDQQP4YbGyGVUFDPk9f/fvYaOLmAm0Ejlge0kka7rtTgkPYicG64Mm5QSE48X5UdR88qUZPUWCVcvpSK6XjvNigpHdBye8quWoCnf1Zxr3ch5axqXgHW+bsrdntmTu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc old mail

(just a gentle nudge to send stuff to ljs@kernel.org instead thanks :)

On Tue, Mar 24, 2026 at 07:31:25PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> Hi all,
>
> As Harry Yoo pointed out [1], in the case of reparenting LRU folios, the value
> passed to functions such as __mod_memcg{_lruvec}_state() may exceed the upper
> limit of int, so this series aims to correct the parameter type of these
> functions.
>
> This series is based on the next-20260323.
>
> Comments and suggestions are welcome!
>
> Thanks,
> Qi
>
> [1]. https://lore.kernel.org/all/acDxaEgnqPI-Z4be@hyeyoo/
>
> Qi Zheng (3):
>   mm: memcontrol: correct the type of stats_updates to unsigned long
>   mm: memcontrol: correct the parameter type of
>     __mod_memcg{_lruvec}_state()
>   mm: memcontrol: correct the nr_pages parameter type of
>     mem_cgroup_update_lru_size()
>
>  include/linux/memcontrol.h   |  2 +-
>  include/trace/events/memcg.h | 10 +++++-----
>  mm/memcontrol.c              | 28 ++++++++++++++--------------
>  3 files changed, 20 insertions(+), 20 deletions(-)
>
> --
> 2.20.1
>

