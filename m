Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F3ECD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22A086B009F; Mon, 18 May 2026 20:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29BA6B009D; Mon, 18 May 2026 20:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76936B009F; Mon, 18 May 2026 20:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC6C66B0099
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:19:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 816681C0089
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:19:53 +0000 (UTC)
X-FDA: 84782261466.30.7544FCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 73E0C4000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:19:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J9DRXfHT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779149991;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NGomBzgbQZ2ySVcBUiVnBbzQ389Zl/ZMfXWk2cdyTx8=;
	b=QxufeA/uVwIgo9JzNFM3aaXLcWlbWCmDyk3Psj99ddO1IDprviQ8GGE+PSdmd3NBFXlAH+
	M0Ktx5+iwN1QGD2wSOcsks1IZiuk2etxbpBK4Avo4iVhNwC0m1c6ZfaKtv/Fa+iOKjgHCF
	FwP9UKbE6/NnvGjkve12uK4Kt32Gp3k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779149991; a=rsa-sha256;
	cv=none;
	b=ZJnkKnOwBcWg1zg+BHH+g/Q5RFurvmBVb/pHnHR5fg1iEGO74kIm0k6l7+Sv32uhK+xCGx
	qt9nMspl8irWGpKehU27mYGkNUmrRvMYoWHVJX7kAN3/vxZyVr52Yy3ZjdvNBbXIIuA2IT
	kpLXcGgQ7sXLfXhAk44xKg7daYe3cxo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J9DRXfHT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 998A644579;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73B2FC2BCC7;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779149989;
	bh=3zXO270ajr1tnjZV8A/bAEEs7bzJ1z/L+UKQw43NjcA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=J9DRXfHTV1x2wT9FDO37latHI4bpt8gKaGiG5kfWObrWNPOZ1PwiIDrOaEJd+qvUc
	 fX8hs18VuXivZ952QtRTEqLm9GDQOebDPvvpE9leVmnrASt8EZc/cXz6xShxEgVU0c
	 b4smGrhdd51TB8f7BsoVCY4yPNH0LmIU3+U7u4X+CnHBCK/Bx6W2HZhu6J0m+pIZLN
	 iHZhcVrD/U0y0EoS9jwt1VwH06vAlMgb9QNeUtqc86x6/5dUBPPKicK9yb/AdxLiPY
	 eVFi+X0T0rI6PwlZjyYq5+elbPAY9VpQNo7nI2LWfrTevOu3tHlBQceHIEdmUp/aY8
	 JXySAESSXTJgQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651A9CD4F3C;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 18 May 2026 17:19:44 -0700
Subject: [PATCH v3 5/6] mm: hugetlb: Move mem_cgroup_charge_hugetlb()
 earlier in allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260518-hugetlb-open-up-v3-5-e14b302477f8@google.com>
References: <20260518-hugetlb-open-up-v3-0-e14b302477f8@google.com>
In-Reply-To: <20260518-hugetlb-open-up-v3-0-e14b302477f8@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com, 
 jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com, 
 mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com, 
 pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
 rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, 
 seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com, 
 vannapurve@google.com, yan.y.zhao@intel.com, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779149988; l=2460;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=D0/c/tPxzDKBQ5LqjBs64oNrn/JHwmJjr3L/Nq/FGGs=;
 b=5rbwFVt3aoGkbaTw+PHbELOYhBY/NhAnIaG1JfuEYmejI73V/Ie6kUAohYd18a9Q8wrlAb3d0
 25QVtOzNcpCBbwDanBDndQxjoPXO5fAgCNnuuhzu8IADnbhR2zQU0vp
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 73E0C4000A
X-Rspamd-Server: rspam04
X-Stat-Signature: 37m5hwtoz54eysuuh5moukppwjidnq8a
X-HE-Tag: 1779149991-245520
X-HE-Meta: U2FsdGVkX1/hMUuD7oUk6H+BNDcRc45sPVb4gWuwMAE0oT21h9f20AowyHuMbnOcEGxqYC4ReMlv0CGfQy5YNs6/S7T1OSEVPlhap8nTamNBZHJmGQA/XENjQ2DcSE98LX3a4XA10RzTjRMG+awZXTB2NBxrbwRZIrPRM4lpq4KO643Q9vwhth8XuIFpZtS2+UZfWvBi05hIpmVvLbQS6fSPwq+wnx0+ZPzr76KZINZGCh8G8TpEA2aaG0FUvGCZfOXhTJ+gL1vv6EAmaWQFa5BBc1urrSQTTUEUA/ZlauYuCEWpiWpJl9oDY664eDpc7Ki8aCzYTFPOYHgQhrim/oMLQ971IQgO7KJbQscrN+8ISKgEyZ+26nEgtoBz75fVlDEY2fWhGkMcbo0pcuCLxYGYiUCQ/4BUoGoG8Pp4uLvlLKLu6dQM2DAhAWiFDuakNrDXUsuNsiXlNwx4jnqKAcQBifftAfuYimb57gTQzhPl8zNxvOho1iBkWmYXY6WDezLF9Uzkw4FVWgQw67t7CUvoPMe8CheNh6bRC/xwi/uKiQ0HJFxMxnHBwCkzBdjPHGasGfs4q8HStfJ2pWN0PhCMIZ53D5+Q2MdS1yT8B/8RnvgKk8dr/TynJG+o/qw0rUzQNXu1edEzIjLbO/vmqkJr9ALjcX0Pd7pKyvg/wHfkQAk6JNeE/15HTT0wkFRsy64f68WYoRm7uO/PyxgYDVZipjt9AJbl48rqdwz5xH8KkrHrqROkV7aMhNvB4tf0thNjYHcwcSR3/8rGy5k2tFhTpbY9FuJg1OUBmpI91M6k1/l93JR45FFIWcmMVGB9O7pD+C29a4WHVIUIYxZCFZ6wczgUSStdwdIZqZvON7BY4KAhjtixYJU3pCJZ4ERKcobl4e/9DKiRcjPf46ADXXvvV6GGA7nSWHq2U1ec3deR86KSR1ZimC+O9V6iS4Arw6hypscHdV6y8a3MXiK
 iav2nMfP
 DNaAAtprCbgEzQT2bdjG0jsTItlQOjX1zbUJrVobf9WOQFwpMXLfLe3liCuFEqJh0tBdBY/pTCmD6MXnmQf3xmdgaCXl1VX6LMwIPjtmFlNkfn8eJFMS3d3vv63J43apO/A5OngN5lNHnR56jbgcKwqeeLbY6k1AhH3gb+Wht7hl5h4x3MF5VtdWbE+Zf7qQ8i5mnEYTUdsJhGCrH9jJnyefcSq3zHnZ14Lz0x2b1hsDjKJ1IdvJ5ys9lj3hB2BC9qCyl6AZ8jfkZbSZfmgbD/ptxLo7U/tG1F0qteEvL/Zno0Awsp64PRaNhqGRt3RwwgRSSBWWEPRDHNW85cV0UzvT5UzHLvTY3a92Gr7QSyRzSrrJb4izyUdnZ9uEYAXFKTzyCn0Hf3KMx3zRCfee2UiHzIY/KrcrrfFWHRD7lFDyYkoFY0gbU2gJNdO5K7l2ic+7z+e9Ir86gLFw58tKuou69Ny2FM4Jkb5/mTvgSiHbB62CI3BPaiaKePJUS+blCgHWc347DkqxEqbelCb+tB7qjnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Move mem_cgroup_charge_hugetlb() earlier in the folio allocation
process. This change draws a cleaner line between memcg charging and the
subsequent hugetlb-specific reservation logic for VMAs and subpools.

While it would be ideal to make all accounting and reservations perfectly
symmetric, mem_cgroup_charge_hugetlb() is a complex operation that cannot
be performed under the hugetlb_lock. Moving the charge to this earlier
point ensures that memcg charging is handled before the code begins
manipulating subpool and VMA-specific state. These two types of accounting
will be separated in a future patch.

If mem_cgroup_charge_hugetlb() fails, the code now branches to
out_subpool_put to ensure the folio is freed and the subpool references are
handled correctly.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ad07e72d6fac3..81e73186dff09 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2991,6 +2991,24 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	spin_unlock_irq(&hugetlb_lock);
 
+	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
+	/*
+	 * Unconditionally increment NR_HUGETLB here. If it turns out that
+	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
+	 * decrement NR_HUGETLB.
+	 */
+	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
+
+	if (ret == -ENOMEM) {
+		free_huge_folio(folio);
+		/*
+		 * Skip uncharging hugetlb_cgroup since the charges
+		 * were committed to the folio and freeing the folio
+		 * would have cleared those up.
+		 */
+		goto out_subpool_put;
+	}
+
 	hugetlb_set_folio_subpool(folio, spool);
 
 	if (map_chg != MAP_CHG_ENFORCED) {
@@ -3018,19 +3036,6 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		}
 	}
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
-	/*
-	 * Unconditionally increment NR_HUGETLB here. If it turns out that
-	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
-	 * decrement NR_HUGETLB.
-	 */
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
-
-	if (ret == -ENOMEM) {
-		free_huge_folio(folio);
-		return ERR_PTR(-ENOMEM);
-	}
-
 	return folio;
 
 out_uncharge_cgroup:

-- 
2.54.0.563.g4f69b47b94-goog



