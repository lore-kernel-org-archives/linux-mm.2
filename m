Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FEE0C61DD5
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 807B46B00A2; Thu, 27 Aug 2026 05:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B85D6B00A3; Thu, 27 Aug 2026 05:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CF476B00A4; Thu, 27 Aug 2026 05:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE256B00A2
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:45:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D12B540396
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:45:55 +0000 (UTC)
X-FDA: 85146567870.24.D39EA99
Received: from mta0.migadu.com (out-201.mta0.migadu.com [91.218.175.201])
	by imf02.hostedemail.com (Postfix) with ESMTP id E220680003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:45:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.201 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823954;
	b=TZxdUKMdyjLd3OEx1EALDfb4gsKmAmhhFzBiGP+gjHQz9UKTaUqZg1KMFaTkbvrE/QF8vj
	ViAslVjoUrKqDvunmIX4N50pjTG6kXggbRB7j9JCjp/YQIaF/ZLTN/2I/x+5xlGSt8cIIA
	9TaUOoHdU8l1Q+WXU6hf/XooAC1OYTI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.201 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YQjCFE/6nKW+yviz+5DLsw7WyTIhvTPpK+d1F4iHiy4=;
	b=WV//k98HBGWYPhgVvHfzpqBL1BJ/6Zcf1C69X5n5VxORNj24W6ORGtnkWfVvzgLhaUUUdI
	e6PbA45PyOM0CWHmcwcZbQrHOavSwifQSuUbO8rYNylbI2k8umWskUFhZvmW/A1YQyg4hS
	GAVx7Kuz+JhAp8aJdrcI6GtaPh29At8=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8048e88cfe4c95cd;
	Thu, 27 Aug 2026 09:45:52 +0000
X-Mizu-Trace-ID: 8048e88cfe4c95cd
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 07/16] mm, swap: add xswap grow trigger on cluster allocation
Date: Thu, 27 Aug 2026 17:44:57 +0800
Message-ID: <20260827094509.1016740-8-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E220680003
X-Stat-Signature: p37p4myez6oysizfaz9ogbuwnsc7zrsh
X-HE-Tag: 1787823953-890456
X-HE-Meta: U2FsdGVkX19zw2YhyUU86bu5wpsrfF4N6UE0WeHSsWphvScCslyYj8XxR9DPXvSTcDKXCDzA2NewZipmtD4Llp8QrfvcHc6HTs9pZTkq223crczyIz3kbriNKYzJ++fxsSEgC+z6liG0MpqmbCTr7V08MdooxUnFXG1p4MxHg1Md446+bZ0io79KFlrxB6r6IuHMVjHL9jmzp99wGmUBbpYXkhNhbr3/PrQSABgioYhBVLmXGmVvyFwFhiM16WPLFq4Z52KgHmGm4cEOwoJ4cyPK7TJ/Z70EljNFVtxtkS+wUstxdoNgMBUw3c31Sk2IF/dh+FpjHKINwaP48mj8xxknTdpFXmBt7fZ+Sjp+QIyAHqgf9VP8gaydCFHx6FcDeKhDliCdVyxvedLThY1nH5u5a1sxzFQAQA2b3I5zUcyGAUaH/+Oy9PexwTGgEkeRj+JYDgGG1GASXeeBkSpIzXvJj4MoKt1oKLHpdI3uogizzj6gT2iJEwof84VPXuNIsGsn1sxxL7mYdoX/M3+cC6jWWv6Yuoy6/6lgZWxJjkEHddfhRHSZqm7XyfoDUeZbNChuxrcGAgBzDDlM/8ATogKV3usmcG39lFyAmc5+ODV/54S+4FM7Ik+062d2VdLvx3Gy1FZryMwpV42IkcyeDxJ8MJIy1cHWh/oyZUdiMFpV0GmGXm6PR/NxTq3bcK6AubkUfbol1O5JI9UplRbgCV3Tiluvw+Bsf9heyuK7fehlEuKTvR+cX3UW8BsVZao/3l6cdscRf+jOZ6YWSE1B/MfU0hN4z1KqXbuyVQkP75F4n/7/yhbVDI4YQquB9F95TwwcTF48mPhcDdg4r7eYWOkMW0x3w2KXn5nMXKoXwhjUJGEGyvPHdZQQm5G2HscNQovnYmzbznEUTTsXgjMfQQe4OMfb8Tb+uWSXEq8cHELB1CGsWeXCaWWbmcGPXMrLwyPTOqUV9AQKuTdUzlG
 aw4VRtQk
 dtV0sRh3GZpTOSwPpF1DVtG/HSYZmev/+Abd+JakeL7jlBzsa/2uAubPHhZmv+02z141LIRgpZSVKu+Bf5UhGnuBEWnsUdtDJnI2+VsUEhRZJQbg4VH6K9R4scVcjbB3HaHSxN7GvFItt/+QuVAdXURcwGNArIfl5HJZ7hIqROZ6ulPu33ihPTaeH9qT2IVKRQ7m2ZTWalamPHYJZ4rI5KSi1sg37sGz7k1V17/ULsawF2TCPCLNKCvt5Ejts1VhowUDHhNTeXgK+7miGX2V+VAjfB6D/GVM4elQdBjY+lkcQBPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When cluster_alloc_swap_entry() fails to find a free cluster and
the xswap device still has room to grow, expand the mapped range
by XSWAP_GROW_CLUSTERS clusters.

Since xswap is always SWP_SOLIDSTATE, no locks need to be dropped
before calling xswap_map_clusters(), global_cluster_lock is never
held on this path.

The grow sequence:
1. Check nr_clusters_mapped < nr_clusters and free list empty
2. Call xswap_map_clusters() to allocate and map more physical pages
3. Add newly mapped clusters to si->free_clusters under si->lock
4. Retry allocation from the fresh free clusters

This makes the xswap cluster space grow transparently as swap usage
increases, without any userspace intervention.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1127e3d6596b..c6a01d74298a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1273,6 +1273,51 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		if (found)
 			goto done;
 	}
+
+#ifdef CONFIG_XSWAP
+	/*
+	 * For xswap: if no free cluster was found and more clusters
+	 * can be mapped, grow the cluster_info array and retry.
+	 */
+	if (!found && (si->flags & SWP_XSWAP) &&
+	    READ_ONCE(si->nr_clusters_mapped) < READ_ONCE(si->nr_clusters) &&
+	    list_empty(&si->free_clusters)) {
+		unsigned long nr_new = min(READ_ONCE(si->nr_clusters) -
+					  READ_ONCE(si->nr_clusters_mapped),
+					  XSWAP_GROW_CLUSTERS);
+		unsigned long start = READ_ONCE(si->nr_clusters_mapped);
+		unsigned long i;
+
+		if (!xswap_map_clusters(si, start, nr_new)) {
+			unsigned long added = 0;
+
+			for (i = start; i < start + nr_new; i++) {
+				struct swap_cluster_info *ci = &si->cluster_info[i];
+
+				/*
+				 * A concurrent grower may have already added
+				 * these clusters to the free list.  Only add
+				 * clusters that are still off-list (NONE).
+				 * Lock ci->lock first: move_cluster() takes
+				 * si->lock internally.
+				 */
+				spin_lock(&ci->lock);
+				if (ci->flags == CLUSTER_FLAG_NONE) {
+					move_cluster(si, ci, &si->free_clusters,
+						     CLUSTER_FLAG_FREE);
+					added++;
+				}
+				spin_unlock(&ci->lock);
+			}
+			WRITE_ONCE(si->nr_free_tail,
+				   READ_ONCE(si->nr_free_tail) + added);
+
+			/* Retry allocation from the free list */
+			found = alloc_swap_scan_list(si, &si->free_clusters,
+						    folio, false);
+		}
+	}
+#endif
 done:
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
-- 
2.54.0


