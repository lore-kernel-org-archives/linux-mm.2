Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B7AE63F0B
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 19:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7A4E6B0099; Sun, 15 Feb 2026 14:09:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07056B009B; Sun, 15 Feb 2026 14:09:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2BB36B009D; Sun, 15 Feb 2026 14:09:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 793EA6B0099
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 14:09:20 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E5C81CD80
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:00:49 +0000 (UTC)
X-FDA: 84447607818.05.F613530
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 24A0B100005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:00:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LShGTUaK;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771182047;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYIC/qIlONGZYtOPMXl3t7HkwCD9MiX2OTNWNoz8qm8=;
	b=OQB1f2MSASXTdh1SUfn2OuRQtN5ryxxST9oLdBcNPUqyHGivTV5cIQJai/Oqrb0Q4DjlgG
	b8GV9wY21YbKuEv6RqcKfXTJRY25xoFaF1NjhIlB4jx9zWmBHtoZsxPTNZPMuRd3IDzlY8
	cUTyNsZSdLwSB24+KPxRJZjJ7VKThvc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LShGTUaK;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771182047; a=rsa-sha256;
	cv=none;
	b=r3QlC2Y64th5t4eNgbM9L+N9jQWibJSRYb2I/7dFVwwEtEHagAurMKux/pbnRRmtKnn2fw
	0ycecdoWD51yiXy4ti52Lyv56DgbmasKXEGklrxUU5hCW6sA8iuR0BvNmT15VsKXumLqe+
	0tgmOECSGOUxzCjmafgVaXcClx3PcVw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6565660127;
	Sun, 15 Feb 2026 19:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F206C19423;
	Sun, 15 Feb 2026 19:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771182046;
	bh=ijCT+Mg7d3790XUMIRWeaMLVEKai5+A/PxJRt61VFl4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LShGTUaKXyZSjrhS6kwYIBt9hwvtSZhKlGZ3HR5nedonqog3puYIOht/6vFCjqTal
	 plQBeXpP/93WLZBN6lsrIvrqsqhSuqp6SQgf4qRj8bi2hf1RRyEmrT5iPAQMW0KGqv
	 W32voWw9gmpyrIbRs62TdMAElqJ9DZa+0NLjrAw3cknSmdgbEQ/V4XgNUtfPK8Xwpz
	 B4i72hk0ZKsxsuql1hIdGObH7NMvKG6VVoCLpujon5PodgwPCBZbLM6TN3DrG/zQgo
	 oRd4N/sGgPQYeLP6fjRp6pbo4vp4ZKnPhvlZrTZrC7d9aieSMiTjd5hB7T3X4D+IEM
	 6m3Xjc0Rplf5Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6A4E63F0B;
	Sun, 15 Feb 2026 19:00:45 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 16 Feb 2026 03:00:25 +0800
Subject: [PATCH v3 1/3] mm, swap: speed up hibernation allocation and
 writeout
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-hibernate-perf-v3-1-74e025091145@tencent.com>
References: <20260216-hibernate-perf-v3-0-74e025091145@tencent.com>
In-Reply-To: <20260216-hibernate-perf-v3-0-74e025091145@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Carsten Grohmann <mail@carstengrohmann.de>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, 
 "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
 Carsten Grohmann <carstengrohmann@gmx.de>, Kairui Song <kasong@tencent.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771182044; l=2673;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=AP2Agry4RlYj89KzjPUleAMF+xnfApgEpjtkm4VqQJg=;
 b=oWPcjSUKtm8Q5thSWVCe+iAtBfoyhjpcOXkpVbNik48lhQotclHLHkRYpDUJ3lggMApH+ajKj
 ubJcoDilvf7DOAEJdCiVlTXLq6u98zsCp55n45Ahcmc5887iscwJsNb
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 24A0B100005
X-Stat-Signature: fm64uycguooxd5esdxejr94nb5j4qahy
X-Rspam-User: 
X-HE-Tag: 1771182047-923686
X-HE-Meta: U2FsdGVkX1+NRPkRWvEu8DVOW3w7w/+cHSo/Q68yISS4RrI7+M4dvtzgUZkRzMoK2mCF2l0SUeAzRmJVioz1HJNaf2a8CsubKfqk14qlWHJEE5kxS0cVO7UliJFihnWEDMYEl8piHE66oV37Tpj2ILVPuyy+4Wv8DAqcGGcyl05kOwt7vL1O/Gj7TQW6l2WOCC+xWyoGjXCHG39OzRdfO5s1npWSpUSp2tzzF3YSZwYqduWllohWLYUus4QFwkbLKGDHolOeGsr5uMRF52PALKxxF9DAjfUbjzP8YLUKGVba2vDU6UsVxQT6r3L/BlI3fft5gSnya4Mi6rcotHHICZLdoQE1w4QiuHr3CwGb5CyOA2bnuGJivHdxJiTOOmmuYoxF6AsPUrnt3D7+FKomcx6lSomm3567bOUu4zcGIq/2mS/Gjy+Wmn9xM8Zmj+HuV8N6ZLn0e1+EnN/V4QIGwqVF31NBKf8PxUSrN1z6ttUwNu6Hv2BM64tAla9LL5F0V/T6pCmjE/RHpWkl6HsbSAdr9azow+nJgq4glWtSuHkzmMx015IsW8EI15OhzDDYOEIlEkNPHrH6quWLBEpiprvO4piZqr7LHutp6me5iCjtTavu/5kRcURVRuKXdiz62BeAiTv9nU3qWqWxi1nbhywlhHiqRMFAx//2BSyEIpBaGzyZ/gqWxadsFry1ZuE+AFrYTnkTan/RrLTAjKBTGDqCWxbgf2LJMY5AQ38gA0wUM/uSCkG7utE9bOU2ORgGKmu7hSjUDuiVqMZIN+c81yAcHJ1oXSQVQDxBrgsU+zmap8zUKB7DhzLzS4PbSmbizhF6Egx5xGNo6jmRIDIMi0xelx2guu17lQT07BvJXaapq2L/tXwlPwj6uRp1gZyM6D2wzhBj6LAUYQXztELFrOl5waX+3KvMbfVxOfmu+wAGspQKXZD7MN6HJvcLMJzjIL6kPwx8g17FfnXIJZj
 DQ58JHAa
 1QYMOMHuWQDoRjkfwgrsMSFDAxxpjOKJSmAY4iHoEcRxvYPsJc6u6RYH/tcpz3pdx5NwV4h0GScDH9lHsKAh8nTU9eplvvsz4enO8Z5bYe9lg9TBGZjOA6otrol7vkqugRLvhHShusFXC6VENe/VWOpuk780F8gNKrdHHmBAL+oAWcxjSgelnbJpGwBHzdHikCkfo3aWWzguKfuz/Q2MVoPgnaOZAasgDbRic4JIlRWwDNFtjcvVFo9Xk17meoXCWZk1TJ8Q8Qk6Hbce+qGnO8WOWab9DjFOo6K4BhICliDZ6z0byDOHJCWVe5NiMll+7Ly05csZGa5Z04ObK3QepmIQMSTihqMEtjfz1ulGuII6UnNSMBIFMMCPzx3r7f2yZD3Jt/8/p0hfFX2ToXOBp0BFx0LqlGruITOy+Bm5MCRO9JdbljS+utLd1BrZ/tPJDgBcs333qZl1kJo4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Since commit 0ff67f990bd4 ("mm, swap: remove swap slot cache"),
hibernation has been using the swap slot slow allocation path for
simplification, which turns out might cause regression for some
devices because the allocator now rotates clusters too often, leading to
slower allocation and more random distribution of data.

Fast allocation is not complex, so implement hibernation support as
well.

Test result with Samsung SSD 830 Series (SATA II, 3.0 Gbps) shows the
performance is several times better [1]:
6.19:               324 seconds
After this series:  35 seconds

Fixes: 0ff67f990bd4 ("mm, swap: remove swap slot cache")
Reported-by: Carsten Grohmann <mail@carstengrohmann.de>
Closes: https://lore.kernel.org/linux-mm/20260206121151.dea3633d1f0ded7bbf49c22e@linux-foundation.org/
Link: https://lore.kernel.org/linux-mm/8b4bdcfa-ce3f-4e23-839f-31367df7c18f@gmx.de/ [1]
Cc: stable@vger.kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c6863ff7152c..32e0e7545ab8 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1926,8 +1926,9 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 /* Allocate a slot for hibernation */
 swp_entry_t swap_alloc_hibernation_slot(int type)
 {
-	struct swap_info_struct *si = swap_type_to_info(type);
-	unsigned long offset;
+	struct swap_info_struct *pcp_si, *si = swap_type_to_info(type);
+	unsigned long pcp_offset, offset = SWAP_ENTRY_INVALID;
+	struct swap_cluster_info *ci;
 	swp_entry_t entry = {0};
 
 	if (!si)
@@ -1937,11 +1938,21 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	if (get_swap_device_info(si)) {
 		if (si->flags & SWP_WRITEOK) {
 			/*
-			 * Grab the local lock to be compliant
-			 * with swap table allocation.
+			 * Try the local cluster first if it matches the device. If
+			 * not, try grab a new cluster and override local cluster.
 			 */
 			local_lock(&percpu_swap_cluster.lock);
-			offset = cluster_alloc_swap_entry(si, NULL);
+			pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
+			pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
+			if (pcp_si == si && pcp_offset) {
+				ci = swap_cluster_lock(si, pcp_offset);
+				if (cluster_is_usable(ci, 0))
+					offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
+				else
+					swap_cluster_unlock(ci);
+			}
+			if (!offset)
+				offset = cluster_alloc_swap_entry(si, NULL);
 			local_unlock(&percpu_swap_cluster.lock);
 			if (offset)
 				entry = swp_entry(si->type, offset);

-- 
2.52.0



