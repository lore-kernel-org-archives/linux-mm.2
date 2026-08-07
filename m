Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB6BDC5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 09:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 653966B007B; Fri,  7 Aug 2026 05:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DEAF6B0088; Fri,  7 Aug 2026 05:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8F36B008A; Fri,  7 Aug 2026 05:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0A26B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:45:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01DA21202E7
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:45:18 +0000 (UTC)
X-FDA: 85073990358.24.65089DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6B319120004
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:45:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AXvKR5d1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786095917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8RITH1nY/nc7IpashnTGE42JIybUfWu56Yp7J/1Iy1s=;
	b=8fK06sgkol4S7cghuBAQ4dnlwUG1XnHKa5CFdBe0YGUpuhPB7TbOrZBYAMIoUVra63j80y
	NU0z5anUedXlWr4TB+87cSPBmseE6zdZHmeUjttTQMithIvqQ7xhSxvOxKlZktNojDaAdM
	y4pb0oBCBGhiSlXkqXdf7eEOrwf3hw0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AXvKR5d1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786095917;
	b=soS/KdsnKTquXD2qHb8YUmNNKx/Q0WBQGn8MCmLDw1dDvabKeg1DLGxmrmNaPNjQ0eJ97p
	GOSPFk9JypE69x4xgzX97lzhBMQ74n1Yl9H5qIR+CaDPTeXILyT5NXqrzYyCQ3c6s2ub/D
	KxRH5IInKOeWVCIA2i0WZh8KhyJGBrg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0029F60A86;
	Fri,  7 Aug 2026 09:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2587C1F000E9;
	Fri,  7 Aug 2026 09:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786095916;
	bh=8RITH1nY/nc7IpashnTGE42JIybUfWu56Yp7J/1Iy1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AXvKR5d1cvazAa1A7Tp2AB8n4pvOKTw1DOiMTlxAaG/iaDtDswU6PzN9E+FWAysut
	 Zsm67YoEsT0T/xZa0MWj65QHE0Ouu5B7yre8tAiq8JpIfao9gBbVI56sm2qRMvQxN6
	 JIR2tCLK+ReIS801452Z4AUsyHbodq/+ynt6FwG5OaXdiFAFNpVlkWo/ee8Z5tCOaz
	 zmKVbdAwvkGvrxx5vkQz0i/HUHkr5iuMQ6IPzXFee7MhpivAGH5BJ4KCaFHPMla1ky
	 Ugr+H8D/yPMdstmEu9ylv5Wcbww4NK9f0l2ucqXhgyg5Lat+g9Mgq8vWCCuZEUOSAG
	 Lp8OUpkuhRK7g==
Date: Fri, 7 Aug 2026 11:45:11 +0200
From: Joel Granados <joel.granados@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Jianlin Shi <shijianlin11@foxmail.com>, linux-mm@kvack.org, vbabka@kernel.org, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] mm/page_alloc: only update lowmem_reserve_ratio on
 sysctl write
Message-ID: <pig4crs5bj5aiswzaozygjek6tj7csyhvjb6k6rb4cbro6efnf@3j7xsrrbmi7k>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
 <tencent_A860C873956A52E26AD8D309A308A241BA08@qq.com>
 <anSRGASe5FIrqwlg@cmpxchg.org>
 <20260806142002.ac4a349730f3ce15154a71a5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vr7ccx6vaowjbc2m"
Content-Disposition: inline
In-Reply-To: <20260806142002.ac4a349730f3ce15154a71a5@linux-foundation.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B319120004
X-Stat-Signature: 9ezbqwj6ccx4yraccpshqm9m6r4hzkfg
X-Rspam-User: 
X-HE-Tag: 1786095917-315090
X-HE-Meta: U2FsdGVkX18Yq+IDDz3rsPCtyjQM6y7v5ha0WfRPc5GPwx+X2LTgdMkYSkQnKUSJDquwIyygxPPRnlzV16nPjF+Sz11DP6OaLsfowQZLHJj3IIN7/2omY+0BPZlronF/ruKUYwdVN9w/j50NpwAtEhXjyL8PkM1pPGyaviZTrhUpk6UUzrxd1ZBnNGwzif4aKjkE1Z4f1kxMoPa9SzYrV8madnXqLGkFCAf27fIFjNPLMqDUgoKpsys79fFfWF7mCeWcrVMFGo6DDwNvaXqB/NCtJxGGpc+4nKR2nIkYCDKO4genrVTPBpYvZuBgRNwbYbgfRPZReXgJkgh7fdIKMWUJxNEwOZFU72OoFIG9zXruE3hWrWtY6AgeWYCTA/e2ifyklJdsu3XdMUfg7Xp/asRYc1Vj0SNZ6d6dLFtcHvLOTmqsm73Exsqaz593d/eafHe9+Py2F0BJ7TzMHCLkIpKrKeeNfIAbqd18gwUh/+EMLwD/B+cttqE3E9Rjrxvto4oWeR1lwI92dN0+9SDBxoEb+fdPwCo9xI9gcLMAAFUT+7eV2FHAIumOoHt/7tFlRS4qiV3dxR2r4ZhOoWJRYLcINIUu3YC+4w9q8NnTRAq36bUDqfw0gpmoDG9KI72KyFh19Px+YVonox0sliKtrC7a/78W4UxuGraHamNZ06/6peD+5jPfIQeeYHcdFrf1EwrNJ0fwBmT2SoHKcc46cmKdakNZyoDqD/k1UgJtA80J5ljeCj2MVBlBMVPHngLiZbGHI6QdDoyIFV5z3k7vgVwEQEWas89WKdPpW/GcnBbIpHQ8jWI17YHcx5I1h1quaJg1Q/lUrGMTVpNoRfI2HqC6hmqbMxlmRMoLIqozF4zAnSFs/UqjjX/Cr5UDL7FeeKL2GhxXDXcLd7oNFoyYkRh/zewyRZ+cWVNkflz3+/NenAcxJSw6sUxeu9jUEQ1ASZQ44bj5Ig6JspWQW4X
 u2X+DCP9
 KZOxYj6rOh731EMc/YteoAZeVKlQO8o45J71bU6j6iPSHw0f0G0R3RCre5JluumQTFs6/K///gy6mcllbb/xelOVh/uU12zimlYpUlL8Gu5g9fopMMZILS76YBVUklhdl2ERDHEdrf5A5QAa9ZffrW9CWXrPU9RaEBQeRJ7mH6wD5yxXhjpvqawnwnsrJJmtw8/gpkpi4AY+yInf+T+dBgYZAtsacxkHFuwn06DCSWV/mZfTmCp37TQt+oEMn0IY7BzEJP4z4Zj88hpxBcPAno/t2sViyPg1iAhokJiS6YlU/N1qNa2NMDk7kYSrisL2snwhvCYxUZR4fX8EZ77J7vodWonsXWZ+pHpFfAw96W0DA2cYHPXZlaP4orZVJ5qN0baD+xzfXNIo0jt79VA3sgYCRIMESRlHQV0/RFTzYwCwZ14byl5pIvqF3/7j60iMujg/a3cfHxao2IL2p/om+lRWneCSjMXXDdMKL6vAK6/8bEvifCy0B+cOOcv1HWjdtfplQ30JmNt0wlw8q+SLVTFhLThw1kdte5FvF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--vr7ccx6vaowjbc2m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 06, 2026 at 02:20:02PM -0700, Andrew Morton wrote:
> On Thu, 6 Aug 2026 09:50:16 -0400 Johannes Weiner <hannes@cmpxchg.org> wr=
ote:
>=20
> > > -	proc_dointvec_minmax(table, write, buffer, length, ppos);
> > > +	if (!write)
> > > +		return proc_dointvec_minmax(table, write, buffer, length, ppos);
> > > =20
> > > -	for (i =3D 0; i < MAX_NR_ZONES; i++) {
> > > -		if (sysctl_lowmem_reserve_ratio[i] < 1)
> > > -			sysctl_lowmem_reserve_ratio[i] =3D 0;
> > > -	}
> >=20
> > This could use a comment. How about:
> >=20
> > 	/*
> > 	 * proc_dointvec_max() works incrementally. Use a buffer
> > 	 * and only set the values if all of them parse cleanly.
> > 	 */
> >=20
>=20
> I added a fixlet:
>=20
> --- a/mm/page_alloc.c~mm-page_alloc-only-update-lowmem_reserve_ratio-on-s=
ysctl-write-fix
> +++ a/mm/page_alloc.c
> @@ -6932,6 +6932,10 @@ static int lowmem_reserve_ratio_sysctl_h
>  	if (!write)
>  		return proc_dointvec_minmax(table, write, buffer, length, ppos);
> =20
> +	/*
> +	 * proc_dointvec_max() works incrementally. Use a buffer and only set
> +	 * the values if all of them parse cleanly.
> +	 */
>  	memcpy(ratio, sysctl_lowmem_reserve_ratio, sizeof(ratio));
>  	tmp.data =3D ratio;
> =20
> _
>=20
> Sashiko got all upset about concurrency issues:
>=20
> 	https://sashiko.dev/#/patchset/tencent_A860C873956A52E26AD8D309A308A241B=
A08@qq.com
>=20
> But I think I'm hearing from Joel is that the longer-term plan is to fix
> all this up within proc_dointvec_minmax()?

Indeed. From this I have two todos:
1. Address the partial write for sysctl vectors
2  Address the Potential concurrency issue

Best

Joel

--vr7ccx6vaowjbc2m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmp1qSYACgkQupfNUreW
QU/w/QwAkiskagS/4KNgmgXF/zdpFykp2NN4IXFG70MphKCbGV7I/HkczzUmX/y+
36lvFv4Py+aQmwoZJtvxvaKUqyHNfSaIIU6e3RuxLQlNdHaoX02D8hKpwwFhuvBS
Rz/BxW67l8YoxhFJbe4hDSz4Ty8ef1ezx2zE4QtDqvK1B7LDsc/8fbFWx+9sc9O5
fbxIYoQCIJrLWXrJYdSkIGVI4XmnMCe/wCxoeJAqqck0w7YiaETWa4dwXQ5EzfMO
Xkp3AZo6+uhV65n7uxWRVsPEQSzClA+EGSkun2lRqbvMQWxYY42YXciSU0+Fh69W
Mix+/t45RAlEBFcyo56qjJeK36DiGbt2to+UAotU8YXmDflXgQ+67oOW1zOUECMw
Ms+O7yoTERzAG6CjAQPjH49POTz9SG8GgDl6Da1kGfdvoNAoC4Hg+7bFsrwqU6Ve
oQSl73hRS4Sv00FIqz5z5iOTkArBHo8LDHewSsUEp0+LvIG7R9jWk3SiQvtxJCls
2tkB68+w
=WvIP
-----END PGP SIGNATURE-----

--vr7ccx6vaowjbc2m--

