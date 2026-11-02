Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05570606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=P7pPmEP1
Received: by kanga.kvack.org (Postfix)
	id 3008A6B05BB; Mon,  2 Nov 2026 06:22:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289616B05BC; Mon,  2 Nov 2026 06:22:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 151956B05BD; Mon,  2 Nov 2026 06:22:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB3DE6B05BB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:22:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DCF5B40785
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:03 +0000 (UTC)
X-FDA: 85389939726.01.0E26E5D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1241B40006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P7pPmEP1;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618522;
	b=X+cqq8FOznkAJH/F+Ge9o8yRNst1Aa6esE7CVenckQH46K1RyRDyx3ymRJ/Pr6bjjCamIX
	9KYsd5wUGQm5RnC3dWe/ZV6AQXhIV7EwkimBkeXKjSyLo6Q7VesWoBPosllNRNLnGHrx6g
	pZ+G20Mie1BJm7WsOfgqFiaUmARRPQ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIY1t0oPGMjY8wdeN25SmhCvTiQ+irrDhx4HcT07Fl8=;
	b=Fz404XbhNLdwGzAkzLwLvrq56ugkItGADyEFA0NVfNWYB1Zsnv7M/dtuVcUyvfJt7aDSW1
	7lMCbWUC+fshm1/cl73YoXrgSlwaoYYPA6tqeqhpaKtF2gguV0HyVcJ4PBCNGdrja/QEYf
	WJARB1v1oxhozvbpQw1R/MqxCnZMzGY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P7pPmEP1;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 368B01691;
	Mon,  2 Nov 2026 03:21:58 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4818B3F632;
	Mon,  2 Nov 2026 03:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618521; bh=kV7fmntEBngzWjlRtt0fXgbabk4vgoYlOIhmmgX++kY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=P7pPmEP1+y7xcVY0D4K6XD0jQizTpCe9MveMakhuwNTgU2/rc02un0pmGMjXbJF0R
	 aYrAH5ZcOrnP+iq/bNtZh3I9kNmBsSIpcL/OxZxQcPA/T9dh0psHgdWo77wSDR8Jtr
	 w16o3AMZnYr0X/mED3RmiUDXSnMXprAQfKtqzhZg=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:17 +0000
Subject: [PATCH RESEND v2 04/21] LoongArch: mm: define pud_leaf() only when
 PUD exists
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-4-78840b2ec73c@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=993; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=u7CkBygp3t9kTReuMDaCmZH0s2byLy+RqHAVuQrH24I=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HIwlxi0fq0NvoRR6wAM7dkyWS9oxQBI40Cgc
 DKUESF9vgqJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyMAAKCRBt1cPRWsUx
 M0akC/9EGZkuiEkdTxl3CwYCFtvx1xhNG+FjrVxbus6mPWauJ8F5+J5sg5Np9DCF7VcqrJ7ge/+
 bth6MHuatRPh7bNm2qmt1JrSUpNXrDlMed/ARE35YCapddiVFrA/hyghxyvDrMd5RXiBZ1M4RTK
 PBpos5isVI6lqHRQNvFpm93ZH2dO+LOClaTapIUlIZCo5Lg/rNxgcJrdFYAMGgANqyeKI3gKPd6
 lQtVhU1ZcDtV2xOKlhJegzKtK8N2O6FCC0F/mzVAlow4BD/Owt2Y9Pla/PUoribW/NWNTCSJ5mV
 yQmIkHn4eDIrvIg4JJi4YgB0AVvnHsv9ctgHp71nNecFNaljvmmvh40iYvrgkfBuuxpwT2Hsyzi
 PDwD5+lh1C/9TTrOCsmc4rjeHahxJv3TCJ1ggX4w1/T9VRTBKxgZEgoQWtprkyPP6vK+BHLuFtd
 Y+v4psuuQM6VJV21P5UYO8NVMmjA0VothRLarZ8QJmarCmc3Eu856bpeW5BNJO+iTCRXs=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: wxz3ipebia4x9aqanzq1wstwmot5r8y5
X-Rspamd-Queue-Id: 1241B40006
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793618521-543321
X-HE-Meta: U2FsdGVkX1/XZkLD8/ftlc+viAHzkbfgnAWdWlupLoPFmTWzKwIh1IcNZwZG+wAVEO44qTWE95LpoLmQQ7gdY24bryp8Rh8W2RviUKn6ANgbGu0GhPAvoXQYaTsPn4F76h7+ECilfxFFtggh4tSQqVXEP264iYx8z6XMFYYtKB/4QrY2wX0Vdqs9bOBNWgZyHPzY6z+ptl/iDh8pLVZrH9+FHWjdcMsQ7b7Z+KXR71CPHOmbIGor8cZUHXW/LcD49wU1Lb3EypuPPEVHGlE5lYbKiHi2hAOZ7L2ixw5sZbzUkU+Kg9ULGNTy0gK6SSFS7UJik3Qpx2lvaLS4Vdu2Pjtr1rCBK/7MaqROkTGrE0ll+rmEkA/NnLI5mOQBT8Cp2QO2EN5IXlCpZGd0zsupFZJPt5RbBuV/Pd3BZfQBKQDcb/z+mjxb84i70/fNNhEQaOIMrut3Op5GO26sB116PqYdjPYn30d3S3s0IJ9DESDA2tmIB3LTciPqDC/HhbmIqhf2zUCJVMs084ZXke3rX+/JaTVy6rAqXlrszFlaUrBMbXBYWPSa7aTwLTF6j5P8x9RrTibBgXBDb3ZL8vcImhFasTkEhFvWVQs4mX9Zuh2D98TOAxt3lh6ML2FqQtmhQBWvOmwn147heHrRWONAROJyXWYJfoNEcuUEE2pmFvBtdee87+cd59NxEILi5sGL8Fc9iknTk8Dkh9UsfyUiBJZbsHUZVitYIzpcQg0L6YykQS5HHyRV8twjcuJYUpBqmZ948VPDrkX34KRk6rh/CsE8cnh0Yz08jxIhpv8L/6m6XlEEyBXdXnG1Ns4Gmo6e9iXxyThiBQ1nlkKX8pf7KGL7GZyhVkbKUzdFB5n0QQXhf0/Kfn4oB6Uq6+I6zVsMcMLbeS/lfP5SGwvOo0NofSIj1sf00ycoIeC32Wo+BkHTaNgtzHBX9DawrrmbnVTUXJJxYP0+adLIUalAy3c
 qGixWoQz
 xKbilmMU52uwOpp3f1x7cSkWCI8QNbihSmDBoa+FeZkBQPkQMdL453rkNR3HtDIl+gQtLy40o7Kij5Qp140TJrunToKkGDNssbAuWGViSN2/gLMWcc52jqYnZScWqZjRgL6mXhFI53xK/ryI/POADb25ZEjCfDJJ0wRC4H/N3vwmmUo8AD/HJe2EgtHVBDJBKP7V+7KFYHWIeHgZNoTkzIH6UynMRzy0AD+tFVZ4PWwhQRLWOLLaLndhbiBKzmFrq85RPH59PowiGVSTvfhTh2Nu+McWeh2Ka1rdhglFo7xb1b4dvLsNbLnSVRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "David Hildenbrand (Arm)" <david@kernel.org>

In include/asm-generic/pgtable-nopmd.h, pud_leaf() is hardcoded
to return false as inline function, but it misses the "define pud_leaf
pud_leaf" part.

To prepare for fixing that, define pud_leaf() only when
__PAGETABLE_PMD_FOLDED isn't defined.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/loongarch/include/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index f876031351319..9a62b87c246de 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -631,7 +631,9 @@ static inline long pmd_protnone(pmd_t pmd)
 #endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_leaf(pmd)		((pmd_val(pmd) & _PAGE_HUGE) != 0)
+#ifndef __PAGETABLE_PMD_FOLDED
 #define pud_leaf(pud)		((pud_val(pud) & _PAGE_HUGE) != 0)
+#endif
 
 /*
  * We provide our own get_unmapped area to cope with the virtual aliasing

-- 
2.43.0


