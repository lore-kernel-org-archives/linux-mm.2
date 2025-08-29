Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E209C8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 07:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8097D8E0009; Fri, 29 Aug 2025 03:55:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7920F8E0007; Fri, 29 Aug 2025 03:55:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5518E0009; Fri, 29 Aug 2025 03:55:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 427908E0007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:55:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DCCCA85103
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:45 +0000 (UTC)
X-FDA: 83829035850.19.7B6414E
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id D39E51C0005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Do+PF+Qe;
	spf=pass (imf18.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756454143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rNDvUkQSM5YXWXIzm38SWG/hRRo/bsx6SYKE7k7lSmY=;
	b=5fRuEs4HB/cMksT9OghC9dpE+7zt+Fen32Ays6mUSqZaf4CenhtZsFXtiuaIqGqdNSD91U
	MnWZr+b+q4Us7iJ8MBH5IB+zqis/cNyeZKxIDY6q1id1RVt08ztkxCjjRhxUZuQTOaUKii
	I85cxayf6MzoMeXLjWgkoYEdLC6K8Ro=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Do+PF+Qe;
	spf=pass (imf18.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756454143; a=rsa-sha256;
	cv=none;
	b=ZLnqwbuYdHLJdiED6/CdL3y2qyOEgr3il+HNVZa/bmgAPw8riH/G2iRI2mOv4I/II8AqUT
	L6eLzOAc6j8knusHzlyBfiI374/GT9WpjI0uRGR4+l0Yv5JzBRlNfHcwpTPbYpctTQcNjL
	/uTucPekNr8stgnZErNa6SS9RMtvnJc=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-32326e2f0b3so1482216a91.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756454143; x=1757058943; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNDvUkQSM5YXWXIzm38SWG/hRRo/bsx6SYKE7k7lSmY=;
        b=Do+PF+QeZR/veNPJp1b6yTuYJ0CVkMXdcnwbQdEx3rw7j7Ik1ap4StovUMI9coHWgp
         zghJxoJHOWog3sAOvqEqCbRytyQx+vcHMh1DtqQmEInim6qKg/esO4uiycGXQCWCtwDg
         NmJDdf1h7IJoBfTaxwJAiU9MEf5xGmYKDo8pL4PhYrxRHaAKKfFaRVYIJe0HyYxNMHZe
         cuQ4kCsV6zomYECqttZjwNKa0xYwn17c6wKegXXvMQ+3ud+iQThz2pTD5zpwBFfloeHN
         VejfsCe4ybpoUsCB83+XIyQNBTc5xzfk2bx4uADYj3IcWKuw6ohNVvgBZja574Gmea2U
         XB+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756454143; x=1757058943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rNDvUkQSM5YXWXIzm38SWG/hRRo/bsx6SYKE7k7lSmY=;
        b=LHBJFsr0x++7VVpe5JUBMsMs1H1HFdKfgh9InBu11nJCBTAn8RHgn6sqgq9NIKFH/B
         WX6mfjZbkTeaZ5YFcJMoVpztHEjWrdz2tIT06RbNp+VVLuAhlfD/WWkwwPAxguw9g9qG
         juqjbnRry/LaLURCLkRa5JQ+u0s9Zw2hwpbkCoxNnQHQWCGdEdJxmcjPtFW2WiS4fSv4
         ooVtIkrCIBIEWaWMUXr6v43mE45fs+hDdFIFBL2qDYBea5WHYUEUI6Pr2W8pd7nXukzS
         GJCrNwtFy2qX/eWV3GSjAknH+tCbeR6F0An1yrq38FK32fashSTc8MyYb2ZAoomIIDVq
         jU/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXhMqSrnfrVQeRbu/Q0BPN2ZgL1GxpsHOHANW032H/gERUSV1I9LvAiEyIzuOij4X1DxTq52+1lbQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9rL/J4ZzKQ9EN2fSaRIjnl0sbb6tMM/gTsoCEl8FtBRi2lpkx
	4H/VcHTlTBPo0ZDiZxbg9y9WRd0UdMEeV6uJS6zSrjgQCzQ6pO3jl/un
X-Gm-Gg: ASbGncs7oT/fTSoeNjnMA3/rXn8SbVhNJjKy8j+BidLh0ijXhtD1FG+AJSuBthzuE5h
	dKMh+UafhFoen20GzKgJip5dLsreFCUUFAiyQazXU2keGKyEcs7gq78LYtMth7OvFRmV3edcucj
	Wvswd2LPiLODjA0isFnCWAcUaAVXq2o0YeJ2lK8ZDlodcCywBDRgXaNCodVVqi56+OZRY6SoON2
	6svfoZN+dWAs7jDSlhUBN5HauEonx1YJwN+VcWixzJoB2Jnc8bMQzDyyhNLBGA5kqeXyzYhy+XM
	wUWdQB/B/ZHk8yN5sCgQar3e6jf0uLmQ15msc082ydYQVmKqSnW9aol98/cH+MWqD4KCfKiH0qs
	wUhLL6H1q5KlPxOLWXO4p4MwHWCSDZ0iyw5TE
X-Google-Smtp-Source: AGHT+IG3+4PiXre8myZJXbMXtIyGoT2Zo+1v7SoTFErR1CQFe7OBynTDKWH1/q0UIz7vCvtEP71Wtg==
X-Received: by 2002:a17:90b:4c02:b0:324:ece9:6afb with SMTP id 98e67ed59e1d1-32515eadfb6mr30884939a91.3.1756454142399;
        Fri, 29 Aug 2025 00:55:42 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3276fcd48cesm7365898a91.19.2025.08.29.00.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 00:55:37 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 8D99044808FE; Fri, 29 Aug 2025 14:55:28 +0700 (WIB)
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
Subject: [PATCH 06/14] Documentation: bpf: Convert external kernel docs link
Date: Fri, 29 Aug 2025 14:55:16 +0700
Message-ID: <20250829075524.45635-7-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829075524.45635-1-bagasdotme@gmail.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2744; i=bagasdotme@gmail.com; h=from:subject; bh=IiAjp2UiG4E4i0m+2wynqH3PCAcCcaK0of1KdBtx1KU=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkbY162Whs7TnrT1LggM0BOd5LEqfAiXtc37zS3e5gl8 vnwGP7sKGVhEONikBVTZJmUyNd0epeRyIX2tY4wc1iZQIYwcHEKwES+TGNkWCZ94c28TXy5tQ2r bD/4zPoTU9D/g2m/U+vihV++Li1Y5MvI8PjMzk3qf6eEm+VfELaazHDuklKIXI/3z+ub9I0rLF5 X8QIA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D39E51C0005
X-Stat-Signature: 7h4w7kmh7rb389q7dzoewdwjumcz5c9u
X-Rspam-User: 
X-HE-Tag: 1756454143-772645
X-HE-Meta: U2FsdGVkX19tigDFWSOaWhOf5B0OkyjggTkut9YfRV4fMTjVxzj+kV4y1j2To2ep/fKIiqkIUg17AWspPgn/PgZDPpouemdarirziZvXpXAAAbFa4iw+SSQoA1pxHv4/gVqazspg4eSl372iOo7UXw4CoaoXMo6VaPWFg3xQK8RW+MdCBixeJwQly3rwOqaCr8e+MTTxTxCl3Xzy/iBTtPCTpU1cQM7Oxk1ZBQtTLYfCaSASmDgbAk0fPWqTRQvAgDeQ6y/QrMn2OJ1ftm9DiACYfE2r8bencN7kckLkO2LDevCfqfWBeIOiG8VN/5VQZUx6qe5vye8MISpgKnWKJXrohV5aix3hDnC/s66iCuu3bje+NwnK1Wv34UqzNA+q3e4DkgVYqAdq+hbZzeOboSSH1CySrMb6CjB8y/TWP4rdplQF3HX51UEgrqSpAUeUez317w8I8Z1aABJ0ShJ1ne0dG4BJbk0qzm/kGmkzo+9lS+CemFqrGkcw4+4O3Rts2N3wFo2/NQNtrFIMYAvlkc2bPjt7zY3+e9MT5OxmulF92atJ0by5BZIxmMLLBY0pt4lLfor5n9Fk4OKcNuRCHHrNG7ivZEoix83xXe/MI4n7iptGVl950vNVaiKZdTsfP3vMuyZkypOiKP/dEWWV53i/p8O3ES9ebRfMS9vMKCDLDgwxfDYBJ1jaXc1yVXXAcWBlDAKDpDiD24cZtOxwLsrqO6irh5E5uJxuWxR0K2nAV6Bsm38VlKTcoaPNjQ+84sp4hw7ir936HBHHz+hXw14mJ7jxreD2o8dP/NfxQ6KWY1ev9zK4lKuHO5f+gurTFEt6xLi1hemHkh6Bi8hrLfej9qsPyn5j5Wtlc2Co8wqknJ1esvNCVMNuK14/aJ0AP6oHNOKqFknJWyGWrl4/auZxNB0uWJd5N6e9PUHpLzUJposrRsTWAnkdUtORsMADZh2D8cvT+cNXiZxs4jV
 beWbYKYg
 Reqf3mR5hWEhZmqSxOLHKi9FahvbU/qglbK1u15n4KJXzIgfqWcbBu18u4s+Yqi7ckaVQ3GsEpz4e8XxqATJA1j5Gia/AFeF7Zi3YQ7v7T1b1Xu6IoYqXu7nwTSxwCmEqkhVzUGDVnjn11XSKmDHHtxZOgnvpapbGZn1AEFtslQ0yLPSj5OXnj7JtQOhsGZHphxo1wlXYoPznhoLuOqJylm3pULJieqV6LFSCchbPU1rHsGt3HtnU/bTkzE8i0Oh4h9J73UAAdQ4WFaInw7YOHq1aCTAV744NSXJM6sDzbzrOyvIVuMARfmG143XOkziVfVdX2UNtgr1LytesTlAeu+oIPx8ZGqzHsQsFhBdvFUWEv/lM8m51GQ5VKJkrd4gxdn9nnHXZCeJX0vbdDercUDGkTbusmaaFBJPv0PNav/6fmXcD7caxgM0UpgsO76quPFKj0zVdZvd14z/wMfmfpq4NP41cgBipyDKqpS6L0N4OrS2Zjg/FZIoJv0FTrqsb4zvjpook6laY4QmxDN6jbCyI6fXjOqVGzlAnMvXeRfX4b1d3KHSmDnOrE4UZylS5kqP3x1p2Xj+bWjM12RRMnpHoj5lUQyM+Zn8Qf3cLd73poBMbzBEFMGzJuJCXVQbeZg07Qj5R0RYsWcwHYLTwfXH3Uoziv1oVxVj11ZmwB2VfIeeHj99FD2ArC+DUibZdl3zrmDHhAAnhcUobohHbdaKefQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert links to other docs pages that use external links into
internal cross-references.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/bpf/bpf_iterators.rst | 3 +--
 Documentation/bpf/map_xskmap.rst    | 5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/Documentation/bpf/bpf_iterators.rst b/Documentation/bpf/bpf_iterators.rst
index 189e3ec1c6c8e0..c8e68268fb3e76 100644
--- a/Documentation/bpf/bpf_iterators.rst
+++ b/Documentation/bpf/bpf_iterators.rst
@@ -123,8 +123,7 @@ which often takes time to publish upstream and release. The same is true for pop
 tools like `ss <https://man7.org/linux/man-pages/man8/ss.8.html>`_ where any
 additional information needs a kernel patch.
 
-To solve this problem, the `drgn
-<https://www.kernel.org/doc/html/latest/bpf/drgn.html>`_ tool is often used to
+To solve this problem, the :doc:`drgn <drgn>` tool is often used to
 dig out the kernel data with no kernel change. However, the main drawback for
 drgn is performance, as it cannot do pointer tracing inside the kernel. In
 addition, drgn cannot validate a pointer value and may read invalid data if the
diff --git a/Documentation/bpf/map_xskmap.rst b/Documentation/bpf/map_xskmap.rst
index dc143edd923393..58562e37c16a01 100644
--- a/Documentation/bpf/map_xskmap.rst
+++ b/Documentation/bpf/map_xskmap.rst
@@ -10,7 +10,7 @@ BPF_MAP_TYPE_XSKMAP
 
 The ``BPF_MAP_TYPE_XSKMAP`` is used as a backend map for XDP BPF helper
 call ``bpf_redirect_map()`` and ``XDP_REDIRECT`` action, like 'devmap' and 'cpumap'.
-This map type redirects raw XDP frames to `AF_XDP`_ sockets (XSKs), a new type of
+This map type redirects raw XDP frames to AF_XDP sockets (XSKs), a new type of
 address family in the kernel that allows redirection of frames from a driver to
 user space without having to traverse the full network stack. An AF_XDP socket
 binds to a single netdev queue. A mapping of XSKs to queues is shown below:
@@ -181,12 +181,11 @@ AF_XDP-forwarding programs in the `bpf-examples`_ directory in the `libxdp`_ rep
 For a detailed explanation of the AF_XDP interface please see:
 
 - `libxdp-readme`_.
-- `AF_XDP`_ kernel documentation.
+- Documentation/networking/af_xdp.rst.
 
 .. note::
     The most comprehensive resource for using XSKMAPs and AF_XDP is `libxdp`_.
 
 .. _libxdp: https://github.com/xdp-project/xdp-tools/tree/master/lib/libxdp
-.. _AF_XDP: https://www.kernel.org/doc/html/latest/networking/af_xdp.html
 .. _bpf-examples: https://github.com/xdp-project/bpf-examples
 .. _libxdp-readme: https://github.com/xdp-project/xdp-tools/tree/master/lib/libxdp#using-af_xdp-sockets
-- 
An old man doll... just what I always wanted! - Clara


