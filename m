Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9A35CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE8F6B00A6; Thu, 20 Nov 2025 10:34:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5EC6B00B3; Thu, 20 Nov 2025 10:34:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5966B00BC; Thu, 20 Nov 2025 10:34:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC17F6B00A6
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:34:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6486813965F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:34:58 +0000 (UTC)
X-FDA: 84131383476.21.3F4D100
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id BAAD01C0011
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:34:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BSbuSzzK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763652896; a=rsa-sha256;
	cv=none;
	b=e5Q27LruLI00mtYAcfuoakIlZCiZhLrHBlqhkUZjBpUI7/PpyGZNIYPC9lBLTg8dU06NsN
	HMgqP73Zmn8xdkt1L96WaAK12w/t1afPKRDXC4Xz6qjAsC8gfBfMs61xXhiks3Hpb95vCj
	2HutwlhXBgn3cwiXi3w40enxJbAt/qE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BSbuSzzK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763652896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUFuS19Wb+ilqZ1JfCLr5GwlcbMVh1uoyglC+IV1BTM=;
	b=VH+wCHRcu87fHroWb2RN0KYwpIropBDup6sRVOTPaPyRuRySS1X0CU/C3sBom7QboZKscm
	CH5wgDJMi8+BMTn9wbx6+rS5tm4v4siK14bBEmjOw2KYjF1HjSdvtxB9ar23OkyIenq0dz
	oZwraiudeT+PMygtGaJXFjSUT0eyjFA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 11AD960131;
	Thu, 20 Nov 2025 15:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36EEC4CEF1;
	Thu, 20 Nov 2025 15:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763652895;
	bh=iLlpiIoq6RvRNwPu4wKmwbysrxXgehN/NeIhRBCyojQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=BSbuSzzK7NmUg46X6Xqg6ULra0bk2IOvd4ky2Uu2VfaVLOtcvXkx17NUhrXYC5ucU
	 PJfv6TgrN2RCJfDTXq3QFuGducBydTpyGGuTVt1tX1UsYx158hZaIw6KucGedSBdnj
	 cnWvat7/iCNuhM3D4FhcULyewVEYpxKNXTsxKMFgotaIX21VGAH+F5QnMtqCQtdQ/z
	 u0eFdZ3lwuu0TO7ycFLhQMuIe6rxYzaKbfyXFMQmSh3psyGpXYrvKSG8c5ZUAthpep
	 YZM6LAvl7j2Lgl6pytE3RCmARngLlNipOyV3xf4vphQJBndBwXD2Xe912KrSst9b9D
	 szpXLx0N6hkVw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>,  pratyush@kernel.org,
  jasonmiu@google.com,  graf@amazon.com,  dmatlack@google.com,
  rientjes@google.com,  corbet@lwn.net,  rdunlap@infradead.org,
  ilpo.jarvinen@linux.intel.com,  kanie@linux.alibaba.com,
  ojeda@kernel.org,  aliceryhl@google.com,  masahiroy@kernel.org,
  akpm@linux-foundation.org,  tj@kernel.org,  yoann.congal@smile.fr,
  mmaurer@google.com,  roman.gushchin@linux.dev,  chenridong@huawei.com,
  axboe@kernel.dk,  mark.rutland@arm.com,  jannh@google.com,
  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  linux@weissschuh.net,  linux-kernel@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-mm@kvack.org,
  gregkh@linuxfoundation.org,  tglx@linutronix.de,  mingo@redhat.com,
  bp@alien8.de,  dave.hansen@linux.intel.com,  x86@kernel.org,
  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
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
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org
Subject: Re: [PATCH v6 15/20] mm: memfd_luo: allow preserving memfd
In-Reply-To: <CA+CK2bADcVsRnovkwWftPCbubXoaFrPzSavMU+G9f3XAz3YMLQ@mail.gmail.com>
	(Pasha Tatashin's message of "Wed, 19 Nov 2025 16:56:10 -0500")
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
	<20251115233409.768044-16-pasha.tatashin@soleen.com>
	<aRsBHy5aQ_Ypyy9r@kernel.org>
	<CA+CK2bADcVsRnovkwWftPCbubXoaFrPzSavMU+G9f3XAz3YMLQ@mail.gmail.com>
Date: Thu, 20 Nov 2025 16:34:45 +0100
Message-ID: <mafs0a50g3ega.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BAAD01C0011
X-Rspamd-Server: rspam07
X-Stat-Signature: r48guo9i39n1k5jthj5uujayg14uoexs
X-Rspam-User: 
X-HE-Tag: 1763652896-508950
X-HE-Meta: U2FsdGVkX19eeMaXOdROBXes4j296eeMwY3CqZxk1OIuDgO4ykwA6nb17FeKQp0Z3wkO+C9donU47MXsQ+SVuRWoZcV39BeTMulUw8gDslCKbkbGQq9z9OkSM3p6cp/EgVWrFT/zzmAa+dWrHEBL9077VKovFOrMhNHnzmcOhD5S5aH1F0AcQBPRyPf1s1k2NcYH3rTOIPC5cTWwim/T2+5OEfXMWoLiKOPiwuSXDYW60IWlT7UmhNALF0HcSofpQpGtR4ViatsXYcFVlT0R2+xCQHIC+QKROnaCRNhH7FYMSCD/czLGlEdvjm62oUCMBVC/w2i1FRP0MmLPPOcGN3yZdCcP99krj49k/Gm8BIlotC6kY0GBPenf4XmZy1vLi3k5iORXYxcK+cuJTYyQcIq9xCkBvXolIe3Z3chlif/Fid93lVPK9sop8EbJxuL1D2sRFGfXXIWnKFOCy5iOMHdquFIeql6hzZ4Yadzodbl+5q9zs4yWWrDXZ6iujvxIwxKm5kaNrI/bZ3IERrbssZKzUfsq2MUpxmqzFjowap2fpv04cwM2LheRRP9Q/9iYrFUA/pNVwHY3PZcJo6beKNop1FljybQzGpBhy+zk4rA2v03Vs533VXHEyED3y/8v+J2f3+fOW1NMJI/CUBI7YLQc0ly6yG/kVtw//PmIbFV0m/D6tSAKg4JYsPfENWw/+J1IezTzdJW+iLYfch13WAnqVCPOjyi45zdTEM6J+SJoc7UfbsaYNWiqVCz+4s7kd32rby7ziwG2RRcW1XUrFnjs0LtJbzyAHAjakRdrNt5W8ZfV/HALvUQBSSWFaQM+w0jBPfBnuQwOT/Bvrl/VLO+8/koUgTO86KzxixqreSg8khVIoOlnwiOUr10GGg8qxhwQZwzodnOgmnhu79wmSOwVLG8OjQR8/pCA9D8lVuMlCzWS8ZFscuVA0vHKZcqzb0ShMKn9yXxMOJO3r2j
 /+iW5fKW
 LesuO7Fqt+DVNTget9ATgGEsl/lpdFcWMuVo6HDQX7Knwn5dgatC1dUJAoKjw6ngmSKfsB8Bsx60fE1OXD8Jcvqu0SHoJxkX+5T5u8kKWbmfNc3u0SXpHbFOSNMxiXHyTaAvX3e1MoSFDLDdzEAheLMTO9zqrV/x0wgY0CeQlozqb0mBSU7tjuDTdhgRRVD8Rhdcv64fB6eRbH/dTtzlw9MQZ/N/Z/TXjq4xvSDPnyIzeJ39QQNfnBBcA2AvYOWoUW5tH4zYCaSrsO235Mmc+GOj1ptXrChSwnt4pLK4Vecz3egJMvfkFzQu4NH3ufDP/Jr/fYs4Hoy8KlzzlOKkP9wkqzUZr/YDRwkLuR18YXKpliMRgefLVow9gejVQn+wQoCbNZaPYopjMvE+WdezzqobuKwNnbJ3MSVq437G9MbRrTOI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19 2025, Pasha Tatashin wrote:

> On Mon, Nov 17, 2025 at 6:04=E2=80=AFAM Mike Rapoport <rppt@kernel.org> w=
rote:
>>
>> On Sat, Nov 15, 2025 at 06:34:01PM -0500, Pasha Tatashin wrote:
>> > From: Pratyush Yadav <ptyadav@amazon.de>
>> >
>> > The ability to preserve a memfd allows userspace to use KHO and LUO to
>> > transfer its memory contents to the next kernel. This is useful in many
>> > ways. For one, it can be used with IOMMUFD as the backing store for
>> > IOMMU page tables. Preserving IOMMUFD is essential for performing a
>> > hypervisor live update with passthrough devices. memfd support provides
>> > the first building block for making that possible.
>> >
>> > For another, applications with a large amount of memory that takes time
>> > to reconstruct, reboots to consume kernel upgrades can be very
>> > expensive. memfd with LUO gives those applications reboot-persistent
>> > memory that they can use to quickly save and reconstruct that state.
>> >
>> > While memfd is backed by either hugetlbfs or shmem, currently only
>> > support on shmem is added. To be more precise, support for anonymous
>> > shmem files is added.
>> >
>> > The handover to the next kernel is not transparent. All the properties
>> > of the file are not preserved; only its memory contents, position, and
>> > size. The recreated file gets the UID and GID of the task doing the
>> > restore, and the task's cgroup gets charged with the memory.
>> >
>> > Once preserved, the file cannot grow or shrink, and all its pages are
>> > pinned to avoid migrations and swapping. The file can still be read fr=
om
>> > or written to.
>> >
>> > Use vmalloc to get the buffer to hold the folios, and preserve
>> > it using kho_preserve_vmalloc(). This doesn't have the size limit.
>> >
>> > Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> > Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
[...]
>> > +     struct inode *inode =3D file_inode(file);
>> > +     struct memfd_luo_folio_ser *pfolios;
>> > +     struct kho_vmalloc *kho_vmalloc;
>> > +     unsigned int max_folios;
>> > +     long i, size, nr_pinned;
>> > +     struct folio **folios;
>>
>> pfolios and folios read like the former is a pointer to latter.
>> I'd s/pfolios/folios_ser/

folios_ser is a tricky name, it is very close to folio_ser (which is
what you might use for one member of the array).

I was bit by this when hacking on some hugetlb preservation code. I
wrote folios_ser instead of folio_ser in a loop, and then had to spend
half an hour trying to figure out why the code wasn't working. It is
kinda hard to differentiate between the two visually.

Not that I have a better name off the top of my head. Just saying that
this naming causes weird readability problems.

>
> Done
>
[...]

--=20
Regards,
Pratyush Yadav

