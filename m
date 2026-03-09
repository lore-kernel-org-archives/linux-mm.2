Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30673FCA16A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 18:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8106B0005; Mon,  9 Mar 2026 14:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652916B0089; Mon,  9 Mar 2026 14:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554906B008A; Mon,  9 Mar 2026 14:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 455206B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:07:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD4AD1B756E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 18:07:09 +0000 (UTC)
X-FDA: 84527306178.22.945EDC6
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id CDF9B4000A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 18:07:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=b4Eud+B1;
	spf=pass (imf01.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773079628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MrfDzIDC5Rwkn3qiBzXUKn7XOVFFMBF2JI8saiP7iIE=;
	b=4Lhtm5IiGMnI3zX2RoiuQGA+xjwGNxPu36YMJ8eS5VPtyGZQAu02jifnLDmTHk+Ogi3DKh
	5LU4li3gctGwANPU9tg5OkwM+ga1RIsPxW9+rKygMj134A+omP9hqcOyZ5cjbnZUgL6wl0
	j7bq4dec+cwb0A+CoXl2k8mG7sYUB4Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=b4Eud+B1;
	spf=pass (imf01.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773079628; a=rsa-sha256;
	cv=none;
	b=EcfR2Ve+9pMzbG6+KYvNFLbBtzZGK7jsvDxQHmsQeF/DijwUR2WfrIE6GCaWg9WiskU2A2
	1efsxcCF1IgY+d2LgqptB/iVCaroK+LERHHNVgN82ZjBDogdgZOedKumEeTKiQ7l4h1L0d
	JJ3lyw8GOXOsc1JgiI/UZZx+75Ij6TQ=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-439c9bdc1eeso2539056f8f.3
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 11:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773079626; x=1773684426; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MrfDzIDC5Rwkn3qiBzXUKn7XOVFFMBF2JI8saiP7iIE=;
        b=b4Eud+B1XgzIgqCRNoOMwhQX7fIBp/DE3rt3D4ZuUCnX5NJhkZw5tqlGEcl4oxp7Ae
         f80x6VD9P/GJE4g+CPEtkeIEziyGLgGKvtoUPaak5n1BYsOG5xdYrHwcZ0+PYB60xWYf
         HuoKES72idGJmGE1nRVsoWCceHBRTyMi7g24dbrn/PwRT1LD+4aVfI3aChNnaVjcY5Hu
         rnxW4ICLs6qDf05jCld/SBuaNAJWXqXcyP/Z3JaX9KSufI6apkbZ1fjBcid8EElKvEpQ
         z5Cq/fcYaMlG7FofWHwOmU9JFniLZJ5J3t39GW1YjwnUjXzpROEp36U55Sj2vgQP1BO/
         oxQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773079626; x=1773684426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MrfDzIDC5Rwkn3qiBzXUKn7XOVFFMBF2JI8saiP7iIE=;
        b=nnu70acMa6aYLuIdsGhHxXoZPGj1I8ASgcl3GPcbj8UXX/GKzKFxfzsks3ddvDDbxK
         GlFHXWvFtof0eo2eeMtkMasrlaXrnbTBaKHDRc31skhN0TpZoBKmXlbCn2Yl3wu4P4Cg
         xirOen2kZPAMz34iGDU/egv3R/4LQhIKx+Hf4bi63Q9+6xR/RGIs+S4QAlaKsBrzaXEC
         9UfJSrQ5XBJKBj10p0dUA2zzSn1qQFdSMRlO3A7lbX2kesWL1/eKHLzfTYDO8Hotn2+B
         OjuwnRkANaNuGfZnajbYKp+q9+x3HqRNj/4IntSFLOC3G1eKcf8UCbOOKeHXTAMGpUw1
         N+Ww==
X-Forwarded-Encrypted: i=1; AJvYcCV0cb0EgqDznXNmvbYo1Z2RMOIc9GIA3iIdJEILwpLdsfHO5oyPkQH2ZO303a0KVJvOE2Q8uv44MA==@kvack.org
X-Gm-Message-State: AOJu0YwvoZhAw4oxRh5RoyZNVOK/MxsdahZmq+Qgdy4moXXXtNNFU4v6
	Cb1oBIlSoJOGqZV0BzXHy5pQcEmd4qo5umiE9SaEbfTdarqFqqYxFsiukGhyv6FrJBI=
X-Gm-Gg: ATEYQzz151IQgjJSa58ncBMbaISwMDV+QQrp+PnyKjSeMc2EO5Nz29DdpZkyqOe5h4y
	spzcQWz8leMeAmU9M3r/pqqczY+o4bpsTgXwZhBjA7UZttYB1/x5oIw+UhdzaU7cIL3AzKEuUTJ
	MMqB+PBrrSeNVLz0ulRXhv1qBM1xFYZHlZHNRd74YpJjxHXBGMZP5Dvq2zm4LmSURDPUcxi3A2N
	Wk5F3nSkLDicQ66VkIHW5dkmTs+fCPCcVc0WwUz3pA+n/afxcTsstJYhKF0yLWWH4zKogrTBYIN
	ZRbgXzMJDMAfbaDrATEJBUke1K8MahIMHZD40NB/swArqqHLAVSqVVFk5ZLcGrNqzMc13BBbRrl
	PsSQRzF+Znla3i6ixd9akUKCaDXD3tGbD80SL8iDvXnZ1FBbW/iffzzRzY1j7VKPfzS6Vyd2Eun
	dLmrcpKeMTvKwx7hhnHraEGoaL/oX1OdmweufTPgknHeo=
X-Received: by 2002:a05:6000:220d:b0:439:c43a:acb1 with SMTP id ffacd0b85a97d-439da67c0bcmr22231635f8f.35.1773079626120;
        Mon, 09 Mar 2026 11:07:06 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae2ba66sm24939422f8f.20.2026.03.09.11.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 11:07:05 -0700 (PDT)
Date: Mon, 9 Mar 2026 19:07:04 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftest: memcg: Skp memcg_sock test if address family
 not supported
Message-ID: <4ddd3jascnb6nt7quhyjfmsgsmtfmjofwmnrgjktz57cfbfymj@6ejbdgbg4lz2>
References: <20260309160205.651754-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yd53fwzzczbtgjoq"
Content-Disposition: inline
In-Reply-To: <20260309160205.651754-1-longman@redhat.com>
X-Rspamd-Queue-Id: CDF9B4000A
X-Stat-Signature: x1r3gqwkto7nfz1ck35b9b4fp9efyxyp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773079627-857578
X-HE-Meta: U2FsdGVkX1/Nfq1RSCBbWBaOEGh1e53W5dCtPC5h+qrlqY0OWG6Qqf3OsEpcQkg37iXNQoRCQNCkAnOEEhWOGqBo+xI5BlZpTU450NAhrRgw0qUcv/CXFViheIk/RReunP46O39PvYsPzO/M+P2FBy+qe4rL/tEAst8h//WZ2TltIQKqbSpd7Ukc6hFbjs8zLloQztrJnLdQTEXcnrm+7SkiS4Bjo+ov4QXLEazSHKInK8fAsRsWyaF8eAJqABGQYHQzqpy2Q8aVKse1bQIJ1akpxWpmIbgI7au/nJgi5xfjpGtslOouZSqL3wk7e3ywXt4VmfLhZ1ikJD27sYFRW4AC0lWWu3X3XHpnuvnqoQR2MttvLqiAJgVecnTuyZc3N8ihQtDU04wNAQWqTTFvgZiTSvOYuimug0dj5XsZPSsmR4ODwqXRR80uc+Do17JTZVbGqNR0RaUleD1bAs1uDUcQY6xQFs6FHt7Ulg7nmNqqHuUEX3h5wBUBUXXXbcn8AZL4x4Oo+xp74E6jOlQD1uVK0qfq4LrQU+1XVVMqK9aqVIpNv2HvJUoe0BtFC0JU3hMSAd8ONrLvRlZ+as0WC6aZYHZXm0f/nWcygoE45wJnOvQ4y6SIX/04SkFeonrroxarUKnQJmBeRMnws7eRXt7AhPnh12IO1Lq+ILEyTUeK7EG60fZ8klrWKMUNVyvAhUK8cE2l1VgmvD8zpbd4V8+mx0LumpXT9mv2yV7lpbSXojrcoxm4jHTut3v7YcOcJ90yef7AZUaJDD2+vBvklwURY3h2PL8DTPOgI1c62kwvwYAhWPa6VeJrsDnQrteU/QMtyhxdi9qq5+pF985CLSV62GHwD9KSVVpVnTgwD8p1ItfROhnt6i2IRjTXSdVXhG2XM/GyTXsiFDkruCh/g5j1rCBiCmhyGVLSVzVp0ZiEx5ZDhfEOEhOkvo9a0vOVDDqO48XHUmcz0dHNsry
 3u4zSCmw
 PMzNC2TOy5WrDwuiJGgCJT6KvjiOmG5fHPbvUzxaKYvD082rbixNf1IlOmCCAHWzdsdnXfksQO/tOhmTBNYlCwQ1jkFkEjy6BO62QQdmT/frjhOlnIOPQIAJJG/AVpm2SA8ohPOZDXaaFJFXa5RteXWQs0NT6jmjrONe2v3ICoNpGArlYozzIUJdYyiOOOU5IUMspvvX2pNuXsYqGGN33kFx+HvkEE3IOrlWM0uq+x1CVGhSiyQYFW1oPnzBiykSnRU25wLK7kGY3hf/9yuL6CWtYmABUDDL6/vtvmJvr4tub0tP0m6PwgB1xysqV93iiNjzMytBY7DDAl23LFPSIv3nxQ4Vk7UZiRo+fkTmthmrkexYByxRrSRGA+cjy56qSoZFFGbgRGuOwdScYuDAKIf3+u2bQhmYjqJLRf8xtP95eBht9o0+tmbr+JmofLnZ3HQ19euclegZwDZ1D2u/+HizsZNysjmLmwCZa7Ny5BLH1ci/EEa3uKJI51eG4/+D/KLax
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--yd53fwzzczbtgjoq
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] selftest: memcg: Skp memcg_sock test if address family
 not supported
MIME-Version: 1.0

On Mon, Mar 09, 2026 at 12:02:05PM -0400, Waiman Long <longman@redhat.com> =
wrote:
> On systems where IPv6 isn't enabled or not configured to support
> SOCK_STREAM, the test_memcg_sock test always fails.

I think IPv6 is not substantial for the check...

> The purpose of the test_memcg_sock test is to verify that
> memory.stat.sock and memory.current values are close.

=2E.. so this should work with IPv4 too.

> If the socket() call fails, there is no way we can test that. I
> believe it is better to just skip the test in this case instead of
> reporting a test failure hinting that there may be something wrong
> with the memcg code.

Yes, the skip on (any) socket creation is also (independently) good.

> @@ -1460,6 +1466,9 @@ static int test_memcg_sock(const char *root)
>  	free(memcg);
> =20
>  	return ret;
> +skip:
> +	ret =3D KSFT_SKIP;
> +	goto cleanup;

Maybe make this analogous with other cases where there is no specific skip-=
label but

	if (err =3D=3D EAFNOSUPPORT) {
		ret =3D KSFT_SKIP;
		goto cleanup;
	}

Thanks,
Michal

--yd53fwzzczbtgjoq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaa8MRBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjPoQD+PmjLLORgemm6L6Wd7y1R
hoB0caqu50AlVSz1SKP3ThsBAP+AO9l6EzSrSBWNiUV7LSV/NsXeLyrdxjriU91M
fVEL
=GNSq
-----END PGP SIGNATURE-----

--yd53fwzzczbtgjoq--

