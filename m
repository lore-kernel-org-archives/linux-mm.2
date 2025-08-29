Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41F1EC8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 08:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 431156B0012; Fri, 29 Aug 2025 04:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E2656B0022; Fri, 29 Aug 2025 04:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2817D6B0023; Fri, 29 Aug 2025 04:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BBB46B0012
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:27:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87C981DE155
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:27:46 +0000 (UTC)
X-FDA: 83829116532.21.388A3FE
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7A5C4180003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:27:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KDRTomSQ;
	spf=pass (imf24.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756456064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AfZlK+2PpvnkbeUUWLESRnsPEd9fz1tduXIyE8HjWg=;
	b=VgwrmE6UcGuSxNV73rLfT2XPcsfIMfTUTwTIsFjYurpO+bZIl6A+nM0j29Rby8aE2KBfFr
	LBWmlzt6TYN1muc++vzcYD7nUdNsjiWcX+nchISukeph+UKWqyVdjr5utGN36e/pf18Vuf
	b2KSopKQv9yIJrUrdQ6OHN6+XYcJrT8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KDRTomSQ;
	spf=pass (imf24.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756456064; a=rsa-sha256;
	cv=none;
	b=L4+5KDJd6qvDiI2cJ8QOg9udsR9qs7ohrbkCz+Nsk2UHYdZAOQ25leJ1eYDXdlYVKKlUOm
	jUR1SlrbLBOrnhyOzxCH36H/C27kyHnWWA6ILy5LHj0xZH09fpD6/7G8WebCmEfcFlqYKk
	1tQOhTJ8zjgsmmYUOzbpIlcjSE3YKbs=
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-53b174ca9bdso1313004e0c.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756456063; x=1757060863; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0AfZlK+2PpvnkbeUUWLESRnsPEd9fz1tduXIyE8HjWg=;
        b=KDRTomSQAK9lMO04YuLsJHFx8TPInSNL3StzB9bKxHBU7PntcCT2x6DWJiCrfxWEbB
         JQPDPATp74cE6PKcWMmNdAxHchC0ccDJ+FXW5xIaX0yIj2sMx5Akh7jF2y7qNYhEGkac
         Bb6E13mUb5fV71NIxkpFG8bewh6MFfBUXTfBHNklx+4tzdrATvI562NGQlZQ1RMNNQ4i
         3djCaQRtST4lGkmSQ+glOuukVReivITajoxDIBDf7yXT6JXsqiz2v/IsPvNCRvh/AxwC
         J6SbnpUWiIGlxL/wreVSzYfTAWvHapV0wPiwqeTOVHHFpF22bqVTRrkqxx8ckIhRHgyt
         hzAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756456063; x=1757060863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0AfZlK+2PpvnkbeUUWLESRnsPEd9fz1tduXIyE8HjWg=;
        b=Xs7A5OIA75kMDxJw8uk9sgGhvPFADb643yzgR4bPJiDrS4eIXIWwxOUc5jxKFVseJH
         eNA3QLsWLjyyVkrNte2ZKpi9GdBOkkohHSaRACUq3hPfOryedhxeL4Y9YKh/Ka66IQ7x
         9H3JWv8hVj2O7JvMgVr+kcCE4Uwx/o1F0k1Ox9mBiDKl4OqysMQkn8gFjNHltLEYkgf/
         EIeYSSVVk5YP8wwfBTfkilz9BJucBMNf5LER+3pIOqRNyN1kEAZ+kdTPYwruIJuvVair
         PUX4O/jKX7lxEzm4QcgY51wId+52ho+F55q51trdKGgH1my3ZzMxMf3ToH+Qug1fxUqG
         Phpw==
X-Forwarded-Encrypted: i=1; AJvYcCW3pdcb0Dkvvs2AJ82+ftPZrtsqGH9H6U/ksY73tbzvS5CbTauW1G4b896Kp9tsWlj/P0dA/zxhGA==@kvack.org
X-Gm-Message-State: AOJu0YzayKi/BiAFMJlQUuXgJBcxj/zj0zZEIvphaUNUbjtXyfvJV6/f
	E1uS/E781rL750PEiMlpq8KPnJn61i+7/OXW5J3n2NZxsXUFrdWjY7+TMrdwEd//Ln4=
X-Gm-Gg: ASbGncug4V6xbKdmXUZL925cfXq4qv971u6x3g0FHh0RXdnA5j3i1FoJrNZSKQOzyoC
	QVg1EBGcHcBRm8aJB44MwZ42Kz2thDYQXbpPrgHlA1P361a2nTAuVKd2KwAhjinDpxdV1bSlVUn
	GmeWJ4XqE49pDIM6MW/02FRzG29VFaVj/sLl2eZ3Q4OsGj0cpn/1MM4C2nrKI1DEXAc7KfBwNgm
	eBANMsARsoRyDfb1VLy9VjpeDHOlQrm7m1nIHHUFwcdN+037BUpQj92l2uVmLMCP4w9vLvc/XCd
	MA96P7c0ES2+rWnGLtGL9PpxBO/VfW9De8C/6Ur1NeW7a9mvc+Tv/D/zWKvE8X1MGg97dEHgUNl
	DAjTVyngrSohN0R4ZliwG3H0iGBLU5+YGzAsK
X-Google-Smtp-Source: AGHT+IEwoXGIzV8akza9wuHnzpdMDJjRSJFuE8pmXkEOlv9nwKY6YvijMOuiPPSYq1k0su7e61Abrw==
X-Received: by 2002:a17:903:acd:b0:248:cd0b:344d with SMTP id d9443c01a7336-248cd0b381emr78909285ad.9.1756454579374;
        Fri, 29 Aug 2025 01:02:59 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24903702999sm17213525ad.3.2025.08.29.01.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 01:02:59 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 08D794489F50; Fri, 29 Aug 2025 14:55:28 +0700 (WIB)
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
Subject: [PATCH 11/14] Documentation: net: Convert external kernel networking docs
Date: Fri, 29 Aug 2025 14:55:21 +0700
Message-ID: <20250829075524.45635-12-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829075524.45635-1-bagasdotme@gmail.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4099; i=bagasdotme@gmail.com; h=from:subject; bh=eMX/Qh24hdl/D8upWlphNzasCNRD/YCgXxsSIbz5MxY=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkbY16d1mKOz99m1qX25ldgn5beybqta3f6vFwaVK3P9 qU9Ts6io5SFQYyLQVZMkWVSIl/T6V1GIhfa1zrCzGFlAhnCwMUpABP5Y8vIsLj5nquL3YaGH+H5 K1M/GSvVfagoWJf+Wf//FmmeVbsWnGJk2HnZqfzd057r3t1TvvSsKTBp/5q8NJD5d+PrUJ8N/JZ PmQE=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 14mgk9d7kuhwkj6jwffiieyox9sdb6rc
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A5C4180003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756456064-185692
X-HE-Meta: U2FsdGVkX1/kga7f1uZLVMPco7IQxfrXVXukwxr8lxa626zEYArWLJjqf7iXeINFOhFC2sW3T+bgW/h4XRiV6juCMlyWN4OycK1schJiado/g6DUcbQA0KR6Q0oJnMFyrFg0UW6KTPP6x5az4EyHUzpqVyBYUk9sXolREkzQO9meiq/DLtwraawrXloSe/o/Nxs9hkiK7VDpsJSolMud0viWu0Sx+9y3dY+2oV/1ASLTZuV0dgPyua2jARgY8Osg/1fGhQCV39Mnlc0RqodLJu+YCUDkUZH3CI+aYhUTgrYDztIuL8CxPhZH+kyguGbkj2Rt7Q9/ZcXK3DNYkmnMZZEC+qMyXAmuz7deLmAJTL7lPPX0Zbzh5ITbVEfOfPgWWqrum0/3bU1qvcFUpGiph7WtX4lSnszMl+0tyT1ZQ0PtkZtLBVQV+vXhHOinNjRpnusfh/9DZ3Xlj38jBs3h5JKdh8Um6TTAwa2wWEYdALpYqSuUEQ8GIM7Wqy62ybi7wsfkkv2mHi3F3U7GUfl2UP3rzZOmt62NnXWFO7X+s4F5cyO8H9/ZQ9VD8ncZfoPfho9m//E0v9GSes97KVti4dYnZ49FZi9bHZRk4E//qU4HVxINE1t6Bb6C4cQMHs1BSv/CbGOs2QuvECljQU0AbruJxFDo1IrLe9JoDnK5pbKI81gV8kFmTj7ewEZX6ZzLhrOCoMfvuUYPW3zYWnYLVwEpQ2g32lp5PWyGD1+5CNfaKTUatJjAgNzrEz+fQ1+k9A3/GPGJGkEEqzmcdq82MJU9GrVk/n0GTEJ5gloGG4Vl/QpcFYriA/JG77ClW8Z8RTPuNBli+ji80o2gm5iicjmKhI5pJ6obc92jNCJ7K0NqT1E8fyizQ/owMJiT12qxXRCanlxG0BtZXHWuBKjUA4uvctXIvwJXUErPSdpVo2/tkxQ6hbSis6zv9Cuc98SlrCB7l1+Q3o+uhsakSDD
 jC6CwT+F
 s3Tpnqk7V7yDBdUGIeE9NUCoemdf9e7CIgoCh9NPSPMOoiMBfcOk+HwUlNBfXd5MdKJhdbId5k35udP3c36ggKZrksFb4+c4qjwp/7ddEy3/HbjdLsWo5IKbfAyOK63n05ACR++TS5KERTCrOBP4O1BvTxfXmjMGvK5YgJ4JYiFHz5TNHK7M18U2PJKHP45BPqlJzKhGwnAI+kRolhRgcpAsG4VvMlUKxjgXwio+w/qfwTazFOueVlW1ola0NyzM0Hc2SCPYu9w1lUPtt2Rm7blVd8dx1OXsJ3LfJYinS3zvMoFTW1tCGtOvljBEGBPirMSiPRsU+63a0hidYjn+JY7fQ+dHepzG9tO4g1xr/7EhXJWwGKHbz9btki43M40Knd3DlS0k1mKBt4o4URd2jA4DZB3dRFtCPUu/bfp2rznNGhs798BHNjVV6DkUOvGAF3eVbZwx7NvIoo0MZa5q+55uZbZ1cjAmvrmz5CPCKNPrTpkgDjGQuFmewRtjXsGSuj9QrFFJrIxz7gv1oXLSp9PpKNI9beWoAjYBXUM2gN5vhaFK0Hq80ZeI6ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert cross-references to kernel networking docs that use external
links into internal ones.

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


