Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3297606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 21:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PvWsZurj
Received: by kanga.kvack.org (Postfix)
	id C4E1A6B0601; Tue, 27 Oct 2026 17:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C26346B0608; Tue, 27 Oct 2026 17:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3BC96B0776; Tue, 27 Oct 2026 17:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 93CC86B0601
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:57:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A507120B6A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:57:17 +0000 (UTC)
X-FDA: 85369767714.07.FF4C8B5
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf06.hostedemail.com (Postfix) with ESMTP id 528CF18000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:57:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PvWsZurj;
	spf=pass (imf06.hostedemail.com: domain of 3OR7hagkKCFgJ0HKDI07K6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3OR7hagkKCFgJ0HKDI07K6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793138235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=INM4lTecUqg3+ORjH8the43AegIL5wVO95lrhujQQt0=;
	b=qmhFB7taGLQxKbui39wOCvTvxIfB18V4mVf8Y7xiuKS0m1ilM4XCU98j6GfUP1Z8BDjrMm
	OQeZighlnjvAcZa7EoxSQ9UbtJJ/nbnkDABFfcPF0VesvntHLei8V5LjytM/OE8UkI6iHF
	pMtSXoyx02byubQrrWAxSC34CqlCbI8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PvWsZurj;
	spf=pass (imf06.hostedemail.com: domain of 3OR7hagkKCFgJ0HKDI07K6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3OR7hagkKCFgJ0HKDI07K6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793138235;
	b=JUe68tiLHvcyRwdcQ0l35RSXmSs1IzQhUdVl1qiWMcEGlshEC8bV4jvueY/dmvKEt6Mq/O
	NeYt+ejHpCvVeFrwwjwg0AHEBW3g10juO8V8CrRVyY6XJOvzgM3nWdopMgCTq2hHNKWOw8
	NdzOmjvRIZx872HBJoDXTmZJQZYMn2A=
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c414c206673so28545066b.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793138234; x=1793743034; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=INM4lTecUqg3+ORjH8the43AegIL5wVO95lrhujQQt0=;
        b=PvWsZurjE1huZYRqeEhxwMEaXSzIdTx1NAVjdx+7AtP++c1nJ19be0C6b1by5QVMN8
         bfvmMLOfgGTKSWS6dERq7j22333ShCKSVwtJ5QDNiJb9JlWUJczD52fdIbEUq8R2AFhs
         7ZUkvuVsfo1v6u4eMOpNib7OUv9HrDARw5OrexJ0E8RZkwFaOIrtcvUf5yyDWSeZWWZH
         BOwVcO1Y4wM7fwiLL4IUBxiuRbg9uAMs6j6DZcOkj4LWby/BvTIg4V2HMDR/0TvdOnlZ
         LhGEme15MFk1J7ju+Fj7ndFSIUSnU6CPm6AL98F0vibkIjBvtf3cY/CWukrCQlF4ieON
         +AXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793138234; x=1793743034;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=INM4lTecUqg3+ORjH8the43AegIL5wVO95lrhujQQt0=;
        b=1NiKlHHlycGiDJV7daCZ1lSI/YmCEzjc314o056Rd4bc9TG+7Nt85zNVNEly91XtOx
         TybRlRUsXUcTtLbZIW4GeVKDYEtV+jf6g1uEHqW0SOtpsUaqBHCSnPyGbtJQNHwoRBMv
         xWBDKOjRs4rXkQKEXmaL2+bfX58IAEJBUV3/oOEIxh3+Ys0hrAEBh4s06zPouqOqhz/s
         ZLQ46RgGU5ruoiGRsfP9UX0znFSle2tpTG5ygGvJcb9LA0Ab7wIM0a8daaApgcAZeouG
         nOoTR3H4Vl1cWj+qIWM1RjT5MJ44XIFsQD5qfF0vXTnLZIVgUbxLZR/BKZOxfkoWP+3x
         ozUg==
X-Forwarded-Encrypted: i=1; AKwUvBwCEcidW1dA/LolY3hj75MRW0Z/44o7KhpN1dcKWMPnIa++wGieRXlmioE5MzPPfZ2PeX57vewDrA==@kvack.org
X-Gm-Message-State: AFq9FYJAvCdfPJTUERAtckurVKIMKNaIU4CKo4DoK42REssy2UV0Ai/G
	D7LRMBqimgXLDGcwSQWERJrnEZD79b7eQ2cDYHaCrdsHjKrtV9itxCPkxVRde/zDiKELll+PmbX
	9AT4fmjRKaDBPDUTmtA==
X-Received: from ejkh2.prod.google.com ([2002:a17:906:7182:b0:c46:743f:a4b9])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:e84b:b0:c2e:3a72:ffbd with SMTP id a640c23a62f3a-c49bdf71b7bmr44517166b.41.1793138233642;
 Tue, 27 Oct 2026 14:57:13 -0700 (PDT)
Date: Tue, 27 Oct 2026 21:57:12 +0000
In-Reply-To: <CALzav=dYKAP7pKfoPtz32X1cT_tH4LN0X47_jTO8_HOCT4Pi=w@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <atlQ_Er0Ig7CCSxv@google.com> <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
 <9huzzew0el59.fsf@tarunix.c.googlers.com> <at_CncIPYCxOVkLo@google.com>
 <auDT5MjXYq3lcQjE@google.com> <CALzav=dYKAP7pKfoPtz32X1cT_tH4LN0X47_jTO8_HOCT4Pi=w@mail.gmail.com>
Message-ID: <9huztsm6958n.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
From: tarunsahu@google.com
To: David Matlack <dmatlack@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 528CF18000A
X-Stat-Signature: tiyd7z165t5eyeabds87e5intxkemc4x
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793138235-288360
X-HE-Meta: U2FsdGVkX18+S4A+FLNRzBKNe/FY0CFwlNf8Zy2b+ztS5SNvYyRPi9WAKwsVtOvyE9TIgfn2H45a1JH4vRR5VFqQVWrEDz9Oa5UyJlESeh6zl715czIcMyhSvfzxfritRUH7aydcbLpyouNFsVR5bX9n0XpQxiScE7ht+jDFDaO2lvZpnUeIBZs3sYwfozw8bBma2DHrHVKUe8P3f1DJqChJk6CN2ci9XIaRVWg9xIQ8rCnMGIHw54EYgvLhW+f5IZa82oXRJhcOICPGahGhKhb4EGyxVVC/tKQr9Xbgjrrdx+NZxepjVx+13IfQxk/WpPJyONvhpUkXK7yA9r6604s5wxCSLig+3fKik6DYYj4xO635G4GG590tF5Cpxc/bV6GxHBzk7qCpqLJjnSecL+lgD9PrKzVRjyPwDqe2sPWU9yTBukh0g/4pLRSZXjBgFdyRHJR/QHGTSgS2aCIzv6IuxkCPzdRPR3N8GF9qomXVWkUAuyeB2W512YCwm+eJVh3eeV0BELAhieQsxf8T7kX16Hq39VWNscX3qOPRc1+j1jYfULJZHrlM5fzVrmlcsOFbhyfzR3RfYt5s6oG3j+C0pYXCAoo2omUFFtZDHz5rIBW7dPEnX11/qT/4cZHyOqV2pBy1alhAS2k6Abv2HTeYB8D5oIxabrwy8xNpScsKeCzrIbEEDP0VU8I4jIy5Ly81mOPGkOckL5zKzkcVmfrUyhgvorUEZvsdmDnpi9b10NCUbA6IKZqbnaB/uMRJr8Imvy7wW5xJhEwFQYIIyW5/Kud50bu+QFUf9ZRyNQT9qC8LoGZa8wZ3uw6vciQ+a4WWWpCKSTSQ5XWXfVRfjpuxYZispqd9BJPJkUp61S7+9CbwOwiB10USgaqnYxB1c2d34MK8tOmsvBHg3qqrUho5DI/DdiL4G1h9DBNbxYfK1+2fvVK5b8hBoV9NbYpKs0ix6Oaq5z4IuNmPvvh
 OWXVINDy
 pCbYV6LwSKHWNWfJP7uCSwM8w/o2ncFSQP6PU/JV+20XoLNK0R3b0ZeCS6Kde7lCqaABV9PtSQVDf0jMcMXZi3AKoviRmAJ1p/CnSGuXD9Kq9loRtczNwW7o5x5iSo7CawyN/KrAC8hdjCL7XZ3fZRKd9jz4vjUX3MRV4xxZJ41vt2AOgCHZxmPGnkdbAsO0CwERp1FN95LPENQFUgUgKrLMj72vdImLe7wG2QhRcdUEwlm2ODs2M2Dcojd+ame7vqlj9TTN/AErHQ+xO1Zac3W+KuPm2y++jEKwUt1/KXJ63Jmf2UnpXXNCxNIjjVCQpR3LZfq5MIi5hlPqJ3rXabbUkjPrO1H+Yt71naOKXrj4dabWo6T47f2Lcfyv4vVx9p/sBSvfo3f77scfxPOn8Ds0pGFGqzmrHVTJDMM9lYP7Zyg4E6oyHcb+JJsSIaTaGk/0jD5hlyg2IxV6fQVWYq3wcXDJSrbrScPFS+pd0w19m789f8iWOiXgzLba03hbxQEwQoL2d+mUyv/hZ3sTvTh8PWQtksFuJbU7RsNofWy0R2JLKJP75Hm2vtddTy4+4m6JL2fJiTQ38ID6DRZVuA2IoK5L7zLDaiK+NOgyf6j31coq5RbjnPTnXsrMBVDxzjibbed/GE4D54Wk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

David Matlack <dmatlack@google.com> writes:

> On Tue, Oct 27, 2026 at 9:40=E2=80=AFAM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
>>
>> On 10-26 21:14, David Matlack wrote:
>> > On 2026-10-26 11:50 AM, tarunsahu@google.com wrote:
>> > > Right, Required bit should be source kernel payload property to tell
>> > > target kernel that the payload must be handled to correctly deserial=
ize
>> > > the data. It should be source kernel (userspace) responsiblity to ma=
ke
>> > > sure it understand the target kernel before doing liveupdate.
>> > >
>> > > Saying this, During deserialization, target kernel's required bit is=
 not
>> > > necessary. So I propose the following truth table.
>> > >
>> > > Source hdr  Target supported[i]  Action
>> > > ----------  -------------------  ----------------------------------
>> > > 00          0 or 1               Accept: feature absent in payload
>> > > 01          0                    Accept: ignore the feature data
>> > > 01          1                    Accept: use the feature data
>> > > 11          0                    Reject: -EOPNOTSUPP
>> > > 11          1                    Accept: use the feature data
>> > > 10          0 or 1               Reject: -EINVAL (invalid encoding)
>> >
>> > Yes, this matches what I had in mind for the semantics.
>> >
>> > To be explicit: the source kernel should set the bits for each Live
>> > Update based on what is actually preserved, rather than generating the
>> > header from a static per-kernel array. E.g. memfd would only mark a
>> > feature present for memfds that actually use it. That's what allows
>> > rollback to an older kernel as long as nothing being preserved depends
>> > on the new feature.
>> >
>> > But looking at this again, I think the required bit is redundant. Whet=
her
>> > a feature can be safely ignored is a property of the feature itself, n=
ot
>> > of any particular file. Every file that has a feature present will hav=
e
>> > the same required bit for it. The only thing that actually varies per
>> > file is whether the feature is present.
>> >
>> > The required bit still has to be conveyed to the target somehow, since
>> > the kernel that needs it is the one that doesn't know about the featur=
e.
>> > But it can be conveyed by the feature's number rather than an extra bi=
t:
>> > split the flag space into required features and optional features, and
>> > assign each feature to one of them when it is defined. This is similar
>> > to the required_flags and optional_flags approach in struct pci_ser [1=
].
>> >
>> > Keeping the same header shape as discussed with Pasha:
>> >
>> > struct kho_ser_hdr {
>> >     __u32 size;           /* Size of header + payload in bytes */
>> >     __u16 nr_required;    /* Number of required feature bits */
>> >     __u16 nr_optional;    /* Number of optional feature bits */
>> >     __u64 flags[];        /* Required bits, followed by optional bits =
*/
>> > };
>> >
>> > Required feature N is bit N of flags[], and optional feature N is bit
>> > nr_required + N (using nr_required from the incoming header). The leng=
th
>> > of flags[] is DIV_ROUND_UP(nr_required + nr_optional, 64). Both spaces
>> > are numbered contiguously, so there are no gaps, and up to 64 features
>> > still fit in a 16-byte header.
>> >
>> > Each bit just means the feature is present, so the truth table becomes=
:
>> >
>> > Source bit       Target supports  Action
>> > ---------------  ---------------  ------------------------------
>> > Not set          -                Accept: feature absent
>> > Optional set     No               Accept: ignore the feature data
>> > Optional set     Yes              Accept: use the feature data
>> > Required set     No               Reject: -EOPNOTSUPP
>> > Required set     Yes              Accept: use the feature data
>> >
>>
>> I like this proposal. I bet most features are going to be either
>> optional or required, and even if we ever have a magical
>> sometimes-optional feature, it can have its own required flag. So, no
>> need to pay double the cost on every flag.
>>
>> Just need to make sure that optional features always start from 0, in
>> their own enum, so the offset can be computed correctly in the incoming
>> kernel.
>
> Right. Instead of having a single 32-bit feature space where every
> feature can either be optional or required, we have 2 16-bit feature
> spaces, one for required features and one for optional features. Both
> feature spaces span from 0 to 2^16-1, and then are packed into
> flags[].


Okay sounds good. I will send the next version soon. Also I belive the
design is decided, So I will drop the RFC tag also.

~Tarun

