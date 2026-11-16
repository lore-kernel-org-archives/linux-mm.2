Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68732606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iSdNGUDn
Received: by kanga.kvack.org (Postfix)
	id DABE26B05B5; Mon, 16 Nov 2026 07:49:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D35746B05B6; Mon, 16 Nov 2026 07:49:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72696B05B7; Mon, 16 Nov 2026 07:49:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A35E76B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:49:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DC1AA02F5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:02 +0000 (UTC)
X-FDA: 85440962124.07.1A983D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7E40DC0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iSdNGUDn;
	spf=pass (imf10.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4F6U5hwvw8gwNmHBNKQhCDls4ausjqIT8kXPov+zDoA=;
	b=R3jCZEkLcaFNG5gjRaQh6ezmwcUkA7TO1Tpky3xjCu9V/py+CpjkoX9vu+4nrBUv43BPuA
	96JUKJMIE6LJVB3YJEHMkU9GkPVgfMmutN9AbJ9jlWoeRP1x5+CTGIytYgPP6trWIX89dP
	ShBR2mKedb0+4kJdlElGtBZSjg2Ii6Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833340;
	b=gZ1gmCrUsoe8b0agWdnAizK3uwaerfXxpl9wFFRN3ChqsRGSUufDLHluKLL+R0dcxblksZ
	f/X3XMhlOxnCZzVonCp7DZryLkeb7frprqR9PHxxCv/PcSgkotcXjtA5pyQ+MpXtgF80wz
	vEmGmFVwQW+TGNzweQ4SAItSI1MHPJk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iSdNGUDn;
	spf=pass (imf10.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C85C8437C5;
	Mon, 16 Nov 2026 12:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A251F000C4;
	Mon, 16 Nov 2026 12:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794833339;
	bh=4F6U5hwvw8gwNmHBNKQhCDls4ausjqIT8kXPov+zDoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSdNGUDnUPPi4pJnAYBKNnCGTaI+y4qb3uN/K5lIkcESpOPrpKPgqoRvuRlqXEFp/
	 D22TIAOQoLnM4fj+lgCWae9ef+MQKYOaeqrQgq0dhWWtnjfAThJNwLHjtsfOcC5RbD
	 Np0pFfdb5cSXXXZAUynvQxQrYr1pxZBp6UXANT9o7ZTogMmpoIoohw9lcwxG03mhpX
	 Oy2/oEtzbGj0awkxpXQl7L8affCM3OatgSUKikQvjQ8lVdfzBbeLPTvGwJaiSqc/fS
	 78SKOIgyWd1tcz2HtBmGbx4T2VjGTdAtXLoFfYLGAeU5FNyhXMeNcrhwM2xy6db58r
	 GhZKMPeccyxAg==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linusw@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Lucas Stach <l.stach@pengutronix.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Nishanth Menon <nm@ti.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org,
	sashiko-bot@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 03/10] ARM: pxa: support arbitrary PAGE_OFFSET
Date: Mon, 16 Nov 2026 13:48:25 +0100
Message-ID: <20261116124832.662455-4-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116124832.662455-1-arnd@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 773m9jzsco7anf7f4m7abijda8d81p9y
X-Rspamd-Queue-Id: 7E40DC0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794833340-952541
X-HE-Meta: U2FsdGVkX1/aIwOVcWglU81XlcCZ58Wv+M1eRicdTVMTGo0P0PABeHXFmphYZ0I5Jf/ELc9mYUSo64IMA7JUKqniF72S0VDXFmHXrrU7JTgkxob5imcY8kbbVOg+e8b7x+l1mIwqjWROVhw9/77qlUJp1kAgOH+HawhVwY42nFWId0U4Q2CbAYQt9HdtiB0L2BiBmJIm6ZmInBYlMPjLLUy84j3zjEp+7qScBfMt9HhnUZjfiAnlddf6X1XQDG/6hZNrOH44P+QgYk4sBJ6DtSz1A/Fdjp9STvgZQh0bgV24kGSKpL/tra8qANdx01dvA5iSNS3F9bYzdVpFn49YWMou63eBSk/w92sEAdJzeKIRhU+BxBoDwNOZqOJuEGUBTIsks5U9o3l7Tbuh5Hdu5WTNb8U0H3xndK+vj43bs/o6ngK8V+BK/lLilKmWcCO3JBAzn/5udNmKy8TNxL0+9KEtNmtO9O37rp35/ehGRiuCw/rgYS0K0btTOhQNlzFSsp3ltUav7FAgHgUgUWDc6jRz+PJ2LnFrEJ+J5o74evKeX73kOSnspUF1y7cf4ZgPySRikEvHVhngYDpLt4iN9VlWHj1y699i8UxzzsDI2KAxObCovUq+qIWptWSZaZOzexGx9fK1hgPvtZUla4VolpHW7ncNdiJ9+P4LoUCcmgTyB40cfDEt82FhtuhK2mK1F7P92fuZZjJV+VvFlrcel51LxZSUFkoGNYuGMSdMOs5G28XCgeTKsRqUc1ykcU/5x9+HUxjVfbYXvuPpC1JYsYbBlWio8BodXqCHXlt/z2NgqiMSQCF+qm1krWgi1wMn12D61uK4JKRQx0SK4K/omfnFnNks5qGRN0dc02MdxxB+WGkGoWU6ku8pBJygLyWAtauxjE32Ezk9VNx3CcEuxj/e3bHZMwomSskSubDbCpn8hJl/hFILLrwQrkcd+QK8Nl3Jy5m53STU8cPPYcw
 B0znsIVf
 0ce6J0AUg01YsLu57zY+fo++/XB9krbXiZrM7H4huG26tZr7v/nYr8HOajlIkfzncaqEr3OfF4PRxN0OzcZF62kQdcmDnfxn9sgqI9FcS5YE6dWSXEa77LBFqIokIxwzrSYj+KWHyYiX1BAboEmMNN8OWXHJ0OqCCimXtW/83ZTcXoUw51XHZ6Etu1k5vVzTccSlLQaMbu5VF+o4gKKw9spLW79fmlinznXF7og0vSECgucQaKs+nHiV8auzqYBuMeTy5CgoBnPT05HPNHPtk71qsmtVqgzWu9DvM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

The pxa3xx_cpu_pm_suspend() implementation hardcodes the default
PAGE_OFFSET value for CONFIG_VMSPLIT_3G. This has always been broken
for other configurations but becomes much worse now that the default
is changing.

Fix this to use the correct compile-time constant instead.

Reported-by: sashiko-bot@kernel.org
Fixes: c4d1fb627ff3 ("[ARM] pxa: add preliminary suspend/resume code for pxa3xx")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/sashiko-outbox-212719@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/pxa3xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
index 06c578ea658e..253770075a8b 100644
--- a/arch/arm/mach-pxa/pxa3xx.c
+++ b/arch/arm/mach-pxa/pxa3xx.c
@@ -103,7 +103,7 @@ static void pxa3xx_cpu_standby(unsigned int pwrmode)
  */
 static void pxa3xx_cpu_pm_suspend(void)
 {
-	volatile unsigned long *p = (volatile void *)0xc0000000;
+	volatile unsigned long *p = (volatile void *)PAGE_OFFSET;
 	unsigned long saved_data = *p;
 #ifndef CONFIG_IWMMXT
 	u64 acc0;
-- 
2.53.0


