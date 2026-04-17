Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF83FF43683
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 09:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B43C6B00CB; Fri, 17 Apr 2026 05:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264FC6B00CD; Fri, 17 Apr 2026 05:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109886B00CE; Fri, 17 Apr 2026 05:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED7036B00CB
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:51:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9ED861A0BAF
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:51:22 +0000 (UTC)
X-FDA: 84667580004.08.1B193EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E87ACA0008
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:51:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=axeTsh32;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776419480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BzmzynMP0RSieniwMBz4CmtO50ZPEFjyN9YOZsqikg4=;
	b=co2EMu1oItlhnivQ7Cq7mlpCgQnYpJ2RUyNsjzINN6BVRWqnAmt4VucOZ7QMTgpam4hMuO
	rDvbSMuR7hplKDTawnvr0xJf5cma8Nuzgw4d9eda4Ngt8oxSRyy1mgQNbzE+7n0IYwVYuy
	EIpr5cLNeotwR01zfvhZ5aTRzHkEDxk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776419480; a=rsa-sha256;
	cv=none;
	b=mf1X6eOZzFUcwxRvEfoX/fbXrZTNskZDCt6N5wtjzaFURvGunK49afx7xH44P/4bVzMKdh
	TbhJqrVQPDk+BF95me6wSxvaZZ5fpDF/nVZp7EW/mqpk4OZfTYtZQ0R8U3LtptlT6Y5+Gg
	yCwaIEAoMjFv+YhOvVz2ALlY9uuTXkY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=axeTsh32;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 01A6160139;
	Fri, 17 Apr 2026 09:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEB9C19425;
	Fri, 17 Apr 2026 09:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776419479;
	bh=K+ulvf1w3U8a+KN7T54hOG5ryDsrSUTMSLNev+ah4n8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=axeTsh32UDz21vorG6qIUZfQps/zki7+NJKe37MM9zm6w5EAS+rFUB6gJtPxVqnsX
	 FbAq5V+E0dIzK5/ESp44Cli783ETjOJheLC0xDbav7zo4CSAHrPM0WTsbbYl1VZBx0
	 0CdJ3vhzP7NDO4dO/2MTKX2bqZPFNc3f+Rkwiv1QZgpE49xodyWqhkXIJr0MxwZaRo
	 MSHzksXcgrnR3KgkVgwU+hveiav8PTVHEwaKQbi1Sv2zBigUqSYh3Qq5GaDtv1YjBN
	 2X6V8/4f04OqvGXhSyXHu1/ucyYS9RExfftp0iMXlt9wAihcbGdKG3zBvqz6F3I5FO
	 S4jm5ppN2FiJQ==
Message-ID: <6d4f702c-5ad6-4f84-a73e-c9e34965be98@kernel.org>
Date: Fri, 17 Apr 2026 11:50:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
To: Gregory Price <gourry@gourry.net>, Frank van der Linden <fvdl@google.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
 kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
 dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com,
 ira.weiny@intel.com, dan.j.williams@intel.com, longman@redhat.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
 linux@rasmusvillemoes.dk, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 muchun.song@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 jannh@google.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 pfalcato@suse.de, rientjes@google.com, shakeel.butt@linux.dev,
 riel@surriel.com, harry.yoo@oracle.com, cl@gentwo.org,
 roman.gushchin@linux.dev, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
 zhengqi.arch@bytedance.com, terry.bowman@amd.com
References: <20260222084842.1824063-1-gourry@gourry.net>
 <3342acb5-8d34-4270-98a2-866b1ff80faf@kernel.org>
 <abwRu1FNqI3dVyqL@gourry-fedora-PF4VCD3F>
 <2608a03b-72bb-4033-8e6f-a439502b5573@kernel.org>
 <ad0iT4UWka3gMUpu@gourry-fedora-PF4VCD3F>
 <38cf52d1-32a8-462f-ac6a-8fad9d14c4f0@kernel.org>
 <ad-r7hwIdnvKsrh9@gourry-fedora-PF4VCD3F>
 <CAPTztWajm_JLpp9BjRcX=h72r25ELrXeGkOXVachybBxLJGS=g@mail.gmail.com>
 <aeA6aNDpQ-U5UJCs@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <aeA6aNDpQ-U5UJCs@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E87ACA0008
X-Rspamd-Server: rspam07
X-Stat-Signature: o6s88b3mbope9pdcaj8gw5zm517a9iaw
X-Rspam-User: 
X-HE-Tag: 1776419480-160252
X-HE-Meta: U2FsdGVkX18ijXu/wg2pnSGcwZtbxfqmh6VIsj9vtqEvCw/Y75J39bViQY9K2Mm3GJ+qw9+rwwSGjhgBwGBKSYNspMtG296Zk8vCU2N/QWDl8pDp32UYV5ibo7kqTR1hDhOHugzqeCutaT0+IloauRA2BFtLD/spKAmyDmrp5QtIGXy18dlaNFzysMIIsOKm8RIZl9x/BYxU/obuHA/aweM7Nzv6Lwm2OuQWn7O4CifeTqIEWoGjytl25z7v4+6mupMQGRfiNgJn6Dw/iDU3eblZ2V24x2XmTliwFNXRmSrco6qwlcWXyFeQZtzEJu07Q678tYcQkGsT8j/4yFdCklHINEqUkpQJXG1xCMb82r7huiIs6tsiJCxIbxrH5FNE/aLfUayCzOvJh0PRRmaQJ4hMQmbHhytoErwiRK3Geo3c6BrpvHmPyVL0LwYyuokA1Vz8Qv+LpEQ1QtHPkFzczBhqqnf69lTJKM6bNT6YNWQInSBEysbFqN5AUoux78lzJnbfrFV5fpcVgd37jBd5lXjKXqIJzvfMRD2jppJRgdatAyV1TufVE5CDzSoi0EyuxSlr9e7lMMWHuT+CcWAaMqjAgIv4w+7f5ncBTRM2qNXDLnvCR8VR914XEJwN0DiQhFU9Ux3KTMFvUUhR/iFCMrg+/gF3L424slRM+QL61uiaWUeKCZ/tQEY8pnFv+Uz4EQwyFCGZ8kgAz77ycyqd9BcYHlkofq9XziTxEBME4uvgVmXRVH6kU0PM52dkLE+Fox0q5PbhJjJABQE/WrA4bV0CwSpJcxyBfpYP0LVnlCumV3vTvhcYMiw0sQuAj2I5ySVlB3+38mxTy5eXfvO14cAR7XP+0Uf4RAN+aIrqnWX1KymRFyyIncuHgLiVps2fj9Hz62N2+ZPWPfhkEdrMxtjhWwaDDJA+LrtlMhntll8Fy6fDIqRv2tLs+h99bQkethIiWRyUyXyiMN2Rdad
 GNeNNvyL
 Js5HJ+MULop4sJW1cSG0IRp5Gvc3yJgDqm4EkdKhbMIUr8vGtaU5TGDFNuFTYKoP7lXTZcJHZdpUi+/6c8nspQSM2LQsa9P0ezlwvj86GeOveQh9L1ObsDQ9q1EMoI51mLtwjPZZU0RxGXedssQNnrZaiCs/WBYoicvKXP0M46KWqwzyOhs7tXuOmwMjTIm8tAjKyVW7g4WPS6UCN/AbJGXdBu1dJyuLjw/4QxS/UkUbH1dz4a17tdvyyPY5LdaOMRjyhyzGPyxIseY9mAW5Vs7oF+C3xEI7bPrbXXSE717Zt63AIsFjr7sIfcV8n/WEi0OpVui6p2M4XLLo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 03:24, Gregory Price wrote:
> On Wed, Apr 15, 2026 at 12:47:50PM -0700, Frank van der Linden wrote:
>>
>> This has been a really great discussion. I just wanted to add a few
>> points that I think I have mentioned in other forums, but not here.
>>
>> In essence, this is a discussion about memory properties and the level
>> at which they should be dealt with. Right now there are basically 3
>> levels: pageblocks, zones and nodes. While these levels exist for good
>> reasons, they also sometimes lead to issues. There's duplication of
>> functionality. MIGRATE_CMA and ZONE_MOVABLE both implement the same
>> basic property, but at different levels (attempts have been made to
>> merge them, but it didn't work out).
> 
> I have made this observation as well.  ZONEs in particular are a bit
> odd because they're somehow simultaneously too broad and too narrow in
> terms of what they control and what they're used for.
> 
> 1GB ZONE_MOVABLE HugeTLBFS Pages is an example weird carve-out, because
> the memory is in ZONE_MOVABLE to help make 1GB allocations more
> reliable, but 1GB movable pages were removed from the kernel because
> they're not easily migrated (and therefore may block hot-unplug).
> 
> (Thankfully they're back now, so VMs can live on this memory :P)

Heh, but longterm-pinning would fail on them (making vfio with VMs
angry). Similar to CMA hugetlb.

In the latter case, we should have a way to identify "this allocation is
actually from the CMA owner, so longterm pinning is perfectly fine".
Checking the CMA alloc state would be one approach, but that's rather
nasty. I guess there would be ways to make that work.

I'd assume that people barely rely on 1GB ZONE_MOVABLE HugeTLBFS Pages
(iow, mixing kernel-cmdline ZONE_MOVABLE creation with kernel-cmdline
hugetlb reservation).

I'll note that there was long long ago a proposal of converting
ZONE_MOVABLE to "sticky-movable" page blocks. It wouldn't really solve
this problem, though, where the early boot code just does something
that's rather stupid.


-- 
Cheers,

David

