Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 064E2D5B17D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69DFE6B0062; Mon, 15 Dec 2025 10:04:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627A46B0088; Mon, 15 Dec 2025 10:04:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0136B0089; Mon, 15 Dec 2025 10:04:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 376CD6B0062
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:04:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06A4813352C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:59 +0000 (UTC)
X-FDA: 84222027918.02.0C06D75
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5790016000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765811097; a=rsa-sha256;
	cv=none;
	b=6A2HtfrJqxZgh3fn0Uj8tuaLgOzPIkmrA1EQy8WxIXEf7nw5uHCVBcI8xHKlPnZq3o6YnI
	3muxZ96CGsFxkeFO9FOTOKCHPZzRpAYklEiY9JfdSdWPqgOWSHWdPC1XCsQGRLZu4UQBse
	Dltypd2JEVrDVqZob/VIjYbAbsVWKP8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765811097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c1HVE5iTJsVXawLpc/SH/1Lz2/bA9CTwze4YimX69RY=;
	b=rtZEPXb6o13cOYgUVYFWCqRWrY99KwDssR1nVHufQ4rJu1WuLKxrdzuGAF63RQXMSwrOWz
	tQGBrcE94vVW1zo/f1TZmJEMmrK0LRvCBjekgzo7/oxDVfBpboXPr1EZAwgWXUHWH5HATh
	GrD5z+QVMvLyduACizqhsTixgH/PMxs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62D991713;
	Mon, 15 Dec 2025 07:04:49 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 41F803F73B;
	Mon, 15 Dec 2025 07:04:51 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
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
Subject: [PATCH v6 14/14] mm: Add basic tests for lazy_mmu
Date: Mon, 15 Dec 2025 15:03:23 +0000
Message-ID: <20251215150323.2218608-15-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251215150323.2218608-1-kevin.brodsky@arm.com>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5790016000A
X-Rspamd-Server: rspam03
X-Stat-Signature: ezytfcfsgcq8y15pg5o8rmatbj1exorq
X-Rspam-User: 
X-HE-Tag: 1765811097-667963
X-HE-Meta: U2FsdGVkX18dR7sfsiavMbHSgbTf/ii4rjQ5PP07m4DrhFG109pQz/vHqsMzKm0s8aexG3jHHO0bK3NsIlu2Yl6NU16nlY7lJlXgjrrqiPMmzhpWH9TBbentUNHN4cdX+i2aCP8Yn16ipIfQbfboWK4ZuxTh4CqbKZTCqqeZnNkALDYLXoDhzvI2PVvJDW1p5KAFYAbfHbXCm8fJrWmdWqn8pz3K5C8Hzffs9q/vw/ruSfHW7EcfflZ9stWhUtKotoYx4hAhhOkaYPJsUhYzil49NPH7CBzx/JBU4zNpHiyusfgtoQ2WJ4wgxJgqr+vP+RKZEo3O6pr69g5usx7PaT8WU3FmbNbze/WKI+Bb7YzyzYcHC91EWn35D1G/JUTV5k448gfIYy3CONUvG6tPgr4ipMUDCyS70lJvlNbzIx9OoNyVZFuOSNXe75HFteYm9Ix/228EvymgDv1NQS+K2udFj6WT9/nO8az2YfVfozHTwU/lHdJ209PdUiW3CXBmR7dybmOCU1DYdrHdcvDGjynl6gbGKpJGFB63Q/ZmjikMEycIIUzyeBqAD0M2SLVnk4T5XZ3u6Hyu4bErWzAEwcMfV1wdyRx3IjmEdbrFLMTHnIQsbr/3iY1VAk+G0PKig4v92XbCxmWU0odQM7KXDEMUB75XsGAQMqATtgin1wPjFrYEHV37eK8CyCOZrEe8Q5D+ZqbpRPYsgdvhJoSrb1WHYr8LalnD3h9JavNrt/TyOnFPboeGauCLy6X69arfblJ6A5df35TmMlOuLEQjCvw0vZT45c1hwtZ8cR8cSf8xwwSh5Dnlo0vC5oO1gO2Mh3cjJLNwbeeOGdq0NGWs/PVclBemlzBCV7YTGeGSJCK1p0ddaqWH7Dr6K/TVd14nHJEDhMO//wsQaUVfUrUGyUXztZCk5nBNA53q3bXhgyd2QqZlZefmG5C7DwMfxi4cBn9x6MZoOZWgUh3mUdo
 7KuUeRsj
 dOFGBhUTrtyv63TDuIg9toXovbw9HJGwCz6axKHDMPDuWnwyPiyn7L+rlViV0j/Pi8QsieU7/3xg65hthTV5ouA5ExFMWwioMFxTaTIUbpnEgVqTiiw1eX+ceI94toVv6VV4w/WEF/5Ec+mLLvodVTOs2Pwddjgixnqu1KrHdl5c0miGF+j6aOgRjO8hkqeRwAFOcjJxeBu8NMxzfnxAtsKVpt66wOxPjQuzW36/uuFMiktPWtbko9Go0PlomQirNuagDvPGYt8zHkZ2dSvcGM2wPTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add basic KUnit tests for the generic aspects of the lazy MMU mode:
ensure that it appears active when it should, depending on how
enable/disable and pause/resume pairs are nested.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 mm/Kconfig                     | 12 ++++++
 mm/Makefile                    |  1 +
 mm/tests/lazy_mmu_mode_kunit.c | 71 ++++++++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+)
 create mode 100644 mm/tests/lazy_mmu_mode_kunit.c

diff --git a/mm/Kconfig b/mm/Kconfig
index 62073bd61544..ac48deb44884 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1471,6 +1471,18 @@ config ARCH_HAS_LAZY_MMU_MODE
 	  MMU-related architectural state to be deferred until the mode is
 	  exited. See <linux/pgtable.h> for details.
 
+config LAZY_MMU_MODE_KUNIT_TEST
+	tristate "KUnit tests for the lazy MMU mode" if !KUNIT_ALL_TESTS
+	depends on ARCH_HAS_LAZY_MMU_MODE
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to check that the lazy MMU mode interface behaves
+	  as expected. Only tests for the generic interface are included (not
+	  architecture-specific behaviours).
+
+	  If unsure, say N.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 2d0570a16e5b..9175f8cc6565 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
+obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
diff --git a/mm/tests/lazy_mmu_mode_kunit.c b/mm/tests/lazy_mmu_mode_kunit.c
new file mode 100644
index 000000000000..2720eb995714
--- /dev/null
+++ b/mm/tests/lazy_mmu_mode_kunit.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <kunit/test.h>
+#include <linux/pgtable.h>
+
+static void expect_not_active(struct kunit *test)
+{
+	KUNIT_EXPECT_FALSE(test, is_lazy_mmu_mode_active());
+}
+
+static void expect_active(struct kunit *test)
+{
+	KUNIT_EXPECT_TRUE(test, is_lazy_mmu_mode_active());
+}
+
+static void lazy_mmu_mode_active(struct kunit *test)
+{
+	expect_not_active(test);
+
+	lazy_mmu_mode_enable();
+	expect_active(test);
+
+	{
+		/* Nested section */
+		lazy_mmu_mode_enable();
+		expect_active(test);
+
+		lazy_mmu_mode_disable();
+		expect_active(test);
+	}
+
+	{
+		/* Paused section */
+		lazy_mmu_mode_pause();
+		expect_not_active(test);
+
+		{
+			/* No effect (paused) */
+			lazy_mmu_mode_enable();
+			expect_not_active(test);
+
+			lazy_mmu_mode_disable();
+			expect_not_active(test);
+
+			lazy_mmu_mode_pause();
+			expect_not_active(test);
+
+			lazy_mmu_mode_resume();
+			expect_not_active(test);
+		}
+
+		lazy_mmu_mode_resume();
+		expect_active(test);
+	}
+
+	lazy_mmu_mode_disable();
+	expect_not_active(test);
+}
+
+static struct kunit_case lazy_mmu_mode_test_cases[] = {
+	KUNIT_CASE(lazy_mmu_mode_active),
+	{}
+};
+
+static struct kunit_suite lazy_mmu_mode_test_suite = {
+	.name = "lazy_mmu_mode",
+	.test_cases = lazy_mmu_mode_test_cases,
+};
+kunit_test_suite(lazy_mmu_mode_test_suite);
+
+MODULE_DESCRIPTION("Tests for the lazy MMU mode");
+MODULE_LICENSE("GPL");
-- 
2.51.2


