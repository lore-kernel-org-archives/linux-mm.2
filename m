Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C6E2CA5FD9
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 08:16:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E3E86B0093; Fri,  2 Oct 2026 04:16:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BBA86B0095; Fri,  2 Oct 2026 04:16:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0D26B0096; Fri,  2 Oct 2026 04:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E01256B0093
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 04:16:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 742F5A0675
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:16:20 +0000 (UTC)
X-FDA: 85276978920.30.8B06AEE
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf15.hostedemail.com (Postfix) with ESMTP id E2D67A000A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:16:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Gnkv5q6o;
	spf=pass (imf15.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790928978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=erijjSKK0F16UjGTpa1TwWvZ6Kt00yN1jhH4DWA5qn8=;
	b=opacOYOrdbUEMTsua5DD6VgegsyEHzFKnpSyJUw9XZS7AwW5K+2eBEhi1q/mQ3B0JoQ/M3
	u7HMQUNf4VP7MIX0mmSTSttl1Z9KFgIC6YgNAcfb6BAdZ/hGwGXUvvEeGA0HWXBPo9Mgs9
	ZD0A6XLNqKnLT7VvZZtmD/O93qg7T/Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Gnkv5q6o;
	spf=pass (imf15.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790928978;
	b=8JXO0ecITEonSa2eKN1CaTlsgIeuOMHt2YXDEtcEbPGjJzj25toaYDc9OY5f6IxAPOyJkX
	RuJyLnzLRpPFdAKfqQUyl8/SCemTmGDHoGm6JCvDH5FzdGH9jjW8w3XjAEPmJ+TH7q88ll
	3o3/ryR+kJFvpa2Fs79WgOMqYwRZg/M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1790928972; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=erijjSKK0F16UjGTpa1TwWvZ6Kt00yN1jhH4DWA5qn8=;
 b=Gnkv5q6oaIA7vzSUYJ/bCO3LDfFmUZrZ5DI3Yg+LJSThnLIP2A69xJkstQfmc5ucpmuFac
 S5CSD+6enTLkEyPtyWswxmklEeEvLYIT2Vw537SYcCKZursDeBVqsaas9ZavFCao7x/XsB
 DB6dj6u+8gOferZJ2HvTGgMgLRQ6FkJ+dFFLjY7k1qGxsEFw3zSc4KS3ilIRqYyXZ0CAvc
 lgJm/7nyKuVHshm/L/oUaqxo+J0ttmVGp/CrJzR7hQEUqVTtqetVCniSH1IbB0MWKbMykQ
 FkYuXpEhCXl2VHrfImAGr/zOa+9oXQMMzHaj4zUaGGk5fo2qwqcia0ZyvuwgFQ==
Cc: "Zi Yan" <ziy@nvidia.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, 
	<akpm@linux-foundation.org>, <ljs@kernel.org>, <liam@infradead.org>, 
	<rppt@kernel.org>, <mhocko@suse.com>, <corbet@lwn.net>, 
	<skhan@linuxfoundation.org>, <ying.huang@linux.alibaba.com>, 
	<apopple@nvidia.com>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference with MPOL_WEIGHTED_INTERLEAVE policy
Message-Id: <cac17315-7157-4f97-8ad4-98ef268f1b8a@bytedance.com>
In-Reply-To: <44d15437-6aae-4d7c-bfd4-296276583826@kernel.org>
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Fri, 2 Oct 2026 16:15:45 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
References: <20260930121154.687586-1-joshua.hahnjy@gmail.com> <2e3f12b7-0dac-428c-b70b-07e1f63de028@bytedance.com> <ar0fURbLDPrphYMY@gourry-fedora-PF4VCD3F> <A005B05D-A85C-4153-A65D-0BDF9D8500DF@nvidia.com> <280965b2-c6eb-4f01-a0ac-c4fb7e518f97@kernel.org> <ar5eC22VfSFlMw3W@gourry-fedora-PF4VCD3F> <44d15437-6aae-4d7c-bfd4-296276583826@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Gregory Price" <gourry@gourry.net>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26abf684a+3af7bc+kvack.org+lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E2D67A000A
X-Stat-Signature: u9h33opg6m1bz3wo4fcrhyoscfqfy7x3
X-Rspam-User: 
X-HE-Tag: 1790928976-205116
X-HE-Meta: U2FsdGVkX1/XK7P+Oja0ooTN/u+9OVPnRul9y5B1EnLTqhixVtGab9XvPLNw2M/1Wmu2njzuwouFOq6gFNKVPiMdhpnImJNL60cj9IfspXX2V028DdlHGeA9KwUretl/5ldU24Af5XFUzV78HPmpOJOLlFvC4LnHBw4dGj8n9p4g9UgdWKZAnlOSLmBhNQKNlH6e1KAwPhXomlbsmlWHOp+sCBy5VGSILSJRolJVpmajfDC/AXcsSkF4yyqoOgkCCxyRg9iTlZa7nLG+OFuYzAzDA0PbSkfOm8epI/p4LFm1jstVeCHNLQz1B1SJ864sBIvUV6Ll6DBMz5NBRw95N3dbCGJ74HohHUuEqbEtyWEp3C5KKW8659ASoMRP2cNhWePxrBr7jGABQlRUp5FOs0Ap9cOmPZNqpWWCRsunQZa6lUs9GKi794mblNrOuyLISNagJyileIVoeERoSnFriy6TWUXtZHD/I6p0bx3eRy9c0NlhnhL8KYl8oqRkxtLGLVIAVIYrdMfay6Z9uVB+klIHMCpwIBSTrY7pRl4nQN/BrhcaM8jvpSM7RiGZxEjQesFaAy6ZUi+XOMMEzQktPZTsK4ar7Bsw8e2ZLwG60dgp1fV6rIY4LB+hvXEVe9gAXQCSqntbu1l+DHMs5e43H/91y6zmlV2890PEkCTPsZDNEA2HhwOIXQFcjeTEu0lAmSOJZxuxxTXZtxlVec0HJc5RUiGNQbvnXxmdU5sQwiaM82EEVOatNVVFKUNaOapvbor3QdkJ18C1FX3d4bo+1T1g33Bzyyh3zEAWOJnmpGkNp78wot0hV49t3TkPnz6VFhLw5IBk+tS49F5Ha70AC559dAMlJcvbvf/bTZFQGyVxILlBgVQP1UKdqXJxDzbVzWRjHL30zO+OKNSLP9APOWMjgZwEC2LDYJe9XJZdcx//AGaBxKDmXFbuWgm8XjkOgpOLBWv38EaytYeEZfE
 V1LfNvWH
 HtCCPWtpvEcbUmpwrhYjupOM9GUnyfSwTDj1reBo7JzV0CIXbQFFGRrTpL9uumc6TRhIUmDIkWgWeP2/FESOFeBO83WpRODKdRzI20VF4ooZh1Z4lw/oJEJJ5azDOWABnXViP14+F3StnsxdJoGUv+7Y4sgwqIRPhbKSBGeLnnJh5/I7bj4+ODnDf2m11wAcnCiPj7XheWISmbGcm7Qp41VT9bErAEldWR3hn/B8sf3LRfhZqkmWq9eM54cM+/4zB/iiMBwiu2Cfd6u4bZLim8r7DJV4oCEfCuvbz4ErDU5cqz9xdESoA3C4iVpU8DIlTrMw8Qe0qkOeNvkaah2voCTYTlnjZST18zZjuRf6n3vNIy7tYyYs17fOplV6R0UfjkhUD2EVfwTVB/Sg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 3:56 PM, David Hildenbrand (Arm) wrote:
> On 10/1/26 15:26, Gregory Price wrote:
>> On Thu, Oct 01, 2026 at 12:54:22PM +0200, David Hildenbrand (Arm) wrote:
>>>> If this is a initial-fill problem, can userspace set weighted interleave
>>>> initially? The program or harness can observe memory usage of the program
>>>> or related NUMA nodes and switch the policy to numa balancing via
>>>> set_mempolicy() or mbind() without MPOL_MF_MOVE after certain threshold
>>>> is met?
>>> You mean: use the weighted policy initially and then switch to a NUMA-balancing
>>> one which doesn't involve the weights anymore?
>>>
>>> That makes more sense to me. Although I struggle to see why an effectively
>>> "let's put random memory on slow and others at hot" is a good starting point to
>>> later let if be fixed up by actual balancing/tiering.
>>>
>>> It all sounds a bit hackish. :)
>>>
>> It is a bit of a non-combo (Nonbo).  You're using weighted interleave
>> with the intent of spreading out the bandwidth utilization (and maybe to
>> offset some reclaim behavior? *shrug*) but then undo all the placement
>> with tiering.
> I can understand the "random initial placement will help if you cross your
> fingers" argument from Zi.
>
> But then the question really is whether the app should then change the policy
> after the initial placement was done and the weighted stuff no longer makes a
> lot of sense.
Yes, that model makes sense if the application or runtime can
cooperate with the policy switch.

One limitation is that this is not fully transparent for existing
workloads. set_mempolicy() updates the calling task's policy, and
mbind() updates VMAs in the calling mm. move_pages() and
migrate_pages() can move pages of another process, but they do not
change that process's future allocation policy.

So I agree this staged approach is worth considering, but it also has
some deployment cost for workloads that cannot participate in the
policy switch.

Thanks,
Zhe

>
>> But, in defense of the hackery - I have seen strategies like this work
>> to optimize startup times and then let tiering optimize runtime.  Phased
>> execution gets funky like that.
> No doubt about that.

