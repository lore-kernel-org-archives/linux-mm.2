Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA864CAC587
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0028E0013; Tue,  9 Sep 2025 22:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646E58E0014; Tue,  9 Sep 2025 22:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D6DE8E0015; Tue,  9 Sep 2025 22:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 224CB8E0013
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:44:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC3911A0764
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:44:10 +0000 (UTC)
X-FDA: 83871796260.04.36FAA5B
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 108961C0004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:44:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kUHdOqKi;
	spf=pass (imf21.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fK0hEDM5Yyao3a7xqBzpr49p9H5HB+om5vfXDIKLdeg=;
	b=ZgsguHVdjHFySqekXe9YcgUJIbVDZnhjaqDQuRriypmkLS1GkJ1U9QN3JFLq6hSDLllL1k
	T+PXeSioUNVDBq30MPM7Oss81HPsC3Ac0mwJC54yf05shcRWhQmjff5/rdObsVPoKiuvW8
	46Z0YFUFKhLz6HLX51Y2SviVWIOPoUY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kUHdOqKi;
	spf=pass (imf21.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472249; a=rsa-sha256;
	cv=none;
	b=AFsSSE5rTkQ0mU8KwGRHx/VvY63iWLIiMAoWEcfQtef4osmRvUH5xQIqX03t6AuOhepV7x
	pmykzfhaVK7hhZW78+pQ/ZlMfSNLakUW7jLUdicjtpTx0awKWissYZKCvwzAwQjIr5PG+X
	vgEhR0eIVoUupo83gzl+XXbYAs1KwVM=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-772481b2329so6575549b3a.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472248; x=1758077048; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fK0hEDM5Yyao3a7xqBzpr49p9H5HB+om5vfXDIKLdeg=;
        b=kUHdOqKidFMCU2J6c9gSdMlxCk7pK7MAbYCG0BQ+NbiQbrcBw7PTyExc4aBf3linNC
         soEeEwkyqNga+OZcfLB8RpKhOJGIb7RWTQ9s6obrYQtdK3Zxuf1EYFm1u5t+DPxw5p75
         x87J6kKFF41SQlVfBpwlW1WHHNqKyK1tK1GHsE0uZ0vXXWq1eMNQVwHVPohE8QVXppxD
         wbdpKfsAfNC1TxQ+Qeeb5/9YEt9Be8hV4IHjDjKhqirtpTIuYKliuzPPh1+JUFv7jxb4
         8b0Bi4Zz88n6Pwm5/O26Qd/k16W0rGSCgq5npUQKzOx2gDssxPRIqgAdswzIXGo/4SEw
         cRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472248; x=1758077048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fK0hEDM5Yyao3a7xqBzpr49p9H5HB+om5vfXDIKLdeg=;
        b=r9Za/dniR3IPUGL0OiN1RH/nRWuZYBXZa4qNRnWM2BfccgbDJSzXj7gaZqedl7TFwW
         B8jeGRd77k6ladXI2LWGz8bo7UK+xB6DKtgYIm2K+iwhbIvWZQWXx0udqc1GXs/AnoGK
         mdLbyvSOyqdU/DoL+yQ1uk7in2s2uctIB1S7A0HWlygLheIm8bufDKAXYFjDesdeBMuN
         CZMg9BfiIxnKigqfCYyaKdbkihHIpUcIUYMJMR4psLp9AXr0vzmGxw14hr4c5b1Xcuwq
         UD3mgQ0G0/X7oyQVvE6i0L/J3FZ9LIMnWqH78Kl5j6n7Z95GJarobm4imJvZR4QpPxHg
         vVUw==
X-Forwarded-Encrypted: i=1; AJvYcCVi+AnSthG34SSEJDrk3IGlUYRmdI4QbZk/3zmEfrSdvztJYjI/DdQqzt6j1+fvRWaRCkyk//NS+Q==@kvack.org
X-Gm-Message-State: AOJu0YzUo3jQtCI3Pj1w/yXFMQfHPp3zh2R6kUNsl6L+P2bqUvqOhELc
	v5lPx23sIQnytP9qkKzPBPV1XY5dXmZ3VMARja+ug07n6UdaQK0xRhxO
X-Gm-Gg: ASbGncucYIyigg1vw3msG9+wveeuanJsO8w2GUHBmIP6iqQIMd5raLsAU95qED8vJro
	yhux06IlRdAcY9D9gAt3wdyCYppCJTG4b4ES/P2IqUW3kK+D7DmU7aKJXSQD5dDFXOsqi7haVDX
	/9FXA0dgR/87609/339cbiB5l+j/wbjyhsjQN556+IYTjJBAXaz7xFuhYyDwatIeJUm6Bju0LFL
	h3PoZCinWc/bN6prUHzRvcQsvBVoC5dVa8z3ODwYSsFlbsW75qtnZ1VP3uYbT23OFIlr3vFzfFx
	LAiDCMYFH3UZZfKquTfe2MlMIiw5yPW1SrB3dFe+3Gd0UcbI1DRpS783LRoHzY6+ogQcTc3x8iq
	eZXxDHz5UfvMzUDPHyTYve4AJBA==
X-Google-Smtp-Source: AGHT+IHubWrsefo+d87orOab1DSwsve/ArB2W06/xMLWCSAZ2PZ8eNr96v1SI6ir/qnxEBjX+/LG4w==
X-Received: by 2002:a05:6a00:2d16:b0:76b:f0ac:e7b2 with SMTP id d2e1a72fcca58-7742ddadd68mr16640975b3a.13.1757472247852;
        Tue, 09 Sep 2025 19:44:07 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77466290d84sm3499051b3a.65.2025.09.09.19.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 19:44:03 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id C367141BEA9F; Wed, 10 Sep 2025 09:43:52 +0700 (WIB)
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
Subject: [PATCH v2 09/13] Documentation: filesystems: Fix stale reference to device-mapper docs
Date: Wed, 10 Sep 2025 09:43:24 +0700
Message-ID: <20250910024328.17911-10-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910024328.17911-1-bagasdotme@gmail.com>
References: <20250910024328.17911-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2828; i=bagasdotme@gmail.com; h=from:subject; bh=Ip9RCWVx3N2eFboDnh1dVntKjUKs5RT6sbpEBdmz23c=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkHniixbj++M2M+e9AK28XZP75VaZfxL/rvM//ttckLa 3oE7/o/6yhlYRDjYpAVU2SZlMjXdHqXkciF9rWOMHNYmUCGMHBxCsBNZmb4p1i8uPKB8ZP13wum BPvKxR5SWdltK/h88a0CIW7J/3IPcxkZtk3KCLwZnfbq4QUbicP9bC8vlyYEbns3a5pPVM71i2f ecgIA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gktyae3if3niw87jgsez6h5iby4ksue4
X-Rspam-User: 
X-Rspamd-Queue-Id: 108961C0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1757472248-249434
X-HE-Meta: U2FsdGVkX1+JXUhcRnVPMVjHt1Ux80dD/6jxrIJ//siSbQ4OZ7y9S6k12vt3RTxbd2Y5CnIAMwnHUk9ww28EpUOQgfzAwRmvfdlnn/bKzgUo03GxWZH3EYPURNZqd5Bs8nLyIG4lrFp7NnfdemdzwF99sx0LYiP3Me8bwa/ti3HIku/z4nQosjbSKer3kpVzxobJPWZAVBtuPrt+YVFr8PBV76QGgcQ8/ACxkKOpjY7VslYWLA2Evvduzb1HtyvvvwrPRW7sq2bkStlH1AQYOOGIN4Lf142oKJR4Yt+mSYzyRXbQ2jikZ9+dV9v7a1UCL7IT735btKBP0h4kyVEDGm69RsQaMcOZVgcv8PpDg3nGo2nRxu/nHNQnEgsvoPPI7B5hD+8IsLJJL2q6lF9RJUvj81f8a59fsuHIwfHtoNDYMDd04PMH1AOcDUxoiWTPRkDB7HaHIJI39lPkiM+q46m+P86jNqzyg2DGUe9Vi1qQ5h0IT5xhATAWdYfFfGcgBfOFzktVAYssvY4P6TtxDJaVLoElvellxKK/w789LDlmBywgeDqf2shV/xWGUkiAphLuelrDifWXc1JgyKHreJDrxIEWKdlBxXtbY0d2mJ9gUIrlmjmzIVceZIQZhvp4bsGE/9iv45wdo4gmrJWUoBo1EM+aAGeh2KSduiWIAzi/wuV34ektSix/NcbEJFoP9m7xJ3+0n9kCfRiPH3/LjkD6oD+l19H35tC2ZUrLvbG/Dww5k/oBmym2eF5jxS3V+jT7vEL4IYlMpnFLw2DEZLQjmGs14o4umO4I4Wz84VeAhwCQWy9Dubi17eFEPfNGRfsLEW9FRkOnrqX1I710Z7oCoPtISv44+2PQXtXbpR0MzHcZ5pOn2+gYnUXDf1vcqEDXrEsivoSuFf/ZhmX8FKRUJuJ83XaDMu+Mc1u1/83TO62fXit7Ql3YHO8V02PpUKJyjHRBhfIuyuHHdNh
 Mlcwygkx
 oxKIRrUKLAnZemAW8Q5wWK9uuDHmomCmgc2aNX//qGqE55OQjm9BHPuJX3qLsGvNN69O3NzLf5Hn6c6QwpC3pOQrAqrgwidat7vn+QtK2jIr3Vm471q5wG9xjRenx3NqN6ofN7J/e8EuUqXS9N5Xh7OCR+G7o4ldwha4iqe/uBub4KOfK87G7XYMGXNLqMMVLTCXhqVOnRhMSNkNf2bH85L5cZcc6MAjozrBEQl6z8CqyGuj+PUVWr15Qr87GwxErRZnigMX0tqNuIKQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 6cf2a73cb2bc42 ("docs: device-mapper: move it to the admin-guide")
moves device mapper docs to Documentation/admin-guide, but left
references (which happen to be external ones) behind, hence 404 when
clicking them.

Fix the references while also converting them to internal ones.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/filesystems/fsverity.rst             | 11 +++++------
 Documentation/filesystems/ubifs-authentication.rst |  4 ++--
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 412cf11e329852..54378a3926de7b 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -15,12 +15,11 @@ of read-only files.  Currently, it is supported by the ext4, f2fs, and
 btrfs filesystems.  Like fscrypt, not too much filesystem-specific
 code is needed to support fs-verity.
 
-fs-verity is similar to `dm-verity
-<https://www.kernel.org/doc/Documentation/admin-guide/device-mapper/verity.rst>`_
-but works on files rather than block devices.  On regular files on
-filesystems supporting fs-verity, userspace can execute an ioctl that
-causes the filesystem to build a Merkle tree for the file and persist
-it to a filesystem-specific location associated with the file.
+fs-verity is similar to :doc:`dm-verity
+</admin-guide/device-mapper/verity>` but works on files rather than block
+devices.  On regular files on filesystems supporting fs-verity, userspace can
+execute an ioctl that causes the filesystem to build a Merkle tree for the file
+and persist it to a filesystem-specific location associated with the file.
 
 After this, the file is made readonly, and all reads from the file are
 automatically verified against the file's Merkle tree.  Reads of any
diff --git a/Documentation/filesystems/ubifs-authentication.rst b/Documentation/filesystems/ubifs-authentication.rst
index 106bb9c056f611..9fcad59820915d 100644
--- a/Documentation/filesystems/ubifs-authentication.rst
+++ b/Documentation/filesystems/ubifs-authentication.rst
@@ -439,9 +439,9 @@ References
 
 [DMC-CBC-ATTACK]     https://www.jakoblell.com/blog/2013/12/22/practical-malleability-attack-against-cbc-encrypted-luks-partitions/
 
-[DM-INTEGRITY]       https://www.kernel.org/doc/Documentation/device-mapper/dm-integrity.rst
+[DM-INTEGRITY]       Documentation/admin-guide/device-mapper/dm-integrity.rst
 
-[DM-VERITY]          https://www.kernel.org/doc/Documentation/device-mapper/verity.rst
+[DM-VERITY]          Documentation/admin-guide/device-mapper/verity.rst
 
 [FSCRYPT-POLICY2]    https://lore.kernel.org/r/20171023214058.128121-1-ebiggers3@gmail.com/
 
-- 
An old man doll... just what I always wanted! - Clara


