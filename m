Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B211CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 07:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 994C36B0088; Thu,  4 Jun 2026 03:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945CF6B008A; Thu,  4 Jun 2026 03:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B226B008C; Thu,  4 Jun 2026 03:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 770096B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:10:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23DC3C1D4E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:10:21 +0000 (UTC)
X-FDA: 84841356642.13.29D4ACD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 68DFEC0007
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:10:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mTlK76AL;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780557019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhMxEQwcegOFcYLIZ9y5iV53bw04kwuyEtOBVhEDYMA=;
	b=MhhEHMM7gemJMeYYnKtk/T0ea67+ZltYnquXpk7xYeevhuzDSqxubEfpYjFoEGPOgjWP8Q
	qqquqyUQBeA7kRykbRJn4NPq4bRcsZka8+NBtucDon47HVPOC/LcJlOJeo4632lscJ3ZJw
	OvxuSyONnhJSlkS/ff8e+Qf8AY1Ef7E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mTlK76AL;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780557019;
	b=3T2V7Zr/iDZukUathncWKGObCaF59hPguLU3HyrjQyrElG7mIg9ooo8mwqvrQEI2wydwBI
	Jm8ffKOEYTtWmfRNwdZfHkKB5VU1UfWIY+i40GMe0FhQacBUFOPYgQEGFect+VqGD4EdsS
	5E/iAfP7DUfNd/pH04wTRzXxvWQmoPU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 46DFC43DF5;
	Thu,  4 Jun 2026 07:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724E31F00893;
	Thu,  4 Jun 2026 07:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780557018;
	bh=AhMxEQwcegOFcYLIZ9y5iV53bw04kwuyEtOBVhEDYMA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mTlK76ALzPHk/Pz+6x8nTHyAjcgK/SS+Mku9+Qi7I3SNA0dfcHu6BhFEs+C19pRU6
	 E5+OGsyWwtumgMG/WJ2Le0aae5LQxGXgowtVmcepxAXxMfqCWAilCKaYGk/5+kRVkP
	 4cO9j+hmH6qM30B4Ytx/qU6yvKs9erS3UMZLX0LxVk1/5u7oTpy2ME5T1T/npLCOGU
	 s4u+Pk89mJTbVKzFZ55WRg+drPIILWBGGd5p/DVxhd0Z2F7ICIpxvMp25Jq0zQa4Gy
	 HAb3eZDLpekHG+5x0DW3wia0LnDWOcTfGSaDl10ol+7lmMFjJhA3KS0hZK1C8ogR+c
	 F4m/GYKhfbnJQ==
Message-ID: <f027078c-6a55-463b-8938-95ede02dca3b@kernel.org>
Date: Thu, 4 Jun 2026 16:10:08 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, rob.clark@oss.qualcomm.com
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
References: <20260528093437.2519248-1-hch@lst.de>
 <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
 <20260529135045.GA10647@lst.de>
 <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
 <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
 <20260601113831.GA25535@lst.de>
 <d7b08296-7f6e-4d89-ab3b-04e43d04929e@kernel.org>
 <CACSVV00k-fxW6+waHNqvmYcnVNDkRexoWWprFzfayZfqdyMuuA@mail.gmail.com>
 <CACSVV00dNWgpNVU5rB=Hmg+3oWF18yTyfKNr_tWesjoP1jMxwg@mail.gmail.com>
 <5e6948b3-d235-4b61-aed7-e8b4d0f5b452@kernel.org>
 <CACSVV02v0Fuc6=Rqyd89D-_tcSjEXuQmxz0+2-4aoRAEwJE4zg@mail.gmail.com>
 <b6f6323e-6f5b-4928-b474-bd2743eac3f2@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <b6f6323e-6f5b-4928-b474-bd2743eac3f2@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------wiFRKWLl9yvmDjGQCVE2s47E"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 68DFEC0007
X-Stat-Signature: fetx693q6safoocb9gejut99okuy8x71
X-Rspam-User: 
X-HE-Tag: 1780557019-262544
X-HE-Meta: U2FsdGVkX19ZjdbQ/OHJxhx4f2fnRDx5mpN+EuI88/+ppNI5Atb2/KCwwqp/ZwlOJ2/ZRkEYNDURltx1l+1X4fjipjPnafjG30IZbYicTMBuIiUFOeq3DMo6RKMoHLBsb/Q11SoB7TpzefHXR2hFsSICivI7xp284mWkioUi5iLRYCHhu9GZ2SWgD/nkyWc3t0D99or+65nCp7mudwNPy8blv1dMTiXwN6TKD6vZQKrEjwVJ00uVak+YSDlIb1HNIHec2TvNfWJ+xUpnnRkFZy+lOtyS3PAfZZCQ2jBNRXbSMWdlqsPiesK0MuaBf82FgvFHgqK4VZZ2esuuWyB72ugxEbC/BO/f+goiHahyJ9JzHCaYb9waYi1KAvluxq5OeGZ9a8f5nZw8taGU3R4oyqVlwUYCXgbz4H4felyx9FXjxrjRnN8FjKYW//o9EmyQvb+v54TfS4zYEtX7UgnqwtUUPQXbJ0KfN/Y2G5tl4tvee1lRcJnjfJi/KcnBsLAmpuG7oMNVSDeRZRhf4fJlQLVy6LEKwW75drRxZlAnjGTTi2yZ+3kbBpTrTIwlK8IOlG6/rUiBCswhTzbOtS3X1dcd3FTqdeczC5fXNUM8B5s38uNaHSzkh2LexTyfzme8l5jAgejV5LY0SttyxjIxLMHFvPnHyn7LFajtG0cWegGCVMuuIyr/txlrw3VY2KUiLXYB297zv8ZmEbcAH0hjvNJ5t18pemOUbhEkR+CgQnhFjMPkMAvCxrjT9zCMwjSxMGi7g56vsXslA65m4k6OT6KXS3GSMMnw9IfYpYqvg5V8PJwc+deD9w33of9+v2U1qUnfFwXftzSQUtIaRTk3WagMah9HLbgtgFKg9DxGHhYqgMbK6lwxKQQx3e+7rcXAyRwYN2rqCXihPezhs57rzIVqj4sQASfQXq8Rb7q0adCWG0Hrs24xB6Ag9KNkIaju0UZYwEM/gu4Z3uwl27+
 0VGGcBUo
 BDACqfnNcDrofCYH0mLFsQoLt0i0odBaqlWnFre0PzoG22F9YVM3XAaZaYYpRKDCGXM3yVRPd5nIDln2XuqgCJzW9GTf67lupTC0QM5Thk29pFIeWyG5Jx+Gtf2mVIUcJHZTcdQPpSCnPYMTMC3FMNU2m0bG1IgXx0Ub3ajcndPmQoypUWOKFEyXOhJ7yqvZxNpIShKJD0v6HXQqMT8JYauBRzVt0CqZMlm48aoLnJe+zDvI2csrBOXL/kIUhPVoQCG2DpA36Eg6wIDYdjGRgnSm1sLwFqauSs+lOE9g005Zz6PKmMEWfCqT0MTEsksuM98ZxnkbW7ForXmdlinnoZfIsQQLAuNKHNx9DHjul+Sos5OFIUc8Geua+JQe3gHJbakFkLjUnAZoBgi+9Yx+RSvSdlMwfK2yAbccT5qcgH4+PobTjR61lbivj8h9NBsagLLCWf7xE/K0bbzNpA0JHm8UeFmVo/W7icmEUEJh0+Z/CIpTy047CZS3zesjxSTZbo1WMX1dlKDyp9WV6Wpy+M99TYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------wiFRKWLl9yvmDjGQCVE2s47E
Content-Type: multipart/mixed; boundary="------------wMYGC0PsvxX072tLl8xZovbN";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, rob.clark@oss.qualcomm.com
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
Message-ID: <f027078c-6a55-463b-8938-95ede02dca3b@kernel.org>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
References: <20260528093437.2519248-1-hch@lst.de>
 <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
 <20260529135045.GA10647@lst.de>
 <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
 <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
 <20260601113831.GA25535@lst.de>
 <d7b08296-7f6e-4d89-ab3b-04e43d04929e@kernel.org>
 <CACSVV00k-fxW6+waHNqvmYcnVNDkRexoWWprFzfayZfqdyMuuA@mail.gmail.com>
 <CACSVV00dNWgpNVU5rB=Hmg+3oWF18yTyfKNr_tWesjoP1jMxwg@mail.gmail.com>
 <5e6948b3-d235-4b61-aed7-e8b4d0f5b452@kernel.org>
 <CACSVV02v0Fuc6=Rqyd89D-_tcSjEXuQmxz0+2-4aoRAEwJE4zg@mail.gmail.com>
 <b6f6323e-6f5b-4928-b474-bd2743eac3f2@kernel.org>
In-Reply-To: <b6f6323e-6f5b-4928-b474-bd2743eac3f2@kernel.org>

--------------wMYGC0PsvxX072tLl8xZovbN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/4/26 1:22 AM, Vlastimil Babka (SUSE) wrote:
> On 6/3/26 13:13, Rob Clark wrote:
>> On Wed, Jun 3, 2026 at 2:17=E2=80=AFAM Vlastimil Babka (SUSE) <vbabka@=
kernel.org> wrote:
>>>
>>> We know p->pages is NULL in this case, right? Because it was allocate=
d by
>>> vm_bind_job_create() using kzalloc().
>>> And the job can't be reused with a leftover value?
>>> (msm_iommu_pagetable_prealloc_cleanup doesn't set p->pages to zero).
>>> Or should we set p->pages to NULL here.
>>
>> Correct, the job is not reused.  But I suppose setting p->pages to
>> NULL would make things more obvious, so no objection to that.
>=20
> OK, did that, just in case. Thanks.

The kvfree() -> kfree() part should probably be a separate patch
with Fixes: 830d68f2cb8a ("drm/msm: Fix pgtable prealloc error
path") and Cc: stable?

=2E..as the commit landed v6.18.

>> BR,
>> -R
>>
>>>> +
>>>>         p->pages =3D kvmalloc_objs(*p->pages, p->count);
>>>>         if (!p->pages)
>>>>                 return -ENOMEM;
>>>>
>>>>         ret =3D kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, p->count=
, p->pages);
>>>>         if (ret !=3D p->count) {
>>>> -               kfree(p->pages);
>>>> +               kvfree(p->pages);
>>>>                 p->pages =3D NULL;
>>>>                 p->count =3D ret;
>>>>                 return -ENOMEM;

--=20
Cheers,
Harry / Hyeonggon

--------------wMYGC0PsvxX072tLl8xZovbN--

--------------wiFRKWLl9yvmDjGQCVE2s47E
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaiEk0AAKCRCGXBN6rc5S
1v0/AQCTdSzVR1AlZpSbYogIVVB+443eCQzT7065V9OSIICLswD/e6Yg56WZBHlu
kh1s01feILBrZKf2TcrQ69haUSsKKgk=
=BoaG
-----END PGP SIGNATURE-----

--------------wiFRKWLl9yvmDjGQCVE2s47E--

