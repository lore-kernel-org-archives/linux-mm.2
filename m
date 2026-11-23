Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8637606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YqWv2qyj
Received: by kanga.kvack.org (Postfix)
	id A90196B05B6; Mon, 23 Nov 2026 09:56:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A414A6B05B7; Mon, 23 Nov 2026 09:56:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9822F6B05B8; Mon, 23 Nov 2026 09:56:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56D006B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:56:47 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1CD2A8541
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:56:46 +0000 (UTC)
X-FDA: 85466685612.08.1C3A8B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1311D10000E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:56:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YqWv2qyj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795445805;
	b=Y9XPDyNZ2qFCfmac89fMa1WcVZ76EiO9vWubFNabZkPOFNIdDjY6KwcYnLxmpDKY5nftgU
	nlqEoXlOldw6OdclwKJ/tI17F7C+iwWahEA2W+Guqun46bcrxjrcqM59tJRamOGtJih5jw
	Jvb/kQPeOdvB7VppKRh0XAm97rqC+N4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795445805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOZamLNrX3zI1FIx1Zgz/K1EJ0SMnsfMEV0ESniCNAw=;
	b=E+FudxFcbh17U3UB0hDs5nQcnxACdsAT2amok7U6590NAvwJUHrGXc6S5T7VXMfRWLR4f5
	ARd37+JrNxvyfhOhwy/Ek/2mwgzE53g0qr5D3xg52IZvuMdvMDm7JudCQ4DWBMrwFEZ9nE
	/xYwxd33VylKrcg8GkHQ+BsmsGGSxS4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YqWv2qyj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8AA26224A;
	Mon, 23 Nov 2026 14:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6091F000EF;
	Mon, 23 Nov 2026 14:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795445804;
	bh=JOZamLNrX3zI1FIx1Zgz/K1EJ0SMnsfMEV0ESniCNAw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=YqWv2qyjcmNEHZr5ibzz7SsD3Sv0fNqsfzxZTHwNk4UHOxkfmYvkT6oOT0BiMl7wm
	 /QbzGWI73gNRm2cAqHQpSotGxxCtw2NN85IosI9IXgAw7CnM4SiMCTJxlOfOHqBd0P
	 FEVIPm6SNuG4PHCNJdCGS4Lo+fIqw6FXLYityRX4nJq+Edu0X2+p0co49qeNLhMcX4
	 4OSNEgIfA8AqfmtMS3MDIjbFejZ5juflZnGcXMH2BSqpTZgLqpO3I3jOvmof6eNqwo
	 ntivX1iXJkxlIdDiq+2av3GWxI+Ez9VQvgXdD7vO5JJlmMftHUsStroK2tk4HW/kkV
	 mIcWQfwg6fLNg==
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
Date: Mon, 23 Nov 2026 14:56:36 +0000
Message-ID: <2vxzse0rzjdn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: jbnobb46apde75intohh79q656o3ctiy
X-Rspam-User:
X-Rspamd-Queue-Id: 1311D10000E
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795445804-71866
X-HE-Meta: U2FsdGVkX1+7CNJphDR9la5duDd7k7CLLpjWgg4fZS5NWh8/YcFjSBFyFFKOoSVfe4QFn3ZHpgiFvGUK4I4197D9xAA9MjRYOxOCUh199u09aG0dZyG48HhtV1KRXwKdkRAZrcM54NEq03lCu4MKwiMyiSvNTaE1Xo7C/T7lIhc4Yzj3kGo7OXAkcJoDAbtP+P/ZlaSJUe1a0ChO9JI0Ve8K2HOkV6sp5PFpgu4+U947dMB3jjs3I2MFeCqKQ8SQGN/VECLM39vN+SERWt2HX1mZkRhKC6Ls/3s+6GZBsasJEqvc9IDBe6pM0IiMSVNe3jS9Ii8/rFhcZlz2pW0Q4WJC/gxwU0KTcH90aVULeyTn1CXgG3P48bt7VJ4v3bP/GjT/VdP1fmroTtPNWXSLYF2H7W5vvYYwGUWet+aWe/PCEJv9/HyPHF4H547PooTBcjMhxlc8lWa1lQ9wWkyifCLiinGp+aDlMYaMrYASwrOD9mqe/ef9sDvwagLbtkmwCZgHCjc1peLkpUzVaOe8c1ACUkyqbKRGVoogxrD5DNZleaoErXvFbPvHVGG808LzDuWhcuZh4Cyngw0OW23Icee7fomjlRcyWdp71u6nXg2HdfCQepZpoQ0th6c/j8vJ7k2OqodG/SgiJ3bz/P3+Mhv/8Cu+IpGBCVzFXTwwC85kigvOJbDCItSmo74SHUOc27CK6WRqzD4198+Gvg8OsihWRkHz/PW+AH2Iv6JAqh9cHEueB8PwGNiObDAw3PongjM4jseq5y+dGexr5EIufrjovHgPNk73MiNs9XgJYSS4gLEXQWLZOI5YgnHgLHTXcXb984dHoP2LqsePp5z6to1BZjlon2KX6niFMZpV7sEMpnJCNESs6NowwhOS0tWEsmsecw1VLuQrElrWzUAV+N6XxjhXexdxsjMFsFvGwGbt65ngxN43w+KeRwm5K6PkmfD8zjWJAwBPXtBMSob
 /2ggcJSI
 hhQrSQFvK0BNcWClKOFOD448F7lTtWgz7yiHF8gOYtcMfSkGIFN/qB4ZXTTzVjhYNEl3NNcAJd4F0s7UvA5s+gNs99BlDM1nrVc81oA+ps8AI8PCIJOxu1QdCoorE9JRrpMsu6OlEkWuEP2zUM9wjfedi37IotHwAtyggfvrZdWUxqd9rYRWc3G93QUX0yZg957ES9ByxHaXnSNK9X0ACN7IDOFdacc/9dNA4chgZO0Lvx39LqkiEM4iNlIMK614AP9cjp711G64OF5k1DMtH6lOWJA0VlUSTmMlsmcRyz52y8g227UeA6vA0bbHobg1DyyeqyfbxFw6o6H8mlm6A2XLBRirqNCnXb/EfHYIHCvusi36H5fGbsTE93Nva7I170QG5mGMA6j8o+h/8Jd+RLOXRmEpj6WTgvtW2R1WJ9zZeV9Z1QuKqYD9BNvW/cEjS2Zob/A6Whn7YaFeco7SQHz3OV/feRtTR6NC/B+rjVcu5IVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10 2026, Tarun Sahu wrote:

> Serialized structures in KHO and Live Update Orchestrator currently rely
> on whole-structure compatibility strings or monolithic version fields to
> validate handed-over state across kexec. Any change to a serialized
> structure, even an optional additive field, requires bumping the
> compatibility string or version number and breaks live update between
> adjacent kernels.
>
> Introduce a generic feature header (struct kho_ser_hdr) for serialized
> binary structures in include/linux/kho/abi/feature.h. Each subsystem
> groups the fields of its serialized structure under feature indices,
> starting with index 0 for base fields. When a subsystem adds a new
> capability, it appends new fields to the end of its payload structure
> under a new feature index. Retired fields are kept in place so existing
> field offsets never shift; if the type or format of a field needs to
> change, the existing field and feature are kept intact until retired and
> a new feature index with an appended field of the new type is added.
> Only when a change requires a complete break in the serialized layout or
> semantics that feature flags cannot handle, a new handler or format can
> be introduced with an incremented version number.
>
> Each feature belongs to either a required feature space or an optional
> feature space. Both spaces are numbered independently starting from 0.
> In the serialized header, required features occupy the first nr_required
> bits, followed immediately by nr_optional bits for optional features:
>
>   struct kho_ser_hdr {
>           __u32 size;
>           __u16 nr_required;
>           __u16 nr_optional;
>           __aligned_u64 flags[];
>   };
>
> A set bit indicates that the feature is present in the payload. The
> truth table for deserialization:
>
>   Source bit       Target            Action
>   Not set          -                 Accept: feature absent
>   Optional set     unknown or known  Accept: ignore or use the data
>   Required set     known             Accept: use the feature data
>   Required set     unknown           Reject: -EOPNOTSUPP
>
> During deserialization, the target kernel only validates required
> features: if the source set any required feature bit at or beyond the
> known required feature count of the target kernel, validation fails with
> -EOPNOTSUPP. Optional features are never rejected; the target kernel
> simply checks whether known optional features are present before reading
> their data.

I've been thinking more about this recently, and I don't think we need
to differentiate between optional and required flags. I think all we
need is "feature flags".

Let me explain this by taking my KHO map patches [0] as the example, since
they got me thinking about this in the first place.

I sent out RFC v1 with no multi-entry support and static depth. During
the review, we figured out that we should support multi-index entries
and dynamic depth. Both of them need breaking ABI changes. If you use
these features, a kernel that doesn't understand them will break.

Now let's say for argument's sake that we merged my RFC v1 as-is, and
later down the line realized that we needed multi-index and dynamic
depth. They are backwards incompatible ABI changes, and so need required
flags called say KHO_MAP_F_MULTI_INDEX and KHO_MAP_F_DYN_DEPTH.

If memfd_luo does not know what features the incoming kernel supports,
it can't really ever use these flags. Because it can not guarantee at
all that the live update would succeed. So without information of what
the incoming kernel supports, you can only ever add optional flags.

From the conversations we've had at LPC and in the bi-weeklies (and also
[1]), we want to supply a specification for all the features the
incoming kernel understands via a uAPI.

Once memfd_luo knows whether the incoming kernel supports
KHO_MAP_F_MULTI_INDEX or KHO_MAP_F_DYN_DEPTH, it can choose to use them,
or go with the less efficient single-slot entries. It makes that
decision when writing out the serialization structures at runtime based
on the spec provided. Backwards compatibility is kept by looking at what
the incoming kernel supports, and only using what it can understand.

When we have all this available, I don't see the point in
differentiating between optional and required features at the ABI level.
At the ABI level, all that matters is what the incoming kernel
understands. If the incoming kernel does not understand a specific
field, the outgoing kernel should just not use it. There's no point.
Best case, it gets ignored.

The semantics of required or optional then become "can I describe this
object with the capabilities I can use?". If the answer is yes,
serialization succeeds, if the answer is no, serialization fails. So
with this, KHO_MAP_F_MULTI_INDEX or KHO_MAP_F_DYN_DEPTH are indeed
optional. All memfds can be described without these, they just will be
less efficient.

The only thing that the optional flag buys us is to add backwards ABI
compatible changes _until_ we add the ability to export the
specification of the incoming kernel. Since that should be coming in the
near future, I don't think the churn of optional flags is worth it.

So in short, here's my proposal: we only do "feature flags". The
serializer should know what the incoming side understands, and it should
only use the features that are understood. It should simply not use
anything else. If it can't describe an object with the flags available
to use, serialization fails.

[0] https://lore.kernel.org/kexec/20261116134013.1636689-1-pratyush@kernel.org/
[1] https://lore.kernel.org/kexec/CA+CK2bCnS8wcVDbOymBGeJB6pDUkknOpF22EynbwSV=D5=J4ow@mail.gmail.com/

[...]

-- 
Regards,
Pratyush Yadav

