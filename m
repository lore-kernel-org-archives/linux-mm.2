Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93A88CAC587
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C878E8E000D; Tue,  9 Sep 2025 22:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCBF38E0002; Tue,  9 Sep 2025 22:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F25E8E000D; Tue,  9 Sep 2025 22:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8553F8E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:44:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F69C1603A9
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:44:03 +0000 (UTC)
X-FDA: 83871795966.18.B50D714
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 432CC40003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:44:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PGZa5P03;
	spf=pass (imf01.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exY9byyl4etH+4IQEKnm6qXO5lYPceGxvCuurSN7fh0=;
	b=ZhLIa/CKD4XAcxllPTJEILE6rHoAjL/Tn+/+ZxjdtoX4/sFptRbjyp242pS340OTkowTSB
	NFhXm/q7YQRG6hYatjtn7F7PERlblVt3oO2MXjV4oK5o1peLN3zzmK+a/NVWh+vzqo++5w
	+SMDDhFSrKHvvHwOEGjciXituotIBTQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PGZa5P03;
	spf=pass (imf01.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472241; a=rsa-sha256;
	cv=none;
	b=SnRxDWYwfefPKhXGNiUsFQW7+5OTXzff+sW5BBFJNYGzWR08wCiM91D1dSZuIcA2U8MNns
	xlTZnfv68zbRIrUhGQI4KfmW1uw28+9xCQykJ/7hVU3rF0Cb91IaZIsuQjvRZu13obTCdQ
	g+krH9RQ0d5sB0AMWpXiQPOFqWGr0hs=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so5200832b3a.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472240; x=1758077040; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=exY9byyl4etH+4IQEKnm6qXO5lYPceGxvCuurSN7fh0=;
        b=PGZa5P03HpgQ+GBv9U4vKuBsKh2CQgJgc6QcI0ZHAq2fvTKgKTaIW5l+VxexlNgucg
         9HGsYBWmFXHrqw+vMTq7Hp/KJnG8Rmk+C7leJiQI+zBx2gzibjl1eMtIuBzBbWKVyxre
         BfGuLbLhQnin7gfIH5r8SMpNlSNL5M9GjWAvrP97ZmTmswk/Jt57LSE5N4jOPy6mXGKx
         huyySKuU+RXMA8yMeIz6UOzOFX8+CjxKYydHMgjrzhMJgF5ZYKIOD03DMTonpaN3Ut8A
         I2WKSx8A0pLxN7GQtBrFGMDHBgXuo4uau2bBkaOwVVkzoVVVo1EN+o2JGp6hQbmTbvHu
         efCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472240; x=1758077040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=exY9byyl4etH+4IQEKnm6qXO5lYPceGxvCuurSN7fh0=;
        b=Oud1odkUz5Lj13s4KUGxv0zfwBIfViFu+VyBqXF6FZqVagmhad8/AMddHMcPeDJXd2
         nsLw4w8ECi8Kgnw7tNqTz9tpJQ437pJcYiPk+eXKc7bJMTIbrQvfFKn3/gmA+mOweAjD
         Hh5NYpV/wAFp3kVk/hHNXEu+sO1XeKQ3AP2LRR097FZZ/S8jyhDS1nUTULbcDJwfRxmK
         2vjrkcB1bJJ/6CsjGLvRHUZXoUOg/z4W/8enXPAu00hwdrjfGt4QTormzcpsF+fyXV/k
         WhJae6NknAXcF4S0jRMsl+3ty7YuOrTQx9Zy8pLP/rXwfY76yFg8aFDJZosTuClQHU66
         ZavQ==
X-Forwarded-Encrypted: i=1; AJvYcCWc5/yewtT+t+O+rIGIpBxet09HKLGXabKMyZ0jGMAqIPWrdB4HHXvRl5oYVmCrPyqS6mc9sr4VEQ==@kvack.org
X-Gm-Message-State: AOJu0YyMoFay+RsKA0w+Cle3JVjmvIPL9Mu6YNN95LeE/XfHZWJ2IjPf
	Ent2QW3UNznnql0n0z0eM/h9L9mgQcV62wjRArighoaTaETZeJ247JABc59QuxDM01c=
X-Gm-Gg: ASbGncudG0buKnLT02NsSYtzfSZbE9DikUa29+0Z3tGfKa4Hc6Sy18WdfrniIIJiHBe
	5jvO2jN/ZkykPZGf3Db2qgRkMhPDdaQeDq9mKuhrNHrQandmyBxAR3zKmH5yVydcak1PiAsVOMF
	scUDNKEt+JiUvkupxv3Azwu3XAy4IrESeXEshb5eWXN2WbF7QxPn1l8v7Ol893uDoYh5Csxl1Id
	ut3TO2busodDIIUtz6FgZQtsEZQVujwKwDXoQ6wSNGLeIgTyasoQ9rh3Ow4qsubl+wAG/yQJbPH
	azJh8/2xk6JKsJYYjEy4sInQYW+VU8y578ubxl+q1KDVNgbMqQvD4jCbgGsE6k11zDB3EXgUeq9
	AgPCP7DCiXtR4obTfal/lTKEDGBldz5kWVgLGBu6Gr/O1Ujc=
X-Google-Smtp-Source: AGHT+IF4N06fuW1A2YnqT9YeYfBmdnDVAaiP1zDRDWLaUsyjpra5p/f/1OQFfNYpt7LKVATNwvRwQw==
X-Received: by 2002:a05:6a21:33a6:b0:252:fbd4:630c with SMTP id adf61e73a8af0-253466f83c8mr21797369637.52.1757472239935;
        Tue, 09 Sep 2025 19:43:59 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b548a602e14sm1057772a12.21.2025.09.09.19.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 19:43:58 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 614CF41F3D7B; Wed, 10 Sep 2025 09:43:52 +0700 (WIB)
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
Subject: [PATCH v2 05/13] Documentation: blk-mq: Convert block layer docs external links
Date: Wed, 10 Sep 2025 09:43:20 +0700
Message-ID: <20250910024328.17911-6-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910024328.17911-1-bagasdotme@gmail.com>
References: <20250910024328.17911-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2751; i=bagasdotme@gmail.com; h=from:subject; bh=7QXrNRuCbHeHgCYdGUN3dSXlo+bJ6ZwXyeTt5Kf+8Ys=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkHnijp3TFftH6q+kyOiIzsCLYVR/ZOd/GUnnS+Yu6/k 6t6/fl6OkpZGMS4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjCRydwM/yu/ZhfqF9YvP7NL t0p2f917xpei8yqP3w+TKtx3xMg27gbDX5mQVefmZ+9qe6G15Ils7rRL855MXJGSeHOCjN6Gx61 PyrkA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 432CC40003
X-Stat-Signature: ksgfdbo6p55wsbs5yr53frot75ae3r7u
X-HE-Tag: 1757472241-738763
X-HE-Meta: U2FsdGVkX1/NCbtj90uf39cbCH8pePHIYppu0nNDykTp6rgYPYxLCMNlSbplsOFAPcz+QaVrUE+FHYty4ALSk2mUIeslSrik+0DwIxpkgKb59Lpfd74dBsXtTBsnGTVTMWJ+72NDKyY+RoFRrjTkWXdteLi1LKchl7DCRsYDs0ms5+VfdU+wE7eWPlTMMcbQhcCQmnG+tNQF4hipIbsP5IfVpCcfhxb08yFrPm1rMtTi6+/442ThqwTSQNv6HXIb5uOOmfmi6ehvc6SHZEVaEcXkRQFoytbl4iAJ+OCX2R3nJyjBgxhPgzBrT+72hiuZCWekPbH6sPuevWcryC4IKNuWkf7AbsS0zrH2OQITQX1PJb7dOC6sKZsEJt1uWOEkjczqLQjY8ONDOZ1WwSjT+mBqMMBcVGUVAO7QeBeYPYOpF6sekLSkdNvPRMBUACjIdcqI47aH5viZ5eW3iPqz278Wflb5Ijhr+0I+CC/f0pcT8MXDjE9zyje0cCTthStxxJVS/LnwGjXLaXSCb1NCxTZcoc14JQECoVxS6l7OVLNd7jZhApj0bHL55LHa92QuT+aSAoiP9/nWftGbsWaR9DG8rXRY+yxdd0kiyMBBHTBljVaYkoDXVcAKO6R0ANcO8whcsFwCiDhm8DeN5S0xfKJ264exUnQxda69YtfwTAeW8SgUvtI7/qTr+2MWKrTSLeiBA/FSlomUGaSewwZTckhXmJ17z1dFpFwEZaJA2eJMAWlpC8sHHpY6OOqnQtCV3hYXLTZ04OUHk3TfbxTWoTjHaX7no9JCt+gF4C4JbXP7KORQDh7RwGrGylizdb2JKVi9xKktNojEc+5fAJkILvhl9md24wh7g6PiC5OpYeHxe3prvykCC8hEdh7F9GKPX/gArj9WBwuOmZwTue1MZGxPHiACf/f7Kl+lqnoDL0QrRre3t/dCcyMJzgNO6sjgloGRTKbbdw29//n5FNO
 b2BF6Uz0
 jYjjxjOEmL+Oq8HKOMedS1b/NzNxN1yku+GrzVzni5w9n8IISc+MLAvJmkX+fr7AZ54BTUMGQPNoGVBbVtPua/cYKDV5wmfT6OGXf2S3mFDwo7BnlKlzG6XvXU6ERPg7CJbsoyHm4bMmihXHm0OPg2wDGpSnUyKGjBR+IobziI2N6tYANjECqkUyumH1UWp3ArQ/e0+6oxWcVnnMAVMsb5x3YomBhI/GorgFauJo6cybm+orPrgv2KJkPqbyQlm/eqsfdsZT2oePZp1Y+TIDPoJ7YWdapJ0eGI53cUo/KySWZOuFuRDFBnp0lzbwx7jetnfAfFIP5njmrzkyiyfjRInJvPWU7KKuY3l2+pjZT9Sqe7eja2j1ZpUxyCUH513yE+3GIADUDMo+2B6YZa7c2RBVF5syurDPwF11Hl7Zvji5cOpQy6cqqftXUHbvOQysqLEicdQUrc5SNGCE7axhNuRPS4jGwR9tf5G8GC1vCABfTjC3rWgxJG5it7IAP4u/e6/MuCx6e+PffYK1IG0cQWXWUCLNrSQ5+BeYl6SfxITBqqh1ozsMLguGgVLzfMbH7GwnRUZtPNEnk4C45bwE7wWvw2OEQ8Tc3AiK54K9wunaQvOVoTM+cI8Ti8cXABB2TZ8aAMaOvXmzLgonk8eiaKuK399lWLY03M2pyYOFwH/2Fx/6vBA8Rhr0WL7OBe9LWisVyGn15ClGGdGw=
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


