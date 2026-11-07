Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0B46084F75
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aShcBXa0
Received: by kanga.kvack.org (Postfix)
	id DEEA86B05C6; Fri,  6 Nov 2026 19:37:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8696B05C8; Fri,  6 Nov 2026 19:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDDEE6B05C6; Fri,  6 Nov 2026 19:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F96F6B05C7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 18D0680269
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:08 +0000 (UTC)
X-FDA: 85406458536.21.3E8F14D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0FF01160003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aShcBXa0;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011826;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nw+7gH6TQyDm++SEtaBJ9qTZjP0IXilw6YZGdfy/+5c=;
	b=4bzu+tG04CMQrw+u0qL92AaP/MBQfjIyfDgweJNVEo8zhHjcvEmE2T2V448dMKhW6qboJ5
	L0jvgojS4nRybyTl/E3iTm9O4mmKLke6ALI2v66dprBhQqiC++yeBZO8G7Bi0mwSkGJt3x
	fKT4gFg53nnBfhkNH4nolQLKmlg/4Ug=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011826;
	b=oS699GVT/eGVD4YZ5s8+ce0ZhDwOwLo4l2IJjcXh2hzdpVRQVDLGNMM1R6vbJWYpDVCFja
	WtZK1C9M51MNsPw4vkTFW35Bo37EIGJgrwG+y8XpK5wbY9UbS1baCY/sCf1JWJjRJ/GDoM
	efxT0671E7FuRH19IEKIdz5/KJvrOfU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aShcBXa0;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 975E860E24;
	Sat,  7 Nov 2026 00:37:05 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011825;
	b=G3e7bbwIKSigAnvmAE3ySxyTekfUL94FMcE79ekSs9Sd1Bb3+rTxYqQ6EH7YB5G+zeeC
	 nimu+aS47yNcQhzRy0sw9pc7Za2hrSa7uMXl6le/R0VOFuaSPW3V4hNi2e+bwIKIRv0AU
	 eFsBHb+DdSgfZJlVWanWYJYjX2aqvdgd90gFLjy1DiRUEawogWdQZS8T1n16Zj9/ddGLF
	 5CY3ndxO216oMA3cIs+Qwn+rsZ5aq4GX0sLuBN6mAflwpUloIhjtxSKJtbDO8VDM4b8dZ
	 NGje3FpYinNeTMuRthJWiK0SCigq6M9IXq/x9IW3BOEzTi+9/1l6JAe0fYiLlcF1F6w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011825;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Nw+7gH6TQyDm++SEtaBJ9qTZjP0IXilw6YZGdfy/+5c=;
	b=PGjf+K+Y5dYZyq1RC+f01aFmITwhGZ+5JA2stxPJV2xkAVZfjFFkOQ9oo3Rf5qq4ioqJ
	 YJCvY6/Z4G0/lVU4SKynmF5CB+2/MOmIe/md3X4MlJZRgNzwp06DbYqMqISXE9VZjQJ1P
	 zOGj87IHpdPRgv/rt6Ha0OwiVo5O5Vht4VWJ3nzDLIVXEHUNYBZCULsU49AmmiLz74iiX
	 mdUw/QEU0GDg7lki6INGinAVtDryYPfd1n4ZzP0lnciSBZ9+DqBwHm1nC8mWQgTPxLlvH
	 CyAvlz3WyCggtaeWko4vKlSy2Jf0rDsDF1zp641/baBPlas/3rr3PK05B+NuxaiG2eg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8BD031F00A04;
	Sat,  7 Nov 2026 00:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011825;
	bh=Nw+7gH6TQyDm++SEtaBJ9qTZjP0IXilw6YZGdfy/+5c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=aShcBXa0Mol8YafWuNQV7fdFIYFdp7mdpO5ytD+MtPYWHeB+z5LLAFIMlnhdac+mi
	 pCPWjCmvMyyr6Z/wn6hc59Tb4xzLOJZJVjItFi7BvKyX32l+nXGaWr3o/QF/v2Xu41
	 ACDFYMtx52xLwQVGDMALGdZL9JhAcnjQJFt02PhQLtrINhBaVt4/QqPlgs2J0fP1G8
	 QaCf0rdxzyMvElPICGhEs9KaazSw8jfk7nH26Cn9JwQ5tdQkO1OVLs6JwGIruIpkcO
	 pMNMQt3nzTxITUOVq8fudBjn+iQjHWyEFZVwM0FXZSWSLjT/plVjdy/GhRkZYZl8DW
	 tjYsxBOsAkWLg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 886E1479A9;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:12 -0800
Subject: [PATCH RFC v3 38/88] KVM: guest_memfd: Support arch reclaim on
 inode destruction in PFN mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-38-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=1330;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=TXq1Q9jBI24peVbPvjCPNkLRxMY1K4Ef0Snx4+ixQ0k=;
 b=NZ3n/EAMYCRX+fSqoFNACF15ZIxG3Bi/dLX6qBEDTgTqkaUaK6OzCVw0u+02oNBki4B329uiy
 2o4HzhyKxyYDdZSUnNDup6ShAhNskz8gXyW1Q2hAjUX3tFCGmC2x4V5
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: zcgjguf71rwsa8wtjfitjkeozc1taokh
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0FF01160003
X-Rspam-User: 
X-HE-Tag: 1794011825-816846
X-HE-Meta: U2FsdGVkX1/w2erYoKHdtRAmcYC9nehi0/OCMjaJdaXZE79dQcwFWRSjW4uAqFmGP26bJ1sBlV5bBBvUcnpMjrMeMYVAeTLL8d6KdHzUKwbLpT4p2UpDqEwSPs31dJWfHLUwDaa4Xs0rbD3gY04F25Es35WIIPIdU63UdS6uvgnCBNO6QgWVvffAiQb77Esl9p3EAvSCtaaBhLT5TSL8TRzgmVb8rqCi64r675yMx0yHhHhniD7lTJEXrS3Dd1RNQ90wNSmlHfve1O8Hi526KZfX+iZhwBQQKYFALxHlWOJjQ1lQAoryln4cuMiPRaO/8TDtUXwOz3/50oUU+B0G2/uNZ6kpKHINSzHiOgBmkf/KQZSuUF1FPqmlSLk4ShY661Jw6Rjwcd5ri3wcz8uAQnOT6ss626RRm5ItVRL6sSMlvcHol0m5wYEUZjw/LjGrbdxroFyeC9qKScpFhnR0EdoDb7iDu8jSTZvyh0TKOahcDspL/Nxa7G3midKK02cZ9XcBoXT6vopslUCfo7DuVuQQ3MbnlAidY0WuHY4cOVbHlXS5uUVD5Z6Zg9ZOmN5wX6OV5lVgIz5EYK+h6SCMgxAl52jV7uffo1fWL9JCh2mEbWDmTlbjYiJWNj6ZBeFDF0WT8gicsJOxW9tSOjOkWxMTrRUuf1MWPR1MvkwSZe+NEF1gUy2EksEC6LUZ8tNgEHjSuEdQu1FBR+Ywx0EcraR4g2yYCkUo/m9SClNnha7Lb6Dnu5V7N3mojpWyypWba5PJXw0bv55dcFDrbqT83Y88Svw13jHa6GQA284yjR2fx6mPgI35COwhYGzsTXDVVAJRBHyFlip5mdwzrcrwYyRftCCHz7B7JDdNoWWKrr0i8JmWrcm9TxFlu0ZzIDCxOoRGb96h7fsl0OXYWhQnQK9h1e0cWGjk6N0lcrT+QWSn3yLlcibYlgvirRQWv+PsMhPbVmuZRA5x8YwDRdN
 hn/AyYOK
 aikGQ1kCDfVM2YYRYNdbYFX5IBKO2z2uhfEFII8+jJGj9ldm+eXFSvSk0MGM8emKRbS8F53nsvYLrOvT5FNRcpEQox4E0tuVyqy3HCfTqGOfC5y6eyg8VgSehzFCoVeseo+1qrK2jNNTEYSUEbZIvimRxjN/uf9XTCnj0Ebywb5l0tycKFuXmaFD1Z6LYjdzASsq6HYfsfZByuPwmvHpUBr5Ra9X+Frb5ZzU2ZaK6hpMMMgHOTSQCbvGFc/HMXcLVf9pFRqyyMrUEXpwbOL/kO0TPnDfPiF4zW0HvqBSgxTAioMS2wJPCN8UFxvL3jVSYUmck1hf+eiNaENFXUNaeupaVyyX3Trk2IGSHTpB6sdvXI4ylP1Ksb8ObiBsieOjJlV9CjB15NX3RtbeO9i/le7SBMVrrsNQQeV/pdZBYU4SGV31iZYVSEGIAA09uPb2OeCVQseCcr5riPhiS2GHkObTkP8GJSx2YJ/LVAMJSLl7GQ+sU0PWWBoRZh0yGKJhAvV8Mh/Ffw3TLP1IbEaW+ThAk3FSE2i8engvS1xcm3e2xhfKrtzWLvFCx/8oLz57CUVkdUlxqaE3YZY7XmGNBu5o/Q+9uT8ztOjIO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

In folio mode, folios truncated on inode destruction are reclaimed via
aops->free_folio (kvm_gmem_free_folio), calling kvm_arch_gmem_reclaim()
to reset hardware confidential VM state (e.g. SEV-SNP RMP entries).

In PFN mode, memory is not backed by page cache folios, so
kvm_gmem_free_folio() is never invoked.

Do the reclaim during kvm_gmem_destroy_inode() when in PFN mode across the
entire file range, ensuring that any confidential architecture state on
provider PFNs is reclaimed before releasing the provider.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 567735a564c7a..b46907b480138 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1726,6 +1726,13 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
 {
 	struct gmem_inode *gi = GMEM_I(inode);
 
+	/*
+	 * Skip if the provider was not yet set up, as iput() can reach this on
+	 * error paths before provider_ops is initialized.
+	 */
+	if (gi->provider_ops && kvm_gmem_is_pfn_mode(gi))
+		kvm_gmem_pfn_reclaim(gi, 0, i_size_read(inode) >> PAGE_SHIFT);
+
 	gmem_provider_release(gi);
 
 	mpol_free_shared_policy(&gi->policy);

-- 
2.56.0.455.g6c5a503b38-goog



