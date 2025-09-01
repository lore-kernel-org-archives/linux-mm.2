Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8317FCA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 17:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD088E000C; Mon,  1 Sep 2025 13:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4A08E0007; Mon,  1 Sep 2025 13:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1738E000C; Mon,  1 Sep 2025 13:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D3F38E0007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:11:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23CA616093F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 17:11:08 +0000 (UTC)
X-FDA: 83841321816.16.64BD565
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 91C8840011
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 17:11:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TUUI4mWI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756746666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxNB/3Da+XIexCdnEiPjOOqKyHicxPLTrARqP9TSq78=;
	b=ZEJoixSLIfdn9c8+WMumn+xYL4e1AJcqEG/lrOty9B42kD0M20S0Jg9cgZKhS8OU2iP9sO
	CUjYkraESPaXaATWIG2Hz1EtZ24A3c5R/SG80ilAnUvbeuHOeF3GL5BamM5uR7Kk8Jf9ef
	TRY6cbVfVM8VlESDJaOmIgMgptx8s2s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TUUI4mWI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756746666; a=rsa-sha256;
	cv=none;
	b=HBU/Yneoq+GX5FCAqMVnrqj9UpluI+03UB1uAXotNZX9rcHV0q+R35Xr/TdEiK2JdH8Rdf
	PDKIsrGfUqOy4s/fyiXLpACUKfzOJVR8uRYkrMLst+NeHCSkKVGqTh6CR+9Os6l9dpFM38
	NkzsrFDCSAnBohwurGRRldGHYPJ2AvQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DF3C8601EB;
	Mon,  1 Sep 2025 17:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20273C4CEF0;
	Mon,  1 Sep 2025 17:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756746665;
	bh=4H0TvV5SATbPpUhZV/kpTrbxsbMRGPlfcGGMf566Pzg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=TUUI4mWIbQYkLpKOkdoxxSUBAWTkDGIYzdhS0o8slwr8l2r1Piu0dUL/l4nBep+rG
	 0yJmQw4jAg/OFnBDLBuTCbytHtcsfNnnUgNkZT3gLgEb3ShbgGVAKwQxkOyPSP18C8
	 7llU/i7XIFhO9U0XbVOYJRMrxGrbX605fmK7MccA+FrMFzq540oBoLsId10kVkUbl0
	 lAs6X6RqdrVdsl02+4MM4ddwO3muSKKRwdLGGmbbS8cho5TRe0jnQdsfS22uYIMObg
	 eUQz4JMDeISgSUyU3IB3lnscaMdUMFfjTXMsM05sKQlT4UprJfC0pJ8VwXpakPhqL8
	 FF3vY5xHeeBDA==
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
In-Reply-To: <20250828124320.GB7333@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<20250826162019.GD2130239@nvidia.com> <mafs0bjo0yffo.fsf@kernel.org>
	<20250828124320.GB7333@nvidia.com>
Date: Mon, 01 Sep 2025 19:10:53 +0200
Message-ID: <mafs0h5xmw12a.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 91C8840011
X-Stat-Signature: ayymiizsxi8qeyzyuudm47ffyrc4d5xa
X-Rspam-User: 
X-HE-Tag: 1756746666-29912
X-HE-Meta: U2FsdGVkX18uGeRZA2405Dj3RLC0Vo/6HmrnDcIt3WFT6Xm9Qte6E8PRfFpdFbO+38elNgTQzsF0OuDDE9VJUwWkKEDxlKcJTm+bDBcmpjG1MlWUC7KcsoMQGCSnA1iyvHCA6mbOsGTMDMLBC1UXq6afuNyNsdk3BPAzDUdFji56qwyiFNW/7eC7wi6J3YiLYjCoeq3qfWU6E2lt9tCSuzNO7qGgcOMnwUc17Fj7OnagWn6SX5avAdVxaa/tiiqrlNj0SFBREhiamnUD44C15FTQLQYO+rbQ3/fU69bLgGENLAnvRhYEMlLN0AS7oeFktUiQ1ZY4Qp8etR0IXKf7z2lXvA0hZezOMKJUz+CRGR0qaWrE8+810YhsYopxwvZN4rPGe8g7CLURs/gBkFEU6+ZJp9s466tMyfxQj3I79dRWW1CAWgakh1hMJJ/YNQxalFheqgXiD7rWwIULNX6EQZTpU2o9rhzHrQCwdY6wgrbRsOu0AimDJtZDbpM3+G/YpoRKSbZsoHJAVbWlEt7+Nir7fC1Yw1vCGBIFH8qSDeNKI9D9sXtGTU0BCB8F9bzAWvxy1VRTqQMk+ae9LLkFZYrJWoen+iSmZ/zd97Y9FAWa7R2ObYjXGXaDVQ3hjzrN3sCVlV5jorofc8eCFzvQOzKxtQxMHfWiV2JGMfgqllFJL6I4bF7INNeGhPeGSImztH6NQJyfTzIRf/nNj1q0wTvVtUGU7jYAIE2G40JX4xKURcEmipcYvmAPeS0xPN/ZFGCdxoF/SkG2yKwkGsPyblvRTaKSQDIDe4mZQnu2o3hgoKFTevDPji5cjktKr+Qst9ze1DRprayyWJNYxRtbvr3RLEQVlDFe40mp6F7h5OtF8+gKb9+SajPlHTUhlssZdmjEzpL2jATJe7CBXl2l7MTPIsq8hFSPHnlQoblA7bAiUnaLoVxmpvsb7X9kH34TlqIAkT8nGTNlyP4BH+3
 kBcJ+Rc1
 ThRNfgwAq83sHH6R0ts+LbTu3PWi6MYDOHeZFeag7/TpPjhmjRTl1GNfTMAP6gY1iG6Vmoz0bGEzSPpRceSVwV/oZBvw/js4ATtl07UsDdr3PHkDof88EFpxfZRrtUaVfjFpuZYnJ2pqGvlffS3D3nD6nL9YClcvreZ/s1Fab/HZ3EgIGIhVihwwVhq2NChCgtyPCPtzOwkgNwvIiuFU4qPeu4pBDlrTuviavfIeCYyoqbSOM6EOTdhcdRTRyis4xcQ3fjAeapSrmeQE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

On Thu, Aug 28 2025, Jason Gunthorpe wrote:

> On Wed, Aug 27, 2025 at 05:03:55PM +0200, Pratyush Yadav wrote:
>
>> I think we need something a luo_xarray data structure that users like
>> memfd (and later hugetlb and guest_memfd and maybe others) can build to
>> make serialization easier. It will cover both contiguous arrays and
>> arrays with some holes in them.
>
> I'm not sure xarray is the right way to go, it is very complex data
> structure and building a kho variation of it seems like it is a huge
> amount of work.
>
> I'd stick with simple kvalloc type approaches until we really run into
> trouble.
>
> You can always map a sparse xarray into a kvalloc linear list by
> including the xarray index in each entry.
>
> Especially for memfd where we don't actually expect any sparsity in
> real uses cases there is no reason to invest a huge effort to optimize
> for it..

Full xarray is too complex, sure. But I think a simple sparse array with
xarray-like properties (4-byte pointers, values using xa_mk_value()) is
fairly simple to implement. More advanced features of xarray like
multi-index entries can be added later if needed.

In fact, I have a WIP version of such an array and have used it for
memfd preservation, and it looks quite alright to me. You can find the
code at [0]. It is roughly 300 lines of code. I still need to clean it
up to make it post-able, but it does work.

Building kvalloc on top of this becomes trivial.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/pratyush/linux.git/commit/?h=kho-array&id=cf4c04c1e9ac854e3297018ad6dada17c54a59af

>
>> As I explained above, the versioning is already there. Beyond that, why
>> do you think a raw C struct is better than FDT? It is just another way
>> of expressing the same information. FDT is a bit more cumbersome to
>> write and read, but comes at the benefit of more introspect-ability.
>
> Doesn't have the size limitations, is easier to work list, runs
> faster.
>
>> >  luo_store_object(&memfd_luo_v0, sizeof(memfd_luo_v0), <.. identifier for this fd..>, /*version=*/0);
>> >  luo_store_object(&memfd_luo_v1, sizeof(memfd_luo_v1), <.. identifier for this fd..>, /*version=*/1);
>> 
>> I think what you describe here is essentially how LUO works currently,
>> just that the mechanisms are a bit different.
>
> The bit different is a very important bit though :)
>
> The versioning should be first class, not hidden away as some emergent
> property of registering multiple serializers or something like that.

That makes sense. How about some simple changes to the LUO interfaces to
make the version more prominent:

	int (*prepare)(struct liveupdate_file_handler *handler,
		       struct file *file, u64 *data, char **compatible);

This lets the subsystem fill in the compatible (AKA version) (string
here, but you can make it an integer if you want) when it serialized its
data.

And on restore side, LUO can pass in the compatible:

	int (*retrieve)(struct liveupdate_file_handler *handler,
			u64 data, char *compatible, struct file **file);


-- 
Regards,
Pratyush Yadav

