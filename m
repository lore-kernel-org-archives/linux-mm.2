Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F88D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 03:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 903BA6B0006; Sun, 14 Dec 2025 22:42:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DC486B0007; Sun, 14 Dec 2025 22:42:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA666B0008; Sun, 14 Dec 2025 22:42:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 66E1F6B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 22:42:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD7508BBBD
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:42:29 +0000 (UTC)
X-FDA: 84220308018.02.9800F05
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf24.hostedemail.com (Postfix) with ESMTP id 93CB7180010
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:42:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QrXdkt8w;
	spf=pass (imf24.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765770148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QQAN60cdddSSldQIQPQz11+trQiMjxdlqc/hEj6Yfg=;
	b=1eZ4iZ9miPKs4HmLLGnbXsAaUf1KjBm0bivFxc92aNmQfCCWHDYIOexrATHnE+qOtWaHQN
	Rz4z4N9MvZklhpsIJgVKIJm6Me3CmvCpSSWgRhTzQIjKdQlwtYhSyEqE/oPx0ES2tCljgR
	XoNuv6SnwU3Dtfos8+vCUdtLylDpEhk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QrXdkt8w;
	spf=pass (imf24.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765770148; a=rsa-sha256;
	cv=none;
	b=meV4kF7kiyYzh4z6VJUuMqlP2/xWuSpGrCKNWZ+DF7OkO5LeGcQJhFiBzzgFAZNkym8xEl
	3/X4gfAZYUqwULSIyGikJRKxphfUi2QRphG/u39UncJNjJRULgLm5RgDTzlAytW4pS4ElK
	b0Vqnju/VKFQhUqD12T5DVOzb0fuPik=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3QQAN60cdddSSldQIQPQz11+trQiMjxdlqc/hEj6Yfg=;
	b=QrXdkt8w6pPuZ4/WwMhbvSZeCFVKo9LVhCa2tyfo7V8P0FMcddJEzgoZTB9N+1AkB8MNlO7pK
	X7r80BpTvMe+3Hik4kEoXY8nYlLLICTDVqOHap0jk3zRXS/ReMuZhgU6CLyo0f1r/wcR+3gT1IZ
	Zmt2E3J7YkwMN+k18SZOi7o=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dV5Rm5hggz1prPH;
	Mon, 15 Dec 2025 11:40:20 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 72E58180478;
	Mon, 15 Dec 2025 11:42:21 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 15 Dec 2025 11:42:20 +0800
Message-ID: <164b53af-f4b2-49bf-ac4c-c7b10c080159@huawei.com>
Date: Mon, 15 Dec 2025 11:42:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] lib: xarray: free unused spare node in
 xas_create_range()
From: Jinjiang Tu <tujinjiang@huawei.com>
To: Shardul Bankar <shardul.b@mpiricsoftware.com>, <willy@infradead.org>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dev.jain@arm.com>, <david@kernel.org>, <shardulsb08@gmail.com>,
	<janak@mpiricsoftware.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
References: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
 <89b96a9f-1d03-440a-93cd-2b9876be3122@huawei.com>
In-Reply-To: <89b96a9f-1d03-440a-93cd-2b9876be3122@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 93CB7180010
X-Stat-Signature: zyys5xc9qu3k6e99383m3tqzw9if3p74
X-HE-Tag: 1765770146-526814
X-HE-Meta: U2FsdGVkX19Fe848gkBWT2tpURiz2zxxsqgp4em6vxVzESFS69dzIaUF4JLaazHx2K7q8nACuBE7hsCY25+nRs8lKTW4flH4fWZUh4YbUajHjflIvDxChmRkVQysYt8IufpY1DXf/h9jzOi+VE/kyxIVI7HefW+ZwbpRG2Rh2Nl8wFM7luqL/ZdncYIkTxBSnlUBOPljLsDXqHzNf1Tu4nNI0/jrcntelh/4ePs42pHgqavBqmgYCNB7mLkqUF082/RdESWcp4wVaOeJzVwMob0KyWG5829AgI5xNwtCPs6Ij92B1mYTLwJ/4wKJ1yiatRsS/sRpZe+D6JHOeFopTemU5DXmDB/uU2df2xofkXmGstTDT5Uvg5anf5Q3SAMfDu6n7W69r3sjXuyYmRyUVROP6T8BDlF1hz5u3w412EJ4MGeTQMWembV7PbdggjFSM109FpKX49Yju2RZpYffau/DYAFFgOwr8TmJYMBKKHOiaNtaCY9a94s/E3bxSF1OTC0chhN29YurA2LGbKWBCsEIMyrBMyoIGRcgP70wn+OhljPJ1eAy0KQi3N052S1y++UH6MsOLQ1CqAyZCNf6d2+dpFjPa5cK+yyYG8dbR7xxSveCHQfCghHO3unaikmy/72Udwxu5o0Qk/2Q6px2Yv6IiGK04x63eA111Ec5SnxFdpkaz7z4VWt8uxrWzdjuvQhnN6iDeqnJod6HuRHAETqc8dRc85ycC1BP+XWYE1zGjyFhOrGSIhgUHnlUtP8+CI4sIo6qGe43XiZ9KTiIEFeo+R4Xp4tXV6M599JB66iB6EMIBEV8KxMrgcSkomKRLS4CH3va4TRInjbXwxYoh4vIh3PGdiMlH0U0KYNf5wKhwnP4EgPPCpBPcBE7D//gOu695BpgR0Q7q43ReFmqo6o55QqyKMr6QT3iN136fL9QY5iq1eXnS7goQiJCxG0+KCnHv+r8UXVYAst7Quu
 84YSUIH8
 rRWUwfnBZ5S7Y7vwmWdXOA10IXKLL9svQq+0IdKBuSyU9aOl6YskvHr9uNjX7Ji2RkwaHRdEsS4XeG79zYmncZ7sHak87WrMBKN6u1YMbXK58FguVJANZ7u9FXDuNnmkzvp8Vd21DpI2wWMdqflAN3ZplyHFsYf6hJbf+ZLSYtjM9Ofh7FWtyf1QZ6tH3MZNc+BK0MLPynrjwNU5yn4qL6ZtrkBCG7v4GqOBKQJKVtRjFi0QTFqM0p2HMcr4EfUibwuwk+4p3fMG7HfL1AELPYuPkMokzlsIFjfCQCMwXxh2WaL684FUb/lLylXI+/fbteBWdVKWjucRZJYW4xWD3J4MuSBMzh+kN0ZOegVKytS+OyrNYykQ5qvYg7XBCAU+jnL4GaNlFhZ281ToQY8pUKSBPZQUk8CPjxuEtC48xnItgLxQurPEiL9JfLwrE7zABcUM5cPe8jV6yqtMcRvPhTltjZblv1NAEuDfLyanczjZoEMSlVt2qzbyD4r/lEnZ44180HTKdmgwZ8XE76pmZsvlCqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/12/15 10:19, Jinjiang Tu 写道:
>
>
> 在 2025/12/4 22:26, Shardul Bankar 写道:
>> xas_create_range() is typically called in a retry loop that uses
>> xas_nomem() to handle -ENOMEM errors. xas_nomem() may allocate a spare
>> xa_node and store it in xas->xa_alloc for use in the retry.
>>
>> If the lock is dropped after xas_nomem(), another thread can expand the
>> xarray tree in the meantime. On the next retry, xas_create_range() can
>> then succeed without consuming the spare node stored in xas->xa_alloc.
>> If the function returns without freeing this spare node, it leaks.
>>
>> xas_create_range() calls xas_create() multiple times in a loop for
>> different index ranges. A spare node that isn't needed for one range
>> iteration might be needed for the next, so we cannot free it after each
>> xas_create() call. We can only safely free it after xas_create_range()
>> completes.
>>
>> Fix this by calling xas_destroy() at the end of xas_create_range() to
>> free any unused spare node. This makes the API safer by default and
>> prevents callers from needing to remember cleanup.
>>
>> This fixes a memory leak in mm/khugepaged.c and potentially other
>> callers that use xas_nomem() with xas_create_range().
> I encountered another memory leak issue in xas_create_range().
>
> collapse_file() calls xas_create_range() to pre-create all slots needed.
> If collapse_file() finally fails, these pre-created slots are empty nodes.
> When the file is deleted, shmem_evict_inode()->shmem_truncate_range()->shmem_undo_range()
> calls xas_store(&xas, NULL) for each entries to delete nodes, but leaving those pre-created
> empty nodes leaked.
>
> I can reproduce it with following steps.
> 1) create file /tmp/test_madvise_collapse and ftruncate to 4MB size, and then mmap the file
> 2) memset for the first 2MB
> 3) madvise(MADV_COLLAPSE) for the second 2MB.
> 4) unlink the file
>
> in 3), collapse_file() calls xas_create_range() to expand xarray depth, and fails to collapse
> due to the whole 2M region is empty, leading to the new created empty nodes leaked.
>
> To fix it, maybe we should add a new function xas_delete_range() to revert what xas_create_range()
> does when xas_create_range() runs into rollback path?

How about the following diff? I tried it, and the memory leak disappears. I'm new in xarray, so
I don't if this fix works properly.

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index be850174e802..972df5ceeb84 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -1555,6 +1555,7 @@ void xas_destroy(struct xa_state *);
  void xas_pause(struct xa_state *);
  
  void xas_create_range(struct xa_state *);
+void xas_destroy_range(struct xa_state *xas, unsigned long start, unsigned long end);
  
  #ifdef CONFIG_XARRAY_MULTI
  int xa_get_order(struct xarray *, unsigned long index);
diff --git a/lib/xarray.c b/lib/xarray.c
index 9a8b4916540c..ab15dc939962 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -752,6 +752,21 @@ void xas_create_range(struct xa_state *xas)
  }
  EXPORT_SYMBOL_GPL(xas_create_range);
  
+void xas_destroy_range(struct xa_state *xas, unsigned long start, unsigned long end)
+{
+    unsigned long index;
+    void *entry;
+
+    for (index = start; index < end; ++index) {
+        xas_set(xas, index);
+        entry = xas_load(xas);
+        if (entry)
+            continue;
+        else if (xas->xa_node && !xas->xa_node->count)
+            xas_delete_node(xas);
+    }
+}
+
  static void update_node(struct xa_state *xas, struct xa_node *node,
          int count, int values)
  {
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97d1b2824386..dd9d3f202c4b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2247,7 +2247,10 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
      goto out;
  
  rollback:
-    /* Something went wrong: roll back page cache changes */
+    /* Something went wrong: roll back empty xa_node created by
+     * xas_create_range() and page cache changes
+     */
+    xas_destroy_range(&xas, start, end);
+
      if (nr_none) {
          xas_lock_irq(&xas);
          mapping->nrpages -= nr_none;

>> Link:https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c
>> Link:https://lore.kernel.org/all/20251201074540.3576327-1-shardul.b@mpiricsoftware.com/ ("v3")
>> Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
>> Signed-off-by: Shardul Bankar<shardul.b@mpiricsoftware.com>
>> ---
>>   v4:
>>   - Drop redundant `if (xa_alloc)` around xas_destroy(), as xas_destroy()
>>     already checks xa_alloc internally.
>>   v3:
>>   - Move fix from collapse_file() to xas_create_range() as suggested by Matthew Wilcox
>>   - Fix in library function makes API safer by default, preventing callers from needing
>>     to remember cleanup
>>   - Use shared cleanup label that both restore: and success: paths jump to
>>   - Clean up unused spare node on both success and error exit paths
>>   v2:
>>   - Call xas_destroy() on both success and failure
>>   - Explained retry semantics and xa_alloc / concurrency risk
>>   - Dropped cleanup_empty_nodes from previous proposal
>>
>>   lib/xarray.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/xarray.c b/lib/xarray.c
>> index 9a8b4916540c..f49ccfa5f57d 100644
>> --- a/lib/xarray.c
>> +++ b/lib/xarray.c
>> @@ -744,11 +744,16 @@ void xas_create_range(struct xa_state *xas)
>>   	xas->xa_shift = shift;
>>   	xas->xa_sibs = sibs;
>>   	xas->xa_index = index;
>> -	return;
>> +	goto cleanup;
>> +
>>   success:
>>   	xas->xa_index = index;
>>   	if (xas->xa_node)
>>   		xas_set_offset(xas);
>> +
>> +cleanup:
>> +	/* Free any unused spare node from xas_nomem() */
>> +	xas_destroy(xas);
>>   }
>>   EXPORT_SYMBOL_GPL(xas_create_range);
>>   

