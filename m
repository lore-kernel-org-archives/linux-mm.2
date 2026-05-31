Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC91ACD6E51
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 05:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB086B00FC; Sun, 31 May 2026 01:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7212D6B00FE; Sun, 31 May 2026 01:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E296B00FF; Sun, 31 May 2026 01:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2CEE96B00FC
	for <linux-mm@kvack.org>; Sun, 31 May 2026 01:58:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E991FA0388
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:58:37 +0000 (UTC)
X-FDA: 84826660674.11.1BE12C9
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2A1A6120003
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:58:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dGaKCoGi;
	spf=pass (imf29.hostedemail.com: domain of 3Cs4baggKCG0UTLbTjLYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3Cs4baggKCG0UTLbTjLYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780207116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZW1Swft1eWJtZExgmIavtPOzBDQuGx01Vq9nniKO/I=;
	b=2dQy3v60O687FpeBT2Wx7D07rNgmRkUGMgIXlDnjni7rVBxVhYUovNNyi1N13OdnpUsaFi
	NtD1UqCO+L8JhCgUxoOweB0si7+qj+o74hJEatIX7fpRKFPPkop/LpOOqQCRDMVUWG7jNg
	zxJIR9Acks3LoJTLUKh3hGipyO89T9o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dGaKCoGi;
	spf=pass (imf29.hostedemail.com: domain of 3Cs4baggKCG0UTLbTjLYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3Cs4baggKCG0UTLbTjLYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780207116; a=rsa-sha256;
	cv=none;
	b=y0JGoQC+HZ/+rc82UKIdwMm0xGG1MRCvfpebfSF+nH2fshP73tEgJIf7Ru+PuvoVubDM3Z
	fHguj9PR19RqDXmwksEC53vqFH1MO26mzneCPCL4jqupgct9e5lt1kkhXtJXrOGTR5MHq5
	4UhRPpLbE1/Q6fZ2O+gvSq32jzxL/jg=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c0b35fa876so6520375ad.1
        for <linux-mm@kvack.org>; Sat, 30 May 2026 22:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780207115; x=1780811915; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WZW1Swft1eWJtZExgmIavtPOzBDQuGx01Vq9nniKO/I=;
        b=dGaKCoGijCs68hUVNYGT83sBS07PTNEUGBTu/ttdjTktNcVLNCZy11P4pFEqqohT+7
         jeQKPHOBkOFpLSKIt8656xvX39AZtdtdookndxGeFPp0ymC7LJDDbqruRXje8pDK2dIe
         F8w52hwlbh0W1VJOnKVUrX7J44L15pcrLSARaXiWzumond8GFLnPbQmnpq8jUZSAsx4Z
         Ukn51kVjqZNkXxQ8FigNCi1uqw3U++hgpBCoDGO+1cXFSN7YGMA8aoa1lvxUn30j5Irg
         K60AuU1fWbPSgdqLRM3SiX8qn+oAGtrZ1rFF1Z7pPD/IHBhoVJjJ/YsxEbh+6cOVqmNh
         idaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780207115; x=1780811915;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WZW1Swft1eWJtZExgmIavtPOzBDQuGx01Vq9nniKO/I=;
        b=L4KcIucM3vOfNmq5zt4Mg4L2aZfreYtQywUx9spmzxty6scOL8Rp+4Mhd+3/veXZhg
         ddFnKq+qQ/hxMO/jlstWM0QTO1VAXTxZA0nXDr50ki2MdYJz4F22ZtQotmmwADbrjvGk
         60paazlRytnG8wKObcUq2ovn468n7ohrcFO4zZCsTb86HX6+PzAsfPlJkzWoSanmi9ta
         XAHE2nWldS6dftJvsaB5Xtq/1biMc5YLOS4qh7F4NTTn0XCKlPBpqtv5ewd+ZXW1CfDh
         7H5zE1u8U0+0V+pwKRxc4k9T1IvyNz+rIMp6/WM2CupBziFa3dhb7qS7ggYt00EIBVrH
         1i8g==
X-Forwarded-Encrypted: i=1; AFNElJ8880D2zXDl7e2anrX0yUuHoEcEmL0e9fnguaIK2O6FgKxTODHMDSgCu/ZORbsH+DyoKQKnK5PhBA==@kvack.org
X-Gm-Message-State: AOJu0YxXsHk6DSLnTgWlv8rnKmVY2mQdjUWlmlT250gQ8k1MZR4iFHHO
	KAcKCFpY3m+n0MoImHDkyqB2aZ2hiwXEOS5GxUWBc0j/dJjSzfa7CUlsWVYiF+jjeNME1VcU8Y0
	OttcG+4ZnTrHGwA==
X-Received: from plbkn8.prod.google.com ([2002:a17:903:788:b0:2bf:20bc:ee77])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1c6:b0:2bd:9c0a:32c with SMTP id d9443c01a7336-2bf3683b78dmr65642835ad.19.1780207114820;
 Sat, 30 May 2026 22:58:34 -0700 (PDT)
Date: Sun, 31 May 2026 05:58:28 +0000
In-Reply-To: <20260531055829.3636554-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260531055829.3636554-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260531055829.3636554-4-jiaqiyan@google.com>
Subject: [PATCH v5 3/4] mm/memory-failure: skip take_page_off_buddy after
 dissolving HWPoison HugeTLB page
From: Jiaqi Yan <jiaqiyan@google.com>
To: ljs@kernel.org, linmiaohe@huawei.com, osalvador@kernel.org, ziy@nvidia.com, 
	harry.yoo@oracle.com, willy@infradead.org
Cc: osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: bjyo8ej1pg6bckgngo7t1bmc83hmfxyh
X-Rspamd-Queue-Id: 2A1A6120003
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780207115-795159
X-HE-Meta: U2FsdGVkX1/iwNiX5JzHr40qL374Kfd+FoVTeEPbOFyH7vFSBGz4U3Pr7I9nPcdP4dam8C45r1XEZMAlp+q3tnVZHbR5KF/XgolzqYjZli2kVXOA75mIs3vvk568l9/JBJFYYzy7Cvv/Of8xVXJm3EK5cqvMrYt8yCzST72KCKMjbXsJMIOoWLNragXt+bc3lEGfQpfRGxTdIE6h+6KVfK+fQy1fqPoFCQjwQ+JCXgDs89zRJze+4BunDNLYsROeNPfbNiuKTvzbTFeGbSw1TOKLGO678TAPbjuptQp4+dO4MG4oTRFZ3sHvEeJs+uvLfzoTubxbpiG4xWuQM4TnGR/RWtZH3oNguoadrp53F7EEsXIp4VjjFShfHeRhRsZTjTcXOP04AxMXVtzvsgKQALDde9iAY69f5GlqqzGQQRp+HRARNChj7JXDiaLt5KlPe6gT7KjK53NN0xebIM+bxjhNRYpq1dlTjsGDq5b+FZ0mZhq8Pxllh6Oov8u2f4NkE8i/ID/Fvs1Li5R/hKNo7C4MrfATrUN5StHatY45OA6gu2/EpNZaZboYUWfYVEVlHbS+3bCeiCqrzcmiXSYAKAjTBeOieAtB7Va4Gld6Fy5rtaGubmWJgO/KLdif+4UffNC3RHAACO1mkrZr0bsfII6RL2tSzej8XQfNyz5HqBnk7w5T7etluIEdk3nCTTkTwnrQBw1HgZVB9XalhM2HaFxqhvRmcOza7F+Tj44njid+ziqAC91TEQCkCo3s2kPOWAo87O09d2hj4shBIr/3tw1ldssGBx5m5Zhj/kQKbuj14uSFrKvuwddMdV3vbBhiGOasDDJBwXGfMxtu/nxLqx3aTMZQZIMp2gZyCpPePX8pidxL7q1gmvXo+fyrNtovQ0of0eLMUGuqIdlo85/3XBVL/Zadgcz8fH/8CM7AaZ6yshZi6Ppop4muBTwLSAM9tWaKV+ojhMQtRM/7cNN
 fzyN6fgl
 VS7lLG2Ofo8UilXq2ZpH9qiyRCG7FkLi1WmfQp81wBxj8D9y/wxziHd6S8BBjVwMH2hWhJh2gzyNMQKkgD323RepRQccnMjL6VdaCABqvpAyTl0nJExy7hCBwpFyCpQ5h8pTLDsjRLE82wjDzwmO8cmnDO4HU0H42/r7iJfeFfEsJNXQEct0aATxiATr3MkfVkuWet1iEQNMeEMo411+A7Qh7akF7UJZe4jjjNS4IdeF9ScCQOnfMHkN9JlCe1z+PHEYAgsKV0Vp5OWokZ1/eEQfe4K7hLK4Yp00Z2awBJLHM0FNMXk/ol71PXMSCSSmPYTTs9cD+PN8P2uJZZ638WzBXkCEOvYkuvSqDy+fPbntsu5OLGw7DvyPAylaDv6P2e9tBTC4P2eHM3FVINr8+tHPpKkEeBd7SxFROQp0etUuXSDuUZih6tbaD76t5oFSvUnHFHMbYToSHjuxjDBWNTGzKp2JdXqfFEo4blQQMqDDWdZuMaTSihNGZhT0NTIzbxiZi0guufRTMSKvLqR0O8zOG7hAraPF00G8FnUwo8V70RlcppWg6C6qr0FU54QQ92tac6G69c5dxx65soh2Jq9Ug5lcjy8z2yUO0VxglvlvY2DOZBife3wXJCE+WIxoDxmuQ/o5OFnbTbG3RX7KHe0Dkix9WZOq8iXRxmvjrxiYSc30=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that HWPoison subpage(s) within HugeTLB page will be rejected by
buddy allocator during dissolve_free_hugetlb_folio(), there is no
need to drain_all_pages() and take_page_off_buddy() anymore. In fact,
calling take_page_off_buddy() after dissolve_free_hugetlb_folio()
succeeded returns false, making caller think __page_handle_poison()
failed.

Add __hugepage_handle_poison() and replace __page_handle_poison() at
HugeTLB specific call sites. The being handled HugeTLB page either
is free at the moment of try_memory_failure_hugetlb(), or becomes
free at the moment of me_huge_page().

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 mm/memory-failure.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 95979b7995c1..098c4407e818 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -163,6 +163,30 @@ static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
 static DEFINE_MUTEX(pfn_space_lock);
 
 /*
+ * Only for a HugeTLB page being handled by memory_failure(). The key
+ * difference to soft_offline() is that, no HWPoison subpage will make
+ * into buddy allocator after a successful dissolve_free_hugetlb_folio(),
+ * so take_page_off_buddy() is unnecessary.
+ */
+static int __hugepage_handle_poison(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
+
+	/*
+	 * Can't use dissolve_free_hugetlb_folio() without a reliable
+	 * raw_hwp_list telling which subpage is HWPoison.
+	 */
+	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
+		/* raw_hwp_list becomes unreliable when kmalloc() fails. */
+		return -ENOMEM;
+
+	return dissolve_free_hugetlb_folio(folio);
+}
+
+/*
+ * Only for a free or HugeTLB page being handled by soft_offline().
  * Return values:
  *   1:   the page is dissolved (if needed) and taken off from buddy,
  *   0:   the page is dissolved (if needed) and not taken off from buddy,
@@ -1166,11 +1190,11 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 		 * subpages.
 		 */
 		folio_put(folio);
-		if (__page_handle_poison(p) > 0) {
+		if (__hugepage_handle_poison(p)) {
+			res = MF_FAILED;
+		} else {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
-		} else {
-			res = MF_FAILED;
 		}
 	}
 
@@ -2076,11 +2100,11 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 	 */
 	if (res == MF_HUGETLB_FREED) {
 		folio_unlock(folio);
-		if (__page_handle_poison(p) > 0) {
+		if (__hugepage_handle_poison(p)) {
+			res = MF_FAILED;
+		} else {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
-		} else {
-			res = MF_FAILED;
 		}
 		return action_result(pfn, MF_MSG_FREE_HUGE, res);
 	}
-- 
2.54.0.823.g6e5bcc1fc9-goog


