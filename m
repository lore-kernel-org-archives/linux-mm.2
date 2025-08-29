Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6F3AC8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 08:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B1DA8E0008; Fri, 29 Aug 2025 04:30:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A588E0001; Fri, 29 Aug 2025 04:30:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBAB38E0008; Fri, 29 Aug 2025 04:30:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D770C8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:30:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 840CD13788F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:30:06 +0000 (UTC)
X-FDA: 83829122412.25.5621E08
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4600BC0011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:30:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R8OJvWxJ;
	spf=pass (imf10.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756456204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kNx/lgQaweLHCKpOd5HxLBg5NtnJ9f3nOi2hx/97zs=;
	b=x5B/kPRjOi/DcQwSgIWDrNdG7QZxF8Ore6gwAmzGgpM4c3/V2EB0JMREPru2MW1Qky1SYN
	w/R/diZwfYf5/8gSobfNenI8a56FfYa8G1m2WK7a3Ca6mJNkLPOVcsR/bLOO1Y97/iK4E6
	SSQHMUvNu6eNZEmzgublEnVFNPSOwxM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756456204; a=rsa-sha256;
	cv=none;
	b=QPoQlqfyx/gUnwjZP/OL8hcGt51LQ/bxoBi3JJXI8UwssPGqR71Vgubdd3uG2bXWaGkP0O
	uDWngR7W61VJha0lCJjwljE1UZMf9aHluOdwmBfNt2nT3dE4RGtg+eZm2gnEgu8mhf7fpC
	aPmjqwVgYgkolu3PAstQbWc/eTKsRyU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R8OJvWxJ;
	spf=pass (imf10.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7f6f367a1f0so227010085a.3
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756456203; x=1757061003; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kNx/lgQaweLHCKpOd5HxLBg5NtnJ9f3nOi2hx/97zs=;
        b=R8OJvWxJSikc6d6qOaogzHwym6Zf5soieBEQuPJv+wzsi1826bLSYTFPmPbfkd9djp
         tGP9OJTuuMUhjyLls6o4PKgOWworPbQF1NsiX2B7+9GU7DgyDjnBAqrVyELsCwJSpd2l
         zjn9DjFn5Gn5b3r+ol4N29pph9hE65Y2BaYnhkTN/3qTKhZh8WS03jsxfi79/TkW5U0K
         SN6w+hStsSyMI99XIZ6xhJnX8nFLQYYrxMwZglHMkxp6hCGEmbzaMt8EEizQAFA6jR4M
         t2IR19vmzcXRD2jaESuUrOh/xaj94lk7XnbDf9UQ7CtdMmUw9ln7K62rPxW/Sb6CXc9F
         blTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756456203; x=1757061003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2kNx/lgQaweLHCKpOd5HxLBg5NtnJ9f3nOi2hx/97zs=;
        b=JqadwRN7HGQfMGzSudci4Uv59eNrRzL+LG5lmYfmrJ0Nc2qmw7rlMtGnT9R+E18d8q
         KzkP00PglYYahhr89Z3Une9PlbsXTEhHzMqZdu79smZd7tYVocs0RJhEeihwHVD1+NdW
         07j7f3cTWWgmoNLxhJoOqi8Me+qN3s+HwKY0rD3/x32fI/fQ9QAg54ndZ+hjCMcJaUbJ
         fCKh6lbpzDKp3A3YwFUVMvLEWL0TYLmoYNkAk9yHcKkwiBNlKZHKQ9DP+iyi1FoSZzVI
         uEEy1h5mdC/cuGZU3YDMn9hMnd9TO6WqRtNfnXmSUsYLWhDrSrZ8Vjgdci0kN2mnpfQ0
         tLiA==
X-Forwarded-Encrypted: i=1; AJvYcCXqU0/jh4tNKgpJyDujIDMQgBSDcg/ioPjWBfxFNjWOWzbGxnzAhgU0f+xy9OxTagyZKQuhKoeKaA==@kvack.org
X-Gm-Message-State: AOJu0YwKARdPV7V3tM9FuD++oaG+JT0SuGTQzYYgifqRNlllLyGXWWX8
	mkg17dYZNxoVOI/8Ct1w/FjrDVhs8m0PiyTpW6R4G/bErXEWvTb+2K0zpabvg9PZQws=
X-Gm-Gg: ASbGncuWmtSIo/alwn9NTtxwwYdN19tgzTCZYRgNP7Euios/u1hMlg63eI7df5/hV9/
	WjzgnCTyJRPvBLD0GzhRJKH6Qqjmzw5fGySVOvtz3uNuiBWORRf/VXBIAzLlqUCAHvV1NWpKMS+
	IrqaLfWPImhQAZQy0nB66CpGwLc7RMal0d9ocD7zRHF2kgEjFNc5XVglAVmHfko2FD4eSndDX+x
	grQSNHL4R+uGm6/dgzw+eZLBWeTae8NzryKP1XFANrrBPQ++iy1TXO/4hrYYbJ4pDhutpeSlZLe
	vfuhI7f8mv1Mr+kfLG+3FzYYpJykPf9MSBHubRTqKoIZr0QQL7r04ju4ngcerVQsaZ+c2ICMh3v
	yXZ2QlxankHsAznc7UgrosQBQ/+CRYnvF/yda
X-Google-Smtp-Source: AGHT+IH+t29amFLYd0pmHfYJonIUbgBYX5deBT907gE9ZXzofCuXi+cmB62DwyrzhPtfYbGnFlKG4w==
X-Received: by 2002:a17:902:d2c4:b0:249:25f2:16d0 with SMTP id d9443c01a7336-24925f219ebmr1591865ad.12.1756454575452;
        Fri, 29 Aug 2025 01:02:55 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-249037254a0sm16722785ad.33.2025.08.29.01.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 01:02:54 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id A15474480905; Fri, 29 Aug 2025 14:55:28 +0700 (WIB)
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
Subject: [PATCH 07/14] Documentation: kasan: Use internal link to kunit
Date: Fri, 29 Aug 2025 14:55:17 +0700
Message-ID: <20250829075524.45635-8-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829075524.45635-1-bagasdotme@gmail.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1129; i=bagasdotme@gmail.com; h=from:subject; bh=yEY9P3BA6E4kqaGTHyjuJlgmOOGj2m2ZOET4fPd8xcs=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkbY15eUeC/XH99x9zD0/p/z/9z+OvEiwfuXjriUbHJw 5Al4fDvwo5SFgYxLgZZMUWWSYl8Tad3GYlcaF/rCDOHlQlkCAMXpwBMZOZehv8FVlI3eaYvZbZV FT1yZ4VwhOvUr/8ro6tZD8+s1FyQW17C8E8vzE754pXFu0SKjG4wxTc6XF7j/+Pma/mjrVH18/Y ypfEAAA==
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4600BC0011
X-Stat-Signature: f4ocy858m7ycc5uapht9suxzxibn3jxq
X-HE-Tag: 1756456204-690283
X-HE-Meta: U2FsdGVkX19lHQEdVsQKyXL5M1MEJprzDaX9p5BBY27dKhdgwIpaoXWz0OWuhXCi43vOwy71hTJg5v9Uo581fhQzIRKJ/V+JPqMjvYPnYD2t2yH5oACgURUuTjWa7gaAViUmVf0gI9AHe8pMkM09bnFPBI9yYIH+PccQgk6Q3eQKqkjIRBYz0JrH1AnIQzhMH9sGExx1erl155wn8i2yrW4aFbSNABXF97CsV31c83reSfneB1SDB3f1Q8lHdpPWBDgRTRs9Q+aBFRMz5gcG3SprQ4SyiMYbyHK1xv8ltKLUu5WnvDBJ4BVGaEcimaeXDXamWqV5zlv0ZxcFyzhzxg+KpOn4lEXpVJWqCZBBSbObJ1PDxOlKrUJCtRBT60Qd83Jk8M0LTqIhz5SQkzRGhw4PFfzITrDDh+2JD9fS/M3ACID6oWTj3j3HELN81JhkAaC7QHam+FamiXyuSvTQ4o7NKk2zylJga0dAw0rkjcJt6/pf6cTuFlCJUBr0amcxlP/za5/UFfvKTaLWZmaWvZncEL+PTnVMqSY60Fg8yqhN/61E7HP2xlGsDP8fL9YvToCl+gx/j5qvSrZ6EvrlHIxpv+OJh/sJgmoJ5KOCQHAZh0SFiYnz41RvHEUXGkV9C6xt9xZW84LrM5BN4eFO4/PTUBYm0MmfDYVOGMvUmkX6MXfZxSA9VZ5y8MsirroOiGl84nQtOwupJGU7seD4ehbXyYcuoRGAKmSzgt/2IcAyF5GCv/XCWk74uYacTNXxtZ4N3NfDQDWlVzz/F1AHl2MN3y1e54bo1kx1FnnYRZY5MsIS58KmikB4wn5EG/B6qPHGxe8MPiwR7dbv3bLrkDyVA+IIdorgAfMuwWIhg6AM5Tb17NFOIIEkHtFOUGn+0eqsP90GisGiPHucCcykiQ2Sb+EY1wjzmupFtFNv+s4CqyA6WeCpm3Y/x+4SNia6Q3acLMclE9bV+ZFlsc1
 VSsf/UW4
 jczwqQA49MsTcoec/qUZxdyGPC0jAD67IrMh3f4CFRbfnh4nmJT48Q262StB0OEbMTBzUf1pJIDNQQ1d9fTTSpR3imeMIGnJYPuHLgmDMAdfyg2qOrfkXsJWU7qzstzxWowBL7PQdf71bV1RlEm0kSm+yPR9amA9n6/IcOu6L0fhS1fezfbLwLVzXph3iWsjMW2rzFqQkddaSAXDKUg2EnSHnE5GY3h9C7j+bGKG01JJgNCiMTZDinmEl5A0KirJTiaofK3IRSC48Yte08NaUzG8lfQ1nXlbAu3fr7loyMzqv3vdNJxQgwmbB92uZmqaHs/mwwQraioNClvYvucC9kDO1bDsXN0QizgxrCBvDo1zzF7rib9qe0qWcSnDLqsjY/jK7l9cUZGK62+sofSBXlK0HCzW+m43emuiXhE6J3r3NxkWnpqVzgMtQQYqCnEjwAkvvOSDY6/jDL/+VMuRrY89c5ZcKU/cNXX/xzZntH6Ynh4qVmpO83YaJCc2DTKbqiQge9TlEXps13ngomYhI5uVFthX5kJE8uywPCjOkZOBvtAk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use internal linking to KUnit documentation.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/dev-tools/kasan.rst | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
index 0a1418ab72fdfc..c0896d55c97af8 100644
--- a/Documentation/dev-tools/kasan.rst
+++ b/Documentation/dev-tools/kasan.rst
@@ -562,7 +562,5 @@ There are a few ways to run the KASAN tests.
    With ``CONFIG_KUNIT`` and ``CONFIG_KASAN_KUNIT_TEST`` built-in, it is also
    possible to use ``kunit_tool`` to see the results of KUnit tests in a more
    readable way. This will not print the KASAN reports of the tests that passed.
-   See `KUnit documentation <https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html>`_
-   for more up-to-date information on ``kunit_tool``.
-
-.. _KUnit: https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html
+   See :doc:`KUnit documentation <kunit/index>` for more up-to-date information
+   on ``kunit_tool``.
-- 
An old man doll... just what I always wanted! - Clara


