Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC73FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25CF26B00AB; Tue, 30 Jun 2026 06:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E78F6B00BF; Tue, 30 Jun 2026 06:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AD9C6B00C1; Tue, 30 Jun 2026 06:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB7536B00AB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:54:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 44CA5140452
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:54:36 +0000 (UTC)
X-FDA: 84936270552.10.2FFE321
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 86C3940007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:54:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kIXozC/6";
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816874;
	b=c49Vi6btCJhXSBWTUXWflfFur78d5anXOUATdLlYteoBAHQYbAh+YYoet+zXIwkPkLcU7d
	jl+wSnrRpaXTIiKHHZvCxiDzGxg1zfdFwSaYmzlNf2CifJgtixQsrG7CKDA28+oywxUrfi
	yHlMgX1JbZtyj1ic2xfqwZuF+bTnueQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4zrAKFV36+my9sEQud+nD9Mpl7nfKTgVOKBUepgezI=;
	b=Ys0+O91gp2uOfXD/TApnmnDG2jlYp/SvdhhdRYu1fCtZfcAEgaAAul5/wWn6Gbsboy/9Qz
	kWL2PFJ1X+XROQY1J7m3G+E5VrZtgh0REFMzBRWrwkHUsY9TRHk8yW0sifSbCxcklatgAA
	4BRozcS9vF+nXfUreFE1zeNupSWKGH8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kIXozC/6";
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D59B04043C;
	Tue, 30 Jun 2026 10:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02C11F000E9;
	Tue, 30 Jun 2026 10:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816873;
	bh=o4zrAKFV36+my9sEQud+nD9Mpl7nfKTgVOKBUepgezI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kIXozC/6GRZNoThE7wVrh+Th54Zlbfibcc5IpHidsZAcdx7VFXo3pEpijZTNqJJL8
	 HAhXH+MpFe2aWX2fs3Mge3pm2kiSI6dFCqrZoMw+XtUUfI37m1TXWiOEnt5IRtmY/A
	 Bd/VEHNDnpWqP9c6Xv/NbkbxXROjlqdEY3kv402EamAMjLngoZkbypvmzYrid801B0
	 EII5nPXACbGjLE5yEoQY9s8e5HVZNNUU94tEnD+M6yBoZ7qdf/nH5rMadn4DbQhCF4
	 M63R5M04lGhRaCDs/mYyHSAmzzOOqyxif1n63zUmKYFZiXJ9/eQ5Xf+I7pmCLPw3jW
	 quPIeT1kCcHTw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:54:21 +0300
Subject: [PATCH 4/4] scsi: sym53c8xx_2: replace __get_free_pages() with
 kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-scsi-v1-4-494fb37ebe7b@kernel.org>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
In-Reply-To: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 86C3940007
X-Stat-Signature: kmxmsimaqfqajreq3cuzcnpwrxr8twtm
X-HE-Tag: 1782816874-801083
X-HE-Meta: U2FsdGVkX19RCeNyrVargwOxGNPcRJEjW+r2K0g49yEx9tpN8xra9FWv972EQJ8Iqj/YY13yohhXeSfmmeuhDyBTsDDhJvSB4848p1gIGjvc+FtHEmcFkdz13T+AvZNO+mP8tWwSPkCubqiPpINLXlauiBPawuYG0E0Fvf3Oy0p7BWU6woxvguvEOhvFvpODyOaSgCIbAct2ZOLgZ79MKwfyM6yXHJF7vBOVZJqRcIqMYOZSUDpuRdL0SBaXJkEEsm+JqHeO1OrKeBIHL1GoAO3CsmZnDlgRQ4bdoIvwas/Zekcyz62UKGFxVRQhVytfc5q5z8tqW58GVWH487vrJjM0RhFTZWVSgTLGLJdXh34scjhJSt6N6SRp5fbEZMW1EJKjVc0uxm17Rw/vXrLMk6GzcRSEuKed0rHt6ZtuWyTV7wd77GWPYbsldjlCtyldLuF70JPAESHwcZy/4XETYb7ioegnkMUf3t0/XRNEs9iSB0RjjRLySXVSVIJSgWjEZBxAus4/d5bR1FPr7RmiUdForj5i//QCg8fzPVjwObTEJSJ4ubtlX2AzklyGgQF7azBc2XjEjfzR3VZu0F4i/7TeIBZ/MYRyWHHECouf9jxu3VyDWcBAyI8MUCe6gUkWUfvQ7ua++aoY6C50q5Hiq031Oh3NB7oHts9VdImkvKjPMhxgDrue14HqJAlIrviSMb4+lm5u0dImPgXRwLb+S1OqxGMse7lj6dE46cJ9+ksU5ocwH7CzJQQA94Gm5NfBtqTyPVFETX7u6T/x2on1jNMMWR0uar3MDN0xLjplRoMkpcHT2n84S8w0NJIImLBn0Ua5dU5nYreXs21wfDwNxALr+mAuwVLvRiB9y9PHeIvYr9hYUfNEZYjLfgRDsvuThsZqaTyrmdbrHJNd5n9zryR8eUfW+9cuZBUCth2aRcPBlp73SuTGHzSJD4kOgxBvzBrcq78wUxZquHkKiqN
 LfulmMEz
 9NxNZyefl3TxwFsdCiTshx+hsQs7O7G/mJoySopskNUnOr/R5fHimODYq7uV/+sN+th7E9tx6ItDd2mzRBGRQWEq7DerpP4ckAXhXC106EXVqY/RvhfXKUXTvvzjpfFA/rrRfIkUe78f+DSMn99eiq+Dv6VLpiE2GimxzeWBODaaqjnfqyItPm1X6zmSx1Xwxs6uiJLawVtBAhAB5NeOHMM7+d76yalQherC9U1QCG49uPjsgQxBLa5udU50lx/I4J/sHdVE4CC9CLrjfijLvmUwbx6KvEjcetZhOKjwEO7k3UT0K3rw7rnkGGU65Dv/BFS3E
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


