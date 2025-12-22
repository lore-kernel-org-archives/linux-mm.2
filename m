Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B57BED68BD5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B6956B0089; Sun, 21 Dec 2025 22:01:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281EB6B008A; Sun, 21 Dec 2025 22:01:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ADE16B008C; Sun, 21 Dec 2025 22:01:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2E16B0089
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:01:33 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9C3EB1409BA
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:01:32 +0000 (UTC)
X-FDA: 84245606424.16.121B3C5
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf20.hostedemail.com (Postfix) with ESMTP id A88FE1C000A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:01:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=N6UMCA1D;
	spf=pass (imf20.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766372490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/NJyvc3PgNYOTFxlhtVOKVMv9S/i9bqSK4QKL3La4/E=;
	b=rIaf/J1+63xr1wLampSlWDWz/tCMAjJ+K4+uuPP+qGqcu+LbiqXEo8Ii4BxxG9UNha96Vi
	q0/n6iXcoVTDL8Vl4WP7PX05dMjNeoc8RmTWE79PQ2FpTKcsNi1j45eY0R8YFFsTrYGh2B
	UQid4VPXgYwPaOGwPG16M78XuQ0/0N0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=N6UMCA1D;
	spf=pass (imf20.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766372490; a=rsa-sha256;
	cv=none;
	b=U4JjwQl0UlIp5oNpdOnUNWpUD7Atu+fXy5c+38ze510KUuGfWNloCQLzBMDJxlwghipSX1
	Ao3TptOZGn1fr71unaAu6GLt8iJFao/5koBVabauX0JXKzIQwG7hFB2YNdw5Gj+T75j47K
	TReB1j4bIHU7w7Oy6a4TwwaHRpd86xI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/NJyvc3PgNYOTFxlhtVOKVMv9S/i9bqSK4QKL3La4/E=;
	b=N6UMCA1DtgJeIoYtheayhpcT3L3ynp0uUtd+f+M7MLngQXSI7ZI0HBAoDQA1IcQ8Ryae4M6tS
	GvVcWTbSG8pFDY3uidrVZvrSV12mzyJy8+bhFA2BbUKQchyjZjkERsObSE0Q6F2iXvV8CX5MkOO
	Lm4iMlocPAFm3tP3ABF5cok=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dZNB213cjz1prQ2;
	Mon, 22 Dec 2025 10:58:18 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id BDA4D4056B;
	Mon, 22 Dec 2025 11:01:25 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Dec 2025 11:01:25 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Dec 2025 11:01:24 +0800
Subject: Re: [PATCH] mm/memory-failure: teach kill_accessing_process to accept
 hugetlb tail page pfn
To: <jane.chu@oracle.com>
CC: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
	<jiaqiyan@google.com>, <william.roche@oracle.com>, <rientjes@google.com>,
	<akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@Oracle.com>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20251219062819.2499399-1-jane.chu@oracle.com>
 <eade3d62-8102-22a0-637e-ae2e34f11406@huawei.com>
 <38c098ea-95bb-476f-80c9-de9231b9c991@oracle.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <93ce8e83-500f-9f97-a90c-64d9b3c73f3a@huawei.com>
Date: Mon, 22 Dec 2025 11:01:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <38c098ea-95bb-476f-80c9-de9231b9c991@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A88FE1C000A
X-Stat-Signature: 53jpedznbrg1yjzec6zud74gf4jd8jr5
X-HE-Tag: 1766372489-316737
X-HE-Meta: U2FsdGVkX1/qvAZgRpyGjnX2NYLsVqDjxQnPsaNP2ZC/nPBp+fzvzPFzPULM6m2e4NHxAUJ/l89m5efL9KVB9tAgXDqbTwiXl3ElaJaA+5B2HLrB63ZR2OdiU3XG+46bubYny5hCTGrOFxBwEjKFQ4vrnDZNXL5GkC0fzFp06AStWYSG5J6w4tdZ8BfHckpWRqf5QF7Am6xhHDKirm/aeRckAZjaOKuskAerUI7YxIS9y9YjpleidMNbAA9KGSHZZhaFseZJbeHJhs6A8qDm/ThXAcP0/HiYx0gQEOZSLYHBKkpinK8K8lyVqnkaFo8yWuADt4etRF5VEHtzgxuCog6MLiZT6VP4ip8tBQ4PNog+5s0bGeabsE1E08MzQ3NpnvNJzSR7SJtU/xmzc5ozk8mGShrkQ27gWrsVhOGkgAUWT+jWamIXK5xjFVgy2UMLfU71lIMc0njCSFNRk/8JSuc4YsBuNsP1uQEKGBS3KHYSftjmberD07uXVilocrWVyVxj4clIgDjsLvlGRIsUzTukHfOPk441hTi88rgHEYEpvO/kiB9n5x1G6+oFejc1YsVo9ZB5Mz15eLmrY/cOPcVZq5vG050vAwu8ifoxabJUs4Vlb7Yx/OUEhS0SSChZ41LnDxM84vJRsExGh44KsYtNhRY1TnqtCMPGAizojXmnhxGLBjhBuLnIiVD0J1ZBfIjWsSHfz8F/n0fsut/TLKktmiO1JQYYcXQyGjMEeYwRrHggCCtX5xL5M2Ce1+PbV7auscP/3vzZFKvQZcCmAVcJW+ID6QYtzrKhv6sk//ZEPANAZmmR4XRa8PR0Pum2RKWJQ0ivMEaFqMItdhVeMNAouULqR2aiz5aqXUTiyuDUgGco3HTRWME7cgbhn20ehJpFJLBVFxSDxPJ5ACBXqTTZWufJWEVCcbQYw655QzTpXgWMvKM1uTKVJgZ9ZVjgJV1/GdPNCwRrtlz9yRD
 UPEpUK0q
 vOfnLxTp9UgV5Zoj0ZqSEmVCDHJbkyYV9/kS1Gz3tGwLmfW7sWy9BgY9AHDXs4ObhMojmxO3akhD3I3Ciljz/kXxO364ugZrXWtnW4wmbNn9ZWHOcMvxeYU/9Cwu/1/FMo+NKbvQ6KxwJf7X16ubVoQMId6wwWP/jmWJ0jfi0qiCZZZObHtl5iJmaNI8dgO4LErWQg95A2u6/a4b1aR0u5aQbimkW2yHXsEsueaiIUNMf2UeSIY4D8XymfHt2Ea8qVWdQ0CpfA1sg8BB+Elg1tq/CYh+mo6+eYxuPEdNNNMJUcs2jwJf32JkX+Pub3cH2ngTcz8Reae9xubFmoS49NpwrIlI7HRYy8Sl6Pqz/dnnAlSf0ZsCM/yaWBLAwbIAtUj2pfGkDIElftC7hzEiALMizYbYzi5LSKZUeW3ID8/niafTophg7U9m2UIe1J2WOneCHooOysW+BtNI1xgLW5YceJe68V8SmXnuy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/19 16:06, jane.chu@oracle.com wrote:
> 
> 
> On 12/19/2025 12:01 AM, Miaohe Lin wrote:
>> On 2025/12/19 14:28, Jane Chu wrote:
>>> When a hugetlb folio is being poisoned again, try_memory_failure_hugetlb()
>>> passed head pfn to kill_accessing_process(), that is not right.
>>> The precise pfn of the poisoned page should be used in order to
>>> determine the precise vaddr as the SIGBUS payload.
>>>
>>> This issue has already been taken care of in the normal path, that is,
>>> hwpoison_user_mappings(), see [1][2].  Further more, for [3] to work
>>> correctly in the hugetlb repoisoning case, it's essential to inform
>>> VM the precise poisoned page, not the head page.
>>>
>>> [1] https://lkml.kernel.org/r/20231218135837.3310403-1-willy@infradead.org
>>> [2] https://lkml.kernel.org/r/20250224211445.2663312-1-jane.chu@oracle.com
>>> [3] https://lore.kernel.org/lkml/20251116013223.1557158-1-jiaqiyan@google.com/
>>>
>>
>> Thanks for your patch.
>>
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>>> ---
>>>   mm/memory-failure.c | 22 ++++++++++++----------
>>>   1 file changed, 12 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>> index 3edebb0cda30..c9d87811b1ea 100644
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -681,9 +681,11 @@ static void set_to_kill(struct to_kill *tk, unsigned long addr, short shift)
>>>   }
>>>     static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
>>> -                unsigned long poisoned_pfn, struct to_kill *tk)
>>> +                unsigned long poisoned_pfn, struct to_kill *tk,
>>> +                int pte_nr)
>>>   {
>>>       unsigned long pfn = 0;
>>> +    unsigned long hwpoison_vaddr;
>>>         if (pte_present(pte)) {
>>>           pfn = pte_pfn(pte);
>>> @@ -694,10 +696,11 @@ static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
>>>               pfn = swp_offset_pfn(swp);
>>>       }
>>>   -    if (!pfn || pfn != poisoned_pfn)
>>> +    if (!pfn || (pfn > poisoned_pfn || (pfn + pte_nr - 1) < poisoned_pfn))
>>>           return 0;
>>
>> Can we get pte_nr from @shift? I.e. something like "pte_nr = 1UL << (shift - PAGE_SHIFT);"?
> 
> Why?  Is there any concern with using the macro pages_per_huge_page(h) ?

No, I was trying to get rid of new @pte_nr parameter. Something like below:

 static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
-                               unsigned long poisoned_pfn, struct to_kill *tk,
-                               int pte_nr)
+                               unsigned long poisoned_pfn, struct to_kill *tk)
 {
        unsigned long pfn = 0;
        unsigned long hwpoison_vaddr;
+       int pte_nr;

        if (pte_present(pte)) {
                pfn = pte_pfn(pte);
@@ -701,7 +701,8 @@ static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
                        pfn = softleaf_to_pfn(entry);
        }

-       if (!pfn || (pfn > poisoned_pfn || (pfn + pte_nr - 1) < poisoned_pfn))
+       pte_nr = 1UL << (shift - PAGE_SHIFT);
+       if (!pfn || (pfn > poisoned_pfn || (pfn +  pte_nr - 1) < poisoned_pfn))
                return 0;

        hwpoison_vaddr = addr + ((poisoned_pfn - pfn) << PAGE_SHIFT);

So we don't have to pass in pte_nr from all callers. But that's trivial.

Thanks.
.

