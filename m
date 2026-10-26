Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F94606A322
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 18:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=r6xugff/
Received: by kanga.kvack.org (Postfix)
	id 7487F6B05B0; Mon, 26 Oct 2026 14:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AAFB6B05B1; Mon, 26 Oct 2026 14:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5725C6B05B2; Mon, 26 Oct 2026 14:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27BDA6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:58:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0B89A0839
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:58:51 +0000 (UTC)
X-FDA: 85365689262.01.C5B6167
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf30.hostedemail.com (Postfix) with ESMTP id E9A9080005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:58:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="r6xugff/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 36KLfagkKCAs4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=36KLfagkKCAs4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793041129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uO/W/z94g5X81Ln9+3SsNcj1ZpjaM4tumvmhkUCPgU4=;
	b=HvfCNqWTLhAN0alRrBlLpl0If+LL31tKVrt+k4ipMIT2ef6XQZdXMDG0TdmAkSF5T0PX0T
	RjIk7unbwM7LB0roMzQUc7OtNnbYC1jP4JYX9QMaZpF2CWeAz7p44tZXKOgrGo/RUloR/3
	nk133bzrWkiZJDCpKi88Zlc2S/sRD8w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="r6xugff/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 36KLfagkKCAs4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=36KLfagkKCAs4l25y3ls5rzzrwp.nzxwty58-xxv6lnv.z2r@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793041129;
	b=dgQ1hPzISkIjrjmFvW989C/2snZYLfxcfXZSOpH/m5qFCxP6ZcCZxpUnwrhFdOMF/1rZOV
	kekU0+2hflOn9aKw9/R2TUwBHSSPo5Yh7R038JS0Cy+kYZcj0+y5zuR5XoHtukKUOBNAFG
	JxLudw/ZlOcOJfFnmKHJK+axPHHD4wI=
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b1d6c10725so3962190a12.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793041128; x=1793645928; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uO/W/z94g5X81Ln9+3SsNcj1ZpjaM4tumvmhkUCPgU4=;
        b=r6xugff/k8L7zJIADyC4qcUbA0jS1iAJcSucf0V37l+6wMyVhSTQXIoA1yMP76HpMl
         06Tg+S7N3CFRfrX1VEvtH9qKwx9+kztjxtkha3QUvtnVkLrN3Wm7NQo1bF2uqmzWalQm
         vhN1peqQXvk8aYQa2Sz8I2LobD4oIG47ut62P5rx4g3pitua6kIQmFrV8NrZWDC/g532
         lS13/EVeEEWroJRoizB9YsO4yAKC7liFR9toCqw+2+4ZpGREvwfyKlbsczwDSQI2r6VN
         MFP+oFpcoqrBKvd3j2B9tsSe3Pjj8HhsIYwCT2D/905lngptfL5kdf032VikCbcnE+Ga
         HZsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793041128; x=1793645928;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uO/W/z94g5X81Ln9+3SsNcj1ZpjaM4tumvmhkUCPgU4=;
        b=mIZRFD06VUrtT0C83csdmjduChlUDdWeKlLrBZXw1FD5Wmf+6zbvTnmBDvBVCbjT0w
         VVUFDxnzvunLaoL23aA09y/Y15hLToD4qZZog5rClfcRj1W+PkuHpBKEoB9ee+epnFCw
         5qK6WauW+XwZFkvjHfQ/FVld7XdWDQ0WDJCXc3+xHv1dR/1vaGWJ2IP395VYH57YFgZC
         1aT3Pda0fjwgdmGlUgIsc9P2RqdIASFDZazBjmQSGwiXtHv6q1PVa71HP2LuLMkll7Vo
         XyLTqmBAYZAjbf7Wrl3vDCwFER8VD0Oj/GC6McVU44oL5WjJ20uvYKc6Unhk0g9evP3c
         BjZw==
X-Forwarded-Encrypted: i=1; AKwUvBxDc+kqh7NknSz/CNyyjOz4JvsHT3DVZJG9236yc5k2E3fnXBH1WebdHsmi9CcBqzGLzgVO2jHoIg==@kvack.org
X-Gm-Message-State: AFq9FYK54Rtljhojs8OS+mKcHGVaXOgPitJwaWHjNmjnUASXyV8QCpPY
	9zXx7B3lgQ90nbVNuF0CTWqUsHVwg4Eou47MSbl8TCdJRQzFreRUoKwFIwSqoHk2rwxBTTHRcsD
	PHaJF3TtW3jdi82t9rQ==
X-Received: from ejzi19.prod.google.com ([2002:a17:906:a293:b0:c40:732:2996])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:9f88:b0:c46:7462:6332 with SMTP id a640c23a62f3a-c46bdebd370mr947991366b.37.1793041128327;
 Mon, 26 Oct 2026 11:58:48 -0700 (PDT)
Date: Mon, 26 Oct 2026 18:58:47 +0000
In-Reply-To: <20261026174217.603114-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026174217.603114-1-tarunsahu@google.com>
Message-ID: <9huz8q3k9tlk.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v3 0/4] liveupdate: Add feature header for
 fine-grained ABI compatibility
From: tarunsahu@google.com
To: loganodell@google.com, alex@shazbot.org, dwmw2@infradead.org, 
	seanjc@google.com, Mike Rapoport <rppt@kernel.org>, will@kernel.org, pbonzini@redhat.com, 
	jgg@nvidia.com, Pasha Tatashin <pasha.tatashin@soleen.com>, arnd@arndb.de, 
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, oupton@kernel.org, 
	baolu.lu@linux.intel.com, David Matlack <dmatlack@google.com>, robin.murphy@arm.com, 
	maz@kernel.org, Alexander Graf <graf@amazon.com>, joro@8bytes.org, 
	Bjorn Helgaas <bhelgaas@google.com>, kevin.tian@intel.com, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: E9A9080005
X-Stat-Signature: n1dbmo44dhrxeqirmry73cmxkgrmkf63
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793041129-959235
X-HE-Meta: U2FsdGVkX19k2VseAemsLh27FPvFamYxFG8YlHnmhtwgaHVo8Y36h5d8PECmgR4Ntun1YGW5yVQFJCNILsxQeMGTORwgAwfOrHiwHfWk5GzSNeCBY6Bv3OCLAWye27dXFxR9F1Gn1W+ZJtHWnrjMXXw+HqvTo722WZJCqwSfV3xUZfD95yC02P2Q0q0f/dZKx9ehC+NoOu8AK7dH9t2lFgmYml62N8LniNs2NBub9HhkJZxuHuNqQy9Qa1xoqY7SmqOTW4axP9V8D22rw3ZvJx5UkbhAZJDThxMK+qSSyGwSmQJh/z1NfeAddeGuPJ01mcY6D4gX1G0bMD6NxG4xHFw0e3Rd6NExy2vbk5NEtxlWyJVUghygC/Mx0qNgAeMOq2fQW5ZoH0DSeH1EBsOHZFx/o3eysCC9hkwsNvspTwol7lqK2nwXlEz74wfjJgWn5s2RBYAi6nv/uIosOvPmBqfJ3f52jpo+ZW+PrlVfn0umXqDPYLm818pjk2a22bVP45Dk2iNlMSuGscYvyzifbW2i/FXXV3wS0cdgNsgdkT7mkR+CJphJ/T3vWJf4Yza8RZ+E2Komf/AAUEBt9qegrKyu6HrkX4uaOHp5JpI/YwBlg2yEqFTLOIHM5WDFq0toM+BW6lD/K54fOHRng7TWZo3YimluNX9PvLd3Xa0ghHDElgAJhjS/bGYkg4Bos9EO/q6jM+2uC/Bokhs7bLj0OJr4Pev+3BSxcZYG5Sa2atFitZHMLx//S4FEbgXGST2iG4nj4ua2gei3Nbruf5jIKF2esm9CdpiGmqEXLQhJIiM/Ts9mqPkuyHiFnpKO7WYXnxsugFqjypEmqi0eVfisDw8aES8ri99hFLsLBbkL0tXxkyrQqt+njJIotSP5F6wBwToi8gkBhcSrHNqQkhhXbVnVCRErvFUbjhI/kg4Pb/JIVSI95MXGhHvTfCRqPLOEc7G8WpM9+KYZqVYiddm
 DLqvt32/
 +DfPzzt7TebVVgJQjdsBUra3KvRgSkdSOY9SN0kpQYCB0dOpuposRLfnB08UEaG5od+nNMylC2fMJOapHD42iYvP3i1dnvis0pOleRPe0muZ3UvbyM2Mi37ORAjYb1CfJVBZOhmQb7vuzLJFXXwYkE1FLOVz9xn1qxWPBRye36vp2q+/lyTHZvcTiOMLtwcqKxbXctNkyie1G+20fU54EAHnvmYiKxOkZWN8BuIIO6CWjdMkzmlQ88AJms1giS6FgeabaBHRxeKEsQbn3hc3G7DjcnkmeNmUarBKP6W4FV4NVsvzwm7xsmS59+TM+8ff6qaUYnCpkfh6Kjlmxs77E9/PQYAO0b1MxFjeHaQcTOQ0ByOYY4yV4JkIVjgO+vZmyYyUCEh55JXT+d/3Paq9rHve89rN8P69ywmtBsqJhiGQJs+tg6vSBpCldenmahSzr0ZFKUoQUDhPld2uIcR2LTYkt/NjTG1xb3AOSvavzL/Mu9k+TqoLRVhWSiHF6iOGJd/osnqv7j0Xl7uREHJAeEv1NCMLdQfoR0fn1YtagvDpRr1ODHnQY81fBHVo9Zua8RWUmTSi/4UpYHffTDiDq7lybEvrurGSZCtb5YEN8YMwdd2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


Withdrawing this version because of the following reasons.

1. KHO also has versioning which can also share the same concept of the
feature flags, And the header can be shared amongst KHO and LUO. In next
version, I will include this.

2. If there are any open threads in the V2, Can be settled based on this V3
reference. This V3 has included the suggestion from V2, like updated
truth table, nr_features based flags array, ABI wrapper MACRO etc.

~Tarun


Tarun Sahu <tarunsahu@google.com> writes:

> Changes since RFC v2 [1]:
> - Dropped the file handler compatible rename and per-FD handler
>   selection patches.
> - Replaced the fixed 128-byte header with an expandable struct
>   luo_ser_hdr (size, nr_features, flags[]), kept separate from the
>   payload structure. The header is 8 bytes with no features and 16 bytes
>   for 1 to 32 features.
> - Each subsystem declares its wrapper once with DECLARE_LUO_SER_WRAP(),
>   passing its feature enum MAX; the macro sizes the flags entries and
>   generates name##_wrap_init(), so callers never pass sizes or counts.
>   The target kernel reaches the payload with luo_ser_payload().
> - Feature bits describe only what each preserved object uses. The target
>   kernel checks them against its own boolean supported table, and the
>   header is trusted as the source of truth: validation only rejects a
>   required feature the target kernel does not support. 0b10 is reserved.
> - Moved the __packed removal into its own patch (1/4) and added a KUnit
>   test (4/4).
>
> Changes since RFC v1 [2]:
> - Replaced the 3-mask (supp, req, active) design with a header of 2-bit
>   feature states.
>
> [1] https://lore.kernel.org/all/20261021152527.375070-1-tarunsahu@google.com/
> [2] https://lore.kernel.org/all/20260903023452.721732-1-loganodell@google.com/
>
> ==========COVER LETTER==============
>
> LUO and its file handlers rely only on coarse-grained compatibility
> strings (such as luo-v5 and memfd-v2) to validate handed-over state
> across kexec. Any change to a serialized structure, even an optional
> additive field, requires bumping the string and breaks live update
> between adjacent kernels.
>
> This series adds a feature header (struct luo_ser_hdr) ahead of
> serialized LUO structures so subsystems can evolve their serialized state
> per feature. Each subsystem groups its serialized fields under feature
> indices, with index 0 for the base fields. New capabilities append fields
> at the end of the payload under a new feature index, and retired fields
> stay in place so offsets never shift. Only a change that feature flags
> cannot express needs a new handler with a bumped compatibility string.
>
> Each feature has a 2-bit state set by the source kernel:
> - LUO_FEAT_ABSENT (0b00): not in the payload; a target kernel that
>   supports it can use default values.
> - LUO_FEAT_OPTIONAL (0b01): in the payload; a target kernel that does not
>   support it ignores the data.
> - LUO_FEAT_REQUIRED (0b11): in the payload; a target kernel that does not
>   support it rejects the state with -EOPNOTSUPP.
> - LUO_FEAT_RESERVED (0b10): reserved, not checked by the target kernel.
>
> The target kernel checks the header against its own boolean supported
> table:
>
>   Source hdr  Target supported[i]  Action
>   ----------  -------------------  ----------------------------------
>   00          0 or 1               Accept: feature absent in payload
>   01          0                    Accept: ignore the feature data
>   01          1                    Accept: use the feature data
>   11          0                    Reject: -EOPNOTSUPP
>   11          1                    Accept: use the feature data
>   10          0 or 1               Reserved: not checked by target
>
> struct luo_ser_hdr holds the total size of the serialized structure
> (u32), the number of features (u32 nr_features), and 64-bit flags
> entries with 32 features each. With no features the header is 8 bytes;
> with 1 to 32 features it is 16 bytes.
>
> On the source side, a subsystem declares its wrapper once with
> DECLARE_LUO_SER_WRAP(name, expected_size, nr_features), passing its
> feature enum MAX, then calls name##_wrap_init(), marks the features the
> preserved object uses with luo_ser_set_feat(), and fills wrap->ser. On
> the target side, incoming state is never cast to the wrapper, since the
> source kernel may use a different number of flags entries. The target
> kernel calls luo_ser_hdr_validate(), finds the payload with
> luo_ser_payload(), and reads the fields of a feature only after
> luo_ser_get_feat() shows it present.
>
> Patch 1 removes __packed from the LUO and memfd ABI structures. Patch 2
> adds the header and converts struct luo_ser. Patch 3 converts memfd and
> bumps its compatibility string to memfd-v3. Patch 4 adds KUnit tests.
>
> Tarun Sahu (4):
>   liveupdate: Remove __packed from LUO and memfd ABI structures
>   liveupdate: Add feature header for fine-grained ABI compatibility
>   mm: memfd_luo: Add the feature header
>   liveupdate: Add KUnit test for the feature header helpers
>
>  MAINTAINERS                          |   1 +
>  include/linux/kho/abi/luo.h          | 359 ++++++++++++++++++++++++---
>  include/linux/kho/abi/memfd.h        |  43 +++-
>  kernel/liveupdate/luo_core.c         |  62 +++--
>  lib/Kconfig.debug                    |  16 ++
>  lib/tests/Makefile                   |   1 +
>  lib/tests/liveupdate_feature_kunit.c | 118 +++++++++
>  mm/memfd_luo.c                       |  68 +++--
>  8 files changed, 577 insertions(+), 91 deletions(-)
>  create mode 100644 lib/tests/liveupdate_feature_kunit.c
>
> -- 
> 2.56.0.307.g5fe7bd680c-goog

