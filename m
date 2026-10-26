Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97FDA606A327
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=LkBSVsKT
Received: by kanga.kvack.org (Postfix)
	id AEEE66B05B8; Mon, 26 Oct 2026 13:42:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2E86B05BB; Mon, 26 Oct 2026 13:42:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952C36B05B9; Mon, 26 Oct 2026 13:42:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3026B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:42:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0445FC07A8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:42:24 +0000 (UTC)
X-FDA: 85365496650.07.FF4AEF6
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf07.hostedemail.com (Postfix) with ESMTP id 669CB40007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:42:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LkBSVsKT;
	spf=pass (imf07.hostedemail.com: domain of 3-5DfagkKCPgyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3-5DfagkKCPgyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793036543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=B4ANvDZKg/XTDKTxx6DRbKMCW8lIWCNJ9Qz1jlrn4KM=;
	b=v0+H4kK7p5H6cAeTbI70gDvvTauz/zfMPe6oitReDCRNPeZst+PJJ/yri0lmXQreOimwKD
	EpTa25Iy8e/P8yG7IS7IqxFZDsn/+EFVLfjPp/J0lFULGWnCAHUiE/7OJDC1xoZA0zkVLb
	2EGpyrcnkq3ET5Ak70zqcf3Z/3z191E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793036543;
	b=pWW7aue550G3NWudE9Mzb/9iWyBfmy/LAXJ+9g33Kq93Ypp5TQlSiR+obHdNFnTa1KANUD
	0dGvK6nGY/XsCbAEmo6EeaPaQGBBXVGN9waoXZ6UhahRB7vmoD+EecBJiOVZ4fsAIHRZhv
	bwFmqRmd13ZbIwRY3aYtugTsEzev85E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LkBSVsKT;
	spf=pass (imf07.hostedemail.com: domain of 3-5DfagkKCPgyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3-5DfagkKCPgyfwzsxfmzlttlqj.htrqnsz2-rrp0fhp.twl@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c40285df2a0so191133066b.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793036542; x=1793641342; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=B4ANvDZKg/XTDKTxx6DRbKMCW8lIWCNJ9Qz1jlrn4KM=;
        b=LkBSVsKTiT7AMDJvnjCB1u0K6vUj6qwNJ1R1B+t5DTO16+3DKhheeci/+kPj8K2zuW
         W0c2kkqCdoHS3b3HJnmlMqdyFtFmsd/2T0toQbKBjl7CHewkYS/8eexDtGrNrkepQxsx
         J4coNY35YyxubQ2CAilBcdafKZGwu2HyOh0n74q0i+8SmrNPkbwcEVt96C+qWojiLb3B
         vKLOpxzxn0HCGWIiJNJRLaqAPzsgp85DpDyNnDe2A3AvwtHCQA0EOKXFkmFeZp0D16DB
         gmS/Eg1WWHfSg4Y6FpozoBeG+6pvHH+KyjSI5wtwasi2xTUdJ6fMy7BOPOh8WgDRL7Ip
         /oEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793036542; x=1793641342;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B4ANvDZKg/XTDKTxx6DRbKMCW8lIWCNJ9Qz1jlrn4KM=;
        b=Eyu38O91qPG6xPKvT0n62G2WEIxPWPIGmGRwV+pG7JmlOZlrL/tTM1RVL89U7doxZv
         FK6sQycXuQexVYKF/nELQCLZ/Z2ym+UIPQzH2dj6xk2N0+aamQIjvWYzukqoLQnGKE2f
         j00XTVwiRPjL+zJ3f4QKICbusLQq6D3aOOanuCn2ml/erHncDimyH/Ysrwu83NjDQV71
         bat7NJjnwzyaZ2e0b3vSk2EUt1dFSPkJQDPInWgBv1LHce3crlRTBKU1RR1dzem7bdD2
         mZ9y2AVY8RvJRs2AqZtuzgRg8iSgyCVsgWUx304S51YquiN3p11Y1NJNx4zsEU0XlfAq
         P+Sg==
X-Forwarded-Encrypted: i=1; AKwUvBypjAOlvnhTsoBQDv8+Lvf5/UkbdqEiqbmdn4rAsC1Tqtp767TDl0cp7q9uTt9TLBPsKlIk3p/ajA==@kvack.org
X-Gm-Message-State: AFq9FYL7KSGMxrLLBKwliadEYo385MyAuJN4TKX7JxYdvK1xOUVHZxlC
	czyPWaamjeNQsectgNNuGHbn0ZAjH/FPrAjey6owH+o/ZFkkefpzKRvKsyYL53qLIvDau44iwUh
	LuAFzh7J8bmhW1+ewWg==
X-Received: from ejjj17-n1.prod.google.com ([2002:a05:6938:a091:10b0:c46:a6d4:6c2b])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:608e:b0:c46:8b87:c1f4 with SMTP id a640c23a62f3a-c46bddc4a4emr843314466b.20.1793036539136;
 Mon, 26 Oct 2026 10:42:19 -0700 (PDT)
Date: Mon, 26 Oct 2026 17:42:13 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026174217.603114-1-tarunsahu@google.com>
Subject: [RFC PATCH v3 0/4] liveupdate: Add feature header for fine-grained
 ABI compatibility
From: Tarun Sahu <tarunsahu@google.com>
To: loganodell@google.com, alex@shazbot.org, dwmw2@infradead.org, 
	seanjc@google.com, Mike Rapoport <rppt@kernel.org>, will@kernel.org, pbonzini@redhat.com, 
	jgg@nvidia.com, Pasha Tatashin <pasha.tatashin@soleen.com>, arnd@arndb.de, 
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, oupton@kernel.org, 
	baolu.lu@linux.intel.com, David Matlack <dmatlack@google.com>, robin.murphy@arm.com, 
	maz@kernel.org, Alexander Graf <graf@amazon.com>, joro@8bytes.org, 
	Bjorn Helgaas <bhelgaas@google.com>, kevin.tian@intel.com, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 669CB40007
X-Stat-Signature: zu7nwj1crtn7w54atwgk7macot5zobi1
X-Rspam-User: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793036543-329395
X-HE-Meta: U2FsdGVkX1+WCrYb4G6FhH7Mu4DI0k7ea6qdUIEmnGj5/wr/8Mww1v6MUsDCe08ji8PNk05AzJnPL+KJGDC27Ym8DdBLVFwwZUcr2D8bisz5ezocfZAzloovL17jPXELSNx6koWTCMQwJkRQyE0XazOC2nMGhu6B+8nk5aoQRr5U+3+deP2KFwuy0HVb9pjL5s6cv7LVWTeUnEFKxGGsULMfgh8ZHLUEceJQReDQnI8Jdol9dwStncE+YJC26XqdcgKYAvyavE/oJycmsZNyyg/5p0K37aHI108+adOV1IYY/kTGJbfQn5gpX42Awhhh+Cl49EUEgKTurG7/ZqvaS6g7FPiZbVCHH2lDyMxG1VFApobOPHZWEIXPS7D+QRFpbxl1Haaf9TGRWuaGwZkoHWo7hKl2hoSx7CD2nL8XCmf4Us3roowT/lqStgSgtM3cXw9yFu1fMJuD4Vw8r1q8+RuQMBzsGQebH4N+zcKAMBuuAisxzLRZC/q7rt+xa/fUf2l3fIiH2Jkkx/neCUUXBOWU+G4DPmhOHY9QBy3HtZ74P+UOVcs+zv1Z8mGIRrbvViE/yxM6t9UPvRroZR/fgCcxdtnxz2SUZ+7D/fBRb9adVElmgUD7i8I4r5kvXQVjcKJsEJDsyy0Un2QKjTQuuhFXxoMKClmcfmQ6x1rGgTcxoCu5SipNoTZ4590jRtKFJH17e/1Ph9HYvVtH6vky/oPwB/VwIrDcEfOJA0iH41lB2gNposhIxZUQ3szGLxYVRhhw+zb3DbgCZTJ/BLDDLJSr+S88c+j9W8HbON3yK0uOgA1QY+MqtImg+AoyKBYBmQSgi1p95YHVGMUuYGqQi3Xfa0anvaV64qB3wepi0FeQ8H85V8k/86ow9E1MAXog7AjCUdvhmMlOMooUiB4Bk50aIwtavrfXWLGUuLwEtPKpMdFJ5cmUocUAb5qZJHhkCHRShojPIMWTRSBxUzI
 ew9F6Zou
 sBge4iFkn7D1aVt84WCGI+o+7LHznK+2CaSIPKDcOKX+Sm7271QnldWFAEThBKiYgQWqlEJUXU0xtTvqMQvmBx4Xsmp7sgRGWDfS7fcx5PyGHf/unkaWNTa68n7DkiKEKVgddZDs16FOjEUgBIpX4GYTv5AHbm6PmgWiI5H0Zm2jX5C8EpugaLhXmJd+XBhG3Z6gKMyBlwdxX2Il9jaE5fhPiPWRIa505vy8qQ/3BRaw0M8bHGUWG/vMpBCYh706VQULYeDJ0UKwA59OKsGPSL5XgK0xgzkUVXGcic6irn7n62SoddNhAjd3hAt/Lz18fQf9cue29tHuIeIvlYNm7YuohGpTXoE8if9nAtroDftcrKK/STQvUKiP0/Ds5H22pOTT/05nhrxa9PlQrORSb6whOhSzm5BRc1fGsUEcx0Dm6P5VcOdMHUO9Ox2thTuC+xte+j8WoMd+wMd+d8WwexN1u37P88QjUDwohl8kLJxWUCA0NBW3dybwA7ilfsLZozGTcF+T32hSYLfQPCA23F/IeyTx4+SbAOHjRHMjvN7W7NWqJg7Kh2xP79TBa6o2I2zLiJSUW3KCA3dxtxGrSsTfWkqim4TrnMKq9g2q0P4aHYy3sttyLV8R4oQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Changes since RFC v2 [1]:
- Dropped the file handler compatible rename and per-FD handler
  selection patches.
- Replaced the fixed 128-byte header with an expandable struct
  luo_ser_hdr (size, nr_features, flags[]), kept separate from the
  payload structure. The header is 8 bytes with no features and 16 bytes
  for 1 to 32 features.
- Each subsystem declares its wrapper once with DECLARE_LUO_SER_WRAP(),
  passing its feature enum MAX; the macro sizes the flags entries and
  generates name##_wrap_init(), so callers never pass sizes or counts.
  The target kernel reaches the payload with luo_ser_payload().
- Feature bits describe only what each preserved object uses. The target
  kernel checks them against its own boolean supported table, and the
  header is trusted as the source of truth: validation only rejects a
  required feature the target kernel does not support. 0b10 is reserved.
- Moved the __packed removal into its own patch (1/4) and added a KUnit
  test (4/4).

Changes since RFC v1 [2]:
- Replaced the 3-mask (supp, req, active) design with a header of 2-bit
  feature states.

[1] https://lore.kernel.org/all/20261021152527.375070-1-tarunsahu@google.com/
[2] https://lore.kernel.org/all/20260903023452.721732-1-loganodell@google.com/

==========COVER LETTER==============

LUO and its file handlers rely only on coarse-grained compatibility
strings (such as luo-v5 and memfd-v2) to validate handed-over state
across kexec. Any change to a serialized structure, even an optional
additive field, requires bumping the string and breaks live update
between adjacent kernels.

This series adds a feature header (struct luo_ser_hdr) ahead of
serialized LUO structures so subsystems can evolve their serialized state
per feature. Each subsystem groups its serialized fields under feature
indices, with index 0 for the base fields. New capabilities append fields
at the end of the payload under a new feature index, and retired fields
stay in place so offsets never shift. Only a change that feature flags
cannot express needs a new handler with a bumped compatibility string.

Each feature has a 2-bit state set by the source kernel:
- LUO_FEAT_ABSENT (0b00): not in the payload; a target kernel that
  supports it can use default values.
- LUO_FEAT_OPTIONAL (0b01): in the payload; a target kernel that does not
  support it ignores the data.
- LUO_FEAT_REQUIRED (0b11): in the payload; a target kernel that does not
  support it rejects the state with -EOPNOTSUPP.
- LUO_FEAT_RESERVED (0b10): reserved, not checked by the target kernel.

The target kernel checks the header against its own boolean supported
table:

  Source hdr  Target supported[i]  Action
  ----------  -------------------  ----------------------------------
  00          0 or 1               Accept: feature absent in payload
  01          0                    Accept: ignore the feature data
  01          1                    Accept: use the feature data
  11          0                    Reject: -EOPNOTSUPP
  11          1                    Accept: use the feature data
  10          0 or 1               Reserved: not checked by target

struct luo_ser_hdr holds the total size of the serialized structure
(u32), the number of features (u32 nr_features), and 64-bit flags
entries with 32 features each. With no features the header is 8 bytes;
with 1 to 32 features it is 16 bytes.

On the source side, a subsystem declares its wrapper once with
DECLARE_LUO_SER_WRAP(name, expected_size, nr_features), passing its
feature enum MAX, then calls name##_wrap_init(), marks the features the
preserved object uses with luo_ser_set_feat(), and fills wrap->ser. On
the target side, incoming state is never cast to the wrapper, since the
source kernel may use a different number of flags entries. The target
kernel calls luo_ser_hdr_validate(), finds the payload with
luo_ser_payload(), and reads the fields of a feature only after
luo_ser_get_feat() shows it present.

Patch 1 removes __packed from the LUO and memfd ABI structures. Patch 2
adds the header and converts struct luo_ser. Patch 3 converts memfd and
bumps its compatibility string to memfd-v3. Patch 4 adds KUnit tests.

Tarun Sahu (4):
  liveupdate: Remove __packed from LUO and memfd ABI structures
  liveupdate: Add feature header for fine-grained ABI compatibility
  mm: memfd_luo: Add the feature header
  liveupdate: Add KUnit test for the feature header helpers

 MAINTAINERS                          |   1 +
 include/linux/kho/abi/luo.h          | 359 ++++++++++++++++++++++++---
 include/linux/kho/abi/memfd.h        |  43 +++-
 kernel/liveupdate/luo_core.c         |  62 +++--
 lib/Kconfig.debug                    |  16 ++
 lib/tests/Makefile                   |   1 +
 lib/tests/liveupdate_feature_kunit.c | 118 +++++++++
 mm/memfd_luo.c                       |  68 +++--
 8 files changed, 577 insertions(+), 91 deletions(-)
 create mode 100644 lib/tests/liveupdate_feature_kunit.c

-- 
2.56.0.307.g5fe7bd680c-goog


