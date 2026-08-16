Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2FFAC5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 11:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39906B0809; Sun, 16 Aug 2026 07:00:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EAC56B080B; Sun, 16 Aug 2026 07:00:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8C96B080C; Sun, 16 Aug 2026 07:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 667366B0809
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 07:00:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6FED2804EC
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:00:00 +0000 (UTC)
X-FDA: 85106837760.15.D745FBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C8A5140006
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 10:59:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BxkOfn6V;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786877998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zXvRlHUb1dGVaacwG9Y/iGMhzo5Pl/L8wZbO2uLtAc=;
	b=giUwgkYqZi5QjH23sMCK9HvtayTTsS5dsqUt+fckLlUVikeNM2jxB7jjrgpaOwb8FQVd5F
	dDMwN+DNYk1xI6by+1b5IjSRH6/+yiMTdLwyauI2gs7etD8c5oXZP5Juo6spu4+94FZY4Y
	b8otnIPpHWysDw1dnDc+jhCx1MapgEk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BxkOfn6V;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786877998;
	b=Ks0zPi6BpILyMGUmbfwBOVO0HagcHxP/poZ9TuKg9YkdBbcQAvImK0S0oGxQhkUAqfl49O
	FyYXFCbzK54CQrXT/VZTBBGaKO58YjldaFj+y7gx6nivwLoIn5bszdTQTC/GbbFGKwGb1h
	hruX+FnjWgtN7OhHZU3tgjr6UO6g5wc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D59860055;
	Sun, 16 Aug 2026 10:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C301F000E9;
	Sun, 16 Aug 2026 10:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786877998;
	bh=0zXvRlHUb1dGVaacwG9Y/iGMhzo5Pl/L8wZbO2uLtAc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BxkOfn6VXnfpjzEv/q4Dlg5AnuN8R3AjObhLqH0Nhb8Qm+HMlKpfhw7MlM7pUcjpx
	 j094iQDlHr8uFSOixHJALZDscK3HM5dSJjMTUZJSzGsE08HWLOUuOiScutS8UdHYdx
	 jTRJq/AyQbxDXEqaKgGOqCLlryQeICddB3wgdUNgRhhhw5CfvMk9L+Ot1f/ozzREIb
	 pduODEEIbS3L4UslReNxhI00hG/eu7x1ASfbqfi1c6Z+g+iXDQzIKXWBBFNaoU/pxl
	 5cmOMyKyPQBHzXHaWoFhw7byGMNzbh2WO3UiuFJSgyZSqt30xw1gIJC5WER1i8Dt3B
	 Mh8FSD60GW7qg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 16 Aug 2026 13:59:25 +0300
Subject: [PATCH 2/6] mm/vmalloc: set area's page_order after allocation
 succeeds
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260816-execmem-set-vm-perms-v0-2-v1-2-90944a3ad43f@kernel.org>
References: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org>
In-Reply-To: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>, 
 Will Deacon <will@kernel.org>, x86@kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 loongarch@lists.linux.dev
X-Mailer: b4 0.17-dev
X-Stat-Signature: kf8ueoj3j3kbstqnzsgwbgttnet4zkui
X-Rspamd-Queue-Id: C8A5140006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786877998-489008
X-HE-Meta: U2FsdGVkX1/2ZRZg6jKGQAsjdfGX0GrtCl9NzK+Vwo44GVGa+JOJhkFti83Xkg/Szf2+qpybpZB951ptjI3vtfwbJO3SVOKQ5i+b276QxJZpI400+ObYvGp3ifpv7SZ1CE4mp870twWMT0vVuWR/MOx8VRaYTN8Bab9gztj57c5g5XaMCYtLZV72xWQJewcSB4zpgiPAngYINTC+lqkEDELli/XRztSwKm7dkOBBOfPR+m8bHkKcRCAXz/7G7x0S9/P/jMvicvRfC0sBDUTmir4CX+ZIZMSk91Vi0I5P8fco2pCQ+B34ZwYZcTt2C0ygn7zbWdPybX4a9uyRy0Lu8PC1gMcMhcpOVEIEBGgeWbbpAcb76VAB12xmDldjehzZWFZeobswETjpdiwivDchPv4P3AaDAsFZGW9kjcmOiTVDxYoD0o1A82Cyvf2rtxMu01oRVhnIt3QvYw+63Kw70MLE5tpZXuyjAhL675panev9T8wVMLpIr8HSFieuVF8Bpokg0N4Bpq2QA83cjy4np7ko1RvHewPngYo4Q86HXQkUtwzyA1+w2XYm0b+0wn1meSIeZqPCtqSQAFfSkHhHZEceWYPuExcMUPorqvaKVL4oMxUiEyjRZnrLoHMZfgNO9D8SLqttoxTj2v3oAZZvbQH0F2Bqe5C8gs8rzHOI6pordVc9keBDpAvnxRgzsGOfV8+tE1eG3hrfIfq/fhRsJ/Y0qhmJPHxaDgXKFu9gITvRLMSoYkcxnwZOn+t9BBiC28cEzZwHUT5khe3H5/Z7rBLOpTmyJzr5SMQWSJ3Z2r1DBiF4RdeaLk9Z/5X0DFm5I4+uDxqhu4Y6EmqfuUvfTHZ/pQtiFA9q2XgZ963crev+oCKEhu3FmlEDbTVJaft3ni1Ue8p8Zwf20sNgN3GITNCh0uELmxcYxVBskTKDUbhAOSS6IVedjlwI7NHSQPf1ljE23u4QmoS+WWjkk5G
 zIXXZPxh
 bzwX9OsRjXdGx1zwNtYc8JhLUYugcSM6JKM+87JtYtsTlpSQTY6haqXObp5ar1IVUiZl+2y/SBboYCqapZXwd/5VgAAayk2a7BkIv9kLjNStAyY4fOQixPdPYjytFiUfQHhne08ARfMrTgIw8YvTLVpjy4YHG7YzfdgkPQBFKP1P5IsyH2L8fLdnA4vbiIZbC/Hb7A0eICDj0ojrhedV3B0IMBCMLffoJbN3dXqsT/qFH0nlHCX4xfrbDMHDhJNgiHRvOcD4EBPFeV06EWuH1VpEIZ481PFEvd6RJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__vmalloc_area_node() calls set_vm_area_page_order() to set area's
page_order before actually allocating pages to populate the area.

If allocation of large pages in HUGE_VMAP case fails midway, this leaves
the area with elevated page_order throughout the cleanup path.

There is no actual issue with this because the only place that currently
relies on area->page_order on the cleanup path is the loop calculating
the direct map alias range in vm_reset_perms() and it anyway skips
unpopulated pages.

But having set_vm_area_page_order() in the middle of __vmalloc_area_node()
makes things very obscure, hard to reason about and error prone against
future changes of the cleanup path.

Move the call to set_vm_area_page_order() after __vmalloc_area_node()
succeeded where page order is guaranteed.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/vmalloc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 22566e0b6e38..6822f0fe9583 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3901,8 +3901,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		goto fail;
 	}
 
-	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
-	page_order = vm_area_page_order(area);
+	page_order = page_shift - PAGE_SHIFT;
 
 	/*
 	 * High-order nofail allocations are really expensive and
@@ -4106,6 +4105,14 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 	if (!ret)
 		goto fail;
 
+	/*
+	 * Set area->page_order once it's known exactly that the order of the
+	 * pages the area contains.
+	 * Even if we succeeded to partially populate the area with large pages,
+	 * still treat the area as populated with order-0 pages.
+	 */
+	set_vm_area_page_order(area, shift - PAGE_SHIFT);
+
 	/*
 	 * Mark the pages as accessible, now that they are mapped.
 	 * The condition for setting KASAN_VMALLOC_INIT should complement the

-- 
2.53.0


