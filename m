Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 838C5D711D3
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD2C6B0089; Thu, 18 Dec 2025 19:56:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B83B66B008A; Thu, 18 Dec 2025 19:56:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85766B008C; Thu, 18 Dec 2025 19:56:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9801C6B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:56:19 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5DBCAB8379
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:56:19 +0000 (UTC)
X-FDA: 84234404478.20.FA81323
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 73487100003
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:56:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N6+0xoAA;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766105777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t2o/Vumy+Nw5btbRIBN01nzQJNm6p8LL2tmTgt6B/0g=;
	b=T4qVT5C1iz6fShwWg+5Erfu77e8idPvcUWuiVCJ/P2lqnCWvA4pL0hVL8w78/+DZaDckwj
	Um4FfZNbMb10IOAVVITM++Oyfwu21RUmvVnelKg+OgUeledV0l+PBBjAx+cNj5y3CPqh7u
	65sbVoICDvaTr7GqWtzZGS5FBdV42CI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766105777; a=rsa-sha256;
	cv=none;
	b=rtiNYk6MuziCeIhC2/JI6xo4x2HTkjMObASTw5cRBn5bG/fticsaZqPnNfxp1UyXWwB8Bo
	NAM+6iCFoE28dyZYIDfxVu6a/+nKD0RvCSSFrNTjG0urX5aI21KoY1VaQaldquRD0OlueX
	qqI38ba7NcrtPgp5SlnnYLtOsIRZ3r8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N6+0xoAA;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766105773; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=t2o/Vumy+Nw5btbRIBN01nzQJNm6p8LL2tmTgt6B/0g=;
	b=N6+0xoAArOybKVK8gEqXsENA4TNJA/LFzH+WXtdSszdh7Xj945F1iG8/3/0Cp4eLbs1SUr+ainvgAm5lseGsGN3KUKiRptos+lOdtFluJ3P7hqMgFpiV+SiSVVq5NTva4R4P2cG6xqN0NXwy9ocanBSm6fI/vA/L9meZBrxBAPM=
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvASlNx_1766105770 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Dec 2025 08:56:11 +0800
Message-ID: <121c8ffb-adff-4766-aae9-8be6d37d546a@linux.alibaba.com>
Date: Fri, 19 Dec 2025 08:56:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: rmap: support batched checks of the references
 for large folios
To: Ryan Roberts <ryan.roberts@arm.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <545dba5e899634bc6c8ca782417d16fef3bd049f.1765439381.git.baolin.wang@linux.alibaba.com>
 <cb4d7243-d8c6-4706-a254-6f5afc148910@arm.com>
 <89cdd927-fc88-42cf-b8a1-2fbd736d5f7c@linux.alibaba.com>
 <0caffb55-f242-4b01-b60a-c8749aadf661@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <0caffb55-f242-4b01-b60a-c8749aadf661@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i6tzgy14hyb9f4rawgr3z5ss7tewymyo
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 73487100003
X-Rspam-User: 
X-HE-Tag: 1766105776-37586
X-HE-Meta: U2FsdGVkX1+ZGDnr3Dma8dMqd4LQtzHq/eIVrr81e+csym38BcbpoPFSS+OkH/c3hXMOADY4Dzhyb2wS1zV8tDqEqnvkGiqlCIZSy5oJsPkoasYRjP9DUzh5SOZ96v+V4zzDRsmEYZqoNkXRCoOQkqr4dLh34yr94QEchf1ve8UzA34I1uSFIbpcTCnBFFmxDiyFQpdV7QXLU6snRFZsQvHKwRvydcQPvdqOfYSEnEQBPuI/nmNcsKA0s5+QXclBSpcDeSb5FcwGYWXWnqT0KHDWsqJP7WBzFlV78eumSb4cKtiC8GjVTAh/ub2kexhMJGS4FtRp3TMzgsKB11bsIw9mz3LUFEeMRZ4C0IAUq9CxS0d/N5ltzHL1kpLNOWCNZd6kusLbDuvMouMxhoQPl+b3g1rMUQrZVceh0zmmL4h5LZxOHvXz5kWfvlu7BUKs2d163tBnQDkAzM7UJkTejAKrnzn946aNZaVbqhWHxp0M0YHXsQf7KuaDgfI+et/Ue0dcCSGyf9Vf51ts79Ag2I6wWwrU8LP9lLG3gQYCFKK7DDak+vqqGeQGkRAkpfoXR575moBG5ixkNfnKouBnUZmHtgRZMCK+k/ljatJTfE4OSxJ6yiNZqJX/uMvyRMIzVJld7UamqA97ku1yldP3hchf97BpZwTBt8iENA3HDTruUYO9zofncw1CcH4OzkYDRgndSei4HItYAxa7MsqYa1ZmuH+Al0tTU6g8pQhGS72HWUbrsr+BVCbKuRsKjSM3oCEY7Bes9lpsE9fPyo7UhQe8haf2IWyRaf3tVr07m/k9GU/9aaWfovMONFJKbwVp1FRCk69FkloTKZyrEg6NYR3o8ATciqMagTi+p2KWBvN1Bn5DP/e1K4vvnclKhNWi5USjGQo/R4mI6+sRuYXvq5xUqO7/8Z8OWe0JtfxlIJkngXRDf0ETRNvGc9jPHXbhuv2S6vs/nz20HvA0LCh
 bPBqbFcd
 aoeldnc+Zv8ZNq+0ekwur4QzE0oviX4WIW+pNVrqCEQ/pHIU/w0hrOojfMMUEAdqwUzfkaavuGBo3sHcmDZqdcATZKApbuplEYndz+mUg8KECI0mNWZVuGY+i8R0lMFRWPvl8elkleHQQgJDlX1luB+6E7Fi5P9G6WKrAVzbPuu1QnH5t+iS7pvISxUEQgudyys9j9GQ6kxvSg3O0Qnzbn7+4J+6sS1HrbaaNAPKuShFbbQYehZ7JM6FuQhKuKe8c5sxNTAhIZKR5Z/2nw2iYb7LL3SqfNMD6JzCgLZxkhXmDNOA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/18 20:08, Ryan Roberts wrote:
>>>>    +#define clear_flush_young_ptes clear_flush_young_ptes
>>>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>>>> +                    unsigned long addr, pte_t *ptep,
>>>> +                    unsigned int nr)
>>>> +{
>>>> +    if (likely(nr == 1))
>>>> +        return __ptep_clear_flush_young(vma, addr, ptep);
>>>
>>> Bug: This is broken if core-mm tries to call this for nr=1 on a pte that is part
>>> of a contpte mapping.
>>>
>>> The similar fastpaths are here to prevent regressing the common small folio case.
>>
>> Thanks for catching this. I had considered this before, but I still missed it.
>>
>>> I guess here the best approach is (note no leading underscores):
>>>
>>>      if (likely(nr == 1))
>>>          return ptep_clear_flush_young(vma, addr, ptep);
>>
>> However, I prefer to use pte_cont() to check it. Later, I plan to clean up the
>> ptep_clear_flush_young().
>>
>>      if (nr == 1 && !pte_cont(__ptep_get(ptep))
>>          return __ptep_clear_flush_young(vma, addr, ptep);
> 
> Sure. That would follow the pattern in clear_young_dirty_ptes(). Please use the
> likely() hint as is done everywhere else:
> 
> 	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))

Sure.

> I notice that ptep_test_and_clear_young() and ptep_clear_flush_young() are both
> testing aginst pte_valid_cont(). These could probably be relaxed to pte_cont()
> since it is implicit the the pte must be valid?

Yes, I think so. I can do a cleanup later in a separate patch.

