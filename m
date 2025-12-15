Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD0E2D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16C26B0024; Mon, 15 Dec 2025 06:39:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0326B0026; Mon, 15 Dec 2025 06:39:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B19AB6B0027; Mon, 15 Dec 2025 06:39:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 948376B0024
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:39:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65EAF140162
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:26 +0000 (UTC)
X-FDA: 84221509932.20.85B34B5
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6982B1C0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eRnppLSa;
	spf=pass (imf18.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765798764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TrKHAwDmwEWPzZzAT0wzFml+5He+R0bXqVhPFRZE9SA=;
	b=uRRW3qzTkkRB5zsSX2ziZuAGnGIzxcwfxUpIzwDDz4csbNZtfYEsF6NyQ2P8Dj+FbV9yMz
	/H2HF/6eqxw9erQW+08FrHF70K3BX6fRGtRSysEQiHGbGIGucdk5qLZ0Wd8Wvg8bc3jYKl
	Y/6XYCfwoScqhnWnvnkdnMKrq9ao5ZI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eRnppLSa;
	spf=pass (imf18.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765798764; a=rsa-sha256;
	cv=none;
	b=thlibJwKeftVMaf9NJaiKg+6/N2+rLlYYG2fINXjz6P7xIZjrzX0R4J51oDrCM+rG0hQ5x
	UStgv2ONqCpCWYOdMD2HdUIH40JUYbkl37c/eMPYw3zAcqx0LeL9b2ZeKb7i6wfn8tZGv7
	n9TxGBEXz7+KDWTcvirlM6pxewCOxYw=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a0c09bb78cso8844465ad.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765798763; x=1766403563; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TrKHAwDmwEWPzZzAT0wzFml+5He+R0bXqVhPFRZE9SA=;
        b=eRnppLSapnq6OZ1ZZTmi4WlhxveND9XdJ5er78FZoe83jyjgxDbqJV78pWHIdk1F41
         VV1v2nZ8Ep9Oo9vBRN0cz0njFKTu8ilBtwx05d4vmSe9kjuc+VLBp0mfzzAFxDVhRuJF
         +EA1na8dgg5YVaPtRMJ48hpljF2dnlSv0qOnVxeVrI5QBS19wKI0ABoZLs0rvFvYU9OM
         ucv4r4CrahHchad+PQGwWMbrKFzv4D8qBaHz4YqWM9TNbBOwhHPqTKGFwEmpL8ohSngQ
         4vyz+72sCY4UnLeMDfz0z7as3xYV12345SHQwpDrBeSOBHiyrp9KJkDwSzDJzUOVdR9m
         QVXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765798763; x=1766403563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TrKHAwDmwEWPzZzAT0wzFml+5He+R0bXqVhPFRZE9SA=;
        b=d6aIvTiQYCloFhEsilBc0UNJ+ZT5b03QPs+btrqg7ZARM5rt4ztyLdDg6WkbzJU0Nw
         Nf5RLTitMUe1fiWeZcuFtiOStwvaxnVeSM4mNXoVw2LiIfprhkoP7A4hfZbAtT9WiJZ5
         XDmGY2Pma01OxA4I9oBO+PbZmGiLhI3gRbdM+1hY1+pprPoujPVxBqMYoIqTO3ur3mGz
         Yxmg1REmdXWbBibFa4HJE79LUO+J7GudQzZfmcIix+5m+GGanyeeNWhW8iEu+6bt6Xyy
         G3QjSdiX4W0nPnvypBXk69Yn5Sy16gCUgntlHRM533J8n2+1zfotC3GAAlu1ZoXgyjtt
         Tgrw==
X-Forwarded-Encrypted: i=1; AJvYcCUnZLOHJhJWOuzoo4e5p6nTVC5iUeZ/qdFlIdFEcMsbpga0R5K+PJ50KyKEaj9HZL/fNDBUHbphpA==@kvack.org
X-Gm-Message-State: AOJu0Yy5L+h9fNUSw/fTwW6tj+jBN2ZjApieTUecfws67g13sV962NsX
	GX1Z73CoU2Dh7ZrTb8aoJ2pWd4QWmzAYkwAhGimQVScLZmeP7esYr5Ho
X-Gm-Gg: AY/fxX5Yieaex3R+8Ba7H2Hlbo5JHRLJvrLoPX2DboFGglPtuU5DiZ7kLiYYzB0988G
	l6BmBYEOF9t5TSltmS/VXDOXduV7yW3Hz2O/DI+LPyuDguZwvMl3/R8hP0Ffox8c0LwA2a3JyVi
	9UKz0y/vqjF6wM9rC5pjgah1FX0bnZtmvSR3xYFp0y3x48nbg0vLUMLRujpXN2G7gaaRcm2/Xdc
	33gvRr5sifjyYIJgSTrzzNHuO60e+cudhYQnIoYr+HzQSrS9M5Py9KaGULZ9gdyYRHwj919lxvd
	Xspiy2mjYX2AS/CRaAlh8gozhF+FzPLAtDfAumANw02WF/KVcWLlVQz4WI6meSX6UmmIkLzqRLX
	9328uaU+FdRlQrg/8CBAa9+FGFMwhwuPMknzO3Qr5ai+ll7v/Qirktwu+uDS0dqcyJYhrEXQo4D
	VLAt/TrErHS+4=
X-Google-Smtp-Source: AGHT+IGEKo7pUOqZ/Msgj5pboeIPXCGG8SyTdVwEqd2zfEZHqjnoFfxwhdJcfbexnC7zJuC88ktUrA==
X-Received: by 2002:a17:903:1988:b0:2a0:d0ae:454d with SMTP id d9443c01a7336-2a0d0ae4b49mr35282785ad.22.1765798763267;
        Mon, 15 Dec 2025 03:39:23 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a0f58d7c27sm27523715ad.24.2025.12.15.03.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 03:39:18 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 357B044588D8; Mon, 15 Dec 2025 18:39:06 +0700 (WIB)
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
Subject: [PATCH 11/14] drm/gem/shmem: Describe @shmem and @size parameters
Date: Mon, 15 Dec 2025 18:38:59 +0700
Message-ID: <20251215113903.46555-12-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215113903.46555-1-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1239; i=bagasdotme@gmail.com; h=from:subject; bh=NBybN5/snlW67CYY0LDf5z9mjlB8/ZE5MQWmfMjzEtk=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJn2n4OX/nxidPxCa7t5fuOD8HMfrQSuP1hub/O7ZcKpR 3k2jWdLOkpZGMS4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjCRtAcM/yunTjs9ydWYJypu wYcH6cfFNi1X5dYSuyPxxuv3me1JcpKMDBs+vU9uutHzrUbncPwy+73MjZlbOwIfHrr54bGU4uz aOwwA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: rqpxy3dcuiz8536tyqci7wpumoeabftt
X-Rspam-User: 
X-Rspamd-Queue-Id: 6982B1C0006
X-HE-Tag: 1765798764-424888
X-HE-Meta: U2FsdGVkX19usmuvT6SOLtHu/bP3yfsGrowQoYqFL3X3NvHrRjSArBoWkUvVb1s2fzt7J8+J+Z1eSnMDu/UcVhsFBJ02zWJp29Iw1N0FuIfB09rJZNef3z/ZZN+UwfJmSq1K6cyRsKeuo7EdS2khjRltnqFzufVPpp9KIPJFii2T+lMeqhfL9HZEwFiQ+XqxE4sfWZxMgSi8tkhg8+upo6aPym3nMMtMt2s7LGw+0QiZEEcItd9C1OvYaTsC0pjdvfn5twsDbhLV3J3lcwxdMtAnY2E1x3Qv64XmjnzwgnGaXOmhNL0FR0Wj4I9znkA70K3+usJ3k1AGV/xcXg7n5EMpFcAL4RlWGsOLVZugM01Zf/zq0qHIRTLADJ2GH8zQOuzlQ409rtF51jxzi/CitaaNRG1P026znQgo0ntOTFaW6ASQ1bdkbiUOkWSEYs6p1vfeobZoUfHu00MgClVygqFf77tg0jUVEvnqlytCnLMVIYlPbO/HBGQ+B10Roz89dLbZpsDU1r2IC/jzDvjiiojr3gsjimnVnK7LKd8dAVYmmKjMa8VxIug5ri5Ek+TD/6DBjjZiullw2PVNAvNUA+A3bN2/JrfBqn7blFUjzFdG+2UwrGyzJ2umyIQPF7aSDpBPfUaFsAGq4QvBz8902zrjM3f83N46fLcGlvZUjzCDfGlHJ2UnXCEUEou6W6TcfPIR1Pjkzquez1XNvSMPilAqP5CLJScWpD1qUWD0ouB5uiTR+gh8HYLFrj2ef/9+nshiNh/MMq+guvhGximjEAhwddoGL0YzNhKPQP+s8UaCqxME5MR7/Ik8S+Hbdib+BrKxoBb2zNKtxPNWGNzkRZ47layHP4ZARqudN80yC9fzQIJIzXn7hBHP1m4zqvVgakTG+Li4wE1R5Su48xMYxj0srUnEaQGzSekX2U2eRxhnh4JuU9HWqAXj10DQ3FkpGQwajY7lLra8ilHhnni
 wytGc1hM
 Fxo5GHDfllaqyq83h0NC2DXKCiy8BQmxcFmn4k4tTmgjPE7nh0KERJJolM4ZHA5LClPIp9jk0nMdwGTU+o3Mrwo4LLSGyv9K/SK2IPhmCfY16WtjPv0x3phIku90fFYuiQTT0nEdoNg/j31EUVjGLO9zAhcq+cai29LxgNPVJ1JGZdfBNBP84xnso75gF954HdvFDCbKdCfEtiyKeSfuRAcfKxqUbbckwel+bVpZS1+8/7+FkL6nVmuDyHN7xqnc4i8Qic7/EAFdYMVi47q7ZPeC8y08JGRMs8WRRKkIk/MdJSGzcnr05C6RwcijfBslC/MaQR5mA34l/sakTXdutbLEFQXmyZNfp5/5BnNF+xoc754gM8vSzP0Z3wg0dohYmr0XIKajTzEKJX4y1J8qHCdjCl/Gj9fHnZkNo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sphinx reports kernel-doc warnings:

WARNING: ./drivers/gpu/drm/drm_gem_shmem_helper.c:104 function parameter 'shmem' not described in 'drm_gem_shmem_init'
WARNING: ./drivers/gpu/drm/drm_gem_shmem_helper.c:104 function parameter 'size' not described in 'drm_gem_shmem_init'

Describe the parameters.

Fixes: e3f4bdaf2c5bfe ("drm/gem/shmem: Extract drm_gem_shmem_init() from drm_gem_shmem_create()")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 93b9cff89080f9..7f73900abcbb9d 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -96,7 +96,8 @@ static int __drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_obj
 /**
  * drm_gem_shmem_init - Initialize an allocated object.
  * @dev: DRM device
- * @obj: The allocated shmem GEM object.
+ * @shmem: The allocated shmem GEM object.
+ * @size: shmem GEM object size
  *
  * Returns:
  * 0 on success, or a negative error code on failure.
-- 
An old man doll... just what I always wanted! - Clara


