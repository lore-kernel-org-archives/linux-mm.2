Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA63DCD3427
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 13:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BBF06B0095; Sun, 10 May 2026 09:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2454A6B0096; Sun, 10 May 2026 09:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BEC76B0098; Sun, 10 May 2026 09:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2A476B0095
	for <linux-mm@kvack.org>; Sun, 10 May 2026 09:56:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A16798B79A
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:09 +0000 (UTC)
X-FDA: 84751659258.10.353C1B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0657D140005
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LJiJvlCO;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778421368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oYQg80jfs4dVKny3Jv20SVkaW3szq4o6Hl1VCjUCkFQ=;
	b=6Gtnr5VnEasXVoRgek/15rcjPxLPTz5jf00UzY33jxNDNjsU7JqePTDtUQ6YcUbE2MNOUV
	JGSuRF0FFhecVByOw5tN0GblZSeSYglhfERbzdNNVgQsp4fv+KPE8y8xCwDDBaXx3etnD1
	acVxJYxYMc16pcbO6CmpDxRFUyyuKHE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LJiJvlCO;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778421368; a=rsa-sha256;
	cv=none;
	b=zw4bQxCJDQLA80f4Tjx7E08/MHVcGvvTjP+GMAb/q3ALyTBRhkBSo4WGyFPM4O+M8sM61V
	BYWkJsDXnDwsj9RyKiz2BjXjZYzfnUzAqCZQQM4f/LnDiwqtoNkq42vYmtsz9Gr+PZNAXD
	ZugYRYSzBNfcKhyaIAIQDosL3s6ptCI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 915F060145;
	Sun, 10 May 2026 13:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1742C2BCB8;
	Sun, 10 May 2026 13:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778421367;
	bh=dCoYxGOmCvzNhzjVc8kfAvk/FtIfCDilY+5h2I/R/so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJiJvlCO8M1yDT6WaVcgoIJeHuqMRPpPOUmfiaZrdRiTsYe+YX2GCCv4d1fpVG8GY
	 kjiiB0csgEuGBHXDVfwnizB5RZdeUb+8gXF34ze5wqBpvOZBojAKWJea/7UdakW05V
	 iJ5PTNxuJ2apxYWH+tPz2kYr3xcgufwqPnuYV3N7Zuf2QrPSpTqEhApom3cKSlFUi4
	 IMRgeOOjjhOiU1TMigmEaDREIRrciAuxNDVIzL/cf+/mgjFL+F4gmG6ZSlZtVN0v3I
	 QeKxKII98zvcZsikSgqaZFIVJZBiUWh8bNUyDbLUQB1BsNJujk8unyWBNnJSk3cX0y
	 tLfpWxvPZnzvA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-sh@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Mike Rapoport <rppt@kernel.org>,
	Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 05/10] sh: drop dead code guarded by #ifdef CONFIG_NUMA
Date: Sun, 10 May 2026 16:55:41 +0300
Message-ID: <20260510135546.13554-6-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260510135546.13554-1-rppt@kernel.org>
References: <20260510135546.13554-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0657D140005
X-Stat-Signature: 9mumcfjcprthe1gqbm3jubmo4h5q541t
X-HE-Tag: 1778421367-632913
X-HE-Meta: U2FsdGVkX1/J42TfNSSZzaHUAK7R07wlRn5KwtKmfYs4VPD9JG6+SaaY9TjBEcaDiqXjllxNGWUFp1XE33vn5dXiB5hkpWVGS2gLPTyFazTk0kKDKU3oftwcixNVpVfHZJJ3710Cr2kb7t5ZpM2iQjOjn5uylxwWEiD+rtE30HEzF0zy/VaoNsuwqH+URoC874jBoAZL80kP3jJCZmU1+cQax83pJ1Z1golFiuS+NzkSr4NzQZAMFU7JaMlAx/dACOCNJvHMwlcXOycmI9V5gSEGe/Zju3SpKZdTFkg4Me7s0zikPhy0RjRKUat0jIaenwnXLJS8HI003qYn1318QZOz7u4fRrPgcjJkRWL2fjeJ9Hkx86pEG+xl7Dd5CwQPd7fTCSIe+9LU6WKS3H/OvfYkJKhrSMYu4OS+JCyKdYQWrjXwpNsdTbZ8/md2uYWEhy/sNy6ZVxeLHVDrCNTUnsSxufCrwRDKxAOYOg2ZvNPjzVaX7HnFLAYoiEvAb7WZaPeRxYMhAQeKvb6Igt5fDWAkX4LwADmLZtoP85PKRJQe6FWXMMXElE4zxMG+iskh1jD3JCYgVWNcI0sxKvBU/zStG8/CoGPIGgurRADMJug+Qw8UaZAfiWsRphW2u2qWnm2YTl34kKaFFbGrJqhlovmFebALsK61xC4/Z/xFw4vhdxZXvTZ9zs2n2JVnFStnWWVyESyW/o1JoVrad6PBu67EVtcRZNK/FpQodwNMoxhcVov+TgYv6+C0K/jRIXen1aj0fAdujQYKEGm0yjPMYzZ+rAYKXXF6JUiPcbUli9xcEnDU+PTNSF1kxDa3X+GoKpV5b/EK2N9U+1dJhjMQhUmWnRHBpOInaoGPKdRQ04v6cC9HX9QkJUxCPvs3o3lTUFdAeOgPZUnjHTEEdueVO8VJqJL5jMdHrBdKxQZSmeq53Pj5KJ0Q0ggskvMYwXc2WqDkuG8ssJAKQDElXUL
 CTeLxjXL
 6Tfj02Twydh08iOk+J8YGQ9VW7JdlXlcuIxJr5bQyVeAN7kMjvEl6PSH8Yr3hZEBbIQPluUlyYiZmc254+5vIdnHOBnPbwoJWe/+p0/siBgjyUOpb7kJfOnFL9mK6mcZ1M1++bY5JieDfXdkoZ/w75s1ujZbCwVvuJAZLxH8DfrThT0h0Lc0xI5jdCyVVMd53g8oznAxHvcS/MkfPdemLpBQjbfXoxvZY652sKUU8FUe8pjqNPD5jB9QSBmPeAvaVik3SP/u7IxAxiY5G3FE4lSxwLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

and NUMA-related comments.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sh/include/asm/topology.h | 13 -------------
 arch/sh/kernel/setup.c         |  1 -
 arch/sh/kernel/topology.c      | 12 ------------
 arch/sh/kernel/vmcore_info.c   |  4 ----
 arch/sh/mm/sram.c              |  3 +--
 5 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
index 1db470e02456..a3c31754ba5f 100644
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -2,19 +2,6 @@
 #ifndef _ASM_SH_TOPOLOGY_H
 #define _ASM_SH_TOPOLOGY_H
 
-#ifdef CONFIG_NUMA
-
-#define cpu_to_node(cpu)	((void)(cpu),0)
-
-#define cpumask_of_node(node)	((void)node, cpu_online_mask)
-
-#define pcibus_to_node(bus)	((void)(bus), -1)
-#define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ? \
-					cpu_all_mask : \
-					cpumask_of_node(pcibus_to_node(bus)))
-
-#endif
-
 #define mc_capable()    (1)
 
 const struct cpumask *cpu_coregroup_mask(int cpu);
diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index 039a51291002..5e25c1db4d61 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -227,7 +227,6 @@ void __init __add_active_range(unsigned int nid, unsigned long start_pfn,
 	/*
 	 * Also make sure that there is a PMB mapping that covers this
 	 * range before we attempt to activate it, to avoid reset by MMU.
-	 * We can hit this path with NUMA or memory hot-add.
 	 */
 	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
 			 PAGE_KERNEL);
diff --git a/arch/sh/kernel/topology.c b/arch/sh/kernel/topology.c
index 2d2a7509b565..906b7b1d5443 100644
--- a/arch/sh/kernel/topology.c
+++ b/arch/sh/kernel/topology.c
@@ -57,18 +57,6 @@ static int __init topology_init(void)
 			       __func__, i, ret);
 	}
 
-#if defined(CONFIG_NUMA) && !defined(CONFIG_SMP)
-	/*
-	 * In the UP case, make sure the CPU association is still
-	 * registered under each node. Without this, sysfs fails
-	 * to make the connection between nodes other than node0
-	 * and cpu0.
-	 */
-	for_each_online_node(i)
-		if (i != numa_node_id())
-			register_cpu_under_node(raw_smp_processor_id(), i);
-#endif
-
 	return 0;
 }
 subsys_initcall(topology_init);
diff --git a/arch/sh/kernel/vmcore_info.c b/arch/sh/kernel/vmcore_info.c
index a244a204a1b1..9f029b4a7e63 100644
--- a/arch/sh/kernel/vmcore_info.c
+++ b/arch/sh/kernel/vmcore_info.c
@@ -5,10 +5,6 @@
 
 void arch_crash_save_vmcoreinfo(void)
 {
-#ifdef CONFIG_NUMA
-	VMCOREINFO_SYMBOL(node_data);
-	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
-#endif
 #ifdef CONFIG_X2TLB
 	VMCOREINFO_CONFIG(X2TLB);
 #endif
diff --git a/arch/sh/mm/sram.c b/arch/sh/mm/sram.c
index 2d8fa718d55e..208080f072df 100644
--- a/arch/sh/mm/sram.c
+++ b/arch/sh/mm/sram.c
@@ -16,8 +16,7 @@
  * This provides a standard SRAM pool for tiny memories that can be
  * added either by the CPU or the platform code. Typical SRAM sizes
  * to be inserted in to the pool will generally be less than the page
- * size, with anything more reasonably sized handled as a NUMA memory
- * node.
+ * size.
  */
 struct gen_pool *sram_pool;
 
-- 
2.53.0


