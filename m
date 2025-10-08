Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 803F9CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 07:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93FEA8E000A; Wed,  8 Oct 2025 03:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917438E0002; Wed,  8 Oct 2025 03:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82DD78E000A; Wed,  8 Oct 2025 03:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7046B8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 03:04:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3BBC13AF8D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 07:04:13 +0000 (UTC)
X-FDA: 83974057986.01.A27945F
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1EB5240013
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 07:04:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=W2KXLJgQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759907052; a=rsa-sha256;
	cv=none;
	b=PtZSkF8uWno3/AkxKkOvE0yO1bcxLoTg3iFf4mfHcZPZSIstY2bkGCvUUXaTExYjxrkHaO
	16s9msVbc1TA7pBb7GqKlZw7rgeJ3P20q5m6u50uDSHSTkzmXii1VgIylpd4ezvsgyr3BT
	WJYJWQuPdEd6TrGs1UjWl1b/u4TpZVA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=W2KXLJgQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759907052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rPCHBZ1+/7LiLJckiEnwJaZfBghJo0RvCO3Y5uD53wo=;
	b=bg6IaZFUKE3W6cPQUlXIUYPTa/GhWAAUmZfAUd1jlDjDf3ezHFVhH5m4LP74vDUHgfabMm
	os+t9bYolurL/U2LE4b5YK4qd7xNOCy5sux2ukCl7v4CJ6Qr6NC+9aaaCa3uSWs8y5UBMn
	H0Gz69KlCJgcOn9SLR4wCeOe9wI724Y=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4e6ec0d1683so159051cf.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 00:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759907051; x=1760511851; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rPCHBZ1+/7LiLJckiEnwJaZfBghJo0RvCO3Y5uD53wo=;
        b=W2KXLJgQEvFe4iHEFCSa0VduaB+vPms2m4raWNdEzrcnl2Xg3g747UT8m09Mxdj0Hk
         uWAqtSa+jBn78q/UTR19U14i1tA/K6/UZdub0Sbd7B74+tJ+W6l8S4rkkCN5xbClSJ1j
         PmwfVLhdb3vyLUcfpkWBNyCrTNKFy09m/qZJlEvJYQtOmr9HmKHk9dlLR4R8XvpES0wr
         E5DsN698x3BtCliTqF+ZEGROWpo1tcEL786rwuWi+/upHXdtx+qK4FuB4FkpQdYtiCHU
         wug+8YkhqYvxeFQ884D9nFvyd2cE1pvVH+Vuiy4bXEPsM5FeIPRewJmeT+/6x32inMJM
         UYZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759907051; x=1760511851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rPCHBZ1+/7LiLJckiEnwJaZfBghJo0RvCO3Y5uD53wo=;
        b=Ns6yNiT0t6BDkcXpdPXP2LMLaqRTUyLjr5XoZVcuBZ2j0vywyG7h6Tv+L+UxcnvqRS
         1g9b/XUAV10RcHttlfuwAYLKrb7iFRhKGQXpY0ig1p5gaemZYXwfFPykb+V4Ngdx1odi
         qoJk3AJ5PawjnBr0T+G5YOIyGTzG+9Saigv/CeNmZFM/DTBs/ShixofD4JPkwNoGD8Xc
         vb5bp0nhak/wV8sVbFMK+KU+z6voJ7LrCxnVK6bB26ivWsm5fw+HpfndaNwpSSPkrl2U
         bbcYxIgQIfD6hRF2Nn15ojS2KWOKWtUUPyxvvs2A0ZghnUERy9vummNaEFN/GeOw9WlT
         5rAQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+sAfQwc4Z+6DpB2O4z213cQeF4A7z+r8Bn/AWmFm5NxXg1TgbJDhxf6XbRni308kHfioqRFgCQA==@kvack.org
X-Gm-Message-State: AOJu0Yx0tQ5Pgge8jjnWO/8JM71dMTP/SJjq7wTkV2cCXlJOg1RF4TVC
	8BHk7UvNiXAgouUfQ4IkKmqh+FdUft2fjuoAeDgHhc4YYKPQRYcRCkErwF8uMvrgKztAJhnIC5r
	wMcFwN0vrU10wwkSWs8HSF7xgp6ouFJMUNw+cfayu
X-Gm-Gg: ASbGncuP9Nj79claZm3XyFuK5qWgqUpUrXe4oxZVPnIVlXk8dYCvDchZ2jFoKOZAZCA
	pUmlritlJHOwH8YEEajl/l21vEp/WCQIyE75cbFhndXKGbF5GAVxrdFhYvIn5dsbcxUeygX2J2w
	K3zI/YASdxJJ2rwDZFpPAMYH2ASNta3/UDdOBfokk4ZIxhfkcc087gbcy+hWOldf6kuG3mpfcXT
	ci6heRhf83mkr7RJaxDPiIvMWENzAIPG5aUJoRh/hAOudSOJWwmCBVz2VxoeqT1XYiRA7IGDVVL
	fpiyXA==
X-Google-Smtp-Source: AGHT+IESBNxpmlHAcig1IJkHHF05YX821iqOxoDV74weoqPTYVJz+7JZa7+j9bKX361CFoQRAxX2np/+3jTAYoYjULA=
X-Received: by 2002:a05:622a:14cd:b0:4b4:9863:5d76 with SMTP id
 d75a77b69052e-4e6eab2eacfmr4994001cf.8.1759907049795; Wed, 08 Oct 2025
 00:04:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com> <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
In-Reply-To: <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Wed, 8 Oct 2025 00:03:58 -0700
X-Gm-Features: AS18NWCS-g05IhVhTIM2Iz76DqP2Hm1WLW7pFPt_MogdzxJ745tyFKTSuojklQE
Message-ID: <CAAywjhSP=ugnSJOHPGmTUPGh82wt+qnaqZAqo99EfhF-XHD5Sg@mail.gmail.com>
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
To: Pasha Tatashin <pasha.tatashin@soleen.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1EB5240013
X-Stat-Signature: 5pdk7ezpz8k31ej6togxcn38ksb13335
X-HE-Tag: 1759907051-160235
X-HE-Meta: U2FsdGVkX1+HT+dT80W+mXrNXU5HRLMIlEcoFBnCIiQnYA9DrlCq/Dvh9J15hmzcpv+weue3lr9QtFvxsbQlRZTnRRrGu1edmHkl/CoV4SCTLXEqgJEbaFhGd68QfKp44rNhGT8YB/hkQmRwAhwdY6wSVEljSa/+9DVqbrxjmHPijNku6mLz5nMGnHMRg641JBvmFml48lDnPOQligdWpki3oNap4f66XK6ssO8Qjg/NPBpXmfgpLFbzaqXnI0Ow3oHEJAl5j/ykyt1vgmuqn/bFVNSJrTWrxA9arNK3Qi3hOO67m7mlKcRM1gvz18YVR9CH4ibQFgdCABUp9eeQkI0SaxSWr/rQlKlOMsHnbLRgdbC3X/jA+QMD0eKYgAyqqE+HbENmwaVjr/MbYkVYww+w9IM0mKIcvjc7ODEMWyKNBL+SO2efqm6o4G5odTSyld/gfPvQ1CunGD0KaIMMQfVGiZ55FpyfF9y7plS6ZVe2wg8hdKR3OMBEVz8WxqgkdLt6Y7RPuptSnHIhDo428I2rqTySNXySlK439nXT5OijxW0QYuz8lS9z1uwgmbqbVD8xwKxAGdLdrdI75TuFpeMGE/9LqT0aQ11xqdgSzYPVuHs0M66AwgBLIHonf368VCmmXt7s0bcAAdI/UdicPcWxV7n2YGM+bkigPDILolkWfV9eGUM41NTofu9Xm8YgMxrtuNR3GYs4K9ZTDoXbb8aIYAksQcZ4m/dUmSl4jGoK2kwGE3an61eFxLCOLsDcP1UFmpGXK6jmFlCg+pLGrAXURxlChG0WiF2rA8PNWom9m8qUm8I4DBCmDvTNaC64+BEsQhYprvkg33CTEpg+PXy36XNEx2+qpDZ6kvLc+BrbgV0h9pdZqHic4yp5M2ZRPqNKxjMtZOt0O1D7wqLVWD1k9exqWhqv+7b1A/inJ+F+4NiPe8219QOFbGpYa4GqmQDVjimwJBJheoiJHsp
 0T9hIcYW
 oaX0ZoyI3TPqVD3cUFU5orqTUGj4WXcPFUat+DIq+6JR4E00TDaksrSNYb31PqxdRWz/ARfMhdsQlkdEO9hk+PBOJTfhFvHAIRdidVTLZvPFJS6Ae64WL5xFBR8WIOKta01defuYl74W1h7zT/RzuB1tWnxxU2fnswvMMGWz1puPfo6vhvaQQ9Ac2aCm6YF323bLxPyV/v0zcvmBYUdTcfnRGDJ/iJ3bvBcEXFl/M/xK90n0Ps0ROAEqiNyQErGoOyCXNrkHuzMQeDTd6kMFNfAouOh1Z7EDllxfvVDKnoIbqI6DuPIPzEhOfs6unZGNflEPXLEZlJE3im94oj2nxMlBxkT+OWho0cKfAprK7PTLlYs3knJWWjDmkIF9827S8zgwlz2z2QDqRqRA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 7, 2025 at 10:11=E2=80=AFAM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Sun, Sep 28, 2025 at 9:03=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> >
> > This series introduces the Live Update Orchestrator (LUO), a kernel
> > subsystem designed to facilitate live kernel updates. LUO enables
> > kexec-based reboots with minimal downtime, a critical capability for
> > cloud environments where hypervisors must be updated without disrupting
> > running virtual machines. By preserving the state of selected resources=
,
> > such as file descriptors and memory, LUO allows workloads to resume
> > seamlessly in the new kernel.
> >
> > The git branch for this series can be found at:
> > https://github.com/googleprodkernel/linux-liveupdate/tree/luo/v4
> >
> > The patch series applies against linux-next tag: next-20250926
> >
> > While this series is showed cased using memfd preservation. There are
> > works to preserve devices:
> > 1. IOMMU: https://lore.kernel.org/all/20250928190624.3735830-16-skhawaj=
a@google.com
> > 2. PCI: https://lore.kernel.org/all/20250916-luo-pci-v2-0-c494053c3c08@=
kernel.org
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Changelog since v3:
> > (https://lore.kernel.org/all/20250807014442.3829950-1-pasha.tatashin@so=
leen.com):
> >
> > - The main architectural change in this version is introduction of
> >   "sessions" to manage the lifecycle of preserved file descriptors.
> >   In v3, session management was left to a single userspace agent. This
> >   approach has been revised to improve robustness. Now, each session is
> >   represented by a file descriptor (/dev/liveupdate). The lifecycle of
> >   all preserved resources within a session is tied to this FD, ensuring
> >   automatic cleanup by the kernel if the controlling userspace agent
> >   crashes or exits unexpectedly.
> >
> > - The first three KHO fixes from the previous series have been merged
> >   into Linus' tree.
> >
> > - Various bug fixes and refactorings, including correcting memory
> >   unpreservation logic during a kho_abort() sequence.
> >
> > - Addressing all comments from reviewers.
> >
> > - Removing sysfs interface (/sys/kernel/liveupdate/state), the state
> >   can now be queried  only via ioctl() API.
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Hi all,
>
> Following up on yesterday's Hypervisor Live Update meeting, we
> discussed the requirements for the LUO to track dependencies,
> particularly for IOMMU preservation and other stateful file
> descriptors. This email summarizes the main design decisions and
> outcomes from that discussion.
>
> For context, the notes from the previous meeting can be found here:
> https://lore.kernel.org/all/365acb25-4b25-86a2-10b0-1df98703e287@google.c=
om
> The notes for yesterday's meeting are not yes available.
>
> The key outcomes are as follows:
>
> 1. User-Enforced Ordering
> -------------------------
> The responsibility for enforcing the correct order of operations will
> lie with the userspace agent. If fd_A is a dependency for fd_B,
> userspace must ensure that fd_A is preserved before fd_B. This same
> ordering must be honored during the restoration phase after the reboot
> (fd_A must be restored before fd_B). The kernel preserve the ordering.
>
> 2. Serialization in PRESERVE_FD
> -------------------------------
> To keep the global prepare() phase lightweight and predictable, the
> consensus was to shift the heavy serialization work into the
> PRESERVE_FD ioctl handler. This means that when userspace requests to
> preserve a file, the file handler should perform the bulk of the
> state-saving work immediately.
>
> The proposed sequence of operations reflects this shift:
>
> Shutdown Flow:
> fd_preserve() (heavy serialization) -> prepare() (lightweight final
> checks) -> Suspend VM -> reboot(KEXEC) -> freeze() (lightweight)
>
> Boot & Restore Flow:
> fd_restore() (lightweight object creation) -> Resume VM -> Heavy
> post-restore IOCTLs (e.g., hardware page table re-creation) ->
> finish() (lightweight cleanup)
>
> This decision primarily serves as a guideline for file handler
> implementations. For the LUO core, this implies minor API changes,
> such as renaming can_preserve() to a more active preserve() and adding
> a corresponding unpreserve() callback to be called during
> UNPRESERVE_FD.
>
> 3. FD Data Query API
> --------------------
> We identified the need for a kernel API to allow subsystems to query
> preserved FD data during the boot process, before userspace has
> initiated the restore.
>
> The proposed API would allow a file handler to retrieve a list of all
> its preserved FDs, including their session names, tokens, and the
> private data payload.
>
> Proposed Data Structure:
>
> struct liveupdate_fd {
>         char *session; /* session name */
>         u64 token; /* Preserved FD token */
>         u64 data; /* Private preserved data */
> };
>
> Proposed Function:
> liveupdate_fd_data_query(struct liveupdate_file_handler *h,
>                          struct liveupdate_fd *fds, long *count);
>
> 4. New File-Lifecycle-Bound Global State
> ----------------------------------------
> A new mechanism for managing global state was proposed, designed to be
> tied to the lifecycle of the preserved files themselves. This would
> allow a file owner (e.g., the IOMMU subsystem) to save and retrieve
> global state that is only relevant when one or more of its FDs are
> being managed by LUO.
>
> The key characteristics of this new mechanism are:
> The global state is optionally created on the first preserve() call
> for a given file handler.
> The state can be updated on subsequent preserve() calls.
> The state is destroyed when the last corresponding file is unpreserved
> or finished.
> The data can be accessed during boot.
>
> I am thinking of an API like this.
>
> 1. Add three more callbacks to liveupdate_file_ops:

This part is a little tricky, the file handler might be in a
completely different subsystem as compared to the global state. While
FD is supposed to own and control the lifecycle of the preserved
state, the global state might be needed in a completely different
layer during boot or some other event. Maybe the user can put some
APIs in place to move this state across layers?

Subsystems actually do provide this flexibility. But If I see
correctly, this approach is "global" like a subsystem but synchronous.
Users can decide when to preserve/create global state when they need
without the need to stage it and preserve it when subsystem PREPARE is
called.
> /*
>  * Optional. Called by LUO during first get global state call.
>  * The handler should allocate/KHO preserve its global state object and r=
eturn a
>  * pointer to it via 'obj'. It must also provide a u64 handle (e.g., a ph=
ysical
>  * address of preserved memory) via 'data_handle' that LUO will save.
>  * Return: 0 on success.
>  */
> int (*global_state_create)(struct liveupdate_file_handler *h,
>                            void **obj, u64 *data_handle);
>
> /*
>  * Optional. Called by LUO in the new kernel
>  * before the first access to the global state. The handler receives
>  * the preserved u64 data_handle and should use it to reconstruct its
>  * global state object, returning a pointer to it via 'obj'.
>  * Return: 0 on success.
>  */
> int (*global_state_restore)(struct liveupdate_file_handler *h,
>                             u64 data_handle, void **obj);

If I understand correctly, is this only for unpacking? Once unpacked
the user can call the _get function and get the global state that it
just unpacked. This should be fine.
>
> /*
>  * Optional. Called by LUO after the last
>  * file for this handler is unpreserved or finished. The handler
>  * must free its global state object and any associated resources.
>  */
> void (*global_state_destroy)(struct liveupdate_file_handler *h, void *obj=
);
>
> The get/put global state data:
>
> /* Get and lock the data with file_handler scoped lock */
> int liveupdate_fh_global_state_get(struct liveupdate_file_handler *h,
>                                    void **obj);
>
> /* Unlock the data */
> void liveupdate_fh_global_state_put(struct liveupdate_file_handler *h);
>
> Execution Flow:
> 1. Outgoing Kernel (First preserve() call):
> 2. Handler's preserve() is called. It needs the global state, so it calls
>    liveupdate_fh_global_state_get(&h, &obj). LUO acquires h->global_state=
_lock.
>    It sees h->global_state_obj is NULL.
>    LUO calls h->ops->global_state_create(h, &h->global_state_obj, &handle=
).
>    The handler allocates its state, preserves it with KHO, and returns it=
s live
>    pointer and a u64 handle.
> 3. LUO stores the handle internally for later serialization.
> 4. LUO sets *obj =3D h->global_state_obj and returns 0 with the lock stil=
l held.
> 5. The preserve() callback does its work using the obj.
> 6. It calls liveupdate_fh_global_state_put(h), which releases the lock.
>
> Global PREPARE:
> 1. LUO iterates handlers. If h->count > 0, it writes the stored data_hand=
le into
>    the LUO FDT.
>
> Incoming Kernel (First access):
> 1. When liveupdate_fh_global_state_get(&h, &obj) is called the first time=
. LUO
>    acquires h->global_state_lock.
> 2. It sees h->global_state_obj is NULL, but it knows it has a preserved u=
64
>    handle from the FDT. LUO calls h->ops->global_state_restore()
> 3. Reconstructs its state object, and returns the live pointer.
> 4. LUO sets *obj =3D h->global_state_obj and returns 0 with the lock held=
.
> 5. The caller does its work.
> 6. It calls liveupdate_fh_global_state_put(h) to release the lock.
>
> Last File Cleanup (in unpreserve or finish):
> 1. LUO decrements h->count to 0.
> 2. This triggers the cleanup logic.
> 3. LUO calls h->ops->global_state_destroy(h, h->global_state_obj).
> 4. The handler frees its memory and resources.
> 5. LUO sets h->global_state_obj =3D NULL, resetting it for a future live =
update
>    cycle.
>
> Pasha
>
>
> Pasha

