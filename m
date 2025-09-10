Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05C3ECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98F4C8E0021; Tue,  9 Sep 2025 22:51:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918426B0028; Tue,  9 Sep 2025 22:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612A26B0024; Tue,  9 Sep 2025 22:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 453696B0024
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:51:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 17DAE13B94D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:51:58 +0000 (UTC)
X-FDA: 83871815916.21.10F3A92
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0ED8D40004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:51:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WTKfOrBz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472716; a=rsa-sha256;
	cv=none;
	b=q/BnDF0VTmiIvgRo0oEEvKUFg959xvdQWpgZbl9JwydbTVTRtFIg8hzXSVf06gtOQYb+wD
	FgcQsYFGGJQOEChykyv+2ZWuhwctr+z1MQQhkwMLd/jnEmhbgc9aR9xJyZ+AXIZG1WsBYf
	ZXt+TmW2q/nR93mnijzHVUDr8NC/7nE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WTKfOrBz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2TiZwTLryn0Z2XdO8OaBNvuenSuTUZNT9oHE0TAuq4=;
	b=aXbg9vAu/OAO/6/mFxy0xfR84ngVxAHswKwtwz/Dl01PZ1fh1fMJEUk5jC7gEdq6ezffXB
	hB1ugcjb53ZWuedsyFssrgmTZ7vfZajE0qC3Sflvb/gO2FbWMfl15pKvtyprsC6uV+HAhC
	yaN+6UA4Z8nv5dKHXcY7AecolPv7oFY=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so152235b3a.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472715; x=1758077515; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2TiZwTLryn0Z2XdO8OaBNvuenSuTUZNT9oHE0TAuq4=;
        b=WTKfOrBzMzyatkvRh3sYfzr83wNelZ6nZuSAVI94XP6WxfJF5AT44tH87NsSlJjb8n
         CdsN24CAojkRT+FaW0bjLQNy38Qbj0jxVRj8Nnw4DrdJ0Rhgky1SHkLiAMQCDgGXqPOL
         N86aWsGm1uJR4Goz8xBeywdTzSmAfta+118Iamp4hK+Gu5Cnp6auiWPf0Wbqm9hmrEpR
         Sy0lt9/MQXi1aEn91W+uRYZ0xmyWGWMNEdCP/Wc0hv3c4VjbWtyE+9kM/UZ9uf9jYcQ0
         VtjghqRCknb6YAL1ok6b9kdJ0LdfYng5VXUU3f1MDWRnGpktJ2fNTj1S5rDJ50jGjGYz
         RvkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472715; x=1758077515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e2TiZwTLryn0Z2XdO8OaBNvuenSuTUZNT9oHE0TAuq4=;
        b=RGRbIS4+zFwW+plWJhKRybZpap9Y0yOGNepqTMctBMvdJtbwZrc9Bs0503OeZGIXAh
         BZyl97vmsY+bV8Sn0t1J6ZlWVO15qq3sAz9QleM0gQIqGQHAdEOIeqVWatDAHotwdp9Z
         GS2c4ahrWtFhkLwO9ZCALH6RNtLiOTxi7GLIkprFTglmWPc4+xMYg+W83ujAQMxeCHm3
         2Z2jWfhBLjCSTx2Il0gpAtFok/q7mymGszo5jgd1BoNf+EjwKdXiGP/gkMgqt1GD0Uvp
         zcy/tLrF3Tn5RGtyKcmRow1s+jX8JcJtCdCsikE6Tq0ZWfb8X7HlnnGxIc6uxp1o7rk/
         XahQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYGw+myTGSLhvv5ynOv1JGQubNolRnBEntNxiwldAAhwT+jEXQNAsDpEn1F37Ru6tZx67oh69vXA==@kvack.org
X-Gm-Message-State: AOJu0Yx84kD1NjS8eAN2V5sX4ct7hdD2mrqtNPNK8Dpsf1LvOgE1frnt
	DZWGqzys2gugmQRXx9KDp/8wt+HxprlzLv3WQB2QEW6oeIC3s+78ESqF
X-Gm-Gg: ASbGncvmemKkPw/fl5tfrzQibATVG7Bo3LHQhQi7g+YN8ZBZ9vHzAMr55x2ZWYVsUCm
	JLXZVRgFOlgWBXpZCA0MDrzKsUOQpUhQ48EiikZGRkOJxLoTCXx3rK8a7EN90rVNLzyaGC1OV1E
	oF6q6XEsD4jjSJ4ANIfWNuwb69w6ezVuN2FfX03pr5Idm+Lrb2o1XRn66QYrbNRIEArxKac9P1+
	/d27yyMVpquMMkauOM8DN2h6zH2XyJeC6W5TAyfO+Bkn0Zrwhn+gBDB1qT0t0GVDUgYnSI1kB0z
	cKnyOOxjiYMkPimeLs/FpYVpZ738MRz1didKHD2hHCyBX7CyzDD/zQB1eqROPaM8jp6oYRQHWhk
	mAajaeaojll7UDel9rem3VWWNzypJBwH1d2N1
X-Google-Smtp-Source: AGHT+IFTyhfnUg3CqVtgOKW3+2pEfzFWWNjw1TnoTWF2WDPCy8Lg+0w3QYglyJRg7NnUo5SJL/6TsA==
X-Received: by 2002:a05:6a00:882:b0:770:4753:b984 with SMTP id d2e1a72fcca58-7742e4bf142mr18186197b3a.16.1757472714666;
        Tue, 09 Sep 2025 19:51:54 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77466293757sm3470498b3a.63.2025.09.09.19.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 19:51:53 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id F395041BDD47; Wed, 10 Sep 2025 09:43:52 +0700 (WIB)
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
Subject: [PATCH v2 11/13] Documentation: net: Convert external kernel networking docs
Date: Wed, 10 Sep 2025 09:43:26 +0700
Message-ID: <20250910024328.17911-12-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910024328.17911-1-bagasdotme@gmail.com>
References: <20250910024328.17911-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4165; i=bagasdotme@gmail.com; h=from:subject; bh=3KTOccWMzr8DxZPfBNk641Us82FbHT4BEw3lrJOsNTs=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkHniglPN1/l+G0b3W08+an+40OlbWa5hi83XTh+GX/4 C8C1xeFdZSyMIhxMciKKbJMSuRrOr3LSORC+1pHmDmsTCBDGLg4BWAiBZEM/4u927OPq/vretv+ eb/f6YB5Kk/Laj31K1IKboVhiko7uxj+pxYZGDy7rZrM+OWh+Y5vk3hP+ti0xKVJLGg67/x7TvV +PgA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0ED8D40004
X-Stat-Signature: 6rwoufyacbntsp7q31nw8pifqgbduzk3
X-Rspam-User: 
X-HE-Tag: 1757472715-582035
X-HE-Meta: U2FsdGVkX18C8vvqZkSZF9NNii0Aw8RHzq/c5NsGlWInLyseFzl7TWD387U1ZqK4DtIgXsDqqAMugdnQ/5CNAw2HeIF5a5jc9dMqu+vP+pJ9jS3Pb6RIn8F+1OjA93aEawFehKqpsC3Q+9o9sDjzqjjCwS7WjyABMbMkKwkzYsvZIkypyzxBSGITh1qUgLZYDAEGn9wlVE3qk2XQWAoYA9rdDQZrGl2ujUruMLUqcVB8UIqz+2ceZww1E6+6KYcOO6tBXehKeKNEV2lOWT1tgACNelRNGScqxAgn/fviflM3C6enfZhBr9BjZ2Olzvr5VBgEexcaA79vfYrOBFjFe2/+QqWDhR1ZdnJkk8ibrmZJKaX4eNZAShXPvMXbFlF7hVTJvQNDGxQDJkydxuPrKq9wW70S6MT0prZ84547HPi/A1e+skXa8GtDWU5r63RHm2mXeU6LP8WxcIgGIuiqkgS2r+ASnP1QIXnJrKw+5qnNYFWR5aPHqGCHTcdkjEg1SMpsGNzFG0w5OLs6a0VgwVxvxooGUe632H0aFqG2Ylc9Gz3bxNybX/YaCIbTGUQ4WmPgnUpFQ9+14I/GnCPHhyH63y2XPbbCTsvt8f9BdCc+d96RHRCsbgIrhTg4KJvvHnBVPrpQ4ohdj7sM8LRqSekUSEe7ec+P7z7vsWDs9sYG+9/roPtdOtwOgDgoIEsg2kaSUr3FgqHAPGMUsdm/JSpQivx7RM5e5ySYhw0iUedFhYdcojMqx5wCRQwtimjAcOKph9KP/o4MlN8Xq48NgPxc3dz6saE0uCQTwTglmPwB0ie/WADldi3wRv28HxGzRrti1kVyJxF163+38VeEtffIvxCDACRlrs6igUhHlosHLLYmpAE/by6hiQ1YC6Hh4aUG4xVCi6yP8at4rlk3toyO8QjhOO0QfYVbmIP/2Jx61n2nJbPshxsRvwFVaHgHu0B09OZZX7qBa3Oddrh
 CIWL4Abe
 sgirA438A7o/Q6uYnQaPKJbpCCuMrO8FeKFv6H0oywWixaJn8e4pN3w7yOCLmaeXp1lb1sI9y0w6WjCVxF0jS7zHYXERVSZP/YoKPyfu4rrWdaR7apkeabyfPfLUuFuVmKLZ3BF9sjI5hxYzHctkAAsNvFBbTxDxi5YrlmNuoaOCUjiDAHb75iuldxO5RWwYSDAx9Xom7uLC5vqXnigJQrIsl4JXDquBMhcHWWx/iZ4s9MKlslTxYmlScDNBXluEpxJH0GoPpyQLfSRz0Qj7rmdNp2rurzIjtVKor3tEqxi7xGghL1cYhgAxeH76g/eDq3y4bUNgNwDPhQoXx68g0sLLFyYh/xD3+ctdM+qu2N5tTxGzRJ2leJ4mOmnwC09poU9TIqnyAcCBsxHkNE5C65LMDC1PCFVYodU7gnDMVc0KnZ55KVFSJrFwEsxPd9UpPA2zXzkV0PF9z+OMwD5OKc7lg6m66wA1podBg0eoQ565pGsluh0lgpgEwvfGYPnVMhheWLw1nsUFBxaQ0yXD8bjACpT3NsuSp4mO9vXszCIN4mrDiEY3aXmc5GLUDWlXBlyFLszohHtYBtatCx+f/R+M0yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert cross-references to kernel networking docs that use external
links into internal ones.

Reviewed-by: Arthur Kiyanovski <akiyano@amazon.com> # ena driver
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 .../device_drivers/can/ctu/ctucanfd-driver.rst       |  3 +--
 .../device_drivers/ethernet/amazon/ena.rst           |  4 ++--
 Documentation/networking/ethtool-netlink.rst         |  3 +--
 Documentation/networking/snmp_counter.rst            | 12 +++++-------
 4 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
index 1661d13174d5b8..4f9f36414333fd 100644
--- a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
+++ b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
@@ -40,8 +40,7 @@ About SocketCAN
 SocketCAN is a standard common interface for CAN devices in the Linux
 kernel. As the name suggests, the bus is accessed via sockets, similarly
 to common network devices. The reasoning behind this is in depth
-described in `Linux SocketCAN <https://www.kernel.org/doc/html/latest/networking/can.html>`_.
-In short, it offers a
+described in Documentation/networking/can.rst. In short, it offers a
 natural way to implement and work with higher layer protocols over CAN,
 in the same way as, e.g., UDP/IP over Ethernet.
 
diff --git a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
index 14784a0a6a8a10..b7b314de857b01 100644
--- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
+++ b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
@@ -366,9 +366,9 @@ RSS
 
 DEVLINK SUPPORT
 ===============
-.. _`devlink`: https://www.kernel.org/doc/html/latest/networking/devlink/index.html
 
-`devlink`_ supports reloading the driver and initiating re-negotiation with the ENA device
+:doc:`devlink </networking/devlink/index>` supports reloading the driver and
+initiating re-negotiation with the ENA device
 
 .. code-block:: shell
 
diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index ab20c644af2485..3445b575cb5d39 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1100,8 +1100,7 @@ This feature is mainly of interest for specific USB devices which does not cope
 well with frequent small-sized URBs transmissions.
 
 ``ETHTOOL_A_COALESCE_RX_PROFILE`` and ``ETHTOOL_A_COALESCE_TX_PROFILE`` refer
-to DIM parameters, see `Generic Network Dynamic Interrupt Moderation (Net DIM)
-<https://www.kernel.org/doc/Documentation/networking/net_dim.rst>`_.
+to DIM parameters, see Documentation/networking/net_dim.rst.
 
 COALESCE_SET
 ============
diff --git a/Documentation/networking/snmp_counter.rst b/Documentation/networking/snmp_counter.rst
index ff1e6a8ffe2164..c51d6ca9eff2c7 100644
--- a/Documentation/networking/snmp_counter.rst
+++ b/Documentation/networking/snmp_counter.rst
@@ -782,13 +782,11 @@ TCP ACK skip
 ============
 In some scenarios, kernel would avoid sending duplicate ACKs too
 frequently. Please find more details in the tcp_invalid_ratelimit
-section of the `sysctl document`_. When kernel decides to skip an ACK
-due to tcp_invalid_ratelimit, kernel would update one of below
-counters to indicate the ACK is skipped in which scenario. The ACK
-would only be skipped if the received packet is either a SYN packet or
-it has no data.
-
-.. _sysctl document: https://www.kernel.org/doc/Documentation/networking/ip-sysctl.rst
+section of the Documentation/networking/ip-sysctl.rst. When kernel
+decides to skip an ACK due to tcp_invalid_ratelimit, kernel would
+update one of below counters to indicate the ACK is skipped in
+which scenario. The ACK would only be skipped if the received
+packet is either a SYN packet or it has no data.
 
 * TcpExtTCPACKSkippedSynRecv
 
-- 
An old man doll... just what I always wanted! - Clara


