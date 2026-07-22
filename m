Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC262C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD8A36B00C6; Wed, 22 Jul 2026 11:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D89626B00C8; Wed, 22 Jul 2026 11:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54156B00C9; Wed, 22 Jul 2026 11:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 944CB6B00C6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:31:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25F77140209
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:33 +0000 (UTC)
X-FDA: 85016802066.15.DB78FBA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 372FF20003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eo9nYy+0;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734291;
	b=5M/rmdIm4XRBqoDLSOb3aLi3RBd+gwmSXeYUfViqQwbQjIo8KWqIwv7MigNAeshKAe1WB8
	1MSQFzsBi4Krm6uNgyNKfEYytvVA+oKUzr6/MPo+IAxqjX0yz4eDEywZCG6RQ5L5DSr4ll
	W6CdIRoTQ40ItKewc/fGK/xYo0kwzeM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eo9nYy+0;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQI9rbGkzgEVrFnWGLgOX3c21KQsbpUR3SBBzuEODv0=;
	b=65TRGvwUdlJgSekZtQA4gn3MtFeiasccFF9bPyc1MPuG/pssh1FhsuuYXaUn2NfyAStrr4
	Y915DCU5aWpx4g1xkbDF+tdehTUVWyKk7y2+wk4Na5GRONsBJoUOxv8oBqOTDNVSba9d3P
	tQI4+a+bVe36efU/zkW7Y2MQEBWZaNE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AF1D168F;
	Wed, 22 Jul 2026 08:31:26 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 72B903F66F;
	Wed, 22 Jul 2026 08:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734290; bh=EDS9AlMeDxpN0DuuA4Bhb7IK1Ve/HomsYNUzHrnpR4I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=eo9nYy+06fIf8UQQOHpRhtRbtJUHdIHU5M4nAex7G3P7astgDStgdt2hMeQyYAqSe
	 yo8B2FWjYpXyyHByHNmKAvHBdA0m4zv6FwrlLGp/vPnM/Thugqw0A32y7kI2is2ohe
	 HBjlOUMx1+Pk6p1UZMYZKJxrrKYZ3iaYd/Q0V6kQ=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:15 +0100
Subject: [PATCH RFC v2 07/20] mm/pgtable: define
 (pgd|p4d|pud)_offset_lockless() for folded page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-7-d9e4bad31e0a@arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
In-Reply-To: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2393; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=cKWNMRXsJxpGGQUCO3dJXUBeTYEap08Ll2GdMvnbC84=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOISgRJKMSvsCYR1STuAZc/EAmMgILlkU4XaH
 4rLJvbb3vSJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiEgAKCRBt1cPRWsUx
 MzugC/42IcDVD5LxkniPNsBlkfghPK1wDyrSWxWr7TeFTU6ejjtMKTztgT4RF+0h3SxczGZ3zfL
 m8DyL1Z/YOze8tkRyHQ+9aaZuP1UcIWo0J068oU8zBIGy/e1xo0qcFy+HNb5ifhKaSp/vqXVq7I
 /CORT3klFa/PhxiK1FiYRxln768srrbd+G4S7s/j5I0VRIJHf7rkLAoGqbP2sLn+dZ0b1UlggYJ
 1wr6TMPzn4sfrdgq6Hj8WYTYdddMWcODgOQkHiW0s0qaJW6UZo5f6Jqfonw5Wmhlqb7wj0c3MBq
 kjZxDGOUKw4fVaREwFlSqCNq/Rx7z7Kd4iwRp4lIuNcc0KPeY7Gpo3D67A+mXQmj2oItT5Oe4h5
 mJKipfT4xSDeBAnIDui/JSryAXoNEcWeMA/xfJfC1YGH7hZDa5rWPdbWplDOCWyd/9urEXKuKNo
 jIZ/6eL7alizPWnvSAgA0uJjIti7vbu5VdGE9+KfBk/IAandrmJNpv3QYgD22NJ68bnqY=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: octjrjg5xpqkcqjoqmxftbr5gaiubuas
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 372FF20003
X-Rspam-User: 
X-HE-Tag: 1784734290-260304
X-HE-Meta: U2FsdGVkX1+IB83eCdIojEwPacgPmlVN4mOBuzWxcWU0EaqkFa2YvxykAwGY12c/ogUXq22pNRhdGJgZ1hZ6VsEXGqZmw/i6E7cW5MFfAq0IVLkg7Tv4UMWUWebPMlghxHEAbhi24tISFkR6P6lKLhm74i2JMY2HSD3Nsz1xF2qB7DhtDzkksGSwan+FbtQhSIO/kOGz2BNbakFK80gxnyrsnijTsTcn/RYc0rq9KwrybS0Qa3bBWHpnQR6zGS8XqXNH6pvFkZ7jcYWaZfYZg4yJlBeyjrDlCZaqY0LAxfa4fBBXcLCgn0qtr99lin9633qboXv487aWHN+WF0Je/12ZzR1TLBZ4/8wYDQ2lRphfGISgyW5m9Ko3Hb3WdSYqjU9A61P2B1IjyApCICsVbo/tW7mSPcZW2uqH/uRocVMCVrMc5lMOOBKSZ3HMB0tkni2SyVpgzIS4V3/9SP34AxvwaC5xsQzRNt90po784UdXMThGIb6yDZWKYr+dHXkG61UdLpnTfAaH6dF183R8s1/x/VZ6VGaWcoCS9QgXdZrW4B/fhVFIKZI79arGu5D2Wdw8OxW6mx9K2hlMZ78tXAlqMYYhsJsZeebT+ITFQfNWw/I4v3Wj9nfEJm0J3/8fNiXFf3gJUl7JHBS9t84BJmClmPdiP88ebY+psy1jGAFUzhyehbKNboJiVmx3NeGxeCnqBE9kIkH7lcTRvI1NViR3UJRdtzCA/g15XC7/0yghGju7xo2//aXwYSmTU0FDaOUMGCKsk0DhZvKMLf8Ai2x0+CPQWwD2PLa1H6k3i3EjmJ1eB5rkEhyH4GCxFrxowB/+cI6jd6etUXhFswDb+Sn8pRBWb3DFk6nYWCOannBmDViOz1bDxnPIeHIeX/GqX2I26yhbIYCU3hml4Q2LSoSCFe/BnUtqUMSFXVv8wjcQO9sns9Zcn05yWeAEJzJ4fiIDrYM7nRD4JgSANLr
 OAGOxeXL
 YyIDOI7sa569bxR32nFKxPAQo770T3bkF7Ycdt/uqzen9v1kaltziE5noaSeKsWDIlKVbr21XXS1HtRxDle/Dx5NcE9pOBn9el4Vrl5f0ETixFAN8bVRXTs2lSNaHKNXBuJ6BkBHp/Gwa+lls+5f0QAVopCE2WUSnJsGNQikog5cTGbiv2reO3wxNlkF4CzvbktpQxUrz4GycqY7LYimR0myq9vU1O6Ue9wE3ggDVo1u5X3oqvwbef25dFx6dUifCANpYWeun5SezfFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

The default helpers fallback to pud_offset(), passing a pointer to the
stack value.

Let's provide variants that do exactly what (pgd|p4d|pud)_offset() do,
but ignore the passed pgd_t/p4d_t/pud_t, consequently not working on a
pointer to the stack value like the default handlers would.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/pgtable-nop4d.h | 7 +++++++
 include/asm-generic/pgtable-nopmd.h | 7 +++++++
 include/asm-generic/pgtable-nopud.h | 7 +++++++
 3 files changed, 21 insertions(+)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index c6a5a43899b5..019c3f074b77 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -39,6 +39,13 @@ static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
 	return (p4d_t *)pgd;
 }
 
+static inline p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd,
+		unsigned long address)
+{
+	return (p4d_t *)pgdp;
+}
+#define p4d_offset_lockless p4d_offset_lockless
+
 #define p4d_val(x)				(pgd_val((x).pgd))
 #define __p4d(x)				((p4d_t) { __pgd(x) })
 
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index dbd38b4c3a05..ae2eff44889a 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -50,6 +50,13 @@ static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
 }
 #define pmd_offset pmd_offset
 
+static inline pmd_t *pmd_offset_lockless(pud_t *pudp, pud_t pud,
+		unsigned long address)
+{
+	return (pmd_t *)pudp;
+}
+#define pmd_offset_lockless pmd_offset_lockless
+
 #define pmd_val(x)				(pud_val((x).pud))
 #define __pmd(x)				((pmd_t) { __pud(x) } )
 
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 6c9bca78047c..5a2b0a81ae19 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -47,6 +47,13 @@ static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
 }
 #define pud_offset pud_offset
 
+static inline pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d,
+		unsigned long address)
+{
+	return (pud_t *)p4dp;
+}
+#define pud_offset_lockless pud_offset_lockless
+
 #define pud_val(x)				(p4d_val((x).p4d))
 #define __pud(x)				((pud_t) { __p4d(x) })
 

-- 
2.43.0


