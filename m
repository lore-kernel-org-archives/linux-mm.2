Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EB02CD5BDF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 039276B008C; Tue, 26 May 2026 07:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2BE66B0093; Tue, 26 May 2026 07:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1A776B0095; Tue, 26 May 2026 07:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1E616B008C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:17:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 946C9403B3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:11 +0000 (UTC)
X-FDA: 84809319462.13.A5196C3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id E20E040005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NXGgiha6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+b83bGMCzyEzByJ+5LU82nBa96lT9m0LV7qEzNfGOc=;
	b=vvryp+4Q6SWriwIjcpj0iuY0ZspBgOIDZ0XDEm+tqwxp2d+01WKj48LDilZ5HJE/5OnETV
	jRad3zy565YZ2vNdKqtDWKLJl6AGBQLNlu4GMDtGzeGZqS32/+TN2TRzhWNAC0XbiCULr7
	qcv68mY6nbjj6limwRG52FYEm7Nk4/c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NXGgiha6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794230; a=rsa-sha256;
	cv=none;
	b=48jmreFDYNvH1D0kLffo6L4JVx7ueV3uhoqeI6fuRRB6YyRv5hKNqow5fO2Z2BWsZRUilk
	t/wOWIyxU2v2m7l0A+PiGGK7mWi7ju3dTRN/2lPKdadNAwlcqqLQcle/F7M8BlAuiBKEA1
	HdVhgu7rTpZ+HkDR5MCM+kUzXN0WgwI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92E32169C;
	Tue, 26 May 2026 04:17:03 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24E033F7D8;
	Tue, 26 May 2026 04:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794228; bh=+OGpwgzVEkFFPsMOgL6J2ZFY9bOrw4hijWLmgpJn7uk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=NXGgiha6GINynS7xkcX0uVVxHjHvcpyuF7Tk/QpU/L1V6x4CHZsHCvSUYs0ET6+nz
	 ogt+V9rf6M9baMkmmGSc1m8ROeEoXFuS/FC+MHYGVrDhkuB8nXX/P96j8D/2/W9dzY
	 pEnZJ1K4rGcr6qUXdyJ80DfLZxP3qa6AGXOOPeTE=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:15:51 +0100
Subject: [PATCH RFC v8 02/24] set_memory: Introduce set_memory_pkey() stub
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-2-eaaacdacc67c@arm.com>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794211; l=917;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=+OGpwgzVEkFFPsMOgL6J2ZFY9bOrw4hijWLmgpJn7uk=;
 b=8De/kV8sEljigJjiEvqeCIMnPh9ZNqCIUniOyYuqA+vqWE1URz0rwYAePpTlekHMqoi9dpv9D
 +dX7ogRAjKbAfS1LyoNEllngretraN0QIiB7BLwfLTbt1YABdnxPt1a
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: g4bgf9hawwow8ye6cumnrcmsqakmihad
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E20E040005
X-Rspam-User: 
X-HE-Tag: 1779794229-869625
X-HE-Meta: U2FsdGVkX18IEBjD4R4U7h+LD9oj7F0x6BeeG1Ce+Wc9dt7IM0SausZs/eKxJbDMVGMmiRei0pcz7Z1r1Bdm5fIuSM5T4ToUh30LDI2uOn2QiLSxhvieWPW17le6wi9Vjqbg36YsVrXqOuwbGimBpApVNMgDC2/YwkBW3oVO8di/L9qotdF7ujAR2raw6k71i6QjTna3lO2v6jtuoYQBLPBswLReO7e27URbA/6BBv3AZjInth93zgweRtjToWCycfhdNq1BfnVFiv7/v+7GU+W79iW9ROTT52pfMQDfTRbFJJzC8+8SB21GbAq7bTmD4n1wVeaFMBZn76LwL8HCLlja3lXijV6cIxoExF9mClnfX6DoiCmKKD2yk9KiGFAfWb/hgzE/U0v8wcU2HsmxIRg7Yw14rmb5pEgLoeqBM0xuZR17msvJn9SWOfduzbLCstZIYqIFpMoVNX7oZS2vlqeaV1KdCW6pPBTKrB2gWU4qtrZOAQ5lMuXcvzrU1XdpluXDZ4STZz331XNwVbqLI+NYQMSHLrymA2TJX0YzlFoawfrd05ckUra64kJa0zl4BCpXNscBXhAMsWySfTfzzha4KlFADE0MGRBlAibPJPkPK3D4UG46gL0C+EpI/vtmmfTQ8VM+M76VXv7dcY/Si5B66z4rAkMOc5ed9m7MiJnRka4teuYqApf8fWJmGAbNj2vg7c4fxwWnECaX8gLtKVdFsUj9fZDVbRwxpoN7OFrB1tapMlepulkSJ6z9EbalsqR0zN03KEdwdYXC02I7RobINwUYfvbR6ld/gZvILclnnZxfyTUPrh6RcLlca9hcTSpFyDBrOM7FU0jir3tAKVK0/LOqCgNQWZVID9iYf3aqRpYDkHXdLDo/e9HzotoTTdd+FV80U4xRYOMeacwJD32Mt25RFWZfr/OU0GKpTZs+tsfM8j0ZoKhho+lN+f5+MBQWg8p1YDP7qX8t62l
 qBp9JmsK
 qKQz1fTFCsHKq2lLPPo+VFMtgQmIpz9fU4EToD8EtV8JojoosDVjkLuZOG/iTleWJ4UnS7BEY6YMyfxRd9wWB/NgP9BFetuBvGZhowfoRYmIqq3vOCgh0Q0Kx2lfIseFXUJIOFJYn63/NuGegdCE5NSFkd60yDwG2H9tVRnLsC2CpbKbIEhrZGQ952rwON0ArHt7lIA/Oq+rslOXyry8YmRFvyOOk25n+LFl/5gejGKdZx5Gd+WO9zAhKDRp7R445YoXVHZ4t99p58aa3wZ83guEoQ10eJUjVac6/pYkWT/yP548MIx1mfCMV4w6Fm1ZrUJ61YE/34v+FLZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new function, set_memory_pkey(), which sets the
protection key (pkey) of pages in the specified linear mapping
range. Architectures implementing kernel pkeys (kpkeys) must
provide a suitable implementation; an empty stub is added as
fallback.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/set_memory.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..7b3a8bfde3c6 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -84,4 +84,11 @@ static inline int set_memory_decrypted(unsigned long addr, int numpages)
 }
 #endif /* CONFIG_ARCH_HAS_MEM_ENCRYPT */
 
+#ifndef CONFIG_ARCH_HAS_KPKEYS
+static inline int set_memory_pkey(unsigned long addr, int numpages, int pkey)
+{
+	return 0;
+}
+#endif
+
 #endif /* _LINUX_SET_MEMORY_H_ */

-- 
2.51.2


