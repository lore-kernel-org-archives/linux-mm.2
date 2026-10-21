Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EDB860A2628
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 15:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=AGczIQhJ
Received: by kanga.kvack.org (Postfix)
	id 9526C6B071F; Wed, 21 Oct 2026 11:25:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902DD6B0720; Wed, 21 Oct 2026 11:25:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819346B0721; Wed, 21 Oct 2026 11:25:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 575936B071F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:25:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E426216058A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:25:32 +0000 (UTC)
X-FDA: 85347007704.16.6A63F11
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf03.hostedemail.com (Postfix) with ESMTP id 40D612000C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:25:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AGczIQhJ;
	spf=pass (imf03.hostedemail.com: domain of 3adnYagkKCNwR8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3adnYagkKCNwR8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792596331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=W0oLRP7RmrwK+s1WyDoN9zSSlBczsPl1G7flMYO8vs0=;
	b=8paOp1iVLAEY3BcIWOsK59kXJx6UlM/33rzpaUs/7EQqeihsYSPywRUlQtiygwU6IGyCSO
	9DUHNiGDb3TP8CpWYPIOWSY0SJWmebr9/IdqvgI60xu5Tyyo6GTk2Yqsp2zDPfjHFn1nL4
	3qehOJoSvg63+c/ECpyM7NPgnUTzaLY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AGczIQhJ;
	spf=pass (imf03.hostedemail.com: domain of 3adnYagkKCNwR8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3adnYagkKCNwR8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792596331;
	b=7dsOpegWJH6nVYpeCZFHWGwTZrDHC5gelk/HdRoVTPVUgOdikdwpjfX8VHuxADV1Eyb3I/
	nBwTYHCE4pS+TeiD28w3VkjSdSknRoTN3Pzk3Mzjr9mf1mZ+7AT55drJZJXw5DhGWk3XdW
	CBEt7HTyM6jlbA/ZF1LIyFq523ZAgLo=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c293e604f0eso78283766b.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792596330; x=1793201130; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W0oLRP7RmrwK+s1WyDoN9zSSlBczsPl1G7flMYO8vs0=;
        b=AGczIQhJFPtE5xlv1XSQSzTsg71QQjlMvb7wewvFjTIMrP2PnmMcUTj5L2xypGKuhs
         SzD2qWkm/0Bcz1/75WadajY9qefhNE8T3TFvz+5PJzP8ADXgcHwVITcKF4AWct2NIau3
         nVPj8n4e4ZN58LIIKuvhBgdXLeSMOTzLDtJvS4vbJRIJaxomhoovc7dnql5u7A7ptmd1
         Bf4sx33jNZFhDaKGeKF2NwK7RXVxkEyh1HU7AfICbS3ual5wyt+mFPIT7kDw0vZSKUK3
         AllcZYrgVSE++nNFMC54B+JP+vSq9ESqDAm9xmhIklY4pyJysOpdbIPOpQKTaQvoTUZI
         B5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792596330; x=1793201130;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W0oLRP7RmrwK+s1WyDoN9zSSlBczsPl1G7flMYO8vs0=;
        b=xJSI2l0kR9DgcGepU5fa6QCmzXazkGpQM8ZTllauAPaQQ/saJnzmrDh8xHccbxd453
         iOfAcg0UQFzS4NobieYWPIWT3k/dh4wwEm44g9Vwn0nm9NbKHDacclsRWETohiailtiH
         pdWga2rGrNESBzTICqwd7wh2PVqgyeT8fxPSvty3Fih9wm+ogUJ13Dn8tLOjdVDwCIW0
         NWx/6vHRaHsKQ8H9+jgvMqJXtu+n8OK/WYdS5iu2eyBb4+kbgHnwinst1nqkciNmjk1G
         VpeTpObY05hRvaTD/CVxwiAipzDD/C4iB0+r8Rzxc93V8rvpV+PSukrbba7dbFoRYGCl
         3Mkg==
X-Forwarded-Encrypted: i=1; AKwUvBz2mlKNQc9ZzRF9qVnUbJ8TYq83yy2tt85MebfTPFLwVYuhrZyjv1/mi9sIMbPtuG6z4qM8/TaDRw==@kvack.org
X-Gm-Message-State: AFq9FYLp1UwXVONMTkc9IxQDIIQSTD1Tb6uEXr6EbftoBN9sas0RZizL
	rtUsDU4Q27mLN5QOVI9qLoW1vaqmatWOl/agVW+ZDokUYraKlM2x2nFsdfc3igTdZXB1AZLXDKx
	Ekcqxg3Wy+I1Ks0artg==
X-Received: from edqo20.prod.google.com ([2002:aa7:c514:0:b0:6b1:dfff:2ee9])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:dc8e:b0:c44:14d:d95d with SMTP id a640c23a62f3a-c46796ec9bcmr208718966b.23.1792596329153;
 Wed, 21 Oct 2026 08:25:29 -0700 (PDT)
Date: Wed, 21 Oct 2026 15:25:23 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261021152527.375070-1-tarunsahu@google.com>
Subject: [RFC PATCH v2 0/4] liveupdate: Feature header ABI and named handler
From: Tarun Sahu <tarunsahu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	David Matlack <dmatlack@google.com>, jgg@nvidia.com, robin.murphy@arm.com, 
	loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com, 
	alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, 
	will@kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 40D612000C
X-Stat-Signature: inewbu5rfkxchkocqk7u7sarhyfi7xg7
X-Rspam-User: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792596331-254392
X-HE-Meta: U2FsdGVkX19zek0I2Fb+lz9TUrEYmqqNDDenxx3eOZuWL/AxTEpAnYXbq+8kaB0Wvlez+SuuKIazSIcgs9PqojFbZg0cw8VQeoma/9rsy7FK2k4E6MASATExO33w86dIm3ZzStLcVmVVPTD24RNg9sGdziyIapVBK15C3mv1/NDC6qluZ/MWw6XOcj0120Ig4NXoRuFqnD4a3yZjBbm+pf+LWdGQSmad3gj9myqoklPJZnL4oEOL8cr2I5YafMkeas8oBZPFOCMl7xgV6sB9MHI9JArc7jEEDMxLonG3PHNApQdhnGuMIVA012L/wIWeKBzUNC1sHochf/5pDYpYpa0phbAFmO0yqlgR77L+Azt11v2QNvMmoozQuARnHvuwBuCT8UFUMQqRwpWxs8OjufbhVmufPggm+bAM6co92a0xZiC9AaSne04qG+gDwq/mu1DHD/YOIf1yiIjRuvR8QQ2PZdQko+TjzwMFbFW6G6OBmXSJolDi+JhCWRuNYIHNXv2OmabMPbk1e3wpgp5xMEQO/U8HdGEOUYzE0KevIyMEGvqpkVR8d8T0KPc1AgHYnXt2xZ89R2OFLSVRGglytK+3Q+gaK32KzhZCsE5L7EPdd13U//tJME5psM/EJu/XLpiMkuh0Xi6fddGoiH5K5nA3dmKCucFhLeqL1auv+/57czfcwuyQGWzDZJUIggAzCobsrrjXnDSXtSackvJCTS8yQfLGPcoiMQ1ghCdcP2Ef2tK+BxY1/0fORYPLbpXJiIgUQ5O4Gd+WApbbyPsp+zChKbC4kKhHkYEcWtCR94Dlf/0q9eCnnvZR51Yin0MqCrWDKpMCmwd/d6tdQVNNqDmie+MVAcnSvYa9hW/MheP7d6xStPVlg7e6qliS8cXa8VRJhHPzl6OO10K95SWt9+Mw/ci60F4foPJtlXhVMYIggD6j7HQtdgDP9bufNIdjeJsy21cYxysI4UhrO8a
 lfk2rWn4
 h2dlEB1jvEj6eeSNXSdrjXBN2hvWvqMX+TPPfgfhAx/Svq+cNteXgO9kPWwfNWefV6zRTZCvMuntvlUCD3M9oufV95CWJbrDGV0+HF8wwi9lTKR+JA1oA6jQG7QlrwwF0aiejPmk2UyljpsGRt2tsKlbI5pTu0c/6s3gsHb/IVNsJWCws/LaxxA1U9YNHdbk6notF21gd7GpEVwCRZwJdayiKux43vbowUT2KDM2ji9ud12f/z8VMoSIbKzzE81enLTocFFQkKmJcAWULTHtgImnIchci1bNFJujQoWeglgCwCNEKLCWvRZ0l5rjTK01Tbxq7hVuXdOyDtvJ9KWvm1iEoq+Ktpwrwyu9povV0idy+F1ynVaptApNAx5Jd/psOZFY8WA78RITPy0+yi5WVZPZTVw+A28AX03yR1MvI9c/0wEDKQbhHhxUqXRon0R1oQ2UXflEV/iWWmueCKR4pv9QOKuywWMUqkZ/B899l8GNPSGv2sipNipFTDiiX4fjnTXqdNJ4V4/vRUD0/A2bJBXl1RrDzcjaPGc4Q7WbCqexpEpxbIriN4e9dqBbPfhOE22yhxBQFx6aZvzHhUW8+X0OvuO8bzWkxK4w4JuUbu9na/nQRuVdsgHv9tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Live Update Orchestrator (LUO) and its file handlers currently validate
handed-over KHO state using monolithic compatibility strings ("luo-v5",
"memfd-v2"). Any change to a serialized structure, even an optional
additive field, requires bumping the compatibility string, breaking live
update between adjacent kernel versions across both forward updates and
rollbacks. This series introduces the feature flags per serialized
struct to communicate between the kernel about their active and required
features. Having feature flags increase the compatibility matching
granularity.

This series also renames the file-handler and FLB compatible identifier to
name, extends LIVEUPDATE_SESSION_PRESERVE_FD so userspace can
optionally select which registered file handler preserves a file
descriptor by name, and replaces monolithic version strings in serialized
payloads with a fixed-size 2-bit pair feature header
(struct luo_feature_hdr). So in future, If a change to a subsystem
preservation can not be handled with feature flags, we can attach a new
handler to support the preservation.

This change is motivated by the LPC discussion.

Named File Handler Selection
============================
With fine-grained compatibility tracked via feature headers, the
handler and FLB compatible field is renamed to name. When a subsystem
needs a genuinely incompatible new handler alongside an existing one for
the same file type, struct liveupdate_session_preserve_fd now includes
char handler[LIVEUPDATE_HNDL_NAME_LENGTH] after token (keeping
min_size at 16 bytes for backward compatibility):
- Empty handler (or 16-byte struct): selects the first registered
  handler whose .can_preserve() accepts the fd, keeping default callers
  on the original rollback-safe handler.
- Non-empty handler: selects the registered handler with that exact
  name and verifies .can_preserve() accepts the fd.

2-Bit Pair Feature Header (struct luo_feature_hdr)
==================================================
Each serialized ABI structure (struct luo_ser, struct memfd_luo_ser)
starts with a fixed 128-byte struct luo_feature_hdr containing:
- size: byte size of the enclosing serialized structure from the source
  kernel.
- flags[15]: 15 chained 64-bit feature flags entries. Each entry
  encodes up to 31 features as 2-bit pair (req, active) states
  (enum luo_feat_state: LUO_FEAT_DISABLED = 0b00,
  LUO_FEAT_OPTIONAL = 0b01, LUO_FEAT_REQUIRED = 0b11) plus
  LUO_FEAT_EXT_MASK (bits[63:62] = 0b11) chaining to the next entry
  (up to 465 features total). Because the header is fixed at 128 bytes,
  payload field offsets never shift when extended flags entries are used.

Each subsystem defines its feature states as a static const u8 array
indexed by its feature enum, which luo_feature_hdr_init() packs into
the payload feature header. During deserialization,
luo_feature_hdr_validate() checks the header from the source kernel
against the feature array in the target kernel according to the
per-feature (req, active) truth table:

  Source Target Action
  (1,0)  (x,x)  Reject -EINVAL: invalid source kernel (req without active)
  (x,x)  (1,0)  Reject -EINVAL + WARN_ON_ONCE: invalid target kernel
  (0,0)  (0,0)  Accept: feature absent
  (0,0)  (0,1)  Accept: feature absent
  (0,0)  (1,1)  Reject -EOPNOTSUPP: target kernel requires the feature
  (0,1)  (0,0)  Accept: ignore payload data
  (1,1)  (0,0)  Reject -EOPNOTSUPP: source kernel requires the feature
  (x,1)  (x,1)  Accept: use payload data

Structure Evolution
===================
The relative order and offsets of fields in serialized structures must
remain unchanged as features are added or retired. New fields are always
appended at the end of the structure under a new feature flag, and
retired fields are kept in place so that the offsets of subsequent
fields never shift. If the type or format of a field needs to change,
the existing field and feature are kept intact (and retired when no
longer needed) and a new feature flag with a new appended field of the
new type is added.

In the target kernel, fields of a LUO_FEAT_REQUIRED feature are
guaranteed to be present once luo_feature_hdr_validate() succeeds,
whereas fields of a LUO_FEAT_OPTIONAL feature should be accessed only
after verifying that the feature is active in the source kernel header:

  if (luo_feature_is_active(&ser->features, FEAT_X))
          val = ser->x_field;

Changes since RFC v1 [1]:
- Renamed file-handler and FLB compatible to name and added optional
  handler selection by name in LIVEUPDATE_SESSION_PRESERVE_FD.
- Replaced the 3-mask (supp, req, active) + variable-length FDT and
  feature-section design with a fixed 128-byte struct luo_feature_hdr
  embedding size and 15 chained 64-bit 2-bit pair (req, active)
  flags entries directly in struct luo_ser and struct memfd_luo_ser.
- Replaced compile-time bitmask macros with a static const u8 feature
  array per subsystem packed by luo_feature_hdr_init() and validated
  in a single pass by luo_feature_hdr_validate().

[1] https://lore.kernel.org/all/20260903023452.721732-1-loganodell@google.com/

Tarun Sahu (4):
  liveupdate: Rename handler compatible to name
  liveupdate: Select file handler by name in the preserve ioctl
  liveupdate: Replace compatibility string with a 2-bit pair feature
    header
  mm: memfd_luo: Add the 2-bit pair feature header

 drivers/pci/liveupdate.c         |  10 +-
 include/linux/kho/abi/luo.h      | 367 +++++++++++++++++++++++++++----
 include/linux/kho/abi/memfd.h    |  39 +++-
 include/linux/kho/abi/pci.h      |   2 +-
 include/linux/liveupdate.h       |  18 +-
 include/uapi/linux/liveupdate.h  |  15 +-
 kernel/liveupdate/luo_core.c     |  27 ++-
 kernel/liveupdate/luo_file.c     |  64 ++++--
 kernel/liveupdate/luo_flb.c      |  16 +-
 kernel/liveupdate/luo_internal.h |   3 +-
 kernel/liveupdate/luo_session.c  |   7 +-
 lib/tests/liveupdate.c           |  22 +-
 mm/memfd_luo.c                   |  16 +-
 13 files changed, 481 insertions(+), 125 deletions(-)

-- 
2.56.0.212.g129ede20d9-goog


