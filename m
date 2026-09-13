Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDCCBC88E65
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 15:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919076B0093; Sun, 13 Sep 2026 11:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CB996B008C; Sun, 13 Sep 2026 11:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76C6F6B0093; Sun, 13 Sep 2026 11:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4606B008C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 11:26:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8419AA07BE
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 15:26:56 +0000 (UTC)
X-FDA: 85209116832.04.516136B
Received: from danaos.cslab.ece.ntua.gr (danaos.cslab.ece.ntua.gr [147.102.3.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id BC4BB4000A
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 15:26:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b="HTJl/mFq";
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr;
	spf=pass (imf17.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b="HTJl/mFq";
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr;
	spf=pass (imf17.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789313214;
	b=eOQUFb8zv9ySf8W0Xga0dn0nOuCfTykftjImGa5xMg83N8OcdKWgu7lYyodBcSODVzDao1
	SWH8j686UciNfEzkHRqsOyvR+SBQMcNz4LvKb6q6gPTHK1rC6i4exlZcUGS7U8xIl60ZAS
	9VBW18GG5kgawb8dhmVBfeSXpmdqXv0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789313214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I/+m3OHiB1/w9bCvqfab0gwJ1AbBCswIlznPDA6TImI=;
	b=8pgFAvoWqyPE14cZv29thLJOK2mRBLQTPm5/O/eQkkUlMdwWDMJMhZwXV9rZpyqu57e+jJ
	ZKPKdekYiUT2v5HcJsD247PofBV+8bNMXvYu+JiMIaXzuv9qpnuiDD7qumf062u/YYZMlw
	QLUak8jdwKIRnJFT9Z5+RrJT7D31Q1Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cslab.ece.ntua.gr;
	s=smtp-cslab; t=1789313206;
	bh=Bnk734lVpvGjHUNThsIWBtKEdz4cGiQMC0zLJkAfrIk=;
	h=From:Subject:Date:To:Cc:From;
	b=HTJl/mFqPyZ2rkie4PSJCm14++mzyyZr2PEUIH8+ogRbzF77g5BdI6kDBlncdneNH
	 4lMm9F88bcJiBjq4IYXTGJSseVzxakqsqx6DJTg42fGBC1K97eAEyTMEW4+nSKVtiz
	 9/wPhs75tZm0PY4XVsGe00v7h3mB6sn6uJZclEBo=
Received: from [127.0.0.1] (armor.cslab.ece.ntua.gr [147.102.4.33])
	by danaos.cslab.ece.ntua.gr (Postfix) with ESMTPSA id 8E0AB120A01;
	Sun, 13 Sep 2026 18:26:46 +0300 (EEST)
From: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Subject: [PATCH 0/2] maple_tree: fix maple_range_64 crashes in RCU mode
Date: Sun, 13 Sep 2026 15:26:17 +0000
Message-Id: <20260913-fix-maple-tree-range64-rcu-v1-0-31a130bb8cbf@cslab.ece.ntua.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJnApmoC/x3MQQqDQAxG4atI1g2MsVX0KsXFMP5qwFrJqAji3
 Tt2+eDjnRRhikhNdpJh16jfOUX+yCiMfh7A2qUmcVK6Ohfu9eCPXybwagDbbconW9jYSe+LTvC
 qfUVpsBiS/s/f7XX9AB1VQGNsAAAA
X-Change-ID: 20260912-fix-maple-tree-range64-rcu-02fa3d2e59a7
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Dimitris Charisis <dchar@cslab.ece.ntua.gr>
X-Mailer: b4 0.14.2
X-Rspam-User: 
X-Rspamd-Queue-Id: BC4BB4000A
X-Stat-Signature: xnk7wydnzu5td1m7w6rfpzfkhq46fyig
X-Rspamd-Server: rspam01
X-HE-Tag: 1789313213-169776
X-HE-Meta: U2FsdGVkX199hUD7eclpS1TLKjZ9WMuEU4XvfN0qrQ2NsuTt04zMMd/3nUSCrEoknOBrrD6FaBjVRoBrDlfQw2PjeC7UXiskKhcOLPp9b5eKLQWxewWciyV2Asa6ZrwZoBsga3UKK6G00/ufHPs2fldPxtk6SxU+laWl8kcDd9NbPBFn0N9kQjieY+WrF3mJSMycetjeKI8JRcOiFgPSJRT/7ZWb+JuFOyuS+nx2YWuKk6KM66XLl8/DgxVUMDrYcHSkuUn51mkE7Jnt5e0nRQ591lYm+qIVj3x79Q6na/dW8HaotXFV1hVE0B8XOKvQ1TfcCgUchokCzRgdu7I8wVF2MzCIC5FrUZta7mZddb0iWmfw7XyghgkkwIH6POut1ExUPo4juxK5Rof+rZ4Py+9YCD9NSxlgrpaZt9ntm8j08Ez7YA6FRBtMTtse6zfjt/Ajvn0UL5+Xk+UzenwtepMunWabHzp/kNGUUbaLmrEfQOaPuPcuPbmMsPhoo5pZgnec0VPX05gedWoUgg035iaZxyZ9pjHXJK8Cb/zf/RnDbu4JTixSPxbzgV58+S3XRs5bE9ztpqC0AS+1pKNvnkyQ1mcZpjxTQ1LyLrjEX87yigvVL1jALv6kr1SUs9y/GBPc/h+4UeayiHSlJ0IFxOxyjNBhCYFb12XfV1p2dfis56wJs3ifLAIDei9c5hpHQ7AfF4RLeQYEfbGdGAQFp8hFPeW8KyZ5eAghqAmuom7XkZD22y9LOCNj7vzoh7dwNrE4ks+SMthurdCavA8Q/Z9vDgL0+AORsZBUOvLTWygwDJ8G9xZD4JtVDgKOmjfU4SvTISDHkrEgFQkQB6qNrnP1lBXTaVCQPvTaNIDtwvaU78h2TkQFVF5IHKs+Iy+uOO7MyDo+9RDb7WEXzDLGf2lXZsc2PkI/NQEO66Wy75pWbgGEbJQ4/doJf6zZc37PkSfz11mSaKQTjMEJbf1
 t2z0Z3PV
 RGKW9Iyp+hH9LLF6NnUjQnXDnLecPs+YJZr+sV94VbFJPl6wmc8GfxrV5Dm4dhNbA9hM28HhIeUcLK6mgbtmp2/aqaHElufh6O6UxxZK3YC3c90gtP0GrA7b98tH7ixtJmDk8FG+5ZWqHbcM1efLNReyuvPOb1Fp7JhXEW78G4On7LSqjgTb5YJLKofncEmpAc8ZW9BRoVcOTTYzWHjjMQiUTD3Nc+zTcnLxKOsheLtHWYfFzMxMdX2aEcfAckcviiSY32H+UicJRmqmw+yE2TGaNuHi0puFG6H6HIxZ7OZFALQcdacyArD7YV95EtOxOJYaIr4QxIQJOkqH5RUB4xfAdRVe0/NroOEoilwoJ+vQSYfWoiP2OYa1ESw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I was running a patched kernel using a maple tree in RCU mode without
specifying the MT_FLAGS_ALLOC_RANGE flag and the kernel crashed. I
switched to an upstream kernel, and after some investigation and
debugging (thanks tools/testing/radix-tree/maple.c) I discovered that
there were two separate issues on the RCU destroy path that were
responsible. Both arising from the fact that a maple_range_64 node that
is not full repurposes its last slot to hold metadata. Each issue is
addressed by one of the two patches.

AFAIK there is no in-tree user of maple_range_64 nodes in RCU mode at
the moment. All in-tree users of MT_FLAGS_USE_RCU that I found also set
MT_FLAGS_ALLOC_RANGE which makes the internal nodes maple_arange_64.

Below is the minimal reproducer I used during debugging.

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
happens to land on a node that was freed previously. The splat usually
appears at around 226 insertions in the reproducer. The exact tree size
that triggers it may vary because it depends on where the corrupted
pointer lands.

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

Patch 2 fixes the second issue. mt_free_walk() descends by checking if
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
Dimitris Charisis (2):
      maple_tree: remove mt_clear_meta() to fix a pointer corruption
      maple_tree: fix invalid memory access in mt_free_walk()

 lib/maple_tree.c | 43 +------------------------------------------
 1 file changed, 1 insertion(+), 42 deletions(-)
---
base-commit: e2e54005e20fb42d4a5e140d70a65be4a2363045
change-id: 20260912-fix-maple-tree-range64-rcu-02fa3d2e59a7

Best regards,
-- 
Dimitris Charisis <dchar@cslab.ece.ntua.gr>


