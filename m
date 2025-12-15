Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2153CD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BB5B6B0012; Mon, 15 Dec 2025 06:39:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945136B0022; Mon, 15 Dec 2025 06:39:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7086B0023; Mon, 15 Dec 2025 06:39:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB3B6B0012
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:39:22 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2AB8186732
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:22 +0000 (UTC)
X-FDA: 84221509764.08.26618E3
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 25C101C000F
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:39:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LSuYQoTr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765798760; a=rsa-sha256;
	cv=none;
	b=p87/vmVqRapnXrktSsUKP9/DMbDSGsRlq1p2BUIPTfmZTtvs2zQYEABouCVGWnkP+hGIh8
	WRmjYxYf1oWRgT1TR5wpZ8rPX2YC8eBOsxuwSBZu7NbMiXXF9OzYoE1osQD2Sm4Ulm060K
	uDcxJOSbM3chDGfIVJOVm+UHlOY2/G0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LSuYQoTr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765798760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XhdWc9MI61x0CV5VCAtcSDjXy8TDKlNky9k0yGxBSF0=;
	b=eSA/t4GBosSzZ9TYxEsNdYG/akqoQXihyYuk26zNa5XSgDou9S2+ssUFADHJBFLM8JwPY/
	Vkxl/pUjYkKBZepXGxPnBfcMFUHjqZC7R8gJH97nEXUxRXKI0HlY+VxaXhP/fntIk2Va3U
	nVYn2cjahOtSAjaLOh2q9EOXzO587lc=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7b9215e55e6so2341271b3a.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765798759; x=1766403559; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XhdWc9MI61x0CV5VCAtcSDjXy8TDKlNky9k0yGxBSF0=;
        b=LSuYQoTrm93U9lin0vOJ4pr2BuqiZuObAs/dMmv0QpEl1t/5rYWx84QL5B0dFCyNkz
         m2GogiI7vxUlV8F9UdKVfOCIa2524Y3CgpU5loUA9LDDHGBdZ6DxhhzJ7rGPMaf/OBP/
         zx6Cq5QcKtV8213qW1JGJ5vRnHtK0eMPxsUWy5Rx84mcm/LrFq1Fz6snDJyByoE6tkL9
         +tfE048wjqumOzLWKSY+ss0EiwOD1Q9CtWmyWhbXx3V+Bzen1NIVWOhZ6YfFMULu1BuD
         SL2X1ACrJyFHgYBo6SEAsl1tUF8SmY4OXDG8qRFnUC0d98wGstiL6bLvRdcv24sxw0YA
         1jWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765798759; x=1766403559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XhdWc9MI61x0CV5VCAtcSDjXy8TDKlNky9k0yGxBSF0=;
        b=gsefy18LbbTMnStxioN+O2IJ/qeK3kv628WaCHQRjyl4o0N3NfrP8zWu2k64gZk/wP
         SFeMR8nPWGaNhKgiN4pIFYYQwYmFLhC0MS4LUHndSrMqLA4QR3H++iutNpH6xJqfCWzk
         WJu1CzltZPuIyKYLNXzTFZjDcMLrz3TIgvINl70jKyQhEjSqCd1wTU2+zRJQCb04bvyE
         G3RtP5n/2eh/0yEL08EqWss49ddTgXUuH7uWiNN0zToSwVYxv0e6HbqRwz27bsMNyYSB
         QIxEpB5iZXo7GdoAICQ9+Z45J5QrK6qMK7QW4i/2lB2eMHLTffax7omAquubAQionhHB
         XkwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOorSplBnet82wPXSNhBZyPKnbi9q1aUdRvJqD5ztz1KApM/gReCHzRj6Afg8cbTMeVIw28qAaxQ==@kvack.org
X-Gm-Message-State: AOJu0Yzf0uCtpyz88ETuMBkAs/QMHj43Mb/wJVKQ+SYJpb0FL35X0aO3
	UMIrLxYKeBo44ts5FoEhw49j5F3clWNQlCEIqf8LMhqoh2/nCSAZl9vv
X-Gm-Gg: AY/fxX4N4ZzIAycJq7tMmCuAwhp6KLBTehQ1DKt2axkqLyR4PuuuV51oIiyAKEByyC7
	jlobPviZq9kp3unsv9d9okw7oQxZDM4Wo8kpQyZ8ks5peTP/gGOryEpGG6cPVAsuGBSxAgMnPq/
	PCQX/SmIuo58BTYDFFcxFMuJJRBpYV0b0tNmsY1bWxho7rrpz1G0/M1Nkxg9jQsjaTIxPBof9uN
	YbXVDrSFnDP/MNIhCB1YOgBZf4MXEwB8G19DgsY7ENn1tO00+AUzqQcvWU+MjMQ5MybbWpXx813
	bMk4QDw23Cn68ZN+RQmKNS+9CiQFLZuzx+p7BushXRwAFLO6NT6kDjg7Xsa04mlm2XtcmabsM38
	UWTCTTnDD+7OYDY4IN2taJuay9GRcBE+c1dU+GYT8O2widUZXV+cZj3rwqBJ606qnSC/vJHSSp0
	wAa9A6CikuPFY=
X-Google-Smtp-Source: AGHT+IEml9qI+VrrnmRfetIj/W3ZZs/y3fpGJeeY3YNSfL1Lp+Ud1G2wHo5sReKCb7zM9fF8T1soPQ==
X-Received: by 2002:a05:6a00:4211:b0:7e8:4587:e8c8 with SMTP id d2e1a72fcca58-7f669c8ea65mr9926386b3a.59.1765798758916;
        Mon, 15 Dec 2025 03:39:18 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c566c7cfsm12487742b3a.67.2025.12.15.03.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 03:39:18 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id BCD48444B396; Mon, 15 Dec 2025 18:39:06 +0700 (WIB)
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
Subject: [PATCH 07/14] fs: Describe @isnew parameter in ilookup5_nowait()
Date: Mon, 15 Dec 2025 18:38:55 +0700
Message-ID: <20251215113903.46555-8-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215113903.46555-1-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=946; i=bagasdotme@gmail.com; h=from:subject; bh=ZF9oIk+6VfTU18bKiromuOjnT5V3QoMoKRjEOTmh6aM=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJn2n4NPZboGqi8J0lGIEPx09J91+O5zYvcmVc9uCnNeq KyqY9/YUcrCIMbFICumyDIpka/p9C4jkQvtax1h5rAygQxh4OIUgIloczEyXFE5FS25V7U4nF3s wsyajN23tv7S0jlgc8jW4LrtPJ7fvYwMd203HZvEp7U3/4W850Q53mn2BsnZf49w2jwWklnFefM GBwA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 25C101C000F
X-Stat-Signature: h1aokpy6gnxaopnjkh5jtna84iitqiy7
X-Rspam-User: 
X-HE-Tag: 1765798759-145723
X-HE-Meta: U2FsdGVkX1/ji+E4qRLkyMdwG0KEoGIZaao2yf6Caiusrq+jm5q3mcOZ+wK4ReyQHxwAxaLRbCYKknrgxoEdAaH1SoX5bRm3mNJOF0f7ueHIXDEzHqyFaGzpZk8qu7/E1rIsCibqq2nA293ul6FLxjl7vI7QdqfcUXlwGsi0Bs7UbCg7iwHnkFUX5oP+uc9U7vrWV6VlqSF9+zUIijC9ix/+TMPxnUbTmvd4mR7dZofw6U5FmRQFZExzasErHNK0diG2fPax+Q+o2uKtIyJIrJ8x1ERAkbhDYHNA/hlPM1T3nTkc/zypBEyTtf103Bqc5KXvdogRn47k6GoXKRZn6N7HPpSrRFGJQhoBSW+qNGwv1oNyuGCstR1PgqIlsGTUoAfSXc3Js6BRxmoEA9ikggV3CeAtC9XeUq/IR+deR6um4UFcfeXBsnf0B5VxVfil6D2HKIOqkSn7UsJ9pCeuTmzjDEnlHamhb1tyGMjCmhxmkZvWVUMCi8MEq4M/DRbvNKSMYZAOeK1UD+4Kh0LicG6gAbx7mpEw7HyzUmvcDwNPyHKgDoVr7wMulAMjRWFZHJXegQAYmiq1jQ9tzZ4fLkB7NZ2F8vHi801qe4yEMKIFolOP03KhCdDqfttFh3tv1hoq5TQoCNQ48UgYnzBL/y2vOnZGqPqQXYqTIK2+fIBMe2XGJHzDhzzupG1ioVFwnSggh7xlAJZg1kaaTIe8uO9QHx7TNEBpQm8tuW41HVUeAYlbTb6kRVUoMJvzHjdoLM/kKFoYcQGApWQ5MMjAjEP2+QBRS1yBFw/qlFGWWD6pxinRLyyl74jSshCWg6BCxDLMkqYKDw2IXOXpgP4AEESrQn78Zd3+6fuzN6JHgl41S1puA3aNpkT4SLB94oNQKgUOomMqfPng4vjRDgOOU+ez6ZSGPZKJWZtQ7jEQLh5940Sx41NTLGufdEle8v9+42RUln0ijkbEiEWNq/1
 d6iXV/m6
 atrK1AfJNGOVIzEkyq3risHeV1ectZStj1VqDBdlh2sMjViODf1vEilOiBBIo16FuA9XyisqLkS1miBtngeN6fvOm8dnwRvJK8vCvnDOlYASO/1zqkZg4EQUzikpp6yx4zEKBCW8x0MZ09YORwF+6wqdZNPuWICdguYoh/AGgkuvGTp8raOjKXz9XQSU4yip0nuE9LzKibuDx9jSyjFum/Plx7OV3aFELDrF1u8eS21qlnqOvzzTJQh+L51b1I1lppugay2Waq6J3F7hyynhvaMUfcSnypXvt8TFRO0E6q4V353H1zacEZcwWzxee8OgAzAfLyOqP8CW8uQ2c4x6AqXh0DvbLxXlKkn9tvuDQetDfGGjV5jGs6fWF6rn8Io48P0PEJNGtcRBhyGy3eYtwNCFLG9Qn0h9goYLvtev6fkNZ7xA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sphinx reports kernel-doc warning:

WARNING: ./fs/inode.c:1607 function parameter 'isnew' not described in 'ilookup5_nowait'

Describe the parameter.

Fixes: a27628f4363435 ("fs: rework I_NEW handling to operate without fences")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 fs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/inode.c b/fs/inode.c
index 521383223d8a45..2f4beda7bb8841 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1593,6 +1593,7 @@ EXPORT_SYMBOL(igrab);
  * @hashval:	hash value (usually inode number) to search for
  * @test:	callback used for comparisons between inodes
  * @data:	opaque data pointer to pass to @test
+ * @isnew:	whether the inode is new or not
  *
  * Search for the inode specified by @hashval and @data in the inode cache.
  * If the inode is in the cache, the inode is returned with an incremented
-- 
An old man doll... just what I always wanted! - Clara


