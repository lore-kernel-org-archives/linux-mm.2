Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37BB2C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906906B0096; Sat, 11 Jul 2026 14:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842006B008C; Sat, 11 Jul 2026 14:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 709776B0095; Sat, 11 Jul 2026 14:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6FD6B008C
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:04:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F7D7C3D25
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:04:23 +0000 (UTC)
X-FDA: 84977270406.12.012C14F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1A1CB140006
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:04:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MulPV6Al;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783793062;
	b=Aormlut+0KFEdTp6BJZ1k8aPRqMWa/xrXOOnC1Z3k2q+DKMYGSueJ95ZCi8YJQNdgKtCDd
	Pu1iuoxJs3K/9pMJdhZBTwkCHdL6ZsfoN0LXn8G6pfsKg05KERooYwOQgdRFiIudg0IOIS
	PMEZXbvBafrJLHOM9ujW6PIiA1hnTUM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MulPV6Al;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783793062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTFa+hpzXfcfyF1zP3rvNz2Fhu2Cffg36gE6sioOaYQ=;
	b=xXh1nZQGZ6zcS7EoHL3Ui/M7JQeAwYGhjIDpImKMDsb+CFdRDJELtgOxXrKSOMfeaZLnQb
	aRjWjOpxTuPe1k0w7uW1nThBNiN8BvP5IKejapdycHglMJBRFETUSmMJuREoCDt5jeO28q
	Hf/eqP+MUbVfjKzwXzZHqvLiJmpCpfA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA95D61371;
	Sat, 11 Jul 2026 18:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E7F1F00A3F;
	Sat, 11 Jul 2026 18:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783793061;
	bh=MTFa+hpzXfcfyF1zP3rvNz2Fhu2Cffg36gE6sioOaYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MulPV6Al7PdRkuMvExn0i9dIE8w1T9TdjXcHiU7mSLmr/ml12UAOwG/CZB/qATXyf
	 md+aw7JdFjco/wyrSPmUgbVnYVIWdagWPMgaEfYZH7g00f7zpaGKkeqC0yN5cBsRPy
	 gyiux1YnfWFwgb27qLWugO7JiIiU1fafzNMWASxfjhqEibw1QHZ0Y852PNflQhjisA
	 SizWI8fULFQ71nSX7XRNxjg5h6laM3HKdaG9E/i4esoKomDjNXO8/7KP2qAutjSFZx
	 64lvCUtBI4imnyFEDZUkaGEGvdN+oPYnCL3wVMgmxqeiRhPXxWmFw8SilDe3O2WfBn
	 eKOttvdn0SAOQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"# 5 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/5] mm/damon/paddr: drop last same folio access check reuse optimization
Date: Sat, 11 Jul 2026 11:04:07 -0700
Message-ID: <20260711180409.82093-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260711180409.82093-1-sj@kernel.org>
References: <20260711180409.82093-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1A1CB140006
X-Stat-Signature: p4wpgcj54xr7ox7dduod3my3sfxwe6jm
X-HE-Tag: 1783793061-885440
X-HE-Meta: U2FsdGVkX18ewVSlOgxUrKH5tyA2JXLvyuOqohzlaj1z4sCCMwGkhPTsfd0E5GV9YkVP/MkO7ivR0RRIzqALqp4FL+KqX7AslTjesFz3Y6mmetTRJNdl61SGPi8BfONkXBHUFpojb686m3flQj0Y5QwpFTBUqQltxbk+4SUUtD8XZPjVK5GWt29Yf4f+qJA1a5ozp06ConYPw5pp4cWRlbkfiwk2dxMpVkGiQyEFX3tRWHZzxa7UHxY4h2dLKlnGgnYTvuLWNY1MXLgRvbPv9E08nhFJ4UjFPH63Ua8Tu2yJ/0kOwQF4msVYcpwPYnvDnX7i1Egf078+HUbN05TXFFQ1OsCbvDjLzMguL+Z8xdlxlC4iWvXg9oYymbBiN8F1n+PDSDXMUxglm9guX4bwq23dpOTElzBc5pQCPLZV7FkC3+XA5OiPramq+cY7Xh/2VHy+HjiNUNn3RXLZ9mB3b8RJFrdKpIExhyK5fHLS1tigmgqFKOhhwJnybfmnbtFa8p0FO8sFTfCviMCVIOCysY/VKhpTAc5fwzV+t1KyblfJa7O0oAyXEYzUtE8F61Ygs6V42u6rdWTjiEyZpJZFQmz76lS+XXKw72LjX4FSKWwE4DcpWlEw8oJ/aBjUrc24lVTkEOBwcZhMY6LA0cbO2wEU2gdO1MD1PLLOEQlA9uJAF3AczJbD7B2RL8/yWyjuGuq1xG4V2pysowS7IF3peq/219EMANmWQa66sd03vqz2GXgsw98SY35ZdRJC1iQKZUMp5YDW5r2Hd4Vx09BKkZLEY8eyKNZ8SqYOXoXXDhgHsoaimmWMyMJKgsomO3icmDC/UvczVkXtcTzbtTEGMpWJfE/f+LPqb/2eiOsQApnjra1A4aQVeGSgpSInPDMa3bnrhQvIdrD8yNvwdH88RgQcCAafHCUn6kogmJElsgUDL58msUnfXkKZSGgDDi46wZUM8uij7WMZYMNSWhP
 Q2eOHMhR
 4rgihXJ1+CGha8+G6wtGm3lSZIhvPmlAf1Ocok58XF/SHE8VTG4kuYEYwqYSMu9N8YfjXcJALsmsKaRS8GBslh7v4bwpcahGE5zpG0PlcTa0c7GsrMI8k7trLDrXO5nH+QZ24ln0MhtRl5JBtrcJNhsLlNIwvsp2SzcAFR53Cq4GD1M3VRv4pcyoVtO1ozRFQ7NqK0QP0NApfWTKV44SoBNRtztlMhIamH3h6EYdxzShOam0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It can race when multiple kdamonds are being used.  The problem from the
race is doubtful, but the gain from the optimization is also doubtful.
Simply drop the optimization in favor of code simplicity.

The user impact is doubtfully trivial.  After all, this kind of
interference can happen only by intentional user setup.  Even if it
happens, it will be rare, and the consequence is degradation of the
best-effort monitoring results.  No critical consequences like kernel
panic or memory corruption happen.

The race was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260621204050.10993-1-sj@kernel.org

Fixes: a28397beb55b ("mm/damon: implement primitives for physical address space monitoring")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index b85f88a7a38f4..e4f98d67461f5 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -65,7 +65,7 @@ static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
 	}
 }
 
-static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
+static bool damon_pa_young(phys_addr_t paddr)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	bool accessed;
@@ -74,7 +74,6 @@ static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
 		return false;
 
 	accessed = damon_folio_young(folio);
-	*folio_sz = folio_size(folio);
 	folio_put(folio);
 	return accessed;
 }
@@ -82,23 +81,12 @@ static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
 static void __damon_pa_check_access(struct damon_region *r,
 		unsigned long addr_unit)
 {
-	static phys_addr_t last_addr;
-	static unsigned long last_folio_sz = PAGE_SIZE;
-	static bool last_accessed;
+	bool accessed;
 	phys_addr_t sampling_addr = damon_pa_phys_addr(
 			r->sampling_addr, addr_unit);
 
-	/* If the region is in the last checked page, reuse the result */
-	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(sampling_addr, last_folio_sz)) {
-		damon_update_region_access_rate(r, last_accessed);
-		return;
-	}
-
-	last_accessed = damon_pa_young(sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed);
-
-	last_addr = sampling_addr;
+	accessed = damon_pa_young(sampling_addr);
+	damon_update_region_access_rate(r, accessed);
 }
 
 static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
-- 
2.47.3

