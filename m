Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FCE1C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF586B00A2; Tue,  7 Jul 2026 16:46:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58CB6B00A5; Tue,  7 Jul 2026 16:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B965D6B00AA; Tue,  7 Jul 2026 16:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 884936B00A5
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:46:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E0F61C822F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:46:20 +0000 (UTC)
X-FDA: 84963163320.12.2A7D079
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1762F18000F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qo6OO7Wt;
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783457178;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2Jg5wKi8Dk1WKTQvVrSa8jOEzdBY7gHE/Q2uNFcyck=;
	b=J9vn2uRu6GJE66DwEa2cQB0S62L1lSbfhoJnyvUql5yf7Z4SKF85gDGw/IHAementVkiBj
	ClrHX8IyogM3Hyg8a19AGhd00Tz7xy3+1a1KOVaRzJo9rbNlAElihb2EkIi2mxg7sODFky
	DWxhFpPzEI5ijyKOdiZrgYjbK/Di84A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783457178;
	b=rXUUZv62wE/xbgzv8Os+oGamf25+kTw7CxGbgQC1uSqANYecb/t8Bvpa+GPB/90BxRgv4o
	atl1872HI1mKv22HqLIxUHAisiyDfT0CEO0M7a+93y7Yr5NSILZwVYCXWYR19CJg4107OV
	YvA9AHZMRObAhCHuptgX1oJWySemxDo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qo6OO7Wt;
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F4C06136B;
	Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33DA5C2BCB9;
	Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783457177;
	bh=QOjnxAE+GAvwVsekkkA6CouZPQD2lkrzTyRQz+n8Dx0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Qo6OO7WtnPpgJX4U4mLdz1WCADEMqSyz9q4d1reu0HNJyoy46IEA8jIvjpkIbsZHf
	 bPOms5ORSU2qhPG8oCdI0LPcYlxrxKDDYFf91Os+EdrmwaKfO/sRI4d1S0eHf4sdYC
	 y9YfWpML23Ga3Fx9nskRH0GkXG/LidXJlqzQSihfPTcvrgVDRxMfUL7MENB9WEfXe3
	 sDWuj9qrfaOttRnhJeTnISG2e5yZCYJElolWMdN+TEHW0wAIuLW5syL2WVZsNsuwyb
	 Vf1+vXHqDulfU/i3Y3KyhLcOPWGsrtrlEG2Qd4d6QhtcVr4HO+8sM1U9/dhApAAUkB
	 hCKsNzNdpJJbg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F54C44503;
	Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 07 Jul 2026 13:46:09 -0700
Subject: [PATCH 2/4] mm: hugetlb: Fix folio refcount mismatch on memcg
 charge failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260707-hugetlb-alloc-failure-fixes-v1-2-5bbd3a4b836d@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783457176; l=1164;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Gg4M6FjBN0eERxpvlOF/a2TSmnqG64aUlMaqc3eGXmA=;
 b=mo8MGzg/gQfk0ae6VmaZKFXCoTWsQlyJ407ghMLd1hjVJcChz9T0tEkovJr6ocDcX3FYL4QuD
 Diqtdz/ne/bDRQiTioQvs1vad6FaVeIBuoIscs5e/Aba1WDKN5pwG6U
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1762F18000F
X-Stat-Signature: 5s751xd57x6qmgxfgk3a3e3jkqaq8khk
X-HE-Tag: 1783457177-803603
X-HE-Meta: U2FsdGVkX18qAobSE4GeKxunJq75Yk3s19xitJAq3D8KruF464seVHuUUXdUfz/4T57q8cRHCMvZpDAXFucgbarpK/YdDip1iSpcP/+3dJwC08D2+3P0gsW3nYDqUHU7UeujchuduBxvKedSXOR0nZCLhN8uBTdH4VBrgg4OV4p1/md2mUYKjHiCUkvGWxgTW6LoLQsPHcB+nK8EGKhYjXBqmk+TECDhatjihqVgfSn5/aVM4O9DTXYaq4P5fiiF6W7FJqU2iXsGtdooFM70l56M3laMKOPFqXPOJPikimgWN8DvDaPXtSXGO805c/XjZ08FV845FtI3XZ+LoOSK5xOqk9is8jj+yPuD1mrolnFSnuyIj9CvTdAEg7z0UjbXx9esRLREq/I2filJSY1hSnfyos5wFFkbITJbruIyH/EsRJ0cF2s5Arq7DCycbB9dwlDOdfxhy7s/wzD6I94wlOAkCrkAWOisuSpbXRILq4fEAIpabEbIRoh4MxCAmTwrLkZdfmrJdbpv+iCdyoKF8RkZjeRFaHrmscDZiMV3F0FDpQJ4Pvv+hbQmpnu0mqbWeIBzAw8zee3DnlJpCoCYl/hzDjbAz5ey7GUDQ9+F1C6oN4sjjWcXmTm4TdF9ew/iigXJ5gKSwPpHsZfLXM6zSGCzhuaQMc0O1mEf/ZNaux9vn1hoBR0NChqYIdifhr0a1ek6oleU7BKmWL/+gNVO/5tXn8N1tyq4F13fBtIeFR/H3ffVzH3DedfliGCDR5H1QGccd2paIfk8pf0VUHojrM7trnJeRJVupSP3FXRNNberKqvJdgr6SRRfBcGhF5JM51keVoTfVBKz5LhV3GedykR00+tXrcz8fBto6lvCK4yucltotXuZfHs/Kjs4Qag1N/58fnCAUNVS0OxeSzA/8/FKjIwaue4Id7spS555aUIlnElo8vwIxqVIzb23AYR3xfg6yJUPuyRHL4uYNCy
 USSHLkgu
 g17huLaGA6APzDsyp04+lJYBuYB/nWj3X4fQso57zVWlOvB39Megf+vC2H4mCeUOwQbwQq5+VGiLHcEdSgAYCpXIR51KPWFJQe+rbJATAJS1eF6QUNourtxry5qbq2wOOTL4/H+DKSFagwu/RaHQqGGwyaJO7Kzb/DG602Im5EGy/fcVW1G1yyzqpOfvvku64XlTmfnEkH4FQdH3S9iS2IoRAT0Tnr39sfgOaz/vffqE4MtuxEKG3oSqSWS5H5dLN43wf+lTZg36yz/yyGuZjXGuxUET0123yNHcffj82DZ6DlFI9nVYiJqdGQFiEnTb02DJk7WQTUFXOXnHndGFBzZUeQdDkLuI4H2PjI7Y2AIaKLSGfWEWO0xR0NjcIhLs7yBObZrrO0L47kT5vbiyxTYWU0dUC5qS2VvhmUrHgHsT/rUozTSHoB3NDmkykyCTFeMlOkpJ3VvTpxwNYzmXTRrUp97Ez2JFopQcDvUuDxHlhZ0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When mem_cgroup_charge_hugetlb(folio, gfp) returns -ENOMEM, the folio has
its refcount set to 1 via folio_ref_unfreeze(folio, 1).

The error path calls free_huge_folio(folio) directly, which expects a
refcount of 0. Hence, VM_BUG_ON_FOLIO(folio_ref_count(folio), folio) is
triggered.

Even with CONFIG_DEBUG_VM disabled, returning a folio with refcount 1 to
the freelist can corrupt allocator state later.

Use folio_put(folio) instead of free_huge_folio(folio) to properly drop the
reference before freeing it.

Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e607dcbb2fc3e..46e8dfffcfa5d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2996,7 +2996,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
 
 	if (ret == -ENOMEM) {
-		free_huge_folio(folio);
+		folio_put(folio);
 		return ERR_PTR(-ENOMEM);
 	}
 

-- 
2.55.0.795.g602f6c329a-goog



