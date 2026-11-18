Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C250606A8AE
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 06:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ws2Z7/Pb
Received: by kanga.kvack.org (Postfix)
	id AD4936B00EF; Wed, 18 Nov 2026 01:20:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAC526B05B0; Wed, 18 Nov 2026 01:20:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C1B06B05B3; Wed, 18 Nov 2026 01:20:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5106B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:20:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03795120676
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:20:10 +0000 (UTC)
X-FDA: 85447239822.26.9900BFF
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf22.hostedemail.com (Postfix) with ESMTP id 28B1BC0003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:20:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="ws2Z7/Pb";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794982808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aH8cEp7px8xcaLzznaOBQdWewlYuvVH2iWUw8OYAWwA=;
	b=bG7wm/j7gBdtucVL2fGs1IYj1Q3SXaQaiSwBDKp1IVujMzqP+WCZr5t0igz3FAWLYMG1AV
	2rw5X0s0jQ6oQX2cronkUADl5WaitUWcyJ0JSoS9ZflQ3uWcM6uvenTm4od/gu0IYTyeLU
	CRjYhtttVz5WZYw631+/sia61kfB8Qs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="ws2Z7/Pb";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794982808;
	b=yL5+OP+g4+JH6emmEPj8v+NUgVHu/Etob8TajfPnv1JaOcaHDsoGLtn+FkG4GHC0V8asTV
	5luQYsa/rXqEgK4Ia0/de9lyGoajNDZltCy+s1ZQWTdsHqJ+zv/c0dBJ+VbzLA0StguzAk
	ctCxfxmmHWUUh5K6AgFEt3t38ETWjk4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794982802; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=aH8cEp7px8xcaLzznaOBQdWewlYuvVH2iWUw8OYAWwA=;
	b=ws2Z7/PbzJD/U1GPXewf79MWh0Oi37QfVzR1Q0+8XL+W7261elsX1JjkutdEN7Ccw7mvyVcSK7sfZVfg2KPMyyzmsr74lzqe+40Mv6h24Ia8mrujkd0fqFYwpvLJ6rx4vFDBzKpET1mwQm2cVS2vPvtBmeo59yALxEaslvQPvxc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XF.fZ3i_1794982798;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XF.fZ3i_1794982798 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Nov 2026 14:19:58 +0800
Message-ID: <430c6b67-76a2-4f67-abb6-e28d07a84bd4@linux.alibaba.com>
Date: Wed, 18 Nov 2026 14:19:56 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: use memory barriers for non PMD-sized folios to
 sync
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <6274e62645b9f176dd10d7a79e86b900a39cec5f.1794898535.git.baolin.wang@linux.alibaba.com>
 <c254a38b-d5e5-40d0-8d70-c6baa850cf2a@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <c254a38b-d5e5-40d0-8d70-c6baa850cf2a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: imkgxhjx49qcz3i1iayeg46nfr774m6u
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 28B1BC0003
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794982805-800573
X-HE-Meta: U2FsdGVkX1+EmXVCaRQwr3Cxhgc47qzf/k34ZQW5Uv8iHJkOyJy4odOzKBEDc8ZyI1PoZgMe+zhqkR8UTfeOwZ7FJKyuw7aAgHlAmG575TVNZZo1Zev9qe6TD9Ug5CRxdTdxA/lPY9x68PUjiGHXaG0JzeZcHg/6smAS5tSQ0sur/jqUUp1IOjQkjyD7Kb86u6AWChdmccjpojrIWZGcdoLAc8DNTwGPLovdP+mafFY5k2KIUP8XeULCyYmhv/yy5ZHfI0r1mV/sQlF7JSSyem1S1vqnzMlaTNc03VEzs5LtybDiZEMcl2fKhCMnaXxUMXIYmg/HEaIepW339uDGVKwF6Hx4Ufix/1h29R+06zyY8xW+YokhTI7IlNuj1PIeLZ1jbnvzU4mipmF9sVNxjvyOqbEix6Ekdcr0+YxAFbwPmfkeWVLW3YeVlK2QEkxN0/qmqfBmihfd6gBa+EU/8xLXqeTfjStq0Stac3bx4ouNVjbCtqNn1/zQr2j+e/0s15OBOuL4ad+aH+JyYywuR9ZuzxcAHZIrFP5IyhvevNEC9QRLcH9bfPdO58UHY5XyS4AAsRfqH3AH5I8ExW4usbiixSxXfsLji4OLiGao8h2sA2jiXrhvkWLo6Hn/2+Eyt/joICSpR5GJor8jH6uu2I2U5MrlgyRrwGqV9V0tCRWB3w0O/eQZpdGXr7O+Gu3ZA8FbRq8X3okDs++F3+Yeb2/ZZXQ02VaeTPs9KbRecViZ9Laze7o0z5ab6GztXg5FbM8riaCWhV4UjzGNb1QQAA3jGSr5nqrMVhmlNrLX1ynHU41P702b1PlUAwjpr5VWai34ekePqFPTgV+WdwoxzREM9pgYgLpkdQ4Hkj7aCjUyVxzMzFV3uw1d2J8JQfiEDyv4cbi+6w5bboO1Y4yp/ZW+mm6iUOM8c/ev+A909seRvJjx+gM8VRJ/quZInTNfcKAThQQmCq4+7NRoTGG
 1eEcp3u6
 jPHq/vOmLm/hvaZHPiOapzs8ojdqTClkO8Rxx8CvhXouA9L6jBQ1Rnu0bZ4WFTZS9MbeJdUpRJ5GsPGmy+WUtIEEceCFeTFKdE3HjfqM6enzzD61Hgcv/pN29k/vgwOkcpUU2uQ8Tu+Vt+Op8zHRPAafxI6IXZqCQl+6SkLN+GIY761en4eIP3ayzvHFkug/lYulcJTrPx6HoX+aR/W5u9RKYsW5l1uVcLPYPNNCEFgQXzbKXp5jpAdBkfNvyhSLr6zAdBTnXNZsmE9Q4H1ODyznTf8lR9T0ELVEx/5xs1C9KZ3nrejmxV8/7VjNxte4YASsR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/18/26 5:19 AM, David Hildenbrand (Arm) wrote:
> On 11/17/26 08:00, Baolin Wang wrote:
>> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
>> uses PMD lock via sync_with_folio_pmd_zap() to synchronize when a cleared
>> PMD is found while unmapping a folio.
>>
>> However, for non PMD-sized folios, the only PMD clear that can race with
>> this unmap is PTE table reclaim, which clears the PMD only after the rmaps
>> for the table have been removed. This is plain message passing, and taking
>> the PMD lock is more than needed, like I did in the previous patch[1].
>>
>> Without barriers, the walker can observe the cleared PMD but a stale
>> mapcount on weakly ordered architectures:
>>
>> CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
>> ================================    ================================
>> folio_lock()
>>                                      lock(ptl)
>>                                      clear PTEs
>>                                      remove rmaps   /* W mapcount */
>> [mapcount load satisfied early,
>>   folio still mapped]
>>                                      pmd_clear()    /* W pmd */
>>                                      unlock(ptl)
>> pmdp_get_lockless() -> none         /* R pmd */
>> skip the PMD
>> folio_mapped() -> true              /* R mapcount, stale */
>> unmapping assumed to have failed
>>
>> Pairing an smp_wmb() before the PMD clear with an smp_rmb() after the
>> PMD read forbids this outcome:
>>
>> CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
>> ================================    ================================
>>                                      remove rmaps   /* W mapcount */
>>                                      smp_wmb()
>>                                      pmd_clear()    /* W pmd */
>> pmdp_get_lockless() -> none         /* R pmd */
>> smp_rmb()
>> folio_mapped()                      /* R mapcount */
>>
>> If R pmd observes W pmd, R mapcount must observe W mapcount, so
>> folio_mapped() no longer reports the removed mappings.
>>
>> Pass a 'folio' parameter to sync_with_folio_pmd_zap(), allowing us to
>> skip those pfn walkers: pfn_mkclean_range and mapping_wrprotect_range,
>> which don't need synchronization.
>>
>> Similarly, skip sync for page_mapped_in_vma() since the subsequent
>> operations don't check the folio's mapcount.
> 
> Do we have any way to measure the benefit of this? I think we'll need that to
> convince reviewers (like Lorenzo :) )

As I replied to Lorenzo, I will try, though it is hard to measure the 
performance for this uncommon race case.

