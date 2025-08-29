Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E57EDCA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 07:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEE4F8E000B; Fri, 29 Aug 2025 03:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F6B8E0007; Fri, 29 Aug 2025 03:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919838E000B; Fri, 29 Aug 2025 03:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 729B28E0007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:55:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22F311405C8
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:52 +0000 (UTC)
X-FDA: 83829036144.27.59C1AB4
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1F6221A0003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g+5Dr9rZ;
	spf=pass (imf19.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756454150; a=rsa-sha256;
	cv=none;
	b=eP/OndenvNj/9XQIT3GuND/JUGVTlH+zullVQ9yqfP5iG5kHGr+6+JDppmXzPJWcjHfwKZ
	USEY4LBtXsMZ2P7LJPrKQtI1Cvlx5SuYUKzgOsxx7R3O28ejurvjVYR/uN1o46tzKl7Tbb
	4+wrfyW4+aUfQQ2K86xqvy4zHVYQ/T4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g+5Dr9rZ;
	spf=pass (imf19.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756454150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQcUO3MMNiHKjyp0GXG4A4uvsTQgAsYSLBA8ucpISkE=;
	b=ZOkQ+z+LG0rMP9E8tk4L1ni6Mcmlycs8r7m6cDV+rwj7is6F4b8PTMOBtdP9iTxXMuY3lz
	WzwFCk7u09I3CgDzb004gy3oFZ49OHjoarkTfCZJnDaYgQNBJEet7tpHLN7sbbQJhOFQB9
	BoQsJc3MFSUNCXrjFLuZAFMiaNzDFGQ=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-327ceef65afso1263198a91.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756454149; x=1757058949; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mQcUO3MMNiHKjyp0GXG4A4uvsTQgAsYSLBA8ucpISkE=;
        b=g+5Dr9rZlEml/D9KojxN38x+1yMzKGBMxoCcP8vOfNfR4MPcKlbVh2euuc64AdobJ4
         og8RoE9BaCR7aEhrsRN7j5ElD1cQLFR0lw1z7bR7ksfdP+Nc7ADSXxNy+R/kbGT8qa1z
         z+K3S/Bi7oh0bPIAEAwZ1mncyBYWvmRrUvb9mj6B/oAgDL2VXAFuXHtT2K05O+KbIxUS
         hDZs7sKT7KTCXb0VJemur36X7n7GS4fIsiGO7US90iD3brrVDmbbhgJs6qKVwoPERI9x
         jMF+7+r2Yy+cRk4sa6dP3qcGH5NPnJbonxAjg7rK+eXAPqthGmaENDDDa7iIUiVqu6hf
         41oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756454149; x=1757058949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mQcUO3MMNiHKjyp0GXG4A4uvsTQgAsYSLBA8ucpISkE=;
        b=jenurkNstayelvceqG5yB9glBxhSgKrlfpZ3twkN9aV5Q5Y8xohdEFktuLKZdCG242
         Lr/BjRGbUmgL+bhCo8qDq1ctVK0SvkjNzpCaTkfJOoELSbXZ1HNwnobD9dVrWU7WG5nZ
         RpEVsKHU7McJEehH66eh/BFrNBUV98xcvrotNqnwLnHDaupXTchOfIRwPdoDwcHtwfvy
         w3e2NRqRd0dloesZU0yf/+yg0oLOWHvZYgMt/uQkYm9lo/4/mxP9dFHmIZVWesAZgkHB
         Gjn8viogvltVyJfVHBX+x7LlKYTZL5JhE11Sug707xYc/Zcsw3SmiF5LVly0KeK3LZcT
         q4lQ==
X-Forwarded-Encrypted: i=1; AJvYcCWProJg0SZe5X6jW37GDMlV238Xn/WYuDCTk1630LfRjZ5isbJHSTfNbCyi9AnLBZOFPd7MEIeTGQ==@kvack.org
X-Gm-Message-State: AOJu0YwcmBNCS7IWVCjbUAfiSl+UjHqmczfW7JLikpCp3mMOkWQ/x2H2
	+GYxxBC391CCJsGyAkppT3BP2pB6AssLsvyv9U5/c0i0Z0DHdXkhDkpg
X-Gm-Gg: ASbGncuEH1Yp86kZYsSDSLwA8+yJi9dtZEfhRIxTx9BNVr0u6LXtiVYy/32Je7l9Oum
	6FHv/j1hErCicKD9EX5pFbNPEP4EW5/Xg3p4W+BK0OhvJQ/lUkz06IXDLpUZbWSrs9l7kLJoJ58
	PivAbPpcx04VH/z0JN47f1/Qkc7RHUQ02RC59k1fFI8NpRA6SKekWE/+fV3rvX5UTNtbB8d9Aoo
	7/mQ+H9gcUCUBSFfhwDB8/6r5lj3QwMvbC2QlCXqXsUQ3x5/i3O1TRAcuVWRRkC/cB27aFBpZ04
	dh40M+oAg0plxEDPC1oHKK9VDUZVYRYwSHVY51EetCF2U8HVx1kjrokoSB1z8QqLL4mK+CRI3qP
	/Q8dfYsI99Rkbm1LdRG3//BhmZptt6PfFl2qH
X-Google-Smtp-Source: AGHT+IHLqM32trOVVzh172ftn7E15FM6Ea2Jk4ybBnzNmcbOCkm5faJ3oUsml9NRpuaa5OiBwPVbig==
X-Received: by 2002:a17:90b:4ccc:b0:327:7c5a:fe77 with SMTP id 98e67ed59e1d1-3277c5aff68mr10961209a91.30.1756454148623;
        Fri, 29 Aug 2025 00:55:48 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327a22ec24dsm2591905a91.3.2025.08.29.00.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 00:55:43 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 3924545A3F85; Fri, 29 Aug 2025 14:55:29 +0700 (WIB)
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
Subject: [PATCH 13/14] nitro_enclaves: Use internal cross-reference for kernel docs links
Date: Fri, 29 Aug 2025 14:55:23 +0700
Message-ID: <20250829075524.45635-14-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829075524.45635-1-bagasdotme@gmail.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1391; i=bagasdotme@gmail.com; h=from:subject; bh=evrdLEAoXKuQzTljW81Kh3KyWLApG8gUObVzJ2YlNgE=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkbY16J9usWFB1WvT+NSavLIanh+698vZJvp5Iqyn5cF Oeb1Xiho5SFQYyLQVZMkWVSIl/T6V1GIhfa1zrCzGFlAhnCwMUpABPJ/8zI8C+tSSfleGvDlW33 Ss5v/Xrog5zFrjCmKzem/Vr2Ka6JL4WRod0y2uaV0GJBfuHrJzY9vTqdTVAvLqhtcdO5S89liyP teAA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1F6221A0003
X-Stat-Signature: htdos4bpfb1pbqy3zzjpesody3gok581
X-Rspam-User: 
X-HE-Tag: 1756454149-750386
X-HE-Meta: U2FsdGVkX1+fFvnCP1RLvvQHRPVdQw8crbRZ8pNCIIOISarYcApanhWJXTVlo3o2V3xTvmLZtqNMJYpmMz0JVvmdbSfS5jksvl2nUjzo2qLgTWShBve8vbbRmsblepzWkdYLJG4CcoRqKQpWfouZenVlAbENp+ozlZLVGA/763g2RVoGHIfD8FuJsucXyj3Ml/GKiYc7aujmfD7JveDHMAn98xQ+zGSxnxIh99bYk73gBJRhkC5Emkc4AH7YFjyBhdUUlQupNHbUywJVp5/9gj1uFuzwe1vk5dgkFJjC4lF8Nc/Ehl99SE705oYYTp8NtADai5rLYkCuPhYpVaE2nqCZ/OYZJvP5KkYvYWDBTuwuli2n9e6SpykjS45nSwPmVlRooQrreB6Kz6lmFu+ecPZdevAbnWvh1nCd5rDLuecS/G3T6ph5qreI386/nPTJ3kUiFPMdLaMWKgUnA5SFBORj6k9C1RQk09nc8JQo+HFPZAuV7Sq17r1DR0guIy/gseYlOvRlLRNJG1lVQ4Dxt12NJNnvqbZ0e+jHb6MtkSIjHJZ0mzFRzx0RgHJQy9kM2IHdm8x9Yh5T5h77iATWkxaOwp+Z3M5Ms1gM6mlgfgoeGSob34aVMtMeROYC+yqKKzuWrZvmyiC+uXEvthVUi3I8MoPcFfk03vs47UhHuBKqMOwfJ+aDO1hMGlzssIPyUGd9gnY7ZdweYN81cPE1ZJYQ43NVrqIgH+dOYV+1x+ZH8Fxkc2qrDVZo3ZvhFDSbDEyUjt6oHNBANAo5Soa5DH+hnuPJEU+lG34we2yXFTyAhHI6weq6FeBeP1l/P4LEWdAZRtgumCAURyVBHH4sFcO97PhAbzpoZZXysOncr/Merb7l3htjW82aOeUDMrZSEOiGikAaVGI4z2cwFCNqdmX4dg/u2HSuodXR5EaXgDQubUn9SqRE17UrvRLu/+uLZZau2BCsEdaPbZR4jh/
 X8Zrwy2t
 BQtYglwfAq9dFlpnCO6EhGOnqDkKcXuhH4oskbwky7OvR68u8VT04bcWEsnoParHaGOxUY0WjACRSXw88Au2m6Chile/8OvZGLpFNBZaGr7kO/oL//roZVt+Lf93FwTNN0WyVeNXQzgfOMT1LNecQiDjRR1/StJ48jxy5g+RhNmJQ2uzrE3CqAi2ZecfIMKsyD08hxuL5P0QW7auarHYtgMqN9Vlpv2rPcTrrhfauYArcD2Aj7kwjg3wU/HZJFbGgDRGioorSdSp5MsKg+AZ8mCtIKnciygTxz0sfDtdHL4xHJkO3R8oLHr+0a2SeMle9xf3IUSJI612VG/LNj6VTrBu61CTJ4e0uEuL+j6MJ+znvFHyWmknneBUgnA3BYkm021uaf3sJSML/l96DNY7dEkZCbcheRtVeBmXVp/E85qZkHdgCvqu9OH37gmBhW2GyUc+SQLAY1ombBnmLmDX24itwAYAcMHiZQW8cXa/6joPP+YCDbgH/NWvSEoR2JeON3zTDtgD3Qukjc+iOPngwfpIykVGTFk3g4/ub5hJ5Nm4bQ8bUo3T1t1LKCjtc+33ATXMrIlbugHPdiux//z5dE2VGrQXM6W8f9ZUIc6OvkCdze/QWKA2OFXvJPaG5auOHgYQ3cOWy/vrgJ1UeLYNWHVha08HrkpYMn/cyPymPORdVjdFbhZfjzbMzBDX7YtXxjI6LrQKRnDZ5Z58tZ2wezvkhKLQjCfAJ1UUJPSLUeBgNqiMQDf1pq6T3WX7LiSRBDmlEGWONhgtEmPMKsw0tN+mmIjUx296nwZEbI7qjc+U/yG32rWJPDtpBzgySgdEwgquauRLNTpdQ77ktPPDRHbxkBaSB8kbPySXvN3ZAKN94L+sGHYZjqwaVNQpBOsNCyHkOgpXY1W/flCN8HzJAk+xDBMeahkPwlwsfjDdDBsLO/lbW1fq3Rn+Jj+yAU7yqfY9bBrw50OExvPnCVnx9r9CXmA==
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


