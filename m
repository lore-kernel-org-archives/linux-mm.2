Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B113CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12E56B00FA; Thu, 25 Jun 2026 07:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3C66B00FC; Thu, 25 Jun 2026 07:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB34E6B00FD; Thu, 25 Jun 2026 07:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B39366B00FA
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:22:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C0EA120647
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:22:24 +0000 (UTC)
X-FDA: 84918196608.15.DC427CC
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7E901160003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:22:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Jm4NeYAV;
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782386542;
	b=kVP9LtXZuA7yS2xQbV8xiE2DsRQeDCg/g+XCRwsvyWt4a5jH71TZ7JzMj9Hrj1Regl6t/v
	uB3alp4WaH1G7dPEmfm2F0Q7FmCpRKt8Ed8+Mx17tP1bO71bvnZGjVy+jn+8NFsneiDAZe
	IhifHRzjL1tcGmvgYawAkhQ6kD3Kgo0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782386542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7aFwHLVU70lxTypy+BaNUd+cS3ez5JnTBvAJAnKKbm0=;
	b=JB0xk7oFqREzLcmPNXhGKQHvic/FTckccz1NSMtGGHtccgK+pGdROnd/yJL5fMv8zFu3LY
	/eUKkdXgeNBTFGkVMR3Z96xU+KogroKj44ybpIIKwocd9AudGIaxw6fc5yH8urWJHi4WGt
	kKDldR6iAdRKyYd0fzs4soq7jHG9oi8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Jm4NeYAV;
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7aFwHLVU70lxTypy+BaNUd+cS3ez5JnTBvAJAnKKbm0=; b=Jm4NeYAVUMUjZt8SBlZ46hzdAH
	SVTzl1f68/+cZgP7xmVuNnF5QsUaEd9gSsFfKX1lG3WnKPav8oUp5NnlYK5mjMSfGeBSD1LOneVgO
	sV4CfnC+0JQX+hhtvM56yu/2RNaR01JYhMxzkouD3rltmO205rxDHadRBNjLdv/R24Am9gLGeCB19
	xbB4Yfk5jWe7Lfj15YLA686xwsTgA1TmvVykKDkNekPuwm9ydUy5SYQ34Jauu+EROwlYQ0hgNzXIJ
	1JM/aR8+bziYvS/i7Y5sHnY4uvwwGLrTcZuhLMgZBDmP9rTVAc+5Ldhqk8XdIgfTaNrLZFCviYrdV
	6YYmiKqQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wci9x-000000001kJ-1YHU;
	Thu, 25 Jun 2026 07:22:17 -0400
Message-ID: <5a4ff628c1b947f9cd4da53e1e64b3934a1f2d9a.camel@surriel.com>
Subject: Re: [PATCH v2 0/3] mm: __access_remote_vm with per-VMA lock
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-mm@kvack.org, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Andrew
 Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, Vlastimil Babka	 <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, 	kernel-team@meta.com
Date: Thu, 25 Jun 2026 07:22:17 -0400
In-Reply-To: <b0d9ce70-ebb7-4b79-9a35-257b69daff7a@kernel.org>
References: <20260625015053.2445008-1-riel@surriel.com>
	 <b0d9ce70-ebb7-4b79-9a35-257b69daff7a@kernel.org>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 7E901160003
X-Stat-Signature: e98k6hs8nt31ow4ge8uk6x4un6b3ztq1
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782386542-817427
X-HE-Meta: U2FsdGVkX19Lq2m+BEdnNvQ1SEAzvdtOBUYM7FA35lN9hoeyiRZWf7PbInnbhuEAzNGiGPHRa0vEodU9MWtPbu9Dn+Hdjn76B9uiCfUHo9EuxAEIxoGmelpSIWKPnUmOEzIK4uu98fbznYx3frvbJevRSpyfxMy2gASL8NGetH6a+NZXcb2J7w4ppw2gekLVoACWUDux5EfBQGcQ46K4vMyy1zIxZtznhN6w6CuSgxbyEDhBhkw6Q9i9h3oIEnQyJAxgq3q/cw/Awofo3Iobb4rm6oIF3rD993H+J1pKmDKNMNu156QDvMtXZFHjGdCQAQpGaAqVl16w2vcGj+RVlntijCRDKC9GDQb96QTZb63J3kQnEyKsXJGapjAUadgBgqxOTuYtHxzoSPrPtjRT42BkHpEwEsvP6FWRFzySuYxr6bW21x0B8JWGtbW++tzrpwL+Mq2me4DShRw1txu9xbAMMPzdt9dxOTI3vX2Qm/CJoQ8PsLpWNrSVvblM92ZYhSlVN/FE6z3Cz/c7JopgB+KHKm2y0bRQDvz0lSndltuWVfWZsGYFilflln3TKIKwk//eIZza+J4Qmh/isVlQD7l0CgfeCJ0BRKNnOtaRzO/bwtr2T36jnAMO8izjCWSp9GWu5NJ3/kTIIBrkY/qxxzaiLMc1E/KMKlLS9PCg6UdXIHlpkARtZ5hAzTvBE8myk1fFdmacBabj1QMS6/bBM/bSiiCMnJyHo7+tmLHINCUHmQblwDYMyG6W0oSSMrRQ17zgYhvsaEsa9TSM3IFMNwW/wd+XTqXiWaJ3nnERGmWxIpQyhpVIkab/3iFByZOT9lv1PfF2GuzrP+XwrKHFWAYO0iZcq7jqGrXlBq7dts/g0LFjao3mGg252qaZ0ixilvRUOXME+Ejag1WtARYWH1kIpoTR/VESWWX/v91EDZRmxAFxT9IIIrR9ptx1eYbLExfmo4ZHUM0P5ccV8Iy
 rVFW3clr
 thflqTAs25zxe6ve2HP7AXCW/R3KzAcwQW5g6hlBcKPnYiUHcnZloZLfQDxAH+UexuszEdbBkVTR/MRBxBcmhnwmANkdmDWi8AsJCPonHQ7X9jcN7Fu5vSyr2yXclA1ZEMGzC6dMnqylRrsKJd62a/qEHqIp7KnztEiWe8gh9ksdF5TgPtF8zuRQvFvWLAPeAN8UXNDSG2Ui4QrZhvp2EZq/nzDwtObXcNdvB6ScAFxoObF9mAdvUsd6XnS+l6ymH2hGDLylIqFafsToo7lfEJ/eamA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-06-25 at 08:32 +0200, David Hildenbrand (Arm) wrote:
> On 6/25/26 03:50, Rik van Riel wrote:
> >=20
> > v2:
> > =C2=A0- simplify the code, which should be ok because these copies are =
<
> > PAGE_SIZE
> > =C2=A0- clean up the code
> > =C2=A0- fix locking wrt tlb_remove_table_sync_one()
> > =C2=A0- hopefully address all the other comments
>=20
> You mean, ignoring my comments about not reiplementing GUP entirely?
>=20
> NAK

Do we actually have a path to doing that?

I misread that as more of a wish list thing, not
as something we could realistically do today.

How would I go about making that mmap_lock-less
GUP a reality?

What are the prerequisites?

I'm not opposed to working on that, but I
would like to figure out ahead of time
what an acceptable implementation would
roughly look like.

--=20
All Rights Reversed.

