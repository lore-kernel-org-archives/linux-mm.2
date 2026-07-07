Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5380C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137426B00AB; Tue,  7 Jul 2026 16:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E94A6B00AC; Tue,  7 Jul 2026 16:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E549C6B00AD; Tue,  7 Jul 2026 16:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B4D446B00A7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:46:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2CD86C3A54
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:46:20 +0000 (UTC)
X-FDA: 84963163320.26.C17470B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4353B40008
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:46:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MGLaUjmf;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783457178;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yo+EOpfbjsbji2M//ed7x6CpII0lppHzvPRQm+Y6tJY=;
	b=N0pz2xNbrpgyAVihNBryCFNakV9cxToVjJBqhTJ7lFH0qJsJVDQNMBkoPmuRX7LODs2DrT
	8KsJD0qLCwBg+Nlv3GNhGGuf4syoRf1/4SlltAeLKOxiHWSArSLRl2GrhQ/NImr28OcHr7
	/UScd3/ljm3g7NSD60XL+rUG7Y77iYA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783457178;
	b=Rwt+1VfTL9xOSYm/OwhmNfO0EiqwPOe7/zINxiNLDW5eg5QQezNNZaJzGN4eBHrRaNtIJZ
	JKBHbIHjU42ap/934qfRwC7y3tfyRWmYpU8DnEt+ege1DVU1GtiXphx+Wh+9d47pj/K8NK
	vmEbA2FYUDvV0lU2s3/G9q+8eN6+tDA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MGLaUjmf;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 909506001A;
	Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F1B1C2BCFD;
	Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783457177;
	bh=5ThYgcN+b4g/xLOpKhLOdPQJw1KbHaloeJb+6I1j5qo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MGLaUjmfsguZn8HPzoo2Y45/23NfL2g8oAXId30Qq7MfWmI/ZR8GIho/mPPDzsO5z
	 9ni0ZuU5P3gTaqXBVkdWNjU++lYZv/SOhcNgxU31at9CHZP/bquYYZe+CXCSEB4Scz
	 Tfrs3v9BcH0gLWFHiEyNvCykl2PmaAXcHhFu9MhXaShECFouvL9YBPgk4VkG7mnm2z
	 eSIWMQkysILFMsKyKlieeOnrVaZaK88oi/UovdlFlZ8WoFdwmeisSP3xusx3+ns/Gt
	 cZ+nuR/lCQp+4zPIkdQFArKH1hjIHuB6OlcjsKnt9E/DQTPyGVgGFG5NFqH1huArHS
	 PQBlvqL9WpX5Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E53C43602;
	Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 07 Jul 2026 13:46:10 -0700
Subject: [PATCH 3/4] mm: hugetlb: Return -ENOSPC on memcg charge failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260707-hugetlb-alloc-failure-fixes-v1-3-5bbd3a4b836d@google.com>
References: <20260707-hugetlb-alloc-failure-fixes-v1-0-5bbd3a4b836d@google.com>
In-Reply-To: <20260707-hugetlb-alloc-failure-fixes-v1-0-5bbd3a4b836d@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783457176; l=2099;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=KJOGTu8oQXjrNCEEvEkhcI0Cb9m9KqHL4JLws0fGEuw=;
 b=GnnPrNDO3D5PANpi/l1tjqcwcySr9IkLyYoo6FjNI4ecTCEbgmi3MsCSq0AsB5yxasGgmjIYr
 VvGb36lZjg9Csz6hY04FEvwnHS3hpY96Zcws9nyBzEzRaUv5PxhODEx
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4353B40008
X-Stat-Signature: uu4d3p53q7tuf59f6kmy8sb7ou8pbcd8
X-HE-Tag: 1783457178-707512
X-HE-Meta: U2FsdGVkX188cBXp0H89U76A8YhA23wbBJkO/5Jb9mbB+ZZhGMSlok/b7s+dYoj2Xl3dBFKUnn9UIQH43GE0mNoycNVjmkDGdkj20LAcIxY1mFiuIeE/Tvl9du+yH53rgnD8REAthkLbiuc/Fpyzu8FzYjG/lObGHhRdvJKAJJ2Nd/84KjjdS74DBnNecMUzsKhq9S0UiZclDJct0UkWg+iOwLWseHhY5rZwBpX0vy3qIYUGNTkoRzPhq5H9yg6xqPTsHCrS/sDuLpFxUgGCzhFdE8N/BXZN6MQqP/YBdf3OIacRv3XWlQwG09oyzho75Mh6Qe2ujU1Zx45e/NayrFM6ds6l4NwwKozwEwd6dH4EmndGLSBfpTf/PyMZfQk/XDa6tqsUJdP4dzgym0uqgq2/PEU/Z69yePnOvg8gjveHwfAPVgu9HDEMD3R3q7KInZC649lGOsMENNWJ8Zg8+PHF6Z5Hobvg2PYHvfIAcAv+FNswv/CuaWmsBurCrZ4KZWv/JFw6GmbH13Am2vW/bIHUVnwcbBQrtflEc2DaLvMHUNKR3B9k5bLvq3IE8XbcuQBSKm4+iXGHhN4k+rZtUhDgxYxg3UReR6C/ZpRfylmuM9A6YMNj4Z4zwhOIVN2CChts89qFzpIcTLGyjRN2TGJ4QghrndcVX32rRGhipy0NL1HlYEV2UzFji5TdWUftpJRErLTiT4lPdxfjIDbmIout3MLGW46Sk9GHxJkdjBXbg/gnG7xbrwKJDRTynM2gGXbmU8NiQ328UnMJbQ3dxvmC+ta/fxCFqeXLmWuIqb4KR07vW7fh7fJThmx9COxQE+qffKdYdkz1LSOdCyDxX0xcjMDbUnaD+V9P6f9L9H8WIUZCEVPMlecIkPoMfORfmhJsEkIx27qSrprIEqSaxYQiL9obRBJeZb8Ba5NS/r8QBi3W8qfquXPkee3TXwqFWAeiPEROVHPoltPET7q
 MT7AcbfK
 AjZEGKPtmOxIKScqVzU9vnEWPQ1OUozwtzHvAzIh/FMfoblws7y5rNDZsYE9COuLNDgvvFbwnpjJH2K2eumIU5lle3LWpeGY7R8vC8Fl5SUOBzxtvrjGJZL96+ibL+6dnT1yG8EtvmGsNhwcb44Z3pWDs34yXWRKW5GXkFoWloxNosTxUP/x1XzmZy+q5rj8PROlDN0TqzXKjBYcP3nYVvW0z5DGIR/qZ60rAuAhLlxq4QpFZXFpupH3tkHoIDby6xCMMzWX1OYQ+RChqKvfNjd7zH3fWvU8BIIzFXviXsGQc/nf9eeprDs/GFYBQ2qgeW43q7C8x5ZurHWgqJhGtTwciHM+PRNjFrw+eDNLQC2J5ATBzVbeASP+XNWwLc+utZkVyvNPNca0oivX2P82PpDpWfyjYa/BMnpltRse6+opG0JYqL1sbtU4QbZit/QIfti2GtN9FFAdN827CbxdjPVId/LQDEICnVP3KoF/QTZZ6p/D4Ih0uiUsjaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When mem_cgroup_charge_hugetlb() fails with -ENOMEM, alloc_hugetlb_folio()
currently propagates this error. This results in the page fault handler
returning VM_FAULT_OOM.

Because HugeTLB allocations are high-order and use __GFP_RETRY_MAYFAIL,
they bypass the OOM killer. Returning VM_FAULT_OOM to the #PF handler
without triggering the OOM killer (or having it make progress) leads to
an infinite loop of retrying the fault.

Avoid this loop by returning -ENOSPC when charging fails, which maps to
VM_FAULT_SIGBUS, terminating the process cleanly.

Make mem_cgroup_charge_hugetlb() fault handling use a common error handling
path, the same handling used for hugetlb_cgroup_uncharge_cgroup{,_rsvd}(),
which also don't trigger the OOM killer and hence opt to terminate the
process with a SIGBUS.

Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 46e8dfffcfa5d..e42049e2c038b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2997,7 +2997,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	if (ret == -ENOMEM) {
 		folio_put(folio);
-		return ERR_PTR(-ENOMEM);
+		goto err;
 	}
 
 	return folio;
@@ -3020,6 +3020,17 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);
+err:
+	/*
+	 * Return -ENOSPC when this function fails to allocate or
+	 * charge a huge page. If a standard (PAGE_SIZE) page
+	 * allocation fails, the OOM killer is given a chance to run,
+	 * which may resolve the failure on retry. However, for
+	 * HugeTLB allocations, the OOM killer is not triggered.
+	 * Returning -ENOMEM (or anything resulting in VM_FAULT_OOM)
+	 * would leak to the #PF handler, causing it to loop
+	 * indefinitely retrying the fault.
+	 */
 	return ERR_PTR(-ENOSPC);
 }
 

-- 
2.55.0.795.g602f6c329a-goog



