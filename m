Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F0D8CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8188E0015; Tue,  9 Sep 2025 22:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3FB68E0016; Tue,  9 Sep 2025 22:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC848E0015; Tue,  9 Sep 2025 22:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 559A28E0013
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:44:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1CFAD140728
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:44:11 +0000 (UTC)
X-FDA: 83871796302.22.3205A88
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id 168002000B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:44:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BYb2hQoG;
	spf=pass (imf03.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kNx/lgQaweLHCKpOd5HxLBg5NtnJ9f3nOi2hx/97zs=;
	b=HQ0ivaIkAUEkjH9jQ45GOQGZ53v5uBS/uKiXM6fHEBqdcvHtgiQNk1VFKD5TNSQKlodoO0
	mEDXp4P9ld52FPB2kIKAH+7wmzX54Fn6ugj2CKAzwGBvu2NccMZSk+3TmoqyxU1ajWQ9H0
	UQJJ6OeKgqMcqWKCI8B3G/pNGyJ3idQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472249; a=rsa-sha256;
	cv=none;
	b=jaFiy+9NJYJfJm9XL20uNxz+q1n/b1IvuWLpFC0DKs4D/vR3IRv0QPfyQ2sn9Q52HduYPM
	u5OrCHze9pnxO1xeNFTy1C6Z6P0Zg2LI+mXZiz2WgJTi0ci/NzfZuZ/S/4e+FOqCdYFAem
	VyA8uJBT4ahOw2VlCMPSCz2c1kwziCw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BYb2hQoG;
	spf=pass (imf03.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7723f0924a3so8283274b3a.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472248; x=1758077048; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kNx/lgQaweLHCKpOd5HxLBg5NtnJ9f3nOi2hx/97zs=;
        b=BYb2hQoG3/BfDYzjEcu3D1r9wikL3N3+hm70bl1ymIyhSObz7AIPntvGPVsMFA3cfJ
         PLBxYszHgl+P38Pf5mxU4oqHzWT3cxvDgwYP16YstjIlF1OwQfRhBLSeg4L3r1bbaxBG
         xh1C2OZXssUlumYbHNMLBr1R+TSCDbEUrdF4UyDKw7K0RIfVFpdQaA+GHMLau/en9ehU
         oDHC8/DX5MJ3bLkJSdydra0QaF8sM6fxxvjiCU7rIZ4CZuFWq0o5pHzeGMoaXxS+6b8D
         N5O8dj09Szk5LtBPPK3O9AR7KvnLbeC7G9pkyJ37/DNTATlBD4rPBUbOw+dCJczZ9i+t
         U+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472248; x=1758077048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2kNx/lgQaweLHCKpOd5HxLBg5NtnJ9f3nOi2hx/97zs=;
        b=dFYqqAVuuy0LYWvWZkYwZluT04K5S2yWTGEy8wgNoXxd9zlAfYWxxB7lc4LCyxHYOi
         YpSg4bPpXrSJPO90eTZqQcD6dL5Zs6pU5Q/cQNpCwwjjvCDcH7LVREbVoB328Z29vvOz
         SWDU4LH0MNyhS1ddh6aCvZSErGpnMnvbExtf1sbuii7axRkBMPD4KnDtZ4JnNgpNsMW2
         YjFGRC3Fguxu7jTWTBbYZ8pXordamKotEjvv14yCUGpE9FYiz1MW10cY4l1IUJ7UPvsy
         +HZOrfH+4I+L8q0u68xVCcjgKcsKbc4c+xmAWHwByVD5ibYD7Bk/2KD1BrtYSXgbDo6R
         7+EA==
X-Forwarded-Encrypted: i=1; AJvYcCXIwLhg89SD/Hqema41kD3Y+l3GLElj2qVAGpvG4fGcI63D+05Yyz/AOlg44Z6oEV65SWil3p6ndQ==@kvack.org
X-Gm-Message-State: AOJu0Yxq2VCG2nolZGv/LnVvqPs/WeAUxCFW183vmXyLXSj0Q+ETV+aG
	LdH+d+/O2Z6f7Sl8oPVZWZteKWDn6luXuU3esQUa1rMXx8fPqgYnjcZT
X-Gm-Gg: ASbGncvW1AmFcfzOZt7D0Ali+r8b9wAQ/TXGZUTMrUHQifXs/vmZN+tw8yiHHwcJSyS
	SXmxKK9qEnSCad/E98zn2KOI45ZEPdBcpvda/77tj7suMQpFXVQsskbrpvpcEowXZKiKJGkk0ea
	FmZnVc2pd312YJyIvscighHqcNsEEzOzQQDEzZAmKXcFpMTeZBDGbnAuoqxwua+wCVp1T1HwENS
	xdFx5dzbRhTEDmDZOMxziOGEX1HWI8804vSQAuOS9LWNrMeF0/Lq5MiyIOyXu2cko7zriV/HTul
	biKsjSINVRjlsmqBE9Mi4EH+4XhVRSiFVd5YdmnmdAe2f3yv5QMbVQCYzVv3/kcRDC6T5gfzf03
	nPpPGL88Bnb4POFk27eyREmapUA==
X-Google-Smtp-Source: AGHT+IEyED1mSm10/nBWu/PDugDe2kHeGr2B1Dlm/0Mxg3VMmmsn8EtrKKBRn8Kt1DMp+jVk5SErrA==
X-Received: by 2002:a05:6a21:998d:b0:24e:e270:2f5d with SMTP id adf61e73a8af0-2534547a6fbmr21436774637.43.1757472247740;
        Tue, 09 Sep 2025 19:44:07 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b548a6bbc9fsm1061117a12.43.2025.09.09.19.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 19:44:03 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 999D241BEA9D; Wed, 10 Sep 2025 09:43:52 +0700 (WIB)
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
Subject: [PATCH v2 07/13] Documentation: kasan: Use internal link to kunit
Date: Wed, 10 Sep 2025 09:43:22 +0700
Message-ID: <20250910024328.17911-8-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910024328.17911-1-bagasdotme@gmail.com>
References: <20250910024328.17911-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1129; i=bagasdotme@gmail.com; h=from:subject; bh=yEY9P3BA6E4kqaGTHyjuJlgmOOGj2m2ZOET4fPd8xcs=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkHnihdUeC/XH99x9zD0/p/z/9z+OvEiwfuXjriUbHJw 5Al4fDvwo5SFgYxLgZZMUWWSYl8Tad3GYlcaF/rCDOHlQlkCAMXpwBMpGYSI8Phu5uLfVhjJryT C+XOkO/82KnH+HRZtlehgA+3hxWLXwPDX5ny7U3LZzLMPNBzWixMoIP59nkt/0fGhV4ZjM5rXH1 d+AA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 168002000B
X-Stat-Signature: jtg576aa34m1h561793u4g1njq6rw4o3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757472248-61151
X-HE-Meta: U2FsdGVkX1+9VJBD4zQIlfI1/KkKxSZSH+PRdOQuub/RWNacQHXOAvTxW8KeTcPFg2PV2ZPPq8aQNp3OKp/M+Z8lQK+ynQCk8c8jW1zJMrdKWeaX5uWgF4stZMIG+fP1hUiB+gp43B/bXM+o6eKmBOyGx+wv08Zib84wKTXbKHTKMA/0MM9Ts+xSoM4FsF4eYrRmJHRiZalOvbNv9aqYyeEifIxhyAShCtPRYFqEl2dGFFiIfAt7ciCm9dKFMaVB19NdV4P0oBNldoHcMVfLBs1XLmftQbB+YHWgEVw2WW93piwp5N+0ExRp9mtZIFVr8/W3oSnUwdBTsKQEMzvjOJK6LSkz6UVawoy4Zi7dDGUi9xbAe3+R7SHTXveL2Vkr+1PjmIneiBkzBD1oQaCC5RM97Wk0UyjnsONeqUHks8iN/c/qO2OllLcSkgUkOL6ME9w1XrlklUptDbu3YGPqiVlpR06QH1evCVNkiW2UfLdK5K5lHpxkcRGFlI3t8rcMXru6zEnWRogPnAYDpKrG2kCy5YZ+Eccwndzh4zqMHHWabhW0omqhUaJcTUyDIOZb9SxL/V1iC32y5Nu2bPRsaFTXuhbK1mQpNmMui5eVoWlExOG//9QRnDf2kTUpYX6ybrP2BbfzzDa2ijhSE8ZM1wm6jpbGs+4nr5r/DViTzPbYT1RDbrqfBCMLQm+cbYTu/I9yFWBcYVDTaqnOlLU0TcrkjgyT9wcWEoNOxkpCIgRxBPRUwDiQQKWXPu6kHFmluJy2utz7uQ3NMnqxEJEvIcDcKyA8OItk3KQQIjNP/PRgWXmXtVnqujOf5SDuMqiyUvErYldFxpd15VBZg80carV/Vt3oNA/PhVm0fR0iLZ3/j9gGj/XVTO3+W+iovwxF3fWsWZuzb/OfhygYe0/EFvIGkIv1Y+4sOPSCm2EcU0IO1KvZTTq3UURLiuWS8fezCOZ+xRa2FEHxX6rfCSw
 G799HrZ/
 +XpIt/r6Fjb1eVrn4cdkVebiGxFvXR2V4znlGoQU/F9BSHyOVFglKqGqr8r5kG0klZbleA2Qth8+p/yvNfd+ne8ZUZlqdO0fuV7NQeruwle7HfLDoMA+YHOP5Xy4D9OYTpHopK+o/vSYpGHOugo06WROf6O2QViKQlJR0GqtxAMxYXf+lAjIUEx1zYuwz/09QyolZPNeRQgc2SDGege8ujQQmN6WIij/kH6j/xBcHB/j+9esG3NQGNxZHbsJ1kXolThCC9yNEJ4dShaEXKiSC2HZNZHGyWkCSxUXKLPZyrkzzkF1wzqecuS9J7S7naI3sZ1mcqHyiw0VKMElhUnV4KCO2h9XJwHzimS3oktFhK91PkD9WZuLCl5Q7MLUe6qx2vHWNS+i//71LGgjHe+clxeIZEELCgQVXDJpx5GQnPvUo/9IsAQIzEAQU5O14HrofVM92tKBAwkCI48iFkdFZvtVfv/YayJtweaJC+3/Xeg0WMDPK614Gyuoa+JCSfYDRbIPBnWuJftoWdR2KLeTbsPT1zmTUToHJrAzoVKDiOfBxkQo8uSWwBZwuI0HC2bR0uxAr8EAdky5GwrSbHraw81FD/EQ0YeGfZiyH
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


