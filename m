Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5A1BC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58FD6B0107; Thu,  2 Jul 2026 20:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08B86B0109; Thu,  2 Jul 2026 20:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1E526B010A; Thu,  2 Jul 2026 20:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 848136B0107
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:41:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC0601A01A8
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:21:54 +0000 (UTC)
X-FDA: 84944352948.07.9E4E3AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id DC4411C000B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:21:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k9IwhmZN;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783009313;
	b=w6smdDg8pO/mH0MhaFWztf88qLlAGxxEH2FUnUOlYijFKH9fogCOOl1AOz0n2E67+4dKGj
	5SCU++5fKd/gnAJQ7CMmXqQt0ROYCk7Xacy05SHvLkIqoEpQflVqJ4/AXDnibFvgoM41+x
	ZMHFaXSbzWSJxTs3AnV1fSP3TCH+EUU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783009313;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TA32GZDgoTG+iKVuAC+sQggU85EnQXYnli6e9hB67E8=;
	b=FEzX020HSRKJjJGz3ocUI1pM19pR7mxsd3Bd8T4Vf2FngT8bba9iaA103BwpIWmR66lDIk
	9gpgxPvbBcKlfBqbN8lh//oW1Hdv0V/Qt0YnY3T4izaYopMZybOtvXJco8ro64QEE95Ge0
	o2VerP4zMUY55jQqa3XNs1dbLNQTFNc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k9IwhmZN;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F50643A98;
	Thu,  2 Jul 2026 16:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DFACCC2BCFD;
	Thu,  2 Jul 2026 16:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783009311;
	bh=ScYrHpTLaEGY4fjKrOJyaCi7PO9G1jigzJNU7rgVUWE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=k9IwhmZNmdFARvVe86zxnQudgxEJ1/UiBIiBdyzt6YCNeIdDEKl4m7FTKNw4BqVtk
	 U8jmtXFcl3uSkBrf5CxKlQ8u53YmDA6a9z/1nP/TZrLwuW22V3hRg0mNN/+uPzOR6E
	 mETvzcZzZ9f6CzDL1DDxYCDjkMgS+7LCIFCvc63hE5IArSrzRjx7noVDLL00k56HPj
	 NEuiaT8NevDexniM5A/z58PTGt9MkB+OZ6JBR/Pvc8zMWQQipvjiWJFIckx3Sj3xXF
	 t8TKqPgMVfhx94g6GuXigauE3CRjYpK57OgTdAQaKrPiwg2CM+nl5K+ri982CYroSL
	 WXfsanCfk4SJQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCED2C43458;
	Thu,  2 Jul 2026 16:21:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 02 Jul 2026 09:21:49 -0700
Subject: [PATCH v4 5/6] mm: hugetlb: Move mem_cgroup_charge_hugetlb()
 earlier in allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-hugetlb-open-up-v4-5-d53cefcccf34@google.com>
References: <20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com>
In-Reply-To: <20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783009311; l=2464;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=YM0eoEwVRqN15NAQGhn2SLgSWfw138+SGW7+3TQlWbo=;
 b=F0Gzg9RzlR5MOiq9ompvYrScSReWJeOqgKYjCXThSWDFTc0gk7RyAq2vOnuPy5b9E46AKtr8U
 eM0sqLwP6l+AlfwMsVz9SUsbxBp563HNl6n7VndW6W6zk72Qk86xXe3
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: fzkj647wyektg11i3jx8rc1rjnnh1jze
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DC4411C000B
X-HE-Tag: 1783009312-970123
X-HE-Meta: U2FsdGVkX193ylzWoXum2S6eChX9bawhWLglGbUJ46UFS4BKHQoDeXuf2XsQoF8UxkEktsWMxwBrKV7jGuQ5Z4IgbcbhRtKR5GyfIaFBJp9iscUmn3+kVEtdl0AoJKfKSm2N/VaVDlnKxb8C9ajJa24aFv0wtaNsW/HclJkiDNzDPmKSwiTTcO5aQOTaF4gPV48JxCe+KMyzFkCfapSkEoqG6OCUXbyuup5N2kNlyZZH8rBCoBoF12SmD58FIiLpZavJpOBrG+K9DENVy2M8bMReWWD27g3lHMN5SQSCiO2efhRvmZNqPVgBNzJMHmM1FHCLto0l7+4WdbwUUzrEGa6wy72ALJWEcM5H2l9ZORGrvDmPVMwOJ8Q7fN3vH7zfxGY1Qte8fVrzyxchdxo01PBYK2FFNm39eVsmzZUc1GGqKAMC8J4oOY/t5HHw88yXftVOhKjRUVPv0uNfhwWSxjboc3ZKGHKBfdiX74W3SDGkb5G36U0K2il96p7cbK/eDhQDutf1DArwRroGP+M5/iM7m/go+Tnx8A1uKpMZ0eC4zIdw5MDisXy2FchL6JcyNUked7VLiOGYfwBRqVYf9pLx8nWvkgnT/N2K/VIr+YMVbjaBFlvpWo4/SqdIPK59DVHE1HFy37rvxcB+R8jDWoRpgHZAuthgTukuyYG8gYhjRTO3xNxhXzArqGXfbjCme6k1oYHtr0ayqpP05tla0PFlC5xkggmsWNkuUz9pMFNy6/uMpX/jUiEMuvK313DUlAZ1fRHjVqwpQzz0/5HIvj1X2N95cnIiIqF7T1BhwH39fAhhK3SIZn6sDaYNp/IfbhTkE8dKIcyVA5cADn7rs/7iqCPpp3wc4YPjsy5CJ313LftBO7RTB8w5McJmQzQT2aFKa+xs0qIt7KscxvV/RH9T2KpNJ9cl4OhfZzA3bohNvS62oFzpPBrq53l4F7KjFg0yR33qf99CLbViIeL
 sY15f7LH
 fEquRNeAUFmwIRbTClfwNtJRlAvCbwWrOzVqSm4fJohveCEFmMcNlJBm7wq3iKRhYmz7hSW86c1prXL2o910mpZZorm9d1a7YOqdjLTcLa2jYhIpYmdjjyqZw+TRmkiG1n+34PddKekW8vdg3vQ1jodQf+5A4SCDAJrhGlCEdG50qG7kF4BnA0WkmhSAQZYJ5XLRPD6ULf8hKQmDhScNl2ebW1YO7ZY2J2ayv5aXwKuHxvVrPhdLXbwDiXfznScmXbB+SW957SrXF3shdY0o9VhPrfc8E23UU0m8kcQ3XXihmreQ3mZW5LmXq5PvbWfdHoGM9rFf6+iiOSLDvuFR5jk99umfIra6MhmxA0Dl1z5KKVrX+bst4uYwtyOURohKMlM+ZW0MKFTl5um2YYxyflbNi1gAkntPpEwU0lpzsem+B1XZv4ru4cZ3pzBbRJpabF0UkToHRneIHcxKF5u0N3mwQjJKdtbiGX7aCN1wa6S2shJjLX7ndth1ZgDTwX1isUw5dKLNiib2pS0pSJIOmuh4dE6x8q8CI5OcY
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
index 176b7e9130a38..08ac28111e694 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2978,6 +2978,24 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
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
@@ -3005,19 +3023,6 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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
2.55.0.rc0.799.gd6f94ed593-goog



