Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACC58CA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 16:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19E386B0088; Sat, 10 Oct 2026 12:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F7E6B008A; Sat, 10 Oct 2026 12:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03D2F6B008C; Sat, 10 Oct 2026 12:21:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C6D9A6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 12:21:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC1B2C0160
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:21:05 +0000 (UTC)
X-FDA: 85307230890.03.5F2FEC2
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 018FB180008
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:21:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X6iqUx3k;
	spf=pass (imf24.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791649264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Yijvi9zg0Pj6BOdFjk5FdPLKcBndaQKT70J63Zutecw=;
	b=f9XEt0+kP43uToFr3q456wlH57t8TEluL5NBZ2eM7/dN3uDsQF0T/rKctX2FVIgrGFNQVi
	usxnG0qS+3Fd4gTba41YNj3O3jwueDejiZMrWzQ8jIoxcptdKwRvoP2jD2OtGkaMUFmSbS
	jO3yhPWubKpGr4/3IJYHF1SzBUKtE0I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X6iqUx3k;
	spf=pass (imf24.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791649264;
	b=UpfDhvYnDh+Fa/+Cojy6so9pej6KOb0thCjMEquH6tmQMyyZJa3VcYCrh0PKdf88u1m83O
	76NXnz5AMtpQ/zfZMXZiieUGHhgjkDqEq+5U1Btnwu1RO+8fns+ebAmHGe7NYSu8Pye7dA
	m7Cs7po7Q7OCsz9dZx7rWj2nxXWPP3k=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-15ea896ddc8so960234c88.0
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791649263; x=1792254063; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yijvi9zg0Pj6BOdFjk5FdPLKcBndaQKT70J63Zutecw=;
        b=X6iqUx3kCA9sTO+okkMzbvAbhHvvKmrn+HrtgLCKZkxgpDqkLgRs7DNxcdh+if+BKk
         OWQyqsW2pULiJwicARhz2a0DVXDmlTogGbADFDKs9/n2LwtDR2xtytKpKD7VyuzBscIJ
         AlRLGeFd7cg0Pcn6JEVQSR4G59Of0FZ9UmH9FNz7sXaBs6aftmLnr+NlvGsP+Z2BRfQ0
         fnfMEUeYGVax2BwS3nQ5riVLQxdwHFUnvdgOl+WOk31bJnyoKKPf1ITtb9sLZ9WmFbhq
         Nf4xgDfZ0Cxrzli8q3hucC4dP4p/+n4yO8VT2KcPeRZenaKBiu1JmHcWBYS+bT+C7HZG
         oQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791649263; x=1792254063;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yijvi9zg0Pj6BOdFjk5FdPLKcBndaQKT70J63Zutecw=;
        b=MP1u4vqdhOjZlCazh5T520yYXSJdZtMQqeGZzua6TqSRmcgmHwzzFc1mf3yiMCihRm
         j/k7PhUVk2QFv4+clxzY/G4CxLGhZOLpsod/NEoc6hDblDuwILKBdsH9/1G09hr//oBI
         f0KHNHoq9oG14Sh/EjxNiqlVavWwWNKljMlAlaUSWfcI6+jA9buLvaLVS5nnL8JbH9Ry
         rKsWI0L5QFBhYHgu0C5veRBPBFUpRCojVDl7XZwGOufKWSVbgH6LohpVZke1jeJ/k+p7
         BFlersMKk/D6mEi3OT+kw/Ev6SLrgxrPsBytKdRxZcWEWr+3o6y0ofhhaDZiQGBfWL4C
         211w==
X-Forwarded-Encrypted: i=1; AKwUvBxSSDtpqns3Wch5Y5zt0LfPjXmDxdQs1XG7BWFcHPPMuSZU44vdwUBLbXP15Nsl1yuxD9gEEUwvug==@kvack.org
X-Gm-Message-State: AFq9FYKX8gtMxI3RrWF6S2tg/PgcrZ7SxhRYLYO/MCQwLTJx79na7NsV
	UajA9hghmtQfpBlL7LcuQl7A+HVOP6gRIZLE+sTIwnh9LK1iz+VE2C5s
X-Gm-Gg: AYBFou083sKqUru7kINWdQPh7FYlR87yP9C1zHuq7TMqCd7+kvwHOYDQ2hR9CfHacSn
	M0HdR1cTfN6Aefe/BYx6eBQkr3B2fEFFR+hbSF36+EPMimdTGsqQLBWUunwVhq9OUOvF1ILEDM1
	mLtlXcKIj8V8rBvQL+DSX3ftowr0foNbsQ2P+bx3NWwvxLtofk1W9dNx/PzHAMJoYesunpU8RyP
	s9Jnqzj2cgjZXhrZpM9bCT2IoKm63z9raHzK8doiljsOKmXGrpavFKdOyBREEa4Xy6uvHMW7/kd
	PvFag7sofca3F7/X+a0uaDO0f1ctKvJafIGJLv8x5JdjuNY2OzpYpjOAgRTYYFjGw+TrYCG8IIn
	gifs754GcmVTzdnn5Qh/6Qet6hn2j0/l03Nd8xopCLH3GpG142pdbg30IbF6QBzTAdIPbyr4gzV
	eJ7JmGLCfkMxGjPWRCgMmyybQITQTLlT3nBnTf5GwQ6VmaNBI6aPC8J6NkDb1HfeimvqPSTBQ2V
	YPkU4m+cea4/X5t2w==
X-Received: by 2002:a05:701b:260c:b0:144:f85a:a188 with SMTP id a92af1059eb24-16a56ab4575mr5965520c88.2.1791649262450;
        Sat, 10 Oct 2026 09:21:02 -0700 (PDT)
Received: from acer-nitro-anv15-41.. ([115.96.176.39])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a3f6186fsm15778622c88.14.2026.10.10.09.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 09:21:01 -0700 (PDT)
From: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
To: Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <djbw@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Breno Leitao <leitao@debian.org>
Cc: Ira Weiny <iweiny@kernel.org>,
	Li Ming <ming.li@zohomail.com>,
	Richard Cheng <icheng@nvidia.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Kiryl Shutsemau <kas@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Subject: [RFC PATCH 0/5] cxl, mm: Keep device-reported poison out of the page allocator
Date: Sat, 10 Oct 2026 21:50:08 +0530
Message-ID: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 018FB180008
X-Rspam-User: 
X-Stat-Signature: qzqdokt9ryrty6cbfte3t7t9kiwtrz6b
X-HE-Tag: 1791649263-872455
X-HE-Meta: U2FsdGVkX18PsT+fIVztmfxXDxhi4a4o6thKuvA0v15wgv4PoMAuBLuBUkeS9yU3hpibTujyeffTYyhOUuHGxZGZf5NE1I6W5jbvTUYtWEED0fNssIi7apmX1jFC28fPXGJyVdPZhXpOccwPe+mHolrRkpjLbWdGmJxmuS4mZbVUb2gc4QiV3CHNDbmq2Z2nDN6+hTeH4+gY3kNS4S3F8JvkA2HRe0DfYFAxc46i0H+l8y52KfiCXDCpnsiEeQP21APbI/pj3Whn2YvM7+DshwrwcBrgTIR4xZSsiGFEOmXw1/PY64LkcykTcKapFIaAXObo1MaiYstz154T2bhgDedH59F5y4ShQ9wHPjrFeEreqM53AxzY+P5vdNsZS/5znE3QGJmtND54R9ReKxRqvmCBBjNML95jFyg0Vt7UgQZCnSW8nBO8lAfrlGIuPq9fN5GHZizbQUbOS1UYRd0XPWLltii1JHV2YP9bEqAdsPngxewh4t4/FmroUF1dmH6lUSM1VjQUdxcMFX5LLrkxTzU+cmFs8hr1n2RycQFlrQtvTwV3YhmnLNPqT8URaFmXvd8Yf3R26Cyf9pE1NtHOl+fuJLi3ieOcvlEyKYzE1O7lU3z/lXQ8Ub5sW+jwV36VP0YsDeSrKTeMhNoY2T/WyfKlRRmC3sMBMbDInegIa1DVFlpJw13ToCUPrMcZgQeUkwDmCz3k4OHhbmE7v4syTadHOxHdxI6yyrma6n2CpXkNccpLsgSuzTYbMztQbAvJt0S8kxIhVBfL4Y6Bvk+OzgHWRmeK8ug9OOjeflM1YTi+hjzX2nHhI6ZSo0m/70AV4ZS6kMO8qTSEeYtmXs3nQlwnBxrqcSKkJo3YN11rETivrZnLVxHfzJoBKu3oiE2iT0V+el4Ozb5ShWCxkh5wK+bdNKhcGcCXqvU+0dDiJ3mJS1wQjBonQVJdddK6dRthfHQqpScLazTC8KHip1F
 cNBeAxaV
 twO57NO0QYnW2DTy+4JcKoLe8fAkipYNlYyTqYgkua4M7hPQ4EPZqCnnmlrzzSg+/YUtl6rLZYM5IbEAuL640wNNY0zXVDwobwjkqb0MwV2NmX3dHDL494dYV6ilJvp+TTOk4/oSZ1Y+r45RpmPet2EVbL8Hp3EE+QU3GXgFnNndkQSB/rFeJPIqMOlYosVzO4QEH0f1z3Y2d0WE3APE3TgdOCgCD2BS+GkW48Z5HPpc792po+mSl2ouyTgN0cf4BQVR9yUHEFb2/N+BSqR+C0VBbTlrsPOz9PVRrao1hH4jcRK6eSuURMmUfaM+3X8ACLfnoM4mjk2MkZpHhwOiEBTjah94sQyejschnNJVPntBLZZDkwBzRZUmX4lKdiLQ6fnwq52P7OlXTsWhoK9Xi/tnSJApRoGEl+qjvjq16No8P5o23zOweEINmN4hkMEJdB+NFRNUgEkPv0bttnmyLK4M8dhsSDg9b5RdjEUkCdn9FELRukBX1rAqEnHu4ickbJLdnI4D3UTx5uymj59ccHiy9cNVfCk7TEXJ8Ju1f4Roxo4njTxQL3wd259NCRU8t5FYG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A CXL memory device keeps its own poison list: the DPAs it knows to be
bad. The list lives on the device, so it survives a host reboot, a power
cycle, and moving the device to another host.

Linux reads that list only when user space writes trigger_poison_list.
Nothing reads it when a region is assembled, so with a device that
already has poison:

  1. the RAM region is assembled and dax/kmem onlines it;
  2. every frame enters the buddy allocator, including the ones the
     device would have named had anyone asked;
  3. a task is handed one and reads it: machine check, memory_failure(),
     SIGBUS.

This series reads the poison list at region probe, before the range is
onlined, and keeps the frames it covers out of the allocator. Nothing is
unmapped or signalled, and no runtime path changes: the frames never
enter the allocator, so this is not forwarding latent poison to
memory_failure().

Dependency
==========

This is built on Breno Leitao's hwpoison series [1], which keeps frames
poisoned before a kexec out of the next kernel's allocator. The approach
here, withholding frames as they are onlined rather than taking them
back out later, follows [1]. [1] hooks __free_pages_core(), splits a
block around its bad frames, and marks them with hwpoison_boot_page().
Patch 4 adds a second source to that hook.

The two cover different cases. [1] records frames in a bitmap spanning
the RAM the EFI memory map describes. Memory hot-added after boot sits
outside it, and CXL region memory is hot-added after boot. [1] also
carries its record across kexec only, while the device's list survives
reboot and migration.

Applies on next-20260908 plus [1] v5. The num_poisoned_pages_inc()
change agreed for v6 [2] does not touch these patches. Patches 1, 2 and
5 touch only drivers/cxl; patches 3 and 4 touch mm.

Design
======

Which records are withheld. A corrected error never reaches the poison
list, so every record is uncorrectable. Only records with source
Internal, a failure of the device's own media, are withheld. External
poison was written by the host into healthy media and a rewrite recovers
it; Injected poison comes from the Inject Poison test command. Withholding
either would make a recoverable state permanent.

No host-side storage. The device is the source of truth and is re-read
on every probe. When a location is repaired (sPPR, sparing, hPPR) the
device drops it from the list, and the next probe onlines the frame
again. A record persisted by the host could not learn about the repair.

Volatile ranges. CXL r3.2 8.2.9.8.4.1:

  If the device does not support poison list for volatile ranges and any
  location in the requested list maps to volatile, the device shall
  return Invalid Physical Address.

A device that returns it, or that has no Get Poison List at all, is
onlined as today with nothing withheld. This is also the reason for the
RAM -EFAULT tolerance poison_by_decoder() has carried, without a comment,
since f0832a586396 ("cxl/region: Provide region info to the cxl_poison
trace event").

Incomplete lists. If the device reports overflow, the host stops at
max_errors with more records pending, or a media scan is in progress,
region probe fails rather than onlining on a partial list.

Translation. Each record is mapped to the pages it covers through
cxl_dpa_to_hpa(), including the extended linear cache alias. PFNs are
collected in an xarray, which removes duplicates and keeps them sorted,
then coalesced into ranges and registered once per region. The ranges
are unregistered when the region is torn down.

Out of scope: regions with normalized addressing, and PMEM regions
converted to system RAM through device-dax.

Patches
=======

1. Snapshot the full Get Poison List across continuations into a
   caller-owned buffer, keeping overflow and scan-in-progress state.
   Also bound the record count by the returned payload, and reject an
   empty payload with More set.
2. Factor the per-decoder query out of poison_by_decoder().
3. Add a registry of PFN ranges known bad before online. Readers walk it
   under RCU, since __free_pages_core() runs concurrently across nodes
   during deferred init.
4. Consult the registry from [1]'s free_poisoned_block() and
   __free_pages_core().
5. At RAM-region probe, read each decoder's list, translate, and
   register before the DAX region is created.

Testing
=======

QEMU 9.1.0, x86 q35, one 512 MiB volatile cxl-type3 device, 1-way
region at 0x190000000.

QMP cxl-inject-poison records poison as Internal. The kernel's debugfs
inject_poison goes through the mailbox and records it as Injected, so
both cases can be tested without a mock.

Three 64-byte records were set up before the region was created:
 
  DPA       Injected by         Source     Result after create-region
  ---       -----------         ------     ----------------------------
  0x100000  QMP                 Internal   withheld (PFN 0x190100)
  0x200000  debugfs (mailbox)   Injected   not withheld, source filtered
  0x300000  QMP, then cleared   -          not withheld, no longer listed
 
create-region logged "withholding 1 frame(s) reported poisoned by the
device", and HardwareCorrupted rose to 4 kB: one page, for the one
Internal record.


To reproduce:
-------------------------
1. T1 (Terminal 1): boot the guest
vng --disable-kvm -v -r ./arch/x86/boot/bzImage \
  --disable-microvm --memory 4G --cpus 4 \
  --append "memhp_default_state=online_movable" \
  --qemu-opts="-machine q35,cxl=on \
    -object memory-backend-ram,id=vmem0,share=on,size=512M \
    -device pxb-cxl,bus_nr=12,bus=pcie.0,id=cxl.1 \
    -device cxl-rp,port=0,bus=cxl.1,id=rp0,chassis=0,slot=2 \
    -device cxl-type3,bus=rp0,volatile-memdev=vmem0,id=cxl-vmem0 \
    -M cxl-fmw.0.targets.0=cxl.1,cxl-fmw.0.size=4G \
    -qmp unix:/tmp/qmp.sock,server=on,wait=off"
	
	
2. T1(Terminal 1), in the guest as root: set up and check
# mount -t debugfs none /sys/kernel/debug   2>/dev/null
# mount -t tracefs none /sys/kernel/tracing 2>/dev/null
# echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
# echo 'file drivers/cxl/core/region.c +p' > /sys/kernel/debug/dynamic_debug/control

# cxl list -M -D -u                       

[
  {
    "memdevs":[
      {
        "memdev":"mem0",
        "ram_size":"512.00 MiB (536.87 MB)",
        "serial":"0",
        "host":"0000:0d:00.0",
        "firmware_version":"BWFW VERSION 00",
        "poison_injectable":true
      }
    ]
  },
  {
    "root decoders":[
      {
        "decoder":"decoder0.0",
        "resource":"0x190000000",
        "size":"4.00 GiB (4.29 GB)",
        "interleave_ways":1,
        "max_available_extent":"4.00 GiB (4.29 GB)",
        "pmem_capable":true,
        "volatile_capable":true,
        "accelmem_capable":true,
        "qos_class":0,
        "nr_targets":1
      }
    ]
  }
]



3. T2, on the host: inject two Internal records over QMP(Qemu Machine Protocol) 


$qmp() { printf '{"execute":"qmp_capabilities"}\n%s\n' "$1" | socat - UNIX-CONNECT:/tmp/qmp.sock; }

$qmp '{"execute":"cxl-inject-poison","arguments":{"path":"/machine/peripheral/cxl-vmem0","start":1048576,"length":64}}'   # DPA 1 MB
$qmp '{"execute":"cxl-inject-poison","arguments":{"path":"/machine/peripheral/cxl-vmem0","start":3145728,"length":64}}'   # DPA 3 MB

4. T1: inject an Injected record, and clear one

# ls /sys/kernel/debug/cxl/mem0/            
clear_poison  dpamem  inject_poison

# echo 0x200000 > /sys/kernel/debug/cxl/mem0/inject_poison
# echo 0x300000 > /sys/kernel/debug/cxl/mem0/clear_poison


5. T1: check the device’s list before creating a region

# echo > /sys/kernel/tracing/trace
# echo 1 > /sys/bus/cxl/devices/mem0/trigger_poison_list
# cat /sys/kernel/tracing/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 2/2   #P:4
#
#                                _-----=> irqs-off/BH-disabled
#                               / _----=> need-resched
#                              | / _---=> hardirq/softirq
#                              || / _--=> preempt-depth
#                              ||| / _-=> migrate-disable
#                              |||| /     delay
#           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
#              | |         |   |||||     |         |
            bash-194     [001] .....   511.644231: cxl_poison: memdev=mem0 host=0000:0d:00.0 serial=0 trace_type=List region= region_uuid=00000000-0000-0000-0000-000000000000 hpa=0xffffffffffffffff hpa_alias0=0xffffffffffffffff dpa=0x200000 dpa_length=0x40 source=Injected flags= overflow_time=0
            bash-194     [001] .....   511.644343: cxl_poison: memdev=mem0 host=0000:0d:00.0 serial=0 trace_type=List region= region_uuid=00000000-0000-0000-0000-000000000000 hpa=0xffffffffffffffff hpa_alias0=0xffffffffffffffff dpa=0x100000 dpa_length=0x40 source=Internal flags= overflow_time=0
# cat /proc/iomem 
190000000-28fffffff : CXL Window 0

6. T1: create the region

# cxl create-region -m -t ram -d decoder0.0 -w 1 mem0
cxl region0: Bypassing cpu_cache_invalidate_memregion() for testing!
cxl_region region0: withholding 1 frame(s) reported poisoned by the device --------------------> Withholding  1 frame 
{
  "region":"region0",
  "resource":"0x190000000",
  "size":"512.00 MiB (536.87 MB)",
  "type":"ram",
  "interleave_ways":1,
  "interleave_granularity":256,
  "decode_state":"commit",
  "locked":false,
  "mappings":[
    {
      "position":0,
      "memdev":"mem0",
      "decoder":"decoder2.0"
    }
  ],
  "qos_class_mismatch":true
}
cxl region: cmd_create_region: created 1 region
Fallback order for Node 0: 0 
Built 1 zonelists, mobility grouping on.  Total pages: 1007394
Policy zone: Normal

# cat /proc/iomem

190000000-28fffffff : CXL Window 0
  190000000-1afffffff : region0
    190000000-1afffffff : dax0.0
      190000000-1afffffff : System RAM (kmem)

512 MB is 0x20000000, so the region ends at 0x1afffffff

./tools/mm/page-types -a 0x190000+0x20000 -b hwpoison -l
offset	len	flags






190100	1	___________________X_______________________


             flags	page-count       MB  symbolic-flags			long-symbolic-flags
0x0000000000080000	         1        0  ___________________X_______________________	hwpoison
             total	         1        0


7. T1: check exactly one frame is out of the allocator

# grep HardwareCorrupted /proc/meminfo       
HardwareCorrupted:     4 kB

Not yet covered: interleaved regions, extended linear cache, poison
list overflow, hot-remove of a block holding a withheld frame, and real
hardware. I intend to cover these before a non-RFC posting.

[1] https://lore.kernel.org/linux-cxl/20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org/
[2] https://lore.kernel.org/linux-cxl/arEz7lp9_nRGwHPm@gmail.com/

Shaikh Kamaluddin (5):
  cxl/mbox: Add Get Poison List snapshot support
  cxl/region: Factor decoder poison-list retrieval
  mm/memory-failure: Add a pre-online poison registry
  mm/page_alloc: Keep pre-online poison out of the buddy allocator
  cxl/region: Register device poison before exposing RAM

 drivers/cxl/core/mbox.c        | 137 ++++++++++++-
 drivers/cxl/core/region.c      | 363 ++++++++++++++++++++++++++++++++-
 drivers/cxl/cxlmem.h           |  25 +++
 include/linux/memory-failure.h |  92 +++++++++
 mm/memory-failure.c            | 175 ++++++++++++++++
 mm/page_alloc.c                |   8 +-
 6 files changed, 787 insertions(+), 13 deletions(-)


base-commit: a9d7ced84989ec05be09b4b8428759ef60450a0f
prerequisite-patch-id: fe9d44deb8ccc48c0311bc4131bdf733eb353b34
prerequisite-patch-id: 4cabe6adb37cd8c218bd43c97970bc65f313b671
prerequisite-patch-id: 52ad24bceedb9c03df167f10573166a1d97ba97d
prerequisite-patch-id: 44bfbc8aa3c4b19593f7b0d466fbc0cb99b99f76
prerequisite-patch-id: 2d344a5322ff07c7895a59d2425540a30e4e0630
prerequisite-patch-id: e776f306dcbdda3f6972187ad1e43a62c2754890
prerequisite-patch-id: 3ef887599e31ef973d6d9ca15d0462d55f5f0409
prerequisite-patch-id: a23fe88ab4529b6a6669a991e15cf1631311391c
prerequisite-patch-id: 111c69880ed0e148cdda285896c006e8d1fc98a8
-- 
2.43.0


