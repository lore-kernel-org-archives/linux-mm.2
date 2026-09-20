Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40A63C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 14:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C89206B0088; Sun, 20 Sep 2026 10:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39DF6B008A; Sun, 20 Sep 2026 10:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4FA36B008C; Sun, 20 Sep 2026 10:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 933A96B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:13:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8DF6C045A
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:13:37 +0000 (UTC)
X-FDA: 85234333674.01.F4D4E95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3A97B80003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:13:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AngTpMas;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789913614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=A5dVatuJb8nLIceYIpRqrGfNVuiP4W5dL3y+DyE7U2Q=;
	b=aqkg89yKXY4diUNeAHIkFQp6zQ3AruzYKiUcpjB2oA1660/zLBE9tBQfiz7nZd6CDb8Is5
	5TvLMmjRlKkcEMDzF28ir6sqZoeq0OMHuz9KuPObgL7EgJdNaIzAASoNw793oz96khlZdM
	VpZBTIyZtneB81ZDwjMli7nczc2mPaI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AngTpMas;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789913614;
	b=FNBdYXLlQeuhhcP8U1wGc8yeV6+XicjcR7duSef3di+9J8KhlWHPwGBunQTprRORxO4XKN
	PNHFETWhmGBWnETrJrH5XN1QV5V/J2v0uusjrcbjPUfMa9eYVj6PUPfBM37SPTIY+vTSmj
	sF3rOCroGAgVHIjMtQCPhfyYHgyb97o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 761F9601F0;
	Sun, 20 Sep 2026 14:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BECF1F000FF;
	Sun, 20 Sep 2026 14:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789913613;
	bh=A5dVatuJb8nLIceYIpRqrGfNVuiP4W5dL3y+DyE7U2Q=;
	h=From:Subject:Date:To:Cc;
	b=AngTpMasXlSp6bp26zJSCHmpf2pJfGNPOQSHmrAamM2Fnn3S7iq94uM3opNjpcTqj
	 YXrm/Pv3IrE9iWImSYOFv+rekOfHwmChKJvD3uVuOgkCT9BfIhiegOyS+sAqLdMlTj
	 9JUTW/WhduGPicSKAPloP7z2iqRWwZtiMkPSpj+b7lCoK1JDqB33tpgpAfEtHJVJB5
	 Y9Y9lsrUpV50t1ix7PgLAPmt+6W78uuVVMnJ2hh5z/HRDUG2BBg0IBTPWbbPyphYjf
	 WQyrhfXhUp+qzbM1bZlYCes4kRAa2cIGAx3FN2yP3iPcwd10MZGqPC/IkQLokoExv1
	 fSWaxha0cV8yw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 0/2] mm/mremap: fix two issues with MREMAP_DONTUNMAP
Date: Sun, 20 Sep 2026 15:13:09 +0100
Message-Id: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2NQQqDQAxFryJZNzAOatWrFBepE9uAjkNGpSDe3
 dDlg//+OyGzCmfoixOUD8myRoPyUcD4pfhhlGAM3vnGdd7hJD8Ma9z2uFDCRLoJzZh5nnBhtf2
 zoq59l6Gmpga7Scrm/BOv4bpuBXda73IAAAA=
X-Change-ID: 20260920-fix-dontunmap-partial-self-merge-74a98b1d5a65
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
 Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2334; i=ljs@kernel.org;
 h=from:subject:message-id; bh=+YcSOEfVDCNh71cR2TvPJ/PfisjjjYVWPIECl69VL7E=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWv+Lkyo2M23mq3/meP/sjkZSvzXw3HcxvfAu4wXwrl
 MH4w46IjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExkdiojw8TMoBS5ik0Hp78S
 upi/pGF99p3cnk8qOzL73RWvNlu8MGL4799TIJzNcNjxA+viTzkpHy8d2OMg//XiBo59Els/XnJ
 XZAMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: cm14eykxuqxa4ukd8q76dyhs5gaqes7e
X-Rspamd-Queue-Id: 3A97B80003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789913614-467547
X-HE-Meta: U2FsdGVkX1/Rn0BEZcglsA2ddtxPb31M9XH/PJF3Gxe0DwSSV9GhFt/roNZG5GMptrVJF7s0DvSstlrGB+LrLMgg18rKaSm2z8EAxmtLjqxDUZui8YiCqc72bFB0i5Q7xfotaYY1EL0Vvo+kCNNicLGF+11XvuZgk4lcFVc5wInPuxibZ//RFEHfGHD9HTfa/JDiG6Ip1QJqE0iR6T8tKGuqOkgUv9zRmebBRDfrrQEzBJzlBdE3YxhjM6h3BYouW3sLber+T4PAA1iERZpXcYrsJScao8sfjj+GwTPNcIX2Tpb2y0ZStCUuVKeT2vCaIlPGG6MUQIhc76cIx/8ilSaz28oOUuv4WIv0jNT6ac2Lu7L5hAHvon87m3EFqrCNK3h8hCJbfWnS+wmBcHunpzzGW9124VMFIFHIHjdJsl+Jj84NKU9p1WkgbkSMMN8MjOxbyXkRW0kO7ZC/8XoWBPKgaGPfULTF4OTahRAGo18hMY31F4gguoS3iVGyRPCwBd4xHvd5sQbpGTYDsMuOy/Xz8LoGacDNiOofX4Sjaz9sMRo7XubOi2JtiZyROFNRVga+KtSF+pvTkcinrrBZ4khWGob/v7pPnhBXXNm2/VyD1QR81e/s0xkLUpLULWrXdoY2nSxpvW17/29s6qvK9mbRKSlngV0/k4IK27vFU+mNQKUUilBiUGERPA7ci0oDCLumo5g/sAvS0uez2MASrh9kacoaYmdD10KueJkNKYRXbdxEuLWff+0AmsAr4h3k3Vz+05NJXCG/YnWh1UBOBPYFwye+MRDUVIJitNivlfJWkMa+MQXiyWtpwsqKjpxuD4ZGR23EAPgz+tX7JcwWNpmCWXdKUNQ572FLy8b0SGyOtdGXN3fRMvW5qTnvXXrcgjB5Aj6E/zgJZS0Ocj4qGStGH/97WPoHEXVYLipAL5XmmXUfiY6+EMN9S5cli6/4mFu52kPQgbsizqqM25W
 AubWS2Hg
 kZmVTsc6qUCv6JnIX4gd4ORBeDNOY2YHHIBPQ6Qmu/+eD9l1OiCP9mBhFvkh9VdLzS4PNFB7eTvVwSQo/GMjl9RbeKqvl5xElHwhOv8GLrkGYA9aHPvgNiBm8xVYrglAH1yCR0qTv/0JtGJfhZ885wd4kxOWFP6jf551iLMQRSWyCC6ZFR2Y+l18GLId/KXugPd8lSx34zngdMam31XfiVwIVhnvSIwyGy4k3yTakIGZe62IxWp7UPxmqsgCAx+irVpq1aCjYa8t4Uv+rqJEwYS1141SF/Mg2+cf7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
operations that keep the original VMA in place.

Historically this has led to a lot of bugs where non-obvious interactions
occur between existing mremap() operations and the original VMA.

Commit 397432cab17b ("mm/mremap: account mm->locked_vm correctly for
MREMAP_DONTUNMAP") fixed an accidentally introduced bug around
mm->locked_vm accounting, but this wasn't the only issue.

And thus history repeats itself, as it turns out that mm->locked_vm
accounting is broken by MREMAP_DONTUNMAP yet again by two further cases,
and has been broken ever since the feature was introduced.

Both relate to the fact that VMA_LOCKED_BIT is cleared on the source
VMA (it has to be as all page tables are moved):

1. If an unfaulted VMA_LOCKONFAULT_BIT anonymous VMA self-merges it
   clears the VMA_LOCKED_BIT flag and permanently leaks mm->locked_vm
   pages.

2. If a partial mremap() is performed on a locked VMA there is a leak equal
   to the number of pages not copied.

(Both for MREMAP_DONTUNMAP operations only)

Both issues can be fixed by treating the source range as distinct from the
destination range, which is the definition of what MREMAP_DONTUNMAP does so
is appropriate.

In case 1, simply disallow the self-merge, keeping adjacent source and
destination VMAs distinct.

In case 2, split the source range ahead of time, so accounting is always
correct.

Both changes were tested locally and confirmed to fix the issues.

For the purposes of a backport, the fixes are kept distinct, a follow-up
series can add self-tests.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Lorenzo Stoakes (ARM) (2):
      mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge
      mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP

 mm/mremap.c                   | 87 +++++++++++++++++++++++++++----------------
 mm/vma.c                      | 19 +++++++++-
 mm/vma.h                      |  7 +++-
 tools/testing/vma/tests/vma.c | 10 ++---
 4 files changed, 83 insertions(+), 40 deletions(-)
---
base-commit: a3d0117e02bfa1c3bb6c50e7afe42bbecdbb3459
change-id: 20260920-fix-dontunmap-partial-self-merge-74a98b1d5a65

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


