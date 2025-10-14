Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E2FCCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 06:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26ACE8E0025; Tue, 14 Oct 2025 02:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243828E0005; Tue, 14 Oct 2025 02:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134D88E0025; Tue, 14 Oct 2025 02:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 020268E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:04:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76EFB16071B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:04:57 +0000 (UTC)
X-FDA: 83995681434.23.E51A99D
Received: from flow-a5-smtp.messagingengine.com (flow-a5-smtp.messagingengine.com [103.168.172.140])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6A8CC20008
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:04:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=feuEu4GR;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="L MmTDW1";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf03.hostedemail.com: domain of neilb@ownmail.net designates 103.168.172.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760421895; a=rsa-sha256;
	cv=none;
	b=7i/J0p2TtNeU0/NlEtuPK6p8FrMWw2AeniynxKRFBnXV3t5HfmX+zqkc0bGnWzUXZr8t6p
	aGPVajSJFAocbTvjwVJC8N6Fx7hyypl7Y6iXEQaXZCQcTnbdI+1iLzO6IyIWpiyV7hss77
	ItCNyhGPiYx5rP5vER6Td7pniS7R/kw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm2 header.b=feuEu4GR;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="L MmTDW1";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf03.hostedemail.com: domain of neilb@ownmail.net designates 103.168.172.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760421895;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4Iph9Kl8wZz1HAHn20rKGPeYlZdEw1yUQf1mGdkCUQ=;
	b=316YOTTxgdt7DNTsO4MPLhT0hKZY670hrEoy0yaky6n6VRoHdjfDxtan4Y9WwxBUO/2fys
	QM1zy55aa4ZrCBmudnC3HwhXKCgoMVwl8XnWGbAvxqJ/XWyUegxjJaVZZKYLbz/xzs1vrI
	jn4ZiU2C0eGjwnuczEWEl435Hm3mVo0=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailflow.phl.internal (Postfix) with ESMTP id 62E6C13802DE;
	Tue, 14 Oct 2025 02:04:54 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Tue, 14 Oct 2025 02:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1760421894; x=1760429094; bh=E4Iph9Kl8wZz1HAHn20rKGPeYlZdEw1yUQf
	1mGdkCUQ=; b=feuEu4GRf6dcErALPk+2jItHSg4i5KWiC9i417b4FIhcTbE2y2T
	+Bt4amVdnCGAM1tUKaufU8N3iC3xA2wxgMF91QjmRsfDtS8TkU58KsBcsHLC3Qe9
	9uGqg12zMyyNWlr0tHrmSZMAjHsrqR6wDDn9puU8TZhvuKVCpBBV0N4hnJN5njSM
	BHj+IqFdfGfwsjivQNzH5S2eCArfr2wTYNfe0VVD6mjQGTf1nZkL/z9FmU6wkxeC
	XP7HcSdYhv3lxXdbaxFn3pGRdVj5H/ibkL+9weFKyTuxGadyOlFat4dNTrwfckpc
	EQEtGwZGFoj2V5Cu3Q3Qg7NpyQpILU9t7YQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1760421894; x=
	1760429094; bh=E4Iph9Kl8wZz1HAHn20rKGPeYlZdEw1yUQf1mGdkCUQ=; b=L
	MmTDW13ZQy/vvnXJJHqO2e4Nwp/4f0wIhr5NAnj31qKE+wHoQadph71IrqSc5Ib0
	lhC6eeRCRQGeEFwXVh03+zoKg7JvrvXHWp4EZblBZwrgx5uc1e3QbyqDIz2/xuRM
	x58UYYm8Gs2/BlOkdLgAp+C2Ud0eKKK7HOOKvovGP+SYaw8MNisjOrZV9Q+WOQVr
	FACIlwg4aSWFz83NZUIVVjDgZX3yrjk6q9Sx+4ahYsr/hpjT7Or3pU7QIuTtJpqV
	mwz8Vk/OvGuxNfinjrygxj11QA1kr2UinaJmSCRd7/tXGKs1xZ9lzd3VsMgSyHLG
	tetmXGjlWtEDy8ZH9tV3g==
X-ME-Sender: <xms:_eftaCHyqV6o3FVefhsjNT8IhmMyfFHwk8jZHMhbo-HUFu5X_n6urg>
    <xme:_eftaEnN6jBrfj20h2AuPNDCuOMyqF6Plg83kg-Wm7c0-k_CfdsL7XEtnlxZx9Zc4
    vdnWYhYYsNNXJvyiFNgoRvI7Kazc6WaYj_Vgo60bnGRd5AR>
X-ME-Received: <xmr:_eftaD6dxLXuqheOCQURHeHPfO7bW-CXtJ1AseJtZXeLq0oSGG1WRKKPAy8NkEw4I49DhwHKvB2Po8CEgxiioKrKzekCRYBLjrQ5r26_DkV4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduudeljeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtjeertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epudetfefhudevhedvfeeufedvffekveekgfdtfefggfekheejgefhteeihffggfelnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohepudegledpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtohephhhprgesiiihthhorhdrtghomhdprhgtphhtthhopehlih
    hnkhesvhhivhhordgtohhmpdhrtghpthhtoheprhgtuhesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehlihhnuhigqdhnfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtoheplhhinhhugidqmhhoughulhgvshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehlihhnuhigqdhmvgguihgrsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhr
    tghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhinhhugidqihguvgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:_eftaCbgmYlvEUe7c8diYxkm08sFcYy0h1FLId3hRvl3Wygr1PpoUA>
    <xmx:_eftaO0MJ_hLSTek3S8a6e-GF_TCbTx0v6w4rpkXwlvonZGXG2N4kw>
    <xmx:_eftaNhIc-WZoUYTLfzJpLzI2fsWLLjvzv3kaEG6CxTMcM2aAlX2EQ>
    <xmx:_eftaFhY4IYteGvByEUJUmCKSZRYVweFZ66sE_nYkeHRJBJf5cUvxA>
    <xmx:BujtaI-jqBpV57I5Iv3W1WU6_3vCyGvF2hAPelzIt6ARNYBJwHSB75rK>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Oct 2025 02:04:01 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Byungchul Park" <byungchul@sk.com>
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 torvalds@linux-foundation.org, damien.lemoal@opensource.wdc.com,
 linux-ide@vger.kernel.org, adilger.kernel@dilger.ca,
 linux-ext4@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
 will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
 joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch,
 duyuyang@gmail.com, johannes.berg@intel.com, tj@kernel.org,
 tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
 amir73il@gmail.com, gregkh@linuxfoundation.org, kernel-team@lge.com,
 linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org,
 minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
 sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
 penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
 ngupta@vflare.org, linux-block@vger.kernel.org, josef@toxicpanda.com,
 linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org,
 dan.j.williams@intel.com, hch@infradead.org, djwong@kernel.org,
 dri-devel@lists.freedesktop.org, rodrigosiqueiramelo@gmail.com,
 melissa.srw@gmail.com, hamohammed.sa@gmail.com, harry.yoo@oracle.com,
 chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
 max.byungchul.park@gmail.com, boqun.feng@gmail.com, longman@redhat.com,
 yunseong.kim@ericsson.com, ysk@kzalloc.com, yeoreum.yun@arm.com,
 netdev@vger.kernel.org, matthew.brost@intel.com, her0gyugyu@gmail.com,
 corbet@lwn.net, catalin.marinas@arm.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 luto@kernel.org, sumit.semwal@linaro.org, gustavo@padovan.org,
 christian.koenig@amd.com, andi.shyti@kernel.org, arnd@arndb.de,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 surenb@google.com, mcgrof@kernel.org, petr.pavlu@suse.com,
 da.gomez@kernel.org, samitolvanen@google.com, paulmck@kernel.org,
 frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com,
 josh@joshtriplett.org, urezki@gmail.com, mathieu.desnoyers@efficios.com,
 jiangshanlai@gmail.com, qiang.zhang@linux.dev, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, chuck.lever@oracle.com,
 okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com,
 trondmy@kernel.org, anna@kernel.org, kees@kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, mark.rutland@arm.com,
 ada.coupriediaz@arm.com, kristina.martsenko@arm.com,
 wangkefeng.wang@huawei.com, broonie@kernel.org, kevin.brodsky@arm.com,
 dwmw@amazon.co.uk, shakeel.butt@linux.dev, ast@kernel.org,
 ziy@nvidia.com, yuzhao@google.com, baolin.wang@linux.alibaba.com,
 usamaarif642@gmail.com, joel.granados@kernel.org,
 richard.weiyang@gmail.com, geert+renesas@glider.be,
 tim.c.chen@linux.intel.com, linux@treblig.org,
 alexander.shishkin@linux.intel.com, lillian@star-ark.net,
 chenhuacai@kernel.org, francesco@valla.it, guoweikang.kernel@gmail.com,
 link@vivo.com, jpoimboe@kernel.org, masahiroy@kernel.org,
 brauner@kernel.org, thomas.weissschuh@linutronix.de, oleg@redhat.com,
 mjguzik@gmail.com, andrii@kernel.org, wangfushuai@baidu.com,
 linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-i2c@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-modules@vger.kernel.org, rcu@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v17 28/47] dept: add documentation for dept
In-reply-to: <20251013052354.GA75512@system.software.com>
References: <20251002081247.51255-1-byungchul@sk.com>,
 <20251002081247.51255-29-byungchul@sk.com>,
 <175947451487.247319.6809470356431942803@noble.neil.brown.name>,
 <20251013052354.GA75512@system.software.com>
Date: Tue, 14 Oct 2025 17:03:58 +1100
Message-id: <176042183810.1793333.13639772065939276568@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6A8CC20008
X-Stat-Signature: jm3i1j7tc3x3sqwqnh45a1h9sszrmbgz
X-HE-Tag: 1760421895-367701
X-HE-Meta: U2FsdGVkX19arEgG0mHnGNBdeYQ2uK7JHy51v+S0mMKY3mTdobkFWY16MqlMm4SEiz3cCJh5aU4WnvD4NPj509iA1cHIXqarjcUQTR7Uiw0LtWQcgNE8xEAZTqfiWozPyN+mvxI9z28U2DniC38atiCNa7yxUv0Elpk++3fcfAdkQrfUq4Itv8yYjCk1/U/2gymZViX7iogNfeAZAj/Um29fDuY2Yz4uiDu9l+Ra5bi3UT07Hf+s7j5n04yk7mD1LWH3pWv4hLPBmhB+/uucvMxxy40fahHL/CsHNtw76XST07kEdHe3U4e8GDUo+yxX7NiE2tbJP6i1JmyhsPYWkn65tp52pWmt0B2BhlNNguliSLmFbUle78jV+rZpE53dyvkmbrAdP2yxyc/cZ3km8MEw3TdmPM9X34pTpQHPAsVzbTumXyps2Vj+UrBz2ZTl9GgxI8vlqurDl3VTYZ1XjjRtLW9ODLKY08I4Tdb0U7Y/alxuQunqf/JEpjIASih4OkRhUThfU8zM4LhhAFzn4qBuzQ+Vj8JNDl4sR+afcPW9k9oUP3yvGH18jhexn/RDG2EIzLm/8k5IMMIeAsnep4Gb4JFss2SYsDBrasxbSUtJuBkMI1QQu79ca2zjcuparkoxkchveCcWZg6a1umk4bW4DOaBg0f0RxqSqf8hgz7ybRrPuyEu7KM64M45QMs8l3tnIQJg9dWbjYL2OT8UZ+uAGsVKhFnkk+l7+fyKKddOLJDGB6N55n/0sQ5b7WoAfkofQo5TwdbI0AY/xFjqwuIXOitSPj73XJlDJz7YwS0EAUnHEjZ80E9u1UDuNiSOrCuTkp2+tk9DVC1TN+x+Jt4BhZeH4mFP72YSrZVwAOcFI8bOXT4Fdc216NhezHJQlObYyuyVqw9uGAgXhtezMD1SIaxnaSP2pUlEi3GZALgNKcQb9JSjJt2t+Xt8J4nZfqZ1KbIdqbf/8NOqZvd
 cYGYMW8D
 BKNpWdHgwj8tbebmpjAyDeTXqHAhBqnNdEThKYeFtWEv7K8V3CYsI+zPWoZIeIrCvSXCUEJwJZL9bFJIinyr9D5juhVp1A4U/MAci26f3ydImDWn2CfZ8xDg0wSEprWr9g06Eh4MLNPclhRRsuj37FWB8nWCJzv7N1zgo2vjc0GnCMGFkk0JY7Hg7a9h9Hhn760bM8IKItYnmtiPazz0XuB58FnqHZ0solcelLfrCQwFXsxPMXiceNIbK33a6IxvtPxrHEsgguMo+yojaODsPB3dawTtCNucM44Ae+20hXspLg6d7j92M8sUOtI+9PwGUQ3CtWV7KVgSnDvR8t//m+IHYHo3+4xEcUINkXSrlZMx0ubgspxXxxUvnCSd9pBOXmH0vG3P8ubM/nphcelYyMdLjQusHuMa0KBFQI3soWa236Cu2FcDxPo6HipWkrSCzMZVNn7HcShAsroBfD0lqKbbOEEhQLrx6/PNrNR6w8lP066+1LKWT4+bbHySEZmlMygU0+Bp1GWXMQUVV/0xh6GQzQMxPB9EKUoBXirt+Xk/SQBGmVICJxXt2r2alk3R64UGztWWybFEQf2T0m42IGkIDhSpMfy8x0dKqoTBcuQbCZHbh6hkgVxQk5XLNYsyEMNkZFPQQYtsZvKGeCL5fPQjqqOUYKRZQZSYaJDVo8xTc983VayhcTvHOzCavPgkhPxYTzcIWrX9YH8g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Oct 2025, Byungchul Park wrote:
> On Fri, Oct 03, 2025 at 04:55:14PM +1000, NeilBrown wrote:
> > On Thu, 02 Oct 2025, Byungchul Park wrote:
> > > This document describes the concept and APIs of dept.
> > >
> > 
> > Thanks for the documentation.  I've been trying to understand it.
> 
> You're welcome.  Feel free to ask me if you have any questions.
> 
> > > +How DEPT works
> > > +--------------
> > > +
> > > +Let's take a look how DEPT works with the 1st example in the section
> > > +'Limitation of lockdep'.
> > > +
> > > +   context X    context Y       context Z
> > > +
> > > +                mutex_lock A
> > > +   folio_lock B
> > > +                folio_lock B <- DEADLOCK
> > > +                                mutex_lock A <- DEADLOCK
> > > +                                folio_unlock B
> > > +                folio_unlock B
> > > +                mutex_unlock A
> > > +                                mutex_unlock A
> > > +
> > > +Adding comments to describe DEPT's view in terms of wait and event:
> > > +
> > > +   context X    context Y       context Z
> > > +
> > > +                mutex_lock A
> > > +                /* wait for A */
> > > +   folio_lock B
> > > +   /* wait for A */
> > > +   /* start event A context */
> > > +
> > > +                folio_lock B
> > > +                /* wait for B */ <- DEADLOCK
> > > +                /* start event B context */
> > > +
> > > +                                mutex_lock A
> > > +                                /* wait for A */ <- DEADLOCK
> > > +                                /* start event A context */
> > > +
> > > +                                folio_unlock B
> > > +                                /* event B */
> > > +                folio_unlock B
> > > +                /* event B */
> > > +
> > > +                mutex_unlock A
> > > +                /* event A */
> > > +                                mutex_unlock A
> > > +                                /* event A */
> > > +
> > 
> > I can't see the value of the above section.
> > The first section with no comments is useful as it is easy to see the
> > deadlock being investigate.  The section below is useful as it add
> > comments to explain how DEPT sees the situation.  But the above section,
> > with some but not all of the comments, does seem (to me) to add anything
> > useful.
> 
> I just wanted to convert 'locking terms' to 'wait and event terms' by
> one step.  However, I can remove the section you pointed out that you
> thought was useless.

But it seems you did it in two steps???

If you think the middle section with some but not all of the comments
adds value (And maybe it does - maybe I just haven't seen it yet), the
please explain what value is being added at each step.

It is currently documented as:

 +Adding comments to describe DEPT's view in terms of wait and event:

then

 +Adding more supplementary comments to describe DEPT's view in detail:

Maybe if you said more DEPT's view so at this point so that when we see
the supplementary comments, we can understand how they relate to DEPT's
view.


> 
> > > +
> > > +   context X    context Y       context Z
> > > +
> > > +                mutex_lock A
> > > +                /* might wait for A */
> > > +                /* start to take into account event A's context */
> > 
> > What do you mean precisely by "context".
> 
> That means one of task context, irq context, wq worker context (even
> though it can also be considered as task context), or something.

OK, that makes sense.  If you provide this definition for "context"
before you use the term, I think that will help the reader.


> > If the examples that follow It seems that the "context" for event A
> > starts at "mutex lock A" when it (possibly) waits for a mutex and ends
> > at "mutex unlock A" - which are both in the same process.  Clearly
> > various other events that happen between these two points in the same
> > process could be seen as the "context" for event A.
> > 
> > However event B starts in "context X" with "folio_lock B" and ends in
> > "context Z" or "context Y" with "folio_unlock B".  Is that right?
> 
> Right.
> 
> > My question then is: how do you decide which, of all the event in all
> > the processes in all the system, between the start[S] and the end[E] are
> > considered to be part of the "context" of event A.
> 
> DEPT can identify the "context" of event A only *once* the event A is
> actually executed, and builds dependencies between the event and the
> recorded waits in the "context" of event A since [S].

So a dependency is an ordered set of pairs of "context" and "wait" or
"context" and "event".  "wait"s and "event"s are linked by some abstract
identifier for the event (like lockdep's lock classes).
How are the contexts abstracted. Is it just "same" or "different"

I'll try reading the document again and see how much further I get.

Thanks,
NeilBrown

