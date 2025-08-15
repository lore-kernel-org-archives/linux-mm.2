Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36D7CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 01:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C6EA9001FA; Thu, 14 Aug 2025 21:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597759001D5; Thu, 14 Aug 2025 21:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ADD99001FA; Thu, 14 Aug 2025 21:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 36C889001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:17:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01C59C083D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:17:04 +0000 (UTC)
X-FDA: 83777228010.03.A43CF7D
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf27.hostedemail.com (Postfix) with ESMTP id E781640004
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:17:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755220622; a=rsa-sha256;
	cv=none;
	b=3xiwgu/wSypOM2FpU2KLN9RGv5Fk0t/UOzp58l9TNIy/J6ZKIx2UoYLVRNQ1Y2SghENiXT
	/w+ymm9t/XZhCxyMa+KnZ/TndFYof8fZyn9d3e8etlxODLZPVr+IAkKK5iM5yrY3oJ8NQP
	BxkS/feWTd/8CNjGzeMIB2vJC6aMZ/0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755220622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H0ZXnrhsD3rLlmVJwC8T82yVEM0wVsKHBXiaNRkg8X4=;
	b=qz76R17LrZGXRMt2h4ad5g/8aB6vkg0ep12cog6XuVLDMqSRrIYCVEoDzKEn3ppR44AgiM
	ZXVATUhyzyEM14z1NyxElwx5TH+YM765ASNAd6qCq1b7GlwpqsMqDOFp/ZjGducioRZtGG
	yn90u2aQc+jE8q/6TkM01GMfrZsXS54=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c33xd0yn5zdcHk;
	Fri, 15 Aug 2025 09:12:37 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id B307A1402DF;
	Fri, 15 Aug 2025 09:16:57 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemo200002.china.huawei.com (7.202.195.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 Aug 2025 09:16:56 +0800
Content-Type: multipart/alternative;
	boundary="------------xMrF6xzqVC3RQeUR7lcAhLhG"
Message-ID: <cba9fcb9-9548-488e-a914-d88ff38dc513@huawei.com>
Date: Fri, 15 Aug 2025 09:16:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: fix infinite UCE for VM_PFNMAP'ed
 page
To: <jane.chu@oracle.com>, <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <xueshuai@linux.alibaba.com>,
	<david@redhat.com>, <ziy@nvidia.com>, <osalvador@suse.de>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>
References: <20250811043323.899130-1-tujinjiang@huawei.com>
 <1f5d5a50-2f30-4c1e-bdb2-1c0103cb5b07@oracle.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <1f5d5a50-2f30-4c1e-bdb2-1c0103cb5b07@oracle.com>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E781640004
X-Stat-Signature: 54i97f5bpdgbo5rzun38h8x46bbbk9jw
X-HE-Tag: 1755220621-48032
X-HE-Meta: U2FsdGVkX1+SERkwm8xTWiJJ9/XkNLbiNmRH1gxsV6UaIOZt73O1N8Pt6ZnmQpH/I6S8GrO4V2/Jt9n4yek7C/jy2hDlje2hy7lExMjomE28c/JjMnw+bLGU2MQRa1RCJA/q/+ixv0bWVIkDLfjWmDIhpUCAZd3dxnV0UTrIy7fuX6iF5KURTQCBhHlUWqWL/icYOu2qUbcY95RWTlxcc994hP+2wYgGt6ZyISh961iXgpbGJmXKfmk6ydaBT4voSnrf6C/9fHkJBs0tyVjydovC1I9cBBp/tHZiYWWvMnX4zAN2KILVKI+YEEi1MzT26nHSTtPb4W3mCPHPngAEthuNnHfM54y4S5nZ6YK75IpY5O2ueV+FU6bf5kPK1ISTwxheylwAUbXceRm/COXGpgqYryWHzR6iv5A2iiLk5fy/8Brs6qQc0aCZ/PyaQROVq3GRlnT4yG8/8tfbdq2oT/3CD3+hmgsAfghu+Jt80LVtvvRQTxJMT/IP5+/wzahfHqv7e+PDyrDORWyrazWKAk2lvRInIZ/0cR4kxTYuozBFRavwpuztHOAvQXVF6RxBxkOu7Iw7lCJWWE55yQ3ke/V3CK/qWUtZeRzO2Kon4eSrzvyPOEPZJ0TJvFkXNf2v5smECQn6pTOY110ayPO9poWBOKaQGL/UE0Dv3nokniIbVWj7fWtlZ2d2L/NjceTsh/Rhfa2SUuH/e+geuKYp/7UkHy/auWjdeIYpBRZSvDD5o5YmRvWps3DifAy0pzbhtbIHGYDtUYDx4p7St4yudbbTCQNNDqVpu6OKAG4UrgB31Ao07Rt3z3akxlTUNy9kvWwli1vdOHl2m+qLCd6oj8A54YVvkHcEPrhpuHCPh1nYho6i4SbzKa6UWdc8awhQQK5qT4tXvbWo0oU9rCVH3xn3dFVKT1jtXay+jgxwux3jiaL0L6Lno9p2ou6jvSX/N70HSDxIyW92fzNDKtO
 UOlxpsEF
 ILtQCxWKj6OFejtS/IHavhRYlw+JE5jvv+fU5LD9AXiMxg8z4WAF/rwKqdUJ77zkZJOVFlFEbdBo65paVisTmj6N+7APtWSvhAYbMHLohNkpfGCUVWfNBVHKNzCxbm4pldZfdZvRZKfHeFp3YWtOcjT1q/kK0uP0ZXpPjDycVfUyV7kazjY1uRDA4Ge2tUitiU2+6ddoEXUIHCj5TcUNuqin3HkTHjS7tpCCFnm7SorChP6i+biQeWy6bpaZZNlyVrRUpuRwkjjj5JJ5mM3GNC1W615Nk6B9sf5m7bnzMmpTGvERfjXaX35+4y49PgZed9d+vw8M3B5a3ybmG5OVFI9dOS2fLCV1svUKb+oB4SlzGQ/m2W8LDLGv2c5ATfds2QkfJg4G7M7EPRmuZhxPyGOQ+mpdjzNCSNzaJQjWF7So6ns2II0NZXlBfxFvB2hPyyCx0JGsLXGGwukhN9DLzEEMTDJpO3dPSQS2oxX/TdaNTRzjbPRF0VZUO/2OX99yt8CGkZYT0f9X6WTyOR8eVlQcSGy0c6CAyuPGd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------xMrF6xzqVC3RQeUR7lcAhLhG
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/8/14 14:05, jane.chu@oracle.com 写道:
>
> On 8/10/2025 9:33 PM, Jinjiang Tu wrote:
>> When memory_failure() is called for a already hwpoisoned pfn backed with
>> struct page, kill_accessing_process() will conditionally send a 
>> SIGBUS to
>> the current (triggering) process if it maps the page.
>>
>> However, in case the page is not ordinarily mapped, but was mapped 
>> through
>> remap_pfn_range(), kill_accessing_process() wouldn't identify it as 
>> mapped
>> even though hwpoison_pte_range() would be prepared to handle it, because
>> walk_page_range() will skip VM_PFNMAP as default in walk_page_test(). As
>> a result, walk_page_range() will return 0, assuming "not mapped" and 
>> SIGBUS
>> will be skipped. The user task will trigger UCE infinitely because it 
>> will
>> not receive a SIGBUS on access and simply retry.
>>
>> Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to 
>> processes
>> with recovered clean pages"), kill_accessing_process() will return 
>> EFAULT.
>> For x86, the current task will be killed in kill_me_maybe().
>>
>> To fix it, add .test_walk callback for hwpoison_walk_ops to process
>> VM_PFNMAP VMAs too.
>>
>> Fixes: aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes 
>> with recovered clean pages")
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>> Changelog since v1:
>>   * update patch description, suggested by David Hildenbrand
>>
>>   mm/memory-failure.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index e2e685b971bb..fa6a8f2cdebc 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -853,9 +853,16 @@ static int hwpoison_hugetlb_range(pte_t *ptep, 
>> unsigned long hmask,
>>   #define hwpoison_hugetlb_range    NULL
>>   #endif
>>   +static int hwpoison_test_walk(unsigned long start, unsigned long end,
>> +                 struct mm_walk *walk)
>> +{
>> +    return 0;
>> +}
>> +
>>   static const struct mm_walk_ops hwpoison_walk_ops = {
>>       .pmd_entry = hwpoison_pte_range,
>>       .hugetlb_entry = hwpoison_hugetlb_range,
>> +    .test_walk = hwpoison_test_walk,
>>       .walk_lock = PGWALK_RDLOCK,
>>   };
>
> Looks good.  Could you add this to stable ?

Yes, I will.

>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
>
> thanks,
> -jane
>
>
>
--------------xMrF6xzqVC3RQeUR7lcAhLhG
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
    <div class="moz-cite-prefix">在 2025/8/14 14:05, <a class="moz-txt-link-abbreviated" href="mailto:jane.chu@oracle.com">jane.chu@oracle.com</a>
      写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:1f5d5a50-2f30-4c1e-bdb2-1c0103cb5b07@oracle.com">
      <br>
      On 8/10/2025 9:33 PM, Jinjiang Tu wrote:
      <br>
      <blockquote type="cite">When memory_failure() is called for a
        already hwpoisoned pfn backed with
        <br>
        struct page, kill_accessing_process() will conditionally send a
        SIGBUS to
        <br>
        the current (triggering) process if it maps the page.
        <br>
        <br>
        However, in case the page is not ordinarily mapped, but was
        mapped through
        <br>
        remap_pfn_range(), kill_accessing_process() wouldn't identify it
        as mapped
        <br>
        even though hwpoison_pte_range() would be prepared to handle it,
        because
        <br>
        walk_page_range() will skip VM_PFNMAP as default in
        walk_page_test(). As
        <br>
        a result, walk_page_range() will return 0, assuming "not mapped"
        and SIGBUS
        <br>
        will be skipped. The user task will trigger UCE infinitely
        because it will
        <br>
        not receive a SIGBUS on access and simply retry.
        <br>
        <br>
        Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to
        processes
        <br>
        with recovered clean pages"), kill_accessing_process() will
        return EFAULT.
        <br>
        For x86, the current task will be killed in kill_me_maybe().
        <br>
        <br>
        To fix it, add .test_walk callback for hwpoison_walk_ops to
        process
        <br>
        VM_PFNMAP VMAs too.
        <br>
        <br>
        Fixes: aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to
        processes with recovered clean pages")
        <br>
        Signed-off-by: Jinjiang Tu <a class="moz-txt-link-rfc2396E" href="mailto:tujinjiang@huawei.com">&lt;tujinjiang@huawei.com&gt;</a>
        <br>
        ---
        <br>
        Changelog since v1:
        <br>
          * update patch description, suggested by David Hildenbrand
        <br>
        <br>
          mm/memory-failure.c | 7 +++++++
        <br>
          1 file changed, 7 insertions(+)
        <br>
        <br>
        diff --git a/mm/memory-failure.c b/mm/memory-failure.c
        <br>
        index e2e685b971bb..fa6a8f2cdebc 100644
        <br>
        --- a/mm/memory-failure.c
        <br>
        +++ b/mm/memory-failure.c
        <br>
        @@ -853,9 +853,16 @@ static int hwpoison_hugetlb_range(pte_t
        *ptep, unsigned long hmask,
        <br>
          #define hwpoison_hugetlb_range    NULL
        <br>
          #endif
        <br>
          +static int hwpoison_test_walk(unsigned long start, unsigned
        long end,
        <br>
        +                 struct mm_walk *walk)
        <br>
        +{
        <br>
        +    return 0;
        <br>
        +}
        <br>
        +
        <br>
          static const struct mm_walk_ops hwpoison_walk_ops = {
        <br>
              .pmd_entry = hwpoison_pte_range,
        <br>
              .hugetlb_entry = hwpoison_hugetlb_range,
        <br>
        +    .test_walk = hwpoison_test_walk,
        <br>
              .walk_lock = PGWALK_RDLOCK,
        <br>
          };
        <br>
          </blockquote>
      <br>
      Looks good.  Could you add this to stable ? <br>
    </blockquote>
    <pre>Yes, I will.</pre>
    <blockquote type="cite"
      cite="mid:1f5d5a50-2f30-4c1e-bdb2-1c0103cb5b07@oracle.com"><br>
      Reviewed-by: Jane Chu <a class="moz-txt-link-rfc2396E" href="mailto:jane.chu@oracle.com">&lt;jane.chu@oracle.com&gt;</a>
      <br>
      <br>
      thanks,
      <br>
      -jane
      <br>
      <br>
      <br>
      <br>
    </blockquote>
  </body>
</html>

--------------xMrF6xzqVC3RQeUR7lcAhLhG--

