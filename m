Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 726EBC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 02:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E6496B0005; Mon, 13 Jul 2026 22:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497956B0088; Mon, 13 Jul 2026 22:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389316B008A; Mon, 13 Jul 2026 22:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F35206B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:34:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76145A01F6
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:34:53 +0000 (UTC)
X-FDA: 84985814466.12.B44202C
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf14.hostedemail.com (Postfix) with ESMTP id C2987100003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:34:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pp1UnVQm;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783996491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6cPzGN0BhSGG+3mwai37V4K2Gl6btFijFkZKpQaE0Q=;
	b=xWU28EkK4RIdvdhOP4Ad/q0JjXt8m9wg94/Bx2RYn3EnBlrL+xZ7oXQRaMpb98Djo7sqPR
	/hvkdovSeSFcl/yzLc/GSnj0TlfnhisOmOhJCe988AdlQHa9epRakgDxvDTCPTQpdj7wii
	Ggu2Jpb4wbR+rYClAH7gdKsfr/Q4PPs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pp1UnVQm;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783996491;
	b=UR/KPfSBrt/d69Yhzfq8HZUAnvAQBavx1jQHRL+4Z7AMrdUic/fHGifu3gYlGejLFgK+yC
	pNPiA2ITWESBMCBexb7Pl4TCr7t9FR2LiwJrgQD9RmF1Id50+fiPCWRCfcTKbYUYb+CTNK
	GgEUlJ6fbYgP8lA5tykEMhr5Qb/81IY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783996487; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=C6cPzGN0BhSGG+3mwai37V4K2Gl6btFijFkZKpQaE0Q=;
	b=pp1UnVQmRvciKJKiBfAXnlDS/bj2CaRNQ3oObRIY6QWj8qaaJoJVMutT+rB8QUOR0qQb9VUUKWAUnRF8cTYeqHYAgs/6lgjqxw2uE04EBz4MvkR6oGRvnAIq2VI71kt5gdjj8dQ5A+RRi0VZs591wHoT4DYWNDH8uuTe+TNlYvY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X72TukA_1783996484;
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X72TukA_1783996484 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Jul 2026 10:34:45 +0800
Message-ID: <64aae758-bcf1-45f8-bb3d-bd732ada2b11@linux.alibaba.com>
Date: Tue, 14 Jul 2026 10:34:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogW0V4dGVybmFsIE1haWxdW1BBVENIIDYuMTgueSB2?=
 =?UTF-8?Q?2=5D_mm=3A_shmem=3A_fix_potential_livelock_issue_for_shmem_direct?=
 =?UTF-8?Q?_swapin?=
To: =?UTF-8?B?6ams6LaF?= <machao26@xiaomi.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "hughd@google.com" <hughd@google.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: "kasong@tencent.com" <kasong@tencent.com>,
 "baohua@kernel.org" <baohua@kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 =?UTF-8?B?55Sw5a2d5paM?= <tianxiaobin@xiaomi.com>, =?UTF-8?B?5L+e5Lic5paM?=
 <yudongbin@xiaomi.com>, =?UTF-8?B?5p2O6bmP56iL?= <xiaoyaoli@xiaomi.com>
References: <c0b158fe3f25709543b48a9d81b1933120a9e2ba.1783648317.git.baolin.wang@linux.alibaba.com>
 <636829064b674f71a11095603edcb20a@xiaomi.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <636829064b674f71a11095603edcb20a@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eb754499tnuerstew7mcsynnm5u8dunr
X-Rspamd-Queue-Id: C2987100003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783996489-687566
X-HE-Meta: U2FsdGVkX19ruV6ch8OyjnOocnu1PA7uPPIZnE+7ZnJVSSx9aHuBoM154G0p3/o0AvMg7x0feA/v3YILFDnEGsR1WkUrGeM58nXGl0d5h4SZlpXfqnx4sKznYGiflBYfiyejDwWC8qcSSbJ3u9c1qG8n9wWlReoiKFbUgeK1cGRsJpn16cuQcYhm5I9ln8+kHbkRtyz89mLzC/dqf4D7ZsJT03ssr0BTHOyxhoSKLOrnkc5x7jPf94MgdK/d90Hqy5gcFi16QIbtg2PRXJycjumfzQRGgNrs0++b0A56evehD365k2QSWre8jo2T+JYwkB0kmA/eiOdIFNqOJiDBAzfVeVTzTuU7IQD/QWx/I3j8pHx2c42HMR71OUReZLer8uYTXhhfPvzURCpKjceA+QgKrZbkxtlWLRz+ghEr6afYcHAfOXEI2ptq/jUW3foSzbCNrGrNSDw0VcqFWBV3s92XfjPi0JHcbY7Lvy5zBcs6nEqiEpxJs1r45jjzsBUdyebG86ooIWDCntLRKkRJwuRAwI/WLSBGpDVoIH66N9/wje1gwc8nzP9Q1OOHUrssPd87E5zo2FfLo+rkoU9Z2DD2qnP2Zzm5FdpVLN4nGd3O/9Uv8bZoW/NSQ81q2rkvED8fNDAxpWL2rTM7ohZO9hc3b1LA/wiAVfjvr6/OaFQW2x0OcYlbDgseRHcIiddCVmp5mo5BOMS52v+6cP3YYqCEPm2OlN9jMj7wixvdl646CY2ZNyerTThOUaz+RCm7rEWugI0FAGW6L1/Sfp9WRrD7lw6nmbFbDm9jOK6omaM2tENYC+aMsNU4EDF2K7jdwm3DxGr0jYiySPlvYEF/tqPgO9AirTaFKZFVCj4MYn+/rPDRKaorqlseHClopRf+K+8E7FjisRAvLoGrPD9oeXYXT058tolXig7+6tctRc0e7umxyipaed1bnS9Hw/pO0IgroTYuectv7FPnHtH
 4WgLlBso
 RjRfdLcaFu4MEHBEn8S7ufW2cNOZWa6HUW/zesPFpeIbExM1xQTJW45VnK0MwTij1No4aNV7NBNIedPAC5hktSpDz8eiytJObK3x+mVnROafx4Fkk8utJ8IbuPG/gQnuujpnD4Hg4IUBIs8O6s4tRL+2Cm/BYb3qBJi2i9P7YWOasAzQhY7YutOCaZbQ+tHmkc7fUld6quKIU5UcYSb6JL4yq7a+66IQmtzrNSwK3FJe6npELpGN4e3P6FW3tj5eEji3maNc9qLv35ViSPMUuXy4cr+jM2f1kHK1Eh4ykGBA4qlkQTwN+v9GFPH7DJ97KPM8marCfrAS8uZxh1eq7aTRIXR1QeBH6XamaPYO4oJCJ3szj/rVmYWGytfhDXw99qg0UMiSZq5eCJ+QemIbS7hoZAVMNUYrSrPU8B5HVLnNBEbmdUwa73q+3chzo0JmA0sYwtrI/vKdHChDNhwO59clyrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/13/26 7:55 PM, 马超 wrote:
>> When skipping swapcache for synchronous IO swap devices, swapcache_prepare() is used to prevent parallel swapin from proceeding with the swap cache flag.
>> However, on PREEMPT kernels this can lead to a livelock, as reported by Chao[1]:
>>
>> Thread A starts direct swapin of a shmem folio and calls swapcache_prepare() to set SWAP_HAS_CACHE. It may then be preempted inside workingset_refault().
>> Meanwhile, a higher priority thread B also attempts direct swapin of the same shmem swap entry. Since swapcache_prepare() already marks the entry, thread B repeatedly gets -EEXIST and busy-loops waiting for thread A to finish. But as thread B runs at higher priority, thread A cannot preempt it, resulting in starvation and a livelock.
>>
>> Fix it by yielding the CPU with schedule_timeout_uninterruptible(1) when
>> swapcache_prepare() fails, following the same approach used in commit 029c4628b2eb ("mm: swap: get rid of livelock in swapin readahead") and commit 13ddaf26be32 ("mm/swap: fix race when skipping swapcache").
>>
>> However, commit 01626a1823 ("mm: avoid unconditional one-tick sleep when swapcache_prepare fails") found that the unconditional one-tick sleep can cause UI stuttering on latency-sensitive Android devices. So we can follow the same approach by adding a waitqueue to wake up tasks when needed, instead of always sleeping for a full tick.
>>
>> Note that mainline does not have this potential issue, which has already been resolved by Kairui's swap refactoring work[2].
>>
>> [1] https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.com/
>> [2] https://lore.kernel.org/all/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com/
>> Fixes: 1dd44c0af4fa ("mm: shmem: skip swapcache for swapin of synchronous swap device")
>> Reported-by: Ma Chao <machao26@xiaomi.com>
>> Closes: https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.com/
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>> Changes from v1:
>> - Add a waitqueue to wake up tasks when needed.
>>
>> Hi Chao, could you try this patch to check if fix your issue? Thanks.
>> ---
>> mm/shmem.c | 14 +++++++++++++-
>> 1 file changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 94c5b0d78ac3..3c329b794ae4 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -2005,11 +2005,14 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>>         return ERR_PTR(error);
>> }
>>
>> +static DECLARE_WAIT_QUEUE_HEAD(shmem_swapcache_wq);
>> +
>> static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>>                 struct vm_area_struct *vma, pgoff_t index,
>>                 swp_entry_t entry, int order, gfp_t gfp)  {
>>         struct shmem_inode_info *info = SHMEM_I(inode);
>> +       DECLARE_WAITQUEUE(wait, current);
>>         int nr_pages = 1 << order;
>>         struct folio *new;
>>         gfp_t alloc_gfp;
>> @@ -2066,6 +2069,10 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>>         if (swapcache_prepare(entry, nr_pages)) {
>>                 folio_put(new);
>>                 new = ERR_PTR(-EEXIST);
>> +               /* Relax a bit to prevent rapid repeated page faults */
>> +               add_wait_queue(&shmem_swapcache_wq, &wait);
>> +               schedule_timeout_uninterruptible(1);
>> +               remove_wait_queue(&shmem_swapcache_wq, &wait);
>>                 /* Try smaller folio to avoid cache conflict */
>>                 goto fallback;
>>         }
>> @@ -2423,6 +2430,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>>         if (skip_swapcache) {
>>                 folio->swap.val = 0;
>>                 swapcache_clear(si, swap, nr_pages);
>> +               if (waitqueue_active(&shmem_swapcache_wq))
>> +                       wake_up(&shmem_swapcache_wq);
>>         } else {
>>                 swap_cache_del_folio(folio);
>>         }
>> @@ -2442,8 +2451,11 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>>         if (folio)
>>                 folio_unlock(folio);
>> failed_nolock:
>> -       if (skip_swapcache)
>> +       if (skip_swapcache) {
>>                 swapcache_clear(si, folio->swap, folio_nr_pages(folio));
>> +               if (waitqueue_active(&shmem_swapcache_wq))
>> +                       wake_up(&shmem_swapcache_wq);
>> +       }
>>         if (folio)
>>                 folio_put(folio);
>>         put_swap_device(si);
>> --
>> 2.47.3
> 
> We have conducted stress tests on over 10 pcs for 40 hours each, and no relevant issues have been reproduced.

Thanks for testing. Could you add your 'Tested-by:' tag?

