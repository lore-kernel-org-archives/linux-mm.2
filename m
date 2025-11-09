Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BC9CCCFA1A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 18:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2EC8E0006; Sun,  9 Nov 2025 13:06:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B488E0002; Sun,  9 Nov 2025 13:06:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB4D8E0006; Sun,  9 Nov 2025 13:06:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D693B8E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 13:06:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 918078820B
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 18:06:08 +0000 (UTC)
X-FDA: 84091847616.26.EA29F66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8B10DC0013
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 18:06:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CKFSODqk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762711566; a=rsa-sha256;
	cv=none;
	b=twuYNewn7pF5eoeyEdBcX55F+HqQYJgr8kMkVhvBGbUu6XgqjtxaXgDdudrXPZYdyFJAP4
	xoox7gl3Lw1XxP/z2OFcHN9tz9I08kZ+dsSqnetiac5PVQg68apSY0IdCDFCKEAHZm2t3Y
	EZeSxu90X76K67Qc2Il8/C2erUgxDUg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CKFSODqk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762711566;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ootCegqp4nC8y68iDqi2uBXbIcLyzXdKUQt6SHOUksw=;
	b=e1mhQyK/9K7VO/Jbc7X+0I9HLlnK8ZQEMcTX9l8WNGQb5Rat/ZL7Knwn+x1QM8I3INAjeJ
	2NxyEPt3ljMr0mnNoxiEUyKriQ1PiN9rBeAmUe67jvp24lOuioT5hdf9izK9uimGVISJp5
	HMRsnKZd8vDg6YtKmn3zfIP/GnPI5vk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4687943AAF;
	Sun,  9 Nov 2025 18:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1A6A3C4CEFB;
	Sun,  9 Nov 2025 18:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762711565;
	bh=Rv5rj91RamEanT2fugz7Olj75634AA1cClCMNmzZM78=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=CKFSODqkHQ7lajblVBiiunadMTS7FxkMrl1FUVEvYMWbPrVewMnYvqw8Faz3HSOHO
	 wYK0mqHj+P2DdQ3JWU7IW/l/lQv80/cz4hMzJDLxS4C5PeWLUnY0mEKaq1a7+sIXVn
	 EjGCP/7Y/yBMCHwbqMyCahOB+JqzGM62GNRR1Upx/hRUyHPFUxZhPCtGyNavZ9A22A
	 gh56UNc9kT501DhHTzC6x5HwA137NrxgsCmANUK2SpLPWKfvhF9zmOUWHuVkJd/6OB
	 TjT1USFaxAkDaiX2NXDcq/tHsexW4Zh3Z3pN5fD87c1sBohbGazNj0magcn8QZ/8MJ
	 NqJVH4OMboX3g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098F4CCF9F8;
	Sun,  9 Nov 2025 18:06:05 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 10 Nov 2025 02:06:03 +0800
Subject: [PATCH] Revert "mm, swap: avoid redundant swap device pinning"
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com>
X-B4-Tracking: v=1; b=H4sIAArYEGkC/x2MQQqAIBAAvxJ7TnAtSftKdNBaay8WGhGEf086D
 szMC5kSU4axeSHRzZmPWAHbBpbdxY0Er5VBSaURpRVVonSJwWjVe6kDuk7I3qGy2lMwDmp5Jgr
 8/NdpLuUDy1WRSmUAAAA=
X-Change-ID: 20251109-revert-78524b05f1a3-04a1295bef8a
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762711563; l=4133;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=alE+X02rbk4jwNfT7auzmxmmmbItfQDo8i+kaNeAHjY=;
 b=y+ozs+sm7ni2QmqCYkgxfgsn49ITpx52INQ0Dq+5Kq9kcCBk7gA/JGdd6qZOmhRbyTjalAn2s
 R3zWuGKIM3zBS6pl2r1pQbcyZsst8HOxUqBN0/qrRpv0I1JrjRU40Ny
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8B10DC0013
X-Stat-Signature: 51qh4tp8zgsr19tkh3bed3z63yfig5tw
X-HE-Tag: 1762711566-112909
X-HE-Meta: U2FsdGVkX19Gi3Vwz+a65kTMzOkPDKHZ4s4qiUgC8qFw6j1c3bhpusck6oZlomggBV7Z2jSX/ky6S1CFzQOBntmS1cakUSLXIjkFDggiZstqGEBX+Q5CdJVimZt46WV1EBtnnd6RpsofeGUwpWIz01uyr3RuQ0rOrDdifzzctMakTaY10jazpwqbeWfDjpNRLAwQoy3S9MZrGSwsLf802zvBI7K3b9cqtf54Gd4nRkqV3IhN3uz841h1onkjAPikrslPBGwhUSpGZvQevzj0t4S2jyg+1Vau2Fz5aCW1YcpxJWgdMao/NCCIEy9Joqd+duyU4D36FqZc9fB8aNzNhjCsdzjuXcO1vm8ww4O5FizAEOwmj0qowvfooJ/NDwBK3x/FiZb3mI8w9RZ+Mf86D/UeWgb9dQGe1IrOzBH2A5qOYDPkTV3ZmOMtLzja4fws2Cshmwzm4Rj3YejbCHCd3vfyu4I9pV9JaF/9ZOk6q0wjoDKh8/QaTEpwsbm4m4Nx8XaO8pKHVZrNfIYAUo7CV/fQk3VKUcnCPBoL5yvZ0INP3X8DgbKnndtOYWSlrq5totypc0NQRLcN0D7n/yplIgVgEsx0Yz4kMo/dCGCcZsiNcYM5NINj5ilqMpq4vrIeLP2Yz4rJ3aRyoAp3zoemPp4gWj4caFjFT9RQHC+5V0N69Qy28uwvh8+PAYtO0HLjpG9AVCvWqG+o7XyS/M8uvvH2MAzx9ewvhAWR/yn7Pib/AOqnRCT20zNFeSXNap0YP5MjA93bvF6dpFS7eR6ynpOkRHZvXFoEGCScGJ88x3tWfJd/YRKrgcQbvMZj56zbFhDi88An2ZFNltRR1/pf6I3g2J7cT3J5fpKRJoGqauiiL2oTDZ0KqsI7V8/5L23xnQ0dAUIl8cffwa1mzUeGgKZnSvE8ReGQSyPz31XDJuzSswe4q+kzqBzTKpS9JYpUm8PwxHPgcUOLLyjpMly
 ozaWmyxY
 hFHaNEyRZUTh6FSiyf8qU3KuL6VsFOXNoGXK97NszUIaNf5//FDDYDBvFGhnRKQnbyODDVdOg5RO69B1M3T0b/eyOSaS4aEmxus0YKpEO2kk+jfqHrAlZVa15bLkrrCvv2dnAFgvLJ/KpFwQecHT/FCvbbDmv9n7AaGCWtkhKb20ceJY4GJotCeH9sguQ7Djn9g94TwHMupDB6rxfXq20sOB1w+viM1nqgbr8oyUeVVA++RJK3hVn3cJZfCQBPUoV1rSRgUriyp8PhwlANHfx43otBea0oPHKHByopvmvpQCMK38JlmaX38TptSx00ASYtqCygDEwH2YZvOsAh9PeUX7CMUetGoPz7HsT5QLNevv/wE1U/GHNvnFHZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

This reverts commit 78524b05f1a3e16a5d00cc9c6259c41a9d6003ce.

While reviewing recent leaf entry changes, I noticed that commit
78524b05f1a3 ("mm, swap: avoid redundant swap device pinning") isn't
correct. It's true that most all callers of __read_swap_cache_async are
already holding a swap entry reference, so the repeated swap device
pinning isn't needed on the same swap device, but it is possible that
VMA readahead (swap_vma_readahead()) may encounter swap entries from a
different swap device when there are multiple swap devices, and call
__read_swap_cache_async without holding a reference to that swap device.

So it is possible to cause a UAF if swapoff of device A raced with
swapin on device B, and VMA readahead tries to read swap entries from
device A. It's not easy to trigger but in theory possible to cause real
issues. And besides, that commit made swap more vulnerable to issues
like corrupted page tables.

Just revert it. __read_swap_cache_async isn't that sensitive to
performance after all, as it's mostly used for SSD/HDD swap devices with
readahead. SYNCHRONOUS_IO devices may fallback onto it for swap count >
1 entries, but very soon we will have a new helper and routine for
such devices, so they will never touch this helper or have redundant
swap device reference overhead.

Fixes: 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning")
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 14 ++++++--------
 mm/zswap.c      |  8 +-------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 3f85a1c4cfd9..0c25675de977 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -406,13 +406,17 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
 		bool skip_if_exists)
 {
-	struct swap_info_struct *si = __swap_entry_to_info(entry);
+	struct swap_info_struct *si;
 	struct folio *folio;
 	struct folio *new_folio = NULL;
 	struct folio *result = NULL;
 	void *shadow = NULL;
 
 	*new_page_allocated = false;
+	si = get_swap_device(entry);
+	if (!si)
+		return NULL;
+
 	for (;;) {
 		int err;
 
@@ -499,6 +503,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	put_swap_folio(new_folio, entry);
 	folio_unlock(new_folio);
 put_and_return:
+	put_swap_device(si);
 	if (!(*new_page_allocated) && new_folio)
 		folio_put(new_folio);
 	return result;
@@ -518,16 +523,11 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
 		struct swap_iocb **plug)
 {
-	struct swap_info_struct *si;
 	bool page_allocated;
 	struct mempolicy *mpol;
 	pgoff_t ilx;
 	struct folio *folio;
 
-	si = get_swap_device(entry);
-	if (!si)
-		return NULL;
-
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
 	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 					&page_allocated, false);
@@ -535,8 +535,6 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 
 	if (page_allocated)
 		swap_read_folio(folio, plug);
-
-	put_swap_device(si);
 	return folio;
 }
 
diff --git a/mm/zswap.c b/mm/zswap.c
index 5d0f8b13a958..aefe71fd160c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1005,18 +1005,12 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	struct folio *folio;
 	struct mempolicy *mpol;
 	bool folio_was_allocated;
-	struct swap_info_struct *si;
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
-	si = get_swap_device(swpentry);
-	if (!si)
-		return -EEXIST;
-
 	mpol = get_task_policy(current);
 	folio = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
-			NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
-	put_swap_device(si);
+				NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
 	if (!folio)
 		return -ENOMEM;
 

---
base-commit: 02dafa01ec9a00c3758c1c6478d82fe601f5f1ba
change-id: 20251109-revert-78524b05f1a3-04a1295bef8a

Best regards,
-- 
Kairui Song <kasong@tencent.com>



