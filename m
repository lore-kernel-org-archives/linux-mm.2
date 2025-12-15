Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60558D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 945D16B0006; Mon, 15 Dec 2025 06:39:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91D126B0008; Mon, 15 Dec 2025 06:39:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796BF6B000A; Mon, 15 Dec 2025 06:39:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65E9B6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:39:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 166061DF393
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:13 +0000 (UTC)
X-FDA: 84221509386.05.5802CB3
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1C03DA0010
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q7Q29MYQ;
	spf=pass (imf25.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765798751; a=rsa-sha256;
	cv=none;
	b=1Iyh1F+CyiU7bt8CZGHfdVMotmOghZ6rsKXSI7vj6lE/w9KU8+BiG+AqqIDAJTPqrHfBF7
	iIqMeuy1getMHjN3do5BqtqpAy1QUu0H1lFpbgxUQ6C8yM2ZHXVftXrzWCP6AORIpTGagf
	AbNYS99emuI/gDhHFPMM5r1r9pob5Kg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q7Q29MYQ;
	spf=pass (imf25.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765798751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rTcY4k7PJNNctnILuEp0lcvqj1X2scOTc/Z894ZNYfE=;
	b=GzKTrk5hrJ/SP89qeZYSnqWnMQBky4fl/PvSXYACJRwXs4fXhAcc2dNVRN4G0yif87ZeTX
	/E9rVBYsH/kYJkCKUM3K3eVpBwcics84S+6ts0ZWJgXo1qnTeJgDOwQYvsjFUc/448d/Sd
	oqbX8GNkARNJQLKcglaSbF4g556Nu4k=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-34c213f7690so1777810a91.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765798750; x=1766403550; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rTcY4k7PJNNctnILuEp0lcvqj1X2scOTc/Z894ZNYfE=;
        b=Q7Q29MYQqOCuntZADBdK0RvEeYMcIMSD4nHhAdHIvFB8Xy5Yt/FzGsIctei7za0Co0
         w2cPoDqmx6SHBCL8bqLEqnHAbyxETKWZ1Okhzf1vXps+chMmZW2IBeCAArImX7CaGD0d
         UmEP0UTNjeBuQT9yKZWpx6OR7O0tCbYWmzxOuqVuopjF4uLqFCel5o2kskb+qFlpuvxG
         3Lq/MngmJCLgFWgq5c9AFahpYS5QQgLphwFVzG1wURfT+fbYve2mUr/fkZGOUWVbykPb
         m7sp++g7e9SFwLpkmiEymbN5MBS6U1VJ6QD1W2lqP9+v3uoHPMTMH56cuA/j6/67f4pr
         whAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765798750; x=1766403550;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rTcY4k7PJNNctnILuEp0lcvqj1X2scOTc/Z894ZNYfE=;
        b=CoyvuUKo7d0r6CL4WSMHLMg1Wj6poSKrBGWU4d+uWy5ZdhFK+rLTprRlF5hy7iSRG0
         XF1mHqacrRvts0DW4EOJ9ZdioEB1X5ks65tTK59Fw+dk4MtpNPSVCV4AqNmPxHbxSjG6
         hJMwUmgShp9Tu/JhxTe95xkWDBcYfBbPAbVUmjA/Sgabr/y0o9r4jyB1afs/W3xy2t3k
         5W2dqzQnDWyFMWG5RGZYNzMP2BkWZRcjuBRDjIoXQrkBFY/zyODZ6R5i72m0+rIh27q4
         kn4SSxfgmxfTQhc9HcoV9Un+LNJKv6GdSOCu2fFTbNL1sIt+sH6cAtIa4WiZJo1pZw1P
         zYWA==
X-Forwarded-Encrypted: i=1; AJvYcCUfVEGbJqLfeGVPYYuq4dWIR9BMzDo7/JRCxGMzpWdSyRkMp0ofbji8GmDGTs2rZUo8UmSAvpD2Rw==@kvack.org
X-Gm-Message-State: AOJu0YzbiCN8Y0FoxeR2kNVBcfxcnQfIU5P9jtxBaOOabWZVtogveats
	ec1/s4QP9Cr8njKs6BIC5qZhIcB0y05hxHDNAIyjE3uk1jLQizmJENj1
X-Gm-Gg: AY/fxX52gNiRdb5DYt/Ujx/OeZcSoR0qsBQoZuxj7/gzydvQaca1wcnzkbAYtzPgw7m
	3csax7jtyQ/KHZ2ifH2AWJ1gVVt7IUa0vASutfKdc9sWLQfdCb2jlipyoylTTFXRnj75qUmEdDI
	RWsCjsI7Td67C/iBckR/SHrjJ1thMcMHrhj+4uWpG1mwgPvdW2r8qcLu40ILBCiTm5AKomuREVR
	3FHJDvsjNvbS8Cw8eTpFUCAkSN+uz6aXeDSJn4RViHXHe33Me7sTZToL+pQ0MVHUAs32lCpBkoH
	4sL2agGAjmIc0XyUeSgWGISj1t9ET/6ZO401vwrJeyWJicOPG5Fk2l162IdmdBb0MSq2K3dMIDF
	f+yEZJmjQLqtbSuVXgez2ukW0kRyvZUfGRQW6XwZW8RDVRmsuuhRCgsAmX7EAFVCc7k/OL5s7/1
	8mGbKCiGY51Aes2veCTuSVlQ==
X-Google-Smtp-Source: AGHT+IH7Y0ZP0SVYlRqXrzHx+fOVv/+/V5Bjimjq/e2I+okG90jQDlqbjW8VY0Em0JiciGGZ262G7g==
X-Received: by 2002:a17:902:c402:b0:295:c2e7:7199 with SMTP id d9443c01a7336-29f23c7b8b9mr114062105ad.29.1765798749863;
        Mon, 15 Dec 2025 03:39:09 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9b3850csm133386495ad.17.2025.12.15.03.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 03:39:08 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id AC75C444B38F; Mon, 15 Dec 2025 18:39:05 +0700 (WIB)
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
Subject: [PATCH 00/14] Assorted kernel-doc fixes
Date: Mon, 15 Dec 2025 18:38:48 +0700
Message-ID: <20251215113903.46555-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2064; i=bagasdotme@gmail.com; h=from:subject; bh=zPsruu4atyDYOaQCsKIEqnFkDKfYqb53HHp2txNqt3A=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJn2n4MMm/867RRu9s/LeXucS+TRacFsjy3x8goRK//G7 Jyfu8O1o5SFQYyLQVZMkWVSIl/T6V1GIhfa1zrCzGFlAhnCwMUpABOJ+cjwP9rl0j2O1i3mgnEF j0tV/6z5nLTvdKmsJY/NvB286XtLTzEy7D+8+dTHe63Sb6bPXnHWT1NH5vPMzba75Xe45yw3OaR ZzAUA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C03DA0010
X-Rspamd-Server: rspam04
X-Stat-Signature: e3c31u5j3m5uwyd8zkj18afk6nd15bjm
X-HE-Tag: 1765798750-844933
X-HE-Meta: U2FsdGVkX1/ZmlXrkwaiVLJk9Cirr4/AaY6NsVkgM3sN5I5t5VcrWU0lFUn8ocBqAKOLm6jVeFFo5QASNvOrFTQHNBGbzn944YGNqOpMQtKAZvLRXgnH/vYj+xc7syTiyloHiqhUDNi1m5o/LMkAIS9zVU8Y3xAfAvReYvbhLognBiUAJxj1G/q0WxukAvPeo+20HH5poUNhghZF22g/DAf1TZwCGPDPuNUtWpcTnPMvP+rQ4FwsS/R2ufxv7DVEp6VLwKzHNr6xi+rf3sqTek3bVCRr800G/aChlFDwNs3+5hiOMzTs1MSREBrKtxqyw6VerPa1kSI58YpOxeSjEY8dL1YfDzEhLTxxMMWDRi63ymbazJMxc8SSadU28XlTb0qZdJ3VMR+vwre2ELggBjS2PgQoAB11AY7Pjy1mrOpclpguC3ZdtZSquqUpioMvWUxvK6csRSDXSO8WfBVSlelZEwqzo3z0e+SjLCQVFpj1f5BSHgmsu9ryKlga9NanPp+yYBVs7Mg/JHFsuR6QyGqtUydsKHuBhv6n7yyyqqYgOqNI2sVrNrFwK12PwH8pf1oTY+EFXrcMBIXEemGBAjwZDKOegeWHPuw33WlT0xptmASB7HhT80jhpzyT64T9dEuBJxJkIqqUj1CEeMdQJm5uWoJd9kR549boVupCVLBTaHkXRbCQzrxQLYx9GJ+i7ChyIjLuYLfyb0j7xrxI2NYZuF/DtJWk0FFBJ18Lxy3rRr77cDYAtB+5yZ9Ntd7tZ+DpqUM144wYsrCkMXijnNqAc18cD8GS9fhUBLKyQocrp/Kprw5yCSvNEsxeUUG6l/WRSCY4so/6xg5bfudSUP2I9ijq5qF3Tfdi2flJeqtZ2LhPoMqLEmhxLLUYd/zWTebm9F4mkA6f4O4eDwVfvK+RUwQr1a8hGvbSGgni6LeP2E1qGpTStQ+veILwPbGamHGvlxXqrnyjUOlpbRd
 V6WnGs+n
 l+lHeNhxE1kRd/3ujBHzMprphIQFAE3IrDRF0cy8JOobDNBVrbgpcf9dyTpkfMZcOWRJBqEZeSiPCO3cCgiXLRQyxs/fgoaU6iy8QyfPs+xnLBUYeD0ctxxf2cpaEdOEeQ85annTt7+FDwyFKX7LsFrVYOG4TUnZuB9yHVEc9MtOpUv6qetA1EVFLPzkJwqxQFghaDmWrmGSs6d1KzwOCuiJA3krrru7g8vv4mVdfentZX1tHNbzxDP1H6z0mdMQESXTlbMERPbusLLtyjAujL4Qvki5dDzWRpdBNNS6fCSKc8212QK9Fk4mv1fz7oSTCydHU+6t7nWhQZVzb/lh4xmOVfvofeUBA7RjMJ4Lr/5ZbeB9XUBs+YCfOAzeIybXyCc/COV57MDX4QGg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Here are assorted kernel-doc fixes for 6.19 cycle. As the name
implies, for the merging strategy, the patches can be taken by
respective maintainers to appropriate fixes branches (targetting
6.19 of course) (e.g. for mm it will be mm-hotfixes).

Enjoy!

Bagas Sanjaya (14):
  genalloc: Describe @start_addr parameter in genpool_algo_t
  mm: Describe @flags parameter in memalloc_flags_save()
  textsearch: Describe @list member in ts_ops search
  mm: vmalloc: Fix up vrealloc_node_align() kernel-doc macro name
  mm, kfence: Describe @slab parameter in __kfence_obj_info()
  virtio: Describe @map and @vmap members in virtio_device struct
  fs: Describe @isnew parameter in ilookup5_nowait()
  VFS: fix __start_dirop() kernel-doc warnings
  drm/amd/display: Don't use kernel-doc comment in
    dc_register_software_state struct
  drm/amdgpu: Describe @AMD_IP_BLOCK_TYPE_RAS in amd_ip_block_type enum
  drm/gem/shmem: Describe @shmem and @size parameters
  drm/scheduler: Describe @result in drm_sched_job_done()
  drm/gpusvm: Fix drm_gpusvm_pages_valid_unlocked() kernel-doc comment
  net: bridge: Describe @tunnel_hash member in net_bridge_vlan_group
    struct

 drivers/gpu/drm/amd/display/dc/dc.h      | 2 +-
 drivers/gpu/drm/amd/include/amd_shared.h | 1 +
 drivers/gpu/drm/drm_gem_shmem_helper.c   | 3 ++-
 drivers/gpu/drm/drm_gpusvm.c             | 4 ++--
 drivers/gpu/drm/scheduler/sched_main.c   | 1 +
 fs/inode.c                               | 1 +
 fs/namei.c                               | 3 ++-
 include/linux/genalloc.h                 | 1 +
 include/linux/kfence.h                   | 1 +
 include/linux/sched/mm.h                 | 1 +
 include/linux/textsearch.h               | 1 +
 include/linux/virtio.h                   | 2 ++
 mm/vmalloc.c                             | 2 +-
 net/bridge/br_private.h                  | 1 +
 14 files changed, 18 insertions(+), 6 deletions(-)


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
An old man doll... just what I always wanted! - Clara


