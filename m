Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821D0606A881
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 06:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=MSaSPZrw
Received: by kanga.kvack.org (Postfix)
	id 8E66D6B05BF; Thu, 12 Nov 2026 01:57:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870B66B05C0; Thu, 12 Nov 2026 01:57:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737D56B05C1; Thu, 12 Nov 2026 01:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 448D76B05BF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:57:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B84EAA0513
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:57:05 +0000 (UTC)
X-FDA: 85425560010.12.465BBCB
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf17.hostedemail.com (Postfix) with ESMTP id F33B440002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:57:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MSaSPZrw;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794466623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JO6FW3tawApcJIwTTcR4zJNDJEYR841HkFnpVbs8+pI=;
	b=mxO0+JROiAAUPiQWogbW2uTGw9fER4MDXsKPT50LaydkYZHmWr3ajV9eqT+3LVB10HqgYY
	wjQ5sDo8TeqkyqG+Tblu7PxHnii+Y70bTU9qn+RRb7e9i+hyc5ySTHRdy4PvimxwKSMlpF
	gXRwboJYVGmYRhK/K3zNbkG3VCCHb8Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794466623;
	b=GpEWQTb5tMqynVPFh/hWOnQRkGRHVEYJeihAcMWZ9Czzqw+Cxgb8VqfyHkPYhsiVMmObba
	W3Lkj69eUEQPJdEO4CK7eHiszSObB2Le16jJpo64zNc7Z7e2bFr9tjYGpGsbhviTKUs9O1
	9ZHdKZxX2JCcNnuzpTuEmkArlBZHNUM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MSaSPZrw;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794466616; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JO6FW3tawApcJIwTTcR4zJNDJEYR841HkFnpVbs8+pI=;
	b=MSaSPZrwSImpTjQeit7lfj3V7ivitCBnkn4/es+8mH5j77EqkfPublLS0WOasMlSPZoSZtVAY98yov4tdN23/CzsvVFv8s+eyQXgStJ9m8xndSdXNLNOKY/ECSMSRzBmNNVeRn8p4gfKrElg//KP+JJhkSwXDG7DMyVdYJE+Dls=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XEbCXrk_1794466612;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEbCXrk_1794466612 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Nov 2026 14:56:54 +0800
Message-ID: <dc7e9478-6f03-4ee9-bf41-ebfc4a8f7edb@linux.alibaba.com>
Date: Thu, 12 Nov 2026 14:56:52 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/huge_memory: prevent losing PG_waiters in
 __split_folio_to_order()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Ye Liu <ye.liu@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261110-fix-split_folio_to_order-race-v4-1-cc5042f33408@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261110-fix-split_folio_to_order-race-v4-1-cc5042f33408@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hoswspkoyiynbyofx8k4w8yc6qyh3azg
X-Rspamd-Queue-Id: F33B440002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794466620-354847
X-HE-Meta: U2FsdGVkX1/pFXg/vR3gMQTVfiWa702AaqM5zrzojMMCG3ThHoxCciZ89/ESxvv3rXxiiyJVq4EVoCsfKuzdxZTfuwGGh7iGJjXHnFKbAP0L/TmCaKG46cILx2HtIdTmQK6rc9OQPw7tTPyqaY9JK2nItn/USedwuU02IrISSwd6xoWpoKx8/I0bsiPxHsScVm4wWmbo17uU+iKfge+RHi3K4K0QodIXl8UF8z4/shv5o2wqara2Ydbvs1HlLMJAT5KcOkUjK7p0CvvtYqiAXOaZ50A4jvu1oigWv1ViaA0yk5xTrFjf5mIVMsvmTZFVzyhVDXIlwRQ2uTKB6+8fMbWpk+cRUdERo6S4DaE304y1G/lNEyMrkiT4zVmBjSWFPfUlYUWtY78bGdSOAK/IAqI4IhKn3wzBVYg3KZgWIv4VLc+TgEdnRGpRTIUENEFMkHJJGSDRHm650Z2AqktMBqBiakhIHGbZ2+HCrmRA2Fz+FmxrqzOCEruIco5chGIo725i5SEu7As/CYqSWKW+JFJtWX4QO0VgDvV0f+5ICY6cBWTGlJ1PWtj41yPSWX1NQuU9+cjM7425t/WdVpZUeaimv39r3VihriT6Xwsno2cfyr2ZMD0pcPmIIC2xm9/oxMx9fHBqaO2tyiGjB8Yi4wEylD0fDQK/eXVW18dS/1+xhH3YyoZXJuCqhcBNzQkG2nPV8PyeQdwHNxcUXOnelkNyct8QZqRGmxAJZTAF6bTIv9VUVUxPu9KcHfHrqn6I9lJhauhBEAQ5/isWa3vFSMybfrlgSTy7xOhZS5IvtzweuP43pFO1JUk1c8opGog2FSwixONX47yn5UvSHIdrxa6Jnrid8dtYsdnkgJzFBOiDVLMAh1EiXnFNJtRrlFZv4p4ygoEVob97mVy6XWvgIT+nf959tCgpPcBcAzYJn/67+CHgMZYG9VsJWLID9kfDEuW1YJ60hTB0xZmnjny
 1bmICYtf
 Gw8Qfi9lO0NSTV00AkU49H3eymqjggbLqmZKf1B1YawA/t6AuOEQ7XevW+WzDnpvVtKI8J7sENApu3U5sQLbrRHQw2piCHfW/INWGkOBTJ9IL6pqhelq4k1BXKLr32n1DAR+BcoSqS/RpuoFpn6PB2fFxuGKAyVndDhgo6K2Z6HojH9cCaqVGCxnfX8hoKLztF3XW/2Fu04TN0A8eSgM+4MLTDHOQW8Zo9IvV5RoeBqFJgjS7Sx1xNWMyxEI7rYAz4fHc2siQ9G9vfFHoXvYjDYIay3Q9Uwrolk6nPmj/pOwpO2HUdyYMDhyg2Tr3Vf0NpcDg871+hxhBY7lgkcE33HB+wivdNxo2ckb8tAsn/aBbzzLP1Prz4uA6wvKfHFS9kB4gffksIL+Uzr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/11/26 11:19 AM, Zi Yan wrote:
> __split_folio_to_order() calls prep_compound_page() on each new head page
> to create a compound page after clear_compound_head(). prep_compound_page()
> uses non atomic __SetPageHead(). It is mostly OK, since the folio is locked
> and frozen and no one else is supposed to modify the folio's flags.
> 
> However, code calling migration_entry_wait() can reach the folio by PFN,
> then access its flags. It is because softleaf_entry_wait_on_locked() used
> by migration_entry_wait() sets PG_waiters concurrently without taking a
> reference and the frozen refcount during split cannot block it. Meanwhile,
> __SetPageHead() does a plain read and write, so PG_waiters atomically set
> by softleaf_entry_wait_on_locked() will be lost if the set happens after
> __SetPageHead()'s read and before its write.
> 
> One example code interleaving:
> 
> CPU0: __split_folio_to_order(new_order>0)  CPU1: do_swap_page()
> 
> 1. clear_compound_head(new_head)
>     new_head->compound_info = 0
>     (page_folio(new_head) == new_head now)
> 
>                                             2. migration_entry_wait()
>                                               softleaf_to_folio(entry)
>                                               page_folio() -> new_head
>                                               (not the old head any more)
> 
> 3. prep_compound_page(new_head, new_order)
>       __SetPageHead(new_head)
>         tmp = new_head->flags.f  <-- load; PG_waiters == 0 in tmp
> 
>                                             4. folio_set_waiters(new_head)
>                                               set_bit(PG_waiters, &flags.f)
>                                               enqueue on waitqueue, sleep
> 
> 5.     new_head->flags.f = tmp | (1UL << PG_head)
>         <-- store; overwrites step 4, PG_waiters == 0 again
> 
> Later, folio_unlock(new_folio) sees no PG_waiters, skips folio_wake_bit(),
> and CPU1 can remain blocked indefinitely.
> 
> Fix it by setting PG_head along with other flags in new_folio->flags before
> smp_wmb() and clear_compound_head(). The remaining compound page metadata
> is set after clear_compound_head(). In that way, after
> clear_compound_head() makes new_folio visible, nothing overwrites the
> PG_waiters from softleaf_entry_wait_on_locked() by modifying
> new_folio->flags non-atomically.
> 
> While at it, use data_race() to suppress the KCSAN issue reported by Ye
> Liu's patch (the second Closes) on reading folio->flags in
> __split_folio_to_order().
> 
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Reported-by: David Hildenbrand <david@kernel.org>
> Closes: https://lore.kernel.org/all/DMHE8BEEER1H.2BIY52NXATPIA@nvidia.com/
> Reported-by: Ye Liu <ye.liu@linux.dev>
> Closes: https://lore.kernel.org/all/20261029-data_race_huge_mem-v1-1-112e331291c1@linux.dev/
> Fixes: c010d47f107f6 ("mm: thp: split huge page to any lower order pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

