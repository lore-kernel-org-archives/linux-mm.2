Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28ED4D5B16E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FEE26B0026; Mon, 15 Dec 2025 06:39:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43C226B0029; Mon, 15 Dec 2025 06:39:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1567A6B0028; Mon, 15 Dec 2025 06:39:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E25566B0027
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:39:26 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C98F138721
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:26 +0000 (UTC)
X-FDA: 84221509932.10.7F00CF6
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8D49E4000B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KyU1DPlT;
	spf=pass (imf07.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765798764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFsNe5Gu995f8GfU2RxaYzwbXM91ZCVhfkD06BV90tM=;
	b=AFZbBqepXTgQtpkUIqJHxBwvKkjTYWct+qLmnwDqw1IeAv890i51xnR3jSRUEbXPooFEAM
	ev2trm9FLWSgKa1VPe6EaVJFkMpAA/fkZrRtwhIxwWak+0SoidY9MzRhWFBLliTUUhbKN4
	hgD/9MAPZPVcjARdMB+yVm8RrFgwarI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KyU1DPlT;
	spf=pass (imf07.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765798764; a=rsa-sha256;
	cv=none;
	b=mMXI67Edt6/aH3FB3xNBuAY3Rcmrtb/jkhB7HYMQ80C6Ew1khUwYudZ45QD/IJ8Q/SZOKv
	uXpY+B6MR3pmZPKZNaNNGBn4n6A5N2ZtTq/2pq5gpys8m/N648rIJbwqz5/MBVzZqLiHh2
	SVHQKSdLjdzSBNbQPVuk1wKomlV4sQc=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-34c84dc332cso993279a91.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765798763; x=1766403563; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KFsNe5Gu995f8GfU2RxaYzwbXM91ZCVhfkD06BV90tM=;
        b=KyU1DPlT147sdjcwCA43+s6FPLXsm5z9gsvZsi1Oe5vbb+XXSTAG6HKV3crAcCZKL/
         Y2PZqn/Qhryaz7ZErBGH9822PoRUe1Q4qazf/7SHZgoPVl1DKn1272KItDxioGAkuthJ
         KDQDEjd74tLX82FKY2/0v6CJeV+n7+0iaunGBG+I/3h0scHlUCAmIaIDd39VSFxVkMxj
         88Mh71t7+PzP8vK+9QUNc7skO0mzQttFsU0TLvfbhL6bkZwby4TdAH6YMgW8EKGT2viI
         3vDMjLLzxYuD3NDB8zepFSWlqHaBCAnH9OX9YycHkQPAZtUbpruS2MyH+B+YO9ZiDR6U
         dZ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765798763; x=1766403563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KFsNe5Gu995f8GfU2RxaYzwbXM91ZCVhfkD06BV90tM=;
        b=CYKS5r7UFRzIz2vpnj371Y3UpciVEk0pdf0UtkHokPsJDTQxfhjZNp8Gu6J6p0GWky
         pcsLjajMK1x14FiMYYkAqh9GdpEo7rjlYqYk/V0OBgtSM8U170Lcl29wFFPaHl4DKdIt
         +t/Qh9otiPCFr0t7YmyzCENp/1NLaSV4tb8qnQK7XkUTQOw73+3vU4lWAvWnDjBHTuug
         bGZXWb5t1sEv22Azj6yipZp/GitNhg5jds9018smk4MAU0MfFHP0eANBQvLbD+mCXkFd
         CYUWHoX7NqhkhBWfm53R40UfInv30DEHXjEtfMJiTJ8h+VEvggy07KwOmDYTFoAY0dZd
         77Lg==
X-Forwarded-Encrypted: i=1; AJvYcCXpwdP9zfkp8b4K0XQfm+ZW1p4MH3pIN7U3wldBPb5T+O7sCHaiy+u+XWUk6yOsSdQeORToxY5bUw==@kvack.org
X-Gm-Message-State: AOJu0Yw74DqXwgUNWOQRN3gtaZXGBXp2zQaGdUZBEYlo6PyoMu8SWomj
	onDHRQz2B4ORQn5I3zW6LLyOxovF6AgdPAbBQJYEa8M18dl9OQWtRv77
X-Gm-Gg: AY/fxX6SFazArg1TjfRVH0h1WJh4/KkAJihVXRafCHUu5NuQAP16KW9guFTphr4VStC
	hHr9hVipD8SECuEWEeGyK08Wzdd9eMSerWtiRcjj4y7pPIGT7A3wx2KT7wL0eMe7q4gCVJ3tQCx
	DBUCzFvxNw8FWxHA8KrgRRmtdViLMUQjQrAHgJslNbmT8Ks2xCSKdl54k1bb18mU5xNf1JIYeav
	XZ8wPBmlr0YhlXifWNbmLI7HdL6rCfstCTgE8xf15weYiJWCspOqYZ5A75Z/HIP91gbrVZ0yBbL
	Gy3GM+lSKzzjS5i2i4KkWGXOpbg0cegSVBumiU/FB2NIi159dUhjAQknzPUJ9FN5AFn/1x/aJEZ
	a6wU6Xub7MJ8xhmKCsQXSjFcitkjOqxMdJBXUlVYkW7iuRIebPTtUteW6uXzIWW8or4HqNAM2vL
	jcPMUXaEo35Rg=
X-Google-Smtp-Source: AGHT+IEy2tcNugFFoZ/L1b/kwWL3FdgAjYD+lvIJBPYKZMY6hs2UzwV9S1AhT0ES6IDo2vtVEhI5ug==
X-Received: by 2002:a17:90b:2811:b0:340:bb51:17eb with SMTP id 98e67ed59e1d1-34abd6d35c0mr9572904a91.15.1765798763360;
        Mon, 15 Dec 2025 03:39:23 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34abe2f34c7sm2908684a91.9.2025.12.15.03.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 03:39:18 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id CA7C1444B397; Mon, 15 Dec 2025 18:39:06 +0700 (WIB)
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
Subject: [PATCH 08/14] VFS: fix __start_dirop() kernel-doc warnings
Date: Mon, 15 Dec 2025 18:38:56 +0700
Message-ID: <20251215113903.46555-9-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215113903.46555-1-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1286; i=bagasdotme@gmail.com; h=from:subject; bh=XiWwx/yBvL5qhtur1OJ6r0Qtve5kN/UAKMQDFDv8Kk4=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJn2n4O3vI8WDrMwXuvBLq8mNivp3ZeuaVYeu+cJXRZ0u 9ehPPdrRykLgxgXg6yYIsukRL6m07uMRC60r3WEmcPKBDKEgYtTACbSG8vI8EpCRPb0s1m/77E2 hv9V7O9IOeS06tfyqjLP7/lK/+xuKjL8zzy7NtZA+f5K8VWm3d9utqf1737naLT7ZsEzs3nvY45 PYQUA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8D49E4000B
X-Stat-Signature: bxjm9sg5q1ccq8gxepqo86ags3pap9jh
X-Rspam-User: 
X-HE-Tag: 1765798764-978070
X-HE-Meta: U2FsdGVkX1/kCSiMrOtBniUMshEpyPhzCbf0egFxkT5CkjbH3lZncXU978DDjbxboMfQGfaTSJPUPlwfQJSu4YFAiD6UknfuHNTb1fnOy9DnsgvKCJTjVGdIJwST49sUpNrPindBHjIlIiFFijPuiEYTkhNaWelaoIDXHU5hGlbihXabdQ+B3vaVe1nhRwX2kWFMmRyi4wCPae63/4RjPaFkF8oMftlV6UTCVEMx6F8QCBSyteVQGCF84V5JWJ4rLKsX4fzMY04cZ179rk1+MtbKLIPDK0sKI4ef1sNYXSWNxocoSx6+9tJYiaDye7VW7L9AvAHVdNNB1x3slX7n1JbTnTKsg1SBE38svhfJMUcdUh+MOa+d5FykpEjydBruxtH2pxFEZJUu8uEgVDAca/Xzame8LBYOyfurV9UduTpon+pfA0FTwvgngeFJl5u/8vrGcgAqNrHBxo+FKUHTVLys6lzDXa+Uf9RbH2Ph0BX8FoALQtyLWTuK49UjvqgRmEjXldtHEt1ylSg425Z6/QItwePVOsCfA9a/U/GdMeKtK835B+NNPOxdjQi8ni+7SCVwoXoImYCPuLnS1z1YH3Obh96hjokT04GpWQVhEGSXqJXSS+bKY7POpJdnHAaEOpKUMktvPdYgqn6DZe5eH1PuRYbws6gYcD5+j3FCkqu1g6wbIIQpqow4PAWRpiqijJOc54bZ06EfisWV/jnVcx77AWwPZTAd5/7OcdBHrHx6ycy/7v2+C13wXQnANtkTFQK+CiVfcfMvDtFBxg56KQMhzHDBXi320swwpxf3SIAesfouG3vcokJpOk4KiO8V7nvTg6NrTVgBXiO+h/otHOaOWbhxkpKB91lkkLD0Hge3PsVC+eCtuhk20opEJp3Op54MtdXjhBTJb/eaOOQcyGUsCOCebv3K6NP/NWanDKKY4bpuNKvzX9kIPR/sPM26fvNjANeGP9JAbVSdiJy
 1XPjMMvQ
 qNq4kIy/W0lDL2XeWSG8NKWDo2Jzjb9HoApcsUGjnEWH9gYrepph9vYIVwztBFNzZo1WL8mZzPiVqmfNjv7UW73YSBCrkbCHbsKeJ8YcrItAn4IrZvMQRWWCnRI00d9cOaYIoiIO3lr+k/YAYMOmmSvOWPO0NOKPms7hfdsEAxOZCMNfv6OS40tCpPGFxwsGkcNs945T2bTR7SiMpw5M82rBUtFckI5VFkHwpTqGZHmn3uTTUyZ5PoMyIaKoJEhdFYMq+131ikdSohNS/cLGrKEscz3DxdsCaR1wclw3xDTyzPRmFUJcV4utUFN0+5CUdV2/EYimEAKFzTs1Co0IpF5wEyRwFLUkRtgBFD6GOMoAuN0kitAtPiAFiRdTBcwe2YDgzXMDKTBmRFLy6N1o8hLtZPdbclYLhVsIvJ7t/C0/MJu6tbBDFZfbGix9lV0YCHg/glwEnB1h3/c0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sphinx report kernel-doc warnings:

WARNING: ./fs/namei.c:2853 function parameter 'state' not described in '__start_dirop'
WARNING: ./fs/namei.c:2853 expecting prototype for start_dirop(). Prototype was for __start_dirop() instead

Fix them up.

Fixes: ff7c4ea11a05c8 ("VFS: add start_creating_killable() and start_removing_killable()")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 fs/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index bf0f66f0e9b92c..91fd3a786704e2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2836,10 +2836,11 @@ static int filename_parentat(int dfd, struct filename *name,
 }
 
 /**
- * start_dirop - begin a create or remove dirop, performing locking and lookup
+ * __start_dirop - begin a create or remove dirop, performing locking and lookup
  * @parent:       the dentry of the parent in which the operation will occur
  * @name:         a qstr holding the name within that parent
  * @lookup_flags: intent and other lookup flags.
+ * @state:        task state bitmask
  *
  * The lookup is performed and necessary locks are taken so that, on success,
  * the returned dentry can be operated on safely.
-- 
An old man doll... just what I always wanted! - Clara


