Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 667A3D78784
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 14:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B763B6B0088; Fri, 19 Dec 2025 09:26:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA236B0089; Fri, 19 Dec 2025 09:26:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FC156B008A; Fri, 19 Dec 2025 09:26:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F21E6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:26:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E5D713639F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:26:46 +0000 (UTC)
X-FDA: 84236446812.30.7507158
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6752718000D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:26:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eEW2bq+h;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766154404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=upOt2JTZuib8zVPSSBRi7Ch4qhGB1jIMby/yz6+gnG8=;
	b=gEEOfBf/Ho4FIDr7TfXohlEfqhGTPM7d762LLZVTLZLBaZYHzLYNCm9klDQA6M+vWxMceb
	xT2OeC/IO5zzcXK/4HX71tM6PWcVaek5Uc77KpEWzpBXO1thMDQKJsKi5FXoJ905rotleK
	e/ximEARxxFrfKFnYqUctH6k1rioV4I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766154404; a=rsa-sha256;
	cv=none;
	b=CHCx4CShuL33+j0bJZBkKZ5L20kuYdkubd7/KaF3NtxcxBqNtvQ3rGESy19IwA9eS7wHZg
	fifimTpB8cmLcz/F5NxxkWlNs0sL0EGSmflO/RtbLoGgYcNgm+kaEDBf4whGuNvvN909YV
	wfVl7eE3LJTZfEEv6aQJ4+zZOBPZTbw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eEW2bq+h;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DE074360E;
	Fri, 19 Dec 2025 14:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123E7C4CEF1;
	Fri, 19 Dec 2025 14:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766154403;
	bh=NtruIzmWs3/RkjSPS22/BFy28sNI1V1xZlShtSygzL0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eEW2bq+hSt8aoY5+vSw/devvW8oiU02Te1vhx1dn7FvQ99+3FV52/VzCC4eo1+ckT
	 EU4csDq6JMTCFPedkuaiQ6HVeVi9guzYLqET7EZwFjD33t0sDXh25rnE/e5LdMJytg
	 YwM7FnigemDfwy3Y8dbz486RGJo+iiSlkje3MHOAtFPxbgHDCoEbexUqRzpLeHoSCh
	 Kzji5tTOB2g/mHMNJtnwA4/fCil7VW0dMtG9MN5lyHq2NRIwfJG4Q+0l4G/77KteLY
	 JJEBZXf9nVaiJlGDUgjV3kcf1M/PnFJr3LP+z1U9BDGAVIR6/eDnkHvxPbdYLB7t3w
	 EYx10A3miyx3A==
Message-ID: <ad240d4c-0a4a-41dd-aa19-87293530a937@kernel.org>
Date: Fri, 19 Dec 2025 15:26:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/huge_memory: use end_folio to terminate anonymous
 folio remapping
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, lance.yang@linux.dev, linux-mm@kvack.org
References: <20251215004836.694-1-richard.weiyang@gmail.com>
 <CAGsJ_4w3535fwxa_WkkQLcfNjzRkJYbBJ0WfpYJ+v2hwovdvWA@mail.gmail.com>
 <20251215084353.nmznnnmcpcqo4ldy@master>
 <CAGsJ_4yPnv_G0vciNLabA_kn=0k=RP6kBpuD04btj3HM_zarTA@mail.gmail.com>
 <37c5dbc1-bd66-4124-987f-8983a06d576e@kernel.org>
 <20251218152837.kbgmrjb5i6be7xow@master>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251218152837.kbgmrjb5i6be7xow@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7zxe16uaiconqw88y4pem4r43a56qpzi
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6752718000D
X-Rspam-User: 
X-HE-Tag: 1766154404-705481
X-HE-Meta: U2FsdGVkX1+B27pFrgh2sYORcJPiyDTfRDNO/L6IsEFxFwPPX2n5Honca6xdof4XjKmwj1fEVw5cC/1ZfMukB6Ia5Pu1ExKMJk5t6zguqijYnkn/ANQ12LVvUUJ3uKaL55KUN7y0fBP1SJPID8xFrtYQohx8z5g/3IAyXmdMdd6b6gPNHpatZw/1z6M32sHCPCxAOUj4r/6mzO6lGQgkWCUKT4GBbswFfw9FNlEKD6PDJWBmjxliFo+ffIThaWZU0wrEmsTLumHK8vRs5fLFdnn8WfcOGSj4ULpSE549gUwsZIqXjLXwEaOJvZw97BgnnZodT3ougQjDXNTYBVHiq1P9+NWCPown/00pQCmBhnFFvaFvh+Z0b+rJYgHFFzq+ZDbNWVjjQQaOzwjZaLGDJonKXfWjt2HuMAf6VvrL2avHPZWsWNTMz/UrgJoHk4Ak2rxwQhS9Flet5RXvQRDNFGxu4Zf99LBAswTZSxcQH63TwHHzCMetKvq/ZYuDvPq7+KqdHy4D8CbjU18nzGLcuKtsV8+dd3zQWwjUgJRsLpPEOn26bH9emTGUNavwZJb6gvtYe8S34DrFdjnKk5DJj66L4REmWgiog/rf7/j8JJS8yhyW+7wgIf4Tw8aPdfAHELOTrOV02BWbV5njniNYExn5w8BSYCMLnhLNxPtNEGo8oE9w2TPptCKpIATKZS1GkccOEdjV3BfEBE5jP1+o65Z7mXnvCW2M1nF+kISRODGRTGZpL+xWjRMxxbPjLXKufHMRRrFBUJiOQjl2r4zc5n39Jo1uEgUFljFRjmCq+BzHRlXNsf7Cda8JGq5uUzqti4K7oR+C2cPdEehx1bLbsiPRGJ5oOTBViUJZAmNzPY5ObZmz2FzYiFRHW3mXjOiUnZm0EKD4OOEyxqi0HcEpZ5RQybiuZFYrfoZ/T9pZ4sQmV/AFx1d6mCs0khunwYOfNZnNyCz6Z30ysxlb2j+
 B9qxs6cP
 m6Oup1mm+kd6RksYMzR7E/RIh7vvmx/kBxm6ylb73EztZbJP3v+KhGog/CQqg2TVrBPw8/gD2VCya8M1Dk92Vw+KhV6fXyzsCj4Cz28LmtiGWhqlQ2kmF2uLKmbMZ2OMnefUqtkNx71T5oIfGYAySVWDPOWCNsbdAyR23vGLIxRyko7wg0OqQMot31H39GF+gY3UTiWH6B0cPVdBwUwiu5bDEW9fFEgTEPzfcBkp4JuT1tbZlEjANUZ8sWGL2zntAogBw3g+He6HSrrcel72Jq/TkrV25Of0WcYMfrJBrbV29AvHl1NAqNPuA58qSaCsgtkbyQu4//kabpS3T+QtypcvAE2uG0zzy4fPmTbaup1wUMcO22gDN88Qg7JR7fvAtmjQ01EmfwVoeNR6J10EL7Z00TNIZ9B2/BdhyWoZ1gniY1b2Lt2C4ixLF9Uz0ErlpaScj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 16:28, Wei Yang wrote:
> On Thu, Dec 18, 2025 at 10:58:36AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/15/25 10:15, Barry Song wrote:
>>> On Mon, Dec 15, 2025 at 4:43 PM Wei Yang <richard.weiyang@gmail.com> wrote:
>>>>
>>>> On Mon, Dec 15, 2025 at 10:31:15AM +0800, Barry Song wrote:
>>>>> On Mon, Dec 15, 2025 at 8:49 AM Wei Yang <richard.weiyang@gmail.com> wrote:
>>>>>>
>>>>>> After splitting a large folio, it is necessary to remap the resulting
>>>>>> anonymous folios.
>>>>>>
>>>>>> The current implementation determines the end of the remapping process
>>>>>> by counting the number of pages that have been processed.
>>>>>>
>>>>>> Since the final folio in the sequence, end_folio, is already known and
>>>>>> tracked, this commit refactors the remapping loop to leverage end_folio
>>>>>> as the termination marker.
>>>>>>
>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>
>>>>>> ---
>>>>>> v2: move folio assignment in loop
>>>>>> ---
>>>>>>    mm/huge_memory.c | 13 ++++---------
>>>>>>    1 file changed, 4 insertions(+), 9 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>>> index 40cf59301c21..fe812d9c7807 100644
>>>>>> --- a/mm/huge_memory.c
>>>>>> +++ b/mm/huge_memory.c
>>>>>> @@ -3423,20 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>>>>>>           return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>>>>>>    }
>>>>>>
>>>>>> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
>>>>>> +static void remap_page(struct folio *folio, struct folio *end_folio, int flags)
>>>>>>    {
>>>>>
>>>>> Do we actually see an improvement in readability or performance?
>>>>> The existing code feels a bit more readable to me; nr is clearly
>>>>> the number of pages :-)
>>>>>
>>>>
>>>> Hi, Barry,
>>>>
>>>> Thanks for your review.
>>>>
>>>> Currently end_folio has been used in __folio_split() and
>>>> __folio_freeze_and_split_unmapped() as a termination marker. So continue to
>>>> use end_folio here as a termination marker looks consistent and improves
>>>> readability to me.
>>>
>>> In both cases the variables are temporary, and they look fine within their
>>> own self-documented contexts.
>>>
>>> Now that we’re crossing two functions in the context of remap_page(), this
>>> doesn’t seem to be the case, though.
>>>
>>>>
>>>> But yeah, this is my personal preference. If it is not the case, I am fine to
>>>> keep as it is now. :-)
>>>
>>> I personally find the existing code clearer, but I’m also okay if
>>> others like your new approach more.
>>
>> Me too. Well, the existing code could be cleaned up
>> * nr -> nr_pages
>> * remove i and subtract from nr_pages instead
>>
> 
> Sorry for my poor taste :-)
> 
> Is this what you expect?
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1db9cfb09533..b8ee33318a60 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3423,17 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>   	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>   }
>   
> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
> +static void remap_page(struct folio *folio, unsigned long nr_pages, int flags)
>   {
> -	int i = 0;
> -
>   	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
>   	if (!folio_test_anon(folio))
>   		return;
>   	for (;;) {
>   		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
> -		i += folio_nr_pages(folio);
> -		if (i >= nr)
> +		nr_pages -= folio_nr_pages(folio);
> +		if (!nr_pages)
>   			break;

Right, I think we would never underflow nr_pages.

>   		folio = folio_next(folio);
>   	}
> 
>> probably more ... :)
>>
> 
> Don't catch this. Sounds you have more idea on further cleanup?

I was rather wondering whether there could be more cleanups, but I have 
nothing concrete in mind.

-- 
Cheers

David

