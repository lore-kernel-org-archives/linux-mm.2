Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1A6606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 12:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MSeSHGzq
Received: by kanga.kvack.org (Postfix)
	id 4CB906B0356; Fri, 23 Oct 2026 08:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47BF46B0359; Fri, 23 Oct 2026 08:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 342E66B035A; Fri, 23 Oct 2026 08:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F09626B0356
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:14:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83A111C3B27
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:14:03 +0000 (UTC)
X-FDA: 85353782766.20.81DF862
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id E6BEC40003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:14:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MSeSHGzq;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792757641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4f7ubQl5WS1WieEIVPxE9ayCQ7cIvJdX5Z1roKMeMo=;
	b=FhSo/k2iN1Rsn+6ojSPl+7mYGJUHXn+W2WAuvCm1sJwuNmENRqIoCh0Y5m5k/N24tlcjvv
	aLCfHff2OXbMSwSzD2nxGTAtqbVM3p8lLI5gQwRPcWAIO0sleDVcKHApQJtHddQHrMjuVK
	SDM9ewshw265L3vcl55Lb7xzlXMy3gA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MSeSHGzq;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792757641;
	b=DyqXO4ZVovy1kGYpXp5MyrLTPWxaqBQRaCnzeByZUoYRXXk6CPCpDVqnZTMB6g1VShH5sP
	YTL7NhEujtASlptkbNyxGg6GcajYxkmzjeNocl3bJJ6y1rTpLugdfVJ0i2hUuSQWUVrTo1
	41aeRk92YA7Nqz+gvoMCUIHJNuIS5fg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792757640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z4f7ubQl5WS1WieEIVPxE9ayCQ7cIvJdX5Z1roKMeMo=;
	b=MSeSHGzql6Dqv5bvd1VikTanqB6bjmjWdizDvYPBDpq2wWxihWXqVza2oF2tl2CEX0U0xK
	y+0CYmfJyBjEtufTOVjmnN3vJnlwO19oA6GM7sAn8+7A6Wk3uDJ6tvoGU0I3ANIl8lUiPe
	Qe0T+BQ3pO3II8xw6W1EeUJm5N83nGw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-gdGG1omQPNOuyeBy4_c44g-1; Fri, 23 Oct 2026 08:13:59 -0400
X-MC-Unique: gdGG1omQPNOuyeBy4_c44g-1
X-Mimecast-MFC-AGG-ID: gdGG1omQPNOuyeBy4_c44g_1792757639
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-91b529a8610so18908786d6.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 05:13:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792757638; x=1793362438;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z4f7ubQl5WS1WieEIVPxE9ayCQ7cIvJdX5Z1roKMeMo=;
        b=TaSBfFKHgebBeqmcYpYQ4gpWjG5HC152yYd2CW2Gchic/AUTaBlYAtWyQG1mN+Mjgj
         C/8bJSgtqYx1qLCzJ+6Qmz2XfK+qwiN8/rM6DiOjq8O7wg3gzNelgZjEH79toMRQ7crN
         y7b4QETd4AH04tgsJGhb9HB4IP+7NtQACGC0MmSn2iHxqy6DJeKx2G8zH2qQe3wgjsVz
         bQyzDSfRgEbo01GKilalKhNlf+OwbdteFTP9OGaxyd0/eFygukVcAwh1Dud4Dj9G2Cq4
         AfGHws7tGMNoZvQ/+DvgceA3p9Iyquxsc/5/y0xgYVodSkh/27Q7BfkmY327zRtU1NRm
         72Uw==
X-Forwarded-Encrypted: i=1; AKwUvByvD017apvGriUReNlC/VzvdMvkH40+MLf4XjOVhoRWmlS6bkrjtRK1gWUATeJ4UXkTucApftceMQ==@kvack.org
X-Gm-Message-State: AFq9FYKqzzY3nmckSvPWIr67og8lC+vDjXYmQloX6aI6643KZjV13lCJ
	AW6/Ufquy0XZ5U/rd6xi3sGkcTGl0jnTH1/inu3nKKwzBD3nZnZju/n1t3O8mNN5XZLdkuCPO8L
	Owx8j4vxfUkHMok1md22ZWztwGEEHpuTQqoOF+/oDXdLwfmM0KImKLJ/NXuPY
X-Gm-Gg: AYBFou2ID/IZK5+ynEv9bidQx6Qvw23Hqm4IUe51r23HtK6fbZQaZbexbEkvUD4tJxS
	SlDTN7HO4nZDD2BBGzrCSRHhiUbMmRt6UjEEY4xnzivJYkeM2SNaUu3BLWElgw1DbOhHcXDRBYI
	m9kltgqLR6fhiSlsPats60X+AaSSaAYwoR+BhuFEqzSSIH2Z5y/UFQoj/4RUDloANzRhjS0BTU5
	0lCdIXVE3d8RFoHsl7cGkwws/8JH/p47mLH2SJR6d2EBwvZvXLdIInEumUJt8gJxkaP7VSYOupd
	pXsu763iOQ+dCwfawt+vfGIdcqODceAr5M5pUOLJTR8LuH8/s6r1w/3PWsed5fk35aVMp6er32V
	Sdo8=
X-Received: by 2002:a05:6214:5c03:b0:917:8752:8214 with SMTP id 6a1803df08f44-91c3a609a10mr28184036d6.1.1792757638302;
        Fri, 23 Oct 2026 05:13:58 -0700 (PDT)
X-Received: by 2002:a05:6214:5c03:b0:917:8752:8214 with SMTP id 6a1803df08f44-91c3a609a10mr28183596d6.1.1792757637741;
        Fri, 23 Oct 2026 05:13:57 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c3fd665a4sm8079006d6.35.2026.10.23.05.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 05:13:57 -0700 (PDT)
Message-ID: <9544f4ce-f5d1-498b-91ed-906b37122e31@redhat.com>
Date: Fri, 23 Oct 2026 08:13:56 -0400
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mremap() fails VMA expansion when VM_MIXEDMAP is set
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@kernel.org>, Jakub Matena <matenajakub@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261023023106.515365-1-luizcap@redhat.com>
 <8c53e58c-f7d2-4e98-8d03-7ff1163c1159@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <8c53e58c-f7d2-4e98-8d03-7ff1163c1159@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _R_rnImBdIXfBC9KrvqgGQ95E29Xe_9UmGk93XuIMb8_1792757639
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E6BEC40003
X-Stat-Signature: hn77qam6fzb8he4qnfonfp1a1sf83ik9
X-Rspam-User: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792757640-488916
X-HE-Meta: U2FsdGVkX18g6DZpmpBGn7KMPu4xSjcGl+kR7AHoDcPkqHi4Ap4wfzal8AvNX7UqLK46ddpgu3G3GGyDskriKkT8ksTCmE3UEdmM8Dr7hRYCzFcuQtmlsYlbRSlVQA0mZjof6HVJqSXKC7t3yixHtMDh6XU+w9cYOuyZT+xHQfj/3wccdNg5NhJDrzXsIEYu25R/axpNiCYTWYj+H9eom4icW/xhPCQnaL38q5mMpvBY9qmRZq+ccnaHJdrHTy3zJUZtlI9RDk5BtyKYmSf5oCJUAMMbcPbmykMtqyOdoJkwXOgvqmeGEzjLCg8UibmWQ/Rcf9ALAElepfqIrgQRHU6QNgvSCUATzeZY5iw9MQONd0Uj45+LkjqzD2hXyV2Oxtkz7muxqbzhrpABEE3vuXA4MB51Cuvp0HPPKx6B3X4ZgvdFfZ12x8I+f4eurSCumuR/Y+atOeHfK5i84N/phB6OYpQgRmmSTyJB3pHkn4Nt/FAQxbg+d3x5fVLzKXf3VlealgcdBNf7SfxCQb6ZgenU9mddpMoGKDCpxR5WWaxwu8Vus0R0pqJOdCBQfKT3Nl7HEdPdUjugusMLy+MUzf/JGAhLJFKqQ1Aw+VPzcBqy3UntpgPv2KPm9CF0S1Qm7+Cr7YSLehCqUFWVEo40qwhDbjTLEG7A3CeoK6xqbd75MLUvx317cOuCju7xGLHRXUeslr0EqjBwD7djrbKteCKAnptW9b8yXu7V1hkU3u8vGThkah4UruSjp1sKp348xM09c6zpfu2zCgxXMxbKEiJRwZBqXntQcUobdwOUgl9wfA27L6x5awedt3LbmTNwi1LMFGjgZXwdTAdY3L0qhSSgcmmGRtuJhMSuQJUDh+a0tJnfMmNOHCgLkpI+KmspOPLcrzZfIOFw3wCAcsUrivMVsJUVtvv4f6oZuXkJKvd00MiaDYGdX513yGW65nBuJHk7sqTBK6IoeKL6JoM
 v7VuDcxs
 uvgs2j4naVhTzbRavD+9KIlyZ024uP0pcSbSxsorGKl0q45LqsZhEferhW0RfHZ++vaYRONjvIKE64lRQqJoLnIxTtrtDodKyv+aRMOxQShp831ycePZP+6z/jkcwY78/8vhQdue9zOqaJZfJ3H/X/w3uYgEJXEF8kFyK9bk/egH3BhW2YGh0G2oy4I3/aKiDFsH/fcHWRYNpGW2tMQsrq1nN9qKnO4T5zeQa8waKJtCTSzrBPDUl2phmMhno3TbuSy0A/zRxjTYW2aPzc4E5NcWOILqzqKogcVwsxlzy/51aVZ7wXiPmKrP5uDY3bEXDj4RUs3c+mzjw+R+9pE14/fuNVTR9CFA+yiYGGiXnoCwamR1JtJmEQlrq3aZLcTyLArn54leZZrjEzbc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/23/26 3:16 AM, Vlastimil Babka (SUSE) wrote:
> On 10/23/26 04:31, Luiz Capitulino wrote:
>> Growing a VM_MIXEDMAP VMA with mremap(), with or without MREMAP_MAYMOVE, fails
>> with -ENOMEM when the address range after the VMA is free.
>>
>> This regression was introduced in v6.1 by commit ca3d76b0aa80 ("mm: add merging
>> after mremap resize"). This commit changed mremap() to use vma_merge() instead
>> of vma_adjust() for the expansion case. However, vma_merge() returns NULL for
>> a VMA that has any of the VM_SPECIAL flags set.
> 
> Hi,
> 
> 6.1 was a rather long time ago. How was it discovered just now? I.e. what
> use case broke by the change and prompted creating the reproducer?

The use-case that broke was an application running on an older kernel
and accessing a GPFS volume/FS. I was told that GPFS sets VM_MIXEDMAP on
a VMA because it inserts pages in the process address space with
vm_insert_page(). I then asked an LLM to check if there was anything in
tree that would reproduce that, it found the tcp_mmap() case and created
the attached reproducer. Btw, the LLM also told me there are more cases
in-tree that can reproduce this (but they require special hardware or
setup so I didn't investigate).

> 
> Thanks,
> Vlastimil
> 
>> The issue is also present in latest Linus tree, except that the code has been
>> refactored. In the current tree, the path now is expand_vma_in_place() ->
>> vma_merge_extend() -> vma_merge_new_range(), which performs the check:
>>
>> 	/* Special VMAs are unmergeable, also if no prev/next. */
>> 	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
>> 	    (!prev && !next))
>> 		return NULL;
>>
>> This issue was originally reproduced with an external module that sets
>> VM_MIXEDMAP on a VMA because it wants to insert pages with vm_insert_page().
>> However, there's at least one in-tree reproducer: tcp_mmap().
>>
>> Note that commit ca3d76b0aa80 introduced other VMA expansion regressions,
>> but they were caught and fixed early:
>>
>> - 6f12be792fde ("mm, mremap: fix mremap() expanding vma with addr inside vma")
>> - d014cd7c1c35 ("mm, mremap: fix mremap() expanding for vma's with vm_ops->close()")
>>
>> Below you'll find a reproducer and an attempted fix.
>>
>> Reproducer
>> ==========
>>
>> This reproducer was written by an LLM and uses tcp_mmap(). It reproduces
>> against v6.1 and latest Linus tree (2a08195e4db5). The issue is not
>> reproduced on v6.0.
>>
>> #define _GNU_SOURCE
>> #include <stdio.h>
>> #include <unistd.h>
>> #include <errno.h>
>> #include <sys/mman.h>
>> #include <sys/socket.h>
>>
>> int main(void)
>> {
>>          int fd, pagesize;
>>          void *p, *ret;
>>
>>          fd = socket(AF_INET, SOCK_STREAM, 0);
>>          if (fd < 0) {
>>                  perror("socket");
>>                  return 1;
>>          }
>>
>>          pagesize = getpagesize();
>>
>>          /* tcp_mmap() sets VM_MIXEDMAP on this vma. */
>>          p = mmap(NULL, 2 * pagesize, PROT_READ, MAP_SHARED, fd, 0);
>>          if (p == MAP_FAILED) {
>>                  perror("mmap");
>>                  return 1;
>>          }
>>
>>          /* Drop the upper half, so growing back into it can happen in place. */
>>          if (munmap((char *)p + pagesize, pagesize)) {
>>                  perror("munmap");
>>                  return 1;
>>          }
>>
>>          errno = 0;
>>          ret = mremap(p, pagesize, 2 * pagesize, MREMAP_MAYMOVE);
>>          if (ret == MAP_FAILED) {
>>                  printf("BUG REPRODUCED errno=%d\n", errno);
>>                  return 1;
>>          }
>>
>>          printf("NOT REPRODUCED\n");
>>
>>          return 0;
>> }
>>
>> Sketch fix
>> ==========
>>
>> In the fix below, I started with the same idea as d014cd7c1c35: on v6.1 I
>> made mremap() expand VM_MIXEDMAP VMAs the same way that commit did for
>> VMAs with vm_ops->close(). Then I adapted it to the current tree. It fixes
>> the reproducer and I didn't get regressions in MM kselftests nor the
>> tools/testing/vma test.
>>
>> However, I'm not posting this as a fix because I'm unfamiliar with the VMA
>> code so I'm not confident this is the right approach.
>>
>> I really don't mind someone more familiar with the code taking this over.
>>
>> diff --git a/mm/vma.c b/mm/vma.c
>> index 6c35f0d775ab..ac9a0a8a4be9 100644
>> --- a/mm/vma.c
>> +++ b/mm/vma.c
>> @@ -851,9 +851,15 @@ static int commit_merge(struct vma_merge_struct *vmg)
>>   	return 0;
>>   }
>>   
>> -/* We can only remove VMAs when merging if they do not have a close hook. */
>>   static bool can_merge_remove_vma(struct vm_area_struct *vma)
>>   {
>> +	if (vma_flags_test(&vma->flags, VMA_MIXEDMAP_BIT))
>> +		return false;
>> +
>> +	/*
>> +	 * We can only remove VMAs when merging if they do not have a
>> +	 * close hook.
>> +	 */
>>   	return !vma->vm_ops || !vma->vm_ops->close;
>>   }
>>   
>> @@ -1093,6 +1099,20 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
>>   	return NULL;
>>   }
>>   
>> +static bool can_merge_vma(const struct vma_merge_struct *vmg)
>> +{
>> +	/* VMAs without prev/next are unmergeable */
>> +	if (!vmg->prev && !vmg->next)
>> +		return false;
>> +
>> +	/* We can't merge VMA_IO, VMA_DONTEXPAND or VMA_PFNMAP */
>> +	if (vma_flags_test_any(&vmg->vma_flags, VMA_IO_BIT, VMA_DONTEXPAND_BIT,
>> +			       VMA_PFNMAP_BIT))
>> +		return false;
>> +
>> +	return true;
>> +}
>> +
>>   /*
>>    * vma_merge_new_range - Attempt to merge a new VMA into address space
>>    *
>> @@ -1152,9 +1172,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
>>   
>>   	vmg->state = VMA_MERGE_NOMERGE;
>>   
>> -	/* Special VMAs are unmergeable, also if no prev/next. */
>> -	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
>> -	    (!prev && !next))
>> +	if (!can_merge_vma(vmg))
>>   		return NULL;
>>   
>>   	can_merge_left = can_vma_merge_left(vmg);
>>
> 


