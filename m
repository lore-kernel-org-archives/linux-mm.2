Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7790BCA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 08:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F363E6B00B5; Tue, 19 Aug 2025 04:01:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6CC6B0106; Tue, 19 Aug 2025 04:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD59A6B0107; Tue, 19 Aug 2025 04:01:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C746B6B00B5
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:01:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74FDD1380B8
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:01:19 +0000 (UTC)
X-FDA: 83792761878.16.0192A35
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9152B4000C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:01:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755590477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=1AicBB0r8yeNJ3bXaHmABMtMcb1aAChoUbacMbHzHfc=;
	b=neDGYSouyN1H1B1X+It6HoWtTmVdPe6gkmpqoWemQ+bAF23+SEGwtUyTUD119uxwgefAp2
	/j8sgIjgbef7PkfgRFO+v+tXBIOokPu1pR6O/+azJ7zmQ3y4y4pXjcR0qygjVFRpfiyf8B
	fsKQxEvc+/MW8O6Xo5SuUfbgFceFEik=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755590477; a=rsa-sha256;
	cv=none;
	b=w+85A7UNBYXoKd1fjViLiazFN8rs2/PABSvIysMj5ox0u7mOmjgG7yCa4HPjTh6KwxpZfe
	pY/mnf16fhUT8p4wC/wuoeBsm1uV01rTl5vGYhhHRzZQ+ZREPepyUVU8W4xlRa11OoO2Gx
	zknOWfo9RqGayB6/8wJYhB6I/JdYQGo=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c5hk73CTwz2CgJd;
	Tue, 19 Aug 2025 15:56:47 +0800 (CST)
Received: from kwepemo100001.china.huawei.com (unknown [7.202.195.173])
	by mail.maildlp.com (Postfix) with ESMTPS id B15DB1400D4;
	Tue, 19 Aug 2025 16:01:09 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemo100001.china.huawei.com
 (7.202.195.173) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 19 Aug
 2025 16:01:08 +0800
From: Yin Tirui <yintirui@huawei.com>
To: <robh@kernel.org>, <saravanak@google.com>, <dan.j.williams@intel.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <rppt@kernel.org>,
	<Jonathan.Cameron@huawei.com>, <devicetree@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>,
	<yintirui@huawei.com>
Subject: [PATCH v3] of_numa: fix uninitialized memory nodes causing kernel panic
Date: Tue, 19 Aug 2025 15:55:10 +0800
Message-ID: <20250819075510.2079961-1-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemo100001.china.huawei.com (7.202.195.173)
X-Rspamd-Queue-Id: 9152B4000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: p3am8scjezo34m7f3h8ky5qecjue67rw
X-HE-Tag: 1755590475-137106
X-HE-Meta: U2FsdGVkX18KopzfS7xOfD3uKh52ZRQXuen+/hFPLW4EDRBOd4WYhSBIZchRto8cUmmcyWuuG4cv0BWWPvzdYEzbQlbScsstIUwz6y+SaMwQSwyRNrLtnKRS+LJLtkc/Btj/pgsvYceFIpn7LxX2UbeQ/t9rZoBQBxkDmtjNbPTyUhzYmsugm0p7kY0P8LJfTwoeo/2+QvDQtZg6cs07MdatJvDXXFt5dDCDJiisbWazHxb3/fqCNEQVEDp38CzjU2S4Pbsw5sJuTOwVezuBxzbpku04Y4n5k+raZoitOSAeR2ksJXZ3HkwAJ+LAd+nRgs8wvwc0YMLBRehWpyk+JEL7dWxlWqD3YRvS6rZcywPpFnEVmVR3AZNmJ1CS5N0ZTDApYkfUhLpiS6XbZQ7A0FejJDYwQ/qD5yEhyLl9sHAnWccgd43YsW66XuN0NfU97tgznY0HSEMACR3S7oUV8Hp9Dfii4Di75pQW8I1X085fOOJzQEKINFSkgZxksJq0vrr9ijY8dIU3jHUoSnFvxerHuv2MTFdYX8rdS0+oGdvWIMeTF5PWvzXoFW1q80gy1/Iq97TevgJMhMqtmrZopgwn18mVvbN14nBwpPLj2rpl3tVYszY2gWTb76qmnXGJ6dO1VjkojGYfvlYAzN00ov1FtpQ3PPVj3gqIbuTWU0w/j+Cf37X+GTKYaUdy/XJPiU3g+qVJ5WuJ+Sb+SvulZcAifUSyje7/VvyKEoEf0EgrSICCqz1XMq4nsolKqo5nMEUOBWROeKAh+grkjdQxRSOy4qlfjQ5b6/jLmso+ER0afQ7Ev8ya1ehi63+RjLYfkTscj4x06KOTFSsXbNrM4xqrPbTsMN/nId8r+ItIbDhI2M/5Ip2KwIiX2pLqtViwhHSLEwlfillCxYOr448KQETGlS2c9YTvZgzpQ2XSmtkqtVqcOjlnx+25Mfqktg0bUuLz8jtA98l+4XCDTXu
 bjF17ZZg
 rmAKE6g10b3cXzBipdizbsBZYaIgGUYMCmy+BJXN17EI+VVCEeKkZRit8ZXuzwmbwvozxqg+Z3/3zcpw9FFLceXBaMDahvoJmgqCDktLz8McCEKj3WiYR/+1m8jQA7OQJENEsGYiain+aKPlN1WxoJsHBSmidX21MdeZ+eQi+sxMcx9sr0d9fFu7Ir/qk5+I+l0gukiBpVRHEWUI0aTeVdsW1d1QQpAubjC22oG/WWEub9LTpCGW8VFAz92u6GVlvA+xs/bTWwBxllBr42XRuHRqai+fa6PqmT2Wp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When there are memory-only nodes (nodes without CPUs), these nodes
are not properly initialized, causing kernel panic during boot.

of_numa_init
	of_numa_parse_cpu_nodes
		node_set(nid, numa_nodes_parsed);
	of_numa_parse_memory_nodes

In of_numa_parse_cpu_nodes, numa_nodes_parsed gets updated only for
nodes containing CPUs. Memory-only nodes should have been updated in
of_numa_parse_memory_nodes, but they weren't.

Subsequently, when free_area_init() attempts to access NODE_DATA()
for these uninitialized memory nodes, the kernel panics due to NULL
pointer dereference.

This can be reproduced on ARM64 QEMU with 1 CPU and 2 memory nodes:

qemu-system-aarch64 \
-cpu host -nographic \
-m 4G -smp 1 \
-machine virt,accel=kvm,gic-version=3,iommu=smmuv3 \
-object memory-backend-ram,size=2G,id=mem0 \
-object memory-backend-ram,size=2G,id=mem1 \
-numa node,nodeid=0,memdev=mem0 \
-numa node,nodeid=1,memdev=mem1 \
-kernel $IMAGE \
-hda $DISK \
-append "console=ttyAMA0 root=/dev/vda rw earlycon"

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x481fd010]
[    0.000000] Linux version 6.17.0-rc1-00001-gabb4b3daf18c-dirty (yintirui@local) (gcc (GCC) 12.3.1, GNU ld (GNU Binutils) 2.41) #52 SMP PREEMPT Mon Aug 18 09:49:40 CST 2025
[    0.000000] KASLR enabled
[    0.000000] random: crng init done
[    0.000000] Machine model: linux,dummy-virt
[    0.000000] efi: UEFI not found.
[    0.000000] earlycon: pl11 at MMIO 0x0000000009000000 (options '')
[    0.000000] printk: legacy bootconsole [pl11] enabled
[    0.000000] OF: reserved mem: Reserved memory: No reserved-memory node in the DT
[    0.000000] NODE_DATA(0) allocated [mem 0xbfffd9c0-0xbfffffff]
[    0.000000] node 1 must be removed before remove section 23
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000040000000-0x00000000ffffffff]
[    0.000000]   DMA32    empty
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000013fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000040000000-0x00000000bfffffff]
[    0.000000]   node   1: [mem 0x00000000c0000000-0x000000013fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000040000000-0x00000000bfffffff]
[    0.000000] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000a0
[    0.000000] Mem abort info:
[    0.000000]   ESR = 0x0000000096000004
[    0.000000]   EC = 0x25: DABT (current EL), IL = 32 bits
[    0.000000]   SET = 0, FnV = 0
[    0.000000]   EA = 0, S1PTW = 0
[    0.000000]   FSC = 0x04: level 0 translation fault
[    0.000000] Data abort info:
[    0.000000]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[    0.000000]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    0.000000]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    0.000000] [00000000000000a0] user address but active_mm is swapper
[    0.000000] Internal error: Oops: 0000000096000004 [#1]  SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.17.0-rc1-00001-g760c6dabf762-dirty #54 PREEMPT
[    0.000000] Hardware name: linux,dummy-virt (DT)
[    0.000000] pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.000000] pc : free_area_init+0x50c/0xf9c
[    0.000000] lr : free_area_init+0x5c0/0xf9c
[    0.000000] sp : ffffa02ca0f33c00
[    0.000000] x29: ffffa02ca0f33cb0 x28: 0000000000000000 x27: 0000000000000000
[    0.000000] x26: 4ec4ec4ec4ec4ec5 x25: 00000000000c0000 x24: 00000000000c0000
[    0.000000] x23: 0000000000040000 x22: 0000000000000000 x21: ffffa02ca0f3b368
[    0.000000] x20: ffffa02ca14c7b98 x19: 0000000000000000 x18: 0000000000000002
[    0.000000] x17: 000000000000cacc x16: 0000000000000001 x15: 0000000000000001
[    0.000000] x14: 0000000080000000 x13: 0000000000000018 x12: 0000000000000002
[    0.000000] x11: ffffa02ca0fd4f00 x10: ffffa02ca14bab20 x9 : ffffa02ca14bab38
[    0.000000] x8 : 00000000000c0000 x7 : 0000000000000001 x6 : 0000000000000002
[    0.000000] x5 : 0000000140000000 x4 : ffffa02ca0f33c90 x3 : ffffa02ca0f33ca0
[    0.000000] x2 : ffffa02ca0f33c98 x1 : 0000000080000000 x0 : 0000000000000001
[    0.000000] Call trace:
[    0.000000]  free_area_init+0x50c/0xf9c (P)
[    0.000000]  bootmem_init+0x110/0x1dc
[    0.000000]  setup_arch+0x278/0x60c
[    0.000000]  start_kernel+0x70/0x748
[    0.000000]  __primary_switched+0x88/0x90
[    0.000000] Code: d503201f b98093e0 52800016 f8607a93 (f9405260)
[    0.000000] ---[ end trace 0000000000000000 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---

v2: Move the changes to the of_numa related. Correct the fixes tag.
v3: Only amend commit message with no code changes.

Cc: stable@vger.kernel.org
Fixes: 767507654c22 ("arch_numa: switch over to numa_memblks")
Signed-off-by: Yin Tirui <yintirui@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 drivers/of/of_numa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/of/of_numa.c b/drivers/of/of_numa.c
index 230d5f628c1b..cd2dc8e825c9 100644
--- a/drivers/of/of_numa.c
+++ b/drivers/of/of_numa.c
@@ -59,8 +59,11 @@ static int __init of_numa_parse_memory_nodes(void)
 			r = -EINVAL;
 		}
 
-		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++)
+		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++) {
 			r = numa_add_memblk(nid, rsrc.start, rsrc.end + 1);
+			if (!r)
+				node_set(nid, numa_nodes_parsed);
+		}
 
 		if (!i || r) {
 			of_node_put(np);
-- 
2.43.0


