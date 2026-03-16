Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BDDAF506CE
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7B76B0282; Mon, 16 Mar 2026 09:09:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78D96B0284; Mon, 16 Mar 2026 09:09:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7A316B0285; Mon, 16 Mar 2026 09:09:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BD96D6B0282
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:09:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89E12139E9A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:48 +0000 (UTC)
X-FDA: 84551958456.20.E7CD699
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id CAF5E4000F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GoYjdYK+;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QgtlNgL5opTpBn73U5l71gRYTR0A4QeyxntZU129xEE=;
	b=UMF8wluv6b5erGus4WkYlKQY41L7KXuKAM0h6N0ZslNl49b6Ezf7r0byd0GagaVBiZm5tj
	r5bnkpww1X+5sYKIPOsGWUNZPDsfZFbGtoKplS6+K0pi0l/6XgfWxMeOYSR3NJVUAOGWr2
	51e+U/+F7xrXlPB8sy3A+UWdfHm7/Cg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666587; a=rsa-sha256;
	cv=none;
	b=an5ONOqbjzsEAf5zgq6NzpJUgFF1brNOgiAWks5AHKEtXF5rDy+Vv9xcVG6N530fw6KxPn
	V567uPkr5o3bnEMJ4LOhKF4gMLbS2iCIJb13z4iOvCgJZi73MUYHvM96e0RiJnxtfD9/E+
	N7CEfmuCu+lmQk7IT4YNpQt2YWgsMuo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GoYjdYK+;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA3284082E;
	Mon, 16 Mar 2026 13:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B5AC2BC87;
	Mon, 16 Mar 2026 13:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666585;
	bh=cshoMqhmsXn21+m564V6gRodJOxo+/21XTwmvJpWcIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoYjdYK+uvokPnGKuT3tc4SmdUKqIx09gnlf1i1/a6ik3xs2zAiEgRyMQmBT7XnHq
	 5W0IXEMJIsxuNBLQoFNXi+P7nWI71CHQCAclhg6VRgt3ctqVGnmM0+ba8uvws/wIzN
	 WHLV4C8QGtteLWCCHBdv5Ri58aZ95Cmo+uDYbFCBwbVw2TH0mo+x0PQuZWczCJa7lF
	 0WrejdRKjymUGNI5gFdHuyMUwTEDpsxZZroj6vnq3ALslUw5YYLkoz87Ksi63EALhr
	 4DEgEdhyB8ia4nSpei+grNhfrdUn/u5yx27XEj6UK9j6N/d+BrLJXs+U0omOi8nV/n
	 UH0Yws4m9dtZQ==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vineet Gupta <vgupta@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH v2 18/23] mm: update vma_supports_mlock() to use new VMA flags
Date: Mon, 16 Mar 2026 13:08:07 +0000
Message-ID: <2f82b5b93599e89b391ee4672928cefdfd2fb2f8.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CAF5E4000F
X-Stat-Signature: wtsdi7su9aazra37wjdoyx7fzbddbkco
X-Rspam-User: 
X-HE-Tag: 1773666586-374331
X-HE-Meta: U2FsdGVkX1+45ohsCtjy1lWbKzKo37/oYRiUPOm6ZEKcLzMGKkp4reMDHMDypWkV4eVYxYAJZR78Hoa9sFOEeOME0IQ8vSNoMRlKdapq40C/Wje/MQGc1BCKnfxMi0rCNB4Ni7wZeLBHmJc2oSHm2y9NpLLBq2EN+VF18Vz/AGNX92WhUT08rLAOmhaulgh2qE5+x9ZlLUoyKr2b8XNIA4OIyblXMz9H/VKmXhvXbFWHz7J2vLfMfD8n2kqzyan4j6t3Z/5fJojWW+a3/Oz7JdXDVFyQAoQq9gYqkUqBD3IHhI3Ei0juL3ncLotwU+INtJFwXfHnVz0GUD8r9kBQzX8pN7AYw0UpqmzRs/1d8EF8KlCdDSGxNPfinnBlQlVJCrbfqi5LonkBRCEbPn7S525Dd/+vpPVTFLdS7DfElc7aLHA2Dsl5FhovG5BTp13iAboHm+w9XANNtNIK4b/ZX6hfDzVAb+OUaNUvOQi3lFI8fLRUOA1gP0+bfa4gh18wY5zUjuML1oeUfbFX4R7gSzFsTk1WQwEXVjDI0G2SVSePXXm5kCuiTKcTAcr3VBu630QvsCxBXeEkqoX/zWpcr+zZmc0FjjB3y+MIAusMaQbB6CDtF8NapX4jtuvqH97MiHZeovvVS70ltmgPx5dyy+gGPyjSLhjyFJ8c+EQKvvyku56KrUFvney25bjBkMpwYdJSBWJ0EbFMiTaG9bfL8zBEPK+75RRPJ4GVWvbjDxX2EA4bTDmoCPRd9b5JQc/kX0O8kDp8LSImWsJr4A132BLfK1AvKG0YTIEJ95O7jxds0awP3s57jDSks1bkyMVODmDfeAqLBAcjBAKAfGxaXSn48qVakDieqiP+wCfcPfFWXxplBYJVxrT/QIE3qp8i4W4Hyak2LMoSbkfTA322kfJZaI+nqdIM0r0dD2ldPtjeiwQsRiTGijeopsAttTpK5UVblLGWrrnynkWPY2K
 b+UJqSWP
 eBzGHg9J5ORk6oQyxKsbTu6HcrPuwDOLZ2vTpQ5Tcb9TQDoJ2jIFQuMER+SHKtHDko30RuIKC0T0j8zgqy7dycpcr5UaZtIcOQgsoNqfzTrcRCU7OicxmTlV+2Tyq0CReflvD5xc/tnRB+X0VAshmQMGdZgozY3JU20G0sp1kgjdhidU2+4zfCC4vsih2bI3rflaSQBVgGAuQ8eJbWj5wo07r6nO4efrrpgL1UUrIACshgR5RRq6W47pGGb3qFGDLoKZrSigpRLq2FkwO3Jrbwx+KBl9pH+tS3wnRLvd/ebO+ynVHQWWkUeecCHxzOu0TjzsD909zT6YGeHUEr5LFt+FU1z3D/d8W+IYr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We now have the ability to test all of this using the new vma_flags_t
approach, so let's do so.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/internal.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 80d8651441a7..708d240b4198 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1252,7 +1252,9 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
 
 static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_SPECIAL | VM_DROPPABLE))
+	if (vma_test_any_mask(vma, VMA_SPECIAL_FLAGS))
+		return false;
+	if (vma_test_single_mask(vma, VMA_DROPPABLE))
 		return false;
 	if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
 		return false;
-- 
2.53.0


