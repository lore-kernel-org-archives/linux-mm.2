Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D47A9606A337
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 17:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ErCOTW/F
Received: by kanga.kvack.org (Postfix)
	id DCA5D6B05B0; Thu, 26 Nov 2026 12:22:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53D36B05B1; Thu, 26 Nov 2026 12:22:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C9A6B05B2; Thu, 26 Nov 2026 12:22:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B94B6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:22:59 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA6B91C42F3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:22:58 +0000 (UTC)
X-FDA: 85477940436.25.06F3BE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3D58B100007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:22:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ErCOTW/F";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795713777;
	b=a1STRJnyaSuoerm9L4P+9ZkaQTQYnwgqaGxnGMp4iZ/pKUGRQwnt/bn0iHmgLQVn2ufg95
	6aYo0r0xrvkR7dkaPLQhiP0ELbBX6AUI/uqnuGfTQwNyKuBoXP0uNDoPqRxoXAaUHqpSJ1
	/vKGA1UPBl3GqtYYPaK7LG9sCa4EOkE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795713777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXzERec3qi0h+0pnbo1I/7rHrxflf5UtHoI6hva8J+I=;
	b=o08zq/hhgT7R3YeElDUaBtbFSeoZqAwE0yUHP44e5IRJe9/J1ti4IclEB5L4ioqbE5EJwO
	M5eowgcMv3MgieXYfAOPWEJtkhX9HFGzJxrs/5x4OgCPkcJxxNLWUaDIc3pz8c0Ml2UQD9
	JLW0n6CwuHMrYiRQ1pa9Sp6A4IbuTZA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ErCOTW/F";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A48A60138;
	Thu, 26 Nov 2026 17:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232E21F000D0;
	Thu, 26 Nov 2026 17:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795713776;
	bh=sXzERec3qi0h+0pnbo1I/7rHrxflf5UtHoI6hva8J+I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ErCOTW/FmSA/4etDehKpUZ/FnuoYiC4phk3Lc5JABGLvJRGM+yYENk97mUzByHtGL
	 7WZ/K3Cl4KR4vWeBbAOGDPAGZiZfQeuuZYVnaPT/Go99PAhcfYVGs6duVMibveYiqp
	 GBZOdDsOLnVq7zUgnrE5q2gV51HIdbAWJfOgXQQ1/5EcbTrk6IGlyLtkDbME4MUxmH
	 jZ+lJlMDYTH3e8te8W+Yhl+ZgZo6pyhNlr8YlDMWTmeXTGakvoE7i4geuVs0WiNKMu
	 n0IRwPPC5atBezzVSzIRXDrzkQV5iN2xYKBq8ZU2gwjmErzCyIHg0VYIQpvjgk9kq0
	 SL8izATY703pQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  robin.murphy@arm.com,  maz@kernel.org,
  will@kernel.org,  David Matlack <dmatlack@google.com>,  Alexander Graf
 <graf@amazon.com>,  seanjc@google.com,  jgg@nvidia.com,
  loganodell@google.com,  arnd@arndb.de,  dwmw2@infradead.org,
  baolu.lu@linux.intel.com,  Bjorn Helgaas <bhelgaas@google.com>,
  oupton@kernel.org,  alex@shazbot.org,  gle.com@google.com,
  pbonzini@redhat.com,  Andrew Morton <akpm@linux-foundation.org>,
  kevin.tian@intel.com,  joro@8bytes.org,  kvmarm@lists.linux.dev,
  linux-pci@vger.kernel.org,  Pratyush Yadav <pratyush@kernel.org>,
  kexec@lists.infradead.org,  kvm@vger.kernel.org,  iommu@lists.linux.dev,
  linux-arm-kernel@lists.infradead.org,  skhawaja@google.com,
  sagis@google.com,  linux-arch@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI
 compatibility
In-Reply-To: <20261110050202.529473-6-tarunsahu@google.com> (Tarun Sahu's
	message of "Tue, 10 Nov 2026 05:01:48 +0000")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-6-tarunsahu@google.com>
Date: Thu, 26 Nov 2026 17:22:48 +0000
Message-ID: <2vxzo6bbwlqv.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3D58B100007
X-Rspam-User:
X-Stat-Signature: no8d9ty6xy5ieu3zbeqax5uwpipqpxkz
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795713777-162040
X-HE-Meta: U2FsdGVkX186TmDuQEPJA0ByaSijIU9+3t1NsQP95kwxAHuETNLLSiHMBKt3OM9FmJmg2chMDCUUiwGGzk81i/m3FM2UEUWn+txo9ODVBWlGT5xeigdzsN3DiK6XG9u/Al9wCwQLO9QKwKj3MjZ+kGRH9TzNdM5bjUHGBR5YeUmWe5kr5i2rwGm5ygcRjprFg3tM2pwKVs9UvAQhfd2kt6dJ3rfwRqD0cuopwQri5vYYCycSZrUCbXIBJqEqFUysv/cman2c+d27I/4tDixjNd4OJmzbBaw+vOtdn+R2JRpdZtYua6+ddwnnRVjAr0IguEfbmpc8dGyy6LZNPvLYryp7nP3KVIV51W6D/rewioSUIr/qdFRdQM6Y2CoddVLnEqvBrG/WJezZ9dI3Dg741dmp4fb3qkOq8opuPw9wtestqQLwIYt1R/RdLrZ/7OIV4tiWlSkvm5XznH25htgUaEnbBlUgVrB9ubUSyKgPwIrD6xHWUfSNsYPRyOQ/DJ8NEEkVjdJHoeqeAS3n0YY0TazlJDqHcs5NuneCi4A09isQo9pfLEr2YoEoSpizDABU9nUvYLkz6Ij6eyXRJhsicCpBEKJ3rfi4nnFO3MsCGdSmqLfd29dfvVkOpC/OdWb0+9I4TdZpaIU98xADgEsl57EKfs7DQdVNbhqsRKZ5xXXaFAuiYwPWQsVro/+wlCPYjalC9bqQy46eKBmlHa1EGdvg786wPnJDOtoX35/G6TpAI76QcdaTBpe/jNNWQYOKBBdkaExmhTqT2M+wj9Y0rqWruHUvOXZYfQh9Y0qZdVrEcwbakWHpiP52QABd6l0AVnL66wxhqXy83Vh9t+KimYH6hZrBPbTsy6gXdJB00I8ISazELV9Xib1GNjUy5bN9r/gy4WjMEm4eo6AyuLAgUkRLZ9Os/hqpxzCo7cUo+Geo+sWZFjyD8Q5FUOruUaHRX299EnBWNfZzx60ywVZ
 lSDfwYnX
 600hpxgN/34FbnMlyOzcKQAKIkEP3VOVcBhNz0UGjUVmPTe0XAY8UCqs/5tgUZspTxLJ2HguyuZQMEe4upE3yXh1PcDEchIoPBYp91IoyfURmDsOLKTj9VubjFLiaXhswscRdVJ7vrD6KoXWEdalkJ8LcIZ6moG0z5nhTqI49c2l4yJFwjleeWhLSjJLQfiAjCMqvl1LlPFnbjnZ931wdiqfdgNXGcmEsBNAHseRtqN8epDDtsgPGFboxjFhVYHfH4YcDgZO4u5vK3KYekJiDgQYRRvvBIMqoBf23y7QOsU+qimkzP4zg5fwTmcuyn9CIPsncniy6We+RH9/r79gYil2LqUPxwKDH2p+KLBTmgC1pPXA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Other than the general discussion around how we should lay out the bits,
here's some quick code review.

On Tue, Nov 10 2026, Tarun Sahu wrote:
[...]
> ---
>  include/linux/kho/abi/feature.h | 372 ++++++++++++++++++++++++++++++++
>  1 file changed, 372 insertions(+)
>  create mode 100644 include/linux/kho/abi/feature.h
>
> diff --git a/include/linux/kho/abi/feature.h b/include/linux/kho/abi/feature.h
> new file mode 100644
> index 000000000000..55ff1b9e9b73
> --- /dev/null
> +++ b/include/linux/kho/abi/feature.h
> @@ -0,0 +1,372 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/**
> + * DOC: KHO Serialization Feature Header ABI
> + *
> + * Generic feature header for serialized binary data structures preserved
> + * across kexec via KHO or Live Update Orchestrator (LUO).
> + *
> + * Serialized structures start with an 8-byte base header (struct kho_ser_hdr)
> + * containing the total structure size (size, including header, flags, and
> + * payload) in bytes, the number of required features (nr_required), and the
> + * number of optional features (nr_optional). Following the header is a
> + * flexible array of 64-bit flags entries (flags[]) containing one bit per
> + * feature.
> + *
> + * Feature bits:
> + *   - Required feature N is at bit N of flags[].
> + *   - Optional feature N is at bit (nr_required + N) of flags[].
> + *   - The number of __u64 entries in flags[] is
> + *     DIV_ROUND_UP(nr_required + nr_optional, 64).
> + *   - When nr_required == 0 and nr_optional == 0, flags[] has zero entries
> + *     and the header is exactly 8 bytes.
> + *
> + * A set bit indicates that the feature is present in the payload.
> + *
> + * Deserialization truth table:
> + *
> + *   Source bit       Target            Action
> + *   ----------       ------            ------
> + *   Not set          -                 Accept: feature absent
> + *   Optional set     unknown or known  Accept: ignore or use the data
> + *   Required set     known             Accept: use the feature data
> + *   Required set     unknown           Reject: -EOPNOTSUPP
> + *
> + * Validation trusts the incoming header: only set required feature bits at or
> + * beyond the target's known required feature count are rejected (-EOPNOTSUPP).
> + * Optional feature bits are never validated.

I don't understand what this paragraph is supposed to mean.

> + *
> + * Defining features:
> + *
> + * A serialized structure defines its features using enums and registers with
> + * DECLARE_KHO_SER()::
> + *
> + *   enum foo_ser_required {
> + *           FOO_SER_REQ_BAR,
> + *           __FOO_SER_NR_REQUIRED,
> + *   };
> + *
> + *   enum foo_ser_optional {
> + *           FOO_SER_OPT_BAZ,
> + *           __FOO_SER_NR_OPTIONAL,
> + *   };
> + *
> + *   struct foo_ser {
> + *           __u64 base;     // base fields, always present
> + *           __u64 bar;      // FOO_SER_REQ_BAR
> + *           __u64 baz;      // FOO_SER_OPT_BAZ
> + *   };
> + *
> + *   DECLARE_KHO_SER(foo_ser, 24,
> + *                   __FOO_SER_NR_REQUIRED, __FOO_SER_NR_OPTIONAL);
> + *
> + *   // Serialize
> + *   kho_ser_init(fhdr, foo_ser);
> + *   ser = kho_ser_payload(fhdr, foo_ser);
> + *   ser->bar = ...;
> + *   kho_ser_set_required(fhdr, FOO_SER_REQ_BAR);
> + *   ser->baz = ...;
> + *   kho_ser_set_optional(fhdr, FOO_SER_OPT_BAZ);
> + *
> + *   // Restore
> + *   err = kho_ser_validate(fhdr, foo_ser);
> + *   ser = kho_ser_payload(fhdr, foo_ser);
> + *   if (kho_ser_has_required(fhdr, FOO_SER_REQ_BAR))
> + *           use ser->bar;
> + *   if (kho_ser_has_optional(fhdr, FOO_SER_OPT_BAZ))
> + *           use ser->baz;
> + *
> + * Rules:
> + *   - Required and optional features each have their own enum, numbered
> + *     independently from 0.
> + *   - New features are only appended at the end of their enum, never
> + *     reordered or reused.
> + *   - The last entry of each enum (e.g. __FOO_SER_NR_REQUIRED) is the
> + *     feature count passed to DECLARE_KHO_SER and stays last.

Why are these rules? They read more like design patterns to me. Is there
a reason for only using enums, and only using them in this form?

> + *   - The fields of a new feature are appended at the end of the payload.
> + *   - A reader accesses the fields of a feature only when its bit is set in
> + *     the incoming header (kho_ser_has_required() or
> + *     kho_ser_has_optional()), because an older source kernel does not
> + *     serialize them.

Nit: newer source kernel might also not serialize them. No point in
saying that. It is enough to say that the field should not be used.

> + *   - Use required for data the target must understand to restore
> + *     correctly, and optional for data it can safely ignore.
> + *   - Variable length data that follows the payload, such as an array of
> + *     entries, starts at fhdr->size, the size recorded by the source kernel,
> + *     so it stays correct when a later feature appends fields to the
> + *     payload.

I don't understand this line.

> + *
> + * Writing and reading:
> + *
> + * kho_ser_size(), kho_ser_init(), kho_ser_set_required() and
> + * kho_ser_set_optional() (and the clear variants) use the values this
> + * kernel registered with DECLARE_KHO_SER(), so they describe this
> + * kernel's layout and are used when serializing.
> + *
> + * A reader of handed-over data uses only the incoming header:
> + * kho_ser_validate(), kho_ser_hdr_size(), kho_ser_payload(),
> + * kho_ser_has_required(), kho_ser_has_optional() and fhdr->size, so
> + * it follows the layout of the kernel that wrote the data. On data
> + * this kernel serialized, these give the same result.
> + *
> + * Use DECLARE_KHO_SER_HDR(name, *fhdr) (or const
> + * DECLARE_KHO_SER_HDR(name, *fhdr)) to document which registered
> + * structure a feature header pointer belongs to while verifying at
> + * compile time that the structure is registered with DECLARE_KHO_SER().
> + */
> +
> +#ifndef _LINUX_KHO_ABI_FEATURE_H
> +#define _LINUX_KHO_ABI_FEATURE_H
> +
> +#include <linux/build_bug.h>
> +#include <linux/err.h>
> +#include <linux/errno.h>
> +#include <linux/math.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +
> +/**
> + * struct kho_ser_hdr - Header for serialized data structures in KHO.
> + * @size:        Total size in bytes (header + flags + payload).
> + * @nr_required: Number of required features known to the source kernel.
> + * @nr_optional: Number of optional features known to the source kernel.
> + * @flags:       Bitmask of present features (required, then optional).
> + */
> +struct kho_ser_hdr {
> +	__u32 size;
> +	__u16 nr_required;
> +	__u16 nr_optional;
> +	__aligned_u64 flags[];
> +};

Nit: why __u32 and so on? This isn't a uAPI header.

> +
> +static_assert(sizeof(struct kho_ser_hdr) == 8);
> +static_assert(__alignof__(struct kho_ser_hdr) == 8);
> +
> +#define KHO_SER_NR_FLAGS(nr_required, nr_optional) \
> +	DIV_ROUND_UP((__u32)(nr_required) + (__u32)(nr_optional), 64)

That's not number of flags, that the number of bits in the bitmap.
Reading KHO_SER_NR_FLAGS() would make me think this is just nr_required
+ nr_optional.

> +
> +/**
> + * kho_ser_hdr_size - Calculate header size in bytes including flags.
> + * @fhdr: Pointer to the serialization header.
> + *
> + * Return: Size of the header and flags array in bytes.
> + */
> +static inline size_t kho_ser_hdr_size(const struct kho_ser_hdr *fhdr)
> +{
> +	return sizeof(*fhdr) + sizeof(__u64) *
> +		KHO_SER_NR_FLAGS(fhdr->nr_required, fhdr->nr_optional);
> +}
> +
> +/**
> + * kho_ser_set_required - Mark a required feature present in the payload.
> + * @fhdr:  Pointer to the serialization header.
> + * @feat: Required feature index to set.
> + */
> +static inline void kho_ser_set_required(struct kho_ser_hdr *fhdr, unsigned int feat)
> +{
> +	if (feat < fhdr->nr_required)
> +		fhdr->flags[feat / 64] |= 1ULL << (feat % 64);

fhdr->flags[BIT_ULL_WORD(bit)] |= BIT_ULL_MASK(bit);

Is way more readable.

Also,

using the below avoids repeating this incantation multiple times.

static inline void __kho_ser_set_bit(struct kho_ser_hdr *fhdr, unsigned int bit)
{
	fhdr->flags[BIT_ULL_WORD(bit)] |= BIT_ULL_MASK(bit);
}

static inline bool __kho_ser_test_bit(const struct kho_ser_hdr *fhdr, unsigned int bit)
{
	return fhdr->flags[BIT_ULL_WORD(bit)] & BIT_ULL_MASK(bit);
}

> +}
> +
> +/**
> + * kho_ser_clear_required - Clear a required feature in the payload.
> + * @fhdr:  Pointer to the serialization header.
> + * @feat: Required feature index to clear.
> + */
> +static inline void kho_ser_clear_required(struct kho_ser_hdr *fhdr, unsigned int feat)
> +{
> +	if (feat < fhdr->nr_required)
> +		fhdr->flags[feat / 64] &= ~(1ULL << (feat % 64));
> +}
> +
> +/**
> + * kho_ser_set_optional - Mark an optional feature present in the payload.
> + * @fhdr:  Pointer to the serialization header.
> + * @feat: Optional feature index to set.
> + */
> +static inline void kho_ser_set_optional(struct kho_ser_hdr *fhdr, unsigned int feat)
> +{
> +	if (feat < fhdr->nr_optional) {
> +		unsigned int bit = (unsigned int)fhdr->nr_required + feat;
> +
> +		fhdr->flags[bit / 64] |= 1ULL << (bit % 64);
> +	}
> +}
> +
> +/**
> + * kho_ser_clear_optional - Clear an optional feature in the payload.
> + * @fhdr:  Pointer to the serialization header.
> + * @feat: Optional feature index to clear.
> + */
> +static inline void kho_ser_clear_optional(struct kho_ser_hdr *fhdr, unsigned int feat)
> +{
> +	if (feat < fhdr->nr_optional) {
> +		unsigned int bit = (unsigned int)fhdr->nr_required + feat;
> +
> +		fhdr->flags[bit / 64] &= ~(1ULL << (bit % 64));
> +	}
> +}
> +
> +/**
> + * kho_ser_has_required - Check if a required feature is present in the payload.
> + * @fhdr:  Pointer to the serialization header.
> + * @feat: Required feature index to check.
> + *
> + * Return: True if the feature is present, false otherwise or if the index
> + *         exceeds the header's known required feature count.
> + */
> +static inline bool kho_ser_has_required(const struct kho_ser_hdr *fhdr,
> +					unsigned int feat)
> +{
> +	if (feat >= fhdr->nr_required)
> +		return false;
> +	return !!(fhdr->flags[feat / 64] & (1ULL << (feat % 64)));
> +}
> +
> +/**
> + * kho_ser_has_optional - Check if an optional feature is present in the payload.
> + * @fhdr:  Pointer to the serialization header.
> + * @feat: Optional feature index to check.
> + *
> + * Return: True if the feature is present, false otherwise or if the index
> + *         exceeds the header's known optional feature count.
> + */
> +static inline bool kho_ser_has_optional(const struct kho_ser_hdr *fhdr,
> +					unsigned int feat)
> +{
> +	unsigned int bit;
> +
> +	if (feat >= fhdr->nr_optional)
> +		return false;
> +	bit = (unsigned int)fhdr->nr_required + feat;
> +	return !!(fhdr->flags[bit / 64] & (1ULL << (bit % 64)));
> +}
> +
> +/**
> + * __kho_ser_init - Initialize a serialization header and flags.
> + * @fhdr:          Pointer to the memory for the serialization header.
> + * @payload_size: Size of the payload structure in bytes.
> + * @nr_required:  Number of required features known by the caller.
> + * @nr_optional:  Number of optional features known by the caller.
> + */
> +static inline void __kho_ser_init(struct kho_ser_hdr *fhdr, __u32 payload_size,
> +				  __u16 nr_required, __u16 nr_optional)

I really dislike all the __u32, __u16 and so on. This isn't uAPI code,
so should use plain u32, u16 and so on.

> +{
> +	__u32 nr_flags = KHO_SER_NR_FLAGS(nr_required, nr_optional);

flags_size or something like that. nr_flags reads like number of
_actual_ flags.

> +
> +	fhdr->size = sizeof(*fhdr) + sizeof(__u64) * nr_flags + payload_size;
> +	fhdr->nr_required = nr_required;
> +	fhdr->nr_optional = nr_optional;
> +	memset(fhdr->flags, 0, sizeof(__u64) * nr_flags);
> +}
> +
> +/**
> + * __kho_ser_payload - Return pointer to the payload following the header.
> + * @fhdr: Pointer to the serialization header.
> + *
> + * Return: Pointer to payload memory immediately after the flags array.
> + */
> +static inline void *__kho_ser_payload(const struct kho_ser_hdr *fhdr)
> +{
> +	return (void *)((const char *)fhdr + kho_ser_hdr_size(fhdr));

return (void *)fhdr + kho_ser_hdr_size();

does the same thing and is simpler.

> +}
> +
> +/**
> + * __kho_ser_validate - Validate an incoming header against target capabilities.
> + * @fhdr:                Pointer to the serialization header.
> + * @target_nr_required: Number of required features supported by the target.
> + *
> + * Checks that the source did not set any required feature bits that the target
> + * kernel does not support (index >= @target_nr_required).
> + *
> + * Return: 0 if all required features are supported, or -EOPNOTSUPP on failure.
> + */
> +static inline int __kho_ser_validate(const struct kho_ser_hdr *fhdr,
> +				     __u16 target_nr_required)
> +{
> +	unsigned int i;
> +
> +	for (i = target_nr_required; i < fhdr->nr_required; i++) {
> +		if (fhdr->flags[i / 64] & (1ULL << (i % 64)))

Same here, this incantation should go away.

> +			return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * DECLARE_KHO_SER - Register a serialized payload structure with KHO.
> + * @name:         Structure tag name (e.g. luo_ser).
> + * @payload_size: Compile-time expected size of struct @name in bytes.
> + * @nr_required:  Total number of defined required features.
> + * @nr_optional:  Total number of defined optional features.
> + *
> + * Size and 8-byte alignment are asserted under CONFIG_64BIT: KHO and LUO are
> + * 64-bit only, while !CONFIG_KEXEC_HANDOVER stubs pull ABI headers into
> + * 32-bit builds where u64 has 4-byte or 2-byte alignment.
> + */
> +#define DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)	\
> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
> +		      sizeof(struct name) == (payload_size),		\
> +		      "struct " #name " size mismatch");		\
> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
> +		      __alignof__(struct name) == 8,			\
> +		      "struct " #name " must be 8-byte aligned");	\
> +	extern struct kho_ser_hdr __kho_ser_hdr_##name;			\
> +	enum {								\
> +		__KHO_SER_SIZE_##name = (payload_size),			\
> +		__KHO_SER_NR_REQUIRED_##name = (nr_required),		\
> +		__KHO_SER_NR_OPTIONAL_##name = (nr_optional),		\
> +	}

Yeah, I agree with Pasha and Chris. Plain types are much better.

[...]

-- 
Regards,
Pratyush Yadav

