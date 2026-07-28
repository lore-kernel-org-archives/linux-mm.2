Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 840B6C54F54
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D0EE6B0096; Tue, 28 Jul 2026 15:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3823D6B0098; Tue, 28 Jul 2026 15:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24CE66B0099; Tue, 28 Jul 2026 15:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F41A96B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:05:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 979251C0C98
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:05:51 +0000 (UTC)
X-FDA: 85039114902.15.561A2BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E2F9B80004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:05:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n8P1eJ+Z;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785265549;
	b=7dHUUy64rpKPBHGkb/wp2GKKHQrfGgYhEZm5QTPG/iDGcrh9asCO61qZ80ZcMRjNEMoXR3
	QkCA1KlOFfslk5KFzjlPZKUw0PlEtwuUsvorraFPq4apxxHQDT2QbLIs92g6D0J924Dwov
	p1TP9Tj14Qtm15SgFoYkkVIXHLJAmEw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n8P1eJ+Z;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785265549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u10PFj7dkgwUEG86IzmKK3+sD+i3+8K+3s/J+UMugsI=;
	b=dmKHlb+BS1wv2UTYNIGmH4PSbtoP5/ipPvOFpoh63Clb/d2e11nAI4iZCwFk0FwkLFOvvL
	wWAEWtUyNlkHwyhOe0zehgOfUmeDEtsnqH6s3FwRJP4xnuB12T2jtNuzEdeCLM3q62K4Wb
	fGPul2Yx6YFLvqLwtDdNFMWd0e7SKLY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AE15600FC;
	Tue, 28 Jul 2026 19:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE281F000E9;
	Tue, 28 Jul 2026 19:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785265548;
	bh=u10PFj7dkgwUEG86IzmKK3+sD+i3+8K+3s/J+UMugsI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n8P1eJ+ZSvh1KoISAa7ptxeD9wD8kerZNsRE6m4wTJvISY6KXz64/2h7lD6TRwJNZ
	 I7vHyQ2BgT/+d0coaXQ/4GgpGXo2oegu8KivO6gKTVfSE8dpx16/q0OEtMaE4Iz2cb
	 rQysjKHFCpoMzEzfYKeNlSnwK7hV0xP3c9cjbe4AS0qo5Nha8YdRo4fy+DYeXa97UH
	 7VxL+AxPpJixZNM5DfzODbpgPkvgJy3W6ssgtjVMTqIDLcwquIqrOcDplN3Mki89B8
	 GircUyhmeRd19p1K9/C7rOCusYJCjM560yCsa6A2CPlPkc8Hf+9tCqwwxG9vzZcqbw
	 rvc1S0EUhOZ/g==
Message-ID: <7fbdb447-3d6c-4071-bc6d-1af4e44cbd7f@kernel.org>
Date: Tue, 28 Jul 2026 21:05:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 11/12] mm/gup: batch contiguous PTE-mapped large
 folios in follow_page_mask()
To: Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>
References: <20260724222934.1463812-1-riel@surriel.com>
 <20260724222934.1463812-12-riel@surriel.com>
 <5490f8b1-d611-4e4d-bd8b-19c0e05698a3@kernel.org>
 <a086dbb3cc9ee8faa638c70bd282ca31c58d402d.camel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a086dbb3cc9ee8faa638c70bd282ca31c58d402d.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4wyx5asrjxpmc47o1scijqec6ogenkb3
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E2F9B80004
X-Rspam-User: 
X-HE-Tag: 1785265549-124454
X-HE-Meta: U2FsdGVkX1/U5lfpO7x6ts7lr0tEjzZmUlr9EMUQfXoRSMZz5Q0zXDKMyqGHf+qsYDHoE2ihCsFIWGxnlWl+HN/3uqOvCKaHRXNkhqM8sXwHzJwxeSG9VzwzqRxhj9WnFT8e1brtHtPpKZs21JhgEVAk/v3aMkVf4IETGY3bOZSv+dK+85cBwpUiKRoWpWRrT8pjscpYY8OR9nw6t8c9o8IvFty+Lsgfj6hRUXnIarucZ+t+4Ne6RFTExsWjzz+WzCYmDzDcR7MxUYxzdvkN1A2w7WOewRzqjiqua9nJll0CWfC3xU9WBy65ZDJYhDpM3/F70Uku+QbkVlEK5O7FpjMrQNeHn/bBqjh2hMlEMpB+0V6Lu8GHN72/79WsZY9a7iS7mAO1N9lBEW4kSHD53l3SenXNSzrT3EfkMTq2uDswTjqc6BJwqlZUKl+UqikpPzCeeSmyKbfc/bf9mjYtOh0JrYTPULdeIvxingzdJmrjj2M2J9se73zPYPkzq0af0i+Lgb4zsbGG9lvePXE+OrqIa5Qmc7NUMu4HJF5W+ZYcjkMt5/kdl/qsKIOzvCZJ5r2c7/7FDR4fZL+gXwPCwX6WUsMMKSHXw1+c7KILq93MST/bWPcDLEC3mVJ87BZ9XUX4NqSZ/0F9vZ5NTa5hqNBRBg/R3rZsa0E7b8nD8RHMEPCaF9i+aUTdEPeerHCwQ0+KDXE6+6VDYKo/KMA2HzWnmFXUE5RWWrmOH8b21sttuK4qe9z19IY+FnpLep27M6nhd539ZIqx0aDbY+PTzClBHuhqwyr0cMl2zF3/V4ePawnLNdWc3pfw1Gpl6Z9aLDk5vm43kWAvDTsFesSHnhP6gLMsIpxxd8x/95Dzw+ivVS+k8dvZcuRbO17GzcsegAQBLjRCJgOKfA/mvGYO/aXAnfLHg3dvCtIeYuHM5ZFCXK5JMvyzNpDjXHlUtveJVqX3bwKU0ugk24f2Dp6
 pwh4HGZa
 EkhNKxeYFAc+73H03B/ESLMmJ61C1ZDRpVPBtQEERh/d5n2i1DsUowPRncr6FbuTTIQhUqj1nyBwxLch4JQAdzsr0pcT6oZfksNsQG/KsV0140YibGbQW+hOPqYRcvxVtX7rCbWTGVyERmADFvQ5z+gkvsN5gdpeT/PMwj0+nyH5jDhOAcHvMJCBJ8O8EwFrU3nUrhkw9yeyBSH58D3TNAqmgUwBK+qxNUDhSexw+K1wPdAbVw7p03G1SC2y0p6eb7NKWAmKxhsgkuZRpkFY79g/59pCgdFuAeRiSb6rIL4MpyG/zjkYZ41R5e5WGfkYjuO9GAvdgSSTSntRrarCcGAg8VNAxITnAsKz8cxXwTDmzUYj9kmWVPz8HgaklJPVCharl3+WHm2mW5OE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 02:37, Rik van Riel wrote:
> On Mon, 2026-07-27 at 15:54 +0200, David Hildenbrand (Arm) wrote:
>> On 7/25/26 00:29, Rik van Riel wrote:
>>>
>>>   gup_test -L -m 256 -n 65536 -r 16 -t
>>>                         before      after
>>>   64 kB mTHP            3140 us      412 us   (7.6x)
>>>   2 MB THP (control)      78 us       76 us
>>>   4 kB base (control)   3010 us     3042 us
>>>
>>> The PMD-mapped 2 MB THP already returns the whole mapping in one
>>> step, so
>>> it stays fast and unchanged. The 4 kB baseline shows the per-page
>>> walk cost
>>> that the 64 kB case paid before this change; only the PTE-mapped
>>> large
>>> folio case improves.
>>>
>>> Assisted-by: Claude:claude-opus-4.8
>>> Signed-off-by: Rik van Riel <riel@surriel.com>
>>
>> Why is this patch part of this patch set?
>>
>> This makes perfect sense independently, no?
> 
> I'm happy to drop this for now. I think it would
> fit in better with another optimization to only
> take one refcount per continuously mapped extent
> of pages from the same folio.
> 
> I can't really untangle it because it modifies
> some of the same code as other patches in the
> series, but I'm happy to save it for a follow-up.

Given this series here is RFC, can't we have that optimization upfront? I'd
assume it will benefit quite some use cases that pin multiple consecutive pages.

IIUC, it'd be mostly patch 10+11. No need to worry about the test case right
now, we can do that later.

-- 
Cheers,

David

