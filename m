Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6A2BCD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 04:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B7396B0005; Thu, 11 Jun 2026 00:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967306B0088; Thu, 11 Jun 2026 00:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856376B008C; Thu, 11 Jun 2026 00:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 716096B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:28:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6ABA1A04A1
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:28:25 +0000 (UTC)
X-FDA: 84866350170.04.4121438
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 322421C0008
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:28:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R8PazR6j;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781152104;
	b=5OCCWizhnwCbEyZjTsbBgIFm8zgMaWMpT4JuhmiG2+I71rM54+kcW+i2KbjQ/zw6MWFb7W
	m1YorxLjB7o/cUHYJfKo+dZaE88LhUY7/LD4VLZiIbv3Q6JgYSQARaVv8/EiBUldc8exTq
	Vg8wnc6SbZPx1r5UtpfAg/bdI4J4gVY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R8PazR6j;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781152104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ebuoNn8zdrqOpxqpNoXGy+JFde83KobHja3rzwz4bg=;
	b=vmZlVAU1bLg4ipShOWklk9LfULU9VPYrUjPwMQvuvGJlbYBAFmw0WyqMwIp8jgnb4xZeTQ
	ttVjUnxu9bZfttsZA/6/CNwx/P0nTlue2WpF/yIwH52oQP+cYO1W0QwaAEySzX8mSf4pGQ
	uP0u/WHCfpG0RPNzEGauWk4gpuXwB7Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E00E44300;
	Thu, 11 Jun 2026 04:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E2C1F00893;
	Thu, 11 Jun 2026 04:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781152102;
	bh=8ebuoNn8zdrqOpxqpNoXGy+JFde83KobHja3rzwz4bg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R8PazR6jVPYyf7+wFXw1X07UgYA1ez4bgnqAF61ddxjFVJS5h8D5QtzyK7zw/G971
	 HaMTOwnjh77Cw9Kkonln4915X4fMjR0tiz4JUB5RktFGKTL2tPSgjyGh489k+u440R
	 n4QyqIY04sQHH9r6jYfgBlwWA1vRoxQko/hAAQ6ploD/y+5C2sL3MhyFynIq38j5+9
	 G59bUR+8i6BF9unVvOi20zvvkAJfKf8CnktZPj8hXtTPkygc2A1Tg3hA8c5nwjMEyR
	 Qa+sf2ZxBY1DFLzcn5h21YblZCGXDCAFAvCf+iuvEJsSChwcpHDcC9Co/U+opZZBak
	 p9Ul/D30pCdeA==
Message-ID: <df75999f-e96e-4a9b-8930-1b6c6c7c17cb@kernel.org>
Date: Thu, 11 Jun 2026 13:28:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/16] mm/slab: do not limit zeroing to orig_size when
 only red zoning is enabled
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 stable@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-1-7190909db118@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-1-7190909db118@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------9nrmmelZmALRVRtPX4TWPfgk"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 322421C0008
X-Rspam-User: 
X-Stat-Signature: kxij5czajbk9n3ff5edbr9qpddzwowpo
X-HE-Tag: 1781152104-206135
X-HE-Meta: U2FsdGVkX1/Q9dT3ajZ3SWcvzxZHjd+9CW5NBLEpLN61ayoWqqqwoCMcKWqhezz9f8LlbFqWH2HAMV7u/2Zu+p3DZexVkxidgz0F7z2r2BTgWo5+f1ORqkcN0qOlDq06Ju6JD7Vrcs1N/3s6EadKP57XHce066y2ifuBbX3hP/PZxdRnekmuTvmbqaBGCiCD05Bty2ylhDORerJPpRKXtum8xMku9ohkicIz8zq8XmjXZ2YvEIz+bPz1wXDVADZryVj2P3JjlVF9QFLtEvwGZh5y74D+cqIW8CAzrx9L8FyjEvoQIlR4j0J4sySbBtm7sLBUzzg8fr06CzZSdjS3HTIqS1yrrdiw3UnDhF9IfsI0p0+Zt9spcT97H5hvNgdehi9U+ZAhsCDci3E0GQq23vdJcqAZztE8SmmnoyCiVPkbpwtVvnidc6queULkHQIDyaSztW92r2ti2K3iebO+tg57VT02cRTKxMA3D18bzNTnnZAXazeoK+ZtX+DtXbSCdpZJ8EiwugguvelQLBFTr32HD1CKnRoZtUKOec1riAII0njJFsD2aguT1NOHSSQ20IoC/g74/VZ9d/oi9hnO1ey2wdCbgHAl3M88a7nblvqLkDQkLFG2TSJdmm5X4gB5oT2cDZ49GBhMh+AVqOR310CCp4UxwAYrWkSn27AM5Xnt4tkJ6IDFVKS/oMXI4RV8TG5aNbTo0QiqREwqJ1pOtFe598XF+ciylfM0m6okYamZVA82UyRh6EjfNgoGD5giOl3zxkhvQ/YOWiRiHVqMZSuPdVTqAcqymaKM5Hp2YqB8RxA5gH5gFheMIlOCsqiuahRQ+/pKdrrX5LWsFc/6fYMwNMBgGRfiHg4kPNo0WruPmy/7Dm4Guz77sYnFHpTcWjoScKGcqi9yylFDh3JqoAU2DN5YhjZa457PCQ6mzTjX8fY06AY45VWNFk3G0NuxDY9EvUrwO1+k6J4hu5M
 ZL9qbIrR
 JXI/I8DjBu5+k9OZkpapFCUHBp2br9zknP0SZZ+WDTEfbob0MwpdbN76tm3DzWcPmxrjvHnOSorfpBML7nhlyXRSDbbglTP3yeJVJh5IDrD0WhQ2T7UsPcRt7LrMbx8QdlvrB3ZHTPpYlD0MgSGqJapGRLb1xB1jpxfDM1aLXo/UbFoW1GCYFobBNA/Dp4+KBkd7qJcurk1dd0UtNd54XoqyKP1vBtdrKg0l24bhDFT4lV90b++U7qugNgaNaX9w7v7ox9Rjy0KFPES7qxhvjM+8n5fXKF+AQoTboJqASVvjjGBmU0N9wsApcbw6TRpcVFXnZxPweoXaPerRi95Yq7lAAHwdeiLSID3LA1mDQvK7On3LIoRyKru1tcASHMF9rszqi7xIUNcZlO+8eIyEfL7kJ5Aozd8APbdqZQ50ZXbZVKxVfkIroz0Bshx7P7uxOPp/JulB1KtmQeukI7mRIWjbrwl1Yg8K22hYjrOrWFw/0Clc7DIEsM+0SWDz/N2xkSty4cvz8H45rEuvoVPXPOyXDvZeDtI4xzdG4HQsUmcz06KM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------9nrmmelZmALRVRtPX4TWPfgk
Content-Type: multipart/mixed; boundary="------------ErL0jxv071rjUQMi0aMrpEeW";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 stable@vger.kernel.org
Message-ID: <df75999f-e96e-4a9b-8930-1b6c6c7c17cb@kernel.org>
Subject: Re: [PATCH v2 01/16] mm/slab: do not limit zeroing to orig_size when
 only red zoning is enabled
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-1-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-1-7190909db118@kernel.org>

--------------ErL0jxv071rjUQMi0aMrpEeW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/11/26 12:40 AM, Vlastimil Babka (SUSE) wrote:
> When init (zeroing) on allocation is requested, for kmalloc() we
> generally have to zero the full object size even if a smaller size is
> requested, in order to provide krealloc()'s __GFP_ZERO guarantees.
>=20
> But if we track the requested size, krealloc() uses that information to=

> do the right thing. With red zoning also enabled, any unused size
> became part of the red zone, so it must not be zeroed.
>=20
> However the check is imprecise, and will trigger also when only
> SLAB_RED_ZONE is enabled without SLAB_STORE_USER. This means enabling
> red zoning alone can compromise krealloc()'s __GFP_ZERO contract.
>=20
> Fix this by using slub_debug_orig_size() instead, which is the exact
> check for whether the requested size is tracked. We don't need to care
> if red zoning is also enabled or not. Also update and expand the
> comment accordingly.
>=20
> Fixes: 9ce67395f5a0 ("mm/slub: only zero requested size of buffer for k=
zalloc when debug enabled")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------ErL0jxv071rjUQMi0aMrpEeW--

--------------9nrmmelZmALRVRtPX4TWPfgk
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaio5XgAKCRCGXBN6rc5S
1sfjAQDJjxqdD8sQENhgXIPO4U/wPF/HiD82CcmCL/ATkiFhdwEA10COEVT9AbpI
m0HnlYsxgxDFh2+UgTL2jf7cbIWfNwo=
=AcAR
-----END PGP SIGNATURE-----

--------------9nrmmelZmALRVRtPX4TWPfgk--

