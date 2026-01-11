Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BABCD25037
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE87E6B00AD; Sun, 11 Jan 2026 03:27:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAF076B00C0; Sun, 11 Jan 2026 03:27:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D87886B00C2; Sun, 11 Jan 2026 03:27:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6E616B00AD
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:27:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D7AE1403AD
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:27:59 +0000 (UTC)
X-FDA: 84319005078.02.F70FF01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id EED1240006
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:27:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IGnsApOe;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768120078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMuEVnl163nXTa+O/OHvtDDMLzmwllm0L4yo7sEJ3YQ=;
	b=5VrDjDX19U7zalbFw+5oeRwSMAVjr7yB8xyuYGkXFQJ/i9+UzoLjP1Xw1H95+0u9JFrNSw
	/vapuZVee+jUvrt/8lpN9JbB6ZEkdEwDORApFN+K4D4DQ7wjLpCDyL1cvUuvs6sJWG0Epf
	nulW5euU2grnpnYqdB02nkajNZ5O/Jc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IGnsApOe;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768120078; a=rsa-sha256;
	cv=none;
	b=JAxI9aTBZ76kzaPHwc2+KOX1xPFU2PplZu4FbCkg2ym68FCR8MzJGfAIjwLMwkR+PWHPzx
	zFVoCb06tK/UASQsK2orNJZD9jSfz6QeyzHCP5Cik7KD3/JubUinW8VtMoS5lGBaWbkuzz
	swvqwgLGpSp3p/i2dLKCYO8LVc/rWsI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8073A60127;
	Sun, 11 Jan 2026 08:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D8CC4CEF7;
	Sun, 11 Jan 2026 08:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768120077;
	bh=q+M5A50bBS7JfetqFByPT+KJrphXgISZqTpM92eTenA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGnsApOe52UMwQH9rU0QdFDUAygZdjQbcEkT+VcFh+f2uIPc0Movv0hadDZtysGLu
	 JMYTBeuroBlSJGszS2K8JW23cEU1tXtb89wIKkYD2uNZvvSMDgnuNSbEAJkkMWfugW
	 cwtKO3+xV3d/K2hNCc4wGnvGVjpj4mSjlL71LyU4btVNuDx9MwMhZ5QsDvVpKtmQNN
	 2EAcaKe/SBeeqJy3AZisKps+dHlJ9rGGk1wbkEMkkumkaTeOfnRjlxc0fyDYFkNWJz
	 /+oWBnCcEaIsUnQb4PUJdVub3TiaSeyalOMYoRZBztcTqMfYM7Z+CzPCQ4YeR/ZN6x
	 o9YVaMIgO5ztg==
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
Subject: [PATCH v3 26/29] x86: don't reserve hugetlb memory in setup_arch()
Date: Sun, 11 Jan 2026 10:21:00 +0200
Message-ID: <20260111082105.290734-27-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fyy13m69u5ts55ze5cm7g7radwnrorty
X-Rspam-User: 
X-Rspamd-Queue-Id: EED1240006
X-Rspamd-Server: rspam08
X-HE-Tag: 1768120077-132759
X-HE-Meta: U2FsdGVkX18Wl99x9k4w1Ld7opDg85Jf2/mqBenFqIwW1PYlftj41Lfor+qVsggSc0mR26grlmnxXhQSU7Z3oHmPeCxpnNJPwUV83fLY0NWlCVtheb9XM1uPxgqIzgjP2KnJlwR5MsQA52PUyXyYvrmpZh9dzBRQXRePFYwMkBRuirbU62qBXMn0UHgsvshO4uy27bd6Vf4vSmknd0y8MQoEbgm/PHv8lc+EYn/7kfGztkh8Usjpb8n92+594Cv/1nQv6JT9KUH15bqSn6k0BMAdOuiauEpxAhhBSXCUfIqdXqfvOINN3zLFPbAcWpsIHtxCYTDabzQKwmKUzdM/YqBeA/9wotfo5svrqFZCH1gusp4nadSlDC45F9HV/Cx095FiaIpV2XI/AOJOBGbfvufjhofM1X3Cp2y86fzkcrXs0K83K2OPeZKD1n1VwsRBcfMzBwtPIwlan1KjMRw5/Q1ZeuS3ApG94Wphcj8QfAUKBnSvTazKfTscRm+aI9gxIEgp08yeg8tRzMotnq+cskF15+zVwvAHgvGsJTcNSMw9CHF3r92krd65CHzvJ1TjGq3G1FxVi5uga+r5tB0203xOX7fMHvhmTqd3sL/qvdoiVrtg0tRfm+dQ6w+/zF2D+yT6dbeS07ipz+RVFyJTICYn+YLTU8m1vOLsQKTMaOMObEaBLMZRi6P9PQSkZ1I0uiO9e+g9dJotRstWc4+Or3s7l2D+cOHSy2H/3Y3lgOOZrrTW9g+Uw6Y5FqK04kFp+gKwT8DahMWgrJnV0FuHOampT19R3GbahrYbTZGcp1jZoYjDk3MXEqw3jxIGHy7nHivp6zFHIR583Xz5lzXuyhHsb4eRbPGH1rRMc9lwlaFckbgJ3VKCQAIXqQs1hzX9BsBo+RDdSBumkjg5dJBEkBXreYuOW1tLXDYbcpdRJ2sX+swM/OHYO+69t1cUpkauhyQophGv/ny2dNBDx+x
 Om9RlLgd
 Kkj/64AjNi8kuT7nSD6AI6laqjidOGkSmVVesBhsYGWzvm4CMHRKdLLppnxNHgXYdsDih2zbt3HEN7HKXEJN8j+iFIVuQhmMDS9IosvoyXRgS9yBw3r1ZbdOQ7oqduhdL89d4IomEp4gtHdhTu9By7RGKwweSnNz9/UclsjbCiEAihockvN7YQy24j4bC/bkEZPw7HxujKeplMzMfH2c37XT/nIKhNB5PnNHLYAEjhzYE89A+wqwMCi6K4sr01yaLQJMvMdPYveF/NK6ZAt/6YL7HaLdFG0pMPTdHqagwtED76PnAFqYrZIl+DyoLOAG8swsa3RkeWgxyk8ehCILyxJKh+b19rXzrTwNA
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


