Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB07EF8FA6C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 12:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31D0A6B0093; Tue, 21 Apr 2026 08:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CDFA6B0095; Tue, 21 Apr 2026 08:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4036B0096; Tue, 21 Apr 2026 08:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6FD6B0093
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:16:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB021E5B67
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:16:52 +0000 (UTC)
X-FDA: 84682461864.14.8CEBC61
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id D5F78140017
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:16:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KTZrPZEz;
	spf=pass (imf09.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776773810; a=rsa-sha256;
	cv=none;
	b=3mm7pfS9DcvkmU4TnAsrbzHj25Xv+QvKQ6mScWJSiMKiiCWuuGLLGdWQDYU0NKbdnoayUb
	tvdKEeg00imO9wzFY5qreKBTYnnT3hv77H8ztwq+BNUoM8D7Ur1TqS9aAFIeHEtpsL4SZ5
	fMO+AH8iNfhrQrvCsOOX9IdjpYbYcPQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KTZrPZEz;
	spf=pass (imf09.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776773810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuBH0tSA4QMEqer5rgkERxzfsnQAmO+99E5ku8qz2ok=;
	b=n8rX1g6KI/OSJkgtn4dn3Sf+lvXPsCRnXxQp6YJbBNkOYhqlvYlPYhI23DRaEuAKKKqnYY
	BRCv/p+oV/n9ZJKbpD23S0Q4yWVHsxbvrMgedvV+jo4mwqsjzpdYbm/TwGmbNHS+ovNMbv
	gdwfjx8W3rynvurU349IzIkLxtFK9MU=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82f1f6103afso1882051b3a.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776773809; x=1777378609; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FuBH0tSA4QMEqer5rgkERxzfsnQAmO+99E5ku8qz2ok=;
        b=KTZrPZEzcyPC99fYh7HIlv/Vo8OVECeHLCv+NTcx3d2TCP6DKS/MWVNhQWY2BLcZYH
         IbkYTUtS6PeIwA4sUgTKLuAQi+/qGdxuvL7yp4b3777kswhIyGIxZrM2Ox1tkSWCJIO6
         M3R6tbwU1r9PAwjNWHUWQlIVZyHAiYAs7brp2gvQF7i+7p8WfeZdG9ACJLDUekHEODm0
         jLWqu+UEwEIMR9vqX6Ixywwuz12EyiTvFUtAHIqGUC6jHyX7uOAuaCuFnRfijdOUguQY
         tvfgv/91CnmCdKKMHE+4i1zrf+np3YECD+qYTFJIlad/0sx2qS5W/V0JejnYlJjmuKJ/
         i8Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776773809; x=1777378609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FuBH0tSA4QMEqer5rgkERxzfsnQAmO+99E5ku8qz2ok=;
        b=YnHdiS/Z10Z0XNjPqaHRjRHWfEKoNCOWJdjovCJlntBvFipVl3zNAwaBNhFU9lIQlI
         NUSXzKmoTfv8BW3vJVMYJNsR24MtEcfkyZZNCONxSoGakeI7UtL8sxfdELgj17crzXXQ
         aMCJSPELV/kbpu2JVBXT15zZwfvXy1qJ9xhBRFIC4cVIkSNrzlwotMMED+T1dEP6gYyq
         Uki+SGU11JXrF5uOOpJU2/BEsMPKEqF/dNUCh4RXK3upHtXYXBB8DPf9E3cmoIvjk8pY
         /DD+gcF3cVWiYIRpiBrg9gGFROgCntXk5jIgfBKIo4ej9Nif6MfnwcLDQa8Kys8nrdVY
         eawg==
X-Forwarded-Encrypted: i=1; AFNElJ832TOjLpVys9MJULBQVFmJv/UMNIOXruuOhUIA+NDop2wFrmkpe2vN1xiLs5bS4ev0sOWiFQqIHA==@kvack.org
X-Gm-Message-State: AOJu0YyFF+4Mhf0GXwteHfP5zjUhQAbnDjUBrXzrQX0H74l9p9ClsMK/
	Ir9Sl3fw/9ILIcDh6pNDKySyLijGS/yNWKqGS/k40QLpUYCIFCOtRx3H
X-Gm-Gg: AeBDies6WC3LQtmH1s1Khf/v8z8IxelxbLYtmbGSLR51qiXXehDwrGZyq7H/ZE4iMAk
	1fdLAz+5fFSkZZJ9L1KGT+bgiImaz+VUQoqfVSFPzZGOXOGqQ1x/R5c4VsSigzeqKIUHKcR9OFr
	LqPyRd0VD6JKiXQQiuhSgPN2ATNZjHoNPl6XMcMLkSkkXnjnSIKfJOnLQj7cIYL/mgmlIdvniS9
	0pcxrnOhV9moUC//iF5eWkfXv4Yq5hKGwgetGcN83a+CU8OxzgBg+kSufaWQOTpDXcB8EyT7/R+
	c5IaFch9cbO8Mn3r28a0I4W5iKPNkWqOf3vzBaVZNrWWaHJPNLHSH7AQS+l6Ye2tcTIjYzObONj
	aREMZKbjB+mOEPeEwCKZz5iDOZiT/ZuUSfjDsKtQ8ddnjPVlEVWc18+vdFd50uBaQhHpdPCa05Z
	Zos8Y97k9j4abxamlEA/mEOt1RMF9O22/sOYI7PnLpM5zVaZY=
X-Received: by 2002:aa7:88ca:0:b0:82c:d9d0:f482 with SMTP id d2e1a72fcca58-82f8c976ff1mr18659748b3a.46.1776773809369;
        Tue, 21 Apr 2026 05:16:49 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec037e1sm16371071b3a.54.2026.04.21.05.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 05:16:49 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Minchan Kim <minchan@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Barry Song <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH v2 4/4] mm/zswap: defer zs_free() in zswap_invalidate() path
Date: Tue, 21 Apr 2026 20:16:16 +0800
Message-Id: <20260421121616.3298845-5-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260421121616.3298845-1-haowenchao@xiaomi.com>
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D5F78140017
X-Stat-Signature: fefmdhxu776r7uztpdokz895ke11dqyq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776773810-106906
X-HE-Meta: U2FsdGVkX19meTcCZREggZM5437NI2KKZ90ZvjIbg6XMaeaPKhbqEkzp2vYIZ/gA35UZ/tkOkXx8Vt+iPecoGQq3OqbkCxwG/CXUrNsP6XdmJI7Tpnulx/iuENEJ57qLZiH1PK6bXIVmfqJaHP12xsYD6RsT2pcSwcJJ64JpszDYEIIkWgcbrPVaexBtjPHHgqFPUD2PaE5Wvi8sjwPKb2qA3WD71YBYq3YvQMs22Vh30Xst1ij7Z65GjtU5dd3NVohY/IqFemMLuEiDVxGWRGzIm0fjIHueTCbZ6LVOhKlvBebL/yphIslSSr5cxiWoCeCU2lP62uvah8R3HBRP8RNx9vvMzi2DstoA3K0w9ZejIYUqJwlUzPucfsqaOtVyswS8IeiqA5R02fv7KQha9EBCWWHJpY6MmHxdbaX1XKNYAlAiljqZbtAmvhV9XHEnlcBEhW7tUl9HiEosuUSisT/qsDbXwdTFfAvl9NDSV4Tfd4DzTU1gmX9lMCZ5AnJ3BBKTC1zOpvzummtyIa3VcoYFJFKcFRGqR3SS9FhK4zDb05s92lLygMFz9MNZm+LFye8GxyNwdc+z+jrrhB+TslG8ZWSIw2zsE/NNOuBd5wgwC62E+rhqr4GtulzESObTm7YdXtDF2mk7VODLAtN6kdS6DkJCTjv4xHiho0s9Yq0Emo3j2HVZH/qvL4xuYyASQ+oIBLoLhurFwTdKnsA4ndR02fWm1U4oLQvXrt0BK3jYVxMcgnpqc7Y4jGu0tmVm4K9eFIeXkuWtZfPIBEQPGaZ15voKsRnNAIg+wo8NZIuxK19g8lUanc2dnoBWnxbpNl3QrIMqbPC1NvVBts1kTTwrCIj0Bdo3B2wuUVQJemvrXM3gP6JFcuQj2MtKFlBXvmE5ueEvAYeGjNOAgoEw5Ib9Q4sjFZhzzOSdzZJFWl1sB2ud20yLj329K+rqcwuMIRCmM+aTMjdmCMGdH02
 /cDaox3w
 jx7uUhBttlUommCSj3JyfAc1IoBBHSI2vC2DNp4v0uE+xpOU2l/JiKodEldv7+0Y19YvTY1e3TP3h4trLh4NhdeESzEzuEMJSGGulIuZQ/gxOREWuAiHTIuA8EmU2FJUCWYZgGByAWpBvVal96QZxiQfU63nHFP6KPVXDMvoA8hTl9vXHmAVWyGG7ZSpVAvE7RC0CmwXNrGL13y5NfZUuliSSW+pX8vZh4wIwq3PGGAA4M74J59y43MeD0owK2aCGoR/MUd0yVyidnouTiS04GoZuhVhbROcQjeh3MdYcezB8CDLv9lvWc+KbNe0qMnI83OvlcswEHGjoNv7FgkggBMKHMOGTUTEFrZx7Bpxk7ZE1CA5IsWjud+qbnjlQ/p0bN5vbE5OGAodshTkLwMcgk5oFSDQkpdzllV5mt2sIadWdTGcg2Gw+TxUpca4QAIaepDwiKi9QLGQtEKLbdxAHuHlmsfMZd1isHpA2RL5sQRQp3UI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_invalidate() is called on the same process exit path as
zram_slot_free_notify(). The zswap_entry_free() it calls internally
performs zs_free() which is expensive due to zsmalloc internal locking.
Unlike zram which has a trylock fallback, zswap_invalidate() executes
unconditionally, making the latency impact potentially worse.

Like zram, the expensive zs_free() here blocks the process exit path,
delaying overall memory release. Additionally, zswap_entry_free()
performs extra work beyond zs_free(): list_lru_del() (takes its own
spinlock), obj_cgroup accounting, and kmem_cache_free for the entry
itself.

Use zs_free_deferred() in zswap_invalidate() path to defer the
expensive zsmalloc handle freeing to a workqueue, allowing the exit
path to release memory faster. All other callers (zswap_load,
zswap_writeback_entry, zswap_store error paths) run in process context
and continue to use synchronous zs_free().

Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zswap.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 0823cadd02b6..7291f6deb5b6 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -713,11 +713,16 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
 /*
  * Carries out the common pattern of freeing an entry's zsmalloc allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
+ * When @deferred is true, the zsmalloc handle is queued for async freeing
+ * instead of being freed immediately.
  */
-static void zswap_entry_free(struct zswap_entry *entry)
+static void __zswap_entry_free(struct zswap_entry *entry, bool deferred)
 {
 	zswap_lru_del(&zswap_list_lru, entry);
-	zs_free(entry->pool->zs_pool, entry->handle);
+	if (deferred)
+		zs_free_deferred(entry->pool->zs_pool, entry->handle);
+	else
+		zs_free(entry->pool->zs_pool, entry->handle);
 	zswap_pool_put(entry->pool);
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
@@ -729,6 +734,11 @@ static void zswap_entry_free(struct zswap_entry *entry)
 	atomic_long_dec(&zswap_stored_pages);
 }
 
+static void zswap_entry_free(struct zswap_entry *entry)
+{
+	__zswap_entry_free(entry, false);
+}
+
 /*********************************
 * compressed storage functions
 **********************************/
@@ -1655,7 +1665,7 @@ void zswap_invalidate(swp_entry_t swp)
 
 	entry = xa_erase(tree, offset);
 	if (entry)
-		zswap_entry_free(entry);
+		__zswap_entry_free(entry, true);
 }
 
 int zswap_swapon(int type, unsigned long nr_pages)
-- 
2.34.1


