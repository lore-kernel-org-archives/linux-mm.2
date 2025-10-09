Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C74CCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 21:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18FCA8E0035; Thu,  9 Oct 2025 17:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167B68E0002; Thu,  9 Oct 2025 17:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D2C8E0035; Thu,  9 Oct 2025 17:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E64348E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:58:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E05D5C673
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:58:28 +0000 (UTC)
X-FDA: 83979940296.10.8AC6451
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 92CBC18000C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:58:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kMiWkdI4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760047106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Da9rq64jSCHe6oeiNyGExW4qkL69hMLkeHxNHZmMDYA=;
	b=Bjrl3YwUErcXfLmNnVMoDFOrOIfit9KULyVfxrNI2YHdMiGt4UGF0w2mMdSDaVyMmFX9PY
	fNd2/jwezCFdrRyLB0HR8ilz4Bbg4Hm7bJHnfTXfUEUBQYFKIO6DbqhqKwbGzx3JK14SNj
	W+qXi9WONBWJFH3aFBDuRXOGIBKSd2I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760047106; a=rsa-sha256;
	cv=none;
	b=VSBanguayzzK4WrG7g9a6WGFYzYmL2CQO7kGbKr99v6grdYN32s3RlHKmob3Srip2gnWrq
	qDFdSkb9w2+ZHRBDxbFHB0y0R+TNUM/lERszJyC7KT7q1UJHMgRskP9HVUGUH5fIzzATMy
	H1TRutby9q6R6Q8Z8mjADo0+ca5Tb+Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kMiWkdI4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=skhawaja@google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4de66881569so166421cf.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 14:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760047106; x=1760651906; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Da9rq64jSCHe6oeiNyGExW4qkL69hMLkeHxNHZmMDYA=;
        b=kMiWkdI4vq7uPvTfvfIRNbQXXDPZM+XUfSw81ZcTLlAhYdU/008kxSHgzeeiWgnI6R
         c8Nt27X+5dKEPNMVh4zMfXBEWv+Af/dFcLioWu/quhxO/o88dFCwXWsvZSKMosgaE0GC
         t7SprqzdLhndu/oEwCUMzwOWGA12TVY55p6rnD7vvbKESFhIddgPzNpn77Pu13k72WmB
         MsGG3wCbARQtDT0WjLCHTi2tsyhUcK+FxLNgOBCaACmQpqnBTuRCC8l3IcyqQqN9Jubl
         QSiwmt0dl7M+YmBejg+7+n21VZwkd9ASwmIPtnlhJgxJn2N7dUYnMF9vi2OIE5iLToct
         XCzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760047106; x=1760651906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Da9rq64jSCHe6oeiNyGExW4qkL69hMLkeHxNHZmMDYA=;
        b=LPfsF3NJJQfaQo6pi9VuxLO3XYLWuIGzsepZYzm2R5rffsqhQI5W1Tcj01ExY7cLW0
         eqO9oGLv20KVE72PzdOATiJ5LGJhAA9X+yuGLB4tB0YqFoCTZsASK/d6fWtWEIL0cr5d
         hu2pvzFtGblZf9GNWooUsskTjPQevBv7LdMCCq3aCMOCt5Nc1NW5FyLMmANVMz06C3rl
         qZNm/jwkvr07/MiJ1yWi8x5vGjqQA4Pivn4VZrqa7fnGcoOYvXEz25aaqv2F3fMMrBaB
         pkCDz82ZYTe+X0L3JvTkwPGHHWqUr1a7yAKkAcutNFizO0kkCYFnIa8fdj/FSdvHA12M
         MQ1A==
X-Forwarded-Encrypted: i=1; AJvYcCXxbzvRxVDTjEqhlg6sQMYtrDtHkIHafwFeTZ06826szTmCKPRiVlzSkRq1WiWs9QlPOWHimpc9ag==@kvack.org
X-Gm-Message-State: AOJu0YzXpxb1QE0+7ZDjwNpUn9M5yov4QRLrEo5AK6P3CdJEoz8+p+i+
	PU+FeTCUWoBXLWWd7zeZHs0EEf6MYpv6sa89DFjG9fqB7AQTEqlUNlqEyYEs7sFmjjETUvRzS2T
	Chg3OBxK26T64G+z2NY4uO+on8/kWd8hVWtJXAA6C
X-Gm-Gg: ASbGncsfns2FwVOw9+KESBI5uaiVcQbf7nJf80wtxwlX6djUPaO8bh1qcWOS7tEZ10C
	ZHseTKhDzbCd9Uj57TA7ARUQE2hkSjdk6QoTS7EkbRJT9a1Sx1EuT4YsYy1L0E2ZLE+5r3nePu7
	hzvSvcRRHiBKSa8L3bj5CHKoQZiX23jZrO9vQ4A1TeSBNbnO146myY+/w5L5QuYjgOov3YwPjoC
	/6mDtzDWNKXfb77aVYzsGBERryRXeEN215tz613rJuBkr28MtuTDOcbg2/Zh/R4JMHYoY8=
X-Google-Smtp-Source: AGHT+IHtQMqTo8BIFpnJE01TPxuNwy3HFiU5S+TL2cS82bKmRJ04q7RTWP2H9LIooNmOn6Icee0DawB7J8B4tkpHZn4=
X-Received: by 2002:ac8:5acb:0:b0:4b7:9e3a:3804 with SMTP id
 d75a77b69052e-4e6eac3e03dmr19019021cf.16.1760047104907; Thu, 09 Oct 2025
 14:58:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com> <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
In-Reply-To: <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Thu, 9 Oct 2025 14:58:12 -0700
X-Gm-Features: AS18NWAFRVYpxwTRWQpBNTJ0w8vW0qyc8VT4GzWQLZMUeNsIeMEBFK1d54E05pE
Message-ID: <CAAywjhT_9vV-V+BBs1_=QqhCGQqHo89qWy7r5zW1ej51yHPGJA@mail.gmail.com>
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
X-Rspamd-Queue-Id: 92CBC18000C
X-Rspamd-Server: rspam02
X-Stat-Signature: i4ir16n9stenbfxy5hbqyxqj3u3ssp1m
X-HE-Tag: 1760047106-177513
X-HE-Meta: U2FsdGVkX18RadZM6SHAOmIIj5l+w4sP9XMTZqEThx/isgUPxX3zvjDKkEhOBce+fRZrGQTTghs/y0ZHJWOwE9d7gVzQ9vvNdZtMxE8hOs6ugurSyhsuNydkE8vkQFgHtHIyvCJzy0KpEh2Gbee08Bd1NPot9R0HCatT5JzM1rjAv7MfIwaap5n0JL+wkPwAH48AxE7dgUD14Ejo6Nc0zJvi1l7JkrBkx3y1GanReHluvx7SGjWP4/KC2V5Qd+Y0Q7iQNOPwkBAx60a0zVtbzqN9xC3QTB5Pn4+kG7XSKBK/iG2lFWBcLm/XZjVVFNhIvCFu0YvYdlEwLDWWx9TvJhBZDMTFTUe/ewykC4ifjvwJ2/z1w5Yu4+SNOhE+PSzWbZ/OkdzgMt/HwCQ2DRVCemLdDeOoON4Dj4IncDLS62clyCwI2AAbmU3ST34wW+u+W5Mnt3QH/rfXGJjMzUbbWr/smsQnxexFIPG8MoYSnwxVaCCk2W46HJpunFZQiAmDTO5Q43uFpJn1MTpBuNkR8AGWliIQ6ir5U69oGTXlYmrIV9donsZbScOvFkC25SLflWYpUqpX+jNH7MN6s876Gq+MOy9jnvOc1lhD4HQp1gjFsh2YJx57PZRAqkdBDZKUnQpQJoqjhrwwcBd1TDqHOPixWAPywgsEgaw/A/BqAFhfjs7EMAkViZkloAn0x1Q5Dnogj1flzlkbWTDMg4S0gaftwBh3NDb5uYqmQnlhPN4M0ZtUe6uhDXLk0mAbsBisL/3LM7nvr+RwYUkGFIdbvwXKWEHdPEOlupFUVGaQKQPeMJdirYYZ+E3husWPAtvjJhO0ebP/boZgctrtqiwF9WrVMyvqiikWWKzkOwxtVlVCwMAg3SldJ4+c0O3d20WMjCuZ+io70UvXaLy62CGftzkps1G+sUxG86qMKRmSabMy6pKzvMfGJZHWDaQdL73EgiXRZvazftKvgjJi9qM
 DzjqB3xh
 VjnSFsDCR675jtICzMl1Op8UDYeehEctaDF+7ZaCfblzb5HmPvmbY9Ebr2OCID1DVhntpDygxptTa8Vnu+XiDChlwitYKxFjkwUXh2yU8tDUHdHG49XR754l9N6cv+d/K0oSVee5/6c47oSlf/zBoG8tQRl7xtRUew5F8oERubYut4nOfhsbqA0ZiikeTeun+V5bH3wDmCvwIdSTeVqY7ET0uKT3xJXWIxSPI8Jk9CnQ4veWAZwn5GGi1BD9BdUFbXVSl8y8zMU8BuZM2sEVYeLYkCj5lZbQyO6AnZGW8wvTHW2nOJu8b1eS2HKkkL7qpx3S23WiJkhieJeznVVXbf/iaf2TcUEbhcA45xiswo+h7JG0kipqE+zy6mWTXy6KVytBTN3MMo7cy7/E=
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

Now that you are adding the "File-Lifecycle-Bound Global State", I was
wondering if this session data query mechanism is still necessary. It
seems that any preserved state a file handler needs to restore during
boot could be fetched using the Global data support instead. For
example, I don't think session information will be needed to restore
iommu domains during boot (iommu init), but even if some other file
handler needs it then it can keep this info in global data. I
discussed this briefly with Pasha today, but wanted to raise it here
as well.
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

