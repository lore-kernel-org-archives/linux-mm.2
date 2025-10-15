Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF66FCCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A8A8E000E; Wed, 15 Oct 2025 04:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB388E0002; Wed, 15 Oct 2025 04:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BA1C8E000E; Wed, 15 Oct 2025 04:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 19EC98E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:27:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE7BF13C080
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:27:55 +0000 (UTC)
X-FDA: 83999670510.29.A009213
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 520262000D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:27:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760516874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IvBg/qrrc40AR1SV0v31ykKJ4W4sLT9hazCJwA77IyM=;
	b=1rzKazwLc7OEDWv3vdXgUUE6USSG1xzDB5nyzUgAbdWQAqXE4H5cF6p2lH7savWSEeCuv6
	IdgnJD/xwWYWZrzDxI9AZihMHA6p5j8NbQW6PkTFQf86Ukis6BEBNdZYNCAmXWSVy6XY4R
	jglPXmLicGx1bBgmuI1bly2GrKtbaaE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760516874; a=rsa-sha256;
	cv=none;
	b=AXsAbK+kF/zYty74PhMfpasrCUjobAKNIARJvb68LNX1lmrbpe3OlTxIDtUWsNr2B8QDuf
	WpqZvg7gOKHUqa2R3DYEkBYT3zhpY9kV8QknciR+Tk+JyuVdU2miwK4Hdiz/0L7GQsd8Xv
	Q1NL/r/IrxB2l+/qo39Ak8MAFGzYEOs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 968DD22EA;
	Wed, 15 Oct 2025 01:27:45 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 400C13F66E;
	Wed, 15 Oct 2025 01:27:48 -0700 (PDT)
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
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	x86@kernel.org
Subject: [PATCH v3 02/13] x86/xen: simplify flush_lazy_mmu()
Date: Wed, 15 Oct 2025 09:27:16 +0100
Message-ID: <20251015082727.2395128-3-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251015082727.2395128-1-kevin.brodsky@arm.com>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 520262000D
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: t55kycc4r13uigpqwik5dehfbxob8e1q
X-HE-Tag: 1760516874-514582
X-HE-Meta: U2FsdGVkX1/PTmvrhOpjNNject+oMSoeHn0rFHX924qqim9TduGaHzSqD+4xrA48ZYTVyaIRUMz8rjwKMGrvlaNXhdi7j4fugJ6vsXSzSjVi7MI6xI06EihudKHpkbZ+RQXxiC1+/kTEJMCb5pVu6N06f4/vvoWOR38WPyVvs/h53UmWVwrJAn0bCWY3hpGwrtXWdd+GuVylOVFZQwUj4BtE45/fdRZpSCYlY7puZgvfA/s+2eG8fYHGLWIUqsBz81S2GxKtTXglGZZ/q5MQYUHBhYWeABoYLHQR3tJfFyI00k48L5U6+EKnWQfYiQNtoqBq7XW2VpBh8VeFuMdszU3so6bb19ciMFk0h5V6/7EGVwrXvgZKigjs2NtXw7Rr37WETCq9/+II9fFIaXc3li24XVwqRATmMZglro2HR3hDTDjE8n0fHeF+rejHMoFD7FAlWXaHptiCx9T8ZOp8I5jZSL1IjcOU2b4+vZxRdT1OfbaVggpXjm5T9dabw0uiYCznOyIkP3YTmUMvyetn9BQafPC7sV3BDLn4rgKWcX2CKx5QLQe3/J785MQWFNbtIZb+ayxonlX8h5TIafNfWW8kUmRR8UsuVUcAqqgBHt3k/H5jmJlCRjpE98m3scd8Tjgp+ANHcmbyrJmGtSlL+v3O2UoDjgEPFotcmY4kDVTTAPUDPD73eUUynW4xTAEi8OJkKqZlniLfiMT/YSsqq7PmpPLv0MNxW//kmGwWcqz891/XUStcJ7DU5NjbQ34XjQDYtd3JP35eqxSNZEIlDlF4BzYv85sDwsnXNrQa+hVHtkjkuV5qjy7ZxxzR7cHSS90bPVE9HTvBFEBU+Wp75Ypxo7DhGYKYq9iUsraNZ4fFJlkTGOkm3GTO6QeWlpafcG6a2bMSdvUSsUWY3Nh1a+S2MSsKFK92Ca06gebtlhAgce9awOkTP9twe4NLpkOfikfBPBvtnFVcFlwxT6b
 stvWVj+u
 SmuFNLNFE9MDArHxEIO/IA//rlcO6SOZE6l5MkUwhE+bBjE/XKzAAVZZuXx3jDATL+M1TSgAu8WVagcVJ6p9RxB3K+aI+ZbykeU83TufhfUFjaKxr5zRXTuilFey6F1kdHOTZ8MY9xXQQ/qTFsdTtNYtNJdbLKYlOz6sIRmx35OxyVc1uP6E3leWwyv1ZBfI9PX88Uncdr9HJTnA=
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

While at it, we can also avoid preempt_disable() if we are not
in lazy MMU mode - xen_get_lazy_mode() should tolerate preemption.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/x86/xen/mmu_pv.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index 2a4a8deaf612..dcb7b0989c32 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -2137,14 +2137,11 @@ static void xen_enter_lazy_mmu(void)
 
 static void xen_flush_lazy_mmu(void)
 {
-	preempt_disable();
-
 	if (xen_get_lazy_mode() == XEN_LAZY_MMU) {
-		arch_leave_lazy_mmu_mode();
-		arch_enter_lazy_mmu_mode();
+		preempt_disable();
+		xen_mc_flush();
+		preempt_enable();
 	}
-
-	preempt_enable();
 }
 
 static void __init xen_post_allocator_init(void)
-- 
2.47.0


