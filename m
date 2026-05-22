Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35D53CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5803C6B00A6; Fri, 22 May 2026 11:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50B086B00A7; Fri, 22 May 2026 11:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1E56B00A9; Fri, 22 May 2026 11:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28A4E6B00A6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:26:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1912161AAA
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:26:22 +0000 (UTC)
X-FDA: 84795432204.18.C3E887A
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id C533B180003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:26:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=T9EN1XiW;
	spf=pass (imf16.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779463580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1vEySuvchtiTT5/Luvk9UxfuyTrDBUvQ3fx5cuplJao=;
	b=Ju87mVgfgEL+SnqcEuIhuQJ4imEg2+PzrJNqe5tIxOTqaqjWy6K33DhwUZwLRhBMKxGnXW
	SL3XSXV3SZiFhg+G9nxNWWAGNQvSVvgh3ZAerudfz1bGMlksloAtGsOdMTn9yzTbMmUD9j
	5AuYWEUVUNj1bsghWqk0Q6Gr1p+shsg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779463580; a=rsa-sha256;
	cv=none;
	b=lI9WFSg75GPO8rsTPS+Tn+3IPgx5xAY1DTpxxRnisH9mvjyHlzdlkfWdgtkGeh83qYgZ0D
	131CMyJB3+DrEcOg/RNSitH+V0aqJWsY9qRPB1Se6zHOKq8rkqku6pPdkoZybi0z9cVfiQ
	iQTVJCVZiaEyyiyW8ay/VNJ9beFzAPg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=T9EN1XiW;
	spf=pass (imf16.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso96401465e9.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 08:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779463579; x=1780068379; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1vEySuvchtiTT5/Luvk9UxfuyTrDBUvQ3fx5cuplJao=;
        b=T9EN1XiWrLNgtW6VQpI9Sm+zfaW1PTpUEixcPv3siMa089OXxOwsqk8xYUpCUjySqp
         xl5nc5CQjjGq03OnJvU8b3MF8+2YqdQTkUx+SW2iTbErId77BeX6EGiLe/yfbjmqZaGV
         ucapmhn4yD9hgaUH+W017cm2uVkqUTwrgEM8oX21I7h3+KIjnhbTYf21ZIETj6hxohwQ
         xV3621PxmUyDAwR19fMxU2uKGJLpq19EsKa/39bLI/4pOy4bMciAFEvzE7EL8tYpBjEo
         RZemn0VOP73nYvPv58hD3jMpm4ozMUPkVhRtQ27KHs4JwRp6AOPYLeHH2t4RWg+d38Nk
         ubQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779463579; x=1780068379;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1vEySuvchtiTT5/Luvk9UxfuyTrDBUvQ3fx5cuplJao=;
        b=s4dSmfn9wD/qf1MVXK2OiUo+0awi93F2FtGG41W4jesUaW+XShpgNA8fHgDBwixYea
         MMb7h6OEe4wrgLJeiuESSd947RPYhzWAnb/bR+HeQOrqqTb0OX9+BYKyCDY0Pua0H98R
         7SPYFKo+KBRjOoFhCGEMmc0jUhgRWwfHSFyYjgUGDDzxi9LUqY8ItolPrVhTw8z8dFZx
         2K/ThF/2J1F+VyC4K0TPGUjLrlR9L42dlzkvJISqK1FVNy6LM1HSB2NzIU5a5I7pKpB5
         5ynC8FwhosE4dJGS8MDPI3A42naHEt6RAwrim1ju7mmTBgXr7ERCAfSczIo+yO0zMwFQ
         +M8g==
X-Forwarded-Encrypted: i=1; AFNElJ9Vwly1em2oLeUsclieIWGKQRmkbyo8rbALagiFZqU3HXCl5BWvJdwBdAs33Hwqe6MsJ92sK/Um1g==@kvack.org
X-Gm-Message-State: AOJu0YwuH3Qdmtc1UZGKQ7lCEj73cDp3RJo6ReUQMMvxUHCY7FSCsz7J
	36+vy0K3Gw47CPojATTKNpJ83NSdYlC9x5ji/XajkG+gBrRxlnWPwWAT7Sd8hsujZP4=
X-Gm-Gg: Acq92OHFxCTz8L75vGC+ynW6rjm6OIMl+fXR+D1E/byPoU8LMolanAH0n2kKM5oxg5A
	oCoWGixDHk/4ekHwVlYg67ol6zRvM6kcV/T9tI+BOVoYjsF/1U2o5iMtTA/xGxC6mrPY5IEvJhm
	f4S9hwkbGbUnykX2Hv1BazCUiQsIuZcafz6T9IvHIYEWDz+QTY/NSyBW/rxeVV4fmeMpk6q1mdO
	ucOZ4xC5iywfyvzML7SGSyTIA9NIO7ZFxE4uTvAUhldjmoUd4NDPIbFjlPjB2z/icPrM12Iwhcr
	5dKKEwXzWA76m/et6vAVSLLHZNh5sjQpJulwrnjNQSIRslT0FqrpQ7lEffxjhDlo/ORGPekO/gF
	tJB10WTWMDBswjBCj6xoc+yXHgw1apz8TfvgspIDeXDJpbQSVrNwjOBxeF1UFhcQkpbMzck1YR3
	Q8lxJHwBzexp+bGYcrbXioPj97NbXAXfkBHcQm9+Nl/byqY0jaNP8jG4vFufA=
X-Received: by 2002:a05:600c:4ecc:b0:48a:56de:d62a with SMTP id 5b1f17b1804b1-490424b3c7fmr53184145e9.11.1779463579036;
        Fri, 22 May 2026 08:26:19 -0700 (PDT)
Received: from localhost.localdomain (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454a0b82sm53694435e9.9.2026.05.22.08.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 08:26:18 -0700 (PDT)
Date: Fri, 22 May 2026 17:26:16 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
	Dave Airlie <airlied@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/2] cgroup/dmem: add dmem.memcg control file for
 double-charging to memcg
Message-ID: <ahBxB5a9sX9DEWvl@localhost.localdomain>
References: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
 <20260519-cgroup-dmem-memcg-double-charge-v2-2-db4d1407062b@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="af2hel7jza3hmfqp"
Content-Disposition: inline
In-Reply-To: <20260519-cgroup-dmem-memcg-double-charge-v2-2-db4d1407062b@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C533B180003
X-Stat-Signature: bid6tyb18c8kensenuc99dts9uks385e
X-Rspamd-Server: rspam06
X-HE-Tag: 1779463580-141372
X-HE-Meta: U2FsdGVkX19D7aiZTtLD4McBhblqPyePDbbcV05vo4J0FVmguwad4hPifHJLdkh9S7N2mCKN5PRYPJK7njZVHX2AElNGOEY4ZYBnlFDrmSscKUhkCSljAg8NAuUL2zdDXXuaoZulrAnX8dbt4lFrpHTXJHWknr2Xsex2i+CoNJy6Mj9jY3Hvaf71QE3ICGz/ZfsofYb5D9AIjSvbe4g4vDUSqXhQnxlZKMmNc7SCE6SHvBkG4Mi9eTshWsjNjIjoO7tz4hivDK21VPpcRdN+q0Szsqo1IA23pzYXLiYwUjFPYrI14KlPy2ZaJFEIvOCBPCXrOxApNwCAokdB6A+fHzjZ+ydQps1d5tvkcUSk6zKwmqXudagYJ8eycYfazj3SxpOAJSd6+aSXuE7JVuEwH3DFXhzWcuSJYrHj03tEZ7EO6IhJ5iELSmQK5nrhXA7R/GAc/sHC+BG32L+OGjyEbFwL6RqPq6XPuHwKy44GDuZtx++q2iRin2GdD7T+5sEeg3TqOmFckc9i/nyTf4Q+A530//u+y3l3unZcX4gi8jac3VowQgn0EvYKyofToRLT8rfa4N0QJQ6OeIENEL4gGJfCyXbzHULvdBXYhOMKUS/oRXDBWlWkKy7YtP5Dd/Ru/diPUKQb3KCp6fwoO7XhE5eKq4j3luhQofNNaPYFiyYtEoS1MP5tiUqGbkZ3UGiMOlkACua23LTHl9FdKOymVdTX+yEHSpoLzkrWSRZ7ubGugL4SPDLS+TFuNBNFysrDdBGkUMqTWoT/dLUBxCKimnMU7BCLCKG0gBevrWQs5dYmtb/L0mcGMLIcMRbc3QLDYrSvW6DEStXzv7d+E66cPJddh506xNivrrZ17ZYkTzm5+QJetr+c7lmTei/p7g05QLiQpFRK8IMVWgBkCf8v1N7pi6GxeGeiddtftIjFJ1i/alnMzAk5aelvOVfCTa6TBb5Z8V3yA43MnHqIb3i
 lGALZ+cv
 g4mTYxIf/+KMLF1U2aa7zhvFxWlns1oOyvqW62mE50ab7XDhyuR8ENo0EaCDc6BNdEbyT/QRoZhPQld2qRru8NTzxaXxUr2+EMRfsFKMQI7CoXjBfKK5gyrkY7efAqoJum0ApN3eqVRj2V+ZufNIq9CLdh+b6UwrgYlFaO4igZnAhuBMNnRoyimTHDfiQTcCo+Z1gSwCQzxVFGapjf+4btpNAnQWtUWiknjLHXQ3dwgCRnRUw3ufbTiaAswC3KheuLQg4mdVZGXUCRounX1GhysP+CNBl/sHqDN/taqrlwAtyej/sDZ6mQ2z/zvNKNhhRpIMEHHdhJK0njbTgtZON62Z5aCiTcqWmTeboaUCPL6CHLq6nmNTB5oYWoIyq336LD8rWo4ecDuIwAxzJdGfDaOJsptgE6Bquh1rFVwdPUiFNB9gywGR0xWS4FZBonxnQ6P0qiY+hQNUaKMS8tvZGsd4uIp4M45qMok2z1pJNWwQV9gBsxLt4zQNTfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--af2hel7jza3hmfqp
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 2/2] cgroup/dmem: add dmem.memcg control file for
 double-charging to memcg
MIME-Version: 1.0

Hello Eric.

On Tue, May 19, 2026 at 11:59:02AM -0400, Eric Chanudet <echanude@redhat.co=
m> wrote:
> Add a root-only cgroupfs file "dmem.memcg" that lets an administrator
> configure whether allocations in a dmem region should also be charged to
> the memory controller.

This kinda makes sense as it is not unlike io.cost.* device
configurators.

Just for my better understanding -- will there be a space for userspace
to switch this? (No charged dmem allocations happen before responsible
userspace runs, so that the attribute remains unlocked.)

(I'm rather indifferent about the actual double charging/non-charging
matter.)


>=20
> To handle inheritance, dmem adds a depends_on the memory controller,
> unless MEMCG isn't configured in.
>=20
> Double-charging is disabled by default. Once a charge is attempted, the
> setting is locked to prevent inconsistent accounting by a small 4-state
> machine (off, on, locked off, locked on).
>=20
> The memcg to charge is derived from the pool's cgroup, since the pool
> holds a reference to the dmem cgroup state that keeps the cgroup alive
> until it gets uncharged.
>=20
> Signed-off-by: Eric Chanudet <echanude@redhat.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst |  23 +++++
>  kernel/cgroup/dmem.c                    | 158 ++++++++++++++++++++++++++=
+++++-
>  2 files changed, 178 insertions(+), 3 deletions(-)
>=20
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admi=
n-guide/cgroup-v2.rst
> index 6efd0095ed995b1550317662bc1b56c7a7f3db23..1d2fa55ddf0faa17baa916a89=
14d3033e8e42359 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2828,6 +2828,29 @@ DMEM Interface Files
>  	  drm/0000:03:00.0/vram0 12550144
>  	  drm/0000:03:00.0/stolen 8650752
> =20
> +  dmem.memcg
> +	A readwrite nested-keyed file that exists only on the root
> +	cgroup.

Strictly speaking this is not nested-keyed but flat keyed [1],
which leads me to realization that this is the first instance of a boolean.
All in call, such a composition comes to my mind (latter is RO):

	drm/0000:03:00.0/vram0 enable=3D0|1 locked=3D0|1




> +static ssize_t dmem_cgroup_memcg_write(struct kernfs_open_file *of, char=
 *buf,
> +				       size_t nbytes, loff_t off)
> +{
> +	while (buf) {
> +		struct dmem_cgroup_region *region;
> +		char *options, *name;
> +		bool flag;
> +
> +		options =3D buf;
> +		buf =3D strchr(buf, '\n');
> +		if (buf)
> +			*buf++ =3D '\0';

I recall there was a discussion about accepting only a single device per
write(2) (at the same time I see this idiom is still present in other
dmem.* files, so this is nothing to change in _this_ patch).

Thanks,
Michal

[1] https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html#format

--af2hel7jza3hmfqp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCahB1lBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhJyQEA4ebIAV+4wgYjb7Cax+hS
43nEgrk4mA0GQOKjivEd/KMA/A581miemqm16N6I0lzKn9Fm64QJ/G5K9t45IDQW
dr8L
=9Z82
-----END PGP SIGNATURE-----

--af2hel7jza3hmfqp--

