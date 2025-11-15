Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F60CE8D6B
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 03:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1B268E000C; Fri, 14 Nov 2025 22:05:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF26C8E0005; Fri, 14 Nov 2025 22:05:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A07CA8E000C; Fri, 14 Nov 2025 22:05:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 91CD88E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 22:05:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 19EA912EA0B
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 03:05:05 +0000 (UTC)
X-FDA: 84111349770.26.D4665E3
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7CD87180009
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 03:05:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=t1MQHiTE;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf16.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763175903; a=rsa-sha256;
	cv=none;
	b=NJmdXzn37xoOYijVPfZVkmx1q/wKtTKLUEaVKkLVKQ4dprkL6llXvdvNLDpyYzrfdH6rYR
	V2z1jT6YJkyuIUJ//2bWirYtcooLogHeylPnnSvlY7Q9uE3J3Kr+k3OJXnfEVhVFM+jo3Q
	DYCTSnhXiWszqsMyysDSvqYb842YuEM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=t1MQHiTE;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf16.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763175903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3pfW+nTPOizp5ae3wU4J9hmG9q649UAuyaxagX4QObQ=;
	b=zcW4uRePLtTAHauiCjffUBXWAkhLhoKYrr4PAORHE4nBcz80nTiSGJ+tOKh2IXQF6QGQEV
	pdrY4gW1CYsu2EOfWrtFXLDgnMNfsWhgB/2EzvJBPYSWZBwTRzd3pqF2XKQNveZTieK6Bf
	A7RMejnR6p7MCnK9fmHiVu9JjgOivik=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1763175897; bh=3pfW+nTPOizp5ae3wU4J9hmG9q649UAuyaxagX4QObQ=;
	h=From:To:Cc:Subject:Date;
	b=t1MQHiTETD6Xa4ok9CrCSPmZr6M2rxRVVTU4PWZH0Hjs6No1LX597GLzUKVrS3z6Z
	 KI1eeefzf29gFyv4WSfCFq4JV1rnHooomlATNRGc71EzWUIOKmGY+YDYWNXKvIcy4I
	 ylOPWy6P2bzhtGE7KjjIkDu4Njt5sMmLjOlt16x8=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 1363F030; Sat, 15 Nov 2025 11:04:54 +0800
X-QQ-mid: xmsmtpt1763175894tepxfd5gx
Message-ID: <tencent_EB0FED91B01B1F8B6DAEE96719C5F5797F07@qq.com>
X-QQ-XMAILINFO: MqswyhUqVe0CRwL+WpQGJ/BSeXOV4C9EFjf4e2HSkVgZOStP1lYvvkia98RTiY
	 wZiY/DskIq9cTwce7tC1BTsnTCtlmJMFytzRrhLx+fZ3PaJUsOgDvJOn4vymnquFIo8jYpYR1nMp
	 BugvTTAKGzBuc+puVgx5M4l499kwvWe5G3ZpzAxCp0o+JwNwgGnPxlsZN4CFN/F6bvzzQJ2x7crX
	 oG33nOh9GevUbZG+f/yjHN96M41Q11K+5TiKQpLc8ueL9L3kpic8KRkX4glIuJKsP0lQN578Aogb
	 jQ25NUwPkkAcYpzu5X3FAW5flcpiIgJHWmoJ4rQ8AUSHgsw/bsXRtVXmZ1GyfqgPrgIRSYXHl9Js
	 IzTT/iEA7uF393ygXhJp2+Bq5xGUXlq6kyYdXRQ+lGdl/ytmzDy5k7c03Hj2JiXCXSxCAtvRWPZb
	 72+es7kBjqoPSmeXZNP/wZhfFdUB4XZTE2d4XctOraxCVtx7gqzbLu+rA2T2RDml1E6Lmms7bE1t
	 vm3bRpjBmCxuHalHwOabG4LXUeHzQgl2ecCKjYk3laac3EECzZmVyAwhBZTCEKGkok3+Z1yj5Whr
	 7YDT0E19+gd6Fvcsp7BVQDsnlkSNYBjlDBAQzfiYRgucfQOnswOQNtjet93412ZR+KZ0ca02zyJE
	 YZYgVvkS0i5d+ywW0tdLfEtTgga0lOnDMtV83Xc5r7Cg2PGLp7bOFAEo4liqyCPC0gjyfb6urfLK
	 gCki5qVk7rZhnNuBUcJstfFtktnvhCtejaPjUa2GkwsqBKhjRPDl3CGnYrpjuuyWDOe7UXx9y0aQ
	 HywY8eGDXfmbHlPdfxNE6VLD3hynfjkleeTC/ywfD6dGxkK9oLGqHEKia11Cfdkte1KS6ODtLlJ2
	 /XQwqOkYy7cLH993eIvv4ggDC2LxHAbcJeTegbpx1Zi2HSkfnY8uPeIaFPW7W+1qXnSs6sMgjzgT
	 I9nFIsxQMefr7WPk7oS/+DzwudN003PyHmcUJ4g73uqGENPPJd82/QvheNIsGCJz+FTTjMm65zfq
	 zkGc1fmpmSiiTaJ5qt
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: fujunjie <fujunjie1@qq.com>
To: akpm@linux-foundation.org
Cc: vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	fujunjie <fujunjie1@qq.com>
Subject: [PATCH v2] mm/page_alloc: optimize lowmem_reserve max lookup using its semantic monotonicity
Date: Sat, 15 Nov 2025 03:02:55 +0000
X-OQ-MSGID: <20251115030253.3138157-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7CD87180009
X-Stat-Signature: hfecan5pi3x4ugc3rjbtws6wuzutyrbh
X-HE-Tag: 1763175902-835782
X-HE-Meta: U2FsdGVkX198UeZIIuS7yHBr0/Ea4r5UNC1/Ms54UTY8SZ0FiTOBk6DdiwvLgYccpBkWhRdIBUt3TTwlUaInLTlSUMDkqVGnD7MNElOdchZ3gSrQnNBjL55tSvg6vCQYnpU2+Bon05xmL67GB8cnVmoA2FrwA3PlAs1yw8/AdmpT5gU2xAOh3heuqGoKRpRlUe1K9+16HbRr6fYornj4qMeZFxLLFWojtk3K2aYnPmSFrKtBN4i73jyl4mZpQ6Kno3dBgz12bHHJyRKAJmdgtVCT2mA6/pC52vU07vXyzktyszn/j2Wqi1xOVUR+kmNkzNUQau84HTjELYjBAkthlw+lTVM39C3kDEhTo3G86m+kYzEJvYuA+ykvd1jCz2LHF+0WGWqsJ+On6AD9TcnQP1ecGS3F45qCyGC6bvXh3NmZwIeCqbMSir85RSOMiNe5NApS+cdIV4Bac7sY6oB4n07zINeYHuDyvwyxVBfEFXyns5K10UJMypDQBQaVZxgqGPrZm8F/gAuwy9phXmx28P7mFoWGr8GWKOTl5lb6n0FtlKz2Y5HTWPPzWMvJU2M56jScVjSbEd7oYrQcAr0C/RsUapKm7KlUyjtq8DN0P7yFqMQUcuQMREXBuPYzkIOSYdXwiQ87PzToQbKu/mHFezOKHYTSM+51doTyJ2lDUxapDOsZdv1AAdCCnikY2ExI6Azsf+Hl4TNrtiwPy95Rr2NGS5eh8atipQwcWFP5WL5bEpr64aNQnDSNsECQ2bgNAJ5quMsF+OEQS0Z6FAqd45JySkgITKzj3M8uicaGjMFGD6E2xm/Z//GpRfsfy4VImQ6pa3gLWp9r46vCz1+2SXWHzIR9Ktrk8f16lbKy0TDWiRWXu0jCPu7zdKtP1I2Dn/FzFmWjtBHBcV7tj6oLyMwKxT0En3M9jtoeh45eW16aRBi9b83cybqBXiIEJ0W3REDKiNoqXhjv+OWmhda
 ISVcT0t4
 jEkt0tYIOlFStft7ekd61LApwZVBNgINj7aX1NJpORFGPfJfyAvtzZu7qs2+hzmetmOL66PlM9VpRR4O+0WMMyDiOCNJqhia8EF7gE3JZwPHpb5CpvdiGi3q0xRr0fFwf/WNEJbWqYAPvC1rZ5KXn+uTtECUAn+StsSpB0iku8eRX+Bh8Yb0i5b5HoilZvBXvF6A61ioN8Hes2VoT90W6OjRAsVYKgiVkGqrLvLbioSV2lE0/gM0v3j5LzuqCM6fwIl9QeJjBKoKvM4M6/Dw89JwBsatD3G38sRJtn1rdkS/CO6sE8CWwBU44NTUVEvaw1wdg2wR2Cd8klUe1arTZhJV7Rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

calculate_totalreserve_pages() currently finds the maximum
lowmem_reserve[j] for a zone by scanning the full forward range
[j = zone_idx .. MAX_NR_ZONES). However, for a given zone i, the
lowmem_reserve[j] array (for j > i) is naturally expected to form a
monotonically non-decreasing sequence in j, not as an implementation
detail, but as a consequence that naturally arises from the semantics
of lowmem_reserve[].

For zone "i", lowmem_reserve[j] expresses how many pages in zone i must
effectively be kept in reserve when deciding whether an allocation class
that may allocate from zones up to j is allowed to fall back into i. It
protects less flexible allocation classes (which cannot use higher
zones) from being starved by more flexible ones.

Viewed from this semantics, it is natural to expect a partial ordering in j:
as j increases, the allocation class gains access to a strictly larger
set of fallback zones. Therefore lowmem_reserve[j] is expected to be
monotonically non-decreasing in j: more flexible allocation classes must
not be allowed to deplete low zones more aggressively than less flexible
ones.

In other words, if lowmem_reserve[j] were ever observed to *decrease*
as j grows, that would be unexpected from the reserve semantics' point of
view and would likely indicate a semantic change or a misconfiguration.

The current implementation in setup_per_zone_lowmem_reserve() reflects
this policy by accumulating managed pages from higher zones and applying
the configured ratio, which results in a non-decreasing sequence. This
patch makes calculate_totalreserve_pages() rely on that monotonicity
explicitly and finds the maximum reserve value by scanning backward and
stopping at the first non-zero entry. This avoids unnecessary iteration
and reflects the conceptual model more directly. No functional behavior
changes.

To maintain this assumption explicitly, a comment is added next to
setup_per_zone_lowmem_reserve() documenting the monotonicity expectation
and noting that calculate_totalreserve_pages() relies on it.

Changes in v2:
  - Reword the semantic explanation of lowmem_reserve[] monotonicity to
    clarify that it arises naturally from its semantics.
  - Maintain a minimal reference to the invariant in
    calculate_totalreserve_pages(), with full documentation placed in
    setup_per_zone_lowmem_reserve().

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/page_alloc.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23d..d13a81de2203b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6285,10 +6285,21 @@ static void calculate_totalreserve_pages(void)
 			long max = 0;
 			unsigned long managed_pages = zone_managed_pages(zone);
 
-			/* Find valid and maximum lowmem_reserve in the zone */
-			for (j = i; j < MAX_NR_ZONES; j++)
-				max = max(max, zone->lowmem_reserve[j]);
+			/*
+			 * lowmem_reserve[j] is monotonically non-decreasing
+			 * in j for a given zone (see
+			 * setup_per_zone_lowmem_reserve()). The maximum
+			 * valid reserve lives at the highest index with a
+			 * non-zero value, so scan backwards and stop at the
+			 * first hit.
+			 */
+			for (j = MAX_NR_ZONES - 1; j > i; j--) {
+				if (!zone->lowmem_reserve[j])
+					continue;
 
+				max = zone->lowmem_reserve[j];
+				break;
+			}
 			/* we treat the high watermark as reserved pages. */
 			max += high_wmark_pages(zone);
 
@@ -6313,7 +6324,21 @@ static void setup_per_zone_lowmem_reserve(void)
 {
 	struct pglist_data *pgdat;
 	enum zone_type i, j;
-
+	/*
+	 * For a given zone node_zones[i], lowmem_reserve[j] (j > i)
+	 * represents how many pages in zone i must effectively be kept
+	 * in reserve when deciding whether an allocation class that is
+	 * allowed to allocate from zones up to j may fall back into
+	 * zone i.
+	 *
+	 * As j increases, the allocation class can use a strictly larger
+	 * set of fallback zones and therefore must not be allowed to
+	 * deplete low zones more aggressively than a less flexible one.
+	 * As a result, lowmem_reserve[j] is required to be monotonically
+	 * non-decreasing in j for each zone i. Callers such as
+	 * calculate_totalreserve_pages() rely on this monotonicity when
+	 * selecting the maximum reserve entry.
+	 */
 	for_each_online_pgdat(pgdat) {
 		for (i = 0; i < MAX_NR_ZONES - 1; i++) {
 			struct zone *zone = &pgdat->node_zones[i];
-- 
2.34.1


