Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1E4CCAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E979A8E0011; Tue,  9 Sep 2025 22:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20786B0024; Tue,  9 Sep 2025 22:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24C58E0011; Tue,  9 Sep 2025 22:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A87AD6B0023
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:51:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 678E9C0792
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:51:57 +0000 (UTC)
X-FDA: 83871815874.12.A8D4EC5
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 707E040003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:51:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OcaNOwRa;
	spf=pass (imf04.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdhbTSK6p9ht0YngyCDiyyRtcLCfpgxS9tGDrcGiJGs=;
	b=vPm0mKGeUrgTNU3pPpm62nqXRrgMYD5PCe+aifPQ1DODD/m7/Z28go65muC7CKN02E2fQa
	xUPohz2NPHgcRLtt7l+Q/ZX/Y0nflTPfJEMoJGtYcvhqMAhzhXS0bsu5u7D/0lyimRfbFe
	BgazRj7mrTP5kjMNBCx/rSpTDl/qlaw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OcaNOwRa;
	spf=pass (imf04.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472715; a=rsa-sha256;
	cv=none;
	b=6MlB75opApHuf4xaps1u6bGHUkOOLQK6spL/3uFLmUUcw5QEiBZJQQ/EiNmeRWsN44bz3W
	5bjpZeyZDIdEigwVaHZ74WW5csppD9vaovONpDR1pV8OGKGLl27KlAFT8NpBzruxDCwxy0
	ubst6uC4CWJz2IosByoLiGjkz7BpsL0=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso5343574a12.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472714; x=1758077514; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jdhbTSK6p9ht0YngyCDiyyRtcLCfpgxS9tGDrcGiJGs=;
        b=OcaNOwRaX5tma30FCXtj5YZpBHYTtqFgSnMAXPtCDr51TVByYQogtEtQbDGzCKPhIU
         2bBpSgWkOCoJa7OQHphgdGerRGuJDkAdOEcocm2bxXqnm6l22Jyax4pMvBE4Eu628Go0
         wM0zrEq+XF8cgF+0okljNkFiW2AJ9G8FgWyhKJgCS78LeV31jgskGKzej0YMTnFrExPk
         BgjgPdc6/rpKFyXqeby8Tpw2GlRLURfMMzQm7QMEQrdfGEvY6ELfBUXzKU51R1OwX3+s
         DKTRAJBQroyQrG17uX2EOHD3IEuO6XuWItnIkhcgHchoPSH37NXFEgoOfSQ8aUNTvdmD
         4dZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472714; x=1758077514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jdhbTSK6p9ht0YngyCDiyyRtcLCfpgxS9tGDrcGiJGs=;
        b=ccpO7INjrX1h4oBeE2JofXjvwE1BZoX8rH2rjWacmY+BKJviSYOe8N777ZHXakIBAT
         nG7btC4/8s8NZLbU215J+7jWIEcGxpEdlG2kCnf6uYdS6BLWwfK5l0c6wmnjPsfLTzjB
         /SWHpVPJy8M1CGs9KcWyVYOLB0yuwcuPwIyc1YBokJTpq/AxEeuCroLn+VYaeXANw5DO
         7Jmmq23Oyxig+dVD4YasZR5d86PWdJFgmhwDVeC1zWNxj0+93HhDpWIgjqWQcR4CNP/Z
         bl2hF08zXzGF9fiCMFcdaMtPaBuxZJrBODxAwYDIsowKVubkad4cBdKTO2Rw4ACjlGc9
         miLw==
X-Forwarded-Encrypted: i=1; AJvYcCU2QRMoupeSxOgzre7wc0BWXZ9KVZbzDH3n7JYm4OEROwxpTvz/krSyg0bgjEd/hU+miKVv/gnHGg==@kvack.org
X-Gm-Message-State: AOJu0YyuJLcPS36OyHr3SXo2IvtD2Sk57wlkHsfw3IYUG0T/uv5ws9ya
	Wq5sS8WYY0kaDjABwPUwLZnxTGdYGogYS3VXPHRO88L+sF/UJBlj6ga2
X-Gm-Gg: ASbGncvcMIfIFt0DE+JhQmP4rwydkfCkGZxbCt/LqpbLJUtYTwC3PndoZunouuMlkI0
	SyU4NHsTqE18tPAeU0DTaQs5ZGufB8a1eETh2NWOGbaq5fI+hWhfMR5ihR11UMsrieUsRkdFDHD
	vRtBvaZVpvHqs1tNLkAJgDDQi++4ndJPZffJoHQ+GEyNDFYw6nmznzVLU82qQFcGcMOiHgTWQz2
	5oYGLBx08fS+oE+cVkBT73UxJgL2FRo+yRMl5/SvU7YZPTM97apgjAUtF7ks/DAzCHbxiSIEHi0
	K9AVIxV0QVUIOYJ2N91D5wPXraG58es8Y1ymv9U+pVUBCdxfEV1BCX4YAhr3wz/gOCjfDdYgXA8
	sxFekbsuimeQNlTq5+mYSka1Nyg==
X-Google-Smtp-Source: AGHT+IEB/m099LrAl5yQVt4L0Nzl0jupOns8XwrHabjqcwIBBCUNyigNNYELdZPt4mBJxRKyTxzUaA==
X-Received: by 2002:a17:902:da82:b0:24b:2b07:5f6d with SMTP id d9443c01a7336-2516d818031mr154485025ad.9.1757472714167;
        Tue, 09 Sep 2025 19:51:54 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dbb032dc6sm679647a91.0.2025.09.09.19.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 19:51:53 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id DC0B441BEAA1; Wed, 10 Sep 2025 09:43:52 +0700 (WIB)
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
	Linux Kernel Build System <linux-kbuild@vger.kernel.org>,
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
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
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
	Alexandru Ciobotaru <alcioa@amazon.com>,
	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ranganath V N <vnranganath.20@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH v2 10/13] Documentation: smb: smbdirect: Convert KSMBD docs link
Date: Wed, 10 Sep 2025 09:43:25 +0700
Message-ID: <20250910024328.17911-11-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910024328.17911-1-bagasdotme@gmail.com>
References: <20250910024328.17911-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1002; i=bagasdotme@gmail.com; h=from:subject; bh=tVZea1ikNA4Sssls4g09ZchJ08JhUaFOY8Mmt8T2Tzg=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkHnihVZXUEfpV/XXVSre/C87lNIRyCV5IjnItu7ShZU PiphvtYRykLgxgXg6yYIsukRL6m07uMRC60r3WEmcPKBDKEgYtTACZych0jw9MiYfOuPx0mkkFP UiIWTa/TFphmY/DisofsPrHQd/6Zwgx/paxTd1xaG72+5ivH8bnS+nm3e6W3try5uGL6W3UVsUu 32QA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 707E040003
X-Stat-Signature: p4ekx3s6xpzzwragjk8p75ftbze5eaos
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757472715-144184
X-HE-Meta: U2FsdGVkX19EEBiJbMPIPbJ73jlZkpzSnG/JPl5CjBBG4WjeZgjGNOg1Zz6qy/O7plsqGzPNbJThHPKeu2zFNsgg9s3lQeJOsmJLLusQcyOBcdWLXjcbh/6q5axYhiW7+CLXt06tRTxwQSG0mudLeO/beo3KDyGGlVDZ5bgXblh9QJBJ89u/fBBtmXdhubClU0bpIGukBSK5yMQba5kE0a3nm/4novgJdteratVaKq6ClGG3EZqGGX/jd3y8PnQw4CkH+25Fqz+lNsZykFzotm42rCAQK7xFcP8viF9/IekAKTC+82Mw4mDGnnQEcfTHkFE+SzaUtVoPjkaOHV4cIbaN+Jig4K3PXinCs+WnRbcmu+ww5GYiR2d5PfqBAeyi5RiBMrosrnjiKlwunPxLBxwX6QZWX/51p1NWxwTgYdf4mDbc/jE21/7DwMBeJbUqyL4QtOeg51CFW9ae6O7PKVTHY1HxassEkedehu9aq3qHetzdVvck6xc7VXgnpkC++oFaFXsXLTzx7fa+FzaUUglgaLcEMboVq6W1b7NIYxTrQMoybYYiyVeFXoANTlaOr/+wL102YBq76g9woEMdfPpDVJ9HiMJw9SYggYqU4ntd0W4w4Ug44zfgHY9D9V/vccXSh7qBAaDiAZhqth5eAxJDBvAZvGedjfvpl8DbxPtA7dMMkzg9jlFQFe18+cuJuFZhFrGoCOziooHE6y0lnWU1LllOW/Fm365YefeAE2mVLB3Mb7eI/UbN0RyhaEj9Yqv06KrixviHPy/73Dd2JSLCJWCmtu3LLwO9+Sf7kYXrgaFi1ye+NdyKyxSGo3wdNmMY16g7TI9Q1mKzb7KE5FGHKfxVRxLsKRz83pbUAnFlN5H41Br7TPz2t8aGIIVpEvokc33sEBP/dgwius++otTYdbtT3mc38cZwWj7oE4fj6ztkW10sc/tWEV9E3F2ipRyV6UgIA4DNoOrqIvi
 fNWi+JbP
 af3gPEWQtkgGi1cJqk+epE+3CuSefVnlPWhorUNX4zWzBhyZfpaEE4In1tJin1BzHOCEanX6W1GfPBv9NKjY4icHxQ4RCjdrqtUPTOGjsjK7O5o4pSooxNVgkrXHymPwhOEP+jJP0Q0KoMePsaBIWwTip4sH4e6zLKG+1M6AOijNDsD9UtRxi38BG4w0bxhKqAql5VuiCHWFpFXQ6TGz/hfySdarXFwmOssS1SnuyqUKDsByyPhE70QTKm2vf3HimJeCIkwMKiDms47NTxXzVuc1D/PN9sdSSXMhtcB8qPRruZ0EtXD8yje8Nr5oK71aMxwOGbsDYEoQBbFk9e0msWOzMI/5uZDf+fm4w4CVH23PQC0zWXULZk5p1hrpXfkiM23ru2COu6PHyPYnQ3LY8HzRGpgxBC+HkbjKlgPR124sFU13tsksm2N7/tu4gzUWTXAQ+XOyXJ0iDqEJIT6+jzz8sTgAb/qlk/8eOQU0Jw5nVGd8Bt78EoDD50yL7y41DMUMETZTseP9xVNu6J2VsDaQa4a9cAnCbrXPT9FyCkI9AVBKwBH8hGv4UFMgIg4hyF8tN4yGRj84sVghPVKhnLYQJuRUr7k90o5bjxSHtr4tRJQC09/YJY8497EJZUvLLq3yc4T0zotnV4dA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert KSMBD docs link to internal link.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/filesystems/smb/smbdirect.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/smb/smbdirect.rst b/Documentation/filesystems/smb/smbdirect.rst
index ca6927c0b2c084..6258de919511fa 100644
--- a/Documentation/filesystems/smb/smbdirect.rst
+++ b/Documentation/filesystems/smb/smbdirect.rst
@@ -76,8 +76,8 @@ Installation
 Setup and Usage
 ================
 
-- Set up and start a KSMBD server as described in the `KSMBD documentation
-  <https://www.kernel.org/doc/Documentation/filesystems/smb/ksmbd.rst>`_.
+- Set up and start a KSMBD server as described in the :doc:`KSMBD documentation
+  <ksmbd>`.
   Also add the "server multi channel support = yes" parameter to ksmbd.conf.
 
 - On the client, mount the share with `rdma` mount option to use SMB Direct
-- 
An old man doll... just what I always wanted! - Clara


