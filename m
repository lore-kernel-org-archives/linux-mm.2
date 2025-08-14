Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2267ACA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 11:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A149190014A; Thu, 14 Aug 2025 07:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC09900023; Thu, 14 Aug 2025 07:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902AF90014A; Thu, 14 Aug 2025 07:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F529900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:45:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4AA1C1A0649
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:45:53 +0000 (UTC)
X-FDA: 83775183786.14.4D5D304
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7F7E1C000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:45:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OPnGEXsm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755171951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W8UKMe/BMa6O+mFHq4Z5RP3mjo6LhY8rsjitVFWMaek=;
	b=j6xqE9vero8FIAIbYfUeXHeW31AIFJabtFO2h0FPZVaZmJ2tsUaaU/sXwR8DTTzAPy/L4O
	Q2y76dTDLVFKBsaEIZMh6G72YNvktmaBGmATpIGqL+LzPH93tJZsSfxirsAkXAu76sypqc
	TkkCWAE4sMjYHVfIgbnwG3z+ns2TfMs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OPnGEXsm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755171951; a=rsa-sha256;
	cv=none;
	b=MwnCkjerD+fTYXUAsyD9Xr2v6DuVlvaQlvl44n2RYy1HK6hj5yMqSlV5gyUNWenug2uQst
	4GZVytXzR1M1NiYFkf8Nfsk+nvM8CKiwVNNDX7UZeMr1d5v4iJxrtzAhxV1qoDr8nmwpNU
	S2D6zOrMTy2iDCy2OSl3OOKay1GXoh4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B6FB4375F;
	Thu, 14 Aug 2025 11:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6900C4CEF1;
	Thu, 14 Aug 2025 11:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755171950;
	bh=FexkV7nvaMJKSQuSjt56VRn1ropgn6XWofqYu3VqSl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OPnGEXsmQefCR5XKxWgB20+CdEPRHLpwVjZ9QqpgyiEZ/0tCDnmajIc2xnznI+BzQ
	 Is37m5tR5w39ME0RZCAMaBBsKQRSYqMs9a9tZjjyQriX3RqQOr5IihltzPkGu3m3Q4
	 vZTJUJH1TKkWTXuh5TamQ5xvr35SXOixpW9FVi2OiCGYyXHmfuOj0dXi7B8UQAC5Q+
	 zxQk6CKRtdavLtwGvB7gY6HSlp4w30N0rA/eF4w9gIis1iaNFxzbmJZsXiOQE7bHUr
	 9ZJMetEeDzQbchb9v2/vyLtoHZnblpw/SncrzFzAA5/Uj9OF05Wi8okNIKcTLXJXu5
	 tNIXry1AK4ePw==
Date: Thu, 14 Aug 2025 12:45:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
	baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com,
	ziy@nvidia.com, laoar.shao@gmail.com, dev.jain@arm.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
	jannh@google.com, Arnd Bergmann <arnd@arndb.de>, sj@kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 7/7] selftests: prctl: introduce tests for disabling
 THPs except for madvise
Message-ID: <b433c998-0f7b-4ca4-a867-5d1235149843@sirena.org.uk>
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
 <20250813135642.1986480-8-usamaarif642@gmail.com>
 <13220ee2-d767-4133-9ef8-780fa165bbeb@lucifer.local>
 <bac33bcc-8a01-445d-bc42-29dabbdd1d3f@redhat.com>
 <5b341172-5082-4df4-8264-e38a01f7c7d7@lucifer.local>
 <0b7543dd-4621-432c-9185-874963e8a6af@redhat.com>
 <5dce29cc-3fad-416f-844d-d40c9a089a5f@lucifer.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HgKF1GOS9//9I841"
Content-Disposition: inline
In-Reply-To: <5dce29cc-3fad-416f-844d-d40c9a089a5f@lucifer.local>
X-Cookie: This sentence no verb.
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7F7E1C000D
X-Stat-Signature: bw4487sjsyhyg6669ckgwqha94ph7pu8
X-Rspam-User: 
X-HE-Tag: 1755171951-761038
X-HE-Meta: U2FsdGVkX1/hg9+OxExMV8n4LNAOLh5nUWPJ+zEdAQr+PcA1BaFITeXy+MrQMp6ly2gfCOQRdRmXTgjfNUbPw97NaLicVLhk954jz1gRmmdvBv4xA+IAsOzdkTcu+mYKABAUvvks25T6IP34OBsJNsG8Vs1owSeOufeuxRluaJ1QqQxvnRP4M4xR+IyAN4qvs7MCKnuC7I1ofCGSB4YoAVUJTk4QrKiSkhC2MtiishL+JMuT1KA03rxKiHdt9ENzz6NCpzPq6x3WZ0b4U3WG6uFRgru4JbE/83d18lmcS1dkFF3ADh7hUxSk2UAR83xU73xx6K9yqBI9J93Yn4+DaWJAU2cWVlFAVpfzCNAcMMnQKlFM1cBE632mn1zaI/aZt9E6rtkIlKddCfwOZB3LSSJGXc015XySpYb7ACqhldV/ljEzOrGmiCVED+H1pE0a8tpUbvq70MClf0If3lghPWe8EEq06Ky5TqbipbQTGOewzR2r6EeIULVhYGG/eOit/PDgy31F6OGI9avF7CLq8o9mpgwimFbdyjd8f51YzYbymkw0bHNKMHLoxiLEnXl/HFSlI6fJxrjnXNWYeeTieN5yg2lOt4GMohu+f5t4eYEt0PzUiKYTSb2HQRtc8oL8C4YTjy0MTOejmmRIiOl93+90+DpmvytyjCcZ8sOFerjJSAEqaheYkAagW+x9ucza9Pe0yjXyxj5TLkwI6Ptoxjc9uOePjli8YU0mv3qUutXnckeOUnCLG3miFBNtNC6rpNuU9e19RAsq9rilqnM2FsGIYIjG0dBlmHdyNd4FFbQtr/umIdPEb4MmKMmFQw2QyDRNt6xnw5CX2NP+22SbsTnuth7weGRXriwuoWG9sR5ry7c02/yihD31+o1lbJaJ8dstFE8M2tUyQZMkHBdrWDhfEb7OvTTjHznB2ZMU2gjLKP4JwcwefI/18JXzGEZqZnVsN4SPP/71+rqTpia
 HYwUg8+2
 LxFZJRFFpTfA1fT2dMk/XFQmusMIrdUqkd14/IKHrAudcFL2AHhB4CsmNkxMidIae7TA18PdfMLTGztkWksMPvk4K6X2/hy9zdfUgPoPnamCl/NvLtqoGwhzgJJhvxS8BmJBNVRIWJOT8A71jCP2KLKv6L/YTLMOCheIy7ytzc/UQHhLQ1WdHaiyuhmQ3tI6OUsek3Lcl35de1nCUunxccw/OMyV8xAhkexm7yFndJJwWmbDYeJG5VAreycDhcyikAnG7e0z1nWYEeNJvqpOHTXAZQEqN+hCTDIWy7bWnd6kdpYSo4MohRWd/AazXlnI7feuSDih5qFzVo3gQoLsJ0KdGkNHVZoj0F9EipA6UBw01gT7PwD97Gwjqap38ZGMjaHzk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--HgKF1GOS9//9I841
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 14, 2025 at 11:49:15AM +0100, Lorenzo Stoakes wrote:
> On Thu, Aug 14, 2025 at 11:32:55AM +0200, David Hildenbrand wrote:
> > On 13.08.25 20:52, Lorenzo Stoakes wrote:

> > > I can't see anything in the kernel to #ifdef it out so I suppose you mean
> > > running these tests on an older kernel?

...

> > > But this is an unsupported way of running self-tests, they are tied to the
> > > kernel version in which they reside, and test that specific version.

> > > Unless I'm missing something here?

> > I remember we allow for a bit of flexibility when it is simple to handle.

> > Is that documented somewhere?

> Not sure if it's documented, but it'd make testing extremely egregious if
> you had to consider all of the possible kernels and interactions and etc.

> I think it's 'if it happens to work then fine' but otherwise it is expected
> that the tests match the kernel.

> It's also very neat that with a revision you get a set of (hopefully)
> working tests for that revision :)

Some people do try to run the selftests with older kernels, they're
trying to get better coverage for the stables.  For a lot of areas the
skipping falls out natually since there's some optionality (so even with
the same kernel version you might not have the feature in the running
kernel) or it's a new API which has a discovery mechanism in the ABI
anyway.  OTOH some areas have been actively hostile to the idea of
running on older kernels so there are things that do break when you try.
TBH so long as the tests don't crash the system or something people are
probably just going to ignore any tests that have never passed.

--HgKF1GOS9//9I841
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmidzGUACgkQJNaLcl1U
h9A7uAf/TsWdfXYkIPkM2Rj3C1HzjIuj6j4nnUhMESgtZSbf9Am99POGQmQxnUay
Mz75k34/LOlxbUGyk2oz2tqb4Ad725WPmSqg4IEQXJ3or551O2tAApBrrbwTKfrT
ha9jUqj/hhFasDuM9PZsHTUcEk4DKGYtFHOtrucuQMDOSNH7lsB3BEVyaY4xxHzM
d2dWm3i1c8VlbU8gFIX794INH1sdcja2Syh0d5wraBAZ+NS+uJ5iWyZw43YgTGiX
qQR+HWxD/m3NSNX6L58jpZYJq6Q40xDz8aQQiAd2omnwIYWln4HIitcYTpeNvQNw
Poh6lZXtgIVoXt2Io6PYJpr3LnpP6A==
=Xem/
-----END PGP SIGNATURE-----

--HgKF1GOS9//9I841--

