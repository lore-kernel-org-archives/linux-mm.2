Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B322F8A14D
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9527C6B0005; Thu, 16 Apr 2026 05:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903AA6B0089; Thu, 16 Apr 2026 05:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8198E6B008C; Thu, 16 Apr 2026 05:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FFE46B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:41:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22B541B8848
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:41:22 +0000 (UTC)
X-FDA: 84663926004.09.E8CA445
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7EF39140009
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:41:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OdMSTtrE;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776332480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNY0efeN81fPPEk7hSc0vbaPFWkcvmDpUyEhycoFZW4=;
	b=EuCt/5MW0RJeR34opLOSQTAZaExTgQTrFGZNAbABzLUrwn2Y3RBLU7TgVwCO5ZdANkzpMp
	o+vcPrCFjSavtTUsgqp0tKK3JBFtyn3xdUxsvMRFWAVh36hxnFUdHXvd1KYOpuDRAZXdU2
	2xLi3EryanGnMQ1sJOIVIR5Sfsaq0Aw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OdMSTtrE;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776332480; a=rsa-sha256;
	cv=none;
	b=eRHl99Wbss9RMj/mxRdsBtEmnVSI52Y2zB6rcyCz3R8hTx2ugfWs7eNQvnfBBd+dy+MsHi
	epoC8G2av30QJBGEq8lmInwjQH/cPJ8Gn2ugg1Cx1l2erRN770MUGMdUoyiODrYfG3db4g
	NnJkDivX2kBl3gbI0XOH0+SmNb7K/8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B6A2D60131;
	Thu, 16 Apr 2026 09:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5D1C2BCAF;
	Thu, 16 Apr 2026 09:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776332479;
	bh=2alzcICEC3k3e6IxHUG9ZYQslVBWBu0n2/gQ20xdRCU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=OdMSTtrEFg4+AGBw878XaR6uOAeNGvy/8yLqfJgPzBcEDzZ5fp6NaaNoMwboYXmJ1
	 7txHfU9adWdlrfIaaFQAscBcBAs5h3myYVDtGYstooiXzpqVeIB4kVus2LLAjrcieY
	 rmTVnpOms3yewsFmqwnNSGQlTlvPiRRPgon8/uNrdU6ecf8bErhYWfmzo/VDNL91y1
	 mmE3niwtXR2kS0wlP5YmV1LiquITUyAkMuCGQprFBcxlXASwnBIQzy78QiyVSkC3xn
	 E1uTWzoeDUF81anyAgjfMsoOTLa8Of82Jte969TF2IuQty8jNkGyAgF8HL3IYFMtKX
	 Cp5v8B/Fb59Rg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  =?utf-8?B?TWljaGHFgiBDxYJhcGk=?=
 =?utf-8?B?xYRza2k=?=
 <mclapinski@google.com>,  Zi Yan <ziy@nvidia.com>,  Evangelos Petrongonas
 <epetron@amazon.de>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Alexander Graf <graf@amazon.com>,  Samiullah Khawaja
 <skhawaja@google.com>,  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
In-Reply-To: <adfqkOWVFgeAkItF@kernel.org> (Mike Rapoport's message of "Thu, 9
	Apr 2026 21:06:08 +0300")
References: <CAAi7L5dSOxXETv-bYs4hJ1SfixMBQXS4fmfKs3SzVvQ=yY7oSg@mail.gmail.com>
	<76559EF5-8740-4691-8776-0ADD1CCBF2A4@nvidia.com>
	<CAAi7L5ex+66qgFzRkLDbuOmC=cVrMyBctPZv6wd15n1rc2U9KQ@mail.gmail.com>
	<0D1F59C7-CA35-49C8-B341-32D8C7F4A345@nvidia.com>
	<CAAi7L5fvUPUqd3A4m6wubeYh90NH+S2KBRE1R8WKerBYhkU8kg@mail.gmail.com>
	<58A8B1B4-A73B-48D2-8492-A58A03634644@nvidia.com>
	<aburnbP64n9axmu_@kernel.org>
	<CAAi7L5evx8ta8BifNiGNfUoTiaBUsv4cgQRbm_15RoAfdKPcMw@mail.gmail.com>
	<acAAp4JaTGn_STBH@kernel.org> <2vxzwlyj9d0b.fsf@kernel.org>
	<adfqkOWVFgeAkItF@kernel.org>
Date: Thu, 16 Apr 2026 09:41:14 +0000
Message-ID: <2vxzo6jj6y4l.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: z8jqm7y5z9h9zmngwmun8ey1xyyuimai
X-Rspamd-Queue-Id: 7EF39140009
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776332480-910874
X-HE-Meta: U2FsdGVkX19GE42FLViEffApUSuq9i3FzMMJD9WlsW0XKgBY4NXUEBqCqfAaQgagVmX9dTDFU31pcVNUK0GWDQvi1bFaMut9Ve2R2QHd+nxeevZwCeX61lvhAGjjshBqgVx3rgNWQ/XnkuJ12U7Rq8tFUrdW9X45VG0J+FNxY4otcYeJNmeg0q4GaMXqphrOoIdLQZKAcfb+Mri13hYUW6olZLx0F+4lr62mFHeF89RCILwkJb+LZGQjPRUJXjyATV1pvtXdvCnD1GDyzJw3skGQceP9FuUs79bW0ukXmj5i7AvkOo5ICz9gNC8uH+8L8Cakts8VQgiJ+ELJzE6a6HxCrdbeTbtd+QtElJhpgXcAs08oDFxzs1ZkQ7Ls4QgYexo2giv+k0DSrHiu3oNR6M2u2xa4v/z34cpaKEZ+kFlwFnHaXro2PiTI6VGDwPmfPi0v0MdzaThy9HXYnkgv6gYS+Qy6zE3Mqjp6Q518XftusH+Gi4CXdygE+ZESPGhc5FZSHixiOeZ03b++GK92qDAH5WFl6OJRopaBy7UNM5vpPiFBtNYw0leUJTu6t0rTF2LEclgMKxOR/ntzLEeoFpYsiV3TvRyfBkWWWrTVkcK4SH4pLeqfw8/u7+7d4WzwbJzA+U5fHQlQMi1ob05Jwh7YRbdj+/NbS+bPTOyi2AKVrND8NniOUNk5tM4UWt/j8M95N3wp2P8foGW2ic0IytdvJPKQ/8Vhxrf5TUkSZXFH6KO9sE/TALCF8/sV6gVkIc6O9xtABQTvcZl9eHZILrcvkJZ4zYls/ZIoERS1bpj+F6/oV9bQbeszUeMCcxvkRDa8uICxwU8NsF8MqCbqBoUUqZmPamX7Fseb3V5w2OHWsApQJ25rfpc8IRseiAZjTWnk1Y25WdrLEKcmUWfFGWVw29NrtA0SBDzZojGnFtOKYkWbsvDC9RDDbi0gEGNvyJCf26vAFhfKOWg7qCW
 4wqM3BEa
 7UdK55Ei2WZj+oy8NJfm8iW9mC7B+u+s+7WWl+w2EeEmCadzsA5Q+3n4t/8Y0zBfXrOCiLu4YeMsX/a0wKE/7mHTHLhq3WJIVRqMhbDAHhmdUtezeWiSMD8as2cMYVNuwmKw7h+QA+WVhsuOCZYx+80nFVE/g/b1khsyYmIB9eTGn20B8uUVmzizUc7oTHVConp5jixKQuaoL/dEHPUJyiKTh/7D4biQk/35K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09 2026, Mike Rapoport wrote:

> On Tue, Apr 07, 2026 at 12:21:56PM +0000, Pratyush Yadav wrote:
>> On Sun, Mar 22 2026, Mike Rapoport wrote:
>>=20
>> > On Thu, Mar 19, 2026 at 07:17:48PM +0100, Micha=C5=82 C=C5=82api=C5=84=
ski wrote:
[...]
>> Can we just get rid of this entirely? And just update
>> memmap_init_zone_range() to also look for scratch and set the
>> migratetype correctly from the get go? That's more consistent IMO. The
>> two main places that initialize the struct page,
>> memmap_init_zone_range() and deferred_init_memmap_chunk(), check for
>> scratch and set the migratetype correctly.
>
> We could. E.g. let memmap_init() check the memblock flags and pass the
> migratetype to memmap_init_zone_range().
>
> I wanted to avoid as much KHO code in mm/ as possible, but if it is must
> have in deferred_init_memmap_chunk() we could add some to memmap_init() as
> well.

KHO fundamentally alters mm init, so I think it would be hard to keep it
to a neat corner unfortunately... We have been somewhat successful so
far, but that has come at the cost of performance. Once we start trying
to improve performance, I reckon more and more of it will spill into mm
init.

>=20=20
>> > @@ -2061,12 +2060,15 @@ deferred_init_memmap_chunk(unsigned long start=
_pfn, unsigned long end_pfn,
>> >  		spfn =3D max(spfn, start_pfn);
>> >  		epfn =3D min(epfn, end_pfn);
>> >=20=20
>> > +		if (memblock_is_kho_scratch_memory(PFN_PHYS(spfn)))
>> > +			mt =3D MIGRATE_CMA;
>>=20
>> Would it make sense for for_each_free_mem_range() to also return the
>> flags for the region? Then you won't have to do another search. It adds
>> yet another parameter to it so no strong opinion, but something to
>> consider.
>
> I hesitated a lot about this.
> Have you seen memblock::__next_mem_range() signature? ;-)

Fair enough :-O

>
> I decided to start with something correct, but slowish and leave the churn
> and speed for later.

--=20
Regards,
Pratyush Yadav

