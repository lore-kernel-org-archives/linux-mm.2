Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61396CAC58D
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11468E0025; Tue,  9 Sep 2025 10:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BFC78E0003; Tue,  9 Sep 2025 10:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888708E0025; Tue,  9 Sep 2025 10:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74A8D8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:49:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40083864CB
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:49:06 +0000 (UTC)
X-FDA: 83869994292.30.C9DF5B2
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4B65F1C0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:49:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=yadavpratyush.com header.s=fm2 header.b=mgP0v51A;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=k9UAhErE;
	spf=pass (imf21.hostedemail.com: domain of me@yadavpratyush.com designates 202.12.124.142 as permitted sender) smtp.mailfrom=me@yadavpratyush.com;
	dmarc=pass (policy=none) header.from=yadavpratyush.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/TCCEjl1x7wxnth3DtTGIDGSel1rUvJ59NmeiL2G4Q=;
	b=M8B5JqxjVtiG1rYEwh4bQMd+M3R+QBL5ZePrlBfOP9jqEt9YLJiElFoiJcIyNFSIM1InXg
	HRzljEVdwQEzuB8vrmqQTGe05U9f/NcASsq8N24lIqug+viLx5a3ZNApn9//v/qkclyeOX
	mUh3uyw3iaNeIaUDPKUJs6kaFdE2VPQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429344; a=rsa-sha256;
	cv=none;
	b=BHYx6BG16vwhZEWagu1Xw0eoHMSq+5ETDxjmRrLAhNj3SJWlQfxUuVnwZMX1I21oaXaidg
	9FXWyeHuJLwGWqwDaoadeMoroDhMs7opvub2z+iRxWGlvqZNJxxLheU4rdrxgFDU6IHXwD
	I1VAJls7oSDMxVlDwzUqd1VGXtmZwBE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=yadavpratyush.com header.s=fm2 header.b=mgP0v51A;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=k9UAhErE;
	spf=pass (imf21.hostedemail.com: domain of me@yadavpratyush.com designates 202.12.124.142 as permitted sender) smtp.mailfrom=me@yadavpratyush.com;
	dmarc=pass (policy=none) header.from=yadavpratyush.com
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailflow.stl.internal (Postfix) with ESMTP id B3F9E1300990;
	Tue,  9 Sep 2025 10:49:01 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Tue, 09 Sep 2025 10:49:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	yadavpratyush.com; h=cc:cc:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1757429341;
	 x=1757436541; bh=Y/TCCEjl1x7wxnth3DtTGIDGSel1rUvJ59NmeiL2G4Q=; b=
	mgP0v51AEKZ1oLuhYhq0dxoxmzdIjuj3YRTMs5TontGsnXuKeSsgTrsrHF6MMIfE
	212eXMod+EeJVAYGpAy4Wv7mBiYjAcuP6BQl0XEtvwCtFrOR3K7yecENrjLlgS+0
	GXlPErjy7qBU86skUgjtHi0JX73VCP4d2e6kArizhL8smzMUphAKx3KnN6NRc70+
	SBZBlQgCGhIuouqkBKe3T+HAMeylqU047Faj+5IWuvhIgMUt5yQO5NxiWcg9pAgl
	ipuSUbIJEwKfx9Bu+4HDHaX3P4/73OO7C3zCWENMLai5nGCDCq+btAty7NtMpVT5
	ICZUnKckfHRjdd9HvxPKIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757429341; x=1757436541; bh=Y/TCCEjl1x7wxnth3DtTGIDGSel1rUvJ59N
	meiL2G4Q=; b=k9UAhErE0BymxMplbvUgbBzNElquxstojyh1E9JDW+hlCckC4yi
	Wxfbe/64U4mV02XMEQa41HdXXr6D7Pz0TeLA2qkTHnrg8Sad+Av1yC214EPVlh7c
	gGU/Zm8cgJ0YNGHykqSjIPPRgVIBJMHh4vNKSyFr/1Rw0sMkKtmz/l8KddE/3m5T
	d3bK2EMMn4Zp5aVovyEmeH3U+RiBG9K6iHTkI+gB5vUhOJbHZB/e3OsBpJMB5AMP
	YUnki6cCr0TLbu0DTcscCRzctwspe3ooGET70Sb+kC2h/zbuTL77tcH47MLZR4V5
	rB38co4swoM2kR6N5/JxiYwdS2wwFxtWX3w==
X-ME-Sender: <xms:Wj7AaIrI7M7ldDEGh2_Ckv7KIyHISKSpgzqMKkKLJFhg0iGJe_pciQ>
    <xme:Wj7AaNJLH6L9L49uJ1lYcLGgIaQLnilMIFWmRCqyovoUqXEb9Ci53_420Ne6ZiMES
    _l0O6XwDo13qd_55UM>
X-ME-Received: <xmr:Wj7AaFnq_4-dBrJZbIFCdnlipGr0VxvsMJXV5oxjE7RVXL_yHwuriD0TFPRF0Y05P0zdplbqUMEfjEmzXnpjINJGeYfc-UqE6gP95EOykMfw8egzlum9VL28v2PgT-KgkR8gW0xC>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvtdeilecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufgjfhffkfgfgggtsehttdertddtredtnecuhfhrohhmpefrrhgrthihuhhs
    hhcujggruggrvhcuoehmvgeshigruggrvhhprhgrthihuhhshhdrtghomheqnecuggftrf
    grthhtvghrnhepvefgffeuffelffeiveeghfffffeikeeivefhvdeuueetfeekkeegtdeh
    heeuueeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmvgeshigruggrvhhprhgrthihuhhs
    hhdrtghomhdpnhgspghrtghpthhtohepjedvpdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopeifihhtuhesnhhvihguihgrrdgtohhmpdhrtghpthhtoheplhgvohhnrhhosehn
    vhhiughirgdrtghomhdprhgtphhtthhopehprghrrghvsehnvhhiughirgdrtghomhdprh
    gtphhtthhopegrjhgrhigrtghhrghnughrrgesnhhvihguihgrrdgtohhmpdhrtghpthht
    ohepshgrvggvughmsehnvhhiughirgdrtghomhdprhgtphhtthhopehlihhnuhigqdhfsh
    guvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidq
    rghpihesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegsrhgruhhnvghrse
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopehlvghnnhgrrhhtsehpohgvthhtvghrihhn
    ghdrnhgvth
X-ME-Proxy: <xmx:Wj7AaBvS0dMVGs9SUTzz9TmH0Mep055tenv7pII7aNenLBLMCPxeIA>
    <xmx:Wj7AaP1ih8Dwk4RbYaA7fuRZaAcv1inNagfhkDbMSjDtIy4Uvu0wQw>
    <xmx:Wj7AaIbuJb2pBcDWFQ93y58maHi90wS0GGoAglU5mfYfgdOIqspENQ>
    <xmx:Wj7AaIFs2_0V2RcnSQ8cf9Ni9dMlDYA7DolIPUG6L7_ZxPllJtO1sQ>
    <xmx:XT7AaFDEX4cosPWdCU8mMesLFLGI6DT7fI8E4jebyApuljdXe77ZNvcm>
Feedback-ID: i93f149c1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 9 Sep 2025 10:48:51 -0400 (EDT)
From: Pratyush Yadav <me@yadavpratyush.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  pratyush@kernel.org,
  jasonmiu@google.com,  graf@amazon.com,  changyuanl@google.com,
  rppt@kernel.org,  dmatlack@google.com,  rientjes@google.com,
  corbet@lwn.net,  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
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
In-Reply-To: <20250904173433.GA616306@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<20250826162019.GD2130239@nvidia.com>
	<CAF8kJuPaSQN04M-pvpFTjjpzk3pfHNhpx+mCkvWpZOs=0TF3gg@mail.gmail.com>
	<20250902134156.GM186519@nvidia.com>
	<CACePvbWGR+XPfTub41=Ekj3aSMjzyO+FyJmzMy5HEQKq0-wqag@mail.gmail.com>
	<20250904173433.GA616306@nvidia.com>
Date: Tue, 09 Sep 2025 16:48:50 +0200
Message-ID: <mafs0h5xblm0d.fsf@yadavpratyush.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4B65F1C0007
X-Stat-Signature: muwwizj6x4iq77f18yuz86k53grx8swr
X-Rspam-User: 
X-HE-Tag: 1757429344-703526
X-HE-Meta: U2FsdGVkX1+1cMHsmds/TcES+QITqZ9ly++mRKyuhRZdmFnrudKoXdNcMfT81PCIVc+GmLGDyOtXiwV/qe9a75Apkyv52ycM4PcRDs14rBJTCMiJVTQ1Tztpn0mcOJEYYilGnrqG4fKe7kLcLTUn83axfdvakuX6+sUinoAtFL/T5YxuuPT3It8rY+cxlFD8GH4NkgvqjVTY5BqqExw6LoYGKkdmS8OiC2/vwmjmSb0CTa5bKV3Kf1SDnWEQAflGGSnsJ3oO7BwKZpEFwI3Z4Fyhvj6jHijjrAFyW9TaYsrXUj7KzzOySEzAxBYH9WLS56u1lRMa3PzYyUAOF4fMWv2p7p3XwSbUFBeZNUcFP+zRhiZgqE9FpAuZ7OhI7usTcee8/tTs5euAnyDUeq6TFK33KR/u9ww1LQdytLJ6DcktE2Eu9KGDqCNW7tAJnfIQUZnQ41spaQCOWtGvTDCbcszYBUkPJUVQzqqMhZXtu/DVEPm+RvejL5gqUKOSb/WNlQFnHH+aLI+uUCZn1U2RA9I8wOpecdBQbPqDVUBkNxYltEYh+YSRwlT4PUroz1NPsG6pb8zYHbRRVtQnxPDeXHCjetPWQMvm66EDOsUjxqnkeVXZnci2aIJYiv4ZXT+p1WGaPKnuT78DW49iRYgEUqPP+x2F7QPctirFlmOeGhAMapEx2M3kz0DBd2hVnRU8UFJDAIXK92smTtVgpfXVRLzre0ffzSqHnQLVtm3fJPGB7I+bEHpB3Mh+XaWC+CPfyDKJ4Hr6g/oyj0g7DFvuUomp21LacsDxm+vjal56tR9btI9uVlbqeyL0tuYArmErx/z0d99AeZF8p4gf0irlasoKmLjhXN/SYvDSn31yuPdshCa9qnyHBlUaTXesAE41XjCplUvKHgbwSkYXqVX5KSH4PkYoGtNuX6eZ7JoTJo3YkjfuNnSL95jS2Fc1AawQEVjhTQoa7/mht6CjpAo
 r524SFf+
 8GnM7CsRe8DZG8g8CTVqU3xJRGLOMv8RSTwlqAhZ3DdcOrh/peXVSDFy7ED9zogt+ayKjfUA19zjDMTVQ+/f0YOO1wWASy7zgKw28clrCt2k81+N97NQDhymw6QBD8NLYhAsej5kdFisG7VQ/8eHAvNf1VtyKn23IQl4IQBpyo7yCmkXvj3dhERqewKfCUXnS8ua/ecUE1kcIvw3+Ta9YBzutomyfFevmIpe2i80sIAbmIFl1QmAzrMn9Z8Ute/QIAAxocgDYldkufi86Y/7NOMnGaHwlDP2Z3eQePrb4NbyrCO4br/zJ6gT0DCU+HYEikGWmI0vWgXpxn8q6Z30UF3ONwZRKmpw5nGHKmUfLgClO6B66EB4Jq4z3EHA1wrrBM8PdMdGgYUpUZw8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04 2025, Jason Gunthorpe wrote:

> On Wed, Sep 03, 2025 at 05:01:15AM -0700, Chris Li wrote:
>
>> > And if you want to serialize that the optimal path would be to have a
>> > vmalloc of all the strings and a vmalloc of the [] data, sort of like
>> > the kho array idea.
>> 
>> The KHO array idea is already implemented in the existing KHO code or
>> that is something new you want to propose?
>
> Pratyush has proposed it

I just sent out the RFC:
https://lore.kernel.org/linux-mm/20250909144426.33274-1-pratyush@kernel.org/T/#u

[...]

-- 
Regards,
Pratyush Yadav

