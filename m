Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C79D606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 08:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=W9G715Mv
Received: by kanga.kvack.org (Postfix)
	id 5F46D6B00EF; Fri, 30 Oct 2026 04:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A5026B05B1; Fri, 30 Oct 2026 04:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49B506B05B2; Fri, 30 Oct 2026 04:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28BCF6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:44:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6BEF616060B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:44:49 +0000 (UTC)
X-FDA: 85378657098.20.BD88C99
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5C91FA0005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:44:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=W9G715Mv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793349887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYu/kW3DhjeE7f36QmiPGs1R7yxjR+I5Ium8lq5S9Jc=;
	b=xkURQbK+0G/feiqpfaICyir1yWQXEKW2p9ykU2nFduD7fEek0xhwlkJ1NRzphImz/Czt7+
	DCZUCO/VIbt43YqZqcdivMKp1Rvxe9wUpwYdJAeZvb4cjjLcDyEXUnTfY8tz9ClkXrhLBf
	JSb5bjjbOQLBxicgK7aRDhiyV1vKNps=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=W9G715Mv;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793349887;
	b=yyEeGi4fOkHouEY00fMziKnzJ92ikCOj5Oz31zf3H4IUB1FE0c6RjZzvCFMX6zb/HlZuwN
	UTQw/Lez283eXGv6J5SFVHKREkSCF1L9Q/riIL0wBjnhVTZByna7+fNDXTiAUR++zX1gl5
	zG9GGsPPr1J6lCSNbtroxBd6m0wTcJU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793349883; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=FYu/kW3DhjeE7f36QmiPGs1R7yxjR+I5Ium8lq5S9Jc=;
	b=W9G715MvBpAFhQFtxunztd5ZGyM++QavC8YKB/aIpU/oEUDQcllofOAimHnAw73UiteZjBny5Zfq11FqeYan8ecZQxvNdYBPn9ivvmzZk7r30EI/5nKTcuYSgZfe1nRJwu/NlKlj3jQTpgzogSdevF3yx9pZzFPHvYEz1z20gYQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XDlh9st_1793349880;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDlh9st_1793349880 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 30 Oct 2026 16:44:41 +0800
Message-ID: <7b8ef469-d593-4d38-89b4-ba397bc3fea0@linux.alibaba.com>
Date: Fri, 30 Oct 2026 16:44:40 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: fix swapin livelock on a mismatched large swap
 cache folio
To: mt4022@columbia.edu, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 David Hildenbrand <david@kernel.org>, stable@vger.kernel.org
References: <20261027-shmem-swapin-mismatch-v1-1-84e30aa3b9e5@columbia.edu>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261027-shmem-swapin-mismatch-v1-1-84e30aa3b9e5@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5C91FA0005
X-Stat-Signature: 4q44xemo3w456n1i85f48p8rn8fjhafk
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793349885-990792
X-HE-Meta: U2FsdGVkX1+qdZ8jJ32MvqCuHNgL4E1uY/0pclEvIxSRSqCdzmL3jBqHgK84f74h1zVAn4a9nGerrlEWj3CM2J1d2Kq6BPezEnnkOl9eFMbl3SawGwQT+RMeGSGwP30WT+bIeGJenNiCtRkx6NwBghsg/jSTWbE+/69setJ01hgzaav1HYWUB6thyWIfKgYSiFro0/sFxM1gHonPg5kkWEYZvgZD9ZB5nitiH9WZn59oHcrW3UdNHFfDtmTh4sYQg6utpVXU06Q2RLLrey8742/bJy1+aFE9o3D3knrQ8fEHtN7Mnts56uW9Jo34yZSI1cNTzA9blCOjVrfdPK7AtvzgVagw4tNVMEhaORSMOF66yXBF7kyt5VqB72i86MGEyFa3A4ieHwOClXmLN5E3Az/+DveZWATupOOvMeFK+tw5xuDwRhMjbJS+XW6K77mXM606HXik2OLO1KROj/3/VCxivKd/U8BLeZwTPL5GPcNndhIXNbm4G0+Ux8jaYoPZcrXqB/ba22ZGLz6Ob1pdU5iqNwNqcioj2VrjIS1xoNDjsTNFEYBlMjBn8qtHB/e39JD3Cj2E2yvQqWi/vZrv9XJmyhmkv0ovSWgvpZ/bD8G/6Wt4bYuIoQR2eSin9ryYa6Yj/0xAzwhDedDhVU1jEE7s28KmR3an57Z58sQzfBrnJqOqoot0TzodhmOzE3ovBpw0Tfgp3WecjkXaiDj57FqjVjF89IfORmWMqzcXKRg1Lub2EzVA64lBTLOQkS+LmDQlp8ZeTTo5dAZcGWqdxVT5IEUaKhFsUesEiOsLPYjj6d1r3SC6b4MmbA6UqWrW2oACdvZUWAUucg5BAKO5k1x/ejUOzxyLG4uaWzsAVLQIqtwK7PcN4VVxSaI7uz4gyWfV6vQWYU4JXs7hknUIkKJ8i3iSDIK2u+jGeG2P3K4ejOoN97Y5QNHzYwrVViVDgJjtJC1RMkhOXWlu4Mt
 Fh+1VuXS
 tq/eQ5lbfQ3hjNwRnEQHxA74MlMMBCnTScZR/pzujjJ49bmY9KpY2ZA3xSJOSEqAclyVcw9MbYQJ2jEWbIEuGV0IO49Jw6ziqiKitXjMPi5TDkNNzY8A0YsAyFhIVNHA0cVTjSUjseiKO4wU0+nWDQm7maEeFR/iicwtHG+4vyBWA0d5ESdpO2LViq4P34GlXkGIl0POYvdBWmRbw6eE/76ypBCU2DdBQR4JSljj6sjuR3MV4rPvUDqrVA+/4IEsRru5KlqMuaPGLARqsWaRh/D2jxnbHpbJiQJ7nsAJmjHxA3PUVCKEeZWBmD3ECgVnS9aU1YCssZFN4A/2RouL7NB9/BxPlbEIBuFIkDmWeK6Bpp6px/JPuGdjgl6l0n2+Vlx5T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/28/26 4:33 AM, Mani Tofigh via B4 Relay wrote:
> From: Mani Tofigh <mt4022@columbia.edu>
> 
> On a SWP_SYNCHRONOUS_IO swap device, a large shmem folio can be left in
> the swap cache over swap slots that another file now uses.  Reading
> that other file then loops forever in shmem_get_folio_gfp():
> shmem_swapin_folio() finds the large folio, rounds the index and the
> swap entry down to the folio's size, finds no matching entry in the
> file and returns -EEXIST, and the retry finds the same folio again.
> Since the task keeps the mapping locked, a munmap() of the same mapping
> waits forever.
> 
> The folio is left behind when the slots are freed and reused while the
> swapin is still allocating it:
> 
>    Task A (reads X)                      Task B
>    ----------------                      ------
>    shmem_swapin_folio()
>      allocate a large folio
>      for X's slots
>                                          punch a hole in X
>                                          /* X's slots freed */
>                                          swap out file Y
>                                          /* Y reuses those slots */
>      add the folio to the swap
>      cache over those slots
>      shmem_confirm_swap() fails
>      /* -EEXIST, the folio stays
>         in the swap cache */
> 
>    Task C (reads Y)
>    ----------------
>    shmem_swapin_folio()
>      finds the large folio
>      rounds down to its start,
>      where Y has no entry
>      /* -EEXIST, retried forever */
> 
> Before commit c246d236b18b ("mm/shmem: never bypass the swap cache for
> SWP_SYNCHRONOUS_IO"), a direct swapin that failed this way freed its
> folio instead of leaving it in the swap cache.
> 
> do_swap_page() already drops a large swap cache folio that does not
> fit for anonymous memory.  Do the same in shmem_swapin_folio() and on
> a -EEXIST, remove a large folio that is not
> anonymous/dirty/under-writeback from the swap cache so that the retry
> swaps in a folio that fits.
> 
> The reproducer below fills a small brd swap device so that a 64K shmem
> folio and the 4K pages of another file land in the same slots, and races
> a read of the first file with a hole punch and a swapout of the second.
> This bug was identified and confirmed with the help of a deterministic
> hypervisor currently under development, but the non-deterministic C
> reproducer can typically trigger it in the 2-4s time range.  With the
> fix, nothing is triggered after 600 seconds.
> 
> Fixes: c246d236b18b ("mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_IO")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
> ---
> Two patches in David Hildenbrand's v2 shmem fixes series are related
> to this one.  "mm/shmem: fix truncate hang in large swap entry" [1]
> makes truncation retry -EEXIST directly, so it can also loop on such a
> folio.  "mm/shmem: preserve allocation errors when swapping in large
> entries" [2] fixes a different -EEXIST loop, where a failed allocation
> is reported as -EEXIST.
> 
> [1] https://lore.kernel.org/all/20261027-fixes_shmem-v2-10-86a00952acb9@kernel.org/
> [2] https://lore.kernel.org/all/20261027-fixes_shmem-v2-11-86a00952acb9@kernel.org/
> 
> Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/shmemloop.c
> ---

Thanks for the fix. It's a really complicated race and I spent some time 
understanding it:) . I tried several different ways to fix it, but your 
patch looks like the simplest one. So,

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

