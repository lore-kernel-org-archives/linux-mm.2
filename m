Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECD85CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 17:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6EB8E0007; Wed, 24 Sep 2025 13:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AEB68E0001; Wed, 24 Sep 2025 13:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB078E0007; Wed, 24 Sep 2025 13:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2348E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:18:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9DDDE13BDE6
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:18:36 +0000 (UTC)
X-FDA: 83924803032.26.D3DF7F4
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id ABBD580013
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:18:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=inMi+pGx;
	spf=pass (imf30.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758734314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlK30MjUC9fiNGfLRxzMUUUgYUbF4BmxAwJAcTHgmLg=;
	b=GsIpYDPpAEo7axQ/WbOvBcj1mWC9p3RXBag9pzRk5BFzqeuRz3BSRJKKlI0guij7wrJiJR
	jtDlbfobmBcWzIj32CenWZXZROZVD6KOKF0cXmZLyvcoEkh7XSJLsgJIz5JH2Z+nEvXOJO
	gBcz1dTQARkD76c8uuTP8AQndXaTvzQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=inMi+pGx;
	spf=pass (imf30.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758734314; a=rsa-sha256;
	cv=none;
	b=11l3UTMIworyMDk0y3ctU4KwIRPAbdm4lvxGvBmRmoO0atN2nyFX5bOEs5hMv5Wa1dSorO
	k0pG2DXmlnyfr/4t21YBfPbV8WRwieBeKt+U/ipMflhx+86fu2NHekfsPLNS7rX3aSoqel
	7HnxW76O0QWGZmbS4HahyPszmriBUVo=
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-54bd3158f7bso102607e0c.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758734314; x=1759339114; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hlK30MjUC9fiNGfLRxzMUUUgYUbF4BmxAwJAcTHgmLg=;
        b=inMi+pGxQWIiMe6cf1j/J9GRBq7DFbimTtMqwQtnv3Jeqni+ac/F9jiq2sY0fhqYXx
         kG430HL2Zq89QzsK7+Q6vNNtk2Mck0kZN0EicJPNZD7VpBhkWf9CO2wNZCkSeVuIzSBI
         XBJOMomci9AMkkYBdaxohZzXvb3xDiUrR7uAXLItgzINj7JKofsKAGddiHg1e7fZ0SeD
         4aUs9xUqnXUlwbf1CFaD3/ePe3HSv8iq2MWrKvn7bICMgvv8xpZwBnHCLGCGj1yX/j7a
         oY8mOBIsVJ7ycrMJ58MkGGBg5XkaeM1jNFRIkPa00C7uoxHCzxgJQ6vMvUHtfhkwHjjH
         KwVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758734314; x=1759339114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hlK30MjUC9fiNGfLRxzMUUUgYUbF4BmxAwJAcTHgmLg=;
        b=FKAO0cVHIyavvK7UU9vwOC/WOuwsrpJADzuLKbmHafGCX8PS859O8yXs+k5RRoyLc6
         7uCcIMbuzAp9hPDI+YH7y+t+mzwTXzm5/xRcpf+v+Lv5P2yFJ3EhxcMVnEKj49YSCoHm
         Wt2ZjSIm2ggy0IGXwWPHjBUcJNiD/PmzoZV926RORLjcIaIIRMfG0fQ7BZlUzQ0R1H/F
         NVXXvkjpFRJGoq5kFQ7b4NGq4oYTYUo/SvfBVCnwHdMRsY0Ncy1UsSVV+2OE3I75Ezvp
         gJ8g6toQ3YqU0ymx0EbaPmaaB+NP9Ox3nVeVg6YCU1wQU7QyFcw3cGoOPC73OPzGHWpE
         /o8g==
X-Forwarded-Encrypted: i=1; AJvYcCX2Yzi35gnteLEaxi3LBUzE4nSO/lMfwQo4xdIXTEYdG6bD6X1InJR3GeeDL/dJIyHWOVehQabKnw==@kvack.org
X-Gm-Message-State: AOJu0YzUL53Srm9hlDg3OFhajCUyeVeCB8KxqqwX0Jasvt0B9T1xcW4L
	ZHfI7jYN2dZDA2KtICaQAlcTjnVsCjO8K0R8dydSbLU9o+tKzOGa0d5Wr4PvbiRz20qy7vyIUAm
	/pgzVxQ2YmXPxP/vynVIbDiP0+HE3x0g=
X-Gm-Gg: ASbGnctyoxkBDD6mNZIqh15EejG5D/ydDXo+IkiJ1xj5mbaaH13gz7At4PyPxFw/uL+
	Mw1T5C+uFLlrN7Oi2XeCml3cToutp1lUEhSb9kuOynbngZeVEksGotvt9UQNcKSSLNe46Ma26To
	se2cWnY/thl6+Juh+i0v5/8Dld8PnVfECUyp4PDbmZeiYb+xGD5AbHDKGSPTqavapO02sm/1eba
	sf9Q15lNWTa8YmlrNAz6pGOtxxj+XPIS5Pdetk=
X-Google-Smtp-Source: AGHT+IFNudWYdRYohdYWRakfqW3sTemN0SWD3jGIkvD9SRgmpWDEPo14DUBWOj+taHvy6lJzsWWaGnYJeYCvB7r8Igc=
X-Received: by 2002:a05:6122:3c82:b0:54a:9fe8:171e with SMTP id
 71dfb90a1353d-54bea23effamr355653e0c.7.1758734313522; Wed, 24 Sep 2025
 10:18:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <20250919212650.GA275426@fedora> <CAM_iQpXnHr7WC6VN3WB-+=CZGF5pyfo9y9D4MCc_Wwgp29hBrw@mail.gmail.com>
 <20250922142831.GA351870@fedora> <CAM_iQpWO71vSV_0qXiUYeKYZMYF0xWNz8MrUVRkqKwDEtQvKqA@mail.gmail.com>
 <20250923170545.GA509965@fedora>
In-Reply-To: <20250923170545.GA509965@fedora>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 24 Sep 2025 10:18:22 -0700
X-Gm-Features: AS18NWCWLBluj_2WnA7xQt94H_1gC4pE8CBvpOcHrfIASayaDPo8l1l16vPe2Bw
Message-ID: <CAM_iQpWe50B4hfVTd-xTemByvoM_bg7eA9y8qwZjBsYcAbY9fA@mail.gmail.com>
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com, 
	Cong Wang <cwang@multikernel.io>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	multikernel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wh3657pft1cb4fzo7ghfn94ek6a3i9qo
X-Rspam-User: 
X-Rspamd-Queue-Id: ABBD580013
X-Rspamd-Server: rspam04
X-HE-Tag: 1758734314-622395
X-HE-Meta: U2FsdGVkX19zcs5jz8vWr1EyShbb0TrM51Q6S/KcjiZHFMjFIQSRBzWUkJv5CbqiSnMiLPG9+hvmRVKEk/UmeuQYbdNlLGPce9hEh+b6fhT2qehdgFiEm0PDZN7qKXf7oz722OOKUlqFrOBFFf1X7EMT9pdWL1cocceD63mtkdrsEESH5qcV0Mty0FFJUGmN7kaEdwyEVhY0NvioOk7WFunHUUO6WmE6VXX0ABoidAg4uPEqC4m9Wa+sG+0ZdjreRTTJDbpGziw/eS/5qRL4zOxpM+BDCCicn7OmzDZRUyCCXMEoo1o+SqCHYRtenU6X/IwQWBiov6qL6P7l4DjimgM3/h2eHpTfqBzRYhQizIW+9HPIrtiXSDpLZDQwIXtNuSvr3/DxXPtFCGAvchd8lAG9LfGf056AxohRR3UcBSpWN73tAVfzm4AOXWYZOyuRH2Pt+80jpWje2u6kxdlTpFEPiyqLFMwJolpAeip8zjca73rrKOut6tCneOy4xrIRzG9HQSMZE/TfbGj8UJlWgF8OjX6uQBQUSnvJqjjaXfSoaXkq1caURtmXSOrfUTY4O69QLZerT8RCiy1L7Vxq1RdhWzHV/CkypfvpUhoJNH+zQnkQ5pzA9FiwKmxVhdUHF4yStbsIhi3LNDbGMMeJrPMSiHTw77LXBWCUTd9eTtQ5UPYGsKZSXIblx1zHvWYW9eaSqMpnw2LQirARkpiniThhDEdg2vG+AoaKiwmS8PzbhQRpDiwJUv9n6on7T+ZROfs30KIva1nB7LZmTHPctdQ5wDs6IpmiV39xpS4t0TEFgsdUEYySCZIO5GOt7DfuMV26dn1MCdizqXE8uv4MyV6C+O4uUhZXZdMpeKERCyhM3e303Js9FoQKasnsl0F1763/FDHBwNpFQan1tnzmu/5FvKhoO6Bp8tSCz+Xi6Ylw0jl/gi1ZYn9Ohq1L0pLgJ/76YSZSbFB6jGP8g+D
 fzL2wvV2
 k8MyEpQ2ArKHCJEepXtTzYpJj5y+8sk8WRl65jL2iP5B1qD55mEoPnR0enhvEu893PDFIWhTvCNSfCvTzyx1vFNudn94JD+/P3ygcguO/EL3ZTBesdZ2mWHOw9vBtuVahf5eECZRH2k8xS438PfOtp7cgiy/UagEa1T8WCILwBQfsvCpBEX3n6I6TKTg0b6JHSm76Lsx91JAipq2f7kjDJR+GfQ3VoxnWgh8enNFlr42Ma0zCs+Dh8vgHV4OHe9fj7xyrvhQU2wl0gfWOEq8tCb6XS+bTRo+0+9TJMxFirxnyqb7S4Obinsdb8KH0QlQ7BVBu4mheU+++ruJYdyhnGQJnITVtymQ7JVBiNrrdcgabZJFQ7ldGn3KSCLQ+1VcZyn+RUbN8pe15/m84CHOdHGN23VzlhWiA6LwN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 10:05=E2=80=AFAM Stefan Hajnoczi <stefanha@redhat.c=
om> wrote:
>
> On Mon, Sep 22, 2025 at 03:41:18PM -0700, Cong Wang wrote:
> > On Mon, Sep 22, 2025 at 7:28=E2=80=AFAM Stefan Hajnoczi <stefanha@redha=
t.com> wrote:
> > >
> > > On Sat, Sep 20, 2025 at 02:40:18PM -0700, Cong Wang wrote:
> > > > On Fri, Sep 19, 2025 at 2:27=E2=80=AFPM Stefan Hajnoczi <stefanha@r=
edhat.com> wrote:
> > > > >
> > > > > On Thu, Sep 18, 2025 at 03:25:59PM -0700, Cong Wang wrote:
> > > > > > This patch series introduces multikernel architecture support, =
enabling
> > > > > > multiple independent kernel instances to coexist and communicat=
e on a
> > > > > > single physical machine. Each kernel instance can run on dedica=
ted CPU
> > > > > > cores while sharing the underlying hardware resources.
> > > > > >
> > > > > > The multikernel architecture provides several key benefits:
> > > > > > - Improved fault isolation between different workloads
> > > > > > - Enhanced security through kernel-level separation
> > > > >
> > > > > What level of isolation does this patch series provide? What stop=
s
> > > > > kernel A from accessing kernel B's memory pages, sending interrup=
ts to
> > > > > its CPUs, etc?
> > > >
> > > > It is kernel-enforced isolation, therefore, the trust model here is=
 still
> > > > based on kernel. Hence, a malicious kernel would be able to disrupt=
,
> > > > as you described. With memory encryption and IPI filtering, I think
> > > > that is solvable.
> > >
> > > I think solving this is key to the architecture, at least if fault
> > > isolation and security are goals. A cooperative architecture where
> > > nothing prevents kernels from interfering with each other simply does=
n't
> > > offer fault isolation or security.
> >
> > Kernel and kernel modules can be signed today, kexec also supports
> > kernel signing via kexec_file_load(). It migrates at least untrusted
> > kernels, although kernels can be still exploited via 0-day.
>
> Kernel signing also doesn't protect against bugs in one kernel
> interfering with another kernel.

This is also true, this is why memory encryption and authentication
could help. Hardware vendors can catch up with software, which
is how virtualization evolved (e.g. VPDA didn't exist when KVM was
invented).

>
> > >
> > > On CPU architectures that offer additional privilege modes it may be
> > > possible to run a supervisor on every CPU to restrict access to
> > > resources in the spawned kernel. Kernels would need to be modified to
> > > call into the supervisor instead of accessing certain resources
> > > directly.
> > >
> > > IOMMU and interrupt remapping control would need to be performed by t=
he
> > > supervisor to prevent spawned kernels from affecting each other.
> >
> > That's right, security vs performance. A lot of times we have to balanc=
e
> > between these two. This is why Kata Container today runs a container
> > inside a VM.
> >
> > This largely depends on what users could compromise, there is no single
> > right answer here.
> >
> > For example, in a fully-controlled private cloud, security exploits are
> > probably not even a concern. Sacrificing performance for a non-concern
> > is not reasonable.
> >
> > >
> > > This seems to be the price of fault isolation and security. It ends u=
p
> > > looking similar to a hypervisor, but maybe it wouldn't need to use
> > > virtualization extensions, depending on the capabilities of the CPU
> > > architecture.
> >
> > Two more points:
> >
> > 1) Security lockdown. Security lockdown transforms multikernel from
> > "0-day means total compromise" to "0-day means single workload
> > compromise with rapid recovery." This is still a significant improvemen=
t
> > over containers where a single kernel 0-day compromises everything
> > simultaneously.
>
> I don't follow. My understanding is that multikernel currently does not
> prevent spawned kernels from affecting each other, so a kernel 0-day in
> multikernel still compromises everything?

Linux kernel lockdown does reduce the blast radius of a 0-day exploit,
but it doesn=E2=80=99t eliminate it. I hope this is clearer.

>
> >
> > 2) Rapid kernel updates: A more practical way to eliminate 0-day
> > exploits is to update kernel more frequently, today the major blocker
> > is the downtime required by kernel reboot, which is what multikernel
> > aims to resolve.
>
> If kernel upgrades are the main use case for multikernel, then I guess
> isolation is not necessary. Two kernels would only run side-by-side for
> a limited period of time and they would have access to the same
> workloads.

Zero-downtime upgrade is probably the last we could achieve
with multikernel, as a true zero-downtime requires significant effort
on kernel-to-kernel coordination, so we would essentially need to
establish a protocol (via KHO, I hope) here.

On the other hand, isolation is relatively easy and more useful.
I understand you don't like kernel isolation, however, we need to
recognize the success of containers today, regardless we like it or
not.

By the way, although just a theory, I hope multikernel does not
prevent users using virtualization inside, as VM does not prevent
running containers inside. The choice should always be on users'
side, not ours.

I hope this helps.

Regards,
Cong Wang

