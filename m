Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86EFF606A332
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 06:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LNL3ving
Received: by kanga.kvack.org (Postfix)
	id 59F296B05B1; Tue, 10 Nov 2026 01:06:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550016B05B3; Tue, 10 Nov 2026 01:06:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F626B05B7; Tue, 10 Nov 2026 01:06:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1ACFF6B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:06:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A2BEC408E3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:06:10 +0000 (UTC)
X-FDA: 85418174100.10.3BD8194
Received: from mta0.migadu.com (out-82.mta0.migadu.com [91.218.175.82])
	by imf27.hostedemail.com (Postfix) with ESMTP id 614D040006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:06:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LNL3ving;
	spf=pass (imf27.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794290768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=782GmxyFzfSf9cS8To0AwNPsA3l9Ic+2fBQKfnHkhgs=;
	b=QQayEpq65x/bqv2eKOVRDYyvpO9qRJhgUlMQ7G319PAl9upb3JNxaNJbRrc4GQBLkPCFhd
	OEi1vc6BFHDvK1eJcV8sJ/umzqLFwm6jPEUe/+30gg4QUosYaHCdE/3ET+hhF0KvEMs+tB
	V5VcMUN99p6MICqS+E3ut74boTwkSpw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LNL3ving;
	spf=pass (imf27.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794290768;
	b=i/gDFjOmQlwC6YYu2cgat6eNEHBALqTPeRXgK7wF5DT/IywK0DED+atpq56Lir3Q+98441
	D29AE6PoxdLri7JdKgRV9au0vrU4ynjBtC0/K7RJiZphiOIWo5Hz8/o7izx0QmoB5/gLE+
	3J6+hVXJrY4sTcrUrob7wTzJA0k10b0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Qn99IbL0tjCg14t3VJn4RbTaLqaX5gh8tDLA/0sbaFA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794290762; v=1; x=1794895562;
 b=LNL3ving+fxbEK9pr8Ym7VT41SGSHfO6hW43i4RWxp10cdVP85ocYorX7C1VsZANtL29sEmF
 c3OUG+OaNVUQKdf4o+dJ3kZj56lx3j0zLHFvykdw4mT/S8H4n2wdV44p/Y4cOvVuNO7f+Wv9k/+
 Vg3hfSPxXPDnSJvDTgjwOJnc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0dab969928a6af50;
	Tue, 10 Nov 2026 06:06:02 +0000
X-Mizu-Trace-ID: 0dab969928a6af50
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Tue, 10 Nov 2026 14:05:34 +0800
Subject: [PATCH v2] mm/hugetlb: charge hugetlb cgroup and memcg in
 alloc_hugetlb_folio_reserve()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-for-alloc_hugetlb-1109-v2-1-25795ce44f80@kylinos.cn>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXM4QpAMBSG4VvR+W21rQi3ImmOg6Nl2pCSezf8f
 L763gsCeaYAVXKBp4MDuyVCpwngZJaRBPfRoKXOlZKlGJwXxlqH7bSPtNlOfLNENJgVlJe9gnh
 ePQ18fuG6+R32bibc3hrc9wOwAr27egAAAA==
X-Change-ID: 20261109-for-alloc_hugetlb-1109-0ccac58e69d1
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Gerd Hoffmann <kraxel@redhat.com>, Dave Airlie <airlied@redhat.com>
Cc: hongfu.li@linux.dev, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>, Daehyeon Ko <4ncienth@gmail.com>, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794290755; l=4187;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=+K2qRQIWYp4nrXE3VguRotyo4IOkkSIXCtrdykxyQqY=;
 b=GIgizEEZ8nTXph1cEv8EAm4eZob/if3HWtcDVOQuQ8Y1ipBOyHd1Ve5iF5KaqD2pZBsnrHSQt
 GVWYlvdbewwAQxFS6W9BWVtRueBeUwMacw9TH+qNQmisMWHLXl3N+eP
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Stat-Signature: a4wtjxfcg7bbeskpb7am7r5o19wk7jfd
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,LOTS_OF_MONEY,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 614D040006
X-HE-Tag: 1794290768-729703
X-HE-Meta: U2FsdGVkX19PVDealxF6Qkg/WvNieXSKi22gPAFUhreia8HrtAkXq6u4h5/FDuNU9PZT9hYHFjOEgBOytVSSH6muKOIrD/pap2q2P/VU9+TMHdZ/6Lwcb6EV7voPAih+fudtPmaJkf3HWq4kIF6ltsHFwQLNTcG+hcZ5dGbb3bVgA9H17VIK+WjsO9/vPzXStRFknaCGEsbMqi2lE2/8gT2sdE+/t1dpraGAj6KCHbDFPOpikdyEibfHOoOEPiK6KBrlYDYjD4NzUGpK3tKXk/AyONItJDE64D4VlyaKtSOVMq/ZU4d+Wmzw/3Q1bPFcHcAsGUNU5hi/rt0VHi9yWW2wRkSsuPQ2MtFlgCQmIv4drXqtyu2jT+ep8NCxgH8v7m+DXf5b8+oeiLfoJ1R0mA86X8K2fhlY0VHAObh4CoGWzuH6YqgosrRhzz883p0j9PmjMcijnf/YT0E/Or59tIabrrznc55RlxtCxwhg6UBOtAXf1VL7A8hVIwV0f3qPqEaySxyz37mBYNCFWi5sPUKYss4ve+i0SXe19ZD+Tt9AKcqk40805S3RldUNaAFJKat41I1g2KRqhBL7uVpy0ji8irTpH02pBCqMtix2epslvpmz/n8ewReOyVzGAvLTj+O5+UiZYk2LY3l6PpoBMALJ4XSZ09izbd0SOdk5rmCiinFhVqWbKPUV3xUDKhzFSr5aFoVS2gB4jJWlcH0LO+1BJejjsdv2zNXMcJek8jJUQAcRYrIgXWwSPiwzR4FwVhWu7U5Ld4WaVmhN54NVx93lGHbRB56hwwaOqDJcLQvU3LYKLpN8k5M/1XateJWAILCW9hY+LIHmakCZfJpkQes1a5eK/67BNdfkxpQ2Tc3UpnY8DiCzykIedX2gq3hST53iT1hjzcn5HLA6uDFeT4WC22JzsdDFu7gz+jvZIv2l+m9rWygctJMnjrWlOgolL38Q81iUCLVkn5k4K5B
 eWYI+Dc/
 iEjNu3PYlNYbv/w9gvj3vO+xuhDJel3FVPKeCDs0L78DiwxtVkkLP+J5ZOs1VjkENV4JlwIlHOR8pwojzP4Ur57xnf+eDetQkb+H8zU9liREx8S4o8upitFqj+aE1PKzZMTlYJFBevaUeMvNH3Xs9dBJ7lMRjlJr088/pDmPMEdpFuigWPru6IIFX4rPZLN5a2JihEm420P7mRFAXCTUd4v4H4XpYhywaxZkZyeww239HLFzn3ZVt9+2lOwI5Yn0VQeRrUffW62erf0qfX86zHtmP907/HgzaSdla8iB/w8yop0k8c03k1yuDRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hongfu Li <lihongfu@kylinos.cn>

alloc_hugetlb_folio_reserve() hands out a folio from the hugetlb pool and
consumes a global reservation, but unlike the fault path it never charged
the folio to the hugetlb cgroup or to the memcg.  Folios allocated for
memfd_pin_folios() through memfd_alloc_folio() were therefore silently
bypassing the accounting: they are never charged to the hugetlb cgroup
usage counter (hugetlb.<size>.current or hugetlb.<size>.usage_in_bytes),
so the limits (hugetlb.<size>.max or hugetlb.<size>.limit_in_bytes) are
bypassed.  In cgroup v2, with memory_hugetlb_accounting enabled, these
folios are also not accounted in memory.current and are not bounded by
memory.max.

Charge the folios to both the hugetlb cgroup and the memcg, just like
hugetlb_alloc_folio() does.

Test with a process that creates a hugetlb memfd and pins pages through
UDMABUF_CREATE. The counters were read while the folio was still pinned:

Before this patch:
$ echo $$ > /sys/fs/cgroup/test/cgroup.procs
$ ./memfd-alloc-folio 1 &
$ cat /sys/fs/cgroup/test/hugetlb.2MB.current
0
$ cat /sys/fs/cgroup/test/memory.current
1351680
$

After this patch:
$ echo $$ > /sys/fs/cgroup/test/cgroup.procs
$ ./memfd-alloc-folio 1 &
$ cat /sys/fs/cgroup/test/hugetlb.2MB.current
2097152
$ cat /sys/fs/cgroup/test/memory.current
3313664
$

Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Cc: stable@vger.kernel.org
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
Changes in v2:
- Rebased on a tree that includes Daehyeon's "mm/hugetlb_cgroup: prevent
  use-after-free during cgroup offlining", as suggested by Andrew Morton.
  No functional change.
- Since 268d64fabbf1 ("mm/hugetlb: fix NR_HUGETLB accounting for surplus
  folios") reworked the NR_HUGETLB accounting, use mod_hugetlb_memcg_state()
  instead of lruvec_stat_mod_folio(), called after a successful memcg
  charge.
- Return early once a folio has been dequeued, instead of falling
  through to a shared return.
- Corrected the Fixes tag to 89c1905d9c14.
- Updated the commit message to qualify the memory.max claim: only in
  cgroup v2 with memory_hugetlb_accounting enabled.
---
 mm/hugetlb.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index da1c17f14a62..256bb2095b59 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2223,12 +2223,19 @@ struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 		nodemask_t *nmask, gfp_t gfp_mask)
 {
+	struct hugetlb_cgroup *h_cg = NULL;
+	size_t nr_pages = pages_per_huge_page(h);
 	struct folio *folio;
+	int idx = hstate_index(h);
+	int ret;
+
+	if (hugetlb_cgroup_charge_cgroup(idx, nr_pages, &h_cg))
+		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
 	if (!h->resv_huge_pages) {
 		spin_unlock_irq(&hugetlb_lock);
-		return NULL;
+		goto err_uncharge_hugetlb_cgroup;
 	}
 
 	folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask, preferred_nid,
@@ -2236,11 +2243,31 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 	if (folio) {
 		folio_set_hugetlb_restore_reserve(folio);
 		h->resv_huge_pages--;
-	}
+		hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, folio);
 
+		spin_unlock_irq(&hugetlb_lock);
+
+		ret = mem_cgroup_charge_hugetlb(folio, current->mm,
+						gfp_mask | __GFP_RETRY_MAYFAIL);
+		if (ret == -ENOMEM) {
+			folio_put(folio);
+			/*
+			 * Skip uncharging hugetlb_cgroup since the charges
+			 * were committed to the folio and freeing the folio
+			 * would have cleared those up.
+			 */
+			return NULL;
+		}
+
+		mod_hugetlb_memcg_state(folio, nr_pages);
+
+		return folio;
+	}
 	spin_unlock_irq(&hugetlb_lock);
 
-	return folio;
+err_uncharge_hugetlb_cgroup:
+	hugetlb_cgroup_uncharge_cgroup(idx, nr_pages, h_cg);
+	return NULL;
 }
 
 /* folio migration callback function */

---
base-commit: 2c5dafa7f289d760f4492260b0988029aab478b0
change-id: 20261109-for-alloc_hugetlb-1109-0ccac58e69d1

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>


