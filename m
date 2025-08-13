Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D08A8C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49A1590006D; Wed, 13 Aug 2025 09:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A67900044; Wed, 13 Aug 2025 09:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A2590006D; Wed, 13 Aug 2025 09:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE99900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:31:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80C2F140356
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:31:58 +0000 (UTC)
X-FDA: 83771822316.01.7585D4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9F67C140012
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:31:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fZfU1JX0;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755091916; a=rsa-sha256;
	cv=none;
	b=aTXFtSwrNspD7VHGCT57plk4juvVZuuGOT+PWyBB2yMF5p1eneHb4FA5zk91kKX6jUVaAQ
	tUUArOkDjenI1+uLIsibqGx3F1/QAwnVHjpyVpapS/GBNyeQZWcMQ4S8vPhKXJK0+WehNf
	sda4fR6ZWKFcK040bC52ZWKGtjDOqyk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fZfU1JX0;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755091916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIMCEwKxtZYKaR7CZ5BlpNcRt1EpvYI1jxL9U//DKL0=;
	b=35ZqEkhBrCLkI2eTBZ7btiF5F2RdhL/nT+IVNrk3O2E0UGxpAURZ+Gns+1XORDhKINJApL
	vOl4V3Cyv52mKw0TiHEZvgK54UvrkQZXgKKeT0TFlsy6R/1xGBX55SDce/4ZYOiz6JY01w
	EZk1uDDvR3K5oB2z/TK5yvJ+Vl/8u0k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12C7A45C2C;
	Wed, 13 Aug 2025 13:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D8FC4CEEB;
	Wed, 13 Aug 2025 13:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755091914;
	bh=LBaV36kinhS2YmnWCqdbe4NeUbgwg6zlvagH3E1PDKk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=fZfU1JX0513KY6RQ5u4CA1XReF2EwtSPUl9mGOG2aKqICidDoOBi1VkOMqlX2VQkr
	 OmmEn6gT/3VhI+vewT9+KaGsxvhyTKuB6GzefoHfcuAiK17iXvoIQRNBWPfOXiCOOn
	 dxtEPT9Ia7jS+9wJ3RLJCLhWGqcDynOjlBif1A1V1LwSNnuo8T73ndSkvh3LJJv7Gy
	 jAmazTTM6rLVo2W2fVYwP4bDT6qaLVXrA2YKdmujGgIWGaWrby/410iyVA6db7J2/B
	 UnxdYeWn7Ec92oRndFFDFnF2fE0poDi8GSBkUJrMwP0kDKYGc+cudBBzKxPOS3P4sy
	 PCBNuNYmFdTpA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,  Pratyush Yadav
 <pratyush@kernel.org>,  Vipin Sharma <vipinsh@google.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  jasonmiu@google.com,  graf@amazon.com,
  changyuanl@google.com,  rppt@kernel.org,  dmatlack@google.com,
  rientjes@google.com,  corbet@lwn.net,  rdunlap@infradead.org,
  ilpo.jarvinen@linux.intel.com,  kanie@linux.alibaba.com,
  ojeda@kernel.org,  aliceryhl@google.com,  masahiroy@kernel.org,
  akpm@linux-foundation.org,  tj@kernel.org,  yoann.congal@smile.fr,
  mmaurer@google.com,  roman.gushchin@linux.dev,  chenridong@huawei.com,
  axboe@kernel.dk,  mark.rutland@arm.com,  jannh@google.com,
  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  tglx@linutronix.de,  mingo@redhat.com,
  bp@alien8.de,  dave.hansen@linux.intel.com,  x86@kernel.org,
  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  parav@nvidia.com,
  leonro@nvidia.com,  witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
In-Reply-To: <20250813124140.GA699432@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<20250813063407.GA3182745.vipinsh@google.com>
	<2025081310-custodian-ashamed-3104@gregkh> <mafs01ppfxwe8.fsf@kernel.org>
	<2025081351-tinsel-sprinkler-af77@gregkh>
	<20250813124140.GA699432@nvidia.com>
Date: Wed, 13 Aug 2025 15:31:44 +0200
Message-ID: <mafs0bjojwdof.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9F67C140012
X-Stat-Signature: gynm38g9feqaiddsm8pa6ghiiprqazfx
X-Rspam-User: 
X-HE-Tag: 1755091916-104173
X-HE-Meta: U2FsdGVkX1/jutdPQ1Rhwt47v+SZHxC5j3ME57r+ER7Avyw82YhJe3DOLoXaupB3tUpup+PqO5pX8IEmVyAT/voA3ILtCxrBM+kNQn4piMYCQp0bxxScTk1WC2kanT/8FNiFceRHJJ8p4OPDhbB7VO4sH86r1vzeUoNnrbkwS64qAaYenO10pz5q/kJvEq578t/aKLx9Uu3UWhaY6BdZKfKFmaYWhTbimkuXWHV4QTP8bMuBWG5FP+zuxV2pNZ6OwY37EXQgBj+rbi6lOfvmsmjn80krs6UAFwPXdeFsr6IDWQ9tbp424EuiUe6f/q6nAqCOJAOCOCbCdM04P/f6PyPORqGsRVkKum1zo+vB3GCj/qgCaWzLAkJQoRxNsIzY7OqbQYS6EQkUxJhllzhcsZGPNyuRmsyHXyDe8oezIGVJP5rJZ8dioEu581ceUGtLhDzK8GDJyj6UsifP+Wwt4MO3WfborS5j/ZdNegiU+E8e+QZQ+uTgDM7tkxBm2hJ8i8E0dS8B0fQraoj8fK9vXIiWVcSWgtIKwpewq34+xHloigHy344eEVG7Wxja0htjv5FYkgifewIh3i9qAg2qX2WRPl9anmaiWQ8Y+3gAdqpO7CjUPsqLAj8/dR6fpADWxibY/0fArCoSFKebdb1MQviORHQ6A32DMh3sIMwpPP980VNvS4cjk2gKif3xGx4JFJZACZxJMYQpZwoqhbNAeITMCKT0Oq8GxAH03fnZGEP2TJlVTZdCe8u0idHSFEzi/4AXfmD/ovopLfYLZTKfNOH7YcdDHUfgySL3a+vXfU6Gk8w/cOwEZOCRaeqyVDG1N0h3briqgTLwGpOeQ1f+yscDRj6WaOEbh+tykAsFFejwrzZN0Wm0dVJS1A7CU1uRQ4CAufSQNHq4bvWTNfxoGYe/eK5EtcQfyKQdfv5tyPBy+NyL6wKjyfk/ope107ArO1pRv+SBjivbJX1R8tR
 JAfwsTQQ
 pPrP0EWCvgipw/pVryZm/Q6TXLno1U0t/hj67+xQbq04srSlB2xUcx004gh92BkLAajNGTorZTZv5Ntntli0zBsPhA35G+5hzc0lUmYj5+Jd0FcYDKuwElh8Q+DqT4zJN/Xfdevd1Z1F1e28asfY58BiSoKwyN+WJ3TrM8j4AQThkBcL8tJDO9SorzYJqeXiQj6WWnUT4uVMlBS2ygDCfDeWA3xzj+VINzStI4VTnovCs0GfzTBXnY0UJPtymLricRzf6tYSeiR1+jqzykvysS/d8LeTfC9uByzNytoDJf/9MpPPyxbYmHc+vThK5x217AEgNuSnRZfCtkB4o1pl2Wa6xJlmdTrWMLurHALTs+FNpnFBf2nW67rCx2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13 2025, Jason Gunthorpe wrote:

> On Wed, Aug 13, 2025 at 02:14:23PM +0200, Greg KH wrote:
>> On Wed, Aug 13, 2025 at 02:02:07PM +0200, Pratyush Yadav wrote:
>> > On Wed, Aug 13 2025, Greg KH wrote:
>> > 
>> > > On Tue, Aug 12, 2025 at 11:34:37PM -0700, Vipin Sharma wrote:
>> > >> On 2025-08-07 01:44:35, Pasha Tatashin wrote:
>> > >> > From: Pratyush Yadav <ptyadav@amazon.de>
>> > >> > +static void memfd_luo_unpreserve_folios(const struct memfd_luo_preserved_folio *pfolios,
>> > >> > +					unsigned int nr_folios)
>> > >> > +{
>> > >> > +	unsigned int i;
>> > >> > +
>> > >> > +	for (i = 0; i < nr_folios; i++) {
>> > >> > +		const struct memfd_luo_preserved_folio *pfolio = &pfolios[i];
>> > >> > +		struct folio *folio;
>> > >> > +
>> > >> > +		if (!pfolio->foliodesc)
>> > >> > +			continue;
>> > >> > +
>> > >> > +		folio = pfn_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
>> > >> > +
>> > >> > +		kho_unpreserve_folio(folio);
>> > >> 
>> > >> This one is missing WARN_ON_ONCE() similar to the one in
>> > >> memfd_luo_preserve_folios().
>> > >
>> > > So you really want to cause a machine to reboot and get a CVE issued for
>> > > this, if it could be triggered?  That's bold :)
>> > >
>> > > Please don't.  If that can happen, handle the issue and move on, don't
>> > > crash boxes.
>> > 
>> > Why would a WARN() crash the machine? That is what BUG() does, not
>> > WARN().
>> 
>> See 'panic_on_warn' which is enabled in a few billion Linux systems
>> these days :(
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

Yep. And if we are saying WARN() should never be used then doesn't that
make panic_on_warn a no-op? What is even the point of that option then?

Here, we are unable to unpreserve a folio that we have preserved. This
isn't a normal error that we expect to happen. This should _not_ happen
unless something has gone horribly wrong.

For example, the calls to kho_preserve_folio() don't WARN(), since that
can fail for various reasons. They just return the error up the call
chain. As an analogy, allocating a page can fail, and it is quite
reasonable to expect the code to not throw out WARN()s for that. But if
for some reason you can't free a page that you allocated, this is very
unexpected and should WARN(). Of course, in Linux the page free APIs
don't even return a status, but I hope you get my point.

If I were a system administrator who sets panic_on_warn, I would _want_
the system to crash so no further damage happens and I can collect
logs/crash dumps to investigate later. Without the WARN(), I never get a
chance to debug and my system breaks silently. For all others, the
kernel goes on with some possibly corrupted/broken state.

-- 
Regards,
Pratyush Yadav

