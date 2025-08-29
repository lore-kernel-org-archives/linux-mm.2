Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9929CA1000
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 07:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5C68E0008; Fri, 29 Aug 2025 03:55:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 018398E0007; Fri, 29 Aug 2025 03:55:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB5D8E0008; Fri, 29 Aug 2025 03:55:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C723E8E0007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:55:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90A4613A23D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:45 +0000 (UTC)
X-FDA: 83829035850.06.B4DBF90
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id AF3181A0002
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jImUppFd;
	spf=pass (imf19.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756454143; a=rsa-sha256;
	cv=none;
	b=ZI/7d6C2kC8+z/EL7qXK9R4UN4HtK9sm7dxkR3qgcjf8J0mnkOs6UlM+ILM9eDupMbqwF7
	olQQ/ZdKSsh0FecP/HxEhY774aXZfdmE9XpI7N8qp4VsfoKNvyMDa3SGTXrKOxlpli+a0b
	CledBwovtNO6L4JsH1DvnUljCJ5XzCU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jImUppFd;
	spf=pass (imf19.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756454143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exY9byyl4etH+4IQEKnm6qXO5lYPceGxvCuurSN7fh0=;
	b=vzS9WojZSfSbIQQmy3aUjpVF5nRR9v7UYpW3FFA/qx68Tdqb2w3Y8YKfMNiSiy6Cpd0G1a
	FiWVVAO/jOldv+X516Od9YiSM8RIrFTFcpAtoqgZTrvccB3vBa8hnnYk4uS/KnyZsuH+RR
	KpEcQNVTkOAC1Qg3QRjPVqqGwfsVVHw=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so1944879b3a.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756454142; x=1757058942; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=exY9byyl4etH+4IQEKnm6qXO5lYPceGxvCuurSN7fh0=;
        b=jImUppFdt2EmTyGeCtdUR2Seg4HH1ALHYBrfMzkz4f08etN1fpzS3HXvHWk7FREOjF
         0NpBwZCTb9IPupz8bFoPd0rOPOyvfezRpuvWoOvuFSv8VsQaeqwZpP1xB1sTa1+6IOMt
         ooZYJy1SVWuaV6BsiBIlrRiinTyi133GhZHh/xO9wP+9okfF/VyDgprIeESx6UwCzjXT
         2o30Ct213CINyHKXVbeL9h4DnBJtaVJx46aR5Sa4ZvhsOooHrX6udhCTI+DZEVv8OchV
         y6gsku6EkOfvgYtVlUPLyt47kok+J60cACmVhFU3PoRzjDb3ZblwR6Wu+g1ye0I6WPZ4
         lhfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756454142; x=1757058942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=exY9byyl4etH+4IQEKnm6qXO5lYPceGxvCuurSN7fh0=;
        b=lXyXz15qwr40XrchXzivMY5jzhKt6LpGlKyEM4dF+sjTS2bSBNNaJDzcdLMSTdZxlj
         8gxL4D9d0z6MaL4lQGhte9U866FxyZhljL+GPh6R9mgWCs7+zYFPKilCeo54KUk/LVTb
         UEre/r+be5+8LDcjDr12M118WKpYkhNuRCnCZoxIkcRciwrUP12A5JQR6jOuPRzf0Nwi
         K+hLep5HU0jSPiuzPwSKv1pp0C1PfHQEx/e7hHedxaO9XvaMZfcvoJ7cc9OrxU3Spki7
         iSCIT0DWn5NVyMEqla56AE7gcZAEzz4z6rsf8Kz30/JGZ27sKr3RJCaFi0ghMUV9OrV3
         f2nw==
X-Forwarded-Encrypted: i=1; AJvYcCW8o8GqzZad1EDAZ/xV1kGRPr56KhFqNAJZ2o2rji7ExsTMaTzvbdW8UVbXWb3wYEikWtjTyHjzIQ==@kvack.org
X-Gm-Message-State: AOJu0YxthAx/QgFyk8vzBoXMWt0SVmLCI0QDAAFaeFndk8zergU2j3Sg
	bUaeAtLdFq+DXC8R4t+Dtja9DeCPfAy53Ye1Waqm2/5R+3e0hAEiO5xD
X-Gm-Gg: ASbGncvBf6I0fHTDjZ7KIdVJGQMOsqp7kykxmCjFoxRHY2izj+2Bw8CJzrM1MosW7Xh
	sBrYFY5FH4qqea8yB42mz8nR0CXRhDq+uScpGHMgiDWVkDwCDTjvmHad2vP+GQfT0VKWojUWKZs
	YpCDdySCgYtXBQJJwO0hIWQc3skXCLGxZZ5IYdkmIWXs/Mx6USy1ahaDUxhbXt7NEj8FgRopPXR
	0/IGzMpjQnD/EIaOpZttkWlMk0aLWj7woZvGAKBk/WH8OFk78xL6LMKuVnHm6kRJfNTH0nZn8ih
	bLlBXVQwkg2FxYoyktPITPBsiEDY6nBjvVgEuQ1Xr6lnc6LbFcmegoDdvHXWNz2wy+vCHzi8eEy
	v1AfN3d4HFSdKJorHfj31TYdzoJ7evdn3T5XWeObi166Gtjk=
X-Google-Smtp-Source: AGHT+IGl2H1cpKBrzVIc01ALD2l+GqNGGEJdm0M1vP0Ajl0ap9rVA4eE5ntn2ncpRPD9DtXSzK3gDA==
X-Received: by 2002:a05:6a20:1585:b0:232:7c7b:1c7b with SMTP id adf61e73a8af0-24340c429e2mr42540329637.14.1756454142509;
        Fri, 29 Aug 2025 00:55:42 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a2aaa70sm1550930b3a.24.2025.08.29.00.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 00:55:37 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 7A9CF44808EB; Fri, 29 Aug 2025 14:55:27 +0700 (WIB)
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
Subject: [PATCH 05/14] Documentation: blk-mq: Convert block layer docs external links
Date: Fri, 29 Aug 2025 14:55:15 +0700
Message-ID: <20250829075524.45635-6-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829075524.45635-1-bagasdotme@gmail.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2751; i=bagasdotme@gmail.com; h=from:subject; bh=7QXrNRuCbHeHgCYdGUN3dSXlo+bJ6ZwXyeTt5Kf+8Ys=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkbY17q3TFftH6q+kyOiIzsCLYVR/ZOd/GUnnS+Yu6/k 6t6/fl6OkpZGMS4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjARpWqGfwYJyctD8hT/NwY/ sO81mNZXoe/tpx8864flkqYm66Aruxn+V81fprfBrut+sv/0I1K75vi+e3t4WtGyeRzBVy1DeSv K+QE=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AF3181A0002
X-Stat-Signature: 16tieh3yyk9cboij5p4ztz4j7bp5ga3x
X-Rspam-User: 
X-HE-Tag: 1756454143-379536
X-HE-Meta: U2FsdGVkX19BZYcqkyahh9aChwgRkasXw4yAHrB1PLAbmqeHTEug5iI+dXYMp+H79aASY6AH5sKa2xbd127EiezkFvzWKm2q7r3qjjd9rhUfMQsfg545tzhZCRrj2Ay9Sakf/C0t91+vq/RSAYuSJWxAVydrEkQe1GnBDsGTxf+VHZJHLN9CHIiEaS6BTFEFJnP+OjSIhjet5MIh7aes0GtcWhZHe+kW/ff4Qd+3msdNxn/wSOU9ym/XmE410NnwLJGAw4bo7iHCIJ+xH1KjnkzEFz/B1IPBGQDeWajsUft71o6UCUaa7JPMv46DbiPgysgCLg60mWsTVbhCadHyGgpriAxymznhLy8fp4ciK9ckutaO+LAA+6aBe6MZpRpHTBO3K0d4O+ZgUUs+A+IGe2AP0QqX4rAbg223hFlamzg37/ufbpl40eVhaxMF7A7/NbVZ+GRSSHd5g1bswpLPlTo5ya45bCU+gGEUj5jN7nYU29Q63hqLTN1QyK24akoTw8fxkm7PGFwptGQZ5b7T5Br8SnXC7KNO2ohfndmgcUEtrtMnkME44sWIWdSIZfLGUbA5oYHJm7O5LibHg7maOkTG1okrmpVdMndQqFt3D054UxJEJsADOJI2431sPw2TTRJ9/Pis0H/g19CZ5H3KB3jox6kJ7v/c+OO4bdK6uBzEO74prrFzttHeqE9LEEcqL7Lscva1Aiao5C0YlzEOYLJju6zqTRj+VZ55tDY1r6PYLknLRTKJOEuZoh4bFrGiT/8uk5Y3HtbwD7AE6Jt9QLZFbk1BTCGdrQnA/ECsa7q7qWBmaK6TAdTYX+42tioPDT3Hx3r3eDhLEHOS0tcEkEOkGN+QXp08yWk4x5nhPegSBZGvr1Xu68PJyshfrQtZSPagHOOrlGh/KbkZ/VRcO6EzVNNN6X3HAnKfBCQhINuJqpvu48Sx+5P+9x0W7nrCEx4RJ4hVglY6ZUINDZD
 RpuDmFkZ
 NxxODKFM7jws5EPrNERqFikVwJwPuFXT0CZvcLZTTXDT/yCBkBLc/pOFlyTufTmGlSNrwqFHkCaWO9q3y60NhiZB5cYXZrWIQkNdSO6yK/EoccujSpfaTYsWeyKB9TCaNjFf8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert external links to block layer docs to use internal linking.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/block/blk-mq.rst | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/Documentation/block/blk-mq.rst b/Documentation/block/blk-mq.rst
index fc06761b6ea906..4d511feda39cfd 100644
--- a/Documentation/block/blk-mq.rst
+++ b/Documentation/block/blk-mq.rst
@@ -87,17 +87,16 @@ IO Schedulers
 There are several schedulers implemented by the block layer, each one following
 a heuristic to improve the IO performance. They are "pluggable" (as in plug
 and play), in the sense of they can be selected at run time using sysfs. You
-can read more about Linux's IO schedulers `here
-<https://www.kernel.org/doc/html/latest/block/index.html>`_. The scheduling
-happens only between requests in the same queue, so it is not possible to merge
-requests from different queues, otherwise there would be cache trashing and a
-need to have a lock for each queue. After the scheduling, the requests are
-eligible to be sent to the hardware. One of the possible schedulers to be
-selected is the NONE scheduler, the most straightforward one. It will just
-place requests on whatever software queue the process is running on, without
-any reordering. When the device starts processing requests in the hardware
-queue (a.k.a. run the hardware queue), the software queues mapped to that
-hardware queue will be drained in sequence according to their mapping.
+can read more about Linux's IO schedulers at Documentation/block/index.rst.
+The scheduling happens only between requests in the same queue, so it is not
+possible to merge requests from different queues, otherwise there would be
+cache trashing and a need to have a lock for each queue. After the scheduling,
+the requests are eligible to be sent to the hardware. One of the possible
+schedulers to be selected is the NONE scheduler, the most straightforward one.
+It will just place requests on whatever software queue the process is running
+on, without any reordering. When the device starts processing requests in the
+hardware queue (a.k.a. run the hardware queue), the software queues mapped to
+that hardware queue will be drained in sequence according to their mapping.
 
 Hardware dispatch queues
 ~~~~~~~~~~~~~~~~~~~~~~~~
@@ -143,7 +142,7 @@ Further reading
 
 - `NOOP scheduler <https://en.wikipedia.org/wiki/Noop_scheduler>`_
 
-- `Null block device driver <https://www.kernel.org/doc/html/latest/block/null_blk.html>`_
+- Documentation/block/null_blk.rst
 
 Source code documentation
 =========================
-- 
An old man doll... just what I always wanted! - Clara


