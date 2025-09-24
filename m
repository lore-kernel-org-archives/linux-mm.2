Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 863CECAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E14AB8E0014; Wed, 24 Sep 2025 08:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC41E8E0001; Wed, 24 Sep 2025 08:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4278E0014; Wed, 24 Sep 2025 08:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B78E18E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:51:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8434911AE62
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:51:14 +0000 (UTC)
X-FDA: 83924129268.24.07E80FD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id D3BF518000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:51:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YV9D5K7z;
	spf=pass (imf16.hostedemail.com: domain of stefanha@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=stefanha@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758718272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTQTYZTiz2YYOPaT/MkK88YrNEGe0k4y4vUiJM9oV9U=;
	b=cA0TSR9+DW1KKKX5vVfNectUGAgywOeyZkfOt/dERDrezv4vf/jGhTaM5eGZ4yVPVloiEj
	K1xvfR5F9rl3Fq4tPQyK+uomz0MpzSl178Ow841z29hQxYrH6ZIv+7U8Q19IRUnHjZZNng
	IjfMgmHwPovPslAin6EfIoB3neTQQQ4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YV9D5K7z;
	spf=pass (imf16.hostedemail.com: domain of stefanha@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=stefanha@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758718272; a=rsa-sha256;
	cv=none;
	b=cwV0JJxcVEEowHzeQhez3NNcOZ5cnClLKFMFgBfdaxYLG4rFi1OysfSoBr7DhUCAy/FUNy
	VxmjzmSZ7HwuRSxcgySx795+BLHGbLwod3OkAx8ieYSApdIqJefFbdvKhl7Vq6mCVBvGf5
	Z6jt++PR9OHJco2/Q4sRQnARnjyLUaw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758718272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RTQTYZTiz2YYOPaT/MkK88YrNEGe0k4y4vUiJM9oV9U=;
	b=YV9D5K7zrFEQSHmvSJ/Dnl89vMTFgjMwX5SmOPBftIl3NUCQ/W1FvHuHcp+qb8fR1StQNX
	TxCduNYIdPQWxGCO0HK841xOhIK4gfi/oGpvjB2LEy0zjf04QVA7y9XJNXI3DhcT2kBs3t
	ePP3VtGsvo6CMACBmh9HY8bRIKOBcOI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-471-PvkmhR6fP--M8zTnbb8_Mw-1; Wed,
 24 Sep 2025 08:51:06 -0400
X-MC-Unique: PvkmhR6fP--M8zTnbb8_Mw-1
X-Mimecast-MFC-AGG-ID: PvkmhR6fP--M8zTnbb8_Mw_1758718265
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3741919560B7;
	Wed, 24 Sep 2025 12:51:04 +0000 (UTC)
Received: from localhost (unknown [10.2.16.108])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EFF741800452;
	Wed, 24 Sep 2025 12:51:02 +0000 (UTC)
Date: Wed, 24 Sep 2025 08:51:01 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com, Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, multikernel@lists.linux.dev
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture
 support
Message-ID: <20250924125101.GA562097@fedora>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <20250919212650.GA275426@fedora>
 <CAM_iQpXnHr7WC6VN3WB-+=CZGF5pyfo9y9D4MCc_Wwgp29hBrw@mail.gmail.com>
 <20250922142831.GA351870@fedora>
 <CAM_iQpWO71vSV_0qXiUYeKYZMYF0xWNz8MrUVRkqKwDEtQvKqA@mail.gmail.com>
 <20250923170545.GA509965@fedora>
 <3b1a1b17-9a93-47c6-99a1-43639cd05cbf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CpzOrJ/+7+dHBlWP"
Content-Disposition: inline
In-Reply-To: <3b1a1b17-9a93-47c6-99a1-43639cd05cbf@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: da599e6jq7dbc1nb7349mqafbhix85jc
X-Rspam-User: 
X-Rspamd-Queue-Id: D3BF518000F
X-Rspamd-Server: rspam04
X-HE-Tag: 1758718272-821517
X-HE-Meta: U2FsdGVkX18z8H8AFC13y13f33Uv/N+c3T7gQ/XBTFCLwXAnseIVbHFqEQRNMGhnmTczxYSwRgytcbCTpVq/uydBOfr8fDM3WkcnK3uDQDlx9MXHFnSnUeVckmI2AidfRCpg1hl1YMm3Ei2tb+49SWZn1W7t/jn1WIqZhUnPTbILUNz+a+/HxWM9WQYriojYtdKFkuGiOYXGPtFywLUuHXfC68XIOdu13qvvgRsP+NThiBfs+Krr6zC1+eIC3d1sXgk0su0v/r3Fv1f6BuAMUaKfykygDZ9OfDE2dsTD7/tb2ovGScIRvGaen7ZrIZstS5pUYPTvIVhwXnWKBTomDRavO0WgVQpAg8bXkV8I79yq9fmQcHTwPPmKwg2C47CcwCVP0YFPKXlu34dv+pLwrMiyzotrBFd5VzeVDCQVDWAtYHA6K53RxaKcDykaycpUpOm9kCCLSLZAwo6bffRmcQR4idXKbPtKYOUo167rfM2lBoiH4l7XKFMouuRNwoAnPg0bICZu/u7YZ/mdRh6cD5iyZ57mpzKfGW3o3khdCRbbShXeKjbfmkJQx3hBDHbKh5ZecC4f63WZ5HlKjLZThgpQh8f9Ta49arqtTW25NpuDFNz5FWFQ3iduzEfaZipn6G/HMWUYFLWu9VawT0y5Gw+GogGEBj/uvKPbTnKGy1PAsw5VUyVxn/xwGv21S3ec+zfOcIumC5wzTgsJcmRcF7CP/xlvNqQJHM7NQh9kaj6EvY9apqhKNmLNvW3zNIDbSEBrBL4xM8LtTP4KGUZHEeDl5a5BS9j7SY0rO8Yjn7AiBgDE5DbsDeQbeV4AdQVTP0fH9a3UozvYLj1z/G7o/LK0Y5Jen+RwsO9TehvVEDUxvtGBpkKzJ64usELGyeZlkRY1EJdruN/aAYqQBQyGGGmBKNXJjuKJNLFBetcPlVdgVhWLFZIfDZnZnKzAWmGdQoJWK/21fdEQdIhi5cH
 r+3A9lpE
 b+JlFe+CEuvVj1Hw0bPrltYiTPZY56ZUZRnS7kMftICkW1ItcvMUOM3EEXzChT3UYjxbg02IKm8+xHTe9wPadswQii9TLbsOOf6iS6zNDZOPshcdu3YCPXpsdK0ZL67Rcmelthsq74yQpB/efCmVDMPLNraeob8VOZ2EWZdowe7XVr+IUOrFYTkx8l7F/y6Y/6JyPVV3AfLqzJqg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--CpzOrJ/+7+dHBlWP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2025 at 01:38:31PM +0200, David Hildenbrand wrote:
> > >=20
> > > Two more points:
> > >=20
> > > 1) Security lockdown. Security lockdown transforms multikernel from
> > > "0-day means total compromise" to "0-day means single workload
> > > compromise with rapid recovery." This is still a significant improvem=
ent
> > > over containers where a single kernel 0-day compromises everything
> > > simultaneously.
> >=20
> > I don't follow. My understanding is that multikernel currently does not
> > prevent spawned kernels from affecting each other, so a kernel 0-day in
> > multikernel still compromises everything?
>=20
> I would assume that if there is no enforced isolation by the hardware (e.=
g.,
> virtualization, including partitioning hypervisors like jailhouse, pkvm e=
tc)
> nothing would stop a kernel A to access memory assigned to kernel B.
>=20
> And of course, memory is just one of the resources that would not be
> properly isolated.
>=20
> Not sure if encrypting memory per kernel would really allow to not let ot=
her
> kernels still damage such kernels.
>=20
> Also, what stops a kernel to just reboot the whole machine? Happy to learn
> how that will be handled such that there is proper isolation.

The reason I've been asking about the fault isolation and security
statements in the cover letter is because it's unclear:
1. What is implemented today in multikernel.
2. What is on the roadmap for multikernel.
3. What is out of scope for multikernel.

Cong: Can you clarify this? If the answer is that fault isolation and
security are out of scope, then this discussion can be skipped.

Thanks,
Stefan

--CpzOrJ/+7+dHBlWP
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmjT6TUACgkQnKSrs4Gr
c8glqAf/V/fg56oCmCv+HaFs3LvmQyEljhq0JJy17N25yTd+uBaKlL/RQs/qTsez
VrTtD5K5M/dKzlI9hpUM+/RzrxvYy65ZPp6CIfo1eBCRTUpmLZeUXYnZfjk/oU7A
8lL4qXt4sohUnt52FX6jT0io63SgZfzVa+ioe2WDZmh/YVkIi9JNjxhH5HJMuUPU
MxS53WDukYaEaBUJSi4cs/QdjcCudEzZBaeP1FjC6uoeZQ/3lT6Ozr0YGNeHHLUT
XRG0dL1oq9ABmi7Yy2UHwmqj+4cT2964SErwJUesi+a7ij4/ZL2osb1aurT098ZC
e75vuYwusPi8KJrYkzuXOLpAWMW6EA==
=+t3/
-----END PGP SIGNATURE-----

--CpzOrJ/+7+dHBlWP--


