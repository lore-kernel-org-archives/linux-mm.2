Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF4A0108E1FE
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 12:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A366B049D; Thu, 19 Mar 2026 08:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A016B049E; Thu, 19 Mar 2026 08:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F306B049F; Thu, 19 Mar 2026 08:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E52B46B049D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:17:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C371C1EDD
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:17:14 +0000 (UTC)
X-FDA: 84562712388.02.00D1B4B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 04DE210000B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:17:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=keYiv5Gg;
	spf=pass (imf05.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773922633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emBGB9p5VsV2bWJ2GlBh0Rm15v/DEORykhqYZtuDxHE=;
	b=a1tUxQyyU7CRSkuZd2GkbAIkgiyTbTSMRNSEbHbk35TdTAvppAcWcJ475gS+8a0Kv570SU
	BlKnEJXzWeYtqSXKlfsewBkJroxWi72sg4TchnIF6yiQ7d43OjE/k/BFF2LhFUxzxEbxPc
	ZdxTAuxwyBH7xH4ThUqBWlopoCYroPo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=keYiv5Gg;
	spf=pass (imf05.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773922633; a=rsa-sha256;
	cv=none;
	b=psDZoYiXjz8PreY1E9ZQ0ig19T1tihEAWEnei08MgATmZtpgGB56DH2k7l+YRhvY3R+4Er
	ulKwNP7eKazilSkgIAtfXdY0Oy3/XtVI5eJun9rdx2+/cLLmt38moiKXRg4z2RO7Yc6XaI
	fq1Pp4p+i8nOuKAKe9I4BwMw/CL34EM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E136600AD;
	Thu, 19 Mar 2026 12:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37652C19424;
	Thu, 19 Mar 2026 12:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773922632;
	bh=yDuN8W2IxSeMcfgbtfBkaW+G8+mALZNQqoWRx/nA/PQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=keYiv5GglJEbfYr2eGpLbX9Y+aslCrMg/8n0qHaCHjWPFAdCcdAsOygNGi7xbcQvi
	 qRHBYLx6fohQd+zElGqnRy30rtvOIE3VOEUBHXVqi1cRoYZBg+QG9a0LaEAhNSCcEh
	 SlD9vLOp7lUKpTQD7S3Ln1sHll1erEYwcnWbADzKVgk7ls0nxQqrbLm3TWypfsIvHs
	 KneKsY2xR7Nk1B8VWsfgtzMgmRVwiqtAJavcNzZymrEF58e89/zp3uQpSGa8g+DZKl
	 cjgRkl1z7leAPOiF9hq8BlaHNpjzLsSnp50tqp6qEcrrpvzHWzCl4ePMmwYS8mNYG1
	 cBebCs09pEShQ==
Date: Thu, 19 Mar 2026 12:17:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Vlastimil Babka <vbabka@suse.com>
Cc: Lance Yang <lance.yang@linux.dev>,
	syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>,
	david@kernel.org, ljs@kernel.org, willy@infradead.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	linux-mm@kvack.org, baohua@kernel.org, ryan.roberts@arm.com,
	syzkaller-bugs@googlegroups.com, dev.jain@arm.com, ziy@nvidia.com,
	linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
Message-ID: <44cb1295-c2d4-4b94-a9d7-9ad369d0f2f2@sirena.org.uk>
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
 <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
 <5eaa234e-76e5-45ec-833d-64d76903d1bf@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mR/c5f4Ns8MnS+yp"
Content-Disposition: inline
In-Reply-To: <5eaa234e-76e5-45ec-833d-64d76903d1bf@suse.com>
X-Cookie: Given my druthers, I'd druther not.
X-Stat-Signature: 7o6t56thk7js7wusnaahuz9yxqqfkgdf
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 04DE210000B
X-HE-Tag: 1773922632-235960
X-HE-Meta: U2FsdGVkX1/K+WpHSnH32mYfVZmQminmOMJeo0ALF0bJtkX9Ts+US6JCYXYv6AJ5JEOEVRi8rajErc/dkFquuTkGUx/DsNqwNQuBFg/PhyaQLSMbnjq9Hgo1QhPQ6/2gqwRwzp4kBbgFvPQvXPSAhyJxPuJND+9cmsD95Dc0axUxtWZ5XMSG6ccCWNdPNr0wH+5GzexeArGYlUVafdE1XD+7RJaBYaKiBs9AB71ETfrikfYU1U4LXvP4/u5M+F97i3vWk/yPuHXKuFxiOyuOk6EiGh+8F0I+qR9vQa7/LAGxAq7fz39Jpx5w9t3WUphXsOD465Oyqq1lxD8uVIMAeQKbcl09HTzj12wCdViOtFhX1x9qdshXCNZ7+1JZHmycla3FyROqhPu/xgJ3n22JDJ1x5s4jtcdPJy5cREaItkQclPxT+o79ObX2aHdRe27tIE+M05FFGPhK4u6N9VBrWZO3hwqrHbSNcPEo+tFFBEW8EpCfa+/SHX7xdYqJXja7dm1MC0L+8rhd2Xws91pPLpbXR0Ajf/ZggQ5kwntTatJ+PtdIBzlKBoj5HlahIW9u212rpztxgIZIxe/PQqAfTECRu8Enu3Ez/jjrsxt+Lmv0YO5gYnmhj07VNwx7rq40mXm+4/1idFBUbqO9fON2VCH65BQJ0e3kM9s9uo2q+qZoqNfEviwwBDg6MOWiKdtRTiwqjrfj0MAg1sTxydhY0E9QEe8JOVgsfMFQJqKu8xftcSCU5r1XBz3XknGBLG4Ln4+Hyhem0I1orsKGx7wVsb5/Z1bdvF8MjVEwCa7THfFtSgcg0nkM5EVqxmmuWuvawVqtSj4VLNW5HaTQaKbPVgsYe4ehSyzyi0uGNTgo1YzsckFtmmlEhxo0Y4+IO80wOhRpyNvU1PQBOEb/pTUelDBv1skKlhMQrju0LjXvz+q6/Pz6utBjnt5Xs1+RyH4ifnL3GyxHzQFYSYVqG8V
 Krp5h0Zr
 XSkYJsCQl+fXgAzf1XCjvAEyEfJ1HkSgD4LcVX3WIPpiuNe3PPawE3EuVCb0zvstp1g0sh0YeMtE0JA6aMkzIFp1z+/4aokfL38itKh989M1Cs+1igX8UrD4OWvOnHM71TYI02tOPqJ8eVkCHPf5QhM5ahrVmZRD0EIvd45DsCcw2/4GSAEYKKwmc3GK1WXSYA0b7PblRNDT7SAMnDezQfT/nE9OiSDew4/xIE4SQtXT0kKBPLNcOicIrgpdgZunPNAezQBI7Kc4emD6ORxKlSyEg2Y9YFECo0x8PXizvOmXcWMYzyw5YkKPcXao3kocWcgoAp6VW0eaFbxwuLc7NNMVI5CdFu6W/64IVh5hjI4G73ED9hbsxAUxrR0La+XZkja2Gs1o3P3Gv/g+Bv0XaRiU530nwoI5ers8uIg4hwdPSKM4JUfBIqqnT3UGNi0yR+Bjad0/LZILls5SSj6gJPray4hSeqgsQxamSAnCOBH00oySwEAxGlUcGak0WTHL2J9XQ8YCyPjPBaNZY64/+oOBM29+ZU1wKABrObZTus8EtGdiHpDJ+g+Ne5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--mR/c5f4Ns8MnS+yp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2026 at 11:56:21AM +0100, Vlastimil Babka wrote:
> On 3/19/26 09:05, Lance Yang wrote:

> > IIUC, this is a dup of the earlier report[1], which I looked into back
> > in January. The root cause is the same: collapse_file() calls
> > xas_lock_irq() without resetting the xas state first, tripping the
> > XAS_INVALID() assertion:
> >=20
> > #define xas_lock_irq(xas)	xa_lock_irq(XAS_INVALID(xas)->xa)
> >=20
> > static inline struct xa_state *XAS_INVALID(struct xa_state *xas)
> > {
> > 	XA_NODE_BUG_ON(xas->xa_node, xas_valid(xas));
> > 	return xas;
> > }

=2E..

> > I posted a HACK fix at the time[2], but David pointed out that Willy
> > had mentioned it likely needs more thought[3].

=2E..

> That "needs more thought" was Jan 5. After 2.5 months later this is still
> messing up linux-next testing due to a known unfixed problem. Completely
> unnaceptable. Willy, you need to drop the new bug check until the known
> problem is fixed.

> Mark, please drop https://git.infradead.org/users/willy/xarray.git from
> linux-next until it stops breaking linux-next. Thanks.

I just saw this mail, I already started running the merge beforehand and
don't 100% trust the scripts not to fall over if I make a change at this
point - I can drop from tomorrow if things aren't sorted by then.  I see
the xarray tree hasn't been updated since before Christmas.

--mR/c5f4Ns8MnS+yp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmm76UAACgkQJNaLcl1U
h9DvVQf/SfEDJuXK9yMz0xZ0P3v+CGLRi08+h9qxzkKqDofhZdRQufFv7rUa/W8r
+Hc0bgaTeASHWTvmxKSRH00dial53xs6LcjKX+bsmv7wNasirCtm2sakhudTEgdy
THmJprH5rISrlaP+msx1Az0qcQ6dsAUWrZyEMCeWZLG2ZmAcL2h0Ut/ILB8QLlYk
ZYARhZSH5snLc16f44eJQ4nxXPteO2XoDnFg/SNRws+PPBT+iro2cBvuVP6QdW0Y
fTJJY+a2eSKt6jXLKetpREEOCPOlJlJmGChJ7tvjzpBqmejS+PGuKVnk0BIfdFt0
Prs8DEO+uAdpY/akG6GZBz/5fi/GdA==
=xXhS
-----END PGP SIGNATURE-----

--mR/c5f4Ns8MnS+yp--

