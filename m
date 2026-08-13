Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D91D9C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF4E6B0469; Thu, 13 Aug 2026 06:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97646B046A; Thu, 13 Aug 2026 06:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89096B046B; Thu, 13 Aug 2026 06:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6776B0469
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:03:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C186A2C42
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:03:06 +0000 (UTC)
X-FDA: 85095807972.25.7EB30E7
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5073FA000A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:03:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Uc6B1+54;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786615384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y20Ns8/o42YLbUNZyUIkw/RjdW/LS6iDwOmz4RkCo2g=;
	b=pv8oHs67XqQLQ+V5DrslMYbOOCjztCJ9GOycJjdmPAYfe6eof2dNuBw/zKjG5GvrEE8VEn
	eHsNL6bhfvncwoBBF+nCrUYTWvWCdqWEvInBAVdGm4zqk+YRSR/qlHEF5is0qm6ke0H5wr
	AEgt9lHfk2mbVp7aYohEEe/s0A1qSZw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786615384;
	b=olvXa9fZ3myx/bI5EydsWfa2Le5+HvQUW780rH2HpY2H8+T20An9VO8X6v/H6NIdJDL4a7
	9mCQz7OyuGiZFK7vLNEcIO35i0eDkXUJZgsuAXTMZHTpoboPic98N/ecVk7v/9WrKx9l9G
	IFjBCCMFwm6EDOQHmYQFyn88GyZC7dM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Uc6B1+54;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=Y20Ns8/o42YLbUNZyUIkw/RjdW/LS6iDwOmz4RkCo2g=; b=Uc6B1+54cds4o9pQiQUqSOQnJj
	Iw35vhsYmab52ZbTRJti+wIUS3gZ1DdEtWR3SLfj0cuMAxcDV3yVPOhTwkruzbyXorE9qxHa+Scq7
	62828SI3KU0CPQBuaVHqgjawHCqipuW9Brug0193uZ/1R7S7o74F/jkd8A6G8znA9Zv729ZJEKD2W
	1Y1KZPppAE+W+g1ENvoI1jheO7/y1zD36+Y9zHZw0Yov5uhv8+SIiKQ3UE+9LPjzwt1qwhVa/M7kk
	pVCpXJX+enUYXgM2KdsFUdCrMFi4jIFEgRdx4NBvcG6Z4gENn2/bss4cjAaL2IdPu92P7sEy2jesK
	O+QmRN+A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wuSGj-00520V-2U;
	Thu, 13 Aug 2026 10:02:38 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 13 Aug 2026 03:02:20 -0700
Subject: [PATCH v2 1/3] mm, swap: ratelimit bad swap entry reports
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-v2-1-4a625ccabdae@debian.org>
References: <20260813-swap-v2-0-4a625ccabdae@debian.org>
In-Reply-To: <20260813-swap-v2-0-4a625ccabdae@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=1410; i=leitao@debian.org;
 h=from:subject:message-id; bh=tanX7f1b9c0MmsWbxVq9RS0LlQm73iyrFiiu0xCz+SY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqfZYwUNV/hsWYVXh0g9Yl/bbnTzarJh+bZt0Dv
 YjK4FGOAhKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCan2WMAAKCRA1o5Of/Hh3
 bbjeD/9wylsh0OoUfAP4Sfl4AOZVYZSdOyuXtSPCArhrnvA7XBNQ029lqt81WKo/905j9kEqNbh
 gr/9oo7wEt/QZpUHcyvCZ3Lw5DWzTe8DkSBDFYZb6fvnruBSA4IRXfz+0Iow7x6TKSLt5GA/czz
 LFx8trtpgKTX3AJKQj7KhrOnVjWz/RtcAnbVqMlsgDnBHg/+RkD2gbf/H3VW+J/V07wpmq1v66z
 zxx8ASEddvix+EBFJUCYByNjTeZxd2ZEWIvGPEgr+82H9gyHtdcyTTyRw36CKpAq/i3fpZvLBBx
 I1l+7X0NeVeBmGwuH3QYDJjj0XerakXaAtqfdKUo2CbDr6+eXgaDWaSHEsm03QgRS68mwiaSBfR
 /pmxoDTd7IQHZS1CcTLQky9wdI4lVkAjH7N0LGktdO4q9k4RmiheRc3E61+D32PJuJnfkUbkTbb
 QhY2HVG3D2G7EI4GQs3EgY1Od765pz/lkET+FOhkoPinOXHB8vVqP0lwdkkw8WmSBPd57QXcRVx
 Ci0W8W4qC1LNZMnisEZLeNVgBppJSmBrt5FvGIlJZ6J2et67g3iR/hkv436TvLja/b5jLbUl+Pb
 0J1w7Cv2jQdi8U2N563YY3hx5B0KHQHUun66XWrHnSyH12PV1mjPWnCCat8lkB5Kt8Lb2BkyPEz
 KX988srXNdlhE/Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: 75deczo7jw1yzugwcfjh4kez7ijwtqu7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5073FA000A
X-HE-Tag: 1786615384-787918
X-HE-Meta: U2FsdGVkX1+cNcUbOEMCTxUEpqd/0gPGzg8LdZ1ijk0dM4ohGFPtPDH/M2UEvZCOAiy/YYzbGKbqeaMQMlw4ZnuFaZFwMH4+17fgz2jofYES0cjJvs5egF8qUlj6Nw6dik+avtnzSLhEnGursQ5BBsqhxBwzhSa7UFxjdQzp6YZtISWpwAboC4CYKDiazaRiz35ixjEhmLHiGnblCKspm7a1jeUbnbhhD/RKaoRMdD75EeX5XP7El0lphek++vqXGRjNNx/A/XnCP/xqi33EEkBkioyaqQuKIrlMfvrwRkz7SmY1+t2OVanaCI47q7NZV8S+HA6fux/XOFu0gaJ3P9Yr8kYJ6oMeNgOFXWZOyE8nvP3hXiPeq3vSqj0HMGdSeS8jwdyVYsUwG9tUVi9PcAnCM6GLZO6F635bg4JppBthV+JUL9faEvcCd1Jn2BTxy4hgLaZct3o76cWa+badysK85IRA4x7eQCILCnwMUiGWHHjaahvgYn0rNKcsL3BklwV3JT1luhZWf8GXKAGoXNutuKG8+onIz2ikmoqvNUqZkyLemXj8ksPewFJxwHHbNYbDUPdrWFn+NY1NTwFe6pi+ohoq2UFtmlFM/0iC6qf/D/cncrx6vtHIxvk6GWtWhUpj/6Q6XTLhtZexw7lHnG1LrDDhSIWjZKArVP49BCf974yHAfNnuoxRm7I8dLuPTRqJOexHH8AKMMpdzf8SKo1xjBrEt8jKLYcMe+blzYK96VKK6ErvgbCMc6cd8JgzM7Nzb10vHEsKAfAKGPUFBFYDw3+kEI1DWK5ZmoicIp2vQz5NywFc9eMvjgrW0gJWTYhaukc7/YZhT5z7zLVOJ7BLoQqXqIDLxZmnwKwlEEDOd68Qc3WQvSCNBl02avdPg9SnOcPefIiSn5WmHepMw2h3q5RzQ+oG48pTO0KgQuoW6/vH2VdY8VGNRimDTAQEitPoyKd0j2b4oy6sjvi
 sM+jq1n+
 sWSwGguud62uFp1d0h1Ltm3nMXTLZETqjGN/DqAySd7J1pAnr4hXlPVGIgRGU/uN94gS54BBEk97EMmQSgF2IJoWOybRVeSHBv/PMBLZVreeNzy6HHos9FQ4q0K+J05Zdi0a25pn/KEh/7m9g34P7FVRRCQq7WUGdxZt49Uf7qKERz3WpufhTanOHiwIjwkhAlIbQkzZobhErIdAj3RpWjpnzNzCbh3+vepZsCLzoFKnb4hlGhP/KhD25GR5GWeJ6lAUlcxzRNsNoJGQON7bo9Yh2OsysJwalAdWaggp/i3ZKFA1Ux8yveHtKIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A corrupt page table hands the same bogus entry to get_swap_device() on
every access to the mapping, and every rejection is logged. One machine
logged 6185620 copies of the same line in a few hours.

swap_dup_entry_direct() prints the same message from the fork path, once
per call: the WARN_ON_ONCE() guarding it warns once, the pr_err() inside
does not.

Rate limit all three prints.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/swapfile.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4d4e3e3059f6b..31c8a340606bb 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1899,11 +1899,11 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 
 	return si;
 bad_nofile:
-	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
+	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
 out:
 	return NULL;
 put_out:
-	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
+	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	percpu_ref_put(&si->users);
 	return NULL;
 }
@@ -3876,7 +3876,7 @@ int swap_dup_entry_direct(swp_entry_t entry)
 
 	si = swap_entry_to_info(entry);
 	if (WARN_ON_ONCE(!si)) {
-		pr_err("%s%08lx\n", Bad_file, entry.val);
+		pr_err_ratelimited("%s%08lx\n", Bad_file, entry.val);
 		return -EINVAL;
 	}
 

-- 
2.53.0-Meta


