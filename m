Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA3FC8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 07:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65238E0005; Fri, 29 Aug 2025 03:55:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEBDC8E0001; Fri, 29 Aug 2025 03:55:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA398E0001; Fri, 29 Aug 2025 03:55:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E47F8E0005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:55:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34BFEBA316
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:38 +0000 (UTC)
X-FDA: 83829035556.06.78D4B2A
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3103920007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OMI9C7Er;
	spf=pass (imf13.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756454136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GkZ2LL+fO6oH27E7YsqUKpWK9h0JvMFOl/W1FWHyGxk=;
	b=Ib4mmKNnEV650OepvvBSr+uSPTNmUXQRv5wSb/89hz/ViefVT+BRApUt4oH/0zIcPKvyAc
	EYKENfL8rp0nh4ql9efQlScWuVJ5LVHsUfZL8oZTWPTgsnZ0pQ9N5w7h10U0PUoX7vobp/
	OPAkXeEgJqEdYRP+MqMN65UbG9xIiIQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756454136; a=rsa-sha256;
	cv=none;
	b=m4lbv+L0RtmvYiBEnRU2CsZ+25LzoIb1kEoBjF9hat/CztIcKL2Ikzy2gu+4AyYAzS5TiF
	taIWjyqfoTv2aQGK6OxC8LrKHUZTyMP8/o6vW+ZXjQoSVo7W6ahkIYId8mHQP7uLWM83tq
	Xg99ucRYl9nWigXgSsAxdhbgDGjqnVE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OMI9C7Er;
	spf=pass (imf13.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b4d4881897cso174751a12.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756454135; x=1757058935; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GkZ2LL+fO6oH27E7YsqUKpWK9h0JvMFOl/W1FWHyGxk=;
        b=OMI9C7Er0myaNPw3KmE9N27faOlkwt0f5GFcY8l1CFqXzzBCC9O62LKaecPtahyXJR
         TDobK3jsb7/yBHNqWCJ49LgWtQapa7F0q3Og1iRzyXSnpe4tG+cO0FCToMBDNI3DB/Gp
         6WmkLzMrucCN7byx9tjuj9ulTsGeFDG5WGl//Y5aBkd9SOtwag7G7UAw4b8s1LKpgB9Y
         hlXAyMFKOIASJ6ZlF5KTHsDmzElzm1hS1lJMrX4K/wq8Y65FUSxRM6/iYl8e/vK7h8JM
         wiC00PelcFenE0iqMZsoI86UPuKdTJkTQkB1cqjw73DZJyXQ3UO/vfT773M4tsVZE9a7
         qNhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756454135; x=1757058935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GkZ2LL+fO6oH27E7YsqUKpWK9h0JvMFOl/W1FWHyGxk=;
        b=oMeZuGDykrmAy65zk/xguJ3Uko3sHiSMqQyzFqf+KUsN9tWR4+p8jtDHWLlYv1fdZ5
         GtfqwudZBeLKhS+mmKM0e/SjVGnh+3cgrpK7rylrRzOTokKV6fcYi82BM6Mikf1bKCT3
         6r9YRvGRB3e0DrWdcqMYGR02s3/bHFvHesgw3TGy2ESFhT+VNquQA4+XGJhohymkDbRm
         SvEZV+Imxe/jBthN+89eCiEp3oft29gFx4Nn3U8yHyFevYYBlPDRd7AXkFR/Kx//5u39
         xyPJMeMbs4QJHt/NMb6RownNIqvwVuogzfHQfGzOBbqY8vVfrMgkYpTw7/Ns0i1LbcJK
         Du+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVN6gTIbHENJThdcg9wYcwdQHuOZAZ5PPQ3CsVPdqNCXwbTNHQlx14+fgVA0HpwMnFZTse3tjG89w==@kvack.org
X-Gm-Message-State: AOJu0YwdUtS0PB0LdkpdPIxlm8daKsB4k/h8SZoGDGJl3esPVQQxlMpP
	MwNObj1uiudgbuF2fb+UwxI0EMabMtVWmgBxePsviklxtwmBdJKzC815
X-Gm-Gg: ASbGncsxuKkMyJRJmFSgo5fvX3pggZWZ7ooB8TMMn6Fq25U9KCwsNYg3U3SUPfWoy4T
	TfjRhzLdercroEwmuFiEZoybc31VmtYagLKVffoZKTn7uOCw+A4ByLtMpAjWcliSaa5pYcC0vJv
	bUZy6QeItL8uehqshDydRCib7zR1khEucYbck6N24Rcip2mdSLLaVi3xCFkIDgL7jZpMQmfFg9Q
	4OS4R8rCZoOZP6y5ecUDA+wez9XKulGJMDGX1pPasKy6kDV8T0okv0TfL+taSbSKyixkRbJv8W/
	5/lP/rBPg3JWTCMdYt6PfufB+nqqa/SKTyps71ufbqwFtOIgyfBTy9waT6cTOXQFaSZnMM4BtfH
	G4vqNIBL8P8Vok+Fw8SGCwADwHD+QqHIhM+9J
X-Google-Smtp-Source: AGHT+IHJ0etjvptegteXgkUWoFIILA9nIajrzCKr99WRD5OzNxzSggv2jyDezns1lof2dGSUjRUcTQ==
X-Received: by 2002:a17:903:4b07:b0:249:2297:c424 with SMTP id d9443c01a7336-2492297c777mr3315565ad.15.1756454134776;
        Fri, 29 Aug 2025 00:55:34 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24903724ec8sm16944365ad.41.2025.08.29.00.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 00:55:34 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id EF6DE4444CA3; Fri, 29 Aug 2025 14:55:27 +0700 (WIB)
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
Subject: [PATCH 02/14] Documentation: damon: reclaim: Convert "Free Page Reporting" citation link
Date: Fri, 29 Aug 2025 14:55:12 +0700
Message-ID: <20250829075524.45635-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829075524.45635-1-bagasdotme@gmail.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=839; i=bagasdotme@gmail.com; h=from:subject; bh=br/gH56HVzhrfYYqrTP3c/xceN5BBvTsvI3pBYQ/yVo=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkbY14UOzeckV2lWTlnxluBwiWvpt1jF+xvT61/ejpwa tSzw60XO0pZGMS4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjAR0x5GhlnvrvsFdd3e6TjZ g2FTa8uK3U48C+++2yu+oPH13XO8khKMDP0RbvPq2Hk2WQbMuFkV7P77fsRatst+E/e4qhe89eI LYAcA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3103920007
X-Stat-Signature: ukhw473q6bygm1axktod67rk1xa4xesm
X-Rspam-User: 
X-HE-Tag: 1756454135-948374
X-HE-Meta: U2FsdGVkX1+NUEThyw9BRVezoCxEehFdQNU2xSXLot3nDDEhjD/1lR0YvW4in8BTHlwnHi+CbYfsJKglkh3z9lWHMQS6zdei+qMBXbxlArmODCvfZipnUwKKFpDIQRGU/Rw0eWkcWTP/3mFMB3ngQukAshNe6C8HVSQ4D1q6q4aBLDmZujl87NqYikm++2hmdGzgVoqSFipukw6/VQJIpHpo+YRxqziFzPR1L6tdL6wCmGk7WItR6FFQmFNAiozNMf9VC3ySV/RRBlsXSmrmeZ5XBio9z40TB5ibJF50SVgVagg0T+CMZ+ecWuytGaLOuF1P5DLcYa68ESgrJsT6ku4OgT1XxlTeXq88W0cdGvsJIXpr2bQxVS+H4EquQNmTh98TJpgTIyWnMtMHm5lnu98F2FQ8zKRog9sjs3mx9sjywh+TithapMOWBoLGQ2LylLAlddY5iNhVR+bKkUdks2+ybB2OzXJGPgM7rqX2Yxvj6TdklECVJ9R7CO6IvdDRqBzST3VNkZ0OgEKOedgb41kt7E3tEwj7uHqy5QD2Ls4XutckGs+lGKG8WS5vRKjwfVJtyw0JOPm41nFa/WSl82kG7ii5QC1327rXBlMFeTM1Bs2Eqbps3U9qig49zeaLjtIPUFfRyjMT3sHAx5GfIMWrzSAbbpXrq7AnW3xxqpRcNkWmm4UQ0GaJOM6kW/K2vlA0Gyx9DCSgYs682Y5B10DGIH9Lno7mwA0XtT/UJ6L5qqsCubd0bJXy5AqPjlxHxvJHGscI6qmSWcStOdKY9g5ApRHTRiA3kFr97kAOiYRZu9Sf5uOZGr6/vTb/GAKHN2BtpTJHxZ39mWJbfasZ3TGonsyIsu0Ge341Dk02JO3y1R383goVVAt4jXwh9PQmhzDuuqEzIJXrvGNWY5ut812+9PfjXJVKIrFAePzFHRFjua9f8pau4NfgJAzR/SuHXvS0QwDizI+u9GrFBxJ
 MuBwQOJh
 lyk/iM3mPp5e/uNFtnMpJMKh3aSRoByeMy/BoRg21o2a3OO9wgh/vTTlu4f2ccQ1MhpLYLly95a94q+Sh6PkzlFuta70PLyd0DrLkrkB2HiaSOabc4eJ1ijWvNqRY92kKAfiBkV79zuKMIdd4O3X0W0XSDn3s8cqNtAWKU9r/gicunz0cywwnjv5pYWHNg33GMAFqaB2D/CPkgGF+Q+kDp/ra0AUJLsKzPyZwtounfRdDUdR9jZ18vGPrYR7Zy/tMNEkYkE59TsfniSU8YlbnRS9xM49E4qD55JlCF/U09IYE48fLFYWGtrpb0YV8o6RUyI/nXA0Y+eS0+I56o+uD45516gpdoYuk9hLyTkhcuol785wcvCqFNaQsY1rRA5HsYDB2ddLaMbZk4QgbF99zHnXmMiVmH3U2mRUjtD4vlegBWkXh8UArLjpFTujXlDJ8hO2D+YIgSv2orEMz5HIkkoWsLCW1dP4AxfUmqeSdsP0WoHrz5BQEJ18gP0DMp0p1dqTy+rEmqjM2CW+IZ01QYLUIbtlYKjOEAMQCqzlU+cVRa5pwZQQO6p4iaDp5PNkSSST60Rpw+GtPviMWFu1AnpziNbq5TESWvMgVpJ5TMBjnNAfsVs+CXL5xPyB//MFDVpmP/uOwkm4+LC/y6VM87dT2YKHovdRbdcjU4UC7KPhfH004WJuJ8szysw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use internal cross-reference for the citation link to Free Page
Reporting docs.

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


