Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E60CA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 23:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB786B0005; Sat, 30 Aug 2025 19:11:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D858E6B0006; Sat, 30 Aug 2025 19:11:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4C6B6B0008; Sat, 30 Aug 2025 19:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3F066B0005
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 19:11:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A4C3B7E92
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 23:11:36 +0000 (UTC)
X-FDA: 83834972592.26.1EC642A
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4989F180010
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 23:11:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="PFud7j/G";
	spf=pass (imf06.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756595494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKJR3d1y6/pE646jp/qQ2LVHmuXD7qWjBS7Rpy0QVAg=;
	b=yGcnRdjhomr5TfO+bMWU5zSmTjttGxRpAEFq6/3zwebs62XBGyHSrtPUOg9/B/tCNNdSQ5
	shTj0yE10T2e5MPCjrzsLobWwiVbztkw69EUtF9WX3tTpRJ2XmFcfku3qN8ud+vrlDJXaI
	2dTOxgSKxDlhy8klBJpDUCKrDGJP5zA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="PFud7j/G";
	spf=pass (imf06.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756595494; a=rsa-sha256;
	cv=none;
	b=LYKWYFNRp8UFm+yvv2VKSl1ONaR7weHfer+YUPc0JyBbLtmuypo7AdE9rHVvzu+iS1Fmzw
	RCEln0xfdbl5+Miuw+ZGQ+O7akfHK0B0LoRKVRxZkILmzkLkZxfqDDf4LzrXHjw2+1fpER
	5WRCDjuT0H/4ddbtt0BnfTmAPOB78C8=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b4f1ee2e250so218253a12.2
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 16:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756595493; x=1757200293; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pKJR3d1y6/pE646jp/qQ2LVHmuXD7qWjBS7Rpy0QVAg=;
        b=PFud7j/GYSsGR3DwtjkLY9hB+frhS/ip5nZKhYmA+w0dQV9J8xJolglowbLNR6WS5L
         MYygNOrg/Dw6+gY6F487wolidVa6ynhiq1Xl6HpbeWtpk+LYrWdiaNugOdVhzyrqmVP+
         q0lzvRC+UCEm9DykQDQ5H7UXcSN5Mq6TywKz7aoGfKeQyQxUKegKeMSgD3r1MpXut8+x
         KmKdJMzVYPeIpBsyvwwabxGn6QfRCTL2RjKcHBQzqNimCLJPDgQCKei930+TX1szhUSA
         iMWtRX/p2NqJ+7UR6Dc0wKwhvvmaV/uSHw5EWCyk/4IdQ3xishexGvwwkQ93aMDThTkF
         78qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756595493; x=1757200293;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pKJR3d1y6/pE646jp/qQ2LVHmuXD7qWjBS7Rpy0QVAg=;
        b=ShBvVy+iG+4Vsac9w7rNQ61Y6bu7kw0N/XQw+ol89zZP959fmg9cEs/UbYYvijQSDC
         TuQ/Y3JKsnTXQ9QarE8CAEnE/SouolvvsBP/Xc9OPsfAszzp8tamHCZZEemdmV3ZVYCg
         2oLWcXZ7wjnNZAPK9zi715hHvOnt3aJeCoa2UfNOAgxZpd9o7dG3iyAOCtjVdvshIzTz
         BeEA9rz+y2VfmvBevMMVaNAHOfjtGu8/OAcTZthVGgDwMPZHBQANDSq0/SoZjfi4h/PK
         ceQ3+GfUuGe83EATjlEQyBVndDM9ZPXoCQq7OOEgWOK52sr/FdEo29PWpQCeKh1ESYu1
         2RkA==
X-Forwarded-Encrypted: i=1; AJvYcCUQof5Ak15jhUNOQxvS78pHkagljTrav7TWLbdSQlg+ezhgvVJW0I6jZ6qLwjhVT0BYMArJGy/Ffg==@kvack.org
X-Gm-Message-State: AOJu0Yx8+j/60ZQtEx72c2C5m0v/DdY3+zvUNzC3jed6TE9LjqC1XYJ+
	Agd6xRxlPAOmKYAItixoJHT7Ai6XgzCM2ZDxjSm/j8+0W/3dnWVZWmCC
X-Gm-Gg: ASbGncuX/+EckUltbvdmhYK8NknbSzzJV7dayrAlj+ocqyKPFcfew3vS5ukdpNSp9zZ
	7Ex+XRFkdiJoCCtZ127MbZcx4oHXh2Wy5eUmUha0Nc1JFllrVuMfMl0vkASvK+qw6fqbmKPVuRM
	Ox9be5YWOsjTEVuy3cgK4XetQU+0/q89GCgnEBbuLPnngkC5oY/HyBRyDRakwKxgv9rG64BZzOX
	5XBgcujxT7sGVSp55sZyKWCQcVsu3BJm2plkzWVNArf/hkMwfrvrRkl9ZHTSMjN+jljMXUaortJ
	W7sE6dDeSbgphTm7oY0y74n4VY/TWjV1wXBnnW6BLTbMVva8dbbArDRMLkG1nCR6uWOAAV0sZCF
	iyV2YHTr0txht5cVA11NDNQIHF1CtajOkoQjR
X-Google-Smtp-Source: AGHT+IH09TdLkBTBS46a9KkDQcsPHCKV5BjcOl3BN1JIlX/axUWBHc8jxps5fYfmQWtY+6vT/lzr2w==
X-Received: by 2002:a17:902:c952:b0:248:cd4c:d6e with SMTP id d9443c01a7336-2494488a679mr39782015ad.9.1756595492940;
        Sat, 30 Aug 2025 16:11:32 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24906395aa0sm61840295ad.100.2025.08.30.16.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Aug 2025 16:11:31 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 3F63E4222987; Sun, 31 Aug 2025 06:11:28 +0700 (WIB)
Date: Sun, 31 Aug 2025 06:11:28 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux DAMON <damon@lists.linux.dev>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Power Management <linux-pm@vger.kernel.org>,
	Linux Block Devices <linux-block@vger.kernel.org>,
	Linux BPF <bpf@vger.kernel.org>,
	Linux Kernel Workflows <workflows@vger.kernel.org>,
	Linux KASAN <kasan-dev@googlegroups.com>,
	Linux Devicetree <devicetree@vger.kernel.org>,
	Linux fsverity <fsverity@lists.linux.dev>,
	Linux MTD <linux-mtd@lists.infradead.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Build System <linux-lbuild@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux Sound <linux-sound@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>, SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Huang Rui <ray.huang@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Perry Yuan <perry.yuan@amd.com>, Jens Axboe <axboe@kernel.dk>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Joe Perches <joe@perches.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, tytso@mit.edu,
	Richard Weinberger <richard@nod.at>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Shay Agroskin <shayagr@amazon.com>,
	Arthur Kiyanovski <akiyano@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Saeed Bishara <saeedb@amazon.com>, Andrew Lunn <andrew@lunn.ch>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Alexandru Ciobotaru <alcioa@amazon.com>,
	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steve French <stfrench@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 12/14] ASoC: doc: Internally link to Writing an ALSA
 Driver docs
Message-ID: <aLOFIEknbxQZ6FM2@archie.me>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
 <20250829075524.45635-13-bagasdotme@gmail.com>
 <20250830224614.6a124f82@foz.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="q50L9+H94gXo88jD"
Content-Disposition: inline
In-Reply-To: <20250830224614.6a124f82@foz.lan>
X-Stat-Signature: whycfp8ahu1yw3stjcc83mwh5w5fgg7z
X-Rspam-User: 
X-Rspamd-Queue-Id: 4989F180010
X-Rspamd-Server: rspam05
X-HE-Tag: 1756595494-276114
X-HE-Meta: U2FsdGVkX19knuZCNPR714drAFK1P9En8jURckFlOUL8QfxIlKc8GzKneSGDYmkPRSbJTKw0xgNNOOoemAwU7WxqSym0g5CBOfkOTGhaJs6mr0yknBAe8Kc9JQx31UxuodzhF4Rcov/Wr9TyD4CCIysO7JD+Ip441IkS9VlGKlIYcW4Le9RqPWjhSZnxNMSR9DYhHBqdEIUQaoxrPYP1LIrYUtU972fEdDAuWKZtvBebSTNDfmYGrYoDRNwGGKV7tZJv79AHMXw3WfPfg8cOJawXl8dTAiFsCagr8Nuj2oMgn760naMWPp6x+CvxJbxhFuDTBUA3ze22mYpAtoBVeVeBS0jKfre3YMNk4s/tsnoHlkSNyhx17Fjidigv3glo0Mib1/lt247CbbgsQZXDs0JUotLlThrTcxR0f/WBzFmS2FlXIO06eFcV40bC/Bm2MaPHr2cMlDJygxhOVI4fKcJtyWcqVdo2EXBHSj8MiTQ4fRToAOmq6gZ694/QQFgeUAtiufeFtGNhiUiI/poxK25KgslmpdZgkg7LQ0Jih9tJTlcgq1VJ7ZkW/YJWWCmX9JzuoXn/lunfcsnj3fMCqYSDP4L5Ntc2aYrWmj/nsFgEDJgaNmva7ziUmDgmn2dDeW6/gkc9F/urNZDsSJHnRypxyK2zJZbEV9GS1DzGtWOk4+1JbdCkh/bYDGixlqnMwUi/D9NkzICWhuzLeQApwNRhNkYsVo/wZvQ0dX/G28+U7VEFYo1rIwyAk/c7qf4KjyF4Gy6JbjuscFMjCDyv7Sm0kGrRYNY7XFy8MbS7Rb68DvAgaGzV+7CtZxSr4p5bHqt6kYKOunq8/SzDPr8F4eEv9ofdHtjXhuRtlre3w2QMKsZm929WWhfLQGxWI4H+vOSYiuNRnU0Qyu00Tl+K+35/lNEtBrQc802FeMu1TTtd2yNJKeY0Dn568BuU+PWHGYBHMUo4dqNNzN51W24
 eP3SdAz2
 XrJwhoeP2p0oi0UX3TreqmBKRI1HGMoH3qac9BpFW31IpGS2D+GO+/azrRbtHEUAio4f+a9oQk/QEcuq1crVYeCT2tQ9yG8ek2melgDX/nKnFiWMZGI2egXesBZvpoIFYv/olSQ4XfHE4uGCYxmFh+wax1LaD12Ydkw1xRKglYAABjGC2JLRlf+TwVGenLLSV0vKub6isGg86y5fBHGTYHTdAu0mrL+jvcoTz7ks2tBjS92QOeiWFZJKpYtvZNUdhah19erBZLdZ7TEbWOBNv+2ZnsGtGpD1DmcpxBxTA1MHGoWyt1WQlVEnvNJllwXnUFsduynh9ctbDZHUActm/YSWvfI5wJJf1GrRmdpm/s7vsdIICnRDTt5VEjIHpO4ckpjpjvUAbJKZaUF5fPRHIF9ZqvdLnx6kpw2REICN7vD3Ld9i/ghMEpGZtei1y4qg6X5A4/V4e2gAB7DmBs9k58E0qEoBDA1byT4XTm2JODArm7iwp4k1quR9O1Q9QqWeT9NwK5Z7fC13WIx7iUrGPO0IYRBuKBnlmsPDjv7+pqYk0PabQGGWJgoFr0iVrNjkXKw1EVuhRJOIUrFRKCROFI/gRBmbCYRpIOKxhS+szpL4uTBOalXxgRQSHN0kltlCxRzCbfOJ5VP3PN7L8AL7Pwl+0fI98O4pvM06XUMMEPCDFVIY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--q50L9+H94gXo88jD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 30, 2025 at 10:46:22PM +0200, Mauro Carvalho Chehab wrote:
> Em Fri, 29 Aug 2025 14:55:22 +0700
> Bagas Sanjaya <bagasdotme@gmail.com> escreveu:
> > -Please refer to the ALSA driver documentation for details of audio DMA.
> > -https://www.kernel.org/doc/html/latest/sound/kernel-api/writing-an-als=
a-driver.html
> > +Please refer to the :doc:`ALSA driver documentation
> > +<../kernel-api/writing-an-alsa-driver>` for details of audio DMA.
>=20
> Don't use relative paths for :doc:. They don't work well, specially
> when one uses SPHINXDIRS.
>=20
> The best is o use Documentation/kernel-api/writing-an-alsa-driver.rst
> and let automarkup figure it out. As we have a checker, broken
> references generate warnings at build time.

Thanks for the tip!

--=20
An old man doll... just what I always wanted! - Clara

--q50L9+H94gXo88jD
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaLOFGwAKCRD2uYlJVVFO
o9MMAPwIm+r4BZdTF0jZV4Naj+z2WrUBji4gRFJQ4f97vYNhfgEAwX/UGgC71a9U
lMJHF+utPAWnldcv9PoyPOBgO71EEAA=
=C7rV
-----END PGP SIGNATURE-----

--q50L9+H94gXo88jD--

