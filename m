Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DF5FC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 09:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1B16B008A; Fri, 24 Jul 2026 05:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1BF6B008C; Fri, 24 Jul 2026 05:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16C8E6B0092; Fri, 24 Jul 2026 05:59:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D38BC6B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:59:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47521C01D9
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:59:51 +0000 (UTC)
X-FDA: 85023223782.18.CB00849
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9BC8440009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:59:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k0HxrWGF;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784887189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViiLl9ZFF0UEdOn7wLcmnHat7EVRXfbwbFG0wZYEi10=;
	b=hFuHzHtOvSMyS5rz4OHmXvtejiuiCEtkt2YtLySYBh4lmhZgzhM3Nfpc5wNbi5ii+VyU6a
	8SmWJ43A16lhzsEro0SpqX1A6YG/sNVHhU40M5wEFZSmWv8WB0XCpQDIKwYrPrN9Fgywa0
	86+4MH0wHtuDahZBpJo6zImPUHR8i7A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784887189;
	b=4HISZBdfgfP6dkbC0vvDvFnYI1LGdwOzjZcIq7Mm08yxywyoxt6iGKSzjIR54uZnurQH1p
	/MJRd2JyY9oLXEyQpiiUwxkP4QeDtkDEFzGVjM7qGyxG9ym5Jjk68KfhblFO5QWFJQzt9F
	1L+p4Vh+vyG+lpuI791wD9iJuGAeW4c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k0HxrWGF;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <c40f4a8b-1f60-45ea-962d-0597c413ec3d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784887185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ViiLl9ZFF0UEdOn7wLcmnHat7EVRXfbwbFG0wZYEi10=;
	b=k0HxrWGFl2ltc7kB+r1juMoWhA3cgV5epPavsYp57+2JiERhX+D4oeLdbHCEwKtwhy6ele
	jMSgTe4dzXRGXhKy+j7N+gv3IFru1lL8m4dFAlzICSatZDbo9F9VTeGpWxh9yi5+lcdLCW
	7TcoyNw+C5AkTZM54vbVq6/RiE2eWZw=
Date: Fri, 24 Jul 2026 10:59:40 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v5 04/11] mm: zswap: add range lookup for large-folio
 swapin
To: Yosry Ahmed <yosry@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton
 <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org,
 ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, kernel-team@meta.com,
 Alexandre Ghiti <alexghiti@fb.com>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-5-usama.arif@linux.dev> <amFZmtGHEZjXEw5R@google.com>
 <ee172b01-54c3-47ef-9040-1342a1566796@linux.dev>
 <CAO9r8zMzjCf620EHwzfosngc94fu=vAb=ukrtOi9Qf3rA3vv7w@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAO9r8zMzjCf620EHwzfosngc94fu=vAb=ukrtOi9Qf3rA3vv7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9BC8440009
X-Stat-Signature: do8k7wpwikzbxf938bu69zpgf7ge7sjn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784887187-316250
X-HE-Meta: U2FsdGVkX199836w3XtmWAmWdO/nU2B7y+4KJLKT+0elOV9QmMDFqPdnZq1inf66EHt8pfomqa6jH8Xq3ZEHKk/123z9/8SS7lZiDM0uvuqgDpJezNzHh3iLoPDzqEnUz9H2AXF+JdrRrSWAk+YjX4ufzgXyj7tObrGF0QsMnmcXvVD74b6DkK1nRDE1hVdK611KGg+/bOgouYTwcpZdHSae/PSg7Y+sHP9opYZzmQt0C15WKJSmgoQUxKpvP74PizbDuKIAuj2WreFW9cUYGMSrRS/JobVWRTUI1+9Vgi/zSBNDj31RIMiDmcIvWyeAG7Z0ZenDS3c+xSLi94DcfZm4nc9r46Zg10Zx0AopHP/BdFBsvXeHFQAvv+hbXg62rxWOVGzquYdcD10Ed2OGUFvCXHUt8SNbNUlk/2PzMj79IubUylhxq/ov+X5v97nNMjxK6JZ6uX+5d0mr+Abxy5J/KcCzM/Jufo0IDBgj/n3RwXV1tYCguKrXzO/f+xs7T2MRIMIsRJm7wUusa8uYrPLz1IyQNbMo0WFFXViyYMa7aBd5GaPtzsBSWUajHPkbMnI8ttVwypl01hNW/bXOdC4If3TmRAUzosoPczgNDRyV36SU0ntMs7JiFemiHYFXCouEyXFQK+2kM78Y4aP5vm46acDdM7G7VcOva9CM9grJQ233YSOsSg05bvvexSZlxUjB/f1PxeqGO5QdWaLIojfjsbXm61q+mZRvATdN2HANnK0IYgV9IQDZw+g/z+8fQq2b4a8a75pjoQHRmeDgzjrHfckoQnqUzjGO3Iz9JtYVAbgV6hu08mO5Xl4Osidi/O+P5ZeVfna9jn0yWN7m/4FK/C9gY1F0o1y8FwumSMxJEHl30NwtyEFOdooxZvd/Gn9fhnbG90vL0og+UeEoAKctArGI8Cq+yN1DvOz+HjVtJt4quEhAZ3phFNdQIoLO8sKoxEIVuiH5QRqeS9R
 XmOodnZR
 BqwMjVSnEMPJb40M44NJ4MmlIl5IxTSmBHmQkfjBiDBBQo+VrjoukE0yJKiVuPALC9gkrSKP0A0P3C/13kGWO2tAVrHxfCF8psyxCy92JEj4WLWr16ZkJwdGm2zD8e1cjyyFW3PfVPfoKfGT4yl8/n+J+nfAoWwpYqnsQSxpK8ez74vIkQSVm5Ba/2PVaLXzXGca9FlvPOGqgXli817Vv8vnWDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/07/2026 17:42, Yosry Ahmed wrote:
>>>> @@ -1595,13 +1611,19 @@ int zswap_load(struct folio *folio)
>>>>              return -ENOENT;
>>>>
>>>>      /*
>>>> -     * Large folios should not be swapped in while zswap is being used, as
>>>> -     * they are not properly handled. Zswap does not properly load large
>>>> -     * folios, and a large folio may only be partially in zswap.
>>>> +     * A large folio reaches zswap_load() only when its whole range is
>>>> +     * expected to be on disk: PMD swap-entry consumers split before
>>>> +     * calling into PMD-order swapin whenever any slot is still in zswap.
>>>> +     * Confirm the range is entirely absent from zswap and return -ENOENT
>>>> +     * so the caller reads it from disk; if a slot is unexpectedly still in
>>>> +     * zswap, fail the read rather than return partially-initialized data.
>>>>       */
>>>> -    if (WARN_ON_ONCE(folio_test_large(folio))) {
>>>> -            folio_unlock(folio);
>>>> -            return -EINVAL;
>>>> +    if (folio_test_large(folio)) {
>>>> +            if (zswap_is_present(swp, folio_nr_pages(folio))) {
>>>
>>> Is dropping the warning here intentional (for the folio_test_large() &&
>>> zswap_is_present() case)?
>>>
>>
>>
>> Yes, so we can end up in a race, which should be handled gracefully.
>>
>> For example, lets say we have zswap writeback enabled, which means we
>> can end up in a state where we have a PMD swap entry and 511 of the 512
>> slots have been written to disk, but 1 slot (slot X) is still in zswap.
>>
>> We can then have the following race:
>>
>>
>>   CPU A: PMD swap-in                  CPU B: split-PTE swap-in
>>   ------------------                 ------------------------
>>
>>   Checks swap cache: empty
>>
>>                                        Faults slot X
>>                                        Adds order-0 folio F
>>                                        zswap_load(F):
>>                                          removes X from zswap
>>                                          marks F dirty
>>
>>   Checks zswap range: empty
>>   A is preempted
>>
>>                                        Unmaps/reclaims F
>>                                        zswap_store(F):
>>                                          puts X back in zswap
>>                                        Removes F from swap cache
>>
>>   A resumes
>>   Allocates large swap-cache folio G
>>   zswap_load(G) finds X in zswap
> 
> Why don't we check the zswap range after allocating a folio in the
> swap cache? I am assuming at this point we have the folio locked and
> the result should be stable?
> 

Yes that makes sense. The folio is locked and the result will be stable.
How about something like below?

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 1f08fb522036..41f168377cb1 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -12,6 +12,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/mempolicy.h>
 #include <linux/swap.h>
+#include <linux/zswap.h>
 #include <linux/leafops.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
@@ -500,6 +501,17 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
        __folio_set_locked(folio);
        __folio_set_swapbacked(folio);
        __swap_cache_do_add_folio(ci, folio, entry);
+       /*
+        * Reject mixed zswap/disk backing before starting the read.
+        */
+       if (order && zswap_is_present(entry, nr_pages)) {
+               __swap_cache_do_del_folio(ci, folio, entry, shadow);
+               spin_unlock(&ci->lock);
+               folio_unlock(folio);
+               /* nr_pages refs from swap cache, 1 from allocation */
+               folio_put_refs(folio, nr_pages + 1);
+               return ERR_PTR(-EBUSY);
+       }
        spin_unlock(&ci->lock);
 
        if (mem_cgroup_swapin_charge_folio(folio, memcg_id,


>>
>> The correct action would be to reject the PMD order read and fall back
>> to per-page loading.
>>
>> I am bit torn about what to do for zswap here. The series is quite big
>> already. Alexandre is looking at adding support for PMD swap, but will
>> send patches once this series gets merged. My initial versions 1
>> and 2, basically stopped installing PMD swap entry if zswap was ever enabled.
>> From v3, I used Alexandre's suggestion to do zswap_is_present() test
>> so that PMD swap entry can keep on working.
>>
>> Both of these paths are temporary till Alex sends his series. I
>> do feel my initial version was simpler but will basically stop
>> working if zswap is ever enabled. Do you have any suggestions on
>> what your preference is for zswap?
> 
> Even with PMD zswap load support, we still have to deal with the case
> where some order-0 pages are in zswap and some are on disk, right? I
> don't see how that would eliminate the case you mentioned above.

Ack, yeah writeback will still mess with things. I will keep the current
implementation.


