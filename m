Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C7DCCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1F6E8E011F; Tue, 14 Oct 2025 09:30:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF68A8E0112; Tue, 14 Oct 2025 09:30:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D33C68E011F; Tue, 14 Oct 2025 09:30:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C12548E0112
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:30:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70775160927
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:30:13 +0000 (UTC)
X-FDA: 83996803506.03.B36FEAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C377820019
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:30:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PrHy1FFo;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760448611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZerkQV5UIJ4ffC2QtBnHTnul1Sc2wRzT8K0kq7qCVgY=;
	b=2B6/wzj5Ldfhm+ZaAjqyA9BTDsggiOKQlI+RlGGy8EVQ+j8NbsJo5MuptTzA4Qn4ky9aUs
	hs5mALlYmQolACEV+sDr+kZ/3xMvdxIbBJ1jLRhlA/G5EEMZW6pfgu8+wlPPq/yspxyuPv
	ETNrXVMdAu+cCiY+nHAPaqk5FcoJNj8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PrHy1FFo;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760448611; a=rsa-sha256;
	cv=none;
	b=WYawHY6ccPysIcaQwzEzKlsSGO+6yqV6uZd6++vsvc9p8JNQlwk7hWsz97OwRRFSX1rzeD
	d/0BruwPoCIZ5+tLgF2S+mP0h9IH/gqPUJhlTwKkGOHYg5OzGwWXRqvwQiGgmIHlG9IrE+
	e9dtu7xJzsIoBsQKRXBdNaW3LczWqF0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 034AB621A1;
	Tue, 14 Oct 2025 13:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209F8C4CEE7;
	Tue, 14 Oct 2025 13:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760448610;
	bh=pNGGyokr8X1AGHFovWK/YwKzLd8yndY2pnPSWQjmLOc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=PrHy1FFo4vOfHgRLP+LZxJrAoiX0f1g6DosVRTkP9hjElSUeRaA1tnwNqdrN1/RNP
	 rCuPe2GcHw/uA62lAVv0LwUqtXVfO7y3Up7IQSsZx/pLSHidaEipXsgJjA1IZHwSqn
	 s8QOxS1YJoYZ3lS0VWUn7NwuKt5v8TOZj1lw2aS3xYIW4tR08HJwTRshi33ijbW6rv
	 tT4cyA2lKl2ikFIA7gNlVVRNFodqD6voRaOl6ej6ozxGTWFejcm0r+Kb5AoO25TOpS
	 XxnNKMs2DTqMC5RnCxyzWLAWoiuTW8vU56PRAIXGlxUrTlsgqJWZpGrHjjtlr6l8hK
	 ix4SyXG6XtlNw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  jasonmiu@google.com,  graf@amazon.com,
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
In-Reply-To: <20251010150116.GC3901471@nvidia.com> (Jason Gunthorpe's message
	of "Fri, 10 Oct 2025 12:01:16 -0300")
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
	<CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
	<mafs0ms5zn0nm.fsf@kernel.org>
	<CA+CK2bB6F634HCw_N5z9E5r_LpbGJrucuFb_5fL4da5_W99e4Q@mail.gmail.com>
	<20251010150116.GC3901471@nvidia.com>
Date: Tue, 14 Oct 2025 15:29:59 +0200
Message-ID: <mafs0bjm9lig8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C377820019
X-Stat-Signature: n9mgibbqdg7r5nrri8gf41axsej4ohog
X-Rspam-User: 
X-HE-Tag: 1760448611-939256
X-HE-Meta: U2FsdGVkX1++5THhHXddpvLunDr0pbFV7uu97AJ1WMHSmJcXWz1+/+h5Q4IB+Dpfe7CYT0jTd72+fu5SDKueX7QkquRC7G0bmZVrcIbA6nSemBYnqtPJ0z38cwUq1gIsajTUT1X0W3TQKQAZO2nI2vu05UlVd+RVhhCb9VEeab6q15u3kcKfPhgqj8PDxniN8WljVtbklxFkKZWx2Z4qXJtzvToZhMsw8LRDaTy71mXSj/cMNYh9jhP1a433QfwhgxIUY4rhjcDKfASpRZ5sgECH+FixOOcpATPy2Xu6AddMCmCogkLset7oTZmFgk720Bnnb3WAhZZPOERACCzEZVkmXs+G1cjrS4Pjl91vRluet2GvUZR7rm+lERDLQ/w+Go/XJiOo4IQq3s7eRmMFwomgItTXhc0qH3FA31q+OALtNaPgWB+uxLyjCQDPI6ZSqgFs+sazJynJ1teBOlOqx+0L+bauCoCHEOXMj0eFaCGAZddYo9drseN6lBctl/OoppORK07g3mFtN3TVNHBJaztlbfCVwvIoZLHqd+IZ0kN2Y7DKn9NZP8rxh2go4XA6iXcDOUfPHi6aJUa7qhjnYxFPP9K6IyW9LHSCFEVtC8F4O+CPo9JeNLcpH3NokRtUgc0UlpP7p0SptbN3dG6B4w9PuiWBcK6yiXitTXh30dSqe5cqN92DIsRiAGpljZvLrRl2/YwJLK+D/PECmalL2UoTEh5cWq8Y2TZ4ss9xpKm8sqI//bBoGdX2XBa6fY9b8xxuL30YQQf6CH/8ChBnDxNzMGXGoj8ON9QrLdIleQs0bNoUFrRjIybIRViMnSTV6YFFuhgCa5WsELeBk7d+a3nzF9YNn8HqBfIHengqcllDLqPkW7BpC/8f9O5wzDruHYy5TjLcki3PfzCc15TgrJwPq4JaIvqzfy8v4PjqL8t1xG/LFIC7d7i1uzHCl/sJjndNtXQAGxhuZQlegFu
 yDDdNlYr
 rPRs8GhZP3mElAnFWCwoYDZG5MV6TSZP1A4OvarrLrVH+80L4cGtYIwKjaMZUcRVlTo/mws8P0Bngs0i4jWlST+vpkQCGDetgiY2ZxzcDz0QdosIxU0K2WjuK8wA1OV7D1ld/BoZFe81ntgB9NCJ69Un+oU4c9pE+jW+vK1z5eAcpT52HrbD685cmhlMvREhVn5eXW5C1+Y82uQTFIL4YZKvNEYZ4PPJ0ETNWg8lBD82qq1Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10 2025, Jason Gunthorpe wrote:

> On Thu, Oct 09, 2025 at 07:50:12PM -0400, Pasha Tatashin wrote:
>> >   This can look something like:
>> >
>> >   hugetlb_luo_preserve_folio(folio, ...);
>> >
>> >   Nice and simple.
>> >
>> >   Compare this with the new proposed API:
>> >
>> >   liveupdate_fh_global_state_get(h, &hugetlb_data);
>> >   // This will have update serialized state now.
>> >   hugetlb_luo_preserve_folio(hugetlb_data, folio, ...);
>> >   liveupdate_fh_global_state_put(h);
>> >
>> >   We do the same thing but in a very complicated way.
>> >
>> > - When the system-wide preserve happens, the hugetlb subsystem gets a
>> >   callback to serialize. It converts its runtime global state to
>> >   serialized state since now it knows no more FDs will be added.
>> >
>> >   With the new API, this doesn't need to be done since each FD prepare
>> >   already updates serialized state.
>> >
>> > - If there are no hugetlb FDs, then the hugetlb subsystem doesn't put
>> >   anything in LUO. This is same as new API.
>> >
>> > - If some hugetlb FDs are not restored after liveupdate and the finish
>> >   event is triggered, the subsystem gets its finish() handler called and
>> >   it can free things up.
>> >
>> >   I don't get how that would work with the new API.
>> 
>> The new API isn't more complicated; It codifies the common pattern of
>> "create on first use, destroy on last use" into a reusable helper,
>> saving each file handler from having to reinvent the same reference
>> counting and locking scheme. But, as you point out, subsystems provide
>> more control, specifically they handle full creation/free instead of
>> relying on file-handlers for that.
>
> I'd say hugetlb *should* be doing the more complicated thing. We
> should not have global static data for luo floating around the kernel,
> this is too easily abused in bad ways.

Not sure how much difference this makes in practice, but I get your
point.

>
> The above "complicated" sequence forces the caller to have a fd
> session handle, and "hides" the global state inside luo so the
> subsystem can't just randomly reach into it whenever it likes.
>
> This is a deliberate and violent way to force clean coding practices
> and good layering.
>
> Not sure why hugetlb pools would need another xarray??

Not sure myself either. I used it to demonstrate my point of having
runtime state and serialized state separate from each other.

>
> 1) Use a vmalloc and store a list of the PFNs in the pool. Pool becomes
>    frozen, can't add/remove PFNs.

Doesn't that circumvent LUO's state machine? The idea with the state
machine was to have clear points in time when the system goes into the
"limited capacity"/"frozen" state, which is the LIVEUPDATE_PREPARE
event. With what you propose, the first FD being preserved implicitly
triggers the prepare event. Same thing for unprepare/cancel operations.

I am wondering if it is better to do it the other way round: prepare all
files first, and then prepare the hugetlb subsystem at
LIVEUPDATE_PREPARE event. At that point it already knows which pages to
mark preserved so the serialization can be done in one go.

> 2) Require the users of hugetlb memory, like memfd, to
>    preserve/restore the folios they are using (using their hugetlb order)
> 3) Just before kexec run over the PFN list and mark a bit if the folio
>    was preserved by KHO or not. Make sure everything gets KHO
>    preserved.

"just before kexec" would need a callback from LUO. I suppose a
subsystem is the place for that callback. I wrote my email under the
(wrong) impression that we were replacing subsystems.

That makes me wonder: how is the subsystem-level callback supposed to
access the global data? I suppose it can use the liveupdate_file_handler
directly, but it is kind of strange since technically the subsystem and
file handler are two different entities.

Also as Pasha mentioned, 1G pages for guest_memfd will use hugetlb, and
I'm not sure how that would map with this shared global data. memfd and
guest_memfd will likely have different liveupdate_file_handler but would
share data from the same subsystem. Maybe that's a problem to solve for
later...

>
> Restore puts the PFNs that were not preserved directly in the free
> pool, the end user of the folio like the memfd restores and eventually
> normally frees the other folios.

Yeah, on the restore side this idea works fine I think.

>
> It is simple and fits nicely into the infrastructure here, where the
> first time you trigger a global state it does the pfn list and
> freezing, and the lifecycle and locking for this operation is directly
> managed by luo.
>
> The memfd, when it knows it has hugetlb folios inside it, would
> trigger this.
>
> Jason

-- 
Regards,
Pratyush Yadav

