Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF19CD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4162B8E002B; Sun, 16 Nov 2025 13:13:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C62D8E0029; Sun, 16 Nov 2025 13:13:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5748E002B; Sun, 16 Nov 2025 13:13:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 177448E0029
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:13:10 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7169160A4D
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:09 +0000 (UTC)
X-FDA: 84117266898.09.53DA40A
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id E54B6A0004
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J8++m0Tm;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSSgfvXGMUVDrnVHVmW9bapiPTm8k034PTcoJJPn0ow=;
	b=qOU1DhrFdi7H3CsPZQvXdeEZXZZ3bCMU7w+EBM4H8ZQf1faU407n9297YReRxc+8lkUOCp
	EzNBGAwvQ26BeDlCs5CRnMmjL/eLL3/bsqIVitfjwHpnW27Jn4EBNa1dpuMWyaN5cEOQhy
	CTin/c5douCYdsi61f/y5rTTEQBHBTs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J8++m0Tm;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316787; a=rsa-sha256;
	cv=none;
	b=VveW+3RwmqOHL44TrmFfHO0WTBu5W+Ek9ogJplv/N2BrxUhn/usRR/tegRfkAa1jHyBKtO
	YgScQVkVrnopA7VPk4anOLdB9TgnDA7cPclSnXG7yddvsA4kRKLUGJo7ntXjzGGParZGZV
	HrtXpb9qi2tI/eA9azB4FVc75e/ST9M=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8b1b8264c86so371835985a.1
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316787; x=1763921587; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lSSgfvXGMUVDrnVHVmW9bapiPTm8k034PTcoJJPn0ow=;
        b=J8++m0Tmp8eKKyP1PIW4Kovp/7CAS1mKjfUdgrcAp6ThOEyA2dG7LbylDlDncUzIFK
         u6jLn3FQYZCR84sQ9m0fa0sZe5W1tjHYjKlc2UgPHG2cMzSuhSuCIkGvkUNs+84NdL7U
         NeSanRbVag6VPT84Rr3Kpams26hx3GNORodOoYcSRZay7ITxQosSamW2+SJPxk5zq9+z
         yZclnhYDfvvItWXeqs4WRoUM/hnhwxQadGKDG4QMtVb2CnHLiD9pWKbnQhnkVfFtfFEg
         5m3sRQqUeknN0KdSZ1iICMhBibPkGCXHmS7FvKyEMBLyzR5q8e7v5rRn73mIPZqYGt0z
         PhOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316787; x=1763921587;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lSSgfvXGMUVDrnVHVmW9bapiPTm8k034PTcoJJPn0ow=;
        b=wij4eRCFg1YeSa7DUKzkLnFYe9+6xWZoOYBMkDLhW7Wj9UWMqfZFQOjSG1WPKyDrD8
         3P76DLNl2OnHf4vIRZFf+RrvECbxC/6r48hk5oMp+fWf/Paq8cKLhsdcIe8HggzY1LKK
         3htPkeLCyn4dtcLI8Jms4sIoF4TMosdNXKXr6CsKo8obL2jO53nPpPauxX/UU7Ne9amt
         qEV7kqDL0G5fU/xHDBu7MkGMCRMIJTN5kV28aaPDHaxPxYuEa1bH2fwtGtMEG4Mnmvxr
         uoN9BrSHNLnvNqSEVpl9IywZXBcx6AHcJz7/vxW1jkzpij/bKInfVkp+TpxDs1L77IlD
         dB4Q==
X-Gm-Message-State: AOJu0YxsfbgRZg0qS4vt10zOdw5RqJtYWFJEo31nR0+hq3ipO1mp4TbU
	OyWLyCQk2U35yI74jX95MeFEFdtLPN2NHlgTPm1XRKwSyN9EZEaVY0wf
X-Gm-Gg: ASbGncuAmdzluvubsmZsSOur9aR7f2NqYC1Pd30hbydJhiGi11Z7fUWD8mafI3bvUAW
	7Bm0NxGmbyHFYMDlq9ry/U/WK9LXA+oCTKBYM1kVwT6/dbdXhFfoI+qR+1XMp6JsyXpAq3/kR0M
	tGjmtK1hjD/UbuEHTSlasoXvnPZ/zB4q5hXuyTdsHRkU+SlXRUkY82eUrG9TXJGekPAIaktpnkj
	eSsUUZbelVxe7bnHmM018HeI9lpytFhqumRe061CI0WDZ4mceyxnfVAGe6X5JeWvaPAS/sfMUQR
	9Yot7xq48gTZ611BnJBiKXnDMqlRy6e2zNR23q8wnGb9rX8LPKGIdEchlElh9sX6tOlh6Ml9wfl
	fpXe7WYkpn8pTXJWYYXZw+KCQT9qZu/6zt5PesJNRTS7iXYJnEucz5zb8oXmyINA1Gw3pBNBTae
	od6ssEAd4u6a5405T+sSEKLnxiw+JSdQrskqzwNCKrJg==
X-Google-Smtp-Source: AGHT+IEcCA97r0JyWuFTR0wVrGw1frbCyQjh7ot7ArE1rHrRI0o3COooS2z7cYfHFGZW8YMjjYwzJw==
X-Received: by 2002:a05:620a:269a:b0:8b2:200f:ddc9 with SMTP id af79cd13be357-8b2c3145ad8mr1196937085a.9.1763316786891;
        Sun, 16 Nov 2025 10:13:06 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:13:06 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:52 +0800
Subject: [PATCH v2 11/19] mm, swap: split locked entry duplicating into a
 standalone helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-11-37730e6ea6d5@tencent.com>
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=3213;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=4sqUTb5wDrIOXmOyfh6gWE4Eh7n/OBitK92gcYdHBSY=;
 b=G1R6O++yLMnm9VaeJ2Qbh0DEMkVpYLddj4B7JafKPOouOQt+XZ0C+P3slAOI65XhYlEWuiF17
 F9GgB+N7WzXD8EHdK30/egsIEDaiD55RlKu7BkC1ZqOtcQQQ3RtZITD
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E54B6A0004
X-Stat-Signature: fp54pqyumkr64gsssmkdr36zrncd3wsk
X-Rspam-User: 
X-HE-Tag: 1763316787-719245
X-HE-Meta: U2FsdGVkX18keIVqDqGsJ27VanO/1uz4ogGLG6KYwoGxVXU00V9iKFoOelqtLcsl/99xpdHRZWYeCuN+NMWFAeT5V6eC0dzgtQzYVPSsuSQluhR0Un/syFj79Off5HSr/ntrPA/YiYvFSHYAyQADuskRD7rR92Fa/vssW84+z4rwznbwSo872wfqVoB5jAK/RnjLfqL+SZwMdzXWX0oA+iPgIiUU3noRzLsjQlfjypuaEKSeZ8YMIUwcoWwlHzbv2EX9sJx3P6PvpBm9fh+rrBEmGMHCUopLF3hz2O8FetxSCCkbjzSet6eDx7hHKo1l23QGBSgekMvcUsRNEqbDqmV4WBbdUEWe8CaDiwv6SulJcdjb0fEC1rTY5y1h/4pNmFI+tBpXlThlC/3GFAwqwFQhJ3C6Emlgd5YM0/4Tmn4dVrKJQXmUxeesOXzBSCvmVRFnj3znthoUkLzRguJiHw3litBtddq7SMQmtGzwWpkXv280WaobcgALRvSvp9KPN7gFxqEE7SdmfSzXXSC2q4CR/8wsKV25f0euizsLItpjgWNMzH4uvFD3Ebn8oynE1c6tSXMKrMmBaqwDDrMucPFFlFGfLSeuEq+ClzpgWB/1GlYe3PV/YN1++nLkKdRyEx3A20U5drKcUxVF9QsUPsaStJQ63EoJl5rJ1sI3A/yVi0z1cD56gzhmIotVW8zK7rHhnJ/vIUB8RYjgoNrmJbtxrG+88Pu9p94ekawb/QdzP/ADKApoB3WAFn7+PbafvPO5JipLgAJb8enBsOwuG01qLIBuWbPjWmcugkaG4h0MvQhG6IC8s2RIXBvDc6nV2tvZX/k9JthSS6ZU6jX7okKhmjy8r2LoRwrH0hbbRU9mtp+c4CGu4PUHfVZZ2QBZeQhlVW43zKe7ACyhL90QIJTaAXUpf5E2zR2CnTdkloHn+lwpIpZ8awYP1XrN7FBcWgF5y1COBuRVeK08T1K
 1R16JrF2
 NP4Lvjjl0vRo0xiKON8nzUfNPsycu8/rfth949j2/Xw6iJhpjf4MIaFOGp8FNo8tvU58X/5WwihSJIWZmVJt9/Y2dxv/qqkNMjhThaB6sAeRqbJufKEfFqsdWvwQOM9tGNbCe0cV4K9yx87gqHSPFHRedeyY0hmntnoFzG9LZkxtoys8Jrq8m0+i2veQf5I6LnMK21d/Bbkp4AleYwJU8nH37GIgCDPNGRjJcZMJa2OERVHJPlCjOSwxn3VWqNhXEWelavXyO0Hj8+CA/e/fwk8RhAmmLXzGOaY8efuw6ZL3aO63bl/DQvrPPbG8ZUNnM5rR6l/WTdXsBM4sxsiMoZMR4bVKJmeuhSg3o5QA6H96H7Ls/qT9G8czXb9BGhZPeweVuDaVsD9Gaxs/zNlPNnkn7VyDHgt2EWEe3tJC7jVtDcpczR5mvvJBKbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No feature change, split the common logic into a stand alone helper to
be reused later.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 62 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index d57e83a4d0a7..94d21b755c0c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3654,26 +3654,14 @@ void si_swapinfo(struct sysinfo *val)
  * - swap-cache reference is requested but the entry is not used. -> ENOENT
  * - swap-mapped reference requested but needs continued swap count. -> ENOMEM
  */
-static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
+static int swap_dup_entries(struct swap_info_struct *si,
+			    struct swap_cluster_info *ci,
+			    unsigned long offset,
+			    unsigned char usage, int nr)
 {
-	struct swap_info_struct *si;
-	struct swap_cluster_info *ci;
-	unsigned long offset;
-	unsigned char count;
-	unsigned char has_cache;
-	int err, i;
-
-	si = swap_entry_to_info(entry);
-	if (WARN_ON_ONCE(!si)) {
-		pr_err("%s%08lx\n", Bad_file, entry.val);
-		return -EINVAL;
-	}
-
-	offset = swp_offset(entry);
-	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
-	ci = swap_cluster_lock(si, offset);
+	int i;
+	unsigned char count, has_cache;
 
-	err = 0;
 	for (i = 0; i < nr; i++) {
 		count = si->swap_map[offset + i];
 
@@ -3681,25 +3669,20 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 		 * Allocator never allocates bad slots, and readahead is guarded
 		 * by swap_entry_swapped.
 		 */
-		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD)) {
-			err = -ENOENT;
-			goto unlock_out;
-		}
+		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD))
+			return -ENOENT;
 
 		has_cache = count & SWAP_HAS_CACHE;
 		count &= ~SWAP_HAS_CACHE;
 
 		if (!count && !has_cache) {
-			err = -ENOENT;
+			return -ENOENT;
 		} else if (usage == SWAP_HAS_CACHE) {
 			if (has_cache)
-				err = -EEXIST;
+				return -EEXIST;
 		} else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX) {
-			err = -EINVAL;
+			return -EINVAL;
 		}
-
-		if (err)
-			goto unlock_out;
 	}
 
 	for (i = 0; i < nr; i++) {
@@ -3718,14 +3701,31 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 			 * Don't need to rollback changes, because if
 			 * usage == 1, there must be nr == 1.
 			 */
-			err = -ENOMEM;
-			goto unlock_out;
+			return -ENOMEM;
 		}
 
 		WRITE_ONCE(si->swap_map[offset + i], count | has_cache);
 	}
 
-unlock_out:
+	return 0;
+}
+
+static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
+{
+	int err;
+	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+	unsigned long offset = swp_offset(entry);
+
+	si = swap_entry_to_info(entry);
+	if (WARN_ON_ONCE(!si)) {
+		pr_err("%s%08lx\n", Bad_file, entry.val);
+		return -EINVAL;
+	}
+
+	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
+	ci = swap_cluster_lock(si, offset);
+	err = swap_dup_entries(si, ci, offset, usage, nr);
 	swap_cluster_unlock(ci);
 	return err;
 }

-- 
2.51.2


