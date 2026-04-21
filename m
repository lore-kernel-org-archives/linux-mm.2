Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1416F94CB4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 23:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6086C6B008C; Tue, 21 Apr 2026 19:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6EF6B0093; Tue, 21 Apr 2026 19:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB7D6B008C; Tue, 21 Apr 2026 19:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23BFC6B0092
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:02:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D95B9BE3A8
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:02:52 +0000 (UTC)
X-FDA: 84684089784.29.CE86F06
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id DBDDA80019
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:02:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X7eANiGU;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine);
	spf=pass (imf30.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776812570; a=rsa-sha256;
	cv=none;
	b=qSdtJbcZyAP7StO2yImYgZ60fCP5xeDNto+XlZ3pqw+sA9llifB7vAD7KODF1rHOj+9n9l
	2L0QZ5Fp8T510KA4PHE7nM3ouEqaOD3mOkIt0Kf+6HgXQVQixP3X/PvnGyiIMINoJBWQUx
	kH4+ucRUkBJLLEDjHtRFcaKDcNPOrKU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X7eANiGU;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine);
	spf=pass (imf30.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776812570;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDzLT8xllq1iBGA+qtx0OEDuRYSfNoyHs8R3lM9bdik=;
	b=o509SwJuFil299Ljvkb92V21qCmDDHYjsWc/ptn72uGGUID5wZyPyeoEAc6hvVLYv8TzzX
	pRxw49fIgzYa3ndUOfF4ebdNpY9yUwqL7tMzedz3/E0YbfajuxcXzvKM7+Hb/uWIIHQBOZ
	VePkX0pGCAHLpx/SOvwyTR98N+3gTSY=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-12c8cc7a77eso1820713c88.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776812570; x=1777417370; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VDzLT8xllq1iBGA+qtx0OEDuRYSfNoyHs8R3lM9bdik=;
        b=X7eANiGULWy7svYD+0cCu/y6wffuYKt0272g1gGJ2ijqaR3pwO008js3SBGPm3cTwy
         R28riP5zORHW2oEiwXj325jdKelAt74QwqRPclGoKZsHC2y29UHdvNYdXr1zMTTHqGqG
         II3REvRsAtnhm+m+8Lf85mmzkc2UjXR6mm4FlXdu8aCrQWWJak11WcvW9qwV8xQ7JB5s
         FCMBDd3MgMsvXg9sFfRA4Zum33GO1mrhngYSMksZTp2F9hv6YDuaC/HCoGGY2RxmCos8
         JEtvr3axq5MnbvTK3lbU9NaJb2FSA8Pz+U8fPRmZLZtY5+zgMtwwJBcpQvKs/sarfCmr
         M8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776812570; x=1777417370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VDzLT8xllq1iBGA+qtx0OEDuRYSfNoyHs8R3lM9bdik=;
        b=beRz5xpN1rCk1C/CqRuJfqaZ3cccBuhcPQRQ8Bj1m1Umcf8Ayenu+8XofGi93g+h0i
         ohyWiC57Qv2+cUZ2HLizDIHhFJEd+tdtC8x6Wv1oBPgftrIfDkfBcv/60F3ZoFJtcOm0
         8bDPQ4luq+RalUmUMJPynSRTJTA7ttZgs9QRBwqdhg2kbQYdKJa2SU2ZGITtrnVb9rFk
         1CbX46gptE6Otlo2YMMHVex0pmJ26unlfrrwp5GbEPHDP2Kd0zr5JttVvsk2yw2hqMYa
         HnOlOFjFTBs0S8b2ye0t4W9yL7lA+KMSyPNErAHqq8nsVfy1T5GyNEknDyWdTjOfXtCi
         ILiQ==
X-Forwarded-Encrypted: i=1; AFNElJ/K+RbPNVwkWiBcJIeC06rfxgWUV6ti97oyMjhdJ14rG/NpOwwDPPInlNgAtp7EUIQgGp7ri/U47g==@kvack.org
X-Gm-Message-State: AOJu0Yzs7FvpBb9JtS/BAQdGXaWvf3BL6URyO+V2b2K3If7VzQH54Pgj
	G1AfiUJTfot/WMUfooPMSiA29wN2Zhvzl+wXG22MWVxE/MD4ZAI+XNEW
X-Gm-Gg: AeBDievODkoHonu0RYmMPz3MY9xLbjDV8o9qPrLtkBJ/xqQnx0Hj4ZJ58yk1dy3lkKO
	QGz8R5l+XiuCILmckTGAeQ/3prmxx5aHmifJys/iXOzrulEI1Nu68ndHSo8lmXokJ7jEhJnKMkx
	RZHP3HPvy1qSm8bJvnlJvat0G3hEfKOL3onKnA2nY4poQTEStuDiQ5i7dgvWacDCDX2Gbph+F1O
	ejTrIC1E8JbqpjVQWKlDUYyH9MTekHS8FIzWUwuNwN4wcgcJ9YBumme0V6jo5Yx1+XLYgQfAHrO
	3zYgc3ZatSACdydMwf09F6O4UJBgL2B/KQuIxdwKa9ZP9SsSzWBHZQc4bZC6BY42zjDxXIYGfUd
	m29MdXrHkL3cuoP8FqDnS6gRFytDCu2vnSDe6+68lfO6IZCw0U5ZnYSmLrlkRx+YXos6lIO8tO2
	5dgHWnYGOZucYlcphd5YGSIpzt3tASw+Z2diNsUL7msKnqU3N+buLljZZ2bMy2ctuxjqzRmeRFh
	m/4L5Q4f416Tg==
X-Received: by 2002:a05:7022:e985:b0:12d:b2ca:a9e9 with SMTP id a92af1059eb24-12db2caab80mr2271908c88.8.1776812569428;
        Tue, 21 Apr 2026 16:02:49 -0700 (PDT)
Received: from bbox-1.mtv.corp.google.com ([2a00:79e0:2e7c:8:4678:d28b:b946:bcc])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c74a20eb5sm26453546c88.14.2026.04.21.16.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 16:02:48 -0700 (PDT)
From: Minchan Kim <minchan@kernel.org>
To: akpm@linux-foundation.org
Cc: hca@linux.ibm.com,
	linux-s390@vger.kernel.org,
	david@kernel.org,
	mhocko@suse.com,
	brauner@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	timmurray@google.com,
	Minchan Kim <minchan@google.com>,
	Minchan Kim <minchan@kernel.org>
Subject: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for exclusive file folios
Date: Tue, 21 Apr 2026 16:02:38 -0700
Message-ID: <20260421230239.172582-3-minchan@kernel.org>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
In-Reply-To: <20260421230239.172582-1-minchan@kernel.org>
References: <20260421230239.172582-1-minchan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DBDDA80019
X-Rspamd-Server: rspam12
X-Stat-Signature: ek7qsp4a6uj5c7pzhirmk79wc1y19qjz
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam: Yes
X-HE-Tag: 1776812570-313315
X-HE-Meta: U2FsdGVkX1/iyaaLrldKFnm3mLnoqGTZyCwz1HKg/7GcMVU+VA7s/xIMjgTRfkPzb1L7nnnwc62wSb7u+pdHLsCjSCCddccLY2h57kZc4gpcAlKi8HlbL/wLdWzMPMcrJxB5bWSdrzaOAlyfr6wYXr3+KqgzatBX1h4cpYoNOOSEUOrW8p6TzQf6SVH4k9c+GRgtZxt71NCh7+X5aMZhjSR8F8+n5YuecMP6s2tk4DNBLTIkRk8eJ/afvd/5BMlpxTm/O2OuYrCJQ/TpcP2p/2N2k9VK61IZIyZEiTuXdymiyoE+cJAkWn3RvF3jo4SRvgYiyX7b/MIeOlMFU4xW5lh2ENMytOijqiwwuvbIVNPI7Wa03AnfzL8QbijpuGh2aNWQ7HoFDovCg/z9cAc77SZ40NTeG+3hdJTlgjlgWCrmzeimbeEuvOjTngy0kk7MgnUAgN9UQCE/7cfOhx66y+QAttTFBCsVf/2c/6BIik+rl0AaM9ouC5vaBkgEMgzylAaxm9N+V3xRrPwMqDJtsREJhQfEW/NBYjY1jI6V6GXZF+r6mE1wSxwjsEaQGlwBAHFhQHas6OzeKT/20aNkaoqmn85KHWibf+g0Lr0eXptA47ihRSIeI2f2RZrT+Cvlk/zzMefvVB8ZaTSkVumJzQHfU1mRKEGXaz1GdW5A1hhUeMiu7EZz8RKOSGrkhx/wq0jLiOUlv6Q4H7axduuJKneqATdni83cSTf7ZoNx0xfoAqznBLl7z12brnrJrK2XgSRC5opWPkRp3w61PSheju5kKuJEYKaqD+Ne1agHkJhhK5nMC73hYOg+dEsE6pBocsa5r4pg+W7qxGPvCjR9CsGj9Lu1R46udpZyQoFscswO/YQkEqPC0IB9++EM2F+Ih8IvdWVEJWwaxRk2RvtZHEqr0w+FWS6GL4bT3G/wXDApiw9sUSXdxPlsRmlRdaDFBY5nvrxWC9oupBjhXBf
 2tV4S88Y
 X1aynzA6+OYjACmiGeHTfHkKoCkMTg0jX53ubNTPY0fPBRqFi7E8tEZqr6WMDcmwOSXR6FP2vGFSTG6pH4LgKMWbGpcZvnAZNgNbou/01a+p/ml0MtyJ4idPEZ6MQLRygoP6e8fCJJV3VPoMKa3A88yo8iO11k1/jOHz0yD2/LBAbV5McMCAPqT7wijdd9wRtbD5QQuTkuCa+aUzHu9W2JdY1FcIF0S0K1BE67TeQoJUJJ9IgfLS1HGE70OO+WjUSxpt73QFY6SXMMsQ4nv9vWELOYrz9jGWzGT+H2FSgjBpPFzQFXMSQDOneGJXyUQ7ehwoTUoDJzb9FK+hGEf285kNLkjRb2O+jfN/XeggLifQ6YjBy6AH+7NzldelqrpLnp31JnkR/k8D6nLwlzgffjjX/NEGHmuz9dvBSIxgXbNIyKkwCkTCSiglbfMKr6gL5CNWFV2juXdzaSv+i9Qiq3OW6GTltGVV8yOWnnkl31+y+2hLBp3IFMHTT8cxc7W8hDXNNgjvKBT3crFBulYwyVCxh6vKmynWTWVW3hoYWIgbItSPqHZCMFL7VbqXhnG9hhIESj+YR6vGYttaUV0GwbqZg30hx2hT6CRf0OvYAtllwTJzy0l/rCzq/RZbCthVfPTBW0QtkziC8QIgShNnJx5bBEkgkjgQHEjYtRDE1g1qs4mk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the process_mrelease reclaim, skip LRU handling for exclusive
file-backed folios since they will be freed soon so pointless
to move around in the LRU.

This avoids costly LRU movement which accounts for a significant portion
of the time during unmap_page_range.

-   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
     exit_mm
     __mmput
     exit_mmap
     unmap_vmas
   - unmap_page_range
      - 55.75% folio_mark_accessed
         + 48.79% __folio_batch_add_and_move
           4.23% workingset_activation
      + 12.94% folio_remove_rmap_ptes
      + 9.86% page_table_check_clear
      + 3.34% tlb_flush_mmu
        1.06% __page_table_check_pte_clear

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/memory.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 2f815a34d924..fcb57630bb8d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1640,6 +1640,8 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
 	bool delay_rmap = false;
 
 	if (!folio_test_anon(folio)) {
+		bool skip_mark_accessed;
+
 		ptent = get_and_clear_full_ptes(mm, addr, pte, nr, tlb->fullmm);
 		if (pte_dirty(ptent)) {
 			folio_mark_dirty(folio);
@@ -1648,7 +1650,16 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
 				*force_flush = true;
 			}
 		}
-		if (pte_young(ptent) && likely(vma_has_recency(vma)))
+
+		/*
+		 * For the process_mrelease reclaim, skip LRU handling for exclusive
+		 * file-backed folios since they will be freed soon so pointless
+		 * to move around in the LRU.
+		 */
+		skip_mark_accessed = mm_flags_test(MMF_UNSTABLE, mm) &&
+				     !folio_maybe_mapped_shared(folio);
+		if (likely(!skip_mark_accessed) && pte_young(ptent) &&
+		    likely(vma_has_recency(vma)))
 			folio_mark_accessed(folio);
 		rss[mm_counter(folio)] -= nr;
 	} else {
-- 
2.54.0.rc1.555.g9c883467ad-goog


