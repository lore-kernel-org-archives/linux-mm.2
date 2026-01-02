Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A61BEEB57A
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1BA6B00BD; Fri,  2 Jan 2026 02:06:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7884E6B00BF; Fri,  2 Jan 2026 02:06:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681A96B00C0; Fri,  2 Jan 2026 02:06:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56C4A6B00BD
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:06:27 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D7F6B7497
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:06:27 +0000 (UTC)
X-FDA: 84286140414.20.6A2BA50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6DED9A0009
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:06:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Inzhh79V;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMuEVnl163nXTa+O/OHvtDDMLzmwllm0L4yo7sEJ3YQ=;
	b=46vVvgn8vSLY/HmTCucSX7iV2kWzDAHsVjKGWo5bl6TmTOZRK8WXd+O0FHyUB4v2fuPpfX
	YnsmVJ1pUBzp4Y78trVEuco9gbz7Cekw0PcLEJJI/AAcZJJKq0Cs3f6M4H1ah4A59PF/IH
	S0uZCYCjltnAhX8wnTxqPfQYrYCrBHY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Inzhh79V;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337585; a=rsa-sha256;
	cv=none;
	b=KcB9zaVRkifbBtDwUAAgztvkTH3KFzWAHzHAHVuOi1dFc2ZQj+egdvwwVBnLpKU8s9YQei
	9+dcXQL+icEi7xXqRH6qaBl6p/UV+cV5DqaGUMxWb1acYzQ96PNWjH9GrtMR2ixePjQrBk
	4Cq1NNPuPSK0IalvnHFcpk+fSyfQlaw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 79B0540AD3;
	Fri,  2 Jan 2026 07:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72875C116D0;
	Fri,  2 Jan 2026 07:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337584;
	bh=q+M5A50bBS7JfetqFByPT+KJrphXgISZqTpM92eTenA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Inzhh79VgyZ5ZJxghX5baX9tzk6HIXuZ2MyqXt2ADd1mHizZQUaLq3g/u+lhVlVEH
	 kKgI9ji+RRI3pXIaxvmzfXOBumXagdqGp9BtkhjHVMewmngWlnF2E2IL9QTkOuRSgA
	 F5wxMXSi1A6yoJSUGtErYauF2O/JyBm3/k7mIOJswcDRKHuzj6G9fKWXAYhoaocl3X
	 m5h6uKBtJQGDNcQcCMWGhQ3CQWLoc9niN5VqwphQ53oJeTNLdLJkMwAcW4v7twPhRC
	 5qG2/LuaasR/8SN3/olgUS1+J1BoQDKKseepevIyapBoMFO2rsT09pb815Wn1kOow6
	 9VlvE1zKTvTrg==
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
Subject: [PATCH v2 25/28] x86: don't reserve hugetlb memory in setup_arch()
Date: Fri,  2 Jan 2026 09:00:01 +0200
Message-ID: <20260102070005.65328-26-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6DED9A0009
X-Stat-Signature: 644j19qtyjs4yd4bu68oasrgikum75ob
X-HE-Tag: 1767337585-758626
X-HE-Meta: U2FsdGVkX18y0tu5lBPPH/xsMFkg34JTkfWSseK2yMCziHgt58mcIdxSupDgMyFJrz1Rcy1PrELWBBggHWehYwEiMMIdteKYNuxpU4ElqjSIn1t58WNE02VQnnxDkLrofKwPj/I3ZLEkfKaBxza+oCNACmOL9ZVp15sSCZhOEiMbyCQMZZ4mgOYo9VCWUK6l3VS46YoVEbdxIHAkN5OrMYbS2RfEouc76XPbrrqgAo30BhYFCD9tsessqgKLiTeB8t35PMqxLjTPVrWu+RxuzaNT5it8SKl4mnNtXS5aHXsDOctn88nW9J8Fc9xhb725BlCjU5kPePSl07SiHm0EQZHCQa0ez5Hxf3L1G0G8uzDTNf39wF8Z5gH+K6od4NuBk1iDKr6mliGx67Rer1sqxpRtC8x82AuRYgWWSfLoOlvrGyHEHTmb/rU9hASlmZKEvhJf6LmEhwv/NKG0YDjpTkSBZ44rt6MAzUOtRHyzK/kroSvgOHEQdR3c6QwMug9p1aJ5bskcrIno5AHWICJ325Y2G5bag2WHzpjsPpPWw+GHwqiMKLi39tm7g0XMztQAAESSbCzJ1/EY3JmLI8BqNgFHSBmzoGRQvaSnIfxT+gfyW6IEeUT+Xzq1Tw3sP339tb6D6S60XkYXMm5+lEJ4Kz18eYb6viqa2ozDlnjZBH3h5RYtEOOeguTKea3xIgiuC/q8R6BF9J4XJVskBkOgFKQIH+1aCGu+LfvdCif3qiQHkW1t4zQD2ZIf7xGbsS8QDAUcjx9f1If0Xs9ZHuS/1z5eMbjRgtPxO63/QFEAv5g1i4i7/spSDj3/vCzdvtFHJn6I7CJIEBNSURJYLDrunK1OFSc+94GFHueyTaqKv6j02D9HnSBlm1S9qlIWIz5I0GfjiQSrBaBUXuosC+KKG4cSNRuWRnzBS1T15q/h58sNG8aRDUlnBpgNLRIjihru6U3kiRm1G6M/cTJkc6C
 6YYYNG4F
 rL43bS3Y4LJZUnCrpTaefU1p7m0mzLzKyeh5LBInidtKh7kOOaMiU9XZ0fTdMckAWwp2ClwySIbA06aFFTZn0Hf7RfwHsHw0t4wzDR0x736rpczlhuhvYhBkwXOvr0ZvL3RDLe81ZzlyYUdO+wY9QWjJ2qx7EsMQC6zQGrBNQsz6Fs2X8eejqUCuyXzO+InXHBz5gDLtVBuAsN0Ho+iBxQWM9zEXgsSuI37NUvDU1rQWLUStGYOFw7goxGNpmaIRKWDhKN02ZLpD+G+jECx6W/ZiDuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Commit 665eaf313314 ("x86/setup: call hugetlb_bootmem_alloc early")
added an early call to hugetlb_bootmem_alloc() to setup_arch() to allow
HVO style pre-initialization of vmemmap on x86.

With the ordering of hugetlb reservation vs memory map initialization
sorted out in core MM this no longer needs to be an architecture specific
quirk.

Drop the call to hugetlb_bootmem_alloc() from x86::setup_arch().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/kernel/setup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1b2edd07a3e1..e2318fa9b1bb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1191,7 +1191,6 @@ void __init setup_arch(char **cmdline_p)
 
 	if (boot_cpu_has(X86_FEATURE_GBPAGES)) {
 		hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
-		hugetlb_bootmem_alloc();
 	}
 
 	/*
-- 
2.51.0


