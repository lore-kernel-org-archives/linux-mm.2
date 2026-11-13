Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6EAA606A33A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=WS8WcZnC
Received: by kanga.kvack.org (Postfix)
	id 901196B0612; Fri, 13 Nov 2026 03:50:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887DD6B0615; Fri, 13 Nov 2026 03:50:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779B86B0616; Fri, 13 Nov 2026 03:50:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4307C6B0612
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:50:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB8ED140108
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:50:31 +0000 (UTC)
X-FDA: 85429474662.09.65AAE1D
Received: from va-2-114.ptr.blmpb.com (va-2-114.ptr.blmpb.com [209.127.231.114])
	by imf30.hostedemail.com (Postfix) with ESMTP id 135F480004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:50:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=WS8WcZnC;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BRtBrIkCJ4EaL32K9DlOPnqwkNfnHFCSjQCoKgoeAeI=;
	b=TChyWwc1dj4ZUhNEmE3mae+GC4PPO3rZxmlT/yqlet/hw4BOK0EG/xNLmBqs1PIKvMLCP9
	sdBuJu425HS7PeQ1iJf/PiDG7hxpgRaqO4QBblNZ7OXr8BveSfJuWMTNMLbAefYCcqcNmk
	4AFUS9NI2uwxqd8EH5FdP0E1IYzUAJ8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=WS8WcZnC;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559830;
	b=mEYYmzLwK4R3JS7zNgNw6HL2MMIHMN5771aTYmFhhgh/mhX6uXmZtPR8QSpFGoWD8NMZRb
	OgaGQalKGKCk1Kghm9A4f/4SV5OpKbwBkjg2aG9ciKsvL0D/tLim54SUK8sdRb9fqbFbn2
	k9dGzEoaQWdu8W090uSMoKgFrWB2fzI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794559826; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=BRtBrIkCJ4EaL32K9DlOPnqwkNfnHFCSjQCoKgoeAeI=;
 b=WS8WcZnCPd1sylOkrsayKrwQwJmRZxPsTbwuOPsjuRzPlFzJOVVOUDtxz6fBff4j7AGe19
 W884ecRxKw5wEGYZPI2bFIexpnRXKovEkJLUcoJ5dH5vGKjTCpbteJF2mUHNjBN4WCQFAF
 2f8Fb8X65F8F+whKN9DQj1EMvMkHE6ZE89Rxx+3z7Zo+kr7mAK9TYi3T3JxBXmxTAIc+nU
 aC+WxDimYFyav2wlhObzWhkIaRT8wdv1K843OT7OJrZC/gl8lqJ1iq/Cmw86GyyNMgLyZ8
 USSbK5wT3bk1KFDk2ACA/3rlsaPY2+UwXLohW4NSbcmWmin3FVFwRPiZGaxHdA==
To: <gourry@gourry.net>
Cc: <akpm@linux-foundation.org>, <cgroups@vger.kernel.org>, 
	<david@kernel.org>, <joshua.hahnjy@gmail.com>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <ljs@kernel.org>, 
	<mhocko@suse.com>, <muchun.song@linux.dev>, <rakie.kim@sk.com>, 
	<roman.gushchin@linux.dev>, <shakeel.butt@linux.dev>, 
	<weixugc@google.com>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>
Subject: Re: [RFC v2 1/1] mm: add source selector to memory.reclaim
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Fri, 13 Nov 2026 16:49:48 +0800
Content-Transfer-Encoding: 7bit
In-Reply-To: <179455442014.482102.4069329165987986914.b4-reply@b4>
Message-Id: <20261113084948.78661-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26af6cf45+ab9184+kvack.org+lizhe.67@bytedance.com>
References: <179455442014.482102.4069329165987986914.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: m1grhofpxp97e6dfn15erk9cgq9mxz6k
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 135F480004
X-HE-Tag: 1794559828-351311
X-HE-Meta: U2FsdGVkX18BaB6XnXMpTvul0Ebgvzww5Igp37lqVTf68XBxE7EgjM2Lf6N7ZypmBJ0TbuQqNSJUzC4b3HX8ysPJEP6H/+2VeYTw26J9TisJnd090Kw3EvJTTtT0x+L3vKiBkHA466Afv6i12XzyjlwEljh+KrqAOMWDPFlPF2eh0CQ0CgyZuUpgPazL5yTF51e6wV1a1WKdb2wYKFV3cVuaRuUR5TNVj9/FiiZ8obnWgMGjZSXvSuPltFzTxcmRjfZ/WbBR3qoPwGicS7gksyirEyHlZcSTwdARp3gLVV4UYtoT3gDBjKWwXbx8UoSHiC/RKudZRmHA/rWAwM4/Blkk+01Soluwbek8qwXt0uLXXL9v3GJGRL+/JR0uyhnMk21VYqDlBOr0YBP8JsLi1dI77YM5WlluBViwr4Sa1fdJrTsrIwU2cY5QEy0d87Na6eTRy/U1dBkJJn4K9g8QzYq2kH1Njq0E+P4ofi5q6EmrkbA200zcxxpkzB+y2zQ/SoihOM00h7xW0xZgyMwpr2MDpFneFQ+OHYvKTCw4ArnEFZd7SxwuFUfxlr105flspOgvwbcRhsKQ9P+2Iocy7s+5fdwsDLvPAms64g3LhSu5sH90haLwQx2lRzQNgq5zc0zZQBHOpR3OnrPBejtEwpIKi4AMzfIGbsc6/a0v9KIGojvCsD+vYjQJFlHHw6Sb3VHs4M8VAOTGM/wtK8PCcvImAPEg4chmjASK/9g/+hw81lsQyz1z2a9N2g5pIByaRDH9D5ShOovRrQ4UTG/EPNo8yWcXt9qOquROLul7JLY8cYSey+Rco443fex1h2wC797YmNFUUo/R30fO1ATlMevcLJo0hsRC1dj+TUJTxfJBU5FI4CMnLJjV1kskik7cTxjSZwjUNhGUu0DRit0Xv+m6kL/bAXmUagc/U5mdOEoneY+pdMVMKru2rGWdwdt6a/btYwnhDyNMiO5HKwA
 /XQFiO2q
 BJOA/XERmdpKQ18oOwjRd47E9z32g1xSQ0OwZ+naLXvwvawWxDv3DpscXoWbkzEJzQWuogouYPr2Y5GedmgSwbmDLx6jeNm20Btp9THIefXkiOVzYGEoBEkVeg5BkRQyPnfTjCA92jB0XWSvcQYm2U3e09VaQ5ObgyeNHnqXfv1V1oHmVB9b9gMERd7MahC7BhEbDKTQPyVc56lXVe8oYCzrKtN32e65Ced+ubfUie8k4E2SjDREYY4V8PLOQPr2prWpHL4FqnCP/CZ0CPmU5u33LmfvGWJroNnVcq+Es8+fnbLF8oRMhOMHmy6ktw//YCa+JUupeiuRlcgJmYLyZADb5a2thhWGW/ftFLLF/dWtWw7+FIV9S7DkMVdSJOjabHsmlX2vUtKZyCVGEABP6MufGaA4wPUkOPVER
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 02:20:20 -0500, gourry@gourry.net wrote:

> > On 2026-11-02 15:04 +0800, Li Zhe wrote:
> > +	Specifying a source value constrains where proactive reclaim applies
> > +	pressure. Currently only source=nodes:<nodelist> is supported. For
> > +	example::
> > +
> > +	  echo "1G source=nodes:0-1" > memory.reclaim
> > +
> > +	This reclaims memory of the target cgroup resident on nodes 0-1.
> 
> you buried the fact that you want to allow source=zswap in your cover
> letter. I was confused by nodes: was needed here until i re-read.
> 
> As Joshua mentioned, i don't think you need the separate cover letter,
> and I agree this is far too long for the proposed change.

Agreed. The nodes: prefix was meant to keep source= a typed selector,
but I made the motivation and possible future extensions too long and
distracting. I will make v3 much clearer and shorter, and keep the focus
on source=nodes.

> ---
> 
> When I asked for testing, I wasn't concerned with the functionality,
> I was asking what problem this actually solves. performance? fairness?
> 
> Shaping the distribution of memory is neat and clearly works, but why
> does userspace want this?
> 
> The interface "lacking flexibility" is not a problem in and of itself.

Thanks, this is a fair point. Sorry, I also made that earlier
explanation too long, so let me summarize the intended use cases here:

https://lore.kernel.org/all/67fcd8db-269d-43f1-aea2-8c41165747d0@bytedance.com/

In short, performance, fairness and cost are all part of the goal. One
target is mixed DRAM/CXL systems where user space keeps each memcg near
its own DRAM/CXL resident ratio target, based on the workload's
latency/throughput and cost requirements. Another target is the case you
described below, where user space wants memcg-scoped reclaim to apply
pressure to the desired tier first, rather than reclaiming from warmer
memory on the top tier. This is especially useful when a memcg is close
to its memory limit and user space wants charge-reducing reclaim to
start from colder/lower-tier memory first.

> I CAN see why you might want to proactively shape what data is swapped.
> Let me give you an example:
> 
> ---
> The global node reclaim interfaces allow us to put pressure on distinct
> nodes - which lets us shape which node is swapped from first.
> 
> Example: node0-1=DRAM, node2-3:CXL
> 
>   echo 1G > node2/reclaim   # swap from CXL
>   echo 1G > node3/reclaim   # swap from CXL
>   echo 1G > node0/reclaim   # demote to CXL
>   echo 1G > node1/reclaim   # demote to CXL
> 
> But the memcg.reclaim interface only allows us to pressure the complete
> set of cpuset.mems nodes for that memcg
> 
>   cat cpuset.mems           # 0-3
>   echo 1G > memory.reclaim  # makes progress from any of 0-3
> 
> Presently, proactive reclaim iterates nodes in node or fallback order,
> meaning it attempts to make progress from the fastest node possible
> first - which attempts to demote by default.  If the lower nodes are
> full, this demotion will fail and we'll swap directly from the top tier,
> which is (presumably) warmer than the bottom tiers.
> 
> Enable source-bound reclaim in the memory.reclaim interface so that user
> space can have the same control over memcg memory tiers that global
> proactive reclaim has.
> 
>   echo 2G source=nodes:2-3 > memory.reclaim  # [z]swap from CXL
>   echo 2G source=nodes:0-1 > memory.reclaim  # demote to CXL
> 
> This lets user proactive reclaim to target the coldest memory first
> rather than preferring to reclaim from node0 first and potentially
> swap out memory warmer than what is present on a CXL tier.
> ---
> 
> With this, you might be able to demonstrate fewer refaults and less
> DRAM (node0) memory consumed by zswap. These are clear benefits.

Thanks for the example. It makes the problem much easier to discuss. I
will refer to it when reworking the v3 motivation, and will avoid
framing the issue as a generic flexibility problem.

> I would argue that memory.reclaim should operate this way anyway,
> and that would could make proactive reclaim do this by default, but
> I could see the policy bits in userland being useful as well
> 
> Performance may not be the only reason you want this, but you need to
> help me understand what you're trying to accomplish.

Thanks again for the review and suggestions.

Thanks,
Zhe

