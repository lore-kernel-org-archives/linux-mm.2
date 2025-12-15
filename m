Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2B02D5B172
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9DE6B0010; Mon, 15 Dec 2025 06:39:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8337C6B0011; Mon, 15 Dec 2025 06:39:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F176B0012; Mon, 15 Dec 2025 06:39:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 523D26B0010
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:39:19 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1170C8634C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:19 +0000 (UTC)
X-FDA: 84221509638.21.29F7638
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0CE5A40008
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XHlu5xdm;
	spf=pass (imf11.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765798757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9thXFyBI9wECeAoZwvjVxFD8Ol9j6G4X/I1qZGpsX1M=;
	b=7wgTRrj6PrKO6Sl894DIy6jXnyKzeTxBqUbZSq2BW/cCHxkY0Ufn9JwAnpA3lvPYvxg6eM
	BHzRp0PfCZl1D/B8q3f41y6xQNSUXh+VxIojNlkC32GetVEsd5byRS7h/qSJLakGJxwI1f
	O1kw7zhUm85qsi+EaFY8/kwlzRNg4aM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XHlu5xdm;
	spf=pass (imf11.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765798757; a=rsa-sha256;
	cv=none;
	b=WbO1htYPw1GeLMdOrbaz0+gb6bzLb1IarnIqonIs9mjdcFgI5/+e1+nGj0Dm6EnlmgMBd+
	fHGmYCPqBK3+SJvMXKRPUP1WaOPMLKlCmJpDdsU3HbhSyfSPNhAXkg0IelXwAJVbFQaoOZ
	5dnYzS8aVE+OZzro3iv3k0mRt1GTh70=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-34c3cb504efso1703642a91.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765798756; x=1766403556; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9thXFyBI9wECeAoZwvjVxFD8Ol9j6G4X/I1qZGpsX1M=;
        b=XHlu5xdmsEn1DPL5Z4XtfrgLhGqBEiDF9Mne4K07dd3TDBODdBga5OlJ44f/GQwilH
         syrcK2UJGot0yAAnDgeurHO8eihl/6wphMOMx+FjiGNWsLaKNzmhLesmnnlXBjqDUYK1
         NhKKbV2KP77AEUbfs1eqPfGO2o26vbsLnkmsbjEVNudgPKsu69Ua2EjUyRR7rawO20vD
         0IgoYFEhD/qCoDZvDhhXDApZbrXbn8pzFzSoOwxqJbCAjDHyage2gioV4pT34Tz284Dw
         5AIx6w7HX8XurKprha0xS/z9dsDke9fgbzcLs+Sjn7duBOLNPF8CKayz/rWmJQXEHLfe
         6Vew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765798756; x=1766403556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9thXFyBI9wECeAoZwvjVxFD8Ol9j6G4X/I1qZGpsX1M=;
        b=sM5bJE07UPlxw66LOEDkh/Oe8T2SekFdxemwDotDN6yQ5N8/QbE6nSCaH15QIdbYgZ
         JtNQMv2d78zrtWNtAND7andi6jdmtwlGWHYJVJy949d6UKtVrMPU4HTLGwNuyCxw/GmB
         Gx13QiIFaKcYo/fiq+XXBzT1JOjzeMl/P+AH38QT1AYmbLaNwkQFO46J7yGnm/uvO5r2
         gGNUKf9osVw1YFjea+1seUqGOxAhDPRDzB75xY6fhOfm2WfmVtYdVCm0LL5avpNa4MEz
         W5qR4/vTP7MD4wGX+1D8Ijk3GHHa/B76fq0TBO50JitTHf5z02gz7Bfk2mhDVwm63XcE
         8wNg==
X-Forwarded-Encrypted: i=1; AJvYcCUze7ssEo4grKDbF/qGcv1f36eMTJjxEe5zwMrXU8nDyvP7hg6CDkj6UDI3gdPkAo6mOqXkGEXeCg==@kvack.org
X-Gm-Message-State: AOJu0YzQDQbLBHtqC6PJEN5dAgIQDzlCqnTfixkY27FyilF05GAXX1/g
	3PhYM9NzyFykTVXZ/boxrtM481CFX6gjObcG6zQ4uKjr5pBGZfyxldMW
X-Gm-Gg: AY/fxX5XIwtUmHn9rqokzQEWe1SFhLYXuf0sT8HVFalHOR1qJH0AIclStYf5Bs62f/g
	3CkqpYbQm/i2tg7nsnQ0q2h85H0vvkyVA9UZ/6FlcfBXOuNjt6lr7LIhov5vIbW42ILKAYhXKJ+
	vJxKM8bDtrQLIW9ahR5r5F4mx+m+15jsUQnIYlDOkvbmb6Xm+hJY9VTXxrrDKw/TnDh+IIFTw5z
	HVkulxDjhewyL9inr+8iuwOewPa/VZDzk18/xbbJCSSy42XYkvLAydSNQL0k2KRplDtcbKF/eJl
	0dH+73C2iHKOOjlxJ27Q0Tk2qiKkZEdse0zZV9bNZcIo9RLfNH5K8k5NxJKpYW37sNokOttHiCB
	61JhdcdfMNlik9uvbo8FlrdOeLwwn9SHhrC0btNPTRpv+23UaViBA70fDMkJNu5vJ26Mm4amEMC
	tBdft+edZ9cOs=
X-Google-Smtp-Source: AGHT+IE3LQMlInYBtZW6kVYJLJE4CFzfJfm+/f5olU3OmDWyxxykzQlHP1rsXKl8Sxl863J3gFT+2A==
X-Received: by 2002:a17:90b:4b47:b0:33b:8ac4:1ac4 with SMTP id 98e67ed59e1d1-34abd78051dmr11974090a91.35.1765798755860;
        Mon, 15 Dec 2025 03:39:15 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34abe294892sm8918293a91.10.2025.12.15.03.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 03:39:12 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 9EFFF444B395; Mon, 15 Dec 2025 18:39:06 +0700 (WIB)
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
Subject: [PATCH 06/14] virtio: Describe @map and @vmap members in virtio_device struct
Date: Mon, 15 Dec 2025 18:38:54 +0700
Message-ID: <20251215113903.46555-7-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215113903.46555-1-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1385; i=bagasdotme@gmail.com; h=from:subject; bh=bVwk3E00Ao0/BsL4XlONNDCfpFF0qzpzGvJu4GqJ/kY=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJn2n4N3qByLSAtcbrWEYbHxfzPeVTVyK4Naco81fnbf9 sGw4M+ujlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAEwk4Ckjw37unJpIS7sDggaL LUJm/L7quGjlN51XE6JFNZoPynqvOsvIsMhqy5y4fbtebC8768S8lM/yytfC9QdFWExtD//Srpa 6yQYA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i3irb8ewyh6fw7xefkreiqhcdjcawzm5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0CE5A40008
X-HE-Tag: 1765798756-540961
X-HE-Meta: U2FsdGVkX19+xsYfwmDyztgF389CGO5IIV7nwdDrzNgVf00zR+hHQTNJfHWyKeZ7uLUHScPIvAabMbB2gzU4w016dbs0lpteDGoD5IDkf0+NgNqJura7LMrRw/fj66ilCO6Kdw55T3euuqsnyjv7yTGULfycDsttrq8uSlXDdsYMtVrK+3SnT/taVD+mNhEklCQW9vrSSaeXoNjGpH8M3huiB4OtkVezcGAZAfmasI+T6gYOBHFntDFSNZFPl81oARM4xHr5m0gxaGjtNCUQYJDTAZ8FN3nJ+Wp0NDUHTfWNcVKdwLbXtEzQK3hQ5Q010CppAct3Df7qrqfYMQYgY+gTyW+tyclsm6rgJrgJzpiD/pBuxvbbD5op5EOWpyJ7aHg158iZ60x9FoQc9m5uDqb2OFTbEwUdh97HDao32JA2Ga7fP+UzqKRCpGhOYd690JIMYr7C5+T7NATvUd9qhLfdFgPY1NJFC8QyiBEODF9Dn0xz+WIkU36/m0PYc3Mr25NPjeu9Y3cjO8AOab4yXgtQ5t0OiJM/QCeyWCiY/GbL5zvImTTFd+RNaKG60MjPvX4IaJ9MDeqjYbWBVRZNsdJYMZcbPw4IeYLQPSRKaW+Y6dMjRSefharFn7/KVEXH8G8dMhv7OEaPAhZbZO+p8kpHKMMmZxUSf5o2nKUqylqTNstGAsON7TWid85LLxcmbLUyzBppYf2p9yQ84XqGY2CaszMNPnm8E1zPJg95nQJcBFnRMQvQAsy6hXvyA9z2JxNrMv8ib49GYkAihhXBBKO78WtBNNJtWbTS7gLBoTqtopXp2XDgyiO7Jz2ZWP98hmcmF3HK4hLLBf6SJdXOPaAdj4/XHjjJknE4WhsNMXcmrWWTCA6TsbyVpcGR/d1wjZTiiqsCg8NCTRcgcen+PdxEbKedWJa++q61GKOGRPaa6qRfQbcytyIkZXNrmZmsysEuWfSecJbjeu/ZuAV
 levalqEd
 E+Kut1eRb/hq0lv0Yv81UvFyKKNvZjI6ooFAwqFwUYx1jsIM06wPk4ysXVH+ExiZCGYOO1K+Glgl2i7PopZygmDCbf+tmA15ZfnJl11LTEfte/LVdBKGjcOO48R6b8ve+ZnJXQLg0KAY8HUq25cQLvGZhho0XvWRsrHQic1zW27lBZoODsl8a6z6bx6CYU9pxCRZA3S0VbVis0/xBmD7glfJAdoMJ49zM/4pgI97h47cX+rCy750VqYdleI9Tit20vy91oEkp/ejv0xT6IMgjPlVklqzIFDu5i/d/jCEwUjNUf3bTYar3mhjywrWEeW9efFzYqXU3QnjK3+Q6Me2wpzWxtKtpN9m9OrMsqL8axvcLje+lXU6ER8qiib0OCtqURj5tlxEg5Nsv6Jjw2KFMmjgDaFlx8KtkqeMUwEX+spKEvK4tlbXu0SxOZdMeU4PUBpZsgCbdu6bIxZ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sphinx reports kernel-doc warnings:

WARNING: ./include/linux/virtio.h:181 struct member 'map' not described in 'virtio_device'
WARNING: ./include/linux/virtio.h:181 struct member 'vmap' not described in 'virtio_device'

Describe these members.

Fixes: bee8c7c24b7373 ("virtio: introduce map ops in virtio core")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 include/linux/virtio.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 132a474e59140a..68ead8fda9c921 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -150,11 +150,13 @@ struct virtio_admin_cmd {
  * @id: the device type identification (used to match it with a driver).
  * @config: the configuration ops for this device.
  * @vringh_config: configuration ops for host vrings.
+ * @map: configuration ops for device's mapping buffer
  * @vqs: the list of virtqueues for this device.
  * @features: the 64 lower features supported by both driver and device.
  * @features_array: the full features space supported by both driver and
  *		    device.
  * @priv: private pointer for the driver's use.
+ * @vmap: device virtual map
  * @debugfs_dir: debugfs directory entry.
  * @debugfs_filter_features: features to be filtered set by debugfs.
  */
-- 
An old man doll... just what I always wanted! - Clara


