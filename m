Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43248CAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 14:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DB048E0006; Sun, 28 Sep 2025 10:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2DD8E0001; Sun, 28 Sep 2025 10:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C81C8E0006; Sun, 28 Sep 2025 10:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BFA18E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:22:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0ABA91A011B
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:22:46 +0000 (UTC)
X-FDA: 83938875132.15.CA6495E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5B64CC000C
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:22:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TIaEscUT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759069364; a=rsa-sha256;
	cv=none;
	b=DeO8/GEEqtHl/NwU0vxIVKdq0NrLYkInB2XrMmlbPz+/RKtt1i151TIwKf7V2HHAsGoGn8
	omdaeAr1QxTjkSdAIXZ+9g6dqVQQMWY3TdiszOUYfAorLfDyp6qVEVhMFMdxTkQ//xOpio
	9YcHeLFLellr03/lie5JxjwibiI0EyI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TIaEscUT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759069364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=40XsfutwklaTrh/ktA8dOMMeeLMpZtvmLMYd8gv8sBc=;
	b=H67ELV7dlf770vJlro/Km3e+lL8sWn3MWTNZVgoA2i/aJy0NnkEqlzbApoBkEHsGvpHFx6
	yIBAANB2vCQykoaRX1C+6xQZ/DXqqkF3JGPK4XhnHzSq0KN+suxFiaZ0nyrEliBKNBapbH
	ROKfaSwm5BEqx/ckll8zpJ8yaCibPV4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4319644260;
	Sun, 28 Sep 2025 14:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA39C4CEF0;
	Sun, 28 Sep 2025 14:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759069363;
	bh=Wg1xrNCbGg8db7MqipyCxrrsmMoVbFCLhcRL36NHECw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TIaEscUT6E8LJ+NgIrEGjJB2yfmv0DOXQQ3iMgMZewcagvseJj47Zq7TbBcssaQgr
	 rGIH8EVofkWfFbNGyD9UNbpBzi0pz53pYgVouaJYpMKlmDvy9TBwMU+olwn269wf9J
	 T41s4Q3jouYy2lr5tDBEQeiT/eoFSGDOpL0XPUbw3HPWZzVFw+J1z4pE4VH/K+coWe
	 +c/sMEtUxdRwap2G1mPwgXnfFvVaq8LZWqUcrV5n0ZbIzim4JDZucgNI0bkZKhnNWH
	 GRpY/iuBWdp1Ds9iYdYd19AHQgmgAmb9vfi62Kfzhqnu81lPLCvD1oo91CKyc1gyRj
	 N9WRiNJ694s/w==
Date: Sun, 28 Sep 2025 17:22:38 +0300
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
Message-ID: <aNlErhpO1g17gdgM@kernel.org>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <78127855-104f-46e2-e5d2-52c622243b08@gentwo.org>
 <CAM_iQpU2QucTR7+6TwE9yKb+QZg5u_=r9O_tMfsn7Ss7kJbd9A@mail.gmail.com>
 <aNZh3uDdORZ5mfSD@kernel.org>
 <CAM_iQpWXFQwtayT7Zv7iJd7zQZ=rX_P1ZK2P11-6ohRhLpg7Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM_iQpWXFQwtayT7Zv7iJd7zQZ=rX_P1ZK2P11-6ohRhLpg7Xw@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5B64CC000C
X-Stat-Signature: ofjwc5woty7rozn8chs7wnktbc1s4xjh
X-Rspam-User: 
X-HE-Tag: 1759069364-945927
X-HE-Meta: U2FsdGVkX1+IhtjYFl8DVT7oQEvdduU3m35/xpzctsDjViqv2W+f4/vhTHzej6UBgnpgPLli60Z23hN6u4kkRj4qqkdgdJs3yknWO+e5xcsvgPvMMj6M49x6cBSKPmFMUXcYTlyn+E+8Ax0tI3irQKmPew18uBsDCWO3SOsqxAudjaXFzb3hD/TUHuXtEnXd0scPZvFe9yR7Frqrbgy1NXpSJ06uHKsb1hOBZEJxcLijq+IrC7l1fBu7EeiyD8TtITznswd38AyGJyaLKcvnqz5Ud6VlVH0dhV3bCTTsZoGFQs37OrugUtymr80m8zu66kqdKq/AfNvx1CQujpsYCIcOOvC6uBMxPXlBHPsFXh7LXdWm3d7ZxH29osd8MDbLxINaCug3qPPaonRa+Sw90K8FQAAzU3zInM64E3+w5xAsuUFVPpX7ejXAO26O9XbDexafPeLR9jlg6D5lpiLtWEjirE65gmdlkB0ajH0WhVYsEGypwrue8xt7RfemQWvfDvrYXlqwZLHu2MqloOjnhFYfpjMBDn5OGJJ8+x59iacLpCBmiqseofoT45pgS7k9mA/dJF+t9HlDv77mRmPUMqfMFmEwNXSd5tgeWR68DFv5afFcuso2YNZF+GwaPfjsM5tBV0HeFXVr2poC7M48ew5cJIniRhqyxhOgGoXgQCaKKU9tm2aNy3NZ5pJRKnC1PMjUkjyE+bDEl/JuYfZrnWRgJNWLReK74LV+lt1JEMWJerdr62SD6t+e0sJja1rzFZsukQ/jhJZxZElrAGfFbsFTXPDDJsCvvtn2t0j26uRiNtTS5q5OP7W4FUrKmVArPuzG8Z/P6Kt1g3cv0GCee3Umt2+A4hmYbVYFFSpde7Lpfnb+kJn7rZu6kG0qZS8xvrNEaZQIhV5ce0hVh+R0evuqWi3dJJU/IhewfqIGJKj2KwjIKy3cKMY5/YUMjoJSvGgcvRZ+d1a45ddH8Js
 ZHexEuHA
 f8jizpTrXkVNwvtO5Fy5LijTHJu86+iTdstsnL+lJpbbyDz9MTnSfCGheqy/eUEXLurq4AlI2Bh7JyRpwWabPIwgw5LG9fuDGMuTEoPvSDqiQ99mjAIFRrcScEXPHt176QjIru/V0P38jW21/HTl0zBkatExD6hbo2rODkLe5AUFuA2UeS/5n7gQD+yckBfIH2uxdA8y0/imyYcS9o2pUloOT6HBNq1VYQn9AlQ+fEwJExPMfNqB0vO9uxxi3WfBiNUlbaLpjSa98Ieofo0GB/d0u2681JSn3S/TpTuMnTRBi3aB4z+JURlY3CCHTByP6NY1ZyJ/qnddPu0wHGTzSAAEFl+XBt7y/9y/9QkXD/mteUzdOrQLjhJ36uz07cFeqfjKLO2IGWdUHIwX1BjTylC6SWYdIzB+aNenB6QYO7B8oAzmRcxcBA6th7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 27, 2025 at 01:43:23PM -0700, Cong Wang wrote:
> On Fri, Sep 26, 2025 at 2:50 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >
> > On Wed, Sep 24, 2025 at 11:39:44AM -0700, Cong Wang wrote:
> > > On Wed, Sep 24, 2025 at 10:51 AM Christoph Lameter (Ampere)
> > > <cl@gentwo.org> wrote:
> > > > AFAICT various contemporary Android deployments do the multiple kernel
> > > > approach in one way or another already for security purposes and for
> > > > specialized controllers. However, the multi kernel approaches are often
> > > > depending on specialized and dedicated hardware. It may be difficult to
> > > > support with a generic approach developed here.
> > >
> > > You are right, the multikernel concept is indeed pretty old, the BarrelFish
> > > OS was invented in around 2009. Jailhouse was released 12 years ago.
> > > There are tons of papers in this area too.
> >
> > Jailhouse is quite nice actually. Perhaps you should pick that up
> > instead, and start refining and improving it? I'd be interested to test
> > refined jailhouse patches. It's also easy build test images having the
> > feature both with BuildRoot and Yocto.
> 
> Static partitioning is not a bad choice, except it is less flexible. We can't
> get dynamic resource allocation with just static partitioning, but we can
> easily get static partitioning with dynamic allocation, in fact, it should be
> the default case.
> 
> In my own opinion, the reason why containers today are more popular
> than VM's is not just performance, it is elasticity too. Static partitioning
> is essentially against elasticity.

How do you make a popularity comparison between VMs and containers, and
what does the word "popularity" means in the context? The whole world
runs basically runs with guest VMs (just go to check AWS, Azure, Oracle
Cloud and what not).

The problem in that argument is that there is no problem.

BR, Jarkko

