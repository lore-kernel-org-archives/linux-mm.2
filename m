Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FCAC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 23:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505DD6B008A; Tue, 29 Jul 2025 19:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DD996B008C; Tue, 29 Jul 2025 19:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41ABD6B0092; Tue, 29 Jul 2025 19:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 326F46B008A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 19:23:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 862A111352D
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 23:23:43 +0000 (UTC)
X-FDA: 83718881526.17.52E297C
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf13.hostedemail.com (Postfix) with ESMTP id D72F720009
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 23:23:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ExfrNWag;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753831422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+eymXffEz85tsj8xEJlQiTAuUr0hfnIPSf6mWJs3Kyo=;
	b=bQrT4WLDkGwAC0fbI88PCA9gHrlnA3dV6f5jGCVh+WJclFSozU2A1PA3RjQS6l93GSGkwi
	PBS27NtebfT80tII2EJerrER5E/vtNJd57c3Ggu5SYZ15Nwo5gA5HIWBn3FalaBIn2D2ZN
	4ZaHPgUeG44nfju0laapjomwjc/6k74=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753831422; a=rsa-sha256;
	cv=none;
	b=jccmAHY6rBAAgIfLD8mlAz7svH2fFiKcwlKUrHjfq+gnE6d7mu5W9ukPKH5sXW1rMvtOif
	OToZAoZVYqVjB7CMDeo/JL+8XrzTWs+6YyKhUOXtfQpd/2qyNl6Ro0+cCsqpFZOtbnRH7t
	KMCJ7tJqis6wOIKeUF+Qq1EepQbUNaM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ExfrNWag;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id A16005C6665;
	Tue, 29 Jul 2025 23:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50991C4CEF7;
	Tue, 29 Jul 2025 23:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753831420;
	bh=k87dPy6BPkaKz6PVwZ9QExifXqUdGreO1XryLzhHrAU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ExfrNWagdnrOUCqpiU3Lx9CVfPIp7MiWDZf8en0ZPlkT/sSBVYPfQm95IJrm+lavz
	 xO3ixcF5LdhPdpxIhjbbIDM//OnwrYz2GlfzTafjYRm0z9rgGffZIy49H4UOsMDIim
	 MxXUAu7OBYRjdF+bOLfiMb3F2+nvBVDJfkZf1tOxdoGyMHEp5CPbGUpMX0Tde4Oc/A
	 dUTAZX7snWGKF++MpaMUDxcAOcifca93aYE7gxxcGtOlyWyZOzVWPQRuHA8jp8SVV0
	 Gsb68qtK7cOd352+mtgM9MLjS41RS3uKrcDMiOkE/kYX3hQeVqn6I0Nuhg1AD5dbxN
	 XH02XJsRenO3A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>,  Thomas Gleixner <tglx@linutronix.de>,
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
  anna.schumaker@oracle.com,  song@kernel.org,  zhangguopeng@kylinos.cn,
  linux@weissschuh.net,  linux-kernel@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-mm@kvack.org,
  gregkh@linuxfoundation.org,  mingo@redhat.com,  bp@alien8.de,
  dave.hansen@linux.intel.com,  x86@kernel.org,  hpa@zytor.com,
  rafael@kernel.org,  dakr@kernel.org,  bartosz.golaszewski@linaro.org,
  cw00.choi@samsung.com,  myungjoo.ham@samsung.com,
  yesanishhere@gmail.com,  Jonathan.Cameron@huawei.com,
  quic_zijuhu@quicinc.com,  aleksander.lobakin@intel.com,
  ira.weiny@intel.com,  andriy.shevchenko@linux.intel.com,
  leon@kernel.org,  lukas@wunner.de,  bhelgaas@google.com,
  wagi@kernel.org,  djeffery@redhat.com,  stuart.w.hayes@gmail.com,
  lennart@poettering.net,  brauner@kernel.org,  linux-api@vger.kernel.org,
  linux-fsdevel@vger.kernel.org,  saeedm@nvidia.com,
  ajayachandra@nvidia.com,  parav@nvidia.com,  leonro@nvidia.com,
  witu@nvidia.com
Subject: Re: [PATCH v2 31/32] libluo: introduce luoctl
In-Reply-To: <20250729183548.49d6c2dc@gandalf.local.home>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
	<20250723144649.1696299-32-pasha.tatashin@soleen.com>
	<20250729161450.GM36037@nvidia.com> <877bzqkc38.ffs@tglx>
	<20250729222157.GT36037@nvidia.com>
	<20250729183548.49d6c2dc@gandalf.local.home>
Date: Wed, 30 Jul 2025 01:23:30 +0200
Message-ID: <mafs07bzqeg3x.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: D72F720009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 6nwfywjipegtd9yhgpkwauwzekjb6eqe
X-HE-Tag: 1753831421-473454
X-HE-Meta: U2FsdGVkX18jFhC3evgjO/9cqE1LgmbwEBZaOKHmhGLwZSv9pLMuqqXSAckSAEVepZg5uwVQt9yS4oBPdiFgiiLo8B1tAsYoKpP0aHztiFowaWbr8C8W6+rnRAltQryNA9Kf0UGGvCOBsPz9aqulFd0oLScBIIx4PfadpUy8mFKXN9CteZQCygm7EmNHXF0hTK8BOlfCbi+8p/ZUwWpp8BHFBg40xddnpYULXpwybIp3CoU59f64asYJLSrrPJIEgrogMcK0X+Ix5FFeV5mLYVQht2Wc4qvE4AY0rbdHzOKxAvONJd5F8D/WbEVKY7+D8ux9Bp297b8YahQEHszGiRKIHpM6KI20NBi3KE5C/K8UixZkb27BoO26ueH72OyXaKvsziLHytRA88U3f4r+4GOyLMG4T2TZXIu66E1pkANTRJ0aDT4ieDjIqzuPY4OwhJZnn6T1jfwcmQb3GAFD4qYCynsNcuXGzFJWgJRBBrSBZH+bcdaLsc4OMGZD5fM8dd3SgG9xPtQ0vUNA4wY3AQtGB/YRf7LNc0K1f5KsxZ5DoaPrqrsf9od0YL9Fob3m9F2v+iu6ZNkhe+/1xNZpyj3KkNd34QFsoC7fHBd8tY+a0h9LSxntLDeX7AeKz7oNDIyoeWktdgpt8CkWHNlBxwt+LlaK52qiCTyOPUjh5RLSrUMv8QLADFSYzBGlbFye1MI2TYUrbbx0PZOHZQP+i847aqEZ2GwrrwGa0TwB1ZIKOtasmvXXQNYsNur+SP2us53Jokc0TkP5+wiVtt+lmmnYDpdzEtbeEDyH0/b4ezIrw62mC0WUl9B2u62raE/n9NL0na2fEYgh6oSC042CemYUm8VztOP1rChyo5ns7ZFt4q2yC+XQsDTkzdPNn8RrtHCQho7j0OfBF36v6kCZz9gNZVr3mWH8h0Ysi8LPaAVDTVvkQcoFdSUnNCOSjrW1ostXSJjLR4SNJDn4Vrz
 BzRMZ9Tb
 KGh9H0mH4urdRJkmk6T6i+37xpBhj8/v83+zx8bLhqAujgx5CxX8vyL2PtbDP2y3DYSVYQb9uN22HCBSL8Hwp0SHioFdD8MmO/MMQOEb5pVZUCdN2vg9BAb3NQmfzaZI12JWzsBPyQ4q7vS4PvqCsQ+LB2NW5GsqCF0AfPqunjkgHi5qQHfD0gaxlkd1ZGD/pNrtnA1caGjyjBMdmqc+vMB0kITdOLhbkKSgxnsHcbOSlgLOzUQdjPBHNmpppdVLdjjZM61bSDARk21k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29 2025, Steven Rostedt wrote:

> On Tue, 29 Jul 2025 19:21:57 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> > As this is an evolving mechanism, having the corresponding library in
>> > the kernel similar to what we do with perf and other things makes a lot
>> > of sense.  
>> 
>> If we did this everywhere we'd have hundreds of libraries in the
>> kernel tree and I would feel bad for all the distros that have to deal
>> with packaging such a thing :(
>> 
>> It is great for development but I'm not sure mono-repo directions are
>> so good for the overall ecosystem.
>
> I have to agree here. When libtraceevent was in the kernel, it was a pain
> to orchestrate releases with distros. When it was moved out of the kernel,
> it made it much easier to manage.
>
> The main issue was versioning numbers. I know the kernel versioning is
> simply just "hey we added more stuff" and the numbers are meaningless.
>
> But a library usually has a different cycle than the kernel. If it doesn't
> have any changes from one kernel release to the next, the distros will make
> a new version anyway, as each kernel release means a new library release.
>
> This luoctl.c isn't even a library, as it has a "main()" and looks to me
> like an application. So my question is, why is it in tools/lib?

luoctl isn't the library, it is a user of it. See previous patches for
the main library. Don't get too excited though, it is only a thin
wrapper around the ioctls. The more interesting stuff is in patch 32
which shows the API in action.

To add some context: one of the reasons to include it in the series as
an RFC at the end was to showcase the userspace side of the API and have
a way for people to see how it can be used. Seeing an API in action
provides useful context for reviewing patches.

I think Pasha forgot to add the RFC tags when he created v2, since it is
only meant to be RFC right now and not proper patches.

The point of moving out of tree was also brought up in the live update
call and I agree with Jason's feedback on it. The plan is to drop it
from the series in the next revision, and just leave a reference to it
in the cover letter instead.

-- 
Regards,
Pratyush Yadav

