Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFE02CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 17:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDAAA8E00FB; Thu, 18 Sep 2025 13:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8C518E00F6; Thu, 18 Sep 2025 13:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79B28E00FB; Thu, 18 Sep 2025 13:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C65098E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:06:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D47C1602E8
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:06:24 +0000 (UTC)
X-FDA: 83902999488.15.445FB42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id E648180011
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:06:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kddnwzKm;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758215183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4iHmfrOjVqxS1nY8KBbXzE3KCvY6iS5HCykfgrG+OMA=;
	b=DTjVVX+3Bk2Oh/fbzNFOIxqv6QMcJSv9EFKQ5Xe4cnEDrHdueBrlST/MXaW+k7imVKURiA
	pgFt+/CI2eUW9wQCzhQwtd6yyU+IN6+bg7yhwVMqBQzNGUxWWpehZYmM7Amo4YK+XK2WGh
	j0Yy/O27heiEqxhjyV8T0URjTtCLpu4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kddnwzKm;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758215183; a=rsa-sha256;
	cv=none;
	b=1ZposgDeGHQjj5Q8oKtTS1ljcrt5A4inShMqrrWYzwnTFur+xQmj7Q0PqXC5YrRa9nc/Di
	l6oYgybHqwtJgbMtosJ9IYOFIr8w/MB5vIjlctTdn40QlKR/gP8OS6HrOWkdbRc0Kzbnqy
	oH22SU++IRqdBaMOEZOV2qYM0N882zA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 87F234329D;
	Thu, 18 Sep 2025 17:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB2EC4CEE7;
	Thu, 18 Sep 2025 17:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758215181;
	bh=HucGv7/mPLt2Tx4zSzeFM4REnUTmnwAtJbV9JCXao8E=;
	h=From:To:Cc:Subject:Date:From;
	b=kddnwzKmWI6C4Iu4GwObwD7eXUpHqQYaFf7UiiYU4177NZNU04zwGvlNXcj+sq5X3
	 uA7hgyoOmSazGv3banrkOt/qWABfc7CLpjL/7U347ksm1J7Ud28eJBOwjRf5eatN9y
	 7wJaZCFymw0VBIn/f+SyZFIIc/MTsxN41PtvW9iY9H8LEgkHjxdkGcj66K6IPyjLRx
	 HbWRLZlb1MIzKWrSWDZnw2deKMmyfjgXNMNH+rIKt8LBbyJYTnPiKcii6GrH6/qAJE
	 SP18i3039/LM6CD6gCk+g1VHd6vYur7zsOcnTX1m8ZszHjw5f4D9Not7u7Z3sFRbR9
	 D75747c3a/Rqg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH] kho: only fill kimage if KHO is finalized
Date: Thu, 18 Sep 2025 19:06:15 +0200
Message-ID: <20250918170617.91413-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gs4ceeeobeow9h3fk3safey1hxgpi987
X-Rspam-User: 
X-Rspamd-Queue-Id: E648180011
X-Rspamd-Server: rspam04
X-HE-Tag: 1758215182-354231
X-HE-Meta: U2FsdGVkX19fZyPsHutLGbRoDBQ8mWvS0pF8pte4DufjV1UVZHi6rorLoOD0KDoS6ftOyzRsk98A02bRUhH8ehnfIqD3tR14jURsk9kwC3PF/fgJzokA548/wTeqAViNDGsyfGI0ON6hrGcPTYpKa+a/d2c8giwxAAlS7tpuViAYf3LvcdWh4sdesnT49jaeOr9OVDGrh4ldBwFHZDd3lyfhBnnX4+0shYeC1I7lQltlMDrVJI4rjYeAViO7uwE4Fgq8lzDtYVQw3dCaTFprMNy1D81g0qFGQHh/BkDw3kewAtv2dWE/r73LEmlCXHRNG0uEsrGL8mGOPf9h01GrWnzsVyBAJcG/8GHCk88PiKo9jE/2BGk5E0i9FBodQi0VMb3eMo0TuF4MCtyQi99y0ZiUrlsmQjh5rp/hb+2UwXOr1ORp4Xcsriaw9sHHkssTpFM+OjoS8eZIp8ajUv/WRMjysJIdn+0a/Htg7sq9Mq6ix4lYFd/wYW+ApLm0AAhRVJ/PZ/VJ/DY/iqwGlmsrGvoV0KLlOFh/V3k9l+W7KH0WDFHOwgp36+5ZtNCt0pAqfbhMynPyRa5IJm0VJr2jAlAptUlBOHY78UR5lGn/luLMJpt+4bROEAdqhbIFvj9FD2WvRrrprO1KH0p/8l/AGVHVb8XpTaLxuXauvHox3krqLzNXzXUR++uRM9PR8/9uZ5u2Q4uC+8tzfAXknmuOT2RNA/vtW7uw1a6gOcd3C5GHJvgf/6ACicXnQxK6lDjpkai1KUqXSywXVFgCpCWuimMWcDARk5phmugzyuHo+vuVIABCL16fV30xIK/6oSQRSiaGf7fymV4aAlvxT/+G2yWRWw/S7uhQXMF/Dlr5krz0phiTQ48CjXKIlBq4vYXQtgjPu6ReRYO4QseAwQ0u7vH5HMR1/yOuo1CvWovtYBsWzkFDwQbM1HP8SojMJrQxUKcazD21wkiDuhxn/R8
 HIpA+rw3
 pLoq5X6K6xrNKIPTmX0nZYiLNX4TCGfzvJhHRUo0COoPD50b7sTrtUXVXtLw/iAjSzAzRAkWTgDJIUmNagJu8Y72w8cdLnFMIzeyfRg0tk0slYuVX81Za6KKJJCWXif47Ga3K8sC9sqX57v+NwYbcmz2f3BFJDjm7QmFLNeAvFfb8EGLFWtk7CwufZVBTQcLAVqeDAZNMHOdKap/E+j4jMJ2UUB40sVgW3MVFeCsWSfTFw6A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kho_fill_kimage() only checks for KHO being enabled before filling in
the FDT to the image. KHO being enabled does not mean that the kernel
has data to hand over. That happens when KHO is finalized.

When a kexec is done with KHO enabled but not finalized, the FDT page is
allocated but not initialized. FDT initialization happens after
finalize. This means the KHO segment is filled in but the FDT contains
garbage data.

This leads to the below error messages in the next kernel:

    [    0.000000] KHO: setup: handover FDT (0x10116b000) is invalid: -9
    [    0.000000] KHO: disabling KHO revival: -22

There is no problem in practice, and the next kernel boots and works
fine. But this still leads to misleading error messages and garbage
being handed over.

Only fill in KHO segment when KHO is finalized. When KHO is not enabled,
the debugfs interface is not created and there is no way to finalize it
anyway. So the check for kho_enable is not needed, and kho_out.finalize
alone is enough.

Fixes: 3bdecc3c93f9f ("kexec: add KHO support to kexec file loads")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 8079fc4b9189..5ff959a90165 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1242,7 +1242,7 @@ int kho_fill_kimage(struct kimage *image)
 	int err = 0;
 	struct kexec_buf scratch;
 
-	if (!kho_enable)
+	if (!kho_out.finalized)
 		return 0;
 
 	image->kho.fdt = page_to_phys(kho_out.ser.fdt);
-- 
2.47.3


