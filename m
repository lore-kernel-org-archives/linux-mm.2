Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7F97C8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 08:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 091666B0032; Fri, 29 Aug 2025 04:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0672A6B0062; Fri, 29 Aug 2025 04:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E97416B007B; Fri, 29 Aug 2025 04:13:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4DB16B0032
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:13:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 631831A05DD
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:13:36 +0000 (UTC)
X-FDA: 83829080832.21.3C8F440
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id B503110000D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:08:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=koX4WRNR;
	spf=pass (imf14.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=temperror reason="query timed out" header.from=gmail.com (policy=temperror)
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7f7742e71c6so181164185a.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756454908; x=1757059708; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GUuceR9E3vzJz5a/JHCoOJAb1uIOOWcnyWbxLYGhp7M=;
        b=koX4WRNR1xyvnIMahPUafsOo7UVPl6F9QcWsjsFgDbqAPE94UWMKSXE+xDOQRIf06U
         dppDPa5YoHxcEN4aDWoKsEQKPTYOSAoiCkWZ6Rj/hDYN5fA0rETpE4XPH0PfmB5l46qP
         HpJGhdnz9z8CPF3tcniGXIEW/rwAHf/2GkYNSuPfWZKHBKNeaZvf4kpvnE/lif1OVlmv
         TsusFS+QFf4KB2qQpzQtcqwcueDgAyEyknEZ/R+38Q4I8OfyacGAzR6D98mTIt9NNDg2
         3hcTSqJbPQCsDrA+qAPX9twr1FkM+QWYoGmweruaAP4DPnH8QgcssBxQj6HWkT4+W2iD
         lX7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756454908; x=1757059708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GUuceR9E3vzJz5a/JHCoOJAb1uIOOWcnyWbxLYGhp7M=;
        b=hsD8HW5elKgc0HiHWS4QbNr4hht3POHKaxlk+i3sigB1o+RyeVQ4mUroxyc0s7xava
         epQbAIMiocKAv6ygyBmbeCJXUL989ZNcwz0S7+kJSosAcFh5fmJ185KY//oEejquUWks
         /2R3FaKPezlbOpVw5AfLs/KsUGBEYy7H+CV8gCNFeCJPRTayA8RKfRuVkPmCiFZW9wAs
         e4eHHBsXMavhKPFoS0eIL7RW+2LdOxNTgHsFJENiHTHv27Xs2Tz/PPuH0Cwfixd5jF9F
         OJAxCZzJiOQ6L61eVRwGDRxwfvXp3I0x3zpg0l49VLmz3OPhXFCD8oDeeiYUgAjgQYrM
         DwJg==
X-Forwarded-Encrypted: i=1; AJvYcCVqtFbhe2lh6NXk1TbrFlBxdfsiuSTMrCLDGR0wITDuEzyNq8qS5FBNK1tjptiOszZVtG3XPGSMAA==@kvack.org
X-Gm-Message-State: AOJu0Yz5UjeK8rWzTGIduLob+zKT6mYOKSxAw75l8tpishLGKXM0cHDy
	4+jaHe04HG9tTCrJnYlvzEHHwlZnHu31En42QB46y3wk4VuYPB8FcwK2HNa6aMnZ23I=
X-Gm-Gg: ASbGncvLWoSrjrYWq22SNlx2Nr9et5KIageUjhp7RlRdSZQT+jJiqO4SqSwxTQAjI+A
	dYtxheK+/P97WxUe9rp9WZhj2JFu1GgbakmnCgg7TNmcx/IWV76O5wiGJDnopw0bI2ix5nsRhpk
	hRn54xqtD8abAtbBUfpCSy/j5sMHTikytwtcAiDHg7kgK9bw7BuHc+2gIMbBJF7IgPRseCJs7E0
	GrZP/ZQufQivLW/OVifZQWdkZiWD9V7iHGQTJx9zNDriX54S/dTNKLRULsDhIluR9UD4hBCf5Ny
	r06aEeScAyCObrjJBv1iNlIxTLD/kIKnzS3DUC/F5lonqV9POC/+xhjUXB4cWB5DasJ4IZL3jbF
	1NyNWEpQuI3xZqrZwspBeNnbkx7MUtWfV8sLi
X-Google-Smtp-Source: AGHT+IFt0CgZnKjzhJ5g4aj0Cm28ZWwwe3q9IBbh2aQ/4X9BQsH63Txhma9tsRWuYD6j70bLTYHjgg==
X-Received: by 2002:a17:902:e890:b0:246:bcf4:c82d with SMTP id d9443c01a7336-246bcf4cc37mr269048275ad.52.1756454575739;
        Fri, 29 Aug 2025 01:02:55 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-249067de9f1sm16493345ad.151.2025.08.29.01.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 01:02:54 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id B95C34480990; Fri, 29 Aug 2025 14:55:28 +0700 (WIB)
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
Subject: [PATCH 08/14] Documentation: gpu: Use internal link to kunit
Date: Fri, 29 Aug 2025 14:55:18 +0700
Message-ID: <20250829075524.45635-9-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829075524.45635-1-bagasdotme@gmail.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1122; i=bagasdotme@gmail.com; h=from:subject; bh=lGvjj6RPPbr58GqrWqgYvJfKnQd0kE/Khje7rmfw55Q=; b=kA0DAAoW9rmJSVVRTqMByyZiAGixXOmjSTNEt/JFR6AhPDWfGCcGj/Np82/Az7wMJic3oIar2 Ih1BAAWCgAdFiEEkmEOgsu6MhTQh61B9rmJSVVRTqMFAmixXOkACgkQ9rmJSVVRTqNRJAD+IU+J KWDSPb94prUVj+FntqxPO7boU221XL2jEkITc6cBAKhpWT1CuLYVAMm4rv4hGzdOOa9sljkO4cB hdLolzx8O
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B503110000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1xw1nd64mb5qzoo1tcbfjjb5x6bdmwnc
X-HE-Tag: 1756454919-233810
X-HE-Meta: U2FsdGVkX1+U5oPpmWJk6E/TX6wbUgovSnLJVOq8Wlnvui6xuG7Tzq/hLTX+m9cBKuzTGpKfhSsM7qtnbkocNgdykzcFnNLLIasE7eMWmxnYOIpaPTXuI56cyyusI/KVFrlRmwPMHyCES3GLN51KGIftbjlMvhREO+ekpuSwx0wQoIrQKG57K2s21AclyWnlVDhSx6u6/NR8/Na3Kx8Vd8goOEaH5C/P8kG4pDSA4dtlzyRz32M6sK5IvRPd5H0DZHoymG1Z734MmdMlqE3SrEg9v1B5Fr43cm4nXPnO/YMzsvXi+0xR5kiQNMYE2f7vCzDkW7XfUl8qQRx+hJju8KmphEHkdHiWYs4rgrKaLG8LNXSjoysbWJaIhSIcGSB+RzBvSmEVXpyWL0DNPw84X/z4avN5E7mLh4/8yQnpynhricV1CE2L2PgsgicnoXWlvrRMZtEMKXG0jYUFBlwJY1hy6lSV99RYWBVFL4lT+JgqPV0Fun2XNdT65hHNbrlZBsiiUyZVVCZ0QhVPKEd0zujP5XXGaG8NDxCCmjHG43NSROejYbQBOZzUEhnBieitLdp43rNPAm8bfyN0D7AaeWypx7Lf+P6NekU6OfKz0pOQmmOZbnNqpWBCSVvw7ubfbMnKZwwRAH/S8HbPqtUupMdcT9EdVZ4+JiDcdfLk87Vg6fbestS+jiQwQVJOjXZfqIypXODmyErGttu3QhzdVZXTF7xyNOL0LeNW7Z03AJTdW4dp9JBEgl1ub96GBRZ5nDhIZlJlr4UmKFt9knwGQtEWTo22V9YziujN0OOT8HGVNucI//8JHja2VH2dcW2vJ4QwS0v0AkJ27Y4TpODGsqX0Ka67FhFvdu/f9iu8/cEEcEVeZYCnrCFEAwB44k5DymadpgnIXV1sDpgeWo/uXD8durGnQUbyB3rPEoUqZJoFB7ERjPnTYPbsXlttdo9rPIHIa0D/qnGIId6Kgd5
 6ES3mUYv
 a6+FdaqRzZZIK99HADDru5AyAwORaK9AU1sORFoq9vpOHyp1N9A8JEJMvgw2/rfUsfcXg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use internal linking to kunit documentation.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/gpu/todo.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/gpu/todo.rst b/Documentation/gpu/todo.rst
index be8637da3fe950..efe9393f260ae2 100644
--- a/Documentation/gpu/todo.rst
+++ b/Documentation/gpu/todo.rst
@@ -655,9 +655,9 @@ Better Testing
 Add unit tests using the Kernel Unit Testing (KUnit) framework
 --------------------------------------------------------------
 
-The `KUnit <https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html>`_
-provides a common framework for unit tests within the Linux kernel. Having a
-test suite would allow to identify regressions earlier.
+The :doc:`KUnit </dev-tools/kunit/index>` provides a common framework for unit
+tests within the Linux kernel. Having a test suite would allow to identify
+regressions earlier.
 
 A good candidate for the first unit tests are the format-conversion helpers in
 ``drm_format_helper.c``.
-- 
An old man doll... just what I always wanted! - Clara


