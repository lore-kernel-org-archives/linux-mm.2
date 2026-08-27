Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EE96C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 13:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE32D6B0088; Thu, 27 Aug 2026 09:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D646B008A; Thu, 27 Aug 2026 09:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0EA16B008C; Thu, 27 Aug 2026 09:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0DD6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:28:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D764FC02D1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:28:32 +0000 (UTC)
X-FDA: 85147128864.07.A876448
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 97532100009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:28:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ctBtGvrP;
	dkim=pass header.d=redhat.com header.s=google header.b="VbGt/iuO";
	spf=pass (imf05.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787837310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=faP9ygWQlSRIrFbk7BiUYjG/H8pEcJDzSB8VBBaM9e4=;
	b=Gb1oYL4Ue2rkww+8oQUOmjn6mYahwiqc7q1ujheBMf7FZO7C/VYlOBdt6Cd7ObPR8POj/8
	HQiwZx0SMWnMT72f+mK1BNhA93nOBXwOBtjNnqK8BOYskXRb/Gf4uox4WaXPlTB1i6h1Wi
	I24+EF/0VeJ7ePyk0wz38Z3/PFBSyVg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787837310;
	b=O8F4icv9ZeSLH01kEa4L8CIlpatuNwPnxVfeMiEtO1D0/MbfwjqimGkZbbMqyTlbJA5w3z
	nZQVP7+1/9xxX4hK+wtMNXdTPJBzj2SAIU8vfukSmrX2AXDFz7S9YKlKd+67rRTmaBMBw8
	YTTN8k/84+ib73aJ2d2dzwydoYIl0jY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ctBtGvrP;
	dkim=pass header.d=redhat.com header.s=google header.b="VbGt/iuO";
	spf=pass (imf05.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787837310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=faP9ygWQlSRIrFbk7BiUYjG/H8pEcJDzSB8VBBaM9e4=;
	b=ctBtGvrPbZ/jeJ21B/EHJIhAXRTUz1+aNup75tZHHVnJGoTcFPAY5aUFDtYPLtEcEOm9aZ
	tEu6RmRz4XR33At2/fW/A1LXY8iajHIXnG7dKxSAhwQFta7DSKi0YQ6gbGtwCsU1whxu7x
	vhkJXw3zLTtwtDsiNYlLP028hRMqA+s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-yMYN9yRsMsGzobSnnl2_Fg-1; Thu, 27 Aug 2026 09:28:28 -0400
X-MC-Unique: yMYN9yRsMsGzobSnnl2_Fg-1
X-Mimecast-MFC-AGG-ID: yMYN9yRsMsGzobSnnl2_Fg_1787837307
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-47f4bff865cso1052101f8f.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787837307; x=1788442107; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=faP9ygWQlSRIrFbk7BiUYjG/H8pEcJDzSB8VBBaM9e4=;
        b=VbGt/iuOsZMgtk3SCcGBGb66zBBqN3Gu8d8wHX7SVNgslkQeISM0wOR6dDm7Y1Rm5S
         kgV9lDM7F5/jVTwtcbe+ZNtvflomLHbmgje8R8ZO/U1k5S6JzCGbC2RzRywyYNohKuVH
         qG5ah6/kFNWnk5euEpBrRbhfFHXYXGgzfWDYAXDIScst02sq6jiJWpo8O8Z7IoEhpBvY
         KpAWsb8xJYz2BdWEX+5awC1VuiozcT2cyNb6J3Hdjvsytj2HyzDGmsddhqxu4wpwZ6Z7
         1C4QRvlH6YXtGsAZ3tbG6EGEKOuObxAni7i+pzAJTWs7heTtunYrnOoOc5stm27OVRh0
         T3Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787837307; x=1788442107;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=faP9ygWQlSRIrFbk7BiUYjG/H8pEcJDzSB8VBBaM9e4=;
        b=E8XixgWK5ry7gHVlIg/6Z4qb6DOx+FSloEqXeY60bggkMNrfEqe+m4CRRHnMrqIxnz
         T6Y93psHGq5svE9UNLpvao+VwxMCoID8p4/Wq3ClP3UzSY9e7CswLpQqAvpL+T4q+WkS
         ySHdky1z1mqlNmfAzNiQ7tdT+I/fsPEhBUF8Cv6oYu/TJ7JXfdeRrAh0xm8ZHGjlzeuX
         oBa5bMdZMgJrzabTsMismNhQlT8rJosdghMhsCM0GeGgfUSLkZdVGqTIkLhkhImizmbo
         tCUG20U2J6qZvZODDUlIUkLneONlA059Jzs1x0TB/Dhm0q2/qwB2jjODrQrx+bEKDf1/
         qZFQ==
X-Forwarded-Encrypted: i=1; AHgh+Roxe1Ljuek/4TiWzz0lDb8kO0cnG1rqFnL16qio4e0xe9TlTI65mz2qbGMYV1qAnGo8rMc4uwwxpA==@kvack.org
X-Gm-Message-State: AFuF++kC2XSi5t1ixgd8gw1WFSb8/YAJmhzXKYyu6SW6D48G2SQSpGAO
	KvrGqXyr44f/f92ZsyG6NQXXUbVDzXEB+94Wp8pvilaLu2xrBFyZ1iHf8+9nRyAt+myrxDtQkmZ
	2X3/Y8lGYPz9n+F469khRqZrfZtPQ5IQKKsIJRDHHgaS/jbBWZvoS
X-Gm-Gg: AR+sD12QrmBgrUK1sY6zc3aYqdT3wCEDACPXvbXnwQ5ZIqu9oeYH6PqsepaG3qHGqvt
	gmdlGqTnqDDe6nuF4U+cpir0WtuNwGdyUYdrg0ClPKVBjkAwp5TIdST5WW6oD6HPCz9xXa9r1yp
	Ntudjp9deRktzU3ZtsnRyVIq5cPfgXxA1psxsRVQJcRqoH9z6b/8ShxnL6clKAZIjQS+KhJh/I5
	6/0qZakUzSMPg8F3kN4N7cL3Rzsj9Z3DrCr7hfBRkGQaWl6ORf+Hyt+RGi+ubGRmxcZItOJNoGV
	klApGAGsyesCi5nwAyAx1tbXF5v8bJJHHUMZaG+xdX0sySoQrChZGBBYHMG2uR13rLEwv4/ptg=
	=
X-Received: by 2002:a05:6000:29ce:b0:47f:8ac0:282 with SMTP id ffacd0b85a97d-482e26c3ff0mr15609405f8f.17.1787837306967;
        Thu, 27 Aug 2026 06:28:26 -0700 (PDT)
X-Received: by 2002:a05:6000:29ce:b0:47f:8ac0:282 with SMTP id ffacd0b85a97d-482e26c3ff0mr15609319f8f.17.1787837306492;
        Thu, 27 Aug 2026 06:28:26 -0700 (PDT)
Received: from localhost ([2a01:e0a:a99:9822:ca7f:54ff:fe01:374c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e279eb1csm9177838f8f.4.2026.08.27.06.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 06:28:25 -0700 (PDT)
Date: Thu, 27 Aug 2026 15:28:23 +0200
From: Maxime Ripard <mripard@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Eric Chanudet <echanude@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <20260826-brave-nyala-of-elevation-d23aea@houat>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao2t6HP-Zt5KDg30@tiehlicka>
 <ao3UKM5SbxBmxuR0@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao3quaSze8YjPjxZ@tiehlicka>
 <ao3tFg4JLNlbylTR@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao6eC2SUIGVz3Qct@tiehlicka>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="yiahqkhps5b233tk"
Content-Disposition: inline
In-Reply-To: <ao6eC2SUIGVz3Qct@tiehlicka>
X-Stat-Signature: ujtojqcoa4ooc9syofcfopqnz3kutx3i
X-Rspamd-Queue-Id: 97532100009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787837310-517414
X-HE-Meta: U2FsdGVkX18e8PXuynQB3jBVFuumajf9TFbv26C9xD/LQom0DVHIysYG4UBM2qfV5V7O3UBYF9YVz9ci4KdnKkUzZ/sICgiQH671Z/6UdjUBGmoRtRx0dpbEMZbEwm68VMHTgAJ838Jqg9TYhtA/tB61SZT7sNNcVBSi/oSxioLIFRcKq+SJjte93bxjCPxh1PsYEZdSHQ3i76iExTLnl/UiDrpJ49O7Tz8TJAG4p8LPwgwMm6R5dyJoMx08akKqBYQIvk2iQEBCaKEFFXa3DJ9N4OoRBDKaOPLcibyJOjxuqqh8I5WpnVhk/LxIiuq9fb12sqe4cBxqoxeT4V/Y0sXzBkUkBiWWTaeMIVp2rZseY3+AnfRY/QfoGMI+QzRqf6EOmTpzP8SkPDWqOgkBn4nFKAaCjhX5yiq+n0C7T/8+IutbHw415UIup1WWlf2viVo9m6ydXlDVGotLV3dYmh4pBWF4BOdHuYVIrzidbllW8YNN9B9m4+7j9WL2heKxBV0AOEoqeYae2U3Tzr1MZCX9nW2hmvV86qXCjiZqvLsitzhQRmpkQtPKm7uXkIk5Q9IhtBEJnJxTmJpdtZADvikxsvZOBYcmvvIp07W4F4jAmUrTMqPVYEez0W1xTnt3JzPVOYgG3wm4NT/eVFOX6atq3Hub7B0jnZNqM2MCJDfwA/uqFwr1R0gDgnvixMHpd/4y/HSLzjqSZU6kfK+3X6aRGKDRmIQQgjNesSlLIH3hHNm+aVOSlrbLRpRkIdzClMyGhMvZEPeuK237DsVzqLCkJuDqky6eySLwsLjvnRxva5U/zB/+uMO0/bOHorZvrD/phEL4hqtaX0F1asc2n+NZ2pHJ71ZNiVYPIZgmzcXFqlBYHST/ddTou+PJu+t1SuqTWfRWIESSdWHfPa39IbqlrRQ3ryR0bE8xj+/KUdUJyFwjUhqgConySjMpbyyhxPeqzGEkeqrVGgE0JnL
 FQYNl0FQ
 FaEhhhSiQF2N85atYHjkstbuLBuRg0mVtPOd0USkiWF9M9xM04As9/6xqZxoYmfjYq3TUNjLQ3LP0fkyNIbpH9VtIPp1ZNb4rjBMhjSlmDvFzhDWQOXTv4Qkti7kjyrLm0iNdpobX3YQ0yFRMzZ/Ij1FwqA4eagaC+7P84A2qM+1FoFhAR5S5NiCMaVu4ztkyNJ+wtWbE1e63i0fYO1Et6MEsjq2wrgXvMKmnTnKWrqllknXduVlnINlaIdRWKiCtaMqxQ4WG72uWPypnD0g9Za/UaB0iUoFQF3j4bl8ku204XZME0Z1AxasXAh50EfKJo6Ew+xuB4set93ts+Mdf90oQ5NvWbAPqIuP4RhnsHEoXHiO3vWsAkJ+jK6wGLL4xeCpQCPNcvpU+da+mYop62CG3QiZKI7iPwR7RDpuqpzn884UNGcUUyvmpVxs1prbJzmF4BZ5vs35NC20m2bPpzywZ/07x0xWamjkHUwvAqbMtXb/5ZYnVTNl8GB3rmMzi8NCecfA83VBR7LQvDpsO4j44hr4pRz/l7QFhmP7UN8B1IM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--yiahqkhps5b233tk
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
MIME-Version: 1.0

On Wed, Aug 26, 2026 at 10:04:27AM +0200, Michal Hocko wrote:
> > > You cannot really assume usecase, requirements, lifetime etc. for an
> > > arbitrary cma area. I do not think this is a viable way forward. Focus
> > > on your real usecase, which seems to be dmabufs.
> >=20
> > While dmabufs are indeed my main use case, they are quite generic and
> > may not always have system memory backing them (device memory). Working
> > at the CMA allocator alleviated these disparities.
> >=20
> > > Explain what do you want to achieve and then we can think whether mem=
cg
> > > is the right model for that usecase
> >=20
> > Hopefully I expressed this in a better way by now. In short, enforce
> > usage limits for concurrent CMA users using shared CMA resources.
>=20
> Thanks. Yes this is more clear now. And it resembles hugetlb situation
> more than memcg. You simply need a memory pool specific access and usage
> control. Dispersing that to a global memcg limit seems rather coarse and=
=20
> I would say impractical. So it really calls for a per pool control with
> an understanding of how the specific pool really works.

I'm not entirely sure what you meant there, but I think we also need to
have it account in a "global" limit somewhere. Which CMA pool is backing
a CMA device allocation is pretty unpredictable and unstable across
boots, so if userspace wants to put meaningful limits somewhat
generically, we'll need some kind of catchall limit.

Maxime

--yiahqkhps5b233tk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCapA7cgAKCRAnX84Zoj2+
di1+AYCIo8KLWPYOzEwBgbqOdUgA/zgdVT/joCROq5h9TbzGRbFQcxXH7KRg+7fJ
IKAwfJkBf0pN5A/Vo2FO2QoLXkGlaXcWUBJakY9boX9YnDyDdS+4c88lV2EjJudO
EXr1S+1vDw==
=t0iU
-----END PGP SIGNATURE-----

--yiahqkhps5b233tk--


