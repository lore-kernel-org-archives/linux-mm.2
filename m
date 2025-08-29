Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4D43CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 07:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792F46B0024; Fri, 29 Aug 2025 03:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742E06B002A; Fri, 29 Aug 2025 03:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC896B002D; Fri, 29 Aug 2025 03:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 465BC6B0024
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:55:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6A7E118DDB
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:36 +0000 (UTC)
X-FDA: 83829035472.14.0EC354C
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id E3C5320002
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:55:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KQBlcmsj;
	spf=pass (imf03.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756454135; a=rsa-sha256;
	cv=none;
	b=soCUa0ZLyNiyWIZUrsEIvvKsTO/SyW+kO4DsKM3Sob3CCtsI1pyor0NjfKthY0Tw2B61Kw
	YcnArnVVAf3V5l9xfJ4MK3JnlIkVrirjpVDag2s1FvESZkoUeD8DGrhqMHZl1+eCfFGL1j
	to0wy2jxNQWCtZePv/HddyYFwOtw71Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KQBlcmsj;
	spf=pass (imf03.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756454135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e1dzl/9HN9fCmWWoku2EUAe+4oZJtgdEcU9UZmXN/7A=;
	b=zuu5xzgM3gf6y2IX/GE5R5D6BRf/fbxO0wytAcdGQzQp7G2uR56rIyPViU40slhUkJcguu
	8OoCIYZ1+IT/dhQ96nqvRrj20cyj6AwdE4WaPIVBytPwhwlLVJhpLgbS5FU/Bl2IbrEBKF
	bXlUzrSNw8x1uTOX6oAMv2JVEDA967k=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-244580523a0so18916795ad.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756454134; x=1757058934; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e1dzl/9HN9fCmWWoku2EUAe+4oZJtgdEcU9UZmXN/7A=;
        b=KQBlcmsjN32qovrB/oxFamkP/Z+qq4lG+8cnflrtCYrvnkMCDCKuQYB/5zh55AhOxb
         uEF8zyiJnoFHB2LLptKzjBw+L2U1mIt3RGiSR8dJdntW4+qHwvDeapRGFBmuSA1qlenB
         RuJ7LMDDPiOHRolq1naNdfKk0oY/kdezLv78X4/SOARz3MKfHPsNpGLBrJ6d+TjKw6gS
         3OKLhXl9S1SXaeiPwegYaiA5tO20p2/cSjA60G1HVyE/IYPGDc7uARrXrZsDSWCRe1gw
         e+IAE4+ljmd4+KhrRysSydeMD1mXqNZi6X/2vaKT8lQEk/n2Iq3fjLx6S6HQomUUpSwG
         42Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756454134; x=1757058934;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e1dzl/9HN9fCmWWoku2EUAe+4oZJtgdEcU9UZmXN/7A=;
        b=I7KJkk5Tq+rhGwa0lOf5WCjwTbnEUqoYwDRG2uof6lX3qaR9d7ai3tccZzlthkg6mk
         x3eFiW0UBrC+G+1dnsMbJ+j4hfCZfokHoXPZuCgd6kY0u0Ew4W4g38q60O5IbLbNOaVg
         cdUHws5W4Cun2G8DU+n33GYcVAtQBohqIH4oo3YTneF06p6+FYrmR8PWJzfPclQouZMB
         4uo2nFwrd4MUPEByTV3Lv1gqdl23w/gsERddVUVV0LBm/kHRQdCxnRHxxao8nBZIOot2
         YwivIOQW6B4h5x9rH3P9C1A0uMnXVgV/MJ2k6LJGy/eg7IQ1EE+8V/6PE/LwIVDhpY9o
         cI9w==
X-Forwarded-Encrypted: i=1; AJvYcCVKREBZEFrWJRzG1+w0xwyiAjK8CYgSRxqLwKBMWsPssuT6u+I9JFIO6WTjGzLfrlsKE9r9/Q7ATg==@kvack.org
X-Gm-Message-State: AOJu0YwnkNGiftzav+rdq4F/cRGbmEA9h9+5RFnvhRVfAUqQnc5CCLqY
	8VPVo9kErRw95nrqs3AChTf7wG/3TB40sr5l4Fi00+rT+hRlTTaG3tpu
X-Gm-Gg: ASbGncucq2UUpUL5vX9qE1CdHME2/Tudo6ASzLplNpnuZakFhekWWFOegXDY+A6laPj
	5efHC1BfoqU9geNBPz2LaIRkRbeZzMltT/7BK2hjTilNN86Y3uuB9FSASY9t2BtpucJeyVH9Ik+
	dq/hzYteKZ5jZrGkdiAVrhLqTK3H0Xqz2HYg2cnLfXrsKE2nduQhZOOTwMAaLWo5q0/xfckIP/y
	0kF1MSuXtxo6lge+JjRmrc1lCwsA0BQKOEzlo6ijUkeP/kPDQWT5/TlgRrubeZkJevkB6J+oQVl
	0g0TQoeUMBUfvMS7Hw201yQsLc3DOoMLxFFZWO3EFIDqKSaS6wb3LZBy14GhoJA5a9SFMSHHGHj
	HEXMOOTrs3rJtX5BbZ8iJdbGOnpKHUoFeV9O2
X-Google-Smtp-Source: AGHT+IHHspv4kBSvuOju+syLfWNvxBR1WSkz7mrwJNK9paKzC+4NcNK8VdwZC8CcLSepusoSJLIitw==
X-Received: by 2002:a17:903:15ce:b0:246:c7dd:8da7 with SMTP id d9443c01a7336-246c7dd91f6mr219457635ad.32.1756454133503;
        Fri, 29 Aug 2025 00:55:33 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-249037043b3sm17009045ad.22.2025.08.29.00.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 00:55:31 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 92CC9411BF96; Fri, 29 Aug 2025 14:55:27 +0700 (WIB)
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
Subject: [PATCH 00/14] Internalize www.kernel.org/doc cross-reference
Date: Fri, 29 Aug 2025 14:55:10 +0700
Message-ID: <20250829075524.45635-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3498; i=bagasdotme@gmail.com; h=from:subject; bh=UJUK8/oCaP8or4xMM6dYj2gtHalMI9xq0zTRRM+Er48=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBkbY17c4br6T35GuJHFF8Yt24416R5lZZr0d5nIjOkLd Wbtjd2k0FHKwiDGxSArpsgyKZGv6fQuI5EL7WsdYeawMoEMYeDiFICJxIow/NNvVZZWvf59gvln 8f09a96zlV1ddP/qfkeet3OelO1bF7GW4X+WSslpN8ZtovrZdcGNj+0m353MlHX12bkXf15P2h5 ctoADAA==
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E3C5320002
X-Stat-Signature: fod1jofjhmxjd6774ebcpm8mw974y77e
X-Rspam-User: 
X-HE-Tag: 1756454134-895060
X-HE-Meta: U2FsdGVkX1/EhDGRzm22yhveNfWcXHq/U4TZWpYOwFgoopbYxceNJfSdRaAJnGffhvv90UVy24q5xhAhknKCCyNohcdmXouaf/NDwP8s9OIc7RL/lVLi97yn0roEFnACdeG6FivPpQkqfpjoUibAzIia5kbuJ11IWQL2w1oC86mIXnSvXFSmc30YiiLvEW8WtFW7nIICrzkt05DQvHtlEDetHsWRPOrGqTmIZ58w6XmpjMhRUw391mnyTATxnRxzH9Ot1UPF0n9uPSYY1UnLkNNeU3PESbI10i7dSXt/+DMN2CNSodCyew9sHKGqt80CzEWTXzdY9VrjbQYjCONEciUfY984XUX300HlGa/fjJfbPykwFaRmyWWxfUYJ2fS68bx1rTJSjEqDaTEej/TclB5rO+edganyyHbeD8X3kL05tYCNL+xaGmlbe0/ax9O41lQq5nScVNj76UOkpR0zsUcH5cZ1sPtabJwCnCVQhRg2xljPanFgmIOjK96c3LggtrdDsl1aXCm9yUsIbnUg5u+xPpFX4jfrWjNayJc8l6sTysEh8bY2q3dBb2AmedLaCHtnUHM7UDw4Zr7cd4nZG+1pZY1U5vayG7h6hvS8xjGLasGyaDTyguk46yaaCJn4I+0i2UfRH4JUsByofggSg08Ebfp1JGca05MWTepIoj+XpNueE557wk70fPLA7+ewxFwNxDjxAmc5w0byQIByBHpAf5ng3y5eVLvmYbaz4gWFqcd/PpMdFd+vKQyoWXb/Jwu64/68Jd4bvkFQkXlHjoANP44lgvZ/pCstzhPoZNQGBecX1653SvCJg6gcqeth5u2CZKr3eGTwAxoTZXyl5/T9/ZDWXP+58yOyv/Cn2RMIzG4AuxeUjufll3tFNTylm5liei7RayrnFlv2jDvda5vTBJWs3ubETL7hfmaCV/jkpJSFAf2cqZ7sz3I3Cwk9KGrILhiBFdeOFSfvVky
 5Y0oRbRa
 OxjeQpvCXTMXxZ6Gx7FtwkYAL4Y/2VklrFZ4jProVKnT9LouoV9LmuP9vJ23vAr6GEirfTKqWUa/pFwStB9HeUNGL/Rf6MbjoG0NxwZhM5/4IgR7xKzab0WTQIGLaV/vLKw1XnCuUMZBT2mETMZ4OjeYSUVWKE60OlgNuj1obGqCutgpnXzfWECL8hMFVu9I3DOLyl0LrKjnpE3/vLg97j/tpdAZTc/uL9yvgIJihya+NvBH8Dqc5qp8g5y28xY/2lRcXY4m5/q80FcrqRDsREpUp7hk6kqu5bZXDiT4jx5aQBm281/S+4g97ywc4iBM9BfMy/n/1Zk+sKmsiQebdLh2Q1LbCQhbE6sabje62YGjU2tp+TNFWzPBZYBNuZ/NL9OBADo7AK+G7ZDIgkOIZUvhIVJZcGv4bxOAAEAkFUbn8RWsj+dONNVPPvtmUDmEVKMLUyYHCRn8DqmA+GHxKgC16qH3VOitMPlkyShTZbz5BZVUlZGHQEvf+Lc5oLD339f37B7Uc28wzpWrz3BQ8wQz2QQZcV99s724c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cross-references to other docs (so-called internal links) are typically
done following Documentation/doc-guide/sphinx.rst: either simply
write the target docs (preferred) or use :doc: or :ref: reST directives
(for use-cases like having anchor text or cross-referencing sections).
In some places, however, links to https://www.kernel.org/doc
are used instead (outgoing, external links), owing inconsistency as
these requires Internet connection only to see docs that otherwise
can be accessed locally (after building with ``make htmldocs``).

Convert such external links to internal links. Note that this does not
cover docs.kernel.org links nor touching Documentation/tools (as
docs containing external links are in manpages).

This series is based on docs-next tree.

Bagas Sanjaya (14):
  Documentation: hw-vuln: l1tf: Convert kernel docs external links
  Documentation: damon: reclaim: Convert "Free Page Reporting" citation
    link
  Documentation: perf-security: Convert security credentials
    bibliography link
  Documentation: amd-pstate: Use internal link to kselftest
  Documentation: blk-mq: Convert block layer docs external links
  Documentation: bpf: Convert external kernel docs link
  Documentation: kasan: Use internal link to kunit
  Documentation: gpu: Use internal link to kunit
  Documentation: filesystems: Fix stale reference to device-mapper docs
  Documentation: smb: smbdirect: Convert KSMBD docs link
  Documentation: net: Convert external kernel networking docs
  ASoC: doc: Internally link to Writing an ALSA Driver docs
  nitro_enclaves: Use internal cross-reference for kernel docs links
  Documentation: checkpatch: Convert kernel docs references

 Documentation/admin-guide/hw-vuln/l1tf.rst    |   9 +-
 .../admin-guide/mm/damon/reclaim.rst          |   2 +-
 Documentation/admin-guide/perf-security.rst   |   2 +-
 Documentation/admin-guide/pm/amd-pstate.rst   |   3 +-
 Documentation/block/blk-mq.rst                |  23 ++--
 Documentation/bpf/bpf_iterators.rst           |   3 +-
 Documentation/bpf/map_xskmap.rst              |   5 +-
 Documentation/dev-tools/checkpatch.rst        | 121 ++++++++++++------
 Documentation/dev-tools/kasan.rst             |   6 +-
 .../bindings/submitting-patches.rst           |   2 +
 .../driver-api/driver-model/device.rst        |   2 +
 Documentation/filesystems/fsverity.rst        |  11 +-
 Documentation/filesystems/smb/smbdirect.rst   |   4 +-
 Documentation/filesystems/sysfs.rst           |   2 +
 .../filesystems/ubifs-authentication.rst      |   4 +-
 Documentation/gpu/todo.rst                    |   6 +-
 Documentation/kbuild/reproducible-builds.rst  |   2 +
 Documentation/locking/lockdep-design.rst      |   2 +
 .../can/ctu/ctucanfd-driver.rst               |   3 +-
 .../device_drivers/ethernet/amazon/ena.rst    |   4 +-
 Documentation/networking/ethtool-netlink.rst  |   3 +-
 Documentation/networking/snmp_counter.rst     |  12 +-
 Documentation/process/coding-style.rst        |  15 +++
 Documentation/process/deprecated.rst          |   4 +
 Documentation/process/submitting-patches.rst  |   4 +
 Documentation/sound/soc/codec.rst             |   4 +-
 Documentation/sound/soc/platform.rst          |   4 +-
 Documentation/virt/ne_overview.rst            |  10 +-
 28 files changed, 165 insertions(+), 107 deletions(-)


base-commit: ee9a6691935490dc39605882b41b9452844d5e4e
-- 
An old man doll... just what I always wanted! - Clara


