Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C9F1C5DF74
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3929C6B0827; Mon, 17 Aug 2026 09:34:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342DB6B0829; Mon, 17 Aug 2026 09:34:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 280526B082A; Mon, 17 Aug 2026 09:34:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 051F06B0827
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:34:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D14EC075A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:34:27 +0000 (UTC)
X-FDA: 85110855774.26.A44EB8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id F07B020003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:34:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ms6QQQSo;
	spf=pass (imf03.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786973666;
	b=2CiayG5npUCaAjwJQyHs8Oex+YmZZ9Ki+vYH2L8Po1nw2cRvmDWI3RDHu8WMebdIpAXKfF
	FI42G4BkqEM4a8phSdWIKG5EdzRO/7n76jGTqVB8LPsmImzsGPuNypbM/zIwmNK84Sz0g5
	ayqVv21FO621z6Oil1iFr7idQjvrA7U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ms6QQQSo;
	spf=pass (imf03.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786973666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DE35HLqrw5s+Pl32CN1y+ua/nFvB3tTtjnBp0nLCQVg=;
	b=qX/CiZTISqK7M1l1NrlRRNTYCpTx7FVQEVEbUsxlNxz4j9h1IBm+rz80EWI9CJS4xHG1eH
	cJuEovH/Ikq7WJ00al4VJup8/NVAPCvr+gcyzu1RN5E70A57Rvofnz15M02RuD6s/VS/hU
	9PKc3SyaGuBKq810vDfrRDHQuAeXjq4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CFF760A58;
	Mon, 17 Aug 2026 13:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E15F1F000E9;
	Mon, 17 Aug 2026 13:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786973665;
	bh=DE35HLqrw5s+Pl32CN1y+ua/nFvB3tTtjnBp0nLCQVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ms6QQQSoAYyFPE3lw6LWam82FOjo0LPAYlpaec+fO7bEgTQATQOom5O+c/5yb1gVH
	 rSmnTvoS56YF4WWy9rcxi7tuZ7UAFYK/P6Kp+ktbOqFtG9x3QJoyvkNNtJguLajzIE
	 XoSj0B22hOJwphJawL1XFF5OFatscng57XByMfnYHrUlaYOexvh1AhkIpiYSUUgcEu
	 htRH4Jj64nNLOMuZ7tAbHDspuYP0Q9yGeJUXo2Ia0jssiPOjCKn81BMi+ckukT2gMp
	 A3uf88fgSdZ7OqDncIlHD1i82mll1jyT7fNzxQamSDTLigk8S67dmvclcph7XSPqGq
	 OqwX0l+azdOWA==
Date: Mon, 17 Aug 2026 15:34:19 +0200
From: Joel Granados <joel.granados@kernel.org>
To: Bradley Morgan <include@grrlz.net>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com, 
	kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, shijianlin11@foxmail.com, 
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org, ziy@nvidia.com
Subject: Re: [PATCH v2 1/4] sysctl: Split data conversion and file position
 handling
Message-ID: <7xr5rzlyafbbqrenxoijnuux4mt4unu3vkffcvyjaufm64bfgm@itqpdduljg56>
References: <20260814-lklm-partial_ctlvec-v2-1-9df50d26e477@kernel.org>
 <D5FE866D-5393-4E51-8302-E6236B0D059A@grrlz.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xhbipm257r2x7xs7"
Content-Disposition: inline
In-Reply-To: <D5FE866D-5393-4E51-8302-E6236B0D059A@grrlz.net>
X-Rspamd-Queue-Id: F07B020003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: n8k6si3wxbr1mnuofhs4jee31d55b6dy
X-HE-Tag: 1786973665-302110
X-HE-Meta: U2FsdGVkX1+n4eZsGezKYqO9PzNyHs9TGCV9NXIYQXDHmlE5sIeKLbEYthcSmqb6BJDibiL6xobh7JubNrazAL/AxpOupcIzQXOPJR5wnnhOucIhJ1Da17cexv601hi7l7/KY3RoPYIKe8V8hj9Kw1EktraKWEVz8Yr3Eo8R92B29tUhfFu9x0X7KQDSNDfaZEEhh4fjy52dK9/9KU/gMB9pEnVfMIBtZcTVeADIb7fwf88HfvJ5vFB6SVnXDLWl7MseA5MKfPwcPRzu/uL2n6Iuy03Krm7pJlRBEY+FlSy7iPmFyM0aIzXFai6gfUu9pL1nT3I4KXh9wBJmijCZw3QvpyiNVITlFILIwCVvHwk/5lTfSRbi8bQb8pKwUt9e3Ug+FHkBa7qD/2JM4nLegBIV/Gc9rAYmTQhej/Vf+e9MmUqG63Gcy6g2JZ1YyevKZFRa4JOWubT0xlLg6vC/nXbZpE9wdhsOLPlkMtgh7HxRYgbCGr3L45C4yFPhBmU0XYXkHYXLbGu3BEHluJTUIoBNRHHp4Q+ZCXz4+8XcuCQvH01i1gJ3D78IdrtiOI/pEAcEnE/j/2RPKqS4PaShEj40EXoqBqpnG78AMyklCrcZWY7p0YFn/x/U5eLeTgAMbOmSEwCZFl24zpDMqta5UW0kM8154HhMjReW5irmNt0w7nUBgrYi9Sz857xbi/zab1TNyotE4d3+hH08QWL3PaWeyXpb/QFkTSlfavWp0idBoIO0OxBkmg07wKTaP7/06dHTNwK2h6OEI+cOq0R66cV2mJB8KvH6v46gVuK/+ThSNw7Vj6U0ls9gDQK+cvqvIERCXKPSA/7YyUq25hnDbo2BrMGbqCfyn2CJJrQ+qKMqwEQzALW4YolMZiC7bW/BoHILH3661j7Fa2cDleRfAb/rgxsPzMSXYnQNqQHSierL9bpWlHVMkzu7jYdpsxqsWByqQz4O+HZGLm9BfXn
 G+gG33jr
 seDQoOLxO8nspbp7xkWbTT0GJ6HN7LGWJehOSMvbMAhHqn5goX10knbdBPHVUgwR4LyfYtGvTBOC4qsJgP8DwBoDZl+ASiO4YevAN0cIy83MxJbJ9TpM/33XMblSaclGs78ZJ/9ZDWYD+6KWP3U6RKTxvaMY75RfDfNF7kS8ajscmeC6Wd3xYX9iNoJFkbR6zEamvo/LHWOCXU1rShPKe63Pyl9N0jAMsiNo//wUbsfH3c9KtE5dBJNGASwWzHu/8E9XQsAExUrydJq8op1HxR7pcJb7effRgZcYymrtlfiobjgzqEG8G8m6vM4Zmt++s+Obh4tV+bE2QiVAW58npjQh1cY53G/a5MMjwuHb9cVLrJqkknihZ5k3xHUw8jXFA5Jgy5+HrBCT7pRNdvq3eNULwYmB2OUdYmvKa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--xhbipm257r2x7xs7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 15, 2026 at 05:04:32PM +0100, Bradley Morgan wrote:
> >Rename function to prov_vec (from do_proc_vec).
>=20
> s/prov_vec/proc_vec/, the diff renames it to proc_vec.
>=20
> Also the SIZE_MAX comment in proc_vec() only talks about the no
> parsed element case, but after 3/4 a kmemdup failure leaves
> left_nbyte unset too (it goes to out before buf_left_final gets
> written). So the sentinel covers -ENOMEM as well, a line saying so
> would help.
>=20
> The split itself is fine, so with the typo fixed:

This comment is more about why it is OK to use SIZE_MAX. The case where
kmemdup fails falls into the "no elements parsed".

Thx for the review.

>=20
> Reviewed-by: Bradley Morgan <include@grrlz.net>
> Thanks!

--xhbipm257r2x7xs7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmqDDdsACgkQupfNUreW
QU9DGwwAicS0Z0OGIyVckHI7brK9mvqaOD7w4chOv8WkeTLatBjaqFGWXkHQj0gG
M9VE1JaFkXvFbNf7PBvVN0+vFEZXhocsk9lapp35m/mVNCVIz5XW446pPHAKy03F
mkQQNNGFG8Ppv+X2l7nwwIqsOONNnAcrHp3stEeHHeICw85IPrOInrKL+o/nFP7J
J+Z9r6/JDm+u1PY0CYH9xOQjQZAlU9y5QiQrLoYCp6DYfWRVf5baQTIlhhWNxafU
Oe0Qwu70jWAvAkHLCbG7XOF5IoF/y9k4b99/P9AWXcYaMagw1VhGS3375O1zPv0O
m81C8Ef+y2IhRxMwoyphEr0aqKx/N5GQNjhkQQjGIj4MQh6KOxZYywmQ1+ONYXeR
jfxeJtN5pk2ROnUlQ6HQb/g9PmvLjOkAgKoevZNZ/TD/WOScgHj/LyPCxY/SB4K3
q9KQp6NeYVmSVI/mgOOI98EhUDIabAfsMqOnK0mAxwOm5PrVRWFwLRjd64kVfqXi
5bSZC63m
=ZNXh
-----END PGP SIGNATURE-----

--xhbipm257r2x7xs7--

