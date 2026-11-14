Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C02BF606A88F
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HdRpK4pm
Received: by kanga.kvack.org (Postfix)
	id ABCCC6B00EF; Sat, 14 Nov 2026 12:35:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6EE66B05B0; Sat, 14 Nov 2026 12:35:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95CC96B05BE; Sat, 14 Nov 2026 12:35:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61C136B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:35:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4D4F1C3C10
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:35:51 +0000 (UTC)
X-FDA: 85434427302.16.8EFDC7F
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1E21940003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:35:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=HdRpK4pm;
	spf=pass (imf07.hostedemail.com: domain of 385v4agkKCGwdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=385v4agkKCGwdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794677750;
	b=ZuuEpeL+Anw6jVOcBNVnUzh7xQ+h73xfzZI+p02smBeZBE4pKSbsfvflsqC0dHcD2x0QzQ
	dKhE15jWMqwfKOQ4Wo214aff6Z+KW/G1mPX5b+lv0SOaJcg7RS+Wvp4Aw33u+CT7wW+d06
	qIo3tQAwWBKVRay5uKUl8txuM7K8PIw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=HdRpK4pm;
	spf=pass (imf07.hostedemail.com: domain of 385v4agkKCGwdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=385v4agkKCGwdKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794677750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JNaJcXdU6JL88Hplnr1u9aTEynknq2tK7kpa3hgYbA8=;
	b=Uyd1Sa8McHLsRI7M6TK74mL2i3Mkk5aTc5SzsB7scQ5DpTLxb8Q9AzFWyriP75eT3nqRj9
	KBqiKmEYV7+JuK8CRFUJBV3a38jl3iMLkOspG/jp18ZxczhUVD0Q2Bo6M8sLp1bYTR88k/
	p0heKhOwiacbv85QNqNqj7Z2Cx5ybQM=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c37b2763f1bso244877666b.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794677748; x=1795282548; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JNaJcXdU6JL88Hplnr1u9aTEynknq2tK7kpa3hgYbA8=;
        b=HdRpK4pmIhq9N5ktOqmrT8jgQJ3tlEQdYm7pAKYRht09u2wLLIAVUrlj1oFy/QSgmr
         I7gmcrlS3DKQhZ+U5LOfC0FskReYJ1fGoGQC+I1Gumer/HeILGrrYmSY0h89r6R9dIqQ
         C5jUADuxlqPQ40Qh29Awy3MkHVPSd17VBmnRuI1sDaGD8BdPG3kwV7Eio+somXK4LBT4
         ctWPHNrBhCnd5DHbHy/VlKz5wHh2jysJ2HGHxPL6kKNK8W1EV65gXXXCIK6tCBIqs/LX
         wI3eCabsePgFsmyMFNHjP1U2VlH9mRCnR8lMkObpr+9BIL1VTHOIekAQAQ2tAnlF9aa7
         BQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794677748; x=1795282548;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JNaJcXdU6JL88Hplnr1u9aTEynknq2tK7kpa3hgYbA8=;
        b=Y5S41ko2dhp3aHQzFUaA95/zZCmGKuM0WaYSbJimg+VmA+Z8AvTk2PgNPw7hq/UQrK
         s7/P1Sl/L7NhfeP16kTxtgtPMCO3iR+SZrNvAPc/mESHFCryCna2J7CTeWF1y1GyItTj
         5w4V89pYnesgdKkxom7Lw6LTktu2E2NX9NWWk1kgHwl0SWYDfVMmd+Jt5yRF25IOkBsM
         fIP6C7St6WDk0EzhW5byMyx+eIIn04BJ7xvBFn8NfeBaq41t6O5c4dwhDIqd96qk2svm
         K1vSYFkcuSheT1bIUEq6fZ9zexoi2a0JET2livvsOREB4ETC4EJE4RYPgLbORU63FYM7
         Hezg==
X-Forwarded-Encrypted: i=1; AL+hErE+gZWfjjtkyIoMQf9xzN0FyFbY4uc64Q4ipml/iymDY5LvMBM7/FXa1WeVSppsZhVwovbA6Ry46w==@kvack.org
X-Gm-Message-State: APuU4Z//20IgWX4omrdnc2Z8AtNYL52opjZ+Ps2v563ZTRUoNxs6Gjq5
	g4nWwSBdvkRQdB2hRJ40AGraT+lkrDiDTKSfRuanYTXuUKRydgizPw2rBjfFRER3K1fgMkI2w/W
	TYe/ndeO6yHSA7ExHqA==
X-Received: from ejfz7.prod.google.com ([2002:a17:906:ac7:b0:c2e:3202:ef75])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:868f:b0:c33:ae8b:817d with SMTP id a640c23a62f3a-c509654f9admr515384166b.46.1794677747981;
 Sat, 14 Nov 2026 09:35:47 -0800 (PST)
Date: Sat, 14 Nov 2026 17:35:47 +0000
In-Reply-To: <DMRO4QXXB8H4.127C1CPT3RZ18@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-17-tarunsahu@google.com>
 <DMRO4QXXB8H4.127C1CPT3RZ18@google.com>
Message-ID: <9huzmrrbpb7w.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 16/19] PCI: liveupdate: Add feature header to struct pci_dev_ser
From: tarunsahu@google.com
To: David Matlack <dmatlack@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1E21940003
X-Stat-Signature: o875xs75jiesrrsd6of3x7di46yfkq8a
X-Rspam-User: 
X-HE-Tag: 1794677749-259907
X-HE-Meta: U2FsdGVkX1/ppjeN+MX7L7koJUvI0t5scSrp+0x5D0nejDoV/BwEClqPZt0wznXt9UR66twCEicywFzi6veiifs5Mi1VMD1QdbJ3DY99dMWauBx/jvRAok0SxOJc/0lnwdJ+Wl1QKsMrEg9ROLPJJ69TN3jZrwllJrNMsJwmeraEgcujdSETwTORCgFrGsU6X9RuVVXervihATNatD+5hv1f0IWV10vm09EOOhBZX0ZyVDxFPG3Bob0plKjE4hsSlfBAQZoCbjApPYwv6BA6FlF2HDkOU+u6DOOgxfjRm2vst9v8rKHJ6h05GvDcqjvUIMtMNU4oZNIdsPZU6SMom+Qkk0FWEwdUHpAerI2RLH6nq2Ilcf73GdgC3l8qOBs5v+r1x0VxX8/vSaAxkXunqKlNbRNtJA49wPuEJkw/ABOU7rOotIJh4L7/BJS97VJjCA4gkbQkhEJmjMbFtDrSpNTIhR0+eTXYQBQzP60QhwuOLtvPe+hsty6o2d4p9mPJuskHnzxOzxTFYOx1F3jgjSdyKGjhoWkH2FdPfdRK7BfRYxleSVYoFspInycWX8lUlBPcp7dx3LFWwR6PFw5I9psTw9kcJVXfe2z4CUG1tFaIiS6untf8b82nwpAfWFebGaDwMs52/qNxJwkVJISkySoEUmihU3QRTF++KoAK8AhaTuv7z+SSEkeMDa3qaHtXwc0f4MhHVsxpypJ4btQcZ3WPtQQCWwVIdKwlGPY/GR6y1EviHbtqikS5Qtf3CFSpcBDqxFLvS3IiASHSPJ8092HbBRKVoPbtd+yXc7tufrDNGgdJwCRBmEjLo0cBniwUnS7DlOE0IYbHPeGH9mM7q7gGpvBY/G5SA46sbSrG+Saa2r+3GWTZqJUpXJY62qaNsDyhJiEWOAPZl+ZHbGNu99VbniA6HY8cKR++YFLSNRrQoltlKixJVAK+mXFMUCxj5abyHqAcQQ3Bo0Dkup1
 1GPrHJuW
 cvCbqqglvZTMkQi/O5moXsrnq/x8OQcDf7lzF6RNAwrefx/rG6gFwDP4EUtih558wvcZh2XcBG6dykL0ZLjQ+mxQOYePLRgCBkGmMx4vAlxZMu4/TQigIar8UuEty1k/6Z5nAN/WN20ekoPf7ajSrE+Ryv+iEmbFmW7cDK6cwn+Liu0cJTH9twnRmsglUJvk13e7bn753yceC++rPIw+A79uTbD8wt/3fTm0dEsarNelLrUdFpp07fg3+Z//H/isTyDQPKyVNHiyyNxJ5YsTVPk0Wk8YvNTPtgCGmhAGsE+VQDrV8dCzVDVIGfKgww73g7J+D5He9Qjy8NGvgxsb6FRO1yvdQ8FoqlgYzjsveNjY2gZWW/+oeOx/LjDKhQIdPQt2e2Wtim5q8RStUO+Otyno9HuK/fc4n9CDfC8ogi8jmI0KGKRCSLImScFSClE7V9cujnGycwtDycUVi5QmJVIPbI0p4ve4fgRomimYlMsNrCHJIMKlTZ+596e7StDxXFh08XvryCuMPWIFgrR+8Dxq52sraWMu0wv3b0/SUULrlpQZGoDk5ryrewy01NJZ7V8Hs/QXolQdeZyC1/XFS9C6LIPdGBI3SErrUSBiZSs5tUrn82FlPbcf/JFcBHt81ShfA7xKT6d5/zXdbbwoHl2+V2wfx8IPIQysXfqXg0EVWEPRMd7AdgHwU6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"David Matlack" <dmatlack@google.com> writes:

> On Tue Nov 10, 2026 at 5:01 AM UTC, Tarun Sahu wrote:
>> Precede each serialized PCI device entry in the PCI Live Update KHO block
>> set with struct kho_ser_hdr via DECLARE_KHO_SER so future per-device PCI
>> Live Update features can append fields to struct pci_dev_ser without
>> breaking compatibility between adjacent kernels.
>
> Elements of a collection should not have their own feature headers. This
> applies to patches 10, 12, 14, 16 and 18. I raised this during the v2
> discussion [1][2], but I don't think it was addressed.
>

As per [3], I tried to add feature header to all possible instances of
ser structs. Maybe this is the right time to audit these structs and decide
which one will never need feature header.

[3]: https://lore.kernel.org/kexec/CA+CK2bB9xoAWP0kC+KtXeDTdwt0kWqb-PLHN=6DsA=mnRpMfxA@mail.gmail.com/

> All entries in a KHO block set are written by the same kernel using the
> same struct, and the block set has a single entry_size, so every entry
> header is necessarily identical. They don't convey anything that the
> header of the struct that owns the collection can't. In this case,
> struct pci_ser's header can define features that describe fields in
> struct pci_dev_ser, and the PCI core checks them once before iterating.
> If a feature only applies to some devices, the field's value in each
> entry says whether that device uses it.
>

pci_dev_ser can be refrained from using kho_ser_hdr but not
memfd_luo_folio_ser.

The difference lies in their API usage. one use kho block and other one
kho_vmalloc. With kho block, we carry entry_size, so the parent
pci_ser's kho_ser_hdr can communicate about the new field/feature in the
pci_dev_ser and entry_size will carry correct the size of pci_dev_ser
for iterator on deserialization. But for memfd_luo_ser, kho_vmalloc does
not carry such entry_size. So we can solve this by adding the
folio_ser_size into memfd_luo_ser struct.

Without entry_size, we can only add new changes to such structs by
adding feature in parent struct with required = 1. That way rollback or
upgrade will fail to the kernel which does not support this required
feature. Incase, if we have entry_size (folio_ser_size in above
example), it will help marking such feature to be optional also and
deserialization can correctly parse with entry_size and can ignore those
changes if the kernel wants to.


> Per-entry headers also cost a lot for small entries. struct pci_dev_ser
> goes from 8 to 16 bytes, and to 24 bytes once the first feature is
> added. Patch 18 does the same for every preserved memfd folio, which for
> a large guest backed by 4K pages adds gigabytes of preserved metadata.
>

Yeah, we are carrying 8/16 byte of extra memory where every entry share
the same header. Which is a waste.

> They also add new ways to read out of bounds. kho_ser_payload() trusts
> nr_required/nr_optional in each entry, and nothing checks that the entry
> header plus payload fit within entry_size. In patches 14 and 18 the walk
> uses each entry's fhdr->size to find the next entry, so one bad header
> throws off every entry after it.

Bad feature header is not the reasoning here we should back this
requirement. A bad feature header already imply the deserialization is
compromised and hence accessing anything further is undefined. This
holds true for any struct with feature header.

>
> Instead I would keep struct pci_dev_ser as a plain struct, take the
> entry size from the KHO block header (patch 2), and in pci_flb_retrieve()
> check once that the entry size covers the base fields, plus the fields
> of any features set in struct pci_ser's header, e.g.:
>
> 	entry_size = kho_block_set_entry_size(&incoming->block_set);
> 	if (entry_size < offsetofend(struct pci_dev_ser, refcount))
> 		panic(...);
>
> That also restores the minimum entry size check that the v10 PCI series
> had with PCI_DEV_SER_MIN_SIZE, which this version drops.

offsetofend() is a good idea to replace PCI_DEV_SER_MIN_SIZE.

>
> [...]
>
>> -	kho_block_set_init(&incoming->block_set, sizeof(struct pci_dev_ser));
>> +	kho_block_set_init(&incoming->block_set, kho_ser_size(pci_dev_ser));
>
> This size is never used. kho_block_set_restore() overwrites it with the
> entry size recorded by the previous kernel. Passing this kernel's size
> here is misleading: pci_flb_retrieve() (and the LUO session/file restore
> paths) read as if they iterate incoming entries with the outgoing entry
> size, which would be a bug.
>
> Incoming block sets should not take an entry size at all.
> kho_block_set_restore() should initialize the block set itself from the
> incoming block headers, and the incoming paths should drop the
> kho_block_set_init() call.

Yes, We can avoid this dual initialization. kho_block_set_restore can
take care of it. Also once we will agree on having having
kho_block_set_ser to have entry_size which will be part of only
block[0], then we will not have to update the entry_size inside the loop
again and again and count_per_block can also be calculated before the
loop for block 0 and 1..N.

~Tarun
>
> [1] https://lore.kernel.org/kexec/atl6K2Juy6Bh29lh@google.com/
> [2] https://lore.kernel.org/kexec/at-8vkVpN2SF3XgB@google.com/

