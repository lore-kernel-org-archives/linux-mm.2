Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D840CCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 14:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BD7C8E0005; Wed,  3 Sep 2025 10:17:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E138E0001; Wed,  3 Sep 2025 10:17:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25D398E0005; Wed,  3 Sep 2025 10:17:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10DFB8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:17:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7BD3140714
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:17:28 +0000 (UTC)
X-FDA: 83848141776.30.5B674E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2645E40003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:17:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g2qkEx0s;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756909047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YXpHEicHM8rWBAHduDH0XoOkOiuEkvnWoFXufhyx0h8=;
	b=WHoXguSkbJPu6r6lNA6izXgyKY7rPXbk4iCjxMTHeurp2RNxc14yumO439RLIVzmgWEvSh
	adU6XLdzQncODxAu0UvXk5TF/fabr6+9CSdu1+D0gyjACPK9vFawEaH+h9/kd5DUY3dBG+
	cmovYIrG5zI/7mNJ6E9QnMLLDrH3Feo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756909047; a=rsa-sha256;
	cv=none;
	b=J/VHK97Fwi1Tk0+QSgj6qXX/GqOOcfOCpl5fGD9hJWFWVPXX/SU47QDc1uaxTaVvptk1jD
	eW+/GicfVfl0bi/BS7ybU+YhKwx3tWwV67KRSPt2tmfUse6T3XZ+HWJluvqjkTDNP5ikAk
	X7XFgjVFb4m+VYlHitY+wjqS8AUPcPI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g2qkEx0s;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E6E460054;
	Wed,  3 Sep 2025 14:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075E6C4CEE7;
	Wed,  3 Sep 2025 14:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756909046;
	bh=rkSg1vCoekuc9whKWjo4hgqm1Elyfx6nN2+yYBdxBhc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=g2qkEx0srlnMZm9jvTuQkoAfUMqfZLmOGvMvWAXSFNRLeSDA5jxOcfWXXmUvxxNM8
	 yvdadUNZgnBX3z/+e4yDpoxMbRzcPuAnr38KTH3Vu7n/1F7mqMnQLDtY97FOFmU2qb
	 f3BqGPAIhHQlFrXQgm64XqEAf2KGNfJM92WGL8OAKBaRXkA/f3UgK0fIr7zt5swxiJ
	 hgOUO2rzO4bNzczWxkpktx7lTBG9e6nmau7vZmkjiEckwkS4MGMoDE1PbRdr39Xoxn
	 kj4QeQgwRxQT2rdLQor3kdwOYj76BPFKEkjV4l2X1fOg6RdjMK6qKg5Z6N5j4zrE8l
	 ZL568mTWs7NNw==
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
In-Reply-To: <aLbYk30V2EEJJtAf@kernel.org>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<20250826162019.GD2130239@nvidia.com> <aLXIcUwt0HVzRpYW@kernel.org>
	<mafs0ldmyw1hp.fsf@kernel.org> <aLbYk30V2EEJJtAf@kernel.org>
Date: Wed, 03 Sep 2025 16:17:15 +0200
Message-ID: <mafs0qzwnvcwk.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2645E40003
X-Stat-Signature: k1g175ca7w9c9p9k3ajsffbem1qqskif
X-HE-Tag: 1756909047-443580
X-HE-Meta: U2FsdGVkX19f4zLcBINvuJaBt0NCIihZOLKv2wx30s2vEMwX8wmunm3jJQRhOgTd8rnQNPoQm1oDEi2sEZkztKiE9n3RXBnee8pKE/i2OVa3eR295uqpDFT+BHrlROvFe8uHO3rVHsOiP3M/btq/K5Q6WnQfavolSPt99KxiASj4uLLvL4rjaWdYRQLS93YszKav9+fDY3Kw5hvBSt2YSF89DkkwZbKmQu0M3LkAQGKuwfzhemu9jqrISVUZl5Kc8NtPudZF8LMe43F9aWH85TafVmXgFG48iE47QsY5PTIdXG7GA/5vAnybHJ1Qp1va4B4JnWvYoVLMnLpUfY1UUAtKtuKMnfF1tDzLgHdGsao3F89pZwFWOxEQI4uS3WR7UVkyBOsxjB0uX1LBA0MeeBBkvoK9nuZ0y0ZXbaaq90Og6/FkBZjj5j7KHY3kKUKbluC5QAzJStFD/HZKYhK8VCf85MIToR8behcRC5UVxR7rGmCdvPNpBduQXaJDQFSPhEQIC8PpmJde5LIB1qKHX8SBigltTxFUDZsoGNdOfyJbohGt1lWCLGuVEn7GV/FdXne27GQNiH+LwIis+MJH6PYSEDk7YOGwAwMI2Rdp62PBL1hmlsY/3ZAphicVPBHF2wdnW6m4ARvuX2bRvB2hqu7Y8v3QLeZ0/2OIOAZF97SwiOVmVLqCuEv2pvAUjrWWptQ0HfKi6hvpK1fh5pSKjZSxsF8HtVvoO4pJMRSgUv6lak5oqSgVTyMgi2mXkzZD8B/9N88z4GV9vYXYIUEjS8PoE9c7QDY1oYUTRotOSPnd2gH7HvtTpsHFmJDX2Sh6fnJh9ODuuxWm7cFvOcQGfnR384bOz1TXSeDlDeMgwQtK8uvJIwEiVScKsKCoqzA2vm5hhJFSPqUWHuRU75BvnQvo4r8B5QAQBA6fpjaROxtESENvluZ9L0DJvacuKbD8O/ZLnEJ3ocDiIt1xjsO
 alQ73+RT
 +QJJ/k1wemrnJU2E4UQg7q/8G4/dR0Wt+r2FcQLBcP0A+DrCPyWnW6Q4WSsr0dZeY8Uxq4bm97CIZAe/z2kT/uiJpieqagDEtOJbfRyAP7ebzutjGWfar0+p+xsIl7mDMCBUrqwx8Mo4zaY2tQqQM40fIZbl8KanjvDjuMpKSc9iqiDnMMHARdtfcZ5MQQG0C41+bl3CkzIxN6uE1BHq2JeeSlarjVQd94lKz71siKPiyi2Bhb3CvjELX4C861nnXOXEbcgcQpFwU+5U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Tue, Sep 02 2025, Mike Rapoport wrote:

> Hi Pratyush,
>
> On Mon, Sep 01, 2025 at 07:01:38PM +0200, Pratyush Yadav wrote:
>> Hi Mike,
>> 
>> On Mon, Sep 01 2025, Mike Rapoport wrote:
>> 
>> > On Tue, Aug 26, 2025 at 01:20:19PM -0300, Jason Gunthorpe wrote:
>> >> On Thu, Aug 07, 2025 at 01:44:35AM +0000, Pasha Tatashin wrote:
>> >> 
>> >> > +	/*
>> >> > +	 * Most of the space should be taken by preserved folios. So take its
>> >> > +	 * size, plus a page for other properties.
>> >> > +	 */
>> >> > +	fdt = memfd_luo_create_fdt(PAGE_ALIGN(preserved_size) + PAGE_SIZE);
>> >> > +	if (!fdt) {
>> >> > +		err = -ENOMEM;
>> >> > +		goto err_unpin;
>> >> > +	}
>> >> 
>> >> This doesn't seem to have any versioning scheme, it really should..
>> >> 
>> >> > +	err = fdt_property_placeholder(fdt, "folios", preserved_size,
>> >> > +				       (void **)&preserved_folios);
>> >> > +	if (err) {
>> >> > +		pr_err("Failed to reserve folios property in FDT: %s\n",
>> >> > +		       fdt_strerror(err));
>> >> > +		err = -ENOMEM;
>> >> > +		goto err_free_fdt;
>> >> > +	}
>> >> 
>> >> Yuk.
>> >> 
>> >> This really wants some luo helper
>> >> 
>> >> 'luo alloc array'
>> >> 'luo restore array'
>> >> 'luo free array'
>> >
>> > We can just add kho_{preserve,restore}_vmalloc(). I've drafted it here:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=kho/vmalloc/v1
>> >
>> > Will wait for kbuild and then send proper patches.
>> 
>> I have been working on something similar, but in a more generic way.
>> 
>> I have implemented a sparse KHO-preservable array (called kho_array)
>> with xarray like properties. It can take in 4-byte aligned pointers and
>> supports saving non-pointer values similar to xa_mk_value(). For now it
>> doesn't support multi-index entries, but if needed the data format can
>> be extended to support it as well.
>> 
>> The structure is very similar to what you have implemented. It uses a
>> linked list of pages with some metadata at the head of each page.
>> 
>> I have used it for memfd preservation, and I think it is quite
>> versatile. For example, your kho_preserve_vmalloc() can be very easily
>> built on top of this kho_array by simply saving each physical page
>> address at consecutive indices in the array.
>
> I've started to work on something similar to your kho_array for memfd case
> and then I thought that since we know the size of the array we can simply
> vmalloc it and preserve vmalloc, and that lead me to implementing
> preservation of vmalloc :)
>
> I like the idea to have kho_array for cases when we don't know the amount
> of data to preserve in advance, but for memfd as it's currently
> implemented I think that allocating and preserving vmalloc is simpler.
>
> As for porting kho_preserve_vmalloc() to kho_array, I also feel that it
> would just make kho_preserve_vmalloc() more complex and I'd rather simplify
> it even more, e.g. with preallocating all the pages that preserve indices
> in advance.

I think there are two parts here. One is the data format of the KHO
array and the other is the way to build it. I think the format is quite
simple and versatile, and we can have many strategies of building it.

For example, if you are only concerned with pre-allocating data, I can
very well add a way to initialize the KHO array with with a fixed size
up front.

Beyond that, I think KHO array will actually make kho_preserve_vmalloc()
simpler since it won't have to deal with the linked list traversal
logic. It can just do ka_for_each() and just get all the pages. We can
also convert the preservation bitmaps to use it so the linked list logic
is in one place, and others just build on top of it.

>  
>> The code is still WIP and currently a bit hacky, but I will clean it up
>> in a couple days and I think it should be ready for posting. You can
>> find the current version at [0][1]. Would be good to hear your thoughts,
>> and if you agree with the approach, I can also port
>> kho_preserve_vmalloc() to work on top of kho_array as well.
>> 
>> [0] https://git.kernel.org/pub/scm/linux/kernel/git/pratyush/linux.git/commit/?h=kho-array&id=cf4c04c1e9ac854e3297018ad6dada17c54a59af
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/pratyush/linux.git/commit/?h=kho-array&id=5eb0d7316274a9c87acaeedd86941979fc4baf96
>> 
>> -- 
>> Regards,
>> Pratyush Yadav

-- 
Regards,
Pratyush Yadav

