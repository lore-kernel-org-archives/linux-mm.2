Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35AFD606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=PkoQgoXP
Received: by kanga.kvack.org (Postfix)
	id 34EF76B0811; Wed, 21 Oct 2026 21:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3004D6B0812; Wed, 21 Oct 2026 21:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EEFF6B0813; Wed, 21 Oct 2026 21:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D891E6B0811
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:14:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B5B1A82D7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:14:49 +0000 (UTC)
X-FDA: 85348492698.26.51C421B
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98CD7100006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:14:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PkoQgoXP;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792631687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8oVHE7uhvQM0uF0tb8qagzI2B8K9hhXgyXmbesBuqk=;
	b=zREpF0emEf5UzbuGrweLFNi5661QY7DAgI47pLwuqB31Et0XCgrYK67tKETk5k5dZApFvt
	zpKErm6EyvASxuUsHH+JMx3rdlqnAxlhWjgHVg5kZrvBzh61dtfZkDeDNyCMt3O9aqrMWj
	wr6qIaSRkRhQ6exSLvzRkzAOtBjxX0E=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PkoQgoXP;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792631687;
	b=eHfOHAaHw4Jc949VJOHpjvSoxoIKntQSUt9kTDkCVDbiSwn9CTS3Z+pf+D7hdp0TiIlOJY
	0nw3Vy2QyLzWmK1p80kcb15s3iprLn2u46I56pHB6QQsLaroxc/MiL3aBIj2VH6ynGsfq1
	jnfPnh8sUPjm2ukN0Kog22Rxg3XmRvA=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6af9a9451daso1950649a12.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:14:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792631686; cv=none;
        d=google.com; s=arc-20260327;
        b=FSHr0qdbkCS8fciuKnLBPL/PnPn9YRwtBVePCcZMpqMA1O45Gd4hSQpJu+mFYa+CSa
         9nGh03JI+CEaNJ4hYZXoMsklcO/ukTT17KniOsqw5yvebsUj4tUi+AvF1/qAJm04/7+H
         PTFqupP6qRGSiGepVoHYgH4d+0PjW60JxdzzNn18Uo203RkCkeis7P5xPmtKKwDb0EUb
         bjy8PIgVMocX7CBOP/q5HBV+iXl78Qyw/c2NxBloOfUptn+SBdcHv31k/5l+8s1IqzWa
         TE6HTIOckntmc/DMgPeCMtfssoyDN1HO3Pp0RrtTRWeQac1zWuqOS7WoWyhktD0VhxAk
         puCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a8oVHE7uhvQM0uF0tb8qagzI2B8K9hhXgyXmbesBuqk=;
        fh=s3Ia5Bo8LoJsMz6HhS9gdgYzlTg7qwqKwFKJay2Wkb8=;
        b=LmTp3Yi5WkyDQjaNdIfKt2nuU2nEA8P7jI8Hhjlb59LTGnS3Hd0yzFPAA5NLOLKsbw
         9RjV7iANeUpUc3YZKH6E6UiVm/xU/r/d9YrqMF9uJmR1k52BCjbuiiu3axREenJ3qho5
         HfRsk+IZOQsUzCelXX0A0LinpgaAqIm4fSFpB8FkioKpSp3o/T/1qoUtyCegzw+79sh6
         qFWBxAGe8ZTBmJFg+HwLvRy1WsFe97ecJeEM+ljaBigITa6kEXnQM+2lfNcHGhZE4zVf
         1QZn1IAaZsg6QUNoRTYj/Qo0gB49QrZohopvPQ7xjeMzsxqumrRdw5lwdL6YzjIFFllk
         HzJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792631686; x=1793236486; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a8oVHE7uhvQM0uF0tb8qagzI2B8K9hhXgyXmbesBuqk=;
        b=PkoQgoXPs/5FFZbT/P9ulC9AAcnuTbuOwp8R1f9JE4TwmXsVhA7K8b4UyN8Nl3vz+x
         3zV4BKENyxOo9dafVFrCgczBHJG/XWMz49BaivzhLoCUnnCxOmIvZ0wDrgU6gUqKI0pS
         YlFj6Pmh3NBpWNhS2yzw1bZI0ihv3/LbK6RVh6y4Qqd1BHq4FjLu6QY0VVLIVQ0SsAUd
         et6XEPEgDb9kUJx2+QaDnCcKR87nhImmYsFM+ZNBs8niYTEHhj1miSz3HHCtincu1sAO
         H+kuFXLK7jwcpJ1gyx+PWySPMkY+3sV5e+BOx2mc5EZ+cyoWOYCSd132v0fYdGG9fubG
         yczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792631686; x=1793236486;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a8oVHE7uhvQM0uF0tb8qagzI2B8K9hhXgyXmbesBuqk=;
        b=ZLkGfn8GBb5umu7EnZxKR3c1rCCcD/WRcO+OzCRkgpleNDdlJ5XA9MlpYikTO/V41J
         pmy6QPwHvmoqdylNNA94EciFz44NfPHOoTkm+B0WfgNPkyA3WdRrqpn9BJnfn5g57znb
         TUwMOW13ZSriEvkYw/jGcDzGXhHQ+ERYnOqa3gDnA16tGcJ0cy4uy5sGyzjTLvFhCxcE
         KTJCURHsPzKvDpgIM5xceLXIHd+09AWLfkKqlHkpPnAWAcm4EXTuSLpp6IF0LYdj9+GA
         BN3dEuDFXi7IVvzm6HSaAYTQjjvsqZgzB81/l1ZFPi3UDaig/4oooydBr5XAMOwsLQIs
         zH+g==
X-Forwarded-Encrypted: i=1; AKwUvBzbsJCxdo2DiY/yTwz3bELplnuLRMAXiHoVJ+r1ADD2HM7Vhk9iX0nFklvuUBPjKHC7X8mIFG4jJw==@kvack.org
X-Gm-Message-State: AFq9FYLjd66UDZk69k/n+NbwBfFbr2ktJsGcokZEME5cxaIyrf+m+htH
	GxIXgq0Iw2Js8OLXbpFaus3XdHRh1qacyyb0nrlbJDqHeZCL+26ITaDF/ZfKxC0tHm5ef2QV+nV
	gg7WJpHPPxPIb0oay6LUR1dCEPmPVzHnt6sPrIKo42g==
X-Gm-Gg: AYBFou2Cebk7fgaeYp7H4qgQ5l9MHPeJ0NwmO1bSqJOueJMj7vGZ/SfGTn2Pnql/PZ4
	pgPxMMbPHzUxYthoBwLXBg7IiNRBcjz+T1wmC3UMlcgILOfEIrKcf6zPMrj08n0ptkezbobrYpP
	3h8wZPyl8lk152gBFGSIhR/ACUBpYH0BMKWdWvKYAANAxn/26eoIXWLYunZe5wM1S7qEj3IlEjf
	sGkfEUwAwWQALT/bH+U2yVJKHDTWfOuO085uEmnnefSzJBjjOErxHKxzJxtNtiYxS5BUgV/AEt3
	4K+y1dFpa813j7FwguRB/fDn8rll4GzDvQcG1cVjwjWOw7WC55KNs6Jqmxki0rE2IaOshdP4T4h
	eZjTks5WPs6LbD4149Gokzs0T7bwVwsnMGJ+Y7WkgJ6ISO4YVPrrrjXhkv1c9lNSQ1AghX0qbpg
	6U/z/Qc8557/Cj
X-Received: by 2002:a05:6402:428d:b0:6b1:b5b8:b696 with SMTP id
 4fb4d7f45d1cf-6b408eba0a5mr2764546a12.23.1792631685748; Wed, 21 Oct 2026
 18:14:45 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-3-tarunsahu@google.com>
 <CA+CK2bCnS8wcVDbOymBGeJB6pDUkknOpF22EynbwSV=D5=J4ow@mail.gmail.com> <atlEdhPjlyTPDWmG@google.com>
In-Reply-To: <atlEdhPjlyTPDWmG@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 21:14:09 -0400
X-Gm-Features: AclHuK8ceakYR2BnO2tCnQU3MVfSYSSwRjvSGLmyMHhBXtZBiFnzxvM1Bfsv7Tk
Message-ID: <CA+CK2bAxgtx2gZ-UE2HqwAU8=h9K5RE3xozBs1njgLo1-CaPvA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/4] liveupdate: Select file handler by name in the
 preserve ioctl
To: David Matlack <dmatlack@google.com>
Cc: Tarun Sahu <tarunsahu@google.com>, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 98CD7100006
X-Stat-Signature: oozanb3dk9qi3h6fcedbwjycfhj4pjeq
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792631687-972313
X-HE-Meta: U2FsdGVkX19JNYhCm+ynj4G+oeIikdvMLwD6f3DNUVj0gBoUlcOuag3CJDROcAg5WspDuQYgwlUq955ujRPuDFizYBg6+Bo5BTRWAt4jNE1rmbsRkX4pV0df/qZsgapa4InAQai9IXJT+WgrKUxKdXcp9059fzxq9A15yi3bknON6qL6SY9PE/YJv3iFbY9jotvfu+Ihk2KyKmC3JJsCopvGhbO7WHYMr6Iw3z7uu6HpyyX7xu/nXLBKiG0RPjiwuN7rcghnIc/TjsZZVaCo+DdNWruyBerf+UTC9BPCJ/UBQuQS2gIzACHNpA5rkyJgNb7KiEB5UJJ1Auig+ijnXUd+FHrotWDUL+sFQfO8DOPI6jw/U++ph4y6G5QSCz39QNg9TzL57pgS0J4pXDHi1FPx4/YBN1E83l7UvCpMan/MEYRfvPLFIP8ZsWhcnaoQud1lzEqAEiXIkA3/Obfo6SQWymwROSfqPVsDdhsBymNtHo86d4BaPfP2BE/UAEdZ5zqMchSibMmX4sjOS/imzyikqXYgcV1OwExO3aH1HM7XpGtTAbNBUGeC2YwAhoyMOMnIIIHRWO4FJDnzmb5fV4sQXX1Xzjqhq3Vrmb0/WbvWpdR7VXVL/VDXPqQ+PJ6whekj2Bma6OpafnGRrpFjjY8p+7zJmc32J7hV+XEfZ+DyVIWhtFSDpr6GMZ3s6dIvI5NFIBqYGxvGYZHrHho1EFjqcj50kAO7Jw6wSa5PrWyFlKgJFqYw/qS/6XwkOD8f7rYr9x3+UWcAUS9o0zilrD3EDcCKvC5zkjGSoXioTKJIZxNnyEHF/7uBMZi3olbZDTRSB6je1usfmpQwpepDjPJyugUOkyFZJHTHPNY07Sr28KuBa4pTmLND2b6zJrGSCQYeypaVPnlpHKIjHZdNnb1JEER7kzCs0Fi4p40SBon38i2pesU+OskrAi8eTjM/Z4+QzlcU20SvSzRLLxf
 bbEzypP/
 yWkADynkNm+Oj1A7ZjRQKjo3njnEDFGsvzFmtR9ArpSDsoBi3g+TlSBVQAk0HngiearnL5Hp1G252ReXCNYpvdiSjpUL84lei4ZbTeSOC62POP5ZeeTzAmZ2tEDUVmUkJsQiqciectFBvtE0pUUgSL83bDoitt6+gnX4XNLBv/b5MwUpSDOdLC6oAvWMTrKOR1aNB3lGB2Aob/KG5ahT5QmWXWg13aABeszXJBs3As4sfaB+ulQd5ox19+TMRumR7jtB40AQlUAtrytg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 7:02=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-10-21 01:17 PM, Pasha Tatashin wrote:
> > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@google.c=
om> wrote:
> > >
> > > Currently luo_preserve_file() iterates over luo_file_handler_list and
> > > picks the first registered handler whose .can_preserve() callback
> > > returns true. When a subsystem introduces a new, backwards-incompatib=
le
> > > file handler alongside an existing one for the same file type, usersp=
ace
> > > has no way to choose which handler preserves a file descriptor, nor c=
an
> > > the kernel keep the existing rollback-safe handler as the default whi=
le
> > > allowing callers to opt into the new handler.
> >
> > That is not how it will work. If we are in the .can_preserve() call,
> > it means the user has already decided which file handlers to use. We
> > need to do that before any preservation happens; otherwise, we could
> > run into conflicts on FLBs i.e. FH of different version require
> > different FLBs.
> >
> > Therefore, there should be a luoctl call (i.e via a new ioctl to set
> > compatability) that provides the kernel with the specs file of the
> > target kernel we are updating to, allowing the kernel to select the
> > compatible file handlers. Since .can_preserve() is called when the
> > user is already preserving files, the specification must have already
> > been supplied, or the kernel should fall back to using the default
> > (i.e., latest) file handlers.
>
> I don't think that is the right direction. IMO the kernel should not be
> choosing which file handler to use, userspace should be. If userspace
> gets it wrong and chooses a file handler the next kernel does not
> support, that's on them.
>
> The problem with the kernel making a decision about file handlers is
> then userspace does not know what arguments to pass in. We are adding
> custom per-file handler arguments to PRESERVE_FD and RETRIEVE_FD. If the
> kernel is picking which file handler to use, say for a memfd, then
> userspace doesn't know which arguments to pass in.

It is not the kernel deciding on its own which handler to use; it is
the system admin (or host orchestrator) that configures LUO before the
LU process starts, because the sysadmin knows what kernel we are
rebooting into and the LUO specs of that target kernel. Meanwhile, the
process calling PRESERVE_FD (e.g., a VMM) only knows about its own FDs
and should not have to track target kernel serialization versions.

Also, the PRESERVE_FD and RETRIEVE_FD arguments are uABI tied to the
FD type, not to a specific internal handler version. They are stable,
and we can expand them the same way any ioctl argument is expanded
(via size and flags), without ever shrinking or breaking them. We
should not play the game of providing completely different uABI
argument structs for different versions of a file handler. If a caller
passes a new feature in the uABI args that the currently configured
file handler version does not support, PRESERVE_FD simply returns
-EOPNOTSUPP, just like any other extensible ioctl.

> Sure you could add some method where userspace could query which file
> handlers are active and decide arguments based on that. But it feels
> backwards.
>
> I think a much cleaner solution is that userspace chooses file handler
> during PRESERVE_FD. I would even require it for RETRIEVE_FD so that we
> are guaranteed that the args the user is passing in are being sent to
> the right file handler. Passing to RETRIEVE_FD also opens the door to
> transforming across Live Update (similar to how AWS did LU from Xen to
> KVM as discussed at LPC).

On RETRIEVE_FD, the preserved metadata already identifies what format
was preserved. Validating that the user is passing the right argument
struct only requires checking the compatable string, not selecting a
serialization version on every call. And if we ever want to support
cross-subsystem transformations on retrieve, that is a retrieve-side
conversion capability.

> Regarding FLB conflicts, today we don't support multiple FLBs for the
> same global state, so there is nothing to conflict. Selecting a file
> handler during PRESERVE_FD doesn't change that.
>
> If we ever need to support multiple FLBs for the same global state
> (e.g. an incompatible change to the PCI FLB), we can add an ioctl that
> lets userspace select which FLB to use before preserving any files.
> After that, only file handlers registered with the selected FLB can be
> used to preserve files. PRESERVE_FD with any other file handler fails.
>
> That keeps the FLB decision up front and global, like you want, while
> still letting userspace pick the file handler for each fd. I'd also
> expect this to be rare, since FLB serialized state can use the same
> feature flags as everything else in this series.

Userspace owns FDs, not FLBs. Whether a subsystem uses one FLB, two
FLBs, or no FLB to coordinate state across FDs is internal kernel
plumbing. Exposing an ioctl for userspace to select FLBs leaks kernel
internals into the uABI.

Therefore, I think we should not select FLBs from userspace at all.
FLBs are an internal kernel mechanism for sharing state across FDs;
from userspace, we only preserve FDs, so that is what should be
configurable, and the kernel should resolve the dependencies and pick
the FLB versions accordingly.

Changing one file handler may require changing another file handler
because they share an FLB. We can't have a situation where one VMM
preserves using FH_A and another uses FH_B for the same FD type,
trying to use different FLBs for the same data (since we can't
preserve the same page into KHO twice). More generally, we are
rebooting the host into a single target kernel, so compatibility is a
session-level property, not a per-FD property. If we need an upfront
global ioctl anyway, configuring the target compatibility upfront in
one place is much cleaner than exposing FLBs to userspace and
splitting version selection between a global ioctl and per-FD
PRESERVE_FD calls.

