Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08A53C8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 07:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FAC28E0003; Fri, 29 Aug 2025 03:55:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45DF38E0001; Fri, 29 Aug 2025 03:55:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289508E0003; Fri, 29 Aug 2025 03:55:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A7298E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:55:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 924751605C4
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:37 +0000 (UTC)
X-FDA: 83829035514.30.EEDFB3E
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 84E3140005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mw2i41xa;
	spf=pass (imf01.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756454135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PKHUedwTpnE+6902OLKWJUrKeeyE0icmaP4M6h8VeIM=;
	b=gTxhLzTUOPCDOCKx41Yx/Bh0CdbHkhJpoO5m7UtYk+8IdIWpdadv9oMKLw93aD4MYYqj7N
	pM425rw78i8wZffGmOebwwZxzxjodvJttQnli2OSfBC8N4qxfcCJ8b17LpsX3PeJwRVxsx
	5FoFyYjbx0CZJcIhJaffHfVkKraIGDo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mw2i41xa;
	spf=pass (imf01.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756454135; a=rsa-sha256;
	cv=none;
	b=qqggBRokpgj9WrZC7YWTG3Va6TE1g01Gmr10oZcJWI8XfbA7Ud5GY4MG/V+X+0bTZjWRpW
	KKYRsnFQGxdwVXG1e678yd5Td5TK3vMXywuSj/7y+adVdau7uHVMRNpy8+swX5BOXc2W2K
	UupdKExdWIstg5f2IFqpBjVuruE0ZNY=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-77201f3d389so1968516b3a.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756454134; x=1757058934; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PKHUedwTpnE+6902OLKWJUrKeeyE0icmaP4M6h8VeIM=;
        b=Mw2i41xan/ji4o20yA2pP7t3/lSsZtUgcHPty80RsmwtaMGhyMKXKhrXMEb018qZ0W
         222UpKkG6oS1czEfMbzzaeF/PSVPR21OJOS8mPvFXaXivvftHuUCwARn7dsWQjGciWXA
         PIZLeHeF8XZ8kfdrlAT4EoLg/VnbxhzvYyDLDpXEifOFsYqdLjU2K1mKMBcEYn2OzT3V
         7WBqzkBFN5jT9e8gpiIQvSnzPTVRr7QnY7w6sybYjAlkBvOloGuqP0gqBnAFFpnmd43Z
         PPZCnqfsHEfbc1rS4bLY8KyjY6nGiS5w0Ahbq/lIvtv6RaM+Tr/UsCMK18ylQJh+qnb3
         d2HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756454134; x=1757058934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PKHUedwTpnE+6902OLKWJUrKeeyE0icmaP4M6h8VeIM=;
        b=nMvBrDlkrje9EV1B5ssUz7mjv+K1bzQPCCgPnDbPej/mCTYCMUOPfCTnN/gyU7wb3M
         hjhCPOgg9gvtYTtz+Mk0salbLIi+fFB5OJduP/sJSXuajrsv1dmTv75+g2aWHQdiBx2J
         GBR5L/QEONXSNQwIEG2eQW8qK0T7YT+EFdMUHMpkxcCAV5qlTcOcDjAicjkfyqF+snuQ
         feZqkCDEAqQZVZDS58PAumM4lqEIEmx79yk+ZQQ0DAxZ3UuPhtm0usovj5ZLSvYUYL+0
         bI0MR6ZYlrMDVUnl+MGIPRkfGcQVRUD6rH7BZO8pLuV7tJcE1o1XtU5nAKN7gvY0TpB3
         sc/w==
X-Forwarded-Encrypted: i=1; AJvYcCXgmMebW4FeA0ZdvVCV/0MCw6W0a0RGouxJo+EMtcv3gML93gsxhIWLvoH35QF5PBXsJGSR7ThBCQ==@kvack.org
X-Gm-Message-State: AOJu0YzlgWd/OCIC1Ls1FEDNlIAPgjNEvtBCL6LOgqqz8J5toBk7KNOk
	9coB5zx5+8NeAdx2m/Wnie6FhL42XCq5ogDb2BarsnmhpKEejMv4CfgW
X-Gm-Gg: ASbGncsggMI9zZ0hF4wLxgFZTLwmLqXeoEKgjFYzxIx2cDkcbFMbf57GxB7E+F1t5dO
	5pNFjGqRryRw5iRavFACsJDjHLhyDtT2P9uWzzF4lua4npG6YQlGmsp+DRMqSoax3owllaXXbsi
	1CWu9GSIFtNrxAkdSpK0UNsyfzbgh9tlhuUkoYDfTAXLT/4pufzyng8s4oFsC82i0R24PA+Y5G0
	Nqt10FZL/MGZEYs3Z/oBmzUY0AMiHKBaX6VE/2KII0eDSUxS9NBgcwZNzE9nvtt5i/r+rHXcJh4
	ZjRu3YmxGkTUtLkUa4/tfHpGpsDE2DBa5e9fPnOw4sV3GbZt81L3lvFSgQnSMJip82v8Vig2KxY
	FhfcR1EKJf2g+92msanGmcdI3LQ==
X-Google-Smtp-Source: AGHT+IGAIwvY26FUOsw+74AGPHA13vcCLFsNdM4e5R6RQVZDqKcVncdSUEtOIO22R3FiVyKLzy1QwA==
X-Received: by 2002:a05:6a21:6d95:b0:243:9824:26f0 with SMTP id adf61e73a8af0-2439824377dmr17475585637.46.1756454134181;
        Fri, 29 Aug 2025 00:55:34 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3276fcd336dsm7401665a91.18.2025.08.29.00.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 00:55:32 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id CE9134016442; Fri, 29 Aug 2025 14:55:27 +0700 (WIB)
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
Subject: [PATCH 01/14] Documentation: hw-vuln: l1tf: Convert kernel docs external links
Date: Fri, 29 Aug 2025 14:55:11 +0700
Message-ID: <20250829075524.45635-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829075524.45635-1-bagasdotme@gmail.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1333; i=bagasdotme@gmail.com; h=from:subject; bh=oQ/U51BIIgNGsRun+kwInz/tmig5xTqHruGeEvNRxQQ=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkbY144a/JZLY81M41OfrJ5W/1jtyyro8lZM99fCflwN Zg5yrW3o5SFQYyLQVZMkWVSIl/T6V1GIhfa1zrCzGFlAhnCwMUpABMpCGH4p3zu88Pdlu95fhsv /CZ2ieHwual5ab7C13i5XivpL/Ip/M7IMI9vYUN6A5f856j5POvK+r6kxCYoXlPd7vthl2/zPqb NrAA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84E3140005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 83ho1ty1gkxceeq5oc48jhp5zemc8c1u
X-HE-Tag: 1756454135-252594
X-HE-Meta: U2FsdGVkX1/QDXHuaZnkkR+WulSdD1shnJeDBCVAcQW/8yTLpGRO5NvvUcDWI8yppaxh/OUNpVGPmTZaFx3GjpSLzmSVsMr4WJx/EQM2+fGbibJWN0JKOrX6+nhmFoTUlQuL5BfJUEvhI1HqoWvAfpy0PAbJQMkAWJElOw8G5LtuqFBn1PV2lTTqtVbCWNWm89NyitoC/ydZFOOngZxBOB/y1ZMtA6KuCqgycTw7Omd3G67CAt14LUcCXbtNOg1IF79MEVWErV/lQAvWfk8ayYSPGD22MCjrj/uLEKW8r+F7qhf0vQNXUWt7vrmAtXFT3YjXS3PdI6wbvGJsdypBV8Ou1st/q4WTjfsGBbMEZewuP1ZepTFTRdidHh/U2vk5W7JaoZO5DtUUtJJZqR6C7QbcVIPEqGLAxSafo17458KEkInKq3l6LpnymEwSWd+tXtYGVGYSZ7hTufAAUNnpdcEuX1aEtZKFhtOzTxqPsfsugT16nc3ttaKlEYyLolXXbsYGfcXG3j//4FHWJC7gHnPCODpOPLf/QE8zmiu3/Gb0HeOIQwdNbTLM+WRlm6AoinAMM4RkbVSmBzJessf7Jd/hbs9EN+VrrNk5OqbOD4ThPPuRTBPVsIUMS5kkf0n2I9BeyzTZZJXyzY1xgKNUF3+v6QigOZG5uWX+6AhNmQ33rs52MqcaOhPbXLooQze5hBt21zka/mwxt6OCib2drSTx3kFw8uZ8CkTa9nCg9HlPgbQhNZN5pu7zPccQTEqTp5eCuVDEDA1WgQ7XtZ7E2y6SWyHLbs+ZoayTVDPQXUQg8E81VdesyJRBgimrDpkkNl1Ovb81TMmTAtmdEmBOhngdRf3MzEhjjoQ6I4t/S8jUB6X5BFUKcS6D8WU9Cs0cL357VwqPNztLWAZf8rV1f64wyKNzqJ+vRPdqYfYdyJuHEb6Rnuj4EobDYgELyree3N9v/1ZxHP8aqRcZaPN
 smiLnd91
 xju8pDz0TkQv6lk/kcd8eLS4gOVEu79SikghUvmo3cC5RxDPfirW4qwvPDXFYff8P/4GMBSZy7clEtr4AxnDMaMQ0W8H9Us72vKPANgbT5mMMryNdvbgeBfzUIKGl90tVGsT0S+vKSke0GUv5jfice3vxa+dg53/jZjt5uMkjPqVr8yHEiLkr1LVbma6TP2ceqoqG+ehndNWTKNfcZ2u1kMeGrU+UDNCQcB0gciRF4aDnqya0WQcM0KLiadfymKPxI2FegWqhlrwrL35qZn0AwWxpf+3VWusb9lK+bGspfiBldMtOWpT8nTUOH9Oa1Ebo0/y3laEzuTrQbK/Lj80URmcPZaGd/LUSWrbc9eu/oByRj4Ihigji/KYLw+SOthgCk0bP97iZUNBVm5k6RuuMYmrqcXP0aW6XcaSVBFL7M8HzeUHw600eX+vqAwYK1Jk7b1ISzXVzvmbLqM+IJRmkDrzSz5LKA55obTZ5EESju2zxEjRAfS7hsaWAb7m58dkeyJSGdtebbzx9dTM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert external links to kernel docs to use internal cross-references.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/hw-vuln/l1tf.rst | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/l1tf.rst b/Documentation/admin-guide/hw-vuln/l1tf.rst
index 3eeeb488d95527..60bfabbf0b6e2d 100644
--- a/Documentation/admin-guide/hw-vuln/l1tf.rst
+++ b/Documentation/admin-guide/hw-vuln/l1tf.rst
@@ -239,9 +239,8 @@ Guest mitigation mechanisms
    scenarios.
 
    For further information about confining guests to a single or to a group
-   of cores consult the cpusets documentation:
-
-   https://www.kernel.org/doc/Documentation/admin-guide/cgroup-v1/cpusets.rst
+   of cores consult the :doc:`cgroup cpusets documentation
+   <../cgroup-v1/cpusets>`.
 
 .. _interrupt_isolation:
 
@@ -266,9 +265,7 @@ Guest mitigation mechanisms
 
    Interrupt affinity can be controlled by the administrator via the
    /proc/irq/$NR/smp_affinity[_list] files. Limited documentation is
-   available at:
-
-   https://www.kernel.org/doc/Documentation/core-api/irq/irq-affinity.rst
+   available at Documentation/core-api/irq/irq-affinity.rst.
 
 .. _smt_control:
 
-- 
An old man doll... just what I always wanted! - Clara


