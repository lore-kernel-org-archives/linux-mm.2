Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CB78606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SfwQ6lsr
Received: by kanga.kvack.org (Postfix)
	id 3CA826B05B7; Tue, 17 Nov 2026 16:16:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32CBF6B05B8; Tue, 17 Nov 2026 16:16:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21AC06B05B9; Tue, 17 Nov 2026 16:16:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDCD56B05B7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:16:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51E2840594
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:16:52 +0000 (UTC)
X-FDA: 85445870664.05.C4351CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A3F8210000B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:16:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SfwQ6lsr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794950210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfxvKveHFk2OvHfqLTovj/80/P2+vLM5DTO5QeElbac=;
	b=8HBxB/OnzYZPWquaSALQE7uC3ncwUWsDuTm81/dzp88ezrwOfxhUlKEEizDe0NUGOAiOPF
	EVqW//yjxsWKibe6tXl5Ri/3FBFDXF1nPP1IUfz85eAcEe0DV6X2MHCDbqyF27szUFGPgE
	UjIuquIrNdxQJV0aj1JKf53SjCsKmFQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794950210;
	b=bZUHZMF85drMdRaymn8BGyqui72vo23u/W6MP3Cx+RlVx1LCQZ+dX0JqaGCk0bkzEoJqKc
	AVqtnrhb8RUu104b4E4Lm+o/QpQNTLnoPpdqXGmBSvsIlzfs86RgGblJhtOFpnFlGT1tNW
	aDDuXDKzHSKNFZ0W8w1o/4Ho0Vrxtlo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SfwQ6lsr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7D7A4051F;
	Tue, 17 Nov 2026 21:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542941F000C4;
	Tue, 17 Nov 2026 21:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794950209;
	bh=hfxvKveHFk2OvHfqLTovj/80/P2+vLM5DTO5QeElbac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SfwQ6lsr/SBIsl1iP7yCYDkLC2SUSnW2KDw6jOTC6o4wb6snv54IA4bPZV9DJjQXo
	 A7EwIcee5X29fdqDlvUxNZeFeMmZQJy04vU3WjKUmq6dYliKzGIlojPniBr7OVJhm6
	 6KVggZBG8G75VgGtgw8zQKsmKu3JZZXOVWolwmL3NHcbKgMXn/LVxR5dfMWY7UncHW
	 Vh9JKboXJJRoBQ4U8g3aUU5fjlvoWbzxfI90d9ULdwS7bPWCB0u3CYie3UaeiTAi54
	 5Fqkb6jZi0OttAbiBKFYPOURP2xRDJboAAXfwriAuSP1ENM7zU3XMTEMjH7ukvKXg1
	 6P9KytCYsAVKg==
From: Arnd Bergmann <arnd@kernel.org>
To: David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	larips <larips950@gmail.com>,
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
	linux-kernel@vger.kernel.org,
	Kees Cook <kees+treewide@kernel.org>
Subject: [PATCH 2/2] [v2] mm/mempolicy: replace copy_nodes_to_user() interface with put_nodes()
Date: Tue, 17 Nov 2026 22:14:26 +0100
Message-ID: <20261117211635.2472067-2-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261117211635.2472067-1-arnd@kernel.org>
References: <20261117211635.2472067-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A3F8210000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bkygdyfbsnwzwgtcbucn7z7z988e1zpc
X-Rspam-User: 
X-HE-Tag: 1794950210-69538
X-HE-Meta: U2FsdGVkX1/ko9NUVwBLYcAonZD4CMW6i8kEwbqk2yX6us5Kr9rBXosJuFMJe5vGCiRJnHmIjL/neoY3H3mcSFzSUt3hextWV2+4MHy5mqX3wYoGRAWz+tM08dPnvY93/HblGWK70HvBgh08yW6RHi7lrwP0rz8gxOCIyUR/h6jAf2sr6wEs5AK+MF+C8ytK0ifLk1Dwsky492pCEYS3nD/kZ+Zg3IOlv/tH/jMxjfSaI6T0DhG7griHpfRcmGlF7mZmSblNYhlZLRfGQxz3Rp4z0IiKZdsW1H4bWs4gP55axxhpl048fsvr59Y1wneL5pAkUfRGyuDAq1UR0pujhW+/Do0NbBEscV6vuDFzhUBeKGFzza/Ehe3YDfm6qo0B3bl8i9Wym2/2a3JWBK52muJFSVDEtUMj9ZSrURfiHyoEyCjEpKc01OjaxPYpHAbzir7KrfzMQh4R2aIxssuoSKrhuQOwYf5oFjlMGLmJ1pReKe9nTSlkKDTjJq25JqMkfeDMQaxSxOyy4Jx67cVFH3jkIrQ5HeIE51DbN1PRHQ/2lL5m+pd/YncwrjFb0zT0mfWn6vCYSaCoiiPCtNoLAnTPHzOjDQoou8faRjR8wmd71niAYjp9jirpUHoIyQuXnEXNFDVedP51FmjddaCrkN8mGM96USEAPlELg+EfXMyta9DVIMpdyO01LaeDhdbwnKdYKJvmofmT/8mIlM3iSiFy5xwrJh+e7ZKPXjDGPKzYC162qgMPu9QirE7Jluc+i+7bj2QiSwub5/t/7Ftdbn4Vp+mo1H0wmrBCRWy34ODd1y2+C+tb2ICMXXD8+Lg7KEJyARwCCi4ymnXW9QRqDD1SRIK3YFCeq0uc7Dzvuez+c6L4seAccIHYJCmcCu2UCU4EYUolCSJquL2g6AjXe2Gyi2Xp966yoFGtdm7RxQ9FtzQe9HXy3kwteSwcjmWmv8b/ebziptiafFSN4t2
 sCWgDQph
 k5rOPI7pBXGYo+A4cKY1DvOan/iJBJt87ssEDU1OZLkzXrmLLGJvWEMy1HEmk+7X82zkKt03xVNC1yvCf9MVyB2V46RwJpr0E9Z+NiQNk9lD9UcOsfIifmc2cS6VKP7tkhY6FuPctfhGCTI9KVjKwsSkKgxqnTZh6nKlLDsgKeudVSb+VhS5BHhyT0LHjFwpmf+J5+49cB//rXUVBLvK3gheoYDcRP2gM/F8jHLBWncyXXNX1EEgxC6GqcxDjDTpiwSeSOUYKeG0furm+uTCWA9N2sBKADe9rbnacxNnvrNgy4FDLNhR/INLt2qfJJFA01OpKav5q6eun3Pk95U0GVlXL+uVEuN0lC0Y0cG0Ru5dzKNZRiZby4Of6Ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

The get_nodes() function handles copying node masks from userspace, while
copy_nodes_to_user() copies the same masks to userspace, but with a
different argument order and slightly different meaning of the same
variables.

To make that less confusing, change copy_nodes_to_user() to look
more like get_nodes(), using similar name and arguments as well
as adjusting the maxnode value once, with a comment explaining it
in both places.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 mm/mempolicy.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e471ce615691..bb18867ba41e 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1713,7 +1713,7 @@ static int get_bitmap(unsigned long *mask, const unsigned long __user *nmask,
 static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 		     unsigned long maxnode)
 {
-	--maxnode;
+	--maxnode; /* user space ABI uses number of bits plus 1 */
 	nodes_clear(*nodes);
 	if (maxnode == 0 || !nmask)
 		return 0;
@@ -1746,15 +1746,18 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 }
 
 /* Copy a kernel node mask to user space */
-static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
-			      nodemask_t *nodes)
+static int put_nodes(unsigned long __user *mask, nodemask_t *nodes,
+		     unsigned long maxnode)
 {
-	unsigned long copy = ALIGN(maxnode-1, BITS_PER_LONG) / 8;
 	unsigned int nbytes = BITS_TO_LONGS(nr_node_ids) * sizeof(long);
 	bool compat = in_compat_syscall();
+	unsigned long copy;
+
+	--maxnode; /* user space ABI uses number of bits plus 1 */
 
+	copy = ALIGN(maxnode, BITS_PER_LONG) / 8;
 	if (compat)
-		copy = ALIGN(maxnode-1, BITS_PER_COMPAT_LONG) / 8;
+		copy = ALIGN(maxnode, BITS_PER_COMPAT_LONG) / 8;
 
 	if (copy > nbytes) {
 		if (copy > PAGE_SIZE)
@@ -1762,12 +1765,12 @@ static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
 		if (clear_user((char __user *)mask + nbytes, copy - nbytes))
 			return -EFAULT;
 		copy = nbytes;
-		maxnode = nr_node_ids+1;
+		maxnode = nr_node_ids;
 	}
 
 	if (compat)
 		return compat_put_bitmap((compat_ulong_t __user *)mask,
-					 nodes_addr(*nodes), maxnode-1);
+					 nodes_addr(*nodes), maxnode);
 
 	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
 }
@@ -2030,7 +2033,7 @@ static int kernel_get_mempolicy(int __user *policy,
 		return -EFAULT;
 
 	if (nmask)
-		err = copy_nodes_to_user(nmask, maxnode, &nodes);
+		err = put_nodes(nmask, &nodes, maxnode);
 
 	return err;
 }
-- 
2.53.0


