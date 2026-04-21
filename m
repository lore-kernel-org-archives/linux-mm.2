Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72C83F5A8A2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 02:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C70606B008A; Mon, 20 Apr 2026 22:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48CB6B008C; Mon, 20 Apr 2026 22:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86986B0092; Mon, 20 Apr 2026 22:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A5AD66B008A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 22:13:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6FB4D140C4B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:13:05 +0000 (UTC)
X-FDA: 84680940330.17.295713E
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf30.hostedemail.com (Postfix) with ESMTP id C09A78000F
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:13:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xOcYwync;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776737583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hA0i3udkMiNuPIN+N6Va5cEC1S96vQmqUF4aWxz/iKc=;
	b=vMUBPdFOufrD+dTqWfG78NFguK8ceR6gHN+HIdshI/8gAhYwwoL+sJBu8IqRhlK806FNsv
	AzhyfzUs38J++1MLWx5R6XgQ0ijB3KLV4Z1O+Cy9Cg3ESczJbsnD7tp1rvQQc9qvXBxDOz
	lsP8ydz/9URpdJwpFMW0wtxM0oZ2sfM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776737583; a=rsa-sha256;
	cv=none;
	b=gQlSvbHYzIsnTTnjZxKTWRFd9JNsm1wUzHN3FHaDsHhTIx2oq5AlQ+PKkV5icIWOLERgHe
	nTjXwkXfFU4W40wqCwIpo6pwqLa5awrDR4bCz8p756x76nZxE43MLgZaKRIhYQsHhvqLwx
	1imn9MOfw5yVh2vO03uMcIoz4+1Urh0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xOcYwync;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776737578; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hA0i3udkMiNuPIN+N6Va5cEC1S96vQmqUF4aWxz/iKc=;
	b=xOcYwyncC/0Lnwy6cN6SU+rH1Uo/v1uCq+R56zSKriPaoyqnwWaixsSQlVpvTm1/PbG5A+oQIFb4TJga0ZtW+o04/2KRT8ZgscHgs2hObTVcTdVv7QfErqIR95WmzN/DMA18ee75hPBIADJ57zD15AZ0MlQUJcPtyNV1DTu3sc4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1RNv9w_1776737575;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1RNv9w_1776737575 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Apr 2026 10:12:56 +0800
Message-ID: <2c88f810-5c5c-4c26-af34-49e90ca2ba93@linux.alibaba.com>
Date: Tue, 21 Apr 2026 10:12:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v3 04/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260418024429.4055056-1-ziy@nvidia.com>
 <20260418024429.4055056-5-ziy@nvidia.com>
 <b228baf2-0dcd-4135-bab9-04d979b6e617@linux.alibaba.com>
 <E7EBC528-C511-4166-89F3-654171383646@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <E7EBC528-C511-4166-89F3-654171383646@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zb5989xux3zuyqgndnetj1jghiuiaku9
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C09A78000F
X-Rspam-User: 
X-HE-Tag: 1776737581-675858
X-HE-Meta: U2FsdGVkX1+Y0B9GYEuOGkO22P15AJPtVlPNPSFZOdbixwiXedIa8uVwict0PN85pavcCOC7QQBAgzHJBLt5SsQuPvyqvcf1VRqudSmApqrbFH906CpSDIV0/h1IrFky7VeI8MjOJtJfXUqsdC+Na5Kxp6nTMZDRjJgrFXe+tKAEn826QCczoEL26IU5iuMb1MKzQkKZZsYebRWPwPNq9KirkEUF3lqJdxZ+7R+oLKUovuFD8oOAI8Q0iBSUa5FTE8Av1ssiGwenBlS1LdglHI5cpBQFKRmriBQS5iOrOf4Zwd3GnHHKXu0wTecpOCFHt5/UpooYZcN/ndAx4d9imVjHrBbapQWZ45eCjY5RzZPjWBuBVWXSzEDCKadJ+ZadiO3hLh/lk0DtPgOlgjxqsp0BO4Kp46Zhrgy7r53UXrxUgzREpxzNjSTYJQOiZXVHFGKX1alIMAmb2vr+glvgbpk/i0IH25YSKKtv5C1Gtx3JREauFxVG/ukm2ODcWj7qVRAo7NQWmiL9Gn5CfbVLYoy6Z6VZPYnqFS+pBJxgM3gSwBJasMd8xtmlwAMKp27yGPEIIfSa2LcQZICju6V6R2d+tN947+w6b1KoV3FK49kM/gRVzJo8RVRmEB6dvaa3QM++QD8IcB8t5FYHzusuRQhl4KHuNYbBKQle3bOjj45Jh7z3aYhLZq3BAVoUojzScZbwQbhkSPt+bm0gHmYz8n2YAtMgBA+S15zVnIeA45rsjfMDNGYsbgKgp50QViF0nhI7LQ4scp4ST1vAIu9MfYL4IBdr8K+ZQPcaz2LwkbZDmYn3ET2Zex4TRViwjh6E0IyN6rXpiJO38gWU+0/dva0doCt3GftlB5B5ItYcrPlSNkgmf7FGju9FmijK/zUDy1wXBsq3GolcYJjcF0BVesU3ch6WSUZ4eOR/RhFBPgVj6+KbIsu+cfeAZjDSHackyem5ACqJ+mGLDQcP8BZ
 dNZ/nJgy
 jujoqtwUDSzWJv5wloUIRGQJT3kgPkLuCNleAe89Ml0lGUEySV3pEPTNMH3JBsmQaPuUvRKHheTloYfH/yBK+Q2XSjhXfJzuk1BHqUvrQ+mRIL60f7fynK3u564LxIQknw0l4NSuisKav0IUJiI9zc0dLbDw/hne3tNQMb0PtqU79MyUSSZZUC5Qa51BgKEd4Vs1TG6Yh9Qh5Ol/gQbrgM+Ra5E0lKwh3K9Qbs0DPMpZho8GbtDi0cvLeFvdf7eLuAhdLiwcNBhBJZFaFHn/o8EfUN0YoxNHFO3wB1vhD6waa2lSQLh8MCh20Dwg1Sljes4Va0FMM4puVyogkUNSb4j4Lllkzgz0xfqMo3wktGeCkxc8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/20/26 10:57 PM, Zi Yan wrote:
> On 20 Apr 2026, at 2:55, Baolin Wang wrote:
> 
>> On 4/18/26 10:44 AM, Zi Yan wrote:
>>> Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
>>> hugepages are enabled by the global transparent hugepage control.
>>> khugepaged can still be enabled by per-size control for anon and shmem when
>>> the global control is off.
>>>
>>> Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
>>> IS_ENABLED(SHMEM) in hugepage_pmd_enabled().
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>    include/linux/shmem_fs.h |  2 +-
>>>    mm/khugepaged.c          | 28 ++++++++++++++++------------
>>>    2 files changed, 17 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
>>> index 1a345142af7d..dff8fb6ddac0 100644
>>> --- a/include/linux/shmem_fs.h
>>> +++ b/include/linux/shmem_fs.h
>>> @@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>>    void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
>>>    int shmem_unuse(unsigned int type);
>>>   -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
>>>    unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>>    				struct vm_area_struct *vma, pgoff_t index,
>>>    				loff_t write_end, bool shmem_huge_force);
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 1c0fdc81d276..718a2d06d1e6 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -406,18 +406,8 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>>>    		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>>>    }
>>>   -static bool hugepage_pmd_enabled(void)
>>> +static inline bool anon_hpage_pmd_enabled(void)
>>>    {
>>> -	/*
>>> -	 * We cover the anon, shmem and the file-backed case here; file-backed
>>> -	 * hugepages, when configured in, are determined by the global control.
>>> -	 * Anon pmd-sized hugepages are determined by the pmd-size control.
>>> -	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
>>> -	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
>>> -	 */
>>> -	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>> -	    hugepage_global_enabled())
>>> -		return true;
>>>    	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
>>>    		return true;
>>>    	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
>>> @@ -425,7 +415,21 @@ static bool hugepage_pmd_enabled(void)
>>>    	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
>>>    	    hugepage_global_enabled())
>>>    		return true;
>>> -	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
>>> +	return false;
>>> +}
>>> +
>>> +static bool hugepage_pmd_enabled(void)
>>> +{
>>> +	/*
>>> +	 * Anon, shmem and file-backed pmd-size hugepages are all determined by
>>> +	 * the global control. If the global control is off, anon and shmem
>>> +	 * pmd-sized hugepages are also determined by its per-size control.
>>> +	 */
>>
>> Personally, I found the previous comments clearer to me. The statement "Anon, shmem pmd-size hugepages are all determined by the global control" seems somewhat confusing. For example, if hugepage_global_enabled() returns true but the pmd-sized sub-control is set to 'never', that means anon pmd-size hugepages are not allowed.
> 
> You are right.
> 
> I will revert back to the old comment without “when configured in” like below.
> 
> 	/*
> 	 * We cover the anon, shmem and the file-backed case here; file-backed
> 	 * hugepages are determined by the global control.
> 	 * Anon pmd-sized hugepages are determined by the pmd-size control.
> 	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
> 	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
> 	 */

Thanks. With that, feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

