Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F586F5A8A1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 16:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A0BB6B008A; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E4A6B0095; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336F66B008A; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1386C6B008C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BDD4C1B903E
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:57:22 +0000 (UTC)
X-FDA: 84679539924.25.35D8E56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A33EB180004
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:57:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=femgGUzc;
	spf=pass (imf16.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776704240;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B4DOKatcyjn86/8Bn4PMGM7XW/uc3v9aEWaOwGS38+o=;
	b=A31B2vRaBcj1i6t8Hk+XkdCCLub9aANynce3dmnzsgt+gZjxEHzNzVIdHj33BB014hw/RS
	ZWVbAgtnQt7+mJICbaeEP+/eOPRPzmJyp6BumlDDPZAhq3BpghE1lLvstQ0QvgHWKWOW2i
	CglAEPKL0d0z9ZsvNG8xfnlrYxTwtMk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776704240; a=rsa-sha256;
	cv=none;
	b=QrJMyJUb9Ja6QOoXMjF84rCy7E01NpZLPDwz+tifB4byHsx2K243RtpjHxnEgS0NuQ6a22
	rYUrKAw2Dob2T+CcisW9ihxCqTtP+kH/wqc5o94d3almGjgSFgRseYss7ICD+sZUziQ6yl
	jmtiwGpEIWhQ6YiEX5+6LYR/5WN9uCo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=femgGUzc;
	spf=pass (imf16.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E7674456D;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B359C2BCB7;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776704239;
	bh=SJ30GWFN4+KJwvu2SkHYFnnx3JTg7f9fYWex6LSkOx4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=femgGUzczKAiiwbYxS9FVIO7GW5QhRIlkPhQAkkJ4YN+7mDD+ujmDiT04eK+Z8/EG
	 IsBoyqHJbGkz1z5Up5A/wkrzD0BYdXysRcnoM/xrSQr8L+FX+nEVKlzQcttosL5dgv
	 XcsPUhpJ4mkyxW4xYBrYDDFZk93SNoViuJ/4wN8Gg2COfw/WYkjD6y6PEa+Su7R73y
	 Wh3GOSW1x2cPZcrzs1SYkC+nE8EKHKAVHJnCmPq8oTBgiUTBevPFVYzGjPLJsnH6Zy
	 g+4NqF3vzedUEDqZZ76TwNW4nDyOiW/GDkpPpN8DYcyHHa7kJON1MHWB63DlIa0lQ2
	 Nt+6JGce5Kyzw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6204CF5A8A1;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Mon, 20 Apr 2026 22:27:11 +0530
Subject: [PATCH v11 3/5] mm/vmalloc: use physical page count in
 vread_iter()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260420-vmalloc-shrink-v11-3-cad80b00853a@zohomail.in>
References: <20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in>
In-Reply-To: <20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776704237; l=1268;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=NPDgNUyDHjfdan34PgKxqmgFCh6tKET1umIY26Q4uaY=;
 b=KgkDPSioYeTnR140puLbvW28CSF6EqahesvZ6SQGiBF6Fu8mF7wN2cgAz+0/jc0mU4nxKNkwC
 YXypTICZ8sRA8Ueh9Qfo4aEwsOSPW1rrc3NsflepG5rQ/o1cpF7KwUO
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Stat-Signature: xjjdopkuwzccyfatz9ozyksa6x7aopt7
X-Rspam-User: 
X-Rspamd-Queue-Id: A33EB180004
X-Rspamd-Server: rspam05
X-HE-Tag: 1776704240-329471
X-HE-Meta: U2FsdGVkX19Mp1tHSkIDPR9Es1joX/S6q+U0qqUaZwMX3DmhSimvf34viPwQPSxi/zfKejJhLkhViIrxgmkWiwlj9AOLsw6ZgkQ/oL4e8+aIqKmrqywOLwdp4KA/0/1unRSUVizAq24Rzw2WEEBuEPbPNlC37RSHH3cc9R003pI8SIqKrmpj1RS3D9fyrzdvOpnmdJ0Ej+DUjYRgvn+vF8kJqtCnqwcUkfjo82MFdMNjnKY9+KpdLMQBlR4o6z5xWQrq307mB6yCnDC7/rnyfCSDOnUWqGenohBCenALpb1JqUWyzWR++DcbQr8IrW/ImrjjBK327TC5A6Mv2tKnDmhPqtarGosw+2sUZKoY5F27OWsxJSoJ4xq7XjkOCiF0BwS7adlOdYos2w7C9CCzYVugp7ZUelhKLEXMwtYBLqVrTAZE4lnHrmvrFvo26FOQIc+ZT/rwEoLYWjOhixxYw1xLNdG6WQ0XALfoMdBfBbzaknj+gfd5rmxfnzra/prN/dh6/NyWpmtYYw78UGNC5M/W5nuILyhmzoVKxWC6RnO+PE7l4C/9gMgAz6SrIUN0uAgmQl6hw9mqORmNv0vreNJFudEYI1npL/dauY3UQypbhv30n+cgEPOkOlUWiF9KEMnVXmj0FV+yXYDxJ1N0M6jgZYZzSOM6+oQW+ZnB7C9gPSVBF6pvfEbNlKbZLs2h+AW4jEPjEURgoCqGJGLw+DYDFh3yctnS9NRVpmY3w0/l0R/z0t9+2Rx1dfoYx5KHwc7gVdMbohpjqoS+MuZnvI5PivUQjb7FKAr5VfHlbCZCEqVc0zRgBzQmVr0cPaxhwBIimsfqUCf9+dflEldJHhljXaIeQTvfiX/3A4llGpjbdrZ6Y+WJes3W1dGSa2tof431EoW0cDTh1bg+Ap381Jg6dTz9byd5/XfVay9hCy5EzU8Zyl/TU6JCEmYsIWXdPAqQ8WPXH3b+YqE0t6b
 0I/ICxL0
 PE3mmXMEXyV+oMxT9ypY4wOZoUpualBNaD9bHsYJM9Kw4g11ydj6ycdyRLrJ88V+/ft/P/bzD424L819cBFoA5z91Y8RFJdJOwJFz3fvPtz98XCn+lXFHDCleZ3DAkd3VJ+fnMAIq93PaaF7CP+w57KzFL56l6BYjxqMo3GCT1LDO9fNHn/boWqkzfjRUWWz/8XoF5C40sM3Pyccb0QlVW08lkjWbgQGugJLncg3zk39oukdFOTx/u2Z1YAMi5LJRYYVX0UNJKT3lptMEqUPOJPkPeO4VU+4FGeKQT6WfLHuNuecg7uWcsNFaHv6xfwP/FXJfdjE1IYM6sZuui61M9FE7kcBoJYuhvn3JZGBKIeWY5Rr4t3gQXxdOshdtifxWheiyDWS1uQ6QrciXFhuLTBwc8y66izhLPBMYn3jIjUT2Mfnfb0oDxk2ErMbwJgnY3KvH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Update vread_iter() to derive the vm area size from vm->nr_pages rather
than get_vm_area_size().

Currently both values are equivalent, but the upcoming vrealloc() shrink
functionality will free pages without reducing the virtual reservation
size. After such a shrink, the old get_vm_area_size() based calculation
would overestimate the mapped range, causing vread_iter() to attempt
reading from unmapped addresses. Switch to vm->nr_pages now so the
reader remains correct once shrink support is added.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 9e2a08c56322..4cae531ac0ee 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4666,7 +4666,14 @@ long vread_iter(struct iov_iter *iter, const char *addr, size_t count)
 		smp_rmb();
 
 		vaddr = (char *) va->va_start;
-		size = vm ? get_vm_area_size(vm) : va_size(va);
+		if (vm)
+			/*
+			 * Cannot use get_vm_area_size() because realloc()
+			 * may shrink the mapping and area->size may be outdated.
+			 */
+			size = vm->nr_pages << PAGE_SHIFT;
+		else
+			size = va_size(va);
 
 		if (addr >= vaddr + size)
 			goto next_va;

-- 
2.43.0



