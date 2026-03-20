Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CB87108B902
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613EF6B0088; Fri, 20 Mar 2026 07:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EB5F6B0089; Fri, 20 Mar 2026 07:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527FA6B008A; Fri, 20 Mar 2026 07:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 40B9D6B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:44:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD04DC03A3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:44:18 +0000 (UTC)
X-FDA: 84566258196.02.2646888
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 10E1540008
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:44:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UMUiL8XO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774007057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VInuQRz6bDz6QiiP+b8iLibdfY/itvcGF0OqC+T9MB4=;
	b=fbtlDq5b501QkOqiAI7H5w2H0eEi5S62Hj86tl3vuvRnQ1fJh6PlM1hr/buXKGf0B+qTaJ
	NjvVUXVLu3diPK1phcsHRFCB7s4shuMgFpRN4rI8CStEojdXLwnnsEMuYfUcksiMebIL7f
	SUGaTAQipQtFo1Cpd8mSNbIwcu8f9fE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UMUiL8XO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774007057; a=rsa-sha256;
	cv=none;
	b=QDECiEuDVL83xN1pQZYsqOs1vCEv5DpgY3aLTmgMJZfAxbiaLGYthyA65nGszU4kaLDERH
	c/LdDC04BlvsR/cXRNee5ppKGJwDr59kDf9C017Nvgmucnr+BP8UHDNpx0jFpFNvox9RvQ
	Z6zPJxta98zETcQxhlcAmQsC7DIwXWQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F262409DD;
	Fri, 20 Mar 2026 11:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E44FC4CEF7;
	Fri, 20 Mar 2026 11:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774007055;
	bh=JQp3MSL9XfD0fiFy9TC3daF4dHVhQRTOrCBQIwwJJx0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UMUiL8XOeNo4sSgJwu+60ObvNWeiICBECIrjgPTKMq5B0fWiwyuArWSCZxqV23wpK
	 AdMsl5CjPm/bYBO4RAK+W33xOaonvEtlPPR749qUm4qp/J/2GMJzZcGO//ueMfE+NY
	 W39O65i0rHBupEq6gI1TUCNux9gKEin4wSuq+e7o8vcsnei0mVoHG0xrx9ZgF+JT34
	 gNyqg6inr/OdphAYPSvOPb6iH42+avHPw57sxX/VgrUiqiqsiEUT9LQJp+nZUZfwtF
	 e1WkSljQ9yfisqU2aiyZbvd95sd2Uw4dsXyRO89weitSlmy4tceTmd9F6xNW/RKcGn
	 AfEddfSrKk2NA==
Message-ID: <b48275da-a3cb-4621-82fa-c2a83f1e24b5@kernel.org>
Date: Fri, 20 Mar 2026 12:44:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm: introduce a new page type for page pool in page
 type
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
 Jakub Kicinski <kuba@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Toke Hoiland Jorgensen <toke@redhat.com>, linux-kernel@vger.kernel.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org,
 daniel@iogearbox.net, davem@davemloft.net, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
 brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com,
 dtatulea@nvidia.com, Daniel Dao <dqminh@cloudflare.com>,
 kernel-team <kernel-team@cloudflare.com>
References: <20260316222901.GA59948@system.software.com>
 <20260316223113.20097-1-byungchul@sk.com>
 <ebd00055-d4aa-4612-8bf3-ef0a308512f8@kernel.org>
 <20260318020223.GA69943@system.software.com>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <20260318020223.GA69943@system.software.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 10E1540008
X-Stat-Signature: 5spt7sdg3po44a5stsxhyuc5ja1fk5t6
X-Rspam-User: 
X-HE-Tag: 1774007056-100866
X-HE-Meta: U2FsdGVkX1//0D5G0xxBX2CBQxwS+WEbxrgwTlJ59N5hDMuefoYPltCr7gCsl8OMGU4MZt8T5pdYPCcojtNJwqxfzQrDqfqOoQMk6foWcFBcrtNg9IGzjD5BBeMNA2w50QrdgywJh9EcLsEcYpfHOY5ASQDvxDM4VZlcyzn62u2FwxBohEpP/yYUWxIvVMKhvKG6nFFs5gZw4dKpq5vlx2OfIBKJsWWShkmvaJPLJe4CX7g0UMdKZL1ca/xvycCWgEc0z0gVIEfrbeYluyNLI8g8p+tPs7iAYSdWR+VO22qJlpYV6q4qkBHNVXzmKufRltFoGYyqvnIdd/MA978Rl7s3REZs874N33YA71MYB89Cgp050zKgC9JSMrUMrxtFgmOixL4huD7gxTCpR6iPm9DXoSwJv6k8Gqmw0S3h/pvzAi88CEDdx2NUiIkvZW909iqtHpZJRP6SPoOBC1PLVsNEDFLgD//Pg9Kq4ZFwXj5CMjR0DtZHNB2eN3ncg9YkjClqDO6PKJr9ytWa4Yp+QhY289Wn27OU8QtLA6HcqYF8wfUkPFfI8wWODqswQMjRFPk0EN3y+71Sol2eSoSO9puStW/D5senSsmfowyktzNGBKsvVf1VtEHDVrfN2ewtoh1l9T1JJitKIAMgat1Ab9W04UHJHhpGdN6iFAACuEYOEAb4/KiWRvnRwXZUBrSkDOTgVSRyKqnegvEuwiQcO3RBRwCED0gFCS4ISLF787qBPdZ3bRmKPZ94Z4f/lLc+rM3I67jnOU6/X8tcLUCSoKMT1AhsCx0M0+szgZ4EfbVrn4TetUL0NqPcnjLWoqx4l57ZEGMx368gY/FH2sirM8SpjmeHzk05/a3ktQQPRTEXoeASiJBEbWKFNMibOANkUwsVRqmykZkw7pzG7p7gZB59Z5jG5ORNYH3TLlDwdcJjJ2JGavokcXX28bulVGaB071feclYLBaV0BG6pyS
 MOYCt0G3
 fC56Ma+sNNbKmgOTL56hnFpw+BpvNoKERhadif2wq5ICm5b547WbpGkDljCuzH+YY+DUlS0imV8kcWrOV6T1dN78lFrXY/kmO/Wj82TibyU3hig+7nJIjz+kj9vk4o7vT6a/7fAKGaHDpPXh01OjDhkUj3u7UiiNHiblMndrGksNS5HOTYFYC9AbNGRO1x4D0NC+FpL+vsb/5h3VeWL9ybU/8vBENqZ9o7j59x5GeUceZ2og97gOoGzSipVyT2wq5XBT9O7KsejNnfBqcPjTuWQhL1E7/epRrLPbV0LdKend/AH6Tg317LRuT/gxKimQKR4ypM5wgUiQzCM0+EADvhHBXlAIpqkouxbaFYHgu/vwvBBDPJUGlLjRS11YJ91oCYqPWZjDERoXhDT3tjtzWHUHuonhrv7iIFi1NZn1e6Z+NJFC7Ibftm+w0Xy2Xqm754KYKdK+p0HBLOifNmzkuPz1z+0u1p21+gTZWWJdXiektZWtVE7INyjhigrzIH40uFU7XcykVgxtAchUTCyF4dvBMMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/03/2026 03.02, Byungchul Park wrote:
> On Tue, Mar 17, 2026 at 10:20:08AM +0100, Jesper Dangaard Brouer wrote:
>> On 16/03/2026 23.31, Byungchul Park wrote:
>>> Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
>>> determine if a page belongs to a page pool.  However, with the planned
>>> removal of @pp_magic, we should instead leverage the page_type in struct
>>> page, such as PGTY_netpp, for this purpose.
>>>
>>> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
>>> and __ClearPageNetpp() instead, and remove the existing APIs accessing
>>> @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
>>> netmem_clear_pp_magic().
>>>
>>> Plus, add @page_type to struct net_iov at the same offset as struct page
>>> so as to use the page_type APIs for struct net_iov as well.  While at it,
>>> reorder @type and @owner in struct net_iov to avoid a hole and
>>> increasing the struct size.
>>>
>>> This work was inspired by the following link:
>>>
>>>     https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
>>>
>>> While at it, move the sanity check for page pool to on the free path.
>>>
>> [...]
>> see below
>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index 9f2fe46ff69a1..ee81f5c67c18f 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -1044,7 +1044,6 @@ static inline bool page_expected_state(struct page *page,
>>>    #ifdef CONFIG_MEMCG
>>>                        page->memcg_data |
>>>    #endif
>>> -                     page_pool_page_is_pp(page) |
>>>                        (page->flags.f & check_flags)))
>>>                return false;
>>>
>>> @@ -1071,8 +1070,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
>>>        if (unlikely(page->memcg_data))
>>>                bad_reason = "page still charged to cgroup";
>>>    #endif
>>> -     if (unlikely(page_pool_page_is_pp(page)))
>>> -             bad_reason = "page_pool leak";
>>>        return bad_reason;
>>>    }
>>>
>>> @@ -1381,9 +1378,17 @@ __always_inline bool __free_pages_prepare(struct page *page,
>>>                mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>>>                folio->mapping = NULL;
>>>        }
>>> -     if (unlikely(page_has_type(page)))
>>> +     if (unlikely(page_has_type(page))) {
>>> +             /* networking expects to clear its page type before releasing */
>>> +             if (is_check_pages_enabled()) {
>>> +                     if (unlikely(PageNetpp(page))) {
>>> +                             bad_page(page, "page_pool leak");
>>> +                             return false;
>>> +                     }
>>> +             }
>>>                /* Reset the page_type (which overlays _mapcount) */
>>>                page->page_type = UINT_MAX;
>>> +     }
>>
>> I need some opinions here.  When CONFIG_DEBUG_VM is enabled we get help
>> finding (hard to find) page_pool leaks and mark the page as bad.
>>
>> When CONFIG_DEBUG_VM is disabled we silently "allow" leaking.
>> Should we handle this more gracefully here? (release pp resources)
>>
>> Allowing the page to be reused at this point, when a page_pool instance
>> is known to track life-time and (likely) have the page DMA mapped, seems
>> problematic to me.  Code only clears page->page_type, but IIRC Toke
>> added DMA tracking in other fields (plus xarray internally).
>>
>> I was going to suggest to simply re-export page_pool_release_page() that
>> was hidden by 535b9c61bdef ("net: page_pool: hide
>> page_pool_release_page()"), but that functionality was lost in
>> 07e0c7d3179d ("net: page_pool: merge page_pool_release_page() with
>> page_pool_return_page()"). (Cc Jakub/Kuba for that choice).
>> Simply page_pool_release_page(page->pp, page).
>>
>> Opinions?
> 
> This is not an issue related to this patch but it's worth discussing. :)
> 

Yes, looking at existing code, you are actually keeping the same
problematic semantics of freeing a page that is still tracked by a
page_pool (DMA-mapped and life-time tracked), unless CONFIG_DEBUG_VM is
enabled.  You code change just makes this more clear that this is the case.

In that sense this patch is correct and can be applied.
Let me clearly ACK this patch.

Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>


> Not only page pool state but any bad states checks are also skipped with
> is_check_pages_enabled() off, which means they are going to be
> suppressed with the off.
> 

Sadly yes. I'm mostly familiar with the page_pool, and I can say that
this isn't a good situation.  Like Dragos said [1] it would be better to
just leak to it.  Dragos gave a talk[2] on how to find these leaked
pages, if we let them stay leaked.


  [1] https://lore.kernel.org/all/20260319163109.58511b70@kernel.org/
  [2] 
https://netdevconf.info/0x19/sessions/tutorial/diagnosing-page-pool-leaks.html


> It is necessary to first clarify whether the action was intentional or
> not.  According to the answer, we can discuss what to do better. :)
> 
Acking this patch, as this discussion is a problem for "us" (netdev
people) to figure out.  Lets land this patch and then we can followup.

--Jesper





