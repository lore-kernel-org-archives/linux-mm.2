Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 014B0C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0E26B009F; Thu, 10 Sep 2026 02:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577816B00A0; Thu, 10 Sep 2026 02:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 440C96B00A1; Thu, 10 Sep 2026 02:33:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 183956B009F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:33:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1DF9C0417
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:39 +0000 (UTC)
X-FDA: 85196886558.20.01E8D23
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id E90A440009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Mnslk3Nd;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022018;
	b=NyK7MqHElSR512bYn7P8cF1BUL3NcDmMmYgAyp3SeD7tqBRXonnHa3hf7k4rrM/EsRTy7G
	0Sw2zelvknaqkKk/b5YDQDLqC4SMXIMfboP72Fj4AfNNnwwgg3s4mSB01RlqGgZUqzWvZW
	wn8dfPQu8QRpgrl30ZmRh1iAjFejE4o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Mnslk3Nd;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnePsJhsQF7eMOx8C/uEqh/ex5Od6EnmeZ+DbGqwr5U=;
	b=IaogqkS9Wx1ne8C4ktaoNWc8y4+xxznMXugssXZVP1B0Yt9ODT9ZkL2j9w2/AI160Rpm7o
	R+Re4fNKomseXsf5AUtCTrbGHb/5b8ATWbvbOB12RUYv5yvznaHPUlTQhDy2E2DUy6sByQ
	hfxHCHO2dbJOoThkyvL7T6ZSobcptGM=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3964dfb5b9aso8000786a91.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022017; x=1789626817; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EnePsJhsQF7eMOx8C/uEqh/ex5Od6EnmeZ+DbGqwr5U=;
        b=Mnslk3NdO+1LhHSIhNIYfunT7KE7fh6b4P4PZWLhfGze85KrCvy2gwTVuTfv21wWmW
         4RrdZTxhP/mAWzRtj7bP9t3f/82Od4IoY2jHJReI6UUFOtrtif97AxAdIIEIMYs2p7dk
         pxGyYOpFo/CTCVM8VNCMs95KidmdFca3kHJOxHpqNC6Tx3O+sQ3+KWp96Qtux7Qqy33b
         qaZF4U5V42hZ+QtPEulrABHA0imSlxxAvbmo/zzBgwsUteUkzsVOzPoXF9pmgjYu66KY
         vR8xJzOcHIg1M4OD0ECCaP6BO7BzL6uJixXFZgXgE8lU9oc1cJGOAYoxRQjNZEJo1q7m
         cuRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022017; x=1789626817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EnePsJhsQF7eMOx8C/uEqh/ex5Od6EnmeZ+DbGqwr5U=;
        b=bQKKiPdshi4OmIs8XdVMabsr9tiPUQhoZzFl2F04Z6VwZwxxg77PjZvNsWTxllWe3R
         J8NYBj4/2ukyceldOScsf0S1lHzYUGZ12JPwjPQ0xUgqO7+cVGWP5iZqn+uVNhwCuolI
         Y5sjSxgLjH3s0mA+YQf9qrTDWJdZej621eKLm6gzsBzAmeI5trN5zP5J0uz7iuSKA1vr
         ku2GK3x25rS5gpPc5CVKSMWqntjbHKqiD89MsfhRjcwge1kDzI4svpPwqvkiVFn35mrr
         f2df/wGRJvw1r5DEQI7HPSH/zHSpk03hkujlSbKHagUc1ywmKp/DEPB+2ebClElMSdWG
         Hnig==
X-Forwarded-Encrypted: i=1; AKwUvBwg5vN7qsJtX+OnYjOk/xvfEc/6iRodSoqJEfCMiB6F+kmyp1uV6peBx9ulhzcDp0nzwZAZrk4y6A==@kvack.org
X-Gm-Message-State: AFuF++mu3BU1nM6OqPezs7MR/N++6WYgIY8aEecuQS4CicuGpT24ryQ3
	ZOZygVbSp551UVpnlVTJUSHFbl/onP099OjzICzogs4IFB7KbX6A9gqGqTfLVwsNBA4=
X-Gm-Gg: AYBFou1P+iFBdo/zPrq8vO8coF2kb3NK4k+eF3C9n82BvW+yORzUFjAve1cYUX9qrAv
	57BBfMgVzpGKumeOL9oT7qynO1KRh37LCh8pYYFE45Y+hzrK8+nU+4ZEGuPjmjCrf7sO4ySF5h/
	PMj87LAO0XIt11YiFaAAJZCDA1bqpMEtdaYCkyFzGP7FZuvAKQwEg4fCkhQweh5rAQ4FNpzzBa1
	8ud25uY0ob1qK5hw/LZrGYlBLDZgbc38nIvX/uaRsgbADN4SFaUI/dMi0C84KouYEsNWJMDWGzc
	x27hmrcLy0eHIZJt6+vEs4WsbLLxNsTiOSOc6IPUco2TO0oq/4Dlmwfq3SpaDwfnW9gm7yBbDkS
	QB9CHGqjvom51PWsjaTSoC+q5aiu572IYeOb4Mdjt87wqexwNyJ5F2WkAcj+NzQQhgVOFgRK2mR
	eVci/OH6BGJOE80HhsHd4b+5uy5zH304+nO/5Ix8uyBxy5issTg75UWxP8CJRWHIBMhapQi0WG+
	KUIlvwcsaOw69xNKX1TUEZshwiHPmRutI8=
X-Received: by 2002:a17:90b:50cc:b0:396:65dd:4093 with SMTP id 98e67ed59e1d1-39b26202ebamr61814255a91.14.1789022016692;
        Wed, 09 Sep 2026 23:33:36 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.33.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:33:36 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v6 04/17] mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
Date: Thu, 10 Sep 2026 14:32:43 +0800
Message-ID: <20260910063256.64386-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E90A440009
X-Stat-Signature: 3n7stgr5559n1gyaiof9df9fi6g8fqk7
X-Rspam-User: 
X-HE-Tag: 1789022017-372757
X-HE-Meta: U2FsdGVkX18sCs9o026nyay8uGwiH78kgP6xVSEk7Xenqv2wgfklkFO1AMSfO2+r0n1QDHCnDFJI3klY1dOxSyK8MnZCbmJGAAf08DSau4e1I/J/NShkd3TpQQ4f3VBoo9IIbSQqS9OLJzUv+ZSgU7SNOobQBL7jNzv+1pJuixT792cPQ96vY1TWk/cftXqhspXKiwJRR2jyaDOTNHeLhHBfauVl36R056YEMECrIFuKt6ERjorz7Utm135vGURSks+DTIfHQE8JBommxuI9flhiJ1xh/Ec/EVeK++YCst+YTalhIU9YWM2vfAKjfYl8QgvJrh84SQl/NJRn8DukjRlMBCoS0YbCjBXc7P8JOJWNTI5XKNBveZXSTAOuEPoaB4b00vhek/rrAFMsSs1lZFhEJPYtjHi8C4EZqsFI+zvqXr1ddN/XA+YSy6zz5dbcUzs6gkEfPPtGbz0fE8c5EiumKGT3v2fLxqozoqkYVU0jk77dC4znm8VRAMgsToNsjq54f4ILxsRLfF8DNh3arAcIS52svy+ITT7y76oQEApDlpwdOITw0HdRxod3gt56hpSyei5c9dNl/KZesjPF3TvxQE+QJzGkDPisRQYv+rt+d7KamBrq3+oJKYJYY5PFwEFmBafHVggnR3iAh2ydxwwZcW5zdhztqk9Jfo5E46bf73e7mpXGJDeDcPpV0lmZppvtnGgGohW/93aIxh7YRYDlWT1pZw9iUrBEXBO6W4zVIRFnRO1oLZUYpC93oRH+rWCKxhd2wPslWqC6cChJp873KUEfrY+u23hYKhDgk6UgO2HV9YwX0nGrW9Ubn/y6C8EYEdWY5u/huJml2bOz3nzLOG5TNsKmnoh3ZALtvV79R/2ETv1F7Fzbynq3I526srTzyOXIytWJ6cU+HyazlhmctyQ8pT5gviVZTWOPQksKWokNAwwsJs3Gst5dBscq5FDJX8mP7CLZ4cZTt9x
 UneOt9O8
 XqjIAoNByCORF3nDnhSJNhK3lBzjCpQ/U0qh/hZ7Iu5ohWnn1fIOHFhcSFiDAaeTPHLthNQxhDn4mm3I71xkH4jUzBY3jxlfNmv8lXFmYr1UxgbvSeFA34pNvNWTzM+O5kxgSr68qsTjcR4h3XeCzbMGsgtZ1RZckfyMAwDXpiG7XicAPBZpk30Qq6tzWmCn4jdTLwSOEk5pP6Hn9nUJgPX+8bzT49TgMIb7X+UozI6R2q+PW9ibij5T5vsVLvurfgG9QUSInnPEKisGcMJWS5A7zSH7dit9QCPQ8HAXPwyHQ1Y0dCuWN1YcPJDG9rKkvaXxGcr2HqmY/BBANDAEddSiwiPJYQJvQs1fVnHQmNcwguAjOi5+hSCONU9pbQECCC1Qty1V+Ml117kH7iMwGy+aGdoFpMGVj1LuE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The shared tail vmemmap page allocated in vmemmap_get_tail() used to be
left uninitialized, because memmap_init_range() would later overwrite
it.  That forced users such as HugeTLB to defer the initialization to
their own setup paths.

Now that memmap_init_range() skips shared tail vmemmap pages, initialize
them immediately in vmemmap_get_tail() with init_compound_tail()
instead.

This adds initialization at the point where the shared tail page is
allocated. The existing HugeTLB initialization remains necessary until
the compound page order is set and memmap_init_range() starts skipping
shared tails. It is removed when HugeTLB switches to the section-based
mechanism.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v6:
- Clarify the timing of shared tail page initialization removal
  (suggested by David Hildenbrand)
- Collect Acked-by from Mike Rapoport and Qi Zheng
---
 mm/sparse-vmemmap.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index aa6a4a2fae98..107215cf8488 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -338,19 +338,11 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	tail = zone->vmemmap_tails[idx];
 	if (tail)
 		return tail;
-
-	/*
-	 * Only allocate the page, but do not initialize it.
-	 *
-	 * Any initialization done here will be overwritten by memmap_init().
-	 *
-	 * hugetlb_bootmem_struct_page_init() will take care of initialization
-	 * after memmap_init().
-	 */
-
 	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 	if (!p)
 		return NULL;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
 
 	tail = virt_to_page(p);
 	zone->vmemmap_tails[idx] = tail;
-- 
2.54.0


