Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8114ACAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD46F8E0016; Tue,  9 Sep 2025 22:51:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E776B0026; Tue,  9 Sep 2025 22:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E4D8E0016; Tue,  9 Sep 2025 22:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5BB638E0016
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:51:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16C731DF51F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:51:58 +0000 (UTC)
X-FDA: 83871815916.22.ABACE10
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0F71C100003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:51:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ElBEjNrA;
	spf=pass (imf05.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQcUO3MMNiHKjyp0GXG4A4uvsTQgAsYSLBA8ucpISkE=;
	b=eTJs5emOjoD16AS/cbd0vkqjLB54YGGI4JIYFAW8yDb+Xffd4TPGZ1TQAGfUE26r54JPzG
	HEvy/hQhfLc2Lu5qJuOCje++1fplbfqpEjSsZpVp8Csjuxmm7pSy+W3i0so5LGuRubUAve
	GIH+DxJb2lgL7kqjhjcApBHqDAtQJrI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472716; a=rsa-sha256;
	cv=none;
	b=QvXVFqCXINrPAbtuJlatVy++EHO6DLBAvYKVQCqD2YhId8TVhTRtQ0z6MzG/AhC9dyZ6hw
	N1XFwfvHASu6I+5IqxcB8v6ly0g4X8hvC4XxTObrgZzKQlDS5u6g9f/8Cp9gtRmoUd19Zl
	KFucPdjgID1vZFS94qkLgl6frXryvBg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ElBEjNrA;
	spf=pass (imf05.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-32c54c31ed9so3709379a91.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472715; x=1758077515; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mQcUO3MMNiHKjyp0GXG4A4uvsTQgAsYSLBA8ucpISkE=;
        b=ElBEjNrAoDbVA0xzTkq2fC30PtNN/XT+EyvPc4zCCpQY2LwBmNKP0HtfdXg83yNMpE
         ORn/FU+J3fiPdxNVTpCZBI+t1B+sRdktJ+ODQYGF1YZsaU6pCRyZs1m+NwS4Ya7ZEP/h
         YZuDAuhH4e5l+XCr+ZZicinIIiEyeqw6QxdUaH+M5NDXK13vq+JECVkT9q0/C4fLjPAK
         b2YiOiiIgnUabPj5jTaFY7KExubkz78U7+azq1LhxnCcAiLAGPTX6WId+R8EdrT8tBkj
         1QhJZ+nv90CiWTdhBuNsUzN17xQIv/Je+9kC0mjZXVDO1EBKSLXEmcey2nJtnx0Mcn+K
         YX/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472715; x=1758077515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mQcUO3MMNiHKjyp0GXG4A4uvsTQgAsYSLBA8ucpISkE=;
        b=cH9KmHUu0xlGvGEQeG6dI9rP+bzVOW407A/c9E5Dbh0i3kMVYZs0VPhBh4sqVMJrGP
         wMKub+dOVoZiXmh56ULw6N3VGNsFI4mqgedgPC7Ni15rSIW39ny+7BEHp8p726ESD3Ie
         FV2vCzyIjCTRUzlXqR74xuQMw6LYvDOLPPAB0MG/YXb4o/2pvrpO55y6ODs8p5pDVCnu
         PZ/NRP1Gb9UR0WkiH5fAQ0koS9fhMLV8u25W8NX092+EYUPX7w5OZEuacznKKLhNfYnN
         aEAm345tb/tSVsURJUsQfJvnIlL/kwkvvCsWy+zn2GMohwXaf/O8OGV7NDtOXhWBZEGD
         7vtw==
X-Forwarded-Encrypted: i=1; AJvYcCXsVa2/G3WG92BessHQCLuhseejMBOcu78e3kra1cT0XcbYsqaKcp2xdz1qKzlwSHnRKEjsjQHBWg==@kvack.org
X-Gm-Message-State: AOJu0Yz1yOTtL85MWSV5TDEoFVHiJCoFY2AOFbjWzjROFbPgGKEOgjXR
	QswltRdIB3Auq1JXGxy/k3pnv3DAqDEeWvAc9gwe/Y/5JwhKhNQARS0R
X-Gm-Gg: ASbGnculqLRC6+K9LIerPVqvjQFBQYejYLB5hQsmNHRcN37h5eKaqaGg79p4IHJsYUn
	AcQeU8MoGqCuydHWQGPI3ntSaZ0nMY6axEABFS0fAzxw/6gpKk4M0uch2C/TYZ5iM51sufoOWJK
	KhVZ3w0ZX3Bl1+C/Jo0KsMMtgbrnkBWiybEcLe5BR7PBhVX9TLyTdDkzcYGKJr7fyP1tTfN+Kz5
	8+yH8cndEmfrWIONFEjwdmFp+CqN/+NYYr7x0cxXfbvQaaBgVge2iAGfSuSxN33b9uwzOSXEQkX
	tq3QhngOCH7loLdf6/26RDWhiOb4PmchuElcb2h/gKQaGrY5MPmIqxVrRDdRry+zCohLzhyqof/
	gsBC0gPl0NTPKF/ozzzz1UGk8gYB4NfTE2rJR
X-Google-Smtp-Source: AGHT+IHumoKCl0BwECrl0jFgQDm+a5TPs08x2B/wSLqiGEG+ifiNXW+7jwodpJ99kFpH7Ms7vygGwQ==
X-Received: by 2002:a17:90b:2b43:b0:32b:5195:d119 with SMTP id 98e67ed59e1d1-32d43f04fc5mr19535835a91.12.1757472714800;
        Tue, 09 Sep 2025 19:51:54 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dbb313dbasm659049a91.5.2025.09.09.19.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 19:51:53 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 158E941BDD48; Wed, 10 Sep 2025 09:43:53 +0700 (WIB)
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
Subject: [PATCH v2 12/13] nitro_enclaves: Use internal cross-reference for kernel docs links
Date: Wed, 10 Sep 2025 09:43:27 +0700
Message-ID: <20250910024328.17911-13-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910024328.17911-1-bagasdotme@gmail.com>
References: <20250910024328.17911-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1391; i=bagasdotme@gmail.com; h=from:subject; bh=evrdLEAoXKuQzTljW81Kh3KyWLApG8gUObVzJ2YlNgE=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkHniiL9usWFB1WvT+NSavLIanh+698vZJvp5Iqyn5cF Oeb1Xiho5SFQYyLQVZMkWVSIl/T6V1GIhfa1zrCzGFlAhnCwMUpABN50cHwvzL4D8eTgyE89fse HlBVStE02WjOOvl23fZ49/PHUnNONTP8FYh3YzzAeWbK5vj6FqvtSXp3M3+Vxhz3fMrXXv7oQq4 HPwA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F71C100003
X-Stat-Signature: m3ba3dt7f56f6i4obgak5wteoqefktmd
X-Rspam-User: 
X-HE-Tag: 1757472715-722277
X-HE-Meta: U2FsdGVkX1/fdVDnnCXdhHWBn7C1ijIzU2lKakqWluEEy8Wwys4RmsEsMghuavGeqyT89/QEjn9Kd8zgq3XbXbufx22oiFbL5YbudZnu7mAn3VDIGW6hOFa1ZaKWFpb6LACjCacrh/h3z17RtoDj82g3tg4qmX6MNnoiylhwIhkw4s+rCBR1CtLWT9MDfrMoXcf2YJQg4b9TDry7+wl5UjM/i6AMyppAwsM6qJDcu6YaA0Wnr1vFh6saRTREmu0L7QBVIGExwuo+3cc5/DgXRUtZjSDIIbFzJ68t6/vrnnK/P/WBEDYrvnrF6o7MFDXqFtgaXHiymPyiAO8dykFTcwxGh1nEe18JgxeZY5fVnmPx1SY/ZZ3rzdiZaAJylgVle7PwXHUBQ8CTMcUGAQXo4bSNS6oqra1D74kGipts5L9cjMN57552qmDwVYObnQah/MOE1yXCo/SYWRs+/wVkeNGQ4yzch6diPkyP4w9dByF/hZtnPixNxqGTLVS9FZQOEElJGF5olrWvAKjq5X9LFNbUegSpLZ5RcUirze4J5Yni+JVwb0cJH3drkqw4Mn3NWNZd+KAbYE/eliNFWBdgA6sQZKQTagM5P4R4gfvr8tziq1CDr1fX2A/Fj85qyXAnxLyQzCSXiZcEJPq6V4KJKjY6pPKehVo/mE2TWKZRNFXiRmAeGUingGORSPEkiLc16HpOF86gqF3vTQ5FeyybwS+55uw45IUVJ9HyZVskesbiio5mT/GzYN2vlz/nToQdi+6A+3EaclAEdaAVAwq5ZUFBFWoIlr45zQ35m20EIL/rbROFfUgTzMovEKEED1yJqPpKzGlWG5Zd6nFR2gXegkKkGHpLZ/HobRNd55Wt3KgsZtZ/q1ofo5hHhQoYvJLlsoVZ4pETFLRTnvalJ58Ihkcy7MMlwYF61+JnVir0sXEZa885FUk/yk11tDdEeVMNKyjQBqYSTH+YnHnvPhh
 5K70vNOu
 z8mnpdPGn1AU/7lgq6ARQEpjXMGhAqXCyGKmOcNPJgzIo0oJqvVprS8LcXXP8OcyPJjjgY4tMXakul/IWrf856T5xqFKdUGuBBvRV44f1g5gg1+YyUKC1gzVgT0sX6Hp4WVmhdLazLaNWJPcIP7Le1byklRO+CrVGMtMCixiBIGoOzxkUnXXSEidH3L2/9jPjATOoExM2S3+0I0XOHPlNIN6mneLrrlrmToAyChZffjmZ5zxEbGJXa7pbO8/bQbHJjBlh3T0tobsk/ahL18hNWthru2ixmbQHchndSe9O/PhqxCjvrvfWbIAyskXnw7LcJTCMgRG0++RbawhgXBDGKSmd+2QeLWCmB2JZnPPiYf1tbFRwU9y3bmKiitZruU+QFgSvG1IOF1yEYMcin22p4O0VBiA5Jj1K0aYKqnYaP95kuOmTBTS6B9KsViFY7sciKJ6t+746Pirgx8PWgWYayJyvvgfvim0xZJJnGF7Tp6GCe17PFl7P+ATNsEcFQg8bSE/i6iuzkmdVKFrErTlZiQjGzafeq9XicSQHlbD37qu85hlJotA9kjHmQX06f2NRoiFHyFfqkt/wewjSaW3QiR3PzB5KEi75rObpfKY5BjCbBNx4quz8YjaTIFrvH2o2sdPOuk0fDEiZpfUgLh43XJUXDPyjqCvXmF0xKeOLfLOmE6Dhy2aM06bQ8FbtwzwzNWU+/ev3fwL9B4/KJyKmL49/nQqq6IDoFOlaJU1FvEhpzwze3Pb4uBABmBmCq6xyeKY3++WXq3QLpbOSPNTi9lA+2RH3bu4mbib+roJpdn8Nulzp6Q1Ikj596NmH0AC2+VsPuBbo22oPH2J30N6kRrBX09l8UDD/FHiZoc9HKeVjG407t0L0A8SoMW6uP97F3ud6uwzv+YvtEv49K4FeN2w6NGJU53MjwKN9p/5UzUU90A7aq9zB9KyGpzYYgiBcx1uc2bSOeJsRcNFEIPYo4INQPhE5
 qVv+uecR
 jxuN9erNlNno52OIvUY+K6iXDgm1XTubbP9HpKWrYB/YMsfOAsXFbKXAmTQAWIsqDl3ETxlW99Eknkdv1IeQsN0lm4+jWGFKYEjgilxI7uVzNaKaLtqihw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert links to kernel docs pages from external link to internal
cross-references.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/ne_overview.rst | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/ne_overview.rst b/Documentation/virt/ne_overview.rst
index 74c2f5919c886e..572105eab452b2 100644
--- a/Documentation/virt/ne_overview.rst
+++ b/Documentation/virt/ne_overview.rst
@@ -91,10 +91,10 @@ running in the primary VM via a poll notification mechanism. Then the user space
 enclave process can exit.
 
 [1] https://aws.amazon.com/ec2/nitro/nitro-enclaves/
-[2] https://www.kernel.org/doc/html/latest/admin-guide/mm/hugetlbpage.html
+[2] Documentation/admin-guide/mm/hugetlbpage.rst
 [3] https://lwn.net/Articles/807108/
-[4] https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
+[4] Documentation/admin-guide/kernel-parameters.rst
 [5] https://man7.org/linux/man-pages/man7/vsock.7.html
-[6] https://www.kernel.org/doc/html/latest/x86/boot.html
-[7] https://www.kernel.org/doc/html/latest/arm64/hugetlbpage.html
-[8] https://www.kernel.org/doc/html/latest/arm64/booting.html
+[6] Documentation/arch/x86/boot.rst
+[7] Documentation/arch/arm64/hugetlbpage.rst
+[8] Documentation/arch/arm64/booting.rst
-- 
An old man doll... just what I always wanted! - Clara


