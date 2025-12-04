Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB475D2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42CFD6B009F; Thu,  4 Dec 2025 14:30:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD336B00A7; Thu,  4 Dec 2025 14:30:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E4B6B00C0; Thu,  4 Dec 2025 14:30:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1447E6B009F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:30:33 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BBA1A13306C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:32 +0000 (UTC)
X-FDA: 84182780304.05.E6BBBC0
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id AA79C40003
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OCD4IE13;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdpDGFKobTDZcaA+oYO377RhHuNYAnjN7TF4QVNsFf8=;
	b=P8IiICucIT23VY6lkH8Ma4wQ3Gqo9vqLWk8rgOThDAD1asTHDSAsoxuZIKGEDczsIulQGR
	px0LWhItdqw20EOP4hGaHPxbpMz5/w5BJ1yJbe+1NGrKnlluZBzZJMwFUCIU0qWzi7wgiO
	FQOknWw76facacNyq/a91cTs4ouiAFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876630; a=rsa-sha256;
	cv=none;
	b=ZdmW6sTNOgrBLOPojBDVv2Pz2hL7zjS1+0tn4Y08SZOyNrYm2TyeLqokLpVkeLyFAgBIPT
	EAxtiGKRslv/tgaL0q+SAJGaeVTgL2nCqlkumn+Hcpjc9DLZ+dcwLP5ZvaaiXQObSPG7EA
	c7CC3fQRdi8Q8E5N22Kvfg0RsF9PmeI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OCD4IE13;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-297dd95ffe4so12308105ad.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876629; x=1765481429; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pdpDGFKobTDZcaA+oYO377RhHuNYAnjN7TF4QVNsFf8=;
        b=OCD4IE13aER0aKBy28eAeuihJ2EJU1LFZvjqTX3ahIYSPWLv9+I0hwDDpQFwTIC3lW
         2vb+UnglhRSMFTLYl+yDJRPSJxmOIrS9OTciAGqhnkmrUUdjmQwB6Ojv81YfHasqhSLH
         AStej7dQUE0hAoWea3NlNaKcFMtj6CUKaroPPPbMTDGfWus2E6dVx6UpC3/QRLTsDJ8w
         tk859cj6zHTYKp7bJpDOeBBdXK+w5vKHdp2RebsmdUfIeaBrGZn864taQbPT5fErsIB2
         vvVrPIZ6IWnlw6c3vcthGMKCUD2GwxNHvexc2GL7AnOo494+buvdMFL0XsuE2gzXBxZz
         mhpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876629; x=1765481429;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pdpDGFKobTDZcaA+oYO377RhHuNYAnjN7TF4QVNsFf8=;
        b=BifjcZh1klBowTym1OfI7A62s8q/c5PV4xxL6f5CqpS7G5uYT3QLQWVp2s/NyhIFKH
         uEwb9GUXsW3aU7hEA41VETFRAOvTAhDzeJCoQbvdcF7jVSwbYjJDL0lP7fUvIkp76w2h
         H+/7hSR6tQBpmvp941ocOMrIOckkDWAcgl2S/cySJ8ux6HbWY28e9/S7Uz16H4ak9ihh
         B7qQi1fDgfQ3AXBqb0g9OoAdBwZF9PstLThg7fTq8ei7vof15l2E+6TOMENiXo5OExgz
         Jav9aq3zi8biCA4nGZ6zKyIq33LfUw9R0ME9jMq/eolWgkgOeFV3dog4J5uNtDozp5UK
         cTkA==
X-Gm-Message-State: AOJu0Yx+hsRjH4YAY1kPdRgXgwtXuTPDAEBd2Vt/qaF9XlRSDPWgbFN2
	DnFAiAoc41WjmGgWg+WGrS+6ifXfTNglQjeRLsghmNWBmTPS7o6ZDHty
X-Gm-Gg: ASbGncvv8C8wFsFZkoqq2eo3TYgKuhJjKECLeMRyecH87kzt3OjtgNYKbPYtAMgHb/F
	LpEXrB+KbYULWp4m66Ld8cDQRgr8V+t5od8dhtp2pmyV8yjfpBYU+LlvZpoa8ihleFXAYCu6GDn
	emHkX9MytiLRxe91EE3TiuVxHNCzO3LQRq06bNlv4XFRWZwCU6kMVnW4geFkxbJdQQIC76t4ocq
	57/OZ2e6tpWPtsUuvxrAGS1HH8+8hc5TMqgcD/flzTf8dEonXNSKXbmORiD0vgmtxt/52VPtCSB
	W81j0PBw+YccgU0XSXFfeoWD3Yfj5HWL6O9Ex9tT7pWpZfCW913YsQd7ochHhRlkg3F6rLhHrxh
	vd/OWTvqgQQ9TvYb8nBGpDOYOreADNdOfwjlvIcB7kyz5YpH63Acw3TpcL+ur36BPNoLA0Nea5f
	9QlCHvjqbvug0oL0RxKEhhdvBdKO2JYFzaDvLurxFIw0MMtbcg
X-Google-Smtp-Source: AGHT+IFficBiEMz/pYiFH4fMZ1x1Z847vNsC3DafnIyYiLDS2+cnBVh0UanWRv7rLW1Nv8XeJgOXlA==
X-Received: by 2002:a17:902:ccd0:b0:297:e231:f410 with SMTP id d9443c01a7336-29d9fb65b25mr43914435ad.13.1764876629308;
        Thu, 04 Dec 2025 11:30:29 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:30:28 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:19 +0800
Subject: [PATCH v4 11/19] mm, swap: split locked entry duplicating into a
 standalone helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-11-cb7e28a26a40@tencent.com>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
In-Reply-To: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=3213;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=UCtbWcSkIiRY+e/EucxLikEc+mfHA8d9Ghbzu0X0yNQ=;
 b=uBiHRTVs5Yf1quAWq5aqh+UbkP/IGjU3Qt//+q+F8Aj0HHKN7bFns4gRjtpoF5uyfmUMxZk0Y
 4C81u+2HDaACCprv7DUtWzXX9t+Ur6JqeLPVF4a0a2SxiNEaldfC5I8
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AA79C40003
X-Stat-Signature: 1p4ndg8bnkm6jp9d4k16yc8n7zhkb5yp
X-Rspam-User: 
X-HE-Tag: 1764876630-240679
X-HE-Meta: U2FsdGVkX1+lElIYUiM8QGxWq05nVzVdou0WGomObmM8m3h2/9cmGJsiOYfVfiw6iHaR6nl7IvgAFhQ4FZEzl+/pw0afhWaPMBt+ZZ/TZYpd2ifNHDDVc0huFsYM635AJ7k2t04Ivw05tb3qwc8ymHrr56ZBIL+eqw0tXp22I8UqqiWRV8pVAVv/kGjgLE0FOiu8cPI9DPBv5sqSAt0aG8HE7RVcgmnzIgELBHvmKWqHxKxwT8I2IVSyLf0zSAFxhxYj/dv7GNMWry3AUqUBdUjbmUh2hCCwwbRxHhKBWNwLOI+1J/J+2xZMbq/X5etGSvn2oQhLu0vMW5Ix9GYTqvcqmYx4QfQN7mk2vJFyzF2tl3Vk8pi/+i8PR1FN5ICGxSVduZjrEIxhAu+2AjZpI16M+KI3zhV1d+Wf7DfX/alUZtCCtLsxHzNFQXV/aeOUJiRy/iSl3rhrFO3gj0Vm7qMDCzj1hsT+7ne+lQiZ6LQ4Z2Hs4Qhb0HtgRTw+DbHsQKlEfhm45EQhxA4uxFhJQL2FU0nDLVqkg9onHTmapC4qQeoyzX1wGvKrKQLJ2iNhx67gRPKbUGNK+6w2vqHJ0PehzIWVDkbleQJQDjV6ua/vtzv778yeth2B43kDtDSgE5h3WtkH5DeZIGmcS+tv1N8F33/wvpYCZf2S3ATMAlTrHWefxOLnLo57kosuanhYTtXBpZjgzZY4XJ+BJVBE9ubb66JkENvawJUZulCEoSsCUK7eyRrww9xZPFkvRtVRugyo99lSyT2kCcyVM/sQl6IG93Ft/9/mrQfkxokA7dTw/V7XRwkZYbheRWhrbZ3TiFWDijhKUGoEMm/8th/Y508VRZn/JOL0ViXijPLbcPbt27tnAU/MMBKtbgAMJIJEsthTUw5YF4srjDSIHEAd9aKxrepzzQECYffpYqlBJ2967eLYZQZ8DgQTjAh4QEuPb1XCxLe7iWekS2f5VCf
 FPxbaB3f
 oz+JhzWGeN4B5N8UDIzPsDGv292vGNVD6Xwe7pHTAblCEFIbWyiLssFIgMxKntTJRBSfd81pBLhYasin14Y3O2tcUZHaJA+ztIO8ozdvqgFbhInLhEZytTE8fd7sUAIUvvlhKmfcDh+m86Pg6UEc2QbtlQcb0b3DHur140RMYmydgFbSF5yDhfafHu3gLrTAL95KbvmVYXQxAT1msEP4LCH/aMexDv6uLjBZk+7wrqp31xF44nn4vjRLyYZuNNNKO+jKmM+rKNUWNM720LfFoBtPj7FOj2elKrX4ubfhFi9AFSM5KRfgWxp+jYQLTJAA7f34RxCTQeWps+tC4U2E1CbZr2Sg6xhs5CyaW7dyfmuJy50JkQgZocv4n6Q4+KLtO/CerDrncA9XGPJKohX/sG5p1A9Fc/AbLIEtvVx+aEbtYXpL9OkTI9TwQ/w==
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
index 2703dfafc632..d9d943fc7b8d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3666,26 +3666,14 @@ void si_swapinfo(struct sysinfo *val)
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
 
@@ -3693,25 +3681,20 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
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
@@ -3730,14 +3713,31 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
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
2.52.0


