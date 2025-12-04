Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7B87D2168D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7966B00AA; Thu,  4 Dec 2025 10:04:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE986B00B1; Thu,  4 Dec 2025 10:04:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E1A6B00B3; Thu,  4 Dec 2025 10:04:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E929D6B00AA
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:04:41 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B60FC131892
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:41 +0000 (UTC)
X-FDA: 84182110362.06.C24F7A5
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B5A14000B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="B5RneR/K";
	spf=pass (imf01.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764860679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/oVG6yt0b9tG4brIyUSYxsLsof1IU6gNnAr1g9Uea0=;
	b=b6kuc011f7NRqIJ5bJ9Xz3nm+jbAPHqqdU9tAZKxcK8+xjGBocHhPSDuo+G6D4HhW9mm7I
	/O1yRSsOHWhKsdebVZI81bAdgdbGes+FkhwSiDNXLovh4RFKbz/ag0trNNNamfucJEFn7v
	ivEYJXMg8/E3v06cvPj8k951GniRBeY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="B5RneR/K";
	spf=pass (imf01.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764860679; a=rsa-sha256;
	cv=none;
	b=Dh3KeR2+aHzOTfuNZWp0R8diCjEQAQQ/kyY9VbUBxzdzmwJ7Ykn6WeADDuuAL+0eIqGrsS
	g4IpzPh/HVAyqmpWBIb7Ld3ZR2WAwywiT8cT+10MXLJYZxHjzTe07dCdukumWhjQMWmGSH
	e2GpLXIo+rmVzqCUMwS3m7xFcw7pTG8=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42e2e77f519so830918f8f.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764860677; x=1765465477; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x/oVG6yt0b9tG4brIyUSYxsLsof1IU6gNnAr1g9Uea0=;
        b=B5RneR/KjnHGDhbR/ow5viw4DpCllpM4aZHD9k6oa3VL/F77hNuhmwLwDph+4BoTAK
         T+i40RdbU7qKvkZXOjLbC9P2RBbmc3+KZHhOP3QPV3UDN9Y5wV8lU7gbcj0pBKm4m29s
         +GoXdW7mtbEo3OLyRZvqNwRohG84LHN+iK+Sp9Zhz4YnT9sdNK0l9pSPVn3N+CuHT+si
         Hd7kZJKC8nyMb2jrhhz8lkk3km83PPJey2AAqvb8sXpmImwmHYjvqDLdeaL8lQ4k2LYT
         X8F3/G5N0BkDw+JgsDSmatl2BjUTMctL7qDDV4/OspsNxyTqbHmUzGtXS4r2PAg0SYaZ
         3jog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764860677; x=1765465477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x/oVG6yt0b9tG4brIyUSYxsLsof1IU6gNnAr1g9Uea0=;
        b=AgiXcQBxbxSJclp4hxkuBwNQFxa80fSX7Tfsa2OS66gtGHsIluuAKlGi33ywWritl3
         DhzRCcMUuEP/QPNjLIUC04N3SK/3CxPLuN8R49Wns58O1wC6qh0UKPstOcBLu69TVT+f
         /PJV1M8UGb0llpCAMm1Ihm0x+xdPSj8hFEpHFbIZfkfN67Ci4xAxuPsB3sC6ydQZQg8L
         UR8fKGCIG8Ys7uDjM0YkTM8XQlXYsi8Ha6CBp2vmDyj5AXHl2g5vdCVZpEZxIXu0gihj
         ZMx1HAGEWxcUU/g6kMoJ+Sd2g+jtWOKNcknJMnPDXGfclmIWCc8mfLgBjOpUQrcgS94o
         LcMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUP+JXeYrFrydLzHAgDpqYeHWFgsnmeqzMdMW32dpCcXUOpuB4CdX3dpvDCS4QkRnzxarjgzCJepg==@kvack.org
X-Gm-Message-State: AOJu0YxyvsGJrr6iZ8WP0bzaTJ0CMhRnw/6asa3ucVVkk/Ijlgr0JZzn
	RPHxKg9ORZWkQC6ZMnuslrTVlVuCnZOM2b1U0worLskoDhXCe1BMfBubro2Oz9aThLw=
X-Gm-Gg: ASbGnculL+jNb2Bc5ETy+1A5zU6YB9OdLdvGHoYMuQyWjHiO9NzfmPcfw7BRcNm1GsR
	3Ae8Sg/r2yIqk6MDicLzB5wpj4IKy+PVj83AWwJRZ/by2u0SGYDr5h0Bw2uXTQKcZ8xFngQ8GxA
	MBn2EZ8M+EfU+bfg7vkHJpDChoF8va5KStR3q1vbQBuX4sxgVndLF9Bow8M5ln57zs0gfIFCf9p
	XOOpO+28VcSFrwkHt/AqhtzjQoEvdnpfUO8EPJfJS7WD877VZAUogz7F6ruILsbkLq34sRqNk/k
	s3H7Ob2q5H5oIWr4Fb92K4F7xG3Su8u5sxUP690Na3saf5kxANeaa0kFCQTgYrgAuy7YGBkEL5z
	QMCqeP1teI9gt9QQfKV3ZcYhjysdJCv1vfp3egcVhizvTEcQOgIJcvdEZvexnk0+1GlXgpT6X8c
	Snq4d/hZDLeWiGp7/PMRMzeLhLgBC6OxE=
X-Google-Smtp-Source: AGHT+IHE5sb784sH97jiBE9GQFt2QDlFdyIO48ifG+5s0esu24gZG4M3Ltveqfpo7zH5EorQZDV74Q==
X-Received: by 2002:a5d:5f84:0:b0:3e7:45c7:828e with SMTP id ffacd0b85a97d-42f798482c0mr3517344f8f.33.1764860677527;
        Thu, 04 Dec 2025 07:04:37 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d222478sm3638410f8f.20.2025.12.04.07.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 07:04:37 -0800 (PST)
Date: Thu, 4 Dec 2025 16:04:35 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: tj@kernel.org, hannes@cmpxchg.org, shuah@kernel.org, 
	roman.gushchin@linux.dev, lance.yang@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] selftests: cgroup: make test_memcg_sock robust
 against delayed sock stats
Message-ID: <dyie6co47aemejhok5xjjmsvfjpsg2djmkbucnonent3afqylm@ojui2r4gb3ro>
References: <20251203115631.947908-1-zhangguopeng@kylinos.cn>
 <20251203115631.947908-3-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yv3jk2strjnvzxuo"
Content-Disposition: inline
In-Reply-To: <20251203115631.947908-3-zhangguopeng@kylinos.cn>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1B5A14000B
X-Stat-Signature: qamxmph5k4gutpdtrqkqc4ft64a4tjwc
X-Rspam-User: 
X-HE-Tag: 1764860678-72347
X-HE-Meta: U2FsdGVkX18eNivdRO9E9R7/a2x18xtDhsWNHvtcI16CQQcqD6X/pJ21XxaHTvAni5/y6SUHzHxP1zcuc48oYxgE2pR3Y7OPqF+wCaxV0P1Es9v46xLbruKfGIvEZKUIksa9Bkbat48vhjEPix+JOWm2kQfFVrJNvlDGIYyVoY+ywTnWuPz6vmD8AOMzngY0XQ9EeP40AuaSFAimrYqkxh4zev6k7qnbAfVDM2GUcEeT5L8mEH9cznk0sJSDh2szcqyPx9YyXP2JH6/GDnXQv3BPOhZTp82Lg0OFWuz6GMSs59R1fmNAlNphIp2qgczt9CYvkvYqzH8PN9udAwPjNGBxSMzCcIFehCcp9aqgTcD/9BD5/EmIEA66fW/i2da3/paqa2F80wIs565ac+8jOxvPwrYsAFaYPK3adb2tR8aEMHHxL/asVdlenzxxVQjRrY5THiucpRG8a6nS1D+DF14b8ZKuCidnVx2qShbKXE4a3niDw82m4ZS5qbv9YT41ozLMM70KsLdIORoSmEuen8M4njBHrjpbIrZnB6lFtepKMxTnEAHGUG+XuMNmMwhBow0iIIs+yV15ZpWgLK8UJlI7Sj/B3Kt6OU43r+gdIpkzbjBthApZwpPuYxBhSeapvoUre+nU9BCMONAdS+8pM9UoHOUduZ+NnB/RBoSRQPdca39LuAkOA7xYB8l13mcXxZBGSoa9aIxF4z/HDwffcoDNdDTGr350Fv74Rh3/Yhb+j94yI1QRhwNFLAjg39A6G6fZqshryUCKz7ZRkOtHne/Hm5jSA557UyDn99tXqnh9+nbIixyQQwK+x/TFuPZ3+UmblCrObglMhdr1lt2fBbsRQGKspf/aYeEwYW8VHX361Hg1yjVL2mXCA4KRR9rMAcoUaMRuJykemhIbGw4Hxh/blPFnh9qpfW1wGTPl61ujUdLaNMZDpod9zkIBWat8wrfynF0PXO+2PqqsJZ4
 A4ObHVuP
 Wg4nqsqgYNlJ7Nfm3uJl2jfy24ibmjrEdv67BVvnNoyBdqUzRL4Sq9ZBCkiVqtCbBWMUVE4eWDmT5w3i4pypuWRztkH6UmKkmYhtfJ0c73+k4BmBEAoorPz37Iuxo2tG9UmkjxfWBCh97GnaPdUEFPFo728SVblnNFBO8rIVk0fDt6zhrslizDcMNjs3i/t5vuNX76/K5Rm6P5UOX0ClZgb5GFQzTlHk/xYcvdRWq07fLlw0MIiowPx7RPDfYriim+pUBgrQwH6owJssw6/f02zutXYfY7uh/KGzDEdbOOwbccx7lns9/b5iwq+PMMVyNob48hlM61Cpf/+42Kb3XCs5Cb0lyEYbHoouWo7E048j0HFej2arThbLcu3HsDGxsAQ6BuxYxcI5J+YLB7v81Ut2oXCmqE/uWMSy0nuSnsIxrlEhYEqupyn5o6+V6v3jRmkY0rlGKOEXSAg4MwpOT5F78rkySwHtRCrRy5Aoobe0p1FfCEJdfBicZ5gJ0aaNBFEq1d17BMvloxYlVRO+7POI8suya4gPolVIA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--yv3jk2strjnvzxuo
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v5 2/3] selftests: cgroup: make test_memcg_sock robust
 against delayed sock stats
MIME-Version: 1.0

On Wed, Dec 03, 2025 at 07:56:30PM +0800, Guopeng Zhang <zhangguopeng@kylin=
os.cn> wrote:
> test_memcg_sock() currently requires that memory.stat's "sock " counter
> is exactly zero immediately after the TCP server exits. On a busy system
> this assumption is too strict:
>=20
>   - Socket memory may be freed with a small delay (e.g. RCU callbacks).
>   - memcg statistics are updated asynchronously via the rstat flushing
>     worker, so the "sock " value in memory.stat can stay non-zero for a
>     short period of time even after all socket memory has been uncharged.
>=20
> As a result, test_memcg_sock() can intermittently fail even though socket
> memory accounting is working correctly.
>=20
> Make the test more robust by polling memory.stat for the "sock "
> counter and allowing it some time to drop to zero instead of checking
> it only once. The timeout is set to 3 seconds to cover the periodic
> rstat flush interval (FLUSH_TIME =3D 2*HZ by default) plus some
> scheduling slack. If the counter does not become zero within the
> timeout, the test still fails as before.
>=20
> On my test system, running test_memcontrol 50 times produced:
>=20
>   - Before this patch:  6/50 runs passed.
>   - After this patch:  50/50 runs passed.
>=20
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> Suggested-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  .../selftests/cgroup/test_memcontrol.c        | 20 ++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)

Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--yv3jk2strjnvzxuo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaTGjABsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AiVEwD7BJrfWOByVOptuK3iVMCh
fif6gFVXfUY7OTYHzXj5Z7AA/0EyqsqZ6vK/4ej9qB2PndhgnCbsP9ZadktOrMdz
BbkA
=wjUR
-----END PGP SIGNATURE-----

--yv3jk2strjnvzxuo--

