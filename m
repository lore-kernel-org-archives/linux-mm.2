Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A409EEB57A
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B003F6B00A3; Fri,  2 Jan 2026 02:03:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA0E86B00A5; Fri,  2 Jan 2026 02:03:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9996D6B00A6; Fri,  2 Jan 2026 02:03:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 853086B00A3
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:03:05 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54E47B88BA
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:03:05 +0000 (UTC)
X-FDA: 84286131930.19.FC05EA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A36F0180004
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:03:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qc3KtC8A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337383; a=rsa-sha256;
	cv=none;
	b=RIh/aiXy6b9R85QljQcCvGeecNBKV0B77poKzfrln0fRK8UqadS1TEMtwGnh3h1rh/N9Tg
	9xKhvNp8QG3tBmyZi14ffyst22+Y0mDgEx3ToQ9Vv9GLq8iVopa76C/iBryx3yxfRp02KT
	LPLcc1B/n925wW2GMNMFmsXsKV76zsc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qc3KtC8A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Amvc2bHxtbhQlfK6qJaZpELNOKeDaTKBZTuouOmWWwU=;
	b=n/ql+WFxwp/n36B5OVL86tjmk0W54G86ylRpdgsL0q025AcVtwPi7UzRIej6MmC/ye0r4+
	fJN4uEvoIDcSptkclAVr+y7IMgX8C6Tdv/+OiUiBRhYVw7B3OorhMkINcp6gMu6xjk0oIO
	nebf8Z9Kth6ReBOYDYXSx9dUzx4QKqY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C84DE417BC;
	Fri,  2 Jan 2026 07:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5CCC116B1;
	Fri,  2 Jan 2026 07:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337382;
	bh=5jwx79jcXEjB7Ff6jLyMimZz3LM3kE0UW0s3xt/n05M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qc3KtC8AFQ4d+AoWxnHd46tYFFfMCGfOgOZUwh7hPQu9V8GFwrLzacStrzurwyzfC
	 sdwYpZL4opkD8ED1iFsJX1g4ynL3fYl4iZYIf26rGnmUqy0aoVseX41udl1joc8YLN
	 b0l9aUDPoXNxkdtYtfpSrEipGrF3lv2aQvh/qrppryP5vxo149ycZiPv97YUg7SIVs
	 xtERSPPWxwE1pVRnHfO3RI7nXLXJVR0hJDFKbLCkEZx9FVFXZmkpvgHHbGy8xsHI3K
	 Muwf6NAlMOUSvFCm5/CFJwqbJNZUpLRWnYHLvjecYRlXI66YkfrDYdiK5VvE3i/rvK
	 7Je6uYZRC2PQg==
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
Subject: [PATCH v2 11/28] nios2: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:47 +0200
Message-ID: <20260102070005.65328-12-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A36F0180004
X-Stat-Signature: 4h1newy4eyiq5ppg53p6cjo9fjjjd55a
X-HE-Tag: 1767337383-324031
X-HE-Meta: U2FsdGVkX19q9U5RXyMzroqIzjNYvSut4u5RioRYBQ2LDQ2+tcTaha5jK5Lzh3h9lh+m+nkZM8tA1lvKtIkjorjs5CfVSi/lrYtay40hbwqd6Xhx1fELFP0EX2S+oZQ/ZQZOiiE8Bz7OzOxvn9iDMYUByNkddOxNPDEw8tf5ylYsZNNBO8/FVer94jymGmMyzTU/3cn14afkfDWR5KeLkRZKulhG0Q2l642uayTKzsou6op/CUxIGYMso1euyxQpapGWqYwq065z7Wx30xQgKRkvVtQKAyZJtZLcZoh4CHalas/6H6OhKFoUeuOp6DfTW0Yg6nvj8ATI0BvrHm8g0vcR/GOwb74NaCRkARVvakoo9cIY1EgeBQ20sTrYEibQ4YhHWSUgnRZqxuunIVVg92hymyD2KZ3Yo5/NpIq7OEVS8GCXwoYzyys7r+TINEIY7zFYLr5cW2UOT00f7D7c3V8gckwRM6rf4yFLeXUcVD5U/3BgRQtwfgYOiPDxElILY2+7EfG2B92Oi+QeSe5y19quk5ZKIQQnCyleS3df5YSErQpp3SCQawI1wGUd5Nnggtah15DTDO8GhtWs4yTFWhUgQbjcSQYqmJi6DbFa76Ut8N9v7RhCw6Bf2PE9RbX3expEtefV61OMEfF2FaN9f+3vc2l+Vl6G0EpUoWXVrzU9c/3ut/0QCRgHrjlgzNYrE6pxR8+5smnwXjLQJsczWJRvC5z3bNwdxFGpWsVNMPTMn224//CO+f5IE15E7RegSc9eztGPAzsCfco9beaOwydBKdMrm30nc2zcu4+Sxs9vfY2luSqSd3xONPhz113kDRg+XBzeiH9TQY3/ogx/fBo2dIg7TbfJ5Qh8+8fttBMoVlZguxIq4NhP98MEjeLxBjWWLCa7aCupn3oO2bJIM2irk95rVkjVtZMCzD9tYYCf+n9rqs4uRLaAZfXaOuKKtzyRXpFvC/Mkad+WNeH
 ouxu+Q+T
 aG/cblrdvVcGMJfsNf8GjgA31YH251h2dNmNgGKKL8Wf73g30ax8Q+467MhJMkYJwEpofQSKYpr/SlJvmlsnm3iwyvDFgfSXHa0m7ahylLITE3n7w03LTpPRu1cn1uHYMQ0s0jTq0lyYTaTX+VPG9EIpD76aalDWzUp1NvXEeFJe9uknajwiXMAwPQ2cgrNXdv4LQ7beMP9txfG32LPER0MNDWB8TH9rLGxwjAk1nzLJfyKWfOVQvDuLgaaxwouXkuUuUNsl6rHunB8VLG/u91OmS6w==
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
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
---
 arch/nios2/mm/init.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/nios2/mm/init.c b/arch/nios2/mm/init.c
index 94efa3de3933..2cb666a65d9e 100644
--- a/arch/nios2/mm/init.c
+++ b/arch/nios2/mm/init.c
@@ -38,6 +38,11 @@
 
 pgd_t *pgd_current;
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
 /*
  * paging_init() continues the virtual memory environment setup which
  * was begun by the code in arch/head.S.
@@ -51,8 +56,7 @@ void __init paging_init(void)
 	pagetable_init();
 	pgd_current = swapper_pg_dir;
 
-	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
-
+	arch_zone_limits_init(max_zone_pfn);
 	/* pass the memory from the bootmem allocator to the main allocator */
 	free_area_init(max_zone_pfn);
 
-- 
2.51.0


