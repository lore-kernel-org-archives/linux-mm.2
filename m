Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC94A606A333
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=IM6MsFC8
Received: by kanga.kvack.org (Postfix)
	id 103F36B05B1; Sun, 25 Oct 2026 13:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0926F6B05B2; Sun, 25 Oct 2026 13:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F5B6B05B3; Sun, 25 Oct 2026 13:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEE616B05B1
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:40:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BABEB1C3DE0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:22 +0000 (UTC)
X-FDA: 85361862684.07.C108A68
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0B432100008
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IM6MsFC8;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792950021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=h3QApbBlAYhRMvgt4baVTZSCZ7KrzPHAuh9ddC7G5Kg=;
	b=nIH8wQNg+A13UqG1jJplaIuCJeiMRwRHjzxXpreH5f+QyPRMH5NF7KncDUGLjt2YljA433
	vD/+PKH2Qsw2rgU8DZjrXzMcgYHB6BK4Uy40SXUXTS+g82T1cahHd8qdGpcpwHDrW+UCDV
	a7CmPcIO+5ijMSgKN1EhywQodUpp3OY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IM6MsFC8;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792950021;
	b=e8uovjkP2xLzt3EgfBCku0SwKjghAYCEIXmEc9b9zDTlllYZzqfAi4uYNUP5YSc5gUYAau
	oLDoBnuupuMCsBOSyhEmZq1dyXpG2pblShLbwyJ7zSFOkw9zYJOx6eNBdCauX955UXZMl0
	Vyrb4nqZOqJH+4vCx9tge7pL1yIfUBk=
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5c9e7731b34so1756739e0c.2
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792950020; x=1793554820; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=h3QApbBlAYhRMvgt4baVTZSCZ7KrzPHAuh9ddC7G5Kg=;
        b=IM6MsFC87wHLiJV9sPfPnMD3PLl6iQkI0bu4ltx8QTCw++X4a6UGEZ3pLVhUS40D9m
         OC/BLHRbudDJGjQSsSdoOKzlLtMm59hRa2VlFpO8np3vLGzCNIfwXkVS0YciBErVMhKN
         TyVwEQIBS/+l5Syxd9lLYS30S1Zjt0gK3DSgS1VV8NuRBOd0OuYSPEPn9Mf/es4+rHlX
         AH/tkF8A5QC9Zzrlq7E8ZGN0qVzr0wZJ3S/bTNp4DYoH8Yjf5WBaiVegE2/W/S4tB5Tx
         6qWU1AyWtOxkkDjNzWmSxW0o5QbBcLdZXY2gUGRTpFI4cdZc0HVpPuu2JdicmLMd3gcW
         T2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792950020; x=1793554820;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=h3QApbBlAYhRMvgt4baVTZSCZ7KrzPHAuh9ddC7G5Kg=;
        b=1NVcmywBYMYjgU6wlmEJcJ/BI0ZvbA42XHC+y8CjgrcHDrOowK5aqGdPluu9sc09FD
         xVSqCvgMFYBJITwsz2zAs5XMrywmRjAbjxrE6Ry4mLZPhAUa79p8Q5ZXF/ki1JCQKaRX
         gt3+gC8P6/lBGKEDZ2jNElaZdXagD9aBZ+r5zh93/JXcM3TDu7YAwiozjrO6bLv+pEau
         sFd6Sp+B3imx4H5bXqOot/yFrRb7n926jAt82eozvtPGt6J9soovrL3ttMDijCa0kNH0
         JGtOYDeDpplT8SM2r2jhBqJNypI5v8iDOGmUNq0aTdgluNfZR5THkUoHcMGQN9VN7hWE
         rYlg==
X-Forwarded-Encrypted: i=1; AKwUvBxmV7oFymtkksYuDte/iRdCQZLCvMYk58j4yDF/yK28bwOvbkt95yqSWBQNvr1cTkeI8TIpoddb4w==@kvack.org
X-Gm-Message-State: AFq9FYL+rcjDaZylBLHKtpunlAam3GCwDHZg5UPGftH1RoDdFyEVPEJT
	ksGM6BNC+R86dxypSOIVfvVVy10aMQ37N4fD2yh6fmzB3EcMjnmb0EmkVSzoDUkaMIQ=
X-Gm-Gg: AYBFou3wAFP9+aM+jtIMv77iqtydGPnwUcpbQKjR4O1i97I5ZAhaI9quRcEVYD4xy7x
	R4ghw9ZzoaPnHT98ub87LRcGPlC9x94FRq032H2s7rMuOApF1EgaF/gjTyy13GTlf8URHuNe+Qu
	5sFMP+WZTh/4zLhBE0yZIXBinQfKQ1T8aUcYeWhvM7CWNgqriovv5x/zf0w59aF9ZJhnodw9ITk
	yauJ/hGZpKf5ISiEzb/xDy1gE3maUAq/Sad+nbNwEJlflgd3U3AyYBkJgbz9jPwNEXR4pd4nj5I
	hn9dekIVWRYbf8q0kn4Qe2MYBFKb+WKB1z4hPO/cH2CVzTZQpa+FXpowmox/S5NDfpsRkHTxtD2
	NDRZXDi9+7GXi7MXL/X8MJokN5UkHNSXDGXeLmkyx2xE0luPYfpomQLJPD6LMh9S4oasM9JlLSh
	4jCfBLWVa7RpXSifx2vTw0AjA4GcwL6KMv4Hc8S6+lS6PTYy+bwP83cCG9FN/wZVUIMjxBcYRiv
	vSD/HNYSEmGlfkapxb3rdHFJSPjFI4++5mIo5ukFy908IqC/XAp0+tiZmy0IMSdw4dagb+bbs1f
	CGq15vAJeB3EtQXLdv24nx7uAf81Kj6sbfvg4hM9/Gv3Ed7cdy3XB4iict9R9t1UVtAGmxyZTdv
	N
X-Received: by 2002:a05:6122:4893:b0:5ea:c45f:6c4d with SMTP id 71dfb90a1353d-5ec23326819mr1425104e0c.22.1792950020005;
        Sun, 25 Oct 2026 10:40:20 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec234673ebsm5783333e0c.13.2026.10.25.10.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 10:40:19 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v2 0/9] kho: add read-only Kexec Handover mode
Date: Sun, 25 Oct 2026 13:40:07 -0400
Message-ID: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0B432100008
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: jnhk1mw4mj35sq35bdb8coh7p3qqmsj5
X-HE-Tag: 1792950020-433697
X-HE-Meta: U2FsdGVkX19LgxIkWhzCSP1/SsG4SjzlA9SLIcs0uWWbb0Cw3Bc9gTCNUoz9Qoi+MPD30tbiG6JyisH8ysHSBitFw1+tEgS5xYdo/+5WjPYW6eKiCdDC71n7Nngfaiu/P5EyBrCdtzSuTZ2lh1sIRYU6giWWI95Yg7NNtls/3tdAc/HiYCYmLTwMJp+EoBmwQyXsl+XULjlww1xBx31xLCgvssvvj8t3L+YOVUskuz4/7SbuoUpv60lFdpk42ajNGW+o1iN/XF6hvsa86YOn8lZh824bz4GKikrJm58+Zy66IOUd7tzn0TFYzaoEMty2WE3LClcEiTKJ0LurxjnIlqJj3XRcseXOADd142+L1HHMhMgwnfn7qHJ5vUVF1Mk3Yb65J/xeyRf+tWszfzTXWTVbUfGsEwrjpD81jowBH/g5unPRGowkxs/HA1B/teKUGzOmy962ULJwm7yfWcQYBHMI7QYMQQW7eiZ5zUs0G6LGE42MpZkgJHjAe1ZtinOcOh9MY/ecPFHb2WwgDyyKtoaafUkfgf8U4bjeAjWdiWhAtT7CTIRJQns4mHh1kB6v3Y5kSJiEm6QfnLKlvKnJ6khnfRId3ASsTR/VVY2V4WJ5TxgTr5Yf38lyX3oDHFHOz0FBwKXEte9Lzx0bXDh6zL458E0s9paqqstZnyyXfCpk3ValvAXSdIsKbOo/QQQ3dRhmAGE8r1aIpidm0M4izQr/F7IwrYUKbrEn27xhmYTFMnIZ9QVMRIseSXzNEBj3VrOzJ6jls6eawrx1FQT83alOFZc3sYw7mY2KoCPe5dp0Nip/hv1tK90XrJgVlpFxbkG47WTggVaBlDf1Ry10sBWge4UNT25gxW4DcFXi1WdUcsVnC/NY8FMYQx2QqpWD17MlUk8VZpvMkN/WFMb54bn1NiVnvYNGJOnAn+tlPz9dBBchfo9prbpVf8a/U8rPYMrixW2gemlqiaX1oKe
 wZS6pyU4
 T4cXU05eVvW2r7a/lrBjbFnSUarozgwP2w5REKZ4JO4XlVDHGtmyvZ7dYfxDsZ8dmBSD/RY1A/zxEbBVRDrnTt1NlLnXYPRFg80085CNKgw9iw44soylUiW4QJ/N16pjCo1UtVQ0F/LDLkGtPQ3HgEa+H54OR6aaJGD3u61Hb5HfxU54ADhRTcX0Q1yDXBiIZn3D1nAYvxzxNhyYGIFjR+fQ4JgX5fyXK+J8170J9V5oWHYhuCrlkbFunGWgSgf/VPrluvZHX1EH3DkUZWHUZFZBNgtzddHdA4F4Ap1B+IptNq1SwEkOzUSmAuBCbbx6HkoUELsR8SdO79Lo/SQZq4oxLVD57QUdIUqoY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series introduces a read-only Kexec Handover mode, enabled at boot
via 'kho_ro=<pa>' pointing to the physical address of the KHO FDT.

In standard KHO, the outgoing kernel shuts down or serializes all
devices into LUO state, releases machine control, and passes the KHO
FDT physical address through the kexec_file_load() reboot path to the
next kernel, which becomes the sole "Machine Owner" (MO), initializes
struct pages for preserved folios during early boot, and reclaims KHO
metadata and preserved pages back into the page allocator as they are
restored.

In the "Linux Caretaker" (LC) model (as well as inspection kernels or
firmware), a minimal LC kernel runs concurrently on dedicated CPUs
offlined from the MO scheduler while MO is still active or undergoing a
standard KHO-preserved kexec reboot (Live Update). LC is given
read-only access to KHO so a minimal VMM inside LC can keep VMs
responsive (<30ms VM blackout time) by servicing software-only, fully
virtualized devices (such as virtio-console, pvpanic, virtio-rng, etc.)
that do not require host hardware interrupts or global machine state,
while leaving the preserved KHO tree intact for the incoming MO kernel
to retrieve normally once it boots.

LC is never MO: it has no PCI support, does not handle device
interrupts, and is booted inside a small LUO-preserved memfd region
(e.g., ~128MB of RAM on a host with terabytes of memory). Because LC's
direct map only covers its own small memory footprint (both for
isolation and to avoid struct page overhead for host memory), the KHO
FDT, radix tree, and preserved memory all reside outside of LC's direct
map. Furthermore, because LC is configured and launched from userspace
while MO is still running rather than through a kexec reboot handoff
from a shutting-down kernel, userspace reads the KHO FDT physical
address from /sys/kernel/debug/kho/out/fdt_phys and explicitly passes
'kho_ro=<pa>' on LC's kernel command line.

Both CONFIG_KEXEC_HANDOVER and CONFIG_KEXEC_HANDOVER_READONLY can be
compiled into the same kernel image, with the active mode selected at
boot via the kernel command line ('kho=on' vs 'kho_ro=<pa>'; passing
'kho_ro=<pa>' disables regular KHO).

Overview of the series:
- Patch 1 exposes the physical address of the outgoing KHO FDT via
  /sys/kernel/debug/kho/out/fdt_phys so userspace tooling can pass it
  to a 'kho_ro=<pa>' kernel.
- Patch 2 moves the shared radix-tree key encoding, indexing, leaf
  lookup (kho_radix_find_leaf()), FDT validation, and
  kho_retrieve_subtree() helpers into a shared
  kernel/liveupdate/kexec_handover_common.c compilation unit with
  declarations in kernel/liveupdate/kexec_handover_internal.h, while
  also checking that fdt_totalsize(fdt) does not exceed PAGE_SIZE in
  kho_check_fdt() and using get_unaligned() for 64-bit FDT property
  reads in kho_retrieve_subtree().
- Patch 3 hardens kho_restore_vmalloc() and factors out shared vmalloc
  helpers by introducing kho_vmalloc_validate() and kho_vmalloc_walk()
  in kernel/liveupdate/kexec_handover_common.c to validate the
  preservation metadata header and walk the chunk list.
- Patch 4 avoids modifying ser->next and bs->head_pa in kho_block_add()
  and kho_block_set_shrink_one() when operating on an incoming block
  set, as the chain is already linked and incoming blocks must not be
  modified in KHO read-only mode.
- Patch 5 adds CONFIG_KEXEC_HANDOVER_READONLY and
  kernel/liveupdate/kexec_handover_ro.c. When booted with
  'kho_ro=<pa>', the KHO FDT is mapped and validated once in an
  early_initcall, and radix-tree nodes, leaves, and folio/vmalloc
  mappings are cached on first visit in a unified RCU-protected hash
  table for the lifetime of the read-only KHO kernel, providing
  kho_is_ro(), kho_ro_lookup_folio_order(), kho_ro_map_folio(), and
  kho_ro_map_vmalloc().
- Patch 6 wires read-only KHO mode into KHO core (kho_populate(),
  kho_memory_init(), and kho_retrieve_subtree()).
- Patch 7 updates kho_block to map incoming serialized blocks read-only
  via kho_ro_map_folio() in read-only KHO mode.
- Patches 8 and 9 extend test_kho and tools/testing/selftests/kho/vmtest.sh
  to build a single kernel with both CONFIG_KEXEC_HANDOVER=y and
  CONFIG_KEXEC_HANDOVER_READONLY=y and test both standard KHO and
  read-only KHO handover when preserved memory lies outside the boot
  kernel's initial memory range on x86_64 and arm64.

This series is based on liveupdate/next commit 27be83a12b24 ("Merge
branch 'lu-pci-preservation' into next").

Changelog:
v2:
- Expand the cover letter with the LC architecture, explaining why
  'kho_ro=<pa>' takes the FDT physical address on the command line and
  describing the expected users of the read-only KHO APIs (Suggested by
  Mike Rapoport).
- Patch 2 (Suggested by Mike Rapoport):
  - Move the shared radix-tree, FDT, and subtree retrieval helpers into
    a dedicated kernel/liveupdate/kexec_handover_common.c file instead
    of static inline functions in
    kernel/liveupdate/kexec_handover_internal.h, and factor out
    kho_radix_find_leaf() for radix leaf lookup.
  - Check that fdt_totalsize(fdt) does not exceed PAGE_SIZE in
    kho_check_fdt(), drop the "setup: " log prefix from FDT validation
    warnings, and use get_unaligned() when reading 64-bit FDT properties
    in kho_retrieve_subtree().
- Patch 3:
  - Move kho_flags_to_vmalloc() to kexec_handover_common.c alongside
    kho_vmalloc_validate() and add a shared kho_vmalloc_walk() chunk
    walker used by both kho_restore_vmalloc() and kho_ro_map_vmalloc().
- Patches 5 and 6:
  - Allow CONFIG_KEXEC_HANDOVER and CONFIG_KEXEC_HANDOVER_READONLY to be
    compiled into the same kernel image and select the active mode via
    the kernel command line ('kho_ro=<pa>' forces regular KHO disabled).
  - Split the KHO core integration (kho_populate(), kho_memory_init(),
    and kho_retrieve_subtree()) into a separate patch (Patch 6) so
    Patch 5 only introduces the read-only KHO backend.
  - Map and validate the KHO FDT and preserved-memory-map root once in
    an early_initcall so kho_ro_get_fdt() and kho_retrieve_subtree() do
    not sleep or map lazily.
  - Replace kho_ro_restore_vmalloc() (which allocated RAM and copied
    pages) with kho_ro_map_vmalloc() to map preserved kho_vmalloc
    regions read-only in place using kho_vmalloc_walk().
  - Cache radix-tree node, leaf, folio, and vmalloc mappings in a
    unified RCU-protected hash table (kho_ro_map_ht) keyed by address,
    size, and protection for the lifetime of the read-only KHO kernel,
    and drop kho_ro_unmap().
- Patch 9:
  - Build the kernel and initrd only once in vmtest.sh with both
    CONFIG_KEXEC_HANDOVER=y and CONFIG_KEXEC_HANDOVER_READONLY=y
    enabled, running both the standard KHO test and the read-only KHO
    test on the same kernel image.
Link: https://lore.kernel.org/all/20261019021111.990394-1-pasha.tatashin@soleen.com/ # v1

Pasha Tatashin (9):
  kho: expose physical address of outgoing FDT
  kho: move radix tree and FDT helpers to common file
  kho: validate preservation metadata in kho_restore_vmalloc()
  kho: do not modify incoming serialized blocks
  kho: add read-only Kexec Handover mode
  kho: support read-only KHO mode in KHO core
  kho: support read-only KHO mode in kho_block
  kho: test: support read-only KHO mode in test_kho
  selftests: kho: add read-only KHO test to vmtest.sh

 .../admin-guide/kernel-parameters.txt         |   8 +
 Documentation/admin-guide/mm/kho.rst          |   3 +
 Documentation/core-api/kho/index.rst          |   6 +
 include/linux/kexec_handover.h                |  44 +-
 kernel/liveupdate/Kconfig                     |  10 +
 kernel/liveupdate/Makefile                    |   3 +-
 kernel/liveupdate/kexec_handover.c            | 284 +++---------
 kernel/liveupdate/kexec_handover_common.c     | 298 ++++++++++++
 kernel/liveupdate/kexec_handover_debugfs.c    |  22 +-
 kernel/liveupdate/kexec_handover_internal.h   |  47 +-
 kernel/liveupdate/kexec_handover_ro.c         | 429 ++++++++++++++++++
 kernel/liveupdate/kho_block.c                 |  78 +++-
 lib/Kconfig.debug                             |   2 +-
 lib/test_kho.c                                |  71 ++-
 tools/testing/selftests/kho/arm64.conf        |   1 +
 tools/testing/selftests/kho/init.c            |  38 +-
 tools/testing/selftests/kho/vmtest.sh         |  65 ++-
 tools/testing/selftests/kho/x86.conf          |   1 +
 18 files changed, 1121 insertions(+), 289 deletions(-)
 create mode 100644 kernel/liveupdate/kexec_handover_common.c
 create mode 100644 kernel/liveupdate/kexec_handover_ro.c


base-commit: 27be83a12b246b6b3783e7d3ac5c378ff7520f25
-- 
2.56.0.307.g5fe7bd680c-goog


