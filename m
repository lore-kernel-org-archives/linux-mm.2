Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6935FF8FA71
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 12:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9076B0098; Tue, 21 Apr 2026 08:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8ADD6B0099; Tue, 21 Apr 2026 08:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78466B009B; Tue, 21 Apr 2026 08:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A638B6B0098
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:59:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 714491A0D68
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:59:32 +0000 (UTC)
X-FDA: 84682569384.09.DD0E1F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id AB972C0013
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:59:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f0SW469D;
	spf=pass (imf10.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776776370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+3jLRQbxNUK13u6mZzAn1fd/vLLo12UNkdmccaL7iY=;
	b=1dJt4U7iyyOFrrU21+eui91yS4kBUm3gCSoLQohVdZuzKxXI7LXBs3kTcqQMBHGAFPu1Ky
	aLCeozCrdZrrncMBTvfyKHnLdE27Sax/SoU+8Re4gInqkfNUFyci54E17r17fpnydDQsaL
	C49sWOzT+bJc0mOxDWFdo2IA7bzbN08=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776776370; a=rsa-sha256;
	cv=none;
	b=dtgX428Aeo5bepVf6KUf0Emt0s79h2iUbSvsHs7MsXCflwEsk9Pmxq+fG+0CgA4XSS+wDy
	/4eqOK9k/SdVTPLkeaOgC32jH9fXb5cljV/pnjxyjSMHzsEMGboPIT8Lh8zFAXYUWZOjWH
	WgiYYCWP9atedkFzUNfWFRvZW7QISuo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f0SW469D;
	spf=pass (imf10.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D265443A1;
	Tue, 21 Apr 2026 12:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5E3C2BCB0;
	Tue, 21 Apr 2026 12:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776776369;
	bh=7BJvWRZ1a6ku7d9qmmaiiEL9TjM2jB3XUn/ujPzf5jc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f0SW469DCDLkyphmfplgZwLygarAdDL70IMLy/iHzp+Ucm5InCXYnYWSISkfC08mX
	 eoChHoUD21umvMkaem4XTnWXTcyO91YzjE4hLs04aZbdG8hOKnfvmPHKA2TUqOjm+c
	 5ovC8qJHgbL0miLTKT35kGEcdSO9OJowwaaZiWBXGSz6Eta956Il92a+y019HcRg+v
	 SHSIuM5QVAFCc07D6+xVUJLZcJUGvzmUNCe4EI7vyju2cDRxshrMyQ18aul3giEgvJ
	 I8vRKh0YE52tUBjwtZ75T+lYaxSE2N+7ZzUe3rypZcnR4s4x8ntAC+WNS1PMi9p4uf
	 k75/l5PD0EUTQ==
Date: Tue, 21 Apr 2026 13:59:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 16/53] selftests/mm: protection_keys: use kselftest
 framework
Message-ID: <bf3133c3-ae12-45ac-a3d1-5e58b849f817@sirena.org.uk>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-17-rppt@kernel.org>
 <f8495e44-a34a-4289-90f8-0faa71bf1a71@sirena.org.uk>
 <aeczFjEs6sqRPy0w@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cpR1GJECWcVTjcOC"
Content-Disposition: inline
In-Reply-To: <aeczFjEs6sqRPy0w@kernel.org>
X-Cookie: Jenkinson's Law:
X-Stat-Signature: 4593is4iwuf1czaoass95bnrm9ghj3bw
X-Rspam-User: 
X-Rspamd-Queue-Id: AB972C0013
X-Rspamd-Server: rspam05
X-HE-Tag: 1776776370-322855
X-HE-Meta: U2FsdGVkX1/nFb6Ob7Il9e9r5KDBt2Ol2Lcapv1PElfHxrRr/fdL9cLgs+0oCcRk0fOwj/XqL9dZVf4V+OVvqlWrJNO3C94MHdwvL1qUHHU2c1z1qf8kZPsBXRwaLuuhT2zArM0JyIeQ5xVH+Z8HwqOYQOUc9SFW+rKMEtygkLpNrszdWypiTBA1hxYnVJDnaank3mzG54DN6ufqJSSvYMHvKhkKz+HIu8rIazG5FLw1yASpqsjq293WfyMiJ/5+kyyXxyvINEyyszURyklkghBAk838H9baf7ruOp+1VyI6tjD77kOKEhn64ABuw7BnYIRXq7o7UBF7w4z8ZfphFeXwKjJpSTOeHFW5YLrCzWBln/5cJLjWbBjo4dSVPMg7J31yIqTN6wd4nrE5tm6GlMP9vrbYXFYBCKKJwvS3uzZunBVw4fmCKSDbZQ25nOOrh2qFQCwt5h7vygMSi+7O7p5HyUpc20sTGDHFgCvxNoPzhRuBwbi9G1H/PbRAj5T/q3Hu128qn8f6xaaOG4zq9zHJVEKCxCdFMXROUXvOoWBhF4ruuxUNn2k8Q3nDTO+F3enRBmG+fshn9CihbARvNXcfsv2xXdAKqGICd0Gyx8M27RHbq4dctCkoj1YNSY7OsO4i+Fbpz6V8w9lbZMvlUHJU2mJwjDA3aB6WyZxuN7eC0rLlwQIragUIOghnmm9MojbIN+e58H4PSGVlxsFOVeOJ8pKvLsLyNqNoY5kj0dfPmXL5BzlfgE/mUNw1B5bFyP14JXYKB6/NC5PKIhKYuwcJWqVEDtPftY4WNzidQWC6xFaihZlyd9UYT7oK1CFRm+aN4c2wcg1RcfqxttJGoCTdqU3IaeD+aZlIA013d9NmtVwsiUjYBSzj1xlTyPuNRf0l8EwerfljH4wx6Bys4lHE6qAvSrlaFc8Co04mmgkWlDuzt1FRhthfX5Oh6/oNFz2Pea+505d4olRyuQL
 jnZD0x++
 JVasuZ6VP+cY5s+XYFnvGFGtwCnPqulEGv/xBCUC0JiuqxaHgU5JloWgsZ9v39I05bFRKoHI2l12vqMOIJol4pKMH6jSwiqunKFjom91620h3m7ubMZNAKZU8C/7SY7itpheQNpvedKe05ZLnoUFsHA8fJQvX74nG/voqDmLrZa71t7P6AyflS6ydHnBqheVvdYSBoMiDN4DMRpeuukPaNEKOfjoc7hysurw59vjMvLTuulqmLeKS8HrgBwXaSuRqj4sz5bsy1BIpGe43/8OgMy/s2Vj6fKy9p7QSG2Xouu2S8JMn70gfTxA3UxO2ZmZsac2HUy7B4TQTO54Bu4SyZiOlJ+vQfoKIUbHk9f/thBYQUqU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--cpR1GJECWcVTjcOC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 21, 2026 at 11:19:34AM +0300, Mike Rapoport wrote:
> On Mon, Apr 20, 2026 at 06:54:31PM +0100, Mark Brown wrote:

> > If that fflush() is needed it should go into the helper, particularly
> > since ksft_finshed() calls exit() so the fflush() will never be reachd.

> Looks like I'm missing prints because of something in my environment, I'll
> just drop the fflush().

Interesting.  Usually the culprit would be calls to _exit() that bypass
the libc cleanup but I'm not seeing any right now...

--cpR1GJECWcVTjcOC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnndKkACgkQJNaLcl1U
h9BbfQf/QK2ulYd+OvM6NWN36YQJmk1WXro4Gz6hEP9gvf5xt6mL0NdbQbBqOZEg
oq3OyXoq/n0k8B62IJqY0tkwuePlB/aDO6JrFB/QghSSZGffzDBcNv9PvMAWkyNl
CrDyRF/fWX/NDTWK1gPpdatn0Fs9A0rQdgsccm+7TskXbecDtsqTlhvEKJSrqC5p
IdvfMi2Ju33HFrP4t0crED2TZEyU2UTgSc7VZPXUhnXxWZiQTIZ+pBaQ3yqMgI6Y
8hQSS4I5ZjOdnAcPsoBK4PU+TzrXaxg/L3XUOcfVy+5tGBK64+8ZU76P9TO9gYVK
hgSe9jFdX+jwfS2eo0wmKPgDve4xWw==
=Wid2
-----END PGP SIGNATURE-----

--cpR1GJECWcVTjcOC--

