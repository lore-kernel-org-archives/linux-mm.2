Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E18D5CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11F76B008C; Wed, 17 Jun 2026 10:17:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC3556B0092; Wed, 17 Jun 2026 10:17:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B1676B0093; Wed, 17 Jun 2026 10:17:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 661F36B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:17:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B30D18DD95
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:17:56 +0000 (UTC)
X-FDA: 84889608552.23.7B71750
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id ED183C0015
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:17:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QlUK3tnL;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781705874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNs1ZGDzpXvXynbFB8dhMO8k1VwEDdh1BolkKQfqzP8=;
	b=QO3nQj6wj1TBE5CJoO6GPZHFef+zoj5oj8/6hANygF1pEpEPOHnV72k4h5PF9zztxeMDg/
	bkJNybiabzCmcw/NJgQDCsQecShyG6eHuL38dPuyI9aDkWiixc0j5gPUyjxyuMx9IwVk98
	OqGModLvt809ZwztDWfwFJYNEMRSC0o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QlUK3tnL;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781705874;
	b=HuhtXCNMwE+iht6pT3+LwNIXp96jkTYrERbP8uZCRxhwhjPlv8GEubjAPyMvWNVUqZM/8i
	YwIL+Sp0YRFZoThac8Qa7uxC81MZw/kgVhLArhibO7a7amNaZgU4+kYALfyXt+4X504G3b
	Hc+SfY1CdtpRitlehhL7ijGtLgczWrY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6039960052;
	Wed, 17 Jun 2026 14:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387C21F000E9;
	Wed, 17 Jun 2026 14:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781705874;
	bh=hNs1ZGDzpXvXynbFB8dhMO8k1VwEDdh1BolkKQfqzP8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QlUK3tnL9duWBhonQh/40AZCQ4QrF56et90GAVQwBqaN7Ea7ZfTFqpfMqEVtVCGTv
	 Ivr/0159PtHMdsLNu1Arb6uWU92QjTUSg8kMrrJ6avx5Y8T2sw9An4TxpXS4tCXHaD
	 Fc1BZ0/RIxOE9QFFJljrtVlmRNbFjP3gYFdesKnZp4/Vih1Jr5xm9oRMxW3V10g6wO
	 LUMecUKBJX5hqBclr1dJkdhJW7FH3fOZy17JBGVBWkdAtFroI+QNS9zN2AC48ufHYb
	 7Wt6nIwqV/dIrAWFJc9n5EZ2bOl6aQf0NfMek2MC5yXtSEFIF6l/hB070pnLdzo0Yg
	 ZOiIqa4gwHpdg==
Message-ID: <53111e55-0e9d-45f1-b19e-554b0b17e746@kernel.org>
Date: Wed, 17 Jun 2026 16:17:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove mentions of PageWriteback
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Konstantin Ryabitsev <konstantin@linuxfoundation.org>
References: <20260526195650.353196-1-willy@infradead.org>
 <849ad1f8-973f-4742-b56b-7d31570d93fc@kernel.org>
 <ajKj71cXOZMf6mK9@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ajKj71cXOZMf6mK9@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ED183C0015
X-Stat-Signature: ggscd9c56yb9st1cw9upmkmd1d8hg9ow
X-Rspam-User: 
X-HE-Tag: 1781705874-942849
X-HE-Meta: U2FsdGVkX19ne8nVy1xFlvUnIC0SwCsTAshdrYbTbulDPjvaA+XmLfyJB3uwa2pYTTRv5LQT45kZsbx6gKkowuv3Et6EXw2Prq53ONBzBRqzkK/xuJJl7DEu0ht7Q3v67KJpRl1A7DaCaNAqDR4AX4U/+iIocQJPodUkM9pljT1gnUvL+vTOpDRc3rIoC9b3QDR9F8jbVcOaH224Ym/d0nGNPKoSIsui6Uzszj7IQOJaKqrg2Ek+xYlStSDUw9hx1M72PZ/GR0VfluwD6c+u5YE5o0Cq0ZkAizl6St2zdPKVmccOKVrWnWe87k8bOYykttOdy5BrHYcdyoEQ0GV/IhBIQXhw0lqyQF3e9m8TihNslNpaOxbni1HTDc1zBz0K3P97qup2XpnQJqRmUXfNNdjlbfaqeRJC//uRJ/VCSYs+XU/GCvW0CW5x4/fbB9k9ZK9Zl8kfxVsljWW3Cg+bQlR36wHsIS1p8lOiisMfcMpEV0EALVmHLA5OK1l6SrMjOlKt9XwCv8s1I6P4g215IAegKUo3bQwF8I+gf0H6qyhUOd7cEu4gtJyRvMnFdb1qq4Xtc1Vy4dZ4FJViN0DnUnIJa7EOQ7UmmLgok8w8OMIGYn9xlHNsAEBaAsIJxEptHDoLPpfa0uT0/pcF/iJJB8YSYNJxywP28FYxQh/0qCVhDSr/K7L6IPXIrSoxkE1RAr+StTjzX9fvycN42PHNLoghpvQocm2LqU2XjDNSHMoQok6KV3Enseai+U2cs60Jz76+MJC6RVmTd2q3+fOWUCKNkZtNeStQ4JbHmuCQBqo9yJjHzFB836TDUHxlzbhp1RjTOzFctvhp3G6IG74FlU7tEHsmENoyz0LYHXEr+CEfq13/cCScGgeCVH7DOTOegizjDgBJ3LR4tVFwb9QxQZfevoPW5yd1BChiI+1RRlCvszQc4aynRhB73N69pY4B9yM+m+KGidX0gGnLIT/
 j3QQnYI9
 QSEqr0NcLfC0ByxWIXxeqRAvtTVJJDwa/0sKPg3gjxhL8nTSnRMXX1MA7iq3sNCZOVuJkKL5yevkhI4KXBuBnmy1uqM6aPjNzuk1ow1GZeUuQW93AFjVsnEasyaa3mNronNsYaaveetITkWIPCbmTjy+nYUVl4ZHjud5b33RPD1vfYQjxVn5dpnwvm5zvSHkmfbBPVW+8km39Zo9bZrUNzzLZDkeGMrT2eNOKXfV3lc7UW3wKWvEcdOAy6oBmhH4Qi7mT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 15:41, Matthew Wilcox wrote:
> On Wed, Jun 17, 2026 at 01:15:42PM +0200, David Hildenbrand (Arm) wrote:
>> On 5/26/26 21:56, Matthew Wilcox (Oracle) wrote:
>>> Update two comments to refer to writeback in general instead of the
>>> specific flag.  Convert the large comment in memory.c to be entirely
>>> folio-based.
>>
>> How could I tempt you into using checkpatch.pl or similar tooling to pick up
>> people to CC from MAINTAINERS? :)
> 
> Honestly, better tooling.  I don't think checkpatch checks for "have you
> cc'd the right people".  I presume you mean get_maintainer.pl, but it's a

yeah, get_maintainer.pl :)

> pain to copy-and-paste from.  Particularly when it wants me to cc Ted Ts'o
> (shell quoting rules are bothersome).

b4 does a pretty good job for me with "b4 prep --auto-to-cc". I barely ever
have to remove people (rather add some people I want to CC explicitly).

It manages the CC list within the kernel tree (in the cover-letter commit),
and respects CCs on individual commits.

"b4 send" would send them out, but ...

> 
> There's git send-email --cc-cmd, but that doesn't work for my workflow
> where I generate the patches on machine A then scp them to machine
> B where I run git send-email, but don't have a current kernel tree.
> git format-patch doesn't have a --cc-cmd option.

... for your workflow that doesn't work.

There is "b4 send -o tmp-mail/" that doesn't send the mail but stores them in a director.

I just tried with one of my b4 series:

$ b4 send --no-sign -o tmp-mail/

Which gives me:

$ ls tmp-mail/
0000-mm-remove-config_have_bootmem_info_node-part-1.eml
0001-sparc-mm-remove-register_page_bootmem_info.eml
0002-mm-bootmem_info-drop-initialization-of-page-lru.eml
0003-mm-bootmem_info-stop-using-pg_private.eml
0004-mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.eml
0005-mm-bootmem_info-stop-marking-the-pgdat-as-node_info.eml
0006-mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.eml
0007-s390-mm-use-free_reserved_page-in-vmem_free_pages.eml
0008-powerpc-mm-remove-config_have_bootmem_info_node.eml

Which should contain all information, even including Message-Id:, In-Reply-To:  and everything.

I guess you could just SCP that to the other machine and send it from there.


What "b4 send --no-sign -o tmp-mail/" doesn't do is update the version information + create
tags etc (like b4 send would ordinarily do). "-o" currently implies "--dry-run".

That makes it a bit harder to use, because one has to manually, after sending, use
"b4 --manual-reroll COVER_MSGID".

I guess we could extend b4 to just do the reroll even though the patches
were not sent yet (to not imply a --dry-run). CCing Konstantin.

If you want, I can give you a full rundown of commands on how to get started with b4.

Alternatives would probably require a git tree on the other machine.

> 
> So it depends how I'm feeling whether I can be bothered to cc absoluetly
> everybody that get_maintainers.pl suggests, or whether I pick and choose.
> And for documentation fixes, I often just to: Andrew, cc: linux-mm.

It's a bit sad that we usually ask all submitters to respect MAINTAINERS
(and complain to them if they don't), but I have to stumble over your patches
when scanning the mailing list occasionally.

-- 
Cheers,

David

