Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE56C79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 17:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 708A46B0088; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6935A6B0092; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F5C6B0096; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2023D6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E06C140558
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:50:20 +0000 (UTC)
X-FDA: 85184076600.23.AACE10D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0AF54180003
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:50:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPwMeAyy;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788717019;
	b=5D7EU8ItLs8ornsvNITmvM4g7n0AWkWuFzRDmaBS82D/wtxh7OzPNHZJBOURWeKIpc7otj
	n5UwE+2FiGIklcO/gSIryDIhZU+MuVnheRMcRJbX1SL0mObyz7PxrH/YFD3JxhXfpxbR8k
	LN7BUYc5Od3vb25j1t+HuaPsmsVrDCU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPwMeAyy;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788717019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9caat1DezSKbkpbmOqFRGnH5jIo166ZKqznROpa2/Q=;
	b=EkK44u74rWt2cwJQCCgWoT4xNUJGaltZwhR2MjbMCWKA+Ect72ihyAkMKEh/9p1+BGhiXs
	HxpYDtztOb68cuCr4f0e+PFtArXpmWwC/sBqmcaO8kUZZCLOmoVnkXquDWmn/B2JJUT8Ux
	2Jcz7jECEDtKZ1ZEDhWYRpsU78tRrBc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 379F6601F9;
	Sun,  6 Sep 2026 17:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC08F1F00AC4;
	Sun,  6 Sep 2026 17:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788717017;
	bh=u9caat1DezSKbkpbmOqFRGnH5jIo166ZKqznROpa2/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UPwMeAyy1zN0zViRcHCHpIXrbfpEzl0oLLicpp6K2n79LNSsX9FPaYCnG2uEEmoBO
	 1TfNYupDip/RSKBmuPRpDO72DgiQn4Q5nl+a921wHsPmNsozwgyUYZnE9yMoMIfjgx
	 AZJYvc2i3zaRB3BGIg5DlX5C894GhNKijgYziij+KEg4GDAprt4u2mU1IW96Mjac4g
	 H+rz/9AqbD6A1FuJl2DLpsJ+IEBS/AH0lIjDq5tWZtnp16J2DgdA1ZXBz2WJuqme3K
	 IYQTOoUc842UlENHQAWsFThkeBtti+p8taHUYkEb8oTEUoL0q/3sZfTCGOL6m1SXRL
	 uLjeawFsQDjhA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/5] mm/damon/vaddr: support DAMON_FILTER_TYPE_PGIDLE_SET
Date: Sun,  6 Sep 2026 10:50:05 -0700
Message-ID: <20260906175009.93471-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906175009.93471-1-sj@kernel.org>
References: <20260906175009.93471-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0AF54180003
X-Stat-Signature: 7orxqessqpra4w7he7pj3a6ean31tz3w
X-HE-Tag: 1788717018-133719
X-HE-Meta: U2FsdGVkX19+mOri8irEsFsM1H0NBi4GQZ0GsCemhtkETTW0Gzb+iZcjopKi5U6N27mnFX6i/WFYoUrXltHi7HaDqxsanAQDbqOtCh2Hm4lVcv9VjhsuVpv3ZqBRtSF10j2L6K1O9LmFS+Eu0j+ypH+qfEmWd5gCHtlbunjUWVBd9WXUaVHF1Jf534EQRly0fW8B+jrfSQ5N3GCDgji6aGnWymnU4edNippZYDoY4GznDxgWbk1UO3NebeY4yUtwtjPToLK02egdjEzb7h4ctT+xLysJ3Jpc2IgeDfsa16itagMCc84VQuhQS/uHvxRmgFnHkpV/eevFqLKnsJG94CKkmZtFL/XktfHeL99zDLSthBhn9fe7W5GwOzmWaVYcpW5pA30MUPc+Z3B0QfVJcTguji56IRoDhhONjnKtbOrGk3GFtxnE2ZLHMcjBFvyU3d+CoOfTA0snk6w4Io3nEkuXWviiUJ5RA1y1aqtaldGiwITQcGCc6UYWNY3eGnfXvMTYrK8TTQRd57GsULm45lVEAnDaT+F6PGA4sSqDpAR/45U9Wz73vFH5hEQzt24+1QhL7abdwo+xAgZxFhObicIBdj9VnfJ3aHdO6oX8DsXQOSs6k0a5yWjqJqBV79KSMv38sepKCPxFnFWvaH++acWp13kkuf2ES+Odf+G3DSUc0wnVhBLMJw/BtF7nAk4pCFMrlDA5oMajDzcxXwx5F5TsvZ2DFHxfOcXFRL2tINmr34ALk/riJHVu6KsDJjEt8PP2i7Gndsa+rRUa5sJnPBRNeTaIqrWeBLk9+vyJO5MQ5YPvHX5beSEFib/MhybHyMGkWuzqFF4gYYCdKHxBkDatGt8lfHY2ATkOSRb876k+Bp12lcrsvTmsUEZf2TmktVCe+/n7G7yUHvrKKjHqHTP7c1dF6cOfrfxlR2fSOKw80+WCLBSslDsqBCvv0zHFI6EH86g5XYmjWR7hmpq
 2sIYdK1T
 2GB9gcQZo189YoDHpezPic4Q6Kxvq3kuBgmqbBL0WtQqAT1ejPEkpihk3UPzL8Fxng4q3rKIrLyQjrAH1lvujBmnCpK9dHMC46LD1/R+hhsMnK49j+7HxD8scOD9Qq6OCR2DTMRrSDh04VrpkMsG1qzauN51bblvd3bx5j5VbVkqiCcb8klg9jAiRhbEOIKgom6ontdjzXuK9JmGdPeZ9M9Eq5fBLw6GFJxIjbkYoWMnHqtyeum07BvkXWJ88JiGzM9TWYix/h+W1Ix06tcZ8mJ1Akg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement DAMON_FILTER_TYPE_PGIDLE_SET support on the virtual address
space DAMON operation set (vaddr).

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 9a38dc89a156e..7063356370c34 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -550,6 +550,13 @@ static bool damon_va_filter_match(struct damon_filter *filter,
 			matched = damon_va_young_addr(folio, pte, pmd, mm,
 					addr);
 		break;
+	case DAMON_FILTER_TYPE_PGIDLE_SET:
+		if (!folio)
+			matched = false;
+		else
+			matched = !damon_va_young_addr(folio, pte, pmd, mm,
+					addr);
+		break;
 	default:
 		return damon_ops_filter_match(filter, folio);
 	}
-- 
2.47.3

