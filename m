Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54B1F606A330
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ls/BekJr
Received: by kanga.kvack.org (Postfix)
	id 7BA2E6B05B3; Tue, 10 Nov 2026 13:13:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791D56B05B4; Tue, 10 Nov 2026 13:13:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AEB26B05B5; Tue, 10 Nov 2026 13:13:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 443A36B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:13:45 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8231120A38
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:13:44 +0000 (UTC)
X-FDA: 85420007568.29.A7515F7
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1A8F01C0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:13:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="ls/BekJr";
	spf=pass (imf18.hostedemail.com: domain of 31V7zagkKCL4xevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=31V7zagkKCL4xevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794334423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvY3QYyj10AiTA7LMYL5ggn+X+GHJohr24sJvDkqpD4=;
	b=owjUl688vxTiSAPRh8immkD1NyPsSkeqy9gV1awXAcp0jZVVZYvn7qhTz10F6bKmROTMQq
	rP62p6THm/wZtMmFfg6Hk3/zsj3YdLXIGRimwAGWgJ41osLvwzk4GJW1/texdAB6YFyITO
	5DXzn07zE+rtcViv58i7rLHGVVayETI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794334423;
	b=h+aflA5O0nWiuviLa7y2DbXHnWwEJTvkziIzy6ztUvBfvHgBgH/IaD4KG94JSd7HAeQEtW
	0vHXvWtziLHkEprleU1bXpgVdJixwOwxXRr0Dz/eAKwn/RIT9SUGBR54gdSckVIC8c2wFk
	rEwX5kfHpQXjcY90A7Jomzz383UTcbU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="ls/BekJr";
	spf=pass (imf18.hostedemail.com: domain of 31V7zagkKCL4xevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=31V7zagkKCL4xevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c29c391bd2fso210841566b.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794334422; x=1794939222; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pvY3QYyj10AiTA7LMYL5ggn+X+GHJohr24sJvDkqpD4=;
        b=ls/BekJrT9UCzNEJDQ6+B44k44IpY9OC72fN5rpN0r/cwTXjQ8hZhRoZbFkNVX7mwR
         Bgw/ww3AMsanWomL1o46zWY2dK7UTQwZfkEXjs4wqBtl0BmEKrI/3WNGJTqb+nHZ5e4D
         3pC0JfTANtIJtTU+Q1iIkPkuXAEFRDXLXzjxIBS92a2RfWpLrHD0brqBmN9lta82jjK/
         vDy7pzIvFAvRVhH/bflQi05uAfZKfmcT3OS+EQbgNBoUlkIl/Q0nYXRe/IP9zkSHpAJ1
         SElx8epWCxkt/sAXD38hn2m6g9SLGP81129GbdrmSETdF3R8dAgOvCurOdae+IFpYBN1
         F8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794334422; x=1794939222;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pvY3QYyj10AiTA7LMYL5ggn+X+GHJohr24sJvDkqpD4=;
        b=M9brrRuVt0fArpRBOjxUkMBe2Iz05sLfu+OhRDm80mdZCuNLhjSEhZttSDgSHbsdw7
         tkAExDpRwCNOT/QxY1I46N4wBEis9vohvoXQ3Cyrbfygvna9Bpm9jpXegFF4Mgx4lLXL
         sCEt2WtSrl4ROthOblOrYkuO2PjIdKYQXpoTT/+P5Em6mXzu5CKusu5N86hJlDUR4P3P
         fkWvntjiJdkecmtFZntaEnLSabfWLDDhxE4+TKhI7btsuSBcF+wglVn1e59f6w6x/Cl/
         TH7rXvzr2QDBSjxlvsKvtkKszEfjF9HTo9CBaHCgvjyBjrYRiMcLxdJ0ZI3Csz2YeTpv
         cuBQ==
X-Forwarded-Encrypted: i=1; AL+hErHJfzr7N2AM19fYF0K71mf0yQj+0c3ZS4mfTxzaK8Xg2NfCi7LLbfMog23itNyjSSL/s4b0DZ4NJg==@kvack.org
X-Gm-Message-State: APuU4Z+qs97XOliM8nnJjcmGHPwRqj1L2aqIHJsChsqgJF6N9Yqe+KJF
	SNykdzYlaWOUcul4Fd4fjqybAFj/x8VLijD0GG7NvNf3fcQwqQq20xLOM6Nrpo7FK8aBPrX2Mqv
	kcnv2lvudChlgsWK4gw==
X-Received: from ejbfi14.prod.google.com ([2002:a17:906:da0e:b0:c50:4ab9:995a])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:da16:b0:c3f:dce3:20c5 with SMTP id a640c23a62f3a-c50495d5a60mr286796366b.44.1794334421346;
 Tue, 10 Nov 2026 10:13:41 -0800 (PST)
Date: Tue, 10 Nov 2026 18:13:40 +0000
In-Reply-To: <179432205559.2329176.3035981527541971699.b4-review@b4>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-6-tarunsahu@google.com>
 <179432205559.2329176.3035981527541971699.b4-review@b4>
Message-ID: <9huz8q30tuzv.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI compatibility
From: tarunsahu@google.com
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org, 
	kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: ayganbthdbsgmbj8f3epo48fd5b6unbs
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 1A8F01C0004
X-Rspam-User: 
X-HE-Tag: 1794334422-435171
X-HE-Meta: U2FsdGVkX18v7Hkfkb2zV/xQ92T9uVbNG4SlKVbhS76r1EX4yLKB5wGn2qKLopiY6UQDyNLnO7IXdvIZ0nHJpPQr5FZB5TSmcyDJweS3Z7NMV2vvP7lE1ThkcyB1IdUTnhv12T4+urBvWcl90RkSf1AowBcwcSyzcF7HFKWp3iKUYjarmO7gl5lUXZm/BcAv2yXCCCbs6Qd3wZaYTikKnuglvoawL2lsMFkeG8l6YtKd3vIWuPoofgX/FEo3kFn55k3Tf5U6SnocCdEN61vCdNwBqpI3YXOFl43WZCmLIujQB00MIERJzw/OB7BXubM7mUwoEC/9CqdX1ZUYOi90/RfKFleq9AiodPsHxNq2DQRH3beeHXdof+sRBuSifyT5zICMolmd3/raLK228alVBphDEtvkage3NQ5CTZeh0WgBc/JNI7KrXVzqMGUYV8OXgTHmL7BF1SrqM/81xNS7FPnvdYCocpXcvisbjSK7EbYkIPuOh0Gt04U5MstitnDwPiCwRun5OUGRQOm3CYZ/EVyJ/v7tZ/aHSa+OqMfCmdtvzYejFn8q0kE3fJHh+UVSOFR6WKZbMTtHEtn30a32aIe8+5khMq5S3DLtEda3i+Hnkh47OcRepUE3lY25QWp4prEyjGJj2IlzjyV11yNRe20ZXUBx/NYTpT3NzZ+KunrBSiwMthu0RA8rlECKv66vDUAtgi+3j1b1q7KziSNXE3dKyrtvNFAoxe4t8vDNjJEaZAS7v8+rxAupzH0eB3adc00+F5XH0TZZA6FgY9jMFYLSWGIZUUeDvQ5hvS3CBCXc5VtWVplDOrCiVe5Y9BRLKlyTWgz6UDaWDbhdUdKIpsMZAf9aZV1/BAkQKsisRDYspV8nt/CaDgKIXP4YHm3fxZQ0/uMCFJpxM0EvmQOW/zQqG8cYthvf4UZQ+6r28q1LI3/IFgXE89Hj/3CsMiFNwN5Fg3LdLUAhS5aAVjq
 7JgV3sfU
 w2br++7NFuhdMrU74VpucqWeulptQFGH9SiyIQqrbEz6joY5A2WX9Ex+ijSloJHDptQNJczWSVuSrDSvxjgj0DG1TDnWY7wOewprgZXPjT8sePKP4AXAv2Kat4N0WvJzVuSEwtkeUf0Dh88tlyGPFyle5UzVX2Q2QZ4boGatyJvWpsOsaKSaaZ135kiMrKEKlNzNNV/rwTgP9gMTyD+iA92gXSQbpc/jn7HbWreKDR20teaSBWXvVPhJAddyBaa3Lg8CLokaoNSUGE7YjGadrj5rqG3TD/+nC2zcr3R1+QZvOU7O+CFms2qlDq3UZCj74Yso5xK3chq63wsUmPra46V4nsKsC4HVmKWRsPduHW2qy1ah0gsL/V56Mn6zM02dkwpHQloiAxpM6nDIeXbnHP7Mp5E51DlrX7mhSx6Y4SjMFWOfjUalSH5k4E4HeNx4oFSjHzyGDXsxu48QKW6HqZ23rvOmM0mDMRb36tRBmm02e8+tQAejwQb1TBB2h1lr0F4boJV2k2Jdx3i9QsCO6S5czBioi622Q3xDTyFUO+mmAXd6zgi+QSJWaqyjkx8YTrKLcd+Gc6iQgkj1TxIFED+myNDLNpgvgaJgnrCsvYdd2QgtRULMJKxrlPjwWOaiyaC2y07K59O0Fgzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Pasha Tatashin <pasha.tatashin@soleen.com> writes:

>> Serialized structures in KHO and Live Update Orchestrator currently rely
>> on whole-structure compatibility strings or monolithic version fields to
>> validate handed-over state across kexec. Any change to a serialized
>> structure, even an optional additive field, requires bumping the
>> compatibility string or version number and breaks live update between
>> adjacent kernels.
>> 
>> Introduce a generic feature header (struct kho_ser_hdr) for serialized
>> binary structures in include/linux/kho/abi/feature.h. Each subsystem
>> groups the fields of its serialized structure under feature indices,
>> starting with index 0 for base fields. When a subsystem adds a new
>> capability, it appends new fields to the end of its payload structure
>> under a new feature index. Retired fields are kept in place so existing
>> field offsets never shift; if the type or format of a field needs to
>> change, the existing field and feature are kept intact until retired and
>> a new feature index with an appended field of the new type is added.
>> Only when a change requires a complete break in the serialized layout or
>> semantics that feature flags cannot handle, a new handler or format can
>> be introduced with an incremented version number.
>> 
>> Each feature belongs to either a required feature space or an optional
>> feature space. Both spaces are numbered independently starting from 0.
>> In the serialized header, required features occupy the first nr_required
>> bits, followed immediately by nr_optional bits for optional features:
>> 
>>   struct kho_ser_hdr {
>>           __u32 size;
>>           __u16 nr_required;
>>           __u16 nr_optional;
>>           __aligned_u64 flags[];
>>   };
>> 
>> A set bit indicates that the feature is present in the payload. The
>> truth table for deserialization:
>> 
>>   Source bit       Target            Action
>>   Not set          -                 Accept: feature absent
>>   Optional set     unknown or known  Accept: ignore or use the data
>>   Required set     known             Accept: use the feature data
>>   Required set     unknown           Reject: -EOPNOTSUPP
>> 
>> During deserialization, the target kernel only validates required
>> features: if the source set any required feature bit at or beyond the
>> known required feature count of the target kernel, validation fails with
>> -EOPNOTSUPP. Optional features are never rejected; the target kernel
>> simply checks whether known optional features are present before reading
>> their data.
>> 
>> No subsystem defines feature flags yet. Every converted structure is
>> registered with 0 required and 0 optional features, producing a compact
>> 8-byte header with no flags entries. Feature enums can be added later as
>> needed, once the first additive feature is introduced for a particular
>> serialized structure. With nr_required set to 0, kho_ser_validate()
>> rejects any incoming required feature bit while ignoring optional bits,
>> allowing future kernels with additive features to evolve smoothly in
>> both directions.
>> 
>> Each subsystem registers its serialized structure with:
>> 
>>         DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)
>> 
>> This establishes compile-time assertions and provides type-checked
>> helpers: kho_ser_size() for total allocation size, kho_ser_init() to
>> initialize the header, kho_ser_payload() to access the typed payload at
>> its dynamic offset, and kho_ser_validate() to validate required features
>> during restoration. DECLARE_KHO_SER_HDR(name, *fhdr) declares a struct
>> kho_ser_hdr pointer while verifying at compile time that name was
>> registered with DECLARE_KHO_SER(), allowing callers to document which
>> structure a feature header pointer represents.
>> 
>> An example demonstrating how a hypothetical structure defines its
>> features:
>> 
>>   enum foo_ser_required {
>>           FOO_SER_REQ_BAR,
>>           __FOO_SER_NR_REQUIRED,
>>   };
>> 
>>   enum foo_ser_optional {
>>           FOO_SER_OPT_BAZ,
>>           __FOO_SER_NR_OPTIONAL,
>>   };
>> 
>>   struct foo_ser {
>>           __u64 base;     /* base fields, always present */
>>           __u64 bar;      /* FOO_SER_REQ_BAR */
>>           __u64 baz;      /* FOO_SER_OPT_BAZ */
>>   };
>> 
>>   DECLARE_KHO_SER(foo_ser, 24,
>>                   __FOO_SER_NR_REQUIRED, __FOO_SER_NR_OPTIONAL);
>> 
>>   /* Serialize */
>>   kho_ser_init(fhdr, foo_ser);
>>   ser = kho_ser_payload(fhdr, foo_ser);
>>   ser->bar = ...;
>>   kho_ser_set_required(fhdr, FOO_SER_REQ_BAR);
>>   ser->baz = ...;
>>   kho_ser_set_optional(fhdr, FOO_SER_OPT_BAZ);
>> 
>>   /* Restore */
>>   err = kho_ser_validate(fhdr, foo_ser);
>>   ser = kho_ser_payload(fhdr, foo_ser);
>>   if (kho_ser_has_required(fhdr, FOO_SER_REQ_BAR))
>>           use ser->bar;
>>   if (kho_ser_has_optional(fhdr, FOO_SER_OPT_BAZ))
>>           use ser->baz;
>> 
>> Required and optional features each have their own enum, numbered
>> independently from 0. New features are only appended at the end of their
>> enum, never reordered or reused. The last entry of each enum (e.g.
>> __FOO_SER_NR_REQUIRED) is the feature count passed to DECLARE_KHO_SER and
>> stays last. The fields of a new feature are appended at the end of the
>> payload. A reader accesses the fields of a feature only when its bit is set
>> in the incoming header (kho_ser_has_required() or kho_ser_has_optional()),
>> because an older source kernel does not serialize them. Use required for
>> data the target must understand to restore correctly, and optional for
>> data it can safely ignore. Variable length data that follows the payload,
>> such as an array of entries, starts at fhdr->size, the size recorded by the
>> source kernel, so it stays correct when a later feature appends fields to
>> the payload. Document that serialization helpers describe this kernel's
>> layout while deserialization helpers follow the incoming header.
>> 
>> Suggested-by: David Matlack <dmatlack@google.com>
>> Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>>
>> diff --git a/include/linux/kho/abi/feature.h b/include/linux/kho/abi/feature.h
>> new file mode 100644
>> index 000000000000..55ff1b9e9b73
>> --- /dev/null
>> +++ b/include/linux/kho/abi/feature.h
>> @@ -0,0 +1,372 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +/**
>> + * DOC: KHO Serialization Feature Header ABI
>> + *
>> + * Generic feature header for serialized binary data structures preserved
>> + * across kexec via KHO or Live Update Orchestrator (LUO).
>
> via KHO or LUO.
>

Oops! it is wrong. It should only be via KHO.

>> + *
>> + * Serialized structures start with an 8-byte base header (struct kho_ser_hdr)
>> + * containing the total structure size (size, including header, flags, and
>> + * payload) in bytes, the number of required features (nr_required), and the
>> + * number of optional features (nr_optional). Following the header is a
>> + * flexible array of 64-bit flags entries (flags[]) containing one bit per
>> + * feature.
>> + *
>> + * Feature bits:
>> + *   - Required feature N is at bit N of flags[].
>> + *   - Optional feature N is at bit (nr_required + N) of flags[].
>> + *   - The number of __u64 entries in flags[] is
>> + *     DIV_ROUND_UP(nr_required + nr_optional, 64).
>> + *   - When nr_required == 0 and nr_optional == 0, flags[] has zero entries
>> + *     and the header is exactly 8 bytes.
>
> The above is not needed in the documentation.

Sure, I will update all of the above (feature.h) with:

"A feature header precedes each serialized structure that outgoing
kernel store along with ser data and incoming kernel use to understand
and decode the preserved data."

A feature header holds the details about required and optional feature
in the serialized data stored as a bit for each features.
>
>> + *
>> + * A set bit indicates that the feature is present in the payload.
>> + *
>> + * Deserialization truth table:
>> + *
>> + *   Source bit       Target            Action
>> + *   ----------       ------            ------
>> + *   Not set          -                 Accept: feature absent
>> + *   Optional set     unknown or known  Accept: ignore or use the data
>> + *   Required set     known             Accept: use the feature data
>> + *   Required set     unknown           Reject: -EOPNOTSUPP
>> + *
>> + * Validation trusts the incoming header: only set required feature bits at or
>> + * beyond the target's known required feature count are rejected (-EOPNOTSUPP).
>> + * Optional feature bits are never validated.
>> + *
>
> We can shorten the comment below (and commit message as well); there is 
> no need to include sample code showing how the header is implemented in 
> the doc comment. Too much stuff that is not really useful to the reader.
>

Okay, I will remove about function related details below.

About feature flags, I added this because at this point none of the
serialized structure use the feature flags, I intended to explain how they can
define new feature and use them.

I have updated the below, let me know if that looks good.

>> + * Defining features:
>> + *
>> + * A serialized structure defines its features using enums and registers with
>> + * DECLARE_KHO_SER():: AN Example to introduce a new feature:
>> + *
>> + *   enum foo_ser_required {
>> + *           FOO_SER_REQ_BAR,
>> + *           __FOO_SER_NR_REQUIRED,
>> + *   };
>> + *
>> + *   enum foo_ser_optional {
>> + *           FOO_SER_OPT_BAZ,
>> + *           __FOO_SER_NR_OPTIONAL,
>> + *   };
>> + *
>> + *   struct foo_ser {
>> + *           __u64 base;     // base fields, always present
>> + *           __u64 bar;      // FOO_SER_REQ_BAR
>> + *           __u64 baz;      // FOO_SER_OPT_BAZ
>> + *   };
>> + *
>> + *   DECLARE_KHO_SER(foo_ser, 24,
>> + *                   __FOO_SER_NR_REQUIRED, __FOO_SER_NR_OPTIONAL);
>> + *
>> + *
>> + * Rules:
>> + *   - The fields of a new feature are appended at the end of the
>> +       serialized structure to keep the offset of older fields same.
>> + *   - Use required for data the target must understand to restore
>> + *     correctly, and optional for data it can safely ignore.
>> + *
>> + */
>> +

=======END OF DOC=================

>> +#ifndef _LINUX_KHO_ABI_FEATURE_H
>> +#define _LINUX_KHO_ABI_FEATURE_H
>> +
>> +#include <linux/build_bug.h>
>> +#include <linux/err.h>
>> +#include <linux/errno.h>
>> +#include <linux/math.h>
>> +#include <linux/string.h>
>> +#include <linux/types.h>
>> +
>> +/**
>> + * struct kho_ser_hdr - Header for serialized data structures in KHO.
>> + * @size:        Total size in bytes (header + flags + payload).
>> + * @nr_required: Number of required features known to the source kernel.
>> + * @nr_optional: Number of optional features known to the source kernel.
>> + * @flags:       Bitmask of present features (required, then optional).
>> + */
>
> Let's avoid tab-aligning the new doc comment. Apparently, that is not 
> ideal because it makes future maintenance harder; each line must be 
> re-aligned whenever longer fields are added.
>

Got it. I will update it.

>> +struct kho_ser_hdr {
>> +	__u32 size;
>> +	__u16 nr_required;
>> +	__u16 nr_optional;
>> +	__aligned_u64 flags[];
>> +};
>> +
>
> Please use u32/u16/u64, this is not uapi.
>
Got it. I will update it.

>> +static_assert(sizeof(struct kho_ser_hdr) == 8);
>> +static_assert(__alignof__(struct kho_ser_hdr) == 8);
>> +
>> +#define KHO_SER_NR_FLAGS(nr_required, nr_optional) \
>> +	DIV_ROUND_UP((__u32)(nr_required) + (__u32)(nr_optional), 64)
>> +
>> +/**
>> + * kho_ser_hdr_size - Calculate header size in bytes including flags.
>> + * @fhdr: Pointer to the serialization header.
>> + *
>> + * Return: Size of the header and flags array in bytes.
>> + */
>> +static inline size_t kho_ser_hdr_size(const struct kho_ser_hdr *fhdr)
>> +{
>> +	return sizeof(*fhdr) + sizeof(__u64) *
>> +		KHO_SER_NR_FLAGS(fhdr->nr_required, fhdr->nr_optional);
>> +}
>> +
>> +/**
>> + * kho_ser_set_required - Mark a required feature present in the payload.
>> + * @fhdr:  Pointer to the serialization header.
>> + * @feat: Required feature index to set.
>> + */
>> +static inline void kho_ser_set_required(struct kho_ser_hdr *fhdr, unsigned int feat)
>> +{
>> +	if (feat < fhdr->nr_required)
>> +		fhdr->flags[feat / 64] |= 1ULL << (feat % 64);
>> +}
>> +
>> +/**
>> + * kho_ser_clear_required - Clear a required feature in the payload.
>> + * @fhdr:  Pointer to the serialization header.
>> + * @feat: Required feature index to clear.
>> + */
>> +static inline void kho_ser_clear_required(struct kho_ser_hdr *fhdr, unsigned int feat)
>> +{
>> +	if (feat < fhdr->nr_required)
>> +		fhdr->flags[feat / 64] &= ~(1ULL << (feat % 64));
>> +}
>> +
>> +/**
>> + * kho_ser_set_optional - Mark an optional feature present in the payload.
>> + * @fhdr:  Pointer to the serialization header.
>> + * @feat: Optional feature index to set.
>> + */
>> +static inline void kho_ser_set_optional(struct kho_ser_hdr *fhdr, unsigned int feat)
>> +{
>> +	if (feat < fhdr->nr_optional) {
>> +		unsigned int bit = (unsigned int)fhdr->nr_required + feat;
>> +
>> +		fhdr->flags[bit / 64] |= 1ULL << (bit % 64);
>> +	}
>> +}
>> +
>> +/**
>> + * kho_ser_clear_optional - Clear an optional feature in the payload.
>> + * @fhdr:  Pointer to the serialization header.
>> + * @feat: Optional feature index to clear.
>> + */
>> +static inline void kho_ser_clear_optional(struct kho_ser_hdr *fhdr, unsigned int feat)
>> +{
>> +	if (feat < fhdr->nr_optional) {
>> +		unsigned int bit = (unsigned int)fhdr->nr_required + feat;
>> +
>> +		fhdr->flags[bit / 64] &= ~(1ULL << (bit % 64));
>> +	}
>> +}
>> +
>> +/**
>> + * kho_ser_has_required - Check if a required feature is present in the payload.
>> + * @fhdr:  Pointer to the serialization header.
>> + * @feat: Required feature index to check.
>> + *
>> + * Return: True if the feature is present, false otherwise or if the index
>> + *         exceeds the header's known required feature count.
>> + */
>> +static inline bool kho_ser_has_required(const struct kho_ser_hdr *fhdr,
>> +					unsigned int feat)
>> +{
>> +	if (feat >= fhdr->nr_required)
>> +		return false;
>> +	return !!(fhdr->flags[feat / 64] & (1ULL << (feat % 64)));
>> +}
>> +
>> +/**
>> + * kho_ser_has_optional - Check if an optional feature is present in the payload.
>> + * @fhdr:  Pointer to the serialization header.
>> + * @feat: Optional feature index to check.
>> + *
>> + * Return: True if the feature is present, false otherwise or if the index
>> + *         exceeds the header's known optional feature count.
>> + */
>> +static inline bool kho_ser_has_optional(const struct kho_ser_hdr *fhdr,
>> +					unsigned int feat)
>> +{
>> +	unsigned int bit;
>> +
>> +	if (feat >= fhdr->nr_optional)
>> +		return false;
>> +	bit = (unsigned int)fhdr->nr_required + feat;
>> +	return !!(fhdr->flags[bit / 64] & (1ULL << (bit % 64)));
>> +}
>> +
>> +/**
>> + * __kho_ser_init - Initialize a serialization header and flags.
>> + * @fhdr:          Pointer to the memory for the serialization header.
>> + * @payload_size: Size of the payload structure in bytes.
>> + * @nr_required:  Number of required features known by the caller.
>> + * @nr_optional:  Number of optional features known by the caller.
>> + */
>> +static inline void __kho_ser_init(struct kho_ser_hdr *fhdr, __u32 payload_size,
>> +				  __u16 nr_required, __u16 nr_optional)
>> +{
>> +	__u32 nr_flags = KHO_SER_NR_FLAGS(nr_required, nr_optional);
>> +
>> +	fhdr->size = sizeof(*fhdr) + sizeof(__u64) * nr_flags + payload_size;
>> +	fhdr->nr_required = nr_required;
>> +	fhdr->nr_optional = nr_optional;
>> +	memset(fhdr->flags, 0, sizeof(__u64) * nr_flags);
>> +}
>> +
>> +/**
>> + * __kho_ser_payload - Return pointer to the payload following the header.
>> + * @fhdr: Pointer to the serialization header.
>> + *
>> + * Return: Pointer to payload memory immediately after the flags array.
>> + */
>> +static inline void *__kho_ser_payload(const struct kho_ser_hdr *fhdr)
>> +{
>> +	return (void *)((const char *)fhdr + kho_ser_hdr_size(fhdr));
>> +}
>> +
>> +/**
>> + * __kho_ser_validate - Validate an incoming header against target capabilities.
>> + * @fhdr:                Pointer to the serialization header.
>> + * @target_nr_required: Number of required features supported by the target.
>> + *
>> + * Checks that the source did not set any required feature bits that the target
>> + * kernel does not support (index >= @target_nr_required).
>> + *
>> + * Return: 0 if all required features are supported, or -EOPNOTSUPP on failure.
>> + */
>> +static inline int __kho_ser_validate(const struct kho_ser_hdr *fhdr,
>> +				     __u16 target_nr_required)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = target_nr_required; i < fhdr->nr_required; i++) {
>> +		if (fhdr->flags[i / 64] & (1ULL << (i % 64)))
>> +			return -EOPNOTSUPP;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * DECLARE_KHO_SER - Register a serialized payload structure with KHO.
>> + * @name:         Structure tag name (e.g. luo_ser).
>> + * @payload_size: Compile-time expected size of struct @name in bytes.
>> + * @nr_required:  Total number of defined required features.
>> + * @nr_optional:  Total number of defined optional features.
>> + *
>> + * Size and 8-byte alignment are asserted under CONFIG_64BIT: KHO and LUO are
>> + * 64-bit only, while !CONFIG_KEXEC_HANDOVER stubs pull ABI headers into
>> + * 32-bit builds where u64 has 4-byte or 2-byte alignment.
>> + */
>> +#define DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)	\
>> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
>> +		      sizeof(struct name) == (payload_size),		\
>> +		      "struct " #name " size mismatch");		\
>> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
>> +		      __alignof__(struct name) == 8,			\
>> +		      "struct " #name " must be 8-byte aligned");	\
>> +	extern struct kho_ser_hdr __kho_ser_hdr_##name;			\
>> +	enum {								\
>> +		__KHO_SER_SIZE_##name = (payload_size),			\
>> +		__KHO_SER_NR_REQUIRED_##name = (nr_required),		\
>> +		__KHO_SER_NR_OPTIONAL_##name = (nr_optional),		\
>> +	}
>> +
>> +/**
>> + * DECLARE_KHO_SER_HDR - Declare a feature header variable, field, or parameter.
>> + * @name: Structure tag name registered with DECLARE_KHO_SER().
>> + * @decl: Declarator (e.g. *fhdr, **out_fhdr, or * inside DECLARE_KHOSER_PTR).
>> + *
>> + * Declares @decl with type struct kho_ser_hdr while checking at compile time
>> + * that @name was registered with DECLARE_KHO_SER(), documenting which
>> + * serialized payload structure a feature header pointer belongs to.
>> + */
>> +#define DECLARE_KHO_SER_HDR(name, decl)	typeof(__kho_ser_hdr_##name) decl
>> +
>> +/**
>> + * kho_ser_size - Total size of header, flags, and payload for a structure.
>> + * @name: Structure tag name registered with DECLARE_KHO_SER().
>> + */
>> +#define kho_ser_size(name)						\
>> +	(sizeof(struct kho_ser_hdr) +					\
>> +	 sizeof(__u64) * KHO_SER_NR_FLAGS(__KHO_SER_NR_REQUIRED_##name,	\
>> +					  __KHO_SER_NR_OPTIONAL_##name) +\
>> +	 __KHO_SER_SIZE_##name)
>> +
>> +/**
>> + * kho_ser_init - Initialize a serialization header for a registered structure.
>> + * @fhdr:  Pointer to allocated memory.
>> + * @name: Structure tag name registered with DECLARE_KHO_SER().
>> + */
>> +#define kho_ser_init(fhdr, name)						\
>> +	__kho_ser_init((fhdr), __KHO_SER_SIZE_##name,			\
>> +		       __KHO_SER_NR_REQUIRED_##name,			\
>> +		       __KHO_SER_NR_OPTIONAL_##name)
>> +
>> +/**
>> + * kho_ser_payload - Return typed pointer to payload following the header.
>> + * @fhdr:  Pointer to the serialization header.
>> + * @name: Structure tag name registered with DECLARE_KHO_SER().
>> + *
>> + * The first operand only fails the build when DECLARE_KHO_SER(name) is
>> + * missing.
>> + */
>> +#define kho_ser_payload(fhdr, name)					\
>> +	((void)__KHO_SER_SIZE_##name,					\
>> +	 (struct name *)__kho_ser_payload(fhdr))
>> +
>> +/**
>> + * kho_ser_validate - Validate incoming required features for a structure.
>> + * @fhdr:  Pointer to the incoming serialization header.
>> + * @name: Structure tag name registered with DECLARE_KHO_SER().
>> + */
>> +#define kho_ser_validate(fhdr, name)					\
>> +	__kho_ser_validate((fhdr), __KHO_SER_NR_REQUIRED_##name)
>> +
>> +#endif /* _LINUX_KHO_ABI_FEATURE_H */
>
> Headers under include/linux/kho/abi/ are meant to describe the ABI 
> layout only, so include/linux/kho/abi/feature.h should only contain the 
> struct and declaration macros actually used by kho/abi/*.h headers:
>
> - struct kho_ser_hdr (and its static_asserts)
> - DECLARE_KHO_SER()
> - DECLARE_KHO_SER_HDR()
>
> Everything else here (KHO_SER_NR_FLAGS(), kho_ser_hdr_size(), 
> kho_ser_size(), kho_ser_init(), kho_ser_payload(), kho_ser_validate(), 
> kho_ser_{set,clear,has}_{required,optional}(), and the __kho_ser_*() 
> helpers) is kernel runtime helper code and should be moved to 
> include/linux/kexec_handover.h (which also avoids pulling string.h, 
> math.h, err.h, and errno.h into the ABI header).


Okay will update it.
~Tarun

>
> -- 
> Pasha

