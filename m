Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 172F0D64087
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8038F6B0095; Wed, 17 Dec 2025 02:32:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D82E6B0096; Wed, 17 Dec 2025 02:32:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB3D6B00AF; Wed, 17 Dec 2025 02:32:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BBEC6B0095
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:32:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C426605A7
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:32:38 +0000 (UTC)
X-FDA: 84228145596.21.7D94605
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 779C11C0003
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:32:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T5ORc/6N";
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYvZQgglq3AruPpCGYCizx0FTzSaTRzKdYal9LtEFnk=;
	b=K+XF1MP+6Ob9ENeg8Xh+z+btVUFc5gz1Yz4n40i+P5BTJU8bWSZrXaJ1xa8xWTjbT2BE+g
	hE/QrGr0W8xhT1BuxbqGrVtZyRr4wB560iC8gUUgnxclCCCmcUXOJC+7rQ7UITR3S/WVqW
	Q+oVNFYKoYt7ZkoTsopFzaTZR9jwykk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956756; a=rsa-sha256;
	cv=none;
	b=4fU1U8vINQHeP6eHXvLB72sy6sxY4ebmDjadg7aFo6QC9tBGZj9ecs5pIfGOIQsGO4jFkC
	GgX0c/LRKREwmc8xueq2InvDBwCQRK2pl/CM1hzlj3Mfx2UkcZKXN289K1EYTZ2X2mH559
	j8YVnJosDbLSLX7V0itNE10sgWuIE9M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T5ORc/6N";
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cYvZQgglq3AruPpCGYCizx0FTzSaTRzKdYal9LtEFnk=;
	b=T5ORc/6NzynyN75t5NLdbC/TN+V/CiKMrTESzw+PZr/EQRm4YPNNI9B4IDpZ3qzQYCPxeH
	DDkJEN4Y943MwYhsMvFQ5Auw0qsZmXdRaJ2uuvTOoQc+lWq0smWRfXT9CM0t+5XV4ls3As
	ABaeMLsbr7xgIQ2tXXD0YxFdDs/X3kw=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 18/28] mm: zswap: prevent memory cgroup release in zswap_compress()
Date: Wed, 17 Dec 2025 15:27:42 +0800
Message-ID: <cbd77b6cb5273b75fb2d853f368bcb099f52869e.1765956026.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kbpq3aqkgagewdjo9co8gwxbzdjmih6i
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 779C11C0003
X-Rspam-User: 
X-HE-Tag: 1765956756-104426
X-HE-Meta: U2FsdGVkX1/34TxvuHgDjA8FbN4+KvVliUZn+p56SgPCo/ZJUiVm+YHqIQ5RdfjJ2GmYlPh5dbM8Asd035oMs1qvhTn1eMiBIhXacyzj6yWGqxmNQDZQt59Csxeiemir3EV50//L2R5mJND6H+VMY7sx81fUfWuQ78bzme87F1Hl/8tQeLcCXgPI8+PPiTGXR860nq1yV8lTuCGTtMsmctFXPf7fP7XaHR1vPeKkivnsaRHR/BZJDa5PBHQdTQVugHvO1qqGR91zb0h0/yki4AjqwRUqm4UOF/CAn45qgmfZXUqIIk/tEkZDlSXXjU5QdjtlLTDEO70B7C+qKIWhAgkk5RHD76uVgv9Yi7Uvfmmg3Si+KxIW9tRTOzvk4bilbBm9cUq7R1Xxxjrxt+3vNV0PlwgTEvwpv7ow34u2mZ7iuXfLfBzBu5V/7+Y+rWrC83Hs7GdZZ5R5Q485FqKOzYn4TruO0CIuIi96llJ87z1dBAlIncR3JN0KF6q9n9j5I17rgydCNimmvAjISURoo/ssAe2lLHa6inr45f1w0Z6MltGBtUWS3CgQvxexuC4zXncmfbh88mC7c4ImYEqCcmk59hIAl2MCMwKUvoqptPhpbFajPcy3Hn3MsNvjifGY8DS+KELJKERLCweSR6A465UivSVENF7ZKbPnYajdmPsHSy2saZt0e5ckhfUqsFQBjmONeCBQruZ9YF6D0/elByk4y2b6Mx5YZug9Cto3YJusoL3IAMwXx1wlel7vZgxQTd4C+cev3MOVR5DzPpJn3mkq/Uw3zsoyBrvdduoxDe2RR4sfN8o26KpREs+zfzMe64eigZ6I8X1eTUmTf2UJ1QjYsmerifdhWyRrTNDB8mr0+QcNKYLTeZjNjyQiG7oTHAILRvjiY+85QIvqRijuRhNwPj+yFThI+X/erQYJCNnu/WvwGWzXrLXyXh1v1PkToO0DKCliSzF4DVZ7xPI
 qR5QbW3d
 ArQL0rxcB0zdxosVU88qnW/XbK74ortX8JjAXya6xDmNaNuxVxJ6SYV757lV8FJHpC5mGUKt/kinPJnsswmntEx5EiOYKdK3md8SnlND4oZC892NiuHjoeaf9+mf/QbxfV/CD5vR9CRO5QBW78MscC/2XG1UdLstfp1z4VCfv88DPg/3GmmUyGJG2/UoGVgAeStts2bj1oQkIPOhUGi+gj5G9QWuOxIMHXRUDBjU63gdo8eY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

In the near future, a folio will no longer pin its corresponding memory
cgroup. To ensure safety, it will only be appropriate to hold the rcu read
lock or acquire a reference to the memory cgroup returned by
folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard against
the release of the memory cgroup in zswap_compress().

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/zswap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index 5d0f8b13a958d..b468046a90754 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -894,11 +894,14 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * to the active LRU list in the case.
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
+		rcu_read_lock();
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
+			rcu_read_unlock();
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}
+		rcu_read_unlock();
 		comp_ret = 0;
 		dlen = PAGE_SIZE;
 		dst = kmap_local_page(page);
-- 
2.20.1


