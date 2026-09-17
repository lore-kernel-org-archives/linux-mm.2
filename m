Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6108DC982CC
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 01:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B7C6B008C; Wed, 16 Sep 2026 21:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C516B0092; Wed, 16 Sep 2026 21:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3325B6B0093; Wed, 16 Sep 2026 21:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4266B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:11:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E290C01CC
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:11:33 +0000 (UTC)
X-FDA: 85221476466.06.332EA48
Received: from mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3F482120006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:11:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tcgYrEyQ;
	spf=pass (imf29.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789607491;
	b=3Gp9titOrgZUqoO6m4Hp0e2ik1/NbNIZT+Nxwkn/jVHyWq3tG5qRCqHB5CvOUE8rMaqJWS
	D5zQKEx0vwxZb5yoShlP1/BnvbSrCICwWKRPDpczvPQ53apKg3v7Jjew6BNmRmoBJJnCxN
	tidgtst9rGHocClegxruMrFCtYrjK+M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tcgYrEyQ;
	spf=pass (imf29.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789607491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UTBY/Wb3T5O6LLPzRVqoJemmeSq/RyWX/jZm/HdTXz4=;
	b=DjL+UqskPUD01TjSuDxqgZJgeBLT4bG6ieU8AXFA39J7ykeO3VCRNtpQwh+s/P+L1oLAG3
	rY1Yxb+pGoEHWIU7kl1RDWCpQIyC+ghtEdVjxWCf8gmokqyjLOba2blbh7v4GAsIBnF4ws
	0C/y3ymMNXyDE81zGx21MBs+XUEdxzc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=P9osztPS/w56p8S5ChVkJvqYNJdgBwmiJ78Pt9GIkFw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789607489; v=1; x=1790212289;
 b=tcgYrEyQBicp8cfhe0A5aEsa8zlDiEOciMOZOaO6W2EGB+zhzvo5s8MPuP7lfta/DHBStWhV
 r4PT6ENfRG3WMesbwoF8kWhLgQiSKjihMAxqdezHGd4BHBveTMHVDO0LoZTjjMO3l4S2Xo62blB
 qTHzHm5pApIff0exspDOYh3w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d5848c4447c400b0;
	Thu, 17 Sep 2026 01:11:29 +0000
X-Mizu-Trace-ID: d5848c4447c400b0
X-Migadu-Flow: FLOW_OUT
Message-ID: <1dff448c-9cbe-4276-bca1-d91283b0c7b4@linux.dev>
Date: Thu, 17 Sep 2026 09:12:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/6] alloc_tag: clean up the populate failure path
To: Suren Baghdasaryan <surenb@google.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260915070001.113559-1-hao.ge@linux.dev>
 <20260915070001.113559-3-hao.ge@linux.dev>
 <CAJuCfpHJSwNhgotMVpmjVvdv=m52_7Kvzpztf0WcN0AaoSeGGw@mail.gmail.com>
 <60642a7f-2949-428a-8290-40d69c989a77@linux.dev>
 <CAJuCfpG3d7n=z5WnUQYZsqvrt1pemF8TFvGiGyZGLO7ykVvqAQ@mail.gmail.com>
 <CAJuCfpGeRdFY6UPF-vXxwHvP2+tN=BKgRkmLR3PMLuWhxgzPRA@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpGeRdFY6UPF-vXxwHvP2+tN=BKgRkmLR3PMLuWhxgzPRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3F482120006
X-Stat-Signature: uxrt5w8mgmycn3oif18iwwerjs8xepr1
X-Rspam-User: 
X-HE-Tag: 1789607491-294254
X-HE-Meta: U2FsdGVkX18YP5xNL65rvyZ12bRXN7Fj87uf77GzRQ1aAay6Fj6ek3Az2FCwNxbfYySv/L6sCIIAdoye9XSuL4Q93Qp0Ef7SbGruuE7dFxRzSlKvzb9hT0n2W4uH0K/Oc3NSr4mQQFV5AHw843xmGniig/bbYNKjmIEK2HJkoKwcM97bV/L324W9YMwQ/TcCIBXnek2cXZrjLC5nPFSGHEKo2N6YSzzuht7DKdJ9csbnkPf2xW3vUFDC0X7Cx2lflOG14rNHSB3ZjzNeGZl0DfT1hLREp3JaCHMIvYBV+XrkOC8Wrs8dgmBy2XYnK0X49w7ZWFLe00p5g1WJQ4QON2ZAhgiRvcrWQtw1A2fEzfDbYzYpEEdG0up4nYboE6zYTKSRsuVCOmTP2u6A7Zhy3cXLHtD6AGyFwl0Bp8vIWc347j3TF/FaJnPfr1rUh7+v3Sou8m+aEY9w5IaNSLEYJbdq6X8y4HN2dqE/bkQRkFGuj8BQir1bpVcy9c0e7zb/djVecx5tyKKQZG/Ll8JYunGcoY+jxA3kV+/Ns2qqchTulMXYK2puAsqiD9Y4MWfoJzvm19nIzqnN73gY3DSWFTJUDiXXEMwf7hU2Dh/41n9fA8iAWOjZbhbD8GQAbhbYWYbs7C7+PmVFjiZB/WOXLENn86JmR0WfQBpOcNqqleCnQr8w8hfkGO+gPSwG9qVZzpxNqtvdrVnN77jLr1jx+nmdil/UsJGXM+KjllIRbu5k15gI4o3kp/TTfooJdYfxb9jGmqPxtNGfYvgVmhGMgExSY6SWmsD6g3a4ZbhNNcOHJKMxcZLRyi7nUvYiPAgcTK0xByI05u23pwSsEESvYgbGuJymz8QKrROBCbb8DD8PTpFthbkoDtnNOVHp9VZCUtTL4Z9XjnCtdXL0HGEeGrsPfr6y7m9589sLK4C36OeQI2ZHHpLoTLfNPpM/hWzO9NpN7auis8k3Wwl06GX
 KTnmEHid
 eSfnWMzCM3lMCdmU52oUQ6UGCQSqo9mJCYoLQcC2QvfzsngOhSRsbAunvewhyJtX6ZYFs+8aqaHX62CuanLWmZTAG/QihYBwF9+x9r9hRMlXf3dyJp1zrVSmNH3nlshR3Xre3lgqypsNvrKfyRwje/3tiW6y7+OZ1Wwu7jdf60DT7u7iRb0PQ4NrcyYdtezAzTFTJ3xWbjxHQ1JQDyDb2EBlmBPdVS5ec4K9Dp1LjUVEoKTgMJBlDWcjKtovokMKgxrm94RDXxmGFeNzeRHSBtPjX5LsZol0lTuHkFacwHPELK00/7jXL7Xh0XNXAiP0lFFZn2EIHBhwFCb1KxsESt3EesIWq/2/ULeyAOMKC/MqaSA7RDPON71yUyhWw48xt1tCheF61o2NyvV8KkmDhiYBJnsCfCVKtt3y1KtvRaZ6tDKSEFlrxGHeQn3g7+zeKV3neXBWrgNLnPZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren

On 2026/9/17 03:07, Suren Baghdasaryan wrote:
> On Wed, Sep 16, 2026 at 9:31 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>
>> On Tue, Sep 15, 2026 at 11:00 PM Hao Ge <hao.ge@linux.dev> wrote:
>>>
>>> Hi Suren
>>>
>>> Thanks for you review.
>>>
>>> On 2026/9/16 05:09, Suren Baghdasaryan wrote:
>>>> On Mon, Sep 14, 2026 at 11:59 PM Hao Ge <hao.ge@linux.dev> wrote:
>>>>>
>>>>> The reservation is already stored in the maple tree when
>>>>> vm_module_tags_populate() fails. A failed load never unloads the
>>>>> module, so nothing releases the entry. Release it and roll
>>>>> module_tags.size back. Without the rollback a concurrent load that
>>>>> already passed needs_section_mem() can reuse the freed gap, skip
>>>>> vm_module_tags_populate() and write to unmapped memory.
>>>>>
>>>>> vmap_pages_range() may have installed some PTEs before failing. A
>>>>> retry to populate the same range would BUG on them, so undo them,
>>>>> but only if vmap actually ran.
>>>>>
>>>>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
>>>>> Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
>>>>
>>>> If a patch fixes two other patches, it likely needs to be split so
>>>> that each part fixes one patch only. But read on please. I'm not sure
>>>> if one of the fixes is correct.
>>>>
>>>
>>> Kept them in one patch because they only make sense together.
>>>
>>> After a failed populate the reservation is released and the
>>> size rolled back, so the next load takes the same gap and calls
>>> vm_module_tags_populate() again, and that retry would trip over
>>> the PTEs the failed vmap left behind.
>>>
>>> Without the rollback a load that already passed needs_section_mem()
>>> just reuses the gap, skips populate and writes to unmapped memory.
>>> So splitting them leaves each half broken.
>>
>> Yeah, that's why I think vmap_pages_range() cleanup should be a
>> completely separate patch with vmap_pages_range() doing cleanup
>> itself.
>>

I think I get where you're coming from now.
Thanks for taking the time to explain.

>>>
>>>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>>>> ---
>>>>>  mm/alloc_tag.c | 10 ++++++++++
>>>>>  1 file changed, 10 insertions(+)
>>>>>
>>>>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>>>>> index 2070e682fe10..95ddf5b743d0 100644
>>>>> --- a/mm/alloc_tag.c
>>>>> +++ b/mm/alloc_tag.c
>>>>> @@ -804,6 +804,13 @@ static int vm_module_tags_populate(void)
>>>>>                                      next_page, PAGE_SHIFT) < 0) {
>>>>>                         release_pages_arg arg = { .pages = next_page };
>>>>>
>>>>> +                       /*
>>>>> +                        * vmap_pages_range() only runs once all pages were
>>>>> +                        * allocated, and it may have installed some mappings
>>>>> +                        * before failing. Undo them.
>>>>
>>>> If vmap_pages_range() failed to map the range, why should we need to
>>>> undo it? If it indeed leaves some partial mapping when failing then I
>>>> would argue that vmap_pages_range() should be undoing these partial
>>>> mappings itself before returning the error.
>>>>
>>> Yeah it does - none of the paths under vmap_pages_range() undo themselves on error.
>>
>> Hmm. I wonder if this behavior is intentional or requires a fix. The
>> only possible reason I can think of is performance but I can't imagine
>> a failure to map is a performance-critical case.
>>
>> +David Hildenbrand (Red Hat), +Lorenzo Stoakes (Oracle) what do you
> 
> Huh, my gmail thinks you are still at your previous companies :)
> 

I manually fixed it on the mailing list for this thread.

>> guys think? Shouldn't vmap_pages_range() undo its possible partial
>> mapping when it fails?
>>
>>
>>> pcpu_map_pages does perform cleanup on its own as well. There may be other similar sites.
>>> https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/percpu-vm.c#L255
>>> so I did the same here.
>>>
>>> If we really want vmap_pages_range() to handle this cleanup internally, I believe that would
>>> be a relatively large change, and we would need to consider many more cases. So I think we keep
>>> the current behaviour for now.
>>
>> Yeah, I understand it would require a deeper cut but if that's the
>> right way to handle this we might as well do that. Let's see what MM
>> folks think.
>>

Sounds good to me. Let's wait and hear what the MM folks say.

Thanks
Best Regards
Hao

>>>
>>> Thanks
>>> Best Regards
>>> Hao
>>>
>>>>> +                        */
>>>>> +                       if (nr == more_pages)
>>>>> +                               vunmap_range(phys_end, phys_end + (nr << PAGE_SHIFT));
>>>>>                         /* Clean up and error out */
>>>>>                         release_pages(arg, nr);
>>>>>                         return -ENOMEM;
>>>>> @@ -947,6 +954,7 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
>>>>>                 return ret;
>>>>>
>>>>>         if (module_tags.size < offset + size) {
>>>>> +               unsigned long prev_size = module_tags.size;
>>>>>                 int grow_res;
>>>>>
>>>>>                 module_tags.size = offset + size;
>>>>> @@ -961,6 +969,8 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
>>>>>                         shutdown_mem_profiling(true);
>>>>>                         pr_err("Failed to allocate memory for allocation tags in the module %s. Memory allocation profiling is disabled!\n",
>>>>>                                mod->name);
>>>>> +                       release_module_tags(mod, false);
>>>>> +                       module_tags.size = prev_size;
>>>>
>>>> Yes, this one is a valid fix. It fixes 0f9b685626da commit.
>>>>
>>>>>                         return ERR_PTR(grow_res);
>>>>>                 }
>>>>>         }
>>>>> --
>>>>> 2.25.1
>>>>>

