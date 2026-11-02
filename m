Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CD8560E34E4
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=h1K3YNcS
Received: by kanga.kvack.org (Postfix)
	id B225F6B0640; Mon,  2 Nov 2026 10:37:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD3736B0641; Mon,  2 Nov 2026 10:37:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99AC56B0642; Mon,  2 Nov 2026 10:37:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F24A6B0640
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1322B40010
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:03 +0000 (UTC)
X-FDA: 85390582326.03.5AACFAC
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf12.hostedemail.com (Postfix) with ESMTP id 59F1D40002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=h1K3YNcS;
	spf=pass (imf12.hostedemail.com: domain of 3G67oagcKCHgrelejodckkcha.Ykihejqt-iigrWYg.knc@flex--vipinsh.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3G67oagcKCHgrelejodckkcha.Ykihejqt-iigrWYg.knc@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633821;
	b=hiTD/oxn/K0A86S0MOaC9gfIjWVQvgR4Rolv30hTCVg9WFjrIt84LjGKnALSjt7mJ0XVfU
	PeLZjXSsqxjQnWhE1ulVaq+siTtmJFZ+Qr/LmMJUR69xcfeE1zDLlfeOaCa5v4r53lY5+r
	YBx6MAXtGLW18lfN4iix6HtwtaXGhcQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=h1K3YNcS;
	spf=pass (imf12.hostedemail.com: domain of 3G67oagcKCHgrelejodckkcha.Ykihejqt-iigrWYg.knc@flex--vipinsh.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3G67oagcKCHgrelejodckkcha.Ykihejqt-iigrWYg.knc@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iSMn9Luik8JQySxKW5TZdiPLSp0bOJ1EGPPjD/yQ8D8=;
	b=dxco9La6yHZ8p/PobkgtwfgUv5k/NZyWRGaN0trUYif/bMouvjWvipGd/mIe712KNNmi2b
	u7Q2U5fh6fUCvvXbvoQ4TNqXZSp/gZwNEm4DStWPrazjNt39PFSms3KiG6Na0mmVYqaVEM
	GyWqLMhbElDBIQs13ztrnDhHVLOMaww=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc7e92f36f9so2369464a12.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633820; x=1794238620; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iSMn9Luik8JQySxKW5TZdiPLSp0bOJ1EGPPjD/yQ8D8=;
        b=h1K3YNcSM6axFE3VWFTtWYYuoFuEGmy08AXV42/dkisDYnGOg5yNC8utR7kTks2Chi
         wZJ6PRkPFk32GzXo1NU5SZRZSSndKnFM4bx9V1/O1fYM89L4Z02ppvJfvKYJ28kM3dGg
         Xq/4KZbKj/5KJ9HbLVZ0H6zJ1Q/Awj6Ih5z9LOo2lT3rDSKIyq88Bkfih8jYMAmZVfqX
         yYM+0ICd4beEUwgz2S5CAhDwQGz4SxYHklCQ27Qw2UC0UJkA3Q84OyxKIeTF5JV9i7Aw
         b/CmW1pp1oJx/IHy/M+wVnHyBfAWLs+E1BoE0LJ0khq6bSlB4AD7saRkCbu0EvTKJ7fB
         I0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633820; x=1794238620;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iSMn9Luik8JQySxKW5TZdiPLSp0bOJ1EGPPjD/yQ8D8=;
        b=CN5CZgaLTCZLDVHVolVqJLBMdR7MwXzZ401XltTq+e5xgR37zueS5Xt2sfiJUq4gDZ
         U/bMGf+QGrTgTxJSPvl6skxuWH2aOpF6d4RBQSUyPHb4Dc30JcossLu4fvYgMKJEx4Im
         9dYfZ02BoISqzQLnzO4ipLCXtJ2J0+eOceuSxVf9K0iFPudYpz3Q/A/9rInHj9szuNBd
         pPW72T//zoeOBdlRPuHCtGrsS57JvXq1d3eOQByyixyNIZFVLFGfyHS3mR8GFJqE6ncI
         tkywKdMb8i9GcjiX4qlk94PXVSyhRfY41THaadFRP20OKDVoSb3H7+omUKWLTHJV0FNp
         gaEQ==
X-Forwarded-Encrypted: i=1; AKwUvBy99h5B+bKan+cB9gT0h0W4D44AEwb2tpmYVhxU3JzFg/2WCLlkU86egRsCtt7MoM6QkqhgDUX28w==@kvack.org
X-Gm-Message-State: APuU4Z9H32taTYntPGHxBc5opErQkb5jTBtKmSGP42RU8GYO3Jj9ZeGH
	ClqNGhVjRQdN+EwQyx/+xAYxUYE65OSSwg3yXCgxBQXZa8gEWTvL+ZAl6kBFfhSNsspzWyZAU9q
	6Usyw4mELoQ==
X-Received: from pjbir10.prod.google.com ([2002:a17:90b:468a:b0:3aa:ee30:1a77])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a8b:b0:3ab:884b:65b7
 with SMTP id 98e67ed59e1d1-3ae89814e34mr8631702a91.25.1793633819867; Mon, 02
 Nov 2026 07:36:59 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:29 -0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-1-vipinsh@google.com>
Subject: [PATCH v6 00/27] VFIO PCI Live Update (noiommu mode)
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: gerggogtpaa4mj3jyqhgwf96yejfgah6
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 59F1D40002
X-Rspam-User: 
X-HE-Tag: 1793633821-948030
X-HE-Meta: U2FsdGVkX18IQoeqFXzS2+5fRzIbZiTY+WYLFKdMFmXByAbE8heH1S/I0D5Uy+QT9dZax5lINEiWHCswn/kslEKX7ha3Uvkn7OyCI9ZuaDDjYSMGhhXDtQV+7PfBxwkzTctMEEpNqHHLGopDNQFxhvgIH0Joxay3oH7uh2DnS3SNi9C3v9Jmis5KfZs1Aivs+2+WfsLsfBQo8qnaYhmQ1swNh+SDR17nMVdD0QialM+Vup8RpYbDuTVOsxwita2oVBJI6WwDQM7GEzU7WBzTcBVe72giWiGesoeIU1XqXQlLOgYbCkDSEI84wlAEPGb8vdCZcO5n/yk6Ee58yahiyTuASDYmrH/RJphRwbBNdU3HRcweNH4667yfHl6ts7m08nNhg/ps3MD04ViQk0urNdvQP7Dd9n2bYOVGc+d7t9FnAfKjAKn0GKCC0uqoee9eI+VEKS2YPnOq9XiIvM4t72jROF+HHQzNCQtrxlUObvu134WeYbdJFl1k/4lwglierMfRcbH4/uUKCXrglRvfWHOH6pQ0Sfrw1mXgnq3zigZGrLU0z+dMhKjTTf/45IF2dY3uc0QSfWCK/GrTO20ITwPKMqqj4aOPnBLdhtfZGaHlT/COa3LmzQipqph/dPycCdzx3V3kJwy7sdxwVQXZbDJGX6oqrqT/8Yu/nL2V0HDewTw1Mfm6cNyM/JsBoVPbmkJZNLiqc4GKMVn0gCcPrsxFZ43hma6+3n4iZ+z1USAiWoWTsRO5COlIS9gVNziV3Lo3HlB0Twi4A9V4ZK41wCPx/faCkJBY3A1bEBbVBwsStXXKTzOxnwE3fdzPWKTKNyqOnI/SOKNEFU2iA36GLU6LUkV2Ynbt/TBcz01/2XV+00Z3hxAbpOc6KP69ERC6gkk9tESDgZYePHexTV30eiAP5NYfB1OBX9YP186T4Zj1lZsvtROOcp3ByGYHWoeiOCnz+Oncc4cpMzsvBoQ
 4O6oG3xx
 /23jTsIbK7Zu2UgCrOpkyJVEq6MTZEmA4O+rmD+VNi6iA+lLF+YpBB7WoaNF1ABAkkqSupXll6rQimMVtrLB32XumVlvCSBNa813SH4j8lOJnFaex+8FFsI9uwl4dn9wTHPTirskgCILXm3UTRk9FP+besgfOvlObHp5PndpcuFp6wvV8Ruq490C3a7mKeWBvxsAe5CRqJykCBiyX5dB0JX8YMR0S3Gr7AAuQgTN19WoYLw9ZecWB1x4rLyUcWQOxiNkDcLX62FD7tOPdijDJEApuGAvr6mut7fv2pN6qLCDdsIjJKk9xRg6//cVpLyI1bBqQXoD2a4w8vWiDntdMajhkQkJmyhPdCbq1SLmSNawsaBQTeWUCisTxlXhJYs7qiQAbwhyJO2X22kMcCjM6HK7ai+e7zh2PktC292Ff8IX4LCDKKbQ+OR+I+9Ni24F9qxpFUfadhBPHPHFNPuOz4SyMxl4uXCoInDmMvVBinohpFfTzw5yOnz9AgviLySv/TT5R5WZUsvTOvDnPnTuYg24k6foduDijRYYhNRcERIY9eDi/l+rSbXtWpxin03ylIZqHfzRorRZSt8IG2lOo7sJwLNo0IEOJSXqkfO0wDldOIpDjrjwPpXUYWaCL6fwFF1Z8Bk5eDkosO3G59WSA7TXfsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series adds a fully working Live Update support for vfio-pci
devices in noiommu mode, using the Live Update Orchestrator (LUO) and
Kexec HandOver (KHO).

This series can also be found on GitHub:
  https://github.com/shvipin/linux/tree/vfio/liveupdate/v6

Unlike v5, which reset the device in freeze() and required userspace to
re-initialize it after kexec, v6 keeps a preserved device running across
the kexec: it is not reset, bus mastering and memory decode stay enabled,
it stays in D0, and in-flight DMA continues into preserved memory (e.g. a
LUO-preserved shmem memfd). In the new kernel, userspace retrieves the
device FD from its LUO session and takes over the running device without
resetting it on the first VFIO_DEVICE_BIND_IOMMUFD.

Preserving IOMMU-backed devices is refused with -EOPNOTSUPP until LUO can
preserve IOMMU state; group/container FDs and unbound cdev FDs are refused
with -ENOENT.

This series is built on top of PCI Live Update series version v10:
  https://lore.kernel.org/linux-pci/20261013162529.1928093-1-dmatlack@google.com/

Design
======

- Preserve: only a bound noiommu vfio-pci cdev FD can be preserved (no
  VFs, Intel display devices, or zdev). The device is registered with PCI
  Live Update and its pre-open struct pci_saved_state is serialized into
  a versioned KHO buffer ("vfio-pci-v1").

- Freeze/unfreeze: freeze() requires interrupts to be disabled, the
  device to be in D0, and SR-IOV to be disabled (VFs are not preserved).
  It snapshots vconfig and pci_config_map, and masks physical INTx while
  leaving bus mastering enabled. If the kexec is aborted, unfreeze()
  restores INTx and the existing FD keeps working.

- Early protection in the new kernel: an incoming device is kept out of
  runtime D3, sibling dev_set resets are blocked, and opening it via its
  cdev or VFIO_GROUP_GET_DEVICE_FD fails with -EBUSY until the session is
  finished. If the new kernel is not in noiommu mode, bus mastering is
  cleared at registration.

- Retrieve and take-over: LIVEUPDATE_SESSION_RETRIEVE_FD validates the
  serialized state against the hardware and returns an unbound cdev FD.
  The first VFIO_DEVICE_BIND_IOMMUFD takes over the device without
  clearing bus mastering, resetting, or re-saving its state, restores the
  preserved vconfig, and keeps the original saved state so that normal
  reset/restore applies when the FD is closed.

- Unclaimed devices: if the session is finished or closed without taking
  over the device (not retrieved, retrieved but not bound, unbound, or
  driverless), the kernel logs one pci_warn(), resets the device, and
  restores its pre-Live-Update state.

- DMA memory ordering: a running device keeps DMAing until it is taken
  over or reset, so its DMA memory must stay pinned until then. LUO
  finishes files in LIFO order, so userspace must preserve the DMA memory
  (e.g. a memfd) in the same session and before the device. This is
  documented in Documentation/driver-api/vfio_pci_liveupdate.rst.

Testing
=======

- QEMU with an emulated igb device in noiommu mode, across real
  kexec reboots: vfio_pci_liveupdate_uapi_test and
  vfio_pci_liveupdate_kexec_test (opens fail with -EBUSY, memfd stays at
  the same physical addresses, pre-kexec DMA completes after take-over,
  and new DMA works without re-init).
- Physical Intel hosts with DSA (8086:0b25), across real kexec
  reboots: vfio_pci_liveupdate_kexec_test with DMA started just before
  the kexec (opens fail with -EBUSY, memfd stays at the same physical
  addresses, pre-kexec DMA completes correctly after take-over, and new
  DMA works without re-init).


  $ ./setup.sh 0000:6a:01.0
  $ ./vfio_pci_liveupdate_kexec_test -s 1 0000:6a:01.0
  $ kexec --reuse-cmdline -l -s /boot/vmlinuz
  $ kexec -e
  $ ./setup.sh 0000:6a:01.0
  $ ./vfio_pci_liveupdate_kexec_test -s 2 0000:6a:01.0

AI disclosure
=============

New and reworked patches were developed with LLM assistance. Assisted-by
is not needed now in linux kernel but I thought I should at least
disclose this in cover letter.

v6:

- Keep noiommu devices running across kexec and take them over without
  reset, instead of resetting them in freeze().
- Restrict preservation to bound noiommu cdev FDs.
- Add PCI helpers to serialize and restore struct pci_saved_state.
- Add unfreeze() and close races between freeze() and ioctl/config
  access. Refuse freeze() while SR-IOV is enabled, and refuse enabling
  SR-IOV on a frozen device.
- Protect incoming devices in the new kernel until they finish Live
  Update; reset unclaimed devices in finish() with a single pci_warn().
  retrieve() and finish() look the device up under the device lock, so
  they never act on a device that vfio-pci is still probing.
- Fix vfio_pci_liveupdate_init() error handling to avoid a double
  unregister at module exit (reported by Sashiko on v5).
- Drop "vfio/pci: Export vfio_pci_dma_buf_move for vfio-pci module",
  "vfio: selftests: Expose iommu_modes to tests", and exports that were
  only needed by the v5 reset path.
- Update the VFIO PCI and PCI Live Update documentation.
- Selftests: add an iommufd noiommu mode, IOVA == PA mapping helpers,
  2MB THP memfd helpers, an attach() driver op (igb, DSA), and a kexec
  test with DMA running across the Live Update.

v5: https://lore.kernel.org/kvm/20260714151505.3466855-1-vipinsh@google.com/
v4: https://lore.kernel.org/kvm/20260511234802.2280368-1-vipinsh@google.com/
v3: https://lore.kernel.org/kvm/20260323235817.1960573-1-dmatlack@google.com/
v2: https://lore.kernel.org/kvm/20260129212510.967611-1-dmatlack@google.com/
v1: https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/
rfc: https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/

David Matlack (4):
  vfio: Enforce preserved devices are retrieved via
    LIVEUPDATE_SESSION_RETRIEVE_FD
  docs: liveupdate: Add documentation for VFIO PCI
  vfio: selftests: Add vfio_pci_liveupdate_uapi_test
  vfio: selftests: Add Makefile support for TEST_GEN_PROGS_EXTENDED

Vipin Sharma (23):
  vfio/pci: Factor out the reset logic in VFIO PCI device close path
  vfio: Export various helpers from VFIO
  liveupdate: Export symbols needed by modules
  vfio/pci: Register a file handler with Live Update Orchestrator
  PCI: liveupdate: Add helpers to preserve struct pci_saved_state
  vfio: Add helpers to identify device files that can be preserved
  vfio/pci: Preserve vfio-pci device files across Live Update
  vfio: Introduce vfio_find_device() helper
  vfio: Refactor vfio_device_fops_cdev_open()
  vfio: Add API to open cdev device for Live Update restore
  vfio/pci: Retrieve preserved device files after Live Update
  vfio/pci: Protect incoming preserved devices until they finish Live
    Update
  vfio/pci: Take over preserved devices without resetting them
  vfio: selftests: Build liveupdate library in VFIO selftests
  vfio: selftests: Initialize vfio_pci_device using a VFIO cdev FD
  vfio: selftests: Add iommufd noiommu mode
  vfio: selftests: Add helpers to map DMA memory at IOVA == PA in
    noiommu mode
  vfio: selftests: Add helpers for Live Update DMA memory and sysfs
    state
  vfio: selftests: Add an attach() driver op
  vfio: selftests: Test preserving noiommu devices in
    vfio_pci_liveupdate_uapi_test
  vfio: selftests: Add vfio_pci_liveupdate_kexec_test
  vfio: selftests: Verify that opening VFIO device fails during Live
    Update
  vfio: selftests: Add continuous DMA to vfio_pci_liveupdate_kexec_test

 Documentation/PCI/liveupdate.rst              |   3 +
 Documentation/core-api/liveupdate.rst         |   1 +
 .../driver-api/vfio_pci_liveupdate.rst        |  25 +
 MAINTAINERS                                   |   2 +
 drivers/pci/liveupdate.c                      | 223 ++++++
 drivers/pci/pci.c                             |   5 -
 drivers/pci/pci.h                             |   6 +
 drivers/vfio/device_cdev.c                    |  87 +-
 drivers/vfio/group.c                          |   9 +
 drivers/vfio/pci/Kconfig                      |  11 +
 drivers/vfio/pci/Makefile                     |   1 +
 drivers/vfio/pci/vfio_pci.c                   |  14 +-
 drivers/vfio/pci/vfio_pci_config.c            |  19 +-
 drivers/vfio/pci/vfio_pci_core.c              | 348 ++++++--
 drivers/vfio/pci/vfio_pci_intrs.c             |   4 +-
 drivers/vfio/pci/vfio_pci_liveupdate.c        | 745 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h              | 177 +++++
 drivers/vfio/vfio.h                           |  28 +-
 drivers/vfio/vfio_main.c                      |  85 +-
 include/linux/kho/abi/pci.h                   |  47 ++
 include/linux/kho/abi/vfio_pci.h              |  76 ++
 include/linux/pci_liveupdate.h                |   7 +
 include/linux/vfio.h                          |  19 +
 include/linux/vfio_pci_core.h                 |  11 +
 kernel/liveupdate/luo_file.c                  |   2 +
 tools/testing/selftests/vfio/Makefile         |  23 +-
 .../selftests/vfio/lib/drivers/dsa/dsa.c      |  35 +-
 .../selftests/vfio/lib/drivers/igb/igb.c      |  39 +-
 .../selftests/vfio/lib/include/libvfio.h      |   3 +
 .../vfio/lib/include/libvfio/iommu.h          |  43 +
 .../vfio/lib/include/libvfio/sysfs.h          |   1 +
 .../lib/include/libvfio/vfio_pci_device.h     |  10 +
 .../lib/include/libvfio/vfio_pci_driver.h     |  17 +
 tools/testing/selftests/vfio/lib/iommu.c      |  70 +-
 tools/testing/selftests/vfio/lib/libvfio.c    |  54 ++
 tools/testing/selftests/vfio/lib/sysfs.c      |  22 +-
 .../selftests/vfio/lib/vfio_pci_device.c      |  56 +-
 .../selftests/vfio/lib/vfio_pci_driver.c      |  22 +-
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 388 +++++++++
 .../vfio/vfio_pci_liveupdate_uapi_test.c      | 227 ++++++
 40 files changed, 2826 insertions(+), 139 deletions(-)
 create mode 100644 Documentation/driver-api/vfio_pci_liveupdate.rst
 create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
 create mode 100644 include/linux/kho/abi/vfio_pci.h
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c


base-commit: 312200e9211ede3f9a03cc17d094805e06e4674e
-- 
2.56.0.317.g454f8302e1-goog


