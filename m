Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC59CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFA026B00C6; Thu,  7 May 2026 18:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABDD6B00C8; Thu,  7 May 2026 18:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1276B00C9; Thu,  7 May 2026 18:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE5D6B00C6
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:23:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 603FC1C0DBB
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:04 +0000 (UTC)
X-FDA: 84742050288.28.7677A87
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2C69320006
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AxEl6DEg;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vuT7UcDWAinUs+BER1tBruP3Sa2tRxGHJfBaIl3a77Q=;
	b=5yhrKSDwrOrw017vfs6wy4kO2XhbifU4BYiSKH/oiQrUK+2YunVnemLZVZAX1HSVJOXD4R
	6LcEkQcrmd6Zu47Gr5+lGLiRvYc3dfldK210f4Di2Be2U5mE5Usndi3aNdOo3EWFwhRpcn
	ue2RI704qOhXgFqm9YkaJvhQS8Fra8I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AxEl6DEg;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192582; a=rsa-sha256;
	cv=none;
	b=FozRgz348VIbEZHfd8/UohCxoo6c9y79/dOYvWwrPiczfZ/OU5i7XMmPT6ZA8jCOEhr1mR
	LFwcBo92FcBzDdEGMdSd16dIlW9dDVGc/lSJP2uRIzyTnhdNbniYDvTX1Lw4rGIQF66CLz
	gCxrQ1WuijOuqft5uzhZE3NtJJZl2f4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vuT7UcDWAinUs+BER1tBruP3Sa2tRxGHJfBaIl3a77Q=;
	b=AxEl6DEgw/gXwCAXZOJWl913ynQqo0/3iRtADYpukUaG3e68/+4zEahCqvJfOBMdjsE5q2
	FjBPV68fd6gDxXVugEBuaPdz1ilUrZrmijhJxxK/stDYx1hzjFBIVS/xed/GwGvUxQGvqJ
	RQdaIhr1UsGMfjrZvQi2e5nO4TfeHc0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-VL66bNEbMnW9liaFthPdKA-1; Thu, 07 May 2026 18:23:00 -0400
X-MC-Unique: VL66bNEbMnW9liaFthPdKA-1
X-Mimecast-MFC-AGG-ID: VL66bNEbMnW9liaFthPdKA_1778192579
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-44ffa15dc73so1176538f8f.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:23:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192579; x=1778797379;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vuT7UcDWAinUs+BER1tBruP3Sa2tRxGHJfBaIl3a77Q=;
        b=Eo9sbgAWC7AKlPN0lBD9BUfTzstcnw1I8EBzGUjT5eGnzb76oQrGeH1WVJCEiMq9uo
         +Edv9xTKrcP7dGeiRIw5g0Zk0dj6ArjnaFfbB8CB3unIRuBLM2790FHZPm1LkkWunK+V
         0lHPx1XFkZ7+yIUomG92Euzhfd4BxXU45HzbyLbNe8I9BtXVUkCb8YomdN9vc8l/vyU1
         JewkyF01Cey9HC0MErmKj27OuGMM5S51YE1eeytyxT1txzmyv9zoywb0PflV1yn3llRN
         e3L/DSZuOBsXR8URm40yti7Jg4vmSuGttX85heWZ1uFnppgtcCO9u378dUHDabd7y3z1
         N0tQ==
X-Forwarded-Encrypted: i=1; AFNElJ92/BKvgD8xw8MhDh7a9kBRnf5QgyMQ3UZVAzDmrTnZYA6AwlGDRwkyZ6lZwxFsrjh/p6rSwqIUhA==@kvack.org
X-Gm-Message-State: AOJu0Yxn6Zz2bYz5n8s3Zf1CqqxYvIMreLcGqm8l/eA4AhdReT74he4g
	XZPWe4vcLbHlUDG+M5g9A9ViqdzoyR4FF2R8rjy+hUPBWctXK6vzS/bSOntWvdr4PW1P3aOdTV7
	kSZdvuJ5PGcuFjjrLrKBCns+1r5NKL5LTRva9Y0KzlHWb0Ku+jhFi
X-Gm-Gg: AeBDiesxRFNh1JXw7UNzcJ74CAk4IREycmVxXnW/Q3oB0bB3YtR8PvmDPjuwYfhgCDf
	hJoLO/Fa9E6CPiQ++SYEe+sVNYMzoNsuIXgn9DRJER+xxMDeEK0VIdyXEr76UKlvVZCTOQRYkY5
	Fcn9duQpZuoRDZYlyiyhbxhyb1hdApa56S1LJgQn1ZTvjXq4G7T/77pMkVJNZN7wb61gdJkHXCv
	Ya4yKtzaQ0/ZauyFKfKZv0wg/NRl875TMYs0Ugmxd96RBOH8wZR84rbim3h6rJ2+zMNA6ynwS/+
	wapGcCtUOw5hjQ/R4qX8ssZmDVe0kijnqZJLl6J2OZctH0ZzK2fAL7S7bWN4gwrpdyS17HytHbZ
	4U0Xl/DkxFRsq2+/hMDXGOXePPja2AGCkdRjurVha
X-Received: by 2002:a05:600c:3ba7:b0:48a:7772:c26b with SMTP id 5b1f17b1804b1-48e51f40884mr168625825e9.26.1778192578927;
        Thu, 07 May 2026 15:22:58 -0700 (PDT)
X-Received: by 2002:a05:600c:3ba7:b0:48a:7772:c26b with SMTP id 5b1f17b1804b1-48e51f40884mr168625385e9.26.1778192578402;
        Thu, 07 May 2026 15:22:58 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e67349df0sm2936025e9.10.2026.05.07.15.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:22:58 -0700 (PDT)
Date: Thu, 7 May 2026 18:22:55 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org
Subject: [PATCH v5 10/28] mm: use __GFP_ZERO in vma_alloc_anon_folio_pmd
Message-ID: <1644850b5868bdeacb02c753aa1d7fb20aca199a.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dJoyOb4RL_zzjDpqrcqTliowWbtmkw_FWbcmt0sBScg_1778192579
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C69320006
X-Stat-Signature: 5neupindorm5u5se8jat3opnob4jthur
X-HE-Tag: 1778192581-841859
X-HE-Meta: U2FsdGVkX1/WuzRJfG/Tvhia6DxuzOIwrqsR6e7aFlzg9JCKBTKVsolJGKjFAban3UJTLo+Z4YecRR9OBOUZGfBnzr4lA5zSv7r+BlJiQzHYNyiZn1b3OlKIxIWOF2ylV0vDgjcodJJAHscRWQAG/p8P9PTk7hyEEfpSbUcFhycixiqB6EXz3dtUs7YV+JH0xGqhl8AOdUJB3bHAk8RZBS2kZb/oBo0tFvxpAWij3EoGZWngaAo7tF2qOvC0wH/q2ejnbzqlu8BbSQwJFuouOkDH0jstgbss+vLwTTlVkYvKGxYZMfC8AMD2dIbmZir25TBIkVwV1MKUxqEMl9+Hlvbz62PuRxNlc5besx2CKTIDNuYTCgfVk1UBE6iXcFqxF++u7PvfUVqoafBvVM/TUaaVLcjARI9OczGzpBToAVciWMF+3hIgj0q0mOA4myQtygNIrC/Ay1/3wYnovreZ08A83NaDrgrY4DPrRNzlas1IFqLb6UZvY2zDWVSavdliUAiwWWmHgpF5Mx3crnEUUnUvgkRg3mjMIqKvIZyxkLh2iN8rB3ZPuQSBnozO8aVUkKaAroXG82lFtJimRW473p/fGbLtSfl9ndBBJu4TwwS37hLKP20GZO148oh4rXdgrUNDLiJ1Zor39JJRf1qW1j//HAf1/aLZUIbbQeNvliLi9o6z9saEQ7t3TYBks4vVrASMWEm7IQTaiWbzzQetZsp9+hw/8f9HCX7h9HiXxYl9mmSodDWft4uHzTVTmhZkLc/qQmRaJZX4qK/cdZxtyhlqUEwSkm4emLrks2hkzvkox9/doU3tp7Ok1ay6TmudMdIkabMvVO9Vhx1p452DUx7IoMIEhavDBrCDtRdblWpswE+zedBgOXaBe9rlaxXY0sJ6JCewovInuWVtBs1iDsyzrJXjbD+kk0M6dWIhxsEjjQDpTDwBz8e+Xv8pvgO4a6zAsDlfnOPu3SKLx+H
 mTNe+28B
 6xYEjl2Lj51THIqqsML9q1LB8X6cx/bxwGg7bv1abXijWJ/7WUyenyYl4cI8sQLPvPoBcTAFg0rmYwC+Vqj6d9nMO4WN9/zoTY48CuGIYSXC02mQWsIcUgXrFP1QhshWozkuMO7R3NxmGjB5BJACI3Fcypi+YYPMsz+NTUnt1AHbkwRikLRrG6Y30V9V86DDfXsaqnGLZWiKkk8M4iSz19XKwmBc754gnZC3Z2UTewUzZY0cIG0tWxlTsLiJjjutiq94VjSnwBA+xSbk4fHvovm6Dg0lfEQGnGMuwh93fB+eTStmqeITO+zTQGGFN5S5TtQgpowucM1fmGA1WcFGo3iW1/0sxRwmfjj91EnrVdc/bJWaZ6farUOa2NA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert vma_alloc_anon_folio_pmd() to pass __GFP_ZERO instead of
zeroing at the callsite. post_alloc_hook uses the fault address
passed through vma_alloc_folio for cache-friendly zeroing.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/huge_memory.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f51c0841ce91..3f2a868cf9e9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1256,7 +1256,7 @@ EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		unsigned long addr)
 {
-	gfp_t gfp = vma_thp_gfp_mask(vma);
+	gfp_t gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
@@ -1279,14 +1279,6 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	}
 	folio_throttle_swaprate(folio, gfp);
 
-       /*
-	* When a folio is not zeroed during allocation (__GFP_ZERO not used)
-	* or user folios require special handling, folio_zero_user() is used to
-	* make sure that the page corresponding to the faulting address will be
-	* hot in the cache after zeroing.
-	*/
-	if (user_alloc_needs_zeroing())
-		folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * folio_zero_user writes become visible before the set_pmd_at()
-- 
MST


