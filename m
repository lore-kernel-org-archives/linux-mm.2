Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03DECC44500
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 18:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2EC6B00A2; Sun,  5 Jul 2026 14:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9066F6B00A3; Sun,  5 Jul 2026 14:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70AF96B00A4; Sun,  5 Jul 2026 14:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1286B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:07:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B054A140196
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:07:20 +0000 (UTC)
X-FDA: 84955505040.21.1CBEBD8
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0F709A000C
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:07:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="gkMyaG/+";
	spf=pass (imf15.hostedemail.com: domain of 3VZ1KaggKCBQ32uA2Iu708805y.w86527EH-664Fuw4.8B0@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3VZ1KaggKCBQ32uA2Iu708805y.w86527EH-664Fuw4.8B0@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783274839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uixY+zQC2Q4KaJmkwsvpQ8gw1gGr0gBjP0iygMjhgoQ=;
	b=R3k+U7dwgQpaaAA6Gd4NIE0zs3G+gRGa37YD9zj+iidLskBi2DDHcnlYvwKH+Ob5e/8HHO
	gOioR6ES4kFJ+GeVcyD53HfGzSkZozwbzHVWeEXuIHRWRKUG4RNC9QCL+LLG3RHXZvaghl
	ECdWFwg51PPwLhJ5bNkxCBn45H/N0Rc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783274839;
	b=7breWaIxsbdyfcivjlrKuexR0kWU57z9lCCeJqEDs4IZ69Pezr7SXooNRCC/rZ4k8oBT+y
	+c4tanL68WLlYz28Ud32pV6tg3snGVcd8JpY91QnBE/mpC90/BaSX5RQvj2o+0k5LvvkxY
	2j6VlwoeORzIaD+Wr0bjveiErmWJtqg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="gkMyaG/+";
	spf=pass (imf15.hostedemail.com: domain of 3VZ1KaggKCBQ32uA2Iu708805y.w86527EH-664Fuw4.8B0@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3VZ1KaggKCBQ32uA2Iu708805y.w86527EH-664Fuw4.8B0@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c82843005eso41910005ad.1
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 11:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783274838; x=1783879638; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uixY+zQC2Q4KaJmkwsvpQ8gw1gGr0gBjP0iygMjhgoQ=;
        b=gkMyaG/+uk1IMq40TY8QVChQIhkUlvrvXQPiN3sT9lpVoSIuEcDWxHGZdJfY3+qkmO
         mV6f/VfE//Mk/pfdgfh/P3iNMIgmqwTcIDuKDbC6pf4FVj68PAKTfOYi+c1lvUWE/v5u
         7+ohcPlj+J6VPHMRUnm0Aaoi4DrobJDptgbia68vdR2Qy0pkbhQkEfqEhXIgeuuDd1RL
         0zsf/+OOiFSM5fwgRxGAg2c679djfAbwlsYPsVpIaV8mlOKUS0aBFLUsl+d7oph07Hoo
         WdwNVuwjxfeyGhY4wlula97h5yjB4BvS82F0fJGmH5xhGbtzT9xwT6SjfObBEwdUSzs5
         qzFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783274838; x=1783879638;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uixY+zQC2Q4KaJmkwsvpQ8gw1gGr0gBjP0iygMjhgoQ=;
        b=Nr3SwSOTl+1C3926uc5bkkcYCHI2wj+60EGynxABG4TZi5Z+5Yr2cE/dxQoUfEI8X2
         Dq8AgeGcq8IiC40EocxOpJvKBqguvwBCifRB9ggcO/8vEE4vck4Z5w2jlfVmWTsfcTwN
         m3nRVtgvWt34FVGSYbeL7n6x3965aQh5a9Wjp5ykhxG+1JBQ19d+MjIV4qGmnBt4uZjL
         8pXjsqvpStcvB2VMAF7GBsyHdyiZDIClwwUKQjOSxxx8pGX8MqQhKV+eYGoFI63d3YsB
         biU+SvymGAFhftWMk1OZGeq47dQlK5Z4zpkSQfznRRvUtvp1QoCf35z9X12NWe8PwCEY
         GieQ==
X-Forwarded-Encrypted: i=1; AHgh+RptiUV31Fyvp2gj+pq0Y4XIR3KuUnw/LC0iBi81Wnc6VJ6yQrhmBMplnn6gwefM1aYjXG457cUjvA==@kvack.org
X-Gm-Message-State: AOJu0YwpVEx7V73xRmzOUXp1dDpJ6F/V/XkKj3xkt4U7pWIGTMRAG23R
	3v5+Ns3fw8ANH9mqduSbB7Wq7REAAPWzBg0V56IwfdTwbRysQMPDpmkOUuE43iAjDw3lNPws/pm
	YuMfDaFjtjUvsBA==
X-Received: from plxd5.prod.google.com ([2002:a17:902:ef05:b0:2ca:eea9:9845])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d551:b0:2c9:d55d:2d1 with SMTP id d9443c01a7336-2cbb9ebc1admr72206995ad.33.1783274837760;
 Sun, 05 Jul 2026 11:07:17 -0700 (PDT)
Date: Sun,  5 Jul 2026 18:07:10 +0000
In-Reply-To: <20260705180714.3708947-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260705180714.3708947-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260705180714.3708947-2-jiaqiyan@google.com>
Subject: [PATCH v6 1/5] mm/page_alloc: introduce __free_prepared_contig_range()
 with fpi_t
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com, vbabka@kernel.org
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org, 
	osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	nao.horiguchi@gmail.com, david@kernel.org, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, muchun.song@linux.dev, liam@infradead.org, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz, 
	rppt@kernel.org, shuah@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0F709A000C
X-Stat-Signature: uqwe53se5yqqxefwyp3w4k3np9kystu4
X-HE-Tag: 1783274838-480846
X-HE-Meta: U2FsdGVkX19GqkDqyky8AbHz5jzVFztJIYepLoLw4B5DGA0V+A02HzseC+VDILaCg/lBsIdwoUGmah8r+BU7941O1q1S8oJvTA7cZ3ovK0CXvHACLmPg/TcK7S39zHAroclTMeHtbghN1aglK0m+01wjfMojcpJUgzRkKXom/KTdAQ+MLFvHdyPqqUyZlseyAmyu2RJKeZcaDf2X8NSRiec+lvHDMGjITPAGCXV7TwoTsiSNoJ+hhD569njrTE3Q5cN+PT9BQCdSQ1pumx6RkWXILVl5iIIBB4jyQzLSqlCNYs6pxP2dDPxKu1jJ7kixF0+JGTvDYXQoBBR3KPffAEIC8DRGKmbOQuS9sBJBLIETwHR9/sGP5z+ulCdm1wQ6XJtU7HIcQQqiIkXoTJ6PcRigOs1vSxO14881zptLw1hcyNeAdwoBpZjx4QA27LI4Yyi3qEPHtV56FBv5iHTjV5bi4ewF4apeqh/mQAHcjL5KDwzVDlLAXe8wS9AZjuKVwkbD7nLrtvDm/5PlhncYqKxm/DejuqrC/A2QjB4vLqYD0vBK3v5+jG92pb5kL2pRaXF1CDU4uOAxLwaX02aP7uJ29ed/B72yEnOUjlh5vYI0FArRmhXY15tZeIyLHtXH+Iv2nPeVHQNGjzAwHkBzoJHqCWW7TGJmjy5nPZ9Y9ZTeMRuJ0Vw8vgv4DLgWOEmfnXb2rlSxRyiTFykqhWiu2qGJnVxwiXgvL6LTXzOSL/aStZnTy9w6Yz1Y8W8vk4QwV41MtVwDlhKjSAqIX39tV/Wi5espqERR5qhlmkWL7MHSBvAzHsfolxjmxbdL1qKPsToN0BnJkwvqRbSIbLcnFbMPB/t7cOf4IUD8//w4nZHOJLU4xcUNF88Xiwgw94ukbFH8gEXNmKKFatLLWGrtapJrbEVuIY2eGsoWaUYppGqEp2ptb4bYL0FXTAUMY639p7xFwEyH6RjWtlm7Ipx
 X2cNKeKQ
 O88b+UCcGc/9JGpQ2CeLp2tfxM79GhHwvwThH8E8nxJDzTwXpZIScLQARRTYqs7MA2RUNppY2wdThDwzCQP5BzrQ+tMPU5QrEv4XI5WPU20BrU8A/i5N7h+iZsAiyFwePX/ldX88P34uz0ACsf6xb8mJItSSk7ED6weheI1PR9oNGiigcer06TkyLpzrFwciYtvvFZYWs1yr35jJ+aLhtCfQxGChz/ccTn0g+EMTfDG1DmGUUXsFstq7bxBwvTdovEeFzlefI2F82aP8b8CFoHNApYRPvGJZxK3Fo5+F4dwKdThq546WiYKW5tNOMlinVkRtkcFbjQIppQ6ZnZRSE3QZsjsb9qA9xh6PQt42UH+kL4f5NSy1hdw1cA5Dt3FjpZTmI6l5nwRcG0MFQM2ejxzdyLLGEltSUm3kA4xdTTodML0IH82H8SDawgdssIeUsMvLS3UY5mbVWjtJfI3rxYKXP6fNYYkYoq/txXrGezQLIsHtz85/w46caU1uPNtapvl8yD5y/SQGux6tRTXeok68qI8tkTN53w7pPT1aZHlhua9XHHlT5GqtpRupxqRkrxKZP6GZCWSbsszTzjU/MPdUwzRdH9j6QvkeBubNOxMwxC+rpk1tG+1YuDTNO7FDLITItWHn1FkLbd8SkjJbMyBkENo5v0GtjrfO/bLRwr1rbjGUE8V5YP/+Bpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future commit introducing free_has_hwpoison() to be called within
__free_pages_prepare() will need to pass specific fpi_t flags when
freeing a contiguous range of pages. Currently,
free_prepared_contig_range() hardcodes the FPI_PREPARED flag and
does not accept any caller-provided flags.

Rename the core logic to __free_prepared_contig_range() to accept
an fpi_t argument. It bitwise ORs with the required FPI_PREPARED
flag.

This is a preparatory commit with no functional changes.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 mm/page_alloc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 762d9b6bc792..7d27aff48b15 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6852,8 +6852,8 @@ void __init page_alloc_sysctl_init(void)
 	register_sysctl_init("vm", page_alloc_sysctl_table);
 }
 
-static void free_prepared_contig_range(struct page *page,
-		unsigned long nr_pages)
+static void __free_prepared_contig_range(struct page *page,
+		unsigned long nr_pages, fpi_t fpi_flags)
 {
 	unsigned long pfn = page_to_pfn(page);
 
@@ -6870,7 +6870,7 @@ static void free_prepared_contig_range(struct page *page,
 		 * Free the chunk as a single block. Our caller has already
 		 * called free_pages_prepare() for each order-0 page.
 		 */
-		__free_frozen_pages(page, order, FPI_PREPARED);
+		__free_frozen_pages(page, order, fpi_flags | FPI_PREPARED);
 
 		pfn += 1UL << order;
 		page += 1UL << order;
@@ -6878,6 +6878,11 @@ static void free_prepared_contig_range(struct page *page,
 	}
 }
 
+static void free_prepared_contig_range(struct page *page, unsigned long nr_pages)
+{
+	__free_prepared_contig_range(page, nr_pages, FPI_NONE);
+}
+
 static void __free_contig_range_common(unsigned long pfn, unsigned long nr_pages,
 		bool is_frozen)
 {
-- 
2.55.0.rc0.799.gd6f94ed593-goog


