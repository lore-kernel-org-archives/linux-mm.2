Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33262C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247086B00D2; Mon, 17 Aug 2026 09:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F90E6B00D5; Mon, 17 Aug 2026 09:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D816B00D7; Mon, 17 Aug 2026 09:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E55D66B00D2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:24:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CCCB806BB
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:24:43 +0000 (UTC)
X-FDA: 85110831246.13.D6131FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C860D20008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:24:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NdAQ2Aks;
	spf=pass (imf13.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786973081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9x/I2XWbWYVR3+1LarRSMKDhXqXNMBOiaGB6WU1r3DM=;
	b=dsuDPQTItuG4CcruoBPDtA8q7C5XaI6h0Z4dOb6zi9Qqz5A0k8KznkUjyolgDwe8kjP1bI
	coP+lxUhIqHTfJRGGXJk24eeJKjKoioAtoXE093LMlruAjtIPJCbhG9AHFbXLiOMkyvIy3
	1fWF59a02XbyyIxyqa4OGNDg5Xq3v60=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NdAQ2Aks;
	spf=pass (imf13.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786973081;
	b=hUixxHDLPXKqIvQEw/895MDQZOVNOF6NuN/Iq+bG4KZkr0QoxjcBoD13CqQdtTWbg4EHHh
	4lmrwwfr94tU4McWJTMXAa4NBEouzji0y+ENiy3daKBSbv6zceZESxgPYNh2vqq3hxKf1X
	3sKuxhCoDTiEJUnzREqZ6QE57jkzmBQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA89641814;
	Mon, 17 Aug 2026 13:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D451F000E9;
	Mon, 17 Aug 2026 13:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786973080;
	bh=9x/I2XWbWYVR3+1LarRSMKDhXqXNMBOiaGB6WU1r3DM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NdAQ2Akssez/QFq7vDGuffjMTVgOKwOKMnLnT2VAKtPvmg3Hiota8QE475KcxAlHX
	 oJAB6/x1TZO537U7ykXiuoZRN+MAVmDSKqQ3eJZ/y6RH+PXcIinuRpP/WWJ1aK0fyb
	 whbWwz8rUJaFjsfULlCaP0sKjE/5jeUbtqQ9dkxLuiQdy+dHeE52WJGYvP9OCE8Qm1
	 f2443UmIYIdx+lGMBOV6z5YcBZk2jH8A46neza4dfJcumKHKTEI2MX44NjknJbKhkn
	 tL2Lmn+ZMdyrgtfF6Yog99KREMCa6kml+dIKpCEtlHcsoNonc0gAACc/3bLlIs1LqI
	 Ss6bciTfUOHig==
Date: Mon, 17 Aug 2026 15:24:35 +0200
From: Joel Granados <joel.granados@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Jianlin Shi <shijianlin11@foxmail.com>, vbabka@kernel.org, hannes@cmpxchg.org, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/4] sysctl: Disallow partial updates of
 miss-formatted sysctl vectors
Message-ID: <bhe5eoysjusfrfyv4o43lrac2tvy4bvdfzthxyp63cwg3u37kl@sh6kdfukuheu>
References: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
 <20260814123602.ec6889355580da96958b79d6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6bqohl5pkbxvw5gn"
Content-Disposition: inline
In-Reply-To: <20260814123602.ec6889355580da96958b79d6@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C860D20008
X-Stat-Signature: 46xj874xwedjjhod6jracg1hrzzh66q4
X-Rspam-User: 
X-HE-Tag: 1786973081-704786
X-HE-Meta: U2FsdGVkX193qXY4etRjyDQ1zPM846GGkDl3OR7tG0T8wksXoojK/o9czDcfJlPeFBKMSoyOjn6pGRTYaUlgTzwLXOQg4JM29EvNAUA0MKr9aRz+YxJpTZpPZ2FKjZALS1aqYscYqwmlJDMLqr9A2ajvmO9LEPACOrBXvLtcfWCp8hTBYuDZznkcPFVlmLmG5u2c/k0Hp68rEwra88OLKqxHnNpGbXJJgJg1fGIeOxSAlPN8sAJjK/5G6XG/Y9pZMc6huxcPHACmxQfLboCHv06+yLdzCQorp8R7f68bYabGzha6lbpGI++Nf7rC5+H3U63eh7Ah4s1qft6lWRNnpvBd1THt9V3fW0TsNkwE78oPXJw4qiWLiEWz1ZkSpIGwpbUEYYrpPMvVyBctZH+SchAi/ImlT61WjMJTeqikwxvibrMa86lkUrr+SgnTRpVi/vPBf7EMImlFbPzY/DjqPoZGHENWK6p5wA7+DGHwcG0tdRQfmZwlFc7YBaWT7B+Q0PVmB9aQR8QGE5WQUM6nLX9fawNysbsiYRWUnBxxsakTXZ+BfmShua3NGFvQZI2Te+lZwoTT0S5Gwap8geTEAOKmxnNDTdggWjeAD1wjnGOP53SckLev6dt6BNm8cqJWmxRn3mN+uTYtJrC95QkmncCijf1SWA6KYLsf3p4Y/SnmpwkIkq8trPu1F9xB/2cbpkF54jhc5JeSuKv37SjLDkGrPUSALT6K0lQkgAFdy2bQMaDV5xjepjeWUmmCfQ5UoY1edG7eSVsCohzcpAl0AktimbrD8SENVspgaSHnPvshW4cJTtt74a7iujHkCXRBeiB7HXKtZB37tPQr2TdwrBj7yCf0fs1cGMy/b4vw7S54V3e3PbEtXWy71XdUrzi4VRbMtGpzKU6g2U3JjRGY4Xny6ki1xP+5lD7KeHYrNkf5qbqpH/JT3lzrp2zTVXBWcr4bdthtB11oG1mC/96
 dy9q4DbP
 LkNiqFyzwYIuNBA5U0+D09z+31Fwa8dHHyMXjSqUGrjqe+K4couMKyBGQ68fzWTES+IsqrdZvfX6/Blv81BFP12B3IMBkZ1wXMstefijeUfCMGF8rvh7bQ8bcC3+twzzkhpMJf49gzd+0pNZR21wUoA6eNBmsz6MX+aScQrZvQhBS6GgTZPd/CHQ2RPLLsOd/Qe8AzJIPyworno80TUHpMhQtN8UpHX/aiL0pB3yHHvuxXO+V71bF4sSk3PsZ7nxy3MhoYmknq/JdxSJ1VcZJjq2Ru8eC8IyK++6XeRkcizsy4f1LH6p2TWuLp49g7GkI+4yuVJJ+IKnb1/t008EG/SbUSfSnREStiNkX3TpHa4I0w3DhixaHsfK53nhfSl6Iy/kIxXCjSmpbVvhrhYWLZWEoIbR4alMEIzqRcPzAax+JnSgmWooGuJ/mIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--6bqohl5pkbxvw5gn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 12:36:02PM -0700, Andrew Morton wrote:
> On Fri, 14 Aug 2026 12:41:11 +0200 Joel Granados <joel.granados@kernel.or=
g> wrote:
>=20
> > What?
> > =3D=3D=3D=3D=3D
> >=20
> > Stage table->data when writing INT & ULONG ctl_tables. Commit staged
> > data to kernel variable only when all the conversions have succeeded.
> > This is applicable only to variables that represent a vector; paths
> > pertaining to scalers are left unchanged. Notice that partial updates
>=20
> "scalars"

Will change in the cover letter (If/when I send the next version). It
wont actually show up in upstream as this is just in the cover letter.

>=20
> > can still happen if less than the size of the vector are passed and
> > correctly formatted.
> >=20
> > This is the behavior we are protecting against:
> >=20
> >   # echo "4 4 1 7" > /proc/sys/kernel/printk
> >   # echo "1 x" > /proc/sys/kernel/printk
> >   -bash: echo: write error: Invalid argument
> >   # cat /proc/sys/kernel/printk
> >   1 4 1 7    <- the write failed, the first element changed anyway
>=20
> I like the change.
>=20
> > Why?
> > =3D=3D=3D=3D
> > Allowing a partial change to a vector after returning from an erroneous
> > proc_handler is just plain wrong. This should be handled within sysctl
> > to avoid users having to do it for themselves [1].=20
> >=20
> > Behavioral Changes
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > 1. A failed write will not update the vector
> > 2. Vector writes can now fail with -ENOMEM
>=20
> Yeah, this improves Linux.
>=20
> > Testing
> > =3D=3D=3D=3D=3D=3D=3D
> > This went through regular sysctl kunit and self test. Also is posted to
> > 0-day.
> >=20
> > I always find it difficult to know who wants to receive this. Please let
> > me know if you want to be removed from the Cc/To.
>=20
> Sashiko said one thing:
> 	https://sashiko.dev/#/patchset/20260814-lklm-partial_ctlvec-v2-0-9df50d2=
6e477@kernel.org

The tests that keep on giving :).

I'm already working on a replacement for the sysctl selftests and prefer
to leave these as they are and address them in the new version if they
persist.


Thx for the feedback

Best

Joel

--6bqohl5pkbxvw5gn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmqDC5IACgkQupfNUreW
QU/qfgwAg3uPWRE3j+KU7ZyoYAEq0nH8bVJrKBDHKYp6XnQI2PFycst64AzCaT1X
TDkuM/N0pKX0Ef+SwlzQkNCODa0bxzlj6SrFYNEoF/w1nvHzb9BqN3uN9Aaje9VY
ychArGGWx2OecBzJyuyYpNuxGqiXT7A2uVyDrknaTtFqgEdIRJg+ZmC4Hk/bKQqI
dHovH9ii3yNcnqjZaNQafdYIEIcNibLuBUyPHT3Vhv9J7aG+QaZufFlMhxGKDw4b
wjKaGTxOLwfr9YMB6eM3cYTmxRO6LDEhVWETAAWweL0zwOO+dnSVNFXiByX71VW/
gWY1gZpdm6Xaon5aNr2A1Ju/dAXQ6qjDIHhmuDjYjaH3iWnFmTXfIQHBxYac60m4
JtM/Qo2Ju7Ru/fvMsud+B3myqyXwg6nD32+nViDeUbdvXhtGKv4lr6q6tfCYVR9Y
hhAXg5c6S4HAu9H1GCivwjbd86chaFB8S9/naMKxJj+CIyfUjHSMs3WS5qITMZBj
+C2hpnp4
=zPyj
-----END PGP SIGNATURE-----

--6bqohl5pkbxvw5gn--

