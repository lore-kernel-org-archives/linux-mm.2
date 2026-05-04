Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B74BDFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 12:55:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B346B008A; Mon,  4 May 2026 08:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4216B008C; Mon,  4 May 2026 08:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E41B6B0092; Mon,  4 May 2026 08:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC7AD6B008A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:55:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81572897C2
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:55:46 +0000 (UTC)
X-FDA: 84729734292.20.807E5AF
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 88AA6A0008
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:55:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JpNjXDzz;
	spf=pass (imf15.hostedemail.com: domain of jose.fernandez@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777899345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xkSPJSdtSlIYcN/7W3fB90ZDg2RbpoO3LlLAO8rSbLw=;
	b=4STovwFOpOhPABv04Tg3eQUwd4W0xH78+SsGPDio34YqO+CKendL3gpnppl6YwnBz8FWgr
	cTGluFimMnLmAExQoXbrg1CSedZv5z/rzTkODumdfhE3VwQw4vrF+xRFvs9/NbUc9LAIQE
	2Tsmk1W+waNXaHGOsRhpuEHC3/gGgEk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JpNjXDzz;
	spf=pass (imf15.hostedemail.com: domain of jose.fernandez@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777899345; a=rsa-sha256;
	cv=none;
	b=3gn00FLBWENLjEVqopAEUBrv/MzIDO34AhbM9+/tDc5mWAd0IrCz2NhlI0i3qw7xDK0OU4
	bAVv920U2bWUfTQQL5fhcIUkwl0PRyxaEd1PrVKtmLAT/AUAbWYFDrDCdeQkEEFjYGRT2H
	A8t5ZHhuN4LgwLr4z/vmdblqI/R/igc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777899342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xkSPJSdtSlIYcN/7W3fB90ZDg2RbpoO3LlLAO8rSbLw=;
	b=JpNjXDzzxXd0csPoMAtWz2LjLcw/qa/YsWVq2sPGYE3pYjuCFWfpWtTxkAaZ5Au38h6yZQ
	Reye66yAvGCgHQJpUKc+V8vWFj+w0syusJLF2nojx6sZaYIJkLrDMNFy6w1djEq4WDFdcf
	jnM9u/Mc4D3AD1lMfR9xRAJFdzDqtjU=
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Date: Mon, 04 May 2026 12:55:17 +0000
Subject: [PATCH] mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id
 on swapless host
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260504-swap-cgroup-fix-7-0-v1-1-f53ff41ee553@linux.dev>
X-B4-Tracking: v=1; b=H4sIADSX+GkC/yWMSQ7CMAxFr1J5jUVaRnGVikWSuqmRSCK7BaSqd
 yeB5fvDW0FJmBRuzQpCL1ZOsUC7a8BPNgZCHgpDZ7qzOZkj6ttm9EHSknHkD17QIA1m9IO7jq0
 5QHlmoVL9rP39z7q4B/m5qurCWSV0YqOfapSEA8f90+pMAtv2Bctw2NyXAAAA
X-Change-ID: 20260504-swap-cgroup-fix-7-0-ed0fcdb8f103
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
 David Hildenbrand <david@kernel.org>, Barry Song <baohua@kernel.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 stable@vger.kernel.org, 
 syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com, 
 "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 88AA6A0008
X-Rspam-User: 
X-Stat-Signature: ii5o5mchezpu68trp9d5gkxwjp6z6ar1
X-HE-Tag: 1777899344-979997
X-HE-Meta: U2FsdGVkX1+PjUNKNNDntv06rW/emQ8qL/Ooy6ZBEvkI67jQOhaRu0JdCQ1pLr19k8CeckdFNmHfcYmp3Lk0UeGtVyDVCw6dK8FCmeksfXt+4ZcwCsputBJcE4ba+UuInAvciV+shT3qzoxrUv+mA4atkhLVdTmVDvwXDHpfEyc6W7yCPEm9z8oVRSvWpS4BBnQJm6YiThZj5IOO5B5tqC4JBvl5fS4/CSoWMiuehYJvJWfaozkXuDzgmoShYbm1WWsDhGjXtpHQkoUaZTV6F1M99dVUYR0NNWvEqPHMuFS5Q+iVQ2a4LCRB8heVs7rbhFDT4nvW67f6RDMt9HUTkuJoCr1E60M6zIzfAutgwChjh4R8rxtM4O+jH7DTZD0MczHcx2CThpkrgRrJuKhVpMgJ89yg9LQsZOJa9AfMsBny3IM3lBJXSRpq8t5DJaT9cuWKsETpovC4ZEzFsxp6HmwanVCKnZQ+xP8kmswbCKZe5pjm3NVNUV03g2bRxkZk8Ae00nuHLgiqTB8a3NYH+5eWOH8+4Qjd6hevAhrzLv+ncDaJGO+x0cqPJyJsCX67dwmhgoFo0WGw+yN8NTw3tirYOe3nYwrXMg/YK/ku7IosT4rPjOsiJla+OV2UENXVa8SbAAOk8A0w3fKrMnfwPVv2vPTyrs7rNyVO/D4JzK2BPuZ7YIzYuSAYvMFGErzPh0MSysqKdcJL5CLwIsyl/1cPfeZBnc2WizmbjvAhqxvkh2FeCONwQp63pevw4ad4TXTo99z7GIOzsMmJSLdFAg5Ag3NOaoo7LO1jRzmUupjRCxHCvlBqgQxONcY5peeKhHNX8m/DKvzfp4FClXYOM07QIOcxgnK9r4tzEZz2pEKHK/kXjcYG8biuSuPFrEm8SDbCdljYu3eeDzTUtnis1u82JUKRfuQBvQWNAxTQTUErpwL4eGZ9EUbNNPOSVvCQC7SwIT8dXB5Ocr5ZYeO
 qm4xvJX9
 BJblfGszrVf37Lh06xHdDCx5wYNRXXx9ZifOr9HM/Qc7+qef3TJg1VUHZxdR9/NFXC2Ms25L9dzm3j/DYVNfgeZl2rM2Y6M3Vj8Alu0prkWGoQL2CemrOe0z2HZpH8RnR5lRR/Nj6SiFfNUsgfHThWWEjQiX04gCWjXq6c+H2qkrF/9z7/o9KPtH9+PHXqe+2wC4rIr8eBovWfsozfx05HLXAOo8SGdzTZEH5OHu06v0BSl4IaoZ/0vn9l8ocRqtdav8uwVPBz0ux2PbzeElaUjLqHJ0hnAiqj7Sjp3fz6GjzrrRdq6J+sjm/DEUx3cc92X/pIGn9dwxi2PIiu9zOOF4WeeW4QOso69hxiz+nuOQUrjDrJ6fp1Uc4n7JakKjNicO4UzCHE89G45aHe20A7bX7b+wz/+uv1GEwwsEI7XihHO5lkz5jhSHpBMuNsjdSVd0cvsbpw0rjlIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lookup_swap_cgroup_id() passes swap_cgroup_ctrl[type].map to
__swap_cgroup_id_lookup() without checking that the type was ever
registered via swap_cgroup_swapon(). On a swapless host every
ctrl->map is NULL, so __swap_cgroup_id_lookup() dereferences
NULL + a scaled swp_offset().

Since commit bea67dcc5eea ("mm: attempt to batch free swap entries
for zap_pte_range()"), zap_pte_range() -> swap_pte_batch() calls
lookup_swap_cgroup_id() on any non-present, non-none PTE that
decodes as a real swap entry, without first validating it against
swap_info[]. A single PTE corrupted into a type-0 swap entry takes
the host down at process exit.

We hit this in production on a swapless 6.12.58 host: ~1s of
"get_swap_device: Bad swap file entry 3f800204222bb" (do_swap_page()
being correctly defensive about the same entry) followed by

  BUG: unable to handle page fault for address: 000003f800204220
  RIP: 0010:lookup_swap_cgroup_id+0x2b/0x60
  Call Trace:
   swap_pte_batch+0xbf/0x230
   zap_pte_range+0x4c8/0x780
   unmap_page_range+0x190/0x3e0
   exit_mmap+0xd9/0x3c0
   do_exit+0x20c/0x4b0

syzbot has reported the identical stack.

The source of the PTE corruption is a separate bug; this change
makes the teardown path as robust as the fault path already is.
Every other caller of lookup_swap_cgroup_id() is downstream of a
get_swap_device() that has already validated the entry, so the new
branch is cold.

Fixes: bea67dcc5eea ("mm: attempt to batch free swap entries for zap_pte_range()")
Cc: stable@vger.kernel.org
Reported-by: syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/69859728.050a0220.3b3015.0033.GAE@google.com
Assisted-by: Claude:unspecified
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
---
 mm/swap_cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
index de779fed8c210..95c38e54dd587 100644
--- a/mm/swap_cgroup.c
+++ b/mm/swap_cgroup.c
@@ -124,6 +124,8 @@ unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 		return 0;
 
 	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
+	if (unlikely(!ctrl->map))
+		return 0;
 	return __swap_cgroup_id_lookup(ctrl->map, swp_offset(ent));
 }
 

---
base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
change-id: 20260504-swap-cgroup-fix-7-0-ed0fcdb8f103

Best regards,
--  
Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>


