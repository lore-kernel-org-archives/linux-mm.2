Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD3A3C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 08:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 209596B0005; Sun, 28 Jun 2026 04:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BA6D6B0088; Sun, 28 Jun 2026 04:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1F36B008A; Sun, 28 Jun 2026 04:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D78A16B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 04:10:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 450E2C1B3F
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 08:10:15 +0000 (UTC)
X-FDA: 84928598790.19.20B97EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A02EE100009
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 08:10:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Anemyp46;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782634213;
	b=pKKIztBnx3FETWQ1BEnmFR57WmE6RV6Q3+yg/f8geKqPUeUwCtGILYhIkXD8ABcNEuLkbm
	s4GwCCDP705ylkbY29UZpXERKeTIFrJ6KTN7y1GUyQtw5AQo59zFYkCpdKb7E8noLtKxPC
	sYVy/ja7ZQ4WmXIl7lIJLuyfbXYvihY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782634213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+h8xGZNKc6YXPq6khur0wts5VFgWcGZeZRtOQiFbhVo=;
	b=HgeETHq1Icuu3EM9iTj7mo0gp40/ictWUccFIdiENTgb5plCLTBovcmuEYHQFjcKZsyAfk
	GtcZwjUnswgFvn3NLfxlDyFE2151k/80sdQNLi7f3ecooNlleof6Yi6DvfI4MxJ7hqcfeN
	KgRhXSCIP2Q4PGwnrM1+erTfBRqJe/E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Anemyp46;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C54B600AB;
	Sun, 28 Jun 2026 08:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB151F000E9;
	Sun, 28 Jun 2026 08:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782634212;
	bh=+h8xGZNKc6YXPq6khur0wts5VFgWcGZeZRtOQiFbhVo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Anemyp46licdNraBAijIiLoHkzo+1UQ1ZvdazvN64Cp/GwsR+z65ZrxMQjiwjHXVc
	 W837L/70Q+eGDasLesbGIZL9TVpdaHlofdMoqQOTngYNJOG7ddT5t+N995tqxzzqYG
	 5EKIb0IKSRI7hXS731m4o4T8FKbld2Dth7yu1+gaogOoC2sBBCGbCRbfE/xTLVyNDE
	 lTmtrsHTRgze45lCkDe9wx1XLziCCicvDQdfixCuKEFPVl8vky/od22TDk5Xw95ljc
	 jt90KhqEC7ozcp3ktgZGSTWzwL4B44Li2F+3L2pUCaUhiCHYTEi02P1wQHXXcd0pA/
	 XSGveI9wUonog==
Message-ID: <0925f783-1506-4a20-ab9a-3130c2f07ed3@kernel.org>
Date: Sun, 28 Jun 2026 17:10:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------BzaDD78aLc9saRG7mpOf5UwL"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A02EE100009
X-Rspam-User: 
X-Stat-Signature: ws9ezfsf3cyuczo6x74hqqjf7pwmbp1p
X-HE-Tag: 1782634213-386055
X-HE-Meta: U2FsdGVkX1/dis2GySMEyFdbdSEzJMVVXa/05P/1o5LGZAw2saOJoC30LCG9afYRs7KXxfPQCI1Rb8OnAjRFh/p7SLfqoo2uaIfkfTjZwRUa4MLShJa1ueTK893fcIj7yY7oCjYD9djVEvpDcFAQTiozBHf1Y0x7Okr8XwvQGT+/Ev5z0WP58e4wJ/kcM6HknN66wKXCbmfX9QFtJEwzRAikMGL1Wuc6M/beeFdHZ2Hx51gy2uhv7q3RYFhXXmvYkP3Pckk5cWfG7i7oRJbXrKmW1x1EkZ/MofFacVfkaTwDtmGfRSAriJb+j7HayNrL8pnYst/GU72DULCDsdLIFQ4q7VjCU36LROpeNyS9IOGkAQCU41nsVtiLBg/fmMG2juT5oDlpcbkCBsNpctDNY6J76JV6GAOih9jZggXsgwPcPqgxtCExxGt1QQbdW7yqjt1gIA0BluTgD9ST1fM+XSUhppSL38P+BfjS5wd7twEldASe799c49tc52r/o6RlJCahvd8ZuTURkHqgOdig1wECB1vO8/d8Xzf7jL1Xw6xrPHAQVGmgsoSBc4lnQSv4d+FFMATLGvdfvUxnkGdDLVTVoUU7fwGuL4md8QoMofzu2bgSH8Qxyv1/uywv1O41qI1s2BcguYoivo2jt9nOCi4sFR2FjPxb+UHoXAyOiLU3d4Btw/+tKZzsIkjq3MruxyRnORZzLNyjjUgP+RxnjpGfxMS9McVLfK9bE1msjutumQji/5GhFKZgDkT957JQsk7puLRe+5fxxD8a6iM8dqE3XV5OtZfpi7URopOyafwKPFne3odG3ynKwvporyYdJ3mbFKA65wlZJLfSL5vBXm2es866UoczC8lNIl3sTMQsh/7tvy80QJYraRsqpNcoUUNjxrG7quCepUKwDPyJRuWTVtuPwY0KmSaV8GcNIx1yD/GbHCGhCBgRmi71Wpd/VaN+huOjqVquTqZrW0s
 dAV0iRA3
 cqyrohU2YqVd5eN8Dmm7Ohppl/wvfwzezkiNjg6TqYSs6pXnv2eySt3jpf0q2PUseOvotwIuXP2UuKXZ5e/XCk6b6qHJYWK6OtJvrEPP4gJqcZRvJ2O+a5IiJrer3wQeeWKlRllPG5AKgcHzfRKxproFOK6UYI9B8beEwQ+67qnAxW8V0OV28cH59vRxevcB8hHu37HS39PXQe8beoZN56w6yT1Yq6YoMT2vN2xRQcZ6rBLUjBxuLLI+1VwIQGAaTH3XCsjNdBkEO/BkbXRZeikz7NL4wnA65gzeCs0LaiM1CuYGFhZhnN5U+YHb2CqdhoMKOLMz/ksN6SLPK16ninm4kMV8DFvUDr/56TgsZudvuPt2hw0/4GUXCUuvYsETMmTjJA8lrQrjGmkiJYDWKL17TT0CnFzkt5prUCubnxRT3dt+QOKy+/cIuAgUdxnLwYGGBiqeJ/pJn02Cm4YzCdkL28kyKToRh8c1xgOeOhl4vrXe2k73KFrH5yroug4pDD05s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------BzaDD78aLc9saRG7mpOf5UwL
Content-Type: multipart/mixed; boundary="------------MB4ESdZ0F3dP7cD36LoLmprx";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>
Message-ID: <0925f783-1506-4a20-ab9a-3130c2f07ed3@kernel.org>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
In-Reply-To: <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>

--------------MB4ESdZ0F3dP7cD36LoLmprx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/27/26 2:11 AM, Vlastimil Babka (SUSE) wrote:
> Minimally I'd now want to only do that size bumping when allocation
> profiling is enabled. Ideally that means both configured in and not boo=
ted
> with "never".
>
> We probably should have done that already in 280ea9c3154b2.

I think we did already.

obj_exts allocation triggered by memcg has __GFP_ACCOUNT, kmalloc type
is KMALLOC_CGROUP, and so is_kmalloc_normal() should return false?

Perhaps a comment above !is_kmalloc_normal() check would be nice.

> Because AFAIU
> memcg-only obj_exts array don't have this issue
> (or maybe they do have the > [1] issue? Harry?).

memcg-only obj_exts array doesn't have this issue and [1].

Because obj_exts are not accounted and so we can't allocate obj_exts
from KMALLOC_CGROUP.

--=20
Cheers,
Harry / Hyeonggon

--------------MB4ESdZ0F3dP7cD36LoLmprx--

--------------BzaDD78aLc9saRG7mpOf5UwL
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCakDW3gAKCRCGXBN6rc5S
1hS/AQCy7EgueIeApxj3Ba5w4CqMIJjhX+COkASUuiWXWDVJKwEAkgFpo8rzSL9j
xjjPMOV/XhrXJF2zejmzwvdqjhlOTAM=
=4FFO
-----END PGP SIGNATURE-----

--------------BzaDD78aLc9saRG7mpOf5UwL--

