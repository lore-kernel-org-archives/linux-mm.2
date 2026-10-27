Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14419606A326
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 05:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=q9xn8Sti
Received: by kanga.kvack.org (Postfix)
	id 63A4E6B05D1; Tue, 27 Oct 2026 01:44:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EB196B05D3; Tue, 27 Oct 2026 01:44:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501646B05D4; Tue, 27 Oct 2026 01:44:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 072286B05D1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:44:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21D6BA8593
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:44:43 +0000 (UTC)
X-FDA: 85367316846.26.D8EA999
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf09.hostedemail.com (Postfix) with ESMTP id AF169140005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:44:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=q9xn8Sti;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793079881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aSD/uA5GzniB62u1aszYIPG0z9UbK8URKHofuIPTWTk=;
	b=b+W+5DXcAcIy7jr61Y82Mgj7FhLFR4j1J19gXykefq7KorlaSeKOY1FvV6VikHvPVoqqmM
	g22tWWdufszJLCvLtFBKukQtdNn2gdZz9DhGrX0abULUtXaKLBl4n5fDJW7cv5WnulYil0
	IbGve3nhe09DOz4ePEs+ycP9NHXpKXk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=q9xn8Sti;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793079881;
	b=d7EU9xf82DSbI2pywJepCugEBsTaXgQQdEaY+71Z54zR8BNtkuRI/USXpE6L4xthfJA7Qt
	QOkKrEDmUzIx357sLsMl7QMCs9Lv0mLJUrXsse9mBXtQz7jYl8Uc+eOsni2y65cm8g7J2r
	0kasftz5DaJvrp1zwAiYmUFG+G52l7g=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793079876; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=aSD/uA5GzniB62u1aszYIPG0z9UbK8URKHofuIPTWTk=;
	b=q9xn8StirtqES85L9cY356R5Ie23gs8o6hBXwTf7PDcYZK2E4+WInvVKnBFYAYCtEsTogXxY+5ON2h99zWZthBsvkX18K64y62Iy5aMhyD8cmFSXHc4MFepZ5xEoEOU8q3KfxNtvnPfZvM4fht3zfiH1OalMEKBzUZcm4bAnTwM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0XDcpFMl_1793079873;
Received: from 30.74.144.191(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDcpFMl_1793079873 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 13:44:35 +0800
Message-ID: <738ae37e-71f0-4539-be59-e64023a8e237@linux.alibaba.com>
Date: Tue, 27 Oct 2026 13:44:32 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/16] mm/shmem: hold off eviction in shmem_writeout()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Gregory Price
 <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-6-703206d5fa0c@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261026-fixes_shmem-v1-6-703206d5fa0c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AF169140005
X-Stat-Signature: igysrd3sxtehiqjyobu6mk7fyyum6c4s
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793079879-512087
X-HE-Meta: U2FsdGVkX1/kP1SWZ9qf/a45cCv5XRMxr4VopfaN68fVh5mompZtPdlcTtskBXIjT8Ir4+4z7x2v4e2Y4C/ilgNxFjtJnDbdqvJBsmByJ6oUJMRDEfKlJY5KaePE/ThTMPSVzUGNPkwcilXbPXpy7EmXSR75p00BZ8naYkkc3L2xTptyGBFEkZq4vGMuRktWO+37biwaD6iPDvAIW51UgPknfBUBmuORyks2Ow8z4H82H2uUrcpDNyAV2xREMTUyje2yPHsl+ouCtY20kdEUDPKQ5mLMNC0ftGPufxSRen5jkKf5Bwh22hNvWhFOFGORnjK4zCeMRWxWuXkw7m2tYyNJa8qXSXCVVtiIYs4SnSW1fR1XWQQCQcgFieC2a1R2DUj+qZGctnCWrXM0/7p5/omh6ebWSoqzHzs4zy/m+DXnl2rP4Zhor7svG5hKhBiwSlbdvldQA0woMcO7mp543iHOSe1tAK9sv+eVCgjJ2MfCEPLmtZ8oXCbfhB9LAjkHWj/BjW0MvrZM0I9CaMUpyibvzdyJZGIXsGwksT9F5/dEwsfa2UU6x1lAbDk62of5s09QuMZM5Dcs9getC9hN2H0R2bkQl/X5iWAaLTKI8XcHpxB2x+RR4dzBhhrDi8dehbLCUkW8PI27/mtOUiWKsatc+Uzjyj2YsRO2IC56m/iQsS8HIpRSa8O+0NrSC/AKbMGuG6650YE56naajdFU+LvQhTVIZGjd0qRSJSebyWcncLRysk/LdiCStSHpaDkt/LAFJREQEaRX81YXN0sOhQtrnaEsB8QPE0mryB2vwbb8XxsVpfSgTKSr1O3oWtb2gvA6kCR71SnQh+vf5wgJv0NtBFLmGUfmsKZRIPFadglMJepLLXlkBfDxTWN30abBC3qMzirGP6ZsALmxWbHLpFdGsnD7n8Fd/KPsHzPOx5gYHMluCSNgmacadFaEnXTxCQ56jNHeZGZ/kK+0Nza
 e/ppRFjS
 sivxRKFOAbcl8lDQtapkrdNLb7jUNAjY9K9aYk+tgA/VGssEsfxG6oLoZZ/tjIOyM6nRocf6vNtM4nRYMrQyj2Y9xicHLzePdS+8DMpPNFHQRrmJ99aEHd0Yu6/EchpzSBXo7kFOz7bKxfGfBvzUQKsCTX/ZyGh+ee2SYJBhsV8do7+HTlUARNmS+q4Y5M/a/sbrnID2FUMOkfmsV0QibwqIhRcHKjXvenNV2mh4AaTvwBd2aXLgd55AJAidkCgozI6jawK5dJp9dKxisdm7uXWbYs4zLjwD5gCOHPM1vevsOYZwxgMY57OQR5lz935m/z0qBLSgpn6h25GaEzBiFK3QbD5A1vDgLFm77AHYOA+n0i4Wth7gpxMlg3e82nZOZiOBZbKnW52MplV+v3iJnu7QEgsS4qy4wlOfMl/fSxBXqdc4tnEPk5QLHok3wZWYJe0M4PUsaxw/9AfVkG6hMWduNKAMOeKTEBvVSKjDtuNehB4TviMTvZsFcZex2AJQl5Fp+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/26/26 5:40 PM, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Once shmem_writeout() has moved the folio from the page cache to the
> swap cache, the folio lock no longer keeps the inode alive: truncation
> and eviction find a swap entry, free it and do not wait for anybody.
> That did not matter as long as swap_writeout() was the last thing the
> function did.  But since it puts the folio back when swap_writeout()
> returns AOP_WRITEPAGE_ACTIVATE, it uses the mapping and the inode
> afterwards:
> 
>    reclaim                               last close of an unlinked file
>    shmem_writeout()
>      shmem_delete_from_page_cache()
>      swap_writeout()
>        zswap_store() fails               shmem_evict_inode()
>        writeback is disabled               shmem_truncate_range()
>        return AOP_WRITEPAGE_ACTIVATE         shmem_free_swap()
>                                          destroy_inode()
>                                          ... RCU grace period, freed
>      shmem_add_to_page_cache(mapping)
>        xas_lock_irq()            <- use after free
> 
> swap_writeout() behaves that way if zswap is enabled, cannot take the
> folio and the memcg or one of its ancestors has memory.zswap.writeback
> set to 0.
> 
> shmem_unuse() already added infrastructure to deal with that.
> Reuse info->stop_eviction to protect the inode during writeout. Increment
> it before removing the folio from the page cache, and decrement it after
> swap_writeout() and any attempted reinsertion and inode accounting.
> In shmem_evict_inode(), wait for the counter to reach zero even if
> swapoff has already removed the inode from the swap list. Add some helpers
> to make the code easier to digest.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 6344a6d9ce13 ("mm/shmem: writeout free swap if swap_writeout() reactivates")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: code cleanups; improve description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM. Did some shmem swap and truncation tests, and no issues found. So
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

