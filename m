Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B6ACA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F2B26B0008; Fri, 29 Aug 2025 11:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CA2F8E0003; Fri, 29 Aug 2025 11:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9148E0001; Fri, 29 Aug 2025 11:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 493266B0008
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:06:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1A821607C8
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:06:10 +0000 (UTC)
X-FDA: 83830120500.24.97B3615
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id A78221C0011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:06:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Y8ye/QL4";
	spf=pass (imf18.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756479968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtU8o3RRKlATt1ZkDZoqGZInz4LA3xlvTSiKt6WYT3E=;
	b=dfy6KpBCcIdWabHP2AF4fOnu7+bfWkUyfa0THDT2ilty5ijslyXARixupEQSPkQXOhKYEb
	ITUVh5Uv/+SnYlIQJTh6+6yW9CH84XCf36j2MfoA4AIfO+sdl596MskehrkciTAmH6/eyi
	/pCyeX1yEZ2rIsEUBUoHPeW0iD7bg5E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Y8ye/QL4";
	spf=pass (imf18.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756479968; a=rsa-sha256;
	cv=none;
	b=n/aee04uwECD73mN9UypK9N0HCJUtFgJ2n5+bT5JrywxyUOaUSFQOmemlJxWY74V4cDQly
	0WeILFitpxovjl55Xgw8oc9Et790qr9YB/BMNh0qQ+azk+mkv2YbvZu4ZVll81dRxFKWnk
	o4J/M+gQwgjlpQu3HeghtfqPLDCq+ys=
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-74542b1b2f7so1726676a34.3
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756479968; x=1757084768; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xtU8o3RRKlATt1ZkDZoqGZInz4LA3xlvTSiKt6WYT3E=;
        b=Y8ye/QL4J7zizxmfaI7rRQtngZSehr5dgWEviJ7UkVx28/LG1mpClsrtFospuZifPV
         T2VjX6lo2d1TnkWCT1LMTUnXyJlpfyWPi2blwNerY8VWLy1x03s2zj74V4GuXDCJaQq4
         eB65J35olwGNpUG3aNyaeSHNJe5m+kAXzO8X6sVLQPtTB0PRIOVa/vgiJ+Q3K4DmS/+M
         IjaZT2pvRp7xaWlxoUYL7l6PxQFNlAZANEBA6rkHI+3dxN3CyZVs1oXw1zcTyXyn0scQ
         bqHER74Ak2i6dkQaKjec7LPnIGCNb24HIXc56yuoIAUOOS8symGiI7aFtRCzx0g2w+r0
         vQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756479968; x=1757084768;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xtU8o3RRKlATt1ZkDZoqGZInz4LA3xlvTSiKt6WYT3E=;
        b=Yc494Xi+t4TCO56/0a+0ws6MVO8BYPbHrorlHxzjL67dqnwqFbmrs6md8VYJLXiTa2
         1dzqf5MpamTsniff7iV8EARXt8xFHm/Ua0mYGqtnHYnPQ96Id8ZNR9MH2rinJ2YdfvHJ
         a3tYrDYVHXCXmMuctuh6LFBtzLJdDgzSqPM1j3o3xZXEb9ZUjddxh93vHjXYpx6C/rY3
         magSsXqZWHHhfoCq0DZrvkidm0V8+t9g7VyElrqs5Xx3vTaroUGi5gQovHyaV/UkoNFt
         QhrtLVGRu0+2QtIQxHLE2DW1dOGp8+7V1tagerEakeVkmYPWXT8S+atpa0daRvcDjt+N
         AAFw==
X-Forwarded-Encrypted: i=1; AJvYcCXAczG6r2oy6k61JBdPyT2U71tZ72xSAYn/ecGbzykbXK/MgoAvf26X9YEQvYPBOti1TC2Dh61y0Q==@kvack.org
X-Gm-Message-State: AOJu0YyrWDgr9Z5q6X2XbW45IP6kZ9WA2aE5AyQi9bnxAtnvyeTM4iSf
	ImJA4uxhknn2+IgqGdbzkWnJ1iknHCmmWf+iIxU74HDFASZRpUiVGayU
X-Gm-Gg: ASbGncsq6bHKyEq9qELIbydmgaY9bxwtPy0ebS8/vVbUs4PS6TyXAITpyeS6MMvCxET
	ImdCfJsm9YOsYlHeUo2g88OSLK/mPVh1CpK2AaH4mdT+XkpunZVSp7/UTjE2QtuUNUwIb9P3l1E
	EL6J+q1aTc+BKCC3rDuMlBRPTiTsjcbdh5S/dALfwikxvrYq0zwmARMvnerog/lh1NAmmEnRyXF
	EXjFh98YSWMXGLi4v1rka79Jji/u3YU5QbbxOz4x3JUNJUU83g/Fk4xHeMdDHF91Ae7p1DC9lLQ
	Jm37qmgXXkB2xasAHZjejWRlbVgc/Tu+Uxl4ch4U7ALvGgJNAFgaYXpF9gXemNC+EBL3xSrwhKf
	OiXqFEHVQtxX3AF+Py4fijc5uVUyCnjmqtYiU
X-Google-Smtp-Source: AGHT+IHoYRW1dTyT65+rU4V7sdHQy1ZAWCnUhYSUduVJT7h6pncITh0MMXOlALcxWQkuMLP36zurpg==
X-Received: by 2002:a05:6a21:339e:b0:243:9b4e:281b with SMTP id adf61e73a8af0-2439b4e296dmr15525181637.49.1756473541271;
        Fri, 29 Aug 2025 06:19:01 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bac60sm2408193b3a.63.2025.08.29.06.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 06:19:00 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 51DA0409D7C0; Fri, 29 Aug 2025 20:18:56 +0700 (WIB)
Date: Fri, 29 Aug 2025 20:18:55 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Jani Nikula <jani.nikula@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
	Linux Sound <linux-sound@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
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
Subject: Re: [PATCH 00/14] Internalize www.kernel.org/doc cross-reference
Message-ID: <aLGovx7OpL_85YTf@archie.me>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
 <437912a24e94673c2355a2b7b50c3c4b6f68fcc6@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="v+QeNeXg1wIV/8Z8"
Content-Disposition: inline
In-Reply-To: <437912a24e94673c2355a2b7b50c3c4b6f68fcc6@intel.com>
X-Rspamd-Queue-Id: A78221C0011
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6mrm18wd8u9s76sen9rck3wandos74s6
X-HE-Tag: 1756479968-501574
X-HE-Meta: U2FsdGVkX1/0j3FMZ5f2d7zJMDCMi/eTW1dhDCLIUvH8QabxTS7LX8wbexpRNf/L+1iD3eV+wM/FP5GOI4cvBGP4X/wSLRsBXBzmQiDDUcyQLrHWBIBreNTx5gOtVi+xwbp6KlTWt0hyZ2vPMVJ0C7hjnNyOYpHx5P6rwS0oZ11EYYSNkO/jfR3iywwhXNlyxDPtjO56jaxm6YyGcle4B4P1JkpCc2KjBzkWQEYmz5CQs+KOdeZmtJHOMfIeWj3EkelHsdHlTWI5COwfjYIzmWvWPoyDyIhFvXkJgjhx55kGTxhq0tQzWd7bTNyRgxgf9aZKhV0urbc1BxSZDbht1m/8oYo8nGxMfnCwZEn8cyLSVCLKiKf+NDFOMDTBNsy0Rxr7TTJt898ZKAaCv+dK/COmvPNqP3GvftSU5G/nKVnl5SMhtZ8P6Wy0RvHWZ1IW0WVV1vnBVtsmWkFq12XAgG0N9A9cRzcRlVQoURszDguNxoiw/jStbDXLpwLh/okTC06VLCDr8W7A75s2vL3W0oTQK1YDWE1R+YPpCEVDnaMCaH2fkGSdITWx7ELBbVKZ5kzzGu1yQYF4yRxh2xCFp1k8tnqE8jV4jZCSBSxiFkTZisgvdG6wPUsArz1ahbmvghOcgNvTd8lDFZTJ8fekIuoviPF5KURBPKw18TQ3HbboINdD3Pf+VN2J95NS/N66ElMpSgkSid0R6mavv3rQGg12ctbfYiW9l1KaVW7g6viftC339R6siZr37hmItCP16/ZIaJPOH1XKSYcfiM5dN6I9py9wiB/ipzAXkbKCnJsyYm5DWgX9nhAPy3QY82vdnE8lvspicQPtnq2NyeWBmCJHqE7XRkLi/2LfF7d4lLMRBPQp0R0kvazWBoSD4me0pkHe6fwZMWOezNfo2tSq+V8A9JOAYiWaMtSo9xbFC2FlTdKosSc17qY2VOAi43StMkDoBWK/8aMtUxUL39t
 7xVelISN
 8uZwMhJeUb6ClftiTllDMihvsh9qmt597mIn80ZzapXFXymDjhuKTwQIbXh6FSPLQUx8yNcsAnZuPBNCBtrD9FpAR56g+dL9dDPDaR6qDMo/vSTbezzzNfW2yhaNO5bHm1aOkJxhXxAx5j7w1mvcaZaU3j7G9M5PM6g4o9m/qoquNgFyPrq78qj7Vrh+04rVtBuF9w6blL7JWX6c0uin4wVpetPS1c+DRwgU7nQ/eFVH2klEImNcLGTIlxT/rnHA0agVHtrmm/5+0SyE/SXJD/z1ayx/+t2UYvgoEHlnpNVzI/Kmz7yqj6Ag2JIHSL1wbRFSxZVIBvbtF1vVMhWD3Wbqqk9MZkj3bgin3IXjrNblDiqrFD9+5p1NvGRo7piE9KtfWH3RJ6BFY+WcDAYcqbZrPM4H2rajKQwGf9FVFSGJGZ0TltZlSuieG7ZZ0An6PDYmLqhsBfiGHl4lilTdiia0GswmIi552D11+OWsBjiRXBPtL52Vi9GsabKbSk+K8Ge4biCA41hqI0UoDYTjKD1lUkLKmpdPl41YdRIln9aVqDNWBiL/PFbpoAF54WKKYqHOaF3JRUrmW4LtkoCGgIZcvTj7NGbXu7Q/hXYR35QLcH9cOfx+uujKQrknvHFK8HJ+wGoaq0mmT/Jo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--v+QeNeXg1wIV/8Z8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2025 at 03:18:20PM +0300, Jani Nikula wrote:
> FWIW, I'd much prefer using :ref: on rst anchors (that automatically
> pick the link text from the target heading) instead of manually adding
> link texts and file references.
>=20
> i.e.
>=20
> .. _some_target:
>=20
> Heading After Some Target
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>=20
> See :ref:`some_target`.
>=20
> Will generate "See Heading After Some Target".

I did that in patch [14/14], but I had to write out explicit anchor text
considering people reading rst source. When they encounter checkpatch warni=
ng
and they'd like to learn about solution by following See: links, they shoul=
d be
able to locate the actual docs and section mentioned without leaving the
terminal. Before this series, however, they need to click the https link
provided, which leads to relevant docs in docs.kernel.org that its source is
already in Documentation/.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--v+QeNeXg1wIV/8Z8
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaLGougAKCRD2uYlJVVFO
oyLxAP95mJgSRTOQ+hTC3+7/hjakAGgQRjyWnfFgZF9dKlXeHgD/bJRCDtPLAnbQ
JLSf5TwAGdo1LgUd0wgEgetqhpMKwQI=
=82dj
-----END PGP SIGNATURE-----

--v+QeNeXg1wIV/8Z8--

