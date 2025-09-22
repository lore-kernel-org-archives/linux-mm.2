Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B3C3CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 22:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18F68E000A; Mon, 22 Sep 2025 18:41:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC97D8E0001; Mon, 22 Sep 2025 18:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8978E000A; Mon, 22 Sep 2025 18:41:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B3DAB8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 18:41:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5593C1DCE2F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 22:41:33 +0000 (UTC)
X-FDA: 83918359266.15.63940AB
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id 75266120003
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 22:41:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YIcqmh6a;
	spf=pass (imf29.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758580891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yh6sVdAT113ztDhuPxo1MqnAkuhIHDy1HJdIr+aZPU=;
	b=mQD1csYcTXY8gPflXDujxhN8DsTNav1nafoemJ7T9kzyz0ufrcH4h53NBxswti36PxYYWS
	zjC1bKU2wm+PP/qyvcVzM4nsptOdUucfD6qOjJTe16Te5yHcu1Iwq0Wu9ey55QiMAMv+tt
	i7Ygy9njrSvuwwDbNtopnP4gM/TLAf4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758580891; a=rsa-sha256;
	cv=none;
	b=2UgpUE1RXKrvalTagY8tJ/IKmBCotuFyX1iBlX0mQ8iGaoyc6HAI5IE/MJfTaonE8w4hrq
	RLLkN1pFjxmb6tOqvVSaVbmPtDz/Wk6ITGBIgVHXbix2QyhpDhs/S2UTF3xb41BkSJ8Ib0
	tekQmWXSL1P5CB3bTRwoDu/3328fPeY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YIcqmh6a;
	spf=pass (imf29.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-5a0d17db499so1221964137.3
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 15:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758580890; x=1759185690; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0yh6sVdAT113ztDhuPxo1MqnAkuhIHDy1HJdIr+aZPU=;
        b=YIcqmh6aJIiE75VZSXG6KrJrgcN6+GDg4HaP0XVnOLrLNZRIAtEaBQCMLfOXh9T/z6
         ObYD6cdJVRswVWgc4kZIBgCd7xlO6XjF1TM+ICPQWWR+y/lLGzGe3akR4bDkrHBltTu6
         JuAkWL8vT9JjSO0OMkEfIerjeM/6tWttlHu8CVCEn66CxkrtTv3xutxoUnWrReUAQwJn
         Vi20mSdsBLTlAUXAuh5IB6bJLO4rv/aEaj+rgx89dyqO/+Kohl4rccFHhsJx+lDl6RCz
         94YQ6c1Nej5k4zGdDRg1g0AwA6pZeoK+AVyxUYrCSbouTq0/tcaPDXUZFbewtXsZ2ppy
         ADyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758580890; x=1759185690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0yh6sVdAT113ztDhuPxo1MqnAkuhIHDy1HJdIr+aZPU=;
        b=elhg5AreiI5g5nHSR8CgHco0GFOMfKEFYkFWxOpaZ1FSbo7M2A4KkjhVoIdeLZ1Mb7
         UJyh8q2ER64ANuZnh/B116Wo2a8XsMsbTlqiXtnBNpNyM8DSqiNKxEZNqYnknd+CObsz
         TgAB+trW4d4iGhRUzDxDfNWfOisZnKKOdJYmMj1lkFwfEIKAjYkohJmvG7MxV8FVlM6D
         n/ve42aobM7WKif8JP1pb2fHkkIkOPuiNH6edPkZGF+u+R+BhXFK0nonUShvZeHkZZqh
         IsWlcFwyfprB7Qz/SmmWOxM7B78Y4nyHRpSyJV7+odDwqfE6SxGPd3IFZZqwQV0M7kFf
         dOgw==
X-Forwarded-Encrypted: i=1; AJvYcCV/+8ihBIRZZtJrvdBvb+t07QCKo/GaGFp7aNBX7+H4DgsHnTqR9NO+75Y8dkWyNxdbXW4bXagpjg==@kvack.org
X-Gm-Message-State: AOJu0YzfpaW/8s5N5q3bMbyP6alZ6zPXciTEkYjx89qAGnj7YVXGSlLG
	XdS/ja410+nFrJTnZG1w/B4vcTzcAXggS5IBXEFOpKaAsXF4llHRmvhSmh0jETI+4SVxmM94SlD
	JlYv+mZXbYp7kS3NZSPG9eEAmM81eYQw=
X-Gm-Gg: ASbGncvGW4Mlo6fSDFDzRXxStw+oIy3XhlgWvkj3ldgOs6brGkww6RTJMP/8hBzIA4+
	ojMN+h+a3zoPPWUlcbCQL1t6ifbNBtENvT/y0Na3YQDW4yepf97Zy9cH0ysk9IwQjAW8rXNvzRg
	t8+5DBhaOHnQsH2hmPEPBswErV+pT5tv22/fp/+HKFOSw6YPXQt4WTGaca6r3VJars3r8MofHTN
	XdLnRTVKdwAhNiSzh9/qD8y5WhOb+cEtJdqUe4=
X-Google-Smtp-Source: AGHT+IHFB6pkceMUZ77NeXmuYnJm1V8ontKaUDy90T/NYBaMVOfoW99El5NLWv56d5b2UvDdU+jygkw5mvczc9Xzk18=
X-Received: by 2002:a05:6102:4492:b0:4c3:6393:83f4 with SMTP id
 ada2fe7eead31-5a57d8d7f2bmr255887137.2.1758580890508; Mon, 22 Sep 2025
 15:41:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <20250919212650.GA275426@fedora> <CAM_iQpXnHr7WC6VN3WB-+=CZGF5pyfo9y9D4MCc_Wwgp29hBrw@mail.gmail.com>
 <20250922142831.GA351870@fedora>
In-Reply-To: <20250922142831.GA351870@fedora>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Mon, 22 Sep 2025 15:41:18 -0700
X-Gm-Features: AS18NWB9iArZm8gNoiOyRm5CUi70i_coc1Ea1AEenDW54lVyHBPMys3KfUjFGeg
Message-ID: <CAM_iQpWO71vSV_0qXiUYeKYZMYF0xWNz8MrUVRkqKwDEtQvKqA@mail.gmail.com>
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com, 
	Cong Wang <cwang@multikernel.io>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	multikernel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zd1t9j9sgbhs733yd9kynigif38oq983
X-Rspamd-Queue-Id: 75266120003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758580891-711156
X-HE-Meta: U2FsdGVkX1+652JUcAYKtR6kW5UkOruuu/f/R0f3IxeIwFheVv4nOj2VHFVoxKeqn2hK/ohs9Id5q5Owy91lYmLGObro7MVLrcYNVrWHPlzsep9pr72gzDKOBVuA6tYNJPbF/novhAaqaHIE6N4FwDEmLhdDGGupK6LQPfNSm/eUIfdvAHcGbXgh4QTEAzlndOj4M8Iev7PGg+ID1fR/2p6vqUriVxrpxjAdAzqUeqiiOiChQWI8JKP8WG3XiUGno6zMgQAgOswsSnkWzyeJMqoJ73f1GFavys+4idZpH6oTW6xoWWpXRxhH4Qd2CayROP2c1SzxVr72lyMbSTXzjoLWayNS8XvbRIWL4yOSDDRJRIbGF7XMtGbYp1C0c/GxfmkEODnCcfSitWhwrrdEGIbXtbvH4gDbPpv3zMMZfZXqTlbbSFJ8RA2QD+dJpe3QNZOSwSeF1W02QzURzXWMcrEnPpl0MyOFcXpB845I3JJQa9Ql8XZe/uTB/lVGKuSQ8ygzQv8mF+W0OljCbvd92yiNkPKeOTG3oEu142q5Oltl+atGpcTMIcMEaVPXcbgA7R/+PfSHe4CAVOTdfQeK5uoNdfAreqm5CpKxmwQeXvq1KMuVbYOljHlt4qUzbCaKHEb1Zl90z8kt5xY0uH67vZtigKX6S+ZazrWUlqEyDZd6M7C6vRSy8IWbs7Q1wIwtlI+S0b46DqounjY13J9+rIngCe6Nrt9akQh+4uJEopRNcsOd729PaiKFW7kS3fzC9REDsrYE94J3cZOPw98b192Yazq5M2Y3AM0mxJpbIP62busFwGOflBFPPWrKwNf8jHQ6IzfYXg/hMxWZfaL/6wvJLkOkodRlluX8uN3qVgDi3t7z/KmScUITV6XoevwikgQQtZepnuFCn0zkcNLM/XYAgyQDiRZuUIuC1YHPNcBDkNtQYb2HwRh0burQkckWiNlwWxd34HM5GTaVsk1
 XPwi4svt
 YJ3g65JuMbPGUJhvJkF3gX+6TNzGLwf/pFMDfc2+CyL2ilolSZ5i8ThTrfhuBa+EDOj4u5lajzWPeaXRpJMFgpodqdAnS895u1iN2OY51kVZVAhJNzGXAnDiQYh5prIHIrc1439c9hU9I3LUeI4z4fzDYdH70JN4i9xz+4rv2z5ri1zTcKmEkARpmViZUHPOOuSi4OKpfrTKZABBFAU7BCopYtOKC1ruR+oyLTfRm412IEeiUcmCgwdoPLWJ5GjER2D/6oFzbybOkxldr0Z/f3n6I0Q9O7HQDmY051oCLGMxS2w9yV2jzbwt6U2+vxRnXPFJ3QjOxFcgci1oPf2nTWeFvVoOVMu9z08jIqVmvNtHmyoXhf/iAdjL0RwkVGV1xCt7kzJl7SC0tpTNRvcbxFnUVytO+9VRunTs0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 7:28=E2=80=AFAM Stefan Hajnoczi <stefanha@redhat.co=
m> wrote:
>
> On Sat, Sep 20, 2025 at 02:40:18PM -0700, Cong Wang wrote:
> > On Fri, Sep 19, 2025 at 2:27=E2=80=AFPM Stefan Hajnoczi <stefanha@redha=
t.com> wrote:
> > >
> > > On Thu, Sep 18, 2025 at 03:25:59PM -0700, Cong Wang wrote:
> > > > This patch series introduces multikernel architecture support, enab=
ling
> > > > multiple independent kernel instances to coexist and communicate on=
 a
> > > > single physical machine. Each kernel instance can run on dedicated =
CPU
> > > > cores while sharing the underlying hardware resources.
> > > >
> > > > The multikernel architecture provides several key benefits:
> > > > - Improved fault isolation between different workloads
> > > > - Enhanced security through kernel-level separation
> > >
> > > What level of isolation does this patch series provide? What stops
> > > kernel A from accessing kernel B's memory pages, sending interrupts t=
o
> > > its CPUs, etc?
> >
> > It is kernel-enforced isolation, therefore, the trust model here is sti=
ll
> > based on kernel. Hence, a malicious kernel would be able to disrupt,
> > as you described. With memory encryption and IPI filtering, I think
> > that is solvable.
>
> I think solving this is key to the architecture, at least if fault
> isolation and security are goals. A cooperative architecture where
> nothing prevents kernels from interfering with each other simply doesn't
> offer fault isolation or security.

Kernel and kernel modules can be signed today, kexec also supports
kernel signing via kexec_file_load(). It migrates at least untrusted
kernels, although kernels can be still exploited via 0-day.

>
> On CPU architectures that offer additional privilege modes it may be
> possible to run a supervisor on every CPU to restrict access to
> resources in the spawned kernel. Kernels would need to be modified to
> call into the supervisor instead of accessing certain resources
> directly.
>
> IOMMU and interrupt remapping control would need to be performed by the
> supervisor to prevent spawned kernels from affecting each other.

That's right, security vs performance. A lot of times we have to balance
between these two. This is why Kata Container today runs a container
inside a VM.

This largely depends on what users could compromise, there is no single
right answer here.

For example, in a fully-controlled private cloud, security exploits are
probably not even a concern. Sacrificing performance for a non-concern
is not reasonable.

>
> This seems to be the price of fault isolation and security. It ends up
> looking similar to a hypervisor, but maybe it wouldn't need to use
> virtualization extensions, depending on the capabilities of the CPU
> architecture.

Two more points:

1) Security lockdown. Security lockdown transforms multikernel from
"0-day means total compromise" to "0-day means single workload
compromise with rapid recovery." This is still a significant improvement
over containers where a single kernel 0-day compromises everything
simultaneously.

2) Rapid kernel updates: A more practical way to eliminate 0-day
exploits is to update kernel more frequently, today the major blocker
is the downtime required by kernel reboot, which is what multikernel
aims to resolve.

I hope this helps.

Regards,
Cong Wang

