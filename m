Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 944C9C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 17:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F4C76B0093; Wed,  8 Jul 2026 13:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5DA6B0095; Wed,  8 Jul 2026 13:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649676B0096; Wed,  8 Jul 2026 13:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 36A9E6B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:07:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92860120243
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:07:10 +0000 (UTC)
X-FDA: 84966239820.21.E5F9B6C
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id C27FC40012
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:07:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="j3/j3WBb";
	spf=pass (imf01.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783530428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdJQxJx8F3XrC1s03ROFypct+e/tcjWcDJ9Fqkn2hFc=;
	b=ZXBKa9m+IxbInHpkB1wgXRUPvk10MxxjO7dyj/LB6NVqYGbF1ptHIDtN5rqw0gRTJvBGkZ
	W5FfG042dDEvMvz4UZt+Imf6l6eU415GiwbKJpXWNu9UL//7Knlzvf6zimU9CWX7cxmMAw
	myrs60e0XBmpCdgcPh/XY9x+ZputH34=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="j3/j3WBb";
	spf=pass (imf01.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783530428;
	b=HyutUzwKhPUGu18S9gNVn1lfKh9iLjfGZko0k+Gq1hg5TPjiVRWQJJcpikPVEiqXxULPQt
	Y1zyb/J4dQ6hQ408rj71FnDyzPNtx9NUjGjZH0SmVxII21i+vv9zM3ijIKG2nBOra9rQIm
	TVxnVnLpccBNhJVQ9jGn9uObj6WkigI=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84830c774a0so985711b3a.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 10:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783530428; x=1784135228; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kdJQxJx8F3XrC1s03ROFypct+e/tcjWcDJ9Fqkn2hFc=;
        b=j3/j3WBbG0jQ1EK1L9iweXaHUeNjz1WdIFTI9Y8xb2ox80vONULDI5Eg/ntl9McBNn
         hvNpFIO6THkteCsoaQLini0VRbrEzEZlme0wLoad/v4QwdwKZlxIeTg3ALzDhZj8HEm8
         S0KDMY1PlUlPEv27j30P6A5NO3gKVQg94ennEfiXtZhegJWi5tukoAEpKnRXfxpJa/wo
         sts5WvZAebQpfO6GJx4CA3DksciL51fQfISPpuzdzBjr7giTBaUNjXTSxu5kLqVGZ2+F
         +PLgcfNeswgfS9XsepHzv/A3RSClBV+S+kwkPiEOaJ7fGxk6a0VWp9JcYoGFQiekG1+k
         RhHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783530428; x=1784135228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kdJQxJx8F3XrC1s03ROFypct+e/tcjWcDJ9Fqkn2hFc=;
        b=kwQyUc/j2Cta/z56qrtVKx76p0skMM24K/iMQ9hR66PHikYfNSSgDkC50yATf00TPf
         VEppBB0kAVO3ItHDQIfjllh13mIk3V/2DqibCgO9iXgDhnlBFU/6o5ucbaKttczOZQhy
         f8By+ay+3bo7iwMe3hTpEq6wMZvGDSGNCmKZVR9Cu97YupC9nvP5DL5ixNCL97LiFMbq
         yBJxIWn7t3ZONT8LABb8vPE3LlgNTEwzuPvgWf1L4y9m4zfrJFm9SUOlslChX21I8Adb
         yxe6YXOfEFh2SVCH3r7WjyTIj34vwrkY7SX/Omlx7dqBfh2DSWIzoWiA3RI1SvpmQFGu
         AExw==
X-Gm-Message-State: AOJu0YywbeJxsaBYO2EAF7SRnwb8v6tETV4E63lUYup93nm2VZV4Tv0L
	PkGZ9cHquAl9o/LcPAVxI6XuabodS1BspsfBpv9B9VAYqw/U5xJwLAOW
X-Gm-Gg: AfdE7ckH9casZbJ7zGKFVBWlVU6wzta2M13eAyfvb4gW+LrXSHdkNC3gSzNF2T2GI6l
	hRhRlI55R/wL8ZJEmnju/C4H+vbmlgzIlvUpie0JxMQpMIBZuu/8f4ZglhDMJRNCDD36iuGiies
	VUlAW6qSZfpDDqTewi2CI/MJMccpYqqLGgXwqhl3KqmoBSNuh1aEROCdILu4FlRgFBUDooRqlUo
	uB9+hjBflWOOMZM2x3V2DVrM5vWDXCnWMXhHMbdb5mNIiBuOVCF/sG04iZXjQKpOin05dNaU1YP
	fAWMqKmNgvCYIsJRnpsCuMKcJD1jyfZuFRJrroMHOpCAlTw7wPuIQy5sWae7tTVNnWnK0gEud18
	RXTOTiNOgYnjbOvzUaMNmfML+U2xeYXFYQQg4NW7GvfT7P5gNMlGc7R/5ZRRpYqhgcZ7DZBcKGi
	si3mNjAlc=
X-Received: by 2002:a05:6a00:6f08:b0:848:2f74:d8d7 with SMTP id d2e1a72fcca58-84843003eafmr2839561b3a.72.1783530427525;
        Wed, 08 Jul 2026 10:07:07 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84847275fa0sm1119528b3a.22.2026.07.08.10.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 10:07:07 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	David Hildenbrand <david@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 1/3] mm/early_ioremap: clarify early_ioremap_reset() semantics
Date: Thu,  9 Jul 2026 02:06:45 +0900
Message-ID: <20260708170647.362562-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260708170647.362562-1-ekffu200098@gmail.com>
References: <20260708170647.362562-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C27FC40012
X-Stat-Signature: h7gdambrun3m97hh7igmpg199girr9kx
X-HE-Tag: 1783530428-9772
X-HE-Meta: U2FsdGVkX1+FTwlarPFwn6DKmxG2ZmxFur6JQfc9QQzGAPnPIXV7jJIDX+yaFAH62fnBz1v/v+8pIbGMzGsKiU3xxjiIBDPgx/dkUp5pjFqQOWVdeYG1+qoSXRKZLjMEkkjTAWAd55ciwXYvHqzxpK9lFeu9Jx8CnfCMMWPxwnOB8LWxHtyhLqkpAGUY+FhIVndjvwB/AIWP/rPWOA/pudJkNa44Aqs7xHgz1JnHwuYBfQk2OmRt3XsNsuBCDjTy9jGGJy0CC4b4mmH2ToRmoRGpVSR56eSWNXXKCzGpSP7qIfgyMJo3U3UhQMi7Het4UrUxQ0aveBSMml8MOTLLn8TrCsfiNyQcDwy6WnOqHH4sCa2ki9jXVzu0n0YsfDJZpg92mZkF1pmoY0EB8lq4IQr/U6cPuow9ljmGBkkAxj9XsTausveErPQeVcOOCApUCmqeQCkCB8D54GZ/4RtCYyeXg/cmgw+fSAhC8MG3ZCUt+o99DGPV+Hbey8AXbZtAPk7aW7R+6z1y4enqwGFN+sh2LbrXelrKi4P1QZON0W0+M3pGknHz3dn/uJ/jgz+3NZo5aV0qzMCbUtaCdVvjtd/h0m7jntwHxPFxbkxVzEhoAKP/TIKvhJcZJh/Z/VIusfoI6N6Dy17AA+VXqF+fdViItP+T4wvEY1DGLVfAguBTdh9f3QXVUIWlDtps6ml7MmmnqUq5Ygf+FUrgpBMfwDCRInPIXSnAZiaNvStlCy5bGwlOSW18b18/qsP20WQ1NBHq/zUf05pJemeFr9XDehItNr4jSYL9vSWhGhAvJJGtHCejEWb0SGT9Pl3v157fuPdJW0Ti4gI0V+v4OlJ2f9/AGc7Y68L0qfNqQIHHb9a6KmeXizs5DZ0IkBfOOSpXUSMvj1jgNm60fTBMDzWaiaI0uePRM/mZHJh8rKWn/8puR7qvUXN61hA7UIvoJ+JBiTYyVsDqgVFTYrz2gNJ
 1r/cGv+o
 5wVvDSneL4pQdmg9OmeHzLmy0IY30ofxIx2UIrv//N0VD0NspvdhnCQ9XMNM8271WOz8F+UxwsWUUEUb7xfiHwQjnq7MPySOkHqAx48c/xBWyKdpWIqMXYyniB88JZwEd5Knc67ecR6Z11POYjPjwSd5zEFoKQUKaz1TYD8g/q7P/BEq3y68hzc10u4LzNnRBUh7GUQ84v2YwHIPHuWx4rqlY6SKywn2eV7SQ9sjxYVVGa6vzV5n0/AuWq9AuWF20rHVLLAFGYbNMLeWwBKP1o9giHYUsj7lN9ooiwuXH+sr0AEMpw/9orHkFyflzv87GCU393YclOpzP3b4dqzxEo9wJgHrz7No5lIENVleLyDz9fg+3Jzaax9Noexdnfu/pNBFDKp3fqWR1iZTWYJrOVYWRSGJer0nnRHMRI+BE/NVeREQ00BiUbfiPvpbPf81YDlW/SpFJGZdcYIY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__late_set_fixmap() and __late_clear_fixmap() are only used after
early_ioremap_reset() has been called.

arm64, riscv and powerpc all have a __set_fixmap() that works before
and after paging_init(), so they do not need to call
early_ioremap_reset() or define the macros, but they describe the same
situation in three different ways:

                 calls reset    defines the macros
        arm64    yes            yes
        riscv    no             yes
        powerpc  no             no

The existing comment is vague and allows all three. Replace it with
comments that make it clear when the reset and the macros are needed.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/early_ioremap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/early_ioremap.c b/mm/early_ioremap.c
index 96c29b9dc85d..6215b90dfef3 100644
--- a/mm/early_ioremap.c
+++ b/mm/early_ioremap.c
@@ -47,15 +47,19 @@ pgprot_t __init __weak early_memremap_pgprot_adjust(resource_size_t phys_addr,
 	return prot;
 }
 
+/*
+ * Only architectures whose early_ioremap() must stop using __early_set_fixmap()
+ * after paging_init() need to call this.
+ */
 void __init early_ioremap_reset(void)
 {
 	after_paging_init = 1;
 }
 
 /*
- * Generally, ioremap() is available after paging_init() has been called.
- * Architectures wanting to allow early_ioremap after paging_init() can
- * define __late_set_fixmap and __late_clear_fixmap to do the right thing.
+ * Only architectures that call early_ioremap_reset() need to define
+ * __late_set_fixmap() and __late_clear_fixmap(), which early_ioremap() uses
+ * instead of __early_set_fixmap() after the reset.
  */
 #ifndef __late_set_fixmap
 static inline void __init __late_set_fixmap(enum fixed_addresses idx,
-- 
2.43.0


