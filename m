Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7651C606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jZVfiyHU
Received: by kanga.kvack.org (Postfix)
	id 97B526B06AA; Tue, 24 Nov 2026 08:01:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D0F6B06AB; Tue, 24 Nov 2026 08:01:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842216B06AC; Tue, 24 Nov 2026 08:01:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6456F6B06AA
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:01:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F0E7A120B5A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:01:52 +0000 (UTC)
X-FDA: 85470024864.23.56F250F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3BA238000E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:01:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jZVfiyHU;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795525311;
	b=NJNAC8p4+wM9yK3AdX8YVJ40WVy8EA/zQCEeJoQVWhzXQ+uRO6HoaIC7uqPqcOGbivHF7R
	UEDek3FfmPemvNAZsG+bUHgf19Fp6mv5XSebfXdBzhu5qeunQDVRbUIQTD+59TXz+HEL3l
	RiJzfkbQ9S6FGSPXa+nA+xioZFPsdcM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795525311;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrVF/aYtE984rnLlm5LPsstF/ABph3KbrqJASdwOlW8=;
	b=QyoadlLamV8Z4DaDhw/GO+sRhNtXscKemiDdcGpYdApV7DYi+ufpmilMxa0O1gnAWXBKqI
	yJcImaMhnBLG3G0ZywRsItlt3qebCtFqbgZ3RPwWFpligkNlS+tVbaPHRXBqawRvIYqCid
	Hr8mU46oxoFMHwN0zacbTb4eA4BK6hU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jZVfiyHU;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B10FA6264E;
	Tue, 24 Nov 2026 13:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B421F000C0;
	Tue, 24 Nov 2026 13:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525310;
	bh=yrVF/aYtE984rnLlm5LPsstF/ABph3KbrqJASdwOlW8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jZVfiyHUfkEnnKG74BWeCUUeEu/TkNSRVX9xZcB0JUmbgNk3fbu7sfKy/58ffkr8v
	 7KM1gVu5PLXaGoSMcQLgzYVQ/Biv1kuoDjegDQtIzqr9UfI4dzI1IJfaI/Zp0Qf/rX
	 d7Suht0hKQgR3VnN5p+/Ewxw1lENjBXXbTYha/NivTyMFSKrXwCSrDeDKzIivk3Yl8
	 JCaFYcwMMwbjT1EYYnF3CwqKq3DbgnMB4oAi0KnOoT5fRJ2QLZIRlc1+QhI77Xtktb
	 PwJXF4O985uzpPykyMCYJ1zZTOEB+JFHORxL4c786ZA0PCAHML9WbcIuv6kN/4qFYE
	 CdHf5nF6CTjDQ==
Message-ID: <sashiko-outbox-231187@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] mm/memfd_luo: don't use memfd_pin_folios()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pratyush Yadav" <pratyush@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org
In-Reply-To: <20261123130115.4021199-1-pratyush@kernel.org>
References: <20261123130115.4021199-1-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 13:01:49 +0000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3BA238000E
X-Stat-Signature: 6cayxmeydpcpedyfxrrgrwxhzc46di7a
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795525311-468338
X-HE-Meta: U2FsdGVkX19gAZ3PodIDTGOexvQ1uQj2kXaEU1Wd7o4xzccsiT2zs76i24NVafaYA7OsMx6t7jANN891c3DHwm3HqU3dBkpQpuw+EENDoDF0eHCKkH4nL3TAaM6DSz437xrulthiao4HfSNiql9XXyCQgSbEA5b7Wqtyf9HryMDyXpE3YG25gTIIScWP8wbJkjaZ47j29tySMeYgf3NB9mFGqQo0fExv17idqzYu/V2WpxeDQoamcKxneTEqKeJcGFPiIZIzjNIJSFoS4KH/CMgkHoOLpPJQEDX+Nn55G83dadhS5BH3Oc0ffLs5kvr0f2wCpmxuCaV4tqj8XNb+m5PpSX/mG1Ek342pEcshCQMnT1pAtdyl83lBXxYXP0PV+8AzSdcy/+jI5G71sgdXLVVdqJRvZqThUbqddM8Mtk6wUGBB5QFXF7oHnyI6pfhWwdZfwRG8MUR+dBgCgR/wkRDPUUT0Pv1stlU++hCz223+BOijFkd2T4Q4r4GI1wNP+shBv1zYKBmxD1yjjFEz6ZBIRNoHc/5Gz2ZqwJ8GNmjiIcwntTAPix8+H1OmW9SNMUsd88JpPtzrQAsdtJwXmVn6AGOwdBFRpKBwFIQXCcLxLg5Oyc1R3C+6axWhPpiEShkGMccf/5lzliyrUzjPlDLoEjhSAn+UOBnFy0XJRypj/kwIxu9WdOKtD3Tk8GJ4QaJQuzUUawZGC5phGsERwzfyqKsQm6qVfmiTG0NWkmKwCBPARMWm4Jb5GpNX9CewdxXsleQbHFix15wworiNnKy/nCsElsgkDvikHM9Wv1uA4xwI2cUika35mFNxEwjFuJoyACaS/FCBNCTwMu21EFiLOB7fHMIlipNjL2+p8FW1RvbktG4mpQrATworOObLlvkaaspx2nYbfugFTYdeOkTQtDPwzLoHaH57HsdbChhCpcRnmbYpJH7WK7Igs3qTnyFsfIye0fn3JOEpXDZ
 +fZ07ihi
 looLpPnf6WT2zYGaNF0V7WUVX2G4DMXm+zDoavncc3qomGofmxnsnfPEwXdjTafuzoYISygvUX7tZsANF8K113Ngccg7h/jkl/STeMYIsCQX06DNfF+I/T0lNY4ePArFNhteUL/yssU/hjWfytqPxKyeF5JjfbSfzw0cbqQP8IYgXNjBC+9BzJ+Y8Wmgsq2waqNXrMj2/Dflp0S+y4ZMG8p45SOfZv8dkhbxtt2UunYPb7Fu1J6FFk9xCtPsxy7LMtv1Jc7ZPHBgtP7ml73O19Ac2newzEulVR+v0ONWk/apfGrIvBpxnmvtlrxSDhWoBKyHH5KqmR1SQD2iLcdC5mrgwtxK2KGUwUvk++SL+NNVrls6yAc2KR43FJlXv/n/8sVnznAhEKiCSjeJty9qJB5d6ZzcvlW6PwHgsx09pk4gMZZ/PsfRRCf00q9MX2euvIMDCP9YzJpkaE6gi/AchbRO7QfeSq4fLyOq3o/IYJH6KJoa7Vb3dG5VQP0G0ee+dAijTqNAzNUn7EqFs3e24j/ek+yvNa9GyAtRh9drlurR4CKeWQvXV14J1CtuN+qppPYWxwcexfC6xUqmRrL9NRcNBX1w8qFLGZCmLmh3KEfrJoPoyz+Q3d0YIZ3DM57Qz6oDBT/M3M31eizRgoGjyeTwwWo4ScVzs14lXV+d9WXBLZF1FSbJgHJVAdE8ibepVwAZkk10Zrx+NcXhQJkzlIXgegHGyojCDZMPS9JteLZCpgREOZbeDgD+0JuV0HDFkPBin70K/r6+eF+8PnR35/nViQmlT0SjkEA2j8qL6T1VnrKgmwv16mO2zvSw+D0aZOGsSTfiun01VwqQDt/URNwhjn/ajPCF9fJ8Wdy7Ll/OOF3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/memfd_luo: memfd_luo_get_folio() returns -EBUSY after last
  migration
--

commit 41c3599dbcd67e367dde6fcd9824d0c532431810
Author: Pratyush Yadav (Google) <pratyush@kernel.org>

mm/memfd_luo: don't use memfd_pin_folios()

This commit replaces memfd_pin_folios() in memfd_luo with a direct page
cache walk using shmem_get_folio() and migrates folios that are not
longterm pinnable via memfd_luo_migrate_folio().

> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 6b68220275ebe..c963bc3522e61 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -77,26 +77,161 @@

[ ... ]

> +/* How many times to try migrating a folio that is not longterm pinnable=
. */
> +#define MEMFD_LUO_MIGRATE_RETRIES	3

[ ... ]

> +static int memfd_luo_get_folio(struct inode *inode, pgoff_t index,
> +			       struct folio **foliop)
> +{
> +	struct folio *folio;
> +	int err, retry;
> +
> +	for (retry =3D 0; retry < MEMFD_LUO_MIGRATE_RETRIES; retry++) {
> +		err =3D shmem_get_folio(inode, index, 0, &folio, SGP_CACHE);
> +		if (err)
> +			return err;
> +
> +		if (likely(folio_is_longterm_pinnable(folio))) {
> +			*foliop =3D folio;
> +			return 0;
> +		}
> +
> +		folio_unlock(folio);
> +		err =3D memfd_luo_migrate_folio(folio);
> +		/* Someone else might have it isolated, retry a bit. */
> +		if (err && err !=3D -EBUSY)
> +			return err;
> +	}
> +
> +	return -EBUSY;
> +}

[Severity: Medium]
Does memfd_luo_get_folio() return -EBUSY even when
memfd_luo_migrate_folio() succeeds on the final iteration?

Because memfd_luo_migrate_folio() drops the reference to the old folio,
memfd_luo_get_folio() relies on the next iteration of the loop to call
shmem_get_folio() and look up the migrated folio.  If isolation fails with
-EBUSY on the first two attempts and migration succeeds on the third
(retry =3D=3D MEMFD_LUO_MIGRATE_RETRIES - 1), the loop terminates before
re-fetching the migrated folio and fails preservation with -EBUSY.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123130115.4021=
199-1-pratyush@kernel.org?part=3D1

