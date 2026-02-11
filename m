Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 697BBEB5949
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 01:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4EE46B0005; Tue, 10 Feb 2026 20:12:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD1F16B0089; Tue, 10 Feb 2026 20:12:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACA416B008A; Tue, 10 Feb 2026 20:12:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99FF96B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:12:50 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28D4D1B29B7
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:12:50 +0000 (UTC)
X-FDA: 84430401300.23.ACB0E56
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf29.hostedemail.com (Postfix) with ESMTP id AEA93120007
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:12:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=i8nAa+au;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770772367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=faQqNuYtBPQaP3ZQXG1razFHoF3o8CJE3mR/YmkHui8=;
	b=nFEQRZkMJVAqrKMBEToLfg6bwk6qRfGFmkuDgPzEvjW1MofVc5nASIGJK8dpdPpHhxwccP
	HNKFpWzA3nh8PYGLSRqnmIrmvULR94xL/5+EyAWlrTTidawhCNSpS9ZeXDCXQeX5jORVpd
	rlQpTrska4JgfWJ6SnbKY3a3pfv+Hnk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770772367; a=rsa-sha256;
	cv=none;
	b=PBb20GvS6b+bQh4mw9Hm5lGZcL6EE2D2Vv5VUtp6JzRtcCCO43VZrDIa+KO/s5VyQvZvhr
	SxylCNzeE0EHc0PqAMstbwmCsPouPvvFp0U6ztRahOCss8UweU7ih662pyNz+pTQv5UndG
	HyfolnneEWk7P6lYuFEWW4a4qdrShQA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=i8nAa+au;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770772362; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=faQqNuYtBPQaP3ZQXG1razFHoF3o8CJE3mR/YmkHui8=;
	b=i8nAa+auUf8wYBuWzrCzulaOVqCTbjNxbpVf0N1HIzqSSW5yA5a/vC7GCMIxA1uvG/DA87e0K9rnzYs9XUkMVKUKAnLrWkIjd7DgECSd3hYxg9mld28NXZ2IIJsmIlYFQE33tK1r+TBF3cl0YKx8d6D83OuXIwfY1wBrx/9jmLg=
Received: from 30.74.144.106(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wz-u6Mf_1770772361 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Feb 2026 09:12:42 +0800
Message-ID: <f7596f9b-5796-452e-82e1-f8cc6e042eef@linux.alibaba.com>
Date: Wed, 11 Feb 2026 09:12:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/11] mm: thp: always enable mTHP support
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1770675272.git.luizcap@redhat.com>
 <29e8dfc2772af4b6e0db24134ca3563ec422b91a.1770675272.git.luizcap@redhat.com>
 <d2bc3d79-5d00-4943-80bd-01b144529177@linux.alibaba.com>
 <0c0886d5-2561-40e4-94e9-6fca15f25127@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <0c0886d5-2561-40e4-94e9-6fca15f25127@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AEA93120007
X-Stat-Signature: ug5cewpeedqs7w89h6tb3zzbdq63ej9b
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770772366-250948
X-HE-Meta: U2FsdGVkX18x4HOvzVOlRSTyRI9e052rUN/0uLJAwGWcoPiVnwNzn/9oV+KPMkJ/+7njP/FOGstxz2nBqFSRjvetZ8twEYcOHmK1YX8B9tlJP4HrNxKNV9hscoPKQ+ZTDeVtwHA67GyU2H8XZva1eFdd7IST8Jh0SDcfUZItoFB5CIb7najGZAb3wwAB2q/O4Asx+DsQfkHNWTgAxff5MlSubiK7aX5lN0D4EcOIDDldPl/4+Xwry05n3dD6LwKlZERoL52vevoysgwuTfM3AYaQyTiUWY3yWwjkjnxzFpDiN2wy/+5/Av3WehD//EQbXcvZuZ9Ir1A9RbAZ98p7eHadBGdwyAx4a15PWIYFJc19wyrOgG0UvTQjQk63KugnrtXOsQuCAvuYWwBX21lICQ7EFUnM5f4JVesuyBBgzuKja5WuPh1Mlv71TCvdVI1iHGIeDDfVAnC7Mn3t6067JVjqgv5ARfvlzRh3lQ/ZuV0juk4dCsqKRRooCsOu3tg6NROkWlSWXamrAQWBEQTd+CHuomWIeTjlV0COdgSjL9b3s4bZRxwXpankH6hiiZ/CjII6v+f0Hic51xRLrysxla/MxHGwUUa8zeifWfYkhimd5PHkW+q3ahZUXzl6U90Ai5kAT2IkWifUV3AhxdByM8SPULIke4BycSepKgLlbWShUan2semjl1wrvndEqJmcM8fUNcyVsFY0lj7MrV8m1PiDkCLh/hGXcAp+OvKFoWWIyq8TcKAiqDsG4rRGdHjITFD1EWKI+N3zRLh84W7rrVyxjqnhW9pMCao1l9EpJvQnDtUHNHM/wyUwsDk8breyhVY8oFOqvcZm7oyYHEsOKgnwZhkIdY5gamduntr/H2oY+Q5qzl4pLg/5g9XAMQhtz6bpK6U2b39kWxO8aIr5qM7/gjDEM01mZ4oSUQ0xziBGYx5wJtUB2l8AtjhLZOJFPuDZNkzjLXtEAwrdqrQ
 hd2Ro9D5
 6952SM7kcaF5PM9a2PGSigaB4Fb7ZlA8dekJFEg6Pa1UihKhd9QFZb2k+pJb1ijhVQotB5K1wLIibmB8bmUTO62I41JMKmPWUAt8Md2UZouCagIjxMmu7KoAw+0taHGxu7p3f4KVVS7BP+wKXmCFFQmdSFwqXTQtLq3R61oEsAU14uvoLQvrg4U29LEAA1PA00/eZV7ghMkLaGzdOj8+kGDvLQroKbFGF2Uj3VreqqAZfbZNONGQgAuXhm7RQwQ3tbsCkAFm7gpxzTQBxBApx3jb/AX664CUhDRR+b3uU48MOXnKnUsBpSNMEP+B5ogJ8gCV3KzBJVNUaGEJjPUFBLeGZ9OcpgfHBOJignEGUbr94VIU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/10/26 9:28 PM, Luiz Capitulino wrote:
> On 2026-02-10 04:56, Baolin Wang wrote:
>>
>>
>> On 2/10/26 6:14 AM, Luiz Capitulino wrote:
>>> If PMD-sized pages are not supported on an architecture (ie. the
>>> arch implements arch_has_pmd_leaves() and it returns false) then the
>>> current code disables all THP, including mTHP.
>>>
>>> This commit fixes this by allowing mTHP to be always enabled for all
>>> archs. When PMD-sized pages are not supported, its sysfs entry won't be
>>> created and their mapping will be disallowed at page-fault time.
>>>
>>> Similarly, this commit implements the following changes for shmem:
>>>
>>>   - In shmem_allowable_huge_orders(): drop the pgtable_has_pmd_leaves()
>>>     check so that mTHP sizes are considered
>>>   - In shmem_alloc_and_add_folio(): don't consider PMD and PUD orders
>>>     when PMD-sized pages are not supported by the CPU
>>>
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>> ---
>>>   mm/huge_memory.c | 11 +++++++----
>>>   mm/shmem.c       |  4 +++-
>>>   2 files changed, 10 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 1e5ea2e47f79..882331592928 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -115,6 +115,9 @@ unsigned long __thp_vma_allowable_orders(struct 
>>> vm_area_struct *vma,
>>>       else
>>>           supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>>> +    if (!pgtable_has_pmd_leaves())
>>> +        supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>>> +
>>>       orders &= supported_orders;
>>>       if (!orders)
>>>           return 0;
>>> @@ -122,7 +125,7 @@ unsigned long __thp_vma_allowable_orders(struct 
>>> vm_area_struct *vma,
>>>       if (!vma->vm_mm)        /* vdso */
>>>           return 0;
>>> -    if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, 
>>> forced_collapse))
>>> +    if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>>>           return 0;
>>>       /* khugepaged doesn't collapse DAX vma, but page fault is fine. */
>>> @@ -806,6 +809,9 @@ static int __init hugepage_init_sysfs(struct 
>>> kobject **hugepage_kobj)
>>>       }
>>>       orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
>>> +    if (!pgtable_has_pmd_leaves())
>>> +        orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>>
>> I think you should also handle the 'huge_anon_orders_inherit' setting 
>> in this function if pgtable_has_pmd_leaves() returns false. Shmem as 
>> well.
>>
>> if (!anon_orders_configured)
>>      huge_anon_orders_inherit = BIT(PMD_ORDER);
> 
> Good catch. So, would you agree that should set it to BIT(PMD_ORDER - 1)
> in this case?

 From the documentation:
"
By default, PMD-sized hugepages have enabled="inherit" and all other
hugepage sizes have enabled="never".
"

So if pgtable_has_pmd_leaves() returns false, IMO, we should just skip 
setting the PMD-sized order for huge_anon_orders_inherit. What I mean is:

if (!anon_orders_configured && pgtable_has_pmd_leaves())
	huge_anon_orders_inherit = BIT(PMD_ORDER);

