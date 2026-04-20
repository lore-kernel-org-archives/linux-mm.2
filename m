Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5373EA71A4
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 02:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2606B0359; Sun, 19 Apr 2026 22:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7733E6B035A; Sun, 19 Apr 2026 22:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661F56B035B; Sun, 19 Apr 2026 22:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 57DF26B0359
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 22:56:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 869751408A4
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 02:56:27 +0000 (UTC)
X-FDA: 84677420814.20.53C7163
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7991840006
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 02:56:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RYAJ+8tx;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776653785; a=rsa-sha256;
	cv=none;
	b=ofoauO6Xd43GDAcIBF7+aiv//xaeybY3msJqhU08ACzfWbCs4AZnVSwaXZbtRlS2Zs6aHI
	O2dS43+ipy1XlVXQewjZZjYClPS4LdAyDQhmM58GRLLk8VepMtyMg7GjG5/GOf6/cleKMK
	i9iBDUojrL7DBM+JBSuZn86FfJAfiqo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RYAJ+8tx;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776653785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tugQt2aIOJgoqj0Ob37lQ1a1TrVKhZ7jSIgjv7qjxfc=;
	b=QQjd5VF7vFFQwWI13jTUjhID0BBmTAiFZRH/9+5/PkmRfXU4z53uQ+hL+WzreYYVKTegIP
	WvhTA6DgiNdJRjoK24R4gGvyvCFd95s7Fb8kxEycwipB/KqywJ5br3qPSdXX0OvRlBYC0a
	xg352VN9+Y7l3UMhWfhW4TRm7TkD21w=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8d4f78fc9f6so287820285a.3
        for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776653784; x=1777258584; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tugQt2aIOJgoqj0Ob37lQ1a1TrVKhZ7jSIgjv7qjxfc=;
        b=RYAJ+8txRaV43fAUITmpM2dFZxyG8IUJog72rvtwracPrIjm1t3NhoHKSQ09BnEMN+
         k14txyceX04vbOuIlcDOdc5goiZmweHyYAv8aWE0xBot9y3WkdifpzuSQlS0BqplY2vL
         6pQ+rKtPr2RPM49d5zllVYh05wc4vkv4yFBwixzo7qNAFsxMlnFgDHw+Q4R0H3JrQPx7
         jK0PAnwIxoxudlJLnJI1w77SC83z/kFmZ9eyC2S4BAZVQhhC1XDV4H6cnSNH9GlrmS86
         eVi2k4a2fmrbFW7OHPUuDJGKrZvS6isiZBsI0/albYvE7mnTg2gen/5dfHzpvjG2quJX
         A6WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776653784; x=1777258584;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tugQt2aIOJgoqj0Ob37lQ1a1TrVKhZ7jSIgjv7qjxfc=;
        b=C/iEFtBrPR9K3hh7TW0Eemrk1Y0vNjrh0XFrYogKpGpFCWUkZPoMyPgyaCRQNMT//+
         vFMJJ0Pc9s72T4GAvhfKQC1HjphRatwGBGAqqaf8UuzI+nEw8/Qji6j5RE/j8TwNEPPE
         JsmaV3R0BjfVclDwIeN8+Yq2djPfOAfvq+dCzykmYyUm0v0SeLVOYySwUJZY1zxYVYxN
         pkQUdk4h17ATa2yMoJqhVSaPaMWjXnslXKdZ+55BtYiOGvqILV9ZNey7t/9p16OS+AW2
         wkWNwQ42UT2djtetFndylrMAL1aSCa9Z5l9kBeM91BWJ+A+4knSxD9IQoCNBcfQYJS+X
         gUag==
X-Forwarded-Encrypted: i=1; AFNElJ+FIrDHn0/l1GmaTv0l0uTqbQhfSCVM4sl6Xx1j/UzAbv613no/dZKpo5XIdwyUdDvS/SkF83+t8A==@kvack.org
X-Gm-Message-State: AOJu0YxhEMZNMwGGYqhDDx8yJuuqBno+j+oUECywrAVkhfGSL7e416nD
	yNYUh77lWdxsWZmKpQKWkNxHEeMeId5BeJia7tAKdAqMfMJzsbCu0t5qrJ8Bb4x8Knk=
X-Gm-Gg: AeBDiesophewfxYRtWtrNekhOcfUlhmUE0FUMMfH8+Kqa5znUtqqFj+rBxgTN4PI2X9
	U1kcwKL0RDy3Ozjp9KI2WyAxXeIwc3Dv+vuI8L42ZbSOZtYlmLoZhsgDowTGlww0UTi4W1antfO
	xiT1zy1AmVFAdqrLEDEQWlNypXcom5ZIN5cjlPm48ojWpoRPoG+vbZNv2uur/lEMEkf6t7p6nab
	Yv7iPqEHxutlGapmJsAM/nyvXUNH0ZNlvKOqf9+/B4WoOXgc0mmFmQRII6J0TEiMJBtbXWhe+CH
	uqG8qtxoRHodQwZ76yDWho6WRar6eiJ3upYPeVGou9+le2HKRw3ASM4TCR8cM6xH8XphinU5uAo
	+x3KK45SOmW6UynyRst6cRqJJPA8c8Rd7fTGe4t/tRBzE+0IaDylrFqbuYXD1D1cWv3LVPSXTip
	Sfi0RKwGN0acdzPuRmp5mcgMqoy1QleL9p2H3iaxwis1OcszAyzzQLjQYZgi3pbTYnCxx9l1NLk
	Lw6Y9WLsIuuOPAocFTOV8E=
X-Received: by 2002:a05:620a:a2c3:10b0:8e8:bedd:14b2 with SMTP id af79cd13be357-8e8bedd1701mr799144185a.43.1776653784400;
        Sun, 19 Apr 2026 19:56:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-108-28-184-223.washdc.fios.verizon.net. [108.28.184.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d5fe9638sm706089185a.1.2026.04.19.19.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 19:56:23 -0700 (PDT)
Date: Sun, 19 Apr 2026 22:56:20 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com,
	sj@kernel.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <aeWV1CvP9ImZ3eEG@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <3342acb5-8d34-4270-98a2-866b1ff80faf@kernel.org>
 <abwRu1FNqI3dVyqL@gourry-fedora-PF4VCD3F>
 <2608a03b-72bb-4033-8e6f-a439502b5573@kernel.org>
 <ad0iT4UWka3gMUpu@gourry-fedora-PF4VCD3F>
 <38cf52d1-32a8-462f-ac6a-8fad9d14c4f0@kernel.org>
 <ad-r7hwIdnvKsrh9@gourry-fedora-PF4VCD3F>
 <46837cea-5d90-49d8-be67-7306e0e89aa3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46837cea-5d90-49d8-be67-7306e0e89aa3@kernel.org>
X-Rspamd-Queue-Id: 7991840006
X-Rspamd-Server: rspam12
X-Stat-Signature: hocbkk6p8nssdqnm15donzs6e1as7uid
X-Rspam-User: 
X-HE-Tag: 1776653785-926275
X-HE-Meta: U2FsdGVkX19kHgkftSJhWE2tkrYiqBt+W1VSRMvjmJyVIWoYkApSxpbN0WUxblsrumbuhf80VcMeM0UMkcl9il/FbxMubZpiZw3BGM7J6HQa1U5Pw7kJw+Yu3zHWUiYZoqe88apUvzMo+tD1SBeEvJ1uuJ+AfVCS56kuWVwk/Q+tHofLD7ieiddS4cLcSIz+xPOjIK/jaeZC1rWUOGbHO1qOpKEXKxBXN/XiWkMcxQwALoH/SXCgojQJV8CGkEuOq6F663rsJozG5aa/mK/WjdaERFuhrgNqc7z6cnSL5GMLC4wkKFghkYg21Sqe9eT9mTdGS2gFBncw6Mn2wXTAILDSgsNNsbL3dHrTbJ+uqVzFBZVRQg8KsvKpHLwkogLIvv8qKI2WNKHSSZL/Kn21rfQ22sdLXOHrHwOLe4XdOJUEokfK1vaOqma48bDHEgEQooGx96WokXIRezFaV71wwfW1G1s0TKOhamgqgun8MsPKEWsgygWoIZd8Obcfang0O4oxycwr/QkLHcPBG41jQv6cE0Z/nhh6JNQy523MAxuFVYfMOy+G6o/AQBBkj7S05Xbc77kNmA9P3RAvHNDLfd6STa/MTF0r1INRf5m1l+BUhnO1TGYPFE7EhyFtOiG+MX615zJ21WIiPoyxjeLr6vvL6+ALQoD2+uJWBV2lGcO5001/ixDp4JgCqa+W6cP37E7XNrAwIrhnaz0y5/hI/dAni9g9Lk++PFvs2GRW/VmvGuvdTWmSxTu1DuQ1cA58i0wLbaCrvpXwGcNeagBG4e0BOAvwH1dY94YcgMW5eHijfqW369xyr2ntRUTc/EeT8C7xbASdlFygw3bgd5zSXutuGyhjeqv2P3KCcnB9knG5+6QCouYeYLn4kSjnSi5yheCadh1pah6UTexb0wnPFzVw3Fh1bIMQMLHYxuCpyZXB7laG08Xq4Pt9gw4TS0swwxHZ2l6bTOA6YyKUiVG
 Db12mEw5
 mKL5Zb1JVMMQOZdRtQQeUuYexu/spt/JaZgmD+mJyotJ8R5JHvFmZ/04VK3DyAZJtAI8XF4FWz59njxLZJKmjAZeIRJVmU4EdNPxPysxYitDIoM8iG0X3GO+bCVxsvRU06EaPJM+6jCPxz4csAXMSUdh0ncUXxhc+dzG0/jjeRCL78MihWjMVfpRtAxnYzCGYicqYMjQJd7i6JRFJ0qeUr+3WIZAcp+xJrphpsIeJEqExsMzSrSPcQCoaFkwa4Ds6IKIX3WYVSkLDcO9N6NI/YYOkQ0ntfQS866HuC65fCyUGmsEXi7yNJYgv+WakNVhzj1sYmPSn/cg2W2O2PYIrUg3LkaNAcc6aGzqcquvnS/JojoyjX9aXnXCNC1mwU3Ci3TU/Kwm8c5f8pvnWgXCCyeUArQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 11:37:36AM +0200, David Hildenbrand (Arm) wrote:
> On 4/15/26 17:17, Gregory Price wrote:
> 
> >> Needs a second thought regarding fallback logic I raised above.
> >>
> >> What I think would have to be audited is the usage of __GFP_THISNODE by
> >> kernel allocations, where we would not actually want to allocate from
> >> this private node.
> >>
> > 
> > This is fair, and I a re-visit is absolutely warranted.
> > 
> > Re-examining the quick audit from my last response suggests - I should
> > never have seen leakage in those cases, but the fallbacks are needed.
> > 
> > So yes, this all requires a second look (and a third, and a ninth).
> > 
> > I'm not married to __GFP_PRIVATE, but it has been reliable for me.
> 
> Yes, we should carefully describe which semantics we want to achieve, to
> then figure out how we could achieve them.
> 

Ah, I finally dug up my notes on this.

If we overload __GFP_THISNODE - then we have to audit all gfp_mask's
with THISNODE against the use of any of the following *forever*:

#define node_online_map         node_states[N_ONLINE]
#define node_possible_map       node_states[N_POSSIBLE]
#define for_each_node(node)        for_each_node_state(node, N_POSSIBLE)
#define for_each_online_node(node) for_each_node_state(node, N_ONLINE)

  or

cgroup.cpuset.mems_allowed / mems_effective


Anyone that attempts to do:

    for_each_online_node(node):
        buf = alloc_pages_node(node, __GFP_THISNODE, NULL)

*will* get incidental access to private node memory, and it won't be
obvious to existing tooling that this should be considered a bug.


rate of occurance in the current code:
-----------------
node_online_map       -  21 instances
node_possible_map     -  25 instances
for_each_node         -  346 instances
for_each_online_node  -  67 instances
GFP_THISNODE          -  58 instances
(notes don't have mems_allowed/mems_effective instances)


But it's not always going to be obvious - since nodemasks and gfp_masks
get passed around as variables all throughout the kernel.

I ultimately determined that auditing this in-tree is already a fools
errand - and suggesting we try to validate this never occurs for all
future code moving forward is just not realistic in any sense.

I could not come up with a way to remove private nodes from
node_online/possible_map - and private nodes must be added to
cpuset.mems_allowed to allow cpuset control (otherwise all userland
access is blanket denied).

So I moved back to __GFP_PRIVATE.

=== TL;DR:

The core premise of private nodes is isolation first.

So we want this code:

   for node in cpuset.mems_allowed / online_map
       buf = alloc_pages_node(node, __GFP_THISNODE, NULL)

To explicitly fail - so that the caller knows they can't use these
masks this way anymore (it was already potentially a bug, but could
have been masked if all online nodes had memory).

~Gregory

