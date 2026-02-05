Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8ED9EC1E8F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B046B0005; Thu,  5 Feb 2026 06:12:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18EFD6B0092; Thu,  5 Feb 2026 06:12:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 070316B009D; Thu,  5 Feb 2026 06:12:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E74296B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:12:37 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80DCEB982F
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:12:37 +0000 (UTC)
X-FDA: 84410139954.24.D33F0B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A145B40006
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:12:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UmDoQsAt;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770289955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vB2XvmI8xOEuZDhqJZdQ0E5t6e2qbdSL+RHr7KPNIbY=;
	b=3Z+6TknOXzUZX7D3gySR/SmOO2nPp2wPV9qaNBJGSsCHu8vN5ismRn85NXB7w+OhUIb6Do
	kq6um7oTvXLLDrN5zTJ17JHk8neQWU6WSUltyYFY3X49H5TxcuWVhoHJ302Y8a5xfIy5q8
	5bo+WhyMYNQmSiot3IYtUvPEcrznfIo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770289955; a=rsa-sha256;
	cv=none;
	b=KiYYy/X47GBHkX0EfBiKn8htK7zGhjUebP5uJNKLK4oaMPTtnhdOQ+I2NvzdrAwBl1PpPW
	TRlHj25DS7ZYJS/Tr20+vxH4o8TVJLGADP3QpJRTl0+XfdWXaC8ijOzJKVGhfbzX7xPl7b
	x5EMn+mLFlsIYKLRIkSwnHFbzXku1tM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UmDoQsAt;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C802423BC;
	Thu,  5 Feb 2026 11:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF89C4CEF7;
	Thu,  5 Feb 2026 11:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770289954;
	bh=DRKzfNoJqRPu3fLFtkrPmjyMsCFY30DIw22pJGlhfVw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UmDoQsAtWs6UOJMbYx+KvrIcnWssO2xGgEwBlBNl/nOYaPTdejsr/Ji2mlyeT5QiR
	 aTjXYsgJwdQjTg7aauyPA36l746IQMkLdITA4glBXYxIjb/jNrd+ilLvpu+fegqzEe
	 DJOmP1FVp6Wfj6DftOLGPj2Je1vVQ1cieTfSCN0JD12c3bwspxzti7w2XzD7s4w9fm
	 1xFtz22WeWjQWlP5pS/+pnMcLugJGU58Yl8/Mwgtv0uOXwtRCdVbQ8btsIiYBF1o6y
	 9evpvcQ8kBRHP6keK2+OVybdlzxeI7d7JMlx8tv/OffSOm/8lXpsxLfmv0nRf3zUEI
	 /mvP4w+w2TgUw==
Message-ID: <2f908340-a983-42c7-bb59-2d6f3a80c834@kernel.org>
Date: Thu, 5 Feb 2026 12:12:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Carlos Llamas <cmllamas@google.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
 <d3dca137-2e4c-4a1a-bdec-63cc2477bfda@kernel.org>
 <aYR5J0ip2MdD3nMP@google.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYR5J0ip2MdD3nMP@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A145B40006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: pw8f89cngszm9hjsajfcy5h1d3dcmpne
X-HE-Tag: 1770289955-212023
X-HE-Meta: U2FsdGVkX1+u52lqIY93w+j0VfxaxN5OK8kh1vii35uLazwWYXDeiJk9WXBASsfwnV6I6jVVgPt9Z4EjIA6tGP0/uVWJtYXb9imrNvymRDSZkdquFbmd1YB4znkilwm6XWRZxR6wP/jBU6Z6jpnZFySY7rw7SuJekLnhQ7fsX+9SCwYeI1rzVLvtHykZUkwyGy1ctQShtBXQG9/SFxBTWanul44mXKXnmEnJ3KAbs5l5B64KCmGxIx7rQsdoXLDqadsTsXEWg83N3w9L4eCbzBUFk8vLzNes6YKVRkm61P5VDETMP1FuajrUxGLAdBZ58cziiiJLr/S2zwQeJ0PmY7yx3RgiqZUBrc+k2IIn0QCV97wWkwwxqqmhNzVqKHTNFyKymN4UqIY9bi9kE6biWEEVSOT+M4QIPRmTHJeWblNgslWsNRJ8mJv+tBZMj6yCX7Fbq/tN9Kd2zsU71CGiw0ZnIqX2UWHPlugtQ6UcszoHwwUZRGhxhVo9UWQ3ifCTERZtu+7v3kz6J7ndaGeP1LojFqGeykKuQIw/+Dsth7zMBAkcu9tvR5o//t65wXVu/Ld7T5gOqNL0aK/veTlFohEWN831fQUXMLxfR0pFlFcPMJTtvKqS1rmka/hZmFo84YjxlQCw6VWYr+WUh4ViwVoAjrgSxDh8DGSfQXNSqjbajq8OSNDEEfojGO0gL+NbSfyuywrmbmt2ddZXQEzOk4YdAfDY50FYEzs8KAEOvCwasFDN9453UPqO6a7Up4lxJYenhFLBJYEpmp9p+O21qAh7NOs9Tz3woTBs0sDuvqbTC9z6V10rXv55MzDs1Vl12k5USIew3zfR+iRvHc7m7lpbeuzwN1VZjxqziPgCe8SXlqmHcxvpEAcrPH0JJ7F+d89jR2T3SkTqZkXnxFo9AXp6MSMR1naORXnMGDkyb2A3VrIxtpThI3kcGFH/pI8rE4gkmKOho//UKCMoQ5X
 qXw7Ew/g
 MCUfHqwXUOgl/W5VAvkxVwLQIhPqQCc+S6gTJpLvrg5wsNZRmN16h2L38bwwzxrRDRfBxWnpYxK0vZhFxMkv9+I0KjcBIxFZPkpmA0Mk8PXtQzryXR7iNa9dR2hOyIHujxJDzwczYAwxBDrEgP+2J1mEIbeBC388JHAddBrnXgGGdlTHgumuBUFtVAep9SQdXEXeeRYDUg5uAyMWwVenm2JEKFQrqNxImrAvRi8FykVVwXVyczgSO7FSi5FWvVfVmwvDx51rrA8WqjEvU3ertuhoo1TIqGa+sTkdcLcDq7wdiiBmhhC70aHbDpIeNhoM59TrBWLX8ITydLgDVze915HR8FIgz2RzN5ermRkDHMljcuu31fcHduy7TD10pLIHA/4eMR6SU5qSwR988Ku1AbBhzwdeQuSftvjoUqYvnNAnYxVuaFBgH+0JiYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 12:04, Alice Ryhl wrote:
> On Thu, Feb 05, 2026 at 11:59:47AM +0100, David Hildenbrand (arm) wrote:
>> On 2/5/26 11:51, Alice Ryhl wrote:
>>> These are the functions needed by Binder's shrinker.
>>>
>>> Binder uses zap_page_range_single in the shrinker path to remove an
>>> unused page from the mmap'd region. Note that pages are only removed
>>> from the mmap'd region lazily when shrinker asks for it.
>>>
>>> Binder uses list_lru_add/del to keep track of the shrinker lru list, and
>>> it can't use _obj because the list head is not stored inline in the page
>>> actually being lru freed, so page_to_nid(virt_to_page(item)) on the list
>>> head computes the nid of the wrong page.
>>>
>>> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>>> ---
>>>    mm/list_lru.c | 2 ++
>>>    mm/memory.c   | 1 +
>>>    2 files changed, 3 insertions(+)
>>>
>>> diff --git a/mm/list_lru.c b/mm/list_lru.c
>>> index ec48b5dadf519a5296ac14cda035c067f9e448f8..bf95d73c9815548a19db6345f856cee9baad22e3 100644
>>> --- a/mm/list_lru.c
>>> +++ b/mm/list_lru.c
>>> @@ -179,6 +179,7 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
>>>    	unlock_list_lru(l, false);
>>>    	return false;
>>>    }
>>> +EXPORT_SYMBOL_GPL(list_lru_add);
>>>    bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
>>>    {
>>> @@ -216,6 +217,7 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
>>>    	unlock_list_lru(l, false);
>>>    	return false;
>>>    }
>>> +EXPORT_SYMBOL_GPL(list_lru_del);
>>>    bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
>>>    {
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index da360a6eb8a48e29293430d0c577fb4b6ec58099..64083ace239a2caf58e1645dd5d91a41d61492c4 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -2168,6 +2168,7 @@ void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
>>>    	zap_page_range_single_batched(&tlb, vma, address, size, details);
>>>    	tlb_finish_mmu(&tlb);
>>>    }
>>> +EXPORT_SYMBOL(zap_page_range_single);
>>
>> Why not EXPORT_SYMBOL_GPL?
> 
> I just tried to match other symbols in the same file.

We were probably a bit too sloppy with some of these in the past. But:

davhil01@e142025:~/git/linux$ grep -c "EXPORT_SYMBOL(" mm/memory.c
12
davhil01@e142025:~/git/linux$ grep -c "EXPORT_SYMBOL_GPL(" mm/memory.c
10

So just go with EXPORT_SYMBOL_GPL unless there is a good reason why not.

-- 
Cheers,

David

