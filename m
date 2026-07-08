Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74286C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 17:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66DAD6B0092; Wed,  8 Jul 2026 13:07:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E4E6B0093; Wed,  8 Jul 2026 13:07:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5341A6B0095; Wed,  8 Jul 2026 13:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20E746B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:07:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C8C6A020F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:07:05 +0000 (UTC)
X-FDA: 84966239610.07.5DDF20C
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id ED151180004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:07:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O2B+CmMR;
	spf=pass (imf06.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783530423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=amf9A3ny0stjzBNYa5xxQpkuKUHxHwl/QGUYuXrMddg=;
	b=rTYN8U1lYwYrEde4HORuq2KIFCEMS2vMg9/rZUukN9DzEQ+z6+yeYY2OR7rQ2YLX6ntica
	EyeN/qvfjeIRnEdR0WnCM141piu9GNh8o4RR2ZVGDEK9fn/PZbDEt+qlyCTBenjVgh6+I5
	Lg3qhZyM2fx8dF82zV2Jz9ndl/Iqaz4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O2B+CmMR;
	spf=pass (imf06.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783530423;
	b=c+VQT9sLxFtcpp9Lh7A4jjcjkeZs+LunFRZ1h6Nynzg37UGIcYj84K9B3kc05fUB0Q53cP
	x2WL+LeMEM50nOJmG8EbYVCB4FU5BgpKQohLlRsAYdeYRC5LGenhZrm/afcdj35EyRPAZU
	Zqdw6gj0fkKSRJbAE4tC5TCtp4hxi9w=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-847921eed4aso1196897b3a.3
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 10:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783530423; x=1784135223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=amf9A3ny0stjzBNYa5xxQpkuKUHxHwl/QGUYuXrMddg=;
        b=O2B+CmMRXQn2G3b6K4HuFwG3dNRj7sNCrak0bzqQynLhNZGWQrK2kFDYfp7S0TlnU6
         bVS0tJR7RI+ztD6iqFrcwfQOt6aRImU/lAwi5L0yje3gnSBjw33c3k/BNbCS0xFCgakB
         InyhtDpBvcpESnOMArH4/IPgyDv8PG7Z1bZaH/x1nIGV7NDz9EH2UzySTPBZKskkwcYv
         Sg0F4RSLYWiiI/905sUDUl9siA8DVs1ookBWzed4k0FS5iUFxn2M/GWxvN7uJLXL7dAW
         pCMW/y49Mp5hJUOigxiEIdAYcKMrkGsn7iwP9ErNsAcArbjxisxKCy3oIUJhmr+3njNR
         6ykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783530423; x=1784135223;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=amf9A3ny0stjzBNYa5xxQpkuKUHxHwl/QGUYuXrMddg=;
        b=fufBHJDQHdMAMXXZ1pfkpxnodOXVXvGr/slIV/tDVfCu7l/t/m6Y+MeFoEuQRl3KMR
         72EiYKehZhi0zzBjh0MYOBqlL3hfrS6OErvfwVB+n8Zeqf89IBhtOHAq4zK8NtzcAtrK
         bNQHq7C6ettL6byJiE5i5XZ2OvA6yHWuLVBf1RxXlr1NXeHqc/mM2r2VKlT/cwZq+ObL
         7WGsYGiv67bwk6vY7hYboc5RGegNGe4FqLngDhN/ac7SHzxZVZGDFouRb8sRZXapdEnM
         u9eyqu9vddbldqiUVBlxDN+arzxlkR3b4ghAxf/xM/EBohEtoSVfHTZTPLBZM0thHiaC
         5h/Q==
X-Gm-Message-State: AOJu0YyRa67pLwZYJraHsLq/AiOcmVihEBcSA1QAZW15Vlm7H9AMuswe
	5l3ZIfFOIbuGT0O1MqBFC66+QYyQEPMUaevIAmMtCqaIH8Xoua2kR02H
X-Gm-Gg: AfdE7cksvTX7hbVxVPNtmoitsawEEHquhXrWRMwOrDn5crkmkHsMz3L3fWKPltNljHg
	90XTgTj98Bo+oBVGRn3Q5awd14fgbSD0WG/25ZnbpB1K1gADSbS9agLCFQIV43oYunlLQgkvSLy
	kYN3kz0zIgCQiUEC98K5Ov9HlW2oiaaREcoZOtRNm/FYbuGSJkzfqTnV7VqiNGbERuZhukvugcP
	o5KGFAwJCyQLIv+kSFYDBPmsigJe00zE9FAxPz9Xz+Ez/WTQypwUWrjDb0E7CbNcPeINF4BdtUg
	M0H5ygPIvJD1yt66XdA4Z8FTfma1XswylgesLMaDccYFDzjjHFDTAhdM+0Xj5Fd5PUQM6VsWdX9
	tPWHQZIHtfCXilzjLqMoss1solNqq2OBd0JeGRGzzAuB+7J4KL0Z1g+oQCjEZUEPbc07LFg1CQ8
	q/9Wy3WQeWNI6vYmTH5Q==
X-Received: by 2002:a05:6a00:a15:b0:848:2f77:e2df with SMTP id d2e1a72fcca58-8484392f4a8mr3717327b3a.72.1783530422835;
        Wed, 08 Jul 2026 10:07:02 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84847275fa0sm1119528b3a.22.2026.07.08.10.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 10:07:02 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Will Deacon <will@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [PATCH 0/3] mm/early_ioremap: clarify and clean up early_ioremap_reset()
Date: Thu,  9 Jul 2026 02:06:44 +0900
Message-ID: <20260708170647.362562-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ED151180004
X-Stat-Signature: rzdqydzcgn1kg79fubtfpsr47grwoypa
X-HE-Tag: 1783530423-31547
X-HE-Meta: U2FsdGVkX1+zsDcdwPpyoLWJMGE8nTZDK0+/bjfxro3hdRzpee7/cIuOoDsf8yiVaQQ1itFhMOKwUFcbjFcdou4zv4/keTOkXKoZ6SYMt1QaP/ALGvUONCzP/WRoqIu082hdrTS/Z9O1xkMmiSnX3LOsqbGXZ2WW/ipfRP5joK5SS5DX0nVVEksAxQCZbyEVqRPqWRDwB53aUs30suhPfzjVe1xXgtHJZDtyFR4C0lcJM9Xn3cbDEIs5yELMKREkSL4Gt/Tp1KuBOFM0kdoFFsvBDiKdThOqOz84figb4FwA0uxL8uR4BKUvR64qoxcFyJEyfTxEynq9yDv52S1vzQiWOsv1//iGkLWwbN8n759i5PnWQXf57xp4RDg9gmakrV3vRTEce335v1i7SabR/uCTFqeuKRaLiHJEjZTXd7SR9zo48Ma7uvmIMDpaphOko2azGq97XCVe2FDMG0rdfao4r/7PpITYbW4VSBIdUEeoZMjDcI5kypUEOmNnFeNBTtL9AtzIlRQOGYkVm4DXIh+twJhiuva0pWnG4ZMg+mwVCyIDgPgGomvoNInk8h/qWrAUrIuvQSbJuqz9+GolspUvibN/Yge2NelotAjwMjL7pDqA3kqXPEqO7HMCJA+8btjoaWugmFsNxgS8DBsRHPEmBV7mVRmqcR7jgEq4LZnYsI7PtOPpVNvSXh0Tqc/dgsMAv3dvRS+2TtIghogvh1ZGHy6Rx/rCTsyJ9y+uKed9f12f+67lH6kkpWzjM1hTW3BrKfuqQud+COjAF94qJXOinfRjZ3INGqiBmTZx8shf8YA8fwgRbBwrkK/SPkbnlo95BJ4evy6RngJPNUbpDEeb9t+Q+LaRAKtCHt27E7c3UlpcE5EAMeby78fTMZ1GXSvnSL7DcCAoU7Y7SmUQbOD4w0rSPe/jikV3xd4LIyxmvWA2Iravw+DEhS90WocdF8NCWSMptpQxsha5exf
 pIRWpK+a
 YFWi8snU4M6ZLotOrzBdV+Ioqi8F8cS3/zRK5japWuswpDKgr7mkIzgJWk9waI+nuMViRd3OyhA6kXdVTfLV2jGvrMhCDa3gXERdudlZbAmyFXaWTcYX+qQdmT+OunV46DiEPWgVbmj3PShcdPzraIn672NMloB4ur+tc8Sf4m0v6jUAnEwSXRLGf0MUaI06dBcu4pkpEK4otZ8OadJIl1Mz4cfHtfh7VD3HYsqNr418Tg83wlM4NoNO8+RQh6oK8fHD9kozlwWzj92RUpKspHI3aWbRznrvlZjmRb0R45D16WmBy8OKb1Vm82hGRoMg8t5Zgr3tWO5+dYM3WTcskjzC7n+rTmWOwsxsPSnnwcIrtvKACkCxWWaRg4seN4b/5Rg+8WqVazRoZz1QAK/iEJnDrF1KjMWW372IjI42xtrcurQxgI75ATGMOJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__late_set_fixmap() and __late_clear_fixmap() are only used after
early_ioremap_reset() has been called, but the comment above them does
not say anything about that. So arm64, riscv and powerpc, whose
__set_fixmap() works before and after paging_init(), describe the same
situation in three different ways:

                 calls reset    defines the macros
        arm64    yes            yes
        riscv    no             yes
        powerpc  no             no

Patch 1 documents when early_ioremap_reset() needs to be called and
that only architectures calling it need to define the macros.

Patches 2 and 3 remove the unneeded riscv macros, which are
unreachable, and the arm64 reset call and macros, which change
nothing.

No functional change.

Sang-Heon Jeon (3):
  mm/early_ioremap: clarify early_ioremap_reset() semantics
  riscv: remove unused __late_set_fixmap() and __late_clear_fixmap()
  arm64: remove early_ioremap_reset() call and __late_* macros

 arch/arm64/include/asm/fixmap.h |  3 ---
 arch/arm64/kernel/setup.c       |  2 --
 arch/riscv/include/asm/fixmap.h |  3 ---
 mm/early_ioremap.c              | 10 +++++++---
 4 files changed, 7 insertions(+), 11 deletions(-)

-- 
2.43.0


