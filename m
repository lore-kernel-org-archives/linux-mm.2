Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 940FAC44507
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 02:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B896B0095; Wed, 15 Jul 2026 22:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742286B0096; Wed, 15 Jul 2026 22:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633B86B0098; Wed, 15 Jul 2026 22:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D63E6B0095
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 22:31:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC7001403A5
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:31:54 +0000 (UTC)
X-FDA: 84993064548.20.FB07F88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1301A140009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:31:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=arYbAtWK;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784169113;
	b=c09HJFaMjBD8VuXI5E8qcaFkKfwM0xwtD0n6TDY05yFCDLWM6PnhArXnromeiKZwH9nHtg
	NmmdYaWd/7ZzsoIo7ohZvbOkP95EXrPu6XZOVgDiLy4nLouPvvZK+AGg/TTU0+Kvw2Qf1N
	nkItEQxx2gqEGANhth+CMWR/YKKrTYE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=arYbAtWK;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784169113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ynGIyMuoCcAD8NaeJqodKE7wCOdyZZLepombpmz0j20=;
	b=oWxWNkOvTJVgTssH+4gOJo9sUZ236RNRfUcOCsc3GzNT78n9BhiXAq0ALYbUdrj9dQqHDw
	8XQFfYNQSMzzt1OLIw+iCOQPuxmTfgCSBDpizY5Bc+5rKyx4YmpURpmWDodKlUGBQoGBFI
	zW1n9aIF+Jq0z7+/rcSAlf2pSBPlt58=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 831CE6001A;
	Thu, 16 Jul 2026 02:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCADC1F000E9;
	Thu, 16 Jul 2026 02:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784169112;
	bh=ynGIyMuoCcAD8NaeJqodKE7wCOdyZZLepombpmz0j20=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=arYbAtWK4LRZHodP80tz03WZeyNNdKPJq+lxECSV5GryUBNFR5Gk4F6+APA2CQnOb
	 08c5nJ7fZJCbIMppyZmV/AqhU5CfENRjMb9CqkND87C9YH+JPlEafl1lhYR23Le9dW
	 d7zZYG6LcET4EoWG/1qg2n9J9np9e++xKP6F6sxNRxGqDwRulzu0s16W676NdNWQ5N
	 qAIwZNqBZnfQ1X+GoYYhmmmEt/I44c+WNrchLy/Mm7RlGEXSNHLSkJY78+XhmOflSy
	 EbUXzEig/dVOJvqrLh+J3egH77K1PgPo2mzv8evsi+pBbV5b/rbLkhzFWLL8bF6V03
	 q9GVYEU79wMAQ==
Message-ID: <093c6dbe-6ca3-47cd-bf8d-3cc85c13f7ac@kernel.org>
Date: Thu, 16 Jul 2026 11:31:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next-fixes v3 1/4] mm/slab: fix a memory leak due
 to bootstrapping sheaves twice
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <20260713-kmalloc-no-objext-v3-1-47c7bd138de7@kernel.org>
 <CAJuCfpF3vRftgrQGYhRZk7B9Z+GuG9eM5Cx7HehBaaafH+R==Q@mail.gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <CAJuCfpF3vRftgrQGYhRZk7B9Z+GuG9eM5Cx7HehBaaafH+R==Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------fEYtHpWT6oe3c0X3dvhfUDl0"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1301A140009
X-Stat-Signature: iy9bqdh3i6f8cjafjwr4dmbw8ap9u9ba
X-HE-Tag: 1784169112-430879
X-HE-Meta: U2FsdGVkX19u2eVSDa0EUe55dOUS+gIsOH865vlj2lpZRsxY1r5yKyyzIsQ4eEFzIYDeHXdDCP5AFj02WT1fHh0sX6TBqVoYMMJNyRbl39nomS4VSOBgcgHQAeLbux89yM/tsngFUw0U81U2Qhiju84VnPtK14ge5nFQTZPlkoQHoJmvmLjhIwxZT4/GQlv+3f33byKKEAColkYDTGBkUDELEho/TvGtjg9um3v5f+W2oxFIDOCH0CR7D0TT7/IZ4mUm2Xvn0h2ydDnCO6YIUaxBamCinkXIo0tsaRDQmT9iZqgYYfC0TUaCDp8CWeQOTXTf32jFTA6AHaFlT2LIf1tUmoamD11QbDTMdrbmAv6hWdRtcRrFdgAjpzumdTBvrHmdGoSvggl0sd8ruOzXU5i1ogMWacEd75JwoUyvbYFgcXSi6s4fuAhLX9+ZulwN9hNORn0wjLiOHnbWBqIbwFNtQNywaNBRkQjBO034dRRvBLIFlkXS1zf6gvpRYEqkGy0KynTt79ps3RMhX9kesaNIrNw2stabOP7MgZG96CBAQQ6zacLfmqxS/2W0GD3uVgOmO+oWqcanEl8yfioj8fdPMU/q2TI92bZjaE9aqTsEjdrHxRwPg74R3kfq2Y3Tb/1FSg2TbQZ/s33dadNA/bbyURhYBhE6CrnMOqUYCQjtLw4KMgoLqctKWw2Au8YMFugvlgSUXi+ToA0fbaKAp8WUzIHKe8ZlbpNLGB6uZT0p2GoxvQzngqSMdmWiou2Y59VjTucWxfjP6DivE7TwnFsc/wKGroOcNxxxLac/xlwh6ifpxL30oSTM+SWputmh6s15J/kS3W/cP6XJRcFMnKeLhShSrv8AUl850/z9POn2Ns7nEcQ8CQhCviA0KJfGPRcIbNJB9TIMK5dwxYRFxCqro/kAdCjmqQ5UGdtabXw+SegokL+jcOmM92QYSnceJKQfg0K90TTaYVMoI2i
 6or3XQly
 qAn9bdDg/czHGPjWvn/ZbU+UJWXBEXayVR9p3nmlQPqeBLUQZoy2lxRwWNHORjaiMw7QUX6fbtcNsBRzPYXF2rEq5zpY0z/WJg6st4fYSbWkGhGCDrOhbERodaN3oSScp9CMifxU5kUpFMJa/0OIToFUfXReHXsHcQVv0RbJThMLip2gk0aQ9BAVE04nKCa26Y+QSbn86CKgP3IoVp/N2GGYtcLo7TczCxFcw6qAm5mjO4hJ8yvcZoms43jT5pw7iTzCXjQZKtm8kYuuWMpJHCkxIEZiTcZqWhbKoSbB7y2IeFS4LOqcu0IMiEbMXMtXl0pVgnjl9vKGyA6MhDyN2cipEZ2sy2ftIOpFMx8lvABTDnuGU094FR0SGG295RxIAxzOOzMU74MwuxPQHvrLs46okSBhahds/mQEa/eGA3QD2NP7ZH0mcn6uD++1viYqwTJCz75rJNd1TmEz1B45LB/oC3IPkL/Ta5U/DtOsq3NskWpODkFXv26gIHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------fEYtHpWT6oe3c0X3dvhfUDl0
Content-Type: multipart/mixed; boundary="------------vbeyTvd6sxOFnT8cjLtWNjuj";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-ID: <093c6dbe-6ca3-47cd-bf8d-3cc85c13f7ac@kernel.org>
Subject: Re: [PATCH slab/for-next-fixes v3 1/4] mm/slab: fix a memory leak due
 to bootstrapping sheaves twice
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <20260713-kmalloc-no-objext-v3-1-47c7bd138de7@kernel.org>
 <CAJuCfpF3vRftgrQGYhRZk7B9Z+GuG9eM5Cx7HehBaaafH+R==Q@mail.gmail.com>
In-Reply-To: <CAJuCfpF3vRftgrQGYhRZk7B9Z+GuG9eM5Cx7HehBaaafH+R==Q@mail.gmail.com>

--------------vbeyTvd6sxOFnT8cjLtWNjuj
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/14/26 12:30 AM, Suren Baghdasaryan wrote:
> On Mon, Jul 13, 2026 at 7:29=E2=80=AFAM Harry Yoo (Oracle) <harry@kerne=
l.org> wrote:
>>
>> When kmalloc caches are aliased, multiple cache pointers reference
>> the same kmem_cache. As a result, iterating over kmalloc indices and
>> bootstrapping sheaves can bootstrap the same cache more than once and
>> leak memory.
>>
>> Currently, this could happen when the architecture specifies
>> minimum alignment for slab caches that is larger than
>> ARCH_KMALLOC_MINALIGN.
>>
>> Bootstrap sheaves only when the cache does not have them already.
>> Add a warning when bootstrap_cache_sheaves() is called for a cache
>> that already has sheaves enabled.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 913ffd3a1bf5 ("slab: handle kmalloc sheaves bootstrap")
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>=20
> nit: Don't know if we really need a warning...

Hehe, at least the warning allowed me to confirm that this is not an
oversight and the patch fixed it :)

> I would just do an
> early return from bootstrap_cache_sheaves() if cache_has_sheaves() is
> true. But that's not critical.

But yeah, no strong opinion on this.

> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

--=20
Cheers,
Harry / Hyeonggon

--------------vbeyTvd6sxOFnT8cjLtWNjuj--

--------------fEYtHpWT6oe3c0X3dvhfUDl0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalhCkQAKCRCGXBN6rc5S
1nsaAQCpaAuH8Gtt1L7sSRp6NLtXdS3rymXJGVx8TEl7PzJAMQD/f0VpUHt3Q/Xa
GgIaG4fD6fiQReheoPjiIEKi+SYxpQ4=
=y4X0
-----END PGP SIGNATURE-----

--------------fEYtHpWT6oe3c0X3dvhfUDl0--

