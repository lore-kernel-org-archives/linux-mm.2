Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA18C79FA3
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6E1E6B00A4; Sun,  6 Sep 2026 23:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD06A6B00A5; Sun,  6 Sep 2026 23:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBF566B00A6; Sun,  6 Sep 2026 23:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9491B6B00A4
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:50:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20D35A4B76
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:50:56 +0000 (UTC)
X-FDA: 85185590112.24.7447171
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8726A1C0004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:50:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sMy811HE;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788753054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lVshiSVFZ9Y82hpOELbFUOQ47Aud6N74VG1d7Ctjwk=;
	b=bdLApLJlnR+IbKYSXmFzyu+9kD6NdPPntMtDfcpZ96l/QSCTr0hJl1L6oM2QlLho+f9XfU
	VbFr9sZ0D56Zbk0QMG07ZWk4ycH33Hi6cR7uW3q/w4ydXHWjIxH3vgv4WrB7VfNPPojfEs
	HmGVvXyDJW0lc28+luKlnRWBjnc1KZA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788753054;
	b=2FvcM0CahFPgT7djWBIa46gn9RD1T/LT7JeC5AJyqTioQVILQoK5WtVnr8xtl15UfNqz4Z
	cRpt3HmujPl88l1kVz2FkjBCaBP50SXr6Bybot4EpBhiF/Xdu1NpU8DC2o9jH3dqOIw+4g
	PX1xIoZ3BUZbGfp7LFySTDMHyhHkh3k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sMy811HE;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5DE61477;
	Sun,  6 Sep 2026 20:50:49 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CB6B53F7B4;
	Sun,  6 Sep 2026 20:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788753053; bh=/rjGzAt748dsaT36LBnwBIEZW4gfjkEspNbbmVlfxKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMy811HEo7xsqsm1p6JcAzLBb1J9PIdm3/h3H35Mn7WqMv0uYuDIVHpZ3IQqhy+bA
	 sWeT+NJFvEID6NFJBlSkLv1xwq/uGZiqo3RpydBbivEGHiwYUfOgUUsd4NohfsU0vo
	 apZdfIn31OFzbtwwAWTrajkO9WPqqLFAmPjA/4BU=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V2 05/14] arm64/mm: Override read-write accessors for vm_page_prot
Date: Mon,  7 Sep 2026 09:20:20 +0530
Message-ID: <20260907035030.2839978-6-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907035030.2839978-1-anshuman.khandual@arm.com>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8726A1C0004
X-Stat-Signature: 7t8xokh1dtfsb46xg4e5reabasqk3q69
X-HE-Tag: 1788753054-942505
X-HE-Meta: U2FsdGVkX18oPVl+CgWhBK3VlwJG7jZWaq62qSG5C/37oVTI6mdbumfC53hk2O4/45L5K2YN0V2hTk1EOsSQnNQICr/YZJFUHMEcsYZy1EUqifCjO2G8t6i2alD6B7MZPjA7Ag2dNuZmpV3I26dK5EbGxlxWqq9pLRr2vdAyU6rGnQ8vi6Np0OKxa9Iuns8AonJ21RjPRfX6YcRu1eaMDMF6gsLZCtRMQKePHl/Ogt1ZSeZIdqUITJM7RuJmrgnZstXxb2XRQGX7Sp/bWdlDXsuJszV/4JVZX6lZtRwD/x0rv4/6FfNu9hZM7UvxC9iHf6InPwdfWgKxdvkO7Yr+es/Z31GQoeRI8ZFM25fQo0zPCgeISuLqFEOmg1mvbF83GTZZ5bFaAPSGf9HCLf9uzn4Ow3sOsWrk/vAXB5TSWiiqlf2Fe8V9hlkYISPVZ78UnAmRK/qA09pCQj22SC4ajSyRWOdiJnUrVLUMqORwzA8dsvaVWmWEHlSiwFymzB14AXXzg0Jp/SEBF07IZy9GxcYGhkbRaEzNAy5ZiusfhaZWFuhWvwbl65Jp6o1H+rZyuEHW+ksThP2I2qLYcl2F0yy4fmL59rWLPk1sHu+wOcvU4w4fHs8O4WxjYdkmUy1rmIjUSHBVbcB/UGSjup5RxVT+Ux7Zf4aXyoiNCRHLWmzAHF/i9fQ6PP2x5jFM6JMtKgofSdyHjqC3c71spFmTbAOFoWnJpGOgTHqYq1H83Cty6QExoqWlUD+L7qT4MdK/qptA7WxCb2afsMeut2RFZ5vphcJcdyOLl5TmyqOEHelpOnYR2ziV06oKNVTwwrlg3kIKfuZY9pTW3m6BuAdBlT+rZzr3j5ZcgEp61PHLdHoCYvo1TBQ7IK/4ZW/lb3J4ZE7kjQF9i1Wv2k6uU95O1CUwEHT3YyHY0/2OZd8O+yrJ2NE+39cn1iw653FtWlxTS2fen/2wkFRd3KGZRYh
 dx7eCssi
 dOXmBOk9ZyBJ9UzRYYR8ajR5hA2PkqDjwRB3OyA3WIlpjv9sc2qWp7uQxcUL4xjNa6awvfw3odmuood5XNhKfaokO0hKSk9ej50LSc47VJdmf+rH/LfG8Mc5FfvcWhjknyni4a8WpyFwyy1WQKMhnP+drBtCFxHScCoIA3BusoS/I2bitP3408qOtAf0ZAzfOc6dIM/WOpspfe4vRRYTTPLrPn5RlP8QHc+EP8tFRxxtNAXX59KUL+EMfp1dfuZRX2FteFaiT/s0/Qc4l2k8kAM1t8oEJ/D9iwkI9YB2pP5JXtJBwW9Iqof1ALAwEdigEo2VDtyp46OxXgAmLTtq0009DEwDQMGg3oJv+31pS5c2PCX7+Znv7YkBWhT5d5GBRBbbbBLP1ooHwCO+czfNTAVkjtkr4v0ok7zGm8S3Vd/h4eZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Override pgprot_[read|write]() accessors using ptval_[get|set]() providing
required single copy atomic operation for vma->vm_page_prot.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 66bf5bbe484e..2b457db19be0 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -122,6 +122,18 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
 	return ptval_get(*pgdp);
 }
 
+#define pgprot_read pgprot_read
+static inline pgprot_t pgprot_read(pgprot_t *prot)
+{
+	return ptval_get(*prot);
+}
+
+#define pgprot_write pgprot_write
+static inline void pgprot_write(pgprot_t *prot, pgprot_t val)
+{
+	ptval_set(*prot, val);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
-- 
2.43.0


