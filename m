Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3EE6FED9EB
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:57:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9656B0098; Tue, 17 Mar 2026 12:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469F76B0099; Tue, 17 Mar 2026 12:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3598A6B009B; Tue, 17 Mar 2026 12:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24D686B0098
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:57:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE5931B595D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:36 +0000 (UTC)
X-FDA: 84556161312.26.E9D6681
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 352B1100003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h94nBmRa;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tdouF+G/qWuSp6OEeY95cu2HNZboLbHwEtgxzsHT9d4=;
	b=ODf8deWSqLLecgUEFjdX4m3bvvvpJ8rVP1rwdqzNtvWNRST9z86rdmNsUWUD7EjOrARusn
	SUHiFgYA/oqaoyE7/XrsN3XK+lWoS3bXG/sU3IYoJdf6iiuiGAK3oECSXiLYWYS8D7sJL1
	WPWSEfEA1FkaxGR10S2ZF9IHG6pQmjU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h94nBmRa;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766655; a=rsa-sha256;
	cv=none;
	b=lOXJuZ1CcYnJE4gv/mhm31eGpfcxBHXFQPK3ZPeqgUAF1M+APsE1TL32V9+TLf94fz8Kf3
	J1PHB0MOgdH+rM0eWaSE0VK7LJc17N0jlzwnFVOhpdi3BJatM/76WMpDfJkYc4CGNGQ7Nm
	C6PZ7fHsg/RdGykg6dFnqmwQwAASxso=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B1BE40AB4;
	Tue, 17 Mar 2026 16:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B4CC4CEF7;
	Tue, 17 Mar 2026 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773766654;
	bh=3YI8GLSe1tTWHR4VUkgbO+5WHzisOWZuA3eyf8N2TRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h94nBmRa1lj7MKJ7PA9M7CgVzvxBwAAV9TakhLXrNdY2dP5jXSRsFyt3auwxNmXF/
	 Cmr9K/op+yjMOSFwzQo17jrSDebrH0kymNXGRAQ34hK8tLDjPuvTMqScgg/doAonCy
	 z0QkvfRf2dThbrwJariFkrc3HxzK8XWonH4NsyuKadivtDbb0U3myTcMY+JfZ89/ZW
	 C8SD3Z7dF3dhm68HtC9CwkUO6aD5ufhtfmV4WytNrOrVNohKLEq7dut2Y66Z/PBBDc
	 ImEFj48erS2Yb/wxd/vaw04/8SLSebStL59JVB2WI8UDMUzaYYHFSPQm7AsE65fHiP
	 rvwNFWh8h8AYw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH 08/14] mm/sparse: remove sparse_decode_mem_map()
Date: Tue, 17 Mar 2026 17:56:46 +0100
Message-ID: <20260317165652.99114-9-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317165652.99114-1-david@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 352B1100003
X-Rspamd-Server: rspam07
X-Stat-Signature: shn9rnh1k8jtqb3dx7hna9g4d7xiibox
X-Rspam-User: 
X-HE-Tag: 1773766654-991972
X-HE-Meta: U2FsdGVkX1+n90WrskU6ry/VwnSN6SWeQVDPW8uKeBYZffb1fSxf0RfxJEDoxrASuUv8FClSsXb2exfm1hZldAZ8Jdy62/I4oYBkuuKvAQb9EImtcqpp0NgqTuVftwrM20PbqtxZUaDm3WXIqhUdzzrzxCNjShRy677GB5bLN12CsoqWEGnRlg+wzFlir3gjS27ow83s6dpFN9gIIdeY0VrsOrPua23jnKsr/fMqwYxjLa/XwMjvtduv96WnmvXIYiTf9lq7Np6iMQm2/RksPBYoo7tZlKCELBRtEB4MKjK15ZZvVlTxRuZkdxfX2gf/Gd9LRZykDs3pI7RPbHqn57yE5X/J3xXkO+CkF4dgtfm32lRPYF7RTbh9hono1Z3ly4ymw/DwqV5IkDXsjHjKpV4+W7jszd/lHhlN9DRYZ/PaLjxqKTQSED+HKX/9dDRrp9L1hh6858Ls7KJM6a6Zw7SV0ETKEkTk9UXdlVPmzd6p17EAF7KBEUkt5yBB/tu+QVwXp6J04ZK6NFXwl4AWg3Bkwj8gd4qiKaIANDZ1X33ga6sTHd8DdgsyEkznm4KaFaSm+Eu+6Lyt3V9f+CBBbNv7llfbiB2ajWlhskeJfSFmOm0xGi8Lse7Q0RBAnSahaLzjR3REbhtWoStnR0KrBttrWOzzCW9LgW40M/66C9J7Kf7b+FCyoA2xV5GI8j+p+6yeaR45hTq2AjJzdZhR/4hCxoTRKxv99txNRNGg//uo9IvX5/mENh2vwDc86+BTkVcexCAvsa812RrFuDgFE/iM8aBF8i3gN2XnEWLehh1hP7GMoFdTgzOsbJTeNR7PqQ23WscKzSFz+Pvui5dupnWJS7jERT0AqFpsG2DqbWQvPHX7gbfdG8NWA8po8iwQwcbTxO5lEa+fFfEnXmFA6mfsUN+FFHjXdQzKIcRglR97CLx4h2sx3BZlFXWgZoMZlcU5/cJOFvwyv9n/7oY
 I1rcLxcC
 geU/FPU/QBYiJRelMJHqveYW4zUImTk6XOKBn7agPl7v1k7qM+5yk5OWpJBYxvdUQd+TDb7fh/tP/Lw7oI5TzPTOOisrK3fOOovFm4xC9jSPspZ+IOI4HipFLm9/VijQ+5/vqmhIQdLRtsBOde04/sKt23GBhq2sNVHClL7FlFt22ZQOP3VKm/tZIBFYnxXRRkkHqBFyRe+nz0Hwxj1S3gSMjrfLXROZR7+ZqL1/eOgrZdVg899BwQJjMaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_deactivate() applies to CONFIG_SPARSEMEM_VMEMMAP only. So we can
just use pfn_to_page() (after making sure we have the start PFN of the
section), and remove sparse_decode_mem_map().

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/memory_hotplug.h |  2 --
 mm/sparse.c                    | 16 +---------------
 2 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index e77ef3d7ff73..815e908c4135 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -308,8 +308,6 @@ extern int sparse_add_section(int nid, unsigned long pfn,
 		struct dev_pagemap *pgmap);
 extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
 				  struct vmem_altmap *altmap);
-extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
-					  unsigned long pnum);
 extern struct zone *zone_for_pfn_range(enum mmop online_type,
 		int nid, struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages);
diff --git a/mm/sparse.c b/mm/sparse.c
index 636a4a0f1199..2a1f662245bc 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -274,18 +274,6 @@ static unsigned long sparse_encode_mem_map(struct page *mem_map, unsigned long p
 	return coded_mem_map;
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-/*
- * Decode mem_map from the coded memmap
- */
-struct page *sparse_decode_mem_map(unsigned long coded_mem_map, unsigned long pnum)
-{
-	/* mask off the extra low bits of information */
-	coded_mem_map &= SECTION_MAP_MASK;
-	return ((struct page *)coded_mem_map) + section_nr_to_pfn(pnum);
-}
-#endif /* CONFIG_MEMORY_HOTPLUG */
-
 static void __meminit sparse_init_one_section(struct mem_section *ms,
 		unsigned long pnum, struct page *mem_map,
 		struct mem_section_usage *usage, unsigned long flags)
@@ -758,8 +746,6 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 
 	empty = is_subsection_map_empty(ms);
 	if (empty) {
-		unsigned long section_nr = pfn_to_section_nr(pfn);
-
 		/*
 		 * Mark the section invalid so that valid_section()
 		 * return false. This prevents code from dereferencing
@@ -778,7 +764,7 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 			kfree_rcu(ms->usage, rcu);
 			WRITE_ONCE(ms->usage, NULL);
 		}
-		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
+		memmap = pfn_to_page(SECTION_ALIGN_DOWN(pfn));
 	}
 
 	/*
-- 
2.43.0


