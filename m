Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E38B8CD8CA4
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 277048E000B; Thu, 13 Nov 2025 11:32:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24EF18E0002; Thu, 13 Nov 2025 11:32:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165178E000B; Thu, 13 Nov 2025 11:32:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 013B28E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:32:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 987E589DD3
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:32:25 +0000 (UTC)
X-FDA: 84106126650.05.D9FA991
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D37F11C0006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:32:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NrGC9Z1H;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763051543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5p4qF9j+ANohT5Y6p337wNDv9CD+Cknywz7c0hm3bwI=;
	b=G6eys8wkzjKpuIsu6zhOb/8aiu8odd81HIvo+7MBRcpsEDCQB4mPuDDp2Oq7f2dFOjwtJi
	ukYPhQWPCD7jajaRhy6y9KqmsT7+7K+XhU/+K5PfZjfGDhWwwpzDxFG0pHJ2ze52uhhi62
	bvAXh/i/4pBTtpyR7YzhalWH4BGnT5M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NrGC9Z1H;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763051543; a=rsa-sha256;
	cv=none;
	b=HJcIipUmQeupmP331M6r73ZOYBxGqI8CqEbrZvtBXTd/L1P/Z7MB6WAu8NnJch0bzkOgvK
	wMAIeIrNhGUKdOrXsZJtQxumO1gPpSp1SLtehx2n2OWoKaIDYtrnwPr+qQxZfrDHxcsiku
	EPXs2/de5MQuUpK1C6up1+DD9+rSX8A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EC62C600C3;
	Thu, 13 Nov 2025 16:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B42EC4CEF1;
	Thu, 13 Nov 2025 16:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763051542;
	bh=48cU/r2mCuhBi2o3QbLq7X+wCorzdfK7kjE/pbyUoys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NrGC9Z1HvTGjTjRL3xw+mZ4VRxFvPWujkCi0vHliqnjQPxgDj5Iq1rshZmt6ySeMc
	 HGMSMKVh9VgMIzXnB8CNP7DemQTXKeUC8H36kD7XXCJ8kj8oUOWtKFtV5JfCVlNMUH
	 vV2Wz9lpEeXMW2vqdMbjTqxar0BcgazuH6zXzm6BsqIwtOVpVA7LeQFXB8qnOtRmO6
	 ydVLEDH5JNfCnMadYTtk2Srvhd9ymPG9C691mZ4GV2PRr0Iwvc9aecAiVDEwcWPZYX
	 IzqR46Q59HdXyVhnv/UTfIsTjQPSNCKfiaL+IDedKXACddxrDzR6Q4dn3sl1d1gn/I
	 R2sYn55yOR5pQ==
Date: Thu, 13 Nov 2025 18:31:57 +0200
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
Message-ID: <aRYH_Ugp1IiUQdlM@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com>
 <aRHiCxoJnEGmj17q@kernel.org>
 <CA+CK2bCHhbBtSJCx38gxjfR6DM1PjcfsOTD-Pqzqyez1_hXJ7Q@mail.gmail.com>
 <aROZi043lxtegqWE@kernel.org>
 <CA+CK2bAsrEqpt9d3s0KXpjcO9WPTJjymdwtiiyWVS6uq5KKNgA@mail.gmail.com>
 <aRSKrxfAb_GG_2Mw@kernel.org>
 <CA+CK2bAq-0Vz4jSRWnb_ut9AqG3RcH67JQj76GhoH0BaspWs2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bAq-0Vz4jSRWnb_ut9AqG3RcH67JQj76GhoH0BaspWs2A@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D37F11C0006
X-Stat-Signature: cpteqb8bwao4hdhfpb915ieqi4ey9s56
X-Rspam-User: 
X-HE-Tag: 1763051543-956341
X-HE-Meta: U2FsdGVkX18KGyIS/6s3fS3u6XelpQuT+afqkvXGMrgUxLxtbYBU9tkjHcfAjtUYbPP5YkH84MrKY6tH1qGrYn3P9UkimxHRLb+Phl3RxNE+8BvuNY8AdTzMChWyCXWz5GN3zjVwQHlJXDAFcLk9OUOJuxO2tpb3Vm4/xma7f4icS1uMkKAbspMo1Uqa4XY9oWtSJ+qogeNIpz5tjHhMVYwScIpBxq6XB2rC2WUJZumMLUFsJBBPfU1LpQ83y4hrwsTf7EzA+hBbAZPe+47K4jySTPWjHwcKy24yjHCLZOeyc/4oUJMhYK9tS8pV53RWKLsjJyPcQHSp+03+zQ/VBYSjJoJiZOKreQz9OZNU62XjXR1rG5K9mAQRwhdHds+fMexiC97yI6YeJZVpYUyku54TWfg1Lj261szKfBd23d5GJ220NJ2NECOh2u5qg60LpD+R4xshN3fmSN1hGfIU0zFnenhd9ipPBnPKFsgHWR8bC7fNOSxnDI9QcfShPiixrrXM30QxZBUfodwQWbn/QMLfi38F8EjlpJeuQdARACuTO5KhznlwknW7XFESuHs4VSLhJCnz7KpicbfqJhM2J8rbdFKf1MaI6oxXHfZeuFSFtNjpclMzdvKMM7S4Ha/mSLH0iWO5krQoHbxByqrzZ/buHuWr9jrTgCKyeswjqcxIkVWFhGKCkgBjyDtzbKoVw7UVxpTLCMNPL0ZtBUHxFjXd1MwX7cjVCOzBi676ivoh9NC2ul/DE1Uz1jqX1N3Dg0oSzyBG1eAUiSn8cu58VR3m+KR2Ti+ZFySHQHUlcq10FdSlbJBMzpu+XP5sXOSg81Ps+mrwWLSYtS1T2Fcq24XNaCypSsNGVCBTV6GThQBKfq2w+0shKq3iSuLd4tbXrfUS0LWH8JNAMQq+Ec87jq1lU0+TFEyI1nSaTnHfPkoUnlvllKvAI2o/1XtYcZv5koQsoDorZqTS85R+S1z
 1zcK8f2d
 P+tTuGQZ93RgO5+gWa/Gqc0Cm2SCYrYYpmaENxFEn77uDb2b4rcI0HWpZSywsck0AVCQ3s61xSh83Emh8G6KkSVOxrIjzBj6Im1BMHQ/C/iqRQ5sB1hITgn8WNupVjAC7jE3w99Zxjuw6lVmLPhIe2ZRUzii2qQsiLm/rzTaiIJOF0BdN9Dc6GJDiTtJJyBb4VZu03XXUsANLUTZdNjuHCzM0GHUaHaH0nCq00LRLMINP9z5/uPzMstbzv29Et/hwzmVXq+fZ5YPYwY2/NQ2fFrxS4a3gXmC8JcPwbSBxp2RvpxitAflv3/NtasOX7FQR0va/aqDIclgzF6hgzQ+Veo8l5leuCs/NQpSoMtW0kwt3XoMyC26VLlvVlFRBBqYPW0mk/Er4mo9Vg72XD50E82gyCJ7kJhanmu6nqSWUQ+nQGmWBGNUqqd3HGu+G9BmCzWvSzBhllJi5LLo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 09:58:27AM -0500, Pasha Tatashin wrote:
> On Wed, Nov 12, 2025 at 8:25 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > Hi Pasha,
> >
> > On Tue, Nov 11, 2025 at 03:57:39PM -0500, Pasha Tatashin wrote:
> > > Hi Mike,
> > >
> > > Thank you for review, my comments below:
> > >
> > > > > This is why this call is placed first in reboot(), before any
> > > > > irreversible reboot notifiers or shutdown callbacks are performed. If
> > > > > an allocation problem occurs in KHO, the error is simply reported back
> > > > > to userspace, and the live update update is safely aborted.
> >
> > The call to liveupdate_reboot() is just before kernel_kexec(). Why we don't
> > move it there?
> 
> Yes, I can move that call into kernel_kexec().
> 
> > And all the liveupdate_reboot() does if kho_finalize() fails it's massaging
> > the error value before returning it to userspace. Why kernel_kexec() can't
> > do the same?
> 
> We could do that. It would look something like this:
> 
> if (liveupdate_enabled())
>    kho_finalize();
> 
> Because we want to do kho_finalize() from kernel_kexec only when we do
> live update.
> 
> > > > This is fine. But what I don't like is that we can't use kho without
> > > > liveupdate. We are making debugfs optional, we have a way to call
> 
> This is exactly the fix I proposed:
> 
> 1. When live-update is enabled, always disable "finalize" debugfs API.
> 2. When live-update is disabled, always enable "finalize" debugfs API.

I don't mind the concept, what I do mind is sprinkling liveupdate_enabled()
in KHO.

How about we kill debugfs/kho/out/abort and make kho_finalize() overwrite
an existing FDT if there was any? 

Abort was required to allow rollback for subsystems that had kho notifiers,
but now notifiers are gone and kho_abort() only frees the memory
serialization data. I don't see an issue with kho_finalize() from debugfs
being a tad slower because of a call to kho_abort() and the liveupdate path
anyway won't incur that penalty.

> > KHO should not call into liveupdate. That's layering violation.
> > And "stateless KHO" does not really make it stateless, it only removes the
> > memory serialization from kho_finalize(), but it's still required to pack
> > the FDT.
> 
> This touches on a point I've raised in the KHO sync meetings: to be
> effective, the "stateless KHO" work must also make subtree add/remove
> stateless. There should not be a separate "finalize" state just to
> finish the FDT. The KHO FDT is tiny (only one page), and there are
> only a handful of subtrees. Adding and removing subtrees is cheap; we
> should be able to open FDT, modify it, and finish FDT on every
> operation. There's no need for a special finalization state at kexec
> time. KHO should be totally stateless.

And as the first step we can drop 'if (!kho_out.finalized)' from
kho_fill_kimage(). We might need to massage the check for valid FDT in
kho_populate() to avoid unnecessary noise, but largely there's no issue
with always passing KHO data in kimage.
 
> Thanks,
> Pasha

-- 
Sincerely yours,
Mike.

