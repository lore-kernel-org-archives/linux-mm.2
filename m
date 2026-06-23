Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6850CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 07:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1F66B0088; Tue, 23 Jun 2026 03:38:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68ACE6B008A; Tue, 23 Jun 2026 03:38:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553136B008C; Tue, 23 Jun 2026 03:38:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27E236B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:38:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8280A166E1F
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:38:11 +0000 (UTC)
X-FDA: 84910373982.01.930992E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C4BF140014
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:38:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4Z0q+Kl;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782200289;
	b=TsLFsHujqsI9xKPQ1DCqcH5kWWcVUXFOKFGdxw7Ko0S+cchBEbomIwdY8DTFBUh88gVN6v
	4ypnmtjloM0GANDvUgnwCwV0+1bLpD+sjdRSgaFHCHA/eTV9IKSLbkZZ2CgQ1Pb4fOtynj
	AQXSoVxn5qwnfUfw011NiVzcZ3tEc/M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782200289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FHfEFJ7PVtVF/XkhuqXOqUMkLOWdHxknOWZpt4309kQ=;
	b=UpJoADObNE/jSmwmAapDgKA2DKYe+Iw7Bbj+aFLwzzwVw9XXGgwpRLKP6xvMh5keOPh+yX
	qao52comeimSVbeukEVxzYJ+9B/Ju/7RD/UwlOVxMttE2o6e4aEdk0FapjW3R6N/ufXmwC
	SfZJe6kSIp6/zHfQGVKRfFqI5C/8e4M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4Z0q+Kl;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 48DE96001D;
	Tue, 23 Jun 2026 07:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77B61F000E9;
	Tue, 23 Jun 2026 07:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782200289;
	bh=FHfEFJ7PVtVF/XkhuqXOqUMkLOWdHxknOWZpt4309kQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e4Z0q+Kl8uXqinwgS2MCvdOrSUQfobEN+dGQ0VwVEJRqwENqRMRNSxIK0z4aLduwW
	 O1nvP3uPRGlhsTZpyVnC3iIDyL5BxOUojz+dnCLmgTg1LVWD90CXtdpkFLbcjAhmaF
	 Ja1QMODqgelgU6rd++EwGOT3cx0CoKsMrEBEIenycDvwepB0mrUmx0/CwkeJoJVHjK
	 yqyl4dbTo+LzHcwXzeF8qxIQYG0TLtxiJcz08MUwRf6kBtBPVMKilB4AOe3ZK5Qdzh
	 BvOr0LZpyFqD4K5qmFCQFotkkT/q5pF3F3ZfbxEaZOM6nkvZ+gxvgNWpP/gkOHxzBP
	 tXLfBtqq9Syfw==
Message-ID: <f63df082-914c-4317-be08-e0455d1943a9@kernel.org>
Date: Tue, 23 Jun 2026 09:38:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: page_ext: add count limit to page_ext_iter_next to
 prevent invalid PFN access
To: Zi Yan <ziy@nvidia.com>, Ketan <ketan.kishore@oss.qualcomm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Luiz Capitulino <luizcap@redhat.com>
Cc: kernel@oss.qualcomm.com, stable@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 syzbot@syzkaller.appspotmail.com, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>
References: <20260623-page_ext-v3-1-a89799a5367c@oss.qualcomm.com>
 <DJFYU5ZU3S15.2TM0XSBEOB2EM@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DJFYU5ZU3S15.2TM0XSBEOB2EM@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: zkc5ox69uckpseaeeu834thcsgm8rppo
X-Rspamd-Queue-Id: C4BF140014
X-Rspamd-Server: rspam06
X-HE-Tag: 1782200289-799975
X-HE-Meta: U2FsdGVkX1+Akfo65vRIpCR4uB2tMchAM8qj0xbDGRCNXP4l+T/MDU8S+vm4sz//+fuJAytwSSro7LXoCA+4w9qJmL82HwDmG9usn9fhoOKiSPCQ2BrsFAlA/NrHm2AKQCn3nXsCRZeCOAmoLtkHhx05ipTGTEDM7IIQwkwJrMnlLc6kzReedBcU6L06M1GqE6ewC2YNNNCxJA/nAdyLvXkQyI9DghhWaOzAdUeiCZhxVi/XORqEQU/in2BvZVSQmpy/KxGbsB6VdAlmUHbcg+grkudw+7tE63rJPkCOwm3IrhsN6Ug9UsPabkMDMPihJBlKRX9js1ExJNmxe01qZhAy/6tXtug90kuM1yrw6TBaCIDcRFzGHiR7D81OQLBnjYlpTkzauM2Ncz3+PBQvT2WcSTHl/YNHUfOk2w12/eo3pTCEO5XUTpUvmZq4d/61y3elysILSx5g5wXZo0Ho8yY9XRrpGM9CzpoxXDvY1Ua+nl3t0YbgxPSebhgEAJdi8YqcB1MF6k3Jiwbm0dPxEVMZRoLdpBExbMsu6nLebJktqkssRIX2G5rEyZecStSlPz3gWund4MRqbAV0dwFDNzYsBgmAhhGlVpA9pSnDVosMqXPhwo58P5dEmBOn7eTI/Jj4bxD5HJKRWvbRwjUQyrXCBVuW+Yud05AaSKWzZNfFnmH8r0D2MNjHH2fnccRz0TzTRJfIF15pkVYulVCBDZSxe0uRAAGRR+0K5umykfKsaQGEIMDe3X/O33rEVEZmH5Tf8hBYLjDVumumYTOYKkZy/yXgAU243+iu2lrHj4C/J6tT3qXqr2zrH5o35MRbysxMfa3/cLCyxPzNJ3rA1JcsxEbsqTuWjyoHBx0qOjzw1aONjp8hJtW/AMSL1kF8ccDp4Xu21mQPn3LetHDKZU570ycORFk7BJaTj3wF/96dCwCBrIXKQh0CFLF/yjaDXmN2BiHvmgqi3dBD1J0
 eWT2W6WI
 gDCjfjn3apHMEs4GSqr6khZXCs9iVp8Lm5jWbSTT6yAMxGByZv/1dEjc22BI1vzLIfScilvyJskoA7Yarv0XW0E95PIJat59vOz5EvIAz09dF7No+Fp0P4FBnU0nSsZkC684FZ239MEjws8TyfgG/gtkIyROk1bhwr3T/QsrNR1gcY2BkjJV5slTniVGYxxS8OAs1AXajKzY7P5CC5e9BMSCm97P3mNgDgerKjXmszQvHBz2e37ukViPK/l3h//VvnAks0W8yBnnfinhWFjR//8ynQcA08hjvLErDVjr3PXjsiIKebEV7vqykDkY/Ct69aSV8P/Vl/PZwqYaaT6wl1I3xJYo1Jc01jdiqg0AN0d9bWLU19LlqFhi9lGJyzLLbwFadiN/BOkK1cnsqMxgwb7U+Ky2d1jdu8PyAgVO1Xur4jVxHLhOdBrOSgTYMRuGH/AHaDe8TwHyRnmkBa6pO9g/9xcGyPLQ7U2EgnXa/V33nIVPfy5YCgDUM9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 01:27, Zi Yan wrote:
> On Mon Jun 22, 2026 at 5:18 PM EDT, Ketan wrote:
>> The page_ext iteration API does not validate if the PFN still
>> belongs to a valid section while advancing the iterator. When
>> dynamically adding memory in the hotplug path, it can lead to a
>> NULL pointer dereference during page_ext_lookup at the boundary
>> of the last valid section when iterator count equals __pgcount.
>>
>> The for_each_page_ext() macro calls page_ext_iter_next() as its
>> loop increment. for_each_page_ext() does a
>> "__page_ext = page_ext_iter_next(&__iter)" at the end. This
>> causes page_ext_iter_next() to increment iter->index past
>> __pgcount and call page_ext_lookup(start_pfn + __pgcount).
>> During memory hotplug (online), the PFN at start_pfn + __pgcount
>> may belong to a section that has not yet been initialized,
>> causing page_ext_lookup() to trigger a NULL pointer dereference.
>>
>> [   14.555124][  T846] Call trace:
>> [   14.555125][  T846]  lookup_page_ext+0x6c/0x108 (P)
>> [   14.555127][  T846]  page_ext_lookup+0x30/0x3c
>> [   14.555129][  T846]  __reset_page_owner+0x11c/0x260
>> [   14.571201][  T846]  __free_pages_ok+0x5e8/0x8e0
>> [   14.571204][  T846]  __free_pages_core+0x78/0xf0
>> [   14.571206][  T846]  generic_online_page+0x14/0x24
>> [   14.597782][  T846]  online_pages+0x178/0x30c
>> [   14.597784][  T846]  memory_block_change_state+0x284/0x32c
>> [   14.597787][  T846]  memory_subsys_online+0x4c/0x64
>> [   14.597789][  T846]  device_online+0x88/0xb0
>> [   14.597791][  T846]  online_memory_block+0x30/0x40
>> [   14.597793][  T846]  walk_memory_blocks+0xac/0xe8
>> [   14.597794][  T846]  add_memory_resource+0x280/0x298
>> [   14.656161][  T846]  add_memory+0x60/0x98
>>
>> Move the iteration boundary enforcement inside the iterator
>> functions, so callers cannot inadvertently access beyond the
>> requested range.
>>
>> Fixes: 9039b9096ea2 ("mm: page_owner: use new iteration API")
>> Cc: stable@vger.kernel.org
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Suggested-by: Matthew Wilcox <willy@infradead.org>
>> Signed-off-by: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
>> Tested-by: syzbot@syzkaller.appspotmail.com
> This is probably not needed.

Agreed, we usually don't include this.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

