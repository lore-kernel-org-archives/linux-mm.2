Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DE08CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668248E0011; Thu,  4 Sep 2025 08:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618B78E0001; Thu,  4 Sep 2025 08:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5071C8E0011; Thu,  4 Sep 2025 08:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FACA8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:57:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9A8C139D95
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:57:47 +0000 (UTC)
X-FDA: 83851569774.08.44A1CB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 45C6940014
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:57:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="q/ZCDfPq";
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756990666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzf/m8ko3ijlZ+LHksZAU2oV5/eMvkUr7pl2PYATJ9I=;
	b=tL7VsbAO0xnyFb3rGLPlD3gV4tFnEAFgQTlgk/8oijKCMtng3rn5+XC9xdHXjN5Jt18cE0
	ftgWpmKgNcBkenlarVuIB93afcUyjRuylHLEpup/p0ZwHyoFUwosioSDWYtIf6OqLi9i0r
	Y41/4QMhhlJ4/v700SBCl3x3oa4zH7Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="q/ZCDfPq";
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756990666; a=rsa-sha256;
	cv=none;
	b=WvF4IujXCRVvqMrfx0l4ryzGySh+lz2GdZGveyI/SlGSHOk0IwsbzqNAZxMv18NHSAsYCT
	nddUqzFCR070VcAk0/qNBF5Yb6oUTgDOwemr8MbuGk2iI6ru9idckeZB6Q1ZJhEqaod3dd
	vzXnCaXV5qFwwhbm5BBeVuqgZdsh3/Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C102E60212;
	Thu,  4 Sep 2025 12:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7899EC4CEF0;
	Thu,  4 Sep 2025 12:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756990665;
	bh=8/eVc7vWpyZYNyruSsCDjRKKy2KGqc1y07Wo5xHNUoc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=q/ZCDfPqOqseYnoW+PN2j4RogP9bF1M8oDdqg8PP0CGt03j4Lh+rzTi6HbJEgR/SJ
	 qq+195iNezWVcaURhPRCSEaCMf2a+ALMFkXVC96ZUuB1ijXXH8ODxEiubGtrz7mm3k
	 t6MWOz6/eUDrfHP9eAvw+JJNKnkfGUVXh/ja/3MiZvt0mQmzSjFPWjEIUmYOl+4BYA
	 bFr4zNcjyt+tc5A13LqwsBaHU7gKI1yWNt3SF5QsxMHpfuwgr2faUnIpRxyJ6EIaBj
	 kWSvOU//5+ETFo6VuyYvjCfx2UQOhyMBV28IsLrJmWmI9Yt5mBOQws0jA7pW/u3o6y
	 pUcDm6M1eiVaA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  jasonmiu@google.com,  graf@amazon.com,
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
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  parav@nvidia.com,
  leonro@nvidia.com,  witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
In-Reply-To: <20250903150157.GH470103@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<20250826162019.GD2130239@nvidia.com> <mafs0bjo0yffo.fsf@kernel.org>
	<20250828124320.GB7333@nvidia.com> <mafs0h5xmw12a.fsf@kernel.org>
	<20250902134846.GN186519@nvidia.com> <mafs0v7lzvd7m.fsf@kernel.org>
	<20250903150157.GH470103@nvidia.com>
Date: Thu, 04 Sep 2025 14:57:35 +0200
Message-ID: <mafs0a53av0hs.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: qnjh49zxe1ngrzs7fh3re4rx34jct7na
X-Rspam-User: 
X-Rspamd-Queue-Id: 45C6940014
X-Rspamd-Server: rspam01
X-HE-Tag: 1756990666-657435
X-HE-Meta: U2FsdGVkX1/672+Yw823TP3WxSb4BO7Vzf78Wk9BD6/ZuuCmPB+4utGtablWQ/SGUhotxd5t+z0MO0hi5DKmmc3ySC94OMIo4kw4/R/ZFH1nPMnZYdtQye0tg4cU7JC8tquB+z0xSJtgpgQKaSuhuqLxcaFNugv4qv0DJ/+WGKL0Ig/iozwBHd6DG0QpPGKlW6043sFv8jnr6z0za12yQ9dKEj8iiV7NlMoeKgtmNyCyv8Zs/yJnZrU1T+5CjDVrTMR1kz3vlUEj8CdByWKZXMcbTbV0+fgpadJeLg5zE4+hNvpAqR00S5Dl6qA679/l9fQgc+OpHAcKK5L4QWzsQSc3m8AXiS68BnppuP0netFwf901sUHDcO8WgHkokTkUD0ttxnhPQra57P7Wzzzh7oeLzGxivBeReKAlTC2NcV9y7DPGPzqH7KdFpllW9wzozOsHdEeW70U/mMYKPO6J0CQxDuV/0Jnkb24a7lGugDAIeYX1XSApKqHMAshysbS4rb1q1TBYmXHQq8uPNJc01jxGuP7U0uzWjAnSEF0NOFU9/KYG0bDntYjmRyEUOXAVNnm7JDBvOJNQwEasPV2er9AxE4/PKtT1gImYDRR/risK8kjQ82dy0dzx9Vmh8RZRAqhgtM5tRt39foT4GbC2ebP9VMFCtayufJhFu4OnLb2xPK3mrmgChqPj2/CjU4G8T1KXEHybExtJbfsEqRg2bKeLs41SMchU86F9ETxg0QP5HAXu+Jmi2JHcJeeongwyOLw5N66rp9YLGQDVH/FI0/AU4Ryxkw3gk0AgH3CMiqv9DO3GJXNDT1nrg5vTdFPMntEr9Hw0k4hNWZaaXy7alCDqkz2Kq2sxmiSPurQPSBB2dXhNey0u9TpEvXbviREv1+FPf49CSx1lexpQnpoSjUwTT+AbBBTtKtIvRBxOCvRfrt4LkBM8XYUm0daIYvc/0sTJd5stnlqNx8Me9BC
 STIR/Hjy
 o/jhjm23A4JAXje0Pl8F1EASbqoxmBBFkBmoLceyfroBurF/fhf3ttfupnaIbT+RfD5unteAaQkUOb5Z1IKHJ6wfmBWzXURRCvnxxwPQnLEYb3HhENtJdwb0zn/tc8mYe+p4Eq2OtBaJqcvhnxWCaJ6efXSpIgJYpPYpOwOHiFOhaHg/rNQ2cqJ8e4OzRk/OcXl+UMF9X8zzqHvTa1S/dnP0CFDpeZl4gA4+/ExyAwXcpTHA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

On Wed, Sep 03 2025, Jason Gunthorpe wrote:

> On Wed, Sep 03, 2025 at 04:10:37PM +0200, Pratyush Yadav wrote:
>
>> > So, it could be useful, but I wouldn't use it for memfd, the vmalloc
>> > approach is better and we shouldn't optimize for sparsness which
>> > should never happen.
>> 
>> I disagree. I think we are re-inventing the same data format with minor
>> variations. I think we should define extensible fundamental data formats
>> first, and then use those as the building blocks for the rest of our
>> serialization logic.
>
> page, vmalloc, slab seem to me to be the fundamental units of memory
> management in linux, so they should get KHO support.
>
> If you want to preserve a known-sized array you use vmalloc and then
> write out the per-list items. If it is a dictionary/sparse array then
> you write an index with each item too. This is all trivial and doesn't
> really need more abstraction in of itself, IMHO.

We will use up double the space for tracking metadata, but maybe that is
fine until we start seeing bigger memfds in real workloads.

>
>> cases can then build on top of it. For example, the preservation bitmaps
>> can get rid of their linked list logic and just use KHO array to hold
>> and retrieve its bitmaps. It will make the serialization simpler.
>
> I don't think the bitmaps should, the serialization here is very
> special because it is not actually preserved, it just exists for the
> time while the new kernel runs in scratch and is insta freed once the
> allocators start up.

I don't think it matters if they are preserved or not. The serialization
and deserialization is independent of that. You can very well create a
KHO array that you don't KHO-preserve. On next boot, you can still use
it, you just have to be careful of doing it while scratch-only. Same as
we do now.

>
>> I also don't get why you think sparseness "should never happen". For
>> memfd for example, you say in one of your other emails that "And again
>> in real systems we expect memfd to be fully populated too." Which
>> systems and use cases do you have in mind? Why do you think people won't
>> want a sparse memfd?
>
> memfd should principally be used to back VM memory, and I expect VM
> memory to be fully populated. Why would it be sparse?

For the _hypervisor_ live update case, sure. Though even there, I have a
feeling we will start seeing userspace components on the hypervisor use
memfd for stashing some of their state. Pasha has already mentioned they
have a use case for a memfd that is not VM memory.

But hypervisor live upadte isn't the only use case for LUO. We are
looking at enabling state preservation for "normal" userspace
applications. Think big storage nodes with memory in order of TiB. Those
can use a memfd to back their caches so on a kernel upgrade the caches
don't have to be re-fetched. Sparseness is to be expected for such use
cases.

>
>> All in all, I think KHO array is going to prove useful and will make
>> serialization for subsystems easier. I think sparseness will also prove
>> useful but it is not a hill I want to die on. I am fine with starting
>> with a non-sparse array if people really insist. But I do think we
>> should go with KHO array as a base instead of re-inventing the linked
>> list of pages again and again.
>
> The two main advantages I see to the kho array design vs vmalloc is
> that it should be a bit faster as it doesn't establish a vmap, and it
> handles unknown size lists much better.
>
> Are these important considerations? IDK.
>
> As I said to Chris, I think we should see more examples of what we
> actually need before assuming any certain datastructure is the best
> choice.
>
> So I'd stick to simpler open coded things and go back and improve them
> than start out building the wrong shared data structure.
>
> How about have at least three luo clients that show meaningful benefit
> before proposing something beyond the fundamental page, vmalloc, slab
> things?

I think the fundamentals themselves get some benefit. But anyway, since
I have done most of the work on this feature anyway, I will do the rest
and send the patches out. Then you can have a look and if you're still
not convinced, I am fine shelving it for now to revisit later when a
stronger case can be made.

>
>> What do you mean by "data per version"? I think there should be only one
>> version of the serialized object. Multiple versions of the same thing
>> will get ugly real quick.
>
> If you want to support backwards/forwards compatability then you
> probably should support multiple versions as well. Otherwise it
> could become quite hard to make downgrades..

Hmm, forward can work regardless since a newer kernel should speak older
formats too, but for backwards it makes sense to have an older version.

But perhaps it might be a better idea to come up with a mechanism for
the kernel to discover which formats the "next" kernel speaks so it can
for one decide whether it can do the live update at all, and for another
which formats it should use. Maybe we give a way for luod to choose
formats, and give it the responsibility for doing these checks?

>
> Ideally I'd want to remove the upstream code for obsolete versions
> fairly quickly so I'd imagine kernels will want to generate both
> versions during the transition period and then eventually newer
> kernels will only accept the new version.
>
> I've argued before that the extended matrix of any kernel version to
> any other kernel version should lie with the distro/CSP making the
> kernel fork. They know what their upgrade sequence will be so they can
> manage any missing versions to make it work.
>
> Upstream should do like v6.1 to v6.2 only or something similarly well
> constrained. I think this is a reasonable trade off to get subsystem
> maintainers to even accept this stuff at all.
[...]

-- 
Regards,
Pratyush Yadav

