Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68EC2EBFD36
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3C306B0096; Mon, 13 Apr 2026 06:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5536B0098; Mon, 13 Apr 2026 06:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8D316B0099; Mon, 13 Apr 2026 06:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A3C496B0096
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:47:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72AF0B3BF3
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:11 +0000 (UTC)
X-FDA: 84653205462.26.3FEE510
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B1D6C140004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HbANjlCY;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776077229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=roSFcth0MVdyhAOreEG3imiqRCawxMqxK27HS8tvlp8=;
	b=VyiaKg1vKd9wGo9o484E5q25x9CBAuoCdB4N08P/1QWuMDakXfmnsOXiFZgFN2zqHY1PPV
	qj1XUisItcBh11g1FYuIqUPTQ26mYBsWk4/vxf4FtTYrKbHYeVvUJNn3RU+UFXh+2H3KnM
	Dx1/5B2BoNPkfJwQ+CXN+gu97wrciNo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776077229; a=rsa-sha256;
	cv=none;
	b=1L6+iDdnuR0GvwkSXmyytPHU6AhRciYgA6nuDxzfwGyX+KF6J64wL/YkGTbKIs9S/IQw0q
	Q8ad7/3dcsOm4quP1b7ZG0pqJTrcjanIfN50QSOjvu4mVw7XHp0X+dEh/l6bxuJ/SRRXlM
	T/J2iKiZqeyDOuAbR0Jn2KNbIVvMti0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HbANjlCY;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA5FC4408D;
	Mon, 13 Apr 2026 10:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB19C116C6;
	Mon, 13 Apr 2026 10:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776077228;
	bh=s7r2AbNfz/44Y9KLQIIK4MPue07uMssbFF3qS8Ac9vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbANjlCYWuaIObr2nBGm6gDpN+vTZPeEExjqyHfjgVMPVN7tXqxCXqz4mAxYN51jy
	 ZwW+iLCrUHnh353cS1F+l9IgskuTGHPX/xzJNPx5oWGA6Q0OkfMcGq2h021w7AztXy
	 h22iJijQmy3M8IZUKeuHMhYQzr38OtSDfABJA+yBREVg6Z8TxFx3tAAh6CXyE7QN16
	 b3cPY9mufVGAtjEAiQYW8iwJ68UwQri99kd9kFSbUGpeVDYllSFvT1e46P1aCnuCKF
	 PfZ5PoD/DsthEJkNVqYzQoT6tN2Bz3UDWNQagAgyFK0+2JajO+4+IDJbCAPW4Ao9p5
	 9VBTeUnueySpw==
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
Subject: [PATCH 05/10] sh: drop dead code guarded by #ifdef CONFIG_NUMA
Date: Mon, 13 Apr 2026 13:46:43 +0300
Message-ID: <20260413104649.852228-6-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413104649.852228-1-rppt@kernel.org>
References: <20260413104649.852228-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: mbp9yz4c78iwdezcp5nbf9i7zajhxubf
X-Rspamd-Queue-Id: B1D6C140004
X-Rspam-User: 
X-HE-Tag: 1776077229-817288
X-HE-Meta: U2FsdGVkX1/domR01+HlUTBjxF3EEoCCxiuYxxvGPbGuIdtBZJ8c0Fy50WZlA4E33Jk/AAo20AVaGL2/gpzb+v+9wjI+Yfxhl2b2Yy526nSgEYko8qiqsVdAoUvgz4KKyvqzM+HHfUahYxL3op/1Ql+d98zB5gaTnuQTVvF/Fhk850GixCsEhOMcp1GN9MewYGSnP/udvs4yK/Z7aL2OITeaM6wcsdvXxPzUAuDq592ZONBrWXJKxAjzf/O4WCsc+TdNfT0K1yQBB8xnz7UrWPX8x2lK7YslLjxr44vWi/WemIj3gadK/bKz6aOipNvI8LCjH+b705aw5QG/Aq4mpBaTsxNL4eecd2Kqm3vqHi25sejEsrvxw3Muj7LZTUCWVlZVGTGw+ndadCd9zu9k48gRU/KW+scQoW8E+qoR9UJ/ry00vNxToVFz3EFkzADH2NbVLENV5v+a8ADde60lbPToh+qmNAPXN+6smD3veFPTCXZ0t6yXz2DaTUOsE1YsbY+4tuziQGtAg2unb7R8Cbs4bBIl2062DOGLth+NM72GIKb4KKm1x09jaA6NFt2W/WlVQRqWnvABhrSCpbVo3xt/dEdD8yW950YQ1p9Xbx6ZQwDZFEgA10sCWi3F7B02jj+rBpkqyE6T2AsFsrmTbVJC4lUTSri+nqiKIYa7jUc/z/ePJkHmk2uQXFJ6kPS7fK182dTN7fjWE800qWnkhPZEG4vpYVtgRXGizDwVyCHJGQXC92P/skYJvgKePwfLlRJ6jukRWlYY5SCerj7ufn6uULQvpVQN0+HDInO+b/9+wUbW7fR9y3vtTLZQpWx2fPJIqkwnL9hh+h5qXnZqwLFcYN0C9c0C3CFtcB2epLyYYpLae6oaxWPNwRXSGhaGFEiobMC/llXpNZmhRWfJGVIwMCEV5E6VwzFP/yxtLbbT2JN78nPP+8y1TYEks4PJ9e4rUfb9wpA2Kv5EWGu
 kEeGMknA
 SILhYzg1lvRuWAVFW02iXcQmOmATCa3iBdygjZtHT/p3MeGLqaUZf5B14CAcKm9RhqY6EuhyYacn8lJNCXFSVmODr7UgslbAuUD6AXUOE63EuRG6j6SBHOF/ToURpkFveMkWpqt/qye0579SJyBSwkedzu0F+qDuuW3KoDXE5Lpira40YOApqDpRCM36pYowVUJx34sQrn6IsMyUsWoqykrorXi00tjKDVZB2WUo/aKoHXgCaQmfAUEJ3INVObG7dBACDr2Io96mZKo6Jf6sw4ftm/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

and NUMA-related comments.

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


