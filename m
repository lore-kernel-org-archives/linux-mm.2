Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7C6C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 18:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EB7B6B008A; Thu, 31 Jul 2025 14:14:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C48C6B008C; Thu, 31 Jul 2025 14:14:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9D46B0092; Thu, 31 Jul 2025 14:14:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4DE2D6B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:14:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2B05114A17
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:14:52 +0000 (UTC)
X-FDA: 83725360824.10.A3966E7
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 05F6840012
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:14:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PdCGLRYf;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of ydfan@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=ydfan@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753985691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZIqzai1S5uHb7ftn+Ac80FEw0yXaIMJIHXMVatWhvgs=;
	b=leljxya1Sg4R4CvLFZCO2ogR55L5BaZsfWbiIiirnsmFkZ1OhXmneC5IFxyiHHJzcTuIaJ
	BYzxrJU5038wHW5NXpKyAUApY2+pUX8UO3Nzy0L1vpHC8QstDTo0+PSvZ+of8fO2aJ7FCc
	Wg2GabGWNWqj7d8x2QK3qtyV+5wo1sw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753985691; a=rsa-sha256;
	cv=none;
	b=B9iC/8UCuJn+MkvIcKLvMpTfL4SYhoIDPIUElSbV41RFB2R6KTrDnolCIMfonALVkpdGJy
	WhvGq0uqVpQuqO2koXcEqQknQlJXn31onZKtS5XC5QGW6cd5p4KDUD8/k/LmJGP9sE3vI9
	WdvNM4Wnb7jcWFI2rOeGaUrlI+LjoFc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PdCGLRYf;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of ydfan@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=ydfan@suse.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3b79bdc9a7dso6069f8f.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1753985689; x=1754590489; darn=kvack.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZIqzai1S5uHb7ftn+Ac80FEw0yXaIMJIHXMVatWhvgs=;
        b=PdCGLRYf9aE7CVD6RW/zuJLU9KR4/tdtEiHCKGn5lGZ7CjDUgnuFzxI4BfdQ4AbahK
         phFjmdYyBx1ochvWq2NvXh+urQYJjFCNDnILmVDFuiP2a9sL3CHLwuCPFxsjYMttADWy
         kUiVFL0gUx5Q48+ATyDp5Nz4sB7IR50RUy05WogP2QKL2sCn7KCX+6RmauUOcrliroxo
         zTsedkavb5uyaq1D6VLy2YEQX53BkaeZ16pCRRpLXzo56Xjotbf3+65bMIRAbedyjY0T
         2hfkt3fAk736kjJvINj4Sh3cZXxVtIDu+QHQeB0bgXXVVV1U/iK5ZDO4T+4aDSBmMZnr
         eTCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753985689; x=1754590489;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZIqzai1S5uHb7ftn+Ac80FEw0yXaIMJIHXMVatWhvgs=;
        b=O65qN7phKqGFkE98XRzl+3M64kOWYs6QgNJPNppqUrRiKhBEuSvqNZzNESCuvIqBik
         serBzzzdJfvmgrwOMFZRhJxP8j/B2dGYgrhXTF3BixUmefR3pn/LNXY52mgqI3jX8YYs
         db3SDYD2oA6G1GHbMdbwCVoqLH2yD5qgZCMFNVAFUTvZjMWhrjaA1jG8PYbo9W/HDsMx
         2BrpM7pdlkr8pK/osLLP0Mjo4jGTkynFnFMw4d+hsN4sAZMcVdCyp1OUxjOuNbT3oCcx
         volr+r8eZYyq7g2dUFr0vWEzgkwoX4Zr6n7KELHN4hCya8cunnPwPHsIhu5iCE9BOBNz
         t4HQ==
X-Gm-Message-State: AOJu0YyyiibgVXfp8DmKM5wzpYj9s970k+nA0co5dtFZLtnwE5JBxi3X
	PdeIlU0FtsWeZko40uQCnR9NI38+lDaEN4UzRdzrMTrV5ULevf/t1mN8hp4tDdwAbbg=
X-Gm-Gg: ASbGncu6sl0u9SLBfnAh82EtA6yEVjKSj7rD69dw9RvFUSPqIH5yns1ISRqpH5Lg7SM
	b6Rc64mQQBWDcMdQqjXEPMcOI1ftSHLBPAqVqriC75V1tgyaxZcPDLchtAwZXb6pnDtf2VbWI6H
	rYw4aQeMh0TWGfJvkadIfjJsS/hl4lGD+2Fi4/bTw39F46XtH0kcTi3C/abvQ3t/tb/pjxfa3OC
	aLTFRExkfoGkaxs5qtNq4xHKSoFAUkYmS85f+B9ccs+5TlsqFo26oDbIxjKQn28aS80qNCWbiqA
	33cgb5LbNnWiBI51uq1S1EruBkITOYgGbLxN0UwoxA9bY9LSh7zvG78cK0a+D6wJlXktT29Pth2
	QmqN1R9OIeM3Y60svGWw=
X-Google-Smtp-Source: AGHT+IFeofDn7ogmwOU3MtfiWHhybEkCJ88/7m6CVUsHaJvOILW/zxTP69inhurY03UjuZHfi/YP0Q==
X-Received: by 2002:a05:6000:25c8:b0:3b7:9c35:bb7 with SMTP id ffacd0b85a97d-3b79c351143mr2995476f8f.46.1753985689387;
        Thu, 31 Jul 2025 11:14:49 -0700 (PDT)
Received: from [10.211.55.30] ([103.172.41.202])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccfe8f90sm2192921b3a.127.2025.07.31.11.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 11:14:48 -0700 (PDT)
Message-ID: <e01f00f3-58d9-4ca7-af54-bfa42fec9527@suse.com>
Date: Fri, 1 Aug 2025 02:14:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
From: Yadan Fan <ydfan@suse.com>
Subject: [PATCH mm-stable] mm: mempool: fix crash in mempool_free() for
 zero-minimum pools
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 05F6840012
X-Stat-Signature: r7wrzg9nuisx1fnp3fjru4cgfybywbo4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753985690-556726
X-HE-Meta: U2FsdGVkX1/Pm4MGcGyZl3GqlPIhrFOKR2fE3QptVOYvmp9G+wxgOErAAWm6HKIhFH7hj9Pjnp/yuinJ0KmsnqJegHpomBLsZ9ikH4xCPzPbu01LaitKaJ6I2lBVuwOP2/naP4Ayt9OJZk1lLaoBNe2anVl750ZzrT7qY0Pgtk2r2qHr9l5Ns71DKdzXYLHn1zIHBpM7nktgSxVFnht8cgegeRLuDi2TQtzM+G5UocS9xHsxPXoF8NwINGluOXPNqz3GjcIY8YBzJQGtYEG2/7Z5vdaBvXiBZ7lxDQAC7BOv0wjENDyPZXQr+7pZNZQoibnp0QvMH3n13u7laCx8+e4JV7aZzlRkGCkHy2bPzvtm3FpFin73s5i30VMaOE4knWoijCk5BmRzHrL12VL+vBt4iU8GUcJ4EFlrrR8Hg6czX7++qQ+Vhafy57R3O2kyIh1hSJc4tKrTZQIS/PIXXevrKf/20dy6cEOtGRKdgP+JY4r18uOkbywDmieyg3OYrRt+PFvqwoDCIcbcO7jAk9oxT+AdsDLR3FgCFGFTIZ/FQxiMDc83mI1lxxAHohn3gIL2BLrEWRUd4kd3/UqjjRcoJHBnAumthgq3imLxCwARu/lM4ZfRjDR2kK0N63oowQxbmUp8xHhX25stUEthfeXl0jETJQy/ZPU9WEC4xco1It5eXekoKfkw/jSP2+eb2DT0j+Rs8c1jCFKbGi8PcaCozEi06MvNK5D0LKLpWrrDMK4koO053UCKuVSyfpDhxBtgSeo+kX9cgq2i73qbvVYb+bpY1Kv0/N4ppIeNK8Ch5VVty8Euh/Uha5Sstq3ieh4iHCaIzD4z+PTHGu4USxj8yf0CUZ0GggwY5wOadk1RCq7Q8xOyQPgme9F4t4rLTe4i33jDs9gRYYlbhQHwW9DcE+PtK3moOEgaAC6t85WzeTpgDY4A6DmZrDa6pK3C11XwioMa+PnKpZu9I5D
 pcGwG/bR
 3D3qO7xYY9NSIxLF1Vs053jEq9FkYdP6HHeAHVKOhIuDO7Pntbj2HD6aODZ5sA+LGyFKxzSZ7+GtdIudq6CPWMY49cyjqax2mRzvzemdJ9+Ko4VbSMM1jqP0QkFxmkORxAi3WPCIZiC6kvQZEn+Gc2K1/RoRAAvrSkGTtTTSBrltPoL8AryGmNzTsqCkOHkQDhPhYCeMVcbAOYMrd2FS0IPOibJFMKYH2QtT47aeAo+MkQtiJxClJIPLquqkK5S2OHk4y8ahHORvcq5KUlv6sZekBXg7jdS3XsdqtjUBzhvPfM34e1eYQ1wRRejaRd0evxayPFraZBKAgNhLhjsYvlGRg4H5R8IWIx4sZ+WFho85qTxcWj1HS94kCe+aS1Z3Dv/k79qP4BMM+pG8lPVLK/3EFHA39cwqsLvwo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mempool wake-up fix introduced in commit a5867a218d7c ("mm: mempool:
fix wake-up edge case bug for zero-minimum pools") inlined the
add_element() logic in mempool_free() to return the element to the
zero-minimum pool:

pool->elements[pool->curr_nr++] = element;

This causes crash, because mempool_init_node() does not initialize with
real allocation for zero-minimum pool, it only returns ZERO_SIZE_PTR to
the elements array which is unable to be dereferenced, and the
pre-allocation of this array never happened since the while test:

while (pool->curr_nr < pool->min_nr)

can never be satisfied as min_nr is zero, so the pool does not actually
reserve any buffer, the only way so far is to call alloc_fn() to get
buffer from SLUB, but if the memory is under high pressure the alloc_fn()
could never get any buffer, the waiting thread would be in an indefinite
loop of wake-sleep in a period until there is free memory to get.

This patch changes mempool_init_node() to allocate 1 element for the
elements array of zero-minimum pool, so that the pool will have reserved
buffer to use.  This will fix the crash issue and let the waiting thread
can get the reserved element when alloc_fn() failed to get buffer under
high memory pressure.

Also modified add_element() to support zero-minimum pool with
simplifying codes of zero-minimum handling in mempool_free().

Fixes: a5867a218d7c ("mm: mempool: fix wake-up edge case bug for zero-minimum pools")

Signed-off-by: Yadan Fan <ydfan@suse.com>
---
 mm/mempool.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 204a216b6418..1c38e873e546 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -136,7 +136,7 @@ static void kasan_unpoison_element(mempool_t *pool, void *element)
 
 static __always_inline void add_element(mempool_t *pool, void *element)
 {
-	BUG_ON(pool->curr_nr >= pool->min_nr);
+	BUG_ON(pool->min_nr != 0 && pool->curr_nr >= pool->min_nr);
 	poison_element(pool, element);
 	if (kasan_poison_element(pool, element))
 		pool->elements[pool->curr_nr++] = element;
@@ -202,16 +202,20 @@ int mempool_init_node(mempool_t *pool, int min_nr, mempool_alloc_t *alloc_fn,
 	pool->alloc	= alloc_fn;
 	pool->free	= free_fn;
 	init_waitqueue_head(&pool->wait);
-
-	pool->elements = kmalloc_array_node(min_nr, sizeof(void *),
+	/*
+	 * max() used here to ensure storage for at least 1 element to support
+	 * zero minimum pool
+	 */
+	pool->elements = kmalloc_array_node(max(1, min_nr), sizeof(void *),
 					    gfp_mask, node_id);
 	if (!pool->elements)
 		return -ENOMEM;
 
 	/*
-	 * First pre-allocate the guaranteed number of buffers.
+	 * First pre-allocate the guaranteed number of buffers,
+	 * also pre-allocate 1 element for zero minimum pool.
 	 */
-	while (pool->curr_nr < pool->min_nr) {
+	while (pool->curr_nr < max(1, pool->min_nr)) {
 		void *element;
 
 		element = pool->alloc(gfp_mask, pool->pool_data);
@@ -555,20 +559,12 @@ void mempool_free(void *element, mempool_t *pool)
 	 * wake-up path of previous test. This explicit check ensures the
 	 * allocation of element when both min_nr and curr_nr are 0, and
 	 * any active waiters are properly awakened.
-	 *
-	 * Inline the same logic as previous test, add_element() cannot be
-	 * directly used here since it has BUG_ON to deny if min_nr equals
-	 * curr_nr, so here picked rest of add_element() to use without
-	 * BUG_ON check.
 	 */
 	if (unlikely(pool->min_nr == 0 &&
 		     READ_ONCE(pool->curr_nr) == 0)) {
 		spin_lock_irqsave(&pool->lock, flags);
 		if (likely(pool->curr_nr == 0)) {
-			/* Inline the logic of add_element() */
-			poison_element(pool, element);
-			if (kasan_poison_element(pool, element))
-				pool->elements[pool->curr_nr++] = element;
+			add_element(pool, element);
 			spin_unlock_irqrestore(&pool->lock, flags);
 			if (wq_has_sleeper(&pool->wait))
 				wake_up(&pool->wait);
-- 
2.48.1

