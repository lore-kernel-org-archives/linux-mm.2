Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34306E9410B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8986B00AD; Fri,  2 Jan 2026 02:04:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972C96B00AE; Fri,  2 Jan 2026 02:04:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86B116B00AF; Fri,  2 Jan 2026 02:04:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 784A66B00AD
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:04:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E1BCC193D
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:04:31 +0000 (UTC)
X-FDA: 84286135542.27.BC50ECB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B3E321A0006
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:04:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iAXLwpHl;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tokfLp/e6I58cppZJNFjurjxkamTTnFniADDaVWJ9jM=;
	b=5hnYiX9aTGNxprbx0r0d6VuDVfMg2vm1a01l/umlIvAqg/bG/VxeO2HZE0dR4oHsGPc9SM
	IKDi1LOOEr5WS0mNjdxJjT7P3Lc6yuc+jRQOQXYY3EfVWgkIHRh/KgG78QIwiDU1Kc1qs2
	/W+wUQ+/xwtrZbWpwJiHB3lr/x95KCM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iAXLwpHl;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337469; a=rsa-sha256;
	cv=none;
	b=RIKuIxLxsUIARejrc4GRa6xu/r0g0S/W3DXr5w9E/um4jZgnb0uHTVmIeCpnojLtWJyL/d
	PGNpOS0twbUyCBB5YL1BNmKDCd8UT0+rClxlcGQL05HVE2tYRZyl4ZtgSbzBqfLsTUDULx
	KfNAFA7ns7gmji/zqH7IpKq5fryHjHw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DD8E6012A;
	Fri,  2 Jan 2026 07:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20B9C116D0;
	Fri,  2 Jan 2026 07:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337468;
	bh=8ogz7O8vNIuYttKuy/nGG2q6czMHDvEeQHxuChR5AAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAXLwpHlBrQ0GX5FPB84dmZjEy0shRVMJdKLb8mIOyYXk5rRbGGh+ed7gK32cWjdy
	 4mykTMeuWsDwKzi2vKzTIlQgAUI/qmTwUOxzXCie3BuY0k4YcPRN3G+//XWkSFxWPq
	 S5Mkl0UklKeJutKgTu0AKQ1FkJPjKt08u20//SsbGdhPzr5WIr8CRc06UbJPMe/q4n
	 0SO7hjApCIHbpexb2+mfx0+cTLqq1aNrBSTQ92lJHeaRXBCNwfve6QnSyQiXtRcAKO
	 q37HfhxImITqmCg7njORQbpT8iTZ7QgG7Wts5xdYjUFYaALmaqy1CiebFvSM8LzlVU
	 Vr0aPPNoU6NZQ==
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
Subject: [PATCH v2 17/28] sh: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:53 +0200
Message-ID: <20260102070005.65328-18-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B3E321A0006
X-Stat-Signature: ei9k4dhh9xko69c7ny6qdwbw666jhfbx
X-HE-Tag: 1767337469-733525
X-HE-Meta: U2FsdGVkX19nhzONcBIA6oTiEQtDvuu5QXvyuR/fzPbEpYW3N/pbcG047zBQ0CAXxyGL2K4IVdGHOe/S9ZX1B05t2m7cqxkuC46sv7zhWcoChNMAjpD0K/6vG2RUE6dAGlgnhNXLDgBApj8TYHiaMh7BPoZXhdK6lGpW0g50aO8tM5JocHVIdRHO4amZHw3gEAbmDNbxoOcuI7yM2aBC2OpNwTYOYukmc50IXKm4vb7fRiELOpM5AqzVhtIsRPQSzMlb/LhYRwh7B/jRro5nyApFfrusFN1SoVO1pm0N+K69hGrNYIFTduzErr2l7cRgocN8Lryn8QrZgYoYtagsl5pgGCPWzwju6E6UxLBP1Y8MniGBZymbEo5eJTGp42n3YySyHDwwUm1PdwykQ+rcdwqKvA02Fi/+I7qW1J2aG2byncoA9GzELoh4CnqGZyUjEe6NxJm/+778g3cKRo0D7b2TGSPu8hlMfICPM1XoU8vZ2oV9SVdCr6sTYDxPISk5J0OvOsp26OKTcH9gU9F4bIkAAhoSwdb9UuBjrXnmbHseUHqWsppDNVoAu5pifaYoHglXjnsByZYhp3toxVv1iVVrq7NaTB1fA8EUXuphuTNWK/gi33MJaxUyL9Rk1H0MfHK6m6tkll//MJWB0Q4iDPu2wvthR6qXgdpLa543cYXFUdlTlRHfyyUZvHxwHiU3HOwj6a1JKwgio4ntaTZAxxSXwRo5LTrBoOb0BF5EdT4mDvHE5sQIIlkjJxtnnPyh/93HZdDkAT7vJ05MJgKEj9GwM/9pHbqnMtVx0GWBigTHY9rl61VhNT0OIoxURJJikUJO4eVY4h10kYJXeAVOJQrme1DbM9ENS6jmxtM01WBg3dPyDkKijVqqPIRIo1FYHAeNauRPn8txd5bZr2reNLzTtFk4BQ0B+G64QwazOw07JS/9GqDmKWfK+JRV0rjGIXDr9LoZM6rMXrndVvp
 hzJM4Lc6
 aFv1HSzfOX3qNsXdNP0M4x0LsNGlEnmndvhwDXqNpxYrD9pAdxpBqswffRICjNeotC3OL7Ni4R25HEw3ZJbIgTOZDhhAYczKyLBe97+24KKWLlRH3iUaYcI6VpMqH8U4Cx0MGjgx/m+Haeb9dP1zc+5XwwWUJIEcNfNEd70w6VZ3zVqDXdW2AKhBo4gDsbobSKHHDMGIpgzEFx/A4praRsTdLbajlGn1Vbe2PLzxqtA9aiEddO7UvjU9eDVw86J98aUnAstAprUwulZb/yYpgTMjypw==
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
 arch/sh/mm/init.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 99e302eeeec1..5e7e63642611 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -264,6 +264,11 @@ static void __init early_reserve_mem(void)
 	reserve_crashkernel();
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
 void __init paging_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
@@ -322,7 +327,7 @@ void __init paging_init(void)
 	kmap_coherent_init();
 
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 }
 
-- 
2.51.0


