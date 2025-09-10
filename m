Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36D4ECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37E88E0011; Tue,  9 Sep 2025 22:44:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE88F8E0002; Tue,  9 Sep 2025 22:44:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C887C8E0011; Tue,  9 Sep 2025 22:44:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE3338E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:44:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DE3E59AEB
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:44:06 +0000 (UTC)
X-FDA: 83871796092.14.B89E6D5
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7C0A44000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:44:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CVU2PPMI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472244; a=rsa-sha256;
	cv=none;
	b=vKb2z7258GiYoGDSQ/p9wWiivrBq6klqn5Dk74bOHIJmAxIe1LjiE/nweXyV9H3dRqLbPi
	GC8LNfg5N5NJXMYmjkZekIMQQkLf3vnwutTUxTMOVs3XObMMg6D2EpDl3HSPhorJUTCYTm
	2N/sVxhqOiXLcow8bfT1bUkgdncPjUU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CVU2PPMI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0koFSnJrv2UowuMhMeqtiJIslvN7BbZv6mHXQ/mKo7A=;
	b=T+jwgA2pHNRph3BsBhcPmUeEpMoLPMeLelz926xklvEOGPtqWKJrsII9LP0nGS06toE0o+
	h//V+6J00CmetD6PkI2WaEMTqo5IqLX8faCoG051Wiu83hVJ1oJGDLrr//nVEFRZymZEy7
	QeKSxZljwcOi67ww7tdjp+ECHTyRHBA=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b4c9a6d3fc7so3799950a12.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472243; x=1758077043; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0koFSnJrv2UowuMhMeqtiJIslvN7BbZv6mHXQ/mKo7A=;
        b=CVU2PPMI2vRs8w1yKYwpSTu5P3SSa+1tPJex07m/mo8GHTCTGb0oIU396E74XGNCWk
         zTVqZvQhZelR8hxQbNpO0/Q8tiGc5WZzb2e/i2XYSovZiKoOCPirBiEIH3M32OaX2xUW
         zupsSvkl1iWYYI5jdtnXXDGJsf/3UznMbSdTA0W3WF/Fe9+B4btIhYuA8RI2LrcMbVcD
         OBJgT6Ggkwz3dWbynbg8eja8wlByCnqfOFBenrKFvpSsKwxKmzJ4ckR14Pb/0C5p95hL
         4yEwnkTBMCGaFYOYvS0M7RD1VOToXlInyuGn+1VQhmdvmIqVAeHthL9iR6gmFRxJWwCy
         L8DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472243; x=1758077043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0koFSnJrv2UowuMhMeqtiJIslvN7BbZv6mHXQ/mKo7A=;
        b=krbXRY5jlYV4ZT2j+/7ptDWBMlnQciutwh+Fl1urmfP+ytKhAOXEIPGzsCWVqglQOI
         CljGo3fwqJ0FD2wkAYzoUs6rfaqDuNkJYPMqTW5D85KtOl0HkpO+BG69XfEHWHf7Zu2k
         Q3MQRNzVDrwUSxktQ3AaETGO+IVAaJAdTL9SF5gX0bAZkxqxViFDphppZjkm4F83bt+/
         2451cIRbONh60Eus6FkOaIeSOy0WGma54pjQUy2SDhOLJjvadIDewBhYvwVIj1QLV+mZ
         36GkKUMbH7PSUFS9M6gqSAzdQDX6lMp0CekcXwKUHG6PNfBv3Zu5WqYrAJmNwrq/ZKOK
         ASOA==
X-Forwarded-Encrypted: i=1; AJvYcCUBO4guNkLj3HkSU2UYmytKdFDuGNIs8Pfn8xsyU3UEZaZzsOw9qGWypo2vUfLH3dhDGefrdEj3Vw==@kvack.org
X-Gm-Message-State: AOJu0YzQ/aqljVMX7l5NSMg8Cz80M2t7cMXlgqz04wHSbZaw5juzk1EH
	QjIWex+KiyPozfI4I7XPXfpSreiZgyvc+AzazrKlbxxF7QzPRlNNS74K
X-Gm-Gg: ASbGnctZyf24Tw5oIDpFE4kSAgmtv35LNtTrW9IG/gNCDebhxxHRoz/jgNnhejq1PmN
	64iyHJtOsxcdReuWVgGzGZtvHSTZV92Pd7yB4WcPfja4FGig8t/SRMP8c5vlIQlOnAQdWC+EFnu
	1Mm/hJuN17kk6C4Ty/tos7iQVlredXOuMUyR3AImBv7gKn7NzCX56as45hJ+quNZS+f9FA/7/L2
	+L3nGV4CJgytXhFNwjPs+b++gg7HwOaPwL0gkVKIXVOKnQaNq06fP223FcS2Oowqg3GJGTX1JXk
	pMv1FXPBTf2nI7uGeQbNyBmWPi8zrlBL7EftAdDVtBi52d5DcvvbjJQ/s/Yk8h50kL9hx4lDezZ
	X17Nzg20wk0mlXXeW/jpXKwEJ0DxhmUPGlRQ8
X-Google-Smtp-Source: AGHT+IHze3NqUFgqDMM+sZM9Wi/Xmfyi7sD03WA5eGHes94PFV7I4KKOuKIIQBvLXj+TekGgIh8lMA==
X-Received: by 2002:a17:90b:1e51:b0:32b:d089:5c14 with SMTP id 98e67ed59e1d1-32d440c5edfmr18323077a91.35.1757472243321;
        Tue, 09 Sep 2025 19:44:03 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dbc1c467csm201563a91.7.2025.09.09.19.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 19:43:58 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 3876D41FA3A5; Wed, 10 Sep 2025 09:43:52 +0700 (WIB)
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
Subject: [PATCH v2 03/13] Documentation: perf-security: Convert security credentials bibliography link
Date: Wed, 10 Sep 2025 09:43:18 +0700
Message-ID: <20250910024328.17911-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910024328.17911-1-bagasdotme@gmail.com>
References: <20250910024328.17911-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1135; i=bagasdotme@gmail.com; h=from:subject; bh=OYt2QegR/+u0q3CRKm7Zg38q7SY9D/3L6tdzv43Jflg=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkHnijWLH+uxHuD5TvzhcJo65MVRz8evf+ht/Kg8H3eu d3xR8redZSyMIhxMciKKbJMSuRrOr3LSORC+1pHmDmsTCBDGLg4BWAiXd8Y/pkdXvTh5u5HL7eU z3No81zweEv6gxSt+G/HWyxWsM1N7zjH8E/xHeNT5tNsutFpemIVy+M+5pasa5QSXynjZOFf2v3 OnBkA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7C0A44000A
X-Stat-Signature: keockeyr1aogop4suw5zzgf6ft8k1gk8
X-Rspam-User: 
X-HE-Tag: 1757472244-520586
X-HE-Meta: U2FsdGVkX1+TpY1MoYhs+EPf7EaM38pYmLvr2T+FI9a+e+vgY4UR7aR8Ev54kcj0Dz0e/8dsv4Hww+t0RJyXFO7wih94nyJBK5zKjXuRvKBhDGDAVudRY11QHJ/TkKutDR93Kmj8L8kuRVbEwq2X/j6BL4qm79xHnUsmbDJbPHjM/irxZ2Z4kfmoQ1OZVinUdK3JaY0TQfcdX1ceSK8bS4sUfujAa3sH1GD1WbGKy4rkrI1x6fVLVlZqvTnhCAbY079yG9krzFl/ZCT4aTqCrwR4wuHcZnxg+Vz6x689kcLoQOCFo1uLaJISORp/ZxKtLd9Z4E+hF6TrYuk0yCsiZxLj6ldkDRRcKY8Q+p4NIdQa0Xp4UeJBVFj1w3T5C9lWReql6iv1OD1d9z/3MjGVgiMdi/h4LexhiVnRL7M2vMVd+wtoqNsXfXRJ7sIsAH2TfgPw3MThGCOFb7fRGbcX0GF7tLt33mofSFYy8zNzHwLGSp1oxx0oVvIwtHftov6431Z4NKlEYVmV2VDH+zGw5WMFvNe9ASJiPfCj6b6QgYBupfUgZ++OEhaRubJhm54j6m8CD71eCRY226h79b3C90hPDT40roe1tixxm4MFfM0FRc5GAWlKtIdm2fNwEnn0v3Odg5/t3MLrP+BQDZKWIluDEk4n4ePqOhrGMyEtIhsDQ4IYo6YXSlW73U7T+KLEEHoM9Z4qZM6dSkw/pscGr6NH3swwPAw74ZEEa0zydEajLKr9GcrQS6dFnUD0btYh+D9Rudvdra8EhvXgFmYYNO9cBIvEWlW9K6FH+qZ1STpPjiD5a3z6nUjkJ/tjNucqCqd8uNwno7vaY4xgnAqgmxQDADghQmCzkuuasnR3wXFlo7Fqd6KtC+EGCiTG08FVePuUcQfE2cqNmJI5CGjOOhbPVHz18envBC46xX7BKiIKulxGLpVyrfHm313QfVP/5+MriQXPgCKHzbVu8B5
 FpOWtUR4
 yhNN1RAZRj2lKjFjiM8VHfWXvpjn+/s3l9IikVQHY8HfGVrpZ5d8j1osjs86JaAO0HssQAD3o/+/yl3egafpoL/ODfVZSHcUZ7gJ/t3SNspcbp9gBnGQJYYpsfQ7CcNm8zYvdPpjta//m7x+e1DzBP6xaauF7aQKCOyPfExXDY2KpkjPd+XT4NaACVXVGfORLbu3lm4WQ3GC/rr8GZv3WFVRCsG/R8EGAdxE5PrCzcfh3/TXP1JgxVZei3rmL2bx1q5bG/1Y1J5w25zJj/yBP/Gfs+UV1sYRx979tWIW9zWOXcdI9juIEuNPvBR+/CQJDBGz0U28R1FC8y1YbjAcdJKx+fv5MbyxXw++2NdeX2e0OidMGTCWIrIlHUUYrhkJyhwR1o3788XvIXC4rU8OWgkaYUfxRwD1hydYs18aE9BaEG+UGqoVOYcTB1KGBBHvdCuvy/U1e64QWZXFoPavfAmXccYNj5I7+swkdDcU2kHCYzMJIizNbZmj+6ZsCvj2IneRtFa6nF6t+HGKFJ8Fi7EriMZLh/DYfyfEbdQEtsZgrX8GHHo8K5YSkNkYgrSVQ89RmH0jFSl7o3hrYFJgoISMPONDwNO17sP8OTm+fq3LPiJSQCIfbodlHT2pIw90mHdr8XNDO4BP5NTkw+t2gMEM5VN2kOgNE5YaGveeF1OZYovkKtPxl3xhj/b7FbXb765lyR3mB/e+E1S/1LT4jZG6LeWG8qc1CqTv/R+fQh0tUbjn2eolmSeFoWZCjQynj0o50M+CKUvdlm/32E/3lNL00d8eQI6dI0UgyC4l83YkL0lqDDktgFFsJVTASe47G48fjg+mBY1AKRmKyzQRc36PDQT2Uz/LrDgaGS2I1opADp+9FH8hyxi3Z5N4QiyHgrq4M15cVbBeylBXQ7818EboQbXYvUflDo/ld
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use internal cross-reference for bibliography link to security
credentials docs.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/perf-security.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/perf-security.rst b/Documentation/admin-guide/perf-security.rst
index 34aa334320cad3..ec308e00771427 100644
--- a/Documentation/admin-guide/perf-security.rst
+++ b/Documentation/admin-guide/perf-security.rst
@@ -311,7 +311,7 @@ Bibliography
 .. [2] `<http://man7.org/linux/man-pages/man2/perf_event_open.2.html>`_
 .. [3] `<http://web.eece.maine.edu/~vweaver/projects/perf_events/>`_
 .. [4] `<https://perf.wiki.kernel.org/index.php/Main_Page>`_
-.. [5] `<https://www.kernel.org/doc/html/latest/security/credentials.html>`_
+.. [5] Documentation/security/credentials.rst
 .. [6] `<http://man7.org/linux/man-pages/man7/capabilities.7.html>`_
 .. [7] `<http://man7.org/linux/man-pages/man2/ptrace.2.html>`_
 .. [8] `<https://en.wikipedia.org/wiki/Hardware_performance_counter>`_
-- 
An old man doll... just what I always wanted! - Clara


