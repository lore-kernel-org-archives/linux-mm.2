Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6EC5D5B16E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6076B002B; Mon, 15 Dec 2025 06:48:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621346B002A; Mon, 15 Dec 2025 06:48:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F736B002B; Mon, 15 Dec 2025 06:48:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4FD6B0028
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:48:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02C271A0166
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:48:47 +0000 (UTC)
X-FDA: 84221533536.08.1F4CBB6
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id EF07A4000D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:48:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dEajFHf8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765799326; a=rsa-sha256;
	cv=none;
	b=51u7/GuHhxpzvbecqlvrHGTnpdNI4ZMUzpVPNOLPEsNupokqXQWZGQ6+ELb4I0KA7kuAZA
	sbp6vfy6sC27bus1YWqR8IsltuoSPSRXDNCbHyddPdURENxaYKQTjcovz/BUOzS5FEw+Bx
	SOu7KQp54AuDf2gNpxAc6K21CZbhG1Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dEajFHf8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765799326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPi/WFWmImBnVQgsxNvJvJyvieXM1xBFzKoWis67Gg4=;
	b=xGK5KJz6VTlCZsRkq7LRenMLKCCxIXaKrWvf68AR6+JvUegvOD8EEpG2XyfZa1ySSlcf7V
	u3KaXpF0O0ohVuJtLk9l1+6zcFVA5gYrl6B6I8XVDb/TM8ntyJQGpoRPf1m7PC6so1PnmM
	Daol3eIUIXw+SPQyteYhIDykss6dIiA=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34b75fba315so2739093a91.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765799325; x=1766404125; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HPi/WFWmImBnVQgsxNvJvJyvieXM1xBFzKoWis67Gg4=;
        b=dEajFHf8VNHk8RNzNGQ6utUE1qKQCAaDK+33NyVqOgwDRRUfpzd4AFGxHwolIb8Seg
         hZakddBGRUWqogSJnrcs8pFRKnKpjZoBZAGxq50zj/BO1N3MZpDFkBRIx0YlqtjnGSfk
         fIVVULRym1tYx5cnbZEKdGeJ6dfSrNwrZTKxRB9G1Fpj5wbVMvmupvtG8P9Cvp4am3Mt
         WMG4iCaTIEhkLY0TZOSn9jAErxDNdIsSU2qXS1zwpiXd278UfzOQXXcyd82B09CRGUMk
         FqA84wjlTWZ8MvZkdT/Cvo8ZEeLkT03ccohpBwgHSvTI93wKMRqpDZtd7a+qLlWDx4t2
         SecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765799325; x=1766404125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HPi/WFWmImBnVQgsxNvJvJyvieXM1xBFzKoWis67Gg4=;
        b=M6CWUk15ccFeQPvxgWjmJOmJsw1uplVYdAlnFAKb60Kkggv8wqE119nLHECCrLrl9R
         5IWz/fVzAUUwrzUczECXQueeD7TnenswthgQ7nYgC3GMq3wF6keLU8IH0Gf6AYegz0XW
         zhECBx1nNxRbEdJivIC1Ll2DQjGCFo4CIF8HzTrQ/fmBv9GxRL487Txm/vM+vT5GN0GS
         ThXSnzDOzLnxo+j5MiEux2HjZWX+MrO8rERT81CK3i+dyfkge05JUudtvnDxsvm/ZMN5
         NyFsLtMFTMh1sSJv0ndRCVdflxmnhEAmW6eF7WxI7xlH+rrfB/6DBDmeZD6JevdXTZH+
         txzg==
X-Forwarded-Encrypted: i=1; AJvYcCVnVGaJfl6m+zR69X/dJjmr2jPgEll5X028sIQdOYtn3NtsFx8ebNXotcC3UCczJCXJgeQcU0OtzQ==@kvack.org
X-Gm-Message-State: AOJu0YzppL+YUXHD79WgUkSDap1pVi0gu9+8lB48K0VX1dsD1TZG2sfn
	JhW8nkf4LLNjCUrSAqvxGwmWgRIHXLpJS8bPmfoW9XLXP3H/UfQMTwGu
X-Gm-Gg: AY/fxX45qJGMWyu8uE5QTvl7D3+Lv714Z82ludNYFSrli8q+9VkCSX2Txsyj+EGSp02
	l7HEFCL4hub10V/TK6AZDqIXa96yctIMo1c52ZxS+S/EkNxrV3CZcko7scXs4XtsMTF/q1WEvG4
	KW/oRTUQrr6LJOkf28V8OgNYNxrM7wBzSWDIV6NfK9xNAI9D0ygD4QBY2ptNln7Hm36XTLLiGkw
	HLm8awH9mydWpua/YU8/nvRzxJVJ1m7Dnfl/Ie3ODmFEvALPS5OboiCfRVD14DEbfNPESceYCmS
	/hAty0IdlQRiSOJottIErUhX8fwLGI4AR9kPjRou/xSbhRetTTbvNd73RqbsSRI5I+R0y2LH2ZN
	2VEk7yJpJpxiQmvx6xWBLAKzmNbu15b8wtEB+rBJl9WegZ93Lxos4X7E+S+E2MYmo4jfKPopzXg
	zmQj+G2j4YFX9E1FSb51J8fg==
X-Google-Smtp-Source: AGHT+IHySr1buuGxwyvRmyNwB1yX2aGVZnCno4j9FG3NSChYg8gy/QOhSf79+qyZQv+BzWWdtgvcAQ==
X-Received: by 2002:a17:90b:388a:b0:340:be40:fe0c with SMTP id 98e67ed59e1d1-34abe4a6b3amr9032481a91.36.1765799324639;
        Mon, 15 Dec 2025 03:48:44 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34abe3ba59bsm9003471a91.7.2025.12.15.03.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 03:48:42 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 60C6F447330B; Mon, 15 Dec 2025 18:39:07 +0700 (WIB)
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
Subject: [PATCH 13/14] drm/gpusvm: Fix drm_gpusvm_pages_valid_unlocked() kernel-doc comment
Date: Mon, 15 Dec 2025 18:39:01 +0700
Message-ID: <20251215113903.46555-14-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215113903.46555-1-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1611; i=bagasdotme@gmail.com; h=from:subject; bh=j4BXJJMKUhATWUahdKX0lx9i399WYlQDn9Ep3/iweMY=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJn2n0OumS5gNW5/3GqYe0vV4BnvxdVlFyqnrRPWP9PpP u3FMcecjlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAEykPJ/hF9Pft9/+BqzKa/W8 rdg9vSMz5a6N4PnTByKYzgTJnWZ/P5Hhn+aKvLS4vrtB9w7NNb77cZZgzZ2+T776O+w93L/xls2 5xAgA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF07A4000D
X-Rspamd-Server: rspam03
X-Stat-Signature: mya8kpjwa6kon4heiwcsx4yaq95k18aw
X-Rspam-User: 
X-HE-Tag: 1765799325-145585
X-HE-Meta: U2FsdGVkX18PsWa+3kFOoD2YguFBqsulPOKmy4GVCHmQe4DEe55o8Wbe9ojGJweMOqC9OkiipQJvGHtmeWTt05b36PPRt9mnyNrjyuNKxoC4FEso91/U2MKGKQBLDrSHJ5ibU6/kBp7upXGZk0Y0FCYX2N1psuiejHqmhEjVgL0IABG/weoL5XN2uBf0BC4blSZigw1+PGvJZJssRYtI4i56fuwq9hDAbvLd+ChJFg9D1hEHL/n2+uKjIewQuSzVFt6aPM8NROdGGLJqlBOVCatx1+IhOyneHwNYf7CqHdDBdvAqnkDgq7u/HfInUsQxS83H6VmY8n1oqR3vl+U/s9KBah5HNixUgfw1F45ZyjoNMd4CKiJvkUx4hAmCfiCX4plFOsvx0UhF6YbQajjmCsz3Ut4IYg5XiNwoEdfmPxT4eAnGnFTtIOeTVOFdANSMOI+cJC4lZbh0ktgOh9D6/YMReI3U7v61TUrOmZeL3lG9+zs8DqvCbht6btkLxVtW+t8Cy5rljHxkf3nOwM4rpRdwtMzjwjSJ6IdGjucx/eTTPmT/Rf2mctrm9Jkz03l1jy14VNLozBuMf+a5RUPqeKJoNYP5Aj3APClE+Kt9rHX3EFVx5FxnPe5aXdpXaEPM1ocmLXhRYx9EoBuMMEf0UEtdW0OZHpE8/BuKVcwOlsBX1Ts3NMkjHjPLFc0uWeHALJtEiWvwpPlEUhTFwMuTQlw6X3KSowHzHEOo9tiSkHoYtWnWPBwaxuhDogf/Ng7bb6QRzxZZaOZBmtPVYIpxQtgnDwEsXnZTjqnJXS1FGoQ3qS6NlJAFfDHuqL0Zk3nhes1fe3frNa9ZcvqqcSJyGhTaD6c+pW0wK0K5gb0h9kNWL3URyoeuVH8GjBSeOJwcvTY+66kx0GHcAsh67OloBVFKv/PNp05rMpCbHmYNSnSyBMJOazvBdUMWgHiRU+Kf7K2W5GymLdrJiaYxFLT
 CZ4WY9ju
 4bFKK3QXVsUonZuWuPsXnwpQGzNsNu3ozCMkj0X3Jdu1/qde9PVj9RicPqVWlj5OuPg7ti2u673o5FxymlxWJMlWPif9zi5qZdMSC5fk3fxHtDM0q88ieGPAIfD7BZRFUiMU50JbjdroGpFHUBk46IHxjjm6LO5aa3sQ/qHGbbMxa3ikBF3K4dVgBtUwWxnasDukW7yZMO0q57cmUO2L+t62rUO0HbUlzl9QvjQ+phxkRcC3HRmd2QJDbllYc+rs4t2By723azLHcrZcXDnM/uD8M5BV+tMeNtfuerqbhWCjlm6UAuiTy+XSAXFvv70GOb38qm9rFtlTOex4YK4mN+KDk8BQkqT3kD3R8Dj4ZzK4JE0dmZnAKPnW8OC6Zsnfsx75BxkrBZwjCogYOlEyXV7OU4AH73S3WqxwqP2rOosnTLr/ldP9ZDysym917TzzZ4BdEOqGmAsp9/Z0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 6364afd532bcab ("drm/gpusvm: refactor core API to use pages struct")
renames drm_gpusvm_range_pages_valid_unlocked() to
drm_gpusvm_pages_valid_unlocked(), but its kernel-doc comment gets
stale, hence kernel-doc complains:

WARNING: ./drivers/gpu/drm/drm_gpusvm.c:1229 function parameter 'svm_pages' not described in 'drm_gpusvm_pages_valid_unlocked'
WARNING: ./drivers/gpu/drm/drm_gpusvm.c:1229 expecting prototype for drm_gpusvm_range_pages_valid_unlocked(). Prototype was for drm_gpusvm_pages_valid_unlocked() instead

Fix them up.

Fixes: 6364afd532bcab ("drm/gpusvm: refactor core API to use pages struct")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/gpu/drm/drm_gpusvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index 73e550c8ff8c98..fcfbe8c062bf6d 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -1216,9 +1216,9 @@ bool drm_gpusvm_range_pages_valid(struct drm_gpusvm *gpusvm,
 EXPORT_SYMBOL_GPL(drm_gpusvm_range_pages_valid);
 
 /**
- * drm_gpusvm_range_pages_valid_unlocked() - GPU SVM range pages valid unlocked
+ * drm_gpusvm_pages_valid_unlocked() - GPU SVM range pages valid unlocked
  * @gpusvm: Pointer to the GPU SVM structure
- * @range: Pointer to the GPU SVM range structure
+ * @svm_pages: Pointer to the GPU SVM pages
  *
  * This function determines if a GPU SVM range pages are valid. Expected be
  * called without holding gpusvm->notifier_lock.
-- 
An old man doll... just what I always wanted! - Clara


