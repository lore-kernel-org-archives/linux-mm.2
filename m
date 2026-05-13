Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 926BFCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 047606B00CC; Wed, 13 May 2026 11:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13C46B00CD; Wed, 13 May 2026 11:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E02696B00CE; Wed, 13 May 2026 11:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC67F6B00CC
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:40:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 26DA716022C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:40:10 +0000 (UTC)
X-FDA: 84762807780.27.ED444D8
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4E26E180004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:40:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=cWvoBNcC;
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6+k4U3CigWMPa6eRngECurunw+EDs/D/cMRSqJBO8A=;
	b=lBfONysru1EyLh4ipvH5+A05nEiS4AjDahREs14aUQ5FZqg+ITJ951PFOm8zYwnTwhpk19
	+UDssG2Wv3fycLqV/nX87sVPKT9ggU6abWv8tGob5QauijW+rUSdhdG3sVf476/sQNa3xK
	f6iiH/eILqXgtGts0xM73eRQ/mlV0SY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=cWvoBNcC;
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686808; a=rsa-sha256;
	cv=none;
	b=is3iICbzaMu7XA2AfhJZvGkHggur+70AzLFxY0QKHjYXXhyDhkDJbRUV3JqZZIVyRrQa7s
	Llx7NeuMn2iHMdAjNaqWRrlcHLx0rVpiplnNkg/ODGY2pVfMFEztg/ToHTtz0WJFiW86Hl
	qW2wecUK2o0S7kmZQ5pZF/rA6h1O6cQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=/6+k4U3CigWMPa6eRngECurunw+EDs/D/cMRSqJBO8A=; b=cWvoBNcCwzDa9aLv5h70R/mcbs
	PIWp5U14kA+Xrw+I4if9aIU6wpGyKgfEhW5Y8Z7W/D5YckhnxvCaaQShK/YvNegvCluvX6yQLR/I7
	/PCeMjL+eIqsrTyTCpunIZzfvQtNLT50jVVytGljcbyenKQRWoOA6ARdWKsCtWR7EsNikscFT1oT8
	Q31u/fP8EP3hLxhQCYHXWAmhAO3eL+gVi2aXdqB5Xx5LDLsT3nRNcZEJwbs7ClJEu+tlMSUpvft9g
	JwNERdRpSxbdaRYyLwJ2BLhoxkooUqmwnulAufiPZuJYLkL6Jbm2hBYUKd4Gb2wTf6HyGICLxQRt9
	d3wcpdlg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wNBgo-003GU6-26;
	Wed, 13 May 2026 15:40:02 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 13 May 2026 08:39:34 -0700
Subject: [PATCH v7 3/6] mm/memory-failure: report MF_MSG_KERNEL for
 unrecoverable kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260513-ecc_panic-v7-3-be2e578e61da@debian.org>
References: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
In-Reply-To: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2392; i=leitao@debian.org;
 h=from:subject:message-id; bh=aUpEGreCiiwo7XiCDP3nHwzdk2ozZEEtKzqxsRLQzJQ=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqBJs7vngK9RETyLDF63o1EnEfYGgE9nv+9reDZ
 QJAssZ8oZqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCagSbOwAKCRA1o5Of/Hh3
 bVBOD/42fbJ1SIKiXMo7f8f99fs30cZrVejZGjSwvrCi8ZkL5L+6m3DTmQ9ebEeTvLyJl4tugs9
 nlyHwMuz2XZTExQHD/s96rlCtCq1qZuOTdiwBJMFxuWzXLcjFsIV1Pk5p7Ug0gZazN5eDuxRMxG
 4shDiaETS5V3LOP6yuIBje+R60oa0u4UZ7BpFNswvrtQ06gQr+iiH8mH/FoqCJcauhUfCg44MEU
 3aVobIQLqrcxhagv+UPkqlQ0y/pjxnq8MKzwg0lLdhJ5asf1Zy0f67ryt79v1O+NtZtV7RVdA8z
 pOkfJGHV/nD1WCSuy0iZHfgBsanH2szAR1791eyvG4czAd3bMen/vUDb00M/wmz2ppZu6fFqsVP
 TrP35jSeXKDgHqw41fkSddZ9V3MGXLcRpzrh+58jy6izLx1oFURAV6J7Ff2n20bMyTiIKcbP3kC
 uDmTAz9qcMgUzEKJe5YzkbvDwmtcw3B9hYbMKO/mdY49Bx62MuQTppPW+vo0IYHfaJElcvhvZ3H
 BLsLQSX03QA+kZyrb7NTYUctOHoTx3s3vRugPznfFbGM/74kjm1SfEBY9QNyAUJtckjPOvp6JLS
 dGe30VDx4YhSX7UDwzSpVH2eNfHaDpHe5Jsfsv5Szg2+g/v4X6bkY7lShw0liPepWBqZEAuKP3d
 MNdScg4izAJjT8w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4E26E180004
X-Stat-Signature: uqyksrnfaj45yz9buuo8fgj6je5a98my
X-HE-Tag: 1778686808-364049
X-HE-Meta: U2FsdGVkX18GlJi8GY632B5Kzxjr03J5wLmtD9zxyX/mZ6oxRvFRtvlRvw59mol7hkpgtb5/GF55Sc7WRgIf71e261ZrXtiB/gP9KPxSlOGAu9bcgOqiJXzzscIjMhpTkJFZFa/8wz3DsF/gLF6VRDqkQ6cgYuJ8bJvUjINi4Lf08m6YRICLI8ecm8QxG2r79hMimpfiwfGQ1p8hMt9KyspGSUUfjTwwO6jv6lMD8dFRsM+aplPCufujHlM+soGo9LxjSuoQOpcNI9qc8EC4FAKBKB1/KKQSjgOpUKliHMN7AbOMhF7bXQi3qIX60i0MDu9B8adrJ75tlXKVYFIFW+/lAePwxaScSHvnNpVQHCYGaW6TFdyzHbxcQScjj5vD54I/MLihACh+tL5zH4u/KxjKLEIZ3muuuvPOpFyGKGAVKjCQJTadVP0FSESuuAwCAk0NHj8dkcmp1HVqvCIr7HiWlwB4c5t7SHfl9GGlcbfu9M8xZq4UZTCfAI8XE7IsRw8H/Kqb5aKd/tLLVf3jfLqHv2YHH31gQ8qLd5m9mOIoRPZ6GB11I6LGqBb6V36HdTBRaZVB8TcErToJTvVjvnfTwMXwH0U6X5lfi4d6wOp1a6QLQpeNrym2bMHQqIhlHlF2P+xKBEeULffTHX1Gg8vgO4w2CvRuFai0rhtbePPZK6kIO23IBSXCn2/d25AfJnOSQBJ4J/ieFAvW495uZwBLAhzq3xVh95Uc5BCZPY3YbIZtEfu8rmR7vvMussMUiTKt6gUSNt/VrN7hCT2KsT9NluzXTTImG80Z2Vo8ovhOYAgCkX8XgK1zJORqvNc4cVASzK7g9clkrYeykU1jKdM4Pc2aie7uic8JLRL+ovHB74fTUyNFTa1W713LrSZgMR3B2wAjKE/taesVjNnoG+gFAsqEZkoLYsy7WQ/gEqcru/NjBoC6fCe2Str1zbi2/0pn5HafiBIIWoKTpU0
 prAlIAJK
 1GVixOSMJgaz/rFwWUYSHXYVX+cVIWzrbnK8vSrsJ87YKy3HX/Jvz7RRkyKMwNVQ/WH70Ytu27P8CmEBrOARDlniFae6SB4+GVxGpwGKVRViB+MozFt+bMiSZWpNxOWLkiZfuBY+H5CH3jL+vMokKLRlu83ZEteBUZU54ju/0rvgfXweJyANbpeUQ7ZZD0gb8qE3Bwh7d1DigbD268HbnnOqpU7j6V8fewW5hX+znUVQ6v8HxMbTRSZy4mgUiIAN8XOFPK3e/uM2W1f7QGF0PJ3eVZYVzR5c+QMyiVFNOu5dAnMCeuhY2Lcm18UQkG/SXuT00cYtVtBdFyZGUCjqcoRORUHHCBJxEIIxYa8ESfdYgBOkjo24t+bF99EXf0SeAQ3A0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The previous patch teaches get_any_page() to return -ENOTRECOVERABLE
for stable unhandlable kernel pages (PG_reserved, slab, vmalloc, page
tables, kernel stacks, ...).  memory_failure() still folds every
negative return into MF_MSG_GET_HWPOISON, so callers that want to
react to the unrecoverable cases (a panic option, smarter logging)
cannot tell them apart from transient page-allocator races.

Turn the post-call branch into a switch over the get_hwpoison_page()
return code: map -ENOTRECOVERABLE to MF_MSG_KERNEL and any other
negative return to MF_MSG_GET_HWPOISON.  case 0 keeps the existing
free-buddy / kernel-high-order handling and case 1 falls through to
the rest of memory_failure() unchanged.

The MF_MSG_KERNEL label and tracepoint string are kept as
"reserved kernel page" to avoid breaking userspace tools that match
on those literals; the enum value still adequately tags the failure
even though it now also covers slab, vmalloc, page tables and kernel
stack pages.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index bae883df3ccb2..4b3a5d4190a07 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2410,7 +2410,8 @@ int memory_failure(unsigned long pfn, int flags)
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
 	res = get_hwpoison_page(p, flags);
-	if (!res) {
+	switch (res) {
+	case 0:
 		if (is_free_buddy_page(p)) {
 			if (take_page_off_buddy(p)) {
 				page_ref_inc(p);
@@ -2429,7 +2430,19 @@ int memory_failure(unsigned long pfn, int flags)
 			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 		}
 		goto unlock_mutex;
-	} else if (res < 0) {
+	case 1:
+		/* Got a refcount on a handlable page. */
+		break;
+	case -ENOTRECOVERABLE:
+		/*
+		 * Stable unhandlable kernel-owned page (PG_reserved,
+		 * slab, vmalloc, page tables, kernel stacks, ...).
+		 * No recovery possible.
+		 */
+		res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
+		goto unlock_mutex;
+	default:
+		/* Transient lifecycle race with the page allocator. */
 		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
 		goto unlock_mutex;
 	}

-- 
2.53.0-Meta


