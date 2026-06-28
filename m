Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A083C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4F556B0096; Sun, 28 Jun 2026 18:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D067E6B00A0; Sun, 28 Jun 2026 18:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1EC56B0098; Sun, 28 Jun 2026 18:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 824436B008A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:08:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB7FB8E48A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:08:20 +0000 (UTC)
X-FDA: 84930710760.20.8D9C325
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6715E40008
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:08:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782684499;
	b=y8b/5emccFaA11JrGgp2MFBWe2GRAaOiI2tX9BTqpOIMzdfmGJuO4sPXw8iXFusKGNoau7
	3XiwnsJ7J+RRjp3DzT6hCgwMwmJDQjjyL8ozKUzEXMQtJNLRnEz4VFWhvpXHn4bpmlZhJO
	Tj5XE2pt0D24MW4074x6U8jY7Ms5t6c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782684499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=XTE6X0hh4M02Ok96d7LfImhxEcwrt4s0AFVrSZB8oBs=;
	b=C+6zPztwqTZ8oDiN7orQgnn0xvW2yTn6lnpVGizjmGvdeskA/qTF7oCxnZ+T9NPqeRv55D
	pXS/kF22htvPmZZ6bEpK4JtFyBYDFzR5p6oBuwVD+a+k5kUAMgiYviiZzikMHJ9BC1/AX9
	nSFxy5xgzjPXuY8DAK3NwKRZERTKozA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5269741926;
	Sun, 28 Jun 2026 22:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111101F000E9;
	Sun, 28 Jun 2026 22:08:18 +0000 (UTC)
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon: add kernel-doc comments for probes and rnd_state of damon_ctx
Date: Sun, 28 Jun 2026 15:08:02 -0700
Message-ID: <20260628220808.98931-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qgnydooguub4r5qri8m7iwxc95a9cwej
X-Rspamd-Queue-Id: 6715E40008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782684499-577142
X-HE-Meta: U2FsdGVkX19CZbTCd3nIwyyna+ZNpkkrX00iw6WeqzBMT1czX7rChFjIuiZq7vXQfo7mLtz1eVjWTfb9nG9IEoJNkXxfedB4OcQ1jy4yZtCMvJaTNkFtsl13h7qwFsQKt21aCWLAu143tPTggYU6sYqM6LaUrBwkCULETdQ80izL741AnxZTIAP5s9ZN8+AV995C+scWxa4Lw3i8oRIwrBtd41aQVPP5fGaMuIpvPxXOhOtTCT26Ok7hUtqoeVhdQ0uCMgMG7IMsbsKl5NA+V56wxyAky2xpIOL4Z/OSbXm6r6Owv7mhqajB0ho3FgTOThVl/VO76Pralq2otzvjlWNb+eaPa4QfIl3LzrSsZOA47GIVaH58x3OQxerh/MOxIKMvlVfmmEMHCvBwi/EHThjcnX25DDBBoxP4Y8nYuytxDT+Qt68ZDwYtSXAvlRDapVti7X1k88HuuH1rEeUm8Qi7eFqO7fjxq3xqMgpWmz8kirBPKDpN7BrGWCqw1h85SK9Q8oNWUaWbsNDoCE+IAdsIFTCYmjRkbtxcb6RoZ1HGTJ7UF/O4zO1MqjkTXZgHlt3imSz6HM7hCRMH3UsZlKhDMnFXb8VyLMkp+2QOFUhBQfh7xVPDGhP7DW4ofCCej+j+vmSCNG2zNoL+tS4COz/CgmRfzVo9zH1NF5pJSEPCyPjh6AveX8ueIe2uj36WDMkeVol59/pEX30nBKUAdP2rMHD4yAQhFnNLAVCM6NgW8eWafYoModTgiDXkOVCgGqo1QRS0fD3XB0abNdm12XAZF/aMAvDlpMIRiR2S+0CtVGc8QZ+qI5rDCJ+e2JAJBrP2hEFwhPG2uJQKdtlUH+Dx4qnVBMLcNdWtclhaNvnMfjQqkOWOPEvD2f/bYyZyU5QA2y+mhA56UgsgsoeWKv0MKCc2YfyMjYF58Q1pGlblVHiJvm4fPJ6FFPoLP68wQtZOyV6UHY4TRjizyKF
 ogJUnIQL
 sviv7vcbrpEZqPr/Mgiggr8mRhqU6h7HeluROnsShRtMiCEXOzFsibnUqupbyajM00yPiVR6TE1ss+mhy6yXDFzupal7zxoYu1VivydgicsRgvmkt1BhVvC7bFYTh2mS22P9nBqvesAfGC752cLH/kb0Gdg27EIrMUskB4PX4QBddQSRYXNNusXe4wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The two fields of damon_ctx struct don’t have their kernel-doc comments.
That causes kernel document builds to warn.  Fix those.

The broken commits are in the mm-stable tree.  As the issue is not
significant and the next merge window for 7.2 is expected to open today,
apparently it is too late to squash these fixes to the broken commits. I
hope these to be merged into 7.2 release after the merge window, so that
those don't bother stable@.

SJ Park (2):
  mm/damon: add a kernel-doc comment for damon_ctx->probes
  mm/damon: add a kernel-doc comment for damon_ctx->rnd_state

 include/linux/damon.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


base-commit: 7875263842e9465bb31d0dbbcbd899610dfe43b4
-- 
2.47.3

