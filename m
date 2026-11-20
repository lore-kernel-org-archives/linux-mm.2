Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA222606B22C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aLc7Jz1v
Received: by kanga.kvack.org (Postfix)
	id 5DEC06B05DD; Fri, 20 Nov 2026 13:10:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E8F6B05DE; Fri, 20 Nov 2026 13:10:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 408726B05DF; Fri, 20 Nov 2026 13:10:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 041B96B05DD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:45 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B924140129
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:45 +0000 (UTC)
X-FDA: 85456288050.08.97E6C66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6187E40010
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aLc7Jz1v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198243;
	b=pfmjVAi6dnfDw3INL1y/Kobub/tlioO04IgG2PzVhTIHjaC1myen5U1ss2lASTNANWOqFX
	1ZmQ4IBFpyYlaEHk9IheBVy5b/EoCNmp76srWGBVRptQs05VqvUas8KEkxBndyUdoTEgXT
	JHgIkRGiQZrXeDHc/y91k7nRluuqKY0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198243;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=08jpQl5uuZyQGxrg7doFW/+cSJVy/xq9ASMxnxrK8D4=;
	b=S806cXjwl9OxPsLQIYobAhVuHmz3OjbAOWh3ZzUi9DIKxbsYNVJFWfzqnhP6J3Xnljj9WB
	7J0ZalQTsz1jpYigSzPWzF3FqOITjwLNaW381qmsem/uussAT0k9j8BcC2XYTFlE+fDnOU
	FiOyuDPMJLF4hkoh2bKlS6qlJLAL3cw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aLc7Jz1v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1B34409D9;
	Fri, 20 Nov 2026 18:10:42 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198242;
	b=hIXIEOm9XnHj0MP0c0IZ53tJ9STzsYZM5kd450mX1FJxR9o6IQOhOMTgNGL4d1H1NJTT
	 3C0TGA6B65vuCwP9sMRRXB4osiq9ItOoPJEgUQ+/5mj4Qjx0erGNKYxlOKecz9eq66xFL
	 g2lbb97DRecrE19WzLJVOKmxqZe+9y8yQw0ez2F1eXI/OjjTP3CKE8TXcHDUszrt3t9tu
	 R7S3dTYPn/8iUNDwfOOm/0cs76e6Ouckm0ejGGd0XhNBXL0OlgJXoWqyEDHJaj3vMTiki
	 7uCe/3c/1bI1M+b1+OgR72DwZJJj9QilxevNSfEyliSq7xwKJ5GwhU5wHD6ebnGuuuw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198242;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=08jpQl5uuZyQGxrg7doFW/+cSJVy/xq9ASMxnxrK8D4=;
	b=bJ7N7j77yGTxZtUP29NN3gnS4yrNyfdrIQeuljDYmQfXaegDjMzuYlf30jNzeDnaF48E
	 dRpAaJzCZS3yZavr5hm1sRkVjoPLfkYitbJOODcF8HGzNmNuVdImxxq1B4+podyOzuBbb
	 aSUgUD+Vyj4cvAseT06YE1/WWkaBgb/kWd67bqLLOCZuMx9fJzZV5Fse9dwgY9+6L2ZZy
	 xj9yMFViva5JgDszZ5Ob4Ee1+hfVCMr0gTUPqAgKtgOwuWVkO1HZJAhet+JltHcbM3KZ8
	 zipOOyqqJ/hr+i236ulqAUtZ+EZoDFYuERS+NajHYV4RPB6jpu8hFAn6WB2p0s8ezSg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4B9E91F01826;
	Fri, 20 Nov 2026 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198242;
	bh=08jpQl5uuZyQGxrg7doFW/+cSJVy/xq9ASMxnxrK8D4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=aLc7Jz1vX2Td7GsGNbLreG6oz0GwbuKiqmx6U35zIEmx26OFNyCY1E60Gkes5ZzuC
	 bZUrL1dJG9NBMBd4UMcDyGjQDD4MWnHDzUdM9WGJ8gG3A0d2rbVflXB6O+SvEa+4Dn
	 GqzFORUtOq0p+idTzpCaAJCKR/NccxhpOwjw7hCYJ6sr2fSArCY2/qDOgJ+mXhzau/
	 Lsr0lWbRezz5XQQ6gUljaPXT9i1nTL74EDLVYTg//GBPha5C8AhKjmIjOToWaBUivI
	 mfHM15CEwrP8CIygAsXd+TXwtU7D1WuoYzjqQJyZXRc2JlqQVL8QD6bizy/L3Xq3o3
	 jKlHK4EVRpPpA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9880A4B959;
	Fri, 20 Nov 2026 18:09:21 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:29 -0500
Subject: [PATCH 38/60] mm/page_alloc: refuse contiguous allocation from
 private memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-38-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1528;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=SJvqLJtfHqxTbxOinmUOdOKCVWk7SGtVeDyrji7C2Tw=;
 b=Irg8N3GrwFg5yXeCFynVswMM6e7cnSR82GrmMFfEKmwMHPcu5/cEKgAKCYKrx+y54cYfXcmSK
 kzbXph7DqTTAa3NH+5AcJKokpz3sVmwYO3+Bw14lYWZ+1wiDm0fftM2
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6187E40010
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zjxgbuz1igkuur7ux8a19r9tzcpcqwoc
X-HE-Tag: 1795198243-661665
X-HE-Meta: U2FsdGVkX19eKo+xQ2fa5GttJ8QqmLF4fOb/S7z7V6J/XL9IliivPm5Xu1pB1NxArRjFqFyw5ke2eHXKA0UOqk4Cn/3F+hT/+8pG8YVy6I5zm2R4AOdTm6PMpaPfyGJP5MWznv8WgerWb54CtH+aFJyYeFb9vefDXvqiVyZaiwk8JOoSomP+BUJTEDrfLgFjG8exr/hyFIRkvr0w8LdCb8ZoLj064JIE5ESReyBhsKwO/ugmnWfXuPiDN/NCKyxdzVLeQJZU/8xKyoYw9m2ySPe0zbqtBfMZZXTjYG8O9xbF2jLQXh83YCPuqIzKSccc8zJCeb+xIVQr78o4vXb2oFcrRqyWMXikkxfssjKHE4421KXgs91dIa4WpNsAsZInnOERt2N+TRlVu6RiEg36MF9jTpq/VZmeCMXd9iAhCPj3gQgGNtksoON+Jw8TX/XJRV1biKJmoBUpHJ1vavRCkgbjUWE796lPs7wbiN7Hyih5Ea1LK9aZvuQTQ42/aKXNAwblTJx3aYcimCQ+NVtMkMCH2cMC6DUo1NqMWPggQCRyiIGKfBGSr/oK36UVpv6JnE58N6I0YQb8dX/4+eAU1WZ2upjByxFjUXl3Evi4wWOqYICqY5yRkF1zxdq35xtfiAeB3ohFUwME6E3MWj8x4gI3+B89dHsEZEineHxoLnPYaqkgE/EN9ZIUjYQwOi/CBfl08b8r3VEwxP2qu/+JUb/NoW1b95CEmujcIvjJ1+rT5ZzjkmtXhGJDJngCq31VcLoPnFD4m+Zm9oMwiVbNQR4FgujSOwBlos9QtL4bH2yfDfQQj80mBi5UuII9ybKtteYR0NN1ZptLma/DjlC46GxulJmmi+M6Dwd4/tszacwBPHkuIMoy9Ma0igrFYtAD2VWL+8Zino/BRPpJjDra0Mgc+QzqxelbiGqL4YADH05aatEEpxEewP4Gz66UzKEXqfvMBQ57hWkKR7y4L7u
 0uUyAumU
 pXVkwxdktBbP6SOPwW3yOPV1TDx1aInXyo6nQdxIJT/R/mqHM91Jj9u4t6411Ttm8AG2wkd+FFJEtCLh61wRQRvAt0r8YZG3W2KVmxSqQ8JKnDwoW1Kn+VLAisZ0sXOCtcc5daoOJdjBS+hBo7/FtsScAtpbey+eRhDSYhpRZGwCAiTWoFG9qcZwl7Hw8Ewzif4IQXxURmpzKynahdE6tz90bgjPAR4B5uiJmwdGoaeHi1E/Wck8TtQeBXuy1tiigZrfL8imZwsQ93XIom709i8JiL7q8lmUQE20+lJYGWjg2gXnxkv6kfsiauLUAPzcdsIhYc9umVPo7l0Cw30HyB2325e8v3rqW+yLcj8jalSAvUV9IK2bt0ZZor5/LBTRUYoz6Rz1gU+H5i8pi9jMmcCCL3+fwnY5XlY+z3aWpVYhDpmjXzSn27/9S36ZXoefz4mtsezRBretWS9EiQN/rSs4MjNJ+dknS/+GnzuHiGYxPiWERkCsozzaHcl76wkxW3HVFDj7KzUlEUMsgaUNkW9lMZnn8S+HDC0xYypfzwNgXzfPN53xpb4FpNI2FRlEpIXQdTztybZ9/JzPvbHJBJqgIPXN9R33YUbihKLHMXsOiKc8nbBmX56kJK5tghwje/0Bwfymz3A3EYoMYbHBbNqB/IilNlBcAurOsf5KPQG33svv7Xb/eSYBBPgoEk+YVFL9JmReWoPfYuFHYNaPjgGqg2VaHpvWhLPeqw/AovZZjHT/MluO8YzJXHrWIfwv2z6vDKfpc92zEpqqQgJG2WQ89JYchjl3ywcR2V4oz5fTU8Iw5bm9pgVjsKEf2r2pMKUDY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Exact-PFN contiguous allocation bypasses the zonelists and can invoke
compaction and reclaim.

Reject a range on a private node with -EPERM before isolating any pages,
and document the error.

If a user of private ranges shows up, alloc_contig_range() can grow an
ACR flag or an exported api for private allocations.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index de1a13a91ef4..08e57f809a03 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7379,7 +7379,8 @@ static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages
  * free_frozen_pages() also could be used to free compound frozen pages
  * directly.
  *
- * Return: zero on success or negative error code.
+ * Return: zero on success or negative error code
+ *         -EPERM if the range is on a private memory node.
  */
 int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		acr_flags_t alloc_flags, gfp_t gfp_mask)
@@ -7410,6 +7411,9 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
 		return -EINVAL;
 
+	if (node_state(zone_to_nid(cc.zone), N_MEMORY_PRIVATE))
+		return -EPERM;
+
 	gfp_mask = current_gfp_context(gfp_mask);
 	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
 		return -EINVAL;

-- 
2.56.1



