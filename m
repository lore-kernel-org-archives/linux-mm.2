Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4193CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 15:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051A06B0022; Tue,  9 Sep 2025 11:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 001E16B0023; Tue,  9 Sep 2025 11:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0BD86B0024; Tue,  9 Sep 2025 11:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB44F6B0022
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:57:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78407C0668
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:57:03 +0000 (UTC)
X-FDA: 83870165526.14.C11EF60
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3AFFF80006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:57:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=yadavpratyush.com header.s=fm2 header.b=U1bZYID0;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="S 4orRy0";
	spf=pass (imf02.hostedemail.com: domain of me@yadavpratyush.com designates 202.12.124.139 as permitted sender) smtp.mailfrom=me@yadavpratyush.com;
	dmarc=pass (policy=none) header.from=yadavpratyush.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757433421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y6bB3spdv0Y4Iq27PYuVsaMwCq7a7eOlCj3k9gfZcIU=;
	b=Ju9CSsu6NsOHaXOMmihGPX0Ng+l3m0z77xFsIFN4HrbjdehIIfDDjj/1iGYnNzT0mm9sfu
	5x99NNavpOhe87rPbNXdtde0Rn21pSl2zZWiHPrivajrcw/Aeh+Hz9OjKbrrzSJjGQ4B6v
	0tR6ODI0IYdXZrqqBvAH8flpJ7eVpTw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=yadavpratyush.com header.s=fm2 header.b=U1bZYID0;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="S 4orRy0";
	spf=pass (imf02.hostedemail.com: domain of me@yadavpratyush.com designates 202.12.124.139 as permitted sender) smtp.mailfrom=me@yadavpratyush.com;
	dmarc=pass (policy=none) header.from=yadavpratyush.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757433421; a=rsa-sha256;
	cv=none;
	b=KUxjIhDv3NNxyDgcTinZSsj4nkHvw/NJOVkxx9A92XKSxfOtssT04Atczctykqt+ODA8CW
	52YXiR7E3ZQP8h0jAKG7XvaiFM4gD95xRJyLOAfIViagCZWPTRleyhOyPbMkGhLNsiiYTQ
	Z7K7IqBNIQcQC2k23m24ZqvJeZJngb4=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.stl.internal (Postfix) with ESMTP id 9BBD81300201;
	Tue,  9 Sep 2025 11:56:58 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Tue, 09 Sep 2025 11:57:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	yadavpratyush.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1757433418; x=1757440618; bh=Y6bB3spdv0
	Y4Iq27PYuVsaMwCq7a7eOlCj3k9gfZcIU=; b=U1bZYID0dy9gSV0UyWD12/SGew
	bbD2cWhycbMq/6YXT30h6iSDIxj+ocmhBR6ENxPLtk9WcRUDkyXLoHS/N4G5kekV
	0PSHqhZNQ+kpPX0CMeqj4BtaIE7dtT1rVDIR9Dq9GgvbH3K8ck1dQ1hZ7jFHt1Kl
	WoPLU5JNFFZ2ZOnnV4t7kB0p1pbUSBhvgQi2vKv57F3QN0aYClfqxn7pzBAePvTY
	qokDUIFBAQnkTlsgptWmlyNGL3sjml4N4yjvwMbiJEY6BFl+5DHlDX4TX3IptT1r
	kbf/6vlvQDX5HsDN6QH5E8Rj1SXLsNYeH1LUVYBatwY3Qb/p19aoYU0fIGmA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1757433418; x=
	1757440618; bh=Y6bB3spdv0Y4Iq27PYuVsaMwCq7a7eOlCj3k9gfZcIU=; b=S
	4orRy0PtAYfUg0t7JXdON+wH/z931lLwhRw0jzEw3RUuDOTQlfgWrSGnn+RbA3wU
	byjzMqiGYqMXkOV7JWWkKbOg68Ycx+hfK8lPQObZFYLTzxk779LN7QH76/xhEf4k
	svyfFBaXLtwMjCyO2iFfK2sNSg7h/RBaGeBpMlS7IVGLW9Uva8aQgGm78DsOr4y6
	xJsaVglN0VTAJUCYSlxzIwNWxjywIUFJGHhoh0+s1vdMP4uDePM7xl8kEQvKTVTA
	Thetj8fBU9/ka6q88UsS9D+V4t3C7gSNzKGUasaKm9PV901mTJYi65SdHtNp2UxL
	RdzjM6EI7DfSSoweeEo1Q==
X-ME-Sender: <xms:Rk7AaENFgDgG3Z0ewndwpcU0l4keNXhgvUjtzKy3PsxrId3a6-tfZA>
    <xme:Rk7AaJechYAPKky5DUGmMlq8Ww5nZhbLKxzlOzpegDkPL7yQv1ZfykSBqAw1Bp3ou
    D9M9j0yDuKLesBdxjE>
X-ME-Received: <xmr:Rk7AaDpMvXl_L_dhU7PjygEH5En7BCIxrB_rfN_ap7rG5JI5KrVL6ccaY7hEtOeDE9xTFK_1RjqiqTewgZk73fOF87TiiqVXYdIVo4h-I2d9ZcIV84onyGnG0nji-BIFe37s8FWR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvtdekfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufgjfhffkfgfgggtgfesthhqredttderjeenucfhrhhomheprfhrrghthihu
    shhhucgjrggurghvuceomhgvseihrggurghvphhrrghthihushhhrdgtohhmqeenucggtf
    frrghtthgvrhhnpedvhfdvhedtueethefhkeetgedttdeuhefgueehgeduhfejtdfhvdev
    gedvjedugeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehmvgeshigruggrvhhprhgrthihuhhshhdrtghomhdpnhgspghrtghpthhtohepjedv
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopeifihhtuhesnhhvihguihgrrdgtoh
    hmpdhrtghpthhtoheplhgvohhnrhhosehnvhhiughirgdrtghomhdprhgtphhtthhopehp
    rghrrghvsehnvhhiughirgdrtghomhdprhgtphhtthhopegrjhgrhigrtghhrghnughrrg
    esnhhvihguihgrrdgtohhmpdhrtghpthhtohepshgrvggvughmsehnvhhiughirgdrtgho
    mhdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheplhhinhhugidqrghpihesvhhgvghrrdhkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hlvghnnhgrrhhtsehpohgvthhtvghrihhnghdrnhgvth
X-ME-Proxy: <xmx:Rk7AaOik0Nhivpz4N1I59xuLqAM9GAZwpQ2ESwBHdZQFSZk92N3TEA>
    <xmx:Rk7AaEZSZ-16sSEApBkT5RUE-BBpobsQDg-uXUmqfXLQlUPRSz7E9w>
    <xmx:Rk7AaJtmxu4H6qR5NIpgFu2D4ATeJCF0_IWw64bsgr7jK4wE_9nTuw>
    <xmx:Rk7AaHJrbTSZ7kj3UB9FV9vpMu-OJj4TthDLmDwssmSHC9inZhbChw>
    <xmx:Sk7AaIDsIumQfKmeMLRrTl3mf3szS47iGZnmx_wjwi5i_VkrMX-Yzc1a>
Feedback-ID: i93f149c1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 9 Sep 2025 11:56:46 -0400 (EDT)
From: Pratyush Yadav <me@yadavpratyush.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <me@yadavpratyush.com>,  Jason Gunthorpe <jgg@nvidia.com>,
  Pratyush Yadav <pratyush@kernel.org>,  jasonmiu@google.com,
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
In-Reply-To: <CA+CK2bAKL-gyER2abOV-f4M6HOx9=xDE+=jtcDL6YFbQf1-6og@mail.gmail.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<20250826162019.GD2130239@nvidia.com> <mafs0bjo0yffo.fsf@kernel.org>
	<20250828124320.GB7333@nvidia.com> <mafs0h5xmw12a.fsf@kernel.org>
	<20250902134846.GN186519@nvidia.com> <mafs0v7lzvd7m.fsf@kernel.org>
	<20250903150157.GH470103@nvidia.com> <mafs0a53av0hs.fsf@kernel.org>
	<20250904144240.GO470103@nvidia.com> <mafs0cy7zllsn.fsf@yadavpratyush.com>
	<CA+CK2bAKL-gyER2abOV-f4M6HOx9=xDE+=jtcDL6YFbQf1-6og@mail.gmail.com>
Date: Tue, 09 Sep 2025 17:56:46 +0200
Message-ID: <mafs0h5xbk4ap.fsf@yadavpratyush.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: t6uf8ia43cwufinpcnyjxn3kj3184guj
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AFFF80006
X-Rspamd-Server: rspam04
X-HE-Tag: 1757433421-62386
X-HE-Meta: U2FsdGVkX1/UERxBul9Uh5zhx26z8xQaFMCvYalspQOx78unKk4HfBH2loEXkOmmyFnzfRKd6ot/BFhOQBD4dTKTpcYvDYPwWa9WcxVfrOV1SEoTiRdiLh7vDxn2S9CHbvceCAcbauUVdXX6M5fNtK26ijT3GuVDaMoCv4Yin4pSBk9++ravVN8RHMSHvyInILT26MEfsmVb3pSYPH+N4SxwVGDjFbSyTE1N221om0fKMT2cPGQd0Rqdfqu5KammMFoCO/iDdhtRdRM4zGSiD3IXe+AVtFpeWq2ITMX3hpCJpw/S3aVJB0tBPHSwOrLqCKUat/bYOCFIkiPr1iBg0J4geEijpwl4ePJZGmgRKmSLbkXQkpdfUFIiC9GvUePBYjw0YCXOHnICe9DPJ7RgJwtM63/UP+8ntQ9tYmGMuc4OWF+nvdxVnheSV1UZxjlfJI5PfPAJj08pfMxkEAisCGG60FbQyaIXWkAw1cJq5t4/DzzCHVsjeZcJ/hctBBa/G2NXFT5OIIcd2zNVmMAu3XcOiwlmRAfg9M/pW8sZDl0kpMDitMVxkXz5dSU6CL3GcTHrRf0pEwf8+iXPK/GKEll0v/pCf9de6oWBSRgd5q1kh4irf5zbzj9oMNbSsYEp8TkFpxl0864gLvFoRSxDxZ+4xsrR1dmeiOmo6xar2dBqu6orK2tWukCiHVZpgpgjCFMi1UqHpibdsJAylG5il16vue2v4k+pQNA2xzpPz2pVKILQze6VDfu9yb7z78bxxL7KPra1T2Te5CJCHk7FaJ+NaoOeP7f5+6Lh6ar/+eFU9YRsZX/lGjRikYgHn0Y54TMQGR/wld8ewT4tQND8dJgkABjeqTAfCz9ByNNJYER2iqRzCDTDd0Bb/TE7Tb73f9dmp9qMT54CpY3OeCzPtqVvsttCKJ48cZU3Fk7dmLQ21alvUksVs523PImFTDYuhWJwEnXychU99cjdfUQ
 3Eyw9ejM
 fxVRLPsJSysoU+ihs/MJPzHW+/ZW/u+2z58aGbPAFzczktU2pzvh8pDWhP+3vUpcuzffNlSlNshbdCOEmdpHf0yIGpJ+jU82NzkmShYeyZ8GY8VZUPcUYDUG70liekPk+4o/TmFU3U0ZenmbmoHuQycqVn8s499Qgqb+9Ea8WptUojLbIZ/zP932dLBSpMgCVLXyVDYUvFR2WiB1xqMSq5rjbU6Vp8GYQNBsL8fx8C9h80CMKjIrJDJDmL+JGixCr0HdxtbvNWcykkX7qc19eZ+krjgI38Nk5FmWpLZgHR7EOSkf8EpZZaH7IpXqPsQw88UA2p6mg73DGR/JcyR+0idx3lDNjAR0D9M1STs1yfdkOlcdyndp87gIW36jxuqu764enerQpHqBF3MTI3N6xcIrmoSb+OHMan/JkaETpOdO5tb8uPEDKcHXAs0amPd0/NWaNTLmWQh8mT+gntqNYE0fN+XFv2KUJI1jH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09 2025, Pasha Tatashin wrote:

> On Tue, Sep 9, 2025 at 10:53=E2=80=AFAM Pratyush Yadav <me@yadavpratyush.=
com> wrote:
>>
>> On Thu, Sep 04 2025, Jason Gunthorpe wrote:
>>
>> > On Thu, Sep 04, 2025 at 02:57:35PM +0200, Pratyush Yadav wrote:
[...]
>> >> But perhaps it might be a better idea to come up with a mechanism for
>> >> the kernel to discover which formats the "next" kernel speaks so it c=
an
>> >> for one decide whether it can do the live update at all, and for anot=
her
>> >> which formats it should use. Maybe we give a way for luod to choose
>> >> formats, and give it the responsibility for doing these checks?
>> >
>> > I have felt that we should catalog the formats&versions the kernel can
>> > read/write in some way during kbuild.
>> >
>> > Maybe this turns into a sysfs directory of all the data with an
>> > 'enable_write' flag that luod could set to 0 to optimize.
>> >
>> > And maybe this could be a kbuild report that luod could parse to do
>> > this optimization.
>>
>> Or maybe we put that information in a ELF section in the kernel image?
>> Not sure how feasible it would be for tooling to read but I think that
>> would very closely associate the versions info with the kernel. The
>> other option might be to put it somewhere with modules I guess.
>
> To me, all this sounds like hardening, which, while important, can be
> added later. The pre-kexec check for compatibility can be defined and
> implemented once we have all live update components ready
> (KHO/LUO/PCI/IOMMU/VFIO/MEMFD), once we stabilize the versioning
> story, and once we start discussing update stability.

Right. I don't think this is something the current LUO patches have to
solve. This is for later down the line.

>
> Currently, we've agreed that there are no stability guarantees.
> Sometime in the future, we may guarantee minor-to-minor stability, and
> later, stable-to-stable. Once we start working on minor-to-minor
> stability, it would be a good idea to also add hardening where a
> pre-live update would check for compatibility.
>
> In reality, this is not something that is high priority for cloud
> providers, because these kinds of incompatibilities would be found
> during qualification; the kernel will fail to update by detecting a
> version mismatch during boot instead of during shutdown.

I think it would help with making a wider range of roll back and forward
options available. For example, if your current kernel can speak version
A and B, and you are rolling back to a kernel that only speaks A, this
information can be used to choose the right serialization formats.

[...]

--=20
Regards,
Pratyush Yadav

