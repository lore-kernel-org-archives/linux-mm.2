Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C49C87FD2
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 03:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 103FD6B00A5; Tue,  5 Aug 2025 23:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC5D6B00A7; Tue,  5 Aug 2025 23:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33B96B00A8; Tue,  5 Aug 2025 23:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE1036B00A5
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:24:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67D911602B0
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 03:24:56 +0000 (UTC)
X-FDA: 83744890992.06.CBBDA12
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf21.hostedemail.com (Postfix) with ESMTP id 694981C0005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 03:24:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754450694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byl3r5TLhPUqMNZqcLKEyocLYvWnmEeMUh9wlTtDSYY=;
	b=0P6bA1F4a0izHpRNBB09dGB9Ws0cIOwDEa3/IL2cwacyqxhUbSlbT5omwcfH3783dH3OO/
	VwHjeGzFKtFNVWy0KfZtuHCAMsj0gvqAhA0YEkf4Ot+W1yk1FSfdzJsVzi8NQHfSJTP5Md
	M7xT6ucwtn+QXlabybl/jAgdNQP5Zuc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754450694; a=rsa-sha256;
	cv=none;
	b=xIzvMQQm9pNAaD75Nx5yr4ziV3VtFG2acSbsm5RQJhq1wETTDWMT0G2XznXM0I0gnlQnYR
	XsxRYYuMZ58rEzxLSUmriHRc1CCrRmbHIJTr2SLE4kYpBKCZycHOByz4gT80JbkfA/eLCB
	cz8HRPkL69zZ7AO8fe8JVfXEvsiL2wk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bxbBb5zxtz14MFl;
	Wed,  6 Aug 2025 11:19:51 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id EE0111402CC;
	Wed,  6 Aug 2025 11:24:47 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemo200002.china.huawei.com (7.202.195.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 6 Aug 2025 11:24:47 +0800
Content-Type: multipart/alternative;
	boundary="------------I0yCxJ492KpW7SSbSelyvlEH"
Message-ID: <35e24029-d58c-47e8-b5fe-e182f143ebff@huawei.com>
Date: Wed, 6 Aug 2025 11:24:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
To: Miaohe Lin <linmiaohe@huawei.com>
CC: <wangkefeng.wang@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <xueshuai@linux.alibaba.com>,
	<david@redhat.com>, <ziy@nvidia.com>, <osalvador@suse.de>,
	<linux-mm@kvack.org>
References: <20250806020520.631203-1-tujinjiang@huawei.com>
 <1e63c37f-8eb2-865d-d3f4-9ef928f1a959@huawei.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <1e63c37f-8eb2-865d-d3f4-9ef928f1a959@huawei.com>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspamd-Queue-Id: 694981C0005
X-Stat-Signature: xims3a7r5ihwp1m3ca9cn15wuk66gmxt
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754450692-83451
X-HE-Meta: U2FsdGVkX18/LD/t6f7gnCFB/p1FM+oyuG36QGuHY2hATDaJhWn0kdjqBi9BX/xUPVtututMz6wAXtO/RuuddCVUOViq8gbYU8V+aH9bNp1WVGgcGqnd479x0HFq1VDbk9VpbP3fiEHoXD1rSst2b9bya66ZZAfl1ZXmrgfq6JlDFp07NBDb/VFco/w8O++GVukIB7L7B6Vuinn5MGZAPwzFRbDjLcGYeTjE5FLXZkzwf0mq4u1nWHTGVy/sffOF07qdXVDuBjNfwkC9MF46vo/hN2DRuEQre0q95wKDsYJ/wM0O1Pw2izvRp9oe+9lYNBSFbJ+H5Qt1zCwTaCoEw4ZkGI1u+ZGZDo+r5S1z8mAV8k4weFG9s4g5cTxylpswJOZdfHpWDVphi35g+Gr3CymtigOkNa7lAVDoRrlazCBm5OvW7S44i2iWOH6UCTiGV6N8IOyHPdPFAbgDwRfMINO5Vj02kPINuIKXQmYePZMdzgcrgrD37YNkNWugGm84UB/6BebkqGPic9TLfCqznqD9pBYZv5i7/Eiix6cXtzUVLK3EmSfTjh57r78lLhd8SUjICMo1oPhAO88mvHqIoZmnVzqcf6xjWT1naimONUhzJoMOj9WAHCjWnc+7enwJwcpsAXwyGYCgkW+gjlPiDASQT1HxUw5XCjZ60K4jfG0WLvhbY5dSGDMpr2XdFWNj2YzrruYJN0moX0NAPFmMZHfc2p1MlI+EdwX4K9MrKsim6RLyI+i1IIsvW0DPAkij9qu4KNCf6xlJd51mSv+0lWCbSAIR8jvhvBVjtAXiRiTq4K/BpouJoMJ7tM1s0dcpooPShIkYdx4ULiQxLDJLmYkqi7wR1C9Y8ekoeMB9BD1/RJiXRewrzjvWX9Yw5a4K3NP09uUNUCdIkcBOBoQzpIEZWmuCsMskOvf71v/9AjQukbRQ3nPMohdGhQ88gOLSjxrwsZNA9g1G7VyCuGl
 z2I0rXyi
 GzmGPxcQjUh8QPwFBpkFQYVbTh3xc5/P9nIWO18Wh54Ig6Aj1JqOp0eUBPZcYi3Y2OOWecc6CzGF/JYjH9DkQiFZnLB0jyd30oNTxYlHsyStslR46tFOxx8V1VoI/3J92iwMRwoPA7CHMWzguUb5lqlQ+wbfBgnZkv/dfSGHzoUNHW9H7Zisq53arbF9CoFUDrpZeLtaCUGaAJwh2ed03JgoHF77MCgx7dnpjRd3aWGmVPvJCWiorThck97taTcQ2L9wjgLebsX6K8izmEIN6xpZBMKnvsje2aSYiUbYgUD3/AMEExRmBVh+5v89EApEml9CwaAG4CQB1Cf/70hc9Q9QIg152P1d4sGvlr0Q9I1I2ZqYfH7LLmO7iZRbAgOOsSPm+ul5e44e8bRdNNSTK+A0NBYmbi2uK4NMkNGPJtYz2NPEWiq0t41jESK6giVNnjTOUotqzFWRBeX48CUZjraITiluLWmzUa4Rhazu9CIs0SGU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------I0yCxJ492KpW7SSbSelyvlEH
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/8/6 11:05, Miaohe Lin 写道:
> On 2025/8/6 10:05, Jinjiang Tu wrote:
>> When memory_failure() is called for a already hwpoisoned pfn,
>> kill_accessing_process() will be called to kill current task. However, if
> Thanks for your patch.
>
>> the vma of the accessing vaddr is VM_PFNMAP, walk_page_range() will skip
>> the vma in walk_page_test() and return 0.
>>
>> Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
>> with recovered clean pages"), kill_accessing_process() will return EFAULT.
> I'm not sure but pfn_to_online_page should return NULL for VM_PFNMAP pages?
> So memory_failure_dev_pagemap should handle these pages?

We could call remap_pfn_range() for those pfns with struct page. IIUC, VM_PFNMAP
means we should assume the pfn doesn't have struct page, but it can have.

>
>> For x86, the current task will be killed in kill_me_maybe().
>>
>> However, after this commit, kill_accessing_process() simplies return 0,
>> that means UCE is handled properly, but it doesn't actually. In such case,
>> the user task will trigger UCE infinitely.
> Did you ever trigger this loop?

Yes. Our test is as follow steps:
1) create a user task allocates a clean anonymous page, wihout accessing it.
2) use einj to inject UCE for the page
3) create task devmem to use /dev/mem to map the pfn and keep accessing it.

/dev/mem uses remap_pfn_range() to map the pfn.

When task devmem first accesses the pfn, UCE is triggered, memory_failure()
succeeds to isolate it due to it's clean user page. But the task devmem isn't killed.

When task devmem accesses the pfn again, since the pfn is already hwpoisoned, kill_accessing_process() is called.
But it fails to kill the accessing task.


Theoretically, if we have several tasks that share the pfn range mapped by remap_pfn_range(), the above issue exists too.

>
> Thanks.
> .
--------------I0yCxJ492KpW7SSbSelyvlEH
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2025/8/6 11:05, Miaohe Lin 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:1e63c37f-8eb2-865d-d3f4-9ef928f1a959@huawei.com">
      <pre wrap="" class="moz-quote-pre">On 2025/8/6 10:05, Jinjiang Tu wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">When memory_failure() is called for a already hwpoisoned pfn,
kill_accessing_process() will be called to kill current task. However, if
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Thanks for your patch.

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">the vma of the accessing vaddr is VM_PFNMAP, walk_page_range() will skip
the vma in walk_page_test() and return 0.

Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
with recovered clean pages"), kill_accessing_process() will return EFAULT.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
I'm not sure but pfn_to_online_page should return NULL for VM_PFNMAP pages?
So memory_failure_dev_pagemap should handle these pages?</pre>
    </blockquote>
    <pre>We could call remap_pfn_range() for those pfns with struct page. IIUC, VM_PFNMAP 
means we should assume the pfn doesn't have struct page, but it can have.</pre>
    <blockquote type="cite"
      cite="mid:1e63c37f-8eb2-865d-d3f4-9ef928f1a959@huawei.com">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">For x86, the current task will be killed in kill_me_maybe().

However, after this commit, kill_accessing_process() simplies return 0,
that means UCE is handled properly, but it doesn't actually. In such case,
the user task will trigger UCE infinitely.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Did you ever trigger this loop?</pre>
    </blockquote>
    <pre>Yes. Our test is as follow steps:
1) create a user task allocates a clean anonymous page, wihout accessing it.
2) use einj to inject UCE for the page
3) create task devmem to use /dev/mem to map the pfn and keep accessing it.

/dev/mem uses remap_pfn_range() to map the pfn.

When task devmem first accesses the pfn, UCE is triggered, memory_failure()
succeeds to isolate it due to it's clean user page. But the task devmem isn't killed.

When task devmem accesses the pfn again, since the pfn is already hwpoisoned, kill_accessing_process() is called.
But it fails to kill the accessing task.


Theoretically, if we have several tasks that share the pfn range mapped by remap_pfn_range(), the above issue exists too.</pre>
    <blockquote type="cite"
      cite="mid:1e63c37f-8eb2-865d-d3f4-9ef928f1a959@huawei.com">
      <pre wrap="" class="moz-quote-pre">

Thanks.
.
</pre>
    </blockquote>
  </body>
</html>

--------------I0yCxJ492KpW7SSbSelyvlEH--

