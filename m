Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D05E2CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 12:45:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE4CE6B008C; Mon, 12 Oct 2026 08:45:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93D96B0092; Mon, 12 Oct 2026 08:45:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0EC6B0095; Mon, 12 Oct 2026 08:45:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D63B6B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:45:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EFD2C140CBE
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:45:40 +0000 (UTC)
X-FDA: 85313945640.20.06696A0
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1166B140003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:45:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=evUUYGY6;
	spf=pass (imf23.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791809139;
	b=OLDQjCcsrBrm7NIq29DCZBLHyBgQIUyEgw3cYGygzu74sRpvLjj+uKIrq92zgHUboC7vlk
	kRs+OOC1rvQ38k3IK9zZM6NwG5yyMDtwdbx7bHQLoMJXc0CG1L7Li6eVHNQsyJva5xpPGs
	3u5EQ6oyZsq9z+HNfOBsdEOIDpLDw8o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=evUUYGY6;
	spf=pass (imf23.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791809139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=an/ERodSzuEqefgQ6URo9mMgAyarZVhVNb5a4ABoOvI=;
	b=op/1ve1nAYZ6Ar3VwH7lD2ARL0L/fZ6dji7L0lLDAUWiq3cZrtTVtogJmBHjO4SztSh8Qj
	LCLejC6RXuI0K1R6F69nRneCFke6dZyEjez+XH8Gj8ScLE5Ypdbzs2h5Gz4mErKVNNM++j
	1krXQ7ELkRTpLRKuGpIy5DV341Tf4X4=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48c5358fc28so1275488f8f.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 05:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791809138; x=1792413938; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=an/ERodSzuEqefgQ6URo9mMgAyarZVhVNb5a4ABoOvI=;
        b=evUUYGY6c+oDEH+C9AxRAZ92n24hkXqL98ocmPTHWPPPa3l+WS4Etk55/XuWhVGa5/
         O0u3jkrtHBa9gL9pv3ZpW5af0DVeIrfI+m4nX9IcuehiBnnydAcrxF5bcpEHEr1wDh6C
         ttkIOMPnEEOkScTFNzOYwrxZn5dyT4iIb1R8CcjAGORPO0Lhj8oV5CTkwGBqVtuIqgox
         IjOPGwUER9Gm7K/XAI1FgbpZJg6zJMdIKFI2A950yxAc7/jmkVMWNNMGeoPzJddh7QtF
         C8SWJnVG/Rv7Po5hfkqiivYYy5Y3lhpVvOsYjPFrTCyJZ4UzYX6u61n/H52jVHxKvigU
         qh4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791809138; x=1792413938;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=an/ERodSzuEqefgQ6URo9mMgAyarZVhVNb5a4ABoOvI=;
        b=iD+/pPsoqQ8qcStskKLX5XdBmcKnR6iKai7xBCm/fU8CDc6LccZqxyShwlqkPVjymR
         dG3N6GNs6tRmwlJM0J6JKvYw16TG8+GM4DWNwLvA77alLEl5uiskVcZjQaHzwUJfuXV+
         pnC0EAAZoTBAZ/ymXTGc4se2VrxY8ar9qwNN4dh3+hI60UpXqUm6Rm0hd/O2rAyHRhXE
         KnCza3JwE957neYdrHpBzb7A40D8JHTKSJz9c5NfesH4gcF+CahrHJk0VsEqsRmcLfb0
         EEGKU7W9glKvJugOejNeMVXVjp30qk+4GNdgJY3MtRBMX491ONJX+PN7VJyPYLtOrQQA
         Y+3w==
X-Forwarded-Encrypted: i=1; AKwUvBw4QCB1FUOP9Ftr7fMyxisYhVQeDbrHlPUJjwwHfyrMwbenXSZEwVRRBsbMzgst5WuqN7t6Tr6ugw==@kvack.org
X-Gm-Message-State: AFq9FYJYCKqPI1cDFNpYrov/QvRiFYC+X7TStWOaOsuozwdPaOZDAflU
	6UEKnefUeEkv57EvSr3j9GhwDmcqYG5x5/88FS50LvA8qsIGA+tBdrvPVQoQdEtgzd4=
X-Gm-Gg: AYBFou2NfBl4p0HjSHC5VtNa3f/uOyQ73gUPzP8bOoRSnR5nAx0TsXukvwVJ+KTqhTD
	qTFzdSJ7Maeqd3jym9JudQggw+SsN9cKUrFsme0V92nprwWzqnmrEESpi6kobD/Pr9IYhb5N4j0
	R27TydSJrtzLggxkAMpStjish641CFgKJwUnfgVl9rykyF3s4aQlv2M/Mg9kJliv7VrvONiFGvo
	Uwf8lAwemLxU+XLxRK7xtLGvGLBtv3gYDBD+7BRGG2gnTXbVCYcBS0wRcw1tlGI79vaIjgU0wfY
	iDbVyE9j4nvHyGrX7OkwOuwxkSefEF1B+qb38uoH3tDki4M9dq+OEAspFgbrF0TLnvXdVytUPJ9
	citBZCGi0HjnfhigQnT7wQlX8w9QHeKg24fu1Zsx92x6lzi261p4zXfaD6LAbf1IpHiBc8n0aFj
	SmoPRXo4SEb3f2kCczEZZhovRfdUwj8eIQD9jIUcOUjDhApBLYQshN7+2uUfr0x0NZKpA49PkZB
	g==
X-Received: by 2002:a05:6000:298d:20b0:48c:43a4:37f2 with SMTP id ffacd0b85a97d-48dbaadb3f7mr12969989f8f.17.1791809137549;
        Mon, 12 Oct 2026 05:45:37 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db9aadf9bsm18884941f8f.29.2026.10.12.05.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 05:45:37 -0700 (PDT)
Date: Mon, 12 Oct 2026 14:45:35 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "T.J. Mercier" <tjmercier@google.com>, 
	Amir Goldstein <amir73il@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: memcg: don't close an uninitialized fd
Message-ID: <20261012-clumsily-chivalry-c652481fc90a@there>
References: <20261011223358.2327625-9-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gylt5nk4uhld73ur"
Content-Disposition: inline
In-Reply-To: <20261011223358.2327625-9-sashal@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1166B140003
X-Rspam-User: 
X-Stat-Signature: a8p8yiofgt9iasfyo44xc53gxjkh4xr9
X-HE-Tag: 1791809138-226823
X-HE-Meta: U2FsdGVkX18TX5L7KmgeLPbea/4T0yOGk9C2DqXZsnXilZR5qZQOgst+9Lyhli+/yw5izaBvD5aT3phEq2SqgATroAaO2EZ48OqPTWuTDUL2yC3qAsewZlnS+/26n+o8+RHKFMsak9MFBPRr1LQ+kD4cesXF5VaLfGl/AYd0QfqbT9TdPvzckHCssMerNQlfXuvwUjW0OP4WzPDXPsGMSVb5EpArzc+18ZJ3QTHNxfw2qehG2HUz3xX6U94byRRytxNCReLM+EarR/yG2mwMHhzVQlO67iYgRLBfmXgWT+Foa2QU5YEnr4jbqh4x1F2Z5snQ9KvuxcaxoqTyQO7toSs0iy2/j7DLikrclvfi52c5XSstXRJ3P1DnGiGMtxBYepzbjVfQCL9KjhXJiVQerDv51Jw5Ikn/H1OzarJ9T9mAKkRzkppWwZWKfSr3EmPyEVKiZ1YcXRWNhpv6+ia/WOk0o6iJJ1inrAHVC1HGKi4rWWawF+LLw2f4zmM2JyycQ9bJgaa6NRYt6+GMWT70AQqOc/+1a2gqL+Sh3r09d4ik3a0Ow/DbjpC9HpgcUSiIzVBpr+FlQLNmUxzajGpaId6R2HYGfzt8+Lywk1sMpMhfT3pe99jS6X9wxIOCFU/T4mapjSeYbQiB3GUgYzfYRSaYwpCWKD/7TgTxM8CNoBoOtLCCGLKETMaxEThJJ9nL2bQL4v9OEcE+g1VFuY/3T92j7gYZrgiLJPVhwwVg/GmoFsXJfb5vqMPZ1SbFKRG6i2D8uJZ/5hgLyCXyM/U4gkZ/FhGag0Zm7IerZTe5ZSPN8lTVkQ7KsEcwMJhlnd3EwIErA4UuKsIo8QyFhK9vZCnvfXWBvFlf+0MkoP63k3UOSB9m0QKPzMhyLjKvGd1NYvarfNol7gfaTRvOAlRrGkMGkZUjw29bp3AHfxFYvfA92TEcAOk1TPUGy7UtX3KjFoQZhUZVDNROL6CH+wR
 1zCVy1ap
 csE62gH4ZK5NvNQAPtFizi/ZUye32L5TNj1Iri92tPXsL8ODwcE408b7MIc/+6f6Wycblt5WzYwcn4ejFgyhibJkQCDY2DIcIVTiPb4HInUdT7t3UZdEf6ibFVErLzaPKAab7h72rwINkb9AePdGIEsaXPICvUXk/4QY7aktXvU9qA+48hY8I1dEcIrsmfxNdKurbR1gZteJ62QBzFrPOItC93FGFRga4W3reZ7uHZ71e0bTvCTaDSWzs5nNaKLS6UOFxL9SOQYtVMWbc17id66eXJDmpazXwLvu0MAm4ChW7Zjck0/o8gapkHvbq74pg/eNReutlgMFWm60+PLHHsLA8a/szdzzpGRulXMPj3L1/ModnAD68F7ndUtfnTUeZdkA5LNchVshQnr7I+Azr4BMWkJOFiKb9csp1PQlFlzQZec5IYJmj9bqz7tDbHgO9RHAWFix9Cixb8wFXqrLJs2p6SnYbUV0xfYFs83xNEIfx85ChZMGWAOAaXm7GDuMza2JO/4mTOWg9mFM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--gylt5nk4uhld73ur
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] selftests: memcg: don't close an uninitialized fd
MIME-Version: 1.0

On Sun, Oct 11, 2026 at 06:33:37PM -0400, Sasha Levin <sashal@kernel.org> w=
rote:
> test_memcg_inotify_delete_file() and test_memcg_inotify_delete_dir()
> jump to cleanup before the inotify fd is created when cg_name() or
> cg_create() fails, and cleanup then closes whatever fd holds:
>=20
>   test_memcontrol.c:1685:6: warning: variable 'fd' is used uninitialized =
whenever 'if' condition is true [-Wsometimes-uninitialized]
>=20
> Initialize fd to -1.
>=20
> Fixes: 2de27980e1d46 ("selftests: memcg: Add tests for IN_DELETE_SELF and=
 IN_IGNORED")
> Assisted-by: LLM
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/testing/selftests/cgroup/test_memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks too,
Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--gylt5nk4uhld73ur
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaszWahsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AgD0wEAmh10oDQEWn7n0aEJYbBb
uaxG6lg1fY/9sjcEXSxbRKgA/Rt/e9OL/XTpEvxAx8DVCCsJgZnLdHG4SM+IuwrA
BLAB
=3bZl
-----END PGP SIGNATURE-----

--gylt5nk4uhld73ur--

