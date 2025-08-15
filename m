Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BBDCA0EDC
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 01:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7979001F9; Thu, 14 Aug 2025 21:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28DCD9001D5; Thu, 14 Aug 2025 21:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7659001F9; Thu, 14 Aug 2025 21:16:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 065979001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:16:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81C4CBB9F4
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:16:12 +0000 (UTC)
X-FDA: 83777225784.27.C9BF1B7
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4EF2840008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:16:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755220570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EwwiKF2IC2/r0VIfjms4b29WHmg7MzmR8Gto9LHYvYk=;
	b=D4eRaExixnlTUo2absMfJGtt34s6XJm6bVkcsHvf98v3eJ2alQv1ts3/HyxIK52upOulGq
	wtWmm3ZqUwXJadovuXEeiFdts+U8914Cy57ESAW7Ju31z45nDIW54JcpLe1fCLLeuU/5T0
	JOGAVJs6VuJ1KSK9cqtci82uwzfACNQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755220570; a=rsa-sha256;
	cv=none;
	b=VaObGjvrO+tmOCYe9NuGdFZaw/aeQwXBeNe6QI6/gFv0Zd+EDDQEhnxH0pavVe/pRkKcAQ
	bWxXtpUbhEgx5CJIeExeIq6TVcRvbrMsqtmwnYv2sAArGJjwFn/x6kZEZAuzZffyw4svaT
	3LEp7CptOGE83YMb1g+LNOUY8eSgEGM=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c33yK6WJrz2gL3G;
	Fri, 15 Aug 2025 09:13:13 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 97026140123;
	Fri, 15 Aug 2025 09:16:04 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemo200002.china.huawei.com (7.202.195.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 Aug 2025 09:16:03 +0800
Content-Type: multipart/alternative;
	boundary="------------9mv0eLBkKuq9ggQzCbXEm1kg"
Message-ID: <1e86b8e4-0a47-4d82-91b6-c544b3f9a9a7@huawei.com>
Date: Fri, 15 Aug 2025 09:16:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: fix infinite UCE for VM_PFNMAP'ed
 page
To: Miaohe Lin <linmiaohe@huawei.com>
CC: <wangkefeng.wang@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <xueshuai@linux.alibaba.com>,
	<david@redhat.com>, <ziy@nvidia.com>, <osalvador@suse.de>,
	<linux-mm@kvack.org>
References: <20250811043323.899130-1-tujinjiang@huawei.com>
 <c39474a9-31b2-7df8-8ce8-229f706b05de@huawei.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <c39474a9-31b2-7df8-8ce8-229f706b05de@huawei.com>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4EF2840008
X-Stat-Signature: x1mjp9u1eknh5umx8bq3xmqxbjtyepbd
X-Rspam-User: 
X-HE-Tag: 1755220568-504920
X-HE-Meta: U2FsdGVkX1+V6qPrvA8Kiu2uKmgD3PSsijPZS9hDkyaKjF9X6NpNWf3qn6e3gyfCjJUZMsfbXuQqYKTKDsRhawBWxVMaTfZtTG+42rvIPgoxl7HzF/tKcf7OrJ+2ZrPTRLsrqbirTXBA442i56Tf+aFymKUJq+NNTTQYvNiUHlg0oLtM6qMUpUuknCtWQtQRvgAr/qg4rsBIcSH6c12McXzDjLNmegNn7jdfssmwWz26AsCX7wFBrdUqZUbVcGeyVZvRFVS+ceKL4o38U++cfCmMmpvX8rXJsgYxHivotBQV1oW82c5MNfb6jtlJoOEz1f/e/GBDcUmWcnW3I75AhAgCcss+Opp5Fza4zGMO+mixONDO5IqIPazhQ6kgGv0J+ub2SN68jzPiB12fXvFwUJvef5qyClvugy1K9CeHgO5+mlluZHqBoufGTy52GZaw/SBl82duothQY1TzQdfwW6rzNhmJgtIqCaavAOiFZENWqMvCyJ5cDF/wkhZWDN30bvlDM7d3Ys4OpcusiGw2H60Mg2mjgHAW4c1ON0Nf4Bv9bhP9NeKY4OfeAsbKJdcHCS1mlgizpXa6N7s1if22dmCpTVgFPoopdrlVdAzO35chdpPiuWCR10VaYFhB2rjFm3K/6CvL45id/qeylvNh8CTWbcykzmxrdoD0eF08QJn//7mnEzYh7jd8yNUTaHIP4Swd0mjOhERx/0xgB7OHCmzdPadDGvJMtw+mfddJF6y3GH7NjoUHXl6SOKnGThipTg7VaLvLc62gM2L14aWmV4dHTVjdkY162TKESdT5AGtQOMJ99U7LyOeb71u2GKRPVPANYJ4Zsp9MweVmzBjbxmFFHJFazpOTRFfg5OA7J7Wi7PnZWzZncIXh4f+mz1UvXGQ9t1Hrdlr73x/MzGYJpbyjQ8+KFUItluxGhLXS0iGHZLxpfHDm5jTowjxnoniAQWEGGDcotqxC4ZmcxYv
 lpaE0kqr
 xXLtJSTjuUs1PHw/7iYLuTOF6XSakdqhKnEWKVxw5O1Nd0XFx+m23YJti4SubuHoC8gW1h5baAEFOGkxESStGawt9XaLapeEFAR75/rl1ZwG34bC1Wx1GKbTVWpxrl4XMW//+PdOV5JLExDvRAjP94GxTUhUYMmjMcmazSQhTeiYPcI6QdfNEr5RuUFup5zvyE7ch/BcOwsKs2Q8b/k3pltAdo+uwNDekntd3mh+8VTGpwLXhJHdz09mlKsCrcek6WMr1zriAUSTibM8A6sHovunVqB3G88BWrTtfNLlz3qI4rkuKFcO/9kmkrBDXWP/nxrUNXlpqCvfFCkjrBNt9W6eiH4yRu0PS2zpYFqV867VaK9m1HwDlxjBxOBQbgpbJrb3hGkP/NWwLKpR9Du8aHGko8xl6816SIHITb2gytI83iGoYdIUak/lHZldNsR1rF1FZbtoyLMAQCcnF57fGo+FWdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------9mv0eLBkKuq9ggQzCbXEm1kg
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/8/12 10:01, Miaohe Lin 写道:
> On 2025/8/11 12:33, Jinjiang Tu wrote:
>> When memory_failure() is called for a already hwpoisoned pfn backed with
>> struct page, kill_accessing_process() will conditionally send a SIGBUS to
>> the current (triggering) process if it maps the page.
>>
>> However, in case the page is not ordinarily mapped, but was mapped through
>> remap_pfn_range(), kill_accessing_process() wouldn't identify it as mapped
>> even though hwpoison_pte_range() would be prepared to handle it, because
>> walk_page_range() will skip VM_PFNMAP as default in walk_page_test(). As
>> a result, walk_page_range() will return 0, assuming "not mapped" and SIGBUS
>> will be skipped. The user task will trigger UCE infinitely because it will
>> not receive a SIGBUS on access and simply retry.
>>
>> Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
>> with recovered clean pages"), kill_accessing_process() will return EFAULT.
>> For x86, the current task will be killed in kill_me_maybe().
>>
>> To fix it, add .test_walk callback for hwpoison_walk_ops to process
>> VM_PFNMAP VMAs too.
>>
>> Fixes: aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes with recovered clean pages")
>> Signed-off-by: Jinjiang Tu<tujinjiang@huawei.com>
>> ---
>> Changelog since v1:
>>   * update patch description, suggested by David Hildenbrand
>>
>>   mm/memory-failure.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index e2e685b971bb..fa6a8f2cdebc 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -853,9 +853,16 @@ static int hwpoison_hugetlb_range(pte_t *ptep, unsigned long hmask,
>>   #define hwpoison_hugetlb_range	NULL
>>   #endif
>>   
> It might be better to add a comment on why below hwpoison_test_walk is needed.
> It looks somewhat weird as hwpoison_test_walk simply return 0.

Indeed, I will send v3 to add a comment

>
>> +static int hwpoison_test_walk(unsigned long start, unsigned long end,
>> +			     struct mm_walk *walk)
>> +{
>> +	return 0;
>> +}
>> +
> Anyway, this patch looks good to me.
> Acked-by: Miaohe Lin<linmiaohe@huawei.com>
>
> Thanks.
> .
--------------9mv0eLBkKuq9ggQzCbXEm1kg
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
    <div class="moz-cite-prefix">在 2025/8/12 10:01, Miaohe Lin 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:c39474a9-31b2-7df8-8ce8-229f706b05de@huawei.com">
      <pre wrap="" class="moz-quote-pre">On 2025/8/11 12:33, Jinjiang Tu wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">When memory_failure() is called for a already hwpoisoned pfn backed with
struct page, kill_accessing_process() will conditionally send a SIGBUS to
the current (triggering) process if it maps the page.

However, in case the page is not ordinarily mapped, but was mapped through
remap_pfn_range(), kill_accessing_process() wouldn't identify it as mapped
even though hwpoison_pte_range() would be prepared to handle it, because
walk_page_range() will skip VM_PFNMAP as default in walk_page_test(). As
a result, walk_page_range() will return 0, assuming "not mapped" and SIGBUS
will be skipped. The user task will trigger UCE infinitely because it will
not receive a SIGBUS on access and simply retry.

Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
with recovered clean pages"), kill_accessing_process() will return EFAULT.
For x86, the current task will be killed in kill_me_maybe().

To fix it, add .test_walk callback for hwpoison_walk_ops to process
VM_PFNMAP VMAs too.

Fixes: aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes with recovered clean pages")
Signed-off-by: Jinjiang Tu <a class="moz-txt-link-rfc2396E" href="mailto:tujinjiang@huawei.com">&lt;tujinjiang@huawei.com&gt;</a>
---
Changelog since v1:
 * update patch description, suggested by David Hildenbrand 

 mm/memory-failure.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e2e685b971bb..fa6a8f2cdebc 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -853,9 +853,16 @@ static int hwpoison_hugetlb_range(pte_t *ptep, unsigned long hmask,
 #define hwpoison_hugetlb_range	NULL
 #endif
 
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
It might be better to add a comment on why below hwpoison_test_walk is needed.
It looks somewhat weird as hwpoison_test_walk simply return 0.</pre>
    </blockquote>
    <pre>Indeed, I will send v3 to add a comment</pre>
    <blockquote type="cite"
      cite="mid:c39474a9-31b2-7df8-8ce8-229f706b05de@huawei.com">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">+static int hwpoison_test_walk(unsigned long start, unsigned long end,
+			     struct mm_walk *walk)
+{
+	return 0;
+}
+
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Anyway, this patch looks good to me.
Acked-by: Miaohe Lin <a class="moz-txt-link-rfc2396E" href="mailto:linmiaohe@huawei.com">&lt;linmiaohe@huawei.com&gt;</a>

Thanks.
.
</pre>
    </blockquote>
  </body>
</html>

--------------9mv0eLBkKuq9ggQzCbXEm1kg--

