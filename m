Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 775ECCAC58E
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DB458E000C; Tue,  9 Sep 2025 22:44:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C5F8E0002; Tue,  9 Sep 2025 22:44:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA378E000C; Tue,  9 Sep 2025 22:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC62D8E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:44:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B51F86E14
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:44:01 +0000 (UTC)
X-FDA: 83871795882.16.566F4AF
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id 886651C0007
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:43:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=id7PNoeU;
	spf=pass (imf18.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJdcHxX57XebbZj4zrMMfWynAEuJyyuoNM4CHXO3dik=;
	b=LhWgPhNnGCa8B48v8YaGZuEQ4xiNd0fX5y0PCuoolz0v6K/GymDovh5m8TiuPPP4p0c8Zz
	QhGT4y+jgcETVDJdhomDEy/CY8Z7bOAeQNYCAeJ66SS+LoXeG6SUy8heSxsBBiZ+a+p0sY
	CMCctKB58t6qx8v4CpICgmLEjRrGMZg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472239; a=rsa-sha256;
	cv=none;
	b=YacpOtSoaQDZEFaSsoUs4vPpDoNBxWZ96oXGmbyiefdt+umMJY4c663TA8aMcDuUeN9DKv
	sa7SlqUBH3x/RA7LcRuTXO1HT4KNMG3tWTCO8UKiPqoivcbORUSKARd+abf3jcZp3/JODA
	laXMdXD4cuekKk8sHC6Q4MATcmATUnQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=id7PNoeU;
	spf=pass (imf18.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7725147ec88so102557b3a.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472238; x=1758077038; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NJdcHxX57XebbZj4zrMMfWynAEuJyyuoNM4CHXO3dik=;
        b=id7PNoeUt2q+KBjKHoxAJYvecFUwyJKsI8525qwcD1PAFAvGfjGVkKDU7WkX87KDQI
         ysN/uJI6Hezb+toLdGE3C5HvavXf8EWxTupXyJhThaqLPoS1ORZMwjimZYae03LUhR+q
         XOvNcQgz8J81BYHD21Z7vwv5gEvgLwPJVFqpsFuvl0GpdF+vmRgh70vvm4jTfZIFc52I
         f9CvNe/NLxQa1nTYo1rACIxUZL1jZEt5psZcr+PdHRzlclPMHGO8YE/k0iJe1+pm497X
         AYO7Qu7mNdi35xTp35nVF/pY5LVUD+A8UUc/nV8YRI/i5tl6Pd2bCSJf3mRK000Xzjh7
         LgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472238; x=1758077038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NJdcHxX57XebbZj4zrMMfWynAEuJyyuoNM4CHXO3dik=;
        b=CtPPGdZh49H7cizhe94mXTAzWZVUAkiGdYuYzz9Vpl5S1ze8+8mfd0bWnGDsOsegmE
         6usO27B8vJDfMmqEyeFrZMTmQGDmckorp1Z22z8m/98CNudDu/5Jq5RMuNhP/bX6Kf5U
         qNKE/ypxXlf+fFnKd9zCyJVFZWW0xE4RxgbbwzTyNWjl6tED3nwED4u/anoDrFVLWEGD
         5iC3KBedNevC6PoLC7lUip7WQY8AtO4ooUWtXVx+SXqWVBXBxHFs1iAP/BbnILx3zpXs
         iUgvo6dQqrqC59HZL2QkhMk9uxMgChcUwhlF/g+csxaC4xgkJiqhae77+pl7FLJYugGC
         QQ6g==
X-Forwarded-Encrypted: i=1; AJvYcCW5qUO/4HuqV3Hu8sZ7mDsQ5T7Q4vW05iyiNAnK4zLtaPjRTpmNOXHjtN4fZ+bdhacLBvvLexqi7A==@kvack.org
X-Gm-Message-State: AOJu0YxZvwMXttPfNGm/gwrXFLsLfqeRgmtXK6yFneeFSDCrGH2bx8tk
	pNvHeFToaEh9aIINVNz+af0d+ne5QlyhWmr1Z/1muf6yUlFCdPHzLKb/
X-Gm-Gg: ASbGncvUkl/WaxltbsD1oR07NyiNBV2xdjMLSpo6SOLPkaDUG/KV1VdKxj7AOg2AKtO
	ujzaZfyN2w5Rw/HG4wb7VhHYQKOyFwSO0xCeO1HIWpBNi/jKjvEy4Oh8qvyh48E6Dr2OOwohZ9E
	Pz4VfCTtSi8aCqcIpJLB5eQZgcyptTX4qclLX0/vviA8Lha0s7D1IogP9QIHoT3i4NcyIYs7Yed
	irZ8+78lp0uKW/6TJpUN5USMRCfpvyHUglRGzUL1kEi2SrnMlH1MTk8BLlLPoYRS63n44TguPWE
	Rei7M3Ph35n6/JtT39joHXjcxS7LP9pa4sTrXZp0Uux3f5pNCYf7YWiipmLxa/QAnghq0cgizPl
	CP0AIi7XbLsBLHkZ3oMgPdu3F5tmFufAZZ0hF
X-Google-Smtp-Source: AGHT+IHlW2FYAtqZ1nBeuiJ0erIdKTHM8TZOiaskQC50mFORCZ7qHar4U4e6n8dIjJOSKpsMSsisCg==
X-Received: by 2002:a05:6a00:945a:b0:770:4f37:bffb with SMTP id d2e1a72fcca58-7741bebe705mr21095803b3a.3.1757472238265;
        Tue, 09 Sep 2025 19:43:58 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-774662c73e0sm3425976b3a.73.2025.09.09.19.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 19:43:56 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 0C94B41FA3A4; Wed, 10 Sep 2025 09:43:51 +0700 (WIB)
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
Subject: [PATCH v2 02/13] Documentation: damon: reclaim: Convert "Free Page Reporting" citation link
Date: Wed, 10 Sep 2025 09:43:17 +0700
Message-ID: <20250910024328.17911-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910024328.17911-1-bagasdotme@gmail.com>
References: <20250910024328.17911-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=883; i=bagasdotme@gmail.com; h=from:subject; bh=TM7A3b/55JCgQfCA5kxK7YxN6xbvfSMV2ctBC+dU0+o=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkHnih2mgVe6tXtn33sQOG2JKN6npsV2+KuvrWb+KLwo YbPrZOKHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZiIgi7D/1T1Zd+0q3NfXbSR WTM/c6Nt+dI0hVcvJi2QWSN+/Q/fJyVGhivi20SiX0RwBzyI4fPfm+rzyfPWB2YZV73+/5GK7JN 5GAE=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 886651C0007
X-Stat-Signature: 5cb8gcuoryjikwmb4kizr7gwq4jjzahh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757472239-414854
X-HE-Meta: U2FsdGVkX19ZWz0sVDUCoF56jbiMUwjiXiF6oTPbkfIiLIbA+M86vRf3AVehGPTqVEKGTmaLuv45jQqaeudcede88lIv+KndgstYd6Bj4Kt8DF4Cj++bytg2mVCfnHfZi5nY3zI0BoeQc8onxtRxNS7z1iUF4+ZvkbPIjWSiOgVhGiFXGObQ/NlrxpIjuP0DhRM9qJYTspECvsVHf+WM28O4qLz9q9x5xTBwTL6M/douDeoyrqaXDXpbGYDnlTa1Sjz24JOgD+OOZNp080tVQiPPShhQIOGop1/M7QqlP4ROm4joxjHPTpfbuXr4CcHAUfFT9PxuyBefLAWFVkcPs8lGpz2UDHt2b5DzzJZSOZ/t72G0LpW3kZ/mtGGSD7x2TQHMdAnkG+jFa00Py6vhWpNXQ8yI8Y5nchKT54uoYziLjEAH+MmaaI9wVC/GkUK2+oaclUingz1mczSxy1+0c0lXe2BKa7tQpO9v+uUY8Souuf7c90rYqcUM1WaIYFpUgKc4kouXgU970XyuLGv0hpzn7iUSuyPG0sj0ZIq/nSbNCwvAhY6XIobS9lgDB7iUKRNwAQutwlvc9jmlT8ZFE3sWOEJHLyUkqT1CIhwcvqsehk/gX/y7sohnB3gc+kH9qvMoxhakCDsXGzbO77/ymRxiV4wnT2D2qnEwejdtkP0XaaegvN2rklmFoY4CYngYqgaypIOCB6dr32bttrVG5RDBvRNNOu09EPRyZEF0sbVALViH/UDTK5ZKoVLmeN2Knn5xahD0w+hv8VLOoL9XHV7n7anCOn9nWHHG2D02n/FQ0z5O7EnP5SGlpTDMyH3GvRxzkOLQLtaFLF4ADdvxYaJbgE9e6/ZVzDJo+VLAifJSGs18CumFMXNUl4daBkehe7MpW1wTOtRnnKjGv3FaBtzBlDc63gmfBAFBAps6PqV4z9+SGXah68pjQ+yLLevnV8YagYSu17rb5VJGRsG
 5/CvdaIE
 hkJge/p+2DA9bvgMTM708ZeVwBVBocRq7QfLYraH31/Jmr4YDAGGWVsbWVvSLEBvuSt+Q+jwz3rnbS9n82XQFvAgFhR2+ZAtbXPKmwyhpapD9gVut6dgSjJUn5avhvr2PrI0OM7lvGODk4x8Y/252ARt1baZNknUWupynLz2uCI5WUjqCZKqcQ16s/pGAqd2ft1Y0ai0AxVzaGfYvHjyhMYRp9Zjeh8EbEfmhXZd7WdvhijiDLgRkCW4EB7fnLgVf+doZVNMykkssunPtVnQynZNVswDyfwDWwhnA/I6IGbxec2wI2a/dc+Lt19jSv6U/9joYKHbOif6g88DJER5mQ2NovLYsS730lAlPl8l6Sh5RIWLbwcQBX3OXwprk29OYUDAIagU7ww76Ix5bpkPUazFBjAtwvn0cXI+6y3axA8z+yig/hoYBB1Hv0WhdnESV3UQuzN+EYRQnlZPXA4K7pm3Y28EcKcjmoTBVJHjyr/o7dYoqVeIDph+8Q0+A6AgQhrkCGw+92IIvQ8EhPQkm+6ba64zk64N0Dl00Q3iOUtVOXZvdGM+ZqtyyvnbKqaSbkHAaRYexx1gmu/6eGh6GucMIPZeObckpBNibBRYFXsaubrEacG1FSktJeA4WOLnHc8q1s95KWnkQJjRQ96mvfzdWTwWNWM2NxcQzonpI5jn+SMbtNj7jz0CESw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use internal cross-reference for the citation link to Free Page
Reporting docs.

Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/mm/damon/reclaim.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index af05ae6170184f..92bb7cf1b5587a 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -298,4 +298,4 @@ granularity reclamation. ::
 
 .. [1] https://research.google/pubs/pub48551/
 .. [2] https://lwn.net/Articles/787611/
-.. [3] https://www.kernel.org/doc/html/latest/mm/free_page_reporting.html
+.. [3] Documentation/mm/free_page_reporting.rst
-- 
An old man doll... just what I always wanted! - Clara


