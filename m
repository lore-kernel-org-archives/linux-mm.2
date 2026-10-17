Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAAA9CCF2C7
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 10:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080A66B0088; Sat, 17 Oct 2026 06:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031856B008C; Sat, 17 Oct 2026 06:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF9C6B0092; Sat, 17 Oct 2026 06:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C34006B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 06:05:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C429A0261
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 10:05:10 +0000 (UTC)
X-FDA: 85331685180.13.5D04650
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9537C4000A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 10:05:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=fkNO9mgm;
	dmarc=pass (policy=reject) header.from=itx.no;
	spf=pass (imf12.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792231508;
	b=iTGvlwQdfWjHYlRCmPfezgj9BaiBDcVm0T9MadDD059UWGDhcd07evN6WQGbfb4Swv1TRO
	W09b0jWiyaUA3Qj8d/UBL9/K4kI1AK6mAx0y37DefBUxn0TG8akGUJnn/uyFjLTBBdO7ha
	5x4lMksrFUKfDZQlMPyjuHogJlCx6tc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=fkNO9mgm;
	dmarc=pass (policy=reject) header.from=itx.no;
	spf=pass (imf12.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792231508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rT54bwXR0RkT/QOli/8iX9p1hf/Ll8/Tyy05zQ30IMw=;
	b=1dHoACuRitF12HgO7tmeNv4+2HeM+Av+/O3mOXghi8gPd+48bOAs5GKWDqSfPhnOSB4M2z
	c+h7qJG4MAzEySz9furIDTnxZg3YbA6WkKc4S2Wg3QhP72lzyQceA8vBgCs1DqfowMeZdE
	Q/BRVE2OUhutF7cRd7xtuFDLfNJd0mQ=
From: Stian Halseth <stian@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1792231506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rT54bwXR0RkT/QOli/8iX9p1hf/Ll8/Tyy05zQ30IMw=;
	b=fkNO9mgm5puVGBeVviBnR8oced7WC6Sl5MiuLui8A8qLs7wXeGPAaU5R7EHrPhOefcJLOO
	rnhHPh3yLTbgOmOdjQgjpo2SFTO+8j/UO/A4LP3NVarvaQWxkMma42cnFjO003on18sZTu
	ssjOw6xQtQ8yFzM0is8KC2gG++H9yE0=
To: Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>
Cc: Kees Cook <kees@kernel.org>,
	Michel Lespinasse <michel@lespinasse.org>,
	sparclinux@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Stian Halseth <stian@itx.no>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] sparc64: Start bottom-up mmap searches at mm->mmap_base
Date: Sat, 17 Oct 2026 12:04:50 +0200
Message-ID: <20261017100451.2266781-2-stian@itx.no>
In-Reply-To: <20261017100451.2266781-1-stian@itx.no>
References: <20261017100451.2266781-1-stian@itx.no>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 9537C4000A
X-Stat-Signature: eqpd4pra85qk787ejpjczt8jq88x4bhx
X-HE-Tag: 1792231508-533584
X-HE-Meta: U2FsdGVkX1/HJ89gcoKBgnQOn71ZtIwtNIcJzUYl6us/n/lxeg5piGjwBONk1YxCUzzTHax+PVGCIOOJz5WFj3fVMgyII7iJZRFikgGjWNWWTG9XZeWImPKIcF5b0WoW0lP6p8ACaKlWTEPLLQufH7NrbGaBgMMmKgNAe8yadiAqrhuspAGkklMRRAF3ZkkBrmXv96+ha6A9S/C/qSwxQLiaYDmzUiF+3WVEa+HoVVnK7zAy7iTZrTWtwsmzrgSJy9ONmacRbo00ygHEOp2S9TfNK8/vZdhGP03XV+Ow5YchL1db+ouqK8LVqxsjtcBusIdb/u7Ts9CjCMqMMTf2dBNQvHa43RfHqnrqV2rbq+V/Zzoham1ZkQUdGxih1pVjXBYhmHi10GsUGzCADU5ehC62qwSB2BzxBpRuT7ThiDithhdIQO/9P8wefIn7IqoMySMRKb4wVw1rmFgScT+z0XE/txvfTy54LZXFsfm++ayp9xOcTgAwTCZUCHnyaWWeZWzyb6t7RKTSrbnAMjujTDDbs5ahLcviOqoMG1hvrlQiAj116HkhWoUwfWyH25StHACul7gpKcBEVWun4BDOzD8d2zeqdMJnmSaHmdDjjL8f60y6wFYusmaaPvWdItaCkqqtkVwhusmpscMAf1bNhfVejMvHiJfQL6JdvAf4Ly5LKu3KuCnerUD0Q8vp6EYictg39g1bSOtoFfeMtTJuuVhg8Uw8Zjl9WVHsBnoPLdfq4dCHmutUmyxQ22uDvyVJYLWPN0YFyyPSYaMbzvn7XjHnhzWMYasDLVXBEUt82RBn2MC/UYCeirCO+T22Muh1rHAobG0Hpt42URsvCgFEctE0mWsHLdaEpJPYHbEkrGkSt/QtmowLIHuH6iQNXkfWEGwKR6QVy/1sGV41f0M9zV7dyPrNLaGj8YNbk0FqSFWMzuj6cCfR1qADsrROpN5D8ny+P8p+o/1Zx5PAVRM
 R+VNyPYy
 DrHomFkrqieFeLE3v6A5/w85TxAwmCu3ewk5YgisDwABHK/smIQQZs9yxpGKeIlPAuQUWU4z4g+UIBBqW1hNNc3dCwrPk+TY4YwSRupggXfEBbV4DpkBhEiKcqFCC8nloYsfRO5+0OGtyKpwiLGjV2b/hQjykb/UGQYvufu+una/0CidbQ3puhlA+rhHMzuD/oPDx6XbT7k4WIbcAdBmNw1drT1NrWRqXmLeg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

arch_pick_mmap_layout() randomizes mm->mmap_base for the bottom-up
layout, which every 64-bit task uses, but arch_get_unmapped_area()
starts its search at TASK_UNMAPPED_BASE and never looks at it. Shared
libraries and anonymous mappings of 64-bit tasks therefore land at the
same address on every run; only the stack is randomized.

Before the conversion to vm_unmapped_area() the search started at
mm->free_area_cache, which binfmt_elf set to mm->mmap_base. Use
mm->mmap_base as the low limit again, as generic_get_unmapped_area()
does.

Fixes: bb64f55019c7 ("mm: use vm_unmapped_area() on sparc64 architecture")
Link: https://github.com/sparclinux/issues/issues/119
Cc: stable@vger.kernel.org
Signed-off-by: Stian Halseth <stian@itx.no>
---
 arch/sparc/kernel/sys_sparc_64.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index ecefcffcf7b10..087595fa43081 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -142,7 +142,7 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsi
 	}
 
 	info.length = len;
-	info.low_limit = TASK_UNMAPPED_BASE;
+	info.low_limit = mm->mmap_base;
 	info.high_limit = min(task_size, VA_EXCLUDE_START);
 	info.align_mask = get_align_mask(filp, flags);
 	if (!file_hugepage)
@@ -151,7 +151,7 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsi
 
 	if ((addr & ~PAGE_MASK) && task_size > VA_EXCLUDE_END) {
 		VM_BUG_ON(addr != -ENOMEM);
-		info.low_limit = VA_EXCLUDE_END;
+		info.low_limit = max(mm->mmap_base, VA_EXCLUDE_END);
 		info.high_limit = task_size;
 		addr = vm_unmapped_area(&info);
 	}
-- 
2.43.0


