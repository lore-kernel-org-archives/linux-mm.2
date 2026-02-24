Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F438F4BB6B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A363D6B008C; Tue, 24 Feb 2026 12:58:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F73A6B0092; Tue, 24 Feb 2026 12:58:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92DC26B0093; Tue, 24 Feb 2026 12:58:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 808FD6B008C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:58:20 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2EAEE1B63C0
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:58:20 +0000 (UTC)
X-FDA: 84480109560.24.374391C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 868144000B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:58:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771955898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TfZCao8eT3K1iK4rErnvc1JseTGUetZNFAIXCIxV164=;
	b=fS4gZLAVQVxmTXI81fnyN6fSW7DqkzCT5GFnAvdV/LbRQih+HL4NNFTckPb2kYSDc/rjQu
	SHHoVFzI3ddzvHBzpHwgs+ylP8QCRYTGYAZyqrsSKkQqvzZlTgr6tvLxkihWLDyOFip5Yv
	lO0oDhDcIdtOPYZAlzql+E/qAv3FqWU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771955898; a=rsa-sha256;
	cv=none;
	b=upjTUrOWjFxDuAzCbYE+ywtznuM/zMGykOcnYANfA8ufzX5lfYuxsdQ7gSaTekYoixo35b
	XSWq5AxMxRUeFo9ERAW/a9yx9VPoKIgPa/oM+D/4v+BzIfUo+NFfoDgtL+7seqU8lJRDiQ
	1I5ZmaRvFCJZs+C+JyBnHXEbSKVaMfc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 777404414E;
	Tue, 24 Feb 2026 17:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04822C19422;
	Tue, 24 Feb 2026 17:58:13 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Will Deacon <will@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 3/5] riscv: shstk: Use the new common vm_mmap_shadow_stack() helper
Date: Tue, 24 Feb 2026 17:57:55 +0000
Message-ID: <20260224175800.2500729-4-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260224175800.2500729-1-catalin.marinas@arm.com>
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 868144000B
X-Stat-Signature: jk54qxni1b9rbjbwct7haaidnpieuwza
X-HE-Tag: 1771955898-443861
X-HE-Meta: U2FsdGVkX1/+gUlpawmvPONhjqmGqj/AfqSq15PwiOnX9dt+qFDdmdi71dyaF5qK2pmFUzVTxYXmJieG85dvbB4bhFsPJYqWkMExOjsSFXcuRj8Dg3ygJHb+VPYD3jQw6qPZxG/WBunj2TtsRrpxpf9uRpv1EtHFg/BWq0AKQYcWhsR6TYqKNmU1yWqBm+jENymKEcn0HSfOkQ0ynhig/G9ZIzy1V2/nVdPqom1rLSLk8ZYhjHKPTo09W8Ai6M3QuhwQ1rEL/QHb5ph1/+YeJjAhmAg+LleGiRFrP7f2ss5Ez+/o9a7/kBTXW/upemL0VvrV05Rx9F0glupZ3WYXL1osygRuXpw9fcuochv2FovVMtgVKXkhf/42l0S/FXlY6XrxJM3Bharx8I27D4DpsF5Sfa+wA871Ij2J/QC6ZptcnGGdJ5JSYHu+6rWRohTQNzIww5oRNvd7Yz51LYhOYvl6AS7c7lFNNIWiuinBpqe+ugwQhydkt8nDiw2gh62WRXDev/G0XDq3zirBN4fzuAjMUfW2B7H3D+dKESXGG3WjRF3jGZ3oW9etsxEjUhc/5rM0HtCdS9dSKQmzFLsC2i99lFkRBdXLx+8obJWgX7e9OtamQ+apzACeZoTT/Vs4f4UbkVuKFeBxptc6sxDq793r6G2G+uxw2q89HUqxuVqpogwtrELrj29MvGtxUmfWF/bDVLtUjmn4VfeEtIgOx8GyJJB+uDu2QeaU3ECUdA3tqcsRmWqarUWHKI/N8772b0F9UYktW0KtXzCzlh1FWflO/fd//c5vqKbpwuM+PF4VkNUPy1Z0wyRqQbnKbWcNyMepUx6lLzQD4N8ti/SEGq1KAcAqkT8eHQG6jVg5vHuIo0vhxdUqiZS/2Hj7RrCU91b27e0RJESEuIJyJlfZc8i45yKguYYsP1VRQZKCFmihQu4aOM8eu96MnUtPfNJ6YaMQlQvJaPVe5efhpZV
 56AJBq5Z
 /BDQzl5L3kDOAfCFtKA2KF1BQXSGvL7myfraRG4FNuS/7jR3h7fU+p1xOZ63pSpTboTJ37t7cFpZnXz3eCmySONyHuq6yDHr2YQAHU2Ou5W54Q2i/YNE5zfbCvC9rO6tY7WDYXGUQ8syzN51H1ctI758VTw9bNjwql+uNNkbELalNjpwH7UUfmkrDZ++4UZlqv/5e37XZanOQz6XMsEKPxoYTtK5OldSIQlSjxLFdH3M8gicT/4PEEZXwRYhUulRG9Te//mih6Bq/zkOzNS8b4jDgYDd0bZAwccO3/lcSVEusbmq/htYVuGNBQWQI1+93hzrH7B3Md4IfpzACmNlul/8l1JIKNvmkolHKtgNVW1ceI0pgEZrGdODl/8XOoNSAdRbYV0p3sz9aZSH7DoPMWaA+o2ln16VlNdWyGmO3cSAnmtiIGOAlWrpM0oKdD5ASW8BOa4snkRCtag3d6QxKGsNRcX/s1G+E1FDnlcp1e/WeX+yb4EldY03+zXWwi+rnIrhmvAscV64IC2oENXpTpVrO59fCthUWoBL+Rj/OAKyUOfY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace part of the allocate_shadow_stack() content with a call to
vm_mmap_shadow_stack().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/kernel/usercfi.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 1adba746f164..7e57f54dc5b2 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -230,17 +230,7 @@ int restore_user_shstk(struct task_struct *tsk, unsigned long shstk_ptr)
 static unsigned long allocate_shadow_stack(unsigned long addr, unsigned long size,
 					   unsigned long token_offset, bool set_tok)
 {
-	int flags = MAP_ANONYMOUS | MAP_PRIVATE;
-	struct mm_struct *mm = current->mm;
-	unsigned long populate;
-
-	if (addr)
-		flags |= MAP_FIXED_NOREPLACE;
-
-	mmap_write_lock(mm);
-	addr = do_mmap(NULL, addr, size, PROT_READ, flags,
-		       VM_SHADOW_STACK | VM_WRITE, 0, &populate, NULL);
-	mmap_write_unlock(mm);
+	addr = vm_mmap_shadow_stack(addr, size, 0);
 
 	if (!set_tok || IS_ERR_VALUE(addr))
 		goto out;

