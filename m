Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80846CAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 362EC8E0002; Tue,  9 Sep 2025 22:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312998E0013; Tue,  9 Sep 2025 22:44:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3DD8E0002; Tue,  9 Sep 2025 22:44:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8B8B8E0013
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:44:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 88CA613B5DF
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:44:06 +0000 (UTC)
X-FDA: 83871796092.09.4019E06
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 84FAA18000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:44:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kg7v+3dY;
	spf=pass (imf06.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rNDvUkQSM5YXWXIzm38SWG/hRRo/bsx6SYKE7k7lSmY=;
	b=xXdekBHIih79zP3yxqU3J8Dv4UXjP0+iezHfU0Kf3JdSqUihkrH00aty7J1GtP6YqeoyQd
	oKhRbHkKWi2e9MHd4HjI5+QLwWycIiBLEI8KQVpD5wbfOyXqWYbeOmN6CP3xq2iE78NmnB
	AUQj+j1lyM0siwVil2fyZxsGf9zmTTg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472244; a=rsa-sha256;
	cv=none;
	b=d6GsxsNMDczPQtycMf7AnXPQnNewWryuezSprFlEnzS/7Cy+gXHF533CAMoQ6bvQzNP/sq
	wujH50JNkGnOurFx4RZIMUbMMQiYEvmYGLgifOFdk7YpumsyRKVgXe8YauoGEVtIP4F38J
	RfgvUbq2zdOsH4z1RCsXcLacE2TOmKM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kg7v+3dY;
	spf=pass (imf06.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-323266cdf64so5473249a91.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472243; x=1758077043; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNDvUkQSM5YXWXIzm38SWG/hRRo/bsx6SYKE7k7lSmY=;
        b=Kg7v+3dYew8Z+ykllqHpbnjrREnPNIAuqcEnhxtpCK8UVV3Q5xNRC3cp9q7LoQggU5
         EOzEZD2CUJFeuwth6c8JFkAsfhS0rri+6KzaHBtgA6ra8ETf4uRA5f0gC5lWa7T1udNe
         JSdTQClNteXNGmHfruGXam/cL4to7IOJqon2eypTf4YMvOM1FP99FZIA2wQoVM4kGwhd
         E4VIXMoEC51YeQERAxm9UtNADyGhz6hOEHwADWsx1yKWa80SwgrpkuW6iM+VS/91WX3x
         C+kPpjrMN5ZvZsr6RcNsXkIXEtqixNflXgtTWKRcWJ8wKs5cThuMNvjyEXeOoTpbjiVU
         9QuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472243; x=1758077043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rNDvUkQSM5YXWXIzm38SWG/hRRo/bsx6SYKE7k7lSmY=;
        b=qg6sJdJFoU0iS28nhyjXRSsG7lLXShJ6wsx4p/73lr0KsZhVFgEKIcl5EKo1JCYiUd
         TRILNIMkzumI6zaK/qoUoFCKvM30I3M+gg+B1BJJa83WQIQM32fN81BTtFU3oNX8XLvM
         cNUZl4cyhB6nFE6b564eloUs4JWbcGk/KWSeulHYJZaTtcb5Iv+iXREmcSmDXoQTWuDI
         fk+cgqIluPSbKz+MBTpHq5+ZJtGQb+q8DcJDXQGRkYLrBARUC2fonVzHqhaI7yBRoYfI
         P0SapSIc4ccsuEJjrZfeAg43zMxyioOlQdlapSzx280PjeEUi7FbTQP2gpPVCX0WAc6G
         kIGg==
X-Forwarded-Encrypted: i=1; AJvYcCU2rKi3AbmDgjwTeopEiurFlUzta620EzNYJ+ftbHHZUo0Fe75eHCTPVADR7Uceoe6obQrS7WN+1w==@kvack.org
X-Gm-Message-State: AOJu0Ywusmk1rMsBJZbhipP0T/E7orr9G1d1fZAOwzoiMJwtccBSAYVD
	etXlol2OL++Tn2O0wTxj/zZbkbjDyUbXxQGJvTaksnr4WMUxfcWcJFYR
X-Gm-Gg: ASbGncssAYgPOsihIuJHJVL0YeUsWqXFu8pEmTF4HLkkJQsYyOGqtaibn4PO/p0RYEi
	XkCkZjCJ7cEv9Mx2BgnN2ClOAYTw78ERnAcDZcF92H4pom3MJxGDrwRuD7vWd41r4+37Fyncatw
	r5Xoklv+RuWQzBSpIVtNUSAUoZFwbpjkzQK/nqu30J3lO66PO/VuOGkF1d02Z9c7fSLsAjnH3qP
	4qQ4XecPPntt3lJVw2Bbxe4c1W22SZwfXkhPAzVWPiYDUhsy07+NEKUMhnoKDClWdX5miL4cfxM
	QcagkTaTeG20tU7U6+ebpcS27jphoVbSCuKlWODKlx4JERfXxVXeLlyq2BpPUo6C9ZlfgClzGEf
	t1UaapR90rCeevKogoUEBq/aqIBNn9TVyA2Ps7MY74d5OSGU=
X-Google-Smtp-Source: AGHT+IHufov4+itUSgW37fW7I5+vYPKYGEYLT2O7M4oMOCb3e767p9iSPZEDIcWxDU07PyMVD30Hjg==
X-Received: by 2002:a17:90b:48cc:b0:32b:5ea2:a4f6 with SMTP id 98e67ed59e1d1-32d43ef0806mr17274237a91.6.1757472243216;
        Tue, 09 Sep 2025 19:44:03 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32daac59f19sm1672020a91.1.2025.09.09.19.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 19:43:58 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 7D27041BEA9C; Wed, 10 Sep 2025 09:43:52 +0700 (WIB)
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
Subject: [PATCH v2 06/13] Documentation: bpf: Convert external kernel docs link
Date: Wed, 10 Sep 2025 09:43:21 +0700
Message-ID: <20250910024328.17911-7-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910024328.17911-1-bagasdotme@gmail.com>
References: <20250910024328.17911-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2744; i=bagasdotme@gmail.com; h=from:subject; bh=IiAjp2UiG4E4i0m+2wynqH3PCAcCcaK0of1KdBtx1KU=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkHnii1Whs7TnrT1LggM0BOd5LEqfAiXtc37zS3e5gl8 vnwGP7sKGVhEONikBVTZJmUyNd0epeRyIX2tY4wc1iZQIYwcHEKwERe5TH8D8jY+cG0Uf3udDP5 nmfVwtmWi5mup+fF7AiUlLjK8OXNJ4Z/BmfN3s08dUKM70wua9O148mfqhVc3wuvO6WtdrV4s/k pLgA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 84FAA18000A
X-Stat-Signature: u5xq7e869od5unpr4gea4ybn4m1pnfd3
X-Rspam-User: 
X-HE-Tag: 1757472244-4738
X-HE-Meta: U2FsdGVkX1/t6mE5XKxl7WacaS6ZtnB4OpyCWcfgQtDuBpGCkdjhRfTOi/0sBzIrWqBjudy5MjR/ljqSOSfrQTL3s1fSq5nb7ylp2tKCuHIOBxlKR73aJUTIV4KIGp0Ju/0omHldsc122yWuZZHnIyw+vh+Eu3K1p81G1xnyLNKKRK3t5M3f6EODqmCuYyIsrwySNVIMI21EHAEmwIqBZYIOS5xOnhKRmVcjt5t5co6PiadL68fjAIU6l3TlJE6NJSw7Gik8bsDbkF+ldYBBA37RosBaWOY3ERBbNBGMWYrlFRM5iya1cjXPMLb/qtLrtCCdJs61UqW0iyI4Ds4M6Fm4FhISz430g9fmndcii6KvstRxOxEql8xvWL5iiY8NvkulpSYDmRgWy9nZlSI7awWjJk/QYp2wzKUXuaQtm52KWJCoWaAZ+7FogwROQRtN+CKDI7eazc1PRBOroUHwsg7UFHd3tTg+BDLV0lqqhLjPmC33ySSQ4hYpzOlwpKYsR6WdjdCr4Wyl4jg701bageu7VZTqmJxoUFeWaK3Nf5P5+ADOoQ/mPL9V+26rADJ2C0wonXYz0ZjHyA5doUhFUVpIycOBqJoeZ1T/K63EswtrM+cWo9lM0/EqBKVOP2Iu3IwYPEInrsFXa+VSo2PDJ2fWjI5To6yX9s1vu9rCbDUMK3m0QRpK1iVN+NGNxniLEfpfb6N+qLZHRMdgbzTn5bCeLYc4bCh17B2ngxoMuzrWP/3OxiWXm6aXmPL+Des5maIgRXGqbhYt80QT5rxBPtB+AQ+Wwrsz074sNELPuMIE3tcP7gglrZpL4CtLo3ME6o9kodrBl908PwNTSbd0c3Kgbw4FtQfST5QJqnGqgvhqs6QdLT/Tpa1AJCoksJFbXoErl8AePIAWpi13Q0nsLsyYIL4H4yjTR6HCgFZHbTF1NzVhFmLjTnLgQ/dw2xWThXHyzhk3dwWbQ9hcQVL
 83NLh/9j
 u+Vecs9Sx1P+g54qOMtI1jFNPLuCvOAgIwSsFNPTUCtPSynGacYn0fxMFQiOn80t+ecZxpAMhx1EBmOGuDvRbOpU4JnL71/zkd+oUiiM5IJozB1EqeN1LvVTW+VY896ToduYrVHDr+8XMDvP0nu/vuqPN3r1y0nsVYMlOigRCJ1odKxzYW33aA9fkjnmBfB/fJSNQegPo3iJRPAlGq6UuWPTpQAzw529L4P83wRPgDElVP1b7eei4ZJnHF/T7uWYp3xjqiHOIJMANpdP70uGFMmXCSHvv4JWJ8PVfVKqwG74FxjO+dZVt5tr1ZsZ+9toAhBNKST6IUnEXynHwnOwsIrHf/hIh4FAnawbOCaKAWebDmQMt5DCpjqx/RtVrJfTgjOp4cJVopY3/H5VKFkxxLXKelj/iSvYDihg+YGF1UkUZHqxAQZ6VaSnAOpF2xo12D5SbbYuWnSr0W2W7bxbgIo+JbS1Idb5bJbHxjIQLVvitYqSsTQ04IWLsmMWHTupY9WCmm2b/dUSrcTDK7vheKDJkuIn3Ck2+sFmxyG5lO1ktrDuRWlFEbETmfX6sdHMm3E/h4iCxtsf8VOZl1AQuGXsDvI+bun9mchGs/LkMuSQmh4Ax8atRU3zdRalucR57u8Vsux+aHpxNFkcHp6uMLWIvSrZyHng5K8QNHZFEpT+incXavxRXmXSiuWUaPaCbmeviBJWEe/kPOfc+2iWW59lk3Rg+UbqzHC/yyncEpZdDaacU0S5HMYexrQagUzdhbKXSVrjEh1xrR+PHvpQl+a1g4IoRuzcTe/40zvvKIc3Mwzke8os9T+jgvXtYwdcuWF7AJEq2o65t1xv7jY6VSk4U+w==
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


