Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E291606A339
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 21:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=gcUmKaTG
Received: by kanga.kvack.org (Postfix)
	id 75A1A6B05B1; Wed, 11 Nov 2026 16:10:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70AC96B05B2; Wed, 11 Nov 2026 16:10:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FA016B05B3; Wed, 11 Nov 2026 16:10:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29E2E6B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:10:42 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 960F2140429
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:10:41 +0000 (UTC)
X-FDA: 85424082282.17.85FC996
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id C201740008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:10:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gcUmKaTG;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794431439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=r8AUQA6KaaSP0401Cp0Pm+i8FjqoJHWRTLuh0q617+w=;
	b=BtsvgnDdtqu5cY3ByOXdgXtxDaxG2XVE/0enW3O5HuXILkFraZF9cx3G1ClX2WDjgZHpKf
	VF4SstvRAvZxEQAViGGdIpsXT8NyymY2bBM0hio1l41I9tLcXvhwwELYyMOeEu+OgKbg+L
	jWcfEuG3lnuw60UciCNXOKyQO3qgyUA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gcUmKaTG;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794431439;
	b=iBvGzXNrqse+/Y3EUD/36he+edwUdDAvT2Snir20dNWWCPxU7KIf1qvnRS2sbCBKN6qPkx
	TW1EDO+HtGAFkI7zTOrVsCkX2xmyj7jRF/5LPObHPUHLVS8EaM8ia6sJL2WlINiwxihAWF
	rvdMaP0FRFZYz1ocAAZzC/zcmXynhLo=
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-7d2da1667b2so1810154137.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794431439; x=1795036239; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r8AUQA6KaaSP0401Cp0Pm+i8FjqoJHWRTLuh0q617+w=;
        b=gcUmKaTGK8H3rbFZbvrvzKO8vKy0e2cfmFN+oaaTPR5s0yCVo8LARFv2AuzipLxc1f
         6XTfZnbEOS6lemAQWmv9DJBIjbTfI0BGIbUeKjFANfY45nCenemmw3yX7hq5eGOaDEZx
         I09HiaQR0HTi5xrQSyswEGM1auYNgg8WfJnMENJT6ukKvHoNjJxkh7Zmaysfn2amyl+q
         xBcNkIKP7MAnzsi2EL0DL0vyt7WtlLJZFE0cLFExTaDm6FK4kGhXPowI+t6rSP9tpZli
         /AwfaST84NbSXJ2ctPnzIGbNVZ5UpRxSvjaLkRaKN5DxWojAgtY8F4uINoRVFZdEQY6j
         yjSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794431439; x=1795036239;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r8AUQA6KaaSP0401Cp0Pm+i8FjqoJHWRTLuh0q617+w=;
        b=nO90CgG3FoZUqfT9kUhLJhh9ASH+WKhKH06fbE/J8y/eN3gb54yb+S1UMDke/atGNR
         TF2JDzQJxLTDBww0q7MLtlo5kfGwhfa5SZnxWA1uJwqKXJzPJjG8YfemApHSsKv1/x8h
         rj9dXEMjDnkxt6iDTuutO2/ZR9LejcQX43HGaicA3/kBhHv4oftoZPR65r9hz/HQRSqC
         DFdn8hwHe3HnuxNcWM+E1dNCFSW6BqCYjbg7WzcXp22oGMZiRSGQKQKn0ED0ajUhoOu0
         SP9lpsqoEwPBtFK7TP7/iUO7R1DOxwe1OHJc+QkrsXTxyvVrzKsOjkIEISNUQUneCLIL
         b5nQ==
X-Forwarded-Encrypted: i=1; AL+hErHEFeV3L3n2yHU9j4Wor5lbLWq7z08trLh3WJ6bO46I0SboNMazUap/rg489rqxf6KmzTarUknwsQ==@kvack.org
X-Gm-Message-State: APuU4Z/3AiNsgRHzFDoPGdkGtQwnW5y6TWOIcK4VnPcwiKRscSvpZfIR
	4gn2qPvcjSLH049vXi0PeHIaHgw1jkjnZ0f1pMSwfNbK/J/Sp9mSeshktPsgziDITHA=
X-Gm-Gg: AYBFou3EGGJIf+W2hsdlLOVdvfikGcZWgpJMZyoHvkRiYgP5XD7DFci05OLY4Vz8S7H
	5Hdq0C+fuWKbPPuaI4dqqGG6Np1oFZKhTQlQ0s8pIwAY62Xsl/P+0cwIxs/mykcz/KsBWXMSFab
	+YzivQDS9Y6aFsJwHWdbH3IUb72pxb/bf/6TVsgx1xcke+ofCLQLnFRaYVZLjBXMCd3KajPicML
	EPzCtnyU+c8MPLfihwqIU9VflVx1C9DjccZjDBSUE4iMHskk7Nmm7BkHY/sYZzlYxEsAU3fy28X
	0zY3zjA/FLPSyKJVscRLU1iFSyzXZsrsQLDAcYTleBNQs4uElViFdmdU0NABUyuPESgxW40gYTr
	ikAd3KcgTHDLCiDcSnQEqWvKllhngc1rIZGLPxRKTgBF7NXSg6uMWQTSEXYVpAYj+8WY4Uf0BHW
	DA2g7gpUlF6bKlKIVQ/ruqXDQJZw+fvsRZEh8FFNNWj2Z9qUe4gWeDjTWSr1vXGE5+izg7kWzSu
	ZCVfPlgwwLJ0Vtf9gJwDdAEhFVOHd+aunlnwEzR4dYhcgq6ltrhY+SOZXUOCyPADzT9TMhbhH+v
	YtjXUA/tRMHp8FCRZPSogNruIlL/Qa7HidPrYthi5+8S2siqRBMVhADL3tVPNzrP/rQj4nbLYFs
	FD6Ff+p2jnPYkvTgArQODhWi1/BqljFbDMftLJa4j23tNr76rpMb8
X-Received: by 2002:a05:6102:4496:b0:7c3:1395:a090 with SMTP id ada2fe7eead31-7d4fb2a592fmr1781381137.6.1794431438861;
        Wed, 11 Nov 2026 13:10:38 -0800 (PST)
Received: from soleen.c.googlers.com.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d3023847absm4914038137.8.2026.11.11.13.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 13:10:38 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	"Andersen, Tycho" <Tycho.Andersen@amd.com>,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Matlack <dmatlack@google.com>,
	"Heyne, Maximillian" <mheyne@amazon.de>,
	James Gowans <jgowans@amazon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Praveen Kumar <kpraveen.lkml@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	"Woodhouse, David" <dwmw@amazon.co.uk>,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [Hypervisor Live Update] Notes from November 2, 2026
Date: Wed, 11 Nov 2026 16:10:30 -0500
Message-ID: <20261111211035.3297484-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.567.gdb80ae8cd5-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C201740008
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: y84zuf6z61muwcndd7jnr1b51t1nkpjx
X-HE-Tag: 1794431439-508170
X-HE-Meta: U2FsdGVkX1894qoflycjziXJMyUOYg7M/8MvmldoTxt94A1mvSL2xk9wa7KD2PxdB912iOjGFWtB8d5CuVUnGOC28pIa14lpchYvavijjXb+xieUblnYZeqk6Ol1m4JAeh0ZvY9NqmW1DxM5Lsu9cNFZ5Y5PiAXkB/wmEB1K2WrbKMGB/zhns052RdI+IzpeLXu/Cya3fV6HcvIYecJ2P0uEzAkw3lmKpmTTy+6vU8JZJQNF8ZCZDb+waeXHVA4/ccxytDiucYst5cFTHqBzx38l2iXA3vcxIcM5xfti6mPhpGtZBBJvzgUsjhZmy0LvHYI9smNRVZqpK+lu4nO6PrTV/tKwIBlD1QJqs4/W6Py185av87oQ8CcgqnxISQOxqPbb93ahO7laSu0SMbU3bu5hbLK51DEYlsjRITmNw3p6OhPAB42YNbk+liLxHJVMc+eWS7HW8hUgu7O0ANtnx+sr3cBXEG+QEUgh2u20BcmbyhKnEZ6q+A5L9tGM/Zv7uiMk6/GFs/RwaAhE1oTzv0t+rDx3X/STWLflAwcefCJGqRwx3yT9PXhBN/pE7B3VYNdVpqoVlIyO/siW7XnRJKQP9x+Eddi6QmSGaVNBFIupPezYJ/Fm7w9fVZ4RnqcDLZ40UdPYHuPPS+g670xAsNB5B8Ep9jiMUVPG8CkZHNp+B986Y6LdWtKXImaGwI4H73cLCs6ZfkmmWBVChMa7l6CXC79v6c/nYibj/ig+v+XoKdckTRDt16qLyZG+5dlRnLbOfX33jVUy7vCan4w1RhiHIOomdIK2Qk8pS6ySR8v4ZyrO4TU4d38Fn3d9zMmrITOUrTzoOcd6cUcXMQI0cU3drOHeSXr28K0d/ux3ShIoGmm9eX+wPByeCqJzgqdTTDUxfLz8EoReYj6cbfyemdIi7gHSVUiooySrreZvDO460my48rJ423DclK9afEBlKQieIFPDEeXyhTa6SRw
 A4JgdioF
 bxCUPu7KAjtPKVJaTEun0rlhZAF4eFGsaK5gAUi/1ldrhMRFQDqudmOsL9E+X60SaWigmbdW4G93zawrH0dpWjWTL7gAcd7KDQYLmxPjHGb4LfTSVZVGy85Qpx7IIKzg1RpYQPhceEpM6KjjqE4cjEYwFltGy1YUgibk6/nQHUfaMNvRFxr5xSlSRSRK124dHodncbdhjT22Ta++yL/woISrDkR8og61orC8YQ4qsKKet7vAqmMSMujcMGnb2EwDXql18Jz3IXVCcRvlIp4iN5MqARZAZGb9FNKbGuLBy6m90hAhsYxUVE17hY7YBECdkn0XO7mlZ4BeTZ6TBrooveA/0TZPX1Lx1YU32XpM7bjUNYLLYeve5C0Mf6nvEElRfgma1q74kmT3/wLn/12Nv8XGy/O4Ez/dw8kIklQohW3YYz8XlGswtGP9tlDEnHDzulzE9oSrJtDKsa8fM8vL0qkCIGrX1fk2ZTC9tecZuSHXRu2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi everybody,

Here are the notes from our Hypervisor Live Update call held on November 2.
These notes are intended to bring those who could not attend up to speed
and to keep the momentum going between meetings.

----->o-----
Orphaned VMs & Linux Caretaker

* Shift to Specialized Full Linux Caretaker: Evolving the Orphaned VMs RFC
  architecture presented at LPC:

  https://lore.kernel.org/all/20260920193650.3373435-1-pasha.tatashin@soleen.com

  Pasha moved from a standalone KVM-only caretaker runtime to a specialized
  full Linux caretaker kernel. Using Linux directly avoids reimplementing and
  abstracting KVM execution logic in a separate environment and enables
  handling VMM-level VM exits (including select virtio exits such as pvpanic).
  To stay lightweight and isolated, the caretaker boots strictly within its
  assigned memory and physical CPUs—skipping PCI discovery and device access
  entirely and leaving the global KHO tree owned by the host machine owner.

* Supporting Upstream Series:
  - CPU Hotplug Performance Improvements: Standalone series accelerating CPU
    offlining and onlining to reduce physical CPU transfer blackout time
    between the host and caretaker domains:
    https://lore.kernel.org/all/20261019011446.834487-1-pasha.tatashin@soleen.com
  - Read-Only KHO: Introduces a read-only KHO mode for the caretaker kernel
    (currently awaiting upstream review):
    https://lore.kernel.org/all/20261025174017.3870481-1-pasha.tatashin@soleen.com
    Following discussions with Pratyush Yadav and Mike Rapoport, Pasha will
    continue enforcing that KHO-preserved memory outside the caretaker's own
    RAM is excluded from its direct map and mapped read-only on demand,
    preventing accidental KHO modification and avoiding unscalable direct-map
    / struct page exceptions. Read-only memfd changes (previously prototyped
    solely to exercise an end-to-end selftest) will stay separate while core
    read-only KHO is reviewed.
  - Early Session Freeze (LIVEUPDATE_SESSION_FREEZE): v4 is posted upstream:
    https://lore.kernel.org/all/20261026014948.162559-1-pasha.tatashin@soleen.com/

* Caretaker Handover Lifecycle & Session Pinning: Pasha walked through the
  caretaker lifecycle: a global session (e.g., session_lc) holds the
  caretaker's preserved physical CPUs and boot RAM memfd. On the outgoing
  path, the VMM suspends the VM, freezes its LUO session (resolving circular
  FD dependencies and committing metadata to KHO), and tells the caretaker to
  look up the session by name; on the incoming path after kexec, userspace
  stops the caretaker before retrieving and resuming the VM session. Pasha
  discussed adding an optional LIVEUPDATE_SESSION_FREEZE_COMMIT flag (avoiding
  "_IRREVOCABLE" in case an explicit LIVEUPDATE_CMD_SESSION_UNFREEZE ioctl is
  added later) so frozen sessions remain committed in LUO if the VMM exits.
  Pratyush Yadav, David Matlack, and Samiullah Khawaja noted that session
  protection is symmetric across outgoing and incoming paths: while the
  caretaker is actively using a session's preserved resources, the kernel
  should pin / hold a reference in LUO metadata so userspace cannot unfreeze,
  close, or prematurely retrieve and release backing memory (e.g., memfd
  pages) until the caretaker stops.

* Session Isolation vs. Global KHO Tree: Pratyush and David Matlack also
  asked whether the caretaker needs visibility into the global KHO radix tree
  (whose primary purpose is excluding preserved memory from early boot
  allocations, whereas the caretaker boots from dedicated RAM) or could be
  handed only its target LUO session payload(s) for stronger isolation. Pasha
  noted that the caretaker currently maps KHO nodes read-only only along the
  lookup path at retrieve time, and will evaluate whether KHO tree access is
  still needed if session physical addresses are passed directly.

----->o-----
Cross-Subsystem Versioning & Compatibility Strategy

* Expandable Serialization Header (kho_header_ser) v4: Tarun Sahu has v4 of
  the minimal expandable serialization header series ready to post, adding
  entry_size alongside feature flags per Pratyush's review feedback and
  updating existing KHO/LUO serialized structures across upstream Linux.
  Recording entry_size in the header is necessary for early-boot array
  deserialization (such as luo_session_header_ser entries), where callers do
  not inherently know the entry size written by the previous kernel.

* Header Naming Alignment: Tarun asked whether kho_header_ser should be
  renamed to include "feature" to distinguish it when prepended to
  kho_block_header_ser. Pasha and David Matlack agreed to keep kho_header_ser:
  every serialized structure starts with kho_header_ser, while KHO blocks
  naturally follow it with their block-specific kho_block_header_ser.

* Custom Preserve/Retrieve Arguments & Version UAPI: David Matlack is working
  on custom preserve/retrieve argument support alongside tmpfs preservation.
  Pasha suggested landing the serialization header series first and starting
  upstream discussion on the kernel version UAPI in the coming weeks.

----->o-----
Guest Memory (guest_memfd), KVM & Confidential VMs

* End-to-End KVM & Confidential VM PoC Series: Tarun Sahu prepared a combined
  PoC patch series to demonstrate the end-to-end preservation ABI and future
  extensibility for KVM maintainers, structured in layered stages with
  kselftests for each:
  - Non-confidential VM preservation (guest_memfd, KVM VM FD, and vCPU FD
    preservation + selftests).
  - Intel TDX preservation (feature header + selftests, thoroughly reviewed
    with Sagi Shahar).
  - AMD SEV-SNP and ARM CCA preservation (feature headers + selftests,
    prototyped/LLM-tested to illustrate cross-architecture ABI coverage and
    noted accordingly in the cover letter).

* Rebasing & Split Plan: Tarun is cleaning up the PoC series and rebasing it
  onto kho_header_ser v4. Once kho_header_ser lands in liveupdate/next, he
  will post the PoC (marked not-for-merge) to anchor ABI review, with
  standalone vCPU and guest_memfd preservation series prioritized next.

----->o-----
TDX Module & VM Preservation

* KVM PoC Integration & HKID Preservation: Sagi Shahar confirmed that TDX
  preservation is integrated into Tarun's combined KVM PoC patch set. Ongoing
  work is focused on resolving Intel TDX Host Key ID (HKID) preservation
  across kexec.

----->o-----
PCIe Persistence

* Merging PCI v10 & Sequencing for Linux 7.5: With Linux 7.4-rc1 released on
  November 1, liveupdate/next is now open for Linux 7.5. Rather than delaying
  David Matlack's reviewed PCI Live Update v10 series or posting a PCI v11
  that would require re-collecting Reviewed-by tags across the series, Pasha,
  David, and Tarun agreed on a two-step landing sequence:
  1. Pasha will merge PCI v10 into liveupdate/next immediately so it begins
     soaking in linux-next.
  2. Tarun will base kho_header_ser v4 on liveupdate/next and include a patch
     converting PCI's serialized structures (alongside KHO, LUO, and memfd)
     to kho_header_ser, requiring review only on that conversion patch.

----->o-----
VFIO Persistence

* VFIO Live Update v6 Posted: Vipin Sharma returned from leave and posted v6
  of the VFIO live update series (based on PCI v10). Moving beyond the LPC
  prototype (memmap + DSA), v6 uses preserved memfd as the DMA backing source
  in no-IOMMU mode and has been validated end-to-end across kexec on both
  Intel IGB and DSA devices. Community reviews on v6 are welcome.

* PCI Save State Dependency: To get v6 out for review without stacking another
  unmerged series, Vipin included temporary manual serialization of PCI save
  state into an allocated buffer. David Matlack noted that because the
  kernel's current pci_saved_state layout is code-driven and not ABI-stable
  across kernel versions, his PCI save state rework series must merge ahead
  of VFIO. David will review VFIO v6 while Vipin reviews the PCI save state
  rework series to accelerate landing it first.

----->o-----
IOMMU Persistence & LUO Core

* IOMMU Persistence v6 -> v7: Samiullah Khawaja received Reviewed-by tags
  from Baolu Lu on the Intel IOMMU driver, IOMMU core, and IOMMUFD changes in
  v6, and plans to post v7 soon.

* Preventing memfd Hole-Punching Hazards for IOMMU Mappings: Samiullah
  started an upstream discussion (mm/memfd: add F_SEAL_PUNCH_HOLE) to prevent
  a gap where userspace maps memfd pages into IOMMUFD and punches a hole
  (FALLOC_FL_PUNCH_HOLE) prior to memfd preservation—discarding pinned pages
  that existing seals do not block so they are missing after kexec. Per
  feedback from David Hildenbrand, rather than introducing a new seal UAPI,
  memfd will set a sticky flag whenever a hole is punched, and IOMMU preserve
  will reject memfds with that flag set (leaving standalone memfd preserve
  unchanged). Investigating this path also uncovered and fixed a bug in
  memfd_pin_folios().

* Hitless Replacement & IOTLB Conflicts: Upstream discussions continue on
  hitless IOMMU translation replacement across kexec and evaluating potential
  IOTLB conflicts.

----->o-----
Agenda Rotation for Next Meeting

* Deferred Topics First: Because the first seven agenda items filled the
  hour, Pasha will continue rotating the agenda so that the remaining topics—
  tmpfs File Preservation, KHO & Boot Memory (bootmem), PowerPC & LoongArch
  KHO Support, and Resource Accounting & Session Handover—are covered at the
  beginning of the next call.

----->o-----
Action Items & Next Steps

Pasha:
* Merge PCI Live Update v10 into liveupdate/next for Linux 7.5.
* Post the next revision of the early session freeze series incorporating
  caretaker session pinning / lifecycle updates.
* Evaluate whether the Linux caretaker still requires KHO tree access if
  session payload physical addresses are passed directly.
* Rotate the deferred topics (tmpfs, KHO/bootmem, PowerPC & LoongArch) to the
  top of the agenda for the next meeting.

Tarun:
* Post kho_header_ser v4 (with entry_size) rebased onto liveupdate/next,
  converting PCI v10 alongside existing KHO, LUO, and memfd structures.
* Clean up, rebase, and post the combined KVM + guest_memfd + confidential VM
  (TDX, SEV-SNP, ARM CCA) preservation PoC series once kho_header_ser is in
  liveupdate/next.

David M:
* Review Vipin's VFIO live update v6 series.
* Continue work on generic/custom LUO preserve & retrieve arguments alongside
  the next tmpfs preservation series.

Vipin:
* Review David Matlack's PCI save state rework series so VFIO preservation
  can rebase onto ABI-stable PCI save state structures.

Samiullah:
* Post IOMMU persistence v7 incorporating review feedback and tags.
* Implement the sticky memfd punch-hole tracking flag check for IOMMU
  preserve and continue hitless IOTLB replacement discussions.

Pratyush:
* Review Pasha's read-only KHO and updated early session freeze series, as
  well as Tarun's kho_header_ser v4 series.

Sagi:
* Continue working on TDX HKID preservation across kexec with Tarun's KVM/TDX
  PoC series.

The Group:
* Review Pasha's read-only KHO series and Vipin's VFIO live update v6 series
  on the mailing list.

----->o-----

Next meeting will be on Monday, November 16 at 8am PST (UTC-8), everybody is
welcome!

Join Here: https://meet.google.com/rjn-dmzu-hgq

Please let me know if you'd like to propose additional topics for
discussion, thank you!

Best regards,
Pasha

