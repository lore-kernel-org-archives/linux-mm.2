Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 317C4606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fqlvqBAM
Received: by kanga.kvack.org (Postfix)
	id E34D36B05BC; Wed,  4 Nov 2026 04:59:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0AAD6B05BD; Wed,  4 Nov 2026 04:59:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C84856B05BE; Wed,  4 Nov 2026 04:59:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 890776B05BC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:59:13 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20A3EA81CA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:59:13 +0000 (UTC)
X-FDA: 85396988586.18.7A30C6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0741314000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:59:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fqlvqBAM;
	spf=pass (imf09.hostedemail.com: domain of devnull+daejun7.park.samsung.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+daejun7.park.samsung.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793786351;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhEgGsFrhB7fn+QYkE62uO6FmTu6zV39mSaIWkH0dJI=;
	b=suwiQUdnY4gHJxqQfwVanWmVXRXIDfGT/g4li9RjnSGiMlCPnsRBQd0zVs+szO95w3HF+T
	x8MY6KRjMcd/ybNUlfUujUVFYGf3fxBOG40oq0yDDY9j9HWToAfyt+meiMdgIl0rpV3uRg
	O8ehHZgj8PH4tS1Fv74WNnyzCLEDWgk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793786351;
	b=kN3s419p3Oqey25Lhfz5HUxw8nSJhKRAIDn4YTol07yBeqcey01my9rg0CiOqsAgiboyTU
	t8LP973eIkSr4wpQq/Lp4B+jNVGbSaWD+P2Ct+5HHY7v+TmaUFy65WixvnGC0GlMIsnpl2
	NwwnEXfTgMkpEJFIBm+SoDGXBdOt8yI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fqlvqBAM;
	spf=pass (imf09.hostedemail.com: domain of devnull+daejun7.park.samsung.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+daejun7.park.samsung.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 508C341658;
	Wed,  4 Nov 2026 09:59:10 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793786350;
	b=R0hNYq0Lr+03WyHBH58qFLa/eUmyh1HJQ+QHW21ZzjzTCArjWpUKhNxx+gASxrso8OWS
	 YBKbqxybRy/tkjKg3D/hCXxAYRwYYJ23AH/mpDADYKGNsb+r1w8AfuHU3A0HiyFHI0lHd
	 zg6ZFSIG5+u9WJSGsApH9pWMFzpcm+3W6Mprkea0NQfJnG68PMyZY8KB/WyCmERzhW0ZZ
	 3ZenzRjSyJu536qdqqxPBJxhMlKp2f7AQ2TO0448nSVxYh5yiNdKi0N62ARhlK9tJuNud
	 SGapb6SM5HEO5BEAWcvVQmzqZoUIwFZnUda2cnTrq/rUV46iBF5Z2FN0B6WhDK4Y0MA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793786350;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hhEgGsFrhB7fn+QYkE62uO6FmTu6zV39mSaIWkH0dJI=;
	b=p2ZyTODOWqTaZwCMN++dOiR+JVOf6MfjuReeGw/EtvuChs5LKYNpxGfzRDHVMR3mog+b
	 Z6aDnKhreqiXy6OqF6H/GdW+4hqC4QeeFd42OKYkcAx3/VCoJ0qif5svtt8SfJo7JRwn5
	 0+TV5vm28J09+8a5oGeCItzX4w4uYsGasknAFD6uLdlCApscoalW/5Y1jrNsGkb3rScXz
	 pEKzq7BezmioZx0S8eHng1ghweKXxQEWSGbr4tv8XFEOHLBFis/H+EiYP1TAAZREcUJ9s
	 vjW45X6DLrPmJxJa6hvCmEA0lJ0Inej9McysSyDMSBsyyyXXQYFWDppQ214ygmHIIiw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B6DEC1F0093A;
	Wed,  4 Nov 2026 09:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793786350;
	bh=hhEgGsFrhB7fn+QYkE62uO6FmTu6zV39mSaIWkH0dJI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fqlvqBAM7VJ0X87CpOj7BJJC0BrgxnB8FhIzUDjE3pjB9kc5gwVSJuL2HIA+rm0UO
	 9wfTZIMaO5D9oJKd4MiignFK2tsqZGQDF1eaR9g2lepep8KlXpsKzrZaVht1QZ8yf7
	 QMIzIHyUrhPVtqssKyCc0gaEG7zoZ76L7SN4pWw+VTzTw2NHzB8pN4HoBBDGaLJXEC
	 4SuMumitrxeWyItltFzL2W7JQ64GX2vme6UN1fg/VNFsVOQ7ksFa/xQlsrIMgwefRJ
	 0t/Eu1zW1pykdPeu/pEdEzlkRKKddf4Cmx4Ui9XkyO/BzT+SohuhfypIs3WOWRLCTH
	 KQadwEopSv/tg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2882A46D8D;
	Wed,  4 Nov 2026 09:59:08 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Wed, 04 Nov 2026 18:59:08 +0900
Subject: [PATCH 1/2] mm/huge_memory: set memcg_data before a split page
 leaves the folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261104-kpagecgroup-split-v1-1-f70e947fec85@samsung.com>
References: <20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
In-Reply-To: <20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tao Yi <escape@deepseek.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, linux-mm@kvack.org, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793786347; l=3540;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=cwh5/ANoMn3q9VykAu3ZRo+0WnStzvXM2AIm27t94Zo=;
 b=LfLHZKKD4ZZoASkLp/QUsGDpPgsHyik7sI6TFEG8bIwDQ7hcqjurrCS9tT9tVzD2uMffIdinU
 W/ilRC7e8NWCpqe/mTE/+m/FmR8U19gtyf7Q6smPjJhulLiU663ynWV
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: moswhh8rq7rqizr8a96ifpuom835dxw5
X-Rspamd-Queue-Id: 0741314000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793786350-411965
X-HE-Meta: U2FsdGVkX1/I5vHrFKaDS5fKcqfNjWYSAyME5U0R23I3rAy1sEPivejgOSVb81Le4D2/4fjJoT5XgsbERwP2NtTq9ad94VsG9KrOvvu6HUqYWI+onjl2OtvdQh57oc+IEdOACCyS+jk7MTxGsT25Ged086yVdALuLgToWeI2DGJVuxInkW8oanlgcF2drmuQHS+ZpqCfK7AiyGB25bvD76xNMo+PZSLpyGP/fomNUHazikRYCwBRa4zp+7mniqmH9qcic33cuVJQwbt9/sXcDzpRhR11rujO8+aCQFDReZbh1zFHqsoBUUT/FK+QYHXBbThZro0lWiiApz7QsEMPBGMpR4WhNXNfwmdfOfklBP0F4+FVx6qlbAKyF3EVrrJWZjzLRKzUoWDuQHAc9WKDUhLUkYzUWpqN7h3VIq754LuzY1nVVwqSgRtxxkzhYjDWpcIKB9zPlRUCrT9y5iV93vIBYOx4moCCD9nFKdZoSzeHCHCrHyMfE36DGW2OWjvGruWiN42u6lWuE5RDAG6p8bfAPXFDT3RSj1KFKF00yB6GoJMXVb94OX2tly9zP/BOsiqzrDgHX82RXxfEct3MdwC50Gl9jZ8La290AHBzxP7wojhfKVlOTbjEI0tex2Tj7T7u3mE3PFpNcGkuS0rQjXm3/Vor9DUqAFnNlKGEyRZZ0LdmWxGQ2BW/V4N2GkwT4n44YrjkHPNvVI7GxLzYN0kIC7e0ug1DefdFsbOm/p0ANOYzevtJ3aia5ykleYM9r9aM2d7/z3R6evV7mgI+wkxgaSqxLE17HKfjEOtkphLR57d0BBbaxn9ENY6/Kt/n+QpYkACbIeY+WgW74UxqoLmSOwNvezGvA9NvJr6TobtaB1WavVxPW/DmCu/qlp7oG1jlBYwi62J2b6kK3Fqas/3C6NKbyZDsbJSCAZ4DwCuQh1Zow9UzU0ET/pxK5ZTosvHO1Lq6B4HX0DIblpj
 QRdyKXgV
 SpEpWPlQBE3ZjHiiXSpA6Pj6q9CLV4/g9VXLkFQ6yTpP3wuY8CtEzVsFNa46qu0z/6xEKJUSQQbKnuoOpii5zXE2Qzh7Ndgeh6nzjxQlwwkbNoM06ZUQzdH1uB3Amunaeqp6L14P0tXjXpWiKxiNl+vmnufMP+OGjZu1Wd3BSkcFS+3UHHsb5W44K6w2ENVjNHDw7vSzL1rRy967GD8qsRjC2O8Uw+spCKcLvTUDUDzaZaBUGsKTm3z3RjsgOzwyPnXlt7sVpTRuAij6As/LKHFXSLkxQl77/Oh1QPvppo0q/beZciSOk/oE6XT9cDPIXrusr7hLHseXUe3pJyUQ+ioKCsWD3wwe9Fxl3YvDq+amDxPoNrbUF9gp6GqPIw/KO8MhFEdaKWHm3bkpbENnEXU/VQny3cFmYcXeHviRjZd6WBgY+WWZ9dPC52oD9YQ9sStgmAn5qR7cJe08hASmDsgwKRfRhfR2wc9Xvhzsd+T9ny0zu+lTc2PSGNbtyZwVQKHu5IU/uCQcDMeFkA+WJ3ynEn8s8mbO/KFStNjtcA2iW3hdOQSjtz/V0duzHN5GyPqqymWoFp1ejBA3hzNLvyCozPp6SziT9EKreRBAZhXzC4QXo3rLl6JVL9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Daejun Park <daejun7.park@samsung.com>

__split_folio_to_order() copies memcg_data to a new folio after
clear_compound_head(). Until then, memcg_data of the first tail page
holds the folio's _nr_pages. page_cgroup_ino() can see that page as a
folio in the window and take _nr_pages for an objcg pointer. Reading
/proc/kpagecgroup as root then oopses while folios are split to
order 0.

Copy memcg_data before the smp_wmb(), as before commit fa23a338de93
("mm: separate folio_split_memcg_refs() from split_page_memcg()"). Add
the paired smp_rmb() to page_cgroup_ino().

Fixes: fa23a338de93 ("mm: separate folio_split_memcg_refs() from split_page_memcg()")
Reported-by: Tao Yi <escape@deepseek.com>
Closes: https://lore.kernel.org/all/20260907124001.1544655-1-escape@deepseek.com/
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Tested on x86_64 with KASAN (7.3-rc7 and mm-hotfixes-unstable) in an
8-vCPU QEMU guest: six threads read /proc/kpagecgroup for page 1 of 64
THPs that debugfs split_huge_pages splits to order 0. Base oopsed in 6
of 6 runs, 4 of them within 1.5 s. With patch 1, 8 runs of 300 s had
no oops.

Before 7.4, page_cgroup_ino() and folio_memcg_check() take non-const
pointers, so a stable backport needs "struct folio *folio" there. The
hunk applies to those trees without a conflict, and the build then
fails with CONFIG_WERROR=y (-Wdiscarded-qualifiers).
---
 mm/huge_memory.c | 17 +++++++++++++----
 mm/memcontrol.c  |  9 ++++++++-
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 14599d0fff..adc5a47ee7 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3768,7 +3768,19 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		if (folio_test_swapcache(folio))
 			new_folio->swap.val = folio->swap.val + i;
 
-		/* Page flags must be visible before we make the page non-compound. */
+#ifdef CONFIG_MEMCG
+		/*
+		 * In the first tail page, memcg_data still holds
+		 * folio->_nr_pages. Lockless PFN walkers (page_cgroup_ino(),
+		 * page_owner) read memcg_data once the page is not a tail.
+		 */
+		new_folio->memcg_data = folio->memcg_data;
+#endif
+
+		/*
+		 * Page flags and memcg_data must be visible before we make the
+		 * page non-compound.
+		 */
 		smp_wmb();
 
 		/*
@@ -3803,9 +3815,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 			folio_set_young(new_folio);
 		if (folio_test_idle(folio))
 			folio_set_idle(new_folio);
-#ifdef CONFIG_MEMCG
-		new_folio->memcg_data = folio->memcg_data;
-#endif
 
 		folio_xchg_last_cpupid(new_folio, folio_last_cpupid(folio));
 	}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d..c244d56446 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -375,12 +375,19 @@ struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(const struct folio *fo
  */
 ino_t page_cgroup_ino(const struct page *page)
 {
+	const struct folio *folio;
 	struct mem_cgroup *memcg;
 	unsigned long ino = 0;
 
 	rcu_read_lock();
 	/* page_folio() is racy here, but the entire function is racy anyway */
-	memcg = folio_memcg_check(page_folio(page));
+	folio = page_folio(page);
+	/*
+	 * Order the memcg_data load after the compound_info load in
+	 * page_folio(). Pairs with smp_wmb() in __split_folio_to_order().
+	 */
+	smp_rmb();
+	memcg = folio_memcg_check(folio);
 
 	while (memcg && !css_is_online(&memcg->css))
 		memcg = parent_mem_cgroup(memcg);

-- 
2.43.0



