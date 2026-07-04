Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D06EFC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 06:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F546B00BB; Sat,  4 Jul 2026 02:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC886B00BC; Sat,  4 Jul 2026 02:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38E36B00BD; Sat,  4 Jul 2026 02:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B82EF6B00BB
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 02:13:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E2521C5780
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 06:13:55 +0000 (UTC)
X-FDA: 84950078430.12.864DFBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9F3C2C0009
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 06:13:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jmk2gMFL;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783145633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ChsJbQD+rYLxKREcHCGErBZhvfE4abQxVMv0tWl2ri4=;
	b=YmrZmNQt7TNXqG1Xe3CaMBEt27cMZaCxYDv8rQ8RK3JuDkKQMdiV8Wa1GQuCFpXEr9YIAQ
	xuNdFuRg8Yr4eDjkCN3t2qCfQT3W5693Dy8Nm7LryHjGi1XbSMcblwqlB8/tH3R7uOyCkf
	1A43ZbOYC28zE7t5g+TVvh2JbIPDSQE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jmk2gMFL;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783145633;
	b=sDRkIC0S2FzcRn4NUI2kZZ3qcJ8InNrGh2gvwwSztsJr7SfAzgFnZ5YkgfVagzjG+7pa6M
	EGDJWt7kQjjdlr/In64cpXlZLbjk/931n5ADGv1JggumiqsNeCPansWvtKUxvzRYUkIJKP
	ALQfj5yrHz5R040WJD9c7xQFGYFbBZU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4659360122;
	Sat,  4 Jul 2026 06:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C40E1F000E9;
	Sat,  4 Jul 2026 06:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783145633;
	bh=ChsJbQD+rYLxKREcHCGErBZhvfE4abQxVMv0tWl2ri4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jmk2gMFLrK3eU2lLP0K0XOJ1Pm0Uzkc7RJEuAmXhOwd75+F/e2QiRDrlyllwdNK7+
	 b7wQ+uYlfHvWU0PmUHehslmgcJxmnK3217gkV1Xl9Y+JTBcBPOQN687QayTgxlZBXJ
	 /5ewIJhudgeSA0G5uY3yPFK2holTLgZaFvSjEANSl+0Ox1T4WJHp3oMK6Dn9kDP3/I
	 nVVVNdy5wti/f00rRlEtOaGzXqfUSayxeZUlhmTy5eu1IiZ8sD+71yo54zPfQHeKwC
	 +Dwl/S7zgOdKLTh4ttH8FEgQu47KXFvAsqX8h0GvVXTZpNddSk1yMzGN2sLJMnAFPY
	 YKGxAnmygkPlA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 04 Jul 2026 09:13:37 +0300
Subject: [PATCH v2 4/4] scsi: sym53c8xx_2: replace __get_free_pages() with
 kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260704-b4-scsi-v2-4-7d2d21a810de@kernel.org>
References: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
In-Reply-To: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, Hannes Reinecke <hare@suse.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 Wen Xiong <wenxiong@linux.ibm.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9F3C2C0009
X-Stat-Signature: jmh6xjqprurn8ise61eii5uhdmcqwcpj
X-HE-Tag: 1783145633-905255
X-HE-Meta: U2FsdGVkX18+04kkVOhBQaI1zavI0zjJxhW0L8Uw5cdx0g14dXawtL76QjJHQk8p8nXfK7M74/GnJLFYl0MweAddalMkjUg1yBTji+oHBnerAlvkHhjGkBr58yFMQ9NiL5ekl+BbWyXUK0J89U1MUp4fa+LIT3vbNq6TPNtRAXGWY3GxzV4mjZmXyaEW9pD7RHqo98LDn0FMU3G6oWfjpHwfpe7zAPcxWNtwJHdmFqKVbWEvvDUAKnnM2mYwuQ4LQzZD1NIo+DDC9SPXJCnLv7v7AYzdHopKa+6n4pJL/qIZ1b9T/aroHnCPk4odQjZGId832zuAehkp+g89H3CNl1u/qaXn0Cx6Q6yFecDE1bQJnccd9DLs6mP1Xwvl3J8RveLRuKWHUleYevf+vaOJzpY1+TdcESa2aDNb4y6TBoLFiII2fog2zTPM3W2Ob6UhDAWQCGAbsJSn3+jos2Wwi1yCdU3EjUMSWIyWP/iD3GtsnSxrO9iQd2vdtKRfXgYBUBRvAk3xO1+zK71H29QAQMXUIjGnwtT5ho0FkuFxQy/uX2+raP8LWaGZ1pK0YumRhMgnS0Cmyd9szUduIT8EEey7GPYZteqYqX0Cs1KBOLi7V2yhZsSlCZEHANJ+Hyqgm42F2+Dc0snesZBtN+lN3DHMtgR7n14knbrik/oJeXS8ffkmD0OBMGFRTsL1zSps8kvnJ90lcUPWubSZ0zxl6bFoT2kHpy8e+lU0a/zHyaJPlxZU8FgNBg1MGF/tNjlv/NJU1ELUUF/MDY7G8bpqTfMnsTbZUO/iraKRT+rCF2JccYRWG4A92UDM6QMB4ApH01Kt5Fum2HGMC7fIHtyqbavmoz/Bu3Xw22xolUI3aV730dLf0P82dq1kFmOXW+Fq5k7M2UKcmSBfb+9j5fiSjYxzXBDFR6zJB/XLi12rHWLxVLQPAzVseJQ0OBD1NApSU68kNFxVMgtrJbrqvlG
 b4im1CQd
 52h1GIp9hQUurOROiuTyArYIztMjZLLCj8DMAq237DJChsbeWruZbgyrJEdxrxA9Dg9yMZtb+QQ2Y/nDWeW7j/76ltAE6XXFBHAroj1q2kjX6U93rJHfxNwuC4aMOLreyJJdyaIwZrTpIoKb3VgqbH8ZfeJXxhA5txEMGgQPAPj5KAdrLdQbUfT+wHTepOP5lHvY4UnqKJgyF59V9qW15mrBkCiNp7wUNNVJfoKNbA3NVanZBhMRyeNMyCVb3+DSD9m3YO/cpJdc+2qDAnFjmUlu1TU4l1PXN0yGIG7PAOt+AwVDdkGiwwSVPd2fZyJ0W6Ek404hFfUVTXlQTXJRDZ/fFy2ktNer3Cg1fXXXrdteeqsd45Hj+LPg5BdsVPnujDCFryBk1YCVCmec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sym53c8xx_2 driver has an internal memory allocator for small
allocations of the driver structures. The backing memory for that
allocator is allocated with __get_free_pages().

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_pages() with kmalloc() and free_pages() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/scsi/sym53c8xx_2/sym_hipd.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 9231a2899064..aa365e8ba66f 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -1110,9 +1110,9 @@ sym_build_sge(struct sym_hcb *np, struct sym_tblmove *data, u64 badd, int len)
  */
 
 #define sym_get_mem_cluster()	\
-	(void *) __get_free_pages(GFP_ATOMIC, SYM_MEM_PAGE_ORDER)
+	kmalloc(PAGE_SIZE << SYM_MEM_PAGE_ORDER, GFP_ATOMIC)
 #define sym_free_mem_cluster(p)	\
-	free_pages((unsigned long)p, SYM_MEM_PAGE_ORDER)
+	kfree(p)
 
 /*
  *  Link between free memory chunks of a given size.

-- 
2.53.0


