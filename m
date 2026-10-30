Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92DE606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 19:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iWeVmgHp
Received: by kanga.kvack.org (Postfix)
	id 049EB6B05B4; Fri, 30 Oct 2026 15:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3CD96B05B5; Fri, 30 Oct 2026 15:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52B46B05B6; Fri, 30 Oct 2026 15:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD2E06B05B4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 15:12:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F7A0140805
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:12:00 +0000 (UTC)
X-FDA: 85380237600.03.EE51528
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 373EB20009
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:11:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iWeVmgHp;
	spf=pass (imf13.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793387518;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AdjV0Dc6jq/EF2upr0RQlEptHizYdyJQMh7DJ2M0kWc=;
	b=RZrY/r8HD4hMBYylyo6yDVGrIj33MflEobmlaviGdcW50LTzCy5Hi0skHuyFrvjuzRdfmM
	X81t4aGYfjjTktG29ITazcMLVESguojgpYq6jm0/VIIOTZu/R1wq9FSAgQTesS3e+mBqHk
	24/p+UWhlVX9i4Z4v9dvQS3vKRU7cN0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793387518;
	b=Pd7QaNvzGKCVOBBMX541ztrHhqEiHxEM6QcSZkLRThoosKKX+H4QLIQFwLlT1gPc1vMWth
	cSoPknLtMDsKj3JqcmzMs4jWqr4edb6/TEbZJpPExq+A8tGtlfL6oY4BanLun2qsOQlnaF
	noa8IhLhI+k/CBYnXtuzmEgj+UX/sJY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iWeVmgHp;
	spf=pass (imf13.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B3F242ACB;
	Fri, 30 Oct 2026 19:11:57 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793387517;
	b=KL2zpdG3oBasmC8bvaCpdFwRkSHmaQ2Se7DPWfQvIB4hU2OSGIfPUALiyah5DPKQN0eR
	 EAnijLEqmamQxEiVZHm7qHe6rLQve6afLbJJoynVG2r2Bq1jvnWBs+KLgpAXGR4WsXQcw
	 PzqevpDTpXOwkA0kv92BnMsA/09JmKBHN0cJvlurkjQJUz+6MSmN3nvkwerdEGTpMxZpk
	 i581m3WZFr1aWNVsYJDept7Gzl/pTWVbMR2hfaJwTpwF40QsUBChdu8gki0eUVv3psmn7
	 /b/Gh1h9rqLHYP8n1tV3SYhN8Xuo2uJBXWPezTIVrp/PebJ1Sf8giRcnFsgwmgz2f5g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793387517;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=AdjV0Dc6jq/EF2upr0RQlEptHizYdyJQMh7DJ2M0kWc=;
	b=udeviO3Gi2lELJ9IAkUM1qutiyo3hJ7q+3t4hNTKzRQGjKJnfPpgWd+YXTBhPVDUjD41
	 SIM0gRiNZB9Qb6iFe+sfazgrOrY8WsKOmJayDxFfZ5WaoTkbufZYNr3fkHUFaYK0g5o76
	 OOsfb5v86NvMgic0622TlNR4DfbZR+p3zrOXPhQhXUV2ipjr6X6zqDCL/0VQmu3AaimPB
	 2D90M6MQB6+IX3USGMS5BzfNYYuFz6EGxW8qfpExTCAVBRhTAfDhEsW/7bLCOSx8AAbsg
	 jKzk1hi05sxLKYPV+MbsAI3aPNfOG5gpjyY9EC1siVrxny0jf/dyDWIERz/heUX4qAw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AE72F1F000C1;
	Fri, 30 Oct 2026 19:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793387517;
	bh=AdjV0Dc6jq/EF2upr0RQlEptHizYdyJQMh7DJ2M0kWc=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=iWeVmgHp6u9S6Dqzfpc97M5zvM7sSv8dHy1CP8A8IzygwlYP/cWh9k3Ux0KHDX0aP
	 jH6CTqkVLCPAd+X6yeMZkL4dWx/apTJtmrN1AwUOMHpG8VcMBUxth2G6vUP6m3SmN+
	 jzGeMQeG5T4InEf76LZ3Lhq15c29fp7FLydadra8zlslOZDdgJSGo8TMHTxrUdJvCt
	 NZz6/URB88kqxzElxgbYTvFqjVuGWyrrPLPBZeNsaRf9zFInKUBmIqRbpDzpoD+D9W
	 ozjJ/kLT79viKYg4LyZNrUq2IxGb+ba0ltprCXEcnHRJFP3D/utO4kYakAuUO8586Z
	 Q4Bk9G+Z12OEA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 11DE344258;
	Fri, 30 Oct 2026 19:11:56 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Fri, 30 Oct 2026 15:11:56 -0400
Subject: [PATCH] mm/swapfile: drop a large unmapped swap-in folio in
 unuse_pte()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261030-swapin-large-unmapped-v1-1-41e4ae378e6c@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBCF4avIrBtItAzqVaSLGEcd0RgytQri3
 ZvW5cfj/ScIRSaBOjsh0oeFV59gHhm40fqBFHfJkOscjS60kt0G9mq2MW2bX2wI1Cl0ZY+ElSn
 xCekbIvV8/LvN67Zs7UTu/YvBdX0BHaXeEXkAAAA=
X-Change-ID: 20261030-swapin-large-unmapped-6c8f6e691864
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu, 
 stable@vger.kernel.org, Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793387515; l=3373;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=M5/KO6o7bnSBNa94hHZzVGfNGuYH0esspd9WRLUeAHc=;
 b=cIsKIDl0qQSY2um96QQTOYkamZ7uRYzZl1nlZY3LrPTIav2GwYO+9fh0WEiVTcunORwAhWyfD
 iZdb7qZTFvbAZ5oIS0wj85ZlQtwX4r1SVsUX3AYTao1ICRnufLRulAA
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 373EB20009
X-Stat-Signature: xj5gktpspuaks6i3owm5erchch53sewg
X-Rspam-User: 
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793387518-800094
X-HE-Meta: U2FsdGVkX1/s9uRXyHL4JQAUdZa1UnXK1xvCK4CD9vr5r3guijS/N+LHoenY0AspnoqcVMFlG39C5IKYyO2FF5TraZQJvL1aosOHpCxemCUawbBaaTo6g5cu94R85oPtDfI3g1nYhaqUwfGVddvR1LI6DbgwsSttrZgjOPIZNyAsOW72OLoB3AcxCJw/RT8gh1NIseSOVJRTN/uFZzttpu0i23l6vRdDTgWAUh245ooGgi+EmZJTjMNSWU6wUFrqghS8EYWVuuWUoBgE59NwBPm16uAQGwLaVji1gKV/WDExjdgSrzNqn4xrJTtks1RYDiXV29Lq1T//z6f7CH3nYr0L4LXYvuoCypd9ttF85ACzwcWadhTmrLYHNBeO9msowNbZCeO6uFreQ/BmJ26zci7RHUqdFez2Efh/6fZ0pN3oEzNHrRAFYHGDlYzBs7qgbAnKWQGvW7eIAsCUW5IQE8kqnjT8BlL56OE0t4g3I2qMFSv8dV+2Y/iZX5T/JbTaVSo/ua79keHNDmcrjgWn/yzcL/ugUTv/3soeP6TTM5fwdczImtYZUHT/zI4BbQNvaotGYr40JNhKw0Vp/0pMqj8U/pkHANIvXqo9lFlEzeWmAmfJBDMGH/4PmGQDyi5aKc7eVkew+2vmc5tB5HXiw+ssNDIE6xFjlytrQteGyUlLT2Jdof5h7Enj0uM1rRsooYWFdCAqAcUrhDrcn9vIU7svUo4Il+eXMxii5CV6Qzk6+Z/Gm9Ca2ilcOde6fnb3XKY3dylI+w8U/6jT1dJZ/aH/lgR1KEIkcOOwIloLsCVlr7Sod+3vyHD6v858djKvaVwZcJNCgK/UqAl51ykwwWK1bt43wYtHgl9cW/hGACsEYq3aXkN0tzuAfWZGXOoJ9fPV6xm2kBPi9CaZAMDMCsc27hK2ASr381ioHItBOcOORE9+/dsEBbnIMOEMO0FnEf8QHb/EPVeaEGZFF0i
 FXCpRZn9
 Cqrj30Qu8hu9NFrjN8VY6oFc8j1gjZYfkFn2psuWOee24d8VguipkLatv2mgEVOcfK+7431YRWqgmWd9/s4ZbO5SVIG60tPdYV6w+vvwT8zuppmAwl/obeGIVN96a0nbJMLUjrJlXRa5Q5oZsD8ludTylpwn8i3RnwEsxWDCK78pi1xjDT+SoDwrs2hxeZhtfsDYjsoHrW2M8RN/NcjB8WGvcx4odNjIirpq2TTJjbscfKJMnXmcD33LretusXrxEoabwAL+ToWjLw9BG//Je58LFdDtTXLKCCuDf90XCUyEMXwStUdhJXonD7m++3gGb5CFdERx+KoMHL+4725FgyYHNIKbMrxBX7Dxp3WIoCa6mIgCkiHqYR293Dogup3qOvFhANTIv3Iru/n40T5BTJsgpTvJiZ5gpFTOayzqkPgvrNMtDUwEaOYYxmDKn42xhI2gQ708XAtizLfSdxjCb91M5sbaW1lh+ZyaLq4y/EkGl/ZqD89/lCfrE2v4oUINYB882NZZUOz/plnOS40kCNekiVeyIYAnytylqKorWK751NHqZwbahzPlfEbTcozowkHNm/ugHq76knksD1Jg0IijjUlEjy4KYJLhFQG4wiq6gGyZc7fTD11Ibyx9qBt1+8AKQPfMEbap/sFM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mani Tofigh <mt4022@columbia.edu>

Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
for SWP_SYNCHRONOUS_IO"), a fault can read a swapped-out mTHP range into
one large folio in the swap cache.  The folio only becomes anon once
do_swap_page() maps all of it, so if the faulting PTE changes in the
meantime the folio stays in the swap cache while not being mapped or
anon:

  Task A (fault)                       Task B
  do_swap_page()
    /* swaps in large folio F */
                                       madvise(MADV_DONTNEED)
                                         /* zaps the faulting PTE */
    /* PTE changed (F not mapped) */

swapoff then maps it, which marks all of its pages as mapped and
exclusive, and the next fault on one of the other PTEs crashes in
do_swap_page():

  [    6.424485] kernel BUG at mm/memory.c:5195!
  [    6.424503] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  [    6.427654] CPU: 0 UID: 0 PID: 67 Comm: swapmthp Tainted: G        W            7.3.0-17087-gd865f2677c44 #1 PREEMPT
  [    6.432665] RIP: 0010:do_swap_page+0x24eb/0x2fa0
  [    6.451035] Call Trace:
  [    6.451567]  <TASK>
  [    6.453841]  __handle_mm_fault+0x13b5/0x3b40
  [    6.458525]  handle_mm_fault+0x16f/0x480
  [    6.461143]  do_user_addr_fault+0x312/0xa30
  [    6.462044]  exc_page_fault+0x66/0xc0
  [    6.462846]  asm_exc_page_fault+0x26/0x30
  [    6.476708]  </TASK>

do_swap_page() already drops such a folio from the swap cache when it
can't map all of it.  Do the same in unuse_pte() so that swapoff swaps
the entries in again.  With the fix, nothing is reported.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it within a second.

Fixes: f1879e8a0c60 ("mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
This conflicts in context with patch 41/47 of David's v2 series [1],
which changes the line right below in unuse_pte() for KSM folios.  I
can rebase on top of it once it's applied if needed.

[1] https://lore.kernel.org/all/20261029-fixes_core-v2-41-a64ce7f83abb@kernel.org/

Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/swapmthp.c
---
 mm/swapfile.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 189f04d8838f..b0b75ff16835 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2518,6 +2518,18 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 	if (!folio_matches_swap_entry(folio, entry))
 		return 0;
 
+	/*
+	 * A large folio that is not anon yet was swapped in by a page fault
+	 * that did not map it (yet). It can only be mapped as a whole, by
+	 * do_swap_page(). Drop it from the swap cache and swap in small
+	 * folios instead.
+	 */
+	if (unlikely(folio_test_large(folio) && !folio_test_anon(folio))) {
+		if (!WARN_ON_ONCE(folio_test_dirty(folio)))
+			swap_cache_del_folio(folio);
+		return 0;
+	}
+
 	swapcache = folio;
 	folio = ksm_might_need_to_copy(folio, vma, addr);
 	if (unlikely(!folio))

---
base-commit: 5e6c45aaaf93343c7f8a1cde9797080238af5c1b
change-id: 20261030-swapin-large-unmapped-6c8f6e691864

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>



