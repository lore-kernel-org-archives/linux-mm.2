Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 976D2FC6174
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 08:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ACEA6B0099; Sat,  3 Jan 2026 03:48:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08AE26B009B; Sat,  3 Jan 2026 03:48:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDCD76B009D; Sat,  3 Jan 2026 03:48:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC6F76B0099
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 03:48:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 766851A7FF0
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 08:48:15 +0000 (UTC)
X-FDA: 84290025750.02.4881FB2
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8EB12C0007
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 08:48:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DDXWv1RM;
	spf=pass (imf28.hostedemail.com: domain of ming.jvle@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ming.jvle@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767430093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zNQtBvCUtmnAPeuru8aiLc1c6bgNqqxLSRGoZ3PSDyY=;
	b=mx926fwxmnCEvPV3uc54LmaxsIqIY//bC9Wt5DMst0Ly3TittTd5pd2sesEelAy2w8kQbA
	eBPX0NUP8n1qtC7Zd2E2bCUHdN0eRnFx1Fm7Npa+mHBpeCC42Q6I9yYgDfaAfjTTnyo8Wj
	/rNu+ST+r7iMWEvYM0mFahlqBHW4o5k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DDXWv1RM;
	spf=pass (imf28.hostedemail.com: domain of ming.jvle@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ming.jvle@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767430093; a=rsa-sha256;
	cv=none;
	b=3m3JowkkSK1j90alMS5aJ5T836XJA1EytAqxHF2cAdLxkCMisB86ZxnYS5tzQEh0EWm0zQ
	hfUF8Apd/JhYc1pTZvMM+oX54Cs9UXVdCNwNUOnmqlN+t7S6FevErpJ9V3C8GAbOGT+CvE
	oIBuceKcyiyCEQzZ4yKu8N475F0YMbs=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7bc248dc16aso10066983b3a.0
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 00:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767430092; x=1768034892; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zNQtBvCUtmnAPeuru8aiLc1c6bgNqqxLSRGoZ3PSDyY=;
        b=DDXWv1RM2XVn5AUGCa9/GQCwezZ8/CGFCWiheCf0MOg1ESlbBI51ExClpGzh8warhc
         xvJ07GfcaouGaQuwCLs0aDf47/UCjQbJHdxOeeZfXK4JV6XX3HhFY2aO3DDiqwz+7U/u
         VJ+h19B/aEyQztt4Ezb+6EZngXHfmIqVATZtV5JjiFsxehq7EvTpodgC7HWl1xXnKJ5l
         uhVxdSBxjL9XvdfavalI41THmtzsiAmXyi9vz+k3EO7lPFYUk86QA5gXKPv9IUJ4MosQ
         L227d1jQRlfGlKTvlSyxVGSafgfh6YBjdQJJod/XGotv9O29sNTIpN2iP1KKSLlUyqkp
         Ubww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767430092; x=1768034892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zNQtBvCUtmnAPeuru8aiLc1c6bgNqqxLSRGoZ3PSDyY=;
        b=ZCdJasx8D6sofqE2ZUZNG0CwJCbr0ZmyIuBOV+VCPaC2WwdCo7o0oW3xbTqUlZvBAg
         JEz5FIUZ5LjEGG3g3QzxVXcluViQ7yLc1kFiNoiY8x7Zje5dIgt2lcuYmkf/clWmuGZF
         l3EOUabfa0/OnSHEzbHmzjPhpXh8Qq75W6Bk1gtiJyhOoDLxMshDYp2nLZU2t6tROL12
         go9cFwaTxSsYYIuy1AwS1URznzeB0UfGGPp9vkl8C+6DTB2fVWSSWujqjlfgYwipB4aS
         AfsI8DJQKRGdpoap74twqfHx7VBDwvyRl0KDtmVAbQCEuigbSjCjsCwek79nEH65icHO
         /bpg==
X-Forwarded-Encrypted: i=1; AJvYcCWv6vxaAaI+huXOORI5z2aBa60XT/9XOHEA8IrMeyYj9mNP1EYQp1fuD026cc//lNjgm1xfFlx/fQ==@kvack.org
X-Gm-Message-State: AOJu0YyYGLzA15gWHcPF+D0QfpEJ5F84Hsfp5+1o84kx3tjYfX4b69Xg
	SPpDTd4+oekZnZd14OD+4O118tAG44UjsW2WU1RhT1CFvAk7b4g193kC
X-Gm-Gg: AY/fxX6Fs78rRKkDj1gJiHTOPsJfNC6ZLkp4pk8BWvbdignJdUYypyQDRJo4UDjov4n
	1mBbyi/w1PbrVDDRbTU3+IDS6vPXSIe+E4Vy3ymWOBRxsUp2Ua3exEB9N4gTK6MqNBEXljIOEpP
	gnYsdGAn8kAUQ+o1pQ+FQuUlMpCqZwU6jGyv0J1IWdSJvTz5cEoPVzZmr3QZbG4epyZgs4XaKj3
	YwSCepCvHnTbR0/9tyNmQ9jhkW4OLH5C+jHIyWJu3fsXshLZaZriC7pf4PutvRN+EPKfqUr0NOo
	TldO1mT72XGsnUjfunHYvMwKmxEB1TXjJBARnEWR395CxSxp3BojRKKD9/48ZPkBFq6X/DrMzjK
	6p3Y36fQCVOkeYmKRJCAQlRvDDa4zc2Z+ISDhPt6c9m8xkYJqiLq2Dic+nyNmgAk3ynjYEY3vKx
	+SxhDa/VQGMc7VqwZzruMIZpR/JjgUU+hHH6A=
X-Google-Smtp-Source: AGHT+IGp+2Ae35OlKcY/AZO4SFhsJuhif38Zo263lmc6gG+RjhGQaVQCgX9rVZBWLxbZMYLURcJ7SA==
X-Received: by 2002:a05:6a00:e11:b0:7b9:4e34:621b with SMTP id d2e1a72fcca58-7ff6421137cmr37196936b3a.12.1767430092345;
        Sat, 03 Jan 2026 00:48:12 -0800 (PST)
Received: from jvle-ThinkPad-X1-Carbon-Gen-8.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e197983sm42704939b3a.33.2026.01.03.00.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 00:48:12 -0800 (PST)
From: Keke Ming <ming.jvle@gmail.com>
To: mhiramat@kernel.org,
	oleg@redhat.com,
	peterz@infradead.org
Cc: linux@armlinux.org.uk,
	catalin.marinas@arm.com,
	will@kernel.org,
	tsbogend@alpha.franken.de,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Keke Ming <ming.jvle@gmail.com>
Subject: [PATCH 5/5] uprobes: use kmap_local_page() for temporary page mappings
Date: Sat,  3 Jan 2026 16:42:43 +0800
Message-ID: <20260103084243.195125-6-ming.jvle@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260103084243.195125-1-ming.jvle@gmail.com>
References: <20260103084243.195125-1-ming.jvle@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8EB12C0007
X-Stat-Signature: emrzxrn69t8i5ff1gqtq8dcbspw5xzea
X-Rspam-User: 
X-HE-Tag: 1767430093-628508
X-HE-Meta: U2FsdGVkX1+iydXOmQkNfDDjrmB+lM2mGyfgavblCwly3p8xT0JKqNvXs4ZURzFlzmdz5ni6qkjyRzd/HC3LOTn+dwCvk0ThV74t+JVgakAKh7EFCA46rIrWSKLVwNngF6C0cS1LK7y71xX5SW8MZCP7lvZAg/NquIhMJdChkSElQe9FoxtciGt6Xx/cv5sdu9498fBQ4Wa5xgDCiYQLXuDgXaKr9WXfjBtgWACXes1QZ278bOkmPnk4bvi7f8wtA3vr7gkU7cdSl/So4kZd5XIrc4+wNbwvlQP3Ohi63vwWRJD7PenJOdyNUPttH4kZELKtlEJMSR1piCupM+8PoEz4qrknA26OuvQRRGywieZIfU9t4wvEyTEugQZikj/Xt3muyRbHZk/ed1NAXu/7WNb6hdpVRW9pgVjErUfZ+onBQGw9cZO0sgj8sGgSk7LoWpCWpLMKya1CjkJSpXtC0FwB0HWPSC6OJv/YQblAbFeVcfPQD8b2RAXamgb27dySx5THyegHF84F+X64kSp8qqZdqcDAHhWr831t4mhlxWwkFSoPtMpfh+Gy862KLUPpkvvT53f7o4TZr0NX1DcQOxJ8Ao4mou8XK0/9ngL/7HWmz5TF69EH+5qfbwhAwUG0BPXIH7vvT3xoI+srZLBJT5pzePqI8F2oCgujRCzrvn+Ig/k6MzNlZBGl+7xrEIOlOl5ZBN6T/l5twUVLgMlCRrIz1zx2MNZcYf+uYagJFuaXk+vEdQ7jayM4gP7zDboSezEycKawO8XTlqGvA4dPkRpRYY6af2MmpYvhqllNMvGveSC74eihVUs9cmgJsgz9dD7M7vDyCAgOwrv3WrG3ALIpANZ2lLj8zNabudwDilX8HcGDoYPbQGrJ0GgKKmN1Q6NjuYxkGSTjW8ZjJfzNS3bNfPVP5vzm83Z/qTM8bvThEPDTRE9HdVCY8GjCmKthCeH3NNxtfs20Wc6RdD8
 n1DpDVLR
 ckxB1FUyzGD7z7F3FqYsba04TJIxgPVtIsCyMxbVCsq9y74Ebx4vcCV91jDdFwpVUGn7QKklDzqGvX+lgeH0w8EBiPc7f1IJzlBRcWcuFpubvCYrqA0G6jAO/uf6vlRvEIrqlUy0H4gIuUdWywElPGIez+Mo5KAwVv1y25qNBoqxtP/Uw+jnbsEVagXTzT/baoxaIQU8mFPtvvyF0Y126Uyz8ItE8QFTHIM/YYcMHHbnCLbdVK0FMrjt/LzouvO3aOStswclfdXNMul04CfWND97tTIxO0twz8jsNw486FVT3XmAdZw5f6GtOKvIc2nR+1ieaNx95Mu/VM/1cDmodL/KhM8ZzhRBwFlS/NIGClxnEHbtgSO5T1iquH4vClpGQipPw+nzkA+Wxe7qtVdi4j21nphm7mO2ZBklCqvCRQzin3pmVLDeTe/4VeKrDxMliMBjg4a4mk24l1vs3MMu4fKPwy8kcRA82CRGqsn/8IMRl8fOLq/g7N8DQrUoq/DKUS8Tjssaj1ozZh8+RgkZDn11tRBey/apKHejrZ+EH3D0KJl/S5oQHy6tT2cWP5ngSQa8YpNwISKmQ8hAixb9Fx7C5jA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace deprecated kmap_atomic() with kmap_local_page().

Signed-off-by: Keke Ming <ming.jvle@gmail.com>
---
 kernel/events/uprobes.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index d546d32390a8..a7d7d83ca1d7 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -179,16 +179,16 @@ bool __weak is_trap_insn(uprobe_opcode_t *insn)
 
 void uprobe_copy_from_page(struct page *page, unsigned long vaddr, void *dst, int len)
 {
-	void *kaddr = kmap_atomic(page);
+	void *kaddr = kmap_local_page(page);
 	memcpy(dst, kaddr + (vaddr & ~PAGE_MASK), len);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 }
 
 static void copy_to_page(struct page *page, unsigned long vaddr, const void *src, int len)
 {
-	void *kaddr = kmap_atomic(page);
+	void *kaddr = kmap_local_page(page);
 	memcpy(kaddr + (vaddr & ~PAGE_MASK), src, len);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 }
 
 static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t *insn,
@@ -323,7 +323,7 @@ __update_ref_ctr(struct mm_struct *mm, unsigned long vaddr, short d)
 		return ret == 0 ? -EBUSY : ret;
 	}
 
-	kaddr = kmap_atomic(page);
+	kaddr = kmap_local_page(page);
 	ptr = kaddr + (vaddr & ~PAGE_MASK);
 
 	if (unlikely(*ptr + d < 0)) {
@@ -336,7 +336,7 @@ __update_ref_ctr(struct mm_struct *mm, unsigned long vaddr, short d)
 	*ptr += d;
 	ret = 0;
 out:
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 	put_page(page);
 	return ret;
 }
-- 
2.43.0


