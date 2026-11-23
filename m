Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E492606A338
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OI4LOAcN
Received: by kanga.kvack.org (Postfix)
	id 19A766B05C5; Mon, 23 Nov 2026 13:53:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14CC86B05C6; Mon, 23 Nov 2026 13:53:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0623A6B05C7; Mon, 23 Nov 2026 13:53:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D42EF6B05C5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A58F40872
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:42 +0000 (UTC)
X-FDA: 85467282684.06.76EA17B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 66FD2C000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OI4LOAcN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795460020;
	b=w1MNyI6ltEu/KM83CjSEAMn59vBtiVQnK1NlRtWthY/qAQRv7gOpqEARvJW4/l9HWzA6Wr
	pYyZwbMNwmi6KZSnHn+JdUPLYzU/FVK2K+agRHEbimqDkycKG9exKl/7LLqKRY+PAV/syG
	Ha5yGY2f10ReSubWcQDZ3bsSeQh0oJM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460020;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S0g05G9qZGx4poDmgO7lZ71KlplbuRcjeb30J2se0iw=;
	b=Fo6oRVyC6X7cfx8q6d0NW/l3DkF1816hsGo0VaFhSM/yJg3Rf3D1g3v2LUmVIlQ9An26Kq
	v3yDZLk0YC+xAJ4Qn775cCIblQwrTX+yW/496MsftKeBmKwS2KtsRXPa44jl3oK8gCIKmX
	4rIvKjT9TOw22aOqccDyz3uFadYhlkM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OI4LOAcN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E3316141E;
	Mon, 23 Nov 2026 18:53:40 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460019;
	b=XlZNcG1eQ8UO3gM8pVnzANPdqacQycBHowY5SGrdhkfXgN3mGRJqGcgzXWWwZPbjV+k0
	 P5/SwKN+oPOGNN8mAxK577W2KYQUC4trJIORxfyNlESSpoWNJr22tun4Vxsb8O1+wk+8y
	 2A46zDGs0V9LZ5IsnUma65vaq3rhs+tReJwUU8M+G0wXh3kxehj3VJH5LK4YDQW+nDReW
	 jcuaSlD8ekp9MsM65F8FBmjGwLgZWUqgnt24ZIbys2vC5mhA0MVHs8UVTiMgmgCCA1gJv
	 42c+C4OORrmFrs1+A1lP+AGKSADkr7URFBBbKTNDgYUfwwDmQQ+wnp9Q2kjbRo8DnBA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460019;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=S0g05G9qZGx4poDmgO7lZ71KlplbuRcjeb30J2se0iw=;
	b=grp95qAAe8ok1C1VsANNaBMj6dQFGNEgLp9N4A62wiDqUIHQtH3p7PnfPV1DngYZ/ept
	 ddyFhTiC3lzky3qqRgDoW9Q1aVNPZn5J2ZDDS3pQivtXqOr9GddP1Wq2bKRdjtt70NG/8
	 tpbcbrxxmYZifrheH6AtSfUUXhkAcTTopdQXco+71ayyxLkb0UOYw0j6IodS9SyuO0m4S
	 zxr9h+ATB97DwSDBXoGEtX/2R6R++JZ2EhRJ/frGi0xc0E/l7MXjyALAQIKcbFtjp0NTW
	 SMnnYGUNeaTnfydTqeoiFZq5N7YZ7O63DLy7b4wk9ZkFUqOXTiTVmvUEjipvt/06vQg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 515341F0089E;
	Mon, 23 Nov 2026 18:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460019;
	bh=S0g05G9qZGx4poDmgO7lZ71KlplbuRcjeb30J2se0iw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=OI4LOAcN4E/4zVyXqI2A61Tlme4Iy4E3rNCQ7ChWI15doWpkJiblS4VzWnkHDKcMH
	 feh+nHj6jU5xw275gQGTxXx/p6m4DT2uM+Uhka39Cm+gLsMp1V7wtUdsrpVIbG2dOV
	 3XDNoQT9Cf3EcTlIsjW9Qt28hE4eO4sxQ00stEM3/FRKWb6HrMKB4jpQrhph5f15Uf
	 QOn2VcGUZ3rDLa5/vIotCHclUtYgkSHVfmoh/ccX03+CzoPOVYVehqV/bWTeYo78s5
	 OyZ+cm2A3CkhY3Zzp7kwzSTxqy2mbYJIX8m/qIZTWe851LkSVBEWnfIoos0yRUJbD6
	 dDfZZwkHX/q2w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9B9F14C65D;
	Mon, 23 Nov 2026 18:53:01 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:05 +0800
Subject: [PATCH v6 13/18] mm/khugepaged: convert to LRU refs based
 operations for MGLRU
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-mglru-fg-v6-13-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Tianyi Chen <hi@tychen.cc>, Kairui Song <kasong@tencent.com>, 
 Ridong Chen <ridong.chen@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=1410;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ylGSrEczLifu/DdmhwMoGhk6njBmtr2EJO7xuMx10kQ=;
 b=pXXLUep3I/vltYX0L1UH0GTTRjdiy0b3iBc9jWcCRdtT3cKw00OaEvGBk3uaweRY+TaoRFVrh
 ZG6rFxHmKKzBv05zdRFuW60YLUnIX7HDic9FG8ptG6NTl5y6QM0dqWa
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ipukiji44kuy1mwn9gsfj7wtaof1trhw
X-Rspamd-Queue-Id: 66FD2C000C
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795460020-244583
X-HE-Meta: U2FsdGVkX18j//frTWVmjvlFVNjRxWHwSCpvtrEwqXzF3E+sLDGMXOWp3E8y8bfyKcQRGmO38iCP2zRhUWvU7E/m7VyQHjCelf9lroO2vNt4nzxZGJ/ahBDp9ov1cSpV6FBTTu23+Gl7+W9lDdwD1GtPebuRvnwRKr9Ceu2vgLSyPSe3TL5l2nLcYUdDcF3XOWhjgv5MGKOtyKOiQ3YBXourdwWcMZcR6rYOsYqlH9YB1Jtyd0tu92+nMnkKKvHF4WBzs2aXak+3kMsqLaoI36rjjDyFlQjvdCCdgf1DH4DBr2MPgHQhB4vtUFOqATsq4DzfIARcQOJV+mkj2Hz2GbaksUnRrGBMMdPc33cg1yF6uXZ3oPwK4mnqqa0P8xRSCAdZMrsh8Y0rJVcI0tfOxc+2K67bHZc0bl0efbhqi9DEZMXvfOx9VNgkVEqQijhJYpqCaoB0XmKHRox9R6jRFw15RYaiz0A9dB4AoR8uC9PENUoO24Fr+HCsHk2HvaulX9jfuLqxMVPaDOQfjMSKKYfbIt9xacvYoCHKFtP1qDWBd3WiV1z9RdnNoDXlX+ohvwZr976HeWxTyi6GwrCxYuQKPAcH29FMXGrWOMzTN5j6ISl30t96ZHPNCTa0goy27d93ezF8/zPacLRjkVHU+25PkH23V5l/0ilmpuKLgbSdgtCyONvboBfnrrYF6NxcqxHgXTL5oDAuppW19KpiisP20dxN+VKQWoG6Ww51ECep4WJISnaqK/Mnws+ON45xS26KQtqZ632u1Z+Fwa4IWNYWUKcUYTW4DYMvp/vh6fewVq0tKsq7M2+hUKgU92G/EingyhckXKVPDAfue9I1IWemRe0/YbO6DnCPRhrGrpuijWzOye/lB3CXrv836o2r/mlu3eHeF3inUc8bpxPmomXYubjFvoF8cZ1g3DWUTDUgzzryxa4rTmj0k7ivO8ouSHWGH0SG5y03ryOOg2l
 KV61Ybpi
 XB9Dc5r4j5IhS1D+cdNCed3/xQPjv69gdgszMutT3mfz0BhawVp9AoHNz16FqSmqbWgYZrH+EJnUfLwETJ7q+WTATFlzs0ae1roY4J9e3MihgoQbvRScxA0x0EJgUsQFsvRmqCHzXs/h7F3FO1HRSguSjp9+9GMWIOec5lXgEAGFWmYtFFJOFXikGsvE5L8GrjMgvrB4dEq0BKCxT2wfVf6iY3p6r657g9spR25uu4MnOfXfyZ1gmp9O8Tr3r6yT3eJOh5uwpXEA7nk14I5dKZ6+Rj4t3ySHiJ1omfYp7ORPpK4wQWHmRPKi2QCA9rRCoLhrc7z4bTpTciJRUciC7gUoxeGQ00hkMFwDevqUxotRl0DP/DLLGyMHzXyTKtU7tfgpIUKc7MFavZKGmELJdqruXBn0ys6pz4K9l1furObqYxiQNDxQryRk8sbkUJdZUM1/VdICQBvBcaaA+fxBjbBUTaM4q49cI3cp23RvSJe14LLQtuJ0qL2Y1Nf7tkJtqiPSAUiKzmutc0ZT0gNVdvHkP7gGC2hox/4AzsWDg+1KIOXl7bj68lbqGI1OKZwc69QT6dXXCQKJh7e5+A8ioHxYJ1DF+0NtV7GjFnixBSB4Zy+IxcnrsBOOKK9zVNTSdEfkvvbzNKa6Bil3C8e8n/9yMMeXMQVxLHam+AkTN5SApPKOeNnJgTmpHjciVFsVQXv70rv/xo0ZMUTaXlRNQh/ue3cqqWxLmWtFHmtjvE2ObSC+ws8TteiZeXtx75IFYlC+UhcbLyF6+NGvg0CYFmvIdxwudWteF4gkC41XuSyPen3iYe3xVEuj5vTmRpWrbrSofDbBxLEnupFnhPmm9cZRPcsH6+DI7xgQ8H2ePU+/vOXAREpr6pwp6bQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
count, so folios with nonzero even refs no longer have the bit set.
folio_pte_referenced() testing the raw bit misses hot folios at
refs 2, 4 or 6, under-counting the referenced folios of a candidate range
and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.

Test the refs count directly when MGLRU is enabled, mirroring the
smaps conversion.  The classical LRU keeps the plain bit test.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/khugepaged.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2dc4245814df..5e768481ac22 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -579,7 +579,9 @@ static bool folio_pte_referenced(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
 {
 	/* The folio was referenced previously ... */
-	if (folio_test_young(folio) || folio_test_referenced(folio))
+	if (folio_test_young(folio))
+		return true;
+	if (folio_check_lru_refs(folio))
 		return true;
 	/* ... or the PTE mapping was recently used */
 	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);

-- 
2.56.1



