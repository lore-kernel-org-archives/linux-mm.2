Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50247CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 17:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758828E0009; Mon,  1 Sep 2025 13:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709298E0007; Mon,  1 Sep 2025 13:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1F78E0009; Mon,  1 Sep 2025 13:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4862F8E0007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:01:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA058C09BA
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 17:01:52 +0000 (UTC)
X-FDA: 83841298464.14.7DF8FC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 50F8440018
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 17:01:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A8kA9PWJ;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756746111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Tu0TCe47wNSnXt9O6iTKPx79aZUrzOqwn31WOalHF8=;
	b=jmG+XKY/dge3DmuL5H3dMI059Y81m74wKSeWJhk92kN8iwZ7I0mkm06+Puw2akDS7+t4vF
	6iKzyoiBahL3J8UMSknPEua0GqVOJoWgX0i1CZrbZDyxanJsI7nXtQI5MhzZRbyPLmmeGI
	k9+wyLjXrOmLbN/qBbbjWw2mAs75PPI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A8kA9PWJ;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756746111; a=rsa-sha256;
	cv=none;
	b=HAyvGQMD94nHKCYBe0I3rkwsnpo0vS9HtaOk3sDacMkozqAn6yEtFyJWyPrtF5BgWSYr9y
	IlIyXMaWfcjh/BCPdN5gCtiXDt7/AcbcbGVocBSa5U26uZv7qP0OgMXZ8jHr7ctQhEJhbT
	VC0BiU8hf3G5H19iaWtIHSqkv3vz01E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 50387601E4;
	Mon,  1 Sep 2025 17:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D11C4CEF0;
	Mon,  1 Sep 2025 17:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756746110;
	bh=Xid0o6B2H0awNyRJaNWd4FT6j6sbVMwx8IaWar55E1A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=A8kA9PWJsKdpYQ2CpBqzkOfqBwEeEF4/2ZT4gBaEtbBfff2ixrbCh57x0BX3PL1Q/
	 LRcsPWqd+g4xHYH+APQddZHFzqVWwZtUGJUL2ugp7dNJ1M1NQ0kWAey74Ljdd8rPfU
	 ZvXvt45+3GFJD7X0CdQALwh2fmjLib0nmKVV44Q/jVNYJ91jBDD1ekyWQYEPwFNhRr
	 J4nVEA23qJollhtoj3dgmfuLPd4lPGfQRvyFL4gH+tTmPZ1S4lMR6JZk2fC2OZNJqo
	 DYuErBJZvCnW6V2ChlHm3UiUC2OzRxbT3tqer9lZp7wib/mCTkg6T5qSjex029nZPr
	 /XWqER5/3Pu+A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  pratyush@kernel.org,  jasonmiu@google.com,
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
In-Reply-To: <aLXIcUwt0HVzRpYW@kernel.org>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<20250826162019.GD2130239@nvidia.com> <aLXIcUwt0HVzRpYW@kernel.org>
Date: Mon, 01 Sep 2025 19:01:38 +0200
Message-ID: <mafs0ldmyw1hp.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 50F8440018
X-Rspam-User: 
X-Stat-Signature: rdq3bnoae8g5gimbs1smoe3ed7kzj71i
X-Rspamd-Server: rspam09
X-HE-Tag: 1756746111-998018
X-HE-Meta: U2FsdGVkX19U/5+SsxQ2mwlR4UH5nugh4ohEeM9F5IPVPVg4aseqMhQRFfIAaQECjWHF2j0ZuPRmmvw+TWGtRz8flsX8Wo0ekynfUN3Vsm1KmgQNN+tw53cbAcwCgFkTLsQyl38q7cuBsE55LMO5+m2GzYWqtE58EL0iv8X0g+bndkpTz02nt2gyw9VxfK/z8RA5vfSNJ6iD96rwfr8zRxJ0BMK1bPyy81DuYjvGADq8ZzFvZL3F9zLO05/fqRce0KE6pyPxUdBiUu/t6+KD5AqbU8d1/yLICS7kDv+1Zfu2QPVEDcHqueQUzyqWCDB6Vxv970gvOgxsbImAvx0Ho65ZNA+3NZ5OTgV1sA7feUpO72r6faMMnoEXhp14P7UIWb/wHu2u/tk/HKV4LBJU2ZWlFK+YTL9OUndpbOz6wCLtQ6kADXnBzI7TNFfmqCHECQn2bzWILN54QNRIY26MSGISPrkySMqHJjtAnUwP760KEBWflavt7/GHzklsyYG79hD0OXbn6OwUFWH2AbQf1C26thMVzp0DwItliZwirAGGQ88cfDRivd5oT+OafDZovbSXUJQmGO0goixRKz2b494WIber6bIY9/fuld/2hT6X0aroFVprNQQQph7fA/1bBq14JiQu6jgALoOhwucMKkE8SZGoGBEamwYRmmxtYqs490jJkM1gtECrlV288oRJJf3v3H6oxqVFw5ClydwvqFl9DGvGE435tDYIDKwwI36/2v2jJn2m8iez0ky0sgFop/E9ZpMK/fTWtd8JAwx85WVAcMTHAHW0TqV1lpm3K9DawGpYP6SJmh2NG6cvJAnfFITIT61ceMi3tiH2scpaTN+9ipcby5pwbHbUnY8qvJ5IauYconDQLoAxkz9rIfi1Jdbr8U209dP4UwGLNyAGXcw19Y/Ov11Y8Za8GKOnSg781E9t5FNdFd1Q/v7ECtIp5liBm2hLJq2TzF+GLAP
 WIPyoxLe
 +zXRsaNLV8QpFpTCCik+N+GvxWzlBxlHwFxqwVToxiVlt2dSLD5srj/ZuqH13nMKYLFr/SApiN5kZN7XEhU/TOhXpTaIBj0sX98CfwZhkldNZEnwHLVEXwUCPQuMIp2OU4jjI8WWbC9iBnGw402v55zk7WuNgYYek+us5O9HZiD8L7wz574WW7+y360c/dnbvtk5cyC50EYnAJGbvhUAFt6xYZCkAl1NeDFJhaPgIR9XbhylM0busulY1XoFK2wR0cyck+r/2l0jTLLk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Mon, Sep 01 2025, Mike Rapoport wrote:

> On Tue, Aug 26, 2025 at 01:20:19PM -0300, Jason Gunthorpe wrote:
>> On Thu, Aug 07, 2025 at 01:44:35AM +0000, Pasha Tatashin wrote:
>> 
>> > +	/*
>> > +	 * Most of the space should be taken by preserved folios. So take its
>> > +	 * size, plus a page for other properties.
>> > +	 */
>> > +	fdt = memfd_luo_create_fdt(PAGE_ALIGN(preserved_size) + PAGE_SIZE);
>> > +	if (!fdt) {
>> > +		err = -ENOMEM;
>> > +		goto err_unpin;
>> > +	}
>> 
>> This doesn't seem to have any versioning scheme, it really should..
>> 
>> > +	err = fdt_property_placeholder(fdt, "folios", preserved_size,
>> > +				       (void **)&preserved_folios);
>> > +	if (err) {
>> > +		pr_err("Failed to reserve folios property in FDT: %s\n",
>> > +		       fdt_strerror(err));
>> > +		err = -ENOMEM;
>> > +		goto err_free_fdt;
>> > +	}
>> 
>> Yuk.
>> 
>> This really wants some luo helper
>> 
>> 'luo alloc array'
>> 'luo restore array'
>> 'luo free array'
>
> We can just add kho_{preserve,restore}_vmalloc(). I've drafted it here:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=kho/vmalloc/v1
>
> Will wait for kbuild and then send proper patches.

I have been working on something similar, but in a more generic way.

I have implemented a sparse KHO-preservable array (called kho_array)
with xarray like properties. It can take in 4-byte aligned pointers and
supports saving non-pointer values similar to xa_mk_value(). For now it
doesn't support multi-index entries, but if needed the data format can
be extended to support it as well.

The structure is very similar to what you have implemented. It uses a
linked list of pages with some metadata at the head of each page.

I have used it for memfd preservation, and I think it is quite
versatile. For example, your kho_preserve_vmalloc() can be very easily
built on top of this kho_array by simply saving each physical page
address at consecutive indices in the array.

The code is still WIP and currently a bit hacky, but I will clean it up
in a couple days and I think it should be ready for posting. You can
find the current version at [0][1]. Would be good to hear your thoughts,
and if you agree with the approach, I can also port
kho_preserve_vmalloc() to work on top of kho_array as well.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/pratyush/linux.git/commit/?h=kho-array&id=cf4c04c1e9ac854e3297018ad6dada17c54a59af
[1] https://git.kernel.org/pub/scm/linux/kernel/git/pratyush/linux.git/commit/?h=kho-array&id=5eb0d7316274a9c87acaeedd86941979fc4baf96

-- 
Regards,
Pratyush Yadav

