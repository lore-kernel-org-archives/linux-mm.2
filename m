Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7532BCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 17:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41268E000C; Tue,  7 Oct 2025 13:11:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1338E0003; Tue,  7 Oct 2025 13:11:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9108E000C; Tue,  7 Oct 2025 13:11:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 837378E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 13:11:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A8A2140295
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 17:11:12 +0000 (UTC)
X-FDA: 83971958784.26.E1FF944
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 22CF620008
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 17:11:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LW8FtpRi;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759857070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AWRw1t2EiCvmQgNNdpv7LOY6AvNobjsU7Ywi4CTWVS8=;
	b=J18ldm5sKjjocrFUGeFzmollmdwWNfHXSg2Q9hugQ7IST+V6pzXkH96C6rYo2JiTt5wdtx
	aB8wHIr0yl6j/rRC2K1FxzSXdI4dynR3y/5qZXL23JzSk1idmEA2+QcMG469N3RPtfANQY
	uIBZaqkeIQbUS2xtqw/PxH28g/XV7SQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LW8FtpRi;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759857070; a=rsa-sha256;
	cv=none;
	b=lZiCUoteVJRP70T4xbzAiiHK0sNh4HO6NE7u9agYNEoYrMYH3fYuzTJ3BgmU8sNZ3SxbPt
	soB8iXvzM8J20Nek8mhXnMrl6yuUjQUmB2SaTrpSbKjwAESc+hk8NhJ1nkENfQ+Rycu32s
	rCiTpAbO9Vwyc/5jtHetzgexvub7Fww=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4e4f8122660so66941821cf.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 10:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759857069; x=1760461869; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AWRw1t2EiCvmQgNNdpv7LOY6AvNobjsU7Ywi4CTWVS8=;
        b=LW8FtpRip6EnvcoBX8ZaGaOU/B1hOF0uQo/uBPsJjHsokeSdE1Z06Ni5iJyOwLjb+r
         C7QjuPhDXLmwR2g3pJPRUWjeZGcfz7oRcdy6gkmIVRgBggNkR8osqmFgep9CYLyYVPms
         YnFx0KPb0UEXHWOs1qxp5j5zGkz+QXwFxPs7EH3E6rAep8piZfRDRApp5fg33K2WZdqA
         3aqw1DZ52R4wkSC+MFQrVF5MhE45noTPcpfnIKWEtbTy8m0aZHhgU2tXG5E8WuQ0zE0A
         EHxBlvv/EeMmmWPZ00wIvWjPZnWWa2H+CNN/kmH1ca6XnpluHIN+rwycGBBLPYP3NHri
         tuCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759857069; x=1760461869;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AWRw1t2EiCvmQgNNdpv7LOY6AvNobjsU7Ywi4CTWVS8=;
        b=C3W055EAKqJyM1HxFVT9XLVXmCSH3GzlbFzU2k48mZ+6ZoNb25rsplryEPmCPwJOg9
         vClqeTwTxWF0DRIwd2p4Mi6c4GBzxpN9fJCs5VqfLQQa2LOuiISAUx7FlPMqH8QXFLyO
         nzOdeO+otRNBZh/X3o9F8dRVyZbwR4zcId8wUOuqp3lgTS1U+Vn+TcY2ku6i2ZGXqpfh
         AYFL3IZNwnYtNVa7C0IG56y9l4aAhmsZTLJ5oglcLDK9xrZ42BApKjgBrqlQBhCTgJRo
         xBgoCY+uFjYY+UQyoH6lq7DLU2jK3H7W/vqS1r2WMY4psQU3Xnc2wZHUFGZ3dnpGcJ6w
         VITQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+tOYDQ7iYVLmXErL6IspO6lHK3zXYtDMfQvKGLBSE1RefasXqxj93EI6X1Nj//i6YSreQ9vpiLg==@kvack.org
X-Gm-Message-State: AOJu0Yy+6OQdacHocsVNLXt93mYyj82qXTTz3DnE1QPKVwRhPJDgSlK5
	hH7BGBUk7EEYcXfFko2B4kHtVZBqqdYGb9YtaQZuC2w2JuAuZwP3QFxh9GMUC4Y5dmgAjC7w3sm
	KD1OJGeFlahRQGrhl9QHAzGaEJ+jcIVWzSKCaU7Y9wA==
X-Gm-Gg: ASbGnct0UjH0HifqKIq0KRM38VEqEWIOHBEk5pyeEhcxTQj9FbbXvGNY/h+vU+Mxid2
	zV7oTEAwygeEP3GrIpKhEYMzfqxZEmeIdKYZ53Lbd6bg2eT+6qCwW5qXlbr1wfM13xGzcKOt2we
	AiZrxx00tncFhhzIJL3nzL0sYbAFguLAT+T7afWXjHDwocgE/LckydGaCfQeEENMl+q0yJ1tK/F
	Xkg+0L1YlVozMtjdccm7vvxZHpFi+6blC32Ulc=
X-Google-Smtp-Source: AGHT+IHrHNSARo+7sTykBDLK5vp/EH1bjDHDWCDbu2JdzrY3wt5qvUa/q+xa6X664S2uV3zZ9f8Y6nrn0eu81u0SyvY=
X-Received: by 2002:a05:622a:54:b0:4b7:90c0:3156 with SMTP id
 d75a77b69052e-4e6eacb4283mr5037711cf.9.1759857068563; Tue, 07 Oct 2025
 10:11:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 7 Oct 2025 13:10:30 -0400
X-Gm-Features: AS18NWAYCCqTXJEjJ3ZrWQLLuUxvNkwdTkZyTxDoerFJF6t-dA9L3OONGiPCRQA
Message-ID: <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
To: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, pasha.tatashin@soleen.com, rppt@kernel.org, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org, steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 22CF620008
X-Stat-Signature: rqdga8e1jzf3iqhxuwrtxsefu4awpctk
X-Rspam-User: 
X-HE-Tag: 1759857069-836825
X-HE-Meta: U2FsdGVkX19BH0ddVVyKRc/e8S1xLb7ZeT4q8Q5d8WfXy+cWgPYsnSNvFmkrPZ7Firc+INcop71SRq1i6I0lYu9qhZ+EIPCVaEJ+E+jk6By97JP/U1NRiFrIj7qY+3y/x9tTqoikux1LaCp+ckfYamOZYCcrYsnD0W9piCGZATlP07BHkfjs0vZByAge/L/tJeMGCnQJNSM4QOqp73PtEzvE4vleK0iRlW/nW6TX7skZkaNTLeJc/eEQGYm71qrTcA9DiI4pBaTWNyRhZpWPme8y0OAagjOguIq7lJZX37JifLInWY2Lqg52x1cKX2bPQHwWPDZUIRPeCQgUtPkvJIwxqPXUjoiJ/5i50o7reB1OfZoob4sX9vjyUPlgBYk+BNipTjzRyJlvOPAa+h4p9PSR4QNnnc90yeq4RZlj6vE+ffkQr8jWVUAFVAgSxoz4teLPtclYwE8WuWPzEUmMdi0bn88OsWmQkZ1NObGJ1PupaJcRD5yp83PHXyWtibcDatXmKHGM8QdwcT43cMyUcxWZfGOBnJynsL5F6ytcy7xjTHaXVxz241d9/EtD69GKdRTohMOvPzbRZWGO88qb0moXDKGASTaSkA2dXV5Z29T1mrb19WW89atQmCtxx3kV8xIqSklwHtcYPudCR/JMg3x3A2Fgu1KRhJgrraaWYbCbOvJqpN4AeXIEsPCfIRGUhsfuXnryV+bRwQ5bk4j+ARPaOEkKzSNiRZ3gmlGRxwSYU7Z6bMUhclxfo/GY1Skj17u5cWPjz4bVBUTVM/+mYtoeiLrKPqkVw0ezbLnKmDnaEy65QvrdCjo8PvKttMvRBql5V6RbpK0cG85m/XLxdt7tmhFOQL01V4demT2S1iMrLNAuEsn+kiPNU/6gZd4CsISgVWxnbmDOkTBOwMoDc1ikFjHxGiWG+liJSlMIGwu0J8sQ1JhV7xH6eGsIeMpHP0RuOgNbMIYAFdTmmfI
 cGE+qmRW
 VoSMn9N44EwiWN5XDHGjfr0Ix4J5Pk3prjnBL9Dbb27Vi/8hPtRaEiWEtE1LEN/dXXzIKC0ACGMNoBFulrKwIRDYe3nc7E+EXh9insY3dEiu+LVSkYW4Ulh6ov7qcqWLZDBYUV0FmsNgc1ZjLRpdl0JLtXa4qCBoheGCitNzqE9C4mW//o7rzSzC0JQZ24EznvFlYujxZhCd+HIOHcRZpel+3uPbDBK+d6Bg7tPuGDrB8Yau4JlKlxGP5Xk9tUB3/OnnTSqJ4w9hBgVzNVZhYTd/v+O5Y1IjExGbAUyOU/LOObHJ9wOqnxH9Dd+wnKuJJqjikMlcDuuMagm5GwlNK1Cru8VdMswpthQbFnKA92J/LpjflbTsdyeJLgW7KYI9vi3J2b90cd61/8+0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 28, 2025 at 9:03=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> This series introduces the Live Update Orchestrator (LUO), a kernel
> subsystem designed to facilitate live kernel updates. LUO enables
> kexec-based reboots with minimal downtime, a critical capability for
> cloud environments where hypervisors must be updated without disrupting
> running virtual machines. By preserving the state of selected resources,
> such as file descriptors and memory, LUO allows workloads to resume
> seamlessly in the new kernel.
>
> The git branch for this series can be found at:
> https://github.com/googleprodkernel/linux-liveupdate/tree/luo/v4
>
> The patch series applies against linux-next tag: next-20250926
>
> While this series is showed cased using memfd preservation. There are
> works to preserve devices:
> 1. IOMMU: https://lore.kernel.org/all/20250928190624.3735830-16-skhawaja@=
google.com
> 2. PCI: https://lore.kernel.org/all/20250916-luo-pci-v2-0-c494053c3c08@ke=
rnel.org
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Changelog since v3:
> (https://lore.kernel.org/all/20250807014442.3829950-1-pasha.tatashin@sole=
en.com):
>
> - The main architectural change in this version is introduction of
>   "sessions" to manage the lifecycle of preserved file descriptors.
>   In v3, session management was left to a single userspace agent. This
>   approach has been revised to improve robustness. Now, each session is
>   represented by a file descriptor (/dev/liveupdate). The lifecycle of
>   all preserved resources within a session is tied to this FD, ensuring
>   automatic cleanup by the kernel if the controlling userspace agent
>   crashes or exits unexpectedly.
>
> - The first three KHO fixes from the previous series have been merged
>   into Linus' tree.
>
> - Various bug fixes and refactorings, including correcting memory
>   unpreservation logic during a kho_abort() sequence.
>
> - Addressing all comments from reviewers.
>
> - Removing sysfs interface (/sys/kernel/liveupdate/state), the state
>   can now be queried  only via ioctl() API.
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Hi all,

Following up on yesterday's Hypervisor Live Update meeting, we
discussed the requirements for the LUO to track dependencies,
particularly for IOMMU preservation and other stateful file
descriptors. This email summarizes the main design decisions and
outcomes from that discussion.

For context, the notes from the previous meeting can be found here:
https://lore.kernel.org/all/365acb25-4b25-86a2-10b0-1df98703e287@google.com
The notes for yesterday's meeting are not yes available.

The key outcomes are as follows:

1. User-Enforced Ordering
-------------------------
The responsibility for enforcing the correct order of operations will
lie with the userspace agent. If fd_A is a dependency for fd_B,
userspace must ensure that fd_A is preserved before fd_B. This same
ordering must be honored during the restoration phase after the reboot
(fd_A must be restored before fd_B). The kernel preserve the ordering.

2. Serialization in PRESERVE_FD
-------------------------------
To keep the global prepare() phase lightweight and predictable, the
consensus was to shift the heavy serialization work into the
PRESERVE_FD ioctl handler. This means that when userspace requests to
preserve a file, the file handler should perform the bulk of the
state-saving work immediately.

The proposed sequence of operations reflects this shift:

Shutdown Flow:
fd_preserve() (heavy serialization) -> prepare() (lightweight final
checks) -> Suspend VM -> reboot(KEXEC) -> freeze() (lightweight)

Boot & Restore Flow:
fd_restore() (lightweight object creation) -> Resume VM -> Heavy
post-restore IOCTLs (e.g., hardware page table re-creation) ->
finish() (lightweight cleanup)

This decision primarily serves as a guideline for file handler
implementations. For the LUO core, this implies minor API changes,
such as renaming can_preserve() to a more active preserve() and adding
a corresponding unpreserve() callback to be called during
UNPRESERVE_FD.

3. FD Data Query API
--------------------
We identified the need for a kernel API to allow subsystems to query
preserved FD data during the boot process, before userspace has
initiated the restore.

The proposed API would allow a file handler to retrieve a list of all
its preserved FDs, including their session names, tokens, and the
private data payload.

Proposed Data Structure:

struct liveupdate_fd {
        char *session; /* session name */
        u64 token; /* Preserved FD token */
        u64 data; /* Private preserved data */
};

Proposed Function:
liveupdate_fd_data_query(struct liveupdate_file_handler *h,
                         struct liveupdate_fd *fds, long *count);

4. New File-Lifecycle-Bound Global State
----------------------------------------
A new mechanism for managing global state was proposed, designed to be
tied to the lifecycle of the preserved files themselves. This would
allow a file owner (e.g., the IOMMU subsystem) to save and retrieve
global state that is only relevant when one or more of its FDs are
being managed by LUO.

The key characteristics of this new mechanism are:
The global state is optionally created on the first preserve() call
for a given file handler.
The state can be updated on subsequent preserve() calls.
The state is destroyed when the last corresponding file is unpreserved
or finished.
The data can be accessed during boot.

I am thinking of an API like this.

1. Add three more callbacks to liveupdate_file_ops:
/*
 * Optional. Called by LUO during first get global state call.
 * The handler should allocate/KHO preserve its global state object and ret=
urn a
 * pointer to it via 'obj'. It must also provide a u64 handle (e.g., a phys=
ical
 * address of preserved memory) via 'data_handle' that LUO will save.
 * Return: 0 on success.
 */
int (*global_state_create)(struct liveupdate_file_handler *h,
                           void **obj, u64 *data_handle);

/*
 * Optional. Called by LUO in the new kernel
 * before the first access to the global state. The handler receives
 * the preserved u64 data_handle and should use it to reconstruct its
 * global state object, returning a pointer to it via 'obj'.
 * Return: 0 on success.
 */
int (*global_state_restore)(struct liveupdate_file_handler *h,
                            u64 data_handle, void **obj);

/*
 * Optional. Called by LUO after the last
 * file for this handler is unpreserved or finished. The handler
 * must free its global state object and any associated resources.
 */
void (*global_state_destroy)(struct liveupdate_file_handler *h, void *obj);

The get/put global state data:

/* Get and lock the data with file_handler scoped lock */
int liveupdate_fh_global_state_get(struct liveupdate_file_handler *h,
                                   void **obj);

/* Unlock the data */
void liveupdate_fh_global_state_put(struct liveupdate_file_handler *h);

Execution Flow:
1. Outgoing Kernel (First preserve() call):
2. Handler's preserve() is called. It needs the global state, so it calls
   liveupdate_fh_global_state_get(&h, &obj). LUO acquires h->global_state_l=
ock.
   It sees h->global_state_obj is NULL.
   LUO calls h->ops->global_state_create(h, &h->global_state_obj, &handle).
   The handler allocates its state, preserves it with KHO, and returns its =
live
   pointer and a u64 handle.
3. LUO stores the handle internally for later serialization.
4. LUO sets *obj =3D h->global_state_obj and returns 0 with the lock still =
held.
5. The preserve() callback does its work using the obj.
6. It calls liveupdate_fh_global_state_put(h), which releases the lock.

Global PREPARE:
1. LUO iterates handlers. If h->count > 0, it writes the stored data_handle=
 into
   the LUO FDT.

Incoming Kernel (First access):
1. When liveupdate_fh_global_state_get(&h, &obj) is called the first time. =
LUO
   acquires h->global_state_lock.
2. It sees h->global_state_obj is NULL, but it knows it has a preserved u64
   handle from the FDT. LUO calls h->ops->global_state_restore()
3. Reconstructs its state object, and returns the live pointer.
4. LUO sets *obj =3D h->global_state_obj and returns 0 with the lock held.
5. The caller does its work.
6. It calls liveupdate_fh_global_state_put(h) to release the lock.

Last File Cleanup (in unpreserve or finish):
1. LUO decrements h->count to 0.
2. This triggers the cleanup logic.
3. LUO calls h->ops->global_state_destroy(h, h->global_state_obj).
4. The handler frees its memory and resources.
5. LUO sets h->global_state_obj =3D NULL, resetting it for a future live up=
date
   cycle.

Pasha


Pasha

