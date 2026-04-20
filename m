Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F1FF5A8A9
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 17:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F016B0088; Mon, 20 Apr 2026 13:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 428AE6B0089; Mon, 20 Apr 2026 13:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0886B008A; Mon, 20 Apr 2026 13:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AB5D6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:54:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2D94140A8B
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 17:54:41 +0000 (UTC)
X-FDA: 84679684362.17.F7A459F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id EBE67140006
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 17:54:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XYyq7Urs;
	spf=pass (imf09.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776707680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMqJbEnvV/lk0AfMiypeRW1wv4gNL3/BhNVudnPVucY=;
	b=azzrWIehoHUBv8i52Gbxj9zrFs8vAUEGkNb2Y5Iyh3cp1QHpQ4Bk0RHKcf6G6OtVKJXpnk
	IH6xd8RbeeuHuWKZd5tGEPGLRFkIy5GD3aScmmbnxX6SRuKHHPMgzqiMp1774rTyZDx+sa
	vvxewcF5ieSagAZMV0e2Ri71DCVtvF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776707680; a=rsa-sha256;
	cv=none;
	b=EieUDZD87irjVnFS+5W6YC/iWorGetE4B3s8FiQwtx62obi34jhEhajG8HDqoXztAc+RM/
	ckIW6+Qvv5I/FvrfxnirIVlOmQyAxZIWaI4+BHrujjXnH1i88FvwYMFCUU6Z8A3YP5pmlZ
	ImgNyk+UxJjQZxRt81p9PVJrmppPQjY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XYyq7Urs;
	spf=pass (imf09.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5245060018;
	Mon, 20 Apr 2026 17:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4DEC19425;
	Mon, 20 Apr 2026 17:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776707679;
	bh=/PTY/lSJ4AnUpE+6mNiwqTVFEKR9IIn3jhHdLt38EGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XYyq7UrsOAk/ikjgVF5gze/LKuQxVSsfzr3Onb2kpZGk6vSZTdgL9MuTOmSR+DlVp
	 VSkH/X0+HFWLlTyuYvGBxSv+/GgPUlHRYOYwEW6NAIfCfP5tFZ8nW1/SsCgyX9cX/S
	 gY5DaP4CKVPpYHkDvnmZ887pvy0KvQQGpF/0RkM+rCoMWl7A84aYwngN94C/U9wS7V
	 Odslmf4asslolVSPISYKbqyjqq3ClHrlyqxsyNuNph9fh86ayAWQVkUfWQpRDRVCFS
	 5EjCliuT7X/qAZKc1+KaqfoCGuKrMOfj6tKGdYm6a/KeNkFKnFpaN0CIF6E16k2zun
	 NqR0dFAu3FNlA==
Date: Mon, 20 Apr 2026 18:54:31 +0100
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
Message-ID: <f8495e44-a34a-4289-90f8-0faa71bf1a71@sirena.org.uk>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-17-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="29heIyJRxGSTWNY2"
Content-Disposition: inline
In-Reply-To: <20260418105539.1261536-17-rppt@kernel.org>
X-Cookie: Sales tax applies.
X-Stat-Signature: npibrtwe7r9cycb7p9cjo1c3719tsrbb
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EBE67140006
X-Rspam-User: 
X-HE-Tag: 1776707679-901168
X-HE-Meta: U2FsdGVkX1/sqROToDJpHZNnStJZDoKEB/er7KRhDKsLyI1PDaWjPjRqhbVoC0Qpt5bVIMSIhtKkKRIBWoXEt9uLanKvRSa7AFtJMFnnSiXYLbFazHdguP/zn+zpdOlqJDHnYDrwPcSnPHm2oWYNVWow7kOJEUF4rlvq9cjRgw/pMSIhwiBfxcz47Gpfdfxs7zdeXi5D6vYAeCeLuXUpPqM+XcZmOS86Rwq+tHV+g9303c5T0dKU7PmiXMUrNR1L5AjEbd2nW+pycbrLgQuJm0eamdc7sov5ht8CwVm4ztMSO1tz5rsscDG4IIW4mkJ5+HLouOrH5e3o5jy2iVSfuN3zx3pJ+62CnG6aA9IQ/DvTaTFbAbgrd7/TgTJx3qnV4VCbcsXp/8NixKKxcwF4FZC1F6hVQOyhaWhXNkImyzWZadfDpOuI+75Say2pd+sqA7m+AEaa0gEjAvhfXIGhcXR7TgRu/JIHVFFgD1WqMl/KAz5p52fgv2C3/n0tr2lq8CiqWaCo6GCNb4C8zA5GW/HBugbt1sofyfn5Bb0ZrSPSU784f1Ri9Tbm2VkjtekMilkhN4LVtrhYe8WgtYE4/i2ysd3gTCbNJTb2W00o8lJDOL+I8gU6Z7XZZpUhr/3nXE3vweqxgleD8S6/cVgWbd/Qi2pTBVPx2xYF98O5Syq7uCFznMXLQg7HtkTr852io+vEDaaKy+KOOyIXPgU0cJFN3psOprxhErHDtBehnu5dZb9GU8eN3lq50/GyZHw541oTz4ebk46UMNs4Pgc+3hKqQIV1jxPXCaOaGYhmrluKe71JMUGyFZ/3nP+gASp8gchEayaQ11j9//qqw4x/9iYnW3G+wzTtnRA2PUil2jthSZQqF0+D9jtvMUZ1a/sc9pkK7CZhft7PUP1wguT/cEH+2zyC4un5M0LLhb/4rhZVgu3pM4lDBi/kYZEzOXaZH/ZW2A8Rs20WX4fmnf9
 DGMRCxZ+
 TqZkpoNOG7bUMV0BWmU/GRjtkXRp5oMR/z7UpR8x+zWL8sehYA2xFrdEuofvTiFF0PVjgtaumsd5qpMLerceCHX2tF8MZzsIj49f9stkOX2Tno39X1rpOjT8HOzOJDp2N9ouskxE2+lDw9hlzxQ+rhSQ0KA+1l9/neoCWAKOYDEckU091lAnrzjwUJt/PFi/CNE/e81jasDRKYml2K4ict6SbC2J3noio+wS7Sege3nkZB+7d6heRYhtq6jdeF2Xm+kJKL2/zLOv1PBmtS5NJwqdqrmM4kk7UYg13DBWKNWt+JNQkC19t2WMRMFUr0vRVdcwHxb5ZM21oS4PeURh7UEn6Ep0M54jfR2ZFxS7TIYCfShQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--29heIyJRxGSTWNY2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 18, 2026 at 01:55:01PM +0300, Mike Rapoport wrote:

> Adjust dprintf0() printouts to use "#" in the beginning of the line for
> TAP compatibility and add fflush(stdout) in the end of the test to
> ensure all the ksft_print_*() messages are really output.

> +	ksft_finished();
> +	fflush(stdout);

If that fflush() is needed it should go into the helper, particularly
since ksft_finshed() calls exit() so the fflush() will never be reachd.

--29heIyJRxGSTWNY2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnmaFcACgkQJNaLcl1U
h9D1+gf/T1VhynP67CeAWJAgnjzi0T3T5BQSGX89RfuIHrIdW1Lna3akEq4kWhjv
V65lhtVN3EPwrGvnjgCpSjIllnnC7+Pusbasj47MV0NUHrPRbmkmn3nV2OMUrZ0G
/1OXsr4xIDQtIBt+vfqMqfsKeIWaxzNJ31AS8Yl5bX2rdqTlH8VwrCkVnUEL4Fsb
CC/ynssUdslOo1AM/t+N5x/d3ee7cNY1M8jHlywz/j/BPNbzChVFZbaEkAhGnyIT
A+aeDd+a9JfNN6MhX5F0Pp8xV++jbl4ufOWQUcn+zh9e/DX3BF49SxqVDRRYj27J
WEw6gPPxWN1ChiiWh7/3nLVKbYBsOQ==
=I9o2
-----END PGP SIGNATURE-----

--29heIyJRxGSTWNY2--

