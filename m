Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19369606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 20:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=bejmzGLk
Received: by kanga.kvack.org (Postfix)
	id 549CE6B085D; Tue, 24 Nov 2026 15:58:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FBE56B085F; Tue, 24 Nov 2026 15:58:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E90D6B0860; Tue, 24 Nov 2026 15:58:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D78E6B085D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:58:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C02980B53
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:58:14 +0000 (UTC)
X-FDA: 85471225308.01.AFBBF2F
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4E6EB1C0009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:58:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bejmzGLk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795553892;
	b=Y0o0EQ4MmsfW9I4q5ONnpAB/OcjQ4K2iHfRF6wFvHLnxQ1UvJPfkBXBTCFa0cn8Lni7o+R
	2GgBBXTiJuBNqBRgvp2QFtvOpzv6VvKCGREQVCFGZ2GmEl1sxwC6Mfhe5PLTBnSGF0QvXX
	0Bu3x1EY6vGiCWeNKNAs5IFyezWtUY8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795553892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9lR7+FZK4pMd/mVqImDERZx+vy1vSfASfONjlk0tOlI=;
	b=RGeO+CB3n10y0YJ1Jd7H7oIFJuRYwTwJnrbzeQm6mvNBSPaq99+6lIHdBI1cTh9L1z+q2a
	GtUG1p9VGcAZkBE1T1G9fIq8mZDxKpRHdhaLwClfD6c60K7Qn6UuEu/hx2lD7tdeZGt20T
	1xG9rYxdBQ+r/FYiu5DByce7gmgDe1E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bejmzGLk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-9214032a2fdso40816266d6.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1795553891; x=1796158691; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9lR7+FZK4pMd/mVqImDERZx+vy1vSfASfONjlk0tOlI=;
        b=bejmzGLkaGP0JDq3UFgJ+O0PbM+f9PNejjr7YzrqDDr+E0G2VkBom/ql56MlM0/Hb4
         pGKt1EFj7viThjyPTGvIUtnyPqxlwUkWXvfCIphZRbhNnblgbkUvFTXl1igongjhTOqU
         O1lfHrjGC6NwAaCMqYihdTnDD6pQG+m1cycnhmxxiPU9Y8LpWrCR0ldPFI33YWJpOoZI
         cy8h6kSfMkBq9DVhVZ5tzsJ2antFl6UPiYQI8WrSpxEhWURWhDB1wqOCYujfVF7oHgRA
         adE9hQBNTSb+pcWSs+vqBiHJu4RMrvTotoDB+ghf6xtvAMZ9IgFO197h5iaiDuTaaUd1
         EGIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795553891; x=1796158691;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9lR7+FZK4pMd/mVqImDERZx+vy1vSfASfONjlk0tOlI=;
        b=uF2fIWH2FHQXR7syjk2ptfwiB0uRUfjsZ4bPN7TB/GXSo2PP+C1311JUqDHlDz/VG5
         ef19CB75evsjp9f5fqaTq20bUR0e8wf1AhdRS/ZrickZhpowo8VnsjdovB062fYdCa1D
         xGnn/Drkn2ENAlk6SHEQGKHRCOe77t1ma7hRJ90oYa1XTQttL6mKVUJGQRqoi5hE9T1X
         zdOzR8C3WZAtTjNhIEix79C15sw53jC9JF+Mw4F26vGCNZs0ytJcFMCkS19Bgyw4mfTq
         1NamPxyW3JkOLUzQeAhyou5Rn2jnXnG2dFZ/KC2iElH8Ei78CEKXTCLccCl2SMR83SIa
         fobw==
X-Forwarded-Encrypted: i=1; AL+hErEbDCc1SFCZOis9MGZaWNmtForhyaFHn7B+D+1DkPjdUC7YuTaKroLuF/qd8ntid0TGoYWDQ7B07Q==@kvack.org
X-Gm-Message-State: APuU4Z85Xy6dSpkoawjK4X6YX3+s7AWfc+hTCmaJLMlpA+iLwtRQXtJY
	r8zh+RqQJu9YcKgFDNIUzznxRaur/2z1sBxa0b1oNXM6BJsz7GkDL6YuXP/w0UPCFfw=
X-Gm-Gg: AZFdTZcwQAMS5MLybxAh8KElLogUiH9QADB9GyNNrnp0yW8NDphLI1OwO1QbqvhbNHz
	TljeqEcPL/HcluGMQWnFCjkwB2LFdbmpMxr4bUbo+FEKcBXzrAKWuw6+QvZIJfLUGf4V+qeWVEx
	b0FXvafLnwL0iWtsUshqflUvzFZzrItyLpCinF8je5qmN12u3MtZJO07fFygVfM8vJfiDNpl4xw
	wx9aA0POnEKCMKOwPYLTBnp84ofyZXmCQ9rfjdenvAIB44lvqWCntcYrk7FjJg7VGX/FYLTlrBG
	6H+2aObBx4t6pqVqQylJP9e9M3APSKxFBcAGnUdvuWKS/I/JjXDbcPG/ztfmgDKu7/5MDEtDDbZ
	ItVDM70zYMev3cwhDTRsgby8+zz8ha44kAd+uXG/2Wwy+kDSVRlbqYB8fFa1fmdxRVV/bfcyd2P
	5k0jchfO8tBhpdtVDxoQkkzRhqsXaA21ZM1ObvcVQxATZNbBwNK/FKdnyP7JGYPZV1BCz/8aHNt
	5dj6u9t4i7P3ME0mqRg7IV5/9vFKXsx9TWY9QjfCIkf6MNyiTWDbhQpBcYHU2SVfmp0TdNH+dWn
	T3nu2gkVuAylkc+N8Mm7/ah5HgsYqdVRvsYgH5aY9Mu8EtbEqRK5BbtRsDM2uGJ/qMxwQqAOWgP
	hT4g3/VFWBVjwhDxbQbyfTpPjl5FRLCa1CE269qvo9rXjM0P2szkAHp2y4gyZ2ufF+jFk47saEQ
	==
X-Received: by 2002:a05:6214:3382:b0:921:27a1:a4e5 with SMTP id 6a1803df08f44-92134a9a0b6mr276905586d6.28.1795553891171;
        Tue, 24 Nov 2026 12:58:11 -0800 (PST)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349d0f6bsm145562816d6.21.2026.11.24.12.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 12:58:10 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	"Andersen, Tycho" <Tycho.Andersen@amd.com>,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	David Matlack <dmatlack@google.com>,
	"Heyne, Maximillian" <mheyne@amazon.de>,
	James Gowans <jgowans@amazon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Praveen Kumar <kpraveen.lkml@gmail.com>,
	Sagi Shahar <sagis@google.com>,
	Tarun Sahu <tarunsahu@google.com>,
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
Subject: [Hypervisor Live Update] Notes from November 16, 2026
Date: Tue, 24 Nov 2026 15:58:05 -0500
Message-ID: <20261124205808.4097419-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4E6EB1C0009
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: i3u8nixkjsnt3j13ni3xm69fnf98hj37
X-HE-Tag: 1795553892-897825
X-HE-Meta: U2FsdGVkX1+HooQAcUmh+VuXn9LFmbPkjWbTbLMgkYRbSa1N8epFWl+NvEdDPTX8I3xm59hIn1qgQWL5anQTSbhauC/5aDyVjMQUwSby2Cb2zBZaT0imrAXTzanPjoZfBugy7IMCs+nXzutCkmS4Af0C8U6zIoY4MFRSpQhkNA7FAE2XsbBFshIHXfl5WUWQOwJDJ780GTdopyO38CGfSLaqqZHU5oyTBRkk5rX3NPyPOSAotXpV24zsWY5WxTQpNpPV61gT8Qd4PPbHFH+RIzarHomvb0LmzG8OVScoZUFRhpvmnLx6Xr/pIl90Yi30L3VBilW5TEuWFxrCpDwFyp7xi0O0JK4GKqHbWhhjClF9r1i5x963kDERVvRAoE7B8BgHAEeJ3d/L557779TVRIrLhFaT+TtOztm40wnfaQH7Bshym7FYPJb4bI/Y7XL4IlneGxgOcAx6VURTIaOl1zoisu4k0HYLjnhjtTv3rB6kyiCZrhm98CRVoO+UhBAOfY1Fbu1A//hUDMateBLb7ADMEhvmd7yKzDnx5k4doSsJG4KpIxjT8pnxQ4rlPeEVdn1MzdcDt/CGO1RZymFmA4BF1KvjW3e53TRIOOf/cNrdjrcQvKHiRx0Szn5EqkC9o2Xo7PWSHYockodko2DD9NH05k2SKGwYDPx3dO/CDcgdsUVgii7HFwHGaFQpqOFK5LySfmGMDbSMBp9mp7VxWA54Tjk4aNOAcso3Ez6Afo9ePcRdgZJrUirTdDNmk0FQ6NRU48af1iHwNisGrgXnROu7uF1fuOWJMxykN0+qK1z3RVmMyUqOfL/4+GnMniaFtB8kGK4UQXWaeilmQUBs11T6cFxX+vj4dpLkXbi7GoBLC1LPyy56LYLqgxPkxa/g2laiEENMUdZhDhvlE7qQlGMRLc9/0+62cOqQz+T1qodIsNW7W4XfwDRSIJrf/LlHwO0Q6P9yC+AGhcYmLht
 Ll+LN1vj
 jue9zTF0wfeqe52EpENghJAQCR168h2ZSPm4EXqfF9MNXE3KYz6/dMpIZfDAHsWK16fHBElh3jFLqMP2ioEbWCoGc5dTbtSH0e7TaS9HXhX7Xnlq3znhwXhHyp5CKEjBt/da3Grb9HBAUBuqIM3Ji+ps816lSJtbVsy5Kk4RKGGnnaiEEwu+ImCUngVhL44u1knxLHkQlsJytzyS3+Y6+Ai9JMfyLX8yQFSMcu68wqR0lRmbDGzyi4Xqio+vpAsYNiqEve9g/RAgGul4+DtiyzWXTM71xL6EjMZ/ebrj/vOtW+la0S+Tnyg7VMj1KrRmoLhLx7iS1x6XkUyPvYugFLlTZVt/BtarxzKLYAg43rcZ5trDvvXwA5B6wC3LXgJ9ZUMa9gjnMcv16M8LsjjFlG8qGFKdR+UOHUKxiUgmgc/HPNqf6LrVj8HiXpogkWrDf6lpbqqQcslmTyMPjwHExaRkLWg7gV8fu93tRBWgPUirk4Qpk1RB410V8OQuPxXP7LQbJ0dl1qDaE2sX/VyE4qBdZ/epBwegcmLV3DJkQPdUBy0Y4BoLabjzAhxt79JiQCbsk2IRRfHpozeaTnJRdl46i751IViN4BXaxzR3C8lhCnkNbwwsOXgh3bN0jU4Hvsb9cuENaX6hpocq4sRoxsPWze0++E3GxC1+Rq3TY9rXKiYZsmxfjWPt/ICdTECyvmoG434ACTvKxsNTvF9V3C5dPuu4YnFO5lFqM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi everybody,

Here are the notes from our Hypervisor Live Update call held on November 16.
These notes are intended to bring those who could not attend up to speed
and to keep the momentum going between meetings.

Starting with this meeting, we introduced an "Upstream Review Overview"
section at the top of the agenda to track recent mailing list activity from
the past two weeks, followed by our rotating subsystem workstreams. We also
began maintaining each call's agenda and notes as dated tabs in the shared
Hypervisor Live Update document.

----->o-----
Cross-Subsystem Versioning & Feature Header (kho_header_ser v4)

* Review Feedback & Struct Versioning Policy: Tarun Sahu reported that review
  comments on v4 of the expandable feature header series are largely minor
  and formatting-related, with no major design objections:
  https://lore.kernel.org/all/20261110050202.529473-1-tarunsahu@google.com/

  Responding to David Matlack's question on whether secondary serialized
  structures (such as memfd_folio_ser and pci_dev_ser) should each carry a
  kho_header_ser or defer to their parent struct's feature flags, Pasha,
  David, and Pratyush Yadav aligned on two rules:
  - Any separate serialized struct referenced by pointer (e.g., memfd
    pointing to folio state, or a generic KVM struct pointing to an
    arch-specific struct) should carry its own kho_header_ser. At 8–16 bytes,
    versioning is cheap and ensures uniform static size checks and
    independent evolution.
  - Serialized structs should generally not be embedded directly inside
    another serialized struct, as embedded structs cannot grow later. Callers
    wanting to avoid allocating a dedicated page for a secondary struct can
    pack it after the parent struct in the same preserved page and reference
    it via pointer (as memfd does for kho_vmalloc).

* Separate Metadata Header for kho_block Sets: David Matlack noted that v4
  repeated entry_size and the serialization header on every page in a
  kho_block linked list, even though all entries in a block set share a
  single entry size and version. After weighing special-casing block 0 vs.
  separating the metadata from the data blocks (matching kho_vmalloc and
  upcoming radix-tree / KHO map structures whose root pages hold child
  pointers with no room for inline headers), the group aligned on Pratyush's
  proposal:
  - Move block-set metadata (KHO's own versioning header, entry_size, pointer
    to the first block, and the single shared feature header for the array's
    payload entries) into a separate block-set metadata header struct that
    callers place either in its own page or packed alongside their parent
    struct.
  - Remove the per-block serialization header from individual 1-page data
    blocks so all blocks in the chain are uniform.

* FLB Early-Boot Versioning: Pasha highlighted Chris Down's review comment
  that File Lifecycle Bound (FLB) incoming data is accessed very early in
  boot—before file handlers initialize—so FLB versioning must be validated
  when retrieving incoming FLB state.

----->o-----
Upstream Review Overview (tmpfs, IOMMU, VFIO, PCIe, KHO & LUO)

* tmpfs File Preservation (v4): David Matlack posted v4, returning to the
  "retrieve into an existing file" model per Christian Brauner's feedback
  (which simplifies the implementation) and splitting the selftests into
  smaller commits for easier review:
  https://lore.kernel.org/all/20261111002358.1842967-1-dmatlack@google.com/

* IOMMU Persistence (v7 -> v8): Samiullah Khawaja collected Reviewed-by tags
  from Baolu Lu and Ankit Soni on v6, posted v7, and received follow-up
  feedback from Baolu that he will address in v8:
  https://lore.kernel.org/all/20261110040828.1774343-1-skhawaja@google.com/

* VFIO PCI Live Update (v6 -> v7 Split): Vipin Sharma is addressing David
  Matlack's reviews on v6—evaluating the "retrieve into" user-provided FD
  model (for consistency with LUO APIs) and a dedicated locking scheme:
  https://lore.kernel.org/all/20261102153656.1431701-1-vipinsh@google.com/
  Per discussions with David and Alex Williamson (at KVM Forum), Vipin will
  split the 27-patch v6 series into two smaller series for v7: ~14 core VFIO
  patches and a separate VFIO selftests series (which David can review in
  parallel while Alex reviews core VFIO). Alex also noted that stacking on
  in-flight dependencies prevents Sashiko bot reviews from running, and
  encouraged broader upstream VFIO code participation from the team.

* PCIe Live Update, Save State Refactor & P2P DMA Selftest:
  - PCI Save State Refactor v2: Pasha and David agreed this ~90% PCI core
    refactor should merge via the PCI tree. David is gathering initial
    reviews from Pranjal Shrivastava and Vipin before pinging Bjorn Helgaas:
    https://lore.kernel.org/all/20261106004218.604799-1-dmatlack@google.com/
  - VFIO P2P DMA Selftest RFC: General VFIO selftest extending Vipin's DMA
    test to validate peer-to-peer DMA across live update:
    https://lore.kernel.org/all/20261111192411.4133780-1-dmatlack@google.com/
  - PCI Core Live Update v10: David posted Bjorn's requested pci_dev_ser
    allocation/release refactor as a standalone follow-up patch on top of v10
    to avoid churning linux-next; only two ACS save/restore patches remained
    awaiting Bjorn's Ack:
    https://lore.kernel.org/all/20261109174009.735309-1-dmatlack@google.com/

* Early Session Freeze (v5 -> v6): Per Mike Rapoport's feedback on v5, Pasha
  will move Linux caretaker-specific logic out into the read-only KHO/LUO
  caretaker series and post v6 as a pure LIVEUPDATE_SESSION_FREEZE series:
  https://lore.kernel.org/all/20261105050053.3063001-1-pasha.tatashin@soleen.com/

* KHO Bootmem Sizing, Observability, RISC-V & memfd_luo Fixes:
  - Bootmem Sizing v3 (Mike Rapoport): Reviewed and ready to land:
    https://lore.kernel.org/all/20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org/
  - KHO/LUO Observability (Chris Down): Strong support for observability.
    Pasha and Pratyush discussed sysfs vs. debugfs ABI stability: LUO
    UAPI-visible state (e.g., outgoing/incoming sessions and FDs) fits sysfs,
    whereas KHO internal bootmem/scratch details are still evolving (and KHO
    should be made more flexible rather than cementing internal bootmem
    layout as stable sysfs ABI prematurely):
    https://lore.kernel.org/all/cover.1794383544.git.chris@chrisdown.name/
  - RISC-V KHO v3 (Chen Pei): Clean implementation; reviewed by Pasha and
    Mike, awaiting prerequisites:
    https://lore.kernel.org/all/20261106071459.2003-1-cp0613@linux.alibaba.com/
  - memfd_luo Fixes (Pratyush Yadav): Pratyush will check Chris Down's note
    on "keep memfd frozen until finish" v2 (already reviewed by Pasha and
    Samiullah), and will send v3 of "don't use memfd_pin_folios()" addressing
    Mike's wording comments:
    https://lore.kernel.org/all/20261110175855.2437084-1-pratyush@kernel.org/
    https://lore.kernel.org/all/20261103172251.2348370-1-pratyush@kernel.org/

----->o-----
Orphaned VMs & Linux Caretaker

* Read-Only KHO & Dedicated Caretaker Mapping Code: Mike Rapoport raised
  concerns on the read-only KHO series about exposing raw physical addresses
  (design alternatives still under discussion). On the memfd side, rather
  than adding a caretaker-specific read-only retrieval mode into generic
  memfd code, Pasha and Pratyush agreed to place caretaker-specific memfd
  retrieval/mapping logic in a dedicated caretaker file under
  kernel/liveupdate/ so the intent is clear. Pasha plans to combine the next
  version of read-only KHO, read-only LUO, and initial caretaker mapping code
  into one cohesive series so reviewers can evaluate the end-to-end design.

* Updating the KVM Community on the Linux Caretaker Pivot: David Matlack
  noted that KVM maintainers from LPC may still expect the standalone
  KVM-based caretaker RFC to be the active path. Pasha agreed to post an
  update replying to the original Orphaned VMs RFC cover letter explaining
  why the Linux caretaker approach is being pursued first (more generic,
  supports VMM/virtio exits, easier bring-up) while keeping the KVM-only
  model in mind as a potential future security-hardened option:
  https://lore.kernel.org/all/20260920193650.3373435-1-pasha.tatashin@soleen.com/

----->o-----
KVM Forum Recap & Meeting Logistics

* KVM Forum: David Matlack and Vipin Sharma reported from KVM Forum that
  Paolo Bonzini highlighted Live Update on his "what's coming in KVM"
  roadmap slide, and Vipin aligned with Alex Williamson on splitting the VFIO
  live update series.

* Community Growth & Potential Schedule Adjustment: Pasha noted growing
  upstream interest from Meta and other companies and will invite engineers
  working on live update to join the call. Because Mike Rapoport has a
  recurring biweekly LPC committee conflict at the current Monday 8am PT
  slot, Pasha will check with the expanded group to see whether shifting the
  meeting day/time accommodates more participants.

* Shared Agenda Document Link: Going forward, agendas and notes will live in
  dated tabs inside the public Hypervisor Live Update Google Doc. Pasha will
  add the document link to the internal calendar invite as well.

----->o-----
Agenda Rotation for Next Meeting

* Deferred Deep-Dive Topics First: Because the Upstream Review Overview
  (including the kho_header_ser / kho_block design discussion) and Orphaned
  VMs update filled the hour, Pasha will rotate the agenda so that unreached
  deep-dive topics—KHO & Boot Memory (including Pratyush's KHO map RFC),
  PowerPC/LoongArch/RISC-V KHO Support, Resource Accounting & Session
  Handover, Guest Memory (guest_memfd) / KVM & Confidential VMs, and TDX
  Module & VM Preservation—are covered at the start of the next call.

----->o-----
Action Items & Next Steps

Tarun:
* Post kho_header_ser v5 using a separate block-set metadata header for
  kho_block (removing per-block headers), retaining kho_header_ser on
  pointer-referenced structs, and addressing Chris Down's FLB early-boot
  versioning comment.

Pasha:
* Post LIVEUPDATE_SESSION_FREEZE v6 as a standalone session freeze series
  (moving caretaker-specific pieces to the read-only KHO/LUO caretaker
  series).
* Combine read-only KHO, read-only LUO, and initial kernel/liveupdate/
  caretaker mapping code into a cohesive next revision, and continue
  discussing the physical-address exposure feedback with Mike Rapoport.
* Reply to the Orphaned VMs RFC cover letter updating the KVM community on
  the shift to the Linux caretaker approach.
* Invite interested engineers from Meta and other organizations, explore a
  conflict-free time slot (for Mike Rapoport and others), and add the shared
  Hypervisor Live Update doc link to the internal invite.

David M:
* Follow up with Bjorn Helgaas on the remaining two ACS save/restore patches
  in PCI Live Update v10.
* Coordinate reviews from Pranjal Shrivastava and Vipin Sharma on PCI save
  state refactor v2 before pinging Bjorn.

Vipin:
* Split VFIO Live Update v7 into separate core VFIO (~14 patches) and VFIO
  selftests series, and evaluate "retrieve into" FD semantics and locking per
  David Matlack's review feedback.
* Review David's PCI save state refactor v2 series.

Samiullah:
* Address Baolu Lu's review comments on IOMMU persistence v7 and post v8.

Pratyush:
* Check Chris Down's comment on "memfd_luo: keep memfd frozen until finish"
  v2 and post v3 of "mm/memfd_luo: don't use memfd_pin_folios()" addressing
  Mike's wording feedback.

The Group:
* Review David's tmpfs preservation v4 series, Pratyush's KHO map RFC, and
  Chris Down's KHO/LUO observability series on the mailing list.

----->o-----

Next meeting will be on Monday, November 30 at 8am PST (UTC-8), everybody is
welcome!

Join Here: https://meet.google.com/rjn-dmzu-hgq

Please let me know if you'd like to propose additional topics for
discussion, thank you!

Best regards,
Pasha

