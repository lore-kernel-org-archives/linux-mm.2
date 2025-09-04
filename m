Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED501CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552A66B000E; Thu,  4 Sep 2025 08:39:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52A216B0011; Thu,  4 Sep 2025 08:39:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467486B0012; Thu,  4 Sep 2025 08:39:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3827E6B000E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:39:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7B2911890B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:39:26 +0000 (UTC)
X-FDA: 83851523532.15.5EBD854
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 538F11C000E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:39:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9MOrYmH;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756989565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jg0hJ3sn+RKPEiu5Cfl6ZhOa/1LbrjyyZVJdQD+RjrA=;
	b=bhDcJx9Kt8CWIyXxvXC4UwQ4j7WcG5srDqr7FR7YbcRIFl5tCKo3FzMhDgSdcu7vMCLtN4
	t1123VQJ0gsbFV5ckUBiZPeYb3/Bq9CSA4weG0ujRo1YayyeEczkyoeatb62LxCz/iyFoe
	ixeKa+jY2upvnOdNBsxmbXyeZtGmoNQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9MOrYmH;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756989565; a=rsa-sha256;
	cv=none;
	b=M8dPg3T/zmkXXN3V1bzPh5+OPEdwnhNK6VTb7+aAydxIixZzwJNiT5khoMN6jUPHKAnQHO
	zLhdyzQDm+41SImSGFfNbzxbWFlb64M6IVr0cZkjJAmsWLE+KIROJEW3D9Buy1nzulbQMm
	rqrLkxkW5iRJx+I7+Eah30MmT5BfAH0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 045FE60283;
	Thu,  4 Sep 2025 12:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E171AC4CEF1;
	Thu,  4 Sep 2025 12:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756989563;
	bh=/dOXK4oy7iAhoUGr2MmfjWE8hXk9Y8tyleU9g8YasAc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=i9MOrYmHgSH7Y+7qHtX1Byvl1ufAKEXc1Ej/VzGCte2ENcbxl6Mjs/y7IuxfEcCQ3
	 lkRNGXjyWdOWAjOORBHFnPRA/tQO7cxQGyxoKmvFfmz4u8IXtmkl7ciAUTWgFT+GAP
	 myO6mgfBUImeuJUAz/Pp3nRZc3rbxvf5UZr3Y0Bck70j808roKhLMObuwp5KEXxApA
	 xpPMEoC4Z5WrmciOCLArypa7JShIxMw4iOYxs4tM20apqeuHeoOTbvLYZ/wTsANFrj
	 0RU+AInyj9lCuH+cdHwn1+LLbCI7dNSEn4Q4fm9jFierntGz1oHAM9EVt+WbDdjGQ+
	 uvggoCCmg/h4g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Jason Gunthorpe <jgg@nvidia.com>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  jasonmiu@google.com,
  graf@amazon.com,  changyuanl@google.com,  dmatlack@google.com,
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
In-Reply-To: <aLiZbb_F5R2x9-y2@kernel.org>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<20250826162019.GD2130239@nvidia.com> <aLXIcUwt0HVzRpYW@kernel.org>
	<mafs0ldmyw1hp.fsf@kernel.org> <aLbYk30V2EEJJtAf@kernel.org>
	<mafs0qzwnvcwk.fsf@kernel.org> <aLiZbb_F5R2x9-y2@kernel.org>
Date: Thu, 04 Sep 2025 14:39:13 +0200
Message-ID: <mafs0ecsmv1ce.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 8h3qj6n5qn1ygb677u5qihkxy9dy5mz3
X-Rspam-User: 
X-Rspamd-Queue-Id: 538F11C000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1756989565-237827
X-HE-Meta: U2FsdGVkX1/esFpDhG11TT2I+uNCHxS1LvITnryGRLBSqe9LjyK6M4tuYyQqc0Scg4U6ggT8iIJ56jru1HC8riNjSrxuLhYAsUbG6q8oV2FXIdqLyybvQOObomDav/VqbRGIhgPzsuCRELOL7sWA49muQyRYYR/11r6ME1F6Vz+6bqlrRf/Lyq/B61o0FAd4GEhDISwdxrCeKw33LS6r9IjbT6K0k/W3jWruSfBMtW5q+zQ9xkDl0ka1oYlx0q/pR2xmZPGw13pnVc3HJwyUywnsFvS9fMqqVx/5t61UunQLwHW/h1zKJ84rxee+xquS6MjVzqiEPQ6R4iVh71Gm09OKZvEob+0MTFsfJt66ZM5hrHhKTa2xF8LbL4dbKEDZlYu9PwXcotEQpE8WHXAvGRSuJNMreK1ki1Wp6m7N6t6LDU/bsHlxJpVNauoto4+m8W2a7FTcmethsbM+92V1BMHZEJFJpTMbzpnVFzcB3Fo84cu/MGFw1IHyzi011KwOEna+8J28VzNTdp40FCNFZB2slQp/KtHLh3zKweVJRFd2DmeQj2KASJat9rgY80NoH058+AyyxYG+k/TI33IjImtUFeoulEw3yj14S9SQop3esSRg7qvF4aRhQqP3dmHKvZ0yooR0OSR+EPtlV7sMpxCLWo5dZxcV0pDnuP5WvI3rlxVXu0U8EyWjaHRHQJ1rqYgRhJ+rHUl3tuYlImJSr8k+kfLXw7z/2A8UoFgjIn/jWtVW5YSNWKDpwxjsSjvJktl06j6QTC54w0V6noHMjkYnI7sm0knAgpj+YiPl6sD7b+ttc/QhvtDHEWQTVFXTOxgDGRAZAYuLlc38+6xz1ghyXD7vafKvJPMB9guHgPuYnBDcqDbxBSksNaMQzgI70jx0WdSul73OWNrxChpsz7at+bEBPI1w+xFI0L3nqfjowo9g3a+SrhwAzWhxqmqcKFAyHwp5hrJStsijecG
 2BT3lZlT
 rTx4DK3pURvffAJdDdbkHelXz8ngj/xKOkaSM7U6nwDueSgXd4zqA7USZKYiC6vdSTLy4XL+nEqLwwY3MPLttGufhJqzAGhsoLwyEmT7p3th2f/Z9qAdhxRlV7feimMM+Omx2I2JEzY3ztjJa+DkIHxlOfJOmsMtYC4mkWqzv0ms55bcgXkAwp7ICKDoV9RMbZJ/qN3fdHurl+hyjyJMTkH2DaRUzWnt2sFKrFSCmWOv5fU8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Wed, Sep 03 2025, Mike Rapoport wrote:
> On Wed, Sep 03, 2025 at 04:17:15PM +0200, Pratyush Yadav wrote:
>> On Tue, Sep 02 2025, Mike Rapoport wrote:
>> >
>> > As for porting kho_preserve_vmalloc() to kho_array, I also feel that it
>> > would just make kho_preserve_vmalloc() more complex and I'd rather simplify
>> > it even more, e.g. with preallocating all the pages that preserve indices
>> > in advance.
[...]
>  
>> Beyond that, I think KHO array will actually make kho_preserve_vmalloc()
>> simpler since it won't have to deal with the linked list traversal
>> logic. It can just do ka_for_each() and just get all the pages.
>>
>> We can also convert the preservation bitmaps to use it so the linked list
>> logic is in one place, and others just build on top of it.
>
> I disagree. The boilerplate to initialize and iterate the kho_array will
> not make neither vmalloc nor bitmaps preservation simpler IMO.

I have done 80% of the work on this already, so let's do this: I will do
the rest of the 20% and publish the patches. Then you and Jason can have
a look and if you still think it's not worth it, I am fine shelving it
for now and revisiting later when there might be a stronger case.

>
> And for bitmaps Pasha and Jason M. are anyway working on a different data
> structure already, so if their proposal moves forward converting bitmap
> preservation to anything would be a wasted effort.

-- 
Regards,
Pratyush Yadav

