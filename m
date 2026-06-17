Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C02CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 09:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 932B66B0005; Wed, 17 Jun 2026 05:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E42C6B0088; Wed, 17 Jun 2026 05:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FA1F6B008A; Wed, 17 Jun 2026 05:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C1CA6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:29:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D73BD8D5AA
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:29:10 +0000 (UTC)
X-FDA: 84888880860.20.19BFCAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2C7884000C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:29:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ka9YkXJH;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781688549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bl4HHza+GTCgy+MYtBFrYAN0WFCZBYUrBco4XR9hSIM=;
	b=VrIm4GdoOJbf4pG//ZB9jmT5wIOVsYvJ59Azm3q3sK07zOJzHW+HIcPx9eimYaokB3LWDS
	ojFWVj64vcRE/L5gCtg8Qe7OJCPs5yCwj+lYH3ML3W5ExI/fpFtz3ZGW190noxuqAirmi3
	V0OyaE5QXq7xsLYlXxkSN2OFJhttOFM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ka9YkXJH;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781688549;
	b=u48Mmj5GqtewAwq6ffuHZiw1PlYTlEkJ3NIn9q1BuhwVOHkavwtgS87Wu17/I4s0grj4AP
	WfJAlCqZq5TQTOQ9TceohoUb37dqp2EC5JMRIL2/gQt/KttHr8DmObKM0l2ohlT6R4Ce2G
	NX5YayWm88NA6nYIt4DZkSbeeP09JFc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5992E43260;
	Wed, 17 Jun 2026 09:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB111F000E9;
	Wed, 17 Jun 2026 09:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781688548;
	bh=bl4HHza+GTCgy+MYtBFrYAN0WFCZBYUrBco4XR9hSIM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ka9YkXJHHhSQQnBqIKSEgvcoiOLqdDtfGSALn/LNvuy2b8RTgsJp39DWDURwtGQjI
	 sxCeuYAXlA5pSal2qPm/tbUTvwxjWEMJbdbhe3Y76PO6dSTd2i31kqupihTqVaSl4i
	 0JyN4HwOwONPu1D2Wtvg7oltowBDz6evuehFMSRiDpA1ZDtSXI/LpoC0R5CPrLuoTC
	 urb0kRVqbindWU5aebR7rtwOvjto39JuIenS7fz+LK4UphhkHAxvRYz1BmzheVpDnG
	 IrKSXMSEAfhYxtwtNl3GiGSXwszvgmEBUJPuBpUQZRq7cEDjahfE1FQq/U2DyvZC2M
	 OP5ICXShkpTWQ==
Message-ID: <64c1908f-a46e-4489-8f1e-6dabd8afc8ae@kernel.org>
Date: Wed, 17 Jun 2026 18:28:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/15] mm/slab: allow kmem_cache_alloc_bulk() with any
 gfp flags
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
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-10-ce1146d140fb@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-10-ce1146d140fb@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------iK2XvNSkWB0k77xTG0u4rrFL"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2C7884000C
X-Stat-Signature: 4hkrkbpheqiojqacezyhqzbewfbxwuch
X-Rspam-User: 
X-HE-Tag: 1781688549-442343
X-HE-Meta: U2FsdGVkX19kpLOo3TtZC6Xo4br3NNq7Z30RmR9WLDSCgU6bPZJsDkP5bfX+6SXp4veMNl3NJ1t/q4dNNdaEQWpWhbpe78LD5M0ISSZGJ0cffjZ3/P7vL6BPihKND/6t8GKE2/Jy+XRwe5+4ZZA8fPIKH80AVkHWmsP+avx4aIiwLbvKnCagiOT0aSYqxkQtK9NgveFe6Y3EAewvX1Hh/HwhWVGS66bfBSi71vR1KIhAtXyNObXbnL2DfoKmeOpKGb9nYk3gVBC92IzDg9+BuYT3gZzSgAKK9e4pO9bTxrz6OFr7dSaITED5AaQ/ZziX5aIhObZTMLKdGaUKbrL6nVEQjJ7otGGz83oxUcGRYaUiXU2Ywe4MCal7nEzlqRZndJMXQQ4HNF+2Jbsf5pCKlWe3ULx982V0Tg/5H04cqqGLibK5sU8zv/Z05RRGF3Q3XrsWwhVPpcLn1MtWHY3u6W8DpUSTPzdvmu68csAywteBXB8pWSrT/87A9lj/Je7vwloO2xhtcCvw58nJogQVRg36nvT+0t+/7Shl+4aSd6VH0SFv20AHIrRlQzg93nqwsbHL528kuzN3acbzTNZjf4qU4rswJ7/klEKnhN2ZrvOW2OAq/dMQVecrRyQB+PwnODn951jbUJLcH0Hf0CiIaGj9uIEM5i2iEBwDt9CGmz0kqyVt8f1iPdd7FWPUDHJIoNUCxxit/ldzqGZpxlGdEVbyt0NaC677/cq2B5W7hsGsgYtlBOYXqHUDYJRKVPb/8UOGhM9ZHdO0PTUO80lntud6Aq+4tuvgrMYQuHQZHGNGswbbvv9UrPxouKIGGacNb4r9n4WXED/BkEM/IwQbXa1GQzjZ4inWoyhNpSXAm+hAAzvU9o+CfUUWCaV11f0V91p5dA1EbWqtdUABtvEsG9I/n0fnISBLw3qBdaStMHtTwyR09G6QFqyHXKYo6gAtDTQ0WalbbSTA1n8IttG
 qctOp+di
 AjNaLPzJsUjjDjxOGyYsfiu0aZwR28trgGRplQpSbUMHEkMmFGeghP0rb/J71/0FXNI/vRAmfHso8u01PDF8cNUOxAI7gkv5a09hOFoIBW7LXwh6SuVx6/q/SplVD/xDBNqxMXwwM7MDlzHTq3euEdhOjWG1VuQgMcaChDF/A88BS7q25mMooidPmfJT+pzCLlDISo8c+qV4ZBcFUu3GLCf/sk2iFz8jCh2KsNFX+kabjfSvfwAtgzbWBeRCTRJ1OVmFnhU7xS33f/EzsGOW+Ju4X52NwY/W5VMn0iAN12L5eZkO3Ly8/PvSrRptWJCMGJ9Q283qbCGMyonssojloCfaSQOksEClgbIvD71vTf3NR4iVZ3B1a4h5N9BnXuim+Jl2yyyKtfxbEkW8K0IuBz3NG+776bWeBv4tVymwTLXBynZDQQQ6iTX5K4AhzTmZMut9bfmA5CdCSIS4Fq3wkEH3S6JIOaMDtEFJ5s3QA5qzBf/xahIsSMsHTowalX1ytLD2bDFlB+jgiMcqAmst8JApkhCP9nb5WeVvJfFMoN3fyDG2RlpJFsajnACZsqBKN/v8fVlHPQgYZke1WQTKi9ucM3gpTCQOURiUzpk043t2H1+p8MXrRKcsPsgW5L5Y4q+SY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------iK2XvNSkWB0k77xTG0u4rrFL
Content-Type: multipart/mixed; boundary="------------uHnflAN49MCDrkRrwOTzCyef";
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
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <64c1908f-a46e-4489-8f1e-6dabd8afc8ae@kernel.org>
Subject: Re: [PATCH v3 10/15] mm/slab: allow kmem_cache_alloc_bulk() with any
 gfp flags
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-10-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-10-ce1146d140fb@kernel.org>

--------------uHnflAN49MCDrkRrwOTzCyef
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
> The last user of gfpflags_allow_spinning() in slab is
> alloc_from_pcs_bulk(), which is only called from
> kmem_cache_alloc_bulk().
>=20
> It turns out that gfpflags_allow_spinning() is not necessary, because
> kmem_cache_alloc_bulk() is only expected to be called from context that=

> does allow spinning, so simply replace it with 'true'. This means we ca=
n
> also drop the gfp parameter from alloc_from_pcs_bulk().
>=20
> With that, we can remove the "@flags must allow spinning" part of the
> kernel doc, as there is no more connection to the gfp flags in the slab=

> implementation.
>=20
> Also remove a comment in alloc_slab_obj_exts() because there should be
> no more false positives possible due to gfp_allowed_mask during early
> boot.
>=20
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-11-7190909d=
b118@kernel.org
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------uHnflAN49MCDrkRrwOTzCyef--

--------------iK2XvNSkWB0k77xTG0u4rrFL
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajJo2wAKCRCGXBN6rc5S
1kq3AP9mF3O+9eEwZracOcmZ+bzXYCob2+uJSads3yNJGPzRFwEA7kRgdkoJgCoC
2inFLTTi3edE/X8QusVE5XIXADJypgA=
=MW5p
-----END PGP SIGNATURE-----

--------------iK2XvNSkWB0k77xTG0u4rrFL--

