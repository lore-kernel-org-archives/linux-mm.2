Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34076C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 07:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21D6A6B0088; Wed, 12 Aug 2026 03:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6B16B0095; Wed, 12 Aug 2026 03:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0485A6B0099; Wed, 12 Aug 2026 03:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C91C16B0088
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:58:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4732CA0200
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:58:11 +0000 (UTC)
X-FDA: 85091864382.29.41910F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 82D89140005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:58:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ebebBTpA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786521489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zdrl+TMYuCssyaJsJz8djmMUcdVBc/GmUV4c8Q78F2Q=;
	b=Ti+RN9ZGHlZXHEHAGGF31fbpiaW+l2WV1Y2qwkPfX6XOTw/4+W1OnBI6wFOYM0f526NMsl
	nTpO0Bhsj/dXE1zadkTdjEApB0Dobo4Z/KForGHPht8WxuDMcxWVsz3ppKbm8ktY//M2Yl
	3hq0veMngdju8t7vKEAyyywto9x+fQE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ebebBTpA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786521489;
	b=0oIVP+e2gZ/NEsnLxJu9HhVjGTBybvW2+9y2PYE1t/dsmy4oR01FgZSYA4C5sclz/MQnj3
	LvOLNP8P7PBh+NU/W9fbX/okNAcEBjFATcABj8CdBlo/xjD8eJ45jO3dfdc4BV3yt47X5l
	I+jQE5tWLRp+Vml58EnZk+yKcO6Q3+A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A446640BCE;
	Wed, 12 Aug 2026 07:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DD91F000E9;
	Wed, 12 Aug 2026 07:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786521488;
	bh=zdrl+TMYuCssyaJsJz8djmMUcdVBc/GmUV4c8Q78F2Q=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=ebebBTpAAvbwq9QfAXw76ShklBIeNpOfAtXYmOmckvfOh/kgGivkiqeM+57tI7CFT
	 PdtJFG7TmdBRE7bTyXI2vv6znVZD7RlR1QxaodESSxoposnIJg1OGtqXl3N4p9c8ak
	 hrlL86ycVKp0bTTMp0m0bqKFMfSPEp4+hahKTI9+i1a1fg1U40pv5YqikLY7VhsTgb
	 lAQHpq5tjOdfRKM8JoDdpy3jbG/u2sPKT6E9feaXgd2VLr0VtgvTo3SamCbElLxvHH
	 Ae8POiUCHHaNArzr0M8FXCckXRcpzNpeoh+wK8vKc+ztRb2dbCwC4SP8xeS+vzLdDK
	 7FWPhKZw767qQ==
Message-ID: <6023e19e-32b1-4110-b9ce-5063f7976108@kernel.org>
Date: Wed, 12 Aug 2026 09:58:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm.git review status at 7.2-rc7
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <20260811205836.59301ca91b65781c6292a439@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811205836.59301ca91b65781c6292a439@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3mhd4zuac8bwupa7fdxoprgd7rstkq7a
X-Rspamd-Queue-Id: 82D89140005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786521489-609744
X-HE-Meta: U2FsdGVkX1+aTd24ocBkaJ6zbEOWuQbkmq9u53iH3wJNCEAlWaPR1GQ2a0GdZfihr5HyfKjZs0UH5JF6lyaeuAYDHK+EjgW07QMcIZQOgVYOj6BTnmmRpWqrvaRByYRSSEbX1CTZ2R/92aE2mluBXqF1UcO6UI/USoscHBi83F5v5Wwh2zAo2DqZkdFMOiq8zSD3ZjAPe2xxNl15SqZNnsrnJ8GHgENPUj8LTaC31B+5oDOeRt8xxdHx9Ui4p/n5/LMEl8qX/SbougSfhjjrNghxH6AFs821PeKejTvr6KrMSb1s9qS+T2vplCvBdr7wvkq71EoMF3sf4voF8sTsRbdphWFbIFtuncJh7Ybj2Zeryk0GNI1JiqE+l9IFaIyEvJXSAQy8JBdIqrlMC/FifxscN8aXN2IJftM7V8DWVsp9ri23MnFZ67RMwptAcKUSIs6QJU0m1vh2KxiRvkCEMZ33DWijPhPAR1+ouFHfeBtqMuh743o5bwJ3ucuQtTzeQfYf+q6+uGcv+VW6nCKfCKlxwq79/LIgSCciYDpEKb8fb97ZHG8qBjyCNHEhBFbfIqO7keG/OcRnzG6ebFW5uvQRcURYOakZMN4nIm7E2MmSy2vdZrAXpx7vJhZQQwuX/qUdd0IsOL23ImsJG7e86J2CWjGl6dKhuYbS1PHu2XEZNdCF7STFlZLB8qORBI+8pGojMITwA2gCFiD+WMjMLZeGFeuD0G+tzw6bd9JQkdHtwzPgiH0ZeFv1K375VQ53LrZXU9GmbF0rg0jb21V0nDxkw7ILxf8ONYeqaoO4WoBhs2ebSRjfeSYzIHnSK9N/NP4doOcLUZ5uRWFij4OVNCzQvKqIJmCMLGXK60g7OJOYHsk0h80Af7ha0s7EAv2WOxMBPkM9Pniw0dr9dkc3HjTc4r2YoCB/5FZ/Gc+CrUdbD9qAZlaLmsoNjaJn6AtS3INq8vZf5/UCJcFg5gt
 junk96Tv
 mBq/b+BHlbJLoD10o2f//UbB16hP0bK6BNO1MWp/76XXmw8ZSmbFoUD0tLrlWz/vKgrsu5DVEKX2b8aBzzG+yzbj77wMwW8b2vW4KyrDudeBY2h1EOr5JPW6JBblThpqfWvJ63+U6XKobRmGR/SfvBS2Puu330iTohJvAf6hEh7P1MNTYZoUR1Pamn0B49OpA/lWz/dZnWGgJWfgOxe3OnsRHGH2hv46Izd8r52YAV1oP6kBx+sNG9bL8K5W5aZRbStl9GBdz1lRenpyoaFYrBl7RdCuco+94o6I3KurBFiNWsn97dJTDwS3A2q2VxzDAFK71+LINQyMb8s7t7j8uh6/5FjnkWP1lVKR8Ain6txTJJcjbqzhITqYwTb5VWAE03/j2gtKdqBq9RP4bYBL0A4ingE2+hlBY15ENGntTYs4kDJKz4CDc8lRX4Aos0B7wtw4237Udg4/SIsmwWcOS4BwiJQNBmIRG/hdyUVpgfni0miIuicTTOYTJp3gck2h7cH08iLJBP4jXKEwkhFZzddnioS5xQqJWKu57yHI+kFUO3nr95kmpiR2nOcv8mRFx1yXIIlp6kKu0g3JT1Z6H70uNOypwRPeI1vOX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> Audra Mitchell <audra@redhat.com> (1 total)
>     "selftests/mm: fix soft-dirty kselftest supported check"
>         Link: https://sashiko.dev/#/patchset/20260806181843.1839943-2-audra@redhat.com
>         Link: https://lore.kernel.org/20260806181843.1839943-3-audra@redhat.com

I provided review feedback for that one.

> Liam R. Howlett (Oracle) <liam@infradead.org> (17 total)
>     "maple_tree: add rcu locking check when LOCKDEP is enabled"
>         Link: https://lore.kernel.org/20260630190843.3563858-1-liam@infradead.org
>         Link: https://lore.kernel.org/20260630190843.3563858-2-liam@infradead.org
>     "locking/lockdep: add sequence counter to held_lock"
>         Link: https://lore.kernel.org/20260630190843.3563858-3-liam@infradead.org
>         Link: https://lore.kernel.org/all/h3tpnj5kzcrxms5picmimtkpg4aypcpip5wbd6bt2rpdj5k7eb@nhtzs3lefrkq/
>     "maple_tree: add write lock checking with lockdep sequence numbers"
>         Link: https://lore.kernel.org/20260630190843.3563858-4-liam@infradead.org
>     "maple_tree-stop-flooding-logs-when-debug_locks-is-set-to-zero-fix"
>         Link: https://lore.kernel.org/fo5r2xl3fql6gyvjasfvfu4ftugjti2vxg7zskdw7hjeo3xvqm@kk66qmsf762s
>     "maple_tree: drop dead code from mas_extend_spanning_null()"
>         Link: https://lore.kernel.org/20260630190843.3563858-6-liam@infradead.org
>     "maple_tree: drop MAPLE_ALLOC_SLOTS"
>         Link: https://lore.kernel.org/20260630190843.3563858-7-liam@infradead.org
>     "maple_tree: clarify comments on mas_nomem()"
>         Link: https://lore.kernel.org/20260630190843.3563858-8-liam@infradead.org
>     "maple_tree: use prefetched value in mas_wr_store_type()"
>         Link: https://lore.kernel.org/20260630190843.3563858-9-liam@infradead.org
>     "maple_tree: optimise mas_wr_node_store() when not in rcu mode"
>         Link: https://lore.kernel.org/20260630190843.3563858-10-liam@infradead.org
>     "maple_tree: micro optimisation of mas_wr_store_type()"
>         Link: https://lore.kernel.org/20260630190843.3563858-11-liam@infradead.org
>     "maple_tree: add bulk parent set helper"
>         Link: https://lore.kernel.org/20260630190843.3563858-12-liam@infradead.org
>     "maple_tree: WARN_ON_ONCE when allocations fail"
>         Link: https://lore.kernel.org/20260630190843.3563858-15-liam@infradead.org
>     "maple_tree: document erase and allocations better"
>         Link: https://lore.kernel.org/all/20260617180419.GA231643@ziepe.ca/
>         Link: https://lore.kernel.org/20260630190843.3563858-16-liam@infradead.org
>     "maple_tree: change two GFP flags in tests"
>         Link: https://lore.kernel.org/all/d9cbb89faa5bdb71d451781d214a51ce8923a83e.camel@perches.com/
>         Link: https://lore.kernel.org/20260630190843.3563858-17-liam@infradead.org
>     "maple_tree: fix argument name in header"
>         Link: https://lore.kernel.org/20260630190843.3563858-18-liam@infradead.org
>     "maple_tree: avoid extra gap calculation"
>         Link: https://lore.kernel.org/20260630190843.3563858-19-liam@infradead.org
>     "maple_tree: add helper mas_make_walkable()"
>         Link: https://lore.kernel.org/20260630190843.3563858-20-liam@infradead.org
> 

We really need more maple_tree reviewers.

> Lorenzo Stoakes (ARM) <ljs@kernel.org> (6 total)
>     "mm/huge_memory: separate out CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic"
>         Link: https://lore.kernel.org/20260730-fix-refcounted-huge-zero-v2-2-c5d8a41b317f@kernel.org

I want to review that. I am still not convinced that we really need that right
now. The fix was the important bit.

>     "x86/mm/pat: acquire init_mm read lock on attribute change to avoid UAF"
>         Link: https://lore.kernel.org/all/20260626163213.2284080-1-den@openvz.org/
>         Link: https://lore.kernel.org/20260723-series-vmap-race-fix-v6-3-8cc77dcc0018@kernel.org

[...]

>     "mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous"
>         Link: https://lore.kernel.org/20260806-b4-scalable-cow-virt-pgoff-v4-17-ab318a350404@kernel.org
>     "mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous"
>         Link: https://lore.kernel.org/20260806-b4-scalable-cow-virt-pgoff-v4-18-ab318a350404@kernel.org
>     "tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon"
>         Link: https://lore.kernel.org/20260806-b4-scalable-cow-virt-pgoff-v4-19-ab318a350404@kernel.org
>     "tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero merge tests"
>         Link: https://lore.kernel.org/20260806-b4-scalable-cow-virt-pgoff-v4-20-ab318a350404@kernel.org
Planning on reviewing these 4 today.

-- 
Cheers,

David

