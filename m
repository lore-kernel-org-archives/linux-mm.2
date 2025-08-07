Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659E7C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 11:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91906B00BB; Thu,  7 Aug 2025 07:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43B66B00BC; Thu,  7 Aug 2025 07:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D31136B00BD; Thu,  7 Aug 2025 07:13:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C1A086B00BB
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:13:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 694D11371EB
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:13:48 +0000 (UTC)
X-FDA: 83749701336.11.9C33A43
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf15.hostedemail.com (Postfix) with ESMTP id AD27FA000D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:13:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754565226; a=rsa-sha256;
	cv=none;
	b=fu3Sw6LZEx0rQiYasKB4rZ+DLmRnq68zS4Nz+TKR3zZjEhwOvJsQQ32N3oOqdIBExUsnDR
	BTQi2L3dZXa2mBR/eL9xzLZwcneSU5FuaqrGd0iGqTiE8A4FgFt4GbNQt46b2ur896ToEI
	NQW2O/79zHHeli9TTTbuEIQw//C+Ly8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754565226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gGSTI6myYQl0XUavZkP9NOKulH5P4RiptcezoqKtUsw=;
	b=wAzqr42+Mqg4XBvI+ff58rIqFWEFDZd+cLKrmt2fJqcJIEMh1jl85upVzxMoRucAdH1nNa
	PRsNWEvl0VXYR73Vtm2Tr0eLadnp8TgVRXNpHXhG+cK2Dntd5FlWCEHMhO9Q9Ek8seJF2t
	+IcFVbzHtzCIh70nZMI4VSs+dZKaZtE=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4byPbx1336z23jjv;
	Thu,  7 Aug 2025 19:11:09 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 44B591A016C;
	Thu,  7 Aug 2025 19:13:41 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemo200002.china.huawei.com (7.202.195.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 7 Aug 2025 19:13:40 +0800
Content-Type: multipart/alternative;
	boundary="------------0H0DgfAur0r4YpThmTah9uO2"
Message-ID: <156267ef-f834-4bea-9dc0-c8ad32d066b0@huawei.com>
Date: Thu, 7 Aug 2025 19:13:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
To: David Hildenbrand <david@redhat.com>, Miaohe Lin <linmiaohe@huawei.com>
CC: <wangkefeng.wang@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <xueshuai@linux.alibaba.com>, <ziy@nvidia.com>,
	<osalvador@suse.de>, <linux-mm@kvack.org>
References: <20250806020520.631203-1-tujinjiang@huawei.com>
 <1e63c37f-8eb2-865d-d3f4-9ef928f1a959@huawei.com>
 <35e24029-d58c-47e8-b5fe-e182f143ebff@huawei.com>
 <c5567040-6f1b-46d1-890e-7dc6b0b46703@redhat.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <c5567040-6f1b-46d1-890e-7dc6b0b46703@redhat.com>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AD27FA000D
X-Stat-Signature: 83jq7fb85bzxwazqrewhs5bz7rjuy6my
X-HE-Tag: 1754565225-368712
X-HE-Meta: U2FsdGVkX18+Agrl8aazSxf1FkSHV0N7VYcjPPx8SRL+W5se2+3MgkzcpfOk4aFJ82WOQQk9kzoxdGd/t2umPSGBkLvBrz7O596KM5lWOjdCJlXJcb0Fme7KPQ5a1AIdDWU/3ev8p8V8f9spFA7kbt8rW1iQc0WWfUo1/n4/ywoBON8yGDjMdr3vefSV5Wl8X05QYq1g4Tp4ftP54P7nTH+mdZzNur0hp9BDEkFdtaOcn5hB1XZK4ggILKVeGFZnlVjuuhzRqKB5p9YgNnQhy1CMVItXdCo/sjMeMXexY95SCtKRVjTN1fuN2pTswgFHx33IXa0oMkjDinL3Uz2LS8toFl3ZIm8wEHjyrVNEwlcWVbCKQB89+LcyDdHy1HdSp/Kht7TYu56OyXOH2r00cWg7Odp/Kqcz0i3C/7SlTdp5jyRcFP6huGmkAjRkpOL5fTBOUW988Or5wf+wylQLK6R/6CXmj77s/4nxhOrUIDg2BvI+9JEh9jIrHO4UlFD2HdLZfRPWDN56x6XAGi08aoFD6IH06Qtt1Z5dsuHN4M5HiJQjzS5+k8+InB/Zq2QeKas9IghTQTBE2SWs5S0P0N0RvxRu+W04vNaPadsqMYc/2RHZz7pqenZrnA7x5UV94ymHD+F7U4qhNSb84hkwaz9rw1KVXULlu2YxmN0RjZytn7gZwkfgjE+D2b4DdvJXpG8B/YkBvbacWtBDhse0/5KfXGxECh0zmhepB1UlTeCd0nPe+8gyWOa/Lh2vA8/nioCN8kNxx3+qnFYJ7PJ2wjekB54Aei4KQi1c+/7vy00vmsZUtQASU8prUM3H8WmqAJxnvzU/le65L3OunS05Wk6LKb9LImKY5OVBDO6tSGcny2RvN3xTsve/W/MZTCMh3m4fYMWMN4KT9Qf8lwZVbe3P5APZX099v8giJvypthjEufjsZmFq7MYoSp7BzOHUR58ECG5yfkwc/xk00Is
 uCkl5/0K
 438Cx68jVNnMGIZVJF1zUU9tFbZD/RTPzaFSBd0IX7B/NE46m8fM/AE8XHnyHnWtJkF98N4keGD9dMX6rJ89mqM7Mn4idbP6lWFscbbgrnTP91KHewQwu/FNWhvvByW66HgL/WrZFwvIrGTgXYySaBFuxQ58VDF3EqTxfnAz6p5BBqEZFC6TLiu1bL4h8+f7JT+Qrj60aTHFYuYw2PihccGIoqq7J9vX31c+F/jp4rTsVWlVjNVkJJ4MARAOEyisAsdq74VZ6DmxezKwVKw8ILgWVAwzscJkELsgadnDO9+zsJbW46mEPpTfh7UhpZmcPGuvPM5RYHnHd7CXM+cAsBvNOkeRVgh1B+08I4YHSHdi0HUgH2qK9IvTYqga4MJ5NKlwnJRWHWjsby+pkp6C+IjrjjB2EMuETCNIC6kCZo4V2DQVktZKb5ETuMhc79irNG9BLFLwb6NTf4WG8kkExZG+8c27ZIdUyDK02
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------0H0DgfAur0r4YpThmTah9uO2
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/8/6 20:41, David Hildenbrand 写道:
> On 06.08.25 05:24, Jinjiang Tu wrote:
>>
>> 在 2025/8/6 11:05, Miaohe Lin 写道:
>>> On 2025/8/6 10:05, Jinjiang Tu wrote:
>>>> When memory_failure() is called for a already hwpoisoned pfn,
>>>> kill_accessing_process() will be called to kill current task. 
>>>> However, if
>>> Thanks for your patch.
>>>
>>>> the vma of the accessing vaddr is VM_PFNMAP, walk_page_range() will 
>>>> skip
>>>> the vma in walk_page_test() and return 0.
>>>>
>>>> Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to 
>>>> processes
>>>> with recovered clean pages"), kill_accessing_process() will return 
>>>> EFAULT.
>>> I'm not sure but pfn_to_online_page should return NULL for VM_PFNMAP 
>>> pages?
>>> So memory_failure_dev_pagemap should handle these pages?
>>
>> We could call remap_pfn_range() for those pfns with struct page. 
>> IIUC, VM_PFNMAP
>> means we should assume the pfn doesn't have struct page, but it can 
>> have.
>>
>>>> For x86, the current task will be killed in kill_me_maybe().
>>>>
>>>> However, after this commit, kill_accessing_process() simplies 
>>>> return 0,
>>>> that means UCE is handled properly, but it doesn't actually. In 
>>>> such case,
>>>> the user task will trigger UCE infinitely.
>>> Did you ever trigger this loop?
>>
>> Yes. Our test is as follow steps:
>> 1) create a user task allocates a clean anonymous page, wihout 
>> accessing it.
>> 2) use einj to inject UCE for the page
>> 3) create task devmem to use /dev/mem to map the pfn and keep 
>> accessing it.
>
> What is the use case for that? It sounds extremely questionable.
>
This case is only for test, and is strange indeed.

But considering another case, a driver may map same RAM pfn to several processes with remap_pfn_range().
If the first task triggers UCE when accessing the pfn, the task will be killed. But the other tasks couldn't be killed
and triggers UCE infinitely.



--------------0H0DgfAur0r4YpThmTah9uO2
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
    <div class="moz-cite-prefix">在 2025/8/6 20:41, David Hildenbrand 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:c5567040-6f1b-46d1-890e-7dc6b0b46703@redhat.com">On
      06.08.25 05:24, Jinjiang Tu wrote:
      <br>
      <blockquote type="cite">
        <br>
        在 2025/8/6 11:05, Miaohe Lin 写道:
        <br>
        <blockquote type="cite">On 2025/8/6 10:05, Jinjiang Tu wrote:
          <br>
          <blockquote type="cite">When memory_failure() is called for a
            already hwpoisoned pfn,
            <br>
            kill_accessing_process() will be called to kill current
            task. However, if
            <br>
          </blockquote>
          Thanks for your patch.
          <br>
          <br>
          <blockquote type="cite">the vma of the accessing vaddr is
            VM_PFNMAP, walk_page_range() will skip
            <br>
            the vma in walk_page_test() and return 0.
            <br>
            <br>
            Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS
            to processes
            <br>
            with recovered clean pages"), kill_accessing_process() will
            return EFAULT.
            <br>
          </blockquote>
          I'm not sure but pfn_to_online_page should return NULL for
          VM_PFNMAP pages?
          <br>
          So memory_failure_dev_pagemap should handle these pages?
          <br>
        </blockquote>
        <br>
        We could call remap_pfn_range() for those pfns with struct page.
        IIUC, VM_PFNMAP
        <br>
        means we should assume the pfn doesn't have struct page, but it
        can have.
        <br>
        <br>
        <blockquote type="cite">
          <blockquote type="cite">For x86, the current task will be
            killed in kill_me_maybe().
            <br>
            <br>
            However, after this commit, kill_accessing_process()
            simplies return 0,
            <br>
            that means UCE is handled properly, but it doesn't actually.
            In such case,
            <br>
            the user task will trigger UCE infinitely.
            <br>
          </blockquote>
          Did you ever trigger this loop?
          <br>
        </blockquote>
        <br>
        Yes. Our test is as follow steps:
        <br>
        1) create a user task allocates a clean anonymous page, wihout
        accessing it.
        <br>
        2) use einj to inject UCE for the page
        <br>
        3) create task devmem to use /dev/mem to map the pfn and keep
        accessing it.
        <br>
      </blockquote>
      <br>
      What is the use case for that? It sounds extremely questionable. <br>
      <br>
    </blockquote>
    <pre>This case is only for test, and is strange indeed.</pre>
    <pre>But considering another case, a driver may map same RAM pfn to several processes with remap_pfn_range().
If the first task triggers UCE when accessing the pfn, the task will be killed. But the other tasks couldn't be killed
and triggers UCE infinitely.

</pre>
    <p><br>
    </p>
    <p><br>
    </p>
  </body>
</html>

--------------0H0DgfAur0r4YpThmTah9uO2--

