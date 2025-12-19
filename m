Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04682D7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B5F66B00B3; Fri, 19 Dec 2025 14:45:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662DA6B00B5; Fri, 19 Dec 2025 14:45:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 564F76B00B6; Fri, 19 Dec 2025 14:45:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6756B00B3
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:45:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A6D916038F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:52 +0000 (UTC)
X-FDA: 84237250944.18.834895D
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2451E40014
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nis3pxHy;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yhrT3dYvAHuR7z+x4zbB6DCnVKLKVvLlBLpnRsQvASs=;
	b=HcC5jDEzhUU3VKpF73yCgiRQsvhctupLPZve9dTTZ8IkLWSb9xiZVgv3inZD6DQMLHzU5m
	W/shM7BilbEuQI7Sa2w8p7FXVGU9OQnh+G+qzz18MMth7aqeJ67KG0KfbK2Pbbun3ycVW9
	iuQ2e4TEQciZmGnEM36H44ZUVV5RlPo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173550; a=rsa-sha256;
	cv=none;
	b=fNH1ZYVFAjLV3JvG8oBjWysVM+X9UdgJse5DJ6pewJ4W3makcgxTIJiqKPsAvblbZPaGOg
	ttRy8wW+p/5gMM+EpwP5GjqdQ9Odq1tj8GCza7Y9vZFDzhPYRLuAdmebj4clJVeRGQeFkT
	fUcxQ6eXHEhTz5IqkzZwF8u0k7WeMm0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nis3pxHy;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso23504945ad.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173549; x=1766778349; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yhrT3dYvAHuR7z+x4zbB6DCnVKLKVvLlBLpnRsQvASs=;
        b=nis3pxHywddjcVDqeSn0/qVkyzMBCWyyaGvhMU8bK7gbvbduxXWB3fEcdc/3iY6Qd3
         pXLekMTKBAGZmlCjSmSSFsWc0ZeBaOLByFSM4AXABrTCGwY43w1rBuMnzP7fVGyy9MOD
         UA3W0Ne0zztotGJnGc52jBRdQN0tUxo+Lga07DSZ1DZ6Gx3EeNa4cVlcVCyay7FumhzP
         xvO/tMOQupRypZPTwNtlOMQPMn3bSni3q856JIm55LQXH6RYBUh8mvtQcGvWxW0T9ihm
         Pj12sa/u7YUcKzfXYGlUaBR2kQMbwXBJr98Hy4XU0N0CW7W4hLwq4gdbXBDcp61anRqz
         p3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173549; x=1766778349;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yhrT3dYvAHuR7z+x4zbB6DCnVKLKVvLlBLpnRsQvASs=;
        b=MAkvH51LO03zyBJtMS56bWx/7kQ0KHSz+NJ4zDk4mx7Tb3PdaNKXdB44lIf2CGHGBy
         rfMDBggM77BFZ9aGMgtQ3ErKCvqeXyQ883konjpT6s/OLdeJoemTRl7KJjlpuiDy85nz
         dt5/Lteewp6fAXjWtsa3qp8MTMbR1WXGrMBM8HnyfMy4DhUIm5Xce8XEAtHUzXXyXnQr
         66NDq8Ow7oLRiyjlwIawHIaxtYn+x6874m0TjPTkTtYKdpCBMT4xoJrG8fhOp8Xv1Lmt
         3OYpN6V3c8zZg47p0UupVnCAdqHgLBE14EtQAxOzejzdcN/XhCA4NFOm0Mx3OJrG6ZeP
         6WuQ==
X-Gm-Message-State: AOJu0YynLOJMHa5RJlXXZ0LCrnxfNfXg9gbM9CH80Z029vnVq1AOTiEj
	47Vz1Dsl4iTo7VUua7mSqgp+D6x4hXhdf/Ft45z66brSAiW1CaXVX+rP
X-Gm-Gg: AY/fxX7qT3McpuYXfks6xRJ7WrkOH+80WoTXMBp0/1hmAzyYiW1PsaooI8UQE8DG1A0
	/YksbhUjPfnED0APKcdXQJQFMKUGKC7IJ4ZkMb5cUsdV6CGVu7kFLFwmg35nbxx4cLosmwS3sVM
	X/m3tERsQiyt6de8gzSDgGbjxFDvVB+gFEu94coLG/sS8OZLW1vN3PvjvcW/vSns/eA11p5HgTS
	HsUaYrIMY0Jfoe1qpx/zIS2H5otrT8IogmvM8fADUeNJCTWBNU/SV1JhCpUWCZYgH+8YrA+Fqx6
	7rsy/BeXJ1djeo4g2l9MGJ+NA4iEPX2zKI8tefeI8lIl68JegQCoHZrjZYWUoBlXl42gwFZ3Rkn
	d59r4ihiw1uuw8WnoOz1ZNkML5NTpBfDyDZhlxHVmx2tT7xdKot6ymbz+C878ubboJPwvrVYq2z
	N4KnanIhmEppva7+D7hd7TA9xRMiMlo7D/yRyls6XBBbVQBBTHyijqlWkHkndHKFY=
X-Google-Smtp-Source: AGHT+IHYkvMNmtufwGbQFZyaAJlBw5lJ5+Po+hUSBwaQcbyjQEel2hdkBOLfJ0tXOUXH+Tpsl9Ec0g==
X-Received: by 2002:a17:903:b83:b0:2a1:388d:8ef3 with SMTP id d9443c01a7336-2a2f222bc6amr41151885ad.18.1766173548952;
        Fri, 19 Dec 2025 11:45:48 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:45:48 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:48 +0800
Subject: [PATCH v5 19/19] mm, swap: remove no longer needed _swap_info_get
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-19-8862a265a033@tencent.com>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
In-Reply-To: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=3385;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=pCVvSP05LttLarbkjFKj8kSFxDT7Dt4yyCzNi6fJQ+k=;
 b=t5W6ua32Km122SKf4fxjddcswwCKbIbefSoFS8ELA/zydvgz+HlYq42nSlpLbQZLwwNab82Mm
 KdT6vb8aUcJAVN1pAltmNw5XUP5FcmaVvV8kNIADb5tTgy8HN9bpgdh
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Stat-Signature: 1o6ncxfkzyxk6uxtxey58ooacqtbeq6f
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2451E40014
X-Rspam-User: 
X-HE-Tag: 1766173549-253069
X-HE-Meta: U2FsdGVkX1+o8R7rM4S68K5DllhZnwIro52gbbcJcis9Dca+KZUbukfaiW7Hb9MkehoKqO9q9Iv3fm2ZL9GNLmMZomCWDHLCWcbxG3A7Q0yVwZpG+oMQAWjJ7aGACRRxXTQHjDC8JAmmvBeD3p0xGQ0oAzHTxFidEq/zoFGYMRBQoKH2IYCvYCig3ibU+Er1ZDH1ZdP2AskiFNGAAeemZQ0lyNCQ5IKGut5UmvSmy3tWc5N0nK2v1q1Guad3YuMh+8f8mJVtkanMa1LEofPcLCtiBQDMlAW8G2/O9hPt5jNYiewInrI4HaLGXutL0WKQR0mXkQrBcTdNMcHWAgAkUZDQr7JalbdLo3PlKnwNTzJkkwbZpVWs/fax8h4en2jZxPAq4RBk9iv731smKb99PV0xgdUEBOklNQBetrCz6V+Ffrua0R21NRpo1+SPSOEYr5v6edGHL71YVJpcsNRnwcbALaN6XGGY/osZMYPv8S5hAbtuKqd1y7PVB9vSQmD2Sr0Pdt2jA0llfSxfxGb4phwc174Vgc+uUP8FwhQJLqDJuf1TOLutwE1ivmNEm+kDfC39I52AnSMPPZ1keOrEQaorKoslOuWkagWmK9fGIHergTbOsHPi9dtFhkZ68qJenrl2nm0DDP6yzILFNdKBakBdvKjLH/wl+Z9NUkD6CICu08HqhaKmi+Z1/6dK2z9MwxBG5/lqjbk77ZVnQAG8I6RQRghnC9VED3JBQ627TpSVs70b02SY3ZSJA8OfKxC81KjgbPdXnj5WZcaDi7BM0j8heD64IHL0BF3AxJwheBYK+cLFTgTzguzYzurHNO8U3vXnvltLRYxYuorwyDeKk0giUQwVCboHr1HnnsZ4tzxTh8Mo+OJD4pNG2+20b7WI5XBVmvCHN53CozzVpwoacxxXV22LhNABqLn1Fe3+OSzSD4HiLahaPwh4f0oX7Et41SABUT+mEz3FW4UMbpJ
 iqIG/B6m
 IjZyoVZpQGkP+d18pamR8wWc0RBQR90CpxPfhlj0uTPpxHXuiNy9L1hsaUFez0G0oYLCek2pyBp5s1XxZcHdW6wEAiz2AUBZDnpFfoitMyoqIqxY+n1TlXo4d5AbAUrFOImROfB0x8iQyS2aGQ0tZdkEqK+WCOvf/wc0DpvjxD8DfPjWeTp33/NFHmVFaEveMYXoxXivk7jdIO1zKoeKL7u0TlXcGkp+iiROMLN1U0Qmxfyw/fcwY/yzLXYFPZRY4XEu0KY9sdmJMDfH3Gj9CMy1mLfzN8REqZ48zqA4xp55PyzCQ4Xe41q8zgpsxDXMwiNC+OqvWCC9yWfcb9azjrNPLvAbKQMgomq1W9ngH1E3wmSPZpg3O00KsVc5331ICEZ63Et6fpEII7JClsK6Dh9ip6cwURNMD61q+dAs4ik4vGOAqU3wAKhdN1zYUhfI0MULWbIvPd3fo0aF1T4NMvXNlXVLgVbYAb5o6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

There are now only two users of _swap_info_get after consolidating
these callers, folio_free_swap and swp_swapcount.

folio_free_swap already holds the folio lock, and the folio
must be in the swap cache, _swap_info_get is redundant.

For swp_swapcount, it should use get_swap_device instead. get_swap_device
increases the device ref count, which is actually a bit safer. The
only current use is smap walking, and the performance change here
is tiny.

And after these changes, _swap_info_get is no longer used, so we can
safely remove it.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 47 ++++++-----------------------------------------
 1 file changed, 6 insertions(+), 41 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 886f9d6d1a2c..1ee13390d910 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -83,9 +83,7 @@ bool swap_migration_ad_supported;
 #endif	/* CONFIG_MIGRATION */
 
 static const char Bad_file[] = "Bad swap file entry ";
-static const char Unused_file[] = "Unused swap file entry ";
 static const char Bad_offset[] = "Bad swap offset entry ";
-static const char Unused_offset[] = "Unused swap offset entry ";
 
 /*
  * all active swap_info_structs
@@ -1600,41 +1598,6 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
 	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
 }
 
-static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
-{
-	struct swap_info_struct *si;
-	unsigned long offset;
-
-	if (!entry.val)
-		goto out;
-	si = swap_entry_to_info(entry);
-	if (!si)
-		goto bad_nofile;
-	if (data_race(!(si->flags & SWP_USED)))
-		goto bad_device;
-	offset = swp_offset(entry);
-	if (offset >= si->max)
-		goto bad_offset;
-	if (data_race(!si->swap_map[swp_offset(entry)]) &&
-	    !swap_cache_has_folio(entry))
-		goto bad_free;
-	return si;
-
-bad_free:
-	pr_err("%s: %s%08lx\n", __func__, Unused_offset, entry.val);
-	goto out;
-bad_offset:
-	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
-	goto out;
-bad_device:
-	pr_err("%s: %s%08lx\n", __func__, Unused_file, entry.val);
-	goto out;
-bad_nofile:
-	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
-out:
-	return NULL;
-}
-
 static void swap_put_entry_locked(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
 				  unsigned long offset)
@@ -1794,7 +1757,7 @@ int swp_swapcount(swp_entry_t entry)
 	pgoff_t offset;
 	unsigned char *map;
 
-	si = _swap_info_get(entry);
+	si = get_swap_device(entry);
 	if (!si)
 		return 0;
 
@@ -1824,6 +1787,7 @@ int swp_swapcount(swp_entry_t entry)
 	} while (tmp_count & COUNT_CONTINUED);
 out:
 	swap_cluster_unlock(ci);
+	put_swap_device(si);
 	return count;
 }
 
@@ -1858,11 +1822,12 @@ static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
 static bool folio_swapped(struct folio *folio)
 {
 	swp_entry_t entry = folio->swap;
-	struct swap_info_struct *si = _swap_info_get(entry);
+	struct swap_info_struct *si;
 
-	if (!si)
-		return false;
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 
+	si = __swap_entry_to_info(entry);
 	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
 		return swap_entry_swapped(si, entry);
 

-- 
2.52.0


