Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A137E92724
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 704B16B00A8; Sun, 28 Dec 2025 07:43:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8B56B00AA; Sun, 28 Dec 2025 07:43:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB716B00AB; Sun, 28 Dec 2025 07:43:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB766B00A8
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:43:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F5C9142213
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:43:28 +0000 (UTC)
X-FDA: 84268845696.29.4A659CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9289E100003
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:43:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mvnk+T/l";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925806; a=rsa-sha256;
	cv=none;
	b=wvvXVfb43OcLil/yxnkrWr00JzynMIS0Lmrt+gNPo9ZF/MwiHZI6qxWkN1ctSfzM7rENQP
	WkP9Rx2ts8i7AZqW9nRnbdyTwei1YxHavFcKNuKUEgQR9J7NtVq6XpUaHOiLkXggY/0GRn
	M1ldOvGstn/QZQUTMx2S2sDYAGpaUEM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mvnk+T/l";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3rGoNEIN3+nxNy0Tllud3Z5Az96f5Wa9/ZyN58oX2nk=;
	b=xqS8kLYS/eQXeZ6BaAEcnIjSgfDOpvADnr/HMf0g6qQ9JRGfCDkcSPDD7SWSy/8pqx0iph
	Jn0vkHmFgoGIg8TR6SMBq8C/y+9yLAFAcDskmt+2gmpPqYttIcodapiMGAQjEfjzVO2l5E
	V1lYTcd84O+xGELZsWvcXTU4+plnUxE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F74B60055;
	Sun, 28 Dec 2025 12:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEB3C4CEFB;
	Sun, 28 Dec 2025 12:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925805;
	bh=KpWKwBVQ6/Wrpr2p5VE4NagR6mN2AIih488tiFO0eJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mvnk+T/l3iJfcZoVHMTxLWwAkj0lcr2wxYLznPNC6F8yayhhP2dJxOMoDSpp61w1q
	 FyDzRCr6J/Bc96cUb+UTemdxGnkCC3I9ro31Wo0224PqibhHPKKiwILUOOK+zFMW7a
	 /g4IJpQe2W38LqfkpdUspf0PLOPfv+DaYHjyflx+fc7AtcdkD92n69zlEY8e83Wj6Y
	 68sf7yQfGCVvoshnIPwOAY3fFq95dE7Ykvknc5EApPQxj6NXQpXi1wf6YW9xuk1m88
	 PemPb4fVX1lXHkpiOZHqgdGq4x4lcmT6AtAkYPzEwJQ+WehAws2BJqmLoGIHWJNyuu
	 7XMJl1UU7Ju7Q==
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
Subject: [PATCH 13/28] parisc: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:43 +0200
Message-ID: <20251228124001.3624742-14-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9289E100003
X-Rspamd-Server: rspam03
X-Stat-Signature: g631iy5wimydt1ee34d34hx4ftuaqpr8
X-Rspam-User: 
X-HE-Tag: 1766925806-755991
X-HE-Meta: U2FsdGVkX19gLcXD8ehFfVnvHilO8vtu+T2+GJxAQcmpAczBkGu0t29D2FGpU3AwEhuNkWo1yU0wRuMgkOXrAanM8/5wwQhhcNUAqRoLSUkNP+m5FpPoY8AMhtl5IvsBL8usvSjlM9UC60Sq5I2xyL/3ss4JVC6S9pyYU1JAhHrAIJWk2exZmhwzxs6fsKEZnEEPElWxXf+PoneVeGG48X/KLp7q5ecNsHKXU2M9bAd9df+rUDIWRozjC5cFrIyQJK3KU0mrZvyYx6oo4sVDC+CNDmk3BJH+L5RnpXX6kAvanTVVPh4I1hO/q5BI3NS35BWY10rVvAbcOFNJLiqtyOAXttsT218Hp74VFft/U8uCkRNp3G7lm1K/YkCdTfZC9ORjcOM0Fe5f0kyfZwuNR1E6BJ9yO31JY4F9HFLKq82TQpi/9durhXOebTNZOTUpiBjd0GX/mKCgcaIz9/YXN8veFDJ4+I/cAYQieUBNmbIbHYoSDt8CvNr6SCDzmsfMWFTQJxZH89eJTIG78X2+9NlP0Dl9w0i1S1tiqa5Ii32T0OegezH9FpNPu2m4eJdSW1OXzOVo9yqPIrYc8mEfMmfmovk66D9JKumGPAUKrh7Ra4EErkUBQDtLVKTq/SAe1OAW8okTSqKiYy4nbyRYQjy0vLhc+xCR+K1ii4S9f2N4wSpX6BXavRlLCM217rgi0AGGutq5/+/Ynn7qM27kOlxnOuLM8IR69Z2aqDeRioaYHuqNPDePay71sPHISzqLmOqAL1L7OhbLUXEr20ez6OD56nVE2QuEPaJ59fH79dI3+owNzeBZBwK3/glEYA37y56naWesldOey97N1tarDnBBh4nFjbGhQzASeuOCKNhfvl2Q/wFiJnUffMhD5xr57XJUp+dL+gEvM4Y1srwPDeiA4XbrUWmgBidTMj2m7DhJWKFng1Izyb6u5qshJqgsy9S3GpfZenXyP//cL3I
 mazlBd3f
 EyXlnoogAwXEf0tHPoup34L/ZmgqYI5NdKlcvmO46lNvDhZTudL9P1gOg3KiNfqVyl0R3KX4gtIQRx3/84LPRihPvHefTeUHG6mNHan9fq2d8aXCAsGDC7GAsxWHaMoX7opHCon5Kuk2rFEWntWveELaAW2ae5jc0hM6k8NkxUJytzGLvp2ESfh0bGoLxdNC8ALgbDY2inV9h7DcuRkIn5lTISUnSYftMG0jBMQWcU/j5BNErPS4Ew8LpzAGGr1dYMcWQkSuPbXK56AaVcwyw/gRyXA==
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
 arch/parisc/mm/init.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 14270715d754..dc5bd3efe738 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -693,12 +693,16 @@ static void __init fixmap_init(void)
 	} while (addr < end);
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = PFN_DOWN(memblock_end_of_DRAM());
+}
+
 static void __init parisc_bootmem_free(void)
 {
 	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0, };
 
-	max_zone_pfn[0] = memblock_end_of_DRAM();
-
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
-- 
2.51.0


