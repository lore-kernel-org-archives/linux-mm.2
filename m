Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6407CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28DEB6B002F; Mon, 24 Nov 2025 10:24:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265346B0030; Mon, 24 Nov 2025 10:24:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1986B0031; Mon, 24 Nov 2025 10:24:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 094796B002F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:24:46 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B56E2896A2
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:24:45 +0000 (UTC)
X-FDA: 84145872930.17.E4D431B
Received: from sender3-of-o52.zoho.com (sender3-of-o52.zoho.com [136.143.184.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id A82E8140005
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:24:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=g7i8o4iN;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf09.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.184.52 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763997883; a=rsa-sha256;
	cv=pass;
	b=DfwUGdZr54RcZRVx93IVhFkVOOQCab6D2kQ+dnIV7IeYAiAw+qHIzHdXWwBNtzxQTwl0ud
	7TBBDI74fHDsnkI9QJ+xW+p9N3jDHzpi6inDflq3dYOM6xK2kyDlbN2ehNOye6v12u/K2p
	/3YsHkgkHoh91bH1cZKW/R3UvZBbJBs=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=g7i8o4iN;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf09.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.184.52 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763997883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEXtvNdRE9uegVpdOCTTCGjA7xnKIaXPCGqm5liMLPU=;
	b=rcFMYix9L8T8nqKbCAvarbZV07OLgrFgLFEUL5PtQkMFNSK82CF+B5Sc69yjOFwUv2/QJ2
	i9mrkM/HJ1GU2biikgIiWkavI5razREAlyAudRgZCqHjO7D23JQZUshq+Syng18+9yUFHl
	n0UC4HcZ9XvYyyWWx0C6KTK+ls0sK74=
ARC-Seal: i=1; a=rsa-sha256; t=1763997854; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=EBeJp5vovdKkETGoO/PoGM6fQch/V3O3FTzb7HeNuEJc3nbfaY/3s0w7ZeKqYUMQOzJI0wpjzJi2NP0sELcjqjmQbwAVzbKGGmIOYyoUI2toNiBl5CTCArY1plSD2qDURzTDfNb49bQG2JXHYhecjnqI2IY0utLmLbBXTxH+xXo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1763997854; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=JEXtvNdRE9uegVpdOCTTCGjA7xnKIaXPCGqm5liMLPU=; 
	b=DnKLykFjNgOQ0bm/xguwrAhqelgGOmZZcFd2KNp+8tT+Eo4Ld8meUh51pUci/k73U9dth5gh2gb/emFrhGM3Y+ESWG+bhncCDc4i71tpib1KPFKVU3QYDm2KHog512iCVjmF6LpAT1Gtgla6LeXbAr5mzvmypuax5hkiCYIaAqg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=mpiricsoftware.com;
	spf=pass  smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass header.from=<shardul.b@mpiricsoftware.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1763997854;
	s=mpiric; d=mpiricsoftware.com; i=shardul.b@mpiricsoftware.com;
	h=Message-ID:Subject:Subject:From:From:To:To:Cc:Cc:Date:Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:MIME-Version:Message-Id:Reply-To;
	bh=JEXtvNdRE9uegVpdOCTTCGjA7xnKIaXPCGqm5liMLPU=;
	b=g7i8o4iN2PFgR7mQtXvwdnLUJH2EFf50k6NSt0hhN7/g0AeK6EeFu0AomQlCPz0N
	vL/5QpyARyjDO8VKMaotluKYUkydi9f9Cw+PYCKxpGHbuP9yVVv/U6Vg7maKus/+RfQ
	IP5uf+OenlrehLjJ58dxExAr6z4zBIkJp5fTfQfk=
Received: by mx.zohomail.com with SMTPS id 1763997851456767.0702426220278;
	Mon, 24 Nov 2025 07:24:11 -0800 (PST)
Message-ID: <703387c8908a609c3de966574dfcf481c5a97216.camel@mpiricsoftware.com>
Subject: Re: [PATCH] mm: khugepaged: fix memory leak in collapse_file
 rollback path
From: Shardul Bankar <shardul.b@mpiricsoftware.com>
To: Dev Jain <dev.jain@arm.com>, "David Hildenbrand (Red Hat)"
	 <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzbot+a785d07959bc94837d51@syzkaller.appspotmail.com, 
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	janak@mpiricsoftware.com, shardulsb08@gmail.com
Date: Mon, 24 Nov 2025 20:53:54 +0530
In-Reply-To: <9d4774ec-41d4-4c6f-899a-991187e58897@arm.com>
References: <20251123132727.3262731-1-shardul.b@mpiricsoftware.com>
	 <36896775-5083-4b3e-9023-949de7722194@kernel.org>
	 <9d4774ec-41d4-4c6f-899a-991187e58897@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
MIME-Version: 1.0
X-ZohoMailClient: External
X-Rspamd-Queue-Id: A82E8140005
X-Rspamd-Server: rspam07
X-Stat-Signature: uxqp4wamxamrfcxxh1fwy3xg9gjky6qa
X-Rspam-User: 
X-HE-Tag: 1763997883-373198
X-HE-Meta: U2FsdGVkX19Qb7HRTHmbFo7x82v1DFPzxSA4bEYDcaJ6Tsc80e3ql/iVIhexp36K3djIC76wFVqT8OhoEZAv2EYz5d0nbqMau7A1UtnnWlrR2q18+V8NJeeGd4sF6A/YTeQyfjs+3+Krnewd4vxN/fcZAfumCGDInRg4mjciBHtzkkgCZOHB6ES2InFc5YitGJoVjRA8c6ZhVfSBAPScuVdWKy5nF5ot7UEqYDuJjRe85wlmUIPRKBA+z752vt1e05+ZcyZNngvJSnKLs+WIMlLWEMCHGKjORbM/03Yqxh4+qUjEgSBB/ex6RvsJ4RRomXvp3wXSAXhjGDN1oP3nXM+Fo8TLhF1PKwdVVBz4olD+Arhof8MDzpFxNr49EDCYQ85KAO/IoxnvnuJgxlHyEtaAvWrpCg4i+5hRtUiCMR8W0FQCUZTyeoYrk2qJRj/q+L+xnB0CYo+I413CvA30M36gzJz34rN8wLu4MGQzVmUWxmRMTncHZd8bhesyXuzsGqkV0HfRe2+hf+JeIgvcvYsyV+YrrfetmFf0DSWlI0OTTWREkOW5QRt7PKViQzbz4Hxom77dsjkr8SzOKPFu5dq1l8vy+iKqyLiPqEg5N6WDbuqqmjTHEsVJIk4oTBOi3ee0b89xxwzCsHHym6uycQtVrv5qQaRScCWXcmaixyExXXOg6BhUeM1R3GQhwbhviMN1r6Nkg/NYbtoRvlfcQRtJwQjZkgu3g3vGp+VbRrV6X6nA6NNOBvfhgqhVC28ZPCGYLyT5zJ5I9XjEKHVItwQs4Et0dIIfKpmOBNge62I+g64bU8WluiJ8aeX+V3IyUB25gIarI2HF4dfamhVy23Rn5X5oO5AHr3TA/o7zqG0/8zYhQEeuq1nDMh/ZGIGQaOkitLuxP6psvTgle39K8mRyjwlUNch62hNQVg70AnqdJu8CxTa+MioXv3jZncnM1ONpUdpUg09Z1Yqim/O
 KmvLJxlV
 yqeyLgG8yjyb850A9TIpUxsWhjtEwWhz2b5ZpxgMqN353KOXv8GB/VHvgG7HdH2oR78Ijsfzj6lfZR8wLPv9fxAdXUEWEFCChxtSrdG1EjEL8CaTvmOXE88QOaNx58e6KXy8a+6/tfCQzDYSrB9OAecxpHvw2rtCJ/ui4DJbALu9pgBQF/pWhb57fPtp6wMMciX9ydPkI5GlymE19UMvwnHO6Yn9D39ZsL58wpftoqxhpRw+IERpHnflpNOgXGErxV34gVAqIlImKLhkiT3lImP71hyHSJgxCSXHQRo7/5R2QbFz4H29UMoPmAsHfcAHENJCJfbL1MAuY3+wkUm8pI18zh0VPIM8gXK1OFl02jpgF8cbAQIuQ/V0S2t0InRX56NhrZaBIK1caNE9YJ+Zxauc33CwwRxi44md7iJmSQrJMzobzjPGhb2KHAqSI5mRebh5ymOuUOA5ZPKMPYSXgOdTxxugkVr5TdmAKZOxLGBovyey2HXZ/cScBVJAkO4qxrmWM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David, Dev,

Thanks for the clarification, that really helped straighten things out.

On Mon, 2025-11-24 at 17:16 +0530, Dev Jain wrote:
>=20
> On 24/11/25 3:32 pm, David Hildenbrand (Red Hat) wrote:
> >=20
> > =C2=A0Do you mean that, if xas_create_range() failed, collapse_file()
> > will call xas_nomem() to preallocate memory?=20

Yes that's correct.

> > =C2=A0I don't immediately see how xas_create_range() would call
> > xas_nomem().=20

xas_create_range() indeed doesn't call xas_nomem() internally. The
control flow is:

  xas_create_range(&xas)
    -> xas_create()
        -> may set XA_ERROR(-ENOMEM)
  collapse_file() detects xas_error()
    -> calls xas_nomem()
        -> allocates a spare node and stores it in xas->xa_alloc
> >=20

> > =C2=A0Note that after we call xas_nomem(), we retry xas_create_range() =
-
> > - that previously failed to to -ENOMEM.=20
> >=20
> > =C2=A0So the assumption is that the xas_create_range() call would
> > consume that memory.=20
> >=20
> > =C2=A0I'm sure there is some corner case where it is not the case (some
> > concurrent action? not sure)=C2=A0
> =C2=A0
> Someone else can put slots in the xarray since we dropped the lock. I
> cannot prove this, but surely
> disproving this is harder : )

As Dev pointed out, after xas_nomem(), another thread may expand the
xarray while the lock is dropped. In that case, the next
xas_create_range() retry could succeed without consuming xa_alloc, so
xas_destroy() should clear the unused spare node. Calling xas_destroy()
on all exit paths therefore seems correct and safe.

> > =C2=A0Shouldn't we just call xas_destroy() in any case, also when
> > everything succeeded?=C2=A0
> =C2=A0
> Yeah you are right. We should probably do
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index abe54f0043c7..0794a99c807f100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1872,11 +1872,14 @@ staticintcollapse_file(struct mm_struct *mm,
> unsignedlongaddr,
> do {
> xas_lock_irq(&xas);
> xas_create_range(&xas);
> - if (!xas_error(&xas))
> + if (!xas_error(&xas)) {
> + xas_destroy(&xas);
> break;
> + }
> xas_unlock_irq(&xas);
> if (!xas_nomem(&xas, GFP_KERNEL)) {
> =C2=A0result =3D SCAN_FAIL;
> + xas_destroy(&xas);
> goto rollback;
> =C2=A0}
> =C2=A0} while (1);


I=E2=80=99ll prepare v2 implementing Dev=E2=80=99s suggestion and update th=
e commit
message accordingly.

Thanks and Regards,
Shardul

