Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC2A5CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 11:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E863D80036; Mon, 27 Oct 2025 07:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0FAB8000A; Mon, 27 Oct 2025 07:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0AF80036; Mon, 27 Oct 2025 07:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4E678000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:37:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4ACE058EFB
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:37:58 +0000 (UTC)
X-FDA: 84043695036.07.BB451FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A453180010
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:37:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QPZB8lkX;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761565076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ZRl9oLflvWHs5kO5bw6wYiBk4wzNJtdVpiC8Ni43hE=;
	b=AkiTR3HCvIF2s5vZla4lkLtfOKMgMscIOHedZ4Fu0pC9nLiR1XaTeBvGeC0shmFxl4g56D
	9YqNcdGIBfI1mrgZm0pw1MCh6JuljlySZxxXJSuk6WpERdBPCguz6MU+9lvTylbvIQpKFc
	L+EKinVRMtpNStKpQeloa5RvOcUg7zA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761565076; a=rsa-sha256;
	cv=none;
	b=Wllgo/QhPXSfjYcHTz4f/zJc6UN0wXE0zqBwE2fCzHkeE3eAXnlO9q08HlEPrFy6IggNXK
	yQm3mTxyG5Tqhyv1SzqUP3oZZrV6H9j7YCypSz92wlBt8hmCY7ZFsW5/oe5Cae9y7uyZ+0
	DYdKdmQtml1jVTfVmqkafozKeloi5Hk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QPZB8lkX;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3011E457AA;
	Mon, 27 Oct 2025 11:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC65DC4CEFF;
	Mon, 27 Oct 2025 11:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761565075;
	bh=qEFSBVn7tvYChgqBuSbB762Baav+81SepQq/Uf98LX4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=QPZB8lkXka1OfqOTgreoj/P2Lg1hhWZXmp0ATPFjOUcqNjUMSysHbPqTyyVoyY21G
	 pIPzTIEX+qR7+KzqRNGZ6cuJXse0MlchxX/qiRN2MqZYCiQY5t5V0OXONi9DqK3SSz
	 K3AyPumi09jDGxYjIm9az3m97OE5uWSLyHisKPIPa2hli7eY0f5ffKsNYg1fH9rG2p
	 Mc/tUYgYA3hAo/ShlSZseCveHX6OpCES8EJxQWqW8eVPC+0G+rGD1UU4DqFc705ygd
	 p9jQBRWFkJa9wCUdyjyZpLmnuP/QTLnJSuAhyKVtHkBPYhC5plFZDMfv/br3uPs/P3
	 MSRt9bNkz34ig==
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
  leonro@nvidia.com,  witu@nvidia.com,  hughd@google.com,
  skhawaja@google.com,  chrisl@kernel.org,  steven.sistare@oracle.com
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
In-Reply-To: <20251020142924.GS316284@nvidia.com> (Jason Gunthorpe's message
	of "Mon, 20 Oct 2025 11:29:24 -0300")
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
	<CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
	<mafs0ms5zn0nm.fsf@kernel.org>
	<CA+CK2bB6F634HCw_N5z9E5r_LpbGJrucuFb_5fL4da5_W99e4Q@mail.gmail.com>
	<20251010150116.GC3901471@nvidia.com> <mafs0bjm9lig8.fsf@kernel.org>
	<20251020142924.GS316284@nvidia.com>
Date: Mon, 27 Oct 2025 12:37:44 +0100
Message-ID: <mafs0y0owd187.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Stat-Signature: 6kn117dbecdzbh9xcx1nd6czxgu4kztg
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A453180010
X-HE-Tag: 1761565076-615581
X-HE-Meta: U2FsdGVkX19K+9fGQdRPiD4VD9dyFPeAqSRrK4DLrnWB4YCRIWK1kLtTFiW5QWIKcG8N4eyuX2BoXoD6FV5XE3RSdkU7wny23+pTx6o4qFZ6Be7PHOM60OTg0ooBDkDWIOFBbd55Q5r6QIaHxkmI0ISi9W/CHXxx5LqEayyzwkEdarI6UzKr22fC6Enll4UJztREfeJoCiQGxdeaGicPWSiSOrMHVJX6jXQwnKpT71QMS7g1aC/vBNmVezogof0rNHGq9v+jUm5MkjK34Ls3LDbG2gNKODnGX05s2C64TO41SahIBPdsUmMSAu8ZnSV1yVqG30UdDRDZ/J6YO5qhO4TRaVQCuY9mb6KWouAHDgM5LwYkmULEfAr6+VlY6W+m451MnzMJ20/rzQ0sko11Cr8L5TNJB7jWaT/6GnLn68sKDkgnlc7nE9ATG8+HGtN+6BUH3XTJ0VwJi/Bau24rSw0qayfh4j10/aNDdNeL41zuKsaWuUqpalXVRNJrIMtYnBCaci6dh9tEHYWHUdSFquSh1WM0J252lZTqF0zXtmsCTR+LXmIVVbXhsBufiEIUe/1DUeY/SsDOW4pwNoz5++yVQ2PkQfZaihZ+xxm5x+nasYNyoYOeyQtywdqaG6d8Gz3wmH/zAStgDCSP2CW9wFAqRzTXG69RLBhAuEQyK+UE1pN8vK+x+fcP6J5I5BBHs7X2VE1bT3kA3BqiQb0vitoY5uD0VbMHCmbT7mDDsBdGQFvsuMrddfk+LZP6SPQFV6cFa/ZGLMhirhyHyVEhpNA4kXXPt1r/4UYXLvR9t1lc+CimUHP6qvMtJnhMJYuFKws0Lf1VjHE5shZjCBj6LZq0SVFqyWGLDZj2kEciCSMhk9HrwgbSDMIKj8DUdMET3KaSiBw2Euu+23WxwIghNgMIvvWAtPmn/RcA48wy48OgOhPc9SADl2PblvHrEj8sj737GWYBvkd7O1dkygB
 n7uoYT2p
 oWz0snUQbsgBTXcVVDvAIhwdz4wQtFs/xxNN4PR0fi1o/7wdw6qs1dCnvXjzcv0OPDKD2SDm3RA9XRC0BqENNJeUGwptz8d/jjk03NBjJNwmJLbW74F5v9MwT+juAwFpc8zmYLpfslWGgIf/NjhH18+IzQM82S3Ce5Se893dWhHDpXqvJ7TyIPyb2T+yQz2BeuRJRkZ4gM5SPAlaFgR8HjPV+dwCI0CO7g9lDpfbkj0ptu1o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20 2025, Jason Gunthorpe wrote:

> On Tue, Oct 14, 2025 at 03:29:59PM +0200, Pratyush Yadav wrote:
>> > 1) Use a vmalloc and store a list of the PFNs in the pool. Pool becomes
>> >    frozen, can't add/remove PFNs.
>> 
>> Doesn't that circumvent LUO's state machine? The idea with the state
>> machine was to have clear points in time when the system goes into the
>> "limited capacity"/"frozen" state, which is the LIVEUPDATE_PREPARE
>> event. 
>
> I wouldn't get too invested in the FSM, it is there but it doesn't
> mean every luo client has to be focused on it.

Having each subsystem have its own state machine sounds like a bad idea
to me. It can get tricky to manage both for us and our users.

>
>> With what you propose, the first FD being preserved implicitly
>> triggers the prepare event. Same thing for unprepare/cancel operations.
>
> Yes, this is easy to write and simple to manage.
>
>> I am wondering if it is better to do it the other way round: prepare all
>> files first, and then prepare the hugetlb subsystem at
>> LIVEUPDATE_PREPARE event. At that point it already knows which pages to
>> mark preserved so the serialization can be done in one go.
>
> I think this would be slower and more complex?
>
>> > 2) Require the users of hugetlb memory, like memfd, to
>> >    preserve/restore the folios they are using (using their hugetlb order)
>> > 3) Just before kexec run over the PFN list and mark a bit if the folio
>> >    was preserved by KHO or not. Make sure everything gets KHO
>> >    preserved.
>> 
>> "just before kexec" would need a callback from LUO. I suppose a
>> subsystem is the place for that callback. I wrote my email under the
>> (wrong) impression that we were replacing subsystems.
>
> The file descriptors path should have luo client ops that have all
> the required callbacks. This is probably an existing op.
>
>> That makes me wonder: how is the subsystem-level callback supposed to
>> access the global data? I suppose it can use the liveupdate_file_handler
>> directly, but it is kind of strange since technically the subsystem and
>> file handler are two different entities.
>
> If we need such things we would need a way to link these together, but
> I'm wonder if we really don't..
>
>> Also as Pasha mentioned, 1G pages for guest_memfd will use hugetlb, and
>> I'm not sure how that would map with this shared global data. memfd and
>> guest_memfd will likely have different liveupdate_file_handler but would
>> share data from the same subsystem. Maybe that's a problem to solve for
>> later...
>
> On preserve memfd should call into hugetlb to activate it as a hugetlb
> page provider and preserve it too.

From what I understand, the main problem you want to solve is that the
life cycle of the global data should be tied to the file descriptors.
And since everything should have a FD anyway, can't we directly tie the
subsystems to file handlers? The subsystem gets a "preserve" callback
when the first FD that uses it gets preserved. It gets a "unpreserve"
callback when the last FD goes away. And the rest of the state machine
like prepare, cancel, etc. stay the same.

I think this gives us a clean abstraction that has LUO-managed lifetime.

It also works with the guest_memfd and memfd case since both can have
hugetlb as their underlying subsystem. For example,

static const struct liveupdate_file_ops memfd_luo_file_ops = {
	.preserve = memfd_luo_preserve,
	.unpreserve = memfd_luo_unpreserve,
	[...]
	.subsystem = &luo_hugetlb_subsys,
};

And then luo_{un,}preserve_file() can keep a refcount for the subsystem
and preserve or unpreserve the subsystem as needed. LUO can manage the
locking for these callbacks too.

-- 
Regards,
Pratyush Yadav

