Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D35CA0FF2
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 16:11:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23AFB6B0160; Tue, 26 Aug 2025 12:11:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2118A6B0161; Tue, 26 Aug 2025 12:11:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127866B0162; Tue, 26 Aug 2025 12:11:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 043406B0160
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:11:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B92891A01D2
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:11:11 +0000 (UTC)
X-FDA: 83819397942.12.2C2526A
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id D8FEC18000E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:11:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="LSAQ/SXc";
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756224669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BOi2/n6Xz+xQb5GUHHEjvZymVvCpQ6XbmnK9/vs2FEY=;
	b=HH8nSOXVxA4QY1mV7vW4jpVogTwtYF1uPd+ZXANi69C9Wa1KWnLELOyeveua1Dp/GpNP/g
	6iWdI/YZR5evD0ZjWETEu3lbWFmQUpCMrHmGGk9oREMTuxpRvumEL0iAPtH+D2F3WSGJ8W
	PxG+8+jM4eGxNlYmBFPNvuc3uxk081E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="LSAQ/SXc";
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756224669; a=rsa-sha256;
	cv=none;
	b=8dLrnTnhIzjD9T6CbU1sLkMc4S9Y2JY/ev7dfMztQeyhOj+bmdPZTwR4+7hpYdo166E/ny
	5YUYZrmITg/IbL40gXJQHzVgcFEfWa2J+hDTIirFV8zpCaMetgvW9ilBapV2kf9HaiPLLf
	u3u77a6ywv3uxei20pH+/YSyxZEneVg=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7e870325db1so575533785a.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1756224669; x=1756829469; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BOi2/n6Xz+xQb5GUHHEjvZymVvCpQ6XbmnK9/vs2FEY=;
        b=LSAQ/SXcZH69f7lbgTWFpRFCXUB20SMxyHBjpxHoCdhbJb77RhQAtR79ukLZSHM38T
         bE5qhIg+71c+onQz7G1jufdCPFF1PPT7tzCb3Nipm/WNg/vozrfBQRDz0TXQmh1NhwAC
         j+je3MXCgeCVve1fjsRBnnVvZarHUPLmbZNCyv4bRmvuL6dqdivpR6rWDWNQmRP8sT8h
         fgJaxG/SHEeULZIIqj1D/bQ3uWZibkEjetil+cuFGvGUGuZAZd5JhEsT7Q/cpLk4GEF7
         vckqXfAUfXI5GQ9J6fJ9rhyPt4R851Gh7q81lSGPKGOOplQ50kVtZV0wAA7OnuATv5m9
         sQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756224669; x=1756829469;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BOi2/n6Xz+xQb5GUHHEjvZymVvCpQ6XbmnK9/vs2FEY=;
        b=JoXoye0KBDCzMH8UwFy+d3RnRjSBmiFuRKomA0BKF9VVc4whRauOWO5c4YTWqhNmTi
         fiLi/i7Mg95QLkmnd5Cl1mgPLsuPGNl+ilgEpCn3lSyG3vTvu17LHw7VatukTIHPdQe2
         sdkwNglBQ4RvGuPs6uVJHDE7NdX6UCmf4vkXPzu4TYYm3udy0vf/+VKHDgQ/DpPU//0t
         0g9N8jLsulBjVgl31iufBLHNBz8dcBvWwizr6LEhcvI+P3Ab/XVIvEi5M9LdEUO29wqi
         tjBe7wGTPwbBeAYHkWEpJYc7Nso3iVqdOicyrf+WtJq32Zl8nc5HSx1kYSRA2A18FiJo
         6xNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBBKKJoMqLdk12JzMAmk1aa4ZRaVHRybVdIaWBfO+MXyZb9uzey2CAk7Ahl8ETYlmAjMyGFNYqZg==@kvack.org
X-Gm-Message-State: AOJu0YwZmifcrICsJ2gev3J1xhEP2FkhJIwRTilJ6kCEzVRhFWS7epQl
	PVcTRy5QeMbHhNy/eDE+qB2qR1JyvEMBNf6Udvd7SgEAiFw/SDKCQUEgXz9ytALDjR7iD+z1Zhv
	bj2c7mCABnE1ispC3jKAFlYpN6kWLpqcY3SZRmbNPEA==
X-Gm-Gg: ASbGnctRb5FUcLxOJfZVRqkYG0BYouTVoUh/8jD81OPjWr5Q4vhVijBgVySCZD+djVA
	tc6U/2KLEFe0uOF3aqUC0ZZd8UI1QQUm/1J17wXh3l6qO6A79XodYvJ3boiF+DHSjoDjqmaUjP1
	R0tsyCeWx5ncuy+BJUWbHaeY6in6oACb9awHoZaUxNbaTYLJFTWDl/SRJwoJd3O6Evr0MbHxk18
	wl/
X-Google-Smtp-Source: AGHT+IHEi3OE7lLiMPp7C5Vv7KNwlvLIH7ud61BnCQRJa7ny6WBbwsORCRR5wSbzLMiP0IHaIOWVGEwTlDbKi+wkxxs=
X-Received: by 2002:a05:620a:170f:b0:7f6:88d3:1188 with SMTP id
 af79cd13be357-7f688d31502mr113653485a.86.1756224668510; Tue, 26 Aug 2025
 09:11:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <mafs0ms7mxly1.fsf@kernel.org> <CA+CK2bBoLi9tYWHSFyDEHWd_cwvS_hR4q2HMmg-C+SJpQDNs=g@mail.gmail.com>
 <20250826142406.GE1970008@nvidia.com> <CA+CK2bBrCd8t_BUeE-sVPGjsJwmtk3mCSVhTMGbseTi_Wk+4yQ@mail.gmail.com>
 <20250826151327.GA2130239@nvidia.com>
In-Reply-To: <20250826151327.GA2130239@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 26 Aug 2025 16:10:31 +0000
X-Gm-Features: Ac12FXziiQIerbPv84meuIa4-TsBxggHz0dU1bLBX-hwN0ZHUFz86xiQcWhtMqM
Message-ID: <CA+CK2bAbqMb0ZYvsC9tsf6w5myfUyqo3N4fUP3CwVA_kUDQteg@mail.gmail.com>
Subject: Re: [PATCH v3 00/30] Live Update Orchestrator
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: h41wdzbsub6mp3yhi6ifaotxiofa79px
X-Rspam-User: 
X-Rspamd-Queue-Id: D8FEC18000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1756224669-29991
X-HE-Meta: U2FsdGVkX19EFzLc4XvMNK9Y4o3BsE5GQLu0OV92cPcG8Tc+9zIgwcReRW52Er9zAZMkcIrWQB1ezojx+2TeStrBpLj79j/DIpDLdaXRLiHaf2nbr3/FP2qlXhOhjc/0n7zyOFX5SnxaxQd1fqkJkjzQxrIplQUOCQPPbey9cTDHxyzI/nZL7QhnkO5vwECrc2sL1IQMk2iRksXBIQoM+wFx9pElXBjJvUNw9HyNJqtiUXAOoVY6+Fa6v2bZfi4ecOxZJ3gWozCLYCO51/GeqhVjh5cMSasS7yfSu5kj9qx/QtFcsDcDZRwYcfZmxIDvmt9Xj8HyQDnTNuRrIkMgootP6ZqQc8GLGHoFPRJ9cYnf/5XTbJ627EMvW9sEEsaSksYGatHQQBu6a5SKkEnblAF09o6eKbWWHzKfiCZqSeAl5+m2qYNmbgS9Bh1j87W6hThLW2zNWyRR5PFbfneZ1n91hzcVc+oLzejV792cC6iEsnbb9f92KGmK24e14M+Jm2TA9ehGiDgY7AmRc5UgNgrPAg2eZcsAG3GYpyZYdWiXMuZ25m0oOwL8x4PYV1R0JKXc26JQCPp8pQ9785Zh60NjTfSts29ob4rSkIf38fY46z/0nDtmeqKG6C38DCV8nU+VPlwEjng3f6bL5qVrOF7ODfp3eSFbFEBZpIsqRBdYwcysFjn/kNUtJy3OkBURRxXZn9oRvzbjX/vfJuflP39/oAUiwSHvgIoUKxDCrS/wLC1HmZ1zGIsJNWHtHN7lNtcsibOxFuFD63eJXbCK3vz+1hEKBBrWwXQYAKbOX3MZw61kJWSsN3PNPqE3QddvBdpNUUlJBmBisBQr4ebDw7hsuL5qVaIjySW9LkUj5lOp+ZxMoSNGKgbnHxOQwEcaBS5fKpqyALxpv68IyubxD65ssrC0JXqeVFsaTQN3ob92hZXhHhx69JkH0qSNvb/30TqwwlQDRMy3l+txM3L
 uhZtDgij
 4KYX7i515MRXDLHvgfsdbli9IFzDaVICo574LpAVwF/0UtbcqYiv7Thz0js5legpU2a21qSkB0tk8dQrTjVm0SDdKskTd6MInzGUfOlDQowZc9UJwQcoR11fwLrAU8oUtPsbwHwuYoKoa0lYk0F9m9QeF2gDsR1k+9iHQwzJ3QXeJm1JBZFKF/9eo5F8URBvYjr+CeqbsEMF2RwVVqnxKQTfEPWcrrtC+ZoU7RV14rMTHT3bllfEvBLk+R0vEkV7brEoUOhAudSdM83gCixwGp82/oHZUwp8/Vq1o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 3:13=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Tue, Aug 26, 2025 at 03:02:13PM +0000, Pasha Tatashin wrote:
> > I'm trying to understand the drawbacks of the PID-based approach.
> > Could you elaborate on why passing a PID in the RESTORE_FD ioctl is
> > not a good idea?
>
> It will be a major invasive change all over the place in the kernel
> to change things that assume current to do something else. We should
> try to avoid this.
>
> > In this flow, the client isn't providing an arbitrary PID; the trusted
> > luod agent is providing the PID of a process it has an active
> > connection with.
>
> PIDs are wobbly thing, you can never really trust them unless they are
> in a pidfd.

Makes, sense, using a PID by value is fragile due to reuse. Luod would
acquire a pidfd for the client process from its socket connection and
pass that pidfd to the kernel in the RESTORE_FD ioctl. The kernel
would then be operating on a stable, secure handle to the target
process.

> > The idea was to let luod handle the session/security story, and the
> > kernel handle the core preservation mechanism. Adding sessions to the
> > kernel, delegates the management and part of the security model into
> > the kernel. I am not sure if it is necessary, what can be cleanly
> > managed in userspace should stay in userspace.
>
> session fds were an update imagined to allow the kernel to partition
> things the session FD it self could be shared with other processes.

I understand the model you're proposing: luod acts as a factory,
issuing session FDs that are then passed to clients, allowing them to
perform restore operations within their own context. While we can
certainly extend the design to support that, I am still trying to
determine if it's strictly necessary, especially if the same outcome
(correct resource attribution) can be achieved with less kernel
complexity. My primary concern is that functionality that can be
cleanly managed in userspace should remain there.

> I think in the calls the idea was it was reasonable to start without
> sessions fds at all, but in this case we shouldn't be mucking with
> pids or current.

The existing interface, with the addition of passing a pidfd, provides
the necessary flexibility without being invasive. The change would be
localized to the new code that performs the FD retrieval and wouldn't
involve spoofing current or making widespread changes.
For example, to handle cgroup charging for a memfd, the flow inside
memfd_luo_retrieve() would look something like this:

task =3D get_pid_task(target_pid, PIDTYPE_PID);
mm =3D get_task_mm(task);
    // ...
    folio =3D kho_restore_folio(phys);
    // Charge to the target mm, not 'current->mm'
    mem_cgroup_charge(folio, mm, ...);
mmput(mm);
put_task_struct(task);

This approach seems quite contained, and does not modify the existing
interfaces. It avoids the need for the kernel to manage the entire
session state and its associated security model.

Pasha

