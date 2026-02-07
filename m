Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BC40EE0AE0
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 15:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE86D6B0089; Sat,  7 Feb 2026 10:37:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC0086B0092; Sat,  7 Feb 2026 10:37:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBEAB6B0093; Sat,  7 Feb 2026 10:37:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC50E6B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 10:37:29 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2200EC1C8E
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 15:37:29 +0000 (UTC)
X-FDA: 84418065018.16.1784BAE
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id 44ACEC0007
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 15:37:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GcKiDm2I;
	spf=pass (imf10.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770478647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0k/wh7ANdTi5nQi/YCLRVFUaW1qmyLoqNdMBFYAjzbQ=;
	b=pC63XU6jZhgtFIBz7S421ZUxOKxTCC256CEVUJEDKgM+yHk4vnhn7uPbJqngrhc5vNd+E6
	Zq+5jiq48mnR/DVfyymbDVYweb0lV7nU6tK84dgIR2UtOnIQJvvUaqoNk01d2emr+OILUr
	GiO+QhHgjecGUvKAh2KUEd5o/kkDfKU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GcKiDm2I;
	spf=pass (imf10.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770478647; a=rsa-sha256;
	cv=none;
	b=S41Lyy+2XS6qOMm7XcYGkWhy3+6EGFIfdeX2TeQsZuTJSsN3YcInAxUwxhFRFMk/Do0qMn
	qbdzhAS5C16Pp3Q6PIb/6a+VFlILK13V7zmpVMyrmoVGBw6Q3MjyaZzLNXFqIsOJ0m7kID
	fhiuzkEGvjzbafMk6EvR/4eH1pjcRi0=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-59e17afd2d5so1953882e87.3
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 07:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770478645; x=1771083445; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0k/wh7ANdTi5nQi/YCLRVFUaW1qmyLoqNdMBFYAjzbQ=;
        b=GcKiDm2IFIJc9VOJAgVbCSN6p7U4oL/6gQm7iA//e82aGZPGu/44gNatd545eKOtxQ
         xAaZewMUW3vzlHlFRr2QgFoHtplh0tkMYZkYpxKhczxzC5rcGZARnloLd/vA6dUj2QH8
         Rh5+bXayBZy3xvAosd4sNYDvieHIVWMnNFC+YcffvSJEOj0IdbQ41Zqjvd70PWkb2wTJ
         I4sMRznvSb5wzPjiDRYHr3mvao2XPxG9bwFL7gm8GcvboCGTvFHCrDkN8YiMESwSV3AI
         x2dBAymO9dqBK+tS6RdNiNdUJbil/H7sWEgdlvo7hAzZ/q92LmjcwWD1Nd68rUOvQ2uz
         Uqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770478645; x=1771083445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0k/wh7ANdTi5nQi/YCLRVFUaW1qmyLoqNdMBFYAjzbQ=;
        b=YMSNW3awM4NFA2aW1ZFYG+kY8uSYZ/MPbuvNXwZnRtADTNo7oMxLiy2XSjUB5GenFy
         f0LRxEwlS4FWPgxX2lPidi6mcCbpqzpvzfS5v10zn+xMRBbcbj/pchhIZVnhI1f2cI5b
         3aXuOpjOBy0w9ylhH+XEPQIdQbbKaO+UNAC8zRsMp16xoiJP1TXFzdMXoexNNkdunZr8
         MyMHtrogjL4oVQoWHh8twhkT4My278B1XWsIccv+9b2D9bWfh9O7lYm4M4hvFiyOjCg9
         Fg9GrypgKKAf7slmSTGLd7VX5qw+hi3ALrmebSSjvaNB2YrEKbPTglBKiFkq07ACfwYQ
         ECJg==
X-Gm-Message-State: AOJu0YxAONUl76NlVEd152pLrI99lZMmJ9BCLu8vdBTA08s/Lxyq0Dxf
	0AK3nC5q/q95YL9v0C5nxFvln+fD7DSS+niaCwEVCEeqd9rkopE+qrWC6dtBpRrxhbTZqA==
X-Gm-Gg: AZuq6aLYXMNwBB76wq+zRihBGkSPCZ7nDqLZEQ9yv08CJio3xP65jswtjB6Np/MaHo0
	ajwjCBsfasdzbCiDyMCP9YVtttD4r383s3/K54kdpdTap/V8o8CKIxfBLzTezo+eDOGUUezv/QP
	fHGxpRl9Al3Cp+YIYn+tuJQd071P44QDDo8kNKhL7dcoPfvZNtmBuW3VFnPIoJZUCaiH1yqwOvO
	vHTA0xCLtMFTEAkVhF0l9xetX1jC432ZPoaP18NdGOfbEfaLhzHGq4itdmN9Dke/F41QS3zdKjV
	RfmKLqGPLTViY2P4mWvkV6qHY9mdCQ+LLpDFlIMu2C5ajTaXwPukRMjqbmFExTQIWVcGt7WNkLl
	l/2dGGtMBImaMLfRShzBNKB5VwM+A0vUVXOarkx0w9VNhZEdwdjUWcxDOav96p+vgP1sQo43bER
	wh0DxQ55kbcZxi9VDBo9aKiVlj2keMdrdl
X-Received: by 2002:a05:6512:3c86:b0:59d:e771:61f0 with SMTP id 2adb3069b0e04-59e4515829cmr1941200e87.24.1770478644744;
        Sat, 07 Feb 2026 07:37:24 -0800 (PST)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e44d299d1sm1374187e87.64.2026.02.07.07.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 07:37:23 -0800 (PST)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	vbabka@suse.cz,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	ryncsn@gmail.com,
	ziy@nvidia.com,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/page_alloc: clear page->private in free_pages_prepare()
Date: Sat,  7 Feb 2026 20:37:15 +0500
Message-ID: <20260207153716.59302-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <17A126A7-BACA-49E5-8A89-F8E665981136@nvidia.com>
References: <17A126A7-BACA-49E5-8A89-F8E665981136@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 44ACEC0007
X-Stat-Signature: xrqsuududxt6u9isfp45adpbwyy43u9s
X-Rspam-User: 
X-HE-Tag: 1770478647-159212
X-HE-Meta: U2FsdGVkX1+hUpjwZT0VHBNz+Je1tGSmfTde5BsFqIx3DXWfuTiJFFNgJrAjgSlX/T166tGyAmzE4jnXGbpirz2LbrDblNRINhojbm94U4p80COuMjPGkxVwO6OntXa/RHU65c4/smMiZCnIuQ52AKQf2eqK40BbZGhj4WINeYgiNYEJl4Z+ncenVSOrenc5QBk3JTupKlAJYe5wcFMo83jpWLdXNms0CDu7OvzNHzxKDGXK8Jx5pYqAwW1QnKia2yODk/RZAt9zTlfyz9iAiVXjiT3d4GzKqYwZYp7JFAnMYHLNbnf9dz7NmpSi419zz0HDe+fjH364xc0f0kBn9HfVWA5XUgw7EQkv63OiM8IsH3nz715Nd5KtvGxaR/WRLRwpY89xXCjyoSX3VGQCkIhZFp3DB8gkeCLa9tiLihqMsgMo53NSIDCjIcfjaSdjR8WxCj34gRRlh6IYjhIQwseSLqHeQZLhRrwabhe893XkNRgoEZFbg4dFZdDHSwm7jO4TSiKVKXgR/sWo2SvFlU3YDUXdyFM2vZtTREA4cq0nknYPEPMxcfdT3MElCtfWGOohXq+Z5B2jckQjW7GrklXzpayUKySv62Negv415+c5AecMrLEK11wiOabh9PnBReZKnytXXY7TSNzjLa3AnQhz9dsQm7eS04S3tU1HSgzUpofQGCix3bNuUuNaVJNBs7+fHAd7NjxUupjlM9Dgch7W/RxWNqbujImMiOOXAIdbXltBBHOxzd3Gh32DQQTWeZEiB0q7JmsSB7fFdZRBqi3vF5vzO7ItXpEI6lgV/WZuDnG16oud/H9jwTNHWXGp4ps/kKJdmUfQ5JDhelamj8KuswEyhZz6IrbLsFhLxyi9UeDj3dwb5l1ecunWnqc92HoH0zLeEATaWtb/mt1J3FwDJW3F80RIjVFXSRDo2ZWXo+1IbEw9Syjkva18s1qVXElRWgILrEmBKoteQcf
 /K6HJoww
 K+8RRgxMXi55buOf1VpP5oCFqg2YGNL73af2FrzqYPuwKkwecx9pPKPrnvgRFwClUOoXuSVFCteQnpHLLACTsBfBuQTZm9eqf0rYTlVuhogQFtx2eFu6J5cCoXAqxg+W1T1mcKISbhoQvikGFeJIiqtcoUmOi57pYKlmsfv1U+bRybkns6bMUnI6zuWoDcpFMhhBtkX2EHaXt9GB1G3IbWEKxo5U7cQA5bRdaR+0WQILdVJsmP0H30z68uLiUk2sWdDNaxYtX/xn2dMLz1J1n4EWwJMFeDIAzoHrl27yshuo4ELiucZx/IgrVmM7FDRAfC4IYlodCwYNGPsD06oaPDL6bzjkjwSK4aWU8jVlFzmJeFi9EkSylTDDdno6jWH5czgE6oFdrRipvQE+pCH1ISrgAygus7XxPbumr+nKnHnYkD48Aap3DhbWjcqMSVInKvTBnb3xcHfvNP9PSE78XqIpWMhhx9WgWBjm4i0LwYUbXSdPpZatHzjxG1Kv3+7gSOwQ3YcXemLYyzHLg/7lRJhWp+gMwT5CKaP9iZCA3YOMXL0EHmXiOcyGb+d/s7FAvcvY2D67Kz7cd37UDoByjgVUiek96TZ+IDjbDTkMavynQCqwMQYbPiS2Nk33mCHD+Opx4/RC6cNwpF3VV+DtJ4Tr3GPv42LEPPM0ez33SqPcYSQRxay1mBEHQbbYlJnYy2eChqM8KNn35wxOqQkVKTVA0btM+Bg7hbMLazKj9jmb/S+h+IGuLFgOpuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several subsystems (slub, shmem, ttm, etc.) use page->private but don't
clear it before freeing pages. When these pages are later allocated as
high-order pages and split via split_page(), tail pages retain stale
page->private values.

This causes a use-after-free in the swap subsystem. The swap code uses
page->private to track swap count continuations, assuming freshly
allocated pages have page->private == 0. When stale values are present,
swap_count_continued() incorrectly assumes the continuation list is valid
and iterates over uninitialized page->lru containing LIST_POISON values,
causing a crash:

  KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead000000000107]
  RIP: 0010:__do_sys_swapoff+0x1151/0x1860

Fix this by clearing page->private in free_pages_prepare(), ensuring all
freed pages have clean state regardless of previous use.

Fixes: 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages should be split rather than compound")
Cc: stable@vger.kernel.org
Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cbf758e27aa2..24ac34199f95 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1430,6 +1430,7 @@ __always_inline bool free_pages_prepare(struct page *page,
 
 	page_cpupid_reset_last(page);
 	page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	page->private = 0;
 	reset_page_owner(page, order);
 	page_table_check_free(page, order);
 	pgalloc_tag_sub(page, 1 << order);
-- 
2.53.0


