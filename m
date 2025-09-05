Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FFA0CA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DEA9900003; Fri,  5 Sep 2025 15:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967B0900002; Fri,  5 Sep 2025 15:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8091A900003; Fri,  5 Sep 2025 15:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69190900002
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:15:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 369121DC8C9
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:15:20 +0000 (UTC)
X-FDA: 83856150000.29.A29A463
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 45E33120007
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:15:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZXwstkdM;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099718; a=rsa-sha256;
	cv=none;
	b=BpQY8MyJjCDv8lMxu3T2c7jaicWfK8BBSi5fYzCNEFqGn/7Ki515PIkldfrGGE6Eb1qupt
	EWzr9eGfui7ExtabLcD4OTmeMfM45y4k+AmmvBs1HDP1f9TMooN5KIgQWza0s4LnZxtJfj
	XAooT8J4wa/iQeCnMWPH1NSvC4EZC0o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZXwstkdM;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099718;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9s8hZ7R4zViy+wFgr3fw3L0ssVquOrWHeMQPoSASmCw=;
	b=s/9885zmnjDhVlmdyD1wlj3fX7TN02RzXCtIAER5EfK2rVBOk6KU33KA89RIL/nj1A/iJI
	wA+/JSYrzSKXjMVa9HCgVNrUYKPR4+nDhaDUTTqeM8xUkNzB+flqujtpHpUClBbzpOW00D
	wQnTmhr0CfchWPeoRaxfqxLF2IbzF68=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b4c8bee055cso2086229a12.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099717; x=1757704517; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9s8hZ7R4zViy+wFgr3fw3L0ssVquOrWHeMQPoSASmCw=;
        b=ZXwstkdMoqtLkm/73QFcPfogoIr7fW4TcnDFGbzbnrRNkNcPQ8NdWF1kkbEdJk6qCL
         y19r2I2dIX/9ngPj1eueJMwN4hHZEiqSK7alJbP+vL6MkGeovLBqy5/hqMt79MFJZcLb
         r3+qFovKIzHtVBis39MQElnCTH06akY/qGSmnZoNTy1CyNtZ62e1avVqJJRQY2BrxVeT
         H8/HNYz/98uxb4gPNnc644Q+oluzfVIr5Q6GurCu4GL8tt+PaS++G2IsOF0Qujf998BN
         xhKEqa+XDlfQBFUYryDs6tRLhCbHZG1lK9InP4lZHXQ5L5sd5HlV7bz2miX477qiHDDj
         uYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099717; x=1757704517;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9s8hZ7R4zViy+wFgr3fw3L0ssVquOrWHeMQPoSASmCw=;
        b=cjhceN3gopTCejtkI0ynCZsD6hXpLhPo3hkMVi5NZZh6ZjI2whUtE8h6DAlE8AeEp0
         EozlMv16eZyLvLmjgDkOFyddSfCgWK2vGt231GsS/cu5GfG+Jetyz0da/43H2vVC9Lzg
         FSsUOAYoQoRDa0fqYaC8x56M4Fq27JDplvZekNZWBUj/XcdPWMd7P2WNiwc+9HXMlIkv
         Z2Dj/rd1SbMfk5UEP9jJelmBXpCBIVqvlHM2WRxbkUC3irk4i6p1C9rDwU49IlDW9j1F
         LK3+hc03ko9Cd1/AL+prM5ZMLbAIxVdgWNoBqpsjnRyvpp8oIXDmtSg1dvggSKZhD4oz
         NUYQ==
X-Gm-Message-State: AOJu0Yzojp49ZQDsdDjrJSMkBhwknAf+mTMFYkCpZlkk6X14J/44RkJa
	t/LShpFU3ukcw80th+VQJQKPM4qRcGBEk0bs4KokWaCdnBJ6jjezErJYJ0aOGkc1QSM=
X-Gm-Gg: ASbGncuKT7+mIw7xTzCFj9WRHYC8GhW31wrlJRGJRJ3PYbGlxn1kkY5V0PE26MFHIML
	oZl4HD3XoglAOpUkyM3Ev7IXG/QDk8n6Z9DVbPpna6Q3YZJ1WTx+Ds0xMGjspX7NY9zu0OEuSjX
	Y1TEfNwN40XmctgKSjlzwfsBRAa84yxO+j6RGA5NZsUnppn76bA8hwiKwPp6zvCiQBgRp+efOlt
	Bls1RkR0TgBzpm8b5tdLPDxZd4r6VYJu1Xdf3Hz7nY0JbSm/kbSwC3S3YSVdng5GVg5B5ZDNKEl
	kUhBIxASh6ctR6AlB5Ym0GrvIwdHy33cEAJf2wF1WbfJVer39MLGGykvv1rvMILG0P8HbzCKf5m
	wWDnT0kG8Dk8mnG9reuegUZOUcEDFIgRq5ye6SbPlWU2XTxwGH4SWDLpMZ8GTsgMTLkKh
X-Google-Smtp-Source: AGHT+IEd9Oqt6BI578NyTBpy1CqRprvjkInlPYYiEsPmHlAXqsCDTLDSG3bcASc0W4CS/dAa/N/jHw==
X-Received: by 2002:a17:90b:1802:b0:32b:ca6f:1231 with SMTP id 98e67ed59e1d1-32d43f05005mr15140a91.1.1757099714590;
        Fri, 05 Sep 2025 12:15:14 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77256a0f916sm15871442b3a.63.2025.09.05.12.15.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 12:15:14 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v2 12/15] mm, swap: mark swap address space ro and add context debug check
Date: Sat,  6 Sep 2025 03:13:54 +0800
Message-ID: <20250905191357.78298-13-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905191357.78298-1-ryncsn@gmail.com>
References: <20250905191357.78298-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 45E33120007
X-Stat-Signature: 3qrbjc59x47qgbgnb48xsmtc867s5k6u
X-Rspam-User: 
X-HE-Tag: 1757099718-557878
X-HE-Meta: U2FsdGVkX1+GbsdH0G+gr8FgIU5YD5FfgOVmuuJ1dzJuknZCvHhozuMMiWU09XtyI8xfjBsGD7eTkJjP3/KAGYT46gp6agkELusiewgKBelGIB/lC/rnRFj5M2VJYQhmTiKkqSG8ILJICh+68ZnOeB3vA4+Si4xysx9v3CTa+mUFghPyrs7T4mWpwKuHGlGWxCp9gUxljUem7Zcb60PON6k6O2CMrXBkyBiwXA+Pr3cOus/bPqRNjWszah1fwWAmbexAUP/A7UfAqNkXPidg640Ru28tTvtYT87zapo4vgOlnz8N3ixGRRruXVPbdkSG91+Qp7KzFQIlVKDUWDJWz26FWqURzGYua7zbmJxSGm9hE/8Fc26aZQgTlJzsrGNkHj8Q4sxkqoM8QkN9aNOwj6aDK5UmHhak/yU7JYNdzz/3Sn48Ovnh3Nt7mhrcjlaR4VYEx2ai9E2n4mBf4R7+PdK7/6bSIH7+fMtQD2fNGqfYgUJrLiuIoj2m2ErtrK1oneSul8KwR7l+6+rEwW25O+xA1mvEIObZBnvonV9p6sSl+vJQS48YyiJMCRitNV9p+/RfXVc/m8J7FN8KUksPrnw1y92Q5QOMFIhvoXbkXK9mqm9/JqYlz3CE02RwaV4XDZZoobPDySB3/jGst0PSvopCAo2kPNWx15NEJG1H6eInj5XxpwXTaelneMnuSzsXoLtjI4rP4UYg8ciTx3fombnMRxASCSMpRFVX+HgrsF0PRvrf1ldpFUnLe3+XESeiGl6qXKy4nOh6YFx0HvR7cCzmddbWtFiEJlwRWBasy+2xn1up+bcBLi0eeGr3oajTEP2Ry96Rf4r2bWFlorUhRNuESlrG8w845NiK1E/PJMB5S3KX6RygHxO1s3H9KMzmo6cQiJBEz8gIKUtoRv+vhYrxIYrY0KAuDrWhT26sMOLeTCuDj7/8UaKAtsL8H6DZXhPNzF7nY4OxWIbRPmA
 Vs/vaOoh
 RxcSHdOBOAOPu4BHzjthE+kywhZhbdWWn6ge9NYBAZmFgo5X3yhrXSIQ7dLVYip1N4xzo27JBx6HKgHQL4qNp4g/yZUzTDuGXA9nk46CMnx8BKlVGOTfpJiDH9OO9VDSDFgM1BtfCuBE+M+WJ9rmlhViEMJxLptqD9hDwSirelFNe3uo7ChLOxu1jvXVE63WWO/NHRfXJE9zd6MwSJnm3/tvxd5ebJF144JaHTDj+ItA9rDPw9pHF4qR/KT93aVsiKdRXGDpB9zIliClZpASYh5vBzipnldh3gdqygkzaSrmPrt8g6G5JK2Au2mgy2nahRBlIpSfrkD1avmSVhtmc0mT263LFnJaXGtoFv2EiLREHThIAuoEmzjUAjMCJPvTektThQBOg+rZpFlcP2J8yN4GXhnSe4tBd1YLMtOGqK1tpBOUsio1Y/xiMM7IythLJXsroKv2iPBMHha18bDIxoScrzh01T6x3o0FRGtzEykfX/X2tbD/desf1E03YMfQnB93cMnXYbnm7etZwyH7AyJe72o89RRsqdClEwWLW2jER9lzxGin6/wbQe+qRtXqCXX/twyoV19cN1a0d0rPGURUSpeiItgxgLkAC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap cache is now backed by swap table, and the address space is not
holding any mutable data anymore. And swap cache is now protected by
the swap cluster lock, instead of the XArray lock. All access to swap
cache are wrapped by swap cache helpers. Locking is mostly handled
internally by swap cache helpers, only a few __swap_cache_* helpers
require the caller to lock the cluster by themselves.

Worth noting that, unlike XArray, the cluster lock is not IRQ safe.
The swap cache was very different compared to filemap, and now it's
completely separated from filemap. Nothing wants to mark or change
anything or do a writeback callback in IRQ.

So explicitly document this and add a debug check to avoid further
potential misuse. And mark the swap cache space as read-only to avoid
any user wrongly mixing unexpected filemap helpers with swap cache.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h       | 12 +++++++++++-
 mm/swap_state.c |  3 ++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index bf4e54f1f6b6..e48431a26f89 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -99,6 +99,16 @@ static __always_inline struct swap_cluster_info *__swap_cluster_lock(
 {
 	struct swap_cluster_info *ci = __swap_offset_to_cluster(si, offset);
 
+	/*
+	 * Nothing modifies swap cache in an IRQ context. All access to
+	 * swap cache is wrapped by swap_cache_* helpers, and swap cache
+	 * writeback is handled outside of IRQs. Swapin or swapout never
+	 * occurs in IRQ, and neither does in-place split or replace.
+	 *
+	 * Besides, modifying swap cache requires synchronization with
+	 * swap_map, which was never IRQ safe.
+	 */
+	VM_WARN_ON_ONCE(!in_task());
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
 	if (irq)
 		spin_lock_irq(&ci->lock);
@@ -191,7 +201,7 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 #define SWAP_ADDRESS_SPACE_SHIFT	14
 #define SWAP_ADDRESS_SPACE_PAGES	(1 << SWAP_ADDRESS_SPACE_SHIFT)
 #define SWAP_ADDRESS_SPACE_MASK		(SWAP_ADDRESS_SPACE_PAGES - 1)
-extern struct address_space swap_space;
+extern struct address_space swap_space __ro_after_init;
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
 	return &swap_space;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 7147b390745f..209d5e9e8d90 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -37,7 +37,8 @@ static const struct address_space_operations swap_aops = {
 #endif
 };
 
-struct address_space swap_space __read_mostly = {
+/* Set swap_space as read only as swap cache is handled by swap table */
+struct address_space swap_space __ro_after_init = {
 	.a_ops = &swap_aops,
 };
 
-- 
2.51.0


