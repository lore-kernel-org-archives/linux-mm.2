Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 282EDCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 14:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F41D8E0006; Wed,  3 Sep 2025 10:10:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4648E0001; Wed,  3 Sep 2025 10:10:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693678E0006; Wed,  3 Sep 2025 10:10:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 529628E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:10:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E56B111A8B1
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:10:50 +0000 (UTC)
X-FDA: 83848125060.28.D5613F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D13E54001A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:10:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R+S1d8QQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756908649; a=rsa-sha256;
	cv=none;
	b=FeFCbaYSpGJsQ/3xeni3doeCvDMEkRY/Sy3d4tEVkH1GMp3iOxGF0/bAaa+QbyqcyAPvQ0
	5DNdbwN2RMjHRsVNV10UccQXKJqUxPZ7d/P+iLjX6bg0Ms6UVzwnZgV1fiCISstjuUGoiv
	RBhlQqZLl2LiWkqIXVIZgTIL8/1EWu8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R+S1d8QQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756908649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7c5/ktBzfgu/03qJBBWfT2XatxT0yWHvf/btVTllzB8=;
	b=pewcYmzOR1QQDcLo/Rmbpvr6/0NWiWmQqhF9VD95Rn3lNw/BHbopq6Xf0ruuXh6VqevnpW
	607GtZ3X+2U2fPLFIgb9O0EYYPy09FHpX56OTpLc0YMJ3VVsqqx1blwAYZuwLHDVHDVcCz
	wsz1j6QVDWoJFO6CD92HzmEki0/j40U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 541A244076;
	Wed,  3 Sep 2025 14:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4255EC4CEE7;
	Wed,  3 Sep 2025 14:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756908647;
	bh=IJP0VbHKnRlpLO/dj+/Ia2ILTC5O+iulYtBS4Wmtc7Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=R+S1d8QQ8JTOfieL00HXOZ34YoFUz7OL6PI6NmTox55mOQ5P2beuQkiHTw89xKvw3
	 insOk7uKvWRNaeS2vTdE9Ht/CnQJzkKF7GSUV/9EH30J6MBbhwocfVgD71iA7LqCnt
	 zqGDip6cF961mvzPUx6VluNXvCkxwekBrmumpiQS1Wblng3j0PvIFUjnebzWKb0g7R
	 V4bkzKiUCPcrAIysTs2EMlCHah6rOsjnKvu10SpEX2QyWrKKe+3tUV7u4ej/phtqKG
	 dYcayDouOvM9hUHm/g775ZgYpyBRWvfvMV7HVpKIckFauorE4h/2sjZVbRh4vbTHER
	 6qYwmLFOmThTw==
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
In-Reply-To: <20250902134846.GN186519@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<20250826162019.GD2130239@nvidia.com> <mafs0bjo0yffo.fsf@kernel.org>
	<20250828124320.GB7333@nvidia.com> <mafs0h5xmw12a.fsf@kernel.org>
	<20250902134846.GN186519@nvidia.com>
Date: Wed, 03 Sep 2025 16:10:37 +0200
Message-ID: <mafs0v7lzvd7m.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: D13E54001A
X-Stat-Signature: 15zibd1dqjijn43rh9cfex6n5xbu3gc9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756908648-862590
X-HE-Meta: U2FsdGVkX1936XBAdnznaYH5pPlEbP+k9s6UWLTNkAH2g2PftEHqdOA3IdzOMZ+cHyJrllGlYRJHEzcMBzwUhwoZ7XH5h5lCrARxN71053cepXOp7YFjp34SexKVJnlFlD0tEf024joEA3+3ZpVomQfNpkhypS3WiCZaR2jR1Ol9oVleoCtk3L4XJXo57/Zv/A1YhdNe0YzD276faZ85Qf3RVOpL4UBIw1KCPddDhuXnb3NekviX4g2MVVI2shVQPFp9aFM9mHCAFAwWZrBlZV0FsoCHju3PRsv2Zz/XjctvJynxJKxdDrPEfmUjF12tMe9U6dyypaH9gm+NBXfpQYKO0eptE3KD/yYzznLfWUqT5P0YsotU9fwVRfZiVWmQGa+hoUzUBibskivPT/AEhFB8KMw5u6kceIBzxNy/B8cQ2+qpLMxdXP43YmOcztcj+haTShsf3tya4hxlxy03EW1FgPEbsKA/HmGlrHAIthL+0u/NoTPUkZqVBoYVe5cnpLrGBlBDojyB5g+JiVMBmk6/sQa1xyzdCSgvLkcw5d/irzLH63NZzSj1QB6MMmslmrQ6SAEx5amqmgc3XhbzB0s8GVO5Hzpn91TPwaSKWppk7wGRfQ/2XwG3TakqO/M+/67j4YTee5/X1XnFSNzRGlsj2f5hZx+9mC1I8aJ+wOUD+dx0sH9CJo6h1NGRopWkj2clKDw/yeoA5iF3zWgfS9DS87frQkXnzKIkGlO3HMjhmK8VkBmkbZ3c8hCJKxjt2egtf2FYUcUTMz7uVo6rfT2EF8o7SnLDOF1a5/qyWEaacfCYuTdMzfWZna/HiDq3+HRbJeh3Z8j9MxELHf8mQc6+LJwLJ/JLB0PHfpN1q9S7UI+K46nP4azlQZXeXTYo4ikQRJRth7oDg5H/VOmYRFCqSnDIKXb/C75Q0y0ddQot3NSX49lPQRthN3iS8wu4OupFesTtdKoXGedjKCe
 92zB/fW4
 X4E9FUrMKLnXM7XCPfem6/H7GpOPp5LMPYChFLtyfbypTt6KuJip/RqI5NZoK80psayNq3uBdZ6McetiwhydKfn34cspde0nRxUJ4Hd7d7R9s0TkA65yXA/K2+S/AwaV46opPlVi6i5Sq1ciOChsnmsk0VQrRidv+fDJ+r7LEWMhGSpplTVVR+rIDqQwFgyFdLmBTssCgicF8lFpymqV1N38EVlHC23yfbZsCVy8HabbEnolIacpXUljzRrczo3ammLVT0mV/BVJ1pQQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

On Tue, Sep 02 2025, Jason Gunthorpe wrote:

> On Mon, Sep 01, 2025 at 07:10:53PM +0200, Pratyush Yadav wrote:
>> Building kvalloc on top of this becomes trivial.
>> 
>> [0] https://git.kernel.org/pub/scm/linux/kernel/git/pratyush/linux.git/commit/?h=kho-array&id=cf4c04c1e9ac854e3297018ad6dada17c54a59af
>
> This isn't really an array, it is a non-seekable serialization of
> key/values with some optimization for consecutive keys. IMHO it is

Sure, an array is not the best name for the thing. Call it whatever,
maybe a "sparse collection of pointers". But I hope you get the idea.

> most useful if you don't know the size of the thing you want to
> serialize in advance since it has a nice dynamic append.
>
> But if you do know the size, I think it makes more sense just to do a
> preserving vmalloc and write out a linear array..

I think there are two separate parts here. One is the data format and
the other is the data builder.

The format itself is quite simple. It is a linked list of discontiguous
pages that holds a set of pointers. We use that idea already for the
preserved pages bitmap. Mike's vmalloc preservation patches also use the
same idea, just with a small variation.

The builder part (ka_iter in my patches) is an abstraction on top to
build the data structure. I designed it with the nice dynamic append
property since it seemed like a nice and convenient design, but we can
have it define the size statically as well. The underlying data format
won't change.

>
> So, it could be useful, but I wouldn't use it for memfd, the vmalloc
> approach is better and we shouldn't optimize for sparsness which
> should never happen.

I disagree. I think we are re-inventing the same data format with minor
variations. I think we should define extensible fundamental data formats
first, and then use those as the building blocks for the rest of our
serialization logic.

I think KHO array does exactly that. It provides the fundamental
serialization for a collection of pointers, and other serialization use
cases can then build on top of it. For example, the preservation bitmaps
can get rid of their linked list logic and just use KHO array to hold
and retrieve its bitmaps. It will make the serialization simpler.
Similar argument for vmalloc preservation.

I also don't get why you think sparseness "should never happen". For
memfd for example, you say in one of your other emails that "And again
in real systems we expect memfd to be fully populated too." Which
systems and use cases do you have in mind? Why do you think people won't
want a sparse memfd?

And finally, from a data format perspective, the sparseness only adds a
small bit of complexity (the startpos for each kho_array_page).
Everything else is practically the same as a continuous array.

All in all, I think KHO array is going to prove useful and will make
serialization for subsystems easier. I think sparseness will also prove
useful but it is not a hill I want to die on. I am fine with starting
with a non-sparse array if people really insist. But I do think we
should go with KHO array as a base instead of re-inventing the linked
list of pages again and again.

>
>> > The versioning should be first class, not hidden away as some emergent
>> > property of registering multiple serializers or something like that.
>> 
>> That makes sense. How about some simple changes to the LUO interfaces to
>> make the version more prominent:
>> 
>> 	int (*prepare)(struct liveupdate_file_handler *handler,
>> 		       struct file *file, u64 *data, char **compatible);
>
> Yeah, something more integrated with the ops is better.
>
> You could list the supported versions in the ops itself
>
>   const char **supported_deserialize_versions;
>
> And let the luo framework find the right versions.
>
> But for prepare I would expect an inbetween object:
>
> 	int (*prepare)(struct liveupdate_file_handler *handler,
> 	    	       struct luo_object *obj, struct file *file);
>
> And then you'd do function calls on 'obj' to store 'data' per version.

What do you mean by "data per version"? I think there should be only one
version of the serialized object. Multiple versions of the same thing
will get ugly real quick.

Other than that, I think this could work well. I am guessing luo_object
stores the version and gives us a way to query it on the other side. I
think if we are letting LUO manage supported versions, it should be
richer than just a list of strings. I think it should include a ops
structure for deserializing each version. That would encapsulate the
versioning more cleanly.

-- 
Regards,
Pratyush Yadav

