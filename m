Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EA59606A33E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=s7z3LT1C
Received: by kanga.kvack.org (Postfix)
	id 20BCE6B05B1; Mon, 26 Oct 2026 07:50:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2F56B05B2; Mon, 26 Oct 2026 07:50:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2AC6B05B3; Mon, 26 Oct 2026 07:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D46746B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:50:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 673571406D3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:50:14 +0000 (UTC)
X-FDA: 85364609148.05.1849ACF
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf07.hostedemail.com (Postfix) with ESMTP id A2D1440002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:50:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=s7z3LT1C;
	spf=pass (imf07.hostedemail.com: domain of 3cj7fagkKCMk8p6927pw9v33v0t.r310x29C-11zAprz.36v@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3cj7fagkKCMk8p6927pw9v33v0t.r310x29C-11zAprz.36v@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793015412;
	b=x5pSiGlsueBPFRWa0vH8owELxMC2plSj4+f8l0iGgFBOMZRFTC30kE2s4Xmy89U6M0ZaBC
	ENJHJWuYElkaY2tAAj9zGyVhYdkNO3RG91YWhnShJejuAh+xWdiYUYww/qTHsR49MZ+BpV
	lHsY6GD4B/N9iROy+oSFLgx4h0DXLZ4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=s7z3LT1C;
	spf=pass (imf07.hostedemail.com: domain of 3cj7fagkKCMk8p6927pw9v33v0t.r310x29C-11zAprz.36v@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3cj7fagkKCMk8p6927pw9v33v0t.r310x29C-11zAprz.36v@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793015412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6ehAr+5O7aPeLIKo6+S6CS8cvliVvtVKcymE8BrUws=;
	b=uN0DOyqTTZnYonOG+kfqZB+n3fb+BVi0Ag9Vfz3d0AflXo5dAtuiFSskD69f8w/aSaGYOd
	EaEE+nraGkCFzdbrn2eC/kIIiCmH5brSvkHBSYmj7CcSEc5yg+NR0fVGSIWqkwUa7azOxK
	YwWWsm92G7ZkwLVTeLi15i3nU7+bsCY=
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6b1a4c9eadeso3017410a12.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793015411; x=1793620211; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=E6ehAr+5O7aPeLIKo6+S6CS8cvliVvtVKcymE8BrUws=;
        b=s7z3LT1CmsgEclR7DGKAPFS7rkAzl6TgPJTqjDkrzpvG7bVQjkQIBlckLuD/Pucfy0
         dGAAPcmvO9alqNU03kpp4NjjkQ9Gg4CUB6t28ErBmni1V3CcaT7JCuQTaUOO2YqxqdNa
         /hjU/QS9cQtKlhrebS7Lnskxa06BbGEUvBLNEgquhqpU+1Qmi/oYVtxUYlZ5PE7/ygHu
         gugxzBuwh0Y35+gao6LS2v9lwPguRx5Y2/SgirwCJ1aVSAHU27AciXwhynBIDPbCtNsu
         YjAhtVGLrvzNkJudIV4u5aqVXQMi9bD0g/09aMb5XyS+jdNW5Bta1HhGvRSSdoUlDUqN
         9nDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793015411; x=1793620211;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E6ehAr+5O7aPeLIKo6+S6CS8cvliVvtVKcymE8BrUws=;
        b=yxOxw1TWrGsUcuoVPl0FoTNGdCIG3nBsLYnNsXsof6mjF7YONMxtsMXsd3m5UdBlap
         a48y+ayyHDTa8PKC7/9gQOxTENbhfdPaKHXYHKTiscFYSHUn4uhxtcmIcWy43EP2GBfl
         2VXluqAi9JAJQGJEaPoHtmrO63ASOCxYH4CRdIs5JLto37VbncmZCXe/JwOWH+4AiACk
         LCBK70LRI1WWmNcESVIIXlPdkChZ4Qy3AmmqxcgsA2LRB4Qi+h3f91HF+l50F89zLpUD
         bgBQO7W04MBlK/V+U2EJaIe/pOSqIElomFEiXJLcTqWQHn6f1bUNW/eoTHJvGoudg8F/
         gG8w==
X-Forwarded-Encrypted: i=1; AKwUvByeGN00VD0ZtOwm9gohCbzhY2tCnUhOpWx0b/LVX+D/b5E0eFycpm8UsQKfu22T0rhL233GSBSfuQ==@kvack.org
X-Gm-Message-State: AFq9FYLxTOhsTyNgB4PX8e/kqKv96b3R+DUFVtO34y66kncxSaV745vb
	3XfDG6Sbyt4zss5dmx5cX+q5JA4SpdlXuoO9rFLHD0Vaz7tx5v7pfgne+7byg3S2Q7cnQJGLMuf
	EsF1LBcFch2A/CWN9/A==
X-Received: from edrd16.prod.google.com ([2002:aa7:d690:0:b0:6b3:8448:41c6])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:249e:b0:6b1:c7d9:b622 with SMTP id 4fb4d7f45d1cf-6b442fffef3mr7891637a12.26.1793015410774;
 Mon, 26 Oct 2026 04:50:10 -0700 (PDT)
Date: Mon, 26 Oct 2026 11:50:10 +0000
In-Reply-To: <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <atlQ_Er0Ig7CCSxv@google.com> <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
Message-ID: <9huzzew0el59.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
From: tarunsahu@google.com
To: David Matlack <dmatlack@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ckhbeoonizkpsqyyzucbhrgunhpcj89m
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A2D1440002
X-Rspam-User: 
X-HE-Tag: 1793015412-356436
X-HE-Meta: U2FsdGVkX1/asxOWtvGMulRxocC7hPWlCK3DPK+ZCGmlteguT+HL3R0pIksCrGvMe8hgKg6l+iIX+0loHe3WLLUxcKHgxtljKKuBg97PmMCG/XpcFldZL9T/f/UnZAnEHse9LkDbCNUTB4Xy+Wrtb3wXE3J0jy23tAzvDy7K7HlFkPz7/k3U0bYm4rr2xqXHLzE5KPN0PVa0n98HcGHeWYQoCm/RLnccseRkC6RdxElUreellm+u+NvozZelxAaVzs3SI7EGuxHPx9v+o3TZZwkRZ+fJxHVQJXp7RHqjXOgRhWsrdRiMB3JKKphCJ/fzRPRbpABpvci5FFyE0TuIFLRxmz2vFFbnqR9eZyo3vsW8crsLke97e51LRDCU2jTlRgMGwKBt+DHvYiRqG6Br7IZmRgWoOMmQBnWaWuOZMpzSrUhccGNT2rbospfAXdRWmnDm36XxbEfc78CykwUo1AhE0wbMD46uRMN45suE3n5paNY4rosoFQNm7WBsfMErz+lAllgv0cdTjOu3FA/8MPrKfEzki6vgnIGjlveTo14W8kgbG+fj98eGd3Cu7p9Fs4EcpwGXGB0SBSWxGcY+C8Nwe6+2+BbN6UYbO/fSY/zvmsSZUbDp5fgjAr0ztoePFd+sE8sZl2nqdQmOCPLsUp9l29McEck+5GoMXfT1o1yOHLAtDwS9y5vEFc5U5PnEAAceUWxWruUPjRzmdW/d06lEI+JW6wyqmb51450dreN97otOmbafc4v9SPePHqYDTqH+TkQxMjd1TgmxJ4zeHzkfUCu65FtulF8jiwkdjd5+DhH+OLB/vfkJ0F0Q4Ygq/KALohu4zGP6n+MPWZFCNg0yVIqeEqV841oQCVVH7NTNFR0g94PRZMxvi7TiEuD02e21je4aJSC/XHiwDAVfJuMOVbr7ab/i4iiuQnl/LcJnphrwRzbXKMMrusq6k+D30dJZc6UMkeWvWm3q2S7
 /M027v58
 TXdGuLkrfGqKiRw8O8wcT0hesjOBCepvmzUMnKWFYok+/jlWc1CtJg+yI0I4ZmwaW+y25ZQPpu32AXTrhrLykX22Ujn580AckeMdebaEqghicLZt0XaM5o1zcAfidnGuX3E9YavXm6m6KZPgra5Zg7ucYdIpDvkGrOzJxJJBVQ3556rnp3KiamgUCWKBMtUPGGId60DAJLmmYUSUXGnZkXaL9mV+OgJ7bt0z71JgErGoKdz9skmOk2owJZxINt8j/5gsNRQXpQmh5OtQ0tOgPpMTNloYh/iJrI49o+Jsvei4qAmgjgPnwtnF2LV1+MIX0EvvzTyfKvM81BqVXIuCrdLDzGJYzODISWqEk2lSQHEFaSXHV0TaTltM1CSH06KwkgUNV5xNCgx9cGlBWp0a5nbxa+j+UlLjoJ5+JRRsnVyu4e+29IfNrUajkge9tUWuzdpk4v/1J5pGqL4Ap1z6gxk7DXMPiqiKqed55Xb1dkO5VCa5uqSWoGHdDIr/Bz/r92Qfk31A8qA5O1v0x88yB4gd4cLIeK0Cj+Bl++IIQ7USMpVKc2FHZPEu6mMa07mw/+XQyrHWgp2DmXtb5MWX3cNCQGwabRyko1Q4dGVliQnVn/Kg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

David Matlack <dmatlack@google.com> writes:

> On Wed, Oct 21, 2026 at 4:55=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
>>
>> On 2026-10-21 03:25 PM, Tarun Sahu wrote:
>> > LUO and its file handlers validate handed-over state with monolithic
>> > compatibility strings ("luo-v5", "memfd-v2"). Any change to a serializ=
ed
>> > structure, even an optional additive one, must bump the string, which
>> > breaks live update between adjacent kernels. Replace the string in
>> > struct luo_ser with a feature header, so that the target kernel can
>> > accept or reject the source kernel state per feature.
>> >
>> > struct luo_feature_hdr is a fixed 128-byte header: the serialized
>> > structure size from the source kernel followed by 15 chained u64 featu=
re
>> > flags entries. The fixed size keeps payload field offsets identical in
>> > every kernel, regardless of how many flags entries a source kernel use=
s.
>> >
>> > Each feature has a 2-bit pair (req, active) state (enum luo_feat_state=
:
>> > LUO_FEAT_DISABLED, LUO_FEAT_OPTIONAL, LUO_FEAT_REQUIRED). A flags entr=
y
>> > holds 31 features, and bits [63:62] =3D 0b11 chain to the next entry (=
465
>> > features in total). Each subsystem defines its feature states as a
>> > static const u8 array indexed by its feature enum, which
>> > luo_feature_hdr_init() packs into 64-bit flags entries with
>> > LUO_FEAT_EXT_MASK chain bits. The target kernel validates the header f=
rom
>> > the source kernel against its own feature array via
>> > luo_feature_hdr_validate() according to the per-feature (req, active)
>> > truth table:
>> >
>> >   Source Target Action
>> >   (1,0)  (x,x)  Reject -EINVAL: invalid source kernel (req without act=
ive)
>> >   (x,x)  (1,0)  Reject -EINVAL + WARN_ON_ONCE: invalid target kernel
>> >   (0,0)  (0,0)  Accept: feature absent
>> >   (0,0)  (0,1)  Accept: feature absent
>> >   (0,0)  (1,1)  Reject -EOPNOTSUPP: target kernel requires the feature
>> >   (0,1)  (0,0)  Accept: ignore payload data
>> >   (1,1)  (0,0)  Reject -EOPNOTSUPP: source kernel requires the feature
>> >   (x,1)  (x,1)  Accept: use payload data
>>
>> I think we have different definitions of "required".
>>
>> In the PCI series [1], required and optional flags describe the _data_
>> the previous kernel handed over, not the kernel itself. A required bit
>> means "this preserved state depends on feature X; a kernel that does
>> not understand X must not take it over". An optional bit means "the
>> data for X is here, but you can safely ignore it". The source kernel
>> only sets a bit when the preserved state actually uses the feature.
>>
>> It's up to the FLB/FH retrieve how to handle the scenario where a
>> required bit is set that the target kernel does not understand. For the
>> PCI FLB we panic since failing to adopt the PCI state could lead to
>> memory corruption as preserved devices can be doing DMA.
>>
>> The target kernel never requires anything from the source. If a
>> feature is absent, the target kernel must handle that, e.g. by
>> falling back to default behavior. If it can't, that is a compatibility
>> break and should be handled by the compatible string.
>>
>> In this patch each kernel has a single static feature array that is used
>> both to generate the header and to validate the incoming header.  So if
>> kernel N marks a new feature X as required (so that older kernels reject
>> data they cannot understand), then kernel N will also reject every
>> kernel that does not have X, because of the (0,0) -> (1,1) row in the
>> truth table. That breaks forward updates from N-1 to N, and rollbacks
>> from N to N-1 even when **nothing being preserved uses X**. Therefore,
>> every new required feature becomes a compatible string bump.
>>

Right, Required bit should be source kernel payload property to tell
target kernel that the payload must be handled to correctly deserialize
the data. It should be source kernel (userspace) responsiblity to make
sure it understand the target kernel before doing liveupdate.

Saying this, During deserialization, target kernel's required bit is not
necessary. So I propose the following truth table.

Source hdr  Target supported[i]  Action
----------  -------------------  ----------------------------------
00          0 or 1               Accept: feature absent in payload
01          0                    Accept: ignore the feature data
01          1                    Accept: use the feature data
11          0                    Reject: -EOPNOTSUPP
11          1                    Accept: use the feature data
10          0 or 1               Reject: -EINVAL (invalid encoding)

Where Supported bit is extra bit information used by target kernel to
deserialize the data. Which is static information of target kernel and
will never be used in serialization payload.

Like,

static bool memfd_feat_supported[MEMFD_NR_FEATUERS]{
       [MEMFD_CORE_FEATURE] =3D true
}

This makes every kernel 3 bit information.

required+active: used by source kernel and embedded in serialized hdr
supported: used by target kernel to deserialize the data if it supports.

~Tarun



>> I would drop the target-side required state entirely and let the source
>> kernel decide which flags to set for each Live Update based on what is
>> _actually_ preserved. Accessing a field added after the original struct
>> then always requires checking its flag.
>>
>> At the end of the day it is up to userspace to never start using a
>> required feature while they can still rollback to a kernel that does not
>> support it. Cloud Providers know how to do this since Live Migration has
>> the same problem. This also means we must be very careful when adding
>> new required features, as they need some way for userspace to explicitly
>> opt-into them. I do _not_ think we should try to have some generic LUO
>> opt-in for required features. That is up to the File Handlers and FLBs,
>> as they have their own uAPI.
>>
>> [1] https://lore.kernel.org/linux-pci/20261013162529.1928093-1-dmatlack@=
google.com/
>
> Oh and please see the follow-up PCI series to preserve BARs and bridge
> windows for some examples of using optional_flags to extend struct
> pci_ser with additional data without breaking backwards compatibility.
> e.g. https://lore.kernel.org/linux-pci/20261019213054.3157159-5-dmatlack@=
google.com/
>
> I don't yet have a use-case for a required_flag.





