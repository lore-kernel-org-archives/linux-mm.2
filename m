Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71738CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A558E000D; Tue,  2 Sep 2025 07:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23CA8E0001; Tue,  2 Sep 2025 07:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12198E000D; Tue,  2 Sep 2025 07:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B61D8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BE9113B8A5
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:14 +0000 (UTC)
X-FDA: 83844164628.05.9032D38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6AA9740012
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:59:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qlfauluX;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yp/fSPYU0GvGvT2yHJH8dhf0ano+M6K7ZvLXNtQbg8o=;
	b=6emY+RKBlZvrda6WRlMGSqZT7OI9UbA9HavNEB0snO9NfzaNdL8GcnbB5i4UL8v6ng7Vns
	/cC1evU7gLFmiXxAIcJITfFkEgt/YlWjx3OR3At3xfKfsSV9vQ3Ld3j0soUSXMASlMnCZN
	O8xZOwLZrzhV1TvVeuVKo//sJD5niug=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qlfauluX;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814352; a=rsa-sha256;
	cv=none;
	b=X9nvN8DZ9c6rasVYDO/R+mueAqJLDrA0hFZjjx9kf4hXi1dmTUYdZeQYaYTMit7Ab3/G03
	GgcIp68UkxPzHJe2kStCBAEDBCbIWo9Wu5paocq5/wat+Q1D6TlGtja+ZLq7L0hs+CYFkY
	WKTr5+AvGw800HgoEeVlJ+r/JTQ//2M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B9D043885;
	Tue,  2 Sep 2025 11:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C02EC4CEED;
	Tue,  2 Sep 2025 11:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756814351;
	bh=L1nH0nXQSTmGQMPXIz8uvF0lJhnD30PA+J/QkPBeCK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qlfauluXXRsFwdzO38odnlUZfYgoe1CFxonN5cpywYXv/xECjHvycDgDUatmFw6ia
	 mUBDe5ELuiqS8LGCHYzjqgY9atl9gzcJssdfaXwr1lZtfNIX+aFH9UpdxKVWr2hY6o
	 VDLCD80ua4Jz6DivTFtnW+4o83n4pkdiuavOJlynXYAeyflZipfyz6W8Oc25vrDK06
	 V29Vfpbmwl5PHuDi2Rr+x1QhtvO48PuKGszUIh2E5zTCPTSEE1+2o43q4S0XKjtdNU
	 JBHIBh4AmLL5ANN4WvPQ4ZSZLskhnZK0dslMn8n6iV2b6JEvBe14AOjuZFUh5A59jT
	 OoRg1GK9oxOYA==
Date: Tue, 2 Sep 2025 14:58:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, pratyush@kernel.org,
	jasonmiu@google.com, graf@amazon.com, changyuanl@google.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
Message-ID: <aLbb9nOUnBo_ORT0@kernel.org>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com>
 <20250826162019.GD2130239@nvidia.com>
 <aLXIcUwt0HVzRpYW@kernel.org>
 <CA+CK2bC96fxHBb78DvNhyfdjsDfPCLY5J5cN8W0hUDt9KAPBJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bC96fxHBb78DvNhyfdjsDfPCLY5J5cN8W0hUDt9KAPBJQ@mail.gmail.com>
X-Stat-Signature: yxk85575txqi38sx9aupqorjgkkkruoj
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AA9740012
X-Rspamd-Server: rspam05
X-HE-Tag: 1756814352-48050
X-HE-Meta: U2FsdGVkX1/3oQ67WCh2tC8D9KMKQ/XB/vhiKp2k8pRfWFQ0nV2lOJUdOa2YKVk8n004VarU1twFyhnQcigM+1Zg08Z3iHoNBykZrk2Ga+GUsbXPULqH05FJbODO7aExJIrTcopIXf8bvcIbW01Esc4nfaNgfMMVlVWKEAM6FMf7qc/NPPmetSSM22MUcCUQ3LovFbN1iN0Td9Tqba0drpys5Ouw+s/pGUMfN5EHzuQtk2WiWhq9vf4dS7UjpgzEiwfOEzUOcmKla9pZMmtLxdU+Es/1Llng+4QE7OPiwpoyzJHGLtGakmbofv8UvGseI9JVR4Gl2hRQQipaSE+YrENQQmVG4NUUqWVoqObpG512xXSzaZRwsODBs4ktgvzmuOWLKUYPIGOPszTLm5iz0+E04N6po5/Zwe6g/suhEELG5jyWvkM//U3vCXMr24r5a60fw85kIJbsj8b9GGPAYLIWkK7uh4uWsWjmMfnTxKAbTURiqOlQ4Se16tW2rpNRo9G5548X/6kyiws9tJ0gGNfEGMhCLOlpgJBpLyFlUVXMm4CRLvYgK7aPX902WhNuSeLJKEYswn+CEvlyWyPHusm2479G/HNpRfktQVDl3FRKm0BwFqt5/AmmoEKZh2tEuQKCucy3X/5vOh8+SdNHSQCSqSCn43b9cHLqTgcwd5ODp/PGl719/6kPnOAdl0bEX7PgWMpLEO2YdS0UhOvb80L3lhepgAW5Y+Gzak8m0+CxFPL0UiQwU+DKDILZ9cvIpUu2m7jdf1WOy7oa356BOmqs2fLO2XMl9rjhdr+4IyUxBX1ADyiaUghIPei2KA+Tn7Ob36O/yvLPjOh387rrHLE3wnCpnPhpaKTAAQZzNyMremDQE55xImvs/+cFHV4wFcxZZ3qbVK2GyINSrTUXi1iOtpYeolRu1PcFyWV3J12S0jv+M/xZ0VZRkvjwSqrD5BZvQ5tVYikKTwCc8IH
 Ir9iGpxO
 NI/hwQ/3O7pK+4K4SlQ3neAZ0oAJtdzmow8ARhysjIi1fT3mr/ZB/qNQO7o/WK+t0FJEVi6Xq9cYcjrR/GCi5WDZRR1idCREauRiH1UKNXf59kF2n9zSQg9mIk0PAwEfmiZq/OmGD0k9SQkgXg9w2RK3S/p8NumPwbJz1WScosMzyHxOrBkzcgG5GYeRrB4ORJh3l8fvpPgwxuPkYA+jCB1Z40AkRC2XinYB1dCgdZfinysfUW4nE3a/2RVgNqFWROIUhn4xp8JAtIPxmmK0BNQCIcSEI7Kk9vnVJS78qFTpezb3mGXyk8zPHvQAjFZyB+HKd0esS+rG3dhtIth+G6PbCNOEvuB/wkf2ccKIR9dl3nrZwWOUZps4eAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 04:54:15PM +0000, Pasha Tatashin wrote:
> On Mon, Sep 1, 2025 at 4:23 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Tue, Aug 26, 2025 at 01:20:19PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Aug 07, 2025 at 01:44:35AM +0000, Pasha Tatashin wrote:
> > >
> > > > +   /*
> > > > +    * Most of the space should be taken by preserved folios. So take its
> > > > +    * size, plus a page for other properties.
> > > > +    */
> > > > +   fdt = memfd_luo_create_fdt(PAGE_ALIGN(preserved_size) + PAGE_SIZE);
> > > > +   if (!fdt) {
> > > > +           err = -ENOMEM;
> > > > +           goto err_unpin;
> > > > +   }
> > >
> > > This doesn't seem to have any versioning scheme, it really should..
> > >
> > > > +   err = fdt_property_placeholder(fdt, "folios", preserved_size,
> > > > +                                  (void **)&preserved_folios);
> > > > +   if (err) {
> > > > +           pr_err("Failed to reserve folios property in FDT: %s\n",
> > > > +                  fdt_strerror(err));
> > > > +           err = -ENOMEM;
> > > > +           goto err_free_fdt;
> > > > +   }
> > >
> > > Yuk.
> > >
> > > This really wants some luo helper
> > >
> > > 'luo alloc array'
> > > 'luo restore array'
> > > 'luo free array'
> >
> > We can just add kho_{preserve,restore}_vmalloc(). I've drafted it here:
> > https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=kho/vmalloc/v1
> 
> The patch looks okay to me, but it doesn't support holes in vmap
> areas. While that is likely acceptable for vmalloc, it could be a
> problem if we want to preserve memfd with holes and using vmap
> preservation as a method, which would require a different approach.
> Still, this would help with preserving memfd.

I can't say I understand what you mean by "holes in vmap areas". We anyway
get an array of folios in memfd_pin_folios() and at that point we know
exactly how many folios there is. So we can do something like

	preserved_folios = vmalloc_array(nr_folios, sizeof(*preserved_folios));
	memfd_luo_preserve_folios(preserved_folios, folios, nr_folios);
	kho_preserve_vmalloc(preserved_folios, &folios_info);

> However, I wonder if we should add a separate preservation library on
> top of the kho and not as part of kho (or at least keep them in a
> separate file from core logic). This would allow us to preserve more
> advanced data structures such as this and define preservation version
> control, similar to Jason's store_object/restore_object proposal.

kho_preserve_vmalloc() seems quite basic and I don't think it should be
separated from kho core. kho_array is already planned in a separate file :)
 
> > Will wait for kbuild and then send proper patches.
> >
> >
> > --
> > Sincerely yours,
> > Mike.
> 

-- 
Sincerely yours,
Mike.

