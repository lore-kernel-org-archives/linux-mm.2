Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AC7BD6ACF5
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2216B0088; Thu, 18 Dec 2025 07:18:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8EDD6B0089; Thu, 18 Dec 2025 07:18:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E666B008A; Thu, 18 Dec 2025 07:18:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A73166B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:18:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B95760A36
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:18:47 +0000 (UTC)
X-FDA: 84232495494.17.E54375C
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6C45FA0007
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:18:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YQjP9t5y;
	spf=pass (imf15.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766060325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G9dyAm7VTrMPX+usWy8R5N/eUrH31HSfITDxwC8F5mE=;
	b=FhBHsijQsFdYlemjaldZj4WvyLe4xpDnmOoF+6hDhTDSW7YQFqHFs0FpSu1+GrAJlkjIQG
	yFyF6J79Y3+GiETP+B4bkIsXsVNpcqluO7bh1JaluKoObid4UFPVtZqPd1lkenX3oDgG/R
	t+184fWU6kCP/92i1BC0cPu6ItmcunM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YQjP9t5y;
	spf=pass (imf15.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766060325; a=rsa-sha256;
	cv=none;
	b=eMT3Er0+gYXRnAWArBlRKs4fXZAAw0xHgMK/I1DvuOQCB2F3u3D1/XqxH93D9jYUMzcSfd
	9Fg6MD7netoNqR78NQHc5ste3Z++pGdFmZvocqwFmk4tbG9dfOfqYHbYUQ8n/r4tLzUeov
	60TjlFd4e60cmS7S8bmcRX8wsrllK18=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=G9dyAm7VTrMPX+usWy8R5N/eUrH31HSfITDxwC8F5mE=;
	b=YQjP9t5y5M5ZscHOmNSS+CzjYdaBLc4rnPzgNwIKeH+FSFCOn47/dKfi6UPDpXak38n0ej4B5
	pBe3Fq6i+HSc8LqhWH+JWGxtpGkqeq8lRU8KetXIF3a4HbSU9xGH6X8xgKyBMxWXOZaD52nfk2q
	tGQvv2DU4/zDuk3iN3Hakus=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dX8m32xvBz1prMW;
	Thu, 18 Dec 2025 20:16:35 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 1D265140133;
	Thu, 18 Dec 2025 20:18:38 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 20:18:37 +0800
Content-Type: multipart/alternative;
	boundary="------------0a7reg89ezNeONcHYKXx6q0F"
Message-ID: <4b129453-97d1-4da4-9472-21c1634032d0@huawei.com>
Date: Thu, 18 Dec 2025 20:18:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] memory leak of xa_node in collapse_file() when
 rollbacks
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>,
	<ziy@nvidia.com>, <lorenzo.stoakes@oracle.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: Kefeng Wang <wangkefeng.wang@huawei.com>
References: <86834731-02ba-43ea-9def-8b8ca156ec4a@huawei.com>
 <32e4658f-d23b-4bae-9053-acdd5277bb17@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <32e4658f-d23b-4bae-9053-acdd5277bb17@kernel.org>
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6C45FA0007
X-Stat-Signature: oxqdnxbtg91jbbnqgo6hf8tg68waq986
X-HE-Tag: 1766060323-743859
X-HE-Meta: U2FsdGVkX18+UFfwS94T7SxT94mRwcY3kNnrm1zHrpVBnCeEBMJwlQ6Pgf2Fdw46oRyPEvYSbiVHo8eJCM/oLHaHXEmTcrQLIgKR3AXPGrBkcqLtCeDYuB0rgiB+bUUqL7UwuduWbsRRwih0OZfWy27NepK9uwz8Of2rnQUdM6ZlJFO1V6vQFBr7q0QgxD3+I5mkIhIn+669OkM9zFc8YakkTpWvfDH415mUjXg7sLruo7LR10O3gvArOHnPmea52yB4C3PACtBeGY21b9OUipVcfwCVXUoi1cWA+beiEKPRQmzgJG1rSWi0D+x1DNabtRZiBUYkaZqhk0tuX0xyFx+TFriNyoKZZWGEdLUHWeSe7m2Y0Ratm4bYWbRp+pQF0vA3ln0aj0wFkzPwB69hYk5xcp6JDDV2xDIZqh/20SVZ6WCtY31vdZCKxNDqea8RXBenZN5doooyGdqsNqQv02DKLwYIAXMfTp4RKSV3w1o4foSUfoxQaUISI1/HCITCHNzB0G7yhXxM7eqXswMEpMe6CkV8edd55VdposdrBNVLnQuk2LWggr36+mrO+kcZIJDwxC76q+XnwRb5oLEbcxQPGwsnrtaGYEHBtTTogL/y47I7FQH8vK6BgiV1LZWGOIx4E4r8lgOWbt33SwPINxjfFwleu5tstOgUKx4jgh/WaojAe8Qobcxi8+gGOrkyROXQ7t3A4VzndV2W/cxnsu8SYKqSdH+Z5PgpVnmi5POh5NHAfNFMW+8ZUJ5UiNUm8CEu8JA2SIv0FkNPATPF7RmvowO4Ph9EU1lDQfdU3SacLA6FgUHOobhvCaHy82Kzc9K7PY25W6uG/SHN0sCJo72Duj3aEq5kFQaag1DdAFGa9RffGW+uTC3ClcrgUYiPLFCItATRxR7sbLJ1k4kzhHRyx6nDOTWqAzTsnS7ZqFkn7zreSUAHrNNQZKgaDPqWIaGgyQ41qyvL7Y93L/j
 l/CXgYQ1
 OnXLAaXugBnCzyW4RnshSTXRjgADfujSLW6WioU2s+BayZaIghCHwuPBG9WD2XzHTeQ+bSp4Y+02psF7e9sy/sUoFCgah5GlcFYzumiOXd+hLFZIOntm+VGf6Vuj9eCibF4dV7evxnMdGE5+1WuS8F6EhzmdBE+Sh/TPs4L3MIEhCb4wz0OpLmU8XjXKmKYJ/YwwhelegcpBFeRr9Mk7RHgCQWd4h6c1TSzeHBW15YIbiZnEO8p2thfcVL9LVOzJo6K9/kEVdvMr9Tn7FEwksqxHO4RCFcSM+8IFdlCen6ogP6Ml5o6Ef6Yw/eTu8SE/mFcNpPXBTa1iwThtpGLp8f4peb+taOf4clI37Omu9rZVk3AIs0fnrshwpRoI905JJ1TozPnHOZxNvi9yPuMFLZ8wpRQbjqmLuqMp/+1/mYx1Z080KIXxljB3pi/MGmtAZ8r3mlfLdPeWZi7M+cClK4wTDfG9JDALTq6STXgqkoz452nOhAzuroS4ilfh4bTXhoashfJCUO+FGpBDMKyN9r2EnLOK8PBlleXmE1J+JfOkxxaxOGdSaw0dfZ52U9pT6Eu4r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------0a7reg89ezNeONcHYKXx6q0F
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/12/18 19:51, David Hildenbrand (Red Hat) 写道:
> On 12/18/25 12:45, Jinjiang Tu wrote:
>> I encountered a memory leak issue caused by xas_create_range().
>>
>> collapse_file() calls xas_create_range() to pre-create all slots needed.
>> If collapse_file() finally fails, these pre-created slots are empty 
>> nodes
>> and aren't destroyed.
>>
>> I can reproduce it with following steps.
>> 1) create file /tmp/test_madvise_collapse and ftruncate to 4MB size, 
>> and then mmap the file
>> 2) memset for the first 2MB
>> 3) madvise(MADV_COLLAPSE) for the second 2MB
>> 4) unlink the file
>>
>> in 3), collapse_file() calls xas_create_range() to expand xarray 
>> depth, and fails to collapse
>> due to the whole 2M region is empty, the code is as following:
>>
>> collapse_file()
>>     for (index = start; index < end;) {
>>         xas_set(&xas, index);
>>         folio = xas_load(&xas);
>>
>>         VM_BUG_ON(index != xas.xa_index);
>>         if (is_shmem) {
>>             if (!folio) {
>>                 /*
>>                  * Stop if extent has been truncated or
>>                  * hole-punched, and is now completely
>>                  * empty.
>>                  */
>>                 if (index == start) {
>>                     if (!xas_next_entry(&xas, end - 1)) {
>>                         result = SCAN_TRUNCATED;
>>                         goto xa_locked;
>>                     }
>>                 }
>>                 ...
>>             }
>>
>>
>> collapse_file() rollback path doesn't destroy the pre-created empty 
>> nodes.
>>
>> When the file is deleted, shmem_evict_inode()->shmem_truncate_range() 
>> traverses
>> all entries and calls xas_store(xas, NULL) to delete, if the leaf 
>> xa_node that
>> stores deleted entry becomes emtry, xas_store() will automatically 
>> delete the empty
>> node and delete it's  parent is empty too, until parent node isn't 
>> empty. shmem_evict_inode()
>> won't traverse the empty nodes created by xas_create_range() due to 
>> these nodes doesn't store
>> any entries. As a result, these empty nodes are leaked.
>>
>> At first, I tried to destory the empty nodes when collapse_file() 
>> goes to rollback path. However,
>> collapse_file() only holds xarray lock and may release the lock, so 
>> we couldn't prevent concurrent
>> call of collapse_file(), so the deleted empty nodes may be needed by 
>> other collapse_file() calls.
>>
>> IIUC, xas_create_range() is used to guarantee the xas_store(&xas, 
>> new_folio); succeeds. Could we
>> remove xas_create_range() call and just rollback when we fail to 
>> xas_store?
>
> Hi,
>
> thanks for the report.
>
> Is that what [1] is fixing?
>
> [1] 
> https://lore.kernel.org/linux-mm/20251204142625.1763372-1-shardul.b@mpiricsoftware.com/ 
>
>
No, this patch fixes memory leak caused by xas->xa_alloc allocated by xas_nomem() and the xa_node
isn't installed into xarray.

In my case, the leaked xa_nodes have been installed into xarray by xas_create_range().

--------------0a7reg89ezNeONcHYKXx6q0F
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
    <div class="moz-cite-prefix">在 2025/12/18 19:51, David Hildenbrand
      (Red Hat) 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:32e4658f-d23b-4bae-9053-acdd5277bb17@kernel.org">On
      12/18/25 12:45, Jinjiang Tu wrote:
      <br>
      <blockquote type="cite">I encountered a memory leak issue caused
        by xas_create_range().
        <br>
        <br>
        collapse_file() calls xas_create_range() to pre-create all slots
        needed.
        <br>
        If collapse_file() finally fails, these pre-created slots are
        empty nodes
        <br>
        and aren't destroyed.
        <br>
        <br>
        I can reproduce it with following steps.
        <br>
        1) create file /tmp/test_madvise_collapse and ftruncate to 4MB
        size, and then mmap the file
        <br>
        2) memset for the first 2MB
        <br>
        3) madvise(MADV_COLLAPSE) for the second 2MB
        <br>
        4) unlink the file
        <br>
        <br>
        in 3), collapse_file() calls xas_create_range() to expand xarray
        depth, and fails to collapse
        <br>
        due to the whole 2M region is empty, the code is as following:
        <br>
        <br>
        collapse_file()
        <br>
            for (index = start; index &lt; end;) {
        <br>
                xas_set(&amp;xas, index);
        <br>
                folio = xas_load(&amp;xas);
        <br>
        <br>
                VM_BUG_ON(index != xas.xa_index);
        <br>
                if (is_shmem) {
        <br>
                    if (!folio) {
        <br>
                        /*
        <br>
                         * Stop if extent has been truncated or
        <br>
                         * hole-punched, and is now completely
        <br>
                         * empty.
        <br>
                         */
        <br>
                        if (index == start) {
        <br>
                            if (!xas_next_entry(&amp;xas, end - 1)) {
        <br>
                                result = SCAN_TRUNCATED;
        <br>
                                goto xa_locked;
        <br>
                            }
        <br>
                        }
        <br>
                        ...
        <br>
                    }
        <br>
        <br>
        <br>
        collapse_file() rollback path doesn't destroy the pre-created
        empty nodes.
        <br>
        <br>
        When the file is deleted,
        shmem_evict_inode()-&gt;shmem_truncate_range() traverses
        <br>
        all entries and calls xas_store(xas, NULL) to delete, if the
        leaf xa_node that
        <br>
        stores deleted entry becomes emtry, xas_store() will
        automatically delete the empty
        <br>
        node and delete it's  parent is empty too, until parent node
        isn't empty. shmem_evict_inode()
        <br>
        won't traverse the empty nodes created by xas_create_range() due
        to these nodes doesn't store
        <br>
        any entries. As a result, these empty nodes are leaked.
        <br>
        <br>
        At first, I tried to destory the empty nodes when
        collapse_file() goes to rollback path. However,
        <br>
        collapse_file() only holds xarray lock and may release the lock,
        so we couldn't prevent concurrent
        <br>
        call of collapse_file(), so the deleted empty nodes may be
        needed by other collapse_file() calls.
        <br>
        <br>
        IIUC, xas_create_range() is used to guarantee the
        xas_store(&amp;xas, new_folio); succeeds. Could we
        <br>
        remove xas_create_range() call and just rollback when we fail to
        xas_store?
        <br>
      </blockquote>
      <br>
      Hi,
      <br>
      <br>
      thanks for the report.
      <br>
      <br>
      Is that what [1] is fixing?
      <br>
      <br>
      [1]
<a class="moz-txt-link-freetext" href="https://lore.kernel.org/linux-mm/20251204142625.1763372-1-shardul.b@mpiricsoftware.com/">https://lore.kernel.org/linux-mm/20251204142625.1763372-1-shardul.b@mpiricsoftware.com/</a> <br>
      <br>
    </blockquote>
    <pre>No, this patch fixes memory leak caused by xas-&gt;xa_alloc allocated by xas_nomem() and the xa_node
isn't installed into xarray.

In my case, the leaked xa_nodes have been installed into xarray by xas_create_range().

</pre>
  </body>
</html>

--------------0a7reg89ezNeONcHYKXx6q0F--

