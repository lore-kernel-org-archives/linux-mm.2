Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B760CC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 19:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AAC46B0095; Fri,  8 Aug 2025 15:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482CE6B0099; Fri,  8 Aug 2025 15:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BF3D6B009F; Fri,  8 Aug 2025 15:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5256B0095
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:06:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 969AA140437
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:06:22 +0000 (UTC)
X-FDA: 83754521004.11.3430F22
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf09.hostedemail.com (Postfix) with ESMTP id B0F5F140015
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:06:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MVbd3V2B;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754679980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+oQrI+bFVn0JH+5T/ebOKU1EcePPC300qELoyyXxo1Q=;
	b=wTbTGMZCxtMrDksWaQWohmBBT6mpXvUdOqQx7j2cvqSDyLGaVm/Ylfn2DhZ1BO4Eq1Q8pb
	beEehxiBygvEsBryuWY9r+29/1EzkwGawbR/+8G20Vprd9uChlV3trieuQLLcA0gDADadD
	9Hju9JujyORCsbLATiUotMXlYWIRiTI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MVbd3V2B;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754679980; a=rsa-sha256;
	cv=none;
	b=YdPjTYWQl/UglyUoB9ra2FKmsc/LVTSahcTRP4C57PYMC+IfQXRaxqrPpNS6EDYph1pWVz
	40cPciTrivoI3AzwfuFgHVf71EJscxqi1BkaGtC3AdWOg5fFDvSGCxWSjDRBjOZ6cUDL30
	b8ARR2FJp9q8MrpcvrIUepnhCql3+0U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 4B76E5C64DE;
	Fri,  8 Aug 2025 19:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F40C4CEED;
	Fri,  8 Aug 2025 19:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754679979;
	bh=ihLtk4YDljPoQsVr1k+Q6KdWqVvNlEugtmCKJzbpreQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MVbd3V2B9PU2DpN4YFj4kXo77JcV02cklLt8Ew+/o0xBULibQLCGSDhPk+5YuQ/mj
	 6eGZKLNUShdnj3lo4imTZWyM+09/f2GhQBTb6C+0BGVP3d88ljwJ6pK750+ZjcNkFs
	 J83iYdBJegh8zofo/HjfG0v4JbPN3aOrqef3Y5ik=
Date: Fri, 8 Aug 2025 12:06:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com,
 graf@amazon.com, changyuanl@google.com, rppt@kernel.org,
 dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
 rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
 kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
 masahiroy@kernel.org, tj@kernel.org, yoann.congal@smile.fr,
 mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
 axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
 vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com,
 david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org,
 anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
 linux@weissschuh.net, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org,
 cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com,
 Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
 aleksander.lobakin@intel.com, ira.weiny@intel.com,
 andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
 bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
 stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com,
 parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com
Subject: Re: [PATCH v3 01/30] kho: init new_physxa->phys_bits to fix lockdep
Message-Id: <20250808120616.40842e9a9fdc056c9eb74123@linux-foundation.org>
In-Reply-To: <CA+CK2bBoMNEfyFKgvKR0JvECpZrGKP1mEbC_fo8SqystEBAQUA@mail.gmail.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-2-pasha.tatashin@soleen.com>
	<mafs0o6sqavkx.fsf@kernel.org>
	<mafs0bjoqav4j.fsf@kernel.org>
	<CA+CK2bBoMNEfyFKgvKR0JvECpZrGKP1mEbC_fo8SqystEBAQUA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B0F5F140015
X-Rspamd-Server: rspam06
X-Stat-Signature: 8mmxynsfrs3bte8ksgmjfphgym7eapju
X-HE-Tag: 1754679980-974968
X-HE-Meta: U2FsdGVkX18R+0ZnUUIDAlyuXG1R0RYtTG7N4CbCXGwGetuJt1f/XnmpodseV7o9wVBXQGOrQusLHaqBR5I7qbvzlEZ75SsOVvs8l5DpP8QvpntEKr2tav5zWxlzeuyAgKqeBTRDowi2yBFsW2tTLhWw7f+5zoHX5+F8YwG3Jl/25fx63MRdpm4VyRpu27XSQUbdW20T1pkh78Zfk2e5OvI8vOes6LjqQ5KWrTRFRYgffGibDSaqWZ6//aWfYoyxc+gUpslN7YEFA0PNxXCFKd0L5bhIOLm4MwldOsquT8a15XM8dcIpT3q7yfZ/5Bt+P+1v0nBcbtKRSvO2DV4pymxY0oU5Vj3yMzYPf5YxEKwl4GsTKr1sKm2sl/yKCoh7CMAMs9MGs/mlr1BG1Kktj8BhckfAcpI+P74YQ1r4LQoQhXNCi3S+wmmiv1I05zgbvldoKqTRtTfBQdiLR6QqE7HtZ9FjSj5+nnOIRSexbqG04y8J/3iiAcjMTBpfJAyvZBiVoiVeXDSzgTpQ4kEQqeLvOH/DTZfRobFa2HnNNVm6d+MgO/LnSxY4dHaNMFkKxf3/7Sghb18/ouByCvMRU04ax7j6HFOuTsiuaZqkrjHJGCcmfC7XgmOV+asExkN+zc5F1V7wBsf9MC+5wB7sCDgmQfj+NweY1OpX5nZTM43EuIU9Gg9M4HAky/1lhsucmpMukFLG48CpkYt91OOjvnB9LM6/BYhB/tctGF4FhA4LVHpliKeN1bLt0zOtK0PREa+D37YpNZCxeTW24WT8XqSqafQ3EMLhkVHXjMFhGQ8S6LoUmTXHo+YXScBG4RyEqXd+em8HnQCmaeJ1NQ9Xr2WvnQI31pYQ8AHotjPunsrN5/n5ckOj1HsLnZnArG6ecfsADwrdpjO4n8gUQ1X9arPwgtwDm+46ToGgAzVMMXroeQ/oBGATy439JO8HJVKMViG3Rw1ecqE6id0tiX6
 0XLVgY/N
 tsMqDmotehTFuLIxSH4aMvinOe4RKTt2oOeJA6wGBLQgCMFUPi/BPJO17w/7ieHCVMUIlOLZdp3h6jpf/hfwjlCpgyl6pdGXn/inhlYbgsrq/TARyfylZSSImA+fV3gD27yTyHpyVub9WlP17okcsuaeFox3Ssn3h5IxwvUDRLoK+iQnSWIN3Afo9n5Zb34w87McK9YQHRPzUPyfDSfFPxwMuSyoIEkSB93EXCSDYJju7rz2pLeIpIyw/awztsH8NTq/Fwawb6Yj+Zc4WAlS01mqnsfViBqfqpOxKtDQ3uPzbRmv0ZzqozYZqq3U7nrnb2gIWtXtkSrNc9i5dqHFdaFeRvKEXGhfBEHyuweJiso52cnIl72kjuQ+ZNCQETwxwSLmwF9CIXSzngDSReTByKTvJ/QSwPFFbdBd7/ztVepcROBPxEm5H+745OKzR9qCr+/iTXshZjcB8/1I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 8 Aug 2025 14:00:08 +0000 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> > > I suppose this could be simplified a bit to:
> > >
> > >       err = xa_err(physxa);
> > >         if (err || physxa) {
> > >               xa_destroy(&new_physxa->phys_bits);
> > >                 kfree(new_physxa);
> > >
> > >               if (err)
> > >                       return err;
> > >       } else {
> > >               physxa = new_physxa;
> > >       }
> >
> > My email client completely messed the whitespace up so this is a bit
> > unreadable. Here is what I meant:
> >
> >         err = xa_err(physxa);
> >         if (err || physxa) {
> >                 xa_destroy(&new_physxa->phys_bits);
> >                 kfree(new_physxa);
> >
> >                 if (err)
> >                         return err;
> >         } else {
> >                 physxa = new_physxa;
> >         }
> >
> > [...]
> 
> Thanks Pratyush, I will make this simplification change if Andrew does
> not take this patch in before the next revision.
> 

Yes please on the simplification - the original has an irritating
amount of kinda duplication of things from other places.  Perhaps a bit
of a redo of these functions would clean things up.  But later.

Can we please have this as a standalone hotfix patch with a cc:stable? 
As Pratyush helpfully suggested in
https://lkml.kernel.org/r/mafs0sei2aw80.fsf@kernel.org.

Thanks.

