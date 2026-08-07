Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AD07C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 05:45:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D748C6B007B; Fri,  7 Aug 2026 01:45:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26926B0088; Fri,  7 Aug 2026 01:45:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B5E6B008A; Fri,  7 Aug 2026 01:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0976B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 01:45:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E24DC01C7
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:45:48 +0000 (UTC)
X-FDA: 85073386776.01.09CF8AD
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9E114100010
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:45:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HuH/OQiU";
	spf=pass (imf05.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786081546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vtSZIt9dlXMvAfyTzKVr5n3mZ8wTK92TvaHA6/Pp7GE=;
	b=AyclWDApqTwDoU/UROy26lN3UviXkLdmOrU9ftKA0KyYxuCGULHi6o2AjlfHhiqPQLmVqr
	cST3+FKddzkXTpH8DLNDt4LlWoYohY4UFPV0FMztS7c4UZIaHLVnbEP/exSTNGH4lsC4mq
	ACumgNBebwH+UmeTXOsGzSoyw44K7bo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786081546;
	b=dvrcRcP9GrPeIbogl5VqtPtVzD64zPzQG71xG5EXXZHrs9OQdH3Rt1TepiFzVD3ScG+eEA
	D1SLEj2evhwjk82hE9W+KDzr/stxqB+54WECEESIwItoeuY/1N8E5cuwtyggc21sJluPrM
	AZh+MgQ0BWL9u/BGAPZQWFUvlSc7SWI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HuH/OQiU";
	spf=pass (imf05.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <9067a389-2e1b-4352-bb88-7a78a3fe6a19@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786081539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vtSZIt9dlXMvAfyTzKVr5n3mZ8wTK92TvaHA6/Pp7GE=;
	b=HuH/OQiUliANUoiJzpe5x9lpfc5e4uli8SYz6eIvlroKyZCgQlBTalKdLHwzK38mhxeFNd
	43r7cBZx1HzLb4ZwfRG8tFeE/NlMtwW8JBWogImG4jkqODtz9mdH4pNcOC+mjbP6/iqLwV
	hJNEsh4IkUwQWUt/z77xri3pEkgNY4g=
Date: Fri, 7 Aug 2026 13:45:23 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] alloc_tag: fix undetected compressed tag overflow when
 profiling is disabled
To: Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Abhishek Bapat <abhishekbapat@google.com>, stable@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260805090633.141001-1-hao.ge@linux.dev>
 <20260805095505.1c2cbc150441cb20a74ba9bb@linux-foundation.org>
 <CAJuCfpG_XX-Hwy=TCrJ+g6yiMxGXLB=LvnPN_WLP3WQktNZMbA@mail.gmail.com>
 <e96d8a13-8f9a-49f4-ae4c-a14c6de5ae66@linux.dev>
 <CAJuCfpFyTaqLnyi11PtAj-ouJiLcfxZoYDRUUKSZbW3RfDFOUw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpFyTaqLnyi11PtAj-ouJiLcfxZoYDRUUKSZbW3RfDFOUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9E114100010
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: njon7oje6z5scyzx1o819cx4qzrwcer5
X-HE-Tag: 1786081545-77397
X-HE-Meta: U2FsdGVkX1+GHIsMXU6QRySPOwKPICCxQKnTRPYWjRCRzp+A/W82LRr8KyU/wnhXuxoe7vzr55QpzcTu2m2VQrly1ns6dZM5bRw++C/Lxg8kqVfH9pDjp6jeaZ4PkCr4yB1h6aycmV/iJPxv8Jy8TNzlGH1Eyr3lThpQbkQCItppX/bFbE0Yxj/YjQ3wq8tUpqFec7426jRZi+hZgW2usk73gV1nG601g9tvd4q7qzqeAOmWBnf9uKruEFz2pSGzPno7Hh3Rlb6HuvQyN27NJ1sDklTlVL0DvbhYJx246B0IG8x5GVDdmmN5GPuaBTdwegekJhgVkOvM8LLQDZarK+NgbclijML0ZnhCF6jwrZgCZHWs0iNJiNxYiLm0m3deCMPcssYMe8ACu7cJfUEPzrP1akJrq8CxJxJV1f6B/P4MhXiLN/qpoXZZ6vMt6alHRu5z0JM2jXo0kFR+dQy8xLJFigKXYmapa6v+aIG5rkFf7TuHaH5tnJC2Pl1Se3nIOH1DKGnUnuF/LbChusUd5ff1OyALCxlmd+sVNSYBjubI7U6rNLFutoMvLxcEnbNG9x69Pp2BaLDrhN8VBpX6ljBfNJS9Jlslp8Zhs8pT9+p42EEEBQdPK4/hEWUNS9xJKO6phkuZN9pcBXFYWHzjMUAUXRDgTSFjJunJcCS78AA22xk0UcLR+dXiNFejKZQwnrBeJyKruu9c19B94IICsYQg9yC+H+raoZJViv9eMOtOQ2MXui8V6Eswt5IBSULrqSQTltJnO3d3y4skaOV0BCbSG0j+MI52hM6QwkCY344wHXKiFKdqDyHOfClcBwyxWfzVie3IDMP0diekljKTUlHv+K1EuykNYtlCLChTI1NbYDLqQ2ZUsLjTzTsnt8AXPGHPpEItM7m/rJgCJtnR6x4reCB5/Xll3Kzb9sDbMKhCzxoNdKFhbdJfKhDUXnkfl7Ik28ssztPeyhir+EE
 tc/aqPGe
 4WO66fcBzfHc5VK6inFvs5Olz6gwO3QyWgZcXSpzjV77Rp7AxFwGVehAwxNtzDP96zAuRawLfx9jJAUVhbtrpzJrQbCKn6wktCmpFGVqF7vq6kxEQGKKpxB86Sndx5o1M3F+kzMCouPajZFlola55iuerXCBB72w2BfeljK1UYD9huN910inVM5Q1rOGOLnnemgf/pttPxr4gwg6uJibeqRofUOSBpjvu0NsO4LeOR4JcELhGYzb1QcISnsTB1PDTD4zb5AZnYLTb+h5Vw6qHd9Yqbkq4YpEnMtUYRKifqlnOHIfFi+7UppF0Jmx1V0emYpB2oXd2bWSGJg54s9/f/wBsKmpg8PLkK7IJeBg8ukFBMqfsyqem6laXQ2b9jABjs9cpHAxPzGhod9QtVdHyS9M7hXcNAp+vXYJ39uIGmIH+DpMhSxHyPqLPYkPjBWMGL5gMZHFhH5CWOK4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren


On 2026/8/7 09:08, Suren Baghdasaryan wrote:
> On Thu, Aug 6, 2026 at 1:36 AM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> Hi Suren
>>
>>
>> On 2026/8/6 01:47, Suren Baghdasaryan wrote:
>>> On Wed, Aug 5, 2026 at 9:55 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>>>>
>>>> On Wed,  5 Aug 2026 17:06:33 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>>>>
>>>>> In reserve_module_tags(), the tag overflow check is gated on
>>>>> mem_alloc_profiling_enabled():
>>>>>
>>>>>       if (mem_alloc_profiling_enabled() && !tags_addressable())
>>>>>
>>>>> If profiling is toggled off at runtime and a module is loaded whose
>>>>> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
>>>>> skipped. vm_module_tags_populate() still maps memory for the tags and
>>>>> the module loads successfully, but the total tag count now exceeds what
>>>>> NR_UNUSED_PAGEFLAG_BITS can address.
>>>>>
>>>>> Once profiling is re-enabled, ref_to_idx() computes each tag's index
>>>>> as its position in the alloc_tag array. update_page_tag_ref() masks
>>>>> it to alloc_tag_ref_mask before storing in page->flags. Indices
>>>>> beyond the mask are truncated and idx_to_ref() resolves them to wrong
>>>>> tags.
>>>>>
>>>>> This silently corrupts /proc/allocinfo: allocated pages get attributed
>>>>> to the wrong call sites, so the statistics it reports are wrong.
>>>>>
>>>>> mem_alloc_profiling_enabled() and mem_profiling_compressed are
>>>>> independent. Once compressed mode is established at boot, it stays
>>>>> active regardless of runtime toggles of mem_profiling.
>>>>>
>>>>> Remove the mem_alloc_profiling_enabled() guard. Also return an error
>>>>> after shutdown_mem_profiling() to skip vm_module_tags_populate(), as
>>>>> the mapped pages would never be reused - shutdown_mem_profiling() sets
>>>>> mem_profiling_support to false, so no future module load enters the
>>>>> codetag path.
>>>>
>>>> Thanks.
>>>>
>>>> AI review points at a cpuple of possible things, one pre-existing:
>>>>           https://sashiko.dev/#/patchset/20260805090633.141001-1-hao.ge@linux.dev
>>>
>>> Yes, pre-existing issue can be handled separately, it's not directly
>>> related to this change.
>>>
>>>>
>>>> "Does this unintentionally result in a denial of service for module
>>>> loading, preventing critical drivers from loading when they otherwise
>>>> could have just disabled profiling and gracefully continued?" sounds
>>>> pretty obscure and I doubt if we care?
>>>
>>> Hmm, I think Hao considered that in his previous version
>>
>> Yes, I did look into this.
>>
>> but now I'm
>>> thinking we might be able to handle this more gracefully and not fail
>>> the module loading. When profiling is disabled
>>> codetag_needs_module_section() returns false here:
>>> https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L2822,
>>> so if we had to disable profiling, we could return NULL instead of
>>> ENOMEM and change the condition here:
>>> https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L2825
>>> to act as if codetag_needs_module_section() was false from the
>>> beginning. IOW code at
>>> https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L2822
>>> becomes:
>>>
>>> if (codetag_needs_module_section(mod, sname, shdr->sh_size) &&
>>>       (dest = codetag_alloc_module_section(mod, sname, shdr->sh_size,
>>>         arch_mod_section_prepend(mod, i), shdr->sh_addralign)) != NULL) {
>>> ...
>>
>> The primary blocker is __layout_sections.
>>
>> https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L1730
>>
>> This is because __layout_sections controls whether we reserve space for
>> the codetag section inside EXECMEM_MODULE_DATA, the same way we handle
>> regular sections.
>>
>> When codetag_needs_module_section() returns true during layout,
>> module_get_offset_and_type() is skipped, so sh_entsize only gets the
>> type bits with offset = 0 - no space is reserved.
>>
>> If we bail out with NULL when compressed tags overflow and add a dest !=
>> NULL check here, we'll end up hitting the later else block.
>>
>> if (codetag_needs_module_section(mod, sname, shdr->sh_size) &&
>>       (dest = codetag_alloc_module_section(mod, sname, shdr->sh_size,
>> arch_mod_section_prepend(mod, i), shdr->sh_addralign)) != NULL) {
>>          ......
>> } else {
>>          enum mod_mem_type type = shdr->sh_entsize  >> SH_ENTSIZE_TYPE_SHIFT;
>>          unsigned long offset = shdr->sh_entsize  & SH_ENTSIZE_OFFSET_MASK;
>>          dest = mod->mem[type].base + offset;
>> }
>>
>> That'll cause the following memcpy to clobber the leading data.
> 
> Ah, ok, now I remember how the areas are reserved there. Yes, my
> suggestion would not work.
> 
>>
>> If we really need to fix this, we can use dest's return value, with a
>> check like:
>> if (codetag_needs_module_section(mod, sname, shdr->sh_size)) {
>>          dest = codetag_alloc_module_section(mod, sname, shdr->sh_size,
>>                  arch_mod_section_prepend(mod, i), shdr->sh_addralign);
>>          if ( dest == sentinel_val )
>>                  continue;
> 
> You can't simply continue here because during the next iteration
> codetag_needs_module_section() will return false (since we called
> shutdown_mem_profiling() and set mem_profiling_support to false) and
> will take the "else" branch you pointed out earlier, which will
> clobber the leading data.
> 

Ah, right.

>>
>> But that would also mean extra work on our end - for instance, we’d need
>> to stop the per-cpu allocations inside codetag_load_module.
>>
>> https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L3571
>>
>> Could there be a simpler solution for this?
> 
> Hmm. What if we return something like -EAGAIN and propagate it up to
> load_module(). load_module() will check for that error and retry
> calling layout_and_allocate() but since now
> mem_profiling_support=false, both layout_sections() and move_module()
> will work as if profiling is disabled. We need to make sure
> codetag_module_replaced() and codetag_load_module() do nothing when
> mem_profiling_support=false but that should be easy. WDYT?
> 

Good point, I'll look into this approach.

Thanks
Best Regards
Hao

>>
>> Thanks
>> Best Regards
>>
>> Hao
>>
>>>
>>> I think this would result in a better handling of this situation: if
>>> we can't fit the tags anymore, we issue a warning, disable profiling
>>> but continue loading the module. Hao, WDYT?
>>
>>
>>
>>
>>
>>

