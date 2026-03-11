Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F1841049515
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D55FC6B0089; Wed, 11 Mar 2026 06:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03706B008A; Wed, 11 Mar 2026 06:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEF1E6B0092; Wed, 11 Mar 2026 06:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD8C6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:28:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D2191B88BB
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:28:01 +0000 (UTC)
X-FDA: 84533406762.08.5416A33
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5A74C4000D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:27:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EG4qLRFR;
	spf=pass (imf17.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773224879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X5j4jaAYOM8eCoDOEvFzIXtQzN3FUkdB0X3c7yVW0+s=;
	b=Dsh2R8s9V7yGY9Xxi34aVovrim9vAcgKLieP4TwSJh1+xCR5IE3hKMmAv6BBYNWvKYG9Cl
	JJMLR+Wm9QEGbDytCIlUUj5TRIcFQZNRV1euP1MUfTjlV+3t/QT7qTFTNvnQmDeNwIhGA/
	VxHclt4UGl+EgLTzE14lK3SikO121js=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773224879; a=rsa-sha256;
	cv=none;
	b=ZrYNuP/0krWBebwEnKA43tT4/s7iJnLL2dfVoXQmZcvqYmdDuDCazooYP0UFr5LB3kr7I9
	RgjbWejskK8/kt3jFVtovuvHSp4H/fuWMjG8PAVNx9tDYX/DdrPy8dDs06+y5t9VTYy1hK
	WwvCe8rvJ0WYwLi81vg2NVuCH7XYMtw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EG4qLRFR;
	spf=pass (imf17.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-482f454be5bso9296655e9.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773224878; x=1773829678; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X5j4jaAYOM8eCoDOEvFzIXtQzN3FUkdB0X3c7yVW0+s=;
        b=EG4qLRFRzNs91xiebQuWyOXCLbWUYIoQyVfNnACcdPC+Jcs83IdUoVO7vATeOepvfo
         g/YQBWOCdO3Oucl2JqKnZIq7WVJsJESeEY5NRtfHydGuh4v5Ew95C54GC73cpvniOM+E
         osGFm2qzMNExF59gu6Md0aelY2xsNZn/cJ7zQbiO46zcu2BzBzjvMNyd0KlUBYv7NGx/
         Zpb9C9WubQtZxXvL2f5aD4UwEm8TJnRLzHILT/QTC1JbcZSurVv0+iqf4GOCg8L+ak04
         lsrvJM+oiUZ/dW/KV4DnDDjwqZNdLGOPoRwaxP7kpUD88c424zAae2AycXt9piaQklmf
         KG5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773224878; x=1773829678;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X5j4jaAYOM8eCoDOEvFzIXtQzN3FUkdB0X3c7yVW0+s=;
        b=BnL2ngTOx7VkD2ex13HrfWE6/uyYYZPKEAF3lt+o0RxdroNHU1qFz9Q+wGvGTZx5U/
         20K6wfvVfOpuIIWZZQjLiKROxvGSLG/8btgfzTh9Cttpdpi67a4wvgTNGPut2V6mKpdg
         IX09Mv/Pme8YvDKimb/zC/2kgZ+dDzGDZ95/hxrbcUk4yolyLOt0ye1Wp7AWLUwYiVQM
         4jtFKI764JzB40esc1mjd2OGp2GRfbBUiZDQuO4RlXHEbxUMxOY5bSQneeNE/XKcNXOg
         EeheeQCEZ6tGnAs+VV5wDD1dYLarQhI5xAQj0iw56LW7aSGwtohrJo/BQ89iOvCL9sSF
         AsNA==
X-Forwarded-Encrypted: i=1; AJvYcCVWPLOrZiLBZwhAfQifGGyrd4vK45INXJbHwzmjBCZFy+ONZdUpY56+OvCiVoTSVooRi4WYXFGv6g==@kvack.org
X-Gm-Message-State: AOJu0YxxXHX49cnBX/jAOEmxLFEtNLmLbVbPdwhUmrvaeuMAjZjsMKAW
	DxB/r9FQHeiCim4NPqTUVQMV/0UNMQQEpRXIJ3A+I3Bd2XNJRF9XeYqdSDB9UtbuuUg=
X-Gm-Gg: ATEYQzx/4UjPCA0H71Y/lbkPNVsdnOWEjiLru5Szogfl+UtBslZi3gSqvgwfhCQwvS5
	kY7q05MFqZuJ/YOdYTk87q3zBDkytX8nVckJsEgMlAVr4EMwyxAkIpSEqim94TYlElhjGaTDUoF
	bqZIIbSovDZp0jAmQq/Nylh+gzkNXxbSRHZTa2Jp1g8jFrsFVymAuli0OAIMT0QM32IPhEMxGwb
	3vxOM7EYdhVntzF5c2SODAzPFDtHMy+pSZHolnLQ+qsYwDpVWN+iuOsYmgU7ZHMW2rCE9zf7nGY
	2gAPBKmbDEFmkcCgFCJ9+ARJpA+UqP4vW2IsFDtMAkNG1SH/Wr/EAwttq9yZ+Rh1uhCLoIQ6i20
	wcpiiPZFJBF5XTneSjJRZXLI6G/kCX6CLx6reUyzduaIn1e80O6KZcFBZDsJWlheGi3WZZxhi6l
	rxWNpTMxPMSwNa4bXu5V7e+ZnxHQlD1q/TiUsQkVBJPUY=
X-Received: by 2002:a05:600c:8b05:b0:485:38f1:5cec with SMTP id 5b1f17b1804b1-4854b255a79mr29402935e9.7.1773224876909;
        Wed, 11 Mar 2026 03:27:56 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b6756e4sm49552295e9.15.2026.03.11.03.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 03:27:56 -0700 (PDT)
Date: Wed, 11 Mar 2026 11:27:54 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2] selftest: memcg: Skp memcg_sock test if address
 family not supported
Message-ID: <rbw6bit7rgcpcw5zc6vdezp2x3sufogled4yxn2i3xmjkg2gb6@i2rpowwixa5m>
References: <20260310143936.720592-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pa4tyuvad3rxlz5h"
Content-Disposition: inline
In-Reply-To: <20260310143936.720592-1-longman@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5A74C4000D
X-Stat-Signature: uikjcwg6oerforrqmwyzjja8d1kyjpkr
X-HE-Tag: 1773224879-528250
X-HE-Meta: U2FsdGVkX1/jl6q7IUQ42ufWT3xq/TTKmAawclH5u+VMybw2CK+7L0J6Fmkla+ieaOpppGnA81E8NTdlk7JmuHcXcDMTFnQQa05hP0byPhXP12JZLq9J5tKn4WApLbXqEKbKPjCZ2qsTFtOiqxvE8xEzuEol6AD8gKcyL+Aig3aPID6lGingE9fFzeNWSg+YGw60xvs/wRLEOGbrwPxd+nfqfbU+4r/25GT1d5pbfkb3zwiU4XNJXG6aoxIbhFhhkL4vXxNg2YnIGmmPYhjnt+a2z0bPMm1OJd8GD9Q9Le+K8A3f+HBA0OLb9nHwbNgCTsTRQQdrVOiuz8FjV/KF1M7+ti314uXUXfyFN3xPOBGUJXrfYq1yq4/vPNxJGIe9V3HyQ9XfPpR8LkON8wg2Sjjksm+IsNq6+U2dcQA3U8xrqxJ9BV36czwIOzzrg/P6iMJwciTqeLNimJ5g8uKLJNNy6/yVBLGJs9IWqW9R/2yFvB+wOG1NM3cmZWXjkf1dkpx0aIJZj60b+AC4pwFsx4Sv9gBbbC9Jng6g6HVTf7ZrSGa8R+TvpJsoeUYr8rHH3xlfuBiHpL0Wfj7xBuAykVIkI5uTNxgBTMYcfgOG+3Id5X3g8V7Ng1XVQsiRZv+LN2P6SgTrXwahB6Vei5ca+W7qwOm0vL8fOkKO/qul7O9Ov+3LB1eEHXO6h231JzbIpMsiWA/qrExfs29CPsbWNyp25VFOMUstQNlYNC1zQRQxeW3JiI/4Zp/q8G2mayt2g7cH9XLwWuSWBoYlWDh3hGCt4OK9X7YdelsbW5OGcnvAYQstgS8kRb/qQ/385y7dOAx8+PG586BEDG/dU2Fekze9YlYLND+3vxprE+UFp9Kym6e41Hx+buNowtNyJbNgzOy2X2c+V7oJPHFdNfZ4yR9UYxWMaZgaCencpQJcaDp4ERCenFzRIzMH+PvxnQSlhnAfzdxubl34RiatRdF
 ys6OhDnw
 C9w2WOFS4zQos9gOwlr6va5KcAbfwidb5bppMb1lvLFnfjuV/T6vg0TxyIfeaRnFJwxCUpOOiEE76upK7M1Bqa6kfHRa2fEln/X6Nl0+t4EscekPHULrc9FJPOGHBw+TZ9mtlxdesggIkceGVypeAFIoUL/8HWTgMSdYqFtEOtQGFJM5n9Td1aLQ3e9a4Jd4EOE0Vbr2V+FNpNMz4PGEUKkl8nY3jrRMU21pigDcmn4ly6sXhMlWr+28aOPqFqaLgn2YClS0PMcEwuCPT+6V0TmhmbiBjy0E6Lbfo71ch6z+C4wSqliEK0ws9iU8bu1/aJKtVXgNAqBqGPHrA2rrpWsyen2RTorwWsQspe2RurxupN2FPrfWz4COdwOlvaYDP7nLQUwrk5kSh7hXu6k7eVLTOBVJzHY7GTzA/shY+yaU+7zfI6FclKJ7L+TZ//lbLSYiPu+wCXq4OFymdVWstg2Xx2Id/zIuuX1aI3vKvx5evD3zi7y1qDLKupJneCwhMrX01kRLkXr/AreCZwNkC66PLG0DAT/5ckQ/hxtU0C4daaAIYSK9m90izWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--pa4tyuvad3rxlz5h
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] selftest: memcg: Skp memcg_sock test if address
 family not supported
MIME-Version: 1.0

On Tue, Mar 10, 2026 at 10:39:35AM -0400, Waiman Long <longman@redhat.com> =
wrote:
> The test_memcg_sock test in memcontrol.c sets up an IPv6 socket and
> send data over it to consume memory and verify that memory.stat.sock
> and memory.current values are close.
>=20
> On systems where IPv6 isn't enabled or not configured to support
> SOCK_STREAM, the test_memcg_sock test always fails.  When the socket()
> call fails, there is no way we can test the memory consumption and
> verify the above claim. I believe it is better to just skip the test
> in this case instead of reporting a test failure hinting that there
> may be something wrong with the memcg code.
>=20
> Fixes: 5f8f019380b8 ("selftests: cgroup/memcontrol: add basic test for so=
cket accounting")
> Signed-off-by: Waiman Long <longman@redhat.com>
>=20
> [v2] Update and commit log & adjust the skip code as suggested by Michael.
>=20
> ---
>  tools/testing/selftests/cgroup/test_memcontrol.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)

Thanks,
Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--pa4tyuvad3rxlz5h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCabFDkBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AirqwEA5ez8dlyt/ZfidHe6iSqC
8cAuhuEPnD7bwDGi8sH7DSsA/39ZAFz8X5c/wfwzVixVP458FkA+Xqr/aPpG33QE
WDgD
=jKdH
-----END PGP SIGNATURE-----

--pa4tyuvad3rxlz5h--

