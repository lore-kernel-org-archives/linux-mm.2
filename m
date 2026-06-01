Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5470CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EE796B03EB; Mon,  1 Jun 2026 10:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39F386B03ED; Mon,  1 Jun 2026 10:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28E4C6B03EE; Mon,  1 Jun 2026 10:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1630A6B03EB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:53:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B51B540206
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:53:21 +0000 (UTC)
X-FDA: 84831637002.04.A537C38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E65F040014
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:53:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AcDv7JBX;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780325600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xiQUMkR7UOdZhhl/sVNZBEvY/qGg1U4+w0VidMXvdpE=;
	b=su9azNhL19N/PwXGwsJ08AhON1aXh1gSORlKASI8K1Vhx2Hm/O4k09D59Emk5OSfWTdb5t
	bgj3UmpEhagvOxO6iXWJBSZF4NI2FWEuU0rhSB+yhk9ohketRHB5agoTrVMrY12L5TRP3h
	2HweY+rBEh7CLOaOt7XzB4CtEC8D1/I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AcDv7JBX;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780325600; a=rsa-sha256;
	cv=none;
	b=hEiCcEXp4QY3KsltGwNYTLjEqzGUQI59UviYttN/FDg9XJDxeZBVQpb79cMQaj61ButgqJ
	y+GHTzynr3VF18tQCJbTqJ86bkFd1CzNwdNzkRipvXD6X1v9mLzifV6KjDDO09fpF5WOuG
	9jKPhvmWYhOFfCVyzDrZ6npUS4eLiVM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 16C524427F;
	Mon,  1 Jun 2026 14:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8751F00893;
	Mon,  1 Jun 2026 14:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780325599;
	bh=xiQUMkR7UOdZhhl/sVNZBEvY/qGg1U4+w0VidMXvdpE=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=AcDv7JBXv1WuUyybHXbNhCxJc3oOpdXhk7ixtIqrNz429V0cBKGsHpoNWlfy4KzNV
	 nz8uVF2PWvWVekKVwtrkdawEeGIq7I45cAyHLWU5Ar18hskeNTHkZniqkGyz3lCz3K
	 C5w697+eSrqpqovKTdEYhxc2J5Rp+eir44635M31NU8/7+pHWMyROGdifDECzq0vER
	 VUeMbXWYK2FMmSOT3l3h4Ufkj8AmUpvB7jSh7t0fjCSmfFKHDzOFTvCIEADY+VeMiz
	 OZU4kURbqF9inCO8x4Cd5dc8gU3ou4/UcaTPeo0RhhK3KribGsy3gSYF6MfQqSe3lA
	 HM+9ctma9YcUw==
Message-ID: <264ec41c-dd1f-4957-9032-943fe719dffe@kernel.org>
Date: Mon, 1 Jun 2026 23:53:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 bpf-next 3/4] bpf,slab: Add slub-backed allocator for
 bpf_arena
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org
Cc: daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com,
 eddyz87@gmail.com, vbabka@suse.cz, harry.yoo@oracle.com, david@kernel.org,
 tj@kernel.org, roman.gushchin@linux.dev, peterz@infradead.org,
 linux-mm@kvack.org, Hao Li <hao.li@linux.dev>
References: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
 <20260530011345.99342-4-alexei.starovoitov@gmail.com>
 <ca1bb6bf-f25e-44ba-87c5-e23e4939dbd5@kernel.org>
 <acc86e41-21d7-4b1b-b5de-fdc02064a959@kernel.org>
Content-Language: en-US
In-Reply-To: <acc86e41-21d7-4b1b-b5de-fdc02064a959@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------FIHDtU9jdxgAacPQ0ZAKZUFE"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E65F040014
X-Stat-Signature: zon9gihgfdcatp5jwb13gq3k6joc4hww
X-HE-Tag: 1780325599-677769
X-HE-Meta: U2FsdGVkX18h+9nu/FRtqV0Q9/ogieTDrcxvmISk9xQXWYU+YVEUunFNd9sHCVGp0F9/JNumH7PynyX7Z9Q7OKf4eg9WIv+ZPEqtEaR5vL9Vl9xmEJANGMWjXTCLlwmMk5WpWMZNkqWE244/n1upwKiZH0T0nSx/CG1qo1igQ0jeViS0uPPvGgM0x3cjbqBkp+VQFxUAxZcYZa3wmifHp/r2pnnBpFlurc+kxo4KLl3XYxIqit9l2nSWXZvx8I5vGDA+4cmecQ3NClvMLPXD0QT6X4SBw17zkejJJ2VeOq2+nrjlPGTSufF6HsVZMIvoqYHh01YKHuBWiUR0BErD6umrNjl7ApVyBbbmK1IVuuyADFgYSvwcyYnwoRLjABOdz0WTg9BKptm79WdWfXzVPfqTaxJuPxMgLsHDBJS3xGuX/Mp1rTSwhm0MijhI2v7BTpZAYN5R9rUsXNbcZrFukIKlmSYPu/2qZTFPI81yP66XkTNx0GgeA/ZEss+DTfg4QfGld+rX+fvY+RcKUv0Ll/zF1DlNbfYOzK2HLhkbRH7yiQwY2MLTwQcXfuO+W8VdPHGSWpbMJf7FkMNCT/4rPqxLkGEU1ssvJBsTjmv13hJp+9GXYCtRm5iU9PRUGqEYiBK+f72DjJlEa4ymN6+QG2VgP3P5zLV6cPJ2qEBM4qcz4QC+tuHL5JyWKww9HVqs8dvL3BNMiHwkWSwDYgLpbRB5LnZ30FLe6ScXMGoQedDCJlHA6BL0p0JoHZS9M2DRORey9bxyMIC5hSPfKapWoP7fNV9gBBnRhJMO6Vs9bdLSU1+97bWFUuK83Q5iUJzZBNBHJNnqLKW70jtecRjGtcOqn1xNTIn3DQINyrqNQjedA0++uuQHZ0LtCY+2kenT8yg4vx8yeWIJ5dCJM6mvAuKLVbCKc6TZwQz9ZrJCuSRhFD3WKrWs8xUaWRrUjc2nTreG7VIYacfxSOP0+60
 xeB+jAed
 MzndUPfmms1FEppIpS1PsAVjqszPPV1f92WGK499/KtH263L0OFHF4U38dbPwSF9AGGhPkCS1Z2CPhxE/ak9888zU5wWWDIo69dBnLN6fLiN/UQF/x1qHjlrHNI2aVWuE+pTy3REGgN+1QT2LvQXBB6xkuPnyU/HfaO36MWsO7YvWFTSXJH6YQBgtG8n6E0nmMpQNX5mP056CBmCbr1jgGJ7s5vqILwfoYyPtTiLaYsnCOcMSco/ygdsnh0tk61nMNpq0HUH6Q/s8J8A5FappB43J6ZqwJ7iWE7EWO4rR4qPBFA6PkUTjNvSifwCaeZeJmpG1/EZq5uzqsbQGIVdE+xWQ6PCwlfTDpBFj6m7I6e5qeyX/EpVTdhuQ8x7I28DLNcxv3Ba7jSxQOCQearv0hXXlAcLqC2rVho653nHyFuzSMlCv+o7PrMf5p/BSFf48hwOHZUAQ7SroWAzyqPRCMa9m0OvVVuIP8MrsWYEjv1SlCeUP/FqLgq3fgE6yjUnHoAJfuIkLVlrBWouSMt3OJMCVWLDsYXYVrrsd0k1bzfVwMitcqGPJ5GQ04YPnOMKR9c5nyjCPL3tqCXNkXFvi3cXGPR1LdD1fl4JP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------FIHDtU9jdxgAacPQ0ZAKZUFE
Content-Type: multipart/mixed; boundary="------------RIxoiKPUGgqRDcEnXTMRgjKn";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org
Cc: daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com,
 eddyz87@gmail.com, vbabka@suse.cz, harry.yoo@oracle.com, david@kernel.org,
 tj@kernel.org, roman.gushchin@linux.dev, peterz@infradead.org,
 linux-mm@kvack.org, Hao Li <hao.li@linux.dev>
Message-ID: <264ec41c-dd1f-4957-9032-943fe719dffe@kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/4] bpf,slab: Add slub-backed allocator for
 bpf_arena
References: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
 <20260530011345.99342-4-alexei.starovoitov@gmail.com>
 <ca1bb6bf-f25e-44ba-87c5-e23e4939dbd5@kernel.org>
 <acc86e41-21d7-4b1b-b5de-fdc02064a959@kernel.org>
In-Reply-To: <acc86e41-21d7-4b1b-b5de-fdc02064a959@kernel.org>

--------------RIxoiKPUGgqRDcEnXTMRgjKn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 6/1/26 11:36 PM, Harry Yoo wrote:
> On 6/1/26 11:06 PM, Vlastimil Babka (SUSE) wrote:
>> On 5/30/26 03:13, Alexei Starovoitov wrote:
>> I'm far from sure the masking is enough to contain all the bad things =
that
>> can happen as a result of a corrupted freelist. Even the hardened vers=
ion
>> wouldn't help much I think, if a malicious program can both read and w=
rite,
>> it doesn't have to know the secret seed to craft valid freepointers.
>=20
> I hope "a malicious program" doesn't have CAP_BPF, or am I being too
> hopeful?

AND (hopefully) distros that care about security don't allow
unprivileged BPF programs these days?

--=20
Cheers,
Harry / Hyeonggon


--------------RIxoiKPUGgqRDcEnXTMRgjKn--

--------------FIHDtU9jdxgAacPQ0ZAKZUFE
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCah2c1wAKCRCGXBN6rc5S
1uRYAQD4ZwK7PnE6cNfZQnbEzHAyAQZF0oKc/wLME8pIDNGGRAD/alPo/FTKCWSR
ThPaEsBmdazfnhU2b/OP6afE0MHz0QU=
=Re/5
-----END PGP SIGNATURE-----

--------------FIHDtU9jdxgAacPQ0ZAKZUFE--

