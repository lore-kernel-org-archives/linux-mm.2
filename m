Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A53A6073623
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dH8ZXeaw
Received: by kanga.kvack.org (Postfix)
	id A3B146B00EF; Mon,  9 Nov 2026 11:02:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4516B05D4; Mon,  9 Nov 2026 11:02:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865B96B05D5; Mon,  9 Nov 2026 11:02:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3D06B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:02:22 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1E221406FA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:02:21 +0000 (UTC)
X-FDA: 85416047682.02.F254087
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0A9AF1C0021
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:02:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dH8ZXeaw;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240140;
	b=MAQzcI2eQhOtliZ4v1ThY+3fMl5QmZvxVW/Lq0JqJvRt6JzBHTSwI9XTZmpdclbZs2YaOx
	Knz6tUFVYY+YEWhPr7k+YptAcAOPpm92Rywsubru8PL4lG16DoefgwcyO8e5n29VDjykrn
	JXMHlTXd/WGXpxUt1Y8Qefdqrjdn3mo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dH8ZXeaw;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDt336sOLHXoyK1vJ5DHTHNJA3h4jiPSQ6EBbN6VPPU=;
	b=vkSJt7wnt8xN97SqWMXffhbJhAwNTCjS6AB8TKy1/jTVbsY9wizEjY2r/9+ip+qr8wlPhP
	ThwMib8sQ6eyJb0nJ+vQL6QoFG/gqLpZ5bcybcAvruzk5yJeF8/Bu/HF8HTYZXuEyglFZP
	fA9NevvN8HJiNjJgYjikHsyqR4hp5LU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23A1E1516;
	Mon,  9 Nov 2026 08:02:16 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 41B3D3F632;
	Mon,  9 Nov 2026 08:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240139; bh=NFQEFSsYO/fKnRgE7J5ZDxamR8/pZMozASGHFiXFzxE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dH8ZXeawxo9RYVWjKlz7VEpjb0FcZ2mBlznPXMI297grRoAkdMGTUFZAdtqQ2aB8C
	 QAT7+pPg38V9AmeqHCdZL7tGeQk0d6JEhmHFaveFPzheIA0+E5uC4CuyHsOAOiEjVj
	 FUXkCI059PuOzATmarafG9qY4ZXGvOFOmhN05d1E=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:45 +0000
Subject: [PATCH RFC v10 20/22] arm64: kpkeys: Enable
 kpkeys_hardened_pgtables support
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-20-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
In-Reply-To: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=759;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=NFQEFSsYO/fKnRgE7J5ZDxamR8/pZMozASGHFiXFzxE=;
 b=PIyC1APa/UtTe2vo0XydEUgKuIvFCyLXYBF/FwYrpD/9Sxq+MAqmcDszgEbt7wQGtA3IiadoY
 of5pIoerUJaBLMTbjWxhnozwdg5vsRjGujKle7TLPrIZ86KcBsAMXdB
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0A9AF1C0021
X-Stat-Signature: dgygydhty6ma6a5g4ump8sjrm58teqpp
X-Rspam-User: 
X-HE-Tag: 1794240139-399803
X-HE-Meta: U2FsdGVkX18ECanvXpwB+icmMWRN1kE7sqxqz77QAsfH+vDZmEPezZHzMcnhvE0kahbsOk1LZFOZfjWFC0gKG25S0iOALihXQWujFXx8o6rYk0KUnL28T8wieAMBG4YstvniO0fdqAioTlhQX0DZE8fwyUb4VJhAnsXtP0pTYpNfpJTqG5ld47y/+mXT6z0PzF/B+RYWLNaInsCQ3mjJGIkg8nUiFl4V52dQoIqGwRTAHdG1GiN91WGX0dW20gO4j5ZL9xtD3JSRjKxFBGjl79xKKoukZJihi554V75pS/ejP7KUGjvSd1hGNIJHeTZ9g/X9DH8NNOLmHy1IpTjsLcwtD2w0fWhal7Ce8Z1DrqEs8073slswNrdBLa/UV521pwWlUg8HBd14zArGuQ+OPkElsBkjWVt+AB+ae2ALZUp2/ys+5mijk/S3w1uywkdFTvQ6kDt7dMVdRJ3GI2KGLMgpJMGkzXBxch38R4AftW9cZI8hpsxT/+wxEkjbHeNtzDBn8xWgxorJ7KX+9s0k9TN/0biUutHdngveX5oM9AKngZ2kxP5ZA634u3jwLvOaSAOXDh8nivSjqzbFLPlQcRSfeffgdUg4FTEjcLkY276xrhRIVeEInNMpdANMz/1BBY8HNmhAmMGgRHNcgjJIYCFzTBBSyI1tALR3o1tmvZ7HMUq+TqwMa/vEq5C9k3U9hrcDN/32Li0JsBRNdU24CpYBHKn76yPWYmrsOSTo/cYBqp88M5eAooIaogzs+rOQzoQCyKnBePeO8vamZt1/dlPz1QFOi32QiCDeOi7uMSFHXW8rJMiHaSvR/muQGNy0A9bj1GtVuAjt4oV0Pi2YRdMCQSh29E0OGaIatD1L2wJScK55cxnF/pyZcjOAfFE4+X4/ptCgmFgyLy9Q9wFSqA26jWrqusF3KVEEdkgB/w4PAgpQKdvL3axTS/bjPvtzXYqraOx47fYX2LvlnD2
 CnJDP6if
 kzILdPPwcfEIzdkvVfkZDv2ASb/eymSNlymIAWXBttsh2xXVZ9QBGIeS/PYW/QwJy72TbgXEI/TPaQCIh4hnbAjye/89q2stHC5gXe1OJF0ScNWQbw9K9eHGUcTDAwOyG0svDhw3jUrbwl94Lf6SRHbB3riy2rAfayngO+nahPbT+2pZx2yur4wNr5ePUekVAfeKUN6tjtM7pJVwy5ociv3f66c51+1+4oSeVni4T08hccqzsG9lNVJ8atFLAEDyssAc014yPb2VIvKM6X9hk0xhhx8MQIwgnQXL0Z0xCn7lvTVEY2eUvNgoHk+1cyYEECVuZpTOqOpTqILJtLhpbSC+quQvcKPPPnfWqmLmF5xy9hrSMG/vjl/ktbjNJwddX103Hrl52zv9QWZe01ikFtehxHBDvP8mkye4G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

All the pieces are in place to advertise support for
kpkeys_hardened_pgtables. Do it by selecting
ARCH_HAS_KPKEYS_HARDENED_PGTABLES if ARM64_POE is enabled.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index f7e4ffbc07ac..28023dd0fd4b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2301,6 +2301,7 @@ config ARM64_POE
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_PKEYS
 	select ARCH_HAS_KPKEYS
+	select ARCH_HAS_KPKEYS_HARDENED_PGTABLES
 	help
 	  The Permission Overlay Extension is used to implement Memory
 	  Protection Keys. Memory Protection Keys provides a mechanism for

-- 
2.56.0


