Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF271E9410B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201806B0088; Fri,  2 Jan 2026 02:02:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC1C6B00A0; Fri,  2 Jan 2026 02:02:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5136B00A2; Fri,  2 Jan 2026 02:02:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F16516B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:02:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A415A1B110
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:02:36 +0000 (UTC)
X-FDA: 84286130712.14.EC9ECCC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id EA200160005
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:02:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=esVw3TYK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337355; a=rsa-sha256;
	cv=none;
	b=i/shNcdbFnHUzVNgCm1A476HXBiPHYgSNhHReE7JE4sxl7a1mdB5lMbn/fLHcpaULr2ZL/
	blNSseYnEWPQlb0wpr/MFvfdrQNjcvwclmbFSCv38QZ/WpVy6Q5qK3IMC1RQjlpKDem5sp
	f09NU1VfAiNMDq/GPTYRFXMK6JnKSKo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=esVw3TYK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyJA9x7hsheLXPu5a74j6NhGqDdAk1HT6a+T9hWh9As=;
	b=pPmHWbA+ovipWYihtUuNzkAUJxoU8C/5On9ya5oqjN1vHEs8fOk8WRcR/JfczgINvMDeTo
	E5uM34sBgNMZlp8JHE7nq0reECDnxV84frd0k6a7SSM2lO5ijtBwZLHeQSpSh/uUf8G/NY
	0dhvQnDtrgLzG4W6+Y9eC9ckwzRAW9k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 18C57417BC;
	Fri,  2 Jan 2026 07:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18663C116B1;
	Fri,  2 Jan 2026 07:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337354;
	bh=BaQP+Uyb/5HYpSHuMHqe6vNV+NfiesFf3EGC4lY1beM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esVw3TYKANGcWz9BdswnN3jV33uwgwL8IHKDGMR/7IyAQVfT/CTl3CcsQ3ZKfTN4A
	 eIn2sNeDHdSd9GGZX7P1c+KErOINIYgmweOj+gHNg54in9HGd/rbahahPk8htVwrVV
	 RjGvwx9Jrnp+YFXOmHg5lpElgv220mnJ3usOyTqiTqTSgw7mKu3XYPy0FnI8mTHXfp
	 2exbx7Rwy0W9fA3Ily9xPCK0evD3T4GF+5RQAVhzRDZrNyKCbZkOLqkUuOBTO8lYms
	 qsZzC/6JNMarmUuc1XQYowUQZ9UFiH2ijv89KcrOjwMmVuUttw/ixViDIPYM1JGSTO
	 hqZyI8FRhz1bQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>,
	Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	x86@kernel.org,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-mm@kvack.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-um@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org
Subject: [PATCH v2 09/28] microblaze: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:45 +0200
Message-ID: <20260102070005.65328-10-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EA200160005
X-Rspamd-Server: rspam03
X-Stat-Signature: 8fygab3m7g6exbyhheynjdbjmnm5hfm7
X-Rspam-User: 
X-HE-Tag: 1767337354-410303
X-HE-Meta: U2FsdGVkX18NfwkpGCx8Grxmk9n6AXVDDJCWVRvcDCTWHJFNeoOBjgPEX7QKqZzuApa+jO7wvx9LTv4KB9w6qK614v3BeHo+H+vSzKgc6V26oz8DYL5yv9WfonekeE86QbV6cHV0d/3XETB2Zu3VisqNH63EVyuitW46rXJFan/DCtg/jCCp8CVq/SeJkocRg88CGw+uBOusqIJ3EWgc8uRV6bgSxmNIXpLfnG5KM1OTi90Cy8++eJOh2lP0T+8DSgh1WFpvXzYwyrLbAAk91HTkYU4hto+tcwXKLk1zyeEbkUtFzhyVGgmIc2LLffXBtNavHE5ynsBUpz7qxVlekvgL//fFYjoTw6AlJdmyLr4KxS0chciMMzYIEw9p8LcODmJLksgaypd3+J+D7yxk4GwVPghTlGMeIN0a2nQgDxjXNj2zseUI1ZXzC11LtEdkzexaoSg0PdQWqBoplEkCb1ngwaUzF2SNDlPkzOPJrGFcDDfzD0TvxNWZlo+eXUsk+q4wlR1qUWayqen3tDWT81oHBoMJfNJW+maAOKqE/2BtWT8ofP2pgX/psME41gpO682SsmVrOd3IaoJ6uvcDMNHWWmAFo0HHPK4lnsOmnGTbtzNBFWuJ3Dueu0Y3K+Mas2Jz+LNumOuHS+PrOIdrbTTtRsxbRAJlBQ7iv3r8Ttfv1rBFrYJFwLbYQFoecF5jCipdEH+4100t5juBpabGFEJVCxCHxVQWiaBVtyON4Ec12W7aGoZ76X5iXtXdcr4TYS60M9lrRDvUL8rpO4qiQb8BmBTQmMLG8iFXRTZxO9PoEEE61idMCuCM0p4FWcn8vFCOOH6i2jRafj6xW6Amf0J2Q7ZBHg27NCA1tuva2Mlz358h0QWxxb6EN/UVWCSl9sMQm1b1s3Dhvkuu6PnpXQ7rVJFkIQGQA7g/09l696bfJaOWRVQMTY85HAgeOocGtj3Oxk6KnVXEaTKuE4v
 YNSnwuOk
 FtfKdnykdEPRmAZX07qkMQFTxDJezilXQp6AcmRDN9RrtPPa2MJEjepEP+94+om1v0SVqzYFi8C4OU7wCNY4IHd9TDgdexmL3sK38rX+GZ8qdXV+SbDtKkubno81Q5cry/QfDgmF1XT+wUAtScIjU+blEFVxUbYp/awNrbdCe7CnLirOxQJNYGYsQHEb6lnu+LTRAry9TeMFKrxb0v/r8FZFXLEkYj16PN2LrztartT5KkPcYzeNMJ7s5Lb5pHmtx8Ii+iFvSbwSUc2ke3F520SVuVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Move calculations of zone limits to a dedicated arch_zone_limits_init()
function.

Later MM core will use this function as an architecture specific callback
during nodes and zones initialization and thus there won't be a need to
call free_area_init() from every architecture.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/microblaze/mm/init.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
index 31d475cdb1c5..54da60b81094 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -54,6 +54,16 @@ static void __init highmem_init(void)
 }
 #endif /* CONFIG_HIGHMEM */
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+#ifdef CONFIG_HIGHMEM
+	max_zone_pfns[ZONE_DMA] = max_low_pfn;
+	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
+#else
+	max_zone_pfns[ZONE_DMA] = max_pfn;
+#endif
+}
+
 /*
  * paging_init() sets up the page tables - in fact we've already done this.
  */
@@ -71,13 +81,8 @@ static void __init paging_init(void)
 
 #ifdef CONFIG_HIGHMEM
 	highmem_init();
-
-	zones_size[ZONE_DMA] = max_low_pfn;
-	zones_size[ZONE_HIGHMEM] = max_pfn;
-#else
-	zones_size[ZONE_DMA] = max_pfn;
 #endif
-
+	arch_zone_limits_init(zones_size);
 	/* We don't have holes in memory map */
 	free_area_init(zones_size);
 }
-- 
2.51.0


