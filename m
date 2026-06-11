Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D656CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E97C16B008C; Wed, 10 Jun 2026 23:09:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E486C6B0092; Wed, 10 Jun 2026 23:09:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37AA6B0093; Wed, 10 Jun 2026 23:09:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C365D6B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:09:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 51CC51C1D11
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:09:46 +0000 (UTC)
X-FDA: 84866151972.21.D39D055
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8DA5B140008
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:09:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S8uSY9vM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781147384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WT95mZHoPykr2tWUu0TCr6QJxaYWH5/rFPVhZTId5OQ=;
	b=R2bbqCaWmeCtjP3V2AlqgRyTgkJLmKDx7u8kR6XEHlJPu19WpkZCJ0oARyTMnrGWzu2AJI
	P3ddxYuwF2Abb88NPaxIPcAm4hDWWlUqQSeHgYkX/PjYXU8WiVKTEYWzF4plyMweiAsVuS
	o42k8HSAiBf5X376JpVF3FphMWG6d10=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S8uSY9vM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781147384;
	b=5kMSOkqO0PFAn9BBFXnVOpd8UYgKCSM1Zlxm83FwEo1hiwmrLlCq3QHatMbfixASboyUIA
	vsopFKnBywhJDedYhjDzdfLE5ug7zCB/UHaS+v3ItUv4eekuFadZx2se4zq0DX4LGsn0Hl
	0up5GfaIRLQSJKk3TXDVuH/i75c2WSc=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-842273a2c4dso5098411b3a.3
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781147383; x=1781752183; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WT95mZHoPykr2tWUu0TCr6QJxaYWH5/rFPVhZTId5OQ=;
        b=S8uSY9vMNss9BghfawS7em3xWCrBR4uNyoJcPe5RUMMqbZgnKCAhXoJlicBRk8L6tu
         pwlk1PT//TeHQzQF8+UAw1k67UXUl9nVdFghvw1IGnqWjUxxHWux6P20hemrbhLMOBID
         77xuhSatDhDx2k1kFxFE3FcP1hNX0oSttjYnyx2eVWLzK7uXLtjyrzWr3dFPUeJ4+fmi
         W/e3uIKYsPuOuSQhosfnloSsdNN+qSyOAnGE8FDybW1UgfR5WiNjDGYws5n2x3zexq/b
         x/WPckwIgyz8LyccgS5KnEbTnvzMA4OrQPVbRS05KP1L8+Nc0OIMgQh5aGV9TyEzjfV9
         O/mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781147383; x=1781752183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WT95mZHoPykr2tWUu0TCr6QJxaYWH5/rFPVhZTId5OQ=;
        b=U6JPiA/kS0pNHuvikKJ+cR0K1gYHO/uXmKCTKH9jP0gf6zHMTuxy9cc23AD3zup6+0
         Wo0TveNAGiXGJ+Yx9FNCPWYslqCeAWeG/fMrJf4D99QalWqKhtHBRZBajWBJUZ6dcgdn
         OtYRBqHJPAwhOlDw92GrcZ7x1XrQq+Gl7ZqCw2VJnnVuMYx61FrnUkJW3k9LLkVwMGAM
         QWD/T48mFkKvwUHvNLs/LklR6DDbl7yQAvzaXojl0UPwd0m69zdRZwaUq1r6y/wfu4p5
         nUtgTc07Ty6MowGEEM+6RErZt+53vC7mblQDgPnU28tgkEucsH1gePEO/fatgBEk60Kb
         pnkQ==
X-Gm-Message-State: AOJu0Yy9u2UCStsw2c8DFVR+bNd6YSvYzFLogC8Cj7tdP82prBhojs/V
	MGQOM/IWKnhhIGcniA06Kon7pKCuP1KdJHRyHdc+soKtKLVGKAnsaIQPTRFwFHYG
X-Gm-Gg: Acq92OFWKdLLv4/C2S0EpiLHMFTIYqj+GJC9NypEO9aFiIWRNFLTzxjVnYIcoFjDjKk
	rFK1wdtl4GGQkqsdhSTR2B7z1bF0jM1mMT67CbN8KY9NVM4tYQjIgxB+JC0x3/3/w2LOzM3GzCz
	aVr3ED/9TvLmTm0/MqlNuj+bFtkjIrStI2O5aAT5rfg3lHJOf85PycfvGADky6A6aI2b5hovF6Q
	a3aDyZ4oViwkmjnDYRZJpd8RbGkqELIPv040OxNBR65eboaF3p7sP0YWoryfI41sdYZ+9hzbyu/
	0mV25y0ft27NtnlKnG+drBQ3f7PEHilC9guUNBZUxMA4Z4w/eEpf/Y665qJNkoTmVLWLCZ3AT4h
	lJqsUBXC3J79zv3dBh9MTK6qzSFJ5pUjKCpYzka3mRw/zg/K+McfuDrfaOx4QmMlKox9yma3del
	nAEiMqvFJCL4CFzM2AM1kZ8gi1nNH2BF0CCEZcyvI=
X-Received: by 2002:a05:6a00:12cb:b0:841:d7f6:7297 with SMTP id d2e1a72fcca58-84336e0cc4amr784300b3a.40.1781147383427;
        Wed, 10 Jun 2026 20:09:43 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84337bb6ccasm289180b3a.16.2026.06.10.20.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 20:09:42 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Sayali Patil <sayalip@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH v2] include/linux/swap.h: Remove unused leftovers
Date: Thu, 11 Jun 2026 08:39:32 +0530
Message-Id: <68591daf0d679e5a0072d63751f187d14613e2b0.1781146877.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: t5fqg3qe5qyka438zh89ih3aaisgd7no
X-Rspamd-Queue-Id: 8DA5B140008
X-HE-Tag: 1781147384-792848
X-HE-Meta: U2FsdGVkX1/H9xe6s1LhQyaeftbdXkGvbQgO7kJ2i9u6ysTkJXxV+MOBtehvXhAQidXdExe4gbXXLf8m1X0ZQ0dTz/b9HzsHRApx/pW0FmD8XXPPExvkkgQtTKkXFH4Pb99VjJx4AHYMGcvUTst8LFkETfqqVjje53zsbPACAITvmuopc9ttWk5ur0qzdyvUjInLcJ2qqfqNNMjNRWD5oRDLI+B1g0dNiARXNO1U+mMjMzG5ieN8qTkrIcGwnQJyePzAY7CStxb0n9rRL1fFwm1yH5q8BkFduu5N2FDv+Jfy96jaFN8kHvjrT2shlGOAHsW/4kPUpGoJUThtjeXGQ+WeMVHDzF/1fAsU9+yfydATMpJixgmgebg54/xTNAXQ86L5y1PrSORhpPG4jnzk/4ra2m3+rZvZG2H8qhtnStdzkz0M7N/XAgUWw5tO5mqvfio2fdo575Cuto5Fl0mNOtIwDAfQ6KoncZGRRhD7FqCzIHyn9dNoVw0OzJB2mOnhR6Nif8sEOusYdETA4QAnwi1PxMaP+42Oj+W2ONrmHXs1TG65ymiHynPzgfwMyhEBp9b5sjIPD5tUz6XX90cC69doKAEyK0BOVOE1ZWTeZKd/JxL0pEShKdaaVMOS5ADcynXKgN89X/vAohjzM/pkRUdPxyeKXWrApOv97fheSHvLsbEe2G0+BzCjgbHB+UVdalHWB5XqWi34qyGb90+4sGBTDfhJ0b0/PJrFamBsxywh6whwC1xMzdeA0j3NUPEdfP7gDpmlPWI/Dz1CdoLkRsLImg5396KCm/C8PLPqrlIjAk8AgVPcC1foeGXyWFoHbSdUTSK02CvpD0WQ57dOlH/Cx0u0zX90MVsoaBfV707RNDL1w0j9Z8fPpqlPr4Q+Ta6oIRMYwXAaMRTCGsI1b5SkmmhOqN+852AsRYf8OMj4GQt8e7Ney2DFXw2uPQOuO3z/W5wMcNu1jMNOTQs
 smWHTJ5Z
 iAmhezcsJGrEFgemmrV7ChjE+GZIA4UlLSAfIbXEVcxwLfB7SGOejlmpQ1VHfSj6hY5NrCPcD52PBxaBTx8QwSlHCK2srL38yuAwRdp8mfEsQHN7k2NUJKdRiQNms77j+iVkZ3DgfB8zzOT6/VE89UNUVXfPDBVLiPIaxNMr6w97YF6uB4B9DvI5oMJF8cNZ1DY5mEI6j91vtE2nqL1ohcahf1n4+9foLDmuon/Fu+kJz95PxqNmyh5ZdqSNLs+Cx8dHzvTpSkh72nwi791klMzJ4VbrAjysjp/Akth/ruE1wLh3ZAZUtP8dV1Hp2uDwucid4716bZesDHQcL2Oyjr9t+BjFg2emVeAdaUwNh9aNekaA5efWIx17nFEWcZagX9sldL6NobHsAa38u2DlPwxnowSx3RdG4UeU8+2GCBIDC5+V/dcsLNbNyZJV3VQTi5zKp8cuZvdZaotuD5vWgDt3AIWgCUSZCqQgeai06c45f/pqtHtl6OvEk1rbexSkRjz7DsV6t8irj/B8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This removed unused leftovers, most of them are forward structure
declarations. Also removes SWAP_BATCH macro which isn't used any
where in the code.

Found these during manual code review.

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
RFC -> v2:
- separated from the rest of the series (enable thp swap on PowerPC Book3s64)
- RB from Barry
[RFC]: https://lore.kernel.org/linuxppc-dev/cover.1781000840.git.ritesh.list@gmail.com/

 include/linux/swap.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8f0f68e245ba..46c25523d7b8 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -16,10 +16,6 @@
 #include <uapi/linux/mempolicy.h>
 #include <asm/page.h>

-struct notifier_block;
-
-struct bio;
-
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
@@ -29,7 +25,6 @@ struct bio;
 #define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
 				 SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE | \
 				 SWAP_FLAG_DISCARD_PAGES)
-#define SWAP_BATCH 64

 static inline int current_is_kswapd(void)
 {
@@ -175,7 +170,6 @@ static inline void mm_account_reclaimed_pages(unsigned long pages)

 struct address_space;
 struct sysinfo;
-struct writeback_control;
 struct zone;

 /*
@@ -442,7 +436,6 @@ extern sector_t swapdev_block(int, pgoff_t);
 extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
-struct backing_dev_info;
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
 sector_t swap_folio_sector(struct folio *folio);

--
2.39.5


