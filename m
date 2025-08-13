Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDA3CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4AD6900083; Wed, 13 Aug 2025 09:53:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A22CD900044; Wed, 13 Aug 2025 09:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95F89900083; Wed, 13 Aug 2025 09:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 88A9B900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:53:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 56DC882B94
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:53:58 +0000 (UTC)
X-FDA: 83771877756.16.A777390
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B2A694001A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:53:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=mCPLqBCS;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755093236; a=rsa-sha256;
	cv=none;
	b=pv0tNEDtGQrT5THTQ5+PmW/XvZv3DxPslFA5IPcyFOgfWlxah4rXkn9cBZEqfTwhmly2b8
	B0K2SwZ1iZMHRksmy1Aj6w4Lnh7l7gTSY3lZhEhjgnemoRuTBRO2NtJFasw7GSRincQ7Vl
	1rWMI+DzqkMOjzPwoYUKK5WtXPsx9Ac=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=mCPLqBCS;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755093236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PuX1YNIBuHDgnV9GOy2kKe+QfsFfr2VD7JAZgaQ+FJo=;
	b=St84KYCXe5IIWH0swoE/YPv7+EE8S/LijQgqy9fiAi38GJ9jbkmorXt8aNjlM2MD6HY6MC
	vFBNzCiPUsrd7emQFS5OyyVvxsSkK5iihuIHRS/ZzB8WANTSmrxPxbbjfT/m4K+TPyD+Im
	SvsaOWZ8CFbs0Z49ioVEly92xXy4NVo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BEF8A44398;
	Wed, 13 Aug 2025 13:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCA9C4CEEB;
	Wed, 13 Aug 2025 13:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755093235;
	bh=cb6IHvKJI6s9a7NefYpZ8pOVcYdWMtHhY4ST4nI1r9o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mCPLqBCSonSc1PNeIvJP/EqqsgjspL0NafTpNdgQPnaWvE+58pv1tAJIxRQFCqssg
	 fsmFmez2PBUkvRpKyzO3qstcs7257EdUEUwtOG/D9v50oaSbwpUPsxgceky8bhOziJ
	 LAcRHaYPuhwABBEmpo24LwWWfyqXdq2hKPRbw6eA=
Date: Wed, 13 Aug 2025 15:53:51 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
	Vipin Sharma <vipinsh@google.com>, jasonmiu@google.com,
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
Message-ID: <2025081341-essence-unheard-63a1@gregkh>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com>
 <20250813063407.GA3182745.vipinsh@google.com>
 <2025081310-custodian-ashamed-3104@gregkh>
 <mafs01ppfxwe8.fsf@kernel.org>
 <2025081351-tinsel-sprinkler-af77@gregkh>
 <20250813124140.GA699432@nvidia.com>
 <2025081334-rotten-visible-517a@gregkh>
 <mafs07bz7wdfk.fsf@kernel.org>
 <CA+CK2bDs9prKNSo=Ris-L7T43ZFU7ji3cBH3KD1=FxXg7hFbFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bDs9prKNSo=Ris-L7T43ZFU7ji3cBH3KD1=FxXg7hFbFA@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B2A694001A
X-Stat-Signature: e9zqehhbawbobpgjcsssix3uwdkzo6o6
X-Rspam-User: 
X-HE-Tag: 1755093236-976257
X-HE-Meta: U2FsdGVkX1+hdYYSAkhLm8SuF7POhw205T40Th7GK8wzwb1zpR8z0bQmTxxIBLuTIZwOSQhdjfty7hmgy9gLZkkAVtjKOi1s07/pxg2L+nicTry8GdWWdi4e0p0L2eafe7RhmMgFi3u3oUthKOumBoAi05fdqjKNCEbewyk26TpWVuojS59RkrRHHh/RcmHK8npM5zi1/f/4YnHxtzgs+8gttIJ32IAB4/LYE2UEsx2IRPFenG5aUiW4D8uSNcS7nFxRIRyBT5LtSUSTH2gTeg3zpR0HlqQzvKQCWADF0T243uIlA1U9bBBeVjovv7y6qs/F2si66ZuMyx27MIT3dOQBrjVtisdqQnCXiKty/tdY5U+/G9pqMe7RwqUlO3eSuRg+kWfezhFDJpkvG37n6RWjsof3dyMOVb8tT7RqYAo3VD2zHt9NAT89Plgt7GvTqVH5n4oofbE6J7oJ/zCMJAdfaORg53soufQf6O9Hhys0+JnINnlW57biYgL8dlYv7CBOfEmowzpIACXR4OUJ7hzEkypnsu/nlYhMBwhOscGpTM1ltUivQLn5ohoeAt+7FRs4KkF9UUr0bRWfGwL4tso2yb6M4PWBk8zD/rJI4IkTABvyUtcfG8Zd1aG0LEptT0bTIjh+QIL5rA6XR/aqNFrSYHx7QXM+5TplJJv7LD/YKIWKF/KV3Uxprf6uFL1BV9vhjU/woDzYmhhXOM/19vjh6nWGKyScQY52thVqCKUYQ6myzMZG8Fh6sJAPJFZTijey++NTKGOXxpsQ3SmwLJI2DHbH2dE3dFdMspn4KCIK45ApOYyvu+TYhYvqaDOND9LxmTtTTRSXGWYpi86vgNFYmDTFAxjuu3vW8rHWGts6Lbv1W2CNS7zAWGRp+GPDsV7xLiZA82e7dywcgYEHO4+um9/bjB7+/aQatPCKUgOTG6tCkVwlVIy9wMdyioncHAT17qPdwFkkh7zVhSR
 wjkOHoaC
 nXdhOLwDd5WEPtq/J4aVApJMMHW5YD1uzciMij/i3i5BOvAoiIF9qmMAYkhXWk9FFz7OAaFOUIATdTlEHPL46RgUKHtQdYLMOhBqN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 01:41:51PM +0000, Pasha Tatashin wrote:
> On Wed, Aug 13, 2025 at 1:37 PM Pratyush Yadav <pratyush@kernel.org> wrote:
> >
> > On Wed, Aug 13 2025, Greg KH wrote:
> >
> > > On Wed, Aug 13, 2025 at 09:41:40AM -0300, Jason Gunthorpe wrote:
> > [...]
> > >> Use the warn ons. Make sure they can't be triggered by userspace. Use
> > >> them to detect corruption/malfunction in the kernel.
> > >>
> > >> In this case if kho_unpreserve_folio() fails in this call chain it
> > >> means some error unwind is wrongly happening out of sequence, and we
> > >> are now forced to leak memory. Unwind is not something that userspace
> > >> should be controlling, so of course we want a WARN_ON here.
> > >
> > > "should be" is the key here.  And it's not obvious from this patch if
> > > that's true or not, which is why I mentioned it.
> > >
> > > I will keep bringing this up, given the HUGE number of CVEs I keep
> > > assigning each week for when userspace hits WARN_ON() calls until that
> > > flow starts to die out either because we don't keep adding new calls, OR
> > > we finally fix them all.  Both would be good...
> >
> > Out of curiosity, why is hitting a WARN_ON() considered a vulnerability?
> > I'd guess one reason is overwhelming system console which can cause a
> > denial of service, but what about WARN_ON_ONCE() or WARN_RATELIMIT()?
> 
> My understanding that it is vulnerability only if it can be triggered
> from userspace, otherwise it is a preferred method to give a notice
> that something is very wrong.
> 
> Given the large number of machines that have panic_on_warn, a reliable
> kernel crash that is triggered from userspace is a vulnerability(?).

Yes, and so is a unreliable one :)

