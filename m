Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF554CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 16:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF9106B0088; Tue, 29 Sep 2026 12:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD12B6B008A; Tue, 29 Sep 2026 12:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BFFD6B008C; Tue, 29 Sep 2026 12:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42A756B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 12:17:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0179C160591
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:17:40 +0000 (UTC)
X-FDA: 85267305522.26.CAFEEE2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 17CA240008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:17:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kBTGQCOe;
	spf=none (imf07.hostedemail.com: domain of BATV+53b7e1604e29dec6b0a2+8437+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+53b7e1604e29dec6b0a2+8437+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790698659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16rZ9cmL9mS+OyjMzS8D7Rqdw5c8ZrqdHCwu6yoLges=;
	b=g3XhkK2MN29MvjYgex/QM6PL5Pu+O2byxCVpH32z8GR+WJDqszMFHPHP6sx5/LimzB0S3L
	a5PcK4MDp6HeOqutqQCthxavB2DO5nyI5TFC1urnPoQjWiWVM6OI2qYX513P+B3rJEFLo8
	UftEWLVXhPcurwYjgCK1RIguAZggnPI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790698659;
	b=k3QEn/Y08+I8CHjxJZVO7ERuH9fkwPjPPcsFDwVdn2doqVTyP4GbvzcY/iKulTvwyoknqY
	9pd0jhCnNPUoDFOBTAAeTB4Wu9a25wao9gYst2WU3yB42sLTyNtb4sgTHq59b1s9J07LRc
	VIjla4uUkNmU0e7XwEof2mI0fj9YNfw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kBTGQCOe;
	spf=none (imf07.hostedemail.com: domain of BATV+53b7e1604e29dec6b0a2+8437+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+53b7e1604e29dec6b0a2+8437+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=16rZ9cmL9mS+OyjMzS8D7Rqdw5c8ZrqdHCwu6yoLges=; b=kBTGQCOe2fiRbkzi4EoFZ94F9p
	yQjRXRpXycydzShlt+DEs4/5WJU0XxdMSy9E0mr0abhe6iekXQkYFLyJKPW3VRkyoQ7sIRbHidwy7
	0BzJBg9Zk0cf+0i16oVVu7rpInPEzc6qttgKd30042GTXFUc1mo5p+M2HHo3c3M64pXoWkso4jcCJ
	n3b/we4rPT3Y3S5Wz/SyTCUacGk9isP1klvsfVDF043MXF1OjynZVKvXslumJbWWunzQvX5IXtp+e
	1SxYuAtYvUpwWd9eak40GRnLOJg+Rernmh6/Q3TKA9s/Gh2wSZYtd+wWfuf4/MqeI/JzNwAHQCsOa
	252mKFqA==;
Received: from 54-240-197-238.amazon.com ([54.240.197.238] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xBaVw-0000000Ez6m-3WZp;
	Tue, 29 Sep 2026 16:17:08 +0000
Message-ID: <ecab388213245df81815e42246db3b13b2d43e2b.camel@infradead.org>
Subject: Re: [PATCH RFC 00/17] Allow guest_memfd to be created using a
 resource (pool) fd
From: David Woodhouse <dwmw2@infradead.org>
To: Ackerley Tng <ackerleytng@google.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton
 <akpm@linux-foundation.org>, Sean Christopherson <seanjc@google.com>, Paolo
 Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@kernel.org>, 
 Jonathan Corbet	 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap	 <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>,
 vannapurve@google.com, 	erdemaktas@google.com, jxgao@google.com,
 rientjes@google.com, fvdl@google.com, 	jthoughton@google.com,
 tarunsahu@google.com, pratyush@kernel.org, 	fuad.tabba@linux.dev, Gregory
 Price <gourry@gourry.net>, yan.y.zhao@intel.com, 	michael.roth@amd.com,
 suzuki.poulose@arm.com, Christian Brauner	 <brauner@kernel.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, Nicolin Chen	 <nicolinc@nvidia.com>, Xu Yilun
 <yilun.xu@linux.intel.com>, aik@amd.com, 	aneesh.kumar@kernel.org,
 Vlastimil Babka <vbabka@kernel.org>, Connor Williamson	
 <connordw@amazon.co.uk>, Fred Griffoul <fgriffo@amazon.co.uk>
Cc: kernel-team@android.com, kernel-team@meta.com,
 linux-kernel@vger.kernel.org, 	linux-mm@kvack.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, 	linux-kselftest@vger.kernel.org
Date: Tue, 29 Sep 2026 17:17:06 +0100
In-Reply-To: <CAEvNRgGw_RjiGs_bbVnoRAvq49Qukm4h8XhkBd0DXxn1ZzLrQg@mail.gmail.com>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
	 <d599627270c67a5334d2abced75d1d1711fb0af0.camel@infradead.org>
	 <CAEvNRgGw_RjiGs_bbVnoRAvq49Qukm4h8XhkBd0DXxn1ZzLrQg@mail.gmail.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-jELRnwkCgenL5SAUxJqB"
User-Agent: Evolution 3.62.0-0ubuntu1~ppa1~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 17CA240008
X-Stat-Signature: ofqjng1uyw9k1otiieet1jznb3eowhci
X-HE-Tag: 1790698657-591018
X-HE-Meta: U2FsdGVkX1/uxBD20Ft7Rp4puW2MbGnFXhHScIdkRaLTR4jzRwx/AapJKyTVYJ5aQDeDqYzgTxtT6TjiOnDdPIZmyzkDvXn6hqBzOqFauMfyXEX2HTEUlm5Ztmc873sZqnWs8TFJY/LImQEaSeppBsTb40wyQh8EyXAcaZxomZa2tWxUl6yR0j4R1RmNHMQKQKZGfJRRfpC7rlnDsW2OEdRG8uk5LJmdbAs4RrW60k+yG07Qxpu1Xy31Yfl8/SpsKSOlJ2G3UZYzCfXqV7pG2hx56BwLQeEUGUeGx+paprmiQhIWZwVsm0UGt7y4HkP1SyFfvURXSsR5Bc5Q0KKEXgWUAd3KJteJtdj7BYplPGUhNvf5W7ZukfKa+hNaw5+7m3peDRpkv+nPOvpyEWLrFFYkXr+RI/Vc/qDQC+ZSDoFSjt9PqlvU3P+1UlwxVBGDcywZVSiOhdAaPhBbyvsdiXdg6kxDt4tCBvputGZAw2Oi4vmrckH3oAnDqBKg24E1mTKB+tHpmSFiH9k2WWgIMJCLtk5EAJe7784FfPLzUQQw8CuMTUoE6Ttc7y4msNGZjD75MSsjSrP0IB06a+fwW+OdSVe7gPDBefnHjWHyvql1N+YlmfBzYMV+dqZiklXbBndCvLFuBIHfAK3olZlR6gtklounCX5NWkSMDXAAcatomL6AdCPyaYgQN4/jAr+KTk96j9ZthRirpA29QzQ9NZBgBWGWfY20+UGoY9SZkGq0oKbaYIbGB05PPjlx206hd/hPtkuosMxMyFc/1+kab7b5uoVXoDLHOpsufjulklgnJf7HckL7Sm2iZF+wwvbMnDSj6svNoxBFX56X5h4LAJrnMqO8949htu3Kg9XIuxQgp6JH4Zk0Q1sIRCJnEEZ2BQ7wMkoKfmTftgT2G5OHrZ6qkWbgC1FwumsUYK7KKNs5GUpUikyHfAyGFwH6JYy47TJdqVBOOegOZcI/NxH
 IHq6zDwl
 JXgiIZeBzwCiXsMlZVU836j/pL2dnOT3a2rJjljg7T2M+CP+Ulz+6tafZcgEXhNURU3j5DO4TaMgOBGWHoJdDqXjtDE05n5jzx4V8w2ysx6oI7yj156G6YKXqVdHLVfJAYtFQaIl5gM4++4YSnFbcpb83dFsIglTlrp0Bia0hiDlanoIvQwjh+I7zYcgVD17TVSrVPIneT9PRWwIxLeTGYkU3j4Ugm7HGSxaNhWQfzMLpRIruDPxAku0t4XWjq+69F8YXQEMQE1PyaSlDjyCrDnnDvyhTT5a/ZWTUxZQh6wj07ZIx6Kv8QLOFu37xkT4GBcHr2tEK3KKD9jRRdtwe/Skf2Rw9dDwNU4IvC4uFWz2Co19ooxvkR7b0nkBPLeosIx8JgwS3vunRttkhzKu25NyP4cGPBhqt+UKUvFopLUch9U1zriNHPMMwHVMBtYvK1Zyo882z3O3arX0IFnPIOizMpAPJz3GjYTfKYxY2Kio0V0n57RhHYJ9IbecadqsgNs+NoZI3rt/5ctLMYFJwd0MQ9yvdjSZpj4M58IOCWSO3ONo2N6/eeFG1kGqNeiQl7KDNAJUF9cryye7KCWhdPJsFOSoahZd5HolkWPFNI4vh2GSfcBkI4aFbUGc9Bfv964VuyxuQ1XiH68eTk6qzwC6n66JGxM/0lBjV3kQrdCQZIYUugUa9tDED26dCpyXxUEjHyt1WvoeVfg2hPeWOr1mtiwC3Sp5Q6SXw+VfbVlHvqhoDibgkZP1J7TtZaxPYsRVZgaGeP+fltF1v7xt8ZforJ2l4Hkwt/tpjKp9up2tNS1p3DAsea+qMvfBDrafXadUjjDZiZXtgmY3Ely/8HPg7/HHizfPU0mC4+koRq6keyx8laTf8WiP6rin/Sd3dfZ5XMnRP0cNPb69q8Wejt3HZcVZb1qaPmXDFaW0xXut9BYpoGZhj22bQodzZFIAod2psn2B9TdfPfurT1auVzk3EUa7Y
 h4WXHmzQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-jELRnwkCgenL5SAUxJqB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-09-28 at 15:59 -0700, Ackerley Tng wrote:
> David Woodhouse <dwmw2@infradead.org> writes:
>=20
> > On Fri, 2026-09-25 at 17:50 -0700, Ackerley Tng via B4 Relay wrote:
> > >=20
> > > =3D=3D=3D What if my provider doesn't deal with pages?
> > >=20
> > > Frank and David Woodhouse [2] have use cases for providers that use
> > > PFNs, and this is definitely something a generic interface must
> > > support.
> > >=20
> > > Here are some options I can think of:
> > >=20
> > > 1. Don't define .alloc_folio(), instead define .alloc_pfn()
> > > 2. Refactor .alloc_folio() to .alloc_pfn()
> > >=20
> > > Either way, I think guest_memfd should still be the primary manager o=
f
> > > the memory.
> >=20
> > Thanks for working on this.
> >=20
>=20
> Thanks for the quick reply!
>=20
> > I'm not sure what you mean by 'primary manager' here but my use case is
>=20
> Naming is hard! See comment on revocation below.
>=20
> > for the provider to be the ultimate arbiter of who owns which PFN, and
> > revocation of the same. Think of it like a filesystem backed by
> > external memory. Each guest's memory is a file, and a guest can
> > *donate* specific pages of its memory to other guests (which in the
>=20
> Putting donation aside first - I don't have a good picture of how a
> guest would tell the host that it's willing to share a page - can't
> comment. Would love to find out more.
>
> > context of the *interface* only means that we need revocation).

That's implementation-specific. Think of things like Nitro Enclaves
where a guest 'donates' its memory back to the hypervisor to be used by
another microvm. But that interface isn't the guest_memfd concern; as I
said, in the context of the guest_memfd interface, there is only
revocation: that page went away, whatever the reason.

> Going with this revocation part, beginning with a more basic use case:
> I'm thinking that the provider can notify guest_memfd that the page or
> PFN is going away.

Right. That part I have working in what I was posting.
https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dcommitdiff;h=3Dee9=
5ed5aaf06

> guest_memfd cannot say no, but it does have to tell KVM to zap the page
> from stage 2, and for CoCo it may need to do more stuff.
>
> The notification needs some pointer, so I was thinking that on .attach()
> the provider would also note down which guest_memfd instance the
> provider should notify.
>
> The notifier could tell guest_memfd that some (offset, size) is going
> away, and breaking down mappings in the EPT/NPT should be something
> guest_memfd tells KVM to do, I think. Are you thinking that the provider
> would directly break the mappings down in the EPT/NPT?

I think telling KVM is the right thing to do.

> Does this notification mechanism work for you? IIUC regular DAX would
> need it too, like if the device is unplugged for example.

Sure. As long as it works and efficiently covers everyone's use cases,
I'm not going to be overly opinionated a priori about *how* it works.

All such bets are off once we see the code, of course :)

> > Should I be trying to rework parts of my series to live on top of this?
>=20
> I hope to gather more feedback at LPC. It'd be nice to get early
> feedback if you think it can work for you! The overall design still
> needs feedback though, don't take this as the final direction.
>=20
> > Things I have working but which I don't see here include:
> >=20
>=20
> This sounds like 4 or more different features! I think they do work with
> this resource fd proposal.
>=20
> > =C2=A0=E2=80=A2 PFN support (which you mentioned).
>=20
> Yup, guest_memfd needs some way to track PFNs in addition to folios. I
> think for tracking we can reference DAX, the part I haven't looked at is
> how to let guest_memfd handle events. Like if there's memory failure on
> a PFN, how do we let guest_memfd handle it?

Telling the guest about correctable and uncorrectable errors, you mean?
I would have thought that's up to the VMM, until the point where (see
revocation)?

> guest_memfd needs to at least be notified, so that it can handle the KVM
> stuff: zapping and special stuff for CoCo. Whether the provider or
> guest_memfd gets to handle it first can be worked out :)
>=20
> > =C2=A0=E2=80=A2 IOMMUFD support via dma-buf.
>=20
> Is this about having guest_memfd work with dmabuf fds?

It's about having the provider of memory (again, think of it as a daxfs
if you will) able to tell *both* KVM and IOMMU which pages are where =E2=80=
=94
and revoke them at will.

The *implementation* involved dmabuf fds, and we already discussed
which wraps which, on the first posting of my series. But maybe we'll
conclude that the right answer is for IOMMUFD to recognise this
guest_memfd 'provider' as a first-class citizen, and we won't need to
masquerade as dmabuf?

> Fuad also brought up that Android uses dmabuf as an interface for CMA
> memory. [3] IIUC the dmabuf fd is mmap()ed, then the userspace address
> is set up in a memslot for the guest. To make this CMA memory
> CoCo-friendly, we want to use it with guest_memfd.
>=20
> Jason response was that guest_memfd should probably just directly get
> memory from CMA [3].
>=20
> I'm not super familiar with CMA or dmabufs, would either have a suitable
> "resource fd" to pass to guest_memfd like how HugeTLBfs has a mount fd?
> The "resource fd" should ideally have no way to mmap or read/write the
> memory directly.
>=20
> [3] https://lore.kernel.org/all/CA+EHjTxZ0N3Tfnid404B4tkb_E+Z8mODTHTgBPiF=
6=3DbwZp7Hjw@mail.gmail.com/

I think where the memory comes *from* is an implementation detail for
the provider. It provides a PFN (or folio, if you must). All else is
not the business of KVM or IOMMUFD.

> Or is this about letting IOMMUFD get pages to map in IOMMU page tables
> via an fd+offset instead of via mmap()-ed userspace addresses as in
> IOMMU_IOAS_MAP_FILE, and that guest_memfd isn't a supported kind of fd
> (yet)?
>=20
> I think guest_memfd should support IOMMU_IOAS_MAP_FILE. One use case is
> Confidential IO [4], where SNP would need to have private memory
> (guest_memfd) mapped in the IO page tables.

Right, I think that's what I meant with 'first class citizen' above?

> The missing parts here are that guest_memfd and iommufd need to
> cooperate for conversions (or some other coordination in userspace). If
> private memory gets converted to shared, iommufd needs to know to remap
> the pages as shared in the IO page tables.
>=20
> [4] https://lore.kernel.org/all/20260225075211.3353194-1-aik@amd.com/
>=20
> > =C2=A0=E2=80=A2 Revocation (which I've tested correctly breaks down lar=
ge pages in
> > =C2=A0=C2=A0 both EPT/NPT and IOMMU).
>=20
> See above.
>=20
> > =C2=A0=E2=80=A2 AsyncPF support for pages requested by KVM.
>=20
> Is this kind of orthogonal? IIUC today KVM MMU handles the async-ness.
> KVM MMU checks that the page is not there, then since async was
> configured, KVM tells the guest to schedule in something else.
>=20
> guest_memfd doesn't have support for async #PFs now. I imagine it would
> be something like KVM MMU firing off a kvm_gmem_get_pfn() request
> asynchronously, and then guest_memfd gets the page or PFN and inserts it
> in guest_memfd filemap, and then notifies KVM MMU?
>=20
> Within kvm_gmem_get_pfn(), guest_memfd should get the page or PFN from
> the provider.
>=20
> I think it's orthogonal because guest_memfd could
> have gotten a PAGE_SIZE page (existing functionality) or gotten a page
> from the provider.

Kind of, but I'm focusing on the guest_memfd provider interface, and
that needs to support the asychronous mode: asked for a PFN for a given
guest address, it returns -EAGAIN and then provides it later, and the
guest gets the right asyncpf behaviour:
https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dcommitdiff;h=3D894=
dd0fcb34f

--=-jELRnwkCgenL5SAUxJqB
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCE8Ew
ggWvMIIEl6ADAgECAhANkOKMSmGXhF5eMl0rsRhvMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBHMjAeFw0yNDAzMTMwMDAwMDBaFw0zNDAz
MTIyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UE
AxMxRGlnaUNlcnQgQXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTCCAiIw
DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOfSIeC0vv1xPQ+dgSxbIIrkaru6skAWJYaGFzmv
q4Kq+2wU2jxhcWlJg/JeP5jEkq/LM3pn5aaLao79j+XRmS7J1ZpJKUODJVoM4s9MQJhTMvo4qS5Z
S64g6QR7Obkz3I1Lr3aWeSBmDDEyzue+NKtuWZ1Cxy3RdXo/w5HgRc3l2AercOM3Gt1XonTzEtTb
Z/Hwc0Sn9Gz8RmGRK6Ka4hVDl8q/2l110KaV233Kh5etP0csXS8MIMdVRfRu3sc5hp13DG7lCKzK
72a2GEpI8Wpl26G6I1/LMzz/98T+FqjTqxsdquk7Cj7m2vKGLW1BorpQH7WFGPdJQXJe1hfbfiZA
CcVdCtl4nAacFacmsiArZBfX7AQGL7isvHUwwYFEtcApyGW4p2Lt+t8nvU0CANA6BHOpOz1xOP8W
mAESbUriIjyuTUf3fJ9oDNCurVqhASMJCDaWI3lYX/QAoiAzt6akqbbZxo2ujW7mGGqc0KxqE2cs
h2T79v7pC8aUtHBfwNrTR19GnZVxE0eQ7ViIQhR6mpSaUQFA9sG+cmD2G8TnCgYsLa0q8De6F61a
CBevQGHNzrbZ3JAMneveYg/Jy1XxQHDRcvrMfWKe0jjcWbdKYlaGVPm5V1ILwYz7Yv5ewo3NUrxI
GJiywe9qPhuJSDZs7VehTuI0FxGIsgKzVjgbAgMBAAGjggFcMIIBWDASBgNVHRMBAf8ECDAGAQH/
AgEAMB0GA1UdDgQWBBT3m6JO05fF9DQPQw6Bhc6RkzKv+TAfBgNVHSMEGDAWgBTOw0q5mVXyuNtg
v6l+vVa1lzan1jAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMG
CCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURS
b290RzIuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdp
Q2VydEFzc3VyZWRJRFJvb3RHMi5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUA
A4IBAQA+b8Uw53sDspdZgukU+qzLyyHkcjlxGGhHlP+zrmDLKm1wEFvCRS2pili3Hy67i8N4N5NU
vw5Rg6kv3lxb9S9Rktxk43k+tvm68pl7OxQE55ZjVY87P0lUPGwEqOOwLLyH02ZQcsfq5p5LrOH9
0JvmvZ1yy73HS+VpDAqOlytE0NSvTIRqFFkKQGQwfjvtql9YflujuNNvJztjBaHKYZsnNSg+J38o
jYq4TP3pSg3UdVH0PncVjPQyqxC9xef5Xae92Kbkzol3x7Nel3A1bwAkalrDMspvTHvey6LfiBks
FIqviTnoy7fgjaRAJgHS+RXx/cmuRd3rUAclSVVrYu8RMIIHAzCCBOugAwIBAgIQAzUotrsybJHx
HTjKOIVdIDANBgkqhkiG9w0BAQsFADBiMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQs
IEluYy4xOjA4BgNVBAMTMURpZ2lDZXJ0IEFzc3VyZWQgRzIgU01JTUUgUlNBNDA5NiBTSEEzODQg
MjAyNCBDQTEwHhcNMjYwNzE4MDAwMDAwWhcNMjgwMTA0MjM1OTU5WjAeMRwwGgYDVQQDDBNkd213
MkBpbmZyYWRlYWQub3JnMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA2pYux73kdbYX
sWF8f1u6DJP91qcqaZetsyfPkZk0B+MmXmAEv0kVes5n15V2mbDThOnpoPFly0UugQO9JYqLfrtD
tKD5yL58fgrDB9Dw+LQikgrHafl6YSCds5AvUu/8hw2J6noKrcOLJpKlKn9Fl/4IB9Q3JIdLx5aa
EtTqMalIPqHFOlgrJ7s+aua8xbB8YQ9ahqYBXWRJNv3P/2b1DYtdrz1oqZPE3CcB8Pc6Gf2a1Tcm
6TAgtEx7Cf1BFcrsrMz7TWHmGQITieNb2r9UYWSc2Gp+GtYFNJCgT0JJXKUBIauPMKBLteYrL8Fo
ff/uY44dC/mDWjdCP/5x0qelPQjlBvWdHL5zvBTOj06rJ0m3HNI/hnIcDh0Qu2j9reb9rLVcdym6
bWmBM4uDEB8Zv9Ph0KTBFSy1IosyakuD1j1Os30EzjGfbi0EUXIvnOcYbTBAbM5UAzrxEHMhBvoX
Pvnx+OyvjJmc9tWxTX6AcSz+m40esbT17URBeZS18afgieiikm5TynlUYP1LciR3hSgGVzvGXnKO
02VDFR5itGWdRKZ2W5wIShNfWfhSa0D0K5UdIDt5Qc7sjzwK1Yb1sY5Tu0uA5mhIS82q1ov83uxB
sFkriNnhGv/M1NCDVLBiOMsHu73qUM+yKmgKLwF9Hfn9WI25glbAMI4S5r3hYzcCAwEAAaOCAfcw
ggHzMB8GA1UdIwQYMBaAFPebok7Tl8X0NA9DDoGFzpGTMq/5MB0GA1UdDgQWBBRcYhqbcGzn1jrT
JOZaB8O7qllDpzAwBgNVHREEKTAngRNkd213MkBpbmZyYWRlYWQub3JngRBkYXZpZEB3b29kaG91
LnNlMBQGA1UdIAQNMAswCQYHZ4EMAQUBAjAOBgNVHQ8BAf8EBAMCBeAwHQYDVR0lBBYwFAYIKwYB
BQUHAwIGCCsGAQUFBwMEMIGpBgNVHR8EgaEwgZ4wTaBLoEmGR2h0dHA6Ly9jcmwzLmRpZ2ljZXJ0
LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsME2gS6BJ
hkdodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZT
SEEzODQyMDI0Q0ExLmNybDCBjQYIKwYBBQUHAQEEgYAwfjAkBggrBgEFBQcwAYYYaHR0cDovL29j
c3AuZGlnaWNlcnQuY29tMFYGCCsGAQUFBzAChkpodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20v
RGlnaUNlcnRBc3N1cmVkRzJTTUlNRVJTQTQwOTZTSEEzODQyMDI0Q0ExLmNydDANBgkqhkiG9w0B
AQsFAAOCAgEAocabrh1cPd5s3vY5rnlBVQSTc7zs2ZWs67dAIltR+05WELrYClVzzUhMs/LOJPlr
EUo45UDDomXq38DxFepaPd9+iNLjXfn33EX/IG44j04lU/oF/Rg9VeQILkYLbCZ/x9wOjNHZc4SN
ydY7Dhvf/sT5aBz88u7D5+azZJ7Qf1U57wYseCH1Mt0nDrtr5y19IJ8D9xJJ33RFL6vfpHZBBAQ8
+3RqkKNxLoV2aFvQhxdhjNLDqTv3LjUIdicwPraN7JkxEu7CV2Lka7eRqJgkWL7SK0YmBjGpRafs
+icP/ON5RCCKTTb6VlX8eTG2sJJfsFhvJNCCt6xexbWzWtIrfP7NvPBvwBB737AyEGBZkS5aNizT
McURJGTv9UKvBh1LF/+tNhYtLvPCN7oecGzhCHht9jcwSkygTo3Y6YlK3QgOu+ncmiBbfeuwlLZ1
LxbYvG6hgNqXv7u6YyADbYajAQJXJ2OQen39pm3Q/AQSyLYG+B8lDglWsM8tYXPlEdrYJcksGK6F
nqIX6Bumn43rBooLJdiZp4WmfWdL2pxe+LxRDjprmqu1WprixDxULSTOKJZoqTlugs6y3Bc+if+s
gHnBBtz9WQ6MtPHkh7zONDAFIKcBmv8OqPQCx0F3Wv3OEybwMpXx0OsKgK8wLldaX1pXcMuyDgTL
Sqs0AV0OHUgwggcDMIIE66ADAgECAhADNSi2uzJskfEdOMo4hV0gMA0GCSqGSIb3DQEBCwUAMGIx
CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE6MDgGA1UEAxMxRGlnaUNlcnQg
QXNzdXJlZCBHMiBTTUlNRSBSU0E0MDk2IFNIQTM4NCAyMDI0IENBMTAeFw0yNjA3MTgwMDAwMDBa
Fw0yODAxMDQyMzU5NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqG
SIb3DQEBAQUAA4ICDwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZe
YAS/SRV6zmfXlXaZsNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2z
kC9S7/yHDYnqegqtw4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qG
pgFdZEk2/c//ZvUNi12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41va
v1RhZJzYan4a1gU0kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0c
vnO8FM6PTqsnSbcc0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PW
PU6zfQTOMZ9uLQRRci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXt
REF5lLXxp+CJ6KKSblPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQr
lR0gO3lBzuyPPArVhvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7Iq
aAovAX0d+f1YjbmCVsAwjhLmveFjNwIDAQABo4IB9zCCAfMwHwYDVR0jBBgwFoAU95uiTtOXxfQ0
D0MOgYXOkZMyr/kwHQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3
bXcyQGluZnJhZGVhZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEC
MA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwgakGA1UdHwSB
oTCBnjBNoEugSYZHaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZEcyU01J
TUVSU0E0MDk2U0hBMzg0MjAyNENBMS5jcmwwTaBLoEmGR2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNv
bS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNBNDA5NlNIQTM4NDIwMjRDQTEuY3JsMIGNBggrBgEF
BQcBAQSBgDB+MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wVgYIKwYBBQUH
MAKGSmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRHMlNNSU1FUlNB
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
PBM7Wv58DpwoBdM5hGwKfYwAAAAAAAA=


--=-jELRnwkCgenL5SAUxJqB--

