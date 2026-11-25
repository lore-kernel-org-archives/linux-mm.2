Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABF4B606A333
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sq8YyyCq
Received: by kanga.kvack.org (Postfix)
	id D242A6B0957; Wed, 25 Nov 2026 04:31:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC056B0959; Wed, 25 Nov 2026 04:31:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11606B095A; Wed, 25 Nov 2026 04:31:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 978AC6B0957
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:31:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 195611A0DAA
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:31:36 +0000 (UTC)
X-FDA: 85473123792.25.9419237
Received: from mta1.migadu.com (out-147.mta1.migadu.com [95.215.58.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id C3720100007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:31:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sq8YyyCq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.147 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795599094;
	b=pORjzsfV65FhGYLYtvE9pqHmkvacnpYf3PQsgGO+ATyToXuMBkUPzD5iLt0lkhbA2Krl0p
	PezvVB1szAoAAYyVrsq5RhAfTM3Cm7h80JL5Wf3krmbu7h7wlo3Exh6x0U+m5kcXU/l+oc
	e2hoOWQBuyST5+EedqG54sTnqmn2Qgw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795599094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0t3yaiYq49eJNhyVmgpMO6uB/jPaQ0b3Gb0soo4gfAU=;
	b=5DRCsSNJH+10Eg444S5EvzRC/2Y45xNLedlVmUy9LWahuFOQRqtvEFNiSjzTBpnTyyRxfg
	JwBJjHxfyYKJeKFDOI7YrX076pj9GnrbeadNQeBBk8Fq3jdCMRlqsolacBkyznUrsj1sEu
	6saiA9eK4g40BW/Soz6jcStlfzPdnBE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sq8YyyCq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.147 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jWng7U13BDQmuoHoZtAwtlO9p/HGoFdvP6Svn7/G2Lo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795599092; v=1; x=1796203892;
 b=sq8YyyCqCSynK6LYfT0t+IFE3WlevVXmrJK3E1O16fRUQXV0Jqa3OgXdJmls+i8EC2+TKlUp
 PX3La5vZufRwNgS+lbGtqnQVre8xrqEkdqWln2ntsWEa5+iOgv7quapCKHJcyo4nLMFeNIouS+E
 BS+Z3fniDkZ7PGNrfnphBSkg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 16ae719c9c2b2084;
	Wed, 25 Nov 2026 09:31:32 +0000
X-Mizu-Trace-ID: 16ae719c9c2b2084
X-Migadu-Flow: FLOW_OUT
Message-ID: <837d7783-0300-4bc1-a78b-620084af08cc@linux.dev>
Date: Wed, 25 Nov 2026 17:31:21 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/11] mm/vmalloc: undo what vmap_pages_range_batched()
 mapped on failure
To: Suren Baghdasaryan <surenb@google.com>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-10-hao.ge@linux.dev>
 <CAJuCfpF_=KV3ArFO5LtMjc4EGMr79tX_tX2K=YCG_JTvC51OfQ@mail.gmail.com>
 <0e30c5c2-b9d0-40ea-b7f9-af9a8854bd58@linux.dev>
 <CAJuCfpE7S3uTX2rqEkmYqhO6zuqTKtDH88w20m1_fMHF8L672Q@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpE7S3uTX2rqEkmYqhO6zuqTKtDH88w20m1_fMHF8L672Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C3720100007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 3ijxbhd45yt14oq88m9cn5yi1apmp6tp
X-HE-Tag: 1795599093-674427
X-HE-Meta: U2FsdGVkX18roD3WZiQtpoUTSWxDOjMoTQBp/PcTGWxZEmfHGoWSsiDYQM6r/N8ya1FEfN/dzkORmz/Ib6jxxAQ77ESWWubYIdpriJys+NVmhS9km+q7TLaRYJGM3XDgquqPtYtYYzppUFiHFQmJCaRe8g2LTORKIQymLBewaOUeohYsSaXvnFB9u0JQeTdK7e6FG/70GcIvwxWriPdT3lHUQM/iPBHPtN4Hl3TnNVxrJCB/jsiFth0Fb+aZsVmGUJlMXbwMDsCsL9pF4UeICEhCpdyb4ZHk3IRC78rbnzc0P9a+EgxuZy9jR+T3Exp9yFRHiTdAH0qMfE3RHiKRFLhxjpBClN6tvNPuCJAw+RNFPhK4tcb29KTf4myTvq9qYUFsA3KEcZHC/clDiVjzmO/FBfgazY7M8xDAO9+6MwBiFG10aMFcz56UoV2a0g1CGkg7wQfEaXaoRtzes1gTePDsCW+jyrkNUzaw0O79bRtnh8W/znrB+nRjg+Rtv2XveLhBLEobAizSVp1YIzNbWkNQQn7htLOjlMb6hnbvjHSYcMvqYtAsgFHF7Si8WBJymQ6YZyUWA5KftJ4KZncYuUN2WyIwi22wJOv8eAiFqBDxv4WrDBUuTPsuUvZaa3d095I404jtFqKTjy696YMpww2loDE5Ft5RAcHeRbvAfSJAJaDBhdrMEgp+6ZB+3YSHNB5/lLqlkoWIltJJ56LJ7tf8U1G4wUIOyJzNUE4SB9orfYpHKwKR5HyZXvYFzFGjutTOLMoXyex0K7SC8cfA6eCSBif8MWgOyiQuO5A4IFNUuOkwN1iJ91QaBOOejL+3NI5RXSAqZ4QYs/ZBePo2o7JSyAcdC4HC0dUxYgZ9kSsSyYwdrb3g1orljbmeUx79Y5VJylO3W1318mONNOQF27O5PaG04Wdg/ZKOi2CrvqLZg4anCMGw9uQl7mbl6ZuTOCMz6cylKMWssPzEFhC
 4ag4jZgO
 i1AhHrCzEHOIHozj5UdKUuM+3yBLUQ6Oo5C/6XcM6smx5kOZtSlmVNBtInMXswTfgmyDlEeZ0RUPlq4fcKAX+2Tj7JGK4HJSE1ntapSVNmj3iPcAfMka14uuNKC6cfD6XPyEjjP3SvKzjcNC62KxiT7GCTH20h1QedSR/ith4kT0hqX8at9YGwa6PTQaGbBw799p4PPHbNNHk5Li/LvMuW3ttu/fnJAbpCpg1POOOYvq6AGaYoZQY/ZCYNLHqb12qySyh+vWIVY3SGjzxKhnpI2RcNJ6snq0w4cSjBAkD6taxcv+Q8y4TEuCFKh8u0+f8MoAgLlzrbKO9MAeGaL8FVeUREhQlo4E5a0pudGtdP7F/Ii2iGhM3HsxE1GsVFtEQ04t8LuSdo7YBpP6scoOkqWFpUeMDzNSek5Oxaj/dGQtks4Rt8MjXzgh46rozeRfIFfhdbRfsSu4Mcj1AFCh3DD9FHmGXafLhd16iA6YZWRHGQvlNqFAVaHJdB3RX2EYSR5k6G+0MmvjxmCnP4A/LKMHv8PA1/P2zLG+jzYV56SIHhaOS+7H/th7JqLYs3wN9zbuxOi9Nlu8B4XFTbxRyOW4rtGmfBPQR7ZWNrPO44ti+NkzYHIyxxdVTDkCb7Xe3SttK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Suren

On 2026/11/24 00:13, Suren Baghdasaryan wrote:
> On Mon, Nov 23, 2026 at 3:32 AM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> Hi Suren
>>
>>
>> On 2026/11/22 12:13, Suren Baghdasaryan wrote:
>>> On Sun, Nov 15, 2026 at 11:14 PM Hao Ge <hao.ge@linux.dev> wrote:
>>>>
>>>> vmap_pages_range_batched() maps the range batch by batch. When a
>>>> batch fails, the batches before it are installed, and the failing
>>>> one may have installed some of its pages. mapped_end follows the
>>>> end of the last installed page, and the error path undoes
>>>> [addr, mapped_end), never past the point where the walk stopped.
>>>>
>>>> The KMSAN metadata is set up for the whole range up front, so it is
>>>> torn down as a whole when the mapping fails, like in
>>>> vmap_pages_range_noflush(). The only caller, vmap(), also calls
>>>> vunmap() on its error path; the double teardown only walks over PTEs
>>>> that are already cleared.
>>>
>>> As I mentioned before I think this patch should be merged with patch 7.
>>
>> Ack.
>>
>>>
>>>>
>>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>>> ---
>>>>  mm/vmalloc.c | 22 ++++++++++++++++------
>>>>  1 file changed, 16 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>>> index 28e65073624a..aa80bc273ec0 100644
>>>> --- a/mm/vmalloc.c
>>>> +++ b/mm/vmalloc.c
>>>> @@ -3748,13 +3748,14 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
>>>>         const unsigned int nr_pages = (end - addr) >> PAGE_SHIFT;
>>>>         unsigned int prev_shift = 0, batch_idx = 0, nr_mapped;
>>>>         unsigned long batch_start = addr, batch_end = addr;
>>>> +       unsigned long mapped_end = addr;
>>>>         int err;
>>>>
>>>>         err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
>>>>                                              PAGE_SHIFT, GFP_KERNEL);
>>>>
>>>>         if (err)
>>>> -               goto out;
>>>> +               return err;
>>>>
>>>>         for (unsigned int i = 0; i < nr_pages; ) {
>>>>                 unsigned int shift = PAGE_SHIFT +
>>>> @@ -3764,9 +3765,10 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
>>>>                         prev_shift = shift;
>>>>
>>>>                 if (shift != prev_shift) {
>>>> -                       err = vmap_pages_range_noflush_walk(batch_start, batch_end,
>>>> -                                       prot, pages + batch_idx, prev_shift,
>>>> -                                       &nr_mapped);
>>>> +                       err = vmap_pages_range_noflush_walk(batch_start,
>>>> +                                       batch_end, prot, pages + batch_idx,
>>>> +                                       prev_shift, &nr_mapped);
>>>> +                       mapped_end = batch_start + (nr_mapped * PAGE_SIZE);
>>>>                         if (err)
>>>>                                 goto out;
>>>>                         prev_shift = shift;
>>>> @@ -3786,13 +3788,21 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
>>>>         }
>>>>
>>>>         /* Remaining */
>>>> -       if (batch_start < end)
>>>> +       if (batch_start < end) {
>>>>                 err = vmap_pages_range_noflush_walk(batch_start, end, prot,
>>>>                                 pages + batch_idx, prev_shift, &nr_mapped);
>>>> +               mapped_end = batch_start + (nr_mapped * PAGE_SIZE);
>>>> +       }
>>>>
>>>>  out:
>>>> -       if (!err)
>>>> +       if (err) {
>>>> +               /* Undo the part the batches installed before they failed. */
>>>> +               if (mapped_end > addr)
>>>> +                       __vunmap_range_noflush(addr, mapped_end, true);
>>>> +               kmsan_vunmap_range_noflush(addr, end, true);
>>>
>>> So, you are unmapping (addr, mapped_end) range but removing KMSAN
>>> metadata for the entire (addr, end) range. Is that intended?
>>
>> Yes, that is intended. The metadata for the whole range is set up
>> before the mapping starts, kmsan_vmap_pages_range_noflush() at the top
>> of vmap_pages_range_batched() installs the shadow and origin pages for
>> the entire [addr, end) in one go. So on failure the metadata is fully
>> installed and has to go as a whole, while the page tables only reached
>> mapped_end and are undone up to there.
>>
>> I know this looks somewhat awkward. The asymmetry comes from the metadata
>> having to be set up before the mapping starts, I don't see a way to avoid it.
>> Maybe add a comment explaining this?
> 
> Are there any side-effects like the one we found earlier with
> unmapping PTEs which we never installed?

I haven't found any so far. If I've missed a scenario, please
do let me know.

I remain unsure whether kmsan_vunmap_range_noflush() needs a
TLB flush - I already brought this up in the thread for
patch 2.

> I don't think a comment is needed as it's quite obvious.
>

OK.

Thanks again for your and Ulad'careful and patient review of this series.
I recognise this version is a bit messy - I had a lot going on at the time,
and I apologise for that.

I'll take that into account and keep improving.

Thanks
Best Regards
Hao

>>
>> WDYT?
>>
>> Thanks
>> Best Regards
>> Hao
>>
>>>
>>>> +       } else {
>>>>                 flush_cache_vmap(addr, end);
>>>> +       }
>>>>         return err;
>>>>  }
>>>>
>>>> --
>>>> 2.25.1
>>>>

