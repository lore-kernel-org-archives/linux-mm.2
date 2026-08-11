Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74768C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB07A6B0099; Tue, 11 Aug 2026 10:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88A46B009B; Tue, 11 Aug 2026 10:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9E6A6B009D; Tue, 11 Aug 2026 10:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75D306B0099
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:12:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73829C041F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:12:52 +0000 (UTC)
X-FDA: 85089179784.21.13C2588
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id A498280017
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:12:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lSFsYPlg;
	spf=pass (imf30.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786457570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ah0y0gDveI06pCiQf0Bv3vLT+VZq6BOea0NjGFqGqkY=;
	b=jnRETDhJufKwHkgDAYMU9lD0wv2vk3uRt+wappnvs2aCIl4XsiojUf/6JbEC8z+uOMRos3
	F6jN5Q0drtNkyrlN0p8/yr5XOvUpSc27sXu4v7sFihP2Vavd8iFtn0Swqpm9kJs82T/tpo
	On5VMgLHDfVM1R66k96/xwc1teTVeNA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786457570;
	b=TrsvFj9wV4sBlzcwPbvQHFGU87GCuSxCyOm3NS6da0fGLoWSuKejdGbeKSrXDY9XTfXCmW
	7ZQzW6RT5ahMzq0XLYwQDyE9AZKcoGUDlwqEC5NyIJXxBrZ8UKkUlzhQ9j87dfgC5mX+7i
	pmVO79fsRF+aMwwp9+JuT0pbRyfU2FI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lSFsYPlg;
	spf=pass (imf30.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4980dc26022so33094015e9.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786457569; x=1787062369; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ah0y0gDveI06pCiQf0Bv3vLT+VZq6BOea0NjGFqGqkY=;
        b=lSFsYPlgw42qjQwG0+tykAhtYoRJnPjHnJ9G4WJ2aibZ9FMMqLpSkSndhcg2qjNqHM
         tJRTO5lUjU8Jl/4wGbqjQLy940/yK7r8LBVGL2CGCTx7D2r5Da4ThA8ba62ewpqR+GYy
         /sVYbBk/CblyyYYxXFFZL0PDMjOlD7wyaIlK7HzNDZiFo/u/1TB2XwobgDYTP11ox5g3
         lWdOD3X94dO/MabaBu0zsIskNfppHNyMNtaut4Q2qYJDqNGgTBjSmqQu6cPnn+ah/ll0
         zCfeEDpm+NybhzfQXU066qf8I8R1xQGsp6Shi5k27yOhKYfkCsLfkKgu87gmGaiFy/oA
         JXqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786457569; x=1787062369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ah0y0gDveI06pCiQf0Bv3vLT+VZq6BOea0NjGFqGqkY=;
        b=C04xnqAipUQxA7p7nxyxWL0LBE3I9oEXsNqW0stVJgxjDnhWgjMuYCBAokzlsSDjc1
         O/9S7E4dYgSxFABy/k+l1L4U1PWmTrZOfj2TUs8dhSmccGEqVPsoT9Rw31RP6rCaK5Ev
         VDOiccFg9sEMyh85SdoM5XrQq3u1Cx4i+e9KQgbBsp3WyaCVOWELfupnj/TSWS1b2z1l
         jUWACRfnsHkDUObVPMBX703FlGVaSvaG8irWovHPQQb1enRsEIKcy02m8zq2uNFqVcII
         oDGD2gAAxKsu3JjHCEPMpnzd4lNKo93crPvfhn7sGR58lElvi0E3jcil/GxUE4APC/Z0
         DI0g==
X-Forwarded-Encrypted: i=1; AHgh+Rr8C0vAODvKgolFmDehA8vIR2BQ+Z/Dov3CL6bwefhO7kLqR68EID9eu+mhaOGvK4pYRBUCzQ9CxQ==@kvack.org
X-Gm-Message-State: AOJu0YyscE6ie0a0STJF3kNQS+gb0bXLF07aNGdj33CMFMccHiNWvEpN
	AeslE9BbJlMOMTpVWBDIsNIbGs9Dnugo+hOgfO/i0J6YNZ28eErKwbtX
X-Gm-Gg: AR+sD13h1q13YTGFxV1e0/ymyl0LOB/LXa5PQKdgWrGB+6K7dcMjfiOXRUzmJaRSzcV
	mpoDCvgjN5SF6WcfCX66ec85bAo36+zMg7pU47iBI21tpPPlhOWsNkad6Nqrwl8YMXQwO3Cu5qd
	WpPv20Gu8lbImlsgKu7dOSV8R/txCCyeokHhFvXE3DP72cQ/9kdpg2iUfoWYoiZlDL4eYzpdwVg
	psVArvJcUsOmhjNB34SX2KA3k+BSmXqB2EKcPTP/xe+MTeAT2HLDlKhJnGSxxKmPCichy46LJrf
	HLWOcsd6xKWkdk+qlAPTPPuloLoHYl+ELFyujGY/hX8qHGtRei/pk0Zms+eOvBtWC5zA59AWXbQ
	QsR4ytksOUZjuaCobKrlw7b5f2mZT3FbycR8lKrd4WGcx8xl1gUWZg6bwojoJmJYULYBCQgT3H6
	cTLSdq4UyNzvB1e53vvl3Uo6ikVgvCxE7mJfI8mpiK1U1+oQ4CLQ3isl2TU40r2OYMHUMOS3WaI
	bIfw/xeCgqke53G4kE24DVDO5GzGxeLQ5cNOBi6hkgMAvASDxXBDqdGXU6jDVlIc5FihbcxlT0t
	9o5naWTKLNzH9BW7HteXMsyddZjJDjfEC0lmyM40E97+s6Bdn8vQy86k6pD2g689G6xgpA==
X-Received: by 2002:a05:600c:3103:b0:495:737a:7afe with SMTP id 5b1f17b1804b1-4997846c317mr57654805e9.15.1786457568853;
        Tue, 11 Aug 2026 07:12:48 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a133-e401-bc8e-d36c-2d08-c5e0.310.pool.telefonica.de. [2a02:3100:a133:e401:bc8e:d36c:2d08:c5e0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a5be29fsm4464099f8f.12.2026.08.11.07.12.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 11 Aug 2026 07:12:48 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v2 2/3] slab: check for ZERO_SIZE_PTR by exact match
Date: Tue, 11 Aug 2026 16:12:39 +0200
Message-Id: <20260811141240.62519-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260811141240.62519-1-kmehltretter@gmail.com>
References: <20260811141240.62519-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A498280017
X-Stat-Signature: 57unafapuy4ow9qnphnq1q4stxywwiz5
X-HE-Tag: 1786457570-676048
X-HE-Meta: U2FsdGVkX1/cTzOTVoYLX1H1TR4J3rC0wSafXjwKXMkmmRumpsSpe8WDFoyBPRwpGEVo7LXw+z4/bXLCUyQuvvAuUEgUp5Kq7RP5Qw4TRkscopddAFcoaVi2I1FDUik9oWEvpcYAn8PuYqOTi0DjSEQ4ldiK0E5mLHTlwBh6cQ4qloEf/BG50SmA8HlnfiyedH3D/tN/fmAShazgmNnkv01FEL7bvM+62fIdk1rYfIiQ8oB7eypF66XDL5H50wiISOItSgxvCxI867hl5GORkmCMIWGYi4GJOXHytcrHdRZajFRJX2QYsAm2/BOaqoi5QhCPdwJe2VzfRkMMNf04lP6wvBgYc+fN2mVJuF2eCb1O+iZ7El6r1edASzLyYiswpWYxGCK+96oa8p+/3E3LLQqXO7xVc4YrHMW/KnYbAuoXWayvWLKxON6tbyGnE1xXPdxPPfCDP2+hJagexJI1yT2WpSQ3tdTiezZYIQEEfPk/unEuZS8Gk4sSb16GgYKhIfs/gwFsxTjvsmVW4cpn77nWFVn8WoHRH/OTPVpSbaC0CxVU+86W4tVAWqZQa5PH4Bv8l1YT60CHh1bFUVk5N8iNs7Di4aAQeIfa11tEa3Uo02CH5igW+bJsEU1KkuxTQ9+LPAunGVSnN4zJ4V/nCXdvPsXB7uZfja2nilrOgBI+TIqjl7RSLiDaRTY30294n1WjCtH6s3Id60KNlOnCK5pZXgPuD+zAdGeT7GIcvhX1cDmkSYA+GGY+/tzysHFaxuWFgs2Ef+UJIegYOAuwyAGONY7/nh9Q5debhcNGzx4fFulVfhfgj03t5WBFsEXNsnNy3cusYGd/FGgf1VEV4Y4OuOrS6nIba1mKSssd0d9KoTm0hSLmnLDLlJ8eKEjUO/FBvAa9pIKhGzxygzYitj6yAT2rdSXWm76NpOjX5ZnrWo97Ff5dp/F6Lyeh1PIodGVeuJuqSOFxwAaEP6y
 x+w67Oli
 F2SVmxHZrS440m/2iE9nE4YWF6wa+Jsdkm/aA674d0TQ7eUhTkCiFa6XRq7QRoi01C3pCRBZTLnq2dNeyL7SGoHbvMRVUo76Z80HzF14K8RlZ//cluuRAP/59WnEmmnCwK3O1vAyIXqUia1cdUlQEvevz5uPTuLr3yT9RLx/knjFf+2ubCT/u24c2axW8SjZ6WfLC0p1z09NQSTFzXKqO9cQpwOyXYVg+0psHDvP9pAlh5yMNY6h92VM+NiYYojF9fpHmOm3wq5Z42PzknczgRqTau+6E/juxdx8h4hQGPwDWQPkdM+nYOUfbIAghYZeuBdmJq0X/FbCncmWIbwTz7WEErnu1jvmGdNPDGIIS2TrWVApeR0E5zVU81X3JGISNcF4TsEJdVTZVwTrDbz/G7MooGJuOeV11IFM7ypYs+GagEshX06XwjzEPY+fQJkJODgAS6OXE8Foyh/exDE/Hs42o2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ZERO_OR_NULL_PTR() returns true for every value less than or equal to
ZERO_SIZE_PTR. With the sentinel raised to ARCH_KMALLOC_MINALIGN, up
to 128 on some architectures, the helper matches additional values
that are neither NULL nor the sentinel.

Compare explicitly against NULL and ZERO_SIZE_PTR. Store the argument
in an unsigned long temporary to support both pointer and integer
address arguments while evaluating it only once.

This also changes check_bogus_address() in hardened usercopy: nonzero
addresses below ZERO_SIZE_PTR no longer cause its null-address abort.

Apart from hardened usercopy, direct in-tree users apply the helper
to allocation results or explicit sentinel values.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 include/linux/slab.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 3e012cc4f001e..023e10ab77f8d 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -270,8 +270,12 @@ enum _slab_flag_bits {
 #define ZERO_SIZE_PTR ((void *)(ARCH_KMALLOC_MINALIGN > 16 ? \
 				ARCH_KMALLOC_MINALIGN : 16))
 
-#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
-				(unsigned long)ZERO_SIZE_PTR)
+#define ZERO_OR_NULL_PTR(x)						\
+({									\
+	unsigned long __zon_ptr = (unsigned long)(x);			\
+	__zon_ptr == 0 ||						\
+	__zon_ptr == (unsigned long)ZERO_SIZE_PTR;			\
+})
 
 #include <linux/kasan.h>
 
-- 
2.53.0


