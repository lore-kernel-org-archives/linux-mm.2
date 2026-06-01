Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D8DCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 23:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C5926B04D2; Mon,  1 Jun 2026 19:41:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7760C6B04D3; Mon,  1 Jun 2026 19:41:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664D46B04D4; Mon,  1 Jun 2026 19:41:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 523FA6B04D2
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:41:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2A5616203B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:41:56 +0000 (UTC)
X-FDA: 84832969032.04.D131848
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 446B4C000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:41:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QhdoyoH3;
	spf=pass (imf10.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780357315;
	b=vzbCcEiEDjZHbZgSObfNXaDc7wxf9NogkGEYE6k8OllGRLRHwg06w6JY08twJ/61kYU+O4
	H7R2fkj98HkskRh5Zn7u3pGxvUxUKLyordbBZ9httRc/098N3CYE416tRI4ShnC24JaK+I
	CI4J6nQIaKMmt5d7IqcOJrrnHcjeLJk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QhdoyoH3;
	spf=pass (imf10.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780357315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYaho2fb17roRNJm7Je2htGhE4T/MRbsXbRiy/FR468=;
	b=4qx+nSf+4yaZq7Peax15AiI5KQqX2pm3ZANSItb2tAsKK7nI/HcPFBISAHGCZ+Ae56DLUe
	UoA+LBnI9ry94AgyDsTdbUzvuGItmYdnh/FWO7GGqMEENEW+waFBQfWBvGopDRsVXAwgJ8
	eZaEwy3pNh/l0/guHuK20KGCcieEgtM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C778F6001A;
	Mon,  1 Jun 2026 23:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78FC1F00893;
	Mon,  1 Jun 2026 23:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780357314;
	bh=yYaho2fb17roRNJm7Je2htGhE4T/MRbsXbRiy/FR468=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QhdoyoH3RRdxvXvdMwJXNfBwch/1VO+tU3436/qxDSZeS3qlbqgqt3U8HRJynY7wY
	 Fm5JBzwClUSZ6fS8GUFi03hMPXxocHIX+H7aBdSKYi67KiSV0nc9X4VWV0Uevo7ty7
	 gi2VIrKYsl55P3Q6tF1ZbZmT62axIMYI+v/M8NsofBiMoQj/4lfP//SwyVNy8yyTjt
	 +fSuALHTMAfwROn3wsWl6O2J8CHrgZwxEIzEmfAJHUc7bzGgMbgLc29Dd1HDW93pDh
	 1FjP/Vaw/A95b0WeKx2G+O/Z66EE9WnqUhmLFFnFL00620S6jQI95ufOQrPMHJpGQ5
	 XhEGPdsq6N7tw==
Date: Tue, 2 Jun 2026 01:41:48 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Hugh Dickins <hughd@google.com>, linux-man@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] man/man2const/F_{ADD,GET}_SEALS.2const: document
 F_SEAL_EXEC
Message-ID: <ah4YmXpL6rxHlo4r@devuan>
References: <20260529140557.1624507-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bj4mrrqlkuc6upa5"
Content-Disposition: inline
In-Reply-To: <20260529140557.1624507-1-pratyush@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 446B4C000A
X-Rspam-User: 
X-Stat-Signature: m7mh85k9euprj4nro8imex4qogdrauzs
X-HE-Tag: 1780357315-642483
X-HE-Meta: U2FsdGVkX1+t4cZa9k3I7/pBs7CcIKfPKAc/ItM35St3aZ5omJyjDAo5Y6DH0nzBGUafqkfpj7foSqomHlvXj4mPdf2AQFAKEU68LfuzSqoTzKk0R3CWWipuzrt4nePWwmFJZxQDyiA/ljgebAAqvPw8v5URm3a7RXPRzgPNwmASFtqPyhM0T4MK8CmCQ57zd2Cp9MXn/hDBz/LE4iN8HzcZye5RwRLdJeLOS9FynCbjsEy5aIkEZ8Op8BidRZTFUVYNP2z/jZzmaurNkCn/Hr7oOUMOVuDB/nkNMG9DPMYm03DsWZAKRoJc5IvWT+xuSp8uAhn4H29bb+1swmK5OzoDMiK+yNIM1r0uq6Id3dMJQoRY8a43RLWqQxDD+WeycFL7heIPbNhjAju2SIRnxEdJycXnJmED4BujBZJ1x+ZsZAa/rWaggNCn1d51JQWXVUDu0oBsdkVv4xe0oXNMNrvTDpthA0YWO+W0AW9IL6NI5n2qba7S+RETrGmmrnAnNfFTj50zFAp7Ktrt2mNK4DyKNPDWZe0dWXqVpbUOFmyrBL3p10G8MRouGQTEVaZ474IXMoPzCSa5k/tSEg3qbV2vIQQx/jfoZsf/+bfqv7H2DMZNOfdYNi5O/c3V3RwoKAxICLWxgLcY+IjqiaCnlBP+cj5Sf3ct0byJrlUs1uprvQl+E8p/kkYo3mPSZFrtkA+wzcx7iqGGUV10Fg2IhfHB+hwf1Cp715dCPzPK7KL/SeacY8a32Yattu+coUZugsq7ndhD9Xtze0r4RQ/vK/RjSawR1GPXiiMQGTYSKFx1O2ZK7HbemRXtYrkPi1ctbZN4doK2OCdZyDIEs2w++iCMkUYaX+LHeKCOI1JiAGzRaUCjYsulNXgE1rCYkgTk0zjSvOVkBUy5yDkr+EeKaTfIPgu95IbREjaMQMYt9xaiSXqBPB9r1esblaLfQ5qUVuFSabW2xZZ2e9CLdkI
 d0kS78vP
 LQW3RbpdzHbfw7uwGe4tt8in4fd5lnqcx2oUwi9s+V9GRAL5L/aaXlJ2czGbsFpJVZduu97+MEu8gDbh8McoQs6MYKY1W84ROuV2X6HEOUvPh49v76imQ61bWWV03QsN4k+32jM3y4H9VqqXd9PyNj3e6Lane2jhvPxSmx2K1wXsqAd/DT1Aji23sstdd59RCcun1X0yJrzKjjdawfcnaZktMDCBsLCQev1b/3vzQSozUkt4otCaC1M1gPIgN7wB22LYMUt/6iSygQiLclUYQub0T3NTR2iLa4A6alLr+dhrXcuoEYNw0NrtF6uaZva6uYmwZ5fomOwpOcYcHiwaX8W0F31QjwhL59VVxY+5UlaPTDhALvahe5121hQBGTg8iE4HOqOCwNC66tItbGX4D8iebxybdbJ8k4eRL5CN1YUJNHSm2oitcIucKAO6sryYDLFdBXMKBlh8DBLP7WcBJ3/9ZDQZd8MV0AbuH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--bj4mrrqlkuc6upa5
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Hugh Dickins <hughd@google.com>, linux-man@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] man/man2const/F_{ADD,GET}_SEALS.2const: document
 F_SEAL_EXEC
Message-ID: <ah4YmXpL6rxHlo4r@devuan>
References: <20260529140557.1624507-1-pratyush@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260529140557.1624507-1-pratyush@kernel.org>

Hi Pratyush,

On 2026-05-29T16:05:55+0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>=20
> F_SEAL_EXEC was added in Linux v6.3. It blocks changing of the exec bits
> once added. Document it.
>=20
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>=20
> Notes:
>     I discovered this was missing when working on [0]. I had to look at t=
he
>     code to figure out how it was supposed to behave.
>    =20
>     Changes in v2:
>     - Re-write the documentation by hand.
>    =20
>     [0] https://lore.kernel.org/linux-mm/20260505133922.797635-1-pratyush=
@kernel.org/

Thanks!  I've applied the patch, with a few minor tweaks:

	diff --git i/man/man2const/F_GET_SEALS.2const w/man/man2const/F_GET_SEALS.=
2const
	index f41e1748acd0..686a92fddefe 100644
	--- i/man/man2const/F_GET_SEALS.2const
	+++ w/man/man2const/F_GET_SEALS.2const
	@@ -178,13 +178,15 @@ .SH DESCRIPTION
	 while sharing that buffer on a "read-only" basis with other processes.
	 .TP
	 .BR F_SEAL_EXEC " (since Linux 6.3)"
	-If this seal is set, the execute mode bits of the file cannot be modified.
	+If this seal is set,
	+the execute mode bits of the file cannot be modified.
	 Attempting to change the execute mode bits via
	 .BR fchmod (2)
	 or similar will fail with
	 .BR EPERM .
	-This results in a memfd that is either permanently executable or
	-permanently un-executable.
	+This results in a memfd that is
	+either permanently executable
	+or permanently not executable.
	 .IP
	 Adding this seal implicitly adds
	 .BR F_SEAL_GROW ,
	@@ -193,7 +195,8 @@ .SH DESCRIPTION
	 and
	 .BR F_SEAL_FUTURE_WRITE .
	 This ensures that the executable code is not writeable.
	-All the pre-requisites to add the implied seals must be met to successful=
ly add
	+All the pre-requisites to add the implied seals must be met
	+to successfully add
	 .BR F_SEAL_EXEC .
	 .SH RETURN VALUE
	 .TP


Have a lovely night!
Alex

>=20
>  man/man2const/F_GET_SEALS.2const | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>=20
> diff --git a/man/man2const/F_GET_SEALS.2const b/man/man2const/F_GET_SEALS=
=2E2const
> index 175025c10..f41e1748a 100644
> --- a/man/man2const/F_GET_SEALS.2const
> +++ b/man/man2const/F_GET_SEALS.2const
> @@ -176,6 +176,25 @@ will fail with
>  Using this seal,
>  one process can create a memory buffer that it can continue to modify
>  while sharing that buffer on a "read-only" basis with other processes.
> +.TP
> +.BR F_SEAL_EXEC " (since Linux 6.3)"
> +If this seal is set, the execute mode bits of the file cannot be modifie=
d.
> +Attempting to change the execute mode bits via
> +.BR fchmod (2)
> +or similar will fail with
> +.BR EPERM .
> +This results in a memfd that is either permanently executable or
> +permanently un-executable.
> +.IP
> +Adding this seal implicitly adds
> +.BR F_SEAL_GROW ,
> +.BR F_SEAL_SHRINK ,
> +.BR F_SEAL_WRITE ,
> +and
> +.BR F_SEAL_FUTURE_WRITE .
> +This ensures that the executable code is not writeable.
> +All the pre-requisites to add the implied seals must be met to successfu=
lly add
> +.BR F_SEAL_EXEC .
>  .SH RETURN VALUE
>  .TP
>  .B F_GET_SEALS
>=20
> base-commit: 9db8ca91f920b9aba40ed68de6b8da0ca9dbefaa
> --=20
> 2.54.0.1013.g208068f2d8-goog
>=20
>=20

--=20
<https://www.alejandro-colomar.es>

--bj4mrrqlkuc6upa5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmoeGLwACgkQ64mZXMKQ
wqlumw//R7PxIUzCmHCHyJWiab8qt4v7Y9PBVejZoH7w7WSFvfQ4jOBXwNgQ6/4l
mY4p04QrV07jGNbiEENcyOIpjVPCp/ziub5Wg8IK86jmhq+P1KGpTIEtJTNa83oO
zegeo0R469vpW2ABOOZX0L0z+NnPmQD9TwIqTNEs9QV5V0BaJY/vwFpLm1bw3hRW
Hm1QTUUk0WCP0gZQ7oHvK4U3gTff2pEfxpTPGhxQ0vSBs+c1xx0C4GE+DWb2MD2E
G5fkdVfV1ggx6xZ1z0mRBQKN0u8d745nXIOwCoA3bMBx1BL4vpxnm0610tslc0jB
6MYRIw5U6UnzqLVCBa+I3v2gCFVFj7yO6HJWZ8n0aEMJq1E0WK2nOmFNedWqi7wS
EUo0F29Eg4Gl3TVAFt8P5WdMh/czz3D1vG32B6kClEQLQ8fFyzeYd3jZZ0v7eJz5
MR0nSjaDOflJme8cLe2GEr1D0SwROc95bVv5ezUqzFhTIdyeCfzR4BsPJNQXm7Zb
WLQoy4b8IsqAU+VP486ZyLDv8/vjcGDWi/anW3ZawIPZvLopKVVmVXSNwe6heMAI
CKuQVgxq06Gfy8qJhBIISqjYZwISPJaGD3+nxx1VQbOVUzSicK7hSSZkmAOwfH77
y7ZFpXGudIHOPWjvh09z5/y7JBCo1k+9h/3f/CngXuweHounNHk=
=7Zav
-----END PGP SIGNATURE-----

--bj4mrrqlkuc6upa5--

