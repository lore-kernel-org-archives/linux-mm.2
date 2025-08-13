Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE34DCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D024900086; Wed, 13 Aug 2025 09:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45A07900044; Wed, 13 Aug 2025 09:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2860B900086; Wed, 13 Aug 2025 09:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C7E8900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:55:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CDC5D1379D6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:55:34 +0000 (UTC)
X-FDA: 83771881788.04.E98AA79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EA71A20018
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:55:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gnkAXrTO;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755093333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V80gVhJ6ALqPLDb5wwnYcFx6wZC7yR0HZ4/7SUWgmWk=;
	b=IXBDU+tcWDFAngFJ9IJ0stXiidtI6HJx+J9aUSZ/g69X2E5PQAA7SUYynv1Wn3GIQDyEYl
	/JjqmBtlGJktR50DM67jHPmZrID6gLwMbX3dgXX5DMWFwBKKp6mOK//sG7yjI397Wmyc5b
	Na1HEKRhWIvwxw077b1Mb6+nhTugPXI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755093333; a=rsa-sha256;
	cv=none;
	b=0RKLWluqmroCSDzpFNI+zHqhCbQ4/skzM5SVf3mEXJ3Dyv37KOXKMxhxd6V4CQcTU6z4hI
	bGNqyoahpzMFdOz0JR/JflfnmkLdPNLIgRWzrNYyCR4wRZi31NH5FyLfMlrCdVJaRFgW9K
	cWrcKK6nIQuA/Kr8bwBVzdKHfMwtpHQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gnkAXrTO;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BEC4A458E8;
	Wed, 13 Aug 2025 13:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A15C4CEF6;
	Wed, 13 Aug 2025 13:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755093331;
	bh=Z1FONCORgDMbbWMlyIGq1MppJNSEgOqZfpdQRbvLW+k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gnkAXrTOpFI3ROP15wctp09tBwFzwxci6h4Y8PgwuC2CQV+he2WTSZRR+FnjF9f1x
	 Pj07eQQVvToM6lkX1x/CDTozJVGPCLh8LDQ269n3k9lJmMdq4K3oPPOP/Dc7HCE2Fy
	 0Ly35zrERwLE+KC5jD9+Y7eZHFOkJnC0wYk7pnWzfyehBIuVpu3pfe/eA7fu4oMh+E
	 ZnmTH/cjAeavuoGSKKUP4jITmVsFPU5mprGHLDXDgE4BwnQRwHn1oglWjqJBsEeGbD
	 axkt0DApgFSBC+AYL/rPSXnMQBqqfKXKyW7pWJMvrcL2WijEfmbxTjFYH6Yf5JDvGD
	 5oB8EUJC2Qgzw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Vipin Sharma
 <vipinsh@google.com>,  jasonmiu@google.com,  graf@amazon.com,
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
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
In-Reply-To: <CA+CK2bCmQ3hY+ACnLrVZ1qwiTiVvxEBCDNFmAHn_uVRagvshhw@mail.gmail.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<20250813063407.GA3182745.vipinsh@google.com>
	<mafs0wm77wgjx.fsf@kernel.org>
	<CA+CK2bCmQ3hY+ACnLrVZ1qwiTiVvxEBCDNFmAHn_uVRagvshhw@mail.gmail.com>
Date: Wed, 13 Aug 2025 15:55:21 +0200
Message-ID: <mafs0tt2buy0m.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EA71A20018
X-Stat-Signature: x1hsydqzzyo9bfbdkx1jyj6s9woo9t7h
X-HE-Tag: 1755093332-1618
X-HE-Meta: U2FsdGVkX19Zb1qCmky5BxTWM7itq/L+n2rH66OoJU3QJZJ2rUOON/6RwOgXhwKeWy/NlnIUgEL9gqjvceKOkWtuQsG3HJuiehDA5EREzIDUQQf1SDmHAjpgV3T6TxQsQz54IU76jZzGx76fDZC9KtFZBQ2qQYA7tJCYYXtB/0JLtJbDQIjZyYChLtTRaYBD3HiKdiczIPsUHUcJUcvFs+9ADETRd+TLVc+gOyWJ/NfWfH+UCuJnWR2xWhT0oKCheyq1767zYRTF7Py/2OYUIH1DsLeN6A6UzyKo9xtik0dy9mfJpX7sUDclmJSEDHu5Mk8yHS1+ygT8329nOgwTA6GIq8s1YI2gOJKL35XD5LFnGLFYpCFmFYqIkQYVWlgQuT1/0wCdKgHb5oJ8nszNtvdSwkCsgVrAACoIngpQdvTkaVYehCNxZF0FRVxXqbdJNXeRHcPtBxOrSpDPhj1szjm8a0Xtd22odUGchDpBmghEj3vtTt1pOe4Q9u6w32sYlAoTducg7GM9yZfiglDFavKZ+mKqWHuvykw9vuEsXeh0/dhrHlP3IssNkm947iqetXjlIkTxQtgHasvak7PX7yWxcahAyQ7yrVFeYRuG0kqLWfVtuj+c7m23r7dCkcRib+bk2AR/Uja/X/4oPAA1HCh1rZpPJk7AdaEi0ShwCbfJhtnp0xOdWq2AEMdfB8jIgk5iM/T88Oa8IWGOOIV+uww89ZKCzh7+d48RT2CevW2wy1+U+Fn1BlW4tACkt60fSBDDGET/8m3y9U+tf1CEwskVEjYHGKkUvvT/uudmqBtDJK6uU0ZqdwS3dGGQeBzLZNszooUU9576wJQ/DugEmXTHIt2NIU4tDq4f1qYtLcTJNzj0eoPxwr0Sp4mA4Jhkt2v1A+mhXMJxVBa7MoA96OkaDuCQTS3XDGKbA5Se9dL+NurCD3vm0dEBMZ2I2uuq0b3P22UkFhylkvkiA4k
 TJmfI3Dn
 H5DcvlYBgMpnAQtO00LC0nRlFSUq90B2kEVN3XUsIgxi4Vcij90yWEJa6z78CgzknnBIRnrEZKppgeQ3BUwWw/w6ZU0N32yuJPcrvrD801TIljKyLHN7fk+UdAFSixaa94OuMdjk/SUVogXn9WGcMXZw7CC6RfbVcORMsrVLsXVDjDfAwHE+bS0y4MZWC5z5GgraJ2wEnEY9GhB8mcoavUYhQIXTj0e1rfAiTwMplJksRnK7c+OC4VKV87O/TKai/W7fbGgiiF4WWytTe+4aCuP3cNDIGfwpGe9g9BCTigGLmqSlGgqVFm/Rvzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13 2025, Pasha Tatashin wrote:

> On Wed, Aug 13, 2025 at 12:29=E2=80=AFPM Pratyush Yadav <pratyush@kernel.=
org> wrote:
>>
>> Hi Vipin,
>>
>> Thanks for the review.
>>
>> On Tue, Aug 12 2025, Vipin Sharma wrote:
>>
>> > On 2025-08-07 01:44:35, Pasha Tatashin wrote:
>> >> From: Pratyush Yadav <ptyadav@amazon.de>
>> >> +static void memfd_luo_unpreserve_folios(const struct memfd_luo_prese=
rved_folio *pfolios,
>> >> +                                    unsigned int nr_folios)
>> >> +{
>> >> +    unsigned int i;
>> >> +
>> >> +    for (i =3D 0; i < nr_folios; i++) {
>> >> +            const struct memfd_luo_preserved_folio *pfolio =3D &pfol=
ios[i];
>> >> +            struct folio *folio;
>> >> +
>> >> +            if (!pfolio->foliodesc)
>> >> +                    continue;
>> >> +
>> >> +            folio =3D pfn_folio(PRESERVED_FOLIO_PFN(pfolio->foliodes=
c));
>> >> +
>> >> +            kho_unpreserve_folio(folio);
>> >
>> > This one is missing WARN_ON_ONCE() similar to the one in
>> > memfd_luo_preserve_folios().
>>
>> Right, will add.
>>
>> >
>> >> +            unpin_folio(folio);
>>
>> Looking at this code caught my eye. This can also be called from LUO's
>> finish callback if no one claimed the memfd after live update. In that
>> case, unpin_folio() is going to underflow the pincount or refcount on
>> the folio since after the kexec, the folio is no longer pinned. We
>> should only be doing folio_put().
>>
>> I think this function should take a argument to specify which of these
>> cases it is dealing with.
>>
>> >> +    }
>> >> +}
>> >> +
>> >> +static void *memfd_luo_create_fdt(unsigned long size)
>> >> +{
>> >> +    unsigned int order =3D get_order(size);
>> >> +    struct folio *fdt_folio;
>> >> +    int err =3D 0;
>> >> +    void *fdt;
>> >> +
>> >> +    if (order > MAX_PAGE_ORDER)
>> >> +            return NULL;
>> >> +
>> >> +    fdt_folio =3D folio_alloc(GFP_KERNEL, order);
>> >
>> > __GFP_ZERO should also be used here. Otherwise this can lead to
>> > unintentional passing of old kernel memory.
>>
>> fdt_create() zeroes out the buffer so this should not be a problem.
>
> You are right, fdt_create() zeroes the whole buffer, however, I wonder
> if it could be `optimized` to only clear only the header part of FDT,
> not the rest and this could potentially lead us to send an FDT buffer
> that contains both a valid FDT and the trailing bits contain data from
> old kernel.

Fair enough. At least the API documentation does not say anything about
the state of the buffer. My main concern was around performance since
the FDT can be multiple megabytes long for big memfds. Anyway, this
isn't in the blackout window so perhaps we can live with it. Will add
the GFP_ZERO.

--=20
Regards,
Pratyush Yadav

