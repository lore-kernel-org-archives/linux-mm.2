Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA0A3CD6E44
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69F806B00CE; Wed, 27 May 2026 10:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 677906B00D0; Wed, 27 May 2026 10:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518E76B00D1; Wed, 27 May 2026 10:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42B2F6B00CE
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:04:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1E7C1405BF
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:19 +0000 (UTC)
X-FDA: 84813369438.12.AB7E92C
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0BB874001A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NJ5MpcrG;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rv/V9Guf/VmqLyIW7ddquGjxWE57lh1X75zHlzPy+Ls=;
	b=76URrbfly2jVRWyXHQnX8LPod/o7ZxTSvmYWbYXV+fGOxhokY45oXOY8WM+kZG2ozl0fio
	nBYpBpt+uWhtwmAxdKeFCytu1v0PAhafxlTp22A4wCwp/OggmFc0o8OZpPVuJOwgT5kK6G
	xF7lJmeXmdYSO0dqZ4SGe4ysNk98FJ8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NJ5MpcrG;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890658; a=rsa-sha256;
	cv=none;
	b=eKFQ0h46fz5LrBf7FWfKEHwml+6ue1SUODTYdUbxO/tT7k824q3ov8Nd17ogPPWkIHLTnY
	AH0VAJxt91YCtNRvwDCJj6Vc9bYykjrC7uVnDDnF2+CzymT/xaIloYNpGIWkCiD2Wk4BJV
	U81+3eoQ1RkYTyDRl0TQmCurx8gtU4s=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5a8cb92f26aso12710856e87.1
        for <linux-mm@kvack.org>; Wed, 27 May 2026 07:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779890656; x=1780495456; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rv/V9Guf/VmqLyIW7ddquGjxWE57lh1X75zHlzPy+Ls=;
        b=NJ5MpcrGaa9JKCr69aU+fINQimdvMflDZ0R4R2/gajylYLuoTUM5rztU3xnSK8OB/f
         5ZZdHtBTabKleDDHWhyBxIqDTJtjxQfBjz1ODNLACiZDZXEisfFlE8G6AL9wnEupKlRo
         lOweWw/+ngPE0BuVztnGACzF/N2xA+PIH1yaezAFe26mbG0rf92RmQoVaSuVQTjnvq3C
         rJqEO4/Qe7QZ+hFrbOzoSOfQrOFnyRpqBXeXNxbwc41l4q4WHw5NCNCcnDPzHh1L/Xr8
         06u8vxX2RIDM1RtD9qleHCrtpOP7v7NLNsERKH0puhKqqlZrQOiToJJEc9Wkduji+azI
         77lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779890656; x=1780495456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rv/V9Guf/VmqLyIW7ddquGjxWE57lh1X75zHlzPy+Ls=;
        b=psvI1iM1wlk3reDFo0fz2YHQ/fuW/soIb9HVNHLOZfRMrZUD4J+/0gswf1uaY4aFEj
         0C4ACRl1xO8SqnQduf3ZkP0V290teGpXF78eAHJJKftUcWRs/s+LzCk9+ElzvTGpHwOs
         +0rrGTT0E9CjHyUp767+pybDRgCUCoz1gxIxy80V+DA1ONXB6bi5XeO51SoNsSInysYs
         M396oxpn+9lVYkTt5tdYbK9R51evMCSFkQITE+AVJmfHWZTMXpS2sen2/4w660qVJ4Sw
         7HrlTT8AeJwrOhe+ud2cmuHwE1Po/+XHS6irAeI+L+6Mu8H885fuzgMPuN+pIkbw676t
         acTg==
X-Forwarded-Encrypted: i=1; AFNElJ/4F7GAmaUlOPLcrQh1+zBEZ5KVx5o6f+L8K3aKDAcjKzyl12V2JOvyBLy89nsIiaTsRKckYtECKg==@kvack.org
X-Gm-Message-State: AOJu0YzkQKQnjV/A16nm+vbU2va3fdYBf11uk00+J7qt0C00weenKrbc
	QYlTpjxpTw5pxpF96+7pYe5IrcXDj555AcFIlNG0a93Q+uLnW4He8WeP
X-Gm-Gg: Acq92OHIqsvho5C16fzE3anLkF5EFZ9xrpflAkrSdhOYP74W50yiOfoxy25VR6+lN/d
	3vnjvJdP768By0sSQ5T1gR7PAVON3HQWEyOJZx2ndc9FGJSMb0uHcdf6rGi/bTn6phIpBGD9U99
	d6tc5NikrUwZKAF+8S6is3K+eE9dCtEesDsE22FUpFNu+og+dJE9Q+3CZ/vw5X/7U9jdwg9FZ1G
	ozIbTDBTbsVJeAq7mz51vhZXAUE+ygBjYSKNdhAEIv9UCOstR7btmTU+BKA7BnybWKS2tVXzMtG
	sEInCSQvSnIOw+zR3IoBiXkcbX5gUj0iHn39qbrxpSyPSz2x1rUchH+YBpeng1Jn8ENxHWwRcMf
	zlb42ifFsF8h2QiaPnEg+Q5nDX+9vJoRUzcW9aYcY9KjjddDMOJ2EDVA8TMghN5XUnqHgsb2nGV
	bYT20f1G4peXnGOs9XZ0khn+IeODoGiS7k3th/ABL1KoYUr1e7U0lN+N0mFSlJFRLeyXrGnV+cC
	kNdPWEN2clgyhjiq8Kc+8fYRn7hMtr0/Q==
X-Received: by 2002:a05:6512:1287:b0:5a8:5ca8:7f72 with SMTP id 2adb3069b0e04-5aa3238b947mr7339783e87.4.1779890655762;
        Wed, 27 May 2026 07:04:15 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-45edb558f52sm6693771f8f.14.2026.05.27.07.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 07:04:15 -0700 (PDT)
From: Vishal Moola <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	xen-devel@lists.xenproject.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Vishal Moola <vishal.moola@gmail.com>
Subject: [PATCH 4/9] x86/mm: Convert arch_sync_kernel_mappings() to ptdescs
Date: Wed, 27 May 2026 15:03:11 +0100
Message-ID: <20260527140316.294621-5-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527140316.294621-1-vishal.moola@gmail.com>
References: <20260527140316.294621-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f1tqhryswy1u56r5k6ed61d8bqkyspcw
X-Rspamd-Queue-Id: 0BB874001A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779890657-287297
X-HE-Meta: U2FsdGVkX1/Vn+HGYosZMoGuCVI/QvVTGB6jN5PK1uote+Xshp25hX8zR+JXytti+qnpyJ3sP654zYaXtW0gYCrLI8plv8QmJL8mRGSJdmpsV9o3kPqHChtDkklZIY/J/dFFTc1pKKL7ugkmaYCn1fKizNEM/7GUKH1zhk79/vjEOCbvThSK1uRmAgDhPDDEwE7Eb46Gf9nUWZClttbfmHaQ3PkKmBh30SCGyW3+Ia1fZzx+TInS81xP82zvtQebfoWGcTS7dfTfM/Gu4qGbnSTE0mKSZSZzfjGEDH88ENoqiyEVom4hb4CisiFeOeO74cXs9x3kFms3+xZ6cPcpSuo80vl75sbp05EFKmjazgQEVjNGOO3bS97i1QT4hpMcBNlZUq9qGfI1uB0t5JSVntvHUHlgj+rRXrbfLRtKwKulUgcCpMcNTMq4rSBVMpugw7oV8M5j4PwQA3uhH2aAxcZ9IIuMPugDCvVAGsXykMX0SMmDs75WaZqLN110pKOTKia+Zy8JVzmBQIo9BADjhrSqiriOJKtbqJZFquy6Oevr+q6oN6AE6Yu/5T7EnqgzTEy1KwEc/OKDixLgi0EoXfP3jIaWfUWKUiv57lUv3gby2pq+4nIXaCVtBwvMj9pLTY6yjNLmKpSzRVuZjCONlP4M27Tptm5XZ79RwzQ1wMeCRdiwbP7mzhcCnF5o0zTmGObbOCK6xzjJrH1oDFsOEt6IGbeZQQ8sJLqGDmxqR2VA9/PE2r6MWkxqCNdVD4TB19rS0vxFzeP76+hhd3xhyTXDC+WFeiR/cUeL7djaF1rqT0d3pe7ngT7ED8xQ6Wt3+qLrb/CiWgbaEjj4X1T+WkkJcSuBnSd6Ljb+mvZcZkSeDgNfO67jH3fJbGRKVAa3/O7/HSJ7DXcMoTyz0sGmB7lmelQb+bsau2S3FOm+gBCXfjJFfOQgrkX32Ev3JkgM7RcMLESVTU3F+DKfaTJ
 iJ01OI/q
 zfhg9oZAi9ctsPb/WZGOBkjzY+ZhInh74dMLahNMc9hZmpClMn7gZq1q7veaZwlPjF4JoGAPHyTZjBMCxWtrP3SeCeAh2Dh0TlpybGDwctONh3SHW00b36E+XSuUH3vQ6gPkx6P3O9KAlZWRLEbcVhJg5R+ofhGXNIzguu0g6onfKcNIsZbphDq5ORpUizWf7rBeKR8OCRXla9nrIb8h2zxiuNydnaL6ynBBm8q7WSia25KUMFQE4tertxH9nrniXOJCiDiwQqzF7RBc67SSVTvlfgvda6lKV4gympwHd930k/2cetRNyb9t+LdrB9arZ1TJTPLbiXoCCMBK6I8uouQx+yamSUfTvOWr69H+vBojhizdfboQ23w1wnDl1HfYzyZHxGE6pnXgQvVJSbwCNfURPIPSAnZZzHHdtcemacv4mrlAfz+H882n940uwgmflG0W/q7eL7tC3nZG9cMYNDwbVhLcEi76SmEtHHErJP/HyuobUFeYH+DT/4SekgJSbDdXC4cq8hhyC9kQ99YoVeQIUfa1xNvPTDKuiG4b3lVd2h9cWp+yidjtqVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert arch_sync_kernel_mappings() to ptdescs in preparation for
the eventual splitting of ptdescs from struct page.

Following this patch, we can successfully boot a 32-bit x86 kernel with
separately allocated ptdescs.

Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/mm/fault.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 63de8e8684f2..6c72d6668416 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -269,17 +269,17 @@ void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
 	for (addr = start & PMD_MASK;
 	     addr >= TASK_SIZE_MAX && addr < VMALLOC_END;
 	     addr += PMD_SIZE) {
-		struct page *page;
+		struct ptdesc *ptdesc;
 
 		spin_lock(&pgd_lock);
-		list_for_each_entry(page, &pgd_list, lru) {
+		list_for_each_entry(ptdesc, &pgd_list, pt_list) {
 			spinlock_t *pgt_lock;
 
 			/* the pgt_lock only for Xen */
-			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
+			pgt_lock = &pgd_page_get_mm(ptdesc_page(ptdesc))->page_table_lock;
 
 			spin_lock(pgt_lock);
-			vmalloc_sync_one(page_address(page), addr);
+			vmalloc_sync_one(ptdesc_address(ptdesc), addr);
 			spin_unlock(pgt_lock);
 		}
 		spin_unlock(&pgd_lock);
-- 
2.54.0


