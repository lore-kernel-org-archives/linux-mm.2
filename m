Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03A2FCF9C7F
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 18:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EE8B6B0030; Thu, 20 Nov 2025 13:50:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5776B0032; Thu, 20 Nov 2025 13:50:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502556B0062; Thu, 20 Nov 2025 13:50:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 402236B0030
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:50:57 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC2B61A026C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:50:56 +0000 (UTC)
X-FDA: 84131877312.23.6F5D29D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2ABB0100002
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:50:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vOs6yqUY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763664655; a=rsa-sha256;
	cv=none;
	b=BaHMf4/JX8rKIb5H0UypQt4vEtGIa39tWhfsiwGBpo3/7jlvmAwxDRPq/XS7uTqtlbHoTr
	X0FBrH8Ldg3PZ5eJj8ydGKQf+bGu4tKx94Jxfa0ceESvqrmNqv31+x0mtfHaVDMkhQ7d/5
	jmMCuHJhEL4El2g8wU2ge9dFI36QRxc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vOs6yqUY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763664655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2bxddnxwJzuZWe9pHx9uNCf3pYU9kmZwPFpBQx5+GM=;
	b=fXNWRTdZSkgIkeuTdcvosT+13MW5fIQgR+OvNBX/7fhBn5nWAPLhjKtfeOtX5NklPP19AO
	lSGOSCF5r0ruUvZYmbBg58HMuIZBiX6Z7XWAnYnirLG/pJ0HLl1W9xatxYiy/mpeuKhcVV
	ZGnOIo2cBMnv/6HLKzAhzr/s/+tb2yU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E7F45442C2;
	Thu, 20 Nov 2025 18:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413DEC4CEF1;
	Thu, 20 Nov 2025 18:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763664653;
	bh=vPRGeK1JlWNpX03eDI4u9Y0zZmIO0F9Wudh52np23Oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vOs6yqUY+iuUwLBYPwtmKAg5456PAWbrEvmwHkMNqH4VqjEhi9O7xpwTIiIGpvGZy
	 3d2NyIVcnsWNqqbcJnDNliNJ8nEyf0GkStq3JbTUBQGa0xkdGhGt25FGuT5EClqWPA
	 Yu/6EBzI5wPk3TLaQQBW1wkSfWv+p/FYYU9VWUB00uqbLvt46Xj/Xc0/FZ92xAx3D7
	 EdtTPXDLurOV6TykBn92FQV3pbHRxACd8jc6z3H/R/N40zNZRBCrg/pczFXy3Apls7
	 UZ9ksDiH3DOcQS1C1tB8Z3QKJAYa2r6fR5MwPSCsy61j9hauRgzLW4JRNHa0DMHNtk
	 8Y1O/k79jZnhw==
Date: Thu, 20 Nov 2025 20:50:29 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 08/20] liveupdate: luo_flb: Introduce
 File-Lifecycle-Bound global state
Message-ID: <aR9i9SXGDQ6bi1mi@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-9-pasha.tatashin@soleen.com>
 <aRrtRfJaaIHw5DZN@kernel.org>
 <CA+CK2bBxVNRkJ-8Qv1AzfHEwpxnc4fSxdzKCL_7ku0TMd6Rjow@mail.gmail.com>
 <aRxYQKrQeP8BzR_2@kernel.org>
 <CA+CK2bASYtBndN24HZhkndDpsrU1rwjCokE=9eLZUq2Jhj6bag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bASYtBndN24HZhkndDpsrU1rwjCokE=9eLZUq2Jhj6bag@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2ABB0100002
X-Stat-Signature: agzjnha9ehpccz1h1aqepsg15srzn97d
X-HE-Tag: 1763664655-255706
X-HE-Meta: U2FsdGVkX18xVj7Kag4lmrCsKg9aSaP6YmVigBomqVwiUSTEN2uN8kHQKqbfOyQ8lKUUZNNAi23d2yggEsQKnoqRXE7Y419mHpeZ2l6zr4zkFyMgSM5sIRS7+CbzZ8KAzau06YjjCHInG63qKHSM2sUwj9Ko/tyulBt5m4r/HoUZFgkADBfQ00ECbLl+oT8nlVvBRA8nXRrTRT1eWwYID3e3ClTrm6e8z1I9D5G9AT1xTyCoi1YFaJSCFzKr8Y/Qj1Dg6N+viDYm5mIkQ8s0T0GktB9UAD1fRbLkfCrEMICzHmQqQhmdWyqCCYqpfkySXHu2LqYxbZnLcf0i5+xq2Tbh/bNKm+1izSPBW9EDMmf+BtMHi45TM1ec3GTLPWLIxiR869NQBgIcmhjjGi3nLVh6uKmgxcVB8MnI/1GBLWg4wItIhRcQdta9/SjAKARGGJP2bzfgEBCP27FjDIw4zpbU5dDHe9MK0lFW9pgBHYkxKgIcoOGqUTtXtEXjHYLRx0P0hkJe6xk9s+W1GG/F2UExdbAnxRbKYWZnZ8a4rfwq4j7/QhluuuMKy/I0FSE5ltPEcK65BDZ0bnJVTefH3KQLt+mOUhm3mXX/RvrzystuGD/k+oTYEEg3kqhIuhpHVZn1oixE/7eOVEoULMPbyka2UOT0vt2qSQ4nCwmTvwkTgG36nLiVIDbfoUc+gXvyhaQ2hjrRf/3krJgRrQ+pUlJ9KbtJsanKF4JPMt63vefIMbO7jm7EF268aKiziRHdia3kOdSb3K9xL9IoEP9w5T8Nbewu+xXEU/8mySYmQrBAsk0wj9dujsDEarphkOdQLYndIKzcIWfGIf1lrDaX29D3i7Fgs8mtXPnSOi5H9KfvgUCesBVUV4NmJb2ve5yCdO0bNCuLpxZ2JuLgZMGA+uhofqVHcvaL+2Wm2f5rWj1bjht90V0EmQHhBNZopINGkqt7vCRo8yoQaks14Vm
 yFd7Atzv
 CHkXGyVj2zFbc6jX3mnEw2mSk7qBYx2wPlStmUOJBJ9IzsLn0uhSMUJbD91Zk6WYfT8mnMvRvsKSjY0j+LfmxeWvdKrbzHQ2Q1eCizb8I1AGbPqOBYQPRxZV7eWP56h+Qi4EhQbF7HsJ8iY7K8d3lTkOKSvXU+NsCefts/oBJoP/Pi1qjoJ/kwxWtE/kQ0vBtObgh4aWBJTuux6tu5cMgY7Vz26mRpgwImaAFHLX2Drf59caqqmuteiUloTC1Nggb9TcIntJMPJI6qj9HfdWbesXl6dMyDTU7vj8h20fbsT5JEZg1hzvwkVHskZ28miH2bLbosbUyTqvge1V9A/8/IcW0NRxqHPRSYTMlNFmfv2UH19AJODFr08ZwcXDi3RVW2DIb3T6Hjcn+UEppqwuL71gF/hKFYgVITpxf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 10:37:30AM -0500, Pasha Tatashin wrote:
> On Tue, Nov 18, 2025 at 6:28 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Mon, Nov 17, 2025 at 10:54:29PM -0500, Pasha Tatashin wrote:
> > > >
> > > > The concept makes sense to me, but it's hard to review the implementation
> > > > without an actual user.
> > >
> > > There are three users: we will have HugeTLB support that is going to
> > > be posted as RFC in a few weeks. Also, in two weeks we are going to
> > > have an updated VFIO and IOMMU series posted both using FLBs. In the
> > > mean time, this series provides an FLB in-kernel test that verifies
> > > that multiple FLBs can be attached to File-Handlers, and the basic
> > > interfaces are working.
> >
> > Which means that essentially there won't be a real kernel user for FLB for
> > a while.
> > We usually don't merge dead code because some future patchset depends on
> > it.
> 
> I understand the concern. I would prefer to merge FLB with the rest of
> the LUO series; I don't view it as completely dead code since I have
> added the in-kernel test that specifically exercises and validates
> this API.

The test exercises a simple happy flow, but it still does not validate that
this API is what we'll be using in the end.
It's quite probable that the first upstream user of FLB will use this exact
API, but chances are that it will require adjustments to "the real life".

It does look sane, but without an actual user (sorry, but the test does not
count) it's hard to anticipate the potential required changes and potential
corner cases.

Let's hold FLB until it can be actually consumed by HugeTLB or VFIO or
IOMMU.
 
> > I think it should stay in mm-nonmm-unstable if Andrew does not mind keeping
> > it there until the first user is going to land and then FLB will move
> > upstream along with that user.
> 
> My reasoning for pushing for inclusion now is that there are many
> developers who currently depend on the FLB functionality. Having it in
> a public tree, preferably upstream, or at least linux-next, would be
> highly beneficial for their development and testing.
> 
> However, to avoid blocking the entire series, I am going to move the
> FLB patch and the in-kernel test patch to be the last two patches in
> LUOv7.
> 
> This way, the rest of the LUO series can be merged without them if
> they are blocked, however, in this case it would be best if the two
> FLB patches stayed in mm tree to allow VFIO/IOMMU/PCI/HugeTLB
> preservation developers to use them, as they all depend on functional
> FLB.

That's pretty much what I'm suggesting just without "if they are blocked" :) 
 
> Pasha

-- 
Sincerely yours,
Mike.

