Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42796CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 13:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E4A6B0027; Mon, 24 Nov 2025 08:22:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EEE46B0028; Mon, 24 Nov 2025 08:22:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DDB96B0029; Mon, 24 Nov 2025 08:22:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1D66B0027
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:22:56 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3306858AC7
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:22:56 +0000 (UTC)
X-FDA: 84145565952.21.0831E9C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 88C5114000A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:22:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763990574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vgN1Dl8//YP4AAH7YH7ckHY2/xdqQ5K9UykyI+hwA0g=;
	b=AftZ/6VrEQ0Sq+9spg8xIe0jkNVXfr3VZ8eLhOe9w8c82EhsQTdJDspbfU2tBnUXzBF2F0
	mudigTCsfPcyQBboCQBg3WuuLgPlgBkvfsmb9R1ZKn+gt7SfQTJJxN11useQMy6CNe5cCU
	9RVhPiD0dz4XMZrsMLtt8Zhe9mlGUkI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763990574; a=rsa-sha256;
	cv=none;
	b=ocMUBOUTE9iMOeruqtNMQkNFq8g1qvF1AqZk+9e6DHbUr3N0RKYkeDP1yi7iGP0yKSpx3C
	qCqtwc58DXSMpyCi5yvW0KwhOm9n3kfndDIZyn/eE2evlO1p7OQrUNQCv3gqCNnobS0z++
	Ja/vpGfJgubhfun2v0fRqV2DDtcaTxU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 351551515;
	Mon, 24 Nov 2025 05:22:46 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 85C673F73B;
	Mon, 24 Nov 2025 05:22:48 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Juergen Gross <jgross@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	x86@kernel.org
Subject: [PATCH v5 02/12] x86/xen: simplify flush_lazy_mmu()
Date: Mon, 24 Nov 2025 13:22:18 +0000
Message-ID: <20251124132228.622678-3-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251124132228.622678-1-kevin.brodsky@arm.com>
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 88C5114000A
X-Stat-Signature: 6d3nmq96yr1kemcr87xy94xjdup1h8rp
X-HE-Tag: 1763990574-62627
X-HE-Meta: U2FsdGVkX1+3RJD+VMmnlT0s94oTipTyKQrY2IVx1/z2kglv3QdQ6ThezFrhBq4edXvg7ELnJha1F1f5vvSmx8MS2FrFkq6jZHFC9IW/DbYd41HFLmVTB+I9NUGBpQCS8hAb02C1/DGt5sM4G5f8RH27gezmTTtEQ5cqo5PHk/16N5kutpqEKiLR3iirV8aPN53JyI3ChN1BBs42LnKc5+iagZYuBZl2JYd4DpTTLS7efrYWcmMMWo7FwToZ1duT18ui5FgX2rAM5pfGAA7UxjpDijKhO06Sog5bCL5TrTK5eyJJFYvh7uRkzz8B+GIGzxmAie5K3nXn/vbZbY8cS5zbdS57WMfEh5lXkBmYCnY54wVlx05+3o8BuEnwZ69LDoq/rYJoFI7s7D/gsVwDbTXPxPaKz+FHWnA0y51Cty0O6KLPWLfzVUtZpaRQBeIxaP60ePX0kCoChsy7fzFsjhA/m/HPzhNEiymIjMa/VEkeZiLl07ObU/jStTsTFRy2pAqo40yuTbTopW9JzltHJ6uiIdj6QP15XbJK6+sRcoeohLljTGXwXZG5Eu0KmVydgEvMd+OGBXBB7PSLoIhsj8ucICJyW/f4oPoaQEG3kj1OG5CORot9WG8UaeRJTW0ACXaCTXq3+yFtm21IznfIWCwvQaL0U8uROPuxksweK+SArwy9ztDJw6YTzizDw97RRR/AoBrES1EQTYNsnY4etPE6UWiUTUyzdrNmf9+gwxe/32WFwnOMPf5lBQ/KRtOAgmic5A3wKxxIjNorerGEge0gU1MnY3R9mKldU/4jMKX7SbrR4xVv26r180Cl5ApSXUKUqpI6yZBKJp0jHrBaXfsUQmQBAZy4m64/Q9Lgce6G4CtykzA5iJ4XJttlM1i/xi4Oi94q1a3POJj/2o64d5jHAhKTwiQsbqatBwSwOZ4sekjWZl8TbRfrBBx1IrXGGbxjx2VQdIYcMvIfPgn
 DayllG7e
 gBMDhA7d5fPe9EQ48Ohs19uEa1MTbLBdzykodVSFr1oXLMO2T8Vr7ZON5/p0W9vIX5X3azqH63m7ac8+6O+5aWyyMroSV1rFq/jVDBFLBHaFokZO0elkIvriGeh8tksxqiDMFe2SzNQtqVPLt1/hyU7ujfQkgYfAa2PMgWiGf0vdea+lC2C4168UjxNVkM9CUqMZl8EC5Oi4Xv8qqBuNft9NJLBzHMpy2rNmgFuVKnTt4q/zvJCEZbK3bCuJcs38NW2ghbANXDUgl+mAhauTFvLtJaEFwfwVE+bjLuMFxGWPypNiBRAaQheka1qobgg1NGxdiQ+aI2HKz5PJd7EbVnmFApFohsu7lN3qd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

arch_flush_lazy_mmu_mode() is called when outstanding batched
pgtable operations must be completed immediately. There should
however be no need to leave and re-enter lazy MMU completely. The
only part of that sequence that we really need is xen_mc_flush();
call it directly.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/x86/xen/mmu_pv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index 2a4a8deaf612..7a35c3393df4 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -2139,10 +2139,8 @@ static void xen_flush_lazy_mmu(void)
 {
 	preempt_disable();
 
-	if (xen_get_lazy_mode() == XEN_LAZY_MMU) {
-		arch_leave_lazy_mmu_mode();
-		arch_enter_lazy_mmu_mode();
-	}
+	if (xen_get_lazy_mode() == XEN_LAZY_MMU)
+		xen_mc_flush();
 
 	preempt_enable();
 }
-- 
2.51.2


