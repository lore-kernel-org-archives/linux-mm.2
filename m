Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4DCAC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 11:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1C5A6B0088; Thu,  9 Jul 2026 07:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4656B008A; Thu,  9 Jul 2026 07:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4236B008C; Thu,  9 Jul 2026 07:50:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 726306B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:50:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EBFF2892F7
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:50:25 +0000 (UTC)
X-FDA: 84969070410.19.873AABF
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 06E081A0004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:50:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BzxIY3LF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783597824;
	b=M/OkWI7BP4fpC/QJQ4RYZG5jzujyRlBR99UyzhgpxuxhigHVdYUWhuobW/RpXIvfH4yC31
	fl6VdVmZa1hqXfxNrQLaXUg7HlAq2reTI7a4fw0VVs7q5riPNYxQWMq0h7rU9Ctyc2fGSQ
	zW44BRlPejwic6/BF9nrzO711HjgdWI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BzxIY3LF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783597824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNCN2Fdr8yqkD0LsjJkDJLi2MeWHIGyOWfhBDBuuA2k=;
	b=eHOgLQCVRvuZboTxU4CsBTIiNBJUbROFMMao/DfeFtv7M+2GAUgnfA9fXvaT7wRRVJws6/
	r+z1Xm6+5ftz7/kQ1fwhaOBxx9Yo00HJzwF0YSXEYZ5QgLc/SVEUNZCpUvVuM+EjSxxRWQ
	bNCbyGs+e6M0nc1zLQY5L6gJSwQQ7ic=
Received: by mail-pj2-f3.google.com with SMTP id d9443c01a7336-2ccb0e85312so11593295ad.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 04:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783597823; x=1784202623; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hNCN2Fdr8yqkD0LsjJkDJLi2MeWHIGyOWfhBDBuuA2k=;
        b=BzxIY3LFqHKxKqgVRpGZ3NlBX7gi3ziU3JAQ3LVuvLyfaIQbfeVaGL5JvoZsKd5TIV
         ZQUyoUGoRNhgmNmt07/hy732AqB+s5UifaT8TVp9HfOgTG1M97Meq2s2aLJrjSrE8ix8
         11/5oxAGSwddSovPc2VdpH6pZzCfS29TrJKiM2FaXoz4gVfB2tBquWCOCHJnG+vojnA0
         MHz2HuLsKIk3wjRkFqeDbMvu76t1p9MhCMwhJ6SUs4GqXB4sXomhn4z0yA9o8puJDTmr
         TM65dKUWD+6e+V5L2mGATtdEnErRFNS6DzmdDCGE12BY9xJAAGqMUPlyyEhvMOX6iARW
         3qig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783597823; x=1784202623;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hNCN2Fdr8yqkD0LsjJkDJLi2MeWHIGyOWfhBDBuuA2k=;
        b=ZHNVZgWP79IJllgPMNpf4wIYTt8RXzMzuTJuCl3tcIAByQPXZGLmYZqAYqEx482g6N
         B/lJGre/6HWAHrSaqPFQR4v3mxPrSsVkCVRedI4IYfiBbdMpKrpUA1jnwhgCMgrdaiEd
         2PuD7vX20sfq17IT5EbE9fi2j8KUxHsfwz6HcyFHffueOjTPJ+/JeBggzVSgwNyWF/+y
         2JoRG7uUKOkxXRILp7QH0xfdU054FNrk3gRUd1AUCep9DrY0HNF72+FxxJ8q6F3dt8E/
         o+iCJebvUX/4QeSXUvAwI9AlSB6gsVwRId0n5CoHWGpC0iBS7nKKHjn4rewX3UeQ6UyL
         /1Bg==
X-Forwarded-Encrypted: i=1; AHgh+RrWGwpNAJlqfuqR2VAfRckLefH4S9GQN7MI1kO7GIzqaNNcrnzlyn0QX/O4XxUSJViFzUsd1sJpRQ==@kvack.org
X-Gm-Message-State: AOJu0YzoWVfW2xcr1XPS9lEv6O8CMal1hUh6tMBJaxP/EZ8FKeR/IYpb
	Lx8gTap/oGnco4meeZ3uFYAHWmC+m6ILSvcCrW3BzVD0DwpSdyTnE+ZM
X-Gm-Gg: AfdE7cnRNIeeyvM1ptP9rK3XQd9BRB+DBo0MC3Kv9FOhjOg5mEsYtfKie7qiwQwD8N7
	slEUyx+do0hqraHq4gqOHw7fJXiB5h36Qczu/GjjJ94NGzRmU19VJTGzz87SjLJUpluujJDf+BQ
	oxdDFwn6TeY33D6D5UPKmHFcrxg/XCVbkjp94ngHSS01jeoEwcJODWm1ldTvgTwGHTcBPV8+exu
	bzwZ2vBGj5sre8LIP2wkPU7Zuud8jEtVDYQz5LyyCOGZkBC3empXX9Ozq4F2Oo0sebwrIODQMVE
	1nQktXq6AlNluuDMAe9m7SN52NjwsuSyhqkMtjF+LqTtSOckroRDW/VL+W+1LNmt4KPD+TWFZjM
	BjuXRfJgFCO5t94lU98aPOI2NivaHVvCy+CiQbyjzYI/+5ad1WkR5zd9lZi3tVx/Z/i6jzENph0
	WzizOkFeuN4J64G/rLUoW5
X-Received: by 2002:a17:903:2b03:b0:2cc:f4d4:299f with SMTP id d9443c01a7336-2ccf4d46d5amr50430705ad.27.1783597822781;
        Thu, 09 Jul 2026 04:50:22 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb6e2sm43597885ad.3.2026.07.09.04.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 04:50:22 -0700 (PDT)
Message-ID: <66a0b183-825d-43e8-8a03-8ab98728c153@gmail.com>
Date: Thu, 9 Jul 2026 19:50:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm/mlock: wait for migration to finish when
 mlocking a folio
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: vbabka@kernel.org, david@kernel.org, rostedt@goodmis.org,
 mhiramat@kernel.org, Alexander.Krabler@kuka.com, hughd@google.com,
 fvdl@google.com, bigeasy@linutronix.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, riel@surriel.com, liam@infradead.org, harry@kernel.org,
 jannh@google.com, lance.yang@linux.dev, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, pfalcato@suse.de
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-3-chenwandun1@gmail.com> <ak0C-DP_1ZrTVSLj@lucifer>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <ak0C-DP_1ZrTVSLj@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 06E081A0004
X-Rspam-User: 
X-Stat-Signature: abk7yw8fs3iiwt4rgfqudufpnzi3r5h3
X-Rspamd-Server: rspam03
X-HE-Tag: 1783597823-794710
X-HE-Meta: U2FsdGVkX18a/aBzNbgVeGckiEWtL9iyUV2NcP4jMdGnyEQOjdPreT/Fu7zSL6xdc8NsJA9fnIAIEuImcndMpEuocwYcEIgFFNNOIhHuio0MUA9nqvWBbZ9Z8Yx8pMaPdF5Bb7P7iwSTUUFzBf2pUbAjMVxCPq8mN9VV9DJaWegkHYn/kt9GqawLRi+uTDDAueRPuN8OTclJkkyCcOB7705SNELVPMtoquyc+ZsPIzQQ1TU+TH3kMBEOZxl1M72VFaAMcRm+Vlw/nXErWVDseWt3iTmS8sj9Fw/SwsENefipI3o3y5E6sx7a6a0/DKGSZVWGMpxfQr9Fyc0URVS07nuO9zUOxls6tdnk0e8yAtVWiYE6MPWh8TKT2/jruHL1cxnQc+hysUrPdUn4DOQ41wJzI0I1GDC4eKMLykRbtgpoF0hZMbgVgVKoMVwu1aVt4S+VExXRtL0E9dEMgCENOuNUkYNQcEa1H+fTHg7HSVHMuB/3Nuey8XHhZDxNzVBgLV9sWyhTu/4EL4a8k96H6yXrvOi5LSnPR9AsJXZ92jMap7eRQKuPdxBkNExrtE4F95ve8dPInU32W+CfzRFK8/f+nMbqjkcSAsYFE6NUnlLg6pjSsyouZB1VZyBJyNcgc/CQjFlr2lvMVb9lAcZ+7Yf/YOTiGqEa4dUHmvmRH7v7cS8QToScdj3iVNIeeWkLaPVoN2Zj2Pkq54nyfDjbUqaoC2hqRNaf1QVjnjJZAtJWFs4y9P6BkUEHZl0lkh7AsTRYv7NvDSfN4+AU1Bs48OYLesCX+i/vQk8eFRGc0DwZbg8nBJZsip+JvJPsvcAb7hwz223nCpfK76uoxQVwe8edkNiGN2cxTZHo/9TOtEO9PA22v+YaKR9oi4jUfwWOIohe3BA8O3qdCsWfQKHISllIhlhFsOSz2cOiBaq0lv+ZqvyJ5+mmQA+GI5C2ZiujGKnkwDiapTsap8Mr4en
 LNNaUM5N
 Gp4xuz+4c72+O7e60piX9mfQ9bthLz1v7jGOVyRVe8pNf3bKWata4Q2obwyUO6m/cgW+WOAK5jWzYis8W2CfiGuE7NIyITAf09/myEd1QCk8ds6a2ZIVxfol3TpP1kfHpk5b6X7ZUNKRtNs7IAkB/mfQB/M82k4R/+jtnqTeYFbtKFFK1V9e6kN/efXgxYKbtIHEcXj/whuuAfjpt4w1JHsDG4YdQMhBEQvWhKvkxwvzu0ozb8O7W2RVKebw4PDdU2VnQjx62K1RCE1w1f0Ngarw7Mei7Kw/929BRciayp8TLumtQsURsYdotZP12x3P7K1EJXa2F1ZPTZrLm7g36goPlk2AqZcJ+da8NCAEjTjaL4nazvr/MHMeF7Gne18+98IrDrfAMftSG+s025cEUobv2/iwHBG7plzQYd/JOBeNuuAJ0S83g3/zFX4cS1cJw5S67OsNcMy/jpMc9jsSMDeloyN+sobTy6mRE2+Zz7DPHVXKw/YAMx0JeK2+cjxpCGBpMHLQnlfyhPz0Ag63CROrvFa614BxYOiIRcZdoCHOPyIJkQZo/t6pduPQozHbp5RyOD6HC6Yy4S/STYSNfdm6X7l9UBhM2q7kbvHyOg2dWVyZHzEWXoGmpPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/7/26 22:33, Lorenzo Stoakes wrote:
> On Tue, Jul 07, 2026 at 08:59:23PM +0800, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> In RT kernels, sysctl_compact_unevictable_allowed is false by default,
>> when the mlock/mlockall system call try to lock all the present page,
>> the mlock_pte_range function skips non-present entries. If these
>> non-present entries are migration entries, and the migration is not
>> guaranteed to have completed before the mlock/mlockall, it may result
>> in a page fault on subsequent access, which then waits for the
>> migration to finish, causing spike latency in RT kernels.
> 
> Is this really noticable and measurable?

Alexander Krabler reported a 1.1ms latency in [1]

https://lore.kernel.org/all/DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com/

> 
> I suppose not too many ranges should be mock
> 
>>
>> Fix it by waiting for the migration to complete during the mlock/mlockall
>> syscall when sysctl_compact_unevictable_allowed is false.
> 
> Probably better to reference the sysctl itself rather than an arbitrary varible
> name.
Got it.
> 
>>
>> Fixes: 90d07210ab55 ("mm: mlock: use folios and a folio batch internally")
> 
> Again I have no idea why you chose this as the fixes target, especially for
> this?
You're right, the Fixes tag was wrong.

Setting sysctl_compact_unevictable_allowed to zero was introduced in v5.7 by:
	commit 6923aa0d8c62 ("mm/compaction: Disable compact_unevictable_allowed on RT")

Before this commit, mlocked page can be migrated, and dont need to wait for
migration complete.

After this commit, if don't wait for migration complete, this may result in
latency spikes.

(The batch mlock feature increases the probability of hitting migration entries.)

Will update Fixes tag in next version.

> 
> But in any case, why is this separate from the previous commit? I sthis an
> entirely separate fix?

These two patches address two aspects of the same problem,
and I split them into separate patches mainly to make review easier.

Patch 1 mainly prevents pages to be migrated due to batch mlock;
patch 2 mainly ensures that pages undergoing migration have finished
migrating once the mlock system call completes.


> 
>> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>> Link: https://lore.kernel.org/lkml/c8793c0f-7156-4cb7-9e6e-7909397e2fff@kernel.org/#t
> 
> A nit but please strip that #t.
Got it.
> 
>> ---
>>  mm/mlock.c | 23 +++++++++++++++++++++--
>>  1 file changed, 21 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/mlock.c b/mm/mlock.c
>> index 97e49038d8d3..ac65de40b22b 100644
>> --- a/mm/mlock.c
>> +++ b/mm/mlock.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/memcontrol.h>
>>  #include <linux/mm_inline.h>
>>  #include <linux/secretmem.h>
>> +#include <linux/compaction.h>
>>
>>  #include "internal.h"
>>
>> @@ -361,8 +362,17 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
>>
>>  	ptl = pmd_trans_huge_lock(pmd, vma);
>>  	if (ptl) {
>> -		if (!pmd_present(*pmd))
>> +		if (!pmd_present(*pmd)) {
>> +			if (unlikely((vma->vm_flags & VM_LOCKED) &&
> 
> -> vma_test(vma, VMA_LOCKED_BIT)...
> 
> What is the basis for your unlikely()? Don't use likely()/unlikely() just
> because it feels right. Leave them out unless you have actual profiling data to
> prove it.
> 
> Remove it please.
Got it.
> 
> But I'm also confused here - why are you checking for VMAs that already had
> VMA_LOCKED_BIT set when you are about to set it?
> 
> Surely this shouldn't be predicated on VMA_LOCKED_BIT?
munlock also would call mlock_pte_range, if page is under undergoing migration,
munlock dont need to wait migration complete.

> 
> 
>> +			    !compaction_allow_unevictable() &&
> 
> Why do we care about compaction here? Are we assuming the softleaf migration
> entry is present only for compaction reasons?
> 
> So these migration entries could be there for any reason? Does it matter? Is it
> such a big deal, on mlock, to wait for migration entries? I think probably not.
> 
> But then maybe some weird workload gets affected... hmm.

Indeed, there are workloads that are affected by this.
In RT kernels, RT processes typically use mlock to prevent their memory from
being swapped out, and sysctl_compact_unevictable_is set to default 0 in the
RT kernels, so mlocked memory won't be migrated and won't encounter migration
entries on access.

Using compaction_allow_unevictable here is mainly to check whether the system
is latency-sensitive. In RT kernels, sysctl_compact_unevictable_is set to 0 by
default.

If there is no waiting, the migration may won't have completed by the time of
the subsequent memory access, and then we would have to wait for migration
to finish in the page fault path. Since pmd_migration_entry_wait/migration_entry_wait
has no priority-propagation mechanism, if the process executing mlock is an
RT process, this can lead to priority inversion and latency spike occurs.

> 
>> +			    softleaf_is_migration(softleaf_from_pmd(*pmd)))) {
> 
> Use pmd_is_migration_entry()? :)
Got it.
> 
> And technically you should use pmdp_get() I think? Maybe a situation where we
> don't care/need the READ_ONCE() though.
> 
>> +				spin_unlock(ptl);
>> +				pmd_migration_entry_wait(vma->vm_mm, pmd);
>> +				walk->action = ACTION_AGAIN;
>> +				return 0;
>> +			}
> 
> This code is really disgusting, let's please not just copy/paste open-coded
> nested horror shows like this.
> 
> A good rule of thumb is if you see a bunch of code 'poking out' like this and
> certainly if you copy/paste it or something very much like it, break it out into
> a function.
Got it, will do in next version.
> 
> So:
> 
> static bool wait_for_migration(const struct vm_area_struct *vma, softleaf_t entry)
> {
>>>>> As above I'm not sure should even be checking this?
> 	if (!vma_test(vma, VMA_LOCKED_BIT))
> 		return false;
>>>>> As above I'm not sure this makes sense?
> 	if (compaction_allowed_unevictable())
> 		return false;
> 
> 	return softleaf_is_migration(entry);
> }
> 
> Then call it like:
> 
> 	if (ptl) {
> 		const pmd_t pmd = pmdp_get(pmd);
> 
> 		if (!pmd_present(pmd)) {
> 			const softleaf_t entry = softleaf_from_pmd(pmd);
> 
> 			if (!wait_for_migration(vma, entry))
> 				goto out;
> 
> 			spin_unlock(ptl);
> 			pmd_migration_entry_wait(vma->vm_mm, pmd);
> 			walk->action = ACTION_AGAIN;
> 			return 0;
> 		}
> 		if (is_huge_zero_pmd(pmd))
> 			goto out;
> 
> (etc. going *pmd -> pmd)
> 
> But we could probably do even better than that, and assuming your dubious checks
> above aren't needed, we don't even need a helper then:
> 
> 	if (ptl) {
> 		const pmd_t pmd = pmdp_get(pmd); // possibly just *pmd?
> 		const softleaf_t entry = softleaf_from_pmd(pmd);
> 
> 		if (softleaf_is_migration(entry)) {
> 			/* Wait for migration entries. */
> 			spin_unlock(ptl);
> 			pmd_migration_entry_wait(vma->vm_mm, pmd);
> 			walk->action = ACTION_AGAIN;
> 			return 0;
> 		}
> 		if (!pmd_present(pmd))
> 			goto out;
> 		etc.
> 
> And similar for the PTE stuff below.
> 
> This works because softleaf_from_pmd() (and pte) will give you a 'none' softleaf
> if the entry is not a softlaf entry. So you can unconditionally call it on a
> PMD.
Got it.
> 
>>  			goto out;
>> +		}
>>  		if (is_huge_zero_pmd(*pmd))
>>  			goto out;
>>  		folio = pmd_folio(*pmd);
>> @@ -383,8 +393,17 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
>>
>>  	for (pte = start_pte; addr != end; pte++, addr += PAGE_SIZE) {
>>  		ptent = ptep_get(pte);
>> -		if (!pte_present(ptent))
>> +		if (!pte_present(ptent)) {
>> +			if (unlikely((vma->vm_flags & VM_LOCKED) &&
>> +			    !compaction_allow_unevictable() &&
>> +			    softleaf_is_migration(softleaf_from_pte(ptent)))) {
>> +				pte_unmap_unlock(start_pte, ptl);
>> +				migration_entry_wait(vma->vm_mm, pmd, addr);
>> +				walk->action = ACTION_AGAIN;
>> +				return 0;
>> +			}
>>  			continue;
>> +		}
>>  		folio = vm_normal_folio(vma, addr, ptent);
>>  		if (!folio || folio_is_zone_device(folio))
>>  			continue;
>> --
>> 2.43.0
>>
> 
> Thanks, Lorenzo

Thanks again.
Wandun

