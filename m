Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72B75C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4C86B0088; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E176B009B; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AABE26B0088; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4C96B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:39:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E06E1206D4
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:39:09 +0000 (UTC)
X-FDA: 85219429218.17.BFB8F42
Received: from danaos.cslab.ece.ntua.gr (danaos.cslab.ece.ntua.gr [147.102.3.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id B295D2000C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:39:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=GCr8XKiJ;
	spf=pass (imf03.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789558747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gIZXFCPBow2SEBpxYeI2wup92NeyZieu1jGMV5pE5bA=;
	b=J6IkLfpQXFHx83yWgn36RUG/cy8ZDI8FVwN7WqPAFWMLrS/svFyKEZxqMgNK/s+IABiQcZ
	/aLQjMMhuoH88rN4WXRRh/30LG3I+JDk/Ozj9A0Q/MLaCmNZEtd4bbPFFa8SRcLszbduZt
	Jl6jfCbhZ0zTOGH4AU2nP4zRHyNo4WY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789558747;
	b=iIKlzNM4ez7mq1iAeEE8prBEry8/SMJNiVm0lqrIqctFzaIW5ks1n+doHmjwS9/s7V6j/v
	ZFKXhv5TGtNloTmh2uB+qSvFjF/yhCo7Hov353Fs7oWUquU7usff+KthWedkKwPV4e4tb9
	xv6MgC/j4gR3e/0VW8B17je634otXi8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=GCr8XKiJ;
	spf=pass (imf03.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cslab.ece.ntua.gr;
	s=smtp-cslab; t=1789558743;
	bh=rp+GnoA6aH/bX888ZhhE4/Uvu4tL8BbKtB39uGTOfzM=;
	h=From:Subject:Date:To:Cc:From;
	b=GCr8XKiJcFnf0hKmAQZL3dDsWlCJvm4dhK/m+0F3/a9BuKLXPFjWH4CfkWZO+1Ycv
	 +6HqwWOdzg7uniOGMUsBH5Al7092koXi5SngH1+jaaKVQU6RNz8rQKTPgfsNWWlxpd
	 Ayjuc0H9hS3cqTXPbxgIaHaWNJgw6LnVdiyU8BXc=
Received: from [127.0.0.1] (armor.cslab.ece.ntua.gr [147.102.4.33])
	by danaos.cslab.ece.ntua.gr (Postfix) with ESMTPSA id ABE00120B72;
	Wed, 16 Sep 2026 14:39:03 +0300 (EEST)
From: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Subject: [PATCH v2 0/4] maple_tree: fix maple_range_64 crashes in RCU mode
Date: Wed, 16 Sep 2026 11:38:41 +0000
Message-Id: <20260916-fix-maple-tree-range64-rcu-v2-0-0b09de37eb69@cslab.ece.ntua.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMF/qmoC/32Nyw6CMBBFf4V07ZA+FMWV/2FYTMsATRDItBAN4
 d8tJG5dnpuTc1cRiD0Fcc9WwbT44MchgT5lwnU4tAS+Tiy01IUslYbGv+GFU08QmQh4d4ozsJt
 B6gZNrelS4lWkwMSU7CP+rBJ3PsSRP8fXovb1lzX/sosCCUahMtLam7PNw4UebU6O8iHOmLcsq
 m3bvlimsvrMAAAA
X-Change-ID: 20260912-fix-maple-tree-range64-rcu-02fa3d2e59a7
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Dimitris Charisis <dchar@cslab.ece.ntua.gr>
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: rn6gpnbjk6iz8ioyph93j47ykepduwcu
X-Rspamd-Queue-Id: B295D2000C
X-HE-Tag: 1789558746-17723
X-HE-Meta: U2FsdGVkX1/X2/FPPkVL4zFH8AEWQ8U2/ZW+AERoYsrZPcSLRPEqvDlUMDUZpErJeFUcF2FH7mJaxmZW4vPcpTQHrT7pxL+HSMiJvQg1mL8XhPBBSdXiVxxpPmGi468jV9x1G0/YVc0ZMIg6vFrErPqXUNEW4f2xsQbjVFBY3bgwTx3ljg8mSqti7/0VyKhqY8CK563D/o7gW42Yg7MmHxR23GZQy8wkEC84vsQj4wcvPSl7t35qN9U8Y9tyoBL7iAchcOZ26/SFNHjSMnVdMgvEgduf1TOxraQ7rYMwmIrWH/m5ZW3eq1UxowH4Wzqbj4u5ykmPIOFUOwtBfCiheRTUPg2ObweCveYHn10A2b7Zy+od+RPy6HPLfQh0CLTUMkkk7Jzc6GDIwzDjCn+vCaod1O26e1TH0qrQQ7+H3LklQ/S6YBva8uDhkKW1+d1AoR+wuO3ve6jyxwqTlBOmUrdnoDLieghIIAFGQxvin1rWxYLV6lzg+lbbLLg6Gw7ig2qs7eZHSf8ih/8BSZTrxJrK4v+Fok1sJw8xs/+11gaXZ8VXlU9y4C5eLM9zbitVx9prpFFj8OJr9NgqN+d8Z226gSCU6xHgl0ckSwMmQML4xguNeDRsYChNEePaeihsZkGiKEkCfWRKAsNUeAs5XGNcF+yez+3+3BUYG1NMwh4XWvSEwFUTypFSEIFDsfpj8n5eF6jLjDiGs2Dx7arvqK+VeEwlpFg7YQszUa/6Y9uzigrBtM6dH7RMOT/yDPxHXqbDGRNk9F4IPxAzO4ruNdb7Ko1KIHxLFm2FEbUh5r7RE6m2xuNZ7boMxQlm/VHhBS6Rtrs8Umvdm1/4masQkpwBl5VkLTXAF7zCEt1Gyp5Ppby4WVVgfQPUV36iEhAS0RhngZodyoZBCqC70TEtdDfFtnEPh0mWMCpGRxBTnx+74EI01yx394jvdAV9ZZH9S/B5uRnjHYOmp1ahVqL
 NNqRYKXa
 Yr4TKSNmeGPbaz0qI2aWHFkdIYNGsDnoNU2z6Oid2VpklTNn83vsqYGgqxIwCM9H1miAHxhRyUUSA/H/+xDZOTIcr2QcdErEGUTNmeOWRY74epGdEFz18MZXgzIozOkRRbLjjMFQM+x/GaaERQ2SP9MWcwGcCKi1EA/0VKxYpjlHgobdSX8qNxqR5ky6UeiuymSj79PvoW6g11azugZvDBabXv7YJvifmM7LKqsM+9XuhVO17z65Epf7ly9KkrEY7X3Y/g5Rt1EetpYef5Y1aZhhBRY26NnX2K8eAzJFiDnAxYEGga38930QG5fB+elUiMD4aqFoJDsI2yFBsIaCtfRK8CWW5i12UivC4Aj6Sa0AhSQeZqLDq2H7nyW/JuHQ8N6vi/C7aN5N7RHc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch series fixes two RCU destroy path issues on maple_range_64
nodes. Both arising from the fact that a maple_range_64 node repurposes
the last slot to hold metadata when the node is not full. Patches 1 and
3 address each issue, and patches 2 and 4 add the tests used to catch
them.

Currently there is no in-tree user of maple_range_64 nodes in RCU mode.
All in-tree users of MT_FLAGS_USE_RCU also set MT_FLAGS_ALLOC_RANGE
which makes the internal nodes maple_arange_64.

Below is the minimal reproducer used during debugging:

static DEFINE_MTREE(tree);
static int __init maple_fix_init(void)
{
        unsigned long i, j;

        for (i = 10; i < 4000; i++) {
                mt_init_flags(&tree, MT_FLAGS_USE_RCU);

                for (j = 0; j < i; j++) {
                        mtree_insert_range(&tree, j * 10, j * 10 + 9,
                                        xa_mk_value(j), GFP_KERNEL);
                }

                mtree_destroy(&tree);
                rcu_barrier();
        }
        return 0;
}

Patch 1 fixes the first issue. The splat is shown below. mt_clear_meta()
runs after the slots have been rewritten with raw pointers by
mte_dead_leaves(), so it cannot recognize a valid last pointer because
the type information is stripped. On my 64-bit LE machine, it clears
bytes 248 and 249 of the maple_range_64 which are the two least
significant bytes of the last pointer. The lowest byte is already zero,
since nodes are 256-byte aligned, but zeroing byte 249 corrupts the
pointer.

KASAN catches it as a double-free, because that corrupted pointer
happens to land on a node that was freed previously. The splat appears
at 226 insertions in the reproducer. This is when the tree has a full
root node on a 64-bit build.

  ==================================================================
  BUG: KASAN: double-free in mt_free_walk+0x138/0x3a0
  Free of addr ffff0000f3d40000 by task swapper/2/0
  [...]
  Call trace:
   [...]
   kmem_cache_free_bulk+0x5b8/0xc18
   mt_free_walk+0x138/0x3a0
   rcu_core+0x5d0/0x1638
   rcu_core_si+0x18/0x30
   [...]

  Allocated by task 1218:
   [...]
   kmem_cache_alloc_from_sheaf_noprof+0xa8/0x2f0
   dst_setup+0x210/0x630
   mas_wr_split+0x568/0x26e0
   mas_wr_store_entry+0x98c/0x1de0
   mas_insert.isra.0+0x3d0/0x5d8
   mtree_insert_range+0xec/0x1c8
   maple_fix_init+0x94/0xff8 [maple_fix_obj]
   [...]

  Freed by task 0:
   [...]
   __kasan_slab_free+0x88/0xb8
   __rcu_free_sheaf_prepare+0x94/0x360
   rcu_free_sheaf+0x30/0x138
   rcu_core+0x5d0/0x1638
   rcu_core_si+0x18/0x30
   [...]

  The buggy address belongs to the object at ffff0000f3d40000
   which belongs to the cache maple_node of size 256
  The buggy address is located 0 bytes inside of
   256-byte region [ffff0000f3d40000, ffff0000f3d40100)

  [...]
  Memory state around the buggy address:
   ffff0000f3d3ff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
   ffff0000f3d3ff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  >ffff0000f3d40000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                     ^
   ffff0000f3d40080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
   ffff0000f3d40100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ==================================================================

Patch 3 fixes the second issue. mt_free_walk() descends by checking if
the corresponding slot[offset] entry is non-zero. In a maple_range_64
node that has MAPLE_RANGE64_SLOTS-1 valid pointers to child nodes, all
slots will be non-zero, since the last slot holds the metadata. Thus,
mte_dead_walk() dereferences the metadata as if it were a node and hits
the null-ptr-deref as shown in the splat below.

After applying patch 1, the reproducer reaches this case at 3166
insertions. The affected node is the root on a tree with height 3 and it
has 15 valid child nodes on a 64-bit machine.

Patch 1 does not introduce this bug, but it exposes it for the root node
because it no longer clears the root metadata. On an unmodified kernel
before patch 1, the same bug exists and is reachable when such a
maple_range_64 node appears below the root, where mt_clear_meta() is not
called.

Second KASAN splat:

  Unable to handle kernel paging request at virtual address dfff800000000006
  KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
  [...]
  Call trace:
   mte_dead_walk+0x78/0x140 (P)
   mt_free_walk+0x1f8/0x3a0
   rcu_core+0x5d0/0x1638
   rcu_core_si+0x18/0x30
   [..]

Both splats are from an arm64 QEMU guest. The test_maple_tree and the
userspace suite pass after each patch in the series.

---
Note for reviewers:

* Before commit 790e1fa86b34 ("maple_tree: add RCU lock checking to rcu
  callback functions") mas_clear_meta() was called while descending the
  tree, so metadata was cleared on every node. That commit removed the
  call from the descend path leaving only the final call for the root
  node, and renamed it to mt_clear_meta().

  An alternative fix would be to restore metadata clearing for every
  node and fix mt_clear_meta() for full maple_range_64 nodes. I
  preferred removing the clearing and use slot_len to identify the valid
  slots directly.

Signed-off-by: Dimitris Charisis <dchar@cslab.ece.ntua.gr>

---
Changes in v2:
- Add one test after each fix.
- Reword the cover letter.
- Link to v1: https://lore.kernel.org/r/20260913-fix-maple-tree-range64-rcu-v1-0-31a130bb8cbf@cslab.ece.ntua.gr

---
Dimitris Charisis (4):
      maple_tree: remove mt_clear_meta() to fix a pointer corruption
      test_maple_tree: test a full maple_range_64 node in RCU mode
      maple_tree: fix invalid memory access in mt_free_walk()
      test_maple_tree: test a maple_range_64 metadata slot in RCU mode

 lib/maple_tree.c      | 43 +------------------------------------------
 lib/test_maple_tree.c | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 42 deletions(-)
---
base-commit: e2e54005e20fb42d4a5e140d70a65be4a2363045
change-id: 20260912-fix-maple-tree-range64-rcu-02fa3d2e59a7

Best regards,
-- 
Dimitris Charisis <dchar@cslab.ece.ntua.gr>


