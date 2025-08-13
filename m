Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096BBCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 11:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95E7490005D; Wed, 13 Aug 2025 07:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E86C900044; Wed, 13 Aug 2025 07:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761E890005D; Wed, 13 Aug 2025 07:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 52662900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:17:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5001F137961
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:17:42 +0000 (UTC)
X-FDA: 83771483964.30.E1CA1E1
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 48D7D1C000B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:17:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=THlrefF+;
	spf=pass (imf20.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755083860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZlWkB4mdDNZC/cn5UpFz36ZU1sYh8iUkH7z054OQZUg=;
	b=ShWjrLxzj8jq1eAdN4HtPTyp5TOpPdOzvxhNkPayYtiOfC/aIwlG6XNmdcJbhBaaLXs/W/
	c/q87npJmv8vN9VWfV51dX5n5p+ZxwjW51kZHZpTbVRM/M1JNR01u8QqHlnQYbH7WvDHXo
	mJ1/OTsXdJhEo2HOr7mVcaMElS5UYoQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=THlrefF+;
	spf=pass (imf20.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755083860; a=rsa-sha256;
	cv=none;
	b=4J5i7mxpbjaE6xvyNvGkfbmoJIz+TSIUOeIp94fcsP5f1o+GMsmQhhnWjoDkf+Eg+mj8Cl
	3YczXGlBL7r4hM0L3sKDUoZj4jALf2lkPYwzAPUQVKjtlQ/FLQNMsuiGJqkwm8TnniuM3F
	MeG/Rbc2ogOlQ+SnRUBs/HuP+L9CxY8=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b78d13bf10so6591504f8f.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755083859; x=1755688659; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZlWkB4mdDNZC/cn5UpFz36ZU1sYh8iUkH7z054OQZUg=;
        b=THlrefF+2PWg5PIc7zVxDPBI5ToLTIRR5yGoQqZ55sOfeChbnLUglYSspGCWWkAwFI
         to6KMvL8j4LZLxgFBfTH7lgAQPkRs6l6AAD3G+U4FlwuNDgRnpUeoRqfuvqwAO0hHdU6
         ZUEZC/wO8+b2YKlfjRDhvR39GVc66qzrckW3ZJ+OeiuzZocDDVMcp9IksiN414KY4vLt
         MF/6IMVsD1Z5bwNAaK80B6Dd4QjTFhwiyOwhC2cwTxNINIdHVCuWutfaOoQvuDJwS0/A
         pVsF6pWvLrG3uZ8TBPoAw6r9F02k9Hutpu+vlNBZJ/bwbta69Swq9+Cmr03LGFytSi+q
         3p8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755083859; x=1755688659;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZlWkB4mdDNZC/cn5UpFz36ZU1sYh8iUkH7z054OQZUg=;
        b=iP6lNoXG0dUswXhk+rmSbiNw0mTa4LyKhrNALCpbnigHmnqdH4yjwfNJGdrpTvO5cr
         QGVV5SlQEsOegq6miwdwkhGxYqaRrKSFEuLLHxpydbU4SeJPfqm7KUgZ0T94EwZVFwKi
         4/PNycOaqmKR6WNSB7+fnqh1Z5dIoGHtVVIBRljCJ8qFxclVEbO4N3FJv6ACwqdU7xJd
         SqXstpfEjhAUsGKSVgxEOlFmelwulE1egM40BjVS8eemRRvTp9G1oM1ldsa6BirmIiuN
         YtUIsmjBJ4YMxMYss09Gn9qnRE+ZHiP8r6w+n0R/98SEQ07jqXnPORRVHKTCIyHR0CE4
         5hMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcArr0VKozPqgpnH2jDmyGgnun7baBnRQxC1olrEyx0cJ40hqpU74+z26HeWDdWAmU7msFS2FXvg==@kvack.org
X-Gm-Message-State: AOJu0Yzduyxs4z5GfOP+JJXI3CSlgPvDGYY1lswLj+ejDWNYcPRnPzQ3
	zFQ2dGIZvl2CeFV7AlzDkQ2N2kW7Lf4mLiPM/Ej5Zne9SEwWGnFZKlVS
X-Gm-Gg: ASbGnct5N4WutrFOaUwRJOCcf1ZSNTuq1qeUkGKTtol8IH5cCppS+InAdgZoh2fPJa2
	oDRV2PIufMd7YVh6vOCtcIk3djhDa9181P9Gg822+GefjG2aRXCQy97r5HmlqSmPraybPHblwOm
	Cj96Dgd2hXGHJzxDOB2QHbQgoe6JPnQxm0UAo/Rx22WQOYmUlxGtNgLJH/F72uXUoY24+QT28M7
	HHJV4qAkGJBFWQbMZ5sjzUquDTRqjezSQ6g/Rj0dqUs95DvuDgAFrblKICDOUQxx/ha/OPMnqgl
	GiK8yBzq+uOVSjZG/sMjma6BvSoxf5JzbUn/zYFZDRYRfqTBqnd+rbtuRGnSG90/JFcDbIPhuI6
	QhuKUq+tQALiBCoB36aB8Di5RpdgYIGTIz7E=
X-Google-Smtp-Source: AGHT+IHIJckFdgjZWss16Tz9qU5LS3EozEf9NXM4Mc+MLVLT3sIzNz2MSxyepzxFt0CjL8IQUdHUsg==
X-Received: by 2002:a05:6000:178e:b0:3a4:e68e:d33c with SMTP id ffacd0b85a97d-3b917ec3ecbmr2043703f8f.47.1755083858415;
        Wed, 13 Aug 2025 04:17:38 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:aa85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b90d147485sm9666355f8f.19.2025.08.13.04.17.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 04:17:37 -0700 (PDT)
Message-ID: <6bbf6ca2-0c46-43b7-82d8-b990f01ae5dd@gmail.com>
Date: Wed, 13 Aug 2025 12:18:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH linux-next v3] mm, page_pool: introduce a new page type
 for page pool in page type
To: Byungchul Park <byungchul@sk.com>, akpm@linux-foundation.org,
 kuba@kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
 brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, bpf@vger.kernel.org,
 linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, linux-mm@kvack.org,
 netdev@vger.kernel.org
References: <20250729110210.48313-1-byungchul@sk.com>
 <20250813060901.GA9086@system.software.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250813060901.GA9086@system.software.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 48D7D1C000B
X-Rspamd-Server: rspam06
X-Stat-Signature: 5nsn4aqucpp4rjxac5hccaith693e384
X-HE-Tag: 1755083860-263782
X-HE-Meta: U2FsdGVkX18qW5sitTGsmmCmJcTvZlvvq1nlr7YnSjkcy+Iv4LN0YZWU4Ri41iUg2VFRdXrIquIlC3sipvRKv2x61TDZao7MB/HEqGlZnnwCiotzlioCJErBcETxWJ9g43uZk2CULZ8gc/l5PidPzweyzNa6YFzAzISerIIkb/R1kKqwjlAzDl2vtgEQwqRMd0tSryjpWSlEH5bMCq8yeIcsXO+C6ZvFUZjTkG5VjV89knjHZRxtWlA88/Lp8HEWtyuEtnJDZ2g9QbHRi2H1Y+45dFBTXYP2rXAbuGH6CdfhelyKPw97IAookp9J/jXRvWRC5LRhNlgW4iTeOEI0CU37s803q9XfoKf1HRwq12Sz/qkyZq7BLFfxtU3SC3mto3D8rx3tVVX+B0Y4DvqyPHkIiT3y3iu/Ug8v/OCuDN0NbfKFUr8qMOFkMjq7qyiCyYvxmvKnQYbrpuMenr+YsliMEUmrNKGWY2VJ6EQ2OFXijLPjbzErfNI1JCusrVgZ2ycfPmp2j8proEAQVy6RfwZ4Ejm4hCNuHg9U/j92LQU76cHNrgOlqYdf6EdLJnA5qEMomY/oxX72LR/Sr/GfyploTqr48a/9y7aKFg7yAFfCBvZzrnHvrBi6Qlr6PZSiJ6GFMO1XrPcN14aMKcHOKVFhIiBZxxr7gXwR4S3mqrJ5/Oe3AkD+XOAanpYlac9dssovwBLBd/DZZ7DD8YyUA06gVezKOJhAEDlxC/r76765kk+aFTU+SQcseej4Q3A/bdSd5Kx1E6mE4Zs718qfLEvDnlJCU4phu6RRiyVWa9XpdkdJfc4ZsViXfRmS6GD9VQlo/gbF0GoA/quShnfZGWMm4406hIDNIxWzCOIQEeIEaUMbuvMeVVlFitsehb2xuZljQdA6vs5/9F7KC9wOIQFgmqLxxPkoeHeY3I+dnzXXmjUketoMuzpvH+zYkRq1Tw1Q+9EOl6Vvwv48fO4
 IfIv3cQG
 xQdxEuemJvpY1/g3u4oEhnEli9u58Etk2PvRh8jrbRdN9/xSJ7mZi/jBL/N617PlOhLSNc6ee99inE8MXguE9dipyzf/SoDjPNS7UAN/stiQ6EVTxLGQCjszbzUAzMA43FIKJ1+hHsT6eDu2eSthgkgZugVcedvbr/p8PvAwfkNJyOZF+UwgMRD5GqzgTTaM0nd17DQPdT8qyr9S2rRaU9ribS5IRaz2YfY/ONIxBvgcepjbA1DFuMQfTZ7U7wJsXjCKoC3+3bHUYp+p7l1I/VQBbBYTlu1CMcqwy9Cd27VU69g7yFy/vLIOukOEi2720iIpx7+1r9J4R7NIRpKB3BJMBUm6xd0SgX1mPLbqDkYtks/eeSoc8yNG95YXdllofLVj+bMxooW3JMdSvX+TjmQY5hiBZhK88ouseCcIe/q/3hAmD4FZUxZ+7G2tqoUdEyTIsNBPnzFXE+TRd+GZy1EoCdkFPP1OfMRg3CFcm8bpimZmyPgs2usONFpK/X8op/ZrjKnFD+Zvegp1cHswaWou5xTcPo+ALgg3qwzrNzEs3hsMDhH/VsolYQaLq6U5N9iLTcNa1vJhAMarpS/RrsTZv1memXS6rMNS1wmuEmdUxCxtklFF5N8ycvDdzZ0UGEh5SNvVSd0pGiiJbPV5zkS1Oa2eH2fLGaj9gzN3a2wbyFx911UpHQMGNzlGxbULQwQwPfhYIoOH5A0LxnNBC/269k4FfseN4YOnb6dGRT4i5rgE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/25 07:09, Byungchul Park wrote:
> On Tue, Jul 29, 2025 at 08:02:10PM +0900, Byungchul Park wrote:
...>> For net_iov, use ->pp to identify if it's pp, with making sure that ->pp
>> is NULL for non-pp net_iov.
>>
>> This work was inspired by the following link:
>>
>> [1] https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
>>
>> While at it, move the sanity check for page pool to on free.
> 
> Hi, Andrew and Jakub
> 
> I will spin the next one with some modified, once the following patch,
> [1], gets merged.
> 
>     [1] https://lore.kernel.org/all/a8643abedd208138d3d550db71631d5a2e4168d1.1754929026.git.asml.silence@gmail.com/
> 
> This is about both mm and network.  I have no idea which tree should I
> aim at between mm tree and network tree?  I prefer the network tree tho.
> 
> However, it's totally fine regardless of what it would be.  Suggestion?

It should go to net, there will be enough of conflicts otherwise.
mm maintainers, do you like it as a shared branch or can it just
go through the net tree?


It'd also be better to split mm and net changes into a separate
patches. A patch I had before, it might need a rebase though.

From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 17 Jul 2025 11:46:21 +0100
Subject: [PATCH] mm: introduce a page type for page pool

Page pool currently uses ->pp_magic aliased with lru.next to check
whether a page belongs to it. Add a new page type, a later patch will
convert page pool to use it.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
  include/linux/mm.h         | 20 --------------------
  include/linux/page-flags.h |  6 ++++++
  mm/page_alloc.c            |  7 +++----
  3 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0d4ee569aa6b..21db02e92b33 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4205,26 +4205,6 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
  #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
  				  PP_DMA_INDEX_SHIFT)
  
-/* Mask used for checking in page_pool_page_is_pp() below. page->pp_magic is
- * OR'ed with PP_SIGNATURE after the allocation in order to preserve bit 0 for
- * the head page of compound page and bit 1 for pfmemalloc page, as well as the
- * bits used for the DMA index. page_is_pfmemalloc() is checked in
- * __page_pool_put_page() to avoid recycling the pfmemalloc page.
- */
-#define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
-
-#ifdef CONFIG_PAGE_POOL
-static inline bool page_pool_page_is_pp(const struct page *page)
-{
-	return (page->pp_magic & PP_MAGIC_MASK) == PP_SIGNATURE;
-}
-#else
-static inline bool page_pool_page_is_pp(const struct page *page)
-{
-	return false;
-}
-#endif
-
  #define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
  #define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
  #define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 8d3fa3a91ce4..0afdf2ee3fbd 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -933,6 +933,7 @@ enum pagetype {
  	PGTY_zsmalloc		= 0xf6,
  	PGTY_unaccepted		= 0xf7,
  	PGTY_large_kmalloc	= 0xf8,
+	PGTY_net_pp		= 0xf9,
  
  	PGTY_mapcount_underflow = 0xff
  };
@@ -1077,6 +1078,11 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
  PAGE_TYPE_OPS(Unaccepted, unaccepted, unaccepted)
  FOLIO_TYPE_OPS(large_kmalloc, large_kmalloc)
  
+/*
+ * Marks pages allocated by page_pool. See (see net/core/page_pool.c)
+ */
+PAGE_TYPE_OPS(Net_pp, net_pp, net_pp)
+
  /**
   * PageHuge - Determine if the page belongs to hugetlbfs
   * @page: The page to test.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d1d037f97c5f..67dfd6d8a124 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1042,7 +1042,6 @@ static inline bool page_expected_state(struct page *page,
  #ifdef CONFIG_MEMCG
  			page->memcg_data |
  #endif
-			page_pool_page_is_pp(page) |
  			(page->flags & check_flags)))
  		return false;
  
@@ -1069,8 +1068,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
  	if (unlikely(page->memcg_data))
  		bad_reason = "page still charged to cgroup";
  #endif
-	if (unlikely(page_pool_page_is_pp(page)))
-		bad_reason = "page_pool leak";
  	return bad_reason;
  }
  
@@ -1379,9 +1376,11 @@ __always_inline bool free_pages_prepare(struct page *page,
  		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
  		folio->mapping = NULL;
  	}
-	if (unlikely(page_has_type(page)))
+	if (unlikely(page_has_type(page))) {
+		WARN_ON_ONCE(PageNet_pp(page));
  		/* Reset the page_type (which overlays _mapcount) */
  		page->page_type = UINT_MAX;
+	}
  
  	if (is_check_pages_enabled()) {
  		if (free_page_is_bad(page))

-- 
Pavel Begunkov


