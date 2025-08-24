Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BB25CA0EFC
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 14:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402638E000C; Sun, 24 Aug 2025 10:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D97B8E0001; Sun, 24 Aug 2025 10:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316A68E000C; Sun, 24 Aug 2025 10:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20E048E0001
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 10:19:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B3C91361F4
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 14:19:34 +0000 (UTC)
X-FDA: 83811859068.29.8126C94
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf19.hostedemail.com (Postfix) with ESMTP id CE9A61A0004
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 14:19:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756045173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NZCFKc+zTazW5wo9wfnWTlxECViXTyx1c4oYQTdi+RA=;
	b=eeZxEkpd+0r2n5Jja1eoGtjY382YUe+B4LlpMPtDO1zHGzK/cb7e4K6euOqNxzu3eUvpZ/
	meXhYd/LQRp21nQlvR2O3hbWFpC+cSYoRtNnUV54uFWcvKC2YalXvarjjs3eInprW304qd
	1LKm4zOA82qRpK8PA/em7IGPdaKOoZ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756045173; a=rsa-sha256;
	cv=none;
	b=xAZ2gDT/9wTdAt23tDtj7OtlFCB6b+rGB/50dI+VQSgWmrH5XzA9AUoNI15slTAAVJv6PG
	zbNZcAe6q98A6sbGCa64+fco+SGC/i+kthdjOVJg97HP3qXsiAZOuEI/Ln6HOvkGiIhQz4
	xsGh3moMcGHBJAebMelghi5CYq7z614=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 24 Aug 2025 23:19:28 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 24 Aug 2025 23:19:28 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <aKsfcGI+aK2eYISA@yjaykim-PowerEdge-T330>
References: <uyxkdmnmvjipxuf7gagu2okw7afvzlclomfmc6wb6tygc3mhv6@736m7xs6gn5q>
 <CAF8kJuMo3yNKOZL9n5UkHx_O5cTZts287HOnQOu=KqQcnbrMdg@mail.gmail.com>
 <aKC+EU3I/qm6TcjG@yjaykim-PowerEdge-T330>
 <CAF8kJuNuNuxxTbtkCb3Opsjfy-or7E+0AwPDi7L-EgqoraQ3Qg@mail.gmail.com>
 <aKROKZ9+z2oGUJ7K@yjaykim-PowerEdge-T330>
 <CAF8kJuPUouN4c6V-CaG7_WQUAvRxBg02WRxsMtL56_YTdTh1Jg@mail.gmail.com>
 <aKXeLCr9DgQ2YfCq@yjaykim-PowerEdge-T330>
 <CAF8kJuM4f2W6w29VcHY5mgXVMYmTF4yORKaFky6bCjS1xRek9Q@mail.gmail.com>
 <aKgD7nZy7U+rHt9X@yjaykim-PowerEdge-T330>
 <CAF8kJuMb5i6GuD_-XWtHPYnu-8dQ0W51_KqUk60DccqbKjNq6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF8kJuMb5i6GuD_-XWtHPYnu-8dQ0W51_KqUk60DccqbKjNq6w@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CE9A61A0004
X-Stat-Signature: 3ynnrw5y5brc7866fexeqa58e1hzhbw3
X-HE-Tag: 1756045171-43210
X-HE-Meta: U2FsdGVkX1+thKqkNzVSlH85CAj/wDtXA4qMe5C1PhBg0weke0nh6Ju1gFL9gUHzEJi/hN7y5Lczuayfwb4Z1bXZYy43OLobJHbsg8oQWzs8f5IAGcwIaqwlw3QigD6PY601KSCc6j9wu3+YhJU4XFn6Zes4nt2rl7BHoFLAIxYfAkP3bere0zHQDm0ns3VTh1bP7IPOYWHvslwgRHh44S8vmeRtF2aIAtedm4vPR3ybuGxQkekPW6uql1H871z7m5yVUmsGJcUA0UG7vpD+Z9eBayQjSqF6lik9M0R5hjzQ/A3JeGZ+NXR8eKq000+X93jA4oA5HLVhLcQxwzIjyUdctexqk6Jm0IDqQCeOsSt7dfCtTD5XGB6rKb+hE5CS9YYTTyGGb1dZXwZXS3KtEF0Fa/6p/vaCZbxc+jt9ibpzWDOVhkEve37RlG/YOLvj4pZ2v/K9NhxCovJ5IGQNjRpbctntdsTJgFdzvn4gdA34ZJ2WzBzzVPojiLKPt2ZdqK11J8usPJBx8IN+DCnsj+UkbVJAu8jo/zipp2vqEy7F+mSsWe1AXn5sZUtvO+nfi/G6kLxS4Cd0a1kF4QHDs+7q++SfiU1BHSuXENdg6lSy828SyTcebokqLUBubA32q1FCF+gSP7KYDZOd0mdb5wS4GvvmjM1eOFZNgsw8HcIW1jfLzE9gxsw7SsuTHg98ea2BVO0eBEd4gjS3SIDFL2Ypddt7p2k3lqAjtRYUIEs6PJ+Xn7LL9Aa/tHynBFhBgWpdzRLUEAJWKx8UJB10D9HUVIGP240wAD4FD9SwEvujHE7/PXjWmKA0yGebfS8aq8Ke6+CZg5IdymXk7YgPGXtmgKKwEyU+nW8y5sasWVP3AroxjO/JBHM4TnNrNKf5JyZgewBRVsPUAsexqd0Chgr+NF5g832tBgCmg3KMPAwpiIh5N47gbsELk1+7yA6UqmsqIwj2BAFrbWMNW6q
 81czyN5b
 FJRbi5qm77zq66msSmXFlUrL1TouvObmhsDzw8rH3nC7NGjDo0TCFAdpqXP2T8XbStg5aBtEtHxxLYXOIBR3cVfUWC6FcAc1zh0tlsKFPmwB6u2s5cd4H3Sj6v3B83zBm7Rl5d1nqvytS6Mxmv2vDuVLmZ6QO7feAxM27DNq4tHXlvk9hJGxVcf3tJ/uKV+v/jEToZsZWcRRr2thUZz6VoMwhBr0RwD9810oW3uwl2HpgXc88ekNqK8DbEyaVwLkznJ5ZauF1Hn5hT98=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> How do you express the default tier who shall not name? There are
> actually 3 states associated with default. It is not binary.
> 1) default not specified: look up parent chain for default.
> 2) default specified as on. Override parent default.
> 3) default specified as off. Override parent default.

As I understand, your intention is to define inheritance semantics depending
on the default value, and allow children to override this freely with `-` and
`+` semantics. Is that correct?

When I originally proposed the swap cgroup priority mechanism, Michal Koutný
commented that it is unnatural for cgroups if a parent attribute is not
inherited by its child:
(https://lore.kernel.org/linux-mm/rivwhhhkuqy7p4r6mmuhpheaj3c7vcw4w4kavp42avpz7es5vp@hbnvrmgzb5tr/)

Therefore, my current thinking is:
* The global swap setting itself is tier 1 (if nothing is configured).
* If a cgroup has no setting:
  - Top-level cgroups follow the global swap.
  - Child cgroups follow their parent’s setting.
* If a cgroup has its own setting, that setting is applied.
(child cgroups can only select tiers that the parent has allowed.)

This seems natural because most cgroup resource distribution mechanisms follow
a subset inheritance model.

Thus, in my concept, there is no notion of a “default” value that controls
inheritance.

> How are you going to store the list of ranges? Just a bitmask integer
> or a list?

They can be represented as increasing integers, up to 32, and stored as a
bitmask.

> I feel the tier name is more readable. The number to which actual
> device mapping is non trivial to track for humans.

Using increasing integers makes it simpler for the kernel to accept a uniform
interface format, it is identical to the existing cpuset interface, and it
expresses the meaning of “tiers of swap by speed hierarchy” more clearly in my
view.

However, my feeling is still that this approach is clearer both in terms of
implementation and conceptual expression. I would appreciate if you could
reconsider it once more. If after reconsideration you still prefer your
direction, I will follow your decision.

> I want to add another usage case into consideration. The swap.tiers
> does not have to be per cgroup. It can be per VMA. [...]

I understand this as a potential extension use case for swap.tier.  
I will keep this in mind when implementing. If I have further ideas here, I
will share them for discussion.

> Sounds fine. Maybe we can have "ssd:100 zswap:40 hdd" [...]

Yes, this alignment looks good to me!

> Can you elaborate on that. Just brainstorming, can we keep the
> swap.tiers and assign NUMA autobind range to tier as well? [...]

That is actually the same idea I had in mind for the NUMA use case.  
However, I doubt if there is any real workload using this in practice, so I
thought it may be better to leave it out for now. If NUMA autobind is truly
needed later, it could be implemented then.

This point can also be revisited during review or patch writing, so I will
keep thinking about it.

> I feel that that has the risk of  premature optimization. I suggest
> just going with the simplest bitmask check first then optimize as
> follow up when needed. [...]

Yes, I agree with you. Starting with the bitmask implementation seems to be
the right approach.

By the way, while thinking about possible implementation, I would like to ask
your opinion on the following situation:

Suppose a tier has already been defined and cgroups are configured to use it.
Should we allow the tier definition itself to be modified afterwards?

There seem to be two possible choices:

1. Once a cgroup references a tier, modifying that tier should be disallowed.
2. Allow tier re-definition even if cgroups are already referencing it.

Personally, I prefer option (1), since it avoids unexpected changes for
cgroups that already rely on a particular tier definition.

What is your opinion on this?

Best Regards,
Youngjun Park

