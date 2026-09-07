Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F14AC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7476B008C; Mon,  7 Sep 2026 14:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275ED6B0092; Mon,  7 Sep 2026 14:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166386B0093; Mon,  7 Sep 2026 14:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E12A66B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C8F91401EC
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:18 +0000 (UTC)
X-FDA: 85187760756.12.9FCC8A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 60DF71C0008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mudKBYil;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804736;
	b=cQSV72/Q54tY5GQ+8vs8WfcMzcSmlim1KVon7OTbZSevMHxKnjKFsHz6jOSIkauh5EedJs
	HR02wEJcBaI6XCPALcpq2vNT4vwUntC2xObBT+FpJWWNF9iO6ZGBdUeNYNN/i78qxxsju3
	A/hSisPh5C7aFxSQ2oSA7dv0Zj7HcmU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mudKBYil;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804736;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lttfYxNIufkN99/XgEMkS0PwMhTJJSAs9NkHk52ECNM=;
	b=IG0uo0KC8cxVZbuAvD1oV1ryq8upkXd9QTK61TatU60/A1cmirgeRYk9NM5D9uxtvzUmUZ
	dJGQw2XIOkswMo2OdF7Fl6BeDuZQIvYeobtUTQkjsYl63Zx60hcpaBs6liSMR4ZAZWk6+z
	NJG0dvaMT2mOyoGghtxKwweOVkoy/lg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A4A744006;
	Mon,  7 Sep 2026 18:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65378C2BD01;
	Mon,  7 Sep 2026 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804735;
	bh=WHjZ3MtkzfeirCgRiKk2+BAR2kgb6CdSW7hILNlYFUk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mudKBYilZletaWrVKoQQInwp3bT2uXJKxuncY/eT5dmk22y0hJBpViIGoBhueINsF
	 rB0GBgdFFPzB+fNG99onFvQM501aHSWtPfU9ExKApir680ztzaHmT8xKaf2oc4PEdQ
	 Koi8PwKOc/CeFLj1Clb351r+LX2dJRFdnjbbT7HNHCC8ZvYQ4gQMCrN5Mwdj7Q7tOW
	 zuTqnkEOSDPKDadt2gVCIpBEpII47drKAkgm/dCmotMWq9dyL21eJ2oiiY2h7egsTI
	 ypQMK9YNPcJZ0qfNKV/ejaFXmJmCYu6MwAXjbi28qOBQbkxvFYDWPjF5ETUCH3Kc69
	 I0PEBmpGy5Low==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C7BC79F99;
	Mon,  7 Sep 2026 18:12:15 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:05 +0800
Subject: [PATCH v4 01/17] mm/swap: fix off-by-one in swap cache replace
 sanity check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-1-b532a3f20e71@tencent.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=1650;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=XESq4kPupCnQj7r95GN7GoyviZFWLnOgj/AyzSIJFVc=;
 b=jCvUgn3rqoALZFvFG741d+xlfd7OfXxx2iN9tamlvi9M5ApOra3C9c7uG/LVbC8Ashsz4inbx
 PflnFhzqkucB/1VIZSkU7zQDUvf4EHyKiTVtmWkERcsqB9nwr2zsviO
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: rpa5kckpu83mffkyayqczp5u57eqnrdc
X-Rspamd-Queue-Id: 60DF71C0008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788804736-525831
X-HE-Meta: U2FsdGVkX18KQtq6hRdw/sk076E8oNu22uVNYqz75VnbugY5qPUslhhjfwocYrtL0CUgxQ8IHK4mkhjVbkiOgQLed24fwU0GKNX0W8N2eTecCEHil6sfshjttylW5IaHTeFjPX9vZAVL4PkfsUy1dyy8nz8MhZqHaOleQHr9JLKN80+lDIRU6VvK+KVypf6oLw9nhmXByYZGO1I9dxCOc6IrBTCnnAw/Muv4/4ZKegxU6vE0xBTtX/wozpoGS3+9a+fi3O42OS4dnaH19pUgLfLJGOVuxbhSd9KBEgqt1xPbZvaIuTSRXL5B+XWGqFYX98MhrqjNowwJXK2MLuyA4mB6FDTX02zS9xy/m00TsNZ1KCFK7n/ARhT//5u6rvT4k3+Zo/bnNF47CJy1IqW7C2s+n71BREBJw7ZKoNQL3mJlUEqKrPflF2XaemhFOm6EYeVm24ClWbeOu+fZI1wtmDbUKSL4i2cyQKbhDAECBkX27ChL2vUDuOks0WvO1ZCbzPC0PvOh50Dio32lf8TJqGhLKK4buohec6GIbuyGFCbvr6lhnlE9fRfJoFNonRIgs83QqsrB8g4TPufezGX7RCoRjp0/d7eCNRNxIH/aXzXUOhpKhq4nkL/CUHCcZgZEVo98194iWqpJnXAXafvdVp4PtQkRRDZHKwt41zboZJbf8h6udAPTCBHXRc2LctarIb5XNbz8S1Y6vAvsxdhTnfTAkcIx6QC8Tz88BMHmOH/OJYsK5DISy/89ULg1aBdPfJbmOTITiGLz8B5f7VNJN9bRD20xfgt1xfzuyWlQcdqnAKggWQU3e1E/xstTUunwqWJXJ/IlOynuPH2FGoYf0TyOEmE2LJ4R4vyK4jq4E5sA8BJQSD/tsWQPy8dVJvWeTe0+Nv/vULNK4iiD5bH2IwsnLhLyKAekvdJwweKH+vpbjygvy0QrYqLYaZqGcRaZGTdBFEdVaapwbRPTSBt
 QV0utn9+
 PzBitgdAKfij+VV/Rw3IuoXv2DwVwp+nmfdtgFCsz8oihr7WoAdoMROVDz09ilNCACJ/oC8iLtwyIpt8P17puni3JabKq8xE8xwD9JCiunRr9/dLkq0YArNsqNQHICuj+Z4P0YQXni7GKH3nyetr84IsGCA2ndwRCGJ3+EyaKxFV0HrUR7+dCKsxLuLpbbEm+e7StCIB+enZSdr3ClQOCbg5O/W+VF6tCxTKH57g8LMZ835zc6StRCYs/PGjhtfUKdTecM2VkUBgyKm6KYMvKCAPBukACdWtrcjl9eqVqnURR5W91MJCB8yCD0cS+paFtGJOQJnDltQYPqnalqfUKUMundRB0sin1TvG5+Gf5965/1u3Ws5pCTJRDxA89FyYfePze7ipMODdz3vuJzsJQvTlZHXWJhUdRXb7BcnKyViNg7IWxdE23AsGsAhDQlTtui5LZDvO9W0R6o0WQotqm2q5gTYEvkAiAKuO+eGSCwbsKenvMhxhwY+RpHPmrZmnp95Ko
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The DEBUG_VM sanity check in __swap_cache_replace_folio() iterates
the old folio's range with "while (ci_off++ < ci_end)", so the loop
body runs on the already-incremented offset: the first entry is
skipped and one entry past the range is read.  For a folio split
that entry belongs to the first after-split folio and was just
repointed by the replacement loop above, so the check would warn
spuriously whenever sub-folio orders differ from the head folio's.

Currently we don't support non-uniform swapcache split, but this still
needs a fix to clean it up and prepare for non-uniform swap cache split.

Use the same do-while pattern as the replacement loop.

Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 305877e1f4d7..2cf7ed2a4df4 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -389,8 +389,9 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 	    folio_order(old) != folio_order(new)) {
 		ci_off = swp_cluster_offset(old->swap);
 		ci_end = ci_off + folio_nr_pages(old);
-		while (ci_off++ < ci_end)
+		do {
 			WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)) != old);
+		} while (++ci_off < ci_end);
 	}
 }
 

-- 
2.55.0



