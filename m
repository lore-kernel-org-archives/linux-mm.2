Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E15F6D59F6F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 08:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 556696B0005; Sat, 13 Dec 2025 03:00:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5075A6B0007; Sat, 13 Dec 2025 03:00:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6286B0008; Sat, 13 Dec 2025 03:00:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 30D6C6B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 03:00:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE5C81A055E
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 08:00:57 +0000 (UTC)
X-FDA: 84213701754.16.DB4A01A
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id D3999140005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 08:00:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf09.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765612856; a=rsa-sha256;
	cv=none;
	b=zxeL7twRHuTInAXsAGzZp5VaJKEGF80sP55Evy8ZlixihnBoJRJ1XdURFm/18HlDQE4Eua
	qb1A8+zNOeQx6m1GwUqwkDZ3qvE41SVn4aNZJVeUS5VmqMY1nIPwtb4TVZ3UclYaNWcsbF
	ZV4rPbuMLP8C67nOTO7AejzewEQogDI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf09.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765612856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=uwMoXNDgoraLN2s2u+sQU14RS7UZ7t31vygWf6FGxo8=;
	b=0p1KsoC56IwCctrC/UtmOpTVgCEC7DtBYZ/gobEWO7bbh99pa2dFbdQiaSh4Qty9W85AY8
	/gaVNHUXFkKbl0WruIfCPfVn3pGbuen/IY4/DSW2pF6egZNqmE/XLNyzujIgGK/15itIDh
	0IMI5DOuoiWrW6H/QCf5b00nsXIMm64=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a09d981507so719905ad.1
        for <linux-mm@kvack.org>; Sat, 13 Dec 2025 00:00:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765612855; x=1766217655;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwMoXNDgoraLN2s2u+sQU14RS7UZ7t31vygWf6FGxo8=;
        b=dBlWm4U0CJp4Jtk051Ktys9o/EVupf+H1QKEYVApGVYvEkfLmy+HF4JJ+rSOTtWPNS
         vhw9mC/Jf1CW23FkRkEenZ7VXsrjdgwH0CTRN98tZYmcmuxA+guPujdTWpzgVS/md/9A
         KUKTABkk9cQ1mKlvy8wgelIX7nHjYUzp01fl+9dvBiFpvl7C6GVw7NyxepkI0Yg7YUL/
         lJq32mLcaMqSNrJ3T5/Gx+fttN9U123ZD9mJaX6cms0W+yJczjbWipNwkQevpMlw+yJx
         Q6Jti/5YNnIZuaUsAHY29qvImIqMP/2po5xEt1TmSCIGBuX4t4HlGcQo1FV5xZLg2MlS
         gGVw==
X-Forwarded-Encrypted: i=1; AJvYcCWKRClOcOx62rPuBnI6GcrfpLw+wZMKHgNtcyxl3zPTpvDmMxMNJkp/R/8igmPpZQRdt3oEhEfT3g==@kvack.org
X-Gm-Message-State: AOJu0Yzl25hWzL0JAvwO7ySqLgX0wIuzoLbHXn3N388f/qi1KxokFGZR
	KopkEqNYPAHaKBhrX6fxrRkxozPx7NKrPW16PJUDD5kOO3XGxfTfwPgQ
X-Gm-Gg: AY/fxX5GgRjajvoXKDgCLbVGCX2hk+0zt2C4K69KQLHbOrgK1sm6pmmluNYHonRqSWg
	l3qIugJ9+ET1jp17KH9tirqnZ6Si42oeH2Rit1+Xta5as19mCK3/t53P9bzkbY5HoC1TKq3jl9K
	TLES3rHJuJBOfMvaREHtYb7lU9q7SOqtEfPERM2j/m3kcMHOwh1sNfiBnJyNpSsreEU/4AH2U5Z
	FcCXds6C+Zr1sZcZ6eCJcHlD+pXFPkRGPworVTFubRfU0qmztutTqfdkOzuWwckxYAcpDZrWow4
	GLzuoNme7NU3x76kQVqM/OJqWEYr7kmTS/dJrnNVd+qW1XeoHeD1111xB/4OY3MxQC7kPTT+nX6
	GUSxhp2oUrlztS+1d7v+dq1S3SWpZraoctwj8jPMtU3BLOOgFvLoXILCA2E72r12IbctTrHpd5K
	5fOX3Ud80DZ21Yzvf69QQBQk4JUg==
X-Google-Smtp-Source: AGHT+IH/JoAGIeWkbC5Ijwb4LT700SBRuvmuttOCUbTdCoNc0d7rgbi/92X8za8oyhtLlyVRSzlnrA==
X-Received: by 2002:a17:903:1c3:b0:266:57f7:25f5 with SMTP id d9443c01a7336-29eeea041c6mr87005275ad.7.1765612854584;
        Sat, 13 Dec 2025 00:00:54 -0800 (PST)
Received: from localhost.localdomain ([45.142.165.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29f05287fa3sm53149155ad.5.2025.12.13.00.00.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 13 Dec 2025 00:00:54 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RFC 0/3] skip redundant TLB sync IPIs
Date: Sat, 13 Dec 2025 16:00:22 +0800
Message-ID: <20251213080038.10917-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D3999140005
X-Stat-Signature: o9q9mmmws3s9p7ui8icgz6ryitbne79u
X-HE-Tag: 1765612855-546600
X-HE-Meta: U2FsdGVkX1+mPVn/KsuDK1uKt2J9OLpQazsJQee+E4W9hPh/CX8BbATfz14E9S4icQOkc6c/fuu8WiLRPiLKnI1sjKRvX1cfy0R1wQEJwgLLeXVkfhpbN7/MxCdrWkoue1lWDIcgNHCu+B21G9BVOwg1PctZEgU9TQHRBia72DVSg4YrvBZiUYKkl77oxwZqeXK4P7dP46bLEEnyElyPWOEztZP6GvKj3rvIsZw1gMntjUrz1YpPB8PZJ9ItzBclRX0iIrqxAIzBXNsZiIeHw+ysacMFjYFPwPbk6Yo6rLPUfdlPymzaQitnzN11BJY61gArE6vLiVM1FpSPNivy+akjxJdlJdgC4PnBbWQaD1yFe4+beG22DFpLJqY4MfJ0v+CmOccr3iMvJQt5cVC1/b+nQEr8Ndlrnug5sH5YpD1nkhw4vI8P8qdnTwj3S2DXooSHw1m/RFYdstGtQDojNYwhht30Q87QDHryXUn/l+b+beLh13eU/tJhHCPlus7SL3B7njG3l4KM8Sydd28dNxTudwAiaejSimZ59/UlBIA4Dlb8929etspL+gCRK7hWoJx/YyJ7EzoOLMjzUR0tjQL3QSEyK3l0FZXeImzT5eAP4USrzX2cPGP2BTL1H//fe5WyxEJFQDK+2t7zuJ0GbYItBJ120sl/UBhjMJfD+C3T7aUXU203MfnKFuaxTV/tXHdzT3m7b+Wmvy8sEGqNh2QdZtFiV4m9FznqyoJJFLydYzZin/CAB6AGHRxyRhzbQ7y/v4liLIXE/dbLZZdgTuCZML2KBHv5bATPu/tSXZKekwUvk8EbeK5fwyJifBVOJlR6xTPOr6E+Cn7ua8Gvv3WUW1apJD1r9yYe76ZEELPP2OBPC2uZH/jB2UCP3Ck3hkHedenIOlBmpHillnBNqhqGv3Qzqn4UlYvs0I1wbRMKGJ0GV516GYvUyTeEoqY4kW70ij2aj/osX4dIxwI
 E9BM7b+z
 ozEPjM8IDPDJiAC0U5OVFT7mUy2IrJjtGXYpzdsoX9sjxCiZcQRT7t5L5UCHyFVeqYuXRqNwFvG7DkEQMePVOh08p44lYMmpsbogVFoocNoi7+h0bOuS38El5vDlOgPSq7ex3jw558JsWcFNOBMoM2uV52+xyftTD5P0Fo6WNxwzK5jj0GJabRtNIeAXd1+hwlvdF+BBAt8jBO5F2L3EWz1nWC2AJeRum3rg4sPMBBzSoZ4gp1y5mcYrlOlMbCJsXcNtETsIpx/dLhSzkhAh0hT1qWBaur8fGiyO7o8UDpxh4Qh79x0qImMF3co6FJ7SrhoJ5qUmGI/uQDQreInpOUfVhspai89WoTlCyCye9SI1JKdDZXzu0usgimk81NQYvfrbLmQix9PGqiMuJqWYJh8WOn04oyXh54rF9St/iNcWl/NSz3+SZTfVcYHBNGJylzuMS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

When unsharing hugetlb PMD page tables or collapsing pages in khugepaged,
we send two IPIs: one for TLB invalidation, and another to synchronize
with concurrent GUP-fast walkers. However, if the TLB flush already
reaches all CPUs, the second IPI is redundant. GUP-fast runs with IRQs
disabled, so when the TLB flush IPI completes, any concurrent GUP-fast
must have finished.

This series introduces a way for architectures to indicate their TLB flush
already provides full synchronization, allowing the redundant IPI to be
skipped. For now, the optimization is implemented for x86 first and applied
to both hugetlb PMD unsharing and khugepaged. I will dig into other
architectures later, and folks maintaining other architectures are welcome
to help out.

David Hildenbrand did the initial implementation. I just built on his work
and relied on off-list discussions to push it further — thanks a lot David!

Lance Yang (3):
  mm/tlb: allow architectures to skip redundant TLB sync IPIs
  x86/mm: implement redundant IPI elimination for PMD unsharing
  mm/khugepaged: skip redundant IPI in collapse_huge_page()

 arch/x86/include/asm/tlb.h | 17 ++++++++++++++++-
 include/asm-generic/tlb.h  | 22 +++++++++++++++++++++-
 mm/khugepaged.c            |  7 ++++++-
 3 files changed, 43 insertions(+), 3 deletions(-)

-- 
2.49.0


