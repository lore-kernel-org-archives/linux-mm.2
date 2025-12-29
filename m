Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB020E8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 10:52:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 097EA6B0088; Mon, 29 Dec 2025 05:52:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046216B0089; Mon, 29 Dec 2025 05:52:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69446B008A; Mon, 29 Dec 2025 05:52:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D573C6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:52:58 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C0FA1A60F6
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 10:52:58 +0000 (UTC)
X-FDA: 84272196036.07.BD7A52E
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf28.hostedemail.com (Postfix) with ESMTP id 125B4C000D
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 10:52:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EAmJi+z+;
	spf=pass (imf28.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767005576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2je2Qn3fetVLzu93alqgF/no2c7aUP4V2wy0jPtd70U=;
	b=qD94IgJ7IlE0wS5L3/MnFI0ve1L+7bLmcaumEqqRL3m7WrhXlHXbR7gMv+EUzx/bQlz82k
	rZTIeVluyh+uAuKqqxW+8dFFeJnalPv9aqu4UkButRQZfXwhehbnIURagMwiEQygyVU0/O
	EJz2hNALTf6ymM8XR1neTkPH+ZVLQTE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767005576; a=rsa-sha256;
	cv=none;
	b=QyYQhqq0orEJbrjA50J29n/bTHqYm5FlYZjziAjIa8OiCluLneX/ldlvdndrwelZNWp0Oh
	RBWDhDsGKdPSliTX8VoqmXscPOcO+vlXeI1uN5SK3Dg84Nnk8nOzW0caN47buzvBWjkL4n
	Ibr7W0En4O4V5dsZTmyAXwrEmxuGZKo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EAmJi+z+;
	spf=pass (imf28.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so89814595e9.1
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 02:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767005574; x=1767610374; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2je2Qn3fetVLzu93alqgF/no2c7aUP4V2wy0jPtd70U=;
        b=EAmJi+z+oXKXEptTCDsJdcTOvL9GmmPUHCkT6CKFCujY+s83MLrWtbQwbLQofxdhHC
         +VQZT2BVsImDwp19wH72+DSrW2iRgvVNB5+gS63DhfbwrATdVmnko9h/XvvQsUvOvAWu
         mR6H420MZBDP0exdBKCIf+Kj2uVNeowPoFxOID/voZEaZMW7om+4Lp0OEY+5SSf32/6a
         wcpQe/WOhwRQbk5j7j4xhxRsTlRnWuF8D9CQldtHSwgtvVySgIbknKAJkrnn2jgP7VGA
         bLcpPYD7y9HvOpAkr1F9lp8+kaK6N2LCAb1pzHIVByfdRFTKf7BizZhuVwn7PDokKXNc
         eO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767005574; x=1767610374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2je2Qn3fetVLzu93alqgF/no2c7aUP4V2wy0jPtd70U=;
        b=IDVsQqryhxkDAnz999SIkjt57T1cZYInc0rOBWqjFEEn8yukG33A67eqFdBrJk0c/D
         jB47PRsRvNi5y/ataEFKKDXTkafJ6L3bqSC97U0fOrWHb87A+NIHyNuKfWI+oReRexHZ
         hDh3vmZm4cbA9qkVVQzAKzm7iDuXEMO03eUA8IVOYAEDZVKswQ6TxeIj53MeY60qjhNQ
         AMpwdtCAxsdzDLSbud5wALB/VFHWM15GcYgMtLoDEhTs8bQPOgAXwKGRrlUdhNyCn4AA
         dBg+j3SQ30CRH5493Hnu/Qw/tyCKvUJFokPWQaqlEDHNBs5Jl2bDH88AkuNkS/3Lf+w4
         CY8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVlh3Ei42IuP7LCBKtm0UdO5al0TgtvrYeT5Ru83qp4wI1mWQKAzI17rNoKMKjD1Uxwjmm/Y2e8oA==@kvack.org
X-Gm-Message-State: AOJu0Yw4Euxislc5Qrc69cGCbm0SqgYEs4ZtHhAOMg90h/f6Ya7c9P6c
	V1wYjnVOVvpcNVVTflzaK2TD8RoFUWoDRJ9Fa/dO3u6hznBpwrBVgAOci/cwekhVQUM=
X-Gm-Gg: AY/fxX5piJbZJpe3r/9DZchVY76m2sHfyIn5+d7SuhQdJGM5ZRZ/O81T5yxoqEmf46v
	yuX/JwVoGBZl8SBFu5qHvzsFLzVZcUryeHyn3PiV2RK8oQIblP06UDAYS4c3U0g5xHs6xw6isHd
	tu0f7+IAbZ99sQ/ueBrOmi5Ixf4iWqgEyi3iPyYk9BNFr+kf2u2UcOo89Nnd+i0LF8+DeHufV6F
	wDf5ecb1/d8InUmcygn2TzAMmq+uuWBG95iEv8hs5s1mCR5C/GUQ0QJSGvBDxXiUwf5x+TZIRYR
	GLyqFy67si/KK6u3kxu6C8/silFLg+GieiBXrV7hrNY/iA85swmIyWIzB3BEaqMu/Uy2KxHZTOO
	K/D0k8XSDRMFSeY5sasT7xCmXjqaAYFuwJWBFctmm3UF4RZqMPxG6xWpdBYLy9Rj2Jc8VDjMDC+
	c8WBmxL0hTSmE53itjROG3g9UVkTXC0Qc=
X-Google-Smtp-Source: AGHT+IFAZIRctmetW9tapLi56WB2FNZTvHaLwojYq9Phgcvqi/IEQa13TNzXYWZussaQmRw51uyEfA==
X-Received: by 2002:a05:600c:4e90:b0:46e:3d41:6001 with SMTP id 5b1f17b1804b1-47d1959440dmr359077865e9.34.1767005574275;
        Mon, 29 Dec 2025 02:52:54 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be2723d19sm629127655e9.2.2025.12.29.02.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 02:52:53 -0800 (PST)
Date: Mon, 29 Dec 2025 11:52:52 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, 
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <xlvmvjieqfltqtf5y6y37elcwstrhs6sp7qco2npgucdd4ggus@icfvpgxrwljl>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
 <vsr4khfsp4unk73a75ky7i35nzdjqsbodyeeuxipu3arormfjr@awi2srdwawfu>
 <utl6esq7jz5e4f7kwgrpwdjc2rm3yi33ljb6xkm5nxzufa4o7s@hblq2piu3vnz>
 <7enyz6xhyjjp5djpj7jnvqiymqfpmb2gmhmmj7r5rkzjyix7o7@mpxpa566abyd>
 <llwoiz4k5l44z2dyo6oubcflfarhep654cr5tvcrnkltbw4eni@kxywzukbgyha>
 <wvj4w7ifmrifnh5bvftdziudsj52fdnwlhbt2oifwmxmi4eore@ob3mrfahhnm5>
 <63c958ae-9db2-4da8-935b-a596cc8535d3@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="illqhsqtgan5bpog"
Content-Disposition: inline
In-Reply-To: <63c958ae-9db2-4da8-935b-a596cc8535d3@linux.dev>
X-Stat-Signature: i8wz6aun8tq4h59ccyj5hjnx9jue6w1s
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 125B4C000D
X-Rspam-User: 
X-HE-Tag: 1767005575-96569
X-HE-Meta: U2FsdGVkX1+Z8LxT776scBjKzKIQg8NrWVL6c5gHITphlhS0Bla1WsPhZrvwqVy3g1PoYVU1Bi7gbNJZcKWKWjHaS7mUZsKZ3vbB2v6ahTz+5j7/wXGi6tKKTOuk7htML8P8qUmQFpdvKQwh2qFFTp17+RKOXVQOBCebMbZIcAGTFeQJcaVgwA/E7a1jY48Ml5o/jS7xvDLiJbQSMhCQCnmjTNUZ5aFn/stIOOuSTvSUjAYzjuqQk9jNcHKu57bJwXapkK/qJlI/u+9YRg97GZi6bu4Sfh4hU1DdHnMA1kZu4iG8oWVqtLpjB7BEh341Q+hT0ojINnOgPM7Q50bNRusPjnI9UcOFxJvgpGGTjTT6C7UEu7MMpi3vmQr5XQIhcCnSz4CJliooK2qmRMkvf7xPU9EjmN1YmgRJV7Phc7kFIlbqVUibc/lEu6TK3JxmEzzDN7cVLS1s+Cx5sZAottaxgQLR37FDvRs7GqvhSRJ4mjhoaFhLKZ9YMqnvWINRMCZWE1dX2LxUZS0VTw/o4X3LKz38igHGGNcXXafkBFstRaZHrpFbIvUDdLmS61p4FHdNydXwi/UGhpOn8JrOSJpu4t3PvE69NISStPCX26bpvclKh8/yoft/AdYkWpoK85PudfwLQ2UHba4BTTEBG8VfKpzgK/0Tcuq31DhM765oubuwaJg6S2IUw0FyY5LjF13Wy6JUpVIfvulk92M5qg8kLN4dsNHS8ohPQbhciZFaMianbArYzcGLPrfDKygc7eCou/cZKU0jnHdkGX23BaDMFlw5Toeq5rNCVkMSCt9ja7yFtQFZ0F2GZH55QNCoDpbzbj8MbGh/ZQcscgdz+s5HOAz1oHNFU+cS0Qv2MaQ6Q+nTxonm2FskzZvPpTCSo7le/j2FgoRha5m+7Cu/qYoxYCOb96d3E36ZXdA8w8rJx5NYEFZ5DqIq0U+GvQcx7Oh8kVOCrIQH8hXiAf5
 rA2hoCmQ
 mukLxRTpt/51WTUDQlmyQ2WsF1Eb3bCLmZHLIR3IqH/wXC6Z6PV8C4oS670a5ZLFH56dk/pWI06YUR8a0q88xqb+feLiLK9bSwlbAVu1kzS4RPUgLvKNWHKd9VjEB+HjnLfaHxgl3SVS/illl68XqvmS0plVp9DAxq3oOGc7XLamyf7tUNDDvN6zwpLkTermTy1EHDiqxHNUmtx5xz3rCfeM6VvTtHoSrTkBn2l+wdWrZDDnd+74dQOszdrG0J7WpPqCW6M2FgwGsng4lgOtVRGZWY3REz5zfHFGH9+zsCcNSU25NGJC13/I/wD/ZE58rG4rz05VRYt8ybJTrjlSbrgJl5/H4pFcaMDFHuIGEnKiuz4Nak7BsrakFFhZNV0HCI8PCAeLNbvrpoF5wVlVEB+Gnxf9QBpu3v5hLB4wcINbeFdaJGrKLZfU8Eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--illqhsqtgan5bpog
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
MIME-Version: 1.0

On Tue, Dec 23, 2025 at 04:36:18PM -0800, Shakeel Butt <shakeel.butt@linux.=
dev> wrote:
=2E..
> The core stats update functions are mod_memcg_state() and
> mod_memcg_lruvec_state(). If for v1 only, we add additional check for
> CSS_DYING and go to parent if CSS_DYING is set then shouldn't we avoid
> this issue?

=2E..and go to first !CSS_DYING ancestor :-/ (as the whole chain of memcgs
can be offlined)

IIUC thanks to the reparenting charging (modifying state) to an offlined
memcg should be an exception...


On Mon, Dec 29, 2025 at 05:42:43PM +0800, Qi Zheng <qi.zheng@linux.dev> wro=
te:

> > We do reparenting in css_offline() callback and cgroup offlining
> > happen somewhat like this:
> >=20
> > 1. Set CSS_DYING
> > 2. Trigger percpu ref kill
> > 3. Kernel makes sure css ref killed is seen by all CPUs and then trigger
> >     css_offline callback.
>=20
> it seems that we can add the following to
> mem_cgroup_css_free():
>=20
> parent->vmstats->state_local +=3D child->vmstats->state_local;
>=20
> Right? I will continue to take a closer look.

=2E..and the time between offlining and free'ing a memcg should not be
arbitrarily long anymore (right?, the crux of the series).
So only transferring local stats in mem_cgroup_css_free should yield a
correct result after limited time range (with possible underflows
between) with no special precaution for CSS_DYING on charging side.

0.02=E2=82=AC,
Michal

--illqhsqtgan5bpog
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaVJdgRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+Ah51gD/doiKV5VyTZFiXLb4HtUI
bo6/lt/P2BnUD8eq16i80doA/2jQKFn6l9VxvBFRi5i/AuI8/e+ynY2uvwooHwCr
c5IO
=7fmn
-----END PGP SIGNATURE-----

--illqhsqtgan5bpog--

