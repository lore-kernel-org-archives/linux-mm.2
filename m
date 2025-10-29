Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC125CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBC648E0051; Wed, 29 Oct 2025 06:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6B858E0045; Wed, 29 Oct 2025 06:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33D98E0051; Wed, 29 Oct 2025 06:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD1EC8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:10:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70C29C07E4
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:04 +0000 (UTC)
X-FDA: 84050731128.13.B3A93BC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id D76A84000D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761732603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qTnV0i06/09SpCKqB8E7ZEL3p/dD9TNWu4Sk0kLJbY0=;
	b=3aVz5KxZN1mwFQ/VCpDogJmG7cx4/ctGfw3kwzaRIVGKo0G66hckgIT1vUxLfq0mJ1qyUU
	ssdaFpCRECWN8sqsK34FapNQGFDrHJQnUdgG+pRxQAWhL/6Cti++ovbl9tYtkxdx2ivSv0
	I3JgLdCVuXuxObnm2MCytN49QCSsCcs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761732603; a=rsa-sha256;
	cv=none;
	b=pC+hMDSu/+YX/ZEbB5NWttlXyQXcLDNvxIMb+7KTVHFGF1JGjVf9/wMxqVu08ASVM5Ejt/
	VXJlNPP+LLSlw0gQs0JY/EOiMPuk9bVtyoMr/y+1J1jh3hPW3fQSO8JWl7LPKra+gAyucz
	3WFM2L+N7wEvkxDqrCq3UxD8Jeg7DC4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4895F2BCB;
	Wed, 29 Oct 2025 03:09:54 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 369DF3F66E;
	Wed, 29 Oct 2025 03:09:57 -0700 (PDT)
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
Subject: [PATCH v4 02/12] x86/xen: simplify flush_lazy_mmu()
Date: Wed, 29 Oct 2025 10:08:59 +0000
Message-ID: <20251029100909.3381140-3-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251029100909.3381140-1-kevin.brodsky@arm.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D76A84000D
X-Rspamd-Server: rspam02
X-Stat-Signature: oqk53md6bjyexxtnjachgi1jpi9g6ggm
X-HE-Tag: 1761732602-317576
X-HE-Meta: U2FsdGVkX195il3NiwUYKObqpg4G4BhLpx60OIrucSJ/9ZJ8YD4had/XVV+HuBZGXfuhnNlhJd9SC/6s4U731w8pjqVsCNM3R+a/AztLgfm+dzlRdRn8nF+NOrU6zoIb9k3FrGxHfbd5UNFMUTbUvixc+ZtAnic5zXuVEj8JN/JcZOi+JAeOTaPZXxHOMIYzKnpN73hGM8BL+f9A3QJp+yHYw8oZicAHJpXDfpM3t+Pecx2w+1MOP80Q5DDyI4IAOj2YGrz1ecC1zzvJR0eeYNAVXLOdpKE9b45iTi42AP43Zg5Fe4Ez8gCH+OJJhv2hczzWWysXDub6mYi+y3S57TOhuv72H/kfOZFB6ErX1G62VJkt53zf2OWwQ8bWgGjYR5xVQ46yrf9CygALUDmH51nPvAPOsannpZn7qDbyxpKEe+1wyv7SweatWvgYYSQzdpulGf/myg4B6qdKB5BpSimpNEJzAmkluEGfUUIZHj8YNUZ5JCSrXdcXNm3B/Fj1R3EfsRXXxEcZNj1Ueunjv+8M+o+dSBpcuoWB3s1UMBjV6bKRmBcyIuxtCUP5jf5MLvs5FWDmM5FFyNvOyIjfZbZXCWjPoh6NQq8ODROuOa/Wsdff8CwkQCa+svgOU6YeQVlYU16Wif/SGxSM82stLTQDrlv/iMSIEaM3PDsXH4CTX3ngQhuOD9zNYEN7owc87eJMuYLXYGTKpm3tugda51vOJhVhbB9r76TF6hus8/iYU2JmkJrugYFse9U2B5HV4QzK41i6QBTCsSntIuSwAMzou7mXYg6SlNvlm5p5PTaPKhokVP2q46koAI/leI8/Vlh0NJSS5vqGFrCLTDBA+qX5/vnu+pghGgMWur/LwaeemrFpjoULII1bgpniCrAqYjBVoCoKcH2nuJ3bQzVEyBCKA7IA+vIgLvVDBVxSvc0d5llATKKsX+QyYHgP1EGyi5VofYMANBVjzBdUVyI
 xmj5glIV
 7VPXnKr8rMckLgmyhnHD1rgsJDT7kVpyXo8M+UIfGOpbCRB4aGnA3HFkz4J97WT8BN9v2kTHwx3aC6tm1ih7aOwzwiu1gISMdtnWQ3swPB7Ml1lGmTx6z+1W2MIxc/SyBzpIWxIQaDclN4TxJqojm1A+VMgbOulQGpRfdboNB2vVQMdIiOJpAL5hPGNhcSTdJkrNvLudAJ+L1/EM=
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
2.47.0


