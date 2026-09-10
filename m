Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF84C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4036B0096; Thu, 10 Sep 2026 11:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BC026B0098; Thu, 10 Sep 2026 11:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13706B0099; Thu, 10 Sep 2026 11:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9CD66B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:35:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 639031C2515
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:35:58 +0000 (UTC)
X-FDA: 85198253196.24.63B18A1
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf15.hostedemail.com (Postfix) with ESMTP id AA004A000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:35:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tRUMAwwb;
	spf=pass (imf15.hostedemail.com: domain of 3Ws6iagYKCN0RD9MIBFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3Ws6iagYKCN0RD9MIBFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789054556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2+MOwVd/hSplAvFbBk52yvKLS3w7cDWTRO3ieRL0csc=;
	b=INWRac0dvWjVBOggSGIVFZ7jP57qp7grtt6yBYHVx2s1Qbld8GibV4ul2W+NuTnwD93z/T
	o2uWNysPti9YVRNoLSdHTGUkDql7dfqb7TSU45TFFfzCBse5/wqsKEQXaOLEKRuW0K4DXr
	ucL141GEW49MjYZqt0nmy1T4R2Sf8Pk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789054556;
	b=sTtjf+LROF7JOr/Lzi6szgZEHjtFw8O9myf2nvTmSUDIraRNhpcIvQ9qb3utMExAZntoNb
	dVGatFuIrrR+y0t45TS+rNJQKSSgsT8sBZKwn6bdOYHC6pn87MJOpjqNXO9Yaa00fi1VEU
	yIRHo6t4ypTXfTBG05lwLRHm/+hv+nQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tRUMAwwb;
	spf=pass (imf15.hostedemail.com: domain of 3Ws6iagYKCN0RD9MIBFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3Ws6iagYKCN0RD9MIBFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e54b6556aso5606111a91.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789054555; x=1789659355; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2+MOwVd/hSplAvFbBk52yvKLS3w7cDWTRO3ieRL0csc=;
        b=tRUMAwwbux1yofyzf3n5j9g21uDLquJUh1j2zWgfzznFGWHXve0uH8190uoc1x5hgn
         mDdLP43foKXg7cJq0rt3WWQoN/HmJ+5KmlFSNIsH3rBLm/dGONXmWc6Jwh5gbXzw/FS2
         Nwr5G9ose1xf01Cq0spj5QMvVtUV61YT92mRj6SH1K6dwVNFDQzZeyyCIbbNMTD8Q7i0
         NuKFEc8JZGNUnKKqWWbrqP4wVICF/tgFzGS9BqE8P26uVMqzY3uDrgpGG4dLDHj9LcP4
         M5Kw3L7IznNdd5c5zbgPUsst6DgCi4rg+e3EjtOEku5pqo8DxaP94cUyDYnQ+S2aDTs2
         tdvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789054555; x=1789659355;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2+MOwVd/hSplAvFbBk52yvKLS3w7cDWTRO3ieRL0csc=;
        b=SVTK+yPYNamK1DNZaK+5U8FIbYiBSBZhvWW9wB0wUnwehEAbxn1Rg+SDZiJ7Ux7RDm
         bx8/XqtarS0tZBm3e09yx6dpYFkf34AwQI3COSWF8vCLBoRc3QMfmFnpVPW/fw/AvwSY
         YXC0B+Gayum0TjtoWMAhYQjuNvtSAREZV/+MiBPfBvMUbmqGQYSwh97mP1ZBJwrX0XHM
         rYXT1WPT/m38rhHsYFGVozVbF+amUk5L6DonHi112vc5ZzrMqbLkLPPe3gJgpG6tujt5
         /BRkAcc2Liu36wxQojQuvknd69IIOHD6JrTWbrUIcM09RR1LhdIqAuuOCJcjXKR/tkOB
         aWXA==
X-Forwarded-Encrypted: i=1; AKwUvByFvcUEGir8oLDK3xLGRae//TsLWdxgf/xar2mbRYyi8lDpDEGsHYxeQql9wvP5XvEB+xFDHEGa7g==@kvack.org
X-Gm-Message-State: AFuF++maMiqp12xV7cpXKkoYxteSCwlEASccbok0H9oQSemkrk7uVTOP
	GJUavND/h6B3MLnLfM/s9b/xtWL1BxerWZw9dT86bDhz01ruP7o+WmYCOhBLQFSObB8u4J9473t
	ILFXdxA==
X-Received: from pjbdt17.prod.google.com ([2002:a17:90a:fa51:b0:39d:8f18:feb5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:6081:b0:39b:51cc:4586
 with SMTP id 98e67ed59e1d1-39b51cc65admr27199424a91.19.1789054554982; Thu, 10
 Sep 2026 08:35:54 -0700 (PDT)
Date: Thu, 10 Sep 2026 08:35:54 -0700
In-Reply-To: <20260910143448.GD3968357@nvidia.com>
Mime-Version: 1.0
References: <20260903023452.721732-1-loganodell@google.com>
 <20260904160009.GV4157646@nvidia.com> <aptFFYqcSiBdMLE8@google.com>
 <20260905012403.GX4157646@nvidia.com> <aqIAtOoew-_6jw29@google.com> <20260910143448.GD3968357@nvidia.com>
Message-ID: <aqLOWkuVKccR-I7W@google.com>
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Matlack <dmatlack@google.com>, Logan Odell <loganodell@google.com>, arnd@arndb.de, 
	pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org, 
	graf@amazon.com, akpm@linux-foundation.org, pbonzini@redhat.com, 
	maz@kernel.org, oupton@kernel.org, bhelgaas@google.com, alex@shazbot.org, 
	kevin.tian@intel.com, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-pci@vger.kernel.org, iommu@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9t6ma3u5k1tn6xgdeuf7qycpz91hkx46
X-Rspamd-Queue-Id: AA004A000B
X-HE-Tag: 1789054556-299485
X-HE-Meta: U2FsdGVkX183dhPetT7wqz99are246LAQEe4xrFs2Tt5YAuTWU+gYyKxMPrkiYo0gZB1Qfk1UAGRvgoODEMOpHSjLjFDm9w5n2MCzOBLr7AcuNfptVIa0gIkpNA64BiV2d+wo9fZJGzqlm5Yn6wtH5f8Gujui7LfdLSJcqnU/ZDWfPgSDqQAndjJZXYpQlHL04PXWvvI711STJ04GXqEOnwzr85tVyrOF2Oi/VPA19wASyaqbj/khkAk4u8PWwg3UzwXmhLk/5CwxLCwknEfAnsuKs0dIZ8Mp2s9Ah2Sy1n20xno295+3PUl4HxURxnWNW/P+yk3w7o/kl54QVHrXc01XM0Khmk/7XZ+MC2WM8hlKCswcd67reJ6Bu9g62LvOzJouHBm20gTWuU3jqYR1pQRPz4556TL/HZhGqa2ViKtkgOjRCXt36FqZIRXFEETUutZpDQ85iCtnXkCXnMyZrBoTAyOVv98Sw4PHY+FWMQ2XrFJ5sZ0DxaNNf5qgn4adYPeIdaaoooQ0q8+PM5f5o0+0aVqYiU6yZDt6xTgNjG23d3LhCRObYZhuV8yr4mYEsojvOCyuBlWzcJkt0IhW4lQxvzsC44Cxyz6024WRxf3P4lFti9cZFkNnOVOSuulsOi1sAM2O8O990TyJGHjUNFEVXnVvZiAQXSz+s2PtBOx0kAe8cVNkiXv1P2SfKSz+KIiMXrk0xKWcnmA7M7FFqfNpDwAZcl4Mt61EHV9349lIfNM7ciCz6lSRmBv/iUYI5oztckUScE1j28M2dnhtZaOp/WCPFdHQOPTZQNAOT+f7pL1HPgfzgkY180Hxt5Sy0Jtdj2HZyUlqypiaPDB7DyNtEt1obEhG8ZJBZAMRvOMBWCo7B0gNaWSLHSR7ZkV2/fEZsw7DsfSS0B2I3uAC1VxcKshAutTPyQTkA4r+//EOnaf7/wICRims3/eDBvrBd0aNYmHjRcz3twFO7N
 QH1mjd6u
 YCXd+csgPb4nlKr8OJOzvbl9/eFJhFM+EYviQ8BI/z4qRvVzmAYQt/+L8KCkf/mphv6TiVt6PEaaHcnDqvPGYgrVQ9VG+TLld7MNZ/7c2Lp6NiQeSONCRjaVg/AsDd5DDOnobsgKUA6OKOeX687CtR3eJq+eQCPcNZhcXp8R+ZCMNkDpqAkdAUEjCZsLoLyC4kd0lHeWqY2jGvS3Jl03ncHhYrkWMiDzYj9RC9aQlADBVKah+hqHzGBKz8S/MwweDbtbtM3jPiNNrTScAG02LnTVLclVftR/G4ggBYjXqv8gFGr8K1gDXySvFMJKsHkas1qfe8icQg0/vKR7JxC6OCS9jxIpwHXe/X+7qrI+mGw6o0pQNMAeBDO1xSK22VOk1ZyzcH2mwji8brCq9iSF68mxW8cxNit/SKGxLzKJ6dJkOysu0mBgGt9DqE+QgtHun6T2RwTAhi9CGEJzAiNDpXzcCdQX+aKE7nZctpR/yQlNF6MtjQG7V90oSXMN8Ibbc2rqCFI6p/CdkrpUESshPWpKDVaorgBY+puUvB4pTf+qmuwWlZRHWKleHeqCJMBjrxGCoXgWUnzld7JYwrDKsslbvDs42UaQgvJg3WgEXGKei6lBLiRQvQzEG+4hdmXgKM1T/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026, Jason Gunthorpe wrote:
> On Wed, Sep 09, 2026 at 05:58:28PM -0700, Sean Christopherson wrote:
> > On Fri, Sep 04, 2026, Jason Gunthorpe wrote:
> > > On Fri, Sep 04, 2026 at 10:24:21PM +0000, David Matlack wrote:
> > > 
> > > > The proposal here (which is inspired by the KVM UAPI) is to ensure every
> > > > LUO ABI struct has 2 properties:
> > > > 
> > > >  1. A field to encode options/features (e.g. u64 flags).
> > > >  2. A way way to grow without breaking backward compatibility (e.g. so
> > > >     we can add new fields).
> > > > 
> > > > Each flag can mean whatever it needs to. e.g. It can indicate the
> > > > precence of one or more fields (i.e. new fields in the struct), or it
> > > > can mean a field now has a different meaning (i.e. union in the struct).
> > > > 
> > > > This would enable adding support for new features without breaking
> > > > backward compatibility. Downstream users would have to ensure their
> > > > kernel does not start using a new feature while it can still rollback to
> > > > a version that does not support the new feature.
> > > 
> > > This was never the biggest problem. The main issue was the functional
> > > behaviors of the kernel that cannot be represented simply as data in a
> > > struct with some flag bits.
> > > 
> > > Like for instance kernel A supports memfd folio sizes far larger than
> > > kernel B because we fixed MAX_ORDER. You can't fix that just with
> > > simplistic flags.
> > 
> > Can you elaborate on why the folio sizes matter?  Honest question, because I don't
> > understand why the serialization format wouldn't express things as "N contiguous
> > pages starting at PFN X".  Then the implementation would rebuild its folios as
> > appropriate.
> 
> That's an idyllic view, yes, but my point is (IIRC) we didn't do
> exactly that for memfd.

Well, y'all screwed up then.  I don't see why past mistakes should force other
subsystems to support a flawed implementation.  Learn from the mistakes, add v2
of serialization for memfd, and move on.

> Sometimes you can do more and more work to try and be more and more
> general but this is *alot* of work and even then eventually hits
> problematic limits. Like what do you do with the sealing flags? That's
> ABI breaking if the successor does not support them, and downgrades
> make exactly that possible.
>
> A CSPish user can do things like patch the new sealing flag into their
> current kernel (while preventing userspace from using it), ensure
> everything is updated to that, then jump ahead to a newer kernel and
> enjoy the new flag with full downgrade support. There is so much more
> control on their part that makes the problem far more managably simple
> that upstream does not get to have.

I guess maybe we have a different definition of ABI? 

I'm not saying that upstream has to be 100% forwards and backwards compatible.
I'm saying the serialization payload itself should communicate what features are
effectively required.  I.e. *if* there are incompatibilities, they should be
naturally expressed in the serialization format, not communicated out-of-band
through magic numbers.

The scenario you describe fits exactly with what I am proposing.  Until something
actually starts using the new sealing flag, the CSP can downgrade to older kernels
at will.  And if the user cares about downgrading, then they need to prevent the
flag from being used until the new kernel is rollback-safe and deployed to enough
hosts to prevent stockout.

> This is why I think the very idea we can support any version pair is
> too much to ask for. We should focus on supporting a small set of
> version pairs and not making it too invasive or hard in the kernel or
> on the maintainers.
>
> Thus live update within a stable branch only is my proposal for
> upstream support.
> 
> If it really succeeds at that and it becomes very popular, then let's
> discuss upstreaming doing additional version combinations.

Why on earth would we have version numbers in the first place?  IMO, monotically
increasing version numbers are flat out the worst way to communicate features.

I am completely against supporting any scheme that relies on magic version numbers.
It creates problems where none need exist, and checking for compatibility can't be
sanely done in a programmatic way, because by definition it relies on magic numbers.

E.g. if the ABI for a given component hasn't changed, why should anyone care if
the overall "version" of the kernel is ahead or behind by N kernels?

> > I could see things like HugeTLB not working if someone booted the kernel with
> > support for only 1GiB pages and then tried to feed it payload with sub-1GiB ranges.
> > But to me, those sorts of things fall into the "well yeah, don't do that" category.
> 
> Okay, how about worse, todays kernel has hugetlbfs and there are
> patches around to luo serialize that. Lots and lots of talks about a
> post-hugetlbfs world out there.

And?  Adding a compatibility layer to a future kernel so that it understands an
incoming HugeTLBFS payload should be trivial.  I can totally see not wanting to
support serializing a post-HugeTBLFS kernel's memory representation into the "old"
format, though even that probably wouldn't be all that difficult.

> Do we want to constrain what is possible to ensure we accomodate this
> hugetlbfs serialization? I vote no.

In what way is providing strong ABI guarantees for individual components
constraining HugeTBLFS serialization?

> Do we want to reject the hugetlbfs serialization until we have a year
> of debate outlining every possible ABI scenario? I also vote no.

That's a bit of a strawman argument.  Is designing a forward-looking ABI easy?
No, but IMO "a year" is a massive exaggeration of the effort required to come up
with a scheme that can survive a variety of plausible upgrade/downgrade scenarios.

And again, I'm not saying we have to support infinite compatibility.  If some
future kernel drops HugeTLBFS, and we decide not to provide a shim to support
downgrading (which IMO is totally reasonable), then it's on the user to understand
that moving to that new kernel is a one-way street.  Given that dropping something
like HugeTLBFS would require significant changes in the software stack, I think
it's perfectly fine to put the burden of understanding the implications on the end
user (though realistically, there would be a copious amount of documentation and
deprecation warnings).

> Should we make a downgrade round trip a downstream problem? I think
> so!

Hard NAK.  There will inevitably be boundaries that cannot be crossed, but I am
not at all ok punting on downgrades.  To me, that's basically saying "we want to
add just enough support upstream so that it's not too painful to carry full support
out-of-tree".  That completely goes against the spirit of open source and upstream
Linux, and I want no part of it.

