Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D999FC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F06F36B00AF; Mon, 21 Sep 2026 16:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB75C6B00B0; Mon, 21 Sep 2026 16:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7616B00B1; Mon, 21 Sep 2026 16:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B66DB6B00AF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:01:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 461F8A5A80
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:01:16 +0000 (UTC)
X-FDA: 85238838552.19.77B62E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7BC16A0009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:01:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lPA7bQ0Y;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AX6nGJVBYsmzhxob//RZpUMd+OEByTGb1my+643nlcM=;
	b=drUaKE4rp5EqlU2ky+cAQMucZd0vfwPov3DexGbEcFoT/J4ssLS7xkThSMs1RIC6JaV7U0
	N+Wr+CtgPrQ1Tw1E2efP4CsXdZ7Dq3nSTYsLC54Psw4hHF0kidNw1Sr5W7ql0owourKzg4
	uIrSNxhxOElPwc/sktj+t6gq//v3TIY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lPA7bQ0Y;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020874;
	b=zDM8xn5qYIIf5YhdXFpFviISjbp3seMA2tQG5yHNodJLjey0jcG6Xh6zSzSzuqEfunD1wD
	Puwm0zX4qtazSNg3Ni0aA/rxH0dfBoPhT4TbLZ0Kk+gnvLLg/gGOqaqfq4XWTfJ4G2TX4n
	B8+iR+pYytw0OhkFT8e6dui3dQUFj0Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F3281601F9;
	Mon, 21 Sep 2026 20:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142131F000FF;
	Mon, 21 Sep 2026 20:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020873;
	bh=AX6nGJVBYsmzhxob//RZpUMd+OEByTGb1my+643nlcM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lPA7bQ0Y8NxC0wuxHCH8bXKmGCDNvYNwrEnqOF9CaZeXU6vSkj2f3dtIY254mbADY
	 3wrcuT/NmJsCr5vJIcN2+Rz8l5EE0EOLaufW17kc9fxVSj7Frao5VgbBSKfe2t0+EQ
	 tQC6mXZmOFpNtg3z5krpUo/v1PYq89Cv8XZNO49C29i62EzNT3KJcJZFd2KG+E1ooX
	 TGojP2sXyqOw+85W+UJEEzDVsBAqzEmh33DjIPdbbGUJbarzWsQ5a0VtjQk2N1emnG
	 OalGVrUHAe1GmmuW/Z0uLwW3dHLhlQWFGXu15hYmBp/c5bFFtYDlku6c1HEPC81FYc
	 ZoHoVwdO7VSUQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 21 Sep 2026 21:59:04 +0200
Subject: [PATCH v2 12/13] fs/proc/page: clarify comment in
 get_max_dump_pfn()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-b4-sparsemem_cleanups-v2-12-54d81d65e125@kernel.org>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1209; i=david@kernel.org;
 h=from:subject:message-id; bh=kW71CGw1PYjxPgKG6zvCBhURTueD7ZfqBQYFE8KvMsc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI29rSJql0Rmifnxm7RJB25RG++8bZ1RycJLL/6xmvXc
 u8ejZNHOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjI1UhGhnkph/08EjdN0PbP
 n3Poxc1Ndb6bredc2LR4i2hVj+mMJycZGfb5KoXvrJq+fdGnK+LJ6YcM9y/Q+PPTvDG5Zm+v9EX
 H1fwA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7BC16A0009
X-Stat-Signature: 16765w85setd79ij7471o34mdiib8auy
X-Rspam-User: 
X-HE-Tag: 1790020874-693613
X-HE-Meta: U2FsdGVkX1/9IPMOUyx6SdZD5OTAVLhTXChcmJSTGUT6HJlo9yxXzNYxrERUlFge/vQOXbrKMNH5w80hVeoH9ByZYiF2ipOzw9ZWCo/UuvqTKrfFTcBhh2QLQgDgTcJGtJRu4uIamSw2hnug+IPrJ34Zp+PhsTVJ7ObQywyyB/PtMLC6yNslM7iXTKLeEpSwN3H4Oy+CwSDe8m64Ey/rWHELQvysVfgngIvaGURmP6cuIZDFSNkaEBdK0j2SJjDjTLj1uWN20mucJ055tJtFtRoutQ/Rgr2K1CnIgsBQk/uiNO4wutqb8Ppo25Uw+d5N94opt4GbzTY0QtqLSfUs6ONbvgq8gxH+5AapFXwQhMXa5MQqvMc6WnIxlSvAkWTYb16J1lUTgpjWIbP5YEys92MaMLF9BCrFFnyssGfTbwiyptDMtPTD+hzXh+j317i+N6TuVTJYqHPRRmrsmKH+TLj8qoh7bhA/o2dCsalebDsb8osUKOsnbNXbELz5bLeyRVewLpKNWCoydAZfte2tolyvP9FMpCNF4Wqh34DQfgumwHlO6nhDBC3nx855wQOaRziJUPxDOI/dHZrGN02pffSCibbRcqo31AHyG5IjlJTRNj8rVawQti0FTYLdfrLdhWc5ynOz4cwiex5XXcHSlwawG3VaJ7tIwPXfVZebhd2HDgLd2IozssF+QNcQnDv7NHPTaWOSjQN8cyEOpQlLUOmoezhtIdXx4mRy+J53s+DOeJu32AhjOE0UH0SPouKHoGj3gKm1K70JOmnuUgLdCfYRkaLzLzU3XuwGOiw+N26S46vgknmjhfEY2+7fI7dBy/fZA8D4su42bcsCJ830c48zaLVFObvK6tjkOW51Ln+uWaSF+FZ+QEDVBBRI0tUQOGt6zgtYUAW+EuS2Dn0xWxxC0jxOshBuv0LyErDTIfAX8HGXfsAt7AVKSsHrFhTS+HQXLYqcTQjYbemGW2d
 ng3AsEln
 ir51iMzqDOAfnEniwa8PR03c/+OIVkaSqFhfyOmoRF6kTM+ZzivNhcifGdvmPmoyHeIIYY9OSuteTG8SeGNsaJE8aTHhuIyWRglKeLW/8kXB7tm14V1hhJ1xbq1iXTneDaTYXQZDW0a8bCBa2s5b/QmU8FdmBPlD7z0d2gW2N3YV9fctoKHUhOmkloiQLftAT/wUBUiFMJYgJOasDQjoAupB5MEufrgzT/OpAjE8/NHPUxPOzG1oUgiNRhcOvEKVOz3V93GUUkdmcWC+8oBSov8pVDR9vusponiVB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pfn_to_online_page() will only succeed on some PFNs within the same
section, not necessarily all. Let's make that clearer.

While at it, rephrase it to "Allow inspection of".

Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/proc/page.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index f90e1030825e9..6aa99e42ec222 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -31,10 +31,9 @@ static inline unsigned long get_max_dump_pfn(void)
 {
 #ifdef CONFIG_SPARSEMEM
 	/*
-	 * The memmap of early sections is completely populated and marked
-	 * online even if max_pfn does not fall on a section boundary -
-	 * pfn_to_online_page() will succeed on all pages. Allow inspecting
-	 * these memmaps.
+	 * If max_pfn does not fall on a section boundary, pfn_to_online_page()
+	 * can succeed on PFNs beyond max_pfn within the same section. Allow
+	 * inspection of these memmaps.
 	 */
 	return round_up(max_pfn, PAGES_PER_SECTION);
 #else

-- 
2.43.0


