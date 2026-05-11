Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BBBFCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78CBF6B00CF; Mon, 11 May 2026 09:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73D6F6B00D0; Mon, 11 May 2026 09:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62C206B00D1; Mon, 11 May 2026 09:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 51DF36B00CF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:34:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEA521A012D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:34:25 +0000 (UTC)
X-FDA: 84755233290.21.726F0B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id EF25F40002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:34:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T2BnNcIN;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778506464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55gTQHWfRQjTX0PZ0AzZVpqu27T9SCzRticmAHA8oag=;
	b=W47V5M+4Ol+VlnasCk5RbWo8PsCw4yjQvQdKswqtJt802jCJERJ9fLL0bS8mTcPv6uCWu/
	dBo50WQbbD6rH2xoCAZZwlVozWnHbIqtVMEG2bG/4hR48SQ6ekvc3usqQ/8tkJ4/11n0Tp
	5RrrXJJ4zNa4vUAz4kMob2XP4MyI2h8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778506464; a=rsa-sha256;
	cv=none;
	b=J6Lc+x95VW91vC3jZzuHvNO2n4wkA8txG/rzoybl4Rq9AAw1nCUVizHN3sz55rWjbpnwAn
	SANhXS25PnIuPMcjlGv6n4WS3x4MMR+R0H4UPQI9fBchWXRf5LmfT5b2T2E+sIsQddUWQG
	F/s27TmH5Zcl9xaQ+jybqkPtXLYmUHg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T2BnNcIN;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DF42241782;
	Mon, 11 May 2026 13:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8302C2BCB0;
	Mon, 11 May 2026 13:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778506462;
	bh=j72HTubFsOIYbMEtyYXlD7M5D6HK3LB8/kEeO2w5Bew=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T2BnNcIN5YScjHD3wtjb9RNuQ6p/Vt806Q4CVEAghjtFothkBtEcrBmAkRqRvkqV6
	 vn96MWKfiCRLLviFkKZknm/h50Qc78gweh0eS/bH9aZfDwm8mnZrhUk81DIE2ojbdE
	 62yLypWWFnTJtYy9f4Rh2SffC7ZK1iI/1pT8sQDJXI8pq8053xLOrC18vuhZqRQtFb
	 RtG6U+hlY00P1f0J1y5OUAnaQAM7FDlMPhnZ7vK4JKANBPz3wVKkQKn4ow8kHWxjy4
	 bmxFWeN7b/GFT0WiLPNzdbtaSqTe2Do7X1MbWtycbj0NvB8+N9lqIIVa/kqE+DGgXB
	 J3aMfMxp2bWLA==
Message-ID: <71d77e4e-8441-4575-acfb-ac81ab57ec95@kernel.org>
Date: Mon, 11 May 2026 15:34:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/3] mm: track DONTCACHE dirty pages per bdi_writeback
To: Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Ritesh Harjani <ritesh.list@gmail.com>, Chuck Lever
 <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org
References: <20260511-dontcache-v7-0-2848ddce8090@kernel.org>
 <20260511-dontcache-v7-2-2848ddce8090@kernel.org>
 <20260511-begonnen-zuwege-b4272b78eb00@brauner>
 <960ba89c3c6a04a7b9137322493d65e4ab4cd7d2.camel@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <960ba89c3c6a04a7b9137322493d65e4ab4cd7d2.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF25F40002
X-Stat-Signature: 8hqg11jpq77adcoxpcoc4wkp9j7737hu
X-Rspam-User: 
X-HE-Tag: 1778506463-142819
X-HE-Meta: U2FsdGVkX1+u9FUJScLNxoF09smAAUTz446EX4+At3jd8VCmzljpjDcw3rGWQUaev8YfwLeUyZB8cr4s+76bprKFJSmb/6/XCZQNIZXCZCfDkio5tsEKXSgTRnfuTnRQNBTGjuk/KyGiBccT0oot5W/nx/cZ47Rw86Cvwei4wjhWLwsM44aSLCONi1e9Gr7hgsU27nu2d3b5snNB9CZk/nKarsekcperVnS8QcHmYXb1YhwByAjjMiSihDzS742jBXEIdE0qtTgQyOvn0Il4KauqfMY+P3OQAZIDHv7YhXL8Dso8xVev/8OomACGijMu15TMo7Odp4aBEYpMTokS5S8RLmzknOTx/ufKGX3/jj5DFNZPrEXCGOyIiWfy8vJXgO2wnO5Zq2/0Agw8tdEa3FZ0djn4S7TrPkPKPArhLg6f2xnqR3Wn7vrqqDWCXzBTi6u4V8QVh1d3u+SUJBa6ZcCqijDZGj3Z2UVrrsik1Wi6tyEQgj63S0U/L1ljEsR4M4kFmMBb8xVB1XbNyeO2bZlk0THHTyD8TN2ahyxpCgp2m3kh+jqIsQ8S3LDmmbv7dfM46oItT47S9uAnkmleg2PC4v1LMpvhRKT+euB2nm66yEFHq4Q3TeYzpJp2zsACI0FB9Naso0LqJoJeWMlTpyV8qne+9BzuKERBn+TYKsFK86rlFVs2XsTlvtc+uDx02zG4DHWeOnLpmRw7qyoYevdj9Wf4bQuWUCjHra3IQ0hhMSQNEKK3X2uUKgZOmdHP1d+2yS3Snk3M23qOFMZmHPbIz+4vCzZ7J+j94OAcYZKG0o6ZTKRs0c+YE31KaSdylLBYyV725f1ARY5MjCBD9N3uHNP41j5wAqgYr2BNzp9jAkFt/ngDPnRg4MB/fSlhTN1SDkJLk3c7E0Eny9ZF5dO/i3uTvmNiaMiIRnXcjMk6RI3tr0udifol4QERKQC/Nn/od5le4mJ/70hDV2e
 /eGgJzHV
 YvqZWdUdqN9ZbFk5QWjJdhIbygzfW6Nn2sXolHFhf5rXfJtgWc/jVENcR3tUIA/ispUNaNISYOETfhIp+j3RzQ9XDGO9+vF73FjFDIYnj0pYcYINGvzyy7lokKknDzhzUrxSKyXwVDyfhtLhm2xIMrxz/O+2kqT40BMqK+nO/a+ItbcsjP2uBgLNwoU03ZbJV4L0wmhBe6EVsV0sdXdSw2IlaOwQpulRF3odxCrnYrywGuam1Z9Faj2DbdY/kS/nMee5moJnCoxtOeuyDdd1Lgz9Qxx+8yhCdPnwmWGNb48/mqBUoAuvzcqlgkRMvQE/jHT1V2Ok4I+x0NzISL5yW1vXRFEB1QqUEQ9QSFOq8tHNYiNXok0arydHzpErSS6Y1vCII
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 15:29, Jeff Layton wrote:
> On Mon, 2026-05-11 at 15:10 +0200, Christian Brauner wrote:
>> On Mon, May 11, 2026 at 07:58:28AM -0400, Jeff Layton wrote:
>>> Add a per-wb WB_DONTCACHE_DIRTY counter that tracks the number of dirty
>>> pages with the dropbehind flag set (i.e., pages dirtied via RWF_DONTCACHE
>>> writes).
>>>
>>> Increment the counter alongside WB_RECLAIMABLE in folio_account_dirtied()
>>> when the folio has the dropbehind flag set, and decrement it in
>>> folio_clear_dirty_for_io() and folio_account_cleaned(). Also decrement it
>>> when a non-DONTCACHE lookup atomically clears the dropbehind flag on a
>>> dirty folio in __filemap_get_folio_mpol(), using folio_test_clear_dropbehind()
>>> to prevent concurrent lookups from double-decrementing the counter, and
>>> guarding the decrement with mapping_can_writeback() to match the increment
>>> path.
>>>
>>> Transfer the counter alongside WB_RECLAIMABLE in inode_do_switch_wbs() so
>>> that the stat is properly migrated when an inode switches cgroup writeback
>>> domains.
>>>
>>> The counter will be used by the writeback flusher to determine how many
>>> pages to write back when expediting writeback for IOCB_DONTCACHE writes,
>>> without flushing the entire BDI's dirty pages.
>>>
>>> Suggested-by: Jan Kara <jack@suse.cz>
>>> Assisted-by: Claude:claude-opus-4-6
>>
>> Picking up on something we discussed at LSFMM in one of the sessions as
>> an aside rant: I find these AI Assisted-by tags so useless tbh and just
>> pure noise in the git log _especially_ for a core developer like Jeff
>> that I really don't see the point of them and I'm always tempted to just
>> remove the tags when I apply. I have dropped them before because I found
>> them so pointless.
>>
>> Crediting Jan here is the right thing to do and it provides actual value
>> and also just makes sure that a real person who spent time helping out
>> gets visibility in the git history. Why we should extend the same
>> courtesy to automated tooling is really beyond me. Somehow we've become
>> all convinced that these tools require a special status but have spent
>> months arguing about the usefulness of other tags.
> 
> To be clear, Christoph and Ritesh also contributed a lot of review and
> suggestions.
> 
> I was mainly trying to follow this new verbiage in
> Documentation/process/submitting-patches.rst:
> 
> ------------------8<-------------------
> Using Assisted-by:
> ------------------
> If you used any sort of advanced coding tool in the creation of your patch,
> you need to acknowledge that use by adding an Assisted-by tag.  Failure to
> do so may impede the acceptance of your work.  Please see
> Documentation/process/coding-assistants.rst for details regarding the
> acknowledgment of coding assistants.
> ------------------8<-------------------
> 
> If we're demanding this from anyone, then we should demand it from
> everyone. I don't think we want one set of rules for core contributors
> and another set for other folks.
> 
> As to whether we should add them at all -- I don't know. I think it
> really comes down to what we intend to do with this info. I'll play
> devil's advocate for the moment:
> 
> The cost of adding these tags is low. It's just a few extra bits in the
> repo. Maybe this could eventually have historical value?

As we don't really know "how" AI tooling helped. it's pretty useless without a
more detailed description I'm afraid.

OTOH, we want people (in particular not trusted community members) to indicate
that it might all just be unchecked AI output.

Hm.

-- 
Cheers,

David

