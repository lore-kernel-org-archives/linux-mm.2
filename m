Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26399CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31C986B009E; Fri,  2 Oct 2026 20:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27EDD6B009F; Fri,  2 Oct 2026 20:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147126B00A0; Fri,  2 Oct 2026 20:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA17F6B009E
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5619D160524
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:39 +0000 (UTC)
X-FDA: 85279411518.11.9244E4E
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9D8961C000A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RNxkNkEb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3kErAagoKCIMq0ov1no0vunvvnsl.jvtspu14-ttr2hjr.vyn@flex--jthoughton.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3kErAagoKCIMq0ov1no0vunvvnsl.jvtspu14-ttr2hjr.vyn@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986897;
	b=DzwDBEi9xcs/Wtm/YKCDplvUJe48c8eOgkUctXHm59uJKJUANTq+3GNm5bHjxkKAlM98dZ
	7Nf8mKkHjNvcrvuyWWVr11gqhnUZpdJaH1yLbYlnj1o2k/Rd0Zy8NetVPI1Z8DkXaAHpsY
	M/6kNZAMwvJkf0jw9plgGfYIgVIvJbo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RNxkNkEb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3kErAagoKCIMq0ov1no0vunvvnsl.jvtspu14-ttr2hjr.vyn@flex--jthoughton.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3kErAagoKCIMq0ov1no0vunvvnsl.jvtspu14-ttr2hjr.vyn@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jojM/RXyQILqjqfcPpQ8uAxcOK5eNU0AKu35ZovnhAc=;
	b=FZUjvSeGyhtZ0VXoE59JnGh67Ca27EAagKRLfQsZmOsmLsUbkhgqPGI6TBS6CuXeN8iing
	TS+CTdbhkfPl44sGsHSZjmOW8oEmB/u3j5k5ZsuhbbH2yBnGmGSBQogaKBlmvi91x9EotZ
	ZaQ93j5DMdxcS8M/3z6O2Tsyr/8CqAI=
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8881a7875e5so85826b3a.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986896; x=1791591696; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jojM/RXyQILqjqfcPpQ8uAxcOK5eNU0AKu35ZovnhAc=;
        b=RNxkNkEbK3HoFlXfDEQFxmg9lzC6S3kJ+WUDWRAejclxsuGGdHfe5BMlolT1PjTwZz
         vdWOMm53mzCuF2BvJYA48luoFWYR8b7nN5f+bUogsQ2sM5dfaBIKzYmYBwJ5PTbO6FCM
         oD50gCjqAc5KNd8Yg2D6nm+dxNVFQi33jUPA9IG0bgxb/bPR9YGdJ6oQi/TKNWu8RMQ5
         dj5DwNyGs5C2mYrT3TZ2rHeZICspW8aKT54C/rTSMeNs+pSAEwWtQarIRFYTSIHk4XY5
         QfKDGeWGWoQ+2Bz6u4XIp6pn+6YexrMHOjGV8N5hBvqnoD/X8B1VPv79PsS49sgU6VGS
         GFcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986896; x=1791591696;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jojM/RXyQILqjqfcPpQ8uAxcOK5eNU0AKu35ZovnhAc=;
        b=fiMach6rBxlzXhGUHiP80tsRR0muLzqaz+YVJ68A7hbiCutVj6IN/CICCn202FBxfM
         iS2m8dFTnfSo3i1lMppQmqZFNKtYWZVfenr2UJ3LdIJpBEUmRoVYAsdg92nAWR7dsvZM
         88KQP/jcBdfqn/RRpNaEha8sC11IG9f3jAkWIajpt1GY7t+r8VvdHBtiBFykD/QxNWkL
         FYvyia4ptP05aalfQ0uhFN3DahGHttU9wV8Flae0bbYxEJyP4TKDBtA23KpzFgNXPAIP
         lqS+NoaHs5AMwwGg2GbcjeIBTsyKFRe2n8hVA8Y+hLHroD2kgB4PxHPTsQ0EQr6Z/gSH
         99NQ==
X-Forwarded-Encrypted: i=1; AKwUvBy+sDgQ9iuSp4WskV5CwXfAtFjtHy4N3wOIg/2UjUElvlMuyCDSYQ0gToHvX8DB4mdw7+BLPUtWww==@kvack.org
X-Gm-Message-State: AFuF++mjBrwAB5XxpCN2cYt2ZTxmCtTSFMgc3JHHSwbDqoyhz33ZinIc
	oio6X6r/UHBJ1QoXwz1IYGnsNS1jcAI4UFuAykS0P9iASJPkVFDgr7Y1N5Y+uYcPRafCj34BVW7
	J2foeAjeM3P4rGOLvKcRi5Q==
X-Received: from pfbdk13.prod.google.com ([2002:a05:6a00:488d:b0:887:522a:478b])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:ac0f:b0:880:57cd:c32b with SMTP id d2e1a72fcca58-88af6659219mr3895203b3a.21.1790986896172;
 Fri, 02 Oct 2026 17:21:36 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:05 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-3-jthoughton@google.com>
Subject: [PATCH v2 02/20] arm64/pgtable: Clear AF with LDCLR on supported systems
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: cjjnozepoyjso15hqtpdrurj73pa7iek
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D8961C000A
X-HE-Tag: 1790986897-549553
X-HE-Meta: U2FsdGVkX19ifaQHo05tnyDIotATSfpHVLPZOYX5OqenjnBiI7Yh9tVSuiBrXplKiJeY05J/nuX80Ob8TnlEfVsQtHP6E/486/JIcM9DBcW3A9UU0sdUcu4FICLwbysAy8RPt54oMyaZnoqO955yVjVBc64R728JCoTi8eXed1a6OlnJgQ5JOXLH6BSriPNoq7f/9bxWPjXpxp5yAF+yFk06NEX3fC41TpsNMeByu7jm9D4oWMuWVZ0OfRXSCKz7tl7+JUifqqjMPozkbujjdITBAkeCDnu7CFJtSMeMauWtG57QsmmsmS4zY/EYq7muHJnos2YjDyKqrwCdfzbN2VDkoSTwN/RlvHcNy1vK4I73yEF02h7ddimjFBCN3NB5x9JUQm3DoBzRgxLJdTEjnTh8OmqpjWrYSmrarapGGmqRjKe0iBIKkWvRRg2SOAF6rTdppK2GSCp+0P5YhGSugtne5naOLXTSg1LOxsBomZZ1rs+1Kto5RGOHaIJEYc06FxwfNd8n0qKIUaS/Ne2iTy498MhuBaGXHVwKwQ2ChL7HCIaeJJcsyPQjA4uSI9IcLEFFAlr8lgHclukl5lAEyL2G1oNPBiTXYaqVPrkJJQrVOdy6NuKQLsOKWJluz8kBJ77Xp2gF2YBJcAMkAgxTWdTEVaJbT6yX9TFsAFFKV4c69egCuSb86I8e11NzMuJjALxSJzd/MhSiqeEdespeso5BJhFPtncV5Syo65Pfb3skYKt4o9PTl0SKXMQb6WUQ6yYO0jfSt+YBFOX7oN+GRpvXXpDLGH4JedcErJOQcrSYIc9qiPSc5kx76vQ3gwPEREnfsJOwKV+NM/jQ06R8wbNUWLam0LsNPxKhaipFpUTxmIgNx/Yqcnttt+U0cEJyh0JHALJLDkL77gYBsQN9iAf2FfxMo87KF1eavtm6AhcPp4keeqWj2clwzpzBifmAiZZGiOXcUHEIOqGTRM9
 Jb0Ap8jB
 iudlx8qiRF/frnQr+WSMNPfwT8UdxYqvsrmWVknKH8ssT/9RX6bE56IioeeVpJ9SzNPGLiGcK0FlhVwdMxDC4XGAb5CNMfqpzhLcZ+S26Peo7szuPo+8xhvVpWp/sgfS4OKrfIZyPaC3IKjKz38J8yPxxj6veuwwHfcnEhzmv5bJmM9Er7PxD7WAMGq5OwXRZv5OiJtHpJEvv7kHhm1QsTCp6+gcfPrn4lJ16guDgy0II3mzRIzfBpgxrGWn/NVBTEd63DEOXeNLZUZ3jg19Rg85hVQEyg2YVbOTEWnLVHTQBxDz+S+QbS5bSaZF166WOhCgL/g4lx4CJkZF8OMoMzHdprp5776owfayiEigk4wXpGMF9r9AEpMPRkYW6il1GzKfmZsdtHznmZDV+Lm6H54sThNxuAwj3K4PuQuaGyZr3ij33TwS4xbhjP2GnzYSBhJniO6ralhZgFFUz7+K4aiVvXfGZh9daLUCj6jAtpGNfdHDuVvTS7XRM9j5OqiyCo82EalTNWcxpRWUiFdcvqUEM6f3FDKLUBeEt21cJ3ez/8EIQ5yBuxY1nXbJaYYbkkNV0brZP+o6UC+nT8Vw6GYDfckSVTHlC8721HY6YvFfYAus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the cmpxchg loop with atomic64_fetch_andnot_relaxed, which, on
systems with LSE atomics, should end up as LDCLR.

This is somewhat overdue. In recent versions of the architecture, if a
system supports FEAT_LSE, forward progress guarantees for exclusive
monitors and cmpxchg loops are relaxed.

Mechanically, I would love to write test_and_clear_bit_relaxed(), but no
such function exists (test_and_clear_bit() has full ordering, which is
also undesirable). Implementing test_and_clear_bit_relaxed() properly is
a pretty large change; use atomic64 instead, as pte_t contains a u64.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/pgtable.h | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 763c5a411d64..e47c3d010715 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1252,17 +1252,11 @@ static inline void __pte_clear(struct mm_struct *mm,
 static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
 		unsigned long address, pte_t *ptep)
 {
-	pte_t old_pte, pte;
+	atomic64_t *pteval = (atomic64_t *)&pte_val(*ptep);
+	s64 af_mask = PTE_AF;
 
-	pte = __ptep_get(ptep);
-	do {
-		old_pte = pte;
-		pte = pte_mkold(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
-					       pte_val(old_pte), pte_val(pte));
-	} while (pte_val(pte) != pte_val(old_pte));
-
-	return pte_young(pte);
+	/* Atomically clear PTE_AF, checking that it was set before. */
+	return af_mask & atomic64_fetch_andnot_relaxed(af_mask, pteval);
 }
 
 static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


