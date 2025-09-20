Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB0A0CAC5A5
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 21:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8A08E0003; Sat, 20 Sep 2025 17:40:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079C58E0001; Sat, 20 Sep 2025 17:40:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED11B8E0003; Sat, 20 Sep 2025 17:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE4B98E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 17:40:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 889A41188B1
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 21:40:32 +0000 (UTC)
X-FDA: 83910947904.22.DD30CAC
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id A6AB120010
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 21:40:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Tip2mwta;
	spf=pass (imf03.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758404430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8q2wF8NyUMzUdcB4wo27NEUbPU4EJ5KlqSNJI4hsQkI=;
	b=iZtOmQ+Jl8qW64HJWU+azwEYevjfPaOFPAkAUO7E1z4A8JrSFpxjNYpsmX5OVjxJKLKqIu
	kAkSb0d7+E/JA8G525ki9vo1zcJuwtQVzYBVEgKX/+zRXc7vnFdpO+0FDmtMaERfhgjKyB
	CxHWIDueC67BhnlrTKc7Av3fBqD2So4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Tip2mwta;
	spf=pass (imf03.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758404430; a=rsa-sha256;
	cv=none;
	b=pwnisaHxQBDovJeTDlPLz+gT7eNliWXO+HRptpHiJ5VigfaKGt0Po2WuAuBDoZ0wvQEc7G
	XLncjakBV8BB+kXbYC6+3KVT6t5WBlW4wzMkPz/mJK/+JdFDj2jRdvM2inRnP4nLQEyYDC
	NbUntzJWkxVlT26BWxdmoiETVwy9QYE=
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-5300b29615cso2718708137.0
        for <linux-mm@kvack.org>; Sat, 20 Sep 2025 14:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758404430; x=1759009230; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8q2wF8NyUMzUdcB4wo27NEUbPU4EJ5KlqSNJI4hsQkI=;
        b=Tip2mwtaOgorPO5aijxy6J+7o2mNrnF4/611p+BcUMhTyOCFgo++6qeqNkdAwhMyOU
         rfEByIC9PxP+8VXvSbJ41Cptbt/g0tZJV8cRt+H/3HK+M2AeL1zD1vKAdBcGheJJ4Dku
         68/LIetAoQ20vgnV1R9hGVyIMPOLODWURW5Ih0S7EN5FFA2CuWdeo/1Nt7zRrFKhIimW
         exjXxstmr+djk0dILUWVRhLyRCBEFyF/0XEDGLXucm38DjVd/IEQxPuZnzAHCPudUGfM
         ujhGrmKkX8AF50U1KUeTcyF6MkINge79V+Oow7ZJn+0FkgKNbAHRfhEDtWwCgvVHmrjk
         eEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758404430; x=1759009230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8q2wF8NyUMzUdcB4wo27NEUbPU4EJ5KlqSNJI4hsQkI=;
        b=pGWzqjdVFZd9SaeccOzwZMjbJOVLDkZHZI/XMgGmDXoshq/EB4VpkzDYn40J9X3+CV
         255DDIjzgJ2jhPW7J1PLOhve7/LxH19X85H2n4gOr8aJH0e+nwxzirVv7zTqwH3kZMDe
         QbrCKjpj4k6X8a03Aj3pJu1FnF3pgerVn7n0+f4H76IsiH+8kYSU5PNETTtjfkUiE09V
         uS9e5fOQQLK2V23NydaefUBdHoDbrC1lCMasGRlN0V6kCKKl6nljOM0By2DLXsr1ls2G
         o1lH7w2RE30UgZws/+ZsYZn3FyQzePJ0yo2AaSX9CDiIrUcQIpvwpO9d0ddY1+us1myL
         xaIg==
X-Forwarded-Encrypted: i=1; AJvYcCX4iEddvptq9Y5T9hj5i0anFiYoQcMaldNLnbTqB1spzwDSvydX30e4i3YWqiT5sqCLXlIVmf48yw==@kvack.org
X-Gm-Message-State: AOJu0YzOJ1gWE7JGwfFN+BBKH7OrtdhrXKBbcbl3mFNhKxOScR27ccGT
	BcvtSD+RwNNzA8nY5qtVLprR7cJWroCcGhWxP6csEM5cNtUEHc+RvtwoENkTaVKsElRrBXRKfjc
	siXDxTtzEqTWwLLj+gfXV49tbi1ra/04=
X-Gm-Gg: ASbGncvSBcZrFmXUTe6Z1K8htCclnmkyZpXBHCtRzumVOZ6Cn1j+SGQi1cqzkA9HCF/
	5wFpaRQ0ZDKz3e8a3yBEaGIt1cx8ntIb2NcdOOU2XDQyQe5/ixnVSXNUBSt+pIBU/dxcHTV3aYw
	wo7wgkcgFY81DueN/8dka8ZJv7CdC6uRAF4noGHtdPYXZOaS3ACe4vITgNqgaMhaJRyCYfWoEJ3
	OKN+I1LSM+5CUyGzC51DWk8Y5W3Z7ch8FQD7wM=
X-Google-Smtp-Source: AGHT+IHqnAFDkW9PsCMR9JtuaTJ8E+X1B8qYgA1fXLCBophwWpFMTYWf4IrHqUGDtieqxBjWDIPn4UeSEn1c9B0z+lQ=
X-Received: by 2002:a05:6102:c0b:b0:4fa:25a2:5804 with SMTP id
 ada2fe7eead31-588dada35dfmr2845718137.10.1758404429683; Sat, 20 Sep 2025
 14:40:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com> <20250919212650.GA275426@fedora>
In-Reply-To: <20250919212650.GA275426@fedora>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sat, 20 Sep 2025 14:40:18 -0700
X-Gm-Features: AS18NWCv9lp8HiEvE89FhMeXwqiYRCfEXvgC7JXXJLUd4dVtbVWEBLn_j1OZgfI
Message-ID: <CAM_iQpXnHr7WC6VN3WB-+=CZGF5pyfo9y9D4MCc_Wwgp29hBrw@mail.gmail.com>
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com, 
	Cong Wang <cwang@multikernel.io>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A6AB120010
X-Rspamd-Server: rspam05
X-Stat-Signature: ha981ax78y3rqjj5rofzb1kfrnzsr69j
X-Rspam-User: 
X-HE-Tag: 1758404430-871215
X-HE-Meta: U2FsdGVkX1+kEGQF7knAjDQPHQbsQVz/e+3e4o/mR+o4DcuxKGDiEMVhAH5YyTYPuITs1wZrEdyUNw8b5PM+xCylf5rZlNfa9ml0wSUF+OesE4GCmcXrVhXJaqYCxKsVleonLNh8xTQQc4qAjHdM5EA37Za5dSFNWdA6IfNIqBwMZDHM5O4WdnMEd6vZTGOZS6P17Gs+yknhSjv9Ikz2CENqfjNPHjzAwksrNqtSxvGFYCitTWwRRQwDDlmFJ5F+PQBh9j1/cBmaduEy3U/Gkt7aJnuJuX5BS6DBIW7EpjrWtChHRJGKfmj0xMVkbksqgvOCq4trlCzymZfyCUbuzRhgDksffN2Ss3xYcGLFmGcV4L+dH8mxNIOWBRnjabgKIucnI2ed6k4saMVRdiqvkizHfZw1itN9t/hRRtxHmTLIgUw+IiqjRCIy39Yh/1atRV6wXXE0slFPkFzMXrKHgJaoiKTxm2Q4kKWo7sSfDXJKDlWCJKgsTvMzhxtPZ/b4usvGqm57abaq82yQUzq6bwUsE6QtZhU2XI/cbNi7I/e1u/fq1U96bXPcIO9NL712wjo0c9cu/cO6d+1fY0bAVZ/rBoP1KmtsoO2pPzfH1nMtk9XW7r+oTZ3CDsL3I9sUnSd6Sh0rDwIIBrvCWwtl38ks99KCQv9GVOg60tisp23OP9ebZh5yMm4H+vDRVCAbdswww08GRCEi6F0tgO9Th71b3b4E4oZz/Kc8BpBxKFQkrgAVATm1AiWWjMyRV5vAIspEMXD4N+oOPyysPRO5NQjD4tUdmxYDY0S7RqPgxPTFyEZftzVz0m+aFp9RKkrWSyeM/9GREpFkEv+SJCzmBr/3150Y0+uI0kGudwO/agf7GTBCohsSIr9PYJEY+zGeK835r+ad6d9dYSTyeaj6jkUYgM+ASaGYdfeD0bHhD4KQXQJsSEeIpkzfuI7ikxMExhMyVnlIpFVM6eyzc2P
 lq2f8bwl
 7jcrmqtrph9uyI1JFFCDwxis079g7LmWy161qx6XLOINaxqYJP0eioR3dWRpbTHy+EOM5PubPFIsBmR8fo+MNCkooZC/5398CKBuuqNWjq6gw2350r/LQa/txSwjhPKf0i/552chjO5QK+6Mpf/zg+vG63gCoWyMUZSy7NnhcPAkMyVH4hjFwHLQTxCahA43Jz0zj2XagUzPOPHBEERM8m5C7FkhUmqBdYOXzWOcKHkly1UjYmv8wvn8UbfnU5s8uquU+HD6quDNtZLHeOOt5U89kM1Xo2X1Wu4/PKfe5cnU8U/jgoD5Po5a/OfGr5BT9x4drrIlrCZBEM+MfNsJMimlCeTQUZldPpm8urobFQWbMqL6mQqlfnV6rDo/wfjwo1a9U+/9yHB3WGiswLbsuEJlCs1pzXmTiBh3wp0hk2qYsquMT5kiGCkghHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 2:27=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.co=
m> wrote:
>
> On Thu, Sep 18, 2025 at 03:25:59PM -0700, Cong Wang wrote:
> > This patch series introduces multikernel architecture support, enabling
> > multiple independent kernel instances to coexist and communicate on a
> > single physical machine. Each kernel instance can run on dedicated CPU
> > cores while sharing the underlying hardware resources.
> >
> > The multikernel architecture provides several key benefits:
> > - Improved fault isolation between different workloads
> > - Enhanced security through kernel-level separation
>
> What level of isolation does this patch series provide? What stops
> kernel A from accessing kernel B's memory pages, sending interrupts to
> its CPUs, etc?

It is kernel-enforced isolation, therefore, the trust model here is still
based on kernel. Hence, a malicious kernel would be able to disrupt,
as you described. With memory encryption and IPI filtering, I think
that is solvable.

>
> > - Better resource utilization than traditional VM (KVM, Xen etc.)
> > - Potential zero-down kernel update with KHO (Kernel Hand Over)
> >
> > Architecture Overview:
> > The implementation leverages kexec infrastructure to load and manage
> > multiple kernel images, with each kernel instance assigned to specific
> > CPU cores. Inter-kernel communication is facilitated through a dedicate=
d
> > IPI framework that allows kernels to coordinate and share information
> > when necessary.
> >
> > Key Components:
> > 1. Enhanced kexec subsystem with dynamic kimage tracking
> > 2. Generic IPI communication framework for inter-kernel messaging
> > 3. Architecture-specific CPU bootstrap mechanisms (only x86 so far)
> > 4. Proc interface for monitoring loaded kernel instances
> >
> > Patch Summary:
> >
> > Patch 1/7: Introduces basic multikernel support via kexec, allowing
> >            multiple kernel images to be loaded simultaneously.
> >
> > Patch 2/7: Adds x86-specific SMP INIT trampoline for bootstrapping
> >            CPUs with different kernel instances.
> >
> > Patch 3/7: Introduces dedicated MULTIKERNEL_VECTOR for x86 inter-kernel
> >            communication.
> >
> > Patch 4/7: Implements generic multikernel IPI communication framework
> >            for cross-kernel messaging and coordination.
> >
> > Patch 5/7: Adds arch_cpu_physical_id() function to obtain physical CPU
> >            identifiers for proper CPU management.
> >
> > Patch 6/7: Replaces static kimage globals with dynamic linked list
> >            infrastructure to support multiple kernel images.
> >
> > Patch 7/7: Adds /proc/multikernel interface for monitoring and debuggin=
g
> >            loaded kernel instances.
> >
> > The implementation maintains full backward compatibility with existing
> > kexec functionality while adding the new multikernel capabilities.
> >
> > IMPORTANT NOTES:
> >
> > 1) This is a Request for Comments (RFC) submission. While the core
> >    architecture is functional, there are numerous implementation detail=
s
> >    that need improvement. The primary goal is to gather feedback on the
> >    high-level design and overall approach rather than focus on specific
> >    coding details at this stage.
> >
> > 2) This patch series represents only the foundational framework for
> >    multikernel support. It establishes the basic infrastructure and
> >    communication mechanisms. We welcome the community to build upon
> >    this foundation and develop their own solutions based on this
> >    framework.
> >
> > 3) Testing has been limited to the author's development machine using
> >    hard-coded boot parameters and specific hardware configurations.
> >    Community testing across different hardware platforms, configuration=
s,
> >    and use cases would be greatly appreciated to identify potential
> >    issues and improve robustness. Obviously, don't use this code beyond
> >    testing.
> >
> > This work enables new use cases such as running real-time kernels
> > alongside general-purpose kernels, isolating security-critical
> > applications, and providing dedicated kernel instances for specific
> > workloads etc..
>
> This reminds me of Jailhouse, a partitioning hypervisor for Linux.
> Jailhouse uses virtualization and other techniques to isolate CPUs,
> allowing real-time workloads to run alongside Linux:
> https://github.com/siemens/jailhouse
>
> It would be interesting to hear your thoughts about where you want to go
> with this series and how it compares with a partitioning hypervisor like
> Jailhouse.

Good question. A few people pointed me to Jailhouse before. If I understand
correctly, it is still based on hardware virtualization like IOMMU and VMX.
The goal of multikernel is to completely avoid hw virtualization
and without a hypervisor. Of course, this also depends on how we define
hypervisor here: If it is a user-space one like Qemu, this is exactly what
multikernel tries to avoid; or if it is just a broadly "supervisor",
it still exists
in the kernel (unlike Qemu).

This is why I tend to use "host kernel" and "spawned kernel" to distinguish
them, instead of using "hypervisor" and "guest", which easily confuse
people with  virtualization.

Speaking of virtualization, there are some other technologies like
DirectVisor or De-virt. In my humble opinion, they are going the wrong
way as apparently virt + de-virt =3D no virt. Why even bother virt? ;-p

I hope this answers your questions,

Regards,
Cong

