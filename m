Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06414CAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 14:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1687E8E0007; Sun, 28 Sep 2025 10:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140128E0001; Sun, 28 Sep 2025 10:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D1D8E0007; Sun, 28 Sep 2025 10:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E65CB8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:36:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 743DA83CD2
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:36:34 +0000 (UTC)
X-FDA: 83938909908.21.6D16058
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 00C4D14000C
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:36:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=phvoTT7U;
	spf=pass (imf26.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759070193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvzJto+15P7BALZuWOJuYOnk2NcAl2NBEH3Q0XdVu7Q=;
	b=F+5In9mutyrEV6wErfwkNETgESDsIqsWTigfqK77JGpwv6j+2XVNLx9SRMYDUdGzyL8Lot
	Kcs3KeXJvREb+ksNtr2IJqoCiDdw807EvJoC86nbiit2udZTbh5di2EzvmNEOQrc1RZxba
	64NVmURhFmndLdWOtCS2+xbMKrg6MVg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=phvoTT7U;
	spf=pass (imf26.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759070193; a=rsa-sha256;
	cv=none;
	b=A6EzLi0IKbub8ZwT3/NzoJqvTATzzC3Ojh9Y56QmI/HzGmBMVAsZ4sgeVLo9ImRE7c4PEE
	XaGrdt2s6XYLpMQ8nlfn7MIQkpqcxy8uk8BGdnApf9B8fH/Xh1ptTb972eLpgJAV5Ohwst
	yPm8n8qDJPMplRtLRrAjbxItdshY4aQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A5F960281;
	Sun, 28 Sep 2025 14:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72425C4CEF0;
	Sun, 28 Sep 2025 14:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759070191;
	bh=xjQLvrKt9akl9GuheEGr+P2uPV9FsTvq0tDl6rUUN+o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=phvoTT7UCIJjosOrV+WiY/ecV/D1sXuKIFi3R8TrX2Pns5qbLfpmiAmNrA1RZGaPg
	 aQNii2M3zKe1t490lqauPgolU6NFPn5TBq/jSXWYFKAML2rCg7S9JJcIxzp0UE+9Ph
	 CKQdGxwbd3IRDhNVmUgS2dI5aKBcNxHp4aEHDaU9Wn9Yw1aApFd42OrD9JXzLUyU0u
	 tnIlR+X9Y6Yh2G0h3/7z74HnJBmr8P4JBm/0wxUIWtpEsU3KqAsSqC9OeTqRM6wJPd
	 C6QbDTQRHb/y8jMJ5M3AqrL2+yFENt7MSaboP7shXcD/8B6u7lsh3qrgdTrd+Il1yB
	 IrPvpXWO85q1A==
Date: Sun, 28 Sep 2025 17:36:27 +0300
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
Message-ID: <aNlH6-hFc6OmDF_e@kernel.org>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <78127855-104f-46e2-e5d2-52c622243b08@gentwo.org>
 <CAM_iQpU2QucTR7+6TwE9yKb+QZg5u_=r9O_tMfsn7Ss7kJbd9A@mail.gmail.com>
 <aNZh3uDdORZ5mfSD@kernel.org>
 <CAM_iQpWXFQwtayT7Zv7iJd7zQZ=rX_P1ZK2P11-6ohRhLpg7Xw@mail.gmail.com>
 <aNlErhpO1g17gdgM@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aNlErhpO1g17gdgM@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 00C4D14000C
X-Stat-Signature: i913qdeqf43ahwi67kfzebs78wc8551b
X-HE-Tag: 1759070192-458547
X-HE-Meta: U2FsdGVkX19JeVrAS7geMTRMFp+/ygawl+nfGoscLEH0bC382n0DbSR7ShgRb/XE93uXlk+QoyER+Ex+CGw41CSA9wHaIUcWdziIXSkOTSRjThH4jxdwezDEniCpIewVHt6ca5hpcRXD89CBELtlto3K4wLmb9xUKuSpO5XwhBzonb7OS0R9RMB5u3b2xZxzm8KtEOby/3ima5PBOk2ioef+EZqwCu9Hmz6WADeIEmTQuZE4WhZbMeb0PLPF+fAOaPX6xwSqON6RFkKaL9FhfYfLZlZpqAUqloQcBwoPjyMcdw7a7tPss+0Ghm/OnaAcIltU4vFKq9YJDCJJdixrlgun1aHMc3plOEGYF0Tt+boX84Hr1IdaVFx3EVX82zReQG+VKllQhZUaAuyb453zY/ASFek8qfCKhAkUH/vgfAPnuiKiEskrd56+alHbi9RW7izAvNjCKcSl+DwiCfd6g9D6haF38iKmai8yOVpkJNK28+BVhE3iIJJ/HUtL8XLXrsXHjbE56+6Lkcom5MGiqfJ61XM58/PH18wR1jxsdXZrcgaRjKNCm06K+sXPm9+7vDh9PX1Vd1dnb3nlKEgld1erFWWKM91CMYboNzOTB6Ru7syUxpYx4Iqss0xHLdJQy4/mZL9H2WZt9fV2lkEj65uIaartb59y6t/AOQ1ly4u8HfgyDN+pcUR3JgxM8KE1GlrvimUvxbSUTALHTqJZ4W4lzgs960FrXXQRjGpE4jC1jCgflo2zOkwkc0yq0/e0f/Cb41dog8OLQqwB5PDZuUBLrYNwScfZoSGFJP3ME0jm0XX8IvqN5QNuW9U8sfEoUHHTz32inu4GvypNNyDg+IiqyW7sIvLogIJtuQre6tRovCGKhDVjEfuKeBupBnY/rYckQdiFf1r+lNlivIe00TED2l7V3J3jK9Te9RBO7q2CYq9ax609zYuLEud43dmkCQgI/q40s3U4/ms/K7e
 /ffOo2vU
 fIPisIRUxRubw3GOVj/JHPvL6Zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 28, 2025 at 05:22:43PM +0300, Jarkko Sakkinen wrote:
> On Sat, Sep 27, 2025 at 01:43:23PM -0700, Cong Wang wrote:
> > On Fri, Sep 26, 2025 at 2:50 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > >
> > > On Wed, Sep 24, 2025 at 11:39:44AM -0700, Cong Wang wrote:
> > > > On Wed, Sep 24, 2025 at 10:51 AM Christoph Lameter (Ampere)
> > > > <cl@gentwo.org> wrote:
> > > > > AFAICT various contemporary Android deployments do the multiple kernel
> > > > > approach in one way or another already for security purposes and for
> > > > > specialized controllers. However, the multi kernel approaches are often
> > > > > depending on specialized and dedicated hardware. It may be difficult to
> > > > > support with a generic approach developed here.
> > > >
> > > > You are right, the multikernel concept is indeed pretty old, the BarrelFish
> > > > OS was invented in around 2009. Jailhouse was released 12 years ago.
> > > > There are tons of papers in this area too.
> > >
> > > Jailhouse is quite nice actually. Perhaps you should pick that up
> > > instead, and start refining and improving it? I'd be interested to test
> > > refined jailhouse patches. It's also easy build test images having the
> > > feature both with BuildRoot and Yocto.
> > 
> > Static partitioning is not a bad choice, except it is less flexible. We can't
> > get dynamic resource allocation with just static partitioning, but we can
> > easily get static partitioning with dynamic allocation, in fact, it should be
> > the default case.
> > 
> > In my own opinion, the reason why containers today are more popular
> > than VM's is not just performance, it is elasticity too. Static partitioning
> > is essentially against elasticity.
> 
> How do you make a popularity comparison between VMs and containers, and
> what does the word "popularity" means in the context? The whole world
> runs basically runs with guest VMs (just go to check AWS, Azure, Oracle
> Cloud and what not).
> 
> The problem in that argument is that there is no problem.

If I was working on such a feature I would probably package it for e.g,
BuildRoot with BR2_EXTERNAL type of Git and create a user space that
can run some test and benchmarks that actually highlight the benefits.

Then, I would trash the existing cover letter with something with clear
problem statement and motivation instead of whitepaper alike claims.

We can argue to the eterenity with qualitative aspects of any feature
but it is the quantitative proof that actually drives things forward.

BR, Jarkko

