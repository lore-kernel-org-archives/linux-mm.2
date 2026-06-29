Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 601D3C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1C76B0106; Mon, 29 Jun 2026 10:43:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473276B0107; Mon, 29 Jun 2026 10:43:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361BA6B0108; Mon, 29 Jun 2026 10:43:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 124F06B0106
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:43:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CF2114013E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:43:31 +0000 (UTC)
X-FDA: 84933218622.16.FA7839C
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7931DA000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:43:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf25.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744209;
	b=YRg8d0tpBWKu3K0lEJ2gVhnXnZjRO1sD27901dVKTyI9BZShciAd0kaJb90oOLQmWpzL9P
	mrWhiL4oM6P3eIdN+3dLl/XhP6/Q87AsSFu3U2IbH/rGqNRpcWe+8OWkSzU5pn7F2ePKKy
	Bc62hxZdYmcNFEopfWwzw//9zzrSrNY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U2wEKDFSvEEnO7AMAu0Ti/YwJ92qiT9/XJxwneHR3Dc=;
	b=gtBjvWGGiIEpQAHXBrTMZRB+RvvO8lFtnUCWK9KtunI8ysO9XmeI3m47r7VatNf+dixoKa
	ymieSCQHuvzpOivmJfe79DA3dsQHLhzIwqLK020ew5AIF76KyXJOuSeS9OWxriC4JCGX7+
	b5qFJRr2kBeakra8jU2hsf+6O6IgYAM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf25.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gpptH6FJ0z55RJ1;
	Mon, 29 Jun 2026 22:43:19 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 65TEhFFV049040;
	Mon, 29 Jun 2026 22:43:15 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 29 Jun 2026 22:43:18 +0800 (CST)
X-Zmail-TransId: 2af96a428486cf4-6c292
X-Mailer: Zmail v1.0
Message-ID: <20260629224318783u6CQwXyKLEVtR-nJLFZuq@zte.com.cn>
In-Reply-To: <450d77b5-9fbe-423a-82e7-1a178cb4d3cc@kernel.org>
References: 20260629174424441L3NDvwfAQv74N4ZLs1PRA@zte.com.cn,450d77b5-9fbe-423a-82e7-1a178cb4d3cc@kernel.org
Date: Mon, 29 Jun 2026 22:43:18 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <chengming.zhou@linux.dev>,
        <hughd@google.com>, <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2MTAgMy8zXSBrc206IGFkZCBtcmVtYXAgc2VsZnRlc3RzIGZvciBrc21fcm1hcF93YWxr?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 65TEhFFV049040
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 29 Jun 2026 22:43:19 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A428487.001/4gpptH6FJ0z55RJ1
X-Stat-Signature: dzc97bsuz8k7j3by1pf8nadcsakhtmft
X-Rspamd-Queue-Id: 7931DA000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782744208-799672
X-HE-Meta: U2FsdGVkX19JrEb0A3mf9mAq6+KKilzztSueGnzEDmJi7uPaaSL2ut7N4yfSf3vJJCa87exEpPnZchidzqm1umUqa0JCHx21aRrE9lD8qL2bMeT1ryerpbm8o8ADVHaa35kaOgRqqb1J+Qx8QqeY6fx+hEolGJpQ5gTcxbrbr7jWefFKY7dUCbQsUR3WujBoI6cZY2VFKX8qk2mtDGYN5oZK4nQoqHPJwVJ1ehQin0ZIBaknadI6x0L7UsdDA0BWQf/3M2xvxnGBZ+qQcBkyNnw77QLpTGp1s/VhnPj4TMPih6aanHrUTA4/CMR+JyFPAvVmU/9kbeMWqwEBMWU7z7UXRK4EI+jKOJYbadpSVrnNC5ljqna1btfHRxQZTVcVAcAo+oZyswXD84kCFL0k3paMgbOgUCNeRLOKH8263K9NwCTjyDiwRSOX5euygYm5JKEIv7tz4WKSoOURbXdLxbIiqfb98LiVjKOT+sT5wY89vyzW1kZidh02tIm4ou3tCgInk6G8rDZtbc5EfGhCWGqm2XplkKJN69VEZ+cxbWDgcPgbsXx7fexDspNdBMeiJ4N4AbYReiUcseHBJ3yJxVUy+LVVFvWXlvXJloDstT7XhAlKtSWJ/vxsPOGAKpOChn8a6sDaB/A86jzvzu58j+1Fb6+EGK2TngI6l/BUrx3qpJW00CCZ+AkA8Znqe/YHiMH0w2NQmYlcIXwVOWL2ZAGRlYEqUia7Qc+SP5FITsUdOgRt0WtGIJipa1TncJ/oK6d7M15pGUZKmdBf60/in4iImMsdjxOEopbwEo8kZYQgu3QOVU22BqGLnwBAUhTF4v9XbVXmjxCw+/46YWNgOVII+H6myT4yHclFzgaAh1rg3fNeW+VhCrGMOmLxd0gkqx7moTWBldRJIETbW35OxP7Rh3ExtNTWwrbQ1EQW0gtYNh5eCud701/NDyGDNuhaJ9gh+DNmyqgREqqGoXS
 Ot2zFIAI
 OUT+6WPQigF4enhCgP4Cw6sLQIg9Uy0ElTjim0xGHKc05WGdTXxivOCUXAce7e+9y9cslRBqUejctmnsxHg0gTZ1NSfhcfqaGhbKqlnSQj/o3ttjfb4Af3LuvgBJ+9n8ZBwHQ7RnwqXfl95wpGmI2pDPx0Lka/m8XMUJp07abf8pG/0VlMERU5Kkt65IS0ZT0Y5xZEqnTEO2SkB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> I think there are various improvements and simplifications we can perform. In particular,
>  I don't think we need the errors messages or use data-> members.
> 
> What about the following simplification, to move this over the finishing line? (untested)

Agreed. Your version is cleaner and tests successfully.

> 
> There is the low chance of page compaction migrating the page while we check for it. Not sure 
> if we should handle it (but it would involve retrying on PFN mismatch).

It is really possible. To improve robustness, how about double-checking in range_maps_pfn() and
rename range_maps_pfn as range_maps_the_same_pfn() which caculate the fisrt PFN itself without
the input PFN as follows:

static bool range_maps_the_same_pfn(int pagemap_fd, void *region, int nr_pages)
{
        int i;
        int second_times = 0;
        unsigned long first_pfn;

again:
        first_pfn = pagemap_get_pfn(pagemap_fd, region);
        for (i = 0; i < nr_pages; i++) {
                if (pagemap_get_pfn(pagemap_fd, region + i * getpagesize()) != first_pfn) {
                        if (second_times)
                                return false;
                        else {
                                /*
                                 * In case of low chance the low chance of page compaction
                                 * migrating the page while we check for pfn.
                                 */
                                second_times++;
                                goto again;
                        }
                }
        }

        return true;
}


> 
> 
> diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
> index 53f2058b0ef2b..1b7ab46a520cf 100644
> --- a/tools/testing/selftests/mm/rmap.c
> +++ b/tools/testing/selftests/mm/rmap.c
> @@ -430,4 +430,68 @@ TEST_F(migrate, ksm)
>  	propagate_children(_metadata, data);
>  }
>  
> +static bool range_maps_pfn(int pagemap_fd, void *region, int nr_pages,
> +		unsigned long pfn)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_pages; i++)
> +		if (pagemap_get_pfn(pagemap_fd, region + i * getpagesize()) != pfn)
> +			return false;
> +	return true;
> +}
> +
> +TEST_F(migrate, ksm_and_mremap)
> +{
> +	unsigned long old_pfn, new_pfn;
> +	void *region, *mremap_region;
> +	const int nr_pages = 16;
> +	size_t mmap_size;
> +	int pagemap_fd;
> +
> +	/* Skip if KSM is not available */
> +	if (ksm_stop() < 0)
> +		SKIP(return, "accessing \"/sys/kernel/mm/ksm/run\" failed");
> +	if (ksm_get_full_scans() < 0)
> +		SKIP(return, "accessing \"/sys/kernel/mm/ksm/full_scan\" failed");
> +
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	if (pagemap_fd < 0)
> +		SKIP(return, "opening pagemap failed");
> +
> +	/* Allocate and populate twice the anon pages initially. */
> +	mmap_size = 2 * nr_pages * getpagesize();
> +	region = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
> +		      MAP_PRIVATE | MAP_ANON, -1, 0);
> +	ASSERT_NE(region, MAP_FAILED);
> +	memset(region, 0x77, mmap_size);
> +
> +	/* mremap the second half over the first half, to stress rmap handling */
> +	mmap_size /= 2;
> +	mremap_region = mremap(region + mmap_size, mmap_size, mmap_size,
> +			       MREMAP_MAYMOVE | MREMAP_FIXED, region);
> +	ASSERT_EQ(mremap_region, region);
> +
> +	/* Merge all pages into a single KSM page. */
> +	madvise(region, mmap_size, MADV_MERGEABLE);
> +	ASSERT_EQ(ksm_start(), 0);
> +
> +	/* The whole range should map the same KSM page. */
> +	old_pfn = pagemap_get_pfn(pagemap_fd, region);
> +	if (old_pfn == -1ul)
> +		SKIP(return, "Obtaining PFN failed");
> +	ASSERT_TRUE(range_maps_pfn(pagemap_fd, region, nr_pages, old_pfn));
> +
> +	/*
> +	 * Migrate the KSM page; the whole range should map the new (migrated)
> +	 * KSM page.
> +	 */
> +	ASSERT_EQ(try_to_move_page(region), 0);
> +	new_pfn = pagemap_get_pfn(pagemap_fd, region);
> +	if (new_pfn == -1ul)
> +		SKIP(return, "Obtaining PFN failed");
> +	ASSERT_NE(new_pfn, old_pfn);
> +	ASSERT_TRUE(range_maps_pfn(pagemap_fd, region, nr_pages, new_pfn));
> +}
> +
>  TEST_HARNESS_MAIN
> -- 
> 2.43.0
> 
> -- 
> Cheers,
> 
> David

