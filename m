Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9BDFD25037
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488836B0088; Sun, 11 Jan 2026 03:26:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446576B00B7; Sun, 11 Jan 2026 03:26:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31D2F6B00B9; Sun, 11 Jan 2026 03:26:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2025E6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:26:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D39518B749
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:26:43 +0000 (UTC)
X-FDA: 84319001886.16.07C330D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4BF11100006
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:26:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nl3wHs1O;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768120002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azukzfgsXgu/EZDimou0ymklRTxVzT+QThHCfbcQvB4=;
	b=5fOVdeiRWO1seWIOUqEuWk7YIeoJJ0HYKCZOHA1l5BtXXtkisVIF1Gp7odURM0vVJWNUPv
	ub9Xbzaz1bf+NEwTcbIs62I8QYdg5U5A50M80rH6ClrM4jxqT0shVbfhIt0wX4HLs/qjrN
	XVzA+BZ5Er8DG12qAYGUdAovYwPKcDs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nl3wHs1O;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768120002; a=rsa-sha256;
	cv=none;
	b=PWO9WBRl3Y7krH/8mGmQs1vdskKI65O6gJWcvjitIW087qj4qJZAr1WVlKcZsEMOiGP1Z3
	l+K7tNGo6BohQKIrNJQKcdFJH+XnnK2AVLvebbo34/tOfZGvLWDcWlb53Np2W+DG0Lhqbj
	mjjA7IeL/5sDYs0QW8t969oc9wqhCnk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A263460122;
	Sun, 11 Jan 2026 08:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F77C4CEF7;
	Sun, 11 Jan 2026 08:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768120001;
	bh=4MJzw8wq/vYacVlPos8SheQzjEj4nCDptI3YxDfhXAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nl3wHs1O2pqUdz0Vvuzmv46OR0qcJI1+HN5Ee4h/md2AnUo3Ou1FlhbxYHJnpXEFj
	 Qdh5nldk6nj1FcSAWN1zgII2VIOLmZPirbF4ihWm3QG+z7kpMwkoSBVDrxhWWen7KB
	 T2i3p8WFkV9Lgt6Z/5CoUlwWxBnIW/3tXd8oV8ehlBl8P22GRw/KKkaxcaBbDttGNB
	 Gdbga/UDVtZTC0f9560H5GpOjK/dXA/5q43JwZkM44fdhedj3lwEfEjbC0p/+HAVxh
	 Q6X399TIg7FsRwK7XllXsTWt217qXNEQIQr/VobGW+cbxfbUQn4O+kRXx6S2MViokM
	 dlYMsjJ7vMB4A==
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
	Klara Modin <klarasmodin@gmail.com>,
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
	Ritesh Harjani <ritesh.list@gmail.com>,
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
Subject: [PATCH v3 21/29] x86: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:55 +0200
Message-ID: <20260111082105.290734-22-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4BF11100006
X-Stat-Signature: ipr46ysh3ombh57nc4nntuc8g8r5pqrk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768120002-383605
X-HE-Meta: U2FsdGVkX1+nWzqL7SYbeA/gFEAXRJzjyJW1M7hHd6r9LikfYzsGTQgJrz0X3bjCUpJbvLbl5x17/p4W6ppN/OcOopyzNNETv+zt25Uz1T0hZSvmVDhGZ4IdTo6L9Yq57zTdmUKOd3+5frLSfS9co4w8m9+UaarVEsaWRTYG3ut2ecXUyENrFGHpcom8RlnYO91Oe+58NQunpflK0Ho1wSdVdEfSkhA979wzVFYToKGCbpByu9jZ1/hL8ANr2gwSSpAvWcc9NWZKNi6F3bq9UKF2HVFb04Ofjr4caN7r+7J4MpkJQEE3xftfXOTaNSZABIX1YJ/i5eCe/28rqt6Xb+yQpowX6Nz27PvfLB3Z8ZR9kw4lhssyKydAXxMbk8DEvxE9W7GFUQmOIbAUWadSQrl9D7OOwESUFp4giJzYq7anbocBRgLf0gzjXlIcmLa8MoPW2dBvgIKlG7vlvQ8nbbxiaWM3hgphPq4z0FgBCe1MCdoDz/ilseHrIH+86YPDWH4zOyOQmvO+wCUXNDBbJrve+YIB1YiTU+d87zm0IVYgz/3TUwHn6wh9nXlpnQLcthUWUky0d1wpbKcbq27RWA0jseRbvgBXrqZyKjdnM0iTLq6vUbA037ZIoLcGItpt1oDhHXZmcP7dQCn3kMV5L71mqAJL3TSdfaG4TuV9P3vN+HGIXYxFroh0P8qPn34w3UrE1zi3Nrx1mvIabzwK2ik5src3z7RMFfT9O9lTP3KvPUuQBjhZjySMV4jCX832rOMW1kcYvb3YHYNmt4UuqrpMVmWyLSpoCfEV0H54YHq6lbxemsPhBCSz2OyTkG5lW4mF0zffcO5MyfzUeUph/8RdokzPrHGkz9iU/K2GOkjRFimNIsMahVP/4xDWtc6CsFTn4K4jMnNzroDQYK+xlMxUi2rF0E2p24fJRb5p93T3WsfZdAWorerVnaZawbdr1tkLB/3NlAtYzJBlX5K
 ortgN1t6
 GksL5u7y+s55q/P7BtCaZlfD8ddRiBwKN+d8NsnxPpDIltRzEZZ453BqT/G+MPQK5puxegMDfqfv237ArmnlKzXdJOUVfx5JuoRtDaJ7wUqk7ByfLxcqFvC7TdYiZj78Ny5BAXYLKgfmhcw5cdsGvejIcupxnxPnSsocVyjTmCYKRR5sR062eTeYzUZKXCWY66ZPr8abhXhyybpXXMG82F3VJGvf6Bmsbf/bMj5kAwGdm+7phgkPZjEsUMUNO7oxoVidkr1L+HPnfKspbUSqB2395FwFjslpMRJuSptq2udMIolyz/5GIrBsM0mGdJa0WzI8FfozQU/AFnCC3rh3w9n/Jd2/Q3YoZiDxk
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
 arch/x86/mm/init.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 8bf6ad4b9400..e7ef605a18d6 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -997,12 +997,8 @@ void __init free_initrd_mem(unsigned long start, unsigned long end)
 }
 #endif
 
-void __init zone_sizes_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 {
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-
-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-
 #ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA]		= min(MAX_DMA_PFN, max_low_pfn);
 #endif
@@ -1013,7 +1009,15 @@ void __init zone_sizes_init(void)
 #ifdef CONFIG_HIGHMEM
 	max_zone_pfns[ZONE_HIGHMEM]	= max_pfn;
 #endif
+}
+
+void __init zone_sizes_init(void)
+{
+	unsigned long max_zone_pfns[MAX_NR_ZONES];
+
+	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 }
 
-- 
2.51.0


