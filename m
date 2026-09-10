Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A180C79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 21:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 101876B008A; Thu, 10 Sep 2026 17:28:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D9406B0092; Thu, 10 Sep 2026 17:28:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32106B0095; Thu, 10 Sep 2026 17:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B63BB6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:28:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC70CC060E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:28:14 +0000 (UTC)
X-FDA: 85199140908.03.30979E2
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf23.hostedemail.com (Postfix) with ESMTP id 118B914000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:28:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QuyBAVeQ;
	spf=pass (imf23.hostedemail.com: domain of dmatlack@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789075693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOLKQV5MP6URX3X9jqnRFyBsWQauQYYSupdkNVN7Yn8=;
	b=oUUwYB+F2aWSXgdtb0vV9La462LNFL7igVkHxEAvGoFP0EYSYdjdeh+BxYYPfEqHIMyZno
	OPwamYNfAV4nr/TOLqpA6DulUp/xKFjzv9MzFU7n23ByxyzVfQhPT77Xc2a5kSnUTYr2xa
	1h4CRxVeI3G/38qDUKzHUhR6TCHy1rU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QuyBAVeQ;
	spf=pass (imf23.hostedemail.com: domain of dmatlack@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789075693;
	b=oXukWTvtWd3AZ4vQBCXlvNufBh6H3gd06kYyFMrlnQcGlgaZ8Mah5qMTrGb/qZtCqoWl+o
	6J11dddfT3p1qrPwiMLf0OXDmisktiO+diRNuS1u18h5X8xMZKUDU061wZ9hjVePwE4ZwJ
	axi15NIvuPXxTbp2zY+UeU6Uwm08Ws4=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d90ba1d807so1836445ad.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789075692; x=1789680492; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hOLKQV5MP6URX3X9jqnRFyBsWQauQYYSupdkNVN7Yn8=;
        b=QuyBAVeQthxSK4a7MbzWGSap4jj7dsVEfY3B/SKMCFv7eTXrp/KRm7kYDzlbOMOn5B
         pG1Ce63KZMaCE9JD4/NOJzRnUk3OI66ApM/LJZVM+crt5eWNOc65O3u7Awt5viaJ8iOR
         6nGvMVN/ENuqLkyueSWXZPuYgSelFxfcbKBwaKjt84S86Ml3BVY0mEjsEm562gTcg2Pt
         1O7UFNBe0tQDDY1cPbS6zzM5EEO0Ufw3X5mHmcOWes5XopXGSxncO2jm87v/4TR7rW6a
         L4s4ALiS0q87uK92VuOAg3uhKHNfNA3Go7ZVVD6TPm5hStoN0IJPRsWklqAhXacrBHJQ
         GT/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789075692; x=1789680492;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hOLKQV5MP6URX3X9jqnRFyBsWQauQYYSupdkNVN7Yn8=;
        b=L8DIQoKlGpcKLFNHxhWK3+rk45AsnRGUVGbCPU15vaPGMdDnEX1cM29aQtXy42+AC4
         8d6IVgvmPdHifAomqW46/IlKQ+yzf2ag0hKcoDth5AZLm7KmQaHX6Zibh7ER47ceEPih
         3UO9xQnnVJ1uMnB40vqK7DEaH1BAqvKbTLrFl6bjKij638dWWjB9SL43ohrZe+sWBokQ
         0fPfu6N+wsUozVxKQPMqOhqwcfMDdaSFp5UCtozd3I87eIv60n/5vTEhk2RVRu5lFh33
         FLE+W9O8RncO/pyKzzx3SWsH1tAabfZJc6rLGEn7/2LfR8SKuXTzAHVR+NpB2JIAvozq
         Ha+w==
X-Forwarded-Encrypted: i=1; AKwUvBw0K5czojc3VX0JKfSxb/hMKKBxCieIxehbYFPKMm70i1Gq9NvQCOBEVlRg0fEuUi32vz4qEPi5zg==@kvack.org
X-Gm-Message-State: AFuF++la6IPR7fKIRrq2bLRlw9J6omM1pvRBwzHTW/lzSYPFNkQCqDf3
	rzOMJmiSpDu167KBNpGrZKaS/rVkMRYzqvWGL08gRkHiio2o72ZuMePk66NZvxya5A==
X-Gm-Gg: AYBFou09I6S01/5Mk33JFwtjDeXeozZs9Swt72aMcYiosxDF0sSsq3ZM9rwuJYo0dvR
	rtL/gjTHbFpT+lJlDQjVI0V0PB5GqkI2OToPnJ05mwQiFyF5Iaf2RRrVEq2ESxD5eJzf9YcrrF3
	hiMajPx9WORLYMI7B7BiS4dooDSTAFI+rHFk9sN0MF886XWvG7LQ72m04ydI4ATU2HhPRcnYc7B
	dCUqq5GjG5qT7bSl7PBceNVOJltEEM86Mi/FnzGoWCV4UczUbQsElWpjIEmp+N4/Tpm8Kv+2BM5
	5/nc/Bt9tQEMS4fGLkembfr2Sepjzs8Vd0+h4MFituwgZWZqv2EioctDjyVFVehRrW2YqUtcnNS
	uVW8ejlWauRtixaSdeaClDLaIGpLOQJLZ4ZTqSF87lliFk1wsuaL43OBiEcizabHaY5zMCipS4U
	YRv9m6IxDTpJCMMesiGWgcTNjil8HO8VyBGZoVxdhNCQcPd8sL1GiZ99Rayb84EDXPkfb3m4ej7
	3W3Cyqc/iEr2Mu2ppWPH1ryb4a7cUpF9GcthrtE
X-Received: by 2002:a17:902:d984:b0:2d7:f0:896b with SMTP id d9443c01a7336-2dd2a33648emr23827755ad.13.1789075690962;
        Thu, 10 Sep 2026 14:28:10 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2ceb715bsm1812275ad.39.2026.09.10.14.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 14:28:10 -0700 (PDT)
Date: Thu, 10 Sep 2026 21:27:58 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Logan Odell <loganodell@google.com>, arnd@arndb.de,
	pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org,
	graf@amazon.com, akpm@linux-foundation.org, pbonzini@redhat.com,
	maz@kernel.org, oupton@kernel.org, bhelgaas@google.com,
	alex@shazbot.org, kevin.tian@intel.com, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
Message-ID: <aqMgjXfTJ8u3n7Kj@google.com>
References: <20260903023452.721732-1-loganodell@google.com>
 <20260904160009.GV4157646@nvidia.com>
 <aptFFYqcSiBdMLE8@google.com>
 <20260905012403.GX4157646@nvidia.com>
 <aqIAtOoew-_6jw29@google.com>
 <20260910143448.GD3968357@nvidia.com>
 <aqLOWkuVKccR-I7W@google.com>
 <20260910171210.GF3968357@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910171210.GF3968357@nvidia.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 118B914000B
X-Stat-Signature: fspmud7gpzy9iat6ae9h3ij8cxtxjt3j
X-Rspam-User: 
X-HE-Tag: 1789075692-121860
X-HE-Meta: U2FsdGVkX1/w2qy3PWuFXnJ5BVRy06OBRH9ZKesk4ttrS0yHGG24Rq2kREe9JgQB0RW1Ca4638a804EVuVtp6d1/wGBtOF80vvQAytyLhKr1F2x/l6oLOF+7yBcO0E503qrM1juLyo+enTdKwnsvr3FtJJ1XVbPAQZ8XdIe6V50Z2gEGoAwnK7qlrsbVrr8KIfSR/neosPc9UUzdhMhtkwiWSGUcQiQfvNKfZr1GMZ6a4TBhEzIqp01ih6zTXhEShWtce5lPpgq7oVX8+VnepliKtkNHtzbtvD35KOoiwu6mQPQuaCmq/jW3kcr2eICh9Xf1ulsmRJmbpvc5+Ss5ZaSqe2o4WC0J8LvcOR6WQunltbaOUbijMFadjPspeARHgVDoazUKK93SgTZeB07WNagLOgw+yxmX8SqqesiHY3gZmjv02hTTnk4Hlxp2YygYJGWGZZ86TDPGfrajR+Q0eaWkgaLKC+Oe0VNHElSR4WNhimA9uh4d24gf6VPji6v58P12l0zQByUDkKrVYm4d3yVlCsOeZWQ68miXIDajaA4PoB2O76pq6MbaIJP13QSZHvBfccDA/aW/ZFTNw3bZu2vABy+HO3xfNM5kto+2etWQrCcfE9g0EPyEycH0f/LqmZh2BlddCE/YrJMllN9FeEQPHJbmZu/Xc0qpLPnQbGLx1eUYMSoTI5aW8IxAXfhYEhrJbikSFLyRTzFgsSuB4UF5LPEvFpjkn+ClOnaWLAPQ1nPaWROl7XrHUsq21tPDdmtEOHTUwiu0laKmcpS4ffqg4XXEckXOLJb5d3tjlcfTjurbKSysnNgG4PMSZGjiOS7bnvr0tUXsgJBu+UIU+HzyihyfZmFy3eWMfzOcTdUnUzukvq6gUDU+fIbnSO/oFRRKxYx3+xY3+SZV5s3vN6ad4DFrLEdzrU0gnBt1dKrBu7x6WMAlMeGJ1WrlKHQuquQad4+yBtd+MP+EUOq
 Hb8zyanM
 tLXhZAzx8MmS2oMNNsuaRmr+jiTMMqSImU86Cm+OspGXRFyAn4Za6scvJJ3oHiNlMtaLgeV80HpPiK8TG+/GIRnLmMIHaQCsRv4c3anWEDFmSXtPvb+kRA0hHnkM9Z9kghh0O1bna1XEbbKwOVBR0+qToo5oMriuKtYyrRP9zdzWGBhtOr71Bll3V5xILsiwmIL/KWGpFzgeUgdyWSgIgSEaWe5iw/kBhDfVW+CQ0fwb0vNqffrbBkyZAkAD7Kxpk3mmuAx+I5wEdgalppkpPThGKxtP1659qyEgHKoB4aXHEI89ZuYNDl39ydRnAc3pY+tSr5XtVJ16E6q/E99waqunEO47TRTBa4tsixs23iLZNy84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-10 02:12 PM, Jason Gunthorpe wrote:
> On Thu, Sep 10, 2026 at 08:35:54AM -0700, Sean Christopherson wrote:
> 
> > I guess maybe we have a different definition of ABI? 
> > 
> > I'm not saying that upstream has to be 100% forwards and backwards compatible.
> > I'm saying the serialization payload itself should communicate what features are
> > effectively required.  I.e. *if* there are incompatibilities, they should be
> > naturally expressed in the serialization format, not communicated out-of-band
> > through magic numbers.
> 
> The ABI strings were introduced specifically because extension makes
> the actual compatibility indeterminate by userspace. 
> 
> Keep in mind the actual goal here. Someone has kernel A and they need
> to blind kexec into kernel B and NOT have the machine explode, or all
> the VMs sitting on it lost.
> 
> Meaning you must have a way to determine before the kexec if kernel A
> is producing something B will *accept*. Accept is not "parse and fail
> with EOPNOTSUPP" like most uapi schems. Aceept means bring in and
> actually fully support and use.
> 
> So how do you solve this problem? You MUST declare in some kind of
> manifest exactly what ABIs are supported, in some way.

I think this series solves this problem in a fairly clean way without
relying on version numbers.

Each ABI is now extensible with a set of structured featured flags that
are exposed to userspace. Userspace can inspect the flags that the
kernel supports and confirm the next kernel also supports them.

I think there is still room for improvement, like determining what
features are used at runtime rather than statically at compile time, or
allowing userspace to disable use of certain features to control
compatability, but I think these things can be built into this type of
model.

> > The scenario you describe fits exactly with what I am proposing.  
> 
> It does not. What is really wanted here is to tell kernel A to only
> support ABI 1 for memfd and so kernel A will fail to serialize if it
> cannot do it because a newer seal flag was used.
> 
> We do not want to succeed to serialize then fail to accept after
> kexec and have a dead machine.
> 
> This is not anything like a normal uapi compatability problem.
> 
> > actually starts using the new sealing flag, the CSP can downgrade to
> > older kernels at will.  And if the user cares about downgrading,
> > then they need to prevent the flag from being used until the new
> > kernel is rollback-safe and deployed to enough hosts to prevent
> > stockout.
> 
> Yeah, CSP broadly has to do exactly this across a wide range of
> topics. It is a further reason why this feature is not exactly usable
> by a "mainstream" user :\
> 
> > > This is why I think the very idea we can support any version pair is
> > > too much to ask for. We should focus on supporting a small set of
> > > version pairs and not making it too invasive or hard in the kernel or
> > > on the maintainers.
> > >
> > > Thus live update within a stable branch only is my proposal for
> > > upstream support.
> > > 
> > > If it really succeeds at that and it becomes very popular, then let's
> > > discuss upstreaming doing additional version combinations.
> >
> > Why on earth would we have version numbers in the first place?  IMO, monotically
> > increasing version numbers are flat out the worst way to communicate
> > features.
> 
> As above, discoverablility is a key requirement.
> 
> Each version number is a very specific upstream defined ABI, in the
> sense if kernel A emits version X and kernel B accepts version X then
> kexec *must* work.
> 
> You can make some manifest in other more complicated ways, but I'm
> deeply skeptical that is really going to bring any value. It feels
> like it is just increasing the testing matrix :\

The value I see of the flag-based approach over the version-based
approach is:

 - Each component can have one ABI struct that extends over time and one
   serialization/deserialization routines, rather than N for the N
   supported current versions. Supporting multiple versions within a
   single kernel would be required for upgrade/downgrade. Maybe there is
   a way to make the multi-versioning support maintainable but it seems
   like it will be messy to me.

 - Features can be managed individually. Let's say a downstream user
   wants to use a new upstream feature. If we had a versioning model
   they would have to backport the entire version delta from their
   current kernel to that feature upstream. With flags they can backport
   and use an individual feature.

I agree testing matrix becomes more complex but maybe that can be
mitigated with your suggestion that upstream only "officially" supports
(i.e. tests) some constrained version sets like within a stable branch?

>  
> > > > I could see things like HugeTLB not working if someone booted the kernel with
> > > > support for only 1GiB pages and then tried to feed it payload with sub-1GiB ranges.
> > > > But to me, those sorts of things fall into the "well yeah, don't do that" category.
> > > 
> > > Okay, how about worse, todays kernel has hugetlbfs and there are
> > > patches around to luo serialize that. Lots and lots of talks about a
> > > post-hugetlbfs world out there.
> > 
> > And?  Adding a compatibility layer to a future kernel so that it
> > understands an incoming HugeTLBFS payload should be trivial.
> 
> From my experience that's optimistic :(
> 
> > > Do we want to constrain what is possible to ensure we accomodate this
> > > hugetlbfs serialization? I vote no.
> > 
> > In what way is providing strong ABI guarantees for individual components
> > constraining HugeTBLFS serialization?
> 
> I bet it will. Other things we've looked at seemed to be like that.
> Even the above about "yall screwed up" with memfd has the problem
> already. I don't believe we can ever do this so right that it won't be
> constraining to the kernel internals.
> 
> > > Do we want to reject the hugetlbfs serialization until we have a year
> > > of debate outlining every possible ABI scenario? I also vote no.
> > 
> > That's a bit of a strawman argument.  Is designing a forward-looking ABI easy?
> > No, but IMO "a year" is a massive exaggeration of the effort required to come up
> > with a scheme that can survive a variety of plausible upgrade/downgrade scenarios.
> 
> Have you tried to get anything merged into the kernel lately? I've got
> lots of uncontroversial stuff pushed out past 4 months already. Some
> luo patches are close to a year already and don't even have any
> controversy.
> 
> > And again, I'm not saying we have to support infinite compatibility.  
> 
> Okay, I said same stable branch only, do you have some wider
> limitation in mind?
> 
> > > Should we make a downgrade round trip a downstream problem? I think
> > > so!
> > 
> > Hard NAK.  There will inevitably be boundaries that cannot be crossed, but I am
> > not at all ok punting on downgrades.  To me, that's basically saying "we want to
> > add just enough support upstream so that it's not too painful to carry full support
> > out-of-tree".  That completely goes against the spirit of open source and upstream
> > Linux, and I want no part of it.
> 
> I generally agree with you sentiment, but I think this is a unique
> case. I've asked around a fair bit, this is sufficiently complicated,
> requires alot of userspace that the CSPs are not open sourcing so has
> a very minimal usage foot print out side their world. I found one
> other possible user that might be more open source oriented..
> 
> So, if I was feeling unreasonable I'd say stay out of the upstream
> kernel entirely.
> 
> Though, I think this could grow and maybe some open source ecosystem
> will develop around it. I don't know. I'm willing to give it a
> chance.
> 
> HOWEVER upstream is not some kind of free outsourcing for the CSP's
> proprietary forks! Do not ask maintainers to do significant and
> burdensome work that only a CSP is ever going to consume and can only
> really work in a closed proprietary environment. There is no "spirit
> of open source" in that kind of demand. I will be NAKing anything like
> that in my subsystems, I am not signing up to do live update stable
> ABI so the CSPs alone can have a better proprietary product.
> 
> This is how I come to my conclusion that upstream should support same
> stable branch only at this point. It minimizes the burden, it is a
> decent trail of the technology, and if things go well with a quality
> open ecosystem then sure, upstream can change its mind.
> 
> Jason

