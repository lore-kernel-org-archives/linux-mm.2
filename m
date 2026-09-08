Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD10EC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52EC06B0093; Tue,  8 Sep 2026 09:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE966B0095; Tue,  8 Sep 2026 09:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3D06B0096; Tue,  8 Sep 2026 09:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1F66B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:13:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 77997406BD
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:13:55 +0000 (UTC)
X-FDA: 85190637630.17.B276788
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id A65B640003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:13:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G6UKhXbc;
	spf=pass (imf07.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788873233;
	b=q8mKHPcswmrmvBeZ7NYggUMITzY74FgtlcuPMzuh4dDdgRozYoI6HNQlh4ruB+hcEtTB3m
	9RfR6aaTx03gXWlHTp5/hM06vQARlGmQ9d7QnSVH8dMU6Htvpj7mm5vhuNHb0marDD0O4+
	zN+4ndFXu8JgpMShTatOuF+3wI6AGzM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G6UKhXbc;
	spf=pass (imf07.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788873233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45/BFWfpuwLvqqEgE/wDbYZ6sfAlzPF75sDMeqn5VJA=;
	b=e1ZDpFHiYWWH6BQ7RzwCddJb9nd5FO/Z/LjLyDOrcMxNAqbcOqz0NLKLlPJVpxtMLDfygA
	3s45txM4Bm4KbBStDstcFSoougM+onVAGahRmcPRmrh49QU3MIY8uTjqH8Tw5WAaAnQ4wA
	iGop2Nv6V113W7lqd+BRXgJLnK/NvZQ=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c263415982eso349513166b.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788873232; x=1789478032; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=45/BFWfpuwLvqqEgE/wDbYZ6sfAlzPF75sDMeqn5VJA=;
        b=G6UKhXbcHC0kppE5es7QqlbzQa0m/cSX2BOdhiN2LDc2neKoYpE60+q7dw+rE3crDh
         8nGTxP+u7OGHlLNhQ42LRH7ZWJZlK+mhXVD6qRMZ+xXEmhzSOKRKn7vDvVXOYduEX98Y
         Vb5mGuAvo9oSroCzdNJUiCUcwSXQMBdZQ1bnYkP7eJObKNePoVES09HY4oEIYKmIolrg
         qsrJJxhgcOVi+FwcS73nFMojHEvdKBDa6S/orn7Sb2ZnIWa9yOSgZXw4Rpf2EsnuXSfn
         uBTEaizacr3EQnfDKiwe5ohcfca9stpKoiu+eleECJZOFszHpob1+gMN6zHHjq5r1LKN
         B2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788873232; x=1789478032;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=45/BFWfpuwLvqqEgE/wDbYZ6sfAlzPF75sDMeqn5VJA=;
        b=lVAqBBoA3zhmqV9twPXrahAtOhemWXbdWhpT8r+giNiJtiRBeRP7Wtfjm0lH64Dq+2
         IEMAdNYePCNvQDriYEuLNl5m+I3Yk9uR1+Ja+2FCOcfESwgmyABDnk21Ovga0h0K+cYV
         vxf9RxeHPekR/pxkIuOPWWXOxJQpse8/9bvXJV6AhVvWk+LiKJO7Sgv8nMMg2oHesPOH
         gazardy4RqUd78nbHRiZO2ODMHY5Lhh5VEHT/4LbPt8KmDvOdGRDC7NT1oKOuhsDsKtQ
         dBGbFFukOBh8ECVSnQxQsHo4Ajo8trvgfkp9752GPXfexY/ytFcZB+0w3VDyV90FnjyW
         Y7nw==
X-Gm-Message-State: AFuF++kWozny7RZhiXzKXmTYHQZK6+RKJbIlyvnBS2lLbqR7bYoT/JzC
	W52F5bT3lkUUyfT1Z55gPy+tkcebLTG0DA6o51YjFnoOwaLolmMNRB8h
X-Gm-Gg: AYBFou3ZmWzZj/PdXzjPR+6DWWsRQ+gdoGqJ7cCSTXUR8TrEiFeDTFt+L8bvkQDLvHW
	yAuz7RY4zEcxSmJSBJKMl5w9S98qw6y/1Ie9wi1ChjKfGuhto62uA+4s2JjJEo5oe5WYIBQlHku
	77yRWnfb/YqcbXre/w42nRh8eQHvDt3N+ufCGTlhnn4cs4DI5AyA6OfMr0ObDmWoKyNJKxIjIxp
	BZPXFitOrZJN9ctVQGA9G7K5hqVdzKX+6YbSGrOsYoGnEFi2tbxYJCceakssnwTS/s/5OMAPLRX
	muSRLil/tYEIJ+9smnVkFHD+sXh4VzguNdU6MajuCZD6tXzyr4Eb37gB+rdzHibqPNP7Q48E2qU
	ouywq88Co6+fDU7U1rKmTyPwFFHnyBfTJverPDePmCbq4oWnTNasiwazAV0fQ3I9BOnQksDHOGH
	Gvhcb0SegTjDg98Tzj2A3NUgnAWFReTA5Pn9jjhQP4TvOMFzexHvI=
X-Received: by 2002:a17:907:9490:b0:c25:c7a9:7b8a with SMTP id a640c23a62f3a-c260c9dfc11mr2001513766b.12.1788873232277;
        Tue, 08 Sep 2026 06:13:52 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:37a9:1e5a::306:1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d6e1c93sm625170866b.63.2026.09.08.06.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:13:52 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Tue, 08 Sep 2026 14:13:34 +0100
Subject: [PATCH RFC v2 01/11] stackdepot: stop preallocating after the
 final pool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-stackdepot-trie-v2-1-1996d5cef732@cloudflare.com>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
In-Reply-To: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A65B640003
X-Rspam-User: 
X-Stat-Signature: pop8xy8gbccg64m8j3jf9q5a31bkwhkx
X-HE-Tag: 1788873233-548880
X-HE-Meta: U2FsdGVkX18L148wYWexdbX/p1gEPLztqKGqme6Swrr5Eg5Bb0/33XUTTNhEp1D/hiD818Jopv0kOwL8dTtOg7fTw2RqiFDomMfNd4KzkLcN/gnw5ViXpCtRdxWxCox+Iki0AyGrSo96kkS0jqjsdNvBVeW0svEav/5rqXlsBbM9VjqRCvZN4S4gUp2jTXpzEOwokV2ceIir5dBMmv5FpjCLbfuo3tkNbhp0g1WLPtKQMoIqzjZesodPdzEGFu0d113a1PKCrWhsSeBAcoLwzQLLGE1eblgsW/nHoPN3Rr1NbSAZ/kydOjfQUuRVbapr2ysxGpaeRRdPZYPUuOaNn7Vp9/Mx7X4xo6eNhFKpeI27ZgON+o0ua4T/4QLH4JupWQeRr51hsSt1vUoOI1ROdhkvfVhACyqnSy10a9QO7aLJEVMgXbdEt4g6xz3PWVMD6SSVrWwt+JaYotuzt64G7LIFhrwJKvRXYEPJco08irK1RTfBlVYvOhRsyWm8DszLk+IK+dUDAKqPOgQcGvLK9J4CK6N34zGuqR2kCVQIXylfhOq7eii1iJVeU6wpF/2j+B4srB1Z6ZekkyAlz0dIB7CcLsr5faJxqajBWIrm8itarc2msahkFRdVCWhTqK0tFbzVclXy90G8fAFUyxqKsFlNcqY+ydu7S7Ivzo8tc/+buIgYAXuK7ZBwbr66nkvBVI1bQIzu0CPVil5OmHAnKU2lto1TbH+RjBmkT18J2lXMtOfhooViTlPprdqnZ4tMCgZnTl5n4ZblgFjLCPnCWA/DvMM6l4xT6yYf1wIVnYgWWXNO5KoE6Sb6yWrh4KphqShS+St1eVzg/SQULYRO8pf108uo7C5IYdoBmbJG0Gd4BH8MXyxkf7s5cVjp1MA4UNG/szjmBfExbAlUcflYyG/iM/65VkMRfYG1uaHSXO8+b3VEF6bCU7khk5tOg7iBhNHv2mVBddyMcHz2H3G
 clJg3DHZ
 DUYGeaWaZFsDRFFdlVjE03DFt6OH3Hco+xRD4v+2FMxVdmUJ/84UIgPFVn77dnNHdMIJOdOp2ynBHBY2+5IECw3nZFLhqyGNLX43cmLpT07ysCfGd6efi6vQoFBWa9uB1DwAxYG9a9HVJA8ylhiTvOOPPfWi6I5NwpV2wsmWazboiOxUtb8XJizMdY4Se+hKyEuXxubaciryov16R0n6tEO/T5LxeIFGKa63UbM2VOH8mmvjn1XmDQRB8QADu0YIYWL3hU6VIQ/lHWCi5sfOxWArKTQu1512Ll8rJP5PGiPORC0zcZxMBhkPiCv66vJzOd2bTBbNt4GfV4QolMeoXnqKRWCdV/ZIEEHXgmnoEmFQJcukeIjkHVLj0eA57d6QEL14aNvjVHm2z6d5nSKWmELYH05/w+uZdysx2lY5aLpR+qiA2/Llx52Hop1SC18pdTBmB6Qxj7dkRGxD0ynqsiApretdqIyXOBIjT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

depot_init_pool() decides whether another pool is needed before it
increments pools_num. When it registers the last allowed pool, pools_num
is still one below stack_max_pools, so the existing comparison clears
new_pool.

With new_pool cleared, stack_depot_save_flags() can allocate another
order-2 pool after a lookup miss. depot_keep_new_pool() retains its pointer
in the global new_pool, so the allocation is not lost. However, pools_num
has already reached stack_max_pools, and depot_init_pool() rejects every
attempt to register the pool. It remains allocated and unusable until
reboot. The non-NULL pointer prevents later saves from allocating more
spare pools.

Account for the pool being registered in the limit check so registering
the final pool installs STACK_DEPOT_POISON and prevents the extra
allocation.

Fixes: 31639fd6cebd ("stackdepot: use variable size records for non-evictable entries")
Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
 lib/stackdepot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index dd2717ff94bf..90c52f2e0d3f 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -323,7 +323,7 @@ static bool depot_init_pool(void **prealloc)
 	 * NULL; do not reset to NULL if we have reached the maximum number of
 	 * pools.
 	 */
-	if (pools_num < stack_max_pools)
+	if (pools_num + 1 < stack_max_pools)
 		WRITE_ONCE(new_pool, NULL);
 	else
 		WRITE_ONCE(new_pool, STACK_DEPOT_POISON);

-- 
Git-155)


