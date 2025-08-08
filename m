Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6324EC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 13:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4F396B007B; Fri,  8 Aug 2025 09:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C4E6B0089; Fri,  8 Aug 2025 09:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3D186B0092; Fri,  8 Aug 2025 09:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A424E6B007B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:52:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4FA711D449B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:52:48 +0000 (UTC)
X-FDA: 83753730816.09.13313A9
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf28.hostedemail.com (Postfix) with ESMTP id 70427C0012
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:52:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="V0GyU/0x";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754661166; a=rsa-sha256;
	cv=none;
	b=sTvlkmJkUG17/pfpcGXDA+SFrHjQqLziaCYR4m48e6GOMYkKlqyOyc9+GEvsoNGNzdEKk4
	7E5DswOuWlGHCFz7x5p8Q2KGe4o0NZXOsoppH7OeGRrTl0XJ2y6PZhDIBaW5DH9uoUGhuT
	VABNBwc1U2luc3iDh9Oxn/phLe8WZ9o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="V0GyU/0x";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754661166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eWuSm/n+x6UmSbenhuChDI181POgLouqBLmIRKho6Y8=;
	b=XX3cp/r3cP1be5Yqq2mkaymvJ6Cf2e1qim3lX42HkXl6kiMsyDKZ/3OkZV5FltDvIIK4qH
	57eSjhoTi5BlzmFEpwIqpYYpfUZLUf8lRKXJ2v8GVwAPSECt8dxAEizRSO/dS0pYsJufDq
	rcGQ3pq9aV00S0dOTJ3yhJ11+InJgGE=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b0770954faso34770161cf.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 06:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754661165; x=1755265965; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eWuSm/n+x6UmSbenhuChDI181POgLouqBLmIRKho6Y8=;
        b=V0GyU/0xAnGxP/dxDNHHuStImYslj/RnlnbLPCs0RMqdD10/3WPnFkN6OExBrT2jYr
         /8ijFKnYZpPHIej4hRM9wGsHTF3b3OROYMOK06iNH/Soen0sk8n1uTtyNIsTS1kyvqV0
         +ly4Q+BaXqepJzyPz+H48/Ec5ZKjmW71ReZTgv8U/7hibfnWjxMw9dBFmj9oh/rwiImr
         pVYuugIqwy6iilOIS2EBf7s28COjcD5+BYpuMyn+lMYlL9aNiA67CLYUdFXlvN8sK6Ng
         AKiZIMT1G9VCwgzho2F1UCYDb2sneAkqZaSf9QW/QdWuzOc197G2D/vtuDSfIQHxBMqW
         nrCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754661165; x=1755265965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eWuSm/n+x6UmSbenhuChDI181POgLouqBLmIRKho6Y8=;
        b=L7hg3+7/pwuDn54I+M10stErFBHsVED2P6CJ6CoujDKuKa7LWJPx/A6FeqynxeP9tI
         ItoCVb2bjccNd6m8bmp5zzpbzKGCM4hpqWzr836r+N2trM/XdQkiYMtOTDUNpC13G9nm
         CnoOn4jkpV26rSFMQ5z0MTQUuXEq41VaTU0EBxpntPBVVK4dQYVUzruyyk+neBb6vN1a
         LxBCtDFgtIzUZfsVASgC9Peom+lcgRXEvSlyQ4H0k694AMAwfFEU+D7xACdywbjB0ytq
         nAwdGbFnkA9MZhuCAx4oF2osnnscaUVbo0HMlUDu8H3rKEMCfwsxnSO8FMr25k2UjN1g
         bsTg==
X-Forwarded-Encrypted: i=1; AJvYcCUYk/pR5YK5GaPMbvuH4z7+w2KXdl5hJA/qMO3ZcFEWNDybSwXVvNr06LvIizhZfJ9VleZrfTFoKQ==@kvack.org
X-Gm-Message-State: AOJu0YxfEg77tDwhyWt3oyXHI8MZEfqb4Lf9VViGEisFa8YKf2Zu9ebc
	CXbi841HP7N4/iQtfyltMlsKDilJhGCm0lSsG13AeWF6nGrhKtQMXNzzTFxRqFDYWFbx1uz7Rz+
	ns1CpE1dNNLBclIYPhEBmPvQ9fcC4i0w9zdDSo8i3Jw==
X-Gm-Gg: ASbGncuwY9q9dKVPlidtvRqjVHUBSw2F/Z51G1egTQMrjEM7rx1S9YDDUNCKE+vFcDs
	Xe1xkZKRvPpMYMxmh22iCvPny0hEOc/vJGELdmpGKFJbXdL66HFXr4Pwj69fnLZElSSpYCklP+h
	GvR37rU33QH4wK10DjkHwhUGvLLAdqg8iuX6zYID5jtP2S6Rb6gyN6RhXu5/mJqedAV/tMaUJvS
	ptk
X-Google-Smtp-Source: AGHT+IHO5jWq2R+C8O5R0Fm2lL7gLcJpGW7g9n82qYxS65FLgaiPl7bc5Ibupu3yaSPySLQfW9SenpAn90221JpxA8E=
X-Received: by 2002:ac8:7d89:0:b0:4b0:8092:9918 with SMTP id
 d75a77b69052e-4b0aec614dfmr42016261cf.1.1754661165053; Fri, 08 Aug 2025
 06:52:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com> <b227482a-31ec-4c92-a856-bd19f72217b7@redhat.com>
In-Reply-To: <b227482a-31ec-4c92-a856-bd19f72217b7@redhat.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 8 Aug 2025 13:52:08 +0000
X-Gm-Features: Ac12FXyoXpYy06IoMQTlfI4PNRF-wgM5UcLDQBO-MIGYnp5DILElI_szjslsn1M
Message-ID: <CA+CK2bCUXszEadZeBvmjJSEPH2NMi_KZA9o3Nvc6WiMBBE=Hfw@mail.gmail.com>
Subject: Re: [PATCH v3 00/30] Live Update Orchestrator
To: David Hildenbrand <david@redhat.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, joel.granados@kernel.org, 
	rostedt@goodmis.org, anna.schumaker@oracle.com, song@kernel.org, 
	zhangguopeng@kylinos.cn, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 70427C0012
X-Stat-Signature: fxoxzqmx6oc6yrqk4wwh3i4dfsg4p9fn
X-Rspam-User: 
X-HE-Tag: 1754661166-973358
X-HE-Meta: U2FsdGVkX19CtZ09PhXyqrZOsQXieAAYXzrO7UTLwPUKGXM5R8s4CZ458rgGfULAgJjZcdd1pEhT2N0juJSAHQyB9qAC0r2kwm6KT51tvZb0hOlsAOpYR/3H29XdtglDU97IZQhOYoUj8wFNn3xD0wq32jwUaipFiByo5HgKHZ/0UxC/tJ+z2w78HIDh9MoJeMFm7xNCC0TmzUpPHz86nraKmASebWKYsUXt24WVAw0SlUmEizJd/+xQNxuL3sqyaalgipaq4wKbxPphjC3eLgDnh2ctTRGA4HpiNApU1k7E8ojKUcBk+8NFsnPcCL7Cd7ZBwTs0ZMyijS7tKu0Nn5jbWCT/3E9OA4uLM81xR46hXe+Zh2SHTHhTAJD9wSpDvNitaKwV8gGEwraYs/okij5XCxTp1myXiU0ZfZPgJAo2TJsNe3rCcLwjsyccvIeHE/dTdfBwSuA//A2Im1kA+crY9zN4koMOyKaWeBbrzgJOlAAbZmkbEoinYT1IMCIv1GtkXwuwhI0/t6UgXWSq7V54kn7cxjFlaxMq/5aDZc40lQEIEPUBzDFiog4dizXKbiRzn5mLfTFXkGbG8CeVa1tzZFZJKp4tmcMZiTodlSy3sGRd8mmCfAEH5j/TMcn3PrYECt/iOipLrtgB9wkrKmGVQS2WMqla5/HuF5HoA85IsbIQxgoQ1XXY22+PTDYJy2+MOevbre3/ZZFROf0MIJai0JoRyPz80ypeJ3+8kieleMb+LtmBq0Ksj+0CEChnIV5OsVyulQjapRsuqKwA3uKWDwFE6uOHUg8rLcYXWfY8ibouwq/Az4OG15jYZtPjluw3bTsLTVa+PSe+Wy8p4cK7F/IQsduCELZeOyeCEgN5yqY5XUNPk6g82lLj6aHkyV2tKxoAXOZEUtmBIn+7/A2VEpb4idR10eVc6/SI1sPu7dBKYP0gh7554dm1byZ4PNHl/3wkG1CYw7F4pub
 5EV5LRO8
 X6ufXJv3SHY6yGZS44cy56Ailr1fyrgRZmNtLbqFQrFMC+jhnO6QaQ9hrOx4mejwFElL59HRyVHe46Jqb8MeOmBY2lKuR5PnKa6kOyyzXsOm69SCROMQc1pld+gVsk6TbkNRctLLukh+4WcaNWyus67FEOjMwIXbWrrvLOITxGO3vBTUEOy46vT/SfQhlkfZh0rhK3b07xd9nvfEopyiA1QA4DbEvE42x6Ls1OPNpr72cxq4zFXbNgUk7l2ZZBpCqIvsbSK/PVpTcMIa04g0orrdWCRK3Ed83K4/9bUokI5xje5+lWF2WbydGTJFXNuKLLzwV9ah3cTwDjnb5P1TPpgZsTAHcYcppdGTk7ZeNCjuvGyaumbb22cxeI9HQKZU6OqH2rTeIJ48exXoJ0o0unYoXofhOxWM701Yf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 12:07=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 07.08.25 03:44, Pasha Tatashin wrote:
> > This series introduces the LUO, a kernel subsystem designed to
> > facilitate live kernel updates with minimal downtime,
> > particularly in cloud delplyoments aiming to update without fully
> > disrupting running virtual machines.
> >
> > This series builds upon KHO framework by adding programmatic
> > control over KHO's lifecycle and leveraging KHO for persisting LUO's
> > own metadata across the kexec boundary. The git branch for this series
> > can be found at:
> >
> > https://github.com/googleprodkernel/linux-liveupdate/tree/luo/v3
> >
> > Changelog from v2:
> > - Addressed comments from Mike Rapoport and Jason Gunthorpe
> > - Only one user agent (LiveupdateD) can open /dev/liveupdate
> > - Release all preserved resources if /dev/liveupdate closes
> >    before reboot.
> > - With the above changes, sessions are not needed, and should be
> >    maintained by the user-agent itself, so removed support for
> >    sessions.
> > - Added support for changing per-FD state (i.e. some FDs can be
> >    prepared or finished before the global transition.
> > - All IOCTLs now follow iommufd/fwctl extendable design.
> > - Replaced locks with guards
> > - Added a callback for registered subsystems to be notified
> >    during boot: ops->boot().
> > - Removed args from callbacks, instead use container_of() to
> >    carry context specific data (see luo_selftests.c for example).
> > - removed patches for luolib, they are going to be introduced in
> >    a separate repository.
> >
> > What is Live Update?
> > Live Update is a kexec based reboot process where selected kernel
> > resources (memory, file descriptors, and eventually devices) are kept
> > operational or their state preserved across a kernel transition. For
> > certain resources, DMA and interrupt activity might continue with
> > minimal interruption during the kernel reboot.
> >
> > LUO provides a framework for coordinating live updates. It features:
> > State Machine: Manages the live update process through states:
> > NORMAL, PREPARED, FROZEN, UPDATED.
> >
> > KHO Integration:
> >
> > LUO programmatically drives KHO's finalization and abort sequences.
> > KHO's debugfs interface is now optional configured via
> > CONFIG_KEXEC_HANDOVER_DEBUG.
> >
> > LUO preserves its own metadata via KHO's kho_add_subtree and
> > kho_preserve_phys() mechanisms.
> >
> > Subsystem Participation: A callback API liveupdate_register_subsystem()
> > allows kernel subsystems (e.g., KVM, IOMMU, VFIO, PCI) to register
> > handlers for LUO events (PREPARE, FREEZE, FINISH, CANCEL) and persist a
> > u64 payload via the LUO FDT.
> >
> > File Descriptor Preservation: Infrastructure
> > liveupdate_register_filesystem, luo_register_file, luo_retrieve_file to
> > allow specific types of file descriptors (e.g., memfd, vfio) to be
> > preserved and restored.
> >
> > Handlers for specific file types can be registered to manage their
> > preservation and restoration, storing a u64 payload in the LUO FDT.
> >
> > User-space Interface:
> >
> > ioctl (/dev/liveupdate): The primary control interface for
> > triggering LUO state transitions (prepare, freeze, finish, cancel)
> > and managing the preservation/restoration of file descriptors.
> > Access requires CAP_SYS_ADMIN.
> >
> > sysfs (/sys/kernel/liveupdate/state): A read-only interface for
> > monitoring the current LUO state. This allows userspace services to
> > track progress and coordinate actions.
> >
> > Selftests: Includes kernel-side hooks and userspace selftests to
> > verify core LUO functionality, particularly subsystem registration and
> > basic state transitions.
> >
> > LUO State Machine and Events:
> >
> > NORMAL:   Default operational state.
> > PREPARED: Initial preparation complete after LIVEUPDATE_PREPARE
> >            event. Subsystems have saved initial state.
> > FROZEN:   Final "blackout window" state after LIVEUPDATE_FREEZE
> >            event, just before kexec. Workloads must be suspended.
> > UPDATED:  Next kernel has booted via live update. Awaiting restoration
> >            and LIVEUPDATE_FINISH.
> >
> > Events:
> > LIVEUPDATE_PREPARE: Prepare for reboot, serialize state.
> > LIVEUPDATE_FREEZE:  Final opportunity to save state before kexec.
> > LIVEUPDATE_FINISH:  Post-reboot cleanup in the next kernel.
> > LIVEUPDATE_CANCEL:  Abort prepare or freeze, revert changes.
> >
> > v2: https://lore.kernel.org/all/20250723144649.1696299-1-pasha.tatashin=
@soleen.com
> > v1: https://lore.kernel.org/all/20250625231838.1897085-1-pasha.tatashin=
@soleen.com
> > RFC v2: https://lore.kernel.org/all/20250515182322.117840-1-pasha.tatas=
hin@soleen.com
> > RFC v1: https://lore.kernel.org/all/20250320024011.2995837-1-pasha.tata=
shin@soleen.com
> >
> > Changyuan Lyu (1):
> >    kho: add interfaces to unpreserve folios and physical memory ranges
> >
> > Mike Rapoport (Microsoft) (1):
> >    kho: drop notifiers
> >
> > Pasha Tatashin (23):
> >    kho: init new_physxa->phys_bits to fix lockdep
> >    kho: mm: Don't allow deferred struct page with KHO
> >    kho: warn if KHO is disabled due to an error
> >    kho: allow to drive kho from within kernel
> >    kho: make debugfs interface optional
> >    kho: don't unpreserve memory during abort
> >    liveupdate: kho: move to kernel/liveupdate
> >    liveupdate: luo_core: luo_ioctl: Live Update Orchestrator
> >    liveupdate: luo_core: integrate with KHO
> >    liveupdate: luo_subsystems: add subsystem registration
> >    liveupdate: luo_subsystems: implement subsystem callbacks
> >    liveupdate: luo_files: add infrastructure for FDs
> >    liveupdate: luo_files: implement file systems callbacks
> >    liveupdate: luo_ioctl: add userpsace interface
> >    liveupdate: luo_files: luo_ioctl: Unregister all FDs on device close
> >    liveupdate: luo_files: luo_ioctl: Add ioctls for per-file state
> >      management
> >    liveupdate: luo_sysfs: add sysfs state monitoring
> >    reboot: call liveupdate_reboot() before kexec
> >    kho: move kho debugfs directory to liveupdate
> >    liveupdate: add selftests for subsystems un/registration
> >    selftests/liveupdate: add subsystem/state tests
> >    docs: add luo documentation
> >    MAINTAINERS: add liveupdate entry
> >
> > Pratyush Yadav (5):
> >    mm: shmem: use SHMEM_F_* flags instead of VM_* flags
> >    mm: shmem: allow freezing inode mapping
> >    mm: shmem: export some functions to internal.h
> >    luo: allow preserving memfd
> >    docs: add documentation for memfd preservation via LUO
>
> It's not clear from the description why these mm shmem changes are
> buried in this patch set. It's not even described above in the patch
> description.

Hi David,

Yes, I should update the cover letter to include memfd preservation work.

> I suggest sending that part out separately, so Hugh actually spots this.
> (is he even CC'ed?)

+cc hughd@google.com

While MM list is CCed, you are right, I have not specifically CCed
shmem maintainers. This will be fixed in the next revision.

Thank you,
Pasha

