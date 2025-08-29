Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E22EDCA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 08:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370788E0007; Fri, 29 Aug 2025 04:29:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347D68E0001; Fri, 29 Aug 2025 04:29:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20FB08E0007; Fri, 29 Aug 2025 04:29:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1298E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:29:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 92EB11DD7F1
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:29:30 +0000 (UTC)
X-FDA: 83829120900.03.FD1767E
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id A0E104000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:29:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JzpPMuQd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756456168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdhbTSK6p9ht0YngyCDiyyRtcLCfpgxS9tGDrcGiJGs=;
	b=wjMZTOtvlwBzLk4dwE/8RHiM5ormE38mn3KFnBjH6zdfsStc/u8bPDDWZxIkcvfJgYIdoj
	F1Ep2iMNI3hngPye98ogA0Qryr4xvJM5js8VxDruLNx9LURl4hnUDXOc8Fdi5kX2sXtC0t
	9z69tx0yeoZDHzmJpCK65SouGWIYpNY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JzpPMuQd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756456168; a=rsa-sha256;
	cv=none;
	b=JPyuLC2EvQ9nWtXVDf67N/GeL8ZwZrxWlePVQs83y/h3AcxNuGyzgy4xJ8NiJm9k2ao7SO
	WzuyNvQy9jj2sa6d6777xqptuDx4H8N+RML1oYfZoIi8KflqPYYweOZ9ei0G0jeu2h8Dnw
	0IIwDozavG0skSn/kLRGeHZDeZM2FAs=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-70dfd18a27fso10011066d6.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756456168; x=1757060968; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jdhbTSK6p9ht0YngyCDiyyRtcLCfpgxS9tGDrcGiJGs=;
        b=JzpPMuQdFgkOG3R5QPfXBjGsgyO0gRkrUjihNpdDXCtTmSpsuzDPbLWbrnOJf4Opsc
         6EKLiJBDvZLeysBBUZHsOOTm/2a5rF8mV6PpU06pHVFyLxkKoLHWUFhypmTbwa7rDWcv
         eG2FTRNB3Xkwnf0O/GBuHG0hRiRwd9tr5psjen1tfhVsxpv2PoxQtYmUQb5nh1ar2/CK
         7pvLr/WLfIPn5m3bMuknSDP7uGYaCJgzGdfe8+HQeI+PjfJRugWm7I2G3HmRG2ZG+iUV
         Xcxn/1s4YCuvahUvy+Vqd5SdYGWQEdztvkAmygEllbKmAb8AQ963xU2hc9zGDpSx9j/O
         rb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756456168; x=1757060968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jdhbTSK6p9ht0YngyCDiyyRtcLCfpgxS9tGDrcGiJGs=;
        b=jfi5vksqBOMCI1dYFxYp0EYZDTvULwx6wcVGmzsc1oUIjED6PjWeGw1h3yFz20+rnN
         b9Lh+OKmb3NfnXKzTWAPoulxqpDrLtqsGyTxxA6+CrxylOEp4zTIcf6xogIYPTj+O293
         jKGbd7rtm/bhl/bryOyJuSBBqmsiCjhoLxLgJc2bWskaKED9d2f7y7ATvrSPIk/2gKa6
         KCb/M0mNBYXbf2+dMLKdRLxhTVjdnFIRGCiqtHnour8aCykqA7TzR58ks/HGGQRwhsFj
         qnoEBqFPHguVKuCFTdULvxKVHhQn59VsQbE9pKd+yxpUKipo1Wngdh96wBVOs4BIMFj6
         k/1g==
X-Forwarded-Encrypted: i=1; AJvYcCV/N7j8/Jqn+QQKMDo0rhJL56o0MwpzksE9uXyuJ3Mn88QBDO79TjtOGC48Nl9yB/DBnZjIxD2POA==@kvack.org
X-Gm-Message-State: AOJu0Yw4ApMJea6hnpqVANIlDFOCSYZaP1VHRTpYYGWbCNQGVd4dlCAl
	CUPSzpKHP7Qur/j2tf6ivaXJNpMd4eY1tB7q1iwCsClOU3wPIByllwaQLEB6U6Ar5NU=
X-Gm-Gg: ASbGnct/koNNjTNVrA1WTg9WQnTQTlp060AiUnoSc4RnKL+UCXxxuDW9m3Tr5pfnKYy
	MLK/XEUaWcYH5OYnBnkAfYEoZFw+MnCQe4SRRFvxbfYMIpl/E7Oawnlve63Rmrq2KlwFubpdsJA
	C2Zi8i4Ji/w8De2b5NIjU9yeD7+GxOEUHnjL0PPCNO6h/Pb8eYqXtQB6sS1Da5XwVUaq5PTRT8v
	W+Jgp+/S+FPlzCZZoid53klDAGztG7Mxc//bvOk+I8qqUYYdAWjjn+jGK93Humo/muYmBj9c9vU
	DF7Qp5Q3LI7n1qNq5nNS4gIHdoV2mPfc9SqCerasT6i80BxMx0Lup4sGtkesK9TtAQaS0CYZ1Yo
	nd8CBu6kPCLOYxcZBTN9D16tQFQ==
X-Google-Smtp-Source: AGHT+IE+D5SeDqchp/24MDHXx5CQWTZci+ASgYtlboM+vs82gW00FOC1mk2B4v9sodvZwpxdBzPuFw==
X-Received: by 2002:a17:90b:3a87:b0:327:c9c1:4f2a with SMTP id 98e67ed59e1d1-327c9c1642bmr4975594a91.27.1756454576161;
        Fri, 29 Aug 2025 01:02:56 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327b01e90e5sm2191228a91.1.2025.08.29.01.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 01:02:55 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id E8F6644809A5; Fri, 29 Aug 2025 14:55:28 +0700 (WIB)
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
Subject: [PATCH 10/14] Documentation: smb: smbdirect: Convert KSMBD docs link
Date: Fri, 29 Aug 2025 14:55:20 +0700
Message-ID: <20250829075524.45635-11-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829075524.45635-1-bagasdotme@gmail.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1002; i=bagasdotme@gmail.com; h=from:subject; bh=tVZea1ikNA4Sssls4g09ZchJ08JhUaFOY8Mmt8T2Tzg=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkbY15VZXUEfpV/XXVSre/C87lNIRyCV5IjnItu7ShZU PiphvtYRykLgxgXg6yYIsukRL6m07uMRC60r3WEmcPKBDKEgYtTACbSt4OR4WixGWdF367Ci0f0 5/VHVx3YxHrvMF/c3LtfDf1enBJSvMrwV9hALHj9kQNbWF8l9WcGsahNXW7scuzOjYlmr0LWbpu 3gQUA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A0E104000C
X-Stat-Signature: a3i6ymt11rtbaomsr149pqafxi66m3p1
X-Rspam-User: 
X-HE-Tag: 1756456168-742547
X-HE-Meta: U2FsdGVkX19jxtqFL+xGrCsaEo3qLnRAx+7JJCRaMgECQhprSwoYS4U7cR3wvZ/I/6yDKB1HbZhKyFMZWtlFZhhk1Yk/+sdIUcI6thaHJ6n89zBI4wF6JgvJphdM4EDZGROzj6sUkFZp2VenQ2zI4oubha9Tixn97CwsImMYqxE1+4chiotX485SZ1Y5ZO8hx1cNNIOAgm4VsLcKzfaD7z492kWBYAs0S24JTFTbA93LJepNwYB1BsLrOhHzHAcULnuH3mdtd74Tcalq9sL+l1dp0qxGpnwiEuzKo7QJ6IXyh3r1i2Cc+8FQ95/ReStAYZa2KYw4vTqv2Gw17BLLJt2hm3EATQfUM1TSeJEVUEiEpPPi1y/SKoOLIMYN+ZbgmJW4hY4Pd7+mOlKYDatTkdeDlJc3RJa+GK1DZ44SGoEdAF4jXRby+8QNHVkaSlB545lSkLrpWHXm6a5prYlhG0bRgu7kCpu74u6kMCOEN6kjxEOxswPQ5mX2jCzL1gR8KkFkrDkVChgEvB3pXQGbNwv1IHEFgYKsWDh8dseMJogqJCjRczaunlXRtV8oMgHkNL8BL+cnFTjWioBMPacCRItL2M/aKPDZMQXN05N9YDG0R7aWKjtHB3znlc8uV+HurriVJ4mC4fxFTQK4V6Ix76J2lYI+4vyB44fX9CHlts9YUbGZwjC45AxVLyuPzVIMPYD69owTHDgUJgQf+4ZlB51UogGlaEafKraD34wNMPDG0HpszbdG92G9K3NtwHzq4owG6tDgz2FjO/CPW4rVW+sElOY/cP6Sz8KUvivfX+O5FTIvytfqaOxdTbHuAItzGx1jO7WyK+P9oRga+A+bNzs9yEC8/qHYLTBMqqobl3ndPTxNPzT/2W20OyEurLsF5rYS4ImoIZIWjAUOMw2+HwRjM40SxdjiJuSU8fc5FGcKvxFGr120j2PGUthZncz8dPBJGT11sdKxax6N4P0
 q4561EK1
 Rnok+sq1joIDjBlyNQzACu00TaYH3HiLQGNj0pypiGt4l+0tdaeglqEllQsbhAKH7YmD1PkvRyOo3RtvZSV0Y+do16vYh+kdh4WSP9mGWQDjBvyLO0ffs2fFP/SU9/V5vkg64/fejv78NuMWueFsyFj5BRBWmgZhoZH85uVJwS4FvV4ZO6tHiL2GxZv9AA/NJu8OSJLVDlHGwg2W0naovJVdEzfN/YXhVHjkO9TgWYEJGDrqYaxQ7le9HmcGKlptBX7vsrDYW5TnOKtBaY17PhYOo6qfLvVdPomtlPe0je0dKzUy+n4sxLl5pxqwhdlAtLghYGxQvAwxYvpo9I1IvnVBAYGVNngnDVSXNnIvglcqcaCc/FfXlpekoyLhoMgU310d5dLF13XtK75ip35k3XssYDvx9m2z/efDe5DSUvywWqPhLhCMQaxRRbh/uIUnuaM19N5tQSpozG2zgkBHSJLMqAyV+DQfZHyS4MBpIF8KOUJZUYeJSDiTsE2xsvF6pFKIrHU9yjez3m2g=
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


