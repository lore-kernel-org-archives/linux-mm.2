Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBB03F9EDEC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 15:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204AA6B0088; Wed, 22 Apr 2026 11:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC3A6B008A; Wed, 22 Apr 2026 11:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118D06B008C; Wed, 22 Apr 2026 11:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F32CC6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:03:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8AE5A898DA
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:03:23 +0000 (UTC)
X-FDA: 84686510286.05.EC92160
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf16.hostedemail.com (Postfix) with ESMTP id 93C9318001C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:03:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=mCxq2pFV;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776870201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xgW+47Jv/ylGNBGjB8siOtex/NYpwe6kH9Qi/e5jtU8=;
	b=y4T02JVTiEdC9nVMZx8Sz0Tp6Y7pHDiRfiWEcMbBzV5oUkzQ+eHxolgZtflF6wvsb0aLg1
	UXpS4fEVe+k8KoUipAkEXJF9ab7Gr0ueFISjSVOg1YKQmhBCwrApzmSplghOH5gY1qk83u
	ewzAKEjM6iRmsRSXiTH2HCH+XkeUQXY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=mCxq2pFV;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776870201; a=rsa-sha256;
	cv=none;
	b=L7avASemAMEZqUmlxpTDG7DcpK9YbUDhTxVT7+19cEto8PwJ7qWpvrc5Fvo8NegO4yVN30
	VTKeduJn+8KnJSyEICI0ZUWj3NkseirxukLsH8rp3Tyehwrdx32MyyCKbT3mRDbU4oQR6F
	blGRZLR6dRhVtg32NAeixtcvCrgw0GI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xgW+47Jv/ylGNBGjB8siOtex/NYpwe6kH9Qi/e5jtU8=;
	b=mCxq2pFVcDbRoLzB4u+FHEoJSVYkCatnbfup/6NCAJ9o92CbkIYDPUx0CCQEdX1Ir+btXrNsi
	sNblvTMnprDTcvTKpw8zJPqylh5h1axy2wb/7eNAcFAlZPt/KBbQn6qwakFc4eHHsbVoNRK1F8O
	2/dMEm9p/1+4Cw/inuhPCZc=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4g12P93jxCzpStt;
	Wed, 22 Apr 2026 22:56:45 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 9380D40538;
	Wed, 22 Apr 2026 23:03:10 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Apr 2026 23:03:09 +0800
Message-ID: <12bdade5-b239-4456-bb5a-f2648c867db8@huawei.com>
Date: Wed, 22 Apr 2026 23:03:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: shmem: always support large folios for internal
 shmem mount
To: Baolin Wang <baolin.wang@linux.alibaba.com>, "David Hildenbrand (Arm)"
	<david@kernel.org>, <akpm@linux-foundation.org>, <hughd@google.com>
CC: <willy@infradead.org>, <ziy@nvidia.com>, <ljs@kernel.org>,
	<lance.yang@linux.dev>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
References: <26f954be62348591e720c4e8b7a9099b74dc1d6d.1776331555.git.baolin.wang@linux.alibaba.com>
 <1b3c0401-6d10-4a28-97c8-8e3858d8dc3d@kernel.org>
 <015de194-99b9-4f9e-8c89-d35807c6fd08@linux.alibaba.com>
 <ec6aaf0e-90c4-44e6-97db-041bff8644e3@kernel.org>
 <dee02e5b-653e-451b-8f59-7196bdae8f88@linux.alibaba.com>
 <07e26d39-6155-4661-b3df-c2419535ed43@kernel.org>
 <f9508e75-789e-4eb8-b09e-b66a8676a6b0@linux.alibaba.com>
 <bea6080a-850c-4b3f-bcc0-719efc372e72@kernel.org>
 <116df9f9-4db7-40d4-a4a4-30a87c0feffa@linux.alibaba.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <116df9f9-4db7-40d4-a4a4-30a87c0feffa@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 93C9318001C
X-Stat-Signature: y73hr9oojqac865iwhgyhxrj181rurhz
X-Rspam-User: 
X-HE-Tag: 1776870197-489860
X-HE-Meta: U2FsdGVkX1+8aW7a0/XVYu2LmNL1sZlnrCm/o0U8co1YaSxR6yz5HNrT83gFUENbTEeF4XDKiLNu3SILdquKUgeRgG268AUR0jlNUbpRVczs04LVBSwHb2pEgdZe24jZQYD3yA9oWLr2++XLqHdIEFxFpuVUJJzT3E5Xvyr2t+vPHR07UJ4PUXWTKwQJyQvN7LXlInv35eOZ/HDLJK4+k5pRI2XD965oh9RKGEXkktx1B5QxdBJfQg9meOLdFfTAYJjYQ6fJ7xRHszVNB4aCXE/x1IQmpozHMcXdjQBi7xtnG3xpjULy27Yh5Z0xaunx28pf3wlejSXk2usFRktRXg7Zbg2guNjz0t/Sxxvqmm07wf0p85C0mnaaudFSuD4waXuMWik3CyeiztexP+Rc/J6cPUrVElTSyQFLWd9y20CEVZ75u7Rfgq4ZHIf3axxgHgnCLyMuvlHwQx3jtIcTAiJlny4F6MtuNB1y+nR89BiaX2E3A2HOoZODFxGkj8QFjo8EvPm40DlTD3XYY3oWb+eKmByfmcfugMigKJMzidXGcZu+seE7KjFUM0SceZBb8qk8Z4+j3lNEGN9F4+/+fRncO5mK2/BgmGXGX9WdF376Vyr6KXvIP5z8FCfBrHSyismaIkApNKabPIAcznmsHsHSkViVmuYg4i30mO/sYSB23T9vJKc8iB5XZvRMeF1OG2Mt3wyTYLTtQrFkO4FyxfzYoVt9s5U3xaFRCoh2OEimZZFJ+0E0NJ+TCgTFtFQLAKu+OhOSCnYC69lT1tKpn8l33crq4YOPpcF6hHK9XB5DOAheYBzuWqBlIo95ADLxIIFNOrViJH1imJNC5Y1qOFYm7Z26+bZGBzswAGocPVUCZW1RTX5frFmwGuSQJ/0j+MUVRB+1P9uOM1QQVNFoqvrMHSDPL5riNPxfSzPj9zP4Dt0c7fkeMZ5cGH03f2jorIaJ/O5n26PFn0k//nW
 +B3Pwulu
 Z33aYrPp2RViGxAidWvzbbVRJrrLIv0H46ZFEmAO0rw5wd8Zbi8sHgbIeQUX+XIzXt80pLiN5QYQOq7Q8bL2R5NAvdugGIS+4j1D/yQLQM0Ot9cz40Ucp6iuuPQH4WAaMfzSgKqU5C7SHOPURuOrF6LvJpog+7DbVtdoWrhqOlOLwJkDBj1fscVYpFwPyQZuWub56msVZfsCIjk4fr/WgbE5XKHz0NVEGDF3Ad/0JswuXGZHwDHhPj/r/GMtC+xKDZ++g+R8oKb/4mTERSipnMXUJnU0SdrzjDpEVkgRFG9ZH3i8wxK3TBLI5ZsXg8MNkxLx3hqL5qkKTfS1Ns7eLyryfw6GBgxdMYNguRQ2rFbEVvpcKBmgSQCYi4WbQzR5h+DES/zzsjy1iPDSs6ij1F4P3bTcwlC6v8SozLMj43Y9E5IM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/22/2026 2:28 PM, Baolin Wang wrote:
> CC Kefeng,
> 
> On 4/21/26 9:39 PM, David Hildenbrand (Arm) wrote:
>> On 4/21/26 08:27, Baolin Wang wrote:
>>>
>>>
>>> On 4/21/26 3:00 AM, David Hildenbrand (Arm) wrote:
>>>> On 4/17/26 14:45, Baolin Wang wrote:
>>>>>
>>>>>
>>>>>
>>>>> Indeed. Good point.
>>>>>
>>>>>
>>>>> Not really. There could be files created before remount whose mappings
>>>>> don't support large folios (with 'huge=never' option), while files
>>>>> created after remount will have mappings that support large folios (if
>>>>> remounted with 'huge=always' option).
>>>>>
>>>>> It looks like the previous commit 5a90c155defa was also 
>>>>> problematic. The
>>>>> huge mount option has introduced a lot of tricky issues:(
>>>>>
>>>>> Now I think Zi's previous suggestion should be able to clean up this
>>>>> mess? That is, calling mapping_set_large_folios() unconditionally for
>>>>> all shmem mounts, and revisiting Kefeng's first version to fix the
>>>>> performance issue.
>>>>
>>>> Okay, so you'll send a patch to just set mapping_set_large_folios()
>>>> unconditionally?
>>>
>>> I'm still hesitating on this. If we set mapping_set_large_folios()
>>> unconditionally, we need to re-fix the performance regression that was
>>> addressed by commit 5a90c155defa.
>>
>> Just so I can follow: where is the test for large folios that we would
>> unlock large folios and cause a regression?
> 
> I spent some time investigating the performance regression that was 
> addressed by commit 5a90c155defa ("tmpfs: don't enable large folios if 
> not supported"). From my testing, I found that the performance issue no 
> longer exists on upstream:
> 
> mount tmpfs -t tmpfs -o size=50G /mnt/tmpfs
> 
> Base:
> dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.2 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.2 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.1 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.0 GB/s )
> dd if=/dev/zero of=/mnt/tmpfs/test bs=3000K count=1398 (3.0 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)
> 
> Base + revert 5a90c155defa:
> dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.3 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.3 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.2 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.1 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/testbs=3000K count=1398 (3.0 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)
> 
> The data is basically consistent with minor fluctuation noise.
> 
> Later, I continued investigating and found that commit 665575cff098b 
> ("filemap: move prefaulting out of hot write path") fixed the write 
> operation performance.
> 
> Base + revert 665575cff098b + revert 5a90c155defa:
> dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.0 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (2.9 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (2.6 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (2.6 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=3000K count=1398 (2.5 GB/s)
> dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (2.5 GB/s)
> 
> We can see that after reverting commit 665575cff098b, there is a 
> noticeable drop in write performance for tmpfs files.
> 
> So my conclusion is that we can now safely revert commit 5a90c155defa to 
> set mapping_set_large_folios() for all shmem mounts unconditionally.
> 
> Kefeng, please correct me if I missed anything.

Hi Baolin，I found my testcases "bonnie Block/Re Write"

./bonnie -d /tmp -s Size (size is from 100,256,512,1024,2048,4096).

But the dd test is similar as well, and as commit 4e527d5841e2
("iomap: fault in smaller chunks for non-large folio mappings") said,
the issue is,

"If chunk is 2MB, total 512 pages need to be handled finally. During this
period, fault_in_iov_iter_readable() is called to check iov_iter readable
validity. Since only 4KB will be handled each time, below address space
will be checked over and over again"

But after 665575cff098b, fault_in_iov_iter_readable() is moved, so the
issue should be fixed.


+CC Dave，

Since 665575cff098b is works well in generic_perform_write(), I think we
could do the same optimization in iomap_write_iter()? but it seems 
maintainer forget pickup them[1].

[1] 
https://lore.kernel.org/all/20250129181753.3927F212@davehans-spike.ostc.intel.com/ 





