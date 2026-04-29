Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D8F6FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFCF26B008C; Wed, 29 Apr 2026 09:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD47B6B0092; Wed, 29 Apr 2026 09:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA486B0093; Wed, 29 Apr 2026 09:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE8246B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:04:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 861A11A0232
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:04:24 +0000 (UTC)
X-FDA: 84711612048.29.7581991
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 659D4A0008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:04:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lOxHuT/f";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777467862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bNyYaeU5wOOiTh3uKa8V2P4PRECYRnymYA3KnRii+2g=;
	b=D8fG8w3aeHXAD/zPX0Kt+KYemGl1K17CzqG0293C8oFx7QWLYoXR5BTzKQDbYvFQm5hxSF
	lUZXNGsrKp++wzF3tKBaqidYe4DBqtFXgToyxxqL31aGj0PRpPSy+63du+UFF35IYBbkao
	A1UAAHBJZPRAO+VKvpfVNC6O0YfBO4s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lOxHuT/f";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777467862; a=rsa-sha256;
	cv=none;
	b=VrL5pnA8v8nuMXeaEUf+ENxZ04jOGR2xur83vaQ1EywabIJNVxv8GjxwnORAknNVxN+TD0
	vOnmdx6XGqAKpvl1CBpFpk+1eSf2XMNovOunmfs/9hXUzo83b2MpVfVk0JlAvTxcK/lvYr
	kLRl8okhFFqhj4F49/t4Mkq51bA13cE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23BE040824;
	Wed, 29 Apr 2026 13:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1D1C19425;
	Wed, 29 Apr 2026 13:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777467861;
	bh=JKme6JBRrN0TnxQE5dLJVF61YEFWB4vBnH5tddF11mk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lOxHuT/fXVRXH3dDVYllN2Vjqim9hhG3/0+F4jv7LBRnW+GJhaKOOOYxTlsOOTMW6
	 8JX6BCEYmIS7I5ntuj9FiiQrTsqrYx3Kph1zHoEQPTxqqSbMzMuC7iRnqpiXPVnfE/
	 9swRZYEz5Dg0e4wriPHLvhemuTkpGmK0NkGBJCdVk0bcaQ9FTl+4cyyw8IP178Jlys
	 dFjckx9NOzlosfwSeP6EzbFlrv6220ndi9sdE1CM5EoszB+q0ODLkGDmthFko90bhi
	 aMHpSN+uddAbMEfL8XiSB9AM/q4Gel3KvREH/GR3bjtkh7odbYicXzHErF977wji47
	 cFwVtITuuqoBA==
Message-ID: <4ff3d230-d48d-4a9c-aac8-30a7b80c4775@kernel.org>
Date: Wed, 29 Apr 2026 15:04:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/3] mm: Free contiguous order-0 pages efficiently
To: Ryan Roberts <ryan.roberts@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, david.hildenbrand@arm.com
References: <20260401101634.2868165-1-usama.anjum@arm.com>
 <20260429103326.GA1743@cmpxchg.org>
 <20260429050430.d86f01dbe731edc9fa932add@linux-foundation.org>
 <9834200a-492c-4705-a2b2-e76cc0ba5392@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9834200a-492c-4705-a2b2-e76cc0ba5392@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 659D4A0008
X-Rspamd-Server: rspam06
X-Stat-Signature: i9fragxmkj9sdhr7r3n57w4uts3qmj4d
X-HE-Tag: 1777467862-437007
X-HE-Meta: U2FsdGVkX18PdBeYoMjnm2j3GIrqnpQw4rwVr93hY6qhoZoLd5y+vo/PPIkch24mp0iqOnytR4Asrv1l7EIo25YxzVXyImp7asUdhA+vRzonZ+by7ZhrwmK/eb0orX+fWqkKEwJ1m/1ZXxDVRHaAEOo0bRPB6ePRySJPzhLGxYRJOPyfcGNCxr4BmJOcHy8i0KZloaO4akS2fvgZn/6W+I8CBSs+1Jn52EO1ZB7luhrbgdVznWq8+r3ouLJtksQJG7vXYUTySazpw1Q+3+10OP5/vOdJ2n4xz/VR5P5CLGglCVQ4A3G7wcmat3O53IaSHEBio75qKiFNSWqHq9XDPswWNQeCS4oWlC2TsE/+VUReBb6AZ6Y9ZwYGpPUQCdW0VLT4KVjxP/c9rySyJCkvpeauuI9leQnNVBwWcO6vn1SgxxtNxZIFLa8HnaPxlAxzQz4jsMfp8+SsrCRwB0g4bJWpB43BoFiOBte0X1N6o5gYIC+puG9i3KrjisGygCj5ifN+8CqaFB1uHvt6qU3gwYXmUp7u/9l3j1/QmBxRNf/ft4kzZG++X6z/UET6bPGGJBCQRVw3GP7xshkS5rl6daqaAUDbEYizcQ5dkM0saP9qBpCaJKZmEWiz+y7MN8ZWEIflUjmr61kwNJgQBTP9lVLZh7kETaPf1PY+JT/FluFBQC5PR2vsLqxg1Iz7HbX7ex7RoUngPNWu68snAhfjymiFTNiRR+TXu3eJ7qX/n311GGAP0MXMxrBgzJEwV2jdjcAIEc4GlcOzWFQGdo4Si1NOLGuAdXFBf+VoF8iU4gyZ+sFbfxqBGBXmszAG2TLipoE1C60lENVvEafVk15ScVX8O4MOW2qLsk6rNob/zojjStrk16Aang2H4kfADoJWCmZ8GRW13e/wOAGqJ9fh+nTWeU9dtICzfRb+L1/vo1iXHm64T5qRPi8ID3yEz8N1Pjys+iet0eJew+m5SN7
 UmbSH88f
 1AFyIYCjJmIhTCbTIO8Nt9p3j2gM7HQqaqnj9ZvnnHiJQp12MZAeIzqbwXboHF575lFVPLc8BQh1j2FPWL3c/A6P8Kk9a5XjrMaFbW3cnll00md/ZUGVwJDrX60XMMJZpfsEiLZ96ZEbGeeDDfyQrjWs+iBF0npD9uQ/Te8yPVWklIzuztdeQppyQdjtlyyT3Jp//pjp8MofJMpAinKOAvA6Tnyo7x3TXks05YqTCJhzVv9ln3TeRl5nKcGq/w7/Xk2K2Kz5p6ppfHtcqE07kFRHUR5eiR0mriULwGgrrSfrIyj124fwyFRtpYILZYAMZhOCvRU6rRnADQCd7X2390AZDCpo1PbbdkFhcvtm+iMuv3E0KaqYrCvynomNdDk7KHTOi0TeHe2yFNO8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 14:31, Ryan Roberts wrote:
> On 29/04/2026 13:04, Andrew Morton wrote:
>> On Wed, 29 Apr 2026 06:33:26 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
>>
>>>
>>> I think we should revert the original patch.
>>>
>>> The premise is that we can save some allocator calls by requesting
>>> higher orders and splitting them up into singles. This is a frivolous
>>> and short-sighted use of a very coveted and expensive resource.
> 
> I'm not sure it's that simple. First off, vmalloc has preferred to allocate high
> order pages for quite a while, it's just that the patch you're referring to
> makes it try even harder. So reverting the patch doesn't completely revert the
> behaviour, it just reduces it.
> 
> Performance benefits because those high order pages are mapped appropriately in
> the page table - i.e. 1G PUD, 2M PMD, (or 64K CONTPTE on arm64). So it's not
> solely about the number of cycles spent in the allocator; the HW is used more
> efficiently. vmalloc only splits to order-0 for the benefit of the caller,
> because there are some places that assume they can access each returned struct page.
> 
> And all the order-0 pages of the original high order page are freed at the same
> time, so it's not like we are destroying the contiguous resource; it remains
> intact for the next user (well, ignoring that some will be freed to the pcpu
> list - this series solves that wrinkle). I've heard it argued that this approach
> is actually _better_ for conserving contiguous blocks because it's keeping the
> lifetime of all the constituent pages bound together and reducing fragmentation.
> I've never seen any data though...

Right, that's what Willy has said: allocating+freeing larger blocks, especially
for unmovable data, reduces fragmentation as a whole. And that theory makes
sense for me in the context here.

I don't think we want to revert the original patch.

-- 
Cheers,

David

