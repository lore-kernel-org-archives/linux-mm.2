Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB89BC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:16:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F0606B0095; Wed,  9 Sep 2026 12:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7C86B0099; Wed,  9 Sep 2026 12:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE356B009B; Wed,  9 Sep 2026 12:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAD9C6B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:16:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21E7AC028F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:16:03 +0000 (UTC)
X-FDA: 85194725406.09.B0DA899
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf10.hostedemail.com (Postfix) with ESMTP id BE95BC000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:16:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788970561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GVGxETdp2m7ILyPbGRrwuaEiWvle+45bqndsDC/lCao=;
	b=ec0IzQzE6ERysvVLl1gbP8LyddKQQxGB1sAeYyZvhZoxH0eT4qJj0zeWPqmph6YRae//1L
	R3zEDNY4jmQOshRH6N57d9y8eGaSc9MYzvrvpO61C13dOg7of0K/Wqq6ZGZ/OzZy0Uc1gO
	q2KoYQG7Y3ob5+d3KEHDS4Y8vwFU75w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788970561;
	b=CCX0ARRMvOdW4lA3PzBStrsugI2G6l6bBpx/YVCuMnB34mrLDMSRb94iNIDc+y8gzT0BnG
	pcKHV4R1DYjbOCKMjEf0lzZ0D6oPu5iJLOAYuIuMZubDx8YIHJ4mjieIbdgpUp6G6FmxLe
	bkesKCAyfOBSJYrFiDlx0WcK2mzOMAQ=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 10 Sep 2026 01:15:58 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] mm/swap: fix stale comment on swap_info_struct::cluster_info
Date: Thu, 10 Sep 2026 01:15:51 +0900
Message-Id: <20260909161552.2335971-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260909161552.2335971-1-youngjun.park@lge.com>
References: <20260909161552.2335971-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BE95BC000C
X-Stat-Signature: 7wg8sy95b88upzfmf1zoctkzhfukmxjn
X-Rspam-User: 
X-HE-Tag: 1788970560-851213
X-HE-Meta: U2FsdGVkX1/MS1hzysTbZFZW8JrYyWHJUONxJqvsIzIvWUxIq5ImIhglMj30c4RQNyExIlXOqdNb48RFhJHJq5j3z22AeSX0tF9h3nvtwTNb7GoT+1UQZ2WK/OxcdonjbMxhOvyi5NaoJYBIOy8oJykhrErhNFvwYD993AYpJSSv71T+v5d/PbWPyA6kJu1FyFq5Fg+oauga4xcAPCxkqpvbpdnTuKHQg3M9DeeB6lx97ICkmLdeRSKHdOz5VMEeM4JPG/PX/l0+vkqTmzLTiEzXgixv1EXr1TLa+ki+pqf3W1nRJOqPPFdz+gc6IBBjtZ2u0QDtvnzNPSJoehJquImTzF8IBec2hX3vhfoPZVSjZ1BtB7EsAnQdtPLu19yv4YCgoYvr9eraz0uPwBvkSzlFAbzizQ7mr3TH7p0s9aCsg1e9CXmzO9PMRxc9vnObgxGo85CLQb+15SlH1QT4ZagCsgE8g8k079BA2zeTV54CMrsj51YpcAlp0UjCrJ+uGe0m/36IiduQeYbExnCxA445cZtbX0lwUjKrLYL8h1Jl5sIKs/oWefNJnWKdv2FdyHeNqb5t3U3Y0vf3Z+80O6yk13hW5s9NuKHfQqYlG5C1GJPjhYq4Xl/3vVHRY+/8b8OTI+Jqp4y+9wwoEEKbaUZRwI5khsFkiWjTfKezDZzo5Ci5OhJ1jyVVq2QKXmaNLLv1Ub8q82bRjgMP1Xs08nqWf+j3dW3+HOblxOQy9aPSIy5tjdsHZg3fYI9qsoUeMzgOs7M3oJ1vFZ0hfMRCZdiLW6ODySANX7hfVFyt89COOnOnxpKUJNQ4iFo4oBZ5YhMhDxdpMiqBA/uuz8WTaUmyMRG19+3AJEU7xTg+38i3nDZKSJdYfT3zKK6r8JZT+XjF5tswnyQKExfuF8gp3WQynx3wH26xy1WV8tdlCdFE90hk0/IWFBNsZ/vdyngXXnmWEuhFHVSR7gFGqAe
 UB9kL3hN
 uiSbwFcDWkEUTXmKWgyTeoRUUNyA6w7P8Th/UqJHG12JxcmNnLXKTECSfZpj/COmaFi47KvonlcQuBjg8BYF5yX0mkMQixL4JZIpQp50AbPMMgt3CFrnzH5qeILiKD/o5X+zJokQzbiNbLuN7UvuESDhd3GzUGWC23C+Kpc/KiPnx6Lk12p1guYsSmlD5XRS9blH9M71lTerLu9gMGbyHMyA/XXuI+sceBaeGyAGdF9SE18Gl4LO4nrq/uA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

setup_swap_clusters_info() allocates cluster_info for every swap area,
not only for SSDs.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 include/linux/swap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8032a0f3c319..78974da6810e 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -240,7 +240,7 @@ struct swap_info_struct {
 	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
-	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
+	struct swap_cluster_info *cluster_info; /* array, one entry per cluster */
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
 	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
-- 
2.48.1


