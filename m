Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BD09CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 22:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5408E8E0039; Thu,  9 Oct 2025 18:42:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517BE8E0002; Thu,  9 Oct 2025 18:42:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D3C8E0039; Thu,  9 Oct 2025 18:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8F28E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:42:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D16005C6DF
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 22:42:49 +0000 (UTC)
X-FDA: 83980052058.12.BE7E12C
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id D07558000A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 22:42:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PuLHkq3v;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760049768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FbWfQ96AFEkEG50UixpYovK71meMygfaTOSv2fS0lo=;
	b=c+GwYxsAE5ekblHb3K70e+zAEVdOdQFlZe4w/Ee7RVGCQNwB3Fbkwmq8W7YmSwOWqDWtKS
	5EYGRNpG4ZwwbKs7PgVQBIGYf8RGk61mokT3OHPQUozHn6Jt7KOAtjxJ8qqUX9pQF5IQKX
	T641/s4Yy8EdcPpvn/YrZXRCEXDfUbc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760049768; a=rsa-sha256;
	cv=none;
	b=RL+rHXvk3oN+oUD8XsKU+WnVx8oGMvKuzk0afyWh4w3HXyl9pWl+IaWitfPyRogB5WdU4i
	4JYqhERAMRAuOIGnLp4AAj357ECy3yByYHyQYWLMtUt7ZYMPxDYN+QgX6MeZzF+HsG7Xfa
	PGmLuM3OKWy9pL/tZmQEGRWOq3+NEqo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PuLHkq3v;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4e2d2d764a3so12729971cf.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 15:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760049767; x=1760654567; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0FbWfQ96AFEkEG50UixpYovK71meMygfaTOSv2fS0lo=;
        b=PuLHkq3vPWndxyN8h4X44/eM0j2/RHmIOB6BXZ9JbnxjaH75LHXFFZfcSuCs8Jt6AQ
         OIb9lfrymKxovDscac7oyl0NwLF7iETdCoiCPJviFv0zQeNt4nuAZBuVIqM5JvcV5Hrf
         8Z6LHr5u4YjSl1UHU2rtArbdNrkZ3O90YSw7EdKxsyQT3HryozTsRviTVgGKpvxNMXpq
         xG6Tf8E/SrzTTROTUKKEc2IsYcQIlSCkH3tPwMQ9Tz2sZHMMm8rJEaE8FWkQRmD9lO+B
         6wENzbabt5xRdzmRCacvTbEt/M3Ap68OpB5HiHEotT5T4ZqQypME6lL8shYhkwuV8Eei
         vuTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760049767; x=1760654567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0FbWfQ96AFEkEG50UixpYovK71meMygfaTOSv2fS0lo=;
        b=NNXh+6YfOOqJnQbuXd7/bIjqjAbwD4P3GCQMdAdTqFXeZk2nnIaGoQbGILExKxjKWY
         eBKLe1m5oiPF5gXS1QHgdHu3ED7ZXaMw1NX7+p9ccLvS64eBqBnZ1yha5bnA6/mAwBpV
         KFfyQ5qBto9szbVxS55DlstFJ83NWsmJXHidPRwIyo41p0MHqyckyDiwuFr9W09UDYMq
         me0EMjCWiRZqqAnNXeJ1DqlO8S+8fBZQg/5cII5fQb4e7Jef2cU/dWUt6qZEIA2fz9GQ
         bbpOZWjZF5sT3PtdhM8CJpWuk+RhKK2slpky4gu1OCq9Rio6+oS/oeO8YsYVVhq6tRDc
         Wffg==
X-Forwarded-Encrypted: i=1; AJvYcCXAkqYacCBkPLh+twKpRvk2lhbBUFDUmI1HcgSGQ9JDTLpK+zX5LvlCLygaUhUYVovNc9omq49kRQ==@kvack.org
X-Gm-Message-State: AOJu0YxmwhFhnvf0stBz7Eh5DB0KKPEIE+PzDrKKaM+KvGj0Wwp4gvAI
	VeipH2i0pQcbcl35LybffM6fn2Hmz+GAH7xQ/KPH5Bg6kL1FPdaXfmx4CSZUrAkv2Mzpj3ZE2h1
	IuBO/32DFiV96Wb+Fd4i3LEogMO/k2wjW8U3x7LK87Q==
X-Gm-Gg: ASbGnctf9028RjP028lTCckLwBwYvAYoRiOeO42Eg2y2RrpMSBi+xVx1UEsC2DcxTT4
	h9UrA2gwZXbLndTK4DPv8xWz2iJxB9KknAt1WdcXhYep2BZzZWNlcsizVcARfZSNN5yOuajSPD/
	d9B3gfpSBig73VZf1nUU88NJPovZ+mTxFRAmr3XFhydOJbLc6LTT+qK+85Cmq5lRZFOs9qHT7E1
	XZJjsyKnB8IyZlmSpKFsiASkIZW
X-Google-Smtp-Source: AGHT+IHG5W702Zbf4mjn7MvE15WtY39zkt1MK6wHvNWeSpV5Z77scUuTO2nY2xRATETmTz79MrDYNcaEvgfPFiK7ygM=
X-Received: by 2002:a05:622a:60d:b0:4b6:33c1:4d53 with SMTP id
 d75a77b69052e-4e6eacccf23mr129760071cf.16.1760049766599; Thu, 09 Oct 2025
 15:42:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com> <CAAywjhT_9vV-V+BBs1_=QqhCGQqHo89qWy7r5zW1ej51yHPGJA@mail.gmail.com>
In-Reply-To: <CAAywjhT_9vV-V+BBs1_=QqhCGQqHo89qWy7r5zW1ej51yHPGJA@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 9 Oct 2025 18:42:09 -0400
X-Gm-Features: AS18NWD5B-wFlFzrsG8ABOC3Hmjw4CdpOCjhPtFpyfzvKOXdPCdlviqFJ5wfQM0
Message-ID: <CA+CK2bAe3yk4NocURmihcuTNPUcb2-K0JCaQQ5GJ4B58YLEwEw@mail.gmail.com>
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
To: Samiullah Khawaja <skhawaja@google.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
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
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: dgg9oxf6wgfk1q5stcgybbz8mjdw3r7i
X-Rspam-User: 
X-Rspamd-Queue-Id: D07558000A
X-HE-Tag: 1760049767-286154
X-HE-Meta: U2FsdGVkX1+pcLP0le9gIlLRmWClmbofcGLpsrrrB2Bt3OGMe1EJlfVxc6jQbEQjPssXytQyzi0lAvAac+b9F0eK+0qNbyc3PInX+Qt1YA0m0BHHq7apWSfuXepbDe2mL4+p1d0gMJpixa9XYV4NaQCROdwN9afprIwZcdePTCG3vCCvSfUv99XR1+zkwAhpSPiI62z+RbWwi0WQeA8KCQW7rJ+Ycor8z3qmvkCSB2vmX6wO9vqDcbGd67P7hol2BOToCCKhY12aRBCNR3gP67AhnB9R8ZOZebXd9yEtVqND8X97AomMZ+QKEc+uL03PKssknhRaQRqcm7ey6aoKOgnw4GvSc0Cqk6dgltbevKI1dTqB8BDB7/kfl//B0dYmBZXlzQxIAKa2oT17tH/jYQFTCT7FEPHvQWGnxSj8OjcgRCjOAnimFJMY8D8nZGsHV12BCRNPxN8IOGxqFRCbADjbYar1gBcYwufiATmWPMuz0/lD9SsLQvQ0IoSxcXLh/uahXkYzSYPz2rIwJb+uxdA2Hwk0Uw2d62ipZiTvarnBg9uHw8/RVTUXX2QFqjaJ6s5bTT4s5Md+uPGWzjgkJnbY8xbi+lbdr96tTslngNdh2Y7WgaEE/9ffjYCpW38aKyqK+KazuyUhQoRmpHIsH+I6T6x/B9m9aVid+MVOJUUpWAlIaXIEpFjiNOoeKRuQJtApK6qdeeKGembY9kDvAy4jEsjMpFIALswkou3VeMs0o4Qog1b7Oz34QzZ97bSZwRI++Q/APAsu8BzMvU0aBJ8ZPBz06/VtC1w1HtkLslIZY5AZ9CdNrGZr39G9Ol9N9uf6XN5oTOTYa02WDQuxqVPX3ZvITu2ibuHcuCmB5ujgJaxUbxvaBFDn5iNbRSdRGQxPdqs9JTGhBj41RSxuYImsfwk5JD8wZV0pKppE3lB3UZEuAmZC5NhL124rTPThQ/n77Q2EGX8uHmzHxN4
 g+DlVEWZ
 yd7YMN6gmwWi9nRUkkFOwkgCJp+M0ddqldHzDL9ygzOfHqRPTrGoA8K6YbpqdW7Aybf/+fkr4cF58SlHBLZZTr00XCxCNoCa0xXCapByPHbEhQPQEcWry4To5u4tVzYGGFV6090wv9M/1AFbLY6yQyZb6FKbHmzHpgdTIzjoGSEfOrFQ+cmcmWsxthzS7sm2MA7BiHYlVm1BFU9ILdCRCZCPWiQsfA6z2kFXQmpUIFLu7Dn/cN7rY97SU67C0wrHhvUl/9fc4BvuM0LxDP9TPm+iA2QMAg9RTpJNpu20amMMbFZt/38AraBE5fsJ0042r1/fsrZr5Y/IMl9XyFo1kESseQy3eM7yBvAbACiTuIktKrVmhTqVz/CXLDHtCF8tq4JwYmgT4859PVjs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 5:58=E2=80=AFPM Samiullah Khawaja <skhawaja@google.c=
om> wrote:
>
> On Tue, Oct 7, 2025 at 10:11=E2=80=AFAM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> >
> > On Sun, Sep 28, 2025 at 9:03=E2=80=AFPM Pasha Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> > >
> > > This series introduces the Live Update Orchestrator (LUO), a kernel
> > > subsystem designed to facilitate live kernel updates. LUO enables
> > > kexec-based reboots with minimal downtime, a critical capability for
> > > cloud environments where hypervisors must be updated without disrupti=
ng
> > > running virtual machines. By preserving the state of selected resourc=
es,
> > > such as file descriptors and memory, LUO allows workloads to resume
> > > seamlessly in the new kernel.
> > >
> > > The git branch for this series can be found at:
> > > https://github.com/googleprodkernel/linux-liveupdate/tree/luo/v4
> > >
> > > The patch series applies against linux-next tag: next-20250926
> > >
> > > While this series is showed cased using memfd preservation. There are
> > > works to preserve devices:
> > > 1. IOMMU: https://lore.kernel.org/all/20250928190624.3735830-16-skhaw=
aja@google.com
> > > 2. PCI: https://lore.kernel.org/all/20250916-luo-pci-v2-0-c494053c3c0=
8@kernel.org
> > >
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > Changelog since v3:
> > > (https://lore.kernel.org/all/20250807014442.3829950-1-pasha.tatashin@=
soleen.com):
> > >
> > > - The main architectural change in this version is introduction of
> > >   "sessions" to manage the lifecycle of preserved file descriptors.
> > >   In v3, session management was left to a single userspace agent. Thi=
s
> > >   approach has been revised to improve robustness. Now, each session =
is
> > >   represented by a file descriptor (/dev/liveupdate). The lifecycle o=
f
> > >   all preserved resources within a session is tied to this FD, ensuri=
ng
> > >   automatic cleanup by the kernel if the controlling userspace agent
> > >   crashes or exits unexpectedly.
> > >
> > > - The first three KHO fixes from the previous series have been merged
> > >   into Linus' tree.
> > >
> > > - Various bug fixes and refactorings, including correcting memory
> > >   unpreservation logic during a kho_abort() sequence.
> > >
> > > - Addressing all comments from reviewers.
> > >
> > > - Removing sysfs interface (/sys/kernel/liveupdate/state), the state
> > >   can now be queried  only via ioctl() API.
> > >
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Hi all,
> >
> > Following up on yesterday's Hypervisor Live Update meeting, we
> > discussed the requirements for the LUO to track dependencies,
> > particularly for IOMMU preservation and other stateful file
> > descriptors. This email summarizes the main design decisions and
> > outcomes from that discussion.
> >
> > For context, the notes from the previous meeting can be found here:
> > https://lore.kernel.org/all/365acb25-4b25-86a2-10b0-1df98703e287@google=
.com
> > The notes for yesterday's meeting are not yes available.
> >
> > The key outcomes are as follows:
> >
> > 1. User-Enforced Ordering
> > -------------------------
> > The responsibility for enforcing the correct order of operations will
> > lie with the userspace agent. If fd_A is a dependency for fd_B,
> > userspace must ensure that fd_A is preserved before fd_B. This same
> > ordering must be honored during the restoration phase after the reboot
> > (fd_A must be restored before fd_B). The kernel preserve the ordering.
> >
> > 2. Serialization in PRESERVE_FD
> > -------------------------------
> > To keep the global prepare() phase lightweight and predictable, the
> > consensus was to shift the heavy serialization work into the
> > PRESERVE_FD ioctl handler. This means that when userspace requests to
> > preserve a file, the file handler should perform the bulk of the
> > state-saving work immediately.
> >
> > The proposed sequence of operations reflects this shift:
> >
> > Shutdown Flow:
> > fd_preserve() (heavy serialization) -> prepare() (lightweight final
> > checks) -> Suspend VM -> reboot(KEXEC) -> freeze() (lightweight)
> >
> > Boot & Restore Flow:
> > fd_restore() (lightweight object creation) -> Resume VM -> Heavy
> > post-restore IOCTLs (e.g., hardware page table re-creation) ->
> > finish() (lightweight cleanup)
> >
> > This decision primarily serves as a guideline for file handler
> > implementations. For the LUO core, this implies minor API changes,
> > such as renaming can_preserve() to a more active preserve() and adding
> > a corresponding unpreserve() callback to be called during
> > UNPRESERVE_FD.
> >
> > 3. FD Data Query API
> > --------------------
> > We identified the need for a kernel API to allow subsystems to query
> > preserved FD data during the boot process, before userspace has
> > initiated the restore.
> >
> > The proposed API would allow a file handler to retrieve a list of all
> > its preserved FDs, including their session names, tokens, and the
> > private data payload.
> >
> > Proposed Data Structure:
> >
> > struct liveupdate_fd {
> >         char *session; /* session name */
> >         u64 token; /* Preserved FD token */
> >         u64 data; /* Private preserved data */
> > };
> >
> > Proposed Function:
> > liveupdate_fd_data_query(struct liveupdate_file_handler *h,
> >                          struct liveupdate_fd *fds, long *count);
>
> Now that you are adding the "File-Lifecycle-Bound Global State", I was
> wondering if this session data query mechanism is still necessary. It
> seems that any preserved state a file handler needs to restore during
> boot could be fetched using the Global data support instead. For
> example, I don't think session information will be needed to restore
> iommu domains during boot (iommu init), but even if some other file
> handler needs it then it can keep this info in global data. I
> discussed this briefly with Pasha today, but wanted to raise it here
> as well.

I agree, the query API is ugly and indeed not needed with the FLB
Global State. The biggest problem with the query API is that the
caller must somehow know how to interpret the preserved file-handler
data before the struct file is reconstructed. This is problematic;
there should only be one place that knows how to store and interpret
the data, not multiple.

It looks like the combination of an enforced ordering:
Preservation: A->B->C->D
Un-preservation: D->C->B->A
Retrieval: A->B->C->D

and the FLB Global State (where data is automatically created and
destroyed when a particular file type participates in a live update)
solves the need for this query mechanism. For example, the IOMMU
driver/core can add its data only when an iommufd is preserved and add
more data as more iommufds are added. The preserved data is also
automatically removed once the live update is finished or canceled.

Pasha

