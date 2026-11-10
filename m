Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6621D606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=j+8zB4Z/
Received: by kanga.kvack.org (Postfix)
	id 88A726B05B1; Tue, 10 Nov 2026 00:08:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862A16B05E0; Tue, 10 Nov 2026 00:08:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779166B05E1; Tue, 10 Nov 2026 00:08:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0766B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:08:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCF78808C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:08:24 +0000 (UTC)
X-FDA: 85418028528.16.50E7FC5
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com [209.85.167.69])
	by imf23.hostedemail.com (Postfix) with ESMTP id 09FF0140003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:08:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="j+8zB4Z/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3UqXyagkKCMU4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com designates 209.85.167.69 as permitted sender) smtp.mailfrom=3UqXyagkKCMU4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794287303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ktkwbxS31+AJAEtLgON1FC5vgxwtOH8mMNa0BnHkPzQ=;
	b=0FUzkOzzWZHXZOJg2lMfa6DoGtmyTxvMh22p1xCe4EgCt+1zOvoC/GYMpXxHn8Fluuok19
	1jCnhhS9xyESXT5/5cmg4PPCwyLqaEwbRuCN19fV5W4Oqy9I3F3RO9BAgmakcEAkhXIjJQ
	+Rrhy7ZVT7jVsUlrawvT4PUBOEpWzCI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="j+8zB4Z/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3UqXyagkKCMU4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com designates 209.85.167.69 as permitted sender) smtp.mailfrom=3UqXyagkKCMU4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794287303;
	b=dG0IIe1lA62Ad9KTXN5vnlb0Ss2GYmlvpWbDItVYXtoGgDr2t3VRrp+y/QoDl/sxYHnYaf
	dbqzQWltmvjNBsrkA67w1jClhGNEocry+uCewMOluc8VX5S03ui03+zY/Zbl65tSH4K4KB
	IBcjJqXZmdegfdyGO2hiEXtI1JOhDN8=
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5c1595fb6bcso71001e87.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794287301; x=1794892101; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ktkwbxS31+AJAEtLgON1FC5vgxwtOH8mMNa0BnHkPzQ=;
        b=j+8zB4Z/hi2Z0lsV1BSTsorroeUkB2DQ+t5c/A5wx619U5rVFW6CZYMErF7HAEPtix
         Y494YzKnrmdABNWVwmEmmEKcAKlIa0YhAOvCjV9YoUPOddZZmy7QdjHonXCmo9sVuk6W
         KGIJk5tEvZqcBubvGK8BOq4EtOtmHLCNNbGf/0OBdn5EZNBpS4Chk0B31QqhZE9RSY1v
         nVQjH0eNU7fnmQu5+eKzsovhjvHlHTsdZtUc2nW1kosN7Mvm1prmkpty1KvjhL0EqA9L
         VZClRgjm1Phi5VT1tv4c7kWICLatXMoVuY/kjzcTZsTHbiAdbwhq154diHIK7LU0MtJd
         6+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794287301; x=1794892101;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ktkwbxS31+AJAEtLgON1FC5vgxwtOH8mMNa0BnHkPzQ=;
        b=v3M0Jk3TRZHtoAjeIRDOT/k7aYMTrNvsCKpE53NqsbF/jbWnhyV5dOky8LtpY/2XL4
         ovVsGsRhhZC3LgcsmihphMQ6z9rhahdu6bG6qeSFXMzsyCWsmU8PMgwkcetls5hs3+wl
         LvcsQDdj7TiaKLm99T1MHdzwaIuor2mY5spWHQlNozvaW+OLZB0Wy2K8P+tXl4oYmAd+
         gVMRnYZSpYNaswANgmfJQgg6GDzs/nSeBcy45XVk/PTnVPDYWmc5uwzXaSM450BKdVbi
         99psTwosfspGh9hhkHGK6KWFa9+ZLgKIzfsNs0Z1uQYNhX4V8cUotgkTnqj950Jd87Ce
         pbrw==
X-Forwarded-Encrypted: i=1; AL+hErF1ZsSNNJ1HxVCEl7bpLdoK1lWkFWGB9+IYYPXAu3wMAUlq+YBimjhapaes0NEvzX6v5Yh7FalAHg==@kvack.org
X-Gm-Message-State: APuU4Z/rBlOm+2pHLBOWDk2F6fYFZF9op2+/UvlfzfGQ1qE9wu0XpReJ
	WmMUO0QNls0dpVdvOkZgLMa9xOHaL9fMnXGyDKNEJpnNioKtVkojkxy0pMflHHGfErNGuywZo4v
	+1rVtGK/HOAE5JWDapg==
X-Received: from edra14.prod.google.com ([2002:aa7:d90e:0:b0:6b1:af33:7d07])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:947:b0:6b1:b97b:750 with SMTP id 4fb4d7f45d1cf-6b7564fbe2fmr835079a12.16.1794286930545;
 Mon, 09 Nov 2026 21:02:10 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:48 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-6-tarunsahu@google.com>
Subject: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI compatibility
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 09FF0140003
X-Stat-Signature: rw3o4bcimtyx33hdhiqm4i3tup411t4x
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794287302-309131
X-HE-Meta: U2FsdGVkX19HlGnDYjn5+NW59sWncXK4wkZd8S61c12Jj2GS+tq8mEciTxYpHEXssGeusbJjPHnSKMgijHpc1JLrCLK7whrTRen2Q1/i6zo6fUygbycrj5Fr3MUlcsWng8mtTqPASpo3VkJ3vEeHELDtmZOZeIL32X+vNfH63+fe7j3r9I6e0epc4HbdiBCb69SYLN9vd0QbX9KfWGshx4EiPLaFAjuWaBeBuVnyyAVKUKsHt5B77Y2SIOxYEhEtku4H/v489dUjj79EaVLDr7mkHpYbmcCh+zbTKE9wQk+DzKBWYBs6X8SYAr+ET4I9VDRc46F5NY2WMV0p0jxEhzOVsvGbI3RUGZ+depfnWBwPVAyjXlfmOEp2+sABaj/wuOCI2+7OLfEy3iEJv5oyAbSVguKAaia499q30jRKA1aEoVweMDzcMJXO9aBxr8WapfaW5+F3O/Qqae2Fen9Z+QYvlobWxRnjwH3ZOUBlzuDVP32cMXbkAE8kOkhVTj7Z0Xr+E7UIZ6EupFj0oabLv/Y+PwLnzpXvlnpggLW09BIOz9OMDQV2ZgZI9/3M23K1WqRHCdW2De39dKcZe0XueS1Gog3p8ZIbUt5TVjkX7+v0gkdfpeM7bI4NoT9x1FNk2H/YEZK4fFRzpybJAokZqHlKuOux0ULK9g8sgr/Ouv8v+cOpICcYORhM2OkywHUSOJ9dUtzRxZzKG2NvILsEQD/eQgNqls29D272WNbFQTvuuf3aWY67OygQOyExnbV2qwmAba5aIKAerycxjVLcfCwPYdq/UxT/Eg91et0Q9Lsv9msbN1se05V7okEAFnhIBpkWnssXT12XYTlGsm20pBsYPzrpksGTmdSPsxkLcviAz0Vkc3ME9uJbhL2AtS/JkFT9NASzLtDwC3OIQb8cnlkzLL+Kiwupda+126e3dv7tB8lAsjTHgPSO2oZRO9nNPFT493Ugb0rmLkipf4q
 zox4eM+P
 Hl0o/r4SH7lyOe2daKmhhBzy81I1CsQPCA0ctnraF+9lvUgMqeTDmNntrGBd0NibH1skxBdp9KLnNL6CHECBlQMnA2GFxnBHbiareZa8SsWsjdm5lrBArk9ZnvNqrn/rjYtlP5YdgHgQhIX1lzfu97PmlHcOqgzF+hwluGEs46FvE1lOFgB1Tddo/S/4wN03iP4gGE/PGKmNZBycS6lEYkmgG67NyunQpq/ErX9vFatLagH6RgJZ9qNy6Qb6vqI0F2qoDRoiMqaU6Ra6UK7ongJNe1u+XvoV6+Inc3vpAnLeJ2lxRCb6Lq0fbZ8c03HsmquDtUugM8Hvgji7RY4xaxmB+LfsBsm4koLrxFNngkV+3oPB+ZsGW1ETH1v5NA8fWpOChNnZSD0H8zo3BiGkl04tFQu1zzsrtZLNvmkuqFB9vOpXZ1Y6Ic0CwyQAc/iziCiC+o1GZQ4xrlfnapiepN0P1AvUErRsTkeMu/PpQSvcESRdBBNMlti9rsmSxmn/FkwKLsLD4uKVDEkxMCJ56G0Ig1KpdV2hvxyXFS6wMbDsAGZ+2MOxpU8l3IoGjUGMWPB1D7UHUCWd/g9yQZLn61iI9Dt4RNVlCfhWAKScWJWQUpeDtITmlSCXaAn/Lgzu17zzBHWpE/mPA4EO7i75X9J1ejld2QgfdxI7s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Serialized structures in KHO and Live Update Orchestrator currently rely
on whole-structure compatibility strings or monolithic version fields to
validate handed-over state across kexec. Any change to a serialized
structure, even an optional additive field, requires bumping the
compatibility string or version number and breaks live update between
adjacent kernels.

Introduce a generic feature header (struct kho_ser_hdr) for serialized
binary structures in include/linux/kho/abi/feature.h. Each subsystem
groups the fields of its serialized structure under feature indices,
starting with index 0 for base fields. When a subsystem adds a new
capability, it appends new fields to the end of its payload structure
under a new feature index. Retired fields are kept in place so existing
field offsets never shift; if the type or format of a field needs to
change, the existing field and feature are kept intact until retired and
a new feature index with an appended field of the new type is added.
Only when a change requires a complete break in the serialized layout or
semantics that feature flags cannot handle, a new handler or format can
be introduced with an incremented version number.

Each feature belongs to either a required feature space or an optional
feature space. Both spaces are numbered independently starting from 0.
In the serialized header, required features occupy the first nr_required
bits, followed immediately by nr_optional bits for optional features:

  struct kho_ser_hdr {
          __u32 size;
          __u16 nr_required;
          __u16 nr_optional;
          __aligned_u64 flags[];
  };

A set bit indicates that the feature is present in the payload. The
truth table for deserialization:

  Source bit       Target            Action
  Not set          -                 Accept: feature absent
  Optional set     unknown or known  Accept: ignore or use the data
  Required set     known             Accept: use the feature data
  Required set     unknown           Reject: -EOPNOTSUPP

During deserialization, the target kernel only validates required
features: if the source set any required feature bit at or beyond the
known required feature count of the target kernel, validation fails with
-EOPNOTSUPP. Optional features are never rejected; the target kernel
simply checks whether known optional features are present before reading
their data.

No subsystem defines feature flags yet. Every converted structure is
registered with 0 required and 0 optional features, producing a compact
8-byte header with no flags entries. Feature enums can be added later as
needed, once the first additive feature is introduced for a particular
serialized structure. With nr_required set to 0, kho_ser_validate()
rejects any incoming required feature bit while ignoring optional bits,
allowing future kernels with additive features to evolve smoothly in
both directions.

Each subsystem registers its serialized structure with:

        DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)

This establishes compile-time assertions and provides type-checked
helpers: kho_ser_size() for total allocation size, kho_ser_init() to
initialize the header, kho_ser_payload() to access the typed payload at
its dynamic offset, and kho_ser_validate() to validate required features
during restoration. DECLARE_KHO_SER_HDR(name, *fhdr) declares a struct
kho_ser_hdr pointer while verifying at compile time that name was
registered with DECLARE_KHO_SER(), allowing callers to document which
structure a feature header pointer represents.

An example demonstrating how a hypothetical structure defines its
features:

  enum foo_ser_required {
          FOO_SER_REQ_BAR,
          __FOO_SER_NR_REQUIRED,
  };

  enum foo_ser_optional {
          FOO_SER_OPT_BAZ,
          __FOO_SER_NR_OPTIONAL,
  };

  struct foo_ser {
          __u64 base;     /* base fields, always present */
          __u64 bar;      /* FOO_SER_REQ_BAR */
          __u64 baz;      /* FOO_SER_OPT_BAZ */
  };

  DECLARE_KHO_SER(foo_ser, 24,
                  __FOO_SER_NR_REQUIRED, __FOO_SER_NR_OPTIONAL);

  /* Serialize */
  kho_ser_init(fhdr, foo_ser);
  ser = kho_ser_payload(fhdr, foo_ser);
  ser->bar = ...;
  kho_ser_set_required(fhdr, FOO_SER_REQ_BAR);
  ser->baz = ...;
  kho_ser_set_optional(fhdr, FOO_SER_OPT_BAZ);

  /* Restore */
  err = kho_ser_validate(fhdr, foo_ser);
  ser = kho_ser_payload(fhdr, foo_ser);
  if (kho_ser_has_required(fhdr, FOO_SER_REQ_BAR))
          use ser->bar;
  if (kho_ser_has_optional(fhdr, FOO_SER_OPT_BAZ))
          use ser->baz;

Required and optional features each have their own enum, numbered
independently from 0. New features are only appended at the end of their
enum, never reordered or reused. The last entry of each enum (e.g.
__FOO_SER_NR_REQUIRED) is the feature count passed to DECLARE_KHO_SER and
stays last. The fields of a new feature are appended at the end of the
payload. A reader accesses the fields of a feature only when its bit is set
in the incoming header (kho_ser_has_required() or kho_ser_has_optional()),
because an older source kernel does not serialize them. Use required for
data the target must understand to restore correctly, and optional for
data it can safely ignore. Variable length data that follows the payload,
such as an array of entries, starts at fhdr->size, the size recorded by the
source kernel, so it stays correct when a later feature appends fields to
the payload. Document that serialization helpers describe this kernel's
layout while deserialization helpers follow the incoming header.

Suggested-by: David Matlack <dmatlack@google.com>
Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/feature.h | 372 ++++++++++++++++++++++++++++++++
 1 file changed, 372 insertions(+)
 create mode 100644 include/linux/kho/abi/feature.h

diff --git a/include/linux/kho/abi/feature.h b/include/linux/kho/abi/feature.h
new file mode 100644
index 000000000000..55ff1b9e9b73
--- /dev/null
+++ b/include/linux/kho/abi/feature.h
@@ -0,0 +1,372 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/**
+ * DOC: KHO Serialization Feature Header ABI
+ *
+ * Generic feature header for serialized binary data structures preserved
+ * across kexec via KHO or Live Update Orchestrator (LUO).
+ *
+ * Serialized structures start with an 8-byte base header (struct kho_ser_hdr)
+ * containing the total structure size (size, including header, flags, and
+ * payload) in bytes, the number of required features (nr_required), and the
+ * number of optional features (nr_optional). Following the header is a
+ * flexible array of 64-bit flags entries (flags[]) containing one bit per
+ * feature.
+ *
+ * Feature bits:
+ *   - Required feature N is at bit N of flags[].
+ *   - Optional feature N is at bit (nr_required + N) of flags[].
+ *   - The number of __u64 entries in flags[] is
+ *     DIV_ROUND_UP(nr_required + nr_optional, 64).
+ *   - When nr_required == 0 and nr_optional == 0, flags[] has zero entries
+ *     and the header is exactly 8 bytes.
+ *
+ * A set bit indicates that the feature is present in the payload.
+ *
+ * Deserialization truth table:
+ *
+ *   Source bit       Target            Action
+ *   ----------       ------            ------
+ *   Not set          -                 Accept: feature absent
+ *   Optional set     unknown or known  Accept: ignore or use the data
+ *   Required set     known             Accept: use the feature data
+ *   Required set     unknown           Reject: -EOPNOTSUPP
+ *
+ * Validation trusts the incoming header: only set required feature bits at or
+ * beyond the target's known required feature count are rejected (-EOPNOTSUPP).
+ * Optional feature bits are never validated.
+ *
+ * Defining features:
+ *
+ * A serialized structure defines its features using enums and registers with
+ * DECLARE_KHO_SER()::
+ *
+ *   enum foo_ser_required {
+ *           FOO_SER_REQ_BAR,
+ *           __FOO_SER_NR_REQUIRED,
+ *   };
+ *
+ *   enum foo_ser_optional {
+ *           FOO_SER_OPT_BAZ,
+ *           __FOO_SER_NR_OPTIONAL,
+ *   };
+ *
+ *   struct foo_ser {
+ *           __u64 base;     // base fields, always present
+ *           __u64 bar;      // FOO_SER_REQ_BAR
+ *           __u64 baz;      // FOO_SER_OPT_BAZ
+ *   };
+ *
+ *   DECLARE_KHO_SER(foo_ser, 24,
+ *                   __FOO_SER_NR_REQUIRED, __FOO_SER_NR_OPTIONAL);
+ *
+ *   // Serialize
+ *   kho_ser_init(fhdr, foo_ser);
+ *   ser = kho_ser_payload(fhdr, foo_ser);
+ *   ser->bar = ...;
+ *   kho_ser_set_required(fhdr, FOO_SER_REQ_BAR);
+ *   ser->baz = ...;
+ *   kho_ser_set_optional(fhdr, FOO_SER_OPT_BAZ);
+ *
+ *   // Restore
+ *   err = kho_ser_validate(fhdr, foo_ser);
+ *   ser = kho_ser_payload(fhdr, foo_ser);
+ *   if (kho_ser_has_required(fhdr, FOO_SER_REQ_BAR))
+ *           use ser->bar;
+ *   if (kho_ser_has_optional(fhdr, FOO_SER_OPT_BAZ))
+ *           use ser->baz;
+ *
+ * Rules:
+ *   - Required and optional features each have their own enum, numbered
+ *     independently from 0.
+ *   - New features are only appended at the end of their enum, never
+ *     reordered or reused.
+ *   - The last entry of each enum (e.g. __FOO_SER_NR_REQUIRED) is the
+ *     feature count passed to DECLARE_KHO_SER and stays last.
+ *   - The fields of a new feature are appended at the end of the payload.
+ *   - A reader accesses the fields of a feature only when its bit is set in
+ *     the incoming header (kho_ser_has_required() or
+ *     kho_ser_has_optional()), because an older source kernel does not
+ *     serialize them.
+ *   - Use required for data the target must understand to restore
+ *     correctly, and optional for data it can safely ignore.
+ *   - Variable length data that follows the payload, such as an array of
+ *     entries, starts at fhdr->size, the size recorded by the source kernel,
+ *     so it stays correct when a later feature appends fields to the
+ *     payload.
+ *
+ * Writing and reading:
+ *
+ * kho_ser_size(), kho_ser_init(), kho_ser_set_required() and
+ * kho_ser_set_optional() (and the clear variants) use the values this
+ * kernel registered with DECLARE_KHO_SER(), so they describe this
+ * kernel's layout and are used when serializing.
+ *
+ * A reader of handed-over data uses only the incoming header:
+ * kho_ser_validate(), kho_ser_hdr_size(), kho_ser_payload(),
+ * kho_ser_has_required(), kho_ser_has_optional() and fhdr->size, so
+ * it follows the layout of the kernel that wrote the data. On data
+ * this kernel serialized, these give the same result.
+ *
+ * Use DECLARE_KHO_SER_HDR(name, *fhdr) (or const
+ * DECLARE_KHO_SER_HDR(name, *fhdr)) to document which registered
+ * structure a feature header pointer belongs to while verifying at
+ * compile time that the structure is registered with DECLARE_KHO_SER().
+ */
+
+#ifndef _LINUX_KHO_ABI_FEATURE_H
+#define _LINUX_KHO_ABI_FEATURE_H
+
+#include <linux/build_bug.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/math.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+/**
+ * struct kho_ser_hdr - Header for serialized data structures in KHO.
+ * @size:        Total size in bytes (header + flags + payload).
+ * @nr_required: Number of required features known to the source kernel.
+ * @nr_optional: Number of optional features known to the source kernel.
+ * @flags:       Bitmask of present features (required, then optional).
+ */
+struct kho_ser_hdr {
+	__u32 size;
+	__u16 nr_required;
+	__u16 nr_optional;
+	__aligned_u64 flags[];
+};
+
+static_assert(sizeof(struct kho_ser_hdr) == 8);
+static_assert(__alignof__(struct kho_ser_hdr) == 8);
+
+#define KHO_SER_NR_FLAGS(nr_required, nr_optional) \
+	DIV_ROUND_UP((__u32)(nr_required) + (__u32)(nr_optional), 64)
+
+/**
+ * kho_ser_hdr_size - Calculate header size in bytes including flags.
+ * @fhdr: Pointer to the serialization header.
+ *
+ * Return: Size of the header and flags array in bytes.
+ */
+static inline size_t kho_ser_hdr_size(const struct kho_ser_hdr *fhdr)
+{
+	return sizeof(*fhdr) + sizeof(__u64) *
+		KHO_SER_NR_FLAGS(fhdr->nr_required, fhdr->nr_optional);
+}
+
+/**
+ * kho_ser_set_required - Mark a required feature present in the payload.
+ * @fhdr:  Pointer to the serialization header.
+ * @feat: Required feature index to set.
+ */
+static inline void kho_ser_set_required(struct kho_ser_hdr *fhdr, unsigned int feat)
+{
+	if (feat < fhdr->nr_required)
+		fhdr->flags[feat / 64] |= 1ULL << (feat % 64);
+}
+
+/**
+ * kho_ser_clear_required - Clear a required feature in the payload.
+ * @fhdr:  Pointer to the serialization header.
+ * @feat: Required feature index to clear.
+ */
+static inline void kho_ser_clear_required(struct kho_ser_hdr *fhdr, unsigned int feat)
+{
+	if (feat < fhdr->nr_required)
+		fhdr->flags[feat / 64] &= ~(1ULL << (feat % 64));
+}
+
+/**
+ * kho_ser_set_optional - Mark an optional feature present in the payload.
+ * @fhdr:  Pointer to the serialization header.
+ * @feat: Optional feature index to set.
+ */
+static inline void kho_ser_set_optional(struct kho_ser_hdr *fhdr, unsigned int feat)
+{
+	if (feat < fhdr->nr_optional) {
+		unsigned int bit = (unsigned int)fhdr->nr_required + feat;
+
+		fhdr->flags[bit / 64] |= 1ULL << (bit % 64);
+	}
+}
+
+/**
+ * kho_ser_clear_optional - Clear an optional feature in the payload.
+ * @fhdr:  Pointer to the serialization header.
+ * @feat: Optional feature index to clear.
+ */
+static inline void kho_ser_clear_optional(struct kho_ser_hdr *fhdr, unsigned int feat)
+{
+	if (feat < fhdr->nr_optional) {
+		unsigned int bit = (unsigned int)fhdr->nr_required + feat;
+
+		fhdr->flags[bit / 64] &= ~(1ULL << (bit % 64));
+	}
+}
+
+/**
+ * kho_ser_has_required - Check if a required feature is present in the payload.
+ * @fhdr:  Pointer to the serialization header.
+ * @feat: Required feature index to check.
+ *
+ * Return: True if the feature is present, false otherwise or if the index
+ *         exceeds the header's known required feature count.
+ */
+static inline bool kho_ser_has_required(const struct kho_ser_hdr *fhdr,
+					unsigned int feat)
+{
+	if (feat >= fhdr->nr_required)
+		return false;
+	return !!(fhdr->flags[feat / 64] & (1ULL << (feat % 64)));
+}
+
+/**
+ * kho_ser_has_optional - Check if an optional feature is present in the payload.
+ * @fhdr:  Pointer to the serialization header.
+ * @feat: Optional feature index to check.
+ *
+ * Return: True if the feature is present, false otherwise or if the index
+ *         exceeds the header's known optional feature count.
+ */
+static inline bool kho_ser_has_optional(const struct kho_ser_hdr *fhdr,
+					unsigned int feat)
+{
+	unsigned int bit;
+
+	if (feat >= fhdr->nr_optional)
+		return false;
+	bit = (unsigned int)fhdr->nr_required + feat;
+	return !!(fhdr->flags[bit / 64] & (1ULL << (bit % 64)));
+}
+
+/**
+ * __kho_ser_init - Initialize a serialization header and flags.
+ * @fhdr:          Pointer to the memory for the serialization header.
+ * @payload_size: Size of the payload structure in bytes.
+ * @nr_required:  Number of required features known by the caller.
+ * @nr_optional:  Number of optional features known by the caller.
+ */
+static inline void __kho_ser_init(struct kho_ser_hdr *fhdr, __u32 payload_size,
+				  __u16 nr_required, __u16 nr_optional)
+{
+	__u32 nr_flags = KHO_SER_NR_FLAGS(nr_required, nr_optional);
+
+	fhdr->size = sizeof(*fhdr) + sizeof(__u64) * nr_flags + payload_size;
+	fhdr->nr_required = nr_required;
+	fhdr->nr_optional = nr_optional;
+	memset(fhdr->flags, 0, sizeof(__u64) * nr_flags);
+}
+
+/**
+ * __kho_ser_payload - Return pointer to the payload following the header.
+ * @fhdr: Pointer to the serialization header.
+ *
+ * Return: Pointer to payload memory immediately after the flags array.
+ */
+static inline void *__kho_ser_payload(const struct kho_ser_hdr *fhdr)
+{
+	return (void *)((const char *)fhdr + kho_ser_hdr_size(fhdr));
+}
+
+/**
+ * __kho_ser_validate - Validate an incoming header against target capabilities.
+ * @fhdr:                Pointer to the serialization header.
+ * @target_nr_required: Number of required features supported by the target.
+ *
+ * Checks that the source did not set any required feature bits that the target
+ * kernel does not support (index >= @target_nr_required).
+ *
+ * Return: 0 if all required features are supported, or -EOPNOTSUPP on failure.
+ */
+static inline int __kho_ser_validate(const struct kho_ser_hdr *fhdr,
+				     __u16 target_nr_required)
+{
+	unsigned int i;
+
+	for (i = target_nr_required; i < fhdr->nr_required; i++) {
+		if (fhdr->flags[i / 64] & (1ULL << (i % 64)))
+			return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+/**
+ * DECLARE_KHO_SER - Register a serialized payload structure with KHO.
+ * @name:         Structure tag name (e.g. luo_ser).
+ * @payload_size: Compile-time expected size of struct @name in bytes.
+ * @nr_required:  Total number of defined required features.
+ * @nr_optional:  Total number of defined optional features.
+ *
+ * Size and 8-byte alignment are asserted under CONFIG_64BIT: KHO and LUO are
+ * 64-bit only, while !CONFIG_KEXEC_HANDOVER stubs pull ABI headers into
+ * 32-bit builds where u64 has 4-byte or 2-byte alignment.
+ */
+#define DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)	\
+	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
+		      sizeof(struct name) == (payload_size),		\
+		      "struct " #name " size mismatch");		\
+	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
+		      __alignof__(struct name) == 8,			\
+		      "struct " #name " must be 8-byte aligned");	\
+	extern struct kho_ser_hdr __kho_ser_hdr_##name;			\
+	enum {								\
+		__KHO_SER_SIZE_##name = (payload_size),			\
+		__KHO_SER_NR_REQUIRED_##name = (nr_required),		\
+		__KHO_SER_NR_OPTIONAL_##name = (nr_optional),		\
+	}
+
+/**
+ * DECLARE_KHO_SER_HDR - Declare a feature header variable, field, or parameter.
+ * @name: Structure tag name registered with DECLARE_KHO_SER().
+ * @decl: Declarator (e.g. *fhdr, **out_fhdr, or * inside DECLARE_KHOSER_PTR).
+ *
+ * Declares @decl with type struct kho_ser_hdr while checking at compile time
+ * that @name was registered with DECLARE_KHO_SER(), documenting which
+ * serialized payload structure a feature header pointer belongs to.
+ */
+#define DECLARE_KHO_SER_HDR(name, decl)	typeof(__kho_ser_hdr_##name) decl
+
+/**
+ * kho_ser_size - Total size of header, flags, and payload for a structure.
+ * @name: Structure tag name registered with DECLARE_KHO_SER().
+ */
+#define kho_ser_size(name)						\
+	(sizeof(struct kho_ser_hdr) +					\
+	 sizeof(__u64) * KHO_SER_NR_FLAGS(__KHO_SER_NR_REQUIRED_##name,	\
+					  __KHO_SER_NR_OPTIONAL_##name) +\
+	 __KHO_SER_SIZE_##name)
+
+/**
+ * kho_ser_init - Initialize a serialization header for a registered structure.
+ * @fhdr:  Pointer to allocated memory.
+ * @name: Structure tag name registered with DECLARE_KHO_SER().
+ */
+#define kho_ser_init(fhdr, name)						\
+	__kho_ser_init((fhdr), __KHO_SER_SIZE_##name,			\
+		       __KHO_SER_NR_REQUIRED_##name,			\
+		       __KHO_SER_NR_OPTIONAL_##name)
+
+/**
+ * kho_ser_payload - Return typed pointer to payload following the header.
+ * @fhdr:  Pointer to the serialization header.
+ * @name: Structure tag name registered with DECLARE_KHO_SER().
+ *
+ * The first operand only fails the build when DECLARE_KHO_SER(name) is
+ * missing.
+ */
+#define kho_ser_payload(fhdr, name)					\
+	((void)__KHO_SER_SIZE_##name,					\
+	 (struct name *)__kho_ser_payload(fhdr))
+
+/**
+ * kho_ser_validate - Validate incoming required features for a structure.
+ * @fhdr:  Pointer to the incoming serialization header.
+ * @name: Structure tag name registered with DECLARE_KHO_SER().
+ */
+#define kho_ser_validate(fhdr, name)					\
+	__kho_ser_validate((fhdr), __KHO_SER_NR_REQUIRED_##name)
+
+#endif /* _LINUX_KHO_ABI_FEATURE_H */
-- 
2.56.0.506.g506a7eabc5-goog


