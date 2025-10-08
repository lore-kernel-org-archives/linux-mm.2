Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2061FCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 16:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EBC38E0048; Wed,  8 Oct 2025 12:41:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B238E0002; Wed,  8 Oct 2025 12:41:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B16C8E0048; Wed,  8 Oct 2025 12:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58BC18E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:41:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09B09140676
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:41:15 +0000 (UTC)
X-FDA: 83975512110.25.A29EED9
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3FBA0100006
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:41:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TTbYmOdH;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759941673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y0QDDkoHx1oddr1kYoPe9XtgfxjyTTRXUHnhEvUEaHE=;
	b=59kx2wiU0STO6qzSyfF2JQ1+pFmm1RRAEg7//c6d0YCX9eQKXeEaVjm5o5zlFV9IRmDFD9
	AgvJsjxnCO+Svar2i0g9FuuwacDDV0DfVpVCP31/kLFCLPohfnkRXW92jE1isebwcIPrgR
	pJM6hsrb5kYjjaqX76ehAoRgbHg+ah0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TTbYmOdH;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759941673; a=rsa-sha256;
	cv=none;
	b=Kz6Of/Ot/Rz7LXiBj7gWqb2oOJrmd5N5jikWlvgm/pDMspF1RwvjH7LTqcqfOqigGXFLul
	NIY1mYa+b0feR1fC+srCJ16g+Pn3liZOicRrCKy+VhFT9vW0v3irQpv63AzIuJmzqnq8q8
	pG8oRV+qRH75NJEJjy3E/e8i2iFZ+jU=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-856701dc22aso1145885a.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 09:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759941672; x=1760546472; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y0QDDkoHx1oddr1kYoPe9XtgfxjyTTRXUHnhEvUEaHE=;
        b=TTbYmOdH/jKG4uUU2vyWMBxT2HU3TkAa7OuyPELgYOQOalgK/A32ns5TyYOPx4kcr4
         5kn3UOcwIacbxsKVI0mLFwwuLLr/qpnTARpVPry8mUjnDhlgSmSatayze28gKgqvyiXz
         WL/ZFaTItEAhC6MaJ+uurEmU7YkpBERQIGKU+8z63zzYWmR7cbVIR150L2HgN2Wcw1pW
         uxyJc2owBWY+5OWyFj4rpq30E23mBGkWhjk9a1Mq+eF8ghuTSGJje+/wP1BhX8KFlwMJ
         lHxnhWKi/gXllS4iwdS5MN/CawpMNllM1y3jAW0U0x5wT4v1fMOfS2Py+MgTK0EnEQYf
         Q2fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759941672; x=1760546472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y0QDDkoHx1oddr1kYoPe9XtgfxjyTTRXUHnhEvUEaHE=;
        b=P69XFxKQ3aeyy6j3fxCr+e9cUBei+IHMpBbsLiD6u9G3wXyNT3wgAe5oplad68qDvd
         yfg+kEdaH16+AlB4yqk9zj3663XslePv+FYkoQYK2RxQggR055jeLVHuzdi8slVCnFDZ
         QFgYxgdnenSsaFysLk7Ah19WfUkSsDufLEhhjrhoxN92Q5Fs73k5QlCdzlxAXU8RQAWy
         tvly59+Bk/izGIJMEAQvXzEJWF2IUgiFDauNJgzqxSyrFUZenl0UwrAC2Ok+2HLJNXcn
         xLCfztEPDp5aJy/2+/fUbAaUpTMmHHdahMv8DDKaQAbJbDMIWFbyEhYauhZopUOQrVw7
         RVVw==
X-Forwarded-Encrypted: i=1; AJvYcCX0Fgn50MYn/42NoFcjD9dKuwXdT9cASnDmZ4cJNPkjrL4kWVaQU2ybyeNDu58+7+OKoBw6y1QcvQ==@kvack.org
X-Gm-Message-State: AOJu0YxVINk9FwvOx9iCI6uenoyzGgFE6WBa6LXA8b8fM71Xe32oeACa
	9vvO0ZA/vJU3igFw9pIoEpmkweo5OE8YKqXnaYozYffBxZMkXX+fLlC+lqjlahm93nHHSKhtBao
	+YWy6BGOJVhrUof2e0Xawvfsv1ytTf88nqp8yIwom3w==
X-Gm-Gg: ASbGnctSuig/KrAWawplE2TwNQpRq8SH17bVxBaRTalldf9emVqkzTXUBYSs576ejMV
	7P5qiWsZx8n4d7AgGMTFAR5HJFPdN2m5HlkiIIZOU7+TMNEZR1DqG938qnFOPbDwROnP1YzjwUg
	tP4xjr6aku7/s1oO0A0Ppm9uJu6Z7IMjDmqJTe14dksaqT+OHCBW1yT5X466XVDVhIMFzh7vpO3
	jhViTlzQyzySCyFqYv32R3QtWVK
X-Google-Smtp-Source: AGHT+IE3RKIZb1iIOLaTyMNTcxfyaBM7YSPyWPYytKjmmpW9kMu81LYT+MqTFPjCR/XhBeZkyeuypkTguw/UEdpotf8=
X-Received: by 2002:a05:620a:410c:b0:829:b669:c791 with SMTP id
 af79cd13be357-88352d9a448mr549049785a.78.1759941671964; Wed, 08 Oct 2025
 09:41:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com> <CAAywjhSP=ugnSJOHPGmTUPGh82wt+qnaqZAqo99EfhF-XHD5Sg@mail.gmail.com>
In-Reply-To: <CAAywjhSP=ugnSJOHPGmTUPGh82wt+qnaqZAqo99EfhF-XHD5Sg@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 8 Oct 2025 12:40:34 -0400
X-Gm-Features: AS18NWBehU4q9WUE9mwN1N00X-Mv4SLEo64BJ5126E8o614dVWx--_4ZFo216so
Message-ID: <CA+CK2bAG+YAS7oSpdrZYDK0LU2mhfRuj2qTJtT-Hn8FLUbt=Dw@mail.gmail.com>
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
X-Stat-Signature: tim9ghn5bj5rg3k11oj68a7g67dc9p18
X-Rspamd-Queue-Id: 3FBA0100006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759941673-613294
X-HE-Meta: U2FsdGVkX1+SuBQuQY81t7F36eHySJi0Crohhox3BWJXchQhyNpMw0fuJNg9IlYJc/daxc3e8q1+zL4gd36z1bq1L6d8RTZVqJQnBE2P/VZweyO2VRJjkNRDF6NhAYguUdzsS1967ID7RRWDdW6DmAHDpNmzcdZ3UqR4hctKt/HkNPGrXKZDpvZPlhz1N8v0jJLlKWtkvnBZCQ2rMGspfNR9REUuEpFVKYbw443dc1p1gsjxx2ypsLGgv22nJS4hQtveOSA4op/wQa/d0YCVSVgmAfFTqmqKfxG7Gz4u2T82zP66K4jvoEqDzFY+fVHJFDW+BhAqZ6ReI8dfXKXUVKaWUwmPHysUET/VD8wWecPFT0UgkwFS+fRCQDdEHbRFoVVD68M8sZDYClsOeY06VISmKOPnvpQEXLEjMPLjeYG6O7Y8sERQlX4eizwyrEhVVfVeHQwX9+TRSa5HJxbRyhjh3x6RsU19ZfSfcmGBvoxv4ayL7Re6DrqQ8tya2gc0fzPSu+m8LPIyhyd4wILlwf7geRzG7EYeF8oylDK2Fhw6cy9EZKJ+iGdnWfWM4TUJYptXl7B0+Lq+AZQ9Tc+e3teQkbdngCGjER6u4nWwbA7cgPxgsU3EPmhRB7Dr+VKAPQor39mBfADrNiNzgCE+SU2rTIQjaNeixyFA4zCchMhCfTvZ/3uubb4cDSI1+BE1FUY7J3i+v/9+abXiVGNtgaDwtgFsrhyOjaWtQCG3SGUkmQqA1vvp+zfqZPLUG5jp36VPS8Z+pDzVNTYDMfbJPwPQZd7g12k9HeXiBeW9cx/5aQQ035pFFumj65FoG3Am60oonN3OW/BilxYZDN3H92LsEjJQO9it/e0qa7biBOaA9Yqw03aG9QGB++Z3MZLj0Bn+uEVZLix2AV8kJ1uj0ue5O8wLDNuYJBid0dYFnPXmWpOF+ta55021SGDGDxqbYxZlRcuSQGKWRzS1DiV
 0zeRX/AD
 R5ELM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 3:04=E2=80=AFAM Samiullah Khawaja <skhawaja@google.c=
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
> >
> > 4. New File-Lifecycle-Bound Global State
> > ----------------------------------------
> > A new mechanism for managing global state was proposed, designed to be
> > tied to the lifecycle of the preserved files themselves. This would
> > allow a file owner (e.g., the IOMMU subsystem) to save and retrieve
> > global state that is only relevant when one or more of its FDs are
> > being managed by LUO.
> >
> > The key characteristics of this new mechanism are:
> > The global state is optionally created on the first preserve() call
> > for a given file handler.
> > The state can be updated on subsequent preserve() calls.
> > The state is destroyed when the last corresponding file is unpreserved
> > or finished.
> > The data can be accessed during boot.
> >
> > I am thinking of an API like this.

Sami and I discussed this further, and we agree that the proposed API
will work. We also identified two additional requirements that were
not mentioned in my previous email:

1. Ordered Un-preservation
The un-preservation of file descriptors must also be ordered and must
occur in the reverse order of preservation. For example, if a user
preserves a memfd first and then an iommufd that depends on it, the
iommufd must be un-preserved before the memfd when the session is
closed or the FDs are explicitly un-preserved.

2. New API to Check Preservation Status
A new LUO API will be needed to check if a struct file is already
preserved within a session. This is needed for dependency validation.
The proposed function would look like this:

bool liveupdate_is_file_preserved(struct liveupdate_session *session,
struct file *file);

This will allow the file handler for one FD (e.g., iommufd) to verify
during its preserve() callback that its dependencies (e.g., the
backing memfd) have already been preserved in the same session.

Pasha

