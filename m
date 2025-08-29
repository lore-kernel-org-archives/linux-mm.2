Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D94C8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 08:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1198E0009; Fri, 29 Aug 2025 04:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 878958E0001; Fri, 29 Aug 2025 04:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7683A8E0009; Fri, 29 Aug 2025 04:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 64C2C8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:30:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1107A13A43C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:30:11 +0000 (UTC)
X-FDA: 83829122622.28.6E401BE
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1643E40014
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:30:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KSO30War;
	spf=pass (imf11.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756456209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ji3KkW3qUsiM430Q8CaZBzXxSVywrfxa2oAywWyFSjA=;
	b=6ic+DhcVGpewVTFM377Od5ugTw5bM9gdiSceYobnrUL0v8FBWu/lg91CZj4vwckWDshzpY
	LX3Z6ceCV9LaIEvjTsAnqo2ozCZMqjudTyq+yt0RqgKP1l63ysZb0V8gv3j5c1qQjOVs+1
	SuW+HuGl52IDmP/jFES4jE4Xbs3pe74=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KSO30War;
	spf=pass (imf11.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756456209; a=rsa-sha256;
	cv=none;
	b=IEL13vzL10x0qdHIeJGsGf+PApLkzpf/a3qCBF+73uuAw14KyQRHB6xLUXRccivMUishW0
	00Q5dOE7z/3qDxge4S/xlQKFpM4q4cmnlXW2yWbH+H+xjJVShelhWP0Bar2+ZooGI+lWVX
	0YNY8UaERz7WbUkvxiIhVIVAASovxY0=
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-52177c7ec94so550292137.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756456208; x=1757061008; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ji3KkW3qUsiM430Q8CaZBzXxSVywrfxa2oAywWyFSjA=;
        b=KSO30WarFU6mDnP5IvV2QJoEob7f9h89OiSp5nOoBWt3odM0cWGAH9MdQv/Y2up3AB
         RjTMfp252QtDOIyaH+azlMG70J2rBX27xrUzuZfltTdoaVz35De1LOxZbVZ5n83Xs9uv
         nDxbnpYxWWIaIKjYCWUJ1r2yfH+3YJ7SfkNpZoq3CTb+sN0NB1SWPvnLddCh/SSCbFDI
         aERZ+qIXQAl8+J/bNczP7O9Q9a84QBE+JK5UOTF16EYdjV10hQpo3cn7C3WiJx3MCKL0
         jQHMdo4AVhpWoujqTCFBhc4G3DEAVTKBsD47UQe6MeC1Nt+RzSQa6Zz+OZcu1pFYM5/W
         EdHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756456208; x=1757061008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ji3KkW3qUsiM430Q8CaZBzXxSVywrfxa2oAywWyFSjA=;
        b=d0W0B1Z/Op9/1KmQqNDAXh4lOMC6C0RYoYfw3J0oGUdqOkv12mXxCV33UENadT45Vt
         al7iprdP12uvCcObL2+xWudGIzE/xL53muZRDXSt5zjkFgbSDLUpw0Ld9ThZiH1XXeTK
         anxh10+9zl6ADVowD7H7q/DAM9SiY6w0IikE//FWkR7GK4zAXjRrXv303rdwaZpag/rZ
         0yemhlr6uqS6bpNCnE51KQ69DeB0KIH9UTVYHrlu2Pk+JSQ2u67myzBzqLOlFU2NSr1s
         fyQKZaEs8FUKdsc87cGpFSKb4H0vkwGEXz29RL2+Ut99Ppxr05RA+kdVH1wnVZtL8f6A
         l/MA==
X-Forwarded-Encrypted: i=1; AJvYcCVqLz4oiulO5LmuDQbLBYcUxrxMhIEuI9xBSiJK+cfXgAXydP8QCK6xkABKWofJjorllKlrXaaA7w==@kvack.org
X-Gm-Message-State: AOJu0YxlH15hdPArTJKFWGHiyFJ617NFx95Bv77ZPlQ4fMGfsMiLdlz9
	E3tXxCXmSsTDQcM15wg5lGezQxR2vjVIE0ErdN8dkW8eq+chKl4Kua7IwlygBBH5cV4=
X-Gm-Gg: ASbGncuVyFJM5ktpOwPES6SR9Uc/U2EWIfjSj1y1if67lBGvYS8Z3PBin/yu/rHkUW9
	DDgL+1qs3l2AfGCAUynIfqJ9bU9Ec4WjhTHeh8Jkf9k8u9+62qbES1JpZp7vsKlJKG2AAAl4i+O
	Qud7PrsjWA6EN6LlU/N85pnJv0Ai7mYEUj6R5YcnUXEpn9O+X33lWc3L4lqkiO7ab8pU/AGwfAo
	/mOEsl7eLj1KUzUBhj/BuoxTfe/OjvMK/3Cj+J4mngqdiehHmCdqg+z3WURTq0q29V62f9rKsiI
	VDrhpZRD2jBJV77qSAK5EgkzxLVILQ7pOZZdxhWJJZT/VDdafRgbU/Mh7o94zK6ij5+3aDWwFW3
	duNmQBnJCIVm9/0JsuIQz7TadiV5SDv7E3JH4
X-Google-Smtp-Source: AGHT+IG4XzsUhVmrn4fJ8v1PNDsbGNCghgUfxDPbkeqpUjvEg9N6RxHWj66Wbdw1AdmD0ATs4dsvZw==
X-Received: by 2002:a05:6a20:3ca8:b0:240:750:58f with SMTP id adf61e73a8af0-24340d91edcmr35447322637.30.1756454578938;
        Fri, 29 Aug 2025 01:02:58 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4cd0e1c0besm1461992a12.24.2025.08.29.01.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 01:02:58 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 1E9654489F51; Fri, 29 Aug 2025 14:55:28 +0700 (WIB)
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
Subject: [PATCH 12/14] ASoC: doc: Internally link to Writing an ALSA Driver docs
Date: Fri, 29 Aug 2025 14:55:22 +0700
Message-ID: <20250829075524.45635-13-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829075524.45635-1-bagasdotme@gmail.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1684; i=bagasdotme@gmail.com; h=from:subject; bh=QIAPxg2EoM7XBiBH/OfCd9SfIrsCdhbBl57WJdF7gOo=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkbY14FftK8Ic/EqPdDdzlDXfSrtOCCiCo1tq0af6f2T rxS2nS/o5SFQYyLQVZMkWVSIl/T6V1GIhfa1zrCzGFlAhnCwMUpABP5M42RYQe/RHjLfYX8tv8L 9vQt6eKUm/OnRm/3gUlFq/44pi2Xf8HI0BjxjsH0R+yFD+urVrRxaVu1SiT8M9vxwkWu7L/ecZP DfAA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1643E40014
X-Rspam-User: 
X-Stat-Signature: u3nhg7fyg7hu7n6gpm5upc1xbxxnx5hb
X-Rspamd-Server: rspam09
X-HE-Tag: 1756456208-64749
X-HE-Meta: U2FsdGVkX19z4J3utmR159IN4E0lkX8kAtA+Ej4oNJiGxCthU/d0aNHk+Wdz+zVr2/1bXT4P3yx3qUmLLqt4CU1BMLWFgC0AvMDN4GHLseQaBhT2cMyrxclvy3kTw14+bUJKgja9Q4FDQA4vrmG0grDRkysWYfh9PyGn76a6wofi9maiIvf1RKNNWoMc6YK2JrePdKQ08yDIrpYO1jfK6P0ZyewWrinGZHlIgpYKlJ4wcJ47ASNKiQS052ccglTKIvNal7pKsXaSPCN4MPuewUZU9fKrMuBdQNxfjs/PkYxoZE3NBbMmWYyOhGn5LRmkOYNTu04PYU8p8P5zLZz36OMOweAR6t7o1v58ESNOerV6lc0FuPkOrZoC4uZawzPJJUmv1ZffQfq9ADOiY0sO4e8o8pkTXKhaxywh4VGcva1H07W76VYlEjFIAaf99OMtkNbe3XK0gsMH9+3Dban00wSGO6W8k4n/vQoutbYUyaMhtSgHzZ5/Dqt96l172Md23nrSK8Hvfixs2eEL4i7r9tm1RgkRnUylRREVX120Kzl5pUP1xSEJN/sll27hykdk3q30VgRmdwmR3dPyPQG56YJJsj2sFS3ifOmLkwVSHZpuZRluws5Y1aclrbn9LpmQsDtLC7ImJXyS6XQgMXtY/cj23kGaXVvek3Eh9FfGFomySB79qKRQ+H3ILJVpn83X0/G7ST3Oo7z0a6qXr1RXoggFg2j9aJFZmPnkSoZTJet3X0K/vUv19YlsWElHrlpxIRsLPCfeuF0hvJ87pXB939IvvnVYGBd/jlFbOacAUv9vPLxh8tr6FsRTts8VjVUA2bRN86JPXkHIYQQhgTvpZQyjMLvMqpXvSBp+9RHhsFKaojeVGqsT0nY7HTrShCTVLG0MMKs+qcaKJKRTEuIYWT+8AT1kPYbW0HjCUBS/JNcZIgemjiBhsjue5axHsl1V0s3MukGmqsjMxcrrq2W
 H7SHqg26
 pux7UukOwLEOlyzVHFpwp3GDMgFEBh6Na89S04a4h+IshiR3FohpeXBGLOYctXrW+pNAlMBE4yRRyctOex95hppiU3/NqOfm7Y8LDp8/h6/W2u8/MAI0EUsfn2DDbPs0RxtDk7TLOmkY1EG2COgDrdfSsiXhk4K09qBUm3YSnX1r1Xje4V8tXxmy8gln76+12VozuDOzmFGlpMCqCV46H6Ts9YTt5k0DLC0T3EZZU8PUNCo9FxNjklTh7kYVCiLAD3rukSPsrM0l5jgKKxfql+jWFAbaqv5k57CnQM2LZqITBXsBubCwy48rIPiB6rVR/wqjCrg3ebMTHrNcjxumoQMaT7Oeqgd5yc8BHxjsHMlOfHSGUZJGSiIKp+PpmAvgELd7PPOS3ieUzbm9cTn3mGobc4bItqYtz9m1yYg9X/XhKhtH4HkvfFt5oG3tlX+FwKZYVz2HISsw2LfmtZA2Sqv40stgo0GEWMmJcFE2+RFxujSC9dUz8QUWfph+pbKNzBdxiM0qn0JR+ILb7ya1kaQoLjWbRQVoT94nC40jeDsczvlaUJxhcI5RSFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ASoC codec and platform driver docs contain reference to writing ALSA
driver docs, as an external link. Use :doc: directive for the job
instead.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/sound/soc/codec.rst    | 4 ++--
 Documentation/sound/soc/platform.rst | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/sound/soc/codec.rst b/Documentation/sound/soc/codec.rst
index af973c4cac9309..b9d87a4f929b5d 100644
--- a/Documentation/sound/soc/codec.rst
+++ b/Documentation/sound/soc/codec.rst
@@ -131,8 +131,8 @@ The codec driver also supports the following ALSA PCM operations:-
 	int (*prepare)(struct snd_pcm_substream *);
   };
 
-Please refer to the ALSA driver PCM documentation for details.
-https://www.kernel.org/doc/html/latest/sound/kernel-api/writing-an-alsa-driver.html
+Please refer to the :doc:`ALSA driver PCM documentation
+<../kernel-api/writing-an-alsa-driver>` for details.
 
 
 DAPM description
diff --git a/Documentation/sound/soc/platform.rst b/Documentation/sound/soc/platform.rst
index 7036630eaf016c..bd21d0a4dd9b0b 100644
--- a/Documentation/sound/soc/platform.rst
+++ b/Documentation/sound/soc/platform.rst
@@ -45,8 +45,8 @@ snd_soc_component_driver:-
 	...
   };
 
-Please refer to the ALSA driver documentation for details of audio DMA.
-https://www.kernel.org/doc/html/latest/sound/kernel-api/writing-an-alsa-driver.html
+Please refer to the :doc:`ALSA driver documentation
+<../kernel-api/writing-an-alsa-driver>` for details of audio DMA.
 
 An example DMA driver is soc/pxa/pxa2xx-pcm.c
 
-- 
An old man doll... just what I always wanted! - Clara


