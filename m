Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1C660A2635
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 00:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zYICE5Yg
Received: by kanga.kvack.org (Postfix)
	id 38EB06B008C; Fri, 23 Oct 2026 20:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33FCE6B0092; Fri, 23 Oct 2026 20:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259C16B0095; Fri, 23 Oct 2026 20:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 028516B008C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:52:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C969A0282
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 00:52:50 +0000 (UTC)
X-FDA: 85355694900.23.076559A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 00A1C180003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 00:52:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zYICE5Yg;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792803169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=xZtcQ/8DmJXSoJNrGPRWjRKXH7jfwvLZwbB5yzP5F58=;
	b=qMf6gjaIuDVDukB5ZoaOslR60+1UabTOk3fhwHFmBdPTmIMbO5vn12VeQnMH/fH0UPIveb
	NtG65qHqreBz36vt8vlpKPtBW2VLlG/mg19GvXO0vZl5H10U2ZdKeJCYMamzLFHgRTxTfL
	6mOKjMTmgkCYn8tkdi7Z1TEeAaKkaMg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zYICE5Yg;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792803169;
	b=K7a4P8b+pOQA0hInPREAfKdu561ObZ2RIUD4v8KJR3OVK0vNLVYgvTzIefFeOnEMmWr5S7
	wu2TO1Rpg3f8RHRTiiURn5A+EmTo9eBBvuvH3N7GJ6XDvK2Lu1X5shnRAHyQCBW92MzhFe
	uDQh8dxlvaMe5G6OcEOE4NdsucCWEuk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F8CE4243E;
	Sat, 24 Oct 2026 00:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211471F01181;
	Sat, 24 Oct 2026 00:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792803168;
	bh=xZtcQ/8DmJXSoJNrGPRWjRKXH7jfwvLZwbB5yzP5F58=;
	h=Date:To:From:Subject;
	b=zYICE5Yg+IUEBWm8IoUWCSu+vdzhGEJU+n2l1l6GcSNfo6BwWRjlVERupouZO7hWp
	 Cg8cKu8D7uluICZsAE4gia1U4z/FoCaurBS29DEgv1GGPPT7M1AfAmOSL7/EH3rxDZ
	 XeCuyss5sqJ1OsAKPsLPy/uaTAjoH4kyT5ktYtgQ=
Date: Fri, 23 Oct 2026 17:52:47 -0700
To: stefan.kristiansson@saunalahti.fi,shorne@gmail.com,lkp@intel.com,jonas@southpole.se,broonie@kernel.org,akpm@linux-foundation.org,linux-mm@kvack.org,willy@infradead.org
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <7e6799e4a26d4c87b28bfe1d0bab7d54.1@linux-foundation.org>
Subject: [PATCH 1/1] openrisc: include asm/page.h before folded pgtable headers
X-Rspamd-Queue-Id: 00A1C180003
X-Stat-Signature: ijnx4g1po19mka1mciuumd56g5ysdtab
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792803168-45871
X-HE-Meta: U2FsdGVkX1+kngh0fVzgoxeZGk/AzCf2sxXzCs0MuT5lMKSDW+JfiBD038BMNOCVuc1Tdl5GuvICUFMa4sL+ZWL8yCW/aVdtQjJGkUFtlvgdXx/o902D2OCDRvkjGLN3BbfrgiVP4JdDOe7nIf044kTxVLToV34Uej4HkvyBiUrRf9DFuiuww5f8dM4gbL7fMnTPir5qr3/y4d1aJqWpFib3WrAn5c+/biyNwMyBH15O6ZnoPyeiKd0sK3JqCerJhUvPnKDiuRsJ59RKy8n2eq4neEcYYeXpgc10RsktGSp+ORCPtde5FEXi9Goa8s/VEBjE93rOI+PfMu7NTUUtgJrklipVb58S1JMUy4WnNKd7nDBsK0eprREPOOo8u5QEGAxgRIcGboM7Mm4joiU1R9SZqvz32MptwcQMrtGwP37Q3TRLHrxxf4b+3rYZ/Mp9Tc74jHF9fbf65dh+TiKtIFUzwYESkkI1AX1nTgrafC0ylYrKtD+PBpSDx49o8pUEjha+r8fq2qBLLtNTAPmZC9z8WLoGqt/za6izSgNGzb6ANJ+JhocPELjahoBcoDqT6my7ejbY+20pzHT/N8cVjnYuL/euMAEa4BXVqjlG6Az4nDGWzQYGvc7jVedpdL1rklZ3rFecBRWStRdMZoBCZgmGaNEzEcgbFZKzb5ygXX2hNjHWjd9pMhNMWplAssZVH8gSJ1YR+GGdXAMo0b0tNRRHci/cDIaUG0i+Tnrid06L8HCMA4TMLmU3nCyrMCRFvQnKCydXzyhYbfzDMiZyCLJk9xEg2MC0N4RjlOghsMocG6PK318x8ErYWqRGKrhVC7qj6P8n67QsG+Qeou8O0o4KOirj3lu2rQPf9yqnoya1SHy5dYlsENB2puCHakR8fOMboQQVPf3r7uSkNhWl8f1SySURaUwTHortLs8J+v2H3bf3QyFpnK01zAYqBLYcf+ZxjswOCHCMX1WMzok
 5h1JZF1K
 oVXfUtZc2pLsN8vPY4tW/3IQ3QUnSjw1U4FCBb7+RTwGIs9KDhL6K3JZBRlMr1liIj7+vdZ7FlQ8kVycEABpM9cv2OdkZuu/31lNcw0s3DX8HDCQrACrJXOa/qRMj9YwUiUrCxz/ko3KkoFbWrvNyvSt4zCg5Nb76OJHQfKxEGyrsaxiuye8B53EiP6KNEry8XYU08T1Nw7MxnBYPhDiFWjtL/09ZLxKLmxG4LfVSqDHiRedr99kKhRtF9D0Xls3aLnGfmuN5+vqiq4GNDUXhj/2PBoZbcVuS/e9mGdMAszetvNhAkeOSHVaxywawofJl4M10Hk7JS8KD8d1QI1xX19VWE+W1OYfl5ota+gVuz0Ja6OXfbTL/8XqsQF1X6ow4wK7pbfef5AXUmIq1xpEilpJ1Sz7NCGB2xwMI72F+FQkjNNEowG0DrMvmSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>
Subject: openrisc: include asm/page.h before folded pgtable headers
Date: Fri, 23 Oct 2026 17:37:53 -0700

An OpenRISC allmodconfig build fails while compiling the DRM TTM KUnit
helpers:

  include/asm-generic/pgtable-nop4d.h:9:18: error:
  unknown type name 'pgd_t'

The TTM header cleanup stopped including linux/pagemap.h from ttm_tt.h. 
The remaining ttm_caching.h include pulls in linux/pgtable.h, which
reaches OpenRISC's asm/pgtable.h before asm/page.h has supplied the pgd_t
definition.

Include asm/page.h ahead of the generic folded page-table headers.  This
restores the missing type definition and allows OpenRISC allmodconfig
builds to get past this failure.

Fixes: 2854902575ac ("drm: Remove pagemap from ttm_tt.h header")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/202610240135.uFA85jSq-lkp@intel.com
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mark Brown <broonie@kernel.org>
---

 arch/openrisc/include/asm/pgtable.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/openrisc/include/asm/pgtable.h~openrisc-include-asm-page-before-folded-pgtable-headers
+++ a/arch/openrisc/include/asm/pgtable.h
@@ -21,6 +21,7 @@
 #ifndef __ASM_OPENRISC_PGTABLE_H
 #define __ASM_OPENRISC_PGTABLE_H
 
+#include <asm/page.h>
 #include <asm-generic/pgtable-nopmd.h>
 
 #ifndef __ASSEMBLER__
_

