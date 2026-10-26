Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BECC606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ryYTtYQ6
Received: by kanga.kvack.org (Postfix)
	id 8437C6B05B9; Mon, 26 Oct 2026 13:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BB296B05BA; Mon, 26 Oct 2026 13:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534F46B05BB; Mon, 26 Oct 2026 13:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CCCB6B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:42:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43699A8385
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:42:25 +0000 (UTC)
X-FDA: 85365496650.20.572CCE3
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7BF4A1C000D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:42:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ryYTtYQ6;
	spf=pass (imf21.hostedemail.com: domain of 3_ZDfagkKCPovctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3_ZDfagkKCPovctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793036543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kr46c9EVXyRxEb7DPmNyohsxyZ9gzOK05tGIDGM7w1c=;
	b=ZByZxetkBMFMcJXiR9WJDg3r7j/Ubex2zNB1qmTbiKhv9ieqH/31BRJ3fwcDa/peJdlAmw
	iY+sGOFQLz9EkPJT97JA6z1+05p11VsS48U0HIoH14POWB9jGmYsbzC/0px8A4g3QugrHz
	WVfyQEg7D8MYTwlBsgC1Q1DG8SjAmEg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793036543;
	b=cKuEI3hgyYpAIcbenKIlFfDhGPxEEktlJg3QLwZck+8+cqtAgJ/9NCE7qNl/OBzVomv0a2
	gg/iO8nqJ44JSx9qTLc4e0fTQFC5Jwra5BVgLmqZDK/vISaKRJP7vwvIfq7PetfT/Wkuae
	NRxKSyVCQbIktC+C/6q1jF+nDet3lNM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ryYTtYQ6;
	spf=pass (imf21.hostedemail.com: domain of 3_ZDfagkKCPovctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3_ZDfagkKCPovctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a125f5b317so3731356a12.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793036542; x=1793641342; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kr46c9EVXyRxEb7DPmNyohsxyZ9gzOK05tGIDGM7w1c=;
        b=ryYTtYQ6WnK6/t6DynVOsjbRdZJ+f5TtdnFujPh7jnT/QDBfu833CBUN7O97PxIIDe
         Xj/bnok+1xa61cJkvshThxsccR7ueCCBzTjtx/X5VPssIA+QnEiNoqHijNwKOBJMWYb4
         VR+ArkGDoucyep5FPgwjg5ocRjWvTDb7/rci6VWVP9vai+PGx7JMgQ5hDrOhYwKbY7w5
         yKIG/0psYouv+2m65tXCasWsFQ/UVBsYXT+1UTZEsaAvkttB4HlPEynRYZCOaeKne8Ww
         bvBRMNIyqVEstDaOcEZShPLqm48PtlocP23cU7PqouQdGum9nZGYkX4PHh8v8hR95qZu
         LVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793036542; x=1793641342;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kr46c9EVXyRxEb7DPmNyohsxyZ9gzOK05tGIDGM7w1c=;
        b=0TLDa9LjKSR3FIMt4hLnPGKyKNLBYrdVl4+gBBCRoJvxggynC3+2aAuB2VMvfLD2YY
         sCeTlnrK4uyq1eQL9Zsw6nuG0tvzUJ8WXlMSUJeeZ2ewsioofGbuHAiV/dmehTAcG9RC
         kAf6O+htNH17v2X3GhMql0foHvCI6124GQkkDouNGdx1yya3daoiQZ0yW6vk3D20SDTR
         uAAYqxaHE4fXmoZBGphmQPY1wPipTgkGPSIdRkqvyBgF2xKesgl4Ybk3jsmV+nJEoPqU
         EpSnDINu85GCYdSba+JdKMfqujDllqHUTs8Iif0cSrBvwvCqco4m042EAPp+WSV1SVn7
         wn/A==
X-Forwarded-Encrypted: i=1; AKwUvBzTLv9vc2KU3YYTzx4fAlrCrEONKVkQ32++jGJF/Af4HHO8+aCcQu1KzPihDQIQ6hB87qUX+WEDTw==@kvack.org
X-Gm-Message-State: AFq9FYJjzY6vFjY5mY/xCNHpbyyzYtFt3UuxfzF+zN3HeUs2Encb5Y0O
	EHj1tAQR4qdPzFT4dSan/vLePowiP8BBgNM3RL68rMmJ0ix1u6l0J19459CGXPVKxrcQabEZZDD
	HMAmToIxih7aKzx0R/w==
X-Received: from edsl12.prod.google.com ([2002:aa7:d94c:0:b0:6ae:42c6:5908])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:404:b0:6b1:b5b8:b696 with SMTP id 4fb4d7f45d1cf-6b442fe421amr6574269a12.23.1793036541785;
 Mon, 26 Oct 2026 10:42:21 -0700 (PDT)
Date: Mon, 26 Oct 2026 17:42:15 +0000
In-Reply-To: <20261026174217.603114-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026174217.603114-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026174217.603114-3-tarunsahu@google.com>
Subject: [RFC PATCH v3 2/4] liveupdate: Add feature header for fine-grained
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
X-Rspamd-Queue-Id: 7BF4A1C000D
X-Stat-Signature: ndgpfaxfx7gwhecdfht34ykwpm8j56hb
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793036543-587085
X-HE-Meta: U2FsdGVkX1872aKvenCJaveYznq+4J8XCnTK+sxhI9Iz0B7xIX2QykC0ucVRyxD+lo547c8oOsv1Dhmj3hyNuAuBfSvj9xf0jPKx5U1Onb3+seQfmK+ID0GB21yx9LHllK0Lq4zMrrOIv7OPVCc4zNOppyH3jlMStW7togTCjI99SrW9zJsWt1HBdLKpOsz6mLwV4JmlAgIbDjFG34DpmJ7Lr3RD9Rug3ikDxlFhw6+z4+RKnoWXXY2jTYppmkFD+zSWvOpFAbu/uaM2wB5fxx9k/bGif2C1UIwN/9gcKOYETofBcimi6XEtG/3ovnwvxzCBOHLNFcS/ZJGX5yUR1qqqrNn5xNJ1BE8ABQUQBK3UARbPQUE8RDiLVVx8OvxvBpkr4rOvdWlXH/+gc7JlAwZ5DAOrNlwaAAf0an5x3ygq6FWMd9SjjoThazJsoa7RW0Y5Dut9jOehcEiIQe0JKK3V9+BJSugzHkU+GmTr0L81TfzEa6rgvO8TDp2FJk7fCabBqrvG4wQ32NIRWNkJPuhzUdojfjVnALHnxNapmXbh1+dJ0R36RVzkN+z/hp1uYCwm83ZToEGLTFmD9zGu6XHdEEtavoh2YdtjKwWHI+9MncNo+U8B/zpzobl+XE0ib4EthIX2sD5C8WxgNEwy0h1aDFWzaBBomdbwN5AGQfYeWIiVRfpd4cMkRu0uzZyvNMXJnSoa8KhCvgLNKli2dcYFpmMIVEUqyVII68k44F14qLOeYGh0iVuFxgJAG+oEiP6+OB4mR2FdNoGYfNNNAgQ8iklUokaTIyNTbFh0IMXdRCrOSORMQwFXb96oNTTYPzi0PNCNKU7VA7A1Q8MRSKehB3Hs5Q4QPHf4L8D9d3ncHbro8Yr8kfbqtgXxIHVKkTynw2u56wBtI1AZ/FLpHIr8Tyy4ZPFRLYIo6mNomykVHIYiBO2uKmcteZidJPBpiTt5gYDZczAxNZIAKzn
 2nQGiClW
 RAhnukjcX+WXVUFB6ECNRGMVU8SV0F3rX/ND0hV67IfPRZtdx7TUcNlNUe2D3s9zuXBZxeo6J1O3Q57nnSlKrL1D9n/JKGXnI9HlGGbwOXFzHmvbndSuidVXzG7JYy5X6jWn+0d7OvBxPbIbNx0ANUQiFTXzoqXr++Tzo5thFc4G2vaTuniIdNhkq/zkMEvIESNfdczldOpOI2zoIQoqlglR5hPvUcuCg5W8veHf9YfLG4Z/M9M5vwRK7Xyx3jZUApDYCoAbvF8EmTo5TK28z0DoethqlYqGsC/N8d+mqGfVHx1lKU+k9zEC518BQPnkbJlO6n5oaWc79Jsns68jMNtL5CMb174u2vsqkN1of1st/goH5DeHYMNv73BZW5L7WdXxgIocy0RyYN+iI14AW7Z5BBturuCO9I8DsO9NFcllgsLWz/v2L4WmivuEoUnMJtvGyCO1glVpS/X4iIYORJ+b6voG78KOkS4jn9Bwi6++z2R37ukqpg+W1L2JwnHNV1VhxTE4ci1sH/OoQWMdlp7X+8zQE12sX/2g44bZt4v2kYpnFiinBc6TqNBsbGq7qFlBJZF5Wp+IdkQViWVTKxPFue+oVY6Xu35F2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

LUO and its file handlers currently rely solely on coarse-grained
compatibility strings (such as luo-v5 and memfd-v2) to validate
handed-over state across kexec. Because compatibility is checked only
at the whole-structure level, any change to a serialized structure,
even an optional additive field, requires bumping the compatibility
string and breaks live update between adjacent kernels.

Introduce a feature header (struct luo_ser_hdr) ahead of serialized LUO
structures so subsystems can evolve their serialized state at
per-feature granularity. Each subsystem groups the fields of its
serialized structure under feature indices, starting with index 0 for the
base fields. When a subsystem adds a new capability, it appends any new
fields to the end of its payload structure under a new feature index.
Retired fields are kept in place so existing field offsets never shift;
if the type or format of a field needs to change, the existing field and
feature are kept intact until retired and a new feature index with an
appended field of the new type is added. Only when a change requires a
complete break in the serialized layout or semantics that feature flags
cannot handle, a new handler can be introduced with an incremented version
number in its compatibility string.

Each feature in the header has a 2-bit state (enum luo_feat_state):
- LUO_FEAT_ABSENT (0b00): Feature is absent in the serialized payload.
                        Target kernel can initialize the feature with
                        the default values if it supports it.
- LUO_FEAT_OPTIONAL (0b01): Feature is present in the payload and
  optional; a target kernel that does not support it ignores the feature
  data.
- LUO_FEAT_REQUIRED (0b11): Feature is present in the payload and
  required; a target kernel that does not support it rejects the state
  with -EOPNOTSUPP.
- LUO_FEAT_RESERVED (0b10): Reserved encoding, not checked by target.

During deserialization, the target kernel validates the incoming header
against its per feature supported information stored as a simple boolean
array. The truth table for the deserialization:

  Source hdr  Target supported[i]  Action
  ----------  -------------------  ----------------------------------
  00          0 or 1               Accept: feature absent in payload
  01          0                    Accept: ignore the feature data
  01          1                    Accept: use the feature data
  11          0                    Reject: -EOPNOTSUPP
  11          1                    Accept: use the feature data
  10          0 or 1               Reserved: not checked by target

Source hdr is the 2-bit state of feature i written by the source kernel.
Target supported[i] is the boolean entry for feature i in the target
kernel supported features table passed to luo_ser_hdr_validate() (1 =
supported, 0 = not supported; an index at or beyond the table size, or a
NULL table, is read as 0).

The preserved data from the source kernel includes hdr and payload (ABI
for serialized data).

Each subsystem declares a wrapper structure using

        DECLARE_LUO_SER_WRAP(name, expected_size, nr_features)

This Wrapper wraps the hdr and serialized ABI payload in one structure.
Which will be preserved and passed to target kernel. Target kernel will
deserialized the hdr and based on each feature it will deserialize the
payload.

For deserialization in the target kernel, incoming state is never cast
to struct name##_wrap because a source kernel with a different feature
count may have a different number of flags entries. Instead, the target
kernel validates the header with luo_ser_hdr_validate(), locates the
payload with ser = luo_ser_payload(hdr), and checks whether a feature
is present before reading its fields:

  if (luo_ser_get_feat(hdr, FEAT_X) != LUO_FEAT_ABSENT)
          val = ser->x_field;

Also, introduce the LUO_CORE_FEAT_CORE for LUO for the existing mechanism
which is also a required feature.

Signed-off-by: Logan Odell <loganodell@google.com>
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/luo.h  | 336 +++++++++++++++++++++++++++++++----
 kernel/liveupdate/luo_core.c |  62 ++++---
 2 files changed, 338 insertions(+), 60 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 899943877e41..2c30bbd26c10 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -9,29 +9,81 @@
  * DOC: Live Update Orchestrator ABI
  *
  * Live Update Orchestrator uses the stable Application Binary Interface
- * defined below to pass state from a pre-update kernel to a post-update
- * kernel. The ABI is built upon the Kexec HandOver framework and registers
- * the central `struct luo_ser` via the KHO raw subtree API.
+ * defined below to pass state from a source kernel to a target kernel.
+ * The ABI is built upon the Kexec HandOver framework and registers the
+ * central `struct luo_ser` via the KHO raw subtree API.
  *
- * This interface is a contract. Any modification to the structure fields,
- * compatible strings, or the layout of the `__packed` serialization
- * structures defined here constitutes a breaking change. Such changes require
- * incrementing the version number in the relevant `_COMPATIBLE` string to
- * prevent a new kernel from misinterpreting data from an old kernel.
+ * This interface is a contract. `struct luo_ser`, and the serialized state
+ * of each file handler that uses it, start with an 8-byte base feature
+ * header (`struct luo_ser_hdr`) holding the combined structure `size`
+ * (`__u32`) and `nr_features` (`__u32`), followed by an array of 64-bit
+ * `flags` entries (`__u64 flags[]`) before the payload structure.
+ * When `nr_features == 0`, `flags` has zero entries and the header is exactly
+ * 8 bytes. For `1 <= nr_features <= 32`, `flags` has 1 entry and the header
+ * is 16 bytes.
  *
- * Changes are allowed provided the compatibility version is incremented;
- * however, backward/forward compatibility is only guaranteed for kernels
- * supporting the same ABI version.
+ * Feature state encoding (2 bits per feature):
+ *   `LUO_FEAT_ABSENT`   = 0b00: Feature absent in serialized payload
+ *   `LUO_FEAT_OPTIONAL` = 0b01: Feature present in serialized payload (optional)
+ *   `LUO_FEAT_RESERVED` = 0b10: Reserved encoding (not validated)
+ *   `LUO_FEAT_REQUIRED` = 0b11: Feature present in serialized payload (required)
+ *
+ * Feature flags mapping:
+ *   - Each 64-bit `flags` entry encodes 32 features (2 bits per feature).
+ *   - Feature N is encoded in `flags[N / 32]` at bits
+ *     `[2 * (N % 32) + 1 : 2 * (N % 32)]`.
+ *
+ * Truth table::
+ *
+ *   Source hdr  Target supported[i]  Action
+ *   ----------  -------------------  ----------------------------------
+ *   00          0 or 1               Accept: feature absent in payload
+ *   01          0                    Accept: ignore the feature data
+ *   01          1                    Accept: use the feature data
+ *   11          0                    Reject: -EOPNOTSUPP
+ *   11          1                    Accept: use the feature data
+ *   10          0 or 1               Reserved: not checked by target
+ *
+ * Source hdr is the 2-bit state (enum luo_feat_state) of feature i in the
+ * header written by the source kernel. Target supported[i] is the boolean entry
+ * for feature i in the target kernel's supported feature table passed to
+ * luo_ser_hdr_validate() (1 = supported, 0 = not supported; an index at or
+ * beyond @nr_supported, or a NULL table, is 0).
+ *
+ * The relative order and offsets of fields in serialized structures must
+ * remain unchanged as features are added or retired. New fields are always
+ * appended at the end of the structure under a new feature flag, and
+ * retired fields are kept in place so that the offsets of subsequent
+ * fields never shift. If a field's type or format needs to change, the
+ * existing field and feature are kept intact (and retired when no longer
+ * needed) and a new feature flag with a new appended field of the new type
+ * is added.
+ *
+ * Apart from missing required features (-EOPNOTSUPP), `luo_ser_hdr_validate()`
+ * rejects a header only when the source kernel marks a feature `LUO_FEAT_REQUIRED`
+ * that the target kernel does not support. A feature the source kernel did
+ * not send reads as `LUO_FEAT_ABSENT`, so the target kernel reads the fields
+ * of a feature only after checking it::
+ *
+ *   if (luo_ser_get_feat(hdr, FEAT_X) != LUO_FEAT_ABSENT)
+ *           val = ser->x_field;
+ *
+ * The source kernel is responsible for marking a feature it relies on as
+ * `LUO_FEAT_REQUIRED`. The target kernel handles each feature in its own
+ * retrieve code, for example by falling back to default behavior when a
+ * feature is absent; it does not guard against a source kernel that sets
+ * the wrong states.
  *
  * KHO Structure Overview:
  *   The entire LUO state is encapsulated within a single KHO entry named "LUO".
- *   This entry contains the `struct luo_ser` structure.
+ *   This entry contains a `struct luo_ser_hdr` followed by the
+ *   `struct luo_ser` payload.
  *
  * Serialization Structures:
  *   - struct luo_ser:
- *     The central ABI structure that contains the overall state of the LUO.
- *     It includes the compatibility string, the liveupdate-number, and pointers
- *     to sessions and FLBs.
+ *     The central ABI payload structure that contains the overall state of
+ *     the LUO (`LUO_CORE_FEAT_CORE`: the liveupdate-number and physical
+ *     pointers to sessions and FLBs), preceded by `struct luo_ser_hdr`.
  *
  *   - struct luo_session_ser:
  *     Metadata for a single session, including its name and a physical pointer
@@ -40,7 +92,7 @@
  *
  *   - struct luo_file_ser:
  *     Metadata for a single preserved file. Contains the `compatible` string to
- *     find the correct handler in the new kernel, a user-provided `token` for
+ *     find the correct handler in the target kernel, a user-provided `token` for
  *     identification, and an opaque `data` handle for the handler to use.
  *
  *   - struct luo_flb_header_ser:
@@ -57,35 +109,247 @@
 #ifndef _LINUX_KHO_ABI_LUO_H
 #define _LINUX_KHO_ABI_LUO_H
 
-#include <linux/align.h>
+#include <linux/bits.h>
+#include <linux/bug.h>
 #include <linux/build_bug.h>
+#include <linux/errno.h>
 #include <linux/kho/abi/block.h>
+#include <linux/math.h>
+#include <linux/string.h>
+#include <linux/types.h>
 #include <uapi/linux/liveupdate.h>
 
 /*
  * The LUO state is registered under this KHO entry name.
  */
 #define LUO_KHO_ENTRY_NAME	"LUO"
-#define LUO_ABI_COMPATIBLE	"luo-v5"
-#define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
+
+#define LUO_FEAT_PER_FLAGS	32
+#define LUO_FEAT_STATE_MASK	0b11ULL
+
+/**
+ * enum luo_feat_state - 2-bit state of a feature in the serialized payload.
+ * @LUO_FEAT_ABSENT:   Feature is absent in the serialized payload (`0b00`).
+ * @LUO_FEAT_OPTIONAL: Feature is present and optional (`0b01`).
+ * @LUO_FEAT_RESERVED: Reserved encoding (`0b10`).
+ * @LUO_FEAT_REQUIRED: Feature is present and required (`0b11`).
+ */
+enum luo_feat_state {
+	LUO_FEAT_ABSENT   = 0b00,
+	LUO_FEAT_OPTIONAL = 0b01,
+	LUO_FEAT_RESERVED = 0b10,
+	LUO_FEAT_REQUIRED = 0b11,
+};
+
+/**
+ * struct luo_ser_hdr - Base 8-byte header for serialized LUO ABI structures.
+ * @size:        Total size of the serialized structure in bytes (header +
+ *               `flags` + payload).
+ * @nr_features: Number of features encoded in @flags.
+ * @flags:       64-bit feature flags entries (`DIV_ROUND_UP(@nr_features, 32)`
+ *               entries). Each entry encodes 32 features (2 bits per feature:
+ *               feature `N` is in `flags[N / 32]` bits
+ *               `[2*(N % 32) + 1 : 2*(N % 32)]`).
+ */
+struct luo_ser_hdr {
+	__u32 size;
+	__u32 nr_features;
+	__u64 flags[];
+};
+
+static_assert(sizeof(struct luo_ser_hdr) == 8);
+
+/*
+ * Each subsystem declares a wrapper structure with DECLARE_LUO_SER_WRAP() (for
+ * example `struct memfd_luo_ser_wrap` or `struct luo_ser_wrap`) holding the
+ * header, any 64-bit `flags` entries and its payload, allocates it with
+ * sizeof() and initializes the header with the generated wrapper initializer
+ * (e.g. luo_ser_wrap_init()). The structure matches only the layout this kernel
+ * writes, so incoming state is never cast to it; the target kernel uses
+ * luo_ser_hdr_validate() and luo_ser_payload() instead.
+ */
+
+#define LUO_SER_NR_FLAGS(nr_features)	DIV_ROUND_UP_POW2(nr_features, LUO_FEAT_PER_FLAGS)
+
+/**
+ * DECLARE_LUO_SER_WRAP - Declare an outgoing LUO header + payload wrapper structure.
+ * @name:          Name of the payload structure (`struct @name`).
+ * @expected_size: Expected total size in bytes of `struct @name_wrap`.
+ * @nr_features:   Number of features defined for `struct @name`.
+ *
+ * Declares `struct @name_wrap` and inline initializer `@name_wrap_init()`
+ * for the source kernel to allocate and populate when preserving state.
+ * It matches only the layout written by this kernel; incoming state from
+ * another kernel must be validated with luo_ser_hdr_validate() and its
+ * payload reached via luo_ser_payload().
+ */
+#define DECLARE_LUO_SER_WRAP(name, expected_size, nr_features)		\
+	struct name##_wrap {						\
+		union {							\
+			struct luo_ser_hdr hdr;				\
+			struct {					\
+				__u32 __size;				\
+				__u32 __nr_features;			\
+				__u64 flags[LUO_SER_NR_FLAGS(nr_features)];\
+				struct name ser;			\
+			};						\
+		};							\
+	};								\
+	static_assert(sizeof(struct name##_wrap) == (expected_size),	\
+		      "LUO struct " #name " size mismatch!");		\
+	static inline void name##_wrap_init(struct name##_wrap *wrap)	\
+	{								\
+		luo_ser_hdr_init(&wrap->hdr, sizeof(*wrap), (nr_features));\
+	}
+
+/**
+ * luo_ser_hdr_size - Header size of a serialized header.
+ * @hdr: Pointer to the serialized &struct luo_ser_hdr.
+ *
+ * Return: Size of @hdr in bytes, including its 64-bit `flags` entries.
+ */
+static inline size_t luo_ser_hdr_size(const struct luo_ser_hdr *hdr)
+{
+	return struct_size(hdr, flags, LUO_SER_NR_FLAGS(hdr->nr_features));
+}
+
+/**
+ * luo_ser_hdr_init - Initialize a feature header.
+ * @hdr:         Pointer to the &struct luo_ser_hdr to initialize.
+ * @size:        Total size of the serialized structure (header, `flags` entries
+ *               and payload), normally sizeof() of the wrapper structure.
+ * @nr_features: Number of features to accommodate.
+ *
+ * Sets @hdr->size and @hdr->nr_features, and clears the 64-bit `flags` entries.
+ * Touches only the header.
+ */
+static inline void
+luo_ser_hdr_init(struct luo_ser_hdr *hdr, size_t size, u32 nr_features)
+{
+	hdr->size = size;
+	hdr->nr_features = nr_features;
+	memset(hdr->flags, 0, LUO_SER_NR_FLAGS(nr_features) * sizeof(hdr->flags[0]));
+}
+
+/*
+ * These helpers operate on any well-formed header: one initialized on the
+ * outgoing path or validated by luo_ser_hdr_validate() on the incoming path.
+ */
+
+/**
+ * luo_ser_payload - Get pointer to the payload immediately following @hdr.
+ * @hdr: Pointer to the serialized &struct luo_ser_hdr.
+ *
+ * @hdr must be initialized or validated.
+ *
+ * Return: Pointer to the payload structure.
+ */
+static inline void *luo_ser_payload(const struct luo_ser_hdr *hdr)
+{
+	return (void *)((const char *)hdr + luo_ser_hdr_size(hdr));
+}
+
+/**
+ * luo_ser_set_feat - Set the 2-bit state of feature @feat in @hdr.
+ * @hdr:   Pointer to &struct luo_ser_hdr.
+ * @feat:  Feature index.
+ * @state: Feature state (&enum luo_feat_state).
+ *
+ * @hdr must be initialized or validated.
+ */
+static inline void
+luo_ser_set_feat(struct luo_ser_hdr *hdr, u32 feat, enum luo_feat_state state)
+{
+	u32 idx, slot;
+
+	if (WARN_ON_ONCE(feat >= hdr->nr_features))
+		return;
+
+	idx = feat / LUO_FEAT_PER_FLAGS;
+	slot = feat % LUO_FEAT_PER_FLAGS;
+	hdr->flags[idx] &= ~(LUO_FEAT_STATE_MASK << (2 * slot));
+	hdr->flags[idx] |= (u64)(state & LUO_FEAT_STATE_MASK) << (2 * slot);
+}
+
+/**
+ * luo_ser_get_feat - Query the 2-bit state of feature @feat in @hdr.
+ * @hdr:  Pointer to &struct luo_ser_hdr.
+ * @feat: Feature index.
+ *
+ * @hdr must be initialized or validated.
+ *
+ * Return: &enum luo_feat_state (returns %LUO_FEAT_ABSENT if @feat is beyond
+ *         @hdr->nr_features).
+ */
+static inline enum luo_feat_state
+luo_ser_get_feat(const struct luo_ser_hdr *hdr, u32 feat)
+{
+	u32 idx, slot;
+
+	if (feat >= hdr->nr_features)
+		return LUO_FEAT_ABSENT;
+
+	idx = feat / LUO_FEAT_PER_FLAGS;
+	slot = feat % LUO_FEAT_PER_FLAGS;
+
+	return (hdr->flags[idx] >> (2 * slot)) & LUO_FEAT_STATE_MASK;
+}
 
 /**
- * struct luo_ser - Centralized LUO ABI header.
- * @compatible:     Compatibility string identifying the LUO ABI version.
+ * luo_ser_hdr_validate - Validate source kernel's feature header.
+ * @hdr:          Pointer to the feature header from the source kernel.
+ * @supported:    Target kernel's supported features table, indexed by feature.
+ * @nr_supported: Number of entries in @supported.
+ *
+ * Checks each source feature state in @hdr against @supported[i] using the
+ * truth table in the DOC section above.
+ *
+ * Return: 0 if compatible, or -EOPNOTSUPP on required feature mismatch.
+ */
+static inline int
+luo_ser_hdr_validate(const struct luo_ser_hdr *hdr,
+		     const bool *supported, u32 nr_supported)
+{
+	u32 feat;
+
+	for (feat = 0; feat < hdr->nr_features; feat++)
+		if (luo_ser_get_feat(hdr, feat) == LUO_FEAT_REQUIRED &&
+		    (feat >= nr_supported || !supported[feat]))
+			return -EOPNOTSUPP;
+
+	return 0;
+}
+
+/**
+ * enum luo_core_feature - Feature indices for &struct luo_ser.
+ * @LUO_CORE_FEAT_CORE: Core feature covering `liveupdate_num`, `sessions_pa`
+ *                      and `flbs_pa`.
+ * @LUO_CORE_FEAT_MAX:  Number of defined &enum luo_core_feature features.
+ */
+enum luo_core_feature {
+	LUO_CORE_FEAT_CORE = 0,
+	LUO_CORE_FEAT_MAX,
+};
+
+/**
+ * struct luo_ser - Centralized LUO ABI payload.
  * @liveupdate_num: A counter tracking the number of successful live updates.
  * @sessions_pa:    Physical address of the first session block header.
  * @flbs_pa:        Physical address of the FLB header.
  *
- * This structure is the root of all preserved LUO state.
+ * This structure is the root payload of all preserved LUO state, preceded by
+ * &struct luo_ser_hdr.
  */
 struct luo_ser {
-	char compatible[LUO_ABI_COMPAT_LEN];
 	u64 liveupdate_num;
 	u64 sessions_pa;
 	u64 flbs_pa;
 };
 
-static_assert(sizeof(struct luo_ser) == 32);
+static_assert(sizeof(struct luo_ser) == 24);
+
+/* LUO state written by this kernel. Never cast incoming state to it. */
+DECLARE_LUO_SER_WRAP(luo_ser, 40, LUO_CORE_FEAT_MAX);
 
 #define LIVEUPDATE_HNDL_COMPAT_LENGTH	48
 
@@ -95,7 +359,7 @@ static_assert(sizeof(struct luo_ser) == 32);
  * @data:        Private data
  * @token:       User provided token for this file
  *
- * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
+ * Layout changes must be gated by a feature in &enum luo_core_feature.
  */
 struct luo_file_ser {
 	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
@@ -130,10 +394,10 @@ static_assert(sizeof(struct luo_file_set_ser) == 16);
  *
  * This structure is used to package session-specific metadata for transfer
  * between kernels via Kexec Handover. An array of these structures (one per
- * session) is created and passed to the new kernel, allowing it to reconstruct
- * the session context.
+ * session) is created and passed to the target kernel, allowing it to
+ * reconstruct the session context.
  *
- * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
+ * Layout changes must be gated by a feature in &enum luo_core_feature.
  */
 struct luo_session_ser {
 	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
@@ -156,7 +420,7 @@ static_assert(sizeof(struct luo_session_ser) == 80);
  * This structure is located at the physical address specified by the
  * flbs_pa in luo_ser.
  *
- * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
+ * Layout changes must be gated by a feature in &enum luo_core_feature.
  */
 struct luo_flb_header_ser {
 	u64 pgcnt;
@@ -168,19 +432,19 @@ static_assert(sizeof(struct luo_flb_header_ser) == 16);
 /**
  * struct luo_flb_ser - Represents the serialized state of a single FLB object.
  * @name:    The unique compatibility string of the FLB object, used to find the
- *           corresponding &struct liveupdate_flb handler in the new kernel.
+ *           corresponding &struct liveupdate_flb in the target kernel.
  * @data:    The opaque u64 handle returned by the FLB's .preserve() operation
- *           in the old kernel. This handle encapsulates the entire state needed
- *           for restoration.
+ *           in the source kernel. This handle encapsulates the entire state
+ *           needed for restoration.
  * @count:   The reference count at the time of serialization; i.e., the number
  *           of preserved files that depended on this FLB. This is used by the
- *           new kernel to correctly manage the FLB's lifecycle.
+ *           target kernel to correctly manage the FLB's lifecycle.
  *
  * An array of these structures is created in a preserved memory region and
- * passed to the new kernel. Each entry allows the LUO core to restore one
- * global, shared object.
+ * passed to the target kernel. Each entry allows the LUO core to restore
+ * one global, shared object.
  *
- * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
+ * Layout changes must be gated by a feature in &enum luo_core_feature.
  */
 struct luo_flb_ser {
 	char name[LIVEUPDATE_FLB_COMPAT_LENGTH];
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 1b2bda22902d..ab0bcb5f6e11 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -66,10 +66,14 @@
 
 static struct {
 	bool enabled;
-	struct luo_ser *luo_ser_out;
+	struct luo_ser_wrap *luo_ser_out;
 	u64 liveupdate_num;
 } luo_global;
 
+static const bool luo_core_supported_feats[LUO_CORE_FEAT_MAX] = {
+	[LUO_CORE_FEAT_CORE] = true,
+};
+
 /*
  * luo_register_rwlock - Protects registration of file handlers and FLBs.
  */
@@ -84,7 +88,8 @@ early_param("liveupdate", early_liveupdate_param);
 static int __init luo_early_startup(void)
 {
 	phys_addr_t luo_ser_phys;
-	struct luo_ser *luo_ser;
+	struct luo_ser_hdr *hdr;
+	const struct luo_ser *ser;
 	size_t len;
 	int err;
 
@@ -107,31 +112,38 @@ static int __init luo_early_startup(void)
 		return 0;
 	}
 
-	if (len < sizeof(*luo_ser)) {
-		pr_err("LUO state is too small (%zu < %zu)\n", len, sizeof(*luo_ser));
-		return -EINVAL;
+	hdr = phys_to_virt(luo_ser_phys);
+	if (len < sizeof(*hdr) || hdr->size > len) {
+		pr_err("LUO state size invalid (source kernel header size=%u, KHO len=%zu)\n",
+		       len >= sizeof(*hdr) ? hdr->size : 0, len);
+		err = -EINVAL;
+		goto out_free_ser;
 	}
 
-	luo_ser = phys_to_virt(luo_ser_phys);
-	if (strncmp(luo_ser->compatible, LUO_ABI_COMPATIBLE, LUO_ABI_COMPAT_LEN)) {
-		pr_err("LUO state is incompatible with '%s'\n", LUO_ABI_COMPATIBLE);
-		return -EINVAL;
+	/* Only the core fields are needed; later fields are checked per feature. */
+	err = luo_ser_hdr_validate(hdr, luo_core_supported_feats,
+				   ARRAY_SIZE(luo_core_supported_feats));
+	if (err) {
+		pr_err("LUO state feature header validation failed (size=%u, nr_features=%u): %pe\n",
+		       hdr->size, hdr->nr_features, ERR_PTR(err));
+		goto out_free_ser;
 	}
 
-	luo_global.liveupdate_num = luo_ser->liveupdate_num;
+	ser = luo_ser_payload(hdr);
+	luo_global.liveupdate_num = ser->liveupdate_num;
 	pr_info("Retrieved live update data, liveupdate number: %lld\n",
 		luo_global.liveupdate_num);
 
-	err = luo_session_setup_incoming(luo_ser->sessions_pa);
+	err = luo_session_setup_incoming(ser->sessions_pa);
 	if (err)
 		goto out_free_ser;
 
-	luo_flb_setup_incoming(luo_ser->flbs_pa);
+	luo_flb_setup_incoming(ser->flbs_pa);
 
 	err = 0;
 
 out_free_ser:
-	kho_restore_free(luo_ser);
+	kho_restore_free(hdr);
 	return err;
 }
 
@@ -153,34 +165,36 @@ early_initcall(liveupdate_early_init);
 /* Called during boot to create outgoing LUO state */
 static int __init luo_state_setup(void)
 {
-	struct luo_ser *luo_ser;
+	struct luo_ser_wrap *wrap;
 	int err;
 
-	luo_ser = kho_alloc_preserve(sizeof(*luo_ser));
-	if (IS_ERR(luo_ser)) {
+	wrap = kho_alloc_preserve(sizeof(*wrap));
+	if (IS_ERR(wrap)) {
 		pr_err("failed to allocate/preserve LUO state memory\n");
-		return PTR_ERR(luo_ser);
+		return PTR_ERR(wrap);
 	}
 
-	strscpy(luo_ser->compatible, LUO_ABI_COMPATIBLE, sizeof(luo_ser->compatible));
-	luo_ser->liveupdate_num = luo_global.liveupdate_num + 1;
+	luo_ser_wrap_init(wrap);
+	luo_ser_set_feat(&wrap->hdr, LUO_CORE_FEAT_CORE, LUO_FEAT_REQUIRED);
+
+	wrap->ser.liveupdate_num = luo_global.liveupdate_num + 1;
 
-	luo_session_setup_outgoing(&luo_ser->sessions_pa);
+	luo_session_setup_outgoing(&wrap->ser.sessions_pa);
 
-	err = luo_flb_setup_outgoing(&luo_ser->flbs_pa);
+	err = luo_flb_setup_outgoing(&wrap->ser.flbs_pa);
 	if (err)
 		goto exit_free_luo_ser;
 
-	err = kho_add_subtree(LUO_KHO_ENTRY_NAME, luo_ser, sizeof(*luo_ser));
+	err = kho_add_subtree(LUO_KHO_ENTRY_NAME, wrap, sizeof(*wrap));
 	if (err)
 		goto exit_free_luo_ser;
 
-	luo_global.luo_ser_out = luo_ser;
+	luo_global.luo_ser_out = wrap;
 
 	return 0;
 
 exit_free_luo_ser:
-	kho_unpreserve_free(luo_ser);
+	kho_unpreserve_free(wrap);
 	pr_err("failed to prepare LUO state: %d\n", err);
 
 	return err;
-- 
2.56.0.307.g5fe7bd680c-goog


