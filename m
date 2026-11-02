Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B898360A262A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=NeJMQzqw
Received: by kanga.kvack.org (Postfix)
	id DAEA86B05BC; Mon,  2 Nov 2026 06:22:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F146B05BD; Mon,  2 Nov 2026 06:22:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4E806B05BE; Mon,  2 Nov 2026 06:22:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9E366B05BC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:22:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 490AF40C6A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:10 +0000 (UTC)
X-FDA: 85389940020.27.28EB6A1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8FEE320009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NeJMQzqw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqJcyBohCCmTzbrZNGYTNNTZHJuSiPVln17AJPhHdQk=;
	b=xStXcJuKpcT6CXyqOLKyMWrQqFt1UYRPt0+sgxXEk+dnJ3RJJpkGmTQ/KVulguS7SZI8i8
	yGulNN6/QGSUAyQUve+jYaHDE+4a3yVVQkkdBIFdrzeLFS0jwHLR6IRotJ9jalhIYYnVpk
	FYWotgDy017eTbZl9QgIiUmTns2MJe8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NeJMQzqw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618528;
	b=FvXfc4qWryGk5qU80FybENNaGgolisojYTTvgf3ZIETOI/1iXWMvyLPsAYbCziuSpW2ZL2
	CZ4dAqw348hkOIesoYWNGM/Nwwh54wZe07pzAw5TRGb0XWlV8QptwTb2PDjr+Qsvob3ikX
	yjuMGPy90TWdrqD2sG+qJmDkED3XrIc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E1BF2972;
	Mon,  2 Nov 2026 03:22:04 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 906F43F632;
	Mon,  2 Nov 2026 03:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618527; bh=t0SkgFkvYDykWTdwPClx+wiQRsFxgewU3m4qBQArb9Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=NeJMQzqwvJCGViHbJ7QrglEcV+sHE+Y7LmN8Mv9KRlpD1KsgVkRdJciC+OcIGK7Ag
	 luR4kD9pngLARUQXLPyQKeqzGp8WZsRMvLq6m0Yi96l+E6h6jYcb/XlccgGehaPKp5
	 sPYNbHXRsNYuX/TWYKOBUYKwQid6g9Lg7pUylVag=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:18 +0000
Subject: [PATCH RESEND v2 05/21] MIPS: mm: define pud_leaf() only when PUD
 exists
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-5-78840b2ec73c@arm.com>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
In-Reply-To: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=952; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=yLp6pLFkEq1XlBsrO8HJPn9OYitILCqfI5l0JaR3PzY=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HIxBJSBNoM97Az+FdfadshzwrJE6Hk2Nn9Vz
 MKxgKY54myJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyMQAKCRBt1cPRWsUx
 M2E/C/4qpH/vx+lqCX8XvGB0nXajTdL1XeeI+ifzMxsOUQjJtT8tY/smDQ5SKrR6WinrXO6Ngc8
 WmJ6HXGoOoY6VCHl5ja78DeFl3o38mPbYI06PBowiBBAaaOBJkWomfxtw3g2ZgG4Uh1aqfv6fXp
 vwiLGY6gzsFsCz2pkFz/WVYHWeWqpPNYSc9pZpJinfslFX4hi/cKag4gdGQKNYILIYyJJvIlbNy
 BM+ngv4diTaMO/vug1mgTvnHEo8CA7knFGj0n3zq1xoj8KhWbK3mVzkWZUqO7kxKi9KP6At4d68
 cjOzafYZVtnW0n4cMsgFw6P6ue/iZVXDPbhXMFL2jnVeya9rQru/UtN3eOKJMxDQ4gIJ2i7xQeY
 6agNDrREyget33aj1qdFW+UzgsOEn063yBZc3RAdit42b8EUr85bUWAHsHJnOQnFedG3AFdIRv5
 S1T3ej8geq/V9IRjOPajCdzqh5MA+dmkNPfvhLTNuLYlId5s2wizCxEMs+pERzFa1A2c4=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Queue-Id: 8FEE320009
X-Stat-Signature: dsre7wg9yzfi1fwhfu7c136h7ue884cz
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793618529-775185
X-HE-Meta: U2FsdGVkX183E/YYsUgY9VHBXasfAy2WRxoAs4h0ecTutuQGQP8791cu1voW+0aV59991OAwBf3MbILpCfjut+rhjZ4xCKgCmy/Vd8EtAc2nYSfyrEHcAlDF1UyC5I/LV//WtiZXYalcC2VFDulWq2VlQobO+U+tw5fgkX6bgg7refDJ55w5ik6h5vKz7Tf9EG9avumHpR1au/E5YB+pIJswq9CwJU1qRI0zaO6EbDWatcrRRDdhjYbBKvhcAP3wEuI+o4nx3Y94MYKcsnSJR2cUOQ180WOQhuGC0oMsTOsUHB2eRjlryPvbgeKTrbugCf2DpKQnzq9FHX3GIgWS1YUk7afE4lxuU1jyNX5kSQgaeyoxuORazKXU43sVTYBd3fEYePjbEeoRutIN9G3XjvU/B7pHZk3f+JnwqOrpuqhh0T4FyZu+P/KEyDHn+2fGJF6/NBugtqDJEGhovtu3cBMebY6ztfN87hI3fzBtTdN+bCz43ZWVQLVoy6i3U++SMM+L/fsgr2sY3i7uD/76OTpC38qeg1cNFRtmg0KYGBp0jww6rMSGRWfTe3TGW2NMUS/tR/JthP1e86hPWreM6p12jTNhA3zs6am+85MRmhNm16r0yEyF+UB41ed2jBhVnOFehwWnDfseP7x3BvT8FsvKXG6vZHq05rA02p+I9l56uwKHO+ZURbecL6Xh6iEGBL+tWKAmb5j8FjkRaLDrHIv0MTolOE/CVB2e5rYK6ClmoyIZTVxmRwz5OApKPVKM/NB5SIuVoyzi96glRg3i13LWSu05804sTvt/UQz/BaA6n7OIT4XL4HG/oxA4DZRD76VxYN76bdfa2Rj84gPDE1ekn4jFnY1yecoICxIQN+r7X/Wus8CGfeUvkHuNgZo8kB+alpWv29NI+WTaVK/k3KLMj3CQeVxpg0zWE+W7xr7hugbjP15DNzSXlo4KN+KaVzx1XKMqDfa0SHXCZLH
 3t3yPYMB
 4raoQFKx2zOz60fOePgtztSPIQnAZyvvF1Y5Qdl2AozHJ7vs5JSSqposCTwcBGN1cM62/o9zPwmfQm5b1a+rvTgQ4zKqW2NrCefdcieb7fRRR2O7pn/jo9OFFnvqB1dE1qZUsi1OqYvp22hBSA3AtSS/6tQvA8xT+RR7aWKyQMfjyuZz5OGJm/h5VRWEY3C4KMnu5VaceRxV1p7MAdWw2or+zIOK06i/sj0082clf4vEWyTGMRaibHMEFMzv1TpN1yZK4OhGCYDLNixA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "David Hildenbrand (Arm)" <david@kernel.org>

In include/asm-generic/pgtable-nopmd.h, pud_leaf() has hardcoded
to return false as inline function, but it misses the "define pud_leaf"
part.

To prepare for fixing that, define pud_leaf() only when
__PAGETABLE_PMD_FOLDED isn't defined.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/mips/include/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index fa7b935f947ca..151f4d15bd12b 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -745,8 +745,10 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 
 #ifdef _PAGE_HUGE
 #define pmd_leaf(pmd)	((pmd_val(pmd) & _PAGE_HUGE) != 0)
+#ifndef __PAGETABLE_PMD_FOLDED
 #define pud_leaf(pud)	((pud_val(pud) & _PAGE_HUGE) != 0)
 #endif
+#endif
 
 #define gup_fast_permitted(start, end)	(!cpu_has_dc_aliases)
 

-- 
2.43.0


