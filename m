Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EFF9C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7CE6B0114; Thu, 16 Jul 2026 10:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379826B0116; Thu, 16 Jul 2026 10:59:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268556B0117; Thu, 16 Jul 2026 10:59:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF7C36B0114
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:59:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD777C019E
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:43:40 +0000 (UTC)
X-FDA: 84994757400.12.DFA9368
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 243C340008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:43:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ddRFPeB/";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784209419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oWUsUTsHTYC4oF1+U1zCOlOpJa+o/HcjMqULEm1jNKI=;
	b=dDa4PWs4PRF43IlBIBcWk7DelwZTIl7MEx9ymLbA94I5yDQGhnzsp1DnHQo39Fqh9r7Edr
	Qw+oFWdfGs4Mr52IUqt+gvDTdrs/Q516X9AZEEkw6uScCZ/4ZpmkqMT44Jij23r3dBfwTH
	r5M7xUEpXdOdRJzXRq+hQSgxgq+Koxw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784209419;
	b=dBlkWK+WDVYvOBpbaVO0mcWFlN7CYWcQHJQHpG2FXQTZsKjWNEHv2nOdwAK12R459+SW8J
	GrkXi2L794LqH5r2VDNahu/Y9203AZRoMiOkwyVf0AtLo5W1W0SKjqRyEVi+giQKRS6tcN
	oFWHpSsKOn01+AEaqyVEfBRYTHwhbS8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ddRFPeB/";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F77C601ED;
	Thu, 16 Jul 2026 13:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11B41F00A3A;
	Thu, 16 Jul 2026 13:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784209418;
	bh=oWUsUTsHTYC4oF1+U1zCOlOpJa+o/HcjMqULEm1jNKI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ddRFPeB/dy4N9t+1VV61tUOy6RSwcG9ODLZw+J8v/DsHFuvLSCm+SEyltiVJaOJNq
	 zfJEikRpZms7kR5FsxnW/wY68XiDM/HWCi7PgE+3mtkbuQC7zlsu+x9UM1MxQo71pB
	 L7i5hBbUGDOVT7oE57f976DdElPde+afbcy8vQ5PFOO+I32bG9ryUvKL4s1FGTIiKn
	 tI2Phf7XpCYEruV/Pcz11uYKUlbxmiCmMo9YcJdQwQ8bbrjgLRkkB+5hVvrV9f0xot
	 zjF/I+b9w6nqb3R9uLXQHPiwG9dOe6iwPzAHQxhwLMWUlVAwdKTyXNhRj3DgrjEkUU
	 VW1D68HV5+d+g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 16 Jul 2026 14:43:11 +0100
Subject: [PATCH 3/3] mm/mseal: remove further superfluous comments,
 do_mseal()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-mseal-fixups-v1-3-3a9609bf041b@kernel.org>
References: <20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org>
In-Reply-To: <20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4242; i=ljs@kernel.org;
 h=from:subject:message-id; bh=3XEOElWo0Iax9roa0jK1sDNI5MbeHwqjApf5pqY6yz0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIi7n+adExAyarM7UFw98yGhv+zX/n8V1ryQedU13Xv7
 fJWT64WdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiU8UYGTZdV2ExVnl8xdrM
 TzDynwdjRGP87vUdSg/3zqvgrD3C7cXwP/rh4aR5i1REq12Cd/AFBBhurriRJ3MixZtjhbT/4XU
 JnAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 243C340008
X-Stat-Signature: dttudihczby3msotcefg5hd3719ywyge
X-HE-Tag: 1784209418-892948
X-HE-Meta: U2FsdGVkX18vBz6O+LC9OcuwGfNZ0aJPnmGfSaiTbgxJCA55xCCGkyqyxfioNyNVpvTKIdhtfLv8I8aFEMO1GsTS0CBRyNXDfsgvqVs+6WiKy1IihgwVhaQjdmWD9GK5V4AVEY56SfiAKD6GJCusy3UTRW7ZyFZ9OKTc/ZMRNwVhiPIs3aa3uSBmwweFif9XUlvPlYb44crQVzmxIdjrxKIx5y9BRmB7KhDsXW2lqIJsRd58TNiXJ0f922rbyfMa6fgjCnUgJNirBMZSKyuTAHiwyOE8Ud+UmTbc3491bRgK35qDxGNxgxAHZ3HSRcBaaAuTsqULb07hUWQIv8Qcg1e9ONmjiBUXxXMIGPIDhxzkxQdOv0geblmyl46t0Gm/XFAXuw+Hf7NcOAHy2KCRZhN4fXc1OGm6SK3dklME+rbilnINSU/hLrAvBI58XTxcOt9nH2XTeHmXNNCzUIUWJAjpM/99ld+Q6jpFy/4/BHCUilTiJfCyaVttQGeH9ujbz/93BN1AN1GY+vVD2vD9iB63yggojq5VwlUqf6NjbVOkWJ3c+wG0u5cBA7aJ5mu05BGochn9CVETid5iBJ+Sz1lS29T//HmZIqbXv3BdsF95cQoZRH3FhhKZT5EpDyQ0qrUWLssLO7rX6D3wv44NlEhA1e6Y0NvjxionB2RKCeV4gOegcAscadL21U9iRYIkRsRVS1iR2o6BjQu+Vdi+k/HVQRCNRyv3nUKLs4neadlQYmbbaz2w6V2gLB7kf7FzZd2PqAiig49I2E0VJpSGL64eblpigRBCn1r/cY2H0f2s5LAby3Ipe0ScsbgukzDilQ4F637faASI5YUyoIMnwjxb/uGbrTBsVPhyKtPiwI3/VgjYZQE3xaxmCzS5dawF4AH/hNjAlYEaGsgF52we5uG9nXlz5ZBmVehUFQkr59/7P4rvtQUuTQJmmy0TzFYNUPmPMp2TEekgzuTwm3Q
 vdltt8BI
 fp3Mmd3iHBck4JEmLu4u2HqS7XK5LgV8GSOjdZjRpAOkpIPbE32Raj8JHAZTZWlRd8mo8MBneLmggcc3ax8jrGoFjvuewUGcp7u2mW4AZkOsxWsok8kJdIVZ1ca/6ddmMnPxXV//lsJmoXbniREoVxtvchdkSK7z2hma9jJJKgCioqXMoGHX3FlWUvSUtj11SSOxSwfDNubCcyBJKQI70PP+A2Mtnr/8o89j7GelV3T1Gyt/UtXIem3GeP7xNO7A6o19mNKP0bJdyU/8y+6sF7LfO4qb75BoeDEHK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to abstract do_mseal() any longer so put the system call
implementation in the system call declaration.

The comment around do_mseal() is strangely formatted, overly long and adds
a lot of superfluous information that the code already provides, so boil it
down to the essentials.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mseal.c | 74 ++++++++++++++------------------------------------------------
 1 file changed, 16 insertions(+), 58 deletions(-)

diff --git a/mm/mseal.c b/mm/mseal.c
index 5930551d84f2..d01ab35d3f0f 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -99,60 +99,24 @@ void mseal_mmap_page_zero(void)
 }
 
 /*
- * mseal(2) seals the VM's meta data from
- * selected syscalls.
+ * Seal VMAs in the specified input range to prevent an attacker replacing what
+ * is mapped in the range with something else.
  *
- * addr/len: VM address range.
+ * Disallows:
+ * - VMA unmapping, remapping or shrinking.
+ * - Overwriting the VMA with another one via mmap(), mremap() or similar.
+ * - Alteration of properties via mprotect()/pkey_mprotect().
+ * - Destructive madvise() behaviours (like MADV_DONTNEED) on anonymous read-only
+ *   ranges.
  *
- *  The address range by addr/len must meet:
- *   start (addr) must be in a valid VMA.
- *   end (addr + len) must be in a valid VMA.
- *   no gap (unallocated memory) between start and end.
- *   start (addr) must be page aligned.
+ * Since unmapped ranges can be mapped at any time, the input range must span
+ * mapped ranges only.
  *
- *  len: len will be page aligned implicitly.
- *
- *   Below VMA operations are blocked after sealing.
- *   1> Unmapping, moving to another location, and shrinking
- *	the size, via munmap() and mremap(), can leave an empty
- *	space, therefore can be replaced with a VMA with a new
- *	set of attributes.
- *   2> Moving or expanding a different vma into the current location,
- *	via mremap().
- *   3> Modifying a VMA via mmap(MAP_FIXED).
- *   4> Size expansion, via mremap(), does not appear to pose any
- *	specific risks to sealed VMAs. It is included anyway because
- *	the use case is unclear. In any case, users can rely on
- *	merging to expand a sealed VMA.
- *   5> mprotect and pkey_mprotect.
- *   6> Some destructive madvice() behavior (e.g. MADV_DONTNEED)
- *      for anonymous memory, when users don't have write permission to the
- *	memory. Those behaviors can alter region contents by discarding pages,
- *	effectively a memset(0) for anonymous memory.
- *
- *  flags: reserved.
- *
- * return values:
- *  zero: success.
- *  -EINVAL:
- *   invalid input flags.
- *   start address is not page aligned.
- *   Address range (start + len) overflow.
- *  -ENOMEM:
- *   addr is not a valid address (not allocated).
- *   end (start + len) is not a valid address.
- *   a gap (unallocated memory) between start and end.
- *  -EPERM:
- *  - In 32 bit architecture, sealing is not supported.
- * Note:
- *  user can call mseal(2) multiple times, adding a seal on an
- *  already sealed memory is a no-action (no error).
- *
- *  unseal() is not supported.
+ * The flags parameter is currently reserved.
  */
-static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
+SYSCALL_DEFINE3(mseal, unsigned long, start, size_t, len, unsigned long, flags)
 {
-	size_t len;
+	size_t len_aligned;
 	unsigned long end;
 
 	/* Verify flags not set. */
@@ -163,12 +127,12 @@ static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 	if (!PAGE_ALIGNED(start))
 		return -EINVAL;
 
-	len = PAGE_ALIGN(len_in);
+	len_aligned = PAGE_ALIGN(len);
 	/* Check to see whether len was rounded up from small -ve to zero. */
-	if (len_in && !len)
+	if (len && !len_aligned)
 		return -EINVAL;
 
-	end = start + len;
+	end = start + len_aligned;
 	if (end < start)
 		return -EINVAL;
 
@@ -177,9 +141,3 @@ static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 
 	return mseal(start, end);
 }
-
-SYSCALL_DEFINE3(mseal, unsigned long, start, size_t, len, unsigned long,
-		flags)
-{
-	return do_mseal(start, len, flags);
-}

-- 
2.55.0


