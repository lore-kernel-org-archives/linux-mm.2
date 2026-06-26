Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77A33C43327
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 17:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22D16B010B; Fri, 26 Jun 2026 13:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA636B010C; Fri, 26 Jun 2026 13:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C38726B010D; Fri, 26 Jun 2026 13:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 840926B010B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:08:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED55AA052F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:08:40 +0000 (UTC)
X-FDA: 84922698000.11.8CAEC7E
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1B42140006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:08:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HYljj6Ox;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782493719;
	b=F68hIZKueFdubsRSy9s+XHik4+MPBurqY9yrM72ddbGeETsSWRGaBcHkx00kbapJytsfnb
	sW1OdGNd6+Ou5BXwk/JxCfRG6rJO4MdHf16ubf0dgH65Ux+fk/Y1kXiMnii3qStD5cnpSH
	H9LVA7DYqj3LnTAHwxq6BLLhR3Wu7f0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782493719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tLPhQOvYbJ9MvCaXmifdh1jUBsM27DjBWEoAqn3LyyM=;
	b=4iToesutv0XRJDPkzzm+1LrbbHL2v2woDlcqc2WcdfbwLHz5PaAUBEUEQF2wX0+EEKjLkC
	E8NTMj1fVu8hjzCyIfyvbwCZDA3QRSoqywV+7sqQIJ9APpTCWTWn8E9xqRquZCbKWzDsLd
	dZFiFOhSY3Hz5+3C/M6TFE4e8zrbARg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HYljj6Ox;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 26 Jun 2026 10:08:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782493716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tLPhQOvYbJ9MvCaXmifdh1jUBsM27DjBWEoAqn3LyyM=;
	b=HYljj6Oxv5JQqBwnaQNq8arYkl4AVGChM7A/N+JwsXNKPFlqfwPfDmcembYDjq+qFPbBaW
	WYIjUXv88Ktn302oXsGMU6PTCtdkLbBVI+qbEeazTj23fzTPOhPIGpqtsfF24Y3aRckwAw
	BW4tjB68OxrX9c5nu8VHDntI287ZpHw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Harry Yoo <harry@kernel.org>, 
	akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, muchun.song@linux.dev, 
	peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev, ljs@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: mglru: fix stale batch updates after memcg
 reparenting
Message-ID: <aj6xzyqtwd4it0kZ@linux.dev>
References: <aj12aVq3he6q7b2C@cmpxchg.org>
 <4c7b0c46-14f0-4a62-893e-e50714e09b74@linux.dev>
 <46ac28bf-5be1-4600-b522-0a1aa76c28e6@kernel.org>
 <08cf8972-6cfc-4452-9a3c-88e0368dbbf9@linux.dev>
 <afdaff7c-fe6b-40da-8f54-aeeab8fe8867@kernel.org>
 <90fd5300-1016-42e7-abad-08ad85fb62b4@linux.dev>
 <5a0c6597-6b96-4781-a71b-fd1298b2b7bb@kernel.org>
 <c0e366ec-ee5d-42d9-ba33-7c630660e8af@linux.dev>
 <aj5I7JAXWlTHRyEW@cmpxchg.org>
 <57c18afd-e2a3-4b37-90b6-f2a4c758e8aa@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57c18afd-e2a3-4b37-90b6-f2a4c758e8aa@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1B42140006
X-Rspam-User: 
X-Stat-Signature: tcas1yiu15ujwx8ka587tbjjdm35ighu
X-HE-Tag: 1782493718-70874
X-HE-Meta: U2FsdGVkX1/ce3ayQWrbEQaDaEnm8gfsOXJ3qHwAZT8PbL4riz0NwR+biphuDvrRf7vqajrTGOdWPZzx2L6gXewEO4l6QcRZe9kPRp/oDFQf45KyYNOFApI1uks5nlw0UYlAmGuAd/qDiSpEPmxtLkdXcWMbVt2VUQIRfNTVxtC3Yvuxli56nyJBAtr0Jo3u0hSCTbfFYOPK1sKGp0o846kfTNBR00PhLVHtRBhatqTiJc7i8DY4j1iDs6iprxtHY3fM/0XZ3HdDqttuIccTtmk7k5Ga+He0OsQufxQQk/QL0eGhXBzc9Sn9FqqYiOsSH/QkfdCVw4kogUuJZrbr7Rg5PahTVq/gKaiSn8zTrUOsqyuTad+57Z7oLPE6XO1RtOmYvRyjVd/M232NHRRRRJNoepTGe6vyaEEevwAdH+knaAXVhjy1NMWG2gj9EvQmpjoEMJvfNf7NUPGXWn0XxK+sFl/NN4wXCpjV55bR6gmcQXaNkZdjv9KK5WKxIOZOOkqku4F542sdBw3BDmQudsntMRCFIqi/Tb0Ayz09oOE2+WHWmuwQLHyh7wrjJDB6ggBWYe/c0oGqz/uzEgWhmrx2Uxqk37WzW5bq0z/8KNb/nrRAscPmpmcITV1ua/FLek+yTuZ42L1Tttc7gpzXDybAWAsLakNqzCQuUvkmWxHSaxp3Hv3l1MxzE0Y50NphhQu4CuKF16jTTf3JJeXUQqH5mg6q+YiqmBZ5sdZIYPhorkl4R2qYCrThtJ9vvSQBT81WFyAEGhyXFq5JVd42rltygjZklpMqZ4Z1ZaDvrQg7HaktrvdrwA58v+t9e1jGrCBvwNM1K9e6Gn/7liMoJJNLMLkHBnRJdd2/3T+uoIB6M3q147tK17qhAV0hNk9V6+jpB5iBjVhf7i0PZ9h29JDLwjAAWGKEVIYDas1rzV37eWEXzhsLhQroMmvc7wtBv0TLAkeu46iaG/vQcxy
 DNPz7zbV
 vh/u8ZRmvp4YJ1ADyD6V5DMlmfhvDuZTMHKzeFJYLXbkqvPDWHs0ClaDbLDJOhj/CkVRAxLF0qpliKfeBJ1DGFCxNSawUKPtFcRTMkRlXTA9jBc4o6RnwSCtd+kOIWoUWRvivEvASd9txIBo1S6kg3sxbFIZdLOStEsMeTbLKsZeKy58wPy0BSvUqoNX7p+1FSuqRgW7E4lgRsTJFwApHcT6yfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 07:21:28PM +0800, Qi Zheng wrote:
> 
> 
> On 6/26/26 5:39 PM, Johannes Weiner wrote:
> > On Fri, Jun 26, 2026 at 03:04:17PM +0800, Qi Zheng wrote:
> > > On 6/26/26 2:48 PM, Harry Yoo wrote:
> > > > On 6/26/26 3:24 PM, Qi Zheng wrote:
> > > > > On 6/26/26 12:59 PM, Harry Yoo wrote:
> > > > > > Observing a dying cgroup should be rare anyway, it's worth focusing
> > > > > > more on readability?
> > > > > 
> > > > > While it's rare to encounter consecutive dying memcgs, it can still
> > > > > happen, right?
> > > > 
> > > > But is worth saving a few instruction in a basic block that is
> > > > unlikely() to be executed?
> > > 
> > > I don't have a strong opinion here. Hi Johannes, I'll leave the decision
> > > up to you. If necessary, I can send out the v4.
> > 
> > Yes, I was thinking what Harry actually bothered to spell out ;)
> > 
> > The race is rare, multiple levels even rarer, and even *then*
> > mem_cgroup_lruvec() is a quick inline.
> > 
> > This way you have one block to handle that one rare race
> > condition. One place to put the comment. No labels, no goto.
> > 
> > Simplicity wins :)
> 
> Okay, I will update it as you suggested and send out the v4.
> 
> Hi Shakeel, do we really need to move lock_batch_lruvec() to
> memcontrol.h? It's currently only used by reset_batch_size().

This function is very specific to memcg therefore I asked it move to
memcontrol.h and not to keep in vmscan.c but we can always do the cleanup later,
so proceed however you want.


