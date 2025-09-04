Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B538DCA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04FF18E0015; Thu,  4 Sep 2025 08:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027268E0013; Thu,  4 Sep 2025 08:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31A48E0015; Thu,  4 Sep 2025 08:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CFD658E0013
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:58:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6978B8483D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:58:38 +0000 (UTC)
X-FDA: 83851571916.25.BC3C2C9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 967CE20013
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:58:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756990716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CcBj7SkfGcRisUp144Doi/BeLUzFNWGgepHeyPHMYvQ=;
	b=bBPnMbeFDS6hSBC4I5y0Z8eDnkCGULmoBdOakSJZeNNg76GpXw4b02wvFRBnKuSZZOZ+Sa
	UvMqCZ/ydn5nJJ79OZ7bYHh0NmQF4bQmyFu7m00UnYUJmI2GDB+lE2CX7+ILtSpHceotvM
	Qt0xnc2ibmNYFIf0KLmHXFX/S9KdRZY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756990716; a=rsa-sha256;
	cv=none;
	b=fveo9nMZj12fplvc1GONd5GdlVRJdKAap06ZTTtwJ2xp+xvwuK6aNoXt4YrliyZIDY56WC
	Fc25adOUFxnk6edgrM7vp3kF72axZtinJ3tyiuRUsx88N2asw2Aw7TL9Lpa51qkuLulegQ
	VYFFQVWSxrac6wFFQNqFroabtYAAVpA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A9CE2EC6;
	Thu,  4 Sep 2025 05:58:27 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17AC83F6A8;
	Thu,  4 Sep 2025 05:58:30 -0700 (PDT)
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
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH 3/7] arm64: mm: fully support nested lazy_mmu sections
Date: Thu,  4 Sep 2025 13:57:32 +0100
Message-ID: <20250904125736.3918646-4-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250904125736.3918646-1-kevin.brodsky@arm.com>
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 967CE20013
X-Rspam-User: 
X-Stat-Signature: fz8griwrzu11czynettg8gzrfkhc9k4q
X-Rspamd-Server: rspam09
X-HE-Tag: 1756990716-739086
X-HE-Meta: U2FsdGVkX18L7sHlcVIFns20mWRVEjcAG8KGsiFu+C6pTA/Ol08xTKZorAMKpre995PzNz6xpkBUgQSgUHS3Kmtk00HnMBSZSULGoaA+qOoLrBTkFFFzj3V9pY+LFLJ/mBjZeI86A4rT8Gd5KhbQpn6vC28RHXTZUv3nbM+7Kb7wcQDGq3sDq7NmnZHjx4LCnpfhXXVjnHkqTZHZP4N5Lr6irwIManMudaTvWx94pVgIYcBvA+MP6WLWBbKlbR4NWOz8MJ+n/4goM4aGEG6yoYyXh4CODTNboH30mGPirVBnJTICSaWlhftCV6cWizWonvO8GXSqojH9nhTUqUSipqfbiOW97+qQXjcQgS3P0O4WHZ2t3C9vDD5jJea9VskU53tadJnET2MFlPcduSHgANU4nXqGXf3B24zIDa6e68tkvkxtKUARCutC2eIJLYWXmuyG/rNoYxzv5CFKGzfyUtIQANVYgITkId8NzF6f/l+M2/r8D8HgiBqkf38KTgTYV1CUdkKSTKRpTFGoK1SAvkEEGH2mLy2qultnFQDE68AFym8d/v0ysanXp5FKjhEkWeaXcUuoz8/F9v1muZ34qOsA6aR7nHgOWmr8XNxO35Jw/1mN+QxvVHfNYsR7KuH1+olH2q7pYV6c5nTP9jlObMC2Gv0w+7tnEXAtjDBg//hVW9QeRYN0zA8nvwI5LoGGdEYCMjS/p7s3IksgTjzvm4+L9Ij1LBI4xQHSrbZSwzh/JrwAfNV1NhV7TD65N252UYhQtaK7uFCE8ghaKnub3a0D/n6fcvO1r8OnDTjt9GjYUHu0Iyj9Yq+dWXxwu29EnU5RtE/gzNB2hN00I2Zo8L4+pBPSsD9+iy5AstmqENBZeDj/nNFi2srTqRHqLHDY+ahAnWdt/dTOmtrLpCZWg9ZPa2RsrUgkwKMlzmSpnKyV9KmKV+W9bCbAfcoNw64umC8AAGT0XQVnmx+qcDV
 RIqLxRPw
 snD12EtuY4FGVJTsj7uhzMDcDsvsm5OAzZNe3RYUzeoXzrVlBWZlVBGtuol+eX0GdCi4m+laBbL42cyli9x6SGs7o3map5GXqqwMZEFbPO9GwGsFendNmOBXBYGcZA2oD/gl5isgLoIuAH63ghoG4gl7QY2U//W+UczaR4jr3PFSuWi/K10RlPKLu9IFc7SgwJWRy34QgEekKSSk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Despite recent efforts to prevent lazy_mmu sections from nesting, it
remains difficult to ensure that it never occurs - and in fact it
does occur on arm64 in certain situations (CONFIG_DEBUG_PAGEALLOC).
Commit 1ef3095b1405 ("arm64/mm: Permit lazy_mmu_mode to be nested")
made nesting tolerable on arm64, but without truly supporting it:
the inner leave() call clears TIF_LAZY_MMU, disabling the batching
optimisation before the outer section ends.

Now that the lazy_mmu API allows enter() to pass through a state to
the matching leave() call, we can actually support nesting. If
enter() is called inside an active lazy_mmu section, TIF_LAZY_MMU
will already be set, and we can then return LAZY_MMU_NESTED to
instruct the matching leave() call not to clear TIF_LAZY_MMU.

The only effect of this patch is to ensure that TIF_LAZY_MMU (and
therefore the batching optimisation) remains set until the outermost
lazy_mmu section ends. leave() still emits barriers if needed,
regardless of the nesting level, as the caller may expect any
page table changes to become visible when leave() returns.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 816197d08165..602feda97dc4 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -85,24 +85,14 @@ typedef int lazy_mmu_state_t;
 
 static inline lazy_mmu_state_t arch_enter_lazy_mmu_mode(void)
 {
-	/*
-	 * lazy_mmu_mode is not supposed to permit nesting. But in practice this
-	 * does happen with CONFIG_DEBUG_PAGEALLOC, where a page allocation
-	 * inside a lazy_mmu_mode section (such as zap_pte_range()) will change
-	 * permissions on the linear map with apply_to_page_range(), which
-	 * re-enters lazy_mmu_mode. So we tolerate nesting in our
-	 * implementation. The first call to arch_leave_lazy_mmu_mode() will
-	 * flush and clear the flag such that the remainder of the work in the
-	 * outer nest behaves as if outside of lazy mmu mode. This is safe and
-	 * keeps tracking simple.
-	 */
+	int lazy_mmu_nested;
 
 	if (in_interrupt())
 		return LAZY_MMU_DEFAULT;
 
-	set_thread_flag(TIF_LAZY_MMU);
+	lazy_mmu_nested = test_and_set_thread_flag(TIF_LAZY_MMU);
 
-	return LAZY_MMU_DEFAULT;
+	return lazy_mmu_nested ? LAZY_MMU_NESTED : LAZY_MMU_DEFAULT;
 }
 
 static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
@@ -113,7 +103,8 @@ static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
 	if (test_and_clear_thread_flag(TIF_LAZY_MMU_PENDING))
 		emit_pte_barriers();
 
-	clear_thread_flag(TIF_LAZY_MMU);
+	if (state != LAZY_MMU_NESTED)
+		clear_thread_flag(TIF_LAZY_MMU);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-- 
2.47.0


