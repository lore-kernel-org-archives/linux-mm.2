Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96777EFD23D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 11:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A386B00B0; Wed, 25 Feb 2026 06:05:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41426B00B1; Wed, 25 Feb 2026 06:05:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35696B00B2; Wed, 25 Feb 2026 06:05:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC12B6B00B0
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:05:28 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B62C1A0569
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:28 +0000 (UTC)
X-FDA: 84482697936.27.B9CDFEE
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id C854A140008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S1XiELdA;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772017526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zzyMxNvzMyycWrQ4teqi8VMBfU5GZXWjfAFiWBwDYeU=;
	b=eWLXmsdJCH+dH57Q7PahU7dnJlE2+PAMttDoHzPO0bWU5GtJi1Agwt1G8IjHqjPn7XhCzm
	8YbddXvrD6QQA6W7Xe0LDA2tInFL0WQte8XVvJTiHnw6PCPgehTN0k0XC8/HHTbis2T/6Z
	vweF8d1AhJ5jwxwqo8jdKA1b3ZE8SFQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S1XiELdA;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772017526; a=rsa-sha256;
	cv=none;
	b=omM/2Y9fO8xpbGnrM8iCvzLiEybmq9AKYHD0kh+y9xzqVatvlgYCIMT5mNjFu+L04wl0gJ
	PcSsaNjebuddq/PSgmOQQyUeixsdQZTfb4kyWbSHzqsXphepogkt3CIpyiz3W6KCKx23xJ
	DWlZsXoAqQ6mv0DYhnsssMJnqThfCVU=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c7059b9df33so345682a12.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772017526; x=1772622326; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zzyMxNvzMyycWrQ4teqi8VMBfU5GZXWjfAFiWBwDYeU=;
        b=S1XiELdARTXWfFkeYqYrzWYp5Qt4yt9DnIQpbt+NEX6s/jQxI0nbcHHDQMdy90mxii
         z8MieRq9QtfDc0oq9lpsyGn3rm+eQndmPmHeh1z6LejXp2ZC4T46myCvuugw8Kr4ce6F
         98rvVi+atSJNJt96NgF59OFHFGCQsOFAXBsvzx0hTc586oqsb2ggyFekuy83Bk3gkr/K
         HcuMOPOCPriNSyrfMJr4T6RECLnbN90xGVaO9hZHaM4oFjkeuCGnWf9KxT5DXGWwPg7i
         7ai4TLuRzVn6jLEwg10myaK0lPbYUIOByWTkGCvnzgqBXHDGCqz/9YrfWrURz1gjUo5r
         rFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772017526; x=1772622326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zzyMxNvzMyycWrQ4teqi8VMBfU5GZXWjfAFiWBwDYeU=;
        b=fE9SOaj3910jsh84SmGREJy3+ProfbQscX2kQTch6FN8wGnNPOjYsCSZmTTi2v4eG3
         XQDEpg0ZnbXfMkN8bJyA3YD9mZhv9odMI4/5mD5EYnzN+lyiz1iSN7BDNmVpyoRBfU+9
         jp79oVRK7LUBAVdIhI4c9+p02it18FjkaepNf16q2MXbbQkWOZDAO4NzbXKhrnhnB+lO
         Ui6LCS4qehKoTexcUoQxnOJE85+nCd4j7QSdOQkaLE2duI9eFmv8HQeafMGd0YpoKYqV
         EJnn0dNRWejUg0vkauXLFJMD+8QnmIiXAy82AL3851z3zDDTwHNte6xVb2iC8AZw0qMb
         PD+g==
X-Gm-Message-State: AOJu0YzKdUGTH1BScscN0C6d6Fdd+iFjweR77egpP/kU3bwU9mg6Fl6Q
	oLfZaI8nFY1GCpPQEvIP1lutf9vAEjxX1RH5+DJjmwGr8VNiloSFFKFm
X-Gm-Gg: ATEYQzy+8oDD3mv2L52GnGIM62dLm+/w0PLH+7Rbe6oczPIiZc0sO1dr+Y/w/12PCGg
	W3LwGQ607NLI8gkCgjs3ba+fbllW9C5o8VcSh9bwIa1mOdVJ/1jXxmVcE1h47GTzzVNn+9YBBXM
	WvTNU7zlno0l3zfXOd2/w+yUloPjEwcT0S0D1lUhMX2z1eLzY8YpjW6qIK+Dz2NuZ4hUI20mA6l
	xMMd0pUDR41i9OVeOK7fHyt2uzpAKCdcAzkjTb/wHCKHErkzLAzv/cV5VJsH2RhWxGZe7UFTBmk
	Xb++AjTRPpkPAbBOVQqteyBH0GkUGbJdivLGEHlc02o9PaUTE916ZExGH52+FdKXe8JHFEJb1kw
	w3SKYRibukj8Mg1PMPZ9iu4gkmlCyRpN5oiwIuU2uA5e8UQ/tYxjiar2MPfEcfueWgYLw9B+6Tz
	gVJdAAPQs2DVPrccWTVmrLetwuI7+jV5s=
X-Received: by 2002:a17:902:c946:b0:2aa:d6a1:e183 with SMTP id d9443c01a7336-2adbdc3c51cmr30803075ad.1.1772017525603;
        Wed, 25 Feb 2026 03:05:25 -0800 (PST)
Received: from dw-tp.ibmuc.com ([203.81.242.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503f9f5sm138365975ad.77.2026.02.25.03.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 03:05:25 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Christophe Leroy <chleroy@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC v1 09/10] powerpc: book3s64: Make use of H_RPTI_TYPE_ALL macro
Date: Wed, 25 Feb 2026 16:34:30 +0530
Message-ID: <3fb34ebce6a92855ce6c20326c1f7f99097227e3.1772013273.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772013273.git.ritesh.list@gmail.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C854A140008
X-Stat-Signature: bmq5ejfrhuabe7rbpyei9nrzkfpbktc8
X-HE-Tag: 1772017526-901967
X-HE-Meta: U2FsdGVkX1+16M64PDvoXcXdEnVtUUA0F2tdagAWdzf0dVrke+Yil+1Icj2z2IDp0JtZlISS/XH1BFfZVfRbJAhGuObBxScfMfh+aJDOqRxQOoPqgOCk81TC9/4KUQxa1tPsWHIPcIRDX3EtZEO1l52ObbLuOlZGImfVD+Se2eCrF9KiDGEWICBJjLS3Cz4vmaStmfS/hXPe4Y07bbuAugr5JSWBm+jdq22CdTrPa7325HCJeLZjbyWTFZFngW3xB6QRaBjl22S9+cX/nTw+cl9SfMFoWEj9Tc0o8myJ/U85h1LlI0QAFtWXq+TDuIQ6QK5zNJh5BUNzZwNJQ5POGUvAau5N5Y5AoDz+QmKHplgjx5huChhonUiIAyksQa+iXR2nbmA+ztuvkn/bHyprwiVX6IwwVPcg0QE6ez2QZ14+mkqw/1zrtGtWzvPlanj7CG1vGol2wCyLu/pyHt24UCSX1rWh5qCV43Ayj5+oXoRwliVLhldn3z4LbfRSHRvN/8/uy+6hAozQ6ADg19NLvP0hZGFAo1mW5Ga+tlWxOAKc9ak0SHuIdMOvlRo6U3rhdJ1aFWnprSByFCqPwhN0L28RwDAo0VlK0Eu0a0FlbPDOjfQs238RoUkHX8fdF4EYUL6+obGkt+t0TOfCzYiwaYVdDTn055N1OC1lxdkyhG0l6FbZGwe13eFYvc4921L8mIEJnxJXs2uLdvaAjD9GRniJY+rzfpAD4MOcFEiNOT7pcQUKBCNTt+3St1lIf25dDVgcjcdlTCbKUQf85MJPpPTfS6hvgdaJIgu35m5FkumcmaLWwixQG1FHtkIBA5o43UBIUs25CzRtMOLNlYocY6n3WsW+OaccBDijeGJNDKJHfdlMymSoo0YcoPaYNGQp5uIKLwMjTXCLErIAW5tXmEpopdkgITb7CpgKFn42sZEvY//AGAaBfiCLzpceUI4n2tlL0F//waRa1d8A/AR
 ANWCwRUI
 aBD2He20+XW/aWsCPtuRPC14tMVUsPL6lZN3nGH9mqFK1/y7tL2QgdEKoN3qvNTZyUI11r7SAkZWkBwSdxI4uKD/h6y4UmYo4erjTPLKhvOCY8g1sVGSJtgVqw4ZTiY205dHQJ7/pWSAZpnszRdBa3w28rWSm4k26MTwTcENK/F0MaACJJuG3MmOaMPmiw2HFjyQjiu127xufbhWYXHK+Qj32Seo+L9sptxTY52JeR98JtopeITASRlurxogJ00SY/Ib2z+bfvDb6Y/NxZEdIcqKEED6Ptp6mrdCaoBc43osjULkW7Xwe3wZaYdycLz6qF54kF9ROUk8blW/8ZaIdVZce4T8cEp4il1hQ9qQkzMLHabE2D59OvVHkylFZwQ2aotMHRl1ZCzr+OoC6GqSXud6M3GtUr6VdjePNwMEmKioU3pCfTmQKvC+oib1jfl6S1fmCwZyRDvHjX7Qv5xT0spIGzYzVxAE6tCo1SQefhVuz/EILsT2K74GKQfJWwkSqNVZ/BMKzGpEktVFWGrotpjOq+thurVd79qfPJnX7BR2CHh3ZC2YW/tty+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of opencoding, let's use the pre-defined macro (H_RPTI_TYPE_ALL)
at the following places.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/mm/book3s64/radix_tlb.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
index 6ce94eaefc1b..7de5760164a9 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -885,8 +885,7 @@ static void __flush_all_mm(struct mm_struct *mm, bool fullmm)
 	} else if (type == FLUSH_TYPE_GLOBAL) {
 		if (!mmu_has_feature(MMU_FTR_GTSE)) {
 			unsigned long tgt = H_RPTI_TARGET_CMMU;
-			unsigned long type = H_RPTI_TYPE_TLB | H_RPTI_TYPE_PWC |
-					     H_RPTI_TYPE_PRT;
+			unsigned long type = H_RPTI_TYPE_ALL;
 
 			if (atomic_read(&mm->context.copros) > 0)
 				tgt |= H_RPTI_TARGET_NMMU;
@@ -982,8 +981,7 @@ void radix__flush_tlb_kernel_range(unsigned long start, unsigned long end)
 {
 	if (!mmu_has_feature(MMU_FTR_GTSE)) {
 		unsigned long tgt = H_RPTI_TARGET_CMMU | H_RPTI_TARGET_NMMU;
-		unsigned long type = H_RPTI_TYPE_TLB | H_RPTI_TYPE_PWC |
-				     H_RPTI_TYPE_PRT;
+		unsigned long type = H_RPTI_TYPE_ALL;
 
 		pseries_rpt_invalidate(0, tgt, type, H_RPTI_PAGE_ALL,
 				       start, end);
@@ -1337,8 +1335,7 @@ void radix__flush_tlb_collapsed_pmd(struct mm_struct *mm, unsigned long addr)
 			unsigned long tgt, type, pg_sizes;
 
 			tgt = H_RPTI_TARGET_CMMU;
-			type = H_RPTI_TYPE_TLB | H_RPTI_TYPE_PWC |
-			       H_RPTI_TYPE_PRT;
+			type = H_RPTI_TYPE_ALL;
 			pg_sizes = psize_to_rpti_pgsize(mmu_virtual_psize);
 
 			if (atomic_read(&mm->context.copros) > 0)
-- 
2.53.0


