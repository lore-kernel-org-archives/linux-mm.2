Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72A7ECA0FFD
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 07:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEAAE8E000A; Fri, 29 Aug 2025 03:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9C3E8E0007; Fri, 29 Aug 2025 03:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6C68E000A; Fri, 29 Aug 2025 03:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 95A688E0007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:55:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41A25BA38D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:49 +0000 (UTC)
X-FDA: 83829036018.05.A02AFDF
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3677A4000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T31/th1l";
	spf=pass (imf11.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756454147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fK0hEDM5Yyao3a7xqBzpr49p9H5HB+om5vfXDIKLdeg=;
	b=mEj9QddX/sxnkNn7z47wX4L1GxeIJFmUkXgclBtufRnsI2oZHdzdFYPxtJv/2sLwk9UoCg
	Ym0bKQaAZYTEfxoQ4RLaiSFlQ8C8T+kswqS9VchvHfK3jEmuL8RyFglLXQ6ab7o0XDrv7p
	tVuRaUstRltBDfHMg8vkERPy/wu5B/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756454147; a=rsa-sha256;
	cv=none;
	b=VVA0pk0oYcpoh6UrrGY2mGMFRazQTJ2H1v9mmH3KtPz6cy6scocjm7Nr4Kw7KSI70Cz8nD
	S2KV/kq2Ev3XYrxuiH5+auzw37iT+rCPvRhUp5dwgfJtGSvFv+oOMiSp2gdP+ottTH/e3p
	gUDaXfhzlKf72Ph2bDZFEzK+Xkq0kzU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T31/th1l";
	spf=pass (imf11.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-248cb0b37dfso17378725ad.3
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756454146; x=1757058946; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fK0hEDM5Yyao3a7xqBzpr49p9H5HB+om5vfXDIKLdeg=;
        b=T31/th1lb4heJQpGxuxU5apq+YnMKXYi55l30MAMLORGcqcvpsbiuamOmI7nNmZ38+
         o3L1HP7MLywLcS2rMM1SCGDi6pzk1Ca07/r160XSaMaWDD8uxuDpArW7ogwUg3nXkSKF
         BgR/Al/K+wR5SkIZiFsJnWP9qLYRGng2gLGF/Q5ni8WstX9aE0OvQwyDPLh32k4GfjRS
         rg088g5BjAX5q5h4jLHmvefkdSEHlrYWCeTI/7Vy5M/f/jZRoytajBXvC2dSRuEn+pCf
         UT9tTLvKK0RRWSN9TiXdGqg/oMZ/kdc3yhbQsg2PY5G/n1R4EgPAuv3O/ArWSvS24or0
         Q3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756454146; x=1757058946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fK0hEDM5Yyao3a7xqBzpr49p9H5HB+om5vfXDIKLdeg=;
        b=fZ8SSdvosibplt8rkri5OPPIBtALJrBPg1ZHSuAQz3lIhWL4UD43rrWdbODJYUHI3w
         SFnPyTx2C+AUxvD7r/yVZaPSEPRhlDpwdVs2+fGZW2vbWkKPo3QyanDaUVOvxkKXsj+0
         viMv0ugfqHPNk+GugcvqUPR8cvXwALyCUMWo6ZF7DpYUmZmJkYcE/hgN7vGetGmqRdTB
         mnDTyB8z/jwN1Oy1sgq8LV9eGE+Uqow6GqfszEgKCgrR7buNsAvR8G2U9W24ZeNYznpB
         xVdbKh3QmXd43jdGai7h5cpkc8/Sztp4L40kJNbD1EHbj/MzqIQZZrV37HFgac0mGOu5
         oRow==
X-Forwarded-Encrypted: i=1; AJvYcCVv1gBiGTMmZdpDXpvadHka66acWiyPueFRuX8lr+JZ17xqT31xA4jhlnGArhnLNoTcDdQj+bgq1A==@kvack.org
X-Gm-Message-State: AOJu0YxvRo4gUiVryR3VCWWVgs/bIzpbAj0bPzDt8aBHSYRwtQq4yvEZ
	HXLPFhoa/5qIlS7SkNbs0u7eRibrqaZBnCtI0milW4nQnn6xjyk2+KPY
X-Gm-Gg: ASbGnctZ+zlFMnZv50xh/T7VZz89w2S7iHE2OJxKWKU37KaPYtw6GGo9PKDjLHxeoW7
	1GirRfdgcXz0u8O6Uy+n+AhJ6kA/ztEzVJKfn7Q8gU+sOI3cL8PwdtsAKvZdvVZ7q6wPwckgIyD
	Egpgeh0m9hGWm2CyJOjCKJM2Vl6FkzoxJTaEy1F8PfdEc7QXyxVLATfbpy89mNGXVqXKUOhXBC3
	3ZYlPmqae56xuO7l7PrVVig7IaaDtRVhJ5GXiaT56s99xjHoqM3S3LRQ8oOkiuAU5Uxf4lgDJd8
	4gqyqHpluQhMROlQcPhZJAeFmb+iQTCbRpZ5J42UzoNXZcIBr6QQds29Ge8krWtwjJobrGEkeaa
	qtVWQLlUFOm/IirkWmKxeqBvz4ITIdJcvfVeY
X-Google-Smtp-Source: AGHT+IHJbtOvLK7smFZ5Taldvs91dQKYlT3bJQAsV4fZ4iEcDvRKpIMHMCPIqq2aQ2G3ehFn7aA64Q==
X-Received: by 2002:a17:902:cf08:b0:248:a4e2:e6d6 with SMTP id d9443c01a7336-248a4f2333bmr133286365ad.39.1756454145980;
        Fri, 29 Aug 2025 00:55:45 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24905da4784sm16792615ad.90.2025.08.29.00.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 00:55:43 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id C98394480991; Fri, 29 Aug 2025 14:55:28 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Huang Rui <ray.huang@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	Jens Axboe <axboe@kernel.dk>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
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
	Eric Biggers <ebiggers@kernel.org>,
	tytso@mit.edu,
	Richard Weinberger <richard@nod.at>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Waiman Long <longman@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shay Agroskin <shayagr@amazon.com>,
	Arthur Kiyanovski <akiyano@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Saeed Bishara <saeedb@amazon.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Alexandru Ciobotaru <alcioa@amazon.com>,
	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steve French <stfrench@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 09/14] Documentation: filesystems: Fix stale reference to device-mapper docs
Date: Fri, 29 Aug 2025 14:55:19 +0700
Message-ID: <20250829075524.45635-10-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829075524.45635-1-bagasdotme@gmail.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2828; i=bagasdotme@gmail.com; h=from:subject; bh=Ip9RCWVx3N2eFboDnh1dVntKjUKs5RT6sbpEBdmz23c=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkbY16ybj++M2M+e9AK28XZP75VaZfxL/rvM//ttckLa 3oE7/o/6yhlYRDjYpAVU2SZlMjXdHqXkciF9rWOMHNYmUCGMHBxCsBEPq1l+Ke0Kqr32Tmn3/wy 503l2Fb8+Tb1i0vpkb/b//3YUvkmUo6bkeGv6MSGx38SK429ymz0txt6/t/hdS/prR+npRZPk6W qGg8A
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3677A4000C
X-Stat-Signature: jma3z1nqai7pedcwutm6sxhsp11zzj3u
X-HE-Tag: 1756454147-799828
X-HE-Meta: U2FsdGVkX185I+bqq8O/ZS8j/Ix1OqjYYo46xJajj+GdzDdUjd55lQmuq9s5Uupevr2/aqdUxvDnDLUVDDCUOU57jMTkJISk7g3H8PUrUxD7UKYUaS3zH+FA+SeXiTXvsmBodbtTsejGxGXKExRnB7zbQ2CiBS/a2JrA2ShoDjLvk1dGg1De66Eqxcai5qoUVYGY+zBod2kflOF6mxQJp6FL89IPyKMFzbfrg/MawTU5w1kM3w6p57QVratB6IawEMd3aNh8Z2DPr7sYZNmWMCAQMi1ZTO5oOZngrJ+qhrcT9vYoaqL+P7qVZFUMgwiSbqbd5DTV9o7wXyfM8dg3MqZCfarx4y1061vmHxYv+8HwrLwrKEPbQTUyamElK+pDEN30pIczfKaWliBqiEdLe/nO55/72BS5RM7eBO9R/Eb9MWDMwhJFpsL4WEgMTemlVrz+Tka4f0c5m5nSpP573gf2/rdE+dKiIXT3rZrITyfQzQCn/WnvWOHUCQF9+sDfODrRWJBl8FwuX5qiFPSvVnksr2b2q5oHFoGD+9k/b8FI9K8dYwpwLrv4e9ovfVJnlGjstJmRIwrq1tDfqsngT5nmuzTwvY2d8eTVXcpLrgaMf48zJVpuhHEMsRB+syuqa1JRpqW0UYSF2PNcelRXK67i5wcip/hWm3WQ9nosbuATesA42smB4jsquJiDVRBvBJBQ/ggLiJxWMMcEJMbPab8X7R05i9H8u7OWWnkznmwUDcGvrrzhPMkBhZ4AvAbc+TAP+zQlzIzbOSyn0a6Tw3+cG7obwTfnetlofF774WaVDmRW3OTT6eneFk/VRGQs67zvV+qheoURJbnX/IRt0q68D7OwHpiW/02jSXySYYGQ6HMCQ9nFNoPx+fhjB7EJv5ZckOGSpXu3BHpTEaVwZeCSnjD2R9ZptsBkAmqp22YzOOoWD579vH4r4l2bqzmzP1AH0dAKkhc6oa1x9qq
 f92hKdKz
 XpRtK85SsS7BbKgpXTTnjaWXqDHlx7Sw8wYljLrKBgviQaGi8+/y2QWBfds/WYK6EYsGRf1Vb4/V9nlJiPBa0plLxKYAXb+h+osjinJH9eButNq+EV0rUDmZo/BBUOKU6PytvpP1ScfITFiBpLuMiomSoy1eXPJePDCUMDeP4mdUnHqb6qI73/RqJIwO150VFQtOIm8mk7l4spjKk9todPQcr33k0rg16hUn8HpC2Gs4g+fsKCn/4YDlRGIuyDnGOOpYCwq13TFHwxbxkQ5L/YOLrKm7gZHsOdYV6XGcy6S7COba5iYONVlCg/xq2rCwLCgox+9Ps6bjlG+d2EY5Vg6Oaks7op94SiPefwhAetThN7cZ2NyydG+vkswGWex8LG4lWSkX5YnhyQMFnqeF4VS+6UO0B5tW8+TeTmJfBtCXNGzrDePy9F6ceE8Yl5aAKybGY9pkpfVSbSDYVKj+MJ1XqOqJU4hWkv61b7LtJAX+FYZ0toMx/TJKXAWTWuZBbNunCO61sPpGHCFCkzMv73bZlJ69J4/OPlAN49IoNTa53BGzGiqD5Iw5iZQaCSeoflk/i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 6cf2a73cb2bc42 ("docs: device-mapper: move it to the admin-guide")
moves device mapper docs to Documentation/admin-guide, but left
references (which happen to be external ones) behind, hence 404 when
clicking them.

Fix the references while also converting them to internal ones.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/filesystems/fsverity.rst             | 11 +++++------
 Documentation/filesystems/ubifs-authentication.rst |  4 ++--
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 412cf11e329852..54378a3926de7b 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -15,12 +15,11 @@ of read-only files.  Currently, it is supported by the ext4, f2fs, and
 btrfs filesystems.  Like fscrypt, not too much filesystem-specific
 code is needed to support fs-verity.
 
-fs-verity is similar to `dm-verity
-<https://www.kernel.org/doc/Documentation/admin-guide/device-mapper/verity.rst>`_
-but works on files rather than block devices.  On regular files on
-filesystems supporting fs-verity, userspace can execute an ioctl that
-causes the filesystem to build a Merkle tree for the file and persist
-it to a filesystem-specific location associated with the file.
+fs-verity is similar to :doc:`dm-verity
+</admin-guide/device-mapper/verity>` but works on files rather than block
+devices.  On regular files on filesystems supporting fs-verity, userspace can
+execute an ioctl that causes the filesystem to build a Merkle tree for the file
+and persist it to a filesystem-specific location associated with the file.
 
 After this, the file is made readonly, and all reads from the file are
 automatically verified against the file's Merkle tree.  Reads of any
diff --git a/Documentation/filesystems/ubifs-authentication.rst b/Documentation/filesystems/ubifs-authentication.rst
index 106bb9c056f611..9fcad59820915d 100644
--- a/Documentation/filesystems/ubifs-authentication.rst
+++ b/Documentation/filesystems/ubifs-authentication.rst
@@ -439,9 +439,9 @@ References
 
 [DMC-CBC-ATTACK]     https://www.jakoblell.com/blog/2013/12/22/practical-malleability-attack-against-cbc-encrypted-luks-partitions/
 
-[DM-INTEGRITY]       https://www.kernel.org/doc/Documentation/device-mapper/dm-integrity.rst
+[DM-INTEGRITY]       Documentation/admin-guide/device-mapper/dm-integrity.rst
 
-[DM-VERITY]          https://www.kernel.org/doc/Documentation/device-mapper/verity.rst
+[DM-VERITY]          Documentation/admin-guide/device-mapper/verity.rst
 
 [FSCRYPT-POLICY2]    https://lore.kernel.org/r/20171023214058.128121-1-ebiggers3@gmail.com/
 
-- 
An old man doll... just what I always wanted! - Clara


