Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C48C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 19:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C2F6B008C; Wed,  9 Sep 2026 15:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCD086B0092; Wed,  9 Sep 2026 15:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABD916B0093; Wed,  9 Sep 2026 15:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79C436B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:16:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C596AA0339
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:16:32 +0000 (UTC)
X-FDA: 85195180224.10.FFA41BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id DA3C340008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:16:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RyCNiVmG;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788981391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wXj9ngN5H6HdwhDblkFoUKV7muoxkLa+76yE7C6hxc=;
	b=VKUbk7Kja7hTaV7N+EGU9tXpafekGlsvCxnxpA7o65ue76sg0LcQuEiHx+t/006jNyR3uh
	ZG33DF5EEAPIa0bAGVhXv+O0hZj6y2X8Xsqy1CkJVEd3DB9vbVZyKzaO43X6woNAUNbmVF
	GZMnQn0bbFb8DoPb3W7X2H8HCfO8sgw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RyCNiVmG;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788981391;
	b=tFG4zgpasaK/dA6iJoEHg4CkgiOvWpsy43tEPVAlE8x4Nt7KYYh5igus6KNMjYZyj2TmDI
	MfogAulpaIYLL9kp3z7hdtzH7fK3hBJW35Xm19Ug0zRhHDo3SrPsdM5NqfYMtWieBeARTv
	wYqoHCAUgcSA9pXGmmAokAxzFMwfvPw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1441F4068D;
	Wed,  9 Sep 2026 19:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6720B1F000FF;
	Wed,  9 Sep 2026 19:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788981390;
	bh=2wXj9ngN5H6HdwhDblkFoUKV7muoxkLa+76yE7C6hxc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RyCNiVmG0gwVoJRRdkUXv8gX6GNUVxZGm/FHUWdTHa0q0orLghemwOWIP47eGmlHO
	 f+VIjcdFvrgMuOGvEK8W6gKmVp8wXZHb4AI4icfn5DbCTSE8Fh4QPZgOWdVWm6k+IH
	 1VRf0nXYJNWfi4yctD/yfryMwJURmBiBgG3cQUxOEJASeT4q4JvyZGBOgUp/h0S+f1
	 D3jfaAehdGBFcnVXliyRb0AZ/1Vw1kbG39s/eKe/RvADFHSvrr/v2l8lnmLe1ocpSr
	 9jwBy2HBn7esZ8m+jhevy9+2T1RNKBcTL+3g/CfJdvdFLl2CwozxkwB/P4xaQNOwlE
	 VBbr66FrXu6Ng==
Message-ID: <8e643f51-a47f-428e-9443-678326288fa6@kernel.org>
Date: Wed, 9 Sep 2026 21:16:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, willy@infradead.org, jannh@google.com,
 paulmck@kernel.org, pfalcato@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-4-surenb@google.com>
 <4825a2fe-f064-45d7-a7c9-e98de7efe86c@kernel.org>
 <CAJuCfpFL_g7tELjT8p8ExM3tX_v2gNDM9rRKwwefPV_KW=fHfA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpFL_g7tELjT8p8ExM3tX_v2gNDM9rRKwwefPV_KW=fHfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DA3C340008
X-Stat-Signature: bk4fnb4q4ch4sbky378y5s3j4u485e9c
X-Rspam-User: 
X-HE-Tag: 1788981390-891565
X-HE-Meta: U2FsdGVkX19bW1XTgMEYU1VAA0zZ9iZJhwcJ67IJPGCjBv+H+Dt9nIn54GucH02BhRRDOGA5Sx9VoZAIEOaGwegTHug5afweftMbCDEE2jY1Mua7+cOSIO0CYQVLNlJejgcGLw18w5KobpZfDOYgLIdaM+44eVwkis6Hs0wzgP8hXITFmWpbYu7XiGgFqJoHrY7aKXOrRVLZeV4ebgNpVRhbW0pCEKkiCciHcnt9peoPjlpzFp9wXA5vwv+kIPI5hhUYFCAcD0TGbqOB+WwgweZJp9GgFdeSzfpxwOjVKcLoQN6eFCHRouZ13j/LB0mmOhCrLaDv09I6kq+yVul6f1ev2VJrfC9HsyRNuriD0ia7GlpkE8byZ5/Qguck+4pXYGS5rYQ7rbbsTo8GuTs6HjGcjIdL75s/JDu9aKN3Sq7jdE4GLzgf6MpfU2XKcZzb1YySbKT0nG4j8AKSwe6PH43lkRy69OPPZtaiIl6+18i7QXvmTeKfcJ+1uYcWSn7190B8+qjIHJPCel4uvfpQ21ENb16NE7QAT5OEFcDz3Zi7PCKIUQvx0TPM0d5dGdl+IwTO10cw/L5PX9fMN61m70myvnppDle5ChyhZUL+bZRYAuAWzBzp5Qp7wx4dmeOE+lCL26JHGSsrBQMr/DbR2XTG7rz2AmSu/mQdQbybleSp/mOU7AdSDzj8A+Eguc7QHQj1Vq2+JULH/G7K6F40rNxgva1ICxdpTfWlt1WUtVz/nKHW1sRpxEdrzQV85o0ctYVm6GlzLMDCKHRE8DnexBbONMGtJC9ttcSNzDxtDzZY1wVxx7LXyYiVOoUn7gZmjtFq6jnP9OrElYUmJFzdcxIX4F2Mjtjt+CIRWQhym04eprKz+ClUDvY36L19r20nZyDgM2uQ39wqSvwMmYclMN4aU3QOK/ezN2xISxi2taniDpVJ7hdV5wkwnkJIxOrBgLJHSmIo2xLhandCtSZ
 WJvReic5
 UclKT5N7L7anDUd/y+VCF6OLfS9BpZurmdhOfv2YZ7Tqy49Qw+4devDLiLUavYnY3p2JaMq/NY18IK8hakUNQ9R3aQs+pudQ8Ic13Vz5NvVN4xe8117EHsE3Q+EnMhPGg48i2N/QLxicybVjC4GUZGNImM9tykpYfLP8UhUXX285GDDlrpZ3PIBtVVz/ZnW5WJN2O+rPyGosQgMrp7g/qL1RdFy9fiZ64HjDkFUbbKyut3LCI/8UqQAW25fScNQwo024gQI8pRKOZDBZDlI+27gpnmU8s0wTelHelDHihIA6Iy/iucR2/3wz0Xjq97a5jW6mlf3Sk0ZwB10Kj8cN1EwVi60kMWI13b4P3cUgFzMIkYVdAZmKnTznE3cYv+08zAlsM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 20:28, Suren Baghdasaryan wrote:
> On Wed, Sep 9, 2026 at 10:16 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 9/7/26 08:39, Suren Baghdasaryan wrote:
>>> smap_gather_stats() interprets its start parameter to mean vma->vm_start
>>> when it's set to 0. Eliminate this special interpretation and pass
>>> vma->vm_start explicitly when needed.
>>>
>>> Since smap_gather_stats() operates within a single VMA, we can replace
>>> walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
>>> which is simpler and also can be called while holding per-VMA lock.
>>>
>>> No functional change intended.
>>>
>>> Suggested by: Lorenzo Stoakes <ljs@kernel.org>
>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>>> ---
>>>  fs/proc/task_mmu.c | 40 ++++++++++++++++++++++------------------
>>>  1 file changed, 22 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>>> index 9908ba32f180..3351decd1172 100644
>>> --- a/fs/proc/task_mmu.c
>>> +++ b/fs/proc/task_mmu.c
>>> @@ -1246,20 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
>>>       return &smaps_shmem_walk_vma_lock_ops;
>>>  }
>>>
>>> -/*
>>> - * Gather mem stats from @vma with the indicated beginning
>>> - * address @start, and keep them in @mss.
>>> +/**
>>> + * smap_gather_stats() - Gather mem stats from @vma.
>>> + * @priv: proc maps private state.
>>> + * @vma: The VMA to gather stats for.
>>> + * @mss: The accumulated stats.
>>> + * @start: The address from which to start.
>>>   *
>>> - * Use vm_start of @vma as the beginning address if @start is 0.
>>> + * This gathers stats for the whole of the VMA unless the lock was dropped
>>> + * and VMA grew or got merged and we found it again, in which case we only
>>> + * gather stats for the remainder of the VMA range.
>>>   */
>>>  static void smap_gather_stats(struct proc_maps_private *priv,
>>>                             struct vm_area_struct *vma,
>>> -                           struct mem_size_stats *mss, unsigned long start)
>>> +                           struct mem_size_stats *mss,
>>> +                           unsigned long start)
>>>  {
>>>       const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
>>> +     const bool is_partial = start > vma->vm_start;
>>>
>>>       /* Invalid start */
>>> -     if (start >= vma->vm_end)
>>> +     if (start < vma->vm_start || start >= vma->vm_end)
>>>               return;
>>>
>>>       if (vma == get_gate_vma(priv->lock_ctx.mm))
>>> @@ -1279,20 +1286,17 @@ static void smap_gather_stats(struct proc_maps_private *priv,
>>>                * Unless we know that the shmem object (or the part mapped by
>>>                * our VMA) has no swapped out pages at all.
>>>                */
>>> -             unsigned long shmem_swapped = shmem_swap_usage(vma);
>>> +             const unsigned long shmem_swapped = shmem_swap_usage(vma);
>>> +             const bool shared_or_ro = vma_test(vma, VMA_SHARED_BIT) ||
>>> +                                       !vma_test(vma, VMA_WRITE_BIT);
>>>
>>> -             if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
>>> -                                     !(vma->vm_flags & VM_WRITE))) {
>>> +             if (!is_partial && (!shmem_swapped || shared_or_ro))
>>>                       mss->swap += shmem_swapped;
>>> -             } else {
>>> +             else
>>>                       ops = get_smaps_shmem_walk_ops(priv);
>>> -             }
>>
>> Horrible, horrible code, really. But not your fault :)
>>
>> I think we can just make the shared_or_ro less odd by just checking for cow
>> mappings (as described in the comment).
>>
>>         const bool is_cow = vma_is_cow_mapping(vma);
>>
>> ...
>>
>>         if (is_partial || (shmem_swapped && is_cow))
>>                 ops = get_smaps_shmem_walk_ops(priv);
>>         else
>>                 mss->swap += shmem_swapped;
>>
>> That's almost in a form that I could understand what's happening.
> 
> Hmm. So, are you saying that !is_cow always implies shared_or_ro? Or
> maybe you are stating that vma_is_cow_mapping() was the actual intent
> here?

So the comment says:

"For private writable mappings, we might have COW pages that  .."

Which translates to:

	private writable == vma_is_cow_mapping()

> 
> shared_or_ro = VMA_SHARED_BIT || !VMA_WRITE_BIT
> 
> is_cow = !VMA_SHARED_BIT && VMA_MAYWRITE_BIT
> !is_cow = VMA_SHARED_BIT || !VMA_MAYWRITE_BIT
> 
> so, !is_cow would impy shared_or_ro only if !VMA_MAYWRITE_BIT always
> implies !VMA_WRITE_BIT. But I think it's possible to have a VMA that
> has VMA_WRITE_BIT but not VMA_MAYWRITE_BIT, right?

VMA_WRITE should imply VMA_MAYWRITE

(in sanitize_fault_flags() we even disallow write faults entirely if VM_MAYWRITE
is missing)

For example, a
> driver can create such a VMA to allow writing to the VMA but to lock
> its content once mprotect(PROT_READ) gets called.

I don't think that would be valid for a driver to do. But it wouldn't matter
here because

	shmem_mapping(vma->vm_file->f_mapping)


I think we could simplify the comment as well to:

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e671b4fd8dedd..4b7e7089cafa7 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1303,12 +1303,10 @@ static void smap_gather_stats(struct proc_maps_private
*priv,

        if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
                /*
-                * For shared or readonly shmem mappings we know that all
-                * swapped out pages belong to the shmem object, and we can
-                * obtain the swap value much more efficiently. For private
-                * writable mappings, we might have COW pages that are
-                * not affected by the parent swapped out pages of the shmem
-                * object, so we have to distinguish them during the page walk.
+                * In CoW mappings, we might have anon folios that are
+                * independent of the shmem object. So fallback to the less
+                * efficient mechanism in such mappings.
+                *
                 * Unless we know that the shmem object (or the part mapped by
                 * our VMA) has no swapped out pages at all.
                 */

-- 
Cheers,

David

