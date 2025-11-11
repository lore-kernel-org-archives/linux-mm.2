Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5828CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 13:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4108E0008; Tue, 11 Nov 2025 08:36:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54988E0002; Tue, 11 Nov 2025 08:36:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42F78E0008; Tue, 11 Nov 2025 08:36:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C8488E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:36:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D7534C3BB
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:36:24 +0000 (UTC)
X-FDA: 84098425488.15.F48F764
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2F710140012
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:36:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q8CYC5dO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762868182; a=rsa-sha256;
	cv=none;
	b=yL3ipCSq0Nr3wEEwGw5pD0XFbUhT/JgJT82LuJZznhrEOrjkXiOhB9oNj6VUfRvSvI1skt
	pa1sAcHmU1LbpSbxheeSV1n8NpDpJTwD+o02rAAu7Uz7oZdRrECRJ3E83cq1yqpJrRdWHE
	6FaVMETm+qmos3R5QtBHXAAn9QCTEWY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q8CYC5dO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762868182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JSjWYrocQfwFaqc/FEuBHYlJesYb/9NVMF9Hr5o9yD0=;
	b=bajXOxdslxSfazFVbkgk6AQVVC/mC6vV1UHhi3heLLHMc6nBzqcNlW3CXEFjIWGoZ6FFT2
	anqHMV5Ic3f64aS8aw+2doiQ+kczvRvt8eg98TvWjbhs8TbUaoqABxOZAv4n6oQ/QnvMB3
	B1Cn1Nsgv7PVhpY2obH9+vtjuWXXtgQ=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7810289cd4bso4207442b3a.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762868181; x=1763472981; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JSjWYrocQfwFaqc/FEuBHYlJesYb/9NVMF9Hr5o9yD0=;
        b=Q8CYC5dOifNKSdDCp5UxR9ecTK5pGvbhpKtfRm3xhLfjWez9VvQpCiSSzXwJJ9QDQ1
         GfK2xPYj1Jnoem+ObNVToI8XnWzSKXOUvK9r6YSmHMItI6t932haBDTef3zx2/8VI13z
         Ps7JG5cNKaH/kkyKtQsgjgElTqG7dElVbDDQyLJABXDuDUnvIVNHDWNVBLyMVbCunbmw
         X6Ok1khFOIb4HTdczG7+zl7b6OzvL+jUqZGRwcxKi7Lpt/SAFIGK0S+kVI59q/c0MIon
         ApjhDfgIFBRKthJqDR/O59jZbcJk7tAx2SgvklZh6h54RrW+wjnS9Ry3Dzn+pb+3a7td
         IBjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762868181; x=1763472981;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSjWYrocQfwFaqc/FEuBHYlJesYb/9NVMF9Hr5o9yD0=;
        b=I97csT/5r26BOwdVWGP6lKIdTBUfSuxGv5OIdMcKgPq8aK1Jiaw0Eq0jMf74X3VvrD
         l/bi9pOjHUSD7QTUFjej4V8Jx33ueoy2TK4+XMdClmx6NjNS4904F63q7Ho4T8KV5hPd
         4HGuFfX+iK4YIQ/WOk4+89jB9dJB8KZwdyfP3urbon2NlRY+KLvyJet+WgxSZfUtOy7t
         +Dcuy6jKCWnkT1vMz/P+srKmW8H53v2uT+P+vYdoAN3Z/DLYEpEVj/aUzDt/C2ZlpPq2
         xUTCxNYyBs/VwtEvc8m2wfYkHhopB9ut/cBDAFHVNkDbc5t5BRv7iMaxF5M4GiIlz/F9
         4TMg==
X-Gm-Message-State: AOJu0YweQ//eO+GGL+GS3KYy1Hu8jpQZsOk4xd5W2OXWGJppEDLZTg5K
	4rGV0cfVa3OWjUQMH+KpH1XmUE07i6Yrbdo6n0qpFmYwQ0kfir7xv7bs
X-Gm-Gg: ASbGnctBujiaWPBFoVNZ4qDF89CjpVTRACxAlxLogd6n5ohhM6+sevtudvTqnNmqRV6
	HVprH4k6tLcc3Yyeg6RzOTrNRVigEufQLUxQnWpWqLbtVYpzBpxGXorpk5u/B25jDAO8lxIm3FD
	OSXylmWh5kxGAA0+DLoZktm0JCRPuZKJLr2n6GWicre93nkrrt7lQcyWu0aCGaE9/ZgjAjtK/2S
	usO/Q4dsCJt+wrX2WrUltLhuQ8U4PbcUvszFxxMBf+T9cDLjsS1srFcycOXb1EgfxvnTz0HOo/D
	VV2seqyBQ3ogZXzfiv26r6JgHgGoEZ7u3/oE305Qn9tJN+ruU80dN+eJEOrxLLMQXQUxxlQsxR/
	uLHjXC7Lg4Yr3ejV11pncwYLdtat2VJNKrg6Ch6yr5stpBcXfqgEQCn/7ZaQMxv32ilkBv8zJPT
	iMKmuKfFMruaSW6MWPNGpNVmPFgs3QRNorR3RsPA==
X-Google-Smtp-Source: AGHT+IGb8HlE8JWSJkJpS1zcZZEBczySzg7b334mkzaQboKOCpDTMasE41mUoiJGlPM7Flg7CXU+DQ==
X-Received: by 2002:a05:6a20:7fa9:b0:351:118a:62a5 with SMTP id adf61e73a8af0-353a1ae304dmr16647492637.30.1762868180916;
        Tue, 11 Nov 2025 05:36:20 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0c9ff74bfsm15512914b3a.27.2025.11.11.05.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 05:36:20 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 11 Nov 2025 21:36:08 +0800
Subject: [PATCH] mm, swap: fix potential UAF issue for VMA readahead
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251111-swap-fix-vma-uaf-v1-1-41c660e58562@tencent.com>
X-B4-Tracking: v=1; b=H4sIAMc7E2kC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDINAtLk8s0E3LrNAty03ULU1M001KTTY3sDSzNDI1SFMCaisoSgVKg42
 Mjq2tBQBHfgxpYgAAAA==
X-Change-ID: 20251111-swap-fix-vma-uaf-bec70969250f
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Huang Ying <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762868177; l=2673;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=HeLp2ZoEZDX3vftvgCEWtbgmeYKyB9IS5uu4bOi2WgY=;
 b=NP1wXB3s9uZ5LCa0q45CMtK5u/dbQ6VfiNSojUKk74bIoCx+/UuzY877LLypbYFnbaQsE5yWu
 5+x4bAONzQKCDhqfC//W4zhw1Ds+YK0ipI/5kAQRfxPapBT1qcI5Tpr
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F710140012
X-Stat-Signature: qedjy3e39rxpgdo4pmzu3i1tqbp1df1f
X-HE-Tag: 1762868182-236051
X-HE-Meta: U2FsdGVkX1+jAjcapJhhxcUleHmIYtRK/7eYx8qWlTR+F5vRy8ZGVmCL2A/0+gL+yn4J1UHbNjXHolhUZfGuGHCqyxxTBx41IuG+Sx5f4Pypeph7nirdgjxJR8zPzH1y1y6ic3z60khTiNuDeIU08G27sJJPBOEJyCzI0ZaMw0te7xMR0gXDayZtDyfBDWb3JcIkYB0Yq7yvPWts+84htVZ/YCHQZ8eGRguK3vi93rW9aHGYdPXQYkEXd1C3eqQ6auX+CFvjxJSu8qZLLWUc6igYm+RuvGuOSOWmXRwuR0efuf/3RjdgVuVbWwNWIUWVbOz7sl/g7mSM0CQWxN4u3CJV6i1qijx5Gw783bgYkaCQDEi08PCUPBPGn7MZvRmfVosS8hK2Xz0betS9u6/nrzf0bCzug3jW8YAxgt3JP53xAp+NxOgZQjr6hh6T+OkdhmbZ4jzri7u13aI+P2FLpCnxqy1OfZvx0Xm4BzVQCChgUrRDiXXjjaawtXmmXyQ1Ii4LCJg0+IdOmgXOj6UsOeFc8bJdn12Y67TjdHjSxgJtHUZwWLOvM5H3URyy4QtO+zb+48zyOK8t5q3lrrTNv5RXhuL1Qc5uOxYWNoxiPIRoEmzboysLLXvLFt6Devl+ppsJvSqrWKap5o/o7xSFX7upw/Ej10kaocd/27p/gtX0AxwDzCL0DA0TWfchNQ99GUTCMSGHQfZqp6g6EGLSgSUqVZl+4aC79Wr6y24SKgqo5pSErJLJ+ebGxbAsjCYDhjFLK0vdDl9yIZ7Sr9IMNkhzEJ8F3jVRLwbiiHdj6+GpM9mb8ir7RbUAl7ijMX3fj1MJJboeDhYC6BJesBxcfpCHjDrEwgJF+4Zda9ojnxYDkLkPvDSdKG1F2OTr+ig3pvnkvyiVaD3Y0YNy4OVyYHWVwJkkr4x+A8tQWokjuu1aEcqrnfAcsR5+a5ykeczGoDIq7DgA/s8BKvcOsA0
 gQ6+dBBQ
 jgF0cmUlZpeXTNfruN2Cqp3RrCQxAy78m7wKIUpjcNzFgr2ebSvn8RpsofsQeqnUHqM07aLabm+p8VtLDvI+tA9i7bwso/nDyoeKAYY7RaqKPyP1Nfgsrpg3JC7wimWaq+5VnSdUTX7mVNZtfwdYN5xhpj4OEyD6JG+cMoCOHlsM/1TkNQ+EAg7QA6DoBaPBY8H76dS1OWGMtIDi42xXuTkB6XMEocVchn9/3tcYAbXTNjbLU8Vset/h0MdHVjHme1/ngSv2CqUb9xRQAf/05Ymwddq18X2iSY3FaY3mRTAHHAUqITSTzpUa3k3zzUKXPdOmaXiHjzmHo6fesgtceUn5Y7cqnfcVyn1iCw2NOQDkzto4of6Enk3odHkF9huTTzutb5axTcgeGWBrotNnAPeZvMetpd56SpKpnzHoPSi+YyV7wIHvb4gEbTI+yeqvm7f2qAe4YsFNUQjGUEUgGLpsFZJRxFL0zA7rt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Since commit 78524b05f1a3 ("mm, swap: avoid redundant swap device
pinning"), the common helper for allocating and preparing a folio in the
swap cache layer no longer tries to get a swap device reference
internally, because all callers of __read_swap_cache_async are already
holding a swap entry reference. The repeated swap device pinning isn't
needed on the same swap device.

Caller of VMA readahead is also holding a reference to the target
entry's swap device, but VMA readahead walks the page table, so it might
encounter swap entries from other devices, and call
__read_swap_cache_async on another device without holding a reference to
it.

So it is possible to cause a UAF when swapoff of device A raced with
swapin on device B, and VMA readahead tries to read swap entries from
device A. It's not easy to trigger, but in theory, it could cause real
issues.

Make VMA readahead try to get the device reference first if the swap
device is a different one from the target entry.

Cc: stable@vger.kernel.org
Fixes: 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning")
Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Sending as a new patch instead of V2 because the approach is very
different.

Previous patch:
https://lore.kernel.org/linux-mm/20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com/
---
 mm/swap_state.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 0cf9853a9232..da0481e163a4 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -745,6 +745,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 
 	blk_start_plug(&plug);
 	for (addr = start; addr < end; ilx++, addr += PAGE_SIZE) {
+		struct swap_info_struct *si = NULL;
 		softleaf_t entry;
 
 		if (!pte++) {
@@ -759,8 +760,19 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 			continue;
 		pte_unmap(pte);
 		pte = NULL;
+		/*
+		 * Readahead entry may come from a device that we are not
+		 * holding a reference to, try to grab a reference, or skip.
+		 */
+		if (swp_type(entry) != swp_type(targ_entry)) {
+			si = get_swap_device(entry);
+			if (!si)
+				continue;
+		}
 		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 						&page_allocated, false);
+		if (si)
+			put_swap_device(si);
 		if (!folio)
 			continue;
 		if (page_allocated) {

---
base-commit: 565d240810a6c9689817a9f3d08f80adf488ca59
change-id: 20251111-swap-fix-vma-uaf-bec70969250f

Best regards,
-- 
Kairui Song <kasong@tencent.com>


