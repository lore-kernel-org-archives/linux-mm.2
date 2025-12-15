Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 811F7D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00266B0024; Mon, 15 Dec 2025 06:48:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD8326B0028; Mon, 15 Dec 2025 06:48:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B511B6B0029; Mon, 15 Dec 2025 06:48:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 97C556B0024
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:48:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43EFE138C11
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:48:47 +0000 (UTC)
X-FDA: 84221533494.24.FBAC99F
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 38F464000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:48:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fovlq+0X;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765799325; a=rsa-sha256;
	cv=none;
	b=HIH/a7nfitgLUfbG/EORI2CqP7TN7B1ANh5hk0RKbKmYMtNiGTdsug4d15QeHvbxPV2fF9
	v44W3H4GGBF3YEmZwkrFHw7pONPEnXrDtgVAWsCZEc5Vs0s/4lSffT6ObH1CxstI6T0BcA
	BSyiq8RtC2yCG6IgcKPYJd72gl3oswo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fovlq+0X;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765799325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8E8ZSVvZ3A1H5XIeWol9WzN+P6GbKkkMDrw9AgBsXoI=;
	b=CxFU8yrKJdLiSVrx7KxdlrnLBEq51eNxczAqjpI8epHwds2mtQo4DIrGO/6OU358XPq9Pq
	cUbSGgRnapZ0vl+E5t9R88DZXjyNcwnUNQyZBFFAF54op7Y1TbuEFAu0rTdi+Z8J78HGxm
	vhQvvQ7j9IAXRsbO9dEfxhHFI64laBk=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-34c363eb612so1719787a91.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765799324; x=1766404124; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8E8ZSVvZ3A1H5XIeWol9WzN+P6GbKkkMDrw9AgBsXoI=;
        b=fovlq+0XEAL6qfRc3gRCpX0ALkoZto3pHWbE0UmGfUu+FUxbANasrfggQxb4u0punO
         AI8PkO6IZEcv+stJl+EDNUCDfbrM69MmxKdtjvX/liAzI4pS45xxsPO/0VTdawIgr9fs
         iKCJ5fCQOqix0IAgalX3Dkole0s3Ux7S0T4im1lTSjXKTIQKjoI/bZgw39Tvvn2Tsyt6
         AFzNfAjD/U4KRAdHqnvCUPuboKiOg7y88JCcy3kcqp9OHrkgq1qSFWVfi/oPjsniDeam
         PU31ID8usQhVAC6BT/R53SGxlb+9CaQRg9roubwJZCKZJv/9Lt3la3biCnwXQKQCgdx6
         JMHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765799324; x=1766404124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8E8ZSVvZ3A1H5XIeWol9WzN+P6GbKkkMDrw9AgBsXoI=;
        b=g7ViyM2JPtpWskSB8AsBPIDeDR3FyzNLjB/UsAAxq7XJ8c7CZT7WpEVII2UWT6gO+8
         8qug2y9DjpydkxIOk4sf3Big//4S6/6nId2trN4X7ZWhfFE58Cft7LlQQyE0/YD/anMM
         xfzWveP+JcmShQgYT+q7wJZ6yynR+WRU0QbpNXvA8E+ODAQKOpqgFUnxhfbK+D+onURO
         NLPuQh7p6EWnxnoyJeWgDPhxk7su44SKMHMU0Hx6coNXLiegZ8oVQs3e6vRwh4+qxU9N
         DUrDsvG+vhu5fH6z/YE4bJiie/njldZyACUJNMG3Q8VUtHHp4y3YmPNZgq+0UH314XD8
         XPrw==
X-Forwarded-Encrypted: i=1; AJvYcCU+q10vUwI1gx3GQYpTsb+3EO+E24EOzOVKRDS7T7H0/rJm3JT7AbJgz+38LjyUjcEMXlEy4PT+rw==@kvack.org
X-Gm-Message-State: AOJu0YyNtol0scfNnEY+7Z69LNHQws4O22dlv156qpsdVe9Gqt5N64aB
	HfkIR6MX8zivCAIakSOWYRhSV7mpN6wKBzM5+Ij3Sb1AmzLdA13cxFRI
X-Gm-Gg: AY/fxX4BUGDGrF4l+SuDVHseS3N0t8onIKC8pXuvHYuGLzbZy6vGLpbgEP2/cleBRW3
	v84Ovi4KbFfTWuYa9UY2M50e0EyOYPHXr6BUXvSRufQpOo/ImUzNPnNj2Y54XOmrqAQfvHPBtJX
	VarQBu+AaSgImL6Fa6S7gGRf4688FIxrkjgSSzq1Y7fNNbkDo58io5sey93IzRnxrcrR/vBtoZ6
	SfeeM+Mm4t8ho824hBk+RlQEKrZE3pkiNMOFStpTR/h+jRlX830IHge3riz2B96Qs18e4ZlLqe6
	18PULulgdFXP7358cZcStSHUemH/21jKcVuowWXmkG+1E0TP7d0ZalOurU+3N5w/QGFDFZhTuNF
	jtHOWqOVBp13nPYmBGPoebfR9RbhJeobC/I0TkaYC7fS6ZqmdpXN66mkH+5xXJxDPjm/pXMacGU
	lUxx7rCiGJS34fnuZd0cvCIQ==
X-Google-Smtp-Source: AGHT+IFGPLXocnh0bsYmKlmGLz0U7nywcuz+b0WgS325GJYSuSdFNXAMsV5RYXPrF9APc0Uu9mi/Dg==
X-Received: by 2002:a17:90b:2692:b0:340:54a1:d6fe with SMTP id 98e67ed59e1d1-34abd6e705bmr9983263a91.15.1765799324036;
        Mon, 15 Dec 2025 03:48:44 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2c48bf7asm12763568a12.32.2025.12.15.03.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 03:48:42 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 711C5447330D; Mon, 15 Dec 2025 18:39:07 +0700 (WIB)
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
Subject: [PATCH 14/14] net: bridge: Describe @tunnel_hash member in net_bridge_vlan_group struct
Date: Mon, 15 Dec 2025 18:39:02 +0700
Message-ID: <20251215113903.46555-15-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215113903.46555-1-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=895; i=bagasdotme@gmail.com; h=from:subject; bh=Q9RPGjCwe41o18D04IVKznpQEFsNHpWb2BdI9cEOKh8=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJn2n0POW63OZ/vV5HO1nI0n8+fcu08SpWN+KD02YL721 ObASlnjjlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAExESpiR4Y+mRyzDrR2tsxn8 /5W9nMso8ZF7PQPXv0v9ETpvN1g+X8rw39Gt4w5/EGPqsSVHKrba3jn4a/bV+2uL/9ts2fkotu6 9MRMA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 38F464000A
X-Stat-Signature: 498figsbz65igdtouwjr67mssb95m3sb
X-Rspam-User: 
X-HE-Tag: 1765799325-499376
X-HE-Meta: U2FsdGVkX19eLEE5oc243cyckdtxH1pArdN/lqwJNtubHPfU/WSZAqaYQoWE3/OhorJPZ7fM6GoZOlaBle9iUwuliM9voqGprf8hrn22vpca5jGQMn/9chXbNwY2yIruHdwUuECBW6eH7rw7f7s98eEEAITfZIqOvRsMctAdToXMZfgHWjB2JjyvUbKC9WWJO6WqsRN9RUxAx5OjI4aSn77oDJweZ4Vbenw8uQQcE3G17a70MqHvrf5VvF9X2QGOXBxmwslTm+kXns7P9sSvdDY7LrVqfrLVrj8+dv5H/b2Brm7pHtee6sodrKzV2vY34qp3nIQ+XeyoT1rVXmUcnHUybEza96hr7oI7scSzL9WRQFul8G/RmY42kVOwikmESUms++r5JfmN1iQRiNt071U2fuug9B99WE2739UzmHjqdgYZCJSesxSkfzFxQF6Mfq+wlARV6clnZVW7+b6D/tb9y9QNQB/zpfmf+rlgzCe4N3XzMb8NSMKAlcTcUphP0LEv3BBokektqf4EaY/b9QCEPHVsNfCZvrXvqyIpG/wOsp2dgR3wkRxq7K3yN3AQV4cQ8+UOHvH6vhRxShlmCRCgRwcB5lJgCihQywIujco+3u1gXCFMHIH4FXXBzHl31Tp/9BxvFUpmVTnAuEa88KsMCzhCMh0YtIUe0LrhmYLT6/4S6A6feCZVlyiR3mxyiBffjei+Fpz7RK/YLkfxPeJPcQiov7Xav1QiHKRFVSWCgSTh7Hh74aUblEAfN7B3oc2IXff4IL5pa0KJHZ4i4t36yjqkd7CAP0cuydL7YppAEoqPJoGR3C2Zjpqw7ZWB/QVlywRM5gutIPtcmUf9+o47EwKKzHPMzDulgrCms8uFDMtzXPj1rTc6peQPwqy6AjPyivC+2UPSXcBqVOq2zVS7CRZetEvc5kZfyYvWO0fQDZ8Gtp8Rm58MVTtds/hjDY+vdvYghLep5zjn/za
 Myxd/Cfh
 tsQVRP/Y0MIHMQQ4lgwgQ3rYSN+y5NaG6fWLOomuaZKLmBsZEQzGgsZQ+nNbROpxQR2tpa9y/khrcYBKnNxCL0goLhP1rUcuDZ89ce2z7hZjbXrEKveqphzOwdlSp5QScKR+5WhtfuZmI1H4S+WHNv+qQei5oFKU0mvMBnch6LF7OJAniSoFUi2hDCUMQDRxQ/dNLFP49DcSRQc4otb6wF4W6R4Oh4UPqJ4bcC7ZO1YIpPWT73du+6nMppMtrB9QY1wnnFOmIiMVM8sBF7DSMU+c3MviQbRkM2d6mc9/UIOpWezUFWOamY1+wbUg435z50dPbZIvhOYp9uQx+zU98hC4sfcIVqjYcdVpQkfnq72Vt95RO2nhfVXwLWBW2hqSpvCvoaqbVzTDBmtpZkNSxfW5NSskOpDYrx2Q83XBv5HflF0TKbjOzUK44TloRzMT1U1YUQEIjPalaqII=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sphinx reports kernel-doc warning:

WARNING: ./net/bridge/br_private.h:267 struct member 'tunnel_hash' not described in 'net_bridge_vlan_group'

Fix it by describing @tunnel_hash member.

Fixes: efa5356b0d9753 ("bridge: per vlan dst_metadata netlink support")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 net/bridge/br_private.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7280c4e9305f36..bf441ac1c4d38a 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -247,6 +247,7 @@ struct net_bridge_vlan {
  * struct net_bridge_vlan_group
  *
  * @vlan_hash: VLAN entry rhashtable
+ * @tunnel_hash: tunnel rhashtable
  * @vlan_list: sorted VLAN entry list
  * @num_vlans: number of total VLAN entries
  * @pvid: PVID VLAN id
-- 
An old man doll... just what I always wanted! - Clara


