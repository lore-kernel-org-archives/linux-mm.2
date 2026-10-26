Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B3A606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=FCJOn1u+
Received: by kanga.kvack.org (Postfix)
	id AA0C36B05B8; Mon, 26 Oct 2026 08:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A51246B05B9; Mon, 26 Oct 2026 08:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E516B05BA; Mon, 26 Oct 2026 08:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 735966B05B8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:57:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04E9514070E
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:57:56 +0000 (UTC)
X-FDA: 85364779794.01.77C9020
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf14.hostedemail.com (Postfix) with ESMTP id 07521100005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:57:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=FCJOn1u+;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf14.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.152 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793019475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kZI3MT1fgSFZtZ0NsU7CZ4YdGhUuoHZE2FDP+AhJ0Qk=;
	b=gKcuuNO1C2lEbmyCPblurl/EbZprnDpXI3MBNtUDDrCmcTxSkzoK2+VU/aMubep1AqZSgb
	3pmpmoGVxQOUkfv0bV30u//unlWMLd4hdK9JNRZ0qsBrDmUk+cNgKbn3HiSlx2szCgTAxl
	lmKZpGaXBsV9Le/DQiJaD34nWLWsTPE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=FCJOn1u+;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf14.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.152 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793019475;
	b=K1h7MiXGVpI3yOm1gbyMkfQY6NNKNHbUh0o7a/blLZWqJsX/dBd1Yh81isoXrtu1GKboRt
	XQ/zARl3+evBrJVgYkJMfIKBXO0gATlAxzfKca69TzaybmIiFfx4r6NZOpe5HcAWm3cnSk
	shWZdw+e8FuMd5l9L40una3Ipmav8qw=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4jCtvg6Pv6zKnCH;
	Mon, 26 Oct 2026 13:57:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1793019471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kZI3MT1fgSFZtZ0NsU7CZ4YdGhUuoHZE2FDP+AhJ0Qk=;
	b=FCJOn1u+/3qCGOcdCmyWy6c3EnJJbMA7p+5O/jZIFJVDNl1nGPzgOOVLBR640V8uM6B4cg
	zZ/Pd2cWtaHFlZ2pzYBrz6T8KveM3Ja4nPS1wx3z4Wn8ndDqGTKe5L/mql743iB0WWg8lX
	HHAQLFQCKkrwRu0z/ka2d+4N+34Sh3RcPoZd9cF1GK069gPmtg42dz5bpiLp1RqXhxfrZB
	FIDbd/IYVmY3xvi/CNqOTra5g/Fn9Sa8sxo8fcx+OvMjmzwY8p7tLWhCZXYIroA5v5p+kn
	lDyEXt0TiCcLdn8DJdli6UFmFLuwBeO6MNGSyJIOgLiWhB2msBOouLoOYzOUXQ==
Message-ID: <d054b7a2653a2ff3d419b689a50a53290c2cafbb.camel@mailbox.org>
Subject: Re: [PATCH 4/8] Docs/admin-guide/mm/damon/lru_sort: fix remaining
 grammar
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: Aveline Noir <jm5905938@gmail.com>, SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>,  Randy Dunlap <rdunlap@infradead.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Mon, 26 Oct 2026 13:57:49 +0100
In-Reply-To: <179301327249.2.16817896016779044743.damon-docs-grammar-4@gmail.com>
References: 
	<179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
	 <179301327249.2.16817896016779044743.damon-docs-grammar-4@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MBO-RS-META: nzgmngh1z81sf44u537fisxxmnjw44kz
X-MBO-RS-ID: c5f618f06e0dfd708bf
X-Rspamd-Queue-Id: 07521100005
X-Stat-Signature: z9woh8asy998ye4aiobuqz9zej6byhdr
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793019474-501911
X-HE-Meta: U2FsdGVkX18mMeHn+HZkO3pONg4arxL0hLgtYdHeP20iH8qILhItZH5R64qua5db7qdW7f04jKxNVlK9xUXEQsu9OKc5JKrptoxVeoHzQpQYy/q98T2fD5cQc9D71GrP6NWycQQGa1Qd0htkC5fNLRQT/eTzPbuipVAFFMAJHQXLQsjtSSoVz2Mna4q+Vz7mzPs3JB1vrC5Qj1VzgFexXWxUZ9n++Hka25Gzwt5bNijXI/BqYhs9rS8+gBtiXHrh4svtFPBSnqT/tsZhTr0RAOTn3MNlwIT1Xj6HqaUXvPqMJKqwa1LjwkZURJFh8AFMxs4eetNG+X6A+zs+8an0RTSj7RunINkywSaNUwqQaEQoQAvZv48mQSpLPe+BVK4AVY6PCY2lHZJt+TSE2ejZL231MC/zd70DUXmMmWOWrFsqtFpVEf8OV5AkiG8k3Z6yM6xGMlEca5nv184vpIaw4LJUn/PILh9hwqNnfPcTsGn8S00+F9j4C8jKxcAeAteZEi3x8668wJ1qUNM2YfLt1Dju7rhDWNyBfH9fnCo1LHNZ29CCZV9M/o3s1NKGd4jF8tl3JOmib7qyEa3ATSbicTl3obTvysbKGaEVxAss9neLMr8sR3s43neMMHfmgUMuJd4+hVUZRosXKYWlrHeCuHlKjg9cqrgenF+OpLB25bojUGei9nx2dAb4Yw/tBfX1srGEw7y7xh+RrreOfyIkax//XaTBVJG6O46mOTa+4relrZZZoTloTaTeHU7uaSTEfrDu9v35iP9Fl5ZOlbj7EhmywmzqiNaeclcdHNQItbUc4+R7/UcOwq+YzcZjPtvIlk7voSkT/CAo2bc1UHFLWHNEyAg163WLFXsEX5MMafYya4K9/JSIZ0r1ChvsFKw59Lecl886Jvk22iJm7U6ECK0M2QP0FqUKPa3S03rfgbB5vOd4JuES/wmQsSgioU7XA0aytkRxSsI8Sw1/tHP
 HwCtWISk
 REik4e4oK3Uiu18+E8BO+KG8zEk7AKtz6nsoT83vx02SBMwsE3jXGpRF0hU0cBVQdDdWWGtzRSk2amE07tT2qyOk/dp6wmWT+yaJItHtutsptHkpM18LbbGOi26Xk4g4vNrsq8gKdueZX+Ut45sfN1AkmiN66Ud4A5snXiB4U2NJ+NrDXhMFP6c9Cr1AM/tKjezRNV7+6KTUWLAolRYfhqQ4DOhLNlldnYj3Qvi3svEr8kdb3mnEmttzYlbZX5bceSlDH8U5EVQJJJJCRUFs4UFDOFXJvy+oByR3wRgO9Wm68aDSbOnnssyWrZZbMGmclV/N8aun3B3C+bqRXlfpIgAk/scBYrA5onWfwcbEB3RZRTj+7L/TYO3pxDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi again,

On Mon, 2026-10-26 at 22:14 +1100, Aveline Noir wrote:
> Manuel's recent grammar fix for this file, now in damon/next, covered a
> good part of it.=C2=A0 This should take care of the few mistakes that are
> left, like "should automatically activated" and "Make DAMON_LRU_SORT
> reads".=C2=A0 Rewrap where the lines got too long.
>=20
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> ---
> =C2=A0.../admin-guide/mm/damon/lru_sort.rst=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 45 ++++++++++---------
> =C2=A01 file changed, 23 insertions(+), 22 deletions(-)
>=20
> diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentat=
ion/admin-guide/mm/damon/lru_sort.rst
> index aa4cc90ca57c..c628e3f6e587 100644
> --- a/Documentation/admin-guide/mm/damon/lru_sort.rst
> +++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
> @@ -35,7 +35,7 @@ deprioritizing cold pages on their LRU-lists.=C2=A0 To =
avoid it consuming too much
> =C2=A0CPU for the prioritizations, a CPU time usage limit can be configur=
ed.=C2=A0 Under
> =C2=A0the limit, it prioritizes and deprioritizes more hot and cold pages=
 first,
> =C2=A0respectively.=C2=A0 System administrators can also configure under =
what situation
> -this scheme should automatically activated and deactivated with three me=
mory
> +this scheme should be automatically activated and deactivated with three=
 memory

Yours isn't wrong but I would make it:
+this scheme should automatically be activated and deactivated with three m=
emory

Choose as you like.

> =C2=A0pressure watermarks.
> =C2=A0
> =C2=A0Its default parameters for hotness/coldness thresholds and CPU quot=
a limit are
> @@ -55,7 +55,7 @@ DAMON_LRU_SORT utilizes module parameters.=C2=A0 That i=
s, you can put
> =C2=A0``damon_lru_sort.<parameter>=3D<value>`` on the kernel boot command=
 line or write
> =C2=A0proper values to ``/sys/module/damon_lru_sort/parameters/<parameter=
>`` files.
> =C2=A0
> -Below are the description of each parameter.
> +Below is the description of each parameter.

My choice :=20
+Below are the descriptions of each parameter.


> =C2=A0...
Looks good to me.

>=20
> =C2=A0--------------------
> @@ -310,7 +311,7 @@ Total bytes of hot memory regions that were successfu=
lly LRU-sorted.
> =C2=A0nr_hot_quota_exceeds
> =C2=A0--------------------
> =C2=A0
> -Number of times that the time quota limit for hot regions have exceeded.
> +Number of times that the time quota limit for hot regions has been excee=
ded.

I would go for this, but I'm not sure:
+Number of times that the time quota limit for hot regions have been exceed=
ed.

Number of times that ... have been exceeded.

Thanks,
Reviewed-by: Manuel Ebner <manuelebnerli@mailbox.org>

> =C2=A0...

