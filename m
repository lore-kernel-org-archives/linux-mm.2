Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E31ECAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3F26B0010; Tue,  9 Sep 2025 10:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73BB6B0011; Tue,  9 Sep 2025 10:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8A556B0022; Tue,  9 Sep 2025 10:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B693C6B0010
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:53:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A4AB13B48C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:53:43 +0000 (UTC)
X-FDA: 83870005926.28.AE47225
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7580480005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:53:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=yadavpratyush.com header.s=fm2 header.b=PVLNzr83;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=RPHTJ88t;
	spf=pass (imf02.hostedemail.com: domain of me@yadavpratyush.com designates 202.12.124.142 as permitted sender) smtp.mailfrom=me@yadavpratyush.com;
	dmarc=pass (policy=none) header.from=yadavpratyush.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9vTFWiJaKer1MtO0gxs+KTAg+ts1od540agigmt9RZk=;
	b=0EG58u2TNtvxLNqdcoU90qiK7qi/2OVYspWhYzHrhiILGWJOKF1gAkWvZWoKZVyoLb1Vll
	qGxrFqhNNyVV2/IQe6X2R268VMPhM7GR3alXW0v0PA0O5qNYseZlI+sM3FZa2IaUeyl7WV
	6VrJ1M/ZrQ1WmEfA2fE00R09gLYCKhw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=yadavpratyush.com header.s=fm2 header.b=PVLNzr83;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=RPHTJ88t;
	spf=pass (imf02.hostedemail.com: domain of me@yadavpratyush.com designates 202.12.124.142 as permitted sender) smtp.mailfrom=me@yadavpratyush.com;
	dmarc=pass (policy=none) header.from=yadavpratyush.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429621; a=rsa-sha256;
	cv=none;
	b=JXYP/ZPcceOk7gKEeD63/NQUXaW+dDnNzC/xclzI5VK55MO1FZL5jJGZYXpkvLrY7zy2Hv
	HK580sug0tMtq7J7VgFQTDtEH5wUtqJJFe3yrP/Yz5SITvHQYZnAvlQpLSAwdqfMql9GNq
	TMM2pbalLW550thinyrRDnkXf1T7B00=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id E6CCF13002B3;
	Tue,  9 Sep 2025 10:53:38 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 09 Sep 2025 10:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	yadavpratyush.com; h=cc:cc:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1757429618;
	 x=1757436818; bh=9vTFWiJaKer1MtO0gxs+KTAg+ts1od540agigmt9RZk=; b=
	PVLNzr83AOuPAbQA6PutuJ9cfvPUgNk9gZTKpOav/OHE6gnqQB8XLzSLciBhouE/
	g14exyw6HKeORy8Xg39Va/zTqoAg8M9zsvg4ZhXo8houc1zuFGZOmkC56W9z6TfL
	S7kXvC75aIelWB/EojYnJUHjtXDlWBcMczR2kWtp7JDDtqNL2AJZSi4AU3/FirkW
	YJniEso/G515p2mA8HO7l/V0nEaSNDaKY3jiANeWU1U+TO+RgG7rehGP43LnLDJ1
	vxezXWw1Ij0BuB93MxNO/XruLfscjVqhwTCnAupvdIneQnydiDJ2A4TlM+dbzsqG
	xscdVhExnfHrVCGVgMgHfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757429618; x=1757436818; bh=9vTFWiJaKer1MtO0gxs+KTAg+ts1od540ag
	igmt9RZk=; b=RPHTJ88tr3HtCMWPHsH+Vg6vfQMw/agxuAasMnT8aNfG9Y51wed
	SdirQMtazlCgsPf6J/QpzsT05mVuI0mbrkfHqgMpXbNLsWyqUbQc1Gri9+tptIxZ
	0ofhsUFwVV2/u0oG9emCp6uStXny1zwFBZSR931ISZBPAyLHsriBWAd5fyo/BMr/
	Wm8MZqwre/JwiqFKSL/m4UsR0K0auEnMXyrpGIqS4XSpxCkgC6TBY1AUfTvIJeB/
	CjsihFWH+UIH2LyNZUSprin4wPRmg2WcHwHdZRzGPfDTdvPZtfRZxhzvMuaZW3PJ
	lzqDIajddXA3rEr3iDoTVOsKSNK+O/7GPrQ==
X-ME-Sender: <xms:cD_AaEqmIdej0ZAmmfgojN6UQbH-J7JnVRUGk9t96_l3z5XsA_RIww>
    <xme:cD_AaEcOUnmHmFiX1aoQbhn-kRtzW7PlPTEFS1dS7435PRnFlo1G_XAIkXrFkYsDF
    Aazlh7-WaBF1WhDp4o>
X-ME-Received: <xmr:cD_AaFxmmSh2Zc0IFhUcNkXHtaRF6-GzmQsKGiN1XoFgWLKoiVrazyPNcRzCQTtg2HesxixxM6e8U5Wo5osLUIOPN2_lUqXX4KL3nBjhpump5a7gz2mU1yuV_HFtLA0oFUWdPhun>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvtdejtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufgjfhffkfgfgggtsehttdertddtredtnecuhfhrohhmpefrrhgrthihuhhs
    hhcujggruggrvhcuoehmvgeshigruggrvhhprhgrthihuhhshhdrtghomheqnecuggftrf
    grthhtvghrnhepvefgffeuffelffeiveeghfffffeikeeivefhvdeuueetfeekkeegtdeh
    heeuueeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmvgeshigruggrvhhprhgrthihuhhs
    hhdrtghomhdpnhgspghrtghpthhtohepjedupdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopeifihhtuhesnhhvihguihgrrdgtohhmpdhrtghpthhtoheplhgvohhnrhhosehn
    vhhiughirgdrtghomhdprhgtphhtthhopehprghrrghvsehnvhhiughirgdrtghomhdprh
    gtphhtthhopegrjhgrhigrtghhrghnughrrgesnhhvihguihgrrdgtohhmpdhrtghpthht
    ohepshgrvggvughmsehnvhhiughirgdrtghomhdprhgtphhtthhopehlihhnuhigqdhfsh
    guvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidq
    rghpihesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegsrhgruhhnvghrse
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopehlvghnnhgrrhhtsehpohgvthhtvghrihhn
    ghdrnhgvth
X-ME-Proxy: <xmx:cD_AaJS3X1iuruHlhRal1MjI7SwwlmenRNgzpsxu0uphebQaf1bgnA>
    <xmx:cD_AaOZYQTEeOZO9Np9v7Ox6KletTiI1mBM_ne9NDd_GmOUL-4XVEw>
    <xmx:cD_AaJT0m7Hf7fcl9TyCOikCMZcjA9SHNRkl65FWT_tpp3awHX8wXg>
    <xmx:cD_AaO4zA_Fab2hyHjLbyYq_4oTdGBP4_dfx5nld-0LuHploXCzuHw>
    <xmx:cj_AaD3mvRkuJqSP1mvg6o1X3FMPMw_MptR473P_OKvDuKMGfrA9i56r>
Feedback-ID: i93f149c1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 9 Sep 2025 10:53:29 -0400 (EDT)
From: Pratyush Yadav <me@yadavpratyush.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  jasonmiu@google.com,
  graf@amazon.com,  changyuanl@google.com,  rppt@kernel.org,
  dmatlack@google.com,  rientjes@google.com,  corbet@lwn.net,
  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  gregkh@linuxfoundation.org,  tglx@linutronix.de,
  mingo@redhat.com,  bp@alien8.de,  dave.hansen@linux.intel.com,
  x86@kernel.org,  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
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
In-Reply-To: <20250904144240.GO470103@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<20250826162019.GD2130239@nvidia.com> <mafs0bjo0yffo.fsf@kernel.org>
	<20250828124320.GB7333@nvidia.com> <mafs0h5xmw12a.fsf@kernel.org>
	<20250902134846.GN186519@nvidia.com> <mafs0v7lzvd7m.fsf@kernel.org>
	<20250903150157.GH470103@nvidia.com> <mafs0a53av0hs.fsf@kernel.org>
	<20250904144240.GO470103@nvidia.com>
Date: Tue, 09 Sep 2025 16:53:28 +0200
Message-ID: <mafs0cy7zllsn.fsf@yadavpratyush.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7580480005
X-Stat-Signature: f13wf6x3ws6ahn7ekyxoei3n9i1gg9u1
X-HE-Tag: 1757429621-661688
X-HE-Meta: U2FsdGVkX19r9Qvslo9piHS+fFoKsKqGgV4Sf3MElh1okDAv6naafS9RZNHGNPbKSdD77zfJ48JKPBQ6ijOB3fTkhmTakhqorUzi07ii0EYgWaMhA7Mgic1tY+RIdE5wq+8ooL7Sr0VIW7g3pdco43v2Ws7ufteXiq9PnBpDGfG8555mBTypZuMKJjBH5BkJAmj0ImlLpHUIFOyuLKVCHELjcWiLAL8QC+EfZAQMdd/Hav2CfpsXv1sy8aVz8KLVxlf4vCkHeJKfGmIZQovRUMzfEGg0Rpmu+5D0fJW/T365govO9obHunu9zJyafXglec2DQD3nFMcdeVhrekE6LA4qhnuWlOZzxmvbTuyfD7r8ax6MNUVKDghcLQbvtufojNDAd0lURGbpTcoUAsMLgTvzrGCeh1XPuBqOY7WhR/F0I1EZjtzyuybG4t7Wgg32h13blGjNXcXy2lzqw4vkGPGiTxcP6gg24iYSrBCQdnRBLCBus5V3e6R2AUais2rXTl5HFPoabyrLDUTokzSLoVEpbvyslxk1nX2e12VUbdvvZiia//mlTgNXT8yQeYbr8NU5Vzm37Xt3FweqaDjJ5xBC34k38XX1ot7U0k9DqX1SFNl4OBkQl58ex6pC8xesmfk6LwMWbxj9Y1P7GgzEmXeElVZLLm4n6dYFGu/z2WvvHd3/QzVpJ3utlA+GhVmCYNAxlyk/5qXWR7p4AbsGqnjFz1A82grkg4YEDu774WlHWDB/mkwSzWsAqbs6Kl4I6bH8Pvso7KqHlTF7tez1fYCaJViKUEKPdYS/lvKgFoFa098DmTIbjazZf1oTXRLgr/ByPqW/x7i+6vebgEmQmyPP94Sc1X04B3pUpRRVIdlv+2UnjIADuQh3xOkZKFKVpKuyrshe2d9ldQEtN+z9bqdKCnbkdlxD8OUXXCtlGR0AqGPmGgWpLW/1rAYPeofqnM/5oRC+OOu7phmQ2+Z
 F0j2jguh
 F9hELRwmME7Td3K5XMrNJRl27NPe9n6chPm5zgX8wALK9cv+79Faf9wT0LNq79LbZaouqOAKqfZZN82Ltil150yfKVRUKZANAVary5aEJO5ubtl/oBOlEcLdIk+Ipxs24k8CIN9HuMme9oRNY3oy/oBqNq1GEkHwRD12Qhlvi3s04pUwWTyp0AtHbwC9Br5InmZ1Y9UwsE6iKTy63Geyp4cuZJOIZwUGkQ06IgWHr9fOSMKwmbJY9zUdqmuFR3v2ETGTDXSYyPmHWf2YkMCf5rDGPhmtR845Gc0UUi3mrPkAXgax4EXWOnK/6NXVNaVPiz+uGZxPrvFLx3MOJYlRuNnR0ErQox7LXPP/a+N2bBJjAriCob4yruUiP3qYt+5F+gE/TxaWLcuVtAXM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04 2025, Jason Gunthorpe wrote:

> On Thu, Sep 04, 2025 at 02:57:35PM +0200, Pratyush Yadav wrote:
>
>> I don't think it matters if they are preserved or not. The serialization
>> and deserialization is independent of that. You can very well create a
>> KHO array that you don't KHO-preserve. On next boot, you can still use
>> it, you just have to be careful of doing it while scratch-only. Same as
>> we do now.
>
> The KHO array machinery itself can't preserve its own memory
> either.

It can. Maybe it couldn't in the version I showed you, but now it can.
See kho_array_preserve() in
https://lore.kernel.org/linux-mm/20250909144426.33274-2-pratyush@kernel.org/

>
>> For the _hypervisor_ live update case, sure. Though even there, I have a
>> feeling we will start seeing userspace components on the hypervisor use
>> memfd for stashing some of their state. 
>
> Sure, but don't make excessively sparse memfds for kexec use, why
> should that be hard?

Sure, I don't think they should be excessively sparse. But _some_ level
of sparseness can be there.

>
>> applications. Think big storage nodes with memory in order of TiB. Those
>> can use a memfd to back their caches so on a kernel upgrade the caches
>> don't have to be re-fetched. Sparseness is to be expected for such use
>> cases.
>
> Oh? I'm surpised you'd have sparseness there. sparseness seems like
> such a weird feature to want to rely on :\
>
>> But perhaps it might be a better idea to come up with a mechanism for
>> the kernel to discover which formats the "next" kernel speaks so it can
>> for one decide whether it can do the live update at all, and for another
>> which formats it should use. Maybe we give a way for luod to choose
>> formats, and give it the responsibility for doing these checks?
>
> I have felt that we should catalog the formats&versions the kernel can
> read/write in some way during kbuild.
>
> Maybe this turns into a sysfs directory of all the data with an
> 'enable_write' flag that luod could set to 0 to optimize.
>
> And maybe this could be a kbuild report that luod could parse to do
> this optimization.

Or maybe we put that information in a ELF section in the kernel image?
Not sure how feasible it would be for tooling to read but I think that
would very closely associate the versions info with the kernel. The
other option might be to put it somewhere with modules I guess.

>
> And maybe distro/csps use this information mechanically to check if
> version pairs are kexec compatible.
>
> Which re-enforces my feeling that the formats/version should be first
> class concepts, every version should be registered and luo should
> sequence calling the code for the right version at the right time.
>
> Jason

-- 
Regards,
Pratyush Yadav

