Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62568CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 17:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53A0F6B0008; Mon,  1 Sep 2025 13:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4516B000C; Mon,  1 Sep 2025 13:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2D18E0007; Mon,  1 Sep 2025 13:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22ACA6B0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:21:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A741C09C6
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 17:21:46 +0000 (UTC)
X-FDA: 83841348612.30.5EEA439
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 88417A000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 17:21:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T9dmzbN3;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756747304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=siMaPVt6g/JKYh3FQ6uq/rcuBtJ/z3/Tz6xJHHUcN0s=;
	b=2mCi4X1P9wFQ+Vx7QBEKYqzgaPkD8BvJolWXBrNaEYHJUU2OQ3empSDPEz4CEAVnwvCyEB
	9HfTkpLFb2keTtaQCqwKmkGmOVp2qL+ozvdPNRjPoMkvfH5NtRxT/6qrkeoTYzTAC46c0P
	dsUCm+zova9rKnU/680pe8VGeAGRXLw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T9dmzbN3;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756747304; a=rsa-sha256;
	cv=none;
	b=QraGc04uBvRZqZ9CjMg3lxRr6tGkhHUe6ZJ0DgBzZDW79d5bV8HTMkjegvZq4iPlBgZsEu
	2h8lP/rL+22PHnRtTsIQd2tEiYSPr5DvhnaSQtwwTtYdrbPMHZjk/NiSIQVuxGeG+eB+4g
	YC/NWug6S7MQSIlf1rruMR4fnRwGzLQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29D8441AB0;
	Mon,  1 Sep 2025 17:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6769C4CEF0;
	Mon,  1 Sep 2025 17:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756747303;
	bh=3mhC2/T1c6Z+vgeTqGwgs2Xmkym2DVFtNGG4o+LNDHg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=T9dmzbN3vJLJmQDq1Re5bzl8OxpzTbtxHyo9VrZ09/exjPs4/S/UQ/qjokktB5xH0
	 SSAhxDYKrSqviNam9PJfJyWLgwI4zqdg3I1711MwPV/OjBcVgO1pnXEGeXz3WuK0Xv
	 UVuAAVWCHK9DEEZHqKg20aHU8P+mQKhAhInpwws4Klng0iRivbKWCQXm3KK6C52Kus
	 igQubipBz8w3WOXaDSc+DURspm2666u/anhAH4CayF+VNK79UQd6Dcbo23j5PKLmkc
	 7e7Mzu21+so4+IDhVLL5kTXhZiCBHk37Mq4vGWxsegGW2R/VeQMTHWMDaNdZO+jGo4
	 NR5zsktrqL/VA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>,  Jason Gunthorpe <jgg@nvidia.com>,
  pratyush@kernel.org,  jasonmiu@google.com,  graf@amazon.com,
  changyuanl@google.com,  dmatlack@google.com,  rientjes@google.com,
  corbet@lwn.net,  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
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
In-Reply-To: <CA+CK2bC96fxHBb78DvNhyfdjsDfPCLY5J5cN8W0hUDt9KAPBJQ@mail.gmail.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<20250826162019.GD2130239@nvidia.com> <aLXIcUwt0HVzRpYW@kernel.org>
	<CA+CK2bC96fxHBb78DvNhyfdjsDfPCLY5J5cN8W0hUDt9KAPBJQ@mail.gmail.com>
Date: Mon, 01 Sep 2025 19:21:31 +0200
Message-ID: <mafs03496w0kk.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qguqdudsr1i1twdi6odgwff4w4nq1ccd
X-Rspam-User: 
X-Rspamd-Queue-Id: 88417A000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1756747304-770424
X-HE-Meta: U2FsdGVkX1+U7AVc/qA5neTgZNCPDd+RBVpDJxBv/6OZ/wnYrfTDkvhBd8q6entzxBQxIjyxsv5mdAApnhqNZ7AtgCDxDzGqAqLHqqA8Kw2oHY9GHvIrEi3NydWq3IlXNaiQpD7BG3zmtHkmd/oxTuoC+qWHDkiw2YbyJdHWpEmUg4WrR0swKnCu1UI7lph7KxzOPy3o25zEz3AUaRFGNefNNnICI4+U4BzdB8Z3cozjCrW1CNj2KPwpB7uzbdJx9LdS2J4wSsyf42dR12iZW+GV7cKdZ76o3U8089n6pJqpXVF3LYswzm60zbQDtk5fd6tODFH/vq/WXF5Hbj1z+YEJr5swOn18uldhJfywxjD9NMBi/i+0LVMmfZF7OfPCB+zE4fOXD1esvvCaGFGRdIwIzafM/f1lXgFynUmZ+LfhE1+0+U9j+3CtmF6oizuoCZgG/TZgsCFqHf6nzafNFP2sLuRU5EGmlvledGYCxA6kLRDt9AaYVhzmwaJ42j7H8sotvMlPa/y4TnbF4PeG2NdLdDg5VkzYAwmmbAQB8Bkj8R7Fo4MzvLJ4c84aGAi3c7EdV/wmjl0qBOXIe1sGfANKXglrWAisdr4zz9TzacDN0vXFZ8SnywMvpMp0VJKXL/ERC5a+rrzLVoMNMB1ku073df8B//I5GOyUol9I0Kk4UhmFmVk2GdqGEPFt1ARgr4TO0mOk9GwVFR6/8s6dbNRhc1v3+cYXyWkKtrEVJdisV/pRfWpGxsx5aYBKnImgxVURpQ7wqjzHx3IP8UwAAXHxEuvASDfsCd3XxTWr+L3blkHKYIoMBXWbqwT0FTMGDxo528YSs2URWjJkorw+uB+ipPXjuNSEtJUTPNM/Zw4hAQSrU0RIHFlDuRthFSX+4Kwa+6Qx+NTdByli4HaMXgloZaX4pTrJQFRASC6T1BkLukEqPaV4sYyzpYnOh8RumtopDPpnItQFHGWO75h
 ziLYyShv
 fjQNZIicVI2EftBNjCCuZV1KlWE31a0YFfLuyKAlkrAUFkXWw8l/qzjoQfxPY8cw6k/cpPYh8TCkiYQqOrsMz7KSdesFzzLwPZl+Vu7rlZB5Dq0F0cmNgzJjeg5De4K1YjOmUxqAIwBfBpMASzxn1M65WhvmvfMSUX3DByRsZoOIFIyHhQucOh103RyAzpK1gX00udROWCvXLlW/zAGZRvhv4BhI3WEv2jkg84kDmR7/vKbEBo4hvgOA6r12IZFL+1MUdFgBD3zVq4ReMqXlBDZGnY+JzW5Osa5btID4yrLUbsJ3y6nEMjD6dhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Mon, Sep 01 2025, Pasha Tatashin wrote:

> On Mon, Sep 1, 2025 at 4:23=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wr=
ote:
>>
>> On Tue, Aug 26, 2025 at 01:20:19PM -0300, Jason Gunthorpe wrote:
>> > On Thu, Aug 07, 2025 at 01:44:35AM +0000, Pasha Tatashin wrote:
>> >
>> > > +   /*
>> > > +    * Most of the space should be taken by preserved folios. So tak=
e its
>> > > +    * size, plus a page for other properties.
>> > > +    */
>> > > +   fdt =3D memfd_luo_create_fdt(PAGE_ALIGN(preserved_size) + PAGE_S=
IZE);
>> > > +   if (!fdt) {
>> > > +           err =3D -ENOMEM;
>> > > +           goto err_unpin;
>> > > +   }
>> >
>> > This doesn't seem to have any versioning scheme, it really should..
>> >
>> > > +   err =3D fdt_property_placeholder(fdt, "folios", preserved_size,
>> > > +                                  (void **)&preserved_folios);
>> > > +   if (err) {
>> > > +           pr_err("Failed to reserve folios property in FDT: %s\n",
>> > > +                  fdt_strerror(err));
>> > > +           err =3D -ENOMEM;
>> > > +           goto err_free_fdt;
>> > > +   }
>> >
>> > Yuk.
>> >
>> > This really wants some luo helper
>> >
>> > 'luo alloc array'
>> > 'luo restore array'
>> > 'luo free array'
>>
>> We can just add kho_{preserve,restore}_vmalloc(). I've drafted it here:
>> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=3D=
kho/vmalloc/v1
>
> The patch looks okay to me, but it doesn't support holes in vmap
> areas. While that is likely acceptable for vmalloc, it could be a
> problem if we want to preserve memfd with holes and using vmap
> preservation as a method, which would require a different approach.
> Still, this would help with preserving memfd.

I agree. I think we should do it the other way round. Build a sparse
array first, and then use that to build vmap preservation. Our emails
seem to have crossed, but see my reply to Mike [0] that describes my
idea a bit more, along with WIP code.

[0] https://lore.kernel.org/lkml/mafs0ldmyw1hp.fsf@kernel.org/

>
> However, I wonder if we should add a separate preservation library on
> top of the kho and not as part of kho (or at least keep them in a
> separate file from core logic). This would allow us to preserve more
> advanced data structures such as this and define preservation version
> control, similar to Jason's store_object/restore_object proposal.

This is how I have done it in my code: created a separate file called
kho_array.c. If we have enough such data structures, we can probably
move it under kernel/liveupdate/lib/.

As for the store_object/restore_object proposal: see an alternate idea
at [1].

[1] https://lore.kernel.org/lkml/mafs0h5xmw12a.fsf@kernel.org/

--=20
Regards,
Pratyush Yadav

