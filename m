Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A918AF436A7
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 13:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02F16B010B; Fri, 17 Apr 2026 09:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB4476B010D; Fri, 17 Apr 2026 09:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA28D6B010E; Fri, 17 Apr 2026 09:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A83456B010B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:58:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00028B6B47
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:58:16 +0000 (UTC)
X-FDA: 84668202192.01.F5C70E1
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 141E140011
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:58:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="I7Ktw/nG";
	spf=pass (imf27.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776434295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UF3dWetbHtPxfYtcnSagOqoa5vn49qeoBTi550pC/9w=;
	b=l3GUmqu5i/QelBmszQkpbvtPCWUZQM5VnG2nKNa4YSDtTz29Wi07wswwDTiCRit1OxUx8s
	czOJMzvixdW3iaUfDyRYtROw94XZvWl44P/syUhFuNuqitdK1Pk/gCfkeidZZCWlF6gCpG
	16krTcbu2EG955+t0hsPtjWKgvto/0Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="I7Ktw/nG";
	spf=pass (imf27.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776434295; a=rsa-sha256;
	cv=none;
	b=3p3Umn6dgoKlzOm81sDB/gt5AIBZibyRfcIA1N2FYiYva4qicklzwRUzpbxjnQdV2PdWj5
	MNonOtWrO6FSKya5O0BU1aSTS9+WLC+yzrZKqDPzNGDk8KekLZMuOpoypNwbQD7EeeAZQo
	RbGwqHzRD83HnnXaloINCEuBgxbgIyk=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c648bc907ebso453719a12.3
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776434294; x=1777039094; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UF3dWetbHtPxfYtcnSagOqoa5vn49qeoBTi550pC/9w=;
        b=I7Ktw/nG7lVD0VcYbnizCHVDPr/aKzNKGlWIGbQ1X9LtNa4RHCZiyTpuI2j4MV0WE9
         dTZ+nVMH/oqfPw1UsvGODPm4uwY+FpjJunzt/1MoS1KUIKGqigNshMBm49Te49EeekNl
         jrDHOziehBp6g4ErKbEt8Phx+BWuBuMmrf5p2d5pCYIoyTlrna6cjVyJjVihy25L2e9A
         v/MbjPfF7GfuQZKrWqgfOZAh1yVLP52qUkhmV7tVfQnvDdBcB5qOKcrH6tImJ4hPvH9m
         fNwGbKV2f2b/XyladAK5KpUeS3Uo5zgTr4RtARqF038UJpSuFRdc64DirO0B9ym8LT3y
         ahZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776434294; x=1777039094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UF3dWetbHtPxfYtcnSagOqoa5vn49qeoBTi550pC/9w=;
        b=bQDnzogiCBDU5McOKlPeDsqaT8KapVW1Kq/TVvQtXx8+jXeEngPu8zEIn6zNfoMIg0
         /a+usK/H9B4FfB1wUmRKnaNuFEBKHdUdyljMdc3OF1efMs27mys2gSAqJyqb5w5nZ/9/
         PcaZ6AebwCW9IuKopE2upTe4uaq7uGqJBvhC+Vw1UmlEjmjh6bul+sOV+7y06TtHKv7c
         5WfkeWp5TlXnlCIkUx1JpddJZ7dy+y3RmlsAMef7fjSoHukBFsJK1zTVqxwRKJFJLjD9
         3KjIciHfLh0EvuT21neFvbI1ZxYogQpU1/Xl2rBm22weCtAS07PpRFM2BiiJZMrQi3sr
         /bFQ==
X-Gm-Message-State: AOJu0Yykb8os0U3ZurZ1pHUccBIydO/vvJc9KIU20WcLPvPfyi9+6zfV
	sHglit0ebLCEOoBpYOy3QXGOXlbV/Z1JARDAhqqFpiFr4PEb9P10HeYQ
X-Gm-Gg: AeBDieuNoTtaBc9ZVaGdS2rYmW420Bx4r6/66GUGNrQTUZ2U7TY3hF99i2o5KlWrLcO
	v4p5Ji7B/qpqOxjsi2f7hvsJdfBjAw2pKb+6Z2uNsII5pyypBn0bzOOg770XtmTAxECHqq5vPUM
	qL54+JricoRjMeSBQ5M2v/P4avpV6I9wSOxrwX2F0CXURQnjJe9ybtbOGRaVjgNXf33UdA2JX24
	AUCQjMypmlScIECO2OFiAMiilBxhkHpAg3aJkGsqp4qhdYsKdF4jHnxBCgWBbFQhIY/Zf2PSGNw
	rEGiFuY2rTAnUGstUXGFiqA1jMTLHseEWytbxaL52PdIW5GOE67k2U/TmrVmUOcCW0LysWOraQO
	KFXED3X8W62CIfRUhHVEa4NG15X0P9jAWgzsdWSExJP92v+3+WrFlB+bw2rvUmgM96bl+cvjOGS
	b3tVtks6BSJLnMqkKGEz+g8WyNbhue
X-Received: by 2002:a05:6a00:3397:b0:82f:2243:e448 with SMTP id d2e1a72fcca58-82f8c83048fmr2942854b3a.3.1776434293468;
        Fri, 17 Apr 2026 06:58:13 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ebe41cfsm2273309b3a.43.2026.04.17.06.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 06:58:13 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	djbw@kernel.org,
	mingo@kernel.org
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Donghyeon Lee <asd142513@gmail.com>,
	Munhui Chae <mochae@student.42seoul.kr>
Subject: [PATCH v2] mm/fake-numa: fix under-allocation detection in uniform split
Date: Fri, 17 Apr 2026 22:58:05 +0900
Message-ID: <20260417135805.1758378-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 141E140011
X-Stat-Signature: 8ccfmjgihmoykrg5dm7ikyug8uzk63wc
X-Rspam-User: 
X-HE-Tag: 1776434294-301944
X-HE-Meta: U2FsdGVkX18TQUkzZu9R+LWKlQoP4Oxwil4xL0VsQjsVBRNBT3FMgIHkTcMjkRu0K+YQXiN1jUAQgmdROy1zPc8dAzljJtexW74hhJkLtBti2gTBsBc0QZIjKBBaiGbUCV5wm7i5Z7qSbOW6MbOkaRMxivZzOPJyGa87xEuKid7ZUhDBS4FQtlBM+jhke2yf7uVS3xtmKpta2KjMabCCmJwkkfAA0LiiZfsJHSLXGz9OEluzAnOKrFH6/NdIm2PnqX9cVk9MjYAN8CYd5kc/K4PICcQGxAcL0Nyw99c/wgz+FEcetn+nlR0Wf6SyzfJbs9xiO1rzw6Pr+SwAAicCBiq/vC0rFRXqjYblo/iq9L3P5boEcR3kw7ay61qXtsxZKJlHyTdrWpv/FtBi/ZOgMMbI8urUuMphGhnlGWGdb8uTHsHMJLzuaQjgaCIhyZARFwxvkCycZ+LuWOatS30oiQbX2T7sCczbKKR0vgYkCUZyBOty1IvtwyPAo9xNA16ZUCBhELEh2nK1hnfMe3k4bCcCuaOJh7brua/6Uc6llwD8ec5GEyBnIAKbaQk1DchlLWv11TLZkqeIk7BT+nlvHn7MPn0gNWpr9Z1KwUlmSet4xkR0xdh9KIW69kJeywMKfAnXT9X/ihOGn8DxWIdcOvGWiU2s5zttG6yecrofIaTz+CnY4JOYOLhZHOsz36+/JxcpAJqBlvKQuMANgUxYoeB5wEnfKfIk1kZSrdGCwgzMnJS0nlkdvUAHsJvNm7pbEhMwheMPGYr6oESMuF/yRuFPZHakGxwAH6BdU3NoudSc4lyXN+CR00k/tAHdAcJTAn2rVTmgs/RjmxXpnGZOJv1CzmnOM2jvP3DbBBzVjp2NoTem3zHB7rq1qZoTHwN2QkA6zbDQcVhOZ2klPZo+ntuao/VGv5vncLtwWYQ8Qij++3ta7wYWVOBUS/mFK9By7DapfJ+GbQRCM0i9DEw
 h/99USg7
 I08eRDF73tTNe+EoP6WaA+7BBfTfJ7PDTIczzO30FONNdIK2yx5iqLp1K+whFHj0wFTFOV8F9jy8GD9mcXxehHzNEQvMbn9v9kyACuCCFixo/QJRpI5TX0vG4ESokej6hteUhz36xeIXqSE6M+wFA6S5b6UjYFxE310+i04UyM8xjemFCgRmHuyPCVhVWnsj23TnlKpQ1tK5tO9gPAmYxMloyPtcsri1D6L/sI3p2Rk2AfHsHj2w4C69nnaP0LxE3N5SfQZ76bopAlU7Z+rNYQYGrXyB78HWw3QjRTA8I0QwGT4bKD6yUHd29TUYYofNt0eI20lhK9z7hNsAZHHeI2UFKIa9FZb3LlHzCRxrJ6d0yENYRT5ssREH288HBd2mnE0ZIHnBwxnW2+c0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When split NUMA node uniformly, split_nodes_size_interleave_uniform()
returns the next absolute node ID, not the number of nodes created.

The existing under-allocation detection logic compares next absolute node
ID (ret) and request count (n), which only works when nid starts at 0.

For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
1: 128MB) and numa=fake=8U, 8 fake nodes are successfully created from
node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
fake node nid starts at 8, but only 4 fake nodes are created due to
current FAKE_NODE_MIN_SIZE being 32MB, and
split_nodes_size_interleave_uniform() returns 12. By existing
under-allocation detection logic, "ret < n" (12 < 8) is false, so the
under-allocation will not be detected.

Fix under-allocation detection logic to compare the number of actually
created nodes (ret - nid) against the request count (n). Also skip
under-allocation detection logic for memoryless physical nodes where no
fake nodes are created.

Also, fix the outdated comment to match the actual return value.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reported-by: Donghyeon Lee <asd142513@gmail.com>
Reported-by: Munhui Chae <mochae@student.42seoul.kr>
Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capability") # 4.19
---
Changes from RFC v1 [1]
- Merge patchset into once.
- Change base from linux-next to mm-unstable

Changes from RFC v2 [2]
- Fix error message to use the number of created node instead of
  returned node ID.
- Define nr_created variable to explicitly show the number of created
  nodes.

Changes from v1 [1]
- Skip under-allocation check for memoryless node where no fake nodes
  are created.

[1] https://lore.kernel.org/all/20260413154438.396031-1-ekffu200098@gmail.com/
[2] https://lore.kernel.org/all/20260416102558.575210-1-ekffu200098@gmail.com/
[3] https://lore.kernel.org/all/20260417114127.1664283-1-ekffu200098@gmail.com/
---
QEMU-based test results

1) Check under-allocation is well detected (based on commit message
scenario)
  a) AS-IS (before fix)
[    0.001878] NUMA: Node 0 [mem 0x00001000-0x0009ffff] + [mem 0x00100000-0x7fffffff] ]
[    0.001881] Fake node size 255MB too small, increasing to 256MB
[    0.001882] Faking node 0 at [mem 0x0000000000001000-0x0000000010000fff] (256MB)
[    0.001883] Faking node 1 at [mem 0x0000000010001000-0x0000000020000fff] (256MB)
[    0.001883] Faking node 2 at [mem 0x0000000020001000-0x0000000030000fff] (256MB)
[    0.001884] Faking node 3 at [mem 0x0000000030001000-0x0000000040000fff] (256MB)
[    0.001884] Faking node 4 at [mem 0x0000000040001000-0x0000000050000fff] (256MB)
[    0.001884] Faking node 5 at [mem 0x0000000050001000-0x0000000060000fff] (256MB)
[    0.001885] Faking node 6 at [mem 0x0000000060001000-0x0000000070000fff] (256MB)
[    0.001885] Faking node 7 at [mem 0x0000000070001000-0x000000007fffffff] (255MB)
[    0.001885] Fake node size 15MB too small, increasing to 32MB
[    0.001886] Faking node 8 at [mem 0x0000000080000000-0x0000000081ffffff] (32MB)
[    0.001886] Faking node 9 at [mem 0x0000000082000000-0x0000000083ffffff] (32MB)
[    0.001887] Faking node 10 at [mem 0x0000000084000000-0x0000000087fdcfff] (63MB)
[    0.001924] NODE_DATA(0) allocated [mem 0x0fffd6c0-0x10000fff]
[    0.019852] NODE_DATA(1) allocated [mem 0x1fffd6c0-0x20000fff]
[    0.022458] NODE_DATA(2) allocated [mem 0x2dffc6c0-0x2dffffff]
[    0.023293] NODE_DATA(3) allocated [mem 0x3fffd6c0-0x40000fff]
[    0.028522] NODE_DATA(4) allocated [mem 0x4fffd6c0-0x50000fff]
[    0.032397] NODE_DATA(5) allocated [mem 0x5fffd6c0-0x60000fff]
[    0.036552] NODE_DATA(6) allocated [mem 0x6fffd6c0-0x70000fff]
[    0.038746] NODE_DATA(7) allocated [mem 0x7fffc6c0-0x7fffffff]
[    0.040286] NODE_DATA(8) allocated [mem 0x81ffc6c0-0x81ffffff]
[    0.041517] NODE_DATA(9) allocated [mem 0x83ffc6c0-0x83ffffff]
[    0.043678] NODE_DATA(10) allocated [mem 0x87fd86c0-0x87fdbfff]

  b) TO-BE (after fix)
[    0.001858] NUMA: Node 0 [mem 0x00001000-0x0009ffff] + [mem 0x00100000-0x7fffffff] ]
[    0.001860] Fake node size 255MB too small, increasing to 256MB
[    0.001861] Faking node 0 at [mem 0x0000000000001000-0x0000000010000fff] (256MB)
[    0.001861] Faking node 1 at [mem 0x0000000010001000-0x0000000020000fff] (256MB)
[    0.001862] Faking node 2 at [mem 0x0000000020001000-0x0000000030000fff] (256MB)
[    0.001862] Faking node 3 at [mem 0x0000000030001000-0x0000000040000fff] (256MB)
[    0.001863] Faking node 4 at [mem 0x0000000040001000-0x0000000050000fff] (256MB)
[    0.001863] Faking node 5 at [mem 0x0000000050001000-0x0000000060000fff] (256MB)
[    0.001863] Faking node 6 at [mem 0x0000000060001000-0x0000000070000fff] (256MB)
[    0.001864] Faking node 7 at [mem 0x0000000070001000-0x000000007fffffff] (255MB)
[    0.001864] Fake node size 15MB too small, increasing to 32MB
[    0.001864] Faking node 8 at [mem 0x0000000080000000-0x0000000081ffffff] (32MB)
[    0.001865] Faking node 9 at [mem 0x0000000082000000-0x0000000083ffffff] (32MB)
[    0.001865] Faking node 10 at [mem 0x0000000084000000-0x0000000087fdcfff] (63MB)
[    0.001866] numa_emulation: phys: 1 only got 3 of 8 nodes, failing
[    0.001867] NODE_DATA(0) allocated [mem 0x7fffc6c0-0x7fffffff]
[    0.001940] NODE_DATA(1) allocated [mem 0x87fd96c0-0x87fdcfff]

2) No false failure with memoryless node
- Node 0: 2GB, Node 1: memoryless
- numa=fake=2U

  a) AS-IS (before fix)
[    0.001843] NUMA: Node 0 [mem 0x00001000-0x0009ffff] + [mem 0x00100000-0x7ffdcfff] -> [mem 0x00001000-0x7ffdcfff]
[    0.001845] Fake node size 1023MB too small, increasing to 1024MB
[    0.001846] Faking node 0 at [mem 0x0000000000001000-0x0000000040000fff] (1024MB)
[    0.001846] Faking node 1 at [mem 0x0000000040001000-0x000000007ffdcfff] (1023MB)
[    0.001847] Fake node size 0MB too small, increasing to 32MB
[    0.001869] NODE_DATA(0) allocated [mem 0x3fffd6c0-0x40000fff]
[    0.002023] NODE_DATA(1) allocated [mem 0x7ffd86c0-0x7ffdbfff]

  b) TO-BE (after fix)
[    0.001862] NUMA: Node 0 [mem 0x00001000-0x0009ffff] + [mem 0x00100000-0x7ffdcfff] -> [mem 0x00001000-0x7ffdcfff]
[    0.001864] Fake node size 1023MB too small, increasing to 1024MB
[    0.001865] Faking node 0 at [mem 0x0000000000001000-0x0000000040000fff] (1024MB)
[    0.001866] Faking node 1 at [mem 0x0000000040001000-0x000000007ffdcfff] (1023MB)
[    0.001866] Fake node size 0MB too small, increasing to 32MB
[    0.001889] NODE_DATA(0) allocated [mem 0x3fffd6c0-0x40000fff]
[    0.002034] NODE_DATA(1) allocated [mem 0x7ffd86c0-0x7ffdbfff]

And also there is other scenario tested by Donghyeon. [1]

[1] https://lore.kernel.org/all/CAFPTC5e1OLpHa3HqwhtSPjS_PTQz+iG=ovM2cZ=VnOZ_5z7oxg@mail.gmail.com/

---

 mm/numa_emulation.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
index 703c8fa05048..5d72559fcdf2 100644
--- a/mm/numa_emulation.c
+++ b/mm/numa_emulation.c
@@ -214,7 +214,7 @@ static u64 uniform_size(u64 max_addr, u64 base, u64 hole, int nr_nodes)
  * Sets up fake nodes of `size' interleaved over physical nodes ranging from
  * `addr' to `max_addr'.
  *
- * Returns zero on success or negative on error.
+ * Returns absolute node ID on success or negative on error.
  */
 static int __init split_nodes_size_interleave_uniform(struct numa_meminfo *ei,
 					      struct numa_meminfo *pi,
@@ -398,7 +398,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	 */
 	if (strchr(emu_cmdline, 'U')) {
 		unsigned long n;
-		int nid = 0;
+		int nid = 0, nr_created;
 
 		n = simple_strtoul(emu_cmdline, &emu_cmdline, 0);
 		ret = -1;
@@ -416,9 +416,18 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 					n, &pi.blk[0], nid);
 			if (ret < 0)
 				break;
-			if (ret < n) {
+
+			/*
+			 * If no memory was found for this physical node,
+			 * skip the under-allocation check. 
+			 */
+			if (ret == nid)
+				continue;
+
+			nr_created = ret - nid;
+			if (nr_created < n) {
 				pr_info("%s: phys: %d only got %d of %ld nodes, failing\n",
-						__func__, i, ret, n);
+						__func__, i, nr_created, n);
 				ret = -1;
 				break;
 			}
-- 
2.43.0


