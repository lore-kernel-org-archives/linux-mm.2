Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42C9BC982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43BF66B00B2; Tue, 22 Sep 2026 04:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413AF6B00B3; Tue, 22 Sep 2026 04:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329936B00B4; Tue, 22 Sep 2026 04:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3B9C6B00B2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:45:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C5CC403F0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:45:11 +0000 (UTC)
X-FDA: 85240763622.27.F2E77DA
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf18.hostedemail.com (Postfix) with ESMTP id B400B1C0007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:45:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d7KI00ou;
	spf=pass (imf18.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790066709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFj2nCVpKiIz+n9fFlODHsR1pKxI11t8bWPyNgAqBFI=;
	b=Xdyw84G57FNsRgC/QL0CiGaFz1j7xMnr/16AUj5wrklAhXU4Do+1mHnSFPmHPDEa2mwZ1R
	s7Sjnxxpn0wlPXGcfH+NaetCexEqiArUyhqbnKnX234ucJY6wTpk1zja/M6hGqNak8CQ4V
	S5wbuf7KBy96gOT5PpRRiO0A6kL5gBk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d7KI00ou;
	spf=pass (imf18.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790066709;
	b=qSrEN21ZNHneLedyjIe74aJCP5j86GOnx1KKK4aFGQPa1OywP9BRO1yKvyGRVLvB4y4u0T
	IvzPu4FvK5yZTnmXyZqq/UyBkBL5MY4D3kzGgdhVrUn+yXD5TGPb4lf1td019XXcvzH2oL
	NlNgjhhYGX/FO2IKj5xc3+wkSUbLo/s=
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-39569e136f9so3160260a91.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790066708; x=1790671508; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xFj2nCVpKiIz+n9fFlODHsR1pKxI11t8bWPyNgAqBFI=;
        b=d7KI00ouOdHHlcwBOX44JzpRK8sVeo+nNYAD721W/jCh0ewZ9obraAMz/Iz/ogh2lP
         5wZefxNfBMAFJ6e/sc3nEOXj3+/7oAFqQQzzODEybLLfi0SYKtY0QmknfhxNKPrXhs5M
         qFylXtrkeczdTjHonzyhD0XW9tLO/6iOWESmI6jYKCUEaMX93VaHriIW4Ltc1gtrb/HC
         ICbH/GU0ibBsdi/QKhK8y17Aooc+i5t3UNkZM2o2sgn7YmHVpxKEpBB2INubDCLz3mt5
         jC24DWkQaDBKpWX8r2TVNwgqBLF5n6gECaLZPzX1uCnCRfQU02MsiZ6HOio6UJx3BUIU
         6CJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790066708; x=1790671508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xFj2nCVpKiIz+n9fFlODHsR1pKxI11t8bWPyNgAqBFI=;
        b=tb96wvn66xkRLehG5BR1zYoAMNvs+8SvuTIUmcJ21mMHkcTLe2meUhLSIif/dG+FLg
         rEKUdpnvnBuYJB5isbPlMc5ScPDZtCd0kiTCbObgYWwQmmVJW3+kTgrjFo5iz4dISUq2
         b0BbTg7iENzPKxsS5fn0FAgWSYYYQesv0HqOIwq2UhYiZy4nsE5t2meeY5ZCJq5DqzDT
         iCt2NHrHhW9heydgjoiyXq2Qd7SaLZf+/pkVOQ5DVoXcGFfl2L3QUTCBUOMU4zd6lzY2
         AcvlULpMilEgHxAEJpt4RZm1HZ1aE7dWeGVMRhKnKr502UPdGSe3pW88Yb3/M1W0v5KQ
         4aaQ==
X-Forwarded-Encrypted: i=1; AKwUvBx+1W8lfeBCSA/AbYlJ4IzJW7VdJTHo4/xcATA1wQrTqgwtBZtjZPiqWMiX/oxFuz+9BwJ2OAB96Q==@kvack.org
X-Gm-Message-State: AFuF++mVDXUbHiT5+UXItvnA6laiFNwzIOVFW99KUMy67AHgmxK2y6Kv
	8Blj2jIb+d0IaTu3QlhkVx7gd0st78IQXBJfB/aTFTn+Iho0lvUcqyez
X-Gm-Gg: AYBFou2luQtRnGYuf1WfBliNpSfV05GZTGAHHND8qMfKW25jfhnT7Gx3cKBDoU7z0ZK
	XX1el5+93pnuHqQFj60UeXPjd2FC4YCmEgqSdzOSTZysSDTRG5RD5pvxS0MuwO2uElXUQZ3L1SC
	iZDozk3vvOFKzS7xIG3JNnURzoqS7Ub+2uNsCWEcjZRgUtFGhADijuZAOWM02zx92orazu8G/Vs
	ijjKwgAJ4UDbwuVJ7DvkrRmZTTfeTSoGYG5EYIaauFaypp6Yw10Cl65cQ27ZRjKqnSUDyKyLd+G
	D6nc3wMxGRq1vOdMnT8OuTaqnLdpj+ewlS7Sj2aYyQAM3r9EtG/u8fGPCFsRsiNmCKINIGEkLaV
	+QaBbECGLZ6kq8bsyRuylMVn53s3ydH3TCgjfOdyBo4MU/s0DVZO3ArGK0MPa+7AWAyCdWgc0Hw
	B+FJwO2dlwG5uoRF9BHnlymagVwGvSgNguCROVHXT90RUAvKlxLmqaYc6r8H2U/yX0rv/6nwznn
	BLx6y5TNrf07BO3ejorVA==
X-Received: by 2002:a17:90b:1d8c:b0:39d:f4fd:8075 with SMTP id 98e67ed59e1d1-3a073182cebmr486642a91.19.1790066708546;
        Tue, 22 Sep 2026 01:45:08 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0674a5ae4sm3670016a91.12.2026.09.22.01.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:45:07 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v7 9/9] crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF header
Date: Tue, 22 Sep 2026 16:42:56 +0800
Message-ID: <20260922084256.1515554-10-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922084256.1515554-1-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B400B1C0007
X-Stat-Signature: i8cecx545xsa16szwkfz9mkxthto95wz
X-Rspam-User: 
X-HE-Tag: 1790066709-269351
X-HE-Meta: U2FsdGVkX18rj4IXrDEoApK/WJqLlP07CfjVwv+HbfwiLN6bdy3hVUdWprl8Q7C19lu/NkIVGQkMhagSMILcNbSwv444c7RexgPyjVnRXoD8jW7vG9FwlZw0nh7fU8wN6STiU0KRgEfdSqSQqA0JcX6dhOc4aRi87w2sd5349DDXpahuu6UC/XPFsm1G+018tR4v/R6HmFZuPevoLhKQl4OESAEb55CIpopCKp9Fpl17FDmE5zn+Mh8gXwjNIrHH6ItruzffReudVCZFWVNBHrZ2pMqW8DdHDjJDGGhYinypxeRKkPiHLsFQAZYaCO0OImuK5TiEXmLx7mmrZ1mPFWwOVzIe4kZgJsFUvaDBw5cX53wcqKMKb0/NtwC8061kWswBC41+TLJx61go1/fMbrEhrPEEtfP5RGtUKkdanwjLOLsZZAZv/wgjX2INeXb39aOtiK0acdUVEq77FUEwzNQlJ1beJAhpyhiVVazldZcHq6DziwphukDaB2lfkPDgNWzEtXUnoA0btMElu65axfhXgpM0iakl5DGgi96o/DUTHAAMq0Ul/qgT11kCeN7Ii4wWaMkQcM70zaJZhA4EW89pKVoMRFqepv1y+Ioqse3xfSojR+SeyVcnNko2TBh6YxGtSTdfbTNkTh9d9ZUIIHyX8SkPPYBXBSa6N25gs9wn2uqC3xte80/kXb3elNb0i/Ihc3PdydDrY6WioaUr51ResOpFpo2uL1PLMZoKRwERL5gq6gKGgj/O/q7bCJD1dtlMPQCXnVYQaMliWdu6T5HJTaysxjCxzox/IcIZJCxooJWlyxe7RISZMkrzLjZpwgczwksOjOPzoyzRxyHlCteXzsHjAX9Bm8JsbJL7VkaF7NCzv4FObc7pW8TLYkn+KqiwIJ+Cxa4gg4gMqdmF38qfOparbJZV4+Yz482oCg+BqumlaByRlzAV38p9per/DQmh5sxfIlTYM11O9oP
 TcjOP/AR
 7wx1odxA/uL6fi7hQv57PM1YyZ5MPyy5T8F7q9fshn+T6wibrhv00pFzC3ke9BuqUO9SvUm59yZVS2stg33PUfkAp3ao4nKqHsS9TdvZaGQvrcHkLyb1Le2Tog8VzBvK+6N4N8MhhPS699GLGxJyLzc4kLMHrUttt82zS1lf7+hKRlrBzBHgp/Uu1X0/fr9TYvpJuaIQG2mv3WJO5fmfDaCDPRizu6SsYLnVGAq79kXukna+TXb3gXsbYLIDSuM9jqIQKOk0NTR9NwnFnPTAdYj415aH+7eZ/tRpmSpuVOaHM22FjBTmImN/s4mI5MUxRjCH4vY7q/Yd8reatzLk2zoUd7eZZ5oFTc0JtAnnvAwGw1aloWaz0GqodFN9F30mWSm8nIOoI9zsWQ/6pffn8aHcsuUybeV02qN7QP6PF3LgG0cCtzvvLmIFAXJ9mbqi/X3X7+3BMRiBvuCHMvtkZ70PkH+rIsG7U7Uga6XFJ1lK+Wy+FAkBGnzo4MAXh0Swu07F5xSYZ8UPUtL5CfjZMLvw+bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Reserve regions (for GPU, DSP, ...) carry no data useful for crash
analysis. Exclude MEMBLOCK_NODUMP regions from the vmcore ELF header to
reduce vmcore size and capture time. crash_should_skip_region() now also
returns true for MEMBLOCK_NODUMP.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
---
 kernel/crash_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index c7acb2e449df..fdfeee5afa1a 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -270,10 +270,10 @@ int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
 	return 0;
 }
 
-/* Exclude NOMAP regions from the vmcore. */
+/* Exclude NOMAP and NODUMP regions from the vmcore. */
 static bool crash_should_skip_region(struct memblock_region *reg)
 {
-	return memblock_is_nomap(reg);
+	return memblock_is_nomap(reg) || memblock_is_nodump(reg);
 }
 
 static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
-- 
2.43.0


