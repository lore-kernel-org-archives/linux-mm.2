Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDCF2606EEB2
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kFwramWH
Received: by kanga.kvack.org (Postfix)
	id 1B52F6B05B5; Mon,  2 Nov 2026 09:40:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166E36B05B6; Mon,  2 Nov 2026 09:40:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0561C6B05B7; Mon,  2 Nov 2026 09:40:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D31446B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:40:14 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A8FC160140
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:40:14 +0000 (UTC)
X-FDA: 85390439148.08.46011A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5A7CD80008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:40:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kFwramWH;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793630412;
	b=pET6iX5ObWuo+TYjsuFTAYRiu+mIaywp7HAthApYs+Y2VZwjw751L4kdDiXKPNsZWpfgrR
	+FFOasqcW/VkQTxTasBCKgJEs93VoGOVV3FJ0UpxLSalp0fZLQXRF8yTAiGgODFGPJNCDW
	InMIWWOIEEvpEyo5DSIRpBO+P2b66po=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kFwramWH;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793630412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7uBd/GYdLFQ0CEP19uKqZRzW2Hvnv/oll3HrweZMRic=;
	b=0N9OKZJ/PytsGJ8XMuyzsn4aKIE8WGR9D+ML56axoFtamxEan+Ntf1pN3bOGHb+wx8ZJEC
	fWlEr667sFHE52/sg1ScE3axAoLX5nt6SxUftr0XYuezosvXIwVZ+iRsIwFexch59hr4+s
	+yJOt4UEh0zNbvwSJ5VGf8Hk1hK8A84=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0599605C6;
	Mon,  2 Nov 2026 14:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE481F00A18;
	Mon,  2 Nov 2026 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630411;
	bh=7uBd/GYdLFQ0CEP19uKqZRzW2Hvnv/oll3HrweZMRic=;
	h=From:To:Cc:Subject:Date;
	b=kFwramWH3q4LZc+EHXFHRLFBAhkDXk0ds79o9DIP5wQN4NwSbgtXXToP+FRQduDsl
	 NZPIFyYENNvV3IPRbBjyXVBbqQtS2PX9SuUNS4KlYAa5SfRQoE/bRjltg/VInj4gvS
	 OS+wnlLaGS5dtengjzg8olxodvsZmViJyByxE+wQwpAzzX/FaoymsmhFUYID1J3nb/
	 3E1OXtVzFaPy2HPAZ4BJIyfdFd48VEUWAY8vnb7gMOrdd2UfCDEvlp7Uf9IIJFHKey
	 +le8m4qjGlvGlDUXa+mN26n9AEmlwK71vosxZAPFbg151Gknea+Ko7uY2JwljZ9bfd
	 sgyRdCWIfERig==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0131C198003A;
	Mon,  2 Nov 2026 09:40:05 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 02 Nov 2026 09:40:07 -0500
X-ME-Sender: <xms:xaDoauklxqV1yISoZqqEQU_O12C2OvXDrHdnAKnCXr4dmAtjl82_kQ>
    <xme:xaDoaqttip7xUEQsOQUwEuaSyDpuGxcNAhaugKpLieqWMdWw9fzTKZAOoWokQ5mhE
    aymJJGAAXf4ajDSxzuQws668XviMG9XAqV_IS-kNDJccmicTrMvt6A>
X-ME-Received: <xmr:xaDoaqNkSJsJX4r5BiqWIK0-Vf8AKYffKcIfsh5tpXSuXGpO2OyQLLy4GNc>
X-ME-Proxy-Cause: dmFkZTFdGgpaIcHDSt9rb+8IuNb3XchGCgRezkU06/yEz0iVsG1TMMSUAk/+GfmBxks4K8
    jFRMZmXeelIVSiBTsFCeiZJVt0z0zLHpGDb4C0V2NnoSkOxMFGfNVqerfEkjUkJKd1VV2h
    kO7NVTN/EhLXLaf/EY00K5nGNiZaNIwXPGwaYET1jLLMtNBqhaTSxTfItiHiSJ+/mOpD4+
    xaQttZpmC9nTB4Yi9Wmc7Oc8KjmmOfoNyMP13iL1JRLlHC+y39ThwVZ6e0+IEwJW1t5SMD
    q0m388e4DIvw45gQq6g+YY3MpabW2e7aMawsd0p0suzj7F3qXeAft9JyuT+CKFMqK6MlnK
    AYxx1EJZoIiEHZ3XzTTjysAzKIOfs0cQMved6hhrqYDxFMatKj1rwF28cn8FPY9wcYzyOs
    lqudGPuOcTr3yVQJKb35jwTQV781eN9//bRIfMtnFSlVxwdknqoLeVkLdHLcY0fVhl2owN
    M4/c+RtL5maQC6piHNk7lUhH4tgIakeeZhjp6EDRFmT8PB/JxeKp6FXKGiTBVuDiLnnjv1
    x+nVI61iNL+KK8XUkYDy/UD606in8J28r2juARf1BQ4v4LK+NqEMzjWfwBpq4NaeqTkoRJ
    rjFyt67k7QMwyzSpYHQwz+/Q2eUZKNgGQEa4K/S9dlXvqUakrhq/HFXYwy7A
X-ME-Proxy: <xmx:xaDoakobJFUxokww3o_y1DgKovXny917N_V76sNsxVAvoOIMs5q-rQ>
    <xmx:xaDoar9zZKG7W_jDwYReXFL9raCAUIXZjqFNVkScluqwhZFrAs2ZUw>
    <xmx:xaDoaropARx5eyQQiVnl3gIv_ZkqXdpdHuTWV2XkdYmfDjf5sGcicQ>
    <xmx:xaDoahggMQRTyuay3-E-7b-jut25ytordexdkN17zGvppmRMbAOF3A>
    <xmx:xaDoahBLvMMtOFS1KIWLK3RRg3PVxs2rlfM5FQTKS3ef_eYOk1NNwmva>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Nov 2026 09:40:04 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Donnellan <andrew+kernel@donnellan.id.au>,
	Rohan McLure <rmclure@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] x86/mm: Define the zapped-entry checks only with CONFIG_DEBUG_VM
Date: Mon,  2 Nov 2026 14:39:59 +0000
Message-ID: <20261102144001.342837-1-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A7CD80008
X-Stat-Signature: otibhhum1hr5r3meurq3awizsbpwpz1m
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793630412-886164
X-HE-Meta: U2FsdGVkX1+Y4IC3u2GEERjevdKpZDsv1E0DE0Z2aU67aw5Xtd/An7FkG7spHGkYtzVtS4jemUzzbw9m1tOCJd/Syge9otd59gakFToB6G3J6YlcbJtA1btvGtujko3unHClHr57q/laJDtg2uMbd/UwFUAylt9O+X1I9rg9lyQJVROoNkbIKx7P7jU4DWnL4ckyvh2WWp0QD3y6HBZ7aVBukLYZ3sFzfLiqbxnMO6dyh6cyIT80gERSWAdAozu8MFS3BTfBz4NQLJQiLQxTJWdWrcun7o4FlEyQgECHFVFe4yFKFp9WXTdJl4OCt9oSPXne/aeUEsHWzPmpHl2ZzGlb4QuwNkmjEeS/u44C2UAN2Jdaz+uhpNqQpOBAQeFlG9eKRImo7ATLmHobmTcu5qWX6KIuzYJzmhwcM4WdVfvW6V0/kXtfmIe35zaEKkSKEp2F4nO/rZyt7CtqqX/ip6PDyWtkpVIfnjOk1tQ+diDAcosI4pqR66I5HFh2AekhLhpEBizw2K3SmQ0ckkRnBQBy8asG0siaoYFb7613APmYvfO8B54tfBUJE685rP5fnG5lW9l3vyHZgjiviLfWE7bb+7v0j2SuhewQhIH+aUsTFLrmdoUUiMpem8wm5spw2Nw6xZVUGcGm6t+G0g2lXD/MdFFsl1dJYNeRIqtXDIKH8g8TEBcMDLx3uLvpbuAxrW4aCyqYY9kL1EpeXQMQ+R7xqvPuDM/9ZEDkFADHhhSrLXE7dVZ7lOm/O41nTqJDqs/7Sa/ypx01x/paU9171JJy1GCy7rDC2Zcm7eP6dgk24VYG9en/I3OFGsmoAMf2/BYDNP8DkjMHfVdtGj4dP/lBl1XAqZE+2/W1ZZcmXBRIkF2P9hdRWa7CgcAB7XmZB7FWUPbmiC5FOqtlBC1PCxIADwSIwQkKvS89zfp4UMCyp7qXr2jLpehQebd93eGheqoTtouAyTM8LUAOvBg
 4P3BR4Yu
 nn9IvpsMT4Jqpjs9cy/syaZPOydhW/lI8f21h9VIetfZbX5AdMjfXEKzTD9++qcD7Pew4Px8hHQb961q2Z/2vNGWNHKdjeGHRR9lUfodqoNNC4ka/mhLUdcmIEG2zvKkm1zQF6SkhyT2tRDzctvj5P56/P2oekIvp+cbr+pDVtSDbjFdrRGQHQxNg+93cYBgKv8b/hye/Ut/Zb73y9+Epq8p4Iyem0G8UPtNfzdPwyN1eMAFGsFzwIeNqsIGAl7w9QN5i1QDeODkzWlV1qmPJBHpuHFtjXPjfTRAOyhx0qtfPW20FExw3CAPQ3ENW0c0t70foLuOdc8PYvKHDWOvvTJae84J2DUGFDkjunEAg3wy6rVFuoPfvbz43ne6lYLgspPw9cS0IccEE6wvE/8YGPG8x37R8DCU0Sg4GpgIgitEVi3pPDsnNyPdS7pXTgVSxOgt0UMxDp9g5458=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zapping a range calls arch_check_zapped_pte() for every batch of PTEs,
which is every page for small folios, and arch_check_zapped_pmd() or
arch_check_zapped_pud() for every huge leaf. On x86 these are out-of-line
functions whose only content is a VM_WARN_ON_ONCE(), so without
CONFIG_DEBUG_VM they are empty, but the call remains. With the SRSO "Safe
RET" mitigation the return of every such call mispredicts.

Declare and define the checks only with CONFIG_DEBUG_VM. Otherwise the
empty inlines from <linux/pgtable.h> apply, as on every other
architecture. They cannot be inlines in <asm/pgtable.h>: VM_SHADOW_STACK
is defined in <linux/mm.h> after it includes <linux/pgtable.h>.

In a KVM guest on Zen 4 with Safe RET, zapping 4K pages takes one branch
miss per page fewer. MADV_DONTNEED of 1 GiB gets 6% faster on anonymous
memory and 8% on shmem, munmap() 5%. THP is unchanged.

Fixes: e5136e876581 ("mm: Warn on shadow stack memory in wrong vma")
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 arch/x86/include/asm/pgtable.h | 2 ++
 arch/x86/mm/pgtable.c          | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 000fc6c1ca37..9b03a316fb75 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1666,6 +1666,7 @@ static inline bool arch_has_pfn_modify_check(void)
 	return boot_cpu_has_bug(X86_BUG_L1TF);
 }
 
+#ifdef CONFIG_DEBUG_VM
 #define arch_check_zapped_pte arch_check_zapped_pte
 void arch_check_zapped_pte(struct vm_area_struct *vma, pte_t pte);
 
@@ -1674,6 +1675,7 @@ void arch_check_zapped_pmd(struct vm_area_struct *vma, pmd_t pmd);
 
 #define arch_check_zapped_pud arch_check_zapped_pud
 void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud);
+#endif
 
 #ifdef CONFIG_XEN_PV
 #define arch_has_hw_nonleaf_pmd_young arch_has_hw_nonleaf_pmd_young
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 4a105f283cfb..3352bc6904f3 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -798,6 +798,7 @@ pmd_t pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
 	return pmd_clear_saveddirty(pmd);
 }
 
+#ifdef CONFIG_DEBUG_VM
 void arch_check_zapped_pte(struct vm_area_struct *vma, pte_t pte)
 {
 	/*
@@ -823,3 +824,4 @@ void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud)
 	/* See note in arch_check_zapped_pte() */
 	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) && pud_shstk(pud));
 }
+#endif
-- 
2.54.0


