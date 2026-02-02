Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4153AD172B8
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 02:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88BA36B0005; Sun,  1 Feb 2026 21:44:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80F706B0089; Sun,  1 Feb 2026 21:44:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1326B008A; Sun,  1 Feb 2026 21:44:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4756B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 21:44:47 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0557A1A09D3
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 02:44:47 +0000 (UTC)
X-FDA: 84397973814.20.7AC06BE
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf06.hostedemail.com (Postfix) with ESMTP id 60E2E180007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 02:44:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=RgPx9Ukw;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770000284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRPoJejSWuIyH642BDSOfOKubNHu2Ehle183menmiEI=;
	b=NwepgVFjbObH+A70A8i3IWi8zVwSVNfGs9w2BTlt7/XMEr5q0KJntZ5EnyWbTtKxi6ABR+
	Ux7XpUe/tE5l3UyaiD1oEawVteb+JHnrqWft7ePoiJ60fBnUBRghMrF3HgqwIEHsqi7mC7
	7DTo14bvQmx85HFo2e/hBcL4BBCQ3r8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=RgPx9Ukw;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770000284; a=rsa-sha256;
	cv=none;
	b=7BJOz/0EubaCIHSiz/haeHPoPcCJ1bWlvH/NjzZIsDIDtIOEvfTD74P3fg9lis2FChSP42
	6irhpqFtAYvDpKEycFP0UtrGE3ElTodony5f89dqRoe2v++COKwjlN5Q5up/SrdZGF6FRh
	iU8h2HwpMcSJZ8+sE8RN0gHXR55tLJw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uRPoJejSWuIyH642BDSOfOKubNHu2Ehle183menmiEI=; b=RgPx9Ukw8SUU7ODK+w6yxlg8ud
	KZ0W6+9HvWUgfzkG9vWyyL4aCiecVqCTsRkNsIWSOaqtBnGALUmyRm24E9M5XvIdx7ZpDARVEdYgb
	LfO+sQ1DAbgon5/G5/k78iDQpOSGG9OxWSfMK7BKBR/Tu9F4cds9deR3qwVzi+Y7qwMdxwFrtyOB+
	t05uiuoc7UZufTtG0Jo3/qC8MaRkuG+zjmY10uYMjNXpbhZC7VYYuyHiLao60EtvMXovWQNhr3Xs2
	JGrAhL6a826zPGN4RY4Jvf21kdObjr2aTUTe8dTKu/107Jr8jog1IroNVs5rpSRMb4r80s9vawTpV
	EmTDPQaA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vmjv9-000000005fV-0nGb;
	Sun, 01 Feb 2026 21:44:12 -0500
Message-ID: <a0c6c8d86ea05dcf5ff96a9d48d6ec79948c88ee.camel@surriel.com>
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
From: Rik van Riel <riel@surriel.com>
To: Usama Arif <usamaarif642@gmail.com>, ziy@nvidia.com, Andrew Morton
	 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	lorenzo.stoakes@oracle.com, linux-mm@kvack.org
Cc: hannes@cmpxchg.org, shakeel.butt@linux.dev, kas@kernel.org,
 baohua@kernel.org, 	dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, 	Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, 	lance.yang@linux.dev, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, Frank van der Linden	 <fvdl@google.com>
Date: Sun, 01 Feb 2026 21:44:12 -0500
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 60E2E180007
X-Stat-Signature: zrp3r66iseguzthhsbtfrrp7q8pqki3r
X-Rspam-User: 
X-HE-Tag: 1770000284-264276
X-HE-Meta: U2FsdGVkX19Pnzn7njfyZpd7dPKDZw1RL5kjmgV+7sNGVnxP6ld3zMO2dVdzEZ8EtaKY+fCSK72MM0VSb2+ZaPWQBpWWCd+nDh9zsiKd3F5wUUrNV4ldp26kf+16lMblCwVnY/jgwXFwi2RCAVMWBsIXz4RS0WM11nACdGYFpROHCW6p0gFgKiAb/cmwbvUT0MtZJIeZc0EjsCdia6tlJEnUqaPwFropIv+SDF4vO3ngVEIBVx3sRyVi9zJbwa2APu81JfKgBwBlzwsQhB5XHyK6vM5pVR9+8v8HD9dxDyH48B9GkvuBjBJDaeZQyfvWxVSUJv/SQTf6PlbqqQ7EeZTE5cwzb7DoFHcPRlS/BzYtlQuiD8vs2jZRSHRPwwZIWp9B3DciZO3X26X9T+J6B7EV0FvJyh1kXbJjBPmmjYATQkHx7Za7nH6KTGA4mrD6PfqYckhnHY6g7Lnuuh8n30t/IKK2V4NU93/AtbceBzngVSV8IwCQ1ZUUi4BhOBnyNtanxQZ3IAzkSuGvomIzacjAhmvy70wIbDObzLtR1Ho1qobTBplptWe2XLI2p3xySIsnWhpIELE08EyGDAYvxTjZPzmVQR3b+qWf7w9LlLYfjVY8Etu3qlvgP59mR1Y4m9wP5FD1pHUEXI7finTRmRTChrFWE9VBcMlTOlHMzJG3TrgW/RSL6/1i6rzRS4rnMUu7ss779gNE+sPvDXrEWIBfQ8I+xiSxtl6FBlzS/u0s+u+/3WsQ9tGRxl6lEr3cjDSaPCagE7JVe84FcpYNNr6gOhBmcd5w0x7epW8hz7cf0Hok1508um7guJfRN9GPlg6gFcUg8Kakk6MS1+SaMCdazCsRwGh2UpO7U8AbjREpeV21/fBg/FBCXBm75Far/25VIDUD/m8wShaWXSKvh6PglKalYJiu5GMevcjeCbmzedg4RV6nCazcEJEK+1UbrhhGIpPCNLc43YWk5sR
 Iwfhl0Nv
 LoQDi1NXfR1GnN6qzcqDFXgM1Og7DEgJaWr+rmzhrjjE8snDBRXQg4tplk2H9z0PhHbRUmPZd1xYxu2HDzmriDBHnShX/Wor007n05Ew0LJFfsF/TOj1avZYsQwBq0itOlxdSJxbVG8HekPQDcqm0vwDldZOj+lJfxHLnV3vFxmyIMDOlQ18PJx0YgWcRV/9AAcziqgcXmJbaUaA74n+EcOUiiDM+GlupbqFtXO20Czxi5lou377ppk36icdlSpf76S4uAq+Z1run/Q/ickdys61he+yonXJNZu3g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-02-01 at 16:50 -0800, Usama Arif wrote:
>=20
> 1. Static Reservation: hugetlbfs requires pre-allocating huge pages
> at boot
> =C2=A0=C2=A0 or runtime, taking memory away. This requires capacity plann=
ing,
> =C2=A0=C2=A0 administrative overhead, and makes workload orchastration mu=
ch
> much more
> =C2=A0=C2=A0 complex, especially colocating with workloads that don't use
> hugetlbfs.
>=20
To address the obvious objection "but how could we
possibly allocate 1GB huge pages while the workload
is running?", I am planning to pick up the CMA balancing=C2=A0
patch series (thank you, Frank) and get that in an=C2=A0
upstream ready shape soon.

https://lkml.org/2025/9/15/1735

That patch set looks like another case where no
amount of internal testing will find every single
corner case, and we'll probably just want to
merge it upstream, deploy it experimentally, and
aggressively deal with anything that might pop up.

With CMA balancing, it would be possibly to just
have half (or even more) of system memory for
movable allocations only, which would make it possible
to allocate 1GB huge pages dynamically.

--=20
All Rights Reversed.

