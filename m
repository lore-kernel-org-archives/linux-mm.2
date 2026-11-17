Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3DF6606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RvE8aUVF
Received: by kanga.kvack.org (Postfix)
	id CA3B56B05B5; Tue, 17 Nov 2026 16:16:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54B16B05B6; Tue, 17 Nov 2026 16:16:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B46A36B05B7; Tue, 17 Nov 2026 16:16:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE6B6B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:16:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5EF931C3EA3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:16:45 +0000 (UTC)
X-FDA: 85445870370.25.7E6E034
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D19B180005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:16:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RvE8aUVF;
	spf=pass (imf02.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794950204;
	b=G8qMa+lyMQ68qHDV4XG+di1TzCrxfiQxBPqljGgVzCv0CzaQkov8ijTTdAaWdnyxkrOyvK
	aArDTUY6dOqn2w//YNrNraE5xwTmhyM7VkCcpkJRGkJWYzBqmEnpo3GkMqcH3wVTUUVVvh
	okrSzSRvZ97rXtsjgF+popS+rQiuop0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RvE8aUVF;
	spf=pass (imf02.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794950204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aSIqaCuGKAAm3GIlrLBE4Sm3yguEB02bGLyZfmuO6rI=;
	b=epm2a5R0BKCo7gvzBWmlS8/yNVxHe2OKLi3NYsjaSYlIhPC0h2TbF+A50qkigg5SuQFq5b
	XKJk1hOwfSmslVBTG3eu+UWuLgmIU5YjN5N3wm/kPTOukYqSd9Br/rVR9eEqFS0s1eOEjP
	qfFnwZFeDUFK9CRnr8S3UKCyg+NwJFo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA87440AE2;
	Tue, 17 Nov 2026 21:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3711F000C4;
	Tue, 17 Nov 2026 21:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794950202;
	bh=aSIqaCuGKAAm3GIlrLBE4Sm3yguEB02bGLyZfmuO6rI=;
	h=From:To:Cc:Subject:Date;
	b=RvE8aUVFZ2vYKmaEf76csJ4mfnf0cK3VUUHI88V9scAksNusNaNI4xp4L12gl2eh8
	 MyWjTxonX44sJry1digmpaa0AOyu4swHwIBT6069Z/T/k7ajsFWm9soX7KN11qriiY
	 PV+oh4IAe8KVmAjSF4GCngDcjJFvQxH9HXcmAvcXhGcsVLkUHIKWO1WrmTRm6//IGy
	 1ZBnuyvA0GnIgPBos3nECyrUD1nXi9++PMJPyQyrgQaedmvykway5ZmVrcze1Xa0lS
	 7AH1DSWCPsVo9DE9PWGYzyu956tRA0I95MIfzav6Y0rMu/jBQ6EzqXjX8NpcLm+AXC
	 d4A3vAATk/36Q==
From: Arnd Bergmann <arnd@kernel.org>
To: David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>
Cc: larips <larips950@gmail.com>,
	stable@vger.kernel.org,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jackie Liu <liuyun01@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [v2] mm/mempolicy: fix copy_nodes_to_user() for odd inputs
Date: Tue, 17 Nov 2026 22:14:25 +0100
Message-ID: <20261117211635.2472067-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D19B180005
X-Stat-Signature: xgyp8pa4a46gajm1oqbiy9kw5gp5wc17
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794950203-394720
X-HE-Meta: U2FsdGVkX19Cpm+ve72oor6kf/41sZZGCNX7X44Tv8BWG3b/v8jYZeq77/bXAG3RpcjgMOosPZTFf1fosYX0lfSuvFm6x0RCPuIUtvaGSm1sRzyS56khJBjRaLkmL0i5ikgKhPXJaCDnzhEO0vlvACgDtNagIuEai99Hb9r7aowRxkFqf02AkhnfHroh7+0g+vNABYuH5TB8CMcgli4jdjn52iUT66NzvGImuCM5amBWYHNBT06Mhq/YO2lEkDB8w4qof18+mGrcFL2dgVs5PqaIEwSaGVLo12ScrzZWt+e+vXfzxMP7iBy0gdyacR0RBPa4UCkxitBquJIk6Ic4B/q+4uZyCbqMD1v5zG+dDAzTyniOJRdF83HlhfwKg6oy2j27D5zcafWscEjknIGzgtQ1hwFQtwr5yAl00MOEZcY7cU89ZhbRtWFdoVUxPCkb+tEzSM3BmLjhONSCQodeSYYvEKWwnRkPOuG1NFRTh6xuS7TPq5ABj4rQwJkcPjIQLma1TQxFh21jpF6t4TVkc1O+uhIvIlBhHrrimCf1yH/MN3XvdAsg77Y2MQn/ktsKCq9aY2RTkEBsb93nEF/Ibcgzh59kFP7NZUt9s5wzPROLMFQ6nhEmT4CNqiaG+hC2mHoOP1kpAJI+KV2i1h2BptUTN7qfxIasyBe/Ge954fEzRncuVfwkROSgwh41KHhzywTZOV20rgWmLDUKinh9Vss/92jdMrNLx7SEe3nrQ3J1XzS1U/Rgtsnn3LYs3k/V41oxMlR1l0NqXiF+U5EVvbIve4LRNUXasq2YauQf5GNUb3khT/Xi7SqSM1pZiY0BBmOAQwSBTMhaZa0sT/dahXL8dq94v0ZK1mKcdmYkW2EGyx5ks7Zq0j7CjLdu0B++2KjLBF7g7tJC41W7TcWVxXc8fVd7PYwI7aeZmDba8JqXBlhuqCeQ3iyY1aggicMWj/8sxVfg8OuHjU/Mq6z
 i7csX3rd
 y4mSyoRopwp2PpanmZU/yfH18cSH1G7MrJ5E0ofeattEOITgRCSfCLOJPRsAbpzsKdeJUa0kN8HQ66DNIzn0XjHQdjL9PJXs7vtkGZQxy7OnGgYZNiqBau/JgHxU5IjTErrMll+KViFMgeiT67DauJKXsrpR0C6L3mlF6xqgi6uY6slmbvmrrWNKe/5InAw5u0UD3LPtIabcxUfRwdom4v+i6rqRLnk7GXl1ZdQy9uZuf32463m+0Dqs4sIj2RZzBm5UvpZ2Wi+zzphGoZ2/0a2g0pyiu36z4xnWDlVP6ReSQY4h5seTnT75QkZrzcT/uPl/z8IrMCK5NdxZ/gcsKf0AF2B1B0RGrE5PUjpSdvFyQRdT0OsKoVga5RWCpR9nWiQ+K7sFO+H56nbM7GwSlCBk8WwV8V3sydNR10/gFt/0011pyLm6fxeF26Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

The compat_put_bitmap() argument has an off-by-one error that leads to
copying an extra 32-bit word from the kernel stack to userspace when
called with an argument that is one larger than a 64-bit number.

In addition, the size calculation rounds up to multiples of 64 bits
instead of multiples of word size as documented in the man page and
expected by numactl.

Fix the calculation where needed to use the correct -1 offset
and pad as needed.

Reported-by: larips <larips950@gmail.com>
Reported-by: Gregory Price (Meta) <gourry@gourry.net>
Fixes: e130242dc351 ("mm: simplify compat numa syscalls")
Link: https://lore.kernel.org/all/20261117101910.1820066-1-gourry@gourry.net/
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: as Lorenzo pointed out, the off-by-one mistake is part of the ABI
    and cannot change, we just have to use it consistently.
---
 mm/mempolicy.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6d662a9a8c74..e471ce615691 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1749,12 +1749,12 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
 			      nodemask_t *nodes)
 {
-	unsigned long copy = ALIGN(maxnode-1, 64) / 8;
+	unsigned long copy = ALIGN(maxnode-1, BITS_PER_LONG) / 8;
 	unsigned int nbytes = BITS_TO_LONGS(nr_node_ids) * sizeof(long);
 	bool compat = in_compat_syscall();
 
 	if (compat)
-		nbytes = BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);
+		copy = ALIGN(maxnode-1, BITS_PER_COMPAT_LONG) / 8;
 
 	if (copy > nbytes) {
 		if (copy > PAGE_SIZE)
@@ -1762,12 +1762,12 @@ static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
 		if (clear_user((char __user *)mask + nbytes, copy - nbytes))
 			return -EFAULT;
 		copy = nbytes;
-		maxnode = nr_node_ids;
+		maxnode = nr_node_ids+1;
 	}
 
 	if (compat)
 		return compat_put_bitmap((compat_ulong_t __user *)mask,
-					 nodes_addr(*nodes), maxnode);
+					 nodes_addr(*nodes), maxnode-1);
 
 	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
 }
-- 
2.53.0


