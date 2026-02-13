Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB6DEEDF15D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 13:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C16336B0005; Fri, 13 Feb 2026 08:20:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3AF6B0089; Fri, 13 Feb 2026 08:20:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACBE86B008A; Fri, 13 Feb 2026 08:20:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99DC76B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:20:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41179160501
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 13:20:33 +0000 (UTC)
X-FDA: 84439492746.27.9AF222C
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 34EDB20003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 13:20:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="C/ESXk5v";
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770988831;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ilGj6lLTzRpN3r1IcDnTGNS5aDBCBmpZcWwGQt282V8=;
	b=4Cn8TIoplA4gblQC7eu2Aux/CnAIFC2nZw5vy8EHEFaoIffr3lQoS+T0ec0GAEzUmQa23f
	RuFwdJBNk/CF3kjCai6DN7JOTBwXB8jiqsycc4dN6TON9udwUS0+y4saK+wBjmYJjINrMW
	2tb+EblPtLJHAtxTAB9+Xrmn9/31tXM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="C/ESXk5v";
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770988831; a=rsa-sha256;
	cv=none;
	b=BN/kiZmCnM5DfPty7jDpt56DnAl+rGVhD1XLPl7DE9glWgWvHE7hXrTiKQRobmd0Xn/yfP
	Jhq+cjiteRC4p8DOR+tMYDJNrmvw6/nBFN3mVJAQNK34OMX+dp7Vke6GQIVrB3GebvROvZ
	qcjSFZtxF1JfmNcnGK0elyUJZPioGP8=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6581234d208so1491419a12.3
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 05:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770988829; x=1771593629; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ilGj6lLTzRpN3r1IcDnTGNS5aDBCBmpZcWwGQt282V8=;
        b=C/ESXk5vRL+wJuygeS3ykPf+hc58g1ow8tM2ze/Mq4b9PSux8iavt5x5TWaROJy/OH
         CZ/QN8YcEMJ2ZP6UqCLg3b8qI6EUrtxxQLvXuR3pL/7Iq8CVyk/KN0S9Ve67CWoVGFoR
         jrLoPkG2Oq5TFopJ5riZurxdlIAGsNj/M/9iX+HuFv9sN9NCpiXnXTd8EQHSIfxjV2D1
         TEYugkjPd+lWihV2pxCJ5W5ObUgNudPzR99jC6aM12QBQ3ny9jAK931fk1eWUMaUxEI5
         LDtP1wJg74k/9iF41ttv75rF0FbBcMwl96mAQg2M3Unw1VluT28IPGh6uGHT1CINPusb
         rJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770988829; x=1771593629;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ilGj6lLTzRpN3r1IcDnTGNS5aDBCBmpZcWwGQt282V8=;
        b=vW7Q9dydyYtzNy8ZZaps+VneyjFoPcM/lx6HpJ+6qihAlQiLMzXIDMgBGoTlLey1uQ
         EhdPU8iOSE4ME3D3lVn748S6zPkIVWsuJdPZqK7JdnwHerzwqKEuBkG/4ZS81weL31O0
         DiGkVVrinoqY4McMkITUY/LvZVgMT5LS7RVlmiZ18U0Pf9tK8M+dcIfFcyOEKta4RlJe
         eSgtKtNZQC7IV+qpn0hLa0zGkGUUrsu+wngy+j2NgXFxvPKcNRrUoqKnbpVkQETkDe33
         Ymv4iIaOQmXO3S3d/lhyPB2+YYrxi9t75ZN27IsbjQTEZRqRSD8MJL1W/Vp7AMPl62dn
         Dmag==
X-Forwarded-Encrypted: i=1; AJvYcCXcl1FvWHzC9JMtNTZmHLEYEKac//r4JHzA08eqq5KMN02ud4ptkG9Og9+wDFS/gj6bykj7o7L/dw==@kvack.org
X-Gm-Message-State: AOJu0YxqxJ6YmYXs6vttR1+8lcxbyPaFCvLsGUkrx57LfqGBI24fhXsX
	OMgJFpXciOz74fV3xdg8Odz/w49005K1PchmqqwLw8LKPD949W71o/uq
X-Gm-Gg: AZuq6aLU9wOwOkbw1+ZcxTTB5bOIetD7SL+vGQK/CojXwJKOfsusKWnYvV4+gCB4Gwu
	7g0mCHqpOjKN1A/O16MZOPmPKVbR6bnxGzqSYP13UiVdBuTqQIggRfWG+vIEeRdxFy7gXqtlvw3
	PpTuQk34gQhpLGi0r47MbFkNAG5ahcCanKJ8pnHINBa3c3YSLw9LoZAuMiDEziSPjYqQlT7n+38
	/EKo2hk7RdilMjtOcAGypkPfwSrg1uJeHYPlW6ojRCBlu0TC3l61R+E5EFlRujryB2SwE2mkiSV
	/sem9jrY/qLY7U1S1s9XLu4FOQFufpzShga2+lgYuTv+r+LiuzT82IbZ2ITUSpNPfCV2E3oFsih
	F59hqOuE921r6OGZ3RtC7fz/IgaegFBz6a9QFm1q8wiUzzAgwooh2zSf08fjSTVqe7cl1QL9rdm
	pBkvWCjARartbBBAuSiniSMhXo/pOs56sB
X-Received: by 2002:a05:6402:5243:b0:658:1304:b699 with SMTP id 4fb4d7f45d1cf-65bb140c533mr943778a12.31.1770988829196;
        Fri, 13 Feb 2026 05:20:29 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65bad29d471sm658523a12.9.2026.02.13.05.20.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 Feb 2026 05:20:27 -0800 (PST)
Date: Fri, 13 Feb 2026 13:20:27 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org,
	david@kernel.org, riel@surriel.com, Liam.Howlett@oracle.com,
	vbabka@suse.cz, harry.yoo@oracle.com, jannh@google.com,
	gavinguo@igalia.com, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
	linux-mm@kvack.org, Lance Yang <lance.yang@linux.dev>,
	stable@vger.kernel.org
Subject: Re: [Patch v3] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
Message-ID: <20260213132027.wm75sh6trz7n24kd@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260205033113.30724-1-richard.weiyang@gmail.com>
 <fbd6c31f-7f35-4986-86e3-76bf8963433d@lucifer.local>
 <20260210032304.j4k5izweewouabqb@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210032304.j4k5izweewouabqb@master>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 34EDB20003
X-Stat-Signature: 8j9acmntwtdydcy7s6hqbybziifmcere
X-Rspam-User: 
X-HE-Tag: 1770988830-380728
X-HE-Meta: U2FsdGVkX1/1WHJ+rOwv0Qfs9cxmewLZikT4tFMHiwj4lyXsjJx+tnvOesZiXD6sJpfzpX8zeHAxluSpejyjbmPx8kLi8teD1YeJs+kZOQQUlSGbb78VcchWFp7biOBNQNIV/GGmZfQ/zXuO/qdXsQPU+YvrHoVuxWsXnANZiHCvffFeugrENXWvP8g3zJCxfwm8Nf8hgi+8HnvBFsXtzwFZU1iRht8A9DiZzYtcF+y7HDHP8Dypnc1+DzuQVovh4f82uaPowIFVF5TbJTcyZiLmNNNTtbj/n9j1eFnboOCmvJ07iC+VgKw5Fq7TioD3ZMhhTvD6b7t6gSmm6d6CNGSzUpZUGM0j7g9uqWky486LKj6/mcugXWXs4fP+ybZs72vgh862N7Tz4j3r39U8vG7SpYLa6MzNMETWPYPYMa4CncxhCAtqWfaTHTvsMYuJts26eUQDuGCrnqUj6JbdyNS8wswAqC/pyZuW47HzaQUJwjfd21v7Z5jWp1rMiqM1lm9hJ7Ukg+oqAjKo0busy+th0XfLh0UPexzlY0+oErwK/kTOwMRT1v/4s/YtpuZulQuXgDEtiSDnzC4z7WrC8gnAt/NXYczG1SqGq6J/OVVjD6HTRd89Jrm+fuHcXK7tJQpPjErpIEaCUm+ekrnrIQKV/rfan9d3MlSQyCk5kPA0WQ+QOVHOx0/znbdPQLxmdcEp4hMoVDhdZlUVVFtAKPjk8HzUyn0zf8fO4RGIeb1FNkdcMDr30Km1jRH3U7kxls0CGhJjjA6HHrP/ll/549eresCkSxypwun+SsfSfsOIOfCNKr/DzgQo7vzQtsgra1+CjBPFjm9jYpvbft2e0aHs4Qt+gJ1SF24SkifwmJDxKoEpxzywK5GgHxoXrSXb4ZD2TGILo1/bWCqholiH7UtpE4Da9CWUH+KWX2zq1LC96bWK5fzorIF1qO16zld6Rw3lvEwM8lNHLQnomME
 3WvOzScO
 oNOG9/GJF/SSp1/rc/9ifsXp8+6PAGsboKtKwPStur+YiNG5KsasSt29X0FS1vZqwfRSWDfFRkfw2WDzCyQUeH3rzKPokt9M+LNXJU8WLFJd+L0nP+T7HIeKEtyIRzVI4psstyVtt5Ea3/G2oFPyu5II8svGRE1juY56M1PzkeywHBqtVDnHj2eBaw+D7JW5sYstAgDurb4xpbVVCwqQr2R3W8XLkVR05XdDdbXUK09PkNp1ZnxYbsKnkDHDropqQrt+wZFLUsxglLEwZ9lU3N2HOg00fyCsmp3vknrtn3GJn01AvBru0zOCoS4+Vn6fabYqhIC8RgQP1ylg7QuO3aMplRpEqf1gNbYVnc4V7+tjBlRa6ISs9CgVw2C+dz+R3nD3A9WdZ59Z9PZ8PUHXLFQf4rVdAX+uqTCoNdgy422KRQ1opBTviXuIwNGswnEtzcPbZDxdz3gmUEi5UmOHgIwXkt18BUDp16mAakwUjfNkmBPfTUtH7Ux1krgnmmMIzhLA6ysXD9szTJ/CrF/eZjmPTT6pKIfSPNCG0esYdvmVv+RKGqINokOFg6E+f11aawlNQaIpm0m8HfGhs9ibS4PoW3vXn3I1amWMPuND8P6Jdu2yUBJn7Sc5Q9k3WQ1glBNaCptOGQHRHkAzm3y9m9qD4QHIaZdQk8Ie4nyTHKc4be7Jn+jHgs7XtVIj2Hu8pq8IQN2Rms6xdukl0GRQ7sEE17UBslPKfzbqVqWiMOGS810VteCFI6QclaKnEs+6q+rYgSJ044W1AI422HblfvCRXJW9V/vK6dCdPIZ3LqOY308Q1VNcCNy6O8Vsr3PCJsfJtHD1s2whMjHLQ3Z/hkzXnIIoxjGwWJoxEfOtGZqjTmEX3ILgaM6XyPWzP0BMOaPCcF5hYid1xkR4H2APIwZ/kdWRZUNWEHQWZV1lWAkC5nxZwlWC3ruEAjPlPq5x0ixJ2FUy88BC3zTU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 03:23:04AM +0000, Wei Yang wrote:
>On Mon, Feb 09, 2026 at 05:08:16PM +0000, Lorenzo Stoakes wrote:
>>On Thu, Feb 05, 2026 at 03:31:13AM +0000, Wei Yang wrote:
>>> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
>>> split_huge_pmd_locked()") return false unconditionally after
>>> split_huge_pmd_locked() which may fail early during try_to_migrate() for
>>> shared thp. This will lead to unexpected folio split failure.
>>
>>I think this could be put more clearly. 'When splitting a PMD THP migration
>>entry in try_to_migrate_one() in a rmap walk invoked by try_to_migrate() when
>
>split_huge_pmd_locked() could split a PMD THP migration entry, but here we
>expect a PMD THP normal entry.
>
>>TTU_SPLIT_HUGE_PMD is specified.' or something like that.
>>
>>>
>>> One way to reproduce:
>>>
>>>     Create an anonymous thp range and fork 512 children, so we have a
>>>     thp shared mapped in 513 processes. Then trigger folio split with
>>>     /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
>>>     order 0.
>>
>>I think you should explain the issue before the repro. This is just confusing
>>things. Mention the repro _afterwards_.
>>
>
>OK, will move afterwards.
>
>>>
>>> Without the above commit, we can successfully split to order 0.
>>> With the above commit, the folio is still a large folio.
>>>
>>> The reason is the above commit return false after split pmd
>>
>>This sentence doesn't really make sense. Returns false where? And under what
>>circumstances?
>>
>>I'm having to look through 60fbb14396d5 to understand this which isn't a good
>>sign.
>>
>>'This patch adjusted try_to_migrate_one() to, when a PMD-mapped THP migration
>
>I am afraid the original intention of commit 60fbb14396d5 is not just for
>migration entry.
>
>>entry is found, and TTU_SPLIT_HUGE_PMD is specified (for example, via
>>unmap_folio()), exit the walk and return false unconditionally'.
>>
>>> unconditionally in the first process and break try_to_migrate().
>>>
>>> On memory pressure or failure, we would try to reclaim unused memory or
>>> limit bad memory after folio split. If failed to split it, we will leave
>>
>>Limit bad memory? What does that mean? Also should be If '_we_' or '_it_' or
>>something like that.
>>
>
>What I want to mean is in memory_failure() we use try_to_split_thp_page() and
>the PG_has_hwpoisoned bit is only set in the after-split folio contains
>@split_at.
>
>>> some more memory unusable than expected.
>>
>>'We will leave some more memory unusable than expected' is super unclear.
>>
>>You mean we will fail to migrate THP entries at the PTE level?
>>
>
>No. 
>
>Hmm... I would like to clarify before continue.
>
>This fix is not to fix migration case. This is to fix folio split for a shared
>mapped PMD THP. Current folio split leverage migration entry during split
>anonymous folio. So the action here is not to migrate it.
>
>I am a little lost here.
>
>>Can we say this instead please?
>>

Hi, Lorenzo

I am not sure understand you correctly. If not, please let me know.

>>>
>>> The tricky thing in above reproduce method is current debugfs interface
>>> leverage function split_huge_pages_pid(), which will iterate the whole
>>> pmd range and do folio split on each base page address. This means it
>>> will try 512 times, and each time split one pmd from pmd mapped to pte
>>> mapped thp. If there are less than 512 shared mapped process,
>>> the folio is still split successfully at last. But in real world, we
>>> usually try it for once.
>>
>>This whole sentence could be dropped I think I don't think it adds anything.
>>
>>And you're really confusing the issue by dwelling on this I think.
>>

It is intended to explain why the reproduce method should fork 512 child. In
case it is not helpful, I will drop it.

>>You need to restart the walk in this case in order for the PTEs to be correctly
>>handled right?
>>
>>Can you explain why we can't just essentially revert 60fbb14396d5? Or at least
>>the bit that did this change?

Commit 60fbb14396d5 removed some duplicated check covered by
page_vma_mapped_walk(), so just reverting it may not good?

You mean a sentence like above is preferred in commit msg?

>>
>>Also is unmap_folio() the only caller with TTU_SPLIT_HUGE_PMD as the comment
>>that was deleted by 60fbb14396d5 implied? Or are there others? If it is, please
>>mention the commit msg.
>>

Currently there are two core users of TTU_SPLIT_HUGE_PMD:

  * try_to_unmap_one()
  * try_to_migrate_one()

And another two indirect user by calling try_to_unmap():

  * try_folio_split_or_unmap()
  * shrink_folio_list()

try_to_unmap_one() doesn't fail early, so only try_to_migrate_one() is
affected.

So you prefer some description like above to be added in commit msg?

>>
>>>
>>> This patch fixes this by restart page_vma_mapped_walk() after
>>> split_huge_pmd_locked(). We cannot simply return "true" to fix the
>>> problem, as that would affect another case:
>>
>>I mean how would it fix the problem to incorrectly have it return true when the
>>walk had not in fact completed?
>>
>>I'm not sure why you're dwelling on this idea in the commit msg?
>>
>>> split_huge_pmd_locked()->folio_try_share_anon_rmap_pmd() can failed and
>>> leave the folio mapped through PTEs; we would return "true" from
>>> try_to_migrate_one() in that case as well. While that is mostly
>>> harmless, we could end up walking the rmap, wasting some cycles.
>>
>>I mean I think we can just drop this whole paragraph no?
>>

I had an original explanation in [1], which is not clear.
Then David proposed this version in [2], which looks good to me. So I took it
in v3.

If this is not necessary, I am ok to drop it.

[1]: http://lkml.kernel.org/r/20260204004219.6524-1-richard.weiyang@gmail.com
[2]: http://lkml.kernel.org/r/df86ccfd-68a5-416e-81cc-02858e395b70@kernel.org

>>You might think I'm being picky about the commit msg here, but as is I find it
>>pretty much incomprehensible and that's not helpful if we have to go back and
>>read this in future.
>>
>
>Never mind.
>
>A clearer and comprehensive change log is helpful for all. And my English is
>not native language, so your suggestion helps a lot.
>
>>>
>>> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>> Tested-by: Lance Yang <lance.yang@linux.dev>
>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>> Reviewed-by: Gavin Guo <gavinguo@igalia.com>
>>> Acked-by: David Hildenbrand (arm) <david@kernel.org>
>>> Cc: Gavin Guo <gavinguo@igalia.com>
>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Cc: Lance Yang <lance.yang@linux.dev>
>>> Cc: <stable@vger.kernel.org>
>>>
>>> ---
>>> v3:
>>>   * gather RB
>>>   * adjust the commit log and comment per David
>>
>>Clearly not enough :)
>>
>>>   * add userspace-visible runtime effect in change log
>>
>>Which one was that?
>>
>>> v2:
>>>   * restart page_vma_mapped_walk() after split_huge_pmd_locked()
>>> ---
>>>  mm/rmap.c | 12 +++++++++---
>>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 618df3385c8b..1041a64b8e6b 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2446,11 +2446,17 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>  			__maybe_unused pmd_t pmdval;
>>>
>>>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>>> +				/*
>>> +				 * split_huge_pmd_locked() might leave the
>>> +				 * folio mapped through PTEs. Retry the walk
>>> +				 * so we can detect this scenario and properly
>>> +				 * abort the walk.
>>> +				 */
>>
>>This comment is a lot clearer than the commit msg :)
>>
>>>  				split_huge_pmd_locked(vma, pvmw.address,
>>>  						      pvmw.pmd, true);
>>> -				ret = false;
>>> -				page_vma_mapped_walk_done(&pvmw);
>>> -				break;
>>> +				flags &= ~TTU_SPLIT_HUGE_PMD;
>>> +				page_vma_mapped_walk_restart(&pvmw);
>>> +				continue;
>>
>>This logic does lok reasonable.
>>
>>>  			}
>>>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>>>  			pmdval = pmdp_get(pvmw.pmd);
>>> --
>>> 2.34.1
>>>
>>
>>Cheers, Lorenzo
>
>-- 
>Wei Yang
>Help you, Help me

-- 
Wei Yang
Help you, Help me

