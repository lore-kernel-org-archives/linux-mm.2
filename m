Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E80346079046
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Dfu68BII
Received: by kanga.kvack.org (Postfix)
	id 1075F6B05FB; Mon,  2 Nov 2026 10:52:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF346B05FC; Mon,  2 Nov 2026 10:52:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01BD96B061D; Mon,  2 Nov 2026 10:52:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFB2D6B05FB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:52:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7806D1A014D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:52:17 +0000 (UTC)
X-FDA: 85390620714.04.B7A3E00
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by imf07.hostedemail.com (Postfix) with ESMTP id B4B5B40013
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:52:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Dfu68BII;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3rbHoagkKCBIBs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3rbHoagkKCBIBs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793634735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6RtsTbIlQ1+MerKC0xhFDG/d459vnICRyJwyVtriLE=;
	b=trgvyNgHeOdadxqZ8oVilFM/hJmeMWmot8/eUpjIkAnR2cOuCFDsVdwe066jkrXIrlmECh
	1nW5vtxSiF5TvVXnFkwEoNWmuqQud2GA9cW6ZvIZcUu21xJrdY6p+ydgTXMtZU6z6kt2cM
	tVwBEsd95qS047JoEWB5HGHO19hOHDc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Dfu68BII;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3rbHoagkKCBIBs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3rbHoagkKCBIBs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793634735;
	b=TQo/T7o4zbdZD0n+RR+9VGhD+BM0IG6F3NA25LscRwYm0QZgu6255AJ35K/z87FvBDOVAp
	NHyTXgImeSdeAI4hNS4r3UjI20zmnI8TC1jSmQ/Dc5Df28iwnACVqVUQtCVJS6V5bnxFHE
	K/lrjYVsD4A4NilwHXRYTZeLOKwr0S4=
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6b1d818b501so1330746a12.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793634734; x=1794239534; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=j6RtsTbIlQ1+MerKC0xhFDG/d459vnICRyJwyVtriLE=;
        b=Dfu68BII6vFl5Ya5Wy98TIu6KP3oFa1AvzkAEZyVlxM3DNXKHMS6qzTVYBQsfsEYbs
         ZLwZSQVJGXu/yNZ9PL3bjUbNCwDZyptqRtsCLSohhFQJQgmC80iVkedUU+5lOk4UTR3d
         +zF9X3hei7sE8NOjDgqpUpRpM7sSPOLjC7kRDOXSOuiWN/PJzNEWrLqqUhFl9NYAaTPj
         lsA/qjUM4rhBYg6EI7sc5xj9yBp5izj3EgOPbGrgvDnhvX8xERF6a8AIIrfcVDwSwZXN
         3JNWb+jQu/WEaXmsH2hCivJpLKvhTSGa+hj6+a/ri7mgacbYF7MR9mRDhClBH/VH0n+h
         0f5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793634734; x=1794239534;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j6RtsTbIlQ1+MerKC0xhFDG/d459vnICRyJwyVtriLE=;
        b=ky6FTVcyjJ40NzaYMb2MwvMqDsf8K6HnsyO19fFFx7s4kx97TePeHyAoD5rm9TIyhZ
         +eF94G/KKHG6yGjWawWB/X9ip0rZvK7VkO2mg7ZXbKMqcV8HMhyK88mNIhBiMRSNBOxC
         qAuEu87e9MGjmK0u55sV5dYYdHCHEW0AIe6Gv2Rtb2YeDE5mpzvt1T4bGWlEt/MZaAvi
         NseeM1Eu7ykqJdKUKF3o0mU++Icthsj+PzaQ63T2ohLdqujej56M7ku0d0xrW8Dpswal
         FCyHkO0pJNj2HtCtbHjcnwXCK7voDFlxyI6yegIfyq2sWocHqsV8i0TT6VRkUgi3edit
         eieA==
X-Forwarded-Encrypted: i=1; AKwUvByjTkXy96cXQBwvXCS+fhzj09U1bkci5DuYjBY/DJX841TwSOa6sLj2ej1uaNGicwWgB6nQI3Aspw==@kvack.org
X-Gm-Message-State: APuU4Z/XKL0mOWjppD4FQ0Z2Y731OtnwriFFndNWXKWj6ZkS+2fNWCST
	EtsB8pEHfUwErK5LMmKxVDW6WbiA64ZeGweixdC7sd0PLysz4q/AAglFHnh34lkBWWuGooWev8R
	Atvamm2GUQmqpNwV3Rw==
X-Received: from edwr13.prod.google.com ([2002:a05:6402:34d:b0:6ac:bd6a:1c30])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:aa7:cc09:0:b0:6ac:7737:e50d with SMTP id 4fb4d7f45d1cf-6b4d4d83eb2mr5865537a12.29.1793634733847;
 Mon, 02 Nov 2026 07:52:13 -0800 (PST)
Date: Mon, 02 Nov 2026 15:52:12 +0000
In-Reply-To: <auI02M-pZO_aQ4jn@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com> <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
 <attmFVIFU_mS0Y7p@google.com> <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
 <at-8vkVpN2SF3XgB@google.com> <2vxz8q3hoicx.fsf@kernel.org>
 <CALzav=eG5j2n5omO2Mxqw8xA4sZLduxdbBYFcnHpPn0PDpt9Hg@mail.gmail.com> <auI02M-pZO_aQ4jn@google.com>
Message-ID: <9huzik2fz0wj.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
From: tarunsahu@google.com
To: Pasha Tatashin <pasha.tatashin@soleen.com>, David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, maz@kernel.org, arnd@arndb.de, jgg@nvidia.com, 
	robin.murphy@arm.com, loganodell@google.com, oupton@kernel.org, 
	kevin.tian@intel.com, alex@shazbot.org, dwmw2@infradead.org, 
	pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B4B5B40013
X-Stat-Signature: 5pzphqtybbwofnkx433srmytqgrnb87b
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793634735-850666
X-HE-Meta: U2FsdGVkX1+IVbAnvR3s+t6ATFquxLoDkTJttJa3/ZC0Dth5DdmI+60Y7YqP+VV2g+fdKtKU9JHkOCod4KYOgGLk3v7VEEWDkkVPH8olzh6DHFoHOUPl0H9Py+Hdf1vM672MJGp1Jrve5r0uXIghCXH+3bzI7Tgo/z6WLmgwgL8eBoY5PIGRamQF4N2JMsI4/dms1zTBFrFkDzm2w1uSPKM02AwcGOYCOcRygMqIBBkENutaRx8gYPy+94J4NGB+TJfAt8cxKWrAy2On8RIV8he7Lzo8tSGKAL8et4jshs/VRL4aJcWsXxtyqPlGyooCjqZNgbtTyUe9L3iPFer4sP9uVRnE2aIy6O2dX0GCsHs7kbp4hbyLYIg43G1t8aFWw3gzVpDmd91z2ne44/CttMC4AftTJp7pFNlQUpi06ADZiFa5e7SgNEatzXoMeJfMZiSic511gZzgsQh9Cwepv96eMtrl3HKq2TtNkr43r4ceybDb9zxdfnHxJrUHINWhMVZnyWh/i+/KQC0y7zQRdZIyg+4omhr9qr6BYMx1XMSnczvOfula1y83zB8kG8IQIvGNWkDcapnFWoG/olgY1+r5HdgGj9OpwC0O2R15jfuhHdvwpG0ZTYWgkcvkqyngtL3IN1p5YaXhUO2bIFoOE2dBIV2HsHGthr7dCi4m1csr6hM+dq9/OcCXAlf8Tqk0JhOmRLI/RlQo+ed/l3rPL+jRf6hq8Ju9qshJS0YoP2/nluZX+nV/d1mXGrcra5S+SHkNTEpc/PW2RuWjMnNZ8kE8AsnRQ391FuRVo3BOuSD3VWfNfBhrJv2zGDpQSYpqb9cMNBa1xr6o6twZcI26fYxgggxZFQCjunDqZs8J7Ytqe3ZQqON/PjOk+2r3V2JncrdJT7X277PV7LtR08KVaKnbufmVZwILr1EQi/im42Z31/SL9ynuV19ydj3TMLcJD/bsNfyQkCDRjS/rVdL
 jE6qGwqv
 lJnqQX0irye1qI0OUSCUoC8UEqflEI44MxfVEe5mPOmcr4NAy5c28SBeav1GlXyPAOqxySksH0OJchuXrvqnwkDjsXTCHP4q0u/nZWXUFd/twKakiA5BBwI5QZPjy2X5WCilQNmRbTWlgiv8bRa1I59TefBv3+0CB5VdCdlTJ9nLu+sx/3KzqtdGAnwb3mFjXOVuUHrOrfX+TLJcBw1FBpH8/U7FmDnrz+qPrlzCv7idcQg9aMHvPiWKfKWIOTDlGpYMyzY7uZ07b+SRDeygJpbjHrUlHjmpfghkJRSyn36ifhMJg4oGhmvYTKtUFQP6gOVTiwixo8NHT3gD6+eWdIaWXR5bzyy53zOn64TK95rbZHyKOk4pTuG+e14NVi7+Zg7bWn8Iuu1z294gLVGlCzkBonzvnfhrmSwnsAwefaGJdnGPIFXnYPSyNHoMaNUzA8eqsmQaZlhJKmSLnP7Zx6XFp9zWDu5KBb6fpt567WwlzfDmPHUdPzqOK/hpwPeN19dZaPjx2JKSkwqu6yMJ3zwfsXPx8NfQiyTZ5IQgxH00gG6hghdnygorOxhDJ7j0TRY1oW+l4ZtBMRwNYRrlxtEeF05tfXP/siLpjJ3zPnos8zfEGbhsaYkFeW1wzzzjHdlGXQFAa5O2z2+1yOL4XRlNOORQg0LifUi0H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Pasha Tatashin <pasha.tatashin@soleen.com> writes:

> On 10-28 10:24, David Matlack wrote:
>> On Wed, Oct 28, 2026 at 10:17=E2=80=AFAM Pratyush Yadav <pratyush@kernel=
.org> wrote:
>> >
>> > On Mon, Oct 26 2026, David Matlack wrote:
>> >
>> > > On 2026-10-25 04:38 PM, Pasha Tatashin wrote:
>> > >> On Fri, Oct 23, 2026 at 9:50=E2=80=AFAM David Matlack <dmatlack@goo=
gle.com> wrote:
>> > >
>> > [...]
>> > >> The reason I care about keeping the header compact is that we are
>> > >> defining a foundational kernel ABI and want to use this header acro=
ss
>> > >> almost every serialized data structure so we can evolve them later
>> > >> without breaking compatibility. While some top-level structs are on
>> > >> sparse folios today, other serialized structs are tightly packed, a=
nd
>> > >> we are looking to add KHO slab support in the future where tightly
>> > >> packed allocations will be common.
>> > >
>> > > My intuition is we will have a small number of headers per preserved
>> > > file and per preserved FLB. One for the top-level struct and then
>> > > optionally a few more for sub-structs like arch-specific data. That =
is
>> > > why I am less worried 8 bytes per header, even if we fix the folio
>> > > problem.
>> > >
>> > > Maybe where our visions differ is when there are collections of
>> > > serialized structs, like KHO blocks. For collections I don't think t=
he
>> > > elements will each have their own headers. Otherwise the elements co=
uld
>> > > be different sizes.
>> >
>> > kho_block today doesn't store entry_size in the serialized payload. It
>> > relies on its caller to do so. With extensible structures, this can ge=
t
>> > messy. Sure, the owner of the kho_block_set can track the size somewhe=
re
>> > in its payload, but perhaps we should store the size in
>> > kho_block_header_ser to begin with?
>>=20
>> +1000
>>=20
>> KHO block should track the entry size automatically and not rely on
>> the caller. Otherwise every caller is going to have to store the entry
>> size in the struct that owns the KHO block, like I had to do in the
>> PCI v10 series :(
>
> I am fine with updating this as part of the versioning change so that we=
=20
> do not have to do it twice.
>
> Tarun, could you pelase include entry size change into the next version a=
s=20
> well?

Yes, This will be important to track the extensible serialized structure
across kernel. For example struct luo_session_ser has larger size in N+1
kernel which gets deserialized on the beginning of the boot so incoming
block_set must use entry_size of the kernel N which we can update inside
kho_block_set_restore(). And this updated incoming->block_set be used
for iterator in luo_session_deserialize to properly walk through
session_ser entries.

I will send v4 soon including this.

~Tarun

>
> Thanks,
> Pasha
>
>>=20
>> > Anyway, not a problem this series needs to solve, but something we
>> > should eventually do.

