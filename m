Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F26C5D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64A2A6B0022; Mon, 15 Dec 2025 06:48:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FB1A6B0024; Mon, 15 Dec 2025 06:48:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EA0D6B0027; Mon, 15 Dec 2025 06:48:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32AB66B0022
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:48:45 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 09B761DF6AB
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:48:45 +0000 (UTC)
X-FDA: 84221533410.07.7ADAC90
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2F80540007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:48:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TIWkEllh;
	spf=pass (imf11.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765799323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HauKBmXABfepG7VVzo5pWgXSZcUBePm/ZvLfsSGC9U=;
	b=rrRLT9F/k+5ZtKejKpnutUslHjiRMrXLxs3Z4sZNdeptySZodCyBj+8MkLqdDecmm7NVmj
	pdlNabM6P5wk0R+U+lj0yI+sA3ICxOberglxGNLLZSLDC9CJdvyQiX3vd2jKts0v0P1GIk
	W7Wk6xupM6n2wjeQ5iaVYfNIM+iA3tQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TIWkEllh;
	spf=pass (imf11.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765799323; a=rsa-sha256;
	cv=none;
	b=KduPAx73JSc9j548aVkqFCP814jDOgO2F9ztM3PVZZJJNVHdD4I541xjcXVSuB/W2H6pZK
	XCxMwox6a4B+C1yR5pSmJLm+XuqZkvxGlaNvDt/JEF7251vOiQOnENSXKFpJti67//5qgC
	ivzGpoLwr7TRSCGzBYhAH7v5aiKHxM4=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a0d52768ccso12880425ad.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765799322; x=1766404122; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6HauKBmXABfepG7VVzo5pWgXSZcUBePm/ZvLfsSGC9U=;
        b=TIWkEllhI9HQvX6xPF9X2hPh8sijo51F6y2/zkys5CFpUKavwq4vOJTJx/axD/78Cd
         4Oys57Fo6pprwNdgbNR3/ZavD2ZL49Uk8yrZlXI1NenTkgTXrCqbiz5JPYRWFjYscjrA
         PVNgUyIYawtb9P0H5Qpi3xdkQ6wQRNl0WECdRy0b8C2Ria9i6TrW9jBtDkzaNI5VR/cL
         z+E2QhWfG6+K0kTVvUwFKE4AuXcy7aQYuwdUaepOUHsH5Obe5aJ4sstk1GvaP9NkiBHN
         VT31NfHAVL0opvf2CW4VCghb1TNm0vMWoPrQjCrJoz81KLeWoDvI7ze/Gl5QhMkYWsdT
         /B8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765799322; x=1766404122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6HauKBmXABfepG7VVzo5pWgXSZcUBePm/ZvLfsSGC9U=;
        b=LSHBSDBrMBHJ3FekbAOLIhw6Mz+/si6ESWseLvCZXvVewrvCkl6D1euOYWVgRJNAWh
         XI33UKB5NERjo/i7gSVxgYWkIyhhtm7+DT0vZ8fxeBRGMD+x8R1Ak0e2dnWunLSCWBZb
         b720FloAiSRJFaty5jYucnZz+w0u7/4Y/RQZVlxVaNlya1tBNX1qZw+6jwzB+XvmIQO9
         1OniCh7h4GuUNNkajkgAdWuBs/gYrc8lvpIHxhdsNZstuy2cqmvW2SywVy2O4Rbfnj5I
         s92C1rwK7e1xSClWp2jgjURiScckV+sRmVizCi5jpt9WqtdyodLSOmmHsQonCQKDz2Tb
         Ywog==
X-Forwarded-Encrypted: i=1; AJvYcCXue4LwZAlch/HlYxfcxSy4eqzkQPMT/T7JcsvQov6dDq06Oy1fo/WCBk98dLt3hqSql/AtBpcdnQ==@kvack.org
X-Gm-Message-State: AOJu0YwoQJjy+jl7zvGoGc3aCYIKffKZEQjMNzb86uegGklk8axKl38k
	gAJjG6ph9znOkygv9xJDRrvO3CmlGPCCzRZHihjIpD1bWdT7zarLvzfd
X-Gm-Gg: AY/fxX6pVFIV1+0IBgi9Rxo4hO0ZXXSHz2w7KRtHL722WQdovR8zVG0He1DcyS9DfAn
	0iNq+hWV8YrVElFKvrI3V2FjbKYf7L+fvznsn374re0p6wBF08MdLb5h6UMOr4lceNWGEKb5qmf
	d5efDkx9kEpueSDuK71+TLzGtsyf7VKYbjgIBWd5HJl88zgDf8gCEzxqxrk7ZKeG5a9FCDGzbBl
	pe7MVGNZWgcM7nTW3n9iGFnrYEsTFvMmmfCWliMYSNFdKh4Qh5GHvU2dyRHHqkiK/Sb9Hw6o/7n
	RSg6rYGfYNiA/5C7rb8H0qqWbnsXjS9+4LYDiolpU8TCg+2/kdye+dgR1ttIf7UzUXcCKIxJFXT
	7/PmSr90S6OHDBHQVINceFUJfZtkqW0tIpGIrzpdhrVhq+DjeuIv/wxO+Xckhq+zGPn5EfIf6D7
	yfN19ajuzChaE=
X-Google-Smtp-Source: AGHT+IHfPz2x7Vw5nYSquN5rdr59IqpuimzSW/oHADfYTkii49T/33BfFck+CRU3WD2YFqFgGY1MBw==
X-Received: by 2002:a17:902:ccc8:b0:2a0:823f:4da6 with SMTP id d9443c01a7336-2a0823f4e6bmr66287715ad.50.1765799322057;
        Mon, 15 Dec 2025 03:48:42 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29f271bc8a0sm97458185ad.92.2025.12.15.03.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 03:48:41 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 1E64B44588D7; Mon, 15 Dec 2025 18:39:06 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux AMDGPU <amd-gfx@lists.freedesktop.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Filesystems Development <linux-fsdevel@vger.kernel.org>,
	Linux Media <linux-media@vger.kernel.org>,
	linaro-mm-sig@lists.linaro.org,
	kasan-dev@googlegroups.com,
	Linux Virtualization <virtualization@lists.linux.dev>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Network Bridge <bridge@lists.linux.dev>,
	Linux Networking <netdev@vger.kernel.org>
Cc: Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Philipp Stanner <phasta@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Taimur Hassan <Syed.Hassan@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dillon Varone <Dillon.Varone@amd.com>,
	George Shen <george.shen@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Cruise Hung <Cruise.Hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sunil Khatri <sunil.khatri@amd.com>,
	Dominik Kaszewski <dominik.kaszewski@amd.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	"Nysal Jan K.A." <nysal@linux.ibm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Alexey Skidanov <alexey.skidanov@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Vitaly Wool <vitaly.wool@konsulko.se>,
	Harry Yoo <harry.yoo@oracle.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	NeilBrown <neil@brown.name>,
	Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Lyude Paul <lyude@redhat.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Roopa Prabhu <roopa@cumulusnetworks.com>,
	Mao Zhu <zhumao001@208suo.com>,
	Shaomin Deng <dengshaomin@cdjrlc.com>,
	Charles Han <hanchunchao@inspur.com>,
	Jilin Yuan <yuanjilin@cdjrlc.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	George Anthony Vernon <contact@gvernon.com>
Subject: [PATCH 10/14] drm/amdgpu: Describe @AMD_IP_BLOCK_TYPE_RAS in amd_ip_block_type enum
Date: Mon, 15 Dec 2025 18:38:58 +0700
Message-ID: <20251215113903.46555-11-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215113903.46555-1-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1065; i=bagasdotme@gmail.com; h=from:subject; bh=UEs/C9BYSnit6YUYNsXI/TPVZ8wlbVWtOoMfZCt2Czk=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJn2n4P/rZd71fJeeea2Y6ze7l+/BUWfvZxbPVvJ7FLhc b8Ca2nfjlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAEzkQCXDH065v1Nu7J+SJNXm fKBEpbzzpEZrbklCWe8WSUFLrulTkhn+J33s75ffwvJ3fu98iUql0+pnUqJKXmg5a8ursxTsZFv IBQA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F80540007
X-Stat-Signature: af4epub4haehfie66cirset5z7ksa8ed
X-HE-Tag: 1765799323-378246
X-HE-Meta: U2FsdGVkX18k/NM0Ho5kXS28e3qbX2rwdWf1lUJaI8cNpaKa3n1nMvKLJAoyPc4Z/sRZvqDc1HljqhhQclYxgpg5wE0ZCZOd/+pkcCfpmNpR26b1nMGVOiOrSz9vI2ftbz8xwKv4Z6oodMvKhcXpy8AeO59Mkdo3RMoycHSbCRpSPekVR3vylStPvgRTRTlvA2nBnBxaTWq8T1KMmPF8hurerMGN0JctXOWiYjJq4TQmb5Xat0XnbPyy7tadoy1kJtEgT6y0TbC5zjarV8qoy2PjJvsMM/LWRN8TB3kNeQ0h+ykGw8lcxnFLqbvE5iw4r3ia8Q8XolcwYG+2UFt5xNYgt4hll0wOZ67weSrpbxiC9k0AhN1/BNgj03oaj68vXgFfKtmbhBexELMm96Yw4r1oowlpnQmO4JuqKTALwLl9l0YwWjv3uteLu4YvV31x78Vj8+r9FO4jgSmW9jIxuiMi9CJQY2CbBBj69olvIHPgB+hPtvFr16moKMc3wHMxeUKIdTk1j1Q2vChrIjJUQoM27MYOtf489uRac+KKNBqxZQz6YpKUmmzefxPYfIDfqU8EADkkLHm7bJE9eGXtPlqcoLuc8eHzgqocVumcrEWRTeBlX0sWe5IA736g2V/jo64mQ37uZs92U9iZc4nv7/hkh0ddbmfYImsBspYZ1lkl0ITVfNBVPcdTt5hOuKCmczlAKh2dJ3g7FyolO1wxtA4e1u1SaC81DCpYNsW/l/bxymyUhYOsGRoepoSuW3/0Ir6XGe06gGaHAGuGfJq/imwH2//zpnEkxUOA0Zs8jGLOd2yyQe0su01hXquhCs4p6BfE4GjxydhC5ozepVMfPvXPLLghANd1spShXvBRBQowfWSMm4UYRfdyYjj9r4csLpEureBkTk2uQIcwJfrHjDWYoYoQx+BfBX/iQuv+Ur4BVcJCh9R9tl5keYL2XL121lmw0EYbzjYx60q640f
 CZ03HDey
 auZsOGVwSakqUhTKCz+TvmJPpWX7IFYJ0/KC6In46YGZS7B2G9dUpActWBbstKMlM6a3fE11yINmKx1ShD17Kv1b/OjtBpMJopY07mCjiCRPeA5Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sphinx reports kernel-doc warning:

WARNING: ./drivers/gpu/drm/amd/include/amd_shared.h:113 Enum value 'AMD_IP_BLOCK_TYPE_RAS' not described in enum 'amd_ip_block_type'

Describe the value to fix it.

Fixes: 7169e706c82d7b ("drm/amdgpu: Add ras module ip block to amdgpu discovery")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/gpu/drm/amd/include/amd_shared.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/include/amd_shared.h b/drivers/gpu/drm/amd/include/amd_shared.h
index 17945094a13834..d8ed3799649172 100644
--- a/drivers/gpu/drm/amd/include/amd_shared.h
+++ b/drivers/gpu/drm/amd/include/amd_shared.h
@@ -89,6 +89,7 @@ enum amd_apu_flags {
 * @AMD_IP_BLOCK_TYPE_VPE: Video Processing Engine
 * @AMD_IP_BLOCK_TYPE_UMSCH_MM: User Mode Scheduler for Multimedia
 * @AMD_IP_BLOCK_TYPE_ISP: Image Signal Processor
+* @AMD_IP_BLOCK_TYPE_RAS: RAS
 * @AMD_IP_BLOCK_TYPE_NUM: Total number of IP block types
 */
 enum amd_ip_block_type {
-- 
An old man doll... just what I always wanted! - Clara


