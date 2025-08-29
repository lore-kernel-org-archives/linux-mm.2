Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61866CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 07:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 178548E0006; Fri, 29 Aug 2025 03:55:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103538E0001; Fri, 29 Aug 2025 03:55:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70C48E0006; Fri, 29 Aug 2025 03:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D0FD38E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:55:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5AFDE1405CD
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:40 +0000 (UTC)
X-FDA: 83829035640.29.C3D81F4
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 834A118000F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YP+g+lOf;
	spf=pass (imf24.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756454138; a=rsa-sha256;
	cv=none;
	b=YMpQfD0yD3Qb12ApblYAjBlwirUHC6QUn2B5xOeMSKShI+8Ev+4jmd01sALtFreLp2s2VH
	FndV06XS2/FDGXAWNtk5VxBbR2GVbsGgDTGTjLBOmDPfnOmfrBZ/8q6UcjoGGPSPXjlt70
	swhbZPUyEbuJt475KsfPO//oDXlZYFw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YP+g+lOf;
	spf=pass (imf24.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756454138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0koFSnJrv2UowuMhMeqtiJIslvN7BbZv6mHXQ/mKo7A=;
	b=1lcm8IHgX4zuPPrBcRO3WwaIxmDkwOf7efsvNqDt28gP8WvCaJ4QyKKKXZpAme6cZKXEpa
	5IWPbvrDmvEpjqGvJOPfROdT+KG5MnQQJ7RmnI0gd0eztiClgrZjfOPrQytEitLUQ3vnYl
	mX7lgK2IVbEaS70Fv/PmjMTT4mq9XMU=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-244580523a0so18917615ad.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756454137; x=1757058937; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0koFSnJrv2UowuMhMeqtiJIslvN7BbZv6mHXQ/mKo7A=;
        b=YP+g+lOfxZ2xpntYIeICby3FDthwGqqY9fsvZXf6gP9f2bNsMEx97mrZaZ4F3a8nyg
         ZFXgzS9tD0hXF3xT/9AWu96222HlBdzaPhudTHlth24Eu51b6OYVzU9it5fji+6YnuWe
         FlOPtAwL18EFMKrRRmayBsf9LJr+UgC8jUhpQLXVSO4wRFTjfET6xxBCf/xRceXuwKKM
         JqQ2BQuRAuHxRWvqCJgv9HXd355z7vqLQil6o1SPsrfxcCkOt5R7PraO4ZYJ0toBpbLq
         MHwfWQx8/ZLsJ3YEdahR0TV9crLqiAuuxFxyFAHowMVaunH09l9FNO+UBl/WTPxoEMCG
         fMBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756454137; x=1757058937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0koFSnJrv2UowuMhMeqtiJIslvN7BbZv6mHXQ/mKo7A=;
        b=MuxWKKggY2ZDgqtvUx8MNpSoQri2BDuxPRNLHC8j4fNRD739EXfg/LEOq8Pcz5sqFi
         cXi0wkPleOROYAN67VpgSGza9E0NnC706gB4dog1agcOY9Zp0DG06NSIhZ1IGex8fCZa
         JE2sgCYRK7LXXu3pL1cLJdDmVDLek2ltGdQOBFVu2fCIYN1ToYEQfNKulkpsBSsIHcIk
         NT+zJBkF/0lH0Q+5B7FttWpa3vIYTQyK3N02rnahU/u3/TOyPHUvyoSJBZnItriltsW2
         HO7HhUI3a0R34Hs+nTg0wKrPvI3nRL7yTGI3MNdpP04tqPdLd6CUAu+nVFsJ74UkcBCE
         gZpg==
X-Forwarded-Encrypted: i=1; AJvYcCUiy34nxc8gpyHxiXhroL+u7nOd29NjkuN6AWuCY1DBv6G183QsewCRSrm4SnWsxGNpgQL2j8EhtA==@kvack.org
X-Gm-Message-State: AOJu0YzWH28q1Wu/sGpN6kGfIV/hzIiLmwHpKDDAhy8l3YTUJOw6U9uf
	S6oevBkpaROno+LvKelemnr1HHYOuGSB1qULXMaE5ETsF9jWPwq557df
X-Gm-Gg: ASbGncurlWvDgbrw8rwUcvtuumrTvSsiSlI8FtOG4qmf7jAXwNRzXDd5Od356rXMNK5
	RjaPK+L48Ks83NWaIlOL7qxWaf65hGjfyLIuodPP8nWCffhbVYs7juBjfovBoh+V5RqN9bUwEBa
	EfK0iHz1ZJ/rDthzmsJkdlexGhtaYhTvhmNmV4/ALx9AiiIlbODY1/uVuBpau3++XDKSFvo4M/W
	7lNgBUD6npxK6EJfKbFsW/0m+qmNPRLvsk8xN2SI4mxc7Ss7AeYhzAwC7mqhLdO5lWwG4fGKhGb
	psdTI1hx+RunGm0Bf6GswzgntBeo4nGMJYuH66cL7Yllu/k/hyFsLi/+0DZRBpHXnROEkDHc0dv
	e3A10OhAe8hTYPogD8PrpH1KerQ==
X-Google-Smtp-Source: AGHT+IGNjBdTFArxVwVJhrEyw48u+wDRa+YP0G1KaeCtmArj8lT7+bi74vyrPcJB8r8IUDLpPVmmVA==
X-Received: by 2002:a17:902:e888:b0:240:a54e:21a0 with SMTP id d9443c01a7336-2462ee13154mr358734785ad.19.1756454137188;
        Fri, 29 Aug 2025 00:55:37 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24905da26b9sm16688215ad.93.2025.08.29.00.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 00:55:35 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 2F80944808DE; Fri, 29 Aug 2025 14:55:27 +0700 (WIB)
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
Subject: [PATCH 03/14] Documentation: perf-security: Convert security credentials bibliography link
Date: Fri, 29 Aug 2025 14:55:13 +0700
Message-ID: <20250829075524.45635-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829075524.45635-1-bagasdotme@gmail.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1135; i=bagasdotme@gmail.com; h=from:subject; bh=OYt2QegR/+u0q3CRKm7Zg38q7SY9D/3L6tdzv43Jflg=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkbY17WLH+uxHuD5TvzhcJo65MVRz8evf+ht/Kg8H3eu d3xR8redZSyMIhxMciKKbJMSuRrOr3LSORC+1pHmDmsTCBDGLg4BeAmZzL8r1qVsXFN0aQnhlcd HbX/7Z5y0OBc87cVSY827u/OC7GTfMTI8J1f/vkt1YY1nGfMLy+IOlnmXaYQu3XLZy7bCT/2T+u /xQUA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 834A118000F
X-Stat-Signature: 8qtxszgsqdb7y79wqj6fc4nt44gdmerw
X-Rspam-User: 
X-HE-Tag: 1756454138-738523
X-HE-Meta: U2FsdGVkX185HnOwxl5O2exXyCB5SCqEiW9ov44Eg5DI4h+pTgCQX204Oxz8xa8Qvz3BH/3n9an1V9XTtQqC9D9I3ra5FsOJE19xe6rZp3Xbocume2x6K27GJqPpbZQdiAs4EIy5K3AwwMJjFNFc6CMzfyBGxB5qnVnukapftFR+L0Vjczb9AGSd5CkhPpQ5gfSSE/46GqOQ//tUaPc/2+mvFLtEx3/ph7NPOq8TPuMgfuvNtz51UDpbH0vMKa3iH6z51YMPXRoAOKwfcM9C5NV52pVniD57YOpm5a7CrePORgU6z4+3HjA2O05BzdheK2Y1ydyVHDu6z0vHOqA92VadLCnCjj3dFerFtJvSrjmIZbmE5c8eMZ8pSx/paUJaET6szu3/QpfdwE/I0fOuEcYowGhRliIdAm+cYm++1CntJwHeWkUlxJ/FCRoVHvPC9coeEZJEf+pDKJ4ejR6Qj4+8mvSMczZA5/vVU5dxWYr2egaQt2u1nVOXtB9uvSBaiFs6+CF+z3WVcCwiAbZqXYD4ppZQXlUuVjw7IFaDk+qs3gJy9cZa6V7Y2AbzO1zxFYadcoyjf8I+msXHjjunVGbfxBlXuz1VmSUUsN4FPYKUbmvZa/hZ/kdYYPXP/EuybXt4kIs8cnKiNtWPG6iqzrqjS0BnrK4/pkiGqPg1dfJv8okzbM8hI1JPhqmv/l9FACy0gt6S3A6HXRr6NAQGcn6PcrqSaUaoM7SiijchDs7WE2/DGdb8L7iP75qre0iq8/2/bXCGGTbsuWtuiO8tE7K/ZaeIb/hokIsoWl9RFwxFZ1rZ3zsdwF+5thi4OnWSxkJifEqVuNBDRQEHJTmEp79Y2Yvj073tN6e0tzCiKmEbm+CA6nI1Bt3hONcuh14GGDt1B4QGKVLTQffRggijXw5zSDyau82zj+4sy1DbHMfb6n/oIh34sNiRdTDcDUMjMoyrTR/O34IkK0GdV+z
 2DF9fInQ
 7QvAVwNg3E0NFfD0PA4UQykt60rlJgF6tthkSlvynU6R3NYzUIk2hMMhFEFhh6lRCgsP82VORNnO3PtdaVEYZemKjlJK/C0uGcdFk1k/ILpUNV0gzg7vMflUo9Kwu6JmsFE4q
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


