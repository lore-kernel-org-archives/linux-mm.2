Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AAD6CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 06:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738916B00F3; Fri, 26 Jun 2026 02:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E84A6B00F4; Fri, 26 Jun 2026 02:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9DB6B00F5; Fri, 26 Jun 2026 02:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 328446B00F3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:05:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 880B9A03A1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:05:12 +0000 (UTC)
X-FDA: 84921026064.18.5A8216F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id CC9A34000F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:05:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DlqtmkwO;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782453910;
	b=CySr/ZvjuXjiPd/gGGROZq4AuYTV2aVnqP7Cnqlne3ZfLCHXsGYMfs/QnoWW1jKXGHfJIC
	Lxq4ycozDoje6ol6N0rOFkknJDXSKBbRyuAOlsAYtwvsjEGxDDWqpgCuiJ8mv+VZuJ54ve
	abpF/K1XmdvfFdiEq7V/IU+7/WmsBW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782453910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9oL7c3i+gk56KOTzil5DMHlEF4gYOabQZTiWR5RK4M=;
	b=bvGN8qP+QNQDGr7duCwwYOm4jjAv9EZ0nIlr7oifg/bIGjf9QhuyKIfw6aWvmVI0uwguSP
	fET2J1/8EDho0zYNK6bDS00i+sY3Kj43PSjv5nRV6Zcpcnf/pczqDmBSKrZLmie3dKOuxg
	rzCU52u2Mw/SMCY2lEhUK77BfjLCDYg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DlqtmkwO;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C78B9436F6;
	Fri, 26 Jun 2026 06:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47471F000E9;
	Fri, 26 Jun 2026 06:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782453909;
	bh=S9oL7c3i+gk56KOTzil5DMHlEF4gYOabQZTiWR5RK4M=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=DlqtmkwOymvSa5ZtNvNfHbECUNFE7rZKzhXuStdjYZwLnFUTSY2M3eKhy4ZtQzyri
	 LZwaAEt+JAkRKwkl4Bnd+/4ByhlVn2eQ26irDRzqRYoKWyEOmG2En6OYMDuSRSYa/D
	 pUV4zyONLqW65JAZDreixRqs/BNWc5qhuUy/CHbWayhycGCaN77lcVM7GAJKHUu8/q
	 wpV1XUCSP0JxWFUJe/yHBXAmgM6T5xTZc/vpUM54JJUZ/zVg5he8bd0nc6pUt6Q6dG
	 SXfhzNN8oGBK2YqiGGS7HDVJrEJcFRycal3pN8pooUnnC5R7nMG7ImePS7JrLGgkbr
	 cgEaFra2NEg/g==
Message-ID: <be9556d1-7eba-4472-a932-bf56db6285e1@kernel.org>
Date: Fri, 26 Jun 2026 15:04:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/4] memcg,slab: kmalloc_nolock() fixes
From: Harry Yoo <harry@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Alexei Starovoitov <ast@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
Content-Language: en-US
In-Reply-To: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ejXnirQmd0n0E9T07k6SM4Rs"
X-Rspam-User: 
X-Stat-Signature: ytko5r14sw5j1qt58kc9gj19qeqcnpfh
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CC9A34000F
X-HE-Tag: 1782453910-500105
X-HE-Meta: U2FsdGVkX19qqDWwQnCOR23jydcAI+t3qLZAFgN3z8kgxvlzSL4E1D6ZdSPYTxCqlhAfwJQVJL/Rl268Q+/95tsrlbbFztlKa9R4NW/pNdWpf8cz2QQ3dYU4Joexn1ZI6kXEylbLmsIbN8NnMGjrIhZrs8Bd9ZRqdELUufGhSkK85r6L76WeIgDP/aZ6ldKwAWGtJVqUwIpnWRjVUp7xH/SrY5K4dFhENO33lSSuGczukZktFIGVh3KjRMM+8dLuf0ST/JNeFqgz0aT2B1EvY3uu1BtGVeT0SyhoqamDc1rX/7AzXtiWPSvhe2MzAidmfcrvTV07IcXCbBOeKiKqXgme3Tsj29v5qpbaaJKQd1pCGSHs1iYG9HslmBPuyu90ZWYDxMDovdr7CEf70niTaec740ZBGzd+6Nx1yBRK1ic2P93mHVq/Xn6S65+z9VUjWxkv/jbWZ8sSQHbJQ2ALxK+twrwhCv4dVD+0g6cDWDEoIDhzXMBI7KndOyG1CBs26MRohWXo10GHBNMZ1paM0IW/AuW2YcE6ir8x8bUncL+iUZrYlm3L7Pz7unfXweIXOtivic7/J4TkuuVhAgO/StVI4qB4meRxJwk53zsGWqteedVvJ0TInpNu3wrO+3epJ5bw9G8Z0iTVzzIwIqH5mS+tSW3h/kiJLlMPVNHAVXMXERDUOO1Jl0Xok97iTMp+8YvsWdRV0+uIy+XepO3WPlswLhAM8En8u9bFtSbV7x1rfvv+Dz2xSg4PBeGQpOXsywLrMn9a+CriLgTq788009avbGlC32hz+jF+iElMRq/+WQFUx1b0S4lIpwxwnDkDtVCqowzAjir3pNUBeqI6LsjShapIVOQx3fJWtWmv3saRv88tYYVr9Nj0Z7Ldua8KGu0ttU3oLH5ynzMOyo2aH9oelaJ90iKQrKHBhvP4QXjsMs/B0RhFKKI3adpBvD3baHBZHdqqkQ7c74EINT8
 s5Xextcc
 W0R+Uf+C1V6OZZEv0i/zVHnHsHN2kvWmOPdVRMA0/4ZutcQVz1SSjJu4xiT4duP6gsF+pMqisWrV6OyqWpn/6VjtOFGpNsrPui23RKh3HjNGzCXTHJmgRBVR6apifsEcesZMvBSrRtWqQFRCSO4UHasNWKMNMZnRp8QcpYFMf+zwIWf2GmJkQ3AVzBvmdgUigebZM8lTGTWXDujYFXy4g3wEyOdpUky4JLDrBd9u0lA+prz+/fuzzlYozDuZfQr152C9w+tukOebyDri+h31nBPZbvq4jLHDe4RIcj7yC6LgeAlqJ4Uomf2yyBIFOVT7pu+yN87zXFdznc/vdtCLAU2Ok8uM9VRXMn7A8LoQMX+Lwr64FXKriIGyYNtH1HO/aE7FbtbfRErgqd6Dbx/FA/HrU/M3xlNYsB9JCXVKuFEVcsX4kQVbrIDG8bQTuFbV5V3nu2WtrqGJtRbJiLzUu6fujEE4uYsG/An0O6QXDcqgN9rQ+8OPuHwwd5Ph2wgD31U+I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ejXnirQmd0n0E9T07k6SM4Rs
Content-Type: multipart/mixed; boundary="------------xqitAKa4qlewiFSJqUEqWGv3";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Alexei Starovoitov <ast@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <be9556d1-7eba-4472-a932-bf56db6285e1@kernel.org>
Subject: Re: [PATCH RFC 0/4] memcg,slab: kmalloc_nolock() fixes
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
In-Reply-To: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>

--------------xqitAKa4qlewiFSJqUEqWGv3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/24/26 10:11 PM, Harry Yoo (Oracle) wrote:
> Apologies for posting another series during the merge window.
> But these are bug fixes and there are other features that need to be
> rebased on top, so...

Okay, given that this needs a bit of discussion with the memcg folks and
this has been there for a year and nobody noticed, I'd suggest we be bit
less hurried and not delay other new features going on because of this.

But I still think they should eventually be fixed.

--=20
Cheers,
Harry / Hyeonggon

--------------xqitAKa4qlewiFSJqUEqWGv3--

--------------ejXnirQmd0n0E9T07k6SM4Rs
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaj4WggAKCRCGXBN6rc5S
1gJoAQCU62++/Xsx2zl/wm3/4ApCCo8iBQMYmBrJ4FIbh3ZIfwEA8BrSGtpSXrbl
07eyqHG4yRJBsXB/Xo0SQu5z9kQcFgI=
=TLzD
-----END PGP SIGNATURE-----

--------------ejXnirQmd0n0E9T07k6SM4Rs--

