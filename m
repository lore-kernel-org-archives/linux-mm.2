Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64C4FC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8640A6B0093; Wed,  9 Sep 2026 09:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 813C16B0095; Wed,  9 Sep 2026 09:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751A16B00AA; Wed,  9 Sep 2026 09:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56D186B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:35:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C693401F1
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:35:51 +0000 (UTC)
X-FDA: 85194321702.27.87701C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 83CE74000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:35:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lUP10OIi;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ppqQV4pamAYsPTCmhaUztf71g95EkhNaJEiPUVBmZoE=;
	b=GaSM5twnZqmmboqZCYVEM69bXgE9sfJWQOgHlBUPiRqWwU1XrOl8DSybrb/uL3xPowiFf7
	9M4khPbGDUHB6Y+gbL2KGJ8vX8uly5Kt4LDSE8eA4gIfiWn6SNZUNqkjHDOb2v6t79LaFD
	lm/DtOjlzQUyTNO7PW/eYlJD2fYhrpc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960948;
	b=07HrgtEfN/GDutvkok2c2aWGA9YKPMRryuQDRl8CHFqbnuh6PAD+6ioVehyCV7XnM22ncW
	PiI3ycg3ty0EwvVFJ/4kphNstUofDYpzN7cq96cHE6zcbQ7dfW+JATgXeD9lbuQ54QjqV6
	lHwi4REr63kEH2UWFHY7CpeBRl0TiRI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lUP10OIi;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D18F9400FB;
	Wed,  9 Sep 2026 13:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CCA1F00A3E;
	Wed,  9 Sep 2026 13:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960947;
	bh=ppqQV4pamAYsPTCmhaUztf71g95EkhNaJEiPUVBmZoE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lUP10OIiiOD0g1gKYxyCH57GeQCpOQLzLHyLszIH5wxx2hl1OGsyMlnlJy4o9hb9H
	 vTrOvVYAthk4gvleTtWAJw71P7fv0FXFCCXGNP8cBs9MBdObgrQ6MjlpBPLC/UPW2S
	 QX2T0FYx/bn46HOQjzuDWhc0YGbY/YL3k6D79wQHbNZbT7G+N1LGVnZ0OOvHnEvvGJ
	 9uRqg2cqO1vXaitIqGjFXRGf4ybQTmrIYuUF7g3DZjX671eT1b/hS56i9xzP6RED0F
	 u00fsWfWEkfTtbOja82QX9Qf+O/BwWhl6H6FvG+Jtl303l8DvzaWXdGCMUBbR5IwyX
	 Hw6rkhYHu33YA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 09 Sep 2026 15:33:05 +0200
Subject: [PATCH 12/12] mm/memory_hotplug: drop CONFIG_HAVE_ARCH_PFN_VALID
 handling from pfn_to_online_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-b4-sparsemem_cleanups-v1-12-008fc8d579fe@kernel.org>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1129; i=david@kernel.org;
 h=from:subject:message-id; bh=I1xFmYSCNfoZRtg/iuz9b+jqWmT7TApM4OSDy8PLZHc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIWJpgJMyzyvB65vL27f85kbXdLt6gbDzY/Yp6Yf8VM0
 q7DdL5oRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABP52MPIMCEkOfOdVfQq5xUS
 2W+mcbQLni1POiPosUizLu1HR5/6BIafjB+i52zNM5h+yPuoQ0/ve5nj2ncf8i+0Xq1Tdfdeq8B
 DNgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ej1oi8xd7c63zkrnxw18udeymwra7nqc
X-Rspamd-Queue-Id: 83CE74000A
X-HE-Tag: 1788960948-855456
X-HE-Meta: U2FsdGVkX196JXonajAgjlYhZL9T2T+arLWQJzziUlkQpZhulSzX0lODJ1EUwSIL6SW8qKKMCrkUGyQKqXJmw1SrFdh/1+2Iuds3wCtn8+8AJ3EHyeSrd1fTYyxHH99Rp3d9VneuqJY5GyfKRZXe97fn+fT5Wv1tx/x11ofjsDZ0rUStMYRB5umr24RUvb2fyl04qMYaNDigZ7R7i6Yg63PVBJkxMv5P5QcUSSC1VAo5Fv18FI5pwzK6zzEvojqMSE26KA102jhMX/54DJk3ex1KpzWu+oND4yvaAGFV+Zd/a6vh5QhSoE+aW4UgwSj8yA83mVTgsLaV9PmfQej36W5qN+gnoaWmM+PIF2bH+b6cTv0VAazXRK7DkLqXurpoAp4xfIK87g8h2YTcrDq9XMDSWteBoJCqWlK8kOottaQVyhLipjl3qtn4Ip5DflWHunr3R0xgHs9lS9AnCCmZm/I4uiooVlQr2QbT1hO5ih7BMg6D6/zV8KmyCNilZh5waQVAmz4LhlPqemdNFYYfZT4oYpJAHWbofQECtXMOolJfRie6xvvsRBPij6ANYI1g0HvStN8S9E5go0Jgj6SqIz9fDQRnoHWkySRcBgz24CMJIJSRVh3TlUdzetB4KgIqAMx88UaKxxs+qO4Z6J/Ff+/4RqxLQLkr78nw9OtHXz6Ik6vIAlAXhMzzbNgjr/nXWkUBVCX/4G0YSvUeYsprXCnf/4Wqcxf78CMvbNIQa4s/9heYhPogPmPasKL0u3l7+d0zfrCRF7ImBEmGB5yurItYgxmOneo2DhLvTlf4umdoFVtG8adsaB3/8glfkNZGp8UJMvWueV4A5pSnOnU5eGCOsCS4rwxQ80DpZYn/5KqsYCs14Pxog2hslGdN3DDa5WnWRQ7v+yz3qVoeUCJ7Of7EdFcyA9gSRvUokP8Rhnw7Q0ydrUIJ+vaQjF1F6ah4I2w/gcOqNhIk6YJZGHH
 ZItV0Hkr
 SD4t2d/MhTDLIpf2ZKzYXIQUH9/2qb++BKf1EFpDogczJgLdKBshACn0xfJNLLJg/ximeUsC0mahhxohQ0SX5/+LgRKvyAqWrJWindI06hDckB3ssV+xGDuGptd6M0AhqJfzAdRANR+cuoV0wU4KPgHBt0Ue1rSL1IefzAZAsm9//rH9yRxCFFNpB926C0dC2qWIobtuJYC02szksiDCKQBcsyeNMkjeAfnsXXE3XxcwnXyic6uuLev/udSpt9AyNM6duhDbuNe3ehURhXo/nzIlQugu+ApTQuk+G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Drop CONFIG_HAVE_ARCH_PFN_VALID handling, as CONFIG_HAVE_ARCH_PFN_VALID
is never used with CONFIG_MEMORY_HOTPLUG, as the latter depends on
CONFIG_SPARSEMEM_VMEMMAP. Make sure it stays that way.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory_hotplug.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b428da66d279c..58ce35cb48f57 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -344,6 +344,8 @@ struct page *pfn_to_online_page(unsigned long pfn)
 	struct dev_pagemap *pgmap;
 	struct mem_section *ms;
 
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID));
+
 	if (nr >= NR_MEM_SECTIONS)
 		return NULL;
 
@@ -351,13 +353,6 @@ struct page *pfn_to_online_page(unsigned long pfn)
 	if (!online_section(ms))
 		return NULL;
 
-	/*
-	 * Save some code text when online_section() +
-	 * pfn_section_valid() are sufficient.
-	 */
-	if (IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID) && !pfn_valid(pfn))
-		return NULL;
-
 	if (!pfn_section_valid(ms, pfn))
 		return NULL;
 

-- 
2.43.0


