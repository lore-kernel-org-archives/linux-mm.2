Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D281ACD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 10:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C8A26B0005; Fri,  5 Jun 2026 06:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19FB56B0088; Fri,  5 Jun 2026 06:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6006B008A; Fri,  5 Jun 2026 06:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE8186B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:56:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8AA241C2A2C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:56:38 +0000 (UTC)
X-FDA: 84845555676.12.A15C998
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id CAE44140003
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:56:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q23J5p0k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780656996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUm8w415k6U8QcFmjz5s7cPq1GIEQMx0uHtMtXak1VU=;
	b=jG/6zoXvasc5uRqlYBiyDQygrDQ7zQf6dBFGHE1ZJrKCUjthGuTeTU4eSCSjovFuhJQOwb
	vhMvjqqT9bV1WwC9xqPnyDAtSIK43EjkKlGDadT6wNUbA7FdbF1Z/fjJb1IvpPXWOt4H5F
	iik5ZJ5lum3l169dpqsS86noANtpa+s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q23J5p0k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780656996;
	b=EPtxClhBMH/aS/tut1wF/im2+CxhyMDWXkFHi3SOdta6ZrBo8fhqHnIXOqnnIqYtCQT2Mj
	06ObQTnQxVgsHlqEFcM74AOqv0UyikKrSNjn61NNsE3r7zplz4PWsZ1mx0mKQp3ALzz8G3
	tg6hmc+q8zCsknoLvU1QzCN6RBgkRVI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2295A601DD;
	Fri,  5 Jun 2026 10:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5716D1F00893;
	Fri,  5 Jun 2026 10:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780656995;
	bh=GUm8w415k6U8QcFmjz5s7cPq1GIEQMx0uHtMtXak1VU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q23J5p0kWQAPg+EEk4Q+GJHKXIm0nGZ8UXg2IGF2TUJGaXUt3cT0i97qo9ACbrUt1
	 /im3EqNL3g8t1nKW31dJ0xDZz7Os0VVS5nfzXNFxbaYJIVqfabg0Y2ZavdhQDtaIla
	 OmhVjByX1bBOlxUxG6FSBZAyLQnQA1aG3xRQG9TJjibsg5FYF13UXTcKXcOBKRXilw
	 bLzo7CpUorzdHchml9B1caftDJjOhtVI2oeocxWqfsYTfiYjYEI4uzp6HovO8OZDGB
	 gOCLAZJiQ4PJRiYc6R0wy694Pr4xwht/VA8wxUY5e03IWG745MmM/i1G2l179F1MMx
	 eDq8zmBgS9olg==
Message-ID: <3752203b-9806-42aa-83be-8b88dec12e21@kernel.org>
Date: Fri, 5 Jun 2026 12:56:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: xu.xin16@zte.com.cn, tao.wangtao@honor.com, catalin.marinas@arm.com,
 will@kernel.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, akpm@linux-foundation.org,
 willy@infradead.org, sj@kernel.org, kees@kernel.org, luizcap@redhat.com,
 zhangjiao2@cmss.chinamobile.com, kas@kernel.org, hpa@zytor.com,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, jack@suse.cz, riel@surriel.com, harry@kernel.org,
 jannh@google.com, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, chengming.zhou@linux.dev, nao.horiguchi@gmail.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, pfalcato@suse.de, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, damon@lists.linux.dev, shakeel.butt@linux.dev,
 ryncsn@gmail.com, dvander@google.com, wangzicheng@honor.com
References: <20260604111035154Lk-9ZgwKY4Nlk4zz30U1t@zte.com.cn>
 <68a4aec0-72d4-4967-b063-b57cc7ee40cf@kernel.org> <aiKd7tfrICFnlWxV@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aiKd7tfrICFnlWxV@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: kdz1irryuxd5otsmfu3odpt1dkuo7wfa
X-Rspamd-Queue-Id: CAE44140003
X-HE-Tag: 1780656996-350773
X-HE-Meta: U2FsdGVkX186ebOFEB76A8fIJXWNTmI7qRqMj4OHBCL95+5OGIDHUbCkzq7a8B88Jsj9ScINKzeExkUlWTBAAC/sAap4bhbpg+Ty5f2/nsr4GccVk8nleEZKwzLCn5UqZqy5UIGDr/kvmoijnWyeeau7lYxWE8Xfv0fJ0nk7WzQD3gLF0jUSgOyfwfph5HxVzeA+kfbRnKRnSXl8bjH5de4LJaKE8tCNtEWLK+IWGPOMiapc44nmAS7yAVEeRntPBjbBF29IMQWyYz9yuLqLio2cq11p+F4tV8T3FJjbN4TCBDIIXyzaqDbIIWhh5hz5Ak62WABXDy4J8eVzBEH4Z3riG0Ka4HOph2RSONly1uB5jYuWu58giGBJ2UaUvb3NH846F9E0BGCkgrCbtsoeeleRfi1kPGa+fPl51yaQsHS4roTe8D8RLCnXdTEq6UB4FZtZJ61cdfwtxSnvCr/jE4aqRkJ33zgDv2MElQyO7KkE41kjXakVnMsCQb0YNUTIU1ienX+xCgftGGkWM7NjoUQ13IITQg+VN9ITGqSINk8dDzkCQsCZJM3ilE5eKR6bunfyqlnuCy0mrhs+qEUhU16mnJgfBhbyB7efdHU6nQpvP2SIM5I+2O20jlX0kAHrh9tjNWPFINTCUCk69wUPwhq0APk9AOs5iYh/z1UrNJbvWTb0zl77nVVNo/FSbRLqIbJaUm/bwMsoEInbiWK8UNTM4TYx4CcBawFYwikCi805TI5r6dtl6HToQ384Erah2ZN1zY/JWpJG1NQ2blHmhIQXuDFcF6c+CbmZNskpMLhrPYBf6AQrVL+Z6dOqhV5c6ggPtH30qGmhGKaeHACqm68s7ZWWimB25btHCEcftCUPEsUPViQXQ7WbdKNFA33vxVt99aBzKDuYLY01rnpqCC8H3MDNVo8PAQQj581+SgmLT04i/r6fO0bqOPbtwokQsM1xF+yInZcBZUASQW4
 GP/1I6yT
 e27YGyjjtVYAA2Y+GFl8I6eqs4fU/OCO8Xbc+0hcubXWKZc6P57gxWr3FXnlyE5IPg3/ms+OjiDlzt92INrxwlru75YEgX9emkcbiakeG6WikqzjD5OdLXsabCJMOWXLef25tXvbKU3aucA2gZSvyyuoQopc72LAAnM5a3xOlHHzfF27mKv6HpuoLy9fXC1WiNv9k2ZSlt0hwXfNkB+r4V2IyxaChvUgDv+LRJnTmLD17v21oS+ff8DydEia1Z9XsknUHVQh9OKAIxPjGed8Ae8c8qTLbialsI3Wj01LVbesP1iP0cJCV+J+paUo+fzjUaieFtKzkL5O8/URFxHXGeTAhQMsCNE5IwgWSYHD6su71upAf8w9rYQcSTD4qsKdGp0FUJ+wRe0c4BNndZah5Rnds4+wZ2KX2Uv+lIeU5fQ63V40+gCLGgsDjRCfQRfvEfw/Y8ZZI+qJz2+6s0bUbCTVmPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 12:07, Lorenzo Stoakes wrote:
> On Fri, Jun 05, 2026 at 11:38:52AM +0200, David Hildenbrand (Arm) wrote:
>> On 6/4/26 05:10, xu.xin16@zte.com.cn wrote:
>>>
>>> Indeed, it's very complex, but having the changes of 15 patches scattered across
>>> various subsystems is really frustrating for reviewers. It took me a whole day to
>>> read through the entire patch set, which made an already complicated matter even
>>> more complex (maintaining such complex code in the future will be a pain).
>>>
>>> However, overall, I think the original intention behind Tao's patch is innovative
>>> and valuable, and Tao could definitely make this patch set simpler and more
>>> readable, because the core changes actually start from PATCH 10.
>>>
>>> I believe that if Tao had done the following, things might have gone better and easier
>>> for reviewing. In fact, I understand the motivation behind the patch is quite simple
>>> at its core (just wanting to avoid allocating the anon_vma structure when a VMA hasn't
>>> been truly forked, and instead put the VMA information directly into folio->mapping):
>>>
>>> 1) You could actually simplify your patch significantly — without adding a lot of wrappers
>>> and helper functions that introduce extra review overhead — and keep only the most essential elements.
>>>
>>> 2) Provide complete test code (in tools/testing/selftest) that covers the affected functionality,
>>> such as VMA, huge pages, KSM, etc.
>>>
>>> 3) Use the RFC tag to start a discussion.
>>>
>>>
>>> I would be very glad to see if Tao could post a simpler v2 version that does not alter the rmap
>>> core data structures too much and does not introduce excessive complexity, no matter whether
>>> it can be merged finaly.
>>
>> I'm afraid, the overall complexity would increase in any case.
>>
>> So to quote myself "But fundamentally, I think we want to find a new design that
>> is just naturally simpler."
> 
> In general I'm prioritising my work, and hope to ship something within the next
> month, even if it might just be some early bits of work on this to plumb stuff
> in, and certainly the main ting will be an RFC :)

Cool, I'll cover your back on upstream review as much as you need :)

-- 
Cheers,

David

