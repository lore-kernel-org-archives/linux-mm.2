Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57DBDC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4B26B00C9; Thu,  3 Sep 2026 05:52:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58BFE6B00CC; Thu,  3 Sep 2026 05:52:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3F06B00CF; Thu,  3 Sep 2026 05:52:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2116B00C9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:52:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 911DF4049E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:52:14 +0000 (UTC)
X-FDA: 85171985388.12.8F4BC53
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id B6FD414000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:52:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fPmQL19r;
	spf=pass (imf23.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788429132;
	b=dFijErwbFnIemBrGdrkUx7P3MoXanQpnBEUcmjBCevqD7WWCF1WaB6R+CQiJHCiD/X7bkP
	4zwctWhRZHRbc1IO5EEnRJzZnvbEoP5AshmbUypEYm/hfqTCpbjD0AqogSPyHtGxhKM5H/
	SXRuCGNNZPI/WdfBtECWeCGSOPr/Wss=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788429132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZUSYhXvlZHaqGBpfONa6eiZBIF2fasBkwES7t6T1kmo=;
	b=Gv4LfZP1W167IkBsfIPQXLxaDZB1Yo5SLrG/36QcRZDlAdPASFWY4Qf0ald/vVsEghFa/I
	6PjmaPiTphbH3+MptHDLXvEkMlmsEvBkwnigsZgUn5sYs2deuO0SjUEloITFnUnyTI8FGC
	/j39zzcJVyQFYNU1Dl2+PWbNGKZoutg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fPmQL19r;
	spf=pass (imf23.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788429130; x=1819965130;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PSwqmw6s7f1Rf7QEvzaIzHqsNiMQ54g6FGDLD5SDRnk=;
  b=fPmQL19rXQqVPUce+1cKmvs5eOsHd95V9qC5xQLhoIHMlc9K78zBrTgw
   lpZnPax2nB/2j5Pkq+HlEyNVA6NbqgI/JbNivKAx+LAFSxBcffuqUcWli
   RgAU8Pr8IZ5UObRGShtirZMLXXFpqE4mGrn78mYp/i5a6sR5iECfleRrS
   c8WCTA7ujyIXPPWWp86vzf5q8zhMCc6WihgHUjAlGyTeL0D5q+lSYLlzg
   i8p2TUsFe92bg1vAAoaczy0Wa9mDDk678WAiUd103E9L+BHltteSDbaD7
   TUlrhSBX3i1bl3xNAVxPgNF0fgdFz1jVxuIV+OTVWlatrhO1L6WFILcvG
   Q==;
X-CSE-ConnectionGUID: k81HLfPhQkmkyQXUKDlqQQ==
X-CSE-MsgGUID: LY80BIsmRUqPfCL+f2EbQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="100265282"
X-IronPort-AV: E=Sophos;i="6.25,259,1779174000"; 
   d="scan'208";a="100265282"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 02:52:08 -0700
X-CSE-ConnectionGUID: PMQVrUIwRpO77LrAuFO9lg==
X-CSE-MsgGUID: db39kUGRTHGY4ppUDC+UrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,259,1779174000"; 
   d="scan'208";a="294542841"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa001.fm.intel.com with ESMTP; 03 Sep 2026 02:52:07 -0700
From: Yuan Liu <yuan1.liu@intel.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yuan Liu <yuan1.liu@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Jason Zeng <jason.zeng@intel.com>
Subject: [BUG] mm/memory_hotplug: panic due to race between compaction and memory hot-unplug
Date: Thu,  3 Sep 2026 05:55:43 -0400
Message-ID: <20260903095543.3752338-1-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B6FD414000A
X-Stat-Signature: ep9t5h8btahu5gq5mh5d5ppy65366f7z
X-HE-Tag: 1788429131-578511
X-HE-Meta: U2FsdGVkX1+f7fB8s3SnErafor832uX9NDfewHE5Vt2eFuJrWBE5jyRSZgYERFnjr5hEoXLFKExCbZWKRGxAFf5bztkheRPu7d3OjetvtkybqQ9Nkz2B+8caQPTRXmMOnEO9Cl4H5dKuvd03gD+PP+D8v+pwq5otioKwh1SRszNV3ZxNJGiwgnIzLAWux9CTdgiRmb3zOc8sCWC+ALDee/tcRIEPmWeAvhXr0mtRhBpDNIsbUVMMDru9Bc2Peb5b1E9dYrD4WOwedvkQESmZw6RS6Y+8vxwCnQpQ2+WzwAcm9JwmIVyTErt00gmikBjqrZkjFxtb1WsLmjuE9AQ7LzZiLAuqHZZoP+3qwlpjTg6NT78suxWgGlfySgS5rDrC6raySXJCxYgVuWYOFarTRi3hiPRWaJHFfZooU2Z7JjL70LuxNo5K/J5Jtlh91tB/G2B0r8XzViHq0TW2hnoOpWYJNTBtaZdVHtI1i1s9C2/R/C1jkLkv4PX5jHOmWp3xbjgnwkn/x046Mo8EfvfWWJzfOcB1DvKzUxwr0qFjzKheTcJrC5i90Qvz4X8ll03uuMpaS7ROaB2NZTZEN7+AkMdYB6IFwUsP4XZhXunBoRdM0OrQxRKNfP3lf2Ug1pd0YUe/YVvxtTM+j8kMBJ3OyvwZQnWZxmjzrFqjwRoB8yM1PfBSVPGM7bZdrHQ8CviQELIanh9YxOZKF2X1/mdgc6mfzihvcmo8sUPGVNqmRbpSfehlnzXOdqc7N35XQOblpn4T0dwmTY9awg7t8VyzJ4qbg8L0dQHGi1sODVn1WngLETAuLoJ+VuL6dq1eda3k4qiWqz9Jnj5DrjQY3CGR/TB7wC9PTXE2pvKkadBETWzVqQpMsD7melUpKIMFiE2q8rN0gEMBw6eFLKFMFXrAfn9knjGCKIulB5+K/rRvgdpkiY0dVZqpJZWkIQfLRwP4Au8dhsxmMAqi/nQrHF4
 DryClpI4
 6fvhlHCKXUbnEAY3F2XF01sBfRLhkgglYPnIKUomeURc3XAIgusTm005NjURjmTOkXtOG85LhYRj2uC4l7oE/jAcbZuPwElQvrqgYmKu7rEFkSUyFC5PhdfDxHqNsMUkIckm4+f8wSawvw9PG08TuBGP63LcplMSLJaLK+S+KZpIQJwjUHZIELSYFhkN1/ZiUu6RLgwbsV8sk3a48Ybn7Nmnv0JYrWk44seS8gjHsdbvkj0FVDBN3GISTmQXXze8Ax6m3ubdfV86Koy6ZQhcXtFpL9Wc2jus2OeotelJsEP/HPJPkAi7baLvVp/oZPIx1a55yfpFjExxek1D8pJc8XLLuxo3VAN7lHM/sCJlmghWunfo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

While stress testing memory hotplug on a VM guest running an
unmodified vanilla mainline kernel (7.3.0-rc1, as reported by
uname -r), we hit a kernel panic in the guest when memory
hot-unplug runs concurrently with memory compaction.

The kernel was built from mainline at commit:

    cee9395acd80 ("Linux 7.3-rc1")

To be more specific, after a large virtio-mem hot-unplug, the guest
kernel takes a fatal page fault in suitable_migration_target(), called
from isolate_freepages() during compaction.

We are not sure whether this race is reachable under realistic
workloads or only under this synthetic stress test. Sharing it here
in case it is useful, and in case this is already a known issue.
Thanks.


Call trace (top to bottom)
==========================
- RIP: suitable_migration_target+0x5/0x70
   isolate_freepages() <- compaction_alloc() <-
   migrate_pages() <- compact_zone() <- compact_node() <-
   sysctl_compaction_handler().


Why the race happens
====================
CPU0 (compaction free-scanner)          CPU1 (virtio-mem hot-unplug)
----                                    ----
page = pageblock_pfn_to_page()
   /* checks pass, section ONLINE */
   /* returns valid struct page* */

                                         offline_pages()
                                           /* section -> offline */
                                         __remove_pages()
                                           vmemmap_free()
                                           /* struct page UNMAPPED */

suitable_migration_target(page)
   PageBuddy(page)
     read page->page_type
     *** not-present fault -> panic ***

CPU0 checks the PFN and then dereferences the page as two separate
steps without mem_hotplug_lock; CPU1 frees the vmemmap in between.


Guest launch command
====================

     qemu-system-x86_64 -accel kvm -cpu host \
       -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
       -drive file=./seed.img,format=raw,if=virtio \
       -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
       -m 2G,slots=10,maxmem=2052472M \
       -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
       -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
       -nographic -machine q35 \
       -nic user,hostfwd=tcp::3000-:22


Steps to reproduce
==================
1. Boot the guest with the QEMU command above.
2. Enable auto-onlining of hotplugged memory blocks in the guest:
        echo online > /sys/devices/system/memory/auto_online_blocks
3. Hot-plug 512 GiB of memory via the QEMU monitor:
        object_add memory-backend-ram,id=hotmem0,size=512G,share=on
        device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
        qom-set vmem1 requested-size 512G
4. Wait in the guest until all 512 GiB has been onlined:
        free -h
        #        total  used   free  shared  buff/cache  available
        # Mem:   513Gi  11Gi  505Gi    12Mi       154Mi      502Gi
        # Swap:     0B    0B     0B
5. Continuously stress memory compaction in the guest:
        while true; do
            echo 1 > /proc/sys/vm/compact_memory 2>/dev/null
            sleep 0.2
        done
6. Hot-unplug the 512 GiB of memory via the QEMU monitor:
        qom-set vmem1 requested-size 0G

The guest kernel panics during or shortly after the hot-remove.


Panic log
=========

(qemu) object_add memory-backend-ram,id=hotmem0,size=512G,share=on
(qemu) device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
(qemu) qom-set vmem1 requested-size 512G
[   41.425740] pci 0000:01:00.0: [1af4:1058] type 00 class 0x00ff00 PCIe 
Endpoint
[   41.426189] pci 0000:01:00.0: BAR 4 [mem 0x00000000-0x00003fff 64bit 
pref]
[   41.427933] pci 0000:01:00.0: BAR 4 [mem 0xfe200000-0xfe203fff 64bit 
pref]: assigned
[   41.428550] virtio-pci 0000:01:00.0: enabling device (0000 -> 0002)
[   41.434543] virtio_mem virtio2: start address: 0x100000000
[   41.434549] virtio_mem virtio2: region size: 0x8000000000
[   41.434553] virtio_mem virtio2: device block size: 0x200000
[   41.434554] virtio_mem virtio2: nid: 0
[   41.434556] virtio_mem virtio2: memory block size: 0x8000000
[   41.434556] virtio_mem virtio2: subblock size: 0x200000
[   41.434677] virtio_mem virtio2: plugged size: 0x0
[   41.434678] virtio_mem virtio2: requested size: 0x0

(qemu) [   41.484953] virtio_mem virtio2: plugged size: 0x0
[   41.484959] virtio_mem virtio2: requested size: 0x8000000000
[   41.486809] Fallback order for Node 0: 0
[   41.486818] Built 1 zonelists, mobility grouping on.  Total pages: 436553
[   41.486820] Policy zone: Normal

(qemu) qom-set vmem1 requested-size 0G
(qemu) [  176.412881] virtio_mem virtio2: plugged size: 0x8000000000
[  176.412895] virtio_mem virtio2: requested size: 0x0
[  179.207917] BUG: unable to handle page fault for address: 
ffefa4f9edff8033
[  179.208452] #PF: supervisor read access in kernel mode
[  179.208825] #PF: error_code(0x0000) - not-present page
[  179.209197] PGD 7fdaa067 P4D 7fda9067 PUD 2ac8b4067 PMD 0
[  179.209596] Oops: Oops: 0000 [#1] SMP NOPTI
[  179.209905] CPU: 2 UID: 0 PID: 9088 Comm: bash Not tainted 7.3.0-rc1 
#1 PREEMPT(full)
[  179.210473] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[  179.211269] RIP: 0010:suitable_migration_target+0x5/0x70
[  179.211674] Code: 00 00 e9 78 ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 
00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 
00 <80> 7e 33 f0 48 89 fa 48 89 f7 74 38 0f b6 82 16 01 00 00 84 c0 74
[  179.213002] RSP: 0018:ff4a6ede84b4f7f8 EFLAGS: 00010286
[  179.213381] RAX: 0000000007b7fe00 RBX: 0000000007b78000 RCX: 
00000000002d9800
[  179.213893] RDX: 0000000000000002 RSI: ffefa4f9edff8000 RDI: 
ff4a6ede84b4fbe8
[  179.214402] RBP: ffefa4f9edff8000 R08: ff4a6ede84b4f968 R09: 
0000000000000000
[  179.214917] R10: ff4a6ede84b4fae8 R11: ffefa4f80b658940 R12: 
ff4a6ede84b4fbe8
[  179.215430] R13: 0000000000000001 R14: ff3593d2bffaeac0 R15: 
0000000007b7fe00
[  179.215946] FS:  00007f1d2ead8740(0000) GS:ff3593d328656000(0000) 
knlGS:0000000000000000
[  179.216529] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  179.216944] CR2: ffefa4f9edff8033 CR3: 000000010045c001 CR4: 
0000000000773ef0
[  179.217461] PKRU: 55555554
[  179.217663] Call Trace:
[  179.217849]  <TASK>
[  179.218008]  isolate_freepages+0xd6/0x3b0
[  179.218304]  compaction_alloc+0x1c7/0x280
[  179.218601]  ? __pfx_compaction_free+0x10/0x10
[  179.218931]  migrate_folio_unmap+0x30/0x280
[  179.219240]  ? kvm_clock_get_cycles+0x19/0x40
[  179.219568]  migrate_pages_batch+0x19a/0x8b0
[  179.219883]  ? __pfx_compaction_free+0x10/0x10
[  179.220211]  ? __pfx_compaction_alloc+0x10/0x10
[  179.220547]  migrate_pages_sync+0x97/0x240
[  179.220848]  ? __pfx_compaction_alloc+0x10/0x10
[  179.221179]  ? __pfx_compaction_free+0x10/0x10
[  179.221508]  migrate_pages+0x698/0x720
[  179.221785]  ? __pfx_compaction_alloc+0x10/0x10
[  179.222117]  ? __pfx_compaction_free+0x10/0x10
[  179.222449]  compact_zone+0x3d5/0x690
[  179.222719]  ? schedule+0x28/0xa0
[  179.222968]  compact_node+0xa8/0x120
[  179.223235]  sysctl_compaction_handler+0x58/0xa0
[  179.223577]  proc_sys_call_handler+0x1c9/0x2e0
[  179.223906]  vfs_write+0x25d/0x450
[  179.224159]  ksys_write+0x6b/0xe0
[  179.224409]  do_syscall_64+0xbc/0x460
[  179.224680]  ? do_user_addr_fault+0x200/0x680
[  179.225003]  ? irqentry_exit+0x47/0x680
[  179.225287]  ? clear_bhb_loop+0x40/0x90
[  179.225575]  ? do_syscall_64+0x35/0x460
[  179.225858]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  179.226223] RIP: 0033:0x7f1d2ebd4cd4
[  179.226491] Code: c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 
00 00 00 00 00 f3 0f 1e fa 80 3d f5 d3 0d 00 00 74 13 b8 01 00 00 00 0f 
05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 48 83 ec 28 48 89 54 24 18 48
[  179.227813] RSP: 002b:00007ffe25d22748 EFLAGS: 00000202 ORIG_RAX: 
0000000000000001
[  179.228355] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 
00007f1d2ebd4cd4
[  179.228867] RDX: 0000000000000002 RSI: 000055a3b514e6e0 RDI: 
0000000000000001
[  179.229378] RBP: 000055a3b514e6e0 R08: 0000000000000073 R09: 
00000000ffffffff
[  179.229887] R10: 0000000000000000 R11: 0000000000000202 R12: 
0000000000000002
[  179.230404] R13: 00007f1d2ecab5c0 R14: 0000000000000002 R15: 
00007f1d2eca8f00
[  179.230916]  </TASK>
[  179.231082] Modules linked in: virtio_mem rfkill isofs intel_rapl_msr 
intel_rapl_common intel_uncore_frequency_common skx_edac_common nfit 
libnvdimm kvm_intel ppdev kvm irqbypass rapl iTCO_wdt i2c_i801 i2c_smbus 
pcspkr parport_pc lpc_ich bochs parport joydev sg loop fuse 
vsock_loopback vmw_vsock_virtio_transport_common 
vmw_vsock_vmci_transport vsock vmw_vmci xfs sr_mod cdrom ahci libahci 
libata virtio_blk e1000e serio_raw sunrpc dm_mirror dm_region_hash 
dm_log dm_mod
[  179.233994] CR2: ffefa4f9edff8033
[  179.234239] ---[ end trace 0000000000000000 ]---
[  179.234576] RIP: 0010:suitable_migration_target+0x5/0x70
[  179.234578] Code: 00 00 e9 78 ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 
00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 
00 <80> 7e 33 f0 48 89 fa 48 89 f7 74 38 0f b6 82 16 01 00 00 84 c0 74
[  179.234579] RSP: 0018:ff4a6ede84b4f7f8 EFLAGS: 00010286
[  179.234580] RAX: 0000000007b7fe00 RBX: 0000000007b78000 RCX: 
00000000002d9800
[  179.234581] RDX: 0000000000000002 RSI: ffefa4f9edff8000 RDI: 
ff4a6ede84b4fbe8
[  179.234582] RBP: ffefa4f9edff8000 R08: ff4a6ede84b4f968 R09: 
0000000000000000
[  179.234582] R10: ff4a6ede84b4fae8 R11: ffefa4f80b658940 R12: 
ff4a6ede84b4fbe8
[  179.234583] R13: 0000000000000001 R14: ff3593d2bffaeac0 R15: 
0000000007b7fe00
[  179.234585] FS:  00007f1d2ead8740(0000) GS:ff3593d328656000(0000) 
knlGS:0000000000000000
[  179.234586] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  179.234587] CR2: ffefa4f9edff8033 CR3: 000000010045c001 CR4: 
0000000000773ef0
[  179.234589] PKRU: 55555554
[  179.234589] Kernel panic - not syncing: Fatal exception
[  179.241898] Kernel Offset: 0x1800000 from 0xffffffff81000000 
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  179.242657] ---[ end Kernel panic - not syncing: Fatal exception ]---


I can provide the guest .config or a decoded stack trace on request.

Best regards,
Yuan Liu <yuan1.liu@intel.com>

