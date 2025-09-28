Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82DA7CAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 14:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC398E0008; Sun, 28 Sep 2025 10:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BACC98E0001; Sun, 28 Sep 2025 10:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2898E0008; Sun, 28 Sep 2025 10:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A54E8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:41:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3DBF052538
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:41:59 +0000 (UTC)
X-FDA: 83938923558.22.7E48BE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5AEB6180008
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:41:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m0Iw+J01;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759070517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxygTYPsyDIO3n3TnSdkY5wM9WsVygTw8LCKh40a5Zo=;
	b=iEY+fKRqRblsFFT/hgfclVIu3MO2uWRHp0/oxhEkzzCFyhhMrZ7AlhJzSDEH7PE5ZOk65p
	frKVJ9CD4mE2puM6YIC1xLi0SnTx/OqePramDJR4OYIDTiCqN3vfIUgOOB4AApNucg9zF1
	U4TYL415NZEZ39nBLiGT9+pPMidXhHM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m0Iw+J01;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759070517; a=rsa-sha256;
	cv=none;
	b=OLDBx1g7Itd0+fz8eDo7ZKFOdg0C7K2MDmQE0UgfHdXnMCErMLKQndOp21ickSONOBA2tf
	SDZn+Fbnn57tHkhFFtkBJOT3wi5RTQlSNOXKGdlIRGRmAFROKftGkbcwf/3GOrPtkjhkGe
	xJubpHHHPerf4IP3NM6fibEfbkSC/Qk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9018F62175;
	Sun, 28 Sep 2025 14:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAF9C4CEF5;
	Sun, 28 Sep 2025 14:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759070516;
	bh=SzzdI+GX07mAERTWzTnj3dkki2cHhdg6x0GIVS4BA9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m0Iw+J01S0fGdnbq0MAZ6PTKcjL5BY1ZlP4amzY+Kn/GmtCBnY9dg7UsSWwM1Yorm
	 Cd2dsk1mHNjW5aDtyRHfS5v+K5t2fQOYDgVR5NhZ53bD4iWJOh9aqzXG45qM4Blxir
	 0emDc2Vs5ir0T7W06O8Fnia5yaxbnYy1kEdS1AL2SWBMsPd+xvmeAr2t1russfADFJ
	 LmwTnZaw7OCcQLjHiCJtpMNOS8JnuYDb2HudfgMCMcvg9vgongLpQPlPYArVRORTR/
	 sLwXxYgBzKeBbQ30FVP+VRBHnkyPf4N2ZhvocRvD2jIuO43CU8/sbkK4yek2c/W59H
	 iH7YAtiOApm1A==
Date: Sun, 28 Sep 2025 17:41:52 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
	linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, multikernel@lists.linux.dev
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture
 support
Message-ID: <aNlJMAHhFE-O3IX9@kernel.org>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <78127855-104f-46e2-e5d2-52c622243b08@gentwo.org>
 <CAM_iQpU2QucTR7+6TwE9yKb+QZg5u_=r9O_tMfsn7Ss7kJbd9A@mail.gmail.com>
 <aNZh3uDdORZ5mfSD@kernel.org>
 <CAM_iQpWXFQwtayT7Zv7iJd7zQZ=rX_P1ZK2P11-6ohRhLpg7Xw@mail.gmail.com>
 <aNlErhpO1g17gdgM@kernel.org>
 <aNlH6-hFc6OmDF_e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aNlH6-hFc6OmDF_e@kernel.org>
X-Rspamd-Queue-Id: 5AEB6180008
X-Stat-Signature: 86dyxa5bgsjkmtzmstxab3ebtg7nex4z
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759070517-317767
X-HE-Meta: U2FsdGVkX19T3KGTvVLeMnKLVRTf/t7wQycXZi7JK/KXjpaCXrz+0cUx2sosx6wnlkWrAffWhCi4ZH9DNa1MOGRN2HHaE/QjViGVPF2rttL8Mz3k640SKcFuJx0tHwiKtExmAfbCdGIuLRMSSbx71hqbgdjSr07fkeBY+qTEYyzLKPRYWdxINgK6DBpLMfTxe91oy+psfYy5OuRNUSLmVfZGFB4Wk9PaW4vpSXcosatrYyfDsdxUb4ancX06jHs9H6FRfoiEa3GhaTPmf418Qnpl0dFuUAfX+6h3P+Ww/OZxE4GgJgw5QmNXKso/tkt0SxObcDkTeteosksKLj916yTJAZz7tsvy6edljDPDFYPmBLst8C/VYLFrw1IB2KH1wk+q4i9nH7sHAz4/QB7ij7qypJzD6LCN7Pdf5b7xdtq18keXU8C7uhJQyteOlw9EuxLs2sIZdAxE2homm25okbUTQCiImbjAhjfJhmhuS2+mXC50RSAQT50Ggj1uJqp+NiNZTOxDdzwDPjd7AgcD0RZr81EfY3PVSJB1fE77P1yM5iY+DTnG2JRrJfPAcpzIDvJVdQArXa0hJAbLnJUnN/+lnv1iZNsTVQw5IcsHBRKki0llvraSSFh4LsRxGtB2eCl8ke0/hE9YhiV6R9R6G4g79M6Xi5d9Pk0lgNPZNcSnfzrAYCfcwkaZg2CLBkODA4WP0tbRclPDPpB+F36rQZlAGbNMPTcVZxNVT6zu3bFG2hY8RzQrY+K0X2Y5aiN2MyhxKs+4Q8k3ZL0y/ZpUgIhWQ/LJ5IRLnZad8H0dPpa83r2UAmoZrrcCiMbQTFFhr8uGrKCSKdZmIlQbUK/HArYB9JWbEIg71P6pb/PNpv+mo9Z0Cj2cq03knPPvRHQNtyeztVtyzzXUMhFOT1qloflXIBOVJsx0S/zaCLBG+pxq/1+nH4G/6RgbOnNkeKGFeM5bcxziXvqlMyKo1b7
 q3TydVKA
 NAow6sj+Ds+Xp72DDuO4PVBAknS9YpSeeM1UwLx7zv5u8fm8FG+SIZsWuH+ZnZhBZq9VO0HNhPkhXbL0v0OpEKT4pDNcEGKRZmO9ycRiBPUIVmYuL+FLowFBR3FnWQ0SG4dJDUXiMTmV4dCv1hEzDRO4pPYZTJXr3cjPiml8uoMEEnovQ6HuDHuYb14VnJSpAxYir2kkR+nhzN8N9qyi50wBe8qaH4yAsAIZWmnPTdxjUE4Dz+58c2TzWpSD2aSy3y8W9ynoY/bV8hayOJePq0o/QXeJpctu7UJTLEWipxvZs+nasH0qT5Qq3DpqPXAK6M10S1GUInkQq2uwF6mUR3HN3lY8KwqlCwT0P5uc+qOpdHzMhBfs+3fqmJsfEuaTpVhbAf1qZRFwB9PlYHFG5x6O1wBgtW1JmeXggCvIafKNAyq3BSt8LePwlfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 28, 2025 at 05:36:32PM +0300, Jarkko Sakkinen wrote:
> On Sun, Sep 28, 2025 at 05:22:43PM +0300, Jarkko Sakkinen wrote:
> > On Sat, Sep 27, 2025 at 01:43:23PM -0700, Cong Wang wrote:
> > > On Fri, Sep 26, 2025 at 2:50 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > >
> > > > On Wed, Sep 24, 2025 at 11:39:44AM -0700, Cong Wang wrote:
> > > > > On Wed, Sep 24, 2025 at 10:51 AM Christoph Lameter (Ampere)
> > > > > <cl@gentwo.org> wrote:
> > > > > > AFAICT various contemporary Android deployments do the multiple kernel
> > > > > > approach in one way or another already for security purposes and for
> > > > > > specialized controllers. However, the multi kernel approaches are often
> > > > > > depending on specialized and dedicated hardware. It may be difficult to
> > > > > > support with a generic approach developed here.
> > > > >
> > > > > You are right, the multikernel concept is indeed pretty old, the BarrelFish
> > > > > OS was invented in around 2009. Jailhouse was released 12 years ago.
> > > > > There are tons of papers in this area too.
> > > >
> > > > Jailhouse is quite nice actually. Perhaps you should pick that up
> > > > instead, and start refining and improving it? I'd be interested to test
> > > > refined jailhouse patches. It's also easy build test images having the
> > > > feature both with BuildRoot and Yocto.
> > > 
> > > Static partitioning is not a bad choice, except it is less flexible. We can't
> > > get dynamic resource allocation with just static partitioning, but we can
> > > easily get static partitioning with dynamic allocation, in fact, it should be
> > > the default case.
> > > 
> > > In my own opinion, the reason why containers today are more popular
> > > than VM's is not just performance, it is elasticity too. Static partitioning
> > > is essentially against elasticity.
> > 
> > How do you make a popularity comparison between VMs and containers, and
> > what does the word "popularity" means in the context? The whole world
> > runs basically runs with guest VMs (just go to check AWS, Azure, Oracle
> > Cloud and what not).
> > 
> > The problem in that argument is that there is no problem.
> 
> If I was working on such a feature I would probably package it for e.g,
> BuildRoot with BR2_EXTERNAL type of Git and create a user space that
> can run some test and benchmarks that actually highlight the benefits.
> 
> Then, I would trash the existing cover letter with something with clear
> problem statement and motivation instead of whitepaper alike claims.
> 
> We can argue to the eterenity with qualitative aspects of any feature
> but it is the quantitative proof that actually drives things forward.

I'd also carefully check as per modifying kexec that more complex use
cases are compatible such as IMA. I don't know if there is an issue with
secure boot but I'd make sure that there is no friction with it either.

There's also shared security related hardware resources such as TPM,
and in this context two instances end up thus sharing it for e.g.
measurements, and that type of cross-communication could have 
unpredictable consequences (would need to be checked).

BR, Jarkko

