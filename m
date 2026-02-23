Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68EF5EC110C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 17:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B676A6B0089; Mon, 23 Feb 2026 12:39:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F1E6B008A; Mon, 23 Feb 2026 12:39:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A768B6B008C; Mon, 23 Feb 2026 12:39:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94B516B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:39:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5BC7C1C0DD
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:39:48 +0000 (UTC)
X-FDA: 84476434056.03.451D332
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C625C14000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:39:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gwZPMv2o;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771868386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHcCb2HsJLijQLFR6u7ODO3T63bB2yOAHEVWHTJ3SbQ=;
	b=jjd1wWwNnAR6jQaTyqB+bp97Bkm0g3xvFuft4LgcSxguWTmU3oYdV+5jTbGfz/nvaPmN/Q
	7I/1QcPw3a0tvhvDxjAmUYZ8bYdtE6XyUjrBuAuOwCOIXP4jW6zA14JtxHuJOtsDG3i/yJ
	MRdmCoGEcytfY0qvkeCXodbaQk8oHII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771868386; a=rsa-sha256;
	cv=none;
	b=qsX8V6u+W67SAdwSIEAAY1GhaYjLy1j01Irr09W45rdtQyxBSKK8L5+Rwzom1rgSswlJs1
	Uzg5+sNpb9oFWNn3yzpg+b7wul44jmlp0fzI1vX9nv9+wg3VSuEXGfLENU7AVQ7AmDzeQJ
	SOVpSn16eRso6pEcL+v7IAjqQWgc9j0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gwZPMv2o;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 34B9061118;
	Mon, 23 Feb 2026 17:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9C9C116D0;
	Mon, 23 Feb 2026 17:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771868386;
	bh=KPLMRqJNulMdw70KhDZpgFoKTEgDZfxf2vi2hDqk/Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwZPMv2oaRXv+q25/D5x6vlZzXflUJmjGV4pALpQJgz46CHbsuieJUiHTSaROAbnm
	 u7pmDRkPoqTELwyN5p5AbHtMTBjfrilOMgqbApDyxACq46wf1nYixFbyN9gYQdcmaP
	 VQqSgbKN1Y0UT/mklqsSts0sqKX0785iCigbgnDRLxdU7qcPyMh08y0uchYRV+2VON
	 yCIztLlF1sGjQHylJ+ueQAr0tIt1R4fnKDZq+g1VT2rDE2AkQbW9VIhB3yy0v7sgtn
	 1omxvKDF1Xt2WYMBOknNyu27Z0nuIP3JYPdG+qQ8XvqYyK6u2mpUVPn6S6C86Wsbp5
	 6dJL1sbClyTDw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] mm: memfd_luo: always make all folios uptodate
Date: Mon, 23 Feb 2026 18:39:28 +0100
Message-ID: <20260223173931.2221759-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
In-Reply-To: <20260223173931.2221759-1-pratyush@kernel.org>
References: <20260223173931.2221759-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mmw6ahp7qycwyf6win9qeq5ayayuds5c
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C625C14000B
X-HE-Tag: 1771868386-328782
X-HE-Meta: U2FsdGVkX1/UbBXulT+Obnk/ZKhdinH2rCquN1rQpSMQMvKnzBKEvTgL9sQ5kCHmANJtuCIp9Twl8V6eDKsMFJcQlTzKcn301Eko15OM/r3I9fi1U3bUDtslL1ryeFkGxt7F9F3LnSPj0Aso07C3rWYlNE+xor8rAgobPh4li+lMUGedSrkXP3Qvlh4i9unJPHuuCZNLbxvVWNt65diyF0zCNB33r9jf6oeMBlec7X5uJUNvlWMqPB4czabec6bo7IaRgoGI7IhowBRW/ZDl3Q35cWl5mkSSn9XlOVA5/hp1Rs/a/X6k6Nbs9vE6KuGpbWPUTPuDIpsZR44M9fUVM2ImvxfQOy3DLhauTZWvTii6OK8fuaoWt+ZtbXykEYL4oVoThpQbEDkr6XPuD43+gTQZOBhg/xJlv0xI/PS638KSDhvGiK6iirzwLSWQflJQaSNdymHc5cjf0xzI3eLyZzZZoG+zOJmDcibh+UDXmV77QVmjyuVFbDulocwtLu9x5D6CaDTaCGBCEZBQ4soGJSqOCsw1iakQASYXQSc047VRpTBEvCznQuvvgPFXkwWoS1S+CLElpy5+lwEOdqtdhwSTrl+h/hiMunf5OOadR4xMPRkRO84CO6lGeDGtVzL6Tt3jD7PQqrTCxRLWDeoJEwmD7TIt2YaytYhkr1MMWTpnlTlAWGYCTokqDqXaisFdmKHrlEWayzCKg7qat9cW3tNq0IYKFbZBCitV0BvXDtpG1eEkXPBuw+ek2vgRirpBIiBQkMnWa8z24vdiX6v5zDcUhirZY3C9RTxeYPYKo1mghks6utqjdlspCm0copTFXCKuEqrM3eF8F1uxKA/8BqH+GpS8LctOAbjSZCEJDtaGfIlxUp6FZ4PQUUqHF85ubfzluZptQdAcE5UupQtRCs6oj6wo/7TMUVvC6/0m18f5z2zZd3Oew4IK5BOBxxxuqiUQFjae/b/F6z4JHLU
 aPSkLwje
 Z+Ck2/Nun0ILbALP2UPzc9a1aKkCB/9eazcuRGIW6uOQ/sWfrWe/wly5nWV+StlDeoCfnIx0kJAgC8WbkeJ8Shtuv2lIZAD0crNG3PignDDyWLy/r0QudePxn+tnXNqiUoVFNoZmOML3svAA+p6STTsfs1khMlzjXK21+hmoFX11bT9xZhIFlLtDPVq4l/qgCoBjpaCp717vVYJgAghQosi2hu37wK/h+EFzeHLPToqHBYCyYtWhRxlky9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

When a folio is added to a shmem file via fallocate, it is not zeroed on
allocation. This is done as a performance optimization since it is
possible the folio will never end up being used at all. When the folio
is used, shmem checks for the uptodate flag, and if absent, zeroes the
folio (and sets the flag) before returning to user.

With LUO, the flags of each folio are saved at preserve time. It is
possible to have a memfd with some folios fallocated but not uptodate.
For those, the uptodate flag doesn't get saved. The folios might later
end up being used and become uptodate. They would get passed to the next
kernel via KHO correctly since they did get preserved. But they won't
have the MEMFD_LUO_FOLIO_UPTODATE flag.

This means that when the memfd is retrieved, the folios will be added to
the shmem file without the uptodate flag. They will be zeroed before
first use, losing the data in those folios.

Since we take a big performance hit in allocating, zeroing, and pinning
all folios at prepare time anyway, take some more and zero all
non-uptodate ones too.

Later when there is a stronger need to make prepare faster, this can be
optimized.

To avoid racing with another uptodate operation, take the folio lock.

Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Cc: stable@vger.kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 mm/memfd_luo.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index a34fccc23b6a..ccbf1337f650 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -152,10 +152,31 @@ static int memfd_luo_preserve_folios(struct file *file,
 		if (err)
 			goto err_unpreserve;
 
+		folio_lock(folio);
+
 		if (folio_test_dirty(folio))
 			flags |= MEMFD_LUO_FOLIO_DIRTY;
-		if (folio_test_uptodate(folio))
-			flags |= MEMFD_LUO_FOLIO_UPTODATE;
+
+		/*
+		 * If the folio is not uptodate, it was fallocated but never
+		 * used. Saving this flag at prepare() doesn't work since it
+		 * might change later when someone uses the folio.
+		 *
+		 * Since we have taken the performance penalty of allocating,
+		 * zeroing, and pinning all the folios in the holes, take a bit
+		 * more and zero all non-uptodate folios too.
+		 *
+		 * NOTE: For someone looking to improve preserve performance,
+		 * this is a good place to look.
+		 */
+		if (!folio_test_uptodate(folio)) {
+			folio_zero_range(folio, 0, folio_size(folio));
+			flush_dcache_folio(folio);
+			folio_mark_uptodate(folio);
+		}
+		flags |= MEMFD_LUO_FOLIO_UPTODATE;
+
+		folio_unlock(folio);
 
 		pfolio->pfn = folio_pfn(folio);
 		pfolio->flags = flags;
-- 
2.53.0.371.g1d285c8824-goog


