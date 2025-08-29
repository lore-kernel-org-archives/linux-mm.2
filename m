Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E16EC8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 07:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8091E8E0001; Fri, 29 Aug 2025 03:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743348E0007; Fri, 29 Aug 2025 03:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 526E38E0001; Fri, 29 Aug 2025 03:55:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3988A8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:55:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F34D13A2A0
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:43 +0000 (UTC)
X-FDA: 83829035766.14.270A010
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id ED98C40008
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E5sWuePU;
	spf=pass (imf07.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756454141; a=rsa-sha256;
	cv=none;
	b=XFRj03BB903psL8zSDY4eT28pKS6sy8Nti8rlP9b12ATpe+A1Aazm0ULlEGN8W3ChICVBd
	R65zECb/X+tYe3I2X2sGM2IuCEnW2F+zP3pToWmLkDd1etdiLKD7DC4kXyP2bsOd/tOPXZ
	cT3vFBEUhXblKyVsJ8Kg8SAonhuLGvk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E5sWuePU;
	spf=pass (imf07.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756454141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+SUGCH8uEjWgwJ6PdsO74F0lOA4arnp0TuRWyoM63o=;
	b=4E2H1CZSAoblISoav0jGz6nZgtXXuxgCXSptRc2+sPczjgUrTzW+BPAZRoEgJnn4Kudmc5
	bm8D1Homx1Ag/NrtvGKQVRs0iTAJXZt422HNpJfa90WAyHKsb1hdMalYhhIEYy6o1T8ffe
	idqq5k2r31V3tPb6U9Co/TmaUov3ApA=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b47052620a6so2119475a12.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756454140; x=1757058940; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4+SUGCH8uEjWgwJ6PdsO74F0lOA4arnp0TuRWyoM63o=;
        b=E5sWuePUTc/DKrEz2Dlw37WSXupw99qLGY9zp7sk0pP6Mk6zKuusx7KzKDJL37JTLg
         lS7I6TlBZcBzitb8EcwcUdPKAiE/9jJVuIj76w6rLoqv61jfdDfIH6X2d+L94XflK9jA
         a5StfsGR6lZ2v9f0UYq0id5knryoMAm+E0KssYYvoypDiqCQ9OdVym2rBFgG0KTMkiM1
         qza4apy57kUN5xlW59lbJwoQXMyOrrG0MNII1V2KqmC5EBuwfPraw8pMxl9zZo2bd4Qv
         wF3eThoG09J6ZGZDiKU4o9q09U9BYeCnkzCe6QdjX/e5g+xG8MRImO9sdT5FKApnRIB4
         5J9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756454140; x=1757058940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4+SUGCH8uEjWgwJ6PdsO74F0lOA4arnp0TuRWyoM63o=;
        b=APSRx3uhkWXjTdWVVcITsRSTVZgW4ImTTJffBq1wYHK+GuThZCESJw1ae7AoA6MNgM
         Vfpm9LuplY1q+v4ai5fusKzm/o0vkjMC76j/LohMMI+Uk5hzBoHbqqurNyysBWMvoRHA
         caCLYyykEyDYdRltFeFk8RSPPQhjBBqHDL7ipRymCh5zU58kLacZj5hhQQ7bDh6T/Fhk
         J+JwClTw4w+1+DhxzfcfhcywLddu0m1Z4WAKRMpmx4q8d0peJZQfT4p97PNEYq4Cw8nQ
         iTWyrkEg+SBIEBzodQ/x4qSgA7A6gD3qRQZz48mz9wKfm/j3+CmNbb6KFh9lDhg/GgM/
         f4ew==
X-Forwarded-Encrypted: i=1; AJvYcCV6SbN1iYT9Y6nDJugBad5uOQ49slarUDMk3G9COJcNZRiPItvS33/1K/1/Tg6jvpwdK7dD/kQY5Q==@kvack.org
X-Gm-Message-State: AOJu0Yy2Ugkt4RAL5vZWU900r3pzlNFbLWXtLAjg454mVg4OaOLVJDWz
	wAgCvM1OXu3noaBT4IU+BhluR1JxMzMoPPt+cO5PPqAMYWbyxMS+Gh8X
X-Gm-Gg: ASbGncvS8i6WayGI5o6XwHmqappwu6OudiK9SJrIzP4YP38oo81ZxymGGvxfQdKc30p
	7jDuI7WSPeXRS1+rl2lmZzwznzCKXOO15YJSxDMheysM9vzZk34/FvlEGmx8TFshzmkY5zuzUgb
	L5iRQeH5hnoVnxo+67OPBa13/coPxctPOLNr8rlm8zzPZz5c/1ma0+cdRJ/oG+yL24EaLLc54rF
	K1OImNYfOhP5QkRZHV0Oqmu6azfr42vEVwCnImItMVTJ3OPZWCL7kJdDgV0+08T88jBH6wz4BCR
	NnZLrl1UAMNtWFwLdWp52++KpGsNQELgeJRN+zdTHYbHJJpX8eD7e8NGE9Sl8idlN//LsLlLTbq
	ndK1LkCaxIKrXit9UXqi4sfvtkKtjLtrU+cA3
X-Google-Smtp-Source: AGHT+IEUIbmp5KZdMZPn0c0CGQYstQ2DxLDepEvVflAGtJJLsQl7+Hp4DCT56TGBU1NzXfP4o4RcNw==
X-Received: by 2002:a17:902:d510:b0:249:11cc:2afc with SMTP id d9443c01a7336-24911cc303bmr18192475ad.7.1756454139741;
        Fri, 29 Aug 2025 00:55:39 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24903704379sm17029615ad.29.2025.08.29.00.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 00:55:37 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 5F71C44808E5; Fri, 29 Aug 2025 14:55:27 +0700 (WIB)
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
Subject: [PATCH 04/14] Documentation: amd-pstate: Use internal link to kselftest
Date: Fri, 29 Aug 2025 14:55:14 +0700
Message-ID: <20250829075524.45635-5-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829075524.45635-1-bagasdotme@gmail.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=889; i=bagasdotme@gmail.com; h=from:subject; bh=YCjSy3OR+PtbNsOx3d7dblyTwJjnDEtFBwBCle5X25g=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkbY14qPYlapHXxetwsqb0JS9jb7/0/73aj6M+zsn/7f 7uJBK+t7ihlYRDjYpAVU2SZlMjXdHqXkciF9rWOMHNYmUCGMHBxCsBEJPkZ/hloBmcs7pqXLvRo 3uW3yzpsL08refrBOejE1FfXjopF7nZk+B9pJzZFXlK9u2zWB3XR7Keu63hWz99heLTAzXSF0Y1 5YmwA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ED98C40008
X-Stat-Signature: 4wta955qeqejxjtcaxhfed1o3bkn8auo
X-Rspam-User: 
X-HE-Tag: 1756454140-220023
X-HE-Meta: U2FsdGVkX1/zeMYi8VGlz3QgILRslc6bX5pzgWEIUCIFkwIlrs4a8gQB93SnWx+5oXhhPkDJuVVBkd2f6YlzHBibFSKHIbSAKZ/qArqkJ3Vtaw+EX6VQEjaVsciMsT3h3zUSa/iBKr8Jv9uoPY3fcNv60pampvrUMkvndEdmpS4GoJkutTz5gvHO5KiTG4vasS7bUU2x6wh0co+a2ETXfNOQjODcrDk/cuXoy5BcGV0mBjodKi2n03f283Tk2WzWbyi0VOU3ZdM/wdEYLOBaTFHL014RddSqdGTwaTYRDcjgE6HvaNLqTCvRjCHrzHaadH158eONcUBYvk+bbPlIab9vDEyTpp3WBt6Pqhw4jdVB0rDkmXcEXWhEeZV4+x2QYB5rEAAJYCJRxXtd+og+WJNqSyEgn9ENUCBSwMJ5EwK0i7sc1cC55SKdp8AJyv4bhaB71zRjku2dFcLUluOUw1I+g9304QWOV+9ZE3kk4M/IhQuTSoJSJFUOpWS3s69De5LxBgXtHsrWLMuIZ7AhwdC6AYcjxiN9m+aQ9mdMFI/AMOCIDM/hEytRkGWDFnT7KY0RX62p2lOeW0nigV3+PzXxJsXLMRbddJEeK9TxExyOILAsk012cvvO4+xyP5J2VjmOhWsgmGhMT85wyzHhufktPDAmTvgxrl3KeKV/qpFD+FSPaNy4Vi4JgI0f7XG/Yh1NOXqugnUmdWsqgTFQ978Qeh0JvLeu1OAa5Uzy1yxwAClXlQAPHdkOTgmWwiwmlX5vQXmeXAnr8TsNgl2p2LOPXFzNVIJP5JSuHgn5CdvGcG4bBpuICzjo5KrNcmyBkuG5SKbOpwYTZrpzFZGCLSnNbqiKj/9/SqVlIyLk02wgK2wK2KXLFIz76gUyT6oP6rOLq5GPhsYyqqq+UmXAcf2cQ9yN9bcJxSP/9px5TpXateuf2pUVyRAOR6lwJMpKVu7pH1D3Vy2hfVRBh8A
 mua0MdFy
 sAgpz5XD5JHYoH4OLNg3Plu2cs4z7xLLHgG4tmMzqDY46Y5hksQTS3fQsi49d2IDemsu9PqyTEnz23BUCwpPSIGmp8bq4HI5tWn847T1Tyq0cKFArV7uBYrAH4XsA9NRoKhE5TJgvdmYq3vNMU0P5wU5FTEkHNYFpLCcIpxPcrgqiEXt3xh+GtFAvEL8fn9qeaC5iDFNT9FKRWX6Vf8Oc3r/Ggc44Evjlh0/yoE6VvjmMpQCp159T2mj29asbmFdh8qGViDvTKDIXh9Qi9WNaORttA9QTIKwLbV7xq2wy13obNOc0rp/fsxZhBfgWY50xeTbA2xQUdBkbs3EEyNdJPv3NMtY7jx5YZU07ebHSFIqPxVvK3xNfVu9A8aZxugGRlVTtuMKF9FKJKU5RjSHiXj+W0J2GgX7qV71rpX2G7mZCl/RgdeV53jhlwBk1PQUTLl7+zKavIt/DlPjp4CWCbM4e3F7yMJtjNFSKthOX/GbEgWkJ/5r0RR3vJKEG5DKVDIGHdhVNe5LTOkI95geF6isoRsmVGkdDbMY/vbBwP3omt9Ih+uVPmqMwv5stD47kLV+wN49xUFuAp1c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert kselftest docs link to internal cross-reference.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/pm/amd-pstate.rst | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/pm/amd-pstate.rst b/Documentation/admin-guide/pm/amd-pstate.rst
index e1771f2225d5f0..37082f2493a7c1 100644
--- a/Documentation/admin-guide/pm/amd-pstate.rst
+++ b/Documentation/admin-guide/pm/amd-pstate.rst
@@ -798,5 +798,4 @@ Reference
 .. [3] Processor Programming Reference (PPR) for AMD Family 19h Model 51h, Revision A1 Processors
        https://www.amd.com/system/files/TechDocs/56569-A1-PUB.zip
 
-.. [4] Linux Kernel Selftests,
-       https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html
+.. [4] Documentation/dev-tools/kselftest.rst
-- 
An old man doll... just what I always wanted! - Clara


