Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A9FF46C53
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 16:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91FA6B010E; Mon,  6 Apr 2026 12:06:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42AB6B010F; Mon,  6 Apr 2026 12:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30DA6B0110; Mon,  6 Apr 2026 12:06:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B3B0F6B010E
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 12:06:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65872B9931
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 16:06:49 +0000 (UTC)
X-FDA: 84628609338.17.08CEC2F
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 377AC4000F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 16:06:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lRm6yYF5;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775491607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cOKcd1E+kh/rgDmBatc+5AEkevvJqYiqh34IKuXZ368=;
	b=YiJgoywOdVGxRVoxku9dHsZtOWxMGM7AUK/wkjLfueW65nZUnt1g/QfeoG1phdN+aJCDs2
	MiJcCdoV0DThy/tnzqGQOC95vpwnSSA2KXT9YeYKyMWdJ8D1cxsEn+evLCFkSpRC0pwswp
	nVMTSUk37ov1pd8gCWUgTq540egNm2M=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lRm6yYF5;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775491607; a=rsa-sha256;
	cv=pass;
	b=Gig9l/2GOCStPPmwro4VeYacC8bBOpSy3hTPHYugspT14YYRxZ7isTJOAmblPlEKKyaRV9
	q9xJd6hVzMguaDLBqfx9Px6m95sSdbv6iTlM74SP9RwAip88+YAcioBFWJklVzENw6PnYl
	M1IaD/StSdnjB4Aofg8aMvOGEPnhvcs=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5a3af1b7549so3457371e87.1
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 09:06:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775491605; cv=none;
        d=google.com; s=arc-20240605;
        b=Etqc92odMT+OlyMhqfrJ6dz9WvvrdEMZ2Udof7vWYeJ2dvUcSx2tpKqSwmlMZtbPml
         ro3wCbqBGs+EGLKO0QiwSQItn4G8vb3fCNVSpaxp9Rv4E9r+MfqPEee9gOyG0HZo4TkW
         WqZKITgloj5cZKD7GSBKdBNTF78nB7cwicbDiJvYhBaBkCCrS7Ugsvh1JeewJ5crW9vx
         sjIcvd0KaFoXJenTq0uK0+w41WAjAq3iDlOkAGiAzmOaItRAREsGlisX8nd6WlHO2u4E
         OqmL5/sh1JbOrI+WLT8xbDHamnsTWmN83kBrwiBUkeGnwMUDFv5AZD1GH/izNhn9hIrL
         jjkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cOKcd1E+kh/rgDmBatc+5AEkevvJqYiqh34IKuXZ368=;
        fh=AG0z8IN0ZHEpj/WZRtmJcA9t9kzB//rLfCwPtQEyu0U=;
        b=e+Mru70D0qGDFSzUKc9/YqZUhQ/fh3seICCjd7HzsUDPk4kN7xkBvOnyD2ltgGVlWl
         aU10clWTyrqQ++vh74ReBDw4Hkj4HHAg6mbFSyaUyY+1qw9nabPMIkISl2++iGpLvHAj
         4MofbCbKtFZyKL57ov9b06huXEe/ij6TJXg/QtjQ0Tdolpokeob5f+8GjEBAaKyQ+Ty5
         rPR9W+NZQXDLPtex7ON1AyQtZle8lox12ji+2aMN7QQO+HZqi6IQ25Joog57ptmliMw3
         yVHDdscwBmRRDwM0jYVyl2GhROpMKjczbOvllG75t8THs8czEf2JG46A3f635tCfLHfk
         2Gsg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775491605; x=1776096405; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cOKcd1E+kh/rgDmBatc+5AEkevvJqYiqh34IKuXZ368=;
        b=lRm6yYF5eHEpSDWb4j+kumzv4vRsA50wFMtWQBz3CYgtXpKr4+hE28RQA88bhjO5tK
         LZbm5cGvE7YdGMLDYwtBP1lxsQs0VrcrhIkXqcSvT0fOWBKsWMbve4k8flWEr6C7UnZj
         ve9C1zOuXziuJ6HoWZQZ3H0UL1N4AC0lHvX8DeOb9y+RYHo40sT9hxK/BusCjwf+TdWA
         FbTwfyFW+1yVt1p2XLH2NQtFZJu1H49TI9mg+m/+nbfDg+gbCfkwbXxkwkJLogoD/Mw/
         Crb4xDdXFsrSUa6dc2EB54EjNgsq1Ks3yRu0VOcR8IYzJrKBi0QZZIOtHc6mQu9rSmQw
         6J5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775491605; x=1776096405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cOKcd1E+kh/rgDmBatc+5AEkevvJqYiqh34IKuXZ368=;
        b=pNYf1jahE0pwoxpfv9dRqRGA/ePnq5Wx969Yv1ajRN8UTIWVb9w8cKx2iYaGFmLQWf
         2yrjZo9vWfTBYYzyyfERAn7cm8Dp6bqiDcq/8I+cMijvzqEpITRBJv5lqLpWxyEWC+xU
         gjIPadT13jmxVCboU2ZLmxar1HD7mIPVkw+Ibm+iIDa6ZR5erAwDNVGCqXsnLLLx1u92
         2kNBweYFbaTZLEdZ9Q18ThAQUV1OfMaUjcj45WMUO+V2suJyTfKlZCLsU7QeZb13GEI/
         jqzwBjGHa10JFzYIHJw1bd7Y7Y534+ghTqHIp3BX9EAXXibAVkvGM0bQwa+0u4z8tJy/
         xyGg==
X-Forwarded-Encrypted: i=1; AJvYcCXrmeTD32i6dVZSV+LDrL8IwEh0SmpbFjb2kamsiTYF3VbyjJXSa4vtG+3xttC6T1qak6TCDk8A8A==@kvack.org
X-Gm-Message-State: AOJu0YzrH9rcdbT+GWzLLqgHJHhBDLU1axki12Kmk0si0i6J0vWgRmPL
	eJrt6YaOW5IsAz/Z1hoTjFwfvh4MM005l+brb39tGsSqTdujdTL6qC+elo9T0Y/s+rQYwguLTTL
	d5z9EpIO6t9EBO0kiqkdK0it2Wkllv9Qz0yNJMKlK
X-Gm-Gg: AeBDieu3m/P8NRMdVw4brCGr0DYA7FKUGqa5sOxhoQQaqVvhfK7CnjY0bc6dAFviiLT
	b/tWMYyq+VhCzxhvOZVwbo8Ozb56iSA7Dg0FmALs9kez3UmopBMVDIac2OmoW4T3IcSlasPE61u
	QzG70e9/J6oknqDgKCs4GAq0beQdgLBTfpxcPdvwa1KSHzc7RbPgps3MyEuUYPSQ5CXNLOZzMvq
	KcbV6hiqkgMjvaNVhD6XB6+X8ddwv3qBoXaJ3Gsw4qWl6LJka3qDT1KT7Y8PTE29ldiE+XpiALX
	680/oL77
X-Received: by 2002:a05:6512:33cd:b0:5a3:d2ef:2f93 with SMTP id
 2adb3069b0e04-5a3d2ef2ff2mr3364086e87.30.1775491604807; Mon, 06 Apr 2026
 09:06:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com> <20260323235817.1960573-3-dmatlack@google.com>
 <e3fe7085-1297-47b8-bb17-a48196e8f37f@linux.dev> <CALzav=eyf4XRTi8MfE_GBNSm+tjmfX7=d0M8Aj5Hh0vJn7huew@mail.gmail.com>
 <c4138f66-edf2-4689-b5fe-16dc4839e9c3@linux.dev>
In-Reply-To: <c4138f66-edf2-4689-b5fe-16dc4839e9c3@linux.dev>
From: David Matlack <dmatlack@google.com>
Date: Mon, 6 Apr 2026 09:06:15 -0700
X-Gm-Features: AQROBzBbHlG2eO4NjewlbX-rvy8OZhgqlWaRP6spr5d6_KAEWYAdDGH-j6HkrWs
Message-ID: <CALzav=ei_xSfM0MTdPFhGDjNwe3EQ0vHPiEk=vszFX-Xi_KjQw@mail.gmail.com>
Subject: Re: [PATCH v3 02/24] PCI: Add API to track PCI devices preserved
 across Live Update
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Rientjes <rientjes@google.com>, Feng Tang <feng.tang@linux.alibaba.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Li RongQing <lirongqing@baidu.com>, 
	Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: rypm43ni9psoojx8yegxnp83b3jkp43h
X-Rspamd-Queue-Id: 377AC4000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1775491606-14363
X-HE-Meta: U2FsdGVkX1+2vDPMZSrUzr/I5x2byVfggp2QBN40aZISRncFAukHYZoHzz2wynjwkpwMtfYYDf1zN2dsJ4zmko2Y9FZUKhD6jNll//cwGFfIimy1tE4VRJiKTAfSyFfo94ej55SpEVN3x11g3Yk8ifflypQ9NiLS7M8HrA0kO/6YGzsahPg/bQsUYhjbX3zPq9AezEgqxANPADopfbnurxYkVP83mXr+f9H8QpAhBmv+I0ecM6DFJBcQu5qXnLtKS2V1bYzygJmky4aYkOabqkYItJ/StQLZ7j/AXMueq6wAknREAOeJkCK797CDzezVDZwXdAKMEBvKQ8L95Wvxr4pFVnDHsGkWi3TiFBIw0CpPRDTAoAbo1DD/VlBEDPaI40JHIYHIvXNKGa6EpY7MnH1azw39zzVJqoh7dl5Tf4641HBtl9JZeNSfDgI0RwEGCqWMHbIfjKahzpnRTue1/MQ0Z09JNxeT/uAAynGj4gdjiNLQlCz6ITYC165aUal4SQu+E90S9LFwRvbjT9Mhpl1uK2o/+Cv7JI2mHgZqYcL6YNhhxukChVq9Tn58L8rNBFJn3jTQ6zF1xq4iBaSd2xFowiACiqv1pTQtB/fmHU+IV8lgek+ojb0Rm8rxPizwta7g9hpRigItf8L6VAODfH5xqff9l/RSS5dVIX+fNWkiN1BHkzDoPtIAGpVrxvS6ix8liNIoCIBjjhv/nfH3JvbVcziGcdcaQOYCCvtwfq9fwa5j2xwrIQwrIXVo4IqWUmXYvdKj3u2nl9+mq64H1BAifuXRmamRZ5cfIRbqnBhdETTSCDTZBwsp658tHXiAheFvrIZSIiam8FYLrehUEkoDAe8ffiVOX0tKrQZhI4y9bmQgzp/l+mWarmvZoMMsMlBUd2ViIlsSRm+2oiJQzUi6ptD1BV5012npaN/7GZdhRjn2Bx44TVRX6pEavfjJmKgFAhZbB5pGsv4zDmP
 l7TCNvok
 YJVL0iCkm/K737k2cGr135T/8VWWEkOB6hcXrDv4k3UmH/7Xjlp7tUuvMdi3T1el5loMWGje8HYOOXyZRQ00xAnA2lccr6FNkK05ce8wDm+K16qK2NmmjXwXdboJW9UG9kx/5QJtEegxot+pDl2ezQxT//cXtA8bhy0Li4zXDtB6OD90QF9gKqalPIOXAG93dDmqjtnqRYLusUBnmXD8zd+9flyei+lRhWQMgtwggeg2aU29qNNtuc+j98S2s8T+bRQRzE4LAPU7AZdDWVHokghRpLpkFga+O6FctICQs6cIS/lvNIjmZe3vF3jk/mQwsf0p8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 5, 2026 at 9:56=E2=80=AFAM Zhu Yanjun <yanjun.zhu@linux.dev> wr=
ote:
> =E5=9C=A8 2026/4/3 14:58, David Matlack =E5=86=99=E9=81=93:
> > On Thu, Apr 2, 2026 at 2:29=E2=80=AFPM Yanjun.Zhu <yanjun.zhu@linux.dev=
> wrote:
> >> On 3/23/26 4:57 PM, David Matlack wrote:
> >>> +config PCI_LIVEUPDATE
> >>> +     bool "PCI Live Update Support (EXPERIMENTAL)"
> >>> +     depends on PCI && LIVEUPDATE
> >>> +     help
> >>> +       Support for preserving PCI devices across a Live Update. This=
 option
> >>> +       should only be enabled by developers working on implementing =
this
> >>> +       support. Once enough support as landed in the kernel, this op=
tion
> >>> +       will no longer be marked EXPERIMENTAL.
> >>> +
> >>> +       If unsure, say N.
> >> Currently, it only supports 'n' or 'y'. Is it possible to add 'm'
> >> (modular support)?
> >>
> >> This would allow the feature to be built as a kernel module. For
> >> development
> >>
> >> purposes, modularization means we only need to recompile a single modu=
le
> >>
> >> for testing, rather than rebuilding the entire kernel. Compiling a
> >> module should
> >>
> >> be significantly faster than a full kernel build.
> > I don't think it is possible for CONFIG_PCI_LIVEUPDATE to support 'm'.
> > pci_setup_device() (which is under CONFIG_PCI) needs to call
> > pci_liveupdate_setup_device(), and CONFIG_PCI cannot be built as a
> > module. This call is necessary so the PCI core knows whether a device
> > being enumerated was preserved across a previous Live Update.
>
> After the following changes, the liveupdate.ko can be generated
> successfully.

Sure but you've broken the feature. Now devices can be probed before
liveupdate.ko is loaded and the PCI core will have an incorrect view
of which devices were preserved by the previous kernel.

