Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22300F4368A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 11:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF5566B00E0; Fri, 17 Apr 2026 07:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5CD6B00E1; Fri, 17 Apr 2026 07:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D94BF6B00E2; Fri, 17 Apr 2026 07:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C81726B00E0
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:41:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 769CE1A013F
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:41:43 +0000 (UTC)
X-FDA: 84667858086.05.C8E416C
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id B53DD1C0007
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:41:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HyR4gEWP;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776426101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OdeoWNWt+4g6huyrHmNx4JleFuC8aky8d5HWmA1wp+I=;
	b=FH0muwvieJRNoAAjtdIdZcP/qa+XH+sCuGO3B2JlfAwWPeLSJsZ7u36TJZr9+B3BHV9vun
	5AdtR2tsfSKKT4O7PnnUhiP123yGP9GKqBa374E38/Z0tw86YR8po1ndMOV0BecXMoZDLO
	LVpLMoxDFzbLsnkAQIRy/RuEOb2lPvk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776426101; a=rsa-sha256;
	cv=none;
	b=SeXLFc16Wo1JKS+HYCOapno+46oMHWEInyj1qbQGVABrOYS4eVwKpR00H3omnD/3Dzq6cO
	CkAxQKfvOxohPcmbA0PPxiJWNbyw08URBXXBGAzij5QpmaM+ttXIBUy3EPdydCJaJ1AaDl
	pYwxgpDGHUI8JmySQ/VWejlkBdgOZz0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HyR4gEWP;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ad9516a653so2793025ad.0
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776426100; x=1777030900; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OdeoWNWt+4g6huyrHmNx4JleFuC8aky8d5HWmA1wp+I=;
        b=HyR4gEWP0fDIT1hXmZPJYPhvy6uhG7GFo4/7nsD4a/ZWOSQqTvd8VLXZ5FsDPhMOV4
         Mtrz0KH4Hs27aaPf+vo5hk1ZLKHRnwE6fhaq9vOwRchQjqZbhBUVEKFJinWd1oCHjFwp
         5eKvGfZ+3fS8XVD4F1tUPgfjUCsf0HaYj7G0z0VWf+drkoyjgNKxLNDApLMBis7WXwtW
         bXAZPJAeflmmtiOqj5oX85lDomUzFf/36o5AQV3XXjmTt+mRLzrEUHot20FJtNQu07D+
         FBjdbRXVfrGD9ELyLhV19Sg6fkWEmC3YunKOD9quE5m4K6Nc8hlWRlmihpA0LR3s5Ao6
         BrwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776426100; x=1777030900;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OdeoWNWt+4g6huyrHmNx4JleFuC8aky8d5HWmA1wp+I=;
        b=jugEjS8nZ4jjNsI40xFK4B66x0JmG3rnte0vh02gTsM63Kmq4TYvNEax8a9PqB2edx
         3P5t7Ytj9JXjVEUTitlVE9RtQxQPTk1mmxORYc0IRNakg+pzVCFHq+zi+2ncU7s257ME
         S7zLRPF6Hj8h1hr24b9qyh3EgC9gPqtQowMpkYK0SbLMbQYFJt4K/GR6pa/UK5LT8pvZ
         Qf5omXrheHu6uOZ8v+8sjR063DbHh7z5kRrWyNQX8QbYGngRfwmrlV569MBUWvtsgpYy
         40hqwkdzJbX/c+EmsPC0yBtuukGXli0V2AZ7VBpnThbM2TdB/85Ebb65+kCdMum/zS+4
         X18g==
X-Gm-Message-State: AOJu0Yz7tq8gIKFmnYRcmCW6ttjtYJY+XGc4fkV3g8Xpne1EsQslPi8U
	ME2XYAjPLOXVUom8V6bCf6zgQfOyKPG6QTQRXTM9XiycQu1QwnFAbjeV
X-Gm-Gg: AeBDievcNn4TfAbzzM0opKKtlKJ6hWS0mtYIUzV5kQgNlGQH/iJePaGvO8xEjBUfW3v
	gIbfGtuuTuiuF/DEilP1j5kpkEWrQ/U9HDkcQfQnoJ/pcc32jML5xT/hjCnRM0wQ3AldxM3fFuf
	0uWnjfy8Ix7b77eJfpu+Il34kazAWFnF6m9DUMMuE7RwbLvV4X9vxL/+sbV674XvX2RIK21Biqe
	WqC/ire6di2Vs30ED4FGxkgmWaU8gy41M22oq2V/ShWTQXX/YapLMXWWAp6zvydJKwLZAJPnqBi
	CEwzmW4oKINsPSCgZKupKHicBPhjm+QT+SAhT56nDMV08AqK3j6iwMsE3iQz++AQ007XSfVcssH
	k69IAdciWIB1bYQAurPf2Mx7AX4Z+T7A5lw2379Yf1vPjScY26VdHII16UyJFHP41fy9cnaGqt1
	fscM741dUX8+eYFJ5UEZ4bDnmk+4DLsmh5hrLb9Vs=
X-Received: by 2002:a17:903:38c4:b0:2b0:6d56:8d29 with SMTP id d9443c01a7336-2b5f9f3b3edmr30511555ad.32.1776426100380;
        Fri, 17 Apr 2026 04:41:40 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab3a929sm17355605ad.72.2026.04.17.04.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 04:41:39 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	djbw@kernel.org,
	mingo@kernel.org
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Donghyeon Lee <asd142513@gmail.com>,
	Munhui Chae <mochae@student.42seoul.kr>
Subject: [PATCH] mm/fake-numa: fix under-allocation detection in uniform split
Date: Fri, 17 Apr 2026 20:41:26 +0900
Message-ID: <20260417114127.1664283-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: egzyoa5g73codcoiirkr1dfph9pekmzu
X-Rspam-User: 
X-Rspamd-Queue-Id: B53DD1C0007
X-Rspamd-Server: rspam05
X-HE-Tag: 1776426101-139595
X-HE-Meta: U2FsdGVkX18LwIvJ4HU/CNLoGONVvT1YxxnqBgOtWCcXrk+j0M+T1TEV8bB49HX6bY2OvPfZMvmQIosFVUZZoKzdOZfDfaj+P3oFPOtgiBZG0PtCAxxeJFpKAzm2Bk1/xmIsH435WWxtzDF+yHqUcJNPTLeH34As1KaY6JMvZ3RsPQr7NxZzng5zJd9UlQbgQg5B0GK1CPpFBL5R/naiM5hA3fzIcAYZbm+T1eYmKxmRN/8B+FqLm0HUVNF+5pWGiQYz9WHaDUxIU2DIzGbdnvuYV1RShuEs3BNqPJFg1pgtfb9v6qmhn1p6ueInLm6haLxLx6hFpJLfCbvTbPaWVLWV+3ru3TI8yTsEfBDn6r4rLHkh+N5Bir99uPZBxlwrO3pj+1i4jaOTFApQxTACaiqwdElavuRaAcCnQWo/qb879wb34dBrvlIwx3HWQf/A0rXy4ArF3NP5JITS9NwAYx/XopZAd/OT0Akf4G+/CBDs0R6wilBXX4gQ9LtgacPwENtKG2b+0466O8c3/w1BYNlf2duR4sz2i44lcKXpbQrFFBKzw41koxknosV5wZIwSKqu5dmbMEgF3UG1R0PviPikz2eoCvf7/Nu7A2xZkkwurPpFmh+YF7MeIzurAozO6uSkpLakcAusCuZmMk+2GJ6aH4/mA5YV2HXx+ExWlVq4BF1fUwAog3WqsZIu1TsdpUSyuyrgjZmhdKFdsBPWEyai3kt0kw6+HpOUBGlJOL7Y4RrbtWOH46vm124ibFX1X34oMwmwSayFfRoYBFZhkH/Cwr0vcWORStHlzwHupL2jAlnD9DFrYMXXFgJ/tl5Mv6CfehIvC9DdzaPXkq4W9YJyayn9qnUTNa4SKWwsj7JjAnMWNxPvWNHEFPEHeWhWEwBl9suYch1Oli6r9ktIR/lxp7oSmk9acOJ9xb2m0VBHHJBT5yweFOSCzztIAC9B3qWlsfbowTRxWBiCkPy
 VZ0fiXV4
 zCPy7XjCVecbWwUlNSFSKKr+NEfgrRI1cU7kK4PxcVj+Ecd8n2sdUIAIU/rEzVGdnkhVpmR9IVGV5V9hIpsqZawEn3vqrVklpqsg7mstsogQwhfuE8A3EAJM1zQqWY2DjxpvN4QjBlkPV9MeVxEmrDyRqitOOayvuX0TQ0gH7lJnrt33Nt5/4j9l7rBGJfPRNQnqMPZVdVFozkeep06LGFM1GIUGtopCbjOC6eY9Kk/xWCWl44Nb0DjzCv9osxQdQIbxAB6pTDaLnPBwipH8uqMwOwPSwX6WaKNEUoa9QpB0U1njsSSFbq3uvY/QV3rIQyAkm82wj4GYmj3EAsNrvafrf3iXSo0zBub13zRFKmQJGlRnu4WovU5VJTGPBSIvqy/3or9cSvPMfOMPSW8SdpOJ99F4ru3VIovdFClR1INWWCsvXnbZj63p+mw==
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
created nodes (ret - nid) against the request count (n).

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
  noeds.

[1] https://lore.kernel.org/all/20260413154438.396031-1-ekffu200098@gmail.com/
[2] https://lore.kernel.org/all/20260416102558.575210-1-ekffu200098@gmail.com/
---
QEMU-based test results for the commit message scenario.

1) AS-IS (before fix)
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

2) TO-BE (after fix)
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

And also there is other scenario tested by Donghyeon. [1]

[1] https://lore.kernel.org/all/CAFPTC5e1OLpHa3HqwhtSPjS_PTQz+iG=ovM2cZ=VnOZ_5z7oxg@mail.gmail.com/

---
 mm/numa_emulation.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
index 703c8fa05048..bc2f163e7c45 100644
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
@@ -416,9 +416,11 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 					n, &pi.blk[0], nid);
 			if (ret < 0)
 				break;
-			if (ret < n) {
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


