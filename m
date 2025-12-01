Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D53CFD116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 21:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1228F6B0008; Mon,  1 Dec 2025 16:13:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA5C6B000A; Mon,  1 Dec 2025 16:13:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00FB56B00B3; Mon,  1 Dec 2025 16:13:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E57246B00B1
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:13:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 997F513AB5C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:13:27 +0000 (UTC)
X-FDA: 84172153254.24.6A3CC31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C0C6020014
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:13:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OiyqOibi;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764623605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ri7Zl4xmiGDnzA5C6nqQPErmsKx9UUZwX92F74G5xoU=;
	b=SIbkACcDUxy6DaAmfS9ODS71Q0hMNeuHROb55E9EkeLfZS3xAHWQsIsXUoc7AV9TvctPW9
	MOgVfwX2KbU9ebuoI1KzBDorvHxgftpEJayppIfvCTV5OlpwTqHnJrtT6EAKP7Xd64QFPl
	NP+ajCiFarXa7X8icXZSIwPkl85262I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OiyqOibi;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764623605; a=rsa-sha256;
	cv=none;
	b=J+VHonsbUPDYaOpGC4M3m6LO8FZ2ryfiNw73iPOc/H0T8znJ1t3gnaF/lfINsJVslPprPD
	+axq67wgGZPYWsaWIhsdoEhAbY8Yefgtge19v/RfULhnW8895P50KTVUxRJzpl4cY353St
	D9R8Ixjc9GnFGzlGun/63gshzb9cI18=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 743CA42A63;
	Mon,  1 Dec 2025 21:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF63C116C6;
	Mon,  1 Dec 2025 21:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764623604;
	bh=kZqn2EZcd0EeVcfwGvgsusMd/R4Px9rgzyWItI/Or9g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OiyqOibiGIEk4eJqrQQ7oU6acf71C5hEfjVo/Pta7We0iNTrdbxF1ysYUDwWkOECv
	 OS9o0dsizOCi+vp73tjG0hbRZvPFJiWnD4YfSNYpcdQDmXgFXGGo4RfAXoeGuijHJJ
	 E8mhNB7ehJAmWxKjuPQphWmixYEtdKuyXY0cbnPxeVC2iPoA61B1ekM5AvAOqdyjHq
	 l7dgrC0aJHatrdRo0vrxH1gf4MpHea+AfAs0g9EyxGfzcsj30NmADp40AZfRsM6J2Q
	 H2CT4hHsmXIC3ILJHtT/rj4ngGorcHFgeBtWXno9RZZIYhwCqdae02C/lCdVWoi2yl
	 jQgpItYIi9zCg==
Message-ID: <e031bce7-13d4-4404-a714-0d0fc87dc96a@kernel.org>
Date: Mon, 1 Dec 2025 22:13:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [mm] f66e2727dd:
 stress-ng.rawsock.ops_per_sec 46.9% regression
To: Sid Kumar <sidhartha.kumar@oracle.com>,
 kernel test robot <oliver.sang@intel.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 Liam Howlett <liam.howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
References: <202511252236.33b899b3-lkp@intel.com>
 <16995732-b7b9-4121-be36-e912a4154958@kernel.org>
 <e32f61a9-0461-444d-b008-bb09a3d85510@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <e32f61a9-0461-444d-b008-bb09a3d85510@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C0C6020014
X-Rspamd-Server: rspam02
X-Stat-Signature: m7aowgxzqnwh5n7nbm64fa8mjgonshsr
X-Rspam-User: 
X-HE-Tag: 1764623605-737427
X-HE-Meta: U2FsdGVkX19uV2jnE0B7B0Ls/7WHPKfathOyRmtx5UfGPbHQOIctDtKRWXtEjKfoiqFCgmmcl8jZQBkziWc0hVUrzBV1U+/z3l/1xQCr8KCQ77q5lLKIdREY0D30jSRGjypgYQ4b72LF1XdNmcX8ih5L2DvSbfU1wWBZLZnOWMT02N0ABqliTDr1lSYW5OV68ZsKrAwBJrecJJCXzF2n+4SKCAlHpq+215aPOqniIMJJvfnR/N0ZzVn4DLUi2Jx3Xhn0yeCe2JiM3CwCpWIUrqnChYY2qq/58Jz2sNa/b2Ixj9lEd52mCGjZG3DiwkTnfMjrk2iVnA9wqO8YYc2gK7LZElWWsMdFpfd6z8aaHAIIeS6x7U3ZTceiHvaxasnCgXMrOSsu+Pit2XoJgkvrt2QWL2LylU8YpcZAkjmdDLyR/BZPiceWc3vCd0NY2Blekr9lrY6Nwfr/NlVSTtcqKWeW70C3gld202dkAlf0rIfrkeREAs6uOP1bV4T/lSWagN1LbSkntECp8JI1UoSp0Mpvp7NobxA31nwpROvSQYhpmgSaT90vzVCbXCEFEPaYYN/iv/rK5o5yyogJ24mysj+Mtc8WKBmy8fZ8MyfR+0xSilSMsC4vCUXIG5ta5/voHC2DSwHiRhUWpIMrfCellhKdz6duKjZZgy2GIJnXo+pFhUvtrfZfAfovCmcktZuVMawmRBOtr5vzWdsEP6iZ4J7yfpOaXJSIC4S+YMHA+sUjz4SfRtdlSRRtUMxGxiGNP/YMlaqjroErsUO9NAXEcyHJhXeG/9AA33gi3UhuyKmU/4anVy8THKA+aWMy6GzbgiVTfM1FsKqdikcE13wZCRIEoKL4kYPJi3xlzR1RLHJFjKAOs0NMwYCW7VR+pxt2sO4Pq0neR5tPvo3npqvJGPHhPwSqAcSqL6SLnGbpIz9FhjWlj3ZOftKLqyRY3cSTojdNJf7dPWQJHulshXs
 9Z1J5Qed
 McD99MhbozT+D8kuQf05l2T3O8KVKi1LVjAS2+qL3Xt2Cwh9fWn6oV1oq9TtxfPGnshQZ0jqBTMWIEga+W7Ta6FqEQLWLyHwPmSSAWIG9pDNprCD5uIt/tD8r1xcM4skpzCZPrepOKkfz3s6nQxXKQgAHphiB8OytVVZnUF0xiBoU19OPpFdSavW+tSq5jMkeoxAGqK2iF+v1y701EMlFDhaKpYOTAcFr6GS6nRpFUQ15ZJIa0M54H/2it3hyfLqthFvulytqAtXBeSXC87GZAaP1C3WY3Hf4kfqtvCDlrhpYfxB8F/LVDcTFBdRcrcPOAKWykyjMFAISx1RJw1SV3ZMRxEXHQJ4/8A9ZSDl6KHfm7WbIGtbN7t+BhIh+LsfCWfRj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/1/25 21:56, Sid Kumar wrote:
> 
> On 11/26/25 3:49 AM, David Hildenbrand (Red Hat) wrote:
>> On 11/25/25 15:46, kernel test robot wrote:
>>>
>>>
>>> Hello,
>>>
>>> kernel test robot noticed a 46.9% regression of
>>> stress-ng.rawsock.ops_per_sec on:
>>>
>>>
>>> commit: f66e2727ddfcbbe3dbb459e809824f721a914464 ("mm: huge_memory:
>>> use folio_can_map_prot_numa() for pmd folio")
>>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
>>
>> Unexpected, but maybe simple a symptom of doing the right thing?
>>
>> "which skips unsuitable folio, i.e.  zone device, shared folios (KSM,
>> CoW), non-movable dma pinned, dirty file folio and folios that already
>> have the expected node affinity."
>>
>> I suspect skipping shared folios or dirty file folios might make the
>> difference. The benchmark results would be misleading in that case: as
>> we shouldn't have migrated these pages in the first place beforehand.
> 
> 
> Reproducing the benchmark and adding prints to show which condition the
> return false occurs in shows that:
> 
>       /* Also skip shared copy-on-write folios */
>       if (is_cow_mapping(vma->vm_flags) &&
> folio_maybe_mapped_shared(folio)) {
>           printk("false at is_Cow_mapping\n");
>           return false;
>       }
> 
> virtme-ng% dmesg | grep is_Cow_mapping | wc -l
> 25302
> 
> is the condition that now fails and leads to the regression.

Okay, as I thought, it's rather a "doing the right thing". At
least doing the same thing we do during PTE faults :)

This check dates back to:

commit 859d4adc3415a64ccb8b0c50dc4e3a888dcb5805
Author: Henry Willard <henry.willard@oracle.com>
Date:   Wed Jan 31 16:21:07 2018 -0800

     mm: numa: do not trap faults on shared data section pages.
     
     Workloads consisting of a large number of processes running the same
     program with a very large shared data segment may experience performance
     problems when numa balancing attempts to migrate the shared cow pages.
     This manifests itself with many processes or tasks in
     TASK_UNINTERRUPTIBLE state waiting for the shared pages to be migrated.
     
     The program listed below simulates the conditions with these results
     when run with 288 processes on a 144 core/8 socket machine.
     
     Average throughput      Average throughput     Average throughput
     with numa_balancing=0   with numa_balancing=1  with numa_balancing=1
                             without the patch      with the patch
     ---------------------   ---------------------  ---------------------
     2118782                 2021534                2107979
     
     Complex production environments show less variability and fewer poorly
     performing outliers accompanied with a smaller number of processes
     waiting on NUMA page migration with this patch applied.  In some cases,
     %iowait drops from 16%-26% to 0.
     


I think the reproducer would actually not care about anonymous folios, but
not sure if that would make a difference for the benchmark here.

-- 
Cheers

David

