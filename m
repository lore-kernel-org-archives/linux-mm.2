Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE46CC55175
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 10:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2486B0088; Fri, 20 Feb 2026 05:00:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06CB36B0089; Fri, 20 Feb 2026 05:00:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A7E6B008A; Fri, 20 Feb 2026 05:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0E3E6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:00:19 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45EAF13C162
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:00:19 +0000 (UTC)
X-FDA: 84464389758.12.5175F24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 243DC180014
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:00:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pbxYxlFj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771581617; a=rsa-sha256;
	cv=none;
	b=TpmgOpvb9bq9hqGJctSKo7SS/3KT2u87hr+/Jjz+z6clPt0bEFqbwGRmIKqATjoZH1DLSx
	XnieLa+ZSv+sPr3ifr1tU4LcvZLpfq6wUOdQSHyqpsfSWa7AMNtmLqY/vnnsvAeB4idtEI
	gDcM8Ov3qTKNTo7vAqLZk6jYujvRBaU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pbxYxlFj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771581617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVuxxtBS7Ut5yPVZ4E1iz5TIXPHXs3KCE2aWHjn97bA=;
	b=FFt+TcvMF4adRxFw1mOppztSdOKpsK74DFIP3Nzu/bpjBDHgmmsuOYOCmtKIlmUMTklsNU
	w9J0JDUy1EMyizNtxMwai52Dua+I5Ewu90Bsw7Q669Eka0SXaqxExOtwYw4Vp1it6pOwop
	WI5ra/Wh9ZUMKqpTxdgO1BHGiTO88vI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DF637434CC;
	Fri, 20 Feb 2026 10:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A77C116C6;
	Fri, 20 Feb 2026 10:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771581615;
	bh=VkEvwxqYoYFxY/UbJcwTRFOB/VkFF54s/Ok6Mh0zn9s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pbxYxlFj4tKvuzSnXFHQhXhVbVrAhp2IaHKWy48ugnMvOzMWuqHRWG8WXgkj0tUEw
	 FtHZP8vXg8cG+n14TxmREuGdZuE7qXEawVsHfi5co7WkwSgfrMhXpKZwHUb5LMmOGw
	 oR5oIgGtTuBz2rrnicQ68CHKnO4fgQhUWRE+mb/q9EVK5MhZ8sLUMe+IvQDwBftO82
	 gWXWZz3B1B5qDr7fu1yLaxeQWMc8IT8jEGbGDnOuKxfmXRB6wCYYa4wE4bpZAjtIoJ
	 h31PZwOJP9NpYmPeRBXY/tWq/Q0y9uWBxW8fz7RFaAiiQ6zGFUKMvKYA8I9gV0U48c
	 b8Hnoaq6K14kg==
Message-ID: <8b675db3-530a-4b60-96c3-cff936ed764f@kernel.org>
Date: Fri, 20 Feb 2026 11:00:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need
 1GB Transparent Huge Pages
To: Rik van Riel <riel@surriel.com>, Usama Arif <usama.arif@linux.dev>,
 "willy@infradead.org" <willy@infradead.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 lsf-pc@lists.linux-foundation.org, "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
 Lance Yang <lance.yang@linux.dev>, Frank van der Linden <fvdl@google.com>
References: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
 <0c81121c23a9b1016425da100f11cb31feddd7ad.camel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0c81121c23a9b1016425da100f11cb31feddd7ad.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 243DC180014
X-Stat-Signature: xzp41b5kg9cyg19ry9qjzrw4hyjcgc7y
X-HE-Tag: 1771581616-691955
X-HE-Meta: U2FsdGVkX19O2XmtEhWvS6iWtWKOgtt0uSVAo9T3EM67AI/LyIzYaRahJzFfTmA9oyM+MvQA88mnosTo07F6f0AXhKQb58KzdwKN+oUqvQ7/N1H35e8WWtIUkInJSYSV1ZB++SESrVu8GNschjeWTBjf8aVle2CP4/JZ42RCGAtT+ZlvmP9bNZ5heEcUtxUzZnhp/nKD4JHm3SPEUOuujtOtN4llDPTKp5Hlo01BolcZL1dHw53icH6k31Y/Ql8tnbP2Iqf2Vqi44yPp2P4kQePras8+CC/gMLuhJr1EMdAZQkZfMKPzWgaBrSOp9QtbGOLvd4ke9ZV2mMvLoHOIDHD7XkAk0A6gsIlfyFi+f2A+efBMSYp8X0LVtF7DbNkDoQujRDoSA9RneBd02VVqsyT6OPsz62Qdw5HQn0DjvZFui3oFnN7GDYVNxtj4eOc9Y6YNgZZH1V+4QStcGSVtgX0Q+LLGRIi9waYuEAr4y8m1qoGRHsH4xi79192kbMSO9NFVd4n6bpuJxrYe4KvYT+kiCWWlMLnaRdLLvXA4x/y+jXCHij5ZH1esDJDcbeSMdtBOl4D0AU+HVtd+5rMucOaiwbFDXu+U/A95bpQynASzE4mObF+5FoPJTLKf2Lx/xBY2qKJe/ZSApR9PslQAMOQ7RIn0BOgzZsvui1POPf7OD+vjY0v1RO/En/staInp5uRbMzMaU1mq3O/wsTTbFAxFE3ECUaNj5Zh0JmbMiPt5EnMsXMohYidaNSZKPfBEAU5OIgbrjeJ2RCYbwGfJH6ZGdo3JXYQ/U9g6CBql5Meht/IvrZel6SxUhasyO4diU0qpzL7o6uXLDneaACssHwBLY9Grkh8iPb27EkxdzcxfhY5/WY0I6n3roVHPRk7qBtUF5Jtc+YaK/g2jewk9Ob/OElbLdu87zDcPx6nRJUzL4R1vz4rfQz4wbtcD/VX/qCJ9OU/EQtVzd1Oa0IQ
 9I2d9Zcr
 kISb+fV96KqhwNDKXaAy+8WkB5h2i8hMQkhFUmpq9XMJum31U2KcU3b5wy0YWHbTk4z1mwU9rxGsSi86wH4A1AqzDkEnSauuG95+RazSAOBm5X93LwzrSdSpVVS7A0h7Ph+2UkkmOGM1Bwu96vmlTpvollJx6DYV4TnJfykgFwRrhOlicd8aB0sf1EZF5qu/d4+vSgVwyGwLar635JfTSRoa+1SqBhsvirjGWAAFSTeyxMmMO5ok3ydoNSg1vDx91eTKME0KSjNDJDjX38j3tRgF8kMViwHh3z1fryoqcjPQcDZVjbQdmP9eP0gZgtr5pfpp0isj1+iGhKHTZN0lDjgqsqUGXee6Vur7/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 20:02, Rik van Riel wrote:
> On Thu, 2026-02-19 at 15:53 +0000, Usama Arif wrote:
>>
>> Is CMA needed to make this work?
>> ================================
>>
>> The short answer is no. 1G THPs can be gotten without it. CMA can
>> help a lot
>> ofcourse, but we dont *need* it. For e.g. I can run the very simple
>> case of
>> trying to get 1G pages in the upstream kernel without CMA on my
>> server via
>> hugetlb and it works. The server has been up for more than 2 weeks
>> (so pretty
>> fragmented), is running a bunch of stuff in the background, uses 0
>> CMA memory,
>> and I tried to get 100x1G pages on it and it worked.
>> It uses folio_alloc_gigantic, which is exactly what this RFC uses:
> 
> While I agree with the idea of starting simple, I think
> we should ask the question of what we want physical memory
> handling to look like if 1TB pages become more common,
> and applications start to rely on them to meet their
> performance goals.
> 
> We have CMA balancing code today. It seems to work, but
> it likely is not the long term direction we want to go,
> mostly due to the way CMA does allocations.
> 
> It seems clear that in order to prevent memory fragmentation,
> we need to split up system memory in some way between an area
> that is used only for movable allocations, and an area where
> any kind of allocation can go.
> 
> This would need something similar to CMA balancing to prevent
> false OOMs for non-movable allocations.
> 
> However, beyond that I really do not have any idea of what
> things should look like.
> 
> What do we want the kernel to do here?

This subtopic is certainly worth a separate session as it's quite 
involved, but I assume the right (tm) thing to do will be

(a) Teaching the buddy to manage pages larger than the current maximum
     buddy order. There will certainly be some work required to get to
     that point (and Zi Yan already did some work). It might also be
     fair to say that order > current  buddy order might behave different
     at least to some degree (thinking about relation to zone alignment,
     section sizes etc).

     If we require vmemmap for these larger orders, maybe the buddy order
     could more easily exceed the section size; I don't remember all of
     the details why that limitation was in place (but one of them was
     memmap continuity within a high-order buddy page, which is only
     guaranteed within a memory section with CONFIG_SPARSEMEM).

(b) Teaching compaction etc. to *also* compact/group on a larger
     granularity (in addition to current sized pageblocks). When we
     discussed that in the past we used the term superblock, that
     Zi Yan just brought up again in another thread [1].



There was a proposal a while ago to internally separate zones into 
chunks of memory (I think the proposal used DRAM banks, such that you 
could more easily power down unused DRAM banks). I'm not saying we 
should do that, but maybe something like sub-zones could be something to 
explore. Maybe not.

Big, more complex topic :)


[1] 
https://lore.kernel.org/r/34730030-48F6-4D0C-91EA-998A5AF93F5F@nvidia.com

-- 
Cheers,

David

