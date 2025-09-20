Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D10ECAC5A7
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 21:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D30E8E0002; Sat, 20 Sep 2025 17:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484298E0001; Sat, 20 Sep 2025 17:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 399A78E0002; Sat, 20 Sep 2025 17:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 29F908E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 17:14:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8ADF5838C8
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 21:14:01 +0000 (UTC)
X-FDA: 83910881082.02.1991498
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id AA45D1C0006
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 21:13:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TY10GoyI;
	spf=pass (imf18.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758402839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4UIugca8SZaxMzP/24yjEddM7n8Al4cXmz5gSsZCJUE=;
	b=t2j01hub5ypApdFq1FqwcCwxwRzA25TnM81DVXatJKUGVdYj8Cz7Nv2pV/+5C/urD2/+PQ
	3g+55cssMDzhYtJwMjabhfdYfUCm+AOC4NvztN0kgPKQUyCc3IDV0NysU3sJjseHt38jRq
	Fz2lJfRxAbhNIb1C1WGfhYL2bUzey3s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TY10GoyI;
	spf=pass (imf18.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758402839; a=rsa-sha256;
	cv=none;
	b=DxIMRcc8AjiiWIF+Ic0onsUvmmlUnT9MY3xcoKLv0BmbDTUjOT8LjP3HssQ4Uvy88zyfZN
	21+4WDcyaUBxE3INDvB3y2yIm+8ecs7rJllVqY1CksWQx8rm55oPlpH03bL+NKBS0D07Ev
	HHHUF34gKOdKyf/99yS8R3Vp/KgNxtw=
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-8e352f6c277so789165241.2
        for <linux-mm@kvack.org>; Sat, 20 Sep 2025 14:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758402839; x=1759007639; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4UIugca8SZaxMzP/24yjEddM7n8Al4cXmz5gSsZCJUE=;
        b=TY10GoyIoCaIneeBB5OdRb1btibZrc4sqELqsYjC5D8Leq4RQ+BoPlrJxkZwtwjMqd
         EyY0gsb2cPFjEYYQWZP2JU23ercGY0lso7SVPEB3aJrFlbp6rW6Xh3UkYPme46AISg1T
         KsVOiY1MnZaaqtAnOvFyyzkpYMc61tDttGY8j8tSnu3X1+r6q+Y/6BtCfRjPIKaPsNAo
         xNjSqma2fCCOO3TQ++lU9TuZOYVkbIfQ3NzCveAXN63vzYIfWjIrTsrGyBp2h4ueg3pv
         i8nZgRN96TDwniYTVlQqYJv4eZQLzDiEEDREZRO5Iyqhc67KPQp84rlgCsbUonrFZfkQ
         se4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758402839; x=1759007639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4UIugca8SZaxMzP/24yjEddM7n8Al4cXmz5gSsZCJUE=;
        b=b88o+ewLdBnHtCO3He8E59OFJe6LialebF2wHUFlbG5xSBeHWx16l94R1d8gkVlaKb
         kmHkCoZtUdP1rAQDAUdwXihkjcF8CrRaV7uSdWUfsr6MB2VxM7FWeTCltCGG1IQ97OtD
         DRBxr4uTOk79oFeBBdvrcGjuQ0+sV6cOuHVfNOqwv121KQTrMczb+7BwNKjJUA5txrmD
         3WAc+aRAt1eH2ROdTfrSJ/8VO+437ZDVoaoqYYzHaRRZYDPzfCz9zVfUksX5R5q/EP84
         6fvaRT77/sCakK0BNMBcalQ8DhhRrmT8oEclzru/+rbTp96jtPfLPw/tNOG5ILA9Bfr/
         RQoA==
X-Forwarded-Encrypted: i=1; AJvYcCUK6cCA2FlDD7dupdwzgN6SD/P+zhs7d48jvs5DqyrD7Sqayd3V75BdKjt+YiiH9SYKZHmg8o+inA==@kvack.org
X-Gm-Message-State: AOJu0YzJKCf13CigHQjpqff62NFoaCCSD6YYN3Bx0f+x3gY9gY+e8tBI
	WIdoSs+j2VLu/ByLJsL6ziEE0HrEog23NaVx4YrzpepNkokvtX7fyZKNs+PRaK4HmK+juORLFTu
	InFxTQH4D/O5XHN9qa/eN0CooL34yung=
X-Gm-Gg: ASbGncuOjG8dhBTY8qSu0eIvkmCPqiG2Xe6pziCq3HITe5ixdXrXIsOsPJUFa4C7t5q
	afXaN/v6asC1iu64SfTX5bH39KuTyDlKaFvfg4JMeNHfwFsfbRiZxFAmgnVYFs7wXeugl2YHILZ
	yQKCx6hUdyeR/x+l3EIiWgalXsg9/rPN1Dm35zZ9Xks96khfEKJCHHec++I66t1l5uRBuJGOZX/
	cfRO5TvnGDX1PO5BcSH/RdjcmUKuIxwC5qFQ/s=
X-Google-Smtp-Source: AGHT+IFvnPA4h7T1ZUVtn4JDNMPpiPFDn9Yh1yg75Ylw2qMBHo9vNQ/p0Qj34UE2hbDoZxw+1L238MnfW2TU2rGaUKs=
X-Received: by 2002:a05:6102:3e06:b0:55d:34c:f231 with SMTP id
 ada2fe7eead31-588f9cfbf36mr2475265137.35.1758402838660; Sat, 20 Sep 2025
 14:13:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com> <CA+CK2bD3D_XFu1E60qBYwdDzK0c7_bN0BkGBE7h6h_sxmmfvAQ@mail.gmail.com>
In-Reply-To: <CA+CK2bD3D_XFu1E60qBYwdDzK0c7_bN0BkGBE7h6h_sxmmfvAQ@mail.gmail.com>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sat, 20 Sep 2025 14:13:46 -0700
X-Gm-Features: AS18NWC0ac3RYhgSaViFSOyGBJe0fdwa4OEZ_zquyfPSWFlJlyPiOoaLI9mEwmY
Message-ID: <CAM_iQpWmfkB9VPdV=sCcFzUm71my1bWFL7G+QLtYGHpe3oPHAg@mail.gmail.com>
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <cwang@multikernel.io>, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Changyuan Lyu <changyuanl@google.com>, 
	kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AA45D1C0006
X-Stat-Signature: aidjcxkct1sqqkg3ftyxi9zgyfzhfpof
X-HE-Tag: 1758402839-150198
X-HE-Meta: U2FsdGVkX18mlsmKt864YEfNlDzcjZi/APgVRA7ThSIkbnkcc8CRst2jIFRz93ix2iXRdWFkN8gjXLvV2qBrWaQIHlsHijj8mBV2EyzovSLYCNwysYWbGk2CIYPoK7PV8hpfIF5M1KI4YDzCDx4uqkWo1C648M1GuEfw42H27y0WOZYHhJj3HGVY1XqPLZ4PSqGZBSFcAZYzGGx4ie+7vKGTRw6sCtpcWc3kHQ3n7d6enBTXNUEof8+u387iKrHFtDf0HoeRrjCSsaAVyzfEKZCz6xhFKvIhDo8bfCqzeSmSM+BkTjMmj+xU+WSFhBQ/R1Wp//N7xA58pu4bk8l9SItD/kR7s2HRpLDirgXGtfXd0CBV8KaR8J0OTBo33qE7C5ohtUwOOlfx1JOVTYBc0LR4FlH0/TqojEfAQFUhg+GbG/LHtoxCB1JgXksGYDsB9qPzSEpPLVv/+yhrUW3QFiLP3pMYibmo2Ehwaj12DYy3BjMrzF+54YiohH0usGKzy61ZhcGDzcRK7A1xwjpn5YrS8JQYOEf+L6XvGPzQUVWXHE8cg6tciaqCU/U8P7iEzaWjQ4Z+fNPDo6doBpR2w0vc0tYWHgMrn2wZdZkgFwb8LKMV1lHfp9XiE3uoQa/4m+mceC1o/bkxtCe7HCG9eDxi7cRbVdKHY/k5W08M0G7hpeIA6jK7W8J37tKsBZE2WRA2Cqqhnj+nSIlajuPYEwY4YutGsbAV+j5j2U77Yry+r4sG+WqSwRW7gprJPAtYPqQNAltJkrAmRoMztNtf3T7dR1cxZZtBuxtAYM8pubdZeCfi+0D/aP/PicCvdRludmk1TSCwbA8nJvmR8/LCEqXENYHfZxnhEsZ4pWFxMWfdnKXjt72X/sYzmaZdn0XxJlWhucL42lIqkgaxHb+Zl3viUcFCEanxY3aLLKZUO9UokPaNVJvcH7/De7FopBRDbixaFLpjFybPgRp13Wv
 bPYT9CB5
 HU9zHejSYHeY3O4ys0wt5uffEGq5cD2A2tfm3xa4ZGA207BTQN+bh3ugtFYieM7Sm77p3aOq2i3YjKlVwI8USrz/8HvhfONpqylJ8oOJlrt4XDC0geJZGEDSxtoUvBVIFUnTCiCdA/wCASMN5R1b3bclnanYiFb6AS6YmHjdmSlcGamGyyV7QoN2tXZ8Nq5qKGRaZFgNiO9WHUlKgYyztGHQ4Efd96EBIUkWOavBi+q7GfVPScFAmnyPGKhGkPTNDnqULbMpOlN44PMr2S0Pfb9rgc44MDJj5p7uqZDq8elMJ2cFKj9koumIW3VmTQG4KKZ3p8zo4mfdDVWtJrnnIRcdk0JJjau9Xi2amYpZZClI9QRzjNz8dodIzbUFq30ksQFN8GNyahg9BJUVRJwGVamw63VsCz/SoG07RtUKcU+qE4YUDG3uFsQYazi9Hvzz5GAyz8elngcvSwwOxuk1YOUsVGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 6:14=E2=80=AFAM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Thu, Sep 18, 2025 at 6:26=E2=80=AFPM Cong Wang <xiyou.wangcong@gmail.c=
om> wrote:
> >
> > This patch series introduces multikernel architecture support, enabling
> > multiple independent kernel instances to coexist and communicate on a
> > single physical machine. Each kernel instance can run on dedicated CPU
> > cores while sharing the underlying hardware resources.
> >
> > The multikernel architecture provides several key benefits:
> > - Improved fault isolation between different workloads
> > - Enhanced security through kernel-level separation
> > - Better resource utilization than traditional VM (KVM, Xen etc.)
> > - Potential zero-down kernel update with KHO (Kernel Hand Over)
>
> Hi Cong,
>
> Thank you for submitting this; it is an exciting series.

Thanks for your feedback, Pasha.

>
> I experimented with this approach about five years ago for a Live
> Update scenario. It required surprisingly little work to get two OSes
> to boot simultaneously on the same x86 hardware. The procedure I

Yes, I totally agree.

> followed looked like this:
>
> 1. Create an immutable kernel image bundle: kernel + initramfs.
> 2. The first kernel is booted with memmap parameters, setting aside
> the first 1G for its own operation, the second 1G for the next kernel
> (reserved), and the rest as PMEM for the VMs.
> 3. In the first kernel, we offline one CPU and kexec the second kernel
> with parameters that specify to use only the offlined CPU as the boot
> CPU and to keep the other CPUs offline (i.e., smp_init does not start
> other CPUs). The memmap specify the first 1G reserved, and the 2nd 1G
> for its own operations, and the rest  is PMEM.
> 4. Passing the VMs worked by suspending them in the old kernel.
> 5. The other CPUs are onlined in the new kernel (thus killing the old ker=
nel).
> 6. The VMs are resumed in the new kernel.

Exactly.

>
> While this approach was easy to get to the experimental PoC, it has
> some fundamental problems that I am not sure can be solved in the long
> run, such as handling global machine states like interrupts. I think
> the Orphaned VM approach (i.e., keeping VCPUs running through the Live
> Update procedure) is more reliable and likely to succeed for
> zero-downtime kernel updates.

Indeed, migrating hardware resources gracefully is indeed challenging
for both VM or multikernel, especially when not interrupting the applicatio=
ns.
I am imagining that KHO could establish a kind of protocol between two
kernels to migrate resources. The device-tree-inspired abstraction looks
neat to me, it is pretty much like protobuf but in kernel-space.

Although I believe multikernel helps, there are still tons of details neede=
d
to consider. Therefore, I hope my proposal inspires people to think deeper
and discuss together, and hopefully come up with better ideas.

Thanks for sharing your thoughts.

