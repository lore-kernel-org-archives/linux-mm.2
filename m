Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1D0CCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 13:25:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0665C8E0006; Wed, 12 Nov 2025 08:25:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016B48E0003; Wed, 12 Nov 2025 08:25:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48318E0006; Wed, 12 Nov 2025 08:25:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CCA008E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 08:25:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6EC9EB9B73
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:25:31 +0000 (UTC)
X-FDA: 84102026862.03.D2B8039
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D04671C0007
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:25:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JuXf8Iy+;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762953929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxbEP0/mT6oRz19zAiNieP5qnCOb5jc6DkpK21x1k8I=;
	b=YaXAlmRBNDatNgydSLC1DC+lEevHmkACppfUtdEP82QUfUod7mCnjYO4c8ce1Frp/aexc1
	IstgsFKBVcsri9WxlCgtyQCqeR0EWM1ivM4Hy29kqNF9y6mrhStnYqYs3A0kP0VJXW3P68
	9G38JQVun3g6gEwgDo5P5x2r/49O8xM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JuXf8Iy+;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762953929; a=rsa-sha256;
	cv=none;
	b=Wf3KI11NIyVIqLOB24GgQF4MuuN98D331exlrCE+bKE5MqY+bNeFOXCwAuSeATJEFEvm8a
	q8+7JazpMtMqnKdT2YWdEP0gzrP6TX/f+keQQt7r7v9oK3XLyUDZdhQAPr3OIg5jPd/bY8
	wU77xuUzZhj1KT0R62OvUQHmgZCMUMI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF21F60231;
	Wed, 12 Nov 2025 13:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16109C16AAE;
	Wed, 12 Nov 2025 13:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762953928;
	bh=0L4I5YakZvITlyeB7zaJSYGUCZoIKpW33DPBC2WOOhM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JuXf8Iy+r0eY2kUE7hNwEY3/woXsoN7mLLb0NujdRDnGnxWsUwW61gwcXje3J84z4
	 B3/yjjUcJLgZz+Z63i2LjQpS2xfQ308sv9sRWCv/JMCr+xz6rxzPHlAb+EIGZDMMcl
	 +4BJ5OyXy1HSzx36sq+0a/dYIJuQqqf03VW94U30S6eWt3+ZrvU9aDMFk2zcRDN8iX
	 sLbX+QhHTEbyi6hp2/eWg7aUEYD/KYgV1FvYa5w1MO3SBpUSY2kF0rFvNKOhzSjCjU
	 MFbxZY4wDY5r7NZTXeppRfA1WRwj4O7n5KTZrdrUJEUF2x466Y0AkWfrUxTDXAc225
	 gY47Gsfbb3eQQ==
Date: Wed, 12 Nov 2025 15:25:03 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
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
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v5 02/22] liveupdate: luo_core: integrate with KHO
Message-ID: <aRSKrxfAb_GG_2Mw@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com>
 <aRHiCxoJnEGmj17q@kernel.org>
 <CA+CK2bCHhbBtSJCx38gxjfR6DM1PjcfsOTD-Pqzqyez1_hXJ7Q@mail.gmail.com>
 <aROZi043lxtegqWE@kernel.org>
 <CA+CK2bAsrEqpt9d3s0KXpjcO9WPTJjymdwtiiyWVS6uq5KKNgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bAsrEqpt9d3s0KXpjcO9WPTJjymdwtiiyWVS6uq5KKNgA@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D04671C0007
X-Stat-Signature: s9uo7tp6zniwqgbk9ozb3p8tztxgk5co
X-Rspam-User: 
X-HE-Tag: 1762953929-993797
X-HE-Meta: U2FsdGVkX1/ElC5Urdv9JCWzuF/DG9zRcvb4D3UkLd+lLpAudtNGV33Lav1+CcdI6HfVK6vZoTycX9qGQuGPwzJ7uKVJP105Q8s830oTkrtCgS2Xom9uUkczhZiXDwqVxLt5cwkLyRZDNqEp4mAf8gBBGvzXpyOddNeFuyuRePKDZWrVBkfRi2eMMVZIQ0DcZT2gDaPPDewzq7TyqY9RA1TxpmqZejj1mdaIeP9ZizPHskhSACCcqFPnr5Y5w5JWZ+3/OIGWu6ji7TJer+w1l1AnFe+7APK9zOy/9frVd//QBATT6v8LQr3FgcqgZ6ERpa8fdj4ePQkLck7RcFAr3SsG2CE8rwgy1tXUHkbioYkojdwG2wMZl82kMx02G4L32hOkkdbNbQKVYmvIHRMs0MwFZtmFIVsziJpmuJDyOcRoRdr0H2rt+C4VdcmNjH1d/NF8EFSFJrondUhmowrs5E9IsGkxWz1OZjHihFtQmxdKEvIRQ0Jxn3GCvUgrrbFLV/4BGtm/0BV0XIiZtqzyGRZyylKsQhWoqcA4VConI376nJBqZX0ASJHJ8Mg8XegMP9HwjQwaNnr/z8bjwObtl0IsJR68t2l+kn+gZQPs7BvNQYhABpAhyJohy+BhN9/H7xbrVankhEiaxEw68dZBxWFI7a/T4R3zJd77TY+vn5Z39Xp98uInN10OchYIpFuJ5FiAurB7MlksGvFADpGNBuf0pWctaAq6I86moC1FFtTMSQ7UzTt3Dq9jGXNLAkdh21r+gNIOLQoxt8S+FowUI2/wSLHjEz4fkpm6kp7olCm3QkiefWQD1WQZxUOYhKakuvCxE6JMYlpyZ+LF27gx1EOQ7RnPEkCjcFYUtkwaEw7FAls6XUJvyTAfGpK/IyPBdK0NgY2abvMsSSOIF24N7V+A61mxKQE3AM5AzqlCLqvPQQ8iezjPn8w+Sj8AIlmMB0FmRsI07ZaKxyw5oQC
 pcDmUxUp
 C3Jg7T+YE9WK9McvMNGn7hC6oOWhrUlWxK3BV5m/qOAGNxgNYk6w37bzOoV0ZZB+FCG2qTDSrhsos0nkalMfe33U8j3iE9Lm7WNuJB0KGdBT5eLRIx5qDjw6EZBvAKjUpq12eMfwShY25ftrmnyx0juVgmIYWf2znYKpJpbubPqxvoUii9d9plhrIOxiZqlCqJOF+zehVu6robjQt3q6k3OTeWd1oEfSR00lgfPDErXzeWx47IUJCoxUL9Mf3rhxkclmjLNmlKOjmTHPkCeHtl7CS/KwEVPNXRG8c0I+/yFK/ggzlIFuXVlkWKx2rLwf8UhQM131Wvab2MaFSngJDkG0v/TzWP2odDlJQUwHuq0/OBXVClhE5Un0p9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Tue, Nov 11, 2025 at 03:57:39PM -0500, Pasha Tatashin wrote:
> Hi Mike,
> 
> Thank you for review, my comments below:
> 
> > > This is why this call is placed first in reboot(), before any
> > > irreversible reboot notifiers or shutdown callbacks are performed. If
> > > an allocation problem occurs in KHO, the error is simply reported back
> > > to userspace, and the live update update is safely aborted.

The call to liveupdate_reboot() is just before kernel_kexec(). Why we don't
move it there?

And all the liveupdate_reboot() does if kho_finalize() fails it's massaging
the error value before returning it to userspace. Why kernel_kexec() can't
do the same?

> > This is fine. But what I don't like is that we can't use kho without
> > liveupdate. We are making debugfs optional, we have a way to call
> 
> Yes you can: you can disable liveupdate (i.e. not supply liveupdate=1
> via kernel parameter) and use KHO the old way: drive it from the
> userspace. However, if liveupdate is enabled, liveupdate becomes the
> driver of KHO as unfortunately KHO has these weird states at the
> moment.

The "weird state" is the point where KHO builds its FDT. Replacing the
current memory tracker with one that does not require serialization won't
change it. We still need a way to tell KHO that "there won't be new nodes
in FDT, pack it".
 
> > kho_finalize() on the reboot path and it does not seem an issue to do it
> > even without liveupdate. But then we force kho_finalize() into
> > liveupdate_reboot() allowing weird configurations where kho is there but
> > it's unusable.
> 
> What do you mean KHO is there but unusable, we should not have such a state...

If you compile a kernel with KEXEC_HANDOVER=y, KEXEC_HANDOVER_DEBUGFS=n and
LIVEUPDATE=n and boot with kho=1 there is nothing to trigger
kho_finalize().
 
> > What I'd like to see is that we can finalize KHO on kexec reboot path even
> > when liveupdate is not compiled and until then the patch that makes KHO
> > debugfs optional should not go further IMO.
> >
> > Another thing I didn't check in this series yet is how finalization driven
> > from debugfs interacts with liveupdate internal handling?
> 
> I think what we can do is the following:
> - Remove "Kconfig: make debugfs optional" from this series, and
> instead make that change as part of stateless KHO work.
> - This will ensure that when liveupdate=0 always KHO finalize is fully
> support the old way.
> - When liveupdate=1 always disable KHO debugfs "finalize" API, and
> allow liveupdate to drive it automatically. It would add another
> liveupdate_enable() check to KHO, and is going to be removed as part
> of stateless KHO work.

KHO should not call into liveupdate. That's layering violation.
And "stateless KHO" does not really make it stateless, it only removes the
memory serialization from kho_finalize(), but it's still required to pack
the FDT.

I think we should allow kho finalization in some form from kernel_kexec().

When kho=1 and liveupdate=0, it will actually create the FDT if there was
no previous trigger from debugfs or it will continue with FDT created by
explicit request via debugfs.

When liveupdate=1, liveupdate_reboot() may call a function that actually
finalizes the state to allow safe rollback (although in the current patches
it does not seem necessary). And then kho_finalize() called from
kernel_kexec() will just continue with the state created by
liveupdate_reboot().  If we already finalized the kho state via debugfs,
liveupdate_reboot() can either error out or reset that state.

> Pasha
> 

-- 
Sincerely yours,
Mike.

