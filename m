Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22FF460A261B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WWgo0r0r
Received: by kanga.kvack.org (Postfix)
	id 45CFF6B05B1; Fri, 20 Nov 2026 13:53:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E62D6B05B3; Fri, 20 Nov 2026 13:53:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D53F6B05B4; Fri, 20 Nov 2026 13:53:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 063D06B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:53:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 93A37160164
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:53:04 +0000 (UTC)
X-FDA: 85456394688.27.2140006
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id E73DE180007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:53:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WWgo0r0r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795200783;
	b=fePrxmqmFPDbDzOLDk6d3/cEt5tomhrtUagEzJlE0O1tFbnWgMwT1aIOkFsrkTKx1G3H+6
	KFKaK2tFmxPCFVyJM263Td7kJ8f27yEEE4oUrffPfhvM6pqM20sLyeTkV2wrlJrhQQXZcI
	Z3Aa+eH6OPRJjoNFakXMRsDrPj4jVtM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795200783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8v/BZgYUbcYBIe4CB9T7ZtFdceVMuVvuQywcZxh+ZQ=;
	b=08/YzzZUx1s4j3WmM659bo1iat7E4kafxIdqsS3ZoGBunrFcIGA5DYytnX7G3ZiRgvAfqr
	N4QUy1KSOSk9AjTe+ONdtbx2MQ0TZoyD6C+vE15zosMTSbkFi9Rq6eUTgmIxzK9mb9n1jj
	/iH59y74Pe/BV+gly9UyTf3KU2NMr30=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WWgo0r0r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41F8B44284;
	Fri, 20 Nov 2026 18:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CCE1F000C6;
	Fri, 20 Nov 2026 18:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795200781;
	bh=o8v/BZgYUbcYBIe4CB9T7ZtFdceVMuVvuQywcZxh+ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWgo0r0r1vT43l43ZnUCs7L11gO2wYTDrsaDv2oJlg18DbRar2LJXEzGoNqqemJuu
	 DcASk2vntTTS/LPryVF5dq+uau+qOSF3XhUJswL5i7ox/dUpTDUPDj5pM3SB2iLG3E
	 J+XG/LObwAmALYgp1xxlescrrMlNP1ReNQMArjY0Ff5r7p8zrZkICiHOJkAbawm7qs
	 Qdib+6WJijoNXcL9hGOTY6d0MSYKNqIA3nTAM2QMBJRIAtpPYEJO+1R5qntRE5bW82
	 363uzycEl8cFu16wNETEZ3JUoQemxHogWQnzlLlZ9rlFwpr5f2pIkXqgaZfZn8uSFO
	 KYlBjeJp8OnVw==
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
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org
Subject: [PATCH 2/2] [v3] mm/mempolicy: replace copy_nodes_to_user() interface with put_nodes()
Date: Fri, 20 Nov 2026 19:52:13 +0100
Message-ID: <20261120185248.823415-2-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261120185248.823415-1-arnd@kernel.org>
References: <20261120185248.823415-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E73DE180007
X-Rspam-User:
X-Stat-Signature: 8z4dtmmtixbfwwiwparm3boe8qgyyfsy
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795200782-771712
X-HE-Meta: U2FsdGVkX1/F1mPgshBy+4nAHjet3BXRWB3TxeTSzVvGfibTO6J6kpzNUFu8LCscy/gInvXhUdrz+q9G6uzJc/EhaHVofxHACVn1dz/6iz4iLEZ/vN+7sPHfOub+cxnIKqNC6y2ic9rZWMZm8QueysLDCWRsUWPNtbYjB+5Y7lXyZ4v6gHIMVrP8YyRY++A6WvtnR9MLA5xZmqLqEToUKgJkHEVG7pVL0Yh6PpXjAgjCioOUitKcXAiOuYZof6eKjnJzlXDeWsPlRspgSSZs/8ZtUkq1v9byTzg+ZYq/Oq9iADOYvAUJy0HPz6kPE/z+Rdr7AZ++XawFJ8jgbZs+plczKu1o0S/1tW1iDrjb90J7dnMWqEhJOaa62d+XsQmeIxBlw9cLuIikq8LNf1hyz7UAZ3RohwJ8bCY1y1FkYdsSnfsUGiDxeuXNALNHBmhkLdzP9QeeaIqWkb86/7pqTGdGxVxZA2hcCoMxpu0T4OFlvoGDdqa7lIBdVMb1pObbGCGyVgBFvKKtMnzaCThTd7mimbFz3Nz17YfhhZirGafe4W1vbD0tuJEx+2XJvixeLTKZo/VMyymYdIlsQ1hBV9JaZDGnhGeroIEM2XA0Ol7YHGFb+GPdc2A8hBgKWxasYTYHGLayqpPWrUmKHViUa3EJ6vcE3m5g+A5FbSQfcJ81CBsexbuKmfDCEHOVPe+V3narQ99La/9xr0Vf6Jc+GxQbMMd2n8ej2huh8r61/HoVdvqsxzN0L+u27YxB5D016FvQMd9wkRxRz0330jMgcIGoxevgCRUN2qitm2p2Yhz+ZMM2v9WdOulvhPUXIf1WMr3YaUI3wV0FgZfXZfIAcEsF1SclTiXlQnhGVmEOOhZIcF5/AsWXBVFhDfB23pUqlDVFCrPPul4YJc4ZTYHrXWpryMIPjYovUY9O3eZQYGwVCelFNS8O3asnijMEipcCK55rSuVETzitiW0G8ED
 yvQPScqB
 h0ZYQvGVPN4oNcLbD7EHf1LA8p2+68lf6VB+gd46E/622R6H7VP3JoDeBFVG6/SRnIzYL5nytpjC5IdeV4rYuZi9IYvLvKgjApS7WNV3naohgfcqc7tR5/ZWq6LjJInYspV3ZB5fwzVdNeb5aAuJZQA54+iyvkuecjZM2ke/vpY9a5veq5LgfWpgmZVTlJiq3x2xlW15ZgCuwfArZWeJ0Y+/3Eo/xKDdopOIkY8TQFSma9OK5JhcHHEcS3zh/US9K221yy3noJtCpXhQ0Yd3ry7kWWE7w/fvNecT/bCAkfC7Fz2Dxrx+wkkV5GDrLG2cacyxtPle20avomZLsJrvMVszrDFZmZiYVrNld0oLvH/bgmmGkS+s6+sdSFPBGiNYa0FrITmQbtEfx6Pwu/R+FWSl4kxU5wYqJjp6YtmXavA6JxQGn1sQzcO2F/fcjWarbxWbxKu7b9nMOgsjgnxsFOr/dx9AXLs+izSRNSWax3Ig0cW9kLC/AgwSu4UiEXJ3B9fr/sp9Q6FNUd7WNF14rRz7J1abqeyyxbJOwMg9MoGBW3EtKAkTus1Mui9xL+yxM3BbEm4O1EwXweyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

The get_nodes() function handles copying node masks from userspace,
while copy_nodes_to_user() copies the same masks to userspace, but
with a different argument order and slightly different meaning of the
same variables.

To make that less confusing, change copy_nodes_to_user() to look more
like get_nodes(), using similar name and arguments as well as adjusting
the maxnode value once, and restructure it for readability.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 mm/mempolicy.c | 48 +++++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index afe614efb77c..b240acaa8cf1 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1736,7 +1736,9 @@ static int get_bitmap(unsigned long *mask, const unsigned long __user *nmask,
 static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 		     unsigned long maxnode)
 {
-	--maxnode;
+        /* User space passes the number of bits plus 1. Fix that up. */
+	maxnode -= 1;
+
 	nodes_clear(*nodes);
 	if (maxnode == 0 || !nmask)
 		return 0;
@@ -1769,31 +1771,39 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 }
 
 /* Copy a kernel node mask to user space */
-static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
-			      nodemask_t *nodes)
+static int put_nodes(unsigned long __user *mask, nodemask_t *nodes,
+		     unsigned long maxnode)
 {
-	unsigned long copy = ALIGN(maxnode-1, BITS_PER_LONG) / 8;
-	unsigned int nbytes = BITS_TO_LONGS(nr_node_ids) * sizeof(long);
-	bool compat = in_compat_syscall();
+	const bool compat = in_compat_syscall();
+	const unsigned int word_bits = compat ? BITS_PER_COMPAT_LONG : BITS_PER_LONG;
+	unsigned long bits, node_bits;
 
-	if (compat) {
-		copy = ALIGN(maxnode-1, BITS_PER_COMPAT_LONG) / 8;
-		nbytes = BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);
-	}
+	/* User space passes the number of bits plus 1. Fix that up. */
+	maxnode -= 1;
 
-	if (copy > nbytes) {
-		if (copy > PAGE_SIZE)
-			return -EINVAL;
-		if (clear_user((char __user *)mask + nbytes, copy - nbytes))
+	/* Don't exceed what would fit into a single page. */
+	if (maxnode > PAGE_SIZE * BITS_PER_BYTE)
+		return -EINVAL;
+
+	/* Process full words, which depend on the user space ABI. */
+	bits = ALIGN(maxnode, word_bits);
+	node_bits = ALIGN(nr_node_ids, word_bits);
+
+	/* Clear anything we won't copy below. */
+	if (bits > node_bits) {
+		if (clear_user((char __user *)mask + node_bits / BITS_PER_BYTE,
+			       (bits - node_bits) / BITS_PER_BYTE))
 			return -EFAULT;
-		copy = nbytes;
+		bits = node_bits;
 	}
 
+	/* Finally, copy the bitmap. */
 	if (compat)
 		return compat_put_bitmap((compat_ulong_t __user *)mask,
-					 nodes_addr(*nodes), copy * 8);
-
-	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
+					 nodes_addr(*nodes), bits);
+	if (copy_to_user(mask, nodes_addr(*nodes), bits / BITS_PER_BYTE))
+		return -EFAULT;
+	return 0;
 }
 
 /* Basic parameter sanity check used by both mbind() and set_mempolicy() */
@@ -2054,7 +2064,7 @@ static int kernel_get_mempolicy(int __user *policy,
 		return -EFAULT;
 
 	if (nmask)
-		err = copy_nodes_to_user(nmask, maxnode, &nodes);
+		err = put_nodes(nmask, &nodes, maxnode);
 
 	return err;
 }
-- 
2.53.0


