Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADD89606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TJ19gYVp
Received: by kanga.kvack.org (Postfix)
	id CD5FF6B05B6; Wed, 11 Nov 2026 01:16:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD846B05B7; Wed, 11 Nov 2026 01:16:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEB116B05B8; Wed, 11 Nov 2026 01:16:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 982D76B05B6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:16:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F94EC021C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:16:55 +0000 (UTC)
X-FDA: 85421829990.08.7D7BE4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7AA2C40004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:16:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TJ19gYVp;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794377813;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cs0evi9dVSmKWqiPi75Cnylb6/Wxv9tJ6r+A8LIBuRE=;
	b=t4p/Ad9OfFV0IeiSo7EVmqNCpGmvweRQDTEZQOUtFBY3La3TRC/wxGqZTcqJQhzPz+KMQq
	5/wq1OwGYNeSQAmlaFpQ8RvFeba/NPLD61h42kx5aV71tih84k+qYlkMIhfluct0Gwrjjq
	7zmtGM0DG22kuYhguf7jfXoFy7+DmtA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794377813;
	b=ofB8QUweqgYAWmZ5Jj0kdS2Jp5/IwltE6CsA8qh2V0KxZ1AItJ6vjuUS6jvAxUc7jaTSvR
	HBN6NCU7i02qzFJn1wmjxJ2rXRV/NtJFBh3suROe76QNN+YaVDO/orlAvXqimLcEScsLvB
	r+WnNK3foDKExaH8vQR57oZzl/eZYcI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TJ19gYVp;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7466444880;
	Wed, 11 Nov 2026 06:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E6A1F00A11;
	Wed, 11 Nov 2026 06:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794377812;
	bh=cs0evi9dVSmKWqiPi75Cnylb6/Wxv9tJ6r+A8LIBuRE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TJ19gYVponJXD+6bXVDXHTYShKtvx4kcBfVwQuS7qpbOzWRj8Pp+US+SAxz+Udt0Q
	 svT7zXCMBNACh8E1zYYtOhtP9+zlXPJtNcVsiM03nuZVZoz5nqfBwsj+3GD6N0k5NZ
	 sRnybVSechBWdKccJWIc2b+VF88rIjd4wikq3LoCuAKD4JiN/Lo1S8bDqCEB48nAl/
	 xn/xBGef74dOtIMPWFnhCYH1ClDI3VARcH4/lPQ94XXZGeZd8zdNYdIGE+xYO/ajVm
	 jLOxNdr10MlfUw+3DdwrRxoUo7o/5FkniBmLmn2RYbgz5Yjb4OfmpvIfDucaGGLNEf
	 u4DA/vs9XvuGg==
Message-ID: <sashiko-outbox-208417@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 14/19] liveupdate: Add feature header to struct
 luo_flb_ser
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike
 Rapoport" <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org, will@kernel.org, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, "Bjorn
 Helgaas" <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, gle.com@google.com, pbonzini@redhat.com, "Andrew
 Morton" <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, "Pratyush Yadav" <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, skhawaja@google.com, sagis@google.com, linux-mm@kvack.org
In-Reply-To: <20261110050202.529473-15-tarunsahu@google.com>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-15-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 06:16:50 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: gx4bkatzai93z4md38dm1wkqr3cuu96j
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7AA2C40004
X-Rspam-User: 
X-HE-Tag: 1794377813-713476
X-HE-Meta: U2FsdGVkX18HnMhnF3k2RWEjW9fvKLDpI8dqT4xPjrhSOJZp7aFX5pUvV7D2R4rO8z/PMrHbDO2UMVmfKK9Vx/FDxH9EpsDXopccPjO90Kpu0/wNOGDy3WZU0vMDuSBSKmk9KTN8iv6zpp2USbbfe4/JIsdGDL867EctnJ1lJSaaqwAVM3gMdzMDvETdS5wXO+srQT54YWDxerHMiVYGJ5UPexQwUxfMjBU1/Hd79VvxYeuaHhftSmf++2FDoN5PASBOwQ2puv68Geub0XNWoBvn82HVZU7xRsN5lIZJGZG9bPGAUETycWph75LVSVj42pE1Q1bk+NZfoR3FaIcylSpWiC36cM1jhmTbXMXtvem7Q4JgUFlwM49eCpKdCG5ro9MjJ+c+vRYa8V/p6yBqDbcQMaakoEQ5JMGptJ1zIoeeybcm1hFONJ+wwWst0v5A46kYogJEvk6SNJ3OkBSdLJA1sURR0/Ql2tjLHmQ/pblrLET/XBNW8BhUSuIW28cIf7InjsDkELr3/lmNRhohTs0adThCKKU9jAESmG0PXIjAoTxfsQv4CCwWCi3qnxQVxNAYXql/WUa9E57J/uh/FdQB+yGfBVNs0O5Tkr3rMZYMCE73ZfhV6I+D24RY/XNosKlhl4i9k30n7cY7dAnbevh62PTg84zHgTsjheDy3kScj1YeKV5Q/y1nJkyYkVNYpu8LbZF/Xupj8IcM57QZGiUhfjwaHTSFUN6MUinY6+nMt5g4tmnQyGHDeETQOcPviWg6rTCqbXNLscQj2jqeokz0t91u19uDbB/kyEuf8zBhVYMZjKItyBy28SEaxMaZ7wnlXcXVs2Fb4GlRMzNxXRnvObqpVLFHqkKF7k259LJPqXMS/J/TQAPSjk8jjx3Yo4/iXgQ9nHMMbud2u/NEfAOmyBsZGRz+Oh+VRJu4pPUfUxx+C4El9BLlvY1PCuIGNbDfbfjmvj8hK3g7lqY
 JQXD6UuO
 8Wk0T2YbqQb1rozxr9dgwXwLH0gFYL9ve/I4san4c/TWbvwhIExeZslPO+hcb/Kv6xeIoPIZ9i7FdEB8SJShdYDZQqNluzhW5GQrN5mGldo3vCVOopXXXCHrHDQeL0XQM9BvrQ8DFUnDiClftHKHUkYd1t1ictD853Wvn+0DGEciFv7IVEk/84sUvQ8sdBwbjP7fNUvD6G/IbSHUEcOM7Dqcnwu/WwKD1+H87y/TOzK3DphbI2gltLqiNuCowPLiC9MbfGGRWptB2yyrrz+C5gRn01rILEjTIz5V5cimpZYaese9ev/QF6kBzKui7+0SOb2TgNSG2RnvwgsVRoE692tEX1WrhUGi4cACAmD63txCd+yt7vfz4GtTHLyKoRTcSdWDHxgEoIPtB2PSitk+alsOsHErXXHHA3xrmL27rJMgSZa+JziiTtvT0DXfiMllSlCynvoPNwUBwQ18KkvB2Iww1JnY563ICkQu2Sa34zPYWtYoJlAqCidWRfUrbSa7wTxNxo6HQ94ey1E68ImT0RZ98ttetY5GSOkh5BfSL/+hDl7lfvyYZPJ9FfUqLFZpCvCJi5k+Q6J4CerbolqXiyS/EIk9L9LBVtZeB+SyPSlsoIiqVmby40tv+wJBoFE2V3CFfPl+vro1FUOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] liveupdate: -EOPNOTSUPP collision in luo_flb_retrieve_one()
  on validation
--

commit f2fc7f3d05b147a7eeaad5c4521b29383721337e
Author: Tarun Sahu <tarunsahu@google.com>

liveupdate: Add feature header to struct luo_flb_ser

This commit adds a struct kho_ser_hdr feature header to each serialized
struct luo_flb_ser entry and validates each entry header during retrieval
in luo_flb_retrieve_one().

> diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
> index a8dcdb8456fd2..d38c223741ff4 100644
> --- a/kernel/liveupdate/luo_flb.c
> +++ b/kernel/liveupdate/luo_flb.c
[ ... ]
> @@ -177,10 +178,18 @@ static int luo_flb_retrieve_one(struct liveupdate_f=
lb *flb)
>  	if (!fh->active)
>  		return -ENODATA;
> =20
> -	for (int i =3D 0; i < fh->header_ser->count; i++) {
> -		if (!strcmp(fh->ser[i].name, flb->compatible)) {
> -			private->incoming.data =3D fh->ser[i].data;
> -			refcount_set(&private->incoming.count, fh->ser[i].count);
> +	for (u64 i =3D 0; i < fh->header_ser->count;
> +	     i++, fhdr =3D (void *)fhdr + fhdr->size) {
> +		struct luo_flb_ser *ser;
> +
> +		err =3D kho_ser_validate(fhdr, luo_flb_ser);
> +		if (err)
> +			return err;
> +
> +		ser =3D kho_ser_payload(fhdr, luo_flb_ser);
> +		if (!strcmp(ser->name, flb->compatible)) {
> +			private->incoming.data =3D ser->data;
> +			refcount_set(&private->incoming.count, ser->count);
>  			found =3D true;
>  			break;
>  		}

[Severity: Medium]
Does returning -EOPNOTSUPP from kho_ser_validate() collide with the
-EOPNOTSUPP return value that liveupdate_flb_get_incoming() uses to
indicate that Live Update is disabled?

When an incoming struct luo_flb_ser entry has an unsupported required
feature bit set, kho_ser_validate() returns -EOPNOTSUPP, which
liveupdate_flb_get_incoming() propagates to callers:

drivers/pci/liveupdate.c:pci_liveupdate_flb_get_incoming() {
	...
	ret =3D liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&incomin=
g);

	/* Live Update is not enabled. */
	if (ret =3D=3D -EOPNOTSUPP)
		return NULL;
	...
}

Instead of panicking on incompatible incoming state, the PCI subsystem
treats Live Update as disabled and proceeds with normal enumeration over
preserved devices.

Also, kho_ser_validate() runs on every entry before checking ser->name, so
an unsupported required feature on an earlier entry fails lookups for later
compatible FLBs, and returning before refcount_set(&private->incoming.count,
ser->count) leaves private->incoming.count at 0, which underflows in
liveupdate_flb_put_incoming() during luo_file_finish().  Validating all
luo_flb_ser entries up front in luo_flb_setup_incoming() (or translating
the validation error code) would avoid both issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110050202.5294=
73-1-tarunsahu@google.com?part=3D14

