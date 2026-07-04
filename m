Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 198A1C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 06:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD416B00BA; Sat,  4 Jul 2026 02:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E606D6B00BB; Sat,  4 Jul 2026 02:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75FB6B00BC; Sat,  4 Jul 2026 02:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1D7B6B00BA
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 02:13:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 233AD1C1E25
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 06:13:53 +0000 (UTC)
X-FDA: 84950078346.11.AF29409
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8A701A0003
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 06:13:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Clgh8Jsr;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783145630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emLjy5o6r8ZJF+EiAHY/zB3OczqvGQ9Eeeqy3Pf2Faw=;
	b=VMRrMidQupmo7GnZVrAETcwmwIllRcBEBnsO8CiC8Mozgfx3IDooK+xUeHHH+AANjRyst8
	o8PXl1zxz0yCsC9fL4GI1Pag+ZxPGEFYi7WX39gdb7X534V/lGPpf+T5Xn/bsAEHFJDa+B
	PubGfcitseT+zIZ7gi2RdcJTQ6oXGLI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Clgh8Jsr;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783145630;
	b=DJLJmvLEuAtXBoJgODJhhGvN7e++jmryXGuN48nrixKcqNjTxTk6QDwryamCdac72UcS/f
	Px+wbtg0QhVnDMOERgkaUR2RMkp4CD0AdUUHMfWs5rHWMdHHQ+v3XN5LPJ0qCgVJyeCVzg
	GfCLWPL7nSXYJYq6Vb20l4DlZshbQuc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 28CED600AF;
	Sat,  4 Jul 2026 06:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1251F00A3E;
	Sat,  4 Jul 2026 06:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783145629;
	bh=emLjy5o6r8ZJF+EiAHY/zB3OczqvGQ9Eeeqy3Pf2Faw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Clgh8JsrEBdQ/oKnX72d0RSb06OkNypaXXjAe3KGHnzii5UbuKYLr0SsoAneFYrgc
	 qkKvKO3F18YV1fu/fQPB6bXsgevm6whYsfxTTsSOkA4kjyuWvUBrUSifbZcNBWIQqr
	 sHy51Gje1SH2XwNdaEck2RaYjfPS6kdVPXxcmoyOaMknHbsC3FuHj7sILfI3r3oaMk
	 xvTOOSI7rnJ6j5YVJb1cCqPSs+fdIaMrqdfKrLgSH3JYKneob10MjxUZdrcNAeHAHK
	 gjAGZIhxn7ZIbsA/tevlL8B5k6rafA7tfV90Aj82lRzAPRdB2HVJqH6ZAE56Qdot20
	 nhtIBmqdJXLLw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 04 Jul 2026 09:13:36 +0300
Subject: [PATCH v2 3/4] scsi: ipr: use kmalloc() to allocate IPR dump
 buffer memory
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260704-b4-scsi-v2-3-7d2d21a810de@kernel.org>
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
X-Stat-Signature: ywn4bipryk3y3srhgmwwbga56ojcguwn
X-Rspamd-Queue-Id: 8A701A0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783145630-757024
X-HE-Meta: U2FsdGVkX19qEVvytT4Vcxu7bTA7ot1lg/VWQf0bL4iCzhQsAXCD5NHwo6tZ5VHM0rcqlLLgNTzlmtm2SEiXMy5CVDosfJI1JBiP28rsJlvEPlo4e8yoZQtf/Ytf6UK48MDd2GVd+/5N5OTrJ2c6bYydlpvRET2i+aJ7xyLdlaLcaowPsH+yQz9JrSB4q3aIHqDhVhutECG4O2ctKFaryTPX4vcJOSDBOaaruwgTH/mrkatSGjFwmMBIMkfQ1hhBStf4usyvcv1toQB1FQqX3taJvEaDVugMYW+VPSP1gaFavFdBxU93hNHa7K0xfKwiRwqJ8PEwz5hCH32ZQ8ll2IRqn9hmnCQh4F9sIt0CSi3+w8OKzIXonxC/BrsHcv+41+CKaS4+ZGtTHY/J9y7dC10Zg919HE4uRktVjyMM/ef5W7UUbsi6vMZHrGcuPYFiPjta4COU9XVOSUo9Gy6ekyFVGQInahYt2ztM8kSpXYd/mVp+kiA4fK5V3HyCJVi3tPcvEjwPHntQ1CQB6sjtgvPIzS9SaiTYpUJqIorLWVSwieEGKDSN0ZtGW9kqQFswpvADENS8oP5NltBdS25c7OaKiLGYbxMObagEiRXe3Br+JyKNxDb6SYJTAoHISz9z1e1CewEplvQR29TD31hzSF3tUKQjbRMyDg1rayZ5sThP6wKJop377oSd8hpNYKOZ+DFyLEKYYMXUxSFjhiAGLOLv07ONWb/kgp8Y+u7SRf7eGID+eVfBwA4jyZ8gud6faz+a9K4gm+WEFFE278Vy+xWWYauMdHbkyuqDsQWkFP8NkMhD8dYXfiFfHgrIGdYHONVaRuAz4xhK8XltDs1jQC6cCpfq0aDnJa6TJkKPGEpzmAhy5hP1+QjKKnjbf8hBzc9j+wa4k+Sdl8PcVDw1GS44yMDPhAfv80AGnklPRFsYbLYvs2ceEsoXEqg7YEo/vol8dOqweBwSfikSaMz
 nO8EZFwM
 Yp2D2UZ3fFpS77UEgXATngx/2/6/XDUQ8QjoyYCLzcYXdpRiCGR19Jpw87lWBGemSfoDLpDyq44WnR+7gpBTeb5iJmTVlF4K5+4rJgugwBnpeYoQcSt3SUGpMRYeHtv56HNkDrL6qiBKJQlgUhZ5g3e63O4u6k84CwvQjMg1dclcSg4zeblyhk8xS+55ZNNjwQZbsm7wXOX06svGaTAxrFRlpFnadQY5H2727lG6zrhvXaB04klfLasUkzf0P9romLLKnDjQz8HBB+FGGWkEeE4oJJRpvEgFtEGK100MvubNTsVyjJg+TyEz2ylmtUaCBimnlHdvjf25sl4bnrJcEd9p6JP+srrU6cidUIxzdjzfJ+loTkxIj+xnhbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

IPR dump machinery allocates memory to save adapter's crash dump using
__get_free_page().

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Replace use of __get_free_page() with kmalloc().

While on it, relax GFP_ATOMIC to GFP_NOIO for allocation of dump
buffers.
The allocations happen in a workqueue context, but with storage adapter
being in a state where it can't handle I/O.

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Tested-by: Wen Xiong <wenxiong@linux.ibm.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/scsi/ipr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d207e5e81afe..19153dd24736 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
 	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
 		if (ioa_dump->page_offset >= PAGE_SIZE ||
 		    ioa_dump->page_offset == 0) {
-			page = (__be32 *)__get_free_page(GFP_ATOMIC);
+			page = kmalloc(PAGE_SIZE, GFP_NOIO);
 
 			if (!page) {
 				ipr_trace;
@@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
 	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
-		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
+		kfree(dump->ioa_dump.ioa_data[i]);
 
 	vfree(dump->ioa_dump.ioa_data);
 	kfree(dump);

-- 
2.53.0


