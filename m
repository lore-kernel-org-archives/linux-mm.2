Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7113CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 01:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38DEB6B008A; Wed,  7 Oct 2026 21:50:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 366196B008C; Wed,  7 Oct 2026 21:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27C636B0092; Wed,  7 Oct 2026 21:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECC486B008A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:50:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5ED9080458
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 01:50:17 +0000 (UTC)
X-FDA: 85297778874.11.0DCDDF1
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id E942E1C0005
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 01:50:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lcu90nEA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791424215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zxvr0RhVyqkVNwZlzTLbBqT6dNG/BVYIaMV3U/7dCnQ=;
	b=VtqwkrbiVwZTDc8CHW3uAlLm/+6ffDMSH4de5RZ5ZLGL+8TGd/TxNdn83giVlY7ifeVg0x
	QK/Cm/j054tZWuQQgzmgtoWrYRkdH30SJyhA5nqB257kghjk8D14OGgVM4LSeiTcoTRWKP
	Wautfo0hMXvB5qHIY2BDTFBVjQCt36c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lcu90nEA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791424215;
	b=yj1bk5mqA6cekIZY9VWZ9/LU21LDDgemrwy0feyrd2+ZfwgEI/s5Kr2gJ/zxq5B4SufkIg
	mvQCiOQDaRETOyF5Aojb5HCwonyXr9QjWS14J20Wwof0bXFIk8ynVqeO2QBVYDvQtfSyw3
	KjmwjmlnKM9SYDcMBCAk1TrtYorqxZs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791424211; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=zxvr0RhVyqkVNwZlzTLbBqT6dNG/BVYIaMV3U/7dCnQ=;
	b=lcu90nEA2d9uF2CR3K9U3f4L1oYvt70acnhZzdl7Dc9psbfgU0M6DbVtXW0LCeXhC513BSne0dySVHWNUpfkOYDR446tCxJ+FKuca5b3AuJ1Ygqd3PANCqMX0riUsnX39b90b18F5FML35x+Uh8HFOUQ4I72NtsNzIndUfdBlok=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XCIIuQW_1791424207;
Received: from 30.74.144.149(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCIIuQW_1791424207 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 09:50:09 +0800
Message-ID: <a14c2287-8d7f-468d-b0d4-1d445d2be277@linux.alibaba.com>
Date: Thu, 8 Oct 2026 09:50:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 07/14] mm: shmem: allow THP support determination at
 folio allocation time
To: Luiz Capitulino <luizcap@redhat.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <f74ada750d1910f8ea7e55955eb0c330747b93d4.1789695931.git.luizcap@redhat.com>
 <b63f546b-ee92-46c3-85bd-bc64dbaae367@kernel.org>
 <0162d0f5-8e75-458b-a0a1-6071f46d4b35@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <0162d0f5-8e75-458b-a0a1-6071f46d4b35@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: djjwtxmm56bc3tkt6k978xg8ohmijssc
X-Rspam-User: 
X-Rspamd-Queue-Id: E942E1C0005
X-Rspamd-Server: rspam08
X-HE-Tag: 1791424213-333495
X-HE-Meta: U2FsdGVkX188AbEJ5c0byKs+NGfMfM4qWUkFT3x6WQEh/WS9gX4vb+Nm+o8Nc6GH3pZK8e/Thz524e+VDa77Xb0qmZVY6gVAgP5CijlgM31yDBseEOwiXnj51QtEKIKXil4Q3CItHvIM1GIT7NfhSrZNXqt61Hm3UTDCWO4FSqaIM36nbQDSelMfYVHG9PZ4SOwrtVety63jCtgCbD37OGKkSIVcixECUMMylHR6SlqbVlbueeqetO4XT61li+EHDgP1T+qhU7lUuBN8LyPEvtBiMMopyn5zdNYx8f4VsF6QPeZ///oXU800rkJsUapwTHKPqP0T7fUgQFdOTS4Zq6+iV9oohoCSM2uT9f8KOu750DgO19skdOvOr0A6BQP1Mwajk34msr2BZLR/Oq+db+WuKfLzIaDBRiQ5WTdKy/asfjuDk/GPU08Fr8HYGUr6wRqTLjMesBdU9HP8rxlpyIgWKP6m6KlOPWgRv1Ik7DyxduT+VL6B6QCGGSMpjJ0TYF+KqfVvCL47JVcrq6c7yWFPLEwaujL44fXBBytEWWL0GM176/XBusvz1aukisup/M2fdHIPO/jSif2hJbKDlPeQqlV1WEwI0VCXD1TJCwFC/qH8KLxt2XZlDtV/DGOvgUQa+aND7YajF3D1yWefwt451L3KQHbcpmgYAsfkI68ExVcps1cDz5WwKoqyQNqYnmY50l+d0Re1OhWG+N/YlvJsOhQicyyGDAlx9drElPGI+m9NVtSsOSDkiYPvUVS/fD2k1Lm3JzKD1PYN+KbeSbtg6sPuVYA/2dhy/JSJxQtgnSJ4b2TADwwfIKILqfRHajNrZj2AHsdJqUwIFzBH8WMBKqQdQMSHZWBUDUGitu4y4oSBgSZH8c8Nb9ngIznzeN5R3booCZF7WPPpvby/Dpat6oVBviJLUHFWrBhrC07dVskuzv7GY8Kh9olluU63DK4LvlheHxUoIAyZMVT
 oeZ3NrgD
 YoyfkJse9uhJ+KYvffA1+4gh88WLvzqRo8Ph4DVLVqS/Svtc8JEGtifxlBH/hPJNGv8ivTzb04xWzSoi9uRhdnP8dpONNmOactZGEHGohpnrHkCi5DjXZfCZ00FXttzRxc9aewHK6R//CWbfmx8lZQT+7LKSad+Ny63598Z/zu4tQFFJLItbPt8NIQwjGOqF/XiPcOmCYMDfcS1IrHyhQ3iEPuQe4ctLR4KVs0mBCUL5RTX/mQtdif+r8U5XcEJNNEBMZr14gkcSDL6SS8usQD1KClz6Mszj4mr+xn3RFcZq7sWzCwfdHdSHiDIXpeivHHAZAV45xyfv/4shH3veV0XS0aNBUBjX4/Hof
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/3/26 11:09 PM, Luiz Capitulino wrote:
> 
> 
> On 10/2/26 3:23 PM, David Hildenbrand (Arm) wrote:
>> On 9/18/26 03:45, Luiz Capitulino wrote:
>>> In order to enable THP support in shmem today, besides the user
>>> configuration required, the CPU must support PMD-sized pages. This
>>> is the case because of the following has_transparent_hugepage()
>>> usage:
>>>
>>> - shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
>>>    if the CPU supports PMD-sized pages
>>>
>>> - shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>>>    the code block calling has_transparent_hugepage(), the
>>>    has_transparent_hugepage() call is exclusively checking if the CPU
>>>    supports PMD-sized pages
>>>
>>> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
>>> in all cases, shmem can determine THP size support at folio allocation
>>> time. Therefore, drop the has_transparent_hugepage() usage listed above
>>> while keeping the CONFIG_TRANSPARENT_HUGEPAGE checks.
>>>
>>> Additionally, we need to check if PMD size order is supported in
>>> shmem_getattr(). Use pgtable_has_pmd_leaves() for that.
>>>
>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>> ---
>>>   mm/shmem.c | 9 +++++----
>>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 776dff8a848e..930657d05375 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -690,7 +690,7 @@ static int shmem_parse_huge(const char *str)
>>>       else
>>>           return -EINVAL;
>>> -    if (!has_transparent_hugepage() &&
>>> +    if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>>           huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>>>           return -EINVAL;
>>> @@ -1524,6 +1524,8 @@ static int shmem_getattr(struct mnt_idmap *idmap,
>>>       generic_fillattr(idmap, request_mask, inode, stat);
>>>       orders = shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0);
>>
>> I'm curious: why is that not handled inside 
>> shmem_huge_global_enabled() ? If PMD
>> order is impossible (well, okay, it is possible, but we simply cannot 
>> map these
>> things through PMDs), I would expect that we never list them as 
>> "enabled".
> 
> Yes, you're right. What about renaming current 
> shmem_huge_global_enabled() to
> __shmem_huge_global_enabled() and then having:
> 
> static unsigned int shmem_huge_global_enabled(struct inode *inode, 
> pgoff_t index,
>                            loff_t write_end, bool shmem_huge_force,
>                            struct vm_area_struct *vma,
>                            vm_flags_t vm_flags)
> {
>      unsigned int orders;
> 
>      orders = __shmem_huge_global_enabled(inode, index, write_end,
>                           shmem_huge_force, vma, vm_flags);
>      if (!pgtable_has_pmd_leaves())
>          orders &= ~BIT(PMD_ORDER);
> 
>      return orders;
> }
> 
> Would this be acceptable?

Not a fan of re-adding the wrapper. I think you could refer to the 
changes to shmem_allowable_huge_orders() in patch 14 and filter out the 
'disabled_orders' in shmem_huge_global_enabled() directly.

