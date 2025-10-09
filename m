Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AD12CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 22:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936128E0072; Thu,  9 Oct 2025 18:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E6368E0002; Thu,  9 Oct 2025 18:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5088E0072; Thu,  9 Oct 2025 18:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 66B318E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:58:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D1E7160B86
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 22:58:03 +0000 (UTC)
X-FDA: 83980090446.15.D05EA65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 91FFF1C0006
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 22:58:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fsmcUkZG;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760050681; a=rsa-sha256;
	cv=none;
	b=i3IUdLHukzJTZ/UFJnncZa8nzl3Hs14tUCHNY0TO/DJRY+5uO42pqeUaE35w0W1baBYdSY
	lRL8D6T1/+8iWdNrWknLeiXEh17PgzcONt8GA4k+gGrVp/SmeU+93nUZngfe+Tt8NbJCP8
	Q+IiPydrPY6UL6WYpR9fMvkwPisbO/M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fsmcUkZG;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760050681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkSoRWXLCiOf1zQD79CdE7JWEoKvrS8nIAxN07SrUfo=;
	b=o+G+fDZWR+7a33iuHw8YBY0W0DZfwcgUolnxXCflZtKf2Ey4dbqDMEih+KziCVm5xHIYjK
	+SVxrHxMOoTXHKQtu0wo9XngZo9ec1bKnCBlTXjqPn9+CJhQp5kQt6YGRgFq+UFcbpZEd/
	7LvcqvBIplFhDSU+ct2yjkkUW9TWGTg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A91860097;
	Thu,  9 Oct 2025 22:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A298AC4CEF8;
	Thu,  9 Oct 2025 22:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760050680;
	bh=jy9n9D7ZYvmVySH2g9tp3Ckzl9GwzPglDdLRQQiCCGs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=fsmcUkZG+rOzdyBxI+7M0RRHI8iCH0InxqtSmP9yNCDhGt1Bbr4/Jf2pXUvkz4j88
	 UDj2naNsOi0VQHsRuuZ+XVqfnznHDoZklQlLmEsL1ZH+zujftUroGA4CagCopBN4Xz
	 vj1DTaBppGaXMLutBIo9nTWjzscI3qQWSu5T1LRFqzKqosPAtOS1racXWU9cDYO26z
	 zCNFcdY+M8/5R/4MrzEIPk/9YZpX2joKXVX8G1bcNmk+IR5U392qHwGGDcH6PgYjxP
	 +NCkkidu7Ix4EvUC/ZUg3baYkFdaMKgtVHuHpeJMGOFww7i1eR6wjV06LGsYJUWNsK
	 LpFjSmrYG04DQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org,  jasonmiu@google.com,  graf@amazon.com,
  changyuanl@google.com,  rppt@kernel.org,  dmatlack@google.com,
  rientjes@google.com,  corbet@lwn.net,  rdunlap@infradead.org,
  ilpo.jarvinen@linux.intel.com,  kanie@linux.alibaba.com,
  ojeda@kernel.org,  aliceryhl@google.com,  masahiroy@kernel.org,
  akpm@linux-foundation.org,  tj@kernel.org,  yoann.congal@smile.fr,
  mmaurer@google.com,  roman.gushchin@linux.dev,  chenridong@huawei.com,
  axboe@kernel.dk,  mark.rutland@arm.com,  jannh@google.com,
  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  gregkh@linuxfoundation.org,  tglx@linutronix.de,
  mingo@redhat.com,  bp@alien8.de,  dave.hansen@linux.intel.com,
  x86@kernel.org,  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com,
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org,
  steven.sistare@oracle.com
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
In-Reply-To: <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
	(Pasha Tatashin's message of "Tue, 7 Oct 2025 13:10:30 -0400")
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
	<CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
Date: Fri, 10 Oct 2025 00:57:49 +0200
Message-ID: <mafs0ms5zn0nm.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 1pufpp7zh74bb3dioh6whxe9chji3j4m
X-Rspamd-Queue-Id: 91FFF1C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1760050681-873053
X-HE-Meta: U2FsdGVkX18NZNlCD6Q4WQ8U2FrqFrQ9C0zPcaEjN8Ms6GIxUUcvD7pswKXZPG9Nv1/BXIJ8BBM/p2f0dH5UZhWQsB3E2ISpndNasy1/uJpHKOp7YIpJdquaeHktx/KE+7nMLe0g4HDNYv2zLc0lf3XotBJWHXyIqyb8XSy5hcsptLHHIlFZ9BZqXfFA/Zy++IplUP96trgSwGnbYPGhleb7uE7oMEI5wY9VCFIDqG3KMS22pYTRHblE8gzbVDr0YXAgJoiNUWDpvJm8lhRwPtbWsmQZrJ7ZXS10q69vD12eC9gdDzbS+Ph+Rw+QHDu/LYUuGnRNSZqcxl3hGp+hXXe3+lQ6TKbNZOTC+Yj0/9v/jVVylK9dNTuc0T7vNimyxQF1KEZzLcreKoB5+ShVJ5MUcQhwaz/rpWmEyjricEnWtntLmjH0iQySCRyE/uS55UKuzAxWvUs+KHO2AX0njsFVXHY3ORRhPURTwNzDOBMUDWwNizAkDozSr1+ika5SKm8m8/sgr+gt2qjOJWXszHxDvH2Sgjj0EigBDH2q/ZV8bJHRVESLsxTVZhx0vX/xEijZ8lbcl0QTb1Pfcjt2y3ATe8PyqTp10tlA2zSW/LHJCWfWw40COL9tnCGBHRdQ6NMhoxFcj+TFDZmOUPs8vNX73lp96MrqLg6y8BH4dM9gEquGzpuicfb0J7ok3NQNgqhgsEv+z2kenJ15fRZlh71f+xmsBQC1sqckHGDM/LlSZ3/uHBoGSUHNqG4/+L4RkiacxhfCVBRSxdEdRfbapDYCDyT7EEbxbc11odZkXKZ7I20lrI8ZudPUdyPuFq3mRDxK6kydo1aVzriTyQ87nex8bO4flF9BS1IqBUEm7/xxiM8Jl5ReaY6+tA069Raz9+8RID0QLMp9XvXcIO+ykZPDIerNVZcPRv/vXuIXwjRnYn2jqqSJIGb3fBfn7uisc2TjWBGoObvMki/8b1E
 x679cZvZ
 UoEVzlKTkHsxU1yIyVzqxlud2bApvHpIQuEDDU0n2yFE6Ts5V2j69lDOycBkDQi50MxAvkRFIg8kYr+qHMHgrKmr+B/e/3N53fpIh2NLNvEAh360zYjTVVj4O9nzZxR6l5tB+PLIU2etsEylbqViYY2fn7JzJq9iKfKZTBoeiyPK834ZX2Je6ewoWceKNYRgx/rOX5bfqeyEWun6Vn61e30TjcnHdCn58Fw4Z5VDCFLDOlHFMU1IaW+XlPiK6sqPrmOIzx7P2qM8x2vqXHhm6fiwUbpI/Tee+PBZ81FiEsdEVsoMwoP63cKjGBs3HHMzHJHcQa2KIro2LmMgsLckkJ71PoEBJhZFNaZyz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07 2025, Pasha Tatashin wrote:

> On Sun, Sep 28, 2025 at 9:03=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
>>
[...]
> 4. New File-Lifecycle-Bound Global State
> ----------------------------------------
> A new mechanism for managing global state was proposed, designed to be
> tied to the lifecycle of the preserved files themselves. This would
> allow a file owner (e.g., the IOMMU subsystem) to save and retrieve
> global state that is only relevant when one or more of its FDs are
> being managed by LUO.

Is this going to replace LUO subsystems? If yes, then why? The global
state will likely need to have its own lifecycle just like the FDs, and
subsystems are a simple and clean abstraction to control that. I get the
idea of only "activating" a subsystem when one or more of its FDs are
participating in LUO, but we can do that while keeping subsystems
around.

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

IMHO this looks clunky and overcomplicated. Each LUO FD type knows what
its subsystem is. It should talk to it directly. I don't get why we are
adding this intermediate step.

Here is how I imagine the proposed API would compare against subsystems
with hugetlb as an example (hugetlb support is still WIP, so I'm still
not clear on specifics, but this is how I imagine it will work):

- Hugetlb subsystem needs to track its huge page pools and which pages
  are allocated and free. This is its global state. The pools get
  reconstructed after kexec. Post-kexec, the free pages are ready for
  allocation from other "regular" files and the pages used in LUO files
  are reserved.

- Pre-kexec, when a hugetlb FD is preserved, it marks that as preserved
  in hugetlb's global data structure tracking this. This is runtime data
  (say xarray), and _not_ serialized data. Reason being, there are
  likely more FDs to come so no point in wasting time serializing just
  yet.

  This can look something like:

  hugetlb_luo_preserve_folio(folio, ...);

  Nice and simple.

  Compare this with the new proposed API:

  liveupdate_fh_global_state_get(h, &hugetlb_data);
  // This will have update serialized state now.
  hugetlb_luo_preserve_folio(hugetlb_data, folio, ...);
  liveupdate_fh_global_state_put(h);

  We do the same thing but in a very complicated way.

- When the system-wide preserve happens, the hugetlb subsystem gets a
  callback to serialize. It converts its runtime global state to
  serialized state since now it knows no more FDs will be added.

  With the new API, this doesn't need to be done since each FD prepare
  already updates serialized state.

- If there are no hugetlb FDs, then the hugetlb subsystem doesn't put
  anything in LUO. This is same as new API.

- If some hugetlb FDs are not restored after liveupdate and the finish
  event is triggered, the subsystem gets its finish() handler called and
  it can free things up.

  I don't get how that would work with the new API.

My point is, I see subsystems working perfectly fine here and I don't
get how the proposed API is any better.

Am I missing something?

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

The huge page pools are allocated early-ish in boot. On x86, the 1 GiB
pages are allocated from setup_arch(). Other sizes are allocated later
in boot from a subsys_initcall. This is way before the first FD gets
restored, and in 1 GiB case even before LUO gets initialized.

At that point, it would be great if the hugetlb preserved data can be
retrieved. If not, then there needs to at least be some indication that
LUO brings huge pages with it, so that the kernel can trust that it will
be able to successfully get the pages later in boot.

This flow is tricky to implement in the proposed model. With subsystems,
it might just end up working with some early boot tricks to fetch LUO
data.

> 2. It sees h->global_state_obj is NULL, but it knows it has a preserved u=
64
>    handle from the FDT. LUO calls h->ops->global_state_restore()
> 3. Reconstructs its state object, and returns the live pointer.
> 4. LUO sets *obj =3D h->global_state_obj and returns 0 with the lock held.
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

--=20
Regards,
Pratyush Yadav

