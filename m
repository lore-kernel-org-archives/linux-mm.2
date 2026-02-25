Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A78F4BB9E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 11:05:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77BD46B00AD; Wed, 25 Feb 2026 06:05:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 750496B00AE; Wed, 25 Feb 2026 06:05:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6666C6B00AF; Wed, 25 Feb 2026 06:05:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 547066B00AD
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:05:15 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1EA811B6F72
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:15 +0000 (UTC)
X-FDA: 84482697390.28.4DB8885
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2FDDA140019
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kBSnuG4j;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772017513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5Rw321CUbGq2CWBlWTI6x0JAHGQZPTv69nPcT78KGw=;
	b=3vE5l3x+ekp1Zy/dM5fr3EpiSmt6fDC0BCof81F8botUsRnbdpd0KdimGCGpvm94FnUGIr
	KvH4HO3WQcc4zNE+b24QikGDadFO3cND8LmleuybjIFO+nGyUoyBHQoznyowPCcQ+y9p4o
	zgdAykVH6mpDNkSJH63aSTvcaijEpWw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kBSnuG4j;
	spf=pass (imf26.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772017513; a=rsa-sha256;
	cv=none;
	b=CLjztjVekBgR6z6K1AddWuiThTjm8KWWiQY5NkCHp9DX2x7kbazSx2xXRGp8burdSIDc74
	wKAthk7pTCC8D1EAKtsKMI19B5SRS1mQ1rxMsJORXA0NVzuIZXfMyjWOpeE+ah2ONgaLb0
	xumVoTbt+xvDymchUVwv0JLCcwDQsDA=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2aaf5d53eaaso44681505ad.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772017512; x=1772622312; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5Rw321CUbGq2CWBlWTI6x0JAHGQZPTv69nPcT78KGw=;
        b=kBSnuG4jG/izo35c/ZGFWfil/liiJ+3Y6VzzNnMWGAYfQjwWeQMn1Q4G4Nt+XqP+zk
         IXj5jFeP5yYzuN4xtJmyXe41ZCDowqEEWph5mHQkf4XN3biPOUEG9sixEtO2tnQYUJOE
         t1ZK2i5JWPvwjG7GYDcCqf1QenTkF0gn1Iui+pJARx5uCB5FHW5pTyu1UC/5dHc4zSlD
         +8XB9KPg14yVUKlZ1Yi4xsKPOD81nMG0mzFrCiGA0t3ishWTEXy6XrvbYPywcveeS6Pe
         G4TEUuzAceZnAgqODHYnqqTpOeVF407r2P2knsPoi/w8cLnlmJeA3N14a1yx4DMG5INh
         PvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772017512; x=1772622312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I5Rw321CUbGq2CWBlWTI6x0JAHGQZPTv69nPcT78KGw=;
        b=LtTirgJ/y/4NavfcE1isaaIZvUYa0seOkkRaw6b6HC+miFETIRdmPQU1RCnF6M4TbH
         33W3blm43jjXfPL6/+jrM7vD17BWoUCvNNEEYTatJoBkfkT3JWzrQ4cmzFzc57vUh34c
         6ftnlJKuyPtjYV10EXP+R8pjAFqgg4FTv9CcVBhtD+baNA23tq1RqLECe2Gt9mBp29bg
         5NmSSg9SmLjd8YQyyzsS7XnidZrDGUqYDjVlzbD8DfdxdjZpoEsGib9eQtBp0pYwD+Sa
         iPn9GSrk4QSFcfI6c/s75qCMvsur5WY7a9qneKQFawh4Fw2wLcGB6zpXrIeoAHn1fS7f
         UNGA==
X-Gm-Message-State: AOJu0Yx4JxyM7pH8HYbDsSbFs4WHjvIS0JQSPtNooVcUfUTJ7qNiWgyF
	JBhXMCKHJog5+hyk9sSdn0c6zA/Oaki7Bo7P2SjkCmWJhhhupd1/VsFD
X-Gm-Gg: ATEYQzw6bmM/gYfd6r1NrCD+AzQHqBQNDM16gRdlJjlY0m+A8N42C7MloCA9lIZT4f1
	ykymaJG8mlKZlUfgRKgvjDG70qQOEwshIPO8O0yeCNI7uQiGtkRedPcET72quTVaEvdH0eqH/e+
	xtkido9Ruyp9/7ZaKEeXdmaOy5/Yy9CSLLa+uuS64TmJ1JQROBc6P0DuEb7bmBnbrz+LlILRjlG
	EYBfzxcbKScrXqGBYeDu0AQEPGLxRuXfkJQva4dAzpj+TeSN49ef0CVKs5TsDo46kHpAtLaKO+z
	0AOWecA6y6d0OpS7nTCWrd0YqkYmrZccpS/ZOkIyBeR3ufiDK0YzvM4w71ou8qQL5oOx6lJvF5t
	/XWSR5GpdLoW9FdynvP9qBwzE5zWYREB6Qv7jS8v5RMMqy3XVUCSrrEHLHSnZcNQcdru0MAWysC
	CH/8RNRVNWYENm6/tkc0ccs0+yF7g85Qg=
X-Received: by 2002:a17:902:ea0c:b0:2ad:c66d:ad00 with SMTP id d9443c01a7336-2add13fbfe1mr20563975ad.50.1772017512011;
        Wed, 25 Feb 2026 03:05:12 -0800 (PST)
Received: from dw-tp.ibmuc.com ([203.81.242.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503f9f5sm138365975ad.77.2026.02.25.03.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 03:05:11 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Christophe Leroy <chleroy@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC v1 06/10] powerpc/64s: Kill the unused argument of exit_lazy_flush_tlb
Date: Wed, 25 Feb 2026 16:34:27 +0530
Message-ID: <9385e4fbc4bb99ba47ea6070fd82233e6576c228.1772013273.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772013273.git.ritesh.list@gmail.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2FDDA140019
X-Stat-Signature: dszrfctd9aecoayrhfj5xjaag9cxjrxz
X-Rspam-User: 
X-HE-Tag: 1772017512-829387
X-HE-Meta: U2FsdGVkX1/2Xf39uDoyVI2KHgHEfZ0AkBsOrT82nda7L1rprGfJjbXhSfQZ0v4mfgG1uMoK29ldH5IwjPc6zkk5fntsjyFbYAd4L5C0E7Ez2loT70UMAtaQfFG5ha9InOPyODYc14/ugsKXcGxWX6gptdHQ2IUTAwZ+1PqRwotHWX7EIpmn4TgV2Bmk6KvwjZ7+hHjnNjFSF9ahNeTkDbRL6Zf97VF3EW9oLkxSZIhbBjGWORD1DVeURwc5NyhV86g4BUT9//byxcPe4818SfZGF7r4Zjd3DRs/plzKJDWZcy/KRokof2OVtAAh2witrKQk8vjXPTC7Mtm60eIssbqlgGx0XYm66Xw7BsQOqENDLD447veHOidcQTYNDsCz2rC7uglYhQM1Hb6FQZEaltREJCRCcTaTMt8vxgQyBHrHwkKH3hQqkrp4f7AFuzUzjrMYcsOTlWYyqQ/yS94GEmXmjBgr1vpwD+GYNytmQgNiuzq9nU5cbN2LdwCa40oMeNvSB+K9gqChD8r/WsnWUpDHJkpF/9zTw5u95lf5bj+0yETKeXGOWyWH3hHAQoznXzlaA8G8hjBZlHw6+3doypvanmKbwYYiNZ/XK+G9iiTv2fSqnJ5p78gOm+MGaspTqpLfSAKKMBpmJ9PG9Z41DWNY7JdId2unAK9MofZaNYr/JOmRfR4ysn/ex1n9s4ff0AzJO7n1PGYZmf0X7oQMpLCsEo/MpWREsbAosAPXRr29vORePKaTJE3ASeO52dE5i4qT1lr32WXHebUKiZHgT1WF1eNkM7uFViqzYhf0UfYoYAH7XwnzuJDyalhG/oqyFAiitqOFuMwLXMSvUDvTpXLYTdBl9ll0WXROLUI/tS5yvP8pS51sFOClMh7v6yNVX0j/rAxdDiWI3GHHEQl0Z0s/pAxQHQReRoLGX567kmktg/KiWayRdsLeJNpDqtcU00xF4n4FpV/4ZZgA6o6
 qp8QzZTm
 LzpSimuW++XdQI4aElp8IiiS78FoEQXC+/l5+b+gQUPfxDz9XsEJ5yUVkZjEjzHJxdEd6ZzUzs38SJr1I1VXQgUjpd57ssu8BfnDQbWgJBZvpBPAjXK8ntWv1E89uWMmOPebBG8lWxPbYpB7WSxvmSwb18IYnyax9tQcb/BxzabtamrFD3QFmLS+A2havfmMfwf6p3twvvGL/LOss1iPr8TDs6yugXe4bU2DzaOpyV5FmwdpyWf9u3lZ5Ajl2pPC/YCzG0WOv43vTwDxxZJ57eK+MNj9AW/R9CRbg/TatBcJ2OwlB27me0yZmQwQf79pm1hWI+XlCfFG+mXbpaz0PSKpvEUXo/XKaL85QfdyDfDvN8ew8hytaNgG9ozS0BUP2yQ2L0k3rObhgwNMq9MWSA7lnDyK2QXWTkCLqMrgCuStDgg5YS8FLuZmovl8Mt8kFFm1EpZyUlcQa0bGFESMQfNQuROdfPFoOqqwIO8L5iOUspg7Od1BI44NiSKoAq0YwiSE9gBd8ojcJ1RNK8KtfYKQTFKbJaD3VXc4IoNMYn2VoJKGZj2/R9mmE3ndtoKeXsWOBMi3zaHxUyp08mBw+bcLKZTE73ilK4YQ0abTBMQZtNUq9QMUDaQZ6IqOFguuCFNJZ80ONl2wI13l2pFgHkNnmLu3JRCEM/TLSAYQACaGvBJptNRuqJ2xt9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In previous patch we removed the only caller of exit_lazy_flush_tlb()
which was passing always_flush = false in it's second argument.

With that gone, all the callers of exit_lazy_flush_tlb() are local to
radix_pgtable.c and there is no need of an additional argument.

This patch does the required cleanup. There should not be any
functionality change in this patch.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/mm/book3s64/internal.h  |  2 --
 arch/powerpc/mm/book3s64/pgtable.c   |  2 --
 arch/powerpc/mm/book3s64/radix_tlb.c | 14 +++++---------
 3 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/internal.h b/arch/powerpc/mm/book3s64/internal.h
index cad08d83369c..f7055251c8b7 100644
--- a/arch/powerpc/mm/book3s64/internal.h
+++ b/arch/powerpc/mm/book3s64/internal.h
@@ -31,6 +31,4 @@ static inline bool slb_preload_disabled(void)
 
 void hpt_do_stress(unsigned long ea, unsigned long hpte_group);
 
-void exit_lazy_flush_tlb(struct mm_struct *mm, bool always_flush);
-
 #endif /* ARCH_POWERPC_MM_BOOK3S64_INTERNAL_H */
diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index 84284dff650a..52d3e0c4a030 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -23,8 +23,6 @@
 #include <mm/mmu_decl.h>
 #include <trace/events/thp.h>
 
-#include "internal.h"
-
 struct mmu_psize_def mmu_psize_defs[MMU_PAGE_COUNT];
 EXPORT_SYMBOL_GPL(mmu_psize_defs);
 
diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
index 9e1f6558d026..339bd276840b 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -19,8 +19,6 @@
 #include <asm/cputhreads.h>
 #include <asm/plpar_wrappers.h>
 
-#include "internal.h"
-
 /*
  * tlbiel instruction for radix, set invalidation
  * i.e., r=1 and is=01 or is=10 or is=11
@@ -660,7 +658,7 @@ static bool mm_needs_flush_escalation(struct mm_struct *mm)
  * If always_flush is true, then flush even if this CPU can't be removed
  * from mm_cpumask.
  */
-void exit_lazy_flush_tlb(struct mm_struct *mm, bool always_flush)
+static void exit_lazy_flush_tlb(struct mm_struct *mm)
 {
 	unsigned long pid = mm->context.id;
 	int cpu = smp_processor_id();
@@ -703,19 +701,17 @@ void exit_lazy_flush_tlb(struct mm_struct *mm, bool always_flush)
 	if (cpumask_test_cpu(cpu, mm_cpumask(mm))) {
 		dec_mm_active_cpus(mm);
 		cpumask_clear_cpu(cpu, mm_cpumask(mm));
-		always_flush = true;
 	}
 
 out:
-	if (always_flush)
-		_tlbiel_pid(pid, RIC_FLUSH_ALL);
+	_tlbiel_pid(pid, RIC_FLUSH_ALL);
 }
 
 #ifdef CONFIG_SMP
 static void do_exit_flush_lazy_tlb(void *arg)
 {
 	struct mm_struct *mm = arg;
-	exit_lazy_flush_tlb(mm, true);
+	exit_lazy_flush_tlb(mm);
 }
 
 static void exit_flush_lazy_tlbs(struct mm_struct *mm)
@@ -777,7 +773,7 @@ static enum tlb_flush_type flush_type_needed(struct mm_struct *mm, bool fullmm)
 			 * to trim.
 			 */
 			if (tick_and_test_trim_clock()) {
-				exit_lazy_flush_tlb(mm, true);
+				exit_lazy_flush_tlb(mm);
 				return FLUSH_TYPE_NONE;
 			}
 		}
@@ -823,7 +819,7 @@ static enum tlb_flush_type flush_type_needed(struct mm_struct *mm, bool fullmm)
 		if (current->mm == mm)
 			return FLUSH_TYPE_LOCAL;
 		if (cpumask_test_cpu(cpu, mm_cpumask(mm)))
-			exit_lazy_flush_tlb(mm, true);
+			exit_lazy_flush_tlb(mm);
 		return FLUSH_TYPE_NONE;
 	}
 
-- 
2.53.0


