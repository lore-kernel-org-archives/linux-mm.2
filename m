Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE6C8CA5FA5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 00:09:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A299C6B0088; Tue, 29 Sep 2026 20:09:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DADE6B008A; Tue, 29 Sep 2026 20:09:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0CD6B0092; Tue, 29 Sep 2026 20:09:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6678E6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 20:09:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9F7C120617
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 00:09:11 +0000 (UTC)
X-FDA: 85268493702.27.6FA9906
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2AE6B18000A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 00:09:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JDlDZkAh;
	spf=none (imf16.hostedemail.com: domain of BATV+ef936e95af8143c0fdcb+8438+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+ef936e95af8143c0fdcb+8438+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790726950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1XLL5FD+V9XTRWwRvT/RfNWlWKfNSYWOE1zY0VqofQ=;
	b=KkF574Zb6Ph373GiSAlGk3MuImObd6vWrLATXFMLXzwu198EvnXwcbarHK6wjtGa+9SO/D
	EIBpELer+vsCGL+hIke4tpHbTmdkAb4jGgvJFTDkjE6ARr++hld91ol3GSCw/FNwjrOZ7V
	z5DDNHn824fFNRod/veeG7gczPEt8Wo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790726950;
	b=iHgMeLS0xGn3e/8ENQ3ezLq6BECdJBMu11/x9Ur6FL/Rp0ehD7GVdqajs9ztH9pXo/mpVJ
	9K6VP7j0jx60DsaMXFgPxuO4mdLsUd+O5uX8NpBz1f6HA/+T1LjSggBpVVRC74AzMXs0V+
	8HRGazhLQJZpiUxl9DglEpNRjFrBBh0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JDlDZkAh;
	spf=none (imf16.hostedemail.com: domain of BATV+ef936e95af8143c0fdcb+8438+infradead.org+dwmw2@casper.srs.infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=BATV+ef936e95af8143c0fdcb+8438+infradead.org+dwmw2@casper.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=l1XLL5FD+V9XTRWwRvT/RfNWlWKfNSYWOE1zY0VqofQ=; b=JDlDZkAhIOKCzrA6PIYsG9Rum+
	O2oDMtb1uqBXA3NY5kBbcq4FDz9xzZNZe6WjQNKTrTJNDO1GcbSitR2pa9lWkBLUnCc8pPS4d+jOq
	Ur6Xt45vFE1OPnpt35En7XohM7qgeN9R1PAfFmlfhLCP6VwVXWPNCSnxwfvKwGNl6Yk9lVZMvXtou
	OpOtDYXusfmewrvlEZF+TUNIeEGo8cSvA78X1xqbm7Q526+ihXjJzpHCJ5GxADK6C6Q36qs/J4m0T
	G9innKuh9bodxAJmDGDDLZ6AqxMsW6EUd7viVES6UCVo5WSGAowRy7r8GtqI4lJubXpnST++aSKc9
	XHxz9dOA==;
Received: from 54-240-197-238.amazon.com ([54.240.197.238] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xBhsM-00000003keg-429O;
	Wed, 30 Sep 2026 00:08:47 +0000
Message-ID: <763406b6c74937b6b005cc1e2228b429314b97b6.camel@infradead.org>
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
Date: Wed, 30 Sep 2026 01:08:45 +0100
In-Reply-To: <CAEvNRgEU47Xag6S4mJNxZCjEf9AetHO_kvMQ033Vaz4jpwcrcg@mail.gmail.com>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
	 <d599627270c67a5334d2abced75d1d1711fb0af0.camel@infradead.org>
	 <CAEvNRgGw_RjiGs_bbVnoRAvq49Qukm4h8XhkBd0DXxn1ZzLrQg@mail.gmail.com>
	 <ecab388213245df81815e42246db3b13b2d43e2b.camel@infradead.org>
	 <CAEvNRgEU47Xag6S4mJNxZCjEf9AetHO_kvMQ033Vaz4jpwcrcg@mail.gmail.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-hiIoUJ0JSCeXUEQZIIk7"
User-Agent: Evolution 3.62.0-0ubuntu1~ppa1~24.04 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2AE6B18000A
X-Stat-Signature: 31xfweem1ut9z7956qdes68w4jx689rk
X-Rspam-User: 
X-HE-Tag: 1790726949-371889
X-HE-Meta: U2FsdGVkX19dMm1NQOl/KGFapJ332AobBjgnV4sio2DkhTn7agnvpu3g0uxUqR901zdOEFhbVdspvQWmfMa2hKKnPxeMDeLczoIAja/SaNP31/nUFWBf/8oPoJw1iwxZ5VU5oMjwVdWyvLffOjGZw1+EAoBy14VUTRqK3rZRs1E/jptSYl8RTg0wNcPBP7EluNSdnFX9haMTrQYP0IQbQ/sX/Gnj2O1cFN4rX1h2rL3P1mWJToCoSho8SfY/Rli66CnLP1jtpQ5bICI1TrD4lA+8fkrg+tFokqde/bluha1604Jd4nlVzHp4xhDGF+RcgHWwsYCGdQy+KVA0obOnah+1VyYPpWaOBHAfy9K90D9WipIVUAi3VLh0fyG7D8Oqg8Tpau8rq4CfS7yfuJUDEgDMcaWivX2quQwS9PNTZMylAH6S9DWk0GxT/xsfXLl3QkpiOOQkndWlOLY4EN0qSIkR93kVV7kGQ8M+6AJ0cCmiOGx3jF966Ydp8hk6DRm3hPJh+aNp+fy1ncUYzo8WwhgaPL2xVPTNnKXSXTEYh7dU0t4ZdbtGMV45Ni8CnsH1r5Sb4QEmQSoDIG4lRiKz74UafcDxcxhHCxR0yiczbjjQO+lSEV1LwP7RuabpeIyMnNJMNXW54XGus2zQboycTB3Xco2QusoZbPfVsfAppV3ak3w0F1ckN7iQp6GpXaWHlkNDRTuAtxB2Igp6E4ASzXJp/A5+DtFe5r3L6pLdRYGmiMjZbn8lnXG/XFI0bqdawvXRI6bRCa18GWoUHaJ1Kg67pfB783j2wM62Fdi/A38+zyGd2+wb6NHv24LxeKRNbPIjWVHkId0fUwtDJy5fFlg6905+a1EIDG0LfpYZSfPQj7lEYLAHCxvQDOtbLmfkvRlTrhEkQMvoq6ptAOxean+d2c1MG7Wr0/8Jk2DHFMY0kRgF1c6+hREYPlC+TWasOZXDoK9v02HT+LCJhFx
 LJLKVphX
 LvzaHY5MXzYRf4QSUJYilt3XwLM9DxbLbexuO9T77qjzdSe8AQvz87xG6jwMzH8ImmayfGWs8B3gs/edWTon+rEH2B5BpPYRJa60lqS2RcNbtkJmtF8UZt8KT8a2pr3WgN0vMbUWd07VoSNTeEspuXJB1Tyl2ibCEHRbdka1BFd3LEFv6qTXze+ADSp9HSBJbQp+LcPqeoWOGT7n1vklfvwhoU4HcYpXIxvM0ujwZaTfaieWglvLqo5QeXayzop4hkKgIA0xI+ogMnUziI46f/nLafjJnu83hcAPLLrGKjUcAyCKDF4hskFYQw2v3n+jkH+RPRbNQD0VNzLTCxjbfX5qNxvle9G0CfztZ/dgpNlvRI6/GnHzbdzxfbPNCHO5w2nFC39tNV8W/DP6q8/XDynxASHBueIa15KwsFXYLCOVhlmiVbDd6J9ABjXPtd+JTuQB3a6bJf9y48JxkZVh8sZKW1IVlC31N/x7xAo46tsrSxbrgMeLuQ6ILVMLzcrd94Xs6awbNaq/eeQ1a5eXg7fAM1/Rzd05XakSDkT52DH0V14vpMNrJrEPul+u0Z1zEiwkeB8qFlTPoOwEnZnl8Zpt4tojt1u5X9B65A0r1NhOjwRze/OHdx4d3dDYOPzDHhvs4HG90o+FVo783WtwgwF0frkwbCp9daG1qDWJzSCQzNOjcu8QHXRuUFPjwyF8B9GJbcKQfjc2n9vSYY3sQyIfCX7R2aM90H1o3GNMfbO+YA2wmwVnOP+t04aQrmB6QLF67/D104pc1jjVBziXdLcJNWosLmo43TG5G3kT7b2FbYiFCn6kbS7avWDiS1YAwt792+c0L+wnA9IE11dlwZO6EmAew6wItU3mFKWYZ4wfMUazSiNA3pJThKW14D4GRhvDqt5Q9tYKpXCh5YDzXkJOTUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-hiIoUJ0JSCeXUEQZIIk7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-09-29 at 16:41 -0700, Ackerley Tng wrote:
> David Woodhouse <dwmw2@infradead.org> writes:
>=20
> > On Mon, 2026-09-28 at 15:59 -0700, Ackerley Tng wrote:
> > > David Woodhouse <dwmw2@infradead.org> writes:
> > >=20
> > > > On Fri, 2026-09-25 at 17:50 -0700, Ackerley Tng via B4 Relay wrote:
> > > > >=20
> > > > > =3D=3D=3D What if my provider doesn't deal with pages?
> > > > >=20
> > > > > Frank and David Woodhouse [2] have use cases for providers that u=
se
> > > > > PFNs, and this is definitely something a generic interface must
> > > > > support.
> > > > >=20
> > > > > Here are some options I can think of:
> > > > >=20
> > > > > 1. Don't define .alloc_folio(), instead define .alloc_pfn()
> > > > > 2. Refactor .alloc_folio() to .alloc_pfn()
> > > > >=20
> > > > > Either way, I think guest_memfd should still be the primary manag=
er of
> > > > > the memory.
> > > >=20
> > > > Thanks for working on this.
> > > >=20
> > >=20
> > > Thanks for the quick reply!
> > >=20
> > > > I'm not sure what you mean by 'primary manager' here but my use cas=
e is
> > >=20
> > > Naming is hard! See comment on revocation below.
> > >=20
> > > > for the provider to be the ultimate arbiter of who owns which PFN, =
and
> > > > revocation of the same. Think of it like a filesystem backed by
> > > > external memory. Each guest's memory is a file, and a guest can
> > > > *donate* specific pages of its memory to other guests (which in the
> > >=20
> > > Putting donation aside first - I don't have a good picture of how a
> > > guest would tell the host that it's willing to share a page - can't
> > > comment. Would love to find out more.
> > >=20
> > > > context of the *interface* only means that we need revocation).
> >=20
> > That's implementation-specific. Think of things like Nitro Enclaves
> > where a guest 'donates' its memory back to the hypervisor to be used by
> > another microvm. But that interface isn't the guest_memfd concern; as I
> > said, in the context of the guest_memfd interface, there is only
> > revocation: that page went away, whatever the reason.
> >=20
>=20
> Okay we're on the same page then. :) guest_memfd only needs to know that
> the page went away, guest_memfd cannot say no.
>=20
> > > Going with this revocation part, beginning with a more basic use case=
:
> > > I'm thinking that the provider can notify guest_memfd that the page o=
r
> > > PFN is going away.
> >=20
> > Right. That part I have working in what I was posting.
> > [5] https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dcommitdiff=
;h=3Dee95ed5aaf06
> >=20
>=20
> That is similar to what I had in mind except the parameters, I was
> thinking inode, offset, size.
>=20
> kvm_gmem_invalidate_range() in your patch [5] does have a kvm_gmem
> prefix, but it's really a direct call to tell KVM MMU to zap the gfn
> range, guest_memfd doesn't get to update its own state.

Late here now, but it occurs to me that I need to check if that makes
sense. Does the provider *know* the GFN, or only the offset within its
own object =E2=80=94 which might *not* be in a memslot starting at GFN0?

Tangentially: I'd actually quite like the provider to *know* about any
such offset, because if possible I'd like it to be able to be
opinionated about where in the guest pages are mapped.

> > >=20
> > > Yup, guest_memfd needs some way to track PFNs in addition to folios. =
I
> > > think for tracking we can reference DAX, the part I haven't looked at=
 is
> > > how to let guest_memfd handle events. Like if there's memory failure =
on
> > > a PFN, how do we let guest_memfd handle it?
> >=20
> > Telling the guest about correctable and uncorrectable errors, you mean?
> > I would have thought that's up to the VMM, until the point where (see
> > revocation)?
> >=20
>=20
> Informing the guest is definitely the userspace VMM's action to
> take.
>=20
> guest_memfd's role here is updating it's own tracking, and perhaps
> splitting folios. When guest_memfd supports huge pages, one thing high
> on the wishlist is to split the huge folio and zap only the page where
> there was an error and not the huge page.
>=20
> Advantage of splitting: If the failure happened in the last 4K, the
> first 1G - 4K can continue to be used by the guest. If the guest never
> touches the last 4K, it doesn't have to know about the failure at all.

Right, but this is still just revocation of a single 4KiB page and
expecting both KVM and IOMMU to shatter the large page accordingly,
isn't it? That much I already had working.

(The IOMMU shatter does need to be atomic and miss-less, which I don't
think is the case on Arm but could be.)

> >=20
> > I think where the memory comes *from* is an implementation detail for
> > the provider. It provides a PFN (or folio, if you must). All else is
> > not the business of KVM or IOMMUFD.
> >=20
>=20
> So we already have
>=20
> =C2=A0 dmabuf --wraps--> CMA (and others)
>=20
> We could have
>=20
> =C2=A0 [a] guest_memfd --wraps--> dmabuf --wraps--> CMA
>=20
> or
>=20
> =C2=A0 [b] guest_memfd --wraps--> CMA
>=20
> I agree guest_memfd shouldn't care where the PFN comes from, but this
> does impact where the provider_ops code is implemented though.
>
>=20
> If we go with [b], CMA needs to find a non-dmabuf way for userspace to
> get some resource fd. If we go with [a], dmabuf folks need to support
> this :)

I'm not sure I see how CMA is relevant to the *interface*.

A given *implementation* (provider) of a guest_memfd resource might use
CMA for its backing store. Or might use hugetlbfs. Or something DAX-
like. Once the implementation has provided its guest_memfd operations
with its 'get_pfn' method, nobody else cares *where* it finds the PFNs
that it returns when we invoke that method.

> I missed considering breaking down huge pages (the folios). guest_memfd
> will definitely need to cooperate with the provider to break down the
> pages.

KVM manages this part on its own. The guest_memfd implementation only
has to tell it to revoke. It's been a while, but I don't even remember
having to do anything special.
https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dcommitdiff;h=3Dee9=
5ed5aaf0


> I'll need to prototype support with HugeTLBfs, probably after LPC. There
> I'll need to split pages on conversion to shared and merge on conversion
> to private.
>=20
> I think you meant breaking down the mappings for the large pages in
> stage 2? guest_memfd tells KVM to do that in one of the earlier
> prototypes for guest_memfd HugeTLB pages.
>=20
> > > > =C2=A0=E2=80=A2 AsyncPF support for pages requested by KVM.
> > >=20
> > > Is this kind of orthogonal? IIUC today KVM MMU handles the async-ness=
.
> > > KVM MMU checks that the page is not there, then since async was
> > > configured, KVM tells the guest to schedule in something else.
> > >=20
> > > guest_memfd doesn't have support for async #PFs now. I imagine it wou=
ld
> > > be something like KVM MMU firing off a kvm_gmem_get_pfn() request
> > > asynchronously, and then guest_memfd gets the page or PFN and inserts=
 it
> > > in guest_memfd filemap, and then notifies KVM MMU?
> > >=20
> > > Within kvm_gmem_get_pfn(), guest_memfd should get the page or PFN fro=
m
> > > the provider.
> > >=20
> > > I think it's orthogonal because guest_memfd could
> > > have gotten a PAGE_SIZE page (existing functionality) or gotten a pag=
e
> > > from the provider.
> >=20
> > Kind of, but I'm focusing on the guest_memfd provider interface, and
> > that needs to support the asychronous mode: asked for a PFN for a given
> > guest address, it returns -EAGAIN and then provides it later, and the
> > guest gets the right asyncpf behaviour:
> > https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dcommitdiff;h=
=3D894dd0fcb34f
>=20
> I thought the same .alloc_folio would be used, except for an async #PF
> the entire kvm_gmem_get_folio(), which calls .alloc_folio() would be
> done in some background thread, so the provider doesn't have to have a
> different .alloc_folio_async().
>=20

> If the provider does need to know, then the corresponding thing in this
> series could be:
>=20
> =C2=A0 struct guest_memfd_provider_operations {
> 	=C2=A0 void *(*attach)(struct file *resource_file);
> 	=C2=A0 void (*release)(void *provider);
> 	=C2=A0 struct folio *(*alloc_folio)(void *provider, pgoff_t index,
> -				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct mempolicy *mpol);
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct mempolicy *mpol, bool no=
wait);
> 	=C2=A0 void (*invalidate_folio)(void *provider, struct folio *folio);
> =C2=A0 };
>=20
> something like that?

Yeah, the 'nowait' argument on get_pfn() is how I have it working at
the moment. And then, as you say, KVM calls it again *without* nowait,
in a context which can sleep.

> Either way I think it would have to be a later series after the first
> one (for upstreaming).

I don't have a particular use case for asyncpf right now personally,
but I think we *should* get the design for the interface right. We
should do it on the IOMMU side too, because ATS+PRI exists.

--=-hiIoUJ0JSCeXUEQZIIk7
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
rSXSpOT9/8SLFF09WEoeQ2IAAAAAAAA=


--=-hiIoUJ0JSCeXUEQZIIk7--

