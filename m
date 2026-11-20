Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C929606A33F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGNmkv8B
Received: by kanga.kvack.org (Postfix)
	id 634F06B05B0; Fri, 20 Nov 2026 13:52:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1636B05B1; Fri, 20 Nov 2026 13:52:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0996B05B3; Fri, 20 Nov 2026 13:52:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2B86B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:52:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8B749A015A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:52:57 +0000 (UTC)
X-FDA: 85456394394.21.3AD0598
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E69B1C000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:52:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGNmkv8B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795200776;
	b=uHe3CAevNBTSum8VvBAKH90Iy8W9aIgBI/b68lXxP+RRy+DM84ljsxS+4fzp+ghjnAT6Dp
	RlnM6+FqQ5jsv0q1rFE6GVxSGMbXTaeMGVc6qJlrC2eSQg41bNusFXLtsW7CEkdlzzgbDV
	KZrQvobIVEuIpqATP8l9b99+6Kz71zA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795200776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vFu71F4VU/EdQcXZhad8GczLSYIVyzi2P+9OjoRpNEo=;
	b=2zXcK7G4/2mkn50l5U5fZgP881B28QmjHJghRtwvqFePMbyPXBfoNQ8xvFasqqIh3/JDBA
	f4BSi7qFuNeTthaCzXR/aeCQSMWEctv4GjLv70txi+h1NuwInUVKKLUuTBOEJUPQYTHtJs
	ZSqWB5hwEht/W40Kf1qkY5id9nBUCc0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGNmkv8B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E0DC44284;
	Fri, 20 Nov 2026 18:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C761F000C0;
	Fri, 20 Nov 2026 18:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795200774;
	bh=vFu71F4VU/EdQcXZhad8GczLSYIVyzi2P+9OjoRpNEo=;
	h=From:To:Cc:Subject:Date;
	b=iGNmkv8ByFAtY7Lm/PR+Fg4PUMeb2KRjz4XSN/5mJuVUXppzYRSjYAKIzjQl4jm1V
	 +ugc2KySZr5runzMywFHgV2FKrFo2rd6RUCGXuxAP7DzUFFUyUl/NMnrbBSRaffJZD
	 cE9B9XLUH12iMVnVosV1hIuGgZFmL5inkuIUKSup6Zxujcdi1vRRDnM21mW21sunnO
	 qoYeiOmE/wFf7Y16T4swiyol6EmXZHCBn5jlBcsOozuetRyN6nmhXaBkLkpqjGDLa3
	 D3aW86B34td0Kz2CtXE41VH349f0EGhcZ+LJxRysbYTvQ2wTCKFPM+f9HXhioNoMnr
	 HZRUKc3GdYugQ==
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
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org
Subject: [PATCH 1/2] [v3] mm/mempolicy: fix copy_nodes_to_user() for odd inputs
Date: Fri, 20 Nov 2026 19:52:12 +0100
Message-ID: <20261120185248.823415-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E69B1C000A
X-Stat-Signature: ruyz9q8fpcq4icmpp57omrywmwg46bsf
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795200775-867449
X-HE-Meta: U2FsdGVkX1/RnqZcamOnqX4xdykRuEtNZgfaaH/6u77nm+qScjek8Y+0RvZrrYDqMZNVELRQRrjzS97OmExGh/ly9r6T4Pl4qDBTkCa1q3a4h0PPVXKCYgj95f3ov52TSn6qLoyCz/GJE2HDASwAJRFJKPrywBch3Ph4DbOIZBdOtyYSs9kFmT8D5SXaypXjapvpwrGorSAy8RWVyIdBrPVZog9hcJCSJIS+Ahu2AQYVnmrdkkUxH+lnb7C3E/njcP0RboRL2smHjGwKoIflLnsxcaph+IW5412c3jy+1LrS0+T2Q/rjQNyEXcNy1tSejz3n2ZyA5cA93qA2L2pQkjW3WORpsu9ga5frKxUMSPphtzeMrWTY5p9A52ZRuu+vP0fYSXbLb/7zLfhKJt62MMHuq9UJuFFRk2Q0zQxdojXUyIG/yG/0tZwIWwyCfRGLMfWFkYxMcABAk+xvNN6NJWwdaG0hZcGp+BAH+S9Tpo3ojQXQ6v4XiJvfQKpkO9GJrNg8RawUVt+Iejh1Pt9FZAJNngASOuhHYIbRa/ECO9b+5dlplrbxXJ4iAYNE+oaDKijywEucWu6JMCQ/hVRFu0/E0N2PAgtLyHa52w9gKGF/f8cdI+1GiJS+71GXfPCMrNOiix4qiCpAQJ4JQexOntFLw5q1YX0lMfThUQMjjnhs/3Dh1RvdKBeeMyL+9UVekSYaW6cAaG+mGfCdvMsAWU9kJZhC449pUR6Z+J88IYS4smc9128Mz2x8PHbkD0K5cjmluUSZDlmr934BAkUOa9RfIcP0Mgss7XBJ2oUiWfgz2hZGdydFZ/fafDCe2KIi7DL294dUrh5QKZat7+WYjPngSH3lZeuMFQvEgTfFWL+fm9a1oWCs3rXSyCaMVCQrSgvxDAgJQcwvS/2GcpQTDSkjDCRqwLPazbHT6YXza4KL6MivMCUeYaOEEdk8S0WZxmx+QaPqXlc+iw42AOA
 e1zeA5gR
 4hignJgG3jEempGrQ8qQCbIeQpeku2ceF0K1tZuqpW0qw1gnJqLA1BqpMmg7KI3cHNYeVVoknhYlJOEHWKoiIvpmelwmIavcDbQCYNyL+wsqDKvrZRQa3eY2LD5+loyzWj37RL93F23NY5b1u9Fb8hB9gJ4i3rL5P2p929bxhRnIEw7BSZil3ly9PvuVaqp7Nrfrf+VxPSfqz/PJdXG5g5jnl29BwlYmZcXTvpCStYZvWhSadAJFwSekqq4Xdfj7BjY6wYhyTwCs2cWhOkX9HJ/6zGScORQtLx5nFSTZjwwj8SW/ZZdDbDVNwEAFEQQzk2n4r8kT/kdFIi5HzhET5vrFfJrr4vtbL6lhcOCSoRCn3ScxMsmpZ3yL+boa+IZS79gZcr6Y+E5xAoQnlybE8Go+qKjc4iIY8wEz/ze5kLE/3NEjWb83C0w1q5Kpzfg11sGiQLZ5+MzXKbszYqga3TFa9fJgAr7oRv6C9P42Q9miXW7Rx3MFeBM1Jq6kIoCAXT0g+LYAO8vMxT7e2GTk1ZHKh33lVUnI/SfJTAi2DPXkUqiJlnOwFi4l/FbreryBizaGAZ5tCGTUghKa0bVBI2xiItlr05P+FUzXXK7cshWks1Msv/n5cm+cP7kgRkCCFIdXT5HuqvXLpqZAB9Ax4bfPgLUTFV1AwkzPj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

copy_nodes_to_user() is broken for compat userspace in three
distinct ways:

 - Passing a power-of-two size plus 1 as most normal userspace
   does can end up calling compat_put_bitmap() with the wrong
   size, copying an extra 32-bit word from the stack into
   userspace and overflowing both arrays as compat_put_bitmap()
   expects the actual number of bits, not the number plus 1.

 - Asking for an odd number of 32-bit words rounds up the
   userspace buffer size full 64-bit words, leading to
   an out-of-bounds access in userspace.

Fix the calculation of 'copy' to be based on the userspace
word size and use this to for calculating the final number
of bits to copy as well.

Reported-by: larips <larips950@gmail.com>
Reported-by: Gregory Price (Meta) <gourry@gourry.net>
Fixes: e130242dc351 ("mm: simplify compat numa syscalls")
Link: https://lore.kernel.org/all/20261117101910.1820066-1-gourry@gourry.net/
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v3: don't introduce a bug that skip setting a 32-bit word to zero
    where needed.
v2: as Lorenzo pointed out, the off-by-one mistake is part of the ABI
    and cannot change, we just have to use it consistently.
---
 mm/mempolicy.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 62d4c9e57035..afe614efb77c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1772,12 +1772,14 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
 			      nodemask_t *nodes)
 {
-	unsigned long copy = ALIGN(maxnode-1, 64) / 8;
+	unsigned long copy = ALIGN(maxnode-1, BITS_PER_LONG) / 8;
 	unsigned int nbytes = BITS_TO_LONGS(nr_node_ids) * sizeof(long);
 	bool compat = in_compat_syscall();
 
-	if (compat)
+	if (compat) {
+		copy = ALIGN(maxnode-1, BITS_PER_COMPAT_LONG) / 8;
 		nbytes = BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);
+	}
 
 	if (copy > nbytes) {
 		if (copy > PAGE_SIZE)
@@ -1785,12 +1787,11 @@ static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
 		if (clear_user((char __user *)mask + nbytes, copy - nbytes))
 			return -EFAULT;
 		copy = nbytes;
-		maxnode = nr_node_ids;
 	}
 
 	if (compat)
 		return compat_put_bitmap((compat_ulong_t __user *)mask,
-					 nodes_addr(*nodes), maxnode);
+					 nodes_addr(*nodes), copy * 8);
 
 	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
 }
-- 
2.53.0


