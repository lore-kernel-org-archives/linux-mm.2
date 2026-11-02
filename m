Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57A3560A261D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=VZKidji6
Received: by kanga.kvack.org (Postfix)
	id 573976B05CD; Mon,  2 Nov 2026 06:23:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FD366B05CE; Mon,  2 Nov 2026 06:23:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC366B05CF; Mon,  2 Nov 2026 06:23:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1473D6B05CD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:23:21 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 968F040CC9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:23:20 +0000 (UTC)
X-FDA: 85389942960.23.2980A92
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id C1A87100006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:23:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VZKidji6;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618598;
	b=ga+6b1TcFJEAhs7n2vdTDNpIrI93209EOnd4NWMbhZwbNmYR3gsQzLYJVkkxZXgSpVCOJQ
	fBHmKduasij/PtHbD78t9gdmKrRLIBsSy0pUPJ5mZnu27t0KBcsoByh17f0K1YHwdaAEJr
	IkFm3EGhhgtSLlJkDTSCOWwExthXfKk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VZKidji6;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61mOQB/NPnyS6WFT1v6qj3vnbL64UK7nj4+n5n9dFHw=;
	b=pLPeowowOOSDbc9ArzJyIik8oOT1xk3ZUgyXiqIOzjlvKD3nzqYfHvbAo2cv8TOkbKE3EQ
	1VY/NHUWgiA68MKLq0FxFHZA15cOLdxj5GvKx0Ss/EJ6pUASdu0iAA2yk0OHbAa++Nmwfy
	EgEw4asYYTTkk4CSX8zsyAsod1WPD0w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD92D2972;
	Mon,  2 Nov 2026 03:23:14 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE2F03F632;
	Mon,  2 Nov 2026 03:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618598; bh=fSF1q0uZ2D6D7eSotmHP8T3BZdnaiPG7UdplRIp/5/4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=VZKidji6e6O+6chEIb7bnFpe9r7WvFkyVmIiYaEEba1bfdN9JrXHk/VOjxcw7Jcv2
	 qFG379Foq/0vjKt0b37jJIKZ0fR8WbzX6hs+6FN6mIxGadRPx56BeD/OHqHj0M3Q3k
	 P/jCQurQOOjvmQK+t8GXmw74iH/Bo3dhkM8XPPwQ=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:29 +0000
Subject: [PATCH RESEND v2 16/21] openrisc/pgtable: drop __pmd_offset()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-16-78840b2ec73c@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=883; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=HHmjFCiPkfuAa6Yg+gCAN1VqpmgkbnXOKSW8+pCvqDs=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HI2QHNhLhdF8ydTZOu6McskHbnVKaSU6Y1AJ
 kMVzOl9su+JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyNgAKCRBt1cPRWsUx
 MyWSDADUCB3Wh9MFEpUj8ayzq1Kie8YQYpCId3Wx6BZaE5A1K8xkvpBPTY/cf29xjfbRsl7YRod
 f1/gmxrhGnDXme+YBUt2LT+0R/6EYVFjWRb1HaF4XnJ7SRtR5AfMbVoeJOu3aHUtnyg9aqu7SDS
 YeA8/r9WGRtYatAteea4TTFtSp8P9eiyOX/iBhyYCy2PbEOYhYEeHT1QZuWAjUN1uhOQKpV8hl3
 mSpYhEruccW0rL5562glqtUyYO/ueaxe4V2cBBgrXSrho1pWtskDFplB3FGftnJ5yamOVzqEcuP
 sus6RmCTWMYsPRNee20/kjKQ84LvMCIBlqb+2evLIDmjhjbxT6pMa6fthG6IMlOMTv9j0Rk7vYZ
 PgWFxK6acMO4omG7AGcC1rIhrQD5WRMTW66aI38UR1xYHRCPFTR+MGptOyem0dOSHrXPIzrUiaS
 GsTuYuKe/a4MlFNlzuz4X287hGp2oOWGie0GnD81s6W+FjBJt8WVgJP5E2iMP4i/zfMKg=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Queue-Id: C1A87100006
X-Stat-Signature: 7is5u8jbkihg8pjg45wp9jxz8qrei8ne
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793618598-156376
X-HE-Meta: U2FsdGVkX19Ucx703fIY0x7wz+IjSRYi+/mY48Aq28C4aN7dUAdE0BZOe0I0tlLomrAznED4k7d7g3ixx1Q9F9SsODDRzWGK+NBOax6Di5lKGKP5AtIswOVhie1cfu2DGJ8CSZ625mqx9827GRay12lMwnXlryE1uFBRSl7hOzUMc9cbAZpbYhzHXRYNXjqMoFZBjM1K48myLICBscbHTHeGD17L7Q7+ttvX3gmIBPNiHhe65tCZl2P9DkmzjXe84aEL9QcJz+1tzkZAMFyw3kUKWBD+BB+PuVLKif/4771sOZ4KZ/DyfEXzjvPLqiZa7PHp/Mv7WBJgDq0PPzWJIfMcbYVDjAO11T+hxjZ7JY0/JRvw3zRIrz9ABhmSyTi/sOI/WFGiNXcmQ5RXiiWvTbEkV6Mt6wItTOUpl3UzPNEz/UfUfQCx1QTs5lxcFxheE1BOaq/kcEjH4ADqz4oJcYmfDHVuQLPd6lsh5UZyiIq7tV94hQ2gTyy6iy3iB32TCb1CMOvebBsefZd6vlNv4addeonj7rw+h5bvQxe5/KI4rl08RLiyrpmMXnrRtBG74RnHSMH059yV93ZJfEbQdMsTPqKYie7yTokKM9rZTI6J7KWsdimhaQqwjLODxpQm2CSnKWi1HwqeEEj2jM9fmGJHun/LZTUwz9xZB4QqhXQ+R/QuUTRa71TQM3Se+HmeKMVAllPa/4lpecaHxBdzJv6v//1I0WFUefuVdu302RW9ud3Um1V2J/p8surlTg7SNes5azLRrF/XUUi6fpiVgtMVqEu4d0bsEwrrdXbbdxrn8LHWeewPRR69+pOy2Uhpxd5hCRUimdszdJwebkEgLNFoPcf6ISfRU2leQM9mBfdRSlGI5CDZYkJWkN+KPjezrSD/ne0lt6ugatf6zInSXcbv7Sb2CZqRBZZpoFGxJdgvaS2fWvhiEomfI95vUPF13P+cJavaUWvkugR7vSi
 /iqw3uiO
 7XmJZD1Cc6pYERIIbtYMnSWuv02vAp6y/skmxKJik+eeRnT+49G56NAPqYef7qHbcU3TahK32wr4hQDOKuTCMjXSAZatRe9YpOQYWyjHgVzO4qsfg0ru34aixIt36F1npWXuGZPcfVHZ96vUAnUiwYuzDzPtqigWN3fLrLRAyrjP3HPjZ1Qid7/KE7mj1mP40A2Kpe2P0YkJ8UHDQ9jCVMYyuKh6AViPObm8V/nhtZLfpM2w+QRXMgy50Q/ZBbAxMeLuNdJ/9XGwRStE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "David Hildenbrand (Arm)" <david@kernel.org>

The macro is unused, and will collide with a folded page table helper.
Let's just remove it.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/openrisc/include/asm/pgtable.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/openrisc/include/asm/pgtable.h b/arch/openrisc/include/asm/pgtable.h
index 13afcc0bd8631..7fceed641610c 100644
--- a/arch/openrisc/include/asm/pgtable.h
+++ b/arch/openrisc/include/asm/pgtable.h
@@ -331,9 +331,6 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 	return ((unsigned long) __va(pmd_val(pmd) & PAGE_MASK));
 }
 
-#define __pmd_offset(address) \
-	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
-
 #define PFN_PTE_SHIFT		PAGE_SHIFT
 #define pte_pfn(x)		((unsigned long)(((x).pte)) >> PAGE_SHIFT)
 #define pfn_pte(pfn, prot)  __pte((((pfn) << PAGE_SHIFT)) | pgprot_val(prot))

-- 
2.43.0


