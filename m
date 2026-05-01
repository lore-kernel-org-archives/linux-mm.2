Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C8A4CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 14:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50746B008A; Fri,  1 May 2026 10:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A00B46B008C; Fri,  1 May 2026 10:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 916F56B0092; Fri,  1 May 2026 10:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 832EA6B008A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:54:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 36F8A1A0119
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:54:45 +0000 (UTC)
X-FDA: 84719147730.01.E94EFBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 90F074000F
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:54:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aCWpnuFT;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777647283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J7xH+x+ipxS6OQNkn0TXtoNXmQdV2fcMQAkSKAopFW0=;
	b=hA9iCy2Cy3Oo7G9NrpSL0RGF/3tYqEbgprbqBvz5oKpMgkGMazdMU3gwmWysthIpN5jHLN
	7C5o0rE7ZuWUjvw8LVGe9COcnkLDBg9e1qLXMUKuz3xBq00IaDJqfgcAsNfDJsumhvmTzI
	aRH7fyEdIOQt5HH6mP0xhhcUQt3Hc/k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aCWpnuFT;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777647283; a=rsa-sha256;
	cv=none;
	b=jq5DyO8WMyscemEQjpbEodaIcivwfu8/WBNVnxpZY3klV59HsfZPcqzhmYD8TgzVmZghey
	OTHRgxrTvYQmaSXrgP4h589KM0D0LZkEdEwz/QTI9uxnqcxQZZIxyBP9wfFAsGNNRvEBX9
	6+0Xladlbmxj/KgSp4RIOSHz1NtlR5Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 58D1D40C4F;
	Fri,  1 May 2026 14:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC207C2BCB4;
	Fri,  1 May 2026 14:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777647282;
	bh=sIdxJn2uWKCUgOB/jcXwOeB6VnuZjhcEA2rnh/yGasw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCWpnuFTXV3upoj4UjPdpW1McawbKlnlCFBEeLNisCH0zC9aWEqdLEdLMJKuQcw+n
	 bKBiKeo9aht3nZsrkK+rDHGoJzxDQPmcu12UOUCZIoWPKTH9WjcYywhpGlTbayCTe8
	 /tGF7q3lBktif4gkzAfQ+rYgdYJgizImzBILlUHRN0vfXeYsBSqEBLfo13RgnBAGrY
	 jSKK8ythzvY8zLjL4DxRRCKaA1RHIBV5XkKszVHtqNr/OQI01bbn3362NHvfMg1Scd
	 D0sAx3Jarg7VkGo3UTYZOjrTK6cimClDGb5e68fLG82Zq/ploz5vbriOdXTXGlJ7az
	 RlGxBVemjSjBg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/3] userfaultfd: ensure mremap_userfaultfd_fail() releases mmap_changing
Date: Fri,  1 May 2026 17:54:31 +0300
Message-ID: <20260501145433.156211-2-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501145433.156211-1-rppt@kernel.org>
References: <20260501145433.156211-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 90F074000F
X-Rspam-User: 
X-Stat-Signature: e9enazmj6x33wm8bn17wqr4sdy5sua59
X-HE-Tag: 1777647283-223477
X-HE-Meta: U2FsdGVkX18EbFteluNZgXT26wDCXh89mVXsNlvPaoLsLp0HbJRKc9DSpzU+LokvgZi6/cCfJKm8QVJ9BcqzNE3k2luduxRAB9pH/0VKLaEaDc3k1aLiZl6KQYMLqPypXAiDZxhVCa3rz3kqNbmRFiTeGNPfuEllu8vr4MXLLaSUzs6JRZKSKsnyzbKNuHWCchU/rPIwtNNIOliXlOp3kVTJ63jjIG0L6yHJv100SQjteXoiDH22gn7l1jOMtgjrx4BGBSRnGo3Zf5IBig4L05AmrWfSNAgXJrL9vDf25ICLpCmpsJ43l+1UFQIROaDYx2Q6uzTCXFhOFi3txAhV02rXQxtn8TIc/HUCy/nPhdp7PD8az/CNPFaR66qMmybrhO96RXIWHOALQFoQGJpP0UPCzfcR3I5gYlTuh8wBP96ebaEVULieKj/RpwF01VpRbADFsbK045P0ztvheREI1Alk9s4H16joTEbJQncDJOSkLQ8qskyEzvUOE78+I9rt2pQFbQPcZtWxBTR7onsuctPhQF2U4VVXwkatsYoi/z9caDeS1/aeHkN4ddcGxnph5TsG7/EmU5tkyi0hhd95L03FGqy2VrBF7CWVpvAySPxsVsHTwLU84/NZQnGYJDBEC9UJ8ZNnsNqdsJHG5ewNRpCU5eYC1wlkga+racNdIlubv3II6iuZFzJo/U3Rpz5CPokCnSz2sIQ5ERzn+e0+AXdiMT4xesUbXkt8rzvZfCf1Q98XhPJiadqseRMnvkvaozd9xrfMptSqej2ATBShRoRhsbXQdZu0DKLkPpUlrCJiWbLgsUGQorgGu3dRsunkjtY6Cy6ZwfGEF6u8GPpBITYuSeA45VDoyqsBbGHGk4C/FxFsFQoIzXCVxjQ5rNXNVBqtT/gs2g1H2V3waEBy4J8GE5x/ffEgg42qgEQwslVLu1WtnvogewrFF0A+/v5sZ+oKv3BfsZka7Eault1
 h5tRs104
 lSgGfSSR3bsrLbWFmal4nTZ+MiqlxSVTTblGe9MoIDmB5sMUyF01u45unFCE5V1l+HMoO8vgSxDgqP4hbGsbVguV6I7sTKl1hRhHi+maNTsYQv+K+djeKyKiYMhQmPoiRnghuxQeL08+zBHi0qvyCRjPpunNOc7tcicjGwK+/1c/aM6n2maywOMRJAMweelJb9P/Vu2Xk+TGyGIYJrbA5KUo7PZsIe69B0wmRo0m+fdt2ubM8e6vhsDkPUnwLWKDX1njilSLjLNvLLXICCYLPXuSS48xplIoJpkzvOSubQn2zazy6lJgyr+JP9QVyBb2dX7a/qlY+u/+Fw2v2MeN8LYVb+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Sashiko says:

  mremap_userfaultfd_prep() increments ctx->mmap_changing to stall
  concurrent operations, but mremap_userfaultfd_fail() does not
  decrement it before dropping the context reference.

If an mremap operation fails, ctx->mmap_changing remains elevated. This
will causes subsequent userfaultfd operations like a UFFDIO_COPY to fail
with -EAGAIN.

Decrement ctx->mmap_changing in mremap_userfaultfd_fail().

Link: https://sashiko.dev/#/patchset/20260430113512.115938-1-rppt@kernel.org
Fixes: df2cc96e7701 ("userfaultfd: prevent non-cooperative events vs mcopy_atomic races")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/userfaultfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 4b53dc4a3266..ef963a58f1a1 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -786,6 +786,7 @@ void mremap_userfaultfd_fail(struct vm_userfaultfd_ctx *vm_ctx)
 	if (!ctx)
 		return;
 
+	atomic_dec(&ctx->mmap_changing);
 	userfaultfd_ctx_put(ctx);
 }
 
-- 
2.53.0


