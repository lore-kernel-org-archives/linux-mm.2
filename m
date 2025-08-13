Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02CEC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD9590006B; Wed, 13 Aug 2025 09:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5AC900044; Wed, 13 Aug 2025 09:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3C590006B; Wed, 13 Aug 2025 09:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 20F45900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:00:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE65582AF1
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:00:14 +0000 (UTC)
X-FDA: 83771742348.23.C658F60
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0A68840010
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:00:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=iHkAe35r;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755090013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kb5LqNVwswEcJTfvXXUiJi9olfna5MFQNwI1rYtwD6w=;
	b=WxRaYAYvnAHK8Wrux/d9aoq/38sPS7VgheYJQQq1CUeypk9laP0CtjGkIqbhwKsBBwXEpp
	Ls10oRW6ezEqI9CykS8l32bEjBa5zCISuV2dZHkC9SlZMs4aiU/68nuknXAhUxSKK9/Dhf
	j6GnrzBUCtCgr1hh3BYN7JpEhF3W5Sk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755090013; a=rsa-sha256;
	cv=none;
	b=wWDonCZb1AV/aSsoFeHuLh30itRa6x+rWyB1cxBTwLaIbsbGJxUwUKkHC6yZ34QD4kynBi
	lhzkvg3L+URr71imDaJxjEI6B6yFKODqyIiVuhcafXyb55Dcte24Wyh9AkzUxPTktDELYu
	j1DaA2CtWK03Jgm33TeDahIpVBog4aQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=iHkAe35r;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 4429FA57CB8;
	Wed, 13 Aug 2025 13:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3948C4CEF6;
	Wed, 13 Aug 2025 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755090011;
	bh=aDg93MqIzbCDJ7vJIE6yLKnul53KhyAjtWb8ml+qZ20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iHkAe35rDb59ZjrgQqqrFZCnTIqaXOuDdWp6zvt1tpP3B819KzeRSVCjHGSrTFpmC
	 4JAbz1C5K5F1x62spsgdcFf5RN4faSIJHukqDu8llADLTXLJSvYAlzzjHIqySRpplu
	 XIIYl4MaxFu+HwXSLY/4JcPE/MigMbNNLkHojeOA=
Date: Wed, 13 Aug 2025 15:00:08 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Vipin Sharma <vipinsh@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, jasonmiu@google.com,
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
Message-ID: <2025081334-rotten-visible-517a@gregkh>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com>
 <20250813063407.GA3182745.vipinsh@google.com>
 <2025081310-custodian-ashamed-3104@gregkh>
 <mafs01ppfxwe8.fsf@kernel.org>
 <2025081351-tinsel-sprinkler-af77@gregkh>
 <20250813124140.GA699432@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813124140.GA699432@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0A68840010
X-Stat-Signature: 861f5ekpf97bots676b4kzgt8pzqsa65
X-HE-Tag: 1755090012-218109
X-HE-Meta: U2FsdGVkX19Rpsdg4qz6Zbfke00yBy9g/QppCqOaTDe0+vi49lzYFXUx2PMM7RBxR2RqxQw9kSumvoraIZw0QdWeep5yaSmPuho8S2UnDyi7/8Golvsxq8mrydVGdIiGs3wyQULwqVSZ/wXVIIXI7SmNjrxWcdhF0cFS/ayA6UZf/LkRd3WJx2Kakz+Oxq0gXJ+i7yHlrRk7sW0Lclk18FdqQPbtU3+WlL9yi03y6Gc1ey1wlxP5h42NPkbeH+k8gUzEa74CrEdv0YhMxxFh2GrbqpxX3hmu8YUtRyGytNea7hQs/EHOLsrfdbZ5/pPyA/1AGDzT33Sg+kevpjvjjZptlmb/mtzCHPmxDElX/U1NECwpyYSW9A2gSQXli5utzvILM1wQJLS2mM+IhKWUHjs7DkF3dvRipQySmVsMoQzPC6SReOacVG67YwnDWiu5lNiwRcacGAhn3n22D4wKtvKXF7/b9m5ZC37CL7q2pq/fk0IoQzoANiAL23K0cBL73BIDuxbkpJDzGl01FzDYU3IsNCoFMq+cag+p5l2MbaM96RPU/aX9p3CXAfRcLFdpIhOlrmYjr2q/G+NU7HeHf0hz9liZpMlLuNOFY+yUAigBGq4+GkOOvFJ1It2JZyHw9EvEhsP45pYQ5MFUwLAmICfiQc5NlwgnkVYxIa6hq2Auxgo4+AnQzIHQnOMDjTZ49XzAjJzFvv9eU6/2akOZNNY7pXJNHCtknLIaZCNda/abVmR/kfdL8gCwQST4P/73NNPSQc9IzRF3TGWcVR9y7b+9mFxB1WIthRnpB9BgmYVUaHdKBm5OQiYde/Ec8GlfNGYzr9dXPQ2WI4NkzGnog/VzqZM/Xnsy9Bjd2V5DctvIy+hAEUphuqW+OS721Tb1vtl3yKCWpvAtB87Fc96tSa7EfWWgtb3bp+29rvXYFfviNXYNa5Cka2oYwEhLvCenG76Ew5OAcqQQUzN86lg
 w72YZIlT
 Moz4FKWVV2O7orHi6nH+aS0PuBG+8elN1XZFh72LNemiNrxiIE88UX0zIpTEJ4hrdvvpwIAxcv2CsgZaGutm/2sLGuq/x++JRAnICpDYd2pKGzFf1QvQtKl9lL62lgInKL6FognQGDeWMc9jfLhJ5ds6fTmEhWUnx/p2lq9E7/rVbKho3BQVFH6ObpghgB0aoDiAwdTlkS0uzcCQMPnHLKCfidwZTE0vUzJo1aD6ScbBPZuhdzZNcEx2IZPGiC6Ta+jB9OK2V4cAr/Wjk/AbJn5p9pFzVd2N/IG216vFJMnlra1u7IZxfOEWL39opZlMNvl++njepucfV/6ziKti7tGPHjyherqGF39mUb/k8RkJXCeyDy/Dbfvbx52T4jyptb2DFPGWKF/jHfSDT34YlHm75STNkqd6nM08KwP4w5JlOasrg63TfQd33abBV5i25E2RrSYFVY1sTwRG3zGwQgclW/sfyPfag5IQqgWC1rUbvskBi7tKzhPxZJlLcCPq0ExnAYZg7Lwt909s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 09:41:40AM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 13, 2025 at 02:14:23PM +0200, Greg KH wrote:
> > On Wed, Aug 13, 2025 at 02:02:07PM +0200, Pratyush Yadav wrote:
> > > On Wed, Aug 13 2025, Greg KH wrote:
> > > 
> > > > On Tue, Aug 12, 2025 at 11:34:37PM -0700, Vipin Sharma wrote:
> > > >> On 2025-08-07 01:44:35, Pasha Tatashin wrote:
> > > >> > From: Pratyush Yadav <ptyadav@amazon.de>
> > > >> > +static void memfd_luo_unpreserve_folios(const struct memfd_luo_preserved_folio *pfolios,
> > > >> > +					unsigned int nr_folios)
> > > >> > +{
> > > >> > +	unsigned int i;
> > > >> > +
> > > >> > +	for (i = 0; i < nr_folios; i++) {
> > > >> > +		const struct memfd_luo_preserved_folio *pfolio = &pfolios[i];
> > > >> > +		struct folio *folio;
> > > >> > +
> > > >> > +		if (!pfolio->foliodesc)
> > > >> > +			continue;
> > > >> > +
> > > >> > +		folio = pfn_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
> > > >> > +
> > > >> > +		kho_unpreserve_folio(folio);
> > > >> 
> > > >> This one is missing WARN_ON_ONCE() similar to the one in
> > > >> memfd_luo_preserve_folios().
> > > >
> > > > So you really want to cause a machine to reboot and get a CVE issued for
> > > > this, if it could be triggered?  That's bold :)
> > > >
> > > > Please don't.  If that can happen, handle the issue and move on, don't
> > > > crash boxes.
> > > 
> > > Why would a WARN() crash the machine? That is what BUG() does, not
> > > WARN().
> > 
> > See 'panic_on_warn' which is enabled in a few billion Linux systems
> > these days :(
> 
> This has been discussed so many times already:
> 
> https://lwn.net/Articles/969923/
> 
> When someone tried to formalize this "don't use WARN_ON" position 
> in the coding-style.rst it was NAK'd:
> 
> https://lwn.net/ml/linux-kernel/10af93f8-83f2-48ce-9bc3-80fe4c60082c@redhat.com/
> 
> Based on Linus's opposition to the idea:
> 
> https://lore.kernel.org/all/CAHk-=wgF7K2gSSpy=m_=K3Nov4zaceUX9puQf1TjkTJLA2XC_g@mail.gmail.com/
> 
> Use the warn ons. Make sure they can't be triggered by userspace. Use
> them to detect corruption/malfunction in the kernel.
> 
> In this case if kho_unpreserve_folio() fails in this call chain it
> means some error unwind is wrongly happening out of sequence, and we
> are now forced to leak memory. Unwind is not something that userspace
> should be controlling, so of course we want a WARN_ON here.

"should be" is the key here.  And it's not obvious from this patch if
that's true or not, which is why I mentioned it.

I will keep bringing this up, given the HUGE number of CVEs I keep
assigning each week for when userspace hits WARN_ON() calls until that
flow starts to die out either because we don't keep adding new calls, OR
we finally fix them all.  Both would be good...

thanks,

greg k-h

