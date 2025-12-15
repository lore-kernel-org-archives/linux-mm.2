Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC5FD41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E886B0023; Mon, 15 Dec 2025 06:39:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463366B0024; Mon, 15 Dec 2025 06:39:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241F86B0026; Mon, 15 Dec 2025 06:39:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BDB66B0023
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:39:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CAAD686148
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:25 +0000 (UTC)
X-FDA: 84221509890.07.EDB5304
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id C3724140005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TVKrju1X;
	spf=pass (imf09.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765798763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1jHunOtVkIwedmQvRsrzJgL7loZmMhygmTOE5iX6PY=;
	b=7IKcdulVPNMA3wTmp5iaQglWTCkupzr+BI+jUa7/aL/twJ/pwKvq8WFK1iBRvQQPE0xCz6
	MMb8S3yKFZiCGMfA3WlCsY+hFo/eKGoBL1EzPLVOJRMnJbdUTW5ed0jCjHn26AVXMq54MV
	hnMtXnzKpRLVLfCcABewaCQIbYZcKBQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TVKrju1X;
	spf=pass (imf09.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765798763; a=rsa-sha256;
	cv=none;
	b=Xv1C1AcdveFdrl5/3UJ1TU2VDcJ8IW3ep/04man9ZcGJ1uJfMMd9KeF2QdX0oshe7YVwqo
	0TTvxwyX/o+ZinJ47ttbybzgvfqr0XLbt2RXbaIs85MIriTUVK2BHN6VDQQfY52fiXIJRk
	mYnXnmOEntMV9piDgAtieE0G+pc7Cio=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a0b4320665so18484025ad.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765798763; x=1766403563; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c1jHunOtVkIwedmQvRsrzJgL7loZmMhygmTOE5iX6PY=;
        b=TVKrju1XiOMHDnP0wIZaF4Bp7u1Y/pvfxyCDbxPJzsbdoTi3sJho2IWGBrdQfJX2WL
         GOi4DnOCvu0tVwDrPxAq7bBKv+BwA3awv5fSNoe530vjlu66lLmVxkKlbflMgAgRizPX
         /KTyZdB5k97Ddrg3zJjq2RzQRnuYAPWtiNRpH0NvUjNZMCXOOK+4mJfzhwx+BvJTsbNF
         bn/5tDdWxa9P/8OGL7ib1vYhFAdvtZ7+Z3XfsPB0VaKdMVcO1f221dKmh+/SKR71a/PS
         jaO6FghY6ELDtMu8ptJr0xTg+uVa/ZAuJ1KRWcK3wRFMxcMsNqqJlOMEFwvnAEQb+wK/
         J6Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765798763; x=1766403563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c1jHunOtVkIwedmQvRsrzJgL7loZmMhygmTOE5iX6PY=;
        b=kokqGFTEGdGDUsjUu9Iqjvq0WiUGqQ1kYYXAkFwSRoliiQzGRQsK01yHL/bHqMlXEt
         CHFTk88CdN4FJOIBmAMpYXFfsrQE7WySBCBTQMAQ5ZRvQUWLVDyvl79zUwqiDdpHOh3z
         PXazajr1c2tcMMK2lqP5/ZlHbu5iPTYP2xaaPcyGzI6nbtUvJ2lOva/QWn8fCa0hqH01
         xHeegD8rXmD/of5sI2i1kjeSFrq5FH6E3sSjZ7VbL58DllsHjtDHvdQBy7NtCnBt79G/
         tHv3Q+zznNCWmFDNQsW+8dSpWOEWP0HdxV/zX93WDi+TxM01EgSjG/2IwRXmd1yPGUnp
         maqw==
X-Forwarded-Encrypted: i=1; AJvYcCVLYiGoYv8BciydOzwvhNJThOZHe8Boe+gIt0uoG7oq4a2k46yv3V8QU/7H+n/6KaUMAFQ1s5aihw==@kvack.org
X-Gm-Message-State: AOJu0Yxr/PJXsw003k8lWBX4D16jApYYiBDz/PAFZAzJ4k5TvjZ0nCqC
	505wRx2+GKvlAWbVfcK+n4wRT0iflRq/UeWuSllugt8TyX+cUk/kzcbg
X-Gm-Gg: AY/fxX4Yt3Bsaag1CEDgRrXFLHRBR0bg8HQipAvQDHU2FJzkBzCmW2n6WvzEcVprlkD
	i0NDE0TQdFJ/vig9v9PS+gXY6HsGQxVN9seGWu/a7zNcTxh95n2lv79NbNNlt9imlJG9ZYupIwm
	a9uYCfxF7U7Z1geWNEF85WoFBfT29R5H/zaqfgzh3e/D9Yzf5Ffl0L/0smRz1th9T2r3LiDVaY2
	4OG+z3IaEVIEESKNrcgpolNv4c6V+1UtavFQEfOADrie+ODZKlYk+n5y6rzTLJPAFhSCJJyxKD2
	rINHy5WdWLRX/2afp7yQdr76jnH4iD7rE+2d8B92pPeRSDzavjE60/5EUipR/Yev4linOzWhXyr
	S8R9AoldPoPc6Uct+JRhyyi9Acvy9UhFtFwoebgNi9/duWkKm5beB+n6zj0gfY9D2H5NjEPQtqP
	o10JbFJ98K4rE=
X-Google-Smtp-Source: AGHT+IGkBlvtTJJI36YenJR2Mj5A83uVH+1orPi0BLwAvata7acR5hue/qogcd9VSy03MC0if9MWYQ==
X-Received: by 2002:a17:902:dad1:b0:2a0:b066:3f55 with SMTP id d9443c01a7336-2a0b06646d5mr58199625ad.10.1765798762558;
        Mon, 15 Dec 2025 03:39:22 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9d394easm129684215ad.25.2025.12.15.03.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 03:39:18 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id DE7F144588D6; Mon, 15 Dec 2025 18:39:06 +0700 (WIB)
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
Subject: [PATCH 09/14] drm/amd/display: Don't use kernel-doc comment in dc_register_software_state struct
Date: Mon, 15 Dec 2025 18:38:57 +0700
Message-ID: <20251215113903.46555-10-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215113903.46555-1-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1238; i=bagasdotme@gmail.com; h=from:subject; bh=g0JdaQypaND4lTcW0ZqbYUYcFFa4BCtHp67rCXQ3qdI=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJn2n4OZ3cRMgut038Q1Mvx+WnR34qt26aRSjxQZU2vjg 6FirXs7SlkYxLgYZMUUWSYl8jWd3mUkcqF9rSPMHFYmkCEMXJwCMJFN+xkZVrl1e0394/7u+RLu +RrXLfO4ZDZ3GN7cIROa8FQ8sjv1CCPD78WiQS1yNZrTC6Ti9OZz7YjK/sxnP51XNFzRTCM96w0 nAA==
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C3724140005
X-Stat-Signature: uqiaarrxoa16cn54jcce7ync5z5bbrgg
X-HE-Tag: 1765798763-656533
X-HE-Meta: U2FsdGVkX19dtXZfdgGNUp3c6zP0WOBeJbR8LctIDL7pcNzUtlCF3aP6JWuFJErD1DdeWEo8YxFGMADJej+Yj7scuauLrShGFX+iFTnqI1WPsuAaX/49d5tXeBE/ZXeOhyejq6pjO/WN4DIDn7klv1dkz6mz6Akq1EMC67GXhEv17nUYRRPRNkphhpTAwIy7KDYXUYXPG8AFDHU0jfd2jlqyiZfZOAPpOpgemkdrdsUrHQDBbN5339/RciZMThi/pEws36oSCpme13665zcitIip5zQKDLxjeX3vHUy58qmBdE6uoYL008VVMmgVkMYJTqxmbhGZOt9A12kjWwqGl8HcCKnR9snET71UuKZ2ODnNZ0S8+FLx3X6Ee8NHvvl4oRn9QKw6mFVU4O3zvaCK3qQ3BNsYZOKYJthFdCOXhke2K1L/xg0gJfkITlaD2CIei7faYZjm6reAb2/MEhCU6FoZlQL5Nt081YAoBFMJCtDoBIk7j4DGpXL3kJiaBGfqpoZiM0pKVc0IX+QQazl2E8Z5G9Wy7TGTk7zDYkjseLtsSf39cwnzARtdxW/FrHgvehdNCRoaTajGAKkIShHKOSVP4c1hxJkNCTd3D4ibn6HXnsyxRIfYTFMBK1ijYtdOCLGtnpvHZI/KErAvJcAXOFAKWNqh8XU3stHR799X3aeTdaDWG0iTgexQYcmRE7OJaGPR0zNHwRLslI2IkaY3TahyJEq+P+e6qPHjFt3BtSFNbavtO4Peq5q/EXBnhNeik072Koq0GqJhfkpWvdHgqt6+FICJhRouQljV93TnPMi7wNS8Su8W8war9sQ/SwNPdNqszqj3Lf/1mLWo0ixLviIyR7f70yQataZ3WDP/p+hVhGQI7ru1hIfgJIg/5HtfCQTKgN9s4TJWWblTX9kkvVKC7SZCJhjbHIiyNwP3CY2yBPORjq5B09o+2ZZWu9uT5pyDmTakxojNLT4wa4y
 m7MsdOe6
 kqmV8YPUmfzS+sSM5tu47eD3TMKX8tMPu7Nn0a64tsu/bu+8nptRZiIscZeARFyxAf4KmbkERyMxFIr3KeA0AXYYNQbCF1PWed21N6xVUH/0irrE5VTfs21k0wy8ZoNpCXjev+rmvO/8u1clMafJlkolC4bQIXMOGX4NGD4vv8iHVvvWHaqWWarfPt+AK0oivMqtWOqsvPZUJfiOWpkp//YVCcAUcTStl2OHOpWQx8jDrgWVQ56tHPN7uT81tJAXsVYV32IjARX1jziF6pyM2tGz2ppluZ5W3agq1D4w63aLt23TA1mIJ0Uzhe77+DYqS6JWQdGDKlSrTKxPpXQfAUoyH6C8RBBsSoTERPFj4IPbP+czp+Uq2tgZkHvGQToxL55AFyl5Jaht/dFh7j825MEUEnQ3jJI58899vFIMX5Cm2Bl7DGI0BGBQu3KbwCF7R1jz62MDoF+hUqQc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sphinx reports kernel-doc warning:

WARNING: ./drivers/gpu/drm/amd/display/dc/dc.h:2796 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
 * Software state variables used to program register fields across the display pipeline

Don't use kernel-doc comment syntax to fix it.

Fixes: b0ff344fe70cd2 ("drm/amd/display: Add interface to capture expected HW state from SW state")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/gpu/drm/amd/display/dc/dc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 29edfa51ea2cc0..0a9758a042586f 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -2793,7 +2793,7 @@ void dc_get_underflow_debug_data_for_otg(struct dc *dc, int primary_otg_inst, st
 
 void dc_get_power_feature_status(struct dc *dc, int primary_otg_inst, struct power_features *out_data);
 
-/**
+/*
  * Software state variables used to program register fields across the display pipeline
  */
 struct dc_register_software_state {
-- 
An old man doll... just what I always wanted! - Clara


