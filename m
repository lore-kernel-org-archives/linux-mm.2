Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82B73D68BD5
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 03:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3F4E6B0088; Wed, 17 Dec 2025 22:14:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBFA6B0089; Wed, 17 Dec 2025 22:14:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96AF6B008A; Wed, 17 Dec 2025 22:14:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5C3F6B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:14:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E4E8140CAD
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:14:59 +0000 (UTC)
X-FDA: 84231125118.06.07865E4
Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com [209.85.216.68])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4D082140006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:14:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F9EDrpxM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.68 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766027697; a=rsa-sha256;
	cv=none;
	b=p3EJX1qkrUxb6Ym7E9qROPRMfp1wSCYz0afEUXaFaXl3zkO4rHYpdELnboCEujFZkF++mC
	VSpgQi6jVgV1cXSvmuPEeh2DNimJSpVdOTf7hUgOHNOugxcCvgoHsoMNiezrEmdMymHOx7
	upfUJPZs1p1tVLMSpMFlJPgNV05vPag=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F9EDrpxM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.68 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766027697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aMmDsg6PeqY3yDJKla0eomYe6OESw8tJFHAPUF0WDJQ=;
	b=4IGIGjPKUb3n1dAl4+yopgBJX1XyJui4cOd0V0aP7PrlMYVCSGaUSrZBM+yq2kMysD4vlo
	TToZtVZrsCupa5tsjpVvWr/DvbU8iRuosst6MCovOF73ZSh7yb1CvzlZOfCwlw1GY5nr76
	fSaGIWSgitEHHPUcUQFQTC94HJB+498=
Received: by mail-pj1-f68.google.com with SMTP id 98e67ed59e1d1-34aa62f9e74so242008a91.1
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766027696; x=1766632496; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aMmDsg6PeqY3yDJKla0eomYe6OESw8tJFHAPUF0WDJQ=;
        b=F9EDrpxMZfoXSanttBMVyvoEVw59mxyIcoj6uDefPAqmLyD3cqZ0c48Aad6JblAiNf
         vTXwv22kbKzvcMFmz+QtKQ2H2KDS55uEU09p2+mGVMYJeCISDsenQGglOG/1cq+1W10a
         LJzpi5lrrq7X5iM4yC2Yd1BWysfS5p+5aNDpoIEEhp9HpSmPdJwcfdpHSSeCSwe1RNEi
         EC4yw1U3xh28//27Al3lQhDXN14KTLOTvMGcGVW0n5yOHnRXMtwZFa4l84q8EMRxbzPN
         EOhYLMWVaKWzo8MCKHecrYDD0sc57XfBnmaxzcxpuV8GWaqiBQEYT+VG5N1JKDM9d0jY
         nqQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766027696; x=1766632496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aMmDsg6PeqY3yDJKla0eomYe6OESw8tJFHAPUF0WDJQ=;
        b=JaedMu7oAN7CFD1DWpgW0FreTyEv11KB51kqRpG9pfls1OgVKTNE661hCLpE98e0No
         XutXRJiCPiNu5W24zhLo9Dbmv2XmTZGmyY4L98U1sSJaCkTlUjP0SmX/5xxqoW+kt/1e
         5FvljD8aKBwkDeMoWKm/m9w0eNBH0VThMi4d6JAnPYridb4VfHTbLdh08b3TWt4eXwME
         3uROPLrJ10qxi/wcK9IG/rWbJ5zZLN16DUuJ3Vb+N0/r0P69iNvSG5MUo3UKTTzlewXr
         BINA0bXClvL8E4pC4vP8X0tWPWytuSEHV98CN+uWnYJVoM3/beEWOm2o7YMp1nSyVs/e
         fsHg==
X-Forwarded-Encrypted: i=1; AJvYcCWnBmbyO5JEBTUx4Yen504Rsgu9H8Y8J3WOwFa9JchCdsNZ9NHL+hHNi11BpppJ61rvaQanWjSXJQ==@kvack.org
X-Gm-Message-State: AOJu0Yx517JRkc5Ig1HeeNIJtz4VfC5eR3kUywfGlK+uidSV9J3fWOt8
	RYhmov38JtNxNGOzb3v8cohM9/YzAXTPOscy+91QqSTGiE2ojDpK6d6v
X-Gm-Gg: AY/fxX4nHijE9p5XpidfSHydj8I7gXxGhzA3OGssXGLNTpfMiy9RQv0RWr1Z90bgrlU
	l8iOqCvH/g83EiuyQaMTM2/puqQFd/7JT34IY4edkNuOTEgdMTsoMO88Jg0NzAbEba+zY1/k0Yq
	PP0evUV3t8ydRSOQ6jPLW5GCmGPkM0RVyf9lv5zQyNRLQWMoxlyaELyvUkQVKkWAVgxr1o1Mwpz
	qq9KVtwHPe37nLnRjf8p9fpWhbe6Gh2FUfXg4vsPBx8IvgH15X6H/TAklve6XSuhqi1vzKLh57k
	sdL5MK9am6JeM4xz7NMuVEihfomsemyqN6amJfusVRBwM1mhz0WzEohuQAu/kVyY7icukvO1+G3
	53RWHevLsh3M2qQTaT3xWZNkxd4coimySpnqgMCRO0pdM5P4w2+3ojCD7K3aIoN+NzfjStnuxYm
	SoA0cWApukhoOmXfQOdM1Brg==
X-Google-Smtp-Source: AGHT+IHSjhEce/oXMOW5vM6ZF5lLLUz2/oBcTOMxDFFo21mOBhpjs2cfzbOckN+Zo7VcHVKH3Yx+8g==
X-Received: by 2002:a17:90b:2ccf:b0:340:cb18:922 with SMTP id 98e67ed59e1d1-34abd71f7e6mr19045388a91.14.1766027695922;
        Wed, 17 Dec 2025 19:14:55 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1d2d9ae134sm730773a12.1.2025.12.17.19.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 19:14:55 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 75FB1420A930; Thu, 18 Dec 2025 10:14:51 +0700 (WIB)
Date: Thu, 18 Dec 2025 10:14:51 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux AMDGPU <amd-gfx@lists.freedesktop.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Filesystems Development <linux-fsdevel@vger.kernel.org>,
	Linux Media <linux-media@vger.kernel.org>,
	linaro-mm-sig@lists.linaro.org, kasan-dev@googlegroups.com,
	Linux Virtualization <virtualization@lists.linux.dev>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Network Bridge <bridge@lists.linux.dev>,
	Linux Networking <netdev@vger.kernel.org>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>, Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Philipp Stanner <phasta@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Taimur Hassan <Syed.Hassan@amd.com>, Wayne Lin <Wayne.Lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dillon Varone <Dillon.Varone@amd.com>,
	George Shen <george.shen@amd.com>, Aric Cyr <aric.cyr@amd.com>,
	Cruise Hung <Cruise.Hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sunil Khatri <sunil.khatri@amd.com>,
	Dominik Kaszewski <dominik.kaszewski@amd.com>,
	David Hildenbrand <david@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	"Nysal Jan K.A." <nysal@linux.ibm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Alexey Skidanov <alexey.skidanov@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Vitaly Wool <vitaly.wool@konsulko.se>,
	Harry Yoo <harry.yoo@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>,
	NeilBrown <neil@brown.name>, Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>, Ivan Lipski <ivan.lipski@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>, YiPeng Chai <YiPeng.Chai@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Lyude Paul <lyude@redhat.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Roopa Prabhu <roopa@cumulusnetworks.com>,
	Mao Zhu <zhumao001@208suo.com>,
	Shaomin Deng <dengshaomin@cdjrlc.com>,
	Charles Han <hanchunchao@inspur.com>,
	Jilin Yuan <yuanjilin@cdjrlc.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	George Anthony Vernon <contact@gvernon.com>
Subject: Re: [PATCH 00/14] Assorted kernel-doc fixes
Message-ID: <aUNxq6Xk2bGzeBVO@archie.me>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
 <20251216140857.77cf0fb3@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="V23DYTy9ofvlaB8B"
Content-Disposition: inline
In-Reply-To: <20251216140857.77cf0fb3@kernel.org>
X-Rspamd-Queue-Id: 4D082140006
X-Stat-Signature: spouastxkxudyy35o9xduha5z6pn3w8z
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766027697-314764
X-HE-Meta: U2FsdGVkX192VWDRM48yD7fBfunnGj3laFW6dCv+HN2kk1SiN9n5Q3CtT9LISrVX6bXCX6dblcqL0TY3nWOFzJMG2os9773xA6d7tSg6HPclQnuKZ4a2ieiNxPHyWjTaUAR1/s4ct+QXjuBLS3xiDW/K5Zgkg+8aY4hRacjbFPf+oI5skHGupOJr1Uy8R3u33HSO2kwCNvPBegCZTUHVxqOfJCTAOdIq3dk5xTAc9SLknhvxAoATx7j15OMQhu3VTm3MBwYxRvj6PRbHfe2ZwdN+/UF+tgP7sWmJzjESRufWeCc6GHC/TULYTNaN3u04ybFfEhH/h53svyTjvQBmrcEMG6kMcGEkGbuWqgTx4h4k1oEXC54J0a98ax9Pc0Qks0vYiHQc76tGJNU+uPXkvCm5b1WaSjsLzI+UZofYKbKyNqUSUaqp4kUz46w0SKMUHY3UxpZqnfZ7iEndzilsjZuhESi2cw0MMbWu9bGHgyQip1X+paHklBUEby79qrSP7dR4DTy4IhxoDAypTbFAggkcGPSiKQhX6Nx2tW3GkcUEvdP6SxJKYGvOooEyryXYty+jdWh22JQ7orifGQH3H36Oel+iA2EgTyFo919Fx3eo7h9pUxmkuvbbBLIMYfCA4FdEdDhMzj/h3UHtekYsgmykD8904K4aMJbl9mg1EbQ3ASkWS5eZ6R6T2Ly028BOnTAGc3WXVxsMSn/h7tR1pBLDZgU9XaX+25r/SCINmoW+W/XRmznRzdfWscDyLAFDCwxfojI6ljgO9+mF49OCee4w4jg/qmTNAxGvvr1IvVzoTipeGS2QDV35mJzIwTMma5CbRNE97xDsdh3HkRL0N3A5LMWH6sXC0zaAaoWiiOGWguHtZrjoHPDa4S5+WZ0ZNdWPyhIonEcgYwm9Eo0XxvieoRragsgIjxKgmnPfTBpY9f12YIIeC2HHtcRO4vPr2suNn4t7ASrLTV3uywR
 IASPRV83
 CSzz5wEpTX6OjukUClVZr40oJM0/ZwXE6CH2/MkqUu/dlUzZlqdM07wOGsZp62ywFzoIIbmrbYw7ShFmcRPsvcjoCViSJOGxO5KEHuSR/Ml80k0IHKlYyF7ErGzp4exwQUxP6TrNvL615UXNephU34MdGZ0jPRkLvbR+ORN9NSmzMrTeFyTLgC84XPvg/0Dy27/gt6jiFXO6yMZlEnX/Y+Tt5S562w9XaTlo4cgxcxuimOoN2JKK3QC2J5eOlOJB2g1aqzhZUEP9wt/ndO2oBP6hH1EHNpYMzyvwBUJ/id86ko0LddA2pYIozZxhESzTVye7R7E80YP3/lBmnhAXw79dU9QV9PmrjcsR4MNpdprWOP9pJf46pGLD7aUiQcVMtRDTXpoC/Dks4hwoGuis7DSFeVQeHJZV1MF888yIX5CO7OE7eSopFR4RgvJUU3OyTbZ0qYxp8HWTq4tLlpRWyV7qXuKHckp90EWnTdNQgfr9qRqTMu4snlgHOyvX2Ot3rG84vucglAY/+SHJ85+pDK/u5BfC99bncjGG9vbbm6LnRkTBXiYsp5pTxoUwOpmwdnQPPyDXyjjnjM+k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--V23DYTy9ofvlaB8B
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 02:08:57PM -0800, Jakub Kicinski wrote:
> On Mon, 15 Dec 2025 18:38:48 +0700 Bagas Sanjaya wrote:
> > Here are assorted kernel-doc fixes for 6.19 cycle. As the name
> > implies, for the merging strategy, the patches can be taken by
> > respective maintainers to appropriate fixes branches (targetting
> > 6.19 of course) (e.g. for mm it will be mm-hotfixes).
>=20
> Please submit just the relevant changes directly to respective
> subsystems. Maintainers don't have time to sort patches for you.
> You should know better.

OK, thanks!

--=20
An old man doll... just what I always wanted! - Clara

--V23DYTy9ofvlaB8B
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaUNxpwAKCRD2uYlJVVFO
o1nDAP9D8xQeBKhU5vgUY1uZdEmdnOr8lzFR748Q3fszwHYA2AD+Lmk5pycZlTp2
pDdOJDlTqJohju9NNAPmvm1zT37zzwE=
=Ar/g
-----END PGP SIGNATURE-----

--V23DYTy9ofvlaB8B--

