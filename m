Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 962C1606A33E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Up6ewayx
Received: by kanga.kvack.org (Postfix)
	id B40506B0AEF; Wed, 25 Nov 2026 17:27:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF0E86B0AF1; Wed, 25 Nov 2026 17:27:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0786B0AF2; Wed, 25 Nov 2026 17:27:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 723B76B0AEF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:27:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 09DC54015E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:27:32 +0000 (UTC)
X-FDA: 85475079144.01.BC144CB
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by imf16.hostedemail.com (Postfix) with ESMTP id 61379180006
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:27:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Up6ewayx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 30GAHawUKCA8t0zx2v33v0t.r310x29C-11zAprz.36v@flex--elkin.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=30GAHawUKCA8t0zx2v33v0t.r310x29C-11zAprz.36v@flex--elkin.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795645650;
	b=iVUmOvuf5RG7eBvHLOVT/vZykeONsSGlOhRrL988e7U6cAH2ZjZ7ZiHwdCkEezjBryxfGb
	hrP2x0rEZOVTBbzQNcg99Coh/gZW1FXM7+/UXCvfbjBi4kTjGJk1dLA3H4wVqn0HpzIoyl
	aDRsQRB5WCMBUt23F+NZB92dRy9X/iI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795645650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RiNM9OF5vBLtGgFl62pfxBUQi+W1VLFdVJFedeCHig4=;
	b=Z1VANd64zdJ2akUpZS46OaD6KcmjtOsZeQXvFPEEdvtverPOvXepK9NCaHYdlz5rSbACbw
	XXlewq7J1QNtFcUUmO79m3oUEB0YeVj/Wg7VomFKs15QI18hdG/eB3UQCZ/xDVBjFVz7hn
	ObBUmrOuKLMy80hIOoIlEc8RtANAspg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Up6ewayx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 30GAHawUKCA8t0zx2v33v0t.r310x29C-11zAprz.36v@flex--elkin.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=30GAHawUKCA8t0zx2v33v0t.r310x29C-11zAprz.36v@flex--elkin.bounces.google.com
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3869865a304so490592eec.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795645649; x=1796250449; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RiNM9OF5vBLtGgFl62pfxBUQi+W1VLFdVJFedeCHig4=;
        b=Up6ewayxFMvd3wCDxj9B/zN2OTJaYp3OFvqmhZsHsUt5a3TzcvCewbota10bzdMMN/
         MQXqgFA1bQiKuJPx7Rntpo9SQxEY+njn/rVHMH3SOIf1SCHOEvSRC3jqIs+/ZmPVM2mj
         8GU5qScxVsCdfqDzksElkG4N3jGzNo+beCYK+Wa6Hyn6oeaybLmYyCZDWLIqtafOnVMX
         Js4DJ9MywXMhuMkoP3MIy7aXXraClKKJ4DWlmhh/DbHjx6kTSplNvSObRKRtECW4y/UH
         T7F3tvYCGiPMGm2tGzY0N4Xo7T4/VC81bxFxpQSS0KoziE0R2EdJt53v1zFVXynAmC3q
         uDpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795645649; x=1796250449;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RiNM9OF5vBLtGgFl62pfxBUQi+W1VLFdVJFedeCHig4=;
        b=XNoAn1+kOJIXSMUfq0WgxDW/7Y41rJqT+YAyNC8UxtWFlfgbLV1yytqMnEg/6d1dSy
         yd370/bTGD7uloUyWbLPMe3pnbeP7xolLOAoxopKJUuhx1p2fj34wH3X0imBUpOgQwfd
         cXjfFA6MxrPZECPJzWk4ak01gaigjl+FKgSAFySEhhWZFQCb1ofsEdaeL+zQ5SkV7dGq
         pJRrzY88m4+PRpBfHZbO4uTllCY1xz1Piph1wMmW9Qq+Rx8LQS+eUWXHWIFGb62jf/uC
         y9cWyySZE1LuEsDCu+pL89nkoM4vmCUNbb3sM92JYjHEeM0G1daz/HkzayQuejqq3IPg
         n4QQ==
X-Forwarded-Encrypted: i=1; AL+hErEAo6bQfnxzYKPsc6nfRsaV34xIhojKDe9VteIPMgotPyO6drNDETLyXTPsD6DNWA6CL4DjtQ5D4A==@kvack.org
X-Gm-Message-State: APuU4Z+JmRPB9JBndufDPej/4UP1+ZfmtkLNG7dDZMZjZW64bI0o3WMX
	OKCv7/ljuCt8aoZ0QJEQd36t3m0LuMCHgVDfKMWsKVLWXWWvBHXVj+ZaVicHWfCXOeg7fzV4EQB
	X5Q==
X-Received: from dyp12.prod.google.com ([2002:a05:693c:65cc:b0:381:fb4c:34e1])
 (user=elkin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:4710:b0:378:314:4042
 with SMTP id 5a478bee46e88-385702587c5mr17876713eec.14.1795645648594; Wed, 25
 Nov 2026 14:27:28 -0800 (PST)
Date: Wed, 25 Nov 2026 22:27:13 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261125222713.1450385-1-elkin@google.com>
Subject: [PATCH] mm/migrate_device: use locked folio in migrate_device_{range,pfns}()
From: Elkin Cruz <elkin@google.com>
To: David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, irogers@google.com, 
	Elkin Cruz <elkin@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 61379180006
X-Stat-Signature: iii99pj1zko3nacb77bifofenfmpdtgd
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795645650-726263
X-HE-Meta: U2FsdGVkX1/cX0qKpn7U1Fb/9tfmXJO8pA1kFV6yFmEV80LA/8RuzxHEdj7C3c43hLmj3ypWZq6cI3tdzXtqYym8DseN39dZjI2ImixCv2O9oCmFohaX613UoyYbIVKBVY4GeHlAkzQ+OTNS7CsGiBb/TEZJQ3H6iBwaQTgLV3DvZujvWrVhC50d0Ep03Uw89398JqvEluwhDoQ0qAoCet9nLbqOO/xsD9PCADYifhqJ8XCdA2tgIGM5DW73Q4Ujrgw8oWSsujDEBecAKhQOtZ9RKm9RWKGoiFDs0WqzbMLEaG6Hk86y4hBz8JQb8w8DLA/zcRMgRRZmKjcIqeMcjRlKYIGX828a+Fk4r3IGPAbrR8UOVVSxBR1OrQRw8hDSmu1NUnm+hr32mIQlL4B3ecNAEDN7XF7eIw7F+CkH2dj4gUImBI9mf8C0fG/3H+9XjrqMQiyo5Ia8F3cov4fZN9u5iPKfHQJI9RY4mqfg9y6nwtazWcjhpxHMcr5gmokdo9b6ytfa2+JNWnYHWtEt3sKMVFZ0/Zyb0T16Wtc/BsAOhf/VF6x5XAjYIjlkdnaIpiJ9RU48/GATrgp9SudOH9UAtqto/2PSC2IbNNK7mCF6gpAtdrBuA8Oz/6h0r5Ilhu7VznoWgNforxG4r/GPnjZf4Fh3IUY7eAo0W2/coyGMEJT3wCqIGLhSym6kvbpaGGxTiwDRdILCLG7satFYlEm0JDLjuwvzsf73kKGBJPrvhelJkrVoPDpejSk/ovwuJp6ka/DUz2WyZgdT01imF4rKpWj8mNZAcG4oLemt3PvUbHSP9Qkq9nhkkGgSS1bVfogwbn124YNyohiDrS1jf/jPq2WuyBgHCDPzu7U5cruNPFDXnctachyK6wx19KC2yYmlMsZXltF7uX7y+MLfwepE3dbjLKTbmsaV5b2QNsBGoI0mcqPynOtEQmQ2NGFNNTDB77gYgGKyBGuJ7fq
 d6rTCarN
 NKqlQErpD8P4tmd74uaoUyj5UA5gT9ENA/J0FX6yiOZZLb9aViBPHVamd2VZkUD12hO8kDWdEkRwIiR8lzrL56O8J1gPbM/rTv08QFICokPd33ktflu/JvbKSi2NgeTf9DVWUgvfnpWW3+/MZRxRfzaNBm5zDFhJ+Th3eTHelbb4jKXVqxfZ2OcBDzNUszM5NWYECFBLQbCIfWnO35Kb5lIOLPcyTOKESvrOGDKK06KMFqcgtpVHHvdE5dmeYu3DRpXyW9gqLMZhU3yQiibnldzod/7kXoUwOJ029mVHG08wFuAyXgjZxKb7SzdT1hQKFs5Wgl6ETv9Ffg/zz7/iAXkUNXLLuNwoKkGNL2L+RhcJZwMx9rWn7kwqUj50PVoT6UqCxF5Dt63E+0E9aOx8Wnd9xNUWfwtpHPuATPo3j3rFVfWNsc81XMuzA9wNVc2SfmhKPRFM6qa9JcpRfMr37pLXK4Vm4zYQ6lw4tsFh6ECU8NGMRV172iL5/o2uZx2MQ/QAI8GvlCfPhmzlXEgH217vfAOwt2ZWDAyOfZ5SaMMoiAO223dlHUbH7B4Fh5bJljxfAWbPFaZu1icl9bnCAuTj8Ky/050fb81QwXcBczglhgeCYB1PTLvLgTEcN6iAwa+tpcoFtGq0eWO6MuEvvczM/SLl9Ajtily6MvU0jGrMtHUxWf+m5jsLSGbiIr/VcRgpVMckahKedaaeC6l5sTTz1Q3RDkqLGbTXq5gkwtS6PiPYYKi/T9gY4NXrkpFtC6dfrMJ+6ybtWGPdbSWjeT79Jf/HMrGoVswCK7Bq+RQkLoOYi9dXd0baijEmRwtbH4as7Z6O2Wup+ZztldKNcYoX7TBG6iP9PlCBx/i5MMjq68OKHocr1kPql1OloA4pRWBX4OKaJHUDrJRudOqzTQ5l3EA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

migrate_device_range() and migrate_device_pfns() read a speculative
folio pointer via page_folio() prior to taking a reference or lock in
migrate_device_pfn_lock(). If the page splits or changes compound state
before lock acquisition, folio_nr_pages(folio) inspects stale state and
the nr > npages - i error path calls unpin_anon_rmap(), folio_unlock(),
and folio_put() on the unowned speculative pointer while leaking the
reference and lock on the folio actually locked by
migrate_device_pfn_lock().

Return the referenced, locked folio directly from
migrate_device_pfn_lock() and skip unlocked entries cleanly.

Fixes: dc41e961a269 ("mm/migrate_device: avoid out-of-bounds writes for compound folios")
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: stable@vger.kernel.org
Signed-off-by: Elkin Cruz <elkin@google.com>
---

I am trying out new Clang static analysis checks for kernel bug
classes, and they flagged this code as possibly buggy. The findings
were triaged/fixed and commit descriptions were drafted with help of AI,
then checked against linux-next (not runtime-tested on hardware).

Thanks,
Elkin

 mm/migrate_device.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index a953e7acbea6..a599d5baa340 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1416,11 +1416,13 @@ void migrate_vma_finalize(struct migrate_vma *migrate)
 }
 EXPORT_SYMBOL(migrate_vma_finalize);
 
-static unsigned long migrate_device_pfn_lock(unsigned long pfn)
+static unsigned long migrate_device_pfn_lock(unsigned long pfn,
+					     struct folio **foliop)
 {
 	unsigned long src_pfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
 	struct folio *folio;
 
+	*foliop = NULL;
 	folio = folio_get_nontail_page(pfn_to_page(pfn));
 	if (!folio)
 		return 0;
@@ -1436,6 +1438,7 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
 		return 0;
 	}
 
+	*foliop = folio;
 	return src_pfn;
 }
 
@@ -1464,18 +1467,18 @@ int migrate_device_range(unsigned long *src_pfns, unsigned long start,
 	unsigned long i, j, pfn;
 
 	for (pfn = start, i = 0; i < npages; pfn++, i++) {
-		struct page *page = pfn_to_page(pfn);
-		struct folio *folio = page_folio(page);
-		unsigned int nr = 1;
+		struct folio *folio;
+		unsigned int nr;
+
+		src_pfns[i] = migrate_device_pfn_lock(pfn, &folio);
+		if (!folio)
+			continue;
 
-		src_pfns[i] = migrate_device_pfn_lock(pfn);
 		nr = folio_nr_pages(folio);
 		if (nr > npages - i) {
-			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
-				unpin_anon_rmap(folio, src_pfns[i]);
-				folio_unlock(folio);
-				folio_put(folio);
-			}
+			unpin_anon_rmap(folio, src_pfns[i]);
+			folio_unlock(folio);
+			folio_put(folio);
 			memset(&src_pfns[i], 0,
 			       (npages - i) * sizeof(*src_pfns));
 			break;
@@ -1508,18 +1511,18 @@ int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
 	unsigned long i, j;
 
 	for (i = 0; i < npages; i++) {
-		struct page *page = pfn_to_page(src_pfns[i]);
-		struct folio *folio = page_folio(page);
-		unsigned int nr = 1;
+		struct folio *folio;
+		unsigned int nr;
+
+		src_pfns[i] = migrate_device_pfn_lock(src_pfns[i], &folio);
+		if (!folio)
+			continue;
 
-		src_pfns[i] = migrate_device_pfn_lock(src_pfns[i]);
 		nr = folio_nr_pages(folio);
 		if (nr > npages - i) {
-			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
-				unpin_anon_rmap(folio, src_pfns[i]);
-				folio_unlock(folio);
-				folio_put(folio);
-			}
+			unpin_anon_rmap(folio, src_pfns[i]);
+			folio_unlock(folio);
+			folio_put(folio);
 			memset(&src_pfns[i], 0,
 			       (npages - i) * sizeof(*src_pfns));
 			break;
-- 
2.56.1.839.g22a8290db9-goog


