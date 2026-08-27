Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FB7BC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:49:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108E36B0092; Thu, 27 Aug 2026 12:49:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0C06B0099; Thu, 27 Aug 2026 12:49:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15106B009F; Thu, 27 Aug 2026 12:49:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCD7F6B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:49:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6743014012C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:49:40 +0000 (UTC)
X-FDA: 85147635720.21.7F34300
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9687840002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:49:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kGlA7VxW;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787849378;
	b=CxUXj3ejB3u23s4lfGbPsfangGbQYg+vs8DjPicwi3VugIqlacPyXijvcsSA5ClKGsr4qD
	RnLQWETCVd2bgtvr2tFl9Y9eoEPAFHdb3XGq4h1X78fHl9kWie0bi2mzflLo2yVOiWoLGf
	1xWt6m+XswiM1r0A6FBgDL4NNmC3qsY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kGlA7VxW;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787849378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5cG4iuM1d9Xpr0Ghu/Ar+nS5GiRx98CK/xxd+1xvUA=;
	b=x8RkLvP487/0kwlJOAOr0LHLOJh28+NqpkE7mz4DDlAOIq+2h810iP8ZZm+pZii8IvmVLa
	jH+spMph+aSMZpsv9DmBGah+SguJw2NrHjgyoQ2AGgyPLFg9rxcXITwDd1i3jGc5NdyfVe
	32NCe480SyuxTuxHKj3UywzeDWF1o5w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE32D4011F;
	Thu, 27 Aug 2026 16:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2378D1F000E9;
	Thu, 27 Aug 2026 16:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787849377;
	bh=J5cG4iuM1d9Xpr0Ghu/Ar+nS5GiRx98CK/xxd+1xvUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kGlA7VxWC4H4LrpdVhC9YYAuk4lfkA5dIfmFjIqZEw/WBSOnbU59U/UDlG3KwPCSA
	 91i65tzQN9XBNvbBXurAaKaYXesWTyDaeQ4e73MZAK5G+DKufUOg4THZhWZ73Alq3m
	 tbsdvs6Bd1CqbPjnHNRKgIBnjS6Y1dQDikz8Vk1Vo3PFbrOThoqf3Pum/+wRo460Yt
	 Xf1QHoE3boTYnZG9s5GSlBiPYkk8xCbw7jfmYp1ltr/qg5dh5Uh5bPDhvk2bCgJKzd
	 hjIIpnIMUmvxP1fOa2gH1XXK543sCa5MsU2DWLtKzKt7B1TVGz2leERxwjOqlWXA8i
	 ODyD7h1p1IU3Q==
Message-ID: <c9c11ca3-8f78-4086-8549-5e99a4d79feb@kernel.org>
Date: Thu, 27 Aug 2026 18:49:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: reject unsupported kmalloc sizes
To: Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 syzbot+805630f1453e490427fa@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20260817-limit_kmalloc_size-v1-1-5bef487701cc@nvidia.com>
 <82f138f5-11d4-4839-94a3-c226fd982715@kernel.org>
 <ao9dPUpHxP5uOOcw@MacBook-Air.tail10959e.ts.net>
 <DKZ7J9HNUDR6.BP9KG5Q7HYMJ@nvidia.com>
 <c4684212-f44a-4aff-a02d-f3f26095ebc1@kernel.org>
 <DKZUH9SFMP6H.1ZMKA92IHQLG2@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <DKZUH9SFMP6H.1ZMKA92IHQLG2@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9687840002
X-Stat-Signature: nrjstx8y15mzferrgd1rzab7xuca9nq9
X-HE-Tag: 1787849378-411583
X-HE-Meta: U2FsdGVkX19HkKe+vm+XWLoraV2JpDUCquauMccFqr8jllBd8f/io5ZlbdQXfbMrRidlwOTlxpPsZAnRCB+8QucbVqvnFKCR/IIDGmQcb8gTey+1NtQEOp1RQCTMoJli/aZFYhCOTCkCgyadOiUhlVBLCWIztZK1K0PgHbP4eTUTROixzT4hehb5kIeqlflFfdeqKdoRX86TntginyATwVJFtwB57/kDeN2NUCW5tbZ7hhe+XkyvtYC1i/YjsvxwpoWlKrofbckfFIlJi0Ow5FT4NvoLjuybyJ6xovdPfwDHsJoD7NPpsYQpcYOeETvKbtMAbHcW5JFwendNnyLBJj3nEb3nUnkcUTjN6b4EJoiTqNex0juwfbOadxIBg2w8z8Xv1lMYfxyfumDpRNtIYffOqulPE5bs6HNYteAnbsDFEBgFYaaphy81inl3VVzuGEtKwJqGgod7yI75hbNvIFRuuPXKnIV3IvR4yNZwkpFUtWGAV67aG+G4wGk+nL63HxJvYTNdnbtaTRlZXzzu4X9YfRJcBxHJBou1jORvZlXqH4i6JayC4eDF+9KL7oJ4yMVde6WYLe2nOPqnIy630BrMLVA3BtsY1fWuCyIlN2lZDRlC9YXA0rNc24eNR2zVGAD5PhQmC9LQA4h4gwpeLeGi4xvZJFyu6s1SGHgXa+BBXbz7W4V12/5Kxs+hIufcCLVMHwV0DGD3XK9sdmyNH2OG1zMeCJzqruW8pJP+JHwOa6baFBnc8joLiw9CRm8r+i4EjTsbPatDzLwrz3tGNg17IWOKx9Zk0iIcI+2BaU6pOrgxaoYGMYqVNe+eCh1EedoEqXOBDEru/jxJJz0mIBWewnYyV6euNx5egggNmvvuDDtHXyiYItAkoByiUpJEQoPHHG3VCA6jPxb+3MDm68yiN0jlDFhkIVPIy2KGQZZb01ndhuffqZ2Fq+rNoypDNFDVerOcDBCvTtb9nHu
 LlBsVPqQ
 wtORAAfRGc62E51BKtRwgWf/hFBwMsxvkIH5alAUvH6oCq8eMJyCwFQXFtzKTuFtG4GbEbxWXs7ccHeC21BTPKNcp31UnztzgYvFcaE9aOAkoqw00Zoog/uJBV7F7nVdj0ueStbSggAy3mBKRBJ0nX4g93C+FDLYq+pgC9FW62uUeD5JOoqtm9vFv3xKmelIt66LifoLdgGJPi9u0OKHbOjO3z7cIrSDIHm5XK2N8RfRQVtrGXYBdsKuCLP+csPzlSOrohopn4LeNp/pzXHOKDEZ9jCnQyNyIVz/8K8lWL5Ja9yzEWfXlENiI6xLCfJoapaMvndoqu1DTYbQX8qbEZrXoIFYwjelWEiOTRvlqQD7sPgm/kI8iTtEI+zxrJIZxwe1zyZFjObXc9oM2Glx5byY+3sORLN3wC+2/mgv7aQEElKIiVSI5+Vj5if4BgUlYtLxrhRthLETO/5v/Cv4QMcJv3jr3+bZstlwtPuA77LwnLfexhDrdBpAhvpQdmsrTdfvDInJmFJQxLn8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 17:51, Zi Yan wrote:
> On Thu Aug 27, 2026 at 3:47 AM EDT, Vlastimil Babka (SUSE) wrote:
>> On 8/26/26 11:52 PM, Zi Yan wrote:
>>> On Wed Aug 26, 2026 at 5:47 PM EDT, Harry Yoo wrote:
>>>> On Wed, Aug 26, 2026 at 11:28:12AM +0000, Vlastimil Babka (SUSE) wrote:
>>>>> On 8/17/26 22:40, Zi Yan wrote:
>>>>>> kmalloc is used to allocate physically contiguous memory for kernel
>>>>>> allocations. For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc uses
>>>>>> the page allocator and can only support up to KMALLOC_MAX_SIZE. For request
>>>>>> sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a WARN
>>>>>> because kmalloc allocates an order greater than MAX_PAGE_ORDER. Systems
>>>>>> with panic_on_warn=1 crash because of this WARN. Fix it by rejecting any
>>>>>> kmalloc size bigger than KMALLOC_MAX_SIZE.
>>>>>>
>>>>>> Fixes: aadb4bc4a1f9 ("SLUB: direct pass through of page size or higher kmalloc requests")
>>>>>> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
>>>>>> Closes: https://lore.kernel.org/all/6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com/
>>>>>> Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
>>>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>>>> Cc: stable@vger.kernel.org
>>>>>> ---
>>>>>> It fixes a page allocator warning (order > MAX_PAGE_ORDER) when gadgetfs
>>>>>> requests excessively large memory from kmalloc. Instead of adding
>>>>>> __GFP_NOWARN to suppress the warning, as was done for usbfs[1], change
>>>>>> kmalloc to return NULL without a warning for this specific issue.
>>>>>>
>>>>>> [1] commit 4f2629ea67e72 ("USB: usbfs: Don't WARN about excessively large memory allocations")
>>>>>
>>>>> So I checked and for kvmalloc() we have in __kvmalloc_node_noprof()
>>>>>
>>>>>         /* Don't even allow crazy sizes */
>>>>>         if (unlikely(size > INT_MAX)) {
>>>>>                 WARN_ON_ONCE(!(flags & __GFP_NOWARN));
>>>>>                 return NULL;
>>>>>         }
>>>>>
>>>>> This comes from Linus in commit 7661809d493b4. I'd do the same thing here
>>>>> then.
>>>>
>>>> But the purpose of this patch is to avoid the warning in the page
>>>> allocator. Should we fix this in the caller (gadgetfs) then? 
>>> 
>>> It is fixed by: https://lore.kernel.org/all/20260820223719.A4A3C1F000E9@smtp.kernel.org/
>>> 
>>> Please disregard this patch, but we can keep the discussion going.
>>
>> I still think this patch has some value if done as proposed above. Yes
>> in practice it will just replace the page allocator's warning with a
>> different warning, but IMHO it's "nicer" if kmalloc() sanitizes its own
> 
> And SLAB maintainers will be Cc'd. :)

For some people it doesn't matter if it's SLAB or PAGE ALLOCATOR :D

>> requests to the page allocator, using the KMALLOC_MAX_SIZE value.
> 
> Like this? Or the exact pattern as kvmalloc() is preferred?

LGTM. Should return NULL even with __GFP_NOWARN or if the warning has fired
and won't again, and AFAICS this does.

The kvmalloc() pattern predates WARN_ON_ONCE_GFP addition, I think.

> diff --git a/mm/slub.c b/mm/slub.c
> index 0337e60db5ace..b562f2a6fbbee 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5263,7 +5263,12 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
>  {
>  	struct page *page;
>  	void *ptr = NULL;
> -	unsigned int order = get_order(size);
> +	unsigned int order;
> +
> +	if (WARN_ON_ONCE_GFP(size > KMALLOC_MAX_SIZE, flags))
> +		return NULL;
> +
> +	order = get_order(size);
>  
>  	if (unlikely(flags & GFP_SLAB_BUG_MASK))
>  		flags = kmalloc_fix_flags(flags);
> 
> 


