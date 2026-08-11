Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09A73C5B574
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 08:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F106B007B; Tue, 11 Aug 2026 04:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0006B008A; Tue, 11 Aug 2026 04:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCE706B008C; Tue, 11 Aug 2026 04:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACE266B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:10:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4EC361A01B3
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:10:22 +0000 (UTC)
X-FDA: 85088266284.16.20644E0
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 799E14000E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:10:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PpH7CPSf;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786435820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kRDEH2ssIQhIkVPOR6PkKFR0aBPP8ALbaUyGO3LvVVE=;
	b=WAGhNGJcWRYbD20T1OwOBGw4T0ZYFRiXDfRqHqsUS1+wD3QLPJqGpwf9xQTZt3WdCRrxnX
	Xc2UZdcNa1sbG/7SlMfN0WFj6XsA/RTCggsl8hYTeMlk2W7jEuqXnoLg+LklQZVELiomi1
	+I4ns4xPmDO/RX7mNjZQqMg2OyKlNeQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PpH7CPSf;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786435820;
	b=JdHftiKsNCi7yZAIbrcLjt9/hDfgU49msWHtD4Um3lXxEtpTlV6i0Xb/7Mb3vPb2XoR5nY
	2v5zxaO+MXRxyfYusNWzxwofD6IZlW4wD/h2K6O73JLM3xzMu+wVcihzcHgdLejXbzScyj
	PJz7f6B9MyXQSEBmpyiS86kqfq+REOA=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so24444355e9.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786435819; x=1787040619; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kRDEH2ssIQhIkVPOR6PkKFR0aBPP8ALbaUyGO3LvVVE=;
        b=PpH7CPSfKwoPqXVbCayvIdxqoADAxlgJ7USo946+V6KclRyYouXSIyeqsxtDazkHc8
         QWLz16x8+bXxSQa6qVmG4S1XC7JLfDpem0V/1A/LRKejHswg07i+rGSPQs/AjLDUO51O
         djykiUF1An7f+eQXLSRJZmwy2D6y1wmnTkUJkAsKxbopKubcXN+t2JEr7tvyAZgaLpCJ
         HTRL55DXrMEKonrAORpwwsHwxK66GR+G44aPZ63Ni8z0Q8uZIdK2qH4L0au2dDJgy6Pz
         YaabRNLlK5Y/nIuT2AmteN06qkzbk4JKCedMHrPljmHHEfqzcrwdt6BElO2vvZc8X/fB
         /UMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786435819; x=1787040619;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kRDEH2ssIQhIkVPOR6PkKFR0aBPP8ALbaUyGO3LvVVE=;
        b=G36EED7rZzVwDX31eWI0Qw+MyVkNsBwy3z4nZpa1e4q0athIvLEIjlt6M3W8QqLEuj
         9vvc6dzDcbbCkRBMGPisE3lt0B4i+xhXQShe4pbXyQgWs9YFRdBU8Jrivvw8t3sX3QIG
         Hxc50/65wDy9q8ik9EbS1BIAyYKPw/3xV4PVftyVi73QFXP1SdrAxfObPHn4pJXaZpR6
         9/RK6M4hXFkr0k9HnD/GzWw6d07qx3y92TrVORGdDTiaDLmUs0sxEtfLx/LEPEBTIhb6
         UHd063Mo1BNpFwPFtfD2y129Pq4KkMnrjgFux8o7XgYBsOBbZurTUAZhp4tpFZpueABK
         5K0Q==
X-Forwarded-Encrypted: i=1; AHgh+Rr6KNHVMmV3oUSmGwCx7WuOFLVlK/zQAIbVu1eGgZ4uL1sz7SxuP3pSxRLYVdsG/l0dyPrdpfvjxQ==@kvack.org
X-Gm-Message-State: AOJu0Yz4V+2LWBd/DDiRkae4cwdGcXL+hLxoEjnUPF8ADNz7oPOfIlPV
	y6aK6by2hf+yF9GbnY9UDnspEF5e4xSGYt5JqxetyopWUv9lrFzxRuIj
X-Gm-Gg: AR+sD127ZqfWcMiYxP+8ziRtzJkMtO0PTjkvQskWu6bLz3mhdXduBHqy1LNpGZY7bsN
	0dZWjbXnV7+uAJ2BIGlld2sqH/zBQ3l/ECEsJK30firNb49fZ6VbslTPpEhuKIR5VhMajcW6OwH
	B3J9Qf/vzG9cSqrLbzB6/HXvVVqFM/zy6xv4+ej10nO/JO2GzGssxgYii5MynN8xn/IZN/lN+4A
	asbu3xgwAO1F8HJ4RFcuzY0wuS1I1072z/WWhmBusxjRRI3qEBowKaPjEAENh7SQ4a8N8kAbx5d
	qMQOM0FHLmkeSEPZ6db2G774dqfge7+LdR97zBz+tv5cvnqovkxhV4YfQPodhPFpQcf9qVl+oko
	6kIexnp/d3AWHAl0MfcWie5/AqPeaHQ5NT6IcGbX6BEqLs1eHnZjht92sLXnDld7EmGevjviMeK
	GztP8kkE0us5oF9IErq1JkBmBTxkrcMALHxzY0ReII6qDfrBcxThz7LfkG5/gh02EzZxaxI6B6g
	npci4cqiwejE9QwPmuO868sx4H8gRbt4dQ=
X-Received: by 2002:a05:600c:821b:b0:499:6a92:fff1 with SMTP id 5b1f17b1804b1-4997847e9b5mr25827975e9.18.1786435818734;
        Tue, 11 Aug 2026 01:10:18 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a5ac6e6sm2454288f8f.6.2026.08.11.01.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 01:10:18 -0700 (PDT)
Date: Tue, 11 Aug 2026 09:10:16 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Kevin Brodsky
 <kevin.brodsky@arm.com>, linux-mm@kvack.org, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Ryan Roberts
 <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, Huacai Chen
 <chenhuacai@kernel.org>, loongarch@lists.linux.dev, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, Paul
 Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, Richard
 Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, linux-um@lists.infradead.org, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
 <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, x86@kernel.org,
 tboot-devel@lists.sourceforge.net, Ard Biesheuvel <ardb@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, Vishal
 Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 03/22] mm: introduce MMF_KERNEL flag and set it for
 init_mm
Message-ID: <20260811091016.5ca67143@pumpkin>
In-Reply-To: <33fc9d31-2866-4315-9510-0004deb93994@kernel.org>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
	<20260714-remove_pgtable_cdtor-v1-3-44be8a7685d7@arm.com>
	<01f07ea2-8bdd-4450-8a49-548f8b646cfd@kernel.org>
	<33fc9d31-2866-4315-9510-0004deb93994@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 799E14000E
X-Stat-Signature: rcsmpkg4oakge85nr83zk3dm6wdot5ew
X-HE-Tag: 1786435820-77802
X-HE-Meta: U2FsdGVkX187l5qumUm6aPGdLZrx2Fp+UVc/ThKW/St3hlimPdZfYkS2pK0KZgMpjntudIQZJ28mwKQiDTWhhjjrGmuIz4Tbjd4ZVH/tH8oHERvSheM2jW2TAjMi9tHtj8VprgqybJTkEh9pxH1UNUwRmoW3TW4viYpe5r0NC57kKRKKkY2JXMR07Pm/OSUy8/yxEtJG0M1vws80O//EcDcgoSsGCgz1qnso553pQcsxkGDpAeO4yGlZL124tmBFGO4lNudLzoPhsJUFNjRA//OeoMXeWsyIpaHOmG+N3n4Y7ktgcsMJ8rB1YZNU7dUHZRPcRIo6ROfsT2a+L3eC79gOX1Ko/XG+TqxjmgYSrevu45YxbFE2tORj/B/rWpF0breqmiHtU9s6HM8zeuNe0W80LUs+O9Cdr3QID0WrPVD8lFYva5Cmw/i2CCNOi68RYHpKGFfjgBwmx3Y90AtoAXgDWvI6i+dNfHCVu677QsZjAwVFIJrWQLkFhA6vC2Y4nUwvUKeALGO73uiZ7DC3yP60oVJlyS3CRDyxVm9Zcwn7zKU3EVksRXGOHjXRvXpjijyY2wLBvBAYxWATSbCLTDcn8ftkeis2NsKwuV58aoaYsmH63HOHmoakjFjEZ743mOJx2hcnM45Oc2BFeDFOQxX9jF1E9yI9FTVYgwRVTJzX/hpX1khj+mGL7s6aIoE0fYeNLszMoYgaxQHUvNnyR2iZ8z7gHdDbNkvxRXAdsHPEt8cZU92kMvGi45rP4ZpuLsvmYL5Cz68MAO4h5CwLRP0sMth/zE+EkF7WS6lcLDqNcl/boSlJUVOXLqCaBvB9tFYt8EMKdsKZiXJT93OaIQFIgWx94pXmrczHR2DFbvf4lFWfm9OLpoiVSbSgVG03FKsBbjUogjq2+kLf0n/0+dx5W3bfng+qqfx5QIHwrzAaLvbRQWwKuja2ORTSwqAHwaWDTV7OXkAQYtYQHuE
 k1ERXbPW
 rZR9MLsBFOSiJJV2zxPSdyw4SZbP7ln8qEDMH2VonaKyRuEkdTwMHnJn1BiWE8DhYFo1LC0DBZv3ZTkrTR6FJSrh8u5+bOmGlnAdceUQoqIzKbCov6h4+rXWdDh7KzmJnCwmW24h4UwgaqhyyMNk3s602Ej6ZImdvQi/qqQ0d15kL9Iaf2kURr8Snx+jZpcwyz5G2AnXOro0KdGBqFGX0SDdMxLqs+4V5qCNYLyf9khsavIWp07MO0C7/CTqu8pzMktgBwJNraWfW6zLDVUqgKzVSgerxEpXIsLAKLMYa9dKzdv0SPSHgFIni4x/OQjagw2O7gtVr+zS6171rFJhINHdH2xSCVayptJAjdTKBMD3Ljg/mfjjBJICUiBWX3sSeNLB00OmXXkOXDrEKOugRtJ73L9ImkW9wnynhQp9dcPb5+VUj4eSJER/Fmcj//EPa0NA8GVBRo+yO/y79kBKPjDRcF7Ndrix43OjlJJPZrjjWdZo2aBjU0vuHIY6P9LDI065Ap6ay+tdITzojDSrPVjyLcrQCNz+O+CamNrB+XuWY47SWoBJcAEdllciloOVpeiOmUKeNIl56iEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 5 Aug 2026 14:07:01 +0200
"David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 8/3/26 15:59, Christophe Leroy (CS GROUP) wrote:
> >=20
> >=20
> > Le 14/07/2026 =C3=A0 16:03, Kevin Brodsky a =C3=A9crit=C2=A0: =20
> >> mm code often needs to know whether some mm represents a kernel or
> >> user address space. This is currently done by comparing the mm
> >> pointer with &init_mm; besides not being particularly elegant, this
> >> ignores the fact that other mm's (e.g. efi_mm) may also represent
> >> parts of the kernel address space.
> >>
> >> Introduce a new mm flag MMF_KERNEL and set it for init_mm.
> >> Subsequent patches will use this flag to replace comparisons with
> >> &init_mm. No functional change is introduced for now. =20
> >=20
> > Did you consider performance impact ? This test is usually done in quite
> > critical memory handling functions.
> >=20
> > init_mm is known at link time. Before your patch 08/22 there is just a
> > comparison of mm (r3) with a constant (loaded in r10):
> >=20
> > c0014048 <assert_pte_locked>:
> > c0014048:=C2=A0=C2=A0=C2=A0 3d 40 c1 09=C2=A0=C2=A0=C2=A0=C2=A0 lis=C2=
=A0=C2=A0=C2=A0=C2=A0 r10,-16119
> > c001404c:=C2=A0=C2=A0=C2=A0 39 4a 03 98=C2=A0=C2=A0=C2=A0=C2=A0 addi=C2=
=A0=C2=A0=C2=A0 r10,r10,920
> > c0014050:=C2=A0=C2=A0=C2=A0 7c 03 50 00=C2=A0=C2=A0=C2=A0=C2=A0 cmpw=C2=
=A0=C2=A0=C2=A0 r3,r10
> > c0014054:=C2=A0=C2=A0=C2=A0 4d 82 00 20=C2=A0=C2=A0=C2=A0=C2=A0 beqlr
> > ...
> >=20
> > After patch 08/22 we have, it first checks that mm is not 0, then it lo=
ads the
> > word located at mm+528 then AND it with 0x1. This load might be costly.
> >=20
> > c0014048 <assert_pte_locked>:
> > c0014048:=C2=A0=C2=A0=C2=A0 2c 03 00 00=C2=A0=C2=A0=C2=A0=C2=A0 cmpwi=
=C2=A0=C2=A0 r3,0
> > c001404c:=C2=A0=C2=A0=C2=A0 7c 85 23 78=C2=A0=C2=A0=C2=A0=C2=A0 mr=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 r5,r4
> > c0014050:=C2=A0=C2=A0=C2=A0 41 82 00 10=C2=A0=C2=A0=C2=A0=C2=A0 beq=C2=
=A0=C2=A0=C2=A0=C2=A0 c0014060 <assert_pte_locked+0x18>
> > c0014054:=C2=A0=C2=A0=C2=A0 81 23 02 10=C2=A0=C2=A0=C2=A0=C2=A0 lwz=C2=
=A0=C2=A0=C2=A0=C2=A0 r9,528(r3)
> > c0014058:=C2=A0=C2=A0=C2=A0 71 29 00 01=C2=A0=C2=A0=C2=A0=C2=A0 andi.=
=C2=A0=C2=A0 r9,r9,1
> > c001405c:=C2=A0=C2=A0=C2=A0 4c 82 00 20=C2=A0=C2=A0=C2=A0=C2=A0 bnelr =
=20
>=20
> Is that a real problem, though?

The cost of the read is likely to matter most if the branch gets mispredict=
ed.
I'd also guess the mm isn't usually NULL - so that branch needs to statical=
ly
predicted correctly as well.
I'd also not assume that the mm is in the cache (unless the surrounding code
has already accessed it), the L1 data caches are small.

	David


>=20
> What we could do is to just keep the =3D=3D &init_mm check internally on =
configs
> where we know that there is only a single such MM context.
>=20
> Just a thought.
>=20


